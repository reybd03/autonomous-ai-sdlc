# Documentation Template

- File Name: `<Project Acronym>_DOCUMENTATION.md` or `<Guide Name>_doc.md` (e.g. `ntf_user_guide.md`, `ntf_api_reference.md`)
- File Location: `<Project Directory>/docs/` or `<Project Directory>/design/` — see `design_example/epic_example/docs_example/ntf_documentation.md`
- Related High Level Design: `<Project Acronym>_HLD.md` (§6 Publication Updates)
- Related Feature Design: `<Feature ID>_design_document.md`
- Related Test Plan: `<Project Acronym>_TEST_PLAN.md` (§17 Support Use Information)
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description. Keep heading numbering consistent so reviewers can compare across documentation artifacts. Fill in through constant User–AI communication, section by section, confirming each section before proceeding.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – <Document Name> |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Documentation Status | Draft \| In Review \| Reviewed \| Approved \| Published \| Draft v<x.x> \| In Review v<x.x> \| Reviewed v<x.x> \| Approved v<x.x> |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Document Owner | <name> (<email>) |
| Technical Contact | <name> (<email>) |
| Owning Department / Team | Documentation / InfoDev |
| Source File Location | <path / repo> |
| Retention | <e.g. Current Year + 2 Years; Disposal: Delete> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |
| Mandatory Reviewers | <name – area – email – date> |
| Optional Reviewers | <name – area – email – date> |

---

## 1. Header / Metadata

- **Title**: <Short, descriptive documentation title>
- **Doc ID**: `<project>-doc-<n>` (e.g. `ntf-doc-01`)
- **Parent High Level Design**: `<Project Acronym>_HLD.md` (§ reference, e.g. §6)
- **Parent Feature Design**: `<Feature ID>_design_document.md` *(optional)*
- **Status**: Draft \| In Review \| Approved \| Published \| Archived
- **Author**: <name>
- **Reviewers**: <names>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Target Audience**: <e.g. developers, operators, end users, platform engineers>
- **Content Type**: <e.g. user guide, API reference, operator runbook, quick start, tutorial>
- **Format**: <e.g. Markdown, HTML, OpenAPI, PDF>
- **Affected Modules / Components**: <list>

---

## 2. Purpose & Scope

### 2.1 Documentation Overview
> Describe what this document covers, the problem it solves, the current-state gap, and the desired end state. Include a short bulleted list of key deliverables.

### 2.2 Target Audience
> Describe who will read this document and what they need to accomplish. Note any prerequisite knowledge.

### 2.3 Content Scope
> List what is in scope and what is explicitly out of scope.

- **In Scope**:
  - <item 1>
  - <item 2>
- **Out of Scope**:
  - <item 1> (rationale)

### 2.4 Prerequisites
> List what the reader needs before using this documentation (access, accounts, software, environment setup).

---

## 3. Content Structure

### 3.1 Document Sections
> Outline the major sections of this documentation and what each covers.

| Section | Title | Description | Owner |
| :--- | :--- | :--- | :--- |
| 1 | <section title> | <what it covers> | <name> |
| 2 | <section title> | <what it covers> | <name> |

### 3.2 Examples & Code Samples
> List any code examples, configuration snippets, or command-line examples included.

- <example 1>: <purpose>
- <example 2>: <purpose>

### 3.3 Diagrams & Visuals *(optional)*
> List any Mermaid diagrams, screenshots, or architecture visuals.

- <diagram 1>: <purpose>

---

## 4. Accuracy & Verification

### 4.1 Source of Truth
> Identify the authoritative source for the information in this document (HLD, LLD, code, running system).

### 4.2 Verification Steps
> Describe how the documentation was verified against the actual system behavior.

- <step 1>
- <step 2>

### 4.3 Review Checklist
> Items to confirm before publishing.

| Check | Yes / N/A | Notes |
| :--- | :--- | :--- |
| Content matches approved design (HLD/LLD/Feature) | | |
| Code examples compile/run | | |
| Links resolve correctly | | |
| Accessibility review completed | | |
| Security-sensitive info excluded | | |

---

## 5. Publication & Maintenance

### 5.1 Publication Channel
> Where this document is published (developer portal, internal wiki, README, etc.).

### 5.2 Update Triggers
> What events require this document to be updated (release, design change, API change, etc.).

### 5.3 Review Cadence
> How often this document is reviewed for accuracy.

### 5.4 Retirement Plan
> When and how this document will be archived or removed.

---

## 6. Accessibility & Localization *(optional)*

### 6.1 Accessibility Considerations
> Describe accessibility characteristics (screen reader compatibility, color contrast, keyboard navigation, ARIA).

### 6.2 Localization / i18n Considerations *(optional)*
> Describe language support, locale formatting, and translation status.

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

## 8. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
| 1.0 | <YYYY-MM-DD> | <name> | Published |
