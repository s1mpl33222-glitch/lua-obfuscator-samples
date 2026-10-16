--[[
                                        ==                                     
                             =   ===    ====     ==                            
                            ========   =======  ====     ==                    
                           =========    ============     ===  ==               
                        ============    ===============  ========              
                      =============== ================== ==========            
                    =====  ======================   ====== ==========          
                 =================== ======================== === ====         
                 ================== ====================================       
                  =======================================================      
                   =====================================================       
                           ====== ==================     ========= ===         
                           ====== =============================                
                           ========================= =========           =     
                           ===================================         ==      
                          =====================================       ===      
                          ======================================     ====      
                           ======================================    ====      
                           ========================================   =====    
                            ========================================   =====   
                           ==========================================   ====   
                           ========= === ============================   -====  
                          =========     ============= ================   ====  
                          ========      ============= ================   ====  
                         ========      ============== ================  ====   
                         =======       ======= ======= ===============  ===    
                        =======       =======   ======== =================     
                     ==========   ==========      ===== ==============         
                   ===========   ===========    ===== ===============          
                   ==========   ===========    ===== ==============            
]]













































































































































































-- whatever you're looking for, you won't find it here...
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")

local GITHUB_BASE_URL  = "https://raw.githubusercontent.com/safetrademarketplace/scripts/refs/heads/main/"
local UNIVERSAL_URL    = "https://api.luarmor.net/files/v4/loaders/1acad587672d96c8afb9c5bbc36bf921.lua"
local DISCORD_URL      = "https://getcerberus.com/discord"
local EXECUTORS_URL    = "https://getcerberus.com/executors"
local BROKE_URL        = "https://getcerberus.com/madium"
local SKIP_FOLDER      = "Cerberus"
local SKIP_FILE        = "Cerberus/executor_warning.txt"
local LOGO_ASSET       = "rbxassetid://136497541793809"

local C = {
    bg        = Color3.fromRGB(12, 15, 21),
    surface   = Color3.fromRGB(20, 25, 33),
    surface2  = Color3.fromRGB(27, 33, 43),
    track     = Color3.fromRGB(38, 44, 56),
    text      = Color3.fromRGB(233, 240, 250),
    subtext   = Color3.fromRGB(140, 150, 166),
    faint     = Color3.fromRGB(92, 102, 118),
    accent    = Color3.fromRGB(90, 255, 140),
    accentHi  = Color3.fromRGB(150, 255, 190),
    accentDk  = Color3.fromRGB(6, 28, 16),
    danger    = Color3.fromRGB(255, 96, 96),
    amber     = Color3.fromRGB(255, 184, 70),
    white     = Color3.fromRGB(255, 255, 255),
}

local UNIVERSE_MAP = {
    ["3764534614"] = "runeSlayer.lua", ["6115988515"] = "animeSaga.lua", ["7095682825"] = "beaks.lua",
    ["4777817887"] = "bladeBall.lua", ["18668065416"] = "blueLock.lua", ["85896571713843"] = "bgsi.lua",
    ["7018190066"] = "deadRails.lua", ["2880808628"] = "ffo.lua", ["5750914919"] = "fisch.lua",
    ["6331902150"] = "foresaken.lua", ["7436755782"] = "gag.lua", ["2535080489"] = "herosOnline.lua",
    ["7314989375"] = "hunters.lua", ["6048923315"] = "kaizen.lua", ["7513130835"] = "untitledDrillGame.lua",
    ["6931042565"] = "volleyballLegends.lua", ["4931927012"] = "basketballLegends.lua",
    ["6770632849"] = "mugen.lua", ["7218065222"] = "dig.lua", ["4737765103"] = "murimCultivation.lua",
    ["4871329703"] = "typeSoul.lua", ["5569032992"] = "dandysWorld.lua", ["7709344486"] = "stealABrainrot.lua",
    ["5677613211"] = "eatTheWorld.lua", ["7822444776"] = "buildAPlane.lua", ["7326934954"] = "99NITF.lua",
    ["4862269388"] = "archived.lua", ["8051387991"] = "rebornCultivation.lua", ["7882829745"] = "animeEternal.lua",
    ["7219654364"] = "murderersVsSheriffs.lua", ["1946714362"] = "bloodlines.lua", ["7718422952"] = "newMoon.lua",
    ["7671049560"] = "theForge.lua", ["6490954291"] = "ghoulRe.lua", ["9391202356"] = "ghoulRe.lua",
    ["7440311707"] = "demonHunter.lua", ["7024319539"] = "reawakened.lua", ["9363735110"] = "tsunamiBrainrot.lua",
    ["9344307274"] = "breakALuckyBlock.lua", ["5831253580"] = "sorcererAscent.lua", ["1828997286"] = "excry.lua",
    ["8144728961"] = "abyss.lua", ["6701277882"] = "fishIt.lua", ["9649298941"] = "ELFB.lua",
    ["9563386957"] = "CFB.lua", ["7048187681"] = "slayerbound.lua", ["9484779066"] = "SAB.lua",
    ["7983308985"] = "lastLetter.lua", ["648454481"] = "GPO.lua", ["9509842868"] = "gardenHorizons.lua",
    ["5130394318"] = "bizzareLineage.lua", ["9663968307"] = "hooked.lua", ["9872691883"] = "everwind.lua",
    ["4818959878"] = "mashle.lua", ["3726919761"] = "cursedGear.lua", ["8524572339"] = "bridger.lua",
    ["8202280624"] = "bbn.lua", ["9186719164"] = "sailor.lua", ["6161049307"] = "pixelBlade.lua",
    ["3646793294"] = "paradox.lua", ["4658598196"] = "aotr.lua", ["10016841656"] = "noobTD.lua",
    ["1359573625"] = "deepwoken.lua", ["9792947201"] = "slime.lua", ["6409513651"] = "animeWarriors3.lua",
    ["10006104044"] = "wizardsAlchemy.lua", ["2309918273"] = "vv.lua", ["9826885587"] = "evomon.lua",
    ["10200395747"] = "gag2.lua", ["2644656496"] = "hazeSeas.lua", ["9199655655"] = "gakuran.lua",
    ["7613921865"] = "animeExpeditions.lua", ["4827308727"] = "havoc.lua", ["7395930870"] = "sellLemons.lua",
    ["10148749921"] = "animalHospital.lua", ["1511883870"] = "shindoLife.lua", ["7529591378"] = "practicalBasketball.lua", ["578392296"] = "aba.lua",
    ["6035872082"] = "rivals.lua", ["6385532960"] = "ryujin.lua", ["10563114921"] = "stealAnEgg.lua", ["4760747038"] = "wonderland.lua",
    ["6739698191"] = "violenceDistrict.lua", ["9931749389"] = "dqr.lua", ["2459091562"] = "RH2.lua", ["7970033072"] = "theVeil.lua",
    ["5595353122"] = "projectSlayers2.lua"
}

