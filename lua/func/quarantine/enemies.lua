

-- enemies

EntityType.JAILDOOR = Isaac.GetEntityTypeByName("Quarantine Jail Door")
EntityType.WALNUT = Isaac.GetEntityTypeByName("Walnut")
EntityType.WALNUTBRAIN = Isaac.GetEntityTypeByName("Walnut Brain")
EntityType.DEEPSMILE = Isaac.GetEntityTypeByName("Deepsmile")

EntityType.TOXER = Isaac.GetEntityTypeByName("Toxer")

EntityType.GASSY = Isaac.GetEntityTypeByName("Gassy")




EntityType.SIREN = Isaac.GetEntityTypeByName("Siren (Top Left)")

EntityType.JAILOPENBUTTON = Isaac.GetEntityTypeByName("Jail Open Button")

EntityType.CONVEYORBELTGAPER = Isaac.GetEntityTypeByName("Conveyor Belt Gaper")

EntityType.BAGTAGTABLE = Isaac.GetEntityTypeByName("Bagtag Stretcher")
EntityType.BAGTAG = Isaac.GetEntityTypeByName("Bagtag")

EntityType.TRANSPLANT = Isaac.GetEntityTypeByName("Transplant") --- used for many enemies

-- toxic mist
EntityType.TOXICMIST = Isaac.GetEntityTypeByName("Toxic Mist")

local function LoadCode()

function EXILE_M:MadmanUpd(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Madman") then
        local player = Isaac.GetPlayer(0)
        local sprite = entity:GetSprite()

        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND

        local target = entity:GetPlayerTarget()
        local data = entity:GetData()

        if data.GridCountdown == nil then
            data.GridCountdown = 0
            data.Relapse = 0
            data.State = 0
        end

        if data.State == 0 then
            EXILE_M.AnimateWalkFrame(sprite, entity.Velocity, {Up = "WalkUp", Down = "WalkDown", Horizontal = "WalkHori"})
            DotChaseTarg(0.5, 4, entity, 0.85, 75)
            if entity:IsFrame(35,0) then
                local roll = math.random(1,10)
                if roll > 7 then
                    data.State = 2
                else
                    data.State = 0
                end
            end

            if entity.Child then
                entity.Child:GetData().PsychoState = 0
            end

        elseif data.State == 2 then
            entity.Velocity = Vector(0,0)
            if not sprite:IsPlaying("Psycho") then
                entity:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_1,1,0,false,1)
                sprite:Play("Psycho", false)
            elseif sprite:GetFrame() == 10 then
                if entity.Child then
                    entity.Child:GetData().PsychoState = 2
                end
            end
            if sprite:IsFinished("Psycho") then
                data.State = 0
            end
        elseif data.State == 4 then
            EXILE_M.AnimateWalkFrame(sprite, entity.Velocity, {Up = "WalkUp2", Down = "WalkDown2", Horizontal = "WalkHori2"})
            DotChaseTarg(1, 4, entity, 0.85, 75)
        end
    end
    if entity.Variant == Isaac.GetEntityVariantByName("Madman Tear") then
        local player = Isaac.GetPlayer(0)
        local sprite = entity:GetSprite()

        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

        local target = entity:GetPlayerTarget()
        local data = entity:GetData()

        if data.Dirvect == nil then
            data.pos1 = 0
            data.Dirvect = 0
        end


        if data.PsychoState == nil then
            data.PsychoState = 0
            data.SpawnerPos = Vector(0,0)
            data.SpeedMultiplier = 0.98
            data.SlipperinessMultiplier = 0.88

            if entity.Parent then
                data.SpawnerEnt = entity.Parent
            end
        end

        if entity.Parent:IsDead() then
            entity:Die()
        end

        if data.PsychoState == 0 then
            if entity.Position:Distance(entity.Parent.Position) > 50 then
                entity.Velocity = (entity.Parent.Position - entity.Position):Normalized() * 2.5
            end
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", true)
            end
        elseif data.PsychoState == 2 then
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", true)
            end

            --	data.pos1 = entity.Position - entity.Parent.Position
            --	data.Dirvect = data.pos1:GetAngleDegrees()

            --	if entity:IsFrame(4,0) then
            --	local BloodLaser = EntityLaser.ShootAngle(5, entity.Position, data.Dirvect - 180,
            --	8, Vector(0,-23), entity)
            --BloodLaser.DepthOffset = 45;
            --BloodLaser.EndPoint = entity.Parent.Position

            --end

            entity.Velocity = entity.Velocity * data.SlipperinessMultiplier + (target.Position-entity.Position):Resized(data.SpeedMultiplier)
            if entity.Position:Distance(target.Position) < 70 then
                data.PsychoState = 3
            end
        elseif data.PsychoState == 3 then
            entity.Velocity = entity.Velocity / 2
            if not sprite:IsPlaying("Burst") then
                sprite:Play("Burst", true)
            end

            if sprite:IsEventTriggered("burst") then
                entity.Parent:GetData().State = 4
                local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, Vector(0,0), entity)
                blood.PositionOffset = Vector(0,-8)
                sound:Play(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,1)
                for i = 1, math.random(11, 17) do
                    local p = Isaac.Spawn(9, 0, 0, entity.Position, Vector.FromAngle(math.random(0, 360)) * (math.random(200, 2400) * 0.012), entity):ToProjectile()
                    p.Scale = p.Scale * math.random(40, 180) * 0.01
                    p.FallingSpeed = -6
                    local pData = p:GetData()
                    pData.SlowFallProj = true
                end
                entity:PlaySound(SoundEffect.SOUND_MONSTER_ROAR_0,1,0,false,1)
                entity:Remove()

            end

        end
    end
