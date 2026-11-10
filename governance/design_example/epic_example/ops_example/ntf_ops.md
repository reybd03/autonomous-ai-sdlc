# Operations: NTF Deployment Runbook

- File Name: `ntf_ops.md`
- File Location: `notification-service/ops/`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md` (§3.2 RAS, §3.11 Health Checks)
- Related Release: `design_example/epic_example/releases_example/ntf_release.md`
- Related Test Plan: `design_example/epic_example/ntf_TEST_PLAN.md` (§8 Infrastructure)
- Programming Languages: TypeScript, SQL
- Table of Contents: see section headings below

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | NTF – Deployment Runbook |
| Document Number / Name | NTF-OPS-001 |
| Version | v1.0 |
| Ops Status | Active v1.0 |
| Date Created | 2026-10-21 |
| Date Last Updated | 2026-10-22 |
| Document Owner | DevOps Team (devops@example.com) |
| Technical Contact | Alex Rivera (alex.rivera@example.com) |
| Owning Department / Team | DevOps / Platform Engineering |
| Source File Location | notification-service/ops/ntf_ops.md |
| Retention | Current Year + 2 Years; Disposal: Delete |
| Export Classification | Internal |
| Required Approvers | DevOps Lead – 2026-10-22 |
| Mandatory Reviewers | SRE Team – 2026-10-21 |

---

## 1. Header / Metadata

- **Title**: NTF Deployment Runbook
- **Ops ID**: `ntf-ops-01`
- **Parent High Level Design**: `design_example/epic_example/ntf_HLD.md` (§3.2, §3.11)
- **Parent Release**: `design_example/epic_example/releases_example/ntf_release.md`
- **Status**: Active
- **Author**: DevOps Team
- **Reviewers**: SRE Team, Alex Rivera
- **Date Created**: 2026-10-21
- **Date Last Updated**: 2026-10-22
- **Ops Type**: Deployment runbook
- **Target Audience**: DevOps, SRE, platform engineers, on-call
- **Environment**: Production, Staging
- **Affected Modules / Components**: `notification-service`, `api/`, `pipeline/`, `providers/`

---

## 2. Purpose & Scope

### 2.1 Operations Overview
This runbook covers deployment, health monitoring, rollback, and incident response for the Real-Time Notification Service (NTF). It enables DevOps and SRE teams to operate the service reliably in production and staging.

Key deliverables:
- Deployment and rollback procedures
- Health check endpoints and alert thresholds
- Incident classification and response steps
- Backup and restore for preference data

### 2.2 Target Environments
- Production: Kubernetes cluster `prod-cluster`, namespace `ntf-prod`
- Staging: Kubernetes cluster `staging-cluster`, namespace `ntf-staging`

### 2.3 In Scope
- Deploying new versions of `notification-service`
- Rolling back failed deployments
- Scaling API and dispatcher replicas
- Restoring PostgreSQL and Redis from backups
- Rotating provider API keys (FCM, APNs, SendGrid)

### 2.4 Out of Scope
- Managing Kafka cluster infrastructure (owned by platform team)
- Managing provider accounts (FCM, APNs, SendGrid console access)

---

## 3. Architecture & Components

### 3.1 System Overview
NTF is a Kubernetes-deployed service with an API gateway, Kafka consumer pipeline, and multiple delivery providers (FCM, APNs, SendGrid, WebSocket).

### 3.2 Components & Dependencies

| Component | Owner | Dependency | Health Check |
| :--- | :--- | :--- | :--- |
| `notification-service` | Platform Engineering | Kafka, PostgreSQL, Redis | `/healthz` |
| `api/` | Platform Engineering | PostgreSQL, Redis | `/readyz` |
| `pipeline/` | Platform Engineering | Kafka, providers | `/healthz` |
| `providers/` | Platform Engineering | FCM, APNs, SendGrid APIs | Provider-specific |

### 3.3 Ports & Endpoints

| Port | Protocol | Purpose | Source | Destination |
| :--- | :--- | :--- | :--- | :--- |
| 8080 | HTTP | API gateway | External clients | `notification-service` |
| 8081 | HTTP | Health and metrics | Internal monitoring | `notification-service` |
| 9092 | TCP | Kafka | `notification-service` | Kafka cluster |
| 5432 | TCP | PostgreSQL | `notification-service` | PostgreSQL |
| 6379 | TCP | Redis | `notification-service` | Redis |

### 3.4 Configuration & Environment Variables

| Variable | Description | Default | Required | Sensitive |
| :--- | :--- | :--- | :--- | :--- |
| `KAFKA_BROKERS` | Kafka bootstrap servers | `localhost:9092` | Yes | No |
| `DATABASE_URL` | PostgreSQL connection string | None | Yes | Yes |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379` | Yes | No |
| `FCM_KEY` | Firebase Cloud Messaging key | None | Yes | Yes |
| `APNS_KEY` | Apple Push Notification key | None | Yes | Yes |
| `SENDGRID_KEY` | SendGrid API key | None | Yes | Yes |
| `JWT_PUBLIC_KEY` | Service-to-service JWT validation | None | Yes | Yes |

---

## 4. Health Checks & Observability

### 4.1 Health Check Endpoints

