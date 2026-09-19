# Cut the cost of each dispatch: reading scope, model per role, conditional LGPD

ADR 0006 cut the *number* of dispatches. The cost of *each* one has two parts, and the larger is not the file the support writes but the context it fills reading the repo. On the first project each of six advisors independently rediscovered the stack, the test command and the migration layout, and several read other repositories on the same machine. Every dispatch also ran on the session's model, the most expensive one, whether it was a builder writing code or an advisor answering "does this touch personal data".

## Decision

1. **Reading scope in the brief.** The hat collects the shared facts once (stack, test command, CI, the directories the design tree or the diff touches) and puts them in every brief, so no support rediscovers them. A support reads **this repository only**, starting from the paths the brief names, and stops when it can answer: "read until you can answer, then stop", with a cap of twenty files. Roaming the machine was the single most valuable thing an advisor did on the first project (it found the sibling system) and it is now a thing the human asks for, not a default.
2. **Model per role, chosen at dispatch.** `docs/agents/team.md` gains `Model for advisors and reviewers: sonnet | inherit` (default `sonnet`) and `Model for builders: inherit | sonnet` (default `inherit`). The hat passes it as the `model` of each dispatch; nothing is forked. Quality of advice under the cheaper model is a question the next project answers; the setting makes it reversible.
3. **`lgpd-analyst` joins by condition**, like UX, DBA and SRE: when the tree or the diff mentions people, users, accounts, contact or identity data, health, location, minors. Security and QA stay unconditional.

## Why not less

Dropping advisors to one round was ADR 0006. Dropping the roster to two roles would remove the coverage the first project showed to be real. Dropping the file in favour of a chat return would lose the on-disk dissent that ADR 0004 exists for. What remains after this ADR is the cost of the advice itself, which is the product.
