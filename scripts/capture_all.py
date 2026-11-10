#!/usr/bin/env python3
import argparse
import json
import os
import time
import urllib.request
import sys
from datetime import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, ".."))

def resolve_guidelines_file(rel_path):
    env_dir = os.environ.get("GUIDELINES_DIR")
    candidates = [
        os.path.join(env_dir, rel_path) if env_dir else None,
        os.path.join(REPO_ROOT, "governance", rel_path),
        os.path.expanduser(f"~/dev/devlopment/guidelines/{rel_path}"),
        os.path.expanduser(f"~/dev/guidelines/{rel_path}") #,
        # f"<path/to/guidelines/dir>/guidelines/{rel_path}" # Update <path/to/guidelines/dir> to point to absolute path
    ]
    for c in candidates:
        if c and os.path.exists(c):
            return c
    return os.path.join(REPO_ROOT, "governance", rel_path)

OLLAMA_URL = os.environ.get("OLLAMA_URL", "http://localhost:11434/api/generate")

parser = argparse.ArgumentParser(description="Review an HLD across local AI models.")
parser.add_argument(
    "--hld-file",
    default=resolve_guidelines_file("design_example/epic_example/ntf_HLD.md"),
    help="Path to the HLD markdown file to review (default: ntf_HLD.md in governance)",
)
parser.add_argument(
    "--output-file",
    default=resolve_guidelines_file("HLD_Review_Model_Test.md"),
    help="Path where the benchmark markdown report will be written",
)
group = parser.add_mutually_exclusive_group()
group.add_argument(
    "--review-only",
    action="store_true",
    help="Only generate the review report; do not modify the HLD document.",
)
group.add_argument(
    "--update-doc",
    action="store_true",
    help="Perform review updates to the HLD document and generate the report.",
)
args = parser.parse_args()

if not args.review_only and not args.update_doc:
    print(
        "Skipping HLD review. Pass --review-only to generate the report only, "
        "or --update-doc to update the HLD document and generate the report."
    )
    raise SystemExit(0)

HLD_PATH = args.hld_file
OUTPUT_PATH = args.output_file

if not os.path.exists(HLD_PATH):
    print(f"Error: HLD file not found at {HLD_PATH}")
    raise SystemExit(1)

# Delete the report at the beginning of every run so it is recreated fresh.
if os.path.exists(OUTPUT_PATH):
    os.remove(OUTPUT_PATH)
    print(f"Deleted existing {OUTPUT_PATH}")

with open(HLD_PATH, "r") as f:
    hld_content = f.read()

models = [
    {
        "name": "qwen3.5:Architect",
        "role": "Solution Architect / Lead QA / Code Reviewer / Security Reviewer / Documentation",
        "role_section": "roles.md §3.3, §3.6, §3.9, §3.11, §3.12",
        "focus": "Review HLD §2 (Architecture Overview), §3.5-3.6 (Performance/Security), §4 (External Interfaces), §5.1 (Rationale and Alternatives). Validate pattern selection, module boundaries, cross-component interfaces, serialization, error handling, security constraints. Lead QA test strategy review §3.9. Independent gate check against HLD_TEMPLATE.md."
    },
    {
        "name": "qwen2.5-coder:3b",
        "role": "Epic Owner / Tech Lead / Feature Designer / Senior QA / DevOps / Bugfix Designer / UI/UX",
        "role_section": "roles.md §3.4, §3.5, §3.7, §3.10, §3.11, §3.14, §3.15",
        "focus": "Epic decomposition feasibility, technical delivery assessment, implementation viability, test case specification hooks. Review deployment considerations §3.1, §3.3 migration. Check CI/CD, rollout, rollback feasibility. Assess implementation complexity."
    },
    {
        "name": "qwen2.5-coder:0.5b",
        "role": "QA / Test Engineer",
        "role_section": "roles.md §3.8",
        "focus": "Execute and verify test cases against HLD. Review testability §3.9. Identify test scenarios, boundary conditions, negative cases. Check test environment requirements §3.9.1."
    },
    {
        "name": "qwen3:0.6b",
        "role": "QA / Test Engineer / Feature Implementer",
        "role_section": "roles.md §3.8, §3.13",
        "focus": "Execute and verify test cases against HLD. Review testability §3.9. Identify test scenarios, boundary conditions, negative cases. Check test environment requirements §3.9.1. Validate implementation feasibility."
    },
    {
        "name": "gemma3:1b",
        "role": "QA / Test Engineer (UI/UX) / Feature Implementer",
        "role_section": "roles.md §3.8 (scoped), §3.13",
        "focus": "UI/UX review: §3.3 User Interfaces, §3.7 Usability, §3.8 Accessibility, §4.3 UI changes. Check accessibility compliance, error message clarity, user-facing workflows, frontend implementation."
    }
]