local FREE_SCRIPTS = {
    ["animeExpeditions.lua"] = true, ["gag2.lua"] = true, ["slime.lua"] = true, ["deepwoken.lua"] = true,
    ["sellLemons.lua"] = true, ["animalHospital.lua"] = true, ["animeWarriors3.lua"] = true, ["bbn.lua"] = true,
    ["shindoLife.lua"] = true, ["practicalBasketball.lua"] = true, ["aba.lua"] = true, ["rivals.lua"] = true, ["ryujin.lua"] = true,
    ["stealAnEgg.lua"] = true, ["wonderland.lua"] = true, ["violenceDistrict.lua"] = true, ["dqr.lua"] = true, ["RH2.lua"] = true,
    ["bridger.lua"] = true, ["theVeil.lua"] = true, ["projectSlayers2.lua"] = true
}

local LUARMOR_SDK_URL   = "https://sdkapi-public.luarmor.net/library.lua"
local LUARMOR_SCRIPT_ID = "2a503330cb8ca154841314e3b291f7bf"
local LuarmorAPI, LuarmorInitDone

local function initLuarmor()
    if LuarmorInitDone then return end
    LuarmorInitDone = true
    if type(LUARMOR_SCRIPT_ID) ~= "string" or LUARMOR_SCRIPT_ID == "" then return end
    local ok, lib = pcall(function() return loadstring(game:HttpGet(LUARMOR_SDK_URL))() end)
    if ok and type(lib) == "table" then
        LuarmorAPI = lib
        LuarmorAPI.script_id = LUARMOR_SCRIPT_ID
    end
end

local ENV = (type(getgenv) == "function" and getgenv()) or _G
local function truthy(v) return v ~= nil and v ~= false and v ~= 0 and v ~= "" end

-- executors cerberus does not run on, matched against the reported name
local UNSUPPORTED_EXECUTORS = {
    { match = "xeno",   name = "Xeno" },
    { match = "solara", name = "Solara" },
    { match = "delta",  name = "Delta" },
}

local function executorName()
    local ok, name = pcall(function()
        if type(identifyexecutor) == "function" then return identifyexecutor() end
        if type(getexecutorname) == "function" then return getexecutorname() end
        return nil
    end)
    if ok and type(name) == "string" and name ~= "" then return name end
    return nil
end

-- "don't show this again" lives in the workspace, so it survives between runs
local function warningDismissed()
    local ok, res = pcall(function() return isfile and isfile(SKIP_FILE) end)
    return ok and res == true
end

-- returns whether the file actually ended up in the state we asked for
local function setWarningDismissed(on, name)
    pcall(function()
        if on then
            if makefolder then pcall(makefolder, SKIP_FOLDER) end
            if writefile then writefile(SKIP_FILE, "dismissed on " .. tostring(name)) end
        elseif delfile then
            delfile(SKIP_FILE)
        end
    end)
    return warningDismissed() == on
