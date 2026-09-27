local P=ProfessionHelp
local function annotate(tip)
 if not P.ready or tip.professionHelpAdded then return end
 local _,link=tip:GetItem()
 local id=P.ItemID(link)
 if not id or not (P.sources[id] or ProfessionHelpCharDB.vendor[id]) then return end
 tip.professionHelpAdded=true
 local price,kind,record=P.Price(id)
 tip:AddLine(" ")
 tip:AddLine("Profession Help",1,0.82,0.35)
 tip:AddLine(P.Source(id),0.7,0.85,1,true)
 tip:AddLine("Purchase / item: "..P.Money(price),1,1,1)
 tip:AddLine(kind,0.7,0.7,0.7,true)
 if record then tip:AddLine("Observed: "..date("%Y-%m-%d %H:%M",record.time),0.7,0.7,0.7) end
end
for _,tip in ipairs({GameTooltip,ItemRefTooltip}) do
 tip:HookScript("OnTooltipSetItem",annotate)
 tip:HookScript("OnTooltipCleared",function(self) self.professionHelpAdded=nil end)
end
