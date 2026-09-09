# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- For one-off or infrequent operational work, start with the simplest direct end-to-end path. Do not build wrappers, control planes, policy layers, custom verifiers, or automation unless the direct path exposes a concrete blocker or repeated need that justifies the added machinery.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.
- When you need to inspect or understand any image (screenshots, PNGs, design mockups, character art, etc.), ALWAYS delegate to the `vision` subagent - never read the image file directly. The subagent's description is returned with the image, so you do not need to open it yourself.

# Project Memory

- At the start of each session, read MEMORY.md if it exists in the current project scope — it holds accumulated project context.
- Never treat memory as authoritative if the current source code contradicts it.

Before starting a non-trivial task:
- Search project memory for relevant previous decisions, bugs, and implementation patterns.
- Prefer existing project decisions over inventing new approaches.

After completing a non-trivial task:
- Save important architectural decisions.
- Save non-obvious bugs and their fixes.
- Save project-specific conventions discovered during implementation.
- Do not save trivial facts or temporary debugging information.

