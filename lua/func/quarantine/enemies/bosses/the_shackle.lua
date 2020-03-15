
EntityType.CHAINHARPOON = Isaac.GetEntityTypeByName("Chain Harpoon")
EntityType.THESHACKLE = Isaac.GetEntityTypeByName("The Shackle")

ShackleState = {
	APPEAR = 0, ---------
	IDLE = 1,
	JUMPUP = 2,
	CARDHOOK = 3,
	SWINGTHROW = 4,
	DUALSWING = 5,
	GRAPPLE = 6,
	LASER = 7,
	RAPIDGRAPPLE = 8,
	JUMPMID = 9
}

ShackleChain = { --- HAHA GET IT? CHAIN? NO? ILL LEAVE NOW
	[ShackleState.IDLE] =	{0.5, 0.1, 0.0, 0.1, 0.0, 0.1, 0.1, 0.0, 0.1},
	[ShackleState.JUMPUP] =	{0.6, 0.0, 0.0, 0.1, 0.0, 0.1, 0.1, 0.0, 0.1},
	[ShackleState.CARDHOOK] =	{0.3, 0.3, 0.0, 0.0, 0.2, 0.0, 0.1, 0.1, 0.0},
	[ShackleState.SWINGTHROW] =	{0, 0.5, 0, 0.1, 0, 0.0, 0.0, 0.0, 0.4},
	[ShackleState.DUALSWING] =	{0.5, 0, 0, 0, 0, 0.0, 0.0, 0.2, 0.3},
	[ShackleState.GRAPPLE] =	{0.2, 0.6, 0.0, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0},
	[ShackleState.LASER] =	{0.1, 0.6, 0.0, 0.1, 0.1, 0.0, 0.0, 0.0, 0.0},
	[ShackleState.RAPIDGRAPPLE] =	{0, 1, 0, 0, 0, 0.0, 0.0, 0.0, 0.0},
	[ShackleState.JUMPMID] =	{0, 0, 0.35, 0.3, 0, 0.0, 0.0, 0.35, 0.0}
}	

function ShackleTransition(state)
	local roll = math.random()
	for i = 1, #ShackleChain do
		roll = roll - ShackleChain[state][i]
		if roll <= 0 then
			return i
		end
	end
	return #ShackleChain
end

----

