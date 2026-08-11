# LibTraceKit

LibTraceKit is a lightweight tracing library for WoW addon developers. Create a tagged tracer with `TraceKit('<Addon Name>')` and call it like a function to send labeled debug messages to Blizzard's Event Trace UI.

Rather than scattering `print()` calls through your addon or maintaining a separate debug log, LibTraceKit routes your trace output straight into `/etrace` — so your custom messages appear interleaved with real game events, in the correct time order, in one place. Tagging each tracer by addon or module name keeps output readable even when multiple addons are tracing at once.

## Usage

```lua
local t = TraceKit('<Addon Name>')
t('value of namespace=', namespace)
```

Create the tracer once, then call it anywhere like a regular function — no manual event registration, no formatting boilerplate.

## License
All Rights Reserved.

