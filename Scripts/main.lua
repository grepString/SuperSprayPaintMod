-- SuperSprayPaintMod for Drive Beyond Horizons
-- Main script file
--
-- This mod spawns paint bombs with various colors and finishes.
-- Each color has 4 matte and 4 metallic cans.
-- Press F5 to spawn all paint bombs in a grid in front of your character.
--
-- Updated to properly set both matte and metallic properties:
-- - Matte cans have Metallic=0.0 and CustomMetallic=0.0
-- - Metallic cans have Metallic=1.0 and CustomMetallic=1.0
-- - Both types use UseCustomColor=true to ensure custom settings take effect
--
-- Added calls to force visual updates:
-- - Calls OnRep_Color and OnRep_Metallic functions to trigger visual updates
-- - This ensures the paint cans display the correct color immediately
-- - Without these calls, the cans would only update visually after a game reload

print("[SuperSprayPaintMod] Mod loaded")

-- Configuration variables
local CONFIG = {
    -- Distance from player's Z position to the ground (fallback if line trace fails)
    -- Based on the player model files found in Content/Player
    GROUND_OFFSET = 80,

    -- Distance in front of the player to spawn the grid
    FORWARD_DISTANCE = 250,

    -- Spacing between paint cans in the grid
    HORIZONTAL_SPACING = 90,
    DEPTH_SPACING = 140,

    -- Height above ground level to spawn cans
    -- Increased to prevent cans from clipping into ground or exploding
    GROUND_CLEARANCE = 20,

    -- Debug mode for additional logging
    DEBUG = false
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
    { value = 0 }, -- Matte
    { value = 1 }  -- Metallic
}

-- Helper function to set properties on a paint bomb
local function SetPaintBombProperties(paintBomb, color, isMetallic)
    local sheenTypeIndex = isMetallic and 2 or 1
    local metallicValue = isMetallic and 1.0 or 0.0
    local typeStr = isMetallic and "metallic" or "matte"

    -- Set properties
    if paintBomb.PaintColor then
        paintBomb.PaintColor = color.color
    end

    if paintBomb.SheenType then
        paintBomb.SheenType = SheenTypes[sheenTypeIndex].value
    end

    -- Try alternative property names
    if paintBomb.Color then
        paintBomb.Color = color.color
    end

    if paintBomb.Sheen then
        paintBomb.Sheen = SheenTypes[sheenTypeIndex].value
    end

    -- Set Metallic property directly
    if paintBomb.Metallic ~= nil then
        paintBomb.Metallic = metallicValue
        if CONFIG.DEBUG then
            print(string.format("[SuperSprayPaintMod] Set Metallic=%.1f for %s can", metallicValue, typeStr))
        end
    end

    -- Set UseCustomColor property if it exists
    if paintBomb.UseCustomColor ~= nil then
        paintBomb.UseCustomColor = true
        if CONFIG.DEBUG then
            print(string.format("[SuperSprayPaintMod] Set UseCustomColor=true for %s can", typeStr))
        end
    end

    -- Set CustomColor property if it exists
    if paintBomb.CustomColor ~= nil then
        paintBomb.CustomColor = color.color
        if CONFIG.DEBUG then
            print(string.format("[SuperSprayPaintMod] Set CustomColor for %s can", typeStr))
        end
    end

    -- Set CustomMetallic property if it exists
    if paintBomb.CustomMetallic ~= nil then
        paintBomb.CustomMetallic = metallicValue
        if CONFIG.DEBUG then
            print(string.format("[SuperSprayPaintMod] Set CustomMetallic=%.1f for %s can", metallicValue, typeStr))
        end
    end

    -- Call OnRep functions to force visual update
    pcall(function()
        if paintBomb.OnRep_Color then
            paintBomb:OnRep_Color()
            if CONFIG.DEBUG then
                print(string.format("[SuperSprayPaintMod] Called OnRep_Color for %s can", typeStr))
            end
        end

        if paintBomb.OnRepColor then
            paintBomb:OnRepColor()
            if CONFIG.DEBUG then
                print(string.format("[SuperSprayPaintMod] Called OnRepColor for %s can", typeStr))
            end
        end

        if paintBomb.OnRep_Metallic then
            paintBomb:OnRep_Metallic()
            if CONFIG.DEBUG then
                print(string.format("[SuperSprayPaintMod] Called OnRep_Metallic for %s can", typeStr))
            end
        end

        if paintBomb.OnRepMetallic then
            paintBomb:OnRepMetallic()
            if CONFIG.DEBUG then
                print(string.format("[SuperSprayPaintMod] Called OnRepMetallic for %s can", typeStr))
            end
        end
    end)

    -- Try to stabilize the physics
    pcall(function()
        -- Get the root component (usually the physics component)
        local rootComp = paintBomb.RootComponent
        if rootComp then
            -- Try to put the physics to sleep to prevent explosions
            if rootComp.PutRigidBodyToSleep then
                rootComp:PutRigidBodyToSleep()
            end

            -- Try to set initial linear/angular velocity to zero
            if rootComp.SetPhysicsLinearVelocity then
                rootComp:SetPhysicsLinearVelocity({X=0, Y=0, Z=0})
            end

            if rootComp.SetPhysicsAngularVelocityInDegrees then
                rootComp:SetPhysicsAngularVelocityInDegrees({X=0, Y=0, Z=0})
            end
        end
    end)
