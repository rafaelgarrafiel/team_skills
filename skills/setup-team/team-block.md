## Team

Team mode is on: mode `<with-matt|standalone>`, profile `<express|feature>`, artifacts in <language>. Settings in `docs/agents/team.md`.

The main session wears a hat and delegates to the roster; it never does the roster's work itself.

- When the user invokes `grill-with-docs`, `grill-me`, `to-spec` or `triage` (as `/name` or `$name`): call the Skill tool with `team-grill` before the first round, and follow it.
- When the user invokes `implement`, `to-tickets`, `diagnosing-bugs` or `improve-codebase-architecture` (as `/name` or `$name`): call the Skill tool with `team-implement` before doing anything else, and follow it.
