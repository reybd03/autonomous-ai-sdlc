# Roles & Responsibilities

- **Purpose**: Define who owns which artifact, decision, and lifecycle stage in this guidelines library.
- **Scope**: Applies to every consuming project that adopts the templates in this repo (`HLD`, `LLD`, Feature Design, Bug Design, Test Plan, Test Cases) and the `mol-feature-lifecycle` workflow.
- **Audience**: Humans and AI agents working in the repository.
- **Related**: [`AGENTS.md`](./AGENTS.md) · [`README_FEATURE_LIFECYCLE.md`](./lifecycle/README_FEATURE_LIFECYCLE.md) · [`HLD_TEMPLATE.md`](./templates/HLD_TEMPLATE.md) · [`LLD_TEMPLATE.md`](./templates/LLD_TEMPLATE.md) · [`FEATURE_DESIGN_TEMPLATE.md`](./templates/FEATURE_DESIGN_TEMPLATE.md) · [`BUG_DESIGN_TEMPLATE.md`](./templates/BUG_DESIGN_TEMPLATE.md) · [`TEST_PLAN_TEMPLATE.md`](./templates/TEST_PLAN_TEMPLATE.md) · [`TEST_CASE_TEMPLATE.md`](./templates/TEST_CASE_TEMPLATE.md)

---

## 1. How to Read This Document

1. A **role** is a bundle of responsibilities and decision rights — not a job title and not a person.
2. One person may hold several roles (typical on small teams). One role may be split across people (typical at scale).
3. **Accountability never transfers to an AI agent.** An agent may act *in* a role; a named human remains accountable for the output.
4. **Artifacts are owned, not crowdsourced.** The owner writes or commissions the document, resolves review comments, and signs off the status field.
5. **No role approves its own work.** Every artifact has a distinct author and approver.
6. **HLDs and Test Plans are written section by section with the User** — the owner proposes, the User confirms, then the next section begins. See `AGENTS.md` → Code Standards.

Legend for decision rights used throughout:

| Symbol | Meaning |
| :--- | :--- |
| `A` | **Accountable** — final say; signs off; only one per artifact |
| `R` | **Responsible** — does the work |
| `C` | **Consulted** — must be asked before sign-off |
| `I` | **Informed** — notified after the decision |

---

## 2. Role Catalogue

| Role | Mission | Primary Artifacts | Lifecycle Stages |
| :--- | :--- | :--- | :--- |
| Product Owner / Sponsor | Owns *why* and *whether*; funds the work | HLD §1 (objectives, business needs), priorities | Spec, Review gate, Release |
| Business Analyst | Turns stakeholder needs into verifiable requirements | HLD §1.3–1.5, requirement IDs, traceability | Spec |
| Solution Architect | Owns system-level structure and cross-cutting decisions | HLD (all §2–§5), LLD technical review | Spec, Review gate |
| Epic Owner / Tech Lead | Decomposes the epic and owns technical delivery | LLD, child issue breakdown, ADR inputs | Spec, Implement, Review gate |
| Feature Designer / Implementer | Designs and builds one feature or bug fix | Feature Design, Bug Design, code, tests | Spec, Implement, Test |
| Lead QA / Test Engineer | Owns verification strategy and exit criteria | Test Plan, test matrix, defect triage and severity | Spec, Test, Staging QA |
| Senior QA / Test Engineer | Owns test-case specification and coverage traceability | Test Cases, traceability matrix, test data | Spec, Test |
| QA / Test Engineer | Executes and verifies test cases; reports defects | Executed test cases, evidence, bug tickets | Test, Staging QA |
| Code Reviewer / Gate Approver | Independent quality and design-conformance check | Review notes, approval on the gate issue | Review gate |
| DevOps / Release Engineer | Makes delivery repeatable and reversible | CI/CD, rollout plan, rollback plan, changelog | Implement, Staging QA, Release |
| Documentation / InfoDev | Keeps operator and developer docs truthful | Guides, README updates, changelog entries, templates, examples | Docs, Release |
| Security / Compliance Reviewer | Applies security, privacy, and licensing constraints | Security sections, threat notes, compliance sign-off | Spec, Review gate, Release |
| Feature / Bugfix Implementer | Implements one feature or bug fix end-to-end — code, unit tests, changelog entry | Code changes, unit/integration tests, changelog entry | Implement, Test |
| Bugfix Designer / Implementer | Designs and implements a bug fix — bug design doc, code fix, verification | Bug Design, code fix, changelog entry | Spec, Implement, Test |
| UI / UX Designer / Implementer | Designs and implements user interfaces and accessibility-compliant experiences | UI mocks, wireframes, accessibility audit, frontend components | Spec, Implement, Staging QA |

