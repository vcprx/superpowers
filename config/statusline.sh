#!/bin/bash

# Read JSON input once
input=$(cat)

# Extract current directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Extract context percentage
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

repo_name=$(basename "$cwd")

if [ "$ctx_pct" -ge 60 ]; then
  ctx_color='\033[01;31m' # red
elif [ "$ctx_pct" -ge 40 ]; then
  ctx_color='\033[01;33m' # yellow
else
  ctx_color='\033[01;32m' # green
fi

printf '\033[01;36m%s\033[00m | ctx: %b%s%%\033[00m' \
  "$repo_name" "$ctx_color" "$ctx_pct"
