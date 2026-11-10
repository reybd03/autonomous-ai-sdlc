# Test Plan Template

- File Name: `<Project Acronym>_TEST_PLAN.md` (or `<Feature>_TEST_PLAN.md`)
- File Location: `<Project Directory>/design/` (or alongside the feature design doc)
- Related High Level Design: `<Project Acronym>_HLD.md`
- Related Low Level Design: `<Epic ID>_LLD.md` (under `design/epic/`) *(optional)*
- Related Feature Design: `<Feature ID>_design_document.md`
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description — avoid no-op placeholder sections. Keep heading numbering consistent so reviewers can compare across plans. For auditability, complete the **Document Control** block before review.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – <Feature / Line Item> Test Plan |
| Version | <e.g. Test Plan V1.0> |
| Status | Draft \| In Review \| Reviewed \| Approved \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Document Owner | <name> (<email>) |
| Technical Contact | <name> (<email>) |
| Owning Department / Team | <team> |
| Source File Location | <path / repo> |
| Retention | <e.g. Current Year + 2 Years; Disposal: Delete> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |
| Mandatory Reviewers | <name – area – email – date> |
| Optional Reviewers | <name – area – email – date> |

---

## 1. Purpose

### 1.1 Overview
> State the purpose of this test plan and its scope (what is being tested and at what level).

### 1.2 Project Overview
> Brief description of the project/feature under test and its goals.

### 1.3 Test Objectives
> State the main test objectives (e.g. function verification, regression, performance, security). Identify the area of responsibility (unit, integration, E2E, system).

### 1.4 Process Rationale
> Indicate the processes/standards followed (e.g. team testing process, CI policy, quality gates). Reference where they are documented.

---

## 2. Key Test Dates

### 2.1 Test Plan Reviews
> Describe review phases (plan review, test case review, execution review) and dates. Note if new infrastructure affects the schedule.

---

## 3. Dependencies

### 3.1 Hardware / Infrastructure
> Describe test dependencies on hardware/infrastructure (devices, clusters, cloud resources). Indicate what testing depends on availability and the timeframe.

### 3.2 Software
> Describe dependencies on other programming areas/services needed for testing. Indicate testing types affected and availability timeframe.

### 3.3 Test Tools
> List test tools required (unit/integration frameworks, load testers, simulators, reporting). Note where they are available (CI, local, shared env).

---

## 4. Test Criteria

### 4.1 Test Entrance Criteria
> Describe entry criteria for hardware/software/infra for acceptance, regression, progression, and new-function testing.

### 4.2 Test Exit Criteria
> Describe exit criteria (pass rates, coverage thresholds, defect severity gates, performance SLOs).

### 4.3 Deviation from Criteria *(optional)*
> Describe any deviations from the standard test process needed to complete testing. Include approval from process owner if required.

### 4.4 Releases / Versions Tested
> List all releases/versions/environments tested during this test cycle.

---

## 5. Project Contacts

### 5.1 Development Contacts
> List components and their owners/managers affected by this plan.

| Name | Area of Responsibility | Email |
| :--- | :--- | :--- |
| <name> | <area> | <email> |

### 5.2 Test Contacts

| Name | Area of Responsibility | Email |
| :--- | :--- | :--- |
| <name> | Coordinator / Function Test / System Test | <email> |

### 5.3 Other Area Contacts *(optional)*

| Name | Area of Responsibility | Email |
| :--- | :--- | :--- |
| <name> | Driver Build / Integration / Product Management / InfoDev | <email> |

---

## 6. Team Member Assignments

### 6.1 Test Coverage and Support
> List each team's test coverage by component. Include all sub-components affected. List developers and testers per component.

| Component | Developer(s) | Tester(s) |
| :--- | :--- | :--- |
| <component> | <developers> | <testers> |

### 6.1.1 Additional Test Coverage *(optional)*
> List additional components tested by this team that do not belong to it.

| Component | Tester |
| :--- | :--- |
| <component> | <tester> |

---

## 7. Background Publications

> List all documents used as input into this test plan, test scenarios, and test cases (SLD, HLD, feature design, specs). HLD must be listed with version number. Update the version if it changes during the test phase.

| Title | Author / Department | Area |
| :--- | :--- | :--- |
| <Document title>, <version> | <name or team> | <group> |

---

## 8. Infrastructure / Environment Information

### 8.1 Test Infrastructure
> List all infrastructure and environments used to test this plan, including any changes required. Include container/VM/cloud details.

### 8.2 Environment Configuration *(optional)*
> Configuration details, seed data, feature flags, and setup steps.

---

## 9. Problem Reporting and Tracking

### 9.1 Defect Reporting
> Describe how defects are reported (tool, e.g. issue tracker). Include what information is needed to diagnose (failing tests, logs, dumps, usermod info, driver), dump naming conventions, defect numbering with project ID, and recommended field values.

### 9.2 Defect Triage *(optional)*
> Triage process, severity/priority definitions, and escalation.

---

## 10. Test Case Status Reporting and Tracking

### 10.1 Status Reporting
> Describe what status is recorded: total test cases, exposed, successful executions, open defects, S-curves, coverage metrics.

### 10.2 Status Tracking
> Indicate how test progress is tracked (databases, dashboards, CI reports). All line items should have an entry pointing to actual status.

---

## 11. Test Case Output Records

### 11.1 Output Records Location
> List locations used to store test case scripts and successful outputs for archiving (artifact store, CI artifacts, shared drives).

