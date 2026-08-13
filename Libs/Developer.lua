--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local addonName, xns = ...

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer : AceEvent-3.0
local o = {}; LibStub('AceEvent-3.0'):Embed(o); tkd = o

--- @type LibTraceKit-1.0
local LibTraceKit = LibStub('LibTraceKit-1.0')

----- @type TraceKit-1.0, LibTraceKit_Formatter-1.0
--local t, fmt = LibTraceKit:New('libtracekit', SPELLBOOK_FONT_COLOR)
--                  :WithTag('EventHandler')
--                  :WithDelimiter('.')

--- @param tag string
--- @return TraceKit_MultiFunction-1.0
local function traceFn(tag)
  --local tx, fmtx = LibTraceKit:New('libtracekit', prefix, ORANGE_THREAT_COLOR)
  local tx, fmtx = LibTraceKit:New('libtracekit')
                        :WithTag(tag)
                        :WithDelimiter('_')
  --ORANGE_THREAT_COLOR)
  return tx
end

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
function o:PLAYER_ENTERING_WORLD(evt, ...)
  local isLogIn, isReload = ...
  --local tf = traceFn('Developer')
  local t, fmt = LibTraceKit:New('libtracekit')
                        :WithTag(libName)
                        :WithColor(ORANGE_THREAT_COLOR)
                        --:WithDelimiter('_')
  t('Player logged in', 'isLogin=', isLogIn, 'isReload=', isReload)
  t('Player logged in', 'event payload=', fmt({...}))
  
  local tx, fmtx = LibTraceKit.CreateTraceFunction(addonName, libName, RARE_BLUE_COLOR)
  tx('Player logged in', 'isLogin=', isLogIn, 'isReload=', isReload)
end

--o:RegisterEvent('PLAYER_ENTERING_WORLD')