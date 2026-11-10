# Documentation: NTF User Guide — Sending Notifications

- File Name: `ntf_documentation.md`
- File Location: `notification-service/docs/`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md` (§6 Publication Updates)
- Related Feature Design: `design_example/epic_example/features_example/ntf-pref.1_design_document.md`
- Related Test Plan: `design_example/epic_example/ntf_TEST_PLAN.md` (§17 Support Use Information)
- Programming Languages: TypeScript, SQL
- Table of Contents: see section headings below

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | NTF – User Guide: Sending Notifications |
| Document Number / Name | NTF-DOC-001 |
| Version | v1.0 |
| Documentation Status | Published v1.0 |
| Date Created | 2026-10-20 |
| Date Last Updated | 2026-10-22 |
| Document Owner | Alex Rivera (alex.rivera@example.com) |
| Technical Contact | Priya Shah (priya.shah@example.com) |
| Owning Department / Team | Documentation / InfoDev |
| Source File Location | notification-service/docs/ntf_documentation.md |
| Retention | Current Year + 2 Years; Disposal: Delete |
| Export Classification | Internal |
| Required Approvers | Sam Okonkwo – Product Manager – 2026-10-21 |
| Mandatory Reviewers | Priya Shah – QA Lead – 2026-10-21 |
| Optional Reviewers | DevOps Team |

---

## 1. Header / Metadata

- **Title**: NTF User Guide: Sending Notifications
- **Doc ID**: `ntf-doc-01`
- **Parent High Level Design**: `design_example/epic_example/ntf_HLD.md` (§6)
- **Parent Feature Design**: `design_example/epic_example/features_example/ntf-pref.1_design_document.md`
- **Status**: Published
- **Author**: Alex Rivera
- **Reviewers**: Priya Shah, Sam Okonkwo
- **Date Created**: 2026-10-20
- **Date Last Updated**: 2026-10-22
- **Target Audience**: Application developers integrating with the notification service
- **Content Type**: User guide
- **Format**: Markdown
- **Affected Modules / Components**: `api/`, `shared/preferences`, `pipeline/dispatcher`, `providers/`

---

## 2. Purpose & Scope

### 2.1 Documentation Overview
This user guide explains how application developers integrate with the Real-Time Notification Service (NTF) to send push, email, and in-app notifications. It replaces per-service synchronous notification code with a single `sendNotification()` API call.

Key deliverables:
- Quick start guide for `POST /v1/notifications`
- API reference for the notification endpoint
- Preference management self-service instructions
- Error code reference (`NTF-001`, `NTF-002`, `NTF-003`)

### 2.2 Target Audience
Application developers building services that need to send notifications. Prerequisites: basic REST API knowledge, valid service JWT, access to the NTF developer portal.

### 2.3 Content Scope

**In Scope:**
- Sending push, email, and in-app notifications via REST and gRPC
- Managing user notification preferences (opt-in/opt-out)
- Understanding delivery status and audit trails

**Out of Scope:**
- Provider-level configuration (FCM, APNs, SendGrid setup) — handled by platform team
- Kafka topic management — infrastructure concern

### 2.4 Prerequisites
- Valid NTF service account with API access
- Service-to-service JWT token
- Notification template ID from the template registry

---

## 3. Content Structure

### 3.1 Document Sections

| Section | Title | Description | Owner |
| :--- | :--- | :--- | :--- |
| 1 | Quick Start | Send your first notification in 5 minutes | Alex Rivera |
| 2 | API Reference | Full endpoint specification | Alex Rivera |
| 3 | Preference Management | User opt-in/opt-out self-service | Priya Shah |
| 4 | Error Codes | `NTF-001` through `NTF-003` reference | Alex Rivera |
| 5 | Migration Guide | Moving from synchronous sends to NTF | Sam Okonkwo |

### 3.2 Examples & Code Samples
- `curl POST /v1/notifications`: Example cURL command for sending a push notification
- `TypeScript sendNotification()`: TypeScript SDK usage example
- `Preference PUT /v1/preferences`: Example of updating user preferences

### 3.3 Diagrams & Visuals *(optional)*
- `delivery-pipeline.mmd`: Mermaid diagram of event → render → dispatch → deliver flow

---

## 4. Accuracy & Verification

### 4.1 Source of Truth
Authoritative sources: `ntf_HLD.md` v1.0 (architecture), `ntf-pref.1_design_document.md` v1.0 (preference API), running staging service at `ntf-staging.example.com`.

### 4.2 Verification Steps
- All cURL examples tested against staging environment on 2026-10-21
- TypeScript SDK examples compiled and run in CI
- Preference management flow verified end-to-end

### 4.3 Review Checklist

| Check | Yes / N/A | Notes |
| :--- | :--- | :--- |
| Content matches approved design (HLD/LLD/Feature) | Yes | |
| Code examples compile/run | Yes | Tested against staging |
| Links resolve correctly | Yes | All internal links verified |
| Accessibility review completed | N/A | Text-only documentation |
| Security-sensitive info excluded | Yes | No API keys or secrets in examples |

---

## 5. Publication & Maintenance

### 5.1 Publication Channel
Published to the internal developer portal at `docs.example.com/ntf`.

### 5.2 Update Triggers
- New API version release
- Change to notification endpoints or payloads
- Preference API changes
- New error codes added

### 5.3 Review Cadence
Quarterly, or upon any API-breaking change.

### 5.4 Retirement Plan
Archive when NTF API version is deprecated (minimum 6 months notice to consumers).

---

## 6. Accessibility & Localization *(optional)*

### 6.1 Accessibility Considerations
Documentation follows WCAG 2.1 AA: semantic headings, alt text on images, sufficient color contrast, keyboard-navigable code blocks.

### 6.2 Localization / i18n Considerations *(optional)*
Currently English only. Template strings in code examples are locale-aware.

---

## 7. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 2026-10-20 | Alex Rivera | Initial draft |
| 1.0 | 2026-10-22 | Alex Rivera | Published after review |
