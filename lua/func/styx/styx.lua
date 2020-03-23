
--------------------------- STYX
-----------------------------------------------------------------------------------------

local styxfog = "gfx/backdrop/styx/styxfog.anm2"

EXILE_M.StyxFog = StageAPI.Overlay(styxfog, Vector(0.20,0.20), Vector(-25,-25))
EXILE_M.StyxFog:SetAlpha(0)

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
EXILE_M.Stage.Styx:SetMusic(Isaac.GetMusicIdByName("Dank Depths"), {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE})
EXILE_M.Stage.Styx:SetBossMusic(CLOCKWORKBOSS, BOSSOVER, Music.MUSIC_JINGLE_BOSS, CLOCKWORKBOSSEND)
EXILE_M.Stage.Styx:SetTransitionMusic(FLOORINTRO2)
EXILE_M.Stage.Styx:SetSpots("gfx/ui/stage/bossspot_tidal.png", "gfx/ui/stage/playerspot_tidal.png") -- change
EXILE_M.Stage.Styx:SetDisplayName("Styx I")
EXILE_M.Stage.Styx.IsSecondStage = false
EXILE_M.Stage.Styx:SetReplace(StageAPI.StageOverride.ScarredWombOne)


local StyxXL = EXILE_M.Stage.Styx("Styx XL")
StyxXL:SetDisplayName("Styx XL")
StyxXL:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_2
})
StyxXL.IsSecondStage = true

EXILE_M.Stage.Styx:SetXLStage(StyxXL)

StyxTwo = EXILE_M.Stage.Styx("Styx II")

StyxTwo:SetReplace(StageAPI.StageOverride.ScarredWombTwo)
StyxTwo:SetDisplayName("Styx II")
EXILE_M.Stage.Styx:SetNextStage(StyxTwo)
StyxTwo:SetNextStage({
    NormalStage = true,
    Stage = LevelStage.STAGE3_1
})

StyxTwo.IsSecondStage = true

function EXILE_M:RegulateShader()
if not EXILE_M.Stage.Styx:IsStage() and
not EXILE_M.Stage.Clock:IsStage() then
		EXILE_M.RShaders = 1
		EXILE_M.GShaders = 1
		EXILE_M.BShaders = 1
		else
		
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.RegulateShader)



function EXILE_M:ClockShader()
if EXILE_M.Stage.Clock:IsStage() and not EXILE_M.ThunderActive == true then
		EXILE_M.RShaders = 0.8
		EXILE_M.GShaders = 0.8
		EXILE_M.BShaders = 0.8
		else
		
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.ClockShader)

function EXILE_M:QuarShader()
if EXILE_M.Stage.Styx:IsStage() then
			EXILE_M.RShaders = 0.67
		EXILE_M.GShaders = 0.8
		EXILE_M.BShaders = 0.8
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.QuarShader)





StageAPI.AddCallback("CaptainsLog", "PRE_TRANSITION_RENDER", 1, function()
    if EXILE_M.Stage.Styx:IsStage() then
	EXILE_M.StyxFog:Render()
	EXILE_M.StyxFog:SetAlpha(0.8)

    end
end)