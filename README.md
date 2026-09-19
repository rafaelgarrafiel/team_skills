# team-skills

A team for your coding agent. Two **hats** the main session wears (Product Owner, Tech Lead) and seven **subagents** it dispatches (LGPD analyst, security analyst, QA expert, UX expert, DBA, SRE, senior developer). It overlays [mattpocock/skills](https://github.com/mattpocock/skills) when they are installed: you keep running `/grill-with-docs`, `/to-spec`, `/to-tickets`, `/implement`, and the team runs inside them. Without Matt's skills it runs on its own, with a smaller reach.

Status: v0.1.0 built, awaiting the pilots in [PLAN.md](./PLAN.md). Decisions are ADRs in [.agents/adr/](./.agents/adr/).

## How it fits together

| You run | Hat on the main session | Dispatched |
|---|---|---|
| `/grill-with-docs`, `/grill-me` (or `/team-grill`) | Product Owner | LGPD, security and QA advisors before each round; UX when a screen is in play, DBA when data is, SRE when it will run in production. Their facts go into the tree, their questions into the round, tagged by origin |
| `/to-spec` | Product Owner | every advisor reviews the draft spec; maintained objections land in `## Team positions` |
| `/to-tickets` | Tech Lead | senior developer checks implementability and missing blocking edges |
| `/implement` (or `/team-implement`) | Tech Lead | one senior developer per ticket, in parallel worktrees; QA reviews every branch, UX, DBA, security, LGPD and SRE by what the diff touches; two failed rounds escalate to you |
| `/triage` | Product Owner | security on suspected vulnerabilities, QA to reproduce |
| `/diagnosing-bugs` | Tech Lead | QA locks the red command, senior developer fixes with a regression test |
| `/improve-codebase-architecture` | Tech Lead | senior developer and DBA survey candidates |

Three rules hold everywhere: the human decides, the hat owns the artifact, the supports own the facts. Agents never invoke each other; only the hat delegates. Every support writes a file under `.scratch/<feature>/team/` with its `Positions`, and an objection that survives triage is quoted where the decision is made. The full contract is the [`team-contribution`](./skills/team-contribution/SKILL.md) skill; the who-does-what table is [.agents/roster.md](./.agents/roster.md).

## Install

Claude Code, from this repo (it is its own marketplace):

```bash
claude plugin marketplace add rafaelgarrafiel/team_skills
```

```bash
claude plugins install team-skills@team-skills
```

Codex, and any agent that reads the Agent Skills standard:

```bash
npx skills@latest add rafaelgarrafiel/team_skills
```

On Codex the subagents are installed by `/setup-team` (the Codex plugin manifest has no `agents` field); the skills arrive through the command above.

## Setup

Run `/setup-team` once per repo. It detects whether Matt's skills are installed, reuses their issue tracker and domain docs settings when present, and asks for the profile, the active advisors, the artifact language and the loop limits. It writes `docs/agents/team.md` and a `## Team` block in your `CLAUDE.md` or `AGENTS.md`.

## Skills

User-invoked:

- [`setup-team`](./skills/setup-team/SKILL.md): configure the team for this repo ([docs](./docs/setup-team.md))
- [`ask-team`](./skills/ask-team/SKILL.md): which hat or flow fits ([docs](./docs/ask-team.md))

Model-invoked (also reachable by typing them):

- [`team-grill`](./skills/team-grill/SKILL.md): the Product Owner hat ([docs](./docs/team-grill.md))
- [`team-implement`](./skills/team-implement/SKILL.md): the Tech Lead hat ([docs](./docs/team-implement.md))
- [`team-contribution`](./skills/team-contribution/SKILL.md): the contract every support follows ([docs](./docs/team-contribution.md))

## Agents

[`lgpd-analyst`](./agents/lgpd-analyst.md), [`security-analyst`](./agents/security-analyst.md), [`qa-expert`](./agents/qa-expert.md), [`ux-expert`](./agents/ux-expert.md), [`dba`](./agents/dba.md), [`sre`](./agents/sre.md), [`senior-developer`](./agents/senior-developer.md). Canonical files in `agents/` ship to Claude Code as they are; `scripts/build.sh` generates the Codex TOMLs in `dist/codex/agents/`.

## Standalone versus with Matt's skills

| Standalone | With `mattpocock-skills` |
|---|---|
| `/team-grill`: rounds with a frontier, advisors feeding it, on an embedded minimal protocol | the same, on `grilling` and `domain-modeling`: `CONTEXT.md` and ADRs come out |
| `/team-implement` over tickets you already have, or a spec the Tech Lead splits with your confirmation | the same, over `/to-tickets` output, with builders running `tdd` and `code-review` |
| no spec or ticket generation, triage, bug diagnosis, wayfinding, prototypes, research | all of Matt's flows, with the team inside the ones in the table above |

## Harnesses

| Harness | Skills | Agents | Overlay bridge | Status |
|---|---|---|---|---|
| Claude Code | plugin manifest | plugin manifest | `## Team` block plus a `PreToolUse` hook on `Skill` | built; pilot pending |
| Codex | `npx skills add` or the Codex plugin | copied into `.codex/agents/` by `/setup-team` | `## Team` block in `AGENTS.md` | built; parity of parallel builders unverified (see ADR 0002) |

## Development

```bash
scripts/build.sh
```

```bash
scripts/validate.sh
```

`validate.sh` runs `claude plugin validate --strict`, checks version sync across the manifests, skill layout and invocation parity, that `dist/` is fresh, and that the prose carries no em-dashes.