end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.MadmanUpd, EntityType.TRANSPLANT)

EXILE_M:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local ent = Isaac.FindByType(EntityType.TRANSPLANT, Isaac.GetEntityVariantByName("Madman"), -1, false, false)
    for _, entity in ipairs(ent) do
        local sprite = entity:GetSprite()
		local data = entity:GetData()
		if sprite:IsPlaying("Appear") then
			if sprite:GetFrame() == 3 then
			local tear = Isaac.Spawn(EntityType.TRANSPLANT,Isaac.GetEntityVariantByName("Madman Tear"),0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
			tear.Parent = entity
			tear:GetData().SpawnerEnt = entity
			entity.Child = tear
			end
		end
	end	
end)

function EXILE_M:GassyUpdate(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Gassy") then
        local player = Isaac.GetPlayer(0)
        local sprite = entity:GetSprite()

        local target = entity:GetPlayerTarget()
        local data = entity:GetData()

        if sprite:IsEventTriggered("Shoot") then
            local blood3 = Isaac.Spawn(Isaac.GetEntityTypeByName("Toxic Mist"), Isaac.GetEntityVariantByName("Toxic Mist"), 0, entity.Position, Vector(0,0), entity)
            blood3:GetData().TimeOut = 8

        end

    end
end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.GassyUpdate, EntityType.GASSY)


