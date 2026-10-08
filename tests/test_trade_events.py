from test_multi import lua

lua.execute(r'''
local P=ProfessionHelp
local function event(e) P.events.scripts.OnEvent(P.events,e) end
local function tick() P.events.scripts.OnUpdate(P.events,0.4) end
P.frame:Hide();P.scanPending=false;P.showPending=false
linked=false;rank=1;cap=75
local reads=0
function GetTradeSkillInfo()
 reads=reads+1
 -- Simulate a trade-skill API hook emitting events during a scan.
 event('TRADE_SKILL_UPDATE')
 assert(P.ScanRecipes()==false,'recursive scan was allowed')
 return 'Test Recipe','optimal'
end
for _,key in ipairs({'Engineering','Jewelcrafting','Enchanting'}) do
 trade=key;skillName=key
 local before=reads
 event('TRADE_SKILL_SHOW')
 for i=1,1000 do event('TRADE_SKILL_UPDATE') end
 assert(reads==before,'event handler scanned synchronously')
 tick()
 assert(reads==before+1,'burst was not coalesced')
 assert(P.active==key and P.recipes['Test Recipe'])
 for i=1,10 do tick() end
 assert(reads==before+1,'scan-generated events created a feedback loop')
end
local before=reads
event('TRADE_SKILL_SHOW');event('TRADE_SKILL_CLOSE');tick()
assert(reads==before,'closed profession still scanned')
linked=true;event('TRADE_SKILL_SHOW');tick();assert(reads==before)
linked=false
local oldInfo=GetTradeSkillInfo
function GetTradeSkillInfo() error('simulated addon hook failure') end
local errors=0
function geterrorhandler() return function() errors=errors+1 end end
event('TRADE_SKILL_UPDATE');tick()
assert(not P.scanning and errors==1,'scan guard not released after error')
GetTradeSkillInfo=oldInfo
event('TRADE_SKILL_UPDATE');tick();assert(reads==before+1)
print('PASS: event bursts, recursive API hooks, idle frames, profession close, linked trades and error recovery')
''')