Optional roles, activate when the project needs them: **DBA / Data Steward** (schema, migrations, retention), **SRE / On-call** (SLOs, runbooks, health checks), **Vendor / Integration Liaison** (external interfaces).

---

## 3. Role Definitions

### 3.1 Product Owner / Sponsor

- **Owns**: the problem statement, business value, scope boundary, and the decision to proceed or stop.
- **Writes/approves**: HLD §1.1–1.3, §1.6 (delivery/rollback intent), §1.9 (risk acceptance).
- **Decision rights**: scope in/out (`A`); feature priority (`A`); release go/no-go (`A`, jointly with Release Engineer).
- **Hands off to**: Business Analyst (requirements), Epic Owner (decomposition).
- **Must not**: dictate internal design; approve its own exception to a quality gate.

### 3.2 Business Analyst

- **Owns**: unambiguous, testable requirements with stable IDs (`REQ-*`) and their traceability.
- **Writes/approves**: HLD §1.3 (needs → requirement IDs), §1.4 (use cases), §1.5 (dependencies).
- **Decision rights**: requirement wording and acceptance intent (`A`); requirement ambiguities (`A`).
- **Hands off to**: Solution Architect (design), Senior QA (test basis).
- **Must not**: introduce requirements that no stakeholder asked for and no owner will fund.

### 3.3 Solution Architect

- **Owns**: architecture overview, module boundaries, patterns, cross-component interfaces, and NFR budgets.
- **Writes/approves**: HLD §2 (architecture, file layout, patterns), §3.5–3.6 (performance/security), §4 (external interfaces), §5.1 (rationale and alternatives).
- **Decision rights**: architectural approach (`A`); pattern selection (`A`); new cross-component interface (`A`); deviation from an established pattern (`A`, with recorded rationale).
- **Consults**: Security Reviewer (threat surface), DevOps (deployability), Epic Owner (feasibility).
- **Hands off to**: Epic Owner (LLD), Feature Designers (per-feature constraints).
- **Must not**: approve an LLD or Feature Design that contradicts an approved HLD without reopening the HLD.

### 3.4 Epic Owner / Tech Lead

- **Owns**: the epic → feature decomposition and the shared technical contract between child features.
- **Writes/approves**: LLD in full, especially §3 (scope/decomposition), §6 (detailed design), §8 (rollout).
- **Decision rights**: feature slicing (`A`); shared interface shape within the epic (`A`); sequencing (`A`).
- **Consults**: Solution Architect (constraints), Lead QA (testability of the decomposition).
- **Hands off to**: Feature Designers (one design doc per child issue), Lead QA (test planning scope).
- **Must not**: create child features with overlapping unowned responsibilities ("orphan" behaviour).

### 3.5 Feature Designer / Implementer

- **Owns**: one feature or bug end-to-end — design document, code, unit/integration tests, changelog entry.
- **Writes/approves**: `<Feature ID>_design_document.md` or `<Bug ID>_bug_design.md`; code; changelog entry.
- **Decision rights**: local implementation choices inside the agreed interface (`A`); unit/integration test structure within the approved Test Plan (`R`, Senior QA `A`).
- **Consults**: Epic Owner (interface drift), Senior QA (coverage), Security Reviewer (sensitive paths).
- **Hands off to**: Code Reviewer (PR), QA / Test Engineers (verification evidence).
- **Must not**: change a shared interface, schema, or NFR without the owning role's approval; merge its own PR without an independent review.

### 3.6 Lead QA / Test Engineer

- **Owns**: verification strategy, entrance/exit criteria, environments, and the evidence that the plan's exit criteria were met.
- **Writes/approves**: `*_TEST_PLAN.md` (all §1–§24, section by section with the User); test matrix in design docs (§6/§7); defect severity scheme and triage records.
- **Decision rights**: test strategy and entrance/exit criteria (`A`); environment and test-tool selection (`A`); test-plan sign-off (`A`, countersigned per Document Control); defect severity (`A`, with Product Owner on priority).
- **Consults**: Epic Owner (scope, testability), Solution Architect (NFR budgets), DevOps (environment availability), Security Reviewer (security test scope).
- **Hands off to**: Senior QA (test-case authoring against the approved plan), QA / Test Engineers (execution), Gate Approver (results), Product Owner (residual risk).
- **Must not**: waive a failed acceptance case; declare an exit criterion met without recorded evidence; expand the Test Plan's scope without reopening it with the User.

