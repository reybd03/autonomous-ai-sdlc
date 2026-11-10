# Qwen 2.5 Coder 0.5B Fine-Tuning Instructions (sub-1B)

Environment: CPU-only machine (no NVIDIA GPU), Python 3.14, 31 GB RAM.
Base model: `qwen2.5-coder:0.5b` (pull via Ollama, 0.5B params, Q4_K_M, 32K context).
Target: Fine-tune with LoRA and import the merged GGUF back into Ollama for use with opencode.

## Why this model

0.5B parameters fits easily in CPU RAM, trains quickly, and is purpose-built for code.
Best for: simple, repetitive coding tasks (boilerplate, small functions, refactors,
data mappers, API client stubs).

---

## Phase 1 — Environment setup

Create a dedicated virtual environment and install CPU-friendly training packages:

```bash
python3 -m venv ~/qwen25coder05-ft && source ~/qwen25coder05-ft/bin/activate
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
For a coding model, focus on code-related tasks (refactoring, bug fixes, docstring generation, test writing).

Example (`train.jsonl`):

```jsonl
{"instruction": "Refactor this Python function for readability", "input": "def f(x):\n    return [i for i in x if i%2==0]", "output": "def get_even_numbers(numbers):\n    \"\"\"Return a list of even numbers from the input.\"\"\"\n    return [n for n in numbers if n % 2 == 0]"}
{"instruction": "Write a unit test for this function", "input": "...", "output": "import unittest\n..."}
EOF
```

Create the data directory and a starter dataset:

```bash
mkdir -p ~/qwen25coder05-ft/data
cat > ~/qwen25coder05-ft/data/train.jsonl << 'EOF'
{"instruction": "Refactor this Python function", "input": "def f(x):\n    return [i for i in x if i%2==0]", "output": "def get_even_numbers(numbers):\n    '''Return a list of even numbers.'''\n    return [n for n in numbers if n % 2 == 0]"}
EOF
echo "Dataset rows: $(wc -l < ~/qwen25coder05-ft/data/train.jsonl)"
```

For meaningful results, aim for at least several hundred high-quality rows. A 0.5B model trains quickly on CPU, so you can use a larger dataset than the 7B variant.

---

## Phase 3 — Fine-tuning script (LoRA on CPU)

Save as `~/qwen25coder05-ft/train.py`:

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer, DataCollatorForLanguageModeling
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from datasets import load_dataset

MODEL = "ollama/qwen2.5-coder:0.5b"   # or "Qwen/Qwen2.5-Coder-0.5B" from Hugging Face
DATA = "~/qwen25coder05-ft/data/train.jsonl"
OUTPUT = "~/qwen25coder05-ft/adapter"

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
    r=8, lora_alpha=16,
    target_modules=["q_proj","v_proj","k_proj","o_proj","gate_proj","up_proj","down_proj"],
    lora_dropout=0.05,
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
cd ~/qwen25coder05-ft && python train.py
```

---

## Phase 4 — Merge adapter + export to GGUF for Ollama

Ollama runs GGUF, not PEFT adapters directly. Merge the LoRA adapter into the base model, then quantize to GGUF.

Merge script — save as `~/qwen25coder05-ft/merge.py`:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

BASE = "ollama/qwen2.5-coder:0.5b"
ADAPTER = "~/qwen25coder05-ft/adapter"
MERGED = "~/qwen25coder05-ft/merged"

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
cd ~/qwen25coder05-ft && python merge.py
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
python3 ~/llama.cpp/convert-hf-to-gguf.py ~/qwen25coder05-ft/merged --outtype q4_k_m --outfile ~/qwen25coder05-ft/qwen2.5-coder-0.5b-finetuned.Q4_K_M.gguf
```

---

## Phase 5 — Load into Ollama

Create a Modelfile:

```bash
cat > ~/qwen25coder05-ft/Modelfile << 'EOF'
FROM ./qwen2.5-coder-0.5b-finetuned.Q4_K_M.gguf
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
cd ~/qwen25coder05-ft
ollama create qwen2.5-coder:0.5b-finetuned -f Modelfile
ollama run qwen2.5-coder:0.5b-finetuned "Write a Python function to reverse a string"
```

Verify it appears in `ollama list`.

---

## Phase 6 — Point opencode at the fine-tuned model

Edit `/home/alpharius/.config/opencode/agents/qwen2.5-coder-0.5b.md` and change:

```yaml
model: ollama/qwen2.5-coder:0.5b
```

to:

```yaml
model: ollama/qwen2.5-coder:0.5b-finetuned
```

---

## Reality check — CPU-only constraints

| Factor | Reality on this machine |
|--------|------------------------|
| GPU | None — CPU-only |
| RAM | 31 GB (plenty for 0.5B + LoRA) |
| Training speed | Fast on CPU for a 0.5B model |
| Recommended config | LoRA r=8, batch_size=2, gradient_accumulation_steps=4, 1–3 epochs |
