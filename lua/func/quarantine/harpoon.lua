
--nil m

EntityType.CHAINHARPOON = Isaac.GetEntityTypeByName("Chain Harpoon")

local DepthOffsetMode = {
	LOW = 1,
	HIGH = 2,
	EQUAL_TO_PARENT = 3,
	EQUAL_TO_CENTERPOINT = 4
}

function ApplyChainToEntity(ent, chainlength, renderoffset, fadein, depthoffsetmode)
	local data = ent:GetData()
	data.HasChainAttached = true
	data.ChainLength = chainlength or 10
	data.ChainRenderOffset = renderoffset or Vector(0,0)
	data.ChainEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EFFECT_NULL, 0, ent.Position, Vector(0,0), ent)
	data.ChainEffect:GetData().IsChainEffect = true
	data.ChainEffect:GetData().ChainParent = ent
	data.ChainEffect:GetData().DepthOffsetMode = depthoffsetmode or 1
	data.Chains = {}
	for i=1, data.ChainLength do
		data.Chains[i] = {
			Sprite = Sprite(),
			Position = ent.Position,
			Active = i == 1 or not fadein,
			Alpha = 0
		}
		data.Chains[i].Sprite:Load("gfx/effects/chains.anm2", true)
		data.Chains[i].Sprite:SetFrame("chain"..tostring(i%2+1), 0)
	end
end

local EntityTypeNames = {"NPC", "POST_PLAYER", "FAMILIAR", "POST_PICKUP", "POST_TEAR", "POST_PROJECTILE", "POST_LASER", "POST_KNIFE", "POST_BOMB"}

for _,entitytypename in ipairs(EntityTypeNames) do
	EXILE_M:AddCallback(ModCallbacks["MC_"..entitytypename.."_UPDATE"], function(_, ent)
		local data = ent:GetData()
		if data.HasChainAttached then
			for i=1, data.ChainLength do
				local chain = data.Chains[i]
				local updatechain = false
				local targetposition
				if chain.Active then
					if i == 1 then
						targetposition = ent.Position
						if targetposition.X ~= chain.Position.X or targetposition.Y ~= chain.Position.Y then
							updatechain = true
						else 
							break 
						end
					else
						targetposition = data.Chains[i-1].Position + Vector.FromAngle(data.Chains[i-1].Sprite.Rotation)*16
						if targetposition.X ~= chain.Position.X or targetposition.Y ~= chain.Position.Y then
							updatechain = true
						else 
							break
						end
					end
				else
					targetposition = data.Chains[i-1].Position + Vector.FromAngle(data.Chains[i-1].Sprite.Rotation)*16
					if (chain.Position-targetposition):LengthSquared() >= 1000 then
						chain.Active = true
						updatechain = true
					else
						break
					end
				end
				if updatechain then
					chain.Sprite.Rotation = ((chain.Position + Vector.FromAngle(data.Chains[i].Sprite.Rotation)*10) - targetposition):GetAngleDegrees()
					chain.Position = targetposition
					if chain.Alpha ~= 1 then
						chain.Alpha = math.min(chain.Alpha+0.05, 1)
						chain.Sprite.Color = Color(1 ,1 ,1 , chain.Alpha, 0, 0, 0)
					end
				end
			end
		end
	end)

	EXILE_M:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, ent)
		local data = ent:GetData()
		if data.IsChainEffect then
			if data.ChainParent and data.ChainParent:Exists() then
				local parentdata = data.ChainParent:GetData()
				local chaincenterpos = Vector(0,0)
				local currentchainlength = 0
				for i=0, parentdata.ChainLength-1 do
					local chainid = math.max((parentdata.ChainLength+1) - math.max(i + (i%2)*2, 1), 1)
					local chain = parentdata.Chains[chainid]
					if chain.Active then
						chaincenterpos = chaincenterpos+chain.Position
						currentchainlength = currentchainlength+1
						chain.Sprite:Render(Isaac.WorldToScreen(chain.Position)+parentdata.ChainRenderOffset, Vector(0,0), Vector(0,0))
					end
				end
				if data.DepthOffsetMode == DepthOffsetMode.LOW then
					ent.Position = Vector(0,0)
				elseif data.DepthOffsetMode == DepthOffsetMode.HIGH then
					ent.Position = Vector(0,3000)
				elseif data.DepthOffsetMode == DepthOffsetMode.EQUAL_TO_PARENT then
					ent.Position = data.ChainParent.Position+Vector(0,-1)
				elseif data.DepthOffsetMode == DepthOffsetMode.EQUAL_TO_CENTERPOINT then
					ent.Position = chaincenterpos/currentchainlength
				end
			else
				local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, ent.Position, Vector(0,0), ent)
			local offsety = math.random(-30,-10)
			local offsetx = math.random(-20,20)
			blood.SpriteScale = Vector(1.2,1.2)
			blood:SetColor(Color(0.4, 0.4, 0.4, 1, 0, 0, 0),0,1,false,false)
			blood.PositionOffset = Vector(offsetx,offsety)
				ent:Remove()
			end
		end
	end, EffectVariant.EFFECT_NULL)
end


