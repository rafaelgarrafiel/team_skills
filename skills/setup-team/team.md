# Team

Settings the team hats (`team-grill`, `team-implement`) read. Edit freely; re-run `/setup-team` to regenerate.

- **Mode**: `with-matt` | `standalone`
- **Harness**: `claude` | `codex`
- **Profile**: `express` | `feature`
- **Active advisors**: lgpd-analyst, security-analyst, qa-expert, ux-expert, dba, sre
- **Artifact language**: <language>
- **Review loop limit**: 2 (reviewer to builder iterations before the Tech Lead escalates)
- **Parallel builders**: 3
- **Advisor rounds per artifact**: 2

## Hints from exploration

- Frontend present: yes | no (`<path>`)
- Data layer present: yes | no (`<path>`)
- Deploy or CI config present: yes | no (`<path>`)

## Where the team writes

Contribution files under `.scratch/<feature-slug>/team/`, per the `team-contribution` skill. On GitHub or GitLab, maintained objections are also quoted into the issue.
