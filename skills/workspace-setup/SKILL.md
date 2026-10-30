---
name: workspace-setup
description: Set up a repo for agent work with the user: tracker, conventions, starting issues. Use when the user explicitly requests it.
---

# Workspace setup

Bring one repo to the point where any agent, in any environment, can pick up work from its files alone. Settle each choice with the user, one question at a time with your recommendation; read the repo and the user's other repos for facts yourself.

## 1. Choose the tracker

The **tracker** is where planned work, work in progress and handoffs live. Recommend from what the repo and the user already use: GitHub issues and PRs by default; Beads (`bd`) where the user runs it; a plain `TODO.md` only for a throwaway repo. Done when the user has named the tracker and you know its commands for: create an item, comment, close, and list open work.

## 2. Write `AGENTS.md`

Write the repo's root `AGENTS.md`, short, every line something an agent can't find by looking:

- **Work tracking:** the tracker, where the settled design or current goal lives, the unit of work (an issue per PR, a milestone per release…), where handoffs go.
- **Principles:** the few rules that decide tradeoffs in this repo, each with its reason.
- **Before pushing:** the exact commands CI runs.

Claude Code reads `AGENTS.md` only when the repo has no `CLAUDE.md`. If one exists or the user wants one, make its first line `@AGENTS.md` and keep Claude-only material below it.

Done when a fresh agent given only the repo could answer: what to work on next, where to record it, and how to check it before pushing.

## 3. Seed the work

Create the starting items in the tracker: the settled goal (one item that later work links to), the first milestone or equivalent, and its first few issues with acceptance criteria. Done when the next piece of work exists as an item an agent can pick up.

## 4. Repo-only skills

Add a skill to the repo only when it is about this repo alone (its release flow, its benchmark harness). Put it in `.agents/skills/<name>/` and, for Claude Code, `.claude/skills/<name>/` too; copy rather than link if the repo is used on Windows. Shared skills stay in agent-kit.

## Examples

Worked setups, each with what held up and what didn't, are in [examples/](examples/). Read the closest one before step 2. After a setup, add the repo there once a few weeks of work have shown what held up.
