# Project Analysis Template

- File Name: `<Project Acronym>_Project_Analysis.md`
- File Location: `<Project Directory>/design/` or `<Project Directory>/design_example/`
- Programming Languages: <List of languages>
- Related High Level Design: `<Project Acronym>_HLD.md` *(optional)*
- Related Low Level Designs: `<Epic ID>_LLD.md` *(optional)*
- Table of Contents

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description — avoid leaving no-op placeholder sections (e.g. "not written", "no changes"). Keep heading numbering consistent so reviewers can compare across analyses. **Fill in every section through section-by-section confirmation with the User** — the model proposes, the User confirms, then the next section begins. For auditability, complete the **Document Control** block before review.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – Project Analysis |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Analysis Status | Draft \| In Review \| Reviewed \| Approved \| Superseded \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Latest Change Date | <MM/DD/YY> |
| Original Creation Date | <MM/DD/YY> |
| Document Owner | <name> (<email>) |
| Owner's Department / Location | <dept> / <location> |
| Export Classification | <code> |
| Document Retention | <e.g. Current Year + 2 Years; Disposal: Delete> |
| Required Approvers | <name – area of responsibility – email – date> |
| Stakeholders | <name – function – department – contact> |
| Related Beads Issues | <issue IDs> |

---

## 1. Executive Summary

### 1.1 Purpose
> State why this project analysis is being performed (e.g. new initiative, problem investigation, technical debt assessment, vendor evaluation). Identify the decision this analysis supports.

### 1.2 Problem Statement
> Describe the current-state limitation, pain point, or opportunity. Quantify impact where possible (cost, latency, risk, effort, customer impact).

### 1.3 Recommended Direction
> Summarize the recommended course of action and the high-level rationale. State whether the recommendation is to proceed, defer, pivot, or decline.

### 1.4 Key Deliverables
> Bulleted list of expected outputs from this project (documents, prototypes, code, migrations, decommissioning).

### 1.5 Success Criteria
> Measurable criteria that determine whether the project achieved its intended outcome.

---

## 2. Stakeholders & Requirements

### 2.1 Stakeholder Register

| Stakeholder | Role | Function | Department | Contact | Interest / Concern |
| :--- | :--- | :--- | :--- | :--- | :--- |
| <name> | <role> | <function> | <dept> | <email / slack> | <what they care about> |

### 2.2 Business Needs & Requirements

| Req ID | Requirement | Source | Priority | Acceptance Criteria |
| :--- | :--- | :--- | :--- | :--- |
| <REQ-*> | <requirement statement> | <ticket / RFC / stakeholder> | P1–P4 | <measurable pass condition> |

### 2.3 Out of Scope
> Explicitly list what this project will **not** deliver, to prevent scope creep.

---

## 3. Current State Assessment

### 3.1 Existing System / Process
> Describe the current architecture, components, data flows, and operational procedures relevant to this analysis. Reference existing design documents (`*_HLD.md`, `*_LLD.md`) where applicable.

### 3.2 Current Limitations
> List gaps, bottlenecks, single points of failure, manual toil, compliance gaps, or technical debt in the current state.

### 3.3 Baseline Metrics
> Capture current performance, cost, reliability, or operational metrics against which the project will be compared.

---

## 4. Options Analysis

### 4.1 Option A: <Option Name> (Recommended / Baseline)
> Description of the first option.

| Criterion | Assessment | Notes |
| :--- | :--- | :--- |
| Fit to requirements | High / Medium / Low | |
| Effort (person-weeks) | <estimate> | |
| Risk | High / Medium / Low | |
| Cost | <estimate> | |
| Timeline | <estimate> | |
| Dependencies | <list> | |
| Rollback feasibility | Yes / No / Partial | |

### 4.2 Option B: <Option Name>
> Description of the second option.

| Criterion | Assessment | Notes |
| :--- | :--- | :--- |
| Fit to requirements | High / Medium / Low | |
| Effort (person-weeks) | <estimate> | |
| Risk | High / Medium / Low | |
| Cost | <estimate> | |
| Timeline | <estimate> | |
| Dependencies | <list> | |
| Rollback feasibility | Yes / No / Partial | |

### 4.3 Option C: <Option Name> *(optional)*
> Description of the third option, or state "not applicable".

| Criterion | Assessment | Notes |
| :--- | :--- | :--- |
| Fit to requirements | High / Medium / Low | |
| Effort (person-weeks) | <estimate> | |
| Risk | High / Medium / Low | |
| Cost | <estimate> | |
| Timeline | <estimate> | |
| Dependencies | <list> | |
| Rollback feasibility | Yes / No / Partial | |

### 4.4 Decision Matrix & Rationale
> Summarize the comparison and state the selected option with the rationale. Reference any architectural constraints, NFR budgets, or policy decisions that drove the choice.

---

## 5. Technical Design Considerations

### 5.1 High-Level Architecture
> Mermaid diagram or textual description of the proposed architecture. Show module boundaries, interfaces, data flow, and integration points.

### 5.2 Components Affected
> Table of components, type of impact (new / modified / decommissioned), and estimated sizing (KLOC / person-months).

| Component | Impact | Est. Size | Owner |
| :--- | :--- | :--- | :--- |
| <name> | New / Modified / Decommissioned | <size> | <team> |

### 5.3 Non-Functional Requirements
| NFR | Target | Measurement Method | Owner |
| :--- | :--- | :--- | :--- |
| Performance / Latency | <target> | <how measured> | <role> |
| Availability / SLO | <target> | <how measured> | <role> |
| Scalability | <target> | <how measured> | <role> |
| Security | <target> | <how measured> | <role> |
| Compliance | <target> | <how measured> | <role> |
| Operability | <target> | <how measured> | <role> |

### 5.4 Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation | Owner |
| :--- | :--- | :--- | :--- | :--- |
| <risk> | High / Med / Low | High / Med / Low | <mitigation steps> | <role> |

### 5.5 Dependencies & Prerequisites
> List upstream/downstream dependencies, required changes in other components, and prerequisite work.

---

## 6. Rollout & Rollout Plan

### 6.1 Rollout Approach
> Describe the rollout strategy (big bang, phased, canary, blue-green, feature flags), target environments, and rollout schedule.

### 6.2 Rollback Plan
> Describe the rollback trigger conditions, rollback steps, rollback feasibility, and data migration considerations if rolling back.

### 6.3 Communication Plan
> List stakeholder notifications, training needs, and cutover communication.

---

## 7. Resource & Effort Estimate

| Activity | Owner | Est. Effort | Target Dates |
| :--- | :--- | :--- | :--- |
| <activity> | <role> | <person-weeks> | <start – end> |

### 7.1 Total Estimated Effort
> <total person-weeks>

### 7.2 Required Skillsets
> List required roles/skills (e.g. Solution Architect, Lead QA, DevOps, Security Reviewer).

---

## 8. Decision & Approval

### 8.1 Decision
> State the approved direction (proceed / defer / pivot / decline) and any conditions of approval.

### 8.2 Approval Sign-off

| Approver | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | Approved / Rejected / Requires Rework |

### 8.3 Conditions of Approval *(if applicable)*
> Conditions that must be met before work begins.

---

## 9. Follow-Up Actions

| Action | Owner | Due Date | Status |
| :--- | :--- | :--- | :--- |
| <action> | <name> | <YYYY-MM-DD> | Open / In Progress / Closed |

---

## 10. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
