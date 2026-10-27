--[[
    RODEO FOR ANIMAL
    • Tema & tampilan disamakan dengan UniversalHub (46 tema + dekorasi animasi + tombol bubble + foto bawaan)
    • UI lebar, otomatis memenuhi layar (bisa diatur di tab TEMA)
    • Fitur: Auto Catch, Auto Base, Auto X2 (treadmill), Anti AFK, Animal ESP (filter tier 10K s/d 1B+), Info game
    Script ini berdiri sendiri.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local PPS = game:GetService("ProximityPromptService")
local RS = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local Http = game:GetService("HttpService")
local Market = game:GetService("MarketplaceService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")
local rgb = Color3.fromRGB
local WHITE = rgb(255, 255, 255)
local GREEN, RED, YELLOW = rgb(80, 220, 120), rgb(255, 80, 80), rgb(250, 204, 21)
local FONT = Enum.Font
local LEFT, RIGHT = Enum.TextXAlignment.Left, Enum.TextXAlignment.Right

do
    local o = playerGui:FindFirstChild("RodeoHubGui")
    if o then o:Destroy() end
end

----------------------------------------------------------------------
-- STATE + SIMPAN PENGATURAN
----------------------------------------------------------------------
local S = {
    autoCatch = false, autoBase = false, baseMode = "Tween", baseSpeed = 25,
    autoX2 = false, antiAfk = false,
    esp = false, hl = true, showName = true, showDist = true, tracer = false, tierColor = true,
    espMin = 0, espMax = 0, espRange = 0,
    tiers = { true, true, true, true, true, true, true },
    pt = 0.35, anim = true, theme = "default", img = "134262192520482", size = 1, infoBar = true,
}
local conns = {}
local function bind(sig, fn)
    local c = sig:Connect(fn)
    conns[#conns + 1] = c
    return c
end

local SAVE = "RodeoHub_theme.json"
local SAVED = { "theme", "pt", "anim", "img", "size", "infoBar", "hl", "showName", "showDist", "tracer", "tierColor",
    "espMin", "espMax", "espRange", "tiers" }
pcall(function()
    if isfile and isfile(SAVE) then
        local d = Http:JSONDecode(readfile(SAVE))
        if type(d) == "table" then
            for _, k in ipairs(SAVED) do
                if d[k] ~= nil and type(d[k]) == type(S[k]) then S[k] = d[k] end
            end
        end
    end
end)
S.pt = math.clamp(S.pt, 0, 0.85)
S.size = math.clamp(S.size, 0.6, 1)
if S.img == "" then S.img = "134262192520482" end
for i = 1, 7 do
    if type(S.tiers[i]) ~= "boolean" then S.tiers[i] = true end
end

local saveTok = 0
local function save()
    saveTok = saveTok + 1
    local tok = saveTok
    task.delay(0.6, function()
        if tok ~= saveTok then return end
        pcall(function()
            if writefile then
                local t = {}
                for _, k in ipairs(SAVED) do t[k] = S[k] end
                writefile(SAVE, Http:JSONEncode(t))
            end
        end)
    end)
end

----------------------------------------------------------------------
-- HELPER UI
----------------------------------------------------------------------
local function new(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end
local function corner(o, r)
    return new("UICorner", { CornerRadius = (typeof(r) == "UDim") and r or UDim.new(0, r or 8) }, o)
end
local function stroke(o, th)
    return new("UIStroke", { Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end
local function lbl(parent, text, size, font, color, pos, sz, align)
    return new("TextLabel", {
        BackgroundTransparency = 1, Text = text, TextSize = size, Font = font, TextColor3 = color,
        Position = pos, Size = sz, TextXAlignment = align or Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end
local PILL = UDim.new(0.5, 0)
local ROUND = UDim.new(1, 0)

-- palet aktif (diisi ulang saat ganti tema). Awalnya = tema "Bawaan (Foto)"
local pal = {
    black = rgb(10, 10, 15), dark = rgb(18, 22, 35), btn = rgb(25, 32, 50), border = rgb(60, 120, 255),
    accent = rgb(70, 130, 255), on = rgb(40, 80, 40), grey = rgb(150, 160, 180),
}
local curRim = { rgb(255, 255, 255), 0.78 }

-- elemen yang ikut berubah warna saat ganti tema: {instance, property, role}
local reg, softList, refreshers = {}, {}, {}
local function role(inst, prop, r)
    reg[#reg + 1] = { inst, prop, r }
    inst[prop] = pal[r]
    return inst
end
local function soft(inst)
    softList[#softList + 1] = inst
    inst.BackgroundTransparency = S.pt
    return inst
end
local function applySoft()
    for i = #softList, 1, -1 do
        local o = softList[i]
        if o.Parent then o.BackgroundTransparency = S.pt else table.remove(softList, i) end
    end
end
local TI_COLOR = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function recolor()
    for i = #reg, 1, -1 do
        local e = reg[i]
        if e[1].Parent then
            TweenService:Create(e[1], TI_COLOR, { [e[2]] = pal[e[3]] }):Play()
        else
            table.remove(reg, i)
        end
    end
    for _, fn in ipairs(refreshers) do pcall(fn) end
end

-- drag generik (mouse + sentuh)
local function drag(handle, target, onClick)
    local down, moved, sp, st = false, false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            down, moved, sp, st = true, false, i.Position, target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    if down and not moved and onClick then onClick() end
                    down = false
                end
            end)
        end
    end)
    bind(UIS.InputChanged, function(i)
        if down and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - sp
            if not moved and d.Magnitude < 6 then return end
            moved = true
            target.Position = UDim2.new(st.X.Scale, st.X.Offset + d.X, st.Y.Scale, st.Y.Offset + d.Y)
        end
    end)
end

----------------------------------------------------------------------
-- GUI UTAMA (lebar, memenuhi layar)
----------------------------------------------------------------------
local gui = new("ScreenGui", {
    Name = "RodeoHubGui", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true, DisplayOrder = 100,
}, playerGui)

local LW, LH = 780, 340 -- ukuran logis panel (dihitung ulang di fit)
local function FXW() return LW end
local function FXH() return LH end

local MAIN_POS = UDim2.new(0.5, 0, 0.5, 10)
local main = new("Frame", {
    Name = "MainFrame", AnchorPoint = Vector2.new(0.5, 0.5), Position = MAIN_POS,
    Size = UDim2.fromOffset(LW, LH), BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, gui)
role(main, "BackgroundColor3", "black")
corner(main, 14)

-- garis tepi berkilau yang berputar
local mainStroke = stroke(main, 2)
mainStroke.Color = WHITE
local rimGrad = new("UIGradient", { Rotation = 0 }, mainStroke)
local function paintRim()
    rimGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, pal.border),
        ColorSequenceKeypoint.new(0.5, pal.accent:Lerp(WHITE, 0.6)),
        ColorSequenceKeypoint.new(1, pal.border),
    })
end
paintRim()
refreshers[#refreshers + 1] = paintRim
bind(RunService.Heartbeat, function()
    if S.anim and main.Visible then rimGrad.Rotation = (os.clock() * 45) % 360 end
end)

local uiScale = new("UIScale", {}, main)
local chipOnline, chipStats
local rebuildTok = 0
local applyTheme
local function fit()
    local vp = gui.AbsoluteSize
    if vp.X < 10 or vp.Y < 10 then
        local cam = workspace.CurrentCamera
        vp = cam and cam.ViewportSize or Vector2.new(940, 420)
    end
    local sc = math.clamp(vp.Y / 400, 0.8, 1.4)
    uiScale.Scale = sc
    LW = math.clamp(vp.X * 0.95 * S.size / sc, 400, 1200)
    LH = math.clamp(vp.Y * 0.92 * S.size / sc, 250, 660)
    main.Size = UDim2.fromOffset(LW, LH)
    if chipOnline then chipOnline.Visible = LW >= 640 end
    if chipStats then chipStats.Visible = LW >= 540 end
end
local function refit(rebuild)
    fit()
    if rebuild then
        rebuildTok = rebuildTok + 1
        local tok = rebuildTok
        task.delay(0.5, function()
            if tok == rebuildTok and applyTheme and gui.Parent then applyTheme(S.theme, true) end
        end)
    end
end
fit()
bind(gui:GetPropertyChangedSignal("AbsoluteSize"), function() refit(true) end)

-- background: foto bawaan + efek tema (dari UniversalHub)
local bgImage = new("ImageLabel", {
    Name = "BGImage", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop, ZIndex = 0, Visible = false,
}, main)
corner(bgImage, 14)

local function setImage(id)
    local digits = (tostring(id):gsub("%D", ""))
    if digits == "" then return false end
    S.img = digits
    bgImage.Image = "rbxassetid://" .. digits
    task.spawn(function()
        -- kalau ID itu Decal, ambil gambar aslinya (butuh executor yang support GetObjects)
        local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. digits) end)
        if ok and objs and objs[1] and S.img == digits then
            local o = objs[1]
            local d = ((o:IsA("Decal") or o:IsA("Texture")) and o)
                or o:FindFirstChildWhichIsA("Decal", true) or o:FindFirstChildWhichIsA("Texture", true)
            if d and d.Texture and d.Texture ~= "" then bgImage.Image = d.Texture end
        end
    end)
    return true
end

local function makeThemeEngine(main, conns, FXW, FXH)
    local TweenService = game:GetService("TweenService")
    local rgb = Color3.fromRGB

    local ROLES = { "black", "dark", "btn", "border", "accent", "on", "grey", "info",
        "cbg", "cpanel", "ccard", "cbtn", "cbtn2", "cstroke" }

    local function mkPal(arr)
        local pal, seen = {}, {}
        for i, role in ipairs(ROLES) do
            local c = arr[i]
            local r, g, b = c[1], c[2], c[3]
            while seen[r * 65536 + g * 256 + b] do b = (b + 1) % 256 end
            seen[r * 65536 + g * 256 + b] = true
            pal[role] = rgb(r, g, b)
        end
        return pal
    end

    -- urutan: black, dark, btn, border, accent, on, grey, info, cbg, cpanel, ccard, cbtn, cbtn2, cstroke
    local THEMES = {
        { id = "default", name = "Bawaan (Foto)", icon = "🖼️",
            sw = { rgb(10, 10, 15), rgb(60, 120, 255), rgb(125, 100, 215) },
            rim = { rgb(255, 255, 255), 0.78 },
            pal = mkPal({ {10,10,15}, {18,22,35}, {25,32,50}, {60,120,255}, {70,130,255}, {40,80,40}, {150,160,180}, {12,15,25},
                {45,22,62}, {68,34,88}, {52,26,72}, {125,100,215}, {205,115,75}, {150,110,220} }) },
        { id = "mono", name = "Monokrom", icon = "⚪",
            sw = { rgb(14, 14, 16), rgb(120, 122, 134), rgb(232, 234, 240) },
            rim = { rgb(235, 238, 245), 0.55 },
            pal = mkPal({ {12,12,14}, {30,31,35}, {52,53,59}, {206,209,217}, {118,121,132}, {96,102,110}, {172,175,184}, {20,20,23},
                {26,27,31}, {44,45,51}, {36,37,42}, {138,141,152}, {190,193,201}, {176,180,190} }) },
        { id = "forest", name = "Hutan", icon = "🌲",
            sw = { rgb(4, 20, 11), rgb(44, 138, 74), rgb(150, 230, 150) },
            rim = { rgb(150, 240, 170), 0.6 },
            pal = mkPal({ {6,24,13}, {12,42,24}, {20,64,38}, {92,208,120}, {44,138,74}, {30,104,52}, {156,204,170}, {8,30,17},
                {10,36,20}, {22,70,40}, {16,52,30}, {58,160,90}, {196,160,70}, {110,200,130} }) },
        { id = "hacker", name = "Hacker", icon = "💻",
            sw = { rgb(0, 6, 2), rgb(0, 150, 62), rgb(0, 255, 90) },
            rim = { rgb(0, 255, 90), 0.2 },
            pal = mkPal({ {2,9,4}, {4,20,9}, {7,34,14}, {0,255,90}, {0,150,62}, {0,106,44}, {96,204,128}, {3,14,7},
                {3,16,7}, {9,40,18}, {5,27,12}, {0,176,72}, {0,220,200}, {0,210,80} }) },
        { id = "ocean", name = "Lautan", icon = "🌊",
            sw = { rgb(96, 184, 240), rgb(24, 102, 184), rgb(3, 26, 66) },
            rim = { rgb(190, 235, 255), 0.55 },
            pal = mkPal({ {5,26,56}, {9,46,90}, {15,72,128}, {120,206,255}, {30,122,204}, {20,128,150}, {176,214,238}, {6,32,68},
                {8,40,80}, {18,80,138}, {12,60,108}, {44,150,224}, {70,190,200}, {140,210,250} }) },
        { id = "sunset", name = "Sunset", icon = "🌇",
            sw = { rgb(70, 30, 120), rgb(238, 108, 82), rgb(255, 172, 84) },
            rim = { rgb(255, 200, 150), 0.55 },
            pal = mkPal({ {34,12,42}, {56,20,58}, {90,36,82}, {255,156,76}, {222,96,64}, {150,58,112}, {232,192,196}, {38,14,46},
                {48,18,56}, {100,42,90}, {74,30,70}, {214,100,90}, {244,150,60}, {255,170,100} }) },
        { id = "nebula", name = "Nebula", icon = "🌌",
            sw = { rgb(30, 10, 74), rgb(98, 72, 222), rgb(60, 140, 255) },
            rim = { rgb(200, 180, 255), 0.5 },
            pal = mkPal({ {12,7,32}, {22,13,56}, {36,22,86}, {156,126,255}, {98,72,222}, {40,100,190}, {192,182,232}, {15,9,38},
                {20,11,50}, {44,28,100}, {30,18,74}, {120,86,236}, {70,150,240}, {170,140,255} }) },
        { id = "blackhole", name = "Blackhole", icon = "🕳️",
            sw = { rgb(3, 3, 8), rgb(255, 130, 40), rgb(130, 70, 200) },
            rim = { rgb(255, 170, 90), 0.45 },
            pal = mkPal({ {3,3,8}, {10,8,20}, {22,16,40}, {255,152,62}, {168,78,40}, {92,52,122}, {196,176,168}, {6,5,12},
                {9,7,18}, {26,18,46}, {16,12,30}, {190,92,44}, {120,70,190}, {255,170,90} }) },
        { id = "aurora", name = "Aurora", icon = "🌠",
            sw = { rgb(6, 20, 40), rgb(60, 230, 180), rgb(170, 110, 255) },
            rim = { rgb(120, 255, 215), 0.5 },
            pal = mkPal({ {5,12,24}, {9,26,40}, {14,42,60}, {96,240,205}, {60,200,170}, {30,130,112}, {164,208,210}, {7,17,30},
                {10,24,42}, {20,52,74}, {14,38,58}, {40,172,152}, {150,112,240}, {112,232,212} }) },
        { id = "sakura", name = "Sakura", icon = "🌸",
            sw = { rgb(52, 16, 40), rgb(240, 120, 170), rgb(255, 205, 220) },
            rim = { rgb(255, 180, 212), 0.5 },
            pal = mkPal({ {38,14,28}, {62,24,46}, {96,40,72}, {255,162,202}, {240,120,170}, {160,70,112}, {236,198,214}, {44,16,32},
                {52,20,40}, {104,44,78}, {78,32,60}, {222,110,160}, {255,176,120}, {255,172,208} }) },
        { id = "galaxy", name = "Galaksi", icon = "🌀",
            sw = { rgb(8, 4, 22), rgb(190, 120, 255), rgb(255, 210, 160) },
            rim = { rgb(215, 175, 255), 0.45 },
            pal = mkPal({ {6,4,16}, {16,10,36}, {30,18,64}, {196,146,255}, {126,100,255}, {44,122,172}, {192,182,226}, {9,6,22},
                {18,10,40}, {42,26,86}, {28,16,62}, {132,92,236}, {255,132,192}, {204,154,255} }) },
        { id = "solar", name = "Tata Surya", icon = "🪐",
            sw = { rgb(6, 8, 22), rgb(255, 170, 60), rgb(80, 150, 255) },
            rim = { rgb(255, 205, 125), 0.5 },
            pal = mkPal({ {4,5,14}, {10,14,30}, {20,28,56}, {255,200,104}, {255,168,58}, {48,132,92}, {192,198,216}, {6,8,20},
                {12,16,34}, {28,36,70}, {20,26,52}, {72,122,222}, {255,150,58}, {255,202,124} }) },
        { id = "saturn", name = "Saturnus", icon = "🌕",
            sw = { rgb(20, 9, 14), rgb(226, 166, 106), rgb(110, 160, 210) },
            rim = { rgb(244, 198, 144), 0.5 },
            pal = mkPal({ {20,10,12}, {40,20,22}, {70,36,34}, {242,192,132}, {226,160,96}, {120,100,62}, {224,202,182}, {26,13,15},
                {34,18,20}, {74,44,40}, {54,30,30}, {200,140,86}, {110,160,210}, {244,198,142} }) },
        { id = "neon", name = "Neon Retro", icon = "🌴",
            sw = { rgb(14, 4, 32), rgb(255, 60, 200), rgb(0, 230, 255) },
            rim = { rgb(255, 100, 220), 0.35 },
            pal = mkPal({ {10,4,24}, {26,8,50}, {50,14,84}, {255,64,204}, {0,226,255}, {0,150,172}, {204,172,232}, {13,5,30},
                {22,8,44}, {56,18,92}, {40,12,70}, {200,42,162}, {0,190,232}, {255,96,214} }) },
        { id = "lava", name = "Lava", icon = "🌋",
            sw = { rgb(40, 6, 6), rgb(255, 110, 20), rgb(255, 200, 70) },
            rim = { rgb(255, 150, 70), 0.45 },
            pal = mkPal({ {20,5,4}, {44,10,8}, {78,20,12}, {255,120,40}, {226,84,30}, {150,70,20}, {220,184,170}, {26,6,5}, {34,8,6}, {90,26,14}, {64,18,10}, {200,70,28}, {255,170,40}, {255,140,60} }) },
        { id = "snow", name = "Salju", icon = "❄️",
            sw = { rgb(8, 24, 60), rgb(90, 170, 235), rgb(240, 248, 255) },
            rim = { rgb(190, 232, 255), 0.5 },
            pal = mkPal({ {10,22,44}, {18,40,76}, {30,66,112}, {170,225,255}, {90,170,235}, {50,130,170}, {200,224,240}, {12,28,56}, {14,32,62}, {34,72,122}, {24,52,96}, {70,150,220}, {150,210,250}, {190,232,255} }) },
        { id = "rain", name = "Hujan Petir", icon = "🌧️",
            sw = { rgb(6, 10, 20), rgb(78, 124, 180), rgb(170, 205, 245) },
            rim = { rgb(140, 180, 225), 0.55 },
            pal = mkPal({ {10,13,20}, {22,28,40}, {38,48,66}, {120,170,220}, {78,124,180}, {50,110,120}, {170,184,200}, {14,18,28}, {16,21,32}, {34,44,62}, {26,34,50}, {70,110,160}, {130,170,210}, {140,180,225} }) },
        { id = "desert", name = "Gurun", icon = "🏜️",
            sw = { rgb(120, 60, 40), rgb(236, 138, 74), rgb(255, 230, 170) },
            rim = { rgb(255, 200, 120), 0.5 },
            pal = mkPal({ {44,24,14}, {74,40,22}, {112,64,36}, {255,196,110}, {232,150,70}, {140,120,50}, {238,214,184}, {52,28,16}, {60,32,18}, {120,70,40}, {92,52,30}, {210,130,60}, {240,180,90}, {255,200,120} }) },
        { id = "cyber", name = "Cyberpunk", icon = "🌆",
            sw = { rgb(22, 4, 44), rgb(255, 60, 190), rgb(0, 230, 255) },
            rim = { rgb(255, 230, 60), 0.35 },
            pal = mkPal({ {10,4,22}, {24,8,46}, {44,12,74}, {255,230,60}, {0,230,255}, {0,160,170}, {200,180,225}, {14,6,30}, {20,6,40}, {54,14,86}, {38,10,64}, {240,40,150}, {0,200,230}, {255,240,90} }) },
        { id = "candy", name = "Permen", icon = "🍭",
            sw = { rgb(255, 120, 180), rgb(150, 110, 230), rgb(70, 170, 230) },
            rim = { rgb(255, 215, 235), 0.4 },
            pal = mkPal({ {90,40,90}, {120,60,120}, {150,84,150}, {255,200,230}, {255,130,190}, {90,180,150}, {250,220,240}, {100,46,100}, {108,52,108}, {170,100,170}, {140,76,140}, {255,120,180}, {120,200,255}, {255,210,235} }) },
        { id = "city", name = "Kota Malam", icon = "🏙️",
            sw = { rgb(10, 14, 40), rgb(80, 62, 120), rgb(255, 210, 110) },
            rim = { rgb(255, 220, 140), 0.5 },
            pal = mkPal({ {8,10,28}, {16,20,50}, {28,34,76}, {255,210,110}, {240,180,80}, {70,120,100}, {190,196,226}, {10,12,32}, {12,16,40}, {34,40,88}, {24,30,66}, {90,100,190}, {255,190,90}, {255,220,140} }) },
        { id = "thunder", name = "Petir Ungu", icon = "⚡",
            sw = { rgb(14, 6, 40), rgb(140, 90, 240), rgb(240, 220, 90) },
            rim = { rgb(200, 160, 255), 0.4 },
            pal = mkPal({ {10,4,24}, {22,10,50}, {40,18,84}, {190,140,255}, {140,90,240}, {80,70,170}, {200,186,236}, {12,6,30}, {18,8,42}, {50,24,100}, {34,16,72}, {120,70,230}, {240,220,90}, {200,160,255} }) },
        { id = "gold", name = "Emas Mewah", icon = "👑",
            sw = { rgb(10, 8, 4), rgb(200, 150, 50), rgb(255, 226, 130) },
            rim = { rgb(245, 205, 110), 0.4 },
            pal = mkPal({ {10,8,4}, {28,22,10}, {52,40,16}, {240,196,90}, {200,150,50}, {120,110,50}, {214,200,170}, {14,11,6}, {20,15,7}, {58,44,18}, {42,32,14}, {190,140,44}, {250,214,110}, {245,205,110} }) },
        { id = "autumn", name = "Musim Gugur", icon = "🍁",
            sw = { rgb(60, 24, 16), rgb(226, 120, 44), rgb(250, 190, 110) },
            rim = { rgb(255, 180, 90), 0.5 },
            pal = mkPal({ {40,18,10}, {70,30,16}, {108,50,24}, {255,170,70}, {226,120,44}, {130,110,40}, {236,206,180}, {46,20,12}, {56,24,12}, {116,54,26}, {88,40,20}, {210,100,36}, {240,170,60}, {255,180,90} }) },
        { id = "moon", name = "Bulan Purnama", icon = "🌙",
            sw = { rgb(8, 12, 34), rgb(150, 170, 230), rgb(250, 248, 220) },
            rim = { rgb(230, 230, 170), 0.45 },
            pal = mkPal({ {8,12,34}, {14,22,56}, {26,40,86}, {230,230,170}, {150,170,230}, {80,130,130}, {196,204,228}, {10,16,40}, {12,18,46}, {30,46,96}, {20,32,72}, {90,110,190}, {240,230,160}, {210,215,250} }) },
        { id = "rainbow", name = "Pelangi", icon = "🌈",
            sw = { rgb(255, 70, 70), rgb(80, 220, 110), rgb(120, 90, 240) },
            rim = { rgb(255, 255, 255), 0.35 },
            pal = mkPal({ {30,20,50}, {46,30,76}, {70,44,110}, {255,255,255}, {255,120,200}, {70,190,140}, {226,214,240}, {34,22,56}, {40,26,66}, {80,52,126}, {60,40,96}, {240,100,160}, {90,190,255}, {255,230,120} }) },
        { id = "abyss", name = "Laut Dalam", icon = "🐙",
            sw = { rgb(2, 12, 22), rgb(40, 190, 200), rgb(200, 110, 255) },
            rim = { rgb(110, 245, 235), 0.4 },
            pal = mkPal({ {2,12,22}, {4,26,44}, {8,48,72}, {80,240,230}, {40,190,200}, {30,140,120}, {150,204,214}, {3,16,28}, {3,18,32}, {8,52,80}, {6,38,60}, {30,170,190}, {200,110,255}, {110,245,235} }) },
        { id = "fireworks", name = "Kembang Api", icon = "🎆",
            sw = { rgb(6, 4, 20), rgb(255, 100, 150), rgb(255, 200, 70) },
            rim = { rgb(255, 170, 110), 0.4 },
            pal = mkPal({ {6,4,20}, {14,8,40}, {30,16,72}, {255,190,80}, {255,100,150}, {70,160,120}, {206,190,230}, {9,6,26}, {10,6,32}, {40,20,90}, {26,14,62}, {220,70,150}, {255,200,70}, {255,170,110} }) },
        { id = "blueflame", name = "Api Biru", icon = "🔵",
            sw = { rgb(3, 8, 24), rgb(40, 150, 250), rgb(220, 250, 255) },
            rim = { rgb(140, 225, 255), 0.4 },
            pal = mkPal({ {3,8,24}, {6,18,52}, {10,34,86}, {110,220,255}, {40,150,250}, {20,130,160}, {160,200,236}, {4,11,32}, {5,14,40}, {12,40,100}, {8,28,74}, {30,130,240}, {140,230,255}, {140,225,255} }) },
        { id = "firefly", name = "Malam Kunang", icon = "🏕️",
            sw = { rgb(5, 16, 22), rgb(150, 210, 70), rgb(240, 255, 150) },
            rim = { rgb(215, 255, 130), 0.5 },
            pal = mkPal({ {5,12,16}, {9,24,28}, {15,40,44}, {200,240,90}, {150,210,70}, {40,110,60}, {160,190,180}, {7,16,20},
                {8,20,24}, {18,50,50}, {12,34,38}, {90,160,60}, {230,200,70}, {200,240,100} }) },
        { id = "meteor", name = "Hujan Meteor", icon = "☄️",
            sw = { rgb(6, 6, 26), rgb(255, 140, 70), rgb(130, 110, 255) },
            rim = { rgb(255, 190, 130), 0.45 },
            pal = mkPal({ {6,6,20}, {12,12,38}, {22,22,60}, {255,170,90}, {255,140,70}, {60,120,90}, {180,176,210}, {8,8,26},
                {10,10,30}, {30,24,70}, {20,16,52}, {200,100,60}, {255,190,90}, {255,170,100} }) },
        { id = "coral", name = "Terumbu Karang", icon = "🐠",
            sw = { rgb(4, 60, 90), rgb(255, 120, 110), rgb(120, 230, 220) },
            rim = { rgb(255, 180, 170), 0.5 },
            pal = mkPal({ {4,22,34}, {8,40,58}, {14,62,84}, {255,130,120}, {255,110,110}, {30,150,130}, {170,214,220}, {5,28,42},
                {6,30,46}, {16,70,96}, {10,52,74}, {240,120,110}, {255,190,100}, {255,150,140} }) },
        { id = "gear", name = "Mesin Uap", icon = "⚙️",
            sw = { rgb(30, 18, 8), rgb(200, 130, 50), rgb(240, 205, 130) },
            rim = { rgb(240, 190, 110), 0.45 },
            pal = mkPal({ {18,11,6}, {40,26,14}, {66,44,24}, {214,150,70}, {200,130,50}, {90,110,50}, {206,190,164}, {24,15,8},
                {30,19,10}, {70,46,24}, {52,34,18}, {170,110,50}, {230,170,80}, {220,160,80} }) },
        { id = "matcha", name = "Matcha Latte", icon = "🍵",
            sw = { rgb(150, 190, 120), rgb(70, 110, 76), rgb(240, 250, 200) },
            rim = { rgb(235, 250, 190), 0.4 },
            pal = mkPal({ {28,46,34}, {44,70,50}, {64,98,70}, {200,230,150}, {170,210,120}, {70,130,80}, {210,226,200}, {32,52,38},
                {36,58,42}, {70,106,76}, {54,86,62}, {120,170,90}, {230,200,130}, {200,232,160} }) },
        -- ===== v21: 12 tema baru =====
        { id = "halloween", name = "Malam Halloween", icon = "🎃",
            sw = { rgb(60, 20, 70), rgb(255, 120, 20), rgb(160, 90, 230) },
            rim = { rgb(255, 150, 50), 0.4 },
            pal = mkPal({ {14,6,20}, {30,14,40}, {52,24,62}, {255,130,30}, {255,120,20}, {80,120,40}, {204,184,206}, {18,8,26},
                {24,10,32}, {62,28,74}, {44,20,56}, {190,90,20}, {140,80,220}, {255,150,50} }) },
        { id = "sky", name = "Langit Cerah", icon = "☁️",
            sw = { rgb(70, 150, 240), rgb(190, 230, 255), rgb(255, 245, 190) },
            rim = { rgb(255, 255, 255), 0.35 },
            pal = mkPal({ {18,40,78}, {30,66,116}, {46,92,152}, {255,255,255}, {120,200,255}, {50,150,110}, {196,218,242}, {22,48,90},
                {26,56,104}, {52,100,166}, {38,80,134}, {70,140,225}, {255,200,90}, {200,232,255} }) },
        { id = "beach", name = "Pantai Tropis", icon = "🏝️",
            sw = { rgb(50, 190, 215), rgb(250, 228, 170), rgb(255, 150, 90) },
            rim = { rgb(255, 240, 190), 0.4 },
            pal = mkPal({ {8,44,56}, {14,72,86}, {24,104,118}, {255,226,150}, {60,210,225}, {60,150,100}, {196,230,230}, {10,52,64},
                {12,60,74}, {26,112,126}, {18,88,102}, {40,170,190}, {255,150,90}, {255,236,170} }) },
        { id = "arcade", name = "Arkade Retro", icon = "🕹️",
            sw = { rgb(30, 8, 64), rgb(255, 64, 200), rgb(0, 230, 255) },
            rim = { rgb(0, 230, 255), 0.35 },
            pal = mkPal({ {6,4,20}, {16,8,44}, {32,14,72}, {0,230,255}, {255,64,200}, {40,150,60}, {190,180,230}, {9,6,26},
                {14,8,38}, {40,18,84}, {28,12,62}, {210,40,160}, {0,190,230}, {255,220,60} }) },
        { id = "icecream", name = "Es Krim", icon = "🍦",
            sw = { rgb(255, 170, 200), rgb(170, 230, 210), rgb(255, 240, 170) },
            rim = { rgb(255, 255, 255), 0.4 },
            pal = mkPal({ {96,44,76}, {128,64,102}, {164,90,132}, {255,214,232}, {255,150,196}, {90,170,140}, {250,226,240}, {106,50,84},
                {112,54,90}, {176,100,142}, {146,78,118}, {240,130,180}, {130,210,190}, {255,200,225} }) },
        { id = "lantern", name = "Lentera Festival", icon = "🏮",
            sw = { rgb(120, 16, 24), rgb(255, 190, 80), rgb(255, 90, 60) },
            rim = { rgb(255, 200, 100), 0.4 },
            pal = mkPal({ {22,5,8}, {50,10,16}, {84,20,28}, {255,196,90}, {240,70,50}, {120,110,40}, {226,196,180}, {28,6,10},
                {34,8,12}, {96,24,32}, {70,16,24}, {200,50,40}, {255,180,60}, {255,210,120} }) },
        { id = "wizard", name = "Penyihir", icon = "🔮",
            sw = { rgb(40, 16, 90), rgb(120, 90, 255), rgb(80, 230, 220) },
            rim = { rgb(170, 140, 255), 0.4 },
            pal = mkPal({ {8,6,26}, {18,12,52}, {34,22,88}, {150,120,255}, {110,80,240}, {40,150,140}, {190,184,236}, {10,8,32},
                {14,10,42}, {42,28,100}, {28,18,74}, {100,70,220}, {80,220,210}, {170,140,255} }) },
        { id = "dino", name = "Zaman Dino", icon = "🦖",
            sw = { rgb(120, 150, 60), rgb(70, 100, 40), rgb(255, 160, 60) },
            rim = { rgb(220, 240, 140), 0.45 },
            pal = mkPal({ {16,26,12}, {30,46,22}, {48,70,34}, {190,220,110}, {150,190,80}, {90,130,50}, {200,214,176}, {20,32,14},
                {24,38,18}, {54,80,38}, {40,62,28}, {120,160,60}, {240,160,60}, {200,230,120} }) },
        { id = "rosegold", name = "Rose Gold", icon = "🌹",
            sw = { rgb(150, 84, 96), rgb(240, 180, 170), rgb(255, 226, 200) },
            rim = { rgb(255, 205, 190), 0.4 },
            pal = mkPal({ {28,14,20}, {58,30,40}, {92,50,62}, {246,196,180}, {226,150,150}, {130,130,80}, {226,196,196}, {34,18,24},
                {44,22,30}, {100,56,68}, {76,40,52}, {190,110,120}, {240,190,150}, {255,215,200} }) },
        { id = "space", name = "Astronot", icon = "🚀",
            sw = { rgb(4, 6, 24), rgb(70, 110, 255), rgb(255, 140, 70) },
            rim = { rgb(160, 190, 255), 0.45 },
            pal = mkPal({ {3,5,18}, {8,12,40}, {16,24,70}, {120,160,255}, {70,110,255}, {50,140,110}, {170,182,224}, {5,8,26},
                {6,10,32}, {20,30,82}, {12,20,58}, {50,90,230}, {255,140,70}, {150,180,255} }) },
        { id = "bamboo", name = "Hutan Bambu", icon = "🎋",
            sw = { rgb(190, 225, 150), rgb(80, 140, 80), rgb(24, 60, 40) },
            rim = { rgb(220, 250, 180), 0.45 },
            pal = mkPal({ {12,30,20}, {22,54,36}, {36,82,54}, {190,236,150}, {120,200,100}, {70,140,70}, {196,222,196}, {14,36,24},
                {18,44,30}, {40,90,58}, {30,68,44}, {90,160,80}, {230,210,120}, {200,240,160} }) },
        { id = "carnival", name = "Karnaval", icon = "🎪",
            sw = { rgb(70, 20, 100), rgb(255, 80, 120), rgb(255, 220, 70) },
            rim = { rgb(255, 220, 100), 0.4 },
            pal = mkPal({ {16,6,36}, {36,14,70}, {62,24,106}, {255,214,80}, {255,80,130}, {60,160,110}, {214,190,236}, {20,8,44},
                {28,10,56}, {70,28,118}, {50,20,90}, {220,60,110}, {80,200,240}, {255,225,110} }) },
    }
    local byId = {}
    for _, th in ipairs(THEMES) do byId[th.id] = th end

    local cur = THEMES[1].pal -- palet yang sedang dipakai UI (awalnya bawaan)

    local function keyOf(c)
        return math.floor(c.R * 255 + 0.5) * 65536 + math.floor(c.G * 255 + 0.5) * 256 + math.floor(c.B * 255 + 0.5)
    end

    -- ---------- container dekorasi (di belakang semua isi menu) ----------
    local fxRoot = Instance.new("Frame")
    fxRoot.Name = "ThemeFX"
    fxRoot.Size = UDim2.new(1, 0, 1, 0)
    fxRoot.BackgroundColor3 = rgb(255, 255, 255)
    fxRoot.BorderSizePixel = 0
    fxRoot.ClipsDescendants = true
    fxRoot.ZIndex = 0
    fxRoot.Visible = false
    fxRoot.Parent = main
    corner(fxRoot, 14)
    local baseGrad = Instance.new("UIGradient")
    baseGrad.Parent = fxRoot
    local deco = Instance.new("Frame")
    deco.Name = "Deco"
    deco.Size = UDim2.new(1, 0, 1, 0)
    deco.BackgroundTransparency = 1
    deco.BorderSizePixel = 0
    deco.ZIndex = 0
    deco.Parent = fxRoot

    local anims = {}
    local function DENS() return math.clamp((FXW() * FXH()) / (265 * 405), 1, 2.3) end
    local function WX() return math.clamp(FXW() / 265, 1, 4) end
    local animOn = true
    local t0 = os.clock()
    local accDt = 0
    local hbConn = RunService.Heartbeat:Connect(function(dt)
        if not animOn or #anims == 0 or not main.Visible then return end
        accDt = accDt + dt
        if accDt < 0.033 then return end
        dt, accDt = accDt, 0
        local t = os.clock() - t0
        for i = 1, #anims do
            local f = anims[i]
            if f then pcall(f, t, dt) end
        end
    end)
    conns[#conns + 1] = hbConn

    -- ---------- helper bikin dekorasi ----------
    local function mk(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent or deco
        return o
    end

    local function ugrad(parent, rot, cols, trans)
        local g = Instance.new("UIGradient")
        g.Rotation = rot or 0
        if cols then
            local k = {}
            for _, s in ipairs(cols) do table.insert(k, ColorSequenceKeypoint.new(s[1], s[2])) end
            g.Color = ColorSequence.new(k)
        end
        if trans then
            local k = {}
            for _, s in ipairs(trans) do table.insert(k, NumberSequenceKeypoint.new(s[1], s[2])) end
            g.Transparency = NumberSequence.new(k)
        end
        g.Parent = parent
        return g
    end

    local function setBase(rot, stops)
        local k = {}
        for _, s in ipairs(stops) do table.insert(k, ColorSequenceKeypoint.new(s[1], s[2])) end
        baseGrad.Color = ColorSequence.new(k)
        baseGrad.Rotation = rot
    end

    local function circle(x, y, size, color, transp, parent)
        local f = mk("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(x, 0, y, 0),
            Size = UDim2.new(0, size, 0, size), BackgroundColor3 = color,
            BackgroundTransparency = transp or 0, BorderSizePixel = 0,
        }, parent)
        mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, f)
        return f
    end

    -- gumpalan lembut (lingkaran bertumpuk, makin ke tengah makin pekat)
    local function blob(x, y, size, color, layers)
        local g = mk("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(x, 0, y, 0),
            Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        for i = 1, layers do
            local s = 1 - (i - 1) / layers * 0.8
            local c = mk("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(s, 0, s, 0), BackgroundColor3 = color,
                BackgroundTransparency = 0.97 - 0.17 * (i - 1) / math.max(1, layers - 1), BorderSizePixel = 0,
            }, g)
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, c)
        end
        return g
    end

    local function stars(n, seed, maxS, yMax)
        local rnd = Random.new(seed)
        for _ = 1, math.floor(n * DENS()) do
            local s = rnd:NextInteger(1, maxS or 2)
            local d = circle(rnd:NextNumber(), rnd:NextNumber() * (yMax or 1), s, rgb(255, 255, 255), rnd:NextNumber(0.2, 0.6))
            local ph, sp = rnd:NextNumber(0, 6.28), rnd:NextNumber(0.8, 2.5)
            local base = d.BackgroundTransparency
            table.insert(anims, function(t)
                d.BackgroundTransparency = math.clamp(base + math.sin(t * sp + ph) * 0.35, 0, 0.95)
            end)
        end
    end

    local function beams(n, color, x0, rot)
        for i = 1, n do
            local r = mk("Frame", {
                AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(x0 + i * 0.18, 0, -0.1, 0),
                Size = UDim2.new(0, 34, 0, 440), Rotation = rot, BackgroundColor3 = color,
                BackgroundTransparency = 0.9, BorderSizePixel = 0,
            })
            ugrad(r, 90, nil, { { 0, 0.2 }, { 1, 1 } })
            local ph = i * 1.7
            table.insert(anims, function(t) r.BackgroundTransparency = 0.88 + math.sin(t * 0.6 + ph) * 0.04 end)
        end
    end

    local build = {}

    -- 1) MONOKROM: hitam-putih elegan + kilau metalik
    build.mono = function()
        setBase(135, { { 0, rgb(8, 8, 10) }, { 0.5, rgb(54, 55, 61) }, { 1, rgb(12, 12, 14) } })
        for i = 1, 16 do
            mk("Frame", { Position = UDim2.new(0, 0, i / 17, 0), Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = rgb(255, 255, 255), BackgroundTransparency = 0.95, BorderSizePixel = 0 })
        end
        blob(0.92, 0.08, 170, rgb(210, 212, 222), 6)
        blob(0.05, 0.95, 150, rgb(150, 152, 165), 6)
        local sheen = mk("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-0.3, 0, 0.5, 0),
            Size = UDim2.new(0, 70, 0, 520), Rotation = 24, BackgroundColor3 = rgb(255, 255, 255),
            BackgroundTransparency = 0.8, BorderSizePixel = 0,
        })
        ugrad(sheen, 0, nil, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
        table.insert(anims, function(t)
            local p = (t % 8) / 8
            sheen.Position = UDim2.new(-0.3 + p * 1.6, 0, 0.5, 0)
        end)
    end

    -- 2) HUTAN: hijau + pohon, daun jatuh, kunang-kunang, sinar matahari
    build.forest = function()
        setBase(90, { { 0, rgb(30, 96, 54) }, { 0.5, rgb(11, 46, 27) }, { 1, rgb(3, 18, 10) } })
        local rnd = Random.new(7)
        beams(3, rgb(220, 255, 170), 0.15, -18)
        for _, layer in ipairs({ 2, 1 }) do
            local TN = math.floor(7 * WX() + 0.5)
            for i = 0, TN - 1 do
                mk("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.new((i + rnd:NextNumber(0.1, 0.9)) / TN, 0, layer == 1 and 1.03 or 0.97, 0),
                    Size = UDim2.new(0, 60, 0, 60), BackgroundTransparency = 1,
                    Text = rnd:NextInteger(1, 2) == 1 and "🌲" or "🌳",
                    TextSize = layer == 1 and 56 or 38, TextTransparency = layer == 1 and 0.15 or 0.5,
                })
            end
        end
        mk("TextLabel", { Position = UDim2.new(0, 4, 0, 52), Size = UDim2.new(0, 60, 0, 40), BackgroundTransparency = 1,
            Text = "🌿", TextSize = 30, TextTransparency = 0.4, Rotation = -20 })
        mk("TextLabel", { Position = UDim2.new(1, -64, 0, 52), Size = UDim2.new(0, 60, 0, 40), BackgroundTransparency = 1,
            Text = "🌿", TextSize = 30, TextTransparency = 0.4, Rotation = 20 })
        mk("TextLabel", { Position = UDim2.new(0.08, 0, 0.9, 0), Size = UDim2.new(0, 30, 0, 30), BackgroundTransparency = 1,
            Text = "🍄", TextSize = 20, TextTransparency = 0.25 })
        mk("TextLabel", { Position = UDim2.new(0.82, 0, 0.92, 0), Size = UDim2.new(0, 30, 0, 30), BackgroundTransparency = 1,
            Text = "🌸", TextSize = 18, TextTransparency = 0.25 })
        local glyphs = { "🍃", "🌿", "🍃", "🍀", "🍃" }
        for i = 1, 6 do
            local l = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1, Text = glyphs[(i % 5) + 1], TextSize = 16, TextTransparency = 0.25 })
            local x0, sp, ph = rnd:NextNumber(), rnd:NextNumber(0.05, 0.1), rnd:NextNumber(0, 6)
            table.insert(anims, function(t)
                local p = (t * sp + ph) % 1.2 - 0.1
                l.Position = UDim2.new((x0 + math.sin(t * 0.9 + ph) * 0.06) % 1, 0, p, 0)
                l.Rotation = (t * 40 + ph * 50) % 360
            end)
        end
        for _ = 1, 9 do
            local x, y = rnd:NextNumber(0.05, 0.95), rnd:NextNumber(0.45, 0.95)
            local g = circle(x, y, 11, rgb(210, 255, 120), 0.9)
            local d = circle(x, y, 3, rgb(240, 255, 170), 0.1)
            local ph = rnd:NextNumber(0, 6)
            table.insert(anims, function(t)
                local a = (math.sin(t * 1.6 + ph) + 1) / 2
                d.BackgroundTransparency = 0.8 - a * 0.7
                g.BackgroundTransparency = 0.95 - a * 0.2
                local pos = UDim2.new(x + math.sin(t * 0.4 + ph) * 0.03, 0, y + math.cos(t * 0.3 + ph) * 0.02, 0)
                g.Position = pos
                d.Position = pos
            end)
        end
    end

    -- 3) HACKER: hitam-hijau neon, hujan kode, grid cyber, scanline
    build.hacker = function()
        setBase(90, { { 0, rgb(0, 18, 7) }, { 1, rgb(0, 3, 1) } })
        for i = 1, 8 do
            mk("Frame", { Position = UDim2.new(i / 9, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0),
                BackgroundColor3 = rgb(0, 255, 90), BackgroundTransparency = 0.93, BorderSizePixel = 0 })
        end
        for i = 1, 12 do
            mk("Frame", { Position = UDim2.new(0, 0, i / 13, 0), Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = rgb(0, 255, 90), BackgroundTransparency = 0.94, BorderSizePixel = 0 })
        end
        local chars = "01ABCDEFabcdef<>/{}[]$#%&*+=?"
        local rnd = Random.new(11)
        local function rstr(n)
            local s = {}
            for i = 1, n do
                local k = rnd:NextInteger(1, #chars)
                s[i] = chars:sub(k, k)
            end
            return table.concat(s, "\n")
        end
        local HC = math.floor(14 * WX() + 0.5)
        for i = 1, HC do
            local lb = mk("TextLabel", {
                Position = UDim2.new((i - 0.5) / HC, -4, 0, -230), Size = UDim2.new(0, 10, 0, 210),
                BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 12,
                TextColor3 = rgb(0, 255, 100), TextTransparency = 0.3, Text = rstr(14),
                TextYAlignment = Enum.TextYAlignment.Top,
            })
            ugrad(lb, 90, nil, { { 0, 1 }, { 0.8, 0.2 }, { 1, 0 } })
            local sp, off = rnd:NextNumber(60, 140), rnd:NextNumber(0, 600)
            local nextChange = 0
            table.insert(anims, function(t)
                lb.Position = UDim2.new((i - 0.5) / HC, -4, 0, ((t * sp + off) % (FXH() + 230)) - 230)
                if t > nextChange then
                    nextChange = t + rnd:NextNumber(0.15, 0.4)
                    lb.Text = rstr(14)
                end
            end)
        end
        local scan = mk("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = rgb(0, 255, 90),
            BackgroundTransparency = 0.88, BorderSizePixel = 0 })
        ugrad(scan, 90, nil, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
        table.insert(anims, function(t) scan.Position = UDim2.new(0, 0, ((t % 5) / 5) * 1.15 - 0.08, 0) end)
    end

    -- 4) LAUTAN: biru cantik, awan putih, ombak, gelembung
    build.ocean = function()
        setBase(90, { { 0, rgb(96, 184, 240) }, { 0.4, rgb(24, 102, 184) }, { 1, rgb(3, 26, 66) } })
        local rnd = Random.new(21)
        beams(3, rgb(210, 240, 255), 0.1, -16)
        local function cloud(y, scale, speed, off, alpha)
            local g = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 110 * scale, 0, 40 * scale),
                BackgroundTransparency = 1, BorderSizePixel = 0 })
            local parts = { { 0, 0.45, 64, 22 }, { 0.22, 0.2, 44, 26 }, { 0.45, 0.3, 52, 28 }, { 0.62, 0.55, 44, 18 } }
            for _, p in ipairs(parts) do
                local e = mk("Frame", { Position = UDim2.new(p[1], 0, p[2], 0),
                    Size = UDim2.new(0, p[3] * scale, 0, p[4] * scale), BackgroundColor3 = rgb(255, 255, 255),
                    BackgroundTransparency = alpha, BorderSizePixel = 0 }, g)
                mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, e)
            end
            table.insert(anims, function(t)
                g.Position = UDim2.new(((t * speed + off) % 1.6) - 0.35, 0, y, 0)
            end)
        end
        cloud(0.12, 1.0, 0.012, 0.1, 0.7)
        cloud(0.26, 0.8, 0.018, 0.6, 0.78)
        cloud(0.42, 1.2, 0.009, 1.1, 0.8)
        for i = 1, 8 do
            local b = circle(0.5, 1, rnd:NextInteger(4, 9), rgb(220, 245, 255), 0.75)
            local sp, ph, x0 = rnd:NextNumber(0.04, 0.1), rnd:NextNumber(0, 5), rnd:NextNumber(0.05, 0.95)
            table.insert(anims, function(t)
                b.Position = UDim2.new(x0 + math.sin(t + ph) * 0.02, 0, 1.05 - ((t * sp + ph) % 1.1), 0)
            end)
        end
        for layer = 1, 2 do
            local col = layer == 1 and rgb(150, 214, 255) or rgb(8, 70, 140)
            local tr = layer == 1 and 0.82 or 0.55
            local yb = layer == 1 and 0.9 or 0.96
            local sp = layer == 1 and 18 or 30
            local NW = math.ceil(FXW() / 55) + 2
            for i = 0, NW - 1 do
                local w = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.new(0, 90, 0, 90),
                    BackgroundColor3 = col, BackgroundTransparency = tr, BorderSizePixel = 0 })
                mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, w)
                table.insert(anims, function(t)
                    local x = ((i * 55 + t * sp) % (55 * NW)) - 60
                    w.Position = UDim2.new(0, x, yb, math.sin(t * 1.4 + i) * 3)
                end)
            end
        end
    end

    -- 5) SUNSET: jingga halus ke ungu malam, matahari terbenam
    build.sunset = function()
        setBase(90, { { 0, rgb(44, 20, 96) }, { 0.38, rgb(126, 50, 130) }, { 0.72, rgb(238, 108, 82) }, { 1, rgb(255, 172, 84) } })
        stars(26, 5, 2, 0.45)
        local glow = blob(0.5, 0.8, 260, rgb(255, 160, 90), 7)
        local sun = circle(0.5, 0.8, 120, rgb(255, 226, 150), 0.05)
        table.insert(anims, function(t)
            local y = 0.8 + math.sin(t * 0.4) * 0.012
            glow.Position = UDim2.new(0.5, 0, y, 0)
            sun.Position = UDim2.new(0.5, 0, y, 0)
        end)
        local rnd = Random.new(31)
        for i = 1, 5 do
            local y = 0.5 + i * 0.07
            local s = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, rnd:NextInteger(70, 120), 0, 6),
                BackgroundColor3 = i % 2 == 0 and rgb(255, 196, 170) or rgb(170, 100, 190),
                BackgroundTransparency = 0.7, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, s)
            local sp, off = rnd:NextNumber(0.008, 0.02), rnd:NextNumber(0, 1.5)
            table.insert(anims, function(t) s.Position = UDim2.new(((t * sp + off) % 1.5) - 0.3, 0, y, 0) end)
        end
        circle(0.12, 1.14, 300, rgb(46, 18, 70), 0.08)
        circle(0.88, 1.17, 330, rgb(38, 14, 60), 0.08)
    end

    -- 6) NEBULA: ungu angkasa + biru, bintang berkelip, bintang jatuh
    build.nebula = function()
        setBase(120, { { 0, rgb(30, 10, 74) }, { 0.5, rgb(10, 16, 72) }, { 1, rgb(54, 14, 100) } })
        local bl = {
            { 0.2, 0.22, 230, rgb(160, 70, 230) }, { 0.88, 0.5, 250, rgb(50, 110, 255) },
            { 0.5, 0.88, 200, rgb(236, 84, 196) }, { 0.25, 0.68, 160, rgb(60, 200, 255) },
            { 0.75, 0.15, 150, rgb(120, 90, 255) },
        }
        for i, b in ipairs(bl) do
            local g = blob(b[1], b[2], b[3], b[4], 7)
            local ph = i * 1.3
            table.insert(anims, function(t)
                g.Position = UDim2.new(b[1] + math.sin(t * 0.25 + ph) * 0.04, 0, b[2] + math.cos(t * 0.2 + ph) * 0.03, 0)
            end)
        end
        stars(46, 3, 2)
        local sh = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 40, 0, 1),
            BackgroundColor3 = rgb(255, 255, 255), BackgroundTransparency = 0.1, BorderSizePixel = 0,
            Rotation = -43, Visible = false })
        ugrad(sh, 0, nil, { { 0, 0 }, { 1, 1 } })
        table.insert(anims, function(t)
            local p = (t % 7) / 7
            if p < 0.14 then
                local q = p / 0.14
                sh.Visible = true
                sh.Position = UDim2.new(0.95 - q * 0.6, 0, 0.05 + q * 0.4, 0)
            else
                sh.Visible = false
            end
        end)
    end

    -- 7) BLACKHOLE: lubang hitam + cakram akresi berputar + cincin foton + partikel jatuh
    build.blackhole = function()
        setBase(90, { { 0, rgb(6, 4, 14) }, { 0.5, rgb(2, 2, 6) }, { 1, rgb(8, 4, 16) } })
        stars(36, 9, 2)
        local cx, cy = 0.5, 0.42
        blob(cx, cy, 300, rgb(110, 50, 200), 6)
        blob(cx, cy, 230, rgb(255, 120, 40), 7)

        local diskCols = { { 0, rgb(255, 120, 30) }, { 0.5, rgb(255, 238, 195) }, { 1, rgb(255, 120, 30) } }
        local spinners = {}
        local function ring(parent, w, h, th, px, py, dir)
            local f = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(px, 0, py, 0),
                Size = UDim2.new(0, w, 0, h), BackgroundTransparency = 1, BorderSizePixel = 0 }, parent)
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, f)
            local s = mk("UIStroke", { Thickness = th, Color = rgb(255, 255, 255),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, f)
            local g = ugrad(s, 0, diskCols)
            table.insert(spinners, { g, dir })
        end
        local dims = { { 210, 56, 5, 1 }, { 178, 45, 3, -1 }, { 148, 34, 2, 1 } }

        -- cakram belakang
        local fill = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(cx, 0, cy, 0),
            Size = UDim2.new(0, 196, 0, 46), BackgroundColor3 = rgb(255, 130, 40),
            BackgroundTransparency = 0.88, BorderSizePixel = 0 })
        mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, fill)
        for _, d in ipairs(dims) do ring(deco, d[1], d[2], d[3], cx, cy, d[4]) end

        -- cincin foton + inti hitam
        local photon = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(cx, 0, cy, 0),
            Size = UDim2.new(0, 94, 0, 94), BackgroundTransparency = 1, BorderSizePixel = 0 })
        mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, photon)
        mk("UIStroke", { Thickness = 2, Color = rgb(255, 150, 60), Transparency = 0.5 }, photon)
        local hole = circle(cx, cy, 70, rgb(0, 0, 0), 0)
        mk("UIStroke", { Thickness = 2, Color = rgb(255, 196, 120), Transparency = 0.2 }, hole)

        -- cakram depan (separuh bawah) supaya kelihatan melintas di depan lubang hitam
        local front = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(cx, 0, cy, 0),
            Size = UDim2.new(0, 230, 0, 34), BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true })
        for _, d in ipairs(dims) do ring(front, d[1], d[2], d[3], 0.5, 0, d[4]) end

        table.insert(anims, function(t)
            for i = 1, #spinners do
                local s = spinners[i]
                s[1].Rotation = (t * 45 * s[2] * (1 + (i % 3) * 0.2)) % 360
            end
        end)

        local rnd = Random.new(41)
        for _ = 1, 10 do
            local d = circle(cx, cy, 2, rgb(255, 220, 170), 0.2)
            local ph, sp = rnd:NextNumber(0, 6.28), rnd:NextNumber(0.25, 0.6)
            table.insert(anims, function(t)
                local p = (t * sp * 0.2 + ph / 6.28) % 1
                local r = 1 - p * 0.75
                local a = ph + t * sp * 2.2 * (1 + p * 2)
                d.Position = UDim2.new(cx, math.cos(a) * 112 * r, cy, math.sin(a) * 36 * r)
                d.BackgroundTransparency = 0.1 + p * 0.85
            end)
        end
    end

    -- 8) AURORA: pita cahaya hijau-biru-ungu yang melayang pelan + bintang berkedip
    build.aurora = function()
        setBase(160, { { 0, rgb(4, 10, 28) }, { 0.55, rgb(6, 28, 46) }, { 1, rgb(16, 10, 42) } })
        stars(40, 17, 2, 0.75)
        local cols = { rgb(60, 255, 190), rgb(90, 170, 255), rgb(180, 110, 255) }
        for i = 1, 3 do
            local y0 = 0.16 + i * 0.17
            local band = mk("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, y0, 0),
                Size = UDim2.new(1.7, 0, 0, 74), Rotation = -8 + i * 6,
                BackgroundColor3 = cols[i], BackgroundTransparency = 0.8, BorderSizePixel = 0,
            })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, band)
            ugrad(band, 0, nil, { { 0, 1 }, { 0.3, 0.15 }, { 0.7, 0.15 }, { 1, 1 } })
            local ph = i * 1.9
            table.insert(anims, function(t)
                band.Position = UDim2.new(0.5 + math.sin(t * 0.22 + ph) * 0.08, 0, y0 + math.sin(t * 0.35 + ph) * 0.04, 0)
                band.Rotation = -8 + i * 6 + math.sin(t * 0.3 + ph) * 5
                band.BackgroundTransparency = 0.78 + math.sin(t * 0.6 + ph) * 0.07
            end)
        end
        local g = blob(0.88, 0.92, 210, rgb(60, 255, 190), 6)
        table.insert(anims, function(t) g.Size = UDim2.new(0, 210 + math.sin(t * 0.5) * 18, 0, 210 + math.sin(t * 0.5) * 18) end)
    end

    -- 9) SAKURA: kelopak bunga jatuh melayang + cahaya pink berdenyut
    build.sakura = function()
        setBase(150, { { 0, rgb(54, 16, 42) }, { 0.5, rgb(98, 36, 78) }, { 1, rgb(42, 14, 34) } })
        local b1 = blob(0.14, 0.12, 230, rgb(255, 150, 200), 7)
        local b2 = blob(0.9, 0.86, 250, rgb(255, 120, 170), 7)
        table.insert(anims, function(t)
            b1.Position = UDim2.new(0.14 + math.sin(t * 0.2) * 0.03, 0, 0.12 + math.cos(t * 0.17) * 0.03, 0)
            b2.Position = UDim2.new(0.9 + math.cos(t * 0.18) * 0.03, 0, 0.86 + math.sin(t * 0.22) * 0.03, 0)
        end)
        local rnd = Random.new(23)
        for _ = 1, 18 do
            local sz = rnd:NextInteger(5, 9)
            local pt = mk("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, sz, 0, math.max(3, math.floor(sz * 0.7))),
                BackgroundColor3 = rgb(255, rnd:NextInteger(170, 205), rnd:NextInteger(200, 225)),
                BackgroundTransparency = rnd:NextNumber(0.1, 0.35), BorderSizePixel = 0,
            })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, pt)
            local x0, sp, ph, sw = rnd:NextNumber(), rnd:NextNumber(0.03, 0.07), rnd:NextNumber(), rnd:NextNumber(0.02, 0.06)
            table.insert(anims, function(t)
                local q = (t * sp + ph) % 1
                pt.Position = UDim2.new((x0 + math.sin(t * 0.8 + ph * 6) * sw + q * 0.1) % 1, 0, -0.05 + q * 1.1, 0)
                pt.Rotation = t * 40 + ph * 360
            end)
        end
    end

    -- bintang jatuh (dipakai tema luar angkasa)
    local function shoot(period, delay0)
        local sh = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 46, 0, 1),
            BackgroundColor3 = rgb(255, 255, 255), BackgroundTransparency = 0.1, BorderSizePixel = 0,
            Rotation = -40, Visible = false })
        ugrad(sh, 0, nil, { { 0, 0 }, { 1, 1 } })
        table.insert(anims, function(t)
            local p = ((t + delay0) % period) / period
            if p < 0.12 then
                local q = p / 0.12
                sh.Visible = true
                sh.Position = UDim2.new(0.95 - q * 0.55, 0, 0.04 + q * 0.38, 0)
            else
                sh.Visible = false
            end
        end)
    end

    -- 10) GALAKSI: galaksi spiral berputar + inti bercahaya + bintang berkedip
    build.galaxy = function()
        setBase(150, { { 0, rgb(6, 3, 18) }, { 0.5, rgb(16, 8, 38) }, { 1, rgb(4, 3, 14) } })
        stars(56, 31, 2)
        local cx, cy = 0.5, 0.4
        local glow = blob(cx, cy, 300, rgb(150, 80, 230), 6)
        local spin = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(cx, 0, cy, 0),
            Size = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, BorderSizePixel = 0 })
        local rnd = Random.new(77)
        for arm = 0, 2 do
            for i = 1, 26 do
                local r = 8 + i * 4.8
                local th = i * 0.27 + arm * 2.094 + rnd:NextNumber(-0.13, 0.13)
                local k = i / 26
                local sz = (i < 6) and 4 or rnd:NextInteger(2, 4)
                local d = circle(0.5, 0.5, sz, rgb(math.floor(255 - 120 * k), math.floor(205 - 75 * k), math.floor(150 + 105 * k)),
                    0.05 + 0.5 * k, spin)
                d.Position = UDim2.new(0.5, math.cos(th) * r, 0.5, math.sin(th) * r)
            end
        end
        local halo = blob(cx, cy, 90, rgb(255, 230, 190), 6)
        local core = circle(cx, cy, 20, rgb(255, 242, 214), 0.05)
        table.insert(anims, function(t)
            spin.Rotation = t * 8
            local s = 20 + math.sin(t * 1.4) * 3
            core.Size = UDim2.new(0, s, 0, s)
            glow.Position = UDim2.new(cx + math.sin(t * 0.2) * 0.02, 0, cy + math.cos(t * 0.17) * 0.02, 0)
        end)
        shoot(7, 0)
        shoot(11, 4)
    end

    -- 11) TATA SURYA: matahari + 7 planet mengorbit (bulan, cincin Saturnus) + bintang
    build.solar = function()
        setBase(100, { { 0, rgb(3, 4, 14) }, { 0.5, rgb(8, 10, 26) }, { 1, rgb(3, 3, 12) } })
        stars(54, 5, 2)
        local cx, cy, SQ = 0.5, 0.42, 0.36
        blob(cx, cy, 180, rgb(255, 150, 40), 7)
        local sun = circle(cx, cy, 32, rgb(255, 205, 90), 0.02)
        mk("UIStroke", { Thickness = 2, Color = rgb(255, 150, 40), Transparency = 0.4 }, sun)
        table.insert(anims, function(t)
            local sz = 32 + math.sin(t * 1.6) * 2.5
            sun.Size = UDim2.new(0, sz, 0, sz)
        end)
        local P = {
            { 44, 5, rgb(176, 166, 156), 1.30 }, { 62, 8, rgb(240, 176, 96), 0.95 },
            { 82, 9, rgb(84, 150, 255), 0.75, "moon" }, { 102, 7, rgb(236, 104, 72), 0.60 },
            { 124, 15, rgb(226, 190, 140), 0.38 }, { 146, 12, rgb(236, 216, 164), 0.29, "ring" },
            { 164, 9, rgb(140, 212, 232), 0.22 },
        }
        for i, p in ipairs(P) do
            local r, sz, col, sp, kind = p[1], p[2], p[3], p[4], p[5]
            local orb = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(cx, 0, cy, 0),
                Size = UDim2.new(0, r * 2, 0, r * 2 * SQ), BackgroundTransparency = 1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, orb)
            mk("UIStroke", { Thickness = 1, Color = rgb(255, 255, 255), Transparency = 0.86 }, orb)
            local pl = circle(cx, cy, sz, col, 0)
            local ring, moon
            if kind == "ring" then
                ring = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, sz * 2.3, 0, sz * 0.7),
                    BackgroundTransparency = 1, BorderSizePixel = 0 })
                mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, ring)
                mk("UIStroke", { Thickness = 2, Color = rgb(232, 204, 150), Transparency = 0.2 }, ring)
            elseif kind == "moon" then
                moon = circle(cx, cy, 3, rgb(225, 225, 232), 0)
            end
            local ph = i * 1.1
            table.insert(anims, function(t)
                local a = ph + t * sp * 0.5
                local px, py = math.cos(a) * r, math.sin(a) * r * SQ
                pl.Position = UDim2.new(cx, px, cy, py)
                pl.ZIndex = (py < 0) and 0 or 2
                if ring then
                    ring.Position = pl.Position
                    ring.ZIndex = (py < 0) and 0 or 3
                end
                if moon then
                    local b = t * 3
                    moon.Position = UDim2.new(cx, px + math.cos(b) * 10, cy, py + math.sin(b) * 4)
                    moon.ZIndex = (py < 0) and 0 or 3
                end
            end)
        end
        shoot(9, 2)
    end

    -- 12) SATURNUS: planet besar bercincin, pita awan bergeser, bulan mengorbit di depan/belakang
    build.saturn = function()
        setBase(160, { { 0, rgb(20, 9, 14) }, { 0.5, rgb(40, 18, 22) }, { 1, rgb(12, 6, 10) } })
        stars(44, 12, 2)
        local cx, cy = 0.5, 0.4
        local glow = blob(cx, cy, 270, rgb(255, 170, 100), 6)
        local function ellipse(parent, w, h, th, col, tr, px, py, zi)
            local f = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(px, 0, py, 0),
                Size = UDim2.new(0, w, 0, h), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = zi }, parent)
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, f)
            mk("UIStroke", { Thickness = th, Color = col, Transparency = tr }, f)
            return f
        end
        -- cincin (bagian belakang, ketutup planet)
        ellipse(deco, 252, 64, 7, rgb(214, 176, 128), 0.25, cx, cy, 1)
        ellipse(deco, 206, 50, 3, rgb(240, 210, 160), 0.3, cx, cy, 1)
        -- planet
        local planet = circle(cx, cy, 124, rgb(222, 166, 106), 0)
        planet.ZIndex = 2
        local bands = ugrad(planet, 90, { { 0, rgb(188, 128, 82) }, { 0.2, rgb(242, 198, 142) }, { 0.4, rgb(206, 148, 96) },
            { 0.6, rgb(248, 208, 152) }, { 0.8, rgb(196, 136, 88) }, { 1, rgb(156, 104, 68) } })
        local shade = circle(cx, cy, 124, rgb(0, 0, 0), 0)
        shade.ZIndex = 3
        ugrad(shade, 0, nil, { { 0, 1 }, { 0.5, 0.82 }, { 1, 0.15 } })
        -- cincin (bagian depan = separuh bawah saja, di atas planet)
        local clip = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(cx, 0, cy, 0),
            Size = UDim2.new(0, 280, 0, 60), BackgroundTransparency = 1, BorderSizePixel = 0,
            ClipsDescendants = true, ZIndex = 4 })
        ellipse(clip, 252, 64, 7, rgb(214, 176, 128), 0.25, 0.5, 0, 4)
        ellipse(clip, 206, 50, 3, rgb(240, 210, 160), 0.3, 0.5, 0, 4)
        -- bulan
        local moon = circle(cx, cy, 12, rgb(206, 204, 210), 0)
        local moon2 = circle(cx, cy, 6, rgb(150, 190, 235), 0)
        table.insert(anims, function(t)
            bands.Offset = Vector2.new(0, math.sin(t * 0.3) * 0.04)
            local a = t * 0.55
            moon.Position = UDim2.new(cx, math.cos(a) * 150, cy, math.sin(a) * 44)
            moon.ZIndex = (math.sin(a) > 0) and 5 or 0
            local b = t * 0.9 + 2
            moon2.Position = UDim2.new(cx, math.cos(b) * 112, cy, math.sin(b) * 30 - 36)
            moon2.ZIndex = (math.sin(b) > 0) and 5 or 0
            glow.Position = UDim2.new(cx, 0, cy + math.sin(t * 0.4) * 0.015, 0)
        end)
        shoot(8, 1)
    end

    -- 13) NEON RETRO: matahari synthwave + grid jalan yang terus bergerak ke depan
    build.neon = function()
        setBase(90, { { 0, rgb(14, 4, 32) }, { 0.55, rgb(46, 8, 76) }, { 1, rgb(10, 3, 24) } })
        stars(44, 9, 2, 0.5)
        local hz = 0.56
        local sun = circle(0.5, 0.36, 132, rgb(255, 90, 170), 0)
        ugrad(sun, 90, { { 0, rgb(255, 224, 96) }, { 0.5, rgb(255, 92, 154) }, { 1, rgb(184, 44, 204) } })
        blob(0.5, 0.36, 230, rgb(255, 70, 190), 6)
        local ground = mk("Frame", { Position = UDim2.new(0, 0, hz, 0), Size = UDim2.new(1, 0, 1 - hz, 0),
            BackgroundColor3 = rgb(18, 4, 44), BackgroundTransparency = 0.1, BorderSizePixel = 0 })
        ugrad(ground, 90, nil, { { 0, 0.5 }, { 1, 0 } })
        mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, hz, 0), Size = UDim2.new(1, 0, 0, 3),
            BackgroundColor3 = rgb(0, 236, 255), BackgroundTransparency = 0.15, BorderSizePixel = 0 })
        -- garis menuju titik hilang
        local L = 330
        for j = -7, 7 do
            local th = j * 0.17
            mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, math.sin(th) * L / 2, hz, math.cos(th) * L / 2),
                Size = UDim2.new(0, 1, 0, L), Rotation = -math.deg(th),
                BackgroundColor3 = rgb(255, 64, 204), BackgroundTransparency = 0.45, BorderSizePixel = 0 })
        end
        -- garis melintang yang bergerak mendekat
        local N = 9
        local lines = {}
        for i = 1, N do
            lines[i] = mk("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = rgb(255, 64, 204),
                BorderSizePixel = 0, BackgroundTransparency = 0.4 })
        end
        table.insert(anims, function(t)
            for i = 1, N do
                local u = (t * 0.22 + i / N) % 1
                lines[i].Position = UDim2.new(0, 0, hz + u * u * (1 - hz), 0)
                lines[i].BackgroundTransparency = 0.25 + (1 - u) * 0.6
            end
            local s = 132 + math.sin(t * 1.3) * 5
            sun.Size = UDim2.new(0, s, 0, s)
        end)
        shoot(10, 3)
    end

    -- ==================== 15 TEMA BARU ====================
    -- partikel umum: jatuh (dir=1) / naik (dir=-1), bisa teks emoji atau lingkaran/persegi panjang
    build._particles = function(n, seed, o)
        local rnd = Random.new(seed)
        for _ = 1, math.floor(n * DENS()) do
            local sz = rnd:NextInteger(o.s1, o.s2)
            local e
            if o.glyph then
                e = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, sz, 0, sz),
                    BackgroundTransparency = 1, Text = o.glyph[rnd:NextInteger(1, #o.glyph)], TextSize = sz,
                    TextTransparency = o.tr or 0.2 })
            elseif o.rect then
                e = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, o.w or 1, 0, sz),
                    BackgroundColor3 = o.color, BackgroundTransparency = o.tr or 0.4, BorderSizePixel = 0,
                    Rotation = o.angle or 0 })
            else
                e = circle(0.5, 0.5, sz, o.color, o.tr or 0.3)
            end
            local x0, sp, ph = rnd:NextNumber(), rnd:NextNumber(o.sp1, o.sp2), rnd:NextNumber(0, 10)
            table.insert(anims, function(t)
                local p = (t * sp + ph) % 1.2 - 0.1
                if o.dir < 0 then p = 1 - p end
                local x = x0 + math.sin(t * (o.swf or 1) + ph) * (o.sway or 0.03) + p * (o.drift or 0)
                e.Position = UDim2.new(x % 1, 0, p, 0)
                if o.rot then e.Rotation = (t * o.rot + ph * 40) % 360 end
            end)
        end
    end

    -- kota: gedung siluet + jendela menyala berkedip
    build._skyline = function(seed, n, col, hMin, hMax, wins, base)
        n = math.max(n, math.floor(n * WX() + 0.5))
        local rnd = Random.new(seed)
        local lit = {}
        for i = 0, n - 1 do
            local h = rnd:NextInteger(hMin, hMax)
            local b = mk("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(i / n, 0, base, 0),
                Size = UDim2.new(1 / n, 1, 0, h), BackgroundColor3 = col, BorderSizePixel = 0 })
            if wins then
                for r = 0, math.floor(h / 11) - 1 do
                    for c = 0, 2 do
                        if rnd:NextNumber() < 0.45 then
                            local w = mk("Frame", { Position = UDim2.new(0, 5 + c * 9, 0, 6 + r * 11),
                                Size = UDim2.new(0, 4, 0, 5), BackgroundColor3 = wins[rnd:NextInteger(1, #wins)],
                                BackgroundTransparency = 0.15, BorderSizePixel = 0 }, b)
                            if rnd:NextNumber() < 0.18 then table.insert(lit, { w, rnd:NextNumber(0, 6), rnd:NextNumber(0.5, 2) }) end
                        end
                    end
                end
            end
        end
        table.insert(anims, function(t)
            for i = 1, #lit do
                local l = lit[i]
                l[1].BackgroundTransparency = (math.sin(t * l[3] + l[2]) > 0.3) and 0.1 or 0.9
            end
        end)
    end

    -- ubur-ubur bercahaya
    build._jelly = function(x, y, size, col, ph)
        local g = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(x, 0, y, 0),
            Size = UDim2.new(0, size, 0, size * 1.8), BackgroundTransparency = 1, BorderSizePixel = 0 })
        local us = mk("UIScale", {}, g)
        local dome = mk("Frame", { Size = UDim2.new(1, 0, 0, size * 0.75), BackgroundColor3 = col,
            BackgroundTransparency = 0.45, BorderSizePixel = 0 }, g)
        mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, dome)
        mk("UIStroke", { Thickness = 1.5, Color = col, Transparency = 0.2 }, dome)
        ugrad(dome, 90, nil, { { 0, 0.1 }, { 1, 0.7 } })
        local tents = {}
        for i = 1, 5 do
            local tn = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new((i - 0.5) / 5, 0, 0, size * 0.62),
                Size = UDim2.new(0, 2, 0, size * 0.95), BackgroundColor3 = col, BackgroundTransparency = 0.5,
                BorderSizePixel = 0 }, g)
            ugrad(tn, 90, nil, { { 0, 0.2 }, { 1, 1 } })
            tents[i] = tn
        end
        table.insert(anims, function(t)
            local k = math.sin(t * 1.6 + ph)
            us.Scale = 1 + k * 0.07
            g.Position = UDim2.new(x + math.sin(t * 0.3 + ph) * 0.05, 0, y + math.sin(t * 0.5 + ph) * 0.05, 0)
            for i = 1, 5 do tents[i].Rotation = math.sin(t * 1.4 + ph + i) * 9 end
        end)
    end

    -- 16) LAVA: gunung api, lava bercahaya, bara api naik
    build.lava = function()
        setBase(90, { { 0, rgb(36, 6, 6) }, { 0.6, rgb(118, 22, 8) }, { 1, rgb(255, 110, 20) } })
        stars(14, 3, 2, 0.35)
        local glow = blob(0.5, 1.0, 340, rgb(255, 120, 20), 7)
        local peak = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 1.05, 0),
            Size = UDim2.new(0, 270, 0, 270), Rotation = 45, BackgroundColor3 = rgb(22, 7, 6), BorderSizePixel = 0 })
        mk("UICorner", { CornerRadius = UDim.new(0, 16) }, peak)
        local crater = circle(0.5, 0.66, 26, rgb(255, 150, 40), 0.1)
        local cglow = blob(0.5, 0.66, 80, rgb(255, 130, 30), 6)
        local NL = math.ceil(FXW() / 62) + 1
        for i = 0, NL - 1 do
            local w = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.new(0, 90, 0, 60),
                BackgroundColor3 = i % 2 == 0 and rgb(255, 90, 20) or rgb(255, 160, 40), BackgroundTransparency = 0.25,
                BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, w)
            table.insert(anims, function(t)
                w.Position = UDim2.new(0, ((i * 62 + t * (14 + i * 3)) % (62 * NL)) - 50, 0.96, math.sin(t * 1.6 + i) * 3)
            end)
        end
        build._particles(26, 51, { s1 = 2, s2 = 5, color = rgb(255, 170, 60), tr = 0.15, dir = -1, sp1 = 0.06, sp2 = 0.16, sway = 0.04, swf = 1.3 })
        build._particles(5, 52, { glyph = { "🔥" }, s1 = 14, s2 = 20, dir = -1, sp1 = 0.05, sp2 = 0.1, sway = 0.03, tr = 0.35 })
        table.insert(anims, function(t)
            local s = 340 + math.sin(t * 1.5) * 16
            glow.Size = UDim2.new(0, s, 0, s)
            crater.BackgroundTransparency = 0.1 + (math.sin(t * 3) + 1) * 0.12
            cglow.Size = UDim2.new(0, 80 + math.sin(t * 2.4) * 10, 0, 80 + math.sin(t * 2.4) * 10)
        end)
    end

    -- 17) SALJU: salju turun, gunung es, aurora tipis
    build.snow = function()
        setBase(90, { { 0, rgb(150, 200, 240) }, { 0.45, rgb(40, 90, 160) }, { 1, rgb(8, 24, 60) } })
        stars(18, 8, 2, 0.4)
        beams(3, rgb(190, 240, 255), 0.1, -14)
        for i = 0, 3 do
            local m = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.12 + i * 0.3, 0, 1.0, 0),
                Size = UDim2.new(0, 150, 0, 150), Rotation = 45, BackgroundColor3 = i % 2 == 0 and rgb(180, 215, 245) or rgb(130, 175, 225),
                BackgroundTransparency = 0.3, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0, 10) }, m)
        end
        circle(0.5, 1.12, 420, rgb(235, 245, 255), 0.05)
        build._particles(26, 61, { s1 = 2, s2 = 4, color = rgb(255, 255, 255), tr = 0.2, dir = 1, sp1 = 0.05, sp2 = 0.1, sway = 0.04, swf = 1.1 })
        build._particles(12, 62, { s1 = 4, s2 = 6, color = rgb(235, 248, 255), tr = 0.35, dir = 1, sp1 = 0.09, sp2 = 0.16, sway = 0.05, swf = 0.8 })
        build._particles(5, 63, { glyph = { "❄️" }, s1 = 14, s2 = 22, dir = 1, sp1 = 0.04, sp2 = 0.08, sway = 0.05, rot = 25, tr = 0.3 })
    end

    -- 18) HUJAN: awan gelap, hujan miring, kilat, riak air
    build.rain = function()
        setBase(90, { { 0, rgb(26, 32, 48) }, { 1, rgb(6, 10, 20) } })
        blob(0.2, 0.0, 230, rgb(90, 100, 120), 6)
        blob(0.8, 0.02, 240, rgb(70, 80, 104), 6)
        blob(0.5, -0.04, 260, rgb(100, 110, 130), 6)
        build._particles(34, 71, { rect = true, w = 1, s1 = 10, s2 = 18, color = rgb(170, 205, 245), tr = 0.45, angle = 10, dir = 1, sp1 = 0.5, sp2 = 0.9, sway = 0, drift = -0.06 })
        for i = 1, 4 do
            local r = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, r)
            local st = mk("UIStroke", { Thickness = 1.5, Color = rgb(170, 205, 245) }, r)
            local x, y, off = 0.15 + i * 0.18, 0.88 + (i % 2) * 0.07, i * 0.8
            table.insert(anims, function(t)
                local p = ((t * 0.7) + off) % 1
                r.Position = UDim2.new(x, 0, y, 0)
                r.Size = UDim2.new(0, 8 + p * 46, 0, 3 + p * 14)
                st.Transparency = 0.3 + p * 0.7
            end)
        end
        local flash = mk("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(210, 225, 255),
            BackgroundTransparency = 1, BorderSizePixel = 0 })
        table.insert(anims, function(t)
            local p = t % 6.5
            if p < 0.08 then flash.BackgroundTransparency = 0.7
            elseif p < 0.16 then flash.BackgroundTransparency = 0.93
            elseif p < 0.24 then flash.BackgroundTransparency = 0.8
            else flash.BackgroundTransparency = math.min(1, flash.BackgroundTransparency + 0.08) end
        end)
    end

    -- 19) GURUN: matahari besar, bukit pasir, unta jalan, debu
    build.desert = function()
        setBase(90, { { 0, rgb(255, 196, 120) }, { 0.5, rgb(236, 138, 74) }, { 1, rgb(120, 60, 40) } })
        local sunGlow = blob(0.5, 0.28, 260, rgb(255, 236, 170), 7)
        local sun = circle(0.5, 0.28, 90, rgb(255, 246, 200), 0.05)
        beams(3, rgb(255, 230, 170), 0.1, -12)
        circle(0.15, 1.12, 360, rgb(200, 120, 66), 0.05)
        circle(0.8, 1.15, 380, rgb(176, 98, 56), 0.05)
        circle(0.5, 1.28, 460, rgb(138, 74, 46), 0.05)
        mk("TextLabel", { Position = UDim2.new(0.06, 0, 0.84, 0), Size = UDim2.new(0, 30, 0, 30), BackgroundTransparency = 1, Text = "🌵", TextSize = 22 })
        mk("TextLabel", { Position = UDim2.new(0.86, 0, 0.88, 0), Size = UDim2.new(0, 30, 0, 30), BackgroundTransparency = 1, Text = "🌵", TextSize = 18 })
        local camel = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 1), Size = UDim2.new(0, 40, 0, 40), BackgroundTransparency = 1, Text = "🐪", TextSize = 28 })
        local rnd = Random.new(81)
        for _ = 1, 14 do
            local d = circle(0.5, 0.5, rnd:NextInteger(2, 4), rgb(255, 224, 170), 0.5)
            local y0, sp, ph = rnd:NextNumber(0.3, 0.95), rnd:NextNumber(0.03, 0.08), rnd:NextNumber(0, 8)
            table.insert(anims, function(t)
                d.Position = UDim2.new(((t * sp + ph) % 1.2) - 0.1, 0, y0 + math.sin(t + ph) * 0.02, 0)
            end)
        end
        table.insert(anims, function(t)
            camel.Position = UDim2.new(((t * 0.02) % 1.3) - 0.15, 0, 0.9 + math.sin(t * 3) * 0.004, 0)
            local s = 260 + math.sin(t * 0.8) * 12
            sunGlow.Size = UDim2.new(0, s, 0, s)
        end)
    end

    -- 20) CYBERPUNK: kota neon, papan neon, glitch
    build.cyber = function()
        setBase(160, { { 0, rgb(22, 4, 44) }, { 0.55, rgb(64, 6, 74) }, { 1, rgb(4, 20, 44) } })
        stars(20, 4, 2, 0.4)
        local moon = circle(0.72, 0.22, 74, rgb(255, 255, 255), 0.1)
        ugrad(moon, 90, { { 0, rgb(255, 220, 90) }, { 1, rgb(255, 40, 170) } })
        for i = 1, 6 do
            mk("Frame", { Position = UDim2.new(0.72, -37, 0.22, -37 + 30 + i * 6), Size = UDim2.new(0, 74, 0, 1 + i * 0.6),
                BackgroundColor3 = rgb(22, 4, 44), BorderSizePixel = 0 })
        end
        build._skyline(91, 9, rgb(12, 6, 28), 90, 190, { rgb(255, 230, 80), rgb(0, 230, 255), rgb(255, 60, 190) }, 1.0)
        build._skyline(92, 7, rgb(6, 4, 16), 50, 110, { rgb(0, 230, 255), rgb(255, 60, 190) }, 1.02)
        local neons = {}
        for i = 1, 4 do
            local n = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.12 + i * 0.2, 0, 0.55 + (i % 2) * 0.08, 0),
                Size = UDim2.new(0, 46, 0, 4), BackgroundColor3 = (i % 2 == 0) and rgb(0, 240, 255) or rgb(255, 60, 190),
                BackgroundTransparency = 0.1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, n)
            mk("UIStroke", { Thickness = 3, Color = n.BackgroundColor3, Transparency = 0.7 }, n)
            neons[i] = n
        end
        build._particles(12, 93, { rect = true, w = 1, s1 = 8, s2 = 14, color = rgb(255, 80, 200), tr = 0.5, angle = 14, dir = 1, sp1 = 0.3, sp2 = 0.6, sway = 0, drift = -0.08 })
        local glitch = mk("Frame", { Size = UDim2.new(1, 0, 0, 10), BackgroundColor3 = rgb(0, 240, 255),
            BackgroundTransparency = 1, BorderSizePixel = 0 })
        table.insert(anims, function(t)
            for i = 1, 4 do
                neons[i].BackgroundTransparency = (math.sin(t * (2 + i) + i * 2) > -0.6) and 0.1 or 0.8
            end
            local p = t % 4
            if p < 0.18 then
                glitch.BackgroundTransparency = 0.8
                glitch.Position = UDim2.new(((p * 37) % 1) * 0.2 - 0.05, 0, (t * 7.3) % 0.9, 0)
            else
                glitch.BackgroundTransparency = 1
            end
        end)
    end

    -- 21) CANDY: warna permen, gelembung, taburan warna-warni
    build.candy = function()
        setBase(135, { { 0, rgb(255, 120, 180) }, { 0.5, rgb(150, 110, 230) }, { 1, rgb(70, 170, 230) } })
        blob(0.15, 0.2, 200, rgb(255, 255, 255), 6)
        blob(0.88, 0.75, 220, rgb(255, 230, 120), 6)
        for i = 1, 9 do
            local b = circle(0.5, 0.5, 14 + (i * 7) % 26, rgb(255, 255, 255), 0.82)
            mk("UIStroke", { Thickness = 1.5, Color = rgb(255, 255, 255), Transparency = 0.4 }, b)
            local sp, ph, x0 = 0.03 + (i % 4) * 0.015, i * 1.3, (i * 0.113) % 1
            table.insert(anims, function(t)
                b.Position = UDim2.new((x0 + math.sin(t * 0.7 + ph) * 0.04) % 1, 0, 1.1 - ((t * sp + ph) % 1.2), 0)
            end)
        end
        local cols = { rgb(255, 230, 90), rgb(120, 240, 200), rgb(255, 255, 255), rgb(255, 150, 90) }
        local rnd = Random.new(101)
        for i = 1, 22 do
            local s = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 3, 0, 9),
                BackgroundColor3 = cols[(i % #cols) + 1], BackgroundTransparency = 0.1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, s)
            local x0, sp, ph = rnd:NextNumber(), rnd:NextNumber(0.03, 0.07), rnd:NextNumber(0, 9)
            table.insert(anims, function(t)
                local p = (t * sp + ph) % 1.2 - 0.1
                s.Position = UDim2.new((x0 + math.sin(t * 0.6 + ph) * 0.03) % 1, 0, p, 0)
                s.Rotation = (t * 60 + ph * 70) % 360
            end)
        end
        build._particles(5, 102, { glyph = { "🍭", "🍬", "🍩", "🧁" }, s1 = 18, s2 = 26, dir = -1, sp1 = 0.02, sp2 = 0.05, sway = 0.05, swf = 0.8, rot = 20, tr = 0.1 })
    end

    -- 22) KOTA MALAM: bulan, gedung berlapis, jendela berkedip, lampu mobil
    build.city = function()
        setBase(90, { { 0, rgb(10, 14, 40) }, { 0.6, rgb(30, 36, 86) }, { 1, rgb(80, 62, 120) } })
        stars(40, 14, 2, 0.5)
        blob(0.8, 0.16, 120, rgb(255, 240, 190), 6)
        circle(0.8, 0.16, 38, rgb(255, 246, 214), 0.05)
        build._skyline(111, 8, rgb(34, 36, 78), 110, 220, nil, 1.0)
        build._skyline(112, 10, rgb(18, 20, 50), 60, 160, { rgb(255, 226, 130), rgb(255, 200, 100) }, 1.0)
        local cars = {}
        for i = 1, 4 do
            local c = circle(0.5, 0.97, 4, i % 2 == 0 and rgb(255, 80, 80) or rgb(255, 250, 220), 0.1)
            cars[i] = { c, 0.1 + i * 0.07, i * 0.23, i % 2 == 0 and -1 or 1 }
        end
        shoot(9, 2)
        table.insert(anims, function(t)
            for i = 1, 4 do
                local c = cars[i]
                local p = (t * c[2] + c[3]) % 1
                if c[4] < 0 then p = 1 - p end
                c[1].Position = UDim2.new(p, 0, 0.975 + (i % 2) * 0.012, 0)
            end
        end)
    end

    -- 23) PETIR UNGU: badai ungu, kilat zig-zag
    build.thunder = function()
        setBase(90, { { 0, rgb(34, 10, 72) }, { 0.5, rgb(14, 6, 40) }, { 1, rgb(4, 2, 14) } })
        local c1 = blob(0.25, 0.04, 240, rgb(120, 60, 200), 6)
        local c2 = blob(0.75, 0.0, 250, rgb(90, 50, 170), 6)
        local W = math.max(260, FXW())
        local H = math.max(300, FXH())
        local rnd = Random.new(121)
        local bolts = {}
        for b = 1, 3 do
            local g = mk("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false })
            local x, y = W * (0.2 + b * 0.22), 0
            for _ = 1, 6 do
                local dx, dy = rnd:NextNumber(-36, 36), H * 0.14
                local len = math.sqrt(dx * dx + dy * dy)
                local seg = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, x + dx / 2, 0, y + dy / 2),
                    Size = UDim2.new(0, 3, 0, len), Rotation = -math.deg(math.atan2(dx, dy)),
                    BackgroundColor3 = rgb(245, 235, 255), BorderSizePixel = 0 }, g)
                mk("UIStroke", { Thickness = 4, Color = rgb(170, 110, 255), Transparency = 0.55 }, seg)
                x, y = x + dx, y + dy
            end
            bolts[b] = g
        end
        local flash = mk("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = rgb(190, 150, 255),
            BackgroundTransparency = 1, BorderSizePixel = 0 })
        build._particles(18, 122, { rect = true, w = 1, s1 = 8, s2 = 14, color = rgb(200, 170, 255), tr = 0.55, angle = 8, dir = 1, sp1 = 0.4, sp2 = 0.8, sway = 0, drift = -0.04 })
        table.insert(anims, function(t)
            c1.Position = UDim2.new(0.25 + math.sin(t * 0.3) * 0.05, 0, 0.04, 0)
            c2.Position = UDim2.new(0.75 + math.cos(t * 0.25) * 0.05, 0, 0.0, 0)
            local cyc = math.floor(t / 4.5)
            local p = t % 4.5
            for b = 1, 3 do bolts[b].Visible = false end
            if p < 0.3 then
                local on = (p < 0.08) or (p > 0.14 and p < 0.22)
                bolts[(cyc % 3) + 1].Visible = on
                flash.BackgroundTransparency = on and 0.8 or 0.94
            else
                flash.BackgroundTransparency = math.min(1, flash.BackgroundTransparency + 0.06)
            end
        end)
    end

    -- 24) EMAS MEWAH: hitam-emas, kilau menyapu, cincin berputar, kilauan
    build.gold = function()
        setBase(135, { { 0, rgb(10, 8, 4) }, { 0.5, rgb(46, 34, 12) }, { 1, rgb(8, 6, 3) } })
        local goldCols = { { 0, rgb(120, 80, 20) }, { 0.5, rgb(255, 226, 130) }, { 1, rgb(160, 110, 30) } }
        blob(0.95, 0.05, 190, rgb(240, 190, 80), 6)
        blob(0.05, 0.95, 170, rgb(220, 160, 60), 6)
        local spin = {}
        for _, d in ipairs({ { 230, 2, 1 }, { 180, 1.5, -1 }, { 130, 1, 1 } }) do
            local f = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.9, 0, 0.1, 0),
                Size = UDim2.new(0, d[1], 0, d[1]), BackgroundTransparency = 1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, f)
            local s = mk("UIStroke", { Thickness = d[2], Color = rgb(255, 255, 255), Transparency = 0.25 }, f)
            spin[#spin + 1] = { ugrad(s, 0, goldCols), d[3] }
        end
        for _, y in ipairs({ 0.045, 0.955 }) do
            local l = mk("Frame", { Position = UDim2.new(0.05, 0, y, 0), Size = UDim2.new(0.9, 0, 0, 1),
                BackgroundColor3 = rgb(255, 255, 255), BackgroundTransparency = 0.2, BorderSizePixel = 0 })
            ugrad(l, 0, { { 0, rgb(160, 110, 30) }, { 0.5, rgb(255, 226, 130) }, { 1, rgb(160, 110, 30) } }, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
        end
        local sheen = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-0.3, 0, 0.5, 0),
            Size = UDim2.new(0, 80, 0, 560), Rotation = 24, BackgroundColor3 = rgb(255, 226, 140), BackgroundTransparency = 0.82,
            BorderSizePixel = 0 })
        ugrad(sheen, 0, nil, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
        local rnd = Random.new(131)
        for _ = 1, 16 do
            local s = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(rnd:NextNumber(), 0, rnd:NextNumber(), 0),
                Size = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 1, Text = "✦", TextSize = rnd:NextInteger(8, 16),
                TextColor3 = rgb(255, 228, 140) })
            local ph, sp = rnd:NextNumber(0, 6), rnd:NextNumber(0.8, 2)
            table.insert(anims, function(t)
                s.TextTransparency = 0.3 + (math.sin(t * sp + ph) + 1) * 0.35
                s.Rotation = math.sin(t * 0.7 + ph) * 25
            end)
        end
        table.insert(anims, function(t)
            sheen.Position = UDim2.new(-0.3 + ((t % 7) / 7) * 1.6, 0, 0.5, 0)
            for i = 1, #spin do spin[i][1].Rotation = (t * 25 * spin[i][2]) % 360 end
        end)
    end

    -- 25) MUSIM GUGUR: langit senja, daun jatuh berputar
    build.autumn = function()
        setBase(90, { { 0, rgb(250, 190, 110) }, { 0.45, rgb(190, 90, 40) }, { 1, rgb(60, 24, 16) } })
        beams(3, rgb(255, 220, 150), 0.1, -16)
        blob(0.8, 0.12, 170, rgb(255, 220, 140), 6)
        local TN2 = math.floor(7 * WX() + 0.5)
        for i = 0, TN2 - 1 do
            mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new((i + 0.5) / TN2, 0, 1.02, 0),
                Size = UDim2.new(0, 56, 0, 56), BackgroundTransparency = 1, Text = (i % 2 == 0) and "🌳" or "🌲",
                TextSize = 44, TextTransparency = 0.25 })
        end
        circle(0.5, 1.14, 440, rgb(120, 56, 28), 0.05)
        build._particles(11, 141, { glyph = { "🍂", "🍁", "🍂" }, s1 = 14, s2 = 24, dir = 1, sp1 = 0.04, sp2 = 0.09, sway = 0.07, swf = 1.2, rot = 50, tr = 0.12 })
        build._particles(10, 142, { s1 = 2, s2 = 4, color = rgb(255, 210, 130), tr = 0.4, dir = -1, sp1 = 0.02, sp2 = 0.05, sway = 0.05 })
    end

    -- 26) BULAN: bulan purnama besar, kawah, awan lewat, bintang
    build.moon = function()
        setBase(90, { { 0, rgb(8, 12, 34) }, { 0.6, rgb(18, 30, 70) }, { 1, rgb(34, 54, 96) } })
        stars(50, 17, 2, 0.7)
        local glow = blob(0.5, 0.3, 280, rgb(220, 225, 180), 7)
        circle(0.5, 0.3, 112, rgb(250, 248, 220), 0.02)
        circle(0.43, 0.26, 20, rgb(222, 220, 190), 0.2)
        circle(0.57, 0.33, 28, rgb(226, 224, 194), 0.2)
        circle(0.5, 0.38, 14, rgb(220, 218, 186), 0.25)
        local rnd = Random.new(151)
        for i = 1, 4 do
            local c = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, rnd:NextInteger(90, 150), 0, rnd:NextInteger(14, 22)),
                BackgroundColor3 = rgb(26, 40, 84), BackgroundTransparency = 0.25, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, c)
            local y, sp, off = 0.2 + i * 0.08, rnd:NextNumber(0.01, 0.025), rnd:NextNumber(0, 1.5)
            table.insert(anims, function(t) c.Position = UDim2.new(((t * sp + off) % 1.6) - 0.4, 0, y, 0) end)
        end
        circle(0.2, 1.16, 330, rgb(10, 18, 40), 0.05)
        circle(0.85, 1.18, 350, rgb(8, 14, 34), 0.05)
        shoot(8, 1)
        table.insert(anims, function(t)
            local s = 280 + math.sin(t * 0.7) * 10
            glow.Size = UDim2.new(0, s, 0, s)
        end)
    end

    -- 27) PELANGI: warna berganti halus + pelangi berdenyut + awan
    build.rainbow = function()
        setBase(90, { { 0, rgb(60, 40, 110) }, { 1, rgb(30, 20, 70) } })
        local arcs = {}
        local cols = { rgb(255, 70, 70), rgb(255, 150, 50), rgb(255, 230, 70), rgb(80, 220, 110), rgb(70, 160, 255), rgb(120, 90, 240), rgb(190, 90, 230) }
        for i, c in ipairs(cols) do
            local s = 330 - i * 18
            local f = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.98, 0),
                Size = UDim2.new(0, s, 0, s), BackgroundTransparency = 1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, f)
            arcs[i] = mk("UIStroke", { Thickness = 8, Color = c, Transparency = 0.4 }, f)
        end
        local rnd = Random.new(161)
        for i = 1, 3 do
            local c = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 100 + i * 20, 0, 24),
                BackgroundColor3 = rgb(255, 255, 255), BackgroundTransparency = 0.7, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, c)
            local y, sp, off = 0.1 + i * 0.12, rnd:NextNumber(0.012, 0.025), rnd:NextNumber(0, 1.5)
            table.insert(anims, function(t) c.Position = UDim2.new(((t * sp + off) % 1.6) - 0.4, 0, y, 0) end)
        end
        build._particles(14, 162, { s1 = 3, s2 = 6, color = rgb(255, 255, 255), tr = 0.4, dir = -1, sp1 = 0.03, sp2 = 0.07, sway = 0.04 })
        table.insert(anims, function(t)
            local h = (t * 0.03) % 1
            baseGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHSV(h, 0.65, 0.5)),
                ColorSequenceKeypoint.new(0.5, Color3.fromHSV((h + 0.18) % 1, 0.7, 0.4)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV((h + 0.38) % 1, 0.7, 0.3)),
            })
            baseGrad.Rotation = 90 + math.sin(t * 0.2) * 30
            for i = 1, 7 do arcs[i].Transparency = 0.35 + (math.sin(t * 1.5 - i * 0.5) + 1) * 0.12 end
        end)
    end

    -- 28) LAUT DALAM: ubur-ubur bercahaya, plankton, sinar dari atas
    build.abyss = function()
        setBase(90, { { 0, rgb(4, 44, 66) }, { 0.5, rgb(2, 18, 40) }, { 1, rgb(0, 4, 14) } })
        beams(3, rgb(120, 230, 240), 0.05, -10)
        build._jelly(0.2, 0.2, 40, rgb(80, 240, 230), 0)
        build._jelly(0.72, 0.1, 54, rgb(200, 110, 255), 2)
        build._jelly(0.5, 0.52, 34, rgb(255, 120, 200), 4)
        build._jelly(0.85, 0.58, 28, rgb(100, 200, 255), 1)
        build._jelly(0.12, 0.62, 30, rgb(150, 255, 190), 3)
        build._particles(24, 171, { s1 = 2, s2 = 4, color = rgb(150, 255, 240), tr = 0.45, dir = -1, sp1 = 0.015, sp2 = 0.04, sway = 0.05, swf = 0.7 })
        circle(0.5, 1.22, 420, rgb(2, 10, 20), 0.05)
    end

    -- 29) KEMBANG API: langit malam, roket naik lalu meledak warna-warni
    build.fireworks = function()
        setBase(90, { { 0, rgb(6, 4, 22) }, { 1, rgb(26, 10, 52) } })
        stars(34, 19, 2, 0.6)
        build._skyline(181, 10, rgb(6, 4, 14), 30, 70, nil, 1.0)
        for b = 1, 4 do
            local period, off = 4.2 + b * 0.5, b * 1.1
            local pts, rocket = {}, circle(0.5, 1, 4, rgb(255, 230, 170), 0.1)
            for i = 1, 14 do pts[i] = circle(0.5, 0.5, 4, rgb(255, 255, 255), 1) end
            local lastK = -1
            table.insert(anims, function(t)
                local u = t + off
                local k = math.floor(u / period)
                local p = (u % period) / period
                local cx = 0.2 + 0.6 * ((k * 0.37 + b * 0.21) % 1)
                local cy = 0.18 + 0.3 * ((k * 0.53 + b * 0.31) % 1)
                if k ~= lastK then
                    lastK = k
                    for i = 1, 14 do pts[i].BackgroundColor3 = Color3.fromHSV((k * 0.21 + b * 0.17 + i * 0.01) % 1, 0.65, 1) end
                end
                if p < 0.25 then
                    local q = p / 0.25
                    rocket.BackgroundTransparency = 0.1
                    rocket.Position = UDim2.new(cx, 0, 1 - (1 - cy) * q, 0)
                    for i = 1, 14 do pts[i].BackgroundTransparency = 1 end
                else
                    rocket.BackgroundTransparency = 1
                    local q = (p - 0.25) / 0.75
                    local e = 1 - (1 - q) * (1 - q)
                    for i = 1, 14 do
                        local a = (i / 14) * 6.2832
                        pts[i].Position = UDim2.new(cx, math.cos(a) * 62 * e, cy, math.sin(a) * 62 * e + q * q * 30)
                        pts[i].BackgroundTransparency = math.min(1, 0.05 + q * q * 1.1)
                    end
                end
            end)
        end
    end

    -- 30) API BIRU: lidah api biru-putih menari, bara biru naik
    build.blueflame = function()
        setBase(90, { { 0, rgb(4, 10, 30) }, { 0.6, rgb(8, 26, 76) }, { 1, rgb(10, 64, 150) } })
        local glow = blob(0.5, 1.0, 320, rgb(40, 150, 255), 7)
        local flames = {}
        for layer = 1, 3 do
            local col = ({ rgb(20, 70, 200), rgb(60, 180, 255), rgb(220, 250, 255) })[layer]
            local hh = ({ 120, 92, 56 })[layer]
            for i = 0, 7 do
                local f = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new((i + 0.5) / 8, 0, 1.02, 0),
                    Size = UDim2.new(0, 38 - layer * 6, 0, hh), BackgroundColor3 = col,
                    BackgroundTransparency = ({ 0.45, 0.3, 0.15 })[layer], BorderSizePixel = 0 })
                mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, f)
                ugrad(f, 90, nil, { { 0, 0.2 }, { 1, 0 } })
                flames[#flames + 1] = { f, hh, i * 0.9 + layer * 1.7, 38 - layer * 6 }
            end
        end
        build._particles(22, 191, { s1 = 2, s2 = 4, color = rgb(150, 225, 255), tr = 0.2, dir = -1, sp1 = 0.07, sp2 = 0.17, sway = 0.04, swf = 1.4 })
        table.insert(anims, function(t)
            for i = 1, #flames do
                local f = flames[i]
                local k = math.sin(t * 5 + f[3]) * 0.5 + math.sin(t * 8.3 + f[3] * 2) * 0.3
                f[1].Size = UDim2.new(0, f[4] * (1 - k * 0.12), 0, f[2] * (1 + k * 0.28))
                f[1].Rotation = math.sin(t * 3 + f[3]) * 7
            end
            local s = 320 + math.sin(t * 2.2) * 14
            glow.Size = UDim2.new(0, s, 0, s)
        end)
    end

    -- 30) MALAM KUNANG: langit malam, bukit gelap, ilalang, kunang-kunang berkedip
    build.firefly = function()
        setBase(90, { { 0, rgb(10, 32, 44) }, { 0.55, rgb(8, 36, 30) }, { 1, rgb(3, 14, 10) } })
        stars(20, 31, 2, 0.4)
        blob(0.85, 0.1, 120, rgb(230, 250, 170), 6)
        local rnd = Random.new(31)
        for i = 0, 4 do
            local h = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(i * 0.26, 0, 1.06, 0),
                Size = UDim2.new(0, 190, 0, 150), BackgroundColor3 = (i % 2 == 0) and rgb(4, 22, 16) or rgb(6, 30, 22),
                BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, h)
        end
        for _ = 1, 10 do
            mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(rnd:NextNumber(0.03, 0.97), 0, 1.02, 0),
                Size = UDim2.new(0, 2, 0, rnd:NextInteger(30, 70)), BackgroundColor3 = rgb(10, 48, 30),
                BorderSizePixel = 0, Rotation = rnd:NextInteger(-8, 8) })
        end
        for _ = 1, 22 do
            local x, y = rnd:NextNumber(0.05, 0.95), rnd:NextNumber(0.2, 0.95)
            local g = circle(x, y, 12, rgb(190, 255, 110), 0.9)
            local d = circle(x, y, 3, rgb(235, 255, 170), 0.1)
            local ph, sp = rnd:NextNumber(0, 6), rnd:NextNumber(1.1, 2.2)
            table.insert(anims, function(t)
                local a = (math.sin(t * sp + ph) + 1) / 2
                d.BackgroundTransparency = 0.85 - a * 0.75
                g.BackgroundTransparency = 0.96 - a * 0.2
                local pos = UDim2.new(x + math.sin(t * 0.4 + ph) * 0.04, 0, y + math.cos(t * 0.33 + ph) * 0.03, 0)
                g.Position = pos
                d.Position = pos
            end)
        end
    end

    -- 31) HUJAN METEOR: langit ungu-biru, bintang berkedip, meteor jatuh miring
    build.meteor = function()
        setBase(90, { { 0, rgb(8, 8, 34) }, { 0.6, rgb(26, 14, 60) }, { 1, rgb(62, 22, 72) } })
        stars(40, 41, 2, 0.8)
        blob(0.15, 0.97, 230, rgb(255, 120, 80), 6)
        blob(0.92, 0.04, 150, rgb(140, 110, 255), 6)
        local rnd = Random.new(41)
        for _ = 1, 7 do
            local len = rnd:NextInteger(60, 110)
            local m = mk("Frame", { AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.new(0, len, 0, 2),
                BackgroundColor3 = rgb(255, 235, 200), BackgroundTransparency = 0, BorderSizePixel = 0, Rotation = 45 })
            ugrad(m, 0, nil, { { 0, 1 }, { 1, 0 } })
            local sp, ph = rnd:NextNumber(0.16, 0.34), rnd:NextNumber(0, 6)
            local x0, y0 = rnd:NextNumber(-0.1, 0.5), rnd:NextNumber(-0.2, 0.15)
            table.insert(anims, function(t)
                local p = (t * sp + ph) % 2.4
                m.Position = UDim2.new(x0 + p * 0.75, 0, y0 + p * 0.55, 0)
            end)
        end
        build._particles(8, 42, { s1 = 2, s2 = 3, color = rgb(255, 210, 160), tr = 0.5, dir = 1, sp1 = 0.03, sp2 = 0.07, sway = 0.02, swf = 1 })
    end

    -- 32) TERUMBU KARANG: air tosca, sinar, gelembung naik, ikan berenang, karang & pasir
    build.coral = function()
        setBase(90, { { 0, rgb(30, 160, 190) }, { 0.45, rgb(10, 80, 130) }, { 1, rgb(3, 28, 56) } })
        beams(3, rgb(200, 255, 250), 0.1, -16)
        build._particles(18, 51, { s1 = 3, s2 = 8, color = rgb(220, 250, 255), tr = 0.6, dir = -1, sp1 = 0.06, sp2 = 0.14, sway = 0.03, swf = 1.2 })
        local rnd = Random.new(51)
        mk("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 22),
            BackgroundColor3 = rgb(214, 186, 128), BackgroundTransparency = 0.15, BorderSizePixel = 0 })
        local cols = { rgb(255, 110, 120), rgb(255, 160, 90), rgb(230, 90, 170), rgb(255, 200, 110) }
        for i = 0, 8 do
            local x = (i + 0.5) / 9
            local h = rnd:NextInteger(26, 62)
            local col = cols[rnd:NextInteger(1, #cols)]
            local stem = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(x, 0, 1, -6),
                Size = UDim2.new(0, 9, 0, h), BackgroundColor3 = col, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, stem)
            for _, side in ipairs({ -1, 1 }) do
                local br = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, side * 5, 0.6, 0),
                    Size = UDim2.new(0, 6, 0, h * 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Rotation = side * 35 }, stem)
                mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, br)
            end
            local ph = rnd:NextNumber(0, 6)
            table.insert(anims, function(t) stem.Rotation = math.sin(t * 0.9 + ph) * 3 end)
        end
        local glyphs = { "🐠", "🐟", "🐡", "🐠" }
        for i = 1, 4 do
            local f = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 26, 0, 26),
                BackgroundTransparency = 1, Text = glyphs[i], TextSize = rnd:NextInteger(16, 24), TextTransparency = 0.15 })
            local y0, sp, ph = rnd:NextNumber(0.2, 0.75), rnd:NextNumber(0.04, 0.09), rnd:NextNumber(0, 6)
            table.insert(anims, function(t)
                local p = (t * sp + ph) % 1.3
                f.Position = UDim2.new(1.15 - p, 0, y0 + math.sin(t * 1.3 + ph) * 0.02, 0)
            end)
        end
    end

    -- 33) MESIN UAP: tembaga gelap, roda gigi berputar, uap naik
    build.gear = function()
        setBase(135, { { 0, rgb(72, 46, 20) }, { 0.5, rgb(34, 21, 11) }, { 1, rgb(16, 10, 5) } })
        blob(0.9, 0.1, 170, rgb(230, 160, 70), 6)
        blob(0.1, 0.95, 170, rgb(200, 120, 50), 6)
        for i = 1, 9 do
            mk("Frame", { Position = UDim2.new(i / 10, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0),
                BackgroundColor3 = rgb(214, 150, 70), BackgroundTransparency = 0.93, BorderSizePixel = 0 })
        end
        local specs = {
            { 0.12, 0.18, 92, 14 }, { 0.52, 0.3, 64, -22 }, { 0.9, 0.14, 78, 18 },
            { 0.2, 0.74, 70, -16 }, { 0.82, 0.82, 100, 12 }, { 0.5, 0.6, 46, 30 },
        }
        for _, s in ipairs(specs) do
            local gl = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(s[1], 0, s[2], 0),
                Size = UDim2.new(0, s[3], 0, s[3]), BackgroundTransparency = 1, Text = "⚙", TextSize = s[3],
                TextColor3 = rgb(214, 150, 70), TextTransparency = 0.6 })
            table.insert(anims, function(t) gl.Rotation = (t * s[4]) % 360 end)
        end
        build._particles(10, 71, { s1 = 8, s2 = 18, color = rgb(235, 225, 205), tr = 0.82, dir = -1, sp1 = 0.05, sp2 = 0.1, sway = 0.05, swf = 1 })
        build._particles(8, 72, { s1 = 2, s2 = 3, color = rgb(255, 190, 90), tr = 0.3, dir = -1, sp1 = 0.08, sp2 = 0.16, sway = 0.03, swf = 2 })
    end

    -- 34) MATCHA LATTE: hijau lembut, daun melayang, mutiara boba naik, cangkir
    build.matcha = function()
        setBase(90, { { 0, rgb(150, 190, 120) }, { 0.45, rgb(70, 110, 76) }, { 1, rgb(22, 40, 30) } })
        blob(0.85, 0.1, 160, rgb(240, 250, 200), 6)
        blob(0.1, 0.9, 170, rgb(190, 230, 150), 6)
        build._particles(8, 81, { glyph = { "🍃", "🌿", "🍃" }, s1 = 14, s2 = 22, dir = 1, sp1 = 0.04, sp2 = 0.09, sway = 0.06, swf = 0.9, rot = 30, tr = 0.3 })
        build._particles(16, 82, { s1 = 6, s2 = 12, color = rgb(40, 28, 22), tr = 0.45, dir = -1, sp1 = 0.04, sp2 = 0.09, sway = 0.03, swf = 1.2 })
        build._particles(14, 83, { s1 = 2, s2 = 4, color = rgb(255, 255, 235), tr = 0.4, dir = 1, sp1 = 0.03, sp2 = 0.07, sway = 0.03, swf = 1.4 })
        mk("TextLabel", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -8, 1, -4), Size = UDim2.new(0, 56, 0, 56),
            BackgroundTransparency = 1, Text = "🍵", TextSize = 46, TextTransparency = 0.35 })
    end

    -- ==================== v21: 12 TEMA BARU (dekorasi) ====================
    -- emoji melintas horizontal (back=true: dari kanan ke kiri), sedikit naik-turun
    build._drift = function(glyph, size, y0, sp, ph, back, bob, tr)
        local f = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, size, 0, size),
            BackgroundTransparency = 1, Text = glyph, TextSize = size, TextTransparency = tr or 0.15 })
        table.insert(anims, function(t)
            local p = (t * sp + ph) % 1.3
            if back then p = 1.15 - p else p = p - 0.15 end
            f.Position = UDim2.new(p, 0, y0 + math.sin(t * 1.3 + ph) * (bob or 0.02), 0)
        end)
        return f
    end

    -- emoji diam di pojok bawah (opsional goyang)
    build._corner = function(glyph, size, right)
        local f = mk("TextLabel", { AnchorPoint = Vector2.new(right and 1 or 0, 1),
            Position = UDim2.new(right and 1 or 0, right and -8 or 8, 1, -4), Size = UDim2.new(0, size + 10, 0, size + 10),
            BackgroundTransparency = 1, Text = glyph, TextSize = size, TextTransparency = 0.25 })
        table.insert(anims, function(t) f.Rotation = math.sin(t * 1.1) * 4 end)
        return f
    end

    -- deretan lampu kecil berkedip di atas
    build._bulbs = function(n, cols, y)
        for i = 1, n do
            local c = circle((i - 0.5) / n, y, 7, cols[(i - 1) % #cols + 1], 0.1)
            local ph = i * 0.9
            table.insert(anims, function(t) c.BackgroundTransparency = 0.1 + (math.sin(t * 3 + ph) * 0.5 + 0.5) * 0.6 end)
        end
    end

    -- 1) MALAM HALLOWEEN
    build.halloween = function()
        setBase(90, { { 0, rgb(70, 24, 84) }, { 0.5, rgb(30, 10, 40) }, { 1, rgb(10, 4, 14) } })
        stars(30, 91, 2, 0.6)
        blob(0.82, 0.12, 150, rgb(255, 210, 120), 7)
        build._particles(9, 92, { glyph = { "🦇", "🦇", "🕸️" }, s1 = 14, s2 = 22, dir = 1, sp1 = 0.03, sp2 = 0.07, sway = 0.08, swf = 1.1, tr = 0.25 })
        build._particles(7, 93, { glyph = { "👻" }, s1 = 16, s2 = 24, dir = -1, sp1 = 0.03, sp2 = 0.06, sway = 0.05, swf = 0.8, tr = 0.45 })
        build._particles(14, 94, { s1 = 2, s2 = 4, color = rgb(255, 140, 30), tr = 0.35, dir = -1, sp1 = 0.04, sp2 = 0.09, sway = 0.03, swf = 1.6 })
        build._corner("🎃", 46, false)
        build._corner("🕯️", 30, true)
    end

    -- 2) LANGIT CERAH
    build.sky = function()
        setBase(90, { { 0, rgb(70, 150, 240) }, { 0.6, rgb(140, 200, 250) }, { 1, rgb(215, 238, 255) } })
        blob(0.85, 0.1, 150, rgb(255, 245, 190), 7)
        for i = 1, 5 do build._drift("☁️", 30 + i * 7, 0.08 + i * 0.17, 0.012 + i * 0.004, i * 1.9, false, 0.01, 0.1) end
        build._drift("🕊️", 20, 0.3, 0.05, 2, false, 0.04, 0.2)
        build._drift("🎈", 26, 0.78, 0.025, 4, false, 0.03, 0.2)
        build._particles(10, 95, { s1 = 2, s2 = 4, color = rgb(255, 255, 255), tr = 0.4, dir = -1, sp1 = 0.03, sp2 = 0.06, sway = 0.03, swf = 1.2 })
    end

    -- 3) PANTAI TROPIS
    build.beach = function()
        setBase(90, { { 0, rgb(50, 190, 215) }, { 0.7, rgb(120, 225, 225) }, { 1, rgb(250, 228, 170) } })
        blob(0.15, 0.1, 150, rgb(255, 240, 160), 7)
        mk("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = rgb(244, 218, 160), BackgroundTransparency = 0.1, BorderSizePixel = 0 })
        for i = 1, 3 do
            local w = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -24 - i * 9),
                Size = UDim2.new(1.4, 0, 0, 16), BackgroundColor3 = rgb(255, 255, 255),
                BackgroundTransparency = 0.5 + i * 0.1, BorderSizePixel = 0 })
            mk("UICorner", { CornerRadius = UDim.new(0.5, 0) }, w)
            local ph = i * 1.3
            table.insert(anims, function(t) w.Position = UDim2.new(0.5 + math.sin(t * 0.7 + ph) * 0.08, 0, 1, -24 - i * 9) end)
        end
        build._particles(10, 96, { s1 = 4, s2 = 9, color = rgb(255, 255, 255), tr = 0.6, dir = -1, sp1 = 0.04, sp2 = 0.09, sway = 0.03, swf = 1.3 })
        build._drift("🦀", 20, 0.93, 0.03, 1, false, 0.005, 0.1)
        build._drift("🐚", 16, 0.95, 0.02, 3, true, 0.003, 0.1)
        build._corner("🌴", 50, true)
    end

    -- 4) ARKADE RETRO
    build.arcade = function()
        setBase(90, { { 0, rgb(30, 8, 64) }, { 0.55, rgb(14, 6, 38) }, { 1, rgb(6, 4, 20) } })
        for i = 1, 8 do
            mk("Frame", { Position = UDim2.new(i / 9, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0),
                BackgroundColor3 = rgb(0, 230, 255), BackgroundTransparency = 0.88, BorderSizePixel = 0 })
        end
        local lines = {}
        for i = 0, 9 do
            lines[i] = mk("Frame", { Position = UDim2.new(0, 0, i / 10, 0), Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = rgb(255, 64, 200), BackgroundTransparency = 0.75, BorderSizePixel = 0 })
        end
        table.insert(anims, function(t)
            for i = 0, 9 do lines[i].Position = UDim2.new(0, 0, ((i + t * 0.4) % 10) / 10, 0) end
        end)
        stars(26, 97, 3, 0.8)
        build._drift("👾", 22, 0.18, 0.05, 0.5, false, 0.03, 0.15)
        build._drift("👾", 18, 0.42, 0.035, 2.4, true, 0.03, 0.2)
        build._corner("🕹️", 44, true)
    end

    -- 5) ES KRIM
    build.icecream = function()
        setBase(90, { { 0, rgb(255, 170, 200) }, { 0.5, rgb(200, 150, 220) }, { 1, rgb(150, 220, 205) } })
        blob(0.85, 0.12, 160, rgb(255, 245, 200), 6)
        blob(0.1, 0.9, 170, rgb(255, 255, 255), 5)
        build._particles(10, 98, { glyph = { "🍦", "🍧", "🍨", "🍓" }, s1 = 16, s2 = 26, dir = 1, sp1 = 0.03, sp2 = 0.07, sway = 0.05, swf = 0.9, rot = 20, tr = 0.3 })
        local cols = { rgb(255, 90, 140), rgb(255, 230, 90), rgb(110, 210, 255), rgb(150, 255, 170) }
        for i, c in ipairs(cols) do
            build._particles(6, 98 + i, { rect = true, w = 3, s1 = 6, s2 = 10, color = c, tr = 0.2, dir = 1, sp1 = 0.04, sp2 = 0.1, sway = 0.03, swf = 1.2, angle = 30, rot = 60 })
        end
        build._corner("🍦", 46, true)
    end

    -- 6) LENTERA FESTIVAL
    build.lantern = function()
        setBase(90, { { 0, rgb(120, 16, 24) }, { 0.5, rgb(60, 8, 16) }, { 1, rgb(20, 4, 8) } })
        blob(0.5, 0.05, 200, rgb(255, 190, 80), 6)
        build._bulbs(14, { rgb(255, 210, 90), rgb(255, 90, 70) }, 0.012)
        build._particles(8, 107, { glyph = { "🏮" }, s1 = 20, s2 = 34, dir = -1, sp1 = 0.03, sp2 = 0.07, sway = 0.05, swf = 0.9, tr = 0.2 })
        build._particles(18, 108, { s1 = 2, s2 = 4, color = rgb(255, 210, 100), tr = 0.3, dir = -1, sp1 = 0.05, sp2 = 0.12, sway = 0.03, swf = 1.8 })
        build._particles(8, 109, { glyph = { "✨" }, s1 = 10, s2 = 16, dir = 1, sp1 = 0.03, sp2 = 0.06, sway = 0.04, swf = 1.4, tr = 0.35 })
    end

    -- 7) PENYIHIR
    build.wizard = function()
        setBase(90, { { 0, rgb(50, 20, 110) }, { 0.55, rgb(20, 14, 64) }, { 1, rgb(6, 10, 36) } })
        stars(34, 117, 3, 0.7)
        blob(0.2, 0.18, 150, rgb(120, 90, 255), 6)
        blob(0.85, 0.85, 170, rgb(70, 220, 210), 6)
        build._particles(10, 118, { glyph = { "✨", "⭐", "🔮", "🌙" }, s1 = 12, s2 = 20, dir = -1, sp1 = 0.03, sp2 = 0.07, sway = 0.05, swf = 1.1, rot = 25, tr = 0.3 })
        build._particles(14, 119, { s1 = 2, s2 = 4, color = rgb(190, 160, 255), tr = 0.3, dir = -1, sp1 = 0.04, sp2 = 0.1, sway = 0.03, swf = 1.6 })
        build._drift("🦉", 22, 0.22, 0.03, 1.5, true, 0.04, 0.2)
        build._corner("🔮", 46, true)
    end

    -- 8) ZAMAN DINO
    build.dino = function()
        setBase(90, { { 0, rgb(130, 160, 70) }, { 0.5, rgb(66, 98, 42) }, { 1, rgb(26, 38, 20) } })
        blob(0.85, 0.1, 160, rgb(255, 170, 70), 7)
        for i = 0, 7 do
            local f = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new((i + 0.5) / 8, 0, 1, 2),
                Size = UDim2.new(0, 34, 0, 34), BackgroundTransparency = 1, Text = "🌿", TextSize = 30, TextTransparency = 0.15 })
            local ph = i * 0.8
            table.insert(anims, function(t) f.Rotation = math.sin(t * 0.9 + ph) * 6 end)
        end
        build._particles(12, 127, { s1 = 3, s2 = 6, color = rgb(70, 66, 60), tr = 0.45, dir = 1, sp1 = 0.03, sp2 = 0.07, sway = 0.04, swf = 1.1 })
        build._drift("🦖", 34, 0.9, 0.018, 1, false, 0.005, 0.1)
        build._drift("🦕", 30, 0.28, 0.012, 3, true, 0.01, 0.2)
        build._drift("☄️", 20, 0.1, 0.03, 5, false, 0.0, 0.2)
    end

    -- 9) ROSE GOLD
    build.rosegold = function()
        setBase(135, { { 0, rgb(150, 84, 96) }, { 0.5, rgb(86, 44, 56) }, { 1, rgb(40, 20, 28) } })
        blob(0.9, 0.1, 170, rgb(255, 200, 190), 6)
        blob(0.08, 0.92, 160, rgb(240, 170, 150), 6)
        for i = 1, 14 do
            mk("Frame", { Position = UDim2.new(0, 0, i / 15, 0), Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = rgb(255, 214, 200), BackgroundTransparency = 0.95, BorderSizePixel = 0 })
        end
        local sheen = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(-0.3, 0, 0.5, 0),
            Size = UDim2.new(0, 70, 0, 520), Rotation = 24, BackgroundColor3 = rgb(255, 226, 210), BackgroundTransparency = 0.78, BorderSizePixel = 0 })
        ugrad(sheen, 0, nil, { { 0, 1 }, { 0.5, 0 }, { 1, 1 } })
        table.insert(anims, function(t) sheen.Position = UDim2.new(-0.3 + ((t % 9) / 9) * 1.6, 0, 0.5, 0) end)
        build._particles(10, 137, { glyph = { "🌹", "🌸", "🌹" }, s1 = 12, s2 = 20, dir = 1, sp1 = 0.03, sp2 = 0.07, sway = 0.06, swf = 1, rot = 40, tr = 0.3 })
        build._particles(14, 138, { s1 = 2, s2 = 4, color = rgb(255, 226, 190), tr = 0.35, dir = -1, sp1 = 0.03, sp2 = 0.08, sway = 0.03, swf = 1.5 })
    end

    -- 10) ASTRONOT
    build.space = function()
        setBase(90, { { 0, rgb(14, 18, 64) }, { 0.55, rgb(6, 8, 32) }, { 1, rgb(2, 3, 14) } })
        stars(46, 147, 3, 1)
        blob(0.82, 0.2, 120, rgb(255, 150, 80), 7)
        circle(0.82, 0.2, 54, rgb(230, 130, 70), 0.05)
        blob(0.12, 0.78, 110, rgb(90, 150, 255), 7)
        circle(0.12, 0.78, 40, rgb(80, 140, 235), 0.05)
        build._particles(6, 148, { rect = true, w = 2, s1 = 18, s2 = 34, color = rgb(255, 255, 255), tr = 0.35, dir = 1, sp1 = 0.2, sp2 = 0.4, sway = 0, drift = 0.15, angle = 20 })
        local rk = mk("TextLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 34, 0, 34),
            BackgroundTransparency = 1, Text = "🚀", TextSize = 30, Rotation = 45 })
        table.insert(anims, function(t)
            local p = (t * 0.05) % 1.4 - 0.2
            rk.Position = UDim2.new(p, 0, 1 - p, 0)
        end)
        build._drift("🛰️", 24, 0.5, 0.02, 2, true, 0.06, 0.2)
        build._drift("🛸", 22, 0.3, 0.03, 4, false, 0.04, 0.2)
    end

    -- 11) HUTAN BAMBU
    build.bamboo = function()
        setBase(90, { { 0, rgb(190, 225, 150) }, { 0.45, rgb(80, 140, 80) }, { 1, rgb(24, 60, 40) } })
        beams(3, rgb(255, 255, 210), 0.1, -14)
        local rnd = Random.new(157)
        for i = 0, 8 do
            local x = (i + 0.5) / 9 + rnd:NextNumber(-0.02, 0.02)
            local w = rnd:NextInteger(9, 14)
            local stem = mk("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(x, 0, 1.02, 0),
                Size = UDim2.new(0, w, 1.05, 0), BackgroundColor3 = rgb(96 + i * 6, 170, 90), BackgroundTransparency = 0.2, BorderSizePixel = 0 })
            for j = 1, 7 do
                mk("Frame", { Position = UDim2.new(0, -1, j / 8, 0), Size = UDim2.new(1, 2, 0, 3),
                    BackgroundColor3 = rgb(40, 100, 50), BackgroundTransparency = 0.2, BorderSizePixel = 0 }, stem)
            end
            local ph = rnd:NextNumber(0, 6)
            table.insert(anims, function(t) stem.Rotation = math.sin(t * 0.6 + ph) * 1.6 end)
        end
        build._particles(10, 158, { glyph = { "🍃", "🌿" }, s1 = 12, s2 = 20, dir = 1, sp1 = 0.03, sp2 = 0.08, sway = 0.06, swf = 1, rot = 40, tr = 0.3 })
        build._corner("🐼", 46, true)
    end

    -- 12) KARNAVAL
    build.carnival = function()
        setBase(90, { { 0, rgb(90, 26, 120) }, { 0.5, rgb(40, 14, 76) }, { 1, rgb(14, 6, 36) } })
        blob(0.5, 0.0, 220, rgb(255, 200, 90), 6)
        build._bulbs(14, { rgb(255, 80, 120), rgb(255, 220, 70), rgb(90, 210, 255) }, 0.014)
        build._particles(8, 167, { glyph = { "🎈" }, s1 = 20, s2 = 32, dir = -1, sp1 = 0.03, sp2 = 0.07, sway = 0.05, swf = 0.9, tr = 0.2 })
        local cols = { rgb(255, 80, 120), rgb(255, 220, 70), rgb(90, 210, 255) }
        for i, c in ipairs(cols) do
            build._particles(6, 167 + i, { rect = true, w = 3, s1 = 6, s2 = 10, color = c, tr = 0.15, dir = 1, sp1 = 0.05, sp2 = 0.12, sway = 0.03, swf = 1.2, angle = 25, rot = 80 })
        end
        build._drift("🎠", 28, 0.9, 0.02, 2, false, 0.005, 0.15)
        build._corner("🎪", 46, true)
    end

    return {
        THEMES = THEMES, byId = byId, build = build, anims = anims, deco = deco, fxRoot = fxRoot,
        setAnim = function(v) animOn = v end,
    }
