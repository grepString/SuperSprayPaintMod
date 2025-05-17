-- SuperSprayPaintMod for Drive Beyond Horizons

print("[SuperSprayPaintMod] Mod loaded")

local CONFIG = {
    GROUND_OFFSET = 80,
    FORWARD_DISTANCE = 150,
    GROUND_CLEARANCE = 20,
    INFINITE_QUANTITY = 999999
}

-- Tools
local TOOL_PATHS = {
    PAINT_BOMB = "/Game/BP/Items/Movable/PaintBomb/PaintBomb.PaintBomb_C",
    RUST_BRUSH = "/Game/BP/Items/Movable/Tools/RustBrush.RustBrush_C",
    POLISH_BRUSH = "/Game/BP/Items/Movable/Tools/PolishBrush.PolishBrush_C"
}

-- https://teamcolorcodes.com/
-- Use the included rgb_converter.html to add more colors

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
    { name = "Silver", color = { R = 0.45, G = 0.45, B = 0.5, A = 1 } },
    { name = "Cyan", color = { R = 0.298, G = 0.792, B = 0.784, A = 1 } },
    { name = "Alfa Romeo Maroon", color = { R = 0.643, G = 0.129, B = 0.204, A = 1 } },
    { name = "Alpine Dark Blue", color = { R = 0.008, G = 0.098, B = 0.169, A = 1 } },
    { name = "Aston Martin Dark Green", color = { R = 0, G = 0.141, B = 0.125, A = 1 } },
    { name = "Aston Martin Tiffany Green", color = { R = 0.012, G = 0.478, B = 0.408, A = 1 } },
    { name = "Caterham Green", color = { R = 0, G = 0.314, B = 0.188, A = 1 } },
    { name = "Équipe Ligier Dark Blue", color = { R = 0.075, G = 0.141, B = 0.318, A = 1 } },
    { name = "Force India Orange", color = { R = 0.949, G = 0.471, B = 0.212, A = 1 } },
    { name = "Forti Corse Warm Gray", color = { R = 0.561, G = 0.486, B = 0.518, A = 1 } },
    { name = "Haas Red", color = { R = 0.902, G = 0, B = 0.169, A = 1 } },
    { name = "HRT Khaki", color = { R = 0.651, G = 0.565, B = 0.31, A = 1 } },
    { name = "Manor Racing Blue", color = { R = 0, G = 0.427, B = 0.757, A = 1 } },
    { name = "Red Bull Racing Silver", color = { R = 0.753, G = 0.749, B = 0.749, A = 1 } },
    { name = "Sauber Red", color = { R = 0.871, G = 0.192, B = 0.149, A = 1 } },
    { name = "Scuderia AlphaTauri Dark Blue", color = { R = 0.125, G = 0.224, B = 0.298, A = 1 } },
    { name = "Scuderia Ferrari Yellow", color = { R = 1, G = 0.949, B = 0, A = 1 } },
    { name = "Scuderia Toro Rosso Red", color = { R = 1, G = 0.027, B = 0.259, A = 1 } },
    { name = "Simtek Medium Slate Blue", color = { R = 0.455, G = 0.529, B = 0.827, A = 1 } },
    { name = "Team Lotus Peach Puff", color = { R = 0.714, G = 0.6, B = 0.357, A = 1 } },
    { name = "Team Lotus Orange", color = { R = 0.984, G = 0.667, B = 0.118, A = 1 } },
    { name = "Team Penske Red", color = { R = 0.812, G = 0.063, B = 0.176, A = 1 } },
    { name = "Toleman Blue", color = { R = 0.016, G = 0.008, B = 0.769, A = 1 } },
    { name = "Williams Racing Sky Blue", color = { R = 0, G = 0.627, B = 0.871, A = 1 } }
    { name = "Green 4BO", color = { R = 0.404, G = 0.573, B = 0.404, A = 1 } }
}

local currentColorIndex, isMetallic, currentPaintBomb = 1, false, nil

-- Display a message
local function ShowInGameChatMessage(message)
    local formattedMessage = "[SSPM] " .. message

    print("[SuperSprayPaintMod] " .. message)

    -- Send a chat message using the ChatStruct
    local pc = FindFirstOf("PlayerController")
    if not pc or not pc:IsValid() then return end

    pcall(function()
        -- Create a chat struct
        local chatStruct = {}
        chatStruct.Time_8_DF6F279248745BE38C2E40835DE88631 = 0
        chatStruct.User_6_4A6B517E45F066403FD3C4B4AA7C0FA3 = "SuperSprayPaintMod"
        chatStruct.Mesage_7_79981D7A424DFD8E6876D888E700B202 = formattedMessage
        chatStruct.IsInfoMessage_10_CD41743F409EA1DC4DD22CAC94591338 = true

        if pc.ServerSendChatMessage then
            pc:ServerSendChatMessage(chatStruct)
        end
    end)
end