| Endpoint | Method | Expected Response | Alert Threshold |
| :--- | :--- | :--- | :--- |
| `/healthz` | GET | `200 OK` | >5s latency |
| `/readyz` | GET | `200 OK` (includes Kafka/DB connectivity) | >5s latency |
| `/metrics` | GET | Prometheus metrics format | N/A |

### 4.2 Metrics

| Metric | Description | Warning Threshold | Critical Threshold |
| :--- | :--- | :--- | :--- |
| `notification_delivery_total` | Total delivery attempts | N/A | N/A |
| `notification_delivery_failed_total` | Failed deliveries | >5% error rate | >10% error rate |
| `preference_check_latency_ms` | Preference check latency | >20ms p99 | >80ms p99 |
| `kafka_consumer_lag` | Kafka consumer lag | >1000 messages | >5000 messages |

### 4.3 Logs & Tracing

| Log Source | Location | Level | Retention |
| :--- | :--- | :--- | :--- |
| Application logs | stdout/stderr | info | 30 days |
| Error logs | stdout/stderr | error | 90 days |
| Access logs | stdout/stderr | info | 30 days |
| Traces | OpenTelemetry collector | N/A | 7 days |

---

## 5. Operational Procedures

### 5.1 Deployment Procedure
1. Verify all tests pass in CI (lint, typecheck, unit, integration)
2. Build and push Docker image to registry
3. Update Helm values with new image tag
4. Apply Helm chart to staging cluster
5. Run smoke tests against staging
6. Promote to production cluster
7. Monitor health endpoints for 15 minutes

### 5.2 Rollback Procedure
1. Identify the previous stable Helm revision
2. Run `helm rollback ntf <revision>` in the affected namespace
3. Verify health endpoints return `200 OK`
4. Confirm delivery metrics return to baseline
5. Document the rollback incident

### 5.3 Scaling Procedure
1. Check current replica count: `kubectl get deployment ntf -n ntf-prod`
2. Increase replicas: `kubectl scale deployment ntf --replicas=<n> -n ntf-prod`
3. Monitor Kafka consumer lag and API latency

### 5.4 Backup & Restore Procedure
1. PostgreSQL: Daily automated backup via `pg_dump` to S3
2. Redis: RDB snapshots every 6 hours, AOF enabled
3. Restore: Apply latest PostgreSQL dump, then replay Redis AOF

### 5.5 Certificate & Secret Rotation
1. Rotate provider API keys quarterly via Kubernetes secrets
2. Rotate JWT signing keys annually
3. Update all service environments after rotation

### 5.6 Maintenance Procedure

| Task | Frequency | Procedure Reference | Owner |
| :--- | :--- | :--- | :--- |
| Health check review | Daily | §4.1 | SRE |
| Log rotation review | Weekly | §4.3 | DevOps |
| Certificate expiry check | Monthly | §5.5 | DevOps |
| Backup restore test | Quarterly | §5.4 | DevOps |

---

## 6. Incident Response

### 6.1 Incident Classification

| Severity | Definition | Response Time | Escalation Contact |
| :--- | :--- | :--- | :--- |
| Sev-1 | Production outage (no deliveries) | <15 min | On-call SRE |
| Sev-2 | Major degradation (>10% failures) | <1 hour | On-call SRE |
| Sev-3 | Minor issue (isolated failures) | <4 hours | Platform Engineering |
| Sev-4 | Cosmetic (UI text, non-critical) | <1 business day | Platform Engineering |

### 6.2 Incident Response Steps
1. **Detect**: Alerts from Prometheus/Grafana or PagerDuty
2. **Triage**: Assess severity using §6.1 classification
3. **Mitigate**: Rollback deployment if code-related; scale instances if resource-related
4. **Resolve**: Fix root cause, deploy fix, verify
5. **Communicate**: Notify stakeholders via #ntf-incidents Slack channel
6. **Post-mortem**: Document lessons learned within 48 hours

### 6.3 On-Call Contacts

| Role | Name | Contact | Rotation |
| :--- | :--- | :--- | :--- |
| On-call SRE | SRE rotation | +1-555-0100 | Weekly |
| Platform Engineering Lead | Alex Rivera | +1-555-0101 | N/A |

---

## 7. Security & Compliance *(optional)*

### 7.1 Security Considerations
- All API keys stored as Kubernetes secrets, not in code
- JWT validation required for all service-to-service calls
- PII (email addresses, push tokens) encrypted at rest and in transit

### 7.2 Compliance Requirements

| Control | Requirement | Evidence | Owner |
| :--- | :--- | :--- | :--- |
| Access logging | All notification attempts logged | `notification_attempts` table | Platform Engineering |
| Data encryption | PII encrypted at rest/in transit | PostgreSQL TDE, TLS | DevOps |
| Audit trail | Preference changes audited | `preference_audit` table | Platform Engineering |

---

## 8. Review & Approval

| Reviewer | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| DevOps Lead | DevOps Lead | 2026-10-22 | Approved |
| SRE Team | SRE | 2026-10-21 | Approved |

---

## 9. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 2026-10-21 | DevOps Team | Initial draft |
| 1.0 | 2026-10-22 | DevOps Team | Approved |