function EXILE_M:ShackleUpdate(entity)
	local game = Game()
	local data = entity:GetData()
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer(0)
	local topl = room:GetTopLeftPos()
	local botr = room:GetBottomRightPos()
	
	if entity.Variant == Isaac.GetEntityVariantByName("Shackle Afterimage") then
	if not entity:GetSprite():IsPlaying("Idle") then
	entity:GetSprite():Play("Idle", false)
	end
	if entity:GetSprite():IsFinished("Idle") then
	entity:Remove()
	end
	end
	
	if entity.Variant == Isaac.GetEntityVariantByName("The Shackle") then
	
	entity.DepthOffset = 25;
	
	if data.State == nil then data.State = 0 end
	if data.StateFrame == nil then data.StateFrame = 0 end
	local target = entity:GetPlayerTarget()
	local pos1 = entity.Position - target.Position
	local Dirvect = pos1:GetAngleDegrees()

	--entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	
	data.StateFrame = data.StateFrame + 1 
	
	
	if data.State == ShackleState.APPEAR and entity:GetSprite():IsFinished("Appear") then
	--ApplyChainToEntity(entity, 7, Vector(0,-10), false, 1)
		data.State = ShackleState.IDLE
		data.StateFrame = 0
	elseif data.State == ShackleState.IDLE then --------------------------------------
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)
		if data.StateFrame == 1 then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		elseif entity:GetSprite():IsEventTriggered("Shake") then
		sound:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,1)
		Game():ShakeScreen(5,5)
		elseif entity:GetSprite():IsFinished("WalkHori") or entity:GetSprite():IsFinished("WalkVert") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == ShackleState.JUMPUP then
		if data.StateFrame == 1 then
			entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("Jump Up", true)
	elseif entity:GetSprite():IsEventTriggered("Jump") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:AddVelocity((target.Position - entity.Position):Normalized() * 12)
	sound:Play(SoundEffect.SOUND_FAT_WIGGLE,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Pound") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.Velocity = Vector(0,0)
	Game():ShakeScreen(7,7)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,9),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,9),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,-9),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,-9),entity):ToProjectile()

	sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.7,0,false,0.5)
	sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1)
	elseif entity:GetSprite():IsFinished("Jump Up") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end
	elseif data.State == ShackleState.CARDHOOK then ----------------
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("CardHook", true)
		elseif entity:GetSprite():IsEventTriggered("Hook") then
	sound:Play(SoundEffect.SOUND_SHELLGAME,1.2,0,false,0.6)
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,0) , Vector(-21,0), nil)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	--hooktip.SpriteRotation = -180
	hooktip:GetData().SegCount = 25
	
	local hooktip2 = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,0) , Vector(0,-21), nil)
	hooktip2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip2:GetData().Vert = true
	--hooktip2:GetData().ChainRot = 90
	hooktip2:GetData().SegCount = 25
	hooktip2.SpriteRotation = 90
	
	local hooktip3 = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,0) , Vector(0,21), nil)
	hooktip3:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip3:GetData().Vert = true
	hooktip3.SpriteRotation = -90
	hooktip3:GetData().SegCount = 25

	local hooktip4 = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,0) , Vector(21,0), nil)
	hooktip4:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip4.SpriteRotation = -180
	hooktip4:GetData().SegCount = 25
	
	elseif entity:GetSprite():IsEventTriggered("Hook2") then
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		tear:GetData().Lifetime = 99
		end
	elseif entity:GetSprite():IsFinished("CardHook") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == ShackleState.SWINGTHROW then ----------------
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
			entity:GetSprite().FlipX = false
			entity:GetSprite():Play("SwingThrow", true)
		elseif entity:GetSprite():IsEventTriggered("Hook") then
	sound:Play(Sounds.SWORDBEAM,1.1,0,false,0.7)
	local firedown = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swinger"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown:GetData().HasParent = true
	firedown:GetData().Spawner = entity
	firedown:GetData().DistanceOut = 3
	firedown:GetData().DistanceRad = 12
	firedown:GetData().Offset = Vector(30,-20)
	firedown:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	firedown:SetColor(Color(1,1,1,1,255,255,255),15,1,true,false)
