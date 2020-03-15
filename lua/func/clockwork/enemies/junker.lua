
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