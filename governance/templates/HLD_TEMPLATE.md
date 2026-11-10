# High Level Design Template

- File Name: `<Project Acronym>_HLD.md`
- File Location: `<Project Directory>/design/`
- Programming Languages: <List of languages>
- Related Low Level Designs: `<Epic ID>_LLD.md` (under `design/epic/`)
- Table of Contents

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description — avoid leaving no-op placeholder sections (e.g. "not written", "no changes"). Keep heading numbering consistent so reviewers can compare across designs. For auditability, complete the **Document Control** block before review.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – <Feature / Line Item Name> HLD |
| Document Number / Name | <entry in project database> |
| Version | <e.g. HLD V1.0> |
| Design Status | Draft \| In Review \| Reviewed \| Approved \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Latest Change Date | <MM/DD/YY> |
| Original Creation Date | <MM/DD/YY> |
| Document Owner | <name> (<email>) |
| Owner's Department / Location | <dept> / <location> |
| Export Classification | <code> |
| Document Retention | <e.g. Current Year + 10 Years; Disposal: Delete> |
| Required Approvers | <name – area of responsibility – email – date> |
| Stakeholders | <name – function – department – contact> |

---

## 1. Introduction and Objectives
### 1.1 Design Overview
> Describe what the feature/line item delivers, the problem it solves, the current-state limitation, and the desired end state. Include a short bulleted list of key deliverables. State whether it is optional/exploitable and whether a legacy configuration is retained for backward compatibility.
### 1.2 Target Customer Environment
> Describe the customer environments where this can be used (e.g. test vs. production, node/cluster consolidation, service providers). Note who benefits (platform engineers, storage admins, app developers).
### 1.3 Customer and Business Needs Satisfied
> List the customer requirements being addressed with their source (requirement IDs, tickets, RFCs). Explain business value (e.g. isolation, consolidation, cost). Note any secondary benefits.
### 1.4 User Stories and Use Cases
> Either write user stories/use cases, or explicitly state "not written" with rationale. Prefer writing at least 1-2 use cases for external-facing features.
### 1.5 Prerequisites, Corequisites, and Dependencies
> List dependencies on other components (storage layer, admin console, CLI tooling, ops dashboard, build/asset tooling, etc.) with specific required changes (new fields, config variables, panel/screen changes, commands). Use boxed INTERNAL LEVEL DETAIL callouts for deep implementation notes.
### 1.6 Delivery/Rollback Plan
> State the target release/version. State whether rollback is feasible and why (or why not), given the magnitude of changes and dependencies.
### 1.7 Exploiters (Consumers / Dependents)
> Identify software products (first-party, vendor, customer-written) that may exploit this. Note whether exploitation is optional and whether existing apps need updates. Note any environments where exploitation is not required (e.g. specific runtime hosts).
### 1.8 Components Affected and Sizing *(optional)*
> Table of affected components, type of impact, and sizing (KLOC/PM) or link to the planning repository. Include components beyond the primary one.
### 1.9 Risks
> Identify inherent risks (magnitude of change, dependencies, un-architected-for scenarios). List mitigations (prototyping, extended test cycles, close component collaboration).
### 1.10 Vendor Product Considerations *(optional)*
> State whether there are incompatible changes for vendor application programs. Note whether vendors may optionally exploit the feature.
### 1.11 Intellectual Property
> State whether the design includes patentable innovations or other licensable IP.
### 1.12 Bibliography
> List prior/related documents (SLD, prior HLDs, specs) with where to find them (databases, repositories). Include any LLDs (`design/epic/<Epic ID>_LLD.md`) derived from this HLD.

## 2. Architecture Overview
### 2.1 Project Module Hierarchy
> Mermaid diagram of modules/components and their dependencies, annotated with design patterns. Show containers, shared libs, services, and legacy bridges. Include ports for deployables.
### 2.2 File System Layout
> Tree of the project root showing top-level files, shared/, services/, and legacy modules, with brief annotations per directory.

### 2.3 Design Patterns Used *(optional)*
> For each pattern applied in the design, provide:
> - **Pattern Name**: <e.g. API Gateway, Repository, Circuit Breaker, Event-Driven>
> - **Pattern**: <Mermaid diagram or reference to `*_patterns*.md`>
> - **Why Chosen**: <rationale — problem addressed, trade-offs, alternatives rejected>

#### 2.3.1 <Pattern Name>
> **Pattern**: <Mermaid diagram>
> **Why Chosen**: <rationale>

