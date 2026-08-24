---
name: debugging
description: Systematically diagnose and fix software bugs using evidence, reproduction, logging, testing, and minimal changes.
---

# Debugging

Debug systematically rather than guessing.

## Core rule

Do not immediately change code.

First establish:

1. What is happening?
2. What should happen?
3. Where does behavior diverge?
4. What evidence supports the hypothesis?

## Workflow

### 1. Reproduce

Attempt to reproduce the problem.

Record:

- Input
- Expected behavior
- Actual behavior
- Error messages
- Environment
- Version information

### 2. Localize

Trace the execution path.

Use:

- Logs
- Stack traces
- Tests
- Grep
- Code search
- Debuggers
- Git history when useful

Determine the smallest area where the behavior becomes incorrect.

### 3. Form hypotheses

Generate a small number of plausible causes.

Rank them by evidence.

Do not make arbitrary changes to test random theories.

### 4. Verify

Use the smallest experiment that distinguishes between hypotheses.

Examples:

- Add temporary logging
- Run a focused test
- Inspect state
- Check API responses
- Check configuration
- Reproduce with minimal input

### 5. Fix

Make the smallest correct change.

Avoid unrelated refactoring.

### 6. Test

Run:

1. The reproducing test
2. Relevant unit tests
3. Integration tests when applicable
4. Lint/type checks when relevant

### 7. Explain

Tell the user:

- Root cause
- Why it happened
- What changed
- How it was verified

## External dependencies

If the problem involves a library, framework, or API:

Use Context7 to verify current documentation.

Check version compatibility.

If necessary, use Brave Search to investigate current issues or release notes.

## Avoid

- Guessing
- Random edits
- Large rewrites
- Hiding errors
- Disabling validation just to make a problem disappear