end


local engine = makeThemeEngine(main, conns, FXW, FXH)
engine.setAnim(S.anim)

----------------------------------------------------------------------
-- TOMBOL BUBBLE (gaya UniversalHub: pil, kilap, rim, efek pencet)
----------------------------------------------------------------------
local rimObjs = {}
local TI_DOWN = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TI_UP = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local function paintRims()
    for i = #rimObjs, 1, -1 do
        local r = rimObjs[i]
        if r.Parent then
            r.Color = curRim[1]
            r.Transparency = curRim[2]
        else
            table.remove(rimObjs, i)
        end
    end
end
refreshers[#refreshers + 1] = paintRims

local function bubble(b, radius, noGloss)
    new("UIGradient", { Name = "BubbleGrad", Color = ColorSequence.new(WHITE, rgb(176, 176, 192)), Rotation = 90 }, b)
    corner(b, radius or PILL)
    local rim = stroke(b, 1)
    rim.Name = "BubbleRim"
    rim.Color, rim.Transparency = curRim[1], curRim[2]
    rimObjs[#rimObjs + 1] = rim
    if not noGloss then
        local gl = new("Frame", {
            Name = "BubbleGloss", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.07, 0),
            Size = UDim2.new(0.84, 0, 0.38, 0), BackgroundColor3 = WHITE, BackgroundTransparency = 0.8,
            BorderSizePixel = 0, Active = false,
        }, b)
        corner(gl, PILL)
        new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1) }, gl)
        local sp = new("Frame", {
            Name = "BubbleSpark", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.08, 0, 0.3, 0),
            Size = UDim2.fromOffset(3, 3), BackgroundColor3 = WHITE, BackgroundTransparency = 0.35,
            BorderSizePixel = 0, Active = false,
        }, b)
        corner(sp, PILL)
    end
    local us = new("UIScale", { Name = "BubbleScale" }, b)
    local function up() TweenService:Create(us, TI_UP, { Scale = 1 }):Play() end
    b.MouseButton1Down:Connect(function() TweenService:Create(us, TI_DOWN, { Scale = 0.95 }):Play() end)
    b.MouseButton1Up:Connect(up)
    b.MouseLeave:Connect(up)
