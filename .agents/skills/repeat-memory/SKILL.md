---
name: repeat-memory
description: >-
  Before repeating a script or action already done in this project, read
  .repeat-memory/memory.jsonl and follow the latest success for that same
  work. Use on a repeat even when the person does not name this skill.
  After the work, record what worked and what failed. Do not rewrite another
  skill until the person agrees.
---

# Repeat memory

A repeat is a script or an action this project has already done. The first time has no memory. The next time is not started from nothing.

A session-start hook points at this skill when a chat opens. Do not wait for the person to name the skill.

## Before the work

Read `.repeat-memory/memory.jsonl` when it exists. Each line is one record:

```json
{"work":"play-store","summary":"what happened","outcome":"worked","at":"2026-11-10T22:00:00Z"}
```

`outcome` is `worked` or `failed`.

Use a record only inside the same kind of work: the skill being followed, or that script. The same words are not required. The agent judges the likeness. Among similar records, follow the latest one that worked. A failed record only says not to do it that way. Do not follow a path that broke a stop rule.

If the skill being followed already stores its own next step, follow that store for the step. Still write the outcome here.

Do not invent a path when every similar record failed.

## After the work

Append one line. `summary` is the step that worked, or the problem. Do not store a gesture's coordinates. Do not store a secret: a password, a card number, a code, a token, or a proxy credential.

This file stays on the machine. Do not commit it.

## Changing a skill

A skill change is a fix for a step the skill missed or got wrong, or a successful scenario the skill does not yet contain. It is not a copy of the whole time the work just ran. A path that broke a stop rule is not a skill change.

Memory does not change the skill. Propose the skill change and wait. The skill changes only after the person agrees.
