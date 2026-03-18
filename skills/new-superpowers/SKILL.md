---
name: new-superpowers
description: Create, scaffold, or improve skills, commands, and agents in the superpowers repo (~/.claude/skills, commands, agents). Use whenever the user wants to add a new skill, slash command, or agent — even if they just say "turn this into a skill", "make a command for this", or "add this to my superpowers". Also use when refining or iterating on an existing skill.
user-invocable: true
disable-model-invocation: false
---

# New Superpower

Help the user create or improve a skill, command, or agent in the superpowers repo at `/Users/vlad/code/superpowers`.

## Repo structure

```
skills/        # Skill dirs, each with a SKILL.md
commands/      # Slash command .md files
agents/        # Agent .md files
config/
  settings.json  # permissions.allow list
scripts/
  install.sh     # symlinks everything into ~/.claude/
README.md
```

## What are you making?

Start by clarifying the type:

- **Skill** — loaded into Claude's context when triggered by a user request; can contain sub-files (references, scripts, assets). Best for multi-step workflows, domain expertise, or anything that benefits from persistent instructions.
- **Command** — a slash command (`/command-name`) the user invokes explicitly. Best for one-off tasks or workflows the user wants manual control over.
- **Agent** — a specialized subagent with its own instructions, spawned by other skills or commands.

If it's not clear which fits, ask. The user might say "make a skill for X" but actually want a command, or vice versa.

---

## Creating a skill

### 1. Capture intent

If the user didn't fully describe it, ask:

1. What should this skill enable Claude to do?
2. When should it trigger? (what phrases or contexts should activate it)
3. Any specific output format or constraints?
4. Are there existing files, docs, or examples to reference?

If the current conversation already shows a workflow (tools used, steps taken, corrections made), extract the intent from that — the user may just need to fill gaps and confirm.

### 2. Interview & research

Before writing, gather:

- Edge cases and what the skill should NOT do
- Input/output formats
- Dependencies (MCPs, tools, external docs)
- Success criteria

Use WebFetch or WebSearch if useful for researching the domain. Come prepared so you reduce back-and-forth.

### 3. Write the SKILL.md

File path: `skills/<skill-name>/SKILL.md`

Frontmatter fields:

```yaml
---
name: skill-name
description: >
  Use when [specific trigger conditions]. [What it does].
  Trigger this skill whenever [expanded trigger list].
user-invocable: true         # false = Claude-only (e.g. subagent skills)
disable-model-invocation: false
---
```

**Description is the primary triggering mechanism.** Claude tends to undertrigger skills, so make the description a bit "pushy" — enumerate the conditions clearly, include synonyms. Example: instead of "Helps with data visualization", write "Use when the user asks about charts, graphs, dashboards, data visualization, or wants to display any kind of data — even if they don't say 'dashboard' explicitly."

#### Skill anatomy

```
skills/my-skill/
├── SKILL.md           # required — frontmatter + instructions
└── (optional)
    ├── references/    # docs loaded into context on demand
    ├── scripts/       # executable scripts for repetitive/deterministic work
    └── assets/        # templates, fixtures, static files
```

Use sub-files to keep SKILL.md under ~500 lines. Reference them explicitly in the body with guidance on when to read them.

#### Writing principles

- **Imperative form**: "Read the file first. Then generate the report."
- **Explain the why**: Don't just say ALWAYS/NEVER — explain the reasoning so the model can adapt to edge cases. Heavy-handed MUSTs are a yellow flag; reframe as rationale where possible.
- **General, not narrow**: Write for a million different prompts, not just the test cases in front of you. Avoid overfitting to specific examples.
- **Lean**: Remove instructions that aren't pulling their weight. If you find yourself repeating the same constraint everywhere, consolidate it once.
- **Progressive disclosure**: Put the most important context in SKILL.md, details in sub-files. Claude reads sub-files only when needed.

#### Output format pattern

```markdown
## Output format
Always use this structure:
# [Title]
## Summary
## Key findings
## Next steps
```

#### Example pattern

```markdown
## Examples
**Input:** Added JWT token validation to the auth middleware
**Output:** feat(auth): enforce JWT validation on protected routes
```

---

## Creating a command

File path: `commands/<command-name>.md`

Commands are markdown files with a prompt template. They're invoked explicitly with `/command-name`. Keep them focused — they run once per invocation.

```markdown
# Command name

Brief description of what this command does.

## Instructions

[The prompt/instructions Claude will follow when this command is invoked]
```

---

## Creating an agent

File path: `agents/<agent-name>.md`

Agents are spawned by skills or commands as subagents. They should have a focused, single-purpose role.

```markdown
---
name: agent-name
description: What this agent does and when to spawn it
---

# Agent name

[Role and instructions]
```

---

## Testing the skill

For a new skill, come up with 2-3 realistic test prompts — things a real user would actually say. Share them: "Here are test cases I'd like to try. Look right to you?"

Run each prompt yourself (inline, using the skill's instructions) and review the output. Focus on:

- Does the skill produce the right output format?
- Does it handle the core case well?
- Are there obvious gaps or confusing instructions?

Revise the skill based on what you observe. Repeat until it's solid. You don't need extensive automated evals for personal skills — qualitative review and a few iterations is usually enough.

If the skill is complex or has objective success criteria (e.g., "always outputs valid JSON"), add a quick sanity check script in `scripts/` that you can run to verify.

---

## Improving an existing skill

When the user asks to refine or fix a skill:

1. Read the current SKILL.md
2. Understand what's failing or what they want changed
3. Generalize the fix — don't patch just the reported case, think about the broader pattern
4. Look for over-constrained instructions that could be expressed as rationale instead
5. If the skill has sub-files, check if they're being referenced correctly

---

## Description optimization

After writing or revising a skill, review the description with fresh eyes:

- Does it cover the main trigger phrases?
- Does it include near-miss cases (where the user might phrase things differently)?
- Is it specific enough to not trigger on unrelated requests?
- Does it mention the skill name or key domain words explicitly?

Try to think of 5-10 prompts a user might type that should trigger this skill — and 5 that look similar but shouldn't. If the description wouldn't clearly distinguish them, revise it.

---

## Completion checklist

After creating or modifying anything, run through this:

- [ ] File created at correct path (`skills/<name>/SKILL.md`, `commands/<name>.md`, or `agents/<name>.md`)
- [ ] `./scripts/install.sh` run (symlinks into `~/.claude/`)
- [ ] `config/settings.json` — add `"Skill(<name>:*)"` to `permissions.allow` (for skills)
- [ ] `README.md` — add a row to the relevant table

Run install:
```bash
cd /Users/vlad/code/superpowers && ./scripts/install.sh
```

After install, restart Claude Code for the skill to be picked up.
