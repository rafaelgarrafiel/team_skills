# Team

Settings the team hats (`team-grill`, `team-implement`) read. Edit freely; re-run `/setup-team` to regenerate.

- **Mode**: `with-matt` | `standalone`
- **Harness**: `claude` | `codex`
- **Profile**: `express` | `feature`
- **Active advisors**: lgpd-analyst, security-analyst, qa-expert, ux-expert, dba, sre
- **Artifact language**: <language>
- **Dispatch after the first grill round**: `on request` | `automatic`
- **Model for advisors and reviewers**: `sonnet` | `inherit`
- **Model for builders**: `inherit` | `sonnet`
- **Review loop limit**: 2 (reviewer to builder iterations before the Tech Lead escalates)
- **Parallel builders**: 3
- **Advisor rounds per artifact**: 2

## Hints from exploration

- Frontend present: yes | no (`<path>`)
- Data layer present: yes | no (`<path>`)
- Deploy or CI config present: yes | no (`<path>`)

## Projects

Optional. Only in a cockpit: a repository that holds the team's grill, specs and tickets for a platform whose code lives in other repositories. After a delivery, `team-implement` offers to write a summary of it into each project touched. Delete this section if the repo is a single project.

| Project | Path (relative to this repo) | Role | Domain docs |
|---|---|---|---|
| <name> | <../path> | <frontend, backend, supporting service> | <GLOSSARY.md at root, GLOSSARY-MAP.md, none yet> |

## Where the team writes

Contribution files under `.scratch/<feature-slug>/team/`, per the `team-contribution` skill. On GitHub or GitLab, maintained objections are also quoted into the issue.