end

----------------------------------------------------------------------
-- TOP BAR
----------------------------------------------------------------------
local top = new("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 46), BorderSizePixel = 0, ZIndex = 2, Active = true }, main)
role(top, "BackgroundColor3", "black")
soft(top)
corner(top, 14)
role(new("Frame", {
    Size = UDim2.new(1, -28, 0, 1), Position = UDim2.new(0, 14, 1, -1), BorderSizePixel = 0, BackgroundTransparency = 0.55,
}, top), "BackgroundColor3", "accent")

local badge = new("Frame", { Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0, 12, 0.5, -16), BorderSizePixel = 0 }, top)
role(badge, "BackgroundColor3", "btn")
corner(badge, ROUND)
role(stroke(badge, 1.5), "Color", "accent")
lbl(badge, "🌐", 17, FONT.GothamBold, WHITE, UDim2.new(), UDim2.fromScale(1, 1))
lbl(top, "RODEO FOR ANIMAL", 16, FONT.GothamBlack, WHITE, UDim2.new(0, 52, 0, 5), UDim2.new(0, 230, 0, 20), LEFT)
role(lbl(top, "Auto Catch  •  Auto Base  •  Animal ESP", 10, FONT.Gotham, WHITE, UDim2.new(0, 52, 0, 25), UDim2.new(0, 240, 0, 14), LEFT), "TextColor3", "grey")