end

local function unsupportedExecutor()
    if truthy(ENV.CERBERUS_IGNORE_EXECUTOR or _G.CERBERUS_IGNORE_EXECUTOR) then return nil end
    local raw = executorName()
    if not raw then return nil end
    local low = raw:lower()
    for _, e in ipairs(UNSUPPORTED_EXECUTORS) do
        if low:find(e.match, 1, true) then return e.name end
    end
    return nil
end

local function face(weight)
    local ok, f = pcall(function() return Font.new("rbxasset://fonts/families/BuilderSans.json", weight) end)
    if ok and f then return f end
    return Font.fromEnum(Enum.Font.Gotham)
end
local FONT = {
    med  = face(Enum.FontWeight.Medium),
    semi = face(Enum.FontWeight.SemiBold),
    bold = face(Enum.FontWeight.Bold),
}

local function make(class, props)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then inst[k] = v end
        end
        if props.Parent then inst.Parent = props.Parent end
    end
    return inst
end
local function TI(d, style, dir)
    return TweenInfo.new(d, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
end
local function tween(o, ti, goal)
    local t = TweenService:Create(o, ti, goal)
    t:Play()
    return t
end
local function corner(p, r) return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = p }) end
local function stroke(p, color, transparency, thickness)
    return make("UIStroke", {
        Color = color, Transparency = transparency or 0, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p,
    })
end
local function grad(p, c1, c2, rot) return make("UIGradient", { Color = ColorSequence.new(c1, c2), Rotation = rot or 0, Parent = p }) end
local function txt(props)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.FontFace = FONT.med
    t.TextColor3 = C.text
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Left
    for k, v in pairs(props) do if k ~= "Parent" then t[k] = v end end
    if props.Parent then t.Parent = props.Parent end
    return t
end

local function pickParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and typeof(hui) == "Instance" then return hui end
    if CoreGui then return CoreGui end
    local lp = Players.LocalPlayer
    return lp and lp:FindFirstChildOfClass("PlayerGui")
end

local function prettify(file)
    local s = (file or ""):gsub("%.lua$", "")
    s = s:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")
    if #s == 0 then return "Cerberus" end
    return s:sub(1, 1):upper() .. s:sub(2)
end

local Panel = {}
Panel.__index = Panel