### 3.7 Senior QA / Test Engineer

- **Owns**: test-case specification, coverage, traceability, and test data design for the approved Test Plan.
- **Writes/approves**: `<Feature ID>_test_cases.md` (or `<Project Acronym>_TEST_CASES.md`), traceability matrix (§8), boundary and negative cases, fixtures and seed data.
- **Decision rights**: test-case design and granularity (`A`); automation status per case (`A`); coverage adequacy within the approved plan (`A`); acceptance-case content (`A`, Lead QA countersigns the plan).
- **Consults**: Lead QA (plan scope, exit criteria), Feature Designer (behaviour, testability hooks), Business Analyst (requirement wording).
- **Hands off to**: QA / Test Engineers (execution), Lead QA (coverage evidence), Feature Designer (untestable behaviour).
- **Must not**: test beyond the approved Test Plan without Lead QA agreement; mark a case "Automated" when it is not; weaken an expected result to make it achievable.

### 3.8 QA / Test Engineer

- **Owns**: execution and verification of test cases, and the defect reports that follow from them.
- **Writes/approves**: executed test-case records (actual results, `Pass`/`Fail`/`Blocked`), evidence artefacts (logs, screenshots, traces, build IDs), bug tickets.
- **Decision rights**: case-level verdict (`A` for `Pass`/`Fail`/`Blocked` on the recorded steps); defect filing and reproduction steps (`A`); proposed severity (`R`, Lead QA `A`).
- **Consults**: Senior QA (ambiguous expected results), Feature Designer (behaviour and root-cause context), DevOps (environment or build failures).
- **Hands off to**: Senior QA (coverage gaps), Lead QA (results and defect trends), Feature Designer (bug tickets, which then require a `<Bug ID>_bug_design.md`).
- **Must not**: edit expected results to make a case pass; close a defect without retest evidence; file a bug ticket without reproduction steps, expected vs. actual behaviour, and build/commit ID.

Bug tickets raised at this step are the entry point to the bug flow:

| Step | Owner | Output |
| :--- | :--- | :--- |
| File defect | QA / Test Engineer | Bug ticket in the issue tracker (`bd create`), tagged with the failing test-case ID |
| Confirm and triage severity | Lead QA / Test Engineer | Triage record; severity and priority set with Product Owner |
| Author the bug design | Bugfix Designer / Implementer | `<Bug ID>_bug_design.md` (see `templates/BUG_DESIGN_TEMPLATE.md`) |
| Fix, retest, close | Feature / Bugfix Implementer → QA / Test Engineer | Green retest evidence; ticket closed with the run reference |

### 3.9 Code Reviewer / Gate Approver

- **Owns**: independent assessment that the change matches its design and meets the quality gates.
- **Writes/approves**: review comments; the review-gate approval (closing the gate issue).
- **Decision rights**: approve/block a PR or gate (`A`); require design rework (`A`).
- **Consults**: Solution Architect (design conformance), Lead QA (coverage adequacy).
- **Hands off to**: DevOps (release) or the Feature Designer (rework).
- **Must not**: review work it authored; approve on "it works on my machine" evidence alone.

### 3.10 DevOps / Release Engineer

- **Owns**: build, pipeline, environment promotion, rollout and rollback mechanics.
- **Writes/approves**: CI/CD config, deployment manifests, migration ordering, rollout/rollback steps (LLD §8, design §5.10).
- **Decision rights**: deployment method and timing (`A`, with Product Owner on go/no-go); rollback trigger (`A`).
- **Consults**: Lead QA (staging readiness), Security Reviewer (secrets, hardened config).
- **Hands off to**: SRE / On-call (monitoring), Docs (release notes).
- **Must not**: deploy a change whose migration rollback path is undocumented.

### 3.11 Documentation / InfoDev

