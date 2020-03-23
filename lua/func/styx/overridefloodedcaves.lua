	if StageAPI and StageAPI.Loaded then
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
end