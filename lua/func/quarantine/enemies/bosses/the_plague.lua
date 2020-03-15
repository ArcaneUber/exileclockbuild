
EntityType.THEPLAGUE = Isaac.GetEntityTypeByName("The Plague")
EntityType.POISONVIAL = Isaac.GetEntityTypeByName("Poison Vial")

SoundEffect.SOUND_REFLECT = Isaac.GetSoundIdByName("Reflect")
SoundEffect.SOUND_SUPERVIAL = Isaac.GetSoundIdByName("Super Vial")
SoundEffect.SOUND_VIALBREAK = Isaac.GetSoundIdByName("Vial Break")
SoundEffect.SOUND_VIALDROP = Isaac.GetSoundIdByName("Vial Drop")

PlagueState = {
	APPEAR = 0, ---------
	---- WITH BUBBLE ---
	IDLE = 1,
	SHOOT = 2,
	SHOOTLONG = 3,
	BOUNCE = 4,
	--- NO BUBBLE ---
	IDLE2 = 5,
	BLOWBUBBLE = 6,
	---
	SHOOTLONG2 = 7,
	SHOOTCORROSIVE = 8,
	----
	POPBUBBLE = 9,
	---- No Bubble
	SHOOTNOBUBBLE = 10,
	JUMPMIDDLE = 11
}

PlagueChain = {
	[PlagueState.IDLE] =	{0.3, 0.2, 0.1, 0.1, 0.0, 0.0, 0.1, 0.1, 0, 0, 0.1},
	[PlagueState.SHOOT] =	{0.5, 0.4, 0, 0, 0, 0, 0, 0, 0, 0, 0.1},
	[PlagueState.SHOOTLONG] =	{0.6, 0.1, 0.1, 0.1, 0.0, 0.0, 0.0, 0.1, 0, 0, 0},
	[PlagueState.BOUNCE] =	{0.4, 0.1, 0.1, 0.3, 0.0, 0.0, 0.0, 0.1, 0, 0, 0},
	---- NO BUBBLE ----
	[PlagueState.IDLE2] =	{0.0, 0.0, 0.0, 0.0, 0.5, 0, 0.0, 0.0, 0, 0.5, 0},
	[PlagueState.BLOWBUBBLE] =	{1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0},
	---- END NO BUBBLE
	[PlagueState.SHOOTLONG2] =	{1, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0, 0, 0},
	[PlagueState.SHOOTCORROSIVE] =	{0.3, 0.0, 0.0, 0.7, 0.0, 0, 0.0, 0.0, 0, 0, 0},
	[PlagueState.POPBUBBLE] =	{0, 0.0, 0.0, 0.0, 1, 0, 0.0, 0.0, 0, 0, 0},
	[PlagueState.SHOOTNOBUBBLE] =	{0, 0.0, 0.0, 0.0, 0.5, 0, 0.0, 0.0, 0, 0.5, 0},
	[PlagueState.JUMPMIDDLE] =	{1, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0, 0.0, 0}
}	

function PlagueTransition(state)
	local roll = math.random()
	for i = 1, #PlagueChain do
		roll = roll - PlagueChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #PlagueChain
end

----

