# Qwen 3.5 4B Fine-Tuning Instructions

Environment: CPU-only machine (no NVIDIA GPU), Python 3.14, 31 GB RAM.
Base model: `qwen3.5:4b` (already pulled in Ollama, 4.2B params, Q4_K_M, 256K context).
Target: Fine-tune with LoRA and import the merged GGUF back into Ollama for use with opencode.

---

## Phase 1 — Environment setup

Create a dedicated virtual environment and install CPU-friendly training packages:

```bash
python3 -m venv ~/qwen35-ft && source ~/qwen35-ft/bin/activate
pip install --upgrade pip
pip install torch transformers accelerate peft datasets bitsandbytes sentencepiece
```

> **Note:** `bitsandbytes` CPU 4-bit support is limited. If installation or training fails, drop `bitsandbytes` and use `torch` + `peft` LoRA in FP16/BF16 (slower, more RAM).

Verify the install:

```bash
python3 -c "import torch, transformers, peft, datasets; print('imports OK')"
```

---

## Phase 2 — Prepare your dataset

Fine-tuning requires a JSONL file. Recommended field names: `instruction`, `input`, `output`.

Example (`train.jsonl`):

```jsonl
{"instruction": "Explain this bug fix", "input": "```python\ndef foo():\n    return 1\n```", "output": "The fix adds a null check..."}
{"instruction": "Refactor this function", "input": "...", "output": "..."}
```

Create the data directory and a starter dataset:

```bash
mkdir -p ~/qwen35-ft/data
cat > ~/qwen35-ft/data/train.jsonl << 'EOF'
{"instruction": "Summarize the code change", "input": "diff --git a/src/foo.py b/src/foo.py\n@@ -1 +1 @@\n-old()\n+new()", "output": "Replaced old() with new() to improve readability."}
EOF
echo "Dataset rows: $(wc -l < ~/qwen35-ft/data/train.jsonl)"
```

For meaningful results, aim for at least several hundred high-quality rows. More data = better fine-tuning, but longer CPU training time.

---

## Phase 3 — Fine-tuning script (LoRA on CPU)

Save as `~/qwen35-ft/train.py`:

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer, DataCollatorForLanguageModeling
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from datasets import load_dataset

MODEL = "ollama/qwen3.5:4b"   # or "Qwen/Qwen3-4B" from Hugging Face
DATA = "~/qwen35-ft/data/train.jsonl"
OUTPUT = "~/qwen35-ft/adapter"

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
    per_device_train_batch_size=1,
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

Run it (expect slow CPU training):

```bash
cd ~/qwen35-ft && python train.py
```

---

## Phase 4 — Merge adapter + export to GGUF for Ollama

Ollama runs GGUF, not PEFT adapters directly. You must merge the LoRA adapter into the base model, then quantize to GGUF.

Merge script — save as `~/qwen35-ft/merge.py`:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

BASE = "ollama/qwen3.5:4b"
ADAPTER = "~/qwen35-ft/adapter"
MERGED = "~/qwen35-ft/merged"

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
cd ~/qwen35-ft && python merge.py
```

### Convert merged model to GGUF

Install `llama.cpp` if not present:

```bash
cd ~
git clone https://github.com/ggerganov/llama.cpp.git 2>/dev/null || true
cd llama.cpp && make quantize
```

Convert HF → GGUF (llama.cpp provides `convert-hf-to-gguf.py`):

```bash
python3 ~/llama.cpp/convert-hf-to-gguf.py ~/qwen35-ft/merged --outtype q4_k_m --outfile ~/qwen35-ft/qwen3.5-4b-finetuned.Q4_K_M.gguf
```

---

## Phase 5 — Load into Ollama

Create a Modelfile:

```bash
cat > ~/qwen35-ft/Modelfile << 'EOF'
FROM ./qwen3.5-4b-finetuned.Q4_K_M.gguf
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
cd ~/qwen35-ft
ollama create qwen3.5:4b-finetuned -f Modelfile
ollama run qwen3.5:4b-finetuned "Say hello"
```

Verify it appears in `ollama list`.

---

## Phase 6 — Point opencode at the fine-tuned model

Once the fine-tuned model is in Ollama, update the opencode agent:

Edit `/home/alpharius/.config/opencode/agents/qwen3.5.md` and change:

```yaml
model: ollama/qwen3.5:4b
```

to:

```yaml
model: ollama/qwen3.5:4b-finetuned
```

Alternatively, add a separate model entry in `/home/alpharius/.config/opencode/opencode.json` and create a dedicated agent for the fine-tuned variant.

---

## Reality check — CPU-only constraints

| Factor | Reality on this machine |
|--------|------------------------|
| GPU | None — CPU-only |
| RAM | 31 GB (tight but workable for 4B + LoRA) |
| Training speed | Slow (CPU inference/training) |
| Recommended config | LoRA r=8, small dataset (hundreds–thousands of rows), 1–3 epochs |

If fine-tuning proves too slow on CPU, practical alternatives:

1. **Few-shot prompting** — put example instruction/output pairs directly in the `qwen3.5.md` agent instructions instead of fine-tuning.
2. **Fine-tune on a GPU machine** — train elsewhere, export the GGUF, and import it into Ollama here.
3. **Use `qwen3.5:4b` out of the box** — it is already a capable local model for code design, implementation, and tests.
