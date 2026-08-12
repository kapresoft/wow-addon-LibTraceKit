---@alias LibTraceKit_HexColor-1.0 string @hex color value, i.e. '0056AA', 'EEFFEE'

--- [LibPrettyPrint](https://github.com/kapresoft/wow-addon-LibPrettyPrint/blob/main/README.md)
---@alias LibTraceKit_Formatter-1.0 fun(...)

--[[-----------------------------------------------------------------------------
Library: LibTraceKit
-------------------------------------------------------------------------------]]
local MAJOR, MINOR = 'LibTraceKit-1.0', 1

---@class LibTraceKit-1.0
local LibTraceKit = LibStub:NewLibrary(MAJOR, MINOR); if not LibTraceKit then return end

--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]

local strupper = strupper or string.upper
local strtrim = strtrim or string.trim

local COLOR_FORMAT_RGB = COLOR_FORMAT_RGB or 'RRGGBB'
local DEFAULT_DELIM = '::'
local DEFAULT_COLOR = '42AFFA'

--[[-----------------------------------------------------------------------------
Support Functions
-------------------------------------------------------------------------------]]

---@private
---@return number @decimal color val
local function ColorValueFromHex(str, index)
  return tonumber(str:sub(index, index + 1), 16) / 255
end

---@private
---@param hexColorRGB HexRGB | '565656' | 'efefef'
---@return colorRGB?
local function ColorFromHexRGB(hexColorRGB)
  if #hexColorRGB == #COLOR_FORMAT_RGB then
    local r, g, b = ColorValueFromHex(hexColorRGB, 1),
      ColorValueFromHex(hexColorRGB, 3), ColorValueFromHex(hexColorRGB, 5)
    return CreateColor(r, g, b, 1)
  end
  return nil
end

---@param colorRGB colorRGB | string @A Color object, or the hex RRGGBB color | '565656' | 'fc565656'
---@return cfFn
local function cfn(colorRGB)
  ---@type colorRGB?
  local c = type(colorRGB) == 'string' and ColorFromHexRGB(colorRGB) or colorRGB
  assertsafe(
    c and type(c.WrapTextInColorCode) == 'function',
    'Invalid Color <%s>. ColorFormatter:ColorFn(colorRGB): <colorRGB> should be a Color object or a hex string in RRGGBB format, i.e. \'0055ee\'',
    tostring(colorRGB)
  )
  return function (arg) return c:WrapTextInColorCode(tostring(arg)) end
end

--[[-----------------------------------------------------------------------------
LibTraceKit
-------------------------------------------------------------------------------]]
--- @class TraceKit-1.0
--- @field namespace string
--- @field tag string @An optional tag name
--- @field pc Color @The primary color function
--- @field delim string @Delimiter override; defaults to '::', i.e. 'NAMESPACE::TAG'
local TraceKit = {}
TraceKit.__index = TraceKit
TraceKit.__type = 'TraceKit'

---@private
---@param self TraceKit-1.0
TraceKit.__call = function (self, ...) self:LogEvent(...) end

--- tag is optional:  #__Init(namespace, hexColor) or #__Init(namespace, tag, hexColor)
--- @private
--- @param namespace string                                The namespace or identifier of the trace message
--- @param hexColor  LibTraceKit_HexColor-1.0 | colorRGB)? @A hex color value if tag is provided, i.e. '0056AA', 'EEFFEE'; otherwise can be ommitted.
function TraceKit:__Init(namespace, hexColor)
  assertsafe(
    type(namespace) == 'string' and #strtrim(namespace) > 0,
    'Invalid namespace: <%s>. TraceKit:__Init(namespace): <namespace> should be a non-empty string', tostring(namespace)
  )
  self.namespace = strupper(strtrim(namespace))
  ---@type LibTraceKit_Formatter-1.0
  self.formatter = LibPrettyPrint:Formatter({ show_all = true, depth_limit = 1 })
  self.pc = cfn(hexColor or DEFAULT_COLOR)
  self.delim = DEFAULT_DELIM
end

--- @private
--- @param ... any
function TraceKit:LogEvent(...)
  ---@type EventTrace
  local et = EventTrace; if not (et and et.LogEvent) then return end
  local n = self.namespace
  if type(self.tag) == 'string' then
    n = ('%s%s%s'):format(n, self.delim, self.tag)
  end
  et:LogEvent(self.pc(n), ...)
end

--- This is a fluid function
---@param tag string? @tag name
---@return TraceKit-1.0 | fun(...), LibTraceKit_Formatter-1.0
function TraceKit:WithTag(tag)
  assertsafe(
    type(tag) == 'string' and #strtrim(tag) > 0,
    'Invalid tag: <%s>. TraceKit:SetTag(tag): <tag> should be a non-empty string.', tostring(tag)
  )
  self.tag = strupper(strtrim(tag))
  return self, self.formatter
end

--- This is a fluid function
---@param delim string? @Delimiter override; defaults to '::', i.e. 'NAMESPACE::TAG'
---@return TraceKit-1.0 | fun(...), LibTraceKit_Formatter-1.0
function TraceKit:WithDelimiter(delim)
  assertsafe(
    type(delim) == 'string', 'Invalid delim: <%s>. TraceKit:SetDelimiter(delim): <delim> should be a string.',
    tostring(delim)
  )
  self.delim = delim
  return self, self.formatter
end

--- This is a fluid function
---@return TraceKit-1.0 | fun(...), LibTraceKit_Formatter-1.0
function TraceKit:WithUnderscoreDelimiter()
  self.delim = '_'
  return self, self.formatter
end

--[[-----------------------------------------------------------------------------
LibTraceKit
-------------------------------------------------------------------------------]]

--- ### Usage:
--- ```
--- local t, fmt = LibTraceKit:New('libtracekit', '29FFEF')
--- -- OR
--- local t, fmt = LibTraceKit:New('libtracekit')
---                   :WithTag('Main'):WithUnderscoreDelimiter()
--- -- OR
--- local t, fmt = LibTraceKit:New('libtracekit')
---                   :WithTag('EventHandler')
---                   :WithDelimiter('$')
--- ```
--- @param namespace string                                The namespace or identifier of the trace message
--- @param hexColor  LibTraceKit_HexColor-1.0 | colorRGB)? @A hex color value if tag is provided, i.e. '0056AA', 'EEFFEE'; otherwise can be ommitted.
--- @overload fun(namespace: string): TraceKit-1.0 | fun(...), LibTraceKit_Formatter-1.0
--- @return TraceKit-1.0 | fun(...), LibTraceKit_Formatter-1.0
function LibTraceKit:New(namespace, hexColor)
  assertsafe(type(namespace) == 'string', 'LibTraceKit:New(namespace): <namespace> should be a string.')

  ---@type TraceKit-1.0
  local tk = setmetatable({}, TraceKit)
  tk:__Init(namespace, hexColor)

  return tk, tk.formatter
end
