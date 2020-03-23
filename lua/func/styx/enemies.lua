

-- enemies

EntityType.BOWLSTATUE = Isaac.GetEntityTypeByName("Bowl Statue")

function EXILE_M:BowlStatueUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Bowl Statue") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	if data.FillType == nil then data.FillType = 0 end
	if data.Full == nil then data.Full = 0 end
	if data.FillCount == nil then data.FillCount = 0 end
	
	if entity.State == 0 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	EXILE_M.AnimateWalkFrame(sprite, entity.Velocity, {Up = "WalkUp", Down = "WalkDown", Horizontal = "WalkHori"})
	entity.Pathfinder:FindGridPath(target.Position, 0.6, 1, true)
		local tears = Isaac.FindByType(EntityType.ENTITY_TEAR, -1, -1, true, false)
		for _, tear in ipairs(tears) do
		if tear.Position:Distance(entity.Position) < 32 then
		tear:Die()
		if (data.FillType == 0 or data.FillType == 1) and data.FillCount < 4 then
		data.FillType = 1
		entity.State = 2
		data.FillCount = data.FillCount + 1
		end
		if data.FillCount > 3 then
		entity.State = 4
		end
		end
		end
		
				local projs = Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, true, false)
		for _, tear in ipairs(projs) do
		if tear.Position:Distance(entity.Position) < 32 then
		tear:Die()
		if (data.FillType == 0 or data.FillType == 2) and data.FillCount < 4 then
		data.FillType = 2
		entity.State = 2
		data.FillCount = data.FillCount + 1
		end
		if data.FillCount > 3 then
		entity.State = 4
		end
		end
		end
	
	elseif entity.State == 2 then
	entity.Velocity = Vector(0,0)
	if not sprite:IsPlaying("Fill") then
	sprite:Play("Fill", false)
	elseif sprite:IsPlaying("Fill") then
	if sprite:GetFrame() == 4 then
	if data.FillType == 1 then
	entity:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/captainslog/styx/bowl_statue_blue.png")
	entity:GetSprite():LoadGraphics()
	elseif data.FillType == 2 then
	entity:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/captainslog/styx/bowl_statue_red.png")
	entity:GetSprite():LoadGraphics()
	end
	
	end
	end
	if sprite:IsFinished("Fill") then
		entity.State = 0
	end
	
	elseif entity.State == 4 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity.Velocity = Vector(0,0)
	entity:GetSprite().FlipX = (entity.Position.X < target.Position.X)
	if not sprite:IsPlaying("Dump") then
	sprite:Play("Dump", false)
	elseif sprite:IsPlaying("Dump") then
	if sprite:GetFrame() == 5 then
	sound:Play(Sounds.SPLASH_WATER2,1.7,0,false,1)
	if data.FillType == 1 then
			for i = 1, 7 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, entity.Position, ((-(entity.Position - target.Position):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(80, 140) / 78)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -(math.random(40, 80)/10) 
			Projectile.Scale = (math.random(100,150))/80
			Projectile.FallingAccel = (math.random(4, 7)/12)
			Projectile.Height = -26
			Projectile.DepthOffset = 43
			Projectile.CollisionDamage = 1
			Projectile.ProjectileFlags = ProjectileFlags.HIT_ENEMIES
		end
	elseif data.FillType == 2 then
			for i = 1, 7 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(7.75)):Rotated(math.random(-10,10)) * (math.random(80, 140) / 78)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -(math.random(40, 80)/10) 
			Projectile.Scale = (math.random(100,150))/95
			Projectile.FallingAccel = (math.random(4, 7)/12)
			Projectile.Height = -26
			Projectile.DepthOffset = 43
			Projectile.CollisionDamage = 1
		end
	
	end
	end
	if sprite:GetFrame() == 11 then
	data.FillCount = 0
	data.FillType = 0
		entity:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/captainslog/styx/bowl_statue_empty.png")
	entity:GetSprite():LoadGraphics()
	end
	end
		if sprite:IsFinished("Dump") then
		entity.State = 0
	end
	end
		if room:IsClear() then
		for i = 1, 7 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-50,-10)
			local offsetx = math.random(-20,60)
			blood.PositionOffset = Vector(offsetx,offsety)
		end
		sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1.3,0,false,0.7)
		entity:Kill()
	end
	
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BowlStatueUpdate, EntityType.BOWLSTATUE)



