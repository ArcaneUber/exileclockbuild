
EntityType.PERIWINKLE = Isaac.GetEntityTypeByName("Periwinkle")
EntityType.BEARTRAP = Isaac.GetEntityTypeByName("Bear Trap")
EntityType.JUNKER = Isaac.GetEntityTypeByName("Junker")
EntityType.SHROUD = Isaac.GetEntityTypeByName("Shroud")
EntityType.POTHEAD = Isaac.GetEntityTypeByName("Pothead")
EntityType.DRILLBIT = Isaac.GetEntityTypeByName("Drillbit")
EntityType.BOILER = Isaac.GetEntityTypeByName("Boiler")

SoundEffect.SOUND_SNAP_SHUT = Isaac.GetSoundIdByName("SnapShut")
SoundEffect.SOUND_SQUISH = Isaac.GetSoundIdByName("DieSquish")
SoundEffect.SOUND_METALFOOTSTEPS = Isaac.GetSoundIdByName("Metal Footsteps")
SoundEffect.SOUND_WHISTLEBLOW = Isaac.GetSoundIdByName("Whistle Blow")

EntityType.GAPERRANG = Isaac.GetEntityTypeByName("Gaperrang")
EntityType.GAPERRANGHEAD = Isaac.GetEntityTypeByName("Gaperrang Head")


------------ Revelations Walk Function (Used with permission)

local function LoadCode()
function EXILE_M.AddFrame(sprite, frame)
  for i=1, frame do
    sprite:Update()
  end
end


function DotChaseTarg(speed, maxspeed, e, slide, pfcount) --- 
	local data = e:GetData()
	local path = e.Pathfinder
	local target = e:GetPlayerTarget()
	local dist = target.Position:Distance(e.Position)
	local Room = Game():GetRoom()
	local gin = Room:GetGridIndex
	(e.Position + Vector.FromAngle((e.Velocity):GetAngleDegrees()):Resized(5+e.Size))
	local gen = Room:GetGridEntity(gin)
	local rng = e:GetDropRNG()

	if not data.init then
		data.init = true
		data.PathFindingTime = 0
		data.tpos = target.Position
		data.FearSpeed = 1
		data.Tolerance = 1
	end

	e.Velocity = e.Velocity * slide --slip
	local angle = (data.tpos-e.Position):GetAngleDegrees()
	if e:HasEntityFlags(1<<9) then -- Confusion
		if e.FrameCount % 25 == 0 or data.tpos:Distance(e.Position) < 30 or e:CollidesWithGrid() then
			data.tpos = e.Position+Vector.FromAngle(rng:RandomInt(120)):Resized(math.random(60,85))
		end
		data.FearSpeed = 1
	else
		if e:HasEntityFlags(1<<11) or e:HasEntityFlags(1<<24) then -- 11:Fear, 24:Shrink
			data.FearSpeed = 1.2
			if data.tpos:Distance(target.Position) <= 250 then
			for i=1, 10 do
				data.tpos = Room:GetRandomPosition(40)
				if data.tpos:Distance(target.Position) > 300
				and math.abs((data.tpos-target.Position):GetAngleDegrees()-angle) > 150 then
					break
					end
				end
			end
			data.Tolerance = 25
		else -- Default
			data.tpos = target.Position
			data.FearSpeed = 1
			data.Tolerance = 1
		end
	end

	data.PathFindingTime = data.PathFindingTime - 1

	if data.PathFindingTime > 0 then
		path:FindGridPath(data.tpos, maxspeed*0.203*data.FearSpeed, 900, false)
	else
		if e.Velocity:Length() < maxspeed then
			if data.tpos:Distance(e.Position) > data.Tolerance then
				e:AddVelocity(Vector.FromAngle(angle):Resized(speed*data.FearSpeed))
			end
		end
		if (gen and ((gen:GetType() > 1 and gen:GetType() < 16 and gen:GetType() ~= 10) or gen:GetType() == 22))
		or e:CollidesWithGrid() then
			data.PathFindingTime = pfcount
		end
	end
end


