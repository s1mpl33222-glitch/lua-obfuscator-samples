-- ts free for you skid ('
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

pcall(function()
    CoreGui:FindFirstChild("ZAIROS_CROSSHAIR_PRO"):Destroy()
end)

local Theme = {
    Background = Color3.fromRGB(15, 8, 25),
    Surface = Color3.fromRGB(28, 15, 45),
    SurfaceLight = Color3.fromRGB(40, 22, 65),
    Primary = Color3.fromRGB(170, 0, 255),
    PrimaryDark = Color3.fromRGB(120, 0, 180),
    Secondary = Color3.fromRGB(255, 0, 200),
    Accent = Color3.fromRGB(138, 43, 226),
    Text = Color3.fromRGB(245, 245, 255),
    TextDim = Color3.fromRGB(180, 160, 200),
    Success = Color3.fromRGB(0, 255, 150),
    Danger = Color3.fromRGB(255, 50, 100),
    Glow = Color3.fromRGB(200, 100, 255),
}

local Config = {
    Enabled = true,
    CrosshairIndex = 1,
    Color = Theme.Primary,
    SecondaryColor = Theme.Secondary,
    Size = 14,
    Thickness = 2,
    Gap = 5,
    Dot = true,
    DotSize = 3,
    Outline = true,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    OutlineThickness = 1,
    Pulse = false,
    Rotate = false,
    Opacity = 1,
    Length = 12,
    OffsetX = 0,
    OffsetY = 0,
}


local Crosshairs = {

    {Name="Classic Plus",    Cat="Classic",  L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=5,  T=2,   DS=3, CR=0},
    {Name="Classic Minimal", Cat="Classic",  L={1,1,1,1}, D=false, C=false, X=false, S="", Len=10, G=6,  T=2,   DS=0, CR=0},
    {Name="Classic Dot",     Cat="Classic",  L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=4, CR=0},
    {Name="Classic Wide",    Cat="Classic",  L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=16, G=10, T=2,   DS=3, CR=0},
    {Name="Classic Tight",   Cat="Classic",  L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=8,  G=2,  T=2,   DS=3, CR=0},
    {Name="Classic Cross",   Cat="Classic",  L={1,1,1,1}, D=false, C=false, X=false, S="", Len=14, G=8,  T=2,   DS=0, CR=0},
    {Name="Classic X",       Cat="Classic",  L={0,0,0,0}, D=false, C=false, X=true,  S="", Len=12, G=0,  T=2,   DS=0, CR=0},

    {Name="CS2 Default",     Cat="Comp",     L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=10, G=3,  T=1.5, DS=2, CR=0},
    {Name="CS2 Static",      Cat="Comp",     L={1,1,1,1}, D=false, C=false, X=false, S="", Len=8,  G=2,  T=1,   DS=0, CR=0},
    {Name="Valorant",        Cat="Comp",     L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=10, G=4,  T=2,   DS=3, CR=0},
    {Name="Valorant Min",    Cat="Comp",     L={1,1,1,1}, D=false, C=false, X=false, S="", Len=8,  G=3,  T=1.5, DS=0, CR=0},
    {Name="Apex",            Cat="Comp",     L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=5,  T=2,   DS=3, CR=0},
    {Name="Fortnite",        Cat="Comp",     L={1,1,0,0}, D=true,  C=false, X=false, S="", Len=12, G=5,  T=2,   DS=3, CR=0},
    {Name="PUBG",            Cat="Comp",     L={1,1,1,1}, D=true,  C=true,  X=false, S="", Len=10, G=6,  T=1.5, DS=2, CR=14},
    {Name="Rainbow Six",     Cat="Comp",     L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=2, CR=10},
    {Name="CoD",             Cat="Comp",     L={0,0,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=0},

    {Name="Small Dot",       Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=2, CR=0},
    {Name="Medium Dot",      Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=3, CR=0},
    {Name="Large Dot",       Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=5, CR=0},
    {Name="Hollow Dot",      Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=4, CR=5},
    {Name="Square Dot",      Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=4, CR=0},
    {Name="Diamond Dot",     Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="◆", Len=0, G=0,  T=2,   DS=3, CR=0},
    {Name="Star Dot",        Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="★", Len=0, G=0,  T=2,   DS=4, CR=0},
    {Name="Ring Dot",        Cat="Dot",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=3, CR=6},
 
    {Name="Thin Circle",     Cat="Circle",   L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=1,   DS=0, CR=8},
    {Name="Thick Circle",    Cat="Circle",   L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=0, CR=10},
    {Name="Circle Dot",      Cat="Circle",   L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=3, CR=10},
    {Name="Circle Cross",    Cat="Circle",   L={1,1,1,1}, D=false, C=true,  X=false, S="", Len=8,  G=2,  T=1.5, DS=0, CR=12},
    {Name="Double Circle",   Cat="Circle",   L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=0, CR=8},
    {Name="Dashed Circle",   Cat="Circle",   L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=0, CR=10},
    {Name="Dotted Circle",   Cat="Circle",   L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=1,   DS=2, CR=10},
    {Name="Circle X",        Cat="Circle",   L={0,0,0,0}, D=false, C=true,  X=true,  S="", Len=10, G=0,  T=2,   DS=0, CR=14},

    {Name="Sniper",          Cat="Reticle",  L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=20, G=15, T=1,   DS=2, CR=0},
    {Name="Sniper Mil",      Cat="Reticle",  L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=24, G=20, T=1,   DS=2, CR=0},
    {Name="Red Dot",         Cat="Reticle",  L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=1,   DS=4, CR=15},
    {Name="Holo",            Cat="Reticle",  L={0,1,0,0}, D=true,  C=true,  X=false, S="", Len=8,  G=0,  T=2,   DS=3, CR=12},
    {Name="Chevron",         Cat="Reticle",  L={0,0,0,0}, D=false, C=false, X=false, S="⌄", Len=0, G=0,  T=2,   DS=0, CR=0},
    {Name="Triangle",        Cat="Reticle",  L={0,0,0,0}, D=false, C=false, X=false, S="▲", Len=0, G=0,  T=2,   DS=0, CR=0},
    {Name="ACOG",            Cat="Reticle",  L={1,1,1,1}, D=true,  C=true,  X=false, S="", Len=10, G=8,  T=1.5, DS=2, CR=18},
    {Name="Reflex",          Cat="Reticle",  L={0,1,0,0}, D=true,  C=false, X=false, S="", Len=6,  G=0,  T=2,   DS=3, CR=0},
    {Name="Thermal",         Cat="Reticle",  L={1,0,1,1}, D=true,  C=false, X=false, S="", Len=10, G=6,  T=2,   DS=3, CR=0},

    {Name="Tactical",        Cat="Tactical", L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=10, G=5,  T=2,   DS=3, CR=0},
    {Name="Tactical Min",    Cat="Tactical", L={1,0,1,0}, D=false, C=false, X=false, S="", Len=8,  G=4,  T=1.5, DS=0, CR=0},
    {Name="Tactical Box",    Cat="Tactical", L={0,0,1,1}, D=true,  C=false, X=false, S="", Len=10, G=6,  T=2,   DS=3, CR=0},
    {Name="Tactical Hex",    Cat="Tactical", L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=3, CR=14},
    {Name="Tactical Diamond",Cat="Tactical", L={0,0,0,0}, D=false, C=false, X=false, S="◆", Len=0, G=0,  T=2,   DS=8, CR=0},
    {Name="Tactical Arrow",  Cat="Tactical", L={0,0,0,0}, D=false, C=false, X=false, S="▲", Len=0, G=0,  T=2,   DS=6, CR=0},
    {Name="Tactical Target", Cat="Tactical", L={1,1,1,1}, D=true,  C=true,  X=false, S="", Len=10, G=8,  T=2,   DS=3, CR=20},

    {Name="RGB Classic",     Cat="Gaming",   L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=5,  T=2,   DS=3, CR=0},
    {Name="Neon",            Cat="Gaming",   L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=3,   DS=0, CR=12},
    {Name="Cyber",           Cat="Gaming",   L={1,1,1,1}, D=false, C=true,  X=false, S="", Len=12, G=6,  T=2,   DS=0, CR=18},
    {Name="Gaming RGB",      Cat="Gaming",   L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=5,  T=2,   DS=3, CR=0},
    {Name="Gaming Pixel",    Cat="Gaming",   L={0,0,1,1}, D=true,  C=false, X=false, S="", Len=10, G=4,  T=2,   DS=3, CR=0},
    {Name="Gaming Retro",    Cat="Gaming",   L={0,0,0,0}, D=false, C=false, X=false, S="✚", Len=0, G=0,  T=3,   DS=0, CR=0},
    {Name="Gaming SciFi",    Cat="Gaming",   L={0,0,0,0}, D=true,  C=true,  X=true,  S="", Len=12, G=0,  T=2,   DS=3, CR=16},
    {Name="Gaming Pro",      Cat="Gaming",   L={1,0,1,0}, D=true,  C=false, X=false, S="", Len=10, G=4,  T=1.5, DS=2, CR=0},
    {Name="Gaming Elite",    Cat="Gaming",   L={0,0,0,0}, D=false, C=true,  X=true,  S="", Len=8,  G=0,  T=1.5, DS=0, CR=10},
    {Name="Gaming Champion", Cat="Gaming",   L={1,1,1,1}, D=true,  C=true,  X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=20},

    {Name="Pro Static",      Cat="Pro",      L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=8,  G=3,  T=1,   DS=2, CR=0},
    
    {Name="Pro Dynamic",     Cat="Pro",      L={0,0,0,0}, D=false, C=true,  X=true,  S="", Len=10, G=0,  T=1.5, DS=0, CR=12},
    
    {Name="Pro Precision",   Cat="Pro",      L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=1,   DS=2, CR=0},
    
    {Name="Pro Speed",       Cat="Pro",      L={0,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=1.5, DS=2, CR=0},
    
    {Name="Pro Stealth",     Cat="Pro",      L={0,0,1,1}, D=false, C=false, X=false, S="", Len=10, G=8,  T=1,   DS=0, CR=0},
    
    {Name="Pro Aggro",       Cat="Pro",      L={0,0,0,0}, D=true,  C=false, X=true,  S="", Len=16, G=0,  T=2,   DS=3, CR=0},
    
    {Name="Pro Camp",        Cat="Pro",      L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=2, CR=14},
    
    {Name="Pro Rush",        Cat="Pro",      L={1,0,0,0}, D=false, C=true,  X=false, S="", Len=12, G=0,  T=2,   DS=0, CR=10},
    
    {Name="Pro Clutch",      Cat="Pro",      L={1,0,1,0}, D=false, C=false, X=false, S="", Len=10, G=4,  T=2,   DS=0, CR=0},
    
    {Name="Pro Ace",         Cat="Pro",      L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=1,   DS=3, CR=18},
    
    {Name="Pro Hawk",        Cat="Pro",      L={1,1,1,0}, D=true,  C=false, X=false, S="", Len=10, G=4,  T=1.5, DS=2, CR=0},
    
    {Name="Pro Viper",       Cat="Pro",      L={1,1,0,0}, D=false, C=true,  X=false, S="", Len=8,  G=3,  T=1.5, DS=0, CR=10},

    {Name="Single Line",     Cat="Minimal",  L={1,0,0,0}, D=false, C=false, X=false, S="", Len=14, G=0,  T=2,   DS=0, CR=0},
    {Name="Two Lines",       Cat="Minimal",  L={1,1,0,0}, D=false, C=false, X=false, S="", Len=14, G=0,  T=2,   DS=0, CR=0},
    {Name="Three Lines",     Cat="Minimal",  L={1,1,1,0}, D=false, C=false, X=false, S="", Len=14, G=0,  T=2,   DS=0, CR=0},
    {Name="L Shape",         Cat="Minimal",  L={1,0,1,0}, D=false, C=false, X=false, S="", Len=12, G=0,  T=2,   DS=0, CR=0},
    {Name="V Shape",         Cat="Minimal",  L={0,0,1,1}, D=false, C=false, X=false, S="", Len=12, G=0,  T=2,   DS=0, CR=0},
    {Name="Bracket",         Cat="Minimal",  L={0,0,1,1}, D=false, C=false, X=false, S="", Len=10, G=8,  T=2,   DS=0, CR=0},
    {Name="T Shape",         Cat="Minimal",  L={1,0,1,1}, D=false, C=false, X=false, S="", Len=12, G=0,  T=2,   DS=0, CR=0},
    {Name="Chevron Min",     Cat="Minimal",  L={0,0,1,1}, D=false, C=false, X=false, S="", Len=10, G=0,  T=2,   DS=0, CR=0},
    {Name="Slash",           Cat="Minimal",  L={0,0,0,0}, D=false, C=false, X=true,  S="", Len=14, G=0,  T=2,   DS=0, CR=0},
    {Name="Parenthesis",     Cat="Minimal",  L={0,0,1,1}, D=false, C=false, X=false, S="", Len=10, G=0,  T=2,   DS=0, CR=0},
    {Name="Top Only",        Cat="Minimal",  L={1,0,0,0}, D=true,  C=false, X=false, S="", Len=10, G=5,  T=2,   DS=2, CR=0},
    {Name="Cross+Dot",       Cat="Minimal",  L={0,0,0,0}, D=false, C=true,  X=true,  S="", Len=10, G=0,  T=1.5, DS=0, CR=8},

    {Name="Pulse Classic",   Cat="Animated", L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=0},
    {Name="Pulse Dot",       Cat="Animated", L={0,0,0,0}, D=true,  C=false, X=false, S="", Len=0,  G=0,  T=2,   DS=4, CR=0},
    {Name="Rotate Classic",  Cat="Animated", L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=0},
    {Name="Rotate Circle",   Cat="Animated", L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=0, CR=10},
    {Name="Breathe",         Cat="Animated", L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=0},
    {Name="Spin",            Cat="Animated", L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=0},
    {Name="Glitch",          Cat="Animated", L={0,0,0,0}, D=false, C=true,  X=true,  S="", Len=12, G=0,  T=2,   DS=0, CR=14},
    {Name="Flicker",         Cat="Animated", L={1,1,1,1}, D=false, C=false, X=false, S="", Len=12, G=4,  T=2,   DS=0, CR=0},
    {Name="Wave",            Cat="Animated", L={0,0,1,1}, D=true,  C=false, X=false, S="", Len=12, G=4,  T=2,   DS=3, CR=0},
    {Name="Heartbeat",       Cat="Animated", L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=4, CR=12},
  
    {Name="Cross",           Cat="Special",  L={0,1,0,1}, D=false, C=false, X=false, S="✚", Len=16, G=0, T=3,   DS=0, CR=0},
    {Name="Heart",           Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="♥", Len=0,  G=0, T=2,   DS=5, CR=0},
    {Name="Skull",           Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="☠", Len=0,  G=0, T=2,   DS=4, CR=0},
    {Name="Crown",           Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="👑", Len=0,  G=0, T=2,   DS=4, CR=0},
    {Name="Ninja",           Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="⚔", Len=0,  G=0, T=2,   DS=3, CR=0},
    {Name="Dragon",          Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="🐉", Len=0, G=0, T=2,   DS=5, CR=0},
    {Name="Phoenix",         Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="🔅", Len=0, G=0, T=2,   DS=5, CR=0},
    {Name="Star",            Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="🌟", Len=0,  G=0, T=2,   DS=4, CR=0},
    {Name="Lightning",       Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="⚡", Len=0, G=0, T=2,   DS=4, CR=0},
    {Name="Ice",             Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="❄", Len=0,  G=0, T=2,   DS=4, CR=0},
    {Name="Eagle",           Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="🦅", Len=0, G=0, T=2,   DS=5, CR=0},
    {Name="Fire",            Cat="Special",  L={0,0,0,0}, D=true,  C=false, X=false, S="🔥", Len=0, G=0, T=2,   DS=4, CR=0},

    {Name="GP Pro",          Cat="Store",    L={1,1,1,1}, D=true,  C=true,  X=false, S="", Len=14, G=6,  T=2,   DS=3, CR=12},
    {Name="GP Elite",        Cat="Store",    L={0,0,0,0}, D=false, C=true,  X=true,  S="", Len=12, G=0,  T=2,   DS=0, CR=10},
    {Name="GP Ultra",        Cat="Store",    L={1,1,1,1}, D=true,  C=false, X=false, S="", Len=16, G=8,  T=2,   DS=4, CR=0},
    {Name="GP Neon",         Cat="Store",    L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=3,   DS=0, CR=14},
    {Name="GP Minimal",      Cat="Store",    L={1,1,1,1}, D=false, C=false, X=false, S="", Len=10, G=4,  T=1.5, DS=0, CR=0},
    {Name="GP Dot",          Cat="Store",    L={0,0,0,0}, D=true,  C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=4, CR=8},
    {Name="GP Circle",       Cat="Store",    L={0,0,0,0}, D=false, C=true,  X=false, S="", Len=0,  G=0,  T=2,   DS=0, CR=12},
    {Name="GP X",            Cat="Store",    L={0,0,0,0}, D=true,  C=false, X=true,  S="", Len=12, G=0,  T=2,   DS=3, CR=0},
    {Name="GP Box",          Cat="Store",    L={1,1,1,1}, D=true,  C=true,  X=false, S="", Len=12, G=6,  T=2,   DS=3, CR=22},
    {Name="GP Star",         Cat="Store",    L={0,0,0,0}, D=true,  C=false, X=false, S="★", Len=0, G=0,  T=2,   DS=5, CR=0},
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZAIROS_CROSSHAIR_PRO"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local CrosshairContainer = Instance.new("Frame")
CrosshairContainer.Name = "CrosshairContainer"
CrosshairContainer.Size = UDim2.new(0, 100, 0, 100)
CrosshairContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairContainer.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairContainer.BackgroundTransparency = 1
CrosshairContainer.BorderSizePixel = 0
CrosshairContainer.ZIndex = 100
CrosshairContainer.Parent = ScreenGui

local TopLine = Instance.new("Frame")
TopLine.Name = "Top"
TopLine.Size = UDim2.new(0, 2, 0, 12)
TopLine.Position = UDim2.new(0.5, 0, 0.5, 0)
TopLine.AnchorPoint = Vector2.new(0.5, 0.5)
TopLine.BackgroundColor3 = Config.Color
TopLine.BorderSizePixel = 0
TopLine.ZIndex = 101
TopLine.Parent = CrosshairContainer

local BottomLine = Instance.new("Frame")
BottomLine.Name = "Bottom"
BottomLine.Size = UDim2.new(0, 2, 0, 12)
BottomLine.Position = UDim2.new(0.5, 0, 0.5, 0)
BottomLine.AnchorPoint = Vector2.new(0.5, 0.5)
BottomLine.BackgroundColor3 = Config.Color
BottomLine.BorderSizePixel = 0
BottomLine.ZIndex = 101
BottomLine.Parent = CrosshairContainer

local LeftLine = Instance.new("Frame")
LeftLine.Name = "Left"
LeftLine.Size = UDim2.new(0, 12, 0, 2)
LeftLine.Position = UDim2.new(0.5, 0, 0.5, 0)
LeftLine.AnchorPoint = Vector2.new(0.5, 0.5)
LeftLine.BackgroundColor3 = Config.Color
LeftLine.BorderSizePixel = 0
LeftLine.ZIndex = 101
LeftLine.Parent = CrosshairContainer

local RightLine = Instance.new("Frame")
RightLine.Name = "Right"
RightLine.Size = UDim2.new(0, 12, 0, 2)
RightLine.Position = UDim2.new(0.5, 0, 0.5, 0)
RightLine.AnchorPoint = Vector2.new(0.5, 0.5)
RightLine.BackgroundColor3 = Config.Color
RightLine.BorderSizePixel = 0
RightLine.ZIndex = 101
RightLine.Parent = CrosshairContainer

local CenterDot = Instance.new("Frame")
CenterDot.Name = "Dot"
CenterDot.Size = UDim2.new(0, 4, 0, 4)
CenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
CenterDot.BackgroundColor3 = Config.Color
CenterDot.BorderSizePixel = 0
CenterDot.ZIndex = 102
CenterDot.Parent = CrosshairContainer

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = CenterDot

local CircleFrame = Instance.new("Frame")
CircleFrame.Name = "Circle"
CircleFrame.Size = UDim2.new(0, 20, 0, 20)
CircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CircleFrame.BackgroundTransparency = 1
CircleFrame.BorderSizePixel = 0
CircleFrame.ZIndex = 100
CircleFrame.Parent = CrosshairContainer

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(0.5, 0)
CircleCorner.Parent = CircleFrame

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Config.Color
CircleStroke.Thickness = 2
CircleStroke.Parent = CircleFrame

local XLine1 = Instance.new("Frame")
XLine1.Name = "X1"
XLine1.Size = UDim2.new(0, 16, 0, 2)
XLine1.Position = UDim2.new(0.5, 0, 0.5, 0)
XLine1.AnchorPoint = Vector2.new(0.5, 0.5)
XLine1.BackgroundColor3 = Config.Color
XLine1.BorderSizePixel = 0
XLine1.Rotation = 45
XLine1.ZIndex = 101
XLine1.Parent = CrosshairContainer
XLine1.Visible = false

local XLine2 = Instance.new("Frame")
XLine2.Name = "X2"
XLine2.Size = UDim2.new(0, 16, 0, 2)
XLine2.Position = UDim2.new(0.5, 0, 0.5, 0)
XLine2.AnchorPoint = Vector2.new(0.5, 0.5)
XLine2.BackgroundColor3 = Config.Color
XLine2.BorderSizePixel = 0
XLine2.Rotation = -45
XLine2.ZIndex = 101
XLine2.Parent = CrosshairContainer
XLine2.Visible = false

local SymbolLabel = Instance.new("TextLabel")
SymbolLabel.Name = "Symbol"
SymbolLabel.Size = UDim2.new(0, 30, 0, 30)
SymbolLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
SymbolLabel.AnchorPoint = Vector2.new(0.5, 0.5)
SymbolLabel.BackgroundTransparency = 1
SymbolLabel.Text = ""
SymbolLabel.TextColor3 = Config.Color
SymbolLabel.TextSize = 20
SymbolLabel.Font = Enum.Font.GothamBold
SymbolLabel.ZIndex = 102
SymbolLabel.Parent = CrosshairContainer

local function AddOutline(frame)
    local s = Instance.new("UIStroke")
    s.Color = Config.OutlineColor
    s.Thickness = Config.OutlineThickness
    s.Parent = frame
    return s
end

local TopOutline = AddOutline(TopLine)
local BottomOutline = AddOutline(BottomLine)
local LeftOutline = AddOutline(LeftLine)
local RightOutline = AddOutline(RightLine)
local DotOutline = AddOutline(CenterDot)
local X1Outline = AddOutline(XLine1)
local X2Outline = AddOutline(XLine2)


local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsBtn"
SettingsBtn.Size = UDim2.new(0, 60, 0, 32)
SettingsBtn.Position = UDim2.new(0, 15, 0, 80) 
SettingsBtn.BackgroundColor3 = Theme.Surface
SettingsBtn.BackgroundTransparency = 0.1
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Text = "OPEN"
SettingsBtn.TextColor3 = Theme.Primary
SettingsBtn.TextSize = 14
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.ZIndex = 200
SettingsBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SettingsBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Theme.Primary
BtnStroke.Thickness = 1.5
BtnStroke.Transparency = 0.3
BtnStroke.Parent = SettingsBtn


local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(0, 170, 0, 240)
SettingsPanel.Position = UDim2.new(0, 80, 0, 80)
SettingsPanel.BackgroundColor3 = Theme.Background
SettingsPanel.BackgroundTransparency = 0.02
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ZIndex = 201
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = SettingsPanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Theme.Primary
PanelStroke.Thickness = 1.5
PanelStroke.Transparency = 0.25
PanelStroke.Parent = SettingsPanel


local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.BackgroundColor3 = Theme.Surface
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 202
TitleBar.Parent = SettingsPanel

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -25, 1, 0)
TitleText.Position = UDim2.new(0, 6, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "FRHUB CROSSHAIR CUSTOMIZE"
TitleText.TextColor3 = Theme.Primary
TitleText.TextSize = 8
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 203
TitleText.Parent = TitleBar

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(0.55, 0, 0, 1)
TitleLine.Position = UDim2.new(0, 6, 1, -1)
TitleLine.BackgroundColor3 = Theme.Primary
TitleLine.BorderSizePixel = 0
TitleLine.ZIndex = 203
TitleLine.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Position = UDim2.new(1, -20, 0, 1)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Danger
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 203
CloseBtn.Parent = TitleBar


local CatFrame = Instance.new("Frame")
CatFrame.Size = UDim2.new(1, -8, 0, 16)
CatFrame.Position = UDim2.new(0, 4, 0, 23)
CatFrame.BackgroundColor3 = Theme.Surface
CatFrame.BackgroundTransparency = 0.4
CatFrame.BorderSizePixel = 0
CatFrame.ZIndex = 202
CatFrame.Parent = SettingsPanel

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 4)
CatCorner.Parent = CatFrame

local CatScroll = Instance.new("ScrollingFrame")
CatScroll.Size = UDim2.new(1, 0, 1, 0)
CatScroll.BackgroundTransparency = 1
CatScroll.BorderSizePixel = 0
CatScroll.ScrollBarThickness = 0
CatScroll.ScrollingDirection = Enum.ScrollingDirection.X
CatScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
CatScroll.ZIndex = 203
CatScroll.Parent = CatFrame

local CatList = Instance.new("UIListLayout")
CatList.FillDirection = Enum.FillDirection.Horizontal
CatList.SortOrder = Enum.SortOrder.LayoutOrder
CatList.Padding = UDim.new(0, 2)
CatList.Parent = CatScroll


local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -8, 0, 14)
SearchBox.Position = UDim2.new(0, 4, 0, 42)
SearchBox.BackgroundColor3 = Theme.SurfaceLight
SearchBox.BackgroundTransparency = 0.3
SearchBox.BorderSizePixel = 0
SearchBox.Text = "Search..."
SearchBox.TextColor3 = Theme.TextDim
SearchBox.TextSize = 7
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = true
SearchBox.ZIndex = 202
SearchBox.Parent = SettingsPanel

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Theme.Primary
SearchStroke.Thickness = 1
SearchStroke.Transparency = 0.5
SearchStroke.Parent = SearchBox


local ListFrame = Instance.new("Frame")
ListFrame.Size = UDim2.new(1, -8, 0, 120)
ListFrame.Position = UDim2.new(0, 4, 0, 59)
ListFrame.BackgroundColor3 = Theme.Surface
ListFrame.BackgroundTransparency = 0.5
ListFrame.BorderSizePixel = 0
ListFrame.ZIndex = 202
ListFrame.Parent = SettingsPanel

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = ListFrame

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1, -4, 1, -4)
ListScroll.Position = UDim2.new(0, 2, 0, 2)
ListScroll.BackgroundTransparency = 1
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 2
ListScroll.ScrollBarImageColor3 = Theme.Primary
ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListScroll.ZIndex = 203
ListScroll.Parent = ListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)
ListLayout.Parent = ListScroll