function EXILE_M:ToxerUpdate(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Toxer") then
        local player = Isaac.GetPlayer(0)
        local sprite = entity:GetSprite()


        local target = entity:GetPlayerTarget()
        local data = entity:GetData()
        if data.GridCountdown == nil then data.GridCountdown = 0 end

        if entity.State == 0 then
            entity:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            DotChaseTarg(0.5, 4, entity, 0.85, 75)
            if entity:IsFrame(37,0) then
                local roll = math.random(1,10)
                if roll > 7 then
                    entity.State = 2
                else
                    entity.State = 0
                end
            end
        elseif entity.State == 2 then
            entity.Velocity = Vector(0,0)
            entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
            if not sprite:IsPlaying("Attack") then
                sprite:Play("Attack", false)
            elseif sprite:IsPlaying("Attack") then
                if sprite:GetFrame() == 8 then
                    local Projectile = Game():Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_PUKE, entity.Position, ((-(entity.Position - target.Position):Resized(8)):Rotated(math.random(-10,10)) * (math.random(111, 150) / 100)), entity, 0, 0):ToProjectile()
                    Projectile.FallingSpeed = 0.05
                    Projectile.FallingAccel = 0.1
                    Projectile.Scale = 1.5
                    Projectile.Height = -22
                    Projectile.DepthOffset = 43
                    Projectile.CollisionDamage = 0.5
                    Projectile:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/captainslog/quarantine/grenade.png")
                    Projectile:GetSprite():LoadGraphics()
                    Projectile:GetData().GrenadeProj = true
                    entity:PlaySound(SoundEffect.SOUND_GHOST_SHOOT,1,60,false,1)

                    --
                    --

                end
            end
            if sprite:IsFinished("Attack") then
                entity.State = 0
            end
        end
    end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ToxerUpdate, EntityType.TOXER)


function EXILE_M:ToxicMistUpd(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Toxic Mist") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()

        if data.TimeOut == nil then data.TimeOut = 12 end
        if data.TimesPlayed == nil then data.TimesPlayed = 0 end
        if data.Poisoning == nil then data.Poisoning = false end

        data.Poisoning = true

        EXILE_M.RoomToxic = true

        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        entity.DepthOffset = 60

        --entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        if entity.State == 0 then
            if not sprite:IsPlaying("Idle") then
                if data.TimesPlayed < data.TimeOut then
                    sprite:Play("Idle", true)
                else
                    entity.State = 2
                end
            elseif sprite:IsPlaying("Idle") then

                if sprite:IsEventTriggered("Next") then
                    data.TimesPlayed = data.TimesPlayed + 1
                end

            end
        elseif entity.State == 2 then
            if not sprite:IsPlaying("Die") and not sprite:IsFinished("Die") then
                sprite:Play("Die")
            end

            if sprite:IsFinished("Die") then
                entity:Remove()
            end
        end

    end

end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ToxicMistUpd, EntityType.TOXICMIST)


function EXILE_M:TransplantUpd(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Transplant") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()

        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND

        if entity.State == 0 then
            entity.State = 2
        end


        if entity.State == 2 then
            if not sprite:IsPlaying("Move") then
                sprite:Play("Move")
            end
            if sprite:GetFrame() == 5 then
                if entity.Position:Distance(target.Position) < 30 then
                    local avoidPos = Isaac.GetFreeNearPosition(target.Position + (target.Position - entity.Position):Normalized() * 185, 13)
                    DotChaseTarg(7, 20, entity, 0.85, 75)
                else
                    local jumpPos = Isaac.GetFreeNearPosition(entity.Position, 270)
                    DotChaseTarg(7, 20, entity, 0.85, 75)
                end
            end
            if sprite:GetFrame() == 13 then
                entity.Velocity = Vector(0,0)
                entity:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,1)
            end

            if sprite:GetFrame() == 23 then
                local roll = math.random(1,9)
                if roll > 5 then
                    entity.State = 3
                end
            end

        elseif entity.State == 3 then
            if not sprite:IsPlaying("Shoot") then
                sprite:Play("Shoot")
            end

            if sprite:GetFrame() == 17 then
                sound:Play(SoundEffect.SOUND_LITTLE_SPIT,1.1,0,false,1)
                for i = -16, 16, 16 do
                    local p = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, entity.Position, (entity:GetPlayerTarget().Position - entity.Position):Resized(7.5):Rotated(i):Normalized() * 8.7, entity):ToProjectile()
                    p.Height = -50
                end
            end
            if sprite:IsFinished("Shoot") then
                entity.State = 2
            end


        end
    end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.TransplantUpd, EntityType.TRANSPLANT)


DORMANTSTRETCHER = StageAPI.CustomGrid("Bagtag Table", GridEntityType.GRID_ROCKB, nil, "gfx/quarantine_bagtag.anm2", "IdleNoBagShadow")

