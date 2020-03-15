
------------------ ITEMS

EXILE_M.COLLECTIBLE_ETHOS = Isaac.GetItemIdByName("Ethos")
EXILE_M.COLLECTIBLE_PATHOS = Isaac.GetItemIdByName("Pathos")
EXILE_M.COLLECTIBLE_LOGOS = Isaac.GetItemIdByName("Logos")
EXILE_M.COLLECTIBLE_VULKNUT = Isaac.GetItemIdByName("Valknut")

EXILE_M.COLLECTIBLE_ARTEMIS = Isaac.GetItemIdByName("Artemis")

EXILE_M.COLLECTIBLE_CROSIER = Isaac.GetItemIdByName("Crosier")
FamiliarVariant.CROSIER = Isaac.GetEntityVariantByName("Crosier")

EXILE_M.COLLECTIBLE_LANTERN = Isaac.GetItemIdByName("Dad's Lantern")
FamiliarVariant.LANTERN = Isaac.GetEntityVariantByName("Dad's Lantern")

EXILE_M.COLLECTIBLE_MYSTERIOUSEYE = Isaac.GetItemIdByName("Mysterious Eye")
FamiliarVariant.MYSTERIOUSEYE = Isaac.GetEntityVariantByName("Mysterious Eye")

local izmelitem = Isaac.GetItemIdByName("Izmel")
local debugitem = Isaac.GetItemIdByName("Testing Item")


EXILE_M.COLLECTIBLE_INCENSE = Isaac.GetItemIdByName("Incense")
EXILE_M.COLLECTIBLE_CHRISM = Isaac.GetItemIdByName("Chrism")

EXILE_M.COSTUME_ARTEMISHEAD = Isaac.GetCostumeIdByPath("gfx/characters/artemis_head.anm2")
EXILE_M.COSTUME_ARTEMISBODY = Isaac.GetCostumeIdByPath("gfx/characters/artemis_body.anm2")

function EXILE_M:CacheUpdateChrism(player, cacheFlag)
    if player:HasCollectible(EXILE_M.COLLECTIBLE_CHRISM) then
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - 1;
		end
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 1.75
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 1
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.15
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateChrism)

function EXILE_M:CacheUpdateArtemis(player, cacheFlag)
    if player:HasCollectible(EXILE_M.COLLECTIBLE_ARTEMIS) then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 0.75
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateArtemis)		


FamiliarVariant.INCENSEAURA = Isaac.GetEntityVariantByName("Incense Aura")
FamiliarVariant.SWORDENTITY = Isaac.GetEntityVariantByName("Misericorde Swing")

TearVariant.SWORDTEAR = Isaac.GetEntityVariantByName("Sword Tear")

EXILE_M.COSTUME_VULKNUTACTIVE = Isaac.GetCostumeIdByPath("gfx/characters/vulknut_active.anm2")
EXILE_M.COSTUME_VULKNUTINACTIVE = Isaac.GetCostumeIdByPath("gfx/characters/vulknut_inactive.anm2")

local function FollowerEnable(Type, player)
	Isaac.DebugString("Followers Enabled (1, 2)")
	return Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Type, 0, player.Position, Vector(0,0), Caboose):ToFamiliar()

end

function EXILE_M.randomFrom(tbl)
  if #tbl ~= 0 then
    return tbl[math.random(#tbl)]
  end
end


--- Revelations' Get Random Entity Function (Not mine, thanks sent)
function EXILE_M.getRandomEnemy(vulnerable, ignoreFriendly, activeenemy)
	local room = Game():GetRoom()
	local entitylist = room:GetEntities()
	
	if #Isaac.GetRoomEntities() ~= 0 then
    targ, i = nil, 0

    repeat
      targ = EXILE_M.randomFrom(Isaac.GetRoomEntities())
      i = i + 1
    until ( (not vulnerable or targ:IsVulnerableEnemy()) and (not activeenemy or targ:IsActiveEnemy()) and not (ignoreFriendly and targ:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) ) or i == 100

    return targ
	end
end

--- Also Rev stuff, changed to be compatible
function EXILE_M.CollidesWithLine(position, lineStart, lineEnd, lineWidth)
    return lineStart:Distance(position) + lineEnd:Distance(position) - lineStart:Distance(lineEnd) < lineWidth
end

function EXILE_M.CollidesWithLaser(position, laser, add)
    if laser:IsCircleLaser() then
        local distanceFromCenter = position:Distance(laser.Position)
        if math.abs(distanceFromCenter - laser.Radius) < laser.Size then
            return true
        end
    else
        if EXILE_M.CollidesWithLine(position, laser.Position, laser:GetEndPoint(), (laser.Size / 2) + (add or 0)) then
            return true
        end
    end

    return false
end





function EXILE_M:DebugItemUse()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local shape = room:GetRoomShape()
	local npc = player:ToNPC()
	local level = game:GetLevel()

		local vials = Isaac.FindByType(Isaac.GetEntityTypeByName("Quarantine Jail Door"), Isaac.GetEntityVariantByName("Quarantine Jail Door"), -1, true, false) -- Select a vial out of the ones in the room currently
		for _, tear in pairs(vials) do
		tear:GetData().Open = true
		end
end
	
EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.DebugItemUse, debugitem);

function EXILE_M:IzmelUse()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	local shape = room:GetRoomShape()
	local npc = player:ToNPC()
	local level = game:GetLevel()
	
	player:AnimateCollectible(izmelitem, "UseItem", "PlayerPickup")
	
	

	
	for _, enemy in pairs(Isaac.GetRoomEntities()) do
	if enemy.HitPoints < (enemy.MaxHitPoints * 0.25) or enemy:GetSprite():IsPlaying("Death") then
	sound:Play(Sounds.SWORDBEAM,1.3,0,false,1)
	Game():ShakeScreen(11,11)
		
		if enemy.Type == EntityType.ENTITY_DUKE then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,1.5,0,false,1)
			local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			slash.RenderZOffset = 80;
			slash.SpriteScale = enemy.SpriteScale
		enemy:BloodExplode()
		enemy:BloodExplode()
		player:AddBlueFlies(4, enemy.Position, player)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_ROTTEN_BABY, enemy.Position, Vector(0,0), nil)
		enemy:Remove()
		end
		
		if enemy.Type == EntityType.ENTITY_KRAMPUS then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,1.5,0,false,1)
					local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			slash.RenderZOffset = 80;
			slash.SpriteScale = enemy.SpriteScale
		enemy:BloodExplode()
		enemy:BloodExplode()
		local roll = math.random(1,8)
		if roll > 4 then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS, enemy.Position, Vector(0,0), nil)
		else
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LUMP_OF_COAL, enemy.Position, Vector(0,0), nil)
		end
		enemy:Remove()
		end
		
	
	

		if enemy.Type == EntityType.ENTITY_MONSTRO then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,1.5,0,false,1)
					local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			slash.RenderZOffset = 80;
			slash.SpriteScale = enemy.SpriteScale
		enemy:BloodExplode()
		enemy:BloodExplode()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LIL_MONSTRO, enemy.Position, Vector(0,0), nil)
		enemy:Remove()
		end

		if enemy.Type == EntityType.ENTITY_GURDY or enemy.Type == EntityType.ENTITY_GURDY_JR then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,1.5,0,false,1)
					local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			slash.RenderZOffset = 80;
			slash.SpriteScale = enemy.SpriteScale
		enemy:BloodExplode()
		enemy:BloodExplode()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_LIL_GURDY, enemy.Position, Vector(0,0), nil)
		enemy:Remove()
		end
		
			if enemy.Type == EntityType.ENTITY_RAG_MAN and enemy.Variant == 0 then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,1.5,0,false,1)
					local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			slash.RenderZOffset = 80;
			slash.SpriteScale = enemy.SpriteScale
		enemy:BloodExplode()
		enemy:BloodExplode()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_OLD_BANDAGE, enemy.Position, Vector(0,0), nil)
		enemy:Remove()
		end
		
		if enemy.Type == EntityType.ENTITY_DINGLE or enemy.Type == EntityType.ENTITY_DANGLE then
		sound:Play(SoundEffect.SOUND_DEATH_CARD,1.5,0,false,1)
					local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			slash.RenderZOffset = 80;
			slash.SpriteScale = enemy.SpriteScale
		enemy:BloodExplode()
		enemy:BloodExplode()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_PETRIFIED_POOP, enemy.Position, Vector(0,0), nil)
		enemy:Remove()
		end
		
		
	end
	end
