ProfessionHelp = { version = "0.3.1-alpha", recipes = {}, pins = {} }
local P = ProfessionHelp
-- Reference facts: Wowhead WotLK Engineering leveling/recipes guides.
-- Ranges are suggestions, not promises of skill-ups. Reagents come from the client.
P.guide = {
 {1,30,"Rough Blasting Powder"}, {30,50,"Handful of Copper Bolts"},
 {50,51,"Arclight Spanner"}, {51,75,"Rough Copper Bomb"},
 {75,90,"Coarse Blasting Powder"}, {90,100,"Coarse Dynamite"},
 {100,105,"Silver Contact"}, {105,125,"Bronze Tube"},
 {125,135,"Standard Scope"}, {135,150,"Heavy Blasting Powder","Whirring Bronze Gizmo"},
 {150,160,"Bronze Framework"}, {160,175,"Explosive Sheep"},
 {175,176,"Gyromatic Micro-Adjustor"}, {176,195,"Solid Blasting Powder"},
 {195,200,"Mithril Tube"}, {200,215,"Unstable Trigger"},
 {215,238,"Mithril Casing"}, {238,250,"Hi-Explosive Bomb"},
 {250,260,"Dense Blasting Powder"}, {260,285,"Thorium Widget"},
 {285,300,"Thorium Shells"},
 {300,320,"Handful of Fel Iron Bolts","Elemental Blasting Powder","Fel Iron Casing"},
 {320,325,"Fel Iron Bomb"}, {325,335,"Adamantite Grenade"},
 {335,350,"White Smoke Flare"},
 {350,375,"Handful of Cobalt Bolts","Volatile Blasting Trigger"},
 {375,385,"Overcharged Capacitor"}, {385,390,"Explosive Decoy"},
 {390,400,"Froststeel Tube"}, {400,405,"Diamond-cut Refractor Scope"},
 {405,410,"Box of Bombs"}, {410,415,"Goblin Beam Welder"},
 {415,425,"Mana Injector Kit"}, {425,430,"Mechanized Snow Goggles"},
 {430,435,"Noise Machine"}, {435,450,"Gnomish Army Knife"},
}
-- Approximate craft operations for a WHOLE guide step, including components
-- reserved for later steps. Not output item counts or a remaining-crafts counter.
-- Source: Wowhead WotLK Engineering leveling 1-450 guide.
P.craftCounts = {
 ["Rough Blasting Powder"]=60, ["Handful of Copper Bolts"]=30,
 ["Arclight Spanner"]=1, ["Rough Copper Bomb"]=30,
 ["Coarse Blasting Powder"]=60, ["Coarse Dynamite"]=20,
 ["Silver Contact"]=5, ["Bronze Tube"]=25, ["Standard Scope"]=10,
 ["Heavy Blasting Powder"]=30, ["Whirring Bronze Gizmo"]=15,
 ["Bronze Framework"]=15, ["Explosive Sheep"]=15,
 ["Gyromatic Micro-Adjustor"]=1, ["Solid Blasting Powder"]=60,
 ["Mithril Tube"]=7, ["Unstable Trigger"]=20, ["Mithril Casing"]=40,
 ["Hi-Explosive Bomb"]=20, ["Dense Blasting Powder"]=30,
 ["Thorium Widget"]=35, ["Thorium Shells"]=15,
 ["Handful of Fel Iron Bolts"]=40, ["Elemental Blasting Powder"]=20,
 ["Fel Iron Casing"]=10, ["Fel Iron Bomb"]=10,
 ["Adamantite Grenade"]=10, ["White Smoke Flare"]=60,
 ["Handful of Cobalt Bolts"]=35, ["Volatile Blasting Trigger"]=14,
 ["Overcharged Capacitor"]=10, ["Explosive Decoy"]=7,
 ["Froststeel Tube"]=15, ["Diamond-cut Refractor Scope"]=5,
 ["Box of Bombs"]=5, ["Goblin Beam Welder"]=5,
 ["Mana Injector Kit"]=12, ["Mechanized Snow Goggles"]=7,
 ["Noise Machine"]=5, ["Gnomish Army Knife"]=30,
}
-- Reusable components per craft, from the guide's reagent totals.
-- Reverse planning protects supplies when rounded craft estimates are scaled.
P.componentNeeds = {
 ["Rough Copper Bomb"]={["Rough Blasting Powder"]=2,["Handful of Copper Bolts"]=1},
 ["Coarse Dynamite"]={["Coarse Blasting Powder"]=3},
 ["Standard Scope"]={["Bronze Tube"]=1},
 ["Explosive Sheep"]={["Heavy Blasting Powder"]=2,["Whirring Bronze Gizmo"]=1,["Bronze Framework"]=1},
 ["Unstable Trigger"]={["Solid Blasting Powder"]=1},
 ["Hi-Explosive Bomb"]={["Mithril Casing"]=2,["Unstable Trigger"]=1,["Solid Blasting Powder"]=2},
 ["Thorium Shells"]={["Dense Blasting Powder"]=1},
 ["Fel Iron Bomb"]={["Fel Iron Casing"]=1,["Handful of Fel Iron Bolts"]=2,["Elemental Blasting Powder"]=1},
 ["Adamantite Grenade"]={["Handful of Fel Iron Bolts"]=2,["Elemental Blasting Powder"]=1},
 ["White Smoke Flare"]={["Elemental Blasting Powder"]=1},
 ["Explosive Decoy"]={["Volatile Blasting Trigger"]=3},
 ["Diamond-cut Refractor Scope"]={["Froststeel Tube"]=1,["Handful of Cobalt Bolts"]=2},
 ["Box of Bombs"]={["Volatile Blasting Trigger"]=1},
 ["Noise Machine"]={["Froststeel Tube"]=2,["Overcharged Capacitor"]=2,["Handful of Cobalt Bolts"]=8},
}
-- Disposition is scoped to the included leveling route, not every game recipe.
P.keep = {
 ["Rough Blasting Powder"]="Rough Copper Bomb",
 ["Handful of Copper Bolts"]="Rough Copper Bomb",
 ["Coarse Blasting Powder"]="Coarse Dynamite",
 ["Bronze Tube"]="Standard Scope",
 ["Heavy Blasting Powder"]="Explosive Sheep",
 ["Whirring Bronze Gizmo"]="Explosive Sheep",
 ["Bronze Framework"]="Explosive Sheep",
 ["Solid Blasting Powder"]="Unstable Trigger / Hi-Explosive Bomb",
 ["Unstable Trigger"]="Hi-Explosive Bomb",
 ["Mithril Casing"]="Hi-Explosive Bomb",
 ["Dense Blasting Powder"]="Thorium Shells",
 ["Handful of Fel Iron Bolts"]="Fel Iron Bomb / Adamantite Grenade",
 ["Elemental Blasting Powder"]="Fel Iron Bomb / Adamantite Grenade / White Smoke Flare",
 ["Fel Iron Casing"]="Fel Iron Bomb",
 ["Handful of Cobalt Bolts"]="Diamond-cut Refractor Scope / Noise Machine",
 ["Volatile Blasting Trigger"]="Explosive Decoy / Box of Bombs",
 ["Overcharged Capacitor"]="Noise Machine",
 ["Froststeel Tube"]="Diamond-cut Refractor Scope / Noise Machine",
}
P.tools = {
 ["Arclight Spanner"]="Keep one as an Engineering tool.",
 ["Gyromatic Micro-Adjustor"]="Keep one as an Engineering tool.",
 ["Gnomish Army Knife"]="Keep one as a tool; sell or use the extras.",
}
function P.Disposition(name)
 if P.tools[name] then return "KEEP",P.tools[name] end
 if P.keep[name] then return "KEEP","Needed for: "..P.keep[name].."." end
 if P.active=="Enchanting" and name:find("Enchant ")==1 then return "USE / SCROLL","Enchant suitable equipment or a compatible vellum; keep rods and unused reagents." end
 if P.active=="First Aid" or P.active=="Cooking" or P.active=="Alchemy" then return "USE / SELL","Keep what you want to use; check Auction House before selling extras." end
 for _,step in ipairs(P.guide) do
  for i=3,#step do
   if step[i]==name then return "SELL / USE","Not needed by later steps in this guide. Discard only if you do not want to sell or use it." end
  end
 end
 return "CHECK FIRST","No keep/sell advice recorded for this item."