function Panel.new()
    local parent = pickParent()
    local existing = parent and parent:FindFirstChild("CerberusLoaderGui")
    if existing then existing:Destroy() end

    local self = setmetatable({ conns = {}, sweepTween = nil, pulseTween = nil }, Panel)

    local gui = make("ScreenGui", {
        Name = "CerberusLoaderGui", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999999,
    })
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui)
        elseif protectgui then protectgui(gui) end
    end)
    gui.Parent = parent
    self.gui = gui

    local W, H = 460, 300
    local holder = make("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H), Parent = gui,
    })
    self.holder = holder
    self.scale = make("UIScale", { Scale = 0.94, Parent = holder })

    local win = make("CanvasGroup", { BackgroundColor3 = C.bg, GroupTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = holder })
    corner(win, 16)
    stroke(win, C.white, 0.9)
    self.win = win

    local header = make("Frame", { BackgroundTransparency = 1, Active = true, Size = UDim2.new(1, 0, 0, 56), Parent = win })
    self.header = header
    local dot = make("Frame", { BackgroundColor3 = C.accent, Position = UDim2.fromOffset(22, 25), Size = UDim2.fromOffset(8, 8), Parent = header })
    corner(dot, 4)
    local word = txt({ Text = "CERBERUS", FontFace = FONT.bold, TextSize = 16, Position = UDim2.fromOffset(40, 0), Size = UDim2.fromOffset(140, 56), Parent = header })
    grad(word, C.accent, C.accentHi, 90)

    local pill = make("Frame", { BackgroundColor3 = C.surface2, Position = UDim2.fromOffset(140, 20), Size = UDim2.fromOffset(84, 18), Parent = header })
    corner(pill, 6)
    local pillStroke = stroke(pill, C.faint, 0.4)
    local pillLbl = txt({ Text = "LOADER", FontFace = FONT.semi, TextSize = 10, TextColor3 = C.faint, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), Parent = pill })
    self.pill, self.pillStroke, self.pillLbl = pill, pillStroke, pillLbl

    local close = make("TextButton", {
        Text = "×", TextSize = 20, FontFace = FONT.med, TextColor3 = C.subtext,
        AutoButtonColor = false, BackgroundColor3 = C.white, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0, 28), Size = UDim2.fromOffset(30, 30), Parent = header,
    })
    corner(close, 8)
    self:track(close.MouseEnter:Connect(function() tween(close, TI(0.1), { BackgroundTransparency = 0.92, TextColor3 = C.danger }) end))
    self:track(close.MouseLeave:Connect(function() tween(close, TI(0.16), { BackgroundTransparency = 1, TextColor3 = C.subtext }) end))
    self:track(close.MouseButton1Click:Connect(function() self:destroy() end))

    make("Frame", { BackgroundColor3 = C.white, BackgroundTransparency = 0.92, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 0, 1), Parent = win })

    local iconWrap = make("Frame", { BackgroundColor3 = C.accent, BackgroundTransparency = 0.86, Position = UDim2.fromOffset(22, 78), Size = UDim2.fromOffset(46, 46), Parent = win })
    corner(iconWrap, 12)
    local iconStroke = stroke(iconWrap, C.accent, 0.4)
    local logo = make("ImageLabel", { BackgroundTransparency = 1, Image = LOGO_ASSET, ImageColor3 = C.accent, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(26, 26), Parent = iconWrap })
    local glyph = txt({ Text = "", FontFace = FONT.bold, TextSize = 24, TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Center, Visible = false, Size = UDim2.fromScale(1, 1), Parent = iconWrap })
    self.iconWrap, self.iconStroke, self.logo, self.glyph = iconWrap, iconStroke, logo, glyph

    local title = txt({ Text = "Starting up", FontFace = FONT.bold, TextSize = 18, Position = UDim2.fromOffset(84, 76), Size = UDim2.new(1, -106, 0, 26), Parent = win })
    self.title = title
    local bodyScroll = make("ScrollingFrame", {
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.faint,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Position = UDim2.fromOffset(84, 104), Size = UDim2.new(1, -106, 0, 92), Parent = win,
    })
    local body = txt({
        Text = "Getting things ready.", TextSize = 14, TextColor3 = C.subtext, TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top, AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, -6, 0, 0), Parent = bodyScroll,
    })
    self.body = body

    local progWrap = make("Frame", { BackgroundColor3 = C.track, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(22, 210), Size = UDim2.new(1, -44, 0, 5), Parent = win })
    corner(progWrap, 3)
    local fill = make("Frame", { BackgroundColor3 = C.accent, BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0), Parent = progWrap })
    corner(fill, 3)
    local sweep = make("Frame", { BackgroundColor3 = C.accent, BorderSizePixel = 0, Visible = false, Size = UDim2.new(0.32, 0, 1, 0), Position = UDim2.new(-0.35, 0, 0, 0), Parent = progWrap })
    corner(sweep, 3)
    make("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = sweep })
    self.progWrap, self.fill, self.sweep = progWrap, fill, sweep

    local statusRow = make("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(22, 224), Size = UDim2.new(1, -44, 0, 16), Parent = win })
    local statusDot = make("Frame", { BackgroundColor3 = C.accent, Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(6, 6), Parent = statusRow })
    corner(statusDot, 3)
    local statusLbl = txt({ Text = "Starting", TextSize = 12, TextColor3 = C.faint, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -14, 1, 0), Parent = statusRow })
    self.statusRow, self.statusDot, self.statusLbl = statusRow, statusDot, statusLbl

    local btnRow = make("Frame", { BackgroundTransparency = 1, Visible = false, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -16), Size = UDim2.new(1, -44, 0, 38), Parent = win })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = btnRow })
    self.btnRow = btnRow

    self:_enter()
    self:_drag()
    self:_keys()
    self:startPulse()
    return self
end

function Panel:track(c) table.insert(self.conns, c); return c end

function Panel:_enter()
    tween(self.win, TI(0.22), { GroupTransparency = 0 })
    tween(self.scale, TI(0.32, Enum.EasingStyle.Back), { Scale = 1 })
end

function Panel:_drag()
    local dragging, dragStart, startPos
    self:track(self.header.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, io.Position, self.holder.Position
        end
    end))
    self:track(UserInputService.InputChanged:Connect(function(io)
        if dragging and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then
            local d = io.Position - dragStart
            self.holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    self:track(UserInputService.InputEnded:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end))
end

function Panel:_keys()
    self:track(UserInputService.InputBegan:Connect(function(io, gp)
        if not gp and io.KeyCode == Enum.KeyCode.Return then self:destroy() end
    end))
end

function Panel:startPulse()
    if self.pulseTween then return end
    self.iconStroke.Transparency = 0.4
    self.pulseTween = tween(self.iconStroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.8 })
end
function Panel:stopPulse()
    if self.pulseTween then self.pulseTween:Cancel(); self.pulseTween = nil end
    self.iconStroke.Transparency = 0.4
end

function Panel:mode(text, color)
    self.pillLbl.Text = text
    self.pillLbl.TextColor3 = color
    self.pillStroke.Color = color
    self.pillStroke.Transparency = color == C.faint and 0.4 or 0.25
end

