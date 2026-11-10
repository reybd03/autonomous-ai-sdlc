# Release Template

- File Name: `<Project Acronym>_RELEASE.md` or `<Version>_release.md` (e.g. `ntf_release.md`, `v1.0.0_release.md`)
- File Location: `<Project Directory>/releases/` or `<Project Directory>/docs/releases/` — see `design_example/epic_example/releases_example/ntf_release.md`
- Related High Level Design: `<Project Acronym>_HLD.md` (§1.6 Delivery/Rollback Plan)
- Related Low Level Design: `<Project Acronym>_<Epic ID>_LLD.md` (§8 Migration, Coexistence & Rollout)
- Related Changelog: `<Project Acronym>_CHANGELOG.md`
- Related Ops: `<Project Acronym>_OPS.md` (deployment, rollback)
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. This template covers release planning, rollout, rollback, and post-release verification. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – Release <Version> |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Release Status | Draft \| In Review \| Approved \| Scheduled \| Released \| Rolled Back |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Release Owner | <name> (<email>) |
| Release Manager | <name> (<email>) |
| Owning Department / Team | DevOps / Release Engineering |
| Source File Location | <path / repo> |
| Retention | <e.g. Permanent; Disposal: Archive> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |
| Mandatory Reviewers | <name – area – email – date> |

---

## 1. Header / Metadata

- **Title**: <Release title, e.g. "NTF v1.0.0 Production Release">
- **Release ID**: `<project>-release-<n>` (e.g. `ntf-release-01`)
- **Version**: <semver version, e.g. 1.0.0>
- **Parent High Level Design**: `<Project Acronym>_HLD.md` *(optional)*
- **Parent Low Level Design**: `<Project Acronym>_<Epic ID>_LLD.md` *(optional)*
- **Status**: Draft \| In Review \| Approved \| Scheduled \| Released \| Rolled Back
- **Release Type**: <e.g. major, minor, patch, hotfix, beta, RC>
- **Target Environment**: <e.g. production, staging>
- **Release Owner**: <name>
- **Release Manager**: <name>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Scheduled Release Date**: <YYYY-MM-DD>
- **Affected Modules / Components**: <list>

---

## 2. Release Overview

### 2.1 Release Summary
> Describe what this release delivers, the problem it solves, and the desired end state. Include a short bulleted list of key deliverables.

### 2.2 Release Objectives
> List the specific objectives for this release.

- <objective 1>
- <objective 2>

### 2.3 Features & Changes
> List features, bug fixes, and changes included in this release.

| Item | Type | Artifact Reference | Owner |
| :--- | :--- | :--- | :--- |
| <item> | Feature / Bug Fix / Change | <doc link> | <name> |

### 2.4 Exclusions
> List items explicitly excluded from this release.

- <item 1> (rationale)

---

## 3. Rollout Plan

### 3.1 Deployment Strategy
> Describe the deployment approach (blue-green, canary, rolling, big bang).

### 3.2 Rollout Phases
> Describe phased rollout with criteria for advancing between phases.

| Phase | Description | Entry Criteria | Exit Criteria | Owner | Target Date |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Phase 1 | <description> | <criteria> | <criteria> | <name> | <date> |

### 3.3 Feature Flags
> List feature flags used to control rollout.

| Flag | Default | Owner | Rollback Trigger |
| :--- | :--- | :--- | :--- |
| <flag name> | <on/off> | <name> | <condition> |

### 3.4 Communication Plan
> Describe how stakeholders will be notified before, during, and after the release.

| Audience | Channel | Timing | Owner |
| :--- | :--- | :--- | :--- |
| <audience> | <email/slack/meeting> | <when> | <name> |

---

## 4. Rollback Plan

### 4.1 Rollback Triggers
> List conditions that would trigger a rollback.

| Trigger | Description | Owner |
| :--- | :--- | :--- |
| <trigger> | <description> | <name> |

### 4.2 Rollback Procedure
> Step-by-step rollback instructions.

1. <step 1>
2. <step 2>

### 4.3 Rollback Verification
> How to verify the rollback was successful.

- <verification 1>
- <verification 2>

### 4.4 Data Migration Rollback *(optional)*
> How to revert data migrations if needed.

> <description>

---

## 5. Go / No-Go Criteria

### 5.1 Pre-Release Checklist
> Criteria that must be met before release can proceed.

| Check | Yes / N/A | Notes |
| :--- | :--- | :--- |
| All tests pass (unit, integration, E2E) | | |
| Code review complete and approved | | |
| Security review complete | | |
| Performance SLO met | | |
| Documentation updated | | |
| Changelog updated | | |
| Rollback tested | | |
| Stakeholder sign-off obtained | | |

### 5.2 Go / No-Go Decision

| Role | Name | Date | Decision (Go / No-Go) |
| :--- | :--- | :--- | :--- |
| Product Owner | <name> | <YYYY-MM-DD> | |
| Release Manager | <name> | <YYYY-MM-DD> | |
| DevOps Lead | <name> | <YYYY-MM-DD> | |
| Security Reviewer | <name> | <YYYY-MM-DD> | |

---

## 6. Post-Release Verification

### 6.1 Verification Steps
> Steps to verify the release was successful after deployment.

- <step 1>
- <step 2>

### 6.2 Monitoring Plan
> What to monitor after release and for how long.

| Metric | Duration | Alert Threshold | Owner |
| :--- | :--- | :--- | :--- |
| <metric> | <hours/days> | <threshold> | <name> |

### 6.3 Post-Release Review
> When and how the post-release review will be conducted.

- <review details>

---

## 7. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation | Owner |
| :--- | :--- | :--- | :--- | :--- |
| <risk> | <low/med/high> | <low/med/high> | <mitigation> | <name> |

---

## 8. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