local CustomFrame = Instance.new("Frame")
CustomFrame.Size = UDim2.new(1, -8, 0, 55)
CustomFrame.Position = UDim2.new(0, 4, 0, 182)
CustomFrame.BackgroundColor3 = Theme.Surface
CustomFrame.BackgroundTransparency = 0.4
CustomFrame.BorderSizePixel = 0
CustomFrame.ZIndex = 202
CustomFrame.Parent = SettingsPanel

local CustomCorner = Instance.new("UICorner")
CustomCorner.CornerRadius = UDim.new(0, 6)
CustomCorner.Parent = CustomFrame

local CustomTitle = Instance.new("TextLabel")
CustomTitle.Size = UDim2.new(1, 0, 0, 9)
CustomTitle.BackgroundTransparency = 1
CustomTitle.Text = "CUSTOMIZATION"
CustomTitle.TextColor3 = Theme.Secondary
CustomTitle.TextSize = 7
CustomTitle.Font = Enum.Font.GothamBold
CustomTitle.ZIndex = 203
CustomTitle.Parent = CustomFrame

local ColorBtn = Instance.new("TextButton")
ColorBtn.Size = UDim2.new(0, 25, 0, 12)
ColorBtn.Position = UDim2.new(0, 4, 0, 11)
ColorBtn.BackgroundColor3 = Config.Color
ColorBtn.BorderSizePixel = 0
ColorBtn.Text = "CLR"
ColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorBtn.TextSize = 6
ColorBtn.Font = Enum.Font.GothamBold
ColorBtn.ZIndex = 203
ColorBtn.Parent = CustomFrame