end
	
EXILE_M:AddCallback(ModCallbacks.MC_USE_ITEM, EXILE_M.IzmelUse, izmelitem);



--Misericorde
function EXILE_M:SwordTearUpdate(player)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_MISERICORDE) then
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_TEAR, -1, -1, false, false)) do
			local data = entity:GetData()
			local tear = entity:ToTear()
			if entity.Variant ~= TearVariant.SWORDTEAR then
			tear:ChangeVariant(TearVariant.SWORDTEAR)
			sound:Play(Sounds.SWORDBEAM,0.6,0,false,1.3)
			end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.SwordTearUpdate);


function EXILE_M:SwordUpdate(swordEntity)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(EXILE_M.COLLECTIBLE_MISERICORDE) then
  swordEntity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
  posX = player.Position.X
  posY = player.Position.Y
  local fartradius = 22
  local damageDist = 29
  local posXoffset = player.Position.X + 20
  local posYoffset = player.Position.Y + 20
  local sprite = swordEntity:GetSprite()
  swordEntity.RenderZOffset = -18;
  swordEntity.DepthOffset = -35;
  local SwordX = swordEntity.Position.X
  local SwordY = swordEntity.Position.Y
  if not player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
  EXILE_M.SwordDamageDist = 35
  EXILE_M.OffsetDist = 55
  else
  EXILE_M.SwordDamageDist = 42
  EXILE_M.OffsetDist = 65
  end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) 
  and not player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
	sprite:ReplaceSpritesheet(2, "gfx/misericorde_weaponfiremind.png")
	sprite:ReplaceSpritesheet(1, "gfx/misericorde_weaponfiremind.png")
	sprite:LoadGraphics()
   end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) 
  or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) 
  or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO)
  and not player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
	sprite:ReplaceSpritesheet(5, "gfx/misericorde_weaponvenom.png")
	sprite:ReplaceSpritesheet(3, "gfx/misericorde_weaponvenom.png")
	sprite:LoadGraphics()
   end
  if player:HasCollectible(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) then
	sprite:ReplaceSpritesheet(6, "gfx/scythewep.png")
	sprite:ReplaceSpritesheet(3, "gfx/misericorde_weaponplaceholder2.png")
	sprite:ReplaceSpritesheet(2, "gfx/misericorde_weaponplaceholder2.png")
	sprite:ReplaceSpritesheet(0, "gfx/misericorde_weaponplaceholder2.png")
	sprite:LoadGraphics()
   end
   swordPositionOffset = swordEntity.PositionOffset
   if not sprite:IsPlaying("SwingRight") and player:GetFireDirection() == 2 then
   sprite:Play("SwingRight", 1)
   swordEntity.Position = Vector(posX + EXILE_M.OffsetDist,posY)
   swordEntity.FlipX = false
   sound:Play(SoundEffect.SOUND_SHELLGAME,2,0,false,1)
     	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
   if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
   sound:Play(Sounds.FIRESWORD,2,0,false,1)
   end
   
   swordEntity.PositionOffset = Vector(10,0);
   swordEntity.SpriteRotation = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) then
		Game():BombDamage(swordEntity.Position, 0.50, 17, false, player, 0, 0, false)
		end
	end
   if not sprite:IsPlaying("SwingLeft") and player:GetFireDirection() == 0 then
   sprite:Play("SwingLeft", 1)
   swordEntity.Position = Vector(posX - EXILE_M.OffsetDist,posY)
   swordEntity.FlipX = false
   sound:Play(SoundEffect.SOUND_SHELLGAME,2,0,false,1)
     	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
   if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
   sound:Play(Sounds.FIRESWORD,2,0,false,1)
   end
  
   swordEntity.PositionOffset = Vector(-10,0);
   swordEntity.SpriteRotation = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) then
		Game():BombDamage(swordEntity.Position, 0.50, 17, false, player, 0, 0, false)
		end
	end
   if not sprite:IsPlaying("SwingUp") and player:GetFireDirection() == 1 then
   sprite:Play("SwingUp", 1)
   swordEntity.Position = Vector(posX,posY - EXILE_M.OffsetDist)
   swordEntity.FlipX = false
   sound:Play(SoundEffect.SOUND_SHELLGAME,2,0,false,1)
     	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
   if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
   sound:Play(Sounds.FIRESWORD,2,0,false,1)
   end
  
   swordEntity.PositionOffset = Vector(0,-20);
   swordEntity.SpriteRotation = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) then
		Game():BombDamage(swordEntity.Position, 0.50, 17, false, player, 0, 0, false)
		end
	end
   if not sprite:IsPlaying("SwingDown") and player:GetFireDirection() == 3 then
   sprite:Play("SwingDown", 1)
   swordEntity.Position = Vector(posX,posY + EXILE_M.OffsetDist)
   swordEntity.FlipX = false
   sound:Play(SoundEffect.SOUND_SHELLGAME,2,0,false,1)
     	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
	game:ButterBeanFart(swordEntity.Position, fartradius, player, false)
   if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
   sound:Play(Sounds.FIRESWORD,2,0,false,1)
   end
  
   swordEntity.PositionOffset = Vector(0,5);
   swordEntity.SpriteRotation = 0
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SULFURIC_ACID) then
		Game():BombDamage(swordEntity.Position, 0.50, 17, false, player, 0, 0, false)
		end
	end
	if player:GetFireDirection() == 0 then
	if sprite:GetFrame() < 4 then
   	for _, enemy in pairs(Isaac.GetRoomEntities()) do
	local data = enemy:GetData()
		if enemy:IsVulnerableEnemy() and enemy.Position:Distance(swordEntity.Position) < EXILE_M.SwordDamageDist and enemy.Position:Distance(player.Position) > 36 and not data.FriendlyPoop and not data.NoSlice then
			sound:Play(Sounds.STAB,2,0,false,2)
			local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			enemy:BloodExplode()
			slash.RenderZOffset = 23;
			
			enemy:TakeDamage(player.Damage * 2.5,0,EntityRef(player),0)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) then
			enemy:AddPoison(EntityRef(player), 500, 1)
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
			enemy:AddBurn(EntityRef(player), 500, 2)
			end
		end
		if enemy.Type == EntityType.ENTITY_PROJECTILE and enemy.Position:Distance(swordEntity.Position) < 30 then
		enemy:Die()	
		end
		end
	end
	end
	if player:GetFireDirection() == 1 then
	if sprite:GetFrame() < 4 then
   	for _, enemy in pairs(Isaac.GetRoomEntities()) do
	local data = enemy:GetData()
		if enemy:IsVulnerableEnemy() and enemy.Position:Distance(swordEntity.Position) < EXILE_M.SwordDamageDist and enemy.Position:Distance(player.Position) > 36 and not data.FriendlyPoop and not data.NoSlice then
			sound:Play(Sounds.STAB,2,0,false,2)
			local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			enemy:BloodExplode()
			slash.RenderZOffset = 23;
			
			enemy:TakeDamage(player.Damage * 2.5,0,EntityRef(player),0)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) then
			enemy:AddPoison(EntityRef(player), 500, 1)
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
			enemy:AddBurn(EntityRef(player), 500, 2)
			end
		end
		if enemy.Type == EntityType.ENTITY_PROJECTILE and enemy.Position:Distance(swordEntity.Position) < 30 then
		enemy:Die()	
		end
		end
	end
	end
	if player:GetFireDirection() == 2 then
	if sprite:GetFrame() < 4 then
   	for _, enemy in pairs(Isaac.GetRoomEntities()) do
	local data = enemy:GetData()
		if enemy:IsVulnerableEnemy() and enemy.Position:Distance(swordEntity.Position) < EXILE_M.SwordDamageDist and enemy.Position:Distance(player.Position) > 36 and not data.FriendlyPoop and not data.NoSlice then
			sound:Play(Sounds.STAB,2,0,false,2)
			local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			enemy:BloodExplode()
			slash.RenderZOffset = 23;
			
			enemy:TakeDamage(player.Damage * 2.5,0,EntityRef(player),0)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) then
			enemy:AddPoison(EntityRef(player), 500, 1)
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
			enemy:AddBurn(EntityRef(player), 500, 2)
			end
		end
		if enemy.Type == EntityType.ENTITY_PROJECTILE and enemy.Position:Distance(swordEntity.Position) < 30 then
		enemy:Die()
		end
		end
	end
	end
	if player:GetFireDirection() == 3 then
	if sprite:GetFrame() < 4 then
   	for _, enemy in pairs(Isaac.GetRoomEntities()) do
	local data = enemy:GetData()
		if enemy:IsVulnerableEnemy() and enemy.Position:Distance(swordEntity.Position) < EXILE_M.SwordDamageDist and enemy.Position:Distance(player.Position) > 36 and not data.FriendlyPoop and not data.NoSlice then
			sound:Play(Sounds.STAB,2,0,false,2)
			local slash = Isaac.Spawn(EntityType.SLASH, 119, 0, enemy.Position, Vector(0,0), player)
			enemy:BloodExplode()
			slash.RenderZOffset = 23;
			
			enemy:TakeDamage(player.Damage * 2.5,0,EntityRef(player),0)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_COMMON_COLD) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SERPENTS_KISS) 
			or player:HasCollectible(CollectibleType.COLLECTIBLE_SCORPIO) then
			enemy:AddPoison(EntityRef(player), 500, 1)
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_FIRE_MIND) then
			enemy:AddBurn(EntityRef(player), 500, 2)
			end
		end
		if enemy.Type == EntityType.ENTITY_PROJECTILE and enemy.Position:Distance(swordEntity.Position) < 30 then
		enemy:Die()	
		end
		end
	end
	end
	if not sprite:IsPlaying("SwingRight") and not sprite:IsPlaying("SwingDown") and not sprite:IsPlaying("SwingLeft") and not sprite:IsPlaying("SwingUp") and player:GetFireDirection() == -1 then
	swordEntity.Position = Vector(posX,posY)
	if not sprite:IsPlaying("Idle") then
	sprite:Play("Idle", 1)
		end
	end
	swordEntity.Position = Vector(posX,posY)
	swordEntity.Velocity = player.Velocity
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EXILE_M.SwordUpdate, FamiliarVariant.SWORDENTITY);

