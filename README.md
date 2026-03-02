# superpowers

Personal skills, commands, and agents for [Claude Code](https://claude.ai/code) and [OpenCode](https://opencode.ai).

## Installation

**Option A — Claude Code plugin (Claude Code only):**
```
/plugin install /path/to/superpowers
```

**Option B — Dotfiles symlinks (Claude Code + OpenCode):**
```bash
git clone https://github.com/vcprx/superpowers
cd superpowers
./scripts/install.sh
```

> **Important:** `install.sh` symlinks `config/settings.json` to `~/.claude/settings.json`. This will **overwrite** your existing global Claude Code settings. Back up `~/.claude/settings.json` before running if you have custom settings you want to keep.

Re-run `install.sh` after adding new skills, commands, or agents.

## What's included

### Skills

| Skill | Description |
|-------|-------------|
| `laravel-api-development/writing-laravel-api-documentation` | Write and update l5-swagger OpenAPI annotations for Laravel APIs |

## Adding your own

**Skill:**
```
skills/my-skill/SKILL.md
```
```yaml
---
name: my-skill
description: Use when [condition] — [what it does]
user-invocable: true
disable-model-invocation: false
---
```

**Command** (slash command in Claude Code):
```
commands/my-command.md
```

**Agent:**
```
agents/my-agent.md
```

Then run `./scripts/install.sh` and restart Claude Code / OpenCode.
