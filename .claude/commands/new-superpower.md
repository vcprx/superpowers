# Creating Claude Code Skills, Commands, and Agents

You are helping add a new artifact to the superpowers repo at `/Users/vlad/code/superpowers`.

Three artifact types exist. Pick the right one for the task, then follow the checklist.

---

## Choosing the Right Artifact Type

| You want to… | Use |
|---|---|
| Auto-trigger on context (PHP files, Anthropic imports, etc.) | **Skill** |
| Give Claude domain knowledge / guidelines for a task | **Skill** |
| Add a user-invocable `/command` that runs a workflow | **Command** |
| Project-local command (scoped to one repo only) | **Project-local command** in `.claude/commands/` |
| Define a specialized sub-agent persona or capability | **Agent** |

---

## Skills

### Core design principles

**Progressive Disclosure** — Skills use a three-level loading system:
1. **YAML frontmatter** — always loaded in the system prompt; lets Claude decide when to invoke the skill without loading everything
2. **SKILL.md body** — loaded when the skill is deemed relevant; contains full instructions
3. **Linked files** (`references/`, `assets/`, sub-skill `.md` files) — discovered and loaded only as needed

This minimises token usage while keeping specialised expertise available.

**Composability** — Claude can load multiple skills simultaneously. A skill should work alongside others, not assume it is the only active capability.

**Portability** — Skills work identically across Claude.ai, Claude Code, and API. Write once, works everywhere (assuming any runtime dependencies are met).

### Directory layout

```
skills/
  my-skill/
    SKILL.md              ← required: frontmatter + routing/body
    sub-skill-a.md        ← optional sub-skills (no frontmatter)
    sub-skill-b.md
    scripts/              ← executable code invoked by the skill
      do-something.ts
      helper.sh
    references/           ← documentation loaded by Claude as needed
      api-reference.md
      spec.md
    assets/               ← templates, fonts, icons used in output
      template.html
      logo.png
```

**`scripts/`** — Executable code (TypeScript, Bash, etc.) the skill runs during a task. Reference these from SKILL.md instructions, e.g. `run scripts/generate.ts`.

**`references/`** — Supporting documentation Claude can navigate on demand (API specs, style guides, cheat-sheets). Keep files focused so Claude loads only what is relevant.

**`assets/`** — Static files used to produce output: templates, fonts, icons, example files. Reference by relative path from SKILL.md.

### SKILL.md frontmatter

```yaml
---
name: my-skill
description: >
  One-line summary of what this skill does.
  TRIGGER when: <concrete signals — file types, imports, user phrases, task patterns>.
  DO NOT TRIGGER when: <anti-patterns to prevent false positives>.
user-invocable: true   # false = Claude invokes only, user cannot /invoke it
context: fork          # optional — isolates skill in a forked context
disable-model-invocation: false
---
```

### Writing a good description (critical)

The `description` field is the **only** signal Claude reads to decide whether to invoke the skill.
It is shown verbatim in the system prompt — make trigger conditions explicit and specific.

Bad (too vague):
```
Use when working on a Laravel project.
```

Good (concrete):
```
TRIGGER when: user writes PHP classes, controllers, models, or asks about Laravel
  architecture. Files artisan, app/, routes/, composer.json with laravel/framework present.
DO NOT TRIGGER when: non-PHP project, pure JS/CSS work.
```

### Parent skill vs sub-skills

Use a parent `SKILL.md` as a router when you have multiple related concerns:
- Parent body lists sub-skills and when to invoke each
- Sub-skill `.md` files (no frontmatter) contain the actual guidelines/instructions
- Parent invokes the right sub-skill based on the task

---

## Commands

### Global command (available in all projects)

```
commands/my-command.md
```

Run `./scripts/install.sh` to symlink into `~/.claude/commands/`.

### Project-local command (scoped to one repo)

```
<repo>/.claude/commands/my-command.md
```

No install step — Claude Code picks it up automatically. Use this for commands that only
make sense in a specific project context (like this one).

No frontmatter needed. Write the file as a direct instruction to Claude:

```markdown
# My Command

Do X, then Y, then Z.
```

Invoked with `/my-command` or `/my-command some args`.

---

## Agents

An agent is a single `.md` file defining a specialized persona or sub-agent role.

```
agents/my-agent.md
```

Write it as a role definition + capability spec + behavior rules. Claude Code spawns it
via the Agent tool when appropriate. Run `./scripts/install.sh` after adding.

---

## Checklist — Adding to the Superpowers Repo

After creating the files:

**Skill:**
- [ ] `skills/my-skill/SKILL.md` created
- [ ] `./scripts/install.sh` run
- [ ] `"Skill(my-skill:*)"` added to `config/settings.json` `permissions.allow`
- [ ] Row added to `README.md` Skills table

**Global command:**
- [ ] `commands/my-command.md` created
- [ ] `./scripts/install.sh` run
- [ ] Row added to `README.md`

**Project-local command:**
- [ ] `<repo>/.claude/commands/my-command.md` created (no install step)

**Agent:**
- [ ] `agents/my-agent.md` created
- [ ] `./scripts/install.sh` run
- [ ] Row added to `README.md`
