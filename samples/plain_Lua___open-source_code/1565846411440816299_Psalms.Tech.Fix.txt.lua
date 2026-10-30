-- https://discord.gg/UgQAPcBtpy [hihi]
-- I JUST FIX LIBRARY OK?

setfpscap(1000)

loadstring(game:HttpGet'https://pastefy.app/aAkQKVF4/raw')()
local function cooked(Sex3)

if Sex3 then  
   
 
if getgenv().executed then
        return  
    end
   getgenv().executed = true
print("khen.cc")

local startTime = os.clock()


repeat wait() until game:IsLoaded()


loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/bypasssssssss%20game"))()


if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
LPH_NO_VIRTUALIZE  = function(...) return ... end
end


local getcustom = string.find(identifyexecutor(), "Delta")

local  Library

    local assetsupport = string.find(identifyexecutor(), "Wave") or string.find(identifyexecutor(), "Seliware") or string.find(identifyexecutor(), "AWP") or string.find(identifyexecutor(), "Argon") or string.find(identifyexecutor(), "Swift")



if assetsupport then
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/Powerful.lua", true))()
else
    Library  = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/library/refs/heads/main/pslam.lua",true))()
end




local function getAsset(path)
    if getcustom then
        return getcustomasset(string.format("images_stuff/%s", path))
    else
        return "rbxassetid://0"
    end
end





downloadSound = LPH_NO_VIRTUALIZE(function(SoundName, SoundUrl)
    local SoundPath = string.format("images_stuff/%s", SoundName)
    if not isfile(SoundPath) then
        writefile(SoundPath, game:HttpGet(SoundUrl))
    end
    return SoundPath
end)



local Psalms = {
    Tech = {
        Enabled = false,
        AutoPrediction = false,
        AutoPredMode = "PingBased",
        APMODE = "Calculate",
        
        RealPart = "HumanoidRootPart",
        SelectedPart = "HumanoidRootPart",
        AirPart = "RightFoot",
        
        HorizontalPrediction = 0.1,
        VerticalPrediction = 0.1,
        HorizontalPrediction2 = 0.1,
        VerticalPrediction2 = 0.1,
        
        jumpoffset = 0,
        jumpoffset2 = -0.3,
        jumpoffset3 = 0.270,
        
        ShootDelay = 0.22,
        NoGroundShot = false,
        AutoAir = false,
        
        TracerEnabled = true,
        LookAt = false,
        
        Camera = false,
        CamPrediction1 = 0.1,
        CamPrediction2 = 0.1,
        SilentMode = false, 
        smoothness = 0.9,
        speedvalue = 1,
        MacroSpeed = 0.2,
        AntiCurve = false,
        ResolverEnabled = false,
        
        easingStyle = "Sine",
        easingDirection = "Out",
isTargetPlrMode = true,
        shootDelay = 0.114,
        lastShootTime = 0,
TriggerPot = true, 
        
        JumpBreak = false,
        network = false,
        UseVertical = false,
        DotC = Color3.fromRGB(0, 0, 0),
WallCheck = false,
FriendCheck = false, 
 KOCheck = false, 
SeatedCheck = false, 
TeamCheck = false,
UnlockOnKO = false,
CamWallCheck = false, 
CAMKo = false,
bool_at_tp = false, 
MacroDance = "YungBlud",
MacroDanceDelay = 0.300,
    }
}

Psalms.Tech.SelectedPart = Psalms.Tech.RealPart




local Sleeping = false

local TargetAimbot = {
    Enabled = true,
    Keybind = Enum.KeyCode.Q,
    Autoselect = false,
    Prediction = 0.145, 
    RealPrediction = 0.145, 
    Resolver = false, 
    ResolverType = "Recalculate", 
    JumpOffset = 0.06, 
    RealJumpOffset = 0.09, 
    HitParts = {"HumanoidRootPart"}, 
    RealHitPart = "HumanoidRootPart", 
    KoCheck = false, 
    LookAt = false,
    CSync = {
        Enabled = false,
        Type = "Orbit",
        Distance = 10,
        Height = 2,
        Speed = 10,
        RandomAmount = 10,
        Color = Color3.fromRGB(255, 255, 255),
        Saved = nil,
        Visualize = false,
    },
    ViewAt = false,
    Tracer = false,
    Highlight = true,
    HighlightColor1 =Color3.fromRGB(255, 255, 255),
    HighlightColor2 =Color3.fromRGB(255, 255, 255),
    Stats = false, 
    UseFov = false,
    HitEffect = false,
    HitEffectType = "Coom", --  {{ Nova, Crescent Slash, Coom, Cosmic Explosion, Slash, Atomic Slash, Aura Burst }}
    HitEffectColor = Color3.fromRGB(255, 255, 255),
    HitSounds = false,
    HitSound = "Bameware",
    HitChams = false,
    HitChamsMaterial = Enum.Material.Neon,
    HitChamsDuration = 2,
    HitChamsColor = Color3.fromRGB(255, 0, 0),
    HitChamColorEnabled = false,
    HitChamsTransparency = 0,
    HitChamsAcc = false, 
   SkeleColor = Color3.fromRGB(155, 0, 155)

}

local  Highlight = false





local function toggleAimViewer()
local players = game:GetService("Players")
    local player = players.LocalPlayer
    player.CharacterAdded:Connect(function()
        local gui = player.PlayerGui:WaitForChild("gui")
        local aimViewerFrame = gui.Settings.ScrollingFrame.aimviewer
        aimViewerFrame.Visible = true
    end)

    local gui = player.PlayerGui:WaitForChild("gui")
    local aimViewerFrame = gui.Settings.ScrollingFrame.aimviewer
    aimViewerFrame.Visible = true
end



local UserInputService, Players, ReplicatedStorage, RunService, Workspace, Stats = 
    cloneref(game:GetService("UserInputService")), cloneref(game:GetService("Players")), cloneref(game:GetService("ReplicatedStorage")), 
    cloneref(game:GetService("RunService")), cloneref(game:GetService("Workspace")), cloneref(game:GetService("Stats"))

local CoreGui, StarterGui, SoundService, HttpService = 
    cloneref(game:GetService("CoreGui")), cloneref(game:GetService("StarterGui")), cloneref(game:GetService("SoundService")), cloneref(game:GetService("HttpService"))

local LocalPlayer = cloneref(Players.LocalPlayer)
local Camera = cloneref(Workspace.CurrentCamera)

local TargBindEnabled, TargetPlr, TargResolvePos = true, nil, nil
local TargHighlight = Instance.new("Highlight")


local AvatarEditorService = game:GetService("AvatarEditorService")
TargHighlight.Parent = CoreGui
TargHighlight.FillColor = TargetAimbot.HighlightColor1
TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
TargHighlight.FillTransparency = 0.5
TargHighlight.OutlineTransparency = 0
TargHighlight.Enabled = false

local AChams = false
local  updateBreatheEffect = LPH_NO_VIRTUALIZE(function() 
    if AChams then
        local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
        TargHighlight.FillTransparency = 100 * breathe_effect * 0.01
        TargHighlight.OutlineTransparency = 100 * breathe_effect * 0.01
    end
end) 




local HitEffectModule = {
    Locals = {
        Type = {
            ["Nova"] = nil,
            ["Crescent Slash"] = nil,
            ["Coom"] = nil,
            ["Cosmic Explosion"] = nil,
            ["Slash"] = nil,
            ["Atomic Slash"] = nil,
            ["AuraBurst"] = nil,
            ["Thunder"] = nil, 
        },
    },
    Functions = {},
    Settings = {HitEffect = {Color = TargetAimbot.HitEffectColor}}
}

local sounds = {
    BlackPencil = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/bananapencil.mp3.mp3?raw=true",
    UWU = "https://github.com/aa8283/m/blob/alt/sounds/Uwu.mp3?raw=true",
    Plooh = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/plooh.mp3?raw=true",
    Hrntai = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/Hrntai.wav?raw=true",
    Henta01 = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/henta01.wav?raw=true",
    Bruh = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/psalms%20bruh%20sample.mp3?raw=true",
    BoneBreakage = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/psalms%20bone%20breakage.mp3?raw=true",
    Fein = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/psalms%20highly%20defined%20fein.mp3?raw=true",
    Unicorn = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/shiny%20unicorn%20for%20dh%20_%20psalms.mp3?raw=true",
    Kitty = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/Kitty.mp3?raw=true",
    Bird = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/bird%20chirping%20for%20DH%20_%20psalms%20audio.mp3?raw=true",
    BirthdayCake = "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/Birthday%20cake%20for%20dh%20_%20psalms.mp3?raw=true", 
    KenCarson =  "https://github.com/aa8283/m/raw/refs/heads/alt/sounds/ken_carson_-_jennifer_s_body_offici(2).mp3?raw=true"
}

for name, url in pairs(sounds) do
    _G[name .. "Path"] = downloadSound(name .. ".mp3", url)
end

local hitsounds = {
    ["RIFK7"]          = "rbxassetid://9102080552",
    ["Bubble"]         = "rbxassetid://9102092728",
    ["Minecraft"]      = "rbxassetid://5869422451",
    ["Cod"]            = "rbxassetid://160432334",
    ["Bameware"]       = "rbxassetid://6565367558",
    ["Neverlose"]      = "rbxassetid://6565370984",
    ["Gamesense"]      = "rbxassetid://4817809188",
    ["Rust"]           = "rbxassetid://6565371338",
    ["BlackPencil"]    = getAsset("BlackPencil.mp3"),
    ["UWU"]            = getAsset("Uwu.mp3"),
    ["Plooh"]          = getAsset("plooh.mp3"),
    ["Moan"]           = getAsset("Hrntai.mp3"),
    ["Hentai"]         = getAsset("Henta01.mp3"),
    ["Bruh"]           = getAsset("Bruh.mp3"),
    ["BoneBreakage"]   = getAsset("BoneBreakage.mp3"),
    ["Fein"]           = getAsset("Fein.mp3"),
    ["Unicorn"]        = getAsset("Unicorn.mp3"),
    ["Kitty"]          = getAsset("Kitty.mp3"),
    ["Bird"]           = getAsset("Bird.mp3"),
    ["BirthdayCake"]   = getAsset("BirthdayCake.mp3"),
    ["KenCarson"]      = getAsset("KenCarson.mp3")
}


local HitChamsFolder = Instance.new("Folder")
HitChamsFolder.Name = "HitChamsFolder"
HitChamsFolder.Parent = Workspace

--// Crescent Slash

do
local Attachment = Instance.new("Attachment")
Attachment.Name = "Attachment"

HitEffectModule.Locals.Type["Crescent Slash"] = Attachment

local Glow = Instance.new("ParticleEmitter")
Glow.Name = "Glow"
Glow.Lifetime = NumberRange.new(0.16, 0.16)
Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
Glow.Color = ColorSequence.new(Color3.fromRGB(91, 177, 252))
Glow.Speed = NumberRange.new(0, 0)
Glow.Brightness = 5
Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
Glow.Enabled = false
Glow.ZOffset = -0.0565939
Glow.Rate = 50
Glow.Texture = "rbxassetid://8708637750"

local Gradient1 = Instance.new("ParticleEmitter")
Gradient1.Name = "Gradient1"
Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
Gradient1.Color = ColorSequence.new(Color3.fromRGB(115, 201, 255))
Gradient1.Speed = NumberRange.new(0, 0)
Gradient1.Brightness = 6
Gradient1.Size = NumberSequence.new(0, 11.6261358)
Gradient1.Enabled = false
Gradient1.ZOffset = 0.9187313
Gradient1.Rate = 50
Gradient1.Texture = "rbxassetid://8196169974"
Gradient1.Parent = Attachment

local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment

local ShardsDark = Instance.new("ParticleEmitter")
ShardsDark.Name = "ShardsDark"
ShardsDark.Lifetime = NumberRange.new(0.19, 0.35)
ShardsDark.SpreadAngle = Vector2.new(-90, 90)
ShardsDark.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
ShardsDark.Drag = 10
ShardsDark.VelocitySpread = -90
ShardsDark.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
ShardsDark.Speed = NumberRange.new(97.7530136, 146.9970093)
ShardsDark.Brightness = 4
ShardsDark.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.290774, 0.6734411, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
ShardsDark.Enabled = false
ShardsDark.ZOffset = 0.5705321
ShardsDark.Rate = 50
ShardsDark.Texture = "rbxassetid://8030734851"
ShardsDark.Rotation = NumberRange.new(90, 90)
ShardsDark.Orientation = Enum.ParticleOrientation.VelocityParallel
ShardsDark.Parent = Attachment

local Specs = Instance.new("ParticleEmitter")
Specs.Name = "Specs"
Specs.Lifetime = NumberRange.new(0.33, 1.4)
Specs.SpreadAngle = Vector2.new(360, -1000)
Specs.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
Specs.Drag = 10
Specs.VelocitySpread = 360
Specs.Speed = NumberRange.new(36.7492523, 146.9970093)
Specs.Brightness = 7
Specs.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)})
Specs.Enabled = false
Specs.Acceleration = Vector3.new(0, 36.74925231933594, 0)
Specs.Rate = 50
Specs.Texture = "rbxassetid://8030760338"
Specs.EmissionDirection = Enum.NormalId.Right
Specs.Parent = Attachment

local Specs1 = Instance.new("ParticleEmitter")
Specs1.Name = "Specs"
Specs1.Lifetime = NumberRange.new(0.33, 1.75)
Specs1.SpreadAngle = Vector2.new(90, -90)
Specs1.Color = ColorSequence.new(Color3.fromRGB(106, 171, 255))
Specs1.Drag = 9
Specs1.VelocitySpread = 90
Specs1.Speed = NumberRange.new(42.2616425, 73.4985046)
Specs1.Brightness = 6
Specs1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.210774, 0.3978962, 0.1855686), NumberSequenceKeypoint.new(1, 0)})
Specs1.Enabled = false
Specs1.Acceleration = Vector3.new(0, -20.21208953857422, 0)
Specs1.ZOffset = 0.5144895
Specs1.Rate = 50
Specs1.Texture = "rbxassetid://8030760338"
Specs1.Parent = Attachment

local Specs2 = Instance.new("ParticleEmitter")
Specs2.Name = "Specs"
Specs2.Lifetime = NumberRange.new(0.19, 1.2)
Specs2.SpreadAngle = Vector2.new(360, -1000)
Specs2.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
Specs2.Drag = 10
Specs2.VelocitySpread = 360
Specs2.Speed = NumberRange.new(36.7492523, 146.9970093)
Specs2.Brightness = 7
Specs2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.200774, 2.0311937, 0.4363973), NumberSequenceKeypoint.new(1, 0)})
Specs2.Enabled = false
Specs2.Acceleration = Vector3.new(0, 36.74925231933594, 0)
Specs2.Rate = 50
Specs2.Texture = "rbxassetid://8030760338"
Specs2.EmissionDirection = Enum.NormalId.Right
Specs2.Parent = Attachment

local Specs21 = Instance.new("ParticleEmitter")
Specs21.Name = "Specs2"
Specs21.Lifetime = NumberRange.new(0.19, 1.35)
Specs21.SpreadAngle = Vector2.new(90, -90)
Specs21.Color = ColorSequence.new(Color3.fromRGB(106, 171, 255))
Specs21.Drag = 12
Specs21.VelocitySpread = 90
Specs21.Speed = NumberRange.new(42.2616425, 73.4985046)
Specs21.Brightness = 6
Specs21.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.216774, 0.5721694, 0.1855686), NumberSequenceKeypoint.new(1, 0)})
Specs21.Enabled = false
Specs21.Acceleration = Vector3.new(0, -20.21208953857422, 0)
Specs21.ZOffset = 0.5144895
Specs21.Rate = 50
Specs21.Texture = "rbxassetid://8030760338"
Specs21.Parent = Attachment

local ddddddddddddddddddd = Instance.new("ParticleEmitter")
ddddddddddddddddddd.Name = "ddddddddddddddddddd"
ddddddddddddddddddd.Lifetime = NumberRange.new(0.19, 0.37)
ddddddddddddddddddd.SpreadAngle = Vector2.new(90, -90)
ddddddddddddddddddd.LockedToPart = true
ddddddddddddddddddd.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6429392, 0), NumberSequenceKeypoint.new(1, 0)})
ddddddddddddddddddd.LightEmission = 1
ddddddddddddddddddd.Color = ColorSequence.new(Color3.fromRGB(90, 184, 255), Color3.fromRGB(165, 251, 255))
ddddddddddddddddddd.Drag = 6
ddddddddddddddddddd.TimeScale = 0.7
ddddddddddddddddddd.VelocitySpread = 90
ddddddddddddddddddd.Speed = NumberRange.new(81.5833435, 110.2477646)
ddddddddddddddddddd.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.410774, 0.6711507, 0.3356177), NumberSequenceKeypoint.new(1, 0)})
ddddddddddddddddddd.Enabled = false
ddddddddddddddddddd.Acceleration = Vector3.new(0, -81.58334350585938, 0)
ddddddddddddddddddd.ZOffset = 0.8345273
ddddddddddddddddddd.Rate = 50
ddddddddddddddddddd.Texture = "rbxassetid://1053546634"
ddddddddddddddddddd.RotSpeed = NumberRange.new(-444, 166)
ddddddddddddddddddd.Rotation = NumberRange.new(-360, 360)
ddddddddddddddddddd.Parent = Attachment

local large_shard = Instance.new("ParticleEmitter")
large_shard.Name = "large_shard"
large_shard.Lifetime = NumberRange.new(0.19, 0.28)
large_shard.SpreadAngle = Vector2.new(-90, 90)
large_shard.Color = ColorSequence.new(Color3.fromRGB(108, 184, 255))
large_shard.Drag = 10
large_shard.VelocitySpread = -90
large_shard.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
large_shard.Speed = NumberRange.new(97.7530136, 146.9970093)
large_shard.Brightness = 4
large_shard.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.260774, 3.515605, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
large_shard.Enabled = false
large_shard.ZOffset = 0.5705321
large_shard.Rate = 50
large_shard.Texture = "rbxassetid://8030734851"
large_shard.Rotation = NumberRange.new(90, 90)
large_shard.Orientation = Enum.ParticleOrientation.VelocityParallel
large_shard.Parent = Attachment

local out_Specs = Instance.new("ParticleEmitter")
out_Specs.Name = "out_Specs"
out_Specs.Lifetime = NumberRange.new(0.19, 1)
out_Specs.SpreadAngle = Vector2.new(44, -1000)
out_Specs.Color = ColorSequence.new(Color3.fromRGB(98, 174, 255))
out_Specs.Drag = 10
out_Specs.VelocitySpread = 44
out_Specs.Speed = NumberRange.new(36.7492523, 146.9970093)
out_Specs.Brightness = 7
out_Specs.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.244774, 0.5469525, 0.1433053), NumberSequenceKeypoint.new(1, 0)})
out_Specs.Enabled = false
out_Specs.Acceleration = Vector3.new(0, -3.215559720993042, 0)
out_Specs.Rate = 50
out_Specs.Texture = "rbxassetid://8030760338"
out_Specs.EmissionDirection = Enum.NormalId.Right
out_Specs.Parent = Attachment

local Effect = Instance.new("ParticleEmitter")
Effect.Name = "Effect"
Effect.Lifetime = NumberRange.new(0.4, 0.7)
Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
Effect.SpreadAngle = Vector2.new(360, -360)
Effect.LockedToPart = true
Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
Effect.LightEmission = 1
Effect.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
Effect.Drag = 1
Effect.VelocitySpread = 360
Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
Effect.Brightness = 2.0999999
Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
Effect.Enabled = false
Effect.ZOffset = 0.4777403
Effect.Rate = 50
Effect.Texture = "rbxassetid://9484012464"
Effect.RotSpeed = NumberRange.new(-150, -150)
Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
Effect.Rotation = NumberRange.new(50, 50)
Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Effect.Parent = Attachment

local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 1
Crescents.Color = ColorSequence.new(Color3.fromRGB(92, 161, 252))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 20
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment
end

do --// Cosmic Explosion


local Attachment = Instance.new("Attachment")
Attachment.Name = "Attachment"

HitEffectModule.Locals.Type["Cosmic Explosion"] = Attachment

local Glow = Instance.new("ParticleEmitter")
Glow.Name = "Glow"
Glow.Lifetime = NumberRange.new(0.16, 0.16)
Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Glow.Speed = NumberRange.new(0, 0)
Glow.Brightness = 5
Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
Glow.Enabled = false
Glow.ZOffset = -0.0565939
Glow.Rate = 50
Glow.Texture = "rbxassetid://8708637750"
Glow.Parent = Attachment

local Effect = Instance.new("ParticleEmitter")
Effect.Name = "Effect"
Effect.Lifetime = NumberRange.new(0.4, 0.7)
Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
Effect.SpreadAngle = Vector2.new(360, -360)
Effect.LockedToPart = true
Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
Effect.LightEmission = 1
Effect.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Effect.Drag = 1
Effect.VelocitySpread = 360
Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
Effect.Brightness = 2.0999999
Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
Effect.Enabled = false
Effect.ZOffset = 0.4777403
Effect.Rate = 50
Effect.Texture = "rbxassetid://9484012464"
Effect.RotSpeed = NumberRange.new(-150, -150)
Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
Effect.Rotation = NumberRange.new(50, 50)
Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Effect.Parent = Attachment