local ColorBtnCorner = Instance.new("UICorner")
ColorBtnCorner.CornerRadius = UDim.new(0, 3)
ColorBtnCorner.Parent = ColorBtn

local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(0, 13, 0, 9)
SizeLabel.Position = UDim2.new(0, 32, 0, 11)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Sz"
SizeLabel.TextColor3 = Theme.TextDim
SizeLabel.TextSize = 6
SizeLabel.Font = Enum.Font.Gotham
SizeLabel.ZIndex = 203
SizeLabel.Parent = CustomFrame

local SizeInput = Instance.new("TextBox")
SizeInput.Size = UDim2.new(0, 17, 0, 11)
SizeInput.Position = UDim2.new(0, 46, 0, 11)
SizeInput.BackgroundColor3 = Theme.SurfaceLight
SizeInput.BorderSizePixel = 0
SizeInput.Text = tostring(Config.Size)
SizeInput.TextColor3 = Theme.Text
SizeInput.TextSize = 7
SizeInput.Font = Enum.Font.Gotham
SizeInput.ZIndex = 203
SizeInput.Parent = CustomFrame

local SizeInputCorner = Instance.new("UICorner")
SizeInputCorner.CornerRadius = UDim.new(0, 3)
SizeInputCorner.Parent = SizeInput

