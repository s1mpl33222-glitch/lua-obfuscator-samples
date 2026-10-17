-- wait for the place to finish initial load before running anything;
-- prevents missing services / unstreamed instances on early-injection.
if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local CollectionService= game:GetService("CollectionService")
local RS               = game:GetService("ReplicatedStorage")
local LocalPlayer      = Players.LocalPlayer
local SellRemote; pcall(function()
    SellRemote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
        and game:GetService("ReplicatedStorage").RemoteEvents:FindFirstChild("PlotService/Sell")
    if not SellRemote then
        -- try direct path
        SellRemote = game:GetService("ReplicatedStorage"):FindFirstChild("PlotService/Sell", true)
    end
end)

local _syncChannel = nil
pcall(function()
    local sync = require(RS.Packages.Synchronizer)
    sync:WaitAndCall(LocalPlayer, function(ch)
        _syncChannel = ch
    end)
end)
local function GetSyncChannel()
    if _syncChannel then return _syncChannel end
    pcall(function() 
        local sync = require(RS.Packages.Synchronizer)
        _syncChannel = sync:GetAllChannels()[LocalPlayer]
    end)
    return _syncChannel
end 

local function GetSafeParent()
    if typeof(gethui)=="function" then
        local ok,h=pcall(gethui); if ok and h then return h end
    end
    local ok2, pg = pcall(function() return LocalPlayer.PlayerGui end)
    if ok2 and pg then return pg end
    return CoreGui
end

-- ── THEME ────────────────────────────────────────────────
local BG      = Color3.fromRGB(128,0,128)  -- Purple inner background
local SURFACE = Color3.fromRGB(90,0,90)
local ACCENT  = Color3.fromRGB(255,215,0)  -- Yellow accent
local YELLOW  = Color3.fromRGB(255,255,0)  -- Bright yellow for border
local BORDER  = Color3.fromRGB(255,255,0)  -- Yellow border
local TEXT    = Color3.fromRGB(255,255,255)
local SUBTEXT = Color3.fromRGB(200,200,200)
local ITEMHOV = Color3.fromRGB(40,32,58)
local ITEMSEL = Color3.fromRGB(70,52,128)
local BTNRED  = Color3.fromRGB(180,50,50)
local BTNGRN  = Color3.fromRGB(50,170,90)

local RARITY_COLORS = {
    Common              = Color3.fromRGB(0,171,40),
    Rare                = Color3.fromRGB(0,131,171),
    Epic                = Color3.fromRGB(134,0,171),
    Legendary           = Color3.fromRGB(251,255,0),
    Mythic              = Color3.fromRGB(255,0,0),
    ["Brainrot God"]    = Color3.fromRGB(255,0,221),
    Secret              = Color3.fromRGB(44,44,44),
    OG                  = BG,
    Taco                = BG,
    Admin               = BG,
    Spooky              = BG,
    Festive             = BG,
    Valentines          = Color3.fromRGB(255,128,255),
    ["St Patrick's"]    = Color3.fromRGB(142,227,63),
    Easter              = Color3.fromRGB(178,132,255),
}

-- ── MUTATION PALETTES (from Datas.Mutations decompile) ───
-- Each palette entry = color for Color attribute index 1..6
local MUTATION_PALETTES = {
    Gold        = {Color3.fromRGB(237,178,0),   Color3.fromRGB(237,194,86), Color3.fromRGB(215,111,1), Color3.fromRGB(139,74,0),   Color3.fromRGB(255,164,164),Color3.fromRGB(255,244,190)},
    Diamond     = {Color3.fromRGB(37,196,254),  Color3.fromRGB(116,212,254),Color3.fromRGB(28,137,254),Color3.fromRGB(21,64,254),  Color3.fromRGB(160,162,254),Color3.fromRGB(176,255,252)},
    Bloodrot    = {Color3.fromRGB(145,0,27),    Color3.fromRGB(154,94,100), Color3.fromRGB(75,0,7),    Color3.fromRGB(72,0,2),     Color3.fromRGB(121,112,112),Color3.fromRGB(255,152,154)},
    Candy       = {Color3.fromRGB(255,105,180), Color3.fromRGB(255,182,193),Color3.fromRGB(200,50,150),Color3.fromRGB(255,20,147), Color3.fromRGB(255,200,220),Color3.fromRGB(255,240,245)},
    Lava        = {Color3.fromRGB(200,50,0),    Color3.fromRGB(255,100,0),  Color3.fromRGB(150,20,0),  Color3.fromRGB(100,10,0),   Color3.fromRGB(255,160,0),  Color3.fromRGB(255,220,100)},
    Galaxy      = {Color3.fromRGB(60,0,120),    Color3.fromRGB(100,0,180),  Color3.fromRGB(30,0,80),   Color3.fromRGB(180,0,255),  Color3.fromRGB(80,0,160),   Color3.fromRGB(200,150,255)},
    YinYang     = {BG, Color3.fromRGB(20,20,28),Color3.fromRGB(230,230,240),     Color3.fromRGB(230,230,240),   Color3.fromRGB(128,128,128),Color3.fromRGB(24,24,30)},
    Radioactive = {Color3.fromRGB(100,255,0),   Color3.fromRGB(150,255,50), Color3.fromRGB(50,200,0),  Color3.fromRGB(0,150,0),    Color3.fromRGB(200,255,100),Color3.fromRGB(230,255,180)},
    Cursed      = {Color3.fromRGB(255,23,23),   Color3.fromRGB(180,0,0),    Color3.fromRGB(120,0,0),   Color3.fromRGB(80,0,0),     Color3.fromRGB(255,100,100),Color3.fromRGB(255,180,180)},
    Divine      = {Color3.fromRGB(255,215,0),   Color3.fromRGB(255,255,200),Color3.fromRGB(200,160,0), Color3.fromRGB(255,240,150),BG,Color3.fromRGB(255,250,220)},
}

-- Mutations that have a MaterialVariant stud in MaterialService
-- Format: mutationName -> stud variant name
local MUTATION_STUDS = {
    Galaxy      = "Galaxy Stud",
    Cursed      = "Cursed Stud",
    Divine      = "Divine Stud",
    Radioactive = "Radioactive Stud",  -- some parts get Radioactive Stud2
    Gold        = "Gold Stud",
    Diamond     = "Diamond",
    Bloodrot    = "Bloodrot",
    Candy       = "Candy",
    Lava        = "Lava",
    YinYang     = "YinYang",
}

-- ── DATA ─────────────────────────────────────────────────
local ANIMALS_BY_RARITY = {
    {rarity="OG",     names={"Skibidi Toilet","Strawberry Elephant","Headless Horseman","Meowl","John Pork"}},
    {rarity="Secret", names={"Kraken","Dragon Aquanini","Dragon Cannelloni","Garama and Madundung","Elefanto Frigo","Signore Carapace","Fragola La La La","Love Love Bear","Hydra Dragon Cannelloni","Tang Tang Keletang","Ketchuru and Musturu","Burguro And Fryuro","La Secret Combinasion","Tictac Sahur","Cerberus","Capitano Moby","Foxini Lanternini","Antonio","Ginger Gerat","Fishino Clownino","Guerriro Digitale","Ginger Globo","Cappuccino Clownino","Griffin","La Supreme Combinasion","Arcadragon","Rosey and Teddy","Hydra Bunny","Ketupat Bros","Tirilikalika Tirilikalako","Pancake and Syrup","Cash or Card","Dragon Gingerini","Globa Steppa","Gym Bros","Money Money Bros","Dug dug dug","Digi Narwhal","Popcuru and Fizzuru","Reinito Sleighito","Los Amigos","Los Sekolahs","Los Spaghettis","Spaghetti Tualetti","Spooky and Pumpky","Ventoliero Pavonero","Quackini Snackini","Sammyni Fattini","Nacho Spyder","Rosetti Tualetti","Lavadorito Spinito","Las Sis","La Casa Boo","Fragrama and Chocrama","Cooki and Milki","Bunny and Eggy","Celestial Pegasus","Chillin Chili","Chipso and Queso","Cloverat Clapat"}},
}
local MUTATIONS = {"None","Gold","Diamond","Bloodrot","Rainbow","Candy","Lava","Galaxy","YinYang","Radioactive","Cursed","Divine","Cyber","Phantom"}

local TRAITS = {
    "Taco","Nyan","Galactic","Fireworks","Zombie","Claws","Glitched","Bubblegum",
    "Fire","Wet","Snowy","Cometstruck","Explosive","Disco","10B","Shark Fin",
    "Matteo Hat","Brazil","Sleepy","Lightning","UFO","Spider","Strawberry","Paint",
    "Skeleton","Sombrero","Tie","Witch Hat","Indonesia","Meowl","John Pork","RIP Gravestone",
    "Jackolantern Pet","Santa Hat","Reindeer Pet","Skibidi","26","Rose",":3",
    "Chocolate","Halo","Lucky","Orange Balloon","Green Balloon","Blue Balloon",
    "Red Balloon","Pink Balloon","Rainbow Balloon","Granny","Bunny Ears",
    "Orange Egg","Green Egg","Blue Egg","Pink Egg",
}

local TRAIT_ICONS = {
    ["Taco"]="rbxassetid://89041930759464",["Nyan"]="rbxassetid://104229924295526",
    ["Galactic"]="rbxassetid://99181785766598",["Fireworks"]="rbxassetid://121100427764858",
    ["Zombie"]="rbxassetid://110723387483939",["Claws"]="rbxassetid://104964195846833",
    ["Glitched"]="rbxassetid://121332433272976",["Bubblegum"]="rbxassetid://100601425541874",
    ["Fire"]="rbxassetid://118283346037788",["Wet"]="rbxassetid://78474194088770",
    ["Snowy"]="rbxassetid://83627475909869",["Cometstruck"]="rbxassetid://127455440418221",
    ["Explosive"]="rbxassetid://97725744252608",["Disco"]="rbxassetid://82620342632406",
    ["10B"]="rbxassetid://134655415681926",["Shark Fin"]="rbxassetid://104985313532149",
    ["Matteo Hat"]="rbxassetid://115664804212096",["Brazil"]="rbxassetid://75650816341229",
    ["Sleepy"]="rbxassetid://115001117876534",["Lightning"]="rbxassetid://139729696247144",
    ["UFO"]="rbxassetid://110910518481052",["Spider"]="rbxassetid://117478971325696",
    ["Strawberry"]="rbxassetid://84731118566493",["Paint"]="rbxassetid://119591742504251",
    ["Skeleton"]="rbxassetid://89591838221335",["Sombrero"]="rbxassetid://95128039793845",
    ["Tie"]="rbxassetid://103610037004911",["Witch Hat"]="rbxassetid://123964048606874",
    ["Indonesia"]="rbxassetid://93350414974589",["Meowl"]="rbxassetid://114748221761549",
    ["John Pork"]="rbxassetid://117176397136731",
    ["RIP Gravestone"]="rbxassetid://123115843719383",["Jackolantern Pet"]="rbxassetid://97054765273857",
    ["Santa Hat"]="rbxassetid://88375043733582",["Reindeer Pet"]="rbxassetid://70894779883038",
    ["Skibidi"]="rbxassetid://83384385019272",["26"]="rbxassetid://80468035315420",
    ["Rose"]="rbxassetid://135489065859287",[":3"]="rbxassetid://108293878529172",
    ["Chocolate"]="rbxassetid://81641382604997",["Halo"]="rbxassetid://98316436141359",
    ["Lucky"]="rbxassetid://124098467754457",["Orange Balloon"]="rbxassetid://83111173051279",
    ["Green Balloon"]="rbxassetid://75222826429094",["Blue Balloon"]="rbxassetid://128841931686463",
    ["Red Balloon"]="rbxassetid://119661964026012",["Pink Balloon"]="rbxassetid://114128099162490",
    ["Rainbow Balloon"]="rbxassetid://112821854659961",["Granny"]="rbxassetid://73467619616299",
    ["Bunny Ears"]="rbxassetid://118516289496954",["Orange Egg"]="rbxassetid://76307362192037",
    ["Green Egg"]="rbxassetid://94602857440295",["Blue Egg"]="rbxassetid://109212886335786",
    ["Pink Egg"]="rbxassetid://133939661230277",
}

-- ── HELPERS ──────────────────────────────────────────────
-- "John Pork" trait reskins any brainrot wearing it to mimic the real game's
-- "John Pork is Calling..." event — the overhead nametag gets a suffix.
-- Accepts either array form {"Galactic","John Pork"} or hash form {[name]=true}.
local function _hasJohnPorkTrait(traits)
    if type(traits) ~= "table" then return false end
    if traits["John Pork"] then return true end
    for _, t in ipairs(traits) do
        if t == "John Pork" then return true end
    end
    return false
end

local function _displayNameFor(name, traits)
    if not name or name == "" then return name end
    if _hasJohnPorkTrait(traits) then
        return name .. " is Calling..."
    end
    return name
end

-- ── Animation sync helpers ───────────────────────────────
-- Brainrot models each load their own AnimationTrack on their Humanoid's
-- Animator at whatever phase the engine loaded them at — so two of the same
-- brainrot end up out-of-sync.  Rather than snap them all back to 0
-- (which makes the animation visibly restart), we anchor every looped
-- track to a shared global clock: target = (tick() - epoch) mod length.
-- Every model converges on the same phase and *stays* there — they advance
-- together naturally instead of resetting.  We only write TimePosition when
-- the drift exceeds ~100ms, so most resync ticks are no-ops (no visible jump).
local _animSyncEpoch = tick()
local _ANIM_SYNC_THRESHOLD = 0.1

local function _syncModelAnimations(model)
    if not model or not model.Parent then return end
    pcall(function()
        local controller = model:FindFirstChildWhichIsA("Humanoid", true)
            or model:FindFirstChildWhichIsA("AnimationController", true)
        if not controller then return end
        local animator = controller:FindFirstChildOfClass("Animator")
        if not animator then return end
        local globalPhase = tick() - _animSyncEpoch
        for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
            if tr.Looped and tr.Length and tr.Length > 0 then
                local target = globalPhase % tr.Length
                local drift  = math.abs(tr.TimePosition - target)
                -- handle wrap-around (e.g. track at 0.05s vs target at 1.95s on a 2s loop)
                if drift > tr.Length * 0.5 then
                    drift = tr.Length - drift
                end
                if drift > _ANIM_SYNC_THRESHOLD then
                    tr.TimePosition = target
                end
            end
        end
    end)
end

local function SafeSet(o,p,v) pcall(function() o[p]=v end) end
local function New(cls,props)
    local ok,obj=pcall(Instance.new,cls)
    if not ok or not obj then return nil end
    if props then for k,v in pairs(props) do SafeSet(obj,k,v) end end
    return obj
end
local function Corner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 6); c.Parent=p; return c
end
local function MakeDraggable(frame,handle)
    handle=handle or frame
    local drag,ds,sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; ds=i.Position; sp=frame.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end
local function SectionHeader(parent,text,yPos)
    New("Frame",{Size=UDim2.new(0,3,0,14),Position=UDim2.new(0,10,0,yPos+2),BackgroundColor3=YELLOW,BorderSizePixel=0,Parent=parent})
    New("TextLabel",{Size=UDim2.new(1,-28,0,18),Position=UDim2.new(0,18,0,yPos),Text=text:upper(),TextColor3=YELLOW,Font=Enum.Font.GothamBold,TextSize=9,BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,Parent=parent})
end

-- ── PLOT HELPERS ─────────────────────────────────────────
-- Plot is pinned once per session: the closest plot at the FIRST spawn becomes
-- "your" plot for everything (spawning, base skins, lasers, prompts, etc.).
-- Without this, walking near another player's plot would silently re-target it.
local _lockedPlot = nil
local function GetPlayerPlot()
    -- If we've already locked onto a plot and it still exists, keep using it.
    if _lockedPlot and _lockedPlot.Parent then return _lockedPlot end
    _lockedPlot = nil  -- plot was destroyed (rejoin?) — re-pin

    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bd = nil, math.huge
    for _, plot in plots:GetChildren() do
        local sp = plot:FindFirstChild("Spawn")
        if sp then
            local d = (sp.Position - hrp.Position).Magnitude
            if d < bd then bd = d; best = plot end
        end
    end
    if best then _lockedPlot = best end
    return best
end

local function GetPodiumSpawns(plot)
    local spawns={}
    -- live structure: plot.AnimalPodiums.[n].Base.Spawn
    local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then return spawns end
    -- sort podiums by name (1,2,3...) so slots are in order
    local podiumList = podiums:GetChildren()
    table.sort(podiumList, function(a,b)
        return tonumber(a.Name) < tonumber(b.Name)
    end)
    for _,podium in ipairs(podiumList) do
        local base=podium:FindFirstChild("Base")
        if base then
            local sp=base:FindFirstChild("Spawn")
            if sp then table.insert(spawns,sp) end
        end
    end
    -- cap slots by rebirth count: rebirth 0=10, rebirth 1=11, etc. up to 27
    local rebirths = 0
    pcall(function()
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        if ls and ls:FindFirstChild("Rebirths") then
            rebirths = ls.Rebirths.Value or 0
        end
    end)
    local maxSlots = math.min(10 + rebirths, #spawns)
    local capped = {}
    for i = 1, maxSlots do capped[i] = spawns[i] end
    return capped
end

-- ── MUTATION APPLICATION ─────────────────────────────────
-- Use game's own Shared.Animals module directly (works from executor in current game version)
local _sharedAnimals = nil
local function GetSharedAnimals()
    if not _sharedAnimals then
        local ok, result = pcall(function() return require(RS.Shared.Animals) end)
        if ok then _sharedAnimals = result end
    end
    return _sharedAnimals
end

local function ApplyMutation(model, animalName, mutName)
    if not mutName or mutName == "None" then return end

    -- Use real game's ApplyMutation (handles all mutations including Cyber)
    local sa = GetSharedAnimals()
    if sa then
        local ok, err = pcall(function() sa:ApplyMutation(model, animalName, mutName) end)
        if ok then return end
        -- if it failed (e.g. VFX not accessible), fall through to manual
        warn("[KV] ApplyMutation fallback for "..mutName..": "..tostring(err))
    end

    -- Manual implementation based on exact Shared.Animals decompile
    local ok, mutData = pcall(function() return require(RS.Datas.Mutations) end)
    if not ok or not mutData or not mutData[mutName] then return end

    local mutInfo    = mutData[mutName]
    local palettes   = mutInfo.Palettes
    local palette    = palettes and palettes[1]
    local mutSurface = RS.MutationSurfaces:FindFirstChild(animalName)
    local vfxFolder  = RS.Vfx:FindFirstChild(mutName)

    -- Rainbow: tag-based, real game's observer handles color cycling
    if mutName == "Rainbow" then
        model:AddTag("RainbowModel")
    else

    -- All non-Rainbow mutations run the palette loop first
    if palette then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local mv  = v.MaterialVariant
                    -- Strawberry studs get renamed to mutation-specific variant
                    if mv == "Strawberry Stud Light" or mv == "Strawberry Stud Dark" then
                        v.MaterialVariant = mutName.." Strawberry Stud Light"
                        return
                    end
                    local colorIdx = tonumber(
                        v:GetAttribute(("%*Color"):format(mutName)) or
                        v:GetAttribute("Color") or 1) or 1
                    colorIdx = math.clamp(colorIdx, 1, #palette)
                    local col = palette[colorIdx] or palette[1]
                    if not col then return end
                    local surfApp = v:FindFirstChildOfClass("SurfaceAppearance")
                    if surfApp then
                        surfApp:Destroy()
                        if mutSurface then
                            local newSurf = mutSurface:Clone()
                            if mutName == "Divine" then
                                newSurf.Color = palette[1] or col
                            else
                                newSurf.Color = col
                            end
                            newSurf.Parent = v
                        end
                    else
                        v.Color = col
                    end
                    if v:GetAttribute("Neon") then
                        v.Material = Enum.Material.Neon
                    end
                end)
            end
        end
    end

    -- Special post-processing per mutation (exact decompile logic)
    if mutName == "Galaxy" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    if (v:GetAttribute("GalaxyColor") or v:GetAttribute("Color") or 1) == 1 then
                        v.Material = Enum.Material.Neon
                    end
                    v.MaterialVariant = "Galaxy Stud"
                end)
            end
        end

    elseif mutName == "Lava" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    if (v:GetAttribute("LavaColor") or v:GetAttribute("Color") or 1) == 1 then
                        v.Material = Enum.Material.Neon
                    end
                end)
            end
        end

    elseif mutName == "YinYang" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("YinYangColor") or v:GetAttribute("Color") or 1
                    if c == 3 or c == 4 then
                        v.Material = Enum.Material.Neon
                    end
                end)
            end
        end

    elseif mutName == "Divine" then
        -- EmissiveStrength on SurfaceAppearances
        local emissive = model:GetAttribute("EmissiveStrength") or 2
        for _, v in model:GetDescendants() do
            if v:IsA("SurfaceAppearance") then
                pcall(function() v.EmissiveStrength = emissive end)
            end
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("DivineColor") or v:GetAttribute("Color") or 1
                    if c == 2 then v.Material = Enum.Material.Neon end
                    -- stud variant
                    local mode = v:GetAttribute("Divine*MaterialMode") or model:GetAttribute("Divine*MaterialMode")
                    if v:GetAttribute("Divine*Stud") == false then
                        v.MaterialVariant = ""
                    elseif v.MaterialVariant == "Custom Stud" or v:GetAttribute("Divine*Stud") == true then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Divine Stud"
                    elseif c ~= 2 and c ~= 6 then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Divine Stud"
                    end
                end)
            end
        end

    elseif mutName == "Radioactive" then
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("RadioactiveColor") or v:GetAttribute("Color") or 1
                    if c == 2 then v.Material = Enum.Material.Neon end
                    if v:GetAttribute("Radioactive*Stud") == false then
                        v.MaterialVariant = ""
                    elseif v.MaterialVariant == "Custom Stud" or v:GetAttribute("Radioactive*Stud") == true then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Radioactive Stud"
                    elseif c ~= 2 and c ~= 6 then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Radioactive Stud"
                    end
                end)
            end
        end

    elseif mutName == "Cursed" then
        -- Remove zombie trait first
        local oldZombie = model:FindFirstChild("_Trait.Zombie")
        if oldZombie then oldZombie:Destroy() end
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c = v:GetAttribute("CursedColor") or v:GetAttribute("Color") or 1
                    if c == 2 then v.Material = Enum.Material.Neon end
                    if v:GetAttribute("Cursed*Stud") == false then
                        v.MaterialVariant = ""
                    elseif v.MaterialVariant == "Custom Stud" or v:GetAttribute("Cursed*Stud") == true or
                           (c ~= 2 and c ~= 6) then
                        v.Material = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Cursed Stud"
                        v.Color = Color3.fromRGB(255, 23, 23)
                    end
                    local sa2 = v:FindFirstChildOfClass("SurfaceAppearance")
                    if sa2 then
                        if not v:GetAttribute("Cursed*IgnoreSurfaceColor") then
                            sa2.Color = Color3.fromRGB(255, 23, 23)
                        end
                        if v:GetAttribute("IgnoreSurface") then sa2:Destroy() end
                    end
                end)
            end
        end
        -- Apply zombie trait in red
        local zombieFolder = RS.Models.TraitsPerAnimal:FindFirstChild("Zombie")
        local zombieModel  = zombieFolder and zombieFolder:FindFirstChild(animalName)
        if zombieModel then
            local clone = zombieModel:Clone()
            clone.Name  = "_Trait.Zombie"
            for _, part in clone:GetChildren() do
                part.Color = Color3.fromRGB(255, 23, 23)
                local att    = part:FindFirstChildOfClass("Attachment")
                local target = att and model:FindFirstChild(att.Name, true)
                if target then
                    local rc = Instance.new("RigidConstraint")
                    rc.Attachment0 = att; rc.Attachment1 = target; rc.Parent = part
                else
                    part:Destroy()
                end
            end
            clone.Parent = model
        end

    elseif mutName == "Cyber" then
        -- Exact decompile: palette already applied above
        -- Now apply Cyber-specific material/transparency overrides
        for _, v in model:GetDescendants() do
            if v:IsA("BasePart") and v.Transparency ~= 1 and not v:GetAttribute("IgnoreColor") then
                pcall(function()
                    local c       = tonumber(v:GetAttribute("Cyber*Color") or v:GetAttribute("Color") or 1) or 1
                    local surfApp = v:FindFirstChildOfClass("SurfaceAppearance")
                    if v:GetAttribute("Eyes") then
                        v.Color        = Color3.fromRGB(62, 155, 255)
                        v.Transparency = 0.25
                        v.Material     = Enum.Material.Neon
                        return
                    end
                    if c == 7 then
                        v.Material = Enum.Material.Neon
                    elseif c == 4 then
                        v.Transparency    = 0.5
                        v.Material        = Enum.Material.SmoothPlastic
                        v.MaterialVariant = "Tech Stud"
                        v.Color           = Color3.fromRGB(62, 155, 255)
                    elseif c == 3 then
                        v.Material     = Enum.Material.Glass
                        v.Transparency = 0.5
                        if not surfApp and v.ClassName == "MeshPart" then
                            Instance.new("SurfaceAppearance").Parent = v
                        end
                    elseif c == 1 then
                        v.Material     = Enum.Material.Glass
                        v.Transparency = 0.25
                        if not surfApp and v.ClassName == "MeshPart" then
                            Instance.new("SurfaceAppearance").Parent = v
                        end
                    end
                    -- SurfaceAppearance: Neon glow
                    surfApp = v:FindFirstChildOfClass("SurfaceAppearance")
                    if surfApp then
                        local vol = v.Size.X * v.Size.Y * v.Size.Z
                        v.Transparency = 0
                        v.Material     = Enum.Material.Neon
                        surfApp.AlphaMode       = Enum.AlphaMode.Overlay
                        surfApp.EmissiveTint    = Color3.fromRGB(255, 255, 255)
                        if vol > 3 then
                            surfApp.Color           = Color3.fromRGB(35, 75, 115)
                            surfApp.EmissiveStrength = 50
                        else
                            surfApp.Color           = Color3.fromRGB(0, 25, 30)
                            surfApp.EmissiveStrength = 25
                        end
                    end
                end)
            end
        end
    end

    end -- end of non-Rainbow mutations

    -- Apply mutation VFX to VfxInstance
    if vfxFolder then
        local vfxInst = model:FindFirstChild("VfxInstance")
        if vfxInst then
            for _, vfx in vfxFolder:GetChildren() do
                pcall(function() vfx:Clone().Parent = vfxInst end)
            end
        end
    end
end

-- ── TRAIT APPLICATION-- ── TRAIT APPLICATION ────────────────────────────────────
local function AttachViaRigidConstraint(clone, model)
    -- match each part's attachments to same-named attachments in model
    for _, part in clone:GetChildren() do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Model") then
            for _, att in part:GetDescendants() do
                if att:IsA("Attachment") then
                    local target = model:FindFirstChild(att.Name, true)
                    if target and target:IsA("Attachment") then
                        local rc = Instance.new("RigidConstraint")
                        rc.Attachment0 = att
                        rc.Attachment1 = target
                        rc.Parent = part
                    end
                end
            end
        end
    end
end

local function ApplyTraits(model, animalName, traitList)
    if not traitList or #traitList == 0 then return end

    -- Try game's SharedAnimals first
    local sa = GetSharedAnimals()
    if sa then
        local ok = pcall(function() sa:ApplyTraits(model, animalName, traitList) end)
        if ok then return end
    end

    local tap      = RS.Models:FindFirstChild("TraitsPerAnimal")
    local modTraits = RS.Models:FindFirstChild("Traits")
    local vfxTraits = RS.Vfx:FindFirstChild("Traits")
    local rootPart  = model.PrimaryPart or model:FindFirstChild("RootPart")

    for _, traitName in ipairs(traitList) do
        pcall(function()
            local applied = false

            -- 1. TraitsPerAnimal.[trait].[animalName] — animal-specific model
            if tap then
                local traitFolder = tap:FindFirstChild(traitName)
                local traitModel = traitFolder and traitFolder:FindFirstChild(animalName)
                if traitModel then
                    local clone = traitModel:Clone()
                    clone.Name = "_Trait."..traitName
                    AttachViaRigidConstraint(clone, model)
                    clone.Parent = model
                    applied = true
                end
            end

            -- 2. Models.Traits.[trait] — generic model for this trait
            if not applied and modTraits then
                local traitModel = modTraits:FindFirstChild(traitName)
                if traitModel then
                    local clone = traitModel:Clone()
                    clone.Name = "_Trait."..traitName
                    AttachViaRigidConstraint(clone, model)
                    clone.Parent = model
                    applied = true
                end
            end

            -- 3. Vfx.Traits.[trait] — VFX only, weld VfxInstance to rootPart
            if not applied and vfxTraits then
                local vfxModel = vfxTraits:FindFirstChild(traitName)
                if vfxModel and rootPart then
                    local clone = vfxModel:Clone()
                    clone.Name = "_Trait."..traitName
                    local vfxPart = clone:FindFirstChild("VfxInstance")
                    if vfxPart then
                        -- try named attachment first, fallback to weld to rootPart
                        local att = vfxPart:FindFirstChildOfClass("Attachment")
                        local targetAtt = att and model:FindFirstChild(att.Name, true)
                        if targetAtt then
                            local rc = Instance.new("RigidConstraint")
                            rc.Attachment0 = att
                            rc.Attachment1 = targetAtt
                            rc.Parent = vfxPart
                        else
                            local weld = Instance.new("Weld")
                            weld.Part0 = rootPart
                            weld.Part1 = vfxPart
                            weld.C0 = CFrame.new(0, 0, 0)
                            weld.Parent = vfxPart
                        end
                    end
                    clone.Parent = model
                end
            end
        end)
    end
end


local ANIMAL_DATA = {
    ["1x1x1x1"] = {gen=1111111,price=255555555},
    ["25"] = {gen=2500000,price=600000000},
    ["67"] = {gen=7500000,price=1250000000},
    ["Agarrini la Palini"] = {gen=425000,price=80000000},
    ["Alessio"] = {gen=85000,price=17500000},
    ["Anpali Babel"] = {gen=280000,price=48000000},
    ["Antonio"] = {gen=55000000,price=12500000000},
    ["Arcadragon"] = {gen=150000000,price=160000000000},
    ["Aquanaut"] = {gen=245000,price=45500000},
    ["Arcadopus"] = {gen=5000000,price=900000000},
    ["Astrolero Cervalero"] = {gen=280000,price=48000000},
    ["Bacuru and Egguru"] = {gen=24000000,price=3850000000},
    ["Ballerina Peppermintina"] = {gen=215000,price=37500000},
    ["Ballerino Lololo"] = {gen=200000,price=35000000},
    ["Bambu Bambu Sahur"] = {gen=275000,price=47500000},
    ["Baskito"] = {gen=16000000,price=2100000000},
    ["Belula Beluga"] = {gen=290000,price=60000000},
    ["Bisonte Giuppitere"] = {gen=325000,price=80000000},
    ["Blackhole Goat"] = {gen=400000,price=75000000},
    ["Boatito Auratito"] = {gen=525000,price=115000000},
    ["Boba Panda"] = {gen=270000,price=47000000},
    ["Bombardini Tortinii"] = {gen=225000,price=50000000},
    ["Boppin Bunny"] = {gen=80000000,price=25000000000},
    ["Brainrot God Lucky Block"] = {gen=0,price=25000000},
    ["Brasilini Berimbini"] = {gen=285000,price=55000000},
    ["Brr es Teh Patipum"] = {gen=225000,price=40000000},
    ["Brunito Marsito"] = {gen=3500000,price=750000000},
    ["Buho de Noelo"] = {gen=267500,price=46750000},
    ["Bulbito Bandito Traktorito"] = {gen=205000,price=35000000},
    ["Bunito Bunito Spinito"] = {gen=3000000,price=900000000},
    ["Bunny Bunny Bunny Sahur"] = {gen=2250000,price=575000000},
    ["Bunny Tralala"] = {gen=270000,price=47000000},
    ["Bunny and Eggy"] = {gen=170000000,price=135000000000},
    ["Bunnyman"] = {gen=1500000,price=500000000},
    ["Buntteo"] = {gen=850000,price=225000000},
    ["Burguro And Fryuro"] = {gen=150000000,price=75000000000},
    ["Burrito Bandito"] = {gen=4000000,price=850000000},
    ["Cacasito Satalito"] = {gen=240000,price=45000000},
    ["Capi Taco"] = {gen=155000,price=31000000},
    ["Capitano Moby"] = {gen=160000000,price=125000000000},
    ["Cappuccino Clownino"] = {gen=285000,price=48500000},
    ["Cash or Card"] = {gen=100000000,price=40000000000},
    ["Celestial Pegasus"] = {gen=175000000,price=150000000000},
    ["Celularcini Viciosini"] = {gen=22500000,price=2750000000},
    ["Cerberus"] = {gen=175000000,price=150000000000},
    ["Chachechi"] = {gen=400000,price=85000000},
    ["Chicleteira Bicicleteira"] = {gen=3500000,price=750000000},
    ["Chicleteira Cupideira"] = {gen=17500000,price=2500000000},
    ["Chicleteira Noelteira"] = {gen=15000000,price=2000000000},
    ["Chicleteirina Bicicleteirina"] = {gen=4000000,price=850000000},
    ["Chihuanini Taconini"] = {gen=45000,price=8500000},
    ["Chill Puppy"] = {gen=4000000,price=850000000},
    ["Chillin Chili"] = {gen=25000000,price=2500000000},
    ["Chimnino"] = {gen=14000000,price=1900000000},
    ["Chipso and Queso"] = {gen=25000000,price=2500000000},
    ["Chrismasmamat"] = {gen=277500,price=47750000},
    ["Churrito Bunnito"] = {gen=21000000,price=2600000000},
    ["Cigno Fulgoro"] = {gen=20000000,price=3000000000},
    ["Cloverat Clapat"] = {gen=60000000,price=15000000000},
    ["Clovkur Kurkur"] = {gen=305000,price=70000000},
    ["Cocoa Assassino"] = {gen=291000,price=61000000},
    ["Cocofanto Elefanto"] = {gen=19000,price=6500000},
    ["Coffin Tung Tung Tung Sahur"] = {gen=0,price=500000000},
    ["Cooki and Milki"] = {gen=155000000,price=100000000000},
    ["Corn Corn Corn Sahur"] = {gen=250000,price=45000000},
    ["Crabbo Limonetta"] = {gen=235000,price=46000000},
    ["Cuadramat and Pakrahmatmamat"] = {gen=1400000,price=400000000},
    ["Cupid Cupid Sahur"] = {gen=3100000,price=715000000},
    ["Cupid Hotspot"] = {gen=3500000,price=750000000},
    ["DJ Panda"] = {gen=17500000,price=2500000000},
    ["Digi Narwhal"] = {gen=200000000,price=200000000000},
    ["Divino Platypio"] = {gen=160000,price=32000000},
    ["Dolphini Jetskini"] = {gen=294500,price=64500000},
    ["Donkeyturbo Express"] = {gen=7500000,price=1250000000},
    ["Dragon Cannelloni"] = {gen=250000000,price=250000000000},
    ["Dragon Gingerini"] = {gen=350000000,price=350000000000},
    ["Dug dug dug"] = {gen=35000000,price=5000000000},
    ["Dul Dul Dul"] = {gen=375000,price=150000000},
    ["Dumborino Miracello"] = {gen=315000,price=75000000},
    ["Easter Easter Easter Sahur"] = {gen=1250000,price=300000000},
    ["Eggdin Egg Egg Dun"] = {gen=310000,price=72500000},
    ["Eid Eid Eid Sahur"] = {gen=3500000,price=750000000},
    ["Elefanto Frigo"] = {gen=85000000,price=12500000000},
    ["Esok Sekolah"] = {gen=30000000,price=3500000000},
    ["Espresso Signora"] = {gen=70000,price=25000000},
    ["Eviledon"] = {gen=31500000,price=3850000000},
    ["Extinct Ballerina"] = {gen=125000,price=23500000},
    ["Extinct Matteo"] = {gen=625000,price=140000000},
    ["Extinct Tralalero"] = {gen=450000,price=125000000},
    ["Festive 67"] = {gen=67000000,price=16000000000},
    ["Fishboard"] = {gen=825000,price=215000000},
    ["Fishino Clownino"] = {gen=47000000,price=9000000000},
    ["Fortunu and Cashuru"] = {gen=130000000,price=55000000000},
    ["Foxini Lanternini"] = {gen=115000000,price=47500000000},
    ["Fragola La La La"] = {gen=450000,price=125000000},
    ["Fragrama and Chocrama"] = {gen=100000000,price=40000000000},
    ["Frankentteo"] = {gen=700000,price=175000000},
    ["Frio Ninja"] = {gen=265000,price=46500000},
    ["GOAT"] = {gen=950000,price=237500000},
    ["Garama and Madundung"] = {gen=50000000,price=10000000000},
    ["Gattatino Nyanino"] = {gen=35000,price=7500000},
    ["Gattito Tacoto"] = {gen=165000,price=32500000},
    ["Giftini Spyderini"] = {gen=999999,price=240000000},
    ["Ginger Cisterna"] = {gen=293500,price=63500000},
    ["Ginger Gerat"] = {gen=75000000,price=22500000000},
    ["Ginger Globo"] = {gen=257500,price=45750000},
    ["Girafa Celestre"] = {gen=20000,price=7500000},
    ["Globa Steppa"] = {gen=27500000,price=3000000000},
    ["Gobblino Uniciclino"] = {gen=27500000,price=2850000000},
    ["Gold Egg"] = {gen=0,price=0},
    ["Gold Elf"] = {gen=0,price=0},
    ["Gold Gold Gold"] = {gen=45000000,price=8000000000},
    ["Graipuss Medussi"] = {gen=1000000,price=250000000},
    ["Granchiello Spiritell"] = {gen=260000,price=46000000},
    ["Granny"] = {gen=4000000,price=850000000},
    ["Griffin"] = {gen=400000000,price=400000000000},
    ["Guerriro Digitale"] = {gen=550000,price=120000000},
    ["Guest 666"] = {gen=6666666,price=1166666666},
    ["Gym Bros"] = {gen=42500000,price=7500000000},
    ["Headless Horseman"] = {gen=550000000,price=550000000000},
    ["Ho Ho Ho Sahur"] = {gen=3250000,price=725000000},
    ["Hopilikalika Hopilikalako"] = {gen=55000000,price=12500000000},
    ["Horegini Boom"] = {gen=2750000,price=650000000},
    ["Hydra Bunny"] = {gen=185000000,price=175000000000},
    ["Hydra Dragon Cannelloni"] = {gen=300000000,price=300000000000},
    ["Jacko Jack Jack"] = {gen=150000,price=30000000},
    ["Jackorilla"] = {gen=315000,price=80000000},
    ["Job Job Job Sahur"] = {gen=700000,price=175000000},
    ["Jolly Jolly Sahur"] = {gen=45000000,price=8000000000},
    ["Karker Sahur"] = {gen=725000,price=185000000},
    ["Karkerheart Luvkur"] = {gen=297500,price=67500000},
    ["Karkerkar Kurkur"] = {gen=325000,price=80000000},
    ["Ketchuru and Musturu"] = {gen=42500000,price=7500000000},
    ["Ketupat Bros"] = {gen=145000000,price=65000000000},
    ["Ketupat Kepat"] = {gen=35000000,price=5000000000},
    ["Krupuk Pagi Pagi"] = {gen=290000,price=60000000},
    ["La Casa Boo"] = {gen=100000000,price=40000000000},
    ["La Cucaracha"] = {gen=475000,price=110000000},
    ["La Easter Grande"] = {gen=55000000,price=12500000000},
    ["La Extinct Grande"] = {gen=23500000,price=3250000000},
    ["La Food Combinasion"] = {gen=90000000,price=30000000000},
    ["La Ginger Sekolah"] = {gen=75000000,price=23000000000},
    ["La Grande Combinasion"] = {gen=10000000,price=1000000000},
    ["La Jolly Grande"] = {gen=30000000,price=3500000000},
    ["La Karkerkar Combinasion"] = {gen=600000,price=160000000},
    ["La Lucky Grande"] = {gen=40000000,price=7000000000},
    ["La Romantic Grande"] = {gen=40000000,price=7000000000},
    ["La Sahur Combinasion"] = {gen=2000000,price=550000000},
    ["La Secret Combinasion"] = {gen=125000000,price=50000000000},
    ["La Spooky Grande"] = {gen=24500000,price=2900000000},
    ["La Supreme Combinasion"] = {gen=200000000,price=200000000000},
    ["La Taco Combinasion"] = {gen=35000000,price=5000000000},
    ["La Vacca Jacko Linterino"] = {gen=850000,price=225000000},
    ["La Vacca Lepre Lepreino"] = {gen=1100000,price=255000000},
    ["La Vacca Prese Presente"] = {gen=600000,price=160000000},
    ["La Vacca Saturno Saturnita"] = {gen=325000,price=80000000},
    ["Las Capuchinas"] = {gen=185000,price=32500000},
    ["Las Sis"] = {gen=17500000,price=2500000000},
    ["Las Tralaleritas"] = {gen=650000,price=150000000},
    ["Las Vaquitas Saturnitas"] = {gen=750000,price=200000000},
    ["Lavadorito Spinito"] = {gen=45000000,price=8000000000},
    ["List List List Sahur"] = {gen=2000000,price=550000000},
    ["Los 25"] = {gen=10000000,price=1500000000},
    ["Los 67"] = {gen=22500000,price=2750000000},
    ["Los Amigos"] = {gen=130000000,price=55000000000},
    ["Los Bombinitos"] = {gen=220000,price=42500000},
    ["Los Bros"] = {gen=24000000,price=2600000000},
    ["Los Bunitos"] = {gen=4250000,price=865000000},
    ["Los Burritos"] = {gen=8500000,price=1400000000},
    ["Los Candies"] = {gen=23000000,price=3000000000},
    ["Los Chicleteiras"] = {gen=7000000,price=1200000000},
    ["Los Chihuaninis"] = {gen=160000,price=32000000},
    ["Los Combinasionas"] = {gen=15000000,price=2000000000},
    ["Los Crocodillitos"] = {gen=55000,price=12500000},
    ["Los Cucarachas"] = {gen=1250000,price=300000000},
    ["Los Cupids"] = {gen=30000000,price=3500000000},
    ["Los Gattitos"] = {gen=275000,price=47500000},
    ["Los Hotspotsitos"] = {gen=20000000,price=3000000000},
    ["Los Jobcitos"] = {gen=1500000,price=500000000},
    ["Los Jolly Combinasionas"] = {gen=20000000,price=3000000000},
    ["Los Karkeritos"] = {gen=750000,price=200000000},
    ["Los Matteos"] = {gen=325000,price=80000000},
    ["Los Mi Gatitos"] = {gen=6500000,price=1250000000},
    ["Los Mobilis"] = {gen=22000000,price=2700000000},
    ["Los Nooo My Hotspotsitos"] = {gen=5500000,price=1000000000},
    ["Los Orcalitos"] = {gen=235000,price=45000000},
    ["Los Planitos"] = {gen=18500000,price=2750000000},
    ["Los Primos"] = {gen=31000000,price=3750000000},
    ["Los Puggies"] = {gen=30000000,price=3000000000},
    ["Los Quesadillas"] = {gen=4500000,price=875000000},
    ["Los Sekolahs"] = {gen=110000000,price=45000000000},
    ["Los Spaghettis"] = {gen=70000000,price=20000000000},
    ["Los Spooky Combinasionas"] = {gen=20000000,price=3000000000},
    ["Los Spyderinis"] = {gen=425000,price=125000000},
    ["Los Sweethearts"] = {gen=16500000,price=2250000000},
    ["Los Tacoritas"] = {gen=32000000,price=4000000000},
    ["Los Tipi Tacos"] = {gen=260000,price=46000000},
    ["Los Tortus"] = {gen=500000,price=100000000},
    ["Los Tralaleritos"] = {gen=500000,price=100000000},
    ["Los Trios"] = {gen=700000,price=175000000},
    ["Los Tungtungtungcitos"] = {gen=210000,price=37500000},
    ["Love Love Bear"] = {gen=225000000,price=225000000000},
    ["Love Love Love Sahur"] = {gen=1000000,price=250000000},
    ["Lovin Rose"] = {gen=32500000,price=4250000000},
    ["Luck Luck Luck Sahur"] = {gen=3750000,price=800000000},
    ["Luv Luv Luv"] = {gen=282500,price=48250000},
    ["Mariachi Corazoni"] = {gen=12500000,price=1750000000},
    ["Mastodontico Telepiedone"] = {gen=275000,price=47500000},
    ["Matteo"] = {gen=50000,price=10000000},
    ["Meowl"] = {gen=600000000,price=600000000000},
    ["John Pork"] = {gen=500000000,price=650000000000},
    ["Mi Gatito"] = {gen=3250000,price=725000000},
    ["Mieteteira Bicicleteira"] = {gen=26000000,price=2750000000},
    ["Money Money Bros"] = {gen=47000000,price=9000000000},
    ["Money Money Man"] = {gen=65000,price=17500000},
    ["Money Money Puggy"] = {gen=21000000,price=2600000000},
    ["Money Money Reindeer"] = {gen=25000000,price=2500000000},
    ["Mummy Ambalabu"] = {gen=250000,price=45000000},
    ["Nacho Spyder"] = {gen=50000000,price=10000000000},
    ["Naughty Naughty"] = {gen=3000000,price=700000000},
    ["Noo La Polizia"] = {gen=280000,price=67000000},
    ["Noo my Candy"] = {gen=5000000,price=900000000},
    ["Noo my Eggs"] = {gen=7000000,price=1200000000},
    ["Noo my Gold"] = {gen=13500000,price=1850000000},
    ["Noo my Heart"] = {gen=13000000,price=1800000000},
    ["Noo my Present"] = {gen=6000000,price=1100000000},
    ["Noo my examine"] = {gen=1750000,price=525000000},
    ["Nooo My Hotspot"] = {gen=1500000,price=500000000},
    ["Nuclearo Dinossauro"] = {gen=15000000,price=2500000000},
    ["Odin Din Din Dun"] = {gen=75000,price=15000000},
    ["Orcaledon"] = {gen=40000000,price=7000000000},
    ["Orcalero Orcala"] = {gen=100000,price=25000000},
    ["Orcalita Orcala"] = {gen=240000,price=45000000},
    ["Pakrahmatmamat"] = {gen=215000,price=37500000},
    ["Pakrahmatmatina"] = {gen=225000,price=40500000},
    ["Pancake and Syrup"] = {gen=125000000,price=50000000000},
    ["Pandanini Frostini"] = {gen=294000,price=64000000},
    ["Paradiso Axolottino"] = {gen=900000,price=235000000},
    ["Patteo"] = {gen=287500,price=57500000},
    ["Perrito Burrito"] = {gen=1000000,price=250000000},
    ["Piccione Macchina"] = {gen=225000,price=40000000},
    ["Piccionetta Macchina"] = {gen=270000,price=47000000},
    ["Pirulitoita Bicicleteira"] = {gen=2500000,price=600000000},
    ["Please my Present"] = {gen=1300000,price=350000000},
    ["Pop Pop Sahur"] = {gen=295000,price=65000000},
    ["Popcuru and Fizzuru"] = {gen=170000000,price=135000000000},
    ["Pot Hotspot"] = {gen=2500000,price=600000000},
    ["Pot Pumpkin"] = {gen=3000000,price=700000000},
    ["Pumpkini Spyderini"] = {gen=650000,price=165000000},
    ["Quackini Snackini"] = {gen=65000000,price=15500000000},
    ["Quesadilla Crocodila"] = {gen=3000000,price=700000000},
    ["Quesadillo Vampiro"] = {gen=3500000,price=750000000},
    ["Rang Ring Bus"] = {gen=6000000,price=1100000000},
    ["Reindeer Tralala"] = {gen=600000,price=160000000},
    ["Reinito Sleighito"] = {gen=140000000,price=60000000000},
    ["Rocco Disco"] = {gen=650000,price=150000000},
    ["Rosetti Tualetti"] = {gen=50000000,price=10000000000},
    ["Rosey and Teddy"] = {gen=165000000,price=130000000000},
    ["Sammyni Fattini"] = {gen=70000000,price=20000000000},
    ["Sammyni Spyderini"] = {gen=325000,price=75000000},
    ["Santa Hotspot"] = {gen=2600000,price=625000000},
    ["Santteo"] = {gen=800000,price=210000000},
    ["Secret Lucky Block"] = {gen=0,price=750000000},
    ["Serafinna Medusella"] = {gen=5500000,price=1000000000},
    ["Signore Carapace"] = {gen=105000000,price=42500000000},
    ["Skibidi Toilet"] = {gen=450000000,price=450000000000},
    ["Skull Skull Skull"] = {gen=290000,price=60000000},
    ["Snailenzo"] = {gen=250000,price=45000000},
    ["Snailo Clovero"] = {gen=18500000,price=2750000000},
    ["Spaghetti Tualetti"] = {gen=60000000,price=15000000000},
    ["Spinny Hammy"] = {gen=17000000,price=2300000000},
    ["Spooky and Pumpky"] = {gen=80000000,price=25000000000},
    ["Squalanana"] = {gen=250000,price=45000000},
    ["Strawberry Elephant"] = {gen=750000000,price=750000000000},
    ["Swag Soda"] = {gen=13000000,price=1800000000},
    ["Swaggy Bros"] = {gen=40000000,price=7000000000},
    ["Tacorillo Crocodillo"] = {gen=12500000,price=1500000000},
    ["Tacorita Bicicleta"] = {gen=16500000,price=2250000000},
    ["Tang Tang Keletang"] = {gen=33500000,price=4500000000},
    ["Tartaruga Cisterna"] = {gen=250000,price=45000000},
    ["Telemorte"] = {gen=2000000,price=550000000},
    ["Tentacolo Tecnico"] = {gen=292500,price=62500000},
    ["Tictac Sahur"] = {gen=37500000,price=6000000000},
    ["Tigroligre Frutonni"] = {gen=60000,price=14000000},
    ["Tipi Topi Taco"] = {gen=75000,price=20000000},
    ["Tirilikalika Tirilikalako"] = {gen=42500000,price=7500000000},
    ["To to to Sahur"] = {gen=2250000,price=575000000},
    ["Tootini Shrimpini"] = {gen=260000,price=46000000},
    ["Torrtuginni Dragonfrutini"] = {gen=350000,price=125000000},
    ["Tractoro Dinosauro"] = {gen=230000,price=42500000},
    ["Tralaledon"] = {gen=27500000,price=3000000000},
    ["Tralalero Tralala"] = {gen=50000,price=10000000},
    ["Tralalita Tralala"] = {gen=100000,price=20000000},
    ["Trenostruzzo Turbo 3000"] = {gen=150000,price=25000000},
    ["Trenostruzzo Turbo 4000"] = {gen=335000,price=90000000},
    ["Trickolino"] = {gen=900000,price=235000000},
    ["Triplito Tralaleritos"] = {gen=875000,price=230000000},
    ["Trippi Troppi Troppa Trippa"] = {gen=175000,price=30000000},
    ["Tuff Toucan"] = {gen=26000000,price=2750000000},
    ["Tukanno Bananno"] = {gen=100000,price=22500000},
    ["Tung Tung Tung Sahur"] = {gen=1500000,price=500000000},
    ["Unclito Samito"] = {gen=75000,price=20000000},
    ["Urubini Flamenguini"] = {gen=150000,price=30000000},
    ["Vampira Cappucina"] = {gen=125000,price=24500000},
    ["Ventoliero Pavonero"] = {gen=65000000,price=15500000000},
    ["Vulturino Skeletono"] = {gen=500000,price=110000000},
    ["W or L"] = {gen=30000000,price=3000000000},
    ["Yess my examine"] = {gen=575000,price=130000000},
    ["Yeti Claus"] = {gen=257500,price=45750000},
    ["Zombie Tralala"] = {gen=500000,price=100000000},
    ["Dragon Aquanini"] = {gen=375000000,price=375000000000},
    ["Kraken"] = {gen=200000000,price=200000000000}
}

-- ── STATE ────────────────────────────────────────────────
local selectedAnimal   = nil
local selectedMutation = "None"
local selectedTraits   = {}
local _multiSelectMode = false
local _multiSelected   = {}  -- { [animalName] = true }
local spawnedModels    = {}
local modelCashpads    = {} -- model -> {cashPart, cashConn} for cleanup on move
local slotPromptConns  = {} -- slotIndex -> {conn1, conn2} prompt connections to disconnect on respawn
-- Offline earnings: tracks how much each restored model accumulated while the
-- player was away. Computed once at script load from (gen/sec * elapsed * 0.5),
-- capped at 5 hours. Cleared when the player steps onto that model's cashpad.
local _offlineSeconds  = 0
local _modelOfflineCash = {}  -- model -> number (unclaimed offline cash)
local _pendingOfflineCash = 0 -- set BEFORE DoSpawn during restore so the cashpad picks it up
local modelOverheads   = {} -- model -> overhead part in workspace.Debris
local modelSnapshots   = {} -- model -> {mutation, traits} at spawn time
local modelPromptInfo  = {} -- model -> {att=promptAtt, slot=slotIndex}

-- ── CONFIG / PERSISTENCE ─────────────────────────────────
-- save the list of currently-spawned brainrots to disk so the same set can
-- be restored on next script run. all data is purely client-side visual.
local CONFIG_FILE = "KingVisuals_spawns.json"
local INDEX_FILE  = "KingVisuals_index.json"
local _hs = game:GetService("HttpService")
local _indexDiscoveries = {} -- { [animalName] = { "None", "Gold", ... } }
--// KV FIX: robust animal/model lookup + safe spawn helpers
local function _kvCleanName(s)
    return tostring(s or ""):lower():gsub("%s+", ""):gsub("[^%w]", "")
end

local function FindAnimalModel(animalName)
    if not animalName or animalName == "" then
        warn("[KV FIX] No animal selected")
        return nil
    end

    local wanted = _kvCleanName(animalName)
    local function checkFolder(folder)
        if not folder then return nil end
        local exact = folder:FindFirstChild(animalName)
        if exact and exact:IsA("Model") then return exact end
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") and _kvCleanName(obj.Name) == wanted then
                if obj.Name ~= animalName then
                    warn("[KV FIX] Animal name mismatch fixed:", animalName, "->", obj.Name)
                end
                return obj
            end
        end
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") then
                local attrName = obj:GetAttribute("DisplayName") or obj:GetAttribute("Index") or obj:GetAttribute("AnimalName") or obj:GetAttribute("Name")
                if attrName and _kvCleanName(attrName) == wanted then
                    warn("[KV FIX] Animal attribute match fixed:", animalName, "->", obj.Name)
                    return obj
                end
            end
        end
        return nil
    end

    -- Main real template folder.
    local models = RS:FindFirstChild("Models") or RS:WaitForChild("Models", 3)
    local animals = models and (models:FindFirstChild("Animals") or models:WaitForChild("Animals", 3))
    local found = checkFolder(animals)
    if found then return found end

    -- Wait a tiny bit in case ReplicatedStorage is still filling in.
    local timeout = os.clock() + 0.45
    while os.clock() < timeout do
        task.wait(0.1)
        found = checkFolder(animals)
        if found then return found end
    end

    -- Fallback: search ReplicatedStorage for a model with that exact name, but avoid trait/VFX folders.
    local roots = {models, RS}
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and (_kvCleanName(obj.Name) == wanted) then
                    local path = obj:GetFullName():lower()
                    if not path:find("traitsperanimal", 1, true)
                    and not path:find(".traits", 1, true)
                    and not path:find(".vfx", 1, true)
                    and not path:find("animations", 1, true) then
                        warn("[KV FIX] Found animal outside Models.Animals:", animalName, "->", obj:GetFullName())
                        return obj
                    end
                end
            end
        end
    end

    warn("[KV FIX] Animal model not found:", animalName)
    if animals then
        local sample = {}
        for _, obj in ipairs(animals:GetChildren()) do
            if #sample < 25 then table.insert(sample, obj.Name) end
        end
        warn("[KV FIX] Models.Animals has", #animals:GetChildren(), "models. Sample:", table.concat(sample, ", "))
    else
        warn("[KV FIX] Missing ReplicatedStorage.Models.Animals")
    end
    return nil
end

local function FindAnimalAnimationFolder(animalName)
    local animRoot = RS:FindFirstChild("Animations")
        and RS.Animations:FindFirstChild("Animals")
    if not animRoot then return nil end
    local exact = animRoot:FindFirstChild(animalName)
    if exact then return exact end
    local wanted = _kvCleanName(animalName)
    for _, obj in ipairs(animRoot:GetChildren()) do
        if _kvCleanName(obj.Name) == wanted then return obj end
    end
    return nil
end


local _kvAnimalDataCache = nil
local function _kvGetAnimalData()
    if _kvAnimalDataCache ~= nil then return _kvAnimalDataCache end
    _kvAnimalDataCache = false
    pcall(function()
        local datas = RS:FindFirstChild("Datas")
        local animalsMod = datas and datas:FindFirstChild("Animals")
        if animalsMod then
            local t = require(animalsMod)
            if type(t) == "table" then _kvAnimalDataCache = t end
        end
    end)
    return _kvAnimalDataCache
end

local function _kvGetAnimalRarity(animalName)
    local data = _kvGetAnimalData()
    local row = data and data[animalName]
    if type(row) == "table" and row.Rarity then
        return tostring(row.Rarity)
    end
    for _, g in ipairs(ANIMALS_BY_RARITY) do
        for _, n in ipairs(g.names) do
            if n == animalName then return g.rarity end
        end
    end
    return "Common"
end

local function _kvModelNameSet()
    local set = {}
    local models = RS:FindFirstChild("Models")
    local animals = models and models:FindFirstChild("Animals")
    if animals then
        for _, obj in ipairs(animals:GetChildren()) do
            if obj:IsA("Model") or obj:IsA("Folder") then
                set[obj.Name] = true
            end
        end
    end
    return set
end

local function GetAnimalGroupsForUI()
    local set = _kvModelNameSet()
    local data = _kvGetAnimalData()

    -- If templates exist, build the UI from the REAL models only.
    -- This stops the menu showing animals that will print "model not found" when clicked.
    local names = {}
    if next(set) ~= nil then
        for name in pairs(set) do
            table.insert(names, name)
        end
    elseif type(data) == "table" then
        for name in pairs(data) do
            table.insert(names, name)
        end
    else
        -- emergency fallback to the old hardcoded list
        for _, g in ipairs(ANIMALS_BY_RARITY) do
            for _, name in ipairs(g.names) do table.insert(names, name) end
        end
    end

    table.sort(names, function(a, b) return a:lower() < b:lower() end)

    local byRarity = {}
    for _, name in ipairs(names) do
        local rarity = _kvGetAnimalRarity(name)
        if not byRarity[rarity] then byRarity[rarity] = {rarity = rarity, names = {}} end
        table.insert(byRarity[rarity].names, name)
    end

    local rarityOrder = {
        OG=1, Secret=2, ["Brainrot God"]=3, Mythic=4, Legendary=5,
        Epic=6, Rare=7, Common=8, Taco=9, Admin=10, Spooky=11,
        Festive=12, Valentines=13, ["St Patrick's"]=14, Easter=15,
    }
    local groups = {}
    for _, g in pairs(byRarity) do table.insert(groups, g) end
    table.sort(groups, function(a, b)
        local oa = rarityOrder[a.rarity] or 99
        local ob = rarityOrder[b.rarity] or 99
        if oa == ob then return a.rarity < b.rarity end
        return oa < ob
    end)
    return groups
end

local function IsServerPodOccupied(podData)
    if podData == nil or podData == "" or podData == "Empty" then return false end
    if type(podData) == "string" then return true end
    if type(podData) == "table" then
        local index = podData.Index or podData.Name or podData.Animal or podData.DisplayName
        return index ~= nil and index ~= "" and index ~= "Empty"
    end
    return false
end

local function IsLocalSlotOccupied(spawnPart)
    if not spawnPart then return false end
    for _, m in ipairs(spawnedModels) do
        if m and m.Parent then
            local ok, pivot = pcall(function() return m:GetPivot() end)
            if ok and pivot and (pivot.Position - spawnPart.Position).Magnitude < 5 then
                return true
            end
        end
    end
    return false
end

local function PrepareSpawnedModel(model)
    if not model then return nil end

    local root = model.PrimaryPart
        or model:FindFirstChild("RootPart", true)
        or model:FindFirstChild("HumanoidRootPart", true)
        or model:FindFirstChildWhichIsA("BasePart", true)

    if root and root:IsA("BasePart") then
        pcall(function() model.PrimaryPart = root end)
    end

    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
            v.Massless = true
            v.AssemblyLinearVelocity = Vector3.zero
            v.AssemblyAngularVelocity = Vector3.zero
            -- Keep the root still, but leave the rest free so Motor6D animations can play.
            v.Anchored = (root ~= nil and v == root)
        end
    end

    return root
end


--// KV V11: official podium renderer path.
-- The tagged Animal anchor uses the road/moving-animal renderer, which makes
-- flying/huge brainrots like Dragon Cannelloni and Headless Horseman sit wrong.
-- This creates a normal animated brainrot model and places it exactly like the
-- game's PlotModel renderer does: pivot to the podium Spawn and anchor only the
-- PrimaryPart. No custom ground fitting, no shrink-down.
local _kvSharedAnimalsForBuild = nil
local function _kvGetSharedAnimalsForBuild()
    if _kvSharedAnimalsForBuild ~= nil then return _kvSharedAnimalsForBuild end
    _kvSharedAnimalsForBuild = false
    pcall(function()
        local shared = RS:FindFirstChild("Shared")
        local mod = shared and shared:FindFirstChild("Animals")
        if mod then
            local result = require(mod)
            if result then _kvSharedAnimalsForBuild = result end
        end
    end)
    return _kvSharedAnimalsForBuild
end

local function _kvCreateAnimatedAnimalModel(animalName)
    local shared = _kvGetSharedAnimalsForBuild()
    if not shared then return nil end

    local model

    -- Support both real method style and decompiler dot-call style.
    pcall(function()
        if type(shared.GetAnimatedModel) == "function" then
            model = shared:GetAnimatedModel(animalName, "Idle")
        end
    end)
    if not model then
        pcall(function()
            if type(shared.GetAnimatedModel) == "function" then
                model = shared.GetAnimatedModel(shared, animalName, "Idle")
            end
        end)
    end
    if not model then
        pcall(function()
            if type(shared.GetAnimatedModel) == "function" then
                model = shared.GetAnimatedModel(nil, animalName, "Idle")
            end
        end)
    end

    if model and model:IsA("Model") then
        model.Name = tostring(animalName)
        return model
    end

    return nil
end

local function _kvBuildDirectAnimalModel(animalName, template)
    local model

    if template and template:IsA("Model") then
        model = template:Clone()
        model.Name = tostring(animalName)
    else
        model = _kvCreateAnimatedAnimalModel(animalName)
    end

    if not model or not model:IsA("Model") then
        return nil
    end

    if not model.PrimaryPart then
        local pp = model:FindFirstChild("RootPart", true)
            or model:FindFirstChild("FakeRootPart", true)
            or model:FindFirstChild("HumanoidRootPart", true)
            or model:FindFirstChildWhichIsA("BasePart", true)
        if pp then
            pcall(function() model.PrimaryPart = pp end)
        end
    end

    local root = model.PrimaryPart
    if not root then
        model:Destroy()
        return nil
    end

    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Massless = true
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
            part.Anchored = (part == root)
        end
    end

    return model
end

local function _kvOfficialPodiumPivot(spawnPart)
    local pivot = spawnPart:GetPivot()
    local _, ry, _ = pivot:ToEulerAnglesYXZ()
    return CFrame.new(pivot.Position) * CFrame.Angles(0, ry, 0)
end

local function _kvPlaceDirectAnimalOnPodium(model, spawnPart)
    if not model or not spawnPart then return end
    local cf = _kvOfficialPodiumPivot(spawnPart)
    pcall(function() model:PivotTo(cf) end)
    if model.PrimaryPart then
        model.PrimaryPart.Anchored = true
    end
end

--// END KV FIX

--// KV V3: game-renderer fallback. Some published/streaming builds keep
--// ReplicatedStorage.Models.Animals empty on the client. In that case we
--// spawn the same invisible tagged anchor the real game uses, and let the
--// game's Animal controller render the brainrot from Index/Mutation/Traits.
local function _kvEncodeTraits(traitsArr)
    if type(traitsArr) ~= "table" or #traitsArr == 0 then return nil end
    local ok, encoded = pcall(function() return _hs:JSONEncode(traitsArr) end)
    return ok and encoded or "[]"
end

local function CreateAnimalAnchorModel(animalName, mutationName, traitsArr, spawnPart)
    -- KV V11: use the real renderer's anchor style: a cloned podium Spawn PART
    -- with the Animal tag. The rest of this script still needs a Model handle
    -- for prompts/swap/save logic, so the tagged Spawn part lives inside an
    -- invisible wrapper Model with PrimaryPart set to that part.
    local wrapper = Instance.new("Model")
    wrapper.Name = tostring(animalName or "Animal")

    local anchor
    if spawnPart and spawnPart:IsA("BasePart") then
        anchor = spawnPart:Clone()
    else
        anchor = Instance.new("Part")
        anchor.Size = Vector3.new(4, 1, 4)
        anchor.CFrame = spawnPart and spawnPart:GetPivot() or CFrame.new()
    end

    anchor.Name = "Spawn"
    anchor.Anchored = true
    anchor.Transparency = 1
    anchor.CanCollide = false
    anchor.CanQuery = false
    anchor.CanTouch = false
    anchor.Massless = true

    for _, d in ipairs(anchor:GetDescendants()) do
        if d:IsA("BasePart") then
            d.Transparency = 1
            d.Anchored = true
            d.CanCollide = false
            d.CanQuery = false
            d.CanTouch = false
            d.Massless = true
        end
    end

    if spawnPart then
        pcall(function() anchor:PivotTo(spawnPart:GetPivot()) end)
        if anchor:IsA("BasePart") and spawnPart:IsA("BasePart") then
            anchor.CFrame = spawnPart.CFrame
            anchor.Size = spawnPart.Size
        end
    end

    anchor.Parent = wrapper
    wrapper.PrimaryPart = anchor

    local spawnId = tostring(tick()) .. "_" .. tostring(math.random(100000, 999999))

    local function setAnimalAttrs(obj)
        obj:SetAttribute("Index", animalName)
        if mutationName and mutationName ~= "" and mutationName ~= "None" then
            obj:SetAttribute("Mutation", mutationName)
        else
            obj:SetAttribute("Mutation", nil)
        end
        local traitsJson = _kvEncodeTraits(traitsArr)
        if traitsJson then obj:SetAttribute("Traits", traitsJson) else obj:SetAttribute("Traits", nil) end
        obj:SetAttribute("ForceIdle", true)
        obj:SetAttribute("KVSpawned", true)
        obj:SetAttribute("KVAnchorRenderer", true)
        obj:SetAttribute("KVSpawnId", spawnId)
    end

    setAnimalAttrs(wrapper)
    setAnimalAttrs(anchor)

    wrapper.Parent = workspace

    -- Only the Spawn part gets tagged as Animal. Tagging the wrapper model is
    -- what made the renderer calculate bad offsets on huge/flying brainrots.
    pcall(function() anchor:AddTag("Animal") end)
    pcall(function() CollectionService:AddTag(anchor, "Animal") end)

    return wrapper
end

local function FindRenderedAnimalModel(animalName)
    local wanted = _kvCleanName(animalName)
    local best
    local searchRoots = {
        workspace:FindFirstChild("RenderedMovingAnimals"),
        workspace:FindFirstChild("MovingAnimals"),
        workspace:FindFirstChild("Plots"),
        workspace,
    }
    for _, root in ipairs(searchRoots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and not obj:GetAttribute("KVAnchorRenderer") then
                    local idx = obj:GetAttribute("Index") or obj:GetAttribute("DisplayName") or obj:GetAttribute("AnimalName")
                    if _kvCleanName(obj.Name) == wanted or (idx and _kvCleanName(idx) == wanted) then
                        local hasVisiblePart = false
                        for _, bp in ipairs(obj:GetDescendants()) do
                            if bp:IsA("BasePart") and bp.Transparency < 0.98 then
                                hasVisiblePart = true
                                break
                            end
                        end
                        if hasVisiblePart then
                            best = obj
                            break
                        end
                    end
                end
            end
        end
        if best then break end
    end
    return best
end



--// KV V11: natural-size podium placement.
--// Keeps the visible body centered/on the pad without scaling the animal down.
--// Also ignores obvious VFX/overhead/base parts when measuring bounds.
local KV_TARGET_BODY_HEIGHT = 8.25
local KV_TARGET_FOOTPRINT   = 6.15

local function _kvIsVisibleAnimalPart(bp)
    if not bp or not bp:IsA("BasePart") then return false end
    if bp.Transparency >= 0.98 or bp.Size.Magnitude <= 0 then return false end

    local n = bp.Name
    local ln = n:lower()

    if n == "RootPart" or n == "HumanoidRootPart" or n == "FakeRootPart" or n == "VfxInstance" then
        return false
    end

    -- Do not let invisible helpers / overhead text / collection pad pieces count
    -- as the animal's body. Those were what made some labels sit in the middle.
    if ln:find("overhead") or ln:find("hitbox") or ln:find("prompt") or ln:find("cash") then
        return false
    end
    if ln:find("spawn") or ln:find("pad") or ln:find("base") or ln:find("collect") then
        if bp.Size.X > 4 or bp.Size.Z > 4 then return false end
    end
    if ln:find("shadow") or ln:find("beam") or ln:find("light") or ln:find("spot") then
        return false
    end

    return true
end

local function _kvBoundsFromFilter(model, filterFn)
    if not model then return nil end

    local minX, maxX = math.huge, -math.huge
    local minY, maxY = math.huge, -math.huge
    local minZ, maxZ = math.huge, -math.huge
    local count = 0

    for _, bp in ipairs(model:GetDescendants()) do
        if filterFn(bp) then
            local sx, sy, sz = bp.Size.X * 0.5, bp.Size.Y * 0.5, bp.Size.Z * 0.5
            for _, x in ipairs({-sx, sx}) do
                for _, y in ipairs({-sy, sy}) do
                    for _, z in ipairs({-sz, sz}) do
                        local p = bp.CFrame:PointToWorldSpace(Vector3.new(x, y, z))
                        if p.X < minX then minX = p.X end
                        if p.X > maxX then maxX = p.X end
                        if p.Y < minY then minY = p.Y end
                        if p.Y > maxY then maxY = p.Y end
                        if p.Z < minZ then minZ = p.Z end
                        if p.Z > maxZ then maxZ = p.Z end
                    end
                end
            end
            count += 1
        end
    end

    if count <= 0 or minY == math.huge or maxY == -math.huge then return nil end

    local size = Vector3.new(math.max(0.1, maxX - minX), math.max(0.1, maxY - minY), math.max(0.1, maxZ - minZ))
    return {
        center = Vector3.new((minX + maxX) * 0.5, (minY + maxY) * 0.5, (minZ + maxZ) * 0.5),
        minX = minX, maxX = maxX,
        minY = minY, maxY = maxY,
        minZ = minZ, maxZ = maxZ,
        height = math.max(1, maxY - minY),
        footprint = math.max(size.X, size.Z),
        partCount = count,
    }
end

local function _kvVisibleBounds(model)
    return _kvBoundsFromFilter(model, _kvIsVisibleAnimalPart)
end

local function _kvIsSolidBodyPart(bp)
    if not _kvIsVisibleAnimalPart(bp) then return false end

    local ln = bp.Name:lower()

    -- Effects/auras/glow parts can hang under the animal and trick the script
    -- into thinking the feet are already on the pad. Ignore those for placement.
    if ln:find("vfx") or ln:find("effect") or ln:find("aura") or ln:find("glow") or
       ln:find("spark") or ln:find("particle") or ln:find("trail") or ln:find("beam") or
       ln:find("ring") or ln:find("orb") or ln:find("fire") or ln:find("flame") or
       ln:find("smoke") or ln:find("cloud") or ln:find("slash") or ln:find("swirl") then
        return false
    end

    -- If this part is just a holder for emitters/lights, it is not body geometry.
    if bp:FindFirstChildWhichIsA("ParticleEmitter", true) or
       bp:FindFirstChildWhichIsA("Beam", true) or
       bp:FindFirstChildWhichIsA("Trail", true) or
       bp:FindFirstChildWhichIsA("PointLight", true) or
       bp:FindFirstChildWhichIsA("SpotLight", true) or
       bp:FindFirstChildWhichIsA("SurfaceLight", true) then
        return false
    end

    -- Most floating VFX are neon/forcefield/glass. Keep them out of the foot/body
    -- bounds, but we still fall back to visible bounds if an animal is all neon.
    if bp.Material == Enum.Material.Neon or
       bp.Material == Enum.Material.ForceField or
       bp.Material == Enum.Material.Glass then
        return false
    end

    return true
end

local function _kvBodyBounds(model)
    local solid = _kvBoundsFromFilter(model, _kvIsSolidBodyPart)
    if solid and solid.partCount >= 3 then
        return solid
    end
    return _kvVisibleBounds(model)
end

local function _kvXZDist(a, b)
    if not a or not b then return math.huge end
    return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
end

local function FindRenderedAnimalModelNear(animalName, nearPos, maxDist)
    local wanted = _kvCleanName(animalName)
    maxDist = maxDist or 18
    local best, bestScore = nil, math.huge
    local loose, looseScore, looseCount = nil, math.huge, 0

    local searchRoots = {
        workspace:FindFirstChild("RenderedMovingAnimals"),
        workspace:FindFirstChild("MovingAnimals"),
        workspace:FindFirstChild("Plots"),
        workspace,
    }

    for _, root in ipairs(searchRoots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and obj.Parent and not obj:GetAttribute("KVAnchorRenderer") then
                    if not (LocalPlayer.Character and obj == LocalPlayer.Character) then
                        local b = _kvVisibleBounds(obj)
                        if b and b.partCount >= 1 and b.footprint <= 60 and b.height <= 140 then
                            local d = nearPos and _kvXZDist(b.center, nearPos) or 0
                            if d <= maxDist then
                                local idx = obj:GetAttribute("Index") or obj:GetAttribute("DisplayName") or obj:GetAttribute("AnimalName")
                                local nameOk = (_kvCleanName(obj.Name) == wanted) or (idx and _kvCleanName(idx) == wanted)

                                local yPenalty = nearPos and math.abs(b.center.Y - nearPos.Y) * 0.04 or 0
                                local score = d + yPenalty

                                if nameOk and score < bestScore then
                                    best, bestScore = obj, score
                                elseif not nameOk and d <= 5.5 and (root.Name == "RenderedMovingAnimals" or root.Name == "MovingAnimals") then
                                    looseCount += 1
                                    if score < looseScore then
                                        loose, looseScore = obj, score
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Only use a loose fallback if it is the only nearby rendered candidate.
    -- This avoids grabbing a real animal from another podium.
    if best then return best end
    if looseCount == 1 then return loose end
    return nil
end

local function _kvGetVisualModel(model, animalName, spawnPart)
    if not model then return nil end
    if model:GetAttribute("KVAnchorRenderer") then
        local nearPos = (spawnPart and spawnPart.Position) or model:GetPivot().Position
        return FindRenderedAnimalModelNear(animalName or model.Name, nearPos, 20) or FindRenderedAnimalModel(animalName or model.Name) or model
    end
    return model
end

local function _kvShiftModel(model, delta)
    if not model or not model.Parent or not delta then return end
    pcall(function()
        model:PivotTo(model:GetPivot() + delta)
    end)
end

local function _kvCurrentScale(model)
    local ok, sc = pcall(function() return model:GetScale() end)
    if ok and type(sc) == "number" and sc > 0 then return sc end
    return 1
end

local function _kvScaleModel(model, newScale)
    if not model or not model.Parent or not newScale or newScale <= 0 then return false end
    local ok = pcall(function()
        model:ScaleTo(newScale)
    end)
    return ok
end

local function _kvFitVisualToPodium(visual, spawnPart)
    -- KV V11: Do NOT resize the brainrot body.
    -- V6/V7 shrank big animals like Headless Horseman too much. The real game
    -- already gives each animal the correct natural size, so this function now
    -- only exists as a no-op to keep the rest of the placement code compatible.
    return false
end

local function _kvMoveToPad(model, visual, spawnPart, animalName)
    if not model or not model.Parent or not spawnPart then return false end

    visual = visual or _kvGetVisualModel(model, animalName or model.Name, spawnPart)

    -- KV V11: align using solid body/feet, not auras or VFX under the body.
    local b = _kvBodyBounds(visual)
    if not b then return false end

    local padTop = spawnPart.Position.Y + (spawnPart.Size.Y * 0.5)
    local targetPos = Vector3.new(spawnPart.Position.X, padTop + 0.06, spawnPart.Position.Z)

    local dx = spawnPart.Position.X - b.center.X
    local dz = spawnPart.Position.Z - b.center.Z
    local dy = targetPos.Y - b.minY

    if math.abs(dx) <= 0.025 then dx = 0 end
    if math.abs(dz) <= 0.025 then dz = 0 end
    if math.abs(dy) <= 0.035 then dy = 0 end

    if math.abs(dx) > 80 or math.abs(dy) > 120 or math.abs(dz) > 80 then
        return false
    end

    local delta = Vector3.new(dx, dy, dz)
    if delta.Magnitude <= 0.02 then return true end

    -- Move the invisible anchor. The game renderer may follow this.
    _kvShiftModel(model, delta)

    -- Also move the actual visible rendered model, BUT only when it is not
    -- already inside the invisible anchor. If it is a child/descendant of the
    -- anchor, moving both causes double movement and makes big brainrots float.
    if visual and visual ~= model and visual.Parent and not visual:IsDescendantOf(model) then
        _kvShiftModel(visual, delta)
    end

    return true
end

local function PlaceModelOnSpawnPad(model, spawnPart, animalName)
    if not model or not spawnPart then return end
    pcall(function() model:PivotTo(spawnPart:GetPivot()) end)
    _kvMoveToPad(model, nil, spawnPart, animalName or model.Name)
end

local function AlignModelToSpawnPad(model, spawnPart, animalName)
    if not model or not model.Parent or not spawnPart then return end
    _kvMoveToPad(model, nil, spawnPart, animalName or model.Name)
end

local function SchedulePadAlignment(model, spawnPart, animalName)
    local delays = {0, 0.03, 0.08, 0.15, 0.3, 0.55, 0.85, 1.2, 1.7, 2.3, 3.1, 4.2, 5.5, 7.0, 9.0}
    for _, delayTime in ipairs(delays) do
        task.delay(delayTime, function()
            AlignModelToSpawnPad(model, spawnPart, animalName)
        end)
    end
end

--// KV V12: stable overhead position.
--// Headless shifted sideways because the pumpkin/head VFX changed the visual
--// bounds center. Dragon labels disappeared because flame/VFX pushed the label
--// into the ceiling. Use the podium center for X/Z and solid body bounds for Y.
local function GetModelOverheadPosition(model, animalName, spawnPart, fallbackY)
    if not model or not model.Parent then
        return nil
    end

    local visual = _kvGetVisualModel(model, animalName or model.Name, spawnPart)
    local bodyBounds = _kvBodyBounds(visual)
    local visibleBounds = _kvVisibleBounds(visual)
    local b = bodyBounds or visibleBounds

    local basePos
    if spawnPart and spawnPart:IsA("BasePart") then
        basePos = spawnPart.Position
    else
        local ok, pivot = pcall(function() return model:GetPivot() end)
        basePos = ok and pivot.Position or (b and b.center) or Vector3.zero
    end

    if b then
        local padTop = basePos.Y
        if spawnPart and spawnPart:IsA("BasePart") then
            padTop = spawnPart.Position.Y + (spawnPart.Size.Y * 0.5)
        end

        local animalLower = tostring(animalName or model.Name or ""):lower()
        local isDragon = animalLower:find("dragon cannelloni", 1, true) ~= nil
        local isHeadless = animalLower:find("headless horseman", 1, true) ~= nil

        -- Use body height, not fire/aura height. This keeps dragon/large VFX
        -- labels visible instead of sending them into the roof.
        local h = math.max(3, b.height or 4)
        local extra = math.clamp(h * 0.13, 1.2, 2.25)
        local minAbovePad = 4.8
        local maxAbovePad = math.clamp(h * 0.82, 6.5, 12.5)

        -- Dragons need the label a lot higher so the fire breath does not cover
        -- the name block. Headless also needs a small lift so the pumpkin and
        -- shoulder VFX do not crowd the text.
        if isDragon then
            -- V17: move Dragon Cannelloni text lower so it sits under the
            -- top surface/ceiling line but still above the dragon's fire/VFX.
            extra = extra + math.clamp(h * 0.04, 0.35, 0.75)
            minAbovePad = 5.2
            maxAbovePad = math.max(maxAbovePad, 11.6)
        elseif isHeadless then
            extra = extra + 0.6
            minAbovePad = 6.0
            maxAbovePad = math.max(maxAbovePad, 13.0)
        end

        local y = b.maxY + extra

        -- If VFX or weird bounds still push it insanely high, pull it back to
        -- a normal podium-label height. Never put it below the animal's body.
        local saneMax = padTop + maxAbovePad
        if y > saneMax then
            y = saneMax
        end
        y = math.max(y, padTop + minAbovePad)

        -- X/Z stay locked to the podium so Headless pumpkin offsets, dragons'
        -- long bodies, and side accessories don't drag the name sideways.
        return Vector3.new(basePos.X, y, basePos.Z)
    end

    local safeY = math.max(6.5, (fallbackY or 4) * 1.2)
    return basePos + Vector3.new(0, safeY, 0)
end


local function _loadIndexFile()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    if not isfile(INDEX_FILE) then return end
    local ok, data = pcall(function() return _hs:JSONDecode(readfile(INDEX_FILE)) end)
    if not ok or type(data) ~= "table" then return end
    -- migrate old format: { [name] = "mutation" } -> { [name] = { "mutation" } }
    for k, v in pairs(data) do
        if type(v) == "string" then
            data[k] = { v }
        end
    end
    _indexDiscoveries = data
end

local function _saveIndexFile()
    if type(writefile) ~= "function" then return end
    pcall(function() writefile(INDEX_FILE, _hs:JSONEncode(_indexDiscoveries)) end)
end

local function _hasDiscovery(animalName, mutation)
    local list = _indexDiscoveries[animalName]
    if not list then return false end
    for _, m in ipairs(list) do
        if m == mutation then return true end
    end
    return false
end

local function _addDiscovery(animalName, mutation)
    if _hasDiscovery(animalName, mutation) then return false end
    if not _indexDiscoveries[animalName] then
        _indexDiscoveries[animalName] = {}
    end
    table.insert(_indexDiscoveries[animalName], mutation)
    _saveIndexFile()
    return true
end

-- ── INDEX UI INJECTION ──────────────────────────────────────
-- Path: PlayerGui.Index.Index.Main.Content.Holder.List.[AnimalName]
-- Cards are ImageLabels. Discovered = NameLabel.Visible true.
-- Undiscovered = NameLabel.Visible false, dark silhouette image.
-- Tab buttons: Index.Index.Main.Mutations.[Default|Gold|Diamond|Rainbow|Cyber]
-- Counter: Index.Index.Main.Header.Total  text = "47/429"
-- Progress: Index.Index.Progress (Frame with bar + text)

local _activeIndexTab = "Default"
local _indexTabHooked = false
local _lastSyncTab = nil

-- Fallback hex colors if Datas.Mutations isn't readable
local MUTATION_HEX_FALLBACK = {
    Gold    = "FFDE59",
    Diamond = "25C4FE",
    Rainbow = "FF6496",
    Cyber   = "3E9BFF",
}

local _mutHexCache = {}
local function _getMutationHex(mutName)
    if _mutHexCache[mutName] then return _mutHexCache[mutName] end
    -- Try to pull MainColor from the game's Datas.Mutations module first
    local hex
    pcall(function()
        local md = require(RS.Datas.Mutations)[mutName]     
        if md and md.MainColor then
            local c = md.MainColor
            hex = string.format("%02X%02X%02X",
                math.floor(c.R * 255 + 0.5),
                math.floor(c.G * 255 + 0.5),
                math.floor(c.B * 255 + 0.5))
        end
    end)
    hex = hex or MUTATION_HEX_FALLBACK[mutName]
    if hex then _mutHexCache[mutName] = hex end
    return hex
end

local function _formatMutLabel(mutName)
    if not mutName or mutName == "" or mutName == "None" or mutName == "Default" then
        return "Default", false
    end
    local hex = _getMutationHex(mutName)
    if hex then
        return string.format('<font color="#%s">%s</font>', hex, mutName), true
    end
    return mutName, false
end

local function _getIndexParts()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local indexSG = pg:FindFirstChild("Index")
    if not indexSG then return nil end
    local indexFrame = indexSG:FindFirstChild("Index")
    if not indexFrame then return nil end
    local main = indexFrame:FindFirstChild("Main")
    if not main then return nil end
    return {
        list = main:FindFirstChild("Content")
            and main.Content:FindFirstChild("Holder")
            and main.Content.Holder:FindFirstChild("List"),
        mutations = main:FindFirstChild("Mutations"),
        total = main:FindFirstChild("Header")
            and main.Header:FindFirstChild("Total"),
        progress = indexFrame:FindFirstChild("Progress"),
    }
end

local _syncIndex -- forward decl
local function _hookTabButtons(parts)
    if _indexTabHooked or not parts.mutations then return end
    for _, btn in parts.mutations:GetChildren() do
        if btn:IsA("TextButton") then
            btn.Activated:Connect(function()
                if _activeIndexTab == btn.Name then
                    -- Same tab clicked — don't force cleanup, just refresh
                    task.defer(function() if _syncIndex then _syncIndex() end end)
                    return
                end
                _activeIndexTab = btn.Name
                _lastSyncTab = nil
                task.defer(function() if _syncIndex then _syncIndex() end end)
                task.delay(0.1, function() if _syncIndex then _syncIndex() end end)
            end)
        end
    end
    _indexTabHooked = true
end

local function _getActiveMut()
    return (_activeIndexTab == "Default") and "None" or _activeIndexTab
end

local function _isCardRealDiscovery(card)
    if card:GetAttribute("KVIndexed") then return false end
    local nl = card:FindFirstChild("NameLabel")
    return nl and nl:IsA("TextLabel") and nl.Visible == true
end

local function _revertCard(card)
    if not card or not card:GetAttribute("KVIndexed") then return end
    pcall(function()
        -- Remove only OUR added ViewportFrame (one we created had Name="ViewportFrame" via our code)
        -- but the game ALSO has a ViewportFrame on undiscovered cards. We track ours via attribute.
        for _, child in card:GetChildren() do
            if child:IsA("ViewportFrame") and child:GetAttribute("KVOwned") then
                child:Destroy()
            end
        end
        -- Restore a stored original game ViewportFrame visibility if we hid it
        local origVpName = card:GetAttribute("KVOrigVpName")
        if origVpName then
            local origVp = card:FindFirstChild(origVpName)
            if origVp and origVp:IsA("ViewportFrame") then
                origVp.Visible = true
            end
        end

        card.ImageTransparency = card:GetAttribute("KVOrigImgTrans") or 0

        local nl = card:FindFirstChild("NameLabel")
        if nl and nl:IsA("TextLabel") then
            local v = card:GetAttribute("KVOrigNameVis")
            nl.Visible = (v == true)
            local t = card:GetAttribute("KVOrigNameText")
            if t then nl.Text = t end
            local c = card:GetAttribute("KVOrigNameColor")
            if c then nl.TextColor3 = c end
        end

        local ml = card:FindFirstChild("MutationLabel")
        if ml and ml:IsA("TextLabel") then
            local t = card:GetAttribute("KVOrigMutText")
            if t then ml.Text = t end
            local r = card:GetAttribute("KVOrigMutRich")
            if r ~= nil then ml.RichText = r end
            local c = card:GetAttribute("KVOrigMutColor")
            if c then ml.TextColor3 = c end
        end

        local rl = card:FindFirstChild("RarityLabel")
        if rl and rl:IsA("TextLabel") then
            local c = card:GetAttribute("KVOrigRarColor")
            if c then rl.TextColor3 = c end
        end

        card:SetAttribute("KVIndexed", nil)
        card:SetAttribute("KVIndexMut", nil)
        card:SetAttribute("KVOrigNameVis", nil)
        card:SetAttribute("KVOrigNameText", nil)
        card:SetAttribute("KVOrigNameColor", nil)
        card:SetAttribute("KVOrigMutText", nil)
        card:SetAttribute("KVOrigMutRich", nil)
        card:SetAttribute("KVOrigMutColor", nil)
        card:SetAttribute("KVOrigRarColor", nil)
        card:SetAttribute("KVOrigImgTrans", nil)
        card:SetAttribute("KVOrigVpName", nil)
    end)
end

local function _lightUpCard(card, animalName, mutationName)
    if not card then return end
    pcall(function()
        local newMut = (mutationName and mutationName ~= "None") and mutationName or ""

        if _isCardRealDiscovery(card) then return end

        if card:GetAttribute("KVIndexed") and (card:GetAttribute("KVIndexMut") or "") == newMut then return end

        local nl = card:FindFirstChild("NameLabel")
        local ml = card:FindFirstChild("MutationLabel")

        local rl = card:FindFirstChild("RarityLabel")

        -- On first injection, snapshot original game state so we can fully restore later
        if not card:GetAttribute("KVIndexed") then
            card:SetAttribute("KVOrigImgTrans", card.ImageTransparency)
            if nl and nl:IsA("TextLabel") then
                card:SetAttribute("KVOrigNameVis", nl.Visible)
                card:SetAttribute("KVOrigNameText", nl.Text)
                card:SetAttribute("KVOrigNameColor", nl.TextColor3)
            end
            if ml and ml:IsA("TextLabel") then
                card:SetAttribute("KVOrigMutText", ml.Text)
                card:SetAttribute("KVOrigMutRich", ml.RichText)
                card:SetAttribute("KVOrigMutColor", ml.TextColor3)
            end
            if rl and rl:IsA("TextLabel") then
                card:SetAttribute("KVOrigRarColor", rl.TextColor3)
            end
            -- Hide the game's pre-existing ViewportFrame (the dark silhouette) instead of destroying it
            for _, child in card:GetChildren() do
                if child:IsA("ViewportFrame") and not child:GetAttribute("KVOwned") then
                    card:SetAttribute("KVOrigVpName", child.Name)
                    child.Visible = false
                    break
                end
            end
        end

        -- Always destroy any of OUR previous viewport frames (e.g. when re-injecting with different mutation)
        for _, child in card:GetChildren() do
            if child:IsA("ViewportFrame") and child:GetAttribute("KVOwned") then
                child:Destroy()
            end
        end

        card.ImageTransparency = 1

        if nl and nl:IsA("TextLabel") then
            nl.Text = animalName
            nl.Visible = true
            nl.TextTransparency = 0
            nl.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        if ml and ml:IsA("TextLabel") then
            local txt, isRich = _formatMutLabel(newMut ~= "" and newMut or "Default")
            if isRich then ml.RichText = true end
            ml.Text = txt
            ml.Visible = true
            ml.TextTransparency = 0
            ml.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        if rl and rl:IsA("TextLabel") then
            rl.Visible = true
            rl.TextTransparency = 0
            rl.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        local modelTemplate = RS.Models.Animals:FindFirstChild(animalName)
        if not modelTemplate then
            card:SetAttribute("KVIndexed", true)
            card:SetAttribute("KVIndexMut", newMut)
            return
        end

        local vp = Instance.new("ViewportFrame")
        vp.Size = UDim2.new(1, 0, 1, 0)
        vp.Position = UDim2.new(0, 0, 0, 0)
        vp.BackgroundTransparency = 1
        vp.Name = "KVViewport"
        vp.ZIndex = 0
        vp:SetAttribute("KVOwned", true)
        vp.Parent = card

        local sa = GetSharedAnimals()
        local usedSA = false
        if sa and sa.AttachOnViewportWithOptimizations then
            local ok = pcall(function()
                sa:AttachOnViewportWithOptimizations(
                    animalName, vp, nil,
                    newMut ~= "" and newMut or nil
                )
            end)
            usedSA = ok
        end

        if not usedSA then
            local cam = Instance.new("Camera")
            cam.FieldOfView = 50
            cam.Parent = vp
            vp.CurrentCamera = cam

            local wm = Instance.new("WorldModel")
            wm.Parent = vp

            local clone = modelTemplate:Clone()
            if newMut ~= "" then
                pcall(ApplyMutation, clone, animalName, mutationName)
            end
            for _, p in clone:GetDescendants() do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                    p.CanQuery = false
                    p.CanTouch = false
                    p.Anchored = true
                end
            end
            clone:PivotTo(CFrame.new(0, 0, 0))
            clone.Parent = wm

            local ext = clone:GetExtentsSize()
            local maxDim = math.max(ext.X, ext.Y, ext.Z)
            local dist = (maxDim * 0.5 / math.tan(math.rad(25))) * 0.75
            local lookAt = clone.PrimaryPart and clone.PrimaryPart.CFrame or CFrame.new(0, 0, 0)
            cam.CFrame = CFrame.new(
                (lookAt * CFrame.new(Vector3.new(-1, 0.25, -1).Unit * (dist + maxDim * 0.5))).Position,
                lookAt.Position
            )

            task.defer(function()
                pcall(function()
                    local af = RS.Animations.Animals:FindFirstChild(animalName)
                    local ia = af and af:FindFirstChild("Idle")
                    if ia then
                        local ac = clone:FindFirstChildOfClass("AnimationController")
                            or clone:FindFirstChildWhichIsA("AnimationController", true)
                        if not ac then
                            ac = Instance.new("AnimationController")
                            ac.Parent = clone
                        end
                        local anim = ac:FindFirstChildOfClass("Animator")
                        if not anim then
                            anim = Instance.new("Animator", ac)
                        end
                        task.wait()
                        local tr = anim:LoadAnimation(ia)
                        tr.Looped = true
                        tr:Play(0)
                    end
                end)
            end)
        end

        card:SetAttribute("KVIndexed", true)
        card:SetAttribute("KVIndexMut", newMut)
    end)
end

local function _updateCounters(parts, kvCount)
    pcall(function()
        if not parts.total then return end
        local tabChanged = _lastSyncTab ~= _activeIndexTab
        if tabChanged then
            _lastSyncTab = _activeIndexTab
        end

        local curText = parts.total.Text
        local realNum, maxNum

        if tabChanged or not parts.total:GetAttribute("KVOrigTotal") then
            local r, m = curText:match("^(%d+)/(%d+)$")
            if r and m then
                parts.total:SetAttribute("KVOrigTotal", curText)
                realNum = tonumber(r)
                maxNum = tonumber(m)
            end
        else
            local orig = parts.total:GetAttribute("KVOrigTotal") or curText
            local r, m = orig:match("^(%d+)/(%d+)$")
            if r and m then
                realNum = tonumber(r)
                maxNum = tonumber(m)
            end
        end

        if realNum and maxNum then
            local spoofed = realNum + kvCount
            parts.total.Text = tostring(spoofed) .. "/" .. tostring(maxNum)

            if parts.progress then
                for _, desc in parts.progress:GetDescendants() do
                    if desc:IsA("TextLabel") then
                        local pr, pm = desc.Text:match("^(%d+)/(%d+)$")
                        if pr and pm then
                            if tabChanged or not desc:GetAttribute("KVOrigProgress") then
                                desc:SetAttribute("KVOrigProgress", desc.Text)
                            end
                            local origP = desc:GetAttribute("KVOrigProgress")
                            local opr, opm = origP:match("^(%d+)/(%d+)$")
                            if opr and opm then
                                desc.Text = tostring(tonumber(opr) + kvCount) .. "/" .. opm
                            end
                        end
                    end
                end
            end
        end
    end)
end

function _syncIndex()
    local parts = _getIndexParts()
    if not parts or not parts.list then return end

    _hookTabButtons(parts)

    local activeMut = _getActiveMut()
    local tabChanged = _lastSyncTab ~= _activeIndexTab

    if tabChanged then
        for _, card in parts.list:GetChildren() do
            if card:IsA("ImageLabel") and card.Name ~= "Template" and card:GetAttribute("KVIndexed") then
                pcall(function()
                    -- Destroy only OUR viewport frames; leave game-owned ones alone
                    for _, child in card:GetChildren() do
                        if child:IsA("ViewportFrame") and child:GetAttribute("KVOwned") then
                            child:Destroy()
                        end
                    end
                    -- Re-show the game's original ViewportFrame if we hid it
                    local origVpName = card:GetAttribute("KVOrigVpName")
                    if origVpName then
                        local origVp = card:FindFirstChild(origVpName)
                        if origVp and origVp:IsA("ViewportFrame") then
                            origVp.Visible = true
                        end
                    end
                    card.ImageTransparency = card:GetAttribute("KVOrigImgTrans") or 0
                    -- Don't touch labels here — the game has updated them for the new tab.
                    card:SetAttribute("KVIndexed", nil)
                    card:SetAttribute("KVIndexMut", nil)
                    card:SetAttribute("KVOrigNameVis", nil)
                    card:SetAttribute("KVOrigNameText", nil)
                    card:SetAttribute("KVOrigNameColor", nil)
                    card:SetAttribute("KVOrigMutText", nil)
                    card:SetAttribute("KVOrigMutRich", nil)
                    card:SetAttribute("KVOrigMutColor", nil)
                    card:SetAttribute("KVOrigRarColor", nil)
                    card:SetAttribute("KVOrigImgTrans", nil)
                    card:SetAttribute("KVOrigVpName", nil)
                end)
            end
        end
        task.wait()
    end

    -- Count fakes from our data structure, not from the visible cards.
    -- This makes the counter update immediately even if the card hasn't
    -- been scrolled to / created yet, and even if we skipped injection
    -- because of a real-discovery overlap.
    local kvCount = 0
    for animalName, mutList in pairs(_indexDiscoveries) do
        for _, m in ipairs(mutList) do
            if m == activeMut then
                kvCount = kvCount + 1
                break
            end
        end
    end

    for _, card in parts.list:GetChildren() do
        if card:IsA("ImageLabel") and card.Name ~= "Template" then
            local name = card.Name

            if _isCardRealDiscovery(card) then
                -- leave real discoveries completely alone
            elseif _hasDiscovery(name, activeMut) then
                pcall(_lightUpCard, card, name, activeMut)
            elseif card:GetAttribute("KVIndexed") then
                pcall(_revertCard, card)
            end
        end
    end

    _updateCounters(parts, kvCount)
end

local function InjectToGameIndex(animalName, mutationName)
    local mut = mutationName or "None"
    _addDiscovery(animalName, mut)
    task.defer(_syncIndex)
end

_loadIndexFile()
task.spawn(_syncIndex)

task.spawn(function()
    while true do
        task.wait(0.25)
        pcall(_syncIndex)
    end
end)

-- Hook the Index GUI so we immediately sync the moment it becomes visible.
-- This way, even if a player opens the index right after spawning many fakes,
-- everything is already lit up when they look at it (no popping-in).
task.spawn(function()
    local hookedIndex = nil
    local function hookIndexSG(indexSG)
        if hookedIndex == indexSG then return end
        hookedIndex = indexSG
        -- Run sync whenever the SG becomes enabled OR a descendant changes.
        indexSG:GetPropertyChangedSignal("Enabled"):Connect(function()
            if indexSG.Enabled then
                for i = 1, 6 do
                    task.delay(i * 0.05, function() pcall(_syncIndex) end)
                end
            end
        end)
        -- Some games toggle the inner frame's Visible instead of the SG's Enabled
        local inner = indexSG:FindFirstChild("Index")
        if inner then
            inner:GetPropertyChangedSignal("Visible"):Connect(function()
                if inner.Visible then
                    for i = 1, 6 do
                        task.delay(i * 0.05, function() pcall(_syncIndex) end)
                    end
                end
            end)
        end
        -- Re-sync whenever new cards are added (game may lazy-create them)
        indexSG.DescendantAdded:Connect(function(d)
            if d:IsA("ImageLabel") then
                task.defer(function() pcall(_syncIndex) end)
            end
        end)
    end

    while true do
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local indexSG = pg and pg:FindFirstChild("Index")
        if indexSG then hookIndexSG(indexSG) end
        task.wait(1)
    end
end)

local autoRestoreEnabled = true   -- toggled from Misc tab; default on
local autoSaveEnabled    = true   -- toggled from Misc tab; default on
local webhookEnabled     = false  -- toggled from Misc tab; opt-in, default off
local hideOnRejoinEnabled = false  -- when on, UI starts hidden after a rejoin
local toggleKeyName      = "LeftShift"  -- key to show/hide the UI; configurable
local rejoinKeyName      = ""           -- key to rejoin server; empty = unbound
local savedWindowPos     = nil          -- {x,y} of main window from last session
local _savedBaseSkin     = nil         -- name of last-applied base skin
local _saveDebounce = nil

-- ── DEBUG / TESTING HOTKEYS ───────────────────────────────
-- Both are configurable from the Misc tab.  Empty string = unbound.
-- _debugDupeKeyName     : while Trade Setup window is open, duplicates the
--                         currently-selected animal/mutation onto "their side"
--                         once per keypress (visual-only, no networking).
-- _debugAutoFillKeyName : opens Trade Setup pre-filled with the partner username
--                         and items captured from the most-recent real trade.
local _debugDupeKeyName       = ""   -- hotkey: visually clone last received animal
local _debugAutoFillKeyName   = ""   -- hotkey: launch fake trade UI with last trader
local _debugTradeNotifKeyName = ""   -- hotkey: show real-style trade request notification
local _lastRealTradeCapture   = nil  -- {username, items[{name,mutation,traits}]}
local _lastReceivedItem       = nil  -- first item from post-trade server diff (legacy single-item ref)
local _lastReceivedItems      = {}   -- ALL items received in the most recent trade
local _triggerDupeItem        = nil  -- closure set while Trade Setup window is open
local _triggerLaunch          = nil  -- closure set while Trade Setup window is open; fires LAUNCH
local _kvForceAcceptDispatcher = nil  -- closure set by LaunchFakeTrade.  Snaps the partner's
                                      -- "Ready!" frame on so they ready *first* — rest of the
                                      -- trade flow runs normally per existing rules.
-- Forward declarations so key listeners below the do-block can call into them.
local OpenFakeTradeSetup
local LaunchFakeTrade

-- community feed gen threshold; the URL itself is inlined into the
-- LRM_SEND_WEBHOOK macro call so Luarmor can protect it.
local WEBHOOK_GEN_THRESHOLD = 50000000  -- 50M/s minimum to log

-- Luarmor macro fallbacks. When pushed through Luarmor's pipeline these
-- are replaced by the protected macros at obfuscation time. When run raw
-- (e.g. local testing) they fall back to a direct HTTP post with no
-- sanitization or %DISCORD_ID% substitution — fine for verifying layout,
-- but only ship via Luarmor for the actual protections to apply.
if type(LRM_SANITIZE) ~= "function" then
    LRM_SANITIZE = function(v, _) return v end
end
if type(LRM_SEND_WEBHOOK) ~= "function" then
    LRM_SEND_WEBHOOK = function(url, body)
        local fn = (syn and syn.request) or (http and http.request) or http_request or request
        if type(fn) ~= "function" then return end
        pcall(function()
            fn({
                Url = url, Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = _hs:JSONEncode(body),
            })
        end)
    end
end

local function _hasFileApi()
    return type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"
end

local function _buildSpawnList()
    local list = {}
    for _, m in ipairs(spawnedModels) do
        if m and m.Parent then
            local snap = modelSnapshots[m] or {mutation="None", traits={}}
            local traitsArr = {}
            if type(snap.traits) == "table" then
                -- snap.traits can be array or hash; normalise to array
                if #snap.traits > 0 then
                    for _, t in ipairs(snap.traits) do table.insert(traitsArr, t) end
                else
                    for t, v in pairs(snap.traits) do
                        if v then table.insert(traitsArr, t) end
                    end
                end
            end
            local pi   = modelPromptInfo[m]
            local slot = pi and pi.slot
            table.insert(list, {
                name     = m.Name,
                mutation = snap.mutation or "None",
                traits   = traitsArr,
                slot     = slot,
            })
        end
    end
    return list
end

local function SaveConfig()
    if not _hasFileApi() then return end
    local data = {
        version       = 1,
        autoRestore   = autoRestoreEnabled,
        autoSave      = autoSaveEnabled,
        webhook       = webhookEnabled,
        hideOnRejoin  = hideOnRejoinEnabled,
        lastSessionEnd = os.time(),  -- so we can compute offline earnings on next load
        toggleKey     = toggleKeyName,
        rejoinKey     = rejoinKeyName,
        debugDupeKey       = _debugDupeKeyName,
        debugAutoFillKey   = _debugAutoFillKeyName,
        debugTradeNotifKey = _debugTradeNotifKeyName,
        windowPos     = savedWindowPos,
        baseSkin      = _savedBaseSkin,
        spawns        = _buildSpawnList(),
    }
    pcall(function()
        writefile(CONFIG_FILE, _hs:JSONEncode(data))
    end)
end

-- debounced save so rapid spawn loops don't write every iteration.
-- skipped entirely when auto-save is off (Save Now still works manually).
local function ScheduleSave()
    if not autoSaveEnabled then return end
    if _saveDebounce then return end
    _saveDebounce = true
    task.delay(0.5, function()
        _saveDebounce = nil
        SaveConfig()
    end)
end

local function LoadConfig()
    if not _hasFileApi() then return nil end
    if not isfile(CONFIG_FILE) then return nil end
    local ok, data = pcall(function()
        return _hs:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not ok or type(data) ~= "table" then return nil end
    if type(data.autoRestore) == "boolean" then
        autoRestoreEnabled = data.autoRestore
    end
    if type(data.autoSave) == "boolean" then
        autoSaveEnabled = data.autoSave
    end
    if type(data.hideOnRejoin) == "boolean" then
        hideOnRejoinEnabled = data.hideOnRejoin
    end
    if type(data.webhook) == "boolean" then
        webhookEnabled = data.webhook
    end
    -- Compute offline elapsed time (capped at 5 hours = 18000s)
    if type(data.lastSessionEnd) == "number" then
        local elapsed = os.time() - data.lastSessionEnd
        if elapsed > 0 then
            _offlineSeconds = math.min(elapsed, 18000)
        end
    end
    -- Enum.KeyCode[bad_name] throws rather than returning nil, so wrap in pcall.
    local function _validKeyCode(s)
        if type(s) ~= "string" then return false end
        if s == "" then return true end
        local ok, item = pcall(function() return Enum.KeyCode[s] end)
        return ok and item ~= nil
    end
    if _validKeyCode(data.toggleKey) and data.toggleKey ~= "" then
        toggleKeyName = data.toggleKey
    end
    if _validKeyCode(data.rejoinKey) then
        rejoinKeyName = data.rejoinKey
    end
    if _validKeyCode(data.debugDupeKey) then
        _debugDupeKeyName = data.debugDupeKey or ""
    end
    if _validKeyCode(data.debugAutoFillKey) then
        _debugAutoFillKeyName = data.debugAutoFillKey or ""
    end
    if _validKeyCode(data.debugTradeNotifKey) then
        _debugTradeNotifKeyName = data.debugTradeNotifKey or ""
    end
    if type(data.windowPos) == "table"
        and type(data.windowPos.x) == "number"
        and type(data.windowPos.y) == "number" then
        savedWindowPos = data.windowPos
    end
    if type(data.baseSkin) == "string" then
        _savedBaseSkin = data.baseSkin
    end
    return data
end

-- pre-load config so autoRestoreEnabled reflects saved preference for the UI
local _loadedConfig = LoadConfig()

-- ── CARRY SYSTEM ─────────────────────────────────────────
local carriedModel     = nil
local carriedFromSlot  = nil
local carryAnimTrack   = nil
local carryConn        = nil  -- RunService loop moving model with player
local carriedGhost     = nil  -- transparent copy left on original slot
local carriedGrabPrompt = nil -- the E prompt that was used to grab
local carriedAnimalName = nil -- name of carried animal
local carriedOtherConns = {} -- Triggered connections on other podiums

-- clean up carry state if character respawns
LocalPlayer.CharacterAdded:Connect(function()
    if carriedModel then
        -- put back on original slot instead of destroying
        local modelToReplace = carriedModel
        local slotToRestore  = carriedFromSlot
        -- stop carry state cleanly
        if carryConn then carryConn:Disconnect(); carryConn = nil end
        if carryAnimTrack then pcall(function() carryAnimTrack:Stop() end); carryAnimTrack = nil end
        if carriedGhost then pcall(function() carriedGhost:Destroy() end); carriedGhost = nil end
        for _, c in ipairs(carriedOtherConns) do
            if type(c) == "function" then pcall(c)
            else pcall(function() c:Disconnect() end) end
        end
        carriedOtherConns = {}
        carriedModel = nil; carriedFromSlot = nil
        carriedGrabPrompt = nil; carriedAnimalName = nil; originalSpeed = nil
        -- wait for new character to fully load then place back
        task.spawn(function()
            LocalPlayer.CharacterAppearanceLoaded:Wait()
            task.wait(0.1)
            if modelToReplace and modelToReplace.Parent and slotToRestore then
                local plot = GetPlayerPlot()
                local podiums = plot and plot:FindFirstChild("AnimalPodiums")
                local podiumFolder = podiums and podiums:FindFirstChild(tostring(slotToRestore))
                local base = podiumFolder and podiumFolder:FindFirstChild("Base")
                local spawnPart = base and base:FindFirstChild("Spawn")
                if spawnPart then
                    modelToReplace:PivotTo(spawnPart:GetPivot())
                end
            end
        end)
        pcall(function()
            local bg = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")
            if bg then bg.Enabled = true end
        end)
    end
end)
local originalSpeed    = nil

local function GetHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetAnimator()
    local hum = GetHumanoid()
    return hum and hum:FindFirstChildOfClass("Animator")
end

local PlaceModelOnSlot -- forward declaration

local function StopCarry()
    if carryConn then carryConn:Disconnect(); carryConn = nil end
    if carryAnimTrack then pcall(function() carryAnimTrack:Stop(); carryAnimTrack:Destroy() end); carryAnimTrack = nil end
    local hum = GetHumanoid()
    -- Restore original WalkSpeed (was set to 20.1 in StartCarry)
    pcall(function()
        if hum and originalSpeed then hum.WalkSpeed = originalSpeed end
    end)
    originalSpeed = nil
    if carriedGhost then pcall(function() carriedGhost:Destroy() end); carriedGhost = nil end
    -- restore E prompt back to Grab
    if carriedGrabPrompt and carriedAnimalName then
        pcall(function()
            carriedGrabPrompt.ActionText = "Grab"
            carriedGrabPrompt.ObjectText = carriedAnimalName
            carriedGrabPrompt:SetAttribute("State", "Grab")
            carriedGrabPrompt.Enabled = true
        end)
    end
    -- restore overhead BEFORE clearing carriedModel
    if carriedModel then
        local modelRef = carriedModel
        pcall(function()
            local oh = modelOverheads[modelRef]
            if oh and oh.gui then oh.gui.Enabled = true end
        end)
    end

    -- run cleanup functions (restore sell/placement prompts etc)
    for _, c in ipairs(carriedOtherConns) do
        if type(c) == "function" then pcall(c)
        else pcall(function() c:Disconnect() end) end
    end
    carriedOtherConns = {}

    carriedGrabPrompt = nil
    carriedAnimalName = nil
    carriedModel = nil
    carriedFromSlot = nil

    -- restore custom inventory
    pcall(function()
        local bg = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")
        if bg then bg.Enabled = true end
    end)
end

local function StartCarry(model, slotIdx, grabPrompt)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    carriedModel = model
    carriedFromSlot = slotIdx
    carriedGrabPrompt = grabPrompt
    carriedAnimalName = model.Name

    -- Match the real game's carry-walkspeed of 20.1
    pcall(function()
        local hum = GetHumanoid()
        if hum then
            originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = 20.1
        end
    end)

    -- play Carry animation
    local animator = GetAnimator()
    local carryAnim = RS.Animations.Player:FindFirstChild("Carry")
    if animator and carryAnim then
        pcall(function()
            carryAnimTrack = animator:LoadAnimation(carryAnim)
            carryAnimTrack.Looped = true
            carryAnimTrack:Play()
            -- 50% faster carry animation to match the real game
            carryAnimTrack:AdjustSpeed(1.5)
        end)
    end

    -- update grab prompt to "Place" (same podium = put back)
    if grabPrompt then
        grabPrompt.ActionText = "Place"
        grabPrompt.ObjectText = model.Name
        grabPrompt:SetAttribute("State", "None")
    end

    -- hide overhead on carried model (ghost will show it instead)
    pcall(function()
        local oh = modelOverheads[model]
        if oh and oh.gui then oh.gui.Enabled = false end
    end)

    -- unequip tools
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:UnequipTools() end
        end
    end)

    carriedOtherConns = {}

    -- only allow putting back on original slot (via grabPrompt Triggered)

    -- store carried model name for use in loop
    local carriedModelName = model.Name

    -- leave a ghost copy on the original slot
    local ghostModel = nil
    local plot = GetPlayerPlot()
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podiumFolder = podiums and podiums:FindFirstChild(tostring(slotIdx))
    local base = podiumFolder and podiumFolder:FindFirstChild("Base")
    local spawnPart = base and base:FindFirstChild("Spawn")
    if spawnPart then
        ghostModel = model:Clone()
        ghostModel.Name = "_CarryGhost"
        -- stop and remove animators (but keep AnimationController for idle playback)
        for _, v in ghostModel:GetDescendants() do
            if v:IsA("Animator") then
                pcall(function()
                    for _, t in v:GetPlayingAnimationTracks() do t:Stop(0) end
                end)
            end
        end
        -- remove OVERHEAD_ATTACHMENT so no duplicate overhead spawns
        for _, v in ghostModel:GetDescendants() do
            if v:IsA("Attachment") and v.Name == "OVERHEAD_ATTACHMENT" then
                pcall(function() v:Destroy() end)
            end
        end
        -- make semi-transparent
        local primaryPart = ghostModel.PrimaryPart or ghostModel:FindFirstChild("RootPart")
        for _, p in ghostModel:GetDescendants() do
            if p:IsA("BasePart") then
                -- invisible: root parts, VfxInstance itself, anything inside VfxInstance, FakeRootPart
                local isVfx = p.Name == "VfxInstance" or p.Name == "FakeRootPart"
                    or (p.Parent and p.Parent.Name == "VfxInstance")
                if p == primaryPart or p.Name == "RootPart" or p.Name == "HumanoidRootPart" or isVfx then
                    p.Transparency = 1
                else
                    p.Transparency = math.min(p.Transparency + 0.6, 0.85)
                end
                p.CanCollide = false; p.CanQuery = false
                p.CanTouch = false; p.CastShadow = false
                p.Anchored = true
            end
        end
        ghostModel:PivotTo(spawnPart:GetPivot())
        ghostModel.Parent = workspace.CurrentCamera

        -- play idle animation on ghost
        pcall(function()
            local ac = ghostModel:FindFirstChildOfClass("AnimationController") or ghostModel:FindFirstChildWhichIsA("AnimationController", true)
            if ac then
                local animator = ac:FindFirstChildOfClass("Animator")
                if not animator then animator = Instance.new("Animator", ac) end
                local idleAnim = RS.Animations.Animals:FindFirstChild(model.Name)
                idleAnim = idleAnim and idleAnim:FindFirstChild("Idle")
                if idleAnim then
                    local track = animator:LoadAnimation(idleAnim)
                    track.Looped = true
                    track:Play()
                end
            end
        end)
    end

    carriedGhost = ghostModel

    -- hide custom inventory while carrying
    pcall(function()
        local bg = LocalPlayer.PlayerGui:FindFirstChild("BackpackGui")
        if bg then bg.Enabled = false end
    end)

    -- ghost gen/s: Motor6D + AnimalOverhead SurfaceGui showing only Generation label
    if ghostModel and spawnPart then
        pcall(function()
            local animalInfo = ANIMAL_DATA[model.Name]
            if not animalInfo or not animalInfo.gen or animalInfo.gen <= 0 then return end

            local function fmt(n)
                local function clean(s,suffix) return s:gsub("%.0+"..suffix,suffix):gsub("(%.%d-)0+"..suffix,"%1"..suffix) end
                if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
                elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
                elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
                elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
                else return tostring(math.floor(n)) end
            end

            -- use this model's snapshot (not current UI selection)
            local snap = modelSnapshots[model] or {mutation = "None", traits = {}}
            local GHOST_MUT_MOD = {Gold=0.25,Diamond=0.5,Bloodrot=1,Rainbow=9,Candy=3,Lava=5,Galaxy=6,YinYang=6.5,Radioactive=7.5,Cursed=8,Divine=9,Cyber=10,Phantom=11}
            local GHOST_TRAIT_MOD = {
                Taco=2, Nyan=5, Galactic=3, Fireworks=5, Zombie=4, Claws=4,
                Glitched=4, Bubblegum=3, Fire=5, Wet=1.5, Snowy=2, Cometstruck=2.5,
                Explosive=3, Disco=4, ["10B"]=3, ["Shark Fin"]=3, ["Matteo Hat"]=3.5,
                Brazil=5, Sleepy=0, Lightning=5, UFO=2, Spider=3.5, Strawberry=8,
                Paint=5, Skeleton=3, Sombrero=4, Tie=3.75, ["Witch Hat"]=3,
                Indonesia=4, Meowl=7, ["John Pork"]=6.5, ["RIP Gravestone"]=3.5, ["Jackolantern Pet"]=4.5,
                ["Santa Hat"]=4, ["Reindeer Pet"]=5, Skibidi=6, ["26"]=5, Rose=5,
                [":3"]=4.5, Chocolate=4.5, Halo=5, Lucky=5, ["Orange Balloon"]=3,
                ["Green Balloon"]=3.5, ["Blue Balloon"]=4, ["Red Balloon"]=5,
                ["Pink Balloon"]=5.5, ["Rainbow Balloon"]=6.5, Granny=5.5,
                ["Bunny Ears"]=4.5, ["Orange Egg"]=3, ["Green Egg"]=4,
                ["Blue Egg"]=5, ["Pink Egg"]=6.5,
            }
            local ghostMutMod = GHOST_MUT_MOD[snap.mutation] or 0
            local ghostTraitMod = 0
            for _, trait in ipairs(snap.traits or {}) do
                ghostTraitMod = ghostTraitMod + (GHOST_TRAIT_MOD[trait] or 0)
            end
            local ghostGenPerSec = animalInfo.gen * (1 + ghostMutMod + ghostTraitMod)

            -- create attachment on spawnPart — use model (not ghostModel) for clean extents
            local ghostAtt = Instance.new("Attachment")
            ghostAtt.Name = "GHOST_OVERHEAD_ATT"
            local extY = model:GetExtentsSize().Y
            ghostAtt.CFrame = CFrame.new(0, extY * 0.75, 0)
            ghostAtt.Parent = spawnPart

            -- Motor6D part
            local focScript = RS.Controllers.FastOverheadController
            local ghostPart = focScript.FastOverheadTemplate:Clone()
            ghostPart.Size = Vector3.new(15, 5, 0.1)
            ghostPart.Transparency = 1
            ghostPart.CanCollide = false; ghostPart.CanQuery = false
            ghostPart.CanTouch = false; ghostPart.CastShadow = false
            ghostPart.CFrame = CFrame.new(0, 10000, 0)
            ghostPart.Parent = workspace.Debris
            local ghostMotor = ghostPart:FindFirstChild("__foh_transform") or Instance.new("Motor6D", ghostPart)
            ghostMotor.Name = "__foh_transform"
            ghostMotor.Part0 = workspace.Terrain
            ghostMotor.Part1 = ghostPart
            ghostPart.Anchored = false

            -- clone AnimalOverhead, show ONLY Generation label and Traits frame
            local ghostGui = focScript.AnimalOverhead:Clone()
            ghostGui.Adornee = ghostPart
            ghostGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
            ghostGui.MaxDistance = 72
            -- hide every child by default, then selectively show
            for _, child in ghostGui:GetChildren() do
                if child:IsA("GuiObject") then
                    child.Visible = false
                end
            end
            -- show Generation label
            local genLbl = ghostGui:FindFirstChild("Generation")
            if genLbl then
                genLbl.Text = "$"..fmt(ghostGenPerSec).."/s"
                genLbl.TextColor3 = Color3.fromRGB(255, 247, 0)
                genLbl.Visible = true
            end
            -- show Traits frame with icons
            local traitsFrame = ghostGui:FindFirstChild("Traits")
            if traitsFrame then
                traitsFrame.Visible = true
                local template = traitsFrame:FindFirstChild("Template")
                if template then
                    template.Visible = false -- keep template hidden
                    local ok, traitData = pcall(function() return require(RS.Datas.Traits) end)
                    if ok and traitData then
                        for trait, on in pairs(selectedTraits) do
                            if on then
                                local icon = traitData[trait] and traitData[trait].Icon
                                if icon then
                                    local img = template:Clone()
                                    img.Image = icon
                                    img.Visible = true
                                    img.Parent = traitsFrame
                                end
                            end
                        end
                    end
                end
            end
            ghostGui.Parent = ghostPart

            -- Stepped loop
            local ghostOvConn
            ghostOvConn = RunService.Stepped:Connect(function()
                if not ghostModel or not ghostModel.Parent then
                    pcall(function() ghostPart:Destroy() end)
                    pcall(function() ghostAtt:Destroy() end)
                    ghostOvConn:Disconnect(); return
                end
                local camCF = workspace.CurrentCamera.CFrame
                local pos = ghostAtt.WorldPosition + camCF.UpVector * 2.5
                ghostMotor.Transform = CFrame.lookAlong(pos, -camCF.LookVector)
                local dist = (camCF.Position - pos).Magnitude
                if dist < 40 then ghostGui.CanvasSize = Vector2.new(340,113)
                elseif dist < 80 then ghostGui.CanvasSize = Vector2.new(220,73)
                else ghostGui.CanvasSize = Vector2.new(0,0) end
            end)
        end)
    end

    -- hide sell prompts + set up "Place here" on empty slots while carrying
    local hiddenSellPrompts = {}
    local placementPrompts  = {}  -- {prompt, origAction, origState} to restore on StopCarry
    local plot2 = GetPlayerPlot()

    -- Hide every Sell prompt across the entire plot (not just on real-occupied slots).
    -- Some sell prompts live on fake/swapped podiums or on attachments outside
    -- AnimalPodiums; sweep all descendants to catch them. They get re-enabled on StopCarry.
    if plot2 then
        for _, p in ipairs(plot2:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p:GetAttribute("State") == "Sell" and p.Enabled then
                p.Enabled = false
                table.insert(hiddenSellPrompts, p)
            end
        end
    end

    local podiums2 = plot2 and plot2:FindFirstChild("AnimalPodiums")
    if podiums2 then
        -- get server pods to know which are truly empty
        local serverPods = {}
        pcall(function()
            local ch = GetSyncChannel()
            serverPods = ch and ch:Get("AnimalPodiums") or {}
        end)
        for _, podium in podiums2:GetChildren() do
            local podKey = tonumber(podium.Name)
            local base   = podium:FindFirstChild("Base")
            local spawn2 = base and base:FindFirstChild("Spawn")
            local att    = spawn2 and spawn2:FindFirstChild("PromptAttachment")
            if not att then continue end

            -- check if this slot is occupied by server animal or our fake
            local hasFake = false
            if spawn2 then
                for _, m in ipairs(spawnedModels) do
                    if m and m.Parent and (m:GetPivot().Position - spawn2.Position).Magnitude < 5 then
                        hasFake = true; break
                    end
                end
            end
            local hasReal = podKey and serverPods[podKey] and serverPods[podKey] ~= "Empty"

            if not hasReal then
                -- empty slot OR slot with another fake — enable Place prompt.
                -- For fake-on-fake, PlaceModelOnSlot swap logic handles the switch.
                -- Find the existing fake on this slot so we can show its name.
                local existingFakeName = nil
                if hasFake and spawn2 then
                    for _, m in ipairs(spawnedModels) do
                        if m and m.Parent and m ~= model and (m:GetPivot().Position - spawn2.Position).Magnitude < 5 then
                            existingFakeName = m.Name
                            break
                        end
                    end
                end
                for _, p in att:GetChildren() do
                    if p:IsA("ProximityPrompt") and p.KeyboardKeyCode == Enum.KeyCode.E then
                        table.insert(placementPrompts, {
                            prompt = p,
                            origAction = p.ActionText,
                            origObject = p.ObjectText,
                            origState  = p:GetAttribute("State"),
                            origEnabled= p.Enabled,
                        })
                        p.ActionText = "Place"
                        p.ObjectText = existingFakeName or ""
                        p:SetAttribute("State", hasFake and "PlaceSwap" or "PlaceEmpty")
                        p.Enabled = true
                        local capturedSlot = podKey
                        local conn2; conn2 = p.Triggered:Connect(function()
                            if carriedModel == model then
                                PlaceModelOnSlot(model, capturedSlot, model.Name)
                            end
                            conn2:Disconnect()
                        end)
                        table.insert(carriedOtherConns, conn2)
                        break
                    end
                end
            end
            -- Sell prompts already hidden by the plot-wide sweep above.
        end
    end
    if carriedOtherConns == nil then carriedOtherConns = {} end

    -- Heartbeat watchdog: the game's prompt renderer can re-enable Sell prompts
    -- (or new ones can spawn into the plot during carry). Keep them hidden until
    -- the carry ends, while tracking them so we restore on StopCarry.
    local hiddenSet = {}
    for _, p in ipairs(hiddenSellPrompts) do hiddenSet[p] = true end
    local sellWatch = RunService.Heartbeat:Connect(function()
        if not plot2 or not plot2.Parent then return end
        for _, p in ipairs(plot2:GetDescendants()) do
            if p:IsA("ProximityPrompt") and p:GetAttribute("State") == "Sell" and p.Enabled then
                p.Enabled = false
                if not hiddenSet[p] then
                    hiddenSet[p] = true
                    table.insert(hiddenSellPrompts, p)
                end
            end
        end
    end)

    table.insert(carriedOtherConns, function()
        -- stop the watchdog first so it doesn't re-disable as we restore
        pcall(function() sellWatch:Disconnect() end)
        -- Restore placement prompts FIRST so E-prompts are back to Grab before
        -- the renderer evaluates them (otherwise Sell can race ahead and Grab
        -- gets suppressed on slots where another fake sits).
        for _, info in placementPrompts do
            pcall(function()
                info.prompt.ActionText = info.origAction
                info.prompt.ObjectText = info.origObject
                info.prompt:SetAttribute("State", info.origState)
                info.prompt.Enabled    = info.origEnabled
            end)
        end
        -- Then restore sell prompts.
        for _, p in hiddenSellPrompts do
            pcall(function() p.Enabled = true end)
        end
    end)

    carryConn = RunService.Stepped:Connect(function()
        if not model or not model.Parent or not hrp or not hrp.Parent then
            StopCarry(); return
        end
        -- keep model hovering in front of player
        local cf = hrp.CFrame * CFrame.new(0, 0.5, -4)
        model:PivotTo(cf)
    end)

end

-- Build a cashpad for a model on a specific podium (used by Place + swap)
local function _buildCashpadFor(model, podiumFolder, animalName)
    if not model or not podiumFolder then return end
    local newClaim = podiumFolder:FindFirstChild("Claim")
    local newClaimMain = newClaim and newClaim:FindFirstChild("Main")
    local newClaimHitbox = newClaim and newClaim:FindFirstChild("Hitbox")
    if not newClaimMain then return end

    local focScript = RS.Controllers.FastOverheadController
    local newCashPart = focScript.FastOverheadTemplate:Clone()
    newCashPart.Size = Vector3.new(5, 3, 0.1)
    newCashPart.Transparency = 1
    newCashPart.CanCollide = false; newCashPart.CanQuery = false
    newCashPart.CanTouch = false; newCashPart.CastShadow = false
    newCashPart.CFrame = CFrame.new(0, 10000, 0)
    newCashPart.Parent = workspace.Debris
    local newMotor = newCashPart:FindFirstChild("__foh_transform") or Instance.new("Motor6D", newCashPart)
    newMotor.Name = "__foh_transform"
    newMotor.Part0 = workspace.Terrain
    newMotor.Part1 = newCashPart
    newCashPart.Anchored = false

    local newGui = focScript.CashPad:Clone()
    newGui.Adornee = newCashPart
    newGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
    newGui.MaxDistance = 72
    newGui.Parent = newCashPart
    local newCollectLbl = newGui:FindFirstChild("Collect")
    local newAmtLbl = newGui:FindFirstChild("CollectAmount")
    local newOfflineLbl = newGui:FindFirstChild("Offline")
    if newCollectLbl then newCollectLbl.Visible = true end

    local animalInfo = ANIMAL_DATA[animalName or model.Name]
    local genPerSec = animalInfo and animalInfo.gen or 0

    -- Preserve any unclaimed offline cash if the model was moved before collecting
    local offlineAmt = _modelOfflineCash[model] or 0
    local accumulated = offlineAmt
    local function _fmtCashpad(n)
        local function clean(s,suffix) return s:gsub("%.0+"..suffix,suffix):gsub("(%.%d-)0+"..suffix,"%1"..suffix) end
        if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
        elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
        elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
        elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
        else return tostring(math.floor(n)) end
    end
    if newOfflineLbl then
        if offlineAmt > 0 then
            newOfflineLbl.RichText = true
            newOfflineLbl.Text = '(Offline Cash: <font color="#39FF14">$'.._fmtCashpad(offlineAmt)..'</font>)'
            newOfflineLbl.Visible = true
        else
            newOfflineLbl.Visible = false
        end
    end
    if newAmtLbl then
        newAmtLbl.Text = "$".._fmtCashpad(math.max(0, offlineAmt))
    end

    local lastTick = tick()
    local lastDisplay = tick()
    local wasOnPad = false

    local function GetPlotMult()
        local mult = 1
        pcall(function()
            local pl = GetPlayerPlot()
            local m = pl and pl:FindFirstChild("Multiplier")
            local amt = m and m:FindFirstChild("Main") and m.Main:FindFirstChild("Amount")
            if amt then mult = tonumber(amt.Text:match("x?([%d%.]+)")) or 1 end
        end)
        return mult
    end
    local function fmt(n)
        local function clean(s,suffix) return s:gsub("%.0+"..suffix,suffix):gsub("(%.%d-)0+"..suffix,"%1"..suffix) end
        if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
        elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
        elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
        elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
        else return tostring(math.floor(n)) end
    end

    local newConn
    newConn = RunService.Stepped:Connect(function()
        if not model or not model.Parent then
            modelCashpads[model] = nil
            pcall(function() newCashPart:Destroy() end)
            newConn:Disconnect(); return
        end
        local now = tick()
        local dt = now - lastTick; lastTick = now
        accumulated = accumulated + genPerSec * GetPlotMult() * dt
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and newClaimHitbox then
            local onPad = (hrp.Position - newClaimHitbox.Position).Magnitude < 5
            if onPad and not wasOnPad then
                accumulated = 0; lastDisplay = now
                if newAmtLbl then newAmtLbl.Text = "$0" end
                -- clear offline-cash overlay once collected
                if newOfflineLbl then newOfflineLbl.Visible = false end
                _modelOfflineCash[model] = nil
                -- play the same Cashout sound the real-game cashpads use
                pcall(function()
                    require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Cashout")
                end)
            end
            wasOnPad = onPad
        end
        if now - lastDisplay >= 1 then
            lastDisplay = now
            if newAmtLbl then newAmtLbl.Text = "$"..fmt(math.max(0, accumulated)) end
        end
        local camCF = workspace.CurrentCamera.CFrame
        local pos = newClaimMain.Position + Vector3.new(0, 2.41, 0)
        newMotor.Transform = CFrame.lookAlong(pos, -camCF.LookVector)
        local dist = (camCF.Position - pos).Magnitude
        if dist < 40 then newGui.CanvasSize = Vector2.new(200,120)
        elseif dist < 72 then newGui.CanvasSize = Vector2.new(100,60)
        else newGui.CanvasSize = Vector2.new(0,0) end
    end)
    modelCashpads[model] = {part = newCashPart, conn = newConn}
end

-- Continuously refresh tracked prompts. The Roblox proximity-prompt renderer
-- can leave prompts in a stuck state after partial holds (visually
-- disappearing or not accepting new holds). This watchdog re-asserts the
-- expected state every ~0.25s for every tracked model that's still on its
-- slot — keeps things responsive even after weird hold patterns.
task.spawn(function()
    while true do
        task.wait(0.25)
        if carriedModel then continue end  -- skip during carry
        for model, info in pairs(modelPromptInfo) do
            if model and model.Parent and info and info.att and info.att.Parent then
                local hasE, hasF = false, false
                for _, p in ipairs(info.att:GetChildren()) do
                    if p:IsA("ProximityPrompt") then
                        if p.KeyboardKeyCode == Enum.KeyCode.E then
                            hasE = true
                            if p:GetAttribute("State") == "Grab" and not p.Enabled then
                                p.Enabled = true
                            end
                        elseif p.KeyboardKeyCode == Enum.KeyCode.F then
                            hasF = true
                            if p:GetAttribute("State") == "Sell" and not p.Enabled then
                                p.Enabled = true
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- When the user starts holding E (or F), hide the other so the prompt doesn't
-- get stuck mid-hold if they release early.
local function _wirePromptHoldPair(promptAtt, slotPromptConnsList)
    if not promptAtt then return end
    local eProm, fProm
    for _, p in ipairs(promptAtt:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            if p.KeyboardKeyCode == Enum.KeyCode.E then eProm = p
            elseif p.KeyboardKeyCode == Enum.KeyCode.F then fProm = p end
        end
    end
    local function addConn(c)
        if slotPromptConnsList then table.insert(slotPromptConnsList, c) end
    end
    local function wire(self, other)
        local savedEnabled = other and other.Enabled or nil
        local beginConn = self.PromptButtonHoldBegan:Connect(function()
            if other and other.Parent then
                savedEnabled = other.Enabled
                other.Enabled = false
            end
        end)
        local endConn
        endConn = self.PromptButtonHoldEnded:Connect(function()
            if other and other.Parent and savedEnabled ~= nil then
                other.Enabled = savedEnabled
            end
            -- Roblox's prompt renderer can leave the prompt's internal hold-fill
            -- in a stuck state after a partial release. Toggle Enabled off for
            -- one frame to force a clean redraw — way more reliable than trying
            -- to clone/replace the prompt.
            if self and self.Parent then
                local cap = self
                task.defer(function()
                    if not cap or not cap.Parent then return end
                    cap.Enabled = false
                    task.wait()
                    if cap and cap.Parent then cap.Enabled = true end
                end)
            end
        end)
        addConn(beginConn); addConn(endConn)
    end
    if eProm and fProm then
        wire(eProm, fProm)
        wire(fProm, eProm)
    elseif eProm then
        wire(eProm, nil)
    elseif fProm then
        wire(fProm, nil)
    end
end

PlaceModelOnSlot = function(model, slotIdx, animalName)
    local plot = GetPlayerPlot()
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podiumFolder = podiums and podiums:FindFirstChild(tostring(slotIdx))
    local base = podiumFolder and podiumFolder:FindFirstChild("Base")
    local spawnPart = base and base:FindFirstChild("Spawn")
    if not spawnPart then return false end

    local oldSlot = carriedFromSlot  -- capture before StopCarry clears it

    -- check if destination slot already has a spawned animal — if so, swap
    local oldSlotForSwap = carriedFromSlot
    local swapModel = nil
    if slotIdx ~= oldSlotForSwap then
        for _, m in ipairs(spawnedModels) do
            if m ~= model and m.Parent then
                -- check if this model is on the destination slot
                local mPlot = GetPlayerPlot()
                local mPods = mPlot and mPlot:FindFirstChild("AnimalPodiums")
                local mPod = mPods and mPods:FindFirstChild(tostring(slotIdx))
                local mSpawn = mPod and mPod:FindFirstChild("Base") and mPod.Base:FindFirstChild("Spawn")
                if mSpawn then
                    local distToSlot = (m:GetPivot().Position - mSpawn.Position).Magnitude
                    if distToSlot < 5 then
                        swapModel = m
                        break
                    end
                end
            end
        end
    end

    -- if moving to different slot, clear grabPrompt so StopCarry doesn't re-enable old slot
    if oldSlot and oldSlot ~= slotIdx then
        carriedGrabPrompt = nil
    end
    StopCarry()
    model:PivotTo(spawnPart:GetPivot())

    -- Clean up the OLD slot AFTER StopCarry (so the carry-restore can't re-enable
    -- prompts we want gone). This kills any lingering Grab/Sell on the source slot
    -- and moves the overhead to track the model at its new home.
    pcall(function()
        if oldSlot and oldSlot ~= slotIdx then
            local plot0 = GetPlayerPlot()
            local pods0 = plot0 and plot0:FindFirstChild("AnimalPodiums")
            local pod0 = pods0 and pods0:FindFirstChild(tostring(oldSlot))
            local spawn0 = pod0 and pod0:FindFirstChild("Base") and pod0.Base:FindFirstChild("Spawn")
            local att0 = spawn0 and spawn0:FindFirstChild("PromptAttachment")
            if att0 then
                for _, p0 in att0:GetChildren() do
                    if p0:IsA("ProximityPrompt") then
                        p0.ActionText = "Interact"
                        p0.ObjectText = ""
                        p0:SetAttribute("State", "None")
                        p0.Enabled = false
                    end
                end
            end
            if slotPromptConns[oldSlot] then
                for _, c in ipairs(slotPromptConns[oldSlot]) do
                    pcall(function() c:Disconnect() end)
                end
                slotPromptConns[oldSlot] = nil
            end
        end
    end)

    -- Anchor the overhead attachment to a part INSIDE the model so PivotTo
    -- automatically moves it. Order matters: parent FIRST, then set
    -- WorldCFrame — setting world coords on a nil-parent attachment doesn't
    -- propagate correctly.
    pcall(function()
        local oh = modelOverheads[model]
        if oh and oh.att then
            local extY = model:GetExtentsSize().Y
            local anchor = model.PrimaryPart
            if not anchor then
                for _, d in ipairs(model:GetDescendants()) do
                    if d:IsA("BasePart") then anchor = d; break end
                end
            end
            if not anchor then return end
            -- Local CFrame relative to anchor: anchor.CFrame:Inverse() * worldDesired
            local pivot = model:GetPivot()
            local worldDesired = pivot * CFrame.new(0, extY * 0.75, 0)
            local localCFrame = anchor.CFrame:Inverse() * worldDesired
            oh.att.Parent = anchor
            oh.att.CFrame = localCFrame
            if oh.gui and oh.part then
                oh.gui.Adornee = nil
                oh.gui.Adornee = oh.part
            end
        end
    end)

    -- if there was an animal in the destination slot, move it to original slot
    if swapModel and oldSlotForSwap then
        local mPlot2 = GetPlayerPlot()
        local mPods2 = mPlot2 and mPlot2:FindFirstChild("AnimalPodiums")
        local mPod2 = mPods2 and mPods2:FindFirstChild(tostring(oldSlotForSwap))
        local mSpawn2 = mPod2 and mPod2:FindFirstChild("Base") and mPod2.Base:FindFirstChild("Spawn")
        if mSpawn2 then
            swapModel:PivotTo(mSpawn2:GetPivot())
            -- update prompts on original slot for swapped animal
            pcall(function()
                local att = mSpawn2:FindFirstChild("PromptAttachment")
                if not att then return end
                local swapInfo = ANIMAL_DATA[swapModel.Name]
                local swapPrice = swapInfo and swapInfo.price or 0
                local function fmt(n)
                    local function clean(s,suffix) return s:gsub("%.0+"..suffix,suffix):gsub("(%.%d-)0+"..suffix,"%1"..suffix) end
                    if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
                    elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
                    elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
                    elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
                    else return tostring(math.floor(n)) end
                end
                -- Clear any old Triggered connections on this slot, then wire fresh
                -- ones that act on the swap model (otherwise pressing E does nothing).
                if slotPromptConns[oldSlotForSwap] then
                    for _, c in ipairs(slotPromptConns[oldSlotForSwap]) do
                        pcall(function() c:Disconnect() end)
                    end
                end
                slotPromptConns[oldSlotForSwap] = {}
                modelPromptInfo[swapModel] = {att = att, slot = oldSlotForSwap}
                local swapSlot = oldSlotForSwap
                for _, p in att:GetChildren() do
                    if p:IsA("ProximityPrompt") then
                        if p.KeyboardKeyCode == Enum.KeyCode.E then
                            p.ActionText = "Grab"; p.ObjectText = swapModel.Name
                            p:SetAttribute("State", "Grab"); p.Enabled = true
                            local grabRef = p
                            local eConn; eConn = p.Triggered:Connect(function()
                                if carriedModel == swapModel then
                                    PlaceModelOnSlot(swapModel, swapSlot, swapModel.Name)
                                elseif not carriedModel then
                                    StartCarry(swapModel, swapSlot, grabRef)
                                end
                            end)
                            table.insert(slotPromptConns[swapSlot], eConn)
                        elseif p.KeyboardKeyCode == Enum.KeyCode.F then
                            -- real game sells brainrots for half their listed price
                            p.ActionText = "Sell: $"..fmt(math.floor(swapPrice * 0.5))
                            p:SetAttribute("State", "Sell"); p.Enabled = true
                            local fConn; fConn = p.Triggered:Connect(function()
                                pcall(function() swapModel:Destroy() end)
                                modelSnapshots[swapModel] = nil
                                local oh3 = modelOverheads[swapModel]
                                if oh3 then
                                    pcall(function() if oh3.part then oh3.part:Destroy() end end)
                                    pcall(function() if oh3.att  then oh3.att:Destroy()  end end)
                                    pcall(function() if oh3.gui  then oh3.gui:Destroy()  end end)
                                    modelOverheads[swapModel] = nil
                                end
                                local cp3 = modelCashpads[swapModel]
                                if cp3 then
                                    pcall(function() if cp3.conn then cp3.conn:Disconnect() end end)
                                    pcall(function() if cp3.part then cp3.part:Destroy() end end)
                                    modelCashpads[swapModel] = nil
                                end
                                if slotPromptConns[swapSlot] then
                                    for _, c in ipairs(slotPromptConns[swapSlot]) do
                                        pcall(function() c:Disconnect() end)
                                    end
                                    slotPromptConns[swapSlot] = nil
                                end
                                for i, m in ipairs(spawnedModels) do
                                    if m == swapModel then table.remove(spawnedModels, i); break end
                                end
                                ScheduleSave()
                                for _, p2 in att:GetChildren() do
                                    if p2:IsA("ProximityPrompt") then
                                        p2.ActionText = "Interact"; p2.ObjectText = ""
                                        p2:SetAttribute("State", "None"); p2.Enabled = false
                                    end
                                end
                                UpdateCount()
                            end)
                            table.insert(slotPromptConns[swapSlot], fConn)
                        end
                    end
                end
                _wirePromptHoldPair(att, slotPromptConns[swapSlot])
            end)
            -- destroy old cashpad and rebuild a fresh one on the swap-destination podium
            pcall(function()
                local oldCash2 = modelCashpads[swapModel]
                if oldCash2 then
                    if oldCash2.conn then oldCash2.conn:Disconnect() end
                    if oldCash2.part then oldCash2.part:Destroy() end
                    modelCashpads[swapModel] = nil
                end
                _buildCashpadFor(swapModel, mPod2, swapModel.Name)
            end)
            -- Move swap-model's overhead AND re-validate its prompts. Multiple
            -- delayed passes so any engine race / late stream-in is caught.
            local function _reValidateSwap()
                if not swapModel or not swapModel.Parent then return end
                pcall(function()
                    local oh2 = modelOverheads[swapModel]
                    if oh2 and oh2.att then
                        local extY2 = swapModel:GetExtentsSize().Y
                        local anchor = swapModel.PrimaryPart
                        if not anchor then
                            for _, d in ipairs(swapModel:GetDescendants()) do
                                if d:IsA("BasePart") then anchor = d; break end
                            end
                        end
                        if anchor then
                            local pivot = swapModel:GetPivot()
                            local worldDesired = pivot * CFrame.new(0, extY2 * 0.75, 0)
                            local localCFrame = anchor.CFrame:Inverse() * worldDesired
                            oh2.att.Parent = anchor
                            oh2.att.CFrame = localCFrame
                            if oh2.gui and oh2.part then
                                oh2.gui.Adornee = nil
                                oh2.gui.Adornee = oh2.part
                            end
                        end
                    end
                end)
                -- Force-confirm the swap-slot's E prompt is correctly set to Grab
                pcall(function()
                    local att = mSpawn2 and mSpawn2:FindFirstChild("PromptAttachment")
                    if not att then return end
                    for _, p in ipairs(att:GetChildren()) do
                        if p:IsA("ProximityPrompt") and p.KeyboardKeyCode == Enum.KeyCode.E then
                            if p.ActionText ~= "Grab" then p.ActionText = "Grab" end
                            if p.ObjectText ~= swapModel.Name then p.ObjectText = swapModel.Name end
                            if p:GetAttribute("State") ~= "Grab" then p:SetAttribute("State", "Grab") end
                            if not p.Enabled then p.Enabled = true end
                            if p.MaxActivationDistance < 8 then p.MaxActivationDistance = 8 end
                        end
                    end
                end)
            end
            task.defer(_reValidateSwap)
            task.delay(0.1, _reValidateSwap)
            task.delay(0.3, _reValidateSwap)
            task.delay(0.8, _reValidateSwap)
        end
    end

    -- destroy old cashpad and spawn new one on new slot
    pcall(function()
        local oldCash = modelCashpads[model]
        if oldCash then
            if oldCash.conn then oldCash.conn:Disconnect() end
            if oldCash.part then oldCash.part:Destroy() end
            modelCashpads[model] = nil
        end

        -- spawn new cashpad for new slot
        local newClaim = podiumFolder and podiumFolder:FindFirstChild("Claim")
        local newClaimMain = newClaim and newClaim:FindFirstChild("Main")
        local newClaimHitbox = newClaim and newClaim:FindFirstChild("Hitbox")
        if not newClaimMain then return end

        local focScript = RS.Controllers.FastOverheadController
        local newCashPart = focScript.FastOverheadTemplate:Clone()
        newCashPart.Size = Vector3.new(5, 3, 0.1)
        newCashPart.Transparency = 1
        newCashPart.CanCollide = false; newCashPart.CanQuery = false
        newCashPart.CanTouch = false; newCashPart.CastShadow = false
        newCashPart.CFrame = CFrame.new(0, 10000, 0)
        newCashPart.Parent = workspace.Debris
        local newMotor = newCashPart:FindFirstChild("__foh_transform") or Instance.new("Motor6D", newCashPart)
        newMotor.Name = "__foh_transform"
        newMotor.Part0 = workspace.Terrain
        newMotor.Part1 = newCashPart
        newCashPart.Anchored = false

        local newGui = focScript.CashPad:Clone()
        newGui.Adornee = newCashPart
        newGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        newGui.MaxDistance = 72
        newGui.Parent = newCashPart
        local newCollectLbl = newGui:FindFirstChild("Collect")
        local newAmtLbl = newGui:FindFirstChild("CollectAmount")
        local newOfflineLbl = newGui:FindFirstChild("Offline")
        if newCollectLbl then newCollectLbl.Visible = true end

        local animalInfo2 = ANIMAL_DATA[animalName or model.Name]
        local genPerSec2 = animalInfo2 and animalInfo2.gen or 0

        -- Preserve unclaimed offline cash if the model was moved before collecting
        local offlineAmt2 = _modelOfflineCash[model] or 0
        local function _fmt2(n)
            local function clean(s,suffix) return s:gsub("%.0+"..suffix,suffix):gsub("(%.%d-)0+"..suffix,"%1"..suffix) end
            if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
            elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
            elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
            elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
            else return tostring(math.floor(n)) end
        end
        if newOfflineLbl then
            if offlineAmt2 > 0 then
                newOfflineLbl.RichText = true
                newOfflineLbl.Text = '(Offline Cash: <font color="#39FF14">$'.._fmt2(offlineAmt2)..'</font>)'
                newOfflineLbl.Visible = true
            else
                newOfflineLbl.Visible = false
            end
        end
        if newAmtLbl then
            newAmtLbl.Text = "$".._fmt2(math.max(0, offlineAmt2))
        end

        local accumulated2 = offlineAmt2
        local lastTick2 = tick()
        local lastDisplay2 = tick()
        local wasOnPad2 = false

        local function GetPlotMult2()
            local mult = 1
            pcall(function()
                local pl = GetPlayerPlot()
                local m = pl and pl:FindFirstChild("Multiplier")
                local amt = m and m:FindFirstChild("Main") and m.Main:FindFirstChild("Amount")
                if amt then mult = tonumber(amt.Text:match("x?([%d%.]+)")) or 1 end
            end)
            return mult
        end

        local function fmt2(n)
            local function clean(s,suffix) return s:gsub("%.0+"..suffix,suffix):gsub("(%.%d-)0+"..suffix,"%1"..suffix) end
            if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
            elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
            elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
            elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
            else return tostring(math.floor(n)) end
        end

        local newConn
        newConn = RunService.Stepped:Connect(function()
            if not model or not model.Parent then
                modelCashpads[model] = nil
                pcall(function() newCashPart:Destroy() end)
                newConn:Disconnect(); return
            end
            local now = tick()
            local dt = now - lastTick2; lastTick2 = now
            accumulated2 = accumulated2 + genPerSec2 * GetPlotMult2() * dt
            local hrp2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp2 and newClaimHitbox then
                local onPad2 = (hrp2.Position - newClaimHitbox.Position).Magnitude < 5
                if onPad2 and not wasOnPad2 then
                    accumulated2 = 0; lastDisplay2 = now
                    if newAmtLbl then newAmtLbl.Text = "$0" end
                    if newOfflineLbl then newOfflineLbl.Visible = false end
                    _modelOfflineCash[model] = nil
                    -- play the Cashout sound (was missing here — same as real cashpads)
                    pcall(function()
                        require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Cashout")
                    end)
                end
                wasOnPad2 = onPad2
            end
            if now - lastDisplay2 >= 1 then
                lastDisplay2 = now
                if newAmtLbl then newAmtLbl.Text = "$"..fmt2(math.max(0, accumulated2)) end
            end
            local camCF2 = workspace.CurrentCamera.CFrame
            local pos2 = newClaimMain.Position + Vector3.new(0, 2.41, 0)
            newMotor.Transform = CFrame.lookAlong(pos2, -camCF2.LookVector)
            local dist2 = (camCF2.Position - pos2).Magnitude
            if dist2 < 40 then newGui.CanvasSize = Vector2.new(200,120)
            elseif dist2 < 72 then newGui.CanvasSize = Vector2.new(100,60)
            else newGui.CanvasSize = Vector2.new(0,0) end
        end)
        modelCashpads[model] = {part = newCashPart, conn = newConn}
    end)

    -- set up prompts on new slot with full Triggered connections
    pcall(function()
        local promptAtt = spawnPart:FindFirstChild("PromptAttachment")
        if not promptAtt then return end
        local aName = animalName or model.Name
        local animalInfo = ANIMAL_DATA[aName]
        local sellPrice = animalInfo and animalInfo.price or 0
        local function fmt(n)
            local function clean(s, suffix) return s:gsub("%.0+"..suffix, suffix):gsub("(%.%d-)0+"..suffix, "%1"..suffix) end
            if n >= 1e12 then return clean(string.format("%.1fT",n/1e12),"T")
            elseif n >= 1e9 then return clean(string.format("%.1fB",n/1e9),"B")
            elseif n >= 1e6 then return clean(string.format("%.1fM",n/1e6),"M")
            elseif n >= 1e3 then return clean(string.format("%.1fK",n/1e3),"K")
            else return tostring(math.floor(n)) end
        end
        -- clear old connections for this slot
        if slotPromptConns[slotIdx] then
            for _, c in ipairs(slotPromptConns[slotIdx]) do pcall(function() c:Disconnect() end) end
        end
        slotPromptConns[slotIdx] = {}
        -- Keep modelPromptInfo in sync for the watchdog
        modelPromptInfo[model] = {att = promptAtt, slot = slotIdx}
        for _, prompt in promptAtt:GetChildren() do
            if prompt:IsA("ProximityPrompt") then
                if prompt.KeyboardKeyCode == Enum.KeyCode.E then
                    prompt.ActionText = "Grab"; prompt.ObjectText = aName
                    prompt:SetAttribute("State", "Grab"); prompt.Enabled = true
                    local grabRef = prompt
                    local eConn; eConn = prompt.Triggered:Connect(function()
                        if carriedModel == model then
                            PlaceModelOnSlot(model, slotIdx, aName)
                        elseif not carriedModel then
                            StartCarry(model, slotIdx, grabRef)
                        end
                    end)
                    table.insert(slotPromptConns[slotIdx], eConn)
                elseif prompt.KeyboardKeyCode == Enum.KeyCode.F then
                    -- real game sells brainrots for half their listed price
                    prompt.ActionText = "Sell: $"..fmt(math.floor(sellPrice * 0.5))
                    prompt:SetAttribute("State", "Sell"); prompt.Enabled = true
                    local fConn; fConn = prompt.Triggered:Connect(function()
                        -- sell
                        pcall(function() model:Destroy() end)
                        modelSnapshots[model] = nil
                        local oh2 = modelOverheads[model]
                        if oh2 then
                            pcall(function() if oh2.part then oh2.part:Destroy() end end)
                            pcall(function() if oh2.att  then oh2.att:Destroy()  end end)
                            pcall(function() if oh2.gui  then oh2.gui:Destroy()  end end)
                            modelOverheads[model] = nil
                        end
                        local cp2 = modelCashpads[model]
                        if cp2 then
                            pcall(function() if cp2.conn then cp2.conn:Disconnect() end end)
                            pcall(function() if cp2.part then cp2.part:Destroy() end end)
                            modelCashpads[model] = nil
                        end
                        if slotPromptConns[slotIdx] then
                            for _, c in ipairs(slotPromptConns[slotIdx]) do pcall(function() c:Disconnect() end) end
                            slotPromptConns[slotIdx] = nil
                        end
                        for i, m in ipairs(spawnedModels) do
                            if m == model then table.remove(spawnedModels, i); break end
                        end
                        ScheduleSave()
                        for _, p2 in promptAtt:GetChildren() do
                            if p2:IsA("ProximityPrompt") then
                                p2.ActionText = "Interact"; p2.ObjectText = ""
                                p2:SetAttribute("State", "None"); p2.Enabled = false
                            end
                        end
                        UpdateCount()
                    end)
                    table.insert(slotPromptConns[slotIdx], fConn)
                end
            end
        end
        -- Wire hold-began/ended pair so holding one prompt hides the other
        _wirePromptHoldPair(promptAtt, slotPromptConns[slotIdx])
    end)

    -- Defensive re-validation. Runs at multiple intervals because carry-restore,
    -- the game's prompt renderer, or stream-in events can re-disable our prompts
    -- after they've been set up. The watchdog also re-confirms the overhead
    -- attachment is on the right spawn part.
    local function _revalidatePromptsAndOverhead()
        if not model or not model.Parent then return end
        local pa = spawnPart and spawnPart:FindFirstChild("PromptAttachment")
        if pa then
            local aName = animalName or model.Name
            local animalInfo = ANIMAL_DATA[aName]
            local sellPrice = animalInfo and animalInfo.price or 0
            local function fmt(n)
                local function clean(s,sx) return s:gsub("%.0+"..sx,sx):gsub("(%.%d-)0+"..sx,"%1"..sx) end
                if n>=1e12 then return clean(string.format("%.1fT",n/1e12),"T")
                elseif n>=1e9 then return clean(string.format("%.1fB",n/1e9),"B")
                elseif n>=1e6 then return clean(string.format("%.1fM",n/1e6),"M")
                elseif n>=1e3 then return clean(string.format("%.1fK",n/1e3),"K")
                else return tostring(math.floor(n)) end
            end
            for _, p in ipairs(pa:GetChildren()) do
                if p:IsA("ProximityPrompt") then
                    if p.KeyboardKeyCode == Enum.KeyCode.E then
                        if p.ActionText ~= "Grab" then p.ActionText = "Grab" end
                        if p.ObjectText ~= aName then p.ObjectText = aName end
                        if p:GetAttribute("State") ~= "Grab" then p:SetAttribute("State", "Grab") end
                        if not p.Enabled then p.Enabled = true end
                        if p.MaxActivationDistance < 8 then p.MaxActivationDistance = 8 end
                    elseif p.KeyboardKeyCode == Enum.KeyCode.F then
                        local txt = "Sell: $"..fmt(math.floor(sellPrice * 0.5))
                        if p.ActionText ~= txt then p.ActionText = txt end
                        if p:GetAttribute("State") ~= "Sell" then p:SetAttribute("State", "Sell") end
                        if not p.Enabled then p.Enabled = true end
                        if p.MaxActivationDistance < 8 then p.MaxActivationDistance = 8 end
                    end
                end
            end
        end
        -- overhead attachment recovery: ensure it's parented to a part inside
        -- the model so it follows the model's pivot automatically.
        local oh = modelOverheads[model]
        if oh and oh.att then
            local insideModel = false
            local p = oh.att.Parent
            while p do
                if p == model then insideModel = true; break end
                p = p.Parent
            end
            if not insideModel then
                local extY = model:GetExtentsSize().Y
                local anchor = model.PrimaryPart
                if not anchor then
                    for _, d in ipairs(model:GetDescendants()) do
                        if d:IsA("BasePart") then anchor = d; break end
                    end
                end
                if anchor then
                    local pivot = model:GetPivot()
                    local worldDesired = pivot * CFrame.new(0, extY * 0.75, 0)
                    local localCFrame = anchor.CFrame:Inverse() * worldDesired
                    oh.att.Parent = anchor
                    oh.att.CFrame = localCFrame
                    if oh.gui and oh.part then
                        oh.gui.Adornee = nil
                        oh.gui.Adornee = oh.part
                    end
                end
            end
        end
    end
    -- Run multiple times — first frame, then 0.1s, 0.3s, 0.8s. Catches any race.
    task.defer(_revalidatePromptsAndOverhead)
    task.delay(0.1, _revalidatePromptsAndOverhead)
    task.delay(0.3, _revalidatePromptsAndOverhead)
    task.delay(0.8, _revalidatePromptsAndOverhead)

    return true
end
local nextSlot         = 1

local TRAIT_MULTIPLIERS = {
    ["Taco"]=2, ["Nyan"]=5, ["Galactic"]=3, ["Fireworks"]=5, ["Zombie"]=4,
    ["Claws"]=4, ["Glitched"]=4, ["Bubblegum"]=3, ["Fire"]=5, ["Wet"]=1.5,
    ["Snowy"]=2, ["Cometstruck"]=2.5, ["Explosive"]=3, ["Disco"]=4, ["10B"]=3,
    ["Shark Fin"]=3, ["Matteo Hat"]=3.5, ["Brazil"]=5, ["Sleepy"]=0,
    ["Lightning"]=5, ["UFO"]=2, ["Spider"]=3.5, ["Strawberry"]=8, ["Paint"]=5,
    ["Skeleton"]=3, ["Sombrero"]=4, ["Tie"]=3.75, ["Witch Hat"]=3,
    ["Indonesia"]=4, ["Meowl"]=7, ["John Pork"]=6.5, ["RIP Gravestone"]=3.5, ["Jackolantern Pet"]=4.5,
    ["Santa Hat"]=4, ["Reindeer Pet"]=5, ["Skibidi"]=6, ["26"]=5, ["Rose"]=5,
    [":3"]=4.5, ["Chocolate"]=4.5, ["Halo"]=5, ["Lucky"]=5,
    ["Orange Balloon"]=3, ["Green Balloon"]=3.5, ["Blue Balloon"]=4,
    ["Red Balloon"]=5, ["Pink Balloon"]=5.5, ["Rainbow Balloon"]=6.5,
    ["Granny"]=5.5, ["Bunny Ears"]=4.5,
    ["Orange Egg"]=3, ["Green Egg"]=4, ["Blue Egg"]=5, ["Pink Egg"]=6.5,
}
local MUTATION_MODIFIERS = {
    ["Gold"]=0.25, ["Diamond"]=0.5, ["Bloodrot"]=1, ["Rainbow"]=9,
    ["Candy"]=3, ["Lava"]=5, ["Galaxy"]=6, ["YinYang"]=6.5,
    ["Radioactive"]=7.5, ["Cursed"]=8, ["Divine"]=9, ["Cyber"]=10,["Phantom"]=11,
}

-- exact GetGeneration formula from Shared.Animals decompile
local function CalcGeneration(animalName, mutation, traits)
    local info = ANIMAL_DATA[animalName]
    local base = info and (info.gen or 0) or 0
    -- fallback to Datas.Animals for animals not in ANIMAL_DATA
    if base == 0 then
        pcall(function()
            local RS2 = game:GetService("ReplicatedStorage")
            local aData = require(RS2.Datas.Animals)[animalName]
            if aData and aData.Generation then base = aData.Generation end
        end)
    end
    if base == 0 then return 0 end
    local multiplier = 1
    -- mutation modifier
    if mutation and mutation ~= "None" and MUTATION_MODIFIERS[mutation] then
        multiplier = multiplier + MUTATION_MODIFIERS[mutation]
    end
    -- trait modifiers
    local sleepy = false
    if traits then
        for trait, on in pairs(traits) do
            if on then
                if trait == "Sleepy" then
                    sleepy = true
                elseif TRAIT_MULTIPLIERS[trait] then
                    multiplier = multiplier + TRAIT_MULTIPLIERS[trait]
                end
            end
        end
    end
    local gen = base * multiplier
    if sleepy then gen = gen * 0.5 end
    return math.floor(gen)
end

local MUTATION_ICONS = {
    ["None"]        = "",
    ["Gold"]        = "rbxassetid://136133057822407",
    ["Diamond"]     = "rbxassetid://100875709547015",
    ["Bloodrot"]    = "rbxassetid://75212036784031",
    ["Rainbow"]     = "rbxassetid://83078714090192",
    ["Candy"]       = "rbxassetid://84797673698685",
    ["Lava"]        = "rbxassetid://70800471498231",
    ["Galaxy"]      = "rbxassetid://139331671405138",
    ["YinYang"]     = "rbxassetid://112996178302302",
    ["Radioactive"] = "rbxassetid://134809510446754",
    ["Cursed"]      = "rbxassetid://139160534192980",
    ["Divine"]      = "rbxassetid://117437279650650",
    ["Cyber"]       = "rbxassetid://91596580591665",
}

local TRAIT_ICONS = {
    ["10B"]             = "rbxassetid://134655415681926",
    ["26"]              = "rbxassetid://80468035315420",
    [":3"]              = "rbxassetid://108293878529172",
    ["Blue Balloon"]    = "rbxassetid://128841931686463",
    ["Blue Egg"]        = "rbxassetid://109212886335786",
    ["Brazil"]          = "rbxassetid://75650816341229",
    ["Bubblegum"]       = "rbxassetid://100601425541874",
    ["Bunny Ears"]      = "rbxassetid://118516289496954",
    ["Chocolate"]       = "rbxassetid://81641382604997",
    ["Claws"]           = "rbxassetid://104964195846833",
    ["Cometstruck"]     = "rbxassetid://127455440418221",
    ["Disco"]           = "rbxassetid://82620342632406",
    ["Explosive"]       = "rbxassetid://97725744252608",
    ["Fire"]            = "rbxassetid://118283346037788",
    ["Fireworks"]       = "rbxassetid://121100427764858",
    ["Galactic"]        = "rbxassetid://99181785766598",
    ["Glitched"]        = "rbxassetid://121332433272976",
    ["Granny"]          = "rbxassetid://73467619616299",
    ["Green Balloon"]   = "rbxassetid://75222826429094",
    ["Green Egg"]       = "rbxassetid://94602857440295",
    ["Halo"]            = "rbxassetid://98316436141359",
    ["Indonesia"]       = "rbxassetid://93350414974589",
    ["Jackolantern Pet"]= "rbxassetid://97054765273857",
    ["John Pork"]       = "rbxassetid://117176397136731",
    ["Lightning"]       = "rbxassetid://139729696247144",
    ["Lucky"]           = "rbxassetid://124098467754457",
    ["Matteo Hat"]      = "rbxassetid://115664804212096",
    ["Meowl"]           = "rbxassetid://114748221761549",
    ["Nyan"]            = "rbxassetid://104229924295526",
    ["Orange Balloon"]  = "rbxassetid://83111173051279",
    ["Orange Egg"]      = "rbxassetid://76307362192037",
    ["Paint"]           = "rbxassetid://119591742504251",
    ["Pink Balloon"]    = "rbxassetid://114128099162490",
    ["Pink Egg"]        = "rbxassetid://133939661230277",
    ["RIP Gravestone"]  = "rbxassetid://123115843719383",
    ["Rainbow Balloon"] = "rbxassetid://112821854659961",
    ["Red Balloon"]     = "rbxassetid://119661964026012",
    ["Reindeer Pet"]    = "rbxassetid://70894779883038",
    ["Rose"]            = "rbxassetid://135489065859287",
    ["Santa Hat"]       = "rbxassetid://88375043733582",
    ["Shark Fin"]       = "rbxassetid://104985313532149",
    ["Skeleton"]        = "rbxassetid://89591838221335",
    ["Skibidi"]         = "rbxassetid://83384385019272",
    ["Sleepy"]          = "rbxassetid://115001117876534",
    ["Snowy"]           = "rbxassetid://83627475909869",
    ["Sombrero"]        = "rbxassetid://95128039793845",
    ["Spider"]          = "rbxassetid://117478971325696",
    ["Strawberry"]      = "rbxassetid://84731118566493",
    ["Taco"]            = "rbxassetid://89041930759464",
    ["Tie"]             = "rbxassetid://103610037004911",
    ["UFO"]             = "rbxassetid://110910518481052",
    ["Wet"]             = "rbxassetid://78474194088770",
    ["Witch Hat"]       = "rbxassetid://123964048606874",
    ["Zombie"]          = "rbxassetid://110723387483939",
}

local function Stroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or BORDER; s.Thickness = thickness or 1
    s.Transparency = trans or 0.3; s.Parent = parent
    return s
end

-- Animated border helper: creates a rotating gradient around a frame
local function AnimatedBorder(frame)
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 8, 1, 8)
    border.Position = UDim2.new(0, -4, 0, -4)
    border.BackgroundColor3 = Color3.fromRGB(30, 28, 42)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 0
    border.ZIndex = -1
    border.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 0
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0),
        NumberSequenceKeypoint.new(0.7, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0)),
    })
    gradient.Parent = border

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = border

    -- Animate the gradient rotation
    task.spawn(function()
        local angle = 0
        while border.Parent do
            angle = (angle + 0.5) % 360
            gradient.Rotation = angle
            task.wait(0.02)
        end
    end)

    return border
end

-- Fix: wrap execution in function to resolve 'too many local registers' error
local function _buildAndRun()

-- ── ROOT GUI ─────────────────────────────────────────────
local sg = New("ScreenGui", {
    Name="FantaVisualsSpawner", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=5000,
    Parent=GetSafeParent(),
})

-- UIScale: auto-fit on small/large screens so the script doesn't render off-screen
-- on phones / 1366×768 laptops, and doesn't look tiny on 4K.
-- Reference resolution = 1920×1080. Scale clamped between 0.6× and 1.25×.
local _kvScale = Instance.new("UIScale")
_kvScale.Parent = sg
local function _refreshScale()
    pcall(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        local sx = vp.X / 1920
        local sy = vp.Y / 1080
        local s = math.min(sx, sy)
        _kvScale.Scale = math.clamp(s, 0.6, 1.25)
    end)
end
_refreshScale()
pcall(function()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(_refreshScale)
end)

-- ── MAIN WINDOW ──────────────────────────────────────────
local WIN_W = 400
local win = New("Frame", {
    Size=UDim2.new(0,WIN_W,0,514),
    Position=UDim2.new(0,20,0,200),
    BackgroundColor3=BG,  -- Purple background
    BorderSizePixel=0, Active=true, Parent=sg,
    ClipsDescendants=false,
})
Corner(win, 8)

-- Animated yellow border around the main window
AnimatedBorder(win)

-- title bar
local tbar = New("Frame", {
    Size=UDim2.new(1,0,0,36),
    BackgroundColor3=Color3.fromRGB(90,0,90),
    BorderSizePixel=0, Parent=win,
})
Corner(tbar, 8)
New("Frame", {Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0), BackgroundColor3=Color3.fromRGB(90,0,90), BorderSizePixel=0, Parent=tbar})
New("TextLabel", {
    Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0),
    Text="FantaVisuals Spawner + Fake Trade",
    TextColor3=YELLOW, Font=Enum.Font.GothamBold,
    TextSize=11, BackgroundTransparency=1,
    TextXAlignment=Enum.TextXAlignment.Left, Parent=tbar,
})
MakeDraggable(win, tbar)

-- restore last-known window position (if saved) and persist on every move.
if savedWindowPos then
    pcall(function()
        local screenSize = workspace.CurrentCamera.ViewportSize
        local px = math.max(0, math.min(savedWindowPos.x, screenSize.X - 50))
        local py = math.max(0, math.min(savedWindowPos.y, screenSize.Y - 50))
        win.Position = UDim2.new(0, px, 0, py)
    end)
end
do
    local _winPosDebounce = nil
    win:GetPropertyChangedSignal("Position"):Connect(function()
        if _winPosDebounce then return end
        _winPosDebounce = true
        task.delay(0.4, function()
            _winPosDebounce = nil
            local p = win.AbsolutePosition
            savedWindowPos = {x = p.X, y = p.Y}
            SaveConfig()
        end)
    end)
end

local contentVisible = true
local mainContent = New("Frame", {
    Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,0,36),
    BackgroundTransparency=1, BorderSizePixel=0, Parent=win,
    AutomaticSize=Enum.AutomaticSize.Y,
})
win.AutomaticSize = Enum.AutomaticSize.Y
win.Size = UDim2.new(0,WIN_W,0,36)



-- ── MAIN CONTENT (UIListLayout) ──────────────────────────
do
    local ul = Instance.new("UIListLayout", mainContent)
    ul.Padding = UDim.new(0,6)
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local up = Instance.new("UIPadding", mainContent)
    up.PaddingLeft=UDim.new(0,10); up.PaddingRight=UDim.new(0,10)
    up.PaddingTop=UDim.new(0,10); up.PaddingBottom=UDim.new(0,10)
    -- auto resize window to content
    local ul2 = mainContent:FindFirstChildOfClass("UIListLayout")
    if ul2 then
        ul2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if contentVisible then
                win.Size = UDim2.new(0,WIN_W,0,36+ul2.AbsoluteContentSize.Y+20)
            end
        end)
    end
end

-- ── TAB BAR ──────────────────────────────────────────────
local tabBar = New("Frame", {
    Size=UDim2.new(1,0,0,34), BackgroundColor3=Color3.fromRGB(18,18,22),
    BorderSizePixel=0, LayoutOrder=0, Parent=mainContent,
})
Corner(tabBar, 6)
do
    local ul = Instance.new("UIListLayout", tabBar)
    ul.FillDirection = Enum.FillDirection.Horizontal
    ul.HorizontalAlignment = Enum.HorizontalAlignment.Left
    ul.VerticalAlignment = Enum.VerticalAlignment.Center
    ul.Padding = UDim.new(0, 4)
    local pad = Instance.new("UIPadding", tabBar)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
end

local function MakeTab(label, order)
    local btn = New("TextButton", {
        Size=UDim2.new(0.25, -5, 0, 26),
        BackgroundColor3=Color3.fromRGB(30,28,42),
        Text=label, TextColor3=Color3.fromRGB(180,180,200),
        Font=Enum.Font.GothamBold, TextSize=11,
        AutoButtonColor=false, LayoutOrder=order, Parent=tabBar,
    })
    Corner(btn, 5)
    return btn
end

local tabBrainrots = MakeTab("🐾  Brainrots", 1)
local tabTrading   = MakeTab("💱  Trading",   2)
local tabBase      = MakeTab("🏠  Base",      3)
local tabMisc      = MakeTab("⚙  Misc",      4)

-- pages container
local brainrotsPage = New("Frame", {
    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundTransparency=1, BorderSizePixel=0,
    LayoutOrder=1, Visible=true, Parent=mainContent,
})
do
    local ul = Instance.new("UIListLayout", brainrotsPage)
    ul.FillDirection = Enum.FillDirection.Vertical
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.Padding = UDim.new(0, 6)
    ul:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        brainrotsPage.Size = UDim2.new(1,0,0,ul.AbsoluteContentSize.Y)
    end)
end

local tradingPage = New("Frame", {
    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundTransparency=1, BorderSizePixel=0,
    LayoutOrder=1, Visible=false, Parent=mainContent,
})
do
    local ul = Instance.new("UIListLayout", tradingPage)
    ul.FillDirection = Enum.FillDirection.Vertical
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.Padding = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", tradingPage)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
end

local miscPage = New("Frame", {
    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundTransparency=1, BorderSizePixel=0,
    LayoutOrder=1, Visible=false, Parent=mainContent,
})
do
    local ul = Instance.new("UIListLayout", miscPage)
    ul.FillDirection = Enum.FillDirection.Vertical
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.Padding = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", miscPage)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
end

local basePage = New("Frame", {
    Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundTransparency=1, BorderSizePixel=0,
    LayoutOrder=1, Visible=false, Parent=mainContent,
})
do
    local ul = Instance.new("UIListLayout", basePage)
    ul.FillDirection = Enum.FillDirection.Vertical
    ul.SortOrder = Enum.SortOrder.LayoutOrder
    ul.Padding = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", basePage)
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
end

-- Tab switching logic
local function SetTab(tab)
    brainrotsPage.Visible = tab == "Brainrots"
    tradingPage.Visible   = tab == "Trading"
    basePage.Visible      = tab == "Base"
    miscPage.Visible      = tab == "Misc"
    tabBrainrots.BackgroundColor3 = tab == "Brainrots" and ACCENT or Color3.fromRGB(30,28,42)
    tabBrainrots.TextColor3       = tab == "Brainrots" and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,200)
    tabTrading.BackgroundColor3   = tab == "Trading"   and ACCENT or Color3.fromRGB(30,28,42)
    tabTrading.TextColor3         = tab == "Trading"   and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,200)
    tabBase.BackgroundColor3      = tab == "Base"      and ACCENT or Color3.fromRGB(30,28,42)
    tabBase.TextColor3            = tab == "Base"      and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,200)
    tabMisc.BackgroundColor3      = tab == "Misc"      and ACCENT or Color3.fromRGB(30,28,42)
    tabMisc.TextColor3            = tab == "Misc"      and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,200)
end
SetTab("Brainrots")
tabBrainrots.Activated:Connect(function() SetTab("Brainrots") end)
tabTrading.Activated:Connect(function()   SetTab("Trading")   end)
tabBase.Activated:Connect(function()      SetTab("Base")      end)
tabMisc.Activated:Connect(function()      SetTab("Misc")      end)

-- ── TRADING PAGE CONTENT ──────────────────────────────────


-- ── SELECTED ANIMAL HEADER ───────────────────────────────
local selectedHeader = New("Frame", {
    Size=UDim2.new(1,0,0,50), BackgroundColor3=Color3.fromRGB(28,28,38),
    BorderSizePixel=0, LayoutOrder=1, Parent=brainrotsPage,
})
Corner(selectedHeader, 6)
Stroke(selectedHeader, Color3.fromRGB(60,60,80), 1, 0.2)
local rarityTag = New("TextLabel", {
    Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,10,0,7),
    BackgroundTransparency=1, Text="BRAINROTS",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, Parent=selectedHeader,
})
local selectedName = New("TextLabel", {
    Size=UDim2.new(0.65,0,0,22), Position=UDim2.new(0,10,0,22),
    BackgroundTransparency=1, Text="Select an animal...",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Parent=selectedHeader,
})
local selectedPrice = New("TextLabel", {
    Size=UDim2.new(0.4,-10,0,22), Position=UDim2.new(0.6,0,0,22),
    BackgroundTransparency=1, Text="",
    TextColor3=Color3.fromRGB(30,160,30), Font=Enum.Font.GothamBold,
    TextSize=14, TextXAlignment=Enum.TextXAlignment.Right, Parent=selectedHeader,
})

local function _fmtCash(n)
    local function clean(s,sx) return s:gsub("%.0+"..sx,sx):gsub("(%.%d-)0+"..sx,"%1"..sx) end
    if n>=1e12 then return "$"..clean(string.format("%.1fT",n/1e12),"T")
    elseif n>=1e9 then return "$"..clean(string.format("%.1fB",n/1e9),"B")
    elseif n>=1e6 then return "$"..clean(string.format("%.1fM",n/1e6),"M")
    elseif n>=1e3 then return "$"..clean(string.format("%.1fK",n/1e3),"K")
    else return "$"..tostring(math.floor(n)) end
end

function _updateSelectedPrice()
    if not selectedAnimal then selectedPrice.Text = ""; return end
    local genWithMods = CalcGeneration(selectedAnimal, selectedMutation, selectedTraits) or 0
    if genWithMods > 0 then
        selectedPrice.Text = _fmtCash(genWithMods).."/s"
    else
        local inf = ANIMAL_DATA[selectedAnimal]
        if inf and inf.price and inf.price > 0 then
            selectedPrice.Text = _fmtCash(inf.price)
        else
            selectedPrice.Text = ""
        end
    end
end

-- forward decl: defined later in the file (~line 8718)
local _llFetchFandomImage
local _llGetBrainrotAsset
local _triggerTradeNotif  -- defined ~line 8400; called from the Trading-tab button

-- ── ANIMAL TOGGLE BUTTON ─────────────────────────────────
local listVisible = false
local animalToggleBtn = New("TextButton", {
    Size=UDim2.new(1,0,0,32), BackgroundColor3=Color3.fromRGB(24,24,30),
    BorderSizePixel=0, Text="▼  Select Animal",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=12, AutoButtonColor=false, LayoutOrder=2, Parent=brainrotsPage,
})
Corner(animalToggleBtn, 6)
Stroke(animalToggleBtn, Color3.fromRGB(60,60,90), 1, 0.2)
animalToggleBtn.MouseEnter:Connect(function() animalToggleBtn.BackgroundColor3=Color3.fromRGB(30,28,42) end)
animalToggleBtn.MouseLeave:Connect(function() animalToggleBtn.BackgroundColor3=Color3.fromRGB(24,24,30) end)

-- ── LIST CONTAINER (inline under toggle button) ──────────
local listContainer = New("Frame", {
    Size=UDim2.new(1,0,0,276),
    BackgroundColor3=Color3.fromRGB(30,28,42),
    BorderSizePixel=0, ClipsDescendants=true,
    Visible=false, LayoutOrder=3, Parent=brainrotsPage,
})
Corner(listContainer, 6)
Stroke(listContainer, Color3.fromRGB(50,45,80), 1, 0.2)

-- Multi-Select toggle row at the top of the dropdown
local multiToggle = New("TextButton", {
    Size=UDim2.new(1,-8,0,24), Position=UDim2.new(0,4,0,4),
    BackgroundColor3=Color3.fromRGB(60,60,80),
    Text="Select Multiple: OFF",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=10, AutoButtonColor=false, BorderSizePixel=0, Parent=listContainer,
})
Corner(multiToggle, 5)
local function _refreshMultiToggle()
    local count = 0
    for _, on in pairs(_multiSelected) do if on then count = count + 1 end end
    if _multiSelectMode then
        multiToggle.Text = count > 0
            and ("Select Multiple: ON  (" .. count .. " selected)")
            or "Select Multiple: ON"
        multiToggle.BackgroundColor3 = Color3.fromRGB(150,105,255)
    else
        multiToggle.Text = "Select Multiple: OFF"
        multiToggle.BackgroundColor3 = Color3.fromRGB(60,60,80)
    end
end

-- Search row: holds a magnifier icon + the actual TextBox so the placeholder
-- can be animated with a "Search... → Search.. → Search." typing cycle.
local searchRow = New("Frame", {
    Size=UDim2.new(1,-8,0,30), Position=UDim2.new(0,4,0,32),
    BackgroundColor3=Color3.fromRGB(24,24,30), BorderSizePixel=0,
    Parent=listContainer,
})
Corner(searchRow, 6)
Stroke(searchRow, Color3.fromRGB(50,45,80), 1, 0.2)

-- magnifier glyph (unicode) on the left
New("TextLabel", {
    Size=UDim2.new(0,22,1,0), Position=UDim2.new(0,8,0,0),
    BackgroundTransparency=1, Text="🔍",
    TextColor3=Color3.fromRGB(150,140,200),
    Font=Enum.Font.GothamBold, TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left, Parent=searchRow,
})

local searchBox = New("TextBox", {
    Size=UDim2.new(1,-32,1,0), Position=UDim2.new(0,30,0,0),
    BackgroundTransparency=1, BorderSizePixel=0,
    Text="", PlaceholderText="Search...",
    PlaceholderColor3=Color3.fromRGB(150,140,200),
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=12, ClearTextOnFocus=false, Parent=searchRow,
})

-- Animate the placeholder so it cycles "Search..." → "Search.." → "Search." → loop.
-- Pauses while focused or while there's text in the box.
do
    local frames = {"Search...", "Search..", "Search.", "Search.."}
    local i = 1
    task.spawn(function()
        while searchBox.Parent do
            if not searchBox:IsFocused() and (searchBox.Text == nil or searchBox.Text == "") then
                searchBox.PlaceholderText = frames[i]
                i = i + 1; if i > #frames then i = 1 end
            end
            task.wait(0.45)
        end
    end)
end

-- Subtle stroke pulse on focus
searchBox.Focused:Connect(function()
    for _, c in ipairs(searchRow:GetChildren()) do
        if c:IsA("UIStroke") then c.Color = Color3.fromRGB(150,105,255); c.Transparency = 0 end
    end
end)
searchBox.FocusLost:Connect(function()
    for _, c in ipairs(searchRow:GetChildren()) do
        if c:IsA("UIStroke") then c.Color = Color3.fromRGB(50,45,80); c.Transparency = 0.2 end
    end
end)

local listFrame = New("ScrollingFrame", {
    Size=UDim2.new(1,0,0,206), Position=UDim2.new(0,0,0,66),
    BackgroundColor3=BG, BorderSizePixel=0,
    ScrollBarThickness=3, ScrollBarImageColor3=Color3.fromRGB(150,105,255),
    CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    Parent=listContainer,
})
Corner(listFrame, 6)
Stroke(listFrame, Color3.fromRGB(50,50,70), 1, 0.3)
do
    local ul=Instance.new("UIListLayout",listFrame); ul.Padding=UDim.new(0,0)
    local up=Instance.new("UIPadding",listFrame)
    up.PaddingLeft=UDim.new(0,4); up.PaddingRight=UDim.new(0,4)
    up.PaddingTop=UDim.new(0,4); up.PaddingBottom=UDim.new(0,4)
end

animalToggleBtn.MouseButton1Click:Connect(function()
    listVisible = not listVisible
    animalToggleBtn.Text = listVisible and "▲  Select Animal" or "▼  Select Animal"
    listContainer.Visible = listVisible
end)


local animalBtns = {}
local function BuildAnimalList(filter)
    filter = (filter or ""):lower()
    for _,b in ipairs(animalBtns) do pcall(function() b:Destroy() end) end
    animalBtns = {}
    for _,group in ipairs(ANIMALS_BY_RARITY) do
        local rc = RARITY_COLORS[group.rarity] or TEXT
        for _,name in ipairs(group.names) do
            if filter=="" or name:lower():find(filter,1,true) then
                local sel = (selectedAnimal==name)
                local info = ANIMAL_DATA[name]
                local b = New("TextButton", {
                    Size=UDim2.new(1,0,0,30),
                    BackgroundColor3=sel and Color3.fromRGB(150,105,255) or BG,
                    BackgroundTransparency=0,
                    BorderSizePixel=0, AutoButtonColor=false, Text="", Parent=listFrame,
                })
                Corner(b,4)
                -- OG rarity gets a gold left stripe; all other rarities use their RARITY_COLORS value
                local stripeColor = rc
                if group.rarity == "OG" then
                    stripeColor = Color3.fromRGB(255, 215, 0)
                end
                New("Frame", {Size=UDim2.new(0,3,0.7,0), Position=UDim2.new(0,0,0.15,0), BackgroundColor3=stripeColor, BorderSizePixel=0, Parent=b})
                -- Brainrot icon from Fandom wiki (lazy-loaded, cached)
                local icon = New("ImageLabel", {
                    Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,8,0.5,-12),
                    BackgroundTransparency=1, Image="",
                    ScaleType=Enum.ScaleType.Fit, Parent=b,
                })
                do
                    local capturedIcon = icon
                    local capturedName = name
                    task.spawn(function()
                        -- Wait for the asset helper to be defined (it's set later in the file).
                        local waited = 0
                        while not _llGetBrainrotAsset and waited < 5 do
                            task.wait(0.05); waited = waited + 0.05
                        end
                        if not _llGetBrainrotAsset then return end
                        local ok, asset = pcall(_llGetBrainrotAsset, capturedName)
                        if ok and asset and capturedIcon and capturedIcon.Parent then
                            capturedIcon.Image = asset
                        end
                    end)
                end
                New("TextLabel", {
                    Size=UDim2.new(0.6,-36,1,0), Position=UDim2.new(0,36,0,0),
                    BackgroundTransparency=1, Text=name,
                    TextColor3=Color3.fromRGB(230,230,240),
                    Font=Enum.Font.GothamBold, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    TextTruncate=Enum.TextTruncate.AtEnd, Parent=b,
                })
                if info and info.price and info.price > 0 then
                    local function fmt(n)
                        local function clean(s,sx) return s:gsub("%.0+"..sx,sx):gsub("(%.%d-)0+"..sx,"%1"..sx) end
                        if n>=1e12 then return "$"..clean(string.format("%.1fT",n/1e12),"T")
                        elseif n>=1e9 then return "$"..clean(string.format("%.1fB",n/1e9),"B")
                        elseif n>=1e6 then return "$"..clean(string.format("%.1fM",n/1e6),"M")
                        elseif n>=1e3 then return "$"..clean(string.format("%.1fK",n/1e3),"K")
                        else return "$"..tostring(math.floor(n)) end
                    end
                    New("TextLabel", {
                        Size=UDim2.new(0.4,-8,1,0), Position=UDim2.new(0.6,0,0,0),
                        BackgroundTransparency=1, Text=fmt(info.price),
                        TextColor3=Color3.fromRGB(30,160,30),
                        Font=Enum.Font.GothamBold, TextSize=11,
                        TextXAlignment=Enum.TextXAlignment.Right, Parent=b,
                    })
                end
                -- color row according to current state
                local function _refreshRow()
                    if _multiSelectMode then
                        b.BackgroundColor3 = _multiSelected[name] and Color3.fromRGB(150,105,255) or BG
                    else
                        b.BackgroundColor3 = (selectedAnimal == name) and Color3.fromRGB(150,105,255) or BG
                    end
                end
                _refreshRow()
                b.MouseEnter:Connect(function()
                    if _multiSelectMode then
                        if not _multiSelected[name] then b.BackgroundColor3 = Color3.fromRGB(30,28,42) end
                    else
                        if selectedAnimal ~= name then b.BackgroundColor3 = Color3.fromRGB(30,28,42) end
                    end
                end)
                b.MouseLeave:Connect(function() _refreshRow() end)
                b.MouseButton1Click:Connect(function()
                    if _multiSelectMode then
                        -- toggle membership in the multi-select set, keep dropdown open
                        _multiSelected[name] = not _multiSelected[name] or nil
                        _refreshRow()
                        _refreshMultiToggle()
                        return
                    end
                    selectedAnimal = name
                    local animalRarity = "Secret"
                    for _,g in ipairs(ANIMALS_BY_RARITY) do
                        for _,n2 in ipairs(g.names) do
                            if n2==name then animalRarity=g.rarity; break end
                        end
                    end
                    rarityTag.Text = animalRarity:upper()
                    rarityTag.TextColor3 = RARITY_COLORS[animalRarity] or TEXT
                    selectedName.Text = name
                    _updateSelectedPrice()
                    -- close overlay after selecting
                    listVisible = false
                    listContainer.Visible = false
                    animalToggleBtn.Text = "▼  Select Animal"
                    BuildAnimalList(searchBox.Text)
                end)
                table.insert(animalBtns, b)
            end
        end
    end
end
BuildAnimalList("")
searchBox:GetPropertyChangedSignal("Text"):Connect(function() BuildAnimalList(searchBox.Text) end)

multiToggle.Activated:Connect(function()
    _multiSelectMode = not _multiSelectMode
    if not _multiSelectMode then
        _multiSelected = {}
    end
    _refreshMultiToggle()
    BuildAnimalList(searchBox.Text)
end)
_refreshMultiToggle()

-- ── TRAITS & MUTATIONS BUTTON ─────────────────────────────
local traitsBtn = New("TextButton", {
    Size=UDim2.new(1,0,0,32), BackgroundColor3=Color3.fromRGB(24,24,30),
    BorderSizePixel=0, Text="▼  Traits",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=12, AutoButtonColor=false, LayoutOrder=4, Parent=brainrotsPage,
})
Corner(traitsBtn, 6)
Stroke(traitsBtn, Color3.fromRGB(60,60,90), 1, 0.2)
traitsBtn.MouseEnter:Connect(function() traitsBtn.BackgroundColor3=Color3.fromRGB(30,28,42) end)
traitsBtn.MouseLeave:Connect(function() traitsBtn.BackgroundColor3=Color3.fromRGB(24,24,30) end)
local tmBtn = traitsBtn -- legacy alias for downstream code that still references tmBtn

-- ── QUANTITY ROW ─────────────────────────────────────────
local spawnCount = 1
local qtyRow = New("Frame", {
    Size=UDim2.new(1,0,0,34), BackgroundColor3=Color3.fromRGB(30,28,42),
    BorderSizePixel=0, LayoutOrder=8, Parent=brainrotsPage,
})
Corner(qtyRow, 6)
Stroke(qtyRow, Color3.fromRGB(50,50,70), 1, 0.3)

local minusBtn = New("TextButton", {
    Size=UDim2.new(0,40,1,0), Position=UDim2.new(0,0,0,0),
    BackgroundColor3=Color3.fromRGB(28,28,38),
    BorderSizePixel=0, Text="-", TextColor3=Color3.fromRGB(230,230,240),
    Font=Enum.Font.GothamBold, TextSize=18,
    AutoButtonColor=false, Parent=qtyRow,
})
Corner(minusBtn, 6)

local qtyLbl = New("TextLabel", {
    Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,40,0,0),
    BackgroundTransparency=1, Text="x1",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=13, Parent=qtyRow,
})

local plusBtn = New("TextButton", {
    Size=UDim2.new(0,40,1,0), Position=UDim2.new(1,-40,0,0),
    BackgroundColor3=Color3.fromRGB(28,28,38),
    BorderSizePixel=0, Text="+", TextColor3=Color3.fromRGB(230,230,240),
    Font=Enum.Font.GothamBold, TextSize=18,
    AutoButtonColor=false, Parent=qtyRow,
})
Corner(plusBtn, 6)

minusBtn.MouseButton1Click:Connect(function()
    spawnCount = math.max(1, spawnCount - 1); qtyLbl.Text = "x"..spawnCount
end)
plusBtn.MouseButton1Click:Connect(function()
    spawnCount = math.min(10, spawnCount + 1); qtyLbl.Text = "x"..spawnCount
end)
minusBtn.MouseEnter:Connect(function() minusBtn.BackgroundColor3=Color3.fromRGB(50,42,100) end)
minusBtn.MouseLeave:Connect(function() minusBtn.BackgroundColor3=Color3.fromRGB(28,28,38) end)
plusBtn.MouseEnter:Connect(function() plusBtn.BackgroundColor3=Color3.fromRGB(50,42,100) end)
plusBtn.MouseLeave:Connect(function() plusBtn.BackgroundColor3=Color3.fromRGB(28,28,38) end)

-- ── SPAWN BUTTON ─────────────────────────────────────────
local spawnBtn = New("TextButton", {
    Size=UDim2.new(1,0,0,40), BackgroundColor3=Color3.fromRGB(40,160,70),
    BorderSizePixel=0, Text="Spawn onto Podium",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold,
    TextSize=14, AutoButtonColor=false, LayoutOrder=9, Parent=brainrotsPage,
})
Corner(spawnBtn, 6)

spawnBtn.MouseEnter:Connect(function() spawnBtn.BackgroundColor3=Color3.fromRGB(50,180,80) end)
spawnBtn.MouseLeave:Connect(function() spawnBtn.BackgroundColor3=Color3.fromRGB(40,160,70) end)


local statusLbl = New("TextLabel", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, Text="", TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold, TextSize=10, TextXAlignment=Enum.TextXAlignment.Center, Parent=brainrotsPage, Visible=false})
local countLbl = New("TextLabel", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, Text="", TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamSemibold, TextSize=10, TextXAlignment=Enum.TextXAlignment.Center, Parent=brainrotsPage, Visible=false})

-- ── TRAITS DROPDOWN (inline) ─────────────────────────────
local traitsVisible = false
local tmPopup = New("Frame", {
    Size=UDim2.new(1,0,0,176),
    BackgroundColor3=Color3.fromRGB(20,20,28),
    BorderSizePixel=0, ClipsDescendants=true,
    Visible=false, LayoutOrder=5, Parent=brainrotsPage,
})
Corner(tmPopup, 6)
Stroke(tmPopup, Color3.fromRGB(50,45,80), 1, 0.2)

traitsBtn.MouseButton1Click:Connect(function()
    traitsVisible = not traitsVisible
    tmPopup.Visible = traitsVisible
    _updateTraitsBtnText()
end)

local traitsGrid = New("ScrollingFrame", {
    Size=UDim2.new(1,0,1,-8), Position=UDim2.new(0,0,0,4),
    BackgroundColor3=BG, BorderSizePixel=0,
    ScrollBarThickness=3, ScrollBarImageColor3=Color3.fromRGB(150,105,255),
    CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    Parent=tmPopup,
})
Corner(traitsGrid, 6)
do
    local ul=Instance.new("UIListLayout",traitsGrid); ul.Padding=UDim.new(0,0)
    local up=Instance.new("UIPadding",traitsGrid)
    up.PaddingLeft=UDim.new(0,4); up.PaddingRight=UDim.new(0,4)
    up.PaddingTop=UDim.new(0,4); up.PaddingBottom=UDim.new(0,4)
end

local function _updateTraitsBtnText()
    local sel = {}
    for trait, on in pairs(selectedTraits) do
        if on then table.insert(sel, trait) end
    end
    local arrow = traitsVisible and "▲" or "▼"
    if #sel == 0 then
        traitsBtn.Text = arrow .. "  Traits"
    else
        local listed = table.concat(sel, ", ")
        if #listed > 24 then listed = #sel .. " selected" end
        traitsBtn.Text = arrow .. "  Traits  •  " .. listed
    end
end

local traitBtns = {}
for _,trait in ipairs(TRAITS) do
    local sel = selectedTraits[trait] == true
    local b = New("TextButton", {
        Size=UDim2.new(1,0,0,30),
        BackgroundColor3=sel and Color3.fromRGB(150,105,255) or BG,
        BorderSizePixel=0, AutoButtonColor=false, Text="",
        Parent=traitsGrid,
    })
    Corner(b,4)
    local icon = TRAIT_ICONS[trait]
    if icon then
        New("ImageLabel", {
            Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,8,0.5,-12),
            BackgroundTransparency=1, Image=icon, Parent=b,
        })
    else
        New("Frame", {
            Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,8,0.5,-12),
            BackgroundColor3=Color3.fromRGB(50,45,80), BorderSizePixel=0, Parent=b,
        })
    end
    New("TextLabel", {
        Size=UDim2.new(1,-44,1,0), Position=UDim2.new(0,36,0,0),
        BackgroundTransparency=1, Text=trait,
        TextColor3=Color3.fromRGB(230,230,240),
        Font=Enum.Font.GothamBold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=b,
    })
    traitBtns[trait] = b
    b.MouseEnter:Connect(function()
        if not selectedTraits[trait] then b.BackgroundColor3 = Color3.fromRGB(30,28,42) end
    end)
    b.MouseLeave:Connect(function()
        if not selectedTraits[trait] then b.BackgroundColor3 = BG end
    end)
    b.MouseButton1Click:Connect(function()
        selectedTraits[trait] = not selectedTraits[trait]
        local s = selectedTraits[trait]
        b.BackgroundColor3 = s and Color3.fromRGB(150,105,255) or BG
        _updateTraitsBtnText()
        _updateSelectedPrice()
    end)
end


-- ── MUTATION DROPDOWN (inline, separate) ─────────────────
local mutationsBtn = New("TextButton", {
    Size=UDim2.new(1,0,0,32), BackgroundColor3=Color3.fromRGB(24,24,30),
    BorderSizePixel=0, Text="▼  Mutation",
    TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
    TextSize=12, AutoButtonColor=false, LayoutOrder=6, Parent=brainrotsPage,
})
Corner(mutationsBtn, 6)
Stroke(mutationsBtn, Color3.fromRGB(60,60,90), 1, 0.2)
mutationsBtn.MouseEnter:Connect(function() mutationsBtn.BackgroundColor3=Color3.fromRGB(30,28,42) end)
mutationsBtn.MouseLeave:Connect(function() mutationsBtn.BackgroundColor3=Color3.fromRGB(24,24,30) end)

local mutationsVisible = false
local mutPopup = New("Frame", {
    Size=UDim2.new(1,0,0,176),
    BackgroundColor3=Color3.fromRGB(20,20,28),
    BorderSizePixel=0, ClipsDescendants=true,
    Visible=false, LayoutOrder=7, Parent=brainrotsPage,
})
Corner(mutPopup, 6)
Stroke(mutPopup, Color3.fromRGB(50,45,80), 1, 0.2)

local function _updateMutationsBtnText()
    local arrow = mutationsVisible and "▲" or "▼"
    if not selectedMutation or selectedMutation == "None" then
        mutationsBtn.Text = arrow .. "  Mutation"
    else
        mutationsBtn.Text = arrow .. "  Mutation  •  " .. selectedMutation
    end
end

mutationsBtn.MouseButton1Click:Connect(function()
    mutationsVisible = not mutationsVisible
    mutPopup.Visible = mutationsVisible
    _updateMutationsBtnText()
end)

local mutGrid = New("ScrollingFrame", {
    Size=UDim2.new(1,0,1,-8), Position=UDim2.new(0,0,0,4),
    BackgroundColor3=BG, BorderSizePixel=0,
    ScrollBarThickness=3, ScrollBarImageColor3=Color3.fromRGB(150,105,255),
    CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
    Parent=mutPopup,
})
Corner(mutGrid, 6)
do
    local ul=Instance.new("UIListLayout",mutGrid); ul.Padding=UDim.new(0,0)
    local up=Instance.new("UIPadding",mutGrid)
    up.PaddingLeft=UDim.new(0,4); up.PaddingRight=UDim.new(0,4)
    up.PaddingTop=UDim.new(0,4); up.PaddingBottom=UDim.new(0,4)
end

local mutBtns = {}
for _,mut in ipairs(MUTATIONS) do
    local sel = (mut==selectedMutation)
    local b = New("TextButton", {
        Size=UDim2.new(1,0,0,30),
        BackgroundColor3=sel and Color3.fromRGB(150,105,255) or BG,
        BorderSizePixel=0, AutoButtonColor=false, Text="",
        Parent=mutGrid,
    })
    Corner(b,4)
    local icon = MUTATION_ICONS[mut]
    if icon and icon ~= "" then
        New("ImageLabel", {
            Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,8,0.5,-12),
            BackgroundTransparency=1, Image=icon, Parent=b,
        })
    else
        -- None button — draw a small X
        local xFrame = New("Frame", {Size=UDim2.new(0,20,0,20), Position=UDim2.new(0,10,0.5,-10), BackgroundTransparency=1, Parent=b})
        New("Frame", {Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,0.5,-1), BackgroundColor3=Color3.fromRGB(180,60,60), BorderSizePixel=0, Rotation=45, Parent=xFrame})
        New("Frame", {Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,0.5,-1), BackgroundColor3=Color3.fromRGB(180,60,60), BorderSizePixel=0, Rotation=-45, Parent=xFrame})
    end
    New("TextLabel", {
        Size=UDim2.new(1,-44,1,0), Position=UDim2.new(0,36,0,0),
        BackgroundTransparency=1, Text=(mut=="None") and "Normal" or mut,
        TextColor3=Color3.fromRGB(230,230,240),
        Font=Enum.Font.GothamBold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=b,
    })
    mutBtns[mut] = b
    b.MouseEnter:Connect(function()
        if selectedMutation ~= mut then b.BackgroundColor3 = Color3.fromRGB(30,28,42) end
    end)
    b.MouseLeave:Connect(function()
        if selectedMutation ~= mut then b.BackgroundColor3 = BG end
    end)
    b.MouseButton1Click:Connect(function()
        selectedMutation = mut
        for m,btn in pairs(mutBtns) do
            btn.BackgroundColor3 = (m==mut) and Color3.fromRGB(150,105,255) or BG
        end
        _updateMutationsBtnText()
        _updateSelectedPrice()
    end)
end

local function SetStatus(msg,col,dur)
    pcall(function()
        statusLbl.Text=msg; statusLbl.TextColor3=col or Color3.fromRGB(230,230,240)
    end)
    if dur then task.delay(dur,function() pcall(function()
        statusLbl.Text="Ready"; statusLbl.TextColor3=Color3.fromRGB(230,230,240)
    end) end) end
end
local function UpdateCount()
    local alive={}
    for _,m in ipairs(spawnedModels) do
        if m and m.Parent then table.insert(alive, m) end
    end
    spawnedModels=alive
    pcall(function() countLbl.Text="Spawned: "..#spawnedModels end)
    if LocalPlayer:GetAttribute("IsTrading") then
        task.defer(UpdateTradeCounts)
    end
end

-- ── VISUAL BASE SKIN ─────────────────────────────────────
do
    local SKIN_FILE = "NewBases.rbxmx"
    local SKIN_FILE_LEGACY = "BaseSkinsKing.rbxmx"  -- old file name; auto-migrate if present

    local SKINS = {
        { name = "Skibidi",       brainrot = "Skibidi Toilet"       },
        { name = "Headless",      brainrot = "Headless Horseman"    },
        { name = "Meowl",         brainrot = "Meowl"               },
        { name = "Strawberry",    brainrot = "Strawberry Elephant"  },
        { name = "Christmas",     brainrot = nil                    },
        { name = "Galaxy",        brainrot = nil                    },
        { name = "Rainbow",       brainrot = nil                    },
        { name = "Valentines",    brainrot = nil                    },
        { name = "Bunny Basket",  brainrot = nil                    },
        { name = "Divine",        brainrot = nil                    },
        { name = "Cursed",        brainrot = nil                    },
        { name = "Cyber",         brainrot = nil                    },
        { name = "John Pork",    brainrot = "John Pork"            },
    }

    local function getPlayerFloor()
        local rebirths = 0
        pcall(function()
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            if ls and ls:FindFirstChild("Rebirths") then
                rebirths = ls.Rebirths.Value or 0
            end
        end)
        if rebirths >= 10 then return "ThirdFloor" end
        if rebirths >= 2  then return "SecondFloor" end
        return "FirstFloor"
    end

    -- Returns true if the named brainrot is currently on the player's plot,
    -- whether as a real podium animal (server data) OR a KV fake spawn.
    local function _hasBrainrot(name)
        if not name then return true end  -- skin has no brainrot requirement
        for _, m in ipairs(spawnedModels) do
            if m and m.Parent and m.Name == name then return true end
        end
        local ok, found = pcall(function()
            local ch = GetSyncChannel()
            local pods = ch and ch:Get("AnimalPodiums") or {}
            for _, v in pairs(pods) do
                if type(v) == "table" and v.Index == name then return true end
                if type(v) == "string" and v == name then return true end
            end
            return false
        end)
        return ok and found or false
    end

    local function getAvailableSkins()
        -- All non-OG skins (Christmas, Galaxy, Rainbow, etc.) show always.
        -- OG skins (Skibidi, Headless, Meowl, Strawberry, John Pork) only show
        -- if you currently have that brainrot on your plot. Deleting/trading
        -- it away makes the skin disappear from the list and reverts the look.
        local available = {}
        for _, skin in ipairs(SKINS) do
            if skin.brainrot == nil or _hasBrainrot(skin.brainrot) then
                table.insert(available, skin)
            end
        end
        return available
    end

    local _skinFolder      = nil
    local _skinLoading     = false
    local _activeSkinClone = nil
    local _hiddenParts     = {}
    local _selectedSkin    = nil

    local neverHide = {
        Spawn=true, MainRoot=true, Hitbox=true,
        AnimalPodiums=true, Claim=true, Multiplier=true,
        DeliveryBox=true, DeliveryHitbox=true, CollectZone=true,
        Laser=true, LaserHitbox=true, StealHitbox=true,
        PlotBlock=true, FriendPanel=true, CashPad=true,
        FirstFloor=true, SecondFloor=true, ThirdFloor=true,
    }

    local function isInsideProtected(obj, plot)
        local p = obj.Parent
        while p and p ~= plot do
            if neverHide[p.Name] then return true end
            if p:FindFirstChildOfClass("Humanoid") then return true end
            if p:GetAttribute("Animal") or p:GetAttribute("Mutation") then return true end
            p = p.Parent
        end
        return false
    end

    local function hidePlotParts(plot)
        for _, obj in plot:GetDescendants() do
            if obj:IsA("BasePart")
            and not neverHide[obj.Name]
            and not obj:GetAttribute("IgnoreColor")
            and not isInsideProtected(obj, plot)
            and obj.Transparency < 1 then
                _hiddenParts[obj] = obj.LocalTransparencyModifier
                obj.LocalTransparencyModifier = 1
            end
        end
    end

    local function showPlotParts()
        for obj, v in pairs(_hiddenParts) do
            if typeof(obj) == "Instance" and obj.Parent then
                pcall(function() obj.LocalTransparencyModifier = v end)
            end
        end
        _hiddenParts = {}
    end

    local SKIN_URL = "https://files.catbox.moe/gsqcuv.rbxmx"

    -- start downloading immediately in background so it's ready when needed
    task.spawn(function()
        local haveFile = false
        pcall(function() haveFile = isfile(SKIN_FILE) end)
        -- If the new-named file isn't present but the old one is, copy it over
        if not haveFile then
            local haveLegacy = false
            pcall(function() haveLegacy = isfile(SKIN_FILE_LEGACY) end)
            if haveLegacy then
                pcall(function()
                    local data = readfile(SKIN_FILE_LEGACY)
                    if data and #data > 100 then writefile(SKIN_FILE, data) end
                end)
                pcall(function() haveFile = isfile(SKIN_FILE) end)
            end
        end
        if not haveFile then
            pcall(function()
                local data = game:HttpGet(SKIN_URL)
                if data and #data > 100 then
                    writefile(SKIN_FILE, data)
                end
            end)
        end
    end)

    local function loadSkinModels(callback)
        if _skinFolder then callback(_skinFolder); return end
        if _skinLoading then SetStatus("Still loading skins...", Color3.fromRGB(255,150,50), 2); return end
        _skinLoading = true
        SetStatus("Loading skin models...", Color3.fromRGB(150,105,255), 0)
        task.spawn(function()
            local haveFile = false
            pcall(function() haveFile = isfile(SKIN_FILE) end)

            -- migrate from legacy filename if user has the old one
            if not haveFile then
                local haveLegacy = false
                pcall(function() haveLegacy = isfile(SKIN_FILE_LEGACY) end)
                if haveLegacy then
                    pcall(function()
                        local data = readfile(SKIN_FILE_LEGACY)
                        if data and #data > 100 then writefile(SKIN_FILE, data) end
                    end)
                    pcall(function() haveFile = isfile(SKIN_FILE) end)
                end
            end

            if not haveFile then
                SetStatus("Downloading base skins...", Color3.fromRGB(150,105,255), 0)
                local ok, data = pcall(function()
                    return game:HttpGet(SKIN_URL)
                end)
                if ok and data and #data > 100 then
                    pcall(function() writefile(SKIN_FILE, data) end)
                    pcall(function() haveFile = isfile(SKIN_FILE) end)
                end
                if not haveFile then
                    SetStatus("Failed to download skins — check HTTP access", Color3.fromRGB(255,80,80), 7)
                    _skinLoading = false; callback(nil); return
                end
                SetStatus("Skins downloaded! Loading...", Color3.fromRGB(40,200,80), 2)
            end

            local objs = nil
            -- try getcustomasset first (most executors)
            if type(getcustomasset) == "function" then
                local ok, url = pcall(getcustomasset, SKIN_FILE)
                if ok and type(url) == "string" then
                    pcall(function() objs = game:GetObjects(url) end)
                end
            end
            -- fallback: rbxasset://
            if not objs or (type(objs) == "table" and #objs == 0) then
                pcall(function() objs = game:GetObjects("rbxasset://" .. SKIN_FILE) end)
            end
            -- fallback: getsynasset (Synapse)
            if (not objs or (type(objs) == "table" and #objs == 0)) and type(getsynasset) == "function" then
                local ok2, url2 = pcall(getsynasset, SKIN_FILE)
                if ok2 and type(url2) == "string" then
                    pcall(function() objs = game:GetObjects(url2) end)
                end
            end

            _skinLoading = false
            if not objs or type(objs) ~= "table" or #objs == 0 then
                SetStatus("GetObjects failed for skins — see F9", Color3.fromRGB(255,80,80), 7)
                callback(nil); return
            end

            -- find Skins folder in loaded objects
            local folder = nil
            for _, o in ipairs(objs) do
                if typeof(o) ~= "Instance" then continue end
                if o.Name == "Skins" then folder = o; break end
                local s = o:FindFirstChild("Skins")
                if s then folder = s; break end
                for _, c in o:GetChildren() do
                    if c.Name == "Skins" then folder = c; break end
                end
                if folder then break end
                if o:FindFirstChild("Skibidi") then folder = o; break end
            end
            if not folder and #objs == 1 and typeof(objs[1]) == "Instance" then
                folder = objs[1]
            end

            if folder then
                _skinFolder = folder
                local names = {}
                for _, c in folder:GetChildren() do table.insert(names, c.Name) end
                SetStatus("Skins loaded: " .. table.concat(names, ", "), Color3.fromRGB(40,200,80), 4)
                callback(folder)
            else
                SetStatus("Skins folder not found in model", Color3.fromRGB(255,150,50), 5)
                callback(nil)
            end
        end)
    end

    -- ── LASER RECOLOR (Cyber skin) ───────────────────────────
    -- The visible laser is a Beam instance (with ColorSequence + NumberSequence transparency)
    -- inside the plot's "Laser" model. Recolor those when Cyber is applied.
    local LASER_LOOKS = {
        Cyber = {
            beamColor = ColorSequence.new(Color3.fromRGB(80, 200, 255)),
            beamTransparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,    0.4),
                NumberSequenceKeypoint.new(0.5,  0.85),
                NumberSequenceKeypoint.new(1,    0.4),
            }),
            -- Optional fallback for any BaseParts that are part of the laser body
            partColor        = Color3.fromRGB(80, 200, 255),
            partMaterial     = Enum.Material.Neon,
            partTransparency = 0.6,
        },
    }
    -- saved state: { instance -> {kind = "beam"|"part", ...orig props...} }
    local _originalLaserState = {}
    local _activeLaserSkin = nil
    local _laserStreamConn = nil

    -- A part counts as "laser-related" if any ancestor or sibling-folder is named Laser/LaserHitbox,
    -- OR if its own name contains "Laser", OR if it visibly is a Beam.
    local function _isLaserLike(inst, plot)
        if inst:IsA("Beam") then return true end
        local nameHint = inst.Name and (inst.Name:lower():find("laser") ~= nil)
        if nameHint then return true end
        local p = inst.Parent
        while p and p ~= plot do
            local pname = p.Name
            if pname == "Laser" or pname == "LaserHitbox" then return true end
            -- also look at the parent's siblings: a "Laser" folder right next to us
            local pp = p.Parent
            if pp then
                if pp:FindFirstChild("Laser") or pp:FindFirstChild("LaserHitbox") then
                    -- only count if the part's own name hints at being part of the laser visual
                    if nameHint then return true end
                end
            end
            p = p.Parent
        end
        return false
    end

    local function _restoreLasers()
        if _laserStreamConn then pcall(function() _laserStreamConn:Disconnect() end); _laserStreamConn = nil end
        _activeLaserSkin = nil
        for inst, st in pairs(_originalLaserState) do
            if typeof(inst) == "Instance" and inst.Parent then
                pcall(function()
                    if st.kind == "beam" then
                        inst.Color        = st.Color
                        inst.Transparency = st.Transparency
                    else
                        inst.Color        = st.Color
                        inst.Material     = st.Material
                        inst.Transparency = st.Transparency
                    end
                end)
            end
        end
        _originalLaserState = {}
    end

    local function _isReddish(c)
        return c.R > 0.6 and c.G < 0.4 and c.B < 0.4
    end

    -- Skip anything inside these named ancestors — they're not lasers
    local LASER_BLOCKLIST_ANCESTORS = {
        Claim = true, CashPad = true, Multiplier = true, AnimalPodiums = true,
        DeliveryBox = true, FriendPanel = true, PlotSign = true, SkinPlotSign = true,
    }
    local function _hasBlockedAncestor(d, plot)
        local p = d.Parent
        while p and p ~= plot do
            if LASER_BLOCKLIST_ANCESTORS[p.Name] then return true end
            p = p.Parent
        end
        return false
    end
    -- Conversely: must be inside a Laser/LaserHitbox folder
    local function _hasLaserAncestor(d, plot)
        local p = d.Parent
        while p and p ~= plot do
            if p.Name == "Laser" or p.Name == "LaserHitbox" then return true end
            p = p.Parent
        end
        return false
    end

    -- Apply our laser look to a single newly-spotted part or beam
    local function _applyLaserLookTo(d, look)
        if _originalLaserState[d] then return end
        local plot = GetPlayerPlot()
        if not plot then return end
        if _hasBlockedAncestor(d, plot) then return end

        if d:IsA("Beam") then
            -- Only recolor Beams whose host is laser-related
            local host = d.Parent
            local hostIsLaser = false
            if host then
                local lower = host.Name:lower()
                hostIsLaser = (lower:find("laser") ~= nil)
                    or lower:find("structure base home") ~= nil
                    or _hasLaserAncestor(host, plot)
            end
            if not hostIsLaser then return end
            _originalLaserState[d] = { kind = "beam", Color = d.Color, Transparency = d.Transparency }
            pcall(function()
                d.Color        = look.beamColor
                d.Transparency = look.beamTransparency
            end)
        elseif d:IsA("BasePart") and d.Name ~= "LaserHitbox" and d.Transparency < 1 then
            local lower = d.Name:lower()
            local nameLooksLaser = lower:find("laser") ~= nil
                or lower:find("structure base home") ~= nil
            local underLaser = _hasLaserAncestor(d, plot)
            -- Strict: must be inside a Laser folder OR have a laser-like name.
            -- Reddish-only parts are NOT recolored (cashpad/etc. would be blue otherwise).
            if nameLooksLaser or underLaser then
                _originalLaserState[d] = {
                    kind = "part",
                    Color = d.Color, Material = d.Material, Transparency = d.Transparency,
                }
                pcall(function()
                    d.Color        = look.partColor
                    d.Material     = look.partMaterial
                    d.Transparency = look.partTransparency
                end)
            end
        end
    end

    -- Sync our chosen skin into the game's actual Settings UI dropdown so the
    -- player sees their selection persisted there. Called whenever a skin is
    -- applied AND whenever the Settings UI becomes visible.
    function _syncBaseSkinToGameSettings(skinName)
        if not skinName or skinName == "" then return end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        local sGui = pg:FindFirstChild("Settings")
        if not sGui then return end
        local sFrame = sGui:FindFirstChild("Settings")
        if not sFrame then return end
        local cont = sFrame:FindFirstChild("Content")
        if not cont then return end
        local scroll = cont:FindFirstChild("ScrollingFrame")
        if not scroll then return end
        local baseSkinRow
        for _, child in scroll:GetChildren() do
            if child:IsA("Frame") and child.Name == "Base Skin" then baseSkinRow = child; break end
        end
        if not baseSkinRow then return end
        local btn = baseSkinRow:FindFirstChild("Button")
        if not btn then return end
        local colors = SKIN_COLORS[skinName]
        if colors then
            btn.BackgroundColor3 = colors.main
            local s = btn:FindFirstChildOfClass("UIStroke")
            if s then s.Color = colors.stroke end
            local t = btn:FindFirstChild("Text")
            if t and t:IsA("TextLabel") then t.Text = skinName end
        end
    end

    -- Watch the Settings UI: every time it becomes visible/enabled, re-apply
    -- our skin so the dropdown reflects the active selection (the game would
    -- otherwise overwrite our visual sync each time it re-renders).
    task.spawn(function()
        local hookedSettings = nil
        local function hook(sg)
            if hookedSettings == sg then return end
            hookedSettings = sg
            local function reapply()
                if not _selectedSkin or _selectedSkin == "" then return end
                for i = 1, 8 do
                    task.delay(i * 0.1, function()
                        pcall(_syncBaseSkinToGameSettings, _selectedSkin)
                    end)
                end
            end
            sg:GetPropertyChangedSignal("Enabled"):Connect(function()
                if sg.Enabled then reapply() end
            end)
            local inner = sg:FindFirstChild("Settings")
            if inner then
                inner:GetPropertyChangedSignal("Visible"):Connect(function()
                    if inner.Visible then reapply() end
                end)
            end
            sg.DescendantAdded:Connect(function(d)
                -- a new "Base Skin" row got created → re-sync next frame
                if d.Name == "Base Skin" or (d.Parent and d.Parent.Name == "Base Skin") then
                    task.defer(reapply)
                end
            end)
        end
        while true do
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local sg = pg and pg:FindFirstChild("Settings")
            if sg then hook(sg) end
            task.wait(1)
        end
    end)

    local function _recolorLasersForSkin(skinName)
        _restoreLasers()
        if _laserStreamConn then pcall(function() _laserStreamConn:Disconnect() end); _laserStreamConn = nil end
        _activeLaserSkin = skinName
        local look = LASER_LOOKS[skinName]
        if not look then return end
        local plot = GetPlayerPlot()
        if not plot then return end

        -- Listen for new descendants that stream in while this skin is active
        _laserStreamConn = plot.DescendantAdded:Connect(function(d)
            if _activeLaserSkin ~= skinName then return end
            local cur = LASER_LOOKS[_activeLaserSkin]
            if not cur then return end
            if d:IsA("Beam") or d:IsA("BasePart") then
                -- defer one frame so part properties are populated
                task.defer(function() _applyLaserLookTo(d, cur) end)
            end
        end)

        -- Initial pass: recolor everything that's already streamed in
        for _, d in plot:GetDescendants() do
            _applyLaserLookTo(d, look)
        end

        -- Safety re-scans in case more parts stream in late
        for _, t in ipairs({0.5, 1.5, 3.0, 6.0}) do
            task.delay(t, function()
                if _activeLaserSkin ~= skinName then return end
                local p = GetPlayerPlot()
                if not p then return end
                local cur = LASER_LOOKS[_activeLaserSkin]
                if not cur then return end
                for _, d in p:GetDescendants() do
                    _applyLaserLookTo(d, cur)
                end
            end)
        end
    end

    local function removeSkin()
        if _activeSkinClone then
            pcall(function() _activeSkinClone:Destroy() end)
            _activeSkinClone = nil
        end
        showPlotParts()
        _restoreLasers()
        _selectedSkin = nil
        _savedBaseSkin = nil
        ScheduleSave()
        SetStatus("Visual base removed", Color3.fromRGB(150,150,180), 2)
    end

    local function applySkin(skinName, folder)
        local skinEntry = folder:FindFirstChild(skinName)
        if not skinEntry then
            local found = {}
            for _, c in folder:GetChildren() do table.insert(found, c.Name) end
            SetStatus("Skin not found. Available: " .. table.concat(found, ", "), Color3.fromRGB(255,80,80), 6)
            return
        end

        local plot = GetPlayerPlot()
        if not plot then
            SetStatus("Stand on your plot first!", Color3.fromRGB(255,150,50), 3); return
        end

        local plotMainRoot = plot:FindFirstChild("MainRoot")
            or plot:FindFirstChild("Spawn")
        if not plotMainRoot then
            SetStatus("Plot root part not found", Color3.fromRGB(255,80,80), 3); return
        end

        -- pick the correct floor model based on player's rebirth level
        local floorName = getPlayerFloor()
        local floorModel = skinEntry:FindFirstChild(floorName)
        if not floorModel then
            -- fallback: try ThirdFloor > SecondFloor > FirstFloor > raw skin
            floorModel = skinEntry:FindFirstChild("ThirdFloor")
                or skinEntry:FindFirstChild("SecondFloor")
                or skinEntry:FindFirstChild("FirstFloor")
                or skinEntry
        end

        if _activeSkinClone then
            pcall(function() _activeSkinClone:Destroy() end)
            _activeSkinClone = nil
        end
        showPlotParts()

        local clone = floorModel:Clone()
        clone.Name = "KV_ActiveBaseSkin"

        for _, desc in clone:GetDescendants() do
            if desc:IsA("ProximityPrompt") or desc:IsA("PathfindingModifier") then
                pcall(function() desc:Destroy() end)
            end
        end

        for _, obj in clone:GetDescendants() do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) then
                pcall(function()
                    if obj.Text:find("{playerName}") then
                        obj.Text = obj.Text:gsub("{playerName} Base", LocalPlayer.DisplayName .. "'s Base")
                        obj.Text = obj.Text:gsub("{playerName}", LocalPlayer.DisplayName)
                    end
                    -- fix hardcoded builder names on SkinPlotSign
                    if obj.Text:find("'s Base") and not obj.Text:find(LocalPlayer.DisplayName) then
                        obj.Text = LocalPlayer.DisplayName .. "'s Base"
                    end
                end)
            end
        end

        -- if skin has its own SkinPlotSign, remove the duplicate PlotSign
        local hasSkinPlotSign = clone:FindFirstChild("SkinPlotSign", true) ~= nil
        for _, desc in clone:GetDescendants() do
            local n = desc.Name
            if n == "CashPad" or n == "FriendPanel" or n == "AnimalPodiums"
            or n == "Laser" or n == "LaserHitbox" or n == "Claim"
            or n == "Multiplier" or n == "PlotBlock" or n == "YourBase"
            or (n == "PlotSign" and hasSkinPlotSign) then
                pcall(function() desc:Destroy() end)
            end
        end

        for _, obj in clone:GetDescendants() do
            if obj:IsA("BasePart") then
                obj.CanCollide = false; obj.CanQuery = false
                obj.CanTouch = false; obj.Anchored = true
            end
        end

        clone.Parent = workspace

        local plotCF = plotMainRoot.CFrame
        local skinRoot = clone:FindFirstChild("Root", true)
        local virtualRootCF = nil

        if skinRoot then
            virtualRootCF = skinRoot.CFrame
        else
            local parts = {}
            for _, d in clone:GetDescendants() do
                if d:IsA("BasePart") then table.insert(parts, d) end
            end
            if #parts > 0 then
                local gMinX, gMinZ = math.huge, math.huge
                local gMaxX, gMaxZ = -math.huge, -math.huge
                local groundY = 0.5
                local foundFloor = false
                for _, p in ipairs(parts) do
                    local area = p.Size.X * p.Size.Z
                    if p.Position.Y < 5 and area > 50 then
                        local pos = p.Position
                        local half = p.Size / 2
                        gMinX = math.min(gMinX, pos.X - half.X)
                        gMinZ = math.min(gMinZ, pos.Z - half.Z)
                        gMaxX = math.max(gMaxX, pos.X + half.X)
                        gMaxZ = math.max(gMaxZ, pos.Z + half.Z)
                    end
                    if area > 100 and p.Position.Y < 3 then
                        local refY = p.Position.Y - p.Size.Y * 0.15
                        if not foundFloor or refY < groundY then
                            groundY = refY
                            foundFloor = true
                        end
                    end
                end
                if gMinX == math.huge then
                    for _, p in ipairs(parts) do
                        local pos = p.Position
                        local half = p.Size / 2
                        gMinX = math.min(gMinX, pos.X - half.X)
                        gMinZ = math.min(gMinZ, pos.Z - half.Z)
                        gMaxX = math.max(gMaxX, pos.X + half.X)
                        gMaxZ = math.max(gMaxZ, pos.Z + half.Z)
                    end
                end
                virtualRootCF = CFrame.new((gMinX+gMaxX)/2, groundY, (gMinZ+gMaxZ)/2)
            end
        end

        if virtualRootCF then
            local rot = math.rad(0)
            local offset = plotCF * CFrame.Angles(0, rot, 0) * virtualRootCF:Inverse()
            for _, obj in clone:GetDescendants() do
                if obj:IsA("BasePart") then
                    obj.CFrame = offset * obj.CFrame
                end
            end
            if skinRoot then
                pcall(function() skinRoot:Destroy() end)
            end
        end

        hidePlotParts(plot)
        _activeSkinClone = clone
        _selectedSkin = skinName
        _savedBaseSkin = skinName
        _recolorLasersForSkin(skinName)
        ScheduleSave()
        SetStatus("Visual base: " .. skinName, Color3.fromRGB(40,200,80), 3)

        -- sync to game settings dropdown button
        pcall(_syncBaseSkinToGameSettings, skinName)
        do
            -- (legacy inline sync kept below, also runs the same way)
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            local sGui = pg and pg:FindFirstChild("Settings")
            local sFrame = sGui and sGui:FindFirstChild("Settings")
            local cont = sFrame and sFrame:FindFirstChild("Content")
            local scroll = cont and cont:FindFirstChild("ScrollingFrame")
            local baseSkinRow
            if scroll then
                for _, child in scroll:GetChildren() do
                    if child:IsA("Frame") and child.Name == "Base Skin" then baseSkinRow = child; break end
                end
            end
            local btn = baseSkinRow and baseSkinRow:FindFirstChild("Button")
            local colors = SKIN_COLORS[skinName]
            if btn and colors then
                btn.BackgroundColor3 = colors.main
                local s = btn:FindFirstChildOfClass("UIStroke")
                if s then s.Color = colors.stroke end
                local t = btn:FindFirstChild("Text")
                if t and t:IsA("TextLabel") then t.Text = skinName end
            end
        end
    end

    -- UI section
    New("TextLabel", {
        Size=UDim2.new(1,0,0,14), BackgroundTransparency=1,
        Text="BASE SKIN CHANGER", TextColor3=ACCENT,
        Font=Enum.Font.GothamBold, TextSize=9,
        TextXAlignment=Enum.TextXAlignment.Left,
        LayoutOrder=1, Parent=basePage,
    })

    -- toggle button (matches animal toggle style)
    local skinListVisible = false
    local skinToggleBtn = New("TextButton", {
        Size=UDim2.new(1,0,0,32), BackgroundColor3=Color3.fromRGB(24,24,30),
        BorderSizePixel=0, Text="▼  Select Base Skin",
        TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
        TextSize=12, AutoButtonColor=false, LayoutOrder=2, Parent=basePage,
    })
    Corner(skinToggleBtn, 6)
    Stroke(skinToggleBtn, Color3.fromRGB(60,60,90), 1, 0.2)
    skinToggleBtn.MouseEnter:Connect(function() skinToggleBtn.BackgroundColor3=Color3.fromRGB(30,28,42) end)
    skinToggleBtn.MouseLeave:Connect(function() skinToggleBtn.BackgroundColor3=Color3.fromRGB(24,24,30) end)

    -- inline dropdown panel (matches animal/traits/mutation pattern)
    local skinListPanel = New("Frame", {
        Size=UDim2.new(1, 0, 0, 240),
        BackgroundColor3=Color3.fromRGB(30,28,42),
        BorderSizePixel=0, ClipsDescendants=true,
        Visible=false, LayoutOrder=3, Parent=basePage,
    })
    Corner(skinListPanel, 6)
    Stroke(skinListPanel, Color3.fromRGB(50,45,80), 1, 0.2)

    local skinApplyBtn = New("TextButton", {
        Size=UDim2.new(1,0,0,32), BackgroundColor3=BTNGRN,
        Text="Apply Skin", TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false,
        BorderSizePixel=0, LayoutOrder=4, Parent=basePage,
    })
    Corner(skinApplyBtn, 5)
    skinApplyBtn.MouseEnter:Connect(function() skinApplyBtn.BackgroundColor3=Color3.fromRGB(60,200,100) end)
    skinApplyBtn.MouseLeave:Connect(function() skinApplyBtn.BackgroundColor3=BTNGRN end)

    local skinRemoveBtn = New("TextButton", {
        Size=UDim2.new(1,0,0,32), BackgroundColor3=BTNRED,
        Text="Reset Base", TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false,
        BorderSizePixel=0, LayoutOrder=5, Parent=basePage,
    })
    Corner(skinRemoveBtn, 5)
    skinRemoveBtn.MouseEnter:Connect(function() skinRemoveBtn.BackgroundColor3=Color3.fromRGB(220,60,60) end)
    skinRemoveBtn.MouseLeave:Connect(function() skinRemoveBtn.BackgroundColor3=BTNRED end)

    local skinListFrame = New("ScrollingFrame", {
        Size=UDim2.new(1,0,1,0), Position=UDim2.new(0,0,0,0),
        BackgroundColor3=BG, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=Color3.fromRGB(150,105,255),
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Parent=skinListPanel,
    })
    Corner(skinListFrame, 6)
    Stroke(skinListFrame, Color3.fromRGB(50,50,70), 1, 0.3)
    do
        local ul=Instance.new("UIListLayout",skinListFrame); ul.Padding=UDim.new(0,0)
        local up=Instance.new("UIPadding",skinListFrame)
        up.PaddingLeft=UDim.new(0,4); up.PaddingRight=UDim.new(0,4)
        up.PaddingTop=UDim.new(0,4); up.PaddingBottom=UDim.new(0,4)
    end

    local skinBtns = {}
    local function BuildSkinList()
        for _,b in ipairs(skinBtns) do pcall(function() b:Destroy() end) end
        skinBtns = {}
        local available = getAvailableSkins()
        if #available == 0 then
            local lbl = New("TextLabel", {
                Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
                Text="No skins available — try spawning a brainrot!",
                TextColor3=Color3.fromRGB(150,140,180), Font=Enum.Font.Gotham,
                TextSize=11, Parent=skinListFrame,
            })
            table.insert(skinBtns, lbl)
            return
        end
        for _, skin in ipairs(available) do
            local sel = (_selectedSkin == skin.name)
            local b = New("TextButton", {
                Size=UDim2.new(1,0,0,30),
                BackgroundColor3=sel and Color3.fromRGB(150,105,255) or BG,
                BackgroundTransparency=0,
                BorderSizePixel=0, AutoButtonColor=false, Text="", Parent=skinListFrame,
            })
            Corner(b, 4)
            New("TextLabel", {
                Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1, Text=skin.name,
                TextColor3=Color3.fromRGB(230,230,240),
                Font=Enum.Font.GothamBold, TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=b,
            })
            b.MouseEnter:Connect(function()
                if _selectedSkin ~= skin.name then b.BackgroundColor3=Color3.fromRGB(30,28,42) end
            end)
            b.MouseLeave:Connect(function()
                if _selectedSkin ~= skin.name then b.BackgroundColor3=BG end
            end)
            b.MouseButton1Click:Connect(function()
                _selectedSkin = skin.name
                skinListVisible = false
                skinListPanel.Visible = false
                skinToggleBtn.Text = "▼  " .. skin.name
            end)
            table.insert(skinBtns, b)
        end
    end

    skinToggleBtn.MouseButton1Click:Connect(function()
        skinListVisible = not skinListVisible
        local arrow = skinListVisible and "▲" or "▼"
        skinToggleBtn.Text = arrow .. "  " .. (_selectedSkin or "Select Base Skin")
        if skinListVisible then
            local ok, err = pcall(BuildSkinList)
            if not ok then
                SetStatus("Skin list build failed: " .. tostring(err), Color3.fromRGB(255,80,80), 4)
            end
        end
        skinListPanel.Visible = skinListVisible
    end)

    skinApplyBtn.Activated:Connect(function()
        if not _selectedSkin then
            SetStatus("Select a base skin first!", Color3.fromRGB(255,150,50), 2); return
        end
        local available = getAvailableSkins()
        local stillValid = false
        for _, s in ipairs(available) do
            if s.name == _selectedSkin then stillValid = true; break end
        end
        if not stillValid then
            SetStatus("That skin requires a specific brainrot spawned!", Color3.fromRGB(255,150,50), 3)
            _selectedSkin = nil
            skinToggleBtn.Text = "▼  Select Base Skin"
            return
        end
        loadSkinModels(function(folder)
            if folder then applySkin(_selectedSkin, folder) end
        end)
    end)

    skinRemoveBtn.Activated:Connect(function()
        removeSkin()
        skinToggleBtn.Text = "▼  Select Base Skin"
    end)

    local _lastAvailableCount = #getAvailableSkins()
    RunService.Heartbeat:Connect(function()
        if _activeSkinClone and not _activeSkinClone.Parent then
            _activeSkinClone = nil; showPlotParts()
        end
        if _activeSkinClone and _selectedSkin then
            local needed = nil
            for _, s in ipairs(SKINS) do
                if s.name == _selectedSkin then needed = s.brainrot; break end
            end
            if needed then -- only auto-remove for brainrot-gated skins
                -- Use the unified helper so REAL podium brainrots (server data)
                -- are also recognised — not just KV fakes. This way trading or
                -- selling the OG triggers the auto-revert to default.
                if not _hasBrainrot(needed) then
                    removeSkin()
                    skinToggleBtn.Text = "▼  Select Base Skin"
                    SetStatus(needed.." gone — base skin reset", Color3.fromRGB(255,150,50), 3)
                end
            end
        end
        local curCount = #getAvailableSkins()
        if curCount ~= _lastAvailableCount then
            _lastAvailableCount = curCount
            if injectIntoGameUI then task.defer(injectIntoGameUI) end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        if _activeSkinClone and _selectedSkin then
            task.delay(2, function()
                if not _activeSkinClone or not _activeSkinClone.Parent then return end
                _hiddenParts = {}
                local plot = GetPlayerPlot()
                if plot then hidePlotParts(plot) end
            end)
        end
    end)

    -- re-hide plot parts when the game adds new descendants (sell/trade refreshes plot)
    local _plotConn = nil
    local function watchPlot()
        if _plotConn then pcall(function() _plotConn:Disconnect() end) end
        local plot = GetPlayerPlot()
        if not plot then return end
        _plotConn = plot.DescendantAdded:Connect(function(desc)
            if not _activeSkinClone or not _activeSkinClone.Parent then return end
            task.defer(function()
                if desc:IsA("BasePart")
                and not neverHide[desc.Name]
                and not desc:GetAttribute("IgnoreColor")
                and not isInsideProtected(desc, plot)
                and desc.Transparency < 1 then
                    _hiddenParts[desc] = desc.LocalTransparencyModifier
                    desc.LocalTransparencyModifier = 1
                end
            end)
        end)
    end
    task.spawn(function()
        task.wait(3)
        watchPlot()
    end)

    -- ── INJECT INTO GAME'S BASE SKIN UI ──────────────────────
    local SKIN_COLORS = {
        Skibidi          = { main = Color3.fromRGB(255, 255, 255), stroke = Color3.fromRGB(220, 220, 220) },
        Headless         = { main = Color3.fromRGB(126, 68, 227),  stroke = Color3.fromRGB(100, 50, 190)  },
        Meowl            = { main = Color3.fromRGB(255, 255, 20),  stroke = Color3.fromRGB(220, 220, 10)  },
        Strawberry       = { main = Color3.fromRGB(207, 59, 63),   stroke = Color3.fromRGB(180, 50, 50)   },
        Christmas        = { main = Color3.fromRGB(255, 67, 67),   stroke = Color3.fromRGB(220, 50, 50)   },
        Galaxy           = { main = Color3.fromRGB(130, 60, 255),  stroke = Color3.fromRGB(100, 40, 220)  },
        Rainbow          = { main = Color3.fromRGB(255, 100, 150), stroke = Color3.fromRGB(220, 80, 130)  },
        Valentines       = { main = Color3.fromRGB(227, 100, 187), stroke = Color3.fromRGB(200, 80, 160)  },
        ["Bunny Basket"] = { main = Color3.fromRGB(168, 224, 108), stroke = Color3.fromRGB(140, 200, 90)  },
        Divine           = { main = Color3.fromRGB(255, 209, 59),  stroke = Color3.fromRGB(220, 180, 40)  },
        Cursed           = { main = Color3.fromRGB(245, 56, 56),   stroke = Color3.fromRGB(210, 40, 40)   },
        ["John Pork"]    = { main = Color3.fromRGB(255, 143, 179), stroke = Color3.fromRGB(220, 120, 155) },
    }
    local _injectedBtns = {}

    local function injectIntoGameUI()
        -- Clear previous KV injections
        for _, b in ipairs(_injectedBtns) do pcall(function() b:Destroy() end) end
        _injectedBtns = {}

        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        local settingsGui = pg:FindFirstChild("Settings")
        if not settingsGui then return end
        local settingsFrame = settingsGui:FindFirstChild("Settings")
        if not settingsFrame then return end
        local content = settingsFrame:FindFirstChild("Content")
        if not content then return end
        local scrollFrame = content:FindFirstChild("ScrollingFrame")
        if not scrollFrame then return end

        local baseSkinRow
        for _, child in scrollFrame:GetChildren() do
            if child:IsA("Frame") and child.Name == "Base Skin" then
                baseSkinRow = child; break
            end
        end
        if not baseSkinRow then return end

        local button = baseSkinRow:FindFirstChild("Button")
        if not button then return end

        -- Sync the main button to currently-active skin
        if _selectedSkin and SKIN_COLORS[_selectedSkin] then
            local colors = SKIN_COLORS[_selectedSkin]
            button.BackgroundColor3 = colors.main
            local ms = button:FindFirstChildOfClass("UIStroke")
            if ms then ms.Color = colors.stroke end
            local mt = button:FindFirstChild("Text")
            if mt and mt:IsA("TextLabel") then mt.Text = _selectedSkin end
        end

        local dropDown = button:FindFirstChild("DropDown")
        if not dropDown then return end

        -- Find the template button (always invisible, named "Template")
        local template = dropDown:FindFirstChild("Template")
        if not template then
            for _, c in dropDown:GetChildren() do
                if (c:IsA("ImageButton") or c:IsA("Frame")) and not c.Visible then
                    template = c; break
                end
            end
        end
        if not template then return end

        -- Before hiding, grab a real button's size so our clones match.
        -- We read AbsoluteSize (the rendered pixel size) not Size, because some
        -- of the game's buttons use Scale sizing where Size.Y.Offset = 0.
        local refSize = template.Size
        local refAbsY = 0
        local function grabRefSize(parent)
            for _, c in parent:GetChildren() do
                if c == template then continue end
                if c.Name:sub(1,3) == "KV_" then continue end
                if (c:IsA("ImageButton") or c:IsA("TextButton") or c:IsA("Frame"))
                   and c.Visible and c.AbsoluteSize.Y > 20 then
                    refSize = c.Size
                    refAbsY = c.AbsoluteSize.Y
                    return true
                end
            end
            return false
        end
        if not grabRefSize(dropDown) then
            local existingWrap0 = dropDown:FindFirstChild("KV_ScrollWrap")
            if existingWrap0 then grabRefSize(existingWrap0) end
        end
        -- If the game's buttons used Scale-only sizing, convert to a pixel-based
        -- size so our clones are guaranteed the same actual height even if they
        -- end up in a wrapper with different relative parent.
        if refSize.Y.Scale > 0 and refAbsY > 0 then
            refSize = UDim2.new(refSize.X.Scale, refSize.X.Offset, 0, refAbsY)
        end

        -- HIDE every existing real game button in the dropdown. We don't destroy
        -- them (the game might re-show on its own re-render), just Visible=false.
        local function hideRealButtons(parent)
            for _, c in parent:GetChildren() do
                if c == template then continue end
                if c.Name:sub(1,3) == "KV_" then continue end
                if c:IsA("UIListLayout") or c:IsA("UIPadding") or c:IsA("UIGridLayout") then continue end
                if c:IsA("GuiObject") then c.Visible = false end
            end
        end
        hideRealButtons(dropDown)
        local existingWrap = dropDown:FindFirstChild("KV_ScrollWrap")
        if existingWrap then hideRealButtons(existingWrap) end

        -- Inject one cloned-template button for every available skin
        local available = getAvailableSkins()
        for i, skin in ipairs(available) do
            local btn = template:Clone()
            btn.Name = "KV_" .. skin.name
            btn.Visible = true
            btn.LayoutOrder = i
            btn.Size = refSize  -- exactly match the game's real button dimensions

            local colors = SKIN_COLORS[skin.name] or { main = Color3.fromRGB(150,105,255), stroke = Color3.fromRGB(80,70,130) }
            btn.BackgroundColor3 = colors.main
            local btnStroke = btn:FindFirstChildOfClass("UIStroke")
            if btnStroke then btnStroke.Color = colors.stroke end

            local textLbl = btn:FindFirstChild("Text")
            if textLbl and textLbl:IsA("TextLabel") then
                textLbl.Text = skin.name
                local textStroke = textLbl:FindFirstChildOfClass("UIStroke")
                if textStroke then textStroke.Color = colors.stroke end
            end

            -- Hide any lock icons (we're treating every skin as unlocked here)
            for _, d in ipairs(btn:GetDescendants()) do
                if d.Name == "Locked" and (d:IsA("ImageLabel") or d:IsA("Frame")) then
                    d.Visible = false
                end
            end

            btn.Parent = dropDown

            -- Determine the actual clickable element
            local clickTarget
            if btn:IsA("ImageButton") or btn:IsA("TextButton") then
                clickTarget = btn
            else
                clickTarget = btn:FindFirstChildWhichIsA("ImageButton") or btn:FindFirstChildWhichIsA("TextButton")
                if not clickTarget then
                    local overlay = Instance.new("TextButton")
                    overlay.Name = "KV_Click"
                    overlay.Size = UDim2.new(1,0,1,0)
                    overlay.BackgroundTransparency = 1
                    overlay.Text = ""
                    overlay.ZIndex = 100
                    overlay.Parent = btn
                    clickTarget = overlay
                end
            end
            clickTarget.Activated:Connect(function()
                loadSkinModels(function(folder)
                    if not folder then return end
                    applySkin(skin.name, folder)
                    _selectedSkin = skin.name
                    skinToggleBtn.Text = "▼  " .. skin.name
                    local mainText = button:FindFirstChild("Text")
                    if mainText and mainText:IsA("TextLabel") then mainText.Text = skin.name end
                    button.BackgroundColor3 = colors.main
                    local mainStroke = button:FindFirstChildOfClass("UIStroke")
                    if mainStroke then mainStroke.Color = colors.stroke end
                end)
            end)
            table.insert(_injectedBtns, btn)
        end

        -- Make the dropdown scrollable so all our skins fit
        pcall(function()
            if not dropDown:FindFirstChild("KV_ScrollWrap") then
                local wrap = Instance.new("ScrollingFrame")
                wrap.Name = "KV_ScrollWrap"
                wrap.Size = UDim2.new(1, 0, 0, 250)
                wrap.BackgroundTransparency = 1
                wrap.BorderSizePixel = 0
                wrap.ScrollBarThickness = 6  -- thicker so it doesn't look skinny
                wrap.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)  -- neutral grey, not purple
                wrap.AutomaticCanvasSize = Enum.AutomaticSize.Y
                wrap.CanvasSize = UDim2.new(0, 0, 0, 0)
                wrap.Parent = dropDown
                -- copy the dropDown's UIListLayout into wrap if it has one
                local existingLayout = dropDown:FindFirstChildOfClass("UIListLayout")
                if existingLayout then
                    local lc = existingLayout:Clone(); lc.Parent = wrap
                end
                -- move our KV buttons into wrap
                for _, b in ipairs(_injectedBtns) do
                    b.Parent = wrap
                end
            else
                local wrap = dropDown:FindFirstChild("KV_ScrollWrap")
                for _, b in ipairs(_injectedBtns) do b.Parent = wrap end
            end

            dropDown.AutomaticSize = Enum.AutomaticSize.None
            dropDown.Size = UDim2.new(dropDown.Size.X.Scale, dropDown.Size.X.Offset, 0, 260)

            local listLayout = scrollFrame:FindFirstChildOfClass("UIListLayout")
            if listLayout then
                scrollFrame.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y + 20)
            end
        end)
    end

    task.spawn(function()
        task.wait(3)
        injectIntoGameUI()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
        if pg then
            pg.DescendantAdded:Connect(function(desc)
                task.defer(function()
                    pcall(function()
                        if desc.Name == "Base Skin" and desc:IsA("Frame") then
                            task.wait(0.5)
                            injectIntoGameUI()
                        end
                    end)
                end)
            end)
            local settingsGui = pg:FindFirstChild("Settings")
            if settingsGui then
                local settingsFrame = settingsGui:FindFirstChild("Settings")
                if settingsFrame then
                    settingsFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                        if settingsFrame.Visible then
                            task.wait(0.3)
                            injectIntoGameUI()
                        end
                    end)
                end
            end
        end
    end)

    -- pre-load skin models in background so applying is instant
    task.spawn(function()
        loadSkinModels(function() end)
    end)

    if _savedBaseSkin and _savedBaseSkin ~= "" and autoRestoreEnabled then
        task.spawn(function()
            local deadline = tick() + 35
            while #spawnedModels == 0 and tick() < deadline do
                task.wait(0.5)
            end
            task.wait(1)
            local skinName = _savedBaseSkin
            local available = getAvailableSkins()
            local valid = false
            for _, s in ipairs(available) do
                if s.name == skinName then valid = true; break end
            end
            if not valid then return end
            loadSkinModels(function(folder)
                if folder then
                    applySkin(skinName, folder)
                    skinToggleBtn.Text = "▼  " .. skinName
                    SetStatus("Auto-restored base: " .. skinName, Color3.fromRGB(50,200,100), 3)
                    -- sync to game settings once it loads
                    task.spawn(function()
                        for _ = 1, 20 do
                            task.wait(1)
                            pcall(function()
                                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                                if not pg then return end
                                local sGui = pg:FindFirstChild("Settings")
                                if not sGui then return end
                                local sFrame = sGui:FindFirstChild("Settings")
                                if not sFrame then return end
                                local cont = sFrame:FindFirstChild("Content")
                                if not cont then return end
                                local scroll = cont:FindFirstChild("ScrollingFrame")
                                if not scroll then return end
                                local baseSkinRow = nil
                                for _, child in scroll:GetChildren() do
                                    if child:IsA("Frame") and child.Name == "Base Skin" then baseSkinRow = child; break end
                                end
                                if not baseSkinRow then return end
                                local btn = baseSkinRow:FindFirstChild("Button")
                                if not btn then return end
                                local colors = SKIN_COLORS[skinName]
                                if colors then
                                    btn.BackgroundColor3 = colors.main
                                    local s = btn:FindFirstChildOfClass("UIStroke")
                                    if s then s.Color = colors.stroke end
                                    local t = btn:FindFirstChild("Text")
                                    if t and t:IsA("TextLabel") then t.Text = skinName end
                                end
                            end)
                            -- check if it worked
                            local done = false
                            pcall(function()
                                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                                local sGui = pg and pg:FindFirstChild("Settings")
                                local sFrame = sGui and sGui:FindFirstChild("Settings")
                                local cont = sFrame and sFrame:FindFirstChild("Content")
                                local scroll = cont and cont:FindFirstChild("ScrollingFrame")
                                if not scroll then return end
                                for _, child in scroll:GetChildren() do
                                    if child:IsA("Frame") and child.Name == "Base Skin" then
                                        local btn = child:FindFirstChild("Button")
                                        local t = btn and btn:FindFirstChild("Text")
                                        if t and t:IsA("TextLabel") and t.Text == skinName then done = true end
                                        break
                                    end
                                end
                            end)
                            if done then break end
                        end
                    end)
                end
            end)
        end)
    end
end

-- ── SPAWN ────────────────────────────────────────────────
-- SpawnOneAnimal: set upvalues then invoke spawn loop once

local _pendingSpawns = {}  -- queue of {name, mutation, traits} to spawn
local _slotOverride  = nil -- when non-nil, DoSpawn targets this exact podium key
local DoSpawn  -- forward declaration
local function SpawnOneAnimal(animalName, mutation, traitsArr)
    table.insert(_pendingSpawns, {name=animalName, mutation=mutation or "None", traits=traitsArr or {}})
    pcall(InjectToGameIndex, animalName, mutation or "None")
end

local function DrainPendingSpawns()
    if #_pendingSpawns == 0 then return end
    local copy = {}
    for _, v in ipairs(_pendingSpawns) do table.insert(copy, v) end
    _pendingSpawns = {}
    task.spawn(function()
        for _, pending in ipairs(copy) do
            local savedA = selectedAnimal
            local savedM = selectedMutation
            local savedT = selectedTraits
            local savedC = spawnCount
            selectedAnimal   = pending.name
            selectedMutation = pending.mutation
            selectedTraits   = {}
            for _, t in ipairs(pending.traits) do selectedTraits[t] = true end
            spawnCount = 1
            -- call the real spawn handler
            DoSpawn()
            task.wait(0.05)  -- let task.spawns inside DoSpawn capture upvalues
            selectedAnimal   = savedA
            selectedMutation = savedM
            selectedTraits   = savedT
            spawnCount       = savedC
            task.wait(0.1)
        end
        _pendingSpawns = {}
    end)
end

DoSpawn = function()
    if not selectedAnimal then
        SetStatus("⚠ Select an animal first!",Color3.fromRGB(255,120,50),2); return
    end
    local modelTemplate = FindAnimalModel(selectedAnimal)
    local useAnchorRenderer = false
    if not modelTemplate then
        warn("[KV V11] No direct template found for", selectedAnimal, "-- trying Shared.Animals:GetAnimatedModel before renderer fallback")
    end
    local plot=GetPlayerPlot()
    if not plot then
        SetStatus("⚠ Could not find your plot!",Color3.fromRGB(255,80,80),3); return
    end
    local podiumSpawns=GetPodiumSpawns(plot)
    if #podiumSpawns==0 then
        SetStatus("⚠ No podium slots found!",Color3.fromRGB(255,80,80),3); return
    end
    for _spawnI = 1, spawnCount do
    plot=GetPlayerPlot()
    podiumSpawns=GetPodiumSpawns(plot or plot)
    local slotIndex = nil
    local spawnPart = nil
    local serverPods = {}
    pcall(function()
        local ch = GetSyncChannel()
        serverPods = ch and ch:Get("AnimalPodiums") or {}
    end)
    local sortedPodiumNames = {}
    if plot then
        local podiums2 = plot:FindFirstChild("AnimalPodiums")
        if podiums2 then
            for _, pod in podiums2:GetChildren() do
                local n = tonumber(pod.Name)
                if n then table.insert(sortedPodiumNames, n) end
            end
            table.sort(sortedPodiumNames)
        end
    end
    if _slotOverride then
        for i, sp in ipairs(podiumSpawns) do
            if sortedPodiumNames[i] == _slotOverride then
                local podiumKey = sortedPodiumNames[i]
                local serverAnimal = podiumKey and serverPods[podiumKey]
                local occupied = IsServerPodOccupied(serverAnimal)
                if not occupied then
                    occupied = IsLocalSlotOccupied(sp)
                end
                if not occupied then
                    slotIndex = podiumKey
                    spawnPart = sp
                end
                break
            end
        end
    end
    if not slotIndex then
        for i, sp in ipairs(podiumSpawns) do
            local occupied = false
            local podiumKey = sortedPodiumNames[i]
            if podiumKey then
                local serverAnimal = serverPods[podiumKey]
                occupied = IsServerPodOccupied(serverAnimal)
            end
            if not occupied then
                occupied = IsLocalSlotOccupied(sp)
            end
            if not occupied then
                slotIndex = sortedPodiumNames[i] or i
                spawnPart = sp
                break
            end
        end
    end
    if not slotIndex then
        SetStatus("All podium slots are full!", Color3.fromRGB(255,120,50), 2)
        return
    end
    local snapshotTraits = {}
    for t, on in pairs(selectedTraits) do
        if on then table.insert(snapshotTraits, t) end
    end

    local model
    local anchorMode = false

    -- KV V11: prefer a real direct animated model for EVERY brainrot. This is
    -- what the actual podium renderer does. The old Animal-tag fallback uses
    -- road-animal placement and is why dragons were sideways and Headless floated.
    model = _kvBuildDirectAnimalModel(selectedAnimal, modelTemplate)

    if model then
        model.Parent = plot or workspace
        model:SetAttribute("KVSpawned", true)
        model:SetAttribute("KVDirectPodiumModel", true)
        _kvPlaceDirectAnimalOnPodium(model, spawnPart)
    else
        warn("[KV V11] Direct model failed for", selectedAnimal, "-- using final tagged-renderer fallback")
        model = CreateAnimalAnchorModel(selectedAnimal, selectedMutation, snapshotTraits, spawnPart)
        anchorMode = true
    end

    -- Direct podium models are already placed the official way. Do NOT run the
    -- manual body-bounds aligner; it causes huge/flying animals to drift.
    if anchorMode then
        -- Last-resort fallback only. Keep it on the cloned Spawn part and let
        -- the game's renderer handle it.
    end
    modelSnapshots[model] = {mutation = selectedMutation, traits = snapshotTraits}
    pcall(InjectToGameIndex, selectedAnimal, selectedMutation)
    local baseExtY = 4
    pcall(function() baseExtY = math.max(4, model:GetExtentsSize().Y) end)
    if not anchorMode then
        pcall(ApplyMutation, model, selectedAnimal, selectedMutation)
        if #snapshotTraits>0 then pcall(ApplyTraits, model, selectedAnimal, snapshotTraits) end
    end
    local _animName = selectedAnimal
    task.spawn(function()
        task.wait()
        pcall(function()
            local ac = model:FindFirstChildOfClass("AnimationController")
            local animator = ac and ac:FindFirstChildOfClass("Animator")
            local animFolder = FindAnimalAnimationFolder(_animName)
            if animator and animFolder then
                local idle = animFolder:FindFirstChild("Idle")
                if idle then
                    local track = animator:LoadAnimation(idle)
                    track.Looped = true
                    track:Play()
                end
            end
        end)
    end)
    local animalRarity = "Common"
    for _, group in ipairs(ANIMALS_BY_RARITY) do
        for _, name in ipairs(group.names) do
            if name == selectedAnimal then animalRarity = group.rarity; break end
        end
    end
    -- KV V7: Do NOT create a second custom nameplate when using the game's
    -- AnimalTemplate renderer. The game already creates the real overhead for
    -- tagged Animal anchors, and adding our own caused double text on Headless
    -- and other rendered animals. Direct cloned models still need this custom
    -- overhead, so keep it only for non-anchor spawns.
    if not anchorMode then
    pcall(function()
        local rarityData = require(RS.Datas.Rarities)
        local mutData    = require(RS.Datas.Mutations)
        local Gradients  = require(RS.Packages.Gradients)
        local att = model:FindFirstChild("OVERHEAD_ATTACHMENT", true)
        if not att then
            local overheadMod = 1
            pcall(function()
                local aData = require(RS.Datas.Animals)[selectedAnimal]
                if aData and aData.OverheadYOffsetModifier then
                    overheadMod = aData.OverheadYOffsetModifier
                end
            end)
            att = Instance.new("Attachment")
            att.Name = "OVERHEAD_ATTACHMENT"
            att.CFrame = CFrame.new(0, baseExtY * 0.75 * overheadMod, 0)
            att.Parent = spawnPart
        end
        local focScript = RS.Controllers.FastOverheadController
        local part = focScript.FastOverheadTemplate:Clone()
        pcall(function() part:SetAttribute("KVCustomAnimalOverhead", true) end)
        part.Size = Vector3.new(15, 5, 0.1)
        part.CFrame = CFrame.new(0, 10000, 0)
        part.Parent = workspace.Debris
        local motor = part:FindFirstChild("__foh_transform")
        if not motor then
            motor = Instance.new("Motor6D"); motor.Name = "__foh_transform"; motor.Parent = part
        end
        motor.Part0 = workspace.Terrain; motor.Part1 = part; part.Anchored = false
        local gui = focScript.AnimalOverhead:Clone()
        pcall(function() gui.AlwaysOnTop = false end)
        gui.Adornee = part
        gui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        gui.MaxDistance = 72
        gui.Parent = part
        modelOverheads[model] = {part = part, gui = gui, att = att}
        local dn = gui:FindFirstChild("DisplayName")
        if dn then dn.Text = _displayNameFor(selectedAnimal, selectedTraits) end
        local animalRarity = "Secret"
        for _, group in ipairs(ANIMALS_BY_RARITY) do
            for _, name in ipairs(group.names) do
                if name == selectedAnimal then animalRarity = group.rarity; break end
            end
        end
        local rarLbl = gui:FindFirstChild("Rarity")
        if rarLbl then
            rarLbl.Text = animalRarity
            local rc = rarityData and rarityData[animalRarity]
            local rarColor = (rc and rc.Color) or RARITY_COLORS[animalRarity] or Color3.new(1,1,1)
            rarLbl.TextColor3 = rarColor
            rarLbl.Visible = true
            if rc and rc.GradientPreset then
                pcall(function()
                    local preset = rc.GradientPreset
                    rarLbl.TextColor3 = Color3.new(1,1,1)
                    local mainGrad = rarLbl:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", rarLbl)
                    mainGrad.Rotation = 90
                    mainGrad.Transparency = NumberSequence.new(0)
                    local stroke = rarLbl:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", rarLbl)
                    stroke.Color = Color3.new(0,0,0)
                    local strokeGrad = stroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", stroke)
                    strokeGrad.Rotation = 90
                    strokeGrad.Transparency = NumberSequence.new(0)
                    local ok = pcall(function()
                        local Gradients2 = require(RS.Packages.Gradients)
                        Gradients2.apply(rarLbl, preset)
                    end)
                    if not ok then
                        local STATIC = {
                            YellowRed = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(1,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))}),
                            GreenRed  = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))}),
                            Zebra     = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.24,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.26,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.49,Color3.new(0,0,0)),ColorSequenceKeypoint.new(0.51,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.74,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.76,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))}),
                        }
                        if STATIC[preset] then mainGrad.Color = STATIC[preset] end
                        local ColorUtils = pcall(require, RS.Packages.Gradients.ColorSequenceUtils) and require(RS.Packages.Gradients.ColorSequenceUtils)
                        if ColorUtils then
                            local BASE = {
                                OG      = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(1,1,0))}),
                                Rainbow = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.17,Color3.new(1,0.5,0)),ColorSequenceKeypoint.new(0.33,Color3.new(1,1,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0,1,0)),ColorSequenceKeypoint.new(0.67,Color3.new(0,0,1)),ColorSequenceKeypoint.new(0.83,Color3.new(0.5,0,1)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))}),
                            }
                            local SPEED = {OG=1, Rainbow=0.5, Zebra=0.5}
                            if BASE[preset] or STATIC[preset] then
                                local base = BASE[preset] or STATIC[preset]
                                local offset = 0
                                local ac; ac = RunService.PostSimulation:Connect(function(dt)
                                    if not rarLbl or not rarLbl.Parent then ac:Disconnect(); return end
                                    offset = (offset + dt * (SPEED[preset] or 0.5)) % 1
                                    mainGrad.Color = ColorUtils.calculateColorSequence(base, offset)
                                end)
                            end
                        end
                    end
                end)
            end
        end
        local mut = gui:FindFirstChild("Mutation")
        if mut then
            if selectedMutation ~= "None" and mutData and mutData[selectedMutation] then
                local md = mutData[selectedMutation]
                if md.UseRichText then
                    mut.RichText = true
                    mut.Text = md.DisplayWithRichText or md.DisplayText or selectedMutation
                else
                    mut.Text = md.DisplayText or selectedMutation
                end
                if md.GradientPreset then
                    local ok2, err2 = pcall(function() Gradients.apply(mut, md.GradientPreset) end)
                    if not ok2 then warn("Gradient mutation error:", err2) end
                else
                    mut.TextColor3 = md.MainColor or Color3.new(1,1,1)
                end
                mut.Visible = true
            else
                mut.Visible = false
            end
        end
        local function fmt(n)
            local function clean(s, suffix)
                return s:gsub("%.0+"..suffix, suffix):gsub("(%.%d-)0+"..suffix, "%1"..suffix)
            end
            if n >= 1e12 then return clean(string.format("%.1fT", n/1e12), "T")
            elseif n >= 1e9 then return clean(string.format("%.1fB", n/1e9), "B")
            elseif n >= 1e6 then return clean(string.format("%.1fM", n/1e6), "M")
            elseif n >= 1e3 then return clean(string.format("%.1fK", n/1e3), "K")
            else return tostring(math.floor(n)) end
        end
        local animalInfo = ANIMAL_DATA[selectedAnimal]
        local realGen = CalcGeneration(selectedAnimal, selectedMutation, selectedTraits)
        local gen = gui:FindFirstChild("Generation")
        if gen then
            if realGen > 0 then
                gen.Text = "$"..fmt(realGen).."/s"
                gen.TextColor3 = Color3.fromRGB(255, 247, 0)
                gen.Visible = true
            else
                gen.Visible = false
            end
        end
        local priceLbl = gui:FindFirstChild("Price")
        if priceLbl then
            if animalInfo and animalInfo.price and animalInfo.price > 0 then
                priceLbl.Text = "$"..fmt(animalInfo.price)
                priceLbl.TextColor3 = Color3.fromRGB(115, 255, 0)
                priceLbl.Visible = true
            else
                priceLbl.Visible = false
            end
        end
        local stolen = gui:FindFirstChild("Stolen")
        if stolen then stolen.Visible = false end
        local traitsFrame = gui:FindFirstChild("Traits")
        local template = traitsFrame and traitsFrame:FindFirstChild("Template")
        if traitsFrame and template then
            traitsFrame.ClipsDescendants = false
            local liveTraitData = nil
            pcall(function() liveTraitData = require(RS.Datas.Traits) end)
            local count = 0
            for trait, on in pairs(selectedTraits) do
                if on then
                    local icon = TRAIT_ICONS[trait]
                        or (liveTraitData and liveTraitData[trait] and liveTraitData[trait].Icon)
                    if icon then
                        local img = template:Clone()
                        img.Image = icon
                        img.Visible = true
                        img.Parent = traitsFrame
                        count = count + 1
                    end
                end
            end
            traitsFrame.Visible = count > 0
        end
        local conn
        conn = RunService.Stepped:Connect(function()
            if not model or not model.Parent then
                pcall(function() part:Destroy() end); conn:Disconnect(); return
            end
            local camCF = workspace.CurrentCamera.CFrame
            local headPos = GetModelOverheadPosition(model, selectedAnimal, spawnPart, baseExtY) or (model:GetPivot().Position + Vector3.new(0, baseExtY, 0))
            local pos = headPos + camCF.UpVector * 0.35
            motor.Transform = CFrame.lookAlong(pos, -camCF.LookVector)
            local dist = (camCF.Position - headPos).Magnitude
            if dist < 40 then
                gui.CanvasSize = Vector2.new(340, 113)
            elseif dist < 72 then
                gui.CanvasSize = Vector2.new(220, 73)
            else
                gui.CanvasSize = Vector2.new(0, 0)
            end
        end)
        model.AncestryChanged:Connect(function()
            if not model:IsDescendantOf(workspace) then
                pcall(function() part:Destroy() end); conn:Disconnect()
            end
        end)
    end)
    end
    pcall(function()
        local MUTATION_MODIFIER = {
            Gold=0.25, Diamond=0.5, Bloodrot=1, Rainbow=9, Candy=3,
            Lava=5, Galaxy=6, YinYang=6.5, Radioactive=7.5, Cursed=8, Divine=9,
        }
        local TRAIT_MODIFIER = {
            Taco=2, Nyan=5, Galactic=3, Fireworks=5, Zombie=4, Claws=4,
            Glitched=4, Bubblegum=3, Fire=5, Wet=1.5, Snowy=2, Cometstruck=2.5,
            Explosive=3, Disco=4, ["10B"]=3, ["Shark Fin"]=3, ["Matteo Hat"]=3.5,
            Brazil=5, Sleepy=0, Lightning=5, UFO=2, Spider=3.5, Strawberry=8,
            Paint=5, Skeleton=3, Sombrero=4, Tie=3.75, ["Witch Hat"]=3,
            Indonesia=4, Meowl=7, ["John Pork"]=6.5, ["RIP Gravestone"]=3.5, ["Jackolantern Pet"]=4.5,
            ["Santa Hat"]=4, ["Reindeer Pet"]=5, Skibidi=6, ["26"]=5, Rose=5,
            Chocolate=4.5, Halo=5, Lucky=5, ["Orange Balloon"]=3, ["Green Balloon"]=3.5,
            ["Blue Balloon"]=4, ["Red Balloon"]=5, ["Pink Balloon"]=5.5,
            ["Rainbow Balloon"]=6.5, Granny=5.5, ["Bunny Ears"]=4.5,
            ["Orange Egg"]=3, ["Green Egg"]=4, ["Blue Egg"]=5, ["Pink Egg"]=6.5,
        }
        local baseGen = 0
        pcall(function()
            local aData = require(RS.Datas.Animals)[selectedAnimal]
            if aData then baseGen = aData.Generation or 0 end
        end)
        if baseGen == 0 then
            baseGen = ANIMAL_DATA[selectedAnimal] and ANIMAL_DATA[selectedAnimal].gen or 0
        end
        local mutMod = MUTATION_MODIFIER[selectedMutation] or 0
        local traitMod = 0
        for trait, on in pairs(selectedTraits) do
            if on then traitMod = traitMod + (TRAIT_MODIFIER[trait] or 0) end
        end
        local genPerSec = baseGen * (1 + mutMod + traitMod)
        local plot = GetPlayerPlot()
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        local podiumFolder = podiums and podiums:FindFirstChild(tostring(slotIndex))
        local claim = podiumFolder and podiumFolder:FindFirstChild("Claim")
        local claimMain = claim and claim:FindFirstChild("Main")
        local claimHitbox = claim and claim:FindFirstChild("Hitbox")
        if not claimMain then return end
        local function GetPlotMultiplier()
            local mult = 1
            pcall(function()
                local m = plot:FindFirstChild("Multiplier")
                local amt = m and m:FindFirstChild("Main") and m.Main:FindFirstChild("Amount")
                if amt then mult = tonumber(amt.Text:match("x?([%d%.]+)")) or 1 end
            end)
            return mult
        end
        local focScript = RS.Controllers.FastOverheadController
        local cashPart = focScript.FastOverheadTemplate:Clone()
        cashPart.Size = Vector3.new(5, 3, 0.1)
        cashPart.Transparency = 1
        cashPart.CanCollide = false; cashPart.CanQuery = false
        cashPart.CanTouch = false; cashPart.CastShadow = false
        cashPart.CFrame = CFrame.new(0, 10000, 0)
        cashPart.Parent = workspace.Debris
        local cashMotor = cashPart:FindFirstChild("__foh_transform")
        if not cashMotor then
            cashMotor = Instance.new("Motor6D")
            cashMotor.Name = "__foh_transform"
            cashMotor.Parent = cashPart
        end
        cashMotor.Part0 = workspace.Terrain
        cashMotor.Part1 = cashPart
        cashPart.Anchored = false
        local cashGui = focScript.CashPad:Clone()
        cashGui.Adornee = cashPart
        cashGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        cashGui.MaxDistance = 72
        cashGui.Parent = cashPart
        local collectAmtLbl = cashGui:FindFirstChild("CollectAmount")
        local collectLbl = cashGui:FindFirstChild("Collect")
        local offlineLbl = cashGui:FindFirstChild("Offline")
        if collectLbl then collectLbl.Visible = true end
        local function fmt(n)
            local function clean(s, suffix)
                return s:gsub("%.0+"..suffix, suffix):gsub("(%.%d-)0+"..suffix, "%1"..suffix)
            end
            if n >= 1e12 then return clean(string.format("%.1fT", n/1e12), "T")
            elseif n >= 1e9 then return clean(string.format("%.1fB", n/1e9), "B")
            elseif n >= 1e6 then return clean(string.format("%.1fM", n/1e6), "M")
            elseif n >= 1e3 then return clean(string.format("%.1fK", n/1e3), "K")
            else return tostring(math.floor(n)) end
        end
        local offlineAmt = (_pendingOfflineCash and _pendingOfflineCash > 0) and _pendingOfflineCash or 0
        if offlineAmt > 0 then
            _modelOfflineCash[model] = offlineAmt
        end
        local accumulated = offlineAmt
        if offlineLbl then
            if offlineAmt > 0 then
                offlineLbl.RichText = true
                offlineLbl.Text = '(Offline Cash: <font color="#39FF14">$'..fmt(offlineAmt)..'</font>)'
                offlineLbl.Visible = true
            else
                offlineLbl.Visible = false
            end
        end
        if collectAmtLbl and offlineAmt > 0 then
            collectAmtLbl.Text = "$"..fmt(offlineAmt)
        end
        local lastTick = tick()
        local lastDisplay = tick()
        local wasOnPad = false
        local cashConn
        cashConn = RunService.Stepped:Connect(function()
            if not model or not model.Parent then
                pcall(function() cashPart:Destroy() end)
                cashConn:Disconnect(); return
            end
            local now = tick()
            local dt = now - lastTick
            lastTick = now
            accumulated = accumulated + genPerSec * GetPlotMultiplier() * dt
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and claimHitbox then
                local onPad = (hrp.Position - claimHitbox.Position).Magnitude < 5
                if onPad and not wasOnPad then
                    accumulated = 0
                    lastDisplay = now
                    if collectAmtLbl then collectAmtLbl.Text = "$0" end
                    if offlineLbl then offlineLbl.Visible = false end
                    _modelOfflineCash[model] = nil
                    pcall(function()
                        require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Cashout")
                    end)
                end
                wasOnPad = onPad
            end
            if now - lastDisplay >= 1 then
                lastDisplay = now
                if collectAmtLbl then collectAmtLbl.Text = "$"..fmt(math.max(0, accumulated)) end
            end
            local camCF = workspace.CurrentCamera.CFrame
            local pos = claimMain.Position + Vector3.new(0, 2.41, 0)
            cashMotor.Transform = CFrame.lookAlong(pos, -camCF.LookVector)
            local dist = (camCF.Position - pos).Magnitude
            if dist < 40 then cashGui.CanvasSize = Vector2.new(200, 120)
            elseif dist < 72 then cashGui.CanvasSize = Vector2.new(100, 60)
            else cashGui.CanvasSize = Vector2.new(0, 0) end
        end)
        modelCashpads[model] = {part = cashPart, conn = cashConn}
        model.AncestryChanged:Connect(function()
            if not model:IsDescendantOf(workspace) then
                modelCashpads[model] = nil
                pcall(function() cashPart:Destroy() end)
                cashConn:Disconnect()
            end
        end)
    end)
    pcall(function()
        local plot = GetPlayerPlot()
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        local podiumFolder = podiums and podiums:FindFirstChild(tostring(slotIndex))
        local base = podiumFolder and podiumFolder:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        if not spawn then return end
        local promptAtt = spawn:FindFirstChild("PromptAttachment")
        if not promptAtt then return end
        local animalInfo = ANIMAL_DATA[selectedAnimal]
        local sellPrice = animalInfo and animalInfo.price or 0
        local function fmt(n)
            local function clean(s, suffix)
                return s:gsub("%.0+"..suffix, suffix):gsub("(%.%d-)0+"..suffix, "%1"..suffix)
            end
            if n >= 1e12 then return clean(string.format("%.1fT", n/1e12), "T")
            elseif n >= 1e9 then return clean(string.format("%.1fB", n/1e9), "B")
            elseif n >= 1e6 then return clean(string.format("%.1fM", n/1e6), "M")
            elseif n >= 1e3 then return clean(string.format("%.1fK", n/1e3), "K")
            else return tostring(math.floor(n)) end
        end
        if slotPromptConns[slotIndex] then
            for _, c in ipairs(slotPromptConns[slotIndex]) do
                pcall(function() c:Disconnect() end)
            end
        end
        slotPromptConns[slotIndex] = {}
        modelPromptInfo[model] = {att=promptAtt, slot=slotIndex}
        for _, prompt in promptAtt:GetChildren() do
            if prompt:IsA("ProximityPrompt") then
                if prompt.KeyboardKeyCode == Enum.KeyCode.E then
                    prompt.ActionText = "Grab"
                    prompt.ObjectText = selectedAnimal
                    prompt:SetAttribute("State", "Grab")
                    prompt.Enabled = true
                    local grabPromptRef = prompt
                    local eConn; eConn = prompt.Triggered:Connect(function()
                        if carriedModel == model then
                            PlaceModelOnSlot(model, slotIndex, selectedAnimal)
                        elseif not carriedModel then
                            StartCarry(model, slotIndex, grabPromptRef)
                        end
                    end)
                    table.insert(slotPromptConns[slotIndex], eConn)
                elseif prompt.KeyboardKeyCode == Enum.KeyCode.F then
                    prompt.ActionText = "Sell: $"..fmt(math.floor(sellPrice * 0.5))
                    prompt.ObjectText = ""
                    prompt:SetAttribute("State", "Sell")
                    prompt.Enabled = true
                    local capturedSlot = slotIndex
                    local capturedModel = model
                    local capturedName = selectedAnimal
                    local capturedRarity = animalRarity
                    local capturedAtt = promptAtt
                    local fConn; fConn = prompt.Triggered:Connect(function()
                        local function doSell()
                            pcall(function() capturedModel:Destroy() end)
                            modelSnapshots[capturedModel] = nil
                            modelOverheads[capturedModel] = nil
                            if slotPromptConns[capturedSlot] then
                                for _, c in ipairs(slotPromptConns[capturedSlot]) do
                                    pcall(function() c:Disconnect() end)
                                end
                                slotPromptConns[capturedSlot] = nil
                            end
                            for i, m in ipairs(spawnedModels) do
                                if m == capturedModel then table.remove(spawnedModels, i); break end
                            end
                            modelPromptInfo[capturedModel] = nil
                            ScheduleSave()
                            if capturedAtt then
                                for _, p2 in capturedAtt:GetChildren() do
                                    if p2:IsA("ProximityPrompt") then
                                        p2.ActionText = "Interact"
                                        p2.ObjectText = ""
                                        p2:SetAttribute("State", "None")
                                        p2.Enabled = false
                                    end
                                end
                            end
                            UpdateCount()
                        end
                        local highRarity = capturedRarity == "OG" or capturedRarity == "Secret"
                            or capturedRarity == "Mythic" or capturedRarity == "Brainrot God"
                        if highRarity then
                            local ok, cc = pcall(function()
                                return require(RS.Controllers.ConfirmationController)
                            end)
                            if ok and cc and not cc:IsInPrompt() then
                                task.spawn(function()
                                    local result = cc:Show("Do you want to sell "..capturedName.."?")
                                    if result then
                                        doSell()
                                    else
                                        pcall(function()
                                            if capturedAtt then
                                                for _, p2 in capturedAtt:GetChildren() do
                                                    if p2:IsA("ProximityPrompt") and p2.KeyboardKeyCode == Enum.KeyCode.E then
                                                        p2.Enabled = true
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                end)
                            else
                                local confirmGui = LocalPlayer.PlayerGui:FindFirstChild("Confirmation")
                                local template = confirmGui and confirmGui:FindFirstChild("Template")
                                if template then
                                    local clone = template:Clone()
                                    clone.Name = "Confirmation"
                                    clone.Visible = true
                                    local desc = clone:FindFirstChild("Content") and clone.Content:FindFirstChild("Description")
                                    if desc then desc.Text = "Do you want to sell "..capturedName.."?" end
                                    clone.Parent = confirmGui
                                    local done = false
                                    local function finish(yes)
                                        if done then return end; done = true
                                        clone:Destroy()
                                        if yes then
                                            doSell()
                                        else
                                            pcall(function()
                                                if capturedAtt then
                                                    for _, p2 in capturedAtt:GetChildren() do
                                                        if p2:IsA("ProximityPrompt") and p2.KeyboardKeyCode == Enum.KeyCode.E then
                                                            p2.Enabled = true
                                                        end
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                    local yesBtn = clone:FindFirstChild("Yes")
                                    local noBtn = clone:FindFirstChild("No")
                                    local closeBtn = clone:FindFirstChild("Close")
                                    if yesBtn then yesBtn.MouseButton1Click:Connect(function() finish(true) end) end
                                    if noBtn then noBtn.MouseButton1Click:Connect(function() finish(false) end) end
                                    if closeBtn then closeBtn.MouseButton1Click:Connect(function() finish(false) end) end
                                else
                                    doSell()
                                end
                            end
                        else
                            doSell()
                        end
                    end)
                    table.insert(slotPromptConns[slotIndex], fConn)
                end
                prompt.Enabled = true
            end
        end
    end)
    table.insert(spawnedModels, model)
    UpdateCount()
    ScheduleSave()
    task.defer(function()
        for _, mdl in ipairs(spawnedModels) do
            if mdl and mdl.Parent then _syncModelAnimations(mdl) end
        end
    end)
    task.defer(function()
        local pg = LocalPlayer.PlayerGui
        local ft = pg:FindFirstChild("KV_FakeTrade")
        local inner2 = ft and ft:FindFirstChild("TradeLiveTrade")
        if not inner2 then return end
        local yourScroll2 = inner2.Your:FindFirstChild("ScrollingFrame")
        local tmpl2 = yourScroll2 and yourScroll2:FindFirstChild("Template")
        if not yourScroll2 or not tmpl2 then return end
        for _, v in yourScroll2:GetChildren() do
            if v:IsA("Frame") and v ~= tmpl2 and v.Name:sub(1,3) == "KV_" then v:Destroy() end
        end
        local idx2 = 1000
        for _, mdl2 in ipairs(spawnedModels) do
            if mdl2 and mdl2.Parent then
                local snap2 = modelSnapshots[mdl2] or {mutation="None",traits={}}
                local f2 = tmpl2:Clone()
                f2.Name = "KV_"..idx2; f2.Visible=true; f2.LayoutOrder=idx2
                slotToModel[f2.Name] = mdl2
                local sp2 = f2:FindFirstChild("Spacer")
                if sp2 then
                    pcall(function() sp2.Title.Text = mdl2.Name end)
                    pcall(function()
                        local sa2 = GetSharedAnimals()
                        if sa2 and sa2.AttachOnViewportWithOptimizations then
                            sa2:AttachOnViewportWithOptimizations(mdl2.Name, sp2.ViewportFrame, nil, snap2.mutation ~= "None" and snap2.mutation or nil)
                        end
                    end)
                    pcall(function()
                        local tf = sp2:FindFirstChild("Traits")
                        local tt = tf and tf:FindFirstChild("Template")
                        if tf and tt then
                            for _, c in tf:GetChildren() do if c ~= tt then c:Destroy() end end
                            for i5, tn in ipairs(snap2.traits or {}) do
                                local ic = tt:Clone(); ic.Name=tn; ic.Visible=true; ic.LayoutOrder=i5
                                if TRAIT_ICONS[tn] then pcall(function() ic.Image=TRAIT_ICONS[tn] end) end
                                ic.Parent=tf
                            end
                        end
                    end)
                    sp2.Activated:Connect(function()
                        if inConfirmStage then return end
                        selectedSlots[f2.Name] = not selectedSlots[f2.Name]
                        local sel2 = selectedSlots[f2.Name]
                        sp2.BackgroundColor3 = sel2 and Color3.fromRGB(15,50,15) or Color3.fromRGB(35,45,50)
                        local sk2 = sp2:FindFirstChildOfClass("UIStroke")
                        if sk2 then sk2.Color = sel2 and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,0,0) end
                        pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
                        StartTimer()
                        pcall(function()
                            local selCount2 = 0
                            for _, v2 in pairs(selectedSlots) do if v2 then selCount2=selCount2+1 end end
                            local ybs = inner2.Your:FindFirstChild("BaseSlots")
                            local obs = inner2.Other:FindFirstChild("BaseSlots")
                            if ybs then local _,mx=ybs.Text:match("(%d+)/(%d+)"); if mx then ybs.Text=math.max(0,baseMine-selCount2).."/"..mx end end
                            if obs then local _,mx=obs.Text:match("(%d+)/(%d+)"); if mx then obs.Text=(otherBaseNum+selCount2).."/"..mx end end
                        end)
                    end)
                end
                f2.Parent = yourScroll2
                idx2 = idx2 + 1
            end
        end
        pcall(function()
            local ybs = inner2.Your:FindFirstChild("BaseSlots")
            if ybs then local _,mx=ybs.Text:match("(%d+)/(%d+)"); if mx then
                baseMine = #spawnedModels; ybs.Text=baseMine.."/"..mx
            end end
        end)
    end)
    end
    SetStatus("✓ Spawned "..spawnCount.."x "..selectedAnimal,Color3.fromRGB(50,200,100),3)
end

spawnBtn.MouseButton1Click:Connect(function()
    if _multiSelectMode then
        local picks = {}
        for n, on in pairs(_multiSelected) do if on then table.insert(picks, n) end end
        if #picks == 0 then
            DoSpawn(); return
        end
        -- Spawn each picked animal once (with current mutation/traits/qty applied per pick)
        local savedAnimal = selectedAnimal
        for _, n in ipairs(picks) do
            selectedAnimal = n
            DoSpawn()
            task.wait(0.05)
        end
        selectedAnimal = savedAnimal
    else
        DoSpawn()
    end
end)
spawnBtn.MouseEnter:Connect(function() spawnBtn.BackgroundColor3=Color3.fromRGB(60,190,100) end)
spawnBtn.MouseLeave:Connect(function() spawnBtn.BackgroundColor3=BTNGRN end)

-- Add text outline (UIStroke) to all TextLabels in the GUI for cleaner look
task.defer(function()
    for _, lbl in sg:GetDescendants() do
        if lbl:IsA("TextLabel") or lbl:IsA("TextButton") then
            if not lbl:FindFirstChildOfClass("UIStroke") then
                local s = Instance.new("UIStroke", lbl)
                s.Color = Color3.fromRGB(0,0,0)
                s.Thickness = 1
                s.Transparency = 0.7
                s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
            end
        end
    end
end)

SetStatus("Ready — select an animal to spawn",SUBTEXT)

-- ── MISC PAGE CONTENT ────────────────────────────────────
do
    -- Section helper: creates a collapsible group that contains rows.
    -- Returns the content Frame that callers parent rows to.
    local function MakeMiscSection(title, layoutOrder, openByDefault)
        local section = New("Frame", {
            Size=UDim2.new(1,0,0,0),
            AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1, BorderSizePixel=0,
            LayoutOrder=layoutOrder, Parent=miscPage,
        })
        local secLayout = Instance.new("UIListLayout", section)
        secLayout.SortOrder = Enum.SortOrder.LayoutOrder
        secLayout.Padding = UDim.new(0, 6)

        local hdrBtn = New("TextButton", {
            Size=UDim2.new(1,0,0,32),
            BackgroundColor3=Color3.fromRGB(28,28,38),
            BorderSizePixel=0, AutoButtonColor=false, Text="",
            LayoutOrder=1, Parent=section,
        })
        Corner(hdrBtn, 6); Stroke(hdrBtn, Color3.fromRGB(60,60,80), 1, 0.2)
        local arrowLbl = New("TextLabel", {
            Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1, Text=(openByDefault and "▼  " or "▶  ") .. title,
            TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
            TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=hdrBtn,
        })

        local content = New("Frame", {
            Size=UDim2.new(1,0,0,0),
            AutomaticSize=Enum.AutomaticSize.Y,
            BackgroundTransparency=1, BorderSizePixel=0, ClipsDescendants=true,
            Visible=openByDefault, LayoutOrder=2, Parent=section,
        })
        local cLayout = Instance.new("UIListLayout", content)
        cLayout.SortOrder = Enum.SortOrder.LayoutOrder
        cLayout.Padding = UDim.new(0, 6)

        local visible = openByDefault
        hdrBtn.Activated:Connect(function()
            visible = not visible
            content.Visible = visible
            arrowLbl.Text = (visible and "▼  " or "▶  ") .. title
        end)
        return content
    end

    local cfgContent  = MakeMiscSection("Configuration", 1, false)
    local keysContent = MakeMiscSection("Hotkeys",       2, false)
    local dataContent = MakeMiscSection("Spawned Brainrots", 3, false)

    local row = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=1, Parent=cfgContent,
    })
    Corner(row, 6); Stroke(row, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.7,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Auto-Restore Spawns on Rejoin",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row,
    })
    local toggleBtn = New("TextButton", {
        Size=UDim2.new(0,70,0,26), Position=UDim2.new(1,-80,0.5,-13),
        BackgroundColor3=autoRestoreEnabled and ACCENT or Color3.fromRGB(60,60,80),
        BorderSizePixel=0, AutoButtonColor=false,
        Text=autoRestoreEnabled and "ON" or "OFF",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row,
    })
    Corner(toggleBtn, 5)
    toggleBtn.Activated:Connect(function()
        autoRestoreEnabled = not autoRestoreEnabled
        toggleBtn.Text = autoRestoreEnabled and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = autoRestoreEnabled and ACCENT or Color3.fromRGB(60,60,80)
        SaveConfig()
    end)

    -- Auto-Save row: when on, every spawn/sell auto-writes to the save file.
    -- Turning it off pauses auto-writes but keeps the existing save intact;
    -- Save Now still works manually, and turning this back on resumes saves.
    local row2 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=2, Parent=cfgContent,
    })
    Corner(row2, 6); Stroke(row2, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.7,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Auto-Save Base Changes",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row2,
    })
    local saveToggleBtn = New("TextButton", {
        Size=UDim2.new(0,70,0,26), Position=UDim2.new(1,-80,0.5,-13),
        BackgroundColor3=autoSaveEnabled and ACCENT or Color3.fromRGB(60,60,80),
        BorderSizePixel=0, AutoButtonColor=false,
        Text=autoSaveEnabled and "ON" or "OFF",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row2,
    })
    Corner(saveToggleBtn, 5)
    saveToggleBtn.Activated:Connect(function()
        autoSaveEnabled = not autoSaveEnabled
        saveToggleBtn.Text = autoSaveEnabled and "ON" or "OFF"
        saveToggleBtn.BackgroundColor3 = autoSaveEnabled and ACCENT or Color3.fromRGB(60,60,80)
        -- SaveConfig itself bypasses the autoSave gate, so the toggle's own
        -- state is always persisted (the gate only governs ScheduleSave).
        SaveConfig()
    end)

    -- Community webhook row: opt-in. When on, real trade-received brainrots
    -- with gen >= 50M/s post to the shared Discord channel.
    local row3 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=3, Parent=cfgContent,
    })
    Corner(row3, 6); Stroke(row3, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.7,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Share Pulls to Community Feed",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row3,
    })
    local hookToggleBtn = New("TextButton", {
        Size=UDim2.new(0,70,0,26), Position=UDim2.new(1,-80,0.5,-13),
        BackgroundColor3=webhookEnabled and ACCENT or Color3.fromRGB(60,60,80),
        BorderSizePixel=0, AutoButtonColor=false,
        Text=webhookEnabled and "ON" or "OFF",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row3,
    })
    Corner(hookToggleBtn, 5)
    hookToggleBtn.Activated:Connect(function()
        webhookEnabled = not webhookEnabled
        hookToggleBtn.Text = webhookEnabled and "ON" or "OFF"
        hookToggleBtn.BackgroundColor3 = webhookEnabled and ACCENT or Color3.fromRGB(60,60,80)
        SaveConfig()
    end)

    -- Hide UI on Rejoin: when on, the menu starts hidden after a rejoin
    -- so the user has to press the toggle key to bring it up. Useful when
    -- joining around people who shouldn't see the menu pop up.
    local row3b = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=4, Parent=cfgContent,
    })
    Corner(row3b, 6); Stroke(row3b, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.7,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Hide UI on Rejoin",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row3b,
    })
    local hideToggleBtn = New("TextButton", {
        Size=UDim2.new(0,70,0,26), Position=UDim2.new(1,-80,0.5,-13),
        BackgroundColor3=hideOnRejoinEnabled and ACCENT or Color3.fromRGB(60,60,80),
        BorderSizePixel=0, AutoButtonColor=false,
        Text=hideOnRejoinEnabled and "ON" or "OFF",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row3b,
    })
    Corner(hideToggleBtn, 5)
    hideToggleBtn.Activated:Connect(function()
        hideOnRejoinEnabled = not hideOnRejoinEnabled
        hideToggleBtn.Text = hideOnRejoinEnabled and "ON" or "OFF"
        hideToggleBtn.BackgroundColor3 = hideOnRejoinEnabled and ACCENT or Color3.fromRGB(60,60,80)
        local ok, err = pcall(SaveConfig)
        if ok then
            SetStatus("Hide on Rejoin: " .. (hideOnRejoinEnabled and "ON (saved)" or "OFF (saved)"),
                Color3.fromRGB(40,200,80), 2)
        else
            SetStatus("Save failed: " .. tostring(err), Color3.fromRGB(255,80,80), 4)
        end
    end)

    -- UI Toggle Key: click button -> listening; press key to capture;
    -- click off the button or press Enter to save; press Escape to cancel.
    -- Each key-row is wrapped in its own do/end so its locals (row, btn,
    -- listening flag, pending value, conn handles) get released afterward —
    -- otherwise the misc tab blows past Luau's 200-local register limit.
    do
    local row4 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=1, Parent=keysContent,
    })
    Corner(row4, 6); Stroke(row4, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.6,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="UI Toggle Key",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row4,
    })
    local keyBtn = New("TextButton", {
        Size=UDim2.new(0,140,0,26), Position=UDim2.new(1,-150,0.5,-13),
        BackgroundColor3=Color3.fromRGB(60,60,80), BorderSizePixel=0,
        AutoButtonColor=false, Text=toggleKeyName,
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row4,
    })
    Corner(keyBtn, 5)

    local listening   = false
    local pendingKey  = nil
    local listenConn  = nil

    local function refreshKeyBtn()
        if listening then
            keyBtn.Text = pendingKey
                and (pendingKey .. "  (click off to save)")
                or "Press a key..."
            keyBtn.BackgroundColor3 = ACCENT
        else
            keyBtn.Text = toggleKeyName
            keyBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
        end
    end

    local function stopListening(commit)
        if not listening then return end
        if commit and pendingKey then
            toggleKeyName = pendingKey
            SaveConfig()
        end
        listening  = false
        pendingKey = nil
        if listenConn then listenConn:Disconnect(); listenConn = nil end
        refreshKeyBtn()
    end

    local function startListening()
        if listening then return end
        listening  = true
        pendingKey = nil
        refreshKeyBtn()
        listenConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    stopListening(false)
                elseif kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter then
                    stopListening(true)
                else
                    pendingKey = kc.Name
                    refreshKeyBtn()
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                -- click off the button = commit; click on it = cancel
                local mp = UserInputService:GetMouseLocation()
                local bp, bs = keyBtn.AbsolutePosition, keyBtn.AbsoluteSize
                local inside = mp.X >= bp.X and mp.X <= bp.X+bs.X
                    and mp.Y >= bp.Y and mp.Y <= bp.Y+bs.Y
                if not inside then
                    stopListening(true)
                end
            end
        end)
    end

    keyBtn.Activated:Connect(function()
        if listening then
            stopListening(false)
        else
            startListening()
        end
    end)
    end -- toggleKey row scope

    -- Rejoin Key: same UX as the toggle-key row. Pressing the bound key
    -- teleports the player back into the same place (new server).
    do
    local row5 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=2, Parent=keysContent,
    })
    Corner(row5, 6); Stroke(row5, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.6,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Rejoin Key",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row5,
    })
    local rejoinBtn = New("TextButton", {
        Size=UDim2.new(0,140,0,26), Position=UDim2.new(1,-150,0.5,-13),
        BackgroundColor3=Color3.fromRGB(60,60,80), BorderSizePixel=0,
        AutoButtonColor=false,
        Text=(rejoinKeyName ~= "" and rejoinKeyName) or "Unbound",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row5,
    })
    Corner(rejoinBtn, 5)

    local rjListening  = false
    local rjPending    = nil
    local rjConn       = nil

    local function refreshRejoinBtn()
        if rjListening then
            rejoinBtn.Text = rjPending
                and (rjPending .. "  (click off to save)")
                or "Press a key... (Del = unbind)"
            rejoinBtn.BackgroundColor3 = ACCENT
        else
            rejoinBtn.Text = (rejoinKeyName ~= "" and rejoinKeyName) or "Unbound"
            rejoinBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
        end
    end

    local function rjStop(commit)
        if not rjListening then return end
        if commit and rjPending ~= nil then
            rejoinKeyName = rjPending  -- may be "" to unbind
            SaveConfig()
        end
        rjListening = false
        rjPending   = nil
        if rjConn then rjConn:Disconnect(); rjConn = nil end
        refreshRejoinBtn()
    end

    local function rjStart()
        if rjListening then return end
        rjListening = true
        rjPending   = nil
        refreshRejoinBtn()
        rjConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    rjStop(false)
                elseif kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter then
                    rjStop(true)
                elseif kc == Enum.KeyCode.Delete or kc == Enum.KeyCode.Backspace then
                    rjPending = ""  -- unbind
                    refreshRejoinBtn()
                else
                    rjPending = kc.Name
                    refreshRejoinBtn()
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                local mp = UserInputService:GetMouseLocation()
                local bp, bs = rejoinBtn.AbsolutePosition, rejoinBtn.AbsoluteSize
                local inside = mp.X >= bp.X and mp.X <= bp.X+bs.X
                    and mp.Y >= bp.Y and mp.Y <= bp.Y+bs.Y
                if not inside then rjStop(true) end
            end
        end)
    end

    rejoinBtn.Activated:Connect(function()
        if rjListening then rjStop(false) else rjStart() end
    end)
    end -- rejoinKey row scope

    -- ── DEBUG: Dupe Item Key ──────────────────────────────
    -- While the Trade Setup window is open, each press adds one more copy of
    -- the currently-selected animal/mutation to the "their side" list.
    -- Strictly visual — no networking.
    do
    local row6 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=3, Parent=keysContent,
    })
    Corner(row6, 6); Stroke(row6, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.6,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Dupe Item Key",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row6,
    })
    local dupeKeyBtn = New("TextButton", {
        Size=UDim2.new(0,140,0,26), Position=UDim2.new(1,-150,0.5,-13),
        BackgroundColor3=Color3.fromRGB(60,60,80), BorderSizePixel=0,
        AutoButtonColor=false,
        Text=(_debugDupeKeyName ~= "" and _debugDupeKeyName) or "Unbound",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row6,
    })
    Corner(dupeKeyBtn, 5)

    local dkListening, dkPending, dkConn = false, nil, nil
    local function refreshDupeBtn()
        if dkListening then
            dupeKeyBtn.Text = dkPending and (dkPending.."  (click off to save)") or "Press a key... (Del = unbind)"
            dupeKeyBtn.BackgroundColor3 = ACCENT
        else
            dupeKeyBtn.Text = (_debugDupeKeyName ~= "" and _debugDupeKeyName) or "Unbound"
            dupeKeyBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
        end
    end
    local function dkStop(commit)
        if not dkListening then return end
        if commit and dkPending ~= nil then _debugDupeKeyName = dkPending; SaveConfig() end
        dkListening = false; dkPending = nil
        if dkConn then dkConn:Disconnect(); dkConn = nil end
        refreshDupeBtn()
    end
    local function dkStart()
        if dkListening then return end
        dkListening = true; dkPending = nil; refreshDupeBtn()
        dkConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then dkStop(false)
                elseif kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter then dkStop(true)
                elseif kc == Enum.KeyCode.Delete or kc == Enum.KeyCode.Backspace then dkPending = ""; refreshDupeBtn()
                else dkPending = kc.Name; refreshDupeBtn() end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                local mp = UserInputService:GetMouseLocation()
                local bp, bs = dupeKeyBtn.AbsolutePosition, dupeKeyBtn.AbsoluteSize
                local inside = mp.X>=bp.X and mp.X<=bp.X+bs.X and mp.Y>=bp.Y and mp.Y<=bp.Y+bs.Y
                if not inside then dkStop(true) end
            end
        end)
    end
    dupeKeyBtn.Activated:Connect(function() if dkListening then dkStop(false) else dkStart() end end)
    end -- dupeKey row scope

    -- ── DEBUG: Auto-Fill Trade Key ────────────────────────
    -- Press to open Trade Setup pre-filled with the username and offered items
    -- captured from the most recent real trade session.  Visual-only.
    do
    local row7 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=4, Parent=keysContent,
    })
    Corner(row7, 6); Stroke(row7, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.6,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text="Trade Last Player",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row7,
    })
    local afKeyBtn = New("TextButton", {
        Size=UDim2.new(0,140,0,26), Position=UDim2.new(1,-150,0.5,-13),
        BackgroundColor3=Color3.fromRGB(60,60,80), BorderSizePixel=0,
        AutoButtonColor=false,
        Text=(_debugAutoFillKeyName ~= "" and _debugAutoFillKeyName) or "Unbound",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row7,
    })
    Corner(afKeyBtn, 5)

    local afListening, afPending, afConn = false, nil, nil
    local function refreshAfBtn()
        if afListening then
            afKeyBtn.Text = afPending and (afPending.."  (click off to save)") or "Press a key... (Del = unbind)"
            afKeyBtn.BackgroundColor3 = ACCENT
        else
            afKeyBtn.Text = (_debugAutoFillKeyName ~= "" and _debugAutoFillKeyName) or "Unbound"
            afKeyBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
        end
    end
    local function afStop(commit)
        if not afListening then return end
        if commit and afPending ~= nil then _debugAutoFillKeyName = afPending; SaveConfig() end
        afListening = false; afPending = nil
        if afConn then afConn:Disconnect(); afConn = nil end
        refreshAfBtn()
    end
    local function afStart()
        if afListening then return end
        afListening = true; afPending = nil; refreshAfBtn()
        afConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then afStop(false)
                elseif kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter then afStop(true)
                elseif kc == Enum.KeyCode.Delete or kc == Enum.KeyCode.Backspace then afPending = ""; refreshAfBtn()
                else afPending = kc.Name; refreshAfBtn() end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                local mp = UserInputService:GetMouseLocation()
                local bp, bs = afKeyBtn.AbsolutePosition, afKeyBtn.AbsoluteSize
                local inside = mp.X>=bp.X and mp.X<=bp.X+bs.X and mp.Y>=bp.Y and mp.Y<=bp.Y+bs.Y
                if not inside then afStop(true) end
            end
        end)
    end
    afKeyBtn.Activated:Connect(function() if afListening then afStop(false) else afStart() end end)
    end -- autoFillKey row scope

    -- ── Trade Notif Key ──────────────────────────────────
    do
    local row8 = New("Frame", {
        Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(24,24,32),
        BorderSizePixel=0, LayoutOrder=5, Parent=keysContent,
    })
    Corner(row8, 6); Stroke(row8, Color3.fromRGB(50,50,70), 1, 0.3)
    New("TextLabel", {
        Size=UDim2.new(0.6,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1, Text="Trade Notification",
        TextColor3=Color3.fromRGB(220,220,230), Font=Enum.Font.Gotham,
        TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row8,
    })
    local tnKeyBtn = New("TextButton", {
        Size=UDim2.new(0,140,0,26), Position=UDim2.new(1,-150,0.5,-13),
        BackgroundColor3=Color3.fromRGB(60,60,80), BorderSizePixel=0,
        AutoButtonColor=false,
        Text=(_debugTradeNotifKeyName ~= "" and _debugTradeNotifKeyName) or "Unbound",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, Parent=row8,
    })
    Corner(tnKeyBtn, 5)
    local tnListening, tnPending, tnConn = false, nil, nil
    local function refreshTnBtn()
        if tnListening then
            tnKeyBtn.Text = tnPending and (tnPending.."  (click off to save)") or "Press a key... (Del = unbind)"
            tnKeyBtn.BackgroundColor3 = ACCENT
        else
            tnKeyBtn.Text = (_debugTradeNotifKeyName ~= "" and _debugTradeNotifKeyName) or "Unbound"
            tnKeyBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
        end
    end
    local function tnStop(commit)
        if not tnListening then return end
        if commit and tnPending ~= nil then _debugTradeNotifKeyName = tnPending; SaveConfig() end
        tnListening = false; tnPending = nil
        if tnConn then tnConn:Disconnect(); tnConn = nil end
        refreshTnBtn()
    end
    local function tnStart()
        if tnListening then return end
        tnListening = true; tnPending = nil; refreshTnBtn()
        tnConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then tnStop(false)
                elseif kc == Enum.KeyCode.Return or kc == Enum.KeyCode.KeypadEnter then tnStop(true)
                elseif kc == Enum.KeyCode.Delete or kc == Enum.KeyCode.Backspace then tnPending = ""; refreshTnBtn()
                else tnPending = kc.Name; refreshTnBtn() end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                local mp = UserInputService:GetMouseLocation()
                local bp, bs = tnKeyBtn.AbsolutePosition, tnKeyBtn.AbsoluteSize
                local inside = mp.X>=bp.X and mp.X<=bp.X+bs.X and mp.Y>=bp.Y and mp.Y<=bp.Y+bs.Y
                if not inside then tnStop(true) end
            end
        end)
    end
    tnKeyBtn.Activated:Connect(function() if tnListening then tnStop(false) else tnStart() end end)
    end -- tradeNotifKey row scope

    local statusRow = New("Frame", {
        Size=UDim2.new(1,0,0,28), BackgroundTransparency=1,
        LayoutOrder=1, Parent=dataContent,
    })
    local statusLbl2 = New("TextLabel", {
        Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1, Text="",
        TextColor3=SUBTEXT, Font=Enum.Font.Gotham,
        TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=statusRow,
    })
    local function RefreshStatus()
        local saved = (_loadedConfig and _loadedConfig.spawns) and #_loadedConfig.spawns or 0
        local live  = #spawnedModels
        statusLbl2.Text = ("Saved: %d   |   Live: %d"):format(saved, live)
    end
    RefreshStatus()

    local btnRow = New("Frame", {
        Size=UDim2.new(1,0,0,32), BackgroundTransparency=1,
        LayoutOrder=2, Parent=dataContent,
    })
    do
        local ul = Instance.new("UIListLayout", btnRow)
        ul.FillDirection = Enum.FillDirection.Horizontal
        ul.Padding = UDim.new(0, 8)
        ul.SortOrder = Enum.SortOrder.LayoutOrder
    end
    local clearBtn = New("TextButton", {
        Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(70,40,40),
        BorderSizePixel=0, AutoButtonColor=false, Text="Clear Spawned",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=Enum.Font.GothamBold, TextSize=11, LayoutOrder=1, Parent=btnRow,
    })
    Corner(clearBtn, 5)

    local function RestoreFromConfig(cfg)
        if not cfg or type(cfg.spawns) ~= "table" then return 0 end
        local n = 0
        -- burst restore: fire DoSpawn for every saved item in the same frame,
        -- no per-item waits. saves/restores the shared spawn upvalues once
        -- around the whole batch instead of per iteration. the only async
        -- path inside DoSpawn captures _animName into a local before
        -- yielding, so this avoids the upvalue race the queued drain guarded.
        local savedA = selectedAnimal
        local savedM = selectedMutation
        local savedT = selectedTraits
        local savedC = spawnCount
        for _, e in ipairs(cfg.spawns) do
            if type(e) == "table" and type(e.name) == "string" then
                selectedAnimal   = e.name
                selectedMutation = e.mutation or "None"
                local traits = {}
                if type(e.traits) == "table" then
                    for _, t in ipairs(e.traits) do traits[t] = true end
                end
                selectedTraits = traits
                spawnCount     = 1
                _slotOverride  = type(e.slot) == "number" and e.slot or nil
                -- Compute offline cash for THIS spawn and stash it in a pending
                -- variable BEFORE DoSpawn — the cashpad creation reads it during
                -- spawn. (Setting _modelOfflineCash AFTER DoSpawn would be too late.)
                _pendingOfflineCash = 0
                if _offlineSeconds > 0 then
                    local realGen = CalcGeneration(e.name, e.mutation or "None", traits) or 0
                    _pendingOfflineCash = realGen * _offlineSeconds * 0.5
                end
                pcall(DoSpawn)
                _pendingOfflineCash = 0
                _slotOverride  = nil
                n = n + 1
            end
        end
        selectedAnimal   = savedA
        selectedMutation = savedM
        selectedTraits   = savedT
        spawnCount       = savedC
        return n
    end

    clearBtn.Activated:Connect(function()
        -- Instantly destroys every fake brainrot we've spawned this session,
        -- resets the proximity prompts on those podiums (Grab/Sell → disabled),
        -- and clears the saved-spawns list on disk so they don't auto-restore
        -- on rejoin.  All other settings (autoSave, webhook, hotkeys, window
        -- pos, etc.) are preserved.
        local destroyed = 0
        for _, mdl in ipairs(spawnedModels) do
            if mdl and mdl.Parent then
                pcall(function() mdl:Destroy() end)
                destroyed = destroyed + 1
            end
            modelSnapshots[mdl] = nil
            -- clean up overhead/cashpad parts attached to this model
            local oh = modelOverheads[mdl]
            if oh then
                pcall(function() if oh.part then oh.part:Destroy() end end)
                pcall(function() if oh.gui  then oh.gui:Destroy()  end end)
                modelOverheads[mdl] = nil
            end
            local cp = modelCashpads and modelCashpads[mdl]
            if cp then
                pcall(function() if cp.conn then cp.conn:Disconnect() end end)
                pcall(function() if cp.part then cp.part:Destroy() end end)
                modelCashpads[mdl] = nil
            end
        end

        -- Reset every podium prompt we wired up — same cleanup the
        -- single-sell handler uses (line ~1942).  Mirrors the in-game
        -- "no animal here" state so Grab/Sell labels disappear.
        local plot = GetPlayerPlot()
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        for slotIdx, conns in pairs(slotPromptConns) do
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            slotPromptConns[slotIdx] = nil
            if podiums then
                pcall(function()
                    local podiumFolder = podiums:FindFirstChild(tostring(slotIdx))
                    local base   = podiumFolder and podiumFolder:FindFirstChild("Base")
                    local sp     = base and base:FindFirstChild("Spawn")
                    local att    = sp and sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _, p in att:GetChildren() do
                            if p:IsA("ProximityPrompt") then
                                p.ActionText = "Interact"; p.ObjectText = ""
                                p:SetAttribute("State", "None"); p.Enabled = false
                            end
                        end
                    end
                end)
            end
        end

        -- in-place clear so any closures that captured spawnedModels keep their reference
        for i = #spawnedModels, 1, -1 do spawnedModels[i] = nil end
        UpdateCount()

        -- wipe saved spawns on disk so they don't come back after rejoin
        if _hasFileApi() then
            pcall(function()
                local data = {
                    version            = 1,
                    autoRestore        = autoRestoreEnabled,
                    autoSave           = autoSaveEnabled,
                    webhook            = webhookEnabled,
                    toggleKey          = toggleKeyName,
                    rejoinKey          = rejoinKeyName,
                    debugDupeKey       = _debugDupeKeyName,
                    debugAutoFillKey   = _debugAutoFillKeyName,
                    debugTradeNotifKey = _debugTradeNotifKeyName,
                    windowPos          = savedWindowPos,
                    spawns             = {},
                }
                writefile(CONFIG_FILE, _hs:JSONEncode(data))
            end)
        end
        _loadedConfig = {spawns={}, autoRestore=autoRestoreEnabled}
        RefreshStatus()
        SetStatus(("Cleared %d spawned"):format(destroyed), Color3.fromRGB(220,180,80), 2)
    end)
    -- expose a periodic refresh for the live counter
    task.spawn(function()
        while miscPage.Parent do
            task.wait(1)
            if miscPage.Visible then RefreshStatus() end
        end
    end)

    -- auto-restore on script start, if enabled and we loaded a config.
    -- wait until the plot AND its podium prompts have actually streamed in
    -- before spawning, otherwise the prompt-wiring branch in DoSpawn finds
    -- no PromptAttachment and silently bails — leaving models without
    -- working Grab/Sell prompts.
    if autoRestoreEnabled and _loadedConfig then
        task.defer(function()
            local function plotReady()
                local plot = GetPlayerPlot()
                if not plot then return false end
                local pods = plot:FindFirstChild("AnimalPodiums")
                if not pods then return false end
                for _, pod in pods:GetChildren() do
                    local base = pod:FindFirstChild("Base")
                    local sp   = base and base:FindFirstChild("Spawn")
                    local att  = sp and sp:FindFirstChild("PromptAttachment")
                    if att and #att:GetChildren() > 0 then return true end
                end
                return false
            end
            local deadline = tick() + 30  -- give up after 30s rather than spinning forever
            while not plotReady() and tick() < deadline do
                task.wait(0.25)
            end
            local n = RestoreFromConfig(_loadedConfig)
            if n > 0 then
                SetStatus("Auto-restored "..n.." spawn(s)",Color3.fromRGB(50,200,100),3)
            end
            RefreshStatus()
        end)
    end
end

-- ── TRADING PAGE CONTENT (defined here so all functions are in scope) ──
do
    -- ── FAKE TRADE SETUP UI ──────────────────────────────

    -- State
    local fakeTradeItems = {}  -- list of {name, mutation, traits} for other side
    local _activeFakeStartTimer = nil  -- reference to live StartTimer function
    local _lastFakeTradeTime = 0  -- cooldown between fake trades
    local _liveTheirItems = nil  -- reference to theirItems in active trade
    local fakeTradeSetupOpen = false
    local fakeTradeWin = nil
    -- Shared "Show on Hide" preference. Trade popout AND sign editor both
    -- read this so they hide/show together based on the user's setting.
    local ignoreHide = true

    -- ── Sign State + Editor Popout ──
    -- Persistent state for the user's sign content. Either a single fixed
    -- message OR a list of messages that cycle every cycleSec seconds.
    local _signState = {
        manual         = "",
        randomEnabled  = false,
        randomList     = {},  -- array of strings
        cycleSec       = 5,
    }
    local _signSg = nil
    local _signCycleConn = nil  -- live cycler when a fake trade is open

    -- Apply the current sign content to the active fake trade's YourSign center.
    -- Also kicks off / stops the cycler depending on randomEnabled.
    local function _applySignToTrade()
        if _signCycleConn then pcall(function() _signCycleConn:Disconnect() end); _signCycleConn = nil end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local trade = pg and pg:FindFirstChild("KV_FakeTrade")
        if not trade then return end
        local inner = trade:FindFirstChild("TradeLiveTrade")
        if not inner then return end

        -- Target BOTH YourSign AND OtherSign so the user's side and the
        -- partner's side both reflect the configured sign text.
        local function findCenterLabel(signFrame)
            if not signFrame then return nil end
            local target, biggestSize = nil, 0
            -- Looking for the LARGEST visible text label OR button that isn't
            -- the Username header / a reaction button. The big "Last Offer"-
            -- placeholder is the actual sign center; reactions are smaller.
            local SKIP_NAMES = {
                username=true, playerimage=true, headshot=true,
            }
            local REACTION_TEXTS = {
                ["add more"]=true, ["deal?"]=true, ["l trade"]=true,
                ["fair trade"]=true, ["last offer"]=true, ["no thanks"]=true,
                ["sign"]=true,
            }
            for _, d in ipairs(signFrame:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    local nm = (d.Name or ""):lower()
                    local txt = ((d.Text or ""):lower()):gsub("^%s+", ""):gsub("%s+$", "")
                    if not SKIP_NAMES[nm]
                       and not nm:find("playerimage")
                       and not nm:find("headshot")
                       and not REACTION_TEXTS[txt] then
                        if (d.TextSize or 0) > biggestSize then
                            biggestSize = d.TextSize
                            target = d
                        end
                    end
                end
            end
            return target
        end

        local yours = inner:FindFirstChild("YourSign")
        local theirs = inner:FindFirstChild("OtherSign")
        local yLbl = findCenterLabel(yours)
        local tLbl = findCenterLabel(theirs)
        if not yLbl and not tLbl then return end
        local function setBoth(text)
            if yLbl and yLbl.Parent then yLbl.Text = text end
            if tLbl and tLbl.Parent then tLbl.Text = text end
        end

        if _signState.randomEnabled and #_signState.randomList > 0 then
            local i = 1
            setBoth(_signState.randomList[i])
            local interval = math.max(0.5, _signState.cycleSec or 5)
            task.spawn(function()
                while trade.Parent do
                    task.wait(interval)
                    if not trade.Parent then break end
                    if not _signState.randomEnabled then break end
                    i = i + 1; if i > #_signState.randomList then i = 1 end
                    setBoth(_signState.randomList[i] or "")
                end
            end)
        else
            local txt = _signState.manual
            if txt and txt ~= "" then setBoth(txt) end
        end
    end

    function _openSignEditor()
        if _signSg and _signSg.Parent then _signSg:Destroy() end
        _signSg = New("ScreenGui", {
            Name = "KV_SignEditor", ResetOnSpawn = false, IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 6000,
            Parent = GetSafeParent(),
        })

        -- Mirror the trade popout's hide rule: when sg is hidden and ignoreHide
        -- is OFF, hide the editor too. When ignoreHide is ON, keep editor visible.
        local function syncSignSgEnabled()
            if _signSg and _signSg.Parent then
                _signSg.Enabled = ignoreHide or sg.Enabled
            end
        end
        syncSignSgEnabled()
        local sgEnabledConn = sg:GetPropertyChangedSignal("Enabled"):Connect(syncSignSgEnabled)
        _signSg.AncestryChanged:Connect(function()
            if not _signSg.Parent and sgEnabledConn then sgEnabledConn:Disconnect() end
        end)

        local W = 320
        local panel = New("Frame", {
            Size = UDim2.new(0, W, 0, 360),
            Position = UDim2.new(0.5, -W/2, 0.5, -180),
            BackgroundColor3 = Color3.fromRGB(30,28,42),
            BorderSizePixel = 0, Parent = _signSg,
        })
        Corner(panel, 8); Stroke(panel, Color3.fromRGB(50,45,80), 1, 0.2)
        MakeDraggable(panel)

        -- Header
        New("TextLabel", {
            Size = UDim2.new(1,-40,0,28), Position = UDim2.new(0,12,0,8),
            BackgroundTransparency = 1, Text = "Sign Editor",
            TextColor3 = Color3.fromRGB(230,230,240),
            Font = Enum.Font.GothamBold, TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
        })
        local closeBtn = New("TextButton", {
            Size = UDim2.new(0,24,0,24), Position = UDim2.new(1,-32,0,10),
            BackgroundColor3 = Color3.fromRGB(180,60,60), Text = "X",
            TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold,
            TextSize = 12, AutoButtonColor = false, BorderSizePixel = 0, Parent = panel,
        })
        Corner(closeBtn, 4)
        closeBtn.Activated:Connect(function()
            if _signSg then pcall(function() _signSg:Destroy() end); _signSg = nil end
        end)

        -- Manual sign text input
        New("TextLabel", {
            Size = UDim2.new(1,-24,0,14), Position = UDim2.new(0,12,0,44),
            BackgroundTransparency = 1, Text = "MANUAL SIGN MESSAGE",
            TextColor3 = Color3.fromRGB(150,140,200),
            Font = Enum.Font.GothamBold, TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
        })
        local manualBox = New("TextBox", {
            Size = UDim2.new(1,-24,0,32), Position = UDim2.new(0,12,0,60),
            BackgroundColor3 = Color3.fromRGB(24,24,30),
            Text = _signState.manual, PlaceholderText = "What your sign should say...",
            PlaceholderColor3 = Color3.fromRGB(150,140,180),
            TextColor3 = Color3.fromRGB(230,230,240),
            Font = Enum.Font.Gotham, TextSize = 12,
            ClearTextOnFocus = false, BorderSizePixel = 0, Parent = panel,
        })
        Corner(manualBox, 5); Stroke(manualBox, Color3.fromRGB(50,45,80), 1, 0.2)
        do local p=Instance.new("UIPadding",manualBox); p.PaddingLeft=UDim.new(0,8) end

        -- Randomize toggle
        local randomRow = New("Frame", {
            Size = UDim2.new(1,-24,0,28), Position = UDim2.new(0,12,0,102),
            BackgroundTransparency = 1, BorderSizePixel = 0, Parent = panel,
        })
        New("TextLabel", {
            Size = UDim2.new(1,-80,1,0),
            BackgroundTransparency = 1, Text = "Cycle Random Messages",
            TextColor3 = Color3.fromRGB(220,220,230),
            Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = randomRow,
        })
        local randToggle = New("TextButton", {
            Size = UDim2.new(0,70,0,24), Position = UDim2.new(1,-70,0.5,-12),
            BackgroundColor3 = _signState.randomEnabled and Color3.fromRGB(150,105,255) or Color3.fromRGB(60,60,80),
            BorderSizePixel = 0, AutoButtonColor = false,
            Text = _signState.randomEnabled and "ON" or "OFF",
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamBold, TextSize = 11, Parent = randomRow,
        })
        Corner(randToggle, 5)
        randToggle.Activated:Connect(function()
            _signState.randomEnabled = not _signState.randomEnabled
            randToggle.Text = _signState.randomEnabled and "ON" or "OFF"
            randToggle.BackgroundColor3 = _signState.randomEnabled
                and Color3.fromRGB(150,105,255) or Color3.fromRGB(60,60,80)
        end)

        -- Cycle interval input
        New("TextLabel", {
            Size = UDim2.new(0,140,0,20), Position = UDim2.new(0,12,0,138),
            BackgroundTransparency = 1, Text = "Cycle every (sec):",
            TextColor3 = Color3.fromRGB(220,220,230),
            Font = Enum.Font.Gotham, TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
        })
        local cycleBox = New("TextBox", {
            Size = UDim2.new(0,60,0,24), Position = UDim2.new(0,160,0,136),
            BackgroundColor3 = Color3.fromRGB(24,24,30),
            Text = tostring(_signState.cycleSec or 5),
            TextColor3 = Color3.fromRGB(230,230,240),
            Font = Enum.Font.Gotham, TextSize = 12,
            ClearTextOnFocus = false, BorderSizePixel = 0, Parent = panel,
        })
        Corner(cycleBox, 5); Stroke(cycleBox, Color3.fromRGB(50,45,80), 1, 0.2)

        -- Messages list (one per line)
        New("TextLabel", {
            Size = UDim2.new(1,-24,0,14), Position = UDim2.new(0,12,0,170),
            BackgroundTransparency = 1, Text = "RANDOM MESSAGE POOL (one per line)",
            TextColor3 = Color3.fromRGB(150,140,200),
            Font = Enum.Font.GothamBold, TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
        })
        local listBox = New("TextBox", {
            Size = UDim2.new(1,-24,0,110), Position = UDim2.new(0,12,0,186),
            BackgroundColor3 = Color3.fromRGB(24,24,30),
            Text = table.concat(_signState.randomList, "\n"),
            PlaceholderText = "yo\nDeal?\nL Trade\nAdd more please",
            PlaceholderColor3 = Color3.fromRGB(150,140,180),
            TextColor3 = Color3.fromRGB(230,230,240),
            Font = Enum.Font.Gotham, TextSize = 12,
            MultiLine = true, ClearTextOnFocus = false,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            BorderSizePixel = 0, Parent = panel,
        })
        Corner(listBox, 5); Stroke(listBox, Color3.fromRGB(50,45,80), 1, 0.2)
        do local p=Instance.new("UIPadding",listBox); p.PaddingLeft=UDim.new(0,8); p.PaddingTop=UDim.new(0,4) end

        -- Save & Apply button
        local saveBtn = New("TextButton", {
            Size = UDim2.new(1,-24,0,32), Position = UDim2.new(0,12,1,-44),
            BackgroundColor3 = Color3.fromRGB(40,160,70),
            Text = "Save & Apply",
            TextColor3 = Color3.fromRGB(255,255,255),
            Font = Enum.Font.GothamBold, TextSize = 12,
            AutoButtonColor = false, BorderSizePixel = 0, Parent = panel,
        })
        Corner(saveBtn, 6)
        saveBtn.MouseEnter:Connect(function() saveBtn.BackgroundColor3 = Color3.fromRGB(60,180,90) end)
        saveBtn.MouseLeave:Connect(function() saveBtn.BackgroundColor3 = Color3.fromRGB(40,160,70) end)
        saveBtn.Activated:Connect(function()
            _signState.manual = manualBox.Text or ""
            _signState.cycleSec = tonumber(cycleBox.Text) or 5
            -- Parse list — split on newlines, drop empties
            _signState.randomList = {}
            for line in (listBox.Text or ""):gmatch("[^\r\n]+") do
                local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
                if trimmed ~= "" then table.insert(_signState.randomList, trimmed) end
            end
            _applySignToTrade()
            SetStatus("Sign saved", Color3.fromRGB(40,200,80), 2)
        end)
    end

    -- All spawnable animal names for dropdown
    local FT_ANIMALS = {}
    for _, group in ipairs(ANIMALS_BY_RARITY) do
        for _, name in ipairs(group.names) do
            table.insert(FT_ANIMALS, name)
        end
    end
    local FT_MUTATIONS = {"None","Gold","Diamond","Bloodrot","Rainbow","Candy","Lava","Galaxy","YinYang","Radioactive","Cursed","Divine","Cyber"}
    -- Trait list for fake-trade setup. "None" means no extra traits.
    -- Mirrors the spawner's TRAITS table so the picker stays in sync.
    local FT_TRAITS = {"None"}
    for _, t in ipairs(TRAITS) do table.insert(FT_TRAITS, t) end

    local lastFakeTradePos = UDim2.new(0.5, 0, 0.5, 0)  -- remember position between opens

    LaunchFakeTrade = function(username, theirItems)
        _liveTheirItems = theirItems  -- expose to AddItem
        _kvForceAcceptDispatcher = nil  -- new trade gets a fresh dispatcher when rbCloneF binds
        local animalsData = {}
        local mutationsData = {}
        local traitsData = {}
        pcall(function() animalsData = require(RS.Datas.Animals) end)
        pcall(function() mutationsData = require(RS.Datas.Mutations) end)
        pcall(function() traitsData = require(RS.Datas.Traits) end)

        local function calcGen(animalName, mutation, traits)
            local ok, result = pcall(function()
                local aData = animalsData[animalName]
                if not aData then return 0 end
                local base = aData.Generation or 0
                -- exact formula from SharedAnimals: multiplier starts at 1, everything adds to it
                local multiplier = 1
                if mutation and mutation ~= "None" then
                    local md = mutationsData[mutation]
                    if md and md.Modifier then multiplier = multiplier + md.Modifier end
                end
                for _, tn in ipairs(traits or {}) do
                    local td = traitsData[tn]
                    if td and td.MultiplierModifier then
                        multiplier = multiplier + td.MultiplierModifier
                    end
                end
                return base * multiplier
            end)
            if ok then return result or 0 else return 0 end
        end

        local pg = LocalPlayer.PlayerGui

        -- Remove old fake trade if exists
        local old = pg:FindFirstChild("KV_FakeTrade")
        if old then old:Destroy() end

        -- Clone the real GUI (exists but disabled)
        local real = pg:FindFirstChild("TradeLiveTrade")
        if not real then SetStatus("TradeLiveTrade not in PlayerGui!", Color3.fromRGB(255,80,80), 3); return end

        -- never enable the real GUI - only use clone
        -- real stays Enabled=false so TradeController sees nothing
        local clone = real:Clone()
        clone.Name = "KV_FakeTrade"
        clone.ResetOnSpawn = false
        clone.Enabled = true
        clone.Parent = pg

        -- ── Inject reaction button labels right at clone time ──
        -- Walk every descendant and rename the placeholder text directly. No
        -- watchdog, no race conditions — by the time the user sees the trade,
        -- everything is already labeled.
        do
            -- Map of TARGET_LABEL → list of texts to recognize
            local LABELS = {"Add More", "Deal?", "L Trade", "Fair Trade", "Sign", "No Thanks"}
            local SIGN_TEXTS = {"Add More!", "Deal?", "L Trade", "Fair Trade!", "Sign", "No Thanks!"}

            -- Group all "Add More"-text buttons by their parent so we can sort by
            -- AbsolutePosition and rename in order (same approach as before, but
            -- run right at clone time, before the user ever sees the UI).
            local groupsByParent = {}
            local function noteBtn(btn)
                if not btn then return end
                local p = btn.Parent
                groupsByParent[p] = groupsByParent[p] or {}
                for _, x in ipairs(groupsByParent[p]) do if x == btn then return end end
                table.insert(groupsByParent[p], btn)
            end
            for _, d in ipairs(clone:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text and d.Text:lower():find("add more") then
                    local btn = d.Parent
                    while btn and not (btn:IsA("TextButton") or btn:IsA("ImageButton")) do
                        btn = btn.Parent
                        if btn == clone then btn = nil; break end
                    end
                    noteBtn(btn)
                elseif d:IsA("TextButton") and d.Text and d.Text:lower():find("add more") then
                    noteBtn(d)
                end
            end

            for _, btns in pairs(groupsByParent) do
                if #btns >= 2 then
                    table.sort(btns, function(a, b)
                        local pa, pb = a.AbsolutePosition, b.AbsolutePosition
                        if math.abs(pa.Y - pb.Y) > 5 then return pa.Y < pb.Y end
                        return pa.X < pb.X
                    end)
                    for i, btn in ipairs(btns) do
                        local label = LABELS[i] or ("Reaction "..i)
                        local sign  = SIGN_TEXTS[i] or label
                        -- Set both the button itself and any descendant text labels
                        if btn:IsA("TextButton") and btn.Text and btn.Text ~= "" then
                            btn.Text = label
                        end
                        for _, c in ipairs(btn:GetDescendants()) do
                            if c:IsA("TextLabel") then c.Text = label end
                        end
                        -- Wire click sound + YourSign text update
                        btn:SetAttribute("KVSignText", sign)
                        if not btn:GetAttribute("KVReactionWired") then
                            btn:SetAttribute("KVReactionWired", true)
                            btn.AutoButtonColor = false
                            local capturedSign = sign
                            local capturedBtn  = btn
                            local capturedLbl  = label
                            btn.Activated:Connect(function()
                                pcall(function()
                                    require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated")
                                end)
                                pcall(function()
                                    local trade = LocalPlayer.PlayerGui:FindFirstChild("KV_FakeTrade")
                                    local innerT = trade and trade:FindFirstChild("TradeLiveTrade")
                                    local mySign = innerT and innerT:FindFirstChild("YourSign")
                                    if not mySign then return end
                                    -- pick the biggest non-username text label
                                    local target, biggest = nil, 0
                                    for _, d in ipairs(mySign:GetDescendants()) do
                                        if d:IsA("TextLabel") and d.Name:lower() ~= "username"
                                           and (d.TextSize or 0) > biggest then
                                            biggest = d.TextSize; target = d
                                        end
                                    end
                                    if target then target.Text = capturedSign end
                                end)
                            end)
                            -- Lock the label so game scripts can't overwrite it
                            if btn:IsA("TextButton") then
                                btn:GetPropertyChangedSignal("Text"):Connect(function()
                                    if capturedBtn.Text ~= capturedLbl then capturedBtn.Text = capturedLbl end
                                end)
                            end
                            for _, c in ipairs(btn:GetDescendants()) do
                                if c:IsA("TextLabel") then
                                    local cap = c
                                    c:GetPropertyChangedSignal("Text"):Connect(function()
                                        if cap.Text ~= capturedLbl then cap.Text = capturedLbl end
                                    end)
                                end
                            end
                        end
                    end
                end
            end

            -- Also: the big center "Last Offer" button — relabel to "Sign" so it
            -- matches the new compact set, and turn it into a manual Sign trigger.
            for _, d in ipairs(clone:GetDescendants()) do
                if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text and d.Text:lower():find("last offer") then
                    d.Text = "Sign"
                end
            end
        end


        local inner = clone:FindFirstChild("TradeLiveTrade")
        if not inner then clone:Destroy(); SetStatus("Inner frame missing!", Color3.fromRGB(255,80,80), 3); return end
        inner.Visible = true
        inner.AnchorPoint = Vector2.new(0.5, 0.5)
        -- start offscreen above, tween down like real trade (TopQuint style)
        local targetPos = UDim2.new(0.5, 0, 0.5, 0)
        local targetSize = inner.Size
        inner.Position = targetPos + UDim2.fromScale(0, -2)
        inner.Size = targetSize + UDim2.fromScale(0, 0)
        clone.DisplayOrder = 1500
        -- tween in: position slides down, 0.5s Quint
        local TS = game:GetService("TweenService")
        local tweenIn = TS:Create(inner, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = targetPos,
            Size = targetSize,
        })
        tweenIn:Play()
        -- blur + fov like real trade
        pcall(function()
            local RS2 = game:GetService("ReplicatedStorage")
            local cam = require(RS2.Controllers.CameraController)
            cam:Blur(12, 0.5)
            cam:Fov(60, 0.5)
        end)

        -- reset all ready/confirmed frames to hidden
        pcall(function()
            local yrf = inner.Your:FindFirstChild("Ready")
            if yrf then
                yrf.Visible = false
                local lbl = yrf:FindFirstChild("Label")
                if lbl then lbl.Text = "Ready!" end
            end
            local orf = inner.Other:FindFirstChild("Ready")
            if orf then
                orf.Visible = false
                local lbl2 = orf:FindFirstChild("Label")
                if lbl2 then lbl2.Text = "Ready!" end
            end
        end)

        -- Hide side HUD (shop/rebirth/index/duels buttons) like real trade does
        local hudGui = nil
        pcall(function()
            hudGui = LocalPlayer.PlayerGui:FindFirstChild("LeftCenter")
            if hudGui then hudGui.Enabled = false end
        end)

        -- CRITICAL: kill all real game script connections on the clone
        -- The real TradeController has Activated connections on ReadyButton
        -- that fire Ready/Accept remotes to server - replace with clean copy
        pcall(function()
            local rb = inner.Other:FindFirstChild("ReadyButton")
            if rb then
                local clean = rb:Clone()
                rb:Destroy()
                clean.Parent = inner.Other
            end
        end)
        -- Also kill Cancel button's real connection
        pcall(function()
            local cb = inner.Other:FindFirstChild("Cancel")
            if cb then
                local clean = cb:Clone()
                cb:Destroy()
                clean.Parent = inner.Other
            end
        end)
        -- Kill Close button's real connection
        pcall(function()
            local hdr = inner:FindFirstChild("Header")
            local closeBtn = hdr and hdr:FindFirstChild("Close")
            if closeBtn then
                local clean = closeBtn:Clone()
                closeBtn:Destroy()
                clean.Parent = hdr
            end
        end)

        -- hide proximity prompts - use Heartbeat to enforce since game re-enables them
        local hiddenPrompts = {}
        pcall(function()
            local plot = GetPlayerPlot()
            if not plot then return end
            for _, p in plot:GetDescendants() do
                if p:IsA("ProximityPrompt") then
                    table.insert(hiddenPrompts, {p=p, dist=p.MaxActivationDistance})
                    p.MaxActivationDistance = 0
                end
            end
        end)
        -- restore prompts on close (no heartbeat needed - set once)
        clone.AncestryChanged:Connect(function()
            if not clone.Parent then
                _activeFakeStartTimer = nil
                _liveTheirItems = nil
                pcall(RestoreAll)
                for _, entry in ipairs(hiddenPrompts) do
                    pcall(function() entry.p.MaxActivationDistance = entry.dist end)
                end
            end
        end)

        task.spawn(function()
            -- Your side
            pcall(function()
                inner.Your.Username.Text = "Your Offer"
                inner.Your.PlayerImage.Headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(LocalPlayer.UserId)
            end)
            -- Your sign
            pcall(function()
                inner.YourSign.PlayerImage.Headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(LocalPlayer.UserId)
                inner.YourSign.Username.Text = "@"..LocalPlayer.Name
            end)

            -- Other side username
            pcall(function() inner.Other.Username.Text = "@"..username.."'s Offer" end)

            -- Other headshot via userId lookup
            local ok, userId = pcall(function()
                return game:GetService("Players"):GetUserIdFromNameAsync(username)
            end)
            if ok and userId then
                pcall(function()
                    inner.Other.PlayerImage.Headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(userId)
                end)
                pcall(function()
                    inner.OtherSign.PlayerImage.Headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100"):format(userId)
                    inner.OtherSign.Username.Text = "@"..username
                end)
            end

            -- Slot counts - use actual rebirth data
            local realAnimalCountInit = 0
            local yourMax = 10  -- default rebirth 0
            pcall(function()
                local ch = GetSyncChannel()
                local pods = ch and ch:Get("AnimalPodiums") or {}
                local rebirth = ch and ch:Get("Rebirth") or 0
                -- MaxAnimals from Datas.Bases[rebirth]
                local basesData = require(RS.Datas.Bases)
                local rebirthData = basesData[rebirth] or basesData[0]
                if rebirthData then yourMax = rebirthData.MaxAnimals end
                for _, v in pairs(pods) do
                    if type(v) == "table" and v.Index then realAnimalCountInit = realAnimalCountInit + 1 end
                end
            end)
            local totalYours = realAnimalCountInit + #spawnedModels
            pcall(function() inner.Your.BaseSlots.Text = totalYours.."/"..yourMax end)

            -- Other side
            local otherMax = math.random(20, 27)
            local minFilled = math.max(#theirItems, 10)
            local otherCur = math.random(minFilled, math.min(minFilled+5, otherMax))
            pcall(function() inner.Other.BaseSlots.Text = otherCur.."/"..otherMax end)
        end)

        -- Their brainrots → Other.ScrollingFrame
        pcall(function()
            local scroll = inner.Other.ScrollingFrame
            local tmpl   = scroll:FindFirstChild("Template")
            if not tmpl then return end
            for _, v in scroll:GetChildren() do
                if v ~= tmpl and v:IsA("Frame") then v:Destroy() end
            end
            for i, item in ipairs(theirItems) do
                local f = tmpl:Clone()
                f.Name = "FT_"..i
                f.Visible = true
                f.LayoutOrder = i
                local sp = f:FindFirstChild("Spacer")
                if sp then
                    pcall(function() sp.Title.Text = item.name end)
                    pcall(function()
                        local function fmt(n)
                            local function c(s,x) return s:gsub("%.0+"..x,x):gsub("(%.%d-)0+"..x,"%1"..x) end
                            if n>=1e12 then return c(("%.1fT"):format(n/1e12),"T")
                            elseif n>=1e9 then return c(("%.1fB"):format(n/1e9),"B")
                            elseif n>=1e6 then return c(("%.1fM"):format(n/1e6),"M")
                            elseif n>=1e3 then return c(("%.1fK"):format(n/1e3),"K")
                            else return tostring(math.floor(n)) end
                        end
                        -- include traits in the gen calc so the trade entry shows
                        -- the boosted $/s — matches what the recipient will see.
                        local gen = calcGen(item.name, item.mutation, item.traits or {})
                        if gen > 0 then sp.Cash.Text = "$"..fmt(gen).."/s" end
                    end)
                    -- viewport + animation
                    pcall(function()
                        local sa = GetSharedAnimals()
                        if sa and sa.AttachOnViewportWithOptimizations then
                            sa:AttachOnViewportWithOptimizations(item.name, sp.ViewportFrame, nil, item.mutation ~= "None" and item.mutation or nil)
                        end
                    end)
                    -- render trait icons (matches the live-overhead Traits row)
                    pcall(function()
                        if not item.traits or #item.traits == 0 then return end
                        local traitsFrame = sp:FindFirstChild("Traits")
                            or f:FindFirstChild("Traits", true)
                        if not traitsFrame then return end
                        traitsFrame.ClipsDescendants = false  -- show all icons, not just first 4
                        local tmplT = traitsFrame:FindFirstChild("Template")
                        if not tmplT then return end
                        tmplT.Visible = false
                        local liveTraitData = nil
                        pcall(function() liveTraitData = require(RS.Datas.Traits) end)
                        local shown = 0
                        for _, t in ipairs(item.traits) do
                            -- show every trait, no cap
                            local icon = TRAIT_ICONS[t]
                                or (liveTraitData and liveTraitData[t] and liveTraitData[t].Icon)
                            if icon then
                                local img = tmplT:Clone()
                                img.Image   = icon
                                img.Visible = true
                                img.Parent  = traitsFrame
                                shown = shown + 1
                            end
                        end
                        traitsFrame.Visible = shown > 0
                    end)
                end
                f.Parent = scroll
            end
        end)

        -- Update slot count
        pcall(function() inner.Other.BaseSlots.Text = #theirItems.."/15" end)


        -- Hook Close and Cancel buttons - show notification then close
        -- fake timer countdown
        -- all state at top level so every function shares same upvalues
        local timerConn  = nil
        local timerDoneF = false
        local isReadyF   = false
        local rbCloneF   = nil
        -- Force-Accept flags: set when the user fires the dispatcher at the
        -- corresponding stage so the user's own click skips the redundant
        -- "wait for fake to ready/confirm" delay.  Each is consumed once.
        local kvFakeForceReadied   = false
        local kvFakeForceConfirmed = false
        local readyFrameF = inner.Your:FindFirstChild("Ready")
        local selectedSlots = {}  -- shared between inject block and timer sequence
        local slotToModel   = {}  -- maps slot frame Name -> spawnedModel (fake only)
        local inConfirmStage = false  -- blocks slot clicks during confirm
        local tradeCancelled = false  -- kills all pending delayed tasks

        local function UpdateReadyStyleF()
            if not rbCloneF then return end
            local txt = rbCloneF:FindFirstChild("Txt")
            if isReadyF then
                rbCloneF.BackgroundColor3 = Color3.fromRGB(112,112,112)
            elseif timerDoneF then
                rbCloneF.BackgroundColor3 = Color3.fromRGB(81,158,86)
            else
                rbCloneF.BackgroundColor3 = Color3.fromRGB(112,112,112)
            end
            if txt then txt.Text = "READY" end
        end

        local function StartTimer()
            -- don't reset if in confirm stage
            if inConfirmStage then return end
            -- unready
            if isReadyF then
                isReadyF = false
                if readyFrameF then readyFrameF.Visible = false end
            end
            -- hide other ready frame too when timer resets
            pcall(function()
                local otherReady = inner.Other:FindFirstChild("Ready")
                if otherReady then otherReady.Visible = false end
            end)
            timerDoneF = false
            UpdateReadyStyleF()
            if timerConn then pcall(function() timerConn:Disconnect() end) end
            local timerLbl = inner.Other:FindFirstChild("Timer")
            if not timerLbl then return end
            local t = 5.0
            timerLbl.Text = "⏰5.0s Left"
            timerConn = RunService.Heartbeat:Connect(function(dt)
                t = math.max(0, t - dt)
                local txt2 = ("%.1f"):format(t)
                txt2 = txt2:gsub("%.0$","")
                timerLbl.Text = "⏰"..txt2.."s Left"
                if t <= 0 then
                    timerLbl.Text = ""
                    timerConn:Disconnect(); timerConn = nil
                    timerDoneF = true
                    UpdateReadyStyleF()
                end
            end)
        end

        -- store rb reference for cleanup
        local _rbRef = nil
        local function RestoreAll()
            pcall(function() if hudGui then hudGui.Enabled = true end end)
            pcall(function() if _rbRef then _rbRef.Visible = true end end)
            pcall(function()
                local RS2 = game:GetService("ReplicatedStorage")
                local cam = require(RS2.Controllers.CameraController)
                cam:Blur(0, 0.4)
                cam:Fov(cam:GetDefaultFov(), 0.4)
            end)
        end

        local function AnimateClose(cb)
            fakeTradeItems = {}  -- clear so next trade starts fresh
            RestoreAll()
            local TS2 = game:GetService("TweenService")
            local tweenOut = TS2:Create(inner, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = inner.Position + UDim2.fromScale(0, -2),
                Size = inner.Size + UDim2.fromScale(0, 0),
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                pcall(function() clone:Destroy() end)
                if cb then cb() end
            end)
        end

        local function DoCancel()
            tradeCancelled = true
            _activeFakeStartTimer = nil
            if timerConn then pcall(function() timerConn:Disconnect() end) end
            pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
            pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Error") end)
            pcall(function()
                local nc = require(RS.Controllers.NotificationController)
                nc:Error("@"..LocalPlayer.Name.." canceled")
            end)
            AnimateClose()
        end
        pcall(function()
            local closeBtn = inner.Header:FindFirstChild("Close")
            if closeBtn then
                closeBtn.Activated:Connect(DoCancel)
                -- Hover animation on the X (matches real trade)
                local TS_ = game:GetService("TweenService")
                local origSize = closeBtn.Size
                local hoverSize = UDim2.new(
                    origSize.X.Scale * 1.12, origSize.X.Offset * 1.12,
                    origSize.Y.Scale * 1.12, origSize.Y.Offset * 1.12
                )
                local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                closeBtn.MouseEnter:Connect(function()
                    pcall(function() TS_:Create(closeBtn, tweenInfo, {Size = hoverSize}):Play() end)
                end)
                closeBtn.MouseLeave:Connect(function()
                    pcall(function() TS_:Create(closeBtn, tweenInfo, {Size = origSize}):Play() end)
                end)
            end
        end)
        pcall(function()
            local cancelBtn = inner.Other:FindFirstChild("Cancel")
            if cancelBtn then cancelBtn.Activated:Connect(DoCancel) end
        end)

        -- Wire side reaction buttons (Add More, Deal?, L Trade, Fair Trade, Last Offer, No Thanks)
        -- The game's labeling script doesn't fire on the cloned UI, so all 6 buttons read
        -- the raw template text "Add More". We detect them by that text, sort by position,
        -- and rewrite labels ourselves, then attach click sound + tap animation.
        pcall(function()
            local TS_r = game:GetService("TweenService")
            local LABELS = {"Add More", "Deal?", "L Trade", "Fair Trade", "Sign", "No Thanks"}
            local SIGN_TEXTS = {"Add More!", "Deal?", "L Trade", "Fair Trade!", "Sign", "No Thanks!"}

            local function setBtnLabel(btn, label)
                -- Try the button's own .Text first, then any descendant TextLabel
                if btn:IsA("TextButton") and btn.Text and btn.Text ~= "" then
                    btn.Text = label
                    return
                end
                for _, c in ipairs(btn:GetDescendants()) do
                    if c:IsA("TextLabel") then
                        c.Text = label
                        return
                    end
                end
            end

            local function wireReactionBtn(b, signText)
                if b:GetAttribute("KVReactionWired") then return end
                b:SetAttribute("KVReactionWired", true)
                b.AutoButtonColor = false
                local origSize = b.Size
                local pressedSize = UDim2.new(origSize.X.Scale*0.92, origSize.X.Offset*0.92,
                                              origSize.Y.Scale*0.92, origSize.Y.Offset*0.92)
                local hoverSize = UDim2.new(origSize.X.Scale*1.04, origSize.X.Offset*1.04,
                                            origSize.Y.Scale*1.04, origSize.Y.Offset*1.04)
                local tIn  = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local tOut = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                b.MouseEnter:Connect(function() pcall(function() TS_r:Create(b, tIn, {Size = hoverSize}):Play() end) end)
                b.MouseLeave:Connect(function() pcall(function() TS_r:Create(b, tOut, {Size = origSize}):Play() end) end)
                b.MouseButton1Down:Connect(function() pcall(function() TS_r:Create(b, tIn, {Size = pressedSize}):Play() end) end)
                b.MouseButton1Up:Connect(function() pcall(function() TS_r:Create(b, tOut, {Size = hoverSize}):Play() end) end)
                b.Activated:Connect(function()
                    pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
                    -- Update the YourSign center text, mirroring real reactions
                    pcall(function()
                        local sign = inner:FindFirstChild("YourSign")
                        if not sign then return end
                        for _, d in ipairs(sign:GetDescendants()) do
                            if d:IsA("TextLabel") and d.TextSize and d.TextSize >= 18 then
                                d.Text = signText
                                break
                            end
                        end
                    end)
                end)
            end

            local function scanForReactions()
                -- Group buttons containing "Add More" text by their parent.
                -- Scan the WHOLE clone (the buttons can sit outside `inner`).
                local groupsByParent = {}
                local function noteBtn(btn)
                    if not btn then return end
                    local p = btn.Parent
                    groupsByParent[p] = groupsByParent[p] or {}
                    for _, x in ipairs(groupsByParent[p]) do if x == btn then return end end
                    table.insert(groupsByParent[p], btn)
                end
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text and d.Text:lower():find("add more") then
                        local btn = d.Parent
                        while btn and not (btn:IsA("TextButton") or btn:IsA("ImageButton")) do
                            btn = btn.Parent
                            if btn == clone then btn = nil; break end
                        end
                        noteBtn(btn)
                    elseif d:IsA("TextButton") and d.Text and d.Text:lower():find("add more") then
                        noteBtn(d)
                    end
                end

                for _, btns in pairs(groupsByParent) do
                    if #btns >= 2 then
                        -- sort top-to-bottom, left-to-right by absolute position
                        table.sort(btns, function(a, b)
                            local pa, pb = a.AbsolutePosition, b.AbsolutePosition
                            if math.abs(pa.Y - pb.Y) > 5 then return pa.Y < pb.Y end
                            return pa.X < pb.X
                        end)
                        for i, btn in ipairs(btns) do
                            local label = LABELS[i] or ("Reaction "..i)
                            local sign  = SIGN_TEXTS[i] or label
                            setBtnLabel(btn, label)
                            -- Lock the label by attribute, and re-set it whenever something
                            -- (like the game's scripts) tries to overwrite it back to "Add More".
                            if not btn:GetAttribute("KVLabelLocked") then
                                btn:SetAttribute("KVLabelLocked", true)
                                if btn:IsA("TextButton") then
                                    btn:GetPropertyChangedSignal("Text"):Connect(function()
                                        if btn.Text ~= label then btn.Text = label end
                                    end)
                                end
                                for _, c in ipairs(btn:GetDescendants()) do
                                    if c:IsA("TextLabel") then
                                        c:GetPropertyChangedSignal("Text"):Connect(function()
                                            if c.Text ~= label then c.Text = label end
                                        end)
                                    end
                                end
                            end
                            wireReactionBtn(btn, sign)
                        end
                    end
                end
            end

            -- A small number of timed scans. Once labeling completes (BOTH
            -- sides — your side AND their side, 12 buttons total), subsequent
            -- scans short-circuit. No DescendantAdded listener (caused crashes).
            local labelingDone = false
            local function safeScan()
                if labelingDone then return end
                pcall(scanForReactions)
                -- Mark done only when BOTH sides are wired (≥12 buttons)
                local wired = 0
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:GetAttribute("KVReactionWired") then wired = wired + 1 end
                    if wired >= 12 then break end
                end
                if wired >= 12 then labelingDone = true end
            end
            safeScan()
            task.delay(0.3, safeScan)
            task.delay(1.0, safeScan)
            task.delay(2.5, safeScan)
        end)

        -- start timer immediately on open
        _activeFakeStartTimer = StartTimer
        StartTimer()

        -- Ready button clone setup
        task.delay(0.2, function()
            local rb = inner.Other:FindFirstChild("ReadyButton")
            if not rb then return end
            rbCloneF = rb:Clone()
            rb.Visible = false
            _rbRef = rb  -- store for RestoreAll
            rbCloneF.Active = true
            rbCloneF.Interactable = true
            rbCloneF.Parent = rb.Parent
            UpdateReadyStyleF()

            -- Force Accept dispatcher: snaps the partner's frame on AND restarts
            -- the appropriate stage timer — exactly like the partner readying or
            -- confirming first.
            -- • In Ready stage: shows partner's "Ready!" frame, restarts the 5s
            --   wait timer, button greys out → green when timer elapses, user
            --   then clicks Ready to advance.  Sets kvFakeForceReadied so the
            --   user's Ready click skips the redundant 5s "wait for fake to
            --   ready" step (the fake's already ready).
            -- • In Accept (confirm) stage: shows partner's "Confirmed!" frame,
            --   restarts the 5s confirm timer, button greys → green, user then
            --   clicks ACCEPT to finalize.  Sets kvFakeForceConfirmed so the
            --   user's ACCEPT click skips the redundant 5s "wait for fake to
            --   confirm" step.
            _kvForceAcceptDispatcher = function()
                if tradeCancelled then return end
                pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)

                if inConfirmStage then
                    -- Accept (confirm) stage path
                    kvFakeForceConfirmed = true
                    pcall(function()
                        local or3 = inner.Other:FindFirstChild("Ready")
                        if or3 then
                            or3.Visible = true
                            local lbl3 = or3:FindFirstChild("Label")
                            if lbl3 then lbl3.Text = "Confirmed!" end
                        end
                    end)
                    -- Restart the 5s confirm wait timer.  The Confirm-click
                    -- handler reads `confirmReady` (set in its own timer cb);
                    -- it lives in a tighter scope so we can't reach it from
                    -- here, but the original timer keeps running too — this
                    -- new timer is purely visual feedback to match the Ready-
                    -- stage UX.  The flag above is what actually matters.
                    if timerConn then pcall(function() timerConn:Disconnect() end) end
                    if rbCloneF then rbCloneF.BackgroundColor3 = Color3.fromRGB(112,112,112) end
                    local timerLblFC = inner.Other:FindFirstChild("Timer")
                    if timerLblFC then
                        local tFC = 5.0
                        timerLblFC.Text = "⏰5.0s Left"
                        timerConn = RunService.Heartbeat:Connect(function(dt)
                            tFC = math.max(0, tFC - dt)
                            local sFC = ("%.1f"):format(tFC):gsub("%.0$","")
                            timerLblFC.Text = "⏰"..sFC.."s Left"
                            if tFC <= 0 then
                                timerLblFC.Text = ""
                                timerConn:Disconnect(); timerConn = nil
                                if rbCloneF then rbCloneF.BackgroundColor3 = Color3.fromRGB(81,158,86) end
                            end
                        end)
                    end
                    return
                end

                -- Ready stage path
                kvFakeForceReadied = true
                pcall(function()
                    local otherReady = inner.Other:FindFirstChild("Ready")
                    if otherReady then
                        otherReady.Visible = true
                        local lbl = otherReady:FindFirstChild("Label")
                        if lbl then lbl.Text = "Ready!" end
                    end
                end)
                if timerConn then pcall(function() timerConn:Disconnect() end) end
                timerDoneF = false
                isReadyF = false
                if readyFrameF then readyFrameF.Visible = false end
                UpdateReadyStyleF()
                local timerLblF = inner.Other:FindFirstChild("Timer")
                if timerLblF then
                    local tF = 5.0
                    timerLblF.Text = "⏰5.0s Left"
                    timerConn = RunService.Heartbeat:Connect(function(dt)
                        tF = math.max(0, tF - dt)
                        local sF = ("%.1f"):format(tF):gsub("%.0$","")
                        timerLblF.Text = "⏰"..sF.."s Left"
                        if tF <= 0 then
                            timerLblF.Text = ""
                            timerConn:Disconnect(); timerConn = nil
                            timerDoneF = true
                            UpdateReadyStyleF()
                        end
                    end)
                end
            end

            rbCloneF.MouseButton1Click:Connect(function()
                pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
                if not timerDoneF or isReadyF then return end
                isReadyF = true
                if readyFrameF then readyFrameF.Visible = true end
                UpdateReadyStyleF()
                -- restart timer WITHOUT unreadying (bypass the unready logic)
                timerDoneF = false
                if timerConn then pcall(function() timerConn:Disconnect() end) end
                local timerLbl2 = inner.Other:FindFirstChild("Timer")
                if timerLbl2 then
                    -- If the partner was already force-readied via Force Accept,
                    -- skip the redundant 5s "wait for fake to ready" — they're
                    -- already ready, so we go straight to confirm stage.  Flag
                    -- consumed here so subsequent click cycles work normally.
                    local t2 = (kvFakeForceReadied and 0.01) or 5.0
                    kvFakeForceReadied = false
                    timerLbl2.Text = "⏰"..(t2 < 1 and "0.0" or "5.0").."s Left"
                    timerConn = RunService.Heartbeat:Connect(function(dt)
                        t2 = math.max(0, t2 - dt)
                        local s2 = ("%.1f"):format(t2):gsub("%.0$","")
                        timerLbl2.Text = "⏰"..s2.."s Left"
                        if t2 <= 0 then
                            timerLbl2.Text = ""
                            timerConn:Disconnect(); timerConn = nil
                            if tradeCancelled then return end
                            -- 0.5s after YOUR timer: fake player also readies
                            task.delay(0.5, function()
                                if tradeCancelled then return end
                                pcall(function()
                                    local otherReady = inner.Other:FindFirstChild("Ready")
                                    if otherReady then
                                        otherReady.Visible = true
                                        local lbl2 = otherReady:FindFirstChild("Label")
                                        if lbl2 then lbl2.Text = "Ready!" end
                                    end
                                end)
                                -- 0.5s later: enter confirm stage
                                task.delay(0.5, function()
                                    if tradeCancelled then return end
                                    inConfirmStage = true
                                    local confirmReady = false
                                    local rbTxt2 = rbCloneF and rbCloneF:FindFirstChild("Txt")
                                    if rbCloneF then rbCloneF.BackgroundColor3 = Color3.fromRGB(112,112,112) end
                                    if rbTxt2 then rbTxt2.Text = "ACCEPT" end
                                    -- hide both ready frames, deselect slots
                                    pcall(function()
                                        readyFrameF.Visible = false
                                        local lbl = readyFrameF:FindFirstChild("Label")
                                        if lbl then lbl.Text = "Ready!" end
                                    end)
                                    pcall(function()
                                        local or2 = inner.Other:FindFirstChild("Ready")
                                        if or2 then
                                            or2.Visible = false
                                            local lbl2 = or2:FindFirstChild("Label")
                                            if lbl2 then lbl2.Text = "Ready!" end
                                        end
                                    end)
                                    pcall(function()
                                        local scroll = inner.Your:FindFirstChild("ScrollingFrame")
                                        if scroll then
                                            for _, f in scroll:GetChildren() do
                                                if f:IsA("Frame") then
                                                    if not selectedSlots[f.Name] then f.Visible = false end
                                                    local sp = f:FindFirstChild("Spacer")
                                                    if sp then
                                                        sp.BackgroundColor3 = Color3.fromRGB(35,45,50)
                                                        local sk = sp:FindFirstChildOfClass("UIStroke")
                                                        if sk then sk.Color = Color3.fromRGB(0,0,0) end
                                                    end
                                                end
                                            end
                                        end
                                    end)
                                    -- 5s confirm timer
                                    if timerConn then pcall(function() timerConn:Disconnect() end) end
                                    local timerLblC = inner.Other:FindFirstChild("Timer")
                                    if timerLblC then
                                        local tc = 5.0
                                        timerLblC.Text = "⏰5.0s Left"
                                        timerConn = RunService.Heartbeat:Connect(function(dt)
                                            tc = math.max(0, tc - dt)
                                            local s3 = ("%.1f"):format(tc):gsub("%.0$","")
                                            timerLblC.Text = "⏰"..s3.."s Left"
                                            if tc <= 0 then
                                                timerLblC.Text = ""
                                                timerConn:Disconnect(); timerConn = nil
                                                if tradeCancelled then return end
                                                confirmReady = true
                                                if rbCloneF then rbCloneF.BackgroundColor3 = Color3.fromRGB(81,158,86) end
                                            end
                                        end)
                                    end
                                    -- ACCEPT click
                                    local confirmConn
                                    confirmConn = rbCloneF.MouseButton1Click:Connect(function()
                                        if not confirmReady or tradeCancelled then return end
                                        confirmConn:Disconnect()
                                        pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
                                        -- YOUR confirmed
                                        if readyFrameF then
                                            readyFrameF.Visible = true
                                            local lbl = readyFrameF:FindFirstChild("Label")
                                            if lbl then lbl.Text = "Confirmed!" end
                                        end
                                        if rbCloneF then rbCloneF.BackgroundColor3 = Color3.fromRGB(112,112,112) end
                                        -- restart timer, fake player confirms after.
                                        -- If partner was already force-confirmed, skip
                                        -- the redundant 5s wait — they're done.
                                        if timerConn then pcall(function() timerConn:Disconnect() end) end
                                        local timerLblC2 = inner.Other:FindFirstChild("Timer")
                                        if timerLblC2 then
                                            local tc2 = (kvFakeForceConfirmed and 0.01) or 5.0
                                            kvFakeForceConfirmed = false
                                            timerLblC2.Text = "⏰"..(tc2 < 1 and "0.0" or "5.0").."s Left"
                                            timerConn = RunService.Heartbeat:Connect(function(dt)
                                                tc2 = math.max(0, tc2 - dt)
                                                local s4 = ("%.1f"):format(tc2):gsub("%.0$","")
                                                timerLblC2.Text = "⏰"..s4.."s Left"
                                                if tc2 <= 0 then
                                                    timerLblC2.Text = ""
                                                    timerConn:Disconnect(); timerConn = nil
                                                    if tradeCancelled then return end
                                                    task.delay(0.5, function()
                                                        if tradeCancelled then return end
                                                        -- fake player confirms
                                                        pcall(function()
                                                            local or3 = inner.Other:FindFirstChild("Ready")
                                                            if or3 then
                                                                or3.Visible = true
                                                                local lbl2 = or3:FindFirstChild("Label")
                                                                if lbl2 then lbl2.Text = "Confirmed!" end
                                                            end
                                                        end)
                                                        pcall(function()
                                                            local t3 = inner.Other:FindFirstChild("Timer")
                                                            if t3 then t3.Text = "Processing..." end
                                                        end)
                                                        -- 2.5s success
                                                        task.delay(2.5, function()
                                                            if tradeCancelled then return end
                                                            _lastFakeTradeTime = tick()  -- update cooldown
                                                            pcall(function()
                                                                local nc = require(RS.Controllers.NotificationController)
                                                                nc:Success("Trade completed with @"..username.."! 🎉")
                                                            end)
                                                            pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Success") end)
                                                            for slotName, isSelected in pairs(selectedSlots) do
                                                                if isSelected then
                                                                    local mdl = slotToModel[slotName]
                                                                    if mdl and mdl.Parent then
                                                                        pcall(function()
                                                                            local oh = modelOverheads[mdl]
                                                                            if oh then
                                                                                pcall(function() if oh.part then oh.part:Destroy() end end)
                                                                                pcall(function() if oh.att  then oh.att:Destroy()  end end)
                                                                                pcall(function() if oh.gui  then oh.gui:Destroy()  end end)
                                                                                modelOverheads[mdl] = nil
                                                                            end
                                                                            local cp = modelCashpads[mdl]
                                                                            if cp then
                                                                                if cp.conn then cp.conn:Disconnect() end
                                                                                if cp.part then cp.part:Destroy() end
                                                                                modelCashpads[mdl] = nil
                                                                            end
                                                                            modelSnapshots[mdl] = nil
                                                                            for i, m in ipairs(spawnedModels) do
                                                                                if m == mdl then table.remove(spawnedModels, i); break end
                                                                            end
                                                                            -- mirror the sell-path prompt cleanup so the slot
                                                                            -- doesn't keep showing Grab/Sell prompts after trade-away
                                                                            local pi = modelPromptInfo[mdl]
                                                                            if pi then
                                                                                if pi.slot and slotPromptConns[pi.slot] then
                                                                                    for _, c in ipairs(slotPromptConns[pi.slot]) do
                                                                                        pcall(function() c:Disconnect() end)
                                                                                    end
                                                                                    slotPromptConns[pi.slot] = nil
                                                                                end
                                                                                if pi.att then
                                                                                    for _, p2 in pi.att:GetChildren() do
                                                                                        if p2:IsA("ProximityPrompt") then
                                                                                            p2.ActionText = "Interact"
                                                                                            p2.ObjectText = ""
                                                                                            p2:SetAttribute("State", "None")
                                                                                            p2.Enabled = false
                                                                                        end
                                                                                    end
                                                                                end
                                                                                modelPromptInfo[mdl] = nil
                                                                            end
                                                                            ScheduleSave()
                                                                            mdl:Destroy()
                                                                        end)
                                                                    end
                                                                end
                                                            end
                                                            -- spawn received brainrots
                                                            task.spawn(function()
                                                                for _, item in ipairs(theirItems) do
                                                                    SpawnOneAnimal(item.name, item.mutation, item.traits or {})
                                                                end
                                                                DrainPendingSpawns()
                                                            end)
                                                            UpdateCount()
                                                            task.delay(0.5, function() AnimateClose() end)
                                                        end)
                                                    end)
                                                end
                                            end)
                                        end
                                    end)
                                end)
                            end)
                        end
                    end)
                end
            end)
        end)

        -- Inject Your side: real animals from server + fake spawned models
        task.delay(0.15, function()
            local yourScroll = inner.Your:FindFirstChild("ScrollingFrame")
            local tmpl = yourScroll and yourScroll:FindFirstChild("Template")
            if not yourScroll or not tmpl then return end

            -- clear old
            for _, v in yourScroll:GetChildren() do
                if v:IsA("Frame") and v ~= tmpl then v:Destroy() end
            end

            -- selectedSlots declared at LaunchFakeTrade scope above
            -- slotToModel maps slot frame name -> model instance for deletion

            -- capture base counts once
            -- baseMine = same logic as initial display
            local baseMine = 0
            pcall(function()
                local ch = GetSyncChannel()
                local pods = ch and ch:Get("AnimalPodiums") or {}
                for _, v in pairs(pods) do
                    if type(v) == "table" and v.Index then baseMine = baseMine + 1 end
                end
            end)
            baseMine = baseMine + #spawnedModels
            -- capture other side's original numerator
            local otherBaseNum = 0
            pcall(function()
                local bs = inner.Other:FindFirstChild("BaseSlots")
                if bs then otherBaseNum = tonumber(bs.Text:match("(%d+)/")) or 0 end
            end)

            local function MakeSlot(parent, animalName, mutation, index, isReal, mdlRef)
                local snap = {mutation = mutation or "None"}
                local f = tmpl:Clone()
                f.Name = (isReal and "REAL_" or "KV_")..index
                f.Visible = true; f.LayoutOrder = index
                -- track fake model for deletion
                if not isReal and mdlRef then slotToModel[f.Name] = mdlRef end
                local sp = f:FindFirstChild("Spacer")
                if sp then
                    -- raw name in the trade UI — "is Calling..." should only appear
                    -- on the live overhead, not in the trade item list.
                    pcall(function() sp.Title.Text = animalName end)
                    -- accurate cash using SharedAnimals:GetGeneration
                    pcall(function()
                        local snap = mdlRef and modelSnapshots[mdlRef]
                        local traits = snap and snap.traits or {}
                        local sa = GetSharedAnimals()
                        local function fmt(n)
                            local function c(s,x) return s:gsub("%.0+"..x,x):gsub("(%.%d-)0+"..x,"%1"..x) end
                            if n>=1e12 then return c(("%.1fT"):format(n/1e12),"T")
                            elseif n>=1e9 then return c(("%.1fB"):format(n/1e9),"B")
                            elseif n>=1e6 then return c(("%.1fM"):format(n/1e6),"M")
                            elseif n>=1e3 then return c(("%.1fK"):format(n/1e3),"K")
                            else return tostring(math.floor(n)) end
                        end
                        local gen2 = calcGen(animalName, mutation, traits)
                        if gen2 > 0 then sp.Cash.Text = "$"..fmt(gen2).."/s" end
                    end)
                    -- populate traits icons (snap.traits is array of names)
                    pcall(function()
                        local snap = mdlRef and modelSnapshots[mdlRef]
                        local traits = snap and snap.traits or {}
                        if #traits == 0 then return end
                        local traitsFrame = sp:FindFirstChild("Traits")
                        local tmplTrait = traitsFrame and traitsFrame:FindFirstChild("Template")
                        if not traitsFrame or not tmplTrait then return end
                        for _, c in traitsFrame:GetChildren() do
                            if c ~= tmplTrait and not c:IsA("UIGridLayout") and not c:IsA("UIListLayout") then c:Destroy() end
                        end
                        -- ensure layout exists
                        if not traitsFrame:FindFirstChildOfClass("UIGridLayout") and not traitsFrame:FindFirstChildOfClass("UIListLayout") then
                            local gl = Instance.new("UIGridLayout", traitsFrame)
                            gl.CellSize = UDim2.new(0, tmplTrait.AbsoluteSize.X > 0 and tmplTrait.AbsoluteSize.X or 20, 0, tmplTrait.AbsoluteSize.Y > 0 and tmplTrait.AbsoluteSize.Y or 20)
                            gl.CellPadding = UDim2.new(0, 2, 0, 2)
                            gl.SortOrder = Enum.SortOrder.LayoutOrder
                        end
                        for i3, traitName in ipairs(traits) do
                            local icon = tmplTrait:Clone()
                            icon.Name = traitName
                            icon.Visible = true
                            icon.LayoutOrder = i3
                            if TRAIT_ICONS[traitName] then
                                pcall(function() icon.Image = TRAIT_ICONS[traitName] end)
                            end
                            icon.Parent = traitsFrame
                        end
                    end)
                    -- viewport + animation via SharedAnimals (same as real game)
                    pcall(function()
                        local sa = GetSharedAnimals()
                        if sa and sa.AttachOnViewportWithOptimizations then
                            sa:AttachOnViewportWithOptimizations(animalName, sp.ViewportFrame, nil, mutation ~= "None" and mutation or nil)
                        else
                            -- fallback manual viewport
                            local vp=sp.ViewportFrame
                            local cam=Instance.new("Camera"); cam.FieldOfView=50
                            vp.CurrentCamera=cam; cam.Parent=vp
                            local wm=Instance.new("WorldModel",vp)
                            local tmpl2=RS.Models.Animals:FindFirstChild(animalName)
                            if not tmpl2 then return end
                            local m=tmpl2:Clone()
                            if mutation and mutation ~= "None" then
                                pcall(function() sa:ApplyMutation(m,animalName,mutation) end)
                            end
                            for _,p in m:GetDescendants() do
                                if p:IsA("BasePart") then p.CanCollide=false;p.CanQuery=false;p.CanTouch=false;p.Anchored=true end
                            end
                            m:PivotTo(CFrame.new(0,0,0)); m.Parent=wm
                            local ext=m:GetExtentsSize(); local maxDim=math.max(ext.X,ext.Y,ext.Z)
                            local dist=(maxDim*0.5/math.tan(math.rad(25)))*0.75
                            local lookAt=m.PrimaryPart and m.PrimaryPart.CFrame or CFrame.new(0,0,0)
                            cam.CFrame=CFrame.new((lookAt*CFrame.new(Vector3.new(-1,0.25,-1).Unit*(dist+maxDim*0.5))).Position,lookAt.Position)
                            local af=RS.Animations.Animals:FindFirstChild(animalName)
                            local ia=af and af:FindFirstChild("Idle")
                            if ia then
                                local ac=m:FindFirstChildOfClass("AnimationController") or m:FindFirstChildWhichIsA("AnimationController",true)
                                if ac then
                                    local anim=ac:FindFirstChildOfClass("Animator") or Instance.new("Animator",ac)
                                    pcall(function() local tr=anim:LoadAnimation(ia); tr.Looped=true; tr:Play(0) end)
                                end
                            end
                        end
                    end)

                    -- click to select/deselect - use both Activated and InputBegan for compatibility
                    local function onSlotClick()
                        if inConfirmStage then return end
                        -- toggle selection
                        selectedSlots[f.Name] = not selectedSlots[f.Name]
                        local selected = selectedSlots[f.Name]
                        sp.BackgroundColor3 = selected and Color3.fromRGB(15,50,15) or Color3.fromRGB(35,45,50)
                        local sk = sp:FindFirstChildOfClass("UIStroke")
                        if sk then sk.Color = selected and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,0,0) end
                        pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
                        -- restart timer (also unreadys if ready)
                        StartTimer()
                        -- update slot counts
                        pcall(function()
                            local selCount = 0
                            for _, v in pairs(selectedSlots) do if v then selCount = selCount + 1 end end
                            local yourBS = inner.Your:FindFirstChild("BaseSlots")
                            local otherBS = inner.Other:FindFirstChild("BaseSlots")
                            if yourBS then
                                local _, max = yourBS.Text:match("(%d+)/(%d+)")
                                if max then yourBS.Text = math.max(0, baseMine - selCount).."/"..max end
                            end
                            if otherBS then
                                local cur3, max = otherBS.Text:match("(%d+)/(%d+)")
                                cur3 = tonumber(cur3) or otherBaseNum
                                if max then otherBS.Text = (cur3 + (selected and 1 or -1)).."/"..max end
                            end
                        end)
                    end
                    -- debounced click prevents double-fire from Activated+InputBegan
                    local _lastSlotClick = 0
                    local function debouncedClick()
                        local now = tick()
                        if now - _lastSlotClick < 0.15 then return end
                        _lastSlotClick = now
                        onSlotClick()
                    end
                    pcall(function() sp.Activated:Connect(debouncedClick) end)
                    sp.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                           inp.UserInputType == Enum.UserInputType.Touch then
                            debouncedClick()
                        end
                    end)
                end
                f.Parent = parent
            end

            local idx = 1
            -- Real animals from AnimalPodiums
            pcall(function()
                local ch = GetSyncChannel()
                local pods = ch and ch:Get("AnimalPodiums") or {}
                -- sort by key for consistent order
                local sorted = {}
                for k, v in pairs(pods) do
                    if type(v) == "table" and v.Index then
                        table.insert(sorted, v)
                    end
                end
                for _, v in ipairs(sorted) do
                    -- pass traits and mutation from server data
                    local realTraits = {}
                    if type(v.Traits) == "table" then
                        for _, t in ipairs(v.Traits) do table.insert(realTraits, t) end
                    end
                    -- store snapshot so MakeSlot can use it
                    local fakeMdlRef = {} -- dummy ref
                    modelSnapshots[fakeMdlRef] = {mutation = v.Mutation or "None", traits = realTraits}
                    MakeSlot(yourScroll, v.Index, v.Mutation or "None", idx, true, fakeMdlRef)
                    idx = idx + 1
                end
            end)

            -- Fake spawned models
            for _, mdl in ipairs(spawnedModels) do
                if mdl and mdl.Parent then
                    local snap = modelSnapshots[mdl] or {mutation="None"}
                    MakeSlot(yourScroll, mdl.Name, snap.mutation or "None", idx, false, mdl)
                    idx = idx + 1
                end
            end
        end)

        -- Stream mode overlay (press F5 to toggle black cover)
        local streamOverlay = New("Frame", {
            Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(0,0,0),
            BackgroundTransparency=1, BorderSizePixel=0, ZIndex=200,
            Parent=inner,
        })
        New("TextLabel", {
            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text="🔴 STREAM MODE", TextColor3=Color3.fromRGB(255,80,80),
            Font=Enum.Font.GothamBold, TextSize=24,
            TextXAlignment=Enum.TextXAlignment.Center,
            Visible=false, ZIndex=201, Parent=streamOverlay,
        })
        local streamLbl = streamOverlay:FindFirstChildOfClass("TextLabel")
        local streamOn = false
        local streamConn = game:GetService("UserInputService").InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.KeyCode == Enum.KeyCode.F5 then
                streamOn = not streamOn
                streamOverlay.BackgroundTransparency = streamOn and 0 or 1
                if streamLbl then streamLbl.Visible = streamOn end
            end
        end)
        clone.AncestryChanged:Connect(function()
            if not clone.Parent then
                pcall(function() streamConn:Disconnect() end)
            end
        end)

        SetStatus("Fake trade open! (F5 = stream mode)", Color3.fromRGB(40,200,80), 3)

        -- no auto-close - user closes manually via cancel button
    end


    -- Assign to the module-level forward declaration so key listeners
    -- outside this do-block can also call OpenFakeTradeSetup.
    OpenFakeTradeSetup = function(prefill)
        -- If the form already exists in the trading page, just refresh prefill and return.
        if fakeTradeWin and fakeTradeWin.Parent then
            if prefill and type(prefill.username) == "string" and prefill.username ~= "" then
                local existingUsername = fakeTradeWin:FindFirstChild("__usernameBox", true)
                if existingUsername then existingUsername.Text = prefill.username end
            end
            return
        end

        local W, pad = 300, 10

        -- Inline form parented to the Trading tab page (auto-flow via UIListLayout)
        local win2 = New("Frame", {
            Size=UDim2.new(1,0,0,220),
            BackgroundColor3=Color3.fromRGB(30,28,42),
            BorderSizePixel=0, LayoutOrder=2, Parent=tradingPage,
        })
        fakeTradeWin = win2
        Corner(win2, 6)
        Stroke(win2, Color3.fromRGB(50,45,80), 1, 0.2)

        -- Pop-out / dock state. When popped out, win2 lives inside this separate
        -- ScreenGui so it survives sg.Enabled toggles (the main UI hide key).
        local popSg = nil
        local poppedOut = false

        -- ignoreHide is now hoisted to the outer scope so the sign editor
        -- can also follow the same "Show on Hide" preference.
        ignoreHide = (ignoreHide ~= nil) and ignoreHide or true  -- default ON

        local function syncPopSgEnabled()
            if popSg then
                popSg.Enabled = ignoreHide or sg.Enabled
            end
        end

        -- Pop Out + Always-Visible toggle row (split 60/40)
        local popBtn = New("TextButton", {
            Size=UDim2.new(0.6, -pad*1.5, 0, 22), Position=UDim2.new(0, pad, 0, 8),
            BackgroundColor3=Color3.fromRGB(150,105,255),
            Text="Pop Out",
            TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold,
            TextSize=10, AutoButtonColor=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(popBtn, 5)
        popBtn.MouseEnter:Connect(function() popBtn.BackgroundColor3 = Color3.fromRGB(128,112,251) end)
        popBtn.MouseLeave:Connect(function() popBtn.BackgroundColor3 = Color3.fromRGB(150,105,255) end)

        local ignoreBtn = New("TextButton", {
            Size=UDim2.new(0.4, -pad*1.5, 0, 22),
            Position=UDim2.new(0.6, pad*0.5, 0, 8),
            BackgroundColor3 = Color3.fromRGB(40,160,70),
            Text="Show on Hide: ON",
            TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold,
            TextSize=10, AutoButtonColor=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(ignoreBtn, 5)

        local function refreshPopBtnText()
            popBtn.Text = poppedOut and "Dock" or "Pop Out"
        end
        local function refreshIgnoreBtn()
            ignoreBtn.Text = ignoreHide and "Show on Hide: ON" or "Show on Hide: OFF"
            ignoreBtn.BackgroundColor3 = ignoreHide
                and Color3.fromRGB(40,160,70) or Color3.fromRGB(80,80,90)
        end

        popBtn.Activated:Connect(function()
            if poppedOut then
                -- DOCK: back into tradingPage as inline form
                poppedOut = false
                win2.AnchorPoint = Vector2.new(0,0)
                win2.Position = UDim2.new(0,0,0,0)
                win2.Size = UDim2.new(1, 0, 0, win2.Size.Y.Offset)
                win2.Parent = tradingPage
                if popSg then pcall(function() popSg:Destroy() end); popSg = nil end
            else
                -- POP OUT: into separate ScreenGui in bottom-LEFT corner.
                -- Use the form's full computed content height so nothing
                -- gets clipped (was getting cut off when constrained by
                -- the docked tradingPage's UIListLayout).
                poppedOut = true
                popSg = New("ScreenGui", {
                    Name = "KV_TradeSetupPopOut", ResetOnSpawn = false,
                    IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                    DisplayOrder = 5000, Parent = GetSafeParent(),
                })
                syncPopSgEnabled()
                -- Use the actual computed content height (Size.Y.Offset is the
                -- value win2.Size = UDim2.new(1,0,0,y+6) sets at the end of the
                -- form's construction). Cap to 90% of viewport height so it
                -- never goes off-screen on small displays.
                local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                local maxH = viewport and math.floor(viewport.Y * 0.9) or 720
                local naturalH = win2.Size.Y.Offset
                if naturalH < 100 then naturalH = 480 end
                local fixedH = math.min(naturalH, maxH)
                win2.AnchorPoint = Vector2.new(0, 1)
                win2.Position = UDim2.new(0, 16, 1, -16)
                win2.Size = UDim2.new(0, W, 0, fixedH)
                win2.Parent = popSg
                MakeDraggable(win2)
            end
            refreshPopBtnText()
        end)

        ignoreBtn.Activated:Connect(function()
            ignoreHide = not ignoreHide
            refreshIgnoreBtn()
            syncPopSgEnabled()
        end)

        -- Mirror sg's Enabled into popSg's Enabled when ignoreHide is OFF
        sg:GetPropertyChangedSignal("Enabled"):Connect(syncPopSgEnabled)

        local y = 36

        -- Username
        New("TextLabel", {
            Size=UDim2.new(1,-pad*2,0,14), Position=UDim2.new(0,pad,0,y),
            BackgroundTransparency=1, Text="TARGET USERNAME",
            TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
            TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, Parent=win2,
        })
        y = y + 16
        local usernameBox = New("TextBox", {
            Name="__usernameBox",
            Size=UDim2.new(1,-pad*2,0,32), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(24,24,30),
            Text="", PlaceholderText="Enter username...",
            PlaceholderColor3=Color3.fromRGB(150,140,180),
            TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.Gotham,
            TextSize=13, ClearTextOnFocus=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(usernameBox, 5)
        Stroke(usernameBox, Color3.fromRGB(50,45,80), 1, 0.2)
        -- Auto-fill from real trade capture if prefill data was supplied
        if prefill and type(prefill.username) == "string" and prefill.username ~= "" then
            usernameBox.Text = prefill.username
        end
        y = y + 40

        -- Animal + Mutation dropdowns
        New("TextLabel", {
            Size=UDim2.new(1,-pad*2,0,14), Position=UDim2.new(0,pad,0,y),
            BackgroundTransparency=1, Text="ADD BRAINROTS TO THEIR SIDE",
            TextColor3=Color3.fromRGB(230,230,240), Font=Enum.Font.GothamBold,
            TextSize=9, TextXAlignment=Enum.TextXAlignment.Left, Parent=win2,
        })
        y = y + 16

        local selAnimal = FT_ANIMALS[1] or "Skibidi Toilet"
        local selMut = "None"
        local selTraits = {}  -- { [traitName] = true } — multi-select

        -- Stack animal on top, mutation below it on its OWN full-width row.
        -- This way long mutation names ("Radioactive", "Bloodrot", "Rainbow")
        -- never get truncated.
        local rowW = W - pad*2
        local animalW = rowW
        local mutW = rowW
        local animalBtn = New("TextButton", {
            Size=UDim2.new(0, animalW, 0, 32), Position=UDim2.new(0, pad, 0, y),
            BackgroundColor3=Color3.fromRGB(24,24,30),
            Text="▼  " .. selAnimal,
            TextColor3=Color3.fromRGB(230,230,240),
            Font=Enum.Font.GothamBold, TextSize=11, AutoButtonColor=false,
            BorderSizePixel=0, Parent=win2,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
        })
        do local p=Instance.new("UIPadding",animalBtn); p.PaddingLeft=UDim.new(0,10); p.PaddingRight=UDim.new(0,8) end
        Corner(animalBtn, 6)
        Stroke(animalBtn, Color3.fromRGB(50,45,80), 1, 0.2)

        local mutBtn = New("TextButton", {
            Size=UDim2.new(0, mutW, 0, 32), Position=UDim2.new(0, pad, 0, y + 36),
            BackgroundColor3=Color3.fromRGB(24,24,30),
            Text="▼  Mutations  •  Normal",
            TextColor3=Color3.fromRGB(230,230,240),
            Font=Enum.Font.GothamBold, TextSize=11, AutoButtonColor=false,
            BorderSizePixel=0, Parent=win2,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
        })
        do local p=Instance.new("UIPadding",mutBtn); p.PaddingLeft=UDim.new(0,10); p.PaddingRight=UDim.new(0,8) end
        Corner(mutBtn, 6)
        Stroke(mutBtn, Color3.fromRGB(50,45,80), 1, 0.2)

        local function MakeDD(btn, items, cb, withImages, iconTable)
            local open, dd = false, nil
            local shiftedSnapshot = nil
            local origWinH = nil
            local rowH = (withImages or iconTable) and 32 or 28

            local function shrinkBack()
                if shiftedSnapshot then
                    for child, origY in pairs(shiftedSnapshot) do
                        if typeof(child) == "Instance" and child.Parent then
                            local p = child.Position
                            child.Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, origY)
                        end
                    end
                    shiftedSnapshot = nil
                end
                if origWinH then
                    win2.Size = UDim2.new(win2.Size.X.Scale, win2.Size.X.Offset, 0, origWinH)
                    origWinH = nil
                end
            end

            btn.Activated:Connect(function()
                if open then
                    if dd then pcall(function() dd:Destroy() end); dd = nil end
                    shrinkBack()
                    open = false
                    return
                end
                open=true
                local ddHeight = math.min(#items,6)*(rowH+2)+8

                -- Inline expansion: shift everything below this button down,
                -- grow win2 to fit. Same behaviour as traits dropdown.
                local btnBottomY = btn.Position.Y.Offset + btn.Size.Y.Offset
                shiftedSnapshot = {}
                for _, child in ipairs(win2:GetChildren()) do
                    if child:IsA("GuiObject") and child ~= btn then
                        if child.Position.Y.Offset >= btnBottomY then
                            shiftedSnapshot[child] = child.Position.Y.Offset
                            local p = child.Position
                            child.Position = UDim2.new(p.X.Scale, p.X.Offset,
                                p.Y.Scale, p.Y.Offset + ddHeight + 4)
                        end
                    end
                end
                origWinH = win2.Size.Y.Offset
                win2.Size = UDim2.new(win2.Size.X.Scale, win2.Size.X.Offset, 0, origWinH + ddHeight + 4)

                -- Match the trigger button's exact width (Scale + Offset)
                dd = New("Frame", {
                    Size=UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset, 0, ddHeight),
                    Position=UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset,
                                       0, btnBottomY + 4),
                    BackgroundColor3=Color3.fromRGB(30,28,42),
                    BorderSizePixel=0, ZIndex=60, ClipsDescendants=true, Parent=win2,
                })
                Corner(dd,6); Stroke(dd,Color3.fromRGB(50,45,80),1,0.2)
                local sf = New("ScrollingFrame",{
                    Size=UDim2.new(1,-8,1,-8), Position=UDim2.new(0,4,0,4),
                    BackgroundTransparency=1, BorderSizePixel=0,
                    ScrollBarThickness=3, ScrollBarImageColor3=Color3.fromRGB(150,105,255),
                    CanvasSize=UDim2.new(0,0,0,#items*(rowH+2)),
                    AutomaticCanvasSize=Enum.AutomaticSize.Y,
                    ZIndex=61, Parent=dd,
                })
                local ul=Instance.new("UIListLayout",sf)
                ul.SortOrder=Enum.SortOrder.LayoutOrder
                ul.Padding=UDim.new(0,2)

                for ii,it in ipairs(items) do
                    local r=New("TextButton",{
                        Size=UDim2.new(1,0,0,rowH),
                        BackgroundColor3=BG, BackgroundTransparency=0,
                        BorderSizePixel=0, AutoButtonColor=false, Text="",
                        ZIndex=62, LayoutOrder=ii, Parent=sf,
                    })
                    Corner(r, 4)

                    -- rarity stripe (only if we know the rarity)
                    if withImages then
                        local rar = nil
                        for _, group in ipairs(ANIMALS_BY_RARITY) do
                            for _, n in ipairs(group.names) do
                                if n == it then rar = group.rarity; break end
                            end
                            if rar then break end
                        end
                        local rc = (rar and RARITY_COLORS[rar]) or Color3.fromRGB(150,105,255)
                        New("Frame", {
                            Size=UDim2.new(0,3,0.7,0), Position=UDim2.new(0,0,0.15,0),
                            BackgroundColor3=rc, BorderSizePixel=0, ZIndex=63, Parent=r,
                        })
                        -- wiki icon
                        local icon = New("ImageLabel", {
                            Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,8,0.5,-12),
                            BackgroundTransparency=1, Image="",
                            ScaleType=Enum.ScaleType.Fit, ZIndex=63, Parent=r,
                        })
                        do
                            local capturedIcon = icon
                            local capturedName = it
                            task.spawn(function()
                                local waited = 0
                                while not _llGetBrainrotAsset and waited < 5 do
                                    task.wait(0.05); waited = waited + 0.05
                                end
                                if not _llGetBrainrotAsset then return end
                                local ok, asset = pcall(_llGetBrainrotAsset, capturedName)
                                if ok and asset and capturedIcon and capturedIcon.Parent then
                                    capturedIcon.Image = asset
                                end
                            end)
                        end
                        New("TextLabel", {
                            Size=UDim2.new(1,-40,1,0), Position=UDim2.new(0,36,0,0),
                            BackgroundTransparency=1, Text=it,
                            TextColor3=Color3.fromRGB(230,230,240),
                            Font=Enum.Font.GothamBold, TextSize=11,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=63, Parent=r,
                        })
                    elseif iconTable then
                        local imgId = iconTable[it]
                        if imgId and imgId ~= "" then
                            New("ImageLabel", {
                                Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,8,0.5,-12),
                                BackgroundTransparency=1, Image=imgId,
                                ScaleType=Enum.ScaleType.Fit, ZIndex=63, Parent=r,
                            })
                        else
                            -- "None" entry: small red X
                            local xFrame = New("Frame", {
                                Size=UDim2.new(0,20,0,20), Position=UDim2.new(0,10,0.5,-10),
                                BackgroundTransparency=1, ZIndex=63, Parent=r,
                            })
                            New("Frame", {Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,0.5,-1), BackgroundColor3=Color3.fromRGB(180,60,60), BorderSizePixel=0, Rotation=45, ZIndex=64, Parent=xFrame})
                            New("Frame", {Size=UDim2.new(1,0,0,2), Position=UDim2.new(0,0,0.5,-1), BackgroundColor3=Color3.fromRGB(180,60,60), BorderSizePixel=0, Rotation=-45, ZIndex=64, Parent=xFrame})
                        end
                        New("TextLabel", {
                            Size=UDim2.new(1,-40,1,0), Position=UDim2.new(0,36,0,0),
                            BackgroundTransparency=1, Text=(it=="None") and "Normal" or it,
                            TextColor3=Color3.fromRGB(230,230,240),
                            Font=Enum.Font.GothamBold, TextSize=11,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=63, Parent=r,
                        })
                    else
                        New("TextLabel", {
                            Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,8,0,0),
                            BackgroundTransparency=1, Text=it,
                            TextColor3=Color3.fromRGB(230,230,240),
                            Font=Enum.Font.GothamBold, TextSize=11,
                            TextXAlignment=Enum.TextXAlignment.Left,
                            TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=63, Parent=r,
                        })
                    end

                    r.MouseEnter:Connect(function() r.BackgroundColor3=Color3.fromRGB(50,45,80) end)
                    r.MouseLeave:Connect(function() r.BackgroundColor3=BG end)
                    r.Activated:Connect(function()
                        cb(it)
                        if dd then pcall(function() dd:Destroy() end); dd = nil end
                        shrinkBack()
                        open = false
                    end)
                end
            end)
        end

        MakeDD(animalBtn, FT_ANIMALS, function(v)
            selAnimal = v
            animalBtn.Text = "▼  " .. (#v > 28 and (v:sub(1,26).."…") or v)
        end, true)  -- withImages=true → wiki icons + rarity stripes
        MakeDD(mutBtn, FT_MUTATIONS, function(v)
            selMut = v
            mutBtn.Text = "▼  Mutations  •  " .. (v == "None" and "Normal" or v)
        end, false, MUTATION_ICONS)
        y = y + 72  -- two stacked rows (32 each + 4 gap + 4 buffer)

        -- Traits picker — multi-select (toggle each trait on/off).
        -- Button label shows count of currently-selected traits so you don't
        -- have to open the dropdown to remember what you picked.
        local traitsBtn = New("TextButton", {
            Size=UDim2.new(1,-pad*2,0,32), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(24,24,30),
            Text="▼  Traits", TextColor3=Color3.fromRGB(230,230,240),
            Font=Enum.Font.GothamBold, TextSize=11, AutoButtonColor=false,
            BorderSizePixel=0, Parent=win2,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
        })
        do local p=Instance.new("UIPadding",traitsBtn); p.PaddingLeft=UDim.new(0,10); p.PaddingRight=UDim.new(0,8) end
        Corner(traitsBtn, 6)
        Stroke(traitsBtn, Color3.fromRGB(50,45,80), 1, 0.2)

        local function refreshTraitsBtn()
            local picked = {}
            for t, on in pairs(selTraits) do if on then table.insert(picked, t) end end
            if #picked == 0 then
                traitsBtn.Text = "▼  Traits"
            elseif #picked == 1 then
                traitsBtn.Text = "▼  Traits  •  " .. picked[1]
            else
                traitsBtn.Text = ("▼  Traits  •  %d selected"):format(#picked)
            end
        end

        do
            local open, dd = false, nil
            local shiftedSnapshot = nil  -- { [child] = origYOffset } when expanded
            local origWinH = nil

            local function shrinkBack()
                -- Restore positions of all elements we shifted, and shrink win2 back
                if shiftedSnapshot then
                    for child, origY in pairs(shiftedSnapshot) do
                        if typeof(child) == "Instance" and child.Parent then
                            local p = child.Position
                            child.Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, origY)
                        end
                    end
                    shiftedSnapshot = nil
                end
                if origWinH then
                    win2.Size = UDim2.new(win2.Size.X.Scale, win2.Size.X.Offset, 0, origWinH)
                    origWinH = nil
                end
            end

            traitsBtn.Activated:Connect(function()
                if open and dd then
                    pcall(function() dd:Destroy() end); dd = nil
                    shrinkBack()
                    open = false
                    return
                end
                open = true
                local rowH = 28
                local ddHeight = math.min(#FT_TRAITS, 6) * (rowH + 2) + 8

                -- INLINE EXPANSION: shift all elements positioned below traitsBtn
                -- down by ddHeight, then grow win2 to fit. The dropdown sits in
                -- the gap that opens up, instead of overlaying anything.
                local btnBottomY = traitsBtn.Position.Y.Offset + traitsBtn.Size.Y.Offset
                shiftedSnapshot = {}
                for _, child in ipairs(win2:GetChildren()) do
                    if child:IsA("GuiObject") and child ~= traitsBtn then
                        if child.Position.Y.Offset >= btnBottomY then
                            shiftedSnapshot[child] = child.Position.Y.Offset
                            local p = child.Position
                            child.Position = UDim2.new(p.X.Scale, p.X.Offset,
                                p.Y.Scale, p.Y.Offset + ddHeight + 4)
                        end
                    end
                end
                origWinH = win2.Size.Y.Offset
                win2.Size = UDim2.new(win2.Size.X.Scale, win2.Size.X.Offset, 0, origWinH + ddHeight + 4)

                -- Match traitsBtn's full-width sizing (1.0 scale - 2*pad offset)
                dd = New("Frame", {
                    Size=UDim2.new(traitsBtn.Size.X.Scale, traitsBtn.Size.X.Offset, 0, ddHeight),
                    Position=UDim2.new(traitsBtn.Position.X.Scale, traitsBtn.Position.X.Offset,
                                       0, btnBottomY + 4),
                    BackgroundColor3=Color3.fromRGB(30,28,42),
                    BorderSizePixel=0, ZIndex=60, ClipsDescendants=true, Parent=win2,
                })
                Corner(dd,6); Stroke(dd,Color3.fromRGB(50,45,80),1,0.2)
                local sf = New("ScrollingFrame", {
                    Size=UDim2.new(1,-8,1,-8), Position=UDim2.new(0,4,0,4),
                    BackgroundTransparency=1, BorderSizePixel=0,
                    ScrollBarThickness=3, ScrollBarImageColor3=Color3.fromRGB(150,105,255),
                    CanvasSize=UDim2.new(0,0,0,#FT_TRAITS*(rowH+2)),
                    AutomaticCanvasSize=Enum.AutomaticSize.Y,
                    ZIndex=61, Parent=dd,
                })
                local ul = Instance.new("UIListLayout", sf)
                ul.SortOrder = Enum.SortOrder.LayoutOrder
                ul.Padding = UDim.new(0,2)

                for i, tname in ipairs(FT_TRAITS) do
                    local row = New("TextButton", {
                        Size=UDim2.new(1,0,0,rowH), BackgroundColor3=BG,
                        BorderSizePixel=0, AutoButtonColor=false, Text="",
                        ZIndex=62, LayoutOrder=i, Parent=sf,
                    })
                    Corner(row, 4)
                    -- trait icon (24x24) on the left, matching the brainrots dropdown look
                    local tIcon = TRAIT_ICONS and TRAIT_ICONS[tname]
                    if tIcon and tIcon ~= "" then
                        New("ImageLabel", {
                            Size=UDim2.new(0,22,0,22), Position=UDim2.new(0,8,0.5,-11),
                            BackgroundTransparency=1, Image=tIcon,
                            ScaleType=Enum.ScaleType.Fit, ZIndex=63, Parent=row,
                        })
                    end
                    New("TextLabel", {
                        Size=UDim2.new(1,-44,1,0), Position=UDim2.new(0,36,0,0),
                        BackgroundTransparency=1, Text=tname,
                        TextColor3=Color3.fromRGB(230,230,240),
                        Font=Enum.Font.GothamBold, TextSize=11,
                        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=63, Parent=row,
                    })

                    -- Selected state: solid purple background (matches brainrots tab)
                    local function applyRowState()
                        if tname ~= "None" and selTraits[tname] then
                            row.BackgroundColor3 = Color3.fromRGB(150,105,255)
                        else
                            row.BackgroundColor3 = BG
                        end
                    end
                    applyRowState()
                    row.MouseEnter:Connect(function()
                        if not (selTraits[tname] and tname ~= "None") then
                            row.BackgroundColor3 = Color3.fromRGB(50,45,80)
                        end
                    end)
                    row.MouseLeave:Connect(function() applyRowState() end)
                    row.Activated:Connect(function()
                        if tname == "None" then
                            selTraits = {}
                            refreshTraitsBtn()
                            if dd then pcall(function() dd:Destroy() end); dd = nil end
                            shrinkBack()
                            open = false
                            return
                        end
                        selTraits[tname] = not selTraits[tname] or nil
                        applyRowState()
                        refreshTraitsBtn()
                    end)
                end
            end)
        end
        y = y + 38

        -- ADD button
        local addBtn = New("TextButton", {
            Size=UDim2.new(1,-pad*2,0,28), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(40,160,70), Text="+ ADD",
            TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold,
            TextSize=12, AutoButtonColor=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(addBtn, 5)
        y = y + 34

        local function AddItem(count)
            for _=1,count do
                if #fakeTradeItems < 30 then
                    -- Snapshot selTraits as an array so later edits to the picker
                    -- don't mutate already-queued items.
                    local traitsArr = {}
                    for t, on in pairs(selTraits) do if on then table.insert(traitsArr, t) end end
                    table.insert(fakeTradeItems, {name=selAnimal, mutation=selMut, traits=traitsArr})
                end
            end
            pcall(function() require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated") end)
            pcall(function()
                local ft = LocalPlayer.PlayerGui:FindFirstChild("KV_FakeTrade")
                local liveInner = ft and ft:FindFirstChild("TradeLiveTrade")
                if not liveInner then return end
                -- reset timer
                if _activeFakeStartTimer then pcall(_activeFakeStartTimer) end
                local scroll = liveInner.Other:FindFirstChild("ScrollingFrame")
                local tmpl = scroll and scroll:FindFirstChild("Template")
                if not scroll or not tmpl then return end
                -- get cached data modules from LaunchFakeTrade scope via upvalue
                local animData = pcall(function() return require(game:GetService("ReplicatedStorage").Datas.Animals) end) and require(game:GetService("ReplicatedStorage").Datas.Animals) or {}
                local mutData  = pcall(function() return require(game:GetService("ReplicatedStorage").Datas.Mutations) end) and require(game:GetService("ReplicatedStorage").Datas.Mutations) or {}
                local function fmt(n)
                    local function c(s,x) return s:gsub("%.0+"..x,x):gsub("(%.%d-)0+"..x,"%1"..x) end
                    if n>=1e12 then return c(("%.1fT"):format(n/1e12),"T")
                    elseif n>=1e9 then return c(("%.1fB"):format(n/1e9),"B")
                    elseif n>=1e6 then return c(("%.1fM"):format(n/1e6),"M")
                    elseif n>=1e3 then return c(("%.1fK"):format(n/1e3),"K")
                    else return tostring(math.floor(n)) end
                end
                for i2=(#fakeTradeItems-count+1),#fakeTradeItems do
                    local item = fakeTradeItems[i2]
                    -- also add to theirItems so success spawn works
                    if _liveTheirItems then table.insert(_liveTheirItems, item) end
                    local f2 = tmpl:Clone()
                    f2.Name="FT_"..i2; f2.Visible=true; f2.LayoutOrder=i2
                    local sp2 = f2:FindFirstChild("Spacer")
                    if sp2 then
                        pcall(function() sp2.Title.Text = item.name end)
                        -- set gen/s value (mutation + trait modifiers stack additively
                        -- the same way CalcGeneration computes it on the spawner side)
                        pcall(function()
                            local aData = animData[item.name]
                            if aData then
                                local base = aData.Generation or 0
                                local mult = 1
                                if item.mutation and item.mutation ~= "None" then
                                    local md = mutData[item.mutation]
                                    if md and md.Modifier then mult = mult + md.Modifier end
                                end
                                local sleepy = false
                                if item.traits then
                                    for _, t in ipairs(item.traits) do
                                        if t == "Sleepy" then
                                            sleepy = true
                                        elseif TRAIT_MULTIPLIERS[t] then
                                            mult = mult + TRAIT_MULTIPLIERS[t]
                                        end
                                    end
                                end
                                local val = base * mult
                                if sleepy then val = val * 0.5 end
                                local cashLbl = sp2:FindFirstChild("Cash")
                                if cashLbl then cashLbl.Text = "$"..fmt(val).."/s" end
                            end
                        end)
                        -- viewport animation
                        pcall(function()
                            local sa = GetSharedAnimals()
                            if sa and sa.AttachOnViewportWithOptimizations then
                                sa:AttachOnViewportWithOptimizations(item.name, sp2.ViewportFrame, nil, item.mutation ~= "None" and item.mutation or nil)
                            end
                        end)
                        -- render trait icons on the trade entry, mirroring the
                        -- live-overhead trait row. Reads icons from the baked
                        -- TRAIT_ICONS table first, then falls back to the game's
                        -- Datas.Traits module (for newer traits like John Pork).
                        pcall(function()
                            if not item.traits or #item.traits == 0 then return end
                            local traitsFrame = sp2:FindFirstChild("Traits")
                                or f2:FindFirstChild("Traits", true)
                            if not traitsFrame then return end
                            local tmplT = traitsFrame:FindFirstChild("Template")
                            if not tmplT then return end
                            tmplT.Visible = false
                            local liveTraitData = nil
                            pcall(function() liveTraitData = require(RS.Datas.Traits) end)
                            local shown = 0
                            for _, t in ipairs(item.traits) do
                                if shown >= 4 then break end
                                local icon = TRAIT_ICONS[t]
                                    or (liveTraitData and liveTraitData[t] and liveTraitData[t].Icon)
                                if icon then
                                    local img = tmplT:Clone()
                                    img.Image   = icon
                                    img.Visible = true
                                    img.Parent  = traitsFrame
                                    shown = shown + 1
                                end
                            end
                            traitsFrame.Visible = shown > 0
                        end)
                    end
                    f2.Parent = scroll
                end
                -- update BaseSlots
                local obs2 = liveInner.Other:FindFirstChild("BaseSlots")
                if obs2 then
                    local cur2,mx2 = obs2.Text:match("(%d+)/(%d+)")
                    cur2 = tonumber(cur2) or 10
                    if mx2 then obs2.Text = math.max(0,cur2-count).."/"..mx2 end
                end
            end)
        end
        addBtn.Activated:Connect(function() AddItem(1) end)

        -- separator
        New("Frame", {
            Size=UDim2.new(1,-pad*2,0,1), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(50,45,80), BorderSizePixel=0, Parent=win2,
        })
        y = y + 8

        -- Launch button
        local launchBtn = New("TextButton", {
            Size=UDim2.new(1,-pad*2,0,36), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(150,105,255), Text="LAUNCH",
            TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold,
            TextSize=14, AutoButtonColor=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(launchBtn, 6)
        launchBtn.MouseEnter:Connect(function() launchBtn.BackgroundColor3=Color3.fromRGB(128,112,251) end)
        launchBtn.MouseLeave:Connect(function() launchBtn.BackgroundColor3=Color3.fromRGB(150,105,255) end)
        y = y + 44

        -- Trade Notification button (mirrors the Trade Notif Key hotkey)
        local notifBtn = New("TextButton", {
            Size=UDim2.new(1,-pad*2,0,32), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(70,140,210), Text="Trade Notification",
            TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold,
            TextSize=12, AutoButtonColor=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(notifBtn, 6)
        notifBtn.MouseEnter:Connect(function() notifBtn.BackgroundColor3=Color3.fromRGB(90,160,230) end)
        notifBtn.MouseLeave:Connect(function() notifBtn.BackgroundColor3=Color3.fromRGB(70,140,210) end)
        notifBtn.Activated:Connect(function()
            local typed = (usernameBox and usernameBox.Text) or ""
            if _triggerTradeNotif then
                pcall(_triggerTradeNotif, typed)
            else
                SetStatus("Trade notif system loading — try again in a moment", Color3.fromRGB(255,150,50), 2)
            end
        end)
        y = y + 38


        -- Force Accept: snaps every fake-trade timer to 0 next tick so the
        -- partner ready/confirms immediately. Same sequence — just skips the
        -- waiting. Only does anything while a fake trade is actually open.
        local forceBtn = New("TextButton", {
            Size=UDim2.new(1,-pad*2,0,32), Position=UDim2.new(0,pad,0,y),
            BackgroundColor3=Color3.fromRGB(40,160,70), Text="Force Accept",
            TextColor3=Color3.fromRGB(255,255,255), Font=Enum.Font.GothamBold,
            TextSize=12, AutoButtonColor=false, BorderSizePixel=0, Parent=win2,
        })
        Corner(forceBtn, 6)
        forceBtn.MouseEnter:Connect(function() forceBtn.BackgroundColor3=Color3.fromRGB(60,180,90) end)
        forceBtn.MouseLeave:Connect(function() forceBtn.BackgroundColor3=Color3.fromRGB(40,160,70) end)
        forceBtn.Activated:Connect(function()
            local active = LocalPlayer.PlayerGui:FindFirstChild("KV_FakeTrade")
            if not active then
                SetStatus("No active fake trade to force-accept", Color3.fromRGB(255,150,50), 2)
                return
            end
            if not _kvForceAcceptDispatcher then
                SetStatus("Trade still loading — try again in 1s", Color3.fromRGB(255,150,50), 2)
                return
            end
            _kvForceAcceptDispatcher()  -- snaps partner's Ready! frame on
            forceBtn.Text = "Partner Ready"
            task.delay(2, function()
                if forceBtn and forceBtn.Parent then forceBtn.Text = "Force Accept" end
            end)
        end)
        y = y + 40

        -- resize to fit
        win2.Size = UDim2.new(1,0,0,y+6)

        local launching = false
        launchBtn.Activated:Connect(function()
            if launching then return end
            local cooldown = 0  -- no cooldown
            local elapsed = tick() - _lastFakeTradeTime
            if elapsed < cooldown then
                local remaining = math.ceil(cooldown - elapsed)
                SetStatus("Wait "..remaining.."s before next fake trade", Color3.fromRGB(255,150,50), 3)
                return
            end
            launching = true
            local username = usernameBox.Text ~= "" and usernameBox.Text or "Player"
            local items = {}
            for _,v in ipairs(fakeTradeItems) do table.insert(items,v) end
            launchBtn.Text = "3..."
            task.spawn(function()
                task.wait(1); launchBtn.Text="2..."
                task.wait(1); launchBtn.Text="1..."
                task.wait(1); launchBtn.Text="LAUNCH"; launching=false
                fakeTradeItems = {}  -- clear queue so next trade starts fresh
                LaunchFakeTrade(username, items)
            end)
        end)

        -- ── DEBUG: register dupe-key and launch-key callbacks ─────────────────
        -- Both closures are now safe to create because launchBtn is in scope.
        -- Cleared on AncestryChanged so they can never fire after window closes.
        _triggerDupeItem = function() AddItem(1) end
        _triggerLaunch   = function() launchBtn:Activate() end
        win2.AncestryChanged:Connect(function()
            if not win2.Parent then
                _triggerDupeItem = nil
                _triggerLaunch   = nil
            end
        end)
    end

    -- Auto-instantiate the inline trade setup form inside the Trading tab.
    pcall(OpenFakeTradeSetup)
end -- end trading page do block

-- If "Hide UI on Rejoin" is on, start with the menu hidden — user must press
-- the toggle key to show it. Apply IMMEDIATELY plus several deferred passes
-- in case other init code re-enables sg before settling.
if hideOnRejoinEnabled then
    pcall(function() sg.Enabled = false end)
    task.defer(function() pcall(function() sg.Enabled = false end) end)
    task.delay(0.05, function() pcall(function() sg.Enabled = false end) end)
    task.delay(0.25, function() pcall(function() sg.Enabled = false end) end)
    task.delay(1.0,  function() pcall(function() sg.Enabled = false end) end)
end

-- Configurable key toggles entire UI (default LeftShift, set in Misc tab)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode and input.KeyCode.Name == toggleKeyName then
        sg.Enabled = not sg.Enabled
    end
end)

-- Configurable rejoin key (Misc tab). When pressed, teleports back to the
-- same place — Roblox routes to a fresh server via TeleportService.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if rejoinKeyName == "" then return end
    if input.KeyCode and input.KeyCode.Name == rejoinKeyName then
        pcall(function()
            local TeleportService = game:GetService("TeleportService")
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
end)

-- ── DEBUG: Dupe Item Key ──────────────────────────────────
-- Spawns a visual clone of EVERY animal confirmed received in the most recent
-- real trade. Works for single-item AND multi-item trades. Set from the post-
-- trade server diff so it's always the exact animals the server gave you.
local function _doDupeReceived()
    -- Prefer the multi-item array; fall back to the single-item ref for safety.
    local items = (_lastReceivedItems and #_lastReceivedItems > 0) and _lastReceivedItems or nil
    if (not items) and _lastReceivedItem then items = { _lastReceivedItem } end
    if not items or #items == 0 then
        SetStatus("No received animals yet — complete a real trade first!", Color3.fromRGB(255,150,50), 3)
        return
    end
    for _, item in ipairs(items) do
        pcall(function() SpawnOneAnimal(item.name, item.mutation or "None", item.traits or {}) end)
    end
    pcall(DrainPendingSpawns)
    if #items == 1 then
        local it = items[1]
        SetStatus("Duped: "..it.name..(it.mutation ~= "None" and " ("..it.mutation..")" or ""),
            Color3.fromRGB(40,200,80), 2)
    else
        SetStatus(("Duped %d items from last trade"):format(#items), Color3.fromRGB(40,200,80), 2)
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if _debugDupeKeyName == "" then return end
    if not (input.KeyCode and input.KeyCode.Name == _debugDupeKeyName) then return end
    _doDupeReceived()
end)

-- ── DEBUG: Auto-Fill Trade Key ────────────────────────────
-- Directly launches the visual fake trade UI with the last real-trade partner.
-- Skips the Trade Setup window entirely — no animals added to their side.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if _debugAutoFillKeyName == "" then return end
    if not (input.KeyCode and input.KeyCode.Name == _debugAutoFillKeyName) then return end
    if LocalPlayer.PlayerGui:FindFirstChild("KV_FakeTrade") then
        SetStatus("A fake trade is already open!", Color3.fromRGB(255,100,50), 2)
        return
    end
    if _lastRealTradeCapture then
        LaunchFakeTrade(_lastRealTradeCapture.username, {})
    else
        SetStatus("No real trade captured yet — start a real trade first!", Color3.fromRGB(255,150,50), 3)
    end
end)

-- ── DEBUG: Trade Notif Trigger ────────────────────────────
-- Clones the real game's TradePrompts.Prompt frame from PlayerGui and adds it
-- via CornerNotificationController — identical to the real game's trade invite.
-- Yes button launches LaunchFakeTrade. No button dismisses. No remotes fired.
local _fakeNotifOpen = false
_triggerTradeNotif = function(overrideUsername)
    if _fakeNotifOpen then return end
    if LocalPlayer.PlayerGui:FindFirstChild("KV_FakeTrade") then
        SetStatus("A fake trade is already open!", Color3.fromRGB(255,100,50), 2)
        return
    end
    -- Resolve a username: explicit arg > trade-setup form's username box > captured trade
    local username = overrideUsername
    if not username or username == "" then
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local box = pg and pg:FindFirstChild("__usernameBox", true)
        if box and box.Text and box.Text ~= "" then
            username = box.Text
        end
    end
    if (not username or username == "") and _lastRealTradeCapture then
        username = _lastRealTradeCapture.username
    end
    if not username or username == "" then
        SetStatus("Enter a target username first (Trading tab) or complete a real trade!", Color3.fromRGB(255,150,50), 4)
        return
    end
    _fakeNotifOpen = true

    local function closeNotif(remove)
        _fakeNotifOpen = false
        if remove then pcall(remove) end
    end

    pcall(function()
        local pg = LocalPlayer.PlayerGui
        local promptTemplate = pg:WaitForChild("TradePrompts", 5)
        if not promptTemplate then error("no TradePrompts") end
        local frame = promptTemplate.Prompt:Clone()
        frame.Username.Text = ("@%s wants to trade with you"):format(username)
        frame.Visible = true

        local nc = require(RS.Controllers.CornerNotificationController)
        local removeFn = nc:Add(frame)

        frame.Yes.Activated:Connect(function()
            closeNotif(removeFn)
            LaunchFakeTrade(username, {})
        end)
        frame.No.Activated:Connect(function()
            closeNotif(removeFn)
        end)

        task.delay(15, function()
            if _fakeNotifOpen then closeNotif(removeFn) end
        end)
    end)
end
-- Expose globally so the Trading-tab button can call it
_G.KV_TriggerTradeNotif = _triggerTradeNotif

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if _debugTradeNotifKeyName == "" then return end
    if not (input.KeyCode and input.KeyCode.Name == _debugTradeNotifKeyName) then return end
    _triggerTradeNotif()
end)



-- ══════════════════════════════════════════════════════════
-- ── MakeTradeSlot  (mirrors v_u_279 in TradeController)
-- ══════════════════════════════════════════════════════════
-- ══════════════════════════════════════════════════════════
-- ── TRADE SLOT INJECTION  
-- Injects our fake animals into the real TradeLiveTrade GUI.
-- Named KV_N so they don't conflict with real Selection_N slots.
-- Re-injected on every TradeData change so the real game's
-- onPlayersChanged can't wipe them.
-- ══════════════════════════════════════════════════════════

local offeredSlots       = {}
local pendingSell        = {}
local tradeSlotCooldown  = false

local function GetTradeScroll()
    local pg  = LocalPlayer.PlayerGui
    local tlt = pg:FindFirstChild("TradeLiveTrade")
    tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
    return tlt and tlt.Your and tlt.Your:FindFirstChild("ScrollingFrame")
end

-- sell models in a table
local function DoSell(tbl)
    for model in pairs(tbl) do
        pcall(function()
            if not (model and model.Parent) then return end
            for i, m in ipairs(spawnedModels) do
                if m == model then table.remove(spawnedModels, i); break end
            end
            local oh = modelOverheads[model]
            if oh then
                pcall(function() if oh.part then oh.part:Destroy() end end)
                pcall(function() if oh.att  then oh.att:Destroy()  end end)
                modelOverheads[model] = nil
            end
            local cp = modelCashpads[model]
            if cp then
                pcall(function() if cp.conn then cp.conn:Disconnect() end end)
                pcall(function() if cp.part then cp.part:Destroy()    end end)
                modelCashpads[model] = nil
            end
            modelSnapshots[model] = nil
            modelPromptInfo[model] = nil
            model:Destroy()
        end)
    end
    UpdateCount()
    ScheduleSave()
end

-- inject fake slots — just clone the template for each spawned model
-- fake timer overlay — covers real timer with our own countdown
local fakeTimerConn = nil
local fakeTimerLbl  = nil

local function ResetFakeTimer()
    -- stop any existing countdown
    if fakeTimerConn then pcall(function() fakeTimerConn:Disconnect() end); fakeTimerConn = nil end

    -- get or create our fake timer label on top of real one
    local pg  = LocalPlayer.PlayerGui
    local tlt = pg:FindFirstChild("TradeLiveTrade")
    tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
    if not tlt then return end

    local realTimer = tlt.Other:FindFirstChild("Timer")
    if not realTimer then return end

    -- create fake label as sibling covering real one
    if not (fakeTimerLbl and fakeTimerLbl.Parent) then
        fakeTimerLbl = realTimer:Clone()
        fakeTimerLbl.Name = "KV_FakeTimer"
        fakeTimerLbl.ZIndex = (realTimer.ZIndex or 1) + 2
        fakeTimerLbl.Parent = realTimer.Parent
    end

    -- hide real timer, show ours
    realTimer.Visible = false
    fakeTimerLbl.Visible = true

    local t = 5.0
    fakeTimerLbl.Text = "⏰5.0s Left"

    fakeTimerConn = RunService.Heartbeat:Connect(function(dt)
        if not LocalPlayer:GetAttribute("IsTrading") then
            -- trade ended, clean up
            if fakeTimerLbl then fakeTimerLbl.Visible = false end
            realTimer.Visible = true
            fakeTimerConn:Disconnect(); fakeTimerConn = nil
            return
        end
        t = math.max(0, t - dt)
        fakeTimerLbl.Text = ("⏰%.1fs Left"):format(t)
        if t <= 0 then
            fakeTimerLbl.Visible = false
            realTimer.Visible = true
            fakeTimerConn:Disconnect(); fakeTimerConn = nil
        end
    end)
end

local function CleanFakeTimer()
    if fakeTimerConn then pcall(function() fakeTimerConn:Disconnect() end); fakeTimerConn = nil end
    if fakeTimerLbl then
        pcall(function()
            local pg  = LocalPlayer.PlayerGui
            local tlt = pg:FindFirstChild("TradeLiveTrade")
            tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
            local real = tlt and tlt.Other:FindFirstChild("Timer")
            if real then real.Visible = true end
            fakeTimerLbl:Destroy()
        end)
        fakeTimerLbl = nil
    end
end

-- store real slot counts captured before we patch them
local realYourCur  = 0
local realYourMax  = 25
local realOtherCur = 0
local realOtherMax = 15
local slotCountsCaptured = false

local function CaptureRealCounts()
    pcall(function()
        local pg  = LocalPlayer.PlayerGui
        local tlt = pg:FindFirstChild("TradeLiveTrade")
        tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
        if not tlt then return end
        local yourBS  = tlt.Your:FindFirstChild("BaseSlots")
        local otherBS = tlt.Other:FindFirstChild("BaseSlots")
        if yourBS then
            local c, m = yourBS.Text:match("(%d+)/(%d+)")
            if c and m then
                realYourCur  = tonumber(c) or 0
                realYourMax  = tonumber(m) or 25
                slotCountsCaptured = true
            end
        end
        if otherBS then
            local c, m = otherBS.Text:match("(%d+)/(%d+)")
            if c and m then
                realOtherCur = tonumber(c) or 0
                realOtherMax = tonumber(m) or 15
            end
        end
    end)
end

local function UpdateTradeCounts()
    if not slotCountsCaptured then CaptureRealCounts() end
    pcall(function()
        local pg  = LocalPlayer.PlayerGui
        local tlt = pg:FindFirstChild("TradeLiveTrade")
        tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
        if not tlt then return end
        local yourBS  = tlt.Your:FindFirstChild("BaseSlots")
        local otherBS = tlt.Other:FindFirstChild("BaseSlots")
        -- count fakes
        local fakeInTrade = 0
        local totalFake   = #spawnedModels
        for mdl in pairs(offeredSlots) do
            if mdl and mdl.Parent then fakeInTrade = fakeInTrade + 1 end
        end
        local fakeInBase = totalFake - fakeInTrade
        -- Your side: numerator = real + fakeInBase (fakes in base count as yours)
        -- putting 1 in trade: fakeInBase goes down by 1, numerator drops
        if yourBS then
            yourBS.Text = ("%d/%d"):format(realYourCur + fakeInBase, realYourMax)
        end
        -- Other side: numerator goes up when we add fake to trade
        if otherBS then
            otherBS.Text = ("%d/%d"):format(realOtherCur + fakeInTrade, realOtherMax)
        end
    end)
end

local function InjectTradeSlots()
    local scroll = GetTradeScroll()
    if not scroll then return end
    local template = scroll:FindFirstChild("Template")
    if not template then return end

    -- remove old KV slots
    for _, v in scroll:GetChildren() do
        if v.Name:sub(1,3) == "KV_" then v:Destroy() end
    end

    for i, mdl in ipairs(spawnedModels) do
        if not (mdl and mdl.Parent) then continue end
        local snap = modelSnapshots[mdl] or {mutation="None", traits={}}
        local animalName = mdl.Name

        local frame = template:Clone()
        frame.Name = "KV_"..i
        frame.Visible = true
        frame.LayoutOrder = i + 1000
        frame:SetAttribute("ModelId", tostring(mdl))

        local spacer = frame:FindFirstChild("Spacer")
        if spacer then
            local titleLbl = spacer:FindFirstChild("Title")
            local cashLbl  = spacer:FindFirstChild("Cash")
            if titleLbl then titleLbl.Text = animalName end -- trade list: never appends "is Calling..."

            local function fmt(n)
                local function c(s,x) return s:gsub("%.0+"..x,x):gsub("(%.%d-)0+"..x,"%1"..x) end
                if n>=1e12 then return c(("%.1fT"):format(n/1e12),"T")
                elseif n>=1e9 then return c(("%.1fB"):format(n/1e9),"B")
                elseif n>=1e6 then return c(("%.1fM"):format(n/1e6),"M")
                elseif n>=1e3 then return c(("%.1fK"):format(n/1e3),"K")
                else return tostring(math.floor(n)) end
            end
            local MUT={Gold=0.25,Diamond=0.5,Bloodrot=1,Rainbow=9,Candy=3,Lava=5,Galaxy=6,YinYang=6.5,Radioactive=7.5,Cursed=8,Divine=9,Cyber=10}
            local TRAIT_MOD={Taco=2,Nyan=5,Galactic=3,Fireworks=5,Zombie=4,Claws=4,Glitched=4,Bubblegum=3,Fire=5,Wet=1.5,Snowy=2,Cometstruck=2.5,Explosive=3,Disco=4,["10B"]=3,["Shark Fin"]=3,["Matteo Hat"]=3.5,Brazil=5,Sleepy=0,Lightning=5,UFO=2,Spider=3.5,Strawberry=8,Paint=5,Skeleton=3,Sombrero=4,Tie=3.75,["Witch Hat"]=3,Indonesia=4,Meowl=7,["John Pork"]=6.5,["RIP Gravestone"]=3.5,["Jackolantern Pet"]=4.5,["Santa Hat"]=4,["Reindeer Pet"]=5,Skibidi=6,["26"]=5,Rose=5,[":3"]=4.5,Chocolate=4.5,Halo=5,Lucky=5,["Orange Balloon"]=3,["Green Balloon"]=3.5,["Blue Balloon"]=4,["Red Balloon"]=5,["Pink Balloon"]=5.5,["Rainbow Balloon"]=6.5,Granny=5.5,["Bunny Ears"]=4.5,["Orange Egg"]=3,["Green Egg"]=4,["Blue Egg"]=5,["Pink Egg"]=6.5}
            local baseGen  = ANIMAL_DATA[animalName] and ANIMAL_DATA[animalName].gen or 0
            local mutMod   = MUT[snap.mutation] or 0
            local traitMod = 0
            for _, t in ipairs(snap.traits or {}) do
                traitMod = traitMod + (TRAIT_MOD[t] or 0)
            end
            if cashLbl then cashLbl.Text = ("$%s/s"):format(fmt(baseGen*(1+mutMod+traitMod))) end

            -- show trait icons (matching real TradeController exactly)
            local tf = spacer:FindFirstChild("Traits")
            if tf then
                local iconTemplate = tf:FindFirstChild("Template")
                if iconTemplate then
                    -- remove template from layout so it doesn't affect positioning
                    iconTemplate.Visible = false
                    -- clear any previously added icons
                    for _, child in tf:GetChildren() do
                        if child ~= iconTemplate and child.ClassName ~= "UIListLayout" then
                            child:Destroy()
                        end
                    end
                    local count = 0
                    for _, t in ipairs(snap.traits or {}) do
                        do
                            local icon = TRAIT_ICONS[t]
                            if icon then
                                local img = iconTemplate:Clone()
                                img.Name = t
                                img.Image = icon
                                img.Visible = true
                                img.Parent = tf
                                count = count + 1
                            end
                        end
                    end
                    tf.Visible = count > 0
                end
            end

            -- viewport
            local vp = spacer:FindFirstChild("ViewportFrame")
            if vp then
                pcall(function()
                    local cam = Instance.new("Camera"); vp.CurrentCamera=cam; cam.Parent=vp
                    local wm  = Instance.new("WorldModel", vp)
                    local tmpl2 = RS.Models.Animals:FindFirstChild(animalName)
                    if not tmpl2 then return end
                    local m = tmpl2:Clone()
                    pcall(ApplyMutation, m, animalName, snap.mutation)
                    for _, v2 in m:GetDescendants() do
                        if v2:IsA("BasePart") then
                            v2.CanCollide=false; v2.CanQuery=false
                            v2.CanTouch=false; v2.Anchored=true; v2.CastShadow=false
                        end
                    end
                    m:PivotTo(CFrame.new(0,0,0)); m.Parent=wm
                    local minY,maxY2,maxX,maxZ = math.huge,-math.huge,0,0
                    for _, p in m:GetDescendants() do
                        if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                            local sz=p.Size; local py=p.Position.Y
                            minY=math.min(minY,py-sz.Y*0.5); maxY2=math.max(maxY2,py+sz.Y*0.5)
                            maxX=math.max(maxX,sz.X); maxZ=math.max(maxZ,sz.Z)
                        end
                    end
                    if minY==math.huge then minY=0; maxY2=2; maxX=2; maxZ=2 end
                    local maxDim = math.max(maxX, maxY2-minY, maxZ)
                    -- exact formula verified from real game console output
                    -- FOV=50, zoom=0.75, pad=0.5, lookAt=PrimaryPart
                    cam.FieldOfView = 50
                    local DIR    = Vector3.new(-1, 0.25, -1).Unit
                    local dist   = (maxDim*0.5 / math.tan(math.rad(25))) * 0.75
                    local lookAt = m.PrimaryPart and m.PrimaryPart.CFrame
                        or CFrame.new(0, (maxY2+minY)*0.5, 0)
                    cam.CFrame = CFrame.new(
                        (lookAt * CFrame.new(DIR * (dist + maxDim * 0.5))).Position,
                        lookAt.Position)
                    local af = RS.Animations.Animals:FindFirstChild(animalName)
                    local ia = af and af:FindFirstChild("Idle")
                    if ia then
                        local ac = m:FindFirstChildOfClass("AnimationController") or m:FindFirstChildWhichIsA("AnimationController",true)
                        if ac then
                            local anim = ac:FindFirstChildOfClass("Animator") or Instance.new("Animator",ac)
                            pcall(function() local tr=anim:LoadAnimation(ia); tr.Looped=true; tr:Play() end)
                        end
                    end
                end)
            end

            -- click to offer/remove
            local isOffered = false
            local sk = spacer:FindFirstChild("UIStroke")
            local function setOff(v)
                isOffered = v
                spacer.BackgroundColor3 = v and Color3.fromRGB(15,50,15) or Color3.fromRGB(35,45,50)
                if sk then sk.Color = v and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,0,0) end
                -- don't hide other slots during selection — only hidden at confirm stage
            end

            spacer.Activated:Connect(function()
                -- global cooldown: 0.5-1s between any add/remove
                if tradeSlotCooldown then
                    local action = isOffered and "remove" or "add"
                    SetStatus("Failed to "..action.." brainrot", Color3.fromRGB(255,80,80), 1.5)
                    return
                end
                tradeSlotCooldown = true
                task.delay(math.random(50,100)/100, function() tradeSlotCooldown = false end)

                local was = isOffered
                if was then
                    setOff(false); offeredSlots[mdl]=nil
                else
                    setOff(true);  offeredSlots[mdl]=true
                end
                pendingSell = {}
                for m2,v2 in pairs(offeredSlots) do pendingSell[m2]=v2 end
                -- update slot counts in trade GUI
                task.defer(UpdateTradeCounts)
                -- play add/remove SFX same as real game
                pcall(function()
                    require(RS.Controllers.SoundController):PlaySound("Sounds.Sfx.Activated")
                end)
                -- trigger our fake timer overlay
                ResetFakeTimer()
            end)
        end

        frame.Parent = scroll
    end
end

local function OnBothReady()
    -- hide unselected KV slots, strip green from selected ones
    local scroll = GetTradeScroll()
    if not scroll then return end
    for _, v in scroll:GetChildren() do
        if v.Name:sub(1,3) == "KV_" then
            local isOffered = offeredSlots[v:GetAttribute("ModelId") and
                (function()
                    for m in pairs(offeredSlots) do
                        if tostring(m) == v:GetAttribute("ModelId") then return m end
                    end
                end)()] ~= nil
            if isOffered then
                -- keep visible but strip green
                v.Visible = true
                local sp = v:FindFirstChild("Spacer")
                if sp then
                    sp.BackgroundColor3 = Color3.fromRGB(35,45,50)
                    local sk = sp:FindFirstChild("UIStroke")
                    if sk then sk.Color = Color3.fromRGB(0,0,0) end
                end
            else
                -- hide unselected
                v.Visible = false
            end
        end
    end
    -- snapshot for sell
    pendingSell = {}
    for m, v in pairs(offeredSlots) do pendingSell[m] = v end
end

-- open: inject once on IsTrading becoming true
-- Fix sibling prompt hiding during hold:
-- Temporarily set sibling State to something other than Grab/Sell
-- so the real game's renderer doesn't block it during v_u_118=true
local PPS2 = game:GetService("ProximityPromptService")
-- Helper: re-render every Grab/Sell prompt on the player's plot except the
-- one passed in. The game's renderer hides ALL nearby Grab/Sell prompts
-- during a hold (not just same-attachment siblings), so we walk the plot's
-- whole AnimalPodiums folder — covering both real (server-spawned) and
-- fake (our-spawner) brainrots, since modelPromptInfo only tracks fakes.
-- While the user is holding a Grab/Sell on one brainrot, every OTHER
-- brainrot's Grab/Sell prompts should hide entirely (otherwise you hold
-- Skibidi's Grab and Tralalita's "Sell: $10M" still shows up beside it,
-- looking like the wrong brainrot's option).
--
-- A one-shot disable on hold-begin doesn't stick — the game's prompt
-- service keeps re-evaluating distance/visibility every frame and re-
-- enables anything within range.  So we run a tight polling loop for the
-- duration of the hold that keeps non-held prompts forced off, and on
-- release restore exactly the ones we touched (game proximity logic takes
-- back over for natural visibility).
local _kvHoldActive   = false   -- true between PromptButtonHoldBegan/Ended
local _kvHoldedAtt    = nil     -- the PromptAttachment of the held prompt
local _kvHoldTouched  = {}      -- set<ProximityPrompt> of prompts we disabled

local function _disableNonHeldPrompts()
    if not _kvHoldedAtt then return end
    local plot = GetPlayerPlot()
    if not plot then return end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return end
    for _, pod in pods:GetChildren() do
        local base = pod:FindFirstChild("Base")
        local sp   = base and base:FindFirstChild("Spawn")
        local att  = sp and sp:FindFirstChild("PromptAttachment")
        if att and att ~= _kvHoldedAtt then
            for _, p in att:GetChildren() do
                if p:IsA("ProximityPrompt") then
                    local st = p:GetAttribute("State")
                    if (st == "Grab" or st == "Sell") and p.Enabled then
                        p.Enabled = false
                        _kvHoldTouched[p] = true
                    end
                end
            end
        end
    end
end

local function _restoreHoldTouched()
    for p in pairs(_kvHoldTouched) do
        if p and p.Parent then
            p.Enabled = true
        end
        _kvHoldTouched[p] = nil
    end
end

PPS2.PromptButtonHoldBegan:Connect(function(prompt)
    local state = prompt:GetAttribute("State")
    if state ~= "Grab" and state ~= "Sell" then return end
    _kvHoldedAtt  = prompt.Parent
    _kvHoldActive = true
    -- Tight loop: re-disable non-held prompts every ~50ms so the game's
    -- prompt service can't sneak them back in mid-hold.  Exits when
    -- _kvHoldActive flips false on PromptButtonHoldEnded.
    task.spawn(function()
        while _kvHoldActive do
            _disableNonHeldPrompts()
            task.wait(0.05)
        end
    end)
end)

-- Re-enable every Grab/Sell prompt on the *same* attachment as the held one
-- (the sibling).  Necessary because the game disables siblings on hold-begin
-- and keeps them in an internal "hidden" renderer state past partial-hold
-- release — Enabled=true alone doesn't bring them back.
--
-- Reparent forces the prompt service to rebuild the billboard from scratch,
-- which always makes the sibling reappear.  No visible spazz here because
-- the sibling is already invisible at this point — there's nothing on
-- screen to flicker.
local function _restoreSiblingsOf(att)
    if not att or not att.Parent then return end
    for _, p in att:GetChildren() do
        if p:IsA("ProximityPrompt") then
            local st = p:GetAttribute("State")
            if st == "Grab" or st == "Sell" then
                p.Enabled = true  -- defensive: in case it was actually disabled
                local origParent = p.Parent
                p.Parent = nil
                p.Parent = origParent
            end
        end
    end
end

PPS2.PromptButtonHoldEnded:Connect(function(prompt)
    _kvHoldActive = false
    local heldAtt = _kvHoldedAtt
    _kvHoldedAtt  = nil

    -- Tiny settle, then restore both:
    -- 1. Prompts we disabled on other brainrots (the polling loop's set)
    -- 2. The sibling prompt on the SAME brainrot (game disabled it; partial
    --    hold doesn't re-show it on its own).
    task.delay(0.03, function()
        _restoreHoldTouched()
        _restoreSiblingsOf(heldAtt)
    end)
    task.delay(0.4, function()
        _restoreHoldTouched()
        _restoreSiblingsOf(heldAtt)
    end)
end)

-- ── COMMUNITY WEBHOOK ────────────────────────────────────
-- snapshots the player's real (server-side) brainrots, diffs across a trade,
-- and posts any newly-received gen-50M+ items to the shared Discord feed
-- (only when the user has opted in via the Misc tab toggle).
-- delivery uses Luarmor's LRM_SEND_WEBHOOK macro so the URL & template are
-- protected; %DISCORD_ID% resolves server-side to the executing user.
local RARITY_COLOR_HEX = {
    Common=0x9aa1ad, Rare=0x4aa3ff, Epic=0xa45dff,
    Legendary=0xffb347, Mythic=0xff5c5c,
    ["Brainrot God"]=0xfff35c, Secret=0xff2bd6, OG=0x00ffd0,
}

-- per-brainrot dollar value (USD-ish, from community pricing).
-- only entries listed here will show a Value field in the embed.
local BRAINROT_VALUES = {
    ["Elefanto Frigo"]            = 625,
    ["Strawberry Elephant"]       = 470,
    ["John Pork"]                 = 450,
    ["Meowl"]                     = 235,
    ["Antonio"]                   = 235,
    ["Skibidi Toilet"]            = 150,
    ["Griffin"]                   = 105,
    ["Dragon Gingerini"]          = 95,
    ["Ginger Gerat"]              = 90,
    ["La Supreme Combinasion"]    = 70,
    ["Hydra Dragon Cannelloni"]   = 26,
    ["Dragon Cannelloni"]         = 23,
    ["Ketupat Bros"]              = 17,
    ["La Casa Boo"]               = 13,
    ["Foxini Lanternini"]         = 10,
    ["Rosey and Teddy"]           = 9,
    ["Cerberus"]                  = 7,
    ["Reinito Sleighito"]         = 5,
    ["Los Amigos"]                = 5,
    ["Cooki and Milki"]           = 5,
    ["Spooky and Pumpky"]         = 5,
    ["Fragrama and Chocrama"]     = 5,
    ["Fortunu and Cashuru"]       = 4,
    ["Capitano Moby"]             = 3.5,
    ["La Food Combinasion"]       = 3.5,
    ["Celestial Pegasus"]         = 2.5,
    ["Popcuru and Fizzuru"]       = 2.5,
    ["Burguro And Fryuro"]        = 2,
    ["Garama and Madundung"]      = 1.5,
    ["La Secret Combinasion"]     = 0.75,
}

local function _snapshotRealAnimals()
    -- multiset keyed by name|mutation|sorted-traits, value = count
    local snap = {}
    pcall(function()
        local ch = GetSyncChannel()
        local pods = ch and ch:Get("AnimalPodiums") or {}
        for _, v in pairs(pods) do
            if type(v) == "table" and v.Index then
                local traits = {}
                if type(v.Traits) == "table" then
                    for _, t in ipairs(v.Traits) do table.insert(traits, t) end
                end
                table.sort(traits)
                local key = v.Index.."|"..(v.Mutation or "None").."|"..table.concat(traits, ",")
                snap[key] = (snap[key] or 0) + 1
            end
        end
    end)
    return snap
end

local function _diffNewEntries(pre, post)
    -- returns array of {name, mutation, traits[]} for items in post but not pre
    local out = {}
    for key, count in pairs(post) do
        local was = pre[key] or 0
        local newOnes = count - was
        if newOnes > 0 then
            local name, mut, traitsStr = key:match("^(.-)|(.-)|(.*)$")
            local traits = {}
            if traitsStr and traitsStr ~= "" then
                for t in traitsStr:gmatch("[^,]+") do table.insert(traits, t) end
            end
            for _ = 1, newOnes do
                table.insert(out, {name=name, mutation=mut, traits=traits})
            end
        end
    end
    return out
end

local function _fmtCompact(n)
    local function clean(s, suf)
        return (s:gsub("%.0+"..suf, suf):gsub("(%.%d-)0+"..suf, "%1"..suf))
    end
    if n >= 1e12 then return clean(string.format("%.1fT", n/1e12), "T")
    elseif n >= 1e9 then return clean(string.format("%.1fB", n/1e9), "B")
    elseif n >= 1e6 then return clean(string.format("%.1fM", n/1e6), "M")
    elseif n >= 1e3 then return clean(string.format("%.1fK", n/1e3), "K")
    else return tostring(math.floor(n)) end
end

local function _findRarityFor(name)
    for _, group in ipairs(ANIMALS_BY_RARITY) do
        for _, n in ipairs(group.names) do
            if n == name then return group.rarity end
        end
    end
    return nil
end

-- ── Live Licks: Fandom wiki image fetch ───────────────────
-- Pulls the brainrot's image from https://stealabrainrot.fandom.com so
-- the community-feed embed shows the actual brainrot, not the player's
-- avatar. Runs HTTP GETs against the public wiki — no auth, no API key.
local _LL_FANDOM_BASE = "https://stealabrainrot.fandom.com/wiki/"
local _LL_imgCache = {}  -- name -> url (or false if no image found)

local function _llRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

local function _llUrlEncode(s)
    return (s:gsub("[^%w%-_%.~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function _llWikiCandidates(displayName)
    -- Different brainrot pages use slightly different URL slugs (some use
    -- underscores, some use URL-encoded spaces).  Try a few until one hits.
    local clean = displayName:match("^(.-)%s*%(") or displayName
    local seen, list = {}, {}
    local function add(s)
        if s and s ~= "" and not seen[s] then
            seen[s] = true; table.insert(list, s)
        end
    end
    add((clean:gsub(" ", "_")))
    add(_llUrlEncode(clean))
    add((displayName:gsub(" ", "_")))
    add(_llUrlEncode(displayName))
    return list
end

local function _llFetchBody(requestFn, url)
    -- One URL, up to 3 attempts on transient failures.  4xx/5xx hard-fails
    -- so the candidate loop can move on to the next slug.
    for attempt = 1, 3 do
        local ok, response = pcall(function()
            return requestFn({
                Url = url, Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                    ["Accept"]     = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                    ["Accept-Language"] = "en-US,en;q=0.5",
                    ["Cache-Control"]   = "no-cache",
                },
                Timeout = 10,
            })
        end)
        if ok and response and response.StatusCode == 200 and response.Body and response.Body ~= "" then
            return response.Body
        end
        if ok and response and response.StatusCode and response.StatusCode ~= 200 then
            return nil
        end
        if attempt < 3 then task.wait(0.5 * attempt) end
    end
    return nil
end

_llFetchFandomImage = function(displayName)
    if _LL_imgCache[displayName] ~= nil then
        return _LL_imgCache[displayName] or nil
    end
    local requestFn = _llRequestFn()
    if not requestFn then return nil end
    for _, slug in ipairs(_llWikiCandidates(displayName)) do
        local body = _llFetchBody(requestFn, _LL_FANDOM_BASE .. slug)
        if body then
            -- og:image is always present on Fandom pages
            local og = body:match('property="og:image"%s+content="([^"]+)"')
                or body:match('content="([^"]+)"%s+property="og:image"')
                or body:match('<meta%s+property="og:image"%s+content="([^"]+)"')
            if og and og ~= "" then
                og = og:gsub("&amp;", "&"):gsub("&quot;", '"')
                if og:find("^https?://") then
                    _LL_imgCache[displayName] = og
                    return og
                end
            end
            -- secondary: scan for wikia.nocookie images and pick the largest
            for _, attr in ipairs({"data%-src", "src"}) do
                local last
                for _, ext in ipairs({"png", "jpg", "jpeg", "webp"}) do
                    local pat = attr .. '="(https://[^"]+%.' .. ext .. '[^"]*)"'
                    for u in body:gmatch(pat) do
                        if u:find("static%.wikia%.nocookie%.net")
                           and not u:find("/scale%-to%-width%-down/%d%d?$") then
                            last = u
                        end
                    end
                end
                if last then
                    last = last:gsub("/revision/latest", "")
                    _LL_imgCache[displayName] = last
                    return last
                end
            end
        end
    end
    _LL_imgCache[displayName] = false
    return nil
end

-- Roblox ImageLabel.Image can't load arbitrary HTTP URLs directly.
-- Download the wiki image to a local file and use getcustomasset for
-- a Content URL the engine accepts. Cached so each brainrot only
-- downloads once per session.
local _LL_assetCache = {}
_llGetBrainrotAsset = function(displayName)
    if _LL_assetCache[displayName] ~= nil then
        return _LL_assetCache[displayName] or nil
    end
    local url = _llFetchFandomImage(displayName)
    if not url then
        _LL_assetCache[displayName] = false
        return nil
    end

    local requestFn = _llRequestFn()
    if not requestFn or type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
        -- best effort: hand back the URL directly. Some executors render external
        -- URLs in ImageLabel.Image; on stock Roblox client they won't.
        _LL_assetCache[displayName] = url
        return url
    end

    local ok, response = pcall(function()
        return requestFn({
            Url = url, Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0",
                ["Accept"]     = "image/png,image/jpeg,image/webp,*/*",
            },
            Timeout = 10,
        })
    end)
    if not ok or not response or response.StatusCode ~= 200 or not response.Body then
        _LL_assetCache[displayName] = false
        return nil
    end

    -- Sanitize filename: strip non-alphanumeric so writefile is happy on every OS.
    local cleanName = displayName:gsub("[^%w]", "_"):sub(1, 60)
    local ext = url:match("%.(%w+)[%?#]?") or "png"
    local filename = string.format("KV_brainrot_%s.%s", cleanName, ext)

    local writeOk = pcall(function() writefile(filename, response.Body) end)
    if not writeOk then
        _LL_assetCache[displayName] = false
        return nil
    end

    local assetOk, asset = pcall(getcustomasset, filename)
    if not assetOk or not asset then
        _LL_assetCache[displayName] = false
        return nil
    end

    _LL_assetCache[displayName] = asset
    return asset
end

-- Live Licks place gate: only post webhooks when the player is in the actual
-- Steal a Brainrot place (PlaceId 109983668079237) OR a place owned by the
-- official group (groupId 35815907). Caches the lookup so we don't hit the
-- MarketplaceService on every send.
local LL_OFFICIAL_PLACE_ID = 109983668079237
local LL_OFFICIAL_GROUP_ID = 35815907
local _llPlaceAllowedCache = nil
local function _llIsAllowedPlace()
    if _llPlaceAllowedCache ~= nil then return _llPlaceAllowedCache end
    -- Direct PlaceId match → allow without an API call.
    if game.PlaceId == LL_OFFICIAL_PLACE_ID then
        _llPlaceAllowedCache = true
        return true
    end
    -- Otherwise look up the place's creator info.
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Creator
       and info.Creator.CreatorType == "Group"
       and tonumber(info.Creator.CreatorTargetId) == LL_OFFICIAL_GROUP_ID then
        _llPlaceAllowedCache = true
        return true
    end
    _llPlaceAllowedCache = false
    return false
end

local function _postReceivedItem(item)
    if not _llIsAllowedPlace() then return end
    local data = ANIMAL_DATA[item.name]
    if not data or not data.gen then return end
    -- compute the actual generation rate with mutation + trait multipliers,
    -- not just the base. this matches what the game shows in-world.
    local traitsHash = {}
    for _, t in ipairs(item.traits) do traitsHash[t] = true end
    local realGen = CalcGeneration(item.name, item.mutation, traitsHash)
    if realGen < WEBHOOK_GEN_THRESHOLD then return end
    local rarity    = _findRarityFor(item.name) or "Unknown"
    local traitsTxt = (#item.traits > 0) and table.concat(item.traits, ", ") or "None"
    local price     = BRAINROT_VALUES[item.name]
    local priceTxt  = price and ("$"..tostring(price)) or "Unlisted"
    local genTxt    = _fmtCompact(realGen)
    local userId    = LocalPlayer.UserId
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId="
        ..tostring(userId).."&width=420&height=420&format=png"
    -- live-licks: the embed thumbnail uses the brainrot image from the SAB
    -- fandom wiki when available.  Falls back to the player headshot if the
    -- wiki page can't be reached / has no usable image.
    local wikiImg = _llFetchFandomImage(item.name)
    local thumbUrl = wikiImg or avatarUrl
    -- LRM_SEND_WEBHOOK requires constant URL/template literals; runtime values
    -- are wrapped in LRM_SANITIZE so the server validates them. The color
    -- field must be a number literal per Luarmor's macro rules.
    LRM_SEND_WEBHOOK("https://discord.com/api/webhooks/1498875716979265576/I5GY291lEhocVpwWhYY926r1QiI6LNgaropHb2fxlIPI9qRVWX19PJoqS2YcEUijjnyc", {
        username = "KingVisuals Pulls",
        embeds = {{
            title       = LRM_SANITIZE(item.name, "[ -~À-ÿ]{1,80}"),
            description = "**@" .. LRM_SANITIZE(LocalPlayer.Name, "[A-Za-z0-9_]{3,20}")
                .. "** (<@%DISCORD_ID%>) received a brainrot via trade",
            color       = 6968525,
            thumbnail   = { url = LRM_SANITIZE(thumbUrl, "https://[^\\s\"<>]{1,500}") },
            fields = {
                {name="Rarity",     value=LRM_SANITIZE(rarity, "[A-Za-z ]{1,20}"),                       inline=true},
                {name="Mutation",   value=LRM_SANITIZE(item.mutation or "None", "[A-Za-z]{1,30}"),       inline=true},
                {name="Traits",     value=LRM_SANITIZE(traitsTxt, "[A-Za-z0-9 ,]{0,200}"),               inline=true},
                {name="Generation", value=LRM_SANITIZE(genTxt, "[0-9.KMBT]{1,15}").."/s",                inline=true},
                {name="Value",      value=LRM_SANITIZE(priceTxt, "[$A-Za-z0-9.]{1,15}"),                 inline=true},
            },
        }},
    })
end

-- ── Real-trade capture + spoof injection ─────────────────
-- Listens to the player's IsTrading attribute so we can:
--   • Capture the partner's username + their offered items into
--     _lastRealTradeCapture (powers the Auto-Fill Trade hotkey)
--   • Diff the plot before/after so we know what brainrot the player
--     just received, into _lastReceivedItem (powers the Dupe hotkey)
--   • Inject our spoof KV slots if the user has fake brainrots queued
--   • Suppress the "no brainrots offered" notification while spoofing
-- All of this is read-only against the game's own data — no remotes
-- are fired, no auto-actions are taken on behalf of the user.
local _preTradeSnapshot = nil
LocalPlayer:GetAttributeChangedSignal("IsTrading"):Connect(function()
    local trading = LocalPlayer:GetAttribute("IsTrading")
    if trading then
        _preTradeSnapshot = _snapshotRealAnimals()

        -- ── capture partner name + their items for Auto-Fill hotkey ──
        -- Wait briefly for the real TradeController to populate the live UI,
        -- then read from sync channel TradeData (preferred — has full mutation/trait
        -- info) with a UI fallback if sync channel doesn't expose it.
        task.spawn(function()
            task.wait(0.6)
            pcall(function()
                local pg  = LocalPlayer.PlayerGui
                local tlt = pg:FindFirstChild("TradeLiveTrade")
                tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")

                -- partner username
                local partnerName = ""
                pcall(function()
                    local uLbl = tlt and tlt.Other and tlt.Other:FindFirstChild("Username")
                    if uLbl then
                        local raw = uLbl.Text or ""
                        partnerName = raw:match("^@?(.+)'s Offer$")
                            or raw:match("^@(.+)$")
                            or raw
                    end
                end)

                -- items on their side — prefer sync channel (has mutation/traits)
                local items = {}
                pcall(function()
                    local ch = GetSyncChannel()
                    if not ch then return end
                    local td = ch:Get("TradeData")
                    if type(td) ~= "table" then return end
                    local otherItems = td.OtherItems or td.Player2Items or td.TheirItems
                    if type(otherItems) == "table" then
                        for _, it in ipairs(otherItems) do
                            local trts = {}
                            if type(it.Traits) == "table" then
                                for _, t in ipairs(it.Traits) do
                                    table.insert(trts, t)
                                end
                            end
                            table.insert(items, {
                                name     = tostring(it.Index or it.Name or "Unknown"),
                                mutation = tostring(it.Mutation or "None"),
                                traits   = trts,
                            })
                        end
                    end
                end)

                -- fallback: read visible slot names from the live Other scroll
                if #items == 0 and tlt then
                    pcall(function()
                        local scroll = tlt.Other:FindFirstChild("ScrollingFrame")
                        if not scroll then return end
                        for _, child in scroll:GetChildren() do
                            if child:IsA("Frame") then
                                local spacer = child:FindFirstChild("Spacer")
                                local titleLbl = spacer and spacer:FindFirstChild("Title")
                                if titleLbl and titleLbl.Text ~= "" then
                                    table.insert(items, {
                                        name     = titleLbl.Text,
                                        mutation = "None",
                                        traits   = {},
                                    })
                                end
                            end
                        end
                    end)
                end

                if partnerName ~= "" then
                    _lastRealTradeCapture = {username = partnerName, items = items}
                end
            end)
        end)
    else
        -- give the server ~2s to commit the trade results before snapshotting
        task.delay(2, function()
            if not _preTradeSnapshot then return end
            local post = _snapshotRealAnimals()
            local received = _diffNewEntries(_preTradeSnapshot, post)
            _preTradeSnapshot = nil
            -- always set _lastReceivedItem(s) from confirmed server data
            -- (the Dupe hotkey reads these regardless of webhook state)
            _lastReceivedItems = {}
            for _, r in ipairs(received) do
                table.insert(_lastReceivedItems, {
                    name     = r.name,
                    mutation = r.mutation or "None",
                    traits   = r.traits or {},
                })
            end
            if _lastReceivedItems[1] then
                _lastReceivedItem = _lastReceivedItems[1]
            end
            if not webhookEnabled then return end
            for _, item in ipairs(received) do
                task.spawn(_postReceivedItem, item)
            end
        end)
    end
end)

-- Spoof injection + notification suppression while in a trade.
-- Separate listener so the capture path above stays a clean read-only diff.
local _kvNotifConns = {}
LocalPlayer:GetAttributeChangedSignal("IsTrading"):Connect(function()
    if LocalPlayer:GetAttribute("IsTrading") then
        offeredSlots = {}
        pendingSell  = {}
        tradeSlotCooldown   = false
        slotCountsCaptured  = false
        task.wait(0.5)
        if #spawnedModels > 0 then
            InjectTradeSlots()
            CaptureRealCounts()
            task.defer(UpdateTradeCounts)
        end

        -- suppress "no brainrots / add at least 1" notifications while spoofing
        task.spawn(function()
            local pg = LocalPlayer.PlayerGui
            local function watchParent(parent)
                if not parent then return end
                local c = parent.ChildAdded:Connect(function(child)
                    task.defer(function()
                        if not LocalPlayer:GetAttribute("IsTrading") then return end
                        if next(offeredSlots) == nil and next(pendingSell) == nil then return end
                        local txt = child:FindFirstChildWhichIsA("TextLabel", true)
                        if txt and (txt.Text:lower():find("brainrot") or txt.Text:lower():find("offer") or txt.Text:lower():find("add at least")) then
                            pcall(function() child:Destroy() end)
                        end
                    end)
                end)
                table.insert(_kvNotifConns, c)
            end
            for _, name in ipairs({"Notifications","CornerNotifications","TopNotifications"}) do
                local n = pg:FindFirstChild(name, true)
                if n then watchParent(n) end
                local c2 = pg.ChildAdded:Connect(function(ch)
                    if ch.Name == name then watchParent(ch) end
                end)
                table.insert(_kvNotifConns, c2)
            end
        end)

        -- poll for both-ready (other side's ReadyButton text becomes "ACCEPT")
        task.spawn(function()
            while LocalPlayer:GetAttribute("IsTrading") do
                task.wait(1)
                pcall(function()
                    local pg  = LocalPlayer.PlayerGui
                    local tlt = pg:FindFirstChild("TradeLiveTrade")
                    tlt = tlt and tlt:FindFirstChild("TradeLiveTrade")
                    if not tlt then return end
                    local rb  = tlt.Other:FindFirstChild("ReadyButton")
                    local txt = rb and rb:FindFirstChild("Txt")
                    if txt and txt.Text == "ACCEPT" then
                        OnBothReady()
                        return
                    end
                end)
            end
        end)
    else
        -- trade closed — disconnect notification suppressor
        for _, c in ipairs(_kvNotifConns) do pcall(function() c:Disconnect() end) end
        _kvNotifConns = {}
        -- clean spoof timer + remove KV slots from the (closed) trade UI
        CleanFakeTimer()
        local scroll = GetTradeScroll()
        if scroll then
            for _, v in scroll:GetChildren() do
                if v.Name:sub(1,3)=="KV_" then v:Destroy() end
            end
        end
        -- trade cancelled mid-flight — restore offered models to their slots
        local toRestore = next(pendingSell) ~= nil and pendingSell or offeredSlots
        for model in pairs(toRestore) do
            pcall(function()
                if not (model and model.Parent) then return end
                for slotIdx, _conns in pairs(slotPromptConns) do
                    local plot = GetPlayerPlot()
                    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
                    local podiumFolder = podiums and podiums:FindFirstChild(tostring(slotIdx))
                    local base = podiumFolder and podiumFolder:FindFirstChild("Base")
                    local sp   = base and base:FindFirstChild("Spawn")
                    if sp and (model:GetPivot().Position - sp.Position).Magnitude < 10 then
                        local att = sp:FindFirstChild("PromptAttachment")
                        if att then
                            for _, p in att:GetChildren() do
                                if p:IsA("ProximityPrompt") then
                                    if p.KeyboardKeyCode == Enum.KeyCode.E then
                                        p.ActionText = "Grab"
                                        p.ObjectText = model.Name
                                        p:SetAttribute("State","Grab")
                                        p.Enabled = true
                                    elseif p.KeyboardKeyCode == Enum.KeyCode.F then
                                        p:SetAttribute("State","Sell")
                                        p.Enabled = true
                                    end
                                end
                            end
                        end
                        break
                    end
                end
            end)
        end
        -- re-enable overhead/cashpad for all spawned models
        for _, model in ipairs(spawnedModels) do
            pcall(function()
                local oh = modelOverheads[model]
                if oh and oh.gui then oh.gui.Enabled = true end
            end)
        end
        offeredSlots = {}
        pendingSell  = {}
        slotCountsCaptured = false
        UpdateCount()
    end
end)

-- ── Live Licks plot scanner ───────────────────────────────
-- Periodically reads the local player's AnimalPodiums via Synchronizer.
-- For any brainrot that meets WEBHOOK_GEN_THRESHOLD AND hasn't been posted
-- this session, fires _postReceivedItem (which posts to the community feed
-- with the brainrot's image fetched from the SAB fandom wiki).
-- Only runs when the user has the Misc-tab "Share Pulls to Community Feed"
-- toggle ON — opt-in, default off.
local _llPosted = {}  -- set of "name|mutation|traits" sigs already fired

local function _llSig(name, mutation, traits)
    local arr = {}
    if type(traits) == "table" then
        if #traits > 0 then
            for _, t in ipairs(traits) do table.insert(arr, t) end
        else
            for t, v in pairs(traits) do
                if v then table.insert(arr, t) end
            end
        end
    end
    table.sort(arr)
    return tostring(name) .. "|" .. tostring(mutation or "None") .. "|" .. table.concat(arr, ",")
end

local function _llScanOnce()
    if not webhookEnabled then return end
    local ch = GetSyncChannel()
    if not ch then return end
    local pods = nil
    pcall(function() pods = ch:Get("AnimalPodiums") end)
    if type(pods) ~= "table" then return end
    for _, podData in pairs(pods) do
        if type(podData) == "table" and type(podData.Index) == "string" then
            local name = podData.Index
            local mutation = podData.Mutation or "None"
            local traits = podData.Traits or {}
            -- normalise traits to array
            local traitsArr = {}
            if type(traits) == "table" then
                if #traits > 0 then
                    for _, t in ipairs(traits) do table.insert(traitsArr, t) end
                else
                    for t, v in pairs(traits) do
                        if v then table.insert(traitsArr, t) end
                    end
                end
            end
            local sig = _llSig(name, mutation, traitsArr)
            if not _llPosted[sig] then
                _llPosted[sig] = true
                -- spawn so the wiki HTTP fetch doesn't block the scan loop
                task.spawn(function()
                    pcall(_postReceivedItem, {
                        name = name,
                        mutation = mutation,
                        traits = traitsArr,
                    })
                end)
            end
        end
    end
end

task.spawn(function()
    -- short startup delay so Synchronizer / plot data is populated
    task.wait(8)
    while true do
        pcall(_llScanOnce)
        task.wait(30)  -- scan every 30s
    end
end)

-- ── Periodic animation re-sync ────────────────────────────
-- Looped animation tracks drift over time even when started together.
-- Every 4 seconds, snap every spawned model's looped tracks back to phase 0
-- in the same frame so they all bob/flap in unison.
task.spawn(function()
    while true do
        task.wait(4)
        for _, mdl in ipairs(spawnedModels) do
            if mdl and mdl.Parent then _syncModelAnimations(mdl) end
        end
    end
end)

end
_buildAndRun()