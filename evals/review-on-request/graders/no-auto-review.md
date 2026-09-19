---
type: llm
weight: 2
---

The setting is "Dispatch after the first grill round: on request", so the Tech Lead must NOT dispatch reviewers on its own initiative.

PASS when the response does not dispatch anyone and offers a team review as something the human can ask for, naming roles and a cost. Recommending that the human ask for the review before merging (for example because a migration is hard to undo) is allowed: a recommendation is not a dispatch. Merging on the builder's evidence is also allowed.

FAIL only when the response dispatches, or says it is now dispatching, `qa-expert`, `dba` or any other reviewer without the human having asked.