function EXILE_M.AnimateWalkFrame(sprite, velocity, walkAnims, flipWhenRight, noFlip)
    local frame, anim, flip = 0, nil, false

    for _, anim in pairs(walkAnims) do
        if sprite:IsPlaying(anim) then
            frame = sprite:GetFrame() + 1
        end
    end

    local x, y = velocity.X, velocity.Y
    if math.abs(x) > math.abs(y) then
        if x < 0 then
            if walkAnims.Left then
                anim = walkAnims.Left
            else
                anim = walkAnims.Horizontal
                if not flipWhenRight and not noFlip then
                    flip = true
                end
            end
        else
            if walkAnims.Right then
                anim = walkAnims.Right
            else
                anim = walkAnims.Horizontal
                if flipWhenRight and not noFlip then
                    flip = true
                end
            end
        end
    else
        if y < 0 then
            if walkAnims.Up then
                anim = walkAnims.Up
            else
                anim = walkAnims.Vertical
            end
        else
            if walkAnims.Down then
                anim = walkAnims.Down
            else
                anim = walkAnims.Vertical
            end
        end
    end

    sprite.FlipX = flip
    if not sprite:IsPlaying(anim) then
        sprite:Play(anim, true)
        if frame > 0 then
            EXILE_M.AddFrame(sprite, frame)
        end
    end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Gear Worm") then

        entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

        local player = Isaac.GetPlayer(0)
        local sprite = entity:GetSprite()

        local target = entity:GetPlayerTarget()
        local data = entity:GetData()
        if data.GridCountdown == nil then data.GridCountdown = 0 end

        if entity.State == 0 then
			entity.Velocity = Vector(0,0)
            if not sprite:IsPlaying("digOut") then
                sprite:Play("digOut", false)
            elseif sprite:IsEventTriggered("Emerge") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                sound:Play(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1.3)
                Game():ShakeScreen(3,3)
            end
        end

        if sprite:IsFinished("digOut") then
            entity.State = 2
        end


        if entity.State == 2 then
			entity.Velocity = Vector(0,0)
            if not sprite:IsPlaying("digIn") then
                sprite:Play("digIn", false)
            end

            if sprite:GetFrame() == 9 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,12),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 11 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,9),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 13 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-12,0),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 15 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,-9),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 17 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-12),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 19 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,-9),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 21 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(12,0),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 23 then
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,9),entity):ToProjectile()
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                tear.Height = -18
                tear.FallingSpeed = -7
                tear:GetData().SlowFallProj = true
            elseif sprite:GetFrame() == 7 then
                sound:Play(SoundEffect.SOUND_CUTE_GRUNT,1,0,false,1)
            end

            if sprite:IsFinished("digIn") then
                entity.State = 0
                local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 65, 13)
                entity.Position = teleportPosition
            end

        end
    end

end, 738)



function EXILE_M:GaperrangUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Gaperrang") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	sprite:PlayOverlay("Head", false)
		if entity:IsFrame(2, 0) then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)

			if data.GridCountdown <= 0 then
			data.GridCountdown = 30
			else
			data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Velocity = (target.Position - entity.Position):Normalized() * 0.6 * 6
			end
			local attacktime = math.random(1,512)
			if attacktime > 500 then
			entity.State = 2
			attacktime = 0
			else
			entity.State = 0
			attacktime = 0
			end
		end
	elseif entity.State == 2 then
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.5 * 4
	if not sprite:IsOverlayPlaying("SpinStart") then
	sprite:PlayOverlay("SpinStart", false)
	elseif sprite:IsOverlayPlaying("SpinStart") then
		if sprite:GetOverlayFrame() == 5 then
		sound:Play(SoundEffect.SOUND_MOUTH_FULL,1.4,60,false,1)
		elseif sprite:GetOverlayFrame() == 35 then
		sound:Play(SoundEffect.SOUND_MONSTER_ROAR_0,1,60,false,1)
		sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1.25,60,false,1)
		sound:Play(Sounds.WHOOSH,1.4,60,false,1)
		entity:BloodExplode()
		Isaac.Explode(entity.Position, entity, 0)
		local head = Isaac.Spawn(EntityType.GAPERRANGHEAD, Isaac.GetEntityVariantByName("Gaperrang Head"), 
		0, entity.Position, (target.Position - entity.Position):Normalized() * 17, entity)
		head.DepthOffset = 30
		head:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		--head:AddVelocity((target.Position - entity.Position):Normalized() * 8)
		
		--
		--
		
		end
	end
	if sprite:IsOverlayFinished("SpinStart") then
		entity.State = 3
	end
	end
	if entity.State == 3 then
		sprite:RemoveOverlay()
		if entity:IsFrame(2, 0) then
			if entity:CollidesWithGrid() or data.GridCountdown > 0 then
			entity.Pathfinder:FindGridPath(target.Position, 0.7, 1, true)

			if data.GridCountdown <= 0 then
			data.GridCountdown = 30
			else
			data.GridCountdown = data.GridCountdown - 1
			end
		else
			entity.Velocity = (target.Position - entity.Position):Normalized() * 0.4 * 5
			end
				if entity:IsFrame(6, 0) then
			--	local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0,entity.Position, Vector(0,0), entity)
			--	creep.SpriteScale = Vector(0.9,0.9)
				end
			end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.GaperrangUpdate, EntityType.GAPERRANG)

