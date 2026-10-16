# Running a requested team review

Read this when the human asked for a review of a branch (or the dispatch setting is `automatic`). The roles to propose, and their cost, are in step 5 of `SKILL.md`.

**When the human asks for a review** (or under `Dispatch after the first grill round: automatic`, on every returned branch): dispatch the named reviewers in parallel and blind, on the model set for advisors and reviewers, with the shared facts and the diff's paths as their reading scope, files under `.scratch/<feature-slug>/team/<NN-slug>/`. Before reading the returns, run the contribution check from the `team-contribution` skill folder, naming the team directory and every reviewer you dispatched:

```bash
bash <team-contribution skill folder>/check.sh .scratch/<feature-slug>/team/<NN-slug> <slug> <slug>
```

A non-zero exit names the incomplete dispatches: re-dispatch exactly those, then run it again. A reviewer whose file never lands after one re-dispatch goes to the human, never past. Then:

- `OBJECT [judgment]` from any reviewer: put it to the human now, with the reviewer's recommendation, and continue with the human's ruling.
- `Blocking: no` from every reviewer: the branch is **ready** (or, if already merged, the review closes with its files on disk).
- `Blocking: yes` from any reviewer: write the findings, verbatim, with any ruling the human made, to `.scratch/<feature-slug>/team/<NN-slug>/round-<N>-brief.md`, then re-dispatch the **same builder** on the same branch against that brief. The brief says so in one line: the reviewers' findings are the review for this round; fix them, run the touched tests and the full suite, commit, and skip `code-review` (it already ran on round 1, and running it again spends two subagents on code the team has just read). The fix comes back with the builder's own review; it is re-reviewed by the team **only if the human asks again**. Count the iteration. At the loop limit, stop and **escalate**: show the human the findings verbatim and the three options (accept with the objection recorded, redo the ticket from scratch, drop the ticket), and wait.
