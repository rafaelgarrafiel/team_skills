## What it does

`team-implement` is the Tech Lead hat: the main session distributes tickets to senior-developer subagents, has every returned branch reviewed, merges what passes and escalates what does not. The main session never writes production code; it briefs, reads returns, rules on conflicts and merges.

## When to reach for it

Type `/team-implement`, or, with Matt's skills installed, the agent loads it on its own when you run `/implement`, `/to-tickets`, `/diagnosing-bugs` or `/improve-codebase-architecture` in a repo where `/setup-team` has run.

| You have | What happens |
|---|---|
| Tickets with blocking edges (from `/to-tickets` or your tracker) | ready tickets are built in parallel, up to the limit, each in its own worktree |
| A spec and no tickets, with Matt | the hat tells you to run `/to-tickets` first |
| A spec and no tickets, standalone | the hat splits it into tracer-bullet tickets and starts after you confirm the list |

## Prerequisites

`/setup-team` once per repo, and a tracker the hat can read (Matt's `docs/agents/issue-tracker.md`, or the one `/setup-team` wrote). Reviews land under `.scratch/<feature-slug>/team/<NN-slug>/`.

## Build, review, loop, escalate

Every ticket goes through the same four moves. A **builder** gets the ticket, its spec section and the domain docs, builds test-first at the agreed seam, reviews its own diff and commits to its branch. **Reviewers** are dispatched blind on the branch: QA always (runs the suite, audits the tests along the Spec axis), UX, DBA, security, LGPD and SRE by what the diff touches. A blocking finding sends the same builder back with the findings verbatim, at most the configured **loop limit** (2 by default). Past the limit the hat stops and **escalates**: you see the findings and choose to accept with the objection recorded, redo, or drop. A passing branch is merged, its ticket closed, and the tickets it unblocked join the ready set.

## Common questions

**Why does it stop after two failed rounds instead of trying harder?**
A third round on the same findings is where agents start solving the reviewer instead of the ticket. The loop limit turns that into a decision for you, with the evidence in front of you.

**Can two builders conflict?**
Yes, when two tickets touch one seam. The blocking edges from `/to-tickets` are what keep them apart; a conflict at merge time is resolved by intent from the tickets, or brought to you when both tickets have a claim.

## It's working if

- The main session's own diff is empty: every code change arrived on a `team/<feature>/<NN-slug>` branch.
- Each merged ticket has a QA file beside it, and a conditional reviewer's file only when the diff earned one.
- An escalation shows you verbatim findings and three options, never a fourth attempt.

## Where it fits

The last step of the team's chain (`team-grill → /to-spec → /to-tickets → team-implement`) and the hat under Matt's `/to-tickets`, `/diagnosing-bugs` and `/improve-codebase-architecture`. Its sibling is [team-grill](./team-grill.md). The map is [ask-team](../skills/ask-team/SKILL.md).
