EntityType.BEARTRAP = Isaac.GetEntityTypeByName("Bear Trap")
SoundEffect.SOUND_SNAP_SHUT = Isaac.GetSoundIdByName("SnapShut")
SoundEffect.SOUND_SQUISH = Isaac.GetSoundIdByName("DieSquish")

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