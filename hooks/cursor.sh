#!/bin/bash
# Cursor sessionStart hook. Prints JSON on stdout.
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
memory="$root/.repeat-memory/memory.jsonl"
skill="$root/.agents/skills/repeat-memory/SKILL.md"

if [[ ! -f "$skill" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

note="Follow the repeat-memory skill at .agents/skills/repeat-memory/SKILL.md before repeating a script or action already done in this project. Do not wait for the user to name the skill."

if [[ -s "$memory" ]]; then
  note="$note Read .repeat-memory/memory.jsonl first and follow the latest success for that same work."
fi

printf '%s\n' "{\"additional_context\":\"$note\"}"