local function chip(x, w)
    local f = new("Frame", { Size = UDim2.fromOffset(w, 24), Position = UDim2.new(1, x, 0.5, -12), BorderSizePixel = 0 }, top)
    role(f, "BackgroundColor3", "dark")
    soft(f)
    corner(f, PILL)
    local st = stroke(f, 1)
    st.Transparency = 0.55
    role(st, "Color", "accent")
    return f
end
chipOnline = chip(-324, 80)
do
    local dot = new("Frame", { Size = UDim2.fromOffset(7, 7), Position = UDim2.new(0, 10, 0.5, -3), BackgroundColor3 = GREEN, BorderSizePixel = 0 }, chipOnline)
    corner(dot, ROUND)
    lbl(chipOnline, "ONLINE", 10, FONT.GothamBold, GREEN, UDim2.new(0, 22, 0, 0), UDim2.new(1, -26, 1, 0), LEFT)
    task.spawn(function()
        while gui.Parent do
            if S.anim and main.Visible then
                TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.7 }):Play()
                task.wait(0.8)
                TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 }):Play()
                task.wait(0.8)
            else
                task.wait(0.5)
            end
        end
    end)
end
chipStats = chip(-238, 152)
local statLabel = lbl(chipStats, "FPS --  •  --ms", 10, FONT.GothamBold, GREEN, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, 0))