local Gradient1 = Instance.new("ParticleEmitter")
Gradient1.Name = "Gradient1"
Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
Gradient1.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Gradient1.Speed = NumberRange.new(0, 0)
Gradient1.Brightness = 6
Gradient1.Size = NumberSequence.new(0, 11.6261358)
Gradient1.Enabled = false
Gradient1.ZOffset = 0.9187313
Gradient1.Rate = 50
Gradient1.Texture = "rbxassetid://8196169974"
Gradient1.Parent = Attachment

local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment

local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 10
Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 4
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment

local ParticleEmitter2 = Instance.new("ParticleEmitter")
ParticleEmitter2.Name = "ParticleEmitter2"
ParticleEmitter2.FlipbookFramerate = NumberRange.new(20, 20)
ParticleEmitter2.Lifetime = NumberRange.new(0.19, 0.38)
ParticleEmitter2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
ParticleEmitter2.SpreadAngle = Vector2.new(360, 360)
ParticleEmitter2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.209842, 0.5), NumberSequenceKeypoint.new(0.503842, 0.263333), NumberSequenceKeypoint.new(0.799842, 0.5), NumberSequenceKeypoint.new(1, 1)})
ParticleEmitter2.LightEmission = 1
ParticleEmitter2.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
ParticleEmitter2.VelocitySpread = 360
ParticleEmitter2.Speed = NumberRange.new(0.0161231, 0.0161231)
ParticleEmitter2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 4.3125), NumberSequenceKeypoint.new(0.3985056, 7.9375), NumberSequenceKeypoint.new(1, 10)})
ParticleEmitter2.Enabled = false
ParticleEmitter2.ZOffset = 0.15
ParticleEmitter2.Rate = 100
ParticleEmitter2.Texture = "http://www.roblox.com/asset/?id=12394566430"
ParticleEmitter2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
ParticleEmitter2.Rotation = NumberRange.new(39, 999)
ParticleEmitter2.Orientation = Enum.ParticleOrientation.VelocityParallel
ParticleEmitter2.Parent = Attachment
end

do --// Coom

local Attachment = Instance.new("Attachment")

HitEffectModule.Locals.Type["Coom"] = Attachment

local Foam = Instance.new("ParticleEmitter")
Foam.Name = "Foam"
Foam.LightInfluence = 0.5
Foam.Lifetime = NumberRange.new(1, 1)
Foam.SpreadAngle = Vector2.new(360, -360)
Foam.VelocitySpread = 360
Foam.Squash = NumberSequence.new(1)
Foam.Speed = NumberRange.new(20, 20)
Foam.Brightness = 2.5
Foam.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.1016692, 0.6508875, 0.6508875), NumberSequenceKeypoint.new(0.6494689, 1.4201183, 0.4127519), NumberSequenceKeypoint.new(1, 0)})
Foam.Enabled = false
Foam.Acceleration = Vector3.new(0, -66.04029846191406, 0)
Foam.Rate = 100
Foam.Texture = "rbxassetid://8297030850"
Foam.Rotation = NumberRange.new(-90, -90)
Foam.Orientation = Enum.ParticleOrientation.VelocityParallel
Foam.Parent = Attachment
end

do --// Slash
local Attachment = Instance.new("Attachment")
HitEffectModule.Locals.Type["Slash"] = Attachment

local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 10
Crescents.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 96, 255)), ColorSequenceKeypoint.new(0.3160622, Color3.fromRGB(160, 96, 255)), ColorSequenceKeypoint.new(0.5146805, Color3.fromRGB(154, 82, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 96, 255))})
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 4
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment
end

do --// Atomic Slash


local Attachment = Instance.new("Attachment")

HitEffectModule.Locals.Type["Atomic Slash"] = Attachment

local Crescents = Instance.new("ParticleEmitter")
Crescents.Name = "Crescents"
Crescents.Lifetime = NumberRange.new(0.19, 0.38)
Crescents.SpreadAngle = Vector2.new(-360, 360)
Crescents.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1932907, 0), NumberSequenceKeypoint.new(0.778754, 0), NumberSequenceKeypoint.new(1, 1)})
Crescents.LightEmission = 10
Crescents.Color = ColorSequence.new(Color3.fromRGB(160, 96, 255))
Crescents.VelocitySpread = -360
Crescents.Speed = NumberRange.new(0.0826858, 0.0826858)
Crescents.Brightness = 4
Crescents.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.398774, 8.8026266, 2.2834616), NumberSequenceKeypoint.new(1, 11.477972, 1.860431)})
Crescents.Enabled = false
Crescents.ZOffset = 0.4542207
Crescents.Rate = 50
Crescents.Texture = "rbxassetid://12509373457"
Crescents.RotSpeed = NumberRange.new(800, 1000)
Crescents.Rotation = NumberRange.new(-360, 360)
Crescents.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Crescents.Parent = Attachment

local Glow = Instance.new("ParticleEmitter")
Glow.Name = "Glow"
Glow.Lifetime = NumberRange.new(0.16, 0.16)
Glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1421725, 0.6182796), NumberSequenceKeypoint.new(1, 1)})
Glow.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Glow.Speed = NumberRange.new(0, 0)
Glow.Brightness = 5
Glow.Size = NumberSequence.new(9.1873131, 16.5032349)
Glow.Enabled = false
Glow.ZOffset = -0.0565939
Glow.Rate = 50
Glow.Texture = "rbxassetid://8708637750"
Glow.Parent = Attachment

local Effect = Instance.new("ParticleEmitter")
Effect.Name = "Effect"
Effect.Lifetime = NumberRange.new(0.4, 0.7)
Effect.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
Effect.SpreadAngle = Vector2.new(360, -360)
Effect.LockedToPart = true
Effect.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1070999, 0.19375), NumberSequenceKeypoint.new(0.7761194, 0.88125), NumberSequenceKeypoint.new(1, 1)})
Effect.LightEmission = 1
Effect.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Effect.Drag = 1
Effect.VelocitySpread = 360
Effect.Speed = NumberRange.new(0.0036749, 0.0036749)
Effect.Brightness = 2.0999999
Effect.Size = NumberSequence.new(6.9680691, 9.9213123)
Effect.Enabled = false
Effect.ZOffset = 0.4777403
Effect.Rate = 50
Effect.Texture = "rbxassetid://9484012464"
Effect.RotSpeed = NumberRange.new(-150, -150)
Effect.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
Effect.Rotation = NumberRange.new(50, 50)
Effect.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
Effect.Parent = Attachment

local Gradient1 = Instance.new("ParticleEmitter")
Gradient1.Name = "Gradient1"
Gradient1.Lifetime = NumberRange.new(0.3, 0.3)
Gradient1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.3), NumberSequenceKeypoint.new(1, 1)})
Gradient1.Color = ColorSequence.new(Color3.fromRGB(173, 82, 252))
Gradient1.Speed = NumberRange.new(0, 0)
Gradient1.Brightness = 6
Gradient1.Size = NumberSequence.new(0, 11.6261358)
Gradient1.Enabled = false
Gradient1.ZOffset = 0.9187313
Gradient1.Rate = 50
Gradient1.Texture = "rbxassetid://8196169974"
Gradient1.Parent = Attachment

local Shards = Instance.new("ParticleEmitter")
Shards.Name = "Shards"
Shards.Lifetime = NumberRange.new(0.19, 0.7)
Shards.SpreadAngle = Vector2.new(-90, 90)
Shards.Color = ColorSequence.new(Color3.fromRGB(179, 145, 253))
Shards.Drag = 10
Shards.VelocitySpread = -90
Shards.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5705521, 0.4125001), NumberSequenceKeypoint.new(1, -0.9375)})
Shards.Speed = NumberRange.new(97.7530136, 146.9970093)
Shards.Brightness = 4
Shards.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.284774, 1.2389833, 0.1534118), NumberSequenceKeypoint.new(1, 0)})
Shards.Enabled = false
Shards.Acceleration = Vector3.new(0, -56.961341857910156, 0)
Shards.ZOffset = 0.5705321
Shards.Rate = 50
Shards.Texture = "rbxassetid://8030734851"
Shards.Rotation = NumberRange.new(90, 90)
Shards.Orientation = Enum.ParticleOrientation.VelocityParallel
Shards.Parent = Attachment
end




do --// Aura Burst
    local attachment = Instance.new("Attachment")
    attachment.Name = "Attachment"
    HitEffectModule.Locals.Type["AuraBurst"] = attachment
    

local useparticle2 = Instance.new('ParticleEmitter')
useparticle2.Name = "useparticle2"
useparticle2.Acceleration = Vector3.new(0, 10, 0)
useparticle2.Brightness = 10
useparticle2.Color = ColorSequence.new(Color3.new(0, 1, 0.333333), Color3.new(0, 0, 1))
useparticle2.Drag = 3
useparticle2.Enabled = false
useparticle2.Lifetime = NumberRange.new(0.3, 10)
useparticle2.LightEmission = 1
useparticle2.Rate = 50
useparticle2.RotSpeed = NumberRange.new(-150, 150)
useparticle2.Rotation = NumberRange.new(-360, 360)
useparticle2.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.19467, 0.819203),
    NumberSequenceKeypoint.new(1, 0)
})
useparticle2.Speed = NumberRange.new(4.49742, 34.4802)
useparticle2.SpreadAngle = Vector2.new(360, 360)
useparticle2.Texture = "rbxassetid://16171528032"
useparticle2.Parent = attachment

local useparticle = Instance.new('ParticleEmitter')
useparticle.Name = "useparticle"
useparticle.Acceleration = Vector3.new(0, 10, 0)
useparticle.Brightness = 10
useparticle.Color = ColorSequence.new(Color3.new(0, 1, 0.403922), Color3.new(0.12549, 0, 1))
useparticle.Drag = 3
useparticle.Enabled = false
useparticle.Lifetime = NumberRange.new(0.3, 10)
useparticle.LightEmission = 1
useparticle.Rate = 50
useparticle.RotSpeed = NumberRange.new(-150, 150)
useparticle.Rotation = NumberRange.new(-360, 360)
useparticle.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.19467, 0.819203),
    NumberSequenceKeypoint.new(1, 0)
})
useparticle.Speed = NumberRange.new(4.49742, 34.4802)
useparticle.SpreadAngle = Vector2.new(360, 360)
useparticle.Texture = "rbxassetid://16171528032"
useparticle.Parent = attachment

local circles2 = Instance.new('ParticleEmitter')
circles2.Name = "circles2"
circles2.Acceleration = Vector3.new(0, 0, 0.001)
circles2.Brightness = 10
circles2.Color = ColorSequence.new(Color3.new(0, 1, 0.541176), Color3.new(0.0784314, 0, 1))
circles2.Enabled = false
circles2.Lifetime = NumberRange.new(0.9, 0.9)
circles2.LightInfluence = 0.35
circles2.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
circles2.Rate = 4
circles2.RotSpeed = NumberRange.new(150, 150)
circles2.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.20394, 8.79781),
    NumberSequenceKeypoint.new(1, 10)
})
circles2.Speed = NumberRange.new(0.01, 0.01)
circles2.SpreadAngle = Vector2.new(360, 360)
circles2.Texture = "http://www.roblox.com/asset/?id=6835970470"
circles2.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.840125, 0.83125),
    NumberSequenceKeypoint.new(1, 1)
})
circles2.Parent = attachment

local circles = Instance.new('ParticleEmitter')
circles.Name = "circles"
circles.Acceleration = Vector3.new(0, 0, 0.001)
circles.Brightness = 10
circles.Color = ColorSequence.new(Color3.new(0, 1, 0.45098), Color3.new(0.133333, 0, 1))
circles.Enabled = false
circles.Lifetime = NumberRange.new(0.9, 0.9)
circles.LightInfluence = 0.35
circles.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
circles.Rate = 4
circles.RotSpeed = NumberRange.new(150, 150)
circles.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.20394, 8.79781),
    NumberSequenceKeypoint.new(1, 10)
})
circles.Speed = NumberRange.new(0.01, 0.01)
circles.SpreadAngle = Vector2.new(360, 360)
circles.Texture = "http://www.roblox.com/asset/?id=6835970470"
circles.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.840125, 0.83125),
    NumberSequenceKeypoint.new(1, 1)
})
circles.Parent = attachment
end

do --// Thunder
    local attachment = Instance.new("Attachment")
    attachment.Name = "Attachment"
HitEffectModule.Locals.Type["Thunder"] = attachment

local ELECTRIC2 = Instance.new('ParticleEmitter')
ELECTRIC2.Parent = attachment
ELECTRIC2.Name = "ELECTRIC"
ELECTRIC2.Brightness = 3
ELECTRIC2.Color = ColorSequence.new(Color3.new(0, 0.52549, 0.780392), Color3.new(1, 0, 1))
ELECTRIC2.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
ELECTRIC2.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
ELECTRIC2.Lifetime = NumberRange.new(1, 3)
ELECTRIC2.LightEmission = 1
ELECTRIC2.Orientation = Enum.ParticleOrientation.FacingCameraWorldUp
ELECTRIC2.Rate = 5
ELECTRIC2.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 19),
    NumberSequenceKeypoint.new(1, 0)
})
ELECTRIC2.Speed = NumberRange.new(0, 0)
ELECTRIC2.SpreadAngle = Vector2.new(-360, 360)
ELECTRIC2.Texture = "rbxassetid://10547286472"
ELECTRIC2.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.25, 1),
    NumberSequenceKeypoint.new(1, 1)
})

local ParticleEmitter = Instance.new('ParticleEmitter') 
ParticleEmitter.Color = ColorSequence.new(
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(0, 0, 139)
)
ParticleEmitter.Drag = 5
ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.4)
ParticleEmitter.LightEmission = 0.5
ParticleEmitter.Rate = 5
ParticleEmitter.Parent = attachment
ParticleEmitter.RotSpeed = NumberRange.new(200, 250)
ParticleEmitter.Rotation = NumberRange.new(-360, 360)
ParticleEmitter.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 7),
    NumberSequenceKeypoint.new(1, 0)
})
ParticleEmitter.Speed = NumberRange.new(0, 0)
ParticleEmitter.Texture = "http://www.roblox.com/asset/?id=467188845"
ParticleEmitter.Transparency = NumberSequence.new(0, 0.43125, 0, 0.299656, 0.04375, 0, 0.874618, 0, 0, 1, 0, 0)
ParticleEmitter.ZOffset = 1
end


do
    local part = Instance.new("Part")
    part.Parent = ReplicatedStorage
    local attachment = Instance.new("Attachment")
    attachment.Name = "Attachment"
    attachment.Parent = part
    HitEffectModule.Locals.Type["Nova"] = attachment

    local function createParticleEmitter(acceleration)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "ParticleEmitter"
        emitter.Acceleration = acceleration
        emitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.495, HitEffectModule.Settings.HitEffect.Color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        emitter.Lifetime = NumberRange.new(0.5, 0.5)
        emitter.LightEmission = 1
        emitter.LockedToPart = true
        emitter.Rate = 1
        emitter.Rotation = NumberRange.new(0, 360)
        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 10),
            NumberSequenceKeypoint.new(1, 1)
        })
        emitter.Speed = NumberRange.new(0, 0)
        emitter.Texture = "rbxassetid://1084991215"
        emitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.534, 0.25),
            NumberSequenceKeypoint.new(1, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
        emitter.ZOffset = 1
        emitter.Parent = attachment
        return emitter
    end

    createParticleEmitter(Vector3.new(0, 0, 1))
    local perpendicularEmitter = createParticleEmitter(Vector3.new(0, 1, -0.001))
    perpendicularEmitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
end

HitEffectModule.Functions.Effect = function(character, color)
    if not TargetAimbot.HitEffect and character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local effectAttachment = HitEffectModule.Locals.Type[TargetAimbot.HitEffectType]:Clone()
    effectAttachment.Parent = humanoidRootPart

    for _, emitter in pairs(effectAttachment:GetChildren()) do
        if emitter:IsA("ParticleEmitter") then
            emitter.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.495, color),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
            emitter:Emit()
        end
    end

    task.delay(2, function()
        effectAttachment:Destroy()
    end)
end

local PlayHitSound = LPH_NO_VIRTUALIZE(function() 
    if TargetAimbot.HitSounds and hitsounds[TargetAimbot.HitSound] then
        local sound = Instance.new("Sound")
        sound.SoundId = hitsounds[TargetAimbot.HitSound]
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end) 



local TweenService = game:GetService("TweenService")

local  HitChams = LPH_NO_VIRTUALIZE(function(Player)
    if not TargetAimbot.HitChams then return end

    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.Archivable = true
        local Cloned = Player.Character:Clone()
        Cloned.Name = "Player Clone"

        local BodyParts = {
            "Head", "UpperTorso", "LowerTorso",
            "LeftUpperArm", "LeftLowerArm", "LeftHand",
            "RightUpperArm", "RightLowerArm", "RightHand",
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot"
        }

        for _, Part in ipairs(Cloned:GetChildren()) do
            if Part:IsA("BasePart") then
                local PartValid = false
                for _, validPart in ipairs(BodyParts) do
                    if Part.Name == validPart then
                        PartValid = true
                        break
                    end
                end
                
                if not PartValid then
                    Part:Destroy()
                end
            elseif Part:IsA("Accessory") or Part:IsA("Tool") or Part.Name == "face" or Part:IsA("Shirt") or Part:IsA("Pants") or Part:IsA("Hat") then
                Part:Destroy()
            end
        end

        if Cloned:FindFirstChild("Humanoid") then
            Cloned.Humanoid:Destroy()
        end

        for _, BodyPart in ipairs(Cloned:GetChildren()) do
            if BodyPart:IsA("BasePart") then
                BodyPart.CanCollide = false
                BodyPart.Anchored = true
                BodyPart.Transparency = TargetAimbot.HitChamsTransparency
                BodyPart.Color = TargetAimbot.HitChamsColor
                BodyPart.Material = TargetAimbot.HitChamsMaterial
            end
        end

        if Cloned:FindFirstChild("Head") then
            local Head = Cloned.Head
            Head.Transparency = TargetAimbot.HitChamsTransparency
            Head.Color = TargetAimbot.HitChamsColor
            Head.Material = TargetAimbot.HitChamsMaterial

            if Head:FindFirstChild("face") then
                Head.face:Destroy()
            end
        end

        Cloned.Parent = game.Workspace

        local tweenInfo = TweenInfo.new(
            TargetAimbot.HitChamsDuration,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            0,
            true
        )

        for _, BodyPart in ipairs(Cloned:GetChildren()) do
            if BodyPart:IsA("BasePart") then
                local tween = TweenService:Create(BodyPart, tweenInfo, { Transparency = 1 })
                tween:Play()
            end
        end

        task.delay(TargetAimbot.HitChamsDuration, function()
            if Cloned and Cloned.Parent then
                Cloned:Destroy()
            end
        end)
    end
end) 

local Client = Players.LocalPlayer
        local Mouse = Client:GetMouse()

local HitChamsSkeleton = LPH_NO_VIRTUALIZE(function(Player)
    if not TargetAimbot.HitSkele then return end

    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local bones = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "RightUpperArm"},
            {"RightUpperArm", "RightLowerArm"},
            {"RightLowerArm", "RightHand"},
            {"UpperTorso", "LeftUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"},
            {"LeftLowerArm", "LeftHand"},
            {"LowerTorso", "RightUpperLeg"},
            {"RightUpperLeg", "RightLowerLeg"},
            {"RightLowerLeg", "RightFoot"},
            {"LowerTorso", "LeftUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"}
        }

        local lines = {}

        for _, bonePair in ipairs(bones) do
            local parentBone = Player.Character:FindFirstChild(bonePair[1])
            local childBone = Player.Character:FindFirstChild(bonePair[2])

            if parentBone and childBone then
                local line = Instance.new("Part")
                line.Size = Vector3.new(0.02, 0.02, (parentBone.Position - childBone.Position).Magnitude)
                line.CFrame = CFrame.new(parentBone.Position, childBone.Position) * CFrame.new(0, 0, -line.Size.Z / 2)
                line.Anchored = true
                line.CanCollide = false
                line.Transparency = TargetAimbot.HitChamsTransparency
                line.Color = TargetAimbot.SkeleColor
                line.Material = Enum.Material.Neon
                line.Parent = workspace

                local tweenInfo = TweenInfo.new(TargetAimbot.HitChamsDuration / 0.2,  Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local tween = TweenService:Create(line, tweenInfo, {Transparency = 1})
                tween:Play()

                table.insert(lines, line)
            end
        end

        task.delay(TargetAimbot.HitChamsDuration, function()
            for _, line in ipairs(lines) do
                if line and line.Parent then
                    line:Destroy()
                end
            end
        end)
    end
end)