-- Check if a property exists
local function HasProperty(obj, propName)
    if not obj then return false end
    local success, result = pcall(function() return obj[propName] ~= nil end)
    return success and result
end

-- Infinite tools
local function SetInfiniteToolProperties(tool)
    if not tool or not tool:IsValid() then return end

    tool.Quantity = CONFIG.INFINITE_QUANTITY
    tool.MinQuantity = 0
    tool.MaxQuantity = CONFIG.INFINITE_QUANTITY

    -- Call OnRep function to force visual update
    pcall(function()
        if HasProperty(tool, "OnRep_Quantity") then tool:OnRep_Quantity() end
    end)
end

-- Set properties on a paint bomb
local function SetPaintBombProperties(paintBomb, colorData, isMetallic)
    if not paintBomb or not paintBomb:IsValid() then return end

    local color = colorData.color

    paintBomb.Color = color

    paintBomb.Metallic = isMetallic and 1.0 or 0.0

    -- Set infinite usage
    SetInfiniteToolProperties(paintBomb)

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
    end)
end

local function SpawnTool(toolPath, toolName, callback)
    local pc = FindFirstOf("PlayerController")
    if not pc or not pc.Pawn then return nil end

    local pawn = pc.Pawn
    local toolClass = StaticFindObject(toolPath)
    if not toolClass then
        print("[SuperSprayPaintMod] Error: Could not find " .. toolName .. " class")
        return nil
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

    -- Spawn the tool
    local world = pawn:GetWorld()
    local success, result = pcall(function()
        return world:SpawnActor(toolClass, spawnPos, {Pitch=0, Yaw=yaw, Roll=0})
    end)

    if success and result then
        if callback then
            callback(result)
        end
        return result
    else
        print("[SuperSprayPaintMod] Error: Failed to spawn " .. toolName)
        return nil
    end
end

-- Spawn a paint can
function SpawnPaintCan()
    local result = SpawnTool(TOOL_PATHS.PAINT_BOMB, "PaintBomb", function(paintBomb)
        currentPaintBomb = paintBomb
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)

        local colorName = Colors[currentColorIndex].name
        local sheenType = isMetallic and "Metallic" or "Matte"
        local message = string.format("Spawned %s %s paint", colorName, sheenType)

        print("[SuperSprayPaintMod] " .. message)
        ShowInGameChatMessage(message)
    end)
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

    local colorName = Colors[currentColorIndex].name
    local sheenType = isMetallic and "Metallic" or "Matte"
    local message = string.format("Color: %s (%s)", colorName, sheenType)

    print("[SuperSprayPaintMod] " .. message)
    ShowInGameChatMessage(message)
    UpdatePaintCan()
end

function ToggleSheen()
    isMetallic = not isMetallic

    local colorName = Colors[currentColorIndex].name
    local sheenType = isMetallic and "Metallic" or "Matte"
    local message = string.format("Color: %s (%s)", colorName, sheenType)

    print("[SuperSprayPaintMod] " .. message)
    ShowInGameChatMessage(message)
    UpdatePaintCan()
end

-- Spawn a rust brush
function SpawnRustBrush()
    SpawnTool(TOOL_PATHS.RUST_BRUSH, "RustBrush", function(brush)
        SetInfiniteToolProperties(brush)

        local message = "Spawned Rust Brush with infinite usage"
        print("[SuperSprayPaintMod] " .. message)
        ShowInGameChatMessage(message)
    end)
end

-- Spawn a polish sponge
function SpawnPolishBrush()
    SpawnTool(TOOL_PATHS.POLISH_BRUSH, "PolishBrush", function(brush)
        SetInfiniteToolProperties(brush)

        local message = "Spawned Polish Sponge with infinite usage"
        print("[SuperSprayPaintMod] " .. message)
        ShowInGameChatMessage(message)
    end)
end

-- Register key bindings
RegisterKeyBind(Key.F5, function() SpawnPaintCan(); return false end)
RegisterKeyBind(Key.F6, function() SpawnRustBrush(); return false end)
RegisterKeyBind(Key.F7, function() SpawnPolishBrush(); return false end)
RegisterKeyBind(Key.OEM_FOUR, function() CycleColor(-1); return false end)  -- [
RegisterKeyBind(Key.OEM_SIX, function() CycleColor(1); return false end)    -- ]
RegisterKeyBind(Key.OEM_FIVE, function() ToggleSheen(); return false end)   -- \

print("[SuperSprayPaintMod] Controls: F5 to spawn a spray paint can")
print("[SuperSprayPaintMod] Controls: F6 to spawn a rust brush")
print("[SuperSprayPaintMod] Controls: F7 to spawn a polish sponge")
print("[SuperSprayPaintMod] Controls: [ or ] to cycle colors")
print("[SuperSprayPaintMod] Controls: \\ to toggle metallic/matte sheen")
print("[SuperSprayPaintMod] Current color will be displayed in the in-game chat when cycling colors or spawning paint")
