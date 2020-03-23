
--nil m

EntityType.CHAINHARPOON = Isaac.GetEntityTypeByName("Chain Harpoon")

local HARPOON_SPACING = 24
local Target = nil

local ZoomLevel = 1
local TriggeredLeft = false
local TriggeredRight = false
local mouseOffset = Vector(0,40)

function EXILE_M:onRender()
	local player = Isaac.GetPlayer(0)
	local room = Game():GetRoom()
	
	local ScrollOffset = room:GetRenderScrollOffset()
	local mousePos = Input.GetMousePosition(true)
	
		local tears = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears) do
		if tear:GetData().Child == true then
		if tear:GetData().FixedRotation == nil then
		tear:GetData().Pos = (tear.Parent.Position - tear.Position):GetAngleDegrees() + 180
		tear.SpriteRotation = tear:GetData().Pos
		else
		tear.SpriteRotation = tear:GetData().FixedRotation
		end
		if player.Position:Distance(tear.Position) < 27 then
		player:TakeDamage(1,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
		end
		--
		end
		end



	
	if Target == nil or not Target:Exists() then
	Target = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, mousePos, Vector(0,0), nil):ToNPC()
	else
		Target.Position = mousePos
		Target:GetSprite():Play("Idle", true)
		Target:GetData().Target = true
		local seg = Target.Child
		while seg do
		if seg.Position:Distance(seg.Parent.Position) > HARPOON_SPACING then
				seg.Position = seg.Parent.Position + (seg.Position - seg.Parent.Position):Normalized() * HARPOON_SPACING
			end
		seg = seg.Child
		end
	end
	
	if not TriggeredLeft and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) then
	TriggeredLeft = true
	
	local tail = Target
	
	while tail.Child do
		tail = tail.Child
	end
	tail.Child = Isaac.Spawn(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), 0, tail.Position, Vector(0,0), nil):ToNPC()
	tail.Child.Parent = tail
	tail.Child:GetData().Child = true
	if not tail.Child:GetSprite():IsPlaying("Chain") then
	tail.Child:GetSprite():Play("Chain", true)
	end
	elseif TriggeredLeft and not Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) then
		TriggeredLeft = false
	end
		local tears2 = Isaac.FindByType(EntityType.CHAINHARPOON, Isaac.GetEntityVariantByName("Chain Harpoon"), -1, false, false)
		for _, tear in ipairs(tears2) do
		if tear:GetData().Target == true and tear.Child then
		if tear:GetData().FixedRotation == nil then
		tear:GetData().Pos = (tear.Position - tear.Child.Position):GetAngleDegrees() + 180
		tear.SpriteRotation = tear:GetData().Pos
		else
		tear.SpriteRotation = tear:GetData().FixedRotation
		end
		--
		end
		if player.Position:Distance(tear.Position) < 32 then
		player:TakeDamage(1,DamageFlag.DAMAGE_INVINCIBLE,EntityRef(player),0)
		end
		end
	end
	
EXILE_M:AddCallback(ModCallbacks.MC_POST_RENDER, EXILE_M.onRender)	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	