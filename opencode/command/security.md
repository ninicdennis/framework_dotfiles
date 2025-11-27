---
description: Run security audit on dependencies
agent: security-auditor
subtask: true
---

Check for security vulnerabilities:
!`npm audit 2>&1 || yarn audit 2>&1 || pnpm audit 2>&1 || pip-audit 2>&1 || bundle audit 2>&1 || cargo audit 2>&1`

Identify critical issues and suggest safe update paths. Prioritize by severity.
