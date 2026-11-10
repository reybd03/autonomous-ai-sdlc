# Release: NTF v1.0.0 Production Release

- File Name: `ntf_release.md`
- File Location: `notification-service/releases/`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md` (§1.6 Delivery/Rollback Plan)
- Related Low Level Design: `design_example/epic_example/ntf-pref_LLD.md` (§8 Migration, Coexistence & Rollout)
- Related Changelog: `design_example/epic_example/changelog_example/ntf_changelog.md`
- Related Ops: `design_example/epic_example/ops_example/ntf_ops.md` (deployment, rollback)
- Programming Languages: TypeScript, SQL
- Table of Contents: see section headings below

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | NTF – Release v1.0.0 |
| Document Number / Name | NTF-RELEASE-001 |
| Version | v1.0.0 |
| Release Status | Released v1.0 |
| Date Created | 2026-10-20 |
| Date Last Updated | 2026-10-22 |
| Release Owner | Alex Rivera (alex.rivera@example.com) |
| Release Manager | DevOps Team (devops@example.com) |
| Owning Department / Team | DevOps / Release Engineering |
| Source File Location | notification-service/releases/ntf_release.md |
| Retention | Permanent; Disposal: Archive |
| Export Classification | Internal |
| Required Approvers | Sam Okonkwo – Product Owner – 2026-10-22; DevOps Lead – 2026-10-22 |
| Mandatory Reviewers | Priya Shah – QA Lead – 2026-10-21; Security Reviewer – 2026-10-21 |

---

## 1. Header / Metadata

- **Title**: NTF v1.0.0 Production Release
- **Release ID**: `ntf-release-01`
- **Version**: 1.0.0
- **Parent High Level Design**: `design_example/epic_example/ntf_HLD.md`
- **Parent Low Level Design**: `design_example/epic_example/ntf-pref_LLD.md`
- **Status**: Released
- **Release Type**: Major
- **Target Environment**: Production
- **Release Owner**: Alex Rivera
- **Release Manager**: DevOps Team
- **Date Created**: 2026-10-20
- **Date Last Updated**: 2026-10-22
- **Scheduled Release Date**: 2026-10-23
- **Affected Modules / Components**: `api/`, `shared/preferences`, `pipeline/dispatcher`, `providers/`

---

## 2. Release Overview

### 2.1 Release Summary
NTF v1.0.0 delivers the Real-Time Notification Service with async Kafka-based delivery, per-user preference management, and opt-out enforcement. This is the first production release, replacing synchronous per-service notification sends.

Key deliverables:
- `POST /v1/notifications` REST API and gRPC service
- Preference self-service API (`GET/PUT/DELETE /v1/preferences`)
- Dispatch pipeline with preference enforcement and audit logging
- FCM, APNs, SendGrid, and WebSocket delivery providers
- Helm chart for Kubernetes deployment

### 2.2 Release Objectives
- Centralize notification delivery behind a single API
- Decouple producers from delivery latency via Kafka
- Enable user-level opt-out for marketing communications (GDPR/CCPA)
- Provide audit trail of all notification attempts

### 2.3 Features & Changes

| Item | Type | Artifact Reference | Owner |
| :--- | :--- | :--- | :--- |
| Notification API | Feature | `ntf_HLD.md` §4.1 | Alex Rivera |
| Preference management | Feature | `ntf-pref.1_design_document.md` §5.1 | Alex Rivera |
| Dispatch enforcement | Feature | `ntf-pref.1_design_document.md` §5.3 | Alex Rivera |
| Preference cache bug fix | Bug Fix | `ntf-bug-7_bug_design.md` | Priya Shah |
| Legacy synchronous send deprecation | Change | `ntf_changelog.md` | Alex Rivera |

### 2.4 Exclusions
- Webhook delivery (phase 2) — requires separate integration effort
- Per-tenant default policies (ntf-pref.3) — deferred to phase 3
- Admin bulk import/export (ntf-pref.2) — ready for phase 2

---

## 3. Rollout Plan

### 3.1 Deployment Strategy
Blue-green deployment with feature flag control. The new service runs alongside the legacy path, with traffic shifted via the `ntf.preferences.enforce` feature flag.

### 3.2 Rollout Phases

| Phase | Description | Entry Criteria | Exit Criteria | Owner | Target Date |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Phase 1 | Deploy to staging, run smoke tests | All tests pass in CI | Staging smoke tests pass | DevOps Team | 2026-10-22 |
| Phase 2 | Enable feature flag for 10% of production traffic | Phase 1 complete | Error rate < 1% for 1 hour | Platform Engineering | 2026-10-23 |
| Phase 3 | Enable feature flag for 100% of production traffic | Phase 2 stable | Zero Sev-1/Sev-2 for 24 hours | Platform Engineering | 2026-10-24 |

### 3.3 Feature Flags

| Flag | Default | Owner | Rollback Trigger |
| :--- | :--- | :--- | :--- |
| `ntf.preferences.enforce` | off | Alex Rivera | Error rate > 5% or preference check latency > 80ms p99 |

### 3.4 Communication Plan

| Audience | Channel | Timing | Owner |
| :--- | :--- | :--- | :--- |
| Engineering team | Slack #ntf-release | 24 hours before release | Release Manager |
| Customer support | Email | Day of release | Product Manager |
| Producers (order, billing) | Jira ticket + Slack | 1 week before release | Alex Rivera |

---

## 4. Rollback Plan

### 4.1 Rollback Triggers

| Trigger | Description | Owner |
| :--- | :--- | :--- |
| Error rate > 5% for 10 minutes | Elevated notification delivery failures | On-call SRE |
| Preference check latency > 80ms p99 | Dispatch pipeline degraded | On-call SRE |
| Sev-1 incident | Production outage | On-call SRE |

### 4.2 Rollback Procedure
1. Set `ntf.preferences.enforce` feature flag to `off`
2. Roll back Helm chart to previous revision: `helm rollback ntf <previous-revision>`
3. Verify health endpoints return `200 OK`
4. Confirm delivery metrics return to baseline
5. Notify stakeholders via #ntf-incidents Slack channel

### 4.3 Rollback Verification
- `/healthz` returns `200 OK`
- `/readyz` returns `200 OK` (Kafka/DB connectivity confirmed)
- `notification_delivery_failed_total` returns to baseline
- `kafka_consumer_lag` below 1000 messages

### 4.4 Data Migration Rollback *(optional)*
Preference data migration is additive (new tables only). Rollback drops `user_preferences` and `preference_audit` tables if needed. No data loss for existing notification data.

---

## 5. Go / No-Go Criteria

### 5.1 Pre-Release Checklist

| Check | Yes / N/A | Notes |
| :--- | :--- | :--- |
| All tests pass (unit, integration, E2E) | Yes | 100% pass rate on staging |
| Code review complete and approved | Yes | `ntf-review-01` approved |
| Security review complete | Yes | JWT validation, PII encryption verified |
| Performance SLO met | Yes | Preference check p99 < 20ms (cache hit) |
| Documentation updated | Yes | `ntf_documentation.md` published |
| Changelog updated | Yes | `ntf_changelog.md` v1.0.0 |
| Rollback tested | Yes | Staging rollback drill completed 2026-10-21 |
| Stakeholder sign-off obtained | Yes | Product Owner and DevOps Lead |

### 5.2 Go / No-Go Decision

| Role | Name | Date | Decision (Go / No-Go) |
| :--- | :--- | :--- | :--- |
| Product Owner | Sam Okonkwo | 2026-10-22 | Go |
| Release Manager | DevOps Team | 2026-10-22 | Go |
| DevOps Lead | DevOps Lead | 2026-10-22 | Go |
| Security Reviewer | Security Team | 2026-10-21 | Go |

---

## 6. Post-Release Verification

### 6.1 Verification Steps
- Monitor `/healthz` and `/readyz` for 1 hour post-deployment
- Verify `notification_delivery_failed_total` remains below 1%
- Confirm preference opt-out is enforced (no marketing deliveries to opted-out users)
- Check audit log entries are being written correctly

### 6.2 Monitoring Plan

| Metric | Duration | Alert Threshold | Owner |
| :--- | :--- | :--- | :--- |
| `notification_delivery_failed_total` | 24 hours | >5% error rate | On-call SRE |
| `preference_check_latency_ms` | 24 hours | >80ms p99 | Platform Engineering |
| `kafka_consumer_lag` | 24 hours | >1000 messages | Platform Engineering |

### 6.3 Post-Release Review
Scheduled for 2026-10-24, 2:00 PM UTC, with Product, Engineering, QA, and DevOps.

---

## 7. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation | Owner |
| :--- | :--- | :--- | :--- | :--- |
| Cache staleness allows notification after opt-out | Medium | High | 60s TTL + invalidation on write (see `ntf-bug-7`) | Alex Rivera |
| Provider rate limits throttle delivery | Low | Medium | Per-provider rate limiting and queuing | Platform Engineering |
| Kafka consumer lag during traffic spikes | Low | Medium | Horizontal scaling of consumer groups | DevOps |

---

## 8. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 2026-10-20 | Alex Rivera | Initial draft |
| 1.0.0 | 2026-10-22 | Alex Rivera | Released |