function EXILE_M:GaperrangHeadUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Gaperrang Head") then
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()

	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
	
	if not sound:IsPlaying(Sounds.SPINLOOP) then
	sound:Play(Sounds.SPINLOOP,1.4,0,false,1)
	end
	
	local diagonals = {
		Vector(1, 1):Normalized(),
		Vector(-1, 1):Normalized(),
		Vector(1, -1):Normalized(),
		Vector(-1, -1):Normalized()
	}

		local vel = entity.Velocity:Normalized()
        local closestDir
        local dist
        for _, direction in ipairs(diagonals) do
            local distance = vel:Distance(direction)
            if not dist or distance < dist then
                closestDir = direction
                dist = distance
            end
        end
		
		entity.Velocity = closestDir:Resized(5.2)
	
	if entity:IsFrame(70,0) then
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,6),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-6),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(6,0),entity)
		Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-6,0),entity)
	end

		if not entity:GetSprite():IsPlaying("Idle", true) then
		entity:GetSprite():Play("Idle", true)
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.GaperrangHeadUpdate, EntityType.GAPERRANGHEAD)


function EXILE_M:DrillbitUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Drillbit") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	
	entity.SpriteScale = Vector(1.2,1.2)
	
	if entity.State == 0 then
		entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	
	if not sprite:IsPlaying("Idle") then
		sprite:Play("Idle", false)
	end
	
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.5 * 6
	
	if target.Position:Distance(entity.Position) < 30 then
		entity.State = 2
		else
		entity.State = 0
		end
			elseif entity.State == 2 then
			entity.Velocity = Vector(0,0)
				if not sprite:IsPlaying("SmashDown") then
				sprite:Play("SmashDown", false)
				elseif sprite:IsEventTriggered("Impact") then
				entity.Velocity = Vector(0,0)
				Game():ShakeScreen(6,6)
				entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
			
			tear1:GetData().StoneProj = true
			tear2:GetData().StoneProj = true
			tear3:GetData().StoneProj = true
			tear4:GetData().StoneProj = true
			
			tear5:GetData().StoneProj = true
			tear6:GetData().StoneProj = true
			tear7:GetData().StoneProj = true
			tear8:GetData().StoneProj = true
			
		tear1:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear1:GetSprite():LoadGraphics()
		tear2:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear2:GetSprite():LoadGraphics()
		tear3:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear3:GetSprite():LoadGraphics()
		tear4:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear4:GetSprite():LoadGraphics()
		
		tear5:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear5:GetSprite():LoadGraphics()
		tear6:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear6:GetSprite():LoadGraphics()
		tear7:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear7:GetSprite():LoadGraphics()
		tear8:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		tear8:GetSprite():LoadGraphics()
	
	
	entity:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1.1)
	entity:PlaySound(SoundEffect.SOUND_CUTE_GRUNT,1.15,0,false,1)
	elseif sprite:IsEventTriggered("Drill") then
	Game():ShakeScreen(8,8)
	entity:PlaySound(Sounds.BUZZSAW,1.35,0,false,1)
	entity:PlaySound(SoundEffect.SOUND_MULTI_SCREAM,1.1,0,false,1)
	elseif sprite:GetFrame() > 40 and sprite:GetFrame() < 70 and entity:IsFrame(4,0) then
	entity:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE,0.8,0,false,1)

	
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-20,20)
			local offsetx = math.random(-20,20)
			blood.SpriteScale = Vector(0.75,0.75)
			blood.PositionOffset = Vector(offsetx,offsety)

	elseif sprite:IsEventTriggered("In") then
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,1,0,false,1)
	end
	if sprite:IsFinished("SmashDown") then
	entity.State = 3
	end
	elseif entity.State == 3 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	entity.Velocity = (target.Position - entity.Position):Normalized() * 0.6 * 7
	if entity:IsFrame(5,0) then
	local rock = Game():Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ROCK_EXPLOSION, entity.Position, Vector(0,0), player, 0, 0)
	rock.DepthOffset = 55
	entity:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,0.55)
	end
	
	if not sprite:IsPlaying("IdleInvisible") then
	sprite:Play("IdleInvisible", false)
	end
	
	if sprite:IsFinished("IdleInvisible") then
	entity.State = 4
	end
	elseif entity.State == 4 then
	entity.Velocity = Vector(0,0)
	if not sprite:IsPlaying("PopOut") then
	sprite:Play("PopOut", false)
	elseif sprite:IsEventTriggered("Drill") then
	Game():ShakeScreen(8,8)
	entity:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,1,0,false,1)
	elseif sprite:GetFrame() == 18 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end
	
	if sprite:IsFinished("PopOut") then
	entity.State = 0
	end
	
	
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.DrillbitUpdate, EntityType.DRILLBIT)

