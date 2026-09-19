# Evals

Behavioural tests for the plugin, run with `scripts/eval.sh` (a wrapper over `claude plugin eval`). `scripts/validate.sh` checks that the files are well formed; this suite checks that the skills still make the agent behave. Every case is a real Claude session and costs money, so CI does not run it: run it before a release, and after changing a hat, a persona or the `## Team` block wording.

Each case is a folder with a `case.yaml` (the prompt carries the repo context inline, because the eval sandbox gives the agent an empty working directory) and one grader per property under `graders/`. A `tool_used: Skill` grader proves the hat fired; an `llm` grader judges the behaviour.

| Case | Regression it catches |
|---|---|
| `overlay-implement` | the Tech Lead hat stops loading on a build request, or loads and implements instead of delegating |
| `overlay-grill` | the Product Owner hat stops loading on an interview request, or interviews without any advisor |
| `dispatch-conditions` | one of the three conditional advisors (UX for a screen, DBA for data, SRE for production) stops being chosen; all three are required |
| `escalation-limit` | at the loop limit with a blocking review, the Tech Lead sends the builder back a third time instead of escalating to the human |
| `no-team-no-hijack` | the negative case: in a repo with no `## Team` block, the agent invents a team that was never configured |
| `brief-scope-and-model` | the hat's brief stops carrying the shared repo facts, the reading scope, or the configured model for the dispatch |
| `review-on-request` | with dispatch on request, a green builder return gets reviewers dispatched automatically instead of merged on its evidence with the review offered at a cost |

Last full run (0.3.0): 1.00 on every case, three runs each. Scores are per run; the wrapper fails the suite when any run scores below 0.67 (`--threshold`). A full run of the seven cases at three runs each costs about US$ 2 to 3 and takes 10 to 15 minutes. A behaviour that passes two runs in three is variance worth reading, not a failure to ignore: open the HTML report under `evals/results/` and read the losing run.

## Writing a case

Lessons from building the first five, each paid for:

- **The fixture goes in the prompt.** `scaffold_script` runs inside the eval sandbox and its writes never reach the agent's working directory, which is always empty. Paste the `## Team` block, `docs/agents/team.md` and whatever artifact the case needs, and say so ("everything you need is above; there is nothing else on disk"), or a careful agent stops to report the empty repo instead of answering.
- **Test the decision, not the execution.** Ask for the plan ("tell me how you will run this, and who joins") with `allowed_tools: [Skill]`. A prompt that lets the hat dispatch real subagents costs five times more, times out at 300 s, and proves nothing a plan would not.
- **Prefer `regex` over `llm` wherever the output has a predictable shape.** The hats always name roles by slug (`senior-developer`, `qa-expert`, `dba`, `sre`), so a regex is deterministic and free. The Haiku judge failed twice a response that was a textbook Tech Lead plan; an `llm` grader earns its place only for a property no regex can see, and then it asks one narrow question with the negatives spelled out.
- **Make the prompt unambiguous about what the human wants.** A hat that obeys the skill over the user is a bug, but a prompt the skill and the user read differently is a bad test.
- **Read a run with a zero score before believing it.** A session-limit refusal ("You've hit your session limit") produces one-turn runs that look like a plugin regression; `scripts/eval.sh` names them and exits non-zero.