local targetHealth = nil

local updateTargetHealth = LPH_NO_VIRTUALIZE(function()
    if TargBindEnabled and TargetPlr and TargetPlr.Character then
        local humanoid = TargetPlr.Character:FindFirstChild("Humanoid")
        if humanoid then
            local currentHealth = humanoid.Health
            if currentHealth < targetHealth then
                local damageDealt = targetHealth - currentHealth
                local damageText = string.format("%d", math.round(damageDealt))
                local remainingValue = string.format("%d", math.max(currentHealth, 0))
                local selectedPart = tostring(Psalms.Tech.SelectedPart)

                if Hitnotify then
                    local realColor = "#" .. Library.Accent:ToHex()
                    Library:Notification(
                        '> Hit <font color="'..realColor..'">'..TargetPlr.DisplayName..'</font> on <font color="'..realColor..'">'..selectedPart..'</font> for <font color="'..realColor..'">'..damageText..'</font> ('..remainingValue..' remaining)',
                        1.5
                    )
                end
                HitEffectModule.Functions.Effect(TargetPlr.Character, TargetAimbot.HitEffectColor)
                PlayHitSound()
                HitChams(TargetPlr)
                HitChamsSkeleton(TargetPlr)
            end
            targetHealth = currentHealth
        end
    end
end)



RunService.RenderStepped:Connect(LPH_JIT(function()
    if TargetAimbot.Enabled and TargBindEnabled and TargetAimbot.Highlight and TargetPlr and TargetPlr.Character and Highlight then
        TargHighlight.FillColor = TargetAimbot.HighlightColor1
TargHighlight.OutlineColor = TargetAimbot.HighlightColor2
TargHighlight.Adornee = TargetPlr.Character
        TargHighlight.Enabled = true
    else
        TargHighlight.Adornee = nil
        TargHighlight.Enabled = false
    end
end)) 


local crosshair_position = "Middle"

local Cursor = loadstring(game:HttpGet("https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/cursor.lua",true))()
getgenv().crosshair.color = Library.Accent
    getgenv().crosshair.mode = "Middle"
    getgenv().crosshair.sticky = false
getgenv().crosshair.enabled = false
getgenv().crosshair.spin = false



RunService.PostSimulation:Connect(LPH_JIT(function()
    if getgenv().crosshair.sticky and TargetPlr and TargetPlr.Character then
        local TargetPart = TargetPlr.Character:FindFirstChild(Psalms.Tech.SelectedPart)
        if TargetPart then
            local Position = Camera:WorldToViewportPoint(TargetPart.Position)
            getgenv().crosshair.mode = 'custom'
            getgenv().crosshair.position = Vector2.new(Position.X, Position.Y)
        end
    else
        getgenv().crosshair.mode = crosshair_position
        Position = nil
        TargetPart = nil
    end
end))

local TargetFuturePosition = LPH_NO_VIRTUALIZE(function()
    local selectedPart = Psalms.Tech.SelectedPart
    local targetPart = TargetPlr.Character[selectedPart]

    if targetPart then
        local currentTick = tick()
        local currentPos = targetPart.CFrame

        local velocity = Vector3.new(0, 0, 0)
        
        if Psalms.Tech.ResolverEnabled then
            if Psalms.Tech.RESOLVER == "Recalculate" then
                if lastPos then
                    local delta = currentTick - lastTick
                    if delta > 0 then
                        local positionDifference = currentPos - lastPos
                        velocity = positionDifference / delta
                    end
                end
                lastPos = currentPos
                lastTick = currentTick
            elseif Psalms.Tech.RESOLVER == "MoveDirection" then
                velocity = TargetPlr.Character.Humanoid.MoveDirection * TargetPlr.Character.Humanoid.WalkSpeed
            elseif Psalms.Tech.RESOLVER == "LookVector" then
                velocity = targetPart.CFrame.LookVector * Psalms.Tech.HorizontalPrediction * 1.5
            end
        else
            velocity = targetPart.AssemblyLinearVelocity
        end

        local horizontalPrediction = Psalms.Tech.HorizontalPrediction
        local verticalPrediction = Psalms.Tech.VerticalPrediction
        local jumpOffset = Psalms.Tech.jumpoffset or 0

        if Psalms.Tech.UseVertical then
            return Vector3.new(
                currentPos.X + (velocity.X / horizontalPrediction),
                currentPos.Y + (velocity.Y / verticalPrediction),
                currentPos.Z + (velocity.Z / horizontalPrediction)
            ) + Vector3.new(0, Psalms.Tech.jumpoffset, 0)
        else
                       return Vector3.new(
                currentPos.X + (velocity.X * horizontalPrediction),
                currentPos.Y + (velocity.Y * verticalPrediction),
                currentPos.Z + (velocity.Z * horizontalPrediction)
            ) + Vector3.new(0, Psalms.Tech.jumpoffset, 0)
        end
    end

    return nil
end)


local NEWFrame = LPH_NO_VIRTUALIZE(function()
    local targetPosition = TargetPlr.Character.HumanoidRootPart.Position

    if TargetAimbot.CSync.Type == "Random" then
        return CFrame.new(
            targetPosition + Vector3.new(
                math.random(-TargetAimbot.CSync.RandomAmount, TargetAimbot.CSync.RandomAmount),
                math.random(0, TargetAimbot.CSync.RandomAmount),
                math.random(-TargetAimbot.CSync.RandomAmount, TargetAimbot.CSync.RandomAmount)
            )
        ) * CFrame.Angles(
            math.rad(math.random(0, 360)),
            math.rad(math.random(0, 360)),
            math.rad(math.random(0, 360))
        )
    elseif TargetAimbot.CSync.Type == "Orbit" then
        local CurrentTime = tick()
        return CFrame.new(targetPosition) *
            CFrame.Angles(0, 2 * math.pi * CurrentTime * TargetAimbot.CSync.Speed % (2 * math.pi), 0) *
            CFrame.new(0, TargetAimbot.CSync.Height, TargetAimbot.CSync.Distance)
    elseif TargetAimbot.CSync.Type == "Spiral" then
        local CurrentTime = tick()
        local angle = 2 * math.pi * CurrentTime * TargetAimbot.CSync.Speed % (2 * math.pi)
        local spiralRadius = TargetAimbot.CSync.Distance + math.sin(CurrentTime) * TargetAimbot.CSync.RandomAmount
        return CFrame.new(targetPosition) *
            CFrame.Angles(0, angle, 0) *
            CFrame.new(spiralRadius, TargetAimbot.CSync.Height, 0)
    elseif TargetAimbot.CSync.Type == "Spherical" then
        local CurrentTime = tick()
        local radius = TargetAimbot.CSync.Distance
        local sphericalX = radius * math.sin(CurrentTime) * math.cos(CurrentTime * TargetAimbot.CSync.Speed)
        local sphericalY = radius * math.sin(CurrentTime) * math.sin(CurrentTime * TargetAimbot.CSync.Speed)
        local sphericalZ = radius * math.cos(CurrentTime)
        return CFrame.new(targetPosition + Vector3.new(sphericalX, sphericalY, sphericalZ))
    elseif TargetAimbot.CSync.Type == "Attach" then
        local attach = TargetFuturePosition()
        return CFrame.new(attach)
    end
end) 



local utility = {};

local function GetBullet()
    if workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Siren") and workspace.Ignored.Siren:FindFirstChild("Radius") then
        return {
            BulletPath = workspace.Ignored.Siren.Radius,
            BulletName = "BULLET_RAYS",
            BulletBeamName = "GunBeam"
        }
    elseif workspace:FindFirstChild("Ignored")  then
        return {
            BulletPath = workspace.Ignored,
            BulletName = "BULLET_RAYS",
            BulletBeamName = "GunBeam"
        }
    elseif workspace then
        return {
            BulletPath = workspace,
            BulletName = "Part",
            BulletBeamName = "gb"
        }
    end
    return nil
end

local support = GetBullet()
local bullet_beam_name = support.BulletBeamName
local bullet_name = support.BulletName
local bullet_path = support.BulletPath

Configurations = {
    Visuals = {
        Bullet_Trails = {
            Enabled = false,
            Width = 1.0,
            Duration = 3,
            Fade = false,
            FadeDuration = 3,
            Color  = Library.Accent,
            Texture = "Electro" -- 12781803086
        }
    }
}



local BulletTexture = {
    Electro = "rbxassetid://139193109954329",
    Cool = "rbxassetid://116848240236550",
    Cum = "rbxassetid://88263664141635"
}

local utility = {}; do
utility.instance_new = function(type, properties)
        local instance = Instance.new(type);

        for property, value in properties do
            instance[property] = value;
        end;

        return instance;
    end;

    utility.new_connection = function(type, callback) --// by all means do NOT virtualize this
        local connection = type:Connect(callback)
        table.insert(connections, connection)
        return connection
    end

    utility.create_beam = LPH_NO_VIRTUALIZE(function(BulletTex, wid, from, to, color_1, color_2, duration, fade_enabled, fade_duration)
        local tween
        local total_time = 0

        local main_part = utility.instance_new("Part", {
            Parent = workspace,
            Size = Vector3.new(0, 0, 0),
            Massless = true,
            Transparency = 1,
            CanCollide = false,
            Position = from,
            Anchored = true
        })

        local part0 = utility.instance_new("Part", {
            Parent = main_part,
            Size = Vector3.new(0, 0, 0),
            Massless = true,
            Transparency = 1,
            CanCollide = false,
            Position = from,
            Anchored = true
        })

        local part1 = utility.instance_new("Part", {
            Parent = main_part,
            Size = Vector3.new(0, 0, 0),
            Massless = true,
            Transparency = 1,
            CanCollide = false,
            Position = to,
            Anchored = true
        })

        local attachment0 = utility.instance_new("Attachment", {Parent = part0})
        local attachment1 = utility.instance_new("Attachment", {Parent = part1})

        local beam = utility.instance_new("Beam", {
    Texture = BulletTex,
    TextureMode = Enum.TextureMode.Wrap,
    TextureLength = 10,
    LightEmission = 10, 
    LightInfluence = 1,
    FaceCamera = true,
    ZOffset = -1,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    }),
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color_1),
        ColorSequenceKeypoint.new(1, color_2),
    }),
    Width0 = wid, 
    Width1 = wid, 
    Attachment0 = attachment0,
    Attachment1 = attachment1,
    Enabled = true,
    Parent = main_part
})

        if fade_enabled then
            tween = utility.new_connection(RunService.Heartbeat, function(delta_time) --// credits to Xander
                total_time += delta_time
                beam.Transparency = NumberSequence.new(
                    TweenService:GetValue((total_time / fade_duration), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                )
            end)
        end

        task.delay(duration, function()
            main_part:Destroy()
            if tween then
                tween:Disconnect()
            end
        end)
    end)
end

local Utility = {}

local function SirenAdded(Obj)
        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        local function VerifyBullet(obj)
            return (obj.Name == bullet_name or obj:FindFirstChild("Attachment") or obj:FindFirstChild(bullet_beam_name)) and obj
        end

        local PlayerChecks = {PlayerGun = false}
        local BulletRay = VerifyBullet(Obj)
    
        if BulletRay and RootPart then
            local Mag = (RootPart.Position - BulletRay.Position).Magnitude
            if Mag <= 13 then PlayerChecks.PlayerGun = true end

            if PlayerChecks.PlayerGun then
                local GunBeam = BulletRay:WaitForChild(bullet_beam_name)
                
                local Attachment0 = GunBeam.Attachment0 -- closest to player
                local Attachment1 = GunBeam.Attachment1 -- mouse position


            if Configurations.Visuals.Bullet_Trails.Enabled then
                GunBeam:Destroy()
                utility.create_beam(
BulletTexture[Configurations.Visuals.Bullet_Trails.Texture],
Configurations.Visuals.Bullet_Trails.Width, 
                    BulletRay.Position,
                    Attachment1.WorldCFrame.Position,
                    Configurations.Visuals.Bullet_Trails.Color,
                    Configurations.Visuals.Bullet_Trails.Color,
                    Configurations.Visuals.Bullet_Trails.Duration,
                    Configurations.Visuals.Bullet_Trails.Fade,
                    Configurations.Visuals.Bullet_Trails.Duration
                )
            end
        end
    end
end

if bullet_path then
    bullet_path.ChildAdded:Connect(SirenAdded)
end

getgenv().esp = {
TargetOnly = false,
    AutoStep = true, -- automatically updates the esp, you can disable this and use Player:Step() if you want to manually update them
    CharacterSize = Vector3.new(4, 5.75, 1.5),
    CharacterOffset = CFrame.new(0, -0.25, 0),
    UseBoundingBox = false, -- will use bounding box instead of size preset for dynamic box

    PriorityColor = Color3.new(1,0.25,0.25),

    BoxEnabled = false,
    BoxCorners = false,
    BoxDynamic = false,
    BoxStaticXFactor = 1.3,
    BoxStaticYFactor = 1.6,
    BoxColor = Color3.fromRGB(255, 255, 255),
    
    SkeletonEnabled = false,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    SkeletonMaxDistance = 300,

    ChamsEnabled = false,
    ChamsInnerColor = Color3.fromRGB(102, 60, 153),
    ChamsOuterColor = Color3.fromRGB(0, 0, 0),
    ChamsInnerTransparency = 0.5,
    ChamsOuterTransparency = 0.5,


    TextEnabled = false,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextLayout = {
        ['nametag']  = { enabled = true, position = 'top', order = 1 },
        ['name']     = { enabled = true, position = 'top', order = 2 },
        ['health']   = { enabled = true, position = 'left', order = 1, bar = 'health' },
        ['tool']     = { enabled = true, position = 'bottom', suffix = '', prefix = '', order = 1 },
        ['distance'] = { enabled = true, position = 'bottom', suffix = 'm', order = 2 },
    },

    BarLayout = {
        ['health'] = { enabled = false, position = 'left', order = 1, color_empty = Color3.fromRGB(176, 84, 84), color_full = Color3.fromRGB(140, 250, 140) }
    }
    
}







local world_to_viewport = Camera.WorldToViewportPoint
local inf = math.huge

local skeleton_connections = {
    {'UpperTorso', 'Head', Vector3.new(0,0.4,0), Vector3.new(0,-0.2,0)},
    {'UpperTorso', 'LowerTorso', Vector3.new(0,0.4,0)},

    {'UpperTorso', 'RightUpperArm', Vector3.new(0,0.4,0)},
    {'UpperTorso', 'LeftUpperArm', Vector3.new(0,0.4,0)},
    {'RightUpperArm', 'RightHand'},
    {'LeftUpperArm', 'LeftHand'},

    {'LowerTorso', 'LeftUpperLeg'},
    {'LeftUpperLeg', 'LeftFoot'},
    {'LowerTorso', 'RightUpperLeg'},
    {'RightUpperLeg', 'RightFoot'}
}

function vector2_floor(vector2)
    return Vector2.new(math.floor(vector2.X), math.floor(vector2.Y))
end

function cframe_to_viewport(cframe, floor)
    local position, visible = world_to_viewport(Camera, cframe * (cframe - cframe.p):ToObjectSpace(Camera.CFrame - Camera.CFrame.p).p)
    if floor then
        position = vector2_floor(position)
    end
    return position, visible
end

local old; old = hookfunction(Drawing.new, function(class, properties)
    local drawing = old(class)
    for i,v in next, properties or {} do
        drawing[i] = v
    end
    return drawing
end)


getgenv().players = {}
local player = {}
player.__index = player

function player:Check()
    if getgenv().esp.TargetOnly and self.instance ~= TargetPlr then
        return false
    end
    
    local character = self.instance.Character
    local rootpart = character and character:FindFirstChild('HumanoidRootPart')
    local torso = character and character:FindFirstChild('UpperTorso')
    local humanoid = rootpart and character:FindFirstChild('Humanoid')
    if not humanoid or 0 >= humanoid.Health then
        return false
    end

    local screen_position, screen_visible = cframe_to_viewport(torso.CFrame * esp.CharacterOffset, true)

    if not screen_visible then
        return false
    end

    return true, {
        character = character,
        rootpart = rootpart,
        humanoid = humanoid,
        position = screen_position,
        cframe = rootpart.CFrame * esp.CharacterOffset,
        health = humanoid.Health,
        maxhealth = humanoid.MaxHealth,
        healthfactor = humanoid.Health / humanoid.MaxHealth,
        distance = (rootpart.CFrame.p - Camera.CFrame.p).magnitude
    }
end

function player:Step(delta)

    local check_pass, check_data = self:Check()

    self:SetVisible(false)

    if not check_pass then
        return
    else
        self.visible = true
    end
    
    local size = self:GetBoxSize(check_data.position, check_data.cframe)
local position = vector2_floor(check_data.position - size / 2)
local color = self.priority and esp.PriorityColor
local stroke_color = Color3.new(0, 0, 0)
local box_drawings = self.drawings.box

if esp.BoxEnabled and esp.BoxCorners then
    local corner_size = size.X / 3

    box_drawings[9].Position = position
    box_drawings[10].Position = position + Vector2.new(size.X - 1, 0)
    box_drawings[11].Position = position + Vector2.new(0, size.Y - corner_size)
    box_drawings[12].Position = position + Vector2.new(size.X - 1, size.Y - corner_size)

    box_drawings[13].Position = position
    box_drawings[14].Position = position + Vector2.new(size.X - corner_size, 0)
    box_drawings[15].Position = position + Vector2.new(0, size.Y - 1)
    box_drawings[16].Position = position + Vector2.new(size.X - corner_size, size.Y - 1)

    for i = 1, 8 do
        local outline = box_drawings[i]
        local inline = box_drawings[i + 8]

        inline.Visible = true
        outline.Visible = true
        inline.Filled = true
        outline.Filled = false

        inline.Color = color or (self.useboxcolor and self.boxcolor) or esp.BoxColor
        outline.Color = stroke_color

        outline.Position = inline.Position - Vector2.new(2, 2)

        if i > 4 then
            inline.Size = Vector2.new(corner_size, 1)
            outline.Size = Vector2.new(corner_size + 4, 6)
        else
            inline.Size = Vector2.new(1, corner_size)
            outline.Size = Vector2.new(6, corner_size + 4)
        end
    end


    elseif esp.BoxEnabled then
    local outline = box_drawings[1]
    local inline = box_drawings[9]

    outline.Visible = true
    outline.Size = size
    outline.Position = position
    outline.Transparency = 0.7

    inline.Visible = true
    inline.Size = size
    inline.Position = position
    inline.Color = color or (self.useboxcolor and self.boxcolor) or esp.BoxColor
    inline.Transparency = 0.7
end
   



    self.highlight.Enabled = esp.ChamsEnabled
    self.highlight.FillColor = (self.usehighlightcolor and self.highlightcolor) or esp.ChamsInnerColor
    self.highlight.FillTransparency = esp.ChamsInnerTransparency
    self.highlight.OutlineColor = (self.usehighlightcolor and self.outlinehighlightcolor) or esp.ChamsOuterColor
    self.highlight.OutlineTransparency = esp.ChamsOuterTransparency
    self.highlight.Parent = check_data.character
    self.highlight.Adornee = check_data.character

    local bar_data = self:GetBarData(check_data)
    local bar_positions = { top = 0, bottom = 0, left = 0, right = 0 }

    for idx, data in next, self.drawings.bar do
        local flag = data[1]
        local layout = data[2]
        local outline = data[3]
        local inline = data[4]
        local data = bar_data[flag]

        if not layout.enabled or data.enabled == false then
            continue
        end

        local progress = data.progress or 0
        local vertical = layout.position == 'left' or layout.position == 'right'

        outline.Visible = true
        inline.Visible = true

        outline.Size = vertical and Vector2.new(3, size.Y + 2) or Vector2.new(size.X + 2, 3)
        outline.Position = position + (
            layout.position == 'top' and Vector2.new(-1, -(5 + bar_positions.top)) or
            layout.position == 'bottom' and Vector2.new(-1, size.Y + 2 + bar_positions.bottom) or
            layout.position == 'left' and Vector2.new(-5-bar_positions.left, -1) or
            layout.position == 'right' and Vector2.new(size.X + 2 + bar_positions.right, -1)
        )

        inline.Color = layout.color_empty:lerp(layout.color_full, progress)
        inline.Size = vertical and Vector2.new(1, progress * size.Y) or Vector2.new(progress * size.X, 1)

        if vertical then
            inline.Position = outline.Position + Vector2.new(1,1 + size.Y - progress * size.Y)
        else
            inline.Position = outline.Position + Vector2.new(size.X - progress * size.X ,1)
        end

        bar_positions[layout.position] += 4

    end

    if esp.TextEnabled then
        local text_data = self:GetTextData(check_data)
        local text_positions = { top = bar_positions.top, bottom = bar_positions.bottom, left = 0, right = 0 }

        for idx, data in next, self.drawings.text do
            local flag = data[1]
            local layout = data[2]
            local drawing = data[3]
            local data = text_data[flag]

            if not layout.enabled or data.enabled == false then
                continue
            end

            drawing.Visible = true
            drawing.Text = (layout.prefix or '') .. (data.text or '') .. (layout.suffix or '')
            drawing.Color = data.color or color or layout.color or esp.TextColor

            if layout.bar then
                drawing.Position = position + (
                    layout.position == 'left' and Vector2.new(-(bar_positions.left + drawing.TextBounds.X + 2), size.Y - bar_data[layout.bar].progress * size.Y - 3) or
                    layout.position == 'right' and Vector2.new(size.X + bar_positions.right + 2, size.Y - bar_data[layout.bar].progress * size.Y -3)               
                )
            else
                drawing.Position = position + (
                    layout.position == 'top' and Vector2.new(size.X / 2, -3 - (text_positions.top + 14)) or
                    layout.position == 'bottom' and Vector2.new(size.X / 2, size.Y + text_positions.bottom + 2) or
                    layout.position == 'left' and Vector2.new(-(bar_positions.left + drawing.TextBounds.X + 2), text_positions.left - 3) or
                    layout.position == 'right' and Vector2.new(size.X + bar_positions.right + 2, size.Y + text_positions.right - 3)               
                )
    
                text_positions[layout.position] += 14
            end

        end 
    end

    if esp.SkeletonEnabled and esp.SkeletonMaxDistance > check_data.distance then

        local cache = {}

        for idx, connection_data in next, skeleton_connections do
            local drawing = self.drawings.skeleton[idx]
            local part_a = check_data.character:FindFirstChild(connection_data[1])
            local part_b = check_data.character:FindFirstChild(connection_data[2])

            if part_a and part_b then
                local screen_position_a = cache[part_a] or cframe_to_viewport(part_a.CFrame + (connection_data[3] or Vector3.new()), true)
                local screen_position_b = cache[part_b] or cframe_to_viewport(part_b.CFrame + (connection_data[4] or Vector3.new()), true)

                cache[part_a] = screen_position_a
                cache[part_b] = screen_position_b

                drawing.Visible = true
                drawing.Color = color or esp.SkeletonColor
                drawing.From = screen_position_a
                drawing.To = screen_position_b
            end
        end
    end