function EXILE_M:harpoonUpd(entity)
  local data, sprite, target = entity:GetData(), entity:GetSprite(), entity:GetPlayerTarget()
	if entity.Variant == Isaac.GetEntityVariantByName("Chain Harpoon") then
	if data.InWall == nil then data.InWall = false end
	if data.Chained == nil then data.Chained = false end
	if data.Lifetime == nil then data.Lifetime = 0 end
	
	if not data.InWall == true then
	if not entity:GetSprite():IsPlaying("Idle", true) then
		entity:GetSprite():Play("Idle", true)
		
	end
	end
	
	if not data.Chained == true then
	entity:PlaySound(Isaac.GetSoundIdByName("Portcullis 2"), 1, 0, false, 1)
	entity.DepthOffset = 10
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	ApplyChainToEntity(entity, entity:GetData().SegCount, Vector(0,0), true, 3)
	data.Chained = true
	end
	
	if data.Lifetime > 100 then
	entity:SetColor(Color(1,0.10,0.10,1,0,0,0),999,0,0,false)
	end
	
	if data.Lifetime > 120 then
			sound:Play(SoundEffect.SOUND_KEY_DROP0,1.1,0,false,0.3)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(3,3),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-3,3),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(3,-3),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-3,-3),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,5),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-5),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(5,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-5,0),entity):ToProjectile()
	Isaac.Explode(entity.Position, entity, 20)
	entity:Remove()
	end
	
	if entity:CollidesWithGrid() and not data.InWall == true then
	data.InWall = true
	entity.Velocity = Vector(0,0)
	entity.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	Game():ShakeScreen(8,8)
	sound:Play(SoundEffect.SOUND_KEY_DROP0,1.1,0,false,0.52)
	sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1.1,0,false,1)
	for i = 1, 4 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - Isaac.GetFreeNearPosition(entity.Position, 4)):Resized(8)):Rotated(math.random(-60,25)) * (math.random(40, 180) / 90)), entity, 0, 0):ToProjectile()
			Projectile.FallingAccel = (math.random(4, 6)/10) --(math.random(4, 6)/10)
			Projectile.FallingSpeed = -(math.random(70, 80)/10) --(math.random(70, 80)/10)
			Projectile.Scale = (math.random(100,150))/100
			Projectile.Height = -4
			Projectile.DepthOffset = 20
			Projectile.ProjectileFlags = ProjectileFlags.NO_WALL_COLLIDE
	end
	end
	
	if data.InWall == true then
	data.Lifetime = data.Lifetime + 1
	entity.Velocity = Vector(0,0)
		if not entity:GetSprite():IsPlaying("InWall", true) then
		entity:GetSprite():Play("InWall", true)
		end
	end
	
	end
	if entity.Variant == Isaac.GetEntityVariantByName("Chain Harpoon Chain Solid") then
	entity.Velocity = Vector(0,0)
	if not entity:GetSprite():IsPlaying("Idle", true) then
		entity:GetSprite():Play("Idle", true)
	elseif entity:GetSprite():IsEventTriggered("Break") then
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-30,-10)
			local offsetx = math.random(-20,20)
			blood.SpriteScale = Vector(1.2,1.2)
			blood:SetColor(Color(0.4, 0.4, 0.4, 1, 0, 0, 0),0,1,false,false)
			blood.PositionOffset = Vector(offsetx,offsety)
			sound:Play(SoundEffect.SOUND_KEY_DROP0,1.1,0,false,0.52)
	elseif entity:GetSprite():IsEventTriggered("Remove") then
	entity:Remove()
	end
end
end
	
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.harpoonUpd, EntityType.CHAINHARPOON)	

function EXILE_M:ChainOrbits(f)
	if f:GetData().HasParent == true then
	f.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	
    if f:GetData().Degrees == nil then f:GetData().Degrees = 0 end
    if f:GetData().Radius == nil then f:GetData().Radius = 0 end
    f:GetData().Degrees = f:GetData().Degrees + f:GetData().DistanceRad
    f:GetData().Radius = 40 * f:GetData().DistanceOut
    if f:GetData().Degrees >= 360 then f:GetData().Degrees = 0 end
    if f:GetData().Degrees <= -360 then f:GetData().Degrees = 0 end
    for i = 0, Isaac.CountEntities(entity, Isaac.GetEntityTypeByName("Chain Harpoon Swinger"), Isaac.GetEntityVariantByName("Chain Harpoon Swinger"), -1) do
        local spawner = f:GetData().Spawner
        local direction = Vector.FromAngle(f:GetData().Degrees):Normalized()
        f:GetData().NewPos = spawner.Position + direction * f:GetData().Radius
        f.Velocity = -(f.Position - f:GetData().NewPos)/4
		f.SpriteRotation = direction:GetAngleDegrees() - 95
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ChainOrbits, EntityType.CHAINHARPOON);

function EXILE_M:ChainOrbits2(f)
	if f:GetData().HasParent == true then
	f.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	
    if f:GetData().Degrees == nil then f:GetData().Degrees = 0 end
    if f:GetData().Radius == nil then f:GetData().Radius = 0 end
    f:GetData().Degrees = f:GetData().Degrees + f:GetData().DistanceRad
    f:GetData().Radius = 40 * f:GetData().DistanceOut
    if f:GetData().Degrees >= 360 then f:GetData().Degrees = 0 end
    if f:GetData().Degrees <= -360 then f:GetData().Degrees = 0 end
    for i = 0, Isaac.CountEntities(entity, Isaac.GetEntityTypeByName("Chain Harpoon Swinger"), Isaac.GetEntityVariantByName("Chain Harpoon Swing Chain"), -1) do
        local spawner = f:GetData().Spawner
        local direction = Vector.FromAngle(f:GetData().Degrees):Normalized()
        f:GetData().NewPos = (spawner.Position + f:GetData().Offset) + direction * f:GetData().Radius
        f.Velocity = -(f.Position - f:GetData().NewPos)/4
		f.SpriteRotation = direction:GetAngleDegrees() - 115
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ChainOrbits2, EntityType.CHAINHARPOON);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	