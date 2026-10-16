---
name: ask-team
description: Ask which team hat, advisor or flow fits your situation. A router over this plugin and how it sits on mattpocock/skills.
disable-model-invocation: true
metadata:
  version: "0.4.2"
---

# Ask Team

The team is two **hats** the main session wears and eight **subagents** it dispatches. You keep invoking the skills you already know; the hat runs inside them.

## With Matt's skills installed

| You run | Hat | Who is dispatched |
|---|---|---|
| `/grill-with-docs`, `/grill-me` | Product Owner (`team-grill`) | LGPD, security, QA advisors every dispatch; UX when a screen is in play; DBA when data is |
| `/to-spec` | Product Owner | every active advisor reviews the draft spec; maintained objections land in `## Team positions` |
| `/to-tickets` | Tech Lead (`team-implement`) | senior developer checks implementability and missing blocking edges |
| `/implement` | Tech Lead | one senior developer per ticket in parallel worktrees; QA reviews every branch, UX, DBA, security, LGPD by what the diff touches; two failed rounds escalate to you |
| `/implement`, in a cockpit | Tech Lead | after the merge, offers one knowledge keeper per project touched, to write the delivery's record, ADRs and glossary terms into it; only on your yes |
| `/triage` | Product Owner | security on suspected vulnerabilities, QA to reproduce |
| `/diagnosing-bugs` | Tech Lead | QA locks the red command, senior developer fixes with a regression test |
| `/improve-codebase-architecture` | Tech Lead | senior developer and DBA survey candidates |

Unchanged and team-free: `/wayfinder`, `/prototype`, `/research`, `/handoff`, `/resolving-merge-conflicts`, `/wizard`, `/code-review` on its own.

## Standalone

Without Matt's skills, run the hats directly: `/team-grill` for the interview (embedded rounds, advisors as above) and `/team-implement` over tickets that already exist in your tracker, or over a spec the Tech Lead splits with your confirmation. Spec and ticket generation, triage, bug diagnosis, wayfinding, prototypes and research are Matt's; install `mattpocock-skills` to get them.

## Where things land

Every advisor and reviewer writes a file under `.scratch/<feature-slug>/team/` (contract: `team-contribution`). Read them where the decision is made: a maintained objection is quoted in the spec, the ticket or the review verdict, never only in a summary.

## Which version is installed

Read `metadata.version` in the frontmatter of this file: it is the version of the skills you are running now. `docs/agents/team.md` records, on its `Team-skills version` line, the version that last set the repo up. When the two differ, say so: the skills were updated after the setup, and re-running `/setup-team` records what the new version added (it asks only the missing sections). A `team.md` with no such line was written by a version before 0.4.1. Do not look in the installer's lockfile: `skills-lock.json` and `.skill-lock.json` hold the source and a hash of each skill, never a semantic version.

## Precondition

`/setup-team`, once per repo. It reuses Matt's tracker and domain settings when they exist and asks for the profile, the advisors, the artifact language and the limits.
