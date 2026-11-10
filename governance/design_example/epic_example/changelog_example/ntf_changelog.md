# Changelog: NTF Notification Service

- File Name: `ntf_changelog.md`
- File Location: `notification-service/changelog/`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md`
- Related Release: `design_example/epic_example/releases_example/ntf_release.md`
- Programming Languages: TypeScript, SQL
- Table of Contents: see section headings below

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | NTF – Changelog |
| Document Number / Name | NTF-CHANGELOG-001 |
| Version | v1.0 |
| Status | Published v1.0 |
| Date Created | 2026-10-22 |
| Date Last Updated | 2026-10-22 |
| Document Owner | Alex Rivera (alex.rivera@example.com) |
| Owning Department / Team | Documentation / InfoDev / Release Engineering |
| Source File Location | notification-service/changelog/2026-10.md |
| Retention | Permanent; Disposal: Archive |
| Export Classification | Internal |
| Required Approvers | Sam Okonkwo – Product Manager – 2026-10-22 |

---

## 1. Header / Metadata

- **Title**: NTF Changelog — October 2026
- **Changelog ID**: `ntf-changelog-01`
- **Covered Period**: 2026-10-15 to 2026-10-22
- **Status**: Published
- **Author**: Alex Rivera
- **Reviewers**: Priya Shah, Sam Okonkwo
- **Date Created**: 2026-10-22
- **Date Last Updated**: 2026-10-22
- **Related Release**: `v1.0.0` (`design_example/epic_example/releases_example/ntf_release.md`)
- **Affected Modules / Components**: `api/`, `shared/preferences`, `pipeline/dispatcher`, `providers/`

---

## 2. Change Log Format

> Follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) conventions:
> - **Added** — new features
> - **Changed** — changes in existing functionality
> - **Deprecated** — soon-to-be removed features
> - **Removed** — removed features
> - **Fixed** — bug fixes
> - **Security** — security-related changes
> - **Documentation** — documentation-only changes
> - **Operations** — ops/infrastructure changes

---

## 3. Changes

### 3.1 `v1.0.0` — `2026-10-22`

#### Added
- Real-Time Notification Service with Kafka-based async delivery pipeline ([PR #142](https://github.com/example/ntf/pull/142))
- Per-user notification preference and opt-out management ([PR #145](https://github.com/example/ntf/pull/145))
- Preference enforcement in dispatch pipeline with audit logging ([PR #148](https://github.com/example/ntf/pull/148])

#### Changed
- Migrated order-service and billing-service from synchronous sends to event publishing ([PR #150](https://github.com/example/ntf/pull/150))

#### Deprecated
- Legacy synchronous `sendNotification()` direct provider calls — to be removed in v2.0.0 ([PR #152](https://github.com/example/ntf/pull/152))

#### Removed
- None

#### Fixed
- `ntf-bug-7`: Preference cache stale data after bulk check update ([PR #155](https://github.com/example/ntf/pull/155))

#### Security
- JWT validation for all preference API endpoints ([PR #149](https://github.com/example/ntf/pull/149))

#### Documentation
- Published NTF User Guide and API Reference ([PR #153](https://github.com/example/ntf/pull/153))

#### Operations
- Helm chart deployment to Kubernetes staging cluster ([PR #151](https://github.com/example/ntf/pull/151))

### 3.2 `v0.9.0-rc.3` — `2026-10-20`

#### Added
- Redis-based preference cache with 60s TTL ([PR #140](https://github.com/example/ntf/pull/140))

#### Fixed
- Race condition in preference cache invalidation ([PR #144](https://github.com/example/ntf/pull/144))

---

## 4. Migration Notes

> Describe any breaking changes and how users should migrate.

| Change | Impact | Migration Steps | Owner |
| :--- | :--- | :--- | :--- |
| Legacy synchronous send → async event publishing | Medium | Replace direct provider calls with `POST /v1/notifications`; dual-write for 2 weeks | Alex Rivera |
| Preference opt-out now enforced | High | Review marketing notification lists; users who opted out will no longer receive marketing emails | Priya Shah |

---

## 5. Deprecation Schedule

| Item | Deprecated In | Removal Date | Replacement | Owner |
| :--- | :--- | :--- | :--- | :--- |
| Legacy synchronous send | v1.0.0 | 2026-11-15 | `POST /v1/notifications` | Alex Rivera |

---

## 6. Review & Approval

| Reviewer | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| Priya Shah | QA Lead | 2026-10-22 | Approved |
| Sam Okonkwo | Product Manager | 2026-10-22 | Approved |

---

## 7. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 2026-10-22 | Alex Rivera | Initial draft |