end

function player:GetTextData(data)
    local tool = data.character:FindFirstChildOfClass('Tool')
    return {
        ['nametag']  = { text = self.nametag_text, enabled = self.nametag_enabled, color = self.nametag_color },
        ['name']     = { text = self.instance.DisplayName },
        ['health']   = { text = tostring(math.floor(data.health)), color = esp.BarLayout.health.color_empty:lerp(esp.BarLayout.health.color_full, data.healthfactor) },
        ['distance'] = { text = tostring(math.floor(data.distance)) },
        ['tool']     = { text = tool and tool.Name, enabled = tool ~= nil }
    }
end

function player:GetBarData(data) -- progress should be a number 0-1, you can get this by doing value /  / maxarmo
    return {
        ['health'] = { progress = data.healthfactor }
    }
end

function player:GetBoxSize(position, cframe)
    if esp.BoxDynamic then
        local size = esp.CharacterSize
        
        if esp.UseBoundingBox then
            _, size = self.instance.Character:GetBoundingBox()
        end

        local x = cframe_to_viewport(cframe * CFrame.new(size.X, 0, 0))
        local y = cframe_to_viewport(cframe * CFrame.new(0, size.Y, 0))
        local z = cframe_to_viewport(cframe * CFrame.new(0, 0, size.Z))

        local SizeX = math.max(math.abs(position.X - x.X), math.abs(position.X - z.X))
        local SizeY = math.max(math.abs(position.Y - y.Y), math.abs(position.Y - x.Y))

        return Vector2.new(math.clamp(math.floor(SizeX), 3, inf), math.clamp(math.floor(SizeY), 6, inf))
    else
        local distance = (Camera.CFrame.p - cframe.p).magnitude
        local factor = 1 / ((distance / 3) * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
        return Vector2.new(math.clamp(math.floor(factor * esp.BoxStaticXFactor), 3, inf), math.clamp(math.floor(factor * esp.BoxStaticYFactor), 6, inf))
    end
end

function player:SetPriority(bool)
    self.priority = bool
end

function player:GetPriority()
    return self.priority
end

function player:SetBoxColorEnabled(bool)
    self.useboxcolor = bool
end

function player:SetBoxColor(color)
    self.boxcolor = color
end

function player:SetHighlightColorEnabled(bool)
    self.usehighlightcolor = bool
end

function player:SetHighlightColor(color, color2)
    self.highlightcolor = color
    self.outlinehighlightcolor = color2
end

function player:SetNametagText(str)
    self.nametag_text = str
end

function player:SetNametagEnabled(bool)
    self.nametag_enabled = bool
end

function player:SetNametagColor(color)
    self.nametag_color = color
end

function player:SetNametag(str, bool, color)
    self:SetNametagText(str)
    self:SetNametagEnabled(bool)
    self:SetNametagColor(color)
end

function player:SetVisible(bool)
    if self.visible ~= bool then
        self.visible = bool
        for i,v in next, self.drawings.box do v.Visible = bool end
        for i,v in next, self.drawings.skeleton do v.Visible = bool end
        for i,v in next, self.drawings.text do v[3].Visible = bool end
        for i,v in next, self.drawings.bar do v[3].Visible = bool; v[4].Visible = bool end
    end
end

-- // new player
function esp.NewPlayer(player_instance)
    if TargetModeEnabled and TargetPlr then
        player_instance = TargetPlr
    end

    local player = setmetatable({}, player)

    player.instance = player_instance
    player.priority = false
    player.useboxcolor = false
    player.nametag_enabled = false
    player.nametag_text = 'nametag'
    player.nametag_color = Color3.new(1,1,1)
    player.boxcolor = Color3.new(1,1,1)

    player.highlight = Instance.new('Highlight')
    player.drawings = {
        text = {},
        bar = {},
        skeleton = {},
        box = {}
    }

    player.remove_esp = function() 
        for i,v in next, player.drawings.box do v:Remove() end
        for i,v in next, player.drawings.skeleton do v:Remove() end
        for i,v in next, player.drawings.text do v[3]:Remove() end
        for i,v in next, player.drawings.bar do v[3]:Remove(); v[4]:Remove() end

        player.highlight:Destroy()
    end

    for i = 1, 8 do
        player.drawings.box[i] = Drawing.new('Square')
    end

    for i = 9, 16 do
        player.drawings.box[i] = Drawing.new('Square')
    end

    for i = 1, 10 do
        player.drawings.skeleton[i] = Drawing.new('Line', { Thickness = 1 })
    end

    for flag, layout in next, esp.TextLayout do
        table.insert(player.drawings.text, { 
            flag,
            layout,
            Drawing.new('Text', { Size = 13, Font = 2, Outline = true, Center = layout.position == 'top' or layout.position == 'bottom' }) 
        })
    end

    for flag, layout in next, esp.BarLayout do
        table.insert(player.drawings.bar, { 
            flag,
            layout,
            Drawing.new('Square', { Thickness = 1, Filled = true }),
            Drawing.new('Square', { Thickness = 1, Filled = true }),
        })
    end

    table.sort(player.drawings.text, function(a,b)
        return a[2].order < a[2].order
    end)

    table.sort(player.drawings.bar, function(a,b)
        return a[2].order < a[2].order
    end)

    
    table.insert(players, player)
    return player
end

-- // update
game:GetService('RunService').PreRender:Connect(function(delta)
    if esp.AutoStep then
        for i, player in next, players do
            player:Step(delta)
        end
    end
end)

for i, v in next, game.Players:GetPlayers() do
    esp.NewPlayer(v)
end

game.Players.PlayerAdded:Connect(function(new_player)
    esp.NewPlayer(new_player)
end)


local Saved, Client, Camera, nigga = nil, game.Players.LocalPlayer, workspace.CurrentCamera, {}
local IgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
local desync_setback = Instance.new("Part")
desync_setback.Name = "im a skibidi rizzler"
desync_setback.Parent = workspace
desync_setback.Size = Client.Character:WaitForChild("HumanoidRootPart").Size
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1
nigga["CFrameVisualize"] = game:GetObjects("rbxassetid://9474737816")[1]
nigga["CFrameVisualize"].Head.Face:Destroy()

for _, v in pairs(nigga["CFrameVisualize"]:GetChildren()) do
    v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70
    v.Material = "ForceField"
    v.Color = Library.Accent
    v.CanCollide = false
    v.Anchored = false
end

game:GetService('RunService').Heartbeat:Connect(LPH_JIT(function()
    if TargetAimbot.CSync.Enabled then
        nigga["CFrameVisualize"].Parent = IgnoreFolder
    else
        nigga["CFrameVisualize"].Parent = nil
    end
    
    if TargetAimbot.CSync.Enabled and TargetPlr and TargetAimbot.CSync.Visualize then
        local humanoidRootPart = Client.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local FakeCFrame = humanoidRootPart.CFrame
            Saved = humanoidRootPart.CFrame
            
            
            FakeCFrame = NEWFrame() 

            nigga["CFrameVisualize"]:SetPrimaryPartCFrame(FakeCFrame)

            for _, Part in pairs(nigga["CFrameVisualize"]:GetChildren()) do
                Part.Color = TargetAimbot.CSync.Color
            end

            humanoidRootPart.CFrame = FakeCFrame

            game:GetService("RunService").RenderStepped:Wait()

            desync_setback.Position = Saved.Position + Vector3.new(0, 1.5, 0)
            
            if TargBindEnabled then
                Camera.CameraSubject = desync_setback
            else
                Camera.CameraSubject = Client.Character:FindFirstChild("Humanoid")
            end
            humanoidRootPart.CFrame = Saved
        end
    end
end)) 



if game.PlaceId == 9825515356 or game.PlaceId == 2788229376 then
    Psalms.Tech.LockType = "Index"
else
    Psalms.Tech.LockType = "Namecall"
end

local lastPosition = nil

RunService.RenderStepped:Connect(LPH_JIT(function()

   if TargetPlr and TargetPlr.Character and 
       game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
       TargetPlr.Character:FindFirstChild("HumanoidRootPart") then

        if TargetAimbot.CSync.Enabled and not TargetAimbot.CSync.Visualize then
            local SigmaCFrame = NEWFrame()

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SigmaCFrame
            lastPosition = TargetPlr.Character.HumanoidRootPart.Position
        end
    elseif not TargetPlr and lastPosition then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastPosition)
        lastPosition = nil
    end
end)) 
   


Psalms.Tech.RESOLVER = "MoveDirection"

local lastTick = tick()
local lastPos = nil

if game.PlaceId == 9825515356 then
    local LocalFramework = LocalPlayer.PlayerGui:WaitForChild("Framework")
    local FrameworkEnvironment

    if LocalFramework then
        FrameworkEnvironment = getsenv(LocalFramework)
    end

    RunService.PostSimulation:Connect(function(DeltaTime)
        if Psalms.Tech.Enabled and Psalms.Tech.LockType == "Index" and FrameworkEnvironment and TargetPlr then
            FrameworkEnvironment._G.MOUSE_POSITION = TargetFuturePosition()
        end
    end)
else
    local Hooks = {}
    local mouse = game.Players.LocalPlayer:GetMouse()
        Hooks[1] = hookmetamethod(mouse, "__index", newcclosure(function(self, index)
            if index == "Hit" and Psalms.Tech.LockType == "Index" and Psalms.Tech.Enabled and TargetPlr and TargetPlr.Character and Psalms.Tech.SelectedPart then
                local TargetFuturePosition = TargetFuturePosition()
                if TargetFuturePosition then
                    return CFrame.new(TargetFuturePosition)
                end
            end
            return Hooks[1](self, index)
        end))
    end




local  Argumen = {"UpdateMousePos", "GetMousePos", "MousePos", "MOUSE", "MousePosUpdate", "UpdateMousePosI2", "UpdateMousePosI",  "UpdateAim"}


local Argument
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(...)
    local args = {...}
    local method = getnamecallmethod()

    if Psalms.Tech.Enabled and Psalms.Tech.LockType == "Namecall" then
        if TargetPlr and TargetPlr.Character and method == "FireServer" then
            for _, methodName in ipairs(Argumen) do
                if args[2] == methodName then
                    Argument = methodName
                    if not Psalms.Tech.AntiAimViewer then
                        args[3] = TargetFuturePosition()
                        return old(unpack(args))
                    end
                end
            end
        end
    end

    return old(...)
end)

setreadonly(mt, true)


-- Legit

for _, Value in pairs(game.ReplicatedStorage:GetChildren()) do
    if Value.Name == "MainEvent" or Value.Name == "Bullets" or 
       Value.Name == ".gg/untitledhood" or Value.Name == "Remote" or 
       Value.Name == "MAINEVENT" then
        MainEvent = Value
        break 
    end
end



local function CharAdded()
    if Character then
        Character.ChildAdded:Connect(function(tool)
            if tool:IsA("Tool") then
                tool.Activated:Connect(function()
                    if MainEvent and Argument then
                        if Psalms.Tech.Enabled and TargetPlr and TargetPlr.Character and Psalms.Tech.AntiAimViewer then
                            local AimPosition = TargetFuturePosition()
                            MainEvent:FireServer(Argument, AimPosition)
                        end
                    end
                end)
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(newchar)
    Character = newchar
    CharAdded()
end)

if LocalPlayer.Character then
    Character = LocalPlayer.Character
    CharAdded()
end

local players = game:GetService("Players")
local client = players.LocalPlayer

local AutoShoot = LPH_NO_VIRTUALIZE(function()
    if TargetPlr then
        local character = client.Character
        if character then
            if TargetPlr.Character:FindFirstChildOfClass("ForceField") then
                return
            end
            
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and tool:IsA("Tool") then
                tool:Activate()
            end
        end
    end
end)

local e = Instance.new("BillboardGui")
e.Name = "PP"
e.Size = UDim2.new(2, 0, 2, 0)
e.AlwaysOnTop = true

local img3 = Instance.new("ImageLabel", e)
img3.Name = "img3"
img3.Size = UDim2.new(0.6, 0, 0.6, 0)
img3.BackgroundTransparency = 1
img3.Image = "rbxassetid://108770683919433"
img3.ImageTransparency = 0

local adorneePart = Instance.new("Part")
adorneePart.Size = Vector3.new(0, 0, 0)
adorneePart.Anchored = true
adorneePart.Parent = workspace

e.Adornee = adorneePart
e.Parent = workspace

RunService.RenderStepped:Connect(LPH_JIT(function()
    if TargetPlr and TargetPlr.Character and Psalms.Tech.VelocityDot and TargetPlr.Character:FindFirstChild(Psalms.Tech.SelectedPart) then
        local pos = TargetFuturePosition()
        adorneePart.Transparency = 0
        adorneePart.Position = pos
        e.Enabled = true
    else
        adorneePart.Position = Vector3.new(0, 0, 0)
        adorneePart.Transparency = 1
        e.Enabled = false
    end
end)) 

local targetSigm99928 = Psalms.Tech.ShootDelay 
local targetSigmaPOBALLs = nil
local Shot2ing = false

local checkTarget = LPH_NO_VIRTUALIZE(function() 
    if TargetPlr and TargetPlr.Character then
        local humanoid = TargetPlr.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = TargetPlr.Character:FindFirstChild("HumanoidRootPart")

        if humanoid and humanoidRootPart then
            local SigmaAir = humanoid:GetState() == Enum.HumanoidStateType.Freefall

            if SigmaAir and Psalms.Tech.AutoAir then
                if not targetSigmaPOBALLs then
                    targetSigmaPOBALLs = tick()
                else
                    local airDuration = tick() - targetSigmaPOBALLs
                    if airDuration >= targetSigm99928 then
                        if not Shot2ing then
                            Shot2ing = true
                            while TargetPlr and TargetPlr.Character and SigmaAir do
                                AutoShoot()
                                task.wait(0.00001)

                                SigmaAir = humanoid:GetState() == Enum.HumanoidStateType.Freefall

                                if not SigmaAir then
                                    Shot2ing = false
                                    targetSigmaPOBALLs = nil
                                    break
                                end
                            end
                            Shot2ing = false
                        end
                    end
                end
            else
                targetSigmaPOBALLs = nil
                Shot2ing = false
            end
        end
    end
end)




local function isPlayerOnSameTeam(player)
    if not player.Team or not LocalPlayer.Team then
        return false
    end

    return player.Team == LocalPlayer.Team
end

local function BehindWall(player)
    if not player or player == game.Players.LocalPlayer or not player.Character then
        return true
    end

    local targetPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then
        return true
    end

    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = (targetPart.Position - origin).unit * (targetPart.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function isPlayerKO(player)
    if not player.Character then
        return false
    end

    local bodyEffects = player.Character:FindFirstChild("BodyEffects")
    if bodyEffects then
        local KO = bodyEffects:FindFirstChild("K.O")
        if KO and KO:IsA("BoolValue") and KO.Value then
            return true
        end
    end

    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and  humanoidRootPart.Anchored then
        return true
    end

    return false
end

local function isPlayerSeated(player)
    if not player.Character then
        return false
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        return true
    end

    return false
end

local predictionTable =  {
    {20, 0.08960952},
    {30, 0.11252476},
    {50, 0.13544},
    {65, 0.1264236},
    {70, 0.12533},
    {80, 0.139340},
    {100, 0.141987},
    {110, 0.144634},
    {120, 0.147281},
    {130, 0.149928},
    {140, 0.152575},
    {150, 0.155222},
    {160, 0.157869},
    {170, 0.160516},
    {180, 0.163163},
    {190, 0.165810},
    {200, 0.168457},
    {210, 0.171104},
    {220, 0.173751},
    {230, 0.176398},
    {240, 0.179045},
    {250, 0.181692},
    {260, 0.184339},
    {270, 0.186986},
    {280, 0.189633},
    {290, 0.192280},
    {300, 0.194927}
}

local sigma_table = {
    {0, 0.04070},
    {30, 0.05078}
}



local calculate = LPH_NO_VIRTUALIZE(function(Ping)
    return (Ping / 1000) + 0.037
end)

local updatePredictionValue = LPH_NO_VIRTUALIZE(function() 
    local pg = tonumber(string.split(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(), '(')[1])
    
    local function fiCl(tb)
        local clVa, clDi = nil, math.huge
        for _, en in ipairs(tb) do
            local di = math.abs(pg - en[1])
            if di < clDi then clDi, clVa = di, en[2] end
        end
        return clVa
    end

    if Psalms.Tech.CamAutoprediction then
        local clVa = fiCl(sigma_table)
        if clVa then
            Psalms.Tech.CamPrediction1, Psalms.Tech.CamPrediction2 = clVa, clVa
        end
    end

    if pg and Psalms.Tech.AutoPrediction then
        local mo, clVa = Psalms.Tech.APMODE
        if mo == "Default" or mo == "Sets Based" then
            clVa = fiCl(mo == "Sets Based" and predictionTable or sigma_table)
            if clVa then
                Psalms.Tech.HorizontalPrediction, Psalms.Tech.VerticalPrediction = clVa, clVa * (mo == "Sets Based" and 0.910 or 1)
            end
        elseif mo == "Math Based" then
            local function gePr(fa, ad) 
    return fa * math.log(pg + 1) + ad 
end
Psalms.Tech.HorizontalPrediction = gePr(0.105, -0.342665)
Psalms.Tech.VerticalPrediction = gePr(0.1, -0.3405)
        elseif mo == "Calculate" then
            local calcValue = calculate(pg)
            Psalms.Tech.HorizontalPrediction, Psalms.Tech.VerticalPrediction = calcValue, calcValue
        end
    end
end)

local  LookAtPlayer = LPH_NO_VIRTUALIZE(function(tg)
    local lc = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local lrp, lh = lc:FindFirstChild("HumanoidRootPart"), lc:FindFirstChildOfClass("Humanoid")

    if lh and lrp then
        if Psalms.Tech and Psalms.Tech.LookAt and not Psalms.Tech.Macroing then
            if tg and tg.Character then
                local trp, th = tg.Character:FindFirstChild("HumanoidRootPart"), tg.Character:FindFirstChildOfClass("Humanoid")

                if th and trp then
                    local lp, tp = lrp.Position, trp.Position
                    local dir = Vector3.new(tp.X - lp.X, 0, tp.Z - lp.Z).unit

                    lrp.CFrame = CFrame.new(lp, lp + dir)
                    lh.AutoRotate = false
                end
            end
        else
            lh.AutoRotate = true
        end
    elseif lc:FindFirstChild("Humanoid") then
        lc.Humanoid.AutoRotate = true
    end
end) 

local ViewTarget = LPH_NO_VIRTUALIZE(function()
    if TargetPlr and TargetPlr.Character and Psalms.Tech.ViewAt then
        Camera.CameraSubject = TargetPlr.Character.Humanoid
    elseif not TargetAimbot.CSync.Visualize and not TargetPlr and not  Psalms.Tech.ViewAt and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end) 


local inAir = LPH_NO_VIRTUALIZE(function()
    if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
        local state = TargetPlr.Character.Humanoid:GetState()

        if state == Enum.HumanoidStateType.Freefall then
            Psalms.Tech.jumpoffset = Psalms.Tech.jumpoffset3
                Psalms.Tech.SelectedPart = Psalms.Tech.AirPart
        elseif state == Enum.HumanoidStateType.Jumping then
            Psalms.Tech.jumpoffset = Psalms.Tech.jumpoffset2
        else
            Psalms.Tech.SelectedPart = Psalms.Tech.RealPart
            Psalms.Tech.jumpoffset = 0
        end
    end
end)



local function autospam()
    if Psalms.Tech.AutoShoot and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
        if  not TargetPlr.Character:FindFirstChildOfClass("ForceField") then
            LocalPlayer.Character:FindFirstChildOfClass("Tool"):Activate()
        end
    end
end

function shoott() 
    if LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
        LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):Activate()
    end
