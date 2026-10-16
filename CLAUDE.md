# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LibTraceKit is a lightweight WoW library for tagged debug tracing. `LibStub('LibTraceKit-1.0'):New('<Addon Name>')` returns a tracer (and a formatter) that you call like a function, e.g. `t('value of namespace=', namespace)`, to send labeled messages to Blizzard's `/etrace` Event Trace UI instead of scattering `print()` calls.

**Work in progress:** the API is still changing, and `README.md` may describe planned usage (e.g. a global `TraceKit('<Addon Name>')`) that the code doesn't implement yet. Treat the code as the current truth; don't "fix" the README or the code to match each other unless asked.

It's a **library**, not a standalone addon. It ships its own `.toc` for standalone testing and deployment, but consumers usually embed it: they git-sync it into their `ThirdParty/Libs` through their `dev/setup.yml`, as ActionbarPlus does with `ThirdParty-Libs/LibTraceKit`.

## Build & Release

See "Build & Release (WoW addons)" in `~/.claude/Claude-Wow-Addon-Dev.md`.

## Architecture

Single-purpose library in one file, `LibTraceKit.lua` (registered with LibStub as `LibTraceKit-1.0`). `Libs/` holds only the dev-only `Developer.lua` (TOC-wrapped in `#@debug@`) and assets. Embedded deps (LibStub, LibPrettyPrint) load from `ThirdParty/ThirdParty.xml`.

Keep it flat unless a real second concern (e.g. formatting, filtering) emerges; don't pre-build a module registry or namespace system before there's more than one file's worth of logic.

## Key conventions

- **No hard dependency on another addon:** everything LibTraceKit needs is embedded. A consumer relying on a standalone install should list it under `OptionalDeps`, not `RequiredDeps`.
- **Testing in game:** use `/etrace` to confirm traced messages appear correctly.

## Code style

Formatting is enforced by `stylua.toml`: 100-column width, 2-space indent, Unix line endings, prefer single quotes, keep parens on function calls, collapse simple statements onto one line. Match this on touched lines; don't reformat whole files as a side effect of an unrelated change.