function EXILE_M:CacheUpdateSword(player, cacheFlag)
    if player:HasCollectible(EXILE_M.COLLECTIBLE_MISERICORDE) then
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
			player.MaxFireDelay = player.MaxFireDelay + 7;
		end
		end
		if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearFallingSpeed = player.TearFallingSpeed + 4
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed + 0.5
		end
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 2.2
		end
	end
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
	player:CheckFamiliar(FamiliarVariant.SWORDENTITY, player:GetCollectibleNum(EXILE_M.COLLECTIBLE_MISERICORDE), RNG())
	end

end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateSword)


function EXILE_M:GetEye(EyeF)
 -- Run basic starting functions meant to initialize before the familiar itself spawns, and when isaac first obtains the item.
 -- For example; Variables and states that the Familiar should be in when its first collected. (Especially it's initial/first state!)
	EXILE_M.EyeBlinking = 0
end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, EXILE_M.GetEye, FamiliarVariant.MYSTERIOUSEYE)

function EXILE_M:UpdateEye(EyeF)
    local player = Isaac.GetPlayer(0)
    local data = EyeF:GetData()
    local sprite = EyeF:GetSprite()
    local pos = EyeF.Position

    local mindistance = nil
	if Game():GetFrameCount() > 8 then
    for _, target in pairs(Isaac.GetRoomEntities()) do
        if target.Type == EntityType.ENTITY_PICKUP and target.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local currdistance = target.Position:Distance(player.Position)
            if not mindistance or (currdistance < mindistance) then
                mindistance = currdistance
            end
        end
    end
            EXILE_M.EyeBlinking = 0
            if mindistance then
                if mindistance < 330 and mindistance > 120 then
                    EXILE_M.EyeBlinking = 1
                elseif mindistance < 120 and mindistance > 86 then
                    EXILE_M.EyeBlinking = 2
                elseif mindistance < 86 then
                    EXILE_M.EyeBlinking = 3

                end
            end
            
            
    if EXILE_M.EyeBlinking == 1 and not EyeF:GetSprite():IsPlaying("Blinking1", true) then
    EyeF:GetSprite():Play("Blinking1", true)
    end
    
    if EXILE_M.EyeBlinking == 2 and not EyeF:GetSprite():IsPlaying("Blinking2", true) then
    EyeF:GetSprite():Play("Blinking2", true)
    end

    if EXILE_M.EyeBlinking == 3 and not EyeF:GetSprite():IsPlaying("Blinking3", true) then
    EyeF:GetSprite():Play("Blinking3", true)
    end
    
    if EXILE_M.EyeBlinking == 0 and not EyeF:GetSprite():IsPlaying("Idle", true) then
    EyeF:GetSprite():Play("Idle", true)
    end
    
    if EyeF:GetSprite():IsEventTriggered("Blink") then
    sound:Play(Sounds.EYECLINK,1.5,0,false,1)
    end
	end
    EyeF:FollowParent()