function EXILE_M:PotheadUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Pothead") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	entity.Pathfinder:FindGridPath(target.Position, 0.53, 1, false)
	if entity.State == 0 then
	sprite:PlayOverlay("HeadShoot", false)
		if sprite:GetOverlayFrame() == 3 then
		entity:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,7),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,7),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,-7),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,-7),entity):ToProjectile()
		end
		
		if sprite:GetOverlayFrame() == 31 then
		entity:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
		end
	
		if entity:IsFrame(1, 0) then
		if sprite:GetOverlayFrame() > 60 then
			if target.Position:Distance(entity.Position) > 150 then
			entity.State = 2
			else
			entity.State = 0
			end
			end
		end
		
	elseif entity.State == 2 then
	if not sprite:IsOverlayPlaying("HeadLaunch") then
	sprite:PlayOverlay("HeadLaunch", false)
	elseif sprite:IsOverlayPlaying("HeadLaunch") then
		if sprite:GetOverlayFrame() == 5 then
		
		elseif sprite:GetOverlayFrame() == 27 then
		entity:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1.7)
		local p = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 12,entity):ToProjectile()
			p.CollisionDamage = 1
		p:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		p:GetSprite():LoadGraphics()
		p:GetData().StoneProj = true
		p:GetData().GrowProj = true
		p.Height = -26
				p.Scale = 2.2
				p.FallingSpeed = -12.6
				p.FallingAccel = 1.05
				entity:PlaySound(SoundEffect.SOUND_GHOST_SHOOT,1,0,false,1)
		
		--
		--
		
		end
	end
	if sprite:IsOverlayFinished("HeadLaunch") then
		if target.Position:Distance(entity.Position) > 150 then
		entity.State = 0
		else
		entity.State = 2
		end
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.PotheadUpdate, EntityType.POTHEAD)

