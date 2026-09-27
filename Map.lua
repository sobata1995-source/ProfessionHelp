local P=ProfessionHelp
function P.OpenMap(loc)
 -- Zone indices are discovered at runtime; do not use Retail map IDs.
 for continent=1,4 do
  local zones={GetMapZones(continent)}
  for zone,name in ipairs(zones) do
   if name==loc.zone then
    P.mapTarget=loc
    ShowUIPanel(WorldMapFrame)
    SetMapZoom(continent,zone)
    if loc.map=="Dalaran" and SetDungeonMapLevel then SetDungeonMapLevel(1) end
    P.UpdatePins()
    if P.frame then P.frame:Hide() end
    return
   end
  end
 end
 print("Profession Help: open "..loc.zone.." manually"..(loc.zoneOnly and "" or ("; coordinates "..loc.x..", "..loc.y))..". Automatic zone lookup currently requires an English client.")
end
function P.UpdatePins()
 if not WorldMapButton or not P.ready then return end
 local map=GetMapInfo()
 local level=GetCurrentMapDungeonLevel and GetCurrentMapDungeonLevel() or 0
 for i,loc in ipairs(P.locations) do
  local pin=P.pins[i]
  if not pin then
   pin=CreateFrame("Button",nil,WorldMapButton)
   pin:SetWidth(16);pin:SetHeight(16)
   pin:SetFrameLevel(WorldMapButton:GetFrameLevel()+20)
   local tex=pin:CreateTexture(nil,"OVERLAY")
   tex:SetAllPoints();tex:SetTexture("Interface\\Icons\\Trade_Engineering")
   pin.texture=tex;pin.loc=loc
   pin:SetScript("OnEnter",function(self)
    local l=self.loc
    local tip=WorldMapTooltip or GameTooltip
    tip:SetOwner(self,"ANCHOR_RIGHT")
    tip:SetText(l.name,1,0.82,0)
    tip:AddLine(l.zone.."  "..l.x..", "..l.y,1,1,1)
    tip:AddLine(l.info,1,1,1,true)
    tip:AddLine(P.RepStatus(l),1,0.4,0.3,true)
    tip:AddLine("Pins remain visible regardless of reputation or exploration.",0.6,0.8,1,true)
    tip:Show()
   end)
   pin:SetScript("OnLeave",function() (WorldMapTooltip or GameTooltip):Hide() end)
   P.pins[i]=pin
  end
  pin.loc=loc
  local target=P.mapTarget==loc
  pin:SetWidth(target and 24 or 16);pin:SetHeight(target and 24 or 16)
  pin:SetFrameLevel(WorldMapButton:GetFrameLevel()+(target and 21 or 20))
  if not loc.zoneOnly and (ProfessionHelpDB.mapPins or target) and map==loc.map and level<=1 then
   pin:ClearAllPoints()
   pin:SetPoint("CENTER",WorldMapButton,"TOPLEFT",loc.x/100*WorldMapButton:GetWidth(),-loc.y/100*WorldMapButton:GetHeight())
   pin:Show()
  else pin:Hide() end
 end
 for i=#P.locations+1,#P.pins do P.pins[i]:Hide() end
end
local watcher=CreateFrame("Frame")
watcher:RegisterEvent("WORLD_MAP_UPDATE")
watcher:SetScript("OnEvent",function() P.UpdatePins() end)
watcher:SetScript("OnUpdate",function(self,elapsed)
 self.t=(self.t or 0)+elapsed
 if self.t>=0.5 then
  self.t=0
  if WorldMapFrame and WorldMapFrame:IsShown() then P.UpdatePins() end
 end
end)
