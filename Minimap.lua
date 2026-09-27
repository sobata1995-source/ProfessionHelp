local P = ProfessionHelp

-- Manual access remains available for every profession, including skill 450.
local button = CreateFrame("Button", "ProfessionHelpMinimapButton", Minimap)
P.minimapButton = button
button:SetWidth(32)
button:SetHeight(32)
button:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -2, -2)
button:SetFrameLevel(Minimap:GetFrameLevel() + 8)
button:RegisterForClicks("LeftButtonUp")

local icon = button:CreateTexture(nil, "ARTWORK")
icon:SetTexture("Interface\\Icons\\Trade_Engineering")
icon:SetWidth(20)
icon:SetHeight(20)
icon:SetPoint("CENTER", 0, 0)
icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local border = button:CreateTexture(nil, "OVERLAY")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
border:SetWidth(54)
border:SetHeight(54)
border:SetPoint("TOPLEFT", 0, 0)

button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
button:SetScript("OnClick", function()
 if not P.ready then return end
 if P.frame:IsShown() then
  P.frame:Hide()
 else
  P.ScanRecipes()
  P.Show()
 end
end)
button:SetScript("OnEnter", function(self)
 GameTooltip:SetOwner(self, "ANCHOR_LEFT")
 GameTooltip:SetText("Profession Help", 1, 0.82, 0)
 GameTooltip:AddLine("Click to open / close profession help.", 1, 1, 1)
 GameTooltip:AddLine("Use Profession in the window to switch.", 1, 1, 1)
 GameTooltip:Show()
end)
button:SetScript("OnLeave", function() GameTooltip:Hide() end)
button:Show()
