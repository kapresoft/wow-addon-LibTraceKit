# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LibTraceKit is a lightweight WoW addon library for tagged debug tracing. It gives addon developers `TraceKit('<Addon Name>')` -- a tracer you create once and then call like a function, e.g. `t('value of namespace=', namespace)` -- to send labeled debug messages straight into Blizzard's `/etrace` Event Trace UI, instead of scattering `print()` calls or maintaining a separate debug log.

LibTraceKit is a **library**, not a standalone addon: it ships with its own `.toc` for standalone testing/deployment in WoW, but is primarily meant to be consumed by other addons via git-sync (see `dev/setup.yml` in consumer addons, e.g. how DevSuite pulls `ThirdParty-Libs/LibPrettyPrint`).

## Build & Release

### Pull external library dependencies

```shell
w-sync-libs
# Output goes to .release/
```

### Deployment to local WoW installs

#### One-time deploy
```shell
w-deployer -c ./dev/deployer-config.lua
```

#### Continuous Deploy with 'quiet' -q and 'watch' -w mode

```shell
w-deployer -c ./dev/deployer-config.lua -qw
```

### Clean build
```shell
./dev/release-clean.sh
```

### Release process
1. Create pull requests
2. Create tag to publish -- an automated GitHub Action will push any tag created
3. Verify CurseForge build is green, then publish the GitHub draft release

There are no automated tests. Validation is done in-game.

## Architecture

Single-purpose library, not split into multiple modules. Source lives under `Libs/`. As the library grows, keep it flat unless a real second concern (e.g. formatting, filtering) emerges -- don't pre-build a module registry or namespace system before there's more than one file's worth of logic.

## Key conventions

- **Optional dependency, not required** -- consuming addons declare LibTraceKit under `OptionalDeps` in their `.toc`, not `RequiredDeps`. LibTraceKit itself should have zero hard dependency on any other addon.
- **No unit test framework** -- test in-game. Use `/etrace` to confirm traced messages appear correctly.
- **EmmyLua annotations** -- use EmmyLua (`---@param`, `---@return`, `---@class`) for IDE type checking on the public API surface.

## Code style

Formatting is enforced by `stylua.toml`: 100-column width, 2-space indent, Unix line endings, prefer single quotes, keep parens on function calls, collapse simple statements onto one line. Match this on touched lines; don't reformat whole files as a side effect of an unrelated change.
