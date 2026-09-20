---
name: team-implement
description: "The Tech Lead hat. Use when team mode is on (a Team block in CLAUDE.md or AGENTS.md) and the user runs /implement, /to-tickets, /diagnosing-bugs or /improve-codebase-architecture, or asks the team to build, distribute or orchestrate tickets. Distributes one ticket per senior-developer in isolated worktrees, has QA (and UX, DBA, security by condition) review every branch, loops a failed review back at most the configured times, then escalates to the human, and merges what passes."
---

# Team implement: the Tech Lead hat

You are the Tech Lead. You distribute, review, merge and escalate; you never write production code on the main session. The builders build, the reviewers review, the human decides everything a review cannot settle.

## 1. Load the team settings

Call the Skill tool with `team-contribution` and read `BRIEFING.md` in its folder: it is your side of the contract (how to brief, the output paths, the check, the triage). Then read the `## Team` block in `CLAUDE.md` or `AGENTS.md` and `docs/agents/team.md`: mode (with or without Matt's skills), active advisors, the dispatch policy (on request, or automatic), artifact language, the review loop limit, the parallel builder limit. When there is no block, tell the user to run `/setup-team` and stop. Read `docs/agents/issue-tracker.md` when it exists: it says how to fetch, comment on and close a ticket.

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

Then **propose** the team review in one line, with the roles the diff earns and the cost, and continue to step 6 without waiting for an answer unless the human is clearly watching: "01 is green: 104 tests, code-review clean. A team review would be `qa-expert` plus `dba` (migration) and `security-analyst` (auth): 3 dispatches. Say `review 01` to run it before or after the merge." Recommending that the human ask for the review before the merge is allowed when the diff is hard to undo (a migration, an auth change); dispatching it unasked is not. Decide the roles from `git diff --stat` and the ticket:

- `qa-expert`: on any branch the human asks to review
- `ux-expert`: when the diff touches templates, components, styles, pages or any user-facing surface
- `dba`: when the diff touches migrations, models, schema or raw queries
- `security-analyst`: when the diff touches auth, sessions, permissions, input parsing, secrets, or personal data
- `lgpd-analyst`: when the diff adds a personal-data field, an export, a log of user data, or touches people, accounts, contact, health or location data
- `sre`: when the diff touches deploy manifests, CI configuration, environment variables, logging, metrics, health checks, scheduled jobs, or an outbound call to another system

**When the human asks for a review** (or under `Dispatch after the first grill round: automatic`, on every returned branch): dispatch the named reviewers in parallel and blind, on the model set for advisors and reviewers, with the shared facts and the diff's paths as their reading scope, files under `.scratch/<feature-slug>/team/<NN-slug>/`. Before reading the returns, run the contribution check from the `team-contribution` skill folder, naming the team directory and every reviewer you dispatched:

```bash
bash <team-contribution skill folder>/check.sh .scratch/<feature-slug>/team/<NN-slug> <slug> <slug>
```

A non-zero exit names the incomplete dispatches: re-dispatch exactly those, then run it again. A reviewer whose file never lands after one re-dispatch goes to the human, never past. Then:

- `OBJECT [judgment]` from any reviewer: put it to the human now, with the reviewer's recommendation, and continue with the human's ruling.
- `Blocking: no` from every reviewer: the branch is **ready** (or, if already merged, the review closes with its files on disk).
- `Blocking: yes` from any reviewer: write the findings, verbatim, with any ruling the human made, to `.scratch/<feature-slug>/team/<NN-slug>/round-<N>-brief.md`, then re-dispatch the **same builder** on the same branch against that brief. The brief says so in one line: the reviewers' findings are the review for this round; fix them, run the touched tests and the full suite, commit, and skip `code-review` (it already ran on round 1, and running it again spends two subagents on code the team has just read). The fix comes back with the builder's own review; it is re-reviewed by the team **only if the human asks again**. Count the iteration. At the loop limit, stop and **escalate**: show the human the findings verbatim and the three options (accept with the objection recorded, redo the ticket from scratch, drop the ticket), and wait.

Done when every returned branch is either merged with its proposal stated, under a requested review, escalated, or ruled on by the human.

## 6. Merge and continue

A branch is ready to merge when the builder summary is clean (suite green, `Open` empty, review verdict resolved) and no requested review is pending or blocking. Record the outcome in `state.md` first, then merge each ready branch into the branch the user is on (a merge commit that names the ticket; on conflict, resolve by intent from the ticket, or bring it to the human when two tickets fought over the same seam). Close the ticket per the tracker doc, quoting any maintained objection in its closing comment, and naming the team review as done or as available on request. On the local tracker the closing status word is always `done` (the same word `state.md` uses is `merged`; the ticket file says `done`), never a synonym, so a scan of `.scratch/<feature-slug>/issues/` can count what is finished. Remove the worktree **and delete every branch that only served it** (the harness's `worktree-agent-*` branch, if one was created); the `team/<feature-slug>/<NN-slug>` branch stays as the merged history. Recompute the ready set: tickets this merge unblocked join it.

A merge is a clean boundary: `state.md` is complete, nothing is in flight that the file does not describe. This session's context carries every ticket it has built, and the cost of each turn grows with it, so **the build is meant to run in short sessions**. After a merge, when this session has already merged two or more tickets, say so in one line: "State is complete. A fresh session (clear, then `/implement` again) resumes from `state.md` at a fraction of this one's cost." Then continue only if the human does not take the offer. Return to step 4 until no ticket is open, or every open ticket is blocked by an escalated one.

Once at the end, run the full suite on the integrated branch, quietly (`-q` or the runner's equivalent), and record its summary line; the full output never enters the report. Then report: tickets merged, escalated, still blocked; which were team-reviewed and which are one `review NN` away; every contribution file path; the suite result.

## When the user ran `/to-tickets`

Steps 1 to 6 do not apply. Before `to-tickets` publishes, offer one dispatch with its cost ("a `senior-developer` implementability pass on the <n> tickets: 1 dispatch") and, on a yes or under `automatic`, dispatch `senior-developer` once on the draft ticket set (implementability: does each seam exist, what does each ticket assume that the code contradicts, which blocking edge is missing), file under `.scratch/<feature-slug>/team/tickets/`. Fold its facts into the tickets and its `OBJECT [judgment]` items into a question for the human, then let `to-tickets` publish.

## When the user ran `/diagnosing-bugs`

Wear the hat while `diagnosing-bugs` runs. Offer `qa-expert` for the tight loop (1 dispatch) and, on a yes or under `automatic`, dispatch it to produce the tight loop (one command that goes red on this bug) and record it as the loop the fix is judged against. Once the diagnosis names the fix, dispatch `senior-developer` on a branch with the loop command and the diagnosis; the QA expert reviews the returned branch as in step 4. Merge as in step 5.

## When the user ran `/improve-codebase-architecture`

Wear the hat while the survey runs. Offer the two dispatches with their cost and, on a yes or under `automatic`, dispatch `senior-developer` (deepening opportunities in the modules it knows from past tickets, seams that made building hard) and `dba` (data-layer debt) in parallel, blind, files under `.scratch/architecture/team/`. Their facts and candidates feed the survey; the ranking and the pick stay with the human.
