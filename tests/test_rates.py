from test_multi import lua

lua.execute(r'''
local P=ProfessionHelp
P.UseProfession('Engineering');skillName='Engineering';rank=1;cap=75
P.tab='Leveling';P.selected=nil;P.Refresh()
assert(P.SkillRate()==3)
local expectedPowder={[1]=60,[2]=30,[3]=20,[7]=10}
local expectedBombs={[1]=30,[2]=15,[3]=10,[7]=5}
for _,rate in ipairs({1,2,3,7,1}) do
 P.manualBatch=true;P.batch=999
 P.rateButton.scripts.OnClick()
 assert(P.rateMenu:IsShown())
 P.rateOptions[rate].scripts.OnClick()
 assert(not P.rateMenu:IsShown())
 assert(P.SkillRate()==rate and ProfessionHelpCharDB.skillRate==rate)
 assert(P.rateButton.text:find('x'..rate,1,true))
 assert(P.selected=='Rough Blasting Powder')
 assert(P.batch==expectedPowder[rate] and not P.manualBatch)
 assert(P.plannedCrafts['Rough Copper Bomb']==expectedBombs[rate])
 -- In particular x7 needs 10 powder for 5 bombs, not ceil(60/7)=9.
 assert(P.plannedCrafts['Rough Blasting Powder']==expectedPowder[rate])
 local materials=false
 for _,f in ipairs(frames) do
  if f.text and f.text:find('Materials for '..expectedPowder[rate]..' craft',1,true) then materials=true end
 end
 assert(materials,'material card not recalculated')
 P.Initialize();assert(P.SkillRate()==rate,'saved character setting lost')
 for _,profession in ipairs(P.professionOrder) do
  P.UseProfession(profession);P.tab='Leveling';P.Refresh()
  assert(P.SkillRate()==rate,'profession switch changed the multiplier')
  for _,count in pairs(P.plannedCrafts) do assert(count>=1 and count==math.floor(count)) end
  if P.profile.gathering then assert(P.SuggestedCrafts({activity='gather'})==nil) end
 end
 P.UseProfession('Engineering');P.tab='Leveling';P.Refresh()
end
assert(not P.SetSkillRate(0) and not P.SetSkillRate(-1) and not P.SetSkillRate(4))
assert(not P.SetSkillRate('bad') and not P.SetSkillRate(nil))
assert(P.SkillRate()==1)
P.manualBatch=true;P.batch=42
assert(P.SetSkillRate(1) and P.manualBatch and P.batch==42,'same rate should preserve manual quantity')
local firstCharacter=ProfessionHelpCharDB
ProfessionHelpCharDB={};P.Initialize();assert(P.SkillRate()==3)
P.SetSkillRate(7)
ProfessionHelpCharDB=firstCharacter;P.Initialize();assert(P.SkillRate()==1)
for _,bad in ipairs({0,4,-2,'oops'}) do
 ProfessionHelpCharDB.skillRate=bad;P.Initialize();assert(P.SkillRate()==3)
end
ProfessionHelpCharDB.skillRate='2';P.Initialize();assert(P.SkillRate()==2)
P.frame:Show();P.rateButton.scripts.OnClick();assert(P.rateMenu:IsShown())
P.frame.scripts.OnHide();assert(not P.rateMenu:IsShown())
print('PASS: x1/x2/x3/x7 dropdown callbacks, quantities/material cards, component reserves, all professions, persistence, character isolation, invalid settings and menu close')
''')
