local P=ProfessionHelp
local register=P.RegisterProfession
register("First Aid",3273,"first-aid",{
 {1,40,"Linen Bandage",50},{40,80,"Heavy Linen Bandage",60},
 {80,115,"Wool Bandage",60},{115,150,"Heavy Wool Bandage",60},
 {150,180,"Silk Bandage",50},{180,210,"Heavy Silk Bandage",50},
 {210,240,"Mageweave Bandage",60},{240,260,"Heavy Mageweave Bandage",30},
 {260,290,"Runecloth Bandage",50},{290,300,"Heavy Runecloth Bandage",15},
 {300,340,"Netherweave Bandage",50},{340,360,"Heavy Netherweave Bandage",20},
 {360,400,"Frostweave Bandage",80},{400,450,"Heavy Frostweave Bandage",90},
})
P.professions["First Aid"].url="https://www.wow-professions.com/wotlk/first-aid-leveling-guide-wotlk-classic"
register("Cooking",2550,"cooking",{
 {1,40,"Spice Bread",45},{40,80,"Smoked Bear Meat",50},{80,100,"Dry Pork Ribs",25},
 {100,175,"Bristle Whisker Catfish",100},{175,225,"Rockscale Cod",65},
 {225,250,"Spotted Yellowtail",35},{250,285,"Poached Sunscale Salmon",45},
 {285,300,"Smoked Desert Dumplings",20},{300,325,"Ravager Dog",35},
 {325,350,"Roasted Clefthoof",35},{350,400,"Baked Manta Ray",80},
 {400,425,"Black Jelly",40},{425,450,"Dragonfin Filet",60},
})
P.professions.Cooking.url="https://www.icy-veins.com/wotlk-classic/cooking-profession-and-leveling-1-450-guide"
P.professions.Cooking.estimateNote="Craft counts are planning estimates; recheck skill after small batches."
local function gathering(name,spell,slug,rows)
 local d=register(name,spell,slug,{})
 d.gathering=true
 d.url="https://www.wowhead.com/wotlk/guide/professions/"..slug.."/overview-leveling-routes"
 for _,r in ipairs(rows) do
  local loc={name=r[3],zone=r[4],kind="Area",zoneOnly=true,info=r[5]}
  d.locations[#d.locations+1]=loc
  d.guide[#d.guide+1]={r[1],r[2],r[3],activity=r[5],loc=#d.locations,loot=r[6]}
 end
 return d
end
gathering("Mining",2575,"mining",{
 {1,65,"Copper veins","Durotar","Mine Copper in Durotar (Horde) or Elwynn Forest / Dun Morogh (Alliance). Carry a Mining Pick and enable Find Minerals.",2770},
 {65,125,"Tin and Silver","Hillsbrad Foothills","Follow hills and caves for Tin; Silver becomes available at 75. Smelting can supplement early skill gains.",2771},
 {125,175,"Iron deposits","Arathi Highlands","Mine Iron along hills. Gold becomes available at 155.",2772},
 {175,250,"Mithril deposits","Tanaris","Mine Mithril around rocky borders; continue until Thorium is available. Truesilver requires 230.",3858},
 {250,300,"Thorium veins","Un'Goro Crater","Small Thorium from 250; Rich Thorium from 275. Circle cliffs and caves.",10620},
 {300,325,"Fel Iron deposits","Hellfire Peninsula","Mine Fel Iron along rocky borders. Train Master Mining first.",23424},
 {325,350,"Adamantite deposits","Nagrand","Mine Adamantite around hills and caves, with Fel Iron as an alternative.",23425},
 {350,400,"Cobalt deposits","Borean Tundra","Train Grand Master; mine Cobalt. Howling Fjord is an alternative.",36909},
 {400,450,"Saronite deposits","Sholazar Basin","Mine Saronite; Rich Saronite from 425. Titanium requires 450 and is not a leveling target below that.",36912},
})
gathering("Herbalism",2366,"herbalism",{
 {1,50,"Peacebloom and Silverleaf","Durotar","Gather in starting zones: Durotar for Horde, Elwynn Forest for Alliance. Enable Find Herbs.",2447},
 {50,100,"Mageroyal and Briarthorn","The Barrens","Mageroyal from 50, Briarthorn from 70. Silverpine / Westfall are alternatives.",2450},
 {100,150,"Bruiseweed and Kingsblood","Hillsbrad Foothills","Bruiseweed from 100, Wild Steelbloom from 115, Kingsblood from 125.",2453},
 {150,205,"Liferoot and Fadeleaf","Arathi Highlands","Liferoot near water; Fadeleaf from 160 and Goldthorn from 170.",3357},
 {205,230,"Purple Lotus","Tanaris","Gather Purple Lotus near ruins; continue picking non-grey herbs.",8831},
 {230,250,"Sungrass","Feralas","Gather Sungrass in open areas and other non-grey herbs.",8838},
 {250,275,"Gromsblood","Felwood","Gather Gromsblood and other non-grey herbs.",8846},
 {275,300,"Golden Sansam","Winterspring","Golden Sansam from 260; Dreamfoil from 270 and Mountain Silversage from 280.",13464},
 {300,350,"Felweed and Dreaming Glory","Hellfire Peninsula","Train Master; gather Felweed and Dreaming Glory from 315. Zangarmarsh is another option.",22785},
 {350,400,"Goldclover and Tiger Lily","Borean Tundra","Train Grand Master; gather Goldclover and Tiger Lily from 375. Howling Fjord is an alternative.",36901},
 {400,425,"Adder's Tongue","Sholazar Basin","Gather Adder's Tongue and Tiger Lily.",36903},
 {425,450,"Lichbloom and Icethorn","The Storm Peaks","Lichbloom from 425, Icethorn from 435. Icecrown is an alternative.",36905},
})
gathering("Skinning",8613,"skinning",{
 {1,75,"Light Leather","Durotar","Fully loot low-level beasts, then skin them. Carry a Skinning Knife. Alliance can use Elwynn Forest.",2318},
 {75,150,"Medium Leather","The Barrens","Skin level-appropriate beasts; move toward higher-level beasts as skins turn grey. Wetlands is an Alliance alternative.",2319},
 {150,225,"Heavy Leather","Stranglethorn Vale","Skin beasts you can safely defeat; non-grey skinning can raise skill.",4234},
 {225,250,"Thick Leather","Tanaris","Skin beasts in Tanaris or Feralas.",4304},
 {250,300,"Rugged Leather","Un'Goro Crater","Skin dinosaurs and other beasts. Avoid enemies above your combat ability.",8170},
 {300,350,"Knothide Leather","Hellfire Peninsula","Train Master; skin Outland beasts. Move to Nagrand when appropriate.",21887},
 {350,450,"Borean Leather","Borean Tundra","Train Grand Master; skin Northrend beasts. Move to Sholazar Basin as targets turn grey.",33568},
})
local fishing=gathering("Fishing",7620,"fishing",{
 {1,75,"Fishing: Apprentice","Orgrimmar","Equip a fishing pole and fish in safe open water. Orgrimmar or Stormwind works. Loot catches; check your skill cap."},
 {75,150,"Fishing: Journeyman","Orgrimmar","Keep fishing in safe water. Higher skill needs more catches per skill-up. Train the next rank before reaching the cap."},
 {150,225,"Fishing: Expert","Orgrimmar","Any safe fishing water can provide skill gains. Lures help your effective fishing skill."},
 {225,300,"Fishing: Artisan","Orgrimmar","Continue catching and looting fish. Keep useful fish for Cooking or sell them."},
 {300,375,"Fishing: Master","Dalaran","Learn Master Fishing. You can continue in low-level water; Dalaran is also an option if accessible."},
 {375,450,"Fishing: Grand Master","Dalaran","Learn Grand Master and keep fishing. No fixed catch count is promised for this server."},
})
fishing.url="https://www.wowhead.com/wotlk/guide/professions/fishing/overview"

-- Verified trainer coordinates; fallback is the listed Dalaran trainer, not a guessed capital pin.
local function trainer(prof,name,zone,map,x,y,faction)
 local d=P.professions[prof]
 local l={name=name,zone=zone,map=map,x=x,y=y,faction=faction,kind="Trainer",info=prof.." trainer. Check available ranks and recipes in game."}
 d.locations[#d.locations+1]=l
 return #d.locations
end
local dalaran={
 {"Alchemy","Linzy Blackbolt",42.4,32},{"Blacksmithing","Alard Schmied",45.33,27.66},
 {"Enchanting","Enchanter Nalthanis",39.04,39.79},{"Inscription","Professor Pallin",42.4,37.5},
 {"Jewelcrafting","Timothy Jones",40.6,35.2},{"Leatherworking","Diane Cannings",34.7,28.6},
 {"Tailoring","Charles Worth",36.1,33.6},{"First Aid","Olisarra the Kind",37.6,36.6},
 {"Mining","Jedidiah Handers",41.5,25.7},{"Herbalism","Dorothy Egan",42.9,34.1},
 {"Skinning","Derik Marks",35.8,28.8},{"Fishing","Marcia Chase",52.6,65.6},
}
for _,r in ipairs(dalaran) do P.professions[r[1]].grandTrainer=trainer(r[1],r[2],"Dalaran","Dalaran",r[3],r[4]) end
local org={
 {"Tailoring","Magar",63,49.6},{"First Aid","Arnok",34,84.4},
 {"Mining","Makaru",73,26.4},{"Herbalism","Jandi",55.6,39.6},
 {"Skinning","Thuwd",63.2,45.2},{"Fishing","Lumak",69.8,29.6},
}
for _,r in ipairs(org) do P.professions[r[1]].hordeTrainer=trainer(r[1],r[2],"Orgrimmar","Ogrimmar",r[3],r[4],"Horde") end
P.professions.Jewelcrafting.hordeTrainer=trainer("Jewelcrafting","Kalinda","Silvermoon City","SilvermoonCity",90,73,"Horde")
P.professions.Cooking.grandHorde=trainer("Cooking","Awilo Lon'gomba","Dalaran","Dalaran",70,39,"Horde")
P.professions.Cooking.grandAlliance=trainer("Cooking","Katherine Lee","Dalaran","Dalaran",39.8,66.6,"Alliance")
P.professions.Engineering.grandTrainer=1

local function source(prof,name,description)
 local d=P.professions[prof];d.recipeSources=d.recipeSources or {};d.recipeSources[name]=description
end
source("Engineering","White Smoke Flare","Vendor schematic in Outland, Exodar or Silvermoon; check stock.")
source("Alchemy","Philosopher's Stone","Recipe vendor: Alchemist Pestlezugg, Gadgetzan, Tanaris. Keep the stone for transmutes.")
source("Alchemy","Super Mana Potion","Recipe vendor in Blade's Edge Mountains (Horde) or Zangarmarsh (Alliance).")
source("Blacksmithing","Imperial Plate Bracers","Plans from the Imperial Plate Bracer quest in Gadgetzan, Tanaris.")
source("Blacksmithing","Lesser Ward of Shielding","Plans vendor in Shadowmoon Valley or Hellfire Peninsula.")
source("Jewelcrafting","Pendant of the Agate Shield","Design vendor in Thousand Needles (Horde) or Wetlands (Alliance).")
source("Tailoring","Bolt of Imbued Netherweave","Pattern vendor in Shattrath City.")
source("Tailoring","Runecloth Gloves","Pattern vendor: Qia in Everlook, Winterspring; limited stock.")
source("Leatherworking","Overcast Bracers","Pattern vendor in Dalaran; costs Heavy Borean Leather.")
source("Leatherworking","Overcast Handwraps","Pattern vendor in Dalaran; costs Heavy Borean Leather.")
source("First Aid","Heavy Frostweave Bandage","Manual drops from Northrend humanoids/undead with First Aid 390+. Try Zul'Drak; learn the bandage at 400.")
local ench={
 ["Enchant Cloak - Minor Agility"]="Formula vendor in Ashenvale (Alliance) or Stonetalon Mountains (Horde).",
 ["Enchant Bracer - Lesser Strength"]="Formula vendor in Ashenvale (Alliance) or Stonetalon Mountains (Horde).",
 ["Lesser Mana Oil"]="Formula vendor in Silithus.",
 ["Enchant Shield - Greater Stamina"]="Bind-on-pickup formula vendor in Undercity or Darnassus.",
 ["Runed Arcanite Rod"]="Formula vendor in Moonglade.",
 ["Superior Wizard Oil"]="Formula vendor in Shattrath City.",
 ["Runed Adamantite Rod"]="Formula vendor in Hellfire Peninsula (Alliance) or Terokkar Forest (Horde).",
 ["Enchant Cloak - Mighty Armor"]="Formula vendor in Dalaran; costs Dream Shards.",
 ["Enchant Gloves - Armsman"]="Formula vendor in Dalaran; costs Dream Shards.",
 ["Enchant Boots - Greater Assault"]="Formula vendor in Dalaran; costs Dream Shards.",
}
for name,description in pairs(ench) do source("Enchanting",name,description) end
local cook={
 ["Smoked Bear Meat"]="Recipe: Andrew Hilbert in Silverpine Forest (Horde), Drac Roughcut in Loch Modan (Alliance).",
 ["Bristle Whisker Catfish"]="Buy the recipe from a fishing supplier; check the linked guide for your faction.",
 ["Rockscale Cod"]="Buy the recipe from a fishing supplier; check the linked guide for your faction.",
 ["Spotted Yellowtail"]="Recipe: Gikkix, Steamwheedle Port, Tanaris.",
 ["Poached Sunscale Salmon"]="Recipe: Gikkix, Steamwheedle Port, Tanaris.",
 ["Smoked Desert Dumplings"]="Quest chain starting with Desert Recipe from Calandrath in Silithus.",
 ["Ravager Dog"]="Recipe: Cookie One-Eye (Thrallmar) or Sid Limbardi (Honor Hold), Hellfire Peninsula.",
 ["Roasted Clefthoof"]="Recipe: Nula the Butcher (Garadar) or Uriku (Telaar), Nagrand.",
 ["Dragonfin Filet"]="Buy the recipe with Dalaran Cooking Awards from cooking dailies; needs Northern Spices.",
}
for name,description in pairs(cook) do source("Cooking",name,description) end
for _,d in pairs(P.professions) do
 d.notes=d.notes or {};d.recipeSources=d.recipeSources or {}
 for _,s in ipairs(d.guide) do
  local name=s[3]
  if name=="Glyphs" or name=="Major Glyphs" or name=="Uncommon Quality Gems" or name=="Rare-quality gems / meta gems" then
   s.choice=true;s.activity="Choose a learned orange/yellow recipe in this range. Open Recipes to see its materials and prices. Train or acquire new recipes when old ones turn grey."
  end
  if name:find(" Ink") or name:find("Bolt of ") then d.keep[name]=d.keep[name] or "Later recipes; keep until the route is finished" end
  if name:find("Runed .+ Rod") then d.tools[name]="Keep one as an Enchanting tool and for the next rod." end
 end
end
P.professions.Alchemy.tools["Philosopher's Stone"]="Keep one for transmutes."
P.professions.Inscription.notes["Northrend Inscription Research"]="Research has a cooldown. This step can take multiple days; check the client cooldown."
P.professions.Jewelcrafting.notes["Icy Prism"]="Icy Prism has a cooldown. This step can take multiple days; check the client cooldown."
P.professions.Alchemy.notes["Transmute: Titanium"]="Check the client for any server-specific transmute cooldown."

-- Common material sources shared by all modules. Prices remain observed, never invented.
local function materials(ids,description) for _,id in ipairs(ids) do P.sources[id]=description end end
materials({2447,765,2449,785,2450,2452,2453,3355,3356,3357,3358,3369,3818,3819,3820,3821,4625,8831,8836,8838,8839,8845,8846,13463,13464,13465,13466,13467,13468,22785,22786,22787,22789,22790,22791,22792,22793,22794,36901,36903,36904,36905,36906,36907,37921},"Herbalism: appropriate-level herbs; or Auction House.")
materials({10940,10938,10939,10998,11082,11083,11134,11135,11137,11174,11175,11176,16202,16203,16204,22445,22446,22447,22448,22449,22450,34052,34053,34054,34055,34056,34057},"Enchanting: disenchant suitable equipment; or Auction House.")
materials({774,818,1206,1210,1529,1705,3864,7909,7910,12361,12363,12364,12799,12800,23077,23079,23107,23112,23117,21929,36917,36918,36920,36921,36923,36924,36926,36927,36929,36930,36932,36933},"Mining / Jewelcrafting prospecting, or Auction House. Yield depends on ore type.")
materials({39151,39334,39338,39339,39340,39341,39342,39343,43103,43104,43105,43106,43107,43108,43109},"Inscription: mill stacks of five appropriate herbs; or Auction House.")
materials({2320,2321,4291,8343,14341,38426,3371,3372,8925,18256,39501,39502,39354},"Profession supplies vendor; visit to record a purchase price.")
