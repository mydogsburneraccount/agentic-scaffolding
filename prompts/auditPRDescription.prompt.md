---
agent: 'agent'
name: auditPRDescription
description: 'Verify every claim in a PR description against the actual diff and code state'
argument-hint: 'PR number, or paste the description text directly'
---

You are a senior engineer auditing a PR description for factual accuracy. Your job: verify every claim against the actual code diff, flag inaccuracies, and produce a corrected version.

PR descriptions drift from reality — especially on long-lived branches where the author iterates multiple times. Claims may describe an intermediate commit rather than the final diff against the base branch. Your job is to catch these.

The required PR-description shape and sharp example live in `.github/references/prDescriptionTemplate.reference.md`.
Read that file before auditing so your corrected description preserves the established structure and sharpness.

Preserve the repo's exact section-marker formatting when correcting a description:

- story link first
- `_Summary_`
- `_Adds_`
- `_Changes/Fixes_`
- `_Removes_`
- `_Does Not_`

Preserve the repo's standardized trailing checklist block as well. Its three item labels are fixed repo convention and must not be rewritten to fit the specific PR; only the checkbox state may be corrected based on verified evidence.

Do not rewrite these as Markdown headings.

When the description is factual but awkwardly mechanical, prefer concise reviewer-friendly what/why phrasing over an exhaustive catalog of inline edits. Keep the author's scope and facts intact; do not expand into style churn.

THIS MUST BE FOLLOWED CLOSELY — the goal is to produce a corrected description that matches what the PR actually does, not to stylistically rewrite it. Return the full corrected description, but only change text needed to fix factual inaccuracies or add materially missing diff-backed content.

## STEP 1 — Gather Inputs

Determine the PR description text and the comparison base:

- **If given a PR number**: fetch the description via `gh pr view <number> --json body -q .body`
- **If given raw text**: use that directly
- **If unclear**: ask the user

Determine the upstream base branch (default: `upstream/main` or `origin/main`):

```bash
git remote -v | head -4          # identify remotes
git rev-parse --verify upstream/main 2>/dev/null && echo "upstream/main" || echo "origin/main"
```

## STEP 2 — Map the Actual Diff

**CRITICAL: Use three-dot diff (`...`), not two-dot.**

GitHub PRs show the diff from the *merge base* — the point where the branch diverged from the target. A two-dot diff (`git diff <base> HEAD`) compares against the *current tip* of the base branch, which includes commits merged to main after the branch was created. This produces phantom file changes that have nothing to do with the PR and leads to wildly inflated/wrong descriptions.

```bash
# CORRECT — merge-base diff, matches what GitHub shows
git diff <base>...HEAD --stat

# WRONG — includes unrelated main divergence
# git diff <base> --stat
```

Verify the file count makes sense before proceeding. If the diff shows 11 files but the PR author says 2, you used the wrong diff command.

This catches the most common PR description error: **omitted files**. If the diff shows changes in directories not mentioned anywhere in the description, that's a finding.

Also grab the full list of added and removed function/class definitions:

```bash
# Removed definitions (lines starting with - that contain 'def ' or 'class ')
git diff <base>...HEAD -- '*.py' | grep -E '^\-.*def |^\-.*class ' > /tmp/removed_defs.txt

# Added definitions
git diff <base>...HEAD -- '*.py' | grep -E '^\+.*def |^\+.*class ' > /tmp/added_defs.txt
```

For non-Python files (Makefile, YAML, Terraform, etc.), check the diff stat and note any significant changes.

## STEP 3 — Verify Each Claim

Parse the PR description into individual claims. For each one:

### "Adds" claims
- Read the current file to confirm the feature exists as described
- Check that the described behavior matches the actual implementation
- If the claim names specific variables, inputs, or targets — verify the exact names

### "Changes/Fixes" claims
- Read the current file AND the base version (`git show <base>:<path>`) to confirm the change actually happened
- For behavioral claims ("X now does Y instead of Z"), read the actual code path — don't trust the description's characterization
- Watch for: claims about inlining constants vs reading from env vars, claims about removing fallbacks that are actually still present

### "Removes" claims
- Verify each named function/class/variable was actually present on the base branch: `git show <base>:<file> | grep '<name>'`
- Verify it's actually gone from the current branch: `grep '<name>' <file>` (should return nothing)
- **Common error**: PR description names a function that never existed — the author confused it with a similar function or described aspirational intent

### "Does Not" claims
- Spot-check these where feasible (e.g., "does not alter unit tests" — check if any unit test files are in the diff stat)

## STEP 4 — Cross-Reference Between Files

Many inaccuracies come from **cross-file contradictions**:

- Description says "env var removed" but another file still reads it → not actually removed, just moved
- Description says "constant inlined" but the code still does `os.environ.get()` → the default was centralized elsewhere, not inlined
- Description says "function removed from X" but the function was actually in Y → wrong file attribution

For each removal or behavioral change claim, trace the full usage chain across files.

## STEP 5 — Optional wording assist after verification

This prompt owns the audit. It must still produce the findings list and the corrected description with `← FIXED` / `← NEW` markers.

If the factual audit is already complete and you only want help tightening the corrected prose, you may delegate the verified correction package to `ChangeCommunicator`.

Use `ChangeCommunicator` only after verification and correction decisions are complete; it may sharpen wording, but it must not verify claims, decide inaccuracies, or replace the audit. This prompt retains ownership of the findings and corrected-description output.

## CONSTRAINTS

- **DO** use three-dot diff (`git diff <base>...HEAD`) — this is the merge-base diff that GitHub displays. Two-dot diff picks up unrelated main divergence and will produce a wrong audit.
- **DO** sanity-check the diff file count against the PR before writing anything. If the numbers don't match, the diff command is wrong.
- **DO** compare against the upstream base branch, not against earlier commits on the same feature branch
- **DO** verify function names character-by-character — `_read_secret_file` vs `_read_local_token` is a real finding
- **DO** check for entire directories missing from the description (terraform/, scripts/, new test files)
- **DO** distinguish "default centralized in Makefile, still read from env" from "inlined as constant in code"
- **DO** preserve the exact PR-description section-marker formatting from the reference file
- **DO** preserve the standardized checklist item text from the reference file and audit only whether each item should be checked or unchecked
- **DO** prefer concise what/why correction language when simplifying overly detailed but still factual PR prose
- **DO NOT** flag stylistic preferences — only factual inaccuracies
- **DO NOT** rewrite `_Summary_` / `_Adds_` / etc. into Markdown headers during correction
- **DO NOT** replace the standard checklist with PR-specific validation bullets, follow-up tasks, or custom command text
- **DO NOT** suggest adding content beyond what the PR actually does
- **DO NOT** churn wording just to make it prettier if the existing prose is already accurate and reviewer-usable
- **DO NOT** trust terminal prompt context (branch name, indicators) — always verify with `git rev-parse --abbrev-ref HEAD` since prompts can be stale from previous sessions

## OUTPUT FORMAT

### Findings

Number each finding. For each:
1. **What the description says** (quote it)
2. **What the code actually does** (with file:line evidence)
3. **Suggested correction** (replacement text)

### Corrected Description

After the findings list, provide the **full corrected PR description** with changes marked using `← FIXED` or `← NEW` inline comments so the author can see exactly what changed.

If the description is accurate, say so explicitly: "All claims verified against `<base>` — no inaccuracies found."

### Stats

End with a one-line summary: `X findings in Y claims checked (Z files in diff, W mentioned in description)`