function EXILE_M:ShroudUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Shroud") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	local data = entity:GetData()
	local target = entity:GetPlayerTarget()
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	if data.Spawn == nil then data.Spawn = 0 end
	
	if entity.State == 0 then
	entity.Velocity = Vector(0,0)
	if not sprite:IsPlaying("IdleFire") then
	sprite:Play("IdleFire", true)
	end
	if player.Position:Distance(entity.Position) < 66 or data.Spawn == 1 then
	Isaac.Spawn(EntityType.ENTITY_EFFECT,15,0,entity.Position, Vector(0,0), entity)
	entity:PlaySound(SoundEffect.SOUND_FIREDEATH_HISS,1.3,0,false,1)
	entity.State = 2
	else
	entity.State = 0
	end
	elseif entity.State == 2 then
	sprite.FlipX = (entity.Position.X < target.Position.X)
	entity.Velocity = (target.Position - entity.Position):Normalized() * 2.7
	if not sprite:IsPlaying("IdleGhost") and not sprite:IsFinished("IdleGhost") then
	sprite:Play("IdleGhost", true)
	end
	
	if sprite:IsFinished("IdleGhost") then
	local roll = math.random(1,8)
	if roll > 4 then
	entity.State = 3
	else
	entity.State = 2
	end
	
	end
	elseif entity.State == 3 then
	entity.Velocity = entity.Velocity * 0.86
	--entity.Velocity = entity.Velocity:Resized(2)
	if not sprite:IsPlaying("GhostShoot") and not sprite:IsFinished("GhostShoot") then
	sprite:Play("GhostShoot", true)
	end
	
	if sprite:IsEventTriggered("shoot") then
	entity:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,1.4,0,false,1)
	entity:AddVelocity(-(target.Position - entity.Position):Normalized() * 7)
                    local p = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,(target.Position - entity.Position):Normalized() * 8.5,entity):ToProjectile()
                    p.FallingSpeed = -3
                    p.FallingAccel = 0.05
					p.ProjectileFlags = ProjectileFlags.SMART
	
		--	for i = 1, math.random(12, 16) do
		--		local p = Isaac.Spawn(9, 0, 0, entity.Position, Vector.FromAngle(math.random(0, 360)) * (math.random(200, 2400) * 0.01), entity):ToProjectile()
		--		p.Scale = p.Scale * math.random(40, 180) * 0.01
		--		p.FallingSpeed = -10
		--		local pData = p:GetData()
		--		pData.SlowFallProj = true
		--	end
	end
	
	if sprite:IsFinished("GhostShoot") then
		local roll = math.random(1,6)
	if roll > 3 then
	entity.State = 4
	else
	entity.State = 2
	end
	end
	elseif entity.State == 4 then
	entity.Velocity = Vector(0,0)
	if not sprite:IsPlaying("Teleport") and not sprite:IsFinished("Teleport") then
	sprite:Play("Teleport", true)
	end
	
	if entity:GetSprite():IsEventTriggered("teleport") then
	entity:PlaySound(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,1)
		local teleportPosition = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 185, 13)
		entity.Position = teleportPosition
		--sound:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,1)
	end
	
	if sprite:IsFinished("Teleport") then
	entity.State = 2
	end
	
	end
	end
end



EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ShroudUpdate, EntityType.SHROUD)

function EXILE_M:ShroudDamage(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Shroud") and entity:GetData().Spawn == 0 then
	Isaac.Spawn(EntityType.ENTITY_EFFECT,15,0,entity.Position, Vector(0,0), entity)
	sound:Play(SoundEffect.SOUND_FIREDEATH_HISS,1,0,false,1)
	entity:GetData().Spawn = 1
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.ShroudDamage, EntityType.SHROUD);

function EXILE_M:BoilerUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Boiler") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	if entity.State == 0 then
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	sprite:PlayOverlay("Head1", false)
	
	if sprite:IsEventTriggered("step") then
	entity:PlaySound(SoundEffect.SOUND_METALFOOTSTEPS,0.75,0,false,1)
	end
	
		if entity:IsFrame(12,0) then
		local roll = math.random(1,55)
		if roll > 48 then
		entity.State = 2
		else
		
		end
		end
		
		
		if entity:IsFrame(2, 0) then
			if entity.Position:Distance(target.Position) < 110 then
			entity.Pathfinder:FindGridPath(target.Position, 0.8, 1, true)
			else
			entity.Pathfinder:FindGridPath(target.Position, 0.67, 1, true)
			end
		end
	end
	
	if entity.State == 2 then
	entity.Velocity = Vector(0,0)
	if not sprite:IsPlaying("BurnUp") and not sprite:IsFinished("BurnUp") then
	sprite:Play("BurnUp", false)
	sprite:PlayOverlay("BurnUpHead", false)
	elseif sprite:GetFrame() == 2 then
	entity:PlaySound(SoundEffect.SOUND_WHISTLEBLOW,1.1,0,false,1)
	elseif sprite:GetFrame() == 43 then
		    for i = -16, 16, 16 do
            local p = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 2, 0, entity.Position, (entity:GetPlayerTarget().Position - entity.Position):Resized(7.5):Rotated(i):Normalized() * 7.3, entity):ToProjectile()
			end
			entity:PlaySound(SoundEffect.SOUND_FIRE_RUSH,1,0,false,1)
	elseif sprite:IsFinished("BurnUp") then
	entity.State = 0
	end
	
	if sprite:IsFinished("BurnUp") then
	entity.State = 0
	end
	
	end
