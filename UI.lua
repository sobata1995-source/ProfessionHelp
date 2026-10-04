local P=ProfessionHelp
local gold="|cffffd36b"
local white="|cffffffff"
local muted="|cff9eb0c7"
local boxStyle={bgFile="Interface\\ChatFrame\\ChatFrameBackground",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=12,insets={left=3,right=3,top=3,bottom=3}}
local function text(parent,size)
 local t=parent:CreateFontString(nil,"OVERLAY","GameFontNormal")
 t:SetFont("Fonts\\FRIZQT__.TTF",size or 12)
 t:SetJustifyH("LEFT");t:SetJustifyV("TOP")
 return t
end
local function button(parent,label,w,h,fn)
 local b=CreateFrame("Button",nil,parent,"UIPanelButtonTemplate")
 b:SetWidth(w);b:SetHeight(h);b:SetText(label);b:SetScript("OnClick",fn)
 return b
end
local f=CreateFrame("Frame","ProfessionHelpFrame",UIParent)
P.frame=f
f:SetWidth(780);f:SetHeight(580);f:SetPoint("CENTER")
f:SetFrameStrata("HIGH");f:SetClampedToScreen(true)
f:SetBackdrop({bgFile="Interface\\ChatFrame\\ChatFrameBackground",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=16,edgeSize=16,insets={left=4,right=4,top=4,bottom=4}})
f:SetBackdropColor(0.035,0.05,0.085,0.98);f:SetBackdropBorderColor(0.45,0.55,0.7,1)
f:EnableMouse(true);f:SetMovable(true);f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart",function(self) self:StartMoving() end)
f:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
f:Hide()
tinsert(UISpecialFrames,"ProfessionHelpFrame")
local close=CreateFrame("Button",nil,f,"UIPanelCloseButton");close:SetPoint("TOPRIGHT",-4,-4)
local rateMenu
local title=text(f,20);title:SetPoint("TOPLEFT",20,-18);title:SetWidth(600)
local professionMenu=CreateFrame("Frame",nil,f)
professionMenu:SetWidth(356);professionMenu:SetHeight(214);professionMenu:SetPoint("TOPRIGHT",-20,-46)
professionMenu:SetFrameLevel(f:GetFrameLevel()+30);professionMenu:SetBackdrop(boxStyle)
professionMenu:SetBackdropColor(0.035,0.05,0.085,1);professionMenu:Hide()
local choose=button(f,"Profession",110,25,function() if rateMenu then rateMenu:Hide() end; if professionMenu:IsShown() then professionMenu:Hide() else professionMenu:Show() end end)
choose:SetPoint("TOPRIGHT",-32,-18)
for i,key in ipairs(P.professionOrder) do
 local name=key
 local b=button(professionMenu,name,165,25,function()
  P.UseProfession(name);P.tab="Leveling";P.ScanRecipes();professionMenu:Hide()
  P.Refresh();P.listScroll:SetVerticalScroll(0)
 end)
 b:SetPoint("TOPLEFT",10+math.floor((i-1)/7)*175,-10-((i-1)%7)*28)
end
local status=text(f,11);status:SetPoint("TOPLEFT",20,-48);status:SetWidth(735);status:SetHeight(36)
-- A small dropdown built from 3.3.5-compatible frames, matching the profession menu.
local rateButton=button(f,"Skill rate: x3",140,25,function()
 professionMenu:Hide()
 if rateMenu:IsShown() then rateMenu:Hide() else rateMenu:Show() end
end)
rateButton:SetPoint("TOPRIGHT",-32,-48)
P.rateButton=rateButton
rateMenu=CreateFrame("Frame",nil,f)
rateMenu:SetWidth(140);rateMenu:SetHeight(128)
rateMenu:SetPoint("TOPRIGHT",-32,-75)
rateMenu:SetFrameLevel(f:GetFrameLevel()+40);rateMenu:SetBackdrop(boxStyle)
rateMenu:SetBackdropColor(0.035,0.05,0.085,1);rateMenu:EnableMouse(true);rateMenu:Hide()
P.rateMenu=rateMenu
P.rateOptions={}
for i,value in ipairs(P.skillRates) do
 local rate=value
 local option=button(rateMenu,"x"..rate,120,25,function()
  rateMenu:Hide();P.SetSkillRate(rate)
 end)
 option:SetPoint("TOPLEFT",10,-8-(i-1)*28)
 P.rateOptions[rate]=option