- **Owns**: operator- and developer-facing documentation accuracy at release time, plus the template and example library that every project adopts.
- **Writes/approves**: README/guide updates, HLD §6 publication updates, `changelog/<YYYY>-<MM>.md` entries, `templates/*_TEMPLATE.md`, `design_example/*` example documents.
- **Decision rights**: documentation wording and structure (`A`); sufficiency for release (`A`, with Product Owner); template/example changes (`A`, with Product Owner on breaking template changes).
- **Consults**: Feature Designer (behaviour), QA / Test Engineers (worked examples), Solution Architect (template conventions).
- **Hands off to**: Release notes consumers, project teams adopting templates.
- **Must not**: document behaviour that no test or acceptance case demonstrates; change a template without reviewing its impact on existing design documents.

### 3.12 Security / Compliance Reviewer

- **Owns**: security, privacy, licensing, and regulatory constraints applied to the design and the delivery.
- **Writes/approves**: security sections of HLD §3.6 / design §5.6, threat notes, compliance sign-off.
- **Decision rights**: security acceptance (`A`); block on unacceptable risk (`A`).
- **Consults**: Solution Architect (architecture), DevOps (secrets, supply chain).
- **Must not**: be overridden by schedule pressure without a recorded risk acceptance by the Product Owner.

### 3.13 Feature / Bugfix Implementer

- **Owns**: implementation of one feature or bug fix end-to-end — code, unit/integration tests, changelog entry — based on an approved design document.
- **Writes/approves**: code changes, unit/integration tests, changelog entry.
- **Decision rights**: local implementation choices inside the agreed interface (`A`); unit/integration test structure within the approved Test Plan (`R`, Senior QA `A`).
- **Consults**: Epic Owner (interface drift), Senior QA (coverage), Security Reviewer (sensitive paths), Bugfix Designer / Implementer (for bug fixes, on root cause and fix scope).
- **Hands off to**: Code Reviewer (PR), QA / Test Engineers (verification evidence).
- **Must not**: change a shared interface, schema, or NFR without the owning role's approval; merge its own PR without an independent review.

### 3.14 Bugfix Designer / Implementer

- **Owns**: the bug fix end-to-end — bug design document, code fix, and verification — from defect ticket to retest.
- **Writes/approves**: `<Bug ID>_bug_design.md` (see `templates/BUG_DESIGN_TEMPLATE.md`); code fix; changelog entry.
- **Decision rights**: root-cause analysis and fix scope (`A`); bug fix implementation approach within the agreed interface (`A`).
- **Consults**: QA / Test Engineer (reproduction steps, expected vs. actual), Lead QA (severity), Epic Owner (epic-level impact), Security Reviewer (if security-sensitive).
- **Hands off to**: Feature / Bugfix Implementer (code execution support), Code Reviewer (PR), QA / Test Engineers (retest evidence).
- **Must not**: file a bug ticket without reproduction steps; close a defect without retest evidence; approve its own bug design.

### 3.15 UI / UX Designer / Implementer

- **Owns**: user interface design, user experience flows, and accessibility compliance for features and bug fixes.
- **Writes/approves**: UI mocks, wireframes, frontend components, accessibility audit notes.
- **Decision rights**: UI/UX design decisions within brand and accessibility guidelines (`A`); component implementation approach (`A`).
- **Consults**: Product Owner (user needs), Solution Architect (technical feasibility), Security Reviewer (input validation, output sanitization), Feature / Bugfix Implementer (integration).
- **Hands off to**: Feature / Bugfix Implementer (frontend implementation), Code Reviewer (PR), QA / Test Engineers (UI test execution).
- **Must not**: ship UI changes without an accessibility review; approve its own design.

---

## 4. Artifact Ownership (RACI)

| Artifact | Product Owner | Business Analyst | Solution Architect | Epic Owner / Tech Lead | Feature Designer | Feature / Bugfix Implementer | Bugfix Designer / Implementer | UI / UX Designer / Implementer | Lead QA | Senior QA | QA / Test Engineer | Reviewer | DevOps | Docs | Security |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `*_HLD.md` | A | C | R | C | I | I | I | C | C | I | I | C | C | C | C |
| `*_LLD.md` | I | C | C | A/R | C | C | C | C | C | I | I | C | C | I | C |
| Feature Design | I | C | C | C | A | R | C | C | C | C | I | C | I | I | C |
| Bug Design | I | I | C | C | C | I | A/R | C | C | C | C | C | I | I | C |
| Test Plan | C | C | I | C | C | I | I | C | A/R | C | I | C | C | I | C |
| Test Cases | I | C | I | I | C | I | C | C | C | A/R | C | C | I | I | I |
| Bug ticket | I | I | I | I | C | C | I | I | C | C | C | A/R | I | I | I |
| Code change | I | I | C | C | A | R | C | R | I | I | I | C | I | I | C |
| Changelog entry | I | I | I | I | R | R | R | I | I | I | I | C | C | A | I |
| Release / rollback | A | I | C | C | C | I | I | I | C | C | I | I | C | R | C | C |
| `*_TEMPLATE.md` | I | I | C | C | C | I | I | I | C | C | C | C | C | A/R | C |
| `design_example/*` | I | I | C | C | C | I | I | I | C | C | C | C | C | A/R | C |

