## Team

Team mode is on: mode `<with-matt|standalone>`, profile `<express|feature>`, artifacts in <language>. Settings in `docs/agents/team.md`.

The main session wears a hat and delegates to the roster; it never does the roster's work itself.

- When the user runs `/grill-with-docs`, `/grill-me`, `/to-spec` or `/triage`: call the Skill tool with `team-grill` before the first round, and follow it.
- When the user runs `/implement`, `/to-tickets`, `/diagnosing-bugs` or `/improve-codebase-architecture`: call the Skill tool with `team-implement` before doing anything else, and follow it.
