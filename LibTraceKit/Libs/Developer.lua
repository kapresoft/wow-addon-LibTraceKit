--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer : AceEvent-3.0
local o = {}; LibStub('AceEvent-3.0'):Embed(o); tkd = o

--- @type LibTraceKit-1.0
local LibTraceKit = LibStub('LibTraceKit-1.0')

--- @type TraceKit-1.0, LibTraceKit_Formatter-1.0
local t, fmt = LibTraceKit:New('libtracekit', SPELLBOOK_FONT_COLOR)
                  :WithTag('EventHandler')
                  :WithDelimiter('.')

--[[-----------------------------------------------------------------------------
Mixin Methods
-------------------------------------------------------------------------------]]
function o:PLAYER_ENTERING_WORLD(evt, ...)
  local isLogIn, isReload = ...
  t('Player logged in', 'isLogin=', isLogIn, 'isReload=', isReload)
  t('Player logged in', 'event payload=', fmt({...}))
end

o:RegisterEvent('PLAYER_ENTERING_WORLD')
