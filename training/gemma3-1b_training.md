# Gemma 3 1B Fine-Tuning Instructions (sub-1B, multimodal)

Environment: CPU-only machine (no NVIDIA GPU), Python 3.14, 31 GB RAM.
Base model: `gemma3:1b` (pull via Ollama, 1B params, Q4_K_M, 128K context, multimodal text+image).
Target: Fine-tune with LoRA and import the merged GGUF back into Ollama for use with opencode.

## Why this model

1B parameters (at the sub-1B boundary) and multimodal — handles both text and images.
Best for: UI/UX review (screenshot feedback, wireframe critique, layout suggestions,
copy improvements, basic accessibility flags on React + Tailwind components).

---

## Phase 1 — Environment setup

Create a dedicated virtual environment and install CPU-friendly training packages:

```bash
python3 -m venv ~/gemma3-1b-ft && source ~/gemma3-1b-ft/bin/activate
pip install --upgrade pip
pip install torch transformers accelerate peft datasets sentencepiece
```

> **Note:** Gemma 3 is multimodal. Fine-tuning the vision encoder on CPU is very
> slow; consider fine-tuning only the text adapter (LoRA on language-model layers)
> or using few-shot prompting instead of fine-tuning for UI/UX tasks.

Verify the install:

```bash
python3 -c "import torch, transformers, peft, datasets; print('imports OK')"
```

---

## Phase 2 — Prepare your dataset

Fine-tuning requires a JSONL file. Recommended field names: `instruction`, `input`, `output`.
For UI/UX, include screenshot descriptions and desired feedback.

Example (`train.jsonl`):

```jsonl
{"instruction": "Review this UI screenshot for accessibility issues", "input": "[screenshot: login form with low-contrast grey text]", "output": "The login form uses grey text (#888) on white, which fails WCAG contrast. Increase text contrast to at least #333 or use a darker shade."}
{"instruction": "Suggest copy improvements for this button", "input": "[button: 'Click here to submit']", "output": "Use more descriptive copy: 'Submit application' or 'Send message'."}
EOF
```

Create the data directory and a starter dataset:

```bash
mkdir -p ~/gemma3-1b-ft/data
cat > ~/gemma3-1b-ft/data/train.jsonl << 'EOF'
{"instruction": "Review this UI screenshot for accessibility issues", "input": "[screenshot: login form with low-contrast grey text]", "output": "The login form uses grey text (#888) on white, which fails WCAG contrast. Increase text contrast to at least #333."}
EOF
echo "Dataset rows: $(wc -l < ~/gemma3-1b-ft/data/train.jsonl)"
```

Aim for at least several hundred high-quality rows.

---

## Phase 3 — Fine-tuning script (LoRA on CPU)

Save as `~/gemma3-1b-ft/train.py`:

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer, DataCollatorForLanguageModeling
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from datasets import load_dataset

MODEL = "ollama/gemma3:1b"   # or "google/gemma-3-1b-it" from Hugging Face
DATA = "~/gemma3-1b-ft/data/train.jsonl"
OUTPUT = "~/gemma3-1b-ft/adapter"

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
cd ~/gemma3-1b-ft && python train.py
```

---

## Phase 4 — Merge adapter + export to GGUF for Ollama

Merge script — save as `~/gemma3-1b-ft/merge.py`:

```python
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel
import torch

BASE = "ollama/gemma3:1b"
ADAPTER = "~/gemma3-1b-ft/adapter"
MERGED = "~/gemma3-1b-ft/merged"

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
cd ~/gemma3-1b-ft && python merge.py
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
python3 ~/llama.cpp/convert-hf-to-gguf.py ~/gemma3-1b-ft/merged --outtype q4_k_m --outfile ~/gemma3-1b-ft/gemma3-1b-finetuned.Q4_K_M.gguf
```

---

## Phase 5 — Load into Ollama

Create a Modelfile:

```bash
cat > ~/gemma3-1b-ft/Modelfile << 'EOF'
FROM ./gemma3-1b-finetuned.Q4_K_M.gguf
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
cd ~/gemma3-1b-ft
ollama create gemma3:1b-finetuned -f Modelfile
ollama run gemma3:1b-finetuned "Review this UI screenshot for contrast issues"
```

Verify it appears in `ollama list`.

---

## Phase 6 — Point opencode at the fine-tuned model

Edit `/home/alpharius/.config/opencode/agents/gemma3-1b.md` and change:

```yaml
model: ollama/gemma3:1b
```

to:

```yaml
model: ollama/gemma3:1b-finetuned
```

---

## Reality check — CPU-only constraints

| Factor | Reality on this machine |
|--------|------------------------|
| GPU | None — CPU-only |
| RAM | 31 GB (plenty for 1B + LoRA) |
| Training speed | Fast on CPU for a 1B text model; slow for vision encoder |
| Recommended config | LoRA r=8, batch_size=2, gradient_accumulation_steps=4, 1–3 epochs; text-only fine-tuning recommended |
