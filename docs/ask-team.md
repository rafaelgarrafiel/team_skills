## What it does

`ask-team` is the router: which hat runs inside which of Matt's skills, who gets dispatched, what works standalone and what needs Matt's skills installed.

## When to reach for it

You invoke this by typing `/ask-team`, and the agent won't reach for it on its own. Reach for it when you forget whether a flow is team-aware, or what the team does without Matt.

## Which version is installed

`/ask-team` answers it. Every skill carries its version in its frontmatter (`metadata.version`), because the lockfile that `npx skills` keeps records only where a skill came from and a hash of it, never a semantic version, and an agent asked "which version?" finds nothing there. `docs/agents/team.md` records the version that last ran `/setup-team`, so a repo that was set up before an update shows the difference.

## Where it fits

The map over [team-grill](./team-grill.md), [team-implement](./team-implement.md), [setup-team](./setup-team.md) and [team-contribution](./team-contribution.md).