## 3. Impacts on Products Attributes
### 3.1 Installation Considerations
> List customer installation/exploitation activities (config/deployment manifest updates, DB setup, policy rules, admin console changes, storage bucket/volume definitions). Note optional vs. required steps. Use INTERNAL LEVEL DETAIL callouts for deep implementation notes.
### 3.2 Reliability, Availability, and Serviceability Considerations
> State whether RAS characteristics change. If unchanged, say so explicitly.
### 3.3 Migration Actions
> List required migration actions, or state none. Reference installation section for optional actions.
### 3.4 Coexistence Considerations
> Describe release-level toleration, coexistence patches/hotfixes, mixed-release/cluster scenarios, and behavior matrices. Note failure modes if coexistence is not in place.
### 3.5 Performance Considerations
> Identify expected performance impact and key focus areas. State whether a performance test is needed (see 3.9.4).
### 3.6 Security Considerations
> State security implications, or explicitly "none".
### 3.7 Usability Considerations
> New concepts/tasks introduced for platform engineers, operators, and app developers.
### 3.8 Accessibility Considerations
> State whether accessibility characteristics change.
### 3.9 Testability Considerations
#### 3.9.1 Test Environment
> Describe hardware/software/test drivers needed (DB instances, storage backends, application programs). Note sample programs added/changed.
#### 3.9.2 Test Scenarios
> Enumerate configuration variants to test (legacy vs. new, subsystem-only, cluster combos). Include tables of variants and runtime environments. Note switching methods (restart vs. dynamic commands).
#### 3.9.3 System Integrity Testing Considerations
> State whether specific system-integrity testing is required.
#### 3.9.4 Performance Test Requirements
> Describe targeted performance tests (workload, metrics, comparison baseline, tuning hints).
#### 3.9.5 Regression Testing
> Scope of regression testing across all variants; list minimum areas to exercise (APIs, commands, management functions, storage hierarchy, cluster, restart, switching).
### 3.10 Globalization Considerations *(optional)*
> State i18n/conformance to existing component characteristics.
### 3.11 Health Check Considerations
> State whether new/changed health checks or migration health checks are introduced.
### 3.12 Common Criteria Considerations *(optional)*
> State impact on security certification (e.g. Common Criteria, SOC 2, ISO 27001).

## 4. External Design
### 4.1 APIs, Callable Services, and Macros
> Document API changes (new/changed parameters, return/reason codes). Include keyword parameter descriptions.
### 4.2 Commands
> Document command changes (CLI, operator, admin tools, etc.) with syntax and examples.
### 4.3 User Interfaces
> Admin console, GUI, web UI changes and help text.
### 4.4 Environment Variables
> New/changed environment variables.
### 4.5 Codes
> New/changed return and reason codes, with meanings.
### 4.6 Exits (System and User) *(optional)*
> Exit changes and new parameters passed (e.g. database identifier).
### 4.7 Diagnostic Aids
> Core dumps, tracing, diagnostic tools.
### 4.8 Messages
> Message catalog: list new/changed/deleted messages with text and meaning. Tag each as (New)/(Changed)/(Deleted).
### 4.9 Audit / Telemetry Records *(optional)*
> New/changed audit/telemetry record types and fields.
### 4.10 Health Checks
> Health check definitions and changes.
### 4.11 Miscellaneous
#### 4.11.1 Tools
> Internal tools affected and new sample programs.
#### 4.11.2 Databases
> Database tables, schemas, and configuration database changes.
#### 4.11.3 Other *(optional)*
> Anything else (collections, clusters, cold storage, file system, archive tier) not covered above.

## 5. Internal Design
### 5.1 Rationale
> Explain why this approach was chosen; record design goals and constraints. Include "Post-Internal Review Design Changes" narrative if applicable.
#### 5.1.1 Alternatives Considered
> List alternative solutions and why they were rejected.
#### 5.1.2 Follow-On / Future Work *(optional)*
> Describe planned extensions, stages, and artificial limits with rationale.
#### 5.1.3 Post-Review Design Changes *(optional)*
> Capture how the design evolved after internal review (e.g. relaxed restrictions, customer-friendly changes, decisions reversed).
### 5.2 Internal (Cross-Component) Interfaces
> State internal cross-component interfaces, or explicitly "none".
### 5.3 Serialization of Resources
> Distributed locks (lock keys) and scope changes. Use INTERNAL LEVEL DETAIL callouts.
### 5.4 Error Handling Strategy
> New error codes, messages, and propagation strategy.
### 5.5 Dynamic Service Update and Diagnosis
> Dynamic update support, or explicitly "none".
### 5.6 Advanced Customization
> Advanced customization guide impact, or "not required".

## 6. Publication Updates *(optional)*
> Anticipated documentation/publication impact: list each affected guide/manual and the specific changes required (chapter/section, wording).

---

## 7. Reviewed by and Comments

### 7.1 Reviewers

| Reviewer | Role | Date | Comments |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | <comments> |

### 7.2 Comment Section

- **File location**: `<Project Acronym>_<File Being Reviewed>_Comments.md`
- **Created Date**: `<YYYY-MM-DD>`
- **Modified Date**: `<YYYY-MM-DD>`

---

## 8. Appendix: Internal-Level Detail *(optional)*
> Use boxed callouts to quarantine deep implementation notes (e.g. lock keys, serialization details) from the high-level narrative:
>
> ```
> ╔═════════════════════ INTERNAL LEVEL DETAIL ═════════════════════╗
> <deep implementation detail>
> ╚═════════════════════ END INTERNAL LEVEL DETAIL ══════════════════╝
> ```