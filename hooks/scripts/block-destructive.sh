#!/usr/bin/env bash
# block-destructive.sh — PreToolUse hook that blocks dangerous terminal commands
#
# HOW IT WORKS:
#   VS Code calls this script before the agent runs any tool.
#   The script receives JSON on stdin describing what the agent wants to do.
#   If the command matches a dangerous pattern, the script returns a "deny"
#   decision and the agent is blocked from running it.
#
# WHAT IT BLOCKS:
#   - rm -rf /              — recursive delete from root
#   - git push --force/-f   — force-push (rewrites shared history)
#   - git reset --hard      — discards uncommitted work
#   - DROP TABLE/DATABASE   — destructive SQL
#   - dd ... of=/dev/       — raw disk overwrite
#   - mkfs.                 — disk formatting
#
# INSTALL:
#   Copy hooks/block-destructive.json to .github/hooks/ in your project.
#   Make sure this script is executable: chmod +x hooks/scripts/block-destructive.sh
#
# CUSTOMIZE:
#   Add patterns to the DANGEROUS_PATTERNS array below.
#   Each entry is: "regex|Human-readable reason"
#
# DOCS: https://code.visualstudio.com/docs/copilot/customization/hooks

set -euo pipefail

# ── Read input from VS Code ──────────────────────────────────────────────
# VS Code sends JSON on stdin with tool_name, tool_input, etc.
INPUT=$(cat)

# Extract the tool name (e.g., "run_in_terminal", "editFiles")
TOOL_NAME=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_name', ''))
" 2>/dev/null || echo "")

# Only check terminal/command tools — let file edits, searches, etc. pass through
case "$TOOL_NAME" in
  run_in_terminal|send_to_terminal|execute_command|terminal|bash|shell)
    ;;
  *)
    # Not a terminal tool — allow without checking
    exit 0
    ;;
esac

# Extract the command string the agent wants to run
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
ti = data.get('tool_input', {})
# Different tools use different field names for the command
print(ti.get('command', '') or ti.get('input', ''))
" 2>/dev/null || echo "")

# If we couldn't extract a command, allow (don't block on parse errors)
if [ -z "$COMMAND" ]; then
  exit 0
fi

# ── Dangerous patterns ───────────────────────────────────────────────────
# Format: "grep_pattern|reason"
# Patterns are checked with grep -E (extended regex)
DANGEROUS_PATTERNS=(
  'rm\s+(-[a-zA-Z]*f[a-zA-Z]*\s+)?/\s*$|rm\s+-rf\s+/|rm -rf /|Recursive delete from root'
  'git\s+push\s+.*--force|git\s+push\s+-f|Force-push rewrites shared history'
  'git\s+reset\s+--hard|Discards uncommitted work'
  'DROP\s+(TABLE|DATABASE)|Destructive SQL'
  'dd\s+.*of=/dev/|Raw disk overwrite'
  'mkfs\.|Disk formatting'
  '>\s*/dev/sd[a-z]|Raw device write'
)

# ── Check each pattern ───────────────────────────────────────────────────
for entry in "${DANGEROUS_PATTERNS[@]}"; do
  # Split on last | to get pattern and reason
  PATTERN="${entry%|*}"
  REASON="${entry##*|}"

  if echo "$COMMAND" | grep -qEi "$PATTERN"; then
    # Dangerous command detected — tell VS Code to block it
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Blocked by safety hook: ${REASON}. Command: ${COMMAND}"
  }
}
EOF
    exit 0
  fi
done

# ── No dangerous patterns matched — allow the command ─────────────────────
exit 0