local GapLabel = Instance.new("TextLabel")
GapLabel.Size = UDim2.new(0, 12, 0, 9)
GapLabel.Position = UDim2.new(0, 66, 0, 11)
GapLabel.BackgroundTransparency = 1
GapLabel.Text = "Gp"
GapLabel.TextColor3 = Theme.TextDim
GapLabel.TextSize = 6
GapLabel.Font = Enum.Font.Gotham
GapLabel.ZIndex = 203
GapLabel.Parent = CustomFrame

local GapInput = Instance.new("TextBox")
GapInput.Size = UDim2.new(0, 17, 0, 11)
GapInput.Position = UDim2.new(0, 79, 0, 11)
GapInput.BackgroundColor3 = Theme.SurfaceLight
GapInput.BorderSizePixel = 0
GapInput.Text = tostring(Config.Gap)
GapInput.TextColor3 = Theme.Text
GapInput.TextSize = 7
GapInput.Font = Enum.Font.Gotham
GapInput.ZIndex = 203
GapInput.Parent = CustomFrame

local GapInputCorner = Instance.new("UICorner")
GapInputCorner.CornerRadius = UDim.new(0, 3)
GapInputCorner.Parent = GapInput

local ThickLabel = Instance.new("TextLabel")
ThickLabel.Size = UDim2.new(0, 16, 0, 9)
ThickLabel.Position = UDim2.new(0, 99, 0, 11)
ThickLabel.BackgroundTransparency = 1
ThickLabel.Text = "Thk"
ThickLabel.TextColor3 = Theme.TextDim
ThickLabel.TextSize = 6
ThickLabel.Font = Enum.Font.Gotham
ThickLabel.ZIndex = 203
ThickLabel.Parent = CustomFrame

