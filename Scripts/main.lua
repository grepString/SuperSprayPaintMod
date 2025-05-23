-- SuperSprayPaintMod for Drive Beyond Horizons

print("[SuperSprayPaintMod] Mod loaded")

local CONFIG = {
    GROUND_OFFSET = 80,
    FORWARD_DISTANCE = 150,
    GROUND_CLEARANCE = 20,
    INFINITE_QUANTITY = 999999,
    ENABLE_CHAT_MESSAGES = true
}

local TOOL_PATHS = {
    PAINT_BOMB = "/Game/BP/Items/Movable/PaintBomb/PaintBomb.PaintBomb_C",
    RUST_BRUSH = "/Game/BP/Items/Movable/Tools/RustBrush.RustBrush_C",
    POLISH_BRUSH = "/Game/BP/Items/Movable/Tools/PolishBrush.PolishBrush_C"
}

-- https://teamcolorcodes.com/
-- Use the included rgb_converter.html to add more colors

local Colors = {
    { name = "[Basic Colors]", color = { R = 0, G = 0, B = 0, A = 0 } },
    { name = "Blue", color = { R = 0, G = 0, B = 1, A = 1 } },
    { name = "Red", color = { R = 1, G = 0, B = 0, A = 1 } },
    { name = "Green", color = { R = 0, G = 1, B = 0, A = 1 } },
    { name = "Yellow", color = { R = 1, G = 1, B = 0, A = 1 } },
    { name = "Orange", color = { R = 1, G = 0.5, B = 0, A = 1 } },
    { name = "Purple", color = { R = 0.5, G = 0, B = 0.5, A = 1 } },
    { name = "Viola Purple", color = { R = 0.494, G = 0.345, B = 0.494, A = 1 } },
    { name = "Pink", color = { R = 1, G = 0.75, B = 0.8, A = 1 } },
    { name = "Black", color = { R = 0, G = 0, B = 0, A = 1 } },
    { name = "White", color = { R = 1, G = 1, B = 1, A = 1 } },
    { name = "Gold", color = { R = 1, G = 0.84, B = 0, A = 1 } },
    { name = "Silver", color = { R = 0.45, G = 0.45, B = 0.5, A = 1 } },
    { name = "Cyan", color = { R = 0.298, G = 0.792, B = 0.784, A = 1 } },
    { name = "[F1 Racing Team Colors]", color = { R = 0, G = 0, B = 0, A = 0 } },
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
    { name = "Williams Racing Sky Blue", color = { R = 0, G = 0.627, B = 0.871, A = 1 } },
    { name = "[Vintage Military Colors]", color = { R = 0, G = 0, B = 0, A = 0 } },
    { name = "Soviet 4BO Green", color = { R = 0.314, G = 0.329, B = 0.239, A = 1 } },
    { name = "US Olive Drab", color = { R = 0.282, G = 0.353, B = 0.251, A = 1 } },
    { name = "US Desert Sand", color = { R = 0.780, G = 0.706, B = 0.620, A = 1 } },
    { name = "US Navy Blue‑Gray", color = { R = 0.290, G = 0.329, B = 0.380, A = 1 } },
    { name = "US Intermediate Blue", color = { R = 0.439, G = 0.518, B = 0.596, A = 1 } },
    { name = "German Panzergrau", color = { R = 0.290, G = 0.310, B = 0.333, A = 1 } },
    { name = "German Dunkelgelb", color = { R = 0.690, G = 0.604, B = 0.420, A = 1 } },
    { name = "German Olivgrün", color = { R = 0.420, G = 0.420, B = 0.278, A = 1 } },
    { name = "German Rotbraun", color = { R = 0.416, G = 0.243, B = 0.208, A = 1 } },
    { name = "Luftwaffe Grau", color = { R = 0.541, G = 0.541, B = 0.482, A = 1 } },
    { name = "Luftwaffe Schwarzgrün", color = { R = 0.227, G = 0.251, B = 0.208, A = 1 } },
    { name = "Luftwaffe Dunkelgrün", color = { R = 0.275, G = 0.290, B = 0.235, A = 1 } },
    { name = "UK Khaki Green No.3", color = { R = 0.373, G = 0.361, B = 0.247, A = 1 } },
    { name = "UK SCC No.2 Khaki Drab", color = { R = 0.482, G = 0.412, B = 0.318, A = 1 } },
    { name = "UK SCC No.1A Dark Brown", color = { R = 0.302, G = 0.251, B = 0.212, A = 1 } },
    { name = "UK SCC No.15 Olive Drab", color = { R = 0.369, G = 0.365, B = 0.278, A = 1 } },
    { name = "RAF Dark Earth", color = { R = 0.475, G = 0.408, B = 0.329, A = 1 } },
    { name = "RAF Dark Green", color = { R = 0.290, G = 0.329, B = 0.267, A = 1 } },
    { name = "RAF Sky", color = { R = 0.635, G = 0.718, B = 0.659, A = 1 } },
    { name = "NATO Green", color = { R = 0.294, G = 0.325, B = 0.220, A = 1 } },
    { name = "NATO Gelboliv", color = { R = 0.325, G = 0.310, B = 0.235, A = 1 } }
}

