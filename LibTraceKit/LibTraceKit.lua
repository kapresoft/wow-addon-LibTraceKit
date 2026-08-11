--- @alias LibTraceKit_PrintFn LibPrettyPrint_PrintFn @Printer function that outputs plain values to Blizzard Trace UI (like print)
--- @alias LibTraceKit_TraceFn fun(...: any) : void   @Printer function that outputs plain values to Blizzard Trace UI (like print)

local addonName, xns = ...

local libName = 'LibTraceKit'
local strupper = string.upper

--- @class LibTraceKit_Namespace
--- @field addon Name
--- @field traceName Name
--- @field fmt LibPrettyPrint_Formatter
--- @field printer LibPrettyPrint_Printer
local ns = xns; ns.addon = addonName; TK_NS = ns
ns.traceName = strupper(ns.addon)

--- @private
--- @param hexColorRGB HexRGB | '565656' | 'efefef'
--- @return colorRGBA?
local function ColorFromHexRGB(hexColorRGB)
	if #hexColorRGB == #COLOR_FORMAT_RGB then
  		local r, g, b = ExtractColorValueFromHex(hexColorRGB, 1), ExtractColorValueFromHex(hexColorRGB, 3),
  		  ExtractColorValueFromHex(hexColorRGB, 5);
  		return CreateColor(r, g, b, 1);
  	end
	return nil;
end

--- @param color colorRGBA|HexRGBA|HexRGB|HexRGBA @ RED_THREAT_COLOR | '565656fc' | '565656' | 'fc565656'
--- @return cfFn, colorRGBA?
local function ColorFn(color)
  assertsafe(color, "ColorFormatter:ColorFn(color): The function arg color is a required field, but was [%s]", tostring(color))
  local c = color
  if type(c) == 'string' then c = CreateColorFromRGBHexString(color) end
  assertsafe(color, "ColorFormatter:ColorFn(color): Could not resolve color from [%s], type=[%]", tostring(c), type(c))
  return function(arg) return c:WrapTextInColorCode(tostring(arg)) end
end

local primaryC = ColorFn('7ACFFB')

ns.fmt = LibPrettyPrint:Formatter({ show_all = true, depth_limit = 3 });
ns.printer = LibPrettyPrint:Printer({
  prefix = ns.traceName, formatter = ns.fmt,
  prefix_color = '466EFF', sub_prefix_color = '9CFF9C',
})

function ns.tr(prefix, ...)
  --- @type EventTrace
  local et = EventTrace; if not (et and et.LogEvent) then return end
  local c1, logNamePlain = primaryC, ns.traceName
  local n = c1(logNamePlain)
  if type(prefix) == 'string' then n = n .. '::' .. prefix end
  et:LogEvent(n, ...)
end

--- @return string|nil
local function resolveModuleName(moduleName)
  if type(moduleName) == 'string' then return strtrim(moduleName) end
  return nil
end

--- @param prefix string|any
--- @return LibTraceKit_TraceFn
local function traceFn(prefix)
  return function(...) local trfn = ns.tr; return trfn(prefix, ...) end
end

--- @param moduleName Name
local function printerFn(moduleName)
  local lns = ns
  local m = resolveModuleName(moduleName)
  local pr = lns.printer
  if m and #m > 0 then pr = lns.printer:WithSubPrefix(m) end
  return pr
end

local p, t = printerFn(libName), traceFn('Namespace')
p('xns=', xns)
t('xns=', xns)

--[[-----------------------------------------------------------------------------
LibTraceKit
-------------------------------------------------------------------------------]]

--- @class LibTraceKit
local LibTraceKit = {}

--- @return LibTraceKit
function LibTraceKit:New()
  -- todo: impl
  return {} --[[@as LibTraceKit ]]
end