end

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
    local groundLevel = location.Z - CONFIG.GROUND_OFFSET

    -- Get the world for actor spawning
    local world
    local success, result = pcall(function()
        return pawn:GetWorld()
    end)

    if success and result then
        world = result
    else
        print("[SuperSprayPaintMod] Error getting world: " .. tostring(result))
        print("[SuperSprayPaintMod] Cannot spawn paint bombs without a valid world")
        return
    end

    -- Debug output
    if CONFIG.DEBUG then
        print(string.format("[SuperSprayPaintMod] Pawn Rotation - Pitch: %.1f, Yaw: %.1f",
            pawnRotation.Pitch or 0, pawnRotation.Yaw or 0))
        print(string.format("[SuperSprayPaintMod] Player Location - X: %.1f, Y: %.1f, Z: %.1f",
            location.X, location.Y, location.Z))
        print(string.format("[SuperSprayPaintMod] Ground Level - Z: %.1f (Using offset: %.1f)",
            groundLevel, CONFIG.GROUND_OFFSET))
    end

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
    local forwardDistance = CONFIG.FORWARD_DISTANCE     -- Distance in front of player

    -- Calculate base height for all cans
    local baseHeight = groundLevel + CONFIG.GROUND_CLEARANCE

    -- Debug output for base height
    if CONFIG.DEBUG then
        print(string.format("[SuperSprayPaintMod] Base Height for cans - Z: %.1f (Ground + %.1f)",
            baseHeight, CONFIG.GROUND_CLEARANCE))
    end

    -- Create a rotation for all paint bombs (only Yaw component)
    local spawnRotation = {
        Pitch = 0,
        Yaw = yaw,
        Roll = 0
    }

    -- For each color, spawn 4 of each sheen type (matte and metallic) in rows
    -- Each row will have one color with both matte and metallic versions side by side
    for i, color in ipairs(Colors) do
        -- Calculate row index (0-based)
        local row = i - 1
        local offsetY = row * depthSpacing

        -- Debug output for vectors
        if CONFIG.DEBUG and i == 1 then
            print(string.format("[SuperSprayPaintMod] Forward - X: %.2f, Y: %.2f", forwardX, forwardY))
            print(string.format("[SuperSprayPaintMod] Right - X: %.2f, Y: %.2f", rightX, rightY))
        end

        -- Spawn 4 matte versions (left side of the row)
        for j = 1, 4 do
            -- Calculate position with slight offset for each copy
            local offsetMultiplier = (j - 1) * 20  -- 20 units apart

            -- Center the grid horizontally
            local centerOffset = 1.5 * horizontalSpacing

            -- Position for matte cans (left side)
            local matteX = location.X + (forwardX * forwardDistance) + (rightX * (-centerOffset + offsetMultiplier))
            local matteY = location.Y + (forwardY * forwardDistance) + (rightY * (-centerOffset + offsetMultiplier)) + (forwardY * offsetY)
            local matteZ = baseHeight

            -- Debug output for first can
            if CONFIG.DEBUG and i == 1 and j == 1 then
                print(string.format("[SuperSprayPaintMod] First matte can position - X: %.1f, Y: %.1f, Z: %.1f",
                    matteX, matteY, matteZ))
            end

            local matteLocation = { X = matteX, Y = matteY, Z = matteZ }
            local mattePaintBomb

            -- Safely spawn the actor
            local success, result = pcall(function()
                return world:SpawnActor(paintBombClass, matteLocation, spawnRotation)
            end)

            if success then
                mattePaintBomb = result
            else
                print("[SuperSprayPaintMod] Error spawning matte paint bomb: " .. tostring(result))
            end

            if mattePaintBomb then
                -- Set properties and apply visual updates
                SetPaintBombProperties(mattePaintBomb, color, false) -- false = matte
            end
        end

        -- Spawn 4 metallic versions (right side of the row)
        for j = 1, 4 do
            -- Calculate position with slight offset for each copy
            local offsetMultiplier = (j - 1) * 20  -- 20 units apart

            -- Center the grid horizontally
            local centerOffset = 1.5 * horizontalSpacing

            -- Position for metallic cans (right side)
            local metallicX = location.X + (forwardX * forwardDistance) + (rightX * (horizontalSpacing - centerOffset + offsetMultiplier))
            local metallicY = location.Y + (forwardY * forwardDistance) + (rightY * (horizontalSpacing - centerOffset + offsetMultiplier)) + (forwardY * offsetY)
            local metallicZ = baseHeight

            -- Debug output for first metallic can
            if CONFIG.DEBUG and i == 1 and j == 1 then
                print(string.format("[SuperSprayPaintMod] First metallic can position - X: %.1f, Y: %.1f, Z: %.1f",
                    metallicX, metallicY, metallicZ))
            end

            local metallicLocation = { X = metallicX, Y = metallicY, Z = metallicZ }
            local metallicPaintBomb

            -- Safely spawn the actor
            local success, result = pcall(function()
                return world:SpawnActor(paintBombClass, metallicLocation, spawnRotation)
            end)

            if success then
                metallicPaintBomb = result
            else
                print("[SuperSprayPaintMod] Error spawning metallic paint bomb: " .. tostring(result))
            end

            if metallicPaintBomb then
                -- Set properties and apply visual updates
                SetPaintBombProperties(metallicPaintBomb, color, true) -- true = metallic
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
