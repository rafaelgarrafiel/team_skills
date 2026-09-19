---
name: ask-team
description: Ask which team hat, advisor or flow fits your situation. A router over this plugin and how it sits on mattpocock/skills.
disable-model-invocation: true
---

# Ask Team

The team is two **hats** the main session wears and six **subagents** it dispatches. You keep invoking the skills you already know; the hat runs inside them.

## With Matt's skills installed

| You run | Hat | Who is dispatched |
|---|---|---|
| `/grill-with-docs`, `/grill-me` | Product Owner (`team-grill`) | LGPD, security, QA advisors every dispatch; UX when a screen is in play; DBA when data is |
| `/to-spec` | Product Owner | every active advisor reviews the draft spec; maintained objections land in `## Team positions` |
| `/to-tickets` | Tech Lead (`team-implement`) | senior developer checks implementability and missing blocking edges |
| `/implement` | Tech Lead | one senior developer per ticket in parallel worktrees; QA reviews every branch, UX, DBA, security, LGPD by what the diff touches; two failed rounds escalate to you |
| `/triage` | Product Owner | security on suspected vulnerabilities, QA to reproduce |
| `/diagnosing-bugs` | Tech Lead | QA locks the red command, senior developer fixes with a regression test |
| `/improve-codebase-architecture` | Tech Lead | senior developer and DBA survey candidates |

Unchanged and team-free: `/wayfinder`, `/prototype`, `/research`, `/handoff`, `/resolving-merge-conflicts`, `/wizard`, `/code-review` on its own.

## Standalone

Without Matt's skills, run the hats directly: `/team-grill` for the interview (embedded rounds, advisors as above) and `/team-implement` over tickets that already exist in your tracker, or over a spec the Tech Lead splits with your confirmation. Spec and ticket generation, triage, bug diagnosis, wayfinding, prototypes and research are Matt's; install `mattpocock-skills` to get them.

## Where things land

Every advisor and reviewer writes a file under `.scratch/<feature-slug>/team/` (contract: `team-contribution`). Read them where the decision is made: a maintained objection is quoted in the spec, the ticket or the review verdict, never only in a summary.

## Precondition

`/setup-team`, once per repo. It reuses Matt's tracker and domain settings when they exist and asks for the profile, the advisors, the artifact language and the limits.