local ThickInput = Instance.new("TextBox")
ThickInput.Size = UDim2.new(0, 17, 0, 11)
ThickInput.Position = UDim2.new(0, 116, 0, 11)
ThickInput.BackgroundColor3 = Theme.SurfaceLight
ThickInput.BorderSizePixel = 0
ThickInput.Text = tostring(Config.Thickness)
ThickInput.TextColor3 = Theme.Text
ThickInput.TextSize = 7
ThickInput.Font = Enum.Font.Gotham
ThickInput.ZIndex = 203
ThickInput.Parent = CustomFrame

local ThickInputCorner = Instance.new("UICorner")
ThickInputCorner.CornerRadius = UDim.new(0, 3)
ThickInputCorner.Parent = ThickInput

local OffXLabel = Instance.new("TextLabel")
OffXLabel.Size = UDim2.new(0, 15, 0, 9)
OffXLabel.Position = UDim2.new(0, 4, 0, 25)
OffXLabel.BackgroundTransparency = 1
OffXLabel.Text = "X"
OffXLabel.TextColor3 = Theme.TextDim
OffXLabel.TextSize = 6
OffXLabel.Font = Enum.Font.Gotham
OffXLabel.ZIndex = 203
OffXLabel.Parent = CustomFrame

local OffXInput = Instance.new("TextBox")
OffXInput.Size = UDim2.new(0, 17, 0, 11)
OffXInput.Position = UDim2.new(0, 14, 0, 25)
OffXInput.BackgroundColor3 = Theme.SurfaceLight
OffXInput.BorderSizePixel = 0
OffXInput.Text = tostring(Config.OffsetX)
OffXInput.TextColor3 = Theme.Text
OffXInput.TextSize = 7
OffXInput.Font = Enum.Font.Gotham
OffXInput.ZIndex = 203
OffXInput.Parent = CustomFrame

