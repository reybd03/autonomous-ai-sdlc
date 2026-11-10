# Compliance Template

- File Name: `<Project Acronym>_COMPLIANCE.md` or `<Framework>_compliance.md` (e.g. `ntf_compliance.md`, `ntf_gdpr_compliance.md`)
- File Location: `<Project Directory>/compliance/` or `<Project Directory>/docs/compliance/` — see `design_example/epic_example/compliance_example/ntf_compliance.md`
- Related High Level Design: `<Project Acronym>_HLD.md` (§3.6 Security Considerations, §3.12 Common Criteria)
- Related Feature Design: `<Feature ID>_design_document.md` (§5.6 Security Considerations)
- Related Ops: `<Project Acronym>_OPS.md` (§7 Security & Compliance)
- Related Review: `<Project Acronym>_REVIEW.md` (security/compliance review)
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. This template covers compliance assessments for regulatory frameworks (GDPR, CCPA, HIPAA, SOC 2, ISO 27001, PCI DSS, Common Criteria, etc.), security controls, privacy requirements, and licensing obligations. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – <Compliance Framework> Compliance |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Compliance Status | Draft \| In Review \| Reviewed \| Approved \| Compliant \| Non-Compliant \| Exempt \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Compliance Owner | <name> (<email>) |
| Technical Contact | <name> (<email>) |
| Owning Department / Team | Security / Compliance / Legal |
| Source File Location | <path / repo> |
| Retention | <e.g. Current Year + 5 Years; Disposal: Archive> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |
| Mandatory Reviewers | <name – area – email – date> |

---

## 1. Header / Metadata

- **Title**: <Short, descriptive compliance document title>
- **Compliance ID**: `<project>-compliance-<n>` (e.g. `ntf-compliance-01`)
- **Compliance Framework**: <e.g. GDPR, CCPA, HIPAA, SOC 2, ISO 27001, PCI DSS, Common Criteria>
- **Parent High Level Design**: `<Project Acronym>_HLD.md` (§ reference, e.g. §3.6, §3.12)
- **Parent Feature Design**: `<Feature ID>_design_document.md` *(optional)*
- **Status**: Draft \| In Review \| Approved \| Compliant \| Non-Compliant \| Exempt
- **Assessment Type**: <e.g. initial assessment, periodic review, audit preparation, gap analysis>
- **Scope**: <e.g. system-wide, specific module, data processing activity>
- **Data Types Covered**: <e.g. PII, PHI, PCI, financial, health>
- **Geographic Jurisdiction**: <e.g. EU, US-California, US-federal, global>
- **Compliance Owner**: <name>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Next Review Due**: <YYYY-MM-DD>
- **Affected Modules / Components**: <list>

---

## 2. Compliance Overview

### 2.1 Framework Summary
> Describe the compliance framework, its requirements, and why it applies to this system.

### 2.2 Scope & Boundaries
> Define what is in scope and what is out of scope for this compliance assessment.

- **In Scope**:
  - <item 1>
  - <item 2>
- **Out of Scope**:
  - <item 1> (rationale)

### 2.3 Regulatory Context
> List laws, regulations, standards, or contractual obligations that drive compliance requirements.

| Regulation / Standard | Requirement ID | Description | Applicability |
| :--- | :--- | :--- | :--- |
| <regulation> | <ID> | <description> | <full/partial/not applicable> |

---

## 3. Controls & Requirements

### 3.1 Control Inventory
> List compliance controls and their implementation status.

| Control ID | Control Name | Description | Status | Evidence |
| :--- | :--- | :--- | :--- | :--- |
| <ID> | <name> | <description> | <Implemented/Partial/Not Implemented> | <link to evidence> |

### 3.2 Data Processing Activities *(if applicable)*
> Describe personal data processing activities covered by privacy frameworks.

| Activity | Data Type | Purpose | Legal Basis | Retention | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| <activity> | <type> | <purpose> | <basis> | <period> | <name> |

### 3.3 Security Controls
> Describe security controls implemented to meet compliance requirements.

| Control | Description | Implementation | Testing Frequency | Owner |
| :--- | :--- | :--- | :--- | :--- |
| <control> | <description> | <how implemented> | <frequency> | <name> |

---

## 4. Risk Assessment

### 4.1 Compliance Risks
> Identify risks of non-compliance and their potential impact.

| Risk | Description | Likelihood | Impact | Risk Level | Mitigation | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| <risk> | <description> | <low/med/high> | <low/med/high> | <low/med/high> | <mitigation> | <name> |

### 4.2 Accepted Risks *(optional)*
> List risks formally accepted with documented rationale.

| Risk | Acceptance Rationale | Approver | Date | Review Date |
| :--- | :--- | :--- | :--- | :--- |
| <risk> | <rationale> | <name> | <date> | <date> |

---

## 5. Audit Evidence

### 5.1 Evidence Inventory
> List evidence artifacts that demonstrate compliance.

| Evidence ID | Description | Location | Control(s) | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| <ID> | <description> | <path/link> | <control IDs> | <date> |

### 5.2 Audit Findings *(if applicable)*
> List findings from internal or external audits.

| Finding ID | Description | Severity | Status | Remediation | Due Date |
| :--- | :--- | :--- | :--- | :--- | :--- |
| <ID> | <description> | <low/med/high> | <open/closed> | <description> | <date> |

---

## 6. Review & Sign-off

### 6.1 Compliance Review
| Reviewer | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | Compliant / Non-Compliant / Exempt |

### 6.2 Exceptions *(if applicable)*
> List formally approved exceptions to compliance requirements.

| Exception ID | Requirement | Rationale | Approver | Expiry Date | Compensating Control |
| :--- | :--- | :--- | :--- | :--- | :--- |
| <ID> | <requirement> | <rationale> | <name> | <date> | <control> |

---

## 7. Remediation Plan

> List actions required to achieve or maintain compliance.

| Action | Control(s) | Owner | Due Date | Status |
| :--- | :--- | :--- | :--- | :--- |
| <action> | <control IDs> | <name> | <YYYY-MM-DD> | Open / In Progress / Closed |

---

## 8. Reviewed by and Comments

### 8.1 Reviewers

| Reviewer | Role | Date | Comments |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | <comments> |

### 8.2 Comment Section

- **File location**: `<Project Acronym>_<File Being Reviewed>_Comments.md`
- **Created Date**: `<YYYY-MM-DD>`
- **Modified Date**: `<YYYY-MM-DD>`

---

## 9. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
