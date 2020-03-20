_G.EXILE_M = RegisterMod("CaptainsLog", 1)

_G.exile_m ={
  DEBUG = false,
  Testmode = false,

  VERSION = "1.23",

  loadCounter = 0,
}

_G.sound = SFXManager()
_G.game = Game()
_G.music = MusicManager()

math.randomseed(Game():GetRoom():GetDecorationSeed())

-- ENEMY Requires

----- DEAR DATA MINER, If you are looking at my code then welcome to the main.lua. This is the foundation of my mod.
-- I just ask that you don't take anything as a carbon copy of code, you can learn from it, just don't copy it thats all.
--- I'll probably just make tutorials on how to do each of the items and such, my coding is pretty messy after all.

local musicid = music:GetCurrentMusicID()

local level = nil
local players = nil

function EXILE_M.ongamestartNonlevelchange()
  level = Game():GetLevel()
  players = Game():GetPlayer(0)
end 

EXILE_M:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, EXILE_M.ongamestartNonlevelchange)

do
EXILE_M.SavedData = {
}

local _, err = pcall(require, "scripts.p20helper.p20helper")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(tostring(err))
end

local json = require("json")

function EXILE_M:LoadCustomData(getSave)
Isaac.DebugString("Save Data Encoding (1)")
	if EXILE_M:HasData() then
		EXILE_M.SavedData = json.decode(Isaac.LoadModData(EXILE_M))
	end
	Isaac.DebugString("Save Data Encoding (2)")
end
EXILE_M:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, EXILE_M.LoadCustomData)

function EXILE_M:SaveGame()
	EXILE_M.SaveData(EXILE_M, json.encode(EXILE_M.SavedData))
end
EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EXILE_M.SaveGame)
EXILE_M:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, EXILE_M.SaveGame)
do --- for achievements of course, the variables are listed here
if EXILE_M.SavedData.Morality == nil then EXILE_M.SavedData.Morality = 0 end
if EXILE_M.SavedData.MoralityMultiplier == nil then EXILE_M.SavedData.MoralityMultiplier = 0 end



if EXILE_M.SavedData.CasetteUnlock == nil then EXILE_M.SavedData.CasetteUnlock = 0 end
if EXILE_M.SavedData.LectionaryUnlock == nil then EXILE_M.SavedData.LectionaryUnlock = 0 end
if EXILE_M.SavedData.LanternUnlock == nil then EXILE_M.SavedData.LanternUnlock = 0 end
if EXILE_M.SavedData.TwoFingerUnlock == nil then EXILE_M.SavedData.TwoFingerUnlock = 0 end
if EXILE_M.SavedData.MisericordeUnlock == nil then EXILE_M.SavedData.MisericordeUnlock = 0 end
----- Morality Core

if EXILE_M.SavedData.HasHalo == nil then EXILE_M.SavedData.HasHalo = 0 end
if EXILE_M.SavedData.HasHolyWater == nil then EXILE_M.SavedData.HasHolyWater = 0 end
if EXILE_M.SavedData.HasPurity == nil then EXILE_M.SavedData.HasPurity = 0 end
if EXILE_M.SavedData.HasHolyGrail == nil then EXILE_M.SavedData.HasHolyGrail = 0 end
if EXILE_M.SavedData.HasBloodofMartyr == nil then EXILE_M.SavedData.HasBloodofMartyr = 0 end
if EXILE_M.SavedData.HasHolyMantle == nil then EXILE_M.SavedData.HasHolyMantle = 0 end

if EXILE_M.SavedData.LevelResetBumDeaths == nil then EXILE_M.SavedData.LevelResetBumDeaths = 0 end
if EXILE_M.SavedData.LevelResetBumDeaths2 == nil then EXILE_M.SavedData.LevelResetBumDeaths2 = 0 end
if EXILE_M.SavedData.LevelResetBumDeaths3 == nil then EXILE_M.SavedData.LevelResetBumDeaths3 = 0 end
if EXILE_M.SavedData.LevelResetBumDeaths4 == nil then EXILE_M.SavedData.LevelResetBumDeaths4 = 0 end
if EXILE_M.SavedData.LevelResetBumDeaths5 == nil then EXILE_M.SavedData.LevelResetBumDeaths5 = 0 end
if EXILE_M.SavedData.DevilRoomMorality == nil then EXILE_M.SavedData.DevilRoomMorality = 0 end
--- beyond this point is for item save data
if EXILE_M.SavedData.TrinketForgeDmgBoost == nil then EXILE_M.SavedData.TrinketForgeDmgBoost = 0 end
if EXILE_M.SavedData.TitheDono == nil then EXILE_M.SavedData.TitheDono = 0 end
if EXILE_M.SavedData.Misericorde == nil then EXILE_M.SavedData.Misericorde = 0 end
if EXILE_M.SavedData.PathosKills == nil then EXILE_M.SavedData.PathosKills = 0 end
if EXILE_M.SavedData.Incense == nil then EXILE_M.SavedData.Incense = 0 end

--- Player Init Data
if EXILE_M.SavedData.InitAgnes == nil then EXILE_M.SavedData.InitAgnes = 0 end

end
end

do -- tables
Agnes_Char = {
	PlayerType = Isaac.GetPlayerTypeByName("Agnes"),
	UnlockGFX = {
		ItLives = "",
		Isaac = "gfx/ui/achievement/custom/ach_heresy.png",
		Satan = "",
		MegaSatan = "",
		TheLamb = "gfx/ui/achievement/custom/ach_lectionary.png",
		Hush = "",
		Delirium = "",
		UltraGreed = "",
		BossRush = "gfx/ui/achievement/custom/ach_corinthcloak.png",
		BlueBaby = "",
	},
}

end

function EXILE_M:gameStart(getSave) --- Reset Save
local player = Isaac.GetPlayer(0)
    if not getSave then
	--	player:GetData().playerID = 1
		EXILE_M.SavedData.TitheDono = 0
		EXILE_M.SavedData.PathosKills = 0
		EXILE_M.SavedData.TrinketForgeDmgBoost = 0
		EXILE_M.SavedData.LevelResetBumDeaths = 0
		EXILE_M.SavedData.LevelResetBumDeaths2 = 0
		EXILE_M.SavedData.LevelResetBumDeaths3 = 0
		EXILE_M.SavedData.LevelResetBumDeaths4 = 0
		EXILE_M.SavedData.LevelResetBumDeaths5 = 0
		EXILE_M.SavedData.DevilRoomMorality = 0
		EXILE_M.SavedData.HasHalo = 0
		EXILE_M.SavedData.HasHolyWater = 0
		EXILE_M.SavedData.HasPurity = 0
		EXILE_M.SavedData.HasHolyGrail = 0
		EXILE_M.SavedData.HasBloodofMartyr = 0
		EXILE_M.SavedData.HasHolyMantle = 0
		EXILE_M.SavedData.Morality = 0
		EXILE_M.SavedData.MoralityMultiplier = 0
		EXILE_M.SavedData.Misericorde = 0
		EXILE_M.SavedData.InitAgnes = 0
		
		player:EvaluateItems()
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
    end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, EXILE_M.gameStart)


_G.Sounds = {
	PIRATE_WHISTLE = Isaac.GetSoundIdByName("Pirate Whistle"),
	THROWRANG = Isaac.GetSoundIdByName("Throw Whoosh"),
	DARKSPELL = Isaac.GetSoundIdByName("Darkness"),
	CASETTESTING = Isaac.GetSoundIdByName("Casette Stinger"),
	BELL_BUOY = Isaac.GetSoundIdByName("Bell"),
	METALSCRATCH = Isaac.GetSoundIdByName("Metal Scratch"),
	SPLASH_WATER = Isaac.GetSoundIdByName("Water"),
	SPLASH_WATER2 = Isaac.GetSoundIdByName("Water2"),
	RAPID_BEEP = Isaac.GetSoundIdByName("Beeping"),
	HAZELLAUGH = Isaac.GetSoundIdByName("Hazel Laugh"),
	
	LABOSSHIT = Isaac.GetSoundIdByName("LAHIT"),
	LABOSSDIE = Isaac.GetSoundIdByName("LADIE"),
	ROBOTIC = Isaac.GetSoundIdByName("Robotic"),
	GLASSBREAK = Isaac.GetSoundIdByName("Glass Break"),
	
	
	THUNDER = Isaac.GetSoundIdByName("Thunder"),
	
	LOUDBELL = Isaac.GetSoundIdByName("Loud Bell"),
	CLOCKSPIN = Isaac.GetSoundIdByName("Clock Spin"),
	ROCKET_LAND = Isaac.GetSoundIdByName("Rocket"),
	AIR_HISS = Isaac.GetSoundIdByName("Air Hiss"),
	CLOCKTICK = Isaac.GetSoundIdByName("Clock Tick"),
	CLOCKCRANE = Isaac.GetSoundIdByName("Crane Chain"),
	BEEDLEBELL = Isaac.GetSoundIdByName("Small Bell"),
	SCI_FI = Isaac.GetSoundIdByName("Electrical"),
	AESTHETIC = Isaac.GetSoundIdByName("Aesthetic"),
	INSECTSWARMDUMMY = Isaac.GetSoundIdByName("Insect Swarm Custom"),
	WHOOSH = Isaac.GetSoundIdByName("Whoosh"),
	HALLUCINATE = Isaac.GetSoundIdByName("Hallucination"),
	SPARKLE = Isaac.GetSoundIdByName("Sparkle"),
	CONVEYORBELTS = Isaac.GetSoundIdByName("Conveyor Belt"),
	GEARTURN = Isaac.GetSoundIdByName("Gear Turn"),
	SPINLOOP = Isaac.GetSoundIdByName("Head Spin"),
	FAUCETPOUR = Isaac.GetSoundIdByName("Faucet Pour"),
	MORALITYDOWN = Isaac.GetSoundIdByName("Morality Down"),
	MORALITYDOWNSM = Isaac.GetSoundIdByName("Morality Down Small"),
	HOLY_TWO = Isaac.GetSoundIdByName("Holy2"),
	LIGHTNINGPEND = Isaac.GetSoundIdByName("Spark"),
	LIGHTNINGSTRIKE = Isaac.GetSoundIdByName("Lightning Strike"),
	GUNSPIN = Isaac.GetSoundIdByName("Gun spin"),
	GEARSPIN = Isaac.GetSoundIdByName("Gears Spin"),
	LASERFIRE = Isaac.GetSoundIdByName("Laser Pew"),
	BELLRING = Isaac.GetSoundIdByName("Bell Ring"),
	GEARSLOCK = Isaac.GetSoundIdByName("Gears Retract"),
	FLINTLOCK = Isaac.GetSoundIdByName("Flintlock"),
	STAB = Isaac.GetSoundIdByName("Stab"),
	SWORDBEAM = Isaac.GetSoundIdByName("Shing"),
	BUZZER = Isaac.GetSoundIdByName("Buzzer"),
	FIRELIGHT = Isaac.GetSoundIdByName("Fire Light"),
	THUNDERSTORM = Isaac.GetSoundIdByName("Thunderstorm"),
	SMUSH = Isaac.GetSoundIdByName("Smush"),
	TIDALDOOR = Isaac.GetSoundIdByName("TidalDoor"),
	FALLINGWHISTLE = Isaac.GetSoundIdByName("Falling"),
	BUZZSAW = Isaac.GetSoundIdByName("Buzzsaw"),
	FIRESWORD = Isaac.GetSoundIdByName("Fire Sword"),
	EYECLINK = Isaac.GetSoundIdByName("Eye Clink"),
	OCEAN = Isaac.GetSoundIdByName("Ocean"),
	HAZELDIE = Isaac.GetSoundIdByName("Hazel Die"),
	ALARM1 = Isaac.GetSoundIdByName("Alarm1"),
	HOLY_CHANT = Isaac.GetSoundIdByName("Chant")
}

local Ambient = {
	CLOCKWORK_AMB = Isaac.GetSoundIdByName("Clockwork Ambience")
}


HEART_THEME = Isaac.GetMusicIdByName("Heart")
TIDAL_ENTRANCE = Isaac.GetMusicIdByName("Tidal Entrance")
AZTEC_THEME = Isaac.GetMusicIdByName("Aztec") -- Clockwork theme file name, believe it or not
CASSETTEROOM = Isaac.GetMusicIdByName("Don't Touch It")
TIDALINTRO = Isaac.GetMusicIdByName("FloorIntro1")

local item_hhfrag = Isaac.GetItemIdByName("Holy Hand Grenade")
local item_petcem = Isaac.GetItemIdByName("Pet Cemetery")
local item_crown = Isaac.GetItemIdByName("Stabbed Crown")
local item_lectionary = Isaac.GetItemIdByName("Lectionary")


EXILE_M.COLLECTIBLE_LECTIONARY = Isaac.GetItemIdByName("Lectionary")


EXILE_M.COLLECTIBLE_HERESY = Isaac.GetItemIdByName("Heresy")
EXILE_M.COLLECTIBLE_MISERICORDE = Isaac.GetItemIdByName("Misericorde")
EXILE_M.COLLECTIBLE_DIVINEINT = Isaac.GetItemIdByName("Divine Intervention")
EXILE_M.COLLECTIBLE_AMBROSIA = Isaac.GetItemIdByName("Golem")
EXILE_M.COLLECTIBLE_SIPPYCUP = Isaac.GetItemIdByName("Sippy Cup")
EXILE_M.COLLECTIBLE_CREED = Isaac.GetItemIdByName("Creed")
EXILE_M.COLLECTIBLE_TWOFINGER = Isaac.GetItemIdByName("Two-Finger Swear")


EXILE_M.COLLECTIBLE_TUBERC = Isaac.GetItemIdByName("Tuberculosis")
EXILE_M.COLLECTIBLE_HORUS = Isaac.GetItemIdByName("Eye of Horus")
EXILE_M.COLLECTIBLE_SCATBOY = Isaac.GetItemIdByName("Scat Shot")
EXILE_M.COLLECTIBLE_CORINTHCLOAK = Isaac.GetItemIdByName("Corinthian Cloak")

EXILE_M.TRINKET_TARDYSLIP = Isaac.GetTrinketIdByName("Tardy Slip")


EXILE_M.COLLECTIBLE_CHARMGREED = Isaac.GetItemIdByName("Charm of Greed")

EntityType.FATEFINAL = Isaac.GetEntityTypeByName("Fate Boss")



EntityType.ASMODEUS = Isaac.GetEntityTypeByName("Asmodeus")
EntityType.BOULDERGEIST = Isaac.GetEntityTypeByName("Bouldergeist")
EntityType.DARKCASTER = Isaac.GetEntityTypeByName("Dark Caster")
EntityType.LOALOA = Isaac.GetEntityTypeByName("Loa Loa")
EntityType.LOALOA2 = Isaac.GetEntityTypeByName("Loa Loa 2")
EntityType.SIMONBOSS = Isaac.GetEntityTypeByName("SIMON")
EntityType.DUKEOFLOCUSTS = Isaac.GetEntityTypeByName("Duke of Locusts")

EntityType.BOULDERCORPSE = Isaac.GetEntityTypeByName("Bouldergeist Corpse")

EntityType.SPLODER = Isaac.GetEntityTypeByName("Sploder")
EntityType.BELLHAZARD = Isaac.GetEntityTypeByName("Clock Bell (Normal)")
EntityType.AIRPIPE = Isaac.GetEntityTypeByName("Air Pipe")
EntityType.METEORITE = Isaac.GetEntityTypeByName("Meteorite")
EntityType.GEYSER = Isaac.GetEntityTypeByName("Geyser Jet")
EntityType.BIGCRUSHER = Isaac.GetEntityTypeByName("Big Crusher")
EntityType.PIRATEBONEY = Isaac.GetEntityTypeByName("Bilge Rat")
EntityType.BLOODBOY = Isaac.GetEntityTypeByName("Blood Boy")

EntityType.COMBUSTIHORF = Isaac.GetEntityTypeByName("Combustihorf")
EXILE_M.COMBUSTIHORF = Isaac.GetEntityVariantByName("Combustihorf")

EntityType.RINGALING = Isaac.GetEntityTypeByName("Ringaling")

EntityType.CONVEYORBELT = Isaac.GetEntityTypeByName("Conveyor Belt (Right)")



--- SPECIAL GAPERS ENTITY: THE ENTITY USED BY MOST GAPERS IN THE MOD
EntityType.SPECIALGAPER = Isaac.GetEntityTypeByName("Grimace Gaper")


EntityType.RAMMER = Isaac.GetEntityTypeByName("Rammer")
EntityType.DARKFIST = Isaac.GetEntityTypeByName("Dark Fist")
EntityType.FOUNT = Isaac.GetEntityTypeByName("Fount")
EntityType.ANGELHELPER = Isaac.GetEntityTypeByName("Angel Helper")
EntityType.CHESTMIMIC = Isaac.GetEntityTypeByName("Chest Mimic")

EntityType.AFTERIMAGE = Isaac.GetEntityTypeByName("Fate Afterimage")
EntityType.CAFTERIMAGE = Isaac.GetEntityTypeByName("Caster Afterimage")
EntityType.DAFTERIMAGE = Isaac.GetEntityTypeByName("Duke Afterimage")


EntityType.CEYES = Isaac.GetEntityTypeByName("Caster Eyes")
EntityType.LIGHTNING = Isaac.GetEntityTypeByName("Lightning Strike")
EntityType.INCENSE = Isaac.GetEntityTypeByName("Incense Aura")

EntityType.CLOCKSTATUE = Isaac.GetEntityTypeByName("Shooting Statue")
EntityType.CLOCKSTATUEDECOR = Isaac.GetEntityTypeByName("Decorative Statue")
EntityType.FIRESTATUE = Isaac.GetEntityTypeByName("Fire Statue")

EntityType.SLASH = Isaac.GetEntityTypeByName("Slash Effect")
EntityType.LIGHTNINGEFF = Isaac.GetEntityTypeByName("Lightning Effect")
EntityType.RETICLE = Isaac.GetEntityTypeByName("Lectionary Reticle")


-- EX BOSSES
EntityType.MONSTROEX = Isaac.GetEntityTypeByName("Monstro EX")
EntityType.MINISTROEX = Isaac.GetEntityTypeByName("Ministro EX")

EntityType.MOMSHEART = Isaac.GetEntityTypeByName("Mom's Heart")

EXILE_M.AGNESHAIR = Isaac.GetCostumeIdByPath("gfx/characters/agnes_hair.anm2")


EXILE_M.COSTUME_TUBERC = Isaac.GetCostumeIdByPath("gfx/characters/tuberc_head.anm2")
EXILE_M.COSTUME_GOLEMHEAD = Isaac.GetCostumeIdByPath("gfx/characters/golem_head.anm2")
EXILE_M.COSTUME_GOLEMBODY = Isaac.GetCostumeIdByPath("gfx/characters/golem_body.anm2")
EXILE_M.COSTUME_SOYPLACEHOLDER = Isaac.GetCostumeIdByPath("gfx/characters/330_soymilk.anm2")
EXILE_M.COSTUME_CHOCOPLACEHOLDER = Isaac.GetCostumeIdByPath("gfx/characters/choco_milk.anm2")
EXILE_M.COSTUME_CREEDHEAD = Isaac.GetCostumeIdByPath("gfx/characters/creed_head.anm2")
EXILE_M.COSTUME_CREEDBODY = Isaac.GetCostumeIdByPath("gfx/characters/creed_body.anm2")
EXILE_M.COSTUME_SCATHEAD = Isaac.GetCostumeIdByPath("gfx/characters/scatboy_head.anm2")

EXILE_M.COSTUME_CORINTHROBE = Isaac.GetCostumeIdByPath("gfx/characters/corinth_robe.anm2")

EXILE_M.COSTUME_TWOFINGERHEAD = Isaac.GetCostumeIdByPath("gfx/characters/twofinger_head.anm2")
EXILE_M.COSTUME_TWOFINGERBODY = Isaac.GetCostumeIdByPath("gfx/characters/twofinger_body.anm2")
EXILE_M.COSTUME_TWOFINGERGLOW = Isaac.GetCostumeIdByPath("gfx/characters/darkmitre.anm2")

EXILE_M.COSTUME_HORUSGLOW = Isaac.GetCostumeIdByPath("gfx/characters/horus_glow.anm2")

EXILE_M.COSTUME_CHARMGREED = Isaac.GetCostumeIdByPath("gfx/characters/charmofgreed.anm2")

EXILE_M.COSTUME_HERESYWINGS = Isaac.GetCostumeIdByPath("gfx/characters/fate_temp.anm2")

EXILE_M.HOLYGRENADE = Isaac.GetEntityTypeByName("Holy Hand Grenade")

TearVariant.INVISTEAR = Isaac.GetEntityVariantByName("Invis Tear")
TearVariant.SWORDTEAR = Isaac.GetEntityVariantByName("Sword Tear")
TearVariant.POOPTEAR = Isaac.GetEntityVariantByName("Scat Tear")
TearVariant.LUNGTEAR = Isaac.GetEntityVariantByName("Lung Tear")

EffectVariant.LUNGPOOF = Isaac.GetEntityVariantByName("Lung Tear Poof")

ProjectileVariant.SCYTHE = Isaac.GetEntityVariantByName("Scythe Shot")

BLACK_RAMMER = Isaac.GetEntityVariantByName("Black Rammer")

-- moralitymeter

EffectVariant.MORALITYDOWN = Isaac.GetEntityVariantByName("Morality Down")
EffectVariant.MORALITYUP = Isaac.GetEntityVariantByName("Morality Up")

---
EntityType.WINDHOST = Isaac.GetEntityTypeByName("Wind Host")
EntityType.STORMHOST = Isaac.GetEntityTypeByName("Storm Host")

---- CLOCKWORK ENTITIES (Clocks, buttons, etc)
EntityType.TIMEBUTTON = Isaac.GetEntityTypeByName("Time Reversal Button")
EntityType.CLOCKWORKCRANE = Isaac.GetEntityTypeByName("Clockwork Crane")
EntityType.CLOCKSPINNER = Isaac.GetEntityTypeByName("Clockdial (Spinner)")
EntityType.BOULDERGBOULDER = Isaac.GetEntityTypeByName("Bouldergeist Boulder")
EntityType.CLOCKRESET = Isaac.GetEntityTypeByName("Clockdial (Reset)")
EntityType.CLOCKSUMMON = Isaac.GetEntityTypeByName("Clockdial (Summons)")
EntityType.FAUCETRIGHT = Isaac.GetEntityTypeByName("Faucet (Right)")
EntityType.FAUCETLEFT = Isaac.GetEntityTypeByName("Faucet (Left)")
EntityType.GEAREFFECT = Isaac.GetEntityTypeByName("Clockwork Gear")

EXILE_M.PlayerAgnes = Isaac.GetPlayerTypeByName("Agnes")

local CurrentStage

-- EX CODE;
---------------------
----------------------



--- FAMILIARS ---


--- Come back to this one, idiot. - A message to myself -


---- Crosier

-- SCAT SHOT Update

function EXILE_M:ScatCache(player, cacheFlag)
    if player:HasCollectible(EXILE_M.COLLECTIBLE_SCATBOY) then
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay + 1;
		end
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = Color(0.125, 0.125, 0.150, 1, 68, 36, 30)
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.ScatCache)	

function EXILE_M:ScatShotKill()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_SCATBOY) then 
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			local data = entity:GetData()
			entity = entity:ToNPC()
			if entity and entity:IsActiveEnemy(true) then
			if entity:IsDead() and not data.Died and not data.FriendlyPoop then
			data.Died = true
			local roll = math.random(1,19)
			if roll < 7 then
			Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, entity.Position, true)
			end
			if roll > 14 then
			poop = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, entity.Position, Vector(0,0), nil)
			poop:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
		poop:AddEntityFlags(EntityFlag.FLAG_CHARM)
		poop:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
		poop:GetData().FriendlyPoop = true
		end
		if entity.ParentNPC then
			data.Died = true
			end
			end
			end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.ScatShotKill)

function EXILE_M:onUpdateScatShot(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_SCATBOY) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_SCATHEAD)
		EXILE_M.HasScat = false
		end
	end
	if not EXILE_M.HasScat and player:HasCollectible(EXILE_M.COLLECTIBLE_SCATBOY) then
		player:AddNullCostume(EXILE_M.COSTUME_SCATHEAD)
		EXILE_M.HasScat = true
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateScatShot)

EXILE_M.CorinthDamageCount = 0
function EXILE_M:dmgCorinthCloak(player, target, dmgAmount, dmgFlag, source, dmgCountDownFrames)
	local player = Isaac.GetPlayer(0)
	local NearSpawn = Isaac.GetFreeNearPosition(player.Position, 10)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_CORINTHCLOAK) then
	EXILE_M.CorinthDamageCount = EXILE_M.CorinthDamageCount + 1
		if EXILE_M.CorinthDamageCount == 4 then
		EXILE_M.CorinthDamageCount = 0
		sound:Play(Sounds.HOLY_TWO,2,0,false,1)
		local roll = math.random(1,10)
		if roll > 6 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, player.Position, Vector(0,0), nil)
		else
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, player.Position, Vector(0,0), nil)
		
		end
		end
		

	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.dmgCorinthCloak, EntityType.ENTITY_PLAYER)





--
	
---------------------


--

local blackFade = Sprite()
blackFade:Load("gfx/crossfadeblack.anm2", false)

function EXILE_M:onRenderBlackFade()
		if not blackFade:IsFinished("Fade") then
		blackFade:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderBlackFade)

function EXILE_M:fadeUpdate(player)
	blackFade:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.fadeUpdate);

--
local storm = Sprite()
storm:Load("gfx/storm_effect.anm2", false)

function EXILE_M:onRenderStorm()
		if not storm:IsFinished("Idle") then
		storm:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		storm:RenderLayer(1, Isaac.WorldToRenderPosition(Vector(320,280),true))
		storm:RenderLayer(2, Isaac.WorldToRenderPosition(Vector(320,280),true))
		storm:RenderLayer(4, Isaac.WorldToRenderPosition(Vector(320,280),true))
		storm:RenderLayer(5, Isaac.WorldToRenderPosition(Vector(320,280),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderStorm)

function EXILE_M:stormUpdate(player)
	storm:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.stormUpdate);

---

local clockgears = Sprite()
clockgears:Load("gfx/backdrop/brasshead/moving_gears.anm2", false)

function EXILE_M:onRenderClockGears()
		if not clockgears:IsFinished("Idle") then
		clockgears:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		clockgears:RenderLayer(1, Isaac.WorldToRenderPosition(Vector(320,280),true))
		clockgears:RenderLayer(2, Isaac.WorldToRenderPosition(Vector(320,280),true))
		clockgears:RenderLayer(3, Isaac.WorldToRenderPosition(Vector(320,280),true))
		
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderClockGears)

function EXILE_M:clockgearsUpdate(player)
	clockgears:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.clockgearsUpdate);



--
local MeteorEff = Sprite()
MeteorEff:Load("gfx/meteor_effect.anm2", false)

function EXILE_M:throwHolyFrag(_)
	local player = Isaac.GetPlayer(0)
	player:RemoveCollectible(item_hhfrag)
	Isaac.Spawn(EXILE_M.HOLYGRENADE, 3030, 0, player.Position, Vector(0,0), player)
	sound:Play(SoundEffect.SOUND_FETUS_FEET,1,0,false,1)
end
	
EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.throwHolyFrag, item_hhfrag);

EXILE_M.CurseFont = Font()
EXILE_M.CurseFont:Load("font/teammeatfont10.fnt")



local ZoomLevel = 1
local TriggeredLeft = false
local TriggeredRight = false
local mouseOffset = Vector(0,40)

function EXILE_M:LectionaryUse()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	Game():Spawn(EntityType.RETICLE, 1919, player.Position, Vector(0,0), player, 0, 0):ToEffect()
	player:DischargeActiveItem()
end
	
EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.LectionaryUse, item_lectionary);

function EXILE_M:LectionaryRoomCharge(player)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(item_lectionary) then
		player:FullCharge()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.LectionaryRoomCharge)


function EXILE_M:LectionaryReticle(entity)
  local npc = entity:ToNPC()
  local game = Game()
  local data = entity:GetData()
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  local bombDmg = player.Damage * 3.3

  entity.DepthOffset = 180
  entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
  entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
  entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)


  local renderVec0 = Isaac.WorldToRenderPosition(Vector(0,0))
  local renderVec1 = Isaac.WorldToRenderPosition(Vector(1,1))
  local function RenderToWorldPosition(v)
    local r = Vector(0,0)
    r.X = (v.X - renderVec0.X)/(renderVec1.X - renderVec0.X)
    r.Y = (v.Y - renderVec0.Y)/(renderVec1.Y - renderVec0.Y)
    return r / ZoomLevel
  end

  local TopLeft = room:GetRenderSurfaceTopLeft()
  local ScrollOffset = room:GetRenderScrollOffset()

  local mousePos = Input.GetMousePosition(true)

  if not entity:GetSprite():IsPlaying("Use", true) then
    entity.Position = Vector(mousePos.X, mousePos.Y)
  end

  if not entity:GetSprite():IsPlaying("IdleActive", true) and not entity:GetSprite():IsPlaying("Use", true) then
    entity:GetSprite():Play("IdleActive", true)
  elseif Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) and not entity:GetSprite():IsPlaying("Use", true) then
    sound:Play(SoundEffect.SOUND_GOLD_HEART_DROP,2,0,false,1)
    entity:GetSprite():Play("Use", true)
  elseif entity:GetSprite():IsEventTriggered("AnimateUp") then
    player:AnimateTeleport(true)
    Game():ShakeScreen(6,6)
    --local fire = Game():Spawn(EntityType.ENTITY_EFFECT, 52, entity.Position, Vector(0,0), entity, 0, 0)
  elseif entity:GetSprite():IsEventTriggered("Down") then
    player:AnimateTeleport(false)
  elseif entity:GetSprite():IsEventTriggered("Teleport") then

    Game():BombExplosionEffects(entity.Position, bombDmg, 0, Color(4,2,7,1,3,2,1), player, 1.5, false, false)

  elseif entity:GetSprite():IsEventTriggered("TeleportPos") then
    player.Position = entity.Position
  elseif entity:GetSprite():IsEventTriggered("Charge") then
    player:FullCharge()
    entity:Remove()
  end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.LectionaryReticle, EntityType.RETICLE)

function EXILE_M:onRenderMeteor()
		if not MeteorEff:IsFinished("Idle") then
		MeteorEff:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderMeteor)

function EXILE_M:meteorRenderUpd(player)
	MeteorEff:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.meteorRenderUpd);

function EXILE_M:HolyFragUpdate(entity)
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer(0)
	local music = MusicManager()
	local npc = entity:ToNPC()
	
	local toplx = room:GetTopLeftPos().X
	local toply = room:GetTopLeftPos().Y
	local botr = room:GetBottomRightPos()
	
	if not entity:GetSprite():IsPlaying("Pulse", true) then
		entity:GetSprite():Play("Pulse", true)
	elseif entity:GetSprite():IsEventTriggered("Chant") then
		music:Fadeout()
		sound:Play(Sounds.HOLY_CHANT,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Boom") then
		for _, enemy in pairs(Isaac.FindInRadius(entity.Position, 9999, EntityPartition.ENEMY)) do
			local data = enemy:GetData()
			enemy = enemy:ToNPC()
			if enemy and
			
			enemy:IsActiveEnemy(true)
		then
		enemy:TakeDamage(99990,DamageFlag.DAMAGE_EXPLOSION,EntityRef(player),0)
		local soulroll = math.random(1,10)
		if soulroll > 7 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, enemy.Position, Vector(0,0), nil)
				end
			end
		end
		Game():ShakeScreen(50,50)
		sound:Play(SoundEffect.SOUND_SUPERHOLY,1,0,false,1)
		music:Fadein(musicid, 0.4)
		--Isaac.Explode(entity.Position, player, 100)
		local toplformula1 = Vector(toplx + 150,toply)
		local toplformula2 = Vector(toplx + 850,toply)
		local shape = room:GetRoomShape()
		Game():BombExplosionEffects(entity.Position, 2000, 0, Color(3,12,11,2,5,3,1), player, 4, false, false)

		entity:Remove()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.HolyFragUpdate, EXILE_M.HOLYGRENADE)

-----

function EXILE_M:ConveyorBeltUpdate(entity)
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer(0)
    local data = entity:GetData()



    if entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Right)") or
        entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Left)") or
        entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Up)") or
        entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Down)") then
        if room:HasWater() and not data.Changed then
            entity:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/quarantine/conveyor_bullets_ent_submerged.png")
            entity:GetSprite():LoadGraphics()
            data.Changed = true
        end
        data.Immovable = true
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    end

    if entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Right)") then
        if not sound:IsPlaying(Sounds.CONVEYORBELTS) then
            sound:Play(Sounds.CONVEYORBELTS,0.6,0,false,1)
        end
        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Poison Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(0.11,0))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end

        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Corrosive Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(0.11,0))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end

        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 27.5, EntityPartition.ENEMY))) do
            if victim:IsActiveEnemy() and not victim:GetData().Immovable == true then
                if victim.Position:Distance(entity.Position) < 27.5 then
                    victim.Position = victim.Position + Vector(4,0)
                    victim.Velocity = Vector(0,0)

                end
            end
        end

        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 30, EntityPartition.PICKUP))) do
            if victim.Type == EntityType.ENTITY_PICKUP then
                if victim.Position:Distance(entity.Position) < 30 then
                    victim:AddVelocity(Vector(0.40,0))
                    victim.Velocity = victim.Velocity:Resized(3)
                end
            end
        end

        entity.DepthOffset = -170
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL
        if not entity:GetSprite():IsPlaying("Right", true) then
            entity:GetSprite():Play("Right", true)
        end



        if player.Position:Distance(entity.Position) < 24 then
            player:AddVelocity(Vector(0.58,0))
        end
    elseif entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Left)") then

        if not sound:IsPlaying(Sounds.CONVEYORBELTS) then
            sound:Play(Sounds.CONVEYORBELTS,0.6,0,false,1)
        end
        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Poison Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(-0.11,0))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end

        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Corrosive Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(-0.11,0))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end
        entity.DepthOffset = -170
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL
        if not entity:GetSprite():IsPlaying("Left", true) then
            entity:GetSprite():Play("Left", true)
        end
        if player.Position:Distance(entity.Position) < 24 then
            player:AddVelocity(Vector(-0.58,0))
        end
        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 27.5, EntityPartition.ENEMY))) do
            if victim:IsActiveEnemy() and not victim:GetData().Immovable == true then
                if victim.Position:Distance(entity.Position) < 27.5 then
                    victim.Position = victim.Position + Vector(-4,0)
                    victim.Velocity = Vector(0,0)

                end
            end
        end

        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 30, EntityPartition.PICKUP))) do
            if victim.Type == EntityType.ENTITY_PICKUP then
                if victim.Position:Distance(entity.Position) < 30 then
                    victim:AddVelocity(Vector(-0.40,0))
                    victim.Velocity = victim.Velocity:Resized(3)
                end
            end
        end

    elseif entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Up)") then
        if not sound:IsPlaying(Sounds.CONVEYORBELTS) then
            sound:Play(Sounds.CONVEYORBELTS,0.6,0,false,1)
        end
        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Poison Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(0,-0.11))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end

        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Corrosive Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(0,-0.11))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end
        entity.DepthOffset = -170
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL
        if not entity:GetSprite():IsPlaying("Up", true) then
            entity:GetSprite():Play("Up", true)
        end
        if player.Position:Distance(entity.Position) < 24 then
            player:AddVelocity(Vector(0,-0.58))
        end
        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 27.5, EntityPartition.ENEMY))) do
            if victim:IsActiveEnemy() and not victim:GetData().Immovable == true then
                if victim.Position:Distance(entity.Position) < 27.5 then
                    victim.Position = victim.Position + Vector(0,-4)
                    victim.Velocity = Vector(0,0)

                end
            end
        end

        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 30, EntityPartition.PICKUP))) do
            if victim.Type == EntityType.ENTITY_PICKUP then
                if victim.Position:Distance(entity.Position) < 30 then
                    victim:AddVelocity(Vector(0,-0.40))
                    victim.Velocity = victim.Velocity:Resized(3)
                end
            end
        end

    elseif entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt (Down)") then

        if not sound:IsPlaying(Sounds.CONVEYORBELTS) then
            sound:Play(Sounds.CONVEYORBELTS,0.6,0,false,1)
        end
        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Poison Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(0,0.11))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end

        local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Poison Vial"), Isaac.GetEntityVariantByName("Corrosive Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(vials) do
            if tear.Position:Distance(entity.Position) < 27 and not tear:GetSprite():IsPlaying("Fall") then
                tear:AddVelocity(Vector(0,0.11))
                tear.Velocity = tear.Velocity:Resized(2)
            end
        end
        entity.DepthOffset = -170
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL
        if not entity:GetSprite():IsPlaying("Down", true) then
            entity:GetSprite():Play("Down", true)
        end
        if player.Position:Distance(entity.Position) < 24 then
            player:AddVelocity(Vector(0,0.58))
        end
        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 27.5, EntityPartition.ENEMY))) do
            if victim:IsActiveEnemy() and not victim:GetData().Immovable == true then
                if victim.Position:Distance(entity.Position) < 24 then
                    victim.Position = victim.Position + Vector(0,4)
                    victim.Velocity = Vector(0,0)

                end
            end
        end

        for _, victim in pairs((Isaac.FindInRadius(entity.Position, 30, EntityPartition.PICKUP))) do
            if victim.Type == EntityType.ENTITY_PICKUP then
                if victim.Position:Distance(entity.Position) < 30 then
                    victim:AddVelocity(Vector(0,0.40))
                    victim.Velocity = victim.Velocity:Resized(3)
                end
            end
        end

    end

    --player.Position:DistanceSquared(eff.Position) < size * size

