#!/bin/bash
# Install repeat-memory into a project: skill, Cursor hook, Claude Code hook.
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)"
target="$(cd "${1:-.}" && pwd)"

mkdir -p \
  "$target/.agents/skills/repeat-memory" \
  "$target/.cursor/skills" \
  "$target/.cursor/hooks" \
  "$target/.claude/skills" \
  "$target/.claude/hooks"

cp "$src/.agents/skills/repeat-memory/SKILL.md" "$target/.agents/skills/repeat-memory/SKILL.md"
cp "$src/hooks/cursor.sh" "$target/.cursor/hooks/repeat-memory.sh"
cp "$src/hooks/claude.sh" "$target/.claude/hooks/repeat-memory.sh"
chmod +x "$target/.cursor/hooks/repeat-memory.sh" "$target/.claude/hooks/repeat-memory.sh"

ln -sfn ../../.agents/skills/repeat-memory "$target/.cursor/skills/repeat-memory"
ln -sfn ../../.agents/skills/repeat-memory "$target/.claude/skills/repeat-memory"

python3 - "$target" << 'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])

hooks_path = root / ".cursor" / "hooks.json"
hooks = {}
if hooks_path.exists() and hooks_path.read_text().strip():
    hooks = json.loads(hooks_path.read_text())
hooks["version"] = 1
session = hooks.setdefault("hooks", {}).setdefault("sessionStart", [])
command = ".cursor/hooks/repeat-memory.sh"
if not any(isinstance(item, dict) and item.get("command") == command for item in session):
    session.append({"command": command})
hooks_path.write_text(json.dumps(hooks, indent=2) + "\n")

settings_path = root / ".claude" / "settings.json"
settings = {}
if settings_path.exists() and settings_path.read_text().strip():
    settings = json.loads(settings_path.read_text())
starts = settings.setdefault("hooks", {}).setdefault("SessionStart", [])
claude_command = 'bash "$CLAUDE_PROJECT_DIR/.claude/hooks/repeat-memory.sh"'
present = set()
for entry in starts:
    if isinstance(entry, dict):
        present.add(entry.get("matcher"))
for matcher in ("startup", "resume", "compact"):
    if matcher in present:
        continue
    starts.append(
        {
            "matcher": matcher,
            "hooks": [{"type": "command", "command": claude_command}],
        }
    )
settings_path.write_text(json.dumps(settings, indent=2) + "\n")

ignore_path = root / ".gitignore"
ignore = ignore_path.read_text() if ignore_path.exists() else ""
if ".repeat-memory/" not in ignore:
    if ignore and not ignore.endswith("\n"):
        ignore += "\n"
    ignore_path.write_text(ignore + ".repeat-memory/\n")
PY

echo "Installed repeat-memory into $target"
