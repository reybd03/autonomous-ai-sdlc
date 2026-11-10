# Beads Epic Association & Work-Limit Rules

These rules govern how beads issues (tasks, bugs, features) relate to epics and how work is sequenced.

### Rule 1 — Bugs fall under the epic they were fixed in

Every bug fix must be associated with the epic in which the fix was delivered. A bug design document (`<Bug ID>_bug_design.md`) lives under `design/epic/<Epic ID>/bugs/` and its `<Bug ID>_bug_design.md` header **must** carry a `Related Epic` field (`<parent-epic-id>`). A bug ticket created with `bd create` must be a child of that epic (`--parent=<epic-id>`). No bug may be tracked as a loose, epic-less issue.

### Rule 2 — No loose beads tasks; every task needs an epic

No beads task may exist without an epic parent. When creating any new task (feature, bug, or chore), you must either:

- **A. Create an epic for it** — if no existing epic owns the work, create a parent epic issue first, then create the task with `--parent=<epic-id>`.
- **B. Fall under a pre-existing epic** — if an existing epic already owns the work area, create the task as a child of that epic with `--parent=<epic-id>`.

Loose, epic-less tasks are prohibited. Use `bd orphans` and `bd blocked` to surface any task without a parent epic.

### Rule 3 — No new work outside bug fixes until the current epic is complete

While an epic is open (not closed), no new feature, chore, or non-bug work may be started. The only permitted new work is bug fixes scoped to the current epic (or critical production defects approved by the Product Owner). New epics, new features, and new non-bug tasks are blocked until the current epic's LLD is Approved and all its child features and bugs are closed.

These rules are enforced at `bd create` time: a task without `--parent=<epic-id>` must be rejected, and a non-bug task created while an epic is open must be rejected unless approved by the Product Owner.
