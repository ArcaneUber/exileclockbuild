
EntityType.PERIWINKLE = Isaac.GetEntityTypeByName("Periwinkle")

EntityType.BEARTRAP = Isaac.GetEntityTypeByName("Bear Trap")
SoundEffect.SOUND_SNAP_SHUT = Isaac.GetSoundIdByName("SnapShut")
SoundEffect.SOUND_SQUISH = Isaac.GetSoundIdByName("DieSquish")


EntityType.JUNKER = Isaac.GetEntityTypeByName("Junker")

function EXILE_M:JunkerUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Junker") then
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	sprite:PlayOverlay("Head", false)
		if entity:IsFrame(2, 0) then
		entity.Pathfinder:FindGridPath(target.Position, 0.6, 1, true)
			if entity.Position:Distance(target.Position) < 100 then
			local roll = math.random(1,10)
			if roll > 7 then
			entity.State = 3
			else
			entity.State = 2
			end
			else
			entity.State = 0
			end
		end
	elseif entity.State == 2 then
	entity.Pathfinder:FindGridPath(target.Position, 0.45, 1, true)
	if not sprite:IsOverlayPlaying("Vomit") then
	sprite:PlayOverlay("Vomit", false)
	elseif sprite:IsOverlayPlaying("Vomit") then
		if sprite:GetOverlayFrame() == 8 then
		sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.4,60,false,1)
		elseif sprite:GetOverlayFrame() == 33 then
		for i = 1, 4 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(8)):Rotated(math.random(-10,10)) * (math.random(111, 150) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -0.002
			Projectile.FallingAccel = 0.02
			Projectile.Scale = (math.random(100,180))/65
			Projectile.Height = -22
			Projectile.DepthOffset = 43
			Projectile.Damage = 1
		Projectile:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		Projectile:GetSprite():LoadGraphics()
		Projectile:GetData().StoneProj = true
		end
		sound:Play(SoundEffect.SOUND_GHOST_SHOOT,1,60,false,1)
		
		--
		--
		
		end
	end
	if sprite:IsOverlayFinished("Vomit") then
		entity.State = 0
	end
	elseif entity.State == 3 then
	entity.Pathfinder:FindGridPath(target.Position, 0.2, 1, true)
	if not sprite:IsOverlayPlaying("Vomit") then
	sprite:PlayOverlay("Vomit", false)
	elseif sprite:IsOverlayPlaying("Vomit") then
		if sprite:GetOverlayFrame() == 8 then
		sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.4,60,false,1)
		elseif sprite:GetOverlayFrame() == 33 then
		
		for i = 1, math.random(2,3) do
		EntityNPC.ThrowSpider(entity.Position, entity, Vector(entity.Position.X - 60 + entity:GetDropRNG():RandomInt(121), entity.Position.Y - 60 + entity:GetDropRNG():RandomInt(121)), false, 0.0)
		end
		sound:Play(SoundEffect.SOUND_GHOST_SHOOT,1,60,false,1)
		
		end
		end
		if sprite:IsOverlayFinished("Vomit") then
		entity.State = 0
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.JunkerUpdate, EntityType.JUNKER)

function EXILE_M:JunkerDeath(entity)
			sound:Play(SoundEffect.SOUND_BOIL_HATCH,1,0,false,0.6)
			sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
	--local blood2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, 0, entity.Position, Vector(0,0), entity)
	local blood4 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, entity.Position, Vector(0,0), entity)
		for i = 1, 7 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-20,-10)
			local offsetx = math.random(-20,20)
			blood.SpriteScale = Vector(0.8,0.8)
			blood.PositionOffset = Vector(offsetx,offsety)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.JunkerDeath, EntityType.JUNKER);

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


function EXILE_M:BearTrapUpdate(entity)
local player = Isaac.GetPlayer(0)
local room = game:GetRoom()
local level = game:GetLevel()
local sprite = entity:GetSprite()
local data1 = entity:GetData()
	
