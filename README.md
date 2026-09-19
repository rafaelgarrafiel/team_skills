# team-skills

[![validate](https://github.com/rafaelgarrafiel/team_skills/actions/workflows/validate.yml/badge.svg)](https://github.com/rafaelgarrafiel/team_skills/actions/workflows/validate.yml)
[![license](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

**A team for your coding agent.** One agent working alone has one point of view. This gives it colleagues: a Product Owner and a Tech Lead it wears as hats, and specialists (privacy, security, QA, UX, data, SRE, builders) it dispatches and then has to answer to.

It sits on top of [mattpocock/skills](https://github.com/mattpocock/skills). You keep running `/grill-with-docs`, `/to-spec`, `/to-tickets` and `/implement`; the team runs inside them. Installed on its own, it still runs the interview and the build with a smaller reach.

## Install

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin marketplace add rafaelgarrafiel/team_skills
```

```bash
claude plugins install team-skills@team-skills
```

</details>

<details>
<summary><strong>Codex, and other agents</strong></summary>

```bash
npx skills@latest add rafaelgarrafiel/team_skills
```

The skills arrive through the installer. The subagents travel inside the `setup-team` skill; `$setup-team` gives you the one-line copy into `.codex/agents/` (the Codex manifest has no field for agents, and the Codex sandbox cannot write there itself).

</details>

Then run `/setup-team` once per repo, and you are ready. It detects whether Matt's skills are installed, reuses their issue tracker and domain settings, and asks for the profile, the active advisors, the artifact language and the loop limits.

## Why this exists

Four failure modes, and what the team does about each. The evidence under each one is from the first real project built with it: a health portfolio system, greenfield, in a repo with nothing in it.

### #1: The agent asks you what it could have found out

**The problem.** An agent that does not know something asks you. You answer from memory, badly, because the answer is in a repo you have not opened in two months. The interview becomes an exam on your own infrastructure.

**The fix** is to make facts the roster's job and decisions yours. Before every round of the interview, each advisor goes and reads: how authentication already works, what the test command is, where personal data already lives, how anything reaches production. What comes back enters the round as a statement, not a question.

> On the first project, the data advisor came back with this: the system being specified **already existed**, half-built, in another repository on the same machine, under the same administrative process number, with the same 23 initiatives. Nobody in the room remembered. The human ruled to start fresh, and the reason is now an ADR that cites the advisor's file.

### #2: Nobody owns the question that spans everything

**The problem.** Privacy, security, operability, accessibility and data integrity are not steps in a plan. They are questions about every step, and in a single-agent session they belong to nobody, so they surface during review, or in production.

**The fix** is advisors that join by condition, not by phase: the UX advisor when a screen is in play, the DBA when data is, the SRE when something will run in production, and privacy, security and QA on everything.

> Before a line of code existed, the privacy advisor found that the brute-force library the spec had chosen writes e-mail addresses and IPs into its own table, outside the retention rule the same spec defined. The QA advisor found that the formula for "out of date" was either always false or reset itself at every month boundary. The SRE role was added later, after two other advisors kept picking up runtime facts nobody owned.

### #3: Dissent dies in a summary

**The problem.** An agent that disagrees with you, and then complies, leaves no trace of the disagreement. Six weeks later the decision looks unanimous and nobody remembers the cost.

**The fix** is that every specialist writes its own file and ends with positions: `AGREE`, or `OBJECT` tagged as a **judgment** call (both positions legitimate, so it goes to you as a question) or a **knowledge** dispute (an expert can settle it, so the objecting specialists get one more round with each other's positions). Two rounds, maximum. What survives is quoted word for word in the spec, the ticket or the review verdict. The files stay in the repo beside the decision, and before a round closes a check confirms each one landed: a dispatch that produced no file produced no advice, and a return summary cannot tell you which happened.

### #4: The agent grades its own homework

**The problem.** The same agent writes the feature, writes its tests, and tells you it is done. It is the only witness.

**The fix** is that the builder never reviews itself, and that you decide when a second witness is worth paying for. The Tech Lead dispatches one builder per ticket into an isolated worktree; each branch comes back with the builder's own review and a green suite, and the Tech Lead names what a team review would cost ("`review 01`: QA plus DBA and security, 3 dispatches") and moves on. When you ask, separate reviewers read the branch blind, and a blocking finding goes back to the same builder with the findings verbatim, at most twice. Then it stops and escalates to you, with three options, rather than trying a third time. The Tech Lead keeps a state file as it goes, so a session that dies mid-build resumes from what was in flight rather than from a guess.

> A third round on the same findings is where an agent starts solving the reviewer instead of the ticket.

## How it works

Two **hats** and seven **subagents**. A hat is a skill the main session loads, because the interview needs you in the loop and the build needs to dispatch; a subagent runs alone and returns.

| You run | Hat | Dispatched |
|---|---|---|
| `/grill-with-docs`, `/grill-me` | Product Owner | security and QA advisors before round one; privacy when people or personal data are in play, UX when a screen is, DBA when data is, SRE when it will run in production. Later passes offered with their cost |
| `/to-spec` | Product Owner | every active advisor reviews the draft spec, when you accept the offer |
| `/to-tickets` | Tech Lead | a senior developer checks implementability and missing blocking edges |
| `/implement` | Tech Lead | one builder per ticket in parallel worktrees; team reviewers when you ask |
| `/triage` | Product Owner | security on suspected vulnerabilities, QA to reproduce |
| `/diagnosing-bugs` | Tech Lead | QA locks the failing command, a builder fixes it with a regression test |
| `/improve-codebase-architecture` | Tech Lead | a senior developer and the DBA survey candidates |

Four rules hold everywhere. **The human decides**: an advisor recommends, the round asks, you rule. **The hat owns the artifact**, the supports own the facts. **Agents never invoke each other**, so every exchange passes through the hat, and round one is blind: no advisor sees a sibling's contribution before writing its own. **The roster is dispatched once by default**, on the grill's first round; every later dispatch is offered with its cost and runs when you say so, because advice that fires on every loop costs more than the work. Each dispatch is also kept cheap: the hat collects the repo's shared facts once and puts them in every brief, supports read this repository only and stop when they can answer, and advisors run on a smaller model than builders unless you say otherwise.

How the team reaches your session is a `## Team` block that `/setup-team` writes into your `CLAUDE.md` or `AGENTS.md`, beside whatever is already there. That is the whole bridge. On Claude Code a hook reinforces it.

## Reference

Skills split on who can invoke them. **User-invoked** are reachable only when you type them. **Model-invoked** are reachable by you or by the agent, which is what lets the main session load a hat from inside one of Matt's skills.

**User-invoked**

- **[setup-team](./skills/setup-team/SKILL.md)**: configure the team for this repo: mode, profile, active advisors, artifact language, limits. Run once. ([docs](./docs/setup-team.md))
- **[ask-team](./skills/ask-team/SKILL.md)**: which hat or flow fits your situation, and what works without Matt's skills. ([docs](./docs/ask-team.md))

**Model-invoked**

- **[team-grill](./skills/team-grill/SKILL.md)**: the Product Owner hat. Runs the interview, dispatches the advisors blind before each round, merges their facts into the design tree and their questions into the round, and reaches for `codebase-design` when the tree turns structural. ([docs](./docs/team-grill.md))
- **[team-implement](./skills/team-implement/SKILL.md)**: the Tech Lead hat. Reads the tracker, builds the ready set from the blocking edges, dispatches builders in isolated worktrees, has every branch reviewed, merges what passes and escalates what does not. ([docs](./docs/team-implement.md))
- **[team-contribution](./skills/team-contribution/SKILL.md)**: the contract every specialist follows: the brief, the file, the positions, the objection kinds, the return summary. ([docs](./docs/team-contribution.md))

**Agents**

| Agent | Joins |
|---|---|
| [`lgpd-analyst`](./agents/lgpd-analyst.md) | when people or personal data are in play: legal basis, minimisation, retention, data-subject rights (Brazil's LGPD) |
| [`security-analyst`](./agents/security-analyst.md) | the threat model of the change: auth, input, secrets, dependencies |
| [`qa-expert`](./agents/qa-expert.md) | testability at design time; independent review of every built branch |
| [`ux-expert`](./agents/ux-expert.md) | when UI is touched: states, flows, design language, WCAG 2.2 AA |
| [`dba`](./agents/dba.md) | when persistence is touched: schema, migration and rollback, query plans, capacity |
| [`sre`](./agents/sre.md) | when it will run in production: observability, deploy and rollback, incidents, anything scheduled |
| [`senior-developer`](./agents/senior-developer.md) | one ticket per dispatch, built test-first in its own worktree |

A repo can add its own advisor: drop a persona that follows [the contract](./skills/team-contribution/SKILL.md) into your harness's agents folder and list it in `/setup-team`.

## With and without Matt's skills

| On its own | With `mattpocock-skills` |
|---|---|
| `/team-grill`: rounds with a frontier, advisors feeding it, on a minimal embedded protocol | the same, running `grilling` and `domain-modeling`, so `CONTEXT.md` and ADRs come out of it |
| `/team-implement` over tickets you already have, or a spec the Tech Lead splits with your confirmation | the same, over `/to-tickets` output, with builders running `tdd` and `code-review` |
| no spec or ticket generation, triage, bug diagnosis, wayfinding, prototypes or research | all of Matt's flows, with the team inside the ones in the table above |

Installing both is the intended setup. Nothing is duplicated: this package ships no copy of Matt's skills.

## Harnesses

| Harness | Skills | Agents | Bridge | Status |
|---|---|---|---|---|
| Claude Code | plugin manifest | plugin manifest | `## Team` block plus a `PreToolUse` hook | in use |
| Codex | `npx skills add` or the Codex plugin | copied by you, command from `$setup-team` | `## Team` block in `AGENTS.md` (Codex does not read `CLAUDE.md`) | setup verified on a real machine; parallel builders unverified |

## Development

```bash
scripts/validate.sh
```

Checks the manifests, version sync, skill layout and invocation parity, that every frontmatter parses, that the generated Codex agents are fresh, and the prose rules. `scripts/build.sh` regenerates the Codex agent files (`skills/setup-team/codex-agents/`) from `agents/*.md`, the single source of truth for every persona.

```bash
scripts/eval.sh
```

Runs the behavioural suite in [evals/](./evals/README.md) with `claude plugin eval`: does the hat fire, does it delegate, are the conditional advisors chosen, does the Tech Lead escalate at the loop limit, does the plugin stay out of a repo that never configured it. Real sessions, real cost, so it is a release step rather than a CI step.

Decisions live in [.agents/adr/](./.agents/adr/); the phased plan and its pilot criteria in [PLAN.md](./PLAN.md).