end




RunService.Stepped:Connect(LPH_JIT(function()
    checkTarget()
    updateTargetHealth()
updatePredictionValue()
autospam()
LookAtPlayer(TargetPlr)
  inAir()
 ViewTarget()
end))





local Lighting = game:GetService("Lighting")

local originalSettings = {
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ExposureCompensation = Lighting.ExposureCompensation,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ShadowSoftness = Lighting.ShadowSoftness
}

local Environment = {
    Settings = {
        Exposure = 0,
        ClockTime = 1,
        FogColor = Color3.fromRGB(0, 0, 255),
        FogStart = 0,
        FogEnd = 300,
        Ambient = Color3.fromRGB(0, 0, 255),
        Brightness = 0,
        Enabled = false,
        ColorShift_Bottom = Color3.fromRGB(0, 0, 50),
        ColorShift_Top = Color3.fromRGB(50, 50, 150),
        GlobalShadows = true,
        OutdoorAmbient = Color3.fromRGB(60, 60, 100),
        ShadowSoftness = 0.7, 
FogEnabled = false
    }
}

local function UpdateWorld()
    if Environment.Settings.Enabled then
        Lighting.Ambient = Environment.Settings.Ambient
        Lighting.Brightness = Environment.Settings.Brightness
        Lighting.ClockTime = Environment.Settings.ClockTime
        Lighting.ExposureCompensation = Environment.Settings.Exposure
        Lighting.ColorShift_Bottom = Environment.Settings.ColorShift_Bottom
        Lighting.ColorShift_Top = Environment.Settings.ColorShift_Top
        Lighting.GlobalShadows = Environment.Settings.GlobalShadows
        Lighting.OutdoorAmbient = Environment.Settings.OutdoorAmbient
        Lighting.ShadowSoftness = Environment.Settings.ShadowSoftness
    else
        Lighting.Ambient = originalSettings.Ambient
        Lighting.Brightness = originalSettings.Brightness
        Lighting.ClockTime = originalSettings.ClockTime
        Lighting.ExposureCompensation = originalSettings.ExposureCompensation
        Lighting.ColorShift_Bottom = originalSettings.ColorShift_Bottom
        Lighting.ColorShift_Top = originalSettings.ColorShift_Top
        Lighting.GlobalShadows = originalSettings.GlobalShadows
        Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
        Lighting.ShadowSoftness = originalSettings.ShadowSoftness
    end
end

local function fogmaker()
    if Environment.Settings.FogEnabled then
        Lighting.FogColor = Environment.Settings.FogColor
        Lighting.FogStart = Environment.Settings.FogStart
        Lighting.FogEnd = Environment.Settings.FogEnd
    else
        Lighting.FogColor = originalSettings.FogColor
        Lighting.FogStart = originalSettings.FogStart
        Lighting.FogEnd = originalSettings.FogEnd
    end
end
print("gay gay gaysexx.com")

 Recalculate = function(Character)
    local Pos = Character.HumanoidRootPart.Position
    local Tick = tick()

    task.wait(0.1)

    local NewPos = Character.HumanoidRootPart.Position
    local NewTick = tick()

    local Delta = (NewTick - Tick)
    local PositionDifference = (NewPos - Pos)
    local Velocity = PositionDifference / Delta

    Pos = NewPos
    Tick = NewTick
    return Velocity
end



RunService.Heartbeat:Connect(LPH_JIT(function()
    if Psalms.Tech.Camera and TargetPlr and TargetPlr.Character and Psalms.Tech.SelectedPart then
        if TargetPlr.Character[Psalms.Tech.SelectedPart] then



            Psalms.Tech.velocity = Psalms.Tech.CamResolverEnabled 
                and Recalculate(TargetPlr.Character) 
                or TargetPlr.Character[Psalms.Tech.SelectedPart].AssemblyLinearVelocity

            Psalms.Tech.targetPosition = Psalms.Tech.UseExternal 
                and Vector3.new(
                    TargetPlr.Character[Psalms.Tech.SelectedPart].Position.X + (Psalms.Tech.velocity.X / Psalms.Tech.CamPrediction1),
                    TargetPlr.Character[Psalms.Tech.SelectedPart].Position.Y + (Psalms.Tech.velocity.Y / Psalms.Tech.CamPrediction2),
                    TargetPlr.Character[Psalms.Tech.SelectedPart].Position.Z + (Psalms.Tech.velocity.Z / Psalms.Tech.CamPrediction1)
                )
                or Vector3.new(
                    TargetPlr.Character[Psalms.Tech.SelectedPart].Position.X + (Psalms.Tech.velocity.X * Psalms.Tech.CamPrediction1),
                    TargetPlr.Character[Psalms.Tech.SelectedPart].Position.Y + (Psalms.Tech.velocity.Y * Psalms.Tech.CamPrediction2),
                    TargetPlr.Character[Psalms.Tech.SelectedPart].Position.Z + (Psalms.Tech.velocity.Z * Psalms.Tech.CamPrediction1)
                )

if Psalms.Tech.CamWallCheck and BehindWall(TargetPlr) then
                return
            end

            if Psalms.Tech.CAMKo and isPlayerKO(TargetPlr) then
                return
            end

            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, Psalms.Tech.targetPosition), 
                Psalms.Tech.smoothness or 0.1, 
                Enum.EasingStyle[Psalms.Tech.easingStyle], 
                Enum.EasingDirection[Psalms.Tech.easingDirection]
            )
        end
    end
end))

LocalPlayer.Character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
    if Psalms.Tech.JumpBreak and new == Enum.HumanoidStateType.Freefall then
        task.wait(0.17)
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, -15, 0)
    end
end) 



local Desync = false
local AntiLockType = "Zero"
local Direction = Vector3.new(0, 0, -1)

local Xmin, XMax = -10000, 10000
local Ymin, YMax = -10000, 10000
local Zmin, ZMax = -10000, 10000

game:GetService("RunService").heartbeat:Connect(LPH_JIT(function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if game.Players.LocalPlayer.Character and Desync then
        local originalVelocity = hrp.Velocity

        if AntiLockType == "Behind" then
            Direction = Vector3.new(0, 0, -1)
        elseif AntiLockType == "Down" then
            Direction = Vector3.new(0, -1, 0)
        elseif AntiLockType == "Forward" then
            Direction = Vector3.new(0, 0, 1)
        elseif AntiLockType == "Left" then
            Direction = Vector3.new(-1, 0, 0)
        elseif AntiLockType == "One" then
            Direction = Vector3.new(1, 1, 1)
        elseif AntiLockType == "Right" then
            Direction = Vector3.new(1, 0, 0)
        elseif AntiLockType == "Up" then
            Direction = Vector3.new(0, 1, 0)
        elseif AntiLockType == "Zero" then
            Direction = Vector3.new(0, 0, 0)
        elseif AntiLockType == "Shake" then
            hrp.Velocity = Vector3.new(math.random(Xmin, XMax), math.random(Ymin, YMax), math.random(Zmin, ZMax))
            game:GetService("RunService").RenderStepped:Wait()
            hrp.Velocity = originalVelocity
            return
        elseif AntiLockType == "Multiply" then
            hrp.Velocity = originalVelocity * 2
            game:GetService("RunService").RenderStepped:Wait()
            hrp.Velocity = originalVelocity
            return
        end

        hrp.Velocity = Direction * (2^16)
        game:GetService("RunService").RenderStepped:Wait()
        hrp.Velocity = originalVelocity
    end
end))

RunService.PostSimulation:Connect(function()

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if desyncsleep then
            Sleeping = not Sleeping
            setfflag("S2PhysicsSenderRate", 2)
            sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", Sleeping)
        else
            Sleeping = false
            setfflag("S2PhysicsSenderRate", 13)
            sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", Sleeping)
        end
    end
end)





local cframe_to_offset = function(origin, target)
    local actual_origin = origin * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
    return actual_origin:ToObjectSpace(target):inverse()
end

bool_at_tp_tool = function(tool)
    local old_grip = tool.Grip
    if TargetPlr and TargetPlr.Character then
        tool.Parent = LocalPlayer.Backpack
        LocalPlayer.Character.RightHand.Anchored = false
        tool.Grip = cframe_to_offset(LocalPlayer.Character.RightHand.CFrame, TargetPlr.Character.HumanoidRootPart.CFrame)
        LocalPlayer.Character.RightHand.Anchored = true
        tool.Parent = LocalPlayer.Character
        RunService.RenderStepped:Wait()
        tool.Parent = LocalPlayer.Backpack
        LocalPlayer.Character.RightHand.Anchored = false
        tool.Grip = old_grip
        tool.Parent = LocalPlayer.Character
    end
end

local connection

local tool_activated = function(character)
    character.ChildAdded:Connect(function(child)
        if Psalms.Tech.bool_at_tp then
            if child:IsA("Tool") then
                connection = child.Activated:Connect(function()
                    bool_at_tp_tool(child)
                end)
            end
        end
    end)

    character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            if connection then
                connection:Disconnect()
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(new_character)
    tool_activated(new_character)
end)

tool_activated(LocalPlayer.Character)


RunService.Heartbeat:Connect(LPH_JIT(function()
   updateBreatheEffect()

 if Psalms.Tech.cframespeedtoggle and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
        local moveDirection = game.Players.LocalPlayer.Character.Humanoid.MoveDirection
        
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * (Psalms.Tech.speedvalue / 0.5)
    end
end)) 

GetClosestToMouse = function()
            local TargetPlr, Closest = nil, math.huge

            for _, v in pairs(Players:GetPlayers()) do
                if (v ~= Client and v.Character and v.Character:FindFirstChild("HumanoidRootPart")) then
                    local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                    if (Distance < Closest and OnScreen) then
                        Closest = Distance
                        TargetPlr = v
                    end
                end
            end
            return TargetPlr
        end

local skyboxEnabled = false
local skyboxType = 1

function changeSkybox()
    if skyboxEnabled then
        if skyboxType == 1 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=1279987105"
        elseif skyboxType == 2 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=2571711090"
        elseif skyboxType == 3 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "rbxassetid://6277563515"
            Lighting.Sky.SkyboxDn = "rbxassetid://6277565742"
            Lighting.Sky.SkyboxFt = "rbxassetid://6277567481"
            Lighting.Sky.SkyboxLf = "rbxassetid://6277569562"
            Lighting.Sky.SkyboxRt = "rbxassetid://6277583250"
            Lighting.Sky.SkyboxUp = "rbxassetid://6277586065"
        elseif skyboxType == 4 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "rbxassetid://6285719338"
            Lighting.Sky.SkyboxDn = "rbxassetid://6285721078"
            Lighting.Sky.SkyboxFt = "rbxassetid://6285722964"
            Lighting.Sky.SkyboxLf = "rbxassetid://6285724682"
            Lighting.Sky.SkyboxRt = "rbxassetid://6285726335"
            Lighting.Sky.SkyboxUp = "rbxassetid://6285730635"
        elseif skyboxType == 5 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "rbxassetid://877168885"
            Lighting.Sky.SkyboxDn = "rbxassetid://877169070"
            Lighting.Sky.SkyboxFt = "rbxassetid://877169154"
            Lighting.Sky.SkyboxLf = "rbxassetid://877169233"
            Lighting.Sky.SkyboxRt = "rbxassetid://877169317"
            Lighting.Sky.SkyboxUp = "rbxassetid://877169431"
        elseif skyboxType == 6 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=9971120429"
        elseif skyboxType == 7 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=8754359769"

        end
    end
end


local howmany = 0
local MakeButton = LPH_NO_VIRTUALIZE(function(ButtonName, Color, callback)
    howmany = howmany + 1

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame")
    local TextButton = Instance.new("ImageLabel")
    local TextLabel = Instance.new("TextButton")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.3
    Frame.Position = UDim2.new(1, -150, 0, (howmany - 1) * 60)
    Frame.Size = UDim2.new(0, 120, 0, 40)

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Parent = Frame
    uiStroke.Color = Color
    uiStroke.Thickness = 1.2
    uiStroke.Transparency = 0

    TextButton.Parent = Frame
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.new(0, 28, 0, 28)
    TextButton.AnchorPoint = Vector2.new(0, 0.5)
    TextButton.Position = UDim2.new(0.05, 0, 0.5, 0)
    TextButton.Image = "rbxassetid://10734923214"
    TextButton.ImageColor3 = Color

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0, 80, 0, 28)
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.new(0.65, 0, 0.5, 0)
    TextLabel.Font = Enum.Font.Arimo
    TextLabel.Text = ButtonName
    TextLabel.TextColor3 = Color
    TextLabel.TextScaled = true
    TextLabel.TextSize = 25
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextStrokeTransparency = 1

    local uiCorner = Instance.new("UICorner", Frame)
    uiCorner.CornerRadius = UDim.new(0, 8)

    local buttonState = false

    TextLabel.MouseButton1Down:Connect(function()
        buttonState = not buttonState
        callback(buttonState)

        if buttonState then
            TextButton.Image = "rbxassetid://10735024209"
        else
            TextButton.Image = "rbxassetid://10734923214"
        end
    end)

    local dragStart, startPos
    TextLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragStart = nil
                end
            end)
        end
    end)

    TextLabel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStart then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    UITextSizeConstraint.Parent = TextLabel
    UITextSizeConstraint.MaxTextSize = 25
end)






-------

--------
local ScreenGui, Frame, gradient, UICorner, UIStroke, ballsarelife = Instance.new("ScreenGui"), Instance.new("Frame"), Instance.new("UIGradient"), Instance.new("UICorner"), Instance.new("UIStroke"), Color3.fromRGB(255, 255, 255)


ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
----------


local sama_sama_sama, whattheskibidi, mode, coluhhh, coluhhh2, HuhDrawing = false, 0.6, "Center", Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 255), 125

----------
Frame.Parent = ScreenGui
Frame.Visible = sama_sama_sama
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = whattheskibidi
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Frame

UIStroke.Thickness = 1.3
UIStroke.Color = ballsarelife
UIStroke.Parent = Frame

gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, coluhhh),
    ColorSequenceKeypoint.new(1, coluhhh2)
}
gradient.Parent = Frame

local function UpdateStrokeColor()
    local color1 = gradient.Color.Keypoints[1].Value
    UIStroke.Color = Color3.new(color1.R, color1.G, color1.B)
end


local viewportSize = Camera.ViewportSize

local function UpdateFrameSize(fovRadius)
    Frame.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
    Frame.Position = UDim2.new(0.5, -fovRadius, 0.5, -fovRadius)
end

local fovRadius = 125
UpdateFrameSize(fovRadius)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

mouse.Move:Connect(function()
    if mouse and mode == "Mouse" then
        Frame.Position = UDim2.new(0, mouse.X - Frame.Size.X.Offset / 2, 0, mouse.Y - Frame.Size.Y.Offset / 2)
    else
        Frame.Position = UDim2.new(0.5, -Frame.Size.X.Offset / 2, 0.5, -Frame.Size.Y.Offset / 2)
    end
end)

local RotateThisDick = 4

spawn(function()
    while true do
        gradient.Rotation = gradient.Rotation + RotateThisDick
        UpdateStrokeColor()
        task.wait(0.01)
    end
end)







local function findClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, Plr in ipairs(Players:GetPlayers()) do
        if Plr == Players.LocalPlayer or not Plr.Character or not Plr.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end

if Psalms.Tech.FriendCheck and player:IsFriendsWith(Plr.UserId) then
                continue
            end

if Psalms.Tech.TeamCheck and isPlayerOnSameTeam(Plr) then
    continue
end

            if Psalms.Tech.KOCheck and isPlayerKO(Plr) then
                continue
            end

            if Psalms.Tech.SeatedCheck and isPlayerSeated(Plr) then
                continue
            end

            if Psalms.Tech.WallCheck and BehindWall(Plr) then
                continue
            end

        local targetPart = Plr.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen and (not WallCheck or not BehindWall(Plr)) then
                local distanceToCenter = (Vector2.new(
                    Frame.AbsolutePosition.X + Frame.AbsoluteSize.X / 2,
                    Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y / 2
                ) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                if distanceToCenter < closestDistance and distanceToCenter <= fovRadius then
                    closestPlayer = Plr
                    closestDistance = distanceToCenter
                end
            end
        end
    end

    return closestPlayer
end

RunService.Heartbeat:Connect(LPH_JIT(function()
    if Psalms.Tech.SilentMode then
        TargetPlr = findClosestPlayer()
        if TargetPlr and TargetPlr.Character then
            local playerHumanoid = TargetPlr.Character:FindFirstChild("Humanoid")
            if playerHumanoid then
                targetHealth = playerHumanoid.Health
            end
        end
    end

   if Flick and TargetPlr and TargetPlr.Character then
    local playerHumanoid = TargetPlr.Character:FindFirstChild("Humanoid")
    if playerHumanoid and playerHumanoid.Health > 0 then
        local targetPart = TargetPlr.Character:FindFirstChild("UpperTorso")
        if targetPart and playerHumanoid:GetState() == Enum.HumanoidStateType.Freefall then

            local targetPosition = TargetFuturePosition()


            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPosition)
        end
    end
end 
end))







local guh = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local dick = os.date("%Y-%m-%d")



local role = "KHEN"
if LocalPlayer.Name == "GameLuaNhau" then
  role = "BurritoCat"
elseif LocalPlayer.Name == "GameLuaNhau" then
  role = "Taco"
end

local RealColor = "#" .. Library.Accent:ToHex()

local Window = Library:Window({
    Name = 'Psalms.<font color="'..RealColor..'">Tech</font> | '..guh..' | '..dick..' | <font color="'..RealColor..'">'..role..'</font>',
    Amount = 4
})






local Watermark = Library:Watermark({Name = string.format("Psalms.Tech")})






local stats = {
    fpsHighest = 0,
    fpsLowest = math.huge,
    pingTotal = 0,
    pingCount = 0,
    gameStartTime = tick(),
    Update = false
}

RunService.RenderStepped:Connect(function(frametime)
    if not stats.Update then return end
    
    local fps = math.floor(1 / frametime)
    stats.fpsHighest = math.max(stats.fpsHighest, fps)
    stats.fpsLowest = math.min(stats.fpsLowest, fps)

    local ping = 0
    local pingData = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
    if pingData then
        local pingStr = pingData:GetValueString()
        ping = tonumber(string.split(pingStr, '(')[1]) or 0
    end
    stats.pingTotal = stats.pingTotal + ping
    stats.pingCount = stats.pingCount + 1
    local pingAverage = math.floor(stats.pingTotal / stats.pingCount)

    local memory = math.floor(Stats:GetTotalMemoryUsageMb()) .. "MB"
    local currentTime = os.date("%I:%M:%S %p")
    local uptime = math.floor(tick() - stats.gameStartTime)

    local fpsColor = "<font color='rgb(0, 255, 0)'>" .. fps .. "</font>"
    if fps < 20 then
        fpsColor = "<font color='rgb(255, 0, 0)'>" .. fps .. "</font>"
    elseif fps < 40 then
        fpsColor = "<font color='rgb(255, 165, 0)'>" .. fps .. "</font>"
    end

    local pingColor
    if ping < 105 then
        pingColor = "<font color='rgb(0, 255, 0)'>" .. ping .. "ms</font>"
    elseif ping >= 105 and ping < 170 then
        pingColor = "<font color='rgb(255, 165, 0)'>" .. ping .. "ms</font>"
    else
        pingColor = "<font color='rgb(255, 0, 0)'>" .. ping .. "ms</font>"
    end

    
    local targetName = (TargetPlr and TargetPlr.DisplayName) or "None"

    if stats.Update then
        Watermark:UpdateText(
            "FPS: " .. fpsColor ..
            " | Highest FPS: " .. stats.fpsHighest ..
            " | Lowest FPS: " .. stats.fpsLowest ..
            " | Ping: " .. pingColor ..
            " | Memory: " .. memory ..
            " | Uptime: " .. uptime .. "s" ..
            " | Current Time: " .. currentTime ..
            " | Target: " .. targetName
        )
    end
end)