def call_ollama(model_name, prompt):
    start = time.time()
    payload = {
        "model": model_name,
        "prompt": prompt,
        "stream": False,
        "temperature": 0.2,
        "topP": 0.9
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        OLLAMA_URL,
        data=data,
        headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req, timeout=600) as resp:
            result = json.loads(resp.read().decode("utf-8"))
    except Exception as e:
        end = time.time()
        return {
            "duration_ms": int((end - start) * 1000),
            "response": f"ERROR: {str(e)}",
            "error": str(e)
        }
    end = time.time()
    return {
        "duration_ms": int((end - start) * 1000),
        "response": result.get("response", ""),
        "error": result.get("error", None)
    }

def evaluate_accuracy(response):
    checks = {
        "mentions_hld_sections": bool("§" in response or "section" in response.lower()),
        "mentions_template": "template" in response.lower(),
        "identifies_missing": any(w in response.lower() for w in ["missing", "absent", "not found", "not included"]),
        "suggests_improvements": any(w in response.lower() for w in ["recommend", "suggest", "improve", "should"]),
        "references_roles": any(w in response.lower() for w in ["architect", "reviewer", "qa", "security"]),
        "specific_findings": len(response) > 200,
        "mentions_patterns": any(w in response.lower() for w in ["pattern", "architecture"]),
        "mentions_risk": any(w in response.lower() for w in ["risk", "security", "performance"]),
    }
    passed = sum(1 for v in checks.values() if v)
    total = len(checks)
    score = round((passed / total) * 100)
    return {"score": score, "passed": passed, "total": total}

def print_progress(idx, total, model_name, elapsed_ms=None, avg_ms=None):
    """Print a progress line showing overall status."""
    pct = int((idx / total) * 100)
    bar_len = 40
    filled = int(bar_len * idx / total)
    bar = "█" * filled + "░" * (bar_len - filled)
    
    line = f"\r[{bar}] {pct}%  Model {idx}/{total}: {model_name}"
    if elapsed_ms is not None:
        line += f"  ({elapsed_ms}ms)"
    if avg_ms is not None and idx < total:
        remaining = (total - idx) * avg_ms
        line += f"  Est. remaining: {remaining//1000}s"
    print(line, end="", flush=True)

results = []
start_overall = time.time()


def update_hld_document(results):
    """Append a clearly-marked review-update summary to the HLD document.

    This is append-only and reversible so the HLD is updated without
    overwriting existing content.
    """
    update_lines = [
        "\n",
        "## Review Update Summary (auto-generated)\n",
        f"_Generated {datetime.now().isoformat()} by capture_all.py (--update-doc)_\n",
        "\n",
        "The following AI models reviewed this HLD. See "
        "HLD_Review_Model_Test.md for full review results.\n",
        "\n",
        "| Model | Role | Accuracy | Status |\n",
        "|-------|------|----------|--------|\n",
    ]
    for r in results:
        status = "Error" if r["error"] else "Reviewed"
        update_lines.append(
            f"| {r['model']} | {r['role']} | {r['accuracy_score']}% | {status} |\n"
        )
    update_lines.append("\n---\n")

    with open(HLD_PATH, "a") as f:
        f.writelines(update_lines)

    print(f"\nAppended review-update summary to {HLD_PATH}")