local OffXInputCorner = Instance.new("UICorner")
OffXInputCorner.CornerRadius = UDim.new(0, 3)
OffXInputCorner.Parent = OffXInput

local OffYLabel = Instance.new("TextLabel")
OffYLabel.Size = UDim2.new(0, 15, 0, 9)
OffYLabel.Position = UDim2.new(0, 35, 0, 25)
OffYLabel.BackgroundTransparency = 1
OffYLabel.Text = "Y"
OffYLabel.TextColor3 = Theme.TextDim
OffYLabel.TextSize = 6
OffYLabel.Font = Enum.Font.Gotham
OffYLabel.ZIndex = 203
OffYLabel.Parent = CustomFrame

local OffYInput = Instance.new("TextBox")
OffYInput.Size = UDim2.new(0, 17, 0, 11)
OffYInput.Position = UDim2.new(0, 45, 0, 25)
OffYInput.BackgroundColor3 = Theme.SurfaceLight
OffYInput.BorderSizePixel = 0
OffYInput.Text = tostring(Config.OffsetY)
OffYInput.TextColor3 = Theme.Text
OffYInput.TextSize = 7
OffYInput.Font = Enum.Font.Gotham
OffYInput.ZIndex = 203
OffYInput.Parent = CustomFrame

local OffYInputCorner = Instance.new("UICorner")
OffYInputCorner.CornerRadius = UDim.new(0, 3)
OffYInputCorner.Parent = OffYInput

local OpacLabel = Instance.new("TextLabel")
OpacLabel.Size = UDim2.new(0, 18, 0, 9)
OpacLabel.Position = UDim2.new(0, 67, 0, 25)
OpacLabel.BackgroundTransparency = 1
OpacLabel.Text = "Op"
OpacLabel.TextColor3 = Theme.TextDim
OpacLabel.TextSize = 6
OpacLabel.Font = Enum.Font.Gotham
OpacLabel.ZIndex = 203
OpacLabel.Parent = CustomFrame

local OpacInput = Instance.new("TextBox")
OpacInput.Size = UDim2.new(0, 17, 0, 11)
OpacInput.Position = UDim2.new(0, 82, 0, 25)
OpacInput.BackgroundColor3 = Theme.SurfaceLight
OpacInput.BorderSizePixel = 0
OpacInput.Text = tostring(Config.Opacity)
OpacInput.TextColor3 = Theme.Text
OpacInput.TextSize = 7
OpacInput.Font = Enum.Font.Gotham
OpacInput.ZIndex = 203
OpacInput.Parent = CustomFrame

local OpacInputCorner = Instance.new("UICorner")
OpacInputCorner.CornerRadius = UDim.new(0, 3)
OpacInputCorner.Parent = OpacInput

local DotToggle = Instance.new("TextButton")
DotToggle.Size = UDim2.new(0, 25, 0, 11)
DotToggle.Position = UDim2.new(0, 4, 0, 39)
DotToggle.BackgroundColor3 = Config.Dot and Theme.Success or Theme.SurfaceLight
DotToggle.BorderSizePixel = 0
DotToggle.Text = "Dot"
DotToggle.TextColor3 = Theme.Text
DotToggle.TextSize = 6
DotToggle.Font = Enum.Font.GothamBold
DotToggle.ZIndex = 203
DotToggle.Parent = CustomFrame

local DotToggleCorner = Instance.new("UICorner")
DotToggleCorner.CornerRadius = UDim.new(0, 3)
DotToggleCorner.Parent = DotToggle

local OutlineToggle = Instance.new("TextButton")
OutlineToggle.Size = UDim2.new(0, 30, 0, 11)
OutlineToggle.Position = UDim2.new(0, 32, 0, 39)
OutlineToggle.BackgroundColor3 = Config.Outline and Theme.Success or Theme.SurfaceLight
OutlineToggle.BorderSizePixel = 0
OutlineToggle.Text = "Outln"
OutlineToggle.TextColor3 = Theme.Text
OutlineToggle.TextSize = 6
OutlineToggle.Font = Enum.Font.GothamBold
OutlineToggle.ZIndex = 203
OutlineToggle.Parent = CustomFrame

local OutlineToggleCorner = Instance.new("UICorner")
OutlineToggleCorner.CornerRadius = UDim.new(0, 3)
OutlineToggleCorner.Parent = OutlineToggle

local PulseToggle = Instance.new("TextButton")
PulseToggle.Size = UDim2.new(0, 28, 0, 11)
PulseToggle.Position = UDim2.new(0, 65, 0, 39)
PulseToggle.BackgroundColor3 = Config.Pulse and Theme.Success or Theme.SurfaceLight
PulseToggle.BorderSizePixel = 0
PulseToggle.Text = "Pulse"
PulseToggle.TextColor3 = Theme.Text
PulseToggle.TextSize = 6
PulseToggle.Font = Enum.Font.GothamBold
PulseToggle.ZIndex = 203
PulseToggle.Parent = CustomFrame

local PulseToggleCorner = Instance.new("UICorner")
PulseToggleCorner.CornerRadius = UDim.new(0, 3)
PulseToggleCorner.Parent = PulseToggle

local RotateToggle = Instance.new("TextButton")
RotateToggle.Size = UDim2.new(0, 30, 0, 11)
RotateToggle.Position = UDim2.new(0, 96, 0, 39)
RotateToggle.BackgroundColor3 = Config.Rotate and Theme.Success or Theme.SurfaceLight
RotateToggle.BorderSizePixel = 0
RotateToggle.Text = "Rotat"
RotateToggle.TextColor3 = Theme.Text
RotateToggle.TextSize = 6
RotateToggle.Font = Enum.Font.GothamBold
RotateToggle.ZIndex = 203
RotateToggle.Parent = CustomFrame

