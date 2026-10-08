local P = ProfessionHelp
P.batch = 1
P.follow = true
P.skillRates={1,2,3,7}
local function validRate(value)
 for _,rate in ipairs(P.skillRates) do if value==rate then return true end end
 return false
end
function P.SkillRate()
 local rate=ProfessionHelpCharDB and tonumber(ProfessionHelpCharDB.skillRate)
 return validRate(rate) and rate or 3
end
function P.SetSkillRate(value)
 local rate=tonumber(value)
 if not P.ready or not validRate(rate) then return false end
 if rate==P.SkillRate() then return true end
 ProfessionHelpCharDB.skillRate=rate
 -- Recalculate the selected step, including reserved components and materials.
 P.manualBatch=false
 P.batchRecipe=nil
 P.dirty=true
 if P.Refresh then P.Refresh() end
 return true
end
function P.PlanCrafts()
 local counts,needed,order={},{},{}
 local rate=P.SkillRate()
 for _,step in ipairs(P.guide) do
  for j=3,#step do
   local name=step[j]
   if P.craftCounts[name] then
    if not counts[name] then order[#order+1]=name end
    if step.crafts then
     counts[name]=(counts[name] or 0)+math.max(1,math.ceil(step.crafts/rate))
    else
     counts[name]=counts[name] or math.max(1,math.ceil(P.craftCounts[name]/rate))
    end
   end
  end
 end
 for i=#order,1,-1 do
  local name=order[i]
  local recipe=P.recipes[name]
  -- Unknown output: conservatively assume one item per craft until scanned.
  local made=recipe and recipe.minMade or 1
  if type(made)~="number" or made<1 then made=1 end
  counts[name]=math.max(counts[name],math.ceil((needed[name] or 0)/made))
  local needs=P.componentNeeds[name] or {}
  if recipe and recipe.reagents and #recipe.reagents>0 then
   needs={}
   for _,reagent in ipairs(recipe.reagents) do
    if P.craftCounts[reagent.name] then needs[reagent.name]=(needs[reagent.name] or 0)+reagent.count end
   end
  end
  for component,quantity in pairs(needs) do
   needed[component]=(needed[component] or 0)+quantity*counts[name]
  end
 end
 return counts
end
function P.ProfessionName(key)
 local d=P.professions[key or P.active]
 return d and (GetSpellInfo(d.spell) or d.name) or "Engineering"
end
function P.ProfessionFromTrade()
 if not GetTradeSkillLine or (IsTradeSkillLinked and IsTradeSkillLinked()) then return end
 local name=GetTradeSkillLine()
 if name=="Smelting" or name==(GetSpellInfo(2656) or "Smelting") then return "Mining" end
 for _,key in ipairs(P.professionOrder) do
  if name==key or name==P.ProfessionName(key) then return key end
 end
end
function P.ProfessionDB(key)
 local all=ProfessionHelpCharDB.professions
 all[key]=all[key] or {recipes={},learnedNames={}}
 all[key].recipes=all[key].recipes or {}
 all[key].learnedNames=all[key].learnedNames or {}
 return all[key]
end
function P.UseProfession(key)
 local d=P.professions[key]
 if not d then return end
 for _,pin in ipairs(P.pins) do pin:Hide() end
 P.active=key;P.profile=d;P.db=P.ProfessionDB(key)
 for _,field in ipairs({"guide","craftCounts","componentNeeds","keep","tools","catalog","locations","trainingRanks","hordeTrainer","allianceTrainer"}) do P[field]=d[field] end
 P.recipes=P.db.recipes;P.learnedNames=P.db.learnedNames
 P.visibleRecipes={};P.lastRank=P.db.lastRank
 P.follow=true;P.selected=nil;P.selectedKey=nil;P.batchRecipe=nil;P.manualBatch=false
 P.location=nil;P.mapTarget=nil
 if ProfessionHelpDetailScroll then ProfessionHelpDetailScroll:SetVerticalScroll(0) end
 ProfessionHelpCharDB.activeProfession=key
 P.dirty=true
end
function P.SuggestedCrafts(entry)
 if entry.activity or (P.profile.gathering and entry.stepStart) then return nil end
 if entry.baseCount and not P.keep[entry.name] then return math.max(1,math.ceil(entry.baseCount/P.SkillRate())) end
 return P.plannedCrafts[entry.name]
end
function P.ItemID(link) return link and tonumber(string.match(link,"item:(%d+)")) end
function P.Money(value)
 if not value then return "Unknown" end
 value = math.floor(value + 0.5)
 return string.format("%dg %ds %dc",math.floor(value/10000),math.floor(value/100)%100,value%100)
end
function P.EngineeringName() return GetSpellInfo(4036) or "Engineering" end
function P.Skill(key)
 key=key or P.active or "Engineering"
 for i=1,GetNumSkillLines() do
  local name,header,_,rank,_,_,cap = GetSkillLineInfo(i)
  if not header and (name==key or name==P.ProfessionName(key)) then return rank,cap end
 end
 return 0,0
end
function P.Step(rank)
 for _,s in ipairs(P.guide) do if rank >= s[1] and rank < s[2] then return s end end
end
function P.TrainerFor(skill,rankCap)
 local horde=UnitFactionGroup("player")=="Horde"
 local grand=(horde and P.profile.grandHorde or P.profile.grandAlliance) or P.profile.grandTrainer
 if skill>=300 or (rankCap and rankCap>300) then return P.locations[grand] end
 return P.locations[(horde and P.hordeTrainer or P.allianceTrainer) or grand]
end
function P.TrainingInfo(entry)
 if not entry.stepStart then return {} end
 local rank,cap=P.Skill()
 local info={}
 local nextRank
 for _,tier in ipairs(P.trainingRanks) do
  if cap<tier.cap then nextRank=tier;break end
 end
 if nextRank then
  local level=UnitLevel and UnitLevel("player") or 0
  if rank>=nextRank.skill then
   local verb=level>=nextRank.level and "TRAIN RANK: " or "NEXT RANK: "
   info.rankText=verb..nextRank.name.." "..P.active.." (cap "..nextRank.cap..")."
   if level<nextRank.level then info.rankText=info.rankText.." Requires character level "..nextRank.level.."." end
   info.trainer=P.TrainerFor(rank,nextRank.cap)
  else
   info.rankText="Next rank: "..nextRank.name.." at skill "..nextRank.skill..(nextRank.level>0 and (", character level "..nextRank.level) or "").."."
  end
 end
 if entry.stepStart and not entry.activity then
  local known=P.recipes[entry.name] or (P.learnedNames and P.learnedNames[entry.name])
  if not known then
   local source=P.profile.recipeSources and P.profile.recipeSources[entry.name]
   if source then
    info.recipeText="RECIPE SOURCE: "..source
   else
    info.recipeText="TRAIN RECIPE: "..entry.name.." (if missing)."
    info.verify="Not recorded as learned; clear "..P.active.." filters to verify."
    info.trainer=info.trainer or P.TrainerFor(entry.stepStart)
    if rank<entry.stepStart then info.verify=info.verify.." Guide step starts at skill "..entry.stepStart.."." end
   end
  end
 end
 return info
end
function P.AuctionPrice(id)
 if type(Atr_GetAuctionBuyout) ~= "function" then return nil end
 local ok,price = pcall(Atr_GetAuctionBuyout,id)
 if ok and type(price)=="number" and price>0 then return price end
end
function P.Price(id)
 local ah = P.AuctionPrice(id)
 local v = ProfessionHelpCharDB and ProfessionHelpCharDB.vendor[id]
 -- Only observed money-only prices. No conversion from vendor SELL value.
 if v and (not ah or v.price<=ah) then return v.price,"Vendor (last visit)",v end
 if ah then return ah,"Auctionator (scan age unavailable)" end
 return nil,"Unknown: scan AH or visit vendor"
end
function P.Cost(recipe,batch)
 local total,missing,unknown,rows = 0,0,0,{}
 for _,r in ipairs(recipe.reagents or {}) do
  local need=r.count*batch
  local owned=r.id and GetItemCount(r.id) or 0
  local lack=math.max(0,need-owned)
  local price,kind,record = P.Price(r.id)
  if price then total=total+need*price; missing=missing+lack*price
  elseif lack>0 then unknown=unknown+1 end
  rows[#rows+1]={id=r.id,name=r.name,need=need,owned=owned,lack=lack,price=price,kind=kind,record=record}
 end
 return total,missing,unknown,rows
end
local function scanRecipes()
 local key=P.ProfessionFromTrade()
 if not key then return end
 local db=P.ProfessionDB(key)
 local current={}
 for i=1,GetNumTradeSkills() do
  local name,difficulty = GetTradeSkillInfo(i)
  if name and difficulty~="header" then
   db.learnedNames[name]=true
   local r={name=name,difficulty=difficulty,reagents={},index=i}
   if GetTradeSkillNumMade then r.minMade=GetTradeSkillNumMade(i) end
   local link=GetTradeSkillRecipeLink(i)
   r.spell=link and tonumber(string.match(link,"enchant:(%d+)"))
   local valid=true
   for j=1,GetTradeSkillNumReagents(i) do
    local rn,_,count=GetTradeSkillReagentInfo(i,j)
    local id=P.ItemID(GetTradeSkillReagentItemLink(i,j))
    if not id or not rn then valid=false else r.reagents[#r.reagents+1]={id=id,name=rn,count=count} end
   end
   if valid then
    db.recipes[name]=r; current[name]=r
   end
  end
 end
 if key==P.active then P.visibleRecipes=current end
end
-- API hooks in other trade-skill addons may emit updates during these reads.
function P.ScanRecipes()
 if P.scanning then return false end
 P.scanning=true
 local ok,err=pcall(scanRecipes)
 P.scanning=false
 if not ok then
  if geterrorhandler then geterrorhandler()(err) end
  return false
 end
 return true
end
function P.ObserveMerchant()
 if not ProfessionHelpCharDB then return end
 for i=1,GetMerchantNumItems() do
  local name,_,price,quantity,_,_,extended=GetMerchantItemInfo(i)
  local id=P.ItemID(GetMerchantItemLink(i))
  if id and price and quantity and quantity>0 and not extended then
   ProfessionHelpCharDB.vendor[id]={price=price/quantity,time=time(),npc=UnitName("npc") or "Vendor",zone=GetRealZoneText()}
  end
 end
end
function P.Source(id)
 local v=ProfessionHelpCharDB and ProfessionHelpCharDB.vendor[id]
 if v then return "Seen at "..v.npc..", "..v.zone end
 return P.sources[id] or "Source not yet catalogued. Check the item on Wowhead or Auction House."
end
function P.RepStatus(loc)
 if loc.faction and loc.faction~=UnitFactionGroup("player") then return "Other faction" end
 if loc.rep then
  local _,_,standing=GetFactionInfoByID(loc.rep)
  if not standing or standing<8 then return "Requires Exalted (not met / unknown)" end
 end
 return "Check stock and training requirements in game"
end
function P.Initialize()
 ProfessionHelpDB=ProfessionHelpDB or {}
 if ProfessionHelpDB.auto==nil then ProfessionHelpDB.auto=true end
 if ProfessionHelpDB.mapPins==nil then ProfessionHelpDB.mapPins=true end
 ProfessionHelpCharDB=ProfessionHelpCharDB or {}
 ProfessionHelpCharDB.skillRate=P.SkillRate()
 ProfessionHelpCharDB.vendor=ProfessionHelpCharDB.vendor or {}
 ProfessionHelpCharDB.recipes=ProfessionHelpCharDB.recipes or {}
 ProfessionHelpCharDB.learnedNames=ProfessionHelpCharDB.learnedNames or {}
 ProfessionHelpCharDB.professions=ProfessionHelpCharDB.professions or {}
 if not ProfessionHelpCharDB.professions.Engineering then
  ProfessionHelpCharDB.professions.Engineering={recipes=ProfessionHelpCharDB.recipes,learnedNames=ProfessionHelpCharDB.learnedNames,lastRank=ProfessionHelpCharDB.lastRank}
 end
 local active=ProfessionHelpCharDB.activeProfession
 P.UseProfession(P.professions[active] and active or "Engineering")
 P.ready=true
end
local events=CreateFrame("Frame")
P.events=events
for _,e in ipairs({"ADDON_LOADED","PLAYER_LOGIN","SKILL_LINES_CHANGED","TRADE_SKILL_SHOW","TRADE_SKILL_UPDATE","TRADE_SKILL_CLOSE","BAG_UPDATE","MERCHANT_SHOW","MERCHANT_UPDATE","MERCHANT_CLOSED"}) do events:RegisterEvent(e) end
events:SetScript("OnEvent",function(_,event,arg)
 if event=="ADDON_LOADED" and arg=="ProfessionHelp" then P.Initialize() end
 if not P.ready then return end
 if event=="MERCHANT_SHOW" or event=="MERCHANT_UPDATE" then P.ObserveMerchant() end
 if event=="TRADE_SKILL_CLOSE" then P.scanPending=false;P.showPending=false end
 if event=="TRADE_SKILL_SHOW" or event=="TRADE_SKILL_UPDATE" then
  -- Coalesce bursts outside the event handler, without a scan/update loop.
  if P.scanning then return end
  P.scanPending=true
  if event=="TRADE_SKILL_SHOW" then P.showPending=true end
 end
 if event=="PLAYER_LOGIN" or event=="SKILL_LINES_CHANGED" then
  for _,key in ipairs(P.professionOrder) do
   local rank=P.Skill(key)
   local db=P.ProfessionDB(key)
   if event=="SKILL_LINES_CHANGED" and db.lastRank and rank<db.lastRank then
    db.recipes={};db.learnedNames={}
    if key==P.active then P.recipes=db.recipes;P.learnedNames=db.learnedNames;P.visibleRecipes={} end
   end
   if key==P.active then
    if rank~=P.lastRank and P.follow and P.tab=="Leveling" then P.selected=nil;P.selectedKey=nil end
    P.lastRank=rank
   end
   if rank>0 or event=="SKILL_LINES_CHANGED" then db.lastRank=rank end
  end
 end
 P.dirty=true
end)
events:SetScript("OnUpdate",function(self,elapsed)
 self.elapsed=(self.elapsed or 0)+elapsed
 if self.elapsed<0.4 then return end
 self.elapsed=0
 if P.scanPending then
  local show=P.showPending
  P.scanPending=false;P.showPending=false
  local key=P.ProfessionFromTrade()
  if key then
   if show and key~=P.active then P.UseProfession(key) end
   P.ScanRecipes()
   P.dirty=true
   if show and ProfessionHelpDB.auto then
    local rank=P.Skill(key)
    if rank>0 and rank<450 then P.Show();P.dirty=false end
   end
  end
 end
 if P.dirty and P.frame and P.frame:IsShown() then P.dirty=false; P.Refresh() end
end)
SLASH_PROFESSIONHELP1="/ph"
SLASH_PROFESSIONHELP2="/professionhelp"
SlashCmdList.PROFESSIONHELP=function(msg)
 if msg=="auto" then ProfessionHelpDB.auto=not ProfessionHelpDB.auto; print("Profession Help auto-open: "..tostring(ProfessionHelpDB.auto))
 elseif msg=="pins" then ProfessionHelpDB.mapPins=not ProfessionHelpDB.mapPins; P.mapTarget=nil; P.UpdatePins(); print("Profession Help map pins: "..tostring(ProfessionHelpDB.mapPins))
 elseif msg=="reset" then P.frame:ClearAllPoints();P.frame:SetPoint("CENTER");P.Show()
 else
  for _,key in ipairs(P.professionOrder) do if string.lower(msg)==string.lower(key) then P.UseProfession(key);break end end
  P.Show()
 end
end
