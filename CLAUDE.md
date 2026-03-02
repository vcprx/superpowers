# superpowers

Personal skills, commands, and agents for Claude Code and OpenCode.
GitHub: https://github.com/vcprx/superpowers

## Purpose

This repo is a dotfiles-style plugin repository. Its contents are symlinked into
`~/.claude/` so both Claude Code and OpenCode pick them up automatically.

## Structure

```
skills/        # Skill dirs, each with a SKILL.md — symlinked into ~/.claude/skills/
commands/      # Slash command .md files      — symlinked into ~/.claude/commands/
agents/        # Agent definition .md files   — symlinked into ~/.claude/agents/
scripts/       # install.sh does the symlinking
.claude-plugin/plugin.json  # Claude Code plugin manifest for /plugin install
```

## Installation

**Option A — Claude Code plugin:**
```
/plugin install /Users/vlad/code/superpowers
```

**Option B — Dotfiles symlinks (Claude Code + OpenCode):**
```bash
./scripts/install.sh
```

`install.sh` symlinks each skill dir, command file, and agent file individually
into the corresponding `~/.claude/` subdirectory. Re-run after adding new items.

## Adding a Skill

```
skills/
  my-skill/
    SKILL.md
```

`SKILL.md` frontmatter:
```yaml
---
name: my-skill
description: Use when [condition] — [what it does]
user-invocable: true        # false = Claude-only
disable-model-invocation: false
---
```

Then run `./scripts/install.sh` and restart Claude Code / OpenCode.

Also add the skill to the `permissions.allow` list in `config/settings.json`:

```json
"Skill(my-skill:*)"
```

## Notes

- OpenCode reads `~/.claude/skills/` natively — no separate OpenCode config needed.
- Skills are directories; commands and agents are individual `.md` files.
- `scripts/install.sh` uses `ln -sfn` so re-running it is safe.
