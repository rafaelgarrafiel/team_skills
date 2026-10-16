# Knowledge transfer: a delivery's record is written into each project it touched, on the human's yes

When a platform is split across several repositories and the team runs from one of them (the cockpit), every spec, ticket, review verdict and ADR lands in the cockpit. A maintainer who only ever opens the backend finds none of it: the code is there, the reasons are somewhere else. This ADR adds a step after the merge that carries a project-sized summary of the delivery into each project it touched.

## Decision

1. **Registry.** `docs/agents/team.md` gains an optional `## Projects` section, asked by `setup-team`: one line per project with its name, its path relative to the cockpit, its role, and where its domain docs live. Without the section there is no transfer step and the team behaves as before. Paths are relative because the layout has varied (projects nested inside the cockpit, then siblings of it).
2. **A new persona, `knowledge-keeper`.** Neither advisor nor builder: it writes, and it writes outside the cockpit. It is the one persona exempt from ADR 0007's "this repository only", and only for the path of the one project its brief names, plus the cockpit's artifacts for the delivery. One dispatch per affected project, parallel and blind, on the advisors' model. The Tech Lead names the affected projects from the tickets and the ADRs.
3. **The human decides, every time.** After the final suite the Tech Lead asks whether to distribute the knowledge and states the cost in dispatches; nothing runs without a yes. This is stricter than ADR 0006's `automatic` setting on purpose: the step writes into repositories the team does not own.
4. **What a project receives.** Everything the delivery produced, cut to what concerns that project and written as summaries, not copies of the whole:
   - a **delivery record** (`docs/deliveries/<slug>.md`): the problem and decision, the spec slice, the tickets that touched the project, the review verdicts and maintained objections that concern it, links to the ADRs and glossary terms below, and a pointer to the full delivery in the cockpit;
   - **ADRs**: a decision that lives in one project is moved there, leaving a one-line pointer in the cockpit; a decision that crosses projects stays canonical in the cockpit and each affected project gets a short ADR that summarises it and points back;
   - **glossary terms** of that project's context.
   Spec, tickets and verdicts are copied in summary and stay whole in the cockpit as history.
5. **Where it lands.** On a branch of the project, committed, never merged and never pushed. When the project already has a branch carrying the delivery's code, the knowledge goes on that branch so one MR carries both; otherwise a branch of its own. The Tech Lead proposes each project's current branch and the human confirms or names another.
6. **Fitting the project.** Missing `docs/adr/` or `GLOSSARY.md` are created in the Matt format. The project's numbering, language and ADR style win over the cockpit's, and a divergence is reported in the return.
7. **Resumable and idempotent.** `state.md` gains a `## Knowledge` section recording, per project, what was written and on which branch. A second run completes what is missing and updates an existing delivery record; it never duplicates a record or an ADR (ADR 0005's mechanism).

## Considered options

- **Copy the whole spec into every project.** Rejected: five maintainers would each read mostly content that is not theirs. The slice is the point.
- **Transfer at each ticket merge.** Rejected: ADRs and the spec's cross-project framing are only stable once the delivery is done.
- **Automatic at the end.** Rejected by the user: writing into other repositories needs a human yes each time.
- **Leave it in the cockpit and link.** Rejected: the maintainer of one project does not have the cockpit open, and the reason for a decision should survive in the repository the decision shapes.
