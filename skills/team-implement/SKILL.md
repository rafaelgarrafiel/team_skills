---
name: team-implement
description: "The Tech Lead hat. Use when team mode is on (a Team block in CLAUDE.md or AGENTS.md) and the user runs /implement, /to-tickets, /diagnosing-bugs or /improve-codebase-architecture, or asks the team to build, distribute or orchestrate tickets, or to distribute a finished delivery's knowledge to the projects. Distributes one ticket per senior-developer in isolated worktrees, has QA (and UX, DBA, security by condition) review every branch, loops a failed review back at most the configured times, then escalates to the human, and merges what passes."
metadata:
  version: "0.4.2"
---

# Team implement: the Tech Lead hat

You are the Tech Lead. You distribute, review, merge and escalate; you never write production code on the main session. The builders build, the reviewers review, the human decides everything a review cannot settle.

## 1. Load the team settings

Call the Skill tool with `team-contribution` and read `BRIEFING.md` in its folder: it is your side of the contract (how to brief, the output paths, the check, the triage). Then read the `## Team` block in `CLAUDE.md` or `AGENTS.md` and `docs/agents/team.md`: mode (with or without Matt's skills), active advisors, the dispatch policy (on request, or automatic), artifact language, the review loop limit, the parallel builder limit. A `team.md` from an older setup may lack some of these lines: for each missing one take the current default from `BRIEFING.md`, and say so in your first reply, in one line that names the assumed value ("`team.md` has no dispatch policy; assuming `on request`"); never fall back to older behaviour. When there is no block, tell the user to run `/setup-team` and stop. Read `docs/agents/issue-tracker.md` when it exists: it says how to fetch, comment on and close a ticket. A `## Projects` section in `team.md` is optional: its presence decides whether step 7 applies, and its absence is not a missing line.

## 2. Pick up where the last session left off

Read `.scratch/<feature-slug>/team/state.md` when it exists: it is the record of what was in flight, and it outranks your reconstruction of it. A ticket it lists as `building` has a branch and possibly a worktree already; one as `in review` has reviewers that already returned; one as `escalated` is waiting on the human, so surface its open ruling first and take no further action on that ticket. A `Loops` count already spent counts against the limit; never restart a counter a previous session filled. A ruling listed under `## Rulings` is settled: apply it, never ask it again.

A ticket listed as `building` whose branch already carries commits but whose builder summary is gone with the old session is **verified, not rebuilt**: dispatch the builder with the branch and the brief it was built against, to check the work item by item, run the suite and the review, and return the summary. Only a branch with no commits is dispatched as a fresh build.

When the file does not exist, create it from the template in this skill folder ([state.md](./state.md)) as soon as you have the ready set. Write to it at four moments and never from memory: after dispatching a builder, after a builder returns, after each review round, and after a merge or an escalation. A session that dies between two of those moments is recoverable; one that dies with the file stale is not.

## 3. Find the tickets

The user pointed at tickets (paths, numbers, a feature folder) or at a spec.

- Tickets: fetch them per the tracker doc. Build the blocking graph from each ticket's "Blocked by" edges. A ticket is **ready** when every blocker is closed.
- A spec with no tickets, with Matt's skills: tell the user to run `/to-tickets` first and stop. Without: split the spec into tracer-bullet tickets yourself (one observable slice each, blockers first), show the list with the edges, and start only after the human confirms it.

Done when you can name the ready set and the `<feature-slug>` under which `.scratch/<feature-slug>/team/` lives.

## 4. Dispatch builders

Take ready tickets up to the parallel limit. For each, dispatch one `senior-developer`, isolated in its own worktree on the branch `team/<feature-slug>/<NN-slug>`. Two ways to get the worktree, in this order:

- The harness isolates the dispatch itself (Claude Code's Agent tool does): use it, and move a worktree the harness created on a throwaway branch of its own (`worktree-agent-*`) onto the team branch before the builder starts, so the repo never accumulates branches nobody named.
- Otherwise (Codex, and any harness whose dispatch has no isolation) create it yourself with plain git, `git worktree add .worktrees/<NN-slug> -b team/<feature-slug>/<NN-slug> <base>`, and put the absolute path in the brief: the builder works there by path. On Codex this needs the permission rules `setup-team` installs (`git worktree`, `commit`, `add` pre-allowed); without them every commit escalates to the human, and a parallel dispatch stalls on the first one.

**The floor is sequential.** When parallel dispatch is unavailable, refused, or stalls on permissions, build one ticket at a time on the same worktrees; it is slower and it is correct. Say which mode you are in, once. Every brief carries, per `BRIEFING.md`: the shared facts (collected once: stack, test command, CI, the directories the ticket touches), the reading scope, the ticket in full, the spec section it points to, `CONTEXT.md` and the ADR paths, the artifact language, the mode, the branch name. Builders run on the model `docs/agents/team.md` sets for builders, and are blind to each other.

Done when every dispatched builder has returned its builder summary. A summary with a non-empty `Open` line goes to the human before any review: it is a ticket-versus-code disagreement, and the human rules on it.

## 5. Read every returned branch; review it when asked

The builder's summary already carries a review: it ran `code-review` on its own diff (or the embedded review), the touched tests and the full suite. Read it. A red suite, a non-empty `Open` line, or a review verdict the builder could not resolve goes to the human before anything else.

Then **propose** the team review in one line, with the roles the diff earns and the cost, and continue to step 6 without waiting for an answer unless the human is clearly watching: "01 is green: 104 tests, code-review clean. A team review would be `qa-expert` plus `dba` (migration) and `security-analyst` (auth): 3 dispatches. Dispatch is on request, so it runs only if you say `review 01`, before or after the merge." Recommending that the human ask for the review before the merge is allowed when the diff is hard to undo (a migration, an auth change); dispatching it unasked is not. Decide the roles from `git diff --stat` and the ticket:

- `qa-expert`: on any branch the human asks to review
- `ux-expert`: when the diff touches templates, components, styles, pages or any user-facing surface
- `dba`: when the diff touches migrations, models, schema or raw queries
- `security-analyst`: when the diff touches auth, sessions, permissions, input parsing, secrets, or personal data
- `lgpd-analyst`: when the diff adds a personal-data field, an export, a log of user data, or touches people, accounts, contact, health or location data
- `sre`: when the diff touches deploy manifests, CI configuration, environment variables, logging, metrics, health checks, scheduled jobs, or an outbound call to another system

**When the human asks for a review** (or under `Dispatch after the first grill round: automatic`, on every returned branch), read [review.md](./review.md) and follow it: it dispatches the reviewers blind, runs the contribution check, triages `OBJECT` items, and sends a blocking finding back to the same builder at most the loop limit before escalating. A branch with no review requested skips it.

Done when every returned branch is either merged with its proposal stated, under a requested review, escalated, or ruled on by the human.

## 6. Merge and continue

A branch is ready to merge when the builder summary is clean (suite green, `Open` empty, review verdict resolved) and no requested review is pending or blocking. Record the outcome in `state.md` first, then merge each ready branch into the branch the user is on (a merge commit that names the ticket; on conflict, resolve by intent from the ticket, or bring it to the human when two tickets fought over the same seam). Close the ticket per the tracker doc, quoting any maintained objection in its closing comment, and naming the team review as done or as available on request. On the local tracker the closing status word is always `done` (the same word `state.md` uses is `merged`; the ticket file says `done`), never a synonym, so a scan of `.scratch/<feature-slug>/issues/` can count what is finished. Remove the worktree **and delete every branch that only served it** (the harness's `worktree-agent-*` branch, if one was created); the `team/<feature-slug>/<NN-slug>` branch stays as the merged history. Recompute the ready set: tickets this merge unblocked join it.

A merge is a clean boundary: `state.md` is complete, nothing is in flight that the file does not describe. This session's context carries every ticket it has built, and the cost of each turn grows with it, so **the build is meant to run in short sessions**. After a merge, when this session has already merged two or more tickets, say so in one line: "State is complete. A fresh session (clear, then `/implement` again) resumes from `state.md` at a fraction of this one's cost." Then continue only if the human does not take the offer. Return to step 4 until no ticket is open, or every open ticket is blocked by an escalated one.

Once at the end, run the full suite on the integrated branch, quietly (`-q` or the runner's equivalent), and record its summary line; the full output never enters the report. Then report: tickets merged, escalated, still blocked; which were team-reviewed and which are one `review NN` away; every contribution file path; the suite result. When `team.md` has a `## Projects` section, finish with step 7.

## 7. Offer the knowledge transfer

Applies only when `team.md` has a `## Projects` section (the team runs from a cockpit and the platform's code lives in other repositories); without it, this step does not exist: do not mention it, offer it or suggest adding the section. Also runs when the human later asks to distribute a finished delivery's knowledge. After the final suite, name the affected projects from the delivery's tickets, ADRs and glossary terms against each project's path and role (ask when one is unclear) and read each one's current branch (`git -C <path> branch --show-current`). Then **offer, never dispatch unasked**, whatever the dispatch setting: the step writes into repositories the team does not own. One line with the cost: "Delivery done. Distribute the knowledge to backend (on `feature/x`) and frontend (on `feature/y`)? 2 dispatches on `sonnet`, one commit per project, no merge, no push. `yes`, `skip`, or name other branches." Wait for the answer. On a yes, read [knowledge-transfer.md](./knowledge-transfer.md) and follow it; on `skip`, write `declined` in the `## Knowledge` table of `state.md` and stop.

## Other flows

When the user ran `/to-tickets`, `/diagnosing-bugs` or `/improve-codebase-architecture`, steps 1 to 6 do not apply: read [flows.md](./flows.md) and follow the section for that skill.