local function topBtn(text, x, textColor, fallbackBg)
    local b = new("TextButton", {
        Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, x, 0.5, -15), Text = text, TextSize = 14,
        Font = FONT.GothamBlack, TextColor3 = textColor, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 3,
    }, top)
    if fallbackBg then b.BackgroundColor3 = fallbackBg else role(b, "BackgroundColor3", "btn") end
    bubble(b)
    return b
end
local minBtn = topBtn("–", -80, WHITE)
local closeBtn = topBtn("✕", -44, rgb(255, 130, 130), rgb(90, 30, 40))
drag(top, main)

----------------------------------------------------------------------
-- TAB + HALAMAN (kolom-kolom yang bisa di-scroll sendiri)
----------------------------------------------------------------------
local pages, tabBtns, orderOf = {}, {}, setmetatable({}, { __mode = "k" })
local curTab = nil
local PAGE_Y = 88

local function nextOrder(c)
    local n = (orderOf[c] or 0) + 1
    orderOf[c] = n
    return n
end

-- widths: lebar tiap kolom (jumlah = 1). grids[i] = true -> kolom berisi grid kartu tema.
local function makePage(name, widths, grids)
    local pf = new("Frame", {
        Name = name, Size = UDim2.new(1, -20, 1, -(PAGE_Y + 8)), Position = UDim2.new(0, 10, 0, PAGE_Y),
        BackgroundTransparency = 1, Visible = false, ZIndex = 2,
    }, main)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, pf)
    local n = #widths
    local p = { frame = pf }
    for i, w in ipairs(widths) do
        local sf = new("ScrollingFrame", {
            Name = "Col" .. i, Size = UDim2.new(w, -8 * (n - 1) * w, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = i, ZIndex = 2,
        }, pf)
        role(sf, "ScrollBarImageColor3", "accent")
        if grids and grids[i] then
            new("UIGridLayout", {
                CellSize = UDim2.new(1 / 3, -6, 0, 60), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder,
            }, sf)
        else
            new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, sf)
        end
        new("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4) }, sf)
        p[i] = sf
    end
    pages[name] = p
    return p
end

local function refreshTabs()
    for n, b in pairs(tabBtns) do
        local on = (n == curTab)
        TweenService:Create(b, TI_COLOR, {
            BackgroundColor3 = on and pal.accent or pal.btn, TextColor3 = on and WHITE or pal.grey,
        }):Play()
    end
end
refreshers[#refreshers + 1] = refreshTabs

local function showTab(name)
    curTab = name
    for n, p in pairs(pages) do
        if n == name then
            p.frame.Position = UDim2.new(0, 10, 0, PAGE_Y + 10)
            p.frame.Visible = true
            TweenService:Create(p.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = UDim2.new(0, 10, 0, PAGE_Y) }):Play()
        else
            p.frame.Visible = false
        end
    end
    refreshTabs()
end

local tabBar = new("Frame", {
    Name = "Tabs", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 52), BackgroundTransparency = 1, ZIndex = 2,
}, main)
local TABS = { { "MAIN", "🎯" }, { "ESP", "👁️" }, { "TEMA", "🎨" }, { "INFO", "🎮" } }
for i, t in ipairs(TABS) do
    local b = new("TextButton", {
        Name = t[1], Position = UDim2.new((i - 1) / #TABS, 2, 0, 0), Size = UDim2.new(1 / #TABS, -4, 1, 0),
        Text = t[2] .. "  " .. t[1], TextSize = 12, Font = FONT.GothamBold, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 3,
    }, tabBar)
    soft(b)
    bubble(b)
    tabBtns[t[1]] = b
    b.MouseButton1Click:Connect(function() showTab(t[1]) end)
end

----------------------------------------------------------------------
-- KOMPONEN
----------------------------------------------------------------------
-- kartu pengelompok (judul + isi)
local function card(c, title)
    local f = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, LayoutOrder = nextOrder(c) }, c)
    role(f, "BackgroundColor3", "dark")
    soft(f)
    corner(f, 14)
    local st = stroke(f, 1)
    st.Transparency = 0.5
    role(st, "Color", "accent")
    new("UIPadding", {
        PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
    }, f)
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, f)
    if title then
        local h = new("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = nextOrder(f) }, f)
        local bar = new("Frame", { Size = UDim2.fromOffset(3, 14), Position = UDim2.new(0, 0, 0.5, -7), BorderSizePixel = 0 }, h)
        role(bar, "BackgroundColor3", "accent")
        corner(bar, ROUND)
        lbl(h, title, 12, FONT.GothamBlack, WHITE, UDim2.new(0, 10, 0, 0), UDim2.new(1, -10, 1, 0), LEFT)
    end
    return f
end

local function infoText(c, text)
    local l = new("TextLabel", {
        BackgroundTransparency = 1, Text = text, TextSize = 11, Font = FONT.Gotham, TextWrapped = true,
        TextXAlignment = LEFT, TextYAlignment = Enum.TextYAlignment.Top, Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = nextOrder(c),
    }, c)
    role(l, "TextColor3", "grey")
    return l
end

local function statRow(c, name)
    local f = new("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = nextOrder(c) }, c)
    role(lbl(f, name, 11, FONT.Gotham, WHITE, UDim2.new(0, 2, 0, 0), UDim2.new(0.42, 0, 1, 0), LEFT), "TextColor3", "grey")
    local v = lbl(f, "-", 11, FONT.GothamBold, WHITE, UDim2.new(0.42, 0, 0, 0), UDim2.new(0.58, -2, 1, 0), RIGHT)
    v.TextTruncate = Enum.TextTruncate.AtEnd
    return function(t) v.Text = tostring(t) end
end

local function button(c, text, cb)
    local b = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), Text = text, TextSize = 12, Font = FONT.GothamBold, TextColor3 = WHITE,
        AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = nextOrder(c),
    }, c)
    role(b, "BackgroundColor3", "btn")
    soft(b)
    bubble(b)
    b.MouseButton1Click:Connect(function() if cb then cb(b) end end)
    return b
