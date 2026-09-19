---
name: team-contribution
description: The contribution contract every team support follows. Use when dispatched as an advisor, reviewer or builder by the Product Owner or Tech Lead hat, and when a hat writes a brief or reads a return. Defines the brief, the contribution file, positions and objection kinds, rounds, and the return summaries.
---

# Contribution contract

A hat (Product Owner in `team-grill`, Tech Lead in `team-implement`) dispatches supports. Every support writes exactly one file and returns a short summary. The file is the durable record the human can read where the decision is made; the summary is what the hat reads first. Agents never invoke each other: only the hat delegates.

## Dispatch policy: once by default, then on request

A dispatch is the expensive move: every support reads the repo in its own context and writes a file the hat then reads. Left automatic, a build that loops produces several opinions per specialist per ticket, and the cost of advice overtakes the cost of the work. So:

- The roster is dispatched **once by default**: the first round of the grill.
- **Every dispatch after that is the human's call.** The hat proposes it in one line with the cost stated (which roles, how many files) and waits: "Want the advisors on the draft spec? 5 dispatches. `yes` or `skip`." The human can also ask at any time ("review 04 with QA and DBA", "one more advisor pass").
- `docs/agents/team.md` carries the setting: `Dispatch after the first grill round: on request` (the default) or `automatic` (every hook fires without asking, the pre-0.3 behaviour).

A support that is not dispatched writes nothing; there is no file to check and nothing to read. Silence by policy costs zero.

## Size

A file the hat can read in one screen. **Facts**: at most eight bullets, each with its path. **Contribution**: at most six questions or findings, the ones that matter most, ranked; the rest is dropped, never appended. **Positions**: one line per position. A support that has more than that has not finished prioritising. Round 2 appends at most half of that.

## The brief

The hat's prompt carries the task, never the persona (the harness loads the persona). Every brief has:

- **the shared facts**, collected once by the hat so no support rediscovers them: stack and versions, the test command, CI if any, and the directories the design tree or the diff touches
- **the reading scope**: this repository only; start from the paths named in the brief; read until you can answer, then stop; at most twenty files. Looking beyond the repository (sibling projects, the home directory) happens only when the human asked for it, and the brief says so
- the artifact under review: a path, or the design tree so far for a grill round
- the open frontier (grill), or the ticket and its spec section (build and review)
- the paths of `CONTEXT.md` and the ADRs that touch the area, when they exist
- the artifact language, from the `## Team` block
- the mode: with or without Matt's skills
- the size cap above, repeated in one line
- the round number, and in round 2 only, the sibling supports' `## Positions`
- the output path for the contribution file, and this line verbatim: "Call the Skill tool with `team-contribution` and follow it."

Every dispatch also carries a **model**, from `docs/agents/team.md`: advisors and reviewers run on the model configured for them (`sonnet` by default), builders on theirs (`inherit` by default). The hat passes it as the dispatch's model; personas are never forked for it.

Round 1 is **blind**: no brief carries a sibling's contribution. Who sees what is the invariant; whether the harness runs supports in parallel or in sequence is not.

## The file

Path, by dispatch:

| Dispatch | Path |
|---|---|
| grill round | `.scratch/<feature-slug>/team/grill/<agent-slug>.md`, one `## Round N` section appended per round |
| spec review | `.scratch/<feature-slug>/team/spec/<agent-slug>.md` |
| ticket-set check | `.scratch/<feature-slug>/team/tickets/<agent-slug>.md` |
| branch review | `.scratch/<feature-slug>/team/<NN-slug>/<agent-slug>.md` |
| triage, bug, survey | `.scratch/<topic-slug>/team/<agent-slug>.md` |

`.scratch/` is the local scratch area whatever the issue tracker is; on GitHub or GitLab the hat also quotes maintained objections into the issue.

The hat writes each round's brief to `<team-dir>/round-<N>-brief.md` and points the supports at it, so the brief the round was answered against stays on disk beside the answers. A round 2 appends its own `## Round 2` section to each support's existing file and reads the sibling positions from the round 1 sections; it never overwrites round 1.

The headings are exactly the four below, at `##`, with `## Round N` above them when a file spans rounds. A support that nests them deeper breaks the hat's reading of the file.

```markdown
**Collaborator:** <agent-slug>
**Reviewing:** <path, or "grill round N">

## Facts
Findings from the repo, each with a file path, plus the output of any command run. Facts the human would otherwise be asked for.

## Contribution
Grill round: candidate questions for the frontier, each with a recommended answer, in the hat's round format.
Review: findings, each tied to the artifact location it concerns, each with a proposed fix.

## Positions
- AGREE: <what, one line>
- OBJECT [judgment|knowledge]: <what, one line of rationale>
`None` when in full agreement.
```

The first line is the identity marker, verbatim. A hat treats a missing file, or a file without the marker, as an incomplete dispatch: re-dispatch once, then surface it to the human.

## Checking a round is complete

A dispatch that produced no file produced no advice, and a hat that reads only the return summaries cannot tell the difference. Before closing a round, the hat runs [check.sh](./check.sh) with the team directory and every slug it dispatched:

```bash
bash check.sh .scratch/<feature-slug>/team/grill lgpd-analyst security-analyst qa-expert
```

It passes when every named support has a file, each opens with its identity marker, and each carries `Facts`, `Contribution` and `Positions`. A non-zero exit names what to re-dispatch. One re-dispatch, then the human hears about it: the check is evidence, not a retry loop.

## Positions and objection triage

Each `OBJECT` carries a kind, chosen by the support:

- **judgment**: both positions are legitimate (scope, risk appetite, priority, a trade of consistency for speed). The hat puts it to the **human** as a frontier question, with the support's recommendation. Decisions are the human's.
- **knowledge**: an expert can settle it (the law, the code, the suite, a query plan). The hat runs **round 2**: re-dispatch every objecting support with the revised artifact and the other supports' positions, to confirm or maintain. Two rounds maximum, whatever remains.

An objection maintained after triage is **quoted verbatim** in the artifact the hat owns: the spec under a `## Team positions` heading, the ticket, the review verdict. Dissent stays on disk; it never dies in a return summary.

## Return summaries

A support ends with its block and nothing after it.

Advisor or reviewer:

```markdown
## Summary: <agent-slug>, <artifact>
- Produced: <contribution file path>
- Positions: <n> agree, <n> object (<kinds>)
- Blocking: <yes: one line | no>
```

`Blocking: yes` is reserved for a reviewer whose finding must be fixed before merge (a failing suite, an acceptance criterion with no proof, an exploitable path, an irreversible migration with no stated rollback, a missing UI state the spec named). An advisor in a grill round is never blocking.

Builder (`senior-developer`), whose file is the branch itself:

```markdown
## Summary: senior-developer, <ticket>
- Branch: <name>, <n> commits
- Tests: <command>, <passed>/<total>
- Review: <verdict of code-review, or "embedded review">
- Open: <anything the ticket asked for that is not done, or "none">
```

## The Tech Lead's state file

`team-implement` keeps `.scratch/<feature-slug>/team/state.md`, one row per ticket it has touched, with the branch, the state, the review loops already spent and the reviewers that have returned. It is the only file a hat maintains by hand, and it exists for one reason: a session that dies mid-build resumes from it instead of guessing. Everything else the team writes is a record of advice; this one is a record of position.