for i, model in enumerate(models, 1):
    # Show start progress
    print_progress(i - 1, len(models), model["name"])
    print()  # newline after progress bar
    
    prompt = f"""You are acting as a {model['role']} ({model['role_section']}). Your focus: {model['focus']}

Review the following High Level Design (HLD) document for the Real-Time Notification Service (NTF).

Reference the HLD_TEMPLATE.md requirements:
- Document Control must be complete before review
- Section 1: Introduction and Objectives (§1.1-§1.12)
- Section 2: Architecture Overview (§2.1-§2.3)
- Section 3: Impacts on Product Attributes (§3.1-§3.12)
- Section 4: External Design (§4.1-§4.11)
- Section 5: Internal Design (§5.1-§5.6)
- Section 6: Publication Updates
- Section 7: Appendix: Internal-Level Detail

Identify:
1. Missing sections or incomplete content
2. Ambiguous requirements or unclear specifications
3. Deviations from HLD_TEMPLATE.md conventions
4. Specific recommendations for improvement
5. Role-specific findings based on your {model['role']} responsibilities

HLD Content:
```
{hld_content}
```

Provide your review as: findings, missing items, recommendations, and an overall quality score (1-10)."""

    result = call_ollama(model["name"], prompt)
    accuracy = evaluate_accuracy(result["response"])
    
    # Calculate average time so far for ETA
    completed_times = [r["duration_ms"] for r in results]
    avg_ms = sum(completed_times) / len(completed_times) if completed_times else None
    
    results.append({
        "model": model["name"],
        "role": model["role"],
        "role_section": model["role_section"],
        "duration_ms": result["duration_ms"],
        "duration_sec": round(result["duration_ms"] / 1000, 2),
        "accuracy_score": accuracy["score"],
        "accuracy_passed": accuracy["passed"],
        "accuracy_total": accuracy["total"],
        "response_length": len(result["response"]),
        "error": result["error"],
        "response": result["response"]
    })
    
    # Show completion progress
    print_progress(i, len(models), model["name"], result["duration_ms"], avg_ms)
    print(f"\n  ✓ {model['name']}: {result['duration_ms']}ms, {accuracy['score']}% ({accuracy['passed']}/{accuracy['total']}), {len(result['response'])} chars")
    
    if i < len(models):
        time.sleep(2)

# Final progress bar
print_progress(len(models), len(models), "Complete")
print()

# Generate report
report = f"""# HLD Review Model Test Results

**Source File:** design_example/epic_example/ntf_HLD.md
**Template:** templates/HLD_TEMPLATE.md
**Test Date:** {datetime.now().isoformat()}
**Guidelines:** roles.md (role assignments), users.md (model roster)

## Summary Table

| Model | Role | Role Section | Speed (ms) | Speed (s) | Accuracy (%) | Accuracy (passed/total) | Response Length | Error |
|-------|------|-------------|------------|-----------|--------------|------------------------|-----------------|-------|
"""

for r in results:
    report += f"| {r['model']} | {r['role']} | {r['role_section']} | {r['duration_ms']} | {r['duration_sec']} | {r['accuracy_score']} | {r['accuracy_passed']}/{r['accuracy_total']} | {r['response_length']} | {r['error'] or 'None'} |\n"

report += "\n## Detailed Results\n\n"

for r in results:
    report += f"### {r['model']}\n"
    report += f"- **Role:** {r['role']}\n"
    report += f"- **Role Section:** {r['role_section']}\n"
    report += f"- **Speed:** {r['duration_ms']}ms ({r['duration_sec']}s)\n"
    report += f"- **Accuracy:** {r['accuracy_score']}% ({r['accuracy_passed']}/{r['accuracy_total']} checks passed)\n"
    report += f"- **Response Length:** {r['response_length']} characters\n"
    report += f"- **Error:** {r['error'] or 'None'}\n"
    report += f"- **Review Output:**\n"
    report += "```\n"
    report += f"{r['response']}\n"
    report += "```\n\n"
    report += "---\n\n"

# Speed ranking
speed_sorted = sorted(results, key=lambda x: x["duration_ms"])
report += "## Speed Ranking (Fastest to Slowest)\n\n"
for i, r in enumerate(speed_sorted):
    report += f"{i+1}. {r['model']} — {r['duration_ms']}ms ({r['duration_sec']}s)\n"

# Accuracy ranking
acc_sorted = sorted(results, key=lambda x: x["accuracy_score"], reverse=True)
report += "\n## Accuracy Ranking (Highest to Lowest)\n\n"
for i, r in enumerate(acc_sorted):
    report += f"{i+1}. {r['model']} — {r['accuracy_score']}% ({r['accuracy_passed']}/{r['accuracy_total']})\n"

# Best overall (accuracy per second)
best_overall = max(results, key=lambda x: x["accuracy_score"] / max(x["duration_ms"] / 1000, 0.001))
report += f"\n## Best Overall (Accuracy per Second)\n\n"
report += f"**{best_overall['model']}** — {best_overall['accuracy_score']}% accuracy in {best_overall['duration_ms']}ms\n\n"

total_elapsed = int((time.time() - start_overall) * 1000)
report += f"\n**Total test time:** {total_elapsed}ms ({round(total_elapsed/1000, 1)}s)\n"

with open(OUTPUT_PATH, "w") as f:
    f.write(report)

if args.update_doc:
    update_hld_document(results)

print(f"\nReport written to {OUTPUT_PATH}")
print(f"\nSummary:")
for r in results:
    print(f"  {r['model']}: {r['duration_ms']}ms, {r['accuracy_score']}% accuracy, {r['response_length']} chars")