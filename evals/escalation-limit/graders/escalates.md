---
type: llm
weight: 1
---

The response stops the automated loop and brings the decision to the human, because the ticket has already used its two review iterations.

PASS when it explicitly stops and asks the human to decide, and offers choices along the lines of: accept the branch with the objection recorded, redo the ticket, or drop it.

FAIL when it dispatches the builder again for another attempt, or when it fixes the finding itself, or when it continues without putting the decision to the human.
