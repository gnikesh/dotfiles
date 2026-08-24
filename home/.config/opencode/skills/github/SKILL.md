---
name: github
description: Follow disciplined GitHub workflows for repositories, issues, branches, commits, pull requests, and code review.
---

# GitHub Workflow

Use Git and GitHub carefully.

## Before modifying a repository

Inspect:

- Current branch
- Working tree status
- Recent commits
- Repository structure
- Relevant project instructions

Never assume the working tree is clean.

## Changes

Keep changes:

- Focused
- Minimal
- Related to the requested task

Avoid modifying unrelated files.

## Commits

Before committing:

1. Review the diff.
2. Check for accidental changes.
3. Run relevant tests.
4. Run formatting/linting when appropriate.

Write commit messages that explain the change.

## Pull requests

A good PR should explain:

- What changed
- Why it changed
- Important implementation details
- Testing performed
- Known limitations

## Issues

When investigating an issue:

1. Reproduce it if possible.
2. Search existing issues.
3. Inspect relevant commits.
4. Check current documentation.
5. Determine whether the issue is already fixed.

## Safety

Never:

- Force-push without explicit authorization.
- Delete branches without authorization.
- Rewrite shared history without authorization.
- Expose tokens or credentials.
- Commit secrets.

Before destructive Git operations, ask for confirmation.

## External research

When repository behavior depends on an external library:

Use Context7 for current documentation.

When investigating current GitHub issues or releases:

Use GitHub tools when available and Brave Search when necessary.