end

-- tombol kecil sebaris (preset)
local function rowButtons(c, defs)
    local f = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = nextOrder(c) }, c)
    local n = #defs
    for i, d in ipairs(defs) do
        local b = new("TextButton", {
            Position = UDim2.new((i - 1) / n, 2, 0, 0), Size = UDim2.new(1 / n, -4, 1, 0), Text = d[1], TextSize = 11,
            Font = FONT.GothamBold, TextColor3 = WHITE, AutoButtonColor = false, BorderSizePixel = 0,
        }, f)
        role(b, "BackgroundColor3", "btn")
        soft(b)
        bubble(b)
        b.MouseButton1Click:Connect(function() d[2](b) end)
    end
    return f
end

local function toggle(c, text, init, cb)
    local state = init and true or false
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = nextOrder(c),
    }, c)
    soft(row)
    bubble(row)
    lbl(row, text, 12, FONT.GothamBold, WHITE, UDim2.new(0, 14, 0, 0), UDim2.new(1, -72, 1, 0), LEFT)
    local track = new("Frame", { Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10), BorderSizePixel = 0 }, row)
    corner(track, ROUND)
    local knob = new("Frame", { Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, track)
    corner(knob, ROUND)
    local function refresh(animate)
        local bg = state and pal.on or pal.btn
        local tc = state and GREEN or rgb(86, 92, 112)
        local kp = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        if animate then
            TweenService:Create(row, TI_COLOR, { BackgroundColor3 = bg }):Play()
            TweenService:Create(track, TI_COLOR, { BackgroundColor3 = tc }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = kp }):Play()
        else
            row.BackgroundColor3, track.BackgroundColor3, knob.Position = bg, tc, kp
        end
    end
    refreshers[#refreshers + 1] = function() refresh(false) end
    refresh(false)
    row.MouseButton1Click:Connect(function()
        state = not state
        refresh(true)
        if cb then cb(state) end
    end)
    return { Set = function(_, v) state = v and true or false refresh(true) end, Get = function() return state end }
end

local function inputRow(c, text, default, cb, placeholder)
    local f = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BorderSizePixel = 0, LayoutOrder = nextOrder(c) }, c)
    role(f, "BackgroundColor3", "btn")
    soft(f)
    corner(f, PILL)
    local st = stroke(f, 1)
    st.Transparency = 0.6
    role(st, "Color", "border")
    lbl(f, text, 11, FONT.GothamBold, WHITE, UDim2.new(0, 14, 0, 0), UDim2.new(0.55, -14, 1, 0), LEFT)
    local tb = new("TextBox", {
        Size = UDim2.new(0.45, -8, 0, 24), Position = UDim2.new(0.55, 0, 0.5, -12), Text = tostring(default),
        PlaceholderText = placeholder or "", TextSize = 12, Font = FONT.GothamBold, TextColor3 = WHITE,
        ClearTextOnFocus = false, BorderSizePixel = 0,
    }, f)
    role(tb, "BackgroundColor3", "dark")
    role(tb, "PlaceholderColor3", "grey")
    corner(tb, PILL)
    tb.FocusLost:Connect(function() if cb then cb(tb.Text, tb) end end)
    return tb
