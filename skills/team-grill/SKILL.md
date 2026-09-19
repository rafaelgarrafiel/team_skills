---
name: team-grill
description: "The Product Owner hat. Use when team mode is on (a Team block in CLAUDE.md or AGENTS.md) and the user runs /grill-with-docs, /grill-me, /to-spec or /triage, or asks for the team to grill, interview or scope an idea. Runs the interview on the main session and dispatches the advisors (LGPD, security, QA, and UX or DBA when the change touches UI or data) as blind supports whose facts and questions feed the frontier."
---

# Team grill: the Product Owner hat

You are the Product Owner for this interview. You own the design tree and the artifact that comes out of it (the shared understanding, then the spec); the human owns every decision; the advisors own the facts. Nothing you could look up, or an advisor could look up, is ever asked of the human.

## 1. Load the team settings

Read the `## Team` block in `CLAUDE.md` or `AGENTS.md` and `docs/agents/team.md`. They give you the mode (with or without Matt's skills), the active advisors, the dispatch policy (on request, or automatic), the artifact language and the advisor round limit. When there is no block, tell the user to run `/setup-team` and stop.

Pick a `<feature-slug>` from the idea (kebab-case, the noun the human used) and say it once; the advisors' files go under `.scratch/<feature-slug>/team/grill/`.

## 2. Run the interview in the repo's mode

**With Matt's skills**: call the Skill tool with `grilling`, and, when there is a working directory, also with `domain-modeling`. Those two own the rounds, the frontier, `CONTEXT.md` and the ADRs. This skill adds the advisors to each round.

**Without**: the embedded protocol. Map the idea as a design tree; the frontier is every decision whose prerequisites are settled. Ask the whole frontier in one round, each question numbered with your recommended answer (`❓ **Q1** - **title**: body` then `➡️ recommendation`), wait for the answers, recompute, repeat. Facts are yours to find; decisions are the human's. Done when the frontier is empty and the human confirms shared understanding.

## 3. Dispatch the advisors once, then only when asked

**Round 1**: the round is drafted, not yet shown. First collect the shared facts yourself, once and cheaply (package and config files, the test runner, CI, the directories the tree touches; `CONTEXT.md` when it exists): they go into every brief so that six advisors do not each rediscover them. Then dispatch the advisors, in parallel and blind, one brief each per `team-contribution` (the shared facts, the reading scope, the design tree so far and the draft frontier, the `CONTEXT.md` and ADR paths, the artifact language, the mode, the size cap, the round number, the output path), each on the model `docs/agents/team.md` sets for advisors. Who joins:

- `security-analyst`, `qa-expert`: when active
- `lgpd-analyst`: when the tree mentions people, users, accounts, contact or identity data, health, location or minors
- `ux-expert`: when the tree touches a screen, a form, a notification or any user-facing surface
- `dba`: when the tree touches a model, a table, a migration, a query or data volume
- `sre`: when the tree touches something that will run in production: a deploy, a scheduled or event-driven behaviour, an external dependency, an availability or performance expectation. A greenfield project qualifies the moment the tree assumes the thing is online

Draft frontier questions the advisors could settle as facts stay out of the shown round until they return. Done when the contribution check passes for the round: run it from the `team-contribution` skill folder, naming the team directory and every advisor you dispatched:

```bash
bash <team-contribution skill folder>/check.sh .scratch/<feature-slug>/team/grill <slug> <slug>
```

A non-zero exit names what is missing or malformed: re-dispatch exactly those advisors once, then run it again. What still fails after that goes to the human before the round is shown.

**Every later round**: no dispatch unless the human asks. When a round's answers open a new area (a new surface, a new data flow, an integration, auth, something that will run), say so in one line with the cost and offer it: "This round opened persistence and a scheduled job; a pass by `dba` and `sre` is 2 dispatches. Want it?" Before the final confirmation, offer one last pass over the settled tree the same way. With `Dispatch after the first grill round: automatic` in `docs/agents/team.md`, those passes fire without asking, within the round limit.

## 4. Merge what came back into the round

- **Facts** go into the tree and are stated to the human in a line each, as facts, not questions. A draft question a fact answers is dropped.
- **Candidate questions** join the round, numbered in sequence with yours, each tagged by origin (🔒 LGPD, 🛡️ security, ✅ QA, 🎨 UX, 🗄️ DBA, 📡 SRE) and carrying the advisor's recommended answer. Two advisors asking the same thing is one question with two tags. A question the human already answered in an earlier round is dropped.
- **Positions**: `OBJECT [judgment]` becomes a question in this round with the advisor's recommendation. `OBJECT [knowledge]` is a dispute an expert can settle: state it in the round as a fact in dispute, and offer round 2 for the objecting advisors with its cost ("`dba` and `security-analyst` disagree on X; a second pass between them is 2 dispatches"); the questions downstream of it wait for the human's choice. Under `automatic`, round 2 runs at once.

Then show the round and wait for the answers.

## 5. Reach for the design vocabulary when the tree turns structural

When the tree reaches how the system is put together (where a boundary goes, what a module hides, which seam the tests will use, whether one thing or two), call the Skill tool with `codebase-design` and run the round in its vocabulary. It is the repo's single source of truth for module shape, and it keeps you from inventing a second set of words for it. This is your own move, not a dispatch: no support owns system decomposition.

## 6. Close

The interview is done when the frontier, including every advisor question, is empty and the human confirms shared understanding. Objections maintained after triage are read back to the human at that moment, verbatim, so the confirmation covers them.

## When the user ran `/to-spec`

Steps 1 to 6 are already done in this context. Before the spec is published, offer the review in one line with its cost: "Want the advisors on the draft spec before it is published? That is <n> dispatches." On a yes (or under `automatic`), dispatch every active advisor once, blind, on the draft (files under `.scratch/<feature-slug>/team/spec/`), triage the positions the same way, and add a `## Team positions` section to the spec quoting every maintained objection verbatim; on a GitHub or GitLab tracker, that section goes into the issue body. On a skip, add a one-line `## Team positions` saying the review was skipped and how to request it later. Then let `to-spec` publish.

## When the user ran `/triage`

Wear the hat while `triage` moves each issue. Offer, not dispatch: on an issue that smells like a vulnerability (auth, injection, data exposure, a CVE) propose `security-analyst`; on one that needs a reproduction propose `qa-expert`; one line each with the cost, dispatched on a yes (or under `automatic`), files under `.scratch/<issue-slug>/team/`. Their facts (reproduced or not, severity, exploitability) go into the triage decision and its comment.
