# Repeat memory

Instructions for any AI agent. On a repeated script or action, read what worked last time in this project and follow it. The person does not type the skill name.

The instructions are `.agents/skills/repeat-memory/SKILL.md`.

Raw file: https://raw.githubusercontent.com/PrivetQA/repeat-memory-skill/main/.agents/skills/repeat-memory/SKILL.md

Repository: https://github.com/PrivetQA/repeat-memory-skill

## What to do with this link

1. Read the raw skill file above.
2. From the project where the work repeats, run:

```bash
git clone https://github.com/PrivetQA/repeat-memory-skill.git /tmp/repeat-memory-skill
bash /tmp/repeat-memory-skill/install.sh .
```

3. Follow `.agents/skills/repeat-memory/SKILL.md` in that project.
4. Open a new chat. The session hook reminds the agent to read the skill.

`npx skills add PrivetQA/repeat-memory-skill` installs the instructions only. The session hook still needs `install.sh`.

## Where agents find the skill

- `.agents/skills/repeat-memory/SKILL.md` is the shared copy
- `.cursor/skills/repeat-memory` and `.claude/skills/repeat-memory` point at that same directory
- Agents that read `AGENTS.md` follow that file

## Hooks

Memory is `.repeat-memory/memory.jsonl` in the project. Do not commit it. `install.sh` adds that path to `.gitignore`.

| Agent | Hook | What starts it |
| --- | --- | --- |
| Cursor | `.cursor/hooks.json` `sessionStart` | `.cursor/hooks/repeat-memory.sh` |
| Claude Code | `.claude/settings.json` `SessionStart` | `.claude/hooks/repeat-memory.sh` |

The hook does not choose the step and does not change a skill. It tells the agent to read the skill, and to read the memory file when that file already has records.

In Cursor, open the new chat from the editor agent panel. The separate Agents window can miss the first session-start reminder.