end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EXILE_M.UpdateEye, FamiliarVariant.MYSTERIOUSEYE)

function EXILE_M:OnCacheEye(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
	player:CheckFamiliar(FamiliarVariant.MYSTERIOUSEYE, player:GetCollectibleNum(EXILE_M.COLLECTIBLE_MYSTERIOUSEYE), RNG())
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.OnCacheEye)

local artemisColor = Color(0.35, 1.320, 1.300, 1, 1, 1, 1)

EXILE_M:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
  local data = entity:GetData()
  if data.ArtemisLinkEffect then
		if entity:GetData().Targ == nil then
		EXILE_M.getRandomEnemy(true, true, true)
		if targ ~= nil and targ ~= entity then
			entity:GetData().Targ = targ
			
			local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT,43850,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
			eff:GetData().ArtemisSigil = true
			eff:GetData().SigilParent = entity
			
			local eff2 = Isaac.Spawn(EntityType.ENTITY_EFFECT,43850,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
			eff2:GetData().ArtemisSigil = true
			eff2:GetData().SigilParent = entity:GetData().Targ			

			targ:GetData().ArtemisLinkEffectTarg = true
			targ:GetData().ArtemisLinkParent = entity
			end
		else
		entity:SetColor(artemisColor, 2, 5, true, true)
	end
	
  end
  
  if data.ArtemisLinkEffectTarg and not data.ArtemisLinkEffect then
    entity:SetColor(artemisColor, 2, 5, true, true)
  end
  
end)

EXILE_M:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, entity)
  local data = entity:GetData()
  if data.ArtemisSigil then
	entity.Position = data.SigilParent.Position
	entity.SpriteOffset = Vector(0,-8)
	entity.SpriteScale = Vector(0.8,0.8)
	entity.DepthOffset = 80
	end
end)

function EXILE_M:ArtemisTearCheck(tear, entity)
	for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
			if entity:GetData().ArtemisLinkEffect == nil then entity:GetData().ArtemisLinkEffect = false end
			if entity:GetData().ArtemisLinkEffect == false and entity:GetData().ArtemisLinkEffectTarg == nil then
			if entity:IsActiveEnemy() then
				if tear:GetData().ArtemisTear then
					if Isaac.CountEnemies() > 1 then
					entity:GetData().ArtemisLinkEffect = true
					end
				end
			end
			elseif entity:GetData().ArtemisLinkEffect == true then
				entity:TakeDamage(player.Damage,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
				local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT,43851,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
				eff:GetData().ArtemisSigil = true
				eff:GetData().SigilParent = entity
				
				if entity:GetData().Targ ~= nil then
					if not entity:GetData().Targ:IsDead() then
					entity:GetData().Targ:TakeDamage(player.Damage * 0.7,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
				
					local eff2 = Isaac.Spawn(EntityType.ENTITY_EFFECT,43851,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
					eff2:GetData().ArtemisSigil = true
					eff2:GetData().SigilParent = entity:GetData().Targ	
				
					end
				end

			elseif entity:GetData().ArtemisLinkEffectTarg == true then
				entity:TakeDamage(player.Damage,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
				local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT,43851,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
				eff:GetData().ArtemisSigil = true
				eff:GetData().SigilParent = entity

				if entity:GetData().ArtemisLinkParent ~= nil then
				if not entity:GetData().ArtemisLinkParent:IsDead() then
				entity:GetData().ArtemisLinkParent:TakeDamage(player.Damage * 0.7,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
				
				local eff2 = Isaac.Spawn(EntityType.ENTITY_EFFECT,43851,0,entity.Position + Vector(0,0) ,Vector(0,0),entity)
				eff2:GetData().ArtemisSigil = true
				eff2:GetData().SigilParent = entity:GetData().ArtemisLinkParent	
				
				end
				end				

			end
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, EXILE_M.ArtemisTearCheck, entity)


function EXILE_M:ArtemisTearEff(tear)
	for i = 0, (Game():GetNumPlayers() - 1) do
		local player = Isaac.GetPlayer(i)
		if player:HasCollectible(EXILE_M.COLLECTIBLE_ARTEMIS) then
			--if math.random(1, 100) <= 25 then  <---- unused chance modifier
				tear:GetData().ArtemisTear = true
			--end
		end
		if tear:GetData().ArtemisTear == true then
			tear:GetSprite().Color = artemisColor
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, EXILE_M.ArtemisTearEff)


function EXILE_M:GetLantern(LanternF)
Isaac.DebugString("Lantern Init (1)")
 -- Run basic starting functions meant to initialize before the familiar itself spawns, and when isaac first obtains the item.
 -- For example; Variables and states that the Familiar should be in when its first collected. (Especially it's initial/first state!)
	LanternOn = false
	LanternFireVar = 0
	Extinguished = false
	LanternBoost = 0
	ShotBlockEnable = true
	
	Isaac.DebugString("Lantern Init (2)")

end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, EXILE_M.GetLantern, FamiliarVariant.LANTERN)

local GiantBookEthos = Sprite()
GiantBookEthos:Load("gfx/ui/giantbook/giantbook_ethos.anm2", false)

function EXILE_M:onRenderEthos()
		if not GiantBookEthos:IsFinished("Shake") then
		GiantBookEthos:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderEthos)

function EXILE_M:bookUpdateEthos(player)
	GiantBookEthos:Update()
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.bookUpdateEthos);

function EXILE_M:EthosFloorReward()
local player = Isaac.GetPlayer(0)
local game = Game()
local room = game:GetRoom()
if player:HasCollectible(EXILE_M.COLLECTIBLE_ETHOS) then
	if game:GetStagesWithoutDamage() > 0 or game:GetStagesWithoutHeartsPicked() > 0 then
	GiantBookEthos:LoadGraphics()
	GiantBookEthos:Play("Shake", true)
	end
	
	if game:GetStagesWithoutDamage() > 0 then
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
	end
	
	if game:GetStagesWithoutHeartsPicked() > 0 then
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, room:FindFreePickupSpawnPosition(player.Position, 35, false), Vector(0,0), nil)
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true);
	end
	
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, EXILE_M.EthosFloorReward);