function EXILE_M:BagTagTableUpd(entity)
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer(0)
    local data = entity:GetData()
    local sprite = entity:GetSprite()
    if entity.Variant == Isaac.GetEntityVariantByName("Bagtag Stretcher Dud") then
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        entity.DepthOffset = -6
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

        if not sprite:IsPlaying("IdleNoBagShadow") then
            sprite:Play("IdleNoBagShadow", false)
        end
    end
    if entity.Variant == Isaac.GetEntityVariantByName("Bagtag Stretcher") then

        entity.Velocity = Vector(0,0)
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity.DepthOffset = -6

        if data.Spawn == nil then data.Spawn = false end
        if data.Spawned == nil then data.Spawned = false end
        if data.SpawnedGrid == nil then data.SpawnedGrid = false end
        if entity.State == 0 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", false)
            end
            if data.Spawn == true and data.Spawned == false and not room:IsClear() then
                entity.State = 2
                data.Spawned = true
            end
        elseif entity.State == 2 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            if not sprite:IsPlaying("TableSpawn") then
                sprite:Play("TableSpawn", false)
            elseif sprite:GetFrame() == 40 then
                entity:PlaySound(SoundEffect.SOUND_SKIN_PULL,1,0,false,1)
                Game():ShakeScreen(5,5)
            elseif sprite:GetFrame() == 61 then
                entity:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,1)
            elseif sprite:IsEventTriggered("Spawn") then
                local bagtag = Isaac.Spawn(EntityType.BAGTAG, Isaac.GetEntityVariantByName("Bagtag"), 0, entity.Position, Vector(0,0), nil)
                bagtag:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            elseif sprite:GetFrame() == 80 then
                entity.State = 3
            elseif entity.State == 3 then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                if not sprite:IsPlaying("IdleNoBag") then
                    sprite:Play("IdleNoBag", false)
                end

            end
        end

        if room:IsClear() and entity.State == 0 and not data.SpawnedGrid then
            DORMANTSTRETCHER:Spawn(room:GetGridIndex(entity.Position), true, false)
            data.SpawnedGrid = true
        end

        if room:IsClear() and entity.State == 3 and not data.SpawnedGrid then
            DORMANTSTRETCHER:Spawn(room:GetGridIndex(entity.Position), true, false)
            data.SpawnedGrid = true
        end


    end

end

				
EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BagTagTableUpd, EntityType.BAGTAGTABLE)

function EXILE_M:BagtagUpd(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Bagtag") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()

        if data.GridCountdown == nil then data.GridCountdown = 0 end


        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity.DepthOffset = 4

        if room:IsClear() then
            entity:BloodExplode()
            entity:Remove()
        end

        if entity:IsFrame(2, 0) then
            if entity:CollidesWithGrid() or data.GridCountdown > 0 then
                DotChaseTarg(0.8, 4, entity, 0.85, 75)

                if data.GridCountdown < 0 then
                    data.GridCountdown = 30
                else
                    data.GridCountdown = data.GridCountdown - 1
                end
            else
                DotChaseTarg(0.8, 4, entity, 0.85, 75)
                entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            end
        end
        if not sprite:IsPlaying("IdleBodyBag") then
            sprite:Play("IdleBodyBag", false)
        end


    end

end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.BagtagUpd, EntityType.BAGTAG)

function EXILE_M:StretcherRoll()
	local vials = Isaac.FindByType(EntityType.BAGTAGTABLE, Isaac.GetEntityVariantByName("Bagtag Stretcher"), -1, false, false) -- Select a vial out of the ones in the room currently
		for _, tear in ipairs(vials) do
		local edata = tear:GetData()
		if edata.Spawn == false then
		local roll = math.random(1,12)
		if roll > 6 then
		edata.Spawn = true
		else
		
		end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EXILE_M.StretcherRoll)	

