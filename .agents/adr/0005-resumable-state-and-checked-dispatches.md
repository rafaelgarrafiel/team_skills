# A state file for the build, and a check that a dispatch produced advice

Two things the prose could not guarantee, taken from AI-DLC's engine and rebuilt at the size a hat can carry without one.

**Resumption.** AI-DLC keeps persistent state and a recovery ledger, so a dead session resumes at the exact step. Our Tech Lead re-derived the ready set from the tracker each run, which recovers the queue but loses what was in flight: which builder is out, how many reviewer round trips a ticket has already spent against the limit, which reviewers have returned. A resumed session could silently hand a ticket a third and fourth attempt at a limit of two.

**Completion evidence.** AI-DLC's engine refuses to close a stage while a declared support's contribution file is missing or lacks its identity-marker first line. Ours told the hat to re-dispatch once and otherwise trusted the return summaries, which are written by the same agent whose file may not exist.

## Decision

- `team-implement` maintains `.scratch/<feature-slug>/team/state.md` (template: `skills/team-implement/state.md`): one row per ticket with state, branch, loops spent and reviewers returned, plus open rulings and a log. Written at four moments, never from memory: builder dispatched, builder returned, review round done, merged or escalated. On entry the hat reads it and treats it as outranking its own reconstruction.
- `skills/team-contribution/check.sh` takes a team directory and the slugs dispatched, and exits non-zero unless each has a file opening with `**Collaborator:** <slug>` and carrying `Facts`, `Contribution` and `Positions`. Both hats run it before closing a round. One re-dispatch for what fails, then the human hears about it: it is evidence, not a retry loop.

## What this deliberately does not become

An engine. There is no state machine, no audit event taxonomy and no tool that owns transitions; the hat still decides, and a human can read and edit both files. The two mechanisms buy the two properties that mattered most from a deterministic engine (resume, and evidence a dispatch happened) at the cost of two files, and leave the routing where it is.

The remaining gaps to AI-DLC are recorded rather than closed: automatic traceability sensors, source-tagged claims, a model tier per role, and any phase after merge. The post-merge phase is the largest and is a scope decision, not an omission.