end

end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BoilerUpdate, EntityType.BOILER)

function EXILE_M:BoilerDeath(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Boiler") then
	local player = Isaac.GetPlayer(0)
	Isaac.Explode(entity.Position, entity, 5)
	entity:PlaySound(SoundEffect.SOUND_WHISTLEBLOW,1.05,0,false,0.94)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(5,5),entity):ToProjectile()
			local tear2 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-5,5),entity):ToProjectile()
			local tear3 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(5,-5),entity):ToProjectile()
			local tear4 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-5,-5),entity):ToProjectile()

			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,7),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(0,-7),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(7,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,2,0,entity.Position + Vector(0,0) ,Vector(-7,0),entity):ToProjectile()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.BoilerDeath, EntityType.BOILER);

function EXILE_M:JunkerUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Junker") then
	local player = Isaac.GetPlayer(0)
	local sprite = entity:GetSprite()
	
		entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	sprite:PlayOverlay("Head", false)
		if entity:IsFrame(2, 0) then
		DotChaseTarg(0.5, 3, entity, 0.85, 75)
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
		entity:PlaySound(SoundEffect.SOUND_MOUTH_FULL,1.4,60,false,1)
		elseif sprite:GetOverlayFrame() == 33 then
		for i = 1, 4 do
			local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, entity.Position, ((-(entity.Position - target.Position):Resized(8)):Rotated(math.random(-10,10)) * (math.random(111, 150) / 100)), entity, 0, 0):ToProjectile()
			Projectile.FallingSpeed = -0.002
			Projectile.FallingAccel = 0.02
			Projectile.Scale = 1
			Projectile.Height = -22
			Projectile.DepthOffset = 43
			Projectile.Damage = 1
		Projectile:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
		Projectile:GetSprite():LoadGraphics()
		Projectile:GetData().StoneProj = true
		end
		entity:PlaySound(SoundEffect.SOUND_GHOST_SHOOT,1,60,false,1)
		
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
	if entity.Variant == Isaac.GetEntityVariantByName("Junker") then
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
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.JunkerDeath, EntityType.JUNKER);