function EXILE_M:ResetFloorEthos()
	Game():ClearStagesWithoutDamage()
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.ResetFloorEthos, EntityType.ENTITY_PLAYER)


function EXILE_M:PathosTakeDamage()
local player = Isaac.GetPlayer(0)
if player:HasCollectible(EXILE_M.COLLECTIBLE_PATHOS) then
EXILE_M.SavedData.PathosKills = EXILE_M.SavedData.PathosKills + 1
	if EXILE_M.SavedData.PathosKills == 5 then
			sound:Play(Sounds.LIGHTNINGSTRIKE,1,0,false,1)
				local lightning = Isaac.Spawn(EntityType.LIGHTNINGEFF, 3232, 0, player.Position, Vector(0,0), nil)
				Game():ShakeScreen(8,8)
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SAD_ONION, false);
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_SCAPULAR, true);
	elseif EXILE_M.SavedData.PathosKills == 9 then
			sound:Play(Sounds.LIGHTNINGSTRIKE,1,0,false,1)
				local lightning = Isaac.Spawn(EntityType.LIGHTNINGEFF, 3232, 0, player.Position, Vector(0,0), nil)
				Game():ShakeScreen(11,11)
			local tear1 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(7,7),player)
			local tear2 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(-7,7),player)
			local tear3 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(7,-7),player)
			local tear4 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(-7,-7),player)

			local tear5 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(0,9),player)
			local tear6 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(0,-9),player)
			local tear7 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(9,0),player)
			local tear8 = Isaac.Spawn(EntityType.ENTITY_TEAR,TearVariant.BLOOD,0,player.Position + Vector(0,0) ,Vector(-9,0),player)
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL, true);
	elseif EXILE_M.SavedData.PathosKills == 15 then
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BLOOD_MARTYR, false);
				Game():ShakeScreen(12,12)
				local Nearby = Isaac.GetFreeNearPosition(player.Position, 40)
				sound:Play(Sounds.LIGHTNINGSTRIKE,1,0,false,1)
				local lightning = Isaac.Spawn(EntityType.LIGHTNINGEFF, 3232, 0, Nearby, Vector(0,0), nil)
				Isaac.Spawn(5,0,0,Nearby,Vector(0,0),nil)
		sound:Play(Sounds.HOLY_TWO,1,0,false,1)
	end
end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, EXILE_M.PathosTakeDamage)




function EXILE_M:ResetPathosStats()
	EXILE_M.PathosActivated = false
	EXILE_M.SavedData.PathosKills = 0
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetPathosStats)

function EXILE_M:UpdateIncenseAura(incenseAura)
		local player = Isaac.GetPlayer(0)
	local data = incenseAura:GetData()
	local sprite = incenseAura:GetSprite()
	local pos = incenseAura.Position
	for _, enemy in pairs(Isaac.GetRoomEntities()) do
		if enemy:IsActiveEnemy() and enemy.Position:Distance(player.Position) < 80 then
			enemy:AddBurn(EntityRef(player), 900, 2)
			enemy:AddCharmed(50)
		end
	end
	incenseAura.Position = player.Position
	incenseAura.DepthOffset = 120
	incenseAura:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EXILE_M.UpdateIncenseAura, FamiliarVariant.INCENSEAURA)

