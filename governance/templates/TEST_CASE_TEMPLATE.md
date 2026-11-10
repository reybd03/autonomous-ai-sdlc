# Test Case Template

- File Name: `<Project Acronym>_TEST_CASES.md` (or `<Feature ID>_test_cases.md`)
- File Location: `<Project Directory>/design/` (or `tests/`)
- Related Test Plan: `<Project Acronym>_TEST_PLAN.md`
- Related High Level Design: `<Project Acronym>_HLD.md`
- Related Low Level Design: `<Epic ID>_LLD.md` (under `design/epic/`) *(optional)*
- Related Feature Design: `<Feature ID>_design_document.md`
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder. One test case per row in the tables below, or one subsection per test case. Sections marked *(optional)* may be omitted but justify omissions. Keep IDs consistent with the naming convention so reviewers can trace and search.

## Document Control *(optional)*

| Field | Value |
| :--- | :--- |
| Version | <e.g. v1.0> |
| Status | Draft \| In Review \| Reviewed \| Approved \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Author | <name> (<email>) |
| Reviewers | <names> |

---

## 1. Test Case Naming Convention

> Format: `<component>-<feature>-<scenario>` or `<AREA><YY><SEQ>` (e.g. `pref-api-optout-blocks-marketing`, `NTF-001`). Keep consistent across the project for searchability. Encode component/feature/sequence.

---

## 2. Test Case Index

> Optional: a quick index of all test case IDs grouped by feature area.

| Area | ID Range | Count |
| :--- | :--- | :--- |
| <feature area> | <ID range> | <n> |

---

## 3. Test Case Specification

> Each test case uses the fields below. Provide one subsection per test case, or one row in the summary table plus a detail block.

### 3.1 Test Case Template (per case)

- **ID**: `<test case id>`
- **Title**: <short descriptive title>
- **HLD / Feature Ref**: <§ reference, e.g. ntf-pref.1 §5.1>
- **Type**: Unit | Integration | E2E | Performance | Security | Acceptance | Regression
- **Priority**: P1 (critical) | P2 (high) | P3 (medium) | P4 (low)
- **Automation Status**: Automated | Manual | To be automated
- **Owner**: <name>
- **Preconditions**: <environment, data, feature flags, auth state>
- **Test Data**: <inputs, fixtures, seed data>
- **Steps**:
  1. <step 1>
  2. <step 2>
- **Expected Results**: <observable outcomes, messages, status codes, side effects>
- **Actual Results / Status**: <filled during execution; Pass/Fail/Blocked>
- **Defects**: <links to issue tracker, not embedded notes>

### 3.2 Test Case Summary Table *(optional)*

| ID | Title | Type | Priority | Status |
| :--- | :--- | :--- | :--- | :--- |
| `<id>` | <title> | <type> | <P1–P4> | Pass / Fail / Blocked / Not Run |

---

## 4. Acceptance Tests *(optional)*

> Smoke/primary-function scenarios that must pass to accept the feature.

### 4.1 <Acceptance Test ID>
- **ID**: `<id>`
- **Title**: <title>
- **Preconditions**: <...>
- **Steps**: <...>
- **Expected Results**: <...>

---

## 5. Authorization / Permission Matrix *(optional)*

> For features with role-based access, list roles × functions × allowed access level.

| Function / Endpoint | Role A | Role B | Role C |
| :--- | :--- | :--- | :--- |
| <function> | read / write / admin / denied | ... | ... |

Legend: `r` = read, `w` = write, `a` = all, `x` = catch-all/authorization check, blank = no access.

---

## 6. Boundary & Negative Test Cases *(optional)*

> Boundary values, invalid inputs, and error paths. Tag each as boundary/negative.

### 6.1 <ID>
- **ID**: `<id>`
- **Type**: Boundary | Negative
- **Input**: <value>
- **Expected**: <error code / message / behavior>

---

## 7. Regression Test Cases *(optional)*

> Existing behavior that must remain unchanged. Reference prior test IDs.

---

## 8. Traceability Matrix

> Map test cases to requirements / HLD / feature sections.

| Test Case ID | Requirement / HLD § / Feature § | Coverage |
| :--- | :--- | :--- |
| `<id>` | <ref> | <what it verifies> |

---

## 9. Test Environment & Setup *(optional)*

> Setup steps, seed data, feature flags, container/compose commands, and teardown.

```bash
# setup
<commands>

# run
<commands>
```

---

## 10. Reviewed by and Comments

### 10.1 Reviewers

| Reviewer | Role | Date | Comments |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | <comments> |

### 10.2 Comment Section

- **File location**: `<Project Acronym>_<File Being Reviewed>_Comments.md`
- **Created Date**: `<YYYY-MM-DD>`
- **Modified Date**: `<YYYY-MM-DD>`

---

## 11. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |