
---- RACHEL


do
Rachel_Char = {
	PlayerType = Isaac.GetPlayerTypeByName("Rachel"),
	HairGfx = Isaac.GetCostumeIdByPath("gfx/characters/rachel_hair.anm2"),
	BodyGfx = Isaac.GetCostumeIdByPath("gfx/characters/rachel_body.anm2"),
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

function EXILE_M:OnRenderRachel(player)
	if player:GetPlayerType() == Rachel_Char.PlayerType then
	player:AddNullCostume(Rachel_Char.HairGfx)
	player:AddNullCostume(Rachel_Char.BodyGfx)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, EXILE_M.OnRenderRachel)


function EXILE_M:RachelPost()
local player = Isaac.GetPlayer(0)
if player:GetPlayerType() == Rachel_Char.PlayerType then
	if EXILE_M.SavedData.InitRachel == 0 then
		player:AddCollectible(EXILE_M.COLLECTIBLE_CROSIER, 0, false)
		EXILE_M.SavedData.InitRachel = 1
	end
end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.RachelPost)

EXILE_M.bork.NonExistantFunctionThatIsCalledToIntentionallyErrorThis()
