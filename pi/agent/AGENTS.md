# Global Coding Standards

These rules apply to every project unless a project-local AGENTS.md overrides them.

## Core Principles

### Code Quality

- Write clean, readable, self-documenting code
- Descriptive names that clearly convey intent; functions are verbs, variables are nouns
- Clarity over cleverness

### Comments Policy

- **Minimize comments** — code should explain itself
- Only comment: complex algorithms, public APIs, "why" decisions, edge-case warnings
- Never restate what the code does

### File Size Management

- Keep files under **300 lines** whenever possible; **400 is the hard max**
- Break large files into smaller, focused modules — single responsibility per file
- Proactively suggest refactoring when approaching these limits

### Project Boundaries

- Stay within project scope; never modify system files or unrelated projects
- Respect the project's existing architecture and patterns
- When external dependencies are needed, communicate this to the user

### Tech-Stack Fit

- Prefer popular, actively-maintained packages within the project's existing ecosystem
- Do not introduce foreign patterns or obscure dependencies without explicit justification

### Git Workflow

- **NEVER commit or push code automatically**
- Stage changes and present them for review only when asked
- The user maintains full control over version control — no exceptions

## Code Organization

- Group related functionality; clear module boundaries
- Functions small and focused (ideally under 50 lines)
- Extract complex logic into well-named helpers
- Avoid abbreviations unless universally understood

## Development Workflow

1. **Analyze** — understand the task and existing structure
2. **Plan** — think through the approach before coding
3. **Implement** — clean, focused code
4. **Review** — check file sizes, readability, maintainability
5. **Present** — show changes clearly for review
6. **Wait** — the user handles commits