local Page = Window:Page({Name = "Main", Weapons = true})
local Sat = Window:Page({Name = "Rage", Weapons = true})
local Visual = Window:Page({Name = "Visuals", Weapons = true})
local Settings = Window:Page({Name = "Settings"})


--
local SubPage1 = Page:Weapon({Icon = "rbxassetid://78117064682304"})
local SubPage2 = Page:Weapon({Icon = "rbxassetid://120304994615919"})
local SubPage3 = Page:Weapon({Icon = "rbxassetid://77469221937135"})
local SubPage4 = Page:Weapon({Icon = "rbxassetid://128385756502234"})
local SubPage7 = Visual:Weapon({Icon = "rbxassetid://73968584177310"})
local SubPage5 = Visual:Weapon({Icon = "rbxassetid://114736089502081"})
local SubPage6 = Sat:Weapon({Icon = "rbxassetid://119314170974601"})

local TargetAimSection = SubPage1:Section({Name = "Silent/Target", Side = "Left"})
TargetAimSection:Toggle({
    Name = "Enabled",
Flag = "Lock",
    Callback = function(a)
        Psalms.Tech.Enabled = a
    end
})

TargetAimSection:Toggle({
    Name = "Look At",
Flag = "LookAt",
    Callback = function(a)
        Psalms.Tech.LookAt = a 
    end
})

TargetAimSection:Toggle({
    Name = "View",
    Callback = function(a)
        Psalms.Tech.ViewAt = a 
    end
})

TargetAimSection:Toggle({
    Name = "Anti Aim Viewer",
Flag = "Anti Aim Viewer",
    Callback = function(a)
        Psalms.Tech.AntiAimViewer  = a
    end
})
TargetAimSection:Toggle({
    Name = "Auto Air",
Flag = "Auto Air",
    Callback = function(a)
        Psalms.Tech.AutoAir = a
    end
})
TargetAimSection:Textbox({
    Name = "Auto Air Delay",
Flag = "Auto Air Delay",
  Default = tostring(Psalms.Tech.ShootDelay),
    Callback = function(a)
        targetSigm99928  = tonumber(a)
    end
})

TargetAimSection:List({
    Name = "Lock Method",
Flag = "Locking Method",
    Options = {
        "Index", 
        "Namecall"
    },
    Default = Psalms.Tech.LockType,
    Callback = function(a)
        Psalms.Tech.LockType = a
    end
})

local BulletHaha = SubPage1:Section({Name = "Gun Modification", Side = "Left"})

BulletHaha:Toggle({
    Name = "Bullet TP",
    Callback = function(a)
        Psalms.Tech.bool_at_tp = a
    end
})

local idiotdelay = 0


BulletHaha:Toggle({
    Name = "Rapid Fire",
    Flag = "HoodCustom Fire Rate",
    Callback = function(a)
        Noobidiot = a
        while Noobidiot do
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            for _, tool in pairs(character:GetChildren()) do
                if tool:FindFirstChild("GunData") then
                    local gun_find = tool:FindFirstChild("GunData")

                    if gun_find and gun_find:IsA("ModuleScript") then
                        local Gun_Data = require(gun_find)

                        if Gun_Data.cooldown and Gun_Data.slowdown_time then
                            Gun_Data.cooldown = idiotdelay
                            Gun_Data.slowdown_time = 1
                        end
                    end
                end
            end
            task.wait(1)
        end
    end
})



BulletHaha:Textbox({
    Name = "Rapid Fire Delay",
Flag = "HoodCustomGunDelay",
  Default = tostring(idiotdelay),
    Callback = function(a)
        idiotdelay  = tonumber(a)
    end
})

local HitPartSection = SubPage1:Section({Name = "Hit Part", Side = "Left"})
HitPartSection:List({
    Name = "BodyPart",
Flag = "HitPart",
    Options = {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
        "LeftUpperArm", "LeftLowerArm", "LeftHand", 
        "RightUpperArm", "RightLowerArm", "RightHand", 
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    },
    Default = "HumanoidRootPart",
    Callback = function(a)
        Psalms.Tech.RealPart = a
    end
})
HitPartSection:List({
    Name = "AirPart",
Flag = "AirPart",
    Options = {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", 
        "LeftUpperArm", "LeftLowerArm", "LeftHand", 
        "RightUpperArm", "RightLowerArm", "RightHand", 
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", 
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    },
    Default = "RightFoot",
    Callback = function(a)
        Psalms.Tech.AirPart = a
    end
})

local PredictionSection = SubPage1:Section({Name = "Calculation", Side = "Right"})
PredictionSection:Toggle({
    Name = "Division",
Flag = "DivisionTarget",
    Default = false,
    Callback = function(a)
        Psalms.Tech.UseVertical = a
    end
})



PredictionSection:Textbox({
    Name = "Horizontal Prediction (X)",
Flag = "Horizontal Prediction X",
    Default = 0.1,
    Callback = function(a)
        Psalms.Tech.HorizontalPrediction2 = tonumber(a) or 0.1
task.wait(0.01)
Psalms.Tech.HorizontalPrediction = Psalms.Tech.HorizontalPrediction2
    Psalms.Tech.VerticalPrediction = Psalms.Tech.VerticalPrediction2
    end
})
PredictionSection:Textbox({
    Name = "Vertical Prediction (Y)",
Flag = "Vertical Prediction Y",
    Default = 0.1,
    Callback = function(a)
        Psalms.Tech.VerticalPrediction2 = tonumber(a) or 0.1
task.wait(0.01)
Psalms.Tech.HorizontalPrediction = Psalms.Tech.HorizontalPrediction2
    Psalms.Tech.VerticalPrediction = Psalms.Tech.VerticalPrediction2
    end
})
PredictionSection:Textbox({
    Name = "Jump offset",
Flag = "JumpOffset",
    Default = Psalms.Tech.jumpoffset2,
    Callback = function(a)
        Psalms.Tech.jumpoffset2 = tonumber(a)
    end
})
PredictionSection:Textbox({
    Name = "Fall offset",
Flag = "FallOffset",
    Default = Psalms.Tech.jumpoffset3,
    Callback = function(a)
        Psalms.Tech.jumpoffset3 = tonumber(a)
    end
})
PredictionSection:Toggle({
    Name = "Visualize",
Flag = "Visualize",
    Callback = function(a)
        Psalms.Tech.VelocityDot = a
    end
}) 

PredictionSection:Toggle({
    Name = "Resolver",
Flag = "Target Resolver",
    Callback = function(a)
        Psalms.Tech.ResolverEnabled = a
    end
})


PredictionSection:Toggle({
    Name = "Auto Prediction",
Flag = "Target Auto Prediction",
    Callback = function(a)
        Psalms.Tech.AutoPrediction = a
     Psalms.Tech.HorizontalPrediction = Psalms.Tech.HorizontalPrediction2
    Psalms.Tech.VerticalPrediction = Psalms.Tech.VerticalPrediction2
    end
})
PredictionSection:List({
    Name = "Auto Prediction Mode",
Flag = "Auto Prediction Mode",
    Options = {
         "Default",
        "Math Based", 
        "Sets Based",
        "Calculate"
    },
    Default = Psalms.Tech.APMODE,
    Callback = function(a)
        Psalms.Tech.APMODE = a
    end
})
PredictionSection:List({
    Name = "Resolver Method",
Flag = "Resolver Method",
    Options = {
        "Recalculate", 
        "MoveDirection",
        "LookVector"
    },
    Default = "MoveDirection",
    Callback = function(a)
        Psalms.Tech.RESOLVER  = a
    end
})

local Checks = SubPage1:Section({Name = "Checks", Side = "Right"})

Checks:Toggle({
    Name = "KnockOut",
Flag = "KO",
    Callback = function(a)
        Psalms.Tech.KOCheck = a
    end
})

Checks:Toggle({
    Name = "Wall",
Flag = "Wall",
    Callback = function(a)
        Psalms.Tech.WallCheck = a
    end
})

Checks:Toggle({
    Name = "Friend",
Flag = "Friend",
    Callback = function(a)
        Psalms.Tech.FriendCheck  = a
    end
})

Checks:Toggle({
    Name = "Vehicle",
Flag = "Vehicle",
    Callback = function(a)
        Psalms.Tech.SeatedCheck = a
    end
})

Checks:Toggle({
    Name = "Team", 
Flag = "Team",
    Callback = function(a)
        Psalms.Tech.TeamCheck = a
    end
})

MacroEmote = {
    YungBlud = "15610015346",
    Borocks = "3994129128",
    Fishing = "3236848555",
    VPose = "10214418283",
    BouncyTwirl = "14353423348",
    Nimbus = "10147924028"
}


local MTSectionS = SubPage4:Section({Name = "Macro", Side = "Right"})
MTSectionS:Button({Name = "Load Macro", Callback = function()
    if Macro22 then
        Library:Notification("Already Loaded.", 3)
        return
    end
    Macro22 = true
  local Vars = {
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
    },
    Player = {
        Player = game:GetService("Players").LocalPlayer,
        Character = nil,
        Root = nil,
        Humanoid = nil,
    },
    Camera = {
        Instance = workspace.CurrentCamera,
    },
    Settings = {
        MAX_LENGTH = 900000,
        ENABLED_OFFSET = CFrame.new(0, 0, 0),
        DISABLED_OFFSET = CFrame.new(0, 0, 0),
    },
    State = {
        RootPos = Vector3.new(0, 0, 0),
        Active = false,
        MCenabled = false,
    },
    BackpackData = {
        Character = nil,
        Humanoid = nil,
        Backpack = nil,
    },
}

Vars.Player.Character = Vars.Player.Player.Character or Vars.Player.Player.CharacterAdded:Wait()
Vars.Player.Root = Vars.Player.Character:WaitForChild("HumanoidRootPart")
Vars.Player.Humanoid = Vars.Player.Character.Humanoid

function UpdatePos()
    if Vars.Player.Player.Character and Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid") and Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid").RootPart then
        Vars.State.RootPos = Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid").RootPart.Position
    end
end

function UpdateAutoRotate(BOOL)
    if Vars.Player.Player.Character and Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid") then
        Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid").AutoRotate = BOOL
    end
end

function GetUpdatedCameraCFrame()
    if workspace.CurrentCamera then
        return CFrame.new(Vars.State.RootPos, Vector3.new(workspace.CurrentCamera.CFrame.LookVector.X * Vars.Settings.MAX_LENGTH, Vars.State.RootPos.Y, workspace.CurrentCamera.CFrame.LookVector.Z * Vars.Settings.MAX_LENGTH))
    end
end

function EnableShiftlock()
    UpdatePos()
    UpdateAutoRotate(false)
    if Vars.Player.Player.Character and Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid") and Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid").RootPart then
        Vars.Player.Player.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = GetUpdatedCameraCFrame()
    end
    if workspace.CurrentCamera then
        workspace.CurrentCamera.CFrame = Vars.Camera.Instance.CFrame * Vars.Settings.ENABLED_OFFSET
    end
end

function DisableShiftlock()
    UpdatePos()
    UpdateAutoRotate(true)
    if workspace.CurrentCamera then
        workspace.CurrentCamera.CFrame = Vars.Camera.Instance.CFrame * Vars.Settings.DISABLED_OFFSET
    end
    if Vars.State.Active then
        Vars.State.Active:Disconnect()
        Vars.State.Active = nil
    end
end

function ShiftLock()
    if Vars.State.MCenabled then
        if not Vars.State.Active then
            Vars.State.Active = Vars.Services.RunService.RenderStepped:Connect(function()
                EnableShiftlock()
            end)
        else
            DisableShiftlock()
        end
    end
end

MakeButton("Macro", Color3.fromRGB(255, 255, 255), function(a)
    Vars.State.MCenabled = a

if not a then
DisableShiftlock()
end

 if a then
    Vars.BackpackData.Character = Vars.Player.Player.Character or Vars.Player.Player.CharacterAdded:Wait()
    Vars.BackpackData.Humanoid = Vars.BackpackData.Character:FindFirstChild("Humanoid")
    Vars.BackpackData.Backpack = Vars.Player.Player.Backpack

    for _, item in pairs(Vars.BackpackData.Character:GetChildren()) do
        if item:IsA("Tool") then
            item.Parent = Vars.BackpackData.Backpack
        end
    end

    local function humanoidplayemote(humanoid, id)
        return humanoid:PlayEmoteAndGetAnimTrackById(id)
    end

   humanoidplayemote(Vars.BackpackData.Humanoid, MacroEmote[Psalms.Tech.MacroDance])
    task.wait(Psalms.Tech.MacroDanceDelay)

    local items = {}
    for _, item in pairs(Vars.BackpackData.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(items, item)
        end
    end

    if #items > 0 then
        local randomitem = items[math.random(1, #items)]
        randomitem.Parent = Vars.BackpackData.Character
        task.wait(0.100)
        if randomitem then
            randomitem.Parent = Vars.BackpackData.Backpack
        end
    end
end
end)

local TimeElapsed = 0
local OKNigger = nil


RunService.RenderStepped:Connect(function(DeltaTime)
    TimeElapsed = TimeElapsed + DeltaTime
    if TimeElapsed >= Psalms.Tech.MacroSpeed then
        
        if Vars.State.MCenabled then
            if not OKNigger then
                OKNigger = RunService.RenderStepped:Connect(function()
                    ShiftLock()
                end)
            elseif OKNigger then
                DisableShiftlock()
else
DisableShiftlock()
            end
        end
        
        TimeElapsed = 0
    end
end)


    
end})

MacroEmote = {
    YungBlud = "15610015346",
    Borocks = "3994129128",
    Fishing = "3236848555",
    VPose = "10214418283",
    BouncyTwirl = "14353423348",
    Nimbus = "10147924028"
}

MTSectionS:List({
    Name = "Emote To Play",
Flag = "Emote afro",
    Options = {"YungBlud", "Nimbus", "Fishing", "VPose", "BouncyTwirl", "Borocks"},
    Default = "YungBlud",
    Callback = function(a)
        Psalms.Tech.MacroDance = a
    end
})

MTSectionS:Textbox({
    Name = "Latency",
Flag = "Macro Latency",
    Default = tostring(Psalms.Tech.MacroDanceDelay),
    Callback = function(a)
        Psalms.Tech.MacroDanceDelay = tonumber(a)
    end
})


MTSectionS:Textbox({
    Name = "Speed",
Flag = "Macro Speed",
    Default = tostring(Psalms.Tech.MacroSpeed),
    Callback = function(a)
        Psalms.Tech.MacroSpeed = tonumber(a)
    end
})



MTSectionS:Divider({Name = "Blatant"})


MTSectionS:Button({Name = "Load WalkSpeed", Callback = function()
    if Macro23 then
        Library:Notification("Already Loaded.", 3)
        return
    end


Macro23 = true

MakeButton("WalkSpeed", Color3.fromRGB(255, 255, 255), function(a)
dog = a
if dog then

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = Psalms.Tech.MacroSpeed * 1000
    humanoid.JumpPower = 80

if not dog then
humanoid.WalkSpeed = 18
    humanoid.JumpPower = 55
end

    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
if dog then
        humanoid.WalkSpeed = Psalms.Tech.MacroSpeed * 1000

end
    end)
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
if dog then
        humanoid.JumpPower = 90

end
    end)
end
end)

end}) 
    




local MTP = SubPage4:Section({Name = "Load", Side = "Left"})
MTP:Button({
    Name = "Lock Button",
    Callback = function()
        if LockBut then
            Library:Notification("Already Fucking Loaded", 2)
            return
        end
        LockBut = true
        local FOV43 = Drawing.new("Circle")
        FOV43.Transparency = 0.5
        FOV43.Thickness = 2
        FOV43.Color = Color3.new(1, 0, 0)
        FOV43.Filled = false
        FOV43.Radius = 250
        FOV43.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        FOV43.Visible = false

       
        local Sigmaballs = Instance.new("ScreenGui")
        Sigmaballs.Name = "Sigmaballs"
        Sigmaballs.Parent = game.CoreGui
        Sigmaballs.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Sigmaballs.ResetOnSpawn = false

        local ImageButton = Instance.new("ImageButton")
        ImageButton.Name = "ImageButton"
        ImageButton.Parent = Sigmaballs
        ImageButton.Active = true
        ImageButton.Draggable = true
        ImageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ImageButton.BackgroundTransparency = 0.5
        ImageButton.Size = UDim2.new(0, 90, 0, 90)
        ImageButton.Image = "rbxassetid://96086736054343"
        ImageButton.Position = UDim2.new(0.5, -25, 0.5, -25)

        local Ui2corner = Instance.new("UICorner")
        Ui2corner.CornerRadius = UDim.new(0.2, 0)
        Ui2corner.Parent = ImageButton

        local enabled = false




local function SigmaOhioPlayer()
    local player, CC = game.Players.LocalPlayer, workspace.CurrentCamera
    local screenCenter = Vector2.new(CC.ViewportSize.X / 2, CC.ViewportSize.Y / 2)
    local fovRadius, viewportSize = FOV43.Radius, CC.ViewportSize

    local closestPlayer, shortestDistance = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") 
           and v.Character.Humanoid.Health > 0 then
            if Psalms.Tech.FriendCheck and player:IsFriendsWith(v.UserId) then
                continue
            end

if Psalms.Tech.TeamCheck and isPlayerOnSameTeam(v) then
    continue
end

            if Psalms.Tech.KOCheck and isPlayerKO(v) then
                continue
            end

            if Psalms.Tech.SeatedCheck and isPlayerSeated(v) then
                continue
            end

            if Psalms.Tech.WallCheck and BehindWall(v) then
                continue
            end

            local pos, onScreen = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            if onScreen and pos.X > 0 and pos.Y > 0 and pos.X < viewportSize.X and pos.Y < viewportSize.Y then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if dist < fovRadius and dist < shortestDistance then
                    closestPlayer, shortestDistance = v, dist
                end
            end
        end
    end

    return closestPlayer
end

        local function toggleLock()
    if TargetAimbot.Enabled then
        local Closest = SigmaOhioPlayer()
        
        if TargBindEnabled and TargetPlr then

            TargBindEnabled = false
            targetHealth = nil
            game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
            TargetPlr = nil
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            if TargetAimbot.LookAt then
                LocalPlayer.Character.Humanoid.AutoRotate = true
            end
            ImageButton.Image = "rbxassetid://140623923630784"
            Library:Notification("Untargeted", 2)
        else
            if Closest then
                TargBindEnabled = true
                TargetPlr = Closest
                
                if TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                    targetHealth = TargetPlr.Character.Humanoid.Health




                else
                    return
               end
                
                ImageButton.Image = "rbxassetid://96086736054343"
                Library:Notification("Target Locked: <font color='" .. RealColor .. "'>" .. tostring(TargetPlr.DisplayName) .. "</font>", 2)
            else
                Library:Notification("No target found", 2)
            end
        end
    end
end

local PussyTime = 0

RunService.Heartbeat:Connect(function(DeltaTime)
    PussyTime = PussyTime + DeltaTime
    
    if PussyTime >= 0.1 and TargBindEnabled then
        if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
            if Psalms.Tech.UnlockOnKO and isPlayerKO(TargetPlr)  then
                toggleLock()
                return
            end
        end
        
        PussyTime = 0
    end
end)

        ImageButton.MouseButton1Click:Connect(toggleLock)



        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == Enum.KeyCode.DPadDown then
                toggleLock()
            end
        end)
    end
})





MTP:Button({
    Name = "Load Tool",
    Callback = function()
        if game.Players.LocalPlayer.Backpack:FindFirstChild("Lock Tool") then
            Library:Notification("Already Loaded.", 5)
            return
        end

        ToolAlreadyLoaded = true
        local  Client, Mouse = game.Players.LocalPlayer, game.Players.LocalPlayer:GetMouse()



        local Tool = Instance.new("Tool")
        Tool.Name = "Lock Tool"
        Tool.RequiresHandle = false
        Tool.Parent = Client.Backpack
        Tool.TextureId = "rbxassetid://96086736054343"

        Tool.Activated:Connect(function()
            local Closest = GetClosestToMouse()
            if TargetAimbot.Enabled then
                if TargBindEnabled and TargetPlr then
                    TargBindEnabled, TargetPlr, targetHealth = false, nil, nil
                    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
                    workspace.CurrentCamera.CameraSubject = Client.Character.Humanoid
                    Tool.TextureId = "rbxassetid://140623923630784"
                    Library:Notification("Untargeted", 2)
                else
                    TargBindEnabled, TargetPlr = true, Closest
                    if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                        targetHealth = TargetPlr.Character.Humanoid.Health
                        Tool.TextureId = "rbxassetid://96086736054343"
                        Library:Notification("Target Locked: <font color='" .. RealColor .. "'>" .. tostring(TargetPlr.DisplayName) .. "</font>", 2)
                    end
                end
            end
        end)
    end
})



MTP:Keybind({
        Name = "Lock Keybind",
        Flag = "Lock Keybind",
        UseKey = true,
        Default = Enum.KeyCode.Q,
        Callback = function(S)            
        TargLockBind = S
        end
    })