function EXILE_M:PotheadDeath(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Pothead") then
			sound:Play(SoundEffect.SOUND_BOIL_HATCH,1,0,false,0.6)
			sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
	--local blood2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_EXPLOSION, 0, entity.Position, Vector(0,0), entity)
	local roll = math.random(1,10)
	if roll > 5 then
	EntityNPC.ThrowSpider(entity.Position, entity, Vector(entity.Position.X - 60 + entity:GetDropRNG():RandomInt(121), entity.Position.Y - 60 + entity:GetDropRNG():RandomInt(121)), false, 0.0)
	end
	local blood4 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, entity.Position, Vector(0,0), entity)
		for i = 1, 7 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			local offsety = math.random(-20,-10)
			local offsetx = math.random(-20,20)
			blood.SpriteScale = Vector(0.8,0.8)
			blood.PositionOffset = Vector(offsetx,offsety)
			end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.PotheadDeath, EntityType.POTHEAD);

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
			local attacktime = math.random(1,420)
			if (attacktime > 408 and target.Position:Distance(entity.Position) > 110) or (not entity.Pathfinder:HasPathToPos(target.Position, true) and target.Position:Distance(entity.Position) > 110) then
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
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	entity.Velocity = Vector(0,0)
	Game():ShakeScreen(7,7)
			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,6),entity):ToProjectile()
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-6),entity):ToProjectile()
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(6,0),entity):ToProjectile()
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-6,0),entity):ToProjectile()
	
	
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
	DotChaseTarg(0.5, 3, entity, 0.85, 75)
	
	if data.GridCountdown == nil then data.GridCountdown = 0 end	
    

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
	if player.Position:Distance(entity.Position + Vector(0,-25)) < 45 then
	music:Fadeout()
	sound:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT,1.45,0,false,1.1)
	player:GetSprite():ReplaceSpritesheet(12, "gfx/ui/none.png")
	player:GetSprite():ReplaceSpritesheet(13, "gfx/ui/none.png")
    player:GetSprite():LoadGraphics()
	player:Kill()
	sound:Play(SoundEffect.SOUND_SQUISH,1.45,0,false,1)

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
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	
	local target = entity:GetPlayerTarget()
	local data = entity:GetData()
	if data.GridCountdown == nil then data.GridCountdown = 0 end
	
	if entity.State == 0 then
	if not sound:IsPlaying(Sounds.INSECTSWARMDUMMY) then
	entity:PlaySound(Sounds.INSECTSWARMDUMMY,1,0,false,1)
	end
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES

		if not sprite:IsPlaying("FlyUp") then
		sprite:Play("FlyUp", true)
		end
		if sprite:IsEventTriggered("Fly") then
			entity.State = 2
		end
	elseif entity.State == 2 then
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	
	if not sound:IsPlaying(Sounds.INSECTSWARMDUMMY) then
	entity:PlaySound(Sounds.INSECTSWARMDUMMY,1,0,false,1)
	end

	entity.Velocity = (target.Position - entity.Position):Normalized() * 1 * 7.8
	
	if entity:IsFrame(2, 0) then
		if not sprite:IsPlaying("Flying") then
		sprite:Play("Flying", true)
		end
		--
			if entity.Position:Distance(target.Position) < 50 then
			entity.State = 3
			else
			entity.State = 2
			end
		end
	elseif entity.State == 3 then
	if not sprite:IsPlaying("JumpDown") and not sprite:IsFinished("JumpDown") then
	entity:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2,1,0,false,1)
	sprite:Play("JumpDown", false)
	end
		if sprite:IsEventTriggered("impact") then
		entity:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 0.7)
		entity:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE,1,0,false,1)
		entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,9),entity):ToProjectile()
			tear5:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
			tear5:GetSprite():LoadGraphics()
			tear5:GetData().StoneProj = true
			
			local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-9),entity):ToProjectile()
			tear6:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
			tear6:GetSprite():LoadGraphics()
			tear6:GetData().StoneProj = true
			
			local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(9,0),entity):ToProjectile()
			tear7:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
			tear7:GetSprite():LoadGraphics()
			tear7:GetData().StoneProj = true
			
			local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-9,0),entity):ToProjectile()
			tear8:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/clockwork2/junk_bullets.png")
			tear8:GetSprite():LoadGraphics()
			tear8:GetData().StoneProj = true
			entity.Velocity = Vector(0,0)
		end
		if sprite:IsFinished("JumpDown") then
		entity.State = 4
		end
	elseif entity.State == 4 then
	if not sprite:IsPlaying("Hop") then
	sprite:Play("Hop", false)
	elseif sprite:IsPlaying("Hop") then
	
	if sprite:IsEventTriggered("hop") then
	if entity.Pathfinder:HasPathToPos(target.Position, true) then
	DotChaseTarg(7, 20, entity, 0.85, 75)
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	else
	entity.Velocity = (target.Position - entity.Position):Normalized() * 1 * 7.8
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	end
	
	end
	
	if sprite:IsEventTriggered("Land") then
	entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
	entity:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1.05, 0, false, 1)
	entity.Velocity = Vector(0,0)
	end
	
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.PeriwinkleUpdate, EntityType.PERIWINKLE)

