# Qwen 3 0.6B Fine-Tuning Instructions (sub-1B)

Environment: CPU-only machine (no NVIDIA GPU), Python 3.14, 31 GB RAM.
Base model: `qwen3:0.6b` (pull via Ollama, 0.6B params, Q4_K_M, 32K context).
Target: Fine-tune with LoRA and import the merged GGUF back into Ollama for use with opencode.

## Why this model

0.6B parameters fits easily in CPU RAM, trains quickly, and has stronger general
reasoning and instruction-following than the 0.5B class.
Best for: coding tasks and test generation (unit tests, test scaffolding, reading
error/stack-trace output to suggest fixes).

---

## Phase 1 — Environment setup

Create a dedicated virtual environment and install CPU-friendly training packages:

```bash
python3 -m venv ~/qwen3-06-ft && source ~/qwen3-06-ft/bin/activate
pip install --upgrade pip
pip install torch transformers accelerate peft datasets sentencepiece
```

Verify the install:

```bash
python3 -c "import torch, transformers, peft, datasets; print('imports OK')"
```

---

## Phase 2 — Prepare your dataset

Fine-tuning requires a JSONL file. Recommended field names: `instruction`, `input`, `output`.

Example (`train.jsonl`):

```jsonl
{"instruction": "Write a pytest unit test for this function", "input": "def add(a, b):\n    return a + b", "output": "import pytest\n\ndef test_add():\n    assert add(2, 3) == 5\n    assert add(-1, 1) == 0"}
{"instruction": "Generate a Jest test for this function", "input": "...", "output": "..."}
```

Create the data directory and a starter dataset:

```bash
mkdir -p ~/qwen3-06-ft/data
cat > ~/qwen3-06-ft/data/train.jsonl << 'EOF'
{"instruction": "Write a pytest unit test for this function", "input": "def add(a, b):\n    return a + b", "output": "import pytest\n\ndef test_add():\n    assert add(2, 3) == 5\n    assert add(-1, 1) == 0"}
EOF
echo "Dataset rows: $(wc -l < ~/qwen3-06-ft/data/train.jsonl)"
```

Aim for at least several hundred high-quality rows. A 0.6B model trains quickly on CPU.

---

## Phase 3 — Fine-tuning script (LoRA on CPU)

Save as `~/qwen3-06-ft/train.py`:

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer, DataCollatorForLanguageModeling
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from datasets import load_dataset

MODEL = "ollama/qwen3:0.6b"   # or "Qwen/Qwen3-0.6B" from Hugging Face
DATA = "~/qwen3-06-ft/data/train.jsonl"
OUTPUT = "~/qwen3-06-ft/adapter"

tokenizer = AutoTokenizer.from_pretrained(MODEL, trust_remote_code=True)
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

def format_example(example):
    text = f"User: {example['instruction']}\n{example.get('input','')}\nAssistant: {example['output']}"
    return {"text": text}

ds = load_dataset("json", data_files={"train": DATA}, split="train")
ds = ds.map(format_example, remove_columns=ds.column_names)

def tokenize(ex):
    return tokenizer(ex["text"], truncation=True, max_length=2048, padding="max_length")

ds = ds.map(tokenize, batched=True)

model = AutoModelForCausalLM.from_pretrained(
    MODEL,
    trust_remote_code=True,
    torch_dtype=torch.float16,
    device_map="cpu",
    low_cpu_mem_usage=True,
)

model = prepare_model_for_kbit_training(model)
peft_config = LoraConfig(
    r=8, lora_alpha=16, target_modules=["q_proj","v_proj"], lora_dropout=0.05,
    bias="none", task_type="CAUSAL_LM",
)
model = get_peft_model(model, peft_config)

args = TrainingArguments(
    output_dir=OUTPUT,
    per_device_train_batch_size=2,
    gradient_accumulation_steps=4,
    num_train_epochs=3,
    learning_rate=2e-4,
    fp16=True,
    logging_steps=10,
    save_strategy="epoch",
    report_to="none",
    remove_unused_columns=False,
)

trainer = Trainer(
    model=model,
    args=args,
    train_dataset=ds,
    data_collator=DataCollatorForLanguageModeling(tokenizer=tokenizer, mlm=False),
)
trainer.train()
model.save_pretrained(OUTPUT)
tokenizer.save_pretrained(OUTPUT)
print("Adapter saved to", OUTPUT)
```

Run it:

```bash
cd ~/qwen3-06-ft && python train.py
```

---

## Phase 4 — Merge adapter + export to GGUF for Ollama

Merge script — save as `~/qwen3-06-ft/merge.py`:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

BASE = "ollama/qwen3:0.6b"
ADAPTER = "~/qwen3-06-ft/adapter"
MERGED = "~/qwen3-06-ft/merged"

tokenizer = AutoTokenizer.from_pretrained(BASE, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(BASE, trust_remote_code=True, torch_dtype=torch.float16, device_map="cpu")
model = PeftModel.from_pretrained(model, ADAPTER)
model = model.merge_and_unload()
model.save_pretrained(MERGED, safe_serialization=True)
tokenizer.save_pretrained(MERGED)
print("Merged model saved to", MERGED)
```

Run:

```bash
cd ~/qwen3-06-ft && python merge.py
```

### Convert merged model to GGUF

Install `llama.cpp` if not present:

```bash
cd ~
git clone https://github.com/ggerganov/llama.cpp.git 2>/dev/null || true
cd llama.cpp && make quantize
```

Convert HF → GGUF:

```bash
python3 ~/llama.cpp/convert-hf-to-gguf.py ~/qwen3-06-ft/merged --outtype q4_k_m --outfile ~/qwen3-06-ft/qwen3-0.6b-finetuned.Q4_K_M.gguf
```

---

## Phase 5 — Load into Ollama

Create a Modelfile:

```bash
cat > ~/qwen3-06-ft/Modelfile << 'EOF'
FROM ./qwen3-0.6b-finetuned.Q4_K_M.gguf
TEMPLATE """User:
{{ .Prompt }}
Assistant:
"""
PARAMETER stop "User"
PARAMETER stop "Assistant"
PARAMETER temperature 0.7
EOF
```

Create and test the model in Ollama:

```bash
cd ~/qwen3-06-ft
ollama create qwen3:0.6b-finetuned -f Modelfile
ollama run qwen3:0.6b-finetuned "Write a pytest test for a function that adds two numbers"
```

Verify it appears in `ollama list`.

---

## Phase 6 — Point opencode at the fine-tuned model

Edit `/home/alpharius/.config/opencode/agents/qwen3-0.6b.md` and change:

```yaml
model: ollama/qwen3:0.6b
```

to:

```yaml
model: ollama/qwen3:0.6b-finetuned
```

---

## Reality check — CPU-only constraints

| Factor | Reality on this machine |
|--------|------------------------|
| GPU | None — CPU-only |
| RAM | 31 GB (plenty for 0.6B + LoRA) |
| Training speed | Fast on CPU for a 0.6B model |
| Recommended config | LoRA r=8, batch_size=2, gradient_accumulation_steps=4, 1–3 epochs |