end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ConveyorBeltUpdate, EntityType.CONVEYORBELT)


--- NEW ENEMIES


function EXILE_M:BloodBoyUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	sprite:PlayOverlay("Head", false)
		if entity:IsFrame(2, 0) then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)

			if data.GridCountdown <= 0 then
			data.GridCountdown = 30
			else
			data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Velocity = (target.Position - entity.Position):Normalized() * 0.5 * 6
			end
			local attacktime = math.random(1,360)
			if attacktime > 350 then
			entity.State = 2
			attacktime = 0
			else
			entity.State = 0
			attacktime = 0
			end
		end
	elseif entity.State == 2 then
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.2 * 2
	if not sprite:IsOverlayPlaying("Attack") then
	sprite:PlayOverlay("Attack", false)
	elseif sprite:IsOverlayPlaying("Attack") then
		if sprite:GetOverlayFrame() == 5 then
		sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.4,60,false,1)
		elseif sprite:GetOverlayFrame() == 20 then
		pos1 = entity.Position - target.Position
		Dirvect = pos1:GetAngleDegrees()
		elseif sprite:GetOverlayFrame() == 27 then
		local BloodLaser = EntityLaser.ShootAngle(1, entity.Position, Dirvect + 179,
		20, Vector(0,-40), entity)
		sound:Play(SoundEffect.SOUND_GHOST_ROAR,1.4,60,false,1)
		BloodLaser.DepthOffset = 45;
		BloodLaser.EndPoint = target.Position
		sound:Play(SoundEffect.SOUND_GHOST_SHOOT,1,60,false,1)
		
		--
		--
		
		end
	end
	if sprite:IsOverlayFinished("Attack") then
		entity.State = 0
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BloodBoyUpdate, EntityType.BLOODBOY)
--------------

function EXILE_M:ClockworkStatuesUpd(entity)
local player = Isaac.GetPlayer(0)
local sprite = entity:GetSprite()

local target = entity:GetPlayerTarget()
local data = entity:GetData()

if entity.Variant == Isaac.GetEntityVariantByName("Shooting Statue") then
    entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	if entity.State == 0 then
    if not sprite:IsPlaying("Idle") then
        sprite:Play("Idle", false)
    end
    if sprite:IsFinished("Idle") then
        local roll = math.random(1,9)
    if entity.Position:Distance(target.Position) > 105 then
        if roll > 7 then
            entity.State = 2
        else
            entity.State = 0
        sprite:Play("Idle", false)
        end
        end
        end
        elseif entity.State == 2 then
            if not sprite:IsPlaying("Shoot") then
                sprite:Play("Shoot", false)
            sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
            elseif sprite:IsEventTriggered("Shoot") then
                sound:Play(SoundEffect.SOUND_TEARS_FIRE,1,0,false,1)
            local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
            proj.Height = -40
            
            end
            end
            if sprite:IsFinished("Shoot") then
                entity.State = 0
         end
   end
end
            
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ClockworkStatuesUpd, EntityType.CLOCKSTATUE)

function EXILE_M:DecorativeStatues(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Decorative Statue") then
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", false)
	end
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("Decorative Statue 2") then
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", false)
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.DecorativeStatues, EntityType.CLOCKSTATUEDECOR)



function EXILE_M:RingalingUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Ringaling") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", true)
	end
	entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)
	if entity.Position:Distance(target.Position) < 90 then
	entity.State = 2
	end
	elseif entity.State == 2 then
	entity.Velocity = (target.Position + entity.Position):Normalized() * 0.2 * 2
	if not sprite:IsPlaying("Ring") then
	sprite:Play("Ring", true)
	sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.2,0,false,1.5)
	elseif entity:GetSprite():IsEventTriggered("Ring") then
	
	Game():ButterBeanFart(entity.Position, 90, entity, false)
		local tears = Isaac.FindByType(EntityType.ENTITY_TEAR, 0, -1, false, false)
		for _, tear in ipairs(tears) do
		if tear.Position:Distance(entity.Position) < 100 then
		tear:Die()
		--
		end
		end
		elseif entity:GetSprite():IsEventTriggered("Ring2") then
		sound:Play(Sounds.BEEDLEBELL,1.4,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Finish") then
		entity.State = 0
	end
	end
	if sprite:IsFinished("Ring") then
		entity.State = 0
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.RingalingUpdate, EntityType.RINGALING)

function EXILE_M:StatuesUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	local target = entity:GetPlayerTarget()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Fire Statue") then
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.GridCollisionClass = GridCollisionClass.COLLISION_WALL
	entity.DepthOffset = 12
	
	if data.SpawnedFires == nil then data.SpawnedFires = 0 end
	if data.SpawnedFires == 0 then

	local firedown = Isaac.Spawn(EntityType.FIRESTATUE,Isaac.GetEntityVariantByName("Fire Orbital"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown:GetData().HasParent = true
	firedown:GetData().Spawner = entity
	firedown:GetData().DistanceOut = 1
	firedown:GetData().DistanceRad = 3
	if firedown:GetData().SpawnedLight == nil then
	local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, firedown.Position, Vector(0,0), firedown)
	light:SetColor(Color(5, 3, 0, 1, 0, 0, 0),0,1,false,false)
	light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light:GetSprite():LoadGraphics()
	light:GetData().lightSpawnerEntity = firedown
	light:GetData().CustomLight = true
	light:GetData().SpriteScale = Vector(0.55,0.55)
	firedown:GetData().SpawnedLight = 1
	end

	local firedown2 = Isaac.Spawn(EntityType.FIRESTATUE,Isaac.GetEntityVariantByName("Fire Orbital"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown2:GetData().HasParent = true
	firedown2:GetData().Spawner = entity
	firedown2:GetData().DistanceOut = 2
	firedown2:GetData().DistanceRad = 3
	if firedown2:GetData().SpawnedLight == nil then
	local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, firedown2.Position, Vector(0,0), firedown2)
	light:SetColor(Color(5, 3, 0, 1, 0, 0, 0),0,1,false,false)
	light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light:GetSprite():LoadGraphics()
	light:GetData().lightSpawnerEntity = firedown2
	light:GetData().CustomLight = true
	light:GetData().SpriteScale = Vector(0.55,0.55)
	firedown2:GetData().SpawnedLight = 1
	end

	local firedown3 = Isaac.Spawn(EntityType.FIRESTATUE,Isaac.GetEntityVariantByName("Fire Orbital"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown3:GetData().HasParent = true
	firedown3:GetData().Spawner = entity
	firedown3:GetData().DistanceOut = 3
	firedown3:GetData().DistanceRad = 3
	if firedown3:GetData().SpawnedLight == nil then
	local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, firedown3.Position, Vector(0,0), firedown3)
	light:SetColor(Color(5, 3, 0, 1, 0, 0, 0),0,1,false,false)
	light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light:GetSprite():LoadGraphics()
	light:GetData().lightSpawnerEntity = firedown3
	light:GetData().CustomLight = true
	light:GetData().SpriteScale = Vector(0.55,0.55)
	firedown3:GetData().SpawnedLight = 1
	end
	
	data.SpawnedFires = 1
	end
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("Fire Orbital") then
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", true)
	end
	end
	if entity.Variant == Isaac.GetEntityVariantByName("Fire Statue") then
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", true)
	end
	Game():Darken(1,2)
	end
	
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.StatuesUpdate, EntityType.FIRESTATUE)

function EXILE_M:FireStatueOrbits(f)
	if f:GetData().HasParent == true then
    if f:GetData().Degrees == nil then f:GetData().Degrees = 0 end
    if f:GetData().Radius == nil then f:GetData().Radius = 0 end
    f:GetData().Degrees = f:GetData().Degrees + f:GetData().DistanceRad
    f:GetData().Radius = 40 * f:GetData().DistanceOut
    if f:GetData().Degrees >= 360 then f:GetData().Degrees = 0 end
    if f:GetData().Degrees <= -360 then f:GetData().Degrees = 0 end
    for i = 0, Isaac.CountEntities(entity, EntityType.FIRESTATUE, Isaac.GetEntityVariantByName("Fire Orbital"), -1) do
        local spawner = f:GetData().Spawner
        local direction = Vector.FromAngle(f:GetData().Degrees):Normalized()
        f:GetData().NewPos = spawner.Position + direction * f:GetData().Radius
        f.Velocity = -(f.Position - f:GetData().NewPos)/4
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.FireStatueOrbits, EntityType.FIRESTATUE);

function EXILE_M:CombustihorfUpdate(entity)
if entity.Variant == Isaac.GetEntityVariantByName("Combustihorf") then
   local player = Isaac.GetPlayer(0)
local sprite = entity:GetSprite()
local diagonals = {
   Vector(1, 1):Normalized(),
   Vector(-1, 1):Normalized(),
   Vector(1, -1):Normalized(),
   Vector(-1, -1):Normalized()
}

local target = entity:GetPlayerTarget()
local data = entity:GetData()

Game():Darken(1.1, 3)

if entity.Variant == Isaac.GetEntityVariantByName("Combustihorf") then
   if data.GridCountdown == nil then data.GridCountdown = 0 end
      if data.SpawnedLight == nil then data.SpawnedLight = 0 end
         
      if entity.State == 0 then
         local vel = entity.Velocity:Normalized()
      local closestDir
      local dist
      for _, direction in ipairs(diagonals) do
         local distance = vel:Distance(direction)
      if not dist or distance < dist then
         closestDir = direction
      dist = distance
      end
      end
      
      entity.Velocity = closestDir:Resized(4)
      if not sprite:IsPlaying("Idle") then
         sprite:Play("Idle", true)
      if entity:GetData().SpawnedLight == 0 then
         local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, entity.Position, Vector(0,0), entity)
		light:SetColor(Color(10, 0, 50, 1, 6, 0, 0),0,1,false,false)
		light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
		light:GetSprite():LoadGraphics()
		light:GetData().lightSpawnerEntity = entity
		light:GetData().CustomLight = true
		light:GetData().SpriteScale = Vector(1.04,1.04)
		entity:GetData().SpawnedLight = 1
      end
      end
      if entity.Position:Distance(target.Position) < 133 then
         entity.State = 2
      end
      elseif entity.State == 2 then
         if not sprite:IsPlaying("Fire") then
            sprite:Play("Fire", true)
         elseif entity:GetSprite():IsEventTriggered("Fire") then
            sound:Play(SoundEffect.SOUND_FIRE_RUSH,1.2,0,false,1)
         local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 8,entity):ToProjectile()
         elseif entity:GetSprite():IsEventTriggered("Finish") then
            entity.State = 0
         end
         end
         if sprite:IsFinished("Fire") then
            entity.State = 0
         end
      end
   end
end
         
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.CombustihorfUpdate, EntityType.COMBUSTIHORF)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
    local lights = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS, 4, false, false)
    for _, light in ipairs(lights) do
		local room = Game():GetRoom()
        local sprite = light:GetSprite()
		local data = light:GetData()
		if data.CustomLight == true then
		light.Position = data.lightSpawnerEntity.Position
		if data.lightSpawnerEntity:IsDead() then
		
		else
		light.SpriteScale = data.SpriteScale
		end
		end
    end
end)



EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
    local lights = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS, 4, false, false)
    for _, light in ipairs(lights) do
		local room = Game():GetRoom()
        local sprite = light:GetSprite()
		local data = light:GetData()
		if data.CustomLightDecor == true then
		light.Position = data.LightPosition
		light.SpriteScale = data.SpriteScale
		end
    end
end)


function EXILE_M:FountUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	sprite:PlayOverlay("Head", false)
		if entity:IsFrame(5, 0) then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)

			if data.GridCountdown <= 0 then
			data.GridCountdown = 30
			else
			data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Pathfinder:FindGridPath(target.Position, 0.55, 1, true)
			end
			local attacktime = math.random(1,400)
			if attacktime > 385 then
			entity.State = 2
			attacktime = 0
			else
			entity.State = 0
			attacktime = 0
			end
		end
	elseif entity.State == 2 then
	entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)
	if not sprite:IsOverlayPlaying("Attack") and not sprite:IsOverlayPlaying("Charge") then
	sprite:PlayOverlay("Charge", false)
	elseif sprite:IsOverlayPlaying("Charge") then
		if sprite:GetOverlayFrame() == 27 then
		sprite:PlayOverlay("Attack", false)
		elseif sprite:GetOverlayFrame() == 2 then
		sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.4,60,false,1)
		end
	elseif sprite:IsOverlayPlaying("Attack") then
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(entity.Position, 8)):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(7, 9)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/7) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -30
			Projectile.DepthOffset = 20
		if sprite:GetOverlayFrame() == 1 then
		elseif sprite:GetOverlayFrame() == 5 then
		sound:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,1.4,60,false,1)
		elseif sprite:GetOverlayFrame() == 39 then
		entity.State = 0
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.FountUpdate, EntityType.FOUNT)


function EXILE_M:RammerUpdate(entity)
if entity.Variant == Isaac.GetEntityVariantByName("Rammer") or entity.Variant == Isaac.GetEntityVariantByName("Black Rammer") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	
		entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	data.Immovable = true
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if data.Rolling == nil then data.Rolling = 0 end
	
	if data.Stunned == nil then data.Stunned = 0 end
	
	if entity.State == 0 then
	sprite:PlayOverlay("Head", false)
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	data.Rolling = 0
	data.Stunned = 0
		if entity:IsFrame(2, 0) then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, 0.65, 1, true)

			if data.GridCountdown <= 0 then
			data.GridCountdown = 30
			else
			data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Pathfinder:FindGridPath(target.Position, 0.65, 1, true)
			end
			local attacktime = math.random(1,360)
			if attacktime > 350 and entity.Pathfinder:HasPathToPos(target.Position, false) then
			entity.State = 2
			attacktime = 0
			else
			entity.State = 0
			attacktime = 0
			end
		end
	elseif entity.State == 2 then
	if not sprite:IsPlaying("StartRoll", false) and not sprite:IsPlaying("Return", false) and not sprite:IsPlaying("Rolling", false) and data.Rolling == 0 and data.Stunned == 0 then
	entity.Velocity = Vector(0,0)
	entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
	sprite:Play("StartRoll", false)
	sound:Play(SoundEffect.SOUND_MONSTER_ROAR_2,1.5,0,false,1)
	sprite:RemoveOverlay()
	data.Rolling = 1
	data.Stunned = 0
	end

	if sprite:IsFinished("StartRoll", false) and data.Stunned == 0 then
	sprite:Play("Rolling", false)
	end
	if sprite:IsPlaying("Rolling", false) then
	if entity:GetSprite():IsEventTriggered("Crack") then
	local rock = Game():Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ROCK_EXPLOSION, entity.Position, Vector(0,0), player, 0, 0)
	sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
	end
	if entity:CollidesWithGrid() then
	entity.Velocity = Vector(0,0)
	Game():ShakeScreen(11,11)
	sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1.5,0,false,1)

	--Game():BombDamage(entity.Position, 100, 21, false, entity, 0, 0, false)
	if entity.Variant == Isaac.GetEntityVariantByName("Rammer") then
	for i = 1, 9 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(entity.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -25
			Projectile.DepthOffset = 20
	end
	end
	if entity.Variant == Isaac.GetEntityVariantByName("Black Rammer") then
	Isaac.Explode(entity.Position, entity, 20)
	entity:Die()
	end
	sprite:Play("Stunned", false)
	data.Stunned = 1
	end
	entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
		if sprite:GetFrame() == 6 then
		Game():ShakeScreen(6,6)
		sound:Play(Sounds.BUZZSAW,1.5,0,false,1)
		entity:AddVelocity((target.Position - entity.Position):Normalized() * 17)
		end
	end
	if sprite:IsPlaying("Stunned", false) then
	entity.Velocity = Vector(0,0)
	end
	if sprite:IsFinished("Rolling", false) and data.Stunned == 0 then
	entity.Velocity = Vector(0,0)
	sprite:Play("Return", false)
		
		end
	end
	if sprite:IsFinished("Return", false) then
		entity.State = 0
	end
	if sprite:IsFinished("Stunned", false) then
		entity.State = 0
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.RammerUpdate, EntityType.RAMMER)


-----

local timeback = Sprite()
timeback:Load("gfx/giantbook_timeback.anm2", false)

function EXILE_M:onRenderTimeback()
		if not timeback:IsFinished("Effect") then
		timeback:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		timeback:RenderLayer(1, Isaac.WorldToRenderPosition(Vector(320,280),true))
		timeback:RenderLayer(2, Isaac.WorldToRenderPosition(Vector(320,280),true))
		timeback:RenderLayer(3, Isaac.WorldToRenderPosition(Vector(320,280),true))
		timeback:RenderLayer(4, Isaac.WorldToRenderPosition(Vector(320,280),true))
		timeback:RenderLayer(5, Isaac.WorldToRenderPosition(Vector(320,280),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderTimeback)

function EXILE_M:timeUpdate(player)
	timeback:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.timeUpdate);

function EXILE_M:SploderUpdate(entity)
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local npc = entity:ToNPC()

	if entity:GetSprite():IsEventTriggered("EndIdle") then
	local roll = math.random(1,15)
	if roll > 12 then
	entity.Friction = 0
	entity:GetSprite():Play("Spit", true)
	end
	end
	
	
	if entity:IsDead() then
	game:Fart(entity.Position, 2, entity, 1, 1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	end
	
	if entity:GetSprite():IsEventTriggered("DiagShoot") then
	local roll = math.random(1,20)
	if roll > 16 then
   -- local throwspider = EntityNPC.ThrowSpider(entity.Position, entity, Vector(entity.Position.X - 60 + entity:GetDropRNG():RandomInt(121), entity.Position.Y - 60 + entity:GetDropRNG():RandomInt(121)), false, 0.0)
	Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
	Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
	Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
	Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	end
	end


	if not entity:GetSprite():IsPlaying("Idle", true) and not entity:GetSprite():IsPlaying("Walk", true) and not entity:GetSprite():IsPlaying("Spit", true) then
	entity:GetSprite():Play("Walk", true)
	elseif entity:GetSprite():IsPlaying("Walk", true) and not entity:GetSprite():IsPlaying("Spit", true) then
	entity.Friction = 1
	entity.Pathfinder:EvadeTarget(target.Position)
	entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)
	elseif entity:GetSprite():IsEventTriggered("Spit") then
	sound:Play(SoundEffect.SOUND_WORM_SPIT,1.5,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.SploderUpdate, EntityType.SPLODER)


------




EXILE_M.Fatevel = 4.2

FateState = {
	APPEAR = 0,
	IDLE = 1,
	THROW = 2,
	SHOOT = 3,
	METEOR = 4,
	CROSSBRIM = 5,
	BRIMSTONE = 6,
	DARKNESS = 7
}

FateChain = {
	[FateState.IDLE] =		{0.6, 0.05, 0.05, 0.05, 0.05, 0.2, 0},
	[FateState.THROW] = 	{0.1, 0.2, 0.2, 0.1, 0.1, 0, 0},	
	[FateState.SHOOT] =  	{0.2, 0.1, 0.1, 0, 0.3, 0, 0.3},	
	[FateState.METEOR] = 	{0.3, 0.2, 0.5, 0, 0, 0, 0},
	[FateState.CROSSBRIM] = {0.4, 0.2, 0.2, 0.1, 0, 0, 0.1},
	[FateState.BRIMSTONE] = {0.3, 0.1, 0.1, 0.3, 0.1, 0.05, 0.05},
	[FateState.DARKNESS] = 	{0.4, 0.2, 0.2, 0.05, 0.05, 0.1, 0}		
}

function FateTransition(state)
	local roll1 = math.random()
	for i = 1, #FateChain do
		roll1 = roll1 - FateChain[state][i]
		if roll1 <= 0 then
			return i
		end
	end
	return #FateChain
end




----

BouldergState = {
	APPEAR = 0,
	IDLE = 1,
	DASH = 2,
	SPIDERS = 3,
	SHOOT = 4,
	BOULDER = 5,
	BOULDERIDLE = 6,
	BOULDERTHROW = 7,
	BOULDERTOIDLE = 8,
	STUNSTART = 9,
	STUNNED = 10,
	STUNFINISH = 11,
	BOUNCING = 12,
	LASERSTART = 13,
	LASERLOOP = 14,
	LASEREND = 15,
	SPINSTART = 16,
	SPINLOOP = 17,
	SPINEND = 18
}

BouldergChain = {
	[BouldergState.IDLE] =	{0.25, 0.15, 0.1, 0.2, 0, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0, 0, 0.1, 0, 0},
	[BouldergState.DASH] =	{0.5, 0.5, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.SPIDERS] =	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.SHOOT] =	{0.8, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.BOULDER] =	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.BOULDERIDLE] =	{0, 0, 0, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.BOULDERTHROW] =	{0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.BOULDERTOIDLE] =	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.STUNSTART] =	{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.STUNNED] =	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0},
	[BouldergState.STUNFINISH] =	{0.6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.4, 0, 0, 0, 0, 0},
	[BouldergState.BOUNCING] =	{0.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.4, 0, 0, 0.2, 0, 0},
	[BouldergState.LASERSTART] =	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
	[BouldergState.LASERLOOP] =	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
	[BouldergState.LASEREND] =	{0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0},
	[BouldergState.SPINSTART] =	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
	[BouldergState.SPINLOOP] =	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.7, 0.3},
	[BouldergState.SPINEND] =	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}	

function BouldergTransition(state)
	local roll = math.random()
	for i = 1, #BouldergChain do
		roll = roll - BouldergChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #BouldergChain
end

----

function EXILE_M:BouldergeistUpdate(entity)
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	entity.DepthOffset = 45;
	
	if data.State == nil then
	data.State = 0
	data.CurrentVel = 0 
	data.StateFrame = 0
	end
	if data.TimesAttacked == nil then data.TimesAttacked = 0 end
	if data.TimesSpun == nil then data.TimesSpun = 0 end
	
	if data.SlipperinessMultiplier == nil then 
	data.SlipperinessMultiplier = 0.85 
	data.SpeedMultiplier = 0.95 
	end

	if data.SlipperinessMultiplier2 == nil then 
	data.SlipperinessMultiplier2 = 0.95 
	data.SpeedMultiplier2 = 1 
	end
	
	local target = entity:GetPlayerTarget()
	local damageformula = entity.MaxHitPoints / 4
	
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1
	
	if EXILE_M.BellRung == true then
	EXILE_M.BellRung = false
	entity:TakeDamage(damageformula,DamageFlag.DAMAGE_EXPLOSION,EntityRef(player),0)
	data.State = BouldergState.STUNSTART
	data.StateFrame = 0
	end
	
	
	if data.State == BouldergState.APPEAR and entity:GetSprite():IsFinished("Appear") then
	data.CurrentVel = 3.3
		local roomc = game:GetRoom()
		data.State = BouldergState.IDLE
		data.TimesAttacked = 0
		data.StateFrame = 0
	elseif data.State == BouldergState.IDLE then ----------------------------------
	entity:GetSprite().FlipX = (entity.Position.X < target.Position.X)
		entity.Velocity = entity.Velocity * data.SlipperinessMultiplier + (target.Position-entity.Position):Resized(data.SpeedMultiplier)
		if data.StateFrame == 1 then
		EXILE_M.BellRung = false
			entity:GetSprite():Play("Idle", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 4
		elseif entity:GetSprite():IsFinished("Idle") then
			if data.TimesAttacked > 5 then
			data.State = BouldergState.BOULDER
			data.StateFrame = 0
			else
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
			end
		end
	elseif data.State == BouldergState.DASH then -------------------------------------
		if data.StateFrame == 1 then
		EXILE_M.BellRung = false
		data.TimesAttacked = data.TimesAttacked + 1
			entity:GetSprite():Play("Dash", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
	elseif entity:GetSprite():IsEventTriggered("Dash") then
	sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1)
	entity:GetSprite().FlipX = (entity.Position.X < target.Position.X)
	entity.Velocity = (target.Position - entity.Position):Normalized() * 16.5
	
				local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(4,4),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-4,4),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(4,-4),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-4,-4),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,6),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-6),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(6,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-6,0),entity):ToProjectile()
			
			tear1.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear1.Scale = 1
			tear1.Height = -33
			tear1.FallingAccel = -0.085
			tear2.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear2.Scale = 1
			tear2.Height = -33
			tear2.FallingAccel = -0.085
			tear3.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear3.Scale = 1
			tear3.Height = -33
			tear3.FallingAccel = -0.085
			tear4.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear4.Scale = 1
			tear4.Height = -33
			tear4.FallingAccel = -0.085
			
			tear5.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear5.Scale = 1
			tear5.Height = -33
			tear5.FallingAccel = -0.085
			tear6.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear6.Scale = 1
			tear6.Height = -33
			tear6.FallingAccel = -0.085
			tear7.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear7.Scale = 1
			tear7.Height = -33
			tear7.FallingAccel = -0.085
			tear8.ProjectileFlags = ProjectileFlags.TRIANGLE
			tear8.Scale = 1
			tear8.Height = -33
			tear8.FallingAccel = -0.085
	
	
	elseif entity:GetSprite():IsEventTriggered("StopDash") then
	entity.Velocity = Vector(0,0)
	elseif entity:GetSprite():IsFinished("Dash") then
	data.State = BouldergTransition(data.State)
	entity.Velocity = Vector(0,0)
	data.StateFrame = 0
		end
	elseif data.State == BouldergState.SPINSTART then ---------------------------------------
		entity.Velocity = Vector(0,0)
		if data.StateFrame == 1 then
		entity:PlaySound(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
		data.TimesAttacked = data.TimesAttacked + 1
		data.TimesSpun = 0
			entity:GetSprite():Play("SpinStart", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsFinished("SpinStart") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.SPINLOOP then ---------------------------------------
	entity.Velocity = entity.Velocity * data.SlipperinessMultiplier2 + (target.Position-entity.Position):Resized(data.SpeedMultiplier2)
		data.CurrentVel = 1
		
		if entity:IsFrame(9,0) then
		entity:PlaySound(SoundEffect.SOUND_SHELLGAME,1.05,0,false,0.42)
		end
		
		if data.StateFrame == 1 then
			data.TimesSpun = data.TimesSpun + 1
			entity:GetSprite():Play("SpinLoop", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsFinished("SpinLoop") then
			if data.TimesSpun > 6 then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
			else
			data.State = BouldergState.SPINLOOP
			data.StateFrame = 0
			end
		end
	elseif data.State == BouldergState.SPINEND then ---------------------------------------
		entity.Velocity = Vector(0,0)
		if data.StateFrame == 1 then
			entity:GetSprite():Play("SpinEnd", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():GetFrame() == 20 then
		entity:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0,1.15,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Smash1") then
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)

			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
			
			tear1:GetData().StoneProj = true
			tear2:GetData().StoneProj = true
			tear3:GetData().StoneProj = true
			tear4:GetData().StoneProj = true
			
			tear5:GetData().StoneProj = true
			tear6:GetData().StoneProj = true
			tear7:GetData().StoneProj = true
			tear8:GetData().StoneProj = true
			
			
		tear1:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear1:GetSprite():LoadGraphics()
		tear2:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear2:GetSprite():LoadGraphics()
		tear3:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear3:GetSprite():LoadGraphics()
		tear4:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear4:GetSprite():LoadGraphics()
		
		tear5:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear5:GetSprite():LoadGraphics()
		tear6:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear6:GetSprite():LoadGraphics()
		tear7:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear7:GetSprite():LoadGraphics()
		tear8:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear8:GetSprite():LoadGraphics()
	
	
	entity:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,0.75,0,false,1.1)
	Game():ShakeScreen(12,12)
		elseif entity:GetSprite():IsFinished("SpinEnd") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.SPIDERS then ---------------------------------------
		if data.StateFrame == 1 then
		data.TimesAttacked = data.TimesAttacked + 1
			entity:GetSprite():Play("Spiders", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("Spiders") then
		sound:Play(SoundEffect.SOUND_SKIN_PULL,1,0,false,1)
		for i = 1, 4 do
		local throwspider = EntityNPC.ThrowSpider(entity.Position, entity, Vector(entity.Position.X - 60 + entity:GetDropRNG():RandomInt(121), entity.Position.Y - 60 + entity:GetDropRNG():RandomInt(121)), false, 0.0)
		end
		elseif entity:GetSprite():IsFinished("Spiders") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.SHOOT then ---------------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
	data.TimesAttacked = data.TimesAttacked + 1
		data.CurrentVel = 1
		entity:GetSprite():Play("Shoot", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
	sound:Play(SoundEffect.SOUND_SKIN_PULL,1,0,false,1)
		for i = 1, 5 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -(math.random(70, 80)/10) 
			Projectile.Scale = (math.random(100,150))/100
			Projectile.FallingAccel = (math.random(4, 7)/12)
			Projectile.Height = -30
			Projectile.DepthOffset = 43
			--Projectile:GetData().RockProj = true
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 1
		end
	elseif entity:GetSprite():IsFinished("Shoot") then
			data.State = BouldergTransition(data.State)
			data.CurrentVel = 3.3
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.BOULDER then ---------------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		data.TimesAttacked = 0
		entity:GetSprite():Play("Summon Boulder", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	elseif entity:GetSprite():IsEventTriggered("Bells") then
		EXILE_M.BellsDown = true
		EXILE_M.BellsReturn = false
	elseif entity:GetSprite():IsFinished("Summon Boulder") then
			data.State = BouldergTransition(data.State)
			data.CurrentVel = 3.3
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.BOULDERIDLE then ----------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Boulder Idle", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 2
		if entity:IsFrame(5,0) then
		local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,Isaac.GetRandomPosition(18),Vector(0,0),entity):ToProjectile()
		tear1:GetData().StoneProj = true
		tear1.CollisionDamage = 0.1
		tear1.Scale = math.random(2,3)
		tear1.Height = -300
		tear1.FallingSpeed = 2.25
		tear1.FallingAccel = 1.55
		tear1:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear1:GetSprite():LoadGraphics()
		tear1:Update()
		end
			
		elseif entity:GetSprite():IsFinished("Boulder Idle") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.BOULDERTHROW then ----------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		entity:GetSprite().FlipX = (entity.Position.X < target.Position.X)
			entity:GetSprite():Play("Boulder Throw", true)
			sound:Play(SoundEffect.SOUND_FRAIL_CHARGE,1,0,false,1.4)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("Boulder") then
		sound:Play(SoundEffect.SOUND_SHELLGAME,1,0,false,0.6)
		local boulder = Isaac.Spawn(EntityType.BOULDERGBOULDER, 0, 0, entity.Position, (target.Position - entity.Position):Normalized() * 13, entity)
		boulder.DepthOffset = 30
		boulder:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		elseif entity:GetSprite():IsFinished("Boulder Throw") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.BOULDERTOIDLE then ----------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Boulder To Idle", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsFinished("Boulder To Idle") then
			EXILE_M.BellsDown = false
			EXILE_M.BellsReturn = true
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.STUNSTART then ----------------------------------
		entity.Velocity = Vector(0,0)
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Stun Animation", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsFinished("Stun Animation") then
		sound:Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1)
			for i = 1, 3 do
			Isaac.Spawn(EntityType.CLOCKWORKCRANE, Isaac.GetEntityVariantByName("Clockwork Crane"), 0, Isaac.GetRandomPosition(), Vector(0,0), nil)
			end
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.STUNNED then ----------------------------------
	entity.Velocity = Vector(0,0)
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Stunned", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
		elseif entity:GetSprite():IsFinished("Stunned") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.STUNFINISH then ----------------------------------
		if data.StateFrame == 1 then
			sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
			entity:GetSprite():Play("Stun Finish", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsFinished("Stun Finish") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.LASERSTART then ----------------------------------
	entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
			if entity.Position:Distance(room:GetTopLeftPos() + Vector(0,-40)) < 210 then
			Isaac.ConsoleOutput("Success! Laser")
			entity.Velocity = Vector(0,0)
			sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
			entity:GetSprite():Play("LaserStart", true)
			data.CurrentVel = 0
			else
			Isaac.ConsoleOutput("Nope Laser")
			data.State = BouldergState.SHOOT
			data.StateFrame = 0
		end
		elseif entity:GetSprite():GetFrame() < 29 then
		entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():GetFrame() == 31 then
		entity:AddVelocity(Vector(8,0))
		local BloodLaser = EntityLaser.ShootAngle(1, entity.Position, 180,
		80, Vector(0,-40), entity)
		sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
		sound:Play(SoundEffect.SOUND_MULTI_SCREAM,1,0,false,1)
		BloodLaser.DepthOffset = 133;
		BloodLaser:GetData().BouldergLaser = true
		elseif entity:GetSprite():IsFinished("LaserStart") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.LASERLOOP then ----------------------------------
		entity:AddVelocity(Vector(2.5,0))
		if not entity.Velocity == Vector(22,0) then
		entity.Velocity = entity.Velocity * 1.05
		entity.Velocity = entity.Velocity:Resized(13)
		end
		entity:GetSprite().FlipX = false
		if entity:CollidesWithGrid() then
			Game():ShakeScreen(14,14)
			data.State = BouldergState.LASEREND
			data.StateFrame = 0
		end
		if data.StateFrame == 1 then
			entity:GetSprite():Play("LaserLoop", true)
		elseif entity:GetSprite():IsFinished("LaserLoop") and not entity:CollidesWithGrid() then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.LASEREND then ----------------------------------
	entity.Velocity = Vector(0,0)
		local vials = Isaac.FindByType(EntityType.ENTITY_LASER, -1, -1, true, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		if tear:GetData().BouldergLaser == true then
		tear:Remove()
		end
		end
		
		if data.StateFrame == 1 then
			entity:GetSprite():Play("LaserWall", true)
		elseif entity:GetSprite():IsEventTriggered("Hurt") then
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.25,0,false,1)

			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
			
			tear1:GetData().StoneProj = true
			tear2:GetData().StoneProj = true
			tear3:GetData().StoneProj = true
			tear4:GetData().StoneProj = true
			
			tear5:GetData().StoneProj = true
			tear6:GetData().StoneProj = true
			tear7:GetData().StoneProj = true
			tear8:GetData().StoneProj = true
			
			
		tear1:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear1:GetSprite():LoadGraphics()
		tear2:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear2:GetSprite():LoadGraphics()
		tear3:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear3:GetSprite():LoadGraphics()
		tear4:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear4:GetSprite():LoadGraphics()
		
		tear5:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear5:GetSprite():LoadGraphics()
		tear6:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear6:GetSprite():LoadGraphics()
		tear7:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear7:GetSprite():LoadGraphics()
		tear8:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear8:GetSprite():LoadGraphics()
	
	
	entity:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,1.2,0,false,1.1)

		Game():ShakeScreen(13,13)
		elseif entity:GetSprite():IsEventTriggered("Move") then
		sound:Play(SoundEffect.SOUND_GOOATTACH0,1.2,0,false,1)
		elseif entity:GetSprite():GetFrame() > 7 and entity:GetSprite():GetFrame() < 32 then
		if entity:IsFrame(4,0) then
		local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,Isaac.GetRandomPosition(18),Vector(0,0),entity):ToProjectile()
		tear1:GetData().StoneProj = true
		tear1.CollisionDamage = 0.1
		tear1.Scale = math.random(2,3)
		tear1.Height = -325
		tear1.FallingSpeed = 2.32
		tear1.FallingAccel = 1.65
		tear1:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear1:GetSprite():LoadGraphics()
		tear1:Update()
		end
		elseif entity:GetSprite():GetFrame() == 49 then
		sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1.2,0,false,1)
		elseif entity:GetSprite():IsFinished("LaserWall") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == BouldergState.BOUNCING then ----------------------------------
		if data.StateFrame == 1 then
		data.TimesAttacked = data.TimesAttacked + 1
			entity:GetSprite():Play("Bouncing", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("Move") then
		entity.Velocity = Vector(0,0)
		sound:Play(Sounds.HAZELLAUGH,1,0,false,1)
		entity.Velocity = ((-(entity.Position - target.Position):Resized(6)):Rotated(math.random(-10,10)) * (math.random(60, 140) / 100))
		elseif entity:GetSprite():IsEventTriggered("Smash1") then
		entity.Velocity = Vector(0,0)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		Game():ShakeScreen(7,7)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
		elseif entity:GetSprite():IsEventTriggered("Smash2") then
		entity.Velocity = Vector(0,0)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		Game():ShakeScreen(7,7)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

		elseif entity:GetSprite():IsEventTriggered("Smash3") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		entity.Velocity = Vector(0,0)
		Game():ShakeScreen(12,12)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.4,0,false,1)
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1.25,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
		Game():Spawn(EntityType.ENTITY_EFFECT, 61, entity.Position, Vector(0,0), entity, 0, 0)
		elseif entity:GetSprite():GetFrame() > 69 and entity:GetSprite():GetFrame() < 94 then
		if entity:IsFrame(3,0) then
		local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,Isaac.GetRandomPosition(18),Vector(0,0),entity):ToProjectile()
		tear1:GetData().StoneProj = true
		tear1.CollisionDamage = 1
		tear1.Scale = 2
		tear1.Height = -320
		tear1.FallingSpeed = 2.3
		tear1.FallingAccel = 1.65
		tear1:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear1:GetSprite():LoadGraphics()
		end
		elseif entity:GetSprite():IsFinished("Bouncing") then
			data.State = BouldergTransition(data.State)
			data.StateFrame = 0
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BouldergeistUpdate, EntityType.BOULDERGEIST);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local boulderg = Isaac.FindByType(EntityType.BOULDERGEIST, 0, -1, false, false)
    for _, boss in ipairs(boulderg) do
        local sprite = boss:GetSprite()
        if sprite:IsPlaying("Death") then
		boss:GetSprite().FlipX = false
            local npc = boss:ToNPC()
			if sprite:IsEventTriggered("Hurt") then
			sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1.2,0,false,1)
			end
			if sprite:IsEventTriggered("BoulderFall") then
			sound:Play(Sounds.FALLINGWHISTLE,1,0,false,1)
			end
			if sprite:IsEventTriggered("Laugh") then
			sound:Play(Sounds.HAZELLAUGH,1.6,0,false,1)
			end
			if sprite:IsEventTriggered("Explode") then
			sound:Stop(Sounds.FALLINGWHISTLE)
			sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.35,0,false,1)
			sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1.2,0,false,0.6)
			--sound:Play(Sounds.SMUSH,1.25,0,false,0.7)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(7,7),boss)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(-7,7),boss)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(7,-7),boss)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(-7,-7),boss)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(0,9),boss)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(0,-9),boss)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(9,0),boss)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,boss.Position + Vector(0,0) ,Vector(-9,0),boss)
			boss:BloodExplode()
			
			Game():ShakeScreen(16)
            end
			if sprite:IsEventTriggered("Rock") then
			Isaac.Spawn(EntityType.BOULDERCORPSE,0,0,boss.Position,Vector(0,0),boss)
			end
        end
    end