end
f:HookScript("OnHide",function() rateMenu:Hide();professionMenu:Hide() end)
status:SetWidth(570)
P.tab="Leveling"
for i,label in ipairs({"Leveling","Recipes","Vendors"}) do
 local tab=label
 local b=button(f,label,115,25,function() P.tab=tab;P.follow=true;P.selected=nil;P.Refresh();P.listScroll:SetVerticalScroll(0) end)
 b:SetPoint("TOPLEFT",20+(i-1)*122,-88)
end
local refresh=button(f,"Refresh",90,25,function() P.RefreshNow() end);refresh:SetPoint("TOPRIGHT",-20,-88)
local current=button(f,"Current step",120,25,function() P.tab="Leveling";P.follow=true;P.selected=nil;P.Refresh();P.ScrollToCurrent() end);current:SetPoint("TOPLEFT",392,-88)
local list=CreateFrame("ScrollFrame","ProfessionHelpListScroll",f,"UIPanelScrollFrameTemplate")
list:SetPoint("TOPLEFT",20,-127);list:SetWidth(287);list:SetHeight(388)
local listChild=CreateFrame("Frame",nil,list);listChild:SetWidth(282);listChild:SetHeight(1);list:SetScrollChild(listChild)
P.listScroll=list
local detail=CreateFrame("ScrollFrame","ProfessionHelpDetailScroll",f,"UIPanelScrollFrameTemplate")
detail:SetPoint("TOPLEFT",345,-127);detail:SetWidth(391);detail:SetHeight(388)
local detailChild=CreateFrame("Frame",nil,detail);detailChild:SetWidth(385);detailChild:SetHeight(1);detail:SetScrollChild(detailChild)
local footer=text(f,10);footer:SetPoint("BOTTOMLEFT",20,13);footer:SetText("Select a recipe  |  Enter a craft count and press Enter  |  /ph")
local batchLabel=text(f,12);batchLabel:SetPoint("BOTTOMLEFT",345,41);batchLabel:SetText("Crafts:")
local batch=CreateFrame("EditBox",nil,f,"InputBoxTemplate");batch:SetWidth(46);batch:SetHeight(24);batch:SetPoint("BOTTOMLEFT",405,35)
batch:SetAutoFocus(false);batch:SetNumeric(true);batch:SetMaxLetters(3);batch:SetText("1")
batch:SetScript("OnEnterPressed",function(self) P.manualBatch=true;P.batch=math.max(1,math.min(999,tonumber(self:GetText()) or 1));self:SetText(tostring(P.batch));self:ClearFocus();P.Refresh() end)
batch:SetScript("OnEscapePressed",function(self) self:SetText(tostring(P.batch));self:ClearFocus() end)
local linkBox=CreateFrame("EditBox",nil,f,"InputBoxTemplate");linkBox:SetWidth(292);linkBox:SetHeight(24);linkBox:SetPoint("BOTTOMLEFT",25,35)
linkBox:SetAutoFocus(false);linkBox:SetScript("OnEscapePressed",function(self) self:ClearFocus() end)
linkBox:SetScript("OnEnterPressed",function(self) self:ClearFocus() end)
local detailsButton=button(f,"Details",100,25,function()
 P.details=not P.details
 detail:SetVerticalScroll(0)
 P.Refresh()
end)
detailsButton:SetPoint("BOTTOMLEFT",23,35)
-- The copyable source link is useful in the expanded view only.
linkBox:ClearAllPoints();linkBox:SetPoint("BOTTOMLEFT",137,35);linkBox:SetWidth(180)
local rows={}
local cards={}
local function setCards(sections)
 local y=0
 for i,section in ipairs(sections) do
  local card=cards[i]
  if not card then
   card=CreateFrame("Frame",nil,detailChild)
   card:SetWidth(381);card:SetBackdrop(boxStyle)
   card:SetBackdropColor(0.065,0.085,0.12,1)
   card:SetBackdropBorderColor(0.32,0.4,0.5,1)
   card.heading=text(card,11);card.heading:SetPoint("TOPLEFT",12,-10);card.heading:SetWidth(357)
   card.body=text(card,14);card.body:SetWidth(357)
   card.mapButton=button(card,"Show on map",135,25,function(self) if self.location then P.OpenMap(self.location) end end)
   card.mapButton:SetPoint("BOTTOMLEFT",12,10)
   cards[i]=card
  end
  card.heading:SetText(gold..section[1].."|r")
  local headingHeight=card.heading:GetStringHeight()
  card.body:ClearAllPoints();card.body:SetPoint("TOPLEFT",12,-(16+headingHeight))
  card.body:SetText(section[2])
  local height=math.max(64,28+headingHeight+card.body:GetStringHeight())
  local mapButton=card.mapButton
  mapButton:Hide();mapButton.location=nil
  if section[3] then
   height=height+35
   mapButton:SetParent(card);mapButton:ClearAllPoints()
   mapButton:SetPoint("BOTTOMLEFT",12,10)
   mapButton.location=section[3];mapButton:Enable();mapButton:Show()
  end
  card:SetHeight(height);card:ClearAllPoints();card:SetPoint("TOPLEFT",0,-y);card:Show()
  y=y+height+8
 end
 for i=#sections+1,#cards do cards[i]:Hide() end
 detailChild:SetHeight(math.max(388,y))
 if detail.GetVerticalScroll then detail:SetVerticalScroll(math.min(detail:GetVerticalScroll(),math.max(0,y-388))) end