---

## 12. Software and Tooling Requirements

### 12.1 Test Tools
> List test tools and reporting tools required for writing and executing test cases and reporting results. Adapt to your stack.

| Tool | Purpose | Where Available |
| :--- | :--- | :--- |
| <tool> | <purpose> | <CI / local / shared> |

### 12.2 Platform / Runtime Software
> List platform/runtime software used in support of testing (e.g. OS, middleware, databases, message brokers).

---

## 13. Test Case Standards *(optional)*

### 13.1 Test Case Naming Convention
> Describe how test cases are named (e.g. `<component>-<feature>-<scenario>`). Keep consistent for searchability.

### 13.2 Test Case Construction
> Describe how test cases are constructed (unit/integration/E2E, fixtures, mocks, test data).

### 13.3 Test Library / Suite Naming Convention *(optional)*
> Describe how test suites/libraries are named.

---

## 14. Functional Characteristics Under Test

### 14.1 Testing Types Applicable
> Indicate which testing types apply for this plan. Typical categories:

| Type | Description |
| :--- | :--- |
| Acceptance | Minimal set ensuring primary function of new/modified components works and existing functions have not regressed. |
| Regression | Old function test cases/scenarios on available environments; reviewed with verified output from prior runs. |
| Progression | Regression cases updated for new environments/devices or new function. |
| New Function | New test cases/scenarios for new functions; not previously reviewed, no existing output. |

### 14.2 Functional Characteristics by Component
> List all testable functions by component, mapping to HLD/feature design sections.

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <function> | <description of test case or scenario> |

---

## 15. Interoperability *(optional)*

> Describe interoperability testing to validate claims made in the HLD. If no special considerations, state: "There are no special interoperability considerations introduced by this support."

---

## 16. Migration / Coexistence

### 16.1 Migration Considerations
> Migration: when system behavior differs from prior release, a migration action is required. List migration considerations to test (removal of functions, default changes, config changes, app modifications). Migration testing tracked separately from new function.

#### 16.1.1 Test Scenarios

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <function> | <description> |

#### 16.1.2 Migration Issues / Patches *(optional)*
> List issues/patches supplied for migration support.

| Issue / Patch | Component | Description |
| :--- | :--- | :--- |
| <id> | <component> | <description> |

### 16.2 Coexistence Considerations
> Coexistence: how this release coexists with other releases in a shared configuration (multi-node/cluster). List coexistence considerations to test.

#### 16.2.1 Test Scenarios

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <function> | <description> |

#### 16.2.2 Coexistence Issues / Patches *(optional)*
> List issues/patches supplied for coexistence support.

| Issue / Patch | Component | Description |
| :--- | :--- | :--- |
| <id> | <component> | <description> |

---

## 17. Support Use Information

### 17.1 General Support Use Information Considerations
> Items assisting customer use of new function (pre-integration activities, examples, usage scenarios). Correlates with HLD Support Use Information. List considerations to test.

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <function> | <description> |

### 17.2 Security *(optional)*
> Security relevant testing (Common Criteria, SOC 2, etc.). Verify authorized callers allowed and unauthorized callers denied. Applies if interface is restricted to authorized callers or has mixed authorization parameters.

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <function> | <description> |

---

## 18. Human Factors Characteristics *(optional)*

> List human factors / usability characteristics to test for this plan (UI flows, accessibility, error messages).

---

## 19. Messages and Codes

> List all messages and codes to be tested, or reference the HLD/feature doc chapter/section if all are included. Tag each as (New)/(Changed)/(Deleted).

| HLD / Feature Section | Message / Code | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <code> | <description> |

---

## 20. Cross-Component Interfaces *(optional)*

> Identify cross-component interfaces to be tested.

| HLD / Feature Section | Interface | Test Activities |
| :--- | :--- | :--- |
| <§ number> | <interface> | <description> |

---

## 21. Acceptance Test *(optional)*

> List information pertaining to acceptance test (minimal set ensuring primary function works and no regression).

---

## 22. Regression Test

> Include information applicable to regression testing (environments, devices, control units, scope).

---

## 23. Progression and New Function *(optional)*

> Include information applicable to progression and new function testing (environments, devices, control units).

---

## 24. Test Plan Checklist

> Indicate whether each item has been considered for your testing or is N/A. Adapt to your process.

| Type of Verification | Yes / N/A |
| :--- | :--- |
| Verify command output (tables, info) | |
| Reason code / text verification (message and operator response fit the failure) | |
| Contention verification | |
| Boundary testing (min/max, lower/upper limits, values in between, combinations) | |
| Multisystem processing | |
| Error injection | |
| Coverage — different users/callers of component | |
| Single vs. multi-instance/volume | |
| Multiple threads / workers / CPUs | |
| Test in different environments (CLI, UI, API) if applicable | |
| Verify output messages match docs | |
| Executable module sanity check | |
| "What we did not think of?" — think outside the box | |

---
---

## 24. Reviewed by and Comments

### 24.1 Reviewers

| Reviewer | Role | Date | Comments |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | <comments> |

### 24.2 Comment Section

- **File location**: `<Project Acronym>_<File Being Reviewed>_Comments.md`
- **Created Date**: `<YYYY-MM-DD>`
- **Modified Date**: `<YYYY-MM-DD>`

---

## Appendix: Test Environment Setup *(optional)*

> Setup steps, seed data, feature flags, container/compose commands, and teardown.