local currentColorIndex, isMetallic = 1, false
local currentPaintBomb, currentRustBrush, currentPolishBrush = nil, nil, nil
local spawnedTools = {}

local function ShowInGameChatMessage(message)
    if not CONFIG.ENABLE_CHAT_MESSAGES then return end

    local formattedMessage = "[SSPM] " .. message

    print("[SuperSprayPaintMod] " .. message)

    local pc = FindFirstOf("PlayerController")
    if not pc or not pc:IsValid() then return end

    pcall(function()
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

local function HasProperty(obj, propName)
    if not obj then return false end
    local success, result = pcall(function() return obj[propName] ~= nil end)
    return success and result
end

local function SetInfiniteToolProperties(tool)
    if not tool or not tool:IsValid() then return end

    tool.Quantity = CONFIG.INFINITE_QUANTITY
    tool.MinQuantity = 0
    tool.MaxQuantity = CONFIG.INFINITE_QUANTITY

    pcall(function()
        if HasProperty(tool, "OnRep_Quantity") then tool:OnRep_Quantity() end
    end)
end

local function SetPaintBombProperties(paintBomb, colorData, isMetallic)
    if not paintBomb or not paintBomb:IsValid() then return end

    local color = colorData.color

    paintBomb.Color = color

    paintBomb.Metallic = isMetallic and 1.0 or 0.0

    SetInfiniteToolProperties(paintBomb)

    if HasProperty(paintBomb, "ApplicationAmount") then
        paintBomb.ApplicationAmount = 1.0
    end

    if HasProperty(paintBomb, "ApplicationRate") then
        paintBomb.ApplicationRate = 1.0
    end

    if HasProperty(paintBomb, "PaintAmount") then
        paintBomb.PaintAmount = 1.0
    end

    if HasProperty(paintBomb, "PaintCoverage") then
        paintBomb.PaintCoverage = 0.5
    end

    if HasProperty(paintBomb, "PaintRate") then
        paintBomb.PaintRate = 1.0
    end

    if HasProperty(paintBomb, "SprayAmount") then
        paintBomb.SprayAmount = 1.0
    end

    if HasProperty(paintBomb, "SprayRate") then
        paintBomb.SprayRate = 1.0
    end

    pcall(function()
        if HasProperty(paintBomb, "OnRep_Color") then paintBomb:OnRep_Color() end
        if HasProperty(paintBomb, "OnRep_Metallic") then paintBomb:OnRep_Metallic() end
    end)
end

local function DestroyTool(tool)
    if tool and tool:IsValid() then
        local success, _ = pcall(function() return tool:K2_DestroyActor() end)
        if not success then
            print("[SuperSprayPaintMod] Warning: Failed to destroy tool: " .. tostring(tool))
        end
    end
end

local function DestroyAllSpawnedTools()
    print("[SuperSprayPaintMod] Destroying all spawned tools...")
    for i = #spawnedTools, 1, -1 do
        local tool = spawnedTools[i]
        DestroyTool(tool)
        table.remove(spawnedTools, i)
    end
    spawnedTools = {}
    currentPaintBomb = nil
    currentRustBrush = nil
    currentPolishBrush = nil
    print("[SuperSprayPaintMod] All spawned tools destroyed.")
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

    local location = pawn:K2_GetActorLocation()
    local yaw = (pawn:K2_GetActorRotation().Yaw or 0)
    local yawRad = yaw * (math.pi / 180.0)
    local spawnPos = {
        X = location.X + (math.cos(yawRad) * CONFIG.FORWARD_DISTANCE),
        Y = location.Y + (math.sin(yawRad) * CONFIG.FORWARD_DISTANCE),
        Z = (location.Z - CONFIG.GROUND_OFFSET) + CONFIG.GROUND_CLEARANCE
    }

    local world = pawn:GetWorld()
    local success, result = pcall(function()
        return world:SpawnActor(toolClass, spawnPos, {Pitch=0, Yaw=yaw, Roll=0})
    end)

    if success and result then
        table.insert(spawnedTools, result)
        if callback then
            callback(result)
        end
        return result
    else
        print("[SuperSprayPaintMod] Error: Failed to spawn " .. toolName)
        return nil
    end
end

function SpawnPaintCan()
    if currentPaintBomb and currentPaintBomb:IsValid() then
        print("[SuperSprayPaintMod] Destroying previous paint bomb.")
        DestroyTool(currentPaintBomb)
        for i = #spawnedTools, 1, -1 do
            if spawnedTools[i] == currentPaintBomb then
                table.remove(spawnedTools, i)
                break
            end
        end
    end

    local result = SpawnTool(TOOL_PATHS.PAINT_BOMB, "PaintBomb", function(paintBomb)
        currentPaintBomb = paintBomb
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)

        local colorName = Colors[currentColorIndex].name
        local sheenType = isMetallic and "Metallic" or "Matte"
        local message = string.format("Spawned %s %s paint", colorName, sheenType)

        print("[SuperSprayPaintMod] " .. message)
        ShowInGameChatMessage(message)
    end)
    return result