function EXILE_M:PlagueUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local room = game:GetRoom()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Vial Dispenser") then
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity.DepthOffset = 130
	if entity:GetSprite():IsFinished("Idle") then
	entity:GetSprite():Play("Dispense", true)
	end
	
	if entity:GetData().Left == true then
	entity:GetSprite().FlipX = true
	end
	
	if entity:GetSprite():IsEventTriggered("Dispense") then
	sound:Play(SoundEffect.SOUND_VIALDROP,1,0,false,1)
	local roll = math.random(1,16)
	if roll > 12 then
	local vial = Isaac.Spawn(EntityType.POISONVIAL,Isaac.GetEntityVariantByName("Corrosive Vial"),0,entity.Position,Vector(0,0),entity)
	vial:GetData().Falling = 1
	else
	local vial = Isaac.Spawn(EntityType.POISONVIAL,Isaac.GetEntityVariantByName("Poison Vial"),0,entity.Position,Vector(0,0),entity)
	vial:GetData().Falling = 1
	end
	end
	
	if entity:GetSprite():IsFinished("Dispense") then
	entity:GetSprite():Play("Idle", true)
	end
	
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("Plague Pit") then
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity.DepthOffset = -190
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("Plague Booger Corrosive") then
	if data.TargetVial == nil then data.TargetVial = 0 end
	if data.Locked == nil then data.Locked = false end
	if data.SelectedVial == nil then data.SelectedVial = false end
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local vials = Isaac.FindByType(EntityType.POISONVIAL, Isaac.GetEntityVariantByName("Corrosive Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
		if not data.SelectedVial == true then
		for _, tear in ipairs(vials) do
		local roll = math.random(1,40)
		--sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
		if roll > 35 and not data.SelectedVial == true then
		--sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
		data.TargetVial = tear
		data.SelectedVial = true
		end
		end
		end	
	
		if not entity:GetSprite():IsPlaying("Mix", true) then
		entity:GetSprite():Play("Mix", true)
		end
		
		if entity:GetSprite():IsFinished("Mix", true) then
		entity:Remove()
		end
		
		if entity:GetSprite():IsEventTriggered("Remove") then
		if data.SelectedVial == true then
		data.TargetVial:GetData().State = 2
		end
		entity:Remove()
		end
		
		if entity:GetSprite():IsEventTriggered("Move") then
		local vials = Isaac.FindByType(EntityType.POISONVIAL, Isaac.GetEntityVariantByName("Poison Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
		if not data.SelectedVial == true then
		for _, tear in ipairs(vials) do
		local roll = math.random(1,40)
		--sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
		if roll > 35 and not data.SelectedVial == true then
		--sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
		data.TargetVial = tear
		data.SelectedVial = true
		end
		end
		end	
		if data.SelectedVial == true then
		data.Locked = true
		else
		entity:Remove()
		end
		end
		
		if data.Locked == true then
		entity.Position = data.TargetVial.Position or player.Position
		end
	end	

	if entity.Variant == Isaac.GetEntityVariantByName("Plague Booger") then
	if data.TargetVial == nil then data.TargetVial = 0 end
	if data.Locked == nil then data.Locked = false end
	if data.SelectedVial == nil then data.SelectedVial = false end
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local vials = Isaac.FindByType(EntityType.POISONVIAL, Isaac.GetEntityVariantByName("Poison Vial"), -1, true, false) -- Select a vial out of the ones in the room currently
		if not data.SelectedVial == true then
		for _, tear in ipairs(vials) do
		local roll = math.random(1,40)
		--sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
		if roll > 35 and not data.SelectedVial == true and not tear:GetData().TargetVial == true then
		--sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
		data.TargetVial = tear
		data.SelectedVial = true
		end
		end
		end	
	
		if not entity:GetSprite():IsPlaying("Mix", true) then
		entity:GetSprite():Play("Mix", true)
		end
		
		if entity:GetSprite():IsFinished("Mix", true) then
		entity:Remove()
		end
		
		if entity:GetSprite():IsEventTriggered("Remove") then
		if data.SelectedVial == true then
		data.TargetVial:GetData().State = 2
		end
		entity:Remove()
		end
		
		if entity:GetSprite():IsEventTriggered("Move") then
		if data.SelectedVial == true then
		data.Locked = true
		end
		end
		
		if data.Locked == true then
		entity.Position = data.TargetVial.Position or player.Position
		end
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("The Plague") then
	local target = entity:GetPlayerTarget()
	local ang = player.Position - entity.Position
	entity.DepthOffset = 45;
	
	if entity:GetSprite():IsOverlayPlaying("Bubble") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
		local tears = Isaac.FindByType(EntityType.ENTITY_TEAR, 0, -1, false, false)
		for _, tear in ipairs(tears) do
		if tear.Position:Distance(entity.Position) < 65 then
			local tear2 = tear:ToTear()
			sound:Play(SoundEffect.SOUND_REFLECT,0.8,0,false,1.2)
			local shot = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,tear.Position,(player.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
			shot.Scale = tear2.Scale
			shot.Damage = 1
			shot:SetColor(Color(0,70,0,1,0,0,0),23,0,true,false)
		tear:Die()
		entity:GetSprite():PlayOverlay("Reflect")

		--
		end
		end
	
	end
	
	if entity:GetSprite():IsOverlayFinished("Reflect") then
	entity:GetSprite():PlayOverlay("Bubble")
	end
	
	
	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	if data.Bubble == nil then data.Bubble = 0 end
	if data.SelectedVial == nil then data.SelectedVial = false end
	if data.VialTarget == nil then data.VialTarget = 0 end
	if data.IdleNoBubbleTimes == nil then data.IdleNoBubbleTimes = 0 end
	
	data.StateFrame = data.StateFrame + 1
	
	local tears = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, -1, false, false)
		for _, tear in ipairs(tears) do
		if tear.Position:Distance(entity.Position) < 61 and tear:GetData().Ignited == false and data.Bubble == 1 then
		tear:GetData().Ignited = true
		tear:GetData().Lifetime = 110
		data.State = PlagueState.POPBUBBLE
		data.StateFrame = 0
		end
		end
	
	if data.State == PlagueState.APPEAR and entity:GetSprite():IsFinished("Appear") then
		data.State = PlagueState.IDLE
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		data.Bubble = 1
		data.StateFrame = 0
	elseif data.State == PlagueState.IDLE then
	data.SelectedVial = false
	--entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.6 * 7
		if data.StateFrame == 1 then
		if not entity:GetSprite():IsOverlayPlaying("Bubble") then
		entity:GetSprite():PlayOverlay("Bubble")
		end
			entity:GetSprite():Play("Idle", true)
		elseif entity:GetSprite():IsFinished("Idle") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.SHOOT then
	data.Bubble = 1
		if data.StateFrame == 1 then
		sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
		if not entity:GetSprite():IsOverlayPlaying("Bubble") then
		entity:GetSprite():PlayOverlay("Bubble")
		end
		entity.Velocity = Vector(0,0)
		entity:GetSprite():Play("Shoot", true)
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
	sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1,0,false,1)
	local booger = Isaac.Spawn(EntityType.THEPLAGUE, Isaac.GetEntityVariantByName("Plague Booger"), 0,entity.Position, Vector(0,0), entity)
	elseif entity:GetSprite():IsFinished("Shoot") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.SHOOTCORROSIVE then
	data.Bubble = 1
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
		local vials = Isaac.FindByType(EntityType.POISONVIAL, Isaac.GetEntityVariantByName("Corrosive Vial"), -1, true, false)
		sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
		if not entity:GetSprite():IsOverlayPlaying("Bubble") then
		entity:GetSprite():PlayOverlay("Bubble")
		end
		entity:GetSprite():Play("Shoot", true)
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
	sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1,0,false,1)
	local booger2 = Isaac.Spawn(EntityType.THEPLAGUE, Isaac.GetEntityVariantByName("Plague Booger Corrosive"), 0,entity.Position, Vector(0,0), entity)
	elseif entity:GetSprite():IsFinished("Shoot") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.SHOOTLONG then
	data.Bubble = 1
		if data.StateFrame == 1 then
		if not entity:GetSprite():IsOverlayPlaying("Bubble") then
		entity:GetSprite():PlayOverlay("Bubble")
		end
			entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("ShootLong", true)
	elseif entity:GetSprite():IsEventTriggered("Vomit") then
	sound:Play(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF,1,0,false,1)
		elseif entity:GetSprite():GetFrame() > 25 and entity:GetSprite():GetFrame() < 45 then
			sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1,0,false,1)
			local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position,(target.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
			tear.Height = -50
			tear.DepthOffset = 50
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0,entity.Position, Vector(0,0), entity)
			creep:GetSprite().Offset = Vector(0,-33)
			local eff = creep:ToEffect()
			eff:SetColor(Color(0,50,0,1,0,0,0),0,0,false,false)
			
		elseif entity:GetSprite():IsFinished("ShootLong") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.SHOOTLONG2 then
	data.Bubble = 1
		if data.StateFrame == 1 then
		if not entity:GetSprite():IsOverlayPlaying("Bubble") then
		entity:GetSprite():PlayOverlay("Bubble")
		end
			entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("ShootLong2", true)
	elseif entity:GetSprite():IsEventTriggered("Vomit") then
	sound:Play(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF,1,0,false,1)
		elseif entity:GetSprite():GetFrame() > 25 and entity:GetSprite():GetFrame() < 75 then
		entity.Velocity = (target.Position - entity.Position):Normalized() * 0.7 * 8
			sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1,0,false,1)
		for i = 1, 1 do
			if entity:GetData().projvecX == nil then entity:GetData().projvecX = Vector(0, 0) end
				if entity:GetData().projvecY == nil then entity:GetData().projvecY = Vector(0, 0) end
				entity:GetData().projvecX = math.random(-1, 1)
				entity:GetData().projvecY = math.random(-1, 1)
				local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((Vector(entity:GetData().projvecX, entity:GetData().projvecY):Resized(7.75)):Rotated(math.random(-3,3)) * (math.random(60, 120) / 210)), entity, 0, 0):ToProjectile()
				Projectile.FallingAccel = 1
				Projectile.FallingSpeed = 1
				Projectile.Height = -47
				Projectile.DepthOffset = 10
				--Projectile.ProjectileFlags = ProjectileFlags.ACID_GREEN
				Projectile.Scale = 1
				Projectile:SetColor(Color(0,50,0,1,0,0,0),0,0,false,false)
			end
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0,entity.Position, Vector(0,0), entity)
			creep:GetSprite().Offset = Vector(0,-33)
			local eff = creep:ToEffect()
			eff:SetColor(Color(50,0,0,1,0,0,0),0,0,false,false)
			
		elseif entity:GetSprite():IsFinished("ShootLong2") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.BOUNCE then
	data.Bubble = 1
		if data.StateFrame == 1 then
		entity:GetSprite():RemoveOverlay()
			entity:GetSprite():Play("Bounce", true)
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
			entity:AddVelocity((target.Position - entity.Position):Normalized() * 7)
	elseif entity:GetSprite():IsEventTriggered("Stomp") then
			Game():ShakeScreen(13,14)
			entity.Velocity = Vector(0,0)
			sound:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,1)
		sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)
		
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0,entity.Position, Vector(0,0), entity)

		local effect = creep:ToEffect()
		effect.Scale = 2
	elseif entity:GetSprite():IsFinished("Bounce") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.JUMPMIDDLE then
	data.Bubble = 0
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
		entity:GetSprite():RemoveOverlay()
			entity:GetSprite():Play("BounceCenter", true)
	elseif entity:GetSprite():IsEventTriggered("Pop") then
	sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	elseif entity:GetSprite():IsEventTriggered("Stomp") then
	entity.Position = room:GetCenterPos()
	elseif entity:GetSprite():IsEventTriggered("Vomit") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			entity:AddVelocity((target.Position - entity.Position):Normalized() * 4)
			Game():ShakeScreen(13,14)
		sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
		
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(9,9),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(-9,9),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(9,-9),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(-9,-9),entity)

		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(0,11),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(0,-11),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(11,0),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position + Vector(0,0) ,Vector(-11,0),entity)
	elseif entity:GetSprite():IsFinished("BounceCenter") then
			data.Bubble = 1
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.SHOOTNOBUBBLE then
		if data.StateFrame == 1 then
		entity:GetSprite():RemoveOverlay()
			entity:GetSprite():Play("ShootNoBubble", true)
	elseif entity:GetSprite():IsEventTriggered("Shoot") then
		local roll = math.random(1,6)
		if roll > 3 then
	sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1,0,false,1)
	sound:Play(SoundEffect.SOUND_GHOST_SHOOT,1,0,false,1.0)
	local booger = Isaac.Spawn(EntityType.THEPLAGUE, Isaac.GetEntityVariantByName("Plague Booger"), 0,entity.Position, Vector(0,0), entity)
		else
		local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_PUKE,0,entity.Position,(player.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
		tear.Scale = 2
		tear.Damage = 1
		tear.DepthOffset = 40
		sound:Play(SoundEffect.SOUND_GHOST_SHOOT,1,0,false,1.0)
		end
	elseif entity:GetSprite():IsFinished("ShootNoBubble") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.IDLE2 then
	data.Bubble = 0
	data.SelectedVial = false
---	entity.Pathfinder:FindGridPath(target.Position, 0.86, 1, true)
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.6 * 7
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		if data.StateFrame == 1 then
		if data.IdleNoBubbleTimes > 7 then
			data.State = PlagueState.BLOWBUBBLE
			data.StateFrame = 0
		else
			data.IdleNoBubbleTimes = data.IdleNoBubbleTimes + 1
			entity:GetSprite():RemoveOverlay()
			entity:GetSprite():Play("IdleNoBubble", true)
		end
		elseif entity:GetSprite():IsFinished("IdleNoBubble") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.POPBUBBLE then
	data.SelectedVial = false
	data.IdleNoBubbleTimes = 0
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
			entity:GetSprite():RemoveOverlay()
			entity:GetSprite():Play("BubblePop", true)
		elseif entity:GetSprite():IsEventTriggered("Pop") then
		data.Bubble = 0
		sound:Play(SoundEffect.SOUND_PLOP,1.4,0,false,0.6)
		sound:Play(SoundEffect.SOUND_MEAT_JUMPS,1.1,0,false,1.0)
		Game():ShakeScreen(7,7)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(7,7),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity)

		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(0,9),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(9,0),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_TEAR,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity)
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0,entity.Position, Vector(0,0), entity)

		local effect = creep:ToEffect()
		effect.Scale = 2.5
		elseif entity:GetSprite():IsFinished("BubblePop") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == PlagueState.BLOWBUBBLE then
	data.SelectedVial = false
		if data.StateFrame == 1 then
			entity:GetSprite():RemoveOverlay()
			entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("BlowBubble", true)
		elseif entity:GetSprite():IsFinished("BlowBubble") then
			data.State = PlagueTransition(data.State)
			data.StateFrame = 0
			data.Bubble = 1 
		end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.PlagueUpdate, EntityType.THEPLAGUE);

