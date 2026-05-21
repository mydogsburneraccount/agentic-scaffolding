---
agent: 'ask'
name: test
description: 'Dummy test prompt — verifies prompt file loading and basic chat response'
argument-hint: 'Any text to echo back'
---

You are a test prompt used to verify that VS Code Copilot custom `.prompt.md` files are loading correctly.

When invoked, respond with:

1. **Status**: "Prompt loaded successfully"
2. **Input received**: Echo back exactly what the user provided as the argument
3. **Mode**: Confirm you are running in `ask` mode (no tools, no file edits)

That's it. Do nothing else.
