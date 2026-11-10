#!/bin/bash
# Claude Code SessionStart hook. Plain text on stdout is added to the session.
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
memory="$root/.repeat-memory/memory.jsonl"
skill="$root/.agents/skills/repeat-memory/SKILL.md"

if [[ ! -f "$skill" ]]; then
  exit 0
fi

printf '%s' "Follow the repeat-memory skill at .agents/skills/repeat-memory/SKILL.md before repeating a script or action already done in this project. Do not wait for the user to name the skill."

if [[ -s "$memory" ]]; then
  printf '%s' " Read .repeat-memory/memory.jsonl first and follow the latest success for that same work."
fi

printf '\n'
