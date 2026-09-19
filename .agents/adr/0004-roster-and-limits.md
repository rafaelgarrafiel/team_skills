# Full roster from v1, lead/support per skill, bounded review loops

The roster is two hats and seven subagents. The hats never write production code: the Product Owner runs the interview and owns the spec; the Tech Lead distributes tickets and owns the merge.

| Role | Kind | Runs where |
|---|---|---|
| Product Owner | hat (`team-grill`) | main session |
| Tech Lead | hat (`team-implement`) | main session |
| `lgpd-analyst` | advisor | subagent |
| `security-analyst` | advisor | subagent |
| `qa-expert` | advisor and reviewer | subagent |
| `ux-expert` | advisor and reviewer, when UI is touched | subagent |
| `dba` | advisor and reviewer, when persistence is touched | subagent |
| `sre` | advisor and reviewer, when a deployed surface or runtime behaviour is touched | subagent |
| `senior-developer` | builder, one per ticket, worktree-isolated | subagent |

Which role leads and which support inside each of Matt's skills is the table in `.agents/roster.md`; the pattern (a lead owns the artifact, supports contribute blind and leave positions on disk, agents never invoke each other) is borrowed from AI-DLC's ensemble protocol, without its engine.

## Decision

- All nine roles ship in v1. A target repo can add its own advisor by dropping a persona that follows the `team-contribution` skill into its harness's agents folder; `setup-team` asks which advisors are active.
- Advisors contribute as **support only**: they never lead a stage and never talk to the human. Their questions reach the human through the hat's frontier.
- QA in `team-implement` does independent review in v1: runs the suite, audits the builder's tests along the Spec axis, names uncovered risk scenarios. Writing its own end-to-end suite is a later, opt-in setting.
- Limits, all `setup-team` settings with these defaults: reviewer to builder loop at most **2** iterations before the Tech Lead escalates to the human; at most **3** builders in parallel (cost and merge conflicts, not capability); advisor rounds at most **2** per artifact.
- Contribution and review files live under `.scratch/<feature-slug>/team/` whatever the tracker (Matt's `to-spec` publishes the spec as an issue on GitHub, so there is no spec file to sit beside), and the hat quotes maintained objections into the artifact itself (spec, ticket, review verdict, or the issue on a real tracker), so the human reviewer trips over dissent where the decision is made.

## Update, 2026-09-18: `sre` added, `architect` deliberately not

The first pilot showed runtime facts arriving from whoever tripped over them: the DBA reported the Kubernetes and backup posture, the security analyst reported ingress rate limiting and proxy headers, and nobody asked what triggers the reminder e-mail the tree assumed. That is an unowned domain, so `sre` joins, scoped broadly (observability, deploy and rollback, incident, runtime capacity, CI/CD), which is AI-DLC's `operations` plus `pipeline-deploy` plus the runtime half of `aws-platform` in one role. Three narrow infra personas would add two handoffs and no coverage, against the same "broad agents, few handoffs" reasoning AI-DLC gives for shipping 11 roles instead of 30.

An `architect` persona was considered and rejected: the vocabulary for module shape, boundaries and seams already has a single source of truth in `codebase-design`, and `domain-modeling` already runs inside the grill. The gap was that nobody reached for it, so the Product Owner hat now loads `codebase-design` when the tree turns structural. System decomposition is the hat's own work, never a dispatch: it is the one question a support cannot own without owning the whole design.

The reviewer tier (AI-DLC's `architecture-reviewer` and `product-lead`) stays out for now. Its idea, an outside reviewer with a bounded iteration cap, is already how `qa-expert` reviews a branch; a second pair of eyes on the spec before `to-tickets` would be a change to `team-grill` rather than a new persona, and waits for a pilot that shows the need.