function Panel:icon(color, glyphText)
    self.iconWrap.BackgroundColor3 = color
    self.iconStroke.Color = color
    if glyphText then
        self.logo.Visible = false
        self.glyph.Visible = true
        self.glyph.Text = glyphText
        self.glyph.TextColor3 = color
    else
        self.glyph.Visible = false
        self.logo.Visible = true
        self.logo.ImageColor3 = color
    end
end

function Panel:set(o)
    if o.title then self.title.Text = o.title end
    if o.titleColor then self.title.TextColor3 = o.titleColor end
    if o.body then self.body.Text = o.body end
    if o.status then self.statusLbl.Text = o.status end
    if o.statusDot then self.statusDot.BackgroundColor3 = o.statusDot end
end

function Panel:working(on)
    self.progWrap.Visible = on
    self.statusRow.Visible = on
    self.btnRow.Visible = not on
    if on then self:startPulse() else self:stopPulse() end
end

function Panel:progress(p)
    self.sweep.Visible = false
    if self.sweepTween then self.sweepTween:Cancel(); self.sweepTween = nil end
    tween(self.fill, TI(0.35), { Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) })
end

function Panel:busy()
    self:working(true)
    self.fill.Size = UDim2.new(0, 0, 1, 0)
    self.sweep.Visible = true
    if self.sweepTween then self.sweepTween:Cancel() end
    self.sweep.Position = UDim2.new(-0.35, 0, 0, 0)
    self.sweepTween = tween(self.sweep, TweenInfo.new(1.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), { Position = UDim2.new(1.03, 0, 0, 0) })
end

function Panel:nag(seconds, discordUrl)
    self:mode("KEYLESS", C.accent)
    self:icon(C.accent)
    self:set({
        title = "Free & Keyless",
        titleColor = C.accent,
        body = "This script is completely free and keyless, from Cerberus.\n\nJoin our Discord to skip the wait — and to unlock all our other keyless scripts, free.",
    })
    self.progWrap.Visible = true
    self.statusRow.Visible = true
    self:startPulse()
    self:buttons({
        { text = "Copy Discord", kind = "primary", flash = "Link copied!", cb = function()
            if setclipboard then setclipboard(discordUrl); return true end
            return false
        end },

        { text = "Skip the wait", kind = "ghost", cb = function()
            self:popup({
                title = "Skip the wait — go keyless",
                intro = "This script is free forever. Grab it from our Discord and you'll never see this wait again.",
                steps = {
                    "Join the Cerberus Discord.",
                    "Open the #free-panel channel.",
                    "Run the loader posted there — instant, every time.",
                },
                footer = "Every other Cerberus keyless script lives there too, all free.",
                buttons = {
                    { text = "Copy Discord", kind = "primary", flash = "Link copied!", cb = function()
                        if setclipboard then setclipboard(discordUrl); return true end
                        return false
                    end },
                    { text = "Got it", kind = "ghost", close = true },
                },
            })
        end },
    })

    self.sweep.Visible = false
    if self.sweepTween then self.sweepTween:Cancel(); self.sweepTween = nil end
    self.fill.Size = UDim2.new(0, 0, 1, 0)
    tween(self.fill, TweenInfo.new(seconds, Enum.EasingStyle.Linear), { Size = UDim2.new(1, 0, 1, 0) })

    for s = seconds, 1, -1 do
        if not self.gui then return false end
        self.statusLbl.Text = "Continuing in " .. s .. "s"
        task.wait(1)
    end
    self:closePopup()
    return self.gui ~= nil
end

