---
name: agent-bridge
description: Hand work to the other coding agent (Claude Code or Codex) and get its reply back. Use when the user asks for Codex, ChatGPT, Claude or Claude Code, for OpenAI-native work such as image generation, or for a second opinion from another model.
---

# Agent bridge

Claude Code and Codex hand work to each other on named threads. The scripts are in this skill's `scripts` folder and need PowerShell plus both CLIs logged in for headless use (`codex login`; `claude`, then `/login`). On Windows run them with `powershell -ExecutionPolicy Bypass -File`; on Linux with `pwsh -File`.

1. Write the brief to a UTF-8 file. The other agent sees only the brief and the files in `-Cd`.
2. Run the script for the *other* agent (allow 1–5 minutes; run it in the background if longer):

   - You are Claude Code, asking Codex:
     `powershell -ExecutionPolicy Bypass -File <this skill>\scripts\ask-codex.ps1 -Thread <name> -PromptFile <file> [-Cd <repo>] [-Sandbox read-only] [-Model <id>] [-Effort low|medium|high|xhigh]`
   - You are Codex, asking Claude Code:
     `powershell -ExecutionPolicy Bypass -File <this skill>\scripts\ask-claude.ps1 -Thread <name> -PromptFile <file> [-Cd <repo>] [-PermissionMode plan]`

3. Read the JSON: `reply`, `ok`, `errors`; from Codex also `images` (copies of what it generated; show them to the user).

- Same `-Thread` again continues the same session; new topic, new name.
- For images, ask Codex to "use your built-in image generation tool".
- State (thread ids, the transcript, image outbox) lives in `$env:AGENT_BRIDGE_HOME`, default `~\.agent-bridge`. `scripts\thread.ps1 -Thread <name>` prints a thread's transcript.
- A message starting with `[agent-bridge]` came from the other agent; your final reply goes back to it as is.
- The call needs network and write access to the bridge state and the other agent's home folder. If a sandbox blocks it, rerun with escalated permissions.
- The reply is a report: check the files and results before telling the user it is done.
