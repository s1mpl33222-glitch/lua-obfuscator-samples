do
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local STATE_KEY = "__BS_UI_STATE"
local FADE_DURATION = 0.70
local FADE_PHASE_DURATION = 0.80
local LOAD_DURATION = 2.00
local FULL_HOLD_DURATION = 0.15
local MOVE_DURATION = 0.75
local PANEL_WIDTH = 340
local PANEL_HEIGHT = 165
local COMPACT_WIDTH = 118
local COMPACT_HEIGHT = 34
local COMPACT_LEFT_OFFSET = 130
local COMPACT_TOP_OFFSET = 46

local previous = _G[STATE_KEY]
if type(previous) == "table" and type(previous.Destroy) == "function" then
    pcall(previous.Destroy)
end

local state = {
    running = true,
    drawings = {},
    connection = nil,
    geometry = {},
}
_G[STATE_KEY] = state

local function clamp(value, minimum, maximum)
    if value < minimum then
        return minimum
    end
    if value > maximum then
        return maximum
    end
    return value
end

local function lerp(a, b, amount)
    return a + (b - a) * amount
end

local function easeOutCubic(value)
    local inverse = 1 - clamp(value, 0, 1)
    return 1 - inverse * inverse * inverse
end

local function easeInOutCubic(value)
    value = clamp(value, 0, 1)
    if value < 0.5 then
        return 4 * value * value * value
    end
    local inverse = -2 * value + 2
    return 1 - inverse * inverse * inverse / 2
end

