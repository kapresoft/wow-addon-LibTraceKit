# LibTraceKit

LibTraceKit is a lightweight tracing library for WoW addon developers. Create a tagged tracer with `TraceKit('<Addon Name>')` and call it like a function to send labeled debug messages to Blizzard's Event Trace UI.

Rather than scattering `print()` calls through your addon or maintaining a separate debug log, LibTraceKit routes your trace output straight into `/etrace` — so your custom messages appear interleaved with real game events, in the correct time order, in one place. Tagging each tracer by addon or module name keeps output readable even when multiple addons are tracing at once.

Create the tracer once, then call it anywhere like a regular function — no manual event registration, no formatting boilerplate.

## Usage

`LibTraceKit:New(namespace, hexColor)` returns a `TraceKit` instance, which is fluent: its `With*` methods configure the tracer and return `self`, so calls can be chained directly off `New()`. Use `WithTag(tag)` to label a tracer by module or subsystem, and `WithDelimiter(delim)` (or the `WithUnderscoreDelimiter()` shortcut) to override how the namespace and tag are joined in the trace output (default `::`).

`New()` also returns a second, optional value: `fmt`, a formatter you can use to pretty-print tables and other complex values before passing them to the tracer.

```lua
--- @type LibTraceKit-1.0
local LibTraceKit = LibStub('LibTraceKit-1.0')

local t, fmt = LibTraceKit:New('libtracekit', '29FFEF')
-- OR
local t, fmt = LibTraceKit:New('libtracekit')
                  :WithTag('Main'):WithUnderscoreDelimiter()
-- OR
local t, fmt = LibTraceKit:New('libtracekit')
                  :WithTag('EventHandler')
                  :WithDelimiter('.')
```

```lua
local isLogIn, isReload = ...
t('Player logged in', 'isLogin=', isLogIn, 'isReload=', isReload)
```

![screenshot-1.png](dev/media/screenshot-1.png)

```lua
t('Player logged in', 'event payload=', fmt({...}))
```
![screenshot-2.png](dev/media/screenshot-2.png)

```lua
-- prints a table hash of spellInfo
t('Spell casted', 'spell=', spell, 'spellInfo=', spellInfo)

-- prints a formatted spellInfo (to-string)
t('Spell casted', 'spell=', spell, 'spellInfo=', fmt(spellInfo))
```

## License
All Rights Reserved.