`R` may be delegated to an AI agent; `A` may not. Where one role holds `A/R`, the Document Control approver must be a different named person: Test Plan → Product Owner, Test Cases → Lead QA, Feature/Bug Design → Epic Owner, Bugfix Design → Epic Owner.

Defect-only rows: a `Bug ticket` is authored by the QA / Test Engineer who observed the failure, and its `Bug Design` is authored by the Bugfix Designer / Implementer — the separation is what keeps reproduction facts distinct from root-cause opinion.

---

## 5. Lifecycle Stage Ownership

Maps to the `mol-feature-lifecycle` DAG in [`README_FEATURE_LIFECYCLE.md`](./README_FEATURE_LIFECYCLE.md).

| Stage | Accountable | Responsible | Exit evidence |
| :--- | :--- | :--- | :--- |
| 1. Spec & Architecture | Product Owner | Solution Architect, Epic Owner | Approved HLD/LLD/design + requirement IDs |
| 2. Implementation | Epic Owner | Feature Designer, Feature / Bugfix Implementer / AI agent | Code + design doc + unit tests + changelog draft |
| 3. Automated Tests | Lead QA | Senior QA (case specification), Feature / Bugfix Implementer (unit/integration tests) | Approved Test Cases + green suite + coverage note in design §6 |
| 4. Docs & Changelog | Documentation | Feature / Bugfix Implementer, Docs, UI / UX Designer / Implementer | Updated docs + changelog entry |
| 5. Review & Gate (human) | Reviewer | Reviewer | Gate issue closed with PR reference |
| 6. Staging QA | Lead QA | QA / Test Engineers, UI / UX Designer / Implementer (UI verification) | Executed Test Cases with recorded results + a bug ticket for every failure |
| 7. Production Rollout | Product Owner | DevOps | Release note + rollback path verified |

Rules that bind the table:

- A stage may not start before its predecessor's exit evidence exists.
- The human gate at stage 5 cannot be closed by the author or by an AI agent.
- Skipping `docs` or `staging` (`skip_docs`, `skip_staging`) requires the Product Owner to record the rationale in the changelog entry.
- Every failure at stage 6 produces a bug ticket carrying the failing test-case ID. Lead QA confirms severity and the Product Owner sets priority; the fix re-enters at stage 2 and must be retested against the same case before the ticket closes.
- Stage 3 tests against the **approved** Test Plan and Test Cases; a case added after approval is re-reviewed by Senior QA before it can gate a release.

---

## 6. AI Agent Roles

Agents act inside the roles above. The mapping is deliberate: agents expand capacity, not authority.

| Agent mode | Acts as | Allowed | Not allowed |
| :--- | :--- | :--- | :--- |
| Plan / Architect | Solution Architect, Epic Owner (drafting) | Draft HLD/LLD/design sections, propose alternatives, run section-by-section dialogue | Approve a design; set its own status to Approved |
| Implement | Feature Designer, Feature / Bugfix Implementer | Write code, tests, changelog draft, update own design doc | Change a shared interface/schema unilaterally; commit or push without authority |
| Fix | Bugfix Designer / Implementer | Draft bug design, code fix, changelog draft, run reproduction steps | Approve its own bug design; close a defect without retest evidence |
| Design | UI / UX Designer / Implementer | Draft UI mocks, wireframes, frontend components, accessibility notes | Ship UI changes without an accessibility review; approve its own design |
| Test | Lead QA (planning), Senior QA (cases), QA / Test Engineer (execution) | Draft Test Plan sections and Test Cases, run cases, record evidence, file bug tickets | Waive a failed case; declare exit criteria met; close a defect without retest evidence |
| Review | Reviewer (advisory) | Review code and designs, raise findings | Close a human gate; approve its own work |
| Docs | Documentation (drafting) | Update guides and changelog, draft/modify templates and example documents | Publish release notes without owner review |
| Ops | DevOps (assisting) | Prepare CI/CD, manifests, runbooks | Deploy; rotate secrets; force-push |

