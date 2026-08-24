---
name: documentation
description: Retrieve and use current programming documentation through Context7. Use when implementing or explaining APIs, libraries, SDKs, frameworks, or package-specific functionality.
---

# Documentation Research

Use Context7 whenever the answer depends on current or library-specific documentation.

## When to use

Use this skill for:

- Framework APIs
- SDKs
- Libraries
- Package configuration
- API authentication
- Version-specific behavior
- Installation instructions
- Migration guides
- Deprecated APIs
- Configuration options

## Primary rule

Do not rely solely on model memory when current documentation is available.

Prefer:

Context7 → official documentation → source repository → other reliable sources.

## Workflow

1. Identify the library or framework.
2. Determine the relevant version if possible.
3. Search Context7 for the library.
4. Retrieve the relevant documentation.
5. Locate the exact API/configuration needed.
6. Verify important details against the current documentation.
7. Implement using the documented API.

## Version awareness

Always pay attention to:

- Package version
- Framework version
- API version
- Deprecated APIs
- Breaking changes

If the user specifies a version, prioritize documentation for that version.

If documentation appears to describe a different version, explicitly mention the discrepancy.

## Coding

Before writing code involving an unfamiliar library:

1. Look up the API.
2. Confirm the function/class/component exists.
3. Confirm its arguments.
4. Confirm return values.
5. Check current examples.
6. Check relevant migration/deprecation notes.

Do not fabricate APIs.

## Troubleshooting

When debugging a library:

1. Search the current documentation.
2. Search known errors.
3. Check version compatibility.
4. Check official GitHub issues when appropriate.
5. Explain the likely cause.
6. Give the smallest reliable fix.
