--[[-----------------------------------------------------------------------------
Local Vars
-------------------------------------------------------------------------------]]
local addonName, xns = ...

--[[-----------------------------------------------------------------------------
New Instance
-------------------------------------------------------------------------------]]
local libName = 'Developer'
--- @class Developer
local o = {}; tkd = o

--- @type LibTraceKit-1.0
local LibTraceKit = LibStub('LibTraceKit-1.0')

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

function o:test1()
  local ltk = LibStub('LibTraceKit-1.0');
  local t = ltk:New('TraceKit'):WithTag('test');
  t('hello=', 'world')
end

--- @param evt Name
--- @param ... any
function o.PLAYER_ENTERING_WORLD(evt, ...)
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

--- @type Frame
local frame = CreateFrame('Frame')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function(_, event, ...)
  if o[event] then o[event](event, ...) end
end)
