# GitLab MR Review

Review a GitLab Merge Request and post inline comments via the GitLab API.

## Step 1 — Resolve the MR

Fetch your user ID, then make two requests and merge the results:

```bash
glab api "/user"  # store .id as $me_id

glab api "/merge_requests?state=opened&scope=assigned_to_me"
glab api "/merge_requests?state=opened&reviewer_id=$me_id&scope=all"
```

Deduplicate by MR `id`, then display a numbered list:
```
  1. !42  Add payment retry logic       (main ← feature/payment-retry)  @alice
  2. !38  Fix null reference in UserService  (main ← fix/null-user)     @bob
```
Ask the user to pick a number. Resolve to `iid` and `project_id` from the JSON.

From the resolved MR object, store:
- `iid`, `project_id`, `title`, `source_branch`, `target_branch`, `web_url`
- `diff_refs.base_sha`, `diff_refs.head_sha`, `diff_refs.start_sha`

---

## Step 2 — Fetch the diff

```bash
glab api "/projects/$project_id/merge_requests/$iid/changes"
```

Returns a `changes` array. Each entry has:
- `old_path`, `new_path` — file paths before/after
- `new_file`, `deleted_file` — booleans
- `diff` — unified diff string for this file

---

## Step 3 — Detect stack and load skills

Inspect all `new_path` values in `changes`:

| File extensions present | Action |
|------------------------|--------|
| `.php` | Load the `laravel-development` skill via the Skill tool |
| `.ts`, `.tsx`, `.vue` | No skill available yet; review as-is using general best practices |
| Both PHP and TS/Vue | Load `laravel-development` for the PHP portions |

Load any applicable skill before proceeding.

---

## Step 4 — Review all diffs before posting any comment

Read **all** files' diffs before writing a single comment. Understand:
- The intent of the MR (`title`, branch names)
- Cross-file dependencies (a method added in one file, called in another)
- Which files are new, deleted, or renamed

---

## Step 5 — Review each file and collect comments

### Line number tracking

For each file's `diff` string, initialise:
```
old_line = 0
new_line = 0
```

Process line by line:
1. **Hunk header** `@@ -A,B +C,D @@` → set `old_line = A - 1`, `new_line = C - 1`
2. **Context line** (starts with ` `) → increment both `old_line` and `new_line`; position key: `new_line`
3. **Added line** (starts with `+`) → increment `new_line` only; position key: `new_line`
4. **Removed line** (starts with `-`) → increment `old_line` only; position key: `old_line`

Record for each comment: `old_path`, `new_path`, the line number, and whether it's `new_line` or `old_line`.

### What to flag

Apply standards from any loaded skill. In general, flag:
- Logic errors or unhandled edge cases
- Violations of conventions from loaded skills
- Missing or incorrect error handling
- Security issues (injection risks, unvalidated input, exposed secrets)
- Performance problems (N+1 queries, unnecessary loops, missing indexes)
- Unclear naming inconsistent with the surrounding codebase
- Missing tests for non-trivial logic changes

Do **not** flag:
- Pure style preferences not backed by a loaded skill
- Correct code that could merely be written differently
- Lines outside the diff (unchanged context lines)

Write comments in direct, specific language. Reference the exact variable, method, or logic. Suggest a fix where possible.

---

## Step 6 — Post inline comments

For each collected comment, post via the GitLab discussions API.

> **Important:** Do NOT use `glab api -f "position[key]=value"` for this — `glab` silently drops
> nested bracket-key fields, so the comment lands as a plain MR note with no line anchor.
> Instead, pipe a JSON body via `--input -`.

**For an added or context line** (use `new_line`):
```bash
echo '{
  "body": "<comment text>",
  "position": {
    "position_type": "text",
    "base_sha": "<base_sha>",
    "head_sha": "<head_sha>",
    "start_sha": "<start_sha>",
    "old_path": "<old_path>",
    "new_path": "<new_path>",
    "new_line": <new_line>
  }
}' | glab api --method POST --input - "/projects/$project_id/merge_requests/$iid/discussions"
```

**For a removed line** (use `old_line`):
```bash
echo '{
  "body": "<comment text>",
  "position": {
    "position_type": "text",
    "base_sha": "<base_sha>",
    "head_sha": "<head_sha>",
    "start_sha": "<start_sha>",
    "old_path": "<old_path>",
    "new_path": "<new_path>",
    "old_line": <old_line>
  }
}' | glab api --method POST --input - "/projects/$project_id/merge_requests/$iid/discussions"
```

If a POST fails, print the error and the comment text (do not silently drop it), then continue.

---

## Step 7 — Done

Output:
```
Review posted for !<iid>: <title>
<web_url>

<N> comment(s) posted.
```