function Panel:popup(o)
    self:closePopup()

    local scrim = make("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1), ZIndex = 500, Parent = self.gui,
    })
    tween(scrim, TI(0.18), { BackgroundTransparency = 0.55 })

    local holder = make("Frame", {
        BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(400, 10), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 501, Parent = self.gui,
    })
    local hscale = make("UIScale", { Scale = 0.9, Parent = holder })
    local dlg = make("Frame", { BackgroundColor3 = C.surface, Size = UDim2.new(1, 0, 0, 10), AutomaticSize = Enum.AutomaticSize.Y, Parent = holder })
    corner(dlg, 16)
    stroke(dlg, C.white, 0.88)
    make("UIPadding", { PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18), Parent = dlg })
    make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = dlg })

    txt({ Text = o.title or "Cerberus", FontFace = FONT.bold, TextSize = 18, TextColor3 = C.text, Size = UDim2.new(1, 0, 0, 24), LayoutOrder = 1, Parent = dlg })
    if o.intro then
        txt({ Text = o.intro, TextSize = 13, TextColor3 = C.subtext, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2, Parent = dlg })
    end
    for i, step in ipairs(o.steps or {}) do
        local row = make("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = 10 + i, Parent = dlg })
        local chip = make("Frame", { BackgroundColor3 = C.accent, BackgroundTransparency = 0.85, Position = UDim2.fromOffset(0, 2), Size = UDim2.fromOffset(22, 22), Parent = row })
        corner(chip, 6)
        stroke(chip, C.accent, 0.4)
        txt({ Text = tostring(i), FontFace = FONT.bold, TextSize = 12, TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), Parent = chip })
        txt({ Text = step, TextSize = 13, TextColor3 = C.text, TextYAlignment = Enum.TextYAlignment.Center, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -32, 1, 0), Parent = row })
    end
    if o.footer then
        txt({ Text = o.footer, TextSize = 12, TextColor3 = C.faint, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 40, Parent = dlg })
    end

    local btns = make("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 50, Parent = dlg })
    make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10), Parent = btns })
    for i, spec in ipairs(o.buttons or {}) do
        local primary = spec.kind == "primary"
        local b = make("TextButton", {
            Text = spec.text, FontFace = primary and FONT.semi or FONT.med, TextSize = 13,
            TextColor3 = primary and C.accentDk or C.subtext, AutoButtonColor = false,
            BackgroundColor3 = primary and C.accent or C.surface2, Size = UDim2.fromOffset(primary and 150 or 96, 34), LayoutOrder = i, Parent = btns,
        })
        corner(b, 9)
        if not primary then stroke(b, C.white, 0.9) end
        self:track(b.MouseEnter:Connect(function() tween(b, TI(0.1), primary and { BackgroundColor3 = C.accentHi } or { TextColor3 = C.text, BackgroundColor3 = C.track }) end))
        self:track(b.MouseLeave:Connect(function() tween(b, TI(0.16), primary and { BackgroundColor3 = C.accent } or { TextColor3 = C.subtext, BackgroundColor3 = C.surface2 }) end))
        self:track(b.MouseButton1Click:Connect(function()
            local ok = spec.cb and spec.cb()
            if spec.flash then
                b.Text = ok == false and "Unavailable" or spec.flash
                task.delay(1.4, function() if b.Parent then b.Text = spec.text end end)
            end
            if spec.close then self:closePopup() end
        end))
    end

    tween(hscale, TI(0.28, Enum.EasingStyle.Back), { Scale = 1 })
    self._popup = { scrim = scrim, holder = holder, scale = hscale }
    self:track(scrim.MouseButton1Click:Connect(function() self:closePopup() end))
end

function Panel:closePopup()
    local p = self._popup
    if not p then return end
    self._popup = nil
    tween(p.scrim, TI(0.16), { BackgroundTransparency = 1 })
    local t = tween(p.scale, TI(0.14), { Scale = 0.9 })
    t.Completed:Connect(function()
        if p.scrim then p.scrim:Destroy() end
        if p.holder then p.holder:Destroy() end
    end)
end

function Panel:buttons(list)
    for _, c in ipairs(self.btnRow:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    if not list or #list == 0 then self.btnRow.Visible = false; return end
    for i, spec in ipairs(list) do
        local primary = spec.kind == "primary"
        local w = primary and 158 or 116
        local b = make("TextButton", {
            Text = spec.text, FontFace = primary and FONT.semi or FONT.med, TextSize = 13,
            TextColor3 = primary and C.accentDk or C.subtext, AutoButtonColor = false,
            BackgroundColor3 = primary and C.accent or C.surface2, LayoutOrder = i,
            Size = UDim2.fromOffset(w, 36), Parent = self.btnRow,
        })
        corner(b, 10)
        if not primary then stroke(b, C.white, 0.9) end
        self:track(b.MouseEnter:Connect(function()
            tween(b, TI(0.1), primary and { BackgroundColor3 = C.accentHi } or { TextColor3 = C.text, BackgroundColor3 = C.track })
        end))
        self:track(b.MouseLeave:Connect(function()
            tween(b, TI(0.16), primary and { BackgroundColor3 = C.accent } or { TextColor3 = C.subtext, BackgroundColor3 = C.surface2 })
        end))
        self:track(b.MouseButton1Click:Connect(function()
            if spec.flash then
                local ok = spec.cb and spec.cb()
                b.Text = ok == false and "Unavailable" or spec.flash
                task.delay(1.4, function() if b.Parent then b.Text = spec.text end end)
            elseif spec.cb then
                spec.cb()
            end
        end))
    end
    self.btnRow.Visible = true
end

-- a checkbox row for the band the progress bar leaves empty on a stopped screen
function Panel:option(spec)
    if self.optRow then self.optRow:Destroy(); self.optRow = nil end
    if not spec then return end

    local row = make("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(22, 204), Size = UDim2.new(1, -44, 0, 24), Parent = self.win,
    })
    self.optRow = row

    local box = make("Frame", { BackgroundColor3 = C.surface2, Position = UDim2.fromOffset(0, 4), Size = UDim2.fromOffset(16, 16), Parent = row })
    corner(box, 5)
    local boxStroke = stroke(box, C.faint, 0.3)
    local tick = make("Frame", {
        BackgroundColor3 = C.accentDk, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(8, 8), Parent = box,
    })
    corner(tick, 3)
    local lbl = txt({ Text = spec.text, TextSize = 12, TextColor3 = C.faint, Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -26, 1, 0), Parent = row })

    local on = spec.value == true
    local function paint()
        tween(box, TI(0.14), { BackgroundColor3 = on and C.accent or C.surface2 })
        tween(tick, TI(0.14), { BackgroundTransparency = on and 0 or 1 })
        tween(lbl, TI(0.14), { TextColor3 = on and C.text or C.faint })
        boxStroke.Color = on and C.accent or C.faint
        boxStroke.Transparency = on and 0.2 or 0.3
    end
    paint()

    self:track(row.MouseEnter:Connect(function() if not on then tween(lbl, TI(0.1), { TextColor3 = C.subtext }) end end))
    self:track(row.MouseLeave:Connect(function() if not on then tween(lbl, TI(0.16), { TextColor3 = C.faint }) end end))
    self:track(row.MouseButton1Click:Connect(function()
        local want = not on
        if spec.cb and spec.cb(want) == false then
            lbl.Text = spec.failText or spec.text
            return
        end
        on = want
        lbl.Text = spec.text
        paint()
    end))
