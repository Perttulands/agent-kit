# agent-kit

A small, portable setup for coding agents: shared working rules, a handful of skills, and installers that put them where Claude Code and Codex look. Clone it, run one installer, then run `/workspace-setup` in each repo you work in.

## Install

```powershell
git clone https://github.com/Perttulands/agent-kit.git
powershell -ExecutionPolicy Bypass -File agent-kit\install.ps1
```

```bash
git clone https://github.com/Perttulands/agent-kit.git ~/agent-kit && ~/agent-kit/install.sh
```

The installer:

- links each folder in `skills/` into `~/.claude/skills` (Claude Code) and `~/.agents/skills` (Codex, and other agents that follow the `.agents` convention);
- writes `~/.claude/CLAUDE.md`, which imports `global/AGENTS.md`;
- writes `~/.codex/AGENTS.md` as a copy of the same rules, if Codex is installed.

Rerun it after pulling. Your own facts (name, machine quirks, where your repos live) go in `~/.agents/personal.md`; the installer includes that file when it exists.

For Claude Code cloud sessions, paste `cloud-setup.sh` into the environment's setup script.

## What's here

| Path | What |
| --- | --- |
| `global/AGENTS.md` | Working rules for every session. Each repo's own `AGENTS.md` names its tracker and conventions. |
| `skills/` | Skills in the open [Agent Skills](https://agentskills.io) format. `workspace-setup` sets a repo up for agent work. `agent-bridge` lets Claude Code and Codex hand work to each other (Windows, PowerShell). |
| `install.ps1`, `install.sh` | The installers. |
| `cloud-setup.sh` | Setup script for a Claude Code cloud environment. |
