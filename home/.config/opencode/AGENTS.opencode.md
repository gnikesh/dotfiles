
# OpenCode delegation (primary agents only)

This section applies only to OpenCode primary agents (`build`, `plan`). If you were launched as a subagent, ignore it and do your assigned task yourself.

As a primary agent you are an orchestrator. Delegate every substantive unit of work to the matching subagent, then integrate, verify, and report the results. Do work yourself only when it is trivial (a one-line fix, a single command, answering from context you already have) or when it is integration glue between subagent results.

## Roster

| Need | Subagent |
| --- | --- |
| Find code, files, or how something works in the repo | `explore` (state thoroughness: quick, medium, very thorough) |
| External docs, library APIs, versions, known issues | `researcher` |
| Design a non-trivial change and split it into tasks | `architect` |
| Implement a scoped task (non-Apple code) | `implementer` |
| Swift, SwiftUI, UIKit, App Intents, Xcode work | `apple-platform` |
| Any bug, crash, or unexplained failure | `debugger` |
| Write or run tests, fix flaky tests | `tester` |
| Review changes before they are considered done | `code-reviewer` |
| Auth, user data, network-facing code, new dependencies | `security-auditor` |
| Slowness, memory, bundle size, query performance | `perf-profiler` |
| Verify UI end-to-end in browser or simulator | `ui-verifier` |
| READMEs, guides, API docs | `docs-writer` |
| Understand an image | `vision` |
| Anything else multi-step | `general` |

`plan` may only launch the read-only subagents (`explore`, `researcher`, `architect`, `code-reviewer`, `security-auditor`, `vision`).

## Default workflow for build

1. Context - `explore` (and `researcher` if external knowledge is needed). Run them in parallel when independent.
2. Design - `architect` for anything beyond a small, obvious change.
3. Implement - `implementer` or `apple-platform` per task. Bugs go to `debugger` instead.
4. Test - `tester` for coverage of the new behavior.
5. Review - `code-reviewer`, plus `security-auditor` for sensitive areas. Send findings back to the implementing subagent and repeat until the review is clean.
6. Verify - `ui-verifier` for any user-facing change. Run the final lint, typecheck, and test commands yourself and confirm they pass.
7. Docs - `docs-writer` when behavior or usage changed.

Git operations (commits, branches, PRs) stay with the primary agent and follow the global rules above.

## Writing briefs

Subagents start with a fresh context and cannot ask you questions. Every brief must include:
- The goal and the success criteria.
- Exact files or areas they own, and what they must not touch.
- Relevant findings from earlier subagents (paths, interfaces, decisions) so they do not repeat discovery.
- The verification commands to run.
- The report you expect back.

## Parallelism

- Run independent subagents in parallel (background mode), but only when their files do not overlap. Never let two editing subagents touch the same file.
- Run at most 3 subagents at once. Before launching more than 3 in one wave, explain the tradeoff (cost, context, merge risk) and ask the user.
- Do not re-do a subagent's work. If a result looks wrong, verify it yourself with a quick check, then send a corrective brief.
