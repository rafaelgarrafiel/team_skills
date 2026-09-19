## What it does

`setup-team` writes the two files the hats read: `docs/agents/team.md` (mode, profile, active advisors, artifact language, limits) and a `## Team` block in `CLAUDE.md` or `AGENTS.md` that tells the main session which hat to load for which of Matt's skills. It reuses Matt's tracker and domain settings when they exist rather than asking twice.

## When to reach for it

You invoke this by typing `/setup-team`, once per repo, and the agent won't reach for it on its own. Re-run it only to change a setting or after installing or removing Matt's skills (the mode changes).

## Two files, one block

| File | Who reads it |
|---|---|
| `docs/agents/team.md` | the hats, for settings |
| `## Team` block in `CLAUDE.md` / `AGENTS.md` | the main session, every turn: it is the bridge from Matt's skills to the hats |
| `.codex/agents/*.toml` (Codex only) | Codex, to discover the subagents. You copy them with the command the skill gives you: the Codex manifest cannot ship them and the Codex sandbox cannot write under `.codex/` |

## Common questions

**I already ran `/setup-matt-pocock-skills`. Will this ask the same things again?**
No. Tracker and domain layout are read from `docs/agents/issue-tracker.md` and `docs/agents/domain.md`. Only the team's own settings are asked.

**I run this repo from both Claude Code and Codex. Where does the block go?**
Into the file each harness reads: Codex reads only `AGENTS.md`, Claude Code reads `CLAUDE.md`. The skill writes the block into the current harness's file and, when the other file exists without importing it, into that one too. The lightest shared layout is a `CLAUDE.md` that is just `@AGENTS.md`, so one block serves both.

**Why do advisors run on a smaller model?**
A dispatch on the session's model costs several times one on `sonnet`, and an advisor's job (find the facts, ask the right question, take a position) is cheaper to get right than a builder's code. `Model for advisors and reviewers: inherit` in `docs/agents/team.md` restores the session's model if the advice comes back thinner than the project needs; the builders inherit it by default.

**What does the profile change?**
How often advisors are dispatched during a grill: `express` at round 1 and the final confirmation, `feature` also on rounds that open a new area. Gates and reviews are the same in both.

## It's working if

- `CLAUDE.md` (or `AGENTS.md`) carries a `## Team` block of under ten lines beside Matt's `## Agent skills`.
- Running `/grill-with-docs` afterwards makes the agent load `team-grill` without being told.

## Where it fits

A run-once setup, the precondition of [team-grill](./team-grill.md) and [team-implement](./team-implement.md). The map is [ask-team](../skills/ask-team/SKILL.md).
