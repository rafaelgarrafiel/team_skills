# team-skills

A team for a coding agent: two hats the main session wears (Product Owner, Tech Lead) and the subagents they dispatch, layered over mattpocock/skills.

## Language

**Integration branch**:
The one branch that collects every merged ticket of a spec while the spec is being built, kept apart from the branch the user works on.
_Avoid_: feature branch, spec branch

## Multi-project platforms

**Cockpit**:
The repository where the team runs when a platform is split across several repositories: it holds the grill, the spec, the tickets and the decisions of every delivery, and none of the platform's own code.
_Avoid_: ops, hub, orchestrator repo

**Project**:
One of the repositories that make up the platform a cockpit serves, named in the cockpit's `Projects` section whatever its role (frontend, backend, supporting service).
_Avoid_: service, component, app, module

**Knowledge transfer**:
The end-of-delivery step in which what the cockpit recorded about a delivery is written into each project it touched, so a maintainer who only ever opens that project learns what was done there and why.
_Avoid_: handoff, sync, export

**Delivery record**:
The summary of one delivery written into one project: what was decided, which tickets and review verdicts touched that project, and where the full delivery lives in the cockpit.
_Avoid_: changelog, handoff note, spec copy
