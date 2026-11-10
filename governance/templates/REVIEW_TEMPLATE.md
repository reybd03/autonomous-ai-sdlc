# Review Template

- File Name: `<Project Acronym>_REVIEW.md` or `<Artifact ID>_review.md` (e.g. `ntf-pref.1_review.md`, `ntf_code_review.md`)
- File Location: `<Project Directory>/design/epic/reviews/` or `<Project Directory>/reviews/` — see `design_example/epic_example/reviews_example/ntf_review.md`
- Related High Level Design: `<Project Acronym>_HLD.md`
- Related Low Level Design: `<Project Acronym>_<Epic ID>_LLD.md`
- Related Feature Design: `<Feature ID>_design_document.md`
- Related Bug Design: `<Bug ID>_bug_design.md`
- Related Test Plan: `<Project Acronym>_TEST_PLAN.md`
- Related Test Cases: `<Feature ID>_test_cases.md`
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. This template covers design reviews, code reviews, and gate reviews. The reviewer must push back on unacceptable artifacts with specific, actionable comments and a concrete path forward — never rubber-stamp substandard work. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – <Review Name> |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Review Status | Draft \| In Review \| Approved \| Rejected \| Requires Rework |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Reviewer | <name> (<email>) |
| Review Type | <e.g. design review, code review, gate review, security review, compliance review> |
| Owning Department / Team | <team> |
| Source File Location | <path / repo> |
| Retention | <e.g. Current Year + 2 Years; Disposal: Delete> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |
| Mandatory Reviewers | <name – area – email – date> |

---

## 1. Header / Metadata

- **Title**: <Short, descriptive review title>
- **Review ID**: `<project>-review-<n>` (e.g. `ntf-review-01`)
- **Artifact Under Review**: <file path or artifact name, e.g. `design_example/epic_example/features_example/ntf-pref.1_design_document.md`>
- **Artifact Version**: <version of artifact being reviewed>
- **Parent High Level Design**: `<Project Acronym>_HLD.md` *(optional)*
- **Parent Low Level Design**: `<Project Acronym>_<Epic ID>_LLD.md` *(optional)*
- **Parent Feature Design**: `<Feature ID>_design_document.md` *(optional)*
- **Status**: Draft \| In Review \| Approved \| Rejected \| Requires Rework
- **Review Type**: <e.g. design review, code review, gate review, security review, compliance review>
- **Reviewer**: <name>
- **Reviewers**: <names>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Target Audience**: <e.g. author, epic owner, gate approver>
- **Affected Modules / Components**: <list>

---

## 2. Review Scope

### 2.1 Artifacts Reviewed
> List all artifacts reviewed in this session.

| Artifact | Path | Version | Sections Reviewed |
| :--- | :--- | :--- | :--- |
| <artifact name> | <path> | <version> | <sections> |

### 2.2 Review Criteria
> List the criteria against which artifacts were evaluated (project conventions, template requirements, architectural best practices, security standards, etc.).

- <criterion 1>
- <criterion 2>

### 2.3 Review Method
> Describe how the review was conducted (walkthrough, automated tools, checklist, etc.).

- <method 1>
- <method 2>

---

## 3. Findings

> Each finding should reference the specific artifact, section, and line where applicable. Use the push-back model: if a finding makes the artifact unacceptable, it must include specific, actionable comments and a concrete path forward.

### 3.1 Acceptable Items
> Items that meet project standards and require no changes.

| ID | Artifact | Section | Description | Status |
| :--- | :--- | :--- | :--- | :--- |
| <id> | <artifact> | <section> | <description> | Approved |

### 3.2 Minor Issues
> Items that should be addressed but do not block approval.

| ID | Artifact | Section | Severity | Description | Recommended Fix |
| :--- | :--- | :--- | :--- | :--- | :--- |
| <id> | <artifact> | <section> | Low/Medium | <description> | <fix> |

### 3.3 Major Issues (Blocking)
> Items that make the artifact unacceptable and must be resolved before approval.

| ID | Artifact | Section | Severity | Description | Required Action |
| :--- | :--- | :--- | :--- | :--- | :--- |
| <id> | <artifact> | <section> | High/Critical | <description> | <action> |

### 3.4 Template Compliance
> Verify against the relevant template (HLD, LLD, Feature Design, Test Plan, etc.).

| Template Section | Present | Compliant | Notes |
| :--- | :--- | :--- | :--- |
| <section name> | Yes / No | Yes / No | <notes> |

---

## 4. Push-Back Summary

> If any major issues were found, this section summarizes what must change before the artifact can be approved. Do not rubber-stamp substandard work.

### 4.1 Rejection Criteria
> List specific reasons the artifact is unacceptable (if applicable).

- <reason 1>
- <reason 2>

### 4.2 Required Changes
> List concrete changes required to make the artifact acceptable.

| # | Change | Artifact | Section | Owner | Due Date |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | <change description> | <artifact> | <section> | <name> | <YYYY-MM-DD> |

### 4.3 Concrete Path Forward
> Describe specific steps the author should take to remediate findings, including template sections to add, patterns to apply, or code changes to make.

> <detailed remediation steps>

---

## 5. Review Decision

### 5.1 Decision
> State the overall review decision.

- [ ] **Approved** — artifact meets all standards; no changes required.
- [ ] **Approved with Minor Comments** — artifact approved; minor issues should be addressed in follow-up.
- [ ] **Requires Rework** — artifact must be updated and resubmitted for review.
- [ ] **Rejected** — artifact is unacceptable; major rework required before resubmission.

### 5.2 Reviewer Sign-off

| Reviewer | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | <Approved / Rejected / Requires Rework> |

### 5.3 Conditions for Approval *(if applicable)*
> Conditions that must be met before the artifact is considered approved.

- <condition 1>
- <condition 2>

---

## 6. Follow-Up Actions

> List actions to be taken after the review, including re-review scheduling.

| Action | Owner | Due Date | Status |
| :--- | :--- | :--- | :--- |
| <action> | <name> | <YYYY-MM-DD> | Open / In Progress / Closed |

---

## 7. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
