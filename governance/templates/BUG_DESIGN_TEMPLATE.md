# Bug Design Template

- File Name: `<Bug ID>_bug_design.md` (e.g. `ntf-bug-42_bug_design.md`)
- File Location: `<Project Directory>/design/epic/bugs/`
- Related High Level Design: `<Project Acronym>_HLD.md`
- Related Low Level Design: `<Epic ID>_LLD.md` (under `design/epic/`) *(optional)*
- Related Beads Issue / Bug: `<issue-id>`
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder. Bug designs are lighter than feature designs — focus on reproduction, root cause, fix, and verification. Sections marked *(optional)* may be omitted but justify omissions. Fill in through constant User–AI communication, section by section.

## Document Control *(optional — recommended for larger bugs)*

| Field | Value |
| :--- | :--- |
| Version | <e.g. v0.1> |
| Status | Draft \| In Review \| Reviewed \| Approved \| Fixed \| Verified \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Author | <name> (<email>) |
| Reviewers | <names> |

---

## 1. Header / Metadata

- **Title**: <Short, descriptive bug title>
- **Bug ID**: `<project>-bug-<n>` (e.g. `ntf-bug-42`)
- **Related Issue / Epic**: `<issue-id>` / `<parent-epic-id>` (**required** — the epic the bug was fixed in; no loose, epic-less bugs)
- **Status**: Open | In Progress | Fixed | Verified | Closed
- **Severity**: Sev-1 (critical) | Sev-2 (high) | Sev-3 (medium) | Sev-4 (low)
- **Priority**: P1 | P2 | P3 | P4
- **Author**: <name>
- **Reviewers**: <names>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Affected Modules / Components**: <list>
- **Target Languages / Runtimes**: <e.g. TypeScript (Node.js 20)>
- **Framework Stack**: <e.g. Fastify 4, Prisma 5>

---

## 2. Problem Description

### 2.1 Summary
> One-paragraph description of the bug and its user-facing impact.

### 2.2 Steps to Reproduce
1. <step 1>
2. <step 2>
3. <step 3>

### 2.3 Expected Behavior
> What should happen.

### 2.4 Actual Behavior
> What actually happens (include error messages, logs, screenshots).

### 2.5 Frequency / Impact
> Always / intermittent; number of users/requests affected; data loss? downtime?

---

## 3. Environment

- **Environment**: <dev / staging / prod>
- **Version / Build**: <version or commit>
- **Configuration**: <relevant config, feature flags>
- **Dependencies**: <services, DB, cache>

---

## 4. Root Cause Analysis

### 4.1 Investigation
> What was investigated and how (logs, traces, reproduction, code review).

### 4.2 Root Cause
> The underlying cause. Be specific (file, function, condition).

### 4.3 Contributing Factors *(optional)*
> Related code smells, missing tests, config drift, etc.

---

## 5. Fix Design

### 5.1 Proposed Fix
> Describe the change. Include code snippets if helpful.

### 5.2 Affected Files / Modules
- `<file>`: <change>

### 5.3 Design Patterns Used *(optional)*
> For each pattern applied in the fix, provide:
> - **Pattern Name**: <e.g. Repository, Strategy>
> - **Pattern**: <Mermaid diagram or reference>
> - **Why Chosen**: <rationale>

### 5.4 Alternatives Considered *(optional)*
- <Alternative>: <why rejected>

### 5.5 Rollback / Feature Flag Plan *(optional)*
- **Reversibility**: <can the fix be reverted; steps>
- **Data Migration Rollback**: <if applicable>

---

## 6. Impact Analysis

### 6.1 Affected Components
> List components/modules touched and downstream consumers.

### 6.2 Performance / Security Impact *(optional)*
> Any perf or security implications.

### 6.3 Backward Compatibility
> Breaking changes? Migration needed?

---

## 7. Quality Assurance & Verification

### 7.1 Reproduction Verification
> Confirm the bug is reproducible before fix; confirm fixed after.

### 7.2 Regression Tests Added
> List new/updated tests that prevent recurrence.

### 7.3 Quality Gates Executed

```bash
# <gate 1>
<command 1>
```

### 7.4 Test Matrix

| Module / Component | Build Status | Test Count | Test Pass Rate |
| :--- | :--- | :--- | :--- |
| `<module>` | `Pass` / `Fail` | <n> | <n>/<n> |

---

## 8. Risks & Open Questions

### 8.1 Risks
- <risk and mitigation>

### 8.2 Open Questions
- <question and owner>

---
---

## 9. Reviewed by and Comments

### 9.1 Reviewers

| Reviewer | Role | Date | Comments |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | <comments> |

### 9.2 Comment Section

- **File location**: `<Project Acronym>_<File Being Reviewed>_Comments.md`
- **Created Date**: `<YYYY-MM-DD>`
- **Modified Date**: `<YYYY-MM-DD>`

---

## 10. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
| 0.2 | 2026-11-02 | Guidelines maintainer | Made `Related Issue / Epic` field **required** — every bug design must declare the epic it was fixed in; no loose, epic-less bugs permitted. |