if entity.Variant == Isaac.GetEntityVariantByName("Bear Trap") then
entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	if data1.Armed == nil then data1.Armed = false end
	if data1.RanScript == nil then data1.RanScript = false end

	if data1.RanScript == false and data1.Armed == false then ---- About a 50% of the trap being a dud, all other times it is armed
	local roll = math.random(1,8)
	if roll > 4 then
	data1.Armed = true
	else
	data1.Armed = false
	end
	data1.RanScript = true
	end
	
	if entity.State == 0 then
	sprite:Play("Idle", false)
	entity.DepthOffset = -23
	if player.Position:Distance(entity.Position + Vector(0,-25)) < 41 and not player:IsDead() and data1.Armed == true then
	entity.State = 2
	end
	elseif entity.State == 2 then
	if not sprite:IsPlaying("Snap") and not sprite:IsPlaying("Snapped") and not sprite:IsPlaying("IdleSnapped") then
	sprite:Play("Snap", false)
	entity.DepthOffset = 45
	elseif sprite:IsPlaying("Snap") then
	if sprite:IsEventTriggered("snap") then
	sound:Play(SoundEffect.SOUND_SNAP_SHUT,1.3,0,false,1)
	if player.Position:Distance(entity.Position + Vector(0,-25)) < 41 then
	music:Fadeout()
	sound:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT,1.45,0,false,1.1)
	player:GetSprite():ReplaceSpritesheet(12, "gfx/ui/none.png")
	player:GetSprite():ReplaceSpritesheet(13, "gfx/ui/none.png")
    player:GetSprite():LoadGraphics()
	player:Kill()
	sound:Play(SoundEffect.SOUND_SQUISH,1.5,0,false,1)

	sprite:Play("Snapped", false)
	player:BloodExplode()
	local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, player.Position, Vector(0,0), nil)
	end
	end
	elseif sprite:IsPlaying("Snapped") then
	sound:Stop(SoundEffect.SOUND_ISAACDIES)
	end
	if sprite:IsFinished("Snap") then
	entity.State = 0
	end
	if sprite:IsFinished("Snapped") then
	sprite:Play("IdleSnapped", false)
	end
	if sprite:IsFinished("IdleSnapped") then
	sprite:Play("IdleSnapped", false)
	end
	end
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BearTrapUpdate, EntityType.BEARTRAP)

----------------------------------------

function EXILE_M:PeriwinkleUpdate(entity)
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Periwinkle") then
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
		if not sprite:IsPlaying("FlyUp") and not sprite:IsFinished("FlyUp") then
		sprite:Play("FlyUp", false)
		elseif sprite:IsFinished("FlyUp")then
			entity.State = 2
		end
	elseif entity.State == 2 then
		if entity:IsFrame(2, 0) then
		entity:AnimWalkFrame("Flying", "Flying", 0.1)
		entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)
			if entity.Position:Distance(target.Position) < 33 then
			entity.State = 3
			else
			entity.State = 0
			end
		end
	elseif entity.State == 3 then
	if not sprite:IsPlaying("JumpDown") then
	sprite:Play("JumpDown", false)
	elseif sprite:IsPlaying("JumpDown") then
		if sprite:IsEventTriggered("impact") then
		sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,1,0,false,1)
		for i = 1, 4 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(8)):Rotated(math.random(-10,10)) * (math.random(111, 150) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -0.002
			Projectile.FallingAccel = 0.02
			Projectile.Scale = (math.random(100,180))/65
			Projectile.Height = -22
			Projectile.DepthOffset = 43
			Projectile.Damage = 1
		Projectile:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		Projectile:GetSprite():LoadGraphics()
		Projectile:GetData().StoneProj = true
		end
		
		--
		--
		
		end
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.PeriwinkleUpdate, EntityType.PERIWINKLE)

function EXILE_M:PeriwinkleDeath(entity)
			sound:Play(SoundEffect.SOUND_BOIL_HATCH,1,0,false,0.6)
			sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
	--local blood2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, 0, entity.Position, Vector(0,0), entity)
	local blood4 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, entity.Position, Vector(0,0), entity)
		for i = 1, 7 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-20,-10)
			local offsetx = math.random(-20,20)
			blood.SpriteScale = Vector(0.8,0.8)
			blood.PositionOffset = Vector(offsetx,offsety)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.PeriwinkleDeath, EntityType.Periwinkle);

function EXILE_M:GetStoneShots()
	local player = Isaac.GetPlayer(0)
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false)) do
			local data = entity:GetData()
			local projectile = entity:ToProjectile()
			if entity.Type == EntityType.ENTITY_PROJECTILE then 
					if data.StoneProj == true then
				projectile.SpriteRotation = projectile.SpriteRotation + 13
				if (projectile.Height >= -5 or projectile:CollidesWithGrid()) and not projectile:GetData().GroundHit then
						projectile:GetData().GroundHit = true
				--	sound:Stop(Sounds.FALLINGWHISTLE)
				sound:Play(SoundEffect.SOUND_BOIL_HATCH,1,0,false,0.4)
				sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1.2)
			
			local blood2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, 0, entity.Position, Vector(0,0), entity)
				for i = 1, 3 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			
			local offsety = math.random(-50,-10)
			local offsetx = math.random(-20,60)
			blood.SpriteScale = Vector(0.5,0.5)
			blood2.SpriteScale = Vector(0.7,0.7)
			blood.PositionOffset = Vector(offsetx,offsety)
				end
			end
		end
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.GetStoneShots)