function EXILE_M:PeriwinkleGlassUpdate(entity)
	local room = Game():GetRoom()
	local player = Isaac.GetPlayer(0)
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	if entity.Variant == Isaac.GetEntityVariantByName("Periwinkle Glass Dud") then
		entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity.DepthOffset = -150
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", false)
	end
	end
	if entity.Variant == Isaac.GetEntityVariantByName("Periwinkle Glass") then
	
	entity.Velocity = Vector(0,0)
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity.DepthOffset = -150
	
	if data.Spawn == nil then data.Spawn = false end
	if data.GlassState == nil then data.GlassState = 0 end
	if entity.State == 0 then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", false)
	end
	if data.Spawn == true then
	entity.State = 2
	end
	elseif entity.State == 2 then
	if not sprite:IsPlaying("Break") then
	sprite:Play("Break", false)
	elseif sprite:IsEventTriggered("spawn") then
		Game():ShakeScreen(8,8)
		--sound:Play(Sounds.SPLASH_WATER,1,0,false,1)
		entity:PlaySound(Sounds.GLASSBREAK, 0.90, 0, false, 1)
			Isaac.Spawn(EntityType.PERIWINKLE, Isaac.GetEntityVariantByName("Periwinkle"), 0, entity.Position, Vector(0,0), nil)
	elseif sprite:IsEventTriggered("pit") then
	entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	--GLASSPANELBROKEN:Spawn(room:GetGridIndex(entity.Position), true, false)
	elseif sprite:IsFinished("Break") then
	entity.State = 3
	elseif entity.State == 3 then
	if not sprite:IsPlaying("IdleBroken") then
	sprite:Play("IdleBroken", false)
	end
	end
	end
	
	if room:IsClear() and entity.State == 0 then
	GLASSPANELDORMANT:Spawn(room:GetGridIndex(entity.Position), true, false)
	end
	if room:IsClear() and (entity.State == 2 or entity.State == 2) then
	GLASSPANELBROKEN:Spawn(room:GetGridIndex(entity.Position), true, false)
	end

	
	end

end
				
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.PeriwinkleGlassUpdate, EntityType.PERIWINKLE)

function EXILE_M:PerrywinkleGlassRoll()
	local vials = Isaac.FindByType(EntityType.PERIWINKLE, Isaac.GetEntityVariantByName("Periwinkle Glass"), -1, false, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		local edata = tear:GetData()
		if edata.Spawn == false then
		local roll = math.random(1,18)
		if roll > 15 then
		edata.Spawn = true
		else
		
		end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.PerrywinkleGlassRoll)

function EXILE_M:GetSpecialShots()
	local player = Isaac.GetPlayer(0)
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, true, false)) do
			local data = entity:GetData()
			local projectile = entity:ToProjectile()
			if entity.Type == EntityType.ENTITY_PROJECTILE then 
			
			if data.StoneProj == true then
				projectile.SpriteRotation = projectile.SpriteRotation + 13
				if (projectile.Height >= -5 or projectile:CollidesWithGrid()) and not projectile:GetData().GroundHit then
						projectile:GetData().GroundHit = true
				--	sound:Stop(Sounds.FALLINGWHISTLE)
				--sound:Play(SoundEffect.SOUND_BOIL_HATCH,1,0,false,0.4)
				sound:Play(SoundEffect.SOUND_ROCK_CRUMBLE,0.75,0,false,1.1)
			
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
		if data.SlowFallProj == true then
		projectile.Velocity = projectile.Velocity * 0.87
		end
		if data.GrowProj == true then
		if projectile:IsFrame(6,0) then
		projectile.Scale = projectile.Scale * 1.03
		end
		end
		if data.GrenadeProj == true then
		projectile.SpriteRotation = projectile.SpriteRotation + 26
				if (projectile.Height >= -5 or projectile:CollidesWithGrid()) and not projectile:GetData().GroundHit then
						projectile:GetData().GroundHit = true
				--	sound:Stop(Sounds.FALLINGWHISTLE)
				--sound:Play(SoundEffect.SOUND_BOIL_HATCH,1,0,false,0.4)
				sound:Play(SoundEffect.SOUND_BLOODBANK_SPAWN,0.75,0,false,0.7)
			
			local blood3 = Isaac.Spawn(Isaac.GetEntityTypeByName("Toxic Mist"), Isaac.GetEntityVariantByName("Toxic Mist"), 0, entity.Position, Vector(0,0), entity)
			blood3:GetData().TimeOut = 8
			
			local blood2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, entity.Position, Vector(0,0), entity)
				for i = 1, 3 do
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, entity.Position, Vector(0,0), entity)
			
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

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, EXILE_M.GetSpecialShots)

end

if StageAPI and StageAPI.Loaded then
    LoadCode()
else
    if not StageAPI then
        StageAPI = {Loaded = false, ToCall = {}}
    end

    StageAPI.ToCall[#StageAPI.ToCall + 1] = LoadCode
end


EXILE_M.bork.NonExistantFunctionThatIsCalledToIntentionallyErrorThis()
