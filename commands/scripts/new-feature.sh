#!/usr/bin/env bash
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

slug="${1:-}"
[ -n "$slug" ] || die "no slug given — usage: new-feature.sh <kebab-case-slug>"

# The caller must pass an already-kebab-cased slug; this script validates, never rewrites.
# Case is the caller's business, so a ticket ID keeps its capitalization anywhere in the slug.
[[ $slug =~ ^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$ ]] \
  || die "'$slug' is not kebab-case — expected words joined by single dashes, e.g. eu-customer-billing"

# Resolve against the main repo rather than the current worktree, so chaining features does
# not produce app--old--new paths. The main repo root is the parent of the common git dir.
common_dir="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" \
  || die "not inside a git repository"
main_root="$(dirname "$common_dir")"
worktree_path="${main_root}--${slug}"

# Load-bearing: git creates the branch before failing on an existing path, so without this
# check a collision leaves a stray branch behind. An existing branch it rejects cleanly.
[ ! -e "$worktree_path" ] || die "'$worktree_path' already exists"

git worktree add "$worktree_path" -b "$slug"
cd "$worktree_path"

if [ ! -f composer.json ]; then
  composer_setup="no composer.json"
elif composer run-script --list 2>/dev/null | grep -qE '^[[:space:]]*setup([[:space:]]|$)'; then
  composer setup
  composer_setup="ran"
else
  composer_setup="no setup script in composer.json"
fi

echo ""
echo "BRANCH=$slug"
echo "COMPOSER_SETUP=$composer_setup"
echo "WORKTREE_PATH=$worktree_path"
