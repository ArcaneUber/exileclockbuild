
function EXILE_M:SpecialGapersUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Grimace Gaper") then
	--entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	if entity.State == 0 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	sprite:PlayOverlay("Head", false)
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
		if entity:IsFrame(2, 0) then
		entity.Pathfinder:FindGridPath(target.Position, 0.75, 1, true)
			local attacktime = math.random(1,360)
			if attacktime > 350 and target.Position:Distance(entity.Position) > 110 then
			entity.State = 2
			attacktime = 0
			else
			entity.State = 0
			attacktime = 0
			end
		end
	elseif entity.State == 2 then
	if not sprite:IsPlaying("Jump", false) then
	entity.Velocity = Vector(0,0)
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
	sprite:Play("Jump", false)
	sprite:RemoveOverlay()
	end
	if sprite:IsPlaying("Jump", false) then
	if entity:GetSprite():IsEventTriggered("Stomp") then
	entity.Velocity = Vector(0,0)
	Game():ShakeScreen(7,7)
			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,11),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-11),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(11,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-11,0),entity):ToProjectile()
	
	
	tear5:GetData().RockProj = true
	tear5:GetData().Variant = Isaac.GetEntityVariantByName("Clockwork Shockwave")
	tear6:GetData().RockProj = true
	tear6:GetData().Variant = Isaac.GetEntityVariantByName("Clockwork Shockwave")
	tear7:GetData().RockProj = true
	tear7:GetData().Variant = Isaac.GetEntityVariantByName("Clockwork Shockwave")
	tear8:GetData().RockProj = true
	tear8:GetData().Variant = Isaac.GetEntityVariantByName("Clockwork Shockwave")
	
	sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.7,0,false,0.5)
	sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1)
	end
	if entity:GetSprite():IsEventTriggered("Jump") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
	entity:AddVelocity((target.Position - entity.Position):Normalized() * 13)
	sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,0.8,0,false,1.2)
	end
	if entity:GetSprite():IsEventTriggered("Done") then
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
	end

	--Game():BombDamage(entity.Position, 100, 21, false, entity, 0, 0, false)
	if sprite:IsFinished("Jump", false) then
		entity.State = 0
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.SpecialGapersUpdate, EntityType.SPECIALGAPER)

