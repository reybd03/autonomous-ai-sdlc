# Compliance: NTF GDPR & CCPA Compliance

- File Name: `ntf_compliance.md`
- File Location: `notification-service/compliance/`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md` (§3.6 Security Considerations, §3.12 Common Criteria)
- Related Feature Design: `design_example/epic_example/features_example/ntf-pref.1_design_document.md` (§5.6 Security Considerations)
- Related Ops: `design_example/epic_example/ops_example/ntf_ops.md` (§7 Security & Compliance)
- Related Review: `design_example/epic_example/reviews_example/ntf_review.md`
- Programming Languages: TypeScript, SQL
- Table of Contents: see section headings below

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | NTF – GDPR & CCPA Compliance Assessment |
| Document Number / Name | NTF-COMPLIANCE-001 |
| Version | v1.0 |
| Compliance Status | Compliant v1.0 |
| Date Created | 2026-10-20 |
| Date Last Updated | 2026-10-22 |
| Compliance Owner | Security Team (security@example.com) |
| Technical Contact | Alex Rivera (alex.rivera@example.com) |
| Owning Department / Team | Security / Compliance / Legal |
| Source File Location | notification-service/compliance/ntf_compliance.md |
| Retention | Current Year + 5 Years; Disposal: Archive |
| Export Classification | Internal |
| Required Approvers | Security Officer – 2026-10-22; Legal Counsel – 2026-10-22 |
| Mandatory Reviewers | Privacy Officer – 2026-10-21 |

---

## 1. Header / Metadata

- **Title**: NTF GDPR & CCPA Compliance Assessment
- **Compliance ID**: `ntf-compliance-01`
- **Compliance Framework**: GDPR (EU), CCPA (California)
- **Parent High Level Design**: `design_example/epic_example/ntf_HLD.md` (§3.6, §3.12)
- **Parent Feature Design**: `design_example/epic_example/features_example/ntf-pref.1_design_document.md`
- **Status**: Compliant
- **Assessment Type**: Initial assessment
- **Scope**: Notification preference management and delivery audit
- **Data Types Covered**: PII (email addresses, push tokens, user IDs)
- **Geographic Jurisdiction**: EU (GDPR), US-California (CCPA)
- **Compliance Officer**: Security Officer
- **Date Created**: 2026-10-20
- **Date Last Updated**: 2026-10-22
- **Next Review Due**: 2027-10-22
- **Affected Modules / Components**: `shared/preferences`, `api/preferences`, `pipeline/dispatcher`

---

## 2. Compliance Overview

### 2.1 Framework Summary
GDPR (EU General Data Protection Regulation) and CCPA (California Consumer Privacy Act) require organizations to honor user opt-out preferences for marketing communications, maintain audit trails of data processing, and provide data subject rights including access, rectification, and erasure.

NTF processes PII (email addresses, push tokens) for notification delivery. User preference management (opt-in/opt-out) is a core feature that directly supports GDPR Article 21 (right to object) and CCPA §1798.120 (right to opt-out).

### 2.2 Scope & Boundaries

**In Scope:**
- User preference creation, update, and deletion
- Opt-out enforcement in dispatch pipeline
- Audit logging of preference changes and notification attempts
- Data retention and deletion for preference records

**Out of Scope:**
- Marketing consent capture UI (handled by separate consent service)
- Third-party provider compliance (FCM, APNs, SendGrid maintain their own)

### 2.3 Regulatory Context

| Regulation / Standard | Requirement ID | Description | Applicability |
| :--- | :--- | :--- | :--- |
| GDPR | Article 21 | Right to object to processing | Full |
| GDPR | Article 30 | Records of processing activities | Full |
| GDPR | Article 32 | Security of processing | Full |
| CCPA | §1798.120 | Right to opt-out of sale/sharing | Full |
| CCPA | §1798.105 | Right to deletion | Full |

---

## 3. Controls & Requirements

### 3.1 Control Inventory

| Control ID | Control Name | Description | Status | Evidence |
| :--- | :--- | :--- | :--- | :--- |
| CTL-01 | Opt-out enforcement | Dispatcher drops notifications when user has opted out | Implemented | `ntf-pref.1_design_document.md` §5.3, test `pref-dispatch-drops-opted-out` |
| CTL-02 | Audit logging | All preference changes and notification attempts logged | Implemented | `ntf-pref.1_design_document.md` §5.2, `preference_audit` table |
| CTL-03 | Access control | Users can only access their own preferences | Implemented | `ntf-pref.1_design_document.md` §5.6, JWT `sub` validation |
| CTL-04 | Data encryption | PII encrypted at rest and in transit | Implemented | `ntf_HLD.md` §3.6, PostgreSQL TDE, TLS |
| CTL-05 | Forced-enabled security | Security-category notifications cannot be disabled | Implemented | `ntf-pref.1_design_document.md` §5.6 |

### 3.2 Data Processing Activities *(if applicable)*

| Activity | Data Type | Purpose | Legal Basis | Retention | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Notification delivery | Email, push token | Deliver user notifications | Contract performance | 90 days | Platform Engineering |
| Preference management | User ID, channel, category, enabled | Honor user opt-in/opt-out choices | Legal obligation (GDPR Art. 21) | 7 years | Platform Engineering |
| Audit logging | User ID, actor, reason, timestamp | Demonstrate compliance with opt-out requests | Legal obligation | 7 years | Platform Engineering |

### 3.3 Security Controls

| Control | Description | Implementation | Testing Frequency | Owner |
| :--- | :--- | :--- | :--- | :--- |
| JWT validation | Service-to-service authentication | JWT `sub` == `userId` for preference access | Per request | Platform Engineering |
| PII encryption at rest | Preference and audit data encrypted | PostgreSQL TDE | Annual | DevOps |
| PII encryption in transit | All API traffic over TLS | TLS 1.2+ | Annual | DevOps |
| Access logging | All notification attempts logged | `notification_attempts` table | Continuous | Platform Engineering |

---

## 4. Risk Assessment

### 4.1 Compliance Risks

| Risk | Description | Likelihood | Impact | Risk Level | Mitigation | Owner |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Cache staleness | Notification sent within 60s TTL after opt-out | Medium | High | Medium | 60s TTL + invalidation on write (see `ntf-bug-7`) | Alex Rivera |
| Cross-instance race | Another instance holds stale cache key | Low | Medium | Low | Short TTL bounds residual risk | Alex Rivera |
| Unauthorized preference access | User accesses another user's preferences | Low | High | Low | JWT `sub` validation + database-level authorization | Alex Rivera |

### 4.2 Accepted Risks *(optional)*

| Risk | Acceptance Rationale | Approver | Date | Review Date |
| :--- | :--- | :--- | :--- | :--- |
| Cache staleness (60s window) | Residual risk bounded by short TTL; invalidation on write handles most cases | Security Officer | 2026-10-22 | 2027-01-22 |

---

## 5. Audit Evidence

### 5.1 Evidence Inventory

| Evidence ID | Description | Location | Control(s) | Last Verified |
| :--- | :--- | :--- | :--- | :--- |
| EV-01 | Preference enforcement test results | `design_example/epic_example/features_example/ntf-pref.1_test_cases.md` | CTL-01 | 2026-10-22 |
| EV-02 | Audit log schema | `ntf-pref.1_design_document.md` §5.2 | CTL-02 | 2026-10-22 |
| EV-03 | Access control matrix | `ntf-pref.1_test_cases.md` §5 | CTL-03 | 2026-10-22 |
| EV-04 | Encryption configuration | `ntf_HLD.md` §3.6 | CTL-04 | 2026-10-22 |

### 5.2 Audit Findings *(if applicable)*
None — initial assessment, no external audit findings.

---

## 6. Review & Sign-off

### 6.1 Compliance Review

| Reviewer | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| Privacy Officer | Privacy Officer | 2026-10-21 | Compliant |
| Security Officer | Security Officer | 2026-10-22 | Compliant |
| Legal Counsel | Legal Counsel | 2026-10-22 | Compliant |

### 6.2 Exceptions *(if applicable)*
None — no exceptions to compliance requirements have been approved.

---

## 7. Remediation Plan

| Action | Control(s) | Owner | Due Date | Status |
| :--- | :--- | :--- | :--- | :--- |
| Unify cache key schemes (single + bulk) | CTL-01 | Alex Rivera | 2026-11-05 | Open |
| Annual encryption key rotation | CTL-04 | DevOps | 2027-01-22 | Open |

---

## 8. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 2026-10-20 | Security Officer | Initial draft |
| 1.0 | 2026-10-22 | Security Officer | Compliant after review |
