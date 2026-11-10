# User / Model Roster

Alphabetical roster for role assignment in `roles.md`.

Role capability legend:

- **Drafting & Modification** — creates or edits artifacts (may be performed by an AI agent)
- **Oversight & Approval** — reviews, signs off, and is accountable (must be a human)
- **Both** — performs both drafting and approval duties

| Letter | User / Model       | Type  | Role Capability         | Notes                                                               |
| :----: | :----------------- | :---- | :---------------------- | :------------------------------------------------------------------ |
|   A    | Rey Benavidez      | Human | Oversight & Approval    | You — accountable party for all artifacts                           |
|   B    | gemma3:1b          | AI    | Drafting & Modification | Local model — 806 MB. Scoped: UI/UX Testing & Verification (Role 8) |
|   C    | qwen3:0.6b         | AI    | Drafting & Modification | Local model — 522 MB                                                |
|   D    | qwen2.5-coder:0.5b | AI    | Drafting & Modification | Local model — 397 MB                                                |
|   E    | qwen2.5-coder:3b   | AI    | Drafting & Modification | Local model — 1.9 GB. Roles: Epic Owner, Feature Designer, DevOps, Documentation / InfoDev (templates & examples).   |
|   F    | qwen3.5:Architect  | AI    | Drafting & Modification | Local model — 3.3 GB. Roles: Solution Architect, Lead QA, Code Reviewer, Security Reviewer, Documentation / InfoDev (templates & examples).   |
|   G    | <open>             | AI    | —                       | Reserved                                                            |
|   H    | <open>             | AI    | —                       | Reserved                                                            |
|   I    | <open>             | AI    | —                       | Reserved                                                            |
|   J    | <open>             | AI    | —                       | Reserved                                                            |
|   K    | <open>             | AI    | —                       | Reserved                                                            |
|   L    | <open>             | AI    | —                       | Reserved                                                            |
|   M    | <open>             | AI    | —                       | Reserved                                                            |
|   N    | <open>             | AI    | —                       | Reserved                                                            |
|   O    | <open>             | AI    | —                       | Reserved                                                            |
|   P    | <open>             | AI    | —                       | Reserved                                                            |
|   Q    | <open>             | AI    | —                       | Reserved                                                            |
|   R    | <open>             | AI    | —                       | Reserved                                                            |
|   S    | <open>             | AI    | —                       | Reserved                                                            |
|   T    | <open>             | AI    | —                       | Reserved                                                            |
|   U    | <open>             | AI    | —                       | Reserved                                                            |
|   V    | <open>             | AI    | —                       | Reserved                                                            |
|   W    | <open>             | AI    | —                       | Reserved                                                            |
|   X    | <open>             | AI    | —                       | Reserved                                                            |
|   Y    | <open>             | AI    | —                       | Reserved                                                            |
|   Z    | <open>             | AI    | —                       | Reserved                                                            |

---

## Role Assignments (complete)

| #          | Role                                              | Drafting & Modification                     | Oversight & Approval (Accountable) | `roles.md` Section |
| ---------- | ------------------------------------------------- | ------------------------------------------- | ---------------------------------- | ------------------ |
| 1          | Product Owner / Sponsor                           | A. Rey Benavidez                            | **A. Rey Benavidez**               | §3.1               |
| 2          | Business Analyst                                  | A. Rey Benavidez                            | **A. Rey Benavidez**               | §3.2               |
| 3          | Solution Architect                                | F. qwen3.5:Architect                        | **A. Rey Benavidez**               | §3.3               |
| 4          | Epic Owner / Tech Lead                            | E. qwen2.5-coder:3b                         | **A. Rey Benavidez**               | §3.4               |
| 5          | Feature Designer / Implementer                    | E. qwen2.5-coder:3b                         | **A. Rey Benavidez**               | §3.5               |
| 6          | Lead QA / Test Engineer                           | F. qwen3.5:Architect                        | **A. Rey Benavidez**               | §3.6               |
| 7          | Senior QA / Test Engineer                         | E. qwen2.5-coder:3b                         | **A. Rey Benavidez**               | §3.7               |
| 8          | QA / Test Engineer                                | C. qwen3:0.6b · D. qwen2.5-coder:0.5b       | **A. Rey Benavidez**               | §3.8               |
| 8 (scoped) | QA / Test Engineer — UI/UX Testing & Verification | B. gemma3:1b                                | **A. Rey Benavidez**               | §3.8               |
| 9          | Code Reviewer / Gate Approver                     | F. qwen3.5:Architect                        | **A. Rey Benavidez**               | §3.9               |
| 10         | DevOps / Release Engineer                         | E. qwen2.5-coder:3b                         | **A. Rey Benavidez**               | §3.10              |
| 11         | Documentation / InfoDev                           | E & F (qwen2.5-coder:3b, qwen3.5:Architect) | **A. Rey Benavidez**               | §3.11              |
| 12         | Security / Compliance Reviewer                    | F. qwen3.5:Architect                        | **A. Rey Benavidez**               | §3.12              |
| 13         | Feature / Bugfix Implementer                      | B & C (gemma3:1b, qwen3:0.6b)               | **A. Rey Benavidez**               | §3.13              |
| 14         | Bugfix Designer / Implementer                     | E. qwen2.5-coder:3b                         | **A. Rey Benavidez**               | §3.14              |
| 15         | UI / UX Designer / Implementer                    | E. qwen2.5-coder:3b                         | **A. Rey Benavidez**               | §3.15              |

