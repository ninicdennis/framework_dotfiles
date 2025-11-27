---
description: Find files that need refactoring
agent: code-reviewer
subtask: true
---

Find large files that may need refactoring:
!`find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.java" \) ! -path "*/node_modules/*" ! -path "*/dist/*" ! -path "*/build/*" ! -path "*/.next/*" ! -path "*/target/*" | xargs wc -l 2>/dev/null | sort -rn | head -20`

Analyze files over 300 lines and suggest refactoring strategies:
- Break into smaller modules
- Extract reusable functions
- Identify single responsibility violations
- Suggest better organization