function EXILE_M:JailDoorUpdate(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Quarantine Jail Door") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        if data.Finished == nil then data.Finished = false end
        if data.Open == nil then data.Open = false end
        if data.Opened == nil then data.Opened = false end

        entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity.DepthOffset = -120


        if entity.State == 0 then
            if not sprite:IsPlaying("Closed") then
                sprite:Play("Closed", false)
            end

            if data.Open == true and data.Opened == false then
                entity.State = 2
                data.Opened = true
            end


        end

        if entity.State == 2 then
            if not room:IsClear() then
                if not sprite:IsPlaying("Open") and not sprite:IsPlaying("Close") then
                    sprite:Play("Open", false)

                end

                if sprite:IsPlaying("Open") and sprite:GetFrame() == 4 then
                    entity:PlaySound(Isaac.GetSoundIdByName("Portcullis 2"), 1, 0, false, 1)
                    game:ShakeScreen(9,9)
                end


                if sprite:IsPlaying("Open") and sprite:GetFrame() > 11 then
                    if entity:IsFrame(10,0) then
                        local gaper = Isaac.Spawn(EntityType.ENTITY_GAPER, 1, 0, entity.Position, Vector(0,0), entity)
                        gaper:SetColor(Color(0,0,0,0.1,0,0,0),6,0,true,false)
                        gaper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    end
                end
                if sprite:IsFinished("Open") then
                    entity.State = 3
                end
            end
        end

        if entity.State == 3 then
            if not sprite:IsPlaying("Close") then
                sprite:Play("Close", false)
            end

            if sprite:IsFinished("Close") then
                entity.State = 0
            end

        end



    end
end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.JailDoorUpdate, EntityType.JAILDOOR)

function EXILE_M:WalnutUpdate(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Walnut") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        if data.SlipperinessMultiplier == nil then data.SlipperinessMultiplier = 0.85 end
        if data.SpeedMultiplier == nil then data.SpeedMultiplier = 0.95 end


        if entity.State == 0 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            entity.Velocity = entity.Velocity * data.SlipperinessMultiplier + (target.Position-entity.Position):Resized(data.SpeedMultiplier)
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", false)
            end

            if entity:IsFrame(18,0) then
                local roll = math.random(1,12)
                if roll > 9 then
                    entity.State = 2
                else

                end
            end

        elseif entity.State == 2 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            entity.Velocity = Vector(0,0)
            if not sprite:IsPlaying("Shoot") then
                sprite:Play("Shoot", false)
            elseif sprite:IsPlaying("Shoot") then
                if sprite:IsEventTriggered("shoot") then
                    sound:Play(SoundEffect.SOUND_SKIN_PULL,1,0,false,1)
                    local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,7),entity):ToProjectile()
                    local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-7),entity):ToProjectile()
                    local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,0),entity):ToProjectile()
                    local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,0),entity):ToProjectile()
                end
            end
            if sprite:IsFinished("Shoot") then
                entity.State = 0
            end
        elseif entity.State == 3 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            entity.Velocity = Vector(0,0)
            if not sprite:IsPlaying("Brain") then
                sprite:Play("Brain", false)
            elseif sprite:IsPlaying("Brain") then
                if sprite:IsEventTriggered("shoot") then
                    sound:Play(SoundEffect.SOUND_SKIN_PULL,1,0,false,1)
                    sound:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)


                    local brain = Isaac.Spawn(EntityType.WALNUTBRAIN, Isaac.GetEntityVariantByName("Walnut Brain"), 0,entity.Position + Vector(-27,0), Vector(0,0), entity)
                    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0,entity.Position, Vector(0,0), entity)
                    --creep:SetColor(Color(0,20,0,1,0,0,0),0,0,false,false)
                    local effect = creep:ToEffect()
                    effect.Scale = 2

                    brain:GetData().Appear = true
                    --brain.DepthOffset = 55
                    brain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                end
            end
            if sprite:IsFinished("Brain") then
                entity.State = 4
            end
        elseif entity.State == 4 then
            entity:GetSprite().FlipX = (entity.Position.X > target.Position.X)
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            entity.Velocity = entity.Velocity * data.SlipperinessMultiplier + (target.Position-entity.Position):Resized(data.SpeedMultiplier)
            if not sprite:IsPlaying("IdleEmpty") then
                sprite:Play("IdleEmpty", false)
            end
        end
    end

