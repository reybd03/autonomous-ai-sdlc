# Design Document Review Comments Template

- File Name: `<Project Acronym>_<File Being Reviewed>_Comments.md`
- File Location: `<Project Directory>/design/` or `<Project Directory>/design/comments/`
- Related Design Document: `<Project Acronym>_<File Being Reviewed>.md`
- Related Review File: `<epic>_<doc-level>_<review-number>.md`
- Programming Languages: N/A
- Table of Contents

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – `<File Being Reviewed>` Review Comments |
| Document Number / Name | `<entry in project database>` |
| Version | `<e.g. v1.0>` |
| Comments Status | `<Draft | In Review | Approved | Superseded>` |
| Latest Change Date | `<MM/DD/YY>` |
| Original Creation Date | `<MM/DD/YY>` |
| Comment Owner | Rey Benavidez (Owner / Product Owner) |
| Owner's Department / Location | Product / Remote |
| Export Classification | `<code>` |
| Document Retention | `<e.g. Current Year + 2 Years; Disposal: Delete>` |
| Required Approver | Rey Benavidez (Owner / Product Owner) |
| Related Beads Issues | `<issue IDs>` |

> **Note:** Rey Benavidez (Owner / Product Owner) is the required owner and approver of this comment document. AI agents may fill in Document Control fields except for the Required Approver and Comment Owner fields, which are fixed to Rey Benavidez.

---

## 1. Reviewers

| Reviewer | Role | Review Date |
| :--- | :--- | :--- |
| Rey Benavidez | Owner / Product Owner | <YYYY-MM-DD> |
| <name> | <role> | <YYYY-MM-DD> |

> **Note:** Rey Benavidez (Owner / Product Owner) must always be the first reviewer listed. AI models may add additional reviewers below Rey Benavidez (2.2, 2.3, etc.), but may not remove or reorder Rey Benavidez's entry (2.1).

---

## 2. Review Sections

### 2.1 Rey Benavidez — Owner / Product Owner

> **AI agents must not edit this subsection.** Only Rey Benavidez (Owner / Product Owner) may complete this section.

#### 2.1.1 Review Summary

> <Short summary of the review outcome (e.g., "Approved", "Requires Rework", "Rejected") with high-level rationale.>

**Overall Quality Score: <score>/10**

---

### 2.2 <Reviewer Name> — <Role>

> **AI models may complete their own subsection here.** Rey Benavidez's section (2.1) is completed only by Rey Benavidez.

#### 2.2.1 Review Summary

> <Short summary of the review outcome (e.g., "Approved", "Requires Rework", "Rejected") with high-level rationale.>

**Overall Quality Score: <score>/10**

---

### 2.3 <Reviewer Name> — <Role>

> **AI models may add additional subsections (2.3, 2.4, etc.) for each additional reviewer.**

#### 2.3.1 Review Summary

> <Short summary of the review outcome (e.g., "Approved", "Requires Rework", "Rejected") with high-level rationale.>

**Overall Quality Score: <score>/10**

---

## 3. Beads Tracking

| Field | Value |
| :--- | :--- |
| Parent Epic | `<epic-id>` — <epic name> |
| Phase Epic | `<epic-id>.<n>` — <epic name> |
| Task | `<epic-id>.<n>.<m>` — <task name> |
| Task Status | `<Open | In Progress | Closed>` |
| Related Review File | `<epic>_<doc-level>_<review-number>.md` |
| Related Design Document | `design/<Project Acronym>_<File Being Reviewed>.md` |
| Review Comments File | `design/<Project Acronym>_<File Being Reviewed>_Comments.md` |

---

## 4. Missing Sections or Incomplete Content

| # | Finding | Details & Severity |
| :--- | :--- | :--- |
| 1.0 | <finding title> | **<Severity>**. <description> |
| 2.0 | <finding title> | **<Severity>**. <description> |