end
-- A deliberately small, sourced starter catalog. No invented coordinates/prices.
P.locations = {
 {name="Timofey Oshenko", zone="Dalaran", map="Dalaran", x=38.4,y=25.9, kind="Trainer", info="Engineering trainer; check available training in game."},
 {name="Bryan Landers", zone="Dalaran", map="Dalaran", x=38.5,y=25.0, kind="Vendor", info="Schematic: Titanium Toolbox (405)."},
 {name="Findle Whistlesteam",zone="Dalaran",map="Dalaran",x=39.5,y=24.8,kind="Trainer",info="Gnomish X-Ray Specs (425); Gnomish specialization."},
 {name="Didi the Wrench",zone="Dalaran",map="Dalaran",x=39.6,y=25.1,kind="Trainer",info="Global Thermal Sapper Charge (425); Goblin specialization."},
 {name="Logistics Officer Brighton",zone="Howling Fjord",map="HowlingFjord",x=59.6,y=63.8,kind="Vendor",faction="Alliance",rep=1037,info="Mekgineer's Chopper (450); Alliance Vanguard Exalted."},
 {name="Logistics Officer Silverstone",zone="Borean Tundra",map="BoreanTundra",x=57.6,y=66.2,kind="Vendor",faction="Alliance",rep=1037,info="Mekgineer's Chopper (450); Alliance Vanguard Exalted."},
 {name="Sebastian Crane",zone="Howling Fjord",map="HowlingFjord",x=79.6,y=30.6,kind="Vendor",faction="Horde",rep=1052,info="Mechano-hog (450); Horde Expedition Exalted."},
 {name="Gara Skullcrush",zone="Borean Tundra",map="BoreanTundra",x=41.4,y=53.6,kind="Vendor",faction="Horde",rep=1052,info="Mechano-hog (450); Horde Expedition Exalted."},
 {name="Gearcutter Cogspinner",zone="Ironforge",map="Ironforge",x=68.2,y=44.2,kind="Vendor",faction="Alliance",info="Engineering schematics/supplies; stock may vary."},
 {name="Sovik",zone="Orgrimmar",map="Ogrimmar",x=75.6,y=25.2,kind="Vendor",faction="Horde",info="Engineering schematics/supplies; stock may vary."},
}
-- Append so existing catalog location indices remain stable.
P.locations[#P.locations+1]={name="Roxxik",zone="Orgrimmar",map="Ogrimmar",x=76,y=25,kind="Trainer",faction="Horde",info="Engineering trainer: Nogg's Machine Shop, Valley of Honor. Classic recipes and ranks through Artisan."}
P.hordeTrainer=#P.locations
P.locations[#P.locations+1]={name="Springspindle Fizzlegear",zone="Ironforge",map="Ironforge",x=68.6,y=44,kind="Trainer",faction="Alliance",info="Engineering trainer: Tinker Town. Classic recipes and ranks through Artisan."}
P.allianceTrainer=#P.locations
P.trainingRanks={
 {name="Apprentice",skill=0,level=5,cap=75},
 {name="Journeyman",skill=50,level=10,cap=150},
 {name="Expert",skill=125,level=20,cap=225},
 {name="Artisan",skill=200,level=35,cap=300},
 {name="Master",skill=275,level=50,cap=375},
 {name="Grand Master",skill=350,level=65,cap=450},
}
P.catalog = {
 {"Titanium Toolbox",405,"Vendor: Bryan Landers",2},
 {"Gnomish X-Ray Specs",425,"Gnomish specialization trainer",3},
 {"Global Thermal Sapper Charge",425,"Goblin specialization trainer",4},
 {"Mekgineer's Chopper",450,"Alliance Vanguard: Exalted",5},
 {"Mechano-hog",450,"Horde Expedition: Exalted",7},
 {"Jeeves",450,"Schematic: mechanical creatures, including Library Guardians in Storm Peaks; salvaging may also yield it."},
 {"Scrapbot Construction Kit",425,"Quest chain started by SCRAP-E Access Card from Library Guardians, Storm Peaks."},
 {"White Smoke Flare",335,"Vendor schematic: Outland / Exodar / Silvermoon. Precise pins not yet included."},
}
P.sources = {}
local function source(ids, text)
 for _,id in ipairs(ids) do P.sources[id] = text end
end
source({2770,2835},"Mining: Copper Veins in starting zones; or Auction House.")
source({2771,2836},"Mining: Tin Veins; or Auction House.")
source({2772,2838},"Mining: Iron Deposits; or Auction House.")
source({3858,7912},"Mining: Mithril Deposits; or Auction House.")
source({10620,12365},"Mining: Thorium Veins; or Auction House.")
source({23424,23425},"Mining in Outland; or Auction House.")
source({36909,36912},"Mining in Northrend; or Auction House.")
source({2840,2841,2842,3575,3576,3577,3859,3860,6037,12359,23445,23446,36916,36913,41163},"Mining / Smelting (some alloys have additional reagents); or Auction House.")
source({2589,2592,4306,4338,14047},"Loot from level-appropriate humanoids in Azeroth; or Auction House.")
source({21877},"Humanoid loot in Outland; or Auction House.")
source({33470},"Humanoid loot in Northrend; or Auction House.")
source({2318,2319,4234,4304,8170,21887,33568},"Skinning level-appropriate beasts; or Auction House.")
source({37700,37701,37702,37703,37704,37705,35622,35623,35624,35625,35627,36860},"Northrend elemental materials: elemental creatures and gathering; or Auction House.")
source({22573,22574},"Outland elementals / gathering; or Auction House.")
source({2880,2901,5956,7005},"Trade supplies vendor. Visit the vendor to record the actual purchase price.")
source({2839,4357,4359,4364,4371,4375,4377,4382,10505,10558,10559,10560,15992,23781,23782,23783,39681,39682,39683,39690},"Engineering component: craft it yourself or check Auction House.")
