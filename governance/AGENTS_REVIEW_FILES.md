# Review File Generation & Naming

Whenever a design document (HLD, LLD, Feature Design, Bug Design, Test Plan, Test Cases) is **officially reviewed by all of the AI models** involved in that document's lifecycle, a review file MUST be generated.

**File name schema:** `<epic>_<doc-level>_<review-number>.md`

| Token | Description | Example |
| :--- | :--- | :--- |
| `<epic>` | The epic ID that owns the document | `ntf-pref` |
| `<doc-level>` | Document level of the artifact under review | `hld`, `lld`, `feature-design`, `bug-design`, `test-plan`, `test-cases` |
| `<review-number>` | Sequential two-digit review number, starting at `01` | `01`, `02` |

**File location:** `<Project Directory>/design/epic/reviews/` (or `<Project Directory>/reviews/` when no `design/` tree exists).

**Template:** The review file follows `templates/REVIEW_TEMPLATE.md` and must record every AI model that participated in the review, the artifact version reviewed, findings (acceptable / minor / major), and the review decision.

**Trigger:** A review file is generated once every AI model with drafting responsibility for the artifact has reviewed it and the Document Control status moves to `In Review`, `Approved`, `Rejected`, or `Requires Rework`. No document is considered officially reviewed until its `<epic>_<doc-level>_<review-number>.md` review file exists.
