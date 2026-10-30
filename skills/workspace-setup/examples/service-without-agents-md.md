# A server built by milestones, without AGENTS.md (Rust, GitHub tracker)

Agents build it milestone by milestone, often in cloud sessions started from a brief.

**Setup**
- Tracker: GitHub issues under numbered milestones; one PR per issue.
- Conventions live in `PITCH.md`, `README.md` and `docs/`, not in an `AGENTS.md`. The working rules (what the server must never disturb, no polling timers, the CI gates) were repeated in every agent brief.

**What held up**
- Benches checked in (`bench/*.sh`) with numbers recorded on the PR: performance claims are reproducible.

**What didn't**
- Without `AGENTS.md`, each brief had to restate the rules, and a session started without a brief didn't have them. Those rules belong in `AGENTS.md`; the briefs then shrink to the task.
