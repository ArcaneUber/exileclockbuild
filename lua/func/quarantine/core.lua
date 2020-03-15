

local function LoadCode()

EXILE_M.PoisonTimer = 0
EXILE_M.PoisonDamageTimer = 0
EXILE_M.Poisoned = false

function EXILE_M:ResetToxicity(player)
EXILE_M.RoomToxic = false
EXILE_M.PoisonTimer = 0
EXILE_M.PoisonDamageTimer = 0
EXILE_M.Poisoned = false
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetToxicity)


--------- MAIN FUNCTIONS

function EXILE_M:ToxicMeterFunctions()
	local player = Isaac.GetPlayer(0)
	local colorize = EXILE_M.PoisonTimer * 3 - 10
	local colorize2 = EXILE_M.PoisonTimer * 2
	
	if EXILE_M.Stage.Quarantine:IsStage() then
	if not EXILE_M.RoomToxic == true then

	elseif EXILE_M.RoomToxic == true then
	if EXILE_M.PoisonTimer < 11 then

	end

	if EXILE_M.PoisonTimer > 11 then
	
	end
	end
	
	------- Value Failsafes
	if EXILE_M.PoisonTimer > 45 then
	EXILE_M.PoisonTimer = 45
	end
	if EXILE_M.PoisonTimer < 0 then
	EXILE_M.PoisonTimer = 0
	end
	------------------
	
	if EXILE_M.PoisonTimer > 0 then
	EXILE_M.PoisonTimer = EXILE_M.PoisonTimer - 1
	end

	
	if colorize > 0 then
	player:SetColor(Color(1,1,1,1,0, colorize, 0), 35, 0, true, false)
	end
	
	
	if EXILE_M.PoisonTimer > 40 then
	if EXILE_M.PoisonDamageTimer == 23 then
	player:TakeDamage(1,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
	else
	EXILE_M.PoisonDamageTimer = EXILE_M.PoisonDamageTimer + 1
	end
	end
	
	for _, targ in pairs(Isaac.GetRoomEntities()) do
	local data2 = targ:GetData()
	if data2.Poisoning == true then
		if targ.Position:Distance(player.Position) < 56 then
			if EXILE_M.PoisonTimer < 45 then
			EXILE_M.PoisonTimer = EXILE_M.PoisonTimer + 2
			end
		end	
		end
	end
	
	else

	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.ToxicMeterFunctions)


end ----------- End Load Code


if StageAPI and StageAPI.Loaded then
    LoadCode()
else
    if not StageAPI then
        StageAPI = {Loaded = false, ToCall = {}}
    end

    StageAPI.ToCall[#StageAPI.ToCall + 1] = LoadCode
end

EXILE_M.bork.NonexistantFunction()