end)

function EXILE_M:BouldergeistCorpse(entity)
local player = Isaac.GetPlayer(0)
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BouldergeistCorpse, EntityType.BOULDERCORPSE);

SimonState = {
	APPEAR = 0, ---------
	IDLE = 1,
	SPIT = 2,
	EYELASERS = 3,
	SPITOIL = 4,
	HURT = 5,
	CRANES = 6,
	BIGBRIM = 7
}

SimonChain = {
	[SimonState.IDLE] =			{0.7, 0.1, 0.05, 0.05, 0, 0.05, 0.05},
	[SimonState.SPIT] =			{1, 0, 0, 0, 0, 0, 0},
	[SimonState.EYELASERS] =	{1, 0, 0, 0, 0, 0, 0},
	[SimonState.SPITOIL] =		{1, 0, 0, 0, 0, 0, 0},
	[SimonState.HURT] =			{1, 0, 0, 0, 0, 0, 0},
	[SimonState.CRANES] =		{1, 0, 0, 0, 0, 0, 0},
	[SimonState.BIGBRIM] =		{1, 0, 0, 0, 0, 0, 0},
}	

function SimonTransition(state)
	local roll = math.random()
	for i = 1, #SimonChain do
		roll = roll - SimonChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #SimonChain
end

SimonSegState = {
	APPEAR = 0, ---------
	IDLE = 1,
	RAISE = 2,
	IDLERAISED = 3,
	LOWER = 4,
	TEARS = 5,
	LASER = 6
}

SimonSegChain = {
	[SimonSegState.IDLE] =			{0.7, 0.3, 0.0, 0.0, 0.0, 0.0},
	[SimonSegState.RAISE] =			{0.0, 0.0, 0.6, 0.0, 0.2, 0.2},
	[SimonSegState.IDLERAISED] =	{0.0, 0.0, 0.75, 0.1, 0.1, 0.05},
	[SimonSegState.LOWER] =			{1, 0.0, 0.0, 0.0, 0.0, 0.0},
	[SimonSegState.TEARS] =			{0.0, 0.0, 0.8, 0.0, 0.2, 0.0},
	[SimonSegState.LASER] =			{0.0, 0.0, 1, 0.0, 0.0, 0.0}
}	

function SimonSegTransition(state)
	local roll = math.random()
	for i = 1, #SimonSegChain do
		roll = roll - SimonSegChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #SimonSegChain
end

----

function EXILE_M:SimonBossUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	local room = Game():GetRoom()
	
	if entity.Variant == Isaac.GetEntityVariantByName("SIMON") then --- check for var
	entity.DepthOffset = 5;
	local damageformula = entity.MaxHitPoints / 5
	
	--entity.Position = Vector(320,158)
	
	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	local target = entity:GetPlayerTarget()
	
	if EXILE_M.SimonStunned == true then
	EXILE_M.SimonStunned = false
	sound:Play(Sounds.LABOSSHIT,2,0,false,1)
	entity:TakeDamage(damageformula,DamageFlag.DAMAGE_EXPLOSION,EntityRef(player),0)
	data.State = SimonState.HURT
	data.StateFrame = 0
	end
	
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)
	
	data.StateFrame = data.StateFrame + 1 
	
	if data.State == SimonState.APPEAR and entity:GetSprite():IsFinished("Appear") then
		data.State = SimonState.IDLE
		data.StateFrame = 0
	elseif data.State == SimonState.IDLE then --------------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Idle", true)
		elseif entity:GetSprite():IsFinished("Idle") then
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
			
		end
	elseif data.State == SimonState.SPIT then
	-----
	local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		if data.State == SimonSegState.IDLE then
		data.State = SimonSegState.IDLE
		data.StateFrame = 0
		elseif data.State == SimonSegState.IDLERAISED or data.State == SimonSegState.TEARS or data.State == SimonSegState.LASER then
		data.State = SimonSegState.LOWER
		end
	end
		------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Spit", true)
	local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		data.StateFrame = 0
	end
	elseif entity:GetSprite():IsEventTriggered("Spit") then
		sound:Play(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,0.7)
		--local brim = EntityLaser.ShootAngle(6, entity.Position, 90, 15, Vector(0,10), entity):ToLaser()
		local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
		Projectile.Scale = 1.5
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 1
		Projectile:GetData().RockProj = true
	elseif entity:GetSprite():IsFinished("Spit") then
	--
		local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		data.State = SimonSegState.RAISE
		data.StateFrame = 0
	end
	--
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonState.BIGBRIM then
	-----
	local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		if data.State == SimonSegState.IDLE then
		data.State = SimonSegState.IDLE
		data.StateFrame = 0
		elseif data.State == SimonSegState.IDLERAISED or data.State == SimonSegState.TEARS or data.State == SimonSegState.LASER then
		data.State = SimonSegState.LOWER
		end
	end
		------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Big Brim", true)
			sound:Play(SoundEffect.SOUND_FRAIL_CHARGE,1,0,false,1)
	local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		data.StateFrame = 0
	end
	elseif entity:GetSprite():IsEventTriggered("Spit") then
		sound:Play(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,0.7)
		local brim = EntityLaser.ShootAngle(6, entity.Position, 90, 22, Vector(0,-20), entity):ToLaser()
		brim.DepthOffset = 80
		--local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
		--Projectile.Scale = 1.5
		--Projectile.ProjectileFlags = ProjectileFlags.SMART
		--Projectile.HomingStrength = 1
		--Projectile:GetData().RockProj = true
	elseif entity:GetSprite():IsFinished("Big Brim") then
			local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		data.State = SimonSegState.RAISE
		data.StateFrame = 0
	end
	--
	
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonState.EYELASERS then
	-----
	local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		if data.State == SimonSegState.IDLE then
		data.State = SimonSegState.IDLE
		data.StateFrame = 0
		elseif data.State == SimonSegState.IDLERAISED or data.State == SimonSegState.TEARS or data.State == SimonSegState.LASER then
		data.State = SimonSegState.LOWER
		end
	end
		------
		if data.StateFrame == 1 then
		sound:Play(Sounds.ALARM1,1.4,0,false,1)
		Game():ShakeScreen(11,11)
			entity:GetSprite():Play("Eye Laser", true)
			local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		data.StateFrame = 0
	end
		elseif entity:GetSprite():IsEventTriggered("Lasers") then
		sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
		local eyeposl = entity.Position + Vector(85,-40)
		local eyeposr = entity.Position + Vector(-85,-40)
		
		local briml = EntityLaser.ShootAngle(1, eyeposl, 90, 35, Vector(0,10), entity):ToLaser()
		local brimr = EntityLaser.ShootAngle(1, eyeposr, 90, 35, Vector(0,10), entity):ToLaser()
		briml.DepthOffset = 170
		brimr.DepthOffset = 180
		
		
		brimr.MaxDistance = 280
		brimr.IsActiveRotating = true
		brimr:SetActiveRotation(28, 1e5, 1.5)
		
		briml.MaxDistance = 280
		briml.IsActiveRotating = true
		briml:SetActiveRotation(28, 2, -1.5)
		elseif entity:GetSprite():IsFinished("Eye Laser") then
			local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local data = boss:GetData()
		
		data.State = SimonSegState.RAISE
		data.StateFrame = 0
	end
	--
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonState.SPITOIL then
		if data.StateFrame == 1 then
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_2,1,0,false,0.7)
			entity:GetSprite():Play("Spit Oil", true)
	elseif entity:GetSprite():IsEventTriggered("Spit") then
	sound:Play(SoundEffect.SOUND_GHOST_SHOOT,1,0,false,1)
			Game():ShakeScreen(8,9)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,13),entity):ToProjectile()
			proj:GetData().TarProj = true
			
	elseif entity:GetSprite():IsFinished("Spit Oil") then
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonState.HURT then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Hurt", true)
			sound:Play(SoundEffect.SOUND_MONSTER_ROAR_1,1,0,false,0.7)
	elseif entity:GetSprite():IsFinished("Hurt") then
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonState.CRANES then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Summon Cranes", true)
	elseif entity:GetSprite():IsEventTriggered("Cranes") then
	sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,0.7)
			Game():ShakeScreen(13,14)
			Isaac.Spawn(EntityType.CLOCKWORKCRANE, Isaac.GetEntityVariantByName("Clockwork Crane"), 0, Isaac.GetFreeNearPosition(player.Position, 56), Vector(0,0), nil)
			Isaac.Spawn(EntityType.CLOCKWORKCRANE, Isaac.GetEntityVariantByName("Clockwork Crane"), 0, Isaac.GetFreeNearPosition(player.Position, 15), Vector(0,0), nil)
			--Isaac.Spawn(EntityType.CLOCKWORKCRANE, Isaac.GetEntityVariantByName("Clockwork Crane"), 0, Isaac.GetFreeNearPosition(player.Position, 34), Vector(0,0), nil)
	elseif entity:GetSprite():IsFinished("Summon Cranes") then
			data.State = SimonTransition(data.State)
			data.StateFrame = 0
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.SimonBossUpdate, EntityType.SIMONBOSS);

function EXILE_M:SimonsSegmentUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	
	if entity.Variant == Isaac.GetEntityVariantByName("Simon Segment") then --- check for var
	entity.DepthOffset = 15;
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	
	entity:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
	
	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	if data.pos1 == nil then data.pos1 = 0 end
	if data.Dirvect == nil then data.Dirvect = 0 end
	local target = entity:GetPlayerTarget()

	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1 
	
	if data.State == SimonSegState.APPEAR and entity:GetSprite():IsFinished("Appear") then
		data.State = SimonSegState.IDLE
		data.StateFrame = 0
	elseif data.State == SimonSegState.IDLE then --------------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Idle", true)
			entity.DepthOffset = -90
		elseif entity:GetSprite():IsFinished("Idle") then
			data.State = SimonSegTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonSegState.RAISE then
		if data.StateFrame == 1 then
		entity:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) 
		sound:Play(Sounds.ROBOTIC,1.3,0,false,1)
			entity:GetSprite():Play("Raise", true)
			entity.DepthOffset = -30
	elseif entity:GetSprite():IsFinished("Raise") then
			data.State = SimonSegTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonSegState.IDLERAISED then --------------------------------------
		if data.StateFrame == 1 then
		entity:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) 
			entity:GetSprite():Play("IdleRaised", true)
		elseif entity:GetSprite():IsFinished("IdleRaised") then
			data.State = SimonSegTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonSegState.LOWER then
		if data.StateFrame == 1 then
		entity:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) 
			entity:GetSprite():Play("Lower", true)
	elseif entity:GetSprite():IsFinished("Lower") then
			data.State = SimonSegTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonSegState.TEARS then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Tears", true)
	elseif entity:GetSprite():IsEventTriggered("Laser") then
	sound:Play(SoundEffect.SOUND_BEEP,1.5,0,false,0.7)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	elseif entity:GetSprite():IsFinished("Tears") then
			data.State = SimonSegTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == SimonSegState.LASER then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Laser", true)
			entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) 
	elseif entity:GetSprite():GetFrame() == 3 then
	sound:Play(SoundEffect.SOUND_BEEP,1.6,0,false,1.2)
		data.pos1 = entity.Position - target.Position
		data.Dirvect = data.pos1:GetAngleDegrees()
		local BloodLaser = EntityLaser.ShootAngle(2, entity.Position, data.Dirvect + 180,
		19, Vector(0,-23), player)
		BloodLaser.DisableFollowParent = true
		BloodLaser.CollisionDamage = 0
		BloodLaser:SetColor(Color(0, 0, 0, 1, 18, 0, 0),99,1,false,false)
		BloodLaser.DepthOffset = 65;
		BloodLaser.EndPoint = target.Position
	elseif entity:GetSprite():IsEventTriggered("Laser") then
	sound:Play(Sounds.LASERFIRE,1.2,0,false,1)
		local BloodLaser = EntityLaser.ShootAngle(2, entity.Position, data.Dirvect + 180,
		9, Vector(0,-23), entity)
		BloodLaser.DepthOffset = 65;
		BloodLaser.EndPoint = target.Position
	elseif entity:GetSprite():IsFinished("Laser") then
	entity:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE) 
			data.State = SimonSegTransition(data.State)
			data.StateFrame = 0
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.SimonsSegmentUpdate, EntityType.SIMONBOSS);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local simonseg = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1, false, false)
    for _, boss in ipairs(simonseg) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		
		boss:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
		
		if sprite:IsEventTriggered("Raised") then
		--sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1)
		boss.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		boss.DepthOffset = 30
		end
		if sprite:IsEventTriggered("Lowered") then
		--sound:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,1,0,false,1)
		boss.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		boss.DepthOffset = -140
        end
		if sprite:IsEventTriggered("Explosion") then
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, boss.Position, Vector(0,0), boss)
			local offsety = math.random(-30,-10)
			local offsetx = math.random(-20,30)
			blood.PositionOffset = Vector(offsetx,offsety)
			blood.DepthOffset = 90
			blood.SpriteScale = Vector(0.5,0.5)
        end
		if sprite:IsEventTriggered("Death") then
			Isaac.Explode(boss.Position, boss, 5)
			EXILE_M.SimonStunned = true
        end
    end
end)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local simon = Isaac.FindByType(EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("SIMON"), -1, false, false)
    for _, boss in ipairs(simon) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		local segments = Isaac.CountEntities(nil, EntityType.SIMONBOSS, Isaac.GetEntityVariantByName("Simon Segment"), -1)
		
		boss:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
		
		if segments == nil or segments < 1 then
		boss:Kill()
		end
		
		if sprite:IsEventTriggered("Die") then
		Game():ShakeScreen(12,12)
			sound:Play(Sounds.LABOSSDIE,3.5,0,false,1)
        end
		
		
		if sprite:IsEventTriggered("Explosion") then
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, boss.Position, Vector(0,0), boss)
			local offsety = math.random(-60,10)
			local offsetx = math.random(-100,90)
			Game():GetRoom():EmitBloodFromWalls(1,3)
			blood.PositionOffset = Vector(offsetx,offsety)
			blood.DepthOffset = 150
			blood.SpriteScale = Vector(0.7,0.7)
			boss:SetColor(Color(100,100,100,1,0,50,70),1,0,true,false)
        end
		if sprite:IsEventTriggered("Death") then
			Isaac.Explode(boss.Position, boss, 5)
        end
    end
end)

---sound:Play(Sounds.HOLY_TWO,2,0,false,1)
---EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.MoralityCheckShopkeepers, EntityType.ENTITY_SHOPKEEPER);

LoaState = {
	APPEAR = 0, ---------
	IDLE = 1,
	GROUNDIN = 2,
	GROUNDOUT = 3,
	SHOOT1 = 4,
	SHOOT2 = 5,
	JUMPOUT = 6,
	SNIPE = 7,
	DIGINVIS = 8,
	DIG = 9
}

LoaChain = {
	[LoaState.IDLE] =	{0.3, 0.4, 0.0, 0.15, 0.15, 0.0, 0.0, 0.0, 0.0},
	[LoaState.GROUNDIN] =	{0.0, 0.0, 0.3, 0.0, 0.0, 0.3, 0.2, 0.0, 0.2},
	[LoaState.GROUNDOUT] =	{0.8, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LoaState.SHOOT1] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LoaState.SHOOT2] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LoaState.JUMPOUT] =	{0.0, 0.0, 0.2, 0.0, 0.0, 0.45, 0.15, 0.0, 0.2},
	[LoaState.SNIPE] =	{0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LoaState.DIGINVIS] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LoaState.DIG] =	{0.0, 0.0, 0.1, 0.0, 0.0, 0.2, 0.0, 0.0, 0.7}
}	

function LoaTransition(state)
	local roll = math.random()
	for i = 1, #LoaChain do
		roll = roll - LoaChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #LoaChain
end

Loa2State = {
	APPEAR = 0, ---------
	IDLE = 1,
	GROUNDIN = 2,
	GROUNDOUT = 3,
	SHOOT1 = 4,
	SHOOT2 = 5,
	JUMPOUT = 6,
	SNIPE = 7,
	DIGINVIS = 8,
	DIG = 9,
	JUMPOUT2 = 10
}

Loa2Chain = {
	[Loa2State.IDLE] =	{0.25, 0.35, 0.0, 0.2, 0.2, 0.0, 0.0, 0.0, 0.0, 0},
	[Loa2State.GROUNDIN] =	{0.0, 0.0, 0.3, 0.0, 0.0, 0.3, 0.2, 0.0, 0.2, 0},
	[Loa2State.GROUNDOUT] =	{0.8, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0},
	[Loa2State.SHOOT1] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0},
	[Loa2State.SHOOT2] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0},
	[Loa2State.JUMPOUT] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.0, 0.0, 0.0, 0.4},
	[Loa2State.SNIPE] =	{0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0},
	[Loa2State.DIGINVIS] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0},
	[Loa2State.DIG] =	{0.0, 0.0, 0.1, 0.0, 0.0, 0.2, 0.0, 0.0, 0.7, 0},
	[Loa2State.JUMPOUT2] =	{0.0, 0.0, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0}
}	

function Loa2Transition(state)
	local roll = math.random()
	for i = 1, #Loa2Chain do
		roll = roll - Loa2Chain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #Loa2Chain
end

----

function EXILE_M:LoaBossUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	entity.DepthOffset = -12;

	
	if data.State == nil then data.State = 0 end
	if data.CurrentVel == nil then data.CurrentVel = 0 end
	if data.StateFrame == nil then 
	data.StateFrame = 0 
	data.TimesJumped = 0
	end
	local target = entity:GetPlayerTarget()
	
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1
	
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	
	if data.State == LoaState.APPEAR and entity:GetSprite():IsFinished("Appear") then
	data.CurrentVel = 0
	data.State = LoaState.IDLE
	data.StateFrame = 0
	elseif data.State == LoaState.IDLE then ----------------------------------
		if data.StateFrame == 1 then
		data.TimesJumped = 0
		entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
			entity:GetSprite():Play("Idle", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
		elseif entity:GetSprite():IsFinished("Idle") then
			data.State = LoaTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LoaState.GROUNDIN then -------------------------------------
		if data.StateFrame == 1 then
		data.TimesJumped = 0
			entity:GetSprite():Play("Ground In", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
	elseif entity:GetSprite():IsFinished("Ground In") then
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 140, 13)
		entity.Position = teleportPosition
			data.State = LoaTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LoaState.GROUNDOUT then ---------------------------------------
		if data.StateFrame == 1 then
		data.TimesJumped = 0
			entity:GetSprite():Play("Ground Out", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		
		elseif entity:GetSprite():IsFinished("Ground Out") then
			data.State = LoaTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LoaState.SHOOT1 then ---------------------------------------------
	entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Shoot", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,1,0,false,1)
		for i = 1, 7 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(80, 140) / 78)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -(math.random(40, 80)/10) 
			Projectile.Scale = 1
			Projectile.FallingAccel = (math.random(4, 7)/12)
			Projectile.Height = -26
			Projectile.DepthOffset = 43
			Projectile.CollisionDamage = 0.1
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 1
		end
	elseif entity:GetSprite():IsFinished("Shoot") then
			data.State = LoaTransition(data.State)
			data.CurrentVel = 0
			data.StateFrame = 0
		end
	elseif data.State == LoaState.SHOOT2 then ---------------------------------------------
	entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Shoot2", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
	sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1)
	
	local projparams = ProjectileParams()
	projparams.BulletFlags = ProjectileFlags.SMART
	entity:FireProjectiles(entity.Position, Vector(16,0), 8, projparams)
			
	elseif entity:GetSprite():IsFinished("Shoot2") then
			data.State = LoaTransition(data.State)
			data.CurrentVel = 0
			data.StateFrame = 0
		end
	elseif data.State == LoaState.JUMPOUT then ----------------------------------
		entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
			if data.TimesJumped > 5 then
				data.State = LoaState.IDLE
				data.StateFrame = 0
			else
				data.TimesJumped = data.TimesJumped + 1
				entity:GetSprite():Play("Jump Out", true)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				data.CurrentVel = 0
			end
		elseif entity:GetSprite():IsEventTriggered("JumpOut") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1.1,0,false,1)
		local quake = Game():Spawn(EntityType.ENTITY_EFFECT, 61, entity.Position, Vector(0,0), entity, 0, 0)
		quake.DepthOffset = -50
		elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(SoundEffect.SOUND_LITTLE_HORN_COUGH,1,0,false,1)
		for i = 1, 13 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = 1
			Projectile.Height = -26
			Projectile.DepthOffset = 20
			Projectile.CollisionDamage = 0.1
					Projectile:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
			Projectile:GetSprite():LoadGraphics()
			Projectile:GetData().StoneProj = true

		end
		elseif entity:GetSprite():IsEventTriggered("Coll") then
		sound:Play(SoundEffect.SOUND_GOOATTACH0,1.2,0,false,1)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		Game():ShakeScreen(8)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsFinished("Jump Out") then
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 180, 13)
		entity.Position = teleportPosition
			data.State = LoaTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LoaState.SNIPE then ----------------------------------
		entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Snipe", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,0.7)
		local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 13,entity):ToProjectile()
		Projectile.Scale = 1
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 1
		--Projectile:GetData().StoneProj = true
		elseif entity:GetSprite():IsFinished("Snipe") then
			data.State = LoaTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LoaState.DIG then ----------------------------------
		if data.StateFrame == 1 then
		Game():ShakeScreen(4)
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1.1,0,false,0.6)
			entity:GetSprite():Play("Dig", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 4.3
		elseif entity:GetSprite():IsFinished("Dig") then
			data.State = LoaTransition(data.State)
			data.StateFrame = 0
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.LoaBossUpdate, EntityType.LOALOA);

function EXILE_M:Loa2BossUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	entity.DepthOffset = 10;

	
	if data.State == nil then data.State = 0 end
	if data.CurrentVel == nil then data.CurrentVel = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	local target = entity:GetPlayerTarget()
	
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1
	
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	
	if data.State == Loa2State.APPEAR and entity:GetSprite():IsFinished("Appear") then
	data.CurrentVel = 0
		data.State = Loa2State.IDLE
		data.StateFrame = 0
	elseif data.State == Loa2State.IDLE then ----------------------------------
		if data.StateFrame == 1 then
		entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
			entity:GetSprite():Play("Idle", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
		elseif entity:GetSprite():IsFinished("Idle") then
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.GROUNDIN then -------------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Ground In", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
	elseif entity:GetSprite():IsFinished("Ground In") then
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 125, 12)
		entity.Position = teleportPosition
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.GROUNDOUT then ---------------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Ground Out", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		
		elseif entity:GetSprite():IsFinished("Ground Out") then
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.SHOOT1 then ---------------------------------------------
	entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Shoot", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,1,0,false,1)
		for i = 1, 7 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(80, 140) / 78)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -(math.random(40, 80)/10) 
			Projectile.Scale = (math.random(100,150))/80
			Projectile.FallingAccel = (math.random(4, 7)/12)
			Projectile.Height = -26
			Projectile.DepthOffset = 43
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 1
		end
	elseif entity:GetSprite():IsFinished("Shoot") then
			data.State = Loa2Transition(data.State)
			data.CurrentVel = 0
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.SHOOT2 then ---------------------------------------------
	entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Shoot2", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
	sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(3,3),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-3,3),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(3,-3),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-3,-3),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,5),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-5),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(5,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-5,0),entity):ToProjectile()
			
			tear1.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear1.Scale = 2
			tear1.Height = -33
			tear1.FallingAccel = -0.085
			tear2.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear2.Scale = 2
			tear2.Height = -33
			tear2.FallingAccel = -0.085
			tear3.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear3.Scale = 2
			tear3.Height = -33
			tear3.FallingAccel = -0.085
			tear4.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear4.Scale = 2
			tear4.Height = -33
			tear4.FallingAccel = -0.085
			
			tear5.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear5.Scale = 2
			tear5.Height = -33
			tear5.FallingAccel = -0.085
			tear6.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear6.Scale = 2
			tear6.Height = -33
			tear6.FallingAccel = -0.085
			tear7.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear7.Scale = 2
			tear7.Height = -33
			tear7.FallingAccel = -0.085
			tear8.ProjectileFlags = ProjectileFlags.SINE_VELOCITY
			tear8.Scale = 2
			tear8.Height = -33
			tear8.FallingAccel = -0.085
			
	elseif entity:GetSprite():IsFinished("Shoot2") then
			data.State = Loa2Transition(data.State)
			data.CurrentVel = 0
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.JUMPOUT then ----------------------------------
		entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Jump Out", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("JumpOut") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1.3,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(Sounds.SPLASH_WATER2,1.5,0,false,1.0)
		sound:Play(SoundEffect.SOUND_LITTLE_HORN_COUGH,1,0,false,1)
		for i = 1, 3 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -26
			Projectile.DepthOffset = 20
			Projectile.CollisionDamage = 0.5
		end
		for i = 1, 3 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, (((entity.Position + Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -26
			Projectile.DepthOffset = 20
			Projectile.CollisionDamage = 0.5
		end
		elseif entity:GetSprite():IsEventTriggered("Coll") then
		sound:Play(SoundEffect.SOUND_GOOATTACH0,2,0,false,1)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		Game():ShakeScreen(12)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsFinished("Jump Out") then
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 120, 12)
		entity.Position = teleportPosition
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.JUMPOUT2 then ----------------------------------
		entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Flip Trick", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("JumpOut") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1.3,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(Sounds.SPLASH_WATER,2,0,false,0.6)
		Game():ShakeScreen(17,17)
		Game():ShakeScreen(17,17)
		for i = 1, 11 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-66,66)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -48
			Projectile.DepthOffset = 20
		end
		for i = 1, 9 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, (((entity.Position + Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -55
			Projectile.DepthOffset = 20
		end
		elseif entity:GetSprite():IsEventTriggered("Coll") then
		sound:Play(SoundEffect.SOUND_GOOATTACH0,2,0,false,1)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		Game():ShakeScreen(17)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsFinished("Flip Trick") then
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 125, 12)
		entity.Position = teleportPosition
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.SNIPE then ----------------------------------
		entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Snipe", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 0
		elseif entity:GetSprite():IsEventTriggered("Shoot") then
		sound:Play(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,0.7)
		local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 13,entity):ToProjectile()
		Projectile.Scale = 1.5
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 1
		--Projectile:GetData().RockProj = true
		elseif entity:GetSprite():IsFinished("Snipe") then
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == Loa2State.DIG then ----------------------------------
		if data.StateFrame == 1 then
		for i = 1, 3 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, (((entity.Position + Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -6
			Projectile.DepthOffset = 20
		end
		Game():ShakeScreen(4)
		sound:Play(Sounds.SPLASH_WATER2,1.1,0,false,0.8)
			entity:GetSprite():Play("Dig", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			data.CurrentVel = 3
		elseif entity:GetSprite():IsFinished("Dig") then
			data.State = Loa2Transition(data.State)
			data.StateFrame = 0
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.Loa2BossUpdate, EntityType.LOALOA2);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local loaloa = Isaac.FindByType(EntityType.LOALOA, 0, -1, false, false)
    for _, boss in ipairs(loaloa) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		boss.SpriteScale = Vector(1, 1)
		if sprite:IsEventTriggered("Quake") then
		sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1)
		Game():ShakeScreen(8)
		end
		if sprite:IsEventTriggered("In") then
		sound:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,1,0,false,1)
		boss.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		Game():ShakeScreen(7)
		end
        if sprite:IsPlaying("Death") then
            local npc = boss:ToNPC()
			if sprite:IsEventTriggered("Water") then
			sound:Play(SoundEffect.SOUND_GHOST_ROAR,1.1,0,false,1)
			EXILE_M.ActivateFaucetRight = 1
			EXILE_M.ActivateFaucetLeft = 1
			end
			if sprite:IsEventTriggered("Phase2") then
			sound:Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
			Isaac.Spawn(EntityType.LOALOA2,0,0, room:GetCenterPos(), Vector(0,0), nil):ToProjectile()
			boss:Kill()
            end

        end
    end
end)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local loaloa = Isaac.FindByType(EntityType.LOALOA2, 0, -1, false, false)
    for _, boss in ipairs(loaloa) do
		local npc = boss:ToNPC()
		local target = npc:GetPlayerTarget()
        local sprite = boss:GetSprite()
		local room = Game():GetRoom()
		boss.SpriteScale = Vector(0.81, 0.81)
		if sprite:IsEventTriggered("Quake") then
		sound:Play(Sounds.SPLASH_WATER,1.4,0,false,1)
		Game():ShakeScreen(8)
		end
		if sprite:IsEventTriggered("In") then
		sound:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,1.1,0,false,0.5)
		sound:Play(Sounds.SPLASH_WATER2,1.7,0,false,1)
		for i = 1, 3 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, boss.Position, ((-(boss.Position - Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), boss, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -26
			Projectile.DepthOffset = 20
		end
		for i = 1, 3 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, boss.Position, (((boss.Position + Isaac.GetFreeNearPosition(target.Position, 45)):Resized(7.75)):Rotated(math.random(-45,45)) * (math.random(60, 140) / 100)), boss, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,170))/75
			Projectile.Height = -26
			Projectile.DepthOffset = 20
		end
		boss.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		Game():ShakeScreen(7)
		end
        if sprite:IsPlaying("Death") then
            local npc = boss:ToNPC()
			if sprite:IsEventTriggered("Blood") then
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, boss.Position, Vector(0,0), boss)
			local offsety = math.random(-60,-30)
			local offsetx = math.random(-10,20)
			blood.PositionOffset = Vector(offsetx,offsety)
			blood.DepthOffset = 90
			room:EmitBloodFromWalls(1,3)
			sound:Play(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,1)
			end
			if sprite:IsEventTriggered("Cry") then
			sound:Play(SoundEffect.SOUND_MONSTER_ROAR_1,1,0,false,1)
			end
			if sprite:IsEventTriggered("Explode") then
			sound:Play(SoundEffect.SOUND_MONSTER_ROAR_2,1,0,false,1)
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, boss.Position, Vector(0,0), boss)
			boss:BloodExplode()
            end

        end
    end