---

## Usage

When assigning roles from `roles.md`, reference a roster entry by letter (e.g. **A. Rey Benavidez**, **F. qwen3.5:Architect**).

**Assignment model:** An AI model (B–F) may draft or modify artifacts _in_ a role. This includes design documents (HLD, LLD, Feature Design, Bug Design, Test Plan, Test Cases) as well as the template library (`templates/*_TEMPLATE.md`) and the example library (`design_example/*`). Rey Benavidez (A) provides **Human Oversight and Approval** — remaining the accountable (`A`) party for every artifact, gate, and release, per `roles.md` §1.

**Key constraints from `roles.md`:**

- Accountability never transfers to an AI agent. An agent may act _in_ a role; a named human remains accountable.
- No role approves its own work — every artifact has a distinct author and approver.
- `R` (Responsible) may be delegated to an AI agent; `A` (Accountable) may not.

## Design Document Lifecycle Phases (All Design Documents)

Every design document — HLD, LLD, Feature Design, Bug Design, Test Plan, Test Cases, Project Analysis, Compliance, Documentation, and Ops — passes through the following document-control phases, tracked on the Document Control block's status field:

| Document Type | File Pattern | Location | Status Field | Drafting Role |
| :--- | :--- | :--- | :--- | :--- |
| High Level Design | `*_HLD.md` | `design/` | `Design Status` | `qwen3.5:Architect` |
| Low Level Design | `*_LLD.md` | `design/epic/` | `Design Status` | Epic Owner / Tech Lead (`qwen2.5-coder:3b`) |
| Feature Design | `<Feature ID>_design_document.md` | `design/epic/features/` | `Design Status` | Feature Designer / Implementer |
| Bug Design | `<Bug ID>_bug_design.md` | `design/epic/bugs/` | `Status` | Bugfix Designer / Implementer |
| Test Plan | `*_TEST_PLAN.md` | `design/` | `Status` | Lead QA / Test Engineer |
| Test Cases | `*_TEST_CASES.md` | `design/` or `tests/` | `Status` | Senior QA / Test Engineer |
| Project Analysis | `*_Project_Analysis.md` | `design/` | `Analysis Status` | Documentation / InfoDev · qwen3.5:Architect |
| Compliance | `*_COMPLIANCE.md` or `<Framework>_compliance.md` | `compliance/` or `docs/compliance/` | `Compliance Status` | Security / Compliance Reviewer |
| Documentation | `*_DOCUMENTATION.md` or `<Guide Name>_doc.md` | `docs/` or `design/` | `Documentation Status` | Documentation / InfoDev |
| Ops | `*_OPS.md` or `<Runbook Name>_ops.md` | `ops/` or `docs/ops/` | `Ops Status` | DevOps / Release Engineer |

| Phase | Status Value | Accountable (`A`) | Responsible (`R`) | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Draft | `Draft` | — | Author (drafting role) | Written section-by-section with User confirmation at each § boundary. |
| Review | `In Review` | Reviewer | Author (incorporates findings) | Findings recorded as Acceptable / Minor / Major; major findings trigger push-back. |
| Reviewed | `Reviewed` | Human Reviewer | — | Separate human reviewer signs off; author/AI agent may not self-approve. |
| Approved | `Approved` | Human Reviewer | — | Formal approval granted; review file `<epic>_<doc-level>_<review-number>.md` generated. |
| Revision | `Draft v<x.x>` / `In Review v<x.x>` | — | Author | Post-approval change opens a new revision version; status returns to draft/review for that revision. |
| Reviewed (Revision x.x) | `Reviewed v<x.x>` | Human Reviewer | — | Revision x.x review complete; separate human reviewer signs off. |
| Approved (Revision x.x) | `Approved v<x.x>` | Human Reviewer | — | Revision x.x formally approved; new review file generated for that revision. |

**Document-level (`<doc-level>`) values for review file naming:** `hld`, `lld`, `feature-design`, `bug-design`, `test-plan`, `test-cases`, `project-analysis`, `compliance`, `documentation`, `ops`.

**Rules:**
- **No self-approval**: the author or an AI agent may not set their own document to `Approved` or `Approved v<x.x>`.
- **Revision requires re-review**: any change to an Approved document must cycle through Revision → Review → Reviewed → Approved for the new revision version.
- **Review file required**: no document is considered officially reviewed until its `<epic>_<doc-level>_<review-number>.md` review file exists.
- **Reviewed by and Comments required**: Every design document must include a "Reviewed by and Comments" section before its approval section, containing:
  - **Reviewers table**: Reviewer / Role / Date / Comments — listing every human reviewer who evaluated the document.
  - **Comment Section**: File location, Created Date, and Modified Date documenting where review comments are stored.
- **Approval remains human**: Rey Benavidez (A) remains accountable for every artifact gate and release per `roles.md` §1 and §6 guardrail 3. AI agents draft but never approve.