Standing guardrails for every agent mode:

1. **Human accountability**: an agent never holds `A` on an artifact, gate, or release.
2. **Section-by-section**: HLDs and Test Plans are confirmed with the User before the next section.
3. **No self-approval**: an agent may not review, approve, or close its own output.
4. **Conservative git/sync**: no commits, pushes, or Dolt sync without explicit authority — see the Agent Context Profiles in [`AGENTS.md`](./AGENTS.md).
5. **Evidence over assertion**: "done" requires a command output, test run, or linked artifact.
6. **Escalate, don't invent**: unresolved ambiguity becomes an open question addressed to the owning human role.
7. **Reviewed by and Comments required**: every design document must include a "Reviewed by and Comments" section before its approval section, containing a Reviewers table (Reviewer / Role / Date / Comments) and a Comment Section (File location, Created Date, Modified Date).

---

## 7. Decision Rights & Escalation

| Decision | Owner (`A`) | Consult | Escalates to |
| :--- | :--- | :--- | :--- |
| Scope in / out | Product Owner | BA, Architect | Sponsor |
| Requirement wording | Business Analyst | Product Owner | Product Owner |
| Architecture and patterns | Solution Architect | Security, DevOps | CTO / architecture board |
| Epic decomposition | Epic Owner | Architect, Lead QA | Solution Architect |
| Feature-internal design | Feature Designer | Epic Owner | Epic Owner |
| Test strategy and exit criteria | Lead QA | Epic Owner, DevOps, Product Owner | Product Owner |
| Test-case design and coverage | Senior QA | Lead QA, Feature Designer | Lead QA |
| Test execution verdict (`Pass`/`Fail`/`Blocked`) | QA / Test Engineer | Senior QA, Lead QA | Lead QA |
| Defect severity and priority | Lead QA (severity), Product Owner (priority) | Feature Designer, Senior QA | Product Owner |
| Security acceptance | Security Reviewer | Architect | Sponsor (recorded risk) |
| Release go / no-go | Product Owner + DevOps | Lead QA, Security | Sponsor |
| Quality-gate exception | Reviewer | Lead QA, Product Owner | Product Owner (recorded) |
| Feature-internal implementation | Feature / Bugfix Implementer | Epic Owner | Epic Owner |
| Bug fix design and scope | Bugfix Designer / Implementer | Lead QA, Epic Owner | Lead QA |
| UI/UX design and accessibility | UI / UX Designer / Implementer | Product Owner, Security Reviewer | Product Owner |

**Conflict rule**: when two accountable roles disagree, the more conservative option wins until the escalation owner decides in writing (design doc, ADR, or changelog entry). Verbal or chat-only decisions are not binding.

---

## 8. Anti-Patterns

