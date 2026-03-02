#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_SKILLS="$HOME/.claude/skills"
CLAUDE_COMMANDS="$HOME/.claude/commands"
CLAUDE_AGENTS="$HOME/.claude/agents"

mkdir -p "$CLAUDE_SKILLS" "$CLAUDE_COMMANDS" "$CLAUDE_AGENTS"

# Link individual skill directories into ~/.claude/skills/
# Works for both Claude Code and OpenCode (reads ~/.claude/skills/ natively)
for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  ln -sfn "$dir" "$CLAUDE_SKILLS/$skill_name"
  echo "Linked skill: $skill_name"
done

# Link individual command files
for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  cmd_name="$(basename "$file")"
  ln -sfn "$file" "$CLAUDE_COMMANDS/$cmd_name"
  echo "Linked command: $cmd_name"
done

# Link individual agent files
for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  agent_name="$(basename "$file")"
  ln -sfn "$file" "$CLAUDE_AGENTS/$agent_name"
  echo "Linked agent: $agent_name"
done

echo ""
echo "Done. Restart Claude Code / OpenCode to pick up changes."