end
local function setBody(s)
 setCards({{P.tab=="Vendors" and "LOCATION & PRICES" or "RECIPE DETAILS",s,P.location}})
end
local function recipeBody(entry)
 local name=entry.name
 local r=P.recipes[name]
 local lines={gold..name.."|r"}
 P.location=entry.loc and P.locations[entry.loc] or nil
 if entry.range then lines[#lines+1]=white..entry.range.."|r" end
 local training=P.TrainingInfo(entry)
 local trainingLines={}
 if training.recipeText then trainingLines[#trainingLines+1]=gold..training.recipeText.."|r" end
 if training.rankText then trainingLines[#trainingLines+1]=gold..training.rankText.."|r" end
 if training.trainer then
  P.location=training.trainer
  trainingLines[#trainingLines+1]=white.."Trainer: "..P.location.name.." - "..P.location.zone.." ("..P.location.x..", "..P.location.y..").|r"
 end
 if training.verify then trainingLines[#trainingLines+1]=muted..training.verify.."|r" end
 if entry.activity then
  local area=entry.loc and P.locations[entry.loc]
  local sections={{entry.choice and "CHOOSE A RECIPE" or "GATHERING",table.concat(lines,"\n").."\n\n"..entry.activity,area}}
  if #trainingLines>0 then sections[#sections+1]={"TRAINING",table.concat(trainingLines,"\n"),training.trainer} end
  if entry.loot then
   local itemName=GetItemInfo(entry.loot) or ("Item "..entry.loot)
   sections[#sections+1]={"KEEP / SELL",itemName.."\nKeep for your crafting professions or sell extras.\nAH / item: "..P.Money(P.AuctionPrice(entry.loot))}
  end
  sections[#sections+1]={"GUIDE",entry.choice and "Pick a learned recipe in Recipes for its exact materials. Research and vendor recipes may be needed." or "Areas are suggestions, not exact spawn pins. No fixed number of gathers or catches is promised."}
  setCards(sections);linkBox:SetText(P.profile.url)
  return
 end
 local suggested=P.SuggestedCrafts(entry)
 if suggested then
  lines[#lines+1]="\n"..gold.."Guide total (x"..P.SkillRate().."): ~"..suggested.." crafts|r"
  lines[#lines+1]=muted.."Whole step estimate; not a remaining count.|r"
  lines[#lines+1]=muted.."Yellow/green recipes may need extra crafts.|r"
  if P.keep[name] then
   lines[#lines+1]=muted.."Includes components to keep for later.|r"
  end
 end
 if P.profile.notes and P.profile.notes[name] then lines[#lines+1]=gold..P.profile.notes[name].."|r" end
 if P.profile.estimateNote then lines[#lines+1]=muted..P.profile.estimateNote.."|r" end
 if not P.details then
  local sections={{"RECIPE",table.concat(lines,"\n")}}
  if #trainingLines>0 then sections[#sections+1]={"TRAINING",table.concat(trainingLines,"\n"),training.trainer} end
  if P.location and not training.trainer then
   sections[#sections+1]={"LOCATION",white..P.location.name.." - "..P.location.zone.."|r",P.location}
  end
  local materials={}
  if r then
   local live=P.visibleRecipes and P.visibleRecipes[name]
   if live and r.difficulty=="trivial" then materials[#materials+1]="|cffff7777No skill-ups: choose another recipe.|r" end
   local _,_,_,mats=P.Cost(r,P.batch)
   materials[#materials+1]=gold.."Materials for "..P.batch.." craft(s)|r"
   for _,m in ipairs(mats) do
    materials[#materials+1]="\n"..white..m.need.." x "..m.name.."|r"
    materials[#materials+1]=muted.."Have "..m.owned.." / Missing "..m.lack.."|r"
   end
  else
   materials[#materials+1]="Open "..P.active.." and select this recipe to load its materials."
   if not training.recipeText then materials[#materials+1]=muted.."If not learned, check its source in Details.|r" end
  end
  local action,reason=P.Disposition(name)
  local color=action=="KEEP" and "|cff7be09a" or gold
  sections[#sections+1]={"MATERIALS",table.concat(materials,"\n")}
  sections[#sections+1]={"KEEP / SELL",color..action.."|r\n"..white..reason.."|r"}
  setCards(sections)
  return
 end
 if entry.source then lines[#lines+1]="\nSource: "..entry.source end
 if P.location then lines[#lines+1]=P.location.name.." - "..P.location.zone.."\n"..P.RepStatus(P.location) end
 if not r then
  lines[#lines+1]="\nNot recorded as learned. Open your "..P.active.." window with filters cleared and categories expanded to update the recipe list."
  lines[#lines+1]="\nMaterials and costs become available after the recipe is learned and visible in the profession window."
 else
  local live=P.visibleRecipes and P.visibleRecipes[name]
  lines[#lines+1]="\nLearned ("..(live and "visible in profession window" or "saved from a previous view")..")."
  if live then lines[#lines+1]="Difficulty: "..(r.difficulty or "unknown") end
  if live and r.difficulty=="trivial" then lines[#lines+1]="|cffff7777Grey recipe: no further skill-ups. Choose another recipe or train.|r" end
  local _,missing,unknown,mats=P.Cost(r,P.batch)
  lines[#lines+1]="\n"..gold.."Materials for "..P.batch.." craft(s)|r"
  for _,m in ipairs(mats) do
   lines[#lines+1]="\n"..white..m.name.."|r\nNeed "..m.need.." | Bags "..m.owned.." | Missing "..m.lack
   lines[#lines+1]="Unit: "..P.Money(m.price).." - "..m.kind
   if m.record then lines[#lines+1]="Observed: "..date("%Y-%m-%d %H:%M",m.record.time) end
   lines[#lines+1]=muted..P.Source(m.id).."|r"
  end
  lines[#lines+1]="\n"..gold..(unknown>0 and "Known-price subtotal: " or "Missing materials estimate: ")..P.Money(missing).."|r"
  if unknown>0 then lines[#lines+1]="UNKNOWN prices for "..unknown.." missing material type(s); total is incomplete." end
  lines[#lines+1]="\nPrices are per item. Vendor stock/discounts can change. Costs buy components as listed; they do not recursively price crafting components."
 end
 if name=="White Smoke Flare" then lines[#lines+1]="\nVendor schematic; check availability before buying materials." end
 lines[#lines+1]="\nCraft a small batch, then recheck your actual skill. Preserve components needed by later recipes."
 local sections={{"RECIPE DETAILS",table.concat(lines,"\n"),not training.trainer and P.location or nil}}
 if #trainingLines>0 then sections[#sections+1]={"TRAINING",table.concat(trainingLines,"\n"),training.trainer} end
 setCards(sections)
 linkBox:SetText(r and r.spell and ("https://www.wowhead.com/wotlk/spell="..r.spell) or P.profile.url)
end
function P.Refresh()
 if not P.ready then return end
 rateButton:SetText("Skill rate: x"..P.SkillRate().."  v")
 for rate,option in pairs(P.rateOptions) do
  option:SetText((rate==P.SkillRate() and "> " or "").."x"..rate)
 end
 local rank,cap=P.Skill()
 title:SetText("PROFESSION HELP  |cff6ecbff"..P.active.."|r")
 P.plannedCrafts=P.PlanCrafts()
 local auction=type(Atr_GetAuctionBuyout)=="function" and "Auctionator detected" or "Auctionator not detected"
 local hint=""
 if rank==0 then hint="Learn "..P.active.." from a trainer to begin. Browse the guide below."
 elseif rank>=450 then hint=P.active.." 450 reached. Browse Recipes and Vendors for further unlocks."
 elseif rank>=cap then hint="Skill cap reached: visit a "..P.active.." trainer before continuing." end
 status:SetText("Skill "..rank.." / "..cap..(P.details and ("   |   "..auction) or "").."\n"..muted..hint.."|r")
 local entries={}
 if P.tab=="Vendors" then
  for i,l in ipairs(P.locations) do entries[#entries+1]={name=l.name,sub=l.zone,loc=i,vendor=true} end
 else
  local seen={}
  for si,s in ipairs(P.guide) do
   for j=3,#s do
    local name=s[j]
    if P.tab=="Leveling" or not seen[name] then
     local e={name=name,key=si..":"..j,baseCount=s.crafts,activity=s.activity,choice=s.choice,loc=s.loc,loot=s.loot,stepStart=s[1],range=s[1].." - "..s[2],sub=s[1].." - "..s[2],active=rank>=s[1] and rank<s[2],source=(P.profile.recipeSources or {})[name] or "Check "..P.active.." trainer / learned recipes"}
     local suggested=P.SuggestedCrafts(e)
     if suggested then e.sub=e.sub.." | ~"..suggested.." crafts" end
     entries[#entries+1]=e
     seen[name]=true
    end
   end
  end
  if P.tab=="Recipes" then
   for _,c in ipairs(P.catalog) do
    if not seen[c[1]] then entries[#entries+1]={name=c[1],sub="Skill "..c[2],source=c[3],loc=c[4]};seen[c[1]]=true end
   end
   for name in pairs(P.recipes) do if not seen[name] then entries[#entries+1]={name=name,sub="Recorded recipe"} end end
   table.sort(entries,function(a,b) return a.name<b.name end)
  end
 end
 for _,e in ipairs(entries) do e.key=e.key or e.name end
 if not P.selected then
  P.selectedKey=nil
  for _,e in ipairs(entries) do if e.active then P.selected=e.name;P.selectedKey=e.key;break end end
  P.selected=P.selected or (entries[1] and entries[1].name)
 end
 local validKey=false
 for _,e in ipairs(entries) do if e.key==P.selectedKey and e.name==P.selected then validKey=true end end
 if not validKey then
  P.selectedKey=nil
  for _,e in ipairs(entries) do if e.name==P.selected then P.selectedKey=e.key;break end end
 end
 local selected
 for i,e in ipairs(entries) do
  local b=rows[i]
  if not b then
   b=CreateFrame("Button",nil,listChild);b:SetWidth(278);b:SetHeight(52)
   b:SetBackdrop(boxStyle)
   b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
   b.label=text(b,11);b.label:SetPoint("TOPLEFT",10,-8);b.label:SetWidth(258);b.label:SetHeight(38)
   b:SetScript("OnClick",function(self) P.follow=false;P.selected=self.entry.name;P.selectedKey=self.entry.key;detail:SetVerticalScroll(0);P.Refresh() end)
   rows[i]=b
  end
  b.entry=e;b:ClearAllPoints();b:SetPoint("TOPLEFT",0,-(i-1)*56)
  if P.selectedKey==e.key then
   b:SetBackdropColor(0.16,0.13,0.065,1);b:SetBackdropBorderColor(0.85,0.65,0.25,1)
  else
   b:SetBackdropColor(0.055,0.075,0.105,1);b:SetBackdropBorderColor(0.28,0.35,0.44,1)
  end
  b.label:SetText((P.selectedKey==e.key and gold or white)..e.name.."|r\n"..muted..(e.sub or "")..(e.active and "  < current step" or "").."|r")
  b:Show()
  if P.selectedKey==e.key then selected=e end
 end
 for i=#entries+1,#rows do rows[i]:Hide() end
 listChild:SetHeight(math.max(388,#entries*56))
 P.location=nil
 if selected and selected.vendor then
  local l=P.locations[selected.loc];P.location=l
  local lines={gold..l.name.."|r",l.kind.." - "..l.zone,l.zoneOnly and "Suggested gathering area" or (l.x..", "..l.y),"",l.info,"",P.RepStatus(l),"","Observed purchase prices (this character):"}
  local found=false
  for id,v in pairs(ProfessionHelpCharDB.vendor) do
   if v.npc==l.name then found=true;lines[#lines+1]=(GetItemInfo(id) or ("Item "..id))..": "..P.Money(v.price).."\n"..date("%Y-%m-%d %H:%M",v.time) end
  end
  if not found then lines[#lines+1]="Unknown until you visit this vendor. No invented price is shown." end
  setBody(table.concat(lines,"\n"));linkBox:SetText(P.profile.url)
 elseif selected then
  -- Load the guide quantity on selection, but preserve manual edits on refresh.
  if P.batchRecipe~=selected.key then
   P.batchRecipe=selected.key
   P.manualBatch=false
  end
  if not P.manualBatch then
   P.batch=P.SuggestedCrafts(selected) or 1
   batch:SetText(tostring(P.batch))
  end
  recipeBody(selected)
 end
 if P.tab=="Vendors" then
  detailsButton:Hide();linkBox:Show();batch:Hide();batchLabel:Hide()
 else
  detailsButton:Show();detailsButton:SetText(P.details and "Less info" or "Details")
  batch:Show();batchLabel:Show()
  if selected and selected.activity then batch:Hide();batchLabel:Hide() end
  if P.details then linkBox:Show() else linkBox:Hide() end
 end
end
function P.ScrollToCurrent()
 for i,b in ipairs(rows) do
  if b:IsShown() and b.entry.key==P.selectedKey then
   list:SetVerticalScroll(math.max(0,math.min((i-1)*56,listChild:GetHeight()-388)))
   return
  end
 end
end
function P.Show()
 if not P.ready then return end
 f:Show();P.Refresh();P.ScrollToCurrent()
end
function P.RefreshNow()
 if not P.ready then return end
 local canScan=P.ProfessionFromTrade()==P.active and (not TradeSkillFrame or TradeSkillFrame:IsShown())
 if canScan then P.ScanRecipes() end
 if MerchantFrame and MerchantFrame:IsShown() then P.ObserveMerchant() end
 if P.tab=="Leveling" then
  P.follow=true;P.selected=nil;P.selectedKey=nil
  P.manualBatch=false;P.batchRecipe=nil
  detail:SetVerticalScroll(0)
 end
 P.Refresh()
 if P.tab=="Leveling" then P.ScrollToCurrent() end
 P.UpdatePins()
 if canScan or P.profile.gathering then
  footer:SetText("Refreshed: skill, materials and prices updated.")
 else
  footer:SetText("Refreshed. Open "..P.active.." and clear its filters to update learned recipes.")
 end
end