end

function Panel:fadeOut(cb)
    self:stopPulse()
    if self.sweepTween then self.sweepTween:Cancel(); self.sweepTween = nil end
    tween(self.scale, TI(0.2), { Scale = 0.96 })
    local t = tween(self.win, TI(0.2), { GroupTransparency = 1 })
    t.Completed:Connect(function() self:destroy(); if cb then cb() end end)
end

function Panel:destroy()
    for _, c in ipairs(self.conns) do pcall(function() c:Disconnect() end) end
    table.clear(self.conns)
    if self.gui then self.gui:Destroy(); self.gui = nil end
end

local panel = Panel.new()

local function copyTo(payload)
    if setclipboard then setclipboard(payload); return true end
    return false
end

local function fail(o)
    panel:stopPulse()
    panel:working(false)
    panel:mode(o.pill or "ERROR", o.color or C.danger)
    panel:icon(o.color or C.danger, o.glyph or "!")
    panel:set({ title = o.title, titleColor = o.color or C.danger, body = o.body })
    panel:option(o.option)
    panel:buttons(o.buttons)
end

local closeBtn = { text = "Close", kind = "ghost", cb = function() panel:destroy() end }
local discordBtn = { text = "Copy Discord", kind = "primary", flash = "Discord copied!", cb = function() return copyTo(DISCORD_URL) end }

local function checkKey()
    initLuarmor()
    if not LuarmorAPI then return true, "NO_SDK" end
    local key = ENV.script_key or _G.script_key or script_key
    if not key or #tostring(key) < 20 then return false, "NO_KEY" end
    local status
    pcall(function() status = LuarmorAPI.check_key(tostring(key)) end)
    if status and status.code == "KEY_VALID" then return true, "KEY_VALID" end
    return false, (status and status.code) or "UNKNOWN"
end

local function fetch(url, bust)
    local target = bust and (url .. "?t=" .. tostring(math.random(1, 1000000))) or url
    local ok, res = pcall(function() return game:HttpGet(target) end)
    if ok and type(res) == "string" and #res > 10 then return res end

    local reqFunc = (type(request) == "function" and request)
        or (type(http_request) == "function" and http_request)
        or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
    if reqFunc then
        local ok2, res2 = pcall(function() return reqFunc({ Url = target, Method = "GET" }) end)
        if ok2 and res2 and res2.Body and #res2.Body > 10 then return res2.Body end
    end
    return nil, tostring(res)
end

local function runScript(url, label, bust)
    panel:set({ status = "Loading " .. label, statusDot = C.accent })
    panel:busy()

    local content, err = fetch(url, bust)
    if not content then
        fail({
            title = "Couldn't reach the servers", pill = "OFFLINE",
            body = "We couldn't fetch " .. label .. ". Check your connection and try again.\n\n" .. tostring(err),
            buttons = {
                { text = "Retry", kind = "primary", cb = function() task.spawn(runScript, url, label, bust) end },
                { text = "Copy Error", kind = "ghost", flash = "Copied!", cb = function() return copyTo(tostring(err)) end },
                closeBtn,
            },
        })
        return
    end

    local fn, parseErr = loadstring(content)
    if not fn then
        fail({
            title = "Couldn't run the script", pill = "ERROR",
            body = "The script loaded but wouldn't compile — usually a temporary build issue. Try again shortly.\n\n" .. tostring(parseErr),
            buttons = {
                { text = "Retry", kind = "primary", cb = function() task.spawn(runScript, url, label, bust) end },
                { text = "Copy Error", kind = "ghost", flash = "Copied!", cb = function() return copyTo(tostring(parseErr)) end },
                closeBtn,
            },
        })
        return
    end

    panel:set({ title = "Ready", body = "Launching " .. label .. ".", status = "Loaded", statusDot = C.accent })
    panel:progress(1)
    task.wait(0.2)
    panel:fadeOut(function() pcall(fn) end)
