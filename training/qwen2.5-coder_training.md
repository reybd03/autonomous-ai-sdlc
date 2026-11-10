# Qwen 2.5 Coder 7B Fine-Tuning Instructions

Environment: CPU-only machine (no NVIDIA GPU), Python 3.14, 31 GB RAM.
Base model: `qwen2.5-coder:7b` (already pulled in Ollama, 7.6B params, Q4_K_M, 32K context).
Target: Fine-tune with LoRA and import the merged GGUF back into Ollama for use with opencode.

---

## Phase 1 — Environment setup

Create a dedicated virtual environment and install CPU-friendly training packages:

```bash
python3 -m venv ~/qwen25coder-ft && source ~/qwen25coder-ft/bin/activate
pip install --upgrade pip
pip install torch transformers accelerate peft datasets bitsandbytes sentencepiece
```

> **Note:** `bitsandbytes` CPU 4-bit support is limited. If installation or training fails, drop `bitsandbytes` and use `torch` + `peft` LoRA in FP16/BF16 (slower, more RAM). A 7B model on CPU with 31 GB RAM is tight — use gradient accumulation and small batch sizes.

Verify the install:

```bash
python3 -c "import torch, transformers, peft, datasets; print('imports OK')"
```

---

## Phase 2 — Prepare your dataset

Fine-tuning requires a JSONL file. Recommended field names: `instruction`, `input`, `output`. For a coding model, focus on code-related tasks (refactoring, bug fixes, docstring generation, test writing, etc.).

Example (`train.jsonl`):

```jsonl
{"instruction": "Refactor this Python function for readability", "input": "def f(x):\n    return [i for i in x if i%2==0]", "output": "def get_even_numbers(numbers):\n    \"\"\"Return a list of even numbers from the input.\"\"\"\n    return [n for n in numbers if n % 2 == 0]"}
{"instruction": "Write a unit test for this function", "input": "...", "output": "import unittest\n..."}
EOF
```

Create the data directory and a starter dataset:

```bash
mkdir -p ~/qwen25coder-ft/data
cat > ~/qwen25coder-ft/data/train.jsonl << 'EOF'
{"instruction": "Refactor this Python function", "input": "def f(x):\n    return [i for i in x if i%2==0]", "output": "def get_even_numbers(numbers):\n    '''Return a list of even numbers.'''\n    return [n for n in numbers if n % 2 == 0]"}
EOF
echo "Dataset rows: $(wc -l < ~/qwen25coder-ft/data/train.jsonl)"
```

For meaningful results, aim for at least several hundred high-quality rows. Because this is a 7B model on CPU, keep the dataset focused and not excessively large to avoid impractically long training times.

---

## Phase 3 — Fine-tuning script (LoRA on CPU)

Save as `~/qwen25coder-ft/train.py`:

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer, DataCollatorForLanguageModeling
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from datasets import load_dataset

MODEL = "ollama/qwen2.5-coder:7b"   # or "Qwen/Qwen2.5-Coder-7B" from Hugging Face
DATA = "~/qwen25coder-ft/data/train.jsonl"
OUTPUT = "~/qwen25coder-ft/adapter"

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
    per_device_train_batch_size=1,
    gradient_accumulation_steps=8,
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

Run it (expect slow CPU training; a 7B model will be significantly slower than the 4B):

```bash
cd ~/qwen25coder-ft && python train.py
```

---

## Phase 4 — Merge adapter + export to GGUF for Ollama

Ollama runs GGUF, not PEFT adapters directly. You must merge the LoRA adapter into the base model, then quantize to GGUF.

Merge script — save as `~/qwen25coder-ft/merge.py`:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

BASE = "ollama/qwen2.5-coder:7b"
ADAPTER = "~/qwen25coder-ft/adapter"
MERGED = "~/qwen25coder-ft/merged"

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
cd ~/qwen25coder-ft && python merge.py
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
python3 ~/llama.cpp/convert-hf-to-gguf.py ~/qwen25coder-ft/merged --outtype q4_k_m --outfile ~/qwen25coder-ft/qwen2.5-coder-7b-finetuned.Q4_K_M.gguf
```

---

## Phase 5 — Load into Ollama

Create a Modelfile:

```bash
cat > ~/qwen25coder-ft/Modelfile << 'EOF'
FROM ./qwen2.5-coder-7b-finetuned.Q4_K_M.gguf
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
cd ~/qwen25coder-ft
ollama create qwen2.5-coder:7b-finetuned -f Modelfile
ollama run qwen2.5-coder:7b-finetuned "Write a Python function to reverse a string"
```

Verify it appears in `ollama list`.

---

## Phase 6 — Point opencode at the fine-tuned model

Once the fine-tuned model is in Ollama, update the opencode agent:

Edit `/home/alpharius/.config/opencode/agents/qwen.md` and change:

```yaml
model: ollama/qwen2.5-coder:7b
```

to:

```yaml
model: ollama/qwen2.5-coder:7b-finetuned
```

Alternatively, add a separate model entry in `/home/alpharius/.config/opencode/opencode.json` and create a dedicated agent for the fine-tuned variant.

---

## Reality check — CPU-only constraints

| Factor | Reality on this machine |
|--------|------------------------|
| GPU | None — CPU-only |
| RAM | 31 GB (very tight for a 7B model + LoRA; monitor OOM) |
| Training speed | Very slow on CPU for a 7B model |
| Recommended config | LoRA r=8, small dataset (hundreds–thousands of rows), 1–3 epochs, gradient_accumulation_steps=8 |

### Tips for fitting 7B in 31 GB RAM

- Use `bf16` instead of `fp16` if your CPU supports it (slightly more stable).
- Reduce `max_length` to 1024 if you hit memory limits.
- Use gradient checkpointing: add `gradient_checkpointing=True` to `TrainingArguments`.
- Keep batch size at 1 and rely on gradient accumulation.

If fine-tuning proves impractical on CPU, alternatives:

1. **Few-shot prompting** — put code examples directly in the `qwen.md` agent instructions.
2. **Fine-tune on a GPU machine** — train elsewhere, export the GGUF, and import it into Ollama here.
3. **Use `qwen2.5-coder:7b` out of the box** — it is already a strong local coding model.