function EXILE_M:UpdateLantern(LanternF)
	Isaac.DebugString("Lantern Updated (1)")
	local player = Isaac.GetPlayer(0)
	local data = LanternF:GetData()
	local sprite = LanternF:GetSprite()
	local pos = LanternF.Position
	
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if entity.Type == EntityType.ENTITY_FIREPLACE then
			if entity.Position:Distance(pos) < 28 and not entity:IsDead() then
				if not entity:GetData().Died then
				if entity.Variant == 0 then
					entity:Die()
					sound:Play(Sounds.FIRELIGHT,1,0,false,1)
					entity:Remove()
					entity:GetData().Died = true
					LanternFireVar = 1
					LanternOn = true
					LanternBoost = 1
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
					player:EvaluateItems()				
				end
				if entity.Variant == 1 then
					entity:Die()
					sound:Play(Sounds.FIRELIGHT,1,0,false,1)
					entity:Remove()
					entity:GetData().Died = true
					LanternFireVar = 2
					LanternOn = true
					LanternBoost = 2
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)	
					player:EvaluateItems()
				end
				if entity.Variant == 2 then
					entity:Die()
					sound:Play(Sounds.FIRELIGHT,1,0,false,1)
					entity:Remove()
					entity:GetData().Died = true
					LanternFireVar = 4 -- mix up with the variants :P
					LanternOn = true
					LanternBoost = 3
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)	
					player:EvaluateItems()
				end
				if entity.Variant == 3 then
					entity:Die()
					sound:Play(Sounds.FIRELIGHT,1,0,false,1)
					entity:Remove()
					entity:GetData().Died = true
					LanternFireVar = 3
					LanternOn = true
					LanternBoost = 4
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
					player:EvaluateItems()
				end
				end
		
			end
		end
		
		
	end
	
	
	for _, enemy in pairs(Isaac.GetRoomEntities()) do
		if enemy:IsActiveEnemy() and enemy.Position:Distance(pos) < 38 then
			enemy:AddBurn(EntityRef(player), 900, 2)
		end
	end

	for _, enemy in pairs(Isaac.GetRoomEntities()) do
	if enemy.Type == EntityType.ENTITY_PROJECTILE then
		if enemy.Position:Distance(pos) < 23 then
		enemy:Die()
		end
		end
	end
	
	
	if LanternOn == false then
	sprite:Play("FloatDown", false)
	elseif LanternOn == true then
	if LanternFireVar == 1 then
	sprite:Play("FloatDownFire", false)
	end
	if LanternFireVar == 2 then
	sprite:Play("FloatDownFireR", false)
	end
	if LanternFireVar == 3 then
	sprite:Play("FloatDownFireP", false)
	end
	if LanternFireVar == 4 then
	sprite:Play("FloatDownFireB", false)
	end
	end
	
	
	-------
	LanternF:FollowParent()
	Isaac.DebugString("Lantern Updated (2)")
end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EXILE_M.UpdateLantern, FamiliarVariant.LANTERN)

function EXILE_M:RefreshFireDeaths()
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if entity.Type == EntityType.ENTITY_FIREPLACE and entity.HitPoints == 1.0 and not entity:GetData().Died then
		entity:GetData().Died = true
	end
end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.RefreshFireDeaths)


function EXILE_M:GetCrosier(CrosierF)
	Isaac.DebugString("Crosier Init (1)")
 -- Run basic starting functions meant to initialize before the familiar itself spawns, and when isaac first obtains the item.
 -- For example; Variables and states that the Familiar should be in when its first collected. (Especially it's initial/first state!)
	EXILE_M.CrosierCross = false
	EXILE_M.CrosierMoving = 0
	Isaac.DebugString("Crosier Init (2)")
	CrosierF:AddToFollowers()

end

EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, EXILE_M.GetCrosier, FamiliarVariant.CROSIER)