end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.WalnutUpdate, EntityType.WALNUT)

function EXILE_M:WalnutBrainUpdate(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Walnut Brain") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        if data.Appear == nil then data.Appear = false end
        if data.SlipperinessMultiplier == nil then data.SlipperinessMultiplier = 0.93 end
        if data.SpeedMultiplier == nil then data.SpeedMultiplier = 1 end
        if data.AttackType == nil then data.AttackType = 0 end


        if entity.State == 0 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            if data.Appear == true then
                if not sprite:IsPlaying("Appear") then
                    sprite:Play("Appear", false)
                end
                if sprite:IsFinished("Appear") then
                    entity.State = 3
                end
            else
                entity.State = 3
            end
        end

        if entity.State == 3 then
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", false)
            end

            if entity:IsFrame(35,0) then
                sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                if data.AttackType == 0 then
                    local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,7),entity):ToProjectile()
                    local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(0,-7),entity):ToProjectile()
                    data.AttackType = 1
                elseif data.AttackType == 1 then
                    local tear7 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(7,0),entity):ToProjectile()
                    local tear8 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(0,0) ,Vector(-7,0),entity):ToProjectile()
                    data.AttackType = 0
                end
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

            entity.Velocity = closestDir:Resized(3.5)
        end

    end
end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.WalnutBrainUpdate, EntityType.WALNUTBRAIN)


function EXILE_M:SummonBrain(entity)
if entity.Variant == Isaac.GetEntityVariantByName("Walnut") then
local npc = entity:ToNPC()
	if entity.HitPoints < (entity.MaxHitPoints * 0.65) then
	if npc.State == 0 or npc.State == 2 then
	
	npc.State = 3
	
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.SummonBrain, EntityType.WALNUT)

function EXILE_M:ConveyorContentUpd(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt Gaper") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        if data.spawned == nil then data.spawned = 0 end

        if not sprite:IsPlaying("Idle") then
            sprite:Play("Idle", false)
        end

        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        if data.spawned == 0 then
            if sprite:IsEventTriggered("spawn") then
                data.spawned = 1
                local gaper = Isaac.Spawn(EntityType.ENTITY_GAPER,0,0,entity.Position + Vector(0,51) ,Vector(0,0),nil)
                entity:Remove()
            end
        end

    end

    if entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt Pickup (Down)") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        if data.spawned == nil then data.spawned = 0 end

        if not sprite:IsPlaying("Idle") then
            sprite:Play("Idle", false)
        end

        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)

        if data.spawned == 0 then
            if sprite:IsEventTriggered("spawn") then
                data.spawned = 1
                local gaper = Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,entity.Position + Vector(0,31) ,Vector(0,0),nil)
                entity:Remove()
            end
        end

    end

    if entity.Variant == Isaac.GetEntityVariantByName("Conveyor Belt Pickup (Right)") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        if data.spawned == nil then data.spawned = 0 end

        if not sprite:IsPlaying("Idle") then
            sprite:Play("Idle", false)
        end

        entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)

        if data.spawned == 0 then
            if sprite:IsEventTriggered("spawn") then
                data.spawned = 1
                local gaper = Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,entity.Position + Vector(31,0) ,Vector(0,0),nil)
                entity:Remove()
            end
        end

    end

end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.ConveyorContentUpd, EntityType.CONVEYORBELTGAPER)