end

local function searchBox(c, placeholder, cb)
    local tb = new("TextBox", {
        Size = UDim2.new(1, 0, 0, 34), Text = "", PlaceholderText = placeholder, TextSize = 12, Font = FONT.GothamBold,
        TextColor3 = WHITE, ClearTextOnFocus = false, BorderSizePixel = 0, LayoutOrder = nextOrder(c),
    }, c)
    role(tb, "BackgroundColor3", "btn")
    role(tb, "PlaceholderColor3", "grey")
    soft(tb)
    corner(tb, PILL)
    local st = stroke(tb, 1)
    st.Transparency = 0.6
    role(st, "Color", "border")
    tb:GetPropertyChangedSignal("Text"):Connect(function() cb(tb.Text) end)
    return tb
end

local function cycle(c, text, options, default, cb)
    local idx = 1
    for i, o in ipairs(options) do if o == default then idx = i end end
    local b
    b = button(c, "", function()
        idx = idx % #options + 1
        b.Text = text .. ": " .. options[idx]
        if cb then cb(options[idx]) end
    end)
    b.Text = text .. ": " .. options[idx]
    return b
end

-- notifikasi kecil
local curToast
local function notify(title, msg, color)
    if curToast then curToast:Destroy() end
    local f = new("Frame", {
        Size = UDim2.fromOffset(250, 46), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 280, 0, 34),
        BackgroundColor3 = rgb(12, 15, 25), BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 60,
    }, gui)
    curToast = f
    corner(f, 14)
    local s = stroke(f, 1.5)
    s.Color = color or pal.accent
    lbl(f, title, 12, FONT.GothamBold, WHITE, UDim2.new(0, 14, 0, 5), UDim2.new(1, -28, 0, 17), LEFT).ZIndex = 61
    local m = lbl(f, msg, 10, FONT.Gotham, rgb(190, 196, 215), UDim2.new(0, 14, 0, 23), UDim2.new(1, -28, 0, 16), LEFT)
    m.ZIndex = 61
    TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Position = UDim2.new(1, -12, 0, 34) }):Play()
    task.delay(2.6, function()
        if f.Parent then
            TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Position = UDim2.new(1, 280, 0, 34) }):Play()
            task.wait(0.35)
            f:Destroy()
        end
    end)
end

----------------------------------------------------------------------
-- LOGIKA FITUR
----------------------------------------------------------------------
local stat = { eggs = 0, trips = 0, t0 = os.clock() }
local ui = { tierCnt = {}, listRows = {} } -- diisi saat halaman dibuat

local BASE_V3 = Vector3.new(-2.3, 15.0, -287.8)
local BASE_CF = CFrame.new(-2.3, 15.0, -287.8) * CFrame.Angles(0, math.rad(15), 0)

local function goToBase()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    stat.trips = stat.trips + 1
    if S.baseMode == "Teleport" then
        hrp.CFrame = BASE_CF
    else
        local dist = (hrp.Position - BASE_V3).Magnitude
        local dur = math.clamp(dist / (S.baseSpeed or 25), 0.25, 12)
        TweenService:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = BASE_CF }):Play()
    end
end

local function isRidePrompt(p)
    for _, txt in ipairs({ p.ActionText or "", p.ObjectText or "", p.Name or "", p.Parent and p.Parent.Name or "" }) do
        if string.lower(txt):find("ride") then return true end
    end
    return false
end
bind(PPS.PromptTriggered, function(prompt, player)
    if player == plr and S.autoBase and isRidePrompt(prompt) then
        task.wait(0.35)
        goToBase()
    end
end)

-- anti AFK
bind(plr.Idled, function()
    if not S.antiAfk then return end
    pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

-- auto x2 (treadmill)
local activeX2 = {}
local function addX2(o) if o.Name == "X2PopUp" and o:IsA("GuiButton") then activeX2[o] = true end end
for _, o in ipairs(playerGui:GetDescendants()) do addX2(o) end
bind(playerGui.DescendantAdded, addX2)
bind(playerGui.DescendantRemoving, function(o) activeX2[o] = nil end)

local function safeClick(btn)
    if not btn or not btn.Parent or not btn.Visible then return end
    local p = btn.Parent
    while p and p ~= playerGui do
        if p:IsA("GuiObject") and not p.Visible then return end
        p = p.Parent
    end
    pcall(function()
        if firesignal then
            firesignal(btn.Activated)
        elseif getconnections then
            for _, c in pairs(getconnections(btn.Activated)) do c:Fire() end
        else
            btn:Activate()
        end
    end)
end

----------------------------------------------------------------------
-- ANIMAL ESP (dengan filter tier 10K ... 1B+)
----------------------------------------------------------------------
local TIERS = {
    { name = "<10K", range = "di bawah 10K", lo = 0, col = rgb(160, 170, 190) },
    { name = "10K", range = "10K – 99.9K", lo = 1e4, col = rgb(90, 230, 130) },
    { name = "100K", range = "100K – 999K", lo = 1e5, col = rgb(70, 200, 255) },
    { name = "1M", range = "1M – 9.9M", lo = 1e6, col = rgb(190, 120, 255) },
    { name = "10M", range = "10M – 99M", lo = 1e7, col = rgb(255, 175, 50) },
    { name = "100M", range = "100M – 999M", lo = 1e8, col = rgb(255, 80, 100) },
    { name = "1B+", range = "1B ke atas", lo = 1e9, col = rgb(255, 60, 220) },
}
local function tierOf(v)
    for i = #TIERS, 1, -1 do
        if v >= TIERS[i].lo then return i end
    end
    return 1
end

local SUFFIX = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18, sx = 1e21, sp = 1e24, oc = 1e27, no = 1e30 }
local function parseMoney(text)
    if not text then return 0 end
    local s = string.lower(tostring(text))
    s = s:gsub("[%$,%s]", "")
    s = s:gsub("/s", "")
    local num, suf = s:match("([%d%.]+)(%a*)")
    num = tonumber(num)
    if not num then return 0 end
    return num * (SUFFIX[suf] or 1)
end

local FMT = {
    { 1e30, "No" }, { 1e27, "Oc" }, { 1e24, "Sp" }, { 1e21, "Sx" }, { 1e18, "Qi" }, { 1e15, "Qa" },
    { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" },
}
local function fmt(n)
    for _, p in ipairs(FMT) do
        if n >= p[1] then
            local v = n / p[1]
            local s = string.format((v >= 100 and "%.0f") or (v >= 10 and "%.1f") or "%.2f", v)
            if s:find("%.") then
                s = s:gsub("0+$", "")
                s = s:gsub("%.$", "")
            end
            return s .. p[2]
        end
    end
    return tostring(math.floor(n))
end

local espData, infos = {}, {}
local nameCache = setmetatable({}, { __mode = "k" })
local function trackInfo(o) if o.Name == "AnimalInfo" and o:IsA("BillboardGui") then infos[o] = true end end
for _, o in ipairs(workspace:GetDescendants()) do trackInfo(o) end
bind(workspace.DescendantAdded, trackInfo)
bind(workspace.DescendantRemoving, function(o) infos[o] = nil end)

local function getMoney(b)
    local info = b:FindFirstChild("InfoSort")
    if info then
        for _, o in ipairs(info:GetDescendants()) do
            if o.Name == "MoneyPerSecond" and o:IsA("TextLabel") then return o.Text end
        end
    end
    for _, o in ipairs(b:GetDescendants()) do
        if o.Name == "MoneyPerSecond" and o:IsA("TextLabel") then return o.Text end
    end
    return nil
end
local function getModel(b)
    local ad = b.Adornee
    if ad then
        return ad:IsA("Model") and ad or ad:FindFirstAncestorOfClass("Model")
    end
    return b:FindFirstAncestorOfClass("Model")
end
local function rootPart(m)
    return m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
end
local function petName(b, model)
    local c = nameCache[model]
    if c then return c end
    local nm
    pcall(function()
        for _, o in ipairs(b:GetDescendants()) do
            if o:IsA("TextLabel") and o.Text ~= "" then
                local n = string.lower(o.Name)
                if n == "animalname" or n == "petname" or n == "name" or n == "title" then
                    nm = o.Text
                    break
                end
            end
        end
    end)
    nm = nm or model.Name
    nameCache[model] = nm
    return nm
end

local tracerLayer = new("Frame", { Name = "Tracers", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0, Active = false }, gui)

local function makeEsp(it)
    local d = { part = it.part }
    d.hl = new("Highlight", { FillTransparency = 0.6, OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop }, it.model)
    if it.part then
        local bg = new("BillboardGui", {
            Name = "RODEO_EspCard", Adornee = it.part, Size = UDim2.fromOffset(196, 64), StudsOffset = Vector3.new(0, 4.4, 0),
            AlwaysOnTop = true, LightInfluence = 0,
        }, it.part)
        local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = pal.black, BackgroundTransparency = 0.1, BorderSizePixel = 0 }, bg)
        corner(f, 12)
        d.st = stroke(f, 1.5)
        d.stripe = new("Frame", { Size = UDim2.new(1, -24, 0, 3), Position = UDim2.new(0, 12, 0, 0), BorderSizePixel = 0 }, f)
        corner(d.stripe, ROUND)
        d.tag = new("TextLabel", {
            Size = UDim2.fromOffset(46, 16), Position = UDim2.new(0, 8, 0, 8), Font = FONT.GothamBlack, TextSize = 10,
            TextColor3 = rgb(10, 10, 15), BorderSizePixel = 0, Text = "",
        }, f)
        corner(d.tag, ROUND)
        d.name = lbl(f, "", 11, FONT.GothamBold, WHITE, UDim2.new(0, 60, 0, 6), UDim2.new(1, -68, 0, 20), LEFT)
        d.name.TextTruncate = Enum.TextTruncate.AtEnd
        d.money = lbl(f, "", 20, FONT.GothamBlack, WHITE, UDim2.new(0, 10, 0, 24), UDim2.new(1, -20, 0, 24), LEFT)
        d.money.TextScaled = true
        d.dist = lbl(f, "", 10, FONT.GothamMedium, pal.grey, UDim2.new(0, 10, 0, 49), UDim2.new(1, -20, 0, 12), LEFT)
        d.bg = bg
    end
    d.line = new("Frame", {
        BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Visible = false, BackgroundTransparency = 0.2,
        Size = UDim2.fromOffset(0, 2),
    }, tracerLayer)
    return d
end

local function updateEspItem(d, it)
    local t = TIERS[it.tier]
    local col = S.tierColor and t.col or pal.accent
    if d.hl then
        d.hl.Enabled = S.hl
        d.hl.FillColor = col
        d.hl.OutlineColor = col:Lerp(WHITE, 0.45)
    end
    if d.bg then
        d.st.Color = col
        d.stripe.BackgroundColor3 = col
        d.tag.BackgroundColor3 = col
        d.tag.Text = t.name
        d.name.Visible = S.showName
        d.name.Text = it.name
        d.money.Text = it.text or (fmt(it.value) .. "/s")
        d.money.TextColor3 = col:Lerp(WHITE, 0.35)
        d.dist.Visible = S.showDist
        d.dist.TextColor3 = pal.grey
        d.dist.Text = string.format("📏 %d studs  •  ≈ %s/s", math.floor(it.dist + 0.5), fmt(it.value))
    end
    if d.line then d.line.BackgroundColor3 = col end
end

local function removeEsp(m)
    local d = espData[m]
    if d then
        if d.hl then d.hl:Destroy() end
        if d.bg then d.bg:Destroy() end
        if d.line then d.line:Destroy() end
        espData[m] = nil
    end
end
local function clearEsp() for m in pairs(espData) do removeEsp(m) end end