function EXILE_M:UpdateCrosier(CrosierF)
    local player = Isaac.GetPlayer(0)
    local data = CrosierF:GetData()
    local sprite = CrosierF:GetSprite()
    local pos = CrosierF.Position

    local maxdist = 44

    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
        data.resize = 15
        data.damagemult = 0.68
    else
        data.resize = 9
        data.damagemult = 0.5
    end

    if Input.IsButtonPressed(Keyboard.KEY_LEFT, 0)  then
        EXILE_M.CrosierMoving = 1
        CrosierF.Velocity = CrosierF.Velocity:Resized(data.resize)
        CrosierF:AddVelocity(Vector(-0.45,0))
    end
    if Input.IsButtonPressed(Keyboard.KEY_RIGHT, 0)  then
        EXILE_M.CrosierMoving = 1
        CrosierF.Velocity = CrosierF.Velocity:Resized(data.resize)
        CrosierF:AddVelocity(Vector(0.45,0))
    end
    if Input.IsButtonPressed(Keyboard.KEY_DOWN, 0)  then
        EXILE_M.CrosierMoving = 1
        CrosierF.Velocity = CrosierF.Velocity:Resized(data.resize)
        CrosierF:AddVelocity(Vector(0,0.45))
    end
    if Input.IsButtonPressed(Keyboard.KEY_UP, 0)  then
        EXILE_M.CrosierMoving = 1
        CrosierF.Velocity = CrosierF.Velocity:Resized(data.resize)
        CrosierF:AddVelocity(Vector(0,-0.45))
    end
    if Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0) then
        EXILE_M.CrosierMoving = 1
        CrosierF.Velocity = CrosierF.Velocity:Resized(3.5)
        CrosierF.Velocity = CrosierF.Velocity / 3
    end
    if not Input.IsButtonPressed(Keyboard.KEY_LEFT, 0)
        and not Input.IsButtonPressed(Keyboard.KEY_RIGHT, 0)
        and not Input.IsButtonPressed(Keyboard.KEY_DOWN, 0)
        and not Input.IsButtonPressed(Keyboard.KEY_UP, 0)
        and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0) and EXILE_M.CrosierMoving == 1 then
        EXILE_M.CrosierMoving = 0
    end

    if Input.IsButtonPressed(Keyboard.KEY_LEFT, 0)
        or Input.IsButtonPressed(Keyboard.KEY_RIGHT, 0)
        or Input.IsButtonPressed(Keyboard.KEY_DOWN, 0)
        or Input.IsButtonPressed(Keyboard.KEY_UP, 0)
        or Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0) and EXILE_M.CrosierMoving == 1 then
        if not sprite:IsPlaying("Spin", true) then
            CrosierF.Velocity = Vector(0,0)
            sound:Play(Sounds.THROWRANG,1.1,0,false,1)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                sound:Play(Sounds.SWORDBEAM,1.4,0,false,1)
            end
            sprite:Play("Spin", true)
        end
    end

    local vials = Isaac.FindByType(EntityType.ENTITY_LASER, -1, -1, false, false) --
    for __, tear in ipairs(vials) do
        local tlaser = tear:ToLaser()
        if EXILE_M.CollidesWithLaser(CrosierF.Position, tlaser, 60) then
            if not tlaser:GetData().CrosierLaser == true and tlaser.FrameCount == 1 then
                EXILE_M.getRandomEnemy(true, false, true)
                if targ ~= nil and tlaser.SpawnerType == EntityType.ENTITY_PLAYER then
                    if tlaser.Variant == 1 or tlaser.Variant == 3 or tlaser.Variant == 9 then
                        sound:Play(Sounds.SCI_FI,1.0,0,false,0.9)
                        local pos1 = CrosierF.Position - targ.Position
                        local Dirvect = pos1:GetAngleDegrees()
                        local CrosierLaser = EntityLaser.ShootAngle(1, CrosierF.Position, Dirvect + 180,
                            30, Vector(0,-5), CrosierF)
                        --sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
                        CrosierLaser.DepthOffset = 45;
                        CrosierLaser.MaxDistance = 150;
                        CrosierLaser.TearFlags = player.TearFlags
                        CrosierLaser.CollisionDamage = player.Damage
                        CrosierLaser:GetData().CrosierLaser = true
                    elseif  tlaser.Variant == 2 then
                        --	sound:Play(Sounds.SCI_FI,1.0,0,false,0.9)
                        local pos1 = CrosierF.Position - targ.Position
                        local Dirvect = pos1:GetAngleDegrees()
                        local CrosierLaser = EntityLaser.ShootAngle(2, CrosierF.Position, Dirvect + 180,
                            30, Vector(0,-5), CrosierF)
                        --sound:Play(SoundEffect.SOUND_GHOST_ROAR,1,0,false,1)
                        CrosierLaser.DepthOffset = 45;
                        CrosierLaser.MaxDistance = 150;
                        CrosierLaser.TearFlags = player.TearFlags
                        CrosierLaser.CollisionDamage = player.Damage
                        CrosierLaser:GetData().CrosierLaser = true
                    end
                end
            end
        end
    end



    if player:HasCollectible(CollectibleType.COLLECTIBLE_RELIC) then
        sprite:ReplaceSpritesheet(1, "gfx/crosiertest.png")
        sprite:LoadGraphics()
    else
        sprite:ReplaceSpritesheet(1, "gfx/crosiercross_placeholder.png")
        sprite:LoadGraphics()
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
        sprite:ReplaceSpritesheet(3, "gfx/crosiercross_withknife.png")
        sprite:LoadGraphics()
    else
        sprite:ReplaceSpritesheet(3, "gfx/crosiercross_placeholder.png")
        sprite:LoadGraphics()
    end



    if EXILE_M.CrosierMoving == 0 and not sprite:IsPlaying("Idle", true) then
        sprite:Play("Idle", true)
    end

    if EXILE_M.CrosierMoving == 1 and sprite:IsPlaying("Spin", true) then
        ---------- AFTERIMAGE
        if sprite:GetFrame() == 1 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0) then
            CrosierF:GetData().AFrame = 1
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A1", true)
            --sound:Play(SoundEffect.SOUND_SHELLGAME,1.1,0,false,0.45)
        elseif sprite:GetFrame() == 3 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 2
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A2", true)
        elseif sprite:GetFrame() == 5 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 3
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A3", true)
            --sound:Play(SoundEffect.SOUND_SHELLGAME,1.1,0,false,0.45)
        elseif sprite:GetFrame() == 7 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 4
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A4", true)
            --sound:Play(SoundEffect.SOUND_SHELLGAME,1.1,0,false,0.45)
        elseif sprite:GetFrame() == 9 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 5
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A5", true)
            --sound:Play(SoundEffect.SOUND_SHELLGAME,1.1,0,false,0.45)
        elseif sprite:GetFrame() == 11 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 6
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A6", true)
        elseif sprite:GetFrame() == 13 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 7
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A7", true)
            --sound:Play(SoundEffect.SOUND_SHELLGAME,1.1,0,false,0.45)
        elseif sprite:GetFrame() == 15 and not Input.IsButtonPressed(Keyboard.KEY_LEFT_ALT, 0)  then
            CrosierF:GetData().AFrame = 8
            local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), 0, CrosierF.Position, Vector(0,0), CrosierF)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder_aknife.png")
                light:GetSprite():LoadGraphics()
            else
                light:GetSprite():ReplaceSpritesheet(0, "gfx/crosiercross_placeholder.png")
                light:GetSprite():LoadGraphics()
            end
            light:GetSprite():Play("A8", true)
        else

        end

        local tears = Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, false, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(tears) do
            local player = Isaac.GetPlayer(0)
            if tear.Position:Distance(CrosierF.Position) < maxdist then
                if player.Position:Distance(CrosierF.Position) > maxdist then
                    tear:Die()
                end
            end
        end

        for _, enemy in pairs(Isaac.GetRoomEntities()) do
            if enemy:IsActiveEnemy() and enemy.Position:Distance(CrosierF.Position) < maxdist then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
                    enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                end
                enemy:TakeDamage(player.Damage * data.damagemult,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
                if not player:HasCollectible(CollectibleType.COLLECTIBLE_RELIC) then
                -- dud
                else
                    local roll = math.random(1,250)
                    if roll > 230 then
                        local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, enemy.Position, Vector(0,0), player)
                    end
                end
            end
        end
    end

    if EXILE_M.CrosierMoving == 0 then
        local tears = Isaac.FindByType(EntityType.ENTITY_EFFECT, Isaac.GetEntityVariantByName("Crosier Afterimage"), -1, false, false) -- Select a vial out of the ones in the room currently
        for _, tear in ipairs(tears) do
            tear:Remove()
        end
        CrosierF.Velocity = CrosierF.Velocity / 3
        CrosierF:FollowParent()
    end
    CrosierF.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    CrosierF.DepthOffset = 45
    --CrosierF.SpriteScale = player.SpriteScale
end


EXILE_M:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EXILE_M.UpdateCrosier, FamiliarVariant.CROSIER)


function EXILE_M:OnCacheCrosier(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
    local crosierRNG = player:GetCollectibleRNG(EXILE_M.COLLECTIBLE_CROSIER)
	local numCrosier = player:GetCollectibleNum(EXILE_M.COLLECTIBLE_CROSIER) * (player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) + 1)
	player:CheckFamiliar(FamiliarVariant.CROSIER, numCrosier, crosierRNG)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.OnCacheCrosier)

function EXILE_M:OnCacheLantern(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
	player:CheckFamiliar(FamiliarVariant.LANTERN, player:GetCollectibleNum(EXILE_M.COLLECTIBLE_LANTERN), RNG())
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.OnCacheLantern)

function EXILE_M:OnCacheIncense(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
	player:CheckFamiliar(FamiliarVariant.INCENSEAURA, player:GetCollectibleNum(EXILE_M.COLLECTIBLE_INCENSE), RNG())
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.OnCacheIncense)