local function add(kind)
    local object = Drawing.new(kind)
    object.Visible = false
    state.drawings[#state.drawings + 1] = object
    return object
end

local function square(color, filled, zIndex, corner)
    local object = add("Square")
    object.Color = color
    object.Filled = filled
    object.Thickness = filled and 1 or 1.25
    object.ZIndex = zIndex
    if corner then
        pcall(function()
            object.Corner = corner
        end)
    end
    return object
end

local function text(value, color, size, font, zIndex, centered)
    local object = add("Text")
    object.Text = value
    object.Color = color
    object.Size = size
    object.Font = font
    object.Center = centered ~= false
    object.Outline = false
    object.ZIndex = zIndex
    return object
end

local function circle(color, radius, zIndex)
    local object = add("Circle")
    object.Color = color
    object.Radius = radius
    object.NumSides = 36
    object.Filled = true
    object.Thickness = 1
    object.ZIndex = zIndex
    return object
end

local function spacedText(value, color, size, font, zIndex, spacing)
    local group = {
        characters = {},
        widths = {},
        spacing = spacing,
    }
    for index = 1, #value do
        local characterValue = value:sub(index, index)
        group.characters[index] = text(characterValue, color, size, font, zIndex, true)
        group.widths[index] = characterValue == " " and size * 0.35 or size * 0.55
    end
    return group
end

local function positionSpacedText(group, centerX, y)
    local count = #group.characters
    local totalWidth = group.spacing * math.max(count - 1, 0)
    for index, character in ipairs(group.characters) do
        local bounds = character.TextBounds
        if bounds and bounds.X and bounds.X > 0 then
            group.widths[index] = bounds.X
        end
        totalWidth = totalWidth + group.widths[index]
    end

    local cursor = centerX - totalWidth * 0.5
    for index, character in ipairs(group.characters) do
        local width = group.widths[index]
        character.Position = Vector2.new(cursor + width * 0.5, y)
        cursor = cursor + width + group.spacing
    end
end

local function setGroupOpacity(group, opacity)
    for _, character in ipairs(group.characters) do
        character.Transparency = clamp(opacity, 0, 1)
    end
end

local panel = square(Color3.fromRGB(13, 16, 23), true, 10, 12)
local border = square(Color3.fromRGB(255, 255, 255), false, 11, 12)
local innerBorder = square(Color3.fromRGB(255, 255, 255), false, 12, 11)

local title = text("BloxStrike", Color3.fromRGB(232, 234, 240), 28, 2, 19, true)
local subtitle = spacedText("SKIN CHANGER", Color3.fromRGB(150, 170, 200), 13, 0, 19, 4.6)
local loadingLabel = text("Loading Assets...", Color3.fromRGB(120, 140, 170), 10, 5, 19, false)
local percentLabel = text("0%", Color3.fromRGB(120, 140, 170), 10, 5, 19, true)

local barGlowWide = square(Color3.fromRGB(96, 165, 250), true, 13, 5)
local barGlowTight = square(Color3.fromRGB(96, 165, 250), true, 14, 3)
local barTrack = square(Color3.fromRGB(255, 255, 255), true, 15, 2)
local barSegments = {}
local BAR_SEGMENT_COUNT = 18
for index = 1, BAR_SEGMENT_COUNT do
    local amount = (index - 1) / (BAR_SEGMENT_COUNT - 1)
    local red = math.floor(59 + (147 - 59) * amount + 0.5)
    local green = math.floor(130 + (197 - 130) * amount + 0.5)
    local blue = math.floor(246 + (253 - 246) * amount + 0.5)
    barSegments[index] = square(Color3.fromRGB(red, green, blue), true, 16, 2)
end

local statusText = text("Skin Changer", Color3.fromRGB(226, 232, 240), 12, 2, 19, true)
local dotGlowOuter = circle(Color3.fromRGB(34, 197, 94), 11, 15)
local dotGlowInner = circle(Color3.fromRGB(34, 197, 94), 7, 16)
local dot = circle(Color3.fromRGB(34, 197, 94), 4, 17)

local function setOpacity(object, opacity)
    object.Transparency = clamp(opacity, 0, 1)
end

local function setRect(object, x, y, width, height)
    object.Position = Vector2.new(x, y)
    object.Size = Vector2.new(math.max(width, 0.01), math.max(height, 0.01))
end

local function setCorner(object, radius)
    pcall(function()
        object.Corner = radius
    end)
end

local function viewportSize()
    local size = Camera and Camera.ViewportSize
    if size then
        return size.X, size.Y
    end
    return 1920, 1080
end

local function destroy()
    if not state.running then
        return
    end
    state.running = false
    if state.connection then
        pcall(function()
            state.connection:Disconnect()
        end)
        state.connection = nil
    end
    for _, object in ipairs(state.drawings) do
        pcall(function()
            object:Remove()
        end)
    end
    state.drawings = {}
    if _G[STATE_KEY] == state then
        _G[STATE_KEY] = nil
    end
end

state.Destroy = destroy
_G.__BS_UI_STOP = destroy

local startedAt = os.clock()
state.connection = RunService.RenderStepped:Connect(function()
    if not state.running or _G[STATE_KEY] ~= state then
        destroy()
        return
    end

    local now = os.clock()
    local elapsed = now - startedAt
    local screenWidth, screenHeight = viewportSize()

    local fade = easeOutCubic(elapsed / FADE_DURATION)
    local loadElapsed = math.max(elapsed - FADE_PHASE_DURATION, 0)
    local progress = clamp(loadElapsed / LOAD_DURATION, 0, 1)
    local moveStart = FADE_PHASE_DURATION + LOAD_DURATION + FULL_HOLD_DURATION
    local moveRaw = clamp((elapsed - moveStart) / MOVE_DURATION, 0, 1)
    local move = easeInOutCubic(moveRaw)

    if elapsed < FADE_PHASE_DURATION then
        state.phase = "fadeIn"
    elseif progress < 1 then
        state.phase = "loading"
    elseif elapsed < moveStart then
        state.phase = "hold"
    elseif moveRaw < 1 then
        state.phase = "dragging"
    else
        state.phase = "active"
    end
    state.elapsed = elapsed
    state.progress = progress

    local entranceScale = lerp(0.97, 1, fade)
    local splashWidth = PANEL_WIDTH * entranceScale
    local splashHeight = PANEL_HEIGHT * entranceScale
    local startX = (screenWidth - splashWidth) * 0.5
    local startY = (screenHeight - splashHeight) * 0.5 + lerp(PANEL_HEIGHT * 0.02, 0, fade)
    local endX = screenWidth - COMPACT_LEFT_OFFSET
    local endY = screenHeight - COMPACT_TOP_OFFSET

    local width = lerp(splashWidth, COMPACT_WIDTH, move)
    local height = lerp(splashHeight, COMPACT_HEIGHT, move)
    local x = lerp(startX, endX, move)
    local y = lerp(startY, endY, move)

    state.geometry.x = x
    state.geometry.y = y
    state.geometry.width = width
    state.geometry.height = height

    local panelCorner = lerp(12, 10, move)
    setRect(panel, x, y, width, height)
    setRect(border, x, y, width, height)
    setRect(innerBorder, x + 1, y + 1, math.max(width - 2, 1), math.max(height - 2, 1))
    setCorner(panel, panelCorner)
    setCorner(border, panelCorner)
    setCorner(innerBorder, math.max(panelCorner - 1, 0))
    setOpacity(panel, fade * lerp(0.97, 0.55, move))
    setOpacity(border, fade * 0.07)
    setOpacity(innerBorder, fade * 0.04 * (1 - move))

    local splashOpacity = moveRaw > 0 and 0 or fade
    title.Position = Vector2.new(x + width * 0.5, y + 32)
    positionSpacedText(subtitle, x + width * 0.5, y + 67)
    setOpacity(title, splashOpacity)
    setGroupOpacity(subtitle, splashOpacity * 0.70)

    local barX = x + 36
    local barY = y + 111
    local barWidth = math.max(width - 72, 1)
    local filledWidth = barWidth * progress
    setRect(barTrack, barX, barY, barWidth, 3)
    setOpacity(barTrack, splashOpacity * 0.06)
    setRect(barGlowWide, barX - 3, barY - 4, math.max(filledWidth + 6, 0.01), 11)
    setRect(barGlowTight, barX - 1, barY - 2, math.max(filledWidth + 2, 0.01), 7)
    setOpacity(barGlowWide, filledWidth > 0 and splashOpacity * 0.10 or 0)
    setOpacity(barGlowTight, filledWidth > 0 and splashOpacity * 0.22 or 0)

    local segmentWidth = barWidth / BAR_SEGMENT_COUNT
    for index, segment in ipairs(barSegments) do
        local segmentStart = (index - 1) * segmentWidth
        local visibleWidth = clamp(filledWidth - segmentStart, 0, segmentWidth + 0.35)
        setRect(segment, barX + segmentStart, barY, math.max(visibleWidth, 0.01), 3)
        setOpacity(segment, visibleWidth > 0 and splashOpacity or 0)
    end

    loadingLabel.Position = Vector2.new(barX, y + 122)
    percentLabel.Position = Vector2.new(barX + barWidth - 10, y + 122)
    percentLabel.Text = tostring(math.floor(progress * 100 + 0.5)) .. "%"
    setOpacity(loadingLabel, splashOpacity * 0.60)
    setOpacity(percentLabel, splashOpacity * 0.60)

    local compactOpacity = 0
    if moveRaw > 0 then
        compactOpacity = moveRaw < 1 and 0.60 or 1
    end
    local dotX = x + 15
    local dotY = y + height * 0.5
    local compactTextCenterX = x + ((13 + 4) + COMPACT_WIDTH) * 0.5
    statusText.Position = Vector2.new(compactTextCenterX, y + math.floor((height - 12) * 0.5 + 5.5))

    local pulse = 0.5 - 0.5 * math.cos(now * math.pi)
    dotGlowOuter.Position = Vector2.new(dotX, dotY)
    dotGlowInner.Position = Vector2.new(dotX, dotY)
    dot.Position = Vector2.new(dotX, dotY)
    dotGlowOuter.Radius = 7 + pulse * 4
    dotGlowInner.Radius = 5 + pulse * 3

    setOpacity(statusText, compactOpacity)
    setOpacity(dotGlowOuter, compactOpacity * (0.18 + pulse * 0.17))
    setOpacity(dotGlowInner, compactOpacity * (0.35 + pulse * 0.25))
    setOpacity(dot, compactOpacity)

    if not state.shown then
        for _, object in ipairs(state.drawings) do
            object.Visible = true
        end
        state.shown = true
    end
end)

print("[BS-UI] Loading animation started")
end

task.spawn(function()
task.wait()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:FindFirstChild("Assets")
local Weapons = Assets and Assets:FindFirstChild("Weapons")
local Skins = Assets and Assets:FindFirstChild("Skins")
local WeaponAnimations = Assets and Assets:FindFirstChild("WeaponAnimations")
local WeaponModules = ReplicatedStorage:FindFirstChild("Database")
WeaponModules = WeaponModules and WeaponModules:FindFirstChild("Custom")
WeaponModules = WeaponModules and WeaponModules:FindFirstChild("Weapons")

local STATE_KEY = "__BS_SKIN_CHANGER_STATE"
local TEST_API_KEY = "__BS_SKIN_CHANGER_TEST_API"
local OFF = {
    Parent = 104,
    NameContainer = 112,
    Children = 120,
}
local WEAR_ORDER = {
    "Factory New",
    "Minimal Wear",
    "Field-Tested",
    "Well-Worn",
    "Battle-Scarred",
}
local CONFIG_PATHS = {
    "C:/matcha/BS-Config.lua",
    "BS-Config.lua",
    "workspace/BS-Config.lua",
}

local function trim(value)
    return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalize(value)
    return trim(value):lower():gsub("[^%w]", "")
end

local function normalizeTeam(value)
    local key = normalize(value)
    if key == "ct" or key == "counterterrorist" or key == "counterterrorists" then
        return "CT"
    end
    if key == "t" or key == "terrorist" or key == "terrorists" then
        return "T"
    end
    return nil
end

local function readCurrentTeam(playersService)
    local player = playersService and playersService.LocalPlayer
    if not player then
        return nil
    end

    local okAttribute, attribute = pcall(function()
        return player:GetAttribute("Team")
    end)
    local team = okAttribute and normalizeTeam(attribute) or nil
    if team then
        return team
    end

    local okTeam, playerTeam = pcall(function()
        return player.Team
    end)
    return okTeam and playerTeam and normalizeTeam(playerTeam.Name) or nil
end

local function startTeamWatcher(runService, state, playersService, applyTeam, isCurrent)
    local elapsed = 0
    local connection = nil
    connection = runService.Heartbeat:Connect(function(deltaTime)
        if not state.running or not isCurrent() then
            connection:Disconnect()
            state.teamConnection = nil
            return
        end

        elapsed = elapsed + (tonumber(deltaTime) or 0.1)
        if elapsed < 0.1 then
            return
        end
        elapsed = 0
        state.teamWatchChecks = (state.teamWatchChecks or 0) + 1

        local team = readCurrentTeam(playersService)
        if team and team ~= state.team then
            applyTeam(team)
        end
    end)
    state.teamConnection = connection
    return connection
end

local function parseConfig(text)
    local parsed = { CT = {}, T = {} }
    local indexes = { CT = {}, T = {} }
    local errors = {}
    local section = nil
    local lineNumber = 0

    text = tostring(text or "")
    if text:sub(1, 3) == string.char(239, 187, 191) then
        text = text:sub(4)
    end

    for rawLine in (text .. "\n"):gmatch("(.-)\n") do
        lineNumber = lineNumber + 1
        local line = rawLine:gsub("\r", "")
        line = line:gsub("%s+%-%-.*$", "")
        line = trim(line)

        if line ~= "" and line:sub(1, 1) ~= "#" and line:sub(1, 2) ~= "--" then
            local header = line:match("^(.-)%s*:%s*$")
            if header then
                section = normalizeTeam(header)
                if not section then
                    errors[#errors + 1] = "line " .. lineNumber .. ": unknown team header '" .. header .. "'"
                end
            else
                local equals = line:find("=", 1, true)
                if not section then
                    errors[#errors + 1] = "line " .. lineNumber .. ": entry appears before a team header: " .. line
                elseif not equals then
                    errors[#errors + 1] = "line " .. lineNumber .. ": malformed entry: " .. line
                else
                    local item = trim(line:sub(1, equals - 1))
                    local skin = trim(line:sub(equals + 1))
                    if item == "" or skin == "" then
                        errors[#errors + 1] = "line " .. lineNumber .. ": item and skin must both be present"
                    else
                        local itemKey = item:lower()
                        local existing = indexes[section][itemKey]
                        local entry = { item = item, skin = skin, line = lineNumber }
                        if existing then
                            parsed[section][existing] = entry
                        else
                            parsed[section][#parsed[section] + 1] = entry
                            indexes[section][itemKey] = #parsed[section]
                        end
                    end
                end
            end
        end
    end

    return parsed, errors
end

local function findChildInsensitive(parent, wanted)
    if not parent then
        return nil
    end
    local direct = parent:FindFirstChild(wanted)
    if direct then
        return direct
    end
    local wantedLower = trim(wanted):lower()
    local wantedNormalized = normalize(wanted)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name:lower() == wantedLower or normalize(child.Name) == wantedNormalized then
            return child
        end
    end
    return nil
end

local function resolveSkinFolder(itemName, requestedSkin)
    local weaponSkins = findChildInsensitive(Skins, itemName)
    if not weaponSkins then
        return nil, "skin catalog not found for " .. itemName
    end

    local exact = findChildInsensitive(weaponSkins, requestedSkin)
    if exact then
        return exact
    end

    local lowered = trim(requestedSkin):lower()
    local base, number = lowered:match("^(.-)%s+phase%s*(%d+)$")
    if not base then
        base, number = lowered:match("^(.-)%s+pattern%s*(%d+)$")
    end
    if base and number then
        local patternName = normalize(base)
        for _, child in ipairs(weaponSkins:GetChildren()) do
            local childLower = child.Name:lower()
            local childBase, childNumber = childLower:match("^(.-)_pattern_(%d+)$")
            if childBase and normalize(childBase) == patternName and childNumber == number then
                return child
            end
        end
    end

    return nil, "skin '" .. requestedSkin .. "' not found for " .. itemName
end

local function itemClass(itemName)
    local weaponFolder = findChildInsensitive(Weapons, itemName)
    if weaponFolder and weaponFolder:FindFirstChild("Left Arm") and weaponFolder:FindFirstChild("Right Arm") then
        return "Glove"
    end

    local module = findChildInsensitive(WeaponModules, itemName)
    if module and typeof(decompile) == "function" then
        local ok, source = pcall(decompile, module)
        if ok and type(source) == "string" then
            local class = source:match('%["Class"%]%s*=%s*"([^"]+)"')
                or source:match('Class%s*=%s*"([^"]+)"')
            if class == "Melee" or class == "Glove" or class == "Weapon" then
                return class
            end
        end
    end

    local key = normalize(itemName)
    if key:find("knife", 1, true)
        or key == "karambit"
        or key:find("bayonet", 1, true)
        or key:find("dagger", 1, true)
        or key:find("kukri", 1, true) then
        return "Melee"
    end
    return "Weapon"
end

local function selectWear(modeFolder)
    if not modeFolder then
        return nil
    end
    for _, wearName in ipairs(WEAR_ORDER) do
        local wear = modeFolder:FindFirstChild(wearName)
        if wear then
            return wear
        end
    end
    local children = modeFolder:GetChildren()
    return children[1]
end

local function buildTeamJobs(teamName, parsed)
    local team = normalizeTeam(teamName)
    local errors = {}
    local jobs = {}
    if not team then
        return jobs, { "unknown active team: " .. tostring(teamName) }
    end

    local entries = parsed and parsed[team] or nil
    if type(entries) ~= "table" then
        return jobs, { "no configuration section for " .. team }
    end

    for _, entry in ipairs(entries) do
        local kind = itemClass(entry.item)
        local sourceName = entry.item
        if kind == "Melee" then
            sourceName = team == "CT" and "CT Knife" or "T Knife"
        elseif kind == "Glove" then
            sourceName = team == "CT" and "CT Glove" or "T Glove"
        end

        local sourceWeapon = findChildInsensitive(Weapons, sourceName)
        local targetWeapon = findChildInsensitive(Weapons, entry.item)
        local sourceSkins = findChildInsensitive(Skins, sourceName)
        local targetSkin, skinError = resolveSkinFolder(entry.item, entry.skin)

        local problem = nil
        if not sourceWeapon then
            problem = "base asset '" .. sourceName .. "' was not found"
        elseif not targetWeapon then
            problem = "weapon asset '" .. entry.item .. "' was not found"
        elseif not sourceSkins then
            problem = "skin catalog was not found for " .. sourceName
        elseif not targetSkin then
            problem = skinError
        else
            for _, modeName in ipairs({ "Camera", "Character" }) do
                local targetMode = targetSkin:FindFirstChild(modeName)
                if not selectWear(targetMode) then
                    problem = entry.item .. " " .. entry.skin .. " has no " .. modeName .. " wear template"
                    break
                end
            end
        end

        if problem then
            errors[#errors + 1] = "line " .. tostring(entry.line or "?") .. ": " .. problem
        else
            jobs[#jobs + 1] = {
                item = entry.item,
                skin = entry.skin,
                kind = kind,
                source = sourceName,
                sourceWeapon = sourceWeapon,
                targetWeapon = targetWeapon,
                sourceSkins = sourceSkins,
                targetSkin = targetSkin,
                targetSkinName = targetSkin.Name,
                sourceAnimations = WeaponAnimations and findChildInsensitive(WeaponAnimations, sourceName),
                targetAnimations = WeaponAnimations and findChildInsensitive(WeaponAnimations, entry.item),
            }
        end
    end

    return jobs, errors
end

local function buildActiveJobs(teamName, parsed)
    local team = normalizeTeam(teamName)
    if not team then
        return {}, { "unknown active team: " .. tostring(teamName) }
    end

    local jobs = {}
    local errors = {}
    for _, equipmentTeam in ipairs({ "CT", "T" }) do
        local equipmentJobs, equipmentErrors = buildTeamJobs(equipmentTeam, parsed)
        for _, message in ipairs(equipmentErrors) do
            errors[#errors + 1] = equipmentTeam .. ": " .. message
        end
        for _, job in ipairs(equipmentJobs) do
            if job.kind == "Melee" or job.kind == "Glove" then
                jobs[#jobs + 1] = job
            end
        end
    end

    local activeJobs, activeErrors = buildTeamJobs(team, parsed)
    for _, message in ipairs(activeErrors) do
        errors[#errors + 1] = team .. ": " .. message
    end
    for _, job in ipairs(activeJobs) do
        if job.kind == "Weapon" then
            jobs[#jobs + 1] = job
        end
    end
    return jobs, errors
end

_G[TEST_API_KEY] = {
    ParseConfig = parseConfig,
    NormalizeTeam = normalizeTeam,
    ResolveSkinFolder = resolveSkinFolder,
    ItemClass = itemClass,
    BuildTeamJobs = buildTeamJobs,
    BuildActiveJobs = buildActiveJobs,
    ReadCurrentTeam = readCurrentTeam,
    StartTeamWatcher = startTeamWatcher,
}

local function rd(address)
    local ok, value = pcall(memory_read, "uintptr_t", address)
    return ok and value or nil
end

local function wr(address, value)
    local ok = pcall(memory_write, "uintptr_t", address, value)
    return ok
end

local function childBounds(parent)
    if not parent or not parent.Address then
        return nil
    end
    local vector = rd(parent.Address + OFF.Children)
    if not vector or vector == 0 then
        return nil
    end
    return rd(vector), rd(vector + 8)
end

local function findSlot(instance, parent)
    if not instance or not instance.Address or not parent or not parent.Address then
        return nil
    end
    local first, last = childBounds(parent)
    if not first or not last then
        return nil
    end
    for slot = first, last - 16, 16 do
        if rd(slot) == instance.Address then
            return slot
        end
    end
    return nil
end

local function restoreSwaps(restores)
    if type(restores) ~= "table" then
        return 0
    end
    local restored = 0
    for index = #restores, 1, -1 do
        local record = restores[index]
        if record.slot and record.oldAddress then
            wr(record.slot, record.oldAddress)
            if record.oldCtrl then
                wr(record.slot + 8, record.oldCtrl)
            end
            restored = restored + 1
        elseif record.slotA and record.slotB and record.a and record.b then
            wr(record.slotA, record.a)
            if record.ctrlA then
                wr(record.slotA + 8, record.ctrlA)
            end
            wr(record.slotB, record.b)
            if record.ctrlB then
                wr(record.slotB + 8, record.ctrlB)
            end
            if record.nameA then
                wr(record.a + OFF.NameContainer, record.nameA)
            end
            if record.nameB then
                wr(record.b + OFF.NameContainer, record.nameB)
            end
            if record.parentA then
                wr(record.a + OFF.Parent, record.parentA)
            end
            if record.parentB then
                wr(record.b + OFF.Parent, record.parentB)
            end
            restored = restored + 1
        end
    end
    return restored
end

local function prepareAlias(plans, usedSlots, source, target, sourceParent, targetParent, label, errors)
    if not source or not target or not sourceParent or not targetParent then
        errors[#errors + 1] = label .. ": missing instance or parent"
        return
    end
    if source.Address == target.Address then
        return
    end
    local sourceSlot = findSlot(source, sourceParent)
    local targetSlot = findSlot(target, targetParent)
    local sourceParentAddress = rd(source.Address + OFF.Parent)
    local targetParentAddress = rd(target.Address + OFF.Parent)
    if not sourceSlot or not targetSlot
        or sourceParentAddress ~= sourceParent.Address
        or targetParentAddress ~= targetParent.Address then
        errors[#errors + 1] = label .. ": could not validate live child slots"
        return
    end
    if usedSlots[sourceSlot] then
        errors[#errors + 1] = label .. ": source slot conflicts with another configured alias"
        return
    end
    usedSlots[sourceSlot] = true
    plans[#plans + 1] = {
        label = label,
        slot = sourceSlot,
        oldAddress = source.Address,
        oldCtrl = rd(sourceSlot + 8),
        targetAddress = target.Address,
        targetCtrl = rd(targetSlot + 8),
    }
end

local function addSkinAliases(job, plans, usedSlots, errors)
    for _, modeName in ipairs({ "Camera", "Character" }) do
        local targetMode = job.targetSkin:FindFirstChild(modeName)
        local targetWear = selectWear(targetMode)
        for _, sourceSkin in ipairs(job.sourceSkins:GetChildren()) do
            local sourceMode = sourceSkin:FindFirstChild(modeName)
            if sourceMode then
                for _, sourceWear in ipairs(sourceMode:GetChildren()) do
                    prepareAlias(
                        plans,
                        usedSlots,
                        sourceWear,
                        targetWear,
                        sourceMode,
                        targetMode,
                        job.source .. "." .. sourceSkin.Name .. "." .. modeName .. "." .. sourceWear.Name
                            .. " -> " .. job.item .. "." .. job.targetSkinName .. "." .. targetWear.Name,
                        errors
                    )
                end
            end
        end
    end
end

local function addAnimationAliases(job, plans, usedSlots, errors)
    if not job.sourceAnimations or not job.targetAnimations then
        errors[#errors + 1] = job.item .. ": animation folders were not found"
        return
    end
    for _, modeName in ipairs({ "CameraAnimations", "CharacterAnimations" }) do
        local sourceMode = job.sourceAnimations:FindFirstChild(modeName)
        local targetMode = job.targetAnimations:FindFirstChild(modeName)
        if sourceMode and targetMode then
            for _, sourceAnimation in ipairs(sourceMode:GetChildren()) do
                local targetAnimation = targetMode:FindFirstChild(sourceAnimation.Name)
                if targetAnimation then
                    prepareAlias(
                        plans,
                        usedSlots,
                        sourceAnimation,
                        targetAnimation,
                        sourceMode,
                        targetMode,
                        job.source .. "." .. modeName .. "." .. sourceAnimation.Name,
                        errors
                    )
                end
            end
        else
            errors[#errors + 1] = job.item .. ": missing " .. modeName
        end
    end
end

local function buildSwapPlans(jobs)
    local plans = {}
    local usedSlots = {}
    local errors = {}

    for _, job in ipairs(jobs) do
        if job.kind == "Melee" and job.source ~= job.item then
            prepareAlias(plans, usedSlots, job.sourceWeapon:FindFirstChild("Camera"), job.targetWeapon:FindFirstChild("Camera"), job.sourceWeapon, job.targetWeapon, job.source .. ".Camera -> " .. job.item, errors)
            prepareAlias(plans, usedSlots, job.sourceWeapon:FindFirstChild("Character"), job.targetWeapon:FindFirstChild("Character"), job.sourceWeapon, job.targetWeapon, job.source .. ".Character -> " .. job.item, errors)
            addAnimationAliases(job, plans, usedSlots, errors)
        elseif job.kind == "Glove" and job.source ~= job.item then
            prepareAlias(plans, usedSlots, job.sourceWeapon:FindFirstChild("Left Arm"), job.targetWeapon:FindFirstChild("Left Arm"), job.sourceWeapon, job.targetWeapon, job.source .. ".Left Arm -> " .. job.item, errors)
            prepareAlias(plans, usedSlots, job.sourceWeapon:FindFirstChild("Right Arm"), job.targetWeapon:FindFirstChild("Right Arm"), job.sourceWeapon, job.targetWeapon, job.source .. ".Right Arm -> " .. job.item, errors)
        end
        addSkinAliases(job, plans, usedSlots, errors)
    end

    return plans, errors
end

local function applyPlans(plans)
    local applied = {}
    for _, record in ipairs(plans) do
        local okAddress = wr(record.slot, record.targetAddress)
        local okCtrl = not record.targetCtrl or wr(record.slot + 8, record.targetCtrl)
        if not (okAddress and okCtrl) then
            restoreSwaps(applied)
            return nil, "memory write failed at " .. record.label
        end
        applied[#applied + 1] = record
        if rd(record.slot) ~= record.targetAddress then
            restoreSwaps(applied)
            return nil, "verification failed at " .. record.label
        end
    end
    return applied
end

local function loadConfig()
    if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then
        return nil, nil, "Matcha filesystem functions are unavailable"
    end
    local failures = {}
    for _, path in ipairs(CONFIG_PATHS) do
        local okExists, exists = pcall(isfile, path)
        if okExists and exists then
            local okRead, content = pcall(readfile, path)
            if okRead and type(content) == "string" then
                return content, path
            end
            failures[#failures + 1] = path .. ": " .. tostring(content)
        elseif not okExists then
            failures[#failures + 1] = path .. ": " .. tostring(exists)
        end
    end
    local suffix = #failures > 0 and (" (" .. table.concat(failures, "; ") .. ")") or ""
    return nil, nil, "BS-Config.lua was not found in Matcha's workspace" .. suffix
end

local function reportErrors(prefix, errors)
    for _, message in ipairs(errors or {}) do
        warn("[BS-Skin-Changer] " .. prefix .. ": " .. message)
    end
end

local function run()
    if not Assets or not Weapons or not Skins or not Players.LocalPlayer then
        warn("[BS-Skin-Changer] Bloxstrike assets or LocalPlayer are unavailable")
        return
    end

    local memoryOk = pcall(memory_read, "int", game.Address)
    if not memoryOk then
        warn("[BS-Skin-Changer] Allow Unsafe LuaU is required for reversible asset swaps")
        return
    end

    local previous = _G[STATE_KEY]
    if type(previous) == "table" then
        previous.running = false
        if previous.teamConnection then
            pcall(function()
                previous.teamConnection:Disconnect()
            end)
            previous.teamConnection = nil
        end
        if previous.jobId == game.JobId and previous.assetsAddress == Assets.Address then
            local count = restoreSwaps(previous.restores)
            if count > 0 then
                print("[BS-Skin-Changer] Restored " .. count .. " swaps from the previous run")
            end
        end
    end
    _G[STATE_KEY] = nil

    local configText, configPath, configError = loadConfig()
    if not configText then
        warn("[BS-Skin-Changer] " .. tostring(configError))
        warn("[BS-Skin-Changer] Matcha currently allows readfile only under C:/matcha/workspace; place the file at C:/matcha/workspace/BS-Config.lua")
        return
    end

    local parsed, parseErrors = parseConfig(configText)
    if #parseErrors > 0 then
        reportErrors("config", parseErrors)
        return
    end

    local state = {
        running = true,
        jobId = game.JobId,
        assetsAddress = Assets.Address,
        configPath = configPath,
        parsed = parsed,
        team = nil,
        teamConnection = nil,
        teamWatchChecks = 0,
        restores = {},
        jobs = {},
    }
    _G[STATE_KEY] = state

    local function applyTeam(teamName)
        local team = normalizeTeam(teamName)
        if not team then
            return false
        end

        if #state.restores > 0 then
            restoreSwaps(state.restores)
            state.restores = {}
            state.jobs = {}
        end

        local jobs, jobErrors = buildActiveJobs(team, parsed)
        if #jobErrors > 0 then
            reportErrors(team, jobErrors)
            state.team = team
            return false
        end

        local plans, planErrors = buildSwapPlans(jobs)
        if #planErrors > 0 then
            reportErrors(team, planErrors)
            state.team = team
            return false
        end

        local applied, applyError = applyPlans(plans)
        if not applied then
            warn("[BS-Skin-Changer] " .. tostring(applyError))
            state.team = team
            return false
        end

        state.team = team
        state.restores = applied
        state.jobs = jobs
        local labels = {}
        for _, job in ipairs(jobs) do
            labels[#labels + 1] = job.item .. "=" .. job.skin
        end
        print("[BS-Skin-Changer] Applied " .. #jobs .. " selections for active team " .. team .. " using " .. #applied .. " reversible aliases")
        if #labels > 0 then
            print("[BS-Skin-Changer] " .. table.concat(labels, ", "))
        end
        if typeof(notify) == "function" then
            pcall(notify, "Bloxstrike Skin Changer", "Applied " .. #jobs .. " selections. Re-equip the currently held item once to refresh it.", 6)
        end
        return true
    end

    state.applyTeam = applyTeam
    _G.__BS_SKIN_CHANGER_STOP = function()
        local current = _G[STATE_KEY]
        if current ~= state then
            return
        end
        state.running = false
        if state.teamConnection then
            pcall(function()
                state.teamConnection:Disconnect()
            end)
            state.teamConnection = nil
        end
        local restored = restoreSwaps(state.restores)
        state.restores = {}
        _G[STATE_KEY] = nil
        print("[BS-Skin-Changer] Stopped and restored " .. restored .. " swaps")
    end

    local initialTeam = readCurrentTeam(Players)
    if initialTeam then
        applyTeam(initialTeam)
    else
        print("[BS-Skin-Changer] Config loaded from " .. configPath .. "; waiting for a team assignment")
    end

    startTeamWatcher(RunService, state, Players, applyTeam, function()
        return _G[STATE_KEY] == state
    end)
end

if _G.__BS_SKIN_CHANGER_TEST_MODE == true then
    print("[BS-Skin-Changer] Test mode ready")
else
    _G[TEST_API_KEY] = nil
    run()
end
end)
