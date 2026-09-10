#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_SKILLS="$HOME/.claude/skills"
CLAUDE_COMMANDS="$HOME/.claude/commands"
CLAUDE_AGENTS="$HOME/.claude/agents"
OPENCODE_COMMANDS="$HOME/.config/opencode/commands"
OPENCODE_AGENTS="$HOME/.config/opencode/agents"

mkdir -p \
  "$CLAUDE_SKILLS" "$CLAUDE_COMMANDS" "$CLAUDE_AGENTS" \
  "$OPENCODE_COMMANDS" "$OPENCODE_AGENTS"

# Link global Claude Code config files
ln -sfn "$REPO_DIR/config/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
echo "Linked CLAUDE.md"
ln -sfn "$REPO_DIR/config/settings.json" "$HOME/.claude/settings.json"
echo "Linked settings.json"
ln -sfn "$REPO_DIR/config/statusline.sh" "$HOME/.claude/statusline.sh"
chmod +x "$REPO_DIR/config/statusline.sh"
echo "Linked statusline.sh"

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
  ln -sfn "$file" "$OPENCODE_COMMANDS/$cmd_name"
  echo "Linked command: $cmd_name (Claude + OpenCode)"
done

# Link helper scripts used by commands (skipped by the *.md glob above)
if [ -d "$REPO_DIR/commands/scripts" ]; then
  chmod +x "$REPO_DIR/commands/scripts"/*.sh
  ln -sfn "$REPO_DIR/commands/scripts" "$CLAUDE_COMMANDS/scripts"
  echo "Linked command scripts -> $CLAUDE_COMMANDS/scripts"
fi

# Link individual agent files
for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  agent_name="$(basename "$file")"
  ln -sfn "$file" "$CLAUDE_AGENTS/$agent_name"
  ln -sfn "$file" "$OPENCODE_AGENTS/$agent_name"
  echo "Linked agent: $agent_name (Claude + OpenCode)"
done


echo ""
echo "Done. Restart Claude Code / OpenCode to pick up changes."