end)

LDukeState = {
	APPEAR = 0, ---------
	IDLE = 1,
	DASH = 2,
	PUFF = 3,
	SUMMON = 4,
	ROLL = 5,
	SPIT = 6,
	ASCEND = 7,
	DESCENDMINI = 8,
	ASCENDEDWALK = 9,
	DESCEND = 10,
	ASCENDEDPUFF = 11
}

LDukeChain = {
	[LDukeState.IDLE] =	{0.5, 0.1, 0.0, 0.2, 0.0, 0.1, 0.1, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.DASH] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.PUFF] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.SUMMON] =	{0.3, 0.0, 0.2, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.ROLL] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.SPIT] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.ASCEND] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 0.0, 0.0, 0.0},
	[LDukeState.DESCENDMINI] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 0.0, 0.0},
	[LDukeState.ASCENDEDWALK] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.55, 0.15, 0.3},
	[LDukeState.DESCEND] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
	[LDukeState.ASCENDEDPUFF] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.5}
}	

function LDukeTransition(state)
	local roll = math.random()
	for i = 1, #LDukeChain do
		roll = roll - LDukeChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #LDukeChain
end

----

function EXILE_M:LDukeUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local sound = SFXManager()
	local ang = player.Position - entity.Position
	
	if entity.Variant == Isaac.GetEntityVariantByName("Duke of Locusts") then
	
	entity.DepthOffset = 70;
	
	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	local target = entity:GetPlayerTarget()
	

	--entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1 
	
	if data.State == LDukeState.IDLE and entity.Position:Distance(target.Position) < 108 and data.StateFrame > 1 then
		data.State = LDukeState.ROLL
		data.StateFrame = 0
	end
	
	if data.State == LDukeState.IDLE or data.State == LDukeState.SUMMON then
	local diagonals = {
    Vector(1, 1):Normalized(),
    Vector(-1, 1):Normalized(),
    Vector(1, -1):Normalized(),
    Vector(-1, -1):Normalized()
	}
	
		local vel = entity.Velocity:Normalized()
        local closestDir
        local dist
        for _, direction in ipairs(diagonals) do
            local distance = vel:Distance(direction)
            if not dist or distance < dist then
                closestDir = direction
                dist = distance
            end
        end
		
		entity.Velocity = closestDir:Resized(5)
	end
	
	if data.State == LDukeState.APPEAR and entity:GetSprite():IsFinished("Appear") then
		data.State = LDukeState.IDLE
		data.StateFrame = 0
	elseif data.State == LDukeState.IDLE then --------------------------------------
	
		
		if data.StateFrame == 1 then
		sound:Play(SoundEffect.SOUND_INSECT_SWARM_LOOP,1,0,false,1)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			entity:GetSprite():Play("Walk", true)
		elseif entity:GetSprite():IsFinished("Walk") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LDukeState.DASH then
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.7 * 7
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Dash", true)
			sound:Play(SoundEffect.SOUND_FRAIL_CHARGE,1,0,false,1)
	elseif entity:GetSprite():IsFinished("Dash") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LDukeState.PUFF then ----------------
		if data.StateFrame == 1 then
			entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("Puff", true)
		elseif entity:GetSprite():IsEventTriggered("Puff") then
		sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,1,0,false,1)
    local spit = Isaac.FindByType(EntityType.ENTITY_SUCKER, 1, -1, false, false)
    for _, entity in ipairs(spit) do
		entity:GetData().Spawner = entity
		entity:GetData().HasParent = false
	end

		game:ButterBeanFart(entity.Position, 110, player, false)
		elseif entity:GetSprite():IsFinished("Puff") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == LDukeState.SUMMON then ----------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Summon", true)
		elseif entity:GetSprite():IsEventTriggered("Summon") then
		sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,1,0,false,1)
		local spit1 = Isaac.Spawn(EntityType.ENTITY_SUCKER,1,0,entity.Position + Vector(0,-10),Vector(0,0),entity)
		spit1:GetData().Spawner = entity
		spit1:GetData().HasParent = true
		spit1:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		
			sound:Play(SoundEffect.SOUND_MONSTER_ROAR_1,1,0,false,1)
		elseif entity:GetSprite():IsFinished("Summon") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == LDukeState.ROLL then ----------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Roll", true)
		elseif entity:GetSprite():IsEventTriggered("Puff") then
		sound:Play(Sounds.WHOOSH,1.4,60,false,1)
		entity:AddVelocity((target.Position - entity.Position):Normalized() * 17.5)
		Isaac.Spawn(EntityType.ENTITY_BOIL,1,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
			
		elseif entity:GetSprite():IsEventTriggered("StopRoll") then
		entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():GetFrame() > 11 and entity:GetSprite():GetFrame() < 24 then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0,entity.Position, Vector(0,0), entity)
		creep:SetColor(Color(0,20,0,1,0,0,0),0,0,false,false)
		local effect = creep:ToEffect()
		effect.Scale = (math.random(1,2))
		elseif entity:GetSprite():IsFinished("Roll") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == LDukeState.SPIT then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Spit", true)
	elseif entity:GetSprite():IsEventTriggered("Summon") then
	sound:Play(SoundEffect.SOUND_BOSS_GURGLE_ROAR,1,0,false,1)
			local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,0.4),entity):ToProjectile()
			proj.Scale = 3.5
			proj:SetColor(Color(0,20,0,1,0,0,0),0,0,false,false)
			proj.FallingAccel = -0.034
			proj:GetData().PoisonShot = true
			entity:AddVelocity(Vector(0,-16))
	elseif entity:GetSprite():IsFinished("Spit") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end---
	elseif data.State == LDukeState.ASCEND then ----------------
		if data.StateFrame == 1 then
    local spit = Isaac.FindByType(EntityType.ENTITY_SUCKER, 1, -1, false, false)
    for _, entity in ipairs(spit) do
		entity:GetData().Spawner = entity
		entity:GetData().HasParent = false
	end
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			entity:GetSprite():Play("Ascend", true)
		entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():IsFinished("Ascend") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == LDukeState.DESCENDMINI then ----------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("DescendMini", true)
		entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():IsFinished("DescendMini") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == LDukeState.ASCENDEDWALK then --------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.6 * 5
		if data.StateFrame == 1 then
			entity:GetSprite():Play("AscendedWalk", true)
		elseif entity:GetSprite():IsFinished("AscendedWalk") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LDukeState.DESCEND then --------------------------------------
		if data.StateFrame == 1 then
		sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_1,1,0,false,1)
			entity:GetSprite():Play("Descend", true)
			entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():IsEventTriggered("StopRoll") then
			Game():ShakeScreen(17)
			sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
			sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
			
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
			
			tear1:GetData().RockProj = true
			tear2:GetData().RockProj = true
			tear3:GetData().RockProj = true
			tear4:GetData().RockProj = true
			
			tear5:GetData().RockProj = true
			tear6:GetData().RockProj = true
			tear7:GetData().RockProj = true
			tear8:GetData().RockProj = true
	local spit = Isaac.FindByType(EntityType.ENTITY_SUCKER, 1, -1, false, false)
    for _, entity in ipairs(spit) do
		entity:GetData().Spawner = entity
		entity:GetData().HasParent = true
	end
			
		elseif entity:GetSprite():IsEventTriggered("Coll") then
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsFinished("Descend") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == LDukeState.ASCENDEDPUFF then ----------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("AscendedPuff", true)
		elseif entity:GetSprite():IsEventTriggered("Puff") then
		sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,1,0,false,1)
--		sound:Play(Sounds.FALLINGWHISTLE,1,0,false,1)
			local projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
			projectile:GetSprite():ReplaceSpritesheet(0, "gfx/egg_bullets.png")
			projectile:GetSprite():LoadGraphics()
			projectile.SpriteScale = Vector(1.3,1.3)
			local proj = projectile:ToProjectile()
			proj.Scale = 3
			proj.ProjectileFlags = ProjectileFlags.EXPLODE
			proj:GetData().PukeShot = true
			proj.Height = -170
			
				proj.FallingAccel = 1.4
				proj.FallingSpeed = 1.2
	--	game:ButterBeanFart(entity.Position, 4, entity, false)
		elseif entity:GetSprite():IsFinished("AscendedPuff") then
			data.State = LDukeTransition(data.State)
			data.StateFrame = 0
		end ----------
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.LDukeUpdate, EntityType.DUKEOFLOCUSTS);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local duke = Isaac.FindByType(EntityType.DUKEOFLOCUSTS, Isaac.GetEntityVariantByName("Duke of Locusts"), -1, false, false)
    for _, boss in ipairs(duke) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		if sprite:IsEventTriggered("Afterimage") then
		Isaac.Spawn(EntityType.DAFTERIMAGE,Isaac.GetEntityVariantByName("Duke Afterimage"),0,boss.Position + Vector(0,0) ,Vector(0,0),boss)
		end
		if sprite:IsEventTriggered("Afterimage2") then
		Isaac.Spawn(EntityType.DAFTERIMAGE,Isaac.GetEntityVariantByName("Duke Afterimage 2"),0,boss.Position + Vector(0,0) ,Vector(0,0),boss)
		end
	end
end)

function EXILE_M:DukeSpitsCheck(f)
	if f.Variant == Isaac.GetEntityVariantByName("Spit") then
	if f:GetData().HasParent == true then
    if f:GetData().Degrees == nil then f:GetData().Degrees = 0 end
    if f:GetData().Radius == nil then f:GetData().Radius = 0 end
    f:GetData().Degrees = f:GetData().Degrees + 4
    f:GetData().Radius = 55
    if f:GetData().Degrees >= 360 then f:GetData().Degrees = 0 end
    if f:GetData().Degrees <= -360 then f:GetData().Degrees = 0 end
    for i = 0, Isaac.CountEntities(entity, EntityType.ENTITY_SUCKER, 1, -1) do
        local spawner = f:GetData().Spawner
        local direction = Vector.FromAngle(f:GetData().Degrees):Normalized()
        f:GetData().NewPos = spawner.Position + direction * f:GetData().Radius
        f.Velocity = -(f.Position - f:GetData().NewPos)/2
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.DukeSpitsCheck, EntityType.ENTITY_SUCKER);

--- FATE BOSS ---

local FateSpeed = 5

function EXILE_M:FateUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local ang = player.Position - entity.Position
	local halfhealth = 2250
	
	
	local FateSpeedHalf = 7
	
	
	local maxhp = entity.MaxHitPoints

	
	local doorposup = room:GetDoorSlotPosition(DoorSlot.UP0)
	local doorposup2 = room:GetDoorSlotPosition(DoorSlot.UP1)
	local doorposleft = room:GetDoorSlotPosition(DoorSlot.LEFT0)
	local doorposleft2 = room:GetDoorSlotPosition(DoorSlot.LEFT1)
	entity.DepthOffset = 50;
	
	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	local target = entity:GetPlayerTarget()
	
	data.StateFrame = data.StateFrame + 1
	
	
	entity.Velocity = (target.Position - entity.Position):Normalized() * EXILE_M.Fatevel
	
	if data.State == FateState.APPEAR and entity:GetSprite():IsFinished("Appear") then
		EXILE_M.Fatevel = 0
		data.State = FateState.IDLE
		data.StateFrame = 0
	elseif data.State == FateState.IDLE then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Float", true)
			EXILE_M.Fatevel = FateSpeed
			
		if entity.HitPoints < entity.MaxHitPoints / 2 then
			FateSpeed = 7
			entity:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),9999,1,false,false)
		else
			FateSpeed = 5
		end
		elseif entity:GetSprite():IsEventTriggered("Afterimage") then
		Isaac.Spawn(EntityType.AFTERIMAGE, 1111, 0, entity.Position, Vector(0,0), entity)
		elseif entity:GetSprite():IsFinished("Float") then
			data.State = FateTransition(data.State)
			data.StateFrame = 0
		end ----
	elseif data.State == FateState.THROW then
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Throw", true)
			EXILE_M.Fatevel = 1.5
		elseif entity:GetSprite():IsEventTriggered("Throw") then
		sound:Play(SoundEffect.SOUND_SHELLGAME,2,0,false,1)
		local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,1,0,entity.Position + Vector(43,3) ,(player.Position - entity.Position):Normalized() * 18,entity):ToProjectile()
		local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,1,0,entity.Position + Vector(-43,3) ,(player.Position - entity.Position):Normalized() * 18,entity):ToProjectile()
		sound:Play(Sounds,0.6,0,false,1.3)
		tear.DepthOffset = 60
		tear2.DepthOffset = 60
		tear.ProjectileFlags = ProjectileFlags.SMART
		tear.ProjectileFlags = ProjectileFlags.BOOMERANG
		tear.HomingStrength = 3
	
		tear:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		tear:SetColor(Color(0.00, 0.00, 0.00, 1, 100, 0, 250),99,1,false,false)
	
		tear2.ProjectileFlags = ProjectileFlags.SMART
		tear2.HomingStrength = 3
	
		tear2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		tear2:SetColor(Color(0.00, 0.00, 0.00, 1, 100, 0, 250),99,1,false,false)
		elseif entity:GetSprite():IsFinished("Throw") then
			data.State = FateTransition(data.State)
			data.StateFrame = 0
		end ----
	elseif data.State == FateState.SHOOT then
		if data.StateFrame == 1 then
			EXILE_M.Fatevel = 1
			entity:GetSprite():Play("Shooting", true)
		elseif entity:GetSprite():IsEventTriggered("Fire1") then
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(12,12),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-12,12),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(12,-12),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-12,-12),entity)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,14),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(0,-14),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(14,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-14,0),entity)
		elseif entity:GetSprite():IsEventTriggered("Fire2") then
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(9,14),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-9,14),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(14,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-14,-9),entity)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(5,16),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(5,-16),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(16,5),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,entity.Position + Vector(0,0) ,Vector(-16,5),entity)

			
		elseif entity:GetSprite():IsFinished("Shooting") then
			data.State = FateTransition(data.State)
			data.StateFrame = 0
			EXILE_M.Fatevel = FateSpeed
		end ----
	elseif data.State == FateState.METEOR then
		if data.StateFrame == 1 then
		EXILE_M.Fatevel = 0
		entity:GetSprite():Play("Meteor", true)
		sound:Play(SoundEffect.SOUND_MAW_OF_VOID,2,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Meteorstart") then
		MeteorEff:Reload()
		MeteorEff:LoadGraphics()
		MeteorEff:Play("Idle", true)
		elseif entity:GetSprite():IsEventTriggered("Meteor") then
			Game():ShakeScreen(7,7)
			Isaac.Spawn(EntityType.LIGHTNING, 0, 0, room:GetRandomPosition(13), Vector(0,0), entity)
		elseif entity:GetSprite():IsFinished("Meteor") then
			data.State = FateTransition(data.State)
			EXILE_M.Fatevel = FateSpeed
			data.StateFrame = 0
		end ----
	elseif data.State == FateState.CROSSBRIM then
		if data.StateFrame == 1 then
		sound:Play(Sounds.SCI_FI,0.7,0,false,1)
		local LaserW1 = EntityLaser.ShootAngle(2, doorposup, 90,
		4, Vector(0,0), player)
		
		local LaserW2 = EntityLaser.ShootAngle(2, doorposleft, 0,
		4, Vector(0,0), player)
		local LaserW3 = EntityLaser.ShootAngle(2, doorposup2, 90,
		4, Vector(0,0), player)
		local LaserW4 = EntityLaser.ShootAngle(2, doorposleft2, 0,
		4, Vector(0,0), player)
		LaserW1.CollisionDamage = 0
		LaserW2.CollisionDamage = 0
		LaserW3.CollisionDamage = 0
		LaserW4.CollisionDamage = 0
		
		LaserW3.DisableFollowParent = true
		LaserW4.DisableFollowParent = true

		LaserW1.DisableFollowParent = true
		LaserW2.DisableFollowParent = true

		EXILE_M.Fatevel = 2.2
		entity:GetSprite():Play("Lasers", true)	
		elseif entity:GetSprite():IsEventTriggered("Lasers") then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,2,0,false,1)
			Game():ShakeScreen(13,14)


		
		local Laser1 = EntityLaser.ShootAngle(1, doorposup, 90,
		25, Vector(0,0), entity)
		
		local Laser2 = EntityLaser.ShootAngle(1, doorposleft, 0,
		25, Vector(0,0), entity)
		
		Laser1.DisableFollowParent = true
		Laser2.DisableFollowParent = true
		--Laser1:SetColor(Color(0.050, 0.235, 0.215, 3, 0, 0, 0),99,1,false,false)
		--Laser2:SetColor(Color(0.050, 0.235, 0.215, 3, 0, 0, 0),99,1,false,false)
		local Laser3 = EntityLaser.ShootAngle(1, doorposup2, 90,
		25, Vector(0,0), entity)
		local Laser4 = EntityLaser.ShootAngle(1, doorposleft2, 0,
		25, Vector(0,0), entity)
		
		Laser3.DisableFollowParent = true
		Laser4.DisableFollowParent = true
		--Laser3:SetColor(Color(0.050, 0.235, 0.215, 3, 0, 0, 0),99,1,false,false)
		--Laser4:SetColor(Color(0.050, 0.235, 0.215, 3, 0, 0, 0),99,1,false,false)
		elseif entity:GetSprite():IsFinished("Lasers") then
			data.State = FateTransition(data.State)
			EXILE_M.Fatevel = FateSpeed
			data.StateFrame = 0
		end ----
	elseif data.State == FateState.BRIMSTONE then
		if data.StateFrame == 1 then
			EXILE_M.Fatevel = 1
			entity:GetSprite():Play("Lasers2", true)
			sound:Play(SoundEffect.SOUND_MAW_OF_VOID,2,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("GetPos") then
		Fatepos1 = entity.Position - target.Position
		FateDirvect = Fatepos1:GetAngleDegrees()
		elseif entity:GetSprite():IsEventTriggered("LaserShot") then
		local Laser = EntityLaser.ShootAngle(1, entity.Position, FateDirvect + 179,
		20, Vector(0,-40), entity)
		Laser.DepthOffset = 45;
		elseif entity:GetSprite():IsFinished("Lasers2") then
			data.State = FateTransition(data.State)
			data.StateFrame = 0
			EXILE_M.Fatevel = FateSpeed
		end ----
	elseif data.State == FateState.DARKNESS then
		if data.StateFrame == 1 then
			EXILE_M.Fatevel = 1
			entity:GetSprite():Play("Darkness", true)
			sound:Play(SoundEffect.SOUND_MAW_OF_VOID,2,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Darkness") then
		sound:Play(Sounds.DARKSPELL,4,0,false,1)
		Game():Darken(1.1,180)
		elseif entity:GetSprite():IsFinished("Darkness") then
			data.State = FateTransition(data.State)
			data.StateFrame = 0
			EXILE_M.Fatevel = FateSpeed
		end ----
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.FateUpdate, EntityType.FATEFINAL);


----- DROOLS Boss

---- ASMODEUS PHASE ONE

AsmodeusState = {
	APPEAR = 0,
	IDLE = 1,
	THUNDER = 2,
	IDLEINVIS = 3,
	SUMMON1 = 4,
	SUMMON2 = 5,
	FIRE = 6,
	DEATH = 7
}

AsmodeusChain = {
	[AsmodeusState.IDLE] =	{0.6, 0.1, 0.0, 0.1, 0.1, 0.1, 0},
	[AsmodeusState.THUNDER] =	{0.6, 0.1, 0.0, 0.1, 0.1, 0.1, 0},
	[AsmodeusState.IDLEINVIS] =	{0.8, 0.0, 0.2, 0.0, 0.0, 0.0, 0},
	[AsmodeusState.SUMMON1] =	{0.0, 0.0, 1, 0.0, 0.0, 0.0, 0},
	[AsmodeusState.SUMMON2] =	{0.0, 0.0, 1, 0.0, 0.0, 0.0, 0},
	[AsmodeusState.FIRE] =	{0.6, 0.1, 0.0, 0.1, 0.1, 0.1, 0},
	[AsmodeusState.DEATH] =	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0}
}	

function AsmodeusTransition(state)
	local roll = math.random()
	for i = 1, #AsmodeusChain do
		roll = roll - AsmodeusChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #AsmodeusChain
end

----

function EXILE_M:AsmodeusUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	entity.DepthOffset = 45;
	
	if data.State == nil then data.State = 0 end
	if data.Dead == nil then data.Dead = 0 end
	if data.CurrentVel == nil then data.CurrentVel = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	local target = entity:GetPlayerTarget()
	
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	
	if data.State == AsmodeusState.APPEAR and entity:GetSprite():IsFinished("Appear") then
		data.CurrentVel = 3.55
		data.State = AsmodeusState.IDLE
		data.StateFrame = 0
	elseif data.State == AsmodeusState.IDLE then ----------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Idle", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			data.CurrentVel = 3.55
		elseif entity:GetSprite():IsFinished("Idle") then
			data.State = AsmodeusTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == AsmodeusState.THUNDER then -------------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Thunder", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			sound:Play(SoundEffect.SOUND_MONSTER_ROAR_1,1,0,false,1)
			data.CurrentVel = 0
			--entity:SetSize(0.0, Vector(0,0), 1)
			entity.Size = 25
	elseif entity:GetSprite():GetFrame() == 9 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	elseif entity:GetSprite():IsEventTriggered("Thunder") then
	local strike = Isaac.Spawn(EntityType.LIGHTNING, 0, 0, Isaac.GetRandomPosition(12), Vector(0,0), entity)
	strike:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	elseif entity:GetSprite():IsFinished("Thunder") then
			data.State = AsmodeusTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == AsmodeusState.IDLEINVIS then ---------------------------------------
		if data.StateFrame == 1 then
			entity:GetSprite():Play("IdleInvis", true)
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			EXILE_M.AsmodeusSummons = 0
			data.CurrentVel = 3
		elseif entity:GetSprite():IsEventTriggered("Thunder") then
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(4,4),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-4,4),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(4,-4),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-4,-4),entity)
		elseif entity:GetSprite():IsFinished("IdleInvis") then
		   for _, target in pairs((Isaac.FindInRadius(entity.Position, 9999, EntityPartition.ENEMY))) do
		   local data = target:GetData()
			if data.AsmodeusSpawned == true then
            EXILE_M.AsmodeusSummons = 1
			end
		end
			if EXILE_M.AsmodeusSummons < 1 then
			data.State = AsmodeusTransition(data.State)
			data.StateFrame = 0
			else
			data.State = AsmodeusState.IDLEINVIS
			data.StateFrame = 0
			end
		end
	elseif data.State == AsmodeusState.SUMMON1 then ---------------------------------------------
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Summon1", true)
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Summon1") then
	sound:Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1)
		for i = 1, 4 do
		local ent = Isaac.Spawn(EntityType.ENTITY_NULLS,0,0,Isaac.GetRandomPosition(12),Vector(0,0),entity)
		ent:GetData().AsmodeusSpawned = true
		end
	elseif entity:GetSprite():IsFinished("Summon1") then
			data.State = AsmodeusTransition(data.State)
			data.CurrentVel = 3.55
			data.StateFrame = 0
		end
	elseif data.State == AsmodeusState.SUMMON2 then ---------------------------------------------
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Summon2", true)
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	elseif entity:GetSprite():IsEventTriggered("Summon2") then
	sound:Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1)
		for i = 1, 4 do
		local ent = Isaac.Spawn(EntityType.ENTITY_IMP,0,0,Isaac.GetRandomPosition(12),Vector(0,0),entity)
		ent:GetData().AsmodeusSpawned = true
		end
	elseif entity:GetSprite():IsFinished("Summon2") then
			data.State = AsmodeusTransition(data.State)
			data.CurrentVel = 3.55
			data.StateFrame = 0
		end
	elseif data.State == AsmodeusState.FIRE then ---------------------------------------------
		if data.StateFrame == 1 then
		data.CurrentVel = 2
		entity:GetSprite():Play("Fire", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		sound:Play(SoundEffect.SOUND_FRAIL_CHARGE,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Fire") then
	sound:Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
		for i = 1, 8 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, entity.Position, ((-(entity.Position - target.Position):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(60, 140) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -(math.random(70, 80)/10) 
			Projectile.Scale = (math.random(100,150))/100
			Projectile.FallingAccel = (math.random(4, 6)/10)
			Projectile.Height = -50
			Projectile.DepthOffset = 70
			Projectile:SetColor(Color(0.500, 0.150, 0.50, 1, 100, 0, 0),99,1,false,false)
		end
	elseif entity:GetSprite():IsFinished("Fire") then
			data.State = AsmodeusTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == AsmodeusState.DEATH then ---------------------------------------------
	entity.HitPoints = 50
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Death Phase", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_2,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Phase2") then
	sound:Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
	Isaac.Explode(entity.Position, entity, 2)
	elseif entity:GetSprite():IsFinished("Death Phase") then
		Isaac.Explode(entity.Position, entity, 2)
			entity:Kill()
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.AsmodeusUpdate, EntityType.ASMODEUS);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local asmodeus = Isaac.FindByType(EntityType.ASMODEUS, 0, -1, false, false)
    for _, boss in ipairs(asmodeus) do
        local sprite = boss:GetSprite()
        if sprite:IsPlaying("Death") then
            local npc = boss:ToNPC()
			if sprite:IsEventTriggered("DieStart") then
			sound:Play(SoundEffect.SOUND_SATAN_STOMP,1.2,0,false,1)
			sound:Play(SoundEffect.SOUND_ULTRA_GREED_TURN_GOLD_1,1.5,0,false,1)
			end
           if sprite:IsEventTriggered("Phase2") then
				sound:Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
				Isaac.Explode(boss.Position, boss, 2)
				boss:BloodExplode()
			Isaac.Spawn(EntityType.ENTITY_THE_LAMB, 0, 0, boss.Position, Vector(0,0), boss)
			boss:Kill()
            end

        end
    end
end)

CasterState = {
	APPEAR = 0,
	IDLE = 1,
	FIRES1 = 2,
	FIRES2 = 3,
	SMASH = 4,
	DARKNESS = 5,
	TELEPORT = 6,
	SWORD = 7,
	IDLEPROTECTED = 8,
	SMASHPROTECTED = 9,
	THROWOUT = 10,
	DARKNESSPROTECTED = 11,
	CANDLESPIT = 12,
	FIRELASERS = 13,
	CANDLEDIE = 14,
	GETCANDLE = 15
}

CasterChain = {
	[CasterState.IDLE] =	{0.4, 0.1, 0.1, 0.1, 0.2, 0.0, 0.1, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.FIRES1] =	{0.6, 0.0, 0.1, 0.1, 0.2, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.FIRES2] =	{0.5, 0, 0.0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.SMASH] =	{0.6, 0.1, 0.1, 0.0, 0.2, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.DARKNESS] =	{0.6, 0.1, 0.1, 0.2, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-- unused
	[CasterState.TELEPORT] =	{0.6, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	--
	[CasterState.SWORD] =	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-------------------------
	[CasterState.IDLEPROTECTED] =	{0, 0, 0, 0, 0, 0, 0, 0.2, 0.1, 0.2, 0.2, 0.2, 0.1, 0, 0},
	[CasterState.SMASHPROTECTED] =	{0, 0, 0, 0, 0, 0, 0, 0.7, 0, 0, 0, 0.3, 0, 0, 0},
	[CasterState.THROWOUT] = {0, 0, 0, 0, 0, 0, 0, 0.8, 0, 0, 0, 0, 0.2, 0, 0},
	[CasterState.DARKNESSPROTECTED] = {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.CANDLESPIT] = {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.FIRELASERS] = {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
	[CasterState.CANDLEDIE] = {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	-----
	[CasterState.GETCANDLE] = {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0}
}	

function CasterTransition(state)
	local roll = math.random()
	for i = 1, #CasterChain do
		roll = roll - CasterChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #CasterChain
end

----

function EXILE_M:CasterUpdate(entity)

	if entity.Variant == Isaac.GetEntityVariantByName("Dark Caster") then
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local ang = player.Position - entity.Position
	local room = game:GetRoom()
	
	if data.Dirvect == nil then 
	data.pos1 = 0 
	data.Dirvect = 0 
	end
	
	entity.DepthOffset = 55;
	
	if data.State == nil then data.State = 0 end
	if data.AttacksBeforeProt == nil then data.AttacksBeforeProt = 0 end
	if data.CurrentVel == nil then data.CurrentVel = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	if data.Spat == nil then data.Spat = 0 end
	if data.AttacksDone == nil then data.AttacksDone = 0 end
	local target = entity:GetPlayerTarget()
	
	if data.SlipperinessMultiplier == nil then data.SlipperinessMultiplier = 0.87 end
	if data.SpeedMultiplier == nil then data.SpeedMultiplier = 0.97 end
	
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	
	data.StateFrame = data.StateFrame + 1
	
	
	if data.State == CasterState.APPEAR and entity:GetSprite():IsFinished("Appear") then
	data.CurrentVel = 3.3
	
	local candle = Isaac.Spawn(EntityType.DARKCASTER,Isaac.GetEntityVariantByName("Caster Candle"),0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
	candle:GetData().HasParent = true
	candle:GetData().Spawner = entity
	candle:GetData().DistanceOut = 1.16
	candle:GetData().DistanceRad = 5
	candle.DepthOffset = 35
	candle:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	entity.Child = candle
	
	local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, candle.Position, Vector(0,0), candle)
	light:SetColor(Color(10, 0, 50, 1, 6, 0, 0),0,1,false,false)
	light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light:GetSprite():LoadGraphics()
	light:GetData().lightSpawnerEntity = candle
	light:GetData().CustomLight = true
	light:GetData().SpriteScale = Vector(1.04,1.04)
	candle:GetData().SpawnedLight = 1
	
	
	
		entity.Child:GetData().DecidedPos = nil
	data.State = CasterState.IDLEPROTECTED
	data.StateFrame = 0
	elseif data.State == CasterState.IDLE then ----------------------------------
	entity.Velocity = entity.Velocity * data.SlipperinessMultiplier + (target.Position-entity.Position):Resized(data.SpeedMultiplier)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		if data.StateFrame == 1 then
			entity:GetSprite():Play("Idle", true)
			data.CurrentVel = 4.15
		elseif entity:GetSprite():IsEventTriggered("Afterimage") then
			Isaac.Spawn(EntityType.CAFTERIMAGE, 13721, 0, entity.Position, Vector(0,0), entity)
		elseif entity:GetSprite():IsFinished("Idle") then
			if data.AttacksDone > 5 then
			data.State = CasterState.GETCANDLE
			data.StateFrame = 0
			else
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
			end
		end
		---------------------- NEW STUFF
	elseif data.State == CasterState.IDLEPROTECTED then ----------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		if data.StateFrame == 1 then
		entity.Child:GetData().DecidedPos = nil
			entity:GetSprite():Play("IdleProtected", true)
			data.CurrentVel = 4
		elseif entity:GetSprite():IsEventTriggered("Afterimage") then
			Isaac.Spawn(EntityType.CAFTERIMAGE, 13721, 0, entity.Position, Vector(0,0), entity)
		elseif entity:GetSprite():IsFinished("IdleProtected") then
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == CasterState.GETCANDLE then ----------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		if data.StateFrame == 1 then
			entity:GetSprite():Play("GetCandle", true)
			data.CurrentVel = 0
		elseif entity:GetSprite():GetFrame() == 45 then
	local candle = Isaac.Spawn(EntityType.DARKCASTER,Isaac.GetEntityVariantByName("Caster Candle"),0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
	candle:GetData().HasParent = true
	candle:GetData().Spawner = entity
	candle:GetData().DistanceOut = 1.16
	candle:GetData().DistanceRad = 5
	candle.DepthOffset = 35
	candle:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	entity.Child = candle
	
	local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, candle.Position, Vector(0,0), candle)
	light:SetColor(Color(10, 0, 50, 1, 6, 0, 0),0,1,false,false)
	light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light:GetSprite():LoadGraphics()
	light:GetData().lightSpawnerEntity = candle
	light:GetData().CustomLight = true
	light:GetData().SpriteScale = Vector(1.04,1.04)
	candle:GetData().SpawnedLight = 1
		elseif entity:GetSprite():IsFinished("GetCandle") then
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == CasterState.SMASHPROTECTED then ---------------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("SmashProtected", true)
		entity.Position = Vector(320,270)
		sound:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,1)
	elseif entity:GetSprite():GetFrame() == 46 then
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1.1)
	elseif entity:GetSprite():IsEventTriggered("Smash") then
		local lefty = Isaac.Spawn(EntityType.DARKFIST,0,0,entity.Position + Vector(-150,0) ,Vector(0,0),entity)
		local righty = Isaac.Spawn(EntityType.DARKFIST,0,0,entity.Position + Vector(150,0) ,Vector(0,0),entity)
		righty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		lefty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		lefty.FlipX = true
	elseif entity:GetSprite():IsFinished("SmashProtected") then
			data.State = CasterTransition(data.State)
			data.CurrentVel = 3.3
			data.StateFrame = 0
		end
	elseif data.State == CasterState.FIRELASERS then ---------------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("SuperFires", true)
		entity.Position = Vector(320,270)
		sound:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,1)
	elseif entity:GetSprite():GetFrame() > 31 and entity:GetSprite():GetFrame() < 60 then
		if entity:IsFrame(5,0) then
		entity:PlaySound(SoundEffect.SOUND_FIREDEATH_HISS,1.1,0,false,1)
		local fire = Isaac.Spawn(EntityType.ENTITY_FIREPLACE,3,0,Isaac.GetRandomPosition(),Vector(0,0),entity)
		Isaac.Spawn(EntityType.ENTITY_EFFECT,15,0,fire.Position, Vector(0,0), fire)
		fire:GetData().CasterFire = true
		end
		elseif entity:GetSprite():GetFrame() == 82 then
			entity:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0,1.1,0,false,1)
		
		elseif entity:GetSprite():IsEventTriggered("Smash") then
		Game():ShakeScreen(12,12)
		local vials = Isaac.FindByType(EntityType.ENTITY_FIREPLACE, 3, -1, true, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		local edata = tear:GetData()
			if edata.CasterFire == true then
			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,tear.Position + Vector(0,0) ,Vector(0,7),tear):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,tear.Position + Vector(0,0) ,Vector(0,-7),tear):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,tear.Position + Vector(0,0) ,Vector(7,0),tear):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,tear.Position + Vector(0,0) ,Vector(-7,0),tear):ToProjectile()
			Isaac.Explode(tear.Position, tear, 0)
			tear:Remove()
			sound:Play(SoundEffect.SOUND_DEATH_CARD,1,0,false,1)
			end
		end
	elseif entity:GetSprite():IsFinished("SuperFires") then
			data.State = CasterTransition(data.State)
			data.CurrentVel = 3.3
			data.StateFrame = 0
		end
	elseif data.State == CasterState.CANDLESPIT then ----------------------------------
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		data.pos1 = entity.Position - entity.Child.Position
		data.Dirvect = data.pos1:GetAngleDegrees()
		
		if data.StateFrame == 1 then
		data.Spat = 0
		entity.Child:GetData().DecidedPos = entity.Child.Position
			entity:GetSprite():Play("IdleProtected", true)
				entity.Child:GetData().State = 2
			data.CurrentVel = 1.5
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 120, 13)
		entity.Position = teleportPosition
		sound:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,1)
	
		
		elseif entity:IsFrame(6,0)then
			Isaac.Spawn(EntityType.CAFTERIMAGE, 13721, 0, entity.Position, Vector(0,0), entity)
	
		elseif entity:GetSprite():IsFinished("IdleProtected") then	
			entity:GetSprite():Play("Spit", true)
			
		elseif entity:GetSprite():IsEventTriggered("Spit") then
		local vials = Isaac.FindByType(EntityType.DARKCASTER, Isaac.GetEntityVariantByName("Caster Candle"), -1, false, false) 
		for _, candle in ipairs(vials) do
			local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(candle.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
			sound:Play(SoundEffect.SOUND_LITTLE_HORN_COUGH,1.15,0,false,1)
			Projectile:GetData().CandleBurst = true
			Projectile.CollisionDamage = 0.5
			Projectile.Scale = 1.8
			Projectile.DepthOffset = 50
			Projectile.Height = -20
		end

		elseif entity:GetSprite():IsEventTriggered("SpitL") then
		local vials = Isaac.FindByType(EntityType.DARKCASTER, Isaac.GetEntityVariantByName("Caster Candle"), -1, false, false) 
		for _, candle in ipairs(vials) do
			local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(candle.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
			sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_1,1.15,0,false,1)
			Projectile:GetData().CandleBurst2 = true
			Projectile.CollisionDamage = 0.5
			Projectile.Scale = 2.2
			Projectile.DepthOffset = 50
			Projectile.Height = -20
		end
		
		elseif entity:GetSprite():IsFinished("Spit") then
			if data.Spat < 5 then
			data.Spat = data.Spat + 1
			entity:GetSprite():Play("Spit", true)
			else
			entity:GetSprite():Play("CandleSpitLaser", true)
			end
			
		elseif entity:GetSprite():IsFinished("CandleSpitLaser") then
			entity.Child:GetData().State = 0
			data.State = CasterState.FIRELASERS
			data.StateFrame = 0		
		end		
	elseif data.State == CasterState.THROWOUT then ---------------------------------------------
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("ThrowOut", true)
		sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
	elseif entity:GetSprite():GetFrame() > 30 and entity:GetSprite():GetFrame() < 70 then
	Isaac.Spawn(EntityType.CAFTERIMAGE, Isaac.GetEntityVariantByName("Candle Afterimage"), 0, entity.Child.Position, Vector(0,0), entity.Child)
				sound:Play(Sounds.FIRELIGHT,2,0,false,1)
	Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Child.Position + Vector(0,0) ,Vector(0,0),entity.Child)
	entity.Child:GetData().DistanceRad = entity.Child:GetData().DistanceRad + 0.4
	entity.Child:GetData().DistanceOut = entity.Child:GetData().DistanceOut + 0.15
	elseif entity:GetSprite():GetFrame() > 75 and entity:GetSprite():GetFrame() < 97 then
	entity.Child:GetData().DistanceRad = entity.Child:GetData().DistanceRad - 0.5
	entity.Child:GetData().DistanceOut = entity.Child:GetData().DistanceOut - 0.2
	elseif entity:GetSprite():IsEventTriggered("Smash") then
	entity.Child:GetData().DistanceRad = 5
	entity.Child:GetData().DistanceOut = 1.16
	elseif entity:GetSprite():IsFinished("ThrowOut") then
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == CasterState.CANDLEDIE then ---------------------------------------------
		entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		local vials = Isaac.FindByType(EntityType.ENTITY_FIREPLACE, 3, -1, true, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		local edata = tear:GetData()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,15,0,tear.Position, Vector(0,0), tear)
			tear:Remove()
		end		

		data.AttacksDone = 0
		data.CurrentVel = 0
		entity:GetSprite():Play("Angry", true)
	elseif entity:GetSprite():IsEventTriggered("Spit") then
		entity:PlaySound(SoundEffect.SOUND_CUTE_GRUNT,1.15,0,false,1)
	elseif entity:GetSprite():IsFinished("Angry") then
			data.State = CasterState.IDLE
			data.StateFrame = 0
		end
	elseif data.State == CasterState.DARKNESSPROTECTED then ---------------------------------------------
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		if entity.Child:Exists() then
		entity.Child:GetData().State = 1
		end
		entity:GetSprite():Play("DarknessProtected", true)
		sound:Play(Sounds.HAZELLAUGH,1,0,false,1)	
	elseif entity:GetSprite():IsEventTriggered("Darkness") then
	data.CurrentVel = 4.7
	Game():ShakeScreen(12,5)
	Game():Darken(1,123)
	sound:Play(Sounds.DARKSPELL,2,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Hallucinate") then
		Isaac.Spawn(EntityType.CEYES, 23743, 0, Isaac.GetRandomPosition(12), Vector(0,0), entity)
		Isaac.Spawn(EntityType.CEYES, 23743, 0, Isaac.GetRandomPosition(33), Vector(0,0), entity)
	elseif entity:GetSprite():IsFinished("DarknessProtected") then
	if entity.Child:Exists() then
		entity.Child:GetData().State = 0
		end
			data.State = CasterTransition(data.State)
			data.CurrentVel = 3.3
			data.StateFrame = 0
		end		
		--------
	elseif data.State == CasterState.FIRES1 then -------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.AttacksDone = data.AttacksDone + 1
			entity:GetSprite():Play("Fires1", true)
			data.CurrentVel = 1.1
	elseif entity:GetSprite():GetFrame() == 32 then
		sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
		sound:Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("FireCross") then
			sound:Play(Sounds.FIRELIGHT,2,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)
	elseif entity:GetSprite():IsEventTriggered("FireDiag") then
			sound:Play(Sounds.FIRELIGHT,2,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	elseif entity:GetSprite():IsFinished("Fires1") then
			if data.AttacksDone > 5 then
			data.State = CasterState.GETCANDLE
			data.StateFrame = 0
			else
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
			end
		end
	elseif data.State == CasterState.FIRES2 then ---------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
			data.CurrentVel = 1.1
			data.AttacksDone = data.AttacksDone + 1
			entity:GetSprite():Play("Fires2", true)
			sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
	elseif entity:GetSprite():GetFrame() == 35 then
	sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1.2)
	elseif entity:GetSprite():IsEventTriggered("FireCross") then
		sound:Play(Sounds.FIRELIGHT,2,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)
	elseif entity:GetSprite():IsEventTriggered("FireDiag") then
		sound:Play(Sounds.FIRELIGHT,2,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,11),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,-11),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(11,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-11,0),entity)
		elseif entity:GetSprite():IsFinished("Fires2") then
			if data.AttacksDone > 5 then
			data.State = CasterState.GETCANDLE
			data.StateFrame = 0
			else
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
			end
		end
	elseif data.State == CasterState.SMASH then ---------------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.AttacksDone = data.AttacksDone + 1
		data.CurrentVel = 0
		entity:GetSprite():Play("Smash", true)
		entity.Position = Vector(320,270)
		sound:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,1)
	elseif entity:GetSprite():GetFrame() == 46 then
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1.1)
	elseif entity:GetSprite():IsEventTriggered("Smash") then
		local lefty = Isaac.Spawn(EntityType.DARKFIST,0,0,entity.Position + Vector(-150,0) ,Vector(0,0),entity)
		local righty = Isaac.Spawn(EntityType.DARKFIST,0,0,entity.Position + Vector(150,0) ,Vector(0,0),entity)
		righty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		lefty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		lefty.FlipX = true
	elseif entity:GetSprite():IsFinished("Smash") then
			if data.AttacksDone > 5 then
			data.State = CasterState.GETCANDLE
			data.StateFrame = 0
			else
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
			end
		end
	elseif data.State == CasterState.DARKNESS then ---------------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.AttacksDone = data.AttacksDone + 1
		data.CurrentVel = 0
		entity:GetSprite():Play("Darkness", true)
		sound:Play(Sounds.HAZELLAUGH,1,0,false,1)	
	elseif entity:GetSprite():IsEventTriggered("Darkness") then
		local LaserBR1 = EntityLaser.ShootAngle(1, room:GetBottomRightPos(), -90,
		123, Vector(0,0), entity)
		LaserBR1.DisableFollowParent = true
		LaserBR1:SetColor(Color(1,1,1,1,25,0,150),0,0,false,false)
		
		local LaserBR2 = EntityLaser.ShootAngle(1, room:GetBottomRightPos(), -180,
		123, Vector(0,0), entity)
		LaserBR2.DisableFollowParent = true
		LaserBR2:SetColor(Color(1,1,1,1,25,0,150),0,0,false,false)
		
		local LaserTL1 = EntityLaser.ShootAngle(1, room:GetTopLeftPos(), 0,
		123, Vector(0,0), entity)
		LaserTL1.DisableFollowParent = true
		LaserTL1:SetColor(Color(1,1,1,1,25,0,150),0,0,false,false)
		
		local LaserTL2 = EntityLaser.ShootAngle(1, room:GetTopLeftPos(), 90,
		123, Vector(0,0), entity)
		LaserTL2.DisableFollowParent = true
		LaserTL2:SetColor(Color(1,1,1,1,25,0,150),0,0,false,false)

		sound:Play(SoundEffect.SOUND_GHOST_ROAR,1.12,60,false,0.7)
	data.CurrentVel = 5.6
	Game():ShakeScreen(13,13)
	Game():Darken(1,123)
	sound:Play(Sounds.DARKSPELL,1.2,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Hallucinate") then
		Isaac.Spawn(EntityType.CEYES, 23743, 0, Isaac.GetRandomPosition(12), Vector(0,0), entity)
		Isaac.Spawn(EntityType.CEYES, 23743, 0, Isaac.GetRandomPosition(33), Vector(0,0), entity)
	elseif entity:GetSprite():IsFinished("Darkness") then
			if data.AttacksDone > 5 then
			data.State = CasterState.GETCANDLE
			data.StateFrame = 0
			else
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
			end
		end
	elseif data.State == CasterState.TELEPORT then --------- unused attack ------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.CurrentVel = 0
		entity:GetSprite():Play("Teleport", true)
	elseif entity:GetSprite():IsEventTriggered("Teleport") then
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 185, 13)
		entity.Position = teleportPosition
		sound:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,1)
	elseif entity:GetSprite():IsFinished("Teleport") then
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == CasterState.SWORD then -------------------------------------
	entity.Velocity = (target.Position - entity.Position):Normalized() * data.CurrentVel
		if data.StateFrame == 1 then
		data.AttacksDone = data.AttacksDone + 1
			entity:GetSprite():Play("Sword", true)
			data.CurrentVel = 0
	elseif entity:GetSprite():GetFrame() == 2 then
		sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
	elseif entity:GetSprite():GetFrame() == 49 then
		sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
		sound:Play(Sounds.SWORDBEAM,1,0,false,1.7)
	elseif entity:GetSprite():IsEventTriggered("FireCross") then
		sound:Play(Sounds.SWORDBEAM,1,0,false,1)
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,2,0,false,0.3)
		Game():ShakeScreen(8)
		local Projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 9.2,entity):ToProjectile()
		Projectile.Scale = 1
		Projectile.ProjectileFlags = ProjectileFlags.SMART
		Projectile.HomingStrength = 3
	--	Projectile.FallingAccel = -0.085
		Projectile.Height = -33
		Projectile:GetData().RockProj = true
	elseif entity:GetSprite():IsEventTriggered("FireDiag") then
		local playerpos = player.Position.Y
		local posy = entity.Position.Y
		sound:Play(Sounds.SWORDBEAM,1.1,0,false,0.6)
			sound:Play(SoundEffect.SOUND_SHELLGAME,1.2,0,false,0.8)
	    for i = -30, 30, 30 do
                    local p = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 2, 0, entity.Position, (entity:GetPlayerTarget().Position - entity.Position):Resized(7.5):Rotated(i):Normalized() * 13, entity):ToProjectile()
                  --  p.FallingSpeed = -3
                   -- p.FallingAccel = 0.05
					--p.ProjectileFlags = ProjectileFlags.SMART
                end
	elseif entity:GetSprite():IsFinished("Sword") then
			if data.AttacksDone > 5 then
			data.State = CasterState.GETCANDLE
			data.StateFrame = 0
			else
			data.State = CasterTransition(data.State)
			data.StateFrame = 0
			end
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.CasterUpdate, EntityType.DARKCASTER);