MTP:Toggle({
    Name = "Unlock On Death",
Flag = "Unlock On Death",
    Callback = function(a)
        Psalms.Tech.UnlockOnKO = a
    end
})






        local GetClose = function()
            local TargetPlr, Closest = nil, math.huge

            for _, v in pairs(Players:GetPlayers()) do
                if (v ~= Client and v.Character and v.Character:FindFirstChild("HumanoidRootPart")) then
                    local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                    if (Distance < Closest and OnScreen) then
                        Closest = Distance
                        TargetPlr = v
                    end
                end
            end
            return TargetPlr
        end

local function toggleTarget()
    local Closest = GetClosestToMouse()
    if TargetAimbot.Enabled then
        if TargBindEnabled and TargetPlr then
            TargBindEnabled = false
            targetHealth = nil
            TargetPlr = nil
            game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
            workspace.CurrentCamera.CameraSubject = Client.Character.Humanoid
            if TargetAimbot.LookAt then
                Client.Character.Humanoid.AutoRotate = true
            end
            Library:Notification("Untargeted", 2)
        else
            TargBindEnabled = true
            TargetPlr = Closest

            if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("Humanoid") then
                targetHealth = TargetPlr.Character.Humanoid.Health
            else
                return
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == TargLockBind then
        toggleTarget()
    end
end)


local PoAnimate2= SubPage4:Section({Name = "AutoShoot", Side = "Right"})

PoAnimate2:Button({
    Name = "Auto Shoot Button",
    Callback = function()
        if AutoShootButton then
            Library:Notification("Already Loaded.", 3)
            return
        end
        
        AutoShootButton = true
        MakeButton("Shoot", Color3.fromRGB(255, 0, 0), function(state)
            Psalms.Tech.AutoShoot = state
        end)
    end
})

local Bumt = SubPage2:Section({Name = "Main"})

Bumt:Toggle({
    Name = "Enabled",
Flag = "Camera",
    Callback = function(a)
        Psalms.Tech.Camera = a
    end
})
Bumt:Toggle({
    Name = "Flick",
Flag = "Flick",
    Callback = function(a)
        Flick = a
    end
})
Bumt:Toggle({
    Name = "Division",
Flag = "Cam Division",
    Callback = function(a)
        Psalms.Tech.UseExternal = a
    end
})
Bumt:Toggle({
    Name = "Resolver",
Flag = "Cam Resolver",
    Callback = function(a)
        Psalms.Tech.CamResolverEnabled = a
    end
})
Bumt:Textbox({
    Name = "Camera Smoothness",
Flag = "Cam Smoothness",
    Default = tostring(Psalms.Tech.smoothness),
    Callback = function(a)
        Psalms.Tech.smoothness = tonumber(a)
    end
})

Bumt:List({
    Name = "Easing Style",
    Options = {
        "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", 
        "Exponential", "Circular", "Back", "Bounce", "Elastic"
    },
    Default = Psalms.Tech.easingStyle,
    Callback = function(a)
        Psalms.Tech.easingStyle = a
    end
})

Bumt:List({
    Name = "Easing Direction",
    Options = {"In", "Out", "InOut"},
    Default = Psalms.Tech.easingDirection,
    Callback = function(a)
        Psalms.Tech.easingDirection = a
    end
})

Bumt:Divider({Name = "Checks"})

Bumt:Toggle({
    Name = "Wall",
Flag = "Cam WallCheck",
    Callback = function(a)
        Psalms.Tech.CamWallCheck = a
    end
})
Bumt:Toggle({
    Name = "Knocked",
Flag = "Cam Ko",
    Callback = function(a)
        Psalms.Tech.CAMKo = a
    end
})

local camgay = 0.1
local camgay2 = 0.1

local CamPred = SubPage2:Section({Name = "Prediction", Side = "Right"})

CamPred:Textbox({
    Name = "Horizontal Prediction",
Flag = "Cam HPred",
    Default = 0.1,
    Callback = function(a)
        camgay2 = tonumber(a)
task.wait(0.01)
Psalms.Tech.CamPrediction2 = camgay
      Psalms.Tech.CamPrediction1 = camgay2
    end
})
CamPred:Textbox({
    Name = "Vertical Prediction",
Flag = "Cam VPred",
    Default = 0.1,
    Callback = function(a)
        camgay = tonumber(a)
task.wait(0.01)
Psalms.Tech.CamPrediction2 = camgay
      Psalms.Tech.CamPrediction1 = camgay2
    end
})

CamPred:Toggle({
    Name = "AutoPred",
Flag = "Auto Prediction",
    Callback = function(a)
        Psalms.Tech.CamAutoprediction = a
       Psalms.Tech.CamPrediction2 = camgay
      Psalms.Tech.CamPrediction1 = camgay2
    end
})



local HitDetectionSection = SubPage3:Section({Name = "Hit Detection", Side = "Right"})
HitDetectionSection:Toggle({
    Name = "Hit Effect",
Flag = "Hit Effects",
    Callback = function(a) 
        TargetAimbot.HitEffect = a
    end
})
HitDetectionSection:Toggle({
    Name = "Hit Sound",
Flag = "Hit Sounds",
    Callback = function(a)
        TargetAimbot.HitSounds = a
    end
})
HitDetectionSection:Toggle({
    Name = "Notify",
Flag = "Notification",
    Callback = function(a) 
        Hitnotify = a
    end
})
HitDetectionSection:List({
    Name = "Effect Type",
Flag = "Effect Type",
    Options = {"Atomic Slash", "Crescent Slash", "Coom", "Nova", "Cosmic Explosion", "AuraBurst", "Thunder"},
    Default = TargetAimbot.HitEffectType,
    Callback = function(a)
        TargetAimbot.HitEffectType = a
    end
})
HitDetectionSection:List({
    Name = "Sound Type",
Flag = "Sound Type",
    Options = {
        "RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust", 
        "BlackPencil", "UWU", "Plooh", "Moan", "Hentai", 
        "Bruh", "BoneBreakage", "Fein", "Unicorn", "Kitty", "Bird", "BirthdayCake", "KenCarson"
    },
    Default = TargetAimbot.HitSound,
    Callback = function(a)
        TargetAimbot.HitSound = a
    end
})
HitDetectionSection:Colorpicker({
    Name = "Hit Effect Color",
Flag = "Hit Effect Color",
    Default = TargetAimbot.HitEffectColor,
    Callback = function(a)
        TargetAimbot.HitEffectColor = a
    end
})
HitDetectionSection:Colorpicker({
    Name = "Visualizer",
Flag = "Visualizer Color",
    Default = TargetAimbot.CSync.Color,
    Callback = function(a)
        TargetAimbot.CSync.Color = a
    end
})

local MTSection1 = SubPage3:Section({Name = "Prediction Breaker", Side = "Left"})
MTSection1:Toggle({
    Name = "Jump Prediction",
Flag = "Jump Pred Anti",
    Callback = function(a)
        Psalms.Tech.JumpBreak = a
    end
})
MTSection1:Toggle({
    Name = "Enable Anti Lock",
Flag = "AntiLock",
    Callback = function(a)
        Desync = a
    end
})
MTSection1:Toggle({
    Name = "Anti Network",
Flag = "Network Desync",
    Callback = function(a)
        desyncsleep = a
    end
})
MTSection1:List({
    Name = "Anti Lock Type",
Flag = "AntiLock Type",
    Options = {"Multiply", "Shake", "Behind", "Down", "Forward", "Left", "One", "Right", "Up", "Zero"},
    Default = AntiLockType,
    Callback = function(a)
        AntiLockType = a
    end
})

local HitChamsSection = SubPage3:Section({Name = "Hit Chams", Side = "Left"})

HitChamsSection:Toggle({
    Name = "Hit Cham",
Flag = "Hit Chams",
    Callback = function(a)
        TargetAimbot.HitChams = a
    end
}):Colorpicker({
    Name = "Color",
Flag = "HitCham Color",
    Default = TargetAimbot.HitChamsColor,
    Callback = function(a)
        TargetAimbot.HitChamsColor = a
    end
})

HitChamsSection:Toggle({
    Name = "Hit Skeleton",
Flag = "Hit Skele",
    Callback = function(a)
        TargetAimbot.HitSkele = a
    end
}):Colorpicker({
    Name = "Color",
Flag = "Hit SkeletonColor",
    Default = TargetAimbot.SkeleColor, 
    Callback = function(a)
        TargetAimbot.SkeleColor = a
    end
})



HitChamsSection:Slider({
    Name = "Duration",
Flag = "HitChams Duration",
    Min = 0,
    Max = 10,
    Default = TargetAimbot.HitChamsDuration,
    Suffix = "",
    Decimals = 1.293,
    Callback = function(a)
        TargetAimbot.HitChamsDuration = a
    end
})
HitChamsSection:Slider({
    Name = "Transparency",
    Min = 0,
    Max = 1,
    Default = 0,
    Suffix = "",
    Decimals = 0.001,
    Callback = function(a)
        TargetAimbot.HitChamsTransparency = a
    end
})
HitChamsSection:List({
    Name = "Material",
    Options = {Enum.Material.Neon.Name, Enum.Material.SmoothPlastic.Name, Enum.Material.ForceField.Name},
    Default = TargetAimbot.HitChamsMaterial.Name,
    Callback = function(a)
        TargetAimbot.HitChamsMaterial = Enum.Material[a]
    end
})


local NIGA = SubPage7:Section({Name = "SkyBox", Side = "Left"})
local FogDick = SubPage7:Section({Name = "Fog", Side = "Left"})
local TargetVisual = SubPage5:Section({Name = "Target", Side = "Right"})
local Bullet1 = SubPage5:Section({Name = "Bullets", Side = "Right"})
local ESP1 = SubPage5:Section({Name = "Global", Side = "Left"})
local Sig2 = SubPage5:Section({Name = "Local Player", Side = "Right"})
local CrossHair = SubPage5:Section({Name = "Crosshair", Side = "Right"})
local Sig3 = SubPage7:Section({Name = "Enviroment", Side = "Right"})


NIGA:Toggle({
    Name = "Skybox Enabled",
    Callback = function(a)
        skyboxEnabled = a
        changeSkybox()
    end
})

NIGA:List({
    Name = "Skybox Type",
    Options = {
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7"
    },
    Default = "1",
    Callback = function(a)
        skyboxType = tonumber(a)
        changeSkybox()
    end
})

FogDick:Toggle({
    Name = "Fog Enabled",
Flag = "Fog",
    Callback = function(a)
        Environment.Settings.FogEnabled = a
        fogmaker()
    end
})

FogDick:Colorpicker({
    Name = "Fog Color",
Flag = "Fog Color",
    Default = Environment.Settings.FogColor,
    Callback = function(a)
        Environment.Settings.FogColor = a
fogmaker() 
    end
})

FogDick:Textbox({
    Name = "Fog Start",
Flag = "Fog Start",
    Default = Environment.Settings.FogStart,
    Callback = function(a)
        Environment.Settings.FogStart = tonumber(a)
fogmaker()
    end
})

FogDick:Textbox({
    Name = "Fog End",
Flag = "Fog End",
    Default = Environment.Settings.FogEnd,
    Callback = function(a)
        Environment.Settings.FogEnd = tonumber(a)
fogmaker() 
    end
})



NIGA:Button({
    Name = "Change",
    Callback = function()
        changeSkybox()
    end
})
CrossHair:Toggle({Name = "Enable", Callback = function(v)
            getgenv().crosshair.enabled  = v
                end}):Colorpicker({
    Name = "Color",
    Default = getgenv().crosshair.color,
    Callback = function(a)
        getgenv().crosshair.color = a
    end
})

CrossHair:Toggle({Name = "Spin", Callback = function(v)
            getgenv().crosshair.spin  = v
                end})
CrossHair:Toggle({Name = "Resize", Callback = function(v)
            getgenv().crosshair.resize  = v
                end})
CrossHair:Toggle({Name = "Stick To Target",  Callback = function(v)
            getgenv().crosshair.sticky   = v
                end}) 
CrossHair:List({
    Name = "Position",
    Options = {
        "Middle", "Mouse"
    },
    Default = "Middle",
    Callback = function(a)
        crosshair_position = a
    end
})

Bullet1:Toggle({Name = "Enable", Callback = function(v)
            Configurations.Visuals.Bullet_Trails.Enabled   = v
                end}):Colorpicker({
    Name = "Color",
    Default = Configurations.Visuals.Bullet_Trails.Color,
    Callback = function(a)
        Configurations.Visuals.Bullet_Trails.Color = a
    end
})
Bullet1:Toggle({Name = "Fade", Callback = function(v)
            Configurations.Visuals.Bullet_Trails.Fade   = v
                end}) 

Bullet1:Slider({
    Name = "Size",
    Min = 0.01,
    Max = 5,
    Default = Configurations.Visuals.Bullet_Trails.Width,
    Suffix = "%",
    Decimals = 0.01,
    Callback = function(a)
 Configurations.Visuals.Bullet_Trails.Width = a
    end
})
Bullet1:Slider({
    Name = "Duration",
    Min = 0.01,
    Max = 10,
    Default = Configurations.Visuals.Bullet_Trails.Duration,
    Suffix = "%",
    Decimals = 0.01,
    Callback = function(a)
        Configurations.Visuals.Bullet_Trails.Duration = a
    end
})


Bullet1:List({
    Name = "Texture",
    Options = {
        "Cool", "Cum",  "Electro", "None" 
    },
    Default = "Cool",
    Callback = function(a)
        Configurations.Visuals.Bullet_Trails.Texture = a
    end
})

        



-- 
ESP1:Toggle({Name = "Use Bounding Box", Callback = function(v)
    getgenv().esp.UseBoundingBox = v
end})



-- Box Settings
ESP1:Toggle({Name = "Box Enabled", Callback = function(v)
    getgenv().esp.BoxEnabled = v
end}):Colorpicker({
    Name = "Box Color",
    Default = getgenv().esp.BoxColor,
    Callback = function(a)
        getgenv().esp.BoxColor = a
    end
})

ESP1:Toggle({Name = "Box Corners", Callback = function(v)
    getgenv().esp.BoxCorners = v
end})

ESP1:Toggle({Name = "Box Dynamic", Callback = function(v)
    getgenv().esp.BoxDynamic = v
end})

ESP1:Slider({
    Name = "Box Width",
    Min = 0.1,
    Max = 3,
    Default = getgenv().esp.BoxStaticXFactor,
Decimals = 0.01,
    Suffix = "X",
    Callback = function(a)
        getgenv().esp.BoxStaticXFactor = a
    end
})

ESP1:Slider({
    Name = "Box Height",
    Min = 0.1,
    Max = 3,
    Default = getgenv().esp.BoxStaticYFactor,
Decimals = 0.01,
    Suffix = "Y",
    Callback = function(a)
        getgenv().esp.BoxStaticYFactor = a
    end
})



ESP1:Toggle({Name = "Skeleton Enabled", Callback = function(v)
    getgenv().esp.SkeletonEnabled = v
end}):Colorpicker({
    Name = "Skeleton Color",
    Default = getgenv().esp.SkeletonColor,
    Callback = function(a)
        getgenv().esp.SkeletonColor = a
    end
})

ESP1:Slider({
    Name = "Skeleton Max Distance",
    Min = 100,
    Max = 1000,
    Default = getgenv().esp.SkeletonMaxDistance,
    Suffix = "m",
    Callback = function(a)
        getgenv().esp.SkeletonMaxDistance = a
    end
})


ESP1:Toggle({Name = "Chams Enabled", Callback = function(v)
    getgenv().esp.ChamsEnabled = v
end})

ESP1:Colorpicker({
    Name = "Chams Inner Color",
    Default = getgenv().esp.ChamsInnerColor,
    Callback = function(a)
        getgenv().esp.ChamsInnerColor = a
    end
}):Colorpicker({
    Name = "Chams Outer Color",
    Default = getgenv().esp.ChamsOuterColor,
    Callback = function(a)
        getgenv().esp.ChamsOuterColor = a
    end
})

ESP1:Slider({
    Name = "Chams Inner Transparency",
    Min = 0,
    Max = 1,
    Default = getgenv().esp.ChamsInnerTransparency,
    Decimals = 0.01,
    Callback = function(a)
        getgenv().esp.ChamsInnerTransparency = a
    end
})

ESP1:Slider({
    Name = "Chams Outer Transparency",
    Min = 0,
    Max = 1,
    Default = getgenv().esp.ChamsOuterTransparency,
    Decimals = 0.01,
    Callback = function(a)
        getgenv().esp.ChamsOuterTransparency = a
    end
})


ESP1:Toggle({Name = "Text Enabled", Callback = function(v)
    getgenv().esp.TextEnabled = v
end}):Colorpicker({
    Name = "Text Color",
    Default = getgenv().esp.TextColor,
    Callback = function(a)
        getgenv().esp.TextColor = a
    end
})

ESP1:Toggle({Name = "Health Bar Enabled", Callback = function(v)
    getgenv().esp.BarLayout['health'].enabled = v
end})


ESP1:Toggle({
    Name = "Target Only Mode",
    Callback = function(v)
        getgenv().esp.TargetOnly = v
    end
})



getgenv().TrailColor = Color3.fromRGB(255, 209, 220)
Sig2:Toggle({
    Name = "Trail",
    Callback = function(v)
        utility = utility or {}

        local Settings = {
            Visuals = {
                SelfESP = {
                    Trail = {
                        InsideColor = getgenv().TrailColor,
                        OutsideColor = getgenv().TrailColor,
                        LifeTime = 5,
                        Width = 0.08
                    }
                }
            }
        }

        utility.trail_character = function(Bool)
            local player = game.Players.LocalPlayer

            local function createTrail(character)
                local existingTrailPart = workspace:FindFirstChild("TrailPart")
                if existingTrailPart then
                    existingTrailPart:Destroy()
                end

                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                local invisiblePart = Instance.new("Part", workspace)
                invisiblePart.Name = "TrailPart"
                invisiblePart.Size = Vector3.new(0.1, 0.1, 0.1)
                invisiblePart.Transparency = 1
                invisiblePart.Anchored = true
                invisiblePart.CanCollide = false
                invisiblePart.CFrame = humanoidRootPart.CFrame
                
                local BlaBla = Instance.new("Trail", invisiblePart)
                BlaBla.Name = "BlaBla"

                local attachment0 = Instance.new("Attachment", invisiblePart)
                attachment0.Position = Vector3.new(0, 1, 0)
                local attachment1 = Instance.new("Attachment", invisiblePart)
                attachment1.Position = Vector3.new(0, -1, 0)

                BlaBla.Attachment0 = attachment0
                BlaBla.Attachment1 = attachment1

                BlaBla.Lifetime = Settings.Visuals.SelfESP.Trail.LifeTime
                BlaBla.Transparency = NumberSequence.new(0, 0)
                BlaBla.LightEmission = 150
                BlaBla.Brightness =  1500
                BlaBla.LightInfluence = 1
                BlaBla.WidthScale = NumberSequence.new(Settings.Visuals.SelfESP.Trail.Width)

                game:GetService("RunService").RenderStepped:Connect(function()
                    BlaBla.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, getgenv().TrailColor),
                        ColorSequenceKeypoint.new(1, getgenv().TrailColor)
                    })

                    if humanoidRootPart then
                        invisiblePart.CFrame = humanoidRootPart.CFrame
                    end
                end)
            end

            if Bool then
                local character = player.Character or player.CharacterAdded:Wait()
                createTrail(character)

                player.CharacterAdded:Connect(function(newCharacter)
                    if Bool then
                        createTrail(newCharacter)
                    end
                end)
            else
                for _, child in ipairs(workspace:GetChildren()) do
                    if child:IsA("Part") and child.Name == "TrailPart" then
                        child:Destroy()
                    end
                end
            end
        end

        utility.trail_character(v)
    end
}):Colorpicker({
    Name = "Color",
    Default = getgenv().TrailColor,
    Callback = function(a)
        getgenv().TrailColor = a
    end
})

local localPlayerEsp = {
    ForcefieldBody = {
        Enabled = false,
        Color = Library.Accent,
    },
    ForcefieldTools = {
        Enabled = false,
        Color = Library.Accent,
    },
    ForcefieldHats = {
        Enabled = false,
        Color = Library.Accent,
    }
}

function applyForcefieldToParts(parts, isEnabled, color)
    for _, part in pairs(parts) do
        if part:IsA("BasePart") then
            if isEnabled then
                part.Material = Enum.Material.ForceField
                part.Color = color
            else
                part.Material = Enum.Material.Plastic
            end
        end
    end
end

function applyForcefieldToBody()
    local character = game.Players.LocalPlayer.Character
    if character then
        applyForcefieldToParts(character:GetChildren(), localPlayerEsp.ForcefieldBody.Enabled, localPlayerEsp.ForcefieldBody.Color)
    end
end

function applyForcefieldToTools()
    local backpack = game.Players.LocalPlayer.Backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            applyForcefieldToParts(tool:GetChildren(), localPlayerEsp.ForcefieldTools.Enabled, localPlayerEsp.ForcefieldTools.Color)
        end
    end
