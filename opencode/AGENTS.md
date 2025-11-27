# Project Context and Coding Standards

You are an AI coding assistant working with a developer who values clean, maintainable code. Follow these guidelines strictly.

## Core Principles

### Code Quality

- Write clean, readable, self-documenting code
- Use descriptive variable and function names that clearly convey intent
- Structure code logically so anyone can understand it without extensive comments
- Prioritize clarity over cleverness

### Comments Policy

- **Minimize comments** - write code that explains itself
- Only add comments when:
  - Explaining complex algorithms or non-obvious business logic
  - Documenting public APIs or library interfaces
  - Clarifying "why" decisions were made (not "what" the code does)
  - Warning about edge cases or gotchas
- Never add redundant comments that just restate what the code does

### File Size Management

- Keep files under **300 lines of code** whenever possible
- Maximum **400 lines** - beyond this, refactoring is mandatory
- Break large files into smaller, focused modules
- Each file should have a single, clear responsibility
- Suggest refactoring when approaching these limits

### Project Boundaries

- **Stay within the project scope**
- Only modify files that are part of the current project
- Do not make changes to system files, global configurations, or unrelated projects
- When dependencies or external resources are needed, clearly communicate this to the user
- Respect the project's existing architecture and patterns

### Git Workflow

- **NEVER commit code automatically**
- Always stage changes and present them for review
- Let the user decide when and what to commit
- Provide clear summaries of changes made
- The user maintains full control over version control
- Present diffs clearly so the user can review before committing

## Code Organization

### Structure

- Group related functionality together
- Use clear module boundaries
- Keep functions small and focused (ideally under 50 lines)
- Extract complex logic into well-named helper functions

### Naming Conventions

- Use meaningful, searchable names
- Avoid abbreviations unless universally understood
- Be consistent within the codebase
- Function names should be verbs, variables should be nouns

### Refactoring

- Proactively suggest refactoring when:
  - Files approach 300+ lines
  - Functions become too complex
  - Code is duplicated
  - Responsibilities are unclear
- Always explain the benefits of proposed refactorings

## Development Workflow

1. **Analyze** - Understand the task and existing code structure
2. **Plan** - Think through the approach before coding
3. **Implement** - Write clean, focused code
4. **Review** - Check file sizes, readability, and maintainability
5. **Present** - Show changes clearly for user review
6. **Wait** - Let the user handle commits and version control

## Remember

- Code is read far more often than it's written
- Future developers (including the current user) will thank you for clarity
- When in doubt, favor simplicity and readability
- The user is in charge of all git operations - no exceptions
- Stay focused on the project at hand - no scope creep