function EXILE_M:CandleDeath(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Caster Candle") then
		local vials = Isaac.FindByType(EntityType.DARKCASTER, Isaac.GetEntityVariantByName("Dark Caster"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		tear:GetData().State = CasterState.CANDLEDIE
		tear:GetData().StateFrame = 0
		end	
	Isaac.Explode(entity.Position, entity, 0)
	entity:PlaySound(SoundEffect.SOUND_FIREDEATH_HISS,1.05,0,false,0.94)

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,7),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,-7),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,0),entity):ToProjectile()
		
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.CandleDeath, EntityType.DARKCASTER);

function EXILE_M:CandleOrbit(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Caster Candle") then
	
	entity.DepthOffset = -10
	
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	
	if entity:GetData().HasParent == true then
    if entity:GetData().Degrees == nil then entity:GetData().Degrees = 0 end
    if entity:GetData().Radius == nil then entity:GetData().Radius = 0 end
    if entity:GetData().State == nil then entity:GetData().State = 0 end
    if entity:GetData().StateFrame == nil then entity:GetData().StateFrame = 0 end
	
	if entity:GetData().State == 0 then
	

	
	if not sprite:IsPlaying("IdleLit") then
	sprite:Play("IdleLit", true)
	end
	
	
	
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	
	entity:GetSprite().FlipX = false
    entity:GetData().Degrees = entity:GetData().Degrees + entity:GetData().DistanceRad
    entity:GetData().Radius = 40 * entity:GetData().DistanceOut
    if entity:GetData().Degrees >= 360 then entity:GetData().Degrees = 0 end
    if entity:GetData().Degrees <= -360 then entity:GetData().Degrees = 0 end
    for i = 0, Isaac.CountEntities(entity, EntityType.DARKCASTER, Isaac.GetEntityVariantByName("Caster Candle"), -1) do
        local spawner = entity:GetData().Spawner
        local direction = Vector.FromAngle(entity:GetData().Degrees):Normalized()
        entity:GetData().NewPos = spawner.Position + direction * entity:GetData().Radius
        entity.Velocity = -(entity.Position - entity:GetData().NewPos)/4
		if entity:IsFrame(4,0) then
		Isaac.Spawn(EntityType.CAFTERIMAGE, Isaac.GetEntityVariantByName("Candle Afterimage"), 0, entity.Position, Vector(0,0), entity)
		end
	end
	if entity:GetData().Spawner:IsDead() then
	entity:Remove()
	end
		
	end
	
	if entity:GetData().State == 2 then
	entity:GetData().Degrees = 0
    entity:GetData().Radius = 0
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

	if not sprite:IsPlaying("Attack") then
	sprite:Play("Attack", true)
	end	


	local diagonals = {
    Vector(1, 1):Normalized(),
    Vector(-1, 1):Normalized(),
    Vector(1, -1):Normalized(),
    Vector(-1, -1):Normalized()
	}

		local vel = entity.Velocity:Normalized()
        local closestDir
        local dist
        for _, direction in ipairs(diagonals) do
            local distance = vel:Distance(direction)
            if not dist or distance < dist then
                closestDir = direction
                dist = distance
            end
        end
		
		entity.Velocity = closestDir:Resized(2.1)
		
		if entity:IsFrame(4,0) then
		Isaac.Spawn(EntityType.CAFTERIMAGE, Isaac.GetEntityVariantByName("Candle Afterimage"), 0, entity.Position, Vector(0,0), entity)
		end
	
		local vials = Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false) 
		for _, tear in ipairs(vials) do
		local edata = tear:GetData()
		if edata.CandleBurst == true then
		if tear.Position:Distance(entity.Position) < 46 then
			for i = -16, 16, 16 do
            local p = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 2, 0, entity.Position + Vector(0,1), (entity:GetPlayerTarget().Position - entity.Position):Resized(7.5):Rotated(i):Normalized() * 11, entity):ToProjectile()
			
			end
		--	sound:Play(SoundEffect.SOUND_FIRE_RUSH,1.1,0,false,1)
			sound:Play(SoundEffect.SOUND_STEAM_HALFSEC,1.2,0,false,1)
			tear:Die()
			
		end
		end
		
		if edata.CandleBurst2 == true then
		if tear.Position:Distance(entity.Position) < 46 then
				for Angle = 0, 0 + 270, 90 do
					local HolyLaser = EntityLaser.ShootAngle(1, entity.Position, Angle,
					16, Vector(0,0), entity)
				end
		--	sound:Play(SoundEffect.SOUND_FIRE_RUSH,1.1,0,false,1)
			sound:Play(SoundEffect.SOUND_STEAM_HALFSEC,1.2,0,false,1)
			tear:Die()

			
		end
		end
		
	end 

	end
	
	if entity:GetData().State == 1 then
	entity:GetData().Degrees = 0
    entity:GetData().Radius = 0
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	
	if not sprite:IsPlaying("Attack") then
	sprite:Play("Attack", true)
	end
	
	if entity:IsFrame(24,0) then
		sound:Play(SoundEffect.SOUND_FIRE_RUSH,1.1,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,0),entity)
	end
	
	local diagonals = {
    Vector(1, 1):Normalized(),
    Vector(-1, 1):Normalized(),
    Vector(1, -1):Normalized(),
    Vector(-1, -1):Normalized()
	}

		local vel = entity.Velocity:Normalized()
        local closestDir
        local dist
        for _, direction in ipairs(diagonals) do
            local distance = vel:Distance(direction)
            if not dist or distance < dist then
                closestDir = direction
                dist = distance
            end
        end
		
		entity.Velocity = closestDir:Resized(6)
	
	
	end
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.CandleOrbit, EntityType.DARKCASTER);

function EXILE_M:RockProjUpdate()
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false)) do
			local data = entity:GetData()
			if entity.Type == EntityType.ENTITY_PROJECTILE
			and Isaac.GetFrameCount() % math.floor(3.6 / 1) == 0 and data.RockProj == true then
					entity:SetColor(Color(0,0,0,0,0,0,0),0,0,false,false)
					entity.Velocity.Y = entity.Velocity.Y + (math.random() - 0.4) + 1
					entity.Velocity.X = entity.Velocity.X + (math.random() - 0.4) + 1
					entity.Visible = false
					sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.6,0,false,1)
					if data.Variant == nil then data.Variant = EffectVariant.ROCK_EXPLOSION end
					local rock = Game():Spawn(EntityType.ENTITY_EFFECT,data.Variant, entity.Position, Vector(0,0), player, 0, 0)
					Game():BombDamage(rock.Position, 1, 12, false, entity, 0, 0, false)
					Game():BombDamage(entity.Position, 1, 6, false, entity, 0, 0, false)
					Game():ShakeScreen(3)
				end
		end
end
----sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.6,0,false,1.3)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.RockProjUpdate);

function EXILE_M:TarProjUpdate()
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false)) do
			local data = entity:GetData()
			if entity.Type == EntityType.ENTITY_PROJECTILE
			and Isaac.GetFrameCount() % math.floor(3.6 / 1) == 0 and data.TarProj == true then
					entity:SetColor(Color(0,0,0,0,0,0,0),0,0,false,false)
					entity.Velocity.Y = entity.Velocity.Y + (math.random() - 0.4) + 1
					entity.Velocity.X = entity.Velocity.X + (math.random() - 0.4) + 1
					entity.Visible = false
					local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0,entity.Position, Vector(0,0), entity)
					local effect = creep:ToEffect()
					effect.Scale = math.random(2,4)
						Game():ShakeScreen(4)
				end
		end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.TarProjUpdate);

function EXILE_M:PoisonProjUpdate()
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false)) do
			local data = entity:GetData()
			if entity.Type == EntityType.ENTITY_PROJECTILE
			and Isaac.GetFrameCount() % math.floor(3.6 / 1) == 0 and data.PoisonProj == true then
					entity:SetColor(Color(0,0,0,0,0,0,0),0,0,false,false)
					entity.Velocity.Y = entity.Velocity.Y + (math.random() - 0.4) + 1
					entity.Velocity.X = entity.Velocity.X + (math.random() - 0.4) + 1
					entity.Visible = false
					local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, entity.Position, Vector(0,0), entity)
					local effect = creep:ToEffect()
					creep:SetColor(Color(0,20,0,1,0,0,0),0,0,false,false)
					Game():ShakeScreen(3)
				end
		end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.PoisonProjUpdate);

function EXILE_M:GeyserJetUpdate(entity)
	local projectile_params = ProjectileParams()
			projectile_params.Color = Color(0,2,60,1,0, 0, 0, 7, 1, false, false)
			projectile_params.HeightModifier = projectile_params.HeightModifier - 100
			projectile_params.FallingAccelModifier = 1
			projectile_params.FallingSpeedModifier = 1
		   projectile_params.GridCollision = true;
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local Nearby = Isaac.GetFreeNearPosition(player.Position, 30)
	
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	
	if not entity:GetSprite():IsPlaying("Jet", true) then
	sound:Play(Sounds.SPLASH_WATER,1,0,false,1)
	entity:GetSprite():Play("Jet", true)
		elseif entity:GetSprite():IsEventTriggered("Tear") then
			--local rain = entity:FireProjectiles(player.Position, Vector(0,1), 1, projectile_params)
		for i = 1, math.random(1, 2) do
			if entity:GetData().projvecX == nil then entity:GetData().projvecX = Vector(0, 0) end
				if entity:GetData().projvecY == nil then entity:GetData().projvecY = Vector(0, 0) end
				entity:GetData().projvecX = math.random(-1, 1)
				entity:GetData().projvecY = math.random(-1, 1)
				local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((Vector(entity:GetData().projvecX, entity:GetData().projvecY):Resized(7.75)):Rotated(math.random(-4,4)) * (math.random(60, 120) / 210)), entity, 0, 0):ToProjectile()
				Projectile.FallingAccel = 1.4
				Projectile.FallingSpeed = 1.2
				Projectile.Scale = (math.random(100,170))/80
				Projectile.Height = -265
				Projectile.ProjectileFlags = ProjectileFlags.HIT_ENEMIES
			end
		elseif entity:GetSprite():IsEventTriggered("Death") then
			entity:Remove()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.GeyserJetUpdate, EntityType.GEYSER)

function EXILE_M:CrusherUpdate(entity)
	local game = Game()
	local room = game:GetRoom()
	if entity.Variant == Isaac.GetEntityVariantByName("Big Crusher") then
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity.DepthOffset = 23
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
	if entity:GetSprite():IsPlaying("Idle", true) then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
	
	if not entity:GetSprite():IsPlaying("Crush", true) then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:GetSprite():Play("Crush", true)
	elseif entity:GetSprite():IsEventTriggered("Impact") then
	local explosions = Isaac.FindByType(Isaac.GetEntityTypeByName("Boulder Globin Mass"), Isaac.GetEntityVariantByName("Boulder Globin Mass"), -1, false, false)
		for _, explosion in ipairs(explosions) do
		if explosion.Position:Distance(entity.Position) < 40 then
		explosion:Die()
		--
		end
		end
		Game():ShakeScreen(14,5)
		Game():BombDamage(entity.Position, 100, 43, false, nil, 0, 0, false)
		--Isaac.Explode(entity.Position, entity, 2)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.8,0,false,0.7)
		if room:HasWater() then
		for i = 1, math.random(6, 8) do
			if entity:GetData().projvecX == nil then entity:GetData().projvecX = Vector(0, 0) end
				if entity:GetData().projvecY == nil then entity:GetData().projvecY = Vector(0, 0) end
				entity:GetData().projvecX = (math.random(-100, 100))/50
				entity:GetData().projvecY = (math.random(-70, 100))/45
				local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((Vector(entity:GetData().projvecX, entity:GetData().projvecY):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(60, 120) / 100)), entity, 0, 0):ToProjectile()
				Projectile.FallingAccel = (math.random(4, 6)/10)
				Projectile.FallingSpeed = -(math.random(70, 80)/10)
				Projectile.Scale = (math.random(100,170))/75
				Projectile.Height = -3
				--Projectile.ProjectileFlags = ProjectileFlags.HIT_ENEMIES
			end
		end
		elseif entity:GetSprite():GetFrame() > 39 and entity:GetSprite():GetFrame() < 73 then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():GetFrame() > 73 then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		end
	end
end
 
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.CrusherUpdate, EntityType.BIGCRUSHER)

function EXILE_M:BoulderGBoulderUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	
	if data.TimesRolled == nil then data.TimesRolled = 0 end
	

	
	if data.TimesRolled < 4 and not entity:GetSprite():IsPlaying("Idle", true) then
	entity:GetSprite():Play("Idle", true)
	elseif entity:GetSprite():IsEventTriggered("Rolled") then
	data.TimesRolled = data.TimesRolled + 1
	elseif entity:GetSprite():IsEventTriggered("Rolling") then
	sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,0.5)
	entity.Velocity = (target.Position - entity.Position):Normalized() * 13
	end
	if data.TimesRolled == 4 and not entity:GetSprite():IsPlaying("Crush", true) then
	entity:GetSprite():Play("Crush", true)
	end
	if entity:GetSprite():IsEventTriggered("Impact") then
		Game():ShakeScreen(14,5)
		Isaac.Explode(entity.Position, entity, 0)
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
		entity:Remove()
	end
end
 
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BoulderGBoulderUpdate, EntityType.BOULDERGBOULDER)

function EXILE_M:BellHazardUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	if data.Descended == nil then data.Descended = false end
	if data.Ascended == nil then data.Ascended = false end
	if data.Rung == nil then data.Rung = false end
	
	if EXILE_M.BellsDown and not entity:GetSprite():IsPlaying("Descend") then
		if data.Descended == false then
		entity:GetSprite():Play("Descend", false)
	data.Ascended = false
	data.Rung = false
	data.Descended = false
		end
	end
	if EXILE_M.BellsDown and data.Descended == true and not data.Rung and data.Ascended == false and not entity:GetSprite():IsPlaying("Idle") and not entity:GetSprite():IsPlaying("Ring") then
	entity:GetSprite():Play("Idle", true)
	entity:GetSprite().FlipX = false
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	end
	if EXILE_M.BellsDown and data.Descended == true and data.Ascended == false and data.Rung == true and not entity:GetSprite():IsPlaying("Ring")
	and not entity:GetSprite():IsPlaying("Ascend") then
	entity:GetSprite().FlipX = (entity.Position.X < target.Position.X)
	entity:GetSprite():Play("Ring", false)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
	if not EXILE_M.BellsDown and not entity:GetSprite():IsPlaying("Invisible") then
	entity:GetSprite():Play("Invisible", true)
	data.Ascended = false
	data.Descended = false
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
	if entity:GetSprite():IsFinished("Descend") then
		data.Descended = true
	end
	if entity:GetSprite():IsFinished("Ring") and data.Ascended == false then
		entity:GetSprite():Play("Ascend", true)
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		EXILE_M.BellsReturn = true
		data.Ascended = true
	end
	if EXILE_M.BellsReturn and not entity:GetSprite():IsPlaying("Ascend") and data.Ascended == false then -- all bells retract when one is rung
		entity:GetSprite():Play("Ascend", true)
		data.Ascended = true
	end
	if entity:GetSprite():IsFinished("Ascend") then
	if data.Rung == true then
	EXILE_M.BellsReturn = false
	EXILE_M.BellsDown = false
	end
	if not data.Rung == true then
	local newbell = Isaac.Spawn(EntityType.BELLHAZARD, 0, 0, entity.Position, Vector(0,0), nil)
	newbell:GetData().Ascended = false
	newbell:GetData().Descended = false
	newbell:GetData().Rung = false
	end
	entity:Remove()
	end
	if EXILE_M.BellsDown and entity:GetSprite():IsPlaying("Idle") and EXILE_M.BellsReturn == false then
		for _, rock in pairs(Isaac.FindByType(EntityType.BOULDERGBOULDER, 0, 0, false, false)) do
			local rockdata = rock:GetData()
			if rock.Position:Distance(entity.Position) < 48 then
			data.Rung = true
			EXILE_M.BellRung = true
			Isaac.Explode(rock.Position, rock, 0)
			rock:Remove()
			
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(5,5),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-5,5),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(5,-5),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-5,-5),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,7),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-7),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,0),entity):ToProjectile()			

			end
	
	end
	end
	
	if entity:GetSprite():IsEventTriggered("Gears") then
		sound:Play(Sounds.GEARSPIN,1,0,false,1)
	end
	
	if entity:GetSprite():IsEventTriggered("Retract") then
		sound:Play(Sounds.GEARSLOCK,1.2,0,false,1)	
	end
	
	if entity:GetSprite():IsEventTriggered("Ring") then
		sound:Play(Sounds.BELLRING,1.25,0,false,1)
		Game():ShakeScreen(14,5)
	end
	
	
end
 
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BellHazardUpdate, EntityType.BELLHAZARD)

function EXILE_M:AirpipeUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Air Pipe") then
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local BombX = entity.Position.X
	local BombY = entity.Position.Y + 45
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	
	if not entity:GetSprite():IsPlaying("Active", true) then
		entity:GetSprite():Play("Active", true)
	elseif entity:GetSprite():IsEventTriggered("Hiss") then
		sound:Play(Sounds.AIR_HISS,1,0,false,1)
	elseif entity:GetSprite():GetFrame() < 17 then
		Game():BombDamage(Vector(BombX,BombY), 15, 40, false, entity, 0, 0, false)
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.AirpipeUpdate, EntityType.AIRPIPE)

function EXILE_M:ClockworkCraneUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local BombX = entity.Position.X
	local BombY = entity.Position.Y + 45
	
	if entity.Variant == Isaac.GetEntityVariantByName("Clockwork Crane") then
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	if not entity:GetSprite():IsPlaying("LowerGaper", true) then
		entity:GetSprite():Play("LowerGaper", true)
		sound:Play(Sounds.CLOCKCRANE,1.5,0,false,1)
		game:ShakeScreen(12,12)
	elseif entity:GetSprite():IsEventTriggered("Gaper") then
		local gaper = Isaac.Spawn(EntityType.ENTITY_GAPER, 0, 0, entity.Position, Vector(0,0), entity)
	gaper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	elseif entity:GetSprite():IsEventTriggered("Remove") then
	entity:Remove()
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ClockworkCraneUpdate, EntityType.CLOCKWORKCRANE)



function EXILE_M:GearUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Clockwork Gear") then
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local BombX = entity.Position.X
	local BombY = entity.Position.Y + 45
	entity.DepthOffset = 99;
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	Game():ShakeScreen(2)
	
	local eff = entity:ToEffect()
	
	if not entity:GetSprite():IsPlaying("Idle", true) then
		entity:GetSprite():Play("Idle", true)
		if not sound:IsPlaying(Sounds.GEARTURN) then
		sound:Play(Sounds.GEARTURN,3.8,0,false,1)
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.GearUpdate, EntityType.GEAREFFECT)

function EXILE_M:MimicUpdate(entity, npc)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local npc = entity:ToNPC()
	if entity:GetSprite():IsFinished("Appear", true) then
		entity:GetSprite():Play("Jump", true)
	elseif entity:GetSprite():IsEventTriggered("Chest") then
		sound:Play(SoundEffect.SOUND_CHEST_DROP,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Jump") then
		entity:AddVelocity((target.Position - entity.Position):Normalized() * 6)
	if entity:IsDead() == true then
	Game():BombDamage(entity.Position, 15, 71, false, entity, 0, 0, false)
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.MimicUpdate, EntityType.CHESTMIMIC)

function EXILE_M:MonstroEXUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local Nearby = Isaac.GetFreeNearPosition(entity.Position, 10)
	local target = entity:GetPlayerTarget()
	if entity:GetSprite():IsFinished("Appear", true) then
	elseif entity:GetSprite():IsEventTriggered("Spawn") then
		local roll = math.random(1,9)
		if roll == 3 or roll == 4 then
			Isaac.Spawn(EntityType.MINISTROEX, 2212, 0, Nearby, Vector(0,0), entity)	
			Isaac.Spawn(EntityType.MINISTROEX, 2212, 0, Nearby, Vector(0,0), entity)
			sound:Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1)
		elseif roll == 5 or roll == 6 then
			Isaac.Spawn(EntityType.ENTITY_POOTER, 0, 0, Nearby, Vector(0,0), entity)	
			Isaac.Spawn(EntityType.ENTITY_POOTER, 0, 0, Nearby, Vector(0,0), entity)
			sound:Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1)
		else
		
		end
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
			Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	elseif entity:GetSprite():IsEventTriggered("Shoot2") then
		sound:Play(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 12,entity)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.MonstroEXUpdate, EntityType.MONSTROEX)

function EXILE_M:DarkFistUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	
	if not entity:GetSprite():IsPlaying("Smash", true) then
	entity:GetSprite():Play("Smash", true)
	elseif entity:GetSprite():IsEventTriggered("Impact") then
		Game():ShakeScreen(14,5)
		sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
		Game():Spawn(EntityType.ENTITY_EFFECT, 61, entity.Position, Vector(0,0), entity, 0, 0)
	elseif entity:GetSprite():IsEventTriggered("Remove") then
	entity:Remove()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.DarkFistUpdate, EntityType.DARKFIST)

function EXILE_M:LightningUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if not entity:GetSprite():IsPlaying("Idle", true) then
		sound:Play(Sounds.LIGHTNINGPEND,2.5,0,false,1)
		entity:GetSprite():Play("Idle", true)
	elseif entity:GetSprite():IsEventTriggered("Strike") then
	sound:Play(Sounds.LIGHTNINGSTRIKE,2.5,0,false,1)
	Game():ShakeScreen(6,6)
		Game():BombDamage(entity.Position, 100, 35, false, entity, 0, 0, false)
		Isaac.Explode(entity.Position, entity, 0)
	elseif entity:GetSprite():IsEventTriggered("Remove") then
	entity:Remove()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.LightningUpdate, EntityType.LIGHTNING)