local RotateToggleCorner = Instance.new("UICorner")
RotateToggleCorner.CornerRadius = UDim.new(0, 3)
RotateToggleCorner.Parent = RotateToggle

local CurrentCategory = "All"
local RGBHue = 0
local PulseTime = 0
local RotAngle = 0

function UpdateCrosshair()
    if not Config.Enabled then
        CrosshairContainer.Visible = false
        return
    end

    CrosshairContainer.Visible = true

    local ch = Crosshairs[Config.CrosshairIndex]
    if not ch then return end

    if ch.Cat == "Gaming" and ch.Name:find("RGB") then
        RGBHue = (RGBHue + 0.02) % 1
        Config.Color = Color3.fromHSV(RGBHue, 1, 1)
    end

    local pulseMul = 1
    if Config.Pulse then
        PulseTime = PulseTime + 0.08
        pulseMul = 1 + math.sin(PulseTime) * 0.25
    end

    if Config.Rotate then
        RotAngle = (RotAngle + 2) % 360
    else
        RotAngle = 0
    end

    local len = (Config.Length * pulseMul)
    local gap = (Config.Gap * pulseMul)
    local thick = Config.Thickness
    local dotSize = (Config.DotSize * pulseMul)
    local color = Config.Color
    local outline = Config.Outline
    local offX = Config.OffsetX
    local offY = Config.OffsetY

    TopLine.BackgroundColor3 = color
    BottomLine.BackgroundColor3 = color
    LeftLine.BackgroundColor3 = color
    RightLine.BackgroundColor3 = color
    CenterDot.BackgroundColor3 = color
    XLine1.BackgroundColor3 = color
    XLine2.BackgroundColor3 = color
    CircleStroke.Color = color
    SymbolLabel.TextColor3 = color

    TopOutline.Thickness = outline and Config.OutlineThickness or 0
    BottomOutline.Thickness = outline and Config.OutlineThickness or 0
    LeftOutline.Thickness = outline and Config.OutlineThickness or 0
    RightOutline.Thickness = outline and Config.OutlineThickness or 0
    DotOutline.Thickness = outline and Config.OutlineThickness or 0
    X1Outline.Thickness = outline and Config.OutlineThickness or 0
    X2Outline.Thickness = outline and Config.OutlineThickness or 0

    local op = Config.Opacity
    TopLine.BackgroundTransparency = 1 - op
    BottomLine.BackgroundTransparency = 1 - op
    LeftLine.BackgroundTransparency = 1 - op
    RightLine.BackgroundTransparency = 1 - op
    CenterDot.BackgroundTransparency = 1 - op
    XLine1.BackgroundTransparency = 1 - op
    XLine2.BackgroundTransparency = 1 - op
    CircleStroke.Transparency = 1 - op
    SymbolLabel.TextTransparency = 1 - op

    SymbolLabel.Text = ch.S or ""
    SymbolLabel.Visible = ch.S and ch.S ~= ""

    if SymbolLabel.Visible then
        SymbolLabel.TextSize = dotSize * 6
        SymbolLabel.Position = UDim2.new(0.5, offX, 0.5, offY)
        TopLine.Visible = false
        BottomLine.Visible = false
        LeftLine.Visible = false
        RightLine.Visible = false
        CenterDot.Visible = false
        XLine1.Visible = false
        XLine2.Visible = false
        CircleFrame.Visible = false
        CrosshairContainer.Rotation = RotAngle
        return
    end

    TopLine.Visible = ch.L[1] == 1
    TopLine.Size = UDim2.new(0, thick, 0, len)
    TopLine.Position = UDim2.new(0.5, offX, 0.5, offY - gap - len/2)

    BottomLine.Visible = ch.L[2] == 1
    BottomLine.Size = UDim2.new(0, thick, 0, len)
    BottomLine.Position = UDim2.new(0.5, offX, 0.5, offY + gap + len/2)

    LeftLine.Visible = ch.L[3] == 1
    LeftLine.Size = UDim2.new(0, len, 0, thick)
    LeftLine.Position = UDim2.new(0.5, offX - gap - len/2, 0.5, offY)

    RightLine.Visible = ch.L[4] == 1
    RightLine.Size = UDim2.new(0, len, 0, thick)
    RightLine.Position = UDim2.new(0.5, offX + gap + len/2, 0.5, offY)

    CenterDot.Visible = ch.D and Config.Dot
    CenterDot.Size = UDim2.new(0, dotSize, 0, dotSize)
    CenterDot.Position = UDim2.new(0.5, offX, 0.5, offY)

    XLine1.Visible = ch.X
    XLine2.Visible = ch.X
    if ch.X then
        local diag = len * 1.4
        XLine1.Size = UDim2.new(0, diag, 0, thick)
        XLine1.Position = UDim2.new(0.5, offX, 0.5, offY)
        XLine2.Size = UDim2.new(0, diag, 0, thick)
        XLine2.Position = UDim2.new(0.5, offX, 0.5, offY)
    end

    CircleFrame.Visible = ch.C
    if ch.C then
        local cr = (ch.CR > 0 and ch.CR or 10) * pulseMul
        CircleFrame.Size = UDim2.new(0, cr * 2, 0, cr * 2)
        CircleFrame.Position = UDim2.new(0.5, offX, 0.5, offY)
        CircleStroke.Thickness = thick
    end

    CrosshairContainer.Rotation = RotAngle
end

local CatButtons = {}
local ChButtons = {}

function GetCategories()
    local cats = {["All"] = true}
    for _, ch in pairs(Crosshairs) do
        cats[ch.Cat] = true
    end
    return cats
end

function CreateCategoryButtons()
    for cat, _ in pairs(GetCategories()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 35, 0, 13)
        btn.BackgroundColor3 = (cat == CurrentCategory) and Theme.Primary or Theme.SurfaceLight
        btn.BackgroundTransparency = (cat == CurrentCategory) and 0.2 or 0.5
        btn.BorderSizePixel = 0
        btn.Text = cat
        btn.TextColor3 = Theme.Text
        btn.TextSize = 6
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 204
        btn.Parent = CatScroll

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 3)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Primary
        stroke.Thickness = (cat == CurrentCategory) and 1.5 or 0
        stroke.Transparency = 0.3
        stroke.Parent = btn

        btn.MouseButton1Click:Connect(function()
            CurrentCategory = cat
            for _, b in pairs(CatButtons) do
                b.BackgroundColor3 = Theme.SurfaceLight
                b.BackgroundTransparency = 0.5
                b:FindFirstChildOfClass("UIStroke").Thickness = 0
            end
            btn.BackgroundColor3 = Theme.Primary
            btn.BackgroundTransparency = 0.2
            stroke.Thickness = 1.5
            RefreshList()
        end)

        table.insert(CatButtons, btn)
    end