| Anti-pattern | Why it hurts | Countermeasure |
| :--- | :--- | :--- |
| Role blending on delivery | Same person designs, builds, and approves | Independent Reviewer; enforce §5 stage 5 |
| Architect writes the LLD | Epic-level detail gets skipped or rushed | Epic Owner owns the LLD |
| "QA at the end" | Testability discovered too late to fix | Lead QA consulted at spec time (§5 stage 1) |
| QA role collapse | One person plans, authors, executes, and declares pass | Separate Lead QA / Senior QA / QA Engineer duties; per-case evidence recorded |
| Unreproducible bug ticket | Developer cannot reproduce; triage time is lost | QA / Test Engineer attaches steps, expected vs. actual, build ID, logs |
| Verdict by expectation edit | A failing case is "fixed" by weakening its expected result | Expected results frozen at Senior QA sign-off; edits require re-review |
| Defect closed without retest | Unverified fix ships and the regression returns | QA / Test Engineer retests the same case; ticket closed with run reference |
| Ghost approver | Approval by someone who did not read the artifact | Named approver + date in Document Control |
| Agent-declared approval | Gate closed with no human decision | Human gate issue; agents advisory only |
| Orphan feature | Child feature nobody owns in the LLD | Named owner per row in LLD §3.3 |
| Rollback as an afterthought | Incident response improvises | Rollout plan requires documented rollback |
| Stale docs | Operators follow wrong behaviour | Docs role gates release (stage 4 → 7) |
| Implementer designs and approves own fix | No independent verification of bug fix | Bugfix Designer / Implementer must have separate reviewer; enforce §5 stage 5 |
| UI ships without accessibility review | Accessibility barriers reach production | UI / UX Designer / Implementer must pass accessibility review before merge |
| Designer-implementer role collapse | Same person designs UI and approves its own implementation | Separate UI / UX Designer / Implementer from Code Reviewer; independent review required |
| Loose task without an epic | Beads task exists with no epic parent; ownership and scope are unclear | Every task must be created with `--parent=<epic-id>`; create an epic first if none exists (`bd orphans` to surface) |
| New work started while an epic is open | Feature/chore work begun before the current epic completes; work-in-progress limit violated | Only bug fixes scoped to the current epic (or Product Owner-approved critical defects) may be started while an epic is open; new epics/features are blocked until the current epic is closed |
| HLD/LLD edited directly while Approved | Approved document changed without entering revision cycle; change control bypassed | Any change to an Approved design document must cycle through Revision → Review (Revision x.x) → Approved (Revision x.x); status moves to Draft v<x.x> / In Review v<x.x> |
| Document self-approved by author or AI agent | No independent verification; author approves own work | Separate human reviewer required; enforce gate review; agents advisory only per `roles.md` §6 guardrail 3 |
| Compliance/Ops/Documentation edited directly while Approved | Approved compliance/ops/documentation changed without entering revision cycle | Any change to an Approved compliance, ops, or documentation document must cycle through Revision → Review (Revision x.x) → Approved (Revision x.x) |

---

## 10. Design Document Lifecycle Phases (All Design Documents)

Every design document — HLD, LLD, Feature Design, Bug Design, Test Plan, Test Cases, Project Analysis, Compliance, Documentation, and Ops — passes through the following document-control phases, tracked on the Document Control block's status field:

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

**Drafting roles per document type:** HLD → `qwen3.5:Architect`; LLD → Epic Owner / Tech Lead (`qwen2.5-coder:3b`); Feature/Bug Design → Feature Designer / Bugfix Designer; Test Plan → Lead QA; Test Cases → Senior QA; Project Analysis → Documentation / InfoDev · `qwen3.5:Architect`; Compliance → Security / Compliance Reviewer; Documentation → Documentation / InfoDev; Ops → DevOps / Release Engineer. Approval remains a human (Rey Benavidez, A) decision per §1 and §6 guardrail 3.

---

## 9. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 2026-10-23 | Guidelines maintainer | Initial role catalogue, RACI matrices, lifecycle and agent-mode mapping. |
| 0.2 | 2026-10-23 | Guidelines maintainer | Split QA into Lead QA / Test Engineer (owns Test Plan), Senior QA / Test Engineer (owns Test Cases), and QA / Test Engineer (executes, verifies, files bug tickets); updated catalogue, RACI, lifecycle stages, decision rights, and anti-patterns. |
| 0.3 | 2026-10-23 | Guidelines maintainer | Added Feature / Bugfix Implementer, Bugfix Designer / Implementer, and UI / UX Designer / Implementer roles; updated Role Catalogue (§2), Role Definitions (§3.13–3.15), RACI matrix (§4), Lifecycle Stage Ownership (§5), AI Agent Roles (§6), Decision Rights (§7), and Anti-Patterns (§8). |
| 0.4 | 2026-10-29 | Guidelines maintainer | Extended Documentation / InfoDev role (§3.11) to own template and example library; added `*_TEMPLATE.md` and `design_example/*` rows to RACI matrix (§4); extended Docs agent mode (§6) to draft/modify templates and examples. |
| 0.5 | 2026-11-02 | Guidelines maintainer | Added Beads Epic Association & Work-Limit Rules: bugs fall under the epic they were fixed in (§8 anti-patterns); no loose beads tasks without an epic (§8 anti-patterns); no new work outside bug fixes until the current epic is complete (§8 anti-patterns). |
| 0.6 | 2026-11-02 | Guidelines maintainer | Added document lifecycle phases (§8 anti-patterns, §10 shared lifecycle): Draft → Review → Reviewed → Approved → Revision → Review (Revision x.x) → Reviewed (Revision x.x) → Approved (Revision x.x); expanded lifecycle to cover all design document types including Compliance, Documentation, and Ops; added anti-patterns for unrevised post-approval edits and self-approval. |