function EXILE_M:onUpdateCorinthPosession(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_CORINTHCLOAK) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_CORINTHROBE)
		EXILE_M.HasCorinth = false
		end
	end
	if not EXILE_M.HasCorinth and player:HasCollectible(EXILE_M.COLLECTIBLE_CORINTHCLOAK) then
		player:AddNullCostume(EXILE_M.COSTUME_CORINTHROBE)
		EXILE_M.HasCorinth = true
	end
end

function EXILE_M:onUpdateTubercPosession(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_TUBERC) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_TUBERC)
		EXILE_M.HasTuberc = false
		end
	end
	if not EXILE_M.HasTuberc and player:HasCollectible(EXILE_M.COLLECTIBLE_TUBERC) then
		player:AddNullCostume(EXILE_M.COSTUME_TUBERC)
		EXILE_M.HasTuberc = true
	end
end

function EXILE_M:onUpdateCharmGreed(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_CHARMGREED) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_CHARMGREED)
		EXILE_M.HasCharm = false
		end
	end
	if not EXILE_M.HasCharm and player:HasCollectible(EXILE_M.COLLECTIBLE_CHARMGREED) then
		player:AddNullCostume(EXILE_M.COSTUME_CHARMGREED)
		EXILE_M.HasCharm = true
	end
end

function EXILE_M:onUpdateGolemPosession(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_AMBROSIA) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_GOLEMBODY)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_GOLEMHEAD)
		EXILE_M.HasGolem = false
		end
	end
	if not EXILE_M.HasGolem and player:HasCollectible(EXILE_M.COLLECTIBLE_AMBROSIA) then
		player:AddNullCostume(EXILE_M.COSTUME_GOLEMHEAD)
		player:AddNullCostume(EXILE_M.COSTUME_GOLEMBODY)
		EXILE_M.HasGolem = true
	end
end

function EXILE_M:OnRenderAgnes(player)
	if player:GetPlayerType() == Agnes_Char.PlayerType then
		player:AddNullCostume(EXILE_M.AGNESHAIR)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, EXILE_M.OnRenderAgnes)

function EXILE_M:onUpdateCreedPosession(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_CREED) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_CREEDBODY)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_CREEDHEAD)
		EXILE_M.HasCreed = false
		end
	end
	if not EXILE_M.HasCreed and player:HasCollectible(EXILE_M.COLLECTIBLE_CREED) then
		player:AddNullCostume(EXILE_M.COSTUME_CREEDBODY)
		player:AddNullCostume(EXILE_M.COSTUME_CREEDHEAD)
		EXILE_M.HasCreed = true
	end
end

function EXILE_M:onUpdateTwoFinger(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_TWOFINGER) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_TWOFINGERBODY)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_TWOFINGERHEAD)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_TWOFINGERGLOW)
		EXILE_M.HasTwofinger = false
		end
	end
	if not EXILE_M.HasTwofinger and player:HasCollectible(EXILE_M.COLLECTIBLE_TWOFINGER) then
		player:AddNullCostume(EXILE_M.COSTUME_TWOFINGERBODY)
		player:AddNullCostume(EXILE_M.COSTUME_TWOFINGERHEAD)
		player:AddNullCostume(EXILE_M.COSTUME_TWOFINGERGLOW)
		EXILE_M.HasTwofinger = true
	end
end


function EXILE_M:removeMeteor(player)
	if game:GetFrameCount() == 1 then
		MeteorEff:Stop()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.removeMeteor);

function EXILE_M:GetDirectionHead(player)
	local player = Isaac.GetPlayer(0)
	if player:GetFireDirection() == Direction.RIGHT then
	EXILE_M.HeadDirection = 0
	end
	if player:GetFireDirection() == Direction.UP then
	EXILE_M.HeadDirection = 270
	end
	if player:GetFireDirection() == Direction.DOWN then
	EXILE_M.HeadDirection = 90
	end
	if player:GetFireDirection() == Direction.LEFT then
	EXILE_M.HeadDirection = 180
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.GetDirectionHead);


function EXILE_M:RocksUpdate(player)
	local player = Isaac.GetPlayer(0)
	local damagebonus = player.Damage * 2
	local damagebonustear = player.Damage * 1.5
	if player:HasCollectible(EXILE_M.COLLECTIBLE_AMBROSIA) and not player:HasCollectible(EXILE_M.COLLECTIBLE_MISERICORDE) then
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR, -1, -1, false, false)) do
			local data = entity:GetData()
			local tear = entity:ToTear()
			if entity.Type == EntityType.ENTITY_TEAR and entity.Variant ~= TearVariant.INVISTEAR then
			tear:ChangeVariant(TearVariant.INVISTEAR)
			Game():ShakeScreen(3,2)
			sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.6,0,false,1.3)
			end
			if entity.Type == EntityType.ENTITY_TEAR
			and Isaac.GetFrameCount() % math.floor(3.6 / player.ShotSpeed) == 0 and entity.Variant == TearVariant.INVISTEAR then
					entity.Velocity.Y = entity.Velocity.Y + (math.random() - 0.4) + 1
					
					entity.Velocity.X = entity.Velocity.X + (math.random() - 0.4) + 1
					local rock = Game():Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ROCK_EXPLOSION, entity.Position, Vector(0,0), player, 0, 0)
					Game():BombDamage(rock.Position, damagebonus, 12, false, player, 0, 0, false)
					Game():BombDamage(entity.Position, damagebonustear, 6, false, player, 0, 0, false)
				end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.RocksUpdate);

---

function EXILE_M:HorusUpdate()
	local player = Isaac.GetPlayer(0)
	
	local dmgformula = player.Damage * 0.45
	
	if player:HasCollectible(EXILE_M.COLLECTIBLE_HORUS) then
	for _, enemy in pairs(Isaac.FindInRadius(player.Position, 35.4, EntityPartition.ENEMY)) do
		if enemy:IsActiveEnemy() and enemy.Position:Distance(player.Position) < 35.3 then
		enemy:TakeDamage(dmgformula,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
		end
	end
	end
	
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.HorusUpdate);


function EXILE_M:HorusPickupRoll(player)
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_HORUS) then
	if EXILE_M.HorusRoomClear == false then
		if room:IsFirstVisit() then
			if room:GetAliveEnemiesCount() == 0 then
			local roll = math.random(1,75)
				if roll > 60 then
				Game():ShakeScreen(12,12)
				local Nearby = Isaac.GetFreeNearPosition(player.Position, 40)
				sound:Play(Sounds.LIGHTNINGSTRIKE,1,0,false,1)
				local lightning = Isaac.Spawn(EntityType.LIGHTNINGEFF, 3232, 0, Nearby, Vector(0,0), nil)
				Isaac.Spawn(5,0,0,Nearby,Vector(0,0),nil)
				end
			EXILE_M.HorusRoomClear = true
		end
		
	end
	end
	end
end
				
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.HorusPickupRoll)

function EXILE_M:ResetRoomVariablesHorus()

local room = Game():GetRoom()
local player = Isaac.GetPlayer(0)
if game:GetFrameCount() > 9 then
if room:IsFirstVisit() and player:HasCollectible(EXILE_M.COLLECTIBLE_HORUS) then
	if room:GetAliveEnemiesCount() > 0 then
		EXILE_M.HorusRoomClear = false
	else
		EXILE_M.HorusRoomClear = true
		end
	end

end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetRoomVariablesHorus)

function EXILE_M:onUpdateHorusPosession(player)
	if game:GetFrameCount() == 1 then
		if not player:HasCollectible(EXILE_M.COLLECTIBLE_HORUS) then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_HORUSGLOW)
		EXILE_M.HasHorus = false
		end
	end
	if not EXILE_M.HasHorus and player:HasCollectible(EXILE_M.COLLECTIBLE_HORUS) then
		player:AddNullCostume(EXILE_M.COSTUME_HORUSGLOW)
		EXILE_M.HasHorus = true
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateHorusPosession)


--


function EXILE_M:CacheUpdateTuberc(player, cacheFlag)
    if player:HasCollectible(EXILE_M.COLLECTIBLE_TUBERC) then
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 1;
		end
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 1
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateTuberc)

function EXILE_M:onUpdateTuberc(player)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_TUBERC) then 
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR, -1, -1, false, false)) do
			local data = entity:GetData()
			if entity.Type == EntityType.ENTITY_TEAR then 
				local tear = entity:ToTear()
				if entity.Variant == TearVariant.LUNGTEAR then
					if entity.SpawnerType == EntityType.ENTITY_PLAYER then
						if (tear.Height >= -5 or tear:CollidesWithGrid()) and not entity:GetData().GroundHit then
						entity:GetData().GroundHit = true
						local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.LUNGPOOF,0,tear.Position + Vector(0,-3),Vector(0,0), tear)
						bloodcreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 0, tear.Position, Vector(0,0), player):ToEffect()
						bloodcreep.CollisionDamage = player.Damage / 1.55
						bloodcreep:SetColor(Color(0.5,0.05,0,1,0,0,0),0,0,false,false)
						sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(7,7),tear)
			local tear2 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(-7,7),tear)
			local tear3 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(7,-7),tear)
			local tear4 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(-7,-7),tear)

			local tear5 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(0,9),tear)
			local tear6 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(0,-9),tear)
			local tear7 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(9,0),tear)
			local tear8 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,tear.Position + Vector(0,0) ,Vector(-9,0),tear)
				end
			end
		end
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateTuberc)

function EXILE_M:GetPukeShots(player)
	local player = Isaac.GetPlayer(0)
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false)) do
			local data = entity:GetData()
			local projectile = entity:ToProjectile()
			if entity.Type == EntityType.ENTITY_PROJECTILE then 
					if data.PukeShot == true then
				if (projectile.Height >= -5 or projectile:CollidesWithGrid()) and not projectile:GetData().GroundHit then
						projectile:GetData().GroundHit = true
				--	sound:Stop(Sounds.FALLINGWHISTLE)
				Isaac.Spawn(EntityType.ENTITY_GURGLE,0,0,projectile.Position + Vector(0,0) ,Vector(0,0),projectile)
				sound:Play(SoundEffect.SOUND_BOIL_HATCH,1.05,0,false,1)
					sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)
			end
		end
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.GetPukeShots)

function EXILE_M:GetPoisonShots(player)
	local player = Isaac.GetPlayer(0)
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false)) do
			local data = entity:GetData()
			local projectile = entity:ToProjectile()
			if entity.Type == EntityType.ENTITY_PROJECTILE then 
					if data.PoisonShot == true then
				if (projectile.Height >= -5 or projectile:CollidesWithGrid()) and not projectile:GetData().GroundHit then
						projectile:GetData().GroundHit = true
			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,projectile.Position + Vector(0,0) ,Vector(0,9),projectile):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,projectile.Position + Vector(0,0) ,Vector(0,-9),projectile):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,projectile.Position + Vector(0,0) ,Vector(9,0),projectile):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,projectile.Position + Vector(0,0) ,Vector(-9,0),projectile):ToProjectile()
			tear5:GetData().PoisonProj = true
			tear6:GetData().PoisonProj = true
			tear7:GetData().PoisonProj = true
			tear8:GetData().PoisonProj = true
			
				sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)
			end
		end
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.GetPoisonShots)

function EXILE_M:lungDeath(entity, amt, flag, source, countdown)
	if source.Type == EntityType.ENTITY_TEAR
	and source.Variant == TearVariant.LUNGTEAR
	then
	local player = Isaac.GetPlayer(0)
		sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)
						bloodcreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_LEMON_MISHAP, 0, entity.Position, Vector(0,0), player):ToEffect()
						bloodcreep.CollisionDamage = player.Damage / 1.55
						bloodcreep:SetColor(Color(0.5,0.05,0,1,0,0,0),0,0,false,false)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.LUNGPOOF,0,entity.Position + Vector(0,-3),Vector(0,0), entity)
		local tear1 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
		local tear2 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
		local tear3 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
		local tear4 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

		local tear5 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
		local tear6 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
		local tear7 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
		local tear8 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.lungDeath)

function EXILE_M:onUpdateTubercItem(player) -- onUpdate is a main function that constantly runs
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_TUBERC) then -- 
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR, -1, -1, false, false)) do
			if entity.Type == EntityType.ENTITY_TEAR then
			local TearData = entity:GetData()
			local Tear = entity:ToTear()
			if TearData.SpawnType == nil then
				local roll = math.random(15)
				local rollformula = roll + player.Luck
				if rollformula > 10 then
					TearData.SpawnType = math.random(13)
					if TearData.SpawnType > 9 then
					if not entity:GetData().NotPlayerSpawned and entity.SpawnerType == EntityType.ENTITY_PLAYER then
					Tear:ChangeVariant(TearVariant.LUNGTEAR)
					sound:Stop(SoundEffect.SOUND_TEARS_FIRE)
					sound:Play(SoundEffect.SOUND_LITTLE_HORN_COUGH,1,0,false,-0.7)
					Tear.TearFlags = player.TearFlags
					Tear.CollisionDamage = player.Damage * 2
					Tear.Scale = player.Damage / 3.5 + (player.Damage * 0.2)
					end
					end
				else
				TearData.SpawnType = 0
				end
			end
	
			end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateTubercItem)	

function EXILE_M:hasTrinketTardySlip()
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(EXILE_M.TRINKET_TARDYSLIP) then
		Game().BossRushParTime = 600000
		Game().BlueWombParTime = 600000
	else
		Game().BossRushParTime = 36000
		Game().BlueWombParTime = 36000
	end
end	

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.hasTrinketTardySlip)


function EXILE_M:CacheUpdateTwofinger(player, cacheFlag)
    if player:HasCollectible(EXILE_M.COLLECTIBLE_TWOFINGER) then
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 2;
		end
		if cacheFlag == CacheFlag.CACHE_FLYING then
            player.CanFly = true;
		end
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 6.66
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateTwofinger)	


local COMBO1 = Sprite()
COMBO1:Load("gfx/COMBO_GOLEMSTONE.anm2", false)

function EXILE_M:COMBO1UPDATE(player)
	COMBO1:Update()
end

function EXILE_M:onRenderCOMBO1()
	if not COMBO1:IsFinished("Activate") then
		COMBO1:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,310),true))
		COMBO1:RenderLayer(1, Isaac.WorldToRenderPosition(Vector(320,310),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderCOMBO1)

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.COMBO1UPDATE);

function EXILE_M:CacheUpdateRock(player, cacheFlag)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_AMBROSIA) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 1.5;
			if player:HasCollectible(CollectibleType.COLLECTIBLE_SMALL_ROCK) and player:HasCollectible(EXILE_M.COLLECTIBLE_AMBROSIA) then
			player.Damage = player.Damage * 2;
			player:AddMaxHearts(2,true)
			if not EXILE_M.HasCombo1 then
			COMBO1:LoadGraphics()
			COMBO1:Play("Activate", true)
			player:AnimateHappy()
			sound:Play(Sounds.SPARKLE,1,0,false,1)
			sound:Play(SoundEffect.SOUND_POWERUP_SPEWER,1,0,false,1)
			end
			EXILE_M.HasCombo1 = true	
			end
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player.MaxFireDelay >= 5 then
			player.MaxFireDelay = player.MaxFireDelay + 8;
			end
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearFallingSpeed = player.TearFallingSpeed - 0.7
		end
	end
end

function EXILE_M:dmgDivineInt(player, target, dmgAmount, dmgFlag, source, dmgCountDownFrames)
	local player = Isaac.GetPlayer(0)
	local NearSpawn = Isaac.GetFreeNearPosition(player.Position, 10)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_DIVINEINT) and not EXILE_M.ActivatedInt then
		sound:Play(Sounds.HOLY_TWO,1,0,false,1)
		local friendlyEnemy = Isaac.Spawn(EntityType.ANGELHELPER, 3030, 0, NearSpawn, Vector(0,0), player)
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SAD_ONION, true);
		friendlyEnemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
		friendlyEnemy:AddEntityFlags(EntityFlag.FLAG_CHARM)
		friendlyEnemy:AddHealth(9999)
		friendlyEnemy:IsInvincible(true)
		friendlyEnemy.CollisionDamage = 3.5;
		EXILE_M.ActivatedInt = true
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.dmgDivineInt, EntityType.ENTITY_PLAYER)

function EXILE_M:resetDivineInt()

	if game:GetFrameCount() > 1 then
	EXILE_M.ActivatedInt = false

	end
end

function EXILE_M:SippyCupOnRoom(player, cacheFlag)

	local player = Isaac.GetPlayer(0)
	EXILE_M.broll = math.random(1,6)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_SIPPYCUP) then
		if EXILE_M.broll == 1 then
		sound:Play(SoundEffect.SOUND_VAMP_GULP,1,0,false,1)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_CHOCOPLACEHOLDER)
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SOY_MILK, true);
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
		end
		if EXILE_M.broll == 5 then
		sound:Play(SoundEffect.SOUND_VAMP_GULP,1,0,false,1)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
		end
		if EXILE_M.broll == 3 then
		sound:Play(SoundEffect.SOUND_VAMP_GULP,1,0,false,1)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_CHOCOPLACEHOLDER)
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_JESUS_JUICE, true);
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_RANGE)
		end
	end

	player:EvaluateItems()
end
	
EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.SippyCupOnRoom);
EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EXILE_M.SippyCupOnRoom);	

function EXILE_M:HeresyOnRoom(player, cacheFlag)

	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_HERESY) then
	EXILE_M.HeresyDmg = 0
	EXILE_M.HeresyCnt = 0
	EXILE_M.HeresyActive = 1
	for _, enemy in pairs(Isaac.GetRoomEntities()) do
		local data = enemy:GetData()
		enemy = enemy:ToNPC()
			if enemy and enemy:IsActiveEnemy(true) then
			EXILE_M.HeresyDmg = EXILE_M.HeresyDmg + 0.4
			EXILE_M.HeresyCnt = EXILE_M.HeresyCnt + 1
			else
			
			end
		end
	end

	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	player:AddCacheFlags(CacheFlag.CACHE_FLYING)
	player:EvaluateItems()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.HeresyOnRoom);
EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EXILE_M.HeresyOnRoom);

function EXILE_M:HeresyCache(player, cacheFlag)
	if EXILE_M.HeresyActive == nil then EXILE_M.HeresyActive = 0 end
		if player:HasCollectible(EXILE_M.COLLECTIBLE_HERESY) then
			if EXILE_M.HeresyActive == 1 then
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + EXILE_M.HeresyDmg
			end
			if cacheFlag == CacheFlag.CACHE_FLYING then
				if EXILE_M.HeresyCnt >= 5 then
				player.CanFly = true;
				player:AddNullCostume(EXILE_M.COSTUME_HERESYWINGS)
				else
				player:TryRemoveNullCostume(EXILE_M.COSTUME_HERESYWINGS)
			end
		end
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_FLYING)
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.HeresyCache)

-- nice xd
function EXILE_M:CacheUpdateSippy(player, cacheFlag)
		if player:HasCollectible(EXILE_M.COLLECTIBLE_SIPPYCUP) then
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				if EXILE_M.broll == 1 then
				player.Damage = player.Damage * 0.2
			end
				if EXILE_M.broll == 5 then
				player.Damage = player.Damage + 4
			end
				if EXILE_M.broll == 3 then
				player.Damage = player.Damage + 0.5
			end
		end
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
				if EXILE_M.broll == 1 then
				player.MaxFireDelay = 1	
			end		
				if EXILE_M.broll == 5 then
				player.MaxFireDelay = player.MaxFireDelay + 5
			end					
		end
			if cacheFlag == CacheFlag.CACHE_RANGE then
				if EXILE_M.broll == 3 then
				player.TearFallingSpeed = player.TearFallingSpeed + 1.5
				player.TearHeight = player.TearHeight + 0.5
			end						
		end
			if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
				if EXILE_M.broll == 1 then
			player.TearColor = Color(3, 2, 1, 1, 1, 0, 0);
			--player.TearColor = Color(0.250, 0.235, 0.215, 1, 0, 0, 0); possible ash tear color for future reference
			end		
				if EXILE_M.broll == 5 then
			player.TearColor = Color(0.175, 0.150, 0.150, 1, 83, 45, 45)
			end						
		end
		
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_RANGE)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
	end
end

function EXILE_M:OnUpdatePetCemetery(player)
	local player = Isaac.GetPlayer(0)
	local posx = player.Position.X
	local posy = player.Position.Y
	local Nearby = Isaac.GetFreeNearPosition(player.Position, 40)
	local Nearby2 = Isaac.GetFreeNearPosition(player.Position, 80)
	local room = Game():GetRoom()
		local iroll1 = math.random(1,5)
		local iroll2 = math.random(1,2)
		local positionRight = Vector(posx + 1, 0)
		if iroll1 == 1 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_DEAD_CAT, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
		end
		if iroll1 == 2 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_GUPPYS_HEAD, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
		end
		if iroll1 == 3 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_GUPPYS_TAIL, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
		end
		if iroll1 == 4 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_GUPPYS_COLLAR, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
		end
		if iroll1 == 5 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_GUPPYS_PAW, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
		end
		if iroll2 == 1 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_MAXS_HEAD, room:FindFreePickupSpawnPosition(player.Position, 45, false), Vector(0,0), nil)
		end
		if iroll2 == 2 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_CRICKETS_BODY, room:FindFreePickupSpawnPosition(player.Position, 45, false), Vector(0,0), nil)
		end
	player:RemoveCollectible(item_petcem)
	player:AnimateSad()
end

EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.OnUpdatePetCemetery, item_petcem);

function EXILE_M:OnUpdateCrown(player)
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(player.Position, 3, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(player.Position, 1, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, 0, room:FindFreePickupSpawnPosition(player.Position, 3, false), Vector(0,0), nil)
	player:Kill()
end

EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.OnUpdateCrown, item_crown);

function EXILE_M:removeSwordVar(player)
	if Game():GetFrameCount() < 1 then
	EXILE_M.Agnes = false
	end
	 if Game():GetFrameCount() == 1 then

		EXILE_M.incenseSpawned = false
		sound:Stop(Sounds.THUNDERSTORM)
		storm:Stop()
		EXILE_M.HeresyDmg = 0
		EXILE_M.HeresyCnt = 0
		EXILE_M.HeresyActive = 0

	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.removeSwordVar);

function EXILE_M:onUpdateCreed(player) 
    -- Main Code
	local player = Isaac.GetPlayer(0)
	local PlayerData = player:GetData()
	if PlayerData.AmbrosiaFrame == nil then PlayerData.AmbrosiaFrame = 0 end
	if PlayerData.AmbrosiaCool == nil then PlayerData.AmbrosiaCool = 0 end
	
	if game:GetFrameCount() == 1 then
	
	-- use for spawning on run start
	end

	if player:HasCollectible(EXILE_M.COLLECTIBLE_CREED) then 
		player.FireDelay = player.MaxFireDelay 
		if player:GetFireDirection() > -1 and PlayerData.AmbrosiaCool == 0 then
			PlayerData.AmbrosiaFrame = math.min(player.MaxFireDelay * 2.5, PlayerData.AmbrosiaFrame + 1)
			BOff = math.ceil(255 * PlayerData.AmbrosiaFrame / player.MaxFireDelay / 2)
			player:SetColor(Color(1,2,2,1,BOff, BOff, BOff), 1, 0, false, false)
		elseif game:GetRoom():GetFrameCount() > 1 then
			-- Fire?
			if PlayerData.AmbrosiaFrame == player.MaxFireDelay * 2.5 then
				if player:HasCollectible(EXILE_M.COLLECTIBLE_CREED) then
					local HolyLaser = EntityLaser.ShootAngle(5, player.Position, EXILE_M.HeadDirection,
					20, Vector(0,-25), player)
					HolyLaser.DepthOffset = 40;
					HolyLaser.AngleDegrees = EXILE_M.HeadDirection
					HolyLaser.Angle = EXILE_M.HeadDirection
					HolyLaser.StartAngleDegrees = EXILE_M.HeadDirection
					HolyLaser.TearFlags = player.TearFlags
					HolyLaser.CollisionDamage = player.Damage
				end
				PlayerData.AmbrosiaCool = 16 * 2 
			else
				-- Dud..
			end
			PlayerData.AmbrosiaFrame = 0		
		end
		PlayerData.AmbrosiaCool = math.max(0,PlayerData.AmbrosiaCool - 1)
	end
end

function EXILE_M:ResetRoomVariables2()
Isaac.DebugString("Reset Room Vars 2 Updated (1)")
	EXILE_M.WindSpawn = false
	StormEnemyCount = 0
	EXILE_M.BellsDown = false
	EXILE_M.BellsReturn = false
	Isaac.DebugString("Reset Room Vars 2 Updated(2)")
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetRoomVariables2)

function EXILE_M:WindUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if EXILE_M.WindSpawn == false then
		EXILE_M.WindSpawn = true
	end
	player:AddVelocity(Vector(-0.5,0))
end

function EXILE_M:StormHostUpdate(entity)
	local npc = entity:ToNPC()
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if not entity:GetSprite():IsPlaying("Idle", true) then
		entity:GetSprite():Play("Idle", true)
		storm:Reload()
		storm:LoadGraphics()
		sound:Play(Sounds.THUNDERSTORM,5.5,0,false,1)
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_FLUSH,false)
	sound:Stop(SoundEffect.SOUND_FLUSH)

		storm:Play("Idle", true)	
		
	elseif entity:GetSprite():IsEventTriggered("Rain") then
	local roll = math.random(1,10)
	if roll > 5 then
	Game():Spawn(EntityType.LIGHTNING, 0, Isaac.GetFreeNearPosition(player.Position, 15), Vector(0,0), nil, 0, 0)	
	end
	elseif room:IsClear() then
		sound:Stop(Sounds.THUNDERSTORM)
		storm:Stop()
		entity:Remove()
		
	end
	Game():Darken(1,19)
	player:AddVelocity(Vector(-0.3,0))
end

function EXILE_M:ResetStorm()
	Isaac.DebugString("Storms Reset (1)")
	local room = Game():GetRoom() --<-------
	if room:IsClear() then
		sound:Stop(Sounds.THUNDERSTORM)
		storm:Stop()
		
	end
	Isaac.DebugString("Storms Reset(2)")
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetStorm);

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.StormHostUpdate, EntityType.STORMHOST)

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateCreed);

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateSippy)	

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.resetDivineInt);

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateRock)


-- Valknut (Vulknut is typo) Callbacks

--EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateVulknutPosession)
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateTubercPosession)



EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateGolemPosession)
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateCreedPosession)
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateCharmGreed)
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateTwoFinger)
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateCorinthPosession)


	
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.MeteorUpdate, EntityType.METEORITE)



-- Begin coding for the Tidal Floor Code
--TIDAL FLOOR STARTS HERE

-- THIS USES THE EXACT SAME API AS REVELATIONS, MADE BY DEADINFINITY
-- I DO NOT TAKE ANY CREDIT FOR THE STAGE API LAYOUT, ALL CREDIT FOR STAGE API,
-- GOES TO DEADINFINITY AND ANY OTHER MEMBER THAT MADE IT. Thank you! :D
-- THIS MOD REQUIRES STAGE API TO WORK!!!!

-- Dont worry: This isnt a carbon copy of revelations, just uses the same api, thats all
-- Credit to revelations team, you glorious bastards


CLOCKWORKBOSS = Isaac.GetMusicIdByName("Clockwork Boss")
FLOORINTRO2 = Isaac.GetMusicIdByName("FloorIntro2")
CLOCKWORKBOSSEND = Isaac.GetMusicIdByName("Clockwork Boss Over")

BOSSOVER = Isaac.GetMusicIdByName("Boss Over")




SSClockworkRooms = require('resources.luarooms.clockwork_super_special')


 TidalEntranceList = require('resources.luarooms.clockwork_entrance')


 DutchmanBossRooms = require('resources.luarooms.bosses.dutchman_boss')


 HazelBossRooms = require('resources.luarooms.bosses.hazel_boss')


 DroolsBossRooms = require('resources.luarooms.bosses.drools_boss')


 LoaLoaBossRooms = require('resources.luarooms.bosses.loaloa_boss')


 DarkCasterBossRooms = require('resources.luarooms.bosses.darkcaster_boss')


 BouldergeistBossRooms = require('resources.luarooms.bosses.bouldergeist_boss')


 SimonBossRooms = require('resources.luarooms.bosses.simon_boss')

 ClockworkRooms = require('resources.luarooms.clockwork_regular')
 
 QuarantineRooms = require('resources.luarooms.quarantine_regular')







---- REQUIRES 2

if StageAPI and StageAPI.Loaded then

	
end


local function loadmod() --- StageAPI for some people, might load AFTER the mod loads. This prevents that from happening.

GLASSPANELDORMANT = StageAPI.CustomGrid("Glass Panel Dormant", GridEntityType.GRID_DECORATION, nil, "gfx/periwinkle_glass_dormant.anm2", "Idle")

GLASSPANELBROKEN = StageAPI.CustomGrid("Glass Panel Broken", GridEntityType.GRID_PIT, nil, "gfx/periwinkle_glass_broken.anm2", "IdleBroken")



 SSClockworkRoomList = StageAPI.RoomsList("SSClockworkRoomsList", SSClockworkRooms)
  TidalEntranceRoomList = StageAPI.RoomsList("TidalEntranceRoomsList", TidalEntranceList)
 LoaLoaBossList = StageAPI.RoomsList("LoaBossLists", LoaLoaBossRooms)
 DarkCasterBossList = StageAPI.RoomsList("CasterBossLists", DarkCasterBossRooms)
 BouldergeistBossList = StageAPI.RoomsList("BoulderBossList", BouldergeistBossRooms)
 SimonBossList = StageAPI.RoomsList("SimonBossLists", SimonBossRooms)
  ClockworkRoomsList = StageAPI.RoomsList("ClockworkRoomsList", ClockworkRooms)
  QuarantineRoomsList = StageAPI.RoomsList("QuarantineRoomsList", QuarantineRooms)

EXILE_M.Bosses = {
		LoaLoa = {
			Name = "Loa Loa",
			Portrait = "gfx/ui/boss/portrait_loaloa.png",
            Bossname = "gfx/ui/boss/bossname_loaloa.png",
            RoomKeyPrefix = "LoaLoa",
            FilePrefix = "loaloa_",
			Rooms = LoaLoaBossList,
        },
		DarkCaster = {
			Name = "Dark Caster",
			Portrait = "gfx/ui/boss/portrait_darkcaster.png",
            Bossname = "gfx/ui/boss/bossname_darkcaster.png",
            RoomKeyPrefix = "DarkCaster",
            FilePrefix = "darkcaster_",
			Rooms = DarkCasterBossList,
        },
		Bouldergeist = {
			Name = "Bouldergeist",
			Portrait = "gfx/ui/boss/portrait_bouldergeist.png",
            Bossname = "gfx/ui/boss/bossname_bouldergeist.png",
            RoomKeyPrefix = "Bouldergeist",
            FilePrefix = "bouldergeist_",
			Rooms = BouldergeistBossList,
        },
		Simon = {
			Name = "Simon",
			Portrait = "gfx/ui/boss/portrait_simon.png",
            Bossname = "gfx/ui/boss/bossname_simon.png",
            RoomKeyPrefix = "Simon",
            FilePrefix = "simon_",
			Rooms = SimonBossList,
        }
		
}


StageAPI.AddBossData("Simon", EXILE_M.Bosses.Simon)
StageAPI.AddBossData("Loa Loa", EXILE_M.Bosses.LoaLoa)
StageAPI.AddBossData("Dark Caster", EXILE_M.Bosses.DarkCaster)
StageAPI.AddBossData("Bouldergeist", EXILE_M.Bosses.Bouldergeist)



local fog = "gfx/backdrop/exile/fog.anm2"
local fog2 = "gfx/backdrop/exile/fog2.anm2"
local brassfog = "gfx/backdrop/brasshead/fog.anm2"
local gears = "gfx/backdrop/brasshead/gearfog.anm2"
local movinggears = "gfx/backdrop/brasshead/moving_gears.anm2"

EXILE_M.TidalOverlay = StageAPI.Overlay(fog, Vector(0.20,0.20), Vector(-25,-25))
EXILE_M.TidalOverlay:SetAlpha(0)

EXILE_M.TidalOverlayFast = StageAPI.Overlay(fog, Vector(0.20,0.20), Vector(-10,-10))
EXILE_M.TidalOverlayFast:SetAlpha(0)

EXILE_M.MovingGears = StageAPI.Overlay(movinggears, Vector(0,0), Vector(0,0))
EXILE_M.MovingGears:SetAlpha(0)