function EXILE_M:DeepsmileUpd(entity)
    if entity.Variant == Isaac.GetEntityVariantByName("Deepsmile") then
        local game = Game()
        local room = game:GetRoom()
        local data = entity:GetData()
        local player = Isaac.GetPlayer(0)
        local target = entity:GetPlayerTarget()
        local sprite = entity:GetSprite()
        entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)

        if entity.State == 0 then
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
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

            entity.Velocity = closestDir:Resized(3.7)
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle", false)
            end

            if entity:IsFrame(13,0) then
                local roll = math.random(1,12)
                if roll > 7 then
                    entity.State = 2
                else

                end
            end

        elseif entity.State == 2 then
            --entity.Velocity = entity.Velocity * data.SlipperinessMultiplier + (target.Position-entity.Position):Resized(data.SpeedMultiplier)
            if not sprite:IsPlaying("Shoot") then
                sprite:Play("Shoot", false)
            elseif sprite:IsPlaying("Shoot") then
                if sprite:IsEventTriggered("smile") then
                    sound:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR,1,0,false,0.8)
                end

                if sprite:GetFrame() == 35 then
                    sound:Play(SoundEffect.SOUND_SKIN_PULL,1,0,false,1)
                end

                if sprite:GetFrame() == 69 then
                    sound:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,1)
                end

                if sprite:IsEventTriggered("shootr") then
                    sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                    local tear5 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(11,0) ,Vector(7,0),entity):ToProjectile()
                    tear5.Scale = 1
                    tear5.CollisionDamage = 1
                    tear5.ProjectileFlags = ProjectileFlags.WIGGLE
                    tear5.FallingAccel = -0.003
                    tear5.Height = -35

                end
                if sprite:IsEventTriggered("shootl") then
                    sound:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                    local tear6 = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,0,0,entity.Position + Vector(-11,0) ,Vector(-7,0),entity):ToProjectile()
                    tear6.Scale = 1
                    tear6.CollisionDamage = 1
                    tear6.ProjectileFlags = ProjectileFlags.WIGGLE
                    tear6.FallingAccel = -0.003
                    tear6.Height = -35

                end
            end
        end
        if sprite:IsFinished("Shoot") then
            entity.State = 0
        end

    end
end


EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.DeepsmileUpd, EntityType.DEEPSMILE)

--- Decorations

function EXILE_M:SirensUpdate(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Siren (Top Left)") or
	entity.Variant == Isaac.GetEntityVariantByName("Siren (Top Right)") or
	entity.Variant == Isaac.GetEntityVariantByName("Siren (Bottom Left)") or
	entity.Variant == Isaac.GetEntityVariantByName("Siren (Bottom Right)") then
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	entity.SpriteScale = Vector(1.1, 1.1)
		entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local sprite = entity:GetSprite()
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	if data.Blairing == nil then data.Blairing = false end
	if data.Breach == nil then data.Breach = false end
	
	if not room:IsClear() and data.Blairing == true then
	if not sprite:IsPlaying("Blairing") then
	sprite:Play("Blairing", true)
	end
	else
	sprite:Play("Idle", true)
	end
	
	
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.SirensUpdate, EntityType.SIREN)

--

local AlertEff = Sprite()
AlertEff:Load("gfx/alert_effect.anm2", false)

function EXILE_M:onRenderAlert()
		if not AlertEff:IsFinished("Idle") then
		AlertEff:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderAlert)

function EXILE_M:alertRenderUpd(player)
	AlertEff:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.alertRenderUpd);


function EXILE_M:removeOverlays(player)
	if game:GetFrameCount() == 1 then
		AlertEff:Stop()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.removeOverlays);

