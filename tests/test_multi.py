from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / '.test-deps'))
from lupa.lua51 import LuaRuntime

lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute(r'''
frames={}; UIParent={}; UISpecialFrames={}; SlashCmdList={}; tinsert=table.insert
local methods={}
for _,m in ipairs({'SetFont','SetJustifyH','SetJustifyV','SetPoint','ClearAllPoints','SetFrameStrata','SetClampedToScreen','SetBackdrop','SetBackdropColor','SetBackdropBorderColor','EnableMouse','SetMovable','RegisterForDrag','StartMoving','StopMovingOrSizing','SetHighlightTexture','SetAutoFocus','SetNumeric','SetMaxLetters','ClearFocus','SetAllPoints','SetTexture','SetOwner','AddLine'}) do methods[m]=function() end end
function methods:SetWidth(v) self.width=v end
function methods:SetHeight(v) self.height=v end
function methods:SetParent(v) self.parent=v end
function methods:GetWidth() return self.width or 1000 end
function methods:GetHeight() return self.height or 668 end
function methods:SetText(v) self.text=v end
function methods:GetText() return self.text end
function methods:GetStringHeight() return #(self.text or '')/50*15+20 end
function methods:Show() self.shown=true end
function methods:Hide() self.shown=false end
function methods:IsShown() return self.shown~=false end
function methods:Enable() self.enabled=true end
function methods:Disable() self.enabled=false end
function methods:SetScript(k,v) self.scripts[k]=v end
function methods:HookScript(k,v) self.scripts[k]=v end
function methods:GetItem() return 'Rough Stone','item:2835' end
function methods:RegisterEvent(k) self.events[k]=true end
function methods:SetScrollChild(v) self.child=v end
function methods:SetVerticalScroll(v) self.scroll=v end
function methods:SetFrameLevel(v) self.level=v end
function methods:GetFrameLevel() return self.level or 1 end
function CreateFrame(kind,name,parent,template)
 local f=setmetatable({scripts={},events={},name=name,template=template},{__index=methods});frames[#frames+1]=f
 if name then _G[name]=f end
 return f
end
function methods:CreateFontString() return CreateFrame('FontString') end
function methods:CreateTexture() return CreateFrame('Texture') end
WorldMapButton=CreateFrame('Button');WorldMapFrame=CreateFrame('Frame');WorldMapFrame:Hide()
GameTooltip=CreateFrame('Frame');WorldMapTooltip=GameTooltip
ItemRefTooltip=CreateFrame('Frame')
function GetSpellInfo(id) if id==4036 then return 'Engineering' end end
rank=1;cap=75;linked=false;trade='Engineering';bag=2;standing=4
function GetNumSkillLines() return 1 end
function GetSkillLineInfo() return 'Engineering',false,0,rank,0,0,cap end
function GetItemCount(id) return bag end
function GetTradeSkillLine() return trade end
function IsTradeSkillLinked() return linked end
function GetNumTradeSkills() return 1 end
function GetTradeSkillInfo() return 'Rough Blasting Powder','optimal' end
function GetTradeSkillRecipeLink() return '|Henchant:3918|h' end
function GetTradeSkillNumReagents() return 1 end
function GetTradeSkillReagentInfo() return 'Rough Stone','icon',1,bag end
function GetTradeSkillReagentItemLink() return 'item:2835' end
function GetItemInfo(id) return 'Item '..id end
function GetMerchantNumItems() return 2 end
function GetMerchantItemInfo(i) return 'Goods','icon',100,5,10,true,i==2 end
function GetMerchantItemLink(i) return 'item:'..(i==1 and 2835 or 777) end
function UnitName() return 'Sovik' end
function GetRealZoneText() return 'Orgrimmar' end
function UnitFactionGroup() return 'Horde' end
function UnitLevel() return 80 end
function GetFactionInfoByID() return 'Faction','description',standing end
function time() return 1000 end
date=os.date
map='Dalaran';floor=1
function GetMapInfo() return map end
function GetCurrentMapDungeonLevel() return floor end
function GetMapZones(c) if c==4 then return 'Dalaran','Borean Tundra','Howling Fjord' elseif c==1 then return 'Orgrimmar' end end
function SetMapZoom(c,z) if c==1 then map='Ogrimmar' else map=({'Dalaran','BoreanTundra','HowlingFjord'})[z] end end
function SetDungeonMapLevel(v) floor=v end
function ShowUIPanel(f) f:Show() end
''')


