# Operations Template

- File Name: `<Project Acronym>_OPS.md` or `<Runbook Name>_ops.md` (e.g. `ntf_ops.md`, `ntf_deployment_runbook.md`)
- File Location: `<Project Directory>/ops/` or `<Project Directory>/docs/ops/` — see `design_example/epic_example/ops_example/ntf_ops.md`
- Related High Level Design: `<Project Acronym>_HLD.md` (§3.11 Health Checks, §3.2 RAS)
- Related Release: `<Project Acronym>_RELEASE.md`
- Related Test Plan: `<Project Acronym>_TEST_PLAN.md` (§8 Infrastructure)
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. This template covers operational procedures, runbooks, deployment checklists, health checks, and incident response. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – <Ops Document Name> |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Ops Status | Draft \| In Review \| Reviewed \| Approved \| Active \| Retired \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Document Owner | <name> (<email>) |
| Technical Contact | <name> (<email>) |
| Owning Department / Team | DevOps / SRE / Platform Engineering |
| Source File Location | <path / repo> |
| Retention | <e.g. Current Year + 2 Years; Disposal: Delete> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |
| Mandatory Reviewers | <name – area – email – date> |

---

## 1. Header / Metadata

- **Title**: <Short, descriptive ops document title>
- **Ops ID**: `<project>-ops-<n>` (e.g. `ntf-ops-01`)
- **Parent High Level Design**: `<Project Acronym>_HLD.md` (§ reference, e.g. §3.2, §3.11)
- **Parent Release**: `<Project Acronym>_RELEASE.md` *(optional)*
- **Status**: Draft \| In Review \| Approved \| Active \| Retired
- **Author**: <name>
- **Reviewers**: <names>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Ops Type**: <e.g. runbook, deployment checklist, incident response, health check, backup/restore>
- **Target Audience**: <e.g. DevOps, SRE, platform engineers, on-call>
- **Environment**: <e.g. production, staging, development>
- **Affected Modules / Components**: <list>

---

## 2. Purpose & Scope

### 2.1 Operations Overview
> Describe what this ops document covers, the operational problem it solves, and the desired end state. Include a short bulleted list of key deliverables.

### 2.2 Target Environments
> List the environments where these procedures apply (production, staging, development, DR).

### 2.3 In Scope
> List operational activities covered by this document.

- <activity 1>
- <activity 2>

### 2.4 Out of Scope
> List operational activities explicitly excluded.

- <activity 1> (rationale)

---

## 3. Architecture & Components

### 3.1 System Overview
> Brief description of the system architecture relevant to operations.

### 3.2 Components & Dependencies
> List components, their owners, and operational dependencies.

| Component | Owner | Dependency | Health Check |
| :--- | :--- | :--- | :--- |
| <component> | <team> | <depends on> | <endpoint or method> |

### 3.3 Ports & Endpoints
> List network ports, endpoints, and service URLs used for operations.

| Port | Protocol | Purpose | Source | Destination |
| :--- | :--- | :--- | :--- | :--- |
| <port> | <tcp/udp/http> | <purpose> | <source> | <destination> |

### 3.4 Configuration & Environment Variables
> List configuration parameters and environment variables required for operations.

| Variable | Description | Default | Required | Sensitive |
| :--- | :--- | :--- | :--- | :--- |
| <VAR_NAME> | <description> | <default> | Yes / No | Yes / No |

---

## 4. Health Checks & Observability

### 4.1 Health Check Endpoints
> List health check endpoints and their expected responses.

| Endpoint | Method | Expected Response | Alert Threshold |
| :--- | :--- | :--- | :--- |
| <path> | <GET> | <200 OK> | <e.g. >5s latency> |

### 4.2 Metrics
> List key operational metrics and their alert thresholds.

| Metric | Description | Warning Threshold | Critical Threshold |
| :--- | :--- | :--- | :--- |
| <metric> | <description> | <value> | <value> |

### 4.3 Logs & Tracing
> List log locations, log levels, and tracing configuration.

| Log Source | Location | Level | Retention |
| :--- | :--- | :--- | :--- |
| <source> | <path> | <info/debug/error> | <days> |

---

## 5. Operational Procedures

### 5.1 Deployment Procedure
> Step-by-step deployment instructions.

1. <step 1>
2. <step 2>

### 5.2 Rollback Procedure
> Step-by-step rollback instructions in case of deployment failure.

1. <step 1>
2. <step 2>

### 5.3 Scaling Procedure
> How to scale the system up or down.

1. <step 1>
2. <step 2>

### 5.4 Backup & Restore Procedure
> How to back up and restore data.

1. <step 1>
2. <step 2>

### 5.5 Certificate & Secret Rotation
> How to rotate certificates, secrets, and API keys.

1. <step 1>
2. <step 2>

### 5.6 Maintenance Procedure
> Routine maintenance tasks and their frequency.

| Task | Frequency | Procedure Reference | Owner |
| :--- | :--- | :--- | :--- |
| <task> | <daily/weekly/monthly> | <section or link> | <team> |

---

## 6. Incident Response

### 6.1 Incident Classification
> Define severity levels and response times.

| Severity | Definition | Response Time | Escalation Contact |
| :--- | :--- | :--- | :--- |
| Sev-1 | Production outage | <15 min | <name/team> |
| Sev-2 | Major degradation | <1 hour | <name/team> |
| Sev-3 | Minor issue | <4 hours | <name/team> |
| Sev-4 | Cosmetic | <1 business day | <name/team> |

### 6.2 Incident Response Steps
> High-level incident response workflow.

1. **Detect**: <how incidents are detected>
2. **Triage**: <how severity is assessed>
3. **Mitigate**: <how impact is reduced>
4. **Resolve**: <how root cause is fixed>
5. **Communicate**: <how stakeholders are notified>
6. **Post-mortem**: <how lessons are documented>

### 6.3 On-Call Contacts
> List on-call rotation and contact information.

| Role | Name | Contact | Rotation |
| :--- | :--- | :--- | :--- |
| <role> | <name> | <phone/slack> | <schedule> |

---

## 7. Security & Compliance *(optional)*

### 7.1 Security Considerations
> Describe security implications of operational procedures.

### 7.2 Compliance Requirements
> List compliance frameworks and controls applicable to operations.

| Control | Requirement | Evidence | Owner |
| :--- | :--- | :--- | :--- |
| <control> | <description> | <evidence location> | <team> |

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