function EXILE_M:JailButtonUpd(entity)
	if entity.Variant == Isaac.GetEntityVariantByName("Jail Open Button (Dummy)") then
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity.DepthOffset = -140
	end
	if entity.Variant == Isaac.GetEntityVariantByName("Jail Open Button") then
	local game = Game()
	local room = game:GetRoom()
	local data = entity:GetData()
	local player = Isaac.GetPlayer(0)
	local target = entity:GetPlayerTarget()
	local sprite = entity:GetSprite()
	entity:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
	
	entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
	entity.DepthOffset = -140
	
	if data.Switching == nil then data.Switching = false end
	if data.Switched == nil then data.Switched = false end
	
	if not room:IsClear() then
	if not data.Switched and not data.Switching then
	if not sprite:IsPlaying("Off") then
	sprite:Play("Off", false)
	end
	if player.Position:Distance(entity.Position) < 21 then
	data.Switching = true
	end
	end
	
	if data.Switching == true and not data.Switched then
	if not sprite:IsPlaying("Switched") and not sprite:IsFinished("Switched") then
	sprite:Play("Switched", false)
	elseif sprite:IsFinished("Switched") then
	data.Switched = true
	end
	end
	if data.Switched and data.Switching then
	if not sprite:IsPlaying("On") then
	sprite:Play("On", false)
	end
	end

	if sprite:IsEventTriggered("Alert") then
		local doors = Isaac.FindByType(EntityType.JAILDOOR, Isaac.GetEntityVariantByName("Quarantine Jail Door"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, door in ipairs(doors) do
		local ddata = door:GetData()
		ddata.Open = true
		end
		
		
		local sirens1 = Isaac.FindByType(EntityType.SIREN, Isaac.GetEntityVariantByName("Siren (Top Left)"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, siren in ipairs(sirens1) do
		local sdata = siren:GetData()
		sdata.Blairing = true
		end
		
		local sirens2 = Isaac.FindByType(EntityType.SIREN, Isaac.GetEntityVariantByName("Siren (Top Right)"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, siren in ipairs(sirens2) do
		local sdata = siren:GetData()
		sdata.Blairing = true
		end
		
		local sirens3 = Isaac.FindByType(EntityType.SIREN, Isaac.GetEntityVariantByName("Siren (Bottom Left)"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, siren in ipairs(sirens3) do
		local sdata = siren:GetData()
		sdata.Blairing = true
		end
		
		local sirens4 = Isaac.FindByType(EntityType.SIREN, Isaac.GetEntityVariantByName("Siren (Bottom Right)"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, siren in ipairs(sirens4) do
		local sdata = siren:GetData()
		sdata.Blairing = true
		end
		

		
	end
		if sprite:IsEventTriggered("BLEEP") then
	sound:Play(Sounds.ALARM1,1.45,0,false,1)
	StageAPI.PlayTextStreak("BREACH!", nil, nil, nil, "gfx/ui/cursepaper_quarantine.png", Vector(124, 14), EXILE_M.CurseFont, nil, KColor(0, 0, 0, 1))
	Game():ShakeScreen(11,11)
		AlertEff:Reload()
		AlertEff:LoadGraphics()
		AlertEff:Play("Idle", true)
	end
	if sprite:IsEventTriggered("Delete") then
			local button = Isaac.Spawn(EntityType.JAILOPENBUTTON,Isaac.GetEntityVariantByName("Jail Open Button (Dummy)"),0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
		entity:Remove()
	end
	
	else
	if not sprite:IsPlaying("On") then
	sprite:Play("On", false)
	end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, EXILE_M.JailButtonUpd, EntityType.JAILOPENBUTTON)

StageAPI.AddEntityPersistenceData({Type = EntityType.SIREN, Variant = 23520})
StageAPI.AddEntityPersistenceData({Type = EntityType.SIREN, Variant = 23521})
StageAPI.AddEntityPersistenceData({Type = EntityType.SIREN, Variant = 23522})
StageAPI.AddEntityPersistenceData({Type = EntityType.SIREN, Variant = 23523})

StageAPI.AddEntityPersistenceData({Type = EntityType.BAGTAGTABLE, Variant = Isaac.GetEntityVariantByName("Bagtag Stretcher Dud")})

end

if StageAPI and StageAPI.Loaded then
    LoadCode()
else
    if not StageAPI then
        StageAPI = {Loaded = false, ToCall = {}}
    end

    StageAPI.ToCall[#StageAPI.ToCall + 1] = LoadCode
end

EXILE_M.bork.NonexistantFunction()
	