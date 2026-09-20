# Briefing, checking and triage: the hat's side of the contract

Read this when you wear a hat. Supports never load it; they load `SKILL.md`, which is deliberately short because it rides along on every dispatch.

## Reading `docs/agents/team.md` from an older setup

A repo configured by an earlier `setup-team` may lack lines that later versions added. Missing lines take the **current defaults**, never the older behaviour, and you say so once, in one line, with the fix: "`team.md` has no `Dispatch after the first grill round`; assuming `on request`. Run `/setup-team` to record it." The defaults:

| Missing line | Assume |
|---|---|
| `Dispatch after the first grill round` | `on request` |
| `Model for advisors and reviewers` | `sonnet` |
| `Model for builders` | `inherit` |
| `sre` absent from `Active advisors` | active (it joins by condition anyway) |
| `Review loop limit`, `Parallel builders`, `Advisor rounds per artifact` | 2, 3, 2 |

Never rewrite `team.md` yourself: `setup-team` owns it, and the user may have left a line out on purpose after reading this table.

## Dispatch policy: once by default, then on request

A dispatch is the expensive move: every support reads the repo in its own context and writes a file the hat then reads. Left automatic, a build that loops produces several opinions per specialist per ticket, and the cost of advice overtakes the cost of the work. So:

- The roster is dispatched **once by default**: the first round of the grill.
- **Every dispatch after that is the human's call.** Propose it in one line with the cost stated (which roles, how many files) and wait: "Want the advisors on the draft spec? 5 dispatches. `yes` or `skip`." The human can also ask at any time ("review 04 with QA and DBA", "one more advisor pass").
- `docs/agents/team.md` carries the setting: `Dispatch after the first grill round: on request` (the default) or `automatic` (every hook fires without asking).

A support that is not dispatched writes nothing; silence by policy costs zero.

## The brief

Your prompt carries the task, never the persona (the harness loads the persona). Every brief has:

- **the shared facts**, collected once by you so no support rediscovers them: stack and versions, the test command, CI if any, and the directories the design tree or the diff touches
- **the reading scope**, in one line: this repository only, start from these paths, stop when you can answer, twenty files at most. Add "the human asked you to look beyond the repository" only when they did
- the artifact under review: a path, or the design tree so far for a grill round
- the open frontier (grill), or the ticket and its spec section (build and review)
- the paths of `CONTEXT.md` and the ADRs that touch the area, when they exist
- the artifact language, from the `## Team` block
- the mode: with or without Matt's skills
- the size cap, in one line
- the round number, and in round 2 only, the sibling supports' `## Positions`
- the output path for the contribution file, and this line verbatim: "Call the Skill tool with `team-contribution` and follow it."

Every dispatch carries a **model**, from `docs/agents/team.md`: advisors and reviewers on theirs (`sonnet` by default), builders on theirs (`inherit`). Pass it as the dispatch's model where the harness takes one (Claude Code's Agent tool does); never fork a persona for it. On Codex there is no per-dispatch model: omit it, and the role inherits `.codex/config.toml` (or a `model` line in its own TOML, which the human may add).

Write each round's brief to `<team-dir>/round-<N>-brief.md` (a grill round, or a builder's re-dispatch after a review) and point the supports at it, so the text a round was answered against stays on disk and a resumed session can re-dispatch against it.

Round 1 is **blind**: no brief carries a sibling's contribution. Who sees what is the invariant; whether the harness runs supports in parallel or in sequence is not.

## Output paths

| Dispatch | Path |
|---|---|
| grill round | `.scratch/<feature-slug>/team/grill/<agent-slug>.md`, one `## Round N` section per round |
| spec review | `.scratch/<feature-slug>/team/spec/<agent-slug>.md` |
| ticket-set check | `.scratch/<feature-slug>/team/tickets/<agent-slug>.md` |
| branch review | `.scratch/<feature-slug>/team/<NN-slug>/<agent-slug>.md` |
| triage, bug, survey | `.scratch/<topic-slug>/team/<agent-slug>.md` |

`.scratch/` is the local scratch area whatever the issue tracker is; on GitHub or GitLab you also quote maintained objections into the issue.

## Checking a round is complete

A dispatch that produced no file produced no advice, and return summaries cannot tell you which happened. Before closing a round, run [check.sh](./check.sh) with the team directory and every slug you dispatched:

```bash
bash check.sh .scratch/<feature-slug>/team/grill lgpd-analyst security-analyst qa-expert
```

It passes when every named support has a file, each opens with its identity marker, and each carries `Facts`, `Contribution` and `Positions`. A non-zero exit names what to re-dispatch. One re-dispatch, then the human hears about it: the check is evidence, not a retry loop.

## Objection triage

- **judgment**: put it to the human as a question, with the support's recommendation. When two supports raise the same judgment, it is one question citing both.
- **knowledge**: state it as a fact in dispute and offer round 2 for the objecting supports (with the revised artifact and the siblings' positions), with its cost; under `automatic`, run it. Two rounds maximum.

An objection maintained after triage is **quoted verbatim** in the artifact you own: the spec under `## Team positions`, the ticket, the review verdict, the closing comment.

## The Tech Lead's state file

`team-implement` keeps `.scratch/<feature-slug>/team/state.md`: one row per ticket touched, with branch, state, loops spent and reviewers returned, plus open rulings, the human's rulings and a log. It is the only file a hat maintains by hand, and it exists so a session that dies mid-build resumes from it instead of guessing. Everything else the team writes is a record of advice; this one is a record of position.
