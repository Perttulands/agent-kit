#!/usr/bin/env bash
# Setup script for a Claude Code cloud environment: paste it into the environment's settings.
# Runs as root before Claude starts and must exit 0. The result is snapshotted for up to ~7 days;
# edit this script (or the environment) to force a fresh clone. Logs to /tmp/cloud-setup.log.
exec > >(tee -a /tmp/cloud-setup.log) 2>&1
echo "cloud-setup $(date -Is) user=$(id -un) home=$HOME"
if git clone -q --depth 1 https://github.com/Perttulands/agent-kit.git "$HOME/agent-kit"; then
  bash "$HOME/agent-kit/install.sh" || echo "install.sh exited $?"
else
  echo "FAILED clone: agent-kit"
fi
exit 0