end

function RefreshList()
    for _, c in pairs(ListScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    ChButtons = {}

    local search = SearchBox.Text:lower()
    if search == "search..." then search = "" end

    for i, ch in pairs(Crosshairs) do
        if (CurrentCategory == "All" or ch.Cat == CurrentCategory) and
           (search == "" or ch.Name:lower():find(search)) then

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 15)
            btn.BackgroundColor3 = (i == Config.CrosshairIndex) and Theme.Primary or Theme.Surface
            btn.BackgroundTransparency = (i == Config.CrosshairIndex) and 0.3 or 0.6
            btn.BorderSizePixel = 0
            btn.Text = "  " .. ch.Name
            btn.TextColor3 = Theme.Text
            btn.TextSize = 7
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.Gotham
            btn.LayoutOrder = i
            btn.ZIndex = 204
            btn.Parent = ListScroll

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = btn

            local stroke = Instance.new("UIStroke")
            stroke.Color = Theme.Primary
            stroke.Thickness = (i == Config.CrosshairIndex) and 1.5 or 0
            stroke.Transparency = 0.3
            stroke.Parent = btn

            local catTag = Instance.new("TextLabel")
            catTag.Size = UDim2.new(0, 28, 0, 8)
            catTag.Position = UDim2.new(1, -30, 0, 4)
            catTag.BackgroundColor3 = Theme.SurfaceLight
            catTag.BackgroundTransparency = 0.3
            catTag.BorderSizePixel = 0
            catTag.Text = ch.Cat
            catTag.TextColor3 = Theme.TextDim
            catTag.TextSize = 5
            catTag.Font = Enum.Font.Gotham
            catTag.ZIndex = 205
            catTag.Parent = btn

            local tagCorner = Instance.new("UICorner")
            tagCorner.CornerRadius = UDim.new(0, 2)
            tagCorner.Parent = catTag

            btn.MouseButton1Click:Connect(function()
                Config.CrosshairIndex = i
                for _, b in pairs(ChButtons) do
                    b.BackgroundColor3 = Theme.Surface
                    b.BackgroundTransparency = 0.6
                    b:FindFirstChildOfClass("UIStroke").Thickness = 0
                end
                btn.BackgroundColor3 = Theme.Primary
                btn.BackgroundTransparency = 0.3
                stroke.Thickness = 1.5
            end)

            table.insert(ChButtons, btn)
        end
    end
end

SettingsBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = false
end)

local drag, dragStart, startPos = false, nil, nil

SettingsBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = input.Position
        startPos = SettingsBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        SettingsBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        SettingsPanel.Position = UDim2.new(0, startPos.X.Offset + delta.X + 65, 0, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

SearchBox.FocusLost:Connect(RefreshList)

ColorBtn.MouseButton1Click:Connect(function()
    local colors = {
        Theme.Primary, Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 150, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(50, 255, 50), Color3.fromRGB(100, 100, 255), Color3.fromRGB(255, 200, 0),
        Color3.fromRGB(0, 255, 150), Color3.fromRGB(255, 0, 100), Color3.fromRGB(100, 255, 255)
    }
    for i, c in pairs(colors) do
        if c == Config.Color then
            Config.Color = colors[(i % #colors) + 1]
            ColorBtn.BackgroundColor3 = Config.Color
            return
        end
    end
    Config.Color = colors[1]
    ColorBtn.BackgroundColor3 = Config.Color
end)

SizeInput.FocusLost:Connect(function()
    local v = tonumber(SizeInput.Text)
    if v then Config.Length = math.clamp(v, 1, 50) end
    SizeInput.Text = tostring(Config.Length)
end)

GapInput.FocusLost:Connect(function()
    local v = tonumber(GapInput.Text)
    if v then Config.Gap = math.clamp(v, 0, 30) end
    GapInput.Text = tostring(Config.Gap)
end)

ThickInput.FocusLost:Connect(function()
    local v = tonumber(ThickInput.Text)
    if v then Config.Thickness = math.clamp(v, 0.5, 10) end
    ThickInput.Text = tostring(Config.Thickness)
end)

OffXInput.FocusLost:Connect(function()
    local v = tonumber(OffXInput.Text)
    if v then Config.OffsetX = math.clamp(v, -200, 200) end
    OffXInput.Text = tostring(Config.OffsetX)
end)

OffYInput.FocusLost:Connect(function()
    local v = tonumber(OffYInput.Text)
    if v then Config.OffsetY = math.clamp(v, -200, 200) end
    OffYInput.Text = tostring(Config.OffsetY)
end)

OpacInput.FocusLost:Connect(function()
    local v = tonumber(OpacInput.Text)
    if v then Config.Opacity = math.clamp(v, 0.1, 1) end
    OpacInput.Text = tostring(Config.Opacity)
end)

DotToggle.MouseButton1Click:Connect(function()
    Config.Dot = not Config.Dot
    DotToggle.BackgroundColor3 = Config.Dot and Theme.Success or Theme.SurfaceLight
end)

OutlineToggle.MouseButton1Click:Connect(function()
    Config.Outline = not Config.Outline
    OutlineToggle.BackgroundColor3 = Config.Outline and Theme.Success or Theme.SurfaceLight
end)

PulseToggle.MouseButton1Click:Connect(function()
    Config.Pulse = not Config.Pulse
    PulseToggle.BackgroundColor3 = Config.Pulse and Theme.Success or Theme.SurfaceLight
end)

RotateToggle.MouseButton1Click:Connect(function()
    Config.Rotate = not Config.Rotate
    RotateToggle.BackgroundColor3 = Config.Rotate and Theme.Success or Theme.SurfaceLight
end)

CreateCategoryButtons()
RefreshList()

RunService.RenderStepped:Connect(UpdateCrosshair)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.ButtonSelect then
        SettingsPanel.Visible = not SettingsPanel.Visible
    elseif input.KeyCode == Enum.KeyCode.Delete then
        Config.Enabled = not Config.Enabled
    end
end)

local lastTap = 0
UserInputService.TouchTapInWorld:Connect(function(position, processed)
    if processed then return end
    if position.X < 100 and position.Y < 100 then
        local now = tick()
        if now - lastTap < 0.3 then
            SettingsPanel.Visible = not SettingsPanel.Visible
        end
        lastTap = now
    end
end)
