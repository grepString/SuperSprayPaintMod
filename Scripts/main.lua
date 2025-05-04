-- SuperSprayPaintMod for Drive Beyond Horizons
-- Main script file

print("[SuperSprayPaintMod] Mod loaded")

-- Define available colors and sheen types
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
    { name = "Silver", color = { R = 0.75, G = 0.75, B = 0.75, A = 1 } }
}

local SheenTypes = {
    { name = "Matte", value = 0 },
    { name = "Metallic", value = 1 }
}

-- Function to spawn a paint bomb with specified properties
function SpawnPaintBomb(color, sheen, offsetX, offsetY)
    print("[SuperSprayPaintMod] Spawning paint bomb with color: " .. color.name .. ", sheen: " .. sheen.name)

    -- Get the player controller and pawn
    local pc = FindFirstOf("PlayerController")
    if not pc then
        print("[SuperSprayPaintMod] Error: Could not find player controller")
        return
    end

    local pawn = pc.Pawn
    if not pawn then
        print("[SuperSprayPaintMod] Error: Could not find player pawn")
        return
    end

    -- Get the paint bomb class
    local paintBombClass = StaticFindObject("/Game/BP/Items/Movable/PaintBomb/PaintBomb.PaintBomb_C")
    if not paintBombClass then
        print("[SuperSprayPaintMod] Error: Could not find PaintBomb class")
        return
    end

    -- Get player location
    local location = pawn:K2_GetActorLocation()
    local rotation = pawn:K2_GetActorRotation()

    -- Calculate spawn position (in front of the player with offset)
    -- Since we can't use GetForwardVector, we'll use a simple offset based on the player's rotation
    local yaw = rotation.Yaw or 0
    local yawRadians = yaw * (3.14159 / 180.0)
    local forwardX = math.cos(yawRadians)
    local forwardY = math.sin(yawRadians)

    -- Calculate right vector (perpendicular to forward)
    local rightX = -forwardY
    local rightY = forwardX

    -- Calculate spawn position
    local spawnLocation = {
        X = location.X + forwardX * 150 + rightX * offsetX,
        Y = location.Y + forwardY * 150 + rightY * offsetX,
        Z = location.Z + 50 + offsetY
    }

    -- Spawn the paint bomb
    local world = pawn:GetWorld()
    local paintBomb = world:SpawnActor(paintBombClass, spawnLocation, rotation)

    if paintBomb then
        -- Set the paint bomb properties (color and sheen)
        -- Try different property names that might exist in the PaintBomb class
        local propertySet = false

        -- Try setting properties directly
        if paintBomb.PaintColor then
            paintBomb.PaintColor = color.color
            propertySet = true
        end

        if paintBomb.SheenType then
            paintBomb.SheenType = sheen.value
            propertySet = true
        end

        -- Try alternative property names
        if paintBomb.Color then
            paintBomb.Color = color.color
            propertySet = true
        end

        if paintBomb.Sheen then
            paintBomb.Sheen = sheen.value
            propertySet = true
        end

        print("[SuperSprayPaintMod] Paint bomb spawned successfully")
    else
        print("[SuperSprayPaintMod] Error: Failed to spawn paint bomb")
    end
end

-- Function to spawn all paint bombs
function SpawnAllPaintBombs()
    print("[SuperSprayPaintMod] Spawning all paint bombs")

    local spacing = 50
    local row = 0
    local col = 0

    -- Spawn one of each color with matte finish
    for i, color in ipairs(Colors) do
        SpawnPaintBomb(color, SheenTypes[1], col * spacing, row * spacing)
        col = col + 1

        -- Start a new row after 5 items
        if col >= 5 then
            col = 0
            row = row + 1
        end
    end

    -- Add a gap between matte and metallic
    row = row + 1
    col = 0

    -- Spawn one of each color with metallic finish
    for i, color in ipairs(Colors) do
        SpawnPaintBomb(color, SheenTypes[2], col * spacing, row * spacing)
        col = col + 1

        -- Start a new row after 5 items
        if col >= 5 then
            col = 0
            row = row + 1
        end
    end

    print("[SuperSprayPaintMod] All paint bombs spawned")
end

-- Register keybind for F5 to spawn all paint bombs
RegisterKeyBind(Key.F5, function()
    print("[SuperSprayPaintMod] F5 key detected, spawning paint bombs")
    SpawnAllPaintBombs()
    return false
end)

print("[SuperSprayPaintMod] Initialization complete - Press F5 to spawn paint bombs")