local function scan()
    local best = {}
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    for b in pairs(infos) do
        if not b.Parent then
            infos[b] = nil
        else
            local model = getModel(b)
            if model and model ~= char and not Players:GetPlayerFromCharacter(model) then
                local txt = getMoney(b)
                local value = parseMoney(txt)
                local cur = best[model]
                if not cur or value > cur.value then
                    local part = rootPart(model)
                    best[model] = {
                        model = model, text = txt, value = value, part = part,
                        dist = (hrp and part) and (hrp.Position - part.Position).Magnitude or 0,
                        tier = tierOf(value), name = petName(b, model),
                    }
                end
            end
        end
    end
    local list = {}
    for _, it in pairs(best) do list[#list + 1] = it end
    table.sort(list, function(a, b) return a.value > b.value end)
    return list
end

local function passes(it)
    if not S.tiers[it.tier] then return false end
    if it.value < S.espMin then return false end
    if S.espMax > 0 and it.value > S.espMax then return false end
    if S.espRange > 0 and it.dist > S.espRange then return false end
    return true
end

local function updateEsp()
    local list = scan()
    local counts = { 0, 0, 0, 0, 0, 0, 0 }
    local shown = {}
    for _, it in ipairs(list) do
        counts[it.tier] = counts[it.tier] + 1
        if passes(it) then shown[#shown + 1] = it end
    end
    for i = 1, 7 do
        if ui.tierCnt[i] then ui.tierCnt[i].Text = "×" .. counts[i] end
    end
    ui.petTotal = #list
    if ui.setTotal then ui.setTotal(#list) end
    if ui.setShown then ui.setShown(#shown) end

    if S.esp then
        local seen = {}
        for _, it in ipairs(shown) do
            seen[it.model] = true
            local d = espData[it.model]
            if not d then
                d = makeEsp(it)
                espData[it.model] = d
            end
            updateEspItem(d, it)
        end
        for m in pairs(espData) do
            if not seen[m] or not m.Parent then removeEsp(m) end
        end
    else
        clearEsp()
    end

    for i, row in ipairs(ui.listRows) do
        local it = shown[i]
        if it then
            local col = TIERS[it.tier].col
            row.frame.Visible = true
            row.bar.BackgroundColor3 = col
            row.name.Text = it.name
            row.val.Text = string.format("%s/s • %dm", fmt(it.value), math.floor(it.dist + 0.5))
            row.val.TextColor3 = col:Lerp(WHITE, 0.3)
        else
            row.frame.Visible = false
        end
    end
    if ui.listEmpty then ui.listEmpty.Visible = (#shown == 0) end
end
local function refreshEspColors() if S.esp then pcall(updateEsp) end end

-- garis tracer (dari bawah-tengah layar ke pet)
bind(RunService.RenderStepped, function()
    local cam = workspace.CurrentCamera
    if not cam or next(espData) == nil then return end
    local on = S.esp and S.tracer
    local vp = cam.ViewportSize
    local origin = Vector2.new(vp.X / 2, vp.Y)
    for _, d in pairs(espData) do
        local ln = d.line
        if ln then
            if on and d.part and d.part.Parent then
                local p, vis = cam:WorldToViewportPoint(d.part.Position)
                if vis and p.Z > 0 then
                    local target = Vector2.new(p.X, p.Y)
                    local delta = target - origin
                    ln.Visible = true
                    ln.Size = UDim2.fromOffset(delta.Magnitude, 2)
                    ln.Position = UDim2.fromOffset((origin.X + target.X) / 2, (origin.Y + target.Y) / 2)
                    ln.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                else
                    ln.Visible = false
                end
            else
                ln.Visible = false
            end
        end
    end
end)

----------------------------------------------------------------------
-- INFO BAR + LOGO (dibuat dulu supaya bisa dipakai tombol di halaman)
----------------------------------------------------------------------
local infoBar = new("Frame", {
    Name = "InfoBar", Size = UDim2.fromOffset(310, 22), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 3),
    BackgroundColor3 = rgb(12, 15, 25), BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 50, Visible = S.infoBar,
}, gui)
corner(infoBar, PILL)
role(stroke(infoBar, 1), "Color", "accent")
local infoLabel = lbl(infoBar, "📊 FPS --  |  📶 --ms", 11, FONT.GothamBold, GREEN, UDim2.new(0, 6, 0, 0), UDim2.new(1, -12, 1, 0))
infoLabel.ZIndex = 51

local logo = new("TextButton", {
    Name = "LogoBtn", Size = UDim2.fromOffset(42, 42), Position = UDim2.new(0, 12, 0.5, -21), Text = "🌐", TextSize = 20,
    Font = FONT.GothamBold, TextColor3 = WHITE, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 40,
}, gui)
role(logo, "BackgroundColor3", "black")
corner(logo, ROUND)
role(stroke(logo, 2), "Color", "accent")
drag(logo, logo, function() main.Visible = not main.Visible end)
minBtn.MouseButton1Click:Connect(function() main.Visible = false end)
bind(UIS.InputBegan, function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then main.Visible = not main.Visible end
end)

----------------------------------------------------------------------
-- HALAMAN
----------------------------------------------------------------------
local pMain = makePage("MAIN", { 0.34, 0.33, 0.33 })
local pEsp = makePage("ESP", { 0.35, 0.32, 0.33 })
local pTema = makePage("TEMA", { 0.30, 0.70 }, { false, true })
local pInfo = makePage("INFO", { 0.5, 0.5 })

---------------- MAIN ----------------
do
    local c = card(pMain[1], "🥚 AUTO CATCH")
    local catchT
    catchT = toggle(c, "🥚 Auto Catch", false, function(v)
        S.autoCatch = v
        if not v then return end
        local ok, remote = pcall(function() return RS.Modules.Shared.Packages.Network.rev_EggClick end)
        if not (ok and remote) then
            S.autoCatch = false
            catchT:Set(false)
            notify("ERROR", "Remote EggClick tidak ketemu", rgb(248, 113, 113))
            return
        end
        task.spawn(function()
            while S.autoCatch and gui.Parent do
                pcall(function()
                    remote:FireServer()
                    remote:FireServer()
                end)
                stat.eggs = stat.eggs + 2
                task.wait(0.01)
            end
        end)
    end)
    infoText(c, "Mengirim remote EggClick sangat cepat. Berisiko kena kick / ban.")

    local c2 = card(pMain[1], "🏃 TREADMILL")
    toggle(c2, "⏩ Auto X2", false, function(v)
        S.autoX2 = v
        if not v then return end
        task.spawn(function()
            while S.autoX2 and gui.Parent do
                for b in pairs(activeX2) do safeClick(b) end
                task.wait(0.25)
            end
        end)
    end)
    infoText(c2, "Klik tombol X2PopUp otomatis kalau sedang terlihat.")
end

do
    local c = card(pMain[2], "🏠 AUTO BASE")
    toggle(c, "🏠 Auto Base", false, function(v) S.autoBase = v end)
    cycle(c, "📦 Mode", { "Tween", "Teleport" }, "Tween", function(v) S.baseMode = v end)
    inputRow(c, "⚡ Speed (stud/s)", S.baseSpeed, function(t, tb)
        local n = tonumber(t)
        if n then S.baseSpeed = math.clamp(n, 5, 500) end
        tb.Text = tostring(S.baseSpeed)
    end)
    button(c, "📍 Go To Base Now", function() goToBase() end)
    infoText(c, "Auto Base: balik ke base setelah kamu menekan prompt 'ride'.")
end

do
    local c = card(pMain[3], "🛡️ UTILITAS")
    toggle(c, "🛡️ Anti AFK", false, function(v) S.antiAfk = v end)
    infoText(c, "Mencegah kena kick karena diam terlalu lama.")

    local c2 = card(pMain[3], "📈 SESI")
    ui.sUptime = statRow(c2, "⏱️ Waktu aktif")
    ui.sEggs = statRow(c2, "🥚 Catch terkirim")
    ui.sTrips = statRow(c2, "🏠 Perjalanan ke base")
    ui.sPets = statRow(c2, "🐾 Pet terdeteksi")
end

---------------- ESP ----------------
local tierRefresh = {}
local function tierRow(c, i)
    local t = TIERS[i]
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 36), Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = nextOrder(c),
    }, c)
    role(row, "BackgroundColor3", "btn")
    soft(row)
    bubble(row)
    local dot = new("Frame", { Size = UDim2.fromOffset(12, 12), Position = UDim2.new(0, 12, 0.5, -6), BackgroundColor3 = t.col, BorderSizePixel = 0 }, row)
    corner(dot, ROUND)
    lbl(row, t.name, 13, FONT.GothamBlack, WHITE, UDim2.new(0, 32, 0, 0), UDim2.new(0, 52, 1, 0), LEFT)
    role(lbl(row, t.range, 10, FONT.Gotham, WHITE, UDim2.new(0, 84, 0, 0), UDim2.new(1, -170, 1, 0), LEFT), "TextColor3", "grey")
    ui.tierCnt[i] = lbl(row, "×0", 12, FONT.GothamBold, WHITE, UDim2.new(1, -98, 0, 0), UDim2.new(0, 44, 1, 0), RIGHT)
    local box = new("Frame", { Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -34, 0.5, -10), BorderSizePixel = 0 }, row)
    corner(box, 7)
    local bst = stroke(box, 1.5)
    bst.Color = t.col
    local tick = lbl(box, "✔", 12, FONT.GothamBlack, rgb(10, 10, 15), UDim2.new(), UDim2.fromScale(1, 1))
    local function refresh(animate)
        local on = S.tiers[i]
        local bg = on and t.col or rgb(30, 34, 48)
        if animate then
            TweenService:Create(box, TweenInfo.new(0.15), { BackgroundColor3 = bg }):Play()
        else
            box.BackgroundColor3 = bg
        end
        tick.Visible = on
        dot.BackgroundTransparency = on and 0 or 0.65
    end
    tierRefresh[#tierRefresh + 1] = refresh
    refresh(false)
    row.MouseButton1Click:Connect(function()
        S.tiers[i] = not S.tiers[i]
        refresh(true)
        save()
        pcall(updateEsp)
    end)
end
local function setTiers(from, to)
    for i = 1, 7 do S.tiers[i] = (i >= from and i <= to) end
    for _, fn in ipairs(tierRefresh) do fn(true) end
    save()
    pcall(updateEsp)
end
local function moneyText(v) return (v and v > 0) and fmt(v) or "0" end
local function numInput(t)
    local v = parseMoney(t)
    if v == 0 then v = tonumber(t) or 0 end
    return math.max(v, 0)
end

do
    local c = card(pEsp[1], "👁️ ANIMAL ESP")
    toggle(c, "👁️ Animal ESP", S.esp, function(v)
        S.esp = v
        if v then pcall(updateEsp) else clearEsp() end
    end)
    toggle(c, "✨ Highlight pet", S.hl, function(v) S.hl = v save() pcall(updateEsp) end)
    toggle(c, "🏷️ Tampilkan nama", S.showName, function(v) S.showName = v save() pcall(updateEsp) end)
    toggle(c, "📏 Tampilkan jarak", S.showDist, function(v) S.showDist = v save() pcall(updateEsp) end)
    toggle(c, "📍 Garis tracer", S.tracer, function(v) S.tracer = v save() end)
    toggle(c, "🎨 Warna per tier", S.tierColor, function(v) S.tierColor = v save() pcall(updateEsp) end)

    local f = card(pEsp[1], "🎯 FILTER $/s")
    inputRow(f, "💰 Min $/s", moneyText(S.espMin), function(t, tb)
        S.espMin = numInput(t)
        tb.Text = moneyText(S.espMin)
        save()
        pcall(updateEsp)
    end, "5k / 1m / 2.5b")
    inputRow(f, "💎 Max $/s", moneyText(S.espMax), function(t, tb)
        S.espMax = numInput(t)
        tb.Text = moneyText(S.espMax)
        save()
        pcall(updateEsp)
    end, "0 = tanpa batas")
    inputRow(f, "📏 Max jarak", tostring(S.espRange), function(t, tb)
        S.espRange = math.max(tonumber(t) or 0, 0)
        tb.Text = tostring(S.espRange)
        save()
        pcall(updateEsp)
    end, "0 = bebas")
end

do
    local c = card(pEsp[2], "🎚️ TIER PET")
    rowButtons(c, {
        { "SEMUA", function() setTiers(1, 7) end },
        { "10K+", function() setTiers(2, 7) end },
        { "1M+", function() setTiers(4, 7) end },
        { "100M+", function() setTiers(6, 7) end },
    })
    for i = 1, 7 do tierRow(c, i) end
    infoText(c, "Centang tier yang mau ditampilkan. Angka ×N = jumlah pet di map saat ini. Tiap tier punya warna sendiri.")
end

do
    local c = card(pEsp[3], "📋 PET TERDETEKSI")
    ui.setTotal = statRow(c, "🐾 Total di map")
    ui.setShown = statRow(c, "👁️ Sesuai filter")
    for i = 1, 8 do
        local f = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0, LayoutOrder = nextOrder(c), Visible = false }, c)
        role(f, "BackgroundColor3", "btn")
        soft(f)
        corner(f, 10)
        local bar = new("Frame", { Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 6, 0.5, -8), BorderSizePixel = 0 }, f)
        corner(bar, ROUND)
        local nm = lbl(f, "", 11, FONT.GothamBold, WHITE, UDim2.new(0, 16, 0, 0), UDim2.new(0.48, -16, 1, 0), LEFT)
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        local val = lbl(f, "", 10, FONT.GothamBold, WHITE, UDim2.new(0.48, 0, 0, 0), UDim2.new(0.52, -8, 1, 0), RIGHT)
        ui.listRows[i] = { frame = f, bar = bar, name = nm, val = val }
    end
    ui.listEmpty = infoText(c, "Belum ada pet yang cocok dengan filter. Coba pilih tier lain atau dekati pet.")
    infoText(c, "Menampilkan 8 pet dengan $/s tertinggi yang lolos filter.")
end

task.spawn(function()
    while gui.Parent do
        if S.esp or (pages.ESP.frame.Visible and main.Visible) then pcall(updateEsp) end
        task.wait(0.7)
    end
end)

---------------- INFO ----------------
local gameName = "Memuat..."
task.spawn(function()
    local ok, info = pcall(function() return Market:GetProductInfo(game.PlaceId) end)
    gameName = (ok and info and info.Name) or ("Place " .. tostring(game.PlaceId))
end)
local setGame, setPlace, setJob, setPlayers, setNet, setMem
do
    local c = card(pInfo[1], "🎮 INFO GAME")
    setGame = statRow(c, "🎮 Game")
    setPlace = statRow(c, "🆔 Place ID")
    setJob = statRow(c, "🧩 Job ID")
    setPlayers = statRow(c, "👥 Player")
    setNet = statRow(c, "📶 FPS / Ping")
    setMem = statRow(c, "💾 Memori")
    local function copyBtn(text, getter)
        button(c, text, function(b)
            local ok = false
            if setclipboard then ok = pcall(setclipboard, tostring(getter())) end
            b.Text = ok and "✅ Tersalin" or "⚠️ Tidak support"
            task.delay(1.5, function() b.Text = text end)
        end)
    end
    copyBtn("📋 Salin Place ID", function() return game.PlaceId end)
    copyBtn("📋 Salin Job ID", function() return game.JobId end)

    local c2 = card(pInfo[2], "🧰 TENTANG")
    infoText(c2, "• Tema & tampilan sama seperti UniversalHub (46 tema + animasi dekorasi).\n• Ganti tema di tab TEMA, ukuran UI juga bisa diatur di sana.\n• ESP bisa difilter per tier: 10K, 100K, 1M, 10M, 100M, 1B+.\n• Tombol 🌐 di layar untuk sembunyikan / tampilkan UI (bisa digeser). Di PC: RightShift.")
    button(c2, "🧭 Tengahkan UI", function() main.Position = MAIN_POS end)
end

local function refreshInfo()
    setGame(gameName)
    setPlace(game.PlaceId)
    setJob(game.JobId ~= "" and game.JobId or "-")
    setPlayers(string.format("%d / %d", #Players:GetPlayers(), Players.MaxPlayers))
    setNet(string.format("%s / %sms", tostring(ui.fps or "--"), tostring(ui.ping or "--")))
    setMem(string.format("%s MB", tostring(ui.mem or "--")))
end
refreshInfo()

-- update statistik sesi + info tiap detik
task.spawn(function()
    while gui.Parent do
        task.wait(1)
        if main.Visible then
            local s = math.floor(os.clock() - stat.t0)
            ui.sUptime(string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor((s % 3600) / 60), s % 60))
            ui.sEggs(stat.eggs)
            ui.sTrips(stat.trips)
            ui.sPets(ui.petTotal or 0)
            if pages.INFO.frame.Visible then refreshInfo() end
        end
    end
end)

---------------- TEMA ----------------
local themeCards = {}
local function markActive()
    for id, tc in pairs(themeCards) do
        local on = (id == S.theme)
        tc.tick.Visible = on
        tc.act.Enabled = on
    end
    local th = engine.byId[S.theme]
    if th and ui.setThemeName then ui.setThemeName(th.icon .. " " .. th.name) end
end

do
    local c0 = card(pTema[1], "🎨 TEMA AKTIF")
    ui.setThemeName = statRow(c0, "Sekarang")
    local cs = card(pTema[1], "🔎 CARI TEMA")
    searchBox(cs, "ketik nama tema...", function(txt)
        local q = string.lower(txt)
        for _, tc in pairs(themeCards) do
            tc.btn.Visible = (q == "" or tc.key:find(q, 1, true) ~= nil)
        end
    end)

    local c = card(pTema[1], "⚙️ PENGATURAN")
    toggle(c, "✨ Animasi dekorasi", S.anim, function(v)
        S.anim = v
        engine.setAnim(v)
        save()
    end)
    toggle(c, "📊 Info bar (FPS/ping)", S.infoBar, function(v)
        S.infoBar = v
        infoBar.Visible = v
        save()
    end)
    inputRow(c, "🌫️ Transparan %", tostring(math.floor(S.pt * 100 + 0.5)), function(t, tb)
        local n = tonumber(t)
        if n then
            S.pt = math.clamp(n, 0, 85) / 100
            applySoft()
            save()
        end
        tb.Text = tostring(math.floor(S.pt * 100 + 0.5))
    end, "0 - 85")
    inputRow(c, "📐 Ukuran UI %", tostring(math.floor(S.size * 100 + 0.5)), function(t, tb)
        local n = tonumber(t)
        if n then
            S.size = math.clamp(n, 60, 100) / 100
            refit(true)
            save()
        end
        tb.Text = tostring(math.floor(S.size * 100 + 0.5))
    end, "60 - 100")
    inputRow(c, "🖼️ ID gambar", S.img, function(t, tb)
        if setImage(t) then
            applyTheme("default")
            notify("TEMA", "Background gambar diganti", pal.accent)
        else
            tb.Text = S.img
        end
    end, "angka asset id")
    infoText(c, "Isi asset ID gambar / decal, lalu tema 'Bawaan (Foto)' dipakai dengan gambar itu.")
end

for idx, th in ipairs(engine.THEMES) do
    local b = new("TextButton", { Name = th.id, Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = idx }, pTema[2])
    role(b, "BackgroundColor3", "btn")
    soft(b)
    bubble(b, UDim.new(0, 16))
    local sw = new("Frame", { Size = UDim2.fromOffset(38, 38), Position = UDim2.new(0, 10, 0.5, -19), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, b)
    corner(sw, 12)
    local sws = stroke(sw, 1)
    sws.Color = WHITE
    sws.Transparency = 0.4
    new("UIGradient", {
        Rotation = 45,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, th.sw[1]), ColorSequenceKeypoint.new(0.5, th.sw[2]), ColorSequenceKeypoint.new(1, th.sw[3]),
        }),
    }, sw)
    lbl(sw, th.icon, 17, FONT.GothamBold, WHITE, UDim2.new(), UDim2.fromScale(1, 1))
    local nm = lbl(b, th.name, 12, FONT.GothamBold, WHITE, UDim2.new(0, 58, 0, 11), UDim2.new(1, -88, 0, 18), LEFT)
    nm.TextTruncate = Enum.TextTruncate.AtEnd
    for k = 1, 3 do
        local d = new("Frame", {
            Size = UDim2.fromOffset(10, 10), Position = UDim2.new(0, 58 + (k - 1) * 15, 0, 36), BackgroundColor3 = th.sw[k], BorderSizePixel = 0,
        }, b)
        corner(d, ROUND)
    end
    local tk = lbl(b, "✔", 15, FONT.GothamBlack, WHITE, UDim2.new(1, -30, 0, 6), UDim2.fromOffset(20, 20))
    tk.Visible = false
    local act = stroke(b, 2)
    act.Name = "ActiveStroke"
    role(act, "Color", "accent")
    act.Enabled = false
    themeCards[th.id] = { btn = b, tick = tk, act = act, key = string.lower(th.name .. " " .. th.id) }
    b.MouseButton1Click:Connect(function() applyTheme(th.id) end)
end

applyTheme = function(id, silent)
    local th = engine.byId[id] or engine.byId.default
    S.theme = th.id
    for k, v in pairs(th.pal) do pal[k] = v end
    curRim = th.rim
    recolor()

    for i = #engine.anims, 1, -1 do engine.anims[i] = nil end
    engine.deco:ClearAllChildren()
    if th.id == "default" then
        engine.fxRoot.Visible = false
        bgImage.Visible = true
        setImage(S.img)
    else
        bgImage.Visible = false
        engine.fxRoot.Visible = true
        engine.fxRoot.BackgroundTransparency = 0.6
        TweenService:Create(engine.fxRoot, TweenInfo.new(0.35), { BackgroundTransparency = 0 }):Play()
        local ok, err = pcall(engine.build[th.id])
        if not ok then warn("RODEO tema " .. th.id .. ": " .. tostring(err)) end
    end
    markActive()
    refreshEspColors()
    if not silent then save() end
end

----------------------------------------------------------------------
-- FPS / PING + TOMBOL CLOSE
----------------------------------------------------------------------
local frames, acc = 0, 0
bind(RunService.RenderStepped, function(dt)
    frames = frames + 1
    acc = acc + dt
    if acc >= 0.5 then
        local fps = math.floor(frames / acc + 0.5)
        frames, acc = 0, 0
        local ping, mem = 0, 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        pcall(function() mem = math.floor(Stats:GetTotalMemoryUsageMb()) end)
        local col = (ping < 100 and GREEN) or (ping < 200 and YELLOW) or RED
        infoLabel.Text = string.format("📊 FPS %d  |  📶 %dms  |  👥 %d  |  💾 %dMB", fps, ping, #Players:GetPlayers(), mem)
        infoLabel.TextColor3 = col
        statLabel.Text = string.format("FPS %d  •  %dms", fps, ping)
        statLabel.TextColor3 = col
        ui.fps, ui.ping, ui.mem = fps, ping, mem
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    S.autoCatch, S.autoBase, S.autoX2, S.esp, S.antiAfk = false, false, false, false, false
    clearEsp()
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    gui:Destroy()
end)

----------------------------------------------------------------------
-- START
----------------------------------------------------------------------
showTab("MAIN")
applyTheme(S.theme, true)
applySoft()
refit(false)
notify("RODEO HUB", "Loaded • tema sama seperti UniversalHub", pal.accent)
