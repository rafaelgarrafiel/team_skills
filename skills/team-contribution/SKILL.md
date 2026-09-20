---
name: team-contribution
description: The contribution contract every team support follows. Use when dispatched as an advisor, reviewer or builder by the Product Owner or Tech Lead hat. Defines the reading scope, the size cap, the contribution file, positions and objection kinds, and the return summaries. Hats read BRIEFING.md beside this file for how to brief, check and triage.
---

# Contribution contract

You were dispatched by a hat (the Product Owner in `team-grill`, the Tech Lead in `team-implement`). You write exactly one file and return a short summary. The file is the durable record the human reads where the decision is made; the summary is what the hat reads first. You never dispatch anyone: only the hat delegates.

## Reading scope

The brief carries the **shared facts** (stack, test command, CI, the directories in play): trust them, never rediscover them. Read **this repository only**, starting from the paths the brief names, and stop as soon as you can answer; twenty files is the ceiling. Beyond the repository (sibling projects, the home directory) is off limits unless the brief says the human asked for it. Run tests quietly (`-q` or the runner's equivalent) and keep only the summary line.

## Size

A file the hat can read in one screen. **Facts**: at most eight bullets, each with its path. **Contribution**: at most six questions or findings, the ones that matter most, ranked; the rest is dropped, never appended. **Positions**: one line per position. More than that means you have not finished prioritising. A round 2 appends at most half of that.

## The file

Write it at the output path the brief gives you (under `.scratch/<feature-slug>/team/`). In a round 2, append a `## Round 2` section to your existing file; never overwrite round 1. The first line is the identity marker, verbatim; the headings are exactly these, at `##` (with `## Round N` above them when the file spans rounds). A file without the marker or the sections counts as no contribution.

```markdown
**Collaborator:** <agent-slug>
**Reviewing:** <path, or "grill round N">

## Facts
Findings from the repo, each with a file path, plus the summary line of any command run. Facts the human would otherwise be asked for.

## Contribution
Grill round: candidate questions for the frontier, each with a recommended answer, in the hat's round format.
Review: findings, each tied to the artifact location it concerns, each with a proposed fix.

## Positions
- AGREE: <what, one line>
- OBJECT [judgment|knowledge]: <what, one line of rationale>
`None` when in full agreement.
```

## Positions

Each `OBJECT` carries a kind, and you choose it:

- **judgment**: both positions are legitimate (scope, risk appetite, priority, a trade of consistency for speed). The hat will put it to the human with your recommendation; the decision is theirs.
- **knowledge**: an expert can settle it (the law, the code, the suite, a query plan). The hat may run a second round between the objecting supports; state what would settle it.

An objection you maintain is quoted verbatim where the decision is made. Write it so it can be.

## Return summary

End with your block and nothing after it.

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
- Review: <verdict of code-review, "embedded review", or "reviewers' findings applied" on a re-dispatch>
- Open: <anything the ticket asked for that is not done, or "none">
```
