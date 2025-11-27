---
description: Run tests and analyze failures
agent: test-writer
subtask: true
---

Run the test suite: !`npm test 2>&1 || yarn test 2>&1 || pytest 2>&1 || go test ./... 2>&1 || cargo test 2>&1`

Focus on any failing tests and suggest fixes. If tests pass, confirm success.
