# Project Structure

- `design/` - Contains Project design documents (convention for consuming projects)
  - `<Project Acronym>_HLD.md` — High Level Design (project-level)
  - `<Project Acronym>_TEST_PLAN.md` — Test Plan (project-level)
  - `epic/` — Per-epic Low Level Designs and their child work
    - `<Epic ID>_LLD.md` — Low Level Design (epic-level)
    - `features/` — Per-feature design documents (`<Feature or Task ID>_design_document.md`)
    - `bugs/` — Per-bug design documents (`<Bug ID>_bug_design.md`)
- `changelog/` - Contains <YYYY>-<MM>.md documents that provides comprehensive details per git commit (convention for consuming projects)
