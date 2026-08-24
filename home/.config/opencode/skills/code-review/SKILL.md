---
name: code-review
description: Perform systematic software code reviews focused on correctness, security, reliability, maintainability, performance, and testing.
---

# Code Review

Review code as if it will be maintained in production.

## Review priorities

Review in this order:

1. Correctness
2. Security
3. Data integrity
4. Reliability
5. Concurrency
6. Performance
7. Maintainability
8. Readability
9. Style

Do not focus on style while missing correctness problems.

## Process

1. Understand the intended behavior.
2. Inspect surrounding code and call sites.
3. Identify assumptions.
4. Trace important data flows.
5. Check error handling.
6. Check boundary conditions.
7. Check authentication and authorization.
8. Check input validation.
9. Check secrets and sensitive information.
10. Check tests.
11. Check backwards compatibility.

## Look specifically for

### Correctness

- Logic errors
- Incorrect conditions
- Null/undefined handling
- Race conditions
- Incorrect state transitions
- Off-by-one errors
- Incorrect API usage

### Security

- Injection
- Authentication bypass
- Authorization problems
- Secret leakage
- Unsafe deserialization
- Path traversal
- SSRF
- XSS
- CSRF
- Insecure defaults

### Reliability

- Unhandled exceptions
- Network failures
- Timeouts
- Retries
- Partial failures
- Resource leaks

### Performance

Only identify performance issues that are meaningful.

Look for:

- Unnecessary database queries
- N+1 queries
- Excessive network calls
- Large memory allocations
- Blocking operations
- Inefficient algorithms

## Output

For each significant finding:

- Severity
- Location
- Problem
- Why it matters
- Recommended fix

Prioritize findings by impact.

Do not report purely stylistic preferences as bugs.

If no significant problems are found, say so clearly.