root = Path(__file__).resolve().parents[1]
for f in root.glob('*.lua'):
    lua.execute("assert(loadstring(...))", f.read_text(encoding='utf-8'))
for name in ['Data.lua','Professions.lua','Components.lua','MoreProfessions.lua','Core.lua','Map.lua','UI.lua','Tooltips.lua']:
    lua.execute((root/name).read_text(encoding='utf-8'))
lua.execute(r'''
Minimap=CreateFrame('Frame')
getmetatable(Minimap).__index.RegisterForClicks=function() end
getmetatable(Minimap).__index.SetTexCoord=function() end
''')
lua.execute((root/'Minimap.lua').read_text(encoding='utf-8'))
lua.execute(r'''
local P=ProfessionHelp
ProfessionHelpCharDB={recipes={Legacy={name='Legacy'}},learnedNames={Legacy=true},lastRank=1}
P.Initialize()
local event=function(e) P.events.scripts.OnEvent(P.events,e);P.events.scripts.OnUpdate(P.events,0.4) end
assert(#P.professionOrder==14)
assert(P.recipes.Legacy and P.learnedNames.Legacy)
P.frame:Hide();event('PLAYER_LOGIN');assert(not P.frame:IsShown())
event('TRADE_SKILL_SHOW');assert(P.frame:IsShown());assert(P.recipes['Rough Blasting Powder'])
rank=450;P.frame:Hide();event('TRADE_SKILL_SHOW');assert(not P.frame:IsShown())
P.minimapButton.scripts.OnClick();assert(P.frame:IsShown())
rank=1;P.frame:Hide();linked=true;event('TRADE_SKILL_SHOW');assert(not P.frame:IsShown());linked=false
skillName='Alchemy';trade='Alchemy'
function GetSkillLineInfo() return skillName,false,0,rank,0,0,cap end
function GetTradeSkillInfo() return 'Minor Healing Potion','optimal' end
event('TRADE_SKILL_SHOW');assert(P.active=='Alchemy' and P.frame:IsShown())
assert(P.recipes['Minor Healing Potion'] and not P.recipes.Legacy)
assert(P.ProfessionDB('Engineering').recipes.Legacy)
P.UseProfession('Tailoring');event('TRADE_SKILL_UPDATE');assert(P.active=='Tailoring');assert(not P.recipes['Minor Healing Potion'])
P.ObserveMerchant();assert(ProfessionHelpCharDB.vendor[2835].price==20);assert(not ProfessionHelpCharDB.vendor[777])
local total,missing,unknown,rows=P.Cost({reagents={{id=2835,name='Rough Stone',count=2}}},5)
assert(total==200 and missing==160 and unknown==0 and rows[1].need==10)
for _,name in ipairs(P.professionOrder) do
 P.UseProfession(name);skillName=name;rank=1;cap=75
 assert(P.TrainerFor(1),name..' trainer missing')
 assert(P.TrainerFor(350,450),name..' grand trainer missing')
 for r=1,449 do assert(P.Step(r),name..' uncovered skill '..r) end
 for _,tab in ipairs({'Leveling','Recipes','Vendors'}) do
  for _,details in ipairs({false,true}) do
   P.tab=tab;P.details=details;P.selected=nil;P.selectedKey=nil;P.Refresh()
   local candidates={}
   for _,f in ipairs(frames) do if f.entry and f:IsShown() then candidates[#candidates+1]=f end end
   for _,f in ipairs(candidates) do f.scripts.OnClick(f) end
  end
 end
 P.tab='Leveling';P.selected=nil;P.selectedKey=nil;P.Refresh()
 if P.profile.gathering then assert(P.SuggestedCrafts({activity='gather'})==nil) end
end
P.UseProfession('Engineering');skillName='Engineering';rank=30;P.tab='Leveling';P.Refresh()
assert(P.selected=='Handful of Copper Bolts')
local t=P.TrainingInfo({name='Handful of Copper Bolts',stepStart=30})
assert(t.recipeText:find('TRAIN RECIPE') and t.trainer.zone=='Orgrimmar')
ProfessionHelpDB.mapPins=false;P.OpenMap(t.trainer)
assert(not P.frame:IsShown() and P.mapTarget==t.trainer)
local visible=false
for _,pin in ipairs(P.pins) do if pin:IsShown() and pin.loc==t.trainer then visible=true;assert(pin.width==24) end end
assert(visible)
P.UseProfession('Tailoring');P.UpdatePins()
for i,loc in ipairs(P.locations) do assert(P.pins[i].loc==loc) end
P.UseProfession('First Aid');skillName='First Aid';rank=400;cap=450
local t=P.TrainingInfo({name='Heavy Frostweave Bandage',stepStart=400})
assert(t.recipeText:find('RECIPE SOURCE') and not t.trainer)
P.UseProfession('Inscription');skillName='Inscription';rank=440;P.tab='Leveling';P.Refresh()
local firstKey=P.selectedKey
rank=150;P.selected=nil;P.selectedKey=nil;P.Refresh();assert(P.selectedKey~=firstKey)
P.UseProfession('Engineering');assert(P.recipes.Legacy)
print('PASS: Lua 5.1 syntax; 14 complete routes; every row/tab/details render; migration; recipe isolation; auto/manual opening; x3 planning; costs; trainer pins; source exceptions.')
''')
lua.execute(r'''
local P=ProfessionHelp
assert(P.SkillRate()==3)
P.UseProfession('Engineering');P.plannedCrafts=P.PlanCrafts()
assert(P.plannedCrafts['Rough Copper Bomb']==10)
assert(P.plannedCrafts['Rough Blasting Powder']>=20)
P.UseProfession('Alchemy');P.plannedCrafts=P.PlanCrafts()
assert(P.SuggestedCrafts({name='Test',baseCount=10})==4)
local expected=0
for _,s in ipairs(P.guide) do if s[3]=='Minor Healing Potion' then expected=expected+math.ceil(s.crafts/3) end end
assert(P.plannedCrafts['Minor Healing Potion']>=expected)
print('PASS: x3 rounding and component reserves')
''')
lua.execute(r'''
local P=ProfessionHelp
local refresh
for _,f in ipairs(frames) do if f.text=='Refresh' and f.scripts.OnClick then refresh=f end end
assert(refresh,'Refresh button missing')
P.UseProfession('Engineering');skillName='Engineering';rank=1;cap=75;P.tab='Leveling';P.Refresh()
P.follow=false;P.manualBatch=true;P.batch=99;rank=35
trade='Engineering';TradeSkillFrame=CreateFrame('Frame');TradeSkillFrame:Show()
function GetTradeSkillInfo() return 'Handful of Copper Bolts','optimal' end
refresh.scripts.OnClick(refresh)
assert(P.selected=='Handful of Copper Bolts' and P.follow and not P.manualBatch and P.batch~=99)
assert(P.recipes['Handful of Copper Bolts'])
local scans=0;local realScan=P.ScanRecipes
P.ScanRecipes=function() scans=scans+1;realScan() end
TradeSkillFrame:Hide();refresh.scripts.OnClick(refresh);assert(scans==0)
local reminder=false
for _,f in ipairs(frames) do if f.text and f.text:find('Open Engineering and clear its filters',1,true) then reminder=true end end
assert(reminder)
TradeSkillFrame:Show();trade='Alchemy';refresh.scripts.OnClick(refresh);assert(scans==0 and P.active=='Engineering')
trade='Engineering';linked=true;refresh.scripts.OnClick(refresh);assert(scans==0);linked=false
P.tab='Recipes';P.selected='Handful of Copper Bolts';P.Refresh();local key=P.selectedKey
refresh.scripts.OnClick(refresh);assert(scans==1 and P.selectedKey==key)
P.tab='Vendors';P.selected=nil;P.Refresh();local vendor=P.selected
refresh.scripts.OnClick(refresh);assert(P.selected==vendor)
P.ScanRecipes=realScan
print('PASS: Refresh actual button; skill advance; batch reset; scan guards; feedback; recipe/vendor selection retained')
''')
