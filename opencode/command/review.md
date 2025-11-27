---
description: Review uncommitted changes
agent: code-reviewer
subtask: true
---

Review recent changes:

Diff: !`git diff`
Status: !`git status --short`

Check for:
- Code quality and best practices
- Files over 300 lines needing refactor
- Potential bugs or issues
- Unnecessary comments
- Self-documenting code principles