function EXILE_M:VialUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Corrosive Vial") then
	data.Immovable = true
	if data.State == nil then data.State = 0 end
	if data.Falling == nil then data.Falling = 0 end
	if data.Dropped == nil then data.Dropped = 0 end
	if data.SplashingState == nil then data.SplashingState = 0 end
	if data.SplashLoopTimes == nil then data.SplashLoopTimes = 0 end
	
	
	if entity:GetSprite():IsEventTriggered("Dispense") then
	sound:Play(SoundEffect.SOUND_GOLD_HEART_DROP,1.2,0,false,0.6)
	end
	
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.Velocity = entity.Velocity - entity.Velocity/4
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

	if entity.Position:Distance(room:GetCenterPos()) < 78.7 then
	entity:Remove()
	end	

	local target = entity:GetPlayerTarget()
	local ang = player.Position - entity.Position
	entity.DepthOffset = 15;
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	if data.State == 0 then
		if data.Falling == 1 then
			if not entity:GetSprite():IsPlaying("Fall", true) and data.Falling == 1 then
			entity:GetSprite():Play("Fall", true)
			end
			
			if entity:GetSprite():IsEventTriggered("Fall") then
			data.Falling = 0
			end
		end
		
		if not entity:GetSprite():IsPlaying("Idle", true) and data.Falling == 0 then
		entity:GetSprite():Play("Idle", true)
		end
	end
	if data.State == 2 then
		if not entity:GetSprite():IsPlaying("Splash", true) and data.SplashingState == 0 then
		entity:GetSprite():Play("Splash", true)
		sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1.3,0,false,0.7)
		data.SplashingState = 1
		end
		if entity:GetSprite():IsFinished("Splash", true) and data.SplashingState == 1 then
		sound:Play(SoundEffect.SOUND_SUPERVIAL,1.4,0,false,1)
		Game():ShakeScreen(9,8)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
		Isaac.Explode(entity.Position, entity, 5)
		local boney = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, entity.Position, Vector(0,0), entity)
		boney:SetColor(Color(40,120,60,1,0,0,0),23,0,true,false)
		entity:Remove()
		--data.SplashingState = 2
		--data.SplashLoopTimes = 0
		end
		if entity:GetSprite():IsFinished("SplashLoop", true) and data.SplashingState == 2 then
		if data.SplashLoopTimes == 12 then
		
		local tears = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Corrosive == true then
		tear:Remove()
		end
		end
		
		entity:GetSprite():Play("SplashEnd", true)
		data.SplashingState = 3
		else
		entity:GetSprite():Play("SplashLoop", true)
		data.SplashingState = 2
		data.SplashLoopTimes = data.SplashLoopTimes + 1
		end
		end
		if entity:GetSprite():IsFinished("SplashEnd", true) and data.SplashingState == 3 then
		data.State = 0
		data.SplashingState = 0
		end
		
		if entity:GetSprite():IsPlaying("SplashLoop") then

		end
		
	end
	
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("Poison Vial") then
	data.Immovable = true
	if data.State == nil then data.State = 0 end
	if data.Falling == nil then data.Falling = 0 end
	if data.Dropped == nil then data.Dropped = 0 end
	if data.SplashingState == nil then data.SplashingState = 0 end
	if data.SplashLoopTimes == nil then data.SplashLoopTimes = 0 end
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	if entity:GetSprite():IsEventTriggered("Dispense") then
	sound:Play(SoundEffect.SOUND_GOLD_HEART_DROP,1.2,0,false,0.6)
	end
	
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity.Velocity = entity.Velocity - entity.Velocity/4

	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

	if entity.Position:Distance(room:GetCenterPos()) < 78.7 and room:GetType() == RoomType.ROOM_BOSS then
	entity:Remove()
	end
	
	
	local target = entity:GetPlayerTarget()
	local ang = player.Position - entity.Position
	entity.DepthOffset = 15;
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	if data.State == 0 then
		if data.Falling == 1 then
			if not entity:GetSprite():IsPlaying("Fall", true) and data.Falling == 1 then
			entity:GetSprite():Play("Fall", true)
			end
			
			if entity:GetSprite():IsEventTriggered("Fall") then
			data.Falling = 0
			end
		end
		
		if not entity:GetSprite():IsPlaying("Idle", true) and data.Falling == 0 then
		entity:GetSprite():Play("Idle", true)
		end
	end
	if data.State == 2 then
		if not entity:GetSprite():IsPlaying("Splash", true) and data.SplashingState == 0 then
		entity:GetSprite():Play("Splash", true)
		sound:Play(SoundEffect.SOUND_BOSS2_BUBBLES,1.3,0,false,0.7)
		data.SplashingState = 1
		end
		if entity:GetSprite():IsFinished("Splash", true) and data.SplashingState == 1 then
		entity:GetSprite():Play("SplashLoop", true)
		Game():ShakeScreen(9,8)
		sound:Play(Sounds.SPLASH_WATER,1,0,false,1)
		sound:Play(SoundEffect.SOUND_SUPERVIAL,1.4,0,false,1)
		data.SplashingState = 2
		data.SplashLoopTimes = 0
		end
		if entity:GetSprite():IsFinished("SplashLoop", true) and data.SplashingState == 2 then
		if data.SplashLoopTimes == 4 then
		entity:GetSprite():Play("SplashEnd", true)
		data.SplashingState = 3
		else
		entity:GetSprite():Play("SplashLoop", true)
		data.SplashingState = 2
		data.SplashLoopTimes = data.SplashLoopTimes + 1
		end
		end
		if entity:GetSprite():IsFinished("SplashEnd", true) and data.SplashingState == 3 then
		Game():ShakeScreen(9,8)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
		Game():BombExplosionEffects(entity.Position, 5, 0, Color(0,40,0,1,0,0,0), entity, 1.5, false, false)
		entity:Remove()
		data.State = 0
		data.SplashingState = 0
		end
		
		if entity:GetSprite():IsPlaying("SplashLoop") then
		for i = 1, 1 do
			if entity:GetData().projvecX == nil then entity:GetData().projvecX = Vector(0, 0) end
				if entity:GetData().projvecY == nil then entity:GetData().projvecY = Vector(0, 0) end
				entity:GetData().projvecX = math.random(-1, 1)
				entity:GetData().projvecY = math.random(-1, 1)
				local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((Vector(entity:GetData().projvecX, entity:GetData().projvecY):Resized(7.75)):Rotated(math.random(-3,3)) * (math.random(60, 120) / 210)), entity, 0, 0):ToProjectile()
				Projectile.FallingAccel = 1.4
				Projectile.FallingSpeed = 1.2
				Projectile.Height = -265
				Projectile.DepthOffset = 40
			---	Projectile.ProjectileFlags = ProjectileFlags.ACID_GREEN
				Projectile.Scale = (math.random(100,170))/93
				Projectile:SetColor(Color(0,70,0,1,0,0,0),0,0,false,false)
			end
		end
		
	end
	
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.VialUpdate, EntityType.POISONVIAL);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local lights = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, 0, false, false)
    for _, light in ipairs(lights) do
		local room = Game():GetRoom()
        local sprite = light:GetSprite()
		local data = light:GetData()
		if light:GetData().Lifetime == nil then light:GetData().Lifetime = 0 end
		light.Velocity = light.Velocity:Resized(6)
		light:GetData().Lifetime = light:GetData().Lifetime + 1
		if light:GetData().Lifetime > 100 then
		sprite:Play("End")
		end
		if sprite:IsFinished("End") then
		light:Remove()
		end
    end
