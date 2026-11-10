# Test Plan: Real-Time Notification Service (NTF)

- File Name: `ntf_test_plan.md`
- File Location: `notification-service/design/`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md`
- Related Low Level Design: `design_example/epic_example/ntf-pref_LLD.md`
- Related Feature Design: `design_example/epic_example/features_example/ntf-pref.1_design_document.md`
- Programming Languages: TypeScript
- Table of Contents: see section headings below

## Document Control

| Field | Value |
| :--- | :--- |
| Document Title | NTF – Real-Time Notification Service Test Plan |
| Version | Test Plan V1.0 |
| Status | Approved v1.0 |
| Date Created | 10/20/26 |
| Date Last Updated | 10/22/26 |
| Document Owner | Alex Rivera (alex.rivera@example.com) |
| Technical Contact | Alex Rivera (alex.rivera@example.com) |
| Owning Department / Team | Platform Engineering |
| Source File Location | notification-service/design/ |
| Retention | Current Year + 2 Years; Disposal: Delete |
| Export Classification | Internal |
| Required Approvers | Alex Rivera – Tech Lead – 10/21/26; Sam Okonkwo – Product Manager – 10/22/26 |
| Mandatory Reviewers | Priya Shah – QA Lead – 10/22/26 |
| Optional Reviewers | DevOps Team |

---

## 1. Purpose

### 1.1 Overview
This test plan covers verification of the Real-Time Notification Service (NTF), including the preference/opt-out feature (`ntf-pref.1`), delivery pipeline, and provider integrations.

### 1.2 Project Overview
NTF centralizes push, email, and in-app notification delivery behind an asynchronous Kafka-based pipeline, replacing synchronous per-service sends.

### 1.3 Test Objectives
- Verify functional correctness of notification send, preference enforcement, retry/DLQ, and audit logging.
- Verify regression of existing notification behavior during migration.
- Verify performance SLOs (push/in-app p99 < 5s) under load.
- Verify security (auth, PII handling) and observability.

### 1.4 Process Rationale
Testing follows the team's CI policy: unit + integration in CI, E2E in staging, performance in a dedicated load environment. Quality gates: lint, typecheck, tests, coverage ≥ 80%.

---

## 2. Key Test Dates

### 2.1 Test Plan Reviews
- Plan review: 10/22/26 (approved).
- Test case review: 10/24/26.
- Execution: 10/27/26 – 11/07/26.
- Performance run: 11/03/26.

---

## 3. Dependencies

### 3.1 Hardware / Infrastructure
- Kubernetes cluster (staging + load).
- Kafka, PostgreSQL, Redis instances.

### 3.2 Software
- FCM/APNs/SendGrid sandbox credentials.
- Auth service (staging).

### 3.3 Test Tools
- Jest, Supertest, Testcontainers, k6 (load), Playwright (E2E).

---

## 4. Test Criteria

### 4.1 Test Entrance Criteria
- All unit/integration tests pass in CI.
- Migrations applied to staging DB.
- Provider sandbox credentials configured.

### 4.2 Test Exit Criteria
- ≥ 80% code coverage on changed modules.
- 0 open Sev-1/Sev-2 defects.
- Performance SLO met (p99 < 5s push).
- All acceptance scenarios pass.

### 4.3 Deviation from Criteria *(optional)*
N/A.

### 4.4 Releases / Versions Tested
- NTF v1.0 (staging build `ntf-1.0.0-rc.3`), Node.js 20, Kafka 3.6, Postgres 16, Redis 7.

---

## 5. Project Contacts

### 5.1 Development Contacts

| Name | Area of Responsibility | Email |
| :--- | :--- | :--- |
| Alex Rivera | Tech Lead / Notification pipeline | alex.rivera@example.com |
| Priya Shah | Preferences module | priya.shah@example.com |

### 5.2 Test Contacts

| Name | Area of Responsibility | Email |
| :--- | :--- | :--- |
| Priya Shah | QA Lead / Function Test | priya.shah@example.com |

### 5.3 Other Area Contacts *(optional)*

| Name | Area of Responsibility | Email |
| :--- | :--- | :--- |
| DevOps Team | Driver Build / Integration | devops@example.com |
| Product Team | Product Management | product@example.com |

---

## 6. Team Member Assignments

### 6.1 Test Coverage and Support

| Component | Developer(s) | Tester(s) |
| :--- | :--- | :--- |
| `shared/preferences` | Alex Rivera | Priya Shah |
| `api/preferences` | Alex Rivera | Priya Shah |
| `pipeline/dispatcher` | Alex Rivera | Priya Shah |
| `providers/*` | Alex Rivera | Priya Shah |

---

## 7. Background Publications

| Title | Author / Department | Area |
| :--- | :--- | :--- |
| `design_example/epic_example/ntf_HLD.md`, v1.0 | Alex Rivera / Platform Eng | HLD |
| ntf-pref_LLD.md, v1.0 | Alex Rivera / Platform Eng | Low Level Design |
| ntf-pref.1_design_document.md, v1.0 | Alex Rivera / Platform Eng | Feature Design |
| NTF Product Requirements Doc (PRD-NTF-2026) | Product Team | Requirements |

---

## 8. Infrastructure / Environment Information

### 8.1 Test Infrastructure
- Staging: Kubernetes namespace `ntf-staging`, 3 replicas.
- Load: dedicated cluster, 10 replicas, k6 runner.

### 8.2 Environment Configuration *(optional)*
- Feature flag `ntf.preferences.enforce` enabled in staging.
- Provider sandbox credentials via K8s secrets.
- Seed data: 10k users with mixed preferences.

---

## 9. Problem Reporting and Tracking

### 9.1 Defect Reporting
- Tool: GitHub Issues (label `ntf`).
- Required info: failing test name, logs, request/response, userId (hashed), environment.
- Severity: Sev-1 (prod down) … Sev-4 (cosmetic).

### 9.2 Defect Triage *(optional)*
- Daily triage at 10:00; Sev-1/2 escalated immediately.

---

## 10. Test Case Status Reporting and Tracking

### 10.1 Status Reporting
- CI dashboard: pass/fail, coverage, flaky count.
- Daily: total cases, exposed, passed, open defects, S-curve.

### 10.2 Status Tracking
- GitHub Actions + RQM-equivalent (project board). Status posted to #ntf-testing Slack channel.

---

## 11. Test Case Output Records

### 11.1 Output Records Location
- CI artifacts (GitHub Actions), k6 reports in `tests/perf/reports/`, Playwright traces in `tests/e2e/traces/`.

---

## 12. Software and Tooling Requirements

### 12.1 Test Tools

| Tool | Purpose | Where Available |
| :--- | :--- | :--- |
| Jest | Unit tests | CI + local |
| Supertest | API integration | CI + local |
| Testcontainers | Integration (Postgres/Redis/Kafka) | CI + local |
| k6 | Load/performance | Load env |
| Playwright | E2E | Staging |

### 12.2 Platform / Runtime Software
- Node.js 20, PostgreSQL 16, Redis 7, Kafka 3.6, Fastify 4.

---

## 13. Test Case Standards *(optional)*

### 13.1 Test Case Naming Convention
- `<module>.<feature>.<scenario>` (e.g. `preferences.api.optout-blocks-marketing`).

### 13.2 Test Case Construction
- Unit: pure functions, mocked deps.
- Integration: Testcontainers for DB/cache/broker.
- E2E: Playwright against staging.

### 13.3 Test Library / Suite Naming Convention *(optional)*
- Files: `*.test.ts`, `*.integration.test.ts`, `*.e2e.test.ts`.

---

## 14. Functional Characteristics Under Test

### 14.1 Testing Types Applicable

| Type | Description |
| :--- | :--- |
| Acceptance | Minimal set ensuring primary function works and no regression. |
| Regression | Existing notification behavior unchanged during migration. |
| Progression | Cases updated for new preference enforcement. |
| New Function | New cases for preferences, retry/DLQ, audit. |

### 14.2 Functional Characteristics by Component

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| ntf-pref.1 §5.1 | Preference API GET/PUT/DELETE | Contract + integration tests |
| ntf-pref.1 §5.2 | Data model & migrations | Migration up/down tests |
| ntf-pref.1 §5.4 | Error handling | Invalid channel/category, user not found |
| ntf-pref.1 §5.6 | Security / opt-out enforcement | Authz, GDPR irreversibility, forced-enabled security |
| ntf_hld §3.5 | Performance SLO | k6 load test, p99 < 5s |

---

## 15. Interoperability *(optional)*
N/A — no external interoperability claims.

---

## 16. Migration / Coexistence

### 16.1 Migration Considerations
Producers migrate from synchronous send to publishing `NotificationRequested` events; dual-write for 2 weeks.

#### 16.1.1 Test Scenarios

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| ntf_hld §3.3 | Dual-write path | Verify both legacy and new paths produce identical delivery |
| ntf-pref.1 §5.3 | Preference enforcement | Verify opt-out respected in both paths |

#### 16.1.2 Migration Issues / Patches *(optional)*
N/A.

### 16.2 Coexistence Considerations
Legacy and new paths coexist via feature flag per producer.

#### 16.2.1 Test Scenarios

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| ntf_hld §3.4 | Feature flag toggle | Verify switching paths at runtime |

#### 16.2.2 Coexistence Issues / Patches *(optional)*
N/A.

---

## 17. Support Use Information

### 17.1 General Support Use Information Considerations
Developer docs: "Sending Notifications" guide; preference self-service UI.

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| ntf_hld §6 | Publication Updates | Doc review + link check |

### 17.2 Security *(optional)*
- Auth: JWT validation, user-scoped access, admin audit.
- PII: encrypted at rest/in transit; access logged.

| HLD / Feature Section | Function Name | Test Activities |
| :--- | :--- | :--- |
| ntf-pref.1 §5.6 | Authz enforcement | Cross-user access denied; admin audited |

---

## 18. Human Factors Characteristics *(optional)*
- Preference UI accessible (ARIA, keyboard nav).
- Error messages user-friendly.

---

## 19. Messages and Codes

| HLD / Feature Section | Message / Code | Test Activities |
| :--- | :--- | :--- |
| ntf_hld §4.5 | `NTF-001` invalid template | Verify 400 + message |
| ntf_hld §4.5 | `NTF-002` user not found | Verify 404 |
| ntf_hld §4.5 | `NTF-003` channel disabled | Verify drop + audit |

---

## 20. Cross-Component Interfaces *(optional)*

| HLD / Feature Section | Interface | Test Activities |
| :--- | :--- | :--- |
| ntf-pref.1 §5.3 | gRPC `PreferenceService.Check` | Contract test |
| ntf_hld §4.1 | Kafka `notification.requested` | Schema compatibility test |

---

## 21. Acceptance Test *(optional)*
- End-to-end: user opts out of marketing → marketing notification dropped + audited; transactional still delivered.

---

## 22. Regression Test
- Existing notification delivery (push/email/in-app) unchanged for users with default preferences.
- 98 existing unit/integration tests (analogous) remain green.

---

## 23. Progression and New Function *(optional)*
- New preference enforcement exercised across all channel variants.

---

## 24. Test Plan Checklist

| Type of Verification | Yes / N/A |
| :--- | :--- |
| Verify command output (CLI) | Yes |
| Reason code / text verification | Yes |
| Contention / concurrency verification | Yes |
| Boundary testing (min/max values) | Yes |
| Multisystem processing | N/A |
| Error injection (provider failures) | Yes |
| Coverage — different users/callers | Yes |
| Single vs. multi-instance | Yes |
| Multiple workers/threads | Yes |
| Test in different environments (CLI, UI, API) | Yes |
| Verify output messages match docs | Yes |
| Executable module sanity check | Yes |
| "What we did not think of?" | Reviewed |

---

## Appendix: Test Environment Setup *(optional)*

```bash
# Local dev
docker compose up -d kafka postgres redis
pnpm migrate:dev
pnpm dev

# Run tests
pnpm lint && pnpm typecheck
pnpm test
pnpm test:integration
```