end

local function UpdatePaintCan()
    if currentPaintBomb and currentPaintBomb:IsValid() then
        SetPaintBombProperties(currentPaintBomb, Colors[currentColorIndex], isMetallic)
    end
end

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

function SpawnRustBrush()
    if currentRustBrush and currentRustBrush:IsValid() then
        print("[SuperSprayPaintMod] Destroying previous rust brush.")
        DestroyTool(currentRustBrush)
        for i = #spawnedTools, 1, -1 do
            if spawnedTools[i] == currentRustBrush then
                table.remove(spawnedTools, i)
                break
            end
        end
    end

    local result = SpawnTool(TOOL_PATHS.RUST_BRUSH, "RustBrush", function(brush)
        currentRustBrush = brush
        SetInfiniteToolProperties(brush)
        local message = "Spawned Rust Brush with infinite usage"
        print("[SuperSprayPaintMod] " .. message)
        ShowInGameChatMessage(message)
    end)
    return result
end

function SpawnPolishBrush()
    if currentPolishBrush and currentPolishBrush:IsValid() then
        print("[SuperSprayPaintMod] Destroying previous polish brush.")
        DestroyTool(currentPolishBrush)
        for i = #spawnedTools, 1, -1 do
            if spawnedTools[i] == currentPolishBrush then
                table.remove(spawnedTools, i)
                break
            end
        end
    end

    local result = SpawnTool(TOOL_PATHS.POLISH_BRUSH, "PolishBrush", function(brush)
        currentPolishBrush = brush
        SetInfiniteToolProperties(brush)
        local message = "Spawned Polish Sponge with infinite usage"
        print("[SuperSprayPaintMod] " .. message)
        ShowInGameChatMessage(message)
    end)
    return result
end

RegisterKeyBind(Key.F5, function() SpawnPaintCan(); return false end)
RegisterKeyBind(Key.F6, function() SpawnRustBrush(); return false end)
RegisterKeyBind(Key.F7, function() SpawnPolishBrush(); return false end)
RegisterKeyBind(Key.OEM_FOUR, function() CycleColor(-1); return false end)  -- [
RegisterKeyBind(Key.OEM_SIX, function() CycleColor(1); return false end)    -- ]
RegisterKeyBind(Key.OEM_FIVE, function() ToggleSheen(); return false end)   -- \

function OnModuleUnload()
    print("[SuperSprayPaintMod] Mod unloading. Cleaning up...")
    DestroyAllSpawnedTools()
    print("[SuperSprayPaintMod] Mod unloaded.")
end

print("[SuperSprayPaintMod] Controls: F5 to spawn a spray paint can")
print("[SuperSprayPaintMod] Controls: F6 to spawn a rust brush")
print("[SuperSprayPaintMod] Controls: F7 to spawn a polish sponge")
print("[SuperSprayPaintMod] Controls: [ or ] to cycle colors")
print("[SuperSprayPaintMod] Controls: \\ to toggle metallic/matte sheen")
print("[SuperSprayPaintMod] Current color will be displayed in the in-game chat when cycling colors or spawning paint")