end

function applyForcefieldToHats()
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                applyForcefieldToParts(accessory:GetChildren(), localPlayerEsp.ForcefieldHats.Enabled, localPlayerEsp.ForcefieldHats.Color)
            end
        end
    end
end

function onCharacterAdded(character)
    character:WaitForChild("HumanoidRootPart")
    applyForcefieldToBody()
    applyForcefieldToTools()
    applyForcefieldToHats()
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end



TargetVisual:Toggle({
    Name = "Highlight",
    Flag = "HighlightFlag",
    Callback = function(a)
        Highlight = a
    end
})

TargetVisual:Toggle({
    Name = "Animate Highlight",
    Flag = "AnimateHighlightFlag",
    Callback = function(a)
        AChams = a
    end
})

TargetVisual:Colorpicker({
    Name = "Color",
    Flag = "HighlightColor1Flag",
    Default = TargetAimbot.HighlightColor1,
    Callback = function(a)
        TargetAimbot.HighlightColor1 = a
    end
})

TargetVisual:Colorpicker({
    Name = "Color2",
    Flag = "HighlightColor2Flag",
    Default = TargetAimbot.HighlightColor2,
    Callback = function(a)
        TargetAimbot.HighlightColor2 = a
    end
})

Sig2:Toggle({
    Name = "Self Cham",
    Flag = "SelfChamFlag",
    Default = localPlayerEsp.ForcefieldBody.Enabled,
    Callback = function(a)
        localPlayerEsp.ForcefieldBody.Enabled = a
        applyForcefieldToBody()
    end
}):Colorpicker({
    Name = "Color",
    Flag = "SelfChamColorFlag",
    Default = localPlayerEsp.ForcefieldBody.Color,
    Callback = function(a)
        localPlayerEsp.ForcefieldBody.Color = a
        applyForcefieldToBody()
    end
})

Sig2:Toggle({
    Name = "Gun Chams",
    Flag = "GunChamFlag",
    Default = localPlayerEsp.ForcefieldTools.Enabled,
    Callback = function(a)
        localPlayerEsp.ForcefieldTools.Enabled = a
        applyForcefieldToTools()
    end
}):Colorpicker({
    Name = "Color gun",
    Flag = "GunChamColorFlag",
    Default = localPlayerEsp.ForcefieldTools.Color,
    Callback = function(a)
        localPlayerEsp.ForcefieldTools.Color = a
        applyForcefieldToTools()
    end
})

Sig2:Toggle({
    Name = "Accessories Chams",
    Flag = "AccessoriesChamFlag",
    Default = localPlayerEsp.ForcefieldHats.Enabled,
    Callback = function(a)
        localPlayerEsp.ForcefieldHats.Enabled = a
        applyForcefieldToHats()
    end
}):Colorpicker({
    Name = "Color1",
    Flag = "AccessoriesChamColorFlag",
    Default = localPlayerEsp.ForcefieldHats.Color,
    Callback = function(a)
        localPlayerEsp.ForcefieldHats.Color = a
        applyForcefieldToHats()
    end
})

Sig3:Toggle({
    Name = "Enable",
    Flag = "World",
    Default = Environment.Settings.Enabled,
    Callback = function(a)
        Environment.Settings.Enabled = a
        UpdateWorld()
    end
})

Sig3:Toggle({
    Name = "Global Shadow",
    Flag = "GlobalShadowFlag",
    Default = Environment.Settings.GlobalShadows,
    Callback = function(a)
        Environment.Settings.GlobalShadows = a
        UpdateWorld()
    end
})

Sig3:Textbox({
    Name = "Exposure",
    Flag = "ExposureFlag",
    Default = Environment.Settings.Exposure,
    Callback = function(a)
        Environment.Settings.Exposure = tonumber(a)
        UpdateWorld()
    end
})

Sig3:Colorpicker({
    Name = "Color Shift",
    Flag = "ColorShiftBottomFlag",
    Default = Environment.Settings.ColorShift_Bottom,
    Callback = function(a)
        Environment.Settings.ColorShift_Bottom = a
        UpdateWorld()
    end
}):Colorpicker({
    Name = "Top",
    Flag = "ColorShiftTopFlag",
    Default = Environment.Settings.ColorShift_Top,
    Callback = function(a)
        Environment.Settings.ColorShift_Top = a
        UpdateWorld()
    end
})

print("khen.cc")

Sig3:Textbox({
    Name = "Clock Time",
    Flag = "ClockTimeFlag",
    Default = Environment.Settings.ClockTime,
    Callback = function(a)
        Environment.Settings.ClockTime = tonumber(a)
        UpdateWorld()
    end
})

Sig3:Colorpicker({
    Name = "Ambient Color",
    Flag = "AmbientColorFlag",
    Default = Environment.Settings.Ambient,
    Callback = function(a)
        Environment.Settings.Ambient = a
        UpdateWorld()
    end
})

Sig3:Colorpicker({
    Name = "OutdoorAmbient Color",
    Flag = "OutdoorAmbientColorFlag",
    Default = Environment.Settings.OutdoorAmbient,
    Callback = function(a)
        Environment.Settings.OutdoorAmbient = a
        UpdateWorld()
    end
})

Sig3:Textbox({
    Name = "Brightness",
    Flag = "WorldBrightnessFlag",
    Default = Environment.Settings.Brightness,
    Callback = function(a)
        Environment.Settings.Brightness = tonumber(a)
        UpdateWorld()
    end
})

local fuv = SubPage2:Section({Name = "Gradient Silent for Everything", Side = "Right"})

fuv:Toggle({
    Name = "Enabled",
Flag = "ShowSilent" ,
    Callback = function(dang)
        Frame.Visible = dang
    end
})


fuv:Toggle({
    Name = "Silent",
Flag = "SilentEnabled",
    Callback = function(dang)
        Psalms.Tech.SilentMode = dang
    end
})

fuv:List({
    Name = "Mode",
Flag = "FOV Gradient Position",
    Options = {
        "Mouse", "Center"
    },
    Default = "Center",
    Callback = function(a)
        mode = a
    end
})

fuv:Colorpicker({
    Name = "Color 1",
Flag = "Silent Gradient Color",
    Default = coluhhh,
    Callback = function(a)
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, a),
            ColorSequenceKeypoint.new(1, coluhhh2)
        }
    end
})




fuv:Colorpicker({
    Name = "Gradient2",
Flag = "Silent Fov Gradient2",
    Default = coluhhh2,
    Callback = function(a)
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, coluhhh),
            ColorSequenceKeypoint.new(1, a)
        }
    end
})


fuv:Slider({
    Name = "Size",
Flag = "Silent fov sjze",
    Min = 1,
    Max = 200,
    Default = 125,
    Suffix = "%",
    Decimals = 1,
    Callback = function(a)
        local fovRadius = a
UpdateFrameSize(a)
    end
})

local Dog11 = SubPage6:Section({Name = "CFrame Speed", Side = "Left"})



Dog11:Button({
    Name = "Load Invisible Button",
    Callback = function()
        if Hide11 then
            Library:Notification("Already Loaded.", 3)
            return
        end

        local HideEnabled = false
        Hide11 = true
        local LastCFrame

        MakeButton("Invisible", Color3.fromRGB(255, 0, 0), function(state)
            HideEnabled = state

            if not HideEnabled then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LastCFrame
                end
            else
                LastCFrame = nil
            end
        end)

        RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        if HumanoidRootPart then
            local Offset = HumanoidRootPart.CFrame * CFrame.new(9e9, 0, 9e9)

            if HideEnabled then
                LastCFrame = HumanoidRootPart.CFrame
                HumanoidRootPart.CFrame = Offset
                RunService.RenderStepped:Wait()
                HumanoidRootPart.CFrame = LastCFrame
            end
        end
    end
end)

        local HookMethod
        HookMethod = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if not checkcaller() and key == "CFrame" and HideEnabled and 
               LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
               LocalPlayer.Character:FindFirstChild("Humanoid") and 
               LocalPlayer.Character.Humanoid.Health > 0 then
                if self == LocalPlayer.Character.HumanoidRootPart and LastCFrame then
                    return LastCFrame
                end
            end
            return HookMethod(self, key)
        end))

end
})

Dog11:Button({
    Name = "Load Cframe Button",
    Callback = function()
        if MacroAlreadLoaded then
            Library:Notification("Already Loaded.", 3)
            return
        end
        
        MacroAlreadLoaded = true
        MakeButton("Speed", Color3.fromRGB(155, 0, 155), function(state)
            Psalms.Tech.cframespeedtoggle = state
        end)
    end
})

Dog11:Button({
    Name = "Load Fly",
    Callback = function()
        if Macro2 then
            Library:Notification("Already Loaded.", 3)
            return
        end

        Macro2 = true




speeds = Psalms.Tech.speedvalue

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false






MakeButton("Fly", Color3.fromRGB(255, 0, 155), function(state)
niga2 = state

            
        



	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then



		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
				print("khen.cc")
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false




	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	end





end)



game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false
	print("khen.cc")

end)



        
    end
})

Dog11:Slider({
    Name = "Speed",
Flag = "Fly CFrame Speed",
    Min = 0,
    Max = 10,
    Default = 3,
    Suffix = "%",
    Decimals = 000.1,
    Callback = function(a)
        Psalms.Tech.speedvalue = a
    end
})
local CSyncSection = SubPage6:Section({Name = "CSync", Side = "Right"})
CSyncSection:Toggle({
    Name = "Enabled",
Flag = "Strafe",
    Callback = function(a)
        TargetAimbot.CSync.Enabled = a
    end
})
CSyncSection:Toggle({
    Name = "Spoof",
Flag = "Strafe Spoof",
    Callback = function(a)
        TargetAimbot.CSync.Visualize = a
    end
})
CSyncSection:List({
    Name = "Type",
Flag = "TypeStrafe",
    Options = {"Orbit", "Random", "Spiral", "Spherical", "Attach"},
    Default = TargetAimbot.CSync.Type,
    Callback = function(a)
        TargetAimbot.CSync.Type = a
    end
})
CSyncSection:Slider({
    Name = "Distance",
Flag = "Strafe Distance",
    Min = 0,
    Max = 100,
    Default = TargetAimbot.CSync.Distance,
    Suffix = "",
    Decimals = 1,
    Callback = function(a)
        TargetAimbot.CSync.Distance = a
    end
})
CSyncSection:Slider({
    Name = "Height",
Flag = "Strafe Heigjt",
    Min = 0,
    Max = 100,
    Default = TargetAimbot.CSync.Height,
    Suffix = "",
    Decimals = 1,
    Callback = function(a)
        TargetAimbot.CSync.Height = a
    end
})
CSyncSection:Slider({
    Name = "Speed",
Flag = "Strafe Speed",
    Min = 0,
    Max = 100,
    Default = TargetAimbot.CSync.Speed,
    Suffix = "",
    Decimals = 1,
    Callback = function(a)
        TargetAimbot.CSync.Speed = a
    end
})
CSyncSection:Slider({
    Name = "Random Amount",
Flag = "Random Amount",
    Min = 0,
    Max = 100,
    Default = TargetAimbot.CSync.RandomAmount,
    Suffix = "",
    Decimals = 1,
    Callback = function(a)
        TargetAimbot.CSync.RandomAmount = a
    end
})








local Avatar = Settings:Section({Name = "Character", Side = "Right",  Zindex = 2})


local OutfitList = Avatar:List({
    Name = "Outfits",
    Flag = "OutfitSelection",
    Options = {}
})

local CurrentOutfits = {}



local function UpdateOutfitList()

    local Outfits = {}
    local userId = Players.LocalPlayer.UserId
    local url = "https://avatar.roblox.com/v1/users/" .. userId .. "/outfits"

    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and response and response.data then
        for _, outfit in ipairs(response.data) do
            if outfit.isEditable then
                table.insert(Outfits, outfit.name)
                CurrentOutfits[outfit.name] = outfit.id
            end
        end

        if #Outfits ~= #OutfitList.Options or table.concat(Outfits) ~= table.concat(OutfitList.Options) then
            OutfitList.Options = Outfits
            if OutfitList.Refresh then
                OutfitList:Refresh(Outfits)
            end
        end
    end
end

local function EquipOutfit(outfitName)
    local outfitId = CurrentOutfits[outfitName]
    if outfitId then
        local description = Players:GetHumanoidDescriptionFromOutfitId(outfitId)
        AvatarEditorService:PromptSaveAvatar(description, Enum.HumanoidRigType.R15)

        local result = AvatarEditorService.PromptSaveAvatarCompleted:Wait()
        if result == Enum.AvatarPromptResult.Success then
            Players.LocalPlayer.Character.Humanoid.Health = 0
        end
    end
end

OutfitList.Callback = function(selectedOutfit)
    EquipOutfit(selectedOutfit)
end

local Nword = Settings:Section({Name = "Camera", Side = "Right"})

Nword:Slider({
    Name = "Field Of View",
Flag = "Field Of View",
    Min = 5,
    Max = 130,
    Default = 80,
    Suffix = "",
    Decimals = 0.1,
    Callback = function(a)
        Camera.FieldOfView = a
    end
})

Avatar:Button({
        Name = "Refresh",
        Callback = UpdateOutfitList
    })

local PoAnimate = Settings:Section({Name = "Dance", Side = "Right"})



local Configurations = {
    Misc = {
        Animation = {
            Enabled = false,
            SelectedDance = "Floss",
            Speed = 2
        }
    }
}

   
local Dances = {
    Floss = 10714340543,
Spin = 2516930867,
Sit = 807343012,
ArmSpin = 900850443,
Lay = 2695918332

}

local currentAnimation

local function AnimPlay(ID, SPEED)
    if currentAnimation then
        currentAnimation:Stop()
    end

    local animation = Instance.new('Animation')
    animation.AnimationId = 'rbxassetid://' .. ID

    currentAnimation = LocalPlayer.Character.Humanoid:LoadAnimation(animation)
    currentAnimation:Play()
    currentAnimation:AdjustSpeed(tonumber(SPEED) or 1)

    animation:Destroy()
end

PoAnimate:Slider({
    Name = "Speed",
Flag = "Dance Speed",
    Min = 0,
    Max = 1000, 
    Default = Configurations.Misc.Animation.Speed,
    Suffix = "",
    Decimals = 0.001,
    Callback = function(a)
        Configurations.Misc.Animation.Speed = a
    end
})

PoAnimate:List({
    Name = "Dance",
Flag = "Dance Type",
    Options = {"Floss", "Spin", "Sit", "ArmSpin", "Lay"},
    Default = "Floss",
    Callback = function(a)
        Configurations.Misc.Animation.SelectedDance = a
    end
})


PoAnimate:Toggle({
    Name = "Animate",
    Flag = "Animate",
    Callback = function(state)
        Configurations.Misc.Animation.Enabled = state
        if Configurations.Misc.Animation.Enabled then
            local selectedDance = Dances[Configurations.Misc.Animation.SelectedDance or "Floss"]
            if selectedDance then
                AnimPlay(selectedDance, Configurations.Misc.Animation.Speed or 1)
            end
        else
            if currentAnimation then
                currentAnimation:Stop()
                currentAnimation = nil
            end
        end
    end
})





LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if Configurations.Misc.Animation.Enabled then
        local selectedDance = Dances[Configurations.Misc.Animation.SelectedDance or "Floss"]
        if selectedDance then
            AnimPlay(selectedDance, Configurations.Misc.Animation.Speed or 1)
        end
    end
end)


--
do
    local CFG = Settings:Section({Name = "Config", Zindex = 2})
--
if not isfolder("Psalms") then makefolder("Psalms") end
if not isfolder("Psalms/Configs") then makefolder("Psalms/Configs") end

local ConfigList = CFG:List({Name = "Config", Flag = "SettingConfigurationList", Options = {}})
CFG:Textbox({Flag = "SettingsConfigurationName", Name = "Config Name"})

local CurrentList = {}

local function UpdateConfigList()
    local List = {}
    for _, file in ipairs(listfiles("Psalms/Configs")) do
        local FileName = file:match("Psalms/Configs/(.+)%.cfg")
        if FileName then
            table.insert(List, FileName)
        end
    end


    if #List ~= #CurrentList or table.concat(List) ~= table.concat(CurrentList) then
        CurrentList = List
        ConfigList:Refresh(CurrentList)
    end
end

CFG:Button({Name = "Create", Callback = function()
    local ConfigName = Flags.SettingsConfigurationName
    if ConfigName and ConfigName ~= "" and not isfile("Psalms/Configs/" .. ConfigName .. ".cfg") then
        writefile("Psalms/Configs/" .. ConfigName .. ".cfg", "")
        UpdateConfigList()
    end
end})

CFG:Button({Name = "Save", Callback = function()
    local SelectedConfig = Flags.SettingConfigurationList
    if SelectedConfig then
        writefile("Psalms/Configs/" .. SelectedConfig .. ".cfg", Library:GetConfig())
    end
end})

CFG:Button({Name = "Load", Callback = function()
    local SelectedConfig = Flags.SettingConfigurationList
    if SelectedConfig then
        local Content = readfile("Psalms/Configs/" .. SelectedConfig .. ".cfg")
        Library:LoadConfig(Content)
    end
end})

CFG:Button({Name = "Delete", Callback = function()
    local SelectedConfig = Flags.SettingConfigurationList
    if SelectedConfig and isfile("Psalms/Configs/" .. SelectedConfig .. ".cfg") then
        delfile("Psalms/Configs/" .. SelectedConfig .. ".cfg")
        UpdateConfigList()
    end
end})

CFG:Button({Name = "Refresh", Callback = function()
    pcall(UpdateConfigList)
end})



    CFG:Keybind({
        Name = "Menu Key",
        Flag = "MenuKey",
        UseKey = true,
        Default = Enum.KeyCode.End,
        Callback = function(State)
            Library.UIKey = State
        end
    })

    CFG:Colorpicker({
        Name = "Menu Accent",
        Flag = "MenuAccent",
        Default = Library.Accent,
        Callback = function(State)
            Library:ChangeAccent(State)
        end
    })

    CFG:Toggle({
        Name = "Show Watermark",
        Flag = "Watermark",
        Callback = function(State)
            Watermark:SetVisible(State)
        end
    })
local waterbitch = "Psalms.Tech"
CFG:Toggle({
    Name = "Update",
    Flag = "CustomMark",
    Callback = function(State)
        stats.Update = State
        if not stats.Update then
            Watermark:UpdateText(waterbitch)
        end
    end
})

    CFG:Textbox({
        Flag = "WatermarkText",
        Name = "Watermark Text",
        State = "WNCRY", 
        Callback = function(State)
            waterbitch = State
      if not stats.Update then
            Watermark:UpdateText(waterbitch)
        end
        end
    })
end

Library:SetOpen(false)

local Ui22 = Instance.new("ScreenGui")
Ui22.Name = "Ui22"
Ui22.Parent = game.CoreGui
Ui22.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Ui22.ResetOnSpawn = false

local Image3 = Instance.new("ImageButton")
Image3.Name = "Image3"
Image3.Parent = Ui22
Image3.Active = true
Image3.Draggable = true
Image3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Image3.BackgroundTransparency = 1
Image3.Size = UDim2.new(0, 90, 0, 90)
Image3.Image = "rbxassetid://92324433288253"
Image3.Position = UDim2.new(1, -95, 0, 5)











local Ui2corner = Instance.new("UICorner")
Ui2corner.CornerRadius = UDim.new(0.2, 0)
Ui2corner.Parent = Image3

Image3.MouseButton1Click:Connect(function()
    Open = not Open
    Library:SetOpen(Open)
end)






local loadingTime = os.clock() - startTime
Library:Notification(string.format("Already Loaded. Load time: %.3f seconds", loadingTime), 3)

toggleAimViewer()
end
end

if game.PlaceId == 9825515356 then
    local startTime = tick()
    local spoof = {
        pc = true,
        ping = false
    }

    while true do
        if game:GetService("Players").LocalPlayer:FindFirstChild("SPAWN_CHARACTER") then
            local a = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
            local c

            if a and a:IsA("RemoteEvent") then
                c = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = getnamecallmethod()
                    local args = {...}

                    if method == "FireServer" and self == a then
                        if table.find(args, "IS_MOBILE") and spoof.pc then
                            return
                        end

                        if table.find(args, "GetPing") and spoof.ping then
                            return
                        end
                    end

                    return c(self, ...)
                end)
            end
            cooked(true)
            return
        end

        if tick() - startTime >= 10 then
            local a = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
            local c

            if a and a:IsA("RemoteEvent") then
                c = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = getnamecallmethod()
                    local args = {...}

                    if method == "FireServer" and self == a then
                        if table.find(args, "IS_MOBILE") and spoof.pc then
                            return
                        end

                        if table.find(args, "GetPing") and spoof.ping then
                            return
                        end
                    end

                    return c(self, ...)
                end)
            end
            cooked(true)
            return
        end
        
        task.wait()
    end
end

cooked(true) 
