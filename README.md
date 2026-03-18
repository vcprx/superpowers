# superpowers

Personal skills, commands, and agents for [Claude Code](https://claude.ai/code) and [OpenCode](https://opencode.ai).

## Installation

**Option A — Claude Code plugin (Claude Code only):**
```
/plugin install https://github.com/vcprx/superpowers
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
| `new-superpowers` | Create, scaffold, or improve skills, commands, and agents in this repo |
| `laravel-development` | Route Laravel project tasks to the appropriate sub-skill (e.g. scaffolding a modular architecture) |
| `laravel-development` → `references/developing-modular-laravel` | Scaffold modules, register service providers, wire namespaces, set up factories |
| `laravel-development` → `references/laravel-guidelines` | PHP and Laravel coding guidelines (Spatie style) — naming, types, control flow, exceptions |
| `laravel-api-development` | Route Laravel API tasks to the appropriate sub-skill (e.g. writing API documentation) |
| `laravel-api-development` → `references/writing-laravel-api-documentation` | Write and update l5-swagger OpenAPI annotations for Laravel APIs |

### Commands

| Command | Description |
|---------|-------------|
| `/new-superpower` | Scaffold a new skill, command, or agent in this repo (project-local) |
| `/review-mr [iid]` | Review a GitLab MR; prompts for selection if no IID given — posts inline draft notes |

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
