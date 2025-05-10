-- SuperSprayPaintMod for Drive Beyond Horizons

print("[SuperSprayPaintMod] Mod loaded")

-- Config and colors
local CONFIG = {
    GROUND_OFFSET = 80,
    FORWARD_DISTANCE = 150,
    GROUND_CLEARANCE = 20,
    INFINITE_QUANTITY = 999999
}

local Colors = {
    { name = "Blue", color = { R = 0, G = 0, B = 1, A = 1 } },
    { name = "Red", color = { R = 1, G = 0, B = 0, A = 1 } },
    { name = "Green", color = { R = 0, G = 1, B = 0, A = 1 } },
    { name = "Yellow", color = { R = 1, G = 1, B = 0, A = 1 } },
    { name = "Orange", color = { R = 1, G = 0.5, B = 0, A = 1 } },
    { name = "Purple", color = { R = 0.5, G = 0, B = 0.5, A = 1 } },
    { name = "Pink", color = { R = 1, G = 0.75, B = 0.8, A = 1 } },
    { name = "Black", color = { R = 0, G = 0, B = 0, A = 1 } },
    { name = "White", color = { R = 1, G = 1, B = 1, A = 1 } },
    { name = "Gold", color = { R = 1, G = 0.84, B = 0, A = 1 } },
    { name = "Silver", color = { R = 0.45, G = 0.45, B = 0.5, A = 1 } }
}

local currentColorIndex, isMetallic, currentPaintBomb = 1, false, nil

-- Check if a property exists
local function HasProperty(obj, propName)
    if not obj then return false end
    local success, result = pcall(function() return obj[propName] ~= nil end)
    return success and result
end

-- Set properties on a paint bomb
local function SetPaintBombProperties(paintBomb, colorData, isMetallic)
    if not paintBomb or not paintBomb:IsValid() then return end

    local color = colorData.color

    -- Set color property
    paintBomb.Color = color

    -- Set metallic property
    paintBomb.Metallic = isMetallic and 1.0 or 0.0

    -- Set quantity for infinite spray
    paintBomb.Quantity = CONFIG.INFINITE_QUANTITY
    paintBomb.MinQuantity = 0
    paintBomb.MaxQuantity = CONFIG.INFINITE_QUANTITY

    if HasProperty(paintBomb, "ApplicationAmount") then
        paintBomb.ApplicationAmount = 1.0  -- Maximum application amount
    end

    if HasProperty(paintBomb, "ApplicationRate") then
        paintBomb.ApplicationRate = 1.0  -- Maximum application rate
    end

    if HasProperty(paintBomb, "PaintAmount") then
        paintBomb.PaintAmount = 1.0  -- Maximum paint amount
    end

    if HasProperty(paintBomb, "PaintCoverage") then
        paintBomb.PaintCoverage = 0.5  -- Maximum coverage
    end

    if HasProperty(paintBomb, "PaintRate") then
        paintBomb.PaintRate = 1.0  -- Maximum rate
    end

    if HasProperty(paintBomb, "SprayAmount") then
        paintBomb.SprayAmount = 1.0  -- Maximum spray amount
    end

    if HasProperty(paintBomb, "SprayRate") then
        paintBomb.SprayRate = 1.0  -- Maximum spray rate
    end

    -- Call OnRep functions to force visual update
    pcall(function()
        if HasProperty(paintBomb, "OnRep_Color") then paintBomb:OnRep_Color() end
        if HasProperty(paintBomb, "OnRep_Metallic") then paintBomb:OnRep_Metallic() end
        if HasProperty(paintBomb, "OnRep_Quantity") then paintBomb:OnRep_Quantity() end
    end)
end

-- Spawn a paint can in front of the player
function SpawnPaintCan()
    local pc = FindFirstOf("PlayerController")
    if not pc or not pc.Pawn then return end

    local pawn = pc.Pawn
    local paintBombClass = StaticFindObject("/Game/BP/Items/Movable/PaintBomb/PaintBomb.PaintBomb_C")
    if not paintBombClass then
        print("[SuperSprayPaintMod] Error: Could not find PaintBomb class")
        return
    end

    -- Calculate spawn position
    local location = pawn:K2_GetActorLocation()
    local yaw = (pawn:K2_GetActorRotation().Yaw or 0)
    local yawRad = yaw * (math.pi / 180.0)
    local spawnPos = {
        X = location.X + (math.cos(yawRad) * CONFIG.FORWARD_DISTANCE),
        Y = location.Y + (math.sin(yawRad) * CONFIG.FORWARD_DISTANCE),
        Z = (location.Z - CONFIG.GROUND_OFFSET) + CONFIG.GROUND_CLEARANCE
    }

    -- Spawn the paint bomb
    local world = pawn:GetWorld()
    local success, result = pcall(function()
        return world:SpawnActor(paintBombClass, spawnPos, {Pitch=0, Yaw=yaw, Roll=0})
    end)

    if success and result then
        currentPaintBomb = result
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)
        print(string.format("[SuperSprayPaintMod] Spawned %s %s paint",
            Colors[currentColorIndex].name, isMetallic and "metallic" or "matte"))
    else
        print("[SuperSprayPaintMod] Error: Failed to spawn paint can")
    end
end

-- Update paint can properties
local function UpdatePaintCan()
    if currentPaintBomb and currentPaintBomb:IsValid() then
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)
    end
end

-- Cycle colors and toggle sheen
function CycleColor(direction)
    currentColorIndex = currentColorIndex + direction
    if currentColorIndex > #Colors then currentColorIndex = 1 end
    if currentColorIndex < 1 then currentColorIndex = #Colors end
    print("[SuperSprayPaintMod] Color: " .. Colors[currentColorIndex].name)
    UpdatePaintCan()
end

function ToggleSheen()
    isMetallic = not isMetallic
    print("[SuperSprayPaintMod] Sheen: " .. (isMetallic and "Metallic" or "Matte"))
    UpdatePaintCan()
end

-- Register key bindings
RegisterKeyBind(Key.F5, function() SpawnPaintCan(); return false end)
RegisterKeyBind(Key.OEM_FOUR, function() CycleColor(-1); return false end)  -- [
RegisterKeyBind(Key.OEM_SIX, function() CycleColor(1); return false end)    -- ]
RegisterKeyBind(Key.OEM_FIVE, function() ToggleSheen(); return false end)   -- \

print("[SuperSprayPaintMod] Controls: F5 to spawn a paint can")
print("[SuperSprayPaintMod] Controls: [ or ] to cycle colors")
print("[SuperSprayPaintMod] Controls: \\ to toggle metallic/matte sheen")
