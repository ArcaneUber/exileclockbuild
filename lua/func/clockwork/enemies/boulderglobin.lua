
function EXILE_M:BoulderGlobinUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Boulder Globin") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	if data.GridCountdown == nil then data.GridCountdown = 0 end
		if entity:IsFrame(2, 0) then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)

			if data.GridCountdown <= 0 then
			data.GridCountdown = 30
			else
			data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Velocity = (target.Position - entity.Position):Normalized() * 0.4 * 7
			end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BoulderGlobinUpdate, Isaac.GetEntityTypeByName("Boulder Globin"))

function EXILE_M:PostBoulderGlobinDeath(entity)
if entity.Variant == Isaac.GetEntityVariantByName("Boulder Globin") then
	local mass = Isaac.Spawn(Isaac.GetEntityTypeByName("Boulder Globin Mass"),Isaac.GetEntityVariantByName("Boulder Globin Mass"),0,entity.Position,Vector(0,0),entity)
	mass:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.PostBoulderGlobinDeath, Isaac.GetEntityTypeByName("Boulder Globin"))

function EXILE_M:BGlobinMassUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Boulder Globin Mass") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
	entity.Velocity = Vector(0,0)
	if not entity:GetSprite():IsPlaying("ReGen", true) then
	entity:GetSprite():Play("ReGen", true)
	end
	if entity:GetSprite():IsEventTriggered("Spawn") then
	local globin = Isaac.Spawn(Isaac.GetEntityTypeByName("Boulder Globin"),Isaac.GetEntityVariantByName("Boulder Globin"),0,entity.Position,Vector(0,0),entity)
	globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:Remove()
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BGlobinMassUpdate, Isaac.GetEntityTypeByName("Boulder Globin"))

function EXILE_M:PostMassDeath(entity)
if entity.Variant == Isaac.GetEntityVariantByName("Boulder Globin Mass") then
	for i = 1, 7 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-50,-10)
			local offsetx = math.random(-20,60)
			blood.PositionOffset = Vector(offsetx,offsety)
			Isaac.Explode(entity.Position, entity, 5)
		end
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1.3,0,false,0.7)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.PostMassDeath, Isaac.GetEntityTypeByName("Boulder Globin"))
