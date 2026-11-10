# Templates & Examples

Local ollama AI models (B–F per `users.md`) may draft and modify the template library (`templates/*_TEMPLATE.md`) and the example library (`design_example/*`) as part of the **Documentation / InfoDev** drafting role.

**Section-by-section confirmation:** Like HLDs and Test Plans, templates and examples are filled in through constant communication between the User and the AI model — section by section, confirming each section before proceeding to the next. The model proposes, the User confirms, then the next section begins.

**Before editing a template or example:**

- Create a beads task and assign it to the model performing the work:

  ```bash
  bd create "<title>" --description="<why this template/example exists and what must be done>" --type=task --priority=2 --assignee=<model>
  bd update <id> --claim   # claimed by the model before editing
  bd close <id>            # when the template/example (and its review, if applicable) is complete
  ```

- No template or example may be drafted or edited without an open, claimed beads task assigned to the performing model.
- Rey Benavidez (A) remains accountable (`A`) for all template and example changes per `roles.md` §3.11 and §4 RACI.