EXILE_M.TidalOverlay2 = StageAPI.Overlay(fog2, Vector(-0.08,0.08), Vector(1,1))
EXILE_M.TidalOverlay2:SetAlpha(0)


	FLOODED_CAVES_CUSTOM = Isaac.GetMusicIdByName("Flooded Caves")

	StageAPI.FloodedCavesGridGfx = StageAPI.GridGfx()
    StageAPI.FloodedCavesGridGfx:SetRocks("gfx/grid/rocks_drownedcaves.png")
    StageAPI.FloodedCavesGridGfx:SetPits("gfx/grid/grid_pit_water_drownedcaves.png", "gfx/grid/grid_pit_water_drownedcaves.png")
    StageAPI.FloodedCavesGridGfx:SetBridges("gfx/stageapi/floodedcaves/grid_bridge_floodedcaves.png")
    StageAPI.FloodedCavesGridGfx:SetDecorations("gfx/grid/props_03_caves.png")

    StageAPI.FloodedCavesFloors = {
        {"Floodedcaves1_1", "Floodedcaves1_2"},
        {"Floodedcaves2_1", "Floodedcaves2_2"},
        {"FloodedcavesExtraFloor_1", "FloodedcavesExtraFloor_2"}
    }

    StageAPI.FloodedCavesBackdrops = {
        {
            Walls = {"Floodedcaves1_1", "Floodedcaves1_2"},
            NFloors = {"Floodedcaves_nfloor"},
            LFloors = {"Floodedcaves_lfloor"},
            Corners = {"Floodedcaves1_corner"}
        },
        {
            Walls = {"Floodedcaves2_1", "Floodedcaves2_2"},
            NFloors = {"Floodedcaves_nfloor"},
            LFloors = {"Floodedcaves_lfloor"},
            Corners = {"Floodedcaves2_corner"}
        }
    }

    StageAPI.FloodedCavesBackdropHelper = StageAPI.BackdropHelper(StageAPI.FloodedCavesBackdrops, "gfx/backdrop/floodedcaves/", ".png")
    StageAPI.FloodedCavesRoomGfx = StageAPI.RoomGfx(StageAPI.FloodedCavesBackdropHelper, StageAPI.FloodedCavesGridGfx, "_default")
    StageAPI.FloodedCaves = StageAPI.CustomStage("Flooded Caves", nil, true)
    StageAPI.FloodedCavesMusicID = Isaac.GetMusicIdByName("Flooded Caves")
    StageAPI.FloodedCaves:SetStageMusic(StageAPI.FloodedCavesMusicID)
    StageAPI.FloodedCaves:SetBossMusic({Music.MUSIC_BOSS, Music.MUSIC_BOSS2}, Music.MUSIC_BOSS_OVER)
    StageAPI.FloodedCaves:SetRoomGfx(StageAPI.FloodedCavesRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_BOSS})
    StageAPI.FloodedCaves.DisplayName = "Flooded Caves I"

    StageAPI.FloodedCavesTwo = StageAPI.FloodedCaves("Flooded Caves 2")
    StageAPI.FloodedCavesTwo.DisplayName = "Flooded Caves II"

    StageAPI.FloodedCavesXL = StageAPI.FloodedCaves("Flooded Caves XL")
    StageAPI.FloodedCavesXL.DisplayName = "Flooded Caves XL"
    StageAPI.FloodedCaves:SetXLStage(StageAPI.FloodedCavesXL)	

	SCARRED_WOMB_CUSTOM = Isaac.GetMusicIdByName("Scarred Womb")

	StageAPI.ScarredWombGridGfx = StageAPI.GridGfx()
    StageAPI.ScarredWombGridGfx:SetRocks("gfx/grid/rocks_scarredwomb.png")
    StageAPI.ScarredWombGridGfx:SetPits("gfx/grid/grid_pit_blood_scarredwomb.png", "gfx/grid/grid_pit_blood_scarredwomb.png")
    StageAPI.ScarredWombGridGfx:SetBridges("gfx/stageapi/scarredwomb/grid_bridge_scarredwomb.png")
    StageAPI.ScarredWombGridGfx:SetDecorations("gfx/backdrop/scarredwomb/props_scarredwomb.png")

    StageAPI.ScarredWombFloors = {
        {"Scarredwomb1_1", "Scarredwomb1_2"},
        {"Scarredwomb2_1", "Scarredwomb2_2"},
        {"FloodedcavesExtraFloor_1", "FloodedcavesExtraFloor_2"}
    }

    StageAPI.ScarredWombBackdrops = {
        {
            Walls = {"Scarredwomb1_1", "Scarredwomb1_2"},
            NFloors = {"Scarredwomb_nfloor"},
            LFloors = {"Scarredwomb_lfloor"},
            Corners = {"Scarredwomb1_corner"}
        },
        {
            Walls = {"Scarredwomb2_1", "Scarredwomb2_2"},
            NFloors = {"Scarredwomb_nfloor"},
            LFloors = {"Scarredwomb_lfloor"},
            Corners = {"Scarredwomb2_corner"}
        }
    }

    StageAPI.ScarredWombBackdropHelper = StageAPI.BackdropHelper(StageAPI.ScarredWombBackdrops, "gfx/backdrop/scarredwomb/", ".png")
    StageAPI.ScarredWombRoomGfx = StageAPI.RoomGfx(StageAPI.ScarredWombBackdropHelper, StageAPI.ScarredWombGridGfx, "_default")
    StageAPI.ScarredWomb = StageAPI.CustomStage("Scarred Womb", nil, true)
    StageAPI.ScarredWombMusicID = Isaac.GetMusicIdByName("Scarred Womb")
    StageAPI.ScarredWomb:SetStageMusic(StageAPI.ScarredWombMusicID)
    StageAPI.ScarredWomb:SetBossMusic({Music.MUSIC_BOSS, Music.MUSIC_BOSS2}, Music.MUSIC_BOSS_OVER)
    StageAPI.ScarredWomb:SetRoomGfx(StageAPI.ScarredWombRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_BOSS})
    StageAPI.ScarredWomb.DisplayName = "Scarred Womb I"

    StageAPI.ScarredWombTwo = StageAPI.ScarredWomb("Scarred Womb 2")
    StageAPI.ScarredWombTwo.DisplayName = "Scarred Womb II"

    StageAPI.ScarredWombXL = StageAPI.FloodedCaves("Scarred Womb XL")
    StageAPI.ScarredWombXL.DisplayName = "Scarred Womb XL"
    StageAPI.ScarredWomb:SetXLStage(StageAPI.ScarredWombXL)	
	
StageAPI.StageOverride = {
        FloodedCavesOne = {
            OverrideStage = LevelStage.STAGE2_1,
            OverrideStageType = StageType.STAGETYPE_AFTERBIRTH,
            ReplaceWith = StageAPI.FloodedCaves
        },
        FloodedCavesTwo = {
            OverrideStage = LevelStage.STAGE2_2,
            OverrideStageType = StageType.STAGETYPE_AFTERBIRTH,
            ReplaceWith = StageAPI.FloodedCavesTwo
        },
        ScarredWombOne = {
            OverrideStage = LevelStage.STAGE4_1,
            OverrideStageType = StageType.STAGETYPE_AFTERBIRTH,
            ReplaceWith = StageAPI.ScarredWomb
        },
        ScarredWombTwo = {
            OverrideStage = LevelStage.STAGE4_2,
            OverrideStageType = StageType.STAGETYPE_AFTERBIRTH,
            ReplaceWith = StageAPI.ScarredWombTwo
        },
        CatacombsOne = {
            OverrideStage = LevelStage.STAGE2_1,
            OverrideStageType = StageType.STAGETYPE_WOTL,
            ReplaceWith = StageAPI.Catacombs
        },
        CatacombsTwo = {
            OverrideStage = LevelStage.STAGE2_2,
            OverrideStageType = StageType.STAGETYPE_WOTL,
            ReplaceWith = StageAPI.CatacombsTwo
        },
        NecropolisOne = {
            OverrideStage = LevelStage.STAGE3_1,
            OverrideStageType = StageType.STAGETYPE_WOTL,
            ReplaceWith = StageAPI.Necropolis
        },
        NecropolisTwo = {
            OverrideStage = LevelStage.STAGE3_2,
            OverrideStageType = StageType.STAGETYPE_WOTL,
            ReplaceWith = StageAPI.NecropolisTwo
        },
        UteroOne = {
            OverrideStage = LevelStage.STAGE4_1,
            OverrideStageType = StageType.STAGETYPE_WOTL,
            ReplaceWith = StageAPI.Utero
        },
        UteroTwo = {
            OverrideStage = LevelStage.STAGE4_2,
            OverrideStageType = StageType.STAGETYPE_WOTL,
            ReplaceWith = StageAPI.UteroTwo
        }
    }
	
	
	
StageAPI.FloodedCaves:SetReplace(StageAPI.StageOverride.FloodedCavesOne)
StageAPI.FloodedCavesTwo:SetReplace(StageAPI.StageOverride.FloodedCavesTwo)

EXILE_M.Stage = {}

function StageAPI.PlayTransitionAnimationManual(portraitbig, icon, transitionmusic, queue, noshake)
	local player = Isaac.GetPlayer(0)
	if not StageAPI.InOverriddenStage() then
        portraitbig = portraitbig or "gfx/ui/stage/playerportraitbig_01_isaac.png"
        
	end
		icon = icon or "stageapi/transition/levelicons/unknown.png"
        transitionmusic = transitionmusic or Music.MUSIC_JINGLE_NIGHTMARE

        if queue ~= false then
            queue = queue or StageAPI.Music:GetCurrentMusicID()
        end
		
		if StageAPI.NextStage == EXILE_M.Stage.Clock or StageAPI.NextStage == ClockTwo then
		StageAPI.TransitionAnimation:Reset()
		StageAPI.TransitionAnimation:Load("gfx/ui/transitionscreen/transition_clockwork.anm2", true)
		StageAPI.TransitionAnimation:Update()
		else
		StageAPI.TransitionAnimation:Reset()
        portraitbig = portraitbig or "gfx/ui/stage/playerportraitbig_01_isaac.png"
        icon = icon or "stageapi/transition/levelicons/unknown.png"
		StageAPI.TransitionAnimation:Load("stageapi/transition/customnightmare.anm2", true)
        StageAPI.TransitionAnimation:ReplaceSpritesheet(1, portraitbig)
        StageAPI.TransitionAnimation:ReplaceSpritesheet(2, icon)
        StageAPI.TransitionAnimation:LoadGraphics()
		StageAPI.TransitionAnimation:Update()
		end

        StageAPI.TransitionAnimation:LoadGraphics()
        if noshake then
            StageAPI.TransitionAnimation:Play("SceneNoShake", true)
        else
            StageAPI.TransitionAnimation:Play("Scene", true)
        end

        StageAPI.Music:Play(transitionmusic, 0)
        StageAPI.Music:UpdateVolume()

        if queue ~= false then
            StageAPI.Music:Queue(queue)
		end
		if StageAPI.TransitionAnimation:IsFinished("Scene") or stop == true then
			StageAPI.Music:Fadeout()
			StageAPI.Music:Play(queue, 0)
		end
end

function EXILE_M:onRenderTransitionAnim(queue)
	local player = Isaac.GetPlayer(0)
		if StageAPI.TransitionAnimation:IsPlaying("Scene") or StageAPI.TransitionAnimation:IsPlaying("SceneNoShake") then
		if Input.IsActionTriggered(ButtonAction.ACTION_MENUCONFIRM, player.ControllerIndex) or
                Input.IsActionTriggered(ButtonAction.ACTION_MENUBACK, player.ControllerIndex) then
			StageAPI.Music:Play(queue, 0)
			StageAPI.Music:Fadeout()
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderTransitionAnim)


-- CLOCKWORK STARTS HERE
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

EXILE_M.Brassfog = StageAPI.Overlay(brassfog, Vector(0.4,0.4), Vector(-2,-2))
EXILE_M.Brassfog:SetAlpha(0)

EXILE_M.Gearfog = StageAPI.Overlay(gears, Vector(0.8,0.8), Vector(-3,-3.5))
EXILE_M.Gearfog:SetAlpha(0)


EXILE_M.ClockBosses = {
    "Loa Loa",
	"Bouldergeist",
	"Dark Caster",
	"Simon"
}

local thundertimer = 0
local ClockGrid = StageAPI.GridGfx()
ClockGrid:AddDoors("gfx/grid/clockwork/door_01_normaldoor.png", StageAPI.DefaultDoorSpawn)
ClockGrid:AddDoors("gfx/grid/clockwork/hole.png", StageAPI.SecretDoorSpawn)

ClockGrid:SetRocks("gfx/grid/clockwork/rocks.png")
ClockGrid:SetPits("gfx/grid/clockwork/pit.png")
ClockGrid:SetBridges("gfx/grid/clockwork/bridge.png")
ClockGrid:SetDecorations("gfx/grid/clockwork/props.png")

EXILE_M.ClockGrid = ClockGrid

local ClockBackdrop1 = StageAPI.BackdropHelper({
    Walls = {"1", "2", "3"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"corner"}
}, "gfx/backdrop/clockwork/clockwork_", ".png")

local ClockEntrance = StageAPI.BackdropHelper({
    Walls = {"entrance"}
}, "gfx/backdrop/clockwork/clockwork_", ".png")

local ClockEntranceGfx = StageAPI.RoomGfx(ClockEntrance, ClockGrid, "_default", "stageapi/shading/shading")

EXILE_M.ClockworkFloors = {
        {"clockwork_1"},
		{"clockwork_2"}
    }

   EXILE_M.ClockworkBackdrops = {
        {
            Walls = {"clockwork_1", "clockwork_2", "clockwork_3"},
            NFloors = {"clockwork_nfloor"},
            LFloors = {"clockwork_lfloor"},
            Corners = {"clockwork_corner"}
        },
        {
            Walls = {"clockwork_2", "clockwork_3"},
            NFloors = {"clockwork_nfloor"},
            LFloors = {"clockwork_lfloor"},
            Corners = {"clockwork_corner"}
        },
        {
            Walls = {"clockwork_4", "clockwork_5"},
            NFloors = {"clockwork_nfloor"},
            LFloors = {"clockwork_lfloor"},
            Corners = {"clockwork_corner"}
        }
    }


EXILE_M.ClockworkBackdrops = StageAPI.BackdropHelper(EXILE_M.ClockworkBackdrops, "gfx/backdrop/clockwork/", ".png")
EXILE_M.ClockRoomGfx = StageAPI.RoomGfx(EXILE_M.ClockworkBackdrops, ClockGrid, "_default", "stageapi/shading/shading")
EXILE_M.Stage.Clock = StageAPI.CustomStage("Clockwork")
EXILE_M.Stage.Clock:SetTransitionIcon("gfx/ui/stage/clockwork.png")
EXILE_M.Stage.Clock:SetRooms(ClockworkRoomsList)
EXILE_M.Stage.Clock:SetBosses(EXILE_M.ClockBosses)
EXILE_M.Stage.Clock:SetRoomGfx(EXILE_M.ClockRoomGfx, {RoomType.ROOM_BOSS})
EXILE_M.Stage.Clock:SetRoomGfx(EXILE_M.ClockRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS})
EXILE_M.Stage.Clock:SetMusic(AZTEC_THEME, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE})
EXILE_M.Stage.Clock:SetBossMusic(CLOCKWORKBOSS, BOSSOVER, Isaac.GetMusicIdByName("Clockwork Boss Intro"), CLOCKWORKBOSSEND)
EXILE_M.Stage.Clock:SetTransitionMusic(FLOORINTRO2)
EXILE_M.Stage.Clock:SetSpots("gfx/ui/boss/bossspot_clockwork.png", "gfx/ui/boss/playerspot_clockwork.png")
EXILE_M.Stage.Clock:SetDisplayName("Clockwork I")
EXILE_M.Stage.Clock.IsSecondStage = false
EXILE_M.Stage.Clock:SetReplace(StageAPI.StageOverride.CatacombsOne)


local ClockXL = EXILE_M.Stage.Clock("Clockwork XL")
ClockXL:SetDisplayName("Clockwork XL")
ClockXL:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_2
})
ClockXL.IsSecondStage = true

EXILE_M.Stage.Clock:SetXLStage(ClockXL)

ClockTwo = EXILE_M.Stage.Clock("Clockwork II")

ClockTwo:SetReplace(StageAPI.StageOverride.CatacombsTwo)
ClockTwo:SetDisplayName("Clockwork II")
EXILE_M.Stage.Clock:SetNextStage(ClockTwo)
ClockTwo:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_1
})

ClockTwo.IsSecondStage = true



StageAPI.AddCallback("CaptainsLog", "PRE_TRANSITION_RENDER", 1, function()
    if EXILE_M.Stage.Clock:IsStage() then
	EXILE_M.Gearfog:Render()
	EXILE_M.Gearfog:SetAlpha(0.67)
	EXILE_M.TidalOverlay:Render()
	EXILE_M.TidalOverlay:SetAlpha(0.1)
	StageAPI.ChangeStageShadow("gfx/backdrop/clockwork/overlays/", 8)
	sound:SetAmbientSound(Ambient.CLOCKWORK_AMB,1,1)
		if not clockgears:IsPlaying("Idle") then
		clockgears:Reload()
		clockgears:LoadGraphics()
		clockgears:Play("Idle", true)
		end
	else
	clockgears:Stop()
	sound:Stop(Ambient.CLOCKWORK_AMB)
    end
end)





function EXILE_M:ClockworkRoomReset(player)
	if EXILE_M.Stage.Clock:IsStage() then
		EXILE_M.TurnBack = false
	end
end



EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ClockworkRoomReset)

function EXILE_M:QuarantineRoomReset(player)
	if EXILE_M.Stage.Quarantine:IsStage() then
		EXILE_M.Breached = false
	end
end



EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ClockworkRoomReset)

EXILE_M.ClockEntranceDoor = StageAPI.CustomDoor("ClockEntranceDoor", "gfx/grid/clockwork/door_entrance.anm2")
EXILE_M.ClockExitDoor = StageAPI.CustomDoor("ClockExitDoor", "gfx/grid/clockwork/door_entrance_return.anm2")

SoundEffect.SOUND_CLOCK_DOOR = Isaac.GetSoundIdByName("ClockDoor")

local cShine = Sprite()
cShine:Load("gfx/backdrop/shine.anm2", false)

function EXILE_M:onRenderShine()
		if StageAPI.GetCurrentRoomType() == "TidalEntrance" then
		cShine:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		else
		
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderShine)

function EXILE_M:shineUpd(player)
	cShine:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.shineUpd);

local EntranceSlotRNG = RNG() ------------- ACTUALLY USED FOR CLOCKWORK, TIDAL IS NO MORE
function EXILE_M:TidalRoomCheck()
	Isaac.DebugString("Tidal Doors Evaluated (1)")
    local stage = level:GetStage()
	local room = Game():GetRoom()
    if not game:IsGreedMode() and room:GetType() == RoomType.ROOM_SUPERSECRET and (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2) and not EXILE_M.Stage.Clock:IsStage() then
	EXILE_M.musicid = music:GetCurrentMusicID()
        if room:IsFirstVisit() then
        local TidalEntrance = StageAPI.LevelRoom(nil, TidalEntranceRoomList, room:GetSpawnSeed(), RoomShape.ROOMSHAPE_1x1, "TidalEntrance")
        
	StageAPI.SetExtraRoom("TidalEntrance", TidalEntrance)
           
	local emptySlots = {}
    for i = 0, 3 do
    if not room:GetDoor(i) and room:IsDoorSlotAllowed(i) then
                emptySlots[#emptySlots + 1] = i
            end
        end

        EntranceSlotRNG:SetSeed(room:GetSpawnSeed(), 0)
            local slot = emptySlots[StageAPI.Random(1, #emptySlots, EntranceSlotRNG)]

            TidalEntrance.PersistentData.ExitSlot = (slot + 2) % 4
            TidalEntrance.PersistentData.LeadTo = level:GetCurrentRoomIndex()
			--sound:Play(SoundEffect.SOUND_CLOCK_DOOR,5.7,0,false,1)
			Game():ShakeScreen(17,17)

            StageAPI.SpawnCustomDoor(slot, "TidalEntrance", nil, "ClockEntranceDoor")
			
        end
    end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.TidalRoomCheck)

StageAPI.AddCallback("CaptainsLog", "POST_CUSTOM_DOOR_UPDATE", 1, function(door, data, sprite, doorData, persistData)
	local room = Game():GetRoom()
  if not data.SpawnedLight then
		local light = Isaac.Spawn(1000, EffectVariant.FIREWORKS,4, door.Position, Vector(0,0), nil)
	light:SetColor(Color(6, 0, 10, 1, 6, 0, 0),0,1,false,false)
	light:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light:GetSprite():LoadGraphics()
	light:GetData().lightSpawnerEntity = door
	light:GetData().CustomLight = true
	light:GetData().SpriteScale = Vector(1.27,1.27)
	door:GetData().SpawnedLight = 1
	end
	if data.Opened then
        if not data.OpensStinger and room:IsFirstVisit() then
            data.OpensStinger = true
            sound:Play(SoundEffect.SOUND_CLOCK_DOOR,5.9,0,false,1)
			door:GetSprite():Play("Open", false)
        end
    else
        data.OpensStinger = nil
    end
	Game():Darken(1,2)
end, "ClockEntranceDoor")

StageAPI.AddCallback("CaptainsLog", "POST_ROOM_LOAD", 1, function(newRoom, revisited)
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
    if StageAPI.GetCurrentRoomType() == "TidalEntrance" then
        StageAPI.TemporarilyOverrideRockAltEffects()
        StageAPI.SpawnCustomDoor(newRoom.PersistentData.ExitSlot, nil, newRoom.PersistentData.LeadTo, "ClockExitDoor")
            StageAPI.ChangeRoomGfx(ClockEntranceGfx)
				cShine:Reload()
		cShine:LoadGraphics()
		cShine:Play("Idle", true)
			local TidalPortal = EXILE_M.Stage.Clock
        if level:GetStage() == LevelStage.STAGE2_2 or level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH ~= 0 then
                TidalPortal = ClockTwo
        end

        local trapdoor = StageAPI.SpawnCustomTrapdoor(room:GetCenterPos(), TidalPortal, "gfx/grid/clockwork/door_11_trapdoor.anm2")
       -- trapdoor:GetSprite():ReplaceSpritesheet(0, "gfx/grid/tidal/doors/tidal_trapdoor.png")
        --trapdoor:GetSprite():LoadGraphics()
		
		StageAPI.TransitionAnimation:Reset()
		StageAPI.TransitionAnimation:Load("gfx/ui/transitionscreen/transition_clockwork.anm2", true)
    end
end)


tidalEntPlayed = false
EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, function()
  local currentRoom = StageAPI.GetCurrentRoom()
  if StageAPI.GetCurrentRoomType() == "TidalEntrance" then
    EXILE_M.musicsfx = TIDAL_ENTRANCE
    if music:GetQueuedMusicID() ~= EXILE_M.musicsfx then
      music:Queue(EXILE_M.musicsfx)
    end

    if music:GetCurrentMusicID() ~= EXILE_M.musicsfx then
      music:Play(EXILE_M.musicsfx, 3)
      music:UpdateVolume()
      tidalEntPlayed = true
    end
  end
end)

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
local room = Game():GetRoom()
  if tidalEntPlayed then
    if not room:GetType() == RoomType.ROOM_SHOP then
      music:Play(EXILE_M.musicid, 0)
      music:UpdateVolume()
    end

    tidalEntPlayed = false
  end
end)



function EXILE_M:ClockKill()
	local player = Isaac.GetPlayer(0)
	if EXILE_M.Stage.Clock:IsStage() then
	if Isaac.CountEnemies() < 4 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			local data = entity:GetData()
			entity = entity:ToNPC()
			if entity and entity:IsActiveEnemy(true) then
			if entity:IsDead() and not data.Died and not data.FriendlyPoop then
			data.Died = true
			local roll = math.random(1,23)
			if roll > 20 then
			Isaac.Spawn(EntityType.CLOCKWORKCRANE, Isaac.GetEntityVariantByName("Clockwork Crane"), 0, Isaac.GetFreeNearPosition(player.Position, 15), Vector(0,0), nil)
		end
		if entity.ParentNPC then
			data.Died = true
			end
			end
		end
		end
	end
end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.ClockKill)


-------

StageAPI.AddEntityPersistenceData({Type = EntityType.BEARTRAP, Variant = 29327})
StageAPI.AddEntityPersistenceData({Type = EntityType.CLOCKSPINNER, Variant = 14832})
StageAPI.AddEntityPersistenceData({Type = EntityType.CLOCKSUMMON, Variant = 14834})
StageAPI.AddEntityPersistenceData({Type = EntityType.CLOCKRESET, Variant = 14833})
StageAPI.AddEntityPersistenceData({Type = EntityType.BIGCRUSHER, Variant = 12437})
StageAPI.AddEntityPersistenceData({Type = EntityType.AIRPIPE, Variant = 28493})
StageAPI.AddEntityPersistenceData({Type = EntityType.GEAREFFECT, Variant = 0})

StageAPI.AddEntityPersistenceData({Type = EntityType.FIRESTATUE, Variant = 28323})
StageAPI.AddEntityPersistenceData({Type = EntityType.CLOCKSTATUEDECOR, Variant = 23732})
StageAPI.AddEntityPersistenceData({Type = EntityType.CLOCKSTATUEDECOR, Variant = 23733})

StageAPI.AddEntityPersistenceData({Type = EntityType.CONVEYORBELT, Variant = 19288})
StageAPI.AddEntityPersistenceData({Type = EntityType.CONVEYORBELT, Variant = 19289})
StageAPI.AddEntityPersistenceData({Type = EntityType.CONVEYORBELT, Variant = 19290})
StageAPI.AddEntityPersistenceData({Type = EntityType.CONVEYORBELT, Variant = 19291})


--local EntsTable = Isaac.FindByType(x, y, z)  ----- NOTE TO SELF, USE THIS TO GET A RANDOM ENTITY FROM THE ROOM

--local EnemyToUse = EntsTable[rng:RandomInt(#EntsTable) + 1]


-- Quarantine
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------
----------------------------------------------------

local toxicfog = "gfx/backdrop/quarantine/toxicfog.anm2"

EXILE_M.QuarantineFog = StageAPI.Overlay(toxicfog, Vector(0.20,0.20), Vector(-25,-25))
EXILE_M.QuarantineFog:SetAlpha(0)

local QuarantineGrid = StageAPI.GridGfx()
QuarantineGrid:AddDoors("gfx/grid/quarantine/normaldoor.png", StageAPI.DefaultDoorSpawn)
QuarantineGrid:AddDoors("gfx/grid/quarantine/hole.png", StageAPI.SecretDoorSpawn)

QuarantineGrid:SetRocks("gfx/grid/quarantine/rocks.png")
QuarantineGrid:SetPits("gfx/grid/quarantine/pit.png")
QuarantineGrid:SetBridges("gfx/grid/quarantine/bridge.png")
QuarantineGrid:SetDecorations("gfx/grid/props_03_caves.png")

EXILE_M.QuarantineGrid = QuarantineGrid

local QuarantineBackdrop1 = StageAPI.BackdropHelper({
    Walls = {"1", "2", "3"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"corner"}
}, "gfx/backdrop/quarantine/quarantine_", ".png")

local QuarantineBloody = StageAPI.BackdropHelper({
    Walls = {"1_bloody"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"corner"}
}, "gfx/backdrop/quarantine/quarantine_", ".png")

--local QuarantineEntrance = StageAPI.BackdropHelper({
--    Walls = {"entrance"}
--}, "gfx/backdrop/clockwork/quarantine_", ".png")

--local QuarantineEntranceGfx = StageAPI.RoomGfx(QuarantineEntrance, QuarantineGrid, "_default", "stageapi/shading/shading")

EXILE_M.QuarantineFloors = {
        {"quarantine_1"},
		{"quarantine_2"}
    }

EXILE_M.QuarantineBackdrop = {
        {
            Walls = {"quarantine_1", "quarantine_2"},
            NFloors = {"quarantine_nfloor"},
            LFloors = {"quarantine_lfloor"},
            Corners = {"quarantine_corner"}
        },
        {
            Walls = {"quarantine_3", "quarantine_4"},
            NFloors = {"quarantine_nfloor"},
            LFloors = {"quarantine_lfloor"},
            Corners = {"quarantine_corner"}
        },
    }
	
   EXILE_M.QuarantineBloody = {
        {
            Walls = {"quarantine_1_bloody"},
            NFloors = {"quarantine_nfloor"},
            LFloors = {"quarantine_lfloor"},
            Corners = {"quarantine_corner"}
        }
    }


EXILE_M.QuarantineBackdrops = StageAPI.BackdropHelper(EXILE_M.QuarantineBackdrop, "gfx/backdrop/quarantine/", ".png")
EXILE_M.QuarantineBackdropsBloody = StageAPI.BackdropHelper(EXILE_M.QuarantineBloody, "gfx/backdrop/quarantine/", ".png")

EXILE_M.QuarantineRoomGfx = StageAPI.RoomGfx(EXILE_M.QuarantineBackdrops, QuarantineGrid, "_default", "stageapi/shading/shading")
EXILE_M.QuarantineRoomGfxBloody = StageAPI.RoomGfx(EXILE_M.QuarantineBackdropsBloody, QuarantineGrid, "_default", "stageapi/shading/shading")

EXILE_M.Stage.Quarantine = StageAPI.CustomStage("Quarantine")
EXILE_M.Stage.Quarantine:SetTransitionIcon("gfx/ui/stage/quarantine.png")
EXILE_M.Stage.Quarantine:SetRooms(QuarantineRoomsList)
--EXILE_M.Stage.Quarantine:SetBosses(EXILE_M.QuarantineBosses)
EXILE_M.Stage.Quarantine:SetRoomGfx(EXILE_M.QuarantineRoomGfx, {RoomType.ROOM_BOSS})
EXILE_M.Stage.Quarantine:SetRoomGfx(EXILE_M.QuarantineRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS})
EXILE_M.Stage.Quarantine:SetMusic(Isaac.GetMusicIdByName("Quarantine"), {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE})
EXILE_M.Stage.Quarantine:SetBossMusic(CLOCKWORKBOSS, BOSSOVER, Music.MUSIC_JINGLE_BOSS, CLOCKWORKBOSSEND)
EXILE_M.Stage.Quarantine:SetTransitionMusic(FLOORINTRO2)
EXILE_M.Stage.Quarantine:SetSpots("gfx/ui/stage/bossspot_tidal.png", "gfx/ui/stage/playerspot_tidal.png") -- change
EXILE_M.Stage.Quarantine:SetDisplayName("Quarantine I")
EXILE_M.Stage.Quarantine.IsSecondStage = false
EXILE_M.Stage.Quarantine:SetReplace(StageAPI.StageOverride.ScarredWombOne)


local QuarantineXL = EXILE_M.Stage.Quarantine("Quarantine XL")
QuarantineXL:SetDisplayName("Quarantine XL")
QuarantineXL:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_2
})
QuarantineXL.IsSecondStage = true

EXILE_M.Stage.Quarantine:SetXLStage(QuarantineXL)

QuarantineTwo = EXILE_M.Stage.Quarantine("Quarantine II")

QuarantineTwo:SetReplace(StageAPI.StageOverride.ScarredWombTwo)
QuarantineTwo:SetDisplayName("Quarantine II")
EXILE_M.Stage.Quarantine:SetNextStage(QuarantineTwo)
QuarantineTwo:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_1
})

QuarantineTwo.IsSecondStage = true

function EXILE_M:ClockShader()
if EXILE_M.Stage.Clock:IsStage() and not EXILE_M.ThunderActive == true then
		EXILE_M.RShaders = 0.8
		EXILE_M.GShaders = 0.7
		EXILE_M.BShaders = 0.8
		else
		
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.ClockShader)

function EXILE_M:QuarShader()
if EXILE_M.Stage.Quarantine:IsStage() then
			EXILE_M.RShaders = 0.67
		EXILE_M.GShaders = 0.8
		EXILE_M.BShaders = 0.8
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.QuarShader)


local fanshadow = Sprite()
fanshadow:Load("gfx/backdrop/quarantine/fan_shadow.anm2", false)

function EXILE_M:onRenderFan()
		if not fanshadow:IsFinished("Idle") then
		fanshadow:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		fanshadow:RenderLayer(1, Isaac.WorldToRenderPosition(Vector(320,280),true))
		
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderFan)

function EXILE_M:fanUpd(player)
	fanshadow:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.fanUpd);


StageAPI.AddCallback("CaptainsLog", "PRE_TRANSITION_RENDER", 1, function()
    if EXILE_M.Stage.Quarantine:IsStage() then
	EXILE_M.QuarantineFog:Render()
	EXILE_M.QuarantineFog:SetAlpha(0.8)
		if not fanshadow:IsPlaying("Idle") then
		fanshadow:Reload()
		fanshadow:LoadGraphics()
		fanshadow:Play("Idle", true)
		end
	else
	fanshadow:Stop()

    end
end)



---------------------------
--------------------------------------


--------------------------- STYX
-----------------------------------------------------------------------------------------

local styxfog = "gfx/backdrop/styx/styxfog.anm2"

EXILE_M.StyxFog = StageAPI.Overlay(styxfog, Vector(0.20,0.20), Vector(-25,-25))
EXILE_M.StyxFog:SetAlpha(0)

EXILE_M.StyxFog2 = StageAPI.Overlay(styxfog, Vector(0.6,0.6), Vector(-4,-4))
EXILE_M.StyxFog2:SetAlpha(0)

local StyxGrid = StageAPI.GridGfx()
StyxGrid:AddDoors("gfx/grid/styx/normaldoor.png", StageAPI.DefaultDoorSpawn)
StyxGrid:AddDoors("gfx/grid/styx/hole.png", StageAPI.SecretDoorSpawn)

StyxGrid:SetRocks("gfx/grid/styx/rocks.png")
StyxGrid:SetPits("gfx/grid/styx/pit.png")
--StyxGrid:SetBridges("gfx/grid/styx/bridge.png")
StyxGrid:SetDecorations("gfx/grid/props_03_caves.png")

EXILE_M.StyxGrid = StyxGrid

local StyxBackdrop1 = StageAPI.BackdropHelper({
    Walls = {"1", "2", "3"},
    NFloors = {"nfloor"},
    LFloors = {"lfloor"},
    Corners = {"corner"}
}, "gfx/backdrop/styx/styx_", ".png")

--local StyxEntrance = StageAPI.BackdropHelper({
--    Walls = {"entrance"}
--}, "gfx/backdrop/clockwork/styx_", ".png")

--local StyxEntranceGfx = StageAPI.RoomGfx(StyxEntrance, StyxGrid, "_default", "stageapi/shading/shading")

EXILE_M.StyxFloors = {
        {"styx_1"},
		{"styx_2"}
    }

   EXILE_M.StyxBackdrop = {
        {
            Walls = {"styx_1"},
            NFloors = {"styx_nfloor"},
            LFloors = {"styx_lfloor"},
            Corners = {"styx_corner"}
        }
    }



EXILE_M.StyxBackdrops = StageAPI.BackdropHelper(EXILE_M.StyxBackdrop, "gfx/backdrop/styx/", ".png")


EXILE_M.StyxRoomGfx = StageAPI.RoomGfx(EXILE_M.StyxBackdrops, StyxGrid, "_default", "stageapi/shading/shading")

EXILE_M.Stage.Styx = StageAPI.CustomStage("Styx")
EXILE_M.Stage.Styx:SetTransitionIcon("gfx/ui/stage/styx.png")
EXILE_M.Stage.Styx:SetRooms(ClockworkRoomsList)
--EXILE_M.Stage.Styx:SetBosses(EXILE_M.StyxBosses)
EXILE_M.Stage.Styx:SetRoomGfx(EXILE_M.StyxRoomGfx, {RoomType.ROOM_BOSS})
EXILE_M.Stage.Styx:SetRoomGfx(EXILE_M.StyxRoomGfx, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS})
EXILE_M.Stage.Styx:SetMusic(Isaac.GetMusicIdByName("Styx"), {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE})
EXILE_M.Stage.Styx:SetBossMusic(CLOCKWORKBOSS, BOSSOVER, Music.MUSIC_JINGLE_BOSS, CLOCKWORKBOSSEND)
EXILE_M.Stage.Styx:SetTransitionMusic(FLOORINTRO2)
EXILE_M.Stage.Styx:SetSpots("gfx/ui/stage/bossspot_tidal.png", "gfx/ui/stage/playerspot_tidal.png") -- change
EXILE_M.Stage.Styx:SetDisplayName("Styx I")
EXILE_M.Stage.Styx.IsSecondStage = false
EXILE_M.Stage.Styx:SetReplace(StageAPI.StageOverride.FloodedCavesOne)


local StyxXL = EXILE_M.Stage.Styx("Styx XL")
StyxXL:SetDisplayName("Styx XL")
StyxXL:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_2
})
StyxXL.IsSecondStage = true

EXILE_M.Stage.Styx:SetXLStage(StyxXL)

StyxTwo = EXILE_M.Stage.Styx("Styx II")

StyxTwo:SetReplace(StageAPI.StageOverride.FloodedCavesTwo)
StyxTwo:SetDisplayName("Styx II")
EXILE_M.Stage.Styx:SetNextStage(StyxTwo)
StyxTwo:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_1
})

StyxTwo.IsSecondStage = true



function EXILE_M:StyxShader()
if EXILE_M.Stage.Styx:IsStage() and not EXILE_M.ThunderActive == true then
		EXILE_M.RShaders = 0.6
		EXILE_M.GShaders = 0.7
		EXILE_M.BShaders = 0.8
		else
		
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.StyxShader)

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if EXILE_M.Stage.Styx:IsStage() then
	EXILE_M.StyxLightsInit = false
	end
