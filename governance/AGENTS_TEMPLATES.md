# Templates

- `templates/HLD_TEMPLATE.md` — High Level Design template (modernized)
- `templates/LLD_TEMPLATE.md` — Low Level Design template (epic level; sits between HLD and Feature Design)
- `templates/FEATURE_DESIGN_TEMPLATE.md` — Feature/bug design document template
- `templates/BUG_DESIGN_TEMPLATE.md` — Bug design document template
- `templates/TEST_PLAN_TEMPLATE.md` — Test plan template
- `templates/TEST_CASE_TEMPLATE.md` — Test case specification template
- `templates/DOCUMENTATION_TEMPLATE.md` — Documentation template (user guides, API references, operator runbooks)
- `templates/CHANGELOG_TEMPLATE.md` — Changelog template (Keep a Changelog format)
- `templates/OPS_TEMPLATE.md` — Operations template (runbooks, deployment checklists, incident response)
- `templates/REVIEW_TEMPLATE.md` — Review template (design/code/gate reviews with push-back authority)
- `templates/RELEASE_TEMPLATE.md` — Release template (release planning, rollout, rollback, go/no-go)
- `templates/COMPLIANCE_TEMPLATE.md` — Compliance template (GDPR, CCPA, HIPAA, SOC 2, ISO 27001, PCI DSS, Common Criteria)
- `templates/COMMENTS_TEMPLATE.md` — Review Comments template (reviewer comments and findings for any design document)
- `templates/Project_Analysis_TEMPLATE.md` — Project Analysis template (project feasibility, options analysis, rollout)

### When to Use Which

- **HLD** — project/line-item level: architecture, impacts, external/internal design.
- **LLD** — epic level: decomposes an epic into child features, shared technical design, rollout.
- **Feature Design** — per feature/bug issue: detailed design, API, data model, QA.
- **Test Plan** — per project/feature: test strategy, environments, criteria, traceability.
- **Test Cases** — per test plan: individual test case specs.
- **Project Analysis** — per project: feasibility study, options analysis, rollout plan. Sits directly under `design/`.
