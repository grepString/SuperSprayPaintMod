-- SuperSprayPaintMod for Drive Beyond Horizons

print("[SuperSprayPaintMod] Mod loaded")

-- Configuration variables
local CONFIG = {
    -- Distance from player's Z position to the ground (fallback if line trace fails)
    GROUND_OFFSET = 80,

    -- Distance in front of the player to spawn the paint can
    FORWARD_DISTANCE = 150,

    -- Height above ground level to spawn can
    GROUND_CLEARANCE = 20,

    -- Initial color index (1-11)
    INITIAL_COLOR_INDEX = 1,

    -- Initial sheen type (true = metallic, false = matte)
    INITIAL_METALLIC = false,

    -- Quantity for "infinite" spray
    INFINITE_QUANTITY = 999999,

    -- Debug mode for additional logging
    DEBUG = false
}

-- Define available colors
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

local SheenTypes = {
    { value = 0 }, -- Matte
    { value = 1 }  -- Metallic
}

-- Global variables to track current state
local currentColorIndex = CONFIG.INITIAL_COLOR_INDEX
local isMetallic = CONFIG.INITIAL_METALLIC
local currentPaintBomb = nil

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

    -- Set Quantity for infinite spray
    if paintBomb.Quantity ~= nil then
        paintBomb.Quantity = CONFIG.INFINITE_QUANTITY
        if CONFIG.DEBUG then
            print(string.format("[SuperSprayPaintMod] Set Quantity=%.1f for infinite spray", CONFIG.INFINITE_QUANTITY))
        end
    end

    -- Set MinQuantity and MaxQuantity if they exist
    if paintBomb.MinQuantity ~= nil then
        paintBomb.MinQuantity = 0
    end

    if paintBomb.MaxQuantity ~= nil then
        paintBomb.MaxQuantity = CONFIG.INFINITE_QUANTITY
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

-- Function to spawn a single paint can
function SpawnPaintCan()
    print("[SuperSprayPaintMod] Spawning universal paint can")

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
        print("[SuperSprayPaintMod] Cannot spawn paint can without a valid world")
        return
    end

    -- Calculate forward vector using the yaw angle
    local yaw = pawnRotation.Yaw or 0
    local yawRadians = yaw * (3.14159 / 180.0)
    local forwardX = math.cos(yawRadians)
    local forwardY = math.sin(yawRadians)

    -- Calculate spawn position in front of the player
    local spawnX = location.X + (forwardX * CONFIG.FORWARD_DISTANCE)
    local spawnY = location.Y + (forwardY * CONFIG.FORWARD_DISTANCE)
    local spawnZ = groundLevel + CONFIG.GROUND_CLEARANCE

    -- Create a rotation for the paint bomb (only Yaw component)
    local spawnRotation = {
        Pitch = 0,
        Yaw = yaw,
        Roll = 0
    }

    -- Spawn the paint bomb
    local spawnLocation = { X = spawnX, Y = spawnY, Z = spawnZ }
    local success, result = pcall(function()
        return world:SpawnActor(paintBombClass, spawnLocation, spawnRotation)
    end)

    if success then
        currentPaintBomb = result
        print(string.format("[SuperSprayPaintMod] Spawned paint can at X: %.1f, Y: %.1f, Z: %.1f",
            spawnX, spawnY, spawnZ))

        -- Set the properties based on current color and sheen
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)

        -- Print current settings
        print(string.format("[SuperSprayPaintMod] Color: %s, Sheen: %s",
            Colors[currentColorIndex].name,
            isMetallic and "Metallic" or "Matte"))
    else
        print("[SuperSprayPaintMod] Error spawning paint can: " .. tostring(result))
    end
end

-- Function to cycle to the next color
function CycleColorForward()
    currentColorIndex = currentColorIndex + 1
    if currentColorIndex > #Colors then
        currentColorIndex = 1
    end

    print(string.format("[SuperSprayPaintMod] Switched to %s color", Colors[currentColorIndex].name))

    -- Update the current paint can if it exists
    if currentPaintBomb and currentPaintBomb:IsValid() then
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)
    end
end

-- Function to cycle to the previous color
function CycleColorBackward()
    currentColorIndex = currentColorIndex - 1
    if currentColorIndex < 1 then
        currentColorIndex = #Colors
    end

    print(string.format("[SuperSprayPaintMod] Switched to %s color", Colors[currentColorIndex].name))

    -- Update the current paint can if it exists
    if currentPaintBomb and currentPaintBomb:IsValid() then
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)
    end
end

-- Function to toggle between matte and metallic
function ToggleSheen()
    isMetallic = not isMetallic
    print(string.format("[SuperSprayPaintMod] Switched to %s sheen", isMetallic and "Metallic" or "Matte"))

    -- Update the current paint can if it exists
    if currentPaintBomb and currentPaintBomb:IsValid() then
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)
    end
end

-- Register key bindings
RegisterKeyBind(Key.F5, function()
    print("[SuperSprayPaintMod] F5 key detected, spawning paint can")
    SpawnPaintCan()
    return false
end)

RegisterKeyBind(Key.OEM_FOUR, function()  -- Left Bracket [
    print("[SuperSprayPaintMod] Left Bracket key detected, cycling color backward")
    CycleColorBackward()
    return false
end)

RegisterKeyBind(Key.OEM_SIX, function()  -- Right Bracket ]
    print("[SuperSprayPaintMod] Right Bracket key detected, cycling color forward")
    CycleColorForward()
    return false
end)

RegisterKeyBind(Key.OEM_FIVE, function()  -- Backslash \
    print("[SuperSprayPaintMod] Backslash key detected, toggling sheen")
    ToggleSheen()
    return false
end)

print("[SuperSprayPaintMod] Initialization complete")
print("[SuperSprayPaintMod] Press F5 to spawn paint can")
print("[SuperSprayPaintMod] Press [ (Left Bracket) to cycle colors backward")
print("[SuperSprayPaintMod] Press ] (Right Bracket) to cycle colors forward")
print("[SuperSprayPaintMod] Press \\ (Backslash) to toggle between matte and metallic")