> AI models may add new findings to this section but may not remove, delete, or alter comments or findings left by other reviewers (including Rey Benavidez). AI models may only fill in empty rows or append new rows to this table.

---

## 5. Ambiguous Requirements or Unclear Specifications

1. <requirement title>: <description of ambiguity>
2. <requirement title>: <description of ambiguity>

> AI models may add new ambiguous requirements to this list but may not remove, delete, or alter requirements identified by other reviewers (including Rey Benavidez). AI models may only fill in empty items or append new items to this list.

---

## 6. Deviations from Template Conventions

| Section | Convention Violation | Impact |
| :--- | :--- | :--- |
| <section> | <violation description> | <impact description> |

> AI models may add new deviations to this table but may not remove, delete, or alter deviations identified by other reviewers (including Rey Benavidez). AI models may only fill in empty rows or append new rows to this table.

---

## 7. Specific Recommendations for Improvement

### A. <Recommendation Category>
* <recommendation detail>

### B. <Recommendation Category>
* <recommendation detail>

> AI models may add new recommendations to this section but may not remove, delete, or alter recommendations made by other reviewers (including Rey Benavidez). AI models may only fill in empty recommendation categories (A–D) or append new recommendation categories to this section.

---

## 8. Role-Specific Findings & Validation

### <Reviewer Name> (<Role>)
* <finding detail>

### <Reviewer Name> (<Role>)
* <finding detail>

> AI models complete their own reviewer subsection here. Rey Benavidez completes his subsection as Owner / Product Owner. **AI agents must not write Rey Benavidez's subsection and must not remove, delete, or alter comments left by Rey Benavidez or other reviewers.** AI models may only fill in empty reviewer subsections or append new reviewer subsections to this section.

**Overall Quality Score: <score>/10**

---

## 9. Key Improvements
- <improvement 1>
- <improvement 2>

> AI models may add new improvements to this list but may not remove, delete, or alter improvements noted by other reviewers (including Rey Benavidez). AI models may only fill in empty list items or append new items to this list.

---

## 10. Owner Approval Methodology

> **AI agents must not edit Section 10.** Only Rey Benavidez (Owner / Product Owner) may complete this section. AI models may observe but not modify any content in §10.

### 10.1 Approval Criteria
A suggested change is considered **approved** (approved for implementation) when ALL of the following are met:

1. **Owner Review**: Rey Benavidez (Owner / Product Owner) has read and understood the suggested change.
2. **Impact Acceptance**: The impact of the change on scope, timeline, or resources is acceptable.
3. **Documentation Update**: The design document (`<Project Acronym>_<File Being Reviewed>.md`) has been updated to reflect the change.
4. **Comment Acknowledgment**: This comment document has been updated to reflect resolution of the comment.

### 10.2 Approval Procedure

1. **Review**: Rey Benavidez reviews each suggested change in Sections 4–7 of this document.
2. **Decision**: For each change, Rey Benavidez marks it as one of:
   - **Approved** — Approved for implementation as-is
   - **Approved with Modification** — Approved but requires changes before implementation
   - **Rejected** — Not approved; requires rework or withdrawal
   - **Deferred** — Postponed to a future version/phase
3. **Record**: Record the decision in the Approval Register below.
4. **Update**: Update the design document (`<Project Acronym>_<File Being Reviewed>.md`) to reflect approved changes.
5. **Close**: Close this comment document when all changes are approved, rejected, or deferred.

### 10.3 Approval Register

| Change ID | Description | Decision | Approved By | Date | Comments |
| :--- | :--- | :--- | :--- | :--- | :--- |
| | | | | | |

### 10.4 Approval Confirmation

I, Rey Benavidez (Owner / Product Owner), hereby approve the following suggested changes as recorded in Section 10.3:

| Change ID | Decision | Signature | Date |
| :--- | :--- | :--- | :--- |
| | | Rey Benavidez | |

---

## 11. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