function EXILE_M:onLanternDmg(player)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(EXILE_M.COLLECTIBLE_LANTERN) and LanternBoost > 0 then
	for _, entity in pairs(Isaac.GetRoomEntities()) do
	local data = entity:GetData()
	local sprite = entity:GetSprite()
	local pos = entity.Position
		if entity.Type == EntityType.ENTITY_FAMILIAR and
		entity.Variant == FamiliarVariant.LANTERN then
		local dmgroll = math.random(1,6)
		if dmgroll > 4 then
		LanternOn = false
		LanternFireVar = 0
		LanternBoost = 0
				player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
				player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
		player:EvaluateItems()
		entity:GetSprite():Play("Extinguish", true)
		sound:Play(SoundEffect.SOUND_STEAM_HALFSEC,1.5,0,false,1)
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(7,7),player):ToTear()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(-7,7),player):ToTear()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(7,-7),player):ToTear()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(-7,-7),player):ToTear()

			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(0,9),player):ToTear()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(0,-9),player):ToTear()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(9,0),player):ToTear()
			Isaac.Spawn(EntityType.ENTITY_EFFECT,51,0,entity.Position + Vector(0,0) ,Vector(-9,0),player):ToTear()

		end
		end
	end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EXILE_M.onLanternDmg, EntityType.ENTITY_PLAYER)

function EXILE_M:CacheUpdateLanternEffects(player, cacheFlag)
		if player:HasCollectible(EXILE_M.COLLECTIBLE_LANTERN) then
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				if LanternBoost == 2 then
				player.Damage = player.Damage + 2.50
			end
		end
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
				if LanternBoost == 3 then
				player.MaxFireDelay = player.MaxFireDelay - 3
			end						
		end
			if cacheFlag == CacheFlag.CACHE_TEARFLAG then
				if LanternBoost == 4 then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
			player.TearFlags = player.TearFlags | TearFlags.TEAR_CONTINUUM
			end
				if LanternBoost == 1 then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_BURN
			end
		end
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateLanternEffects)

local VulknutEffect = {
	DAMAGE_BOOST = 2.75,
	BONUS_TEARS = 2,
	Triggered = false,
	IsActive = false
}

local GiantBookValknut = Sprite()
GiantBookValknut:Load("gfx/ui/giantbook/giantbook_valknut.anm2", false)


function EXILE_M:CacheUpdateVulknut(player, cacheFlag)
		if VulknutEffect.IsActive then
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + VulknutEffect.DAMAGE_BOOST
		end
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = player.MaxFireDelay - VulknutEffect.BONUS_TEARS
		end
	end
end

function EXILE_M:onRenderBookValknut()
	if VulknutEffect.Triggered then
		if not GiantBookValknut:IsFinished("Appear") then
		GiantBookValknut:RenderLayer(0, Isaac.WorldToRenderPosition(Vector(320,280),true))
		end
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRenderBookValknut)

function EXILE_M:bookUpdateValknut(player)
	GiantBookValknut:Update()
end

function VulknutEffect:Proc(player, cacheFlag, ...)
	local player = Isaac.GetPlayer(0)
	local autodamage = player.Damage / 1.75
	if player:HasCollectible(EXILE_M.COLLECTIBLE_VULKNUT) and not VulknutEffect.IsActive == true then
	sound:Play(Sounds.SCI_FI,1,0,false,1)
	VulknutEffect.Room = game:GetLevel():GetCurrentRoomIndex()
	GiantBookValknut:LoadGraphics()
	GiantBookValknut:Play("Appear", true)
	player:TryRemoveNullCostume(EXILE_M.COSTUME_VULKNUTINACTIVE)
	player:AddNullCostume(EXILE_M.COSTUME_VULKNUTACTIVE)
	for _, enemy in pairs(Isaac.GetRoomEntities()) do
		local data = enemy:GetData()
		enemy = enemy:ToNPC()
		if enemy and
			
		enemy:IsActiveEnemy(true)
	then
		enemy:TakeDamage(autodamage,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
		end
	end
	VulknutEffect.IsActive = true
	VulknutEffect.Triggered = true
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	if not player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		end
	player:EvaluateItems()
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, VulknutEffect.Proc, EntityType.ENTITY_PLAYER)

function EXILE_M:ItemCostumesUpdate(player)
	local player = Isaac.GetPlayer(0)
	if EXILE_M.HasValknut == nil then 
		EXILE_M.HasValknut = 0
		EXILE_M.HasArtemis = 0 
	end

	------ VALKNUT -------
	if not player:HasCollectible(EXILE_M.COLLECTIBLE_VULKNUT) and EXILE_M.HasValknut == 1 and not VulknutEffect.IsActive == true then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_VULKNUTINACTIVE)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_VULKNUTACTIVE)
		EXILE_M.HasValknut = 0
	end
	if player:HasCollectible(EXILE_M.COLLECTIBLE_VULKNUT) and EXILE_M.HasValknut == 0 and not VulknutEffect.IsActive == true then
		player:AddNullCostume(EXILE_M.COSTUME_VULKNUTINACTIVE)
		EXILE_M.HasValknut = 1
	end
	

	------ ARTEMIS -------
	if not player:HasCollectible(EXILE_M.COLLECTIBLE_ARTEMIS) and EXILE_M.HasArtemis == 1 then
		player:TryRemoveNullCostume(EXILE_M.COSTUME_ARTEMISBODY)
		player:TryRemoveNullCostume(EXILE_M.COSTUME_ARTEMISHEAD)
		EXILE_M.HasArtemis = 0
	end
	if player:HasCollectible(EXILE_M.COLLECTIBLE_ARTEMIS) and EXILE_M.HasArtemis == 0 then
		player:AddNullCostume(EXILE_M.COSTUME_ARTEMISBODY)
		player:AddNullCostume(EXILE_M.COSTUME_ARTEMISHEAD)
		EXILE_M.HasArtemis = 1
	end
	
	
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ItemCostumesUpdate)
EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.ItemCostumesUpdate)

EXILE_M:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EXILE_M.CacheUpdateVulknut)




function EXILE_M:ResetRoomVariables3()
Isaac.DebugString("Reset Room Vars 2 Updated (1)")
	VulknutEffect.IsActive = false
	VulknutEffect.Triggered = false
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, EXILE_M.ResetRoomVariables3)

function EXILE_M:onUpdateVulknut(player)
	if VulknutEffect.Room ~= nil and game:GetLevel():GetCurrentRoomIndex() ~= VulknutEffect.Room then
	VulknutEffect.IsActive = false
	VulknutEffect.Triggered = false
	player:TryRemoveNullCostume(EXILE_M.COSTUME_VULKNUTACTIVE)
	player:AddNullCostume(EXILE_M.COSTUME_VULKNUTINACTIVE)
	player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
	player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	player:EvaluateItems()
	VulknutEffect.Room = nil
	end
end

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.onUpdateVulknut)

EXILE_M:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EXILE_M.bookUpdateValknut);

EXILE_M.bork.NonExistantFunctionThatIsCalledToIntentionallyErrorThis()
