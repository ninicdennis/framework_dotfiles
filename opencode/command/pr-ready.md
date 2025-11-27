---
description: Review changes before creating PR
agent: code-reviewer
subtask: true
---

Prepare for pull request:

Commits: !`git log --oneline origin/main..HEAD 2>&1 || git log --oneline main..HEAD 2>&1 || git log --oneline -5`
Files changed: !`git diff --stat origin/main..HEAD 2>&1 || git diff --stat main..HEAD 2>&1`
Full diff: !`git diff origin/main..HEAD 2>&1 || git diff main..HEAD 2>&1`

Verify:
- No files over 400 lines (warn at 300+ lines)
- No debug code or excessive comments
- Clean commit messages
- Code is production-ready
- All changes are necessary and within project scope
