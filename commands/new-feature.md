---
description: Create an isolated git worktree and branch for a new feature
argument-hint: [feature name]
---

# /new-feature

Set up an isolated workspace for a new feature: a dedicated git worktree on a new branch,
with project setup already run.

Feature name given: $ARGUMENTS

## Steps

1. **Get the feature name.** If the line above is empty, ask the user what the feature is
   and wait for their answer. Do not invent one.

2. **Derive the branch slug yourself** from what the user said. Rules:
   - ASCII letters, digits, and single dashes only
   - lowercase everything **except** a ticket/issue ID, which keeps the user's exact casing
     and stays in the position they put it: `VIA-123 roles AND permissions` →
     `VIA-123-roles-and-permissions`
   - 2-4 words — the shortest phrase that still identifies the feature; drop filler words
     (`the`, `a`, `our`, `for`, `to`) unless removing them breaks the meaning
   - transliterate non-ASCII to ASCII (`ā`→`a`, `ļ`→`l`, `ü`→`u`, `š`→`s`)
   - if the user already gave a kebab-case name, pass it through unchanged — do not "improve" it
   - describe only what the user asked for; do not invent scope

   | User said                          | Pass                            |
   |------------------------------------|---------------------------------|
   | `VIA-123 roles AND permissions`    | `VIA-123-roles-and-permissions` |
   | `Add billing for our EU customers` | `eu-customer-billing`           |
   | `Kļūdu labošana maksājumos`        | `payment-bug-fixes`             |
   | `refresh-token-rotation`           | `refresh-token-rotation`        |

3. **Run the script** with that slug:

   ```bash
   ~/.claude/commands/scripts/new-feature.sh "<slug>"
   ```

   The script:
   - creates `../<project-name>--<slug>` as a new worktree on a new branch `<slug>`,
     resolved against the main repo (not the current worktree)
   - runs `composer setup` inside it if `composer.json` defines a `setup` script
   - aborts if the target directory already exists; an existing branch is rejected by git
     itself, so that error reads `fatal: a branch named '<slug>' already exists`
   - **validates** the slug (alphanumeric words joined by single dashes) and errors out
     instead of rewriting your input. The check is structural only — it does not police
     casing, so the lowercasing rules above are yours to enforce. If it rejects the slug,
     fix the slug and rerun; do not work around it.

4. **Report the result to the user.** The script's last lines are `BRANCH=`,
   `COMPOSER_SETUP=`, and `WORKTREE_PATH=`.

   On success, report the branch, the path, and what `composer setup` did, then give the
   `cd` as its own copyable code block:

   > Worktree ready on branch `eu-customer-billing` — `composer setup` ran.
   >
   > ```bash
   > cd /Users/you/code/my-app--eu-customer-billing
   > ```

   On failure, report the script's exact error message and nothing else — no `cd` line, and
   do not delete, reuse, or work around an existing branch or directory unless the user
   tells you to.