end)

function EXILE_M:StyxLights()
	local player = Isaac.GetPlayer(0)
	if EXILE_M.Stage.Styx:IsStage() then
	if not EXILE_M.StyxLightsInit == true then
	local room = Game():GetRoom()
	
	local light1 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS, 4, room:GetTopLeftPos(), Vector(0,0), nil)
	light1:SetColor(Color(15, 7, 0, 1, 0, 0, 0),0,1,false,false)
	light1:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light1:GetSprite():LoadGraphics()
	light1:GetData().CustomLightDecor = true
	light1:GetData().LightPosition = room:GetTopLeftPos()
	light1:GetData().SpriteScale = Vector(1.05,1.05)
	
	local light2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIREWORKS, 4, room:GetBottomRightPos(), Vector(0,0), nil)
	light2:SetColor(Color(15, 7, 0, 1, 0, 0, 0),0,1,false,false)
	light2:GetSprite():ReplaceSpritesheet(0, "gfx/ui/none.png")
    light2:GetSprite():LoadGraphics()
	light2:GetData().CustomLightDecor = true
	light2:GetData().LightPosition = room:GetBottomRightPos()
	light2:GetData().SpriteScale = Vector(1.05,1.05)
	
	EXILE_M.StyxLightsInit = true
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.StyxLights)

function EXILE_M:ThunderShader()
if EXILE_M.Stage.Styx:IsStage() then
		if thundertimer == 244 then
		local roll = math.random(1,12)
		if roll > 5 then
		EXILE_M.ThunderActive = true
		Game():ShakeScreen(6,6)
		EXILE_M.RShaders = 10.7
		EXILE_M.GShaders = 10.7
		EXILE_M.BShaders = 12.7
		sound:Play(Sounds.THUNDER,1.94,0,false,1)
		else
		EXILE_M.ThunderActive = false
		thundertimer = 0
		end
		end
		if thundertimer == 255 then
		EXILE_M.ThunderActive = false
		end
		if thundertimer == 264 then
		thundertimer = 0

		end 		
		if thundertimer == 248 then
		Game():Darken(1,80)
		end 
		if thundertimer < 264 then
		if EXILE_M.RShaders > 0.7 then
		EXILE_M.RShaders = EXILE_M.RShaders - 2
		end
		if EXILE_M.GShaders > 0.7 then
		EXILE_M.GShaders = EXILE_M.GShaders - 2
		end
				if EXILE_M.BShaders > 0.7 then
		EXILE_M.BShaders = EXILE_M.BShaders - 2
		end
		end
		thundertimer = thundertimer + 1		
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.ThunderShader)

raintimer = 0
raintimer2 = 0
function EXILE_M:StyxRain()
if EXILE_M.Stage.Styx:IsStage() then
		if raintimer == 5 then
		local roll = math.random(1,6)
		if roll > 3 then
		local slash = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Styx Rain"), 0, Isaac.GetRandomPosition(48), Vector(0,0), player)
		raintimer = 0
		else
		raintimer = 0
		end
		end
		
		if raintimer2 == 6 then
		local roll = math.random(1,6)
		if roll > 3 then
		local slash2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Styx Rain"), 0, Isaac.GetRandomPosition(120), Vector(0,0), player)
		raintimer2 = 0
		else
		raintimer2 = 0
		end
		end
		
		raintimer = raintimer + 1		
		raintimer2 = raintimer2 + 1		
	end
end


EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.StyxRain)

raintimer3 = 0
raintimer4 = 0
function EXILE_M:BloodRain()
local room = Game():GetRoom()
if EXILE_M.Stage.Quarantine:IsStage() and room:HasWater() then
		if raintimer3 == 12 then
		local roll = math.random(1,6)
		if roll > 3 then
		local slash = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Styx Rain Blood"), 0, Isaac.GetRandomPosition(48), Vector(0,0), player)
		raintimer3 = 0
		else
		raintimer3 = 0
		end
		end
		
		if raintimer4 == 14 then
		local roll = math.random(1,6)
		if roll > 3 then
		local slash2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Styx Rain Blood"), 0, Isaac.GetRandomPosition(120), Vector(0,0), player)
		raintimer4 = 0
		else
		raintimer4 = 0
		end
		end
		
		raintimer3 = raintimer3 + 1		
		raintimer4 = raintimer4 + 1		
	end
end


EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.BloodRain)

--- rain
EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local drops = Isaac.FindByType(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Styx Rain"), -1, false, false)
    for _, entity in ipairs(drops) do
		local room = Game():GetRoom()
        local sprite = entity:GetSprite()
		if not sprite:IsPlaying("Rain") and not sprite:IsFinished("Rain") then
		sprite:Play("Rain")
		end
		if sprite:IsEventTriggered("Impact") then
		sound:Play(SoundEffect.SOUND_WATER_DROP,1.2,0,false,0.9)
		end
		if sprite:IsEventTriggered("Impact2") then
		sound:Play(SoundEffect.SOUND_WATER_DROP,1.1,0,false,1)
		end
		if sprite:IsFinished("Rain") then
		entity:Remove()
		end

    end
end)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local drops = Isaac.FindByType(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Styx Rain Blood"), -1, false, false)
    for _, entity in ipairs(drops) do
		local room = Game():GetRoom()
        local sprite = entity:GetSprite()
		if not sprite:IsPlaying("Rain") and not sprite:IsFinished("Rain") then
		sprite:Play("Rain")
		end
		if sprite:IsEventTriggered("Impact") then
		sound:Play(SoundEffect.SOUND_WATER_DROP,1.2,0,false,0.9)
		end
		if sprite:IsEventTriggered("Impact2") then
		sound:Play(SoundEffect.SOUND_WATER_DROP,1.1,0,false,1)
		end
		if sprite:IsFinished("Rain") then
		entity:Remove()
		end

    end
end)






StageAPI.AddCallback("CaptainsLog", "PRE_TRANSITION_RENDER", 1, function()
    if EXILE_M.Stage.Styx:IsStage() then
	StageAPI.ChangeStageShadow("gfx/backdrop/styx/overlays/", 5)
	EXILE_M.StyxFog:Render()
	EXILE_M.StyxFog:SetAlpha(1)
		EXILE_M.StyxFog2:Render()
	EXILE_M.StyxFog2:SetAlpha(1)

    end
end)


function EXILE_M:RegulateShader()
if not EXILE_M.Stage.Quarantine:IsStage() and
not EXILE_M.Stage.Clock:IsStage() and 
not EXILE_M.Stage.Styx:IsStage() then
		EXILE_M.RShaders = 1
		EXILE_M.GShaders = 1
		EXILE_M.BShaders = 1
		else
		
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.RegulateShader)

function EXILE_M:ReplaceGaperStage(gaper)
	if EXILE_M.Stage.Clock:IsStage() then
		local data = gaper:GetData()
		
		if data.UpdatedGraphics == nil then data.UpdatedGraphics = false end
		local sprite = gaper:GetSprite()
		if not data.UpdatedGraphics then
		local roll = math.random(1,3)
		if roll == 1 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/gaperhead_clockwork.png")
		elseif roll == 2 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/gaperhead_clockwork2.png")
		elseif roll == 3 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/gaperhead_clockwork3.png")
		end
		sprite:ReplaceSpritesheet(0, "gfx/monsters/clockwork_bodies2.png")
		sprite:LoadGraphics()
		data.UpdatedGraphics = true
    end
	end
	
		if EXILE_M.Stage.Quarantine:IsStage() then
		local data = gaper:GetData()
		
		if data.UpdatedGraphics == nil then data.UpdatedGraphics = false end
		local sprite = gaper:GetSprite()
		if not data.UpdatedGraphics then
		local roll = math.random(1,3)
		if roll == 1 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/quarantine/gaperhead_quarantine.png")
		elseif roll == 2 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/quarantine/gaperhead_quarantine2.png")
		elseif roll == 3 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/quarantine/gaperhead_quarantine3.png")
		end
		sprite:ReplaceSpritesheet(0, "gfx/monsters/captainslog/quarantine/quarantine_bodies.png")
		sprite:LoadGraphics()
		data.UpdatedGraphics = true
    end
	end
	
			if EXILE_M.Stage.Styx:IsStage() then
		local data = gaper:GetData()
		
		if data.UpdatedGraphics == nil then data.UpdatedGraphics = false end
		local sprite = gaper:GetSprite()
		if not data.UpdatedGraphics then
		local roll = math.random(1,3)
		if roll == 1 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/styx/gaperhead_styx.png")
		elseif roll == 2 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/styx/gaperhead_styx2.png")
		elseif roll == 3 then
		sprite:ReplaceSpritesheet(1, "gfx/monsters/captainslog/styx/gaperhead_styx2.png")
		end
		sprite:ReplaceSpritesheet(0, "gfx/monsters/captainslog/styx/styx_bodies.png")
		sprite:LoadGraphics()
		data.UpdatedGraphics = true
    end
	end
	
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ReplaceGaperStage, EntityType.ENTITY_GAPER)

function EXILE_M:ShockwavesUpd()
	if EXILE_M.Stage.Clock:IsStage() then
	local vials = Isaac.FindByType(EntityType.ENTITY_EFFECT, 62, -1, true, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		local data = tear:GetData()
		local sprite = tear:GetSprite()
		local rock = Game():Spawn(EntityType.ENTITY_EFFECT,Isaac.GetEntityVariantByName("Clockwork Shockwave"), tear.Position, Vector(0,0), player, 0, 0)
		rock.SpriteScale = tear.SpriteScale
		tear:Remove()
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.ShockwavesUpd)

--------------------------
------------------------------------------------------



---- CASETTE Room






EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
  if playedEntranceMusicLastRoom then
    if not room:GetType() == RoomType.ROOM_SHOP then
      music:Play(EXILE_M.musicid, 0)
      music:UpdateVolume()
    end

    playedEntranceMusicLastRoom = false
  end
end)

---if Input.IsButtonPressed(Keyboard.KEY_TAB, 0)  then

local CustomStreak = Sprite()
CustomStreak:Load("gfx/ui/ingameui/streak.anm2", false)

function EXILE_M:onRenderStreak()
		if not CustomStreak:IsFinished("TextIn") then
		CustomStreak:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
		if not CustomStreak:IsFinished("TextOut") then
		CustomStreak:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
		if not CustomStreak:IsFinished("TextStay") then
		CustomStreak:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderStreak)

function EXILE_M:streakUpdate(player)
	CustomStreak:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.streakUpdate);


EXILE_M.StreakState = 0
function EXILE_M:StreakPostUpdateCheck()
	local player = Isaac.GetPlayer(0)
		if not CustomStreak:IsPlaying("Text") and not CustomStreak:IsFinished("Text") and Input.IsButtonPressed(Keyboard.KEY_TAB, 0) and EXILE_M.StreakState == 0 then
		CustomStreak:Reload()
		CustomStreak:LoadGraphics()
		CustomStreak:Play("Text", true)
		EXILE_M.StreakState = 1
		end
		if CustomStreak:IsPlaying("Text") and CustomStreak:GetFrame() == 8 then
		EXILE_M.StreakState = 2
		if Input.IsButtonPressed(Keyboard.KEY_TAB, 0) then
		CustomStreak:SetFrame("Text", 8)
		end
		end
		if not Input.IsButtonPressed(Keyboard.KEY_TAB, 0) and not CustomStreak:IsPlaying("TextOut") and not CustomStreak:IsFinished("TextOut") and EXILE_M.StreakState == 2 then
		CustomStreak:Reload()
		CustomStreak:LoadGraphics()
		CustomStreak:Play("TextOut", true)
		end
		
		if CustomStreak:IsFinished("TextOut") then
		CustomStreak:Reload()
		CustomStreak:LoadGraphics()
		CustomStreak:Play("Invisible", true)
		EXILE_M.StreakState = 0
		end
		
		if EXILE_M.StreakState == 0 then
		CustomStreak:Reload()
		CustomStreak:LoadGraphics()
		CustomStreak:Play("Invisible", true)
		end
		
		

	if EXILE_M.Stage.Clock:IsStage() then
	CustomStreak:ReplaceSpritesheet(0, "gfx/ui/ingameui/floornames/Clockwork.png")
	CustomStreak:LoadGraphics()
	elseif EXILE_M.Stage.Quarantine:IsStage() then
	CustomStreak:ReplaceSpritesheet(0, "gfx/ui/ingameui/floornames/Quarantine.png")
	CustomStreak:LoadGraphics()
	elseif EXILE_M.Stage.Styx:IsStage() then
	CustomStreak:ReplaceSpritesheet(0, "gfx/ui/ingameui/floornames/Styx.png")
	CustomStreak:LoadGraphics()
	else
	CustomStreak:ReplaceSpritesheet(0, "gfx/ui/ingameui/floornames/blank.png")
	CustomStreak:LoadGraphics()
	end
	Isaac.DebugString(EXILE_M.StreakState)
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.StreakPostUpdateCheck);


end


local Morality = Sprite()
Morality:Load("gfx/ui/ingameui/moralitymeter.anm2", false)

function EXILE_M:onRenderMeter()
	local room = Game():GetRoom()
		if not Morality:IsFinished("MeterIn") then
		Morality:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
		if not Morality:IsFinished("MeterOut") then
		Morality:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
		if not Morality:IsFinished("MeterStay") then
		Morality:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderMeter)

function EXILE_M:meterUpd(player)
	Morality:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.meterUpd);

EXILE_M.MeterState = 0
function EXILE_M:MoralityMeterUpd()
	local player = Isaac.GetPlayer(0)
		if not Morality:IsPlaying("Meter") and not Morality:IsFinished("Meter") and Input.IsButtonPressed(Keyboard.KEY_TAB, 0) and EXILE_M.MeterState == 0 then
		Morality:Reload()
		Morality:LoadGraphics()
		Morality:Play("Meter", true)
		EXILE_M.MeterState = 1
		end
		if Morality:IsPlaying("Meter") and Morality:GetFrame() == 9 then
		EXILE_M.MeterState = 2
		if Input.IsButtonPressed(Keyboard.KEY_TAB, 0) then
		Morality:SetFrame("Meter", 9)
		end
		end
		if not Input.IsButtonPressed(Keyboard.KEY_TAB, 0) and not Morality:IsPlaying("MeterOut") and not Morality:IsFinished("MeterOut") and EXILE_M.MeterState == 2 then
		Morality:Reload()
		Morality:LoadGraphics()
		Morality:Play("MeterOut", true)
		end
		
		if Morality:IsFinished("MeterOut") then
		Morality:Reload()
		Morality:LoadGraphics()
		Morality:Play("MeterInvisible", true)
		EXILE_M.MeterState = 0
		end
		
		if EXILE_M.MeterState == 0 then
		Morality:Reload()
		Morality:LoadGraphics()
		Morality:Play("MeterInvisible", true)
		end
	Isaac.DebugString(EXILE_M.MeterState)
	
	if EXILE_M.SavedData.Morality < -49 and EXILE_M.SavedData.Morality > -74 then
	Morality:ReplaceSpritesheet(0, "gfx/ui/ingameui/morality/moralitymeter_sin1.png")
	Morality:LoadGraphics()
	end
	
	if EXILE_M.SavedData.Morality < -74 then
	Morality:ReplaceSpritesheet(0, "gfx/ui/ingameui/morality/moralitymeter_evil.png")
	Morality:LoadGraphics()
	end
	
	if EXILE_M.SavedData.Morality > -49 then
	Morality:ReplaceSpritesheet(0, "gfx/ui/ingameui/morality/moralitymeter.png")
	Morality:LoadGraphics()
	end
	
	
	
	
end

function EXILE_M:RenderMorality()
	if Input.IsButtonPressed(Keyboard.KEY_TAB, 0) then
	if EXILE_M.SavedData.Morality < 10 and EXILE_M.SavedData.Morality > -10 then
	Isaac.RenderScaledText(EXILE_M.SavedData.Morality, 237, 76, 1, 1, 1, 1, 1, 255)  
	else
	Isaac.RenderScaledText(EXILE_M.SavedData.Morality, 231, 76, 1, 1, 1, 1, 1, 255)  
	end

	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.MoralityMeterUpd);
EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.RenderMorality);

function EXILE_M:ResetMorality()
EXILE_M.StreakState = 0
EXILE_M.MeterState = 0
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetMorality);

--- Morality Scripts

function EXILE_M:MoralityCheckShopkeepers()
	local player = Isaac.GetPlayer(0)
	local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
	eff.DepthOffset = 44
	sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
	EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality - 2 
	player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
	StageAPI.PlayTextStreak("Morality -2", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.MoralityCheckShopkeepers, EntityType.ENTITY_SHOPKEEPER);

function EXILE_M:MoralityCheckSlot(entity)
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()

	if level:GetStateFlag(LevelStateFlag.STATE_BUM_KILLED) then
		if EXILE_M.SavedData.LevelResetBumDeaths == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality - 6
		StageAPI.PlayTextStreak("Morality -6", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
		EXILE_M.SavedData.LevelResetBumDeaths = 1
		end
	end
	if level:GetStateFlag(LevelStateFlag.STATE_BUM_LEFT) then
		if EXILE_M.SavedData.LevelResetBumDeaths2 == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYUP, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.HOLY_TWO,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality + 10
		EXILE_M.SavedData.MoralityMultiplier = EXILE_M.SavedData.MoralityMultiplier + 2
		StageAPI.PlayTextStreak("Morality +10", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		EXILE_M.SavedData.LevelResetBumDeaths2 = 1
		player:AnimateHappy()
		end
	end
	if level:GetStateFlag(LevelStateFlag.STATE_EVIL_BUM_LEFT) then
		if EXILE_M.SavedData.LevelResetBumDeaths3 == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality - 6
		player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
		StageAPI.PlayTextStreak("Morality -6", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		EXILE_M.SavedData.LevelResetBumDeaths3 = 1
		end
	end
	if room:GetType() == RoomType.ROOM_DEVIL then
		if EXILE_M.SavedData.DevilRoomMorality == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality - 2
		player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
		StageAPI.PlayTextStreak("Morality -2", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		EXILE_M.SavedData.DevilRoomMorality = 1
		end
	end	
	if Game():GetDevilRoomDeals() > 0 then
		if EXILE_M.SavedData.LevelResetBumDeaths4 == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,0.7)
		EXILE_M.SavedData.MoralityMultiplier = EXILE_M.SavedData.MoralityMultiplier - 5
		player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
		StageAPI.PlayTextStreak("Morality Multiplier -5", nil, nil, nil, "gfx/ui/ingameui/morality/moralitymult_5.png", Vector(124, 55), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		EXILE_M.SavedData.LevelResetBumDeaths4 = 1
		end
	end
	if Game():GetStateFlag(GameStateFlag.STATE_DONATION_SLOT_BLOWN) then
		if EXILE_M.SavedData.LevelResetBumDeaths5 == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality - 6
		player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
		StageAPI.PlayTextStreak("Morality -6", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		EXILE_M.SavedData.LevelResetBumDeaths5 = 1
		end
	end	
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.MoralityCheckSlot);

function EXILE_M:MoralityLevelUpd()

if Game():GetFrameCount() > 9 then
	EXILE_M.SavedData.LevelResetBumDeaths = 0
	EXILE_M.SavedData.LevelResetBumDeaths2 = 0
	EXILE_M.SavedData.LevelResetBumDeaths3 = 0
	EXILE_M.SavedData.DevilRoomMorality = 0
	if EXILE_M.SavedData.Morality > 0 then
	EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality + 3
	end
	if EXILE_M.SavedData.MoralityMultiplier < 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
		player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
	end
	if EXILE_M.SavedData.MoralityMultiplier > 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYUP, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.HOLY_TWO,1.4,0,false,1)
		player:AnimateHappy()
	end
		
		
	EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality + EXILE_M.SavedData.MoralityMultiplier
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EXILE_M.MoralityLevelUpd);

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source)
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	if flags == DamageFlag.DAMAGE_SPIKES then
		if room:GetType() == RoomType.ROOM_SACRIFICE then
			local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYUP, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.HOLY_TWO,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality + 2
		StageAPI.PlayTextStreak("Morality +2", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		player:AnimateHappy()
		end
	end
end, EntityType.ENTITY_PLAYER)



function EXILE_M:BelialPenalty()
	local player = Isaac.GetPlayer(0)
	local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYDOWN, 0, player.Position, Vector(0,0), player)
	eff.DepthOffset = 44
	sound:Play(Sounds.MORALITYDOWNSM,1.4,0,false,1)
	EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality - 2
	player:SetColor(Color(0.4, 0.1, 0.1, 1, 6, 0, 0),7,5,true,false)
	StageAPI.PlayTextStreak("Morality -2", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
end

EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.BelialPenalty, CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL);


EXILE_M.RShaders = 1
EXILE_M.GShaders = 1
EXILE_M.BShaders = 1

function EXILE_M:GetShaderParams(Shaders)
if EXILE_M.RShaders == nil then EXILE_M.RShaders = 1 end
if EXILE_M.GShaders == nil then EXILE_M.RShaders = 1 end
if EXILE_M.BShaders == nil then EXILE_M.RShaders = 1 end
 local params = { 
 Red = EXILE_M.RShaders,
 Green = EXILE_M.GShaders,
 Blue = EXILE_M.BShaders,
 PlayerPos = { Isaac.GetPlayer(0).Position.X / 100.0,
 Isaac.GetPlayer(0).Position.Y / 100.0 },
 Time = Isaac.GetFrameCount()
 }
 return params;
end

EXILE_M:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, EXILE_M.GetShaderParams)


function EXILE_M:MoralityHalo(player)
	local player = Isaac.GetPlayer(0)
	if game:GetFrameCount() > 7 then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_HALO) then
		if EXILE_M.SavedData.HasHalo == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYUP, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		EXILE_M.SavedData.MoralityMultiplier = EXILE_M.SavedData.MoralityMultiplier + 5
		sound:Play(Sounds.HOLY_TWO,1.4,0,false,1)
		StageAPI.PlayTextStreak(" ", nil, nil, nil, "gfx/ui/ingameui/morality/moralitymult_up5.png", Vector(124, 55), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		player:AnimateHappy()
		EXILE_M.SavedData.HasHalo = 1
		end
		end
	end
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_HALO) then
	if EXILE_M.SavedData.HasHalo == 1 then
	EXILE_M.SavedData.HasHalo = 0
	EXILE_M.SavedData.MoralityMultiplier = EXILE_M.SavedData.MoralityMultiplier - 5
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.MoralityHalo);

function EXILE_M:MoralityBloodofMartyr(player)
	local player = Isaac.GetPlayer(0)
	if game:GetFrameCount() > 7 then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_MARTYR) then
		if EXILE_M.SavedData.HasBloodofMartyr == 0 then
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYUP, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		EXILE_M.SavedData.MoralityMultiplier = EXILE_M.SavedData.MoralityMultiplier + 5
		sound:Play(Sounds.HOLY_TWO,1.4,0,false,1)
		StageAPI.PlayTextStreak(" ", nil, nil, nil, "gfx/ui/ingameui/morality/moralitymult_up5.png", Vector(124, 55), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
		player:AnimateHappy()
		EXILE_M.SavedData.HasBloodofMartyr = 1
		end
		end
	end
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_MARTYR) then
	if EXILE_M.SavedData.HasBloodofMartyr == 1 then
	EXILE_M.SavedData.HasBloodofMartyr = 0
	EXILE_M.SavedData.MoralityMultiplier = EXILE_M.SavedData.MoralityMultiplier - 5
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.MoralityBloodofMartyr);

function EXILE_M:BibleBoost()
		local player = Isaac.GetPlayer(0)
		local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MORALITYUP, 0, player.Position, Vector(0,0), player)
		eff.DepthOffset = 44
		sound:Play(Sounds.HOLY_TWO,1.4,0,false,1)
		EXILE_M.SavedData.Morality = EXILE_M.SavedData.Morality + 4
		StageAPI.PlayTextStreak("Morality +4", nil, nil, nil, "gfx/ui/effect_cursepaper.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
end

EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.BibleBoost, CollectibleType.COLLECTIBLE_BIBLE);


Isaac.ConsoleOutput("[Exile] Loading the StageAPI Content..")

if StageAPI and StageAPI.Loaded then
    loadmod()
	Isaac.ConsoleOutput("[Exile] StageAPI was loaded successfully! *whew*")
else
    if not StageAPI then
	Isaac.ConsoleOutput("[Exile] StageAPI was not able to load! Do you not have it installed or have an outdated version?")
	Isaac.ConsoleOutput("[Exile] There was an error loading the mod content. If this message occurs again please consult the creator.")
        StageAPI = {Loaded = false, ToCall = {}}
    end

    StageAPI.ToCall[#StageAPI.ToCall + 1] = loadmod
end
	
EXILE_M.Modules = {

	"lua/func/clockwork/enemies/enemies.lua",
	"lua/func/styx/enemies.lua",
	"lua/func/quarantine/core.lua",
	"lua/func/quarantine/enemies.lua",
	"lua/func/exile/characters.lua",
	"lua/func/exile/items.lua",
	"lua/func/quarantine/enemies/bosses/the_plague.lua",
	"lua/func/quarantine/enemies/bosses/the_shackle.lua",
	"lua/func/quarantine/harpoon.lua"

}	
	
EXILE_M.LoadFunctions = {}
for i,v in ipairs(EXILE_M.Modules) do
  local _, err = pcall(require, v)
  if string.match(tostring(err), "attempt to index a nil value %(field 'bork'%)") then --supposed to error this way at end of file for luamod command workaround
    exile_m.loadCounter = exile_m.loadCounter + 1
  else
  --  Isaac.DebugString("Failed to load module: " .. tostring(err))
   -- Isaac.ConsoleOutput("Failed to load module: " .. tostring(err) .. "\n")
  end
end



if exile_m.loadCounter < #EXILE_M.Modules then
  --error("Exile: Couldn't load everything!")
else
  Isaac.DebugString("Exile: Finished initial loading!")
end

function EXILE_M.RunLoadFunctions()
    for _, fn in ipairs(EXILE_M.LoadFunctions) do
        fn()
    end
end	

if StageAPI and StageAPI.Loaded then
    EXILE_M.RunLoadFunctions()
else
    if not StageAPI then
        StageAPI = {Loaded = false, ToCall = {}}
    end

    StageAPI.ToCall[#StageAPI.ToCall + 1] = EXILE_M.RunLoadFunctions
end


function EXILE_M:AgnesRender()
local player = Isaac.GetPlayer(0)
if player:GetPlayerType() == Agnes_Char.PlayerType then
	if EXILE_M.SavedData.InitAgnes == 0 then
		player:AddCollectible(EXILE_M.COLLECTIBLE_CORINTHCLOAK, 0, false)
		player:AddNullCostume(EXILE_M.COSTUME_CORINTHROBE)
		player:AddCollectible(EXILE_M.COLLECTIBLE_MISERICORDE, 0, false)
		
		EXILE_M.SavedData.InitAgnes = 1
	end

end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.AgnesRender)

function EXILE_M:SetAgnesStats(player, cacheFlag)
local player = Isaac.GetPlayer(0)
if player:GetPlayerType() == Agnes_Char.PlayerType then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage - 1.35
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed - 0.15
		end
end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.SetAgnesStats)


function EXILE_M:TimeButtonUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Time Reversal Button") then
	local npc = entity:ToNPC()
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if data.Pressed == nil then data.Pressed = false end
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.DepthOffset = -33;
	local pickup = entity:ToPickup()
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	
	if player.Position:Distance(entity.Position) < 17 and not data.Pressed and not EXILE_M.TurnBack then
	local getroom2 = game:GetRoom()
	data.Pressed = true
	entity:GetSprite():Play("Switched", true)
	sound:Play(SoundEffect.SOUND_BUTTON_PRESS,1.5,0,false,1)
	sound:Play(Sounds.HALLUCINATE,1.6,0,false,1)
	timeback:Reload()
	timeback:LoadGraphics()
	timeback:Play("Effect", true)
	Game():ShakeScreen(17,17)
	room:EmitBloodFromWalls(1,6)
	StageAPI.UseD7()
	EXILE_M.TurnBack = true
	end
	
	
	
	if not entity:GetSprite():IsPlaying("Idle", true) and not data.Pressed and not EXILE_M.TurnBack then
	entity:GetSprite():Play("Off", true)
	elseif not entity:GetSprite():IsPlaying("On", true) and data.Pressed and not EXILE_M.TurnBack then
	entity:GetSprite():Play("On", true)
	elseif entity:GetSprite():IsEventTriggered("Remove") then
	entity:Remove()
	elseif entity:GetSprite():GetFrame() == 3 then

	else
	if not entity:GetSprite():IsPlaying("On", true) then
	entity:GetSprite():Play("On", true)
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.TimeButtonUpdate, EntityType.TIMEBUTTON)

function EXILE_M:ClockSpinUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Clockdial (Spinner)") then
	local npc = entity:ToNPC()
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if data.Finished == nil then
	data.Finished = false 
	data.IgnoreArtemis = true 
	end
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.DepthOffset = -200;
	entity.RenderZOffset = -1500;
	
	if entity:GetSprite():IsPlaying("Spinning", true) then
	if entity:GetSprite():GetFrame() > 19 and entity:GetSprite():GetFrame() < 35 then
	for _, enemy in pairs(Isaac.GetRoomEntities()) do
		if enemy:IsActiveEnemy() and enemy.Position:Distance(entity.Position) < 160 then
			enemy:TakeDamage(25,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
		end
	end
	if player.Position:Distance(entity.Position) < 157 then
	player:TakeDamage(1,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
	end
	end
	end
	
	if not room:IsClear() then
	if entity:GetSprite():IsFinished("Idle", true) then
	entity:GetSprite():Play("Ticking", true)
	elseif entity:GetSprite():IsFinished("Ticking", true) then
	entity:GetSprite():Play("Spinning", true)
	sound:Play(Sounds.CLOCKSPIN,1.5,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Tick") then
	sound:Play(Sounds.CLOCKTICK,1.8,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Bell") then
	sound:Play(Sounds.LOUDBELL,1.8,0,false,1)
	Game():ShakeScreen(7,7)
	end
	else
	entity:GetSprite():Play("Idle", true)
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ClockSpinUpdate, EntityType.CLOCKSPINNER)

function EXILE_M:ClockSummonUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Clockdial (Summons)") then
	local npc = entity:ToNPC()
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if data.Finished == nil then data.Finished = false end
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	
	entity.DepthOffset = -200;
	entity.RenderZOffset = -1500;
	
	if not room:IsClear() then
		
		if entity:GetSprite():IsFinished("Idle", true) then
		entity:GetSprite():Play("Ticking", true)
		
		elseif entity:GetSprite():IsFinished("Ticking", true) then
		entity:GetSprite():Play("Summon", true)
		
		elseif entity:GetSprite():IsEventTriggered("Tick") then
		sound:Play(Sounds.CLOCKTICK,1.8,0,false,1)
		
		elseif entity:GetSprite():IsEventTriggered("Sound1") then
		sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1.8,0,false,1)
		
		elseif entity:GetSprite():IsEventTriggered("Sound2") then
		sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.8,0,false,1.6)
		
		elseif entity:GetSprite():IsEventTriggered("Sound3") then
		sound:Play(SoundEffect.SOUND_GHOST_ROAR,1.8,0,false,1.6)
		
		elseif entity:GetSprite():IsEventTriggered("Summon") then
		local gaper = Isaac.Spawn(EntityType.ENTITY_GAPER, 0, 0, entity.Position, Vector(0,1), entity)
		gaper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		
		end
		
		else
		entity:GetSprite():Play("Idle", true)
		end
		
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ClockSummonUpdate, EntityType.CLOCKSUMMON)

function EXILE_M:ClockResetUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Clockdial (Reset)") then
	local npc = entity:ToNPC()
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	if data.Finished == nil then data.Finished = false end
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.DepthOffset = -200;
	entity.RenderZOffset = -1500;
	
	if not room:IsClear() then
	if entity:GetSprite():IsFinished("Idle", true) and not EXILE_M.TurnBack then
	entity:GetSprite():Play("Ticking", true)
	elseif entity:GetSprite():IsFinished("Ticking", true) then
	sound:Play(Sounds.HALLUCINATE,5,0,false,1)
	timeback:Reload()
	timeback:LoadGraphics()
	timeback:Play("Effect", true)
	Game():ShakeScreen(17,17)
	room:EmitBloodFromWalls(1,6)
	StageAPI.UseD7()
	EXILE_M.TurnBack = true
	elseif entity:GetSprite():IsEventTriggered("Tick") then
	sound:Play(Sounds.CLOCKTICK,1.8,0,false,1)
	end
	else
	entity:GetSprite():Play("Idle", true)
	end
end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ClockResetUpdate, EntityType.CLOCKRESET)


function EXILE_M:FaucetRIGHTUpdate(entity)
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	entity.DepthOffset = 150;
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	if EXILE_M.ActivateFaucetRight == 1 then
		EXILE_M.ActivateFaucetRight = 0
		entity:GetSprite():Play("Pour", true)
		elseif entity:GetSprite():IsEventTriggered("Pour") then
		sound:Play(Sounds.SPLASH_WATER,1.8,0,false,1)
		sound:Play(Sounds.FAUCETPOUR,1.8,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Water") then
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_FLUSH,false)
		sound:Stop(SoundEffect.SOUND_FLUSH)
				sound:Play(Sounds.SPLASH_WATER,1,0,false,1)
				Isaac.Spawn(EntityType.GEYSER, 0, 0, Isaac.GetRandomPosition(25), Vector(0,0), nil)
				Isaac.Spawn(EntityType.GEYSER, 0, 0, Isaac.GetRandomPosition(25), Vector(0,0), nil)
		elseif entity:GetSprite():IsFinished("Pour") then
		entity:GetSprite():Play("Idle", true)
	end
	if EXILE_M.ActivateFaucetRight == 0 and not entity:GetSprite():IsPlaying("Pour", true) then
	entity:GetSprite():Play("Idle", true)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.FaucetRIGHTUpdate, EntityType.FAUCETRIGHT)

function EXILE_M:FaucetLEFTUpdate(entity)
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	entity.DepthOffset = 150;
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.FlipX = true
	if EXILE_M.ActivateFaucetLeft == 1 then
	EXILE_M.ActivateFaucetLeft = 0
		entity:GetSprite():Play("Pour", true)
		elseif entity:GetSprite():IsEventTriggered("Pour") then
		sound:Play(Sounds.SPLASH_WATER,1.8,0,false,1)
		sound:Play(Sounds.FAUCETPOUR,1.8,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Water") then
		player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_FLUSH,false)
		sound:Stop(SoundEffect.SOUND_FLUSH)
		elseif entity:GetSprite():IsFinished("Pour") then
		entity:GetSprite():Play("Idle", true)
	end
	if EXILE_M.ActivateFaucetLeft == 0 and not entity:GetSprite():IsPlaying("Pour", true) then
	entity:GetSprite():Play("Idle", true)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.FaucetLEFTUpdate, EntityType.FAUCETLEFT)