---	ApplyChainToEntity(firedown, 3, Vector(0,-10), false, 1)
	
	local firedown2 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown2:GetData().HasParent = true
	firedown2:GetData().Spawner = entity
	firedown2:GetData().DistanceOut = 2
	firedown2:GetData().DistanceRad = 12
	firedown2:GetData().Offset = Vector(30,-20)
	firedown2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

	local firedown3 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown3:GetData().HasParent = true
	firedown3:GetData().Spawner = entity
	firedown3:GetData().DistanceOut = 1
	firedown3:GetData().DistanceRad = 12
	firedown3:GetData().Offset = Vector(30,-20)
	firedown3:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	elseif entity:GetSprite():IsEventTriggered("Hook2") then
	sound:Play(SoundEffect.SOUND_SHELLGAME,1.2,0,false,0.8)
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon Swinger"), -1, false, false)
		for _, tear in ipairs(tears) do
		tear:Remove()
		end
		
		local tears2 = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"), -1, false, false)
		for _, tear in ipairs(tears2) do
		tear:Remove()
		end

	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,0),(target.Position - entity.Position):Normalized() * 23, entity)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip.SpriteRotation = Dirvect
	hooktip:GetData().SegCount = 15

		elseif entity:GetSprite():IsFinished("SwingThrow") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == ShackleState.DUALSWING then ----------------
		--entity:AddVelocity((target.Position - entity.Position):Normalized() * 7)
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("DualSwing", true)
		elseif entity:GetSprite():IsEventTriggered("Hook") then
	local firedown = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swinger"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown:GetData().HasParent = true
	firedown:GetData().Spawner = entity
	firedown:GetData().DistanceOut = 3
	firedown:GetData().DistanceRad = 9
	firedown:GetData().Offset = Vector(18,-10)
	firedown:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	
	local firedown2 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown2:GetData().HasParent = true
	firedown2:GetData().Spawner = entity
	firedown2:GetData().DistanceOut = 2
	firedown2:GetData().DistanceRad = 9
	firedown2:GetData().Offset = Vector(18,-10)
	firedown2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

	local firedown3 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown3:GetData().HasParent = true
	firedown3:GetData().Spawner = entity
	firedown3:GetData().DistanceOut = 1
	firedown3:GetData().DistanceRad = 9
	firedown3:GetData().Offset = Vector(18,-10)
	firedown3:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	--- LEFT
	
	local firedown4 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swinger"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown4:GetData().HasParent = true
	firedown4:GetData().Spawner = entity
	firedown4:GetData().DistanceOut = 3
	firedown4:GetData().DistanceRad = 9
	firedown4:GetData().Offset = Vector(-18,-10)
	firedown4:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	
	local firedown5 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown5:GetData().HasParent = true
	firedown5:GetData().Spawner = entity
	firedown5:GetData().DistanceOut = 2
	firedown5:GetData().DistanceRad = 9
	firedown5:GetData().Offset = Vector(-18,-10)
	firedown5:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

	local firedown6 = Isaac.Spawn(EntityType.CHAINHARPOON,Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"),0,entity.Position + Vector(0,2), Vector(0,0), entity)
	firedown6:GetData().HasParent = true
	firedown6:GetData().Spawner = entity
	firedown6:GetData().DistanceOut = 1
	firedown6:GetData().DistanceRad = 9
	firedown6:GetData().Offset = Vector(-18,-10)
	firedown6:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	elseif entity:GetSprite():IsEventTriggered("Hook2") then
	sound:Play(SoundEffect.SOUND_SHELLGAME,1.2,0,false,0.8)
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon Swinger"), -1, false, false)
		for _, tear in ipairs(tears) do
		tear:Remove()
		end
		
		local tears2 = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"), -1, false, false)
		for _, tear in ipairs(tears2) do
		tear:Remove()
		end	
	
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,-10) , Vector(-21,0), nil)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip:GetData().ChainRot = 90
	hooktip:GetData().SegCount = 18
	
	local hooktip3 = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(0,-10) , Vector(21,0), nil)
	hooktip3:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip3:GetData().Vert = true
	--hooktip3:GetData().ChainRot = -90
	hooktip3.SpriteRotation = -180
	hooktip3:GetData().SegCount = 18
		elseif entity:GetSprite():IsFinished("DualSwing") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == ShackleState.GRAPPLE then
		
		if entity:GetSprite():GetFrame() > 52 then ---- Remove the Grappling Hook Harpoon
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Grapple == true then
		if tear.Position:Distance(entity.Position) > 23 then
		local afterim = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Shackle Afterimage"), 0, entity.Position + Vector(0,0) , Vector(0,0), nil)
		entity:AddVelocity((tear.Position - entity.Position):Normalized() * 14.3)
		entity.Velocity = entity.Velocity - entity.Velocity/4
		else
	sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.5,0,false,1)
	Game():ShakeScreen(12,12)
	entity.Velocity = Vector(0,0)
	for i = 1, 8 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -4
			Projectile.DepthOffset = 20
	end
		tear:Remove()
		end
		end
		end
		end
	
		if data.StateFrame == 1 then
		entity.Velocity = Vector(0,0)
		entity:GetSprite():Play("Grapple", true)
	elseif entity:GetSprite():IsEventTriggered("Hook") then
	sound:Play(SoundEffect.SOUND_SHELLGAME,1,0,false,0.7)
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(-5,0),(target.Position - entity.Position):Normalized() * 23, entity)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip.SpriteRotation = Dirvect
	hooktip:GetData().SegCount = 28
	hooktip:GetData().Grapple = true
	elseif entity:GetSprite():IsEventTriggered("Hook2") then
	entity.Velocity = Vector(0,0)
	elseif entity:GetSprite():IsFinished("Grapple") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end---
	elseif data.State == ShackleState.LASER then ----------------
		entity:GetSprite().FlipX = false
		if data.StateFrame == 1 then
		entity:GetSprite():Play("Laser", true)
		entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():IsEventTriggered("Shake") then
		sound:Play(Sounds.BUZZER,1.2,0,false,1)
		elseif entity:GetSprite():IsEventTriggered("Pound") then
		plpos = entity.Position - target.Position
		posvect = plpos:GetAngleDegrees() --
		elseif entity:GetSprite():IsEventTriggered("Hook2") then
		sound:Play(Sounds.LASERFIRE,1.8,0,false,1)
			local BloodLaser = EntityLaser.ShootAngle(2, entity.Position, posvect + 180,
		9, Vector(-10,-36), entity)
		BloodLaser.DepthOffset = 150;
		BloodLaser.EndPoint = target.Position
		BloodLaser:SetColor(Color(0,120,0,1,0,80,0),999,0,0,false)
		elseif entity:GetSprite():IsFinished("Laser") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == ShackleState.RAPIDGRAPPLE then ----------------
		if data.StateFrame == 1 then
		POSROLL1 = math.random(80,270)
		POSROLL2 = math.random(80,270)
		POSROLL3 = math.random(80,270)
		POSROLL4 = math.random(80,270)
		end
	
		if entity:GetSprite():GetFrame() > 31 and entity:GetSprite():GetFrame() < 50 then ---- FIRST GRAPPLE
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Grapple == true then
		if tear.Position:Distance(entity.Position) > 23 then
		local afterim = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Shackle Afterimage"), 0, entity.Position + Vector(0,0) , Vector(0,0), nil)
		entity:AddVelocity((tear.Position - entity.Position):Normalized() * 14.3)
		entity.Velocity = entity.Velocity - entity.Velocity/4
		else
	sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.5,0,false,1)
	Game():ShakeScreen(12,12)
	entity.Velocity = Vector(0,0)
	for i = 1, 6 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -4
			Projectile.DepthOffset = 20
	end
		tear:Remove()
		end
		end
		end
		end
	
			if entity:GetSprite():GetFrame() > 65 and entity:GetSprite():GetFrame() < 85 then ---- FIRST GRAPPLE
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Grapple == true then
		if tear.Position:Distance(entity.Position) > 28 then
		local afterim = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Shackle Afterimage"), 0, entity.Position + Vector(0,0) , Vector(0,0), nil)
		entity:AddVelocity((tear.Position - entity.Position):Normalized() * 14.3)
		entity.Velocity = entity.Velocity - entity.Velocity/4
		else
	sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.5,0,false,1)
	Game():ShakeScreen(12,12)
	entity.Velocity = Vector(0,0)
	for i = 1, 6 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -4
			Projectile.DepthOffset = 20
	end
		tear:Remove()
		end
		end
		end
		end
	
		if entity:GetSprite():GetFrame() > 99 and entity:GetSprite():GetFrame() < 113 then ---- FIRST GRAPPLE
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Grapple == true then
		if tear.Position:Distance(entity.Position) > 23 then
		local afterim = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Shackle Afterimage"), 0, entity.Position + Vector(0,0) , Vector(0,0), nil)
		entity:AddVelocity((tear.Position - entity.Position):Normalized() * 14.3)
		entity.Velocity = entity.Velocity - entity.Velocity/4
		else
	sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.5,0,false,1)
	Game():ShakeScreen(12,12)
	entity.Velocity = Vector(0,0)
	for i = 1, 6 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -4
			Projectile.DepthOffset = 20
	end
		tear:Remove()
		end
		end
		end
		end
	
	if entity:GetSprite():GetFrame() > 129 and entity:GetSprite():GetFrame() < 152 then ---- FIRST GRAPPLE
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Grapple == true then
		if tear.Position:Distance(entity.Position) > 23 then
		local afterim = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Shackle Afterimage"), 0, entity.Position + Vector(0,0) , Vector(0,0), nil)
		entity:AddVelocity((tear.Position - entity.Position):Normalized() * 14.3)
		entity.Velocity = entity.Velocity - entity.Velocity/4
		else
	sound:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1.5,0,false,0.7)
	Game():ShakeScreen(12,12)
	entity.Velocity = Vector(0,0)
	for i = 1, 8 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(target.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -4
			Projectile.DepthOffset = 20
	end
			
		tear:Remove()
		end
		end
		end
		end
	
	if data.StateFrame == 1 then
	entity.Velocity = Vector(0,0)
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		tear:GetData().Lifetime = 100
		end
		entity:GetSprite():Play("RapidGrapple", true)
	
	
	
	elseif entity:GetSprite():IsEventTriggered("HookG1") then
	entity.Velocity = Vector(0,0)
	sound:Play(SoundEffect.SOUND_SHELLGAME,1,0,false,0.7)
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(-5,0),((topl + Vector(POSROLL1,0)) - entity.Position):Normalized() * 34, entity)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip.SpriteRotation = (entity.Position - (topl + Vector(POSROLL1,0))):GetAngleDegrees()
	hooktip:GetData().SegCount = 28
	hooktip:GetData().Grapple = true
	
	elseif entity:GetSprite():IsEventTriggered("HookG2") then
	entity.Velocity = Vector(0,0)
	sound:Play(SoundEffect.SOUND_SHELLGAME,1,0,false,0.7)
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(-5,0),((botr + Vector(-(POSROLL2),0)) - entity.Position):Normalized() * 34, entity)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip.SpriteRotation = (entity.Position - (botr + Vector(-(POSROLL2),0))):GetAngleDegrees()
	hooktip:GetData().SegCount = 28
	hooktip:GetData().Grapple = true
	
	elseif entity:GetSprite():IsEventTriggered("HookG3") then
	entity.Velocity = Vector(0,0)
	sound:Play(SoundEffect.SOUND_SHELLGAME,1,0,false,0.7)
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(-5,0),((topl + Vector(POSROLL3,0)) - entity.Position):Normalized() * 34, entity)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip.SpriteRotation = (entity.Position - (topl + Vector(POSROLL3,0))):GetAngleDegrees()
	hooktip:GetData().SegCount = 28
	hooktip:GetData().Grapple = true
	
	elseif entity:GetSprite():IsEventTriggered("HookG4") then
	entity.Velocity = Vector(0,0)
	sound:Play(SoundEffect.SOUND_SHELLGAME,1,0,false,0.7)
	local hooktip = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, entity.Position + Vector(-5,0),((botr + Vector(-(POSROLL4),0)) - entity.Position):Normalized() * 34, entity)
	hooktip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	hooktip.SpriteRotation = (entity.Position - (botr + Vector(-(POSROLL4),0))):GetAngleDegrees()
	hooktip:GetData().SegCount = 28
	hooktip:GetData().Grapple = true
	
	elseif entity:GetSprite():IsEventTriggered("Hook2") then
	entity.Velocity = Vector(0,0)
		elseif entity:GetSprite():IsFinished("RapidGrapple") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end ----------
	elseif data.State == ShackleState.JUMPMID then
		if data.StateFrame == 1 then
			entity.Velocity = Vector(0,0)
			entity:GetSprite():Play("Jump Up", true)
	elseif entity:GetSprite():IsEventTriggered("Jump") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	entity:AddVelocity((room:GetCenterPos() - entity.Position):Normalized() * 9)
	sound:Play(SoundEffect.SOUND_MONSTER_GRUNT_2,1,0,false,1)
	elseif entity:GetSprite():IsEventTriggered("Pound") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.Velocity = Vector(0,0)
	Game():ShakeScreen(7,7)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,9),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,9),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,-9),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,-9),entity):ToProjectile()

	sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.7,0,false,0.5)
	sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1)
	elseif entity:GetSprite():IsFinished("Jump Up") then
			data.State = ShackleTransition(data.State)
			data.StateFrame = 0
		end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ShackleUpdate, EntityType.THESHACKLE);

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local shackle = Isaac.FindByType(EntityType.THESHACKLE, Isaac.GetEntityVariantByName("The Shackle"), -1, false, false)
    for _, boss in ipairs(shackle) do
		local room = Game():GetRoom()
        local sprite = boss:GetSprite()
		if sprite:IsEventTriggered("Bomb") then
	sound:Play(SoundEffect.SOUND_KEY_DROP0,1.1,0,false,0.3)
	Isaac.Explode(boss.Position, boss, 20)
		Game():ShakeScreen(8)
        end
    end
end)