end)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local lights = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, false, false)
    for _, light in ipairs(lights) do
		local room = Game():GetRoom()
        local sprite = light:GetSprite()
		local data = light:GetData()
		light:Remove()
		light:SetColor(Color(0,0,0,0,0,0,0),0,0,false,false)
    end
end)


function EXILE_M:CorrosiveVialExplode(entity)
if entity.Variant == Isaac.GetEntityVariantByName("Corrosive Vial") then
	Isaac.Explode(entity.Position, entity, 0)
		sound:Play(SoundEffect.SOUND_VIALBREAK,1.5,0,false,1)
		sound:Play(SoundEffect.SOUND_SUPERVIAL,1.4,0,false,1)
		Game():ShakeScreen(9,8)
		local laser = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.HUSH_LASER,0,Isaac.GetFreeNearPosition(entity.Position, 34),Vector(0,0),entity)
		laser:GetData().Corrosive = true
		laser:GetData().Ignited = false
		laser:GetData().Spawner = entity
			laser:GetSprite():ReplaceSpritesheet(1, "gfx/bosses/captainslog/quarantine/vial_laser.png")
			laser:GetSprite():ReplaceSpritesheet(2, "gfx/bosses/captainslog/quarantine/vial_laser.png")
			laser:GetSprite():ReplaceSpritesheet(3, "gfx/bosses/captainslog/quarantine/vial_laser.png")
			laser:GetSprite():ReplaceSpritesheet(4, "gfx/bosses/captainslog/quarantine/vial_laser.png")
			laser:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/captainslog/quarantine/vial_laser_impact.png")
			laser:GetSprite():LoadGraphics()
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.CorrosiveVialExplode, EntityType.POISONVIAL);



