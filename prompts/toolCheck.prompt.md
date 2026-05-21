---
agent: 'agent'
name: toolCheck
description: 'Verify baseline agent tools and configured MCP servers are accessible by exercising each one'
argument-hint: 'No arguments needed — just run it'
---

You are a diagnostic agent. Your job: run lightweight checks against baseline local tools and the currently configured MCP servers, then report what responded. No analysis, no recommendations — just exercise and report.

## Procedure

### 1. Read the current MCP inventory

Read `personal/prompts/references/mcp-setup.reference.md` first.

Use it as the source of truth for the MCP servers you should try to verify.

### 2. Baseline local-tool checks

Run these local checks first. For each one, make the call, then log the result in the summary table.

#### 2.1 File Read
Read the first 5 lines of `pyproject.toml` in the workspace root.

#### 2.2 Directory Listing
List the contents of the `personal/prompts/` directory.

#### 2.3 Text Search
Search the workspace for the string `"FastAPI"` — just report how many matches.

#### 2.4 Terminal
Run `echo "terminal works"` in the terminal.

### 3. MCP checks

For each MCP server listed in `personal/prompts/references/mcp-setup.reference.md`, make one minimal, safe verification call when the tool is directly available in the active environment.

Suggested lightweight probes:

- `context7` → look up the `fastapi` library
- `your corporate MCP` → run a small personal/status-style request
- `github` → fetch the most recent open PR on this repository
- `project-api` → list available API endpoints or confirm the server responded
- `postgres-local` → run `SELECT 1 AS health_check;`
- `CodeGraphContext` → query one simple symbol relationship
- `memory` → verify it responds to a lightweight read/list request
- `sequential-thinking` → send one thought such as `This is a connectivity test.`
- `actor-critic-thinking` → send one minimal request if the tool is exposed

If a server is listed in the reference but no direct tool is exposed in the active environment, mark it as unavailable in `Notes` instead of guessing or inventing a call.

Do not retry failures. Record the first result and move on.

## Output

After all checks, produce this summary and nothing else:

```
## Tool Check Results

| # | Tool / Server       | Status | Notes |
|---|---------------------|--------|-------|
| 1 | File Read           | ✓ / ✗  |       |
| 2 | Directory Listing   | ✓ / ✗  |       |
| 3 | Text Search         | ✓ / ✗  |       |
| 4 | Terminal            | ✓ / ✗  |       |
| 5 | <MCP server>        | ✓ / ✗  |       |
| 6 | <MCP server>        | ✓ / ✗  |       |
| … | …                   | …      | …     |

X/Y passed
```

If a tool fails, put the error message in `Notes`. Do NOT retry — just record the failure and move on.

## Anti-Patterns

- hardcoding a stale MCP inventory when the shared MCP setup reference already exists
- treating one failing MCP check as proof that the entire MCP stack is down
- retrying failed checks instead of recording the first result
- inventing calls for servers that are not directly exposed in the active environment
