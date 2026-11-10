# Autonomous Multi-Agent SDLC & Local Model Platform

An enterprise-grade, local multi-agent software development lifecycle (SDLC) framework powered by Ollama, specialized SLMs/LLMs, custom Modelfiles, and strict RACI governance.

---

## Architecture & Model Matrix

| Model Tier | Base Model | Persona Role | Responsibilities |
| :--- | :--- | :--- | :--- |
| **Architect** | `qwen3.5:Architect` / `hermes:Architect` | Principal Software Architect | High-Level Design (HLD), Security Reviews, Cross-Component Contracts |
| **Tech Lead / Dev** | `qwen2.5-coder:3b` / `hermes:SeniorDev` | Senior Software Engineer | Low-Level Design (LLD), Code Implementation, DevOps |
| **Verification** | `gemma3:1b` & `qwen3:0.6b` | QA & Verification Engineer | Scoped UI/UX Testing, Accessibility, Lint & Unit Test Verification |

---

## Core Components

1. **Autonomous Scheduled Daemon (`scripts/nightly_ai_runner.sh`):**
   * Operates as a scheduled cron service.
   * Scans project repositories for pending tasks tracked in git-backed **Beads**.
   * Routes tasks to appropriate local Ollama models via REST API based on semantic classification.
   * Supports immediate runs via `--force`.

2. **Agent RACI Governance (`governance/`):**
   * Enforces strict separation of concerns: AI agents act with Responsible (`R`) drafting duties; human engineers retain Accountable (`A`) sign-off.
   * Enforces zero self-approving agents (every artifact requires distinct author and reviewer).
   * Standardizes an 8-phase document control lifecycle covering HLD, LLD, Feature Design, Test Plans, Test Cases, and Ops runbooks.

3. **Automated Architectural Benchmarking (`scripts/capture_all.py`):**
   * Python pipeline that evaluates system design documents across multiple local models simultaneously.
   * Compares model findings against formal design templates, security constraints, and module boundaries.
   * Generates comprehensive markdown audit reports and speed/accuracy rankings.

4. **Consumer-Hardware LoRA Fine-Tuning (`training/`):**
   * Step-by-step guides for training coder models on consumer hardware (CPU or GPU) using PyTorch, Hugging Face `peft`, and GGUF quantization.

---

## Quick Start

### 1. Build Ollama Custom Personas
```bash
ollama create hermes:Architect -f modelfiles/qwen3_5_4b_hermes_Modefile
ollama create hermes:SeniorDev -f modelfiles/qwen2_5_coder_3b_hermes_Modelfile
```

### 2. Run the Benchmark Pipeline
```bash
python3 scripts/capture_all.py --review-only
```

Or benchmark a custom HLD:
```bash
python3 scripts/capture_all.py --hld-file path/to/my_HLD.md --review-only
```

### 3. Run the Nightly Daemon
Run with `--force` for testing outside the 00:00-06:00 window:
```bash
./scripts/nightly_ai_runner.sh --force
```
