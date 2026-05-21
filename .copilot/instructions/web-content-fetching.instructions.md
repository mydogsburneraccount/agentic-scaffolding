---
description: "Use when fetching, reading, or extracting content from web pages, URLs, documentation sites, or any external web resource. Governs tool selection for all web content retrieval."
---

# Web Content Fetching

## Preferred Tool: trafilatura via `fetch_url.sh`

When you need to read, extract, or reference content from a web URL, use the trafilatura-based script in a terminal **instead of** the built-in `fetch_webpage` tool.

### Why

The built-in `fetch_webpage` tool filters page content through a model summary before returning it. This:
- **Mangles formatting** — code blocks, tables, headings, and lists lose structure.
- **Drops or paraphrases content** — the summary is lossy; exact wording, parameter names, and API signatures may be altered.
- **Omits metadata** — page title, date, author, and URL context are discarded.
- **Is unsuitable for documentation** — when you need precise API docs, config references, or technical content, summarized output is unacceptable.

trafilatura extracts the **real main content** of a web page with faithful formatting, links, code blocks, and metadata preserved.

### How to Use

Run in a terminal:

```bash
~/.copilot/scripts/fetch_url.sh "<URL>"
```

This returns clean markdown with metadata header, formatting, links, and code blocks intact.

#### Options

| Flag | Effect |
|---|---|
| *(default)* | Markdown output with formatting + links + metadata |
| `--raw` | Plain text (no markdown markup) |
| `--json` | JSON output with structured metadata fields |
| `--no-links` | Omit hyperlink targets from output |
| `--no-formatting` | Omit bold/italic/heading markup |

#### For large pages

Pipe through `head -n <N>` to control output size:

```bash
~/.copilot/scripts/fetch_url.sh "<URL>" | head -200
```

### Network Notes

The script handles your organization corporate network constraints automatically:
- Tries a direct connection first.
- Falls back to the corporate proxy (`your-corporate-proxy:8080`) if direct access times out.
- Override the proxy with `CORP_PROXY` env var if needed.

## When `fetch_webpage` Is Acceptable

Use `fetch_webpage` **only** when ALL of these are true:
- You have confirmed `fetch_url.sh` is unavailable or broken in this environment.
- You need a quick existence check or high-level summary of a page (not precise content).
- Formatting, code blocks, and exact wording do not matter.
- The result will not be used to inform implementation details, API usage, or configuration.

If in doubt, default to trafilatura.

## When Other Tools Are Better

- **Library/framework documentation** (React, FastAPI, Pydantic, etc.): Prefer `context7` MCP tools first (if available) — they provide versioned, structured docs. Fall back to trafilatura if context7 lacks the specific page or is not configured.
- **your organization your wiki wiki**: Use the `wiki-issue-mcp` wiki tools — they authenticate and parse your wiki content natively.
- **GitHub content**: Use GitHub MCP tools or `git` commands for repo-hosted content.

## Anti-Patterns — Do NOT

- Use `fetch_webpage` to read API documentation, library references, or any content where accuracy matters.
- Use `fetch_webpage` and then try to "reconstruct" mangled code blocks or signatures from the summary.
- Fetch a URL with `fetch_webpage` and present the summarized output as if it were the actual page content.
- Repeatedly call `fetch_webpage` with different `query` parameters trying to get the full content — the tool fundamentally summarizes, it cannot return verbatim content regardless of query.

## Tool Unavailable Fallback

If `fetch_url.sh` is not found or `trafilatura` is not installed:
1. Use `curl -sL <URL>` piped to the terminal and extract content manually from the raw HTML.
2. As a last resort, `fetch_webpage` may be used — but explicitly note in your response that the content was summarized and may not be verbatim.
