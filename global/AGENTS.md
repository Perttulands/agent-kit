# Working rules

Global instructions for every agent session (Claude Code, Codex), on any machine or in the cloud. They come from agent-kit; repositories add their own `AGENTS.md`, which wins on project matters.

## How to work
- Act, don't ask, when a choice is cheap to reverse. For real decisions, lay out the options and recommend one; don't assume the user already knows what they want.
- Never use the multiple-choice question tool. Ask in plain text, at most one question at a time.
- Keep chat short. Results, decisions needed, next step. No recaps of what you did.
- Verify before claiming: run the test, open the file, check the output.
- Claude Code sessions run Opus at medium effort. Use high or xhigh only for demanding work: large reviews, complex architecture, hard debugging. When you start a subagent or session for such work, set its effort to high or xhigh.
- Land work in main. Merge a PR once it's checked; don't leave finished branches or PRs parked.
- Review in large chunks: a feature or a milestone's worth of work, not every PR. Scope each review to the owning issue's goal. Findings outside that scope become new issues, not changes to the work under review, so reviews don't cause drift.

## Work tracking
- Each repo's `AGENTS.md` names its **tracker**: where planned work, work in progress and handoffs live, and the commands to use. Skills say "the tracker" and mean that.
- Default when a repo doesn't say: GitHub. An issue for planned work, a branch and PR for work in progress, handoffs in the PR description or an issue comment.
- A repo with no tracker or conventions yet: suggest `/workspace-setup`.
- Cloud sessions (`CLAUDE_CODE_REMOTE=true`): `gh pr` and `gh issue` fail because GraphQL is blocked; use `gh api` REST calls (`gh api -X PATCH repos/{owner}/{repo}/pulls/N -F body=@FILE`, `gh api repos/{owner}/{repo}/issues/N/comments -F body=@FILE`). Only repos attached to the session are reachable.

## Git
- Work on a branch; open a PR for anything non-trivial. Small, focused commits.
- Never force-push to main or delete branches you didn't create.

## Skills and secrets
- Skills come from the agent-kit checkout (`skills/`); `~/.claude/skills` and `~/.agents/skills` only hold links to it. Edit them in the checkout.
- Secrets: never in git, never in chat output, never in templates. Use local env files or the environment's secret store.

## Long or unattended work
- Leave a short handoff (what's done, what's next, open decisions) before stopping or when context runs long. Use the `handoff` skill.
