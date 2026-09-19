# Degrade gracefully without mattpocock/skills; never vendor them

`team-grill` runs Matt's `grilling` and `domain-modeling`; `team-implement` has the `senior-developer` run his `tdd` and `code-review`. The package must also be installable on its own ("only the team"), so every skill that reaches for one of Matt's has a branch for its absence.

Three options were weighed:

- **Hard dependency**: `setup-team` stops when `mattpocock-skills` is not installed. Simple, but kills the standalone use.
- **Vendoring**: copy Matt's skills into this package. Anyone installing both gets every skill twice, which Matt's own README warns against, and updates drift.
- **Graceful degradation**: `setup-team` detects whether Matt's skills are installed and records it in the `## Team` block. With them, the hats call the Skill tool with `grilling`, `domain-modeling`, `tdd`, `code-review`. Without them, the hats follow a **minimal embedded protocol** (rounds with a frontier for the grill, one red-green slice at a time for the build) and the spec/ticket pipeline (`to-spec`, `to-tickets`) is simply unavailable: the Tech Lead orchestrates over tickets that already exist in the tracker or that the user wrote.

## Decision

Graceful degradation. The package sells the roster and the orchestration; Matt's skills sharpen each step when present.

## Invariants

- No skill in this repo restates the body of a skill from mattpocock/skills. The embedded fallback protocols are deliberately minimal (a few lines), not copies.
- The detection happens once, in `setup-team`, and is recorded in the `## Team` block. Skills read the block; they never probe for Matt's skills at runtime.
- Skills reachable only through Matt (triage, diagnosing-bugs, wayfinder, prototype, research) get no standalone fallback. `ask-team` says so.
