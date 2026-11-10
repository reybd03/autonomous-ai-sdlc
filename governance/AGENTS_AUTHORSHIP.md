# Document Authorship & Beads Task Assignment

Every design document has a single accountable authoring role. When a document is created or updated, a beads task MUST be created and assigned to the document author **before** editing begins:

```bash
bd create "<title>" --description="<why this document exists and what must be done>" --type=task --priority=2 --assignee=<author>
bd update <id> --claim   # claimed by the author before editing
bd close <id>            # when the document (and its review file, if applicable) is complete
```

**Document author mapping:**

| Document | Authoring role | Beads task assignee |
| :--- | :--- | :--- |
| `*_HLD.md` | qwen3.5:Architect (Solution Architect drafting role) | **qwen3.5:Architect** |
| `*_LLD.md` | Epic Owner / Tech Lead | Epic Owner |
| Feature / Bug Design | Feature Designer / Implementer | Feature Designer |
| Test Plan | Lead QA / Test Engineer | Lead QA |
| Test Cases | Senior QA / Test Engineer | Senior QA |
| `*_Project_Analysis.md` | Documentation / InfoDev | Documentation / InfoDev (qwen3.5:Architect or qwen2.5-coder:3b) |

**qwen3.5:Architect is the HLD author.** A beads task for each HLD is created and assigned to qwen3.5:Architect. No HLD may be drafted or edited without an open, claimed beads task assigned to qwen3.5:Architect.

Beads is the source of truth for task ownership — do not use markdown TODO files or TodoWrite for document authorship tracking.
