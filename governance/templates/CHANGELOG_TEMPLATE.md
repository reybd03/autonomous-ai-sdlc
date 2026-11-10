# Changelog Template

- File Name: `<Project Acronym>_CHANGELOG.md` or `<YYYY>-<MM>.md` (e.g. `2026-10.md`)
- File Location: `<Project Directory>/changelog/` or `<Project Directory>/` — see `design_example/epic_example/changelog_example/ntf_changelog.md`
- Related High Level Design: `<Project Acronym>_HLD.md`
- Related Release: `<Project Acronym>_RELEASE.md` *(optional)*
- Programming Languages: <List of languages>
- Table of Contents: see section headings below

> **How to use this template:** Replace every `<...>` placeholder with project-specific content. Follow the [Keep a Changelog](https://keepachangelog.com/) format. Each entry should reference a git commit, PR, or beads issue. Sections marked *(optional)* may be omitted when not applicable, but justify the omission in the PR description.

## Document Control *(recommended)*

| Field | Value |
| :--- | :--- |
| Document Title | `<Project Acronym>` – Changelog |
| Document Number / Name | <entry in project database> |
| Version | <e.g. v1.0> |
| Status | Draft \| In Review \| Approved \| Published |
| Date Created | <YYYY-MM-DD> |
| Date Last Updated | <YYYY-MM-DD> |
| Document Owner | <name> (<email>) |
| Owning Department / Team | Documentation / InfoDev / Release Engineering |
| Source File Location | <path / repo> |
| Retention | <e.g. Permanent; Disposal: Archive> |
| Export Classification | <code> |
| Required Approvers | <name – role – email – date> |

---

## 1. Header / Metadata

- **Title**: <Project Acronym> Changelog
- **Changelog ID**: `<project>-changelog-<n>` (e.g. `ntf-changelog-01`)
- **Covered Period**: <YYYY-MM-DD to YYYY-MM-DD> or <Version X.Y.Z>
- **Status**: Draft \| In Review \| Approved \| Published
- **Author**: <name>
- **Reviewers**: <names>
- **Date Created**: <YYYY-MM-DD>
- **Date Last Updated**: <YYYY-MM-DD>
- **Related Release**: <version or release tag> *(optional)*
- **Affected Modules / Components**: <list>

---

## 2. Change Log Format

> Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) conventions:
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

### 3.1 `<Version>` — `<YYYY-MM-DD>`

#### Added
- <feature 1> ([commit/PR/issue #](link))
- <feature 2> ([commit/PR/issue #](link))

#### Changed
- <change 1> ([commit/PR/issue #](link))
- <change 2> ([commit/PR/issue #](link))

#### Deprecated
- <item 1> ([commit/PR/issue #](link))

#### Removed
- <item 1> ([commit/PR/issue #](link))

#### Fixed
- <bug fix 1> ([commit/PR/issue #](link))
- <bug fix 2> ([commit/PR/issue #](link))

#### Security
- <security fix 1> ([commit/PR/issue #](link))

#### Documentation
- <doc change 1> ([commit/PR/issue #](link))

#### Operations
- <ops change 1> ([commit/PR/issue #](link))

### 3.2 `<Previous Version>` — `<YYYY-MM-DD>`

> Repeat the above structure for each version covered by this changelog file.

---

## 4. Migration Notes

> Describe any breaking changes and how users should migrate.

| Change | Impact | Migration Steps | Owner |
| :--- | :--- | :--- | :--- |
| <change> | <low/medium/high> | <steps> | <name> |

---

## 5. Deprecation Schedule

| Item | Deprecated In | Removal Date | Replacement | Owner |
| :--- | :--- | :--- | :--- | :--- |
| <item> | <version> | <YYYY-MM-DD> | <replacement> | <name> |

---

## 6. Review & Approval

| Reviewer | Role | Date | Decision |
| :--- | :--- | :--- | :--- |
| <name> | <role> | <YYYY-MM-DD> | Approved / Requested Changes |

---

## 7. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | <YYYY-MM-DD> | <name> | Initial draft |