end

local booting = false
local function boot()
    if booting then return end
    booting = true

    -- clears the warning screen's dressing when we get here from "Continue anyway"
    panel:mode("LOADER", C.faint)
    panel:icon(C.accent)
    panel:option(nil)

    local rawKey  = ENV.script_key or _G.script_key or script_key
    local rawFlag = ENV.inDiscord  or _G.inDiscord  or inDiscord
    local skipNag = truthy(rawFlag) or truthy(rawKey)
    if not skipNag then
        if not panel:nag(60, DISCORD_URL) then return end
    end

    panel:set({ title = "Starting up", body = "Getting Cerberus ready.", status = "Detecting game", statusDot = C.accent })
    panel:busy()
    task.wait(0.35)

    local universeId = tostring(game.GameId)
    local fileName = UNIVERSE_MAP[universeId]

    if not fileName then
        panel:mode("UNIVERSAL", C.amber)
        panel:icon(C.amber, "∞")
        panel:set({
            title = "Universal Mode", titleColor = C.amber,
            body = "This game isn't in the Cerberus catalog yet, so we're loading the universal script instead.",
            status = "Falling back to universal", statusDot = C.amber,
        })
        panel:busy()
        task.wait(1.1)
        runScript(UNIVERSAL_URL, "the Universal script", false)
        return
    end

    local baseFile = fileName
    local gameName = prettify(baseFile)

    local variant = ENV.VARIANT or _G.VARIANT
    if type(variant) == "string" and variant ~= "" then
        fileName = fileName:gsub("%.lua$", "") .. "." .. variant .. ".lua"
    end

    panel:set({ title = gameName, body = "Found a dedicated Cerberus script for this game.", status = "Game detected", statusDot = C.accent })
    panel:progress(0.25)
    task.wait(0.3)

    local isFree = FREE_SCRIPTS[baseFile] == true
    local allowNoKey = truthy(ENV.CERBERUS_ALLOW_NO_KEY or _G.CERBERUS_ALLOW_NO_KEY)

    if isFree then
        panel:mode("FREE", C.accent)
        panel:set({ status = "No key required", statusDot = C.accent })
    elseif allowNoKey then
        panel:mode("NO-KEY", C.amber)
        panel:set({ status = "Key check bypassed", statusDot = C.amber })
    else
        panel:set({ status = "Verifying key" })
        panel:progress(0.45)
        task.wait(0.2)
        local ok, code = checkKey()
        if not ok then
            if code == "NO_KEY" then
                fail({
                    title = "No key found", pill = "NO KEY",
                    body = "We couldn't find a Cerberus key. Grab one from our Discord, then run the script again.\n\nAlready loaded a key? Make sure script_key is set before running the loader.",
                    buttons = { discordBtn, closeBtn },
                })
            else
                fail({
                    title = "Key not valid", pill = "KEY",
                    body = "Your key didn't pass verification (" .. tostring(code) .. "). It may be expired, reset, or for a different plan. Get a fresh one from our Discord.",
                    buttons = {
                        discordBtn,
                        { text = "Copy Code", kind = "ghost", flash = "Copied!", cb = function() return copyTo(tostring(code)) end },
                        closeBtn,
                    },
                })
            end
            return
        end
        panel:set({ status = "Key verified", statusDot = C.accent })
    end

    panel:progress(0.6)
    task.wait(0.2)
    runScript(GITHUB_BASE_URL .. fileName, gameName, true)
end

local function warnUnsupported(name)
    fail({
        title = name .. " isn't supported",
        pill = "UNSUPPORTED",
        body = "Cerberus doesn't work properly on " .. name .. " — it's missing things our scripts need, so features will break or nothing will load.\n\n"
            .. "Copy the link below for executors that do work. Can't pay for one? Hit \"I'm broke\".",
        option = {
            text = "Don't show this again",
            failText = "Couldn't save — this executor can't write files",
            cb = function(want) return setWarningDismissed(want, name) end,
        },
        buttons = {
            { text = "Copy Executor List", kind = "primary", flash = "Link copied!", cb = function() return copyTo(EXECUTORS_URL) end },
            { text = "I'm broke", kind = "ghost", flash = "Link copied!", cb = function() return copyTo(BROKE_URL) end },
            { text = "Continue anyway", kind = "ghost", cb = function() task.spawn(boot) end },
        },
    })
end

task.spawn(function()
    local badExecutor = unsupportedExecutor()
    if badExecutor and not warningDismissed() then
        warnUnsupported(badExecutor)
        return
    end
    boot()
end)
