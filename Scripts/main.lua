-- SuperSprayPaintMod for Drive Beyond Horizons
-- Main script file

print("[SuperSprayPaintMod] Mod loaded")

-- Configuration variables
local CONFIG = {
    -- Distance from player's Z position to the ground
    -- Based on the player model files found in Content/Player
    -- MaleCharacter.uasset and FemaleCharacter.uasset suggest standard UE4 character setup
    GROUND_OFFSET = 84,

    -- Distance in front of the player to spawn the grid
    FORWARD_DISTANCE = 250,

    -- Spacing between paint cans in the grid
    HORIZONTAL_SPACING = 90,
    DEPTH_SPACING = 140,
    SHEEN_OFFSET = 60,

    -- Number of columns in the grid
    GRID_COLUMNS = 4,

    -- Height above ground level to spawn cans
    -- Small positive value to ensure cans don't clip into ground
    GROUND_CLEARANCE = 5
}

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

-- This function has been removed and its functionality integrated directly into SpawnAllPaintBombs
-- to ensure consistent grid layout regardless of player view angle

-- Function to spawn all paint bombs
function SpawnAllPaintBombs()
    print("[SuperSprayPaintMod] Spawning all paint bombs")

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

    -- Get player location and rotation
    local location = pawn:K2_GetActorLocation()
    local pawnRotation = pawn:K2_GetActorRotation()

    -- Calculate ground level using the configured offset
    -- Based on the player model files found in Content/Player
    local groundLevel = location.Z - CONFIG.GROUND_OFFSET

    -- Debug output
    print(string.format("[SuperSprayPaintMod] Pawn Rotation - Pitch: %.1f, Yaw: %.1f",
        pawnRotation.Pitch or 0, pawnRotation.Yaw or 0))
    print(string.format("[SuperSprayPaintMod] Player Location - X: %.1f, Y: %.1f, Z: %.1f",
        location.X, location.Y, location.Z))
    print(string.format("[SuperSprayPaintMod] Ground Level - Z: %.1f (Using offset: %.1f)",
        groundLevel, CONFIG.GROUND_OFFSET))

    -- Calculate forward and right vectors based ONLY on Yaw (horizontal rotation)
    -- This is the key to making the grid spawn consistently regardless of where the player is looking
    -- By ignoring Pitch (looking up/down), we ensure the grid is always perpendicular to the player's facing direction
    local yaw = pawnRotation.Yaw or 0
    local yawRadians = yaw * (3.14159 / 180.0)

    -- Forward vector points in the direction the player is facing horizontally
    local forwardX = math.cos(yawRadians)
    local forwardY = math.sin(yawRadians)

    -- Right vector is perpendicular to forward (90 degrees clockwise)
    local rightX = -forwardY
    local rightY = forwardX

    -- Grid configuration - using values from CONFIG
    local horizontalSpacing = CONFIG.HORIZONTAL_SPACING  -- Space between columns (left to right)
    local depthSpacing = CONFIG.DEPTH_SPACING           -- Space between rows (front to back)
    local sheenOffset = CONFIG.SHEEN_OFFSET             -- Distance between matte and metallic versions
    local forwardDistance = CONFIG.FORWARD_DISTANCE     -- Distance in front of player

    -- Use the calculated ground level plus a small offset to ensure cans are visible
    local baseHeight = groundLevel + CONFIG.GROUND_CLEARANCE  -- Just slightly above ground level

    -- Debug output for height calculation
    print(string.format("[SuperSprayPaintMod] Base Height - Ground Z: %.1f, Can Z: %.1f, Offset: %.1f",
        groundLevel, baseHeight, baseHeight - groundLevel))

    -- Number of columns in our grid
    local numColumns = CONFIG.GRID_COLUMNS

    -- Create a rotation for all paint bombs (only Yaw component)
    local spawnRotation = {
        Pitch = 0,
        Yaw = yaw,
        Roll = 0
    }

    -- For each color, spawn 4 of each sheen type (matte and metallic)
    for i, color in ipairs(Colors) do
        -- Calculate grid position (0-based index)
        local gridIndex = i - 1
        local col = gridIndex % numColumns
        local row = math.floor(gridIndex / numColumns)

        -- Calculate offsets - center the grid by subtracting half the total width
        local centerOffset = (numColumns - 1) * horizontalSpacing / 2
        local offsetX = (col * horizontalSpacing) - centerOffset
        local offsetY = row * depthSpacing

        -- Debug output for offsets and vectors
        if i == 1 then
            print(string.format("[SuperSprayPaintMod] Offsets - X: %.1f, Y: %.1f", offsetX, offsetY))
            print(string.format("[SuperSprayPaintMod] Forward - X: %.2f, Y: %.2f", forwardX, forwardY))
            print(string.format("[SuperSprayPaintMod] Right - X: %.2f, Y: %.2f", rightX, rightY))
        end

        local world = pawn:GetWorld()

        -- Spawn 4 matte versions
        for j = 1, 4 do
            -- Calculate position with slight offset for each copy
            local offsetMultiplier = (j - 1) * 20  -- 20 units apart

            local matteX = location.X + (forwardX * forwardDistance) + (rightX * offsetX) + (rightX * offsetMultiplier)
            local matteY = location.Y + (forwardY * forwardDistance) + (rightY * offsetX) + (rightY * offsetMultiplier)
            local matteZ = baseHeight

            -- Debug output for first can
            if i == 1 and j == 1 then
                print(string.format("[SuperSprayPaintMod] First can position - X: %.1f, Y: %.1f, Z: %.1f",
                    matteX, matteY, matteZ))
            end

            local matteLocation = { X = matteX, Y = matteY, Z = matteZ }
            local mattePaintBomb = world:SpawnActor(paintBombClass, matteLocation, spawnRotation)

            if mattePaintBomb then
                -- Set properties
                if mattePaintBomb.PaintColor then
                    mattePaintBomb.PaintColor = color.color
                end

                if mattePaintBomb.SheenType then
                    mattePaintBomb.SheenType = SheenTypes[1].value
                end

                -- Try alternative property names
                if mattePaintBomb.Color then
                    mattePaintBomb.Color = color.color
                end

                if mattePaintBomb.Sheen then
                    mattePaintBomb.Sheen = SheenTypes[1].value
                end
            end
        end

        -- Spawn 4 metallic versions
        for j = 1, 4 do
            -- Calculate position with slight offset for each copy
            local offsetMultiplier = (j - 1) * 20  -- 20 units apart

            local metallicX = location.X + (forwardX * (forwardDistance + sheenOffset)) + (rightX * offsetX) + (rightX * offsetMultiplier)
            local metallicY = location.Y + (forwardY * (forwardDistance + sheenOffset)) + (rightY * offsetX) + (rightY * offsetMultiplier)
            local metallicZ = baseHeight

            local metallicLocation = { X = metallicX, Y = metallicY, Z = metallicZ }
            local metallicPaintBomb = world:SpawnActor(paintBombClass, metallicLocation, spawnRotation)

            if metallicPaintBomb then
                -- Set properties
                if metallicPaintBomb.PaintColor then
                    metallicPaintBomb.PaintColor = color.color
                end

                if metallicPaintBomb.SheenType then
                    metallicPaintBomb.SheenType = SheenTypes[2].value
                end

                -- Try alternative property names
                if metallicPaintBomb.Color then
                    metallicPaintBomb.Color = color.color
                end

                if metallicPaintBomb.Sheen then
                    metallicPaintBomb.Sheen = SheenTypes[2].value
                end
            end
        end
    end

    print("[SuperSprayPaintMod] All paint bombs spawned - 4 of each color and sheen type (matte and metallic)")
end

-- Register keybind for F5 to spawn all paint bombs
RegisterKeyBind(Key.F5, function()
    print("[SuperSprayPaintMod] F5 key detected, spawning paint bombs")
    SpawnAllPaintBombs()
    return false
end)

print("[SuperSprayPaintMod] Initialization complete - Press F5 to spawn paint bombs")
