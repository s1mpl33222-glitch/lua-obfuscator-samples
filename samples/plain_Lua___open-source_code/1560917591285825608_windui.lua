RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
Players = game:GetService("Players")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
UIS = game:GetService("UserInputService")
LocalPlayer = Players.LocalPlayer
CONFIG_FILE = "RJR_NEW_C.json"

local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089


local ConfigTransient = {
    SelectPly    = true,
    TeleportPly  = true,
    SpectatePlys = true,
}

local Defaults = {
    FastAttackMode          = "模式2(部分账号失效用)",
    FastAttackMobs          = true,
    FastAttackPlayers       = true,
    GunM1Mobs               = false,
    GunM1Players            = false,
    M1FireInterval          = 0.2,
    FruitM1                 = false,
    VoidFruitM1             = false,
    AutoHaki                = false,
    AutoKen                 = false,
    AutoV3                  = false,
    AutoV4                  = false,
    AutoFlee                = false,
    AutoFleeHP              = 30,
    RaidChip                = "Flame",
    AutoSoru                = false,

    translateSpeed          = 50,
    translateAccel          = false,
    jumpHeight              = 50,
    jumpEnabled             = false,
    InfiniteJump            = false,
    Fly                     = false,
    FlySpeed                = 50,
    Noclip                  = false,
    BoatNoclip              = false,
    DashLengthEnabled       = false,
    DashLength              = 5,
    DodgeNoCooldown         = false,
    WalkOnWater             = false,
    RemoveWater             = false,

    ESPEnabled              = true,
    ESP_Name                = true,
    ESP_Level               = true,
    ESP_Bounty              = true,
    ESP_Fruit               = true,
    ESP_Distance            = true,
    ESP_HP                  = true,
    ESP_TextSize            = 14,
    ESP_Highlight           = false,
    ESP_HighlightColor      = "FF0000",
    ESP_Layout              = "经典",
    ESP_Avatar              = false,
    ESP_AvatarSide          = "右边",
    ESP_NameColor           = "FFFF00",
    ESP_LevelColor          = "00FF00",
    ESP_BountyColor         = "FFD700",
    ESP_FruitColor          = "FF69B4",
    ESP_DistanceColor       = "00FFFF",
    ESP_HPColor             = "FF5555",

    currentZoom             = 0,
    RemoveLava              = false,
    RemoveFog               = false,
    ClickJump               = false,
    BringMobs               = false,

    TeleportOffsetX         = 0,
    TeleportOffsetY         = 0,
    TeleportOffsetZ         = 0,
    SelectPly               = "",
    TeleportPly             = false,
    SpectatePlys            = false,
    Lock2                   = false,
    TweenNearest            = false,
    TweenSpeed              = 180,
    LockHotkey              = false,
    LockHotkeyKey           = "H",

    SilentAimM1R            = false,
    SilentAimSkill          = false,
    SilentAimSkills         = {"Z", "X", "C", "V", "F"},
    SilentAimShowFOV        = false,
    SilentAimFOV            = 100,
    SilentAimPart           = "Head",
    SilentAimFOVThickness   = 2,
    SilentAimFOVTransparency = 1,
    SilentAimTargetPlayers  = false,
    SilentAimTargetMobs     = false,
    SilentAimShowLine       = false,
    SilentAimFOVMode        = "跟随鼠标",
    SilentAimTeamCheck      = false,
    SilentAimExcludePVP     = false,
    SilentAimExcludeSafeZone = false,
    SilentAimMethod         = "鼠标最近的玩家",

    ServerRegion            = "Singapore",
    HopPlayerRange          = "1-12",
    HopBountyRange          = "大于3m",
    HopMinPlayers           = 1,
    HopMaxPlayers           = 12,
    HopMinBounty            = 3000001,
    HopMaxBounty            = 999999999,
    Theme                   = "Light",
}

for key, defaultValue in pairs(Defaults) do
    if _G[key] == nil then
        _G[key] = defaultValue
    end
end

local ConfigKeys = {}
for key in pairs(Defaults) do
    if not ConfigTransient[key] then
        ConfigKeys[#ConfigKeys + 1] = key
    end
end
table.sort(ConfigKeys)

local ConfigDirty = false
local ConfigSaving = false
local ConfigReady = false
local ConfigLoadedData = {}

local function EnsureConfigFolder()
    if typeof(isfolder) == "function" and typeof(makefolder) == "function" then
        local dir = CONFIG_FILE:match("^(.-)/[^/]+$")
        if dir and not isfolder(dir) then
            makefolder(dir)
        end
        return true
    end
    return false
end

local function DeepCopy(value)
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for k, v in pairs(value) do
        copy[k] = DeepCopy(v)
    end
    return copy
end

local function CollectConfig()
    local data = {}
    for _, key in ipairs(ConfigKeys) do
        local value = _G[key]
        if value ~= nil then
            data[key] = DeepCopy(value)
        end
    end
    return data
end

local function ApplyConfigData(data)
    if type(data) ~= "table" then
        return
    end
    for _, key in ipairs(ConfigKeys) do
        if data[key] ~= nil then
            _G[key] = DeepCopy(data[key])
        end
    end
end

local function SaveConfig(force)
    if ConfigSaving then
        return false
    end
    if not force and not ConfigDirty then
        return false
    end
    if typeof(writefile) ~= "function" then
        return false
    end
    ConfigSaving = true
    local ok = pcall(function()
        EnsureConfigFolder()
        local payload = CollectConfig()
        writefile(CONFIG_FILE, HttpService:JSONEncode(payload))
    end)
    if ok then
        ConfigDirty = false
    end
    ConfigSaving = false
    return ok
end

local function QueueSaveConfig()
    if not ConfigReady then
        return
    end
    ConfigDirty = true
end

local function SaveConfiguration()
    QueueSaveConfig()
end

local function MigrateLegacyKeys(data)
    local migrated = false
    for _, key in ipairs(ConfigKeys) do
        if data[key] == nil then
            local legacy = data["G_" .. key]
            if legacy ~= nil then
                data[key] = legacy
                migrated = true
            end
        end
    end
    if migrated then
        for _, key in ipairs(ConfigKeys) do
            data["G_" .. key] = nil
        end
    end
    return migrated
end

local function MigrateAuraKeys(data)
    local migrated = false
    local function ReadOld(name)
        local v = data[name]
        if v == nil then v = data["G_" .. name] end
        return v
    end
    local function Seed(newKey, value)
        if data[newKey] == nil and value ~= nil then
            data[newKey] = value
            migrated = true
        end
    end

    local oldMobs = ReadOld("AttackMobs")
    local oldPlayers = ReadOld("AttackPlayers")
    local fastMobs, fastPlayers = oldMobs, oldPlayers
    if ReadOld("FastAttack") == false then
        fastMobs, fastPlayers = false, false
    end
    local gunMobs, gunPlayers = oldMobs, oldPlayers
    if ReadOld("DragonGunM1") == false then
        gunMobs, gunPlayers = false, false
    end

    Seed("FastAttackMobs", fastMobs)
    Seed("FastAttackPlayers", fastPlayers)
    Seed("GunM1Mobs", gunMobs)
    Seed("GunM1Players", gunPlayers)
    for _, name in ipairs({ "FastAttack", "AttackMobs", "AttackPlayers", "DragonGunM1" }) do
        if data[name] ~= nil then data[name] = nil migrated = true end
        if data["G_" .. name] ~= nil then data["G_" .. name] = nil migrated = true end
    end
    return migrated
end

local function LoadConfig()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
        return false
    end
    if not isfile(CONFIG_FILE) then
        return false
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not ok or type(data) ~= "table" then
        return false
    end
    local migrated = MigrateLegacyKeys(data)
    if MigrateAuraKeys(data) then migrated = true end
    if migrated then
        ConfigDirty = true
    end
    ConfigLoadedData = data
    ApplyConfigData(data)
    return true
end

LoadConfig()
ConfigReady = true

task.spawn(function()
    local lastRaw = nil
    while task.wait(1) do
        if not ConfigReady then
            continue
        end
        local ok, raw = pcall(function()
            return HttpService:JSONEncode(CollectConfig())
        end)
        if ok and raw then
            if raw ~= lastRaw then
                lastRaw = raw
                ConfigDirty = true
            end
        end
        if ConfigDirty then
            SaveConfig(true)
        end
    end
end)

local Translations = {
    ["人挤人中心"] = "RJR",
    ["主要功能"] = "Main",
    ["杀戮光环"] = "Aura",
    ["ESP"] = "ESP",
    ["FOV"] = "ESP Draw",
    ["绘制"] = "ESP Draw",
    ["传送"] = "Teleport",
    ["杂项"] = "Misc",
    ["服务器"] = "Server",
    ["设置"] = "Settings",
    ["商店"] = "Shop",
    ["公告"] = "Announcement",

    ["快速攻击模式"] = "Fast Attack Mode",
    ["快速攻击攻击怪物"] = "Fast Attack Mobs",
    ["快速攻击攻击玩家"] = "Fast Attack Players",
    ["枪械m1攻击怪物"] = "Gun M1 Mobs",
    ["枪械m1攻击玩家"] = "Gun M1 Players",
    ["枪械 m1 发射间隔"] = "Gun M1 Fire Interval",
    ["果实m1"] = "Fruit M1",
    ["虚空果实m1"] = "Void Fruit M1",
    ["模式1"] = "Mode 1",
    ["模式2(部分账号失效用)"] = "Mode 2 (fails on some accounts)",
    ["聚怪"] = "Mob Gather",

    ["移动速度"] = "Move Speed",
    ["加速开关"] = "Speed Boost",
    ["跳跃高度"] = "Jump Height",
    ["高跳开启"] = "High Jump",
    ["无限跳跃"] = "Infinite Jump",
    ["穿墙"] = "Noclip",
    ["船穿墙"] = "Boat Noclip",
    ["飞行"] = "Fly",
    ["飞行速度"] = "Fly Speed",
    ["自动武装色"] = "Auto Haki",
    ["自动见闻色"] = "Auto Ken",
    ["自动 V3"] = "Auto V3",
    ["自动 V4"] = "Auto V4",
    ["自动瞬步"] = "Auto Soru",
    ["逃跑血量阈值(%)"] = "Flee HP Threshold (%)",

    ["ESP 开关"] = "ESP Toggle",
    ["显示玩家名字"] = "Show Player Name",
    ["显示玩家等级"] = "Show Player Level",
    ["显示玩家赏金"] = "Show Bounty",
    ["显示恶魔果实"] = "Show Fruit",
    ["显示距离"] = "Show Distance",
    ["显示血量"] = "Show HP",
    ["高亮显示玩家"] = "Highlight Players",
    ["高亮颜色"] = "Highlight Color",
    ["ESP 字体大小"] = "ESP Text Size",
    ["ESP 排版"] = "ESP Layout",
    ["经典"] = "Classic",
    ["血条样式"] = "HP Bar Style",
    ["名字颜色"] = "Name Color",
    ["等级颜色"] = "Level Color",
    ["赏金颜色"] = "Bounty Color",
    ["果实颜色"] = "Fruit Color",
    ["距离颜色"] = "Distance Color",
    ["血量颜色"] = "HP Color",
    ["显示玩家头像"] = "Show Player Avatar",
    ["头像位置"] = "Avatar Position",
    ["左边"] = "Left",
    ["右边"] = "Right",

    ["视角缩放距离"] = "Camera Zoom",
    ["冲刺无冷却"] = "Dodge No Cooldown",
    ["冲刺距离修改开关"] = "Dash Length Toggle",
    ["冲刺距离"] = "Dash Length",
    ["减画质"] = "Reduce Graphics",
    ["移除岩浆 (需重进恢复)"] = "Remove Lava (rejoin to restore)",
    ["移除雾 (需重进恢复)"] = "Remove Fog (rejoin to restore)",
    ["水上行走"] = "Walk on Water",
    ["删除水面"] = "Remove Water Surface",
    ["解帧数限制 (仅电脑)"] = "Unlock FPS (PC only)",
    ["左键位移"] = "Left-Click Dash",

    ["选择目标玩家"] = "Select Target Player",
    ["刷新玩家列表"] = "Refresh Player List",
    ["观战玩家"] = "Spectate Player",
    ["平滑传送至玩家"] = "Tween TP to Player",
    ["统一传送速度"] = "Tween Speed",
    ["锁人2"] = "Lock 2",
    ["传送至最近玩家"] = "TP to Nearest Player",
    ["锁人2开启"] = "Lock 2 Started",
    ["锁人2关闭"] = "Lock 2 Stopped",
    ["最近玩家传送开启"] = "Nearest TP Started",
    ["最近玩家传送关闭"] = "Nearest TP Stopped",
    ["已停止锁定目标"] = "Stopped locking target",
    ["平滑追踪目标，近距离自动锁定"] = "Smooth chase, auto lock when close",
    ["平滑追踪最近的玩家"] = "Smoothly chases the nearest player",
    ["X轴偏移"] = "X Offset",
    ["Y轴偏移"] = "Y Offset",
    ["Z轴偏移"] = "Z Offset",
    ["快捷传送点"] = "Quick TP Point",
    ["豪宅"] = "Mansion",
    ["天鹅房间"] = "Swan Room",
    ["鬼船"] = "Ship Inside",
    ["僵尸岛"] = "Ship Outside",
    ["海洋城堡"] = "Castle of the Sea",
    ["海龟豪宅"] = "Turtle Mansion",
    ["司法"] = "Justice",
    ["九头蛇"] = "Hydra",

    ["自瞄范围设置"] = "Aimbot Range Settings",
    ["显示 FOV 范围"] = "Show FOV Range",
    ["FOV 位置"] = "FOV Position",
    ["FOV 半径大小"] = "FOV Radius",
    ["FOV 范围颜色"] = "FOV Range Color",
    ["自瞄设置"] = "Aimbot Settings",
    ["M1 自瞄"] = "M1 Aimbot",
    ["技能自瞄"] = "Skill Aimbot",
    ["指定技能自瞄"] = "Aimbot Skills",
    ["瞄准玩家"] = "Target Players",
    ["瞄准 NPC"] = "Target NPCs",
    ["团队检测"] = "Team Check",
    ["排除未开启pvp"] = "Exclude PvP Disabled",
    ["排除安全区"] = "Exclude Safe Zone",
    ["显示锁定红线"] = "Show Lock Line",
    ["瞄准部位"] = "Target Part",
    ["静默瞄准方法"] = "Silent Aim Method",
    ["鼠标最近的玩家"] = "Closest to Mouse",
    ["最近的玩家"] = "Closest Player",
    ["选择玩家"] = "Selected Player",
    ["跟随鼠标"] = "Follow Mouse",
    ["屏幕中心"] = "Screen Center",

    ["快捷键锁人"] = "Hotkey Lock",
    ["锁人快捷键"] = "Lock Hotkey",
    ["快捷锁人"] = "Quick Hotkey Lock",
    ["未锁定"] = "Not Locked",
    ["距离: "] = "Distance: ",
    ["米"] = "m",
    ["快捷键: "] = "Hotkey: ",
    ["按下按键开始锁定"] = "Press the key to lock",
    ["解除锁定"] = "Unlock",
    ["开始锁定"] = "Start Lock",
    ["正在锁人: "] = "Locking: ",
    ["正在锁人..."] = "Locking...",
    ["环绕锁人"] = "Orbit Lock",
    ["M1 R 自瞄"] = "M1 R Aimbot",
    ["选择瞄准玩家"] = "Select Aimbot Player",

    ["重置数据"] = "Reset Stats",
    ["重置种族"] = "Reroll Race",
    ["切换海盗"] = "Join Pirates",
    ["切换海军"] = "Join Marines",
    ["更换吸血鬼"] = "Change to Ghoul",
    ["更换机器人"] = "Change to Cyborg",

    ["重进服务器"] = "Rejoin Server",
    ["选择服务器区域"] = "Select Server Region",
    ["跳服时搜索的服务器区域"] = "Server region used when hopping",
    ["跳服时过滤人数范围"] = "Player-count range filter when hopping",
    ["跳服时过滤赏金范围"] = "Bounty range filter when hopping",
    ["选择人数"] = "Select Players",
    ["人数设置"] = "Players Setting",
    ["选择赏金"] = "Select Bounty",
    ["赏金设置"] = "Bounty Setting",
    ["跳服"] = "Server Hop",
    ["服务器id"] = "Server ID",
    ["输入服务器id"] = "Enter Server ID",
    ["加入服务器 id"] = "Join Server ID",
    ["自动跳服"] = "Auto Server Hop",
    ["准备跳服..."] = "Preparing server hop...",
    ["设置区域为: "] = "Region set to: ",
    ["区域设置"] = "Region Settings",
    ["已切换为: "] = "Switched to: ",
    ["跳服失败"] = "Server hop failed",
    ["请重新加入游戏"] = "Please rejoin the game",
    ["匹配到服务器"] = "Matched Server",
    ["未找到匹配的服务器"] = "No matching server found",
    ["地区: "] = "Region: ",
    ["人数: "] = "Players: ",
    ["赏金: "] = "Bounty: ",
    ["大于3m"] = ">3M",
    ["大于5m"] = ">5M",
    ["大于10m"] = ">10M",
    ["大于15m"] = ">15M",
    ["大于25m"] = ">25M",
    ["大于35m"] = ">35M",
    ["大于50m"] = ">50M",

    ["窗口切换键"] = "Toggle Window Key",
    ["切换窗口显示状态"] = "Toggle window visibility",
    ["选择主题"] = "Select Theme",
    ["保存配置"] = "Save Config",
    ["加载配置"] = "Load Config",
    ["加载完成"] = "Loaded",
    ["自动保存已开启"] = "Auto Save On",

    ["DC 服务器"] = "DC Server",
    ["点击复制 DC 链接"] = "Click to copy DC link",
    ["已复制 DC 链接"] = "DC link copied",
    ["宣传图"] = "Banner",
    ["声明"] = "Disclaimer",
    ["此脚本完全免费开源 禁止拿去圈钱"] = "This script is free and open source. Do not sell it.",
    ["点击复制"] = "Click to copy",
    ["已复制链接"] = "Link copied",

    ["自动逃跑/袭击"] = "Auto Flee / Raid",
    ["取出果实: 已取出 "] = "Unstore fruit: took out ",
    ["取出果实: 取出失败"] = "Unstore fruit: failed to take one out",
    ["副本: 召唤袭击"] = "Raid: summoning",
    ["副本: 未找到袭击按钮"] = "Raid: summon button not found",
    ["副本: 召唤失败"] = "Raid: summon failed",
    ["副本: 没有袭击芯片"] = "Raid: no raid chip",

    ["复制成功"] = "Copied",
    ["已复制当前服务器ID"] = "Current server ID copied",
    ["操作失败"] = "Operation Failed",
    ["请先输入服务器ID"] = "Please enter server ID first",
    ["请先选择目标玩家"] = "Select target player first",
    ["已设置为"] = "Set to",
    ["未授权"] = "Unauthorized",
    ["该功能仅限授权用户"] = "Authorized users only",
    ["观战中断"] = "Spectate Interrupted",
    ["观战结束"] = "Spectate Ended",
    ["目标玩家不存在/角色消失"] = "Target player not found",
    ["已恢复本地视角"] = "Camera restored",
    ["传送开启"] = "Teleport Started",
    ["传送关闭"] = "Teleport Stopped",
    ["已开始传送玩家（偏移X:"] = "Started teleporting player (offset X:",
    ["已停止传送目标玩家"] = "Stopped teleporting to target",

    ["开始"] = "Start",
    ["停止"] = "Stop",
    ["加速"] = "Speed Up",
    ["减速"] = "Slow Down",
    ["关闭"] = "Close",
    ["隐藏"] = "Hide",
    ["显示"] = "Show",

    ["水果: "] = "Fruit: ",
    ["生命 "] = "HP ",
    ["海军"] = "Marine",
    ["海贼"] = "Pirate",
    ["⚔ PVP已开启 "] = "⚔ PvP On ",
    ["PvP已关闭 "] = "PvP Off ",
}

local ActiveLanguage = "Chinese"
do
    local requested
    if typeof(getgenv) == "function" then
        local ok, env = pcall(getgenv)
        if ok and type(env) == "table" then
            requested = env.Language
        end
    end
    if requested == nil then
        requested = _G.Language
    end
    if type(requested) == "string" then
        local normalized = requested:lower()
        if normalized == "english" or normalized == "en" or requested == "英文" then
            ActiveLanguage = "English"
        end
    end
end

local function L(text)
    if ActiveLanguage == "English" then
        local translated = Translations[text]
        if translated ~= nil then
            return translated
        end
    end
    return text
end

_G.FOVMode = _G.SilentAimFOVMode or "跟随鼠标"
local WindUI = loadstring(request({
    Url = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
}).Body)()
local availableThemesCheck = WindUI:GetThemes()
if not availableThemesCheck[_G.Theme] then
    _G.Theme = "Dark"
end
WindUI:SetTheme(_G.Theme)
local Window = WindUI:CreateWindow({
    Title = L("人挤人中心"),
    Icon = "",
    Author = "by kismile",
    Folder = "WindUI",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = _G.Theme,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,
    OpenButton = {
        Title = "RJR",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        OnlyMobile = false,
        Draggable = true,
        OnlyIcon = false,
        Color = ColorSequence.new(
            Color3.fromHex("#FF4444"),
            Color3.fromHex("#FF8800")
        ),
    },
    ToggleKey = Enum.KeyCode.G,
})
local Tabs = {
    [L("主要功能")] = Window:Section({ Title = L("主要功能"), Opened = true }),
    [L("设置")] = Window:Section({ Title = L("设置"), Opened = true }),
}
local RJR = {
    [L("公告")]     = Tabs[L("主要功能")]:Tab({ Title = L("公告"), Icon = "bell" }),
    [L("主要功能")] = Tabs[L("主要功能")]:Tab({ Title = L("主要功能"), Icon = "zap" }),
    [L("杀戮光环")] = Tabs[L("主要功能")]:Tab({ Title = L("杀戮光环"), Icon = "sword" }),
    ["ESP"]     = Tabs[L("主要功能")]:Tab({ Title = "ESP", Icon = "eye" }),
    [L("绘制")]     = Tabs[L("主要功能")]:Tab({ Title = L("FOV"), Icon = "pen-tool" }),
    [L("传送")]     = Tabs[L("主要功能")]:Tab({ Title = L("传送"), Icon = "users" }),
    [L("杂项")]     = Tabs[L("主要功能")]:Tab({ Title = L("杂项"), Icon = "list" }),
    [L("商店")]     = Tabs[L("主要功能")]:Tab({ Title = L("商店"), Icon = "shopping-cart" }),
    [L("服务器")]   = Tabs[L("设置")]:Tab({ Title = L("服务器"), Icon = "server" }),
    [L("设置")]     = Tabs[L("设置")]:Tab({ Title = L("设置"), Icon = "settings" }),
}
local function ConfigGet(key)
    return _G[key]
end

local function Bind(key, hook)
    return function(value)
        _G[key] = value
        if type(hook) == "function" then
            hook(value)
        elseif type(hook) == "table" then
            if value then
                if hook.Start then hook.Start() end
            else
                if hook.Stop then hook.Stop() end
            end
        end
        SaveConfiguration()
    end
end

local M1_RANGE = 500
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")
local RemoteSeed = Net:FindFirstChild("seed")
local State = { FoundRemote = nil, FoundRemoteId = nil, LastAttack = 0 }
task.spawn(function()
    local folders = { ReplicatedStorage:FindFirstChild("Util"), ReplicatedStorage:FindFirstChild("Common"), ReplicatedStorage:FindFirstChild("Remotes"), ReplicatedStorage:FindFirstChild("Assets"), ReplicatedStorage:FindFirstChild("FX") }
    local function checkChild(child)
        if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
            State.FoundRemoteId = child:GetAttribute("Id")
            State.FoundRemote = child
        end
    end
    for _, folder in ipairs(folders) do
        if folder then
            for _, child in ipairs(folder:GetChildren()) do checkChild(child) end
            folder.ChildAdded:Connect(checkChild)
        end
    end
end)

local function GetTargets()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return {} end
    local targets = {}
    local myPos = root.Position
    local function collect(container, include)
        if not container or not include then return end
        for _, model in ipairs(container:GetChildren()) do
            if model == char then continue end
            local tRoot = model:FindFirstChild("HumanoidRootPart")
            local tHum = model:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                if (tRoot.Position - myPos).Magnitude < M1_RANGE then
                    table.insert(targets, { Model = model, Root = tRoot, Head = model:FindFirstChild("Head") or tRoot })
                end
            end
        end
    end
    collect(workspace:FindFirstChild("Enemies"), _G.FastAttackMobs)
    collect(workspace:FindFirstChild("Characters"), _G.FastAttackPlayers)
    return targets
end
local function PerformAttack(useEncryptedChannel)
    local char = LocalPlayer.Character
    if not char then return end
    local hasTool = char:FindFirstChildOfClass("Tool") or char:FindFirstChild("EquippedWeapon")
    if not hasTool then return end
    local targets = GetTargets()
    if #targets == 0 then return end
    local mainTarget = targets[1]
    local hitList = {}
    for i, target in ipairs(targets) do table.insert(hitList, {target.Model, target.Root}) end
    pcall(function()
        RegisterAttack:FireServer(0)
        RegisterHit:FireServer(mainTarget.Head, hitList)
    end)
    if useEncryptedChannel and State.FoundRemote and State.FoundRemoteId then
        pcall(function()
            local seedValue = RemoteSeed and RemoteSeed:InvokeServer() or 1
            local encryptedId = bit32.bxor(State.FoundRemoteId + 909090, seedValue * 2)
            local rawName = "RE/RegisterHit"
            local timestamp = math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1
            local encryptedName = string.gsub(rawName, ".", function(c) return string.char(bit32.bxor(string.byte(c), timestamp)) end)
            State.FoundRemote:FireServer(encryptedName, encryptedId, mainTarget.Head, hitList)
        end)
    end
end
task.spawn(function()
    while true do
        if not (_G.FastAttackMobs or _G.FastAttackPlayers) then
            task.wait(0.3)
            continue
        end
        local startTime = tick()
        pcall(PerformAttack, _G.FastAttackMode ~= "模式1")
        local elapsed = tick() - startTime
        task.wait(math.max(0.05 - elapsed, 0.001))
    end
end)
RJR[L("杀戮光环")]:Dropdown({
    Title = L("快速攻击模式"),
    Values = {"模式1", "模式2(部分账号失效用)"},
    Value = ConfigGet("FastAttackMode"),
    Callback = Bind("FastAttackMode")
})
RJR[L("杀戮光环")]:Toggle({
    Title = L("快速攻击攻击怪物"),
    Value = ConfigGet("FastAttackMobs"),
    Callback = Bind("FastAttackMobs")
})
RJR[L("杀戮光环")]:Toggle({
    Title = L("快速攻击攻击玩家"),
    Value = ConfigGet("FastAttackPlayers"),
    Callback = Bind("FastAttackPlayers")
})
task.spawn(function()
    local Players = game:GetService("Players")
    local RepStorage = game:GetService("ReplicatedStorage")
    local WS = workspace
    local player = Players.LocalPlayer

    local Net = RepStorage:WaitForChild("Modules"):WaitForChild("Net")
    local ShootGunEvent = Net:WaitForChild("RE/ShootGunEvent")
    local Validator2 = RepStorage:WaitForChild("Remotes"):WaitForChild("Validator2")

    local shootFunc, idx, dragonReady = nil, {}, false
    local LIMB_PARTS = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
        "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
        "HumanoidRootPart"
    }

    local VALID_SEA_ENEMIES = {
        "Terrorshark", "Shark", "Piranha",
        "Fish Crew Member", "Haunted Crew Member",
        "FishBoat", "PirateBrigade", "PirateGrandBrigade"
    }

    local function getRandomLimb(character)
        if not character then return nil end
        local available = {}
        for _, name in ipairs(LIMB_PARTS) do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                available[#available + 1] = part
            end
        end
        if #available == 0 then return character:FindFirstChild("HumanoidRootPart") end
        return available[math.random(1, #available)]
    end

    local function initDragon()
        if dragonReady then return end
        local success = pcall(function()
            local cc = require(RepStorage:WaitForChild("Controllers"):WaitForChild("CombatController"))
            for _, v in ipairs(debug.getupvalues(cc.Attack)) do
                if type(v) == "function" then
                    for i, uv in ipairs(debug.getupvalues(v)) do
                        if uv == 727595 then
                            shootFunc = v
                            idx = { u25 = i-3, u21 = i-2, u24 = i-1, u20 = i, u22 = i+1, u23 = i+2, u26 = i+3 }
                            break
                        end
                    end
                    if shootFunc then break end
                end
            end
        end)
        if success and shootFunc then dragonReady = true end
    end

    local function fireShot(pos, hit)
        if not shootFunc then return end
        local u20 = debug.getupvalue(shootFunc, idx.u20)
        local u21 = debug.getupvalue(shootFunc, idx.u21)
        local u22 = debug.getupvalue(shootFunc, idx.u22)
        local u23 = debug.getupvalue(shootFunc, idx.u23)
        local u24 = debug.getupvalue(shootFunc, idx.u24)
        local u25 = debug.getupvalue(shootFunc, idx.u25)
        local u26 = debug.getupvalue(shootFunc, idx.u26)
        local u79 = u25 * u21
        local u80 = (u24 * u21 + u25 * u20) % u22
        u80 = (u80 * u22 + u79) % u23
        u24 = math.floor(u80 / u22)
        u25 = u80 - u24 * u22
        u26 = u26 + 1
        debug.setupvalue(shootFunc, idx.u24, u24)
        debug.setupvalue(shootFunc, idx.u25, u25)
        debug.setupvalue(shootFunc, idx.u26, u26)
        Validator2:FireServer(math.floor(u80 / u23 * 16777215), u26)
        ShootGunEvent:FireServer(pos, { hit })
    end

    local function getAllPlayerBoatModels()
        local models = {}
        local boats = WS:FindFirstChild("Boats")
        if boats then
            for _, v in ipairs(boats:GetChildren()) do
                local owner = v:FindFirstChild("Owner")
                if owner and owner.Value and tostring(owner.Value) ~= "" then
                    models[v.Name] = true
                end
            end
        end
        return models
    end

    local function IsSilentAimEnemy(target)
        if not target or target == player then return false end
        local main = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("Main")
        local frame = main and main:FindFirstChild("Allies")
            and main.Allies:FindFirstChild("Container")
            and main.Allies.Container:FindFirstChild("Allies")
            and main.Allies.Container.Allies:FindFirstChild("ScrollingFrame")
            and main.Allies.Container.Allies.ScrollingFrame:FindFirstChild("Frame")
        if frame and frame:FindFirstChild(target.Name) then return false end
        local myTeam = player.Team
        local targetTeam = target.Team
        if myTeam and targetTeam and myTeam.Name == "Marines" and targetTeam.Name == "Marines" then return false end
        return true
    end

    local function IsRubberTarget(target)
        local isRubber = false
        pcall(function()
            local fruit = target.Data.DevilFruit.Value
            if typeof(fruit) == "string" and fruit:find("Rubber") then
                isRubber = true
            end
        end)
        return isRubber
    end

    local AttackRange = 450

    local function getClosestSeaTarget()
        local char = player.Character
        if not char then return nil end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil end

        local best, bestDist = nil, AttackRange
        local playerBoats = getAllPlayerBoatModels()

        if _G.GunM1Mobs then
            local seaBeasts = WS:FindFirstChild("SeaBeasts")
            if seaBeasts then
                for _, e in ipairs(seaBeasts:GetChildren()) do
                    local hrp = e:FindFirstChild("HumanoidRootPart")
                    local hp = e:FindFirstChild("Health")
                    if hrp and hp and hp:IsA("ValueBase") and hp.Value > 0 then
                        local segment = e:FindFirstChild("Leviathan Segment")
                        if segment then
                            local dist = (segment.Position - myHRP.Position).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                best = segment
                            end
                        end
                        local dist = (hrp.Position - myHRP.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            best = getRandomLimb(e) or hrp
                        end
                    end
                end
            end

            local enemies = WS:FindFirstChild("Enemies")
            if enemies then
                for _, e in ipairs(enemies:GetChildren()) do
                    if not table.find(VALID_SEA_ENEMIES, e.Name) then continue end
                    if playerBoats[e.Name] then continue end

                    local engine = e:FindFirstChild("Engine")
                    local isBoat = engine and e:FindFirstChild("VehicleSeat")
                    if isBoat then
                        local hp = e:FindFirstChild("Health")
                        if hp and hp:IsA("ValueBase") and hp.Value > 0 then
                            local dist = (engine.Position - myHRP.Position).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                best = engine
                            end
                        end
                    else
                        local hrp = e:FindFirstChild("HumanoidRootPart")
                        local hum = e:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            local dist = (hrp.Position - myHRP.Position).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                best = getRandomLimb(e) or hrp
                            end
                        end
                    end
                end
            end

            local function scanNPC(node, depth)
                if not node then return end
                for _, enemy in node:GetChildren() do
                    local eHum = enemy:FindFirstChildOfClass("Humanoid")
                    local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                    if eRoot and eHum and eHum.Health > 0 then
                        local dist = (eRoot.Position - myHRP.Position).Magnitude
                        if dist < bestDist then
                            bestDist = dist
                            best = getRandomLimb(enemy) or eRoot
                        end
                    elseif depth < 3 and not enemy:IsA("BasePart") then
                        scanNPC(enemy, depth + 1)
                    end
                end
            end
            scanNPC(WS:FindFirstChild("Enemies"), 0)
            scanNPC(WS:FindFirstChild("SeaEvents"), 0)
        end

        if _G.GunM1Players then
            for _, p in ipairs(Players:GetPlayers()) do
                if p == player then continue end
                if p:GetAttribute("PvpDisabled") == true then continue end
                if IsRubberTarget(p) then continue end
                if not IsSilentAimEnemy(p) then continue end
                local pChar = p.Character
                local pHRP = pChar and pChar:FindFirstChild("HumanoidRootPart")
                local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
                if pHRP and pHum and pHum.Health > 0 then
                    local dist = (pHRP.Position - myHRP.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = pHRP
                    end
                end
            end
        end

        return best
    end

    task.spawn(function()
        while not dragonReady do initDragon() task.wait(1) end
        print("[Sea Events] Dragonstorm ready")
        while task.wait() do
            if not (_G.GunM1Mobs or _G.GunM1Players) then continue end
            local char = player.Character
            if not char then continue end
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool or tool.Name ~= "Dragonstorm" then continue end
            local target = getClosestSeaTarget()
            if target then
                fireShot(target.Position, target)
            end
        end
    end)
end)
RJR[L("杀戮光环")]:Toggle({
    Title = L("枪械m1攻击怪物"),
    Value = ConfigGet("GunM1Mobs"),
    Callback = Bind("GunM1Mobs")
})
RJR[L("杀戮光环")]:Toggle({
    Title = L("枪械m1攻击玩家"),
    Value = ConfigGet("GunM1Players"),
    Callback = Bind("GunM1Players")
})
do
    local FruitAttackConnection = nil
    local FruitAttack = false

    local function GetPlayerFruit()
        local char = LocalPlayer.Character
        if not char then return nil end
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                return tool
            end
        end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                    return tool
                end
            end
        end
        return nil
    end

    local function GetMaxCombo(tool)
        if not tool then return 5 end
        local n = tool.Name
        if n == "T-Rex-T-Rex" then return 4 end
        if n == "Blade-Blade" then return 2 end
        if n == "Pain-Pain" then return 4 end
        if n == "Control-Control" then return 4 end
        if n == "Gas-Gas" then return 5 end
        if n == "Dragon-Dragon" then
            local char = LocalPlayer.Character
            return (char and char:FindFirstChild("DragonHybrid")) and 5 or 3
        end
        return 5
    end

    local function SetFruitM1Enabled(enabled)
        FruitAttack = enabled
        if enabled then
            if FruitAttackConnection then
                task.cancel(FruitAttackConnection)
            end
            FruitAttackConnection = task.spawn(function()
                while FruitAttack do
                    task.wait(0.1)
                    local fruit = GetPlayerFruit()
                    if not fruit then continue end
                    local remote = fruit:FindFirstChild("LeftClickRemote")
                    if not remote then continue end
                    local char = LocalPlayer.Character
                    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                    if not myHRP then continue end
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                            local hum       = player.Character:FindFirstChild("Humanoid")
                            if targetHRP and hum and hum.Health > 0
                                and (targetHRP.Position - myHRP.Position).Magnitude < 500 then
                                local dir = (targetHRP.Position - myHRP.Position).Unit
                                pcall(function() remote:FireServer(Vector3.new(dir.X, dir.Y, dir.Z), 1, true) end)
                            end
                        end
                    end
                    local enemiesFolder = Workspace:FindFirstChild("Enemies")
                    if enemiesFolder then
                        for _, npc in pairs(enemiesFolder:GetChildren()) do
                            local targetHRP = npc:FindFirstChild("HumanoidRootPart")
                            local hum       = npc:FindFirstChild("Humanoid")
                            if targetHRP and hum and hum.Health > 0
                                and (targetHRP.Position - myHRP.Position).Magnitude < 500 then
                                local dir = (targetHRP.Position - myHRP.Position).Unit
                                pcall(function() remote:FireServer(Vector3.new(dir.X, dir.Y, dir.Z), 1, true) end)
                            end
                        end
                    end
                end
            end)
        else
            if FruitAttackConnection then
                task.cancel(FruitAttackConnection)
                FruitAttackConnection = nil
            end
        end
    end

    if _G.FruitM1 then
        SetFruitM1Enabled(true)
    end
    RJR[L("杀戮光环")]:Toggle({
        Title = L("果实m1"),
        Value = _G.FruitM1,
        Callback = function(vatt)
            _G.FruitM1 = vatt
            SetFruitM1Enabled(vatt)
            SaveConfiguration()
        end
    })

    local VoidFruitM1Thread = nil
    local voidVec = Vector3.new(9e30, 9e30, 9e30)

    local function SetVoidFruitM1Enabled(enabled)
        if VoidFruitM1Thread then
            task.cancel(VoidFruitM1Thread)
            VoidFruitM1Thread = nil
        end
        if not enabled then return end
        VoidFruitM1Thread = task.spawn(function()
            while _G.VoidFruitM1 do
                task.wait(0.3)
                local fruit = GetPlayerFruit()
                local remote = fruit and fruit:FindFirstChild("LeftClickRemote")
                if not remote then continue end
                local maxCombo = GetMaxCombo(fruit)
                pcall(function() remote:FireServer(voidVec, maxCombo, true) end)
            end
        end)
    end

    if _G.VoidFruitM1 then
        SetVoidFruitM1Enabled(true)
    end
    RJR[L("杀戮光环")]:Toggle({
        Title = L("虚空果实m1"),
        Value = _G.VoidFruitM1,
        Callback = function(vatt)
            _G.VoidFruitM1 = vatt
            SetVoidFruitM1Enabled(vatt)
            SaveConfiguration()
        end
    })
end
local function startAutoHakiLoop()
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
        local commF = remotes and remotes:WaitForChild("CommF_", 5)
        while true do
            task.wait(2)
            if _G.AutoHaki and commF then
                local Character = LocalPlayer.Character
                if Character and not Character:FindFirstChild("HasBuso") then
                    pcall(function()
                        commF:InvokeServer("Buso")
                    end)
                end
            end
        end
    end)
end
do
local function TurnOnV4()
    local char = LocalPlayer.Character
    if not char then return end
    local energy = char:FindFirstChild("RaceEnergy")
    local transformed = char:FindFirstChild("RaceTransformed")
    if not energy or energy.Value < 1 or not transformed or transformed.Value then
        return
    end
    local awakening = (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Awakening"))
        or char:FindFirstChild("Awakening")
    if awakening then
        pcall(function() awakening.RemoteFunction:InvokeServer(true) end)
    end
end

local function TurnOnV3()
    local CommE = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")
    if CommE then
        pcall(function() CommE:FireServer("ActivateAbility") end)
    end
end

local function handleAbility(abilityType)
    task.spawn(function()
        while true do
            if _G["Auto"..abilityType] then
                if abilityType == "V4" then
                    pcall(TurnOnV4)
                    task.wait(1)
                elseif abilityType == "V3" then
                    pcall(TurnOnV3)
                    task.wait(2)
                else
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
    end)
end
handleAbility("V3")
handleAbility("V4")
end

startAutoHakiLoop()

do
    local function isKenActive()
        local ok, blur = pcall(function()
            return game:GetService("Lighting").Blur
        end)
        return ok and blur ~= nil and blur.Enabled
    end

    task.spawn(function()
        local VIM
        pcall(function() VIM = game:GetService("VirtualInputManager") end)
        while true do
            task.wait(1)
            if _G.AutoKen and VIM then
                pcall(function()
                    if not isKenActive() then
                        VIM:SendKeyEvent(true, "E", false, game)
                        task.wait()
                        VIM:SendKeyEvent(false, "E", false, game)
                        task.wait(3)
                    end
                end)
            end
        end
    end)
end

local RAID_FRUIT_MAX_PRICE = 1000000

local function GetCommF()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("CommF_")
end

local function IsRaidChip(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name)
    return string.find(n, "chip", 1, true) ~= nil
        or string.find(n, "micro", 1, true) ~= nil
end

local function HasRaidChip()
    local containers = { LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack") }
    for _, cont in ipairs(containers) do
        if cont then
            for _, t in ipairs(cont:GetChildren()) do
                if IsRaidChip(t) then return true end
            end
        end
    end
    return false
end

local function LoadCheapestRaidFruit()
    local commF = GetCommF()
    if not commF then return false end

    local ok, list = pcall(function() return commF:InvokeServer("GetFruits") end)
    if not ok or type(list) ~= "table" then return false end

    local candidates = {}
    for _, v in ipairs(list) do
        if type(v) == "table" and type(v.Name) == "string"
            and type(v.Price) == "number" and v.Price < RAID_FRUIT_MAX_PRICE then
            candidates[#candidates + 1] = { Name = v.Name, Price = v.Price }
        end
    end
    table.sort(candidates, function(a, b) return a.Price < b.Price end)
    if #candidates == 0 then return false end

    for _, cand in ipairs(candidates) do
        local okLoad, loaded = pcall(function()
            return commF:InvokeServer("LoadFruit", cand.Name)
        end)
        if okLoad and loaded == true then
            task.wait(0.4)
            WindUI:Notify({
                Title = L("自动逃跑/袭击"),
                Content = L("取出果实: 已取出 ") .. cand.Name,
                Duration = 3
            })
            return true
        end
    end

    WindUI:Notify({ Title = L("自动逃跑/袭击"), Content = L("取出果实: 取出失败"), Duration = 3 })
    return false
end

local function EnsureRaidChip()
    if HasRaidChip() then return true end

    local commF = GetCommF()
    if not commF then return false end

    if not LoadCheapestRaidFruit() then
        return false
    end

    task.wait(0.3)
    pcall(function() commF:InvokeServer("RaidsNpc", "Select", _G.RaidChip) end)
    return HasRaidChip()
end

local function TriggerRaid()
    local map = Workspace:FindFirstChild("Map")
    if not map then return "nobutton" end

    local holder, btn
    if World3 then
        holder = map:FindFirstChild("Boat Castle")
        btn = holder and holder:FindFirstChild("RaidSummon2")
    elseif World2 then
        holder = map:FindFirstChild("CircleIsland")
        btn = holder and holder:FindFirstChild("RaidSummon2")
    end
    if not btn then return "nobutton" end

    btn = btn:FindFirstChild("Button") or btn
    btn = btn:FindFirstChild("Main") or btn

    local detector = btn:FindFirstChild("ClickDetector")
    if detector and fireclickdetector then
        pcall(fireclickdetector, detector)
        return true
    end

    local prompt = btn:FindFirstChild("ProximityPrompt")
    if prompt and fireproximityprompt then
        pcall(fireproximityprompt, prompt)
        return true
    end

    return false
end

local fleeConnection = nil
local fleeTriggered = false

local function AutoFleeLoopAlive()
    if not fleeConnection then return false end
    local ok, status = pcall(coroutine.status, fleeConnection)
    if not ok then return false end
    return status ~= "dead"
end

local function StartAutoFlee()
    if AutoFleeLoopAlive() then return end

    fleeConnection = task.spawn(function()
        pcall(EnsureRaidChip)

        while _G.AutoFlee do
            task.wait(0.2)
            pcall(function()
                if not _G.AutoFlee then return end
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then return end

                local hpPercent = (hum.Health / hum.MaxHealth) * 100

                if hpPercent <= _G.AutoFleeHP then
                    if not fleeTriggered then
                        fleeTriggered = true
                        local hasChip = HasRaidChip()
                        if not hasChip then
                            hasChip = EnsureRaidChip()
                        end
                        local result = "nochip"
                        if hasChip then
                            result = TriggerRaid()
                        end
                        if result == true then
                            WindUI:Notify({ Title = L("自动逃跑/袭击"), Content = L("副本: 召唤袭击"), Duration = 3 })
                            task.spawn(function()
                                task.wait(8)
                                if _G.AutoFlee then
                                    pcall(EnsureRaidChip)
                                end
                            end)
                        elseif result == "nobutton" then
                            WindUI:Notify({ Title = L("自动逃跑/袭击"), Content = L("副本: 未找到袭击按钮"), Duration = 3 })
                        elseif result == "nochip" then
                            WindUI:Notify({ Title = L("自动逃跑/袭击"), Content = L("副本: 没有袭击芯片"), Duration = 3 })
                        else
                            WindUI:Notify({ Title = L("自动逃跑/袭击"), Content = L("副本: 召唤失败"), Duration = 3 })
                        end
                    end
                else
                    fleeTriggered = false
                end
            end)
        end
        fleeConnection = nil
        fleeTriggered = false
    end)
end

local function StopAutoFlee()
    if fleeConnection then
        pcall(task.cancel, fleeConnection)
        fleeConnection = nil
    end
    fleeTriggered = false
end

LocalPlayer.CharacterAdded:Connect(function()
    if _G.AutoFlee then
        task.wait(0.5)
        pcall(StartAutoFlee)
    end
end)

if _G.AutoFlee then StartAutoFlee() end
RJR[L("主要功能")]:Toggle({
    Title = L("自动武装色"),
    Value = ConfigGet("AutoHaki"),
    Callback = Bind("AutoHaki")
})
RJR[L("主要功能")]:Toggle({
    Title = L("自动见闻色"),
    Value = ConfigGet("AutoKen"),
    Callback = Bind("AutoKen")
})
RJR[L("主要功能")]:Toggle({
    Title = L("自动 V3"),
    Value = ConfigGet("AutoV3"),
    Callback = Bind("AutoV3")
})
RJR[L("主要功能")]:Toggle({
    Title = L("自动 V4"),
    Value = ConfigGet("AutoV4"),
    Callback = Bind("AutoV4")
})
RJR[L("主要功能")]:Toggle({
    Title = L("自动逃跑/袭击"),
    Value = ConfigGet("AutoFlee"),
    Callback = Bind("AutoFlee", { Start = StartAutoFlee, Stop = StopAutoFlee })
})
RJR[L("主要功能")]:Slider({
    Title = L("逃跑血量阈值(%)"),
    Value = {
        Min = 1,
        Max = 100,
        Default = ConfigGet("AutoFleeHP") or 30
    },
    Callback = Bind("AutoFleeHP")
})
local LastSkillPressed = "Z"
UIS.InputBegan:Connect(function(input)
    if UIS:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.Z then
        LastSkillPressed = "Z"
    elseif input.KeyCode == Enum.KeyCode.X then
        LastSkillPressed = "X"
    elseif input.KeyCode == Enum.KeyCode.C then
        LastSkillPressed = "C"
    elseif input.KeyCode == Enum.KeyCode.V then
        LastSkillPressed = "V"
    elseif input.KeyCode == Enum.KeyCode.F then
        LastSkillPressed = "F"
    end
end)
local function IsSkillSelected(skillName)
    local skills = _G.SilentAimSkills
    if not skills then return true end
    if type(skills) == "table" then
        if next(skills) == nil then return false end
        if skills[skillName] ~= nil then
            return skills[skillName] == true
        end
        for _, v in pairs(skills) do
            if v == skillName then return true end
        end
        return false
    end
    return true
end
local function IsCurrentSkillEnabled()
    return IsSkillSelected(LastSkillPressed)
end
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
local _FIRESERVER = "FireServer"
local _INVOKESERVER = "InvokeServer"
mt.__namecall = newcclosure(function(self, ...)
    if not _G.SilentAimSkill then
        return oldNamecall(self, ...)
    end
    local method = getnamecallmethod()
    if method ~= _FIRESERVER and method ~= _INVOKESERVER then
        return oldNamecall(self, ...)
    end
    if not IsCurrentSkillEnabled() or not _G.SilentAimTargetPos then
        return oldNamecall(self, ...)
    end
    local sName = tostring(self)
    if sName ~= "RemoteEvent" and sName ~= "CommE" and sName ~= "RemoteFunction" then
        return oldNamecall(self, ...)
    end
    local args = {...}
    for i, v in pairs(args) do
        if typeof(v) == "Vector3" then
            args[i] = _G.SilentAimTargetPos
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)
local translateConnection
local translateWalkSpeedConn = nil
local function ApplyTranslateWalkSpeed(humanoid)
    if not humanoid then return end
    if _G.translateAccel then
        humanoid.WalkSpeed = math.clamp(_G.translateSpeed, 1, 2000)
    end
end
local function StartTranslateAccel()
    if translateConnection then return end
    local function bind(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        ApplyTranslateWalkSpeed(humanoid)
        if translateWalkSpeedConn then
            translateWalkSpeedConn:Disconnect()
            translateWalkSpeedConn = nil
        end
        translateWalkSpeedConn = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if _G.translateAccel and humanoid.Health > 0 then
                humanoid.WalkSpeed = math.clamp(_G.translateSpeed, 1, 2000)
            end
        end)
    end
    translateConnection = LocalPlayer.CharacterAdded:Connect(bind)
    if LocalPlayer.Character then
        bind(LocalPlayer.Character)
    end
end
local function StopTranslateAccel()
    if translateConnection then
        translateConnection:Disconnect()
        translateConnection = nil
    end
    if translateWalkSpeedConn then
        translateWalkSpeedConn:Disconnect()
        translateWalkSpeedConn = nil
    end
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end
local stateConn
local function updateJumpPower(humanoid)
    if not humanoid then return end
    if humanoid.UseJumpPower then
        humanoid.JumpPower = _G.jumpEnabled and _G.jumpHeight or 50
    else
        humanoid.JumpHeight = _G.jumpEnabled and _G.jumpHeight or 7.2
    end
end
local function bindHumanoid(humanoid)
    if stateConn then
        stateConn:Disconnect()
        stateConn = nil
    end
    local prop = humanoid.UseJumpPower and "JumpPower" or "JumpHeight"
    stateConn = humanoid:GetPropertyChangedSignal(prop):Connect(function()
        if _G.jumpEnabled then
            updateJumpPower(humanoid)
        end
    end)
    updateJumpPower(humanoid)
end
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        bindHumanoid(humanoid)
    end
end)
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        bindHumanoid(humanoid)
    end
end
if _G.translateAccel then
    StartTranslateAccel()
end
local ESPRunning = false
local espObjects = {}
local espUpdateConnection = nil
local function getTeamInfo(player)
    if not player.Team then
        return "Unknown", Color3.fromRGB(255,255,255)
    end
    if player.Team.Name == "Marines" then
        return L("海军"), Color3.fromRGB(0,170,255)
    else
        return L("海贼"), Color3.fromRGB(255,70,70)
    end
end
local function hexToColor3(hex)
    local r = tonumber(hex:sub(1,2), 16) / 255 or 0
    local g = tonumber(hex:sub(3,4), 16) / 255 or 1
    local b = tonumber(hex:sub(5,6), 16) / 255 or 0
    return Color3.new(r, g, b)
end
local function color3ToRGBString(color3)
    return string.format("rgb(%d,%d,%d)",
        math.floor(color3.R * 255 + 0.5),
        math.floor(color3.G * 255 + 0.5),
        math.floor(color3.B * 255 + 0.5))
end
local function NormalizeLayout(l)
    l = l or "经典"
    if l == "血条" then return "血条样式" end
    if l == "多行" or l == "单行" or l == "双行" or l == "方框" then return "经典" end
    return l
end
local function FormatBounty(amount)
    if amount >= 1000000 then
        return string.format("%.1f", amount / 1000000) .. "M"
    else
        return string.format("%.1f", amount / 1000) .. "K"
    end
end
local function removeESP(player)
    if espObjects[player] then
        pcall(function()
            espObjects[player].gui:Destroy()
            if espObjects[player].highlight then
                espObjects[player].highlight:Destroy()
            end
        end)
        espObjects[player] = nil
    end
end
local function createESP(player)
    if player:GetAttribute("IsAuthor") or
       player.Name == "Mas_Yes" or
       player.Name == "sjqgduf" or
       player.Name == "huha123444" or
       player.Name == "ksxrcm111" or
       player.Name == "Dddyy5" then
        return
    end
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local team, color = getTeamInfo(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,220,0,150)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextScaled = false
    text.TextSize = _G.ESP_TextSize
    text.RichText = true
    text.Font = Enum.Font.SourceSansBold
    text.TextStrokeTransparency = 0
    text.TextColor3 = color
    text.Parent = billboard
    local hpBar = Instance.new("Frame")
    hpBar.Name = "ESP_HPBar"
    hpBar.Size = UDim2.new(1, -60, 0, 6)
    hpBar.Position = UDim2.new(0.5, 0, 1, -8)
    hpBar.AnchorPoint = Vector2.new(0.5, 1)
    hpBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
    hpBar.BorderSizePixel = 1
    hpBar.BorderColor3 = Color3.fromRGB(0,0,0)
    hpBar.Visible = false
    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.Position = UDim2.new(0, 0, 0.5, 0)
    hpFill.AnchorPoint = Vector2.new(0, 0.5)
    hpFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBar
    hpBar.Parent = billboard
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "ESP_Avatar"
    avatar.Size = UDim2.new(0, 42, 0, 42)
    avatar.AnchorPoint = Vector2.new(0, 0.5)
    avatar.Position = UDim2.new(0, 4, 0.5, 0)
    avatar.BackgroundColor3 = Color3.fromRGB(0,0,0)
    avatar.BackgroundTransparency = 0.2
    avatar.BorderSizePixel = 1
    avatar.BorderColor3 = color
    avatar.Image = ""
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Visible = false
    avatar.Parent = billboard
    task.spawn(function()
        pcall(function()
            local url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            pcall(function()
                game:GetService("ContentProvider"):Preload(url)
            end)
            avatar.Image = url
        end)
    end)
    billboard.Parent = head
    local highlight = nil
    if _G.ESP_Highlight then
        local hlColor = hexToColor3(_G.ESP_HighlightColor)
        highlight = Instance.new("Highlight")
        highlight.Name = "ESP_PlayerHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = hlColor
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = hlColor
        highlight.OutlineTransparency = 0
        highlight.Parent = char
    end
    espObjects[player] = {
        gui = billboard,
        label = text,
        hpBar = hpBar,
        hpFill = hpFill,
        avatar = avatar,
        char = char,
        highlight = highlight
    }
end
local lastESPUpdate = 0
local ESP_UPDATE_INTERVAL = 0.1
local playerCache = {}
local function getPlayerData(player)
    if not playerCache[player] then
        playerCache[player] = {
            level = "?",
            fruit = "None",
            bounty = 0,
            team = "Unknown",
            color = Color3.fromRGB(255, 255, 255),
            lastUpdate = 0
        }
    end
    local data = playerCache[player]
    local now = tick()
    if now - data.lastUpdate > 5 then
        pcall(function() data.level = player.Data.Level.Value end)
        pcall(function() data.fruit = player.Data.DevilFruit.Value end)
        pcall(function() data.bounty = player.leaderstats["Bounty/Honor"].Value end)
        data.team, data.color = getTeamInfo(player)
        data.lastUpdate = now
    end
    return data
end
local function updateESP()
    local now = tick()
    if now - lastESPUpdate < ESP_UPDATE_INTERVAL then return end
    lastESPUpdate = now
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:GetAttribute("IsAuthor") or
               player.Name == "Mas_Yes" or
               player.Name == "sjqgdu6" or
               player.Name == "huha124444" or
               player.Name == "ksxrcn111" or
               player.Name == "Dddyy5" then
                if espObjects[player] then
                    removeESP(player)
                end
                continue
            end
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            local data = espObjects[player]
            if char and head then
                if not data or data.char ~= char or not data.gui.Parent then
                    removeESP(player)
                    createESP(player)
                    data = espObjects[player]
                end
            else
                if data then
                    removeESP(player)
                end
                continue
            end
            if not data then continue end
            if char then
                local hum = char:FindFirstChild("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    local distance = math.floor((root.Position - myPos).Magnitude)
                    local hp = math.floor((hum.Health/hum.MaxHealth)*100)
                    local pData = getPlayerData(player)
                    local level = pData.level
                    local fruit = pData.fruit
                    local bounty = pData.bounty
                    local team = pData.team
                    local color = pData.color
                    local warnTag = ""
                    if bounty > 10000000 then
                        warnTag = "⚠ "
                    end
                    local pvpState = L("⚔ PVP已开启 ")
                    local pvpIcon = "🔴 "
                    local isPvpDisabled = false
                    if player:GetAttribute("PvpDisabled") == true then
                        pvpState = L("PvP已关闭 ")
                        pvpIcon = "🟢 "
                        isPvpDisabled = true
                    end
                    data.label.TextColor3 = color
                    local layout = NormalizeLayout(_G.ESP_Layout)
                    local ts = _G.ESP_TextSize
                    if data.label.TextSize ~= ts then
                        data.label.TextSize = ts
                    end
                    local showAvatar = _G.ESP_Avatar and data.avatar.Image ~= ""
                    local avatarLeft = _G.ESP_AvatarSide == "左边"
                    data.avatar.Visible = showAvatar
                    if showAvatar then
                        pcall(function()
                            if avatarLeft then
                                data.avatar.AnchorPoint = Vector2.new(0, 0.5)
                                data.avatar.Position = UDim2.new(0, 4, 0.5, 0)
                                data.label.AnchorPoint = Vector2.new(0.5, 0.5)
                                data.label.Position = UDim2.new(0.5, 18, 0.5, 0)
                                data.label.Size = UDim2.new(1, -56, 1, 0)
                            else
                                data.avatar.AnchorPoint = Vector2.new(1, 0.5)
                                data.avatar.Position = UDim2.new(1, -4, 0.5, 0)
                                data.label.AnchorPoint = Vector2.new(0.5, 0.5)
                                data.label.Position = UDim2.new(0.5, -18, 0.5, 0)
                                data.label.Size = UDim2.new(1, -56, 1, 0)
                            end
                        end)
                    else
                        pcall(function()
                            data.label.AnchorPoint = Vector2.new(0, 0)
                            data.label.Position = UDim2.new(0, 0, 0, 0)
                            data.label.Size = UDim2.new(1, 0, 1, 0)
                        end)
                    end
                    local namePart, levelPart, fruitPart, bountyPart, distPart, hpPart
                    if _G.ESP_Name then
                        namePart = warnTag .. "[" .. team .. "] <font color=\"" .. color3ToRGBString(hexToColor3(_G.ESP_NameColor)) .. "\">" .. player.Name .. "</font>"
                    end
                    if _G.ESP_Level then
                        levelPart = "<font color=\"" .. color3ToRGBString(hexToColor3(_G.ESP_LevelColor)) .. "\">Lv." .. level .. "</font>"
                    end
                    local pvpPart
                    if isPvpDisabled then
                        pvpPart = "<font color=\"rgb(0,255,0)\">" .. pvpIcon .. pvpState .. "</font>"
                    else
                        pvpPart = pvpIcon .. pvpState
                    end
                    if _G.ESP_Fruit then
                        fruitPart = "<font color=\"" .. color3ToRGBString(hexToColor3(_G.ESP_FruitColor)) .. "\">" .. L("水果: ") .. fruit .. "</font>"
                    end
                    if _G.ESP_Bounty then
                        bountyPart = "<font color=\"" .. color3ToRGBString(hexToColor3(_G.ESP_BountyColor)) .. "\">" .. L("赏金: ") .. FormatBounty(bounty) .. "</font>"
                    end
                    if _G.ESP_Distance then
                        distPart = "<font color=\"" .. color3ToRGBString(hexToColor3(_G.ESP_DistanceColor)) .. "\">" .. distance .. L("米") .. "</font>"
                    end
                    if _G.ESP_HP and layout ~= "血条样式" then
                        hpPart = "<font color=\"" .. color3ToRGBString(hexToColor3(_G.ESP_HPColor)) .. "\">" .. L("生命 ") .. hp .. "%</font>"
                    end
                    data.gui.StudsOffset = Vector3.new(0, 3, 0)
                    local hpBarVisible = layout == "血条样式"
                    data.hpBar.Visible = hpBarVisible
                    if hpBarVisible then
                        pcall(function()
                            data.hpFill.Size = UDim2.new(math.clamp(hp / 100, 0, 1), 0, 1, 0)
                            if hp > 50 then
                                data.hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            elseif hp > 25 then
                                data.hpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                            else
                                data.hpFill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
                            end
                        end)
                    end
                    data.label.Visible = true
                    local parts = {}
                    if namePart then parts[#parts+1] = namePart end
                    if levelPart then parts[#parts+1] = levelPart end
                    if pvpPart then parts[#parts+1] = pvpPart end
                    if fruitPart then parts[#parts+1] = fruitPart end
                    if bountyPart then parts[#parts+1] = bountyPart end
                    if distPart then parts[#parts+1] = distPart end
                    if hpPart then parts[#parts+1] = hpPart end
                    data.label.Text = table.concat(parts, "\n")

                    if _G.ESP_Highlight then
                        local hlColor = hexToColor3(_G.ESP_HighlightColor)
                        pcall(function()
                            for _, child in ipairs(char:GetChildren()) do
                                if child:IsA("Highlight") and child.Name ~= "ESP_PlayerHighlight" then
                                    child.FillColor = hlColor
                                    child.OutlineColor = hlColor
                                    child.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                end
                            end
                        end)
                        if not data.highlight or not data.highlight.Parent then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ESP_PlayerHighlight"
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.FillColor = hlColor
                            hl.FillTransparency = 0.5
                            hl.OutlineColor = hlColor
                            hl.OutlineTransparency = 0
                            hl.Parent = char
                            data.highlight = hl
                        else
                            data.highlight.FillColor = hlColor
                            data.highlight.OutlineColor = hlColor
                            data.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                    else
                        if data.highlight then
                            data.highlight:Destroy()
                            data.highlight = nil
                        end
                    end
                end
            end
        end
    end
end
function EnableESP()
    if ESPRunning then return end
    ESPRunning = true
    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
    espUpdateConnection = task.spawn(function()
        while ESPRunning do
            pcall(updateESP)
            task.wait(ESP_UPDATE_INTERVAL)
        end
    end)
end
function DisableESP()
    ESPRunning = false
    espUpdateConnection = nil
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
    espObjects = {}
end
if not _G.ESP_Initialized then
    _G.ESP_Initialized = true
    Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
        playerCache[player] = nil
    end)
end
task.spawn(function()
    task.wait(1)
    if _G.ESPEnabled then
        EnableESP()
    end
end)

RJR[L("主要功能")]:Input({
    Title = L("移动速度"),
    Value = tostring(_G.translateSpeed),
    Placeholder = "1 - 2000",
    Callback = function(text)
        local v = tonumber(text)
        if v then
            _G.translateSpeed = math.clamp(v, 1, 2000)
            if _G.translateAccel and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = _G.translateSpeed
                end
            end
            SaveConfiguration()
        end
    end
})

RJR[L("主要功能")]:Toggle({
    Title = L("加速开关"),
    Value = _G.translateAccel,
    Callback = function(state)
        _G.translateAccel = state
        if state then
            StartTranslateAccel()
        else
            StopTranslateAccel()
        end
        SaveConfiguration()
    end
})

RJR[L("主要功能")]:Input({
    Title = L("跳跃高度"),
    Value = tostring(_G.jumpHeight),
    Placeholder = "50 - 500",
    Callback = function(text)
        local v = tonumber(text)
        if v then
            _G.jumpHeight = math.clamp(v, 50, 500)
            if _G.jumpEnabled and LocalPlayer.Character then
                updateJumpPower(LocalPlayer.Character:FindFirstChild("Humanoid"))
            end
            SaveConfiguration()
        end
    end
})

RJR[L("主要功能")]:Toggle({
    Title = L("高跳开启"),
    Value = _G.jumpEnabled,
    Callback = function(state)
        _G.jumpEnabled = state
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if state then
                    bindHumanoid(humanoid)
                else
                    if humanoid.UseJumpPower then
                        humanoid.JumpPower = 50
                    else
                        humanoid.JumpHeight = 7.2
                    end
                    if stateConn then
                        stateConn:Disconnect()
                        stateConn = nil
                    end
                end
            end
        end
        SaveConfiguration()
    end
})
local Skyjump = { running = false, last = 0 }
function Skyjump.Reset(char)
    if not (char and getgc and getupvalues and setupvalue) then return end
    local sky = char:FindFirstChild("Skyjump")
    if not sky then return end
    if Skyjump.fnsSky ~= sky or #Skyjump.fns == 0 then
        Skyjump.fnsSky = sky
        Skyjump.fns = {}
        Skyjump.jumped = nil
        Skyjump.lastUseTbl = nil
        for _, fn in next, getgc() do
            if typeof(fn) == "function" then
                local ok, env = pcall(getfenv, fn)
                if ok and env and env.script == sky then
                    table.insert(Skyjump.fns, fn)
                end
            end
        end
    end
    for _, fn in ipairs(Skyjump.fns) do
        local hasLastUse = false
        for i, uv in next, getupvalues(fn) do
            if type(uv) == "table" and uv.LastUse ~= nil then
                uv.LastUse = 0
                Skyjump.lastUseTbl = uv
                hasLastUse = true
            elseif type(uv) == "number" and uv >= 5 and uv <= 100 then
                pcall(setupvalue, fn, i, 0)
            end
        end
        if hasLastUse and not Skyjump.jumped then
            Skyjump.jumped = fn
        end
    end
end
function Skyjump.DoJump()
    if not _G.InfiniteJump then return end
    local now = tick()
    if now - Skyjump.last < 0.05 then return end
    Skyjump.last = now
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 or hum.Sit then return end
    Skyjump.Reset(char)
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    if Skyjump.jumped then
        local before = Skyjump.lastUseTbl and Skyjump.lastUseTbl.LastUse
        pcall(Skyjump.jumped, { UserInputState = Enum.UserInputState.Begin })
        if Skyjump.lastUseTbl and before ~= Skyjump.lastUseTbl.LastUse then
            return
        end
    end
    local mult = 1.5
    pcall(function()
        local race = LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Race")
        if race and race.Value == "Skypiea" then mult = 1.4 end
    end)
    local jp = 50
    if hum.UseJumpPower then
        jp = hum.JumpPower
    else
        jp = math.sqrt(math.max(hum.JumpHeight or 7.2, 0) * 2 * workspace.Gravity)
    end
    local vel = hrp.AssemblyLinearVelocity
    hrp.AssemblyLinearVelocity = Vector3.new(vel.X, math.max(jp * mult, 50), vel.Z)
    pcall(function()
        local energy = char:FindFirstChild("Energy")
        local cost = 15
        if energy and energy.Value >= cost then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local commE = remotes and remotes:FindFirstChild("CommE")
            if commE then
                commE:FireServer("Dodge", "Geppo", cost, nil, workspace:GetServerTimeNow())
            end
            local skyEv = ReplicatedStorage:FindFirstChild("PlayerSkyJumped")
            if skyEv then skyEv:Fire() end
        end
    end)
end
UIS.JumpRequest:Connect(Skyjump.DoJump)
function Skyjump.StartLoop()
    if Skyjump.running then return end
    Skyjump.running = true
    task.spawn(function()
        while _G.InfiniteJump do
            pcall(Skyjump.Reset, LocalPlayer.Character)
            task.wait(0.1)
        end
        Skyjump.running = false
    end)
end
if _G.InfiniteJump then Skyjump.StartLoop() end
LocalPlayer.CharacterAdded:Connect(function()
    if _G.InfiniteJump then
        task.wait(1)
        Skyjump.StartLoop()
    end
end)
RJR[L("主要功能")]:Toggle({
    Title = L("无限跳跃"),
    Value = _G.InfiniteJump,
    Callback = function(v)
        _G.InfiniteJump = v
        if v then Skyjump.StartLoop() end
        SaveConfiguration()
    end
})

local Noclip = {}
Noclip.conn = nil
Noclip.descConn = nil
Noclip.char = nil
Noclip.parts = nil
Noclip.saved = nil

do
local function NoclipStrip(part, saved)
    if part:IsA("BasePart") and part.CanCollide then
        saved[part] = true
        part.CanCollide = false
    end
end

local function NoclipRestore(saved)
    if not saved then return end
    for part in pairs(saved) do
        pcall(function()
            if part.Parent then
                part.CanCollide = true
            end
        end)
    end
end

local function NoclipBind(char)
    NoclipRestore(Noclip.saved)
    Noclip.saved = {}
    Noclip.char = char
    Noclip.parts = {}
    if Noclip.descConn then
        Noclip.descConn:Disconnect()
        Noclip.descConn = nil
    end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then
            Noclip.parts[#Noclip.parts + 1] = d
            NoclipStrip(d, Noclip.saved)
        end
    end
    Noclip.descConn = char.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then
            Noclip.parts[#Noclip.parts + 1] = d
            NoclipStrip(d, Noclip.saved)
        end
    end)
end

function Noclip.Start()
    if Noclip.conn then return end
    Noclip.saved = {}
    local char = LocalPlayer.Character
    if char then NoclipBind(char) end
    Noclip.conn = RunService.Stepped:Connect(function()
        local current = LocalPlayer.Character
        if not current then return end
        if current ~= Noclip.char then
            NoclipBind(current)
            return
        end
        local parts = Noclip.parts
        for i = #parts, 1, -1 do
            local part = parts[i]
            if not part.Parent then
                table.remove(parts, i)
            elseif part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

function Noclip.Stop()
    if Noclip.conn then
        Noclip.conn:Disconnect()
        Noclip.conn = nil
    end
    if Noclip.descConn then
        Noclip.descConn:Disconnect()
        Noclip.descConn = nil
    end
    NoclipRestore(Noclip.saved)
    Noclip.char = nil
    Noclip.parts = nil
    Noclip.saved = nil
end
end
if _G.Noclip then Noclip.Start() end
RJR[L("主要功能")]:Toggle({
    Title = L("穿墙"),
    Value = ConfigGet("Noclip"),
    Callback = Bind("Noclip", { Start = Noclip.Start, Stop = Noclip.Stop })
})

local BoatNoclip = {}
BoatNoclip.gen = 0
BoatNoclip.boat = nil
BoatNoclip.saved = setmetatable({}, { __mode = "k" })

local function BoatNoclipStrip(part)
    if part:IsA("BasePart") and part.CanCollide then
        BoatNoclip.saved[part] = true
        part.CanCollide = false
    end
end

local function BoatNoclipClear()
    for part in pairs(BoatNoclip.saved) do
        BoatNoclip.saved[part] = nil
        if part.Parent then
            pcall(function()
                part.CanCollide = true
            end)
        end
    end
    BoatNoclip.boat = nil
end

local function BoatNoclipRiding()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if not seat then return nil end
    local boats = Workspace:FindFirstChild("Boats")
    if not boats then return nil end
    for _, boat in ipairs(boats:GetChildren()) do
        if seat:IsDescendantOf(boat) then return boat end
    end
    return nil
end

local function BoatNoclipTick()
    local boat = BoatNoclipRiding()
    if boat ~= BoatNoclip.boat then
        BoatNoclipClear()
        BoatNoclip.boat = boat
    end
    if not boat then return end
    for _, d in ipairs(boat:GetDescendants()) do
        BoatNoclipStrip(d)
    end
    local char = LocalPlayer.Character
    if char then
        for _, d in ipairs(char:GetDescendants()) do
            BoatNoclipStrip(d)
        end
    end
end

function BoatNoclip.Start()
    BoatNoclip.gen = BoatNoclip.gen + 1
    local gen = BoatNoclip.gen
    task.spawn(function()
        while BoatNoclip.gen == gen do
            pcall(BoatNoclipTick)
            task.wait(0.1)
        end
    end)
end

function BoatNoclip.Stop()
    BoatNoclip.gen = BoatNoclip.gen + 1
    BoatNoclipClear()
end

if _G.BoatNoclip then BoatNoclip.Start() end
RJR[L("主要功能")]:Toggle({
    Title = L("船穿墙"),
    Value = ConfigGet("BoatNoclip"),
    Callback = Bind("BoatNoclip", { Start = BoatNoclip.Start, Stop = BoatNoclip.Stop })
})
do
    local FLY_MIN_SPEED, FLY_MAX_SPEED = 1, 10000
    local flySpeed = 50
    local FlyOn = false
    local FlyLoopConn = nil
    local FlyHoldConn = nil
    local FlyPanel = nil
    local FlySpeedBox = nil
    local FlyStartBtn = nil
    local FlyToggleWidget = nil
    local FlyControls = nil
    local flyAttachment, flyLv, flyAo
    local flyCharacter, flyHumanoid, flyRoot
    local flyLockedTracks, flyAnimateScript = {}, nil
    local FlyHidePanel

    local function FlyClampSpeed(v)
        v = math.floor(tonumber(v) or 50)
        if v < FLY_MIN_SPEED then v = FLY_MIN_SPEED end
        if v > FLY_MAX_SPEED then v = FLY_MAX_SPEED end
        return v
    end

    flySpeed = FlyClampSpeed(_G.FlySpeed)
    _G.FlySpeed = flySpeed

    local function FlyGetControls()
        if FlyControls then return FlyControls end
        pcall(function()
            local PlayerModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule", 5))
            FlyControls = PlayerModule:GetControls()
        end)
        return FlyControls
    end

    local function FlySetSpeed(v)
        flySpeed = FlyClampSpeed(v)
        _G.FlySpeed = flySpeed
        if FlySpeedBox then FlySpeedBox.Text = tostring(flySpeed) end
        SaveConfiguration()
    end

    local function FlyStopHold()
        if FlyHoldConn then
            FlyHoldConn:Disconnect()
            FlyHoldConn = nil
        end
    end

    local function FlyClearPhysics()
        if flyAttachment then
            flyAttachment:Destroy()
            flyAttachment = nil
        end
        flyLv, flyAo = nil, nil
    end

    local function FlyLockPose()
        if not flyHumanoid or not flyCharacter then return end
        flyAnimateScript = flyCharacter:FindFirstChild("Animate")
        if flyAnimateScript then
            flyAnimateScript.Disabled = true
        end
        flyLockedTracks = {}
        for _, track in ipairs(flyHumanoid:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(0)
            table.insert(flyLockedTracks, track)
        end
    end

    local function FlyUnlockPose()
        for _, track in ipairs(flyLockedTracks) do
            if track then
                pcall(function() track:AdjustSpeed(1) end)
            end
        end
        flyLockedTracks = {}
        if flyAnimateScript then
            flyAnimateScript.Disabled = false
            flyAnimateScript = nil
        elseif flyCharacter then
            local a = flyCharacter:FindFirstChild("Animate")
            if a then a.Disabled = false end
        end
    end

    local function FlyKeepPoseLocked()
        if not FlyOn or not flyHumanoid then return end
        for _, track in ipairs(flyHumanoid:GetPlayingAnimationTracks()) do
            if track.Speed ~= 0 then
                track:AdjustSpeed(0)
            end
        end
    end

    local function FlySetupPhysics()
        flyCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        flyHumanoid = flyCharacter:WaitForChild("Humanoid")
        flyRoot = flyCharacter:WaitForChild("HumanoidRootPart")

        FlyClearPhysics()
        if not FlyOn then return end

        FlyLockPose()
        flyHumanoid.PlatformStand = true

        flyAttachment = Instance.new("Attachment")
        flyAttachment.Parent = flyRoot

        flyLv = Instance.new("LinearVelocity")
        flyLv.MaxForce = 9e9
        flyLv.VectorVelocity = Vector3.zero
        flyLv.Attachment0 = flyAttachment
        flyLv.RelativeTo = Enum.ActuatorRelativeTo.World
        flyLv.Parent = flyAttachment

        flyAo = Instance.new("AlignOrientation")
        flyAo.MaxTorque = 9e9
        flyAo.Responsiveness = 200
        flyAo.Mode = Enum.OrientationAlignmentMode.OneAttachment
        flyAo.Attachment0 = flyAttachment
        flyAo.Parent = flyAttachment
    end

    local function FlyBindLoop()
        if FlyLoopConn then return end
        local controls = FlyGetControls()
        if not controls then return end
        FlyLoopConn = RunService.RenderStepped:Connect(function()
            if not FlyOn or not flyRoot or not flyLv or not flyAo or not workspace.CurrentCamera then
                return
            end
            FlyKeepPoseLocked()

            local cam = workspace.CurrentCamera
            local moveVector = controls:GetMoveVector()
            local direction = Vector3.zero

            if moveVector.Magnitude > 0 then
                local rawDirection = (cam.CFrame.LookVector * -moveVector.Z) + (cam.CFrame.RightVector * moveVector.X)
                if rawDirection.Magnitude > 0.001 then
                    direction = rawDirection.Unit
                end
            end

            if direction.Magnitude > 0 then
                local exactSpeed = math.floor(flySpeed * 1000) / 1000
                local targetVelocity = direction * exactSpeed
                flyLv.VectorVelocity = targetVelocity
                flyRoot.AssemblyLinearVelocity = targetVelocity
            else
                flyLv.VectorVelocity = Vector3.zero
                flyRoot.AssemblyLinearVelocity = Vector3.zero
            end

            flyAo.CFrame = cam.CFrame
        end)
    end

    local function FlySyncButtonText()
        if FlyStartBtn then
            FlyStartBtn.Text = FlyOn and L("停止") or L("开始")
        end
    end

    local function FlyStart()
        if FlyOn then return end
        FlyOn = true
        FlySetupPhysics()
        FlyBindLoop()
        FlySyncButtonText()
    end

    local function FlyStop()
        if not FlyOn then return end
        FlyOn = false
        if FlyLoopConn then
            FlyLoopConn:Disconnect()
            FlyLoopConn = nil
        end
        if flyHumanoid then
            pcall(function() flyHumanoid.PlatformStand = false end)
        end
        FlyClearPhysics()
        FlyUnlockPose()
        FlySyncButtonText()
    end

    local function FlyDestroyPanel()
        FlyStopHold()
        if FlyPanel then
            FlyPanel:Destroy()
            FlyPanel = nil
        end
        FlySpeedBox = nil
        FlyStartBtn = nil
    end

    function FlyBuildPanel()
        if FlyPanel then return end
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local existing = PlayerGui:FindFirstChild("RJRFly")
        if existing then existing:Destroy() end

        local m = Instance.new("ScreenGui")
        local f = Instance.new("Frame")
        local u = Instance.new("TextButton")
        local d = Instance.new("TextButton")
        local o = Instance.new("TextButton")
        local t = Instance.new("TextLabel")
        local p = Instance.new("TextButton")
        local s = Instance.new("TextBox")
        local n = Instance.new("TextButton")
        local c = Instance.new("TextButton")
        local h = Instance.new("TextButton")
        local h2 = Instance.new("TextButton")

        m.Name = "RJRFly"
        m.Parent = PlayerGui
        m.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        m.ResetOnSpawn = false

        f.Parent = m
        f.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
        f.BorderColor3 = Color3.fromRGB(103, 221, 213)
        f.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
        f.Size = UDim2.new(0, 190, 0, 57)
        f.Active = true
        f.Draggable = true

        local function b(x, y, z, q)
            x.Name = y
            x.Parent = f
            x.Position = z
            x.Size = q
            x.Font = Enum.Font.SourceSans
            x.Text = y
            x.TextColor3 = Color3.fromRGB(0, 0, 0)
            x.TextSize = 14
            x.TextScaled = true
            x.TextWrapped = true
        end

        b(u, "↑", UDim2.new(0, 0, 0, 0), UDim2.new(0, 44, 0, 28))
        u.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
        u.Text = L("加速")

        b(d, "↓", UDim2.new(0, 0, 0.491228074, 0), UDim2.new(0, 44, 0, 28))
        d.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
        d.Text = L("减速")

        o.Name = "onoff"
        o.Parent = f
        o.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
        o.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
        o.Size = UDim2.new(0, 56, 0, 28)
        o.Font = Enum.Font.SourceSans
        o.Text = L("开始")
        o.TextColor3 = Color3.fromRGB(0, 0, 0)
        o.TextScaled = true
        o.TextSize = 14
        o.TextWrapped = true

        b(p, "plus", UDim2.new(0.231578946, 0, 0, 0), UDim2.new(0, 45, 0, 28))
        p.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
        p.Text = "+5"

        s.Parent = f
        s.Name = "speed"
        s.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
        s.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
        s.Size = UDim2.new(0, 44, 0, 28)
        s.Font = Enum.Font.SourceSans
        s.Text = tostring(flySpeed)
        s.TextColor3 = Color3.fromRGB(0, 0, 0)
        s.TextScaled = true
        s.TextSize = 14
        s.TextWrapped = true
        s.ClearTextOnFocus = false
        s.TextEditable = true
        s.PlaceholderText = "1-10000"

        b(n, "mine", UDim2.new(0.231578946, 0, 0.491228074, 0), UDim2.new(0, 45, 0, 29))
        n.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
        n.Text = "-5"

        t.Parent = f
        t.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
        t.Position = UDim2.new(0.469327301, 0, 0, 0)
        t.Size = UDim2.new(0, 100, 0, 28)
        t.Font = Enum.Font.SourceSans
        t.Text = "RJR FLY"
        t.TextColor3 = Color3.fromRGB(0, 0, 0)
        t.TextScaled = true
        t.TextSize = 14
        t.TextWrapped = true

        c.Name = "Close"
        c.Parent = f
        c.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
        c.Font = Enum.Font.SourceSans
        c.Size = UDim2.new(0, 45, 0, 28)
        c.Text = L("关闭")
        c.TextSize = 30
        c.Position = UDim2.new(0, 0, -1, 27)

        h.Name = "minimize"
        h.Parent = f
        h.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
        h.Font = Enum.Font.SourceSans
        h.Size = UDim2.new(0, 45, 0, 28)
        h.Text = L("隐藏")
        h.TextSize = 30
        h.Position = UDim2.new(0, 44, -1, 27)

        h2.Name = "minimize2"
        h2.Parent = f
        h2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
        h2.Font = Enum.Font.SourceSans
        h2.Size = UDim2.new(0, 45, 0, 28)
        h2.Text = L("显示")
        h2.TextSize = 30
        h2.Position = UDim2.new(0, 44, -1, 57)
        h2.Visible = false

        FlyPanel, FlySpeedBox, FlyStartBtn = m, s, o
        FlySyncButtonText()

        o.MouseButton1Click:Connect(function()
            if FlyOn then
                FlyStop()
            else
                FlyStart()
            end
        end)

        p.MouseButton1Click:Connect(function()
            FlySetSpeed(flySpeed + 5)
        end)

        n.MouseButton1Click:Connect(function()
            FlySetSpeed(flySpeed - 5)
        end)

        local function startHold(delta)
            FlyStopHold()
            FlySetSpeed(flySpeed + delta)
            FlyHoldConn = RunService.Heartbeat:Connect(function()
                FlySetSpeed(flySpeed + delta)
            end)
        end

        u.MouseButton1Down:Connect(function() startHold(1) end)
        u.MouseButton1Up:Connect(FlyStopHold)
        u.MouseLeave:Connect(FlyStopHold)

        d.MouseButton1Down:Connect(function() startHold(-1) end)
        d.MouseButton1Up:Connect(FlyStopHold)
        d.MouseLeave:Connect(FlyStopHold)

        s.FocusLost:Connect(function()
            if s.Text == "" then
                s.Text = tostring(flySpeed)
                return
            end
            local ns = tonumber(s.Text)
            if ns then
                FlySetSpeed(ns)
            else
                s.Text = tostring(flySpeed)
            end
        end)

        c.MouseButton1Click:Connect(function()
            if FlyToggleWidget and FlyToggleWidget.Set then
                pcall(function() FlyToggleWidget:Set(false) end)
            else
                FlyHidePanel()
            end
        end)

        h.MouseButton1Click:Connect(function()
            u.Visible = false
            d.Visible = false
            o.Visible = false
            p.Visible = false
            s.Visible = false
            n.Visible = false
            h.Visible = false
            h2.Visible = true
            f.BackgroundTransparency = 1
            c.Position = UDim2.new(0, 0, -1, 57)
        end)

        h2.MouseButton1Click:Connect(function()
            u.Visible = true
            d.Visible = true
            o.Visible = true
            p.Visible = true
            s.Visible = true
            n.Visible = true
            h.Visible = true
            h2.Visible = false
            f.BackgroundTransparency = 0
            c.Position = UDim2.new(0, 0, -1, 27)
        end)
    end

    local function FlyShowPanel()
        FlyBuildPanel()
    end

    function FlyHidePanel()
        FlyStop()
        FlyDestroyPanel()
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.15)
        flyCharacter = LocalPlayer.Character
        flyHumanoid = flyCharacter and flyCharacter:FindFirstChildOfClass("Humanoid")
        flyRoot = flyCharacter and flyCharacter:FindFirstChild("HumanoidRootPart")
        if FlyOn then
            FlySetupPhysics()
        end
    end)

    FlyToggleWidget = RJR[L("主要功能")]:Toggle({
        Title = L("飞行"),
        Icon = "wind",
        Value = ConfigGet("Fly"),
        Callback = Bind("Fly", { Start = FlyShowPanel, Stop = FlyHidePanel })
    })
    if _G.Fly then
        FlyShowPanel()
    end
end
RJR["ESP"]:Toggle({
    Title = L("ESP 开关"),
    Value = ConfigGet("ESPEnabled"),
    Callback = Bind("ESPEnabled", { Start = EnableESP, Stop = DisableESP })
})
RJR["ESP"]:Toggle({
    Title = L("显示玩家名字"),
    Value = ConfigGet("ESP_Name"),
    Callback = Bind("ESP_Name")
})
RJR["ESP"]:Toggle({
    Title = L("显示玩家等级"),
    Value = ConfigGet("ESP_Level"),
    Callback = Bind("ESP_Level")
})
RJR["ESP"]:Toggle({
    Title = L("显示玩家赏金"),
    Value = ConfigGet("ESP_Bounty"),
    Callback = Bind("ESP_Bounty")
})
RJR["ESP"]:Toggle({
    Title = L("显示恶魔果实"),
    Value = ConfigGet("ESP_Fruit"),
    Callback = Bind("ESP_Fruit")
})
RJR["ESP"]:Toggle({
    Title = L("显示距离"),
    Value = ConfigGet("ESP_Distance"),
    Callback = Bind("ESP_Distance")
})
RJR["ESP"]:Toggle({
    Title = L("显示血量"),
    Value = ConfigGet("ESP_HP"),
    Callback = Bind("ESP_HP")
})
RJR["ESP"]:Toggle({
    Title = L("高亮显示玩家"),
    Value = ConfigGet("ESP_Highlight"),
    Callback = Bind("ESP_Highlight")
})
local function SaveHexColor(key, color)
    _G[key] = string.format("%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5))
    SaveConfiguration()
end
RJR["ESP"]:Colorpicker({
    Title = L("高亮颜色"),
    Default = hexToColor3(_G.ESP_HighlightColor),
    Transparency = 0,
    Callback = function(color)
        SaveHexColor("ESP_HighlightColor", color)
    end
})
RJR["ESP"]:Divider()
RJR["ESP"]:Dropdown({
    Title = L("ESP 排版"),
    Values = {"经典", "血条样式"},
    Value = NormalizeLayout(ConfigGet("ESP_Layout")),
    Callback = Bind("ESP_Layout")
})
RJR["ESP"]:Toggle({
    Title = L("显示玩家头像"),
    Value = ConfigGet("ESP_Avatar"),
    Callback = Bind("ESP_Avatar")
})
RJR["ESP"]:Dropdown({
    Title = L("头像位置"),
    Values = {"左边", "右边"},
    Value = ConfigGet("ESP_AvatarSide"),
    Callback = Bind("ESP_AvatarSide")
})
RJR["ESP"]:Colorpicker({
    Title = L("名字颜色"),
    Default = hexToColor3(_G.ESP_NameColor),
    Callback = function(color)
        SaveHexColor("ESP_NameColor", color)
    end
})
RJR["ESP"]:Colorpicker({
    Title = L("等级颜色"),
    Default = hexToColor3(_G.ESP_LevelColor),
    Callback = function(color)
        SaveHexColor("ESP_LevelColor", color)
    end
})
RJR["ESP"]:Colorpicker({
    Title = L("赏金颜色"),
    Default = hexToColor3(_G.ESP_BountyColor),
    Callback = function(color)
        SaveHexColor("ESP_BountyColor", color)
    end
})
RJR["ESP"]:Colorpicker({
    Title = L("果实颜色"),
    Default = hexToColor3(_G.ESP_FruitColor),
    Callback = function(color)
        SaveHexColor("ESP_FruitColor", color)
    end
})
RJR["ESP"]:Colorpicker({
    Title = L("距离颜色"),
    Default = hexToColor3(_G.ESP_DistanceColor),
    Callback = function(color)
        SaveHexColor("ESP_DistanceColor", color)
    end
})
RJR["ESP"]:Colorpicker({
    Title = L("血量颜色"),
    Default = hexToColor3(_G.ESP_HPColor),
    Callback = function(color)
        SaveHexColor("ESP_HPColor", color)
    end
})
RJR["ESP"]:Slider({
    Title = L("ESP 字体大小"),
    Value = {
        Min = 8,
        Max = 32,
        Default = ConfigGet("ESP_TextSize")
    },
    Callback = Bind("ESP_TextSize")
})

local function ApplyCameraZoom()
    if _G.currentZoom and _G.currentZoom > 0 then
        LocalPlayer.CameraMaxZoomDistance = _G.currentZoom
        LocalPlayer.CameraMinZoomDistance = 0.5
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    ApplyCameraZoom()
end)

task.spawn(function()
    task.wait(0.5)
    ApplyCameraZoom()
end)

local DodgeNoCooldownRunning = false
local function DodgeNoCooldown()
    if _G.DodgeNoCooldown and not DodgeNoCooldownRunning then
        DodgeNoCooldownRunning = true
        task.spawn(function()
            if not getgc or not getupvalues or not setupvalue then DodgeNoCooldownRunning = false; return end

            for i,v in next, getgc() do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Dodge") then
                    if typeof(v) == "function" and getfenv(v).script == char.Dodge then
                        for i2,v2 in next, getupvalues(v) do
                            if tostring(v2) == "0.4" then
                                task.spawn(function()
                                    repeat
                                        setupvalue(v,i2,0)
                                        task.wait(0.1)
                                    until not _G.DodgeNoCooldown
                                    DodgeNoCooldownRunning = false
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end
end

if _G.DodgeNoCooldown then DodgeNoCooldown() end

LocalPlayer.CharacterAdded:Connect(function()
    if _G.DodgeNoCooldown then
        task.wait(1)
        DodgeNoCooldown()
    end
end)

local DashConnection = nil
local function ManageDashLength()
    if _G.DashLengthEnabled then
        if DashConnection then task.cancel(DashConnection) end
        DashConnection = task.spawn(function()
            while _G.DashLengthEnabled do
                task.wait(0.1)
                local character = LocalPlayer.Character
                if character then
                    local currentValue = character:GetAttribute("DashLength")
                    if currentValue ~= _G.DashLength then
                        character:SetAttribute("DashLength", _G.DashLength)
                        character:SetAttribute("DashLengthAir", _G.DashLength)
                    end
                end
            end
        end)
    else
        if DashConnection then
            local character = LocalPlayer.Character
            if character then
                character:SetAttribute("DashLength", 1)
                character:SetAttribute("DashLengthAir", 1)
            end
            task.cancel(DashConnection)
            DashConnection = nil
        end
    end
end
if _G.DashLengthEnabled then ManageDashLength() end

local lavaConnection = nil

local function CheckAndDestroyLava(v)
    if not v then return end
    local name = v.Name
    if name == "Lava" then
        pcall(function() v:Destroy() end)
    elseif name == "LavaParts" then
        local parent = v.Parent
        if parent then
            local pName = parent.Name
            if (pName == "CircleIsland" or pName == "GhostShipInterior") then
                 local grandParent = parent.Parent
                 if grandParent and grandParent.Name == "Map" then
                     pcall(function() v:Destroy() end)
                 end
            end
        end
    end
end

local function StartRemoveLava()
    pcall(function()
        for i, v in pairs(Workspace:GetDescendants()) do
            CheckAndDestroyLava(v)
        end
        for i, v in pairs(ReplicatedStorage:GetDescendants()) do
            CheckAndDestroyLava(v)
        end
    end)
end

local function StopRemoveLava()
    if lavaConnection then
        lavaConnection:Disconnect()
        lavaConnection = nil
    end
end

local function DoRemoveFog()
    pcall(function()
        local lightingService = game:GetService("Lighting")
        if lightingService:FindFirstChild("LightingLayers") then lightingService.LightingLayers:Destroy() end
        if lightingService:FindFirstChild("Sky") then lightingService.Sky:Destroy() end
        lightingService.FogEnd = 9000000000
    end)
end

if _G.RemoveLava then StartRemoveLava() end
if _G.RemoveFog then DoRemoveFog() end

local walkOnWaterConn = nil
local function StartWalkOnWater()
    if walkOnWaterConn then return end
    walkOnWaterConn = task.spawn(function()
        while task.wait(0.2) do
            if not _G.WalkOnWater then break end
            pcall(function()
                local waterBase = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("WaterBase-Plane")
                if waterBase then
                    waterBase.Size = Vector3.new(1000, 112, 1000)
                end
            end)
        end
    end)
end

local function StopWalkOnWater()
    _G.WalkOnWater = false
    pcall(function()
        local waterBase = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("WaterBase-Plane")
        if waterBase then
            waterBase.Size = Vector3.new(1000, 80, 1000)
        end
    end)
end

if _G.WalkOnWater then StartWalkOnWater() end

local waterRemoverConn = nil

local function WaterRemoveTick()
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        local waterBase = map and map:FindFirstChild("WaterBase-Plane")
        if waterBase then
            waterBase:Destroy()
        end
    end)
end

local function StartRemoveWater()
    if waterRemoverConn then return end
    WaterRemoveTick()
    waterRemoverConn = task.spawn(function()
        while _G.RemoveWater do
            task.wait(5)
            if not _G.RemoveWater then break end
            WaterRemoveTick()
        end
        waterRemoverConn = nil
    end)
end

local function StopRemoveWater()
    _G.RemoveWater = false
end

if _G.RemoveWater then StartRemoveWater() end

local CLICK_JUMP_DISTANCE = 300
local clickJumpConn = nil

local function ClickJumpDo()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local cam = Workspace.CurrentCamera
    if not cam then return end

    local ok, ray = pcall(function()
        return cam:ViewportPointToRay(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
    end)
    if not ok or not ray then return end

    local dir = ray.Direction
    if dir.Magnitude < 0.0001 then return end
    dir = dir.Unit

    pcall(function()
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position + dir * CLICK_JUMP_DISTANCE)
end

local function StartClickJump()
    if clickJumpConn then return end
    clickJumpConn = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if not _G.ClickJump then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        pcall(ClickJumpDo)
    end)
end

local function StopClickJump()
    if clickJumpConn then
        clickJumpConn:Disconnect()
        clickJumpConn = nil
    end
end

if _G.ClickJump then StartClickJump() end

local BRING_RANGE = 500
local BRING_FEET_OFFSET = 17
local BRING_OWNER_CHECK_DIST = 300

local bringMobsConnection = nil
local bringMobsCache = {}
local _RunService = RunService
local _Workspace = Workspace

local function GetBringMobsParts(enemy)
    local c = bringMobsCache[enemy]
    if c and c.hum and c.hum.Parent and c.root and c.root.Parent then
        return c
    end
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    local root = enemy:FindFirstChild("HumanoidRootPart")
    if not hum or not root then
        bringMobsCache[enemy] = nil
        return nil
    end
    c = { hum = hum, root = root, collideCleared = false }
    bringMobsCache[enemy] = c
    return c
end

local function BringMobsIsOwner(root)
    local characters = _Workspace:FindFirstChild("Characters")
    if not characters then return true end
    for _, other in ipairs(characters:GetChildren()) do
        if other.Name ~= LocalPlayer.Name then
            local otherRoot = other:FindFirstChild("HumanoidRootPart")
            if otherRoot and (otherRoot.Position - root.Position).Magnitude <= BRING_OWNER_CHECK_DIST then
                return false
            end
        end
    end
    return true
end

local function BringMobsClearCollide(enemy, c)
    if c.collideCleared then return end
    for _, part in ipairs(enemy:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
    c.collideCleared = true
end

local function BringMobsFreeze(c)
    pcall(function() c.hum.WalkSpeed = 0 end)
    pcall(function() c.hum.JumpPower = 0 end)
    pcall(function() c.hum.JumpHeight = 0 end)
    pcall(function() c.hum.UseJumpPower = true end)
end

local function StartBringMobs()
    if bringMobsConnection then return end

    bringMobsConnection = _RunService.Heartbeat:Connect(function()
        if not _G.BringMobs then return end

        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local hum = char:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then return end

            if sethiddenproperty then
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end

            local feet = hrp.Position - Vector3.new(0, BRING_FEET_OFFSET, 0)
            local enemies = _Workspace:FindFirstChild("Enemies")
            if not enemies then return end

            local enemyList = enemies:GetChildren()

            for i = 1, #enemyList do
                local enemy = enemyList[i]
                if enemy:IsA("Model") then
                    local c = GetBringMobsParts(enemy)
                    if c and c.hum.Health > 0 then
                        local distance = (c.root.Position - feet).Magnitude

                        if distance <= BRING_RANGE then
                            BringMobsClearCollide(enemy, c)
                            BringMobsFreeze(c)

                            if distance > 0.5 and BringMobsIsOwner(c.root) then
                                c.root.CFrame = CFrame.new(feet)
                            end
                        end
                    end
                end
            end
        end)
    end)
end

local function StopBringMobs()
    _G.BringMobs = false

    if bringMobsConnection then
        bringMobsConnection:Disconnect()
        bringMobsConnection = nil
    end
    bringMobsCache = {}
end

if _G.BringMobs then StartBringMobs() end

RJR[L("杂项")]:Slider({
    Title = L("视角缩放距离"),
    Value = {
        Min = 1,
        Max = 10000,
        Default = _G.currentZoom or 128
    },
    Callback = function(value)
        _G.currentZoom = value
        ApplyCameraZoom()
        SaveConfiguration()
    end
})

RJR[L("杂项")]:Toggle({
    Title = L("冲刺无冷却"),
    Value = _G.DodgeNoCooldown,
    Callback = function(v)
        _G.DodgeNoCooldown = v
        if v then DodgeNoCooldown() end
        SaveConfiguration()
    end
})

RJR[L("杂项")]:Toggle({
    Title = L("冲刺距离修改开关"),
    Value = _G.DashLengthEnabled,
    Callback = function(state)
        _G.DashLengthEnabled = state
        ManageDashLength()
        SaveConfiguration()
    end
})

RJR[L("杂项")]:Slider({
    Title = L("冲刺距离"),
    Value = {
        Min = 20,
        Max = 300,
        Default = _G.DashLength or 50
    },
    Callback = function(value)
        _G.DashLength = value
        if _G.DashLengthEnabled then ManageDashLength() end
        SaveConfiguration()
    end
})

RJR[L("杂项")]:Button({
    Title = L("减画质"),
    Icon = "monitor",
    Callback = function()
        pcall(function()
            for _, descendant in pairs(game:GetDescendants()) do
                if descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart") then
                    descendant.Material = "Plastic"
                    descendant.Reflectance = 0
                elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                    descendant.Transparency = 1
                elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                    descendant.Lifetime = NumberRange.new(0)
                elseif descendant:IsA("Explosion") then
                    descendant.BlastPressure = 1
                    descendant.BlastRadius = 1
                elseif descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") then
                    descendant.Enabled = false
                end
            end
        end)
    end
})

RJR[L("杂项")]:Toggle({
    Title = L("移除岩浆 (需重进恢复)"),
    Value = ConfigGet("RemoveLava"),
    Callback = Bind("RemoveLava", { Start = StartRemoveLava, Stop = StopRemoveLava })
})

RJR[L("杂项")]:Toggle({
    Title = L("移除雾 (需重进恢复)"),
    Value = ConfigGet("RemoveFog"),
    Callback = Bind("RemoveFog", function(v)
        if v then DoRemoveFog() end
    end)
})

RJR[L("杂项")]:Toggle({
    Title = L("水上行走"),
    Value = ConfigGet("WalkOnWater"),
    Callback = Bind("WalkOnWater", { Start = StartWalkOnWater, Stop = StopWalkOnWater })
})

RJR[L("杂项")]:Toggle({
    Title = L("删除水面"),
    Value = ConfigGet("RemoveWater"),
    Callback = Bind("RemoveWater", { Start = StartRemoveWater, Stop = StopRemoveWater })
})

RJR[L("杂项")]:Toggle({
    Title = L("解帧数限制 (仅电脑)"),
    Value = false,
    Callback = function(v)
        if v and setfpscap then
            setfpscap(999)
        end
    end
})

RJR[L("杂项")]:Toggle({
    Title = L("左键位移"),
    Value = ConfigGet("ClickJump"),
    Callback = Bind("ClickJump", { Start = StartClickJump, Stop = StopClickJump })
})

RJR[L("杂项")]:Toggle({
    Title = L("聚怪"),
    Value = ConfigGet("BringMobs") or false,
    Callback = Bind("BringMobs", { Start = StartBringMobs, Stop = StopBringMobs })
})

RJR[L("商店")]:Button({
    Title = L("重置数据"),
    Icon = "refresh-cw",
    Callback = function()
        local args = {
            "BlackbeardReward",
            "Refund",
            "2"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end
})
RJR[L("商店")]:Button({
    Title = L("重置种族"),
    Icon = "shuffle",
    Callback = function()
        local args = {
            "BlackbeardReward",
            "Reroll",
            "2"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end
})
RJR[L("商店")]:Button({
    Title = L("切换海盗"),
    Icon = "anchor",
    Callback = function()
        local args = {
            "SetTeam",
            "Pirates"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end
})
RJR[L("商店")]:Button({
    Title = L("切换海军"),
    Icon = "shield",
    Callback = function()
        local args = {
            "SetTeam",
            "Marines"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end
})
RJR[L("商店")]:Button({
    Title = L("更换吸血鬼"),
    Icon = "moon",
    Callback = function()
        local args = {"Ectoplasm", "Change", 4}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end
})
RJR[L("商店")]:Button({
    Title = L("更换机器人"),
    Icon = "cpu",
    Callback = function()
        local args = {"CyborgTrainer", "Buy"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end
})

RJR[L("公告")]:Paragraph({
    Title = L("DC 服务器"),
    Desc = "https://discord.gg/rjrhub",
    Buttons = {{
        Title = L("点击复制 DC 链接"),
        Callback = function()
            setclipboard("https://discord.gg/rjrhub")
            WindUI:Notify({ Title = L("复制成功"), Content = L("已复制 DC 链接"), Duration = 2 })
        end
    }}
})



RJR[L("服务器")]:Button({
    Title = L("重进服务器"),
    Callback = function()
        local args = {
            "teleport",
            game.JobId
        }
        game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(unpack(args))
    end
})

local function FormatNumber(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    local left, num, right = s:match("^([^%d]*%d)(%d*)(.-)$")
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

local function ApplyPlayerRange(label)
    _G.HopPlayerRange = label
    local minPlayers, maxPlayers = label:match("(%d+)%-(%d+)")
    if minPlayers and maxPlayers then
        _G.HopMinPlayers = tonumber(minPlayers)
        _G.HopMaxPlayers = tonumber(maxPlayers)
        return
    end
    _G.HopMinPlayers = 1
    _G.HopMaxPlayers = 12
end

local function ApplyBountyRange(label)
    _G.HopBountyRange = label
    local minOnly = label:match("大于([%d%.]+[Mm]?)")
    if minOnly then
        local num, unit = minOnly:match("([%d%.]+)([Mm]?)")
        local value = tonumber(num) or 0
        if unit and unit:lower() == "m" then value = value * 1000000 end
        _G.HopMinBounty = value + 1
        _G.HopMaxBounty = 999999999
        return
    end
    _G.HopMinBounty = 0
    _G.HopMaxBounty = 999999999
end

local function ParseServerInfo(text)
    if type(text) ~= "string" or text == "" then return nil end
    local region = text:match("Region:%s*(.-)%s*%-%s*Players:")
    local cur, max = text:match("Players:%s*(%d+)%s*/%s*(%d+)")
    local bt = text:match("Bounty:%s*([%d,]+)")
    if not cur or not max or not bt then return nil end
    local bounty = tonumber((bt:gsub(",", "")))
    if not bounty then return nil end
    return { Region = region or "Unknown", Players = tonumber(cur), MaxPlayers = tonumber(max), Bounty = bounty }
end

local function IsServerAllowed(info)
    if not info then return false end
    if info.Players < _G.HopMinPlayers or info.Players > _G.HopMaxPlayers then return false end
    if info.Bounty < _G.HopMinBounty or info.Bounty > _G.HopMaxBounty then return false end
    return true
end

ApplyPlayerRange(_G.HopPlayerRange)
ApplyBountyRange(_G.HopBountyRange)

local ServerHopCache = { List = nil, Fetching = false }

local function FetchServerList(timeout)
    local browser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
    if not browser then return nil end
    local servers = {}
    local pending = 0
    for page = 1, 100 do
        pending = pending + 1
        task.delay(page * 0.02, function()
            local ok, result = pcall(function()
                return browser:InvokeServer(page)
            end)
            if not ok then
                local tries = 0
                repeat
                    task.wait(0.5)
                    tries = tries + 1
                    ok, result = pcall(function()
                        return browser:InvokeServer(page)
                    end)
                until ok or tries >= 2
            end
            if ok and type(result) == "table" then
                for job, info in pairs(result) do
                    if type(info) == "table" then
                        servers[job] = {
                            Region = tostring(info.Region or "Unknown"),
                            Count = tonumber(info.Count) or 0,
                            Bounty = tonumber(info.Bounty) or 0,
                        }
                    end
                end
            end
            pending = pending - 1
        end)
    end
    local deadline = tick() + (timeout or 20)
    while pending > 0 and tick() < deadline do
        task.wait(0.1)
    end
    return servers
end

local function GetServerList()
    if ServerHopCache.List then
        return ServerHopCache.List
    end
    if ServerHopCache.Fetching then
        local deadline = tick() + 25
        while ServerHopCache.Fetching and tick() < deadline do
            task.wait(0.1)
        end
        return ServerHopCache.List
    end
    ServerHopCache.Fetching = true
    local ok, servers = pcall(FetchServerList, 20)
    ServerHopCache.Fetching = false
    if ok and type(servers) == "table" and next(servers) ~= nil then
        ServerHopCache.List = servers
    end
    return ServerHopCache.List
end

local function MatchServerInfo(info)
    if not info then return false end
    local regionFilter = tostring(_G.ServerRegion or ""):lower()
    if regionFilter ~= "" then
        local region = tostring(info.Region or ""):lower()
        if not region:find(regionFilter, 1, true) then return false end
    end
    local count = tonumber(info.Count) or 0
    if count < _G.HopMinPlayers or count > _G.HopMaxPlayers then return false end
    local bounty = tonumber(info.Bounty) or 0
    if bounty < _G.HopMinBounty or bounty > _G.HopMaxBounty then return false end
    return true
end

local function PickServer(servers)
    if type(servers) ~= "table" then return nil end
    local currentJob = game.JobId
    local matches = {}
    for job, info in pairs(servers) do
        if job ~= currentJob and MatchServerInfo(info) then
            table.insert(matches, {
                Job = job,
                Region = info.Region,
                Count = info.Count,
                Bounty = info.Bounty,
            })
        end
    end
    if #matches == 0 then return nil end
    return matches[math.random(1, #matches)]
end

local function LegacyServerHop()
    local PlayerGui = LocalPlayer.PlayerGui
    if not PlayerGui:FindFirstChild("ServerBrowser") then return false end

    PlayerGui.ServerBrowser.Enabled = true
    task.wait(0.1)

    local Filters = PlayerGui.ServerBrowser.Frame:FindFirstChild("Filters")
    local SearchRegion = Filters and Filters:FindFirstChild("SearchRegion")
    local TextBox = SearchRegion and SearchRegion:FindFirstChild("TextBox")
    if not TextBox then return false end

    TextBox.Text = _G.ServerRegion

    local Full = Filters and Filters:FindFirstChild("Full")
    local FullCheck = Full and Full:FindFirstChild("Check")
    if FullCheck then
        FullCheck.Text = "\226\156\148\239\184\143"
        task.wait(0.1)
    end

    local ScrollingFrame = PlayerGui.ServerBrowser.Frame.ScrollingFrame
    local FakeScroll = PlayerGui.ServerBrowser.Frame.FakeScroll
    local Inside = FakeScroll.Inside

    task.spawn(function()
        while getgenv().IsServerHopping do
            ScrollingFrame.CanvasPosition = Vector2.new(0, math.random(100, 7000))
            task.wait(0.3)
        end
    end)

    task.wait()

    local currentJobId = game.JobId
    local ServerBrowserRemote = ReplicatedStorage:WaitForChild("__ServerBrowser")
    local passes = 0

    while getgenv().IsServerHopping and passes < 6 do
        passes = passes + 1
        for _, template in ipairs(Inside:GetChildren()) do
            if template.Name == "Template" then
                local joinButton = template:FindFirstChild("Join")
                local textLabel = template:FindFirstChild("TextLabel")
                local info = textLabel and ParseServerInfo(textLabel.Text)

                if joinButton and info and IsServerAllowed(info) then
                    local job = joinButton:GetAttribute("Job")
                    if job and tostring(job):find("-", 1, true) then
                        job = tostring(job)
                        if job ~= currentJobId then
                            WindUI:Notify({
                                Title = L("匹配到服务器"),
                                Content = L("地区: ") .. tostring(info.Region) .. "\n"
                                    .. L("人数: ") .. info.Players .. "/" .. info.MaxPlayers .. "\n"
                                    .. L("赏金: ") .. FormatNumber(info.Bounty),
                                Icon = "wind",
                                Duration = 5
                            })

                            local success = pcall(function()
                                ServerBrowserRemote:InvokeServer("teleport", job)
                            end)
                            if not success then
                                pcall(function()
                                    ServerBrowserRemote:InvokeServer("teleport", job)
                                end)
                            end
                            task.wait(0.3)
                            return true
                        end
                    end
                end
            end
        end
        task.wait(3)
    end
    return false
end

RJR[L("服务器")]:Dropdown({
    Title = L("选择服务器区域"),
    Desc = L("跳服时搜索的服务器区域"),
    Values = {"Oregon", "Florida", "Texas", "California", "Hong Kong", "Germany", "Brazil", "Singapore"},
    Value = _G.ServerRegion,
    Callback = function(v)
        _G.ServerRegion = v
        SaveConfiguration()
        WindUI:Notify({ Title = L("区域设置"), Content = L("已切换为: ") .. v, Duration = 2 })
    end
})

RJR[L("服务器")]:Dropdown({
    Title = L("选择人数"),
    Desc = L("跳服时过滤人数范围"),
    Values = {"1-12", "3-12", "5-12", "7-12", "9-12"},
    Value = _G.HopPlayerRange,
    Callback = function(v)
        ApplyPlayerRange(v)
        SaveConfiguration()
        WindUI:Notify({ Title = L("人数设置"), Content = v .. " (" .. _G.HopMinPlayers .. "-" .. _G.HopMaxPlayers .. ")", Duration = 2 })
    end
})

RJR[L("服务器")]:Dropdown({
    Title = L("选择赏金"),
    Desc = L("跳服时过滤赏金范围"),
    Values = {"大于3m", "大于5m", "大于10m", "大于15m", "大于25m", "大于35m", "大于50m"},
    Value = _G.HopBountyRange,
    Callback = function(v)
        ApplyBountyRange(v)
        SaveConfiguration()
        WindUI:Notify({ Title = L("赏金设置"), Content = v .. " (" .. FormatNumber(_G.HopMinBounty) .. " - " .. FormatNumber(_G.HopMaxBounty) .. ")", Duration = 2 })
    end
})

RJR[L("服务器")]:Button({
    Title = L("跳服"),
    Icon = "wind",
    Callback = function()
        if getgenv().IsServerHopping == true then return end

        getgenv().IsServerHopping = true
        getgenv().ShuttingDown = true

        WindUI:Notify({
            Title = L("自动跳服"),
            Content = L("准备跳服...") .. "\n\n"
                .. L("设置区域为: ") .. _G.ServerRegion .. "\n"
                .. L("人数: ") .. _G.HopPlayerRange .. "\n"
                .. L("赏金: ") .. _G.HopBountyRange,
            Icon = "wind",
            Duration = 10
        })

        task.spawn(function()
            local servers = GetServerList()
            local total = 0
            if type(servers) == "table" then
                for _ in pairs(servers) do total = total + 1 end
            end

            local target = PickServer(servers)

            if not target then
                if total > 0 then
                    getgenv().IsServerHopping = false
                    WindUI:Notify({
                        Title = L("自动跳服"),
                        Content = L("未找到匹配的服务器"),
                        Icon = "wind",
                        Duration = 10
                    })
                    return
                end

                if LegacyServerHop() then return end

                getgenv().IsServerHopping = false
                WindUI:Notify({
                    Title = L("自动跳服"),
                    Content = L("跳服失败") .. "\n\n" .. L("请重新加入游戏"),
                    Icon = "wind",
                    Duration = 10
                })
                return
            end

            WindUI:Notify({
                Title = L("匹配到服务器"),
                Content = L("地区: ") .. tostring(target.Region) .. "\n"
                    .. L("人数: ") .. target.Count .. "/" .. Players.MaxPlayers .. "\n"
                    .. L("赏金: ") .. FormatNumber(target.Bounty),
                Icon = "wind",
                Duration = 5
            })

            local browser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
            local ok = false
            if browser then
                ok = pcall(function()
                    browser:InvokeServer("teleport", target.Job)
                end)
            end
            if not ok then
                getgenv().IsServerHopping = false
                WindUI:Notify({
                    Title = L("自动跳服"),
                    Content = L("跳服失败") .. "\n\n" .. L("请重新加入游戏"),
                    Icon = "wind",
                    Duration = 10
                })
                return
            end
            task.wait(0.3)
        end)
    end
})

RJR[L("服务器")]:Paragraph({
    Title = L("服务器id"),
    Desc = game.JobId,
    Buttons = {{
        Title = "Copy",
        Callback = function()
            setclipboard(game.JobId)
            WindUI:Notify({ Title = L("复制成功"), Content = L("已复制当前服务器ID"), Duration = 2 })
        end
    }}
})

RJR[L("服务器")]:Input({
    Title = L("输入服务器id"),
    Value = _G.JobId,
    Callback = function(value)
        _G.JobId = value
        SaveConfiguration()
    end
})

RJR[L("服务器")]:Button({
    Title = L("加入服务器 id"),
    Callback = function()
        if not _G.JobId or _G.JobId == "" then
            WindUI:Notify({ Title = L("操作失败"), Content = L("请先输入服务器ID"), Duration = 2 })
            return
        end
        local args = {
            "teleport",
            _G.JobId
        }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(unpack(args))
        end)
    end
})

local currentThemeName = WindUI:GetCurrentTheme()
local availableThemes = WindUI:GetThemes()
local themeList = {}
for themeName, _ in pairs(availableThemes) do
    table.insert(themeList, themeName)
end

RJR[L("设置")]:Keybind({
    Title = L("窗口切换键"),
    Desc = L("切换窗口显示状态"),
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local function GetPlayerList()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    table.sort(playerList)
    return playerList
end

local function SetCollide()
    local character = LocalPlayer.Character
    if not character then return end
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.CanTouch   = true
            v.CanQuery   = true
        end
    end
end

local function SetNoCollide()
    local character = LocalPlayer.Character
    if not character then return end
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.CanTouch   = true
            v.CanQuery   = true
        end
    end
end

local ActiveTween = nil

local function GetTweenSpeed()
    local v = tonumber(_G.TweenSpeed)
    if not v then return 180 end
    if v < 0 then v = 0 end
    if v > 500 then v = 500 end
    return v
end

local function topos(Pos, Speed)
    if not LocalPlayer or not LocalPlayer.Character then return end
    local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not HRP or not Humanoid then return end

    HRP.AssemblyLinearVelocity  = Vector3.zero
    HRP.AssemblyAngularVelocity = Vector3.zero
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    local Distance = (Pos.Position - HRP.Position).Magnitude

    Speed = tonumber(Speed) or 300
    if Speed < 1 then Speed = 1 end

    if ActiveTween then ActiveTween:Cancel() end

    ActiveTween = game:GetService("TweenService"):Create(
        HRP,
        TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    )

    local isActive = true
    task.spawn(function()
        while isActive and ActiveTween and ActiveTween.PlaybackState == Enum.PlaybackState.Playing do
            SetNoCollide()
            task.wait(0.001)
        end
    end)

    ActiveTween:Play()

    ActiveTween.Completed:Connect(function()
        isActive = false
        if Humanoid then
            SetCollide()
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)

    task.delay(0.05, function()
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

local function StopTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local bodyClip = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip")
        if bodyClip then bodyClip:Destroy() end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Highlight") then
        LocalPlayer.Character.Highlight:Destroy()
    end
end

local function validateOffset(val)
    local num = tonumber(val)
    if not num then return 0 end
    return math.clamp(num, -3000, 3000)
end

local PlayerDropdown = RJR[L("传送")]:Dropdown({
    Title = L("选择目标玩家"),
    Values = GetPlayerList(),
    Value = _G.SelectPly,
    Callback = function(selectedValue)
        if selectedValue and selectedValue ~= "" then
            _G.SelectPly = selectedValue
            WindUI:Notify({ Title = L("选择目标玩家"), Content = L("已设置为") .. selectedValue, Duration = 2 })
        else
            _G.SelectPly = ""
        end
    end
})

RJR[L("传送")]:Button({
    Title = L("刷新玩家列表"),
    Callback = function()
        local newPlayerList = GetPlayerList()
        if PlayerDropdown and PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(newPlayerList, true)
        end
        if _G.SelectPly ~= "" and PlayerDropdown and PlayerDropdown.SetValue then
            for _, name in ipairs(newPlayerList) do
                if name == _G.SelectPly then
                    pcall(function() PlayerDropdown:SetValue(_G.SelectPly) end)
                    break
                end
            end
        end
        WindUI:Notify({ Title = L("刷新玩家列表"), Content = L("加载完成"), Duration = 2 })
    end
})

getgenv().Key = "1"
getgenv().Key2 = "test"
getgenv().test = "hello"
RJR[L("传送")]:Toggle({
    Title = L("观战玩家"),
    Value = _G.SpectatePlys,
    Callback = function(value)
        _G.SpectatePlys = value
        if value and _G.SelectPly == "" then
            WindUI:Notify({ Title = L("操作失败"), Content = L("请先选择目标玩家"), Duration = 2 })
            _G.SpectatePlys = false
            return
        end
        task.spawn(function()
            local Camera = workspace.CurrentCamera
            repeat
                task.wait(0.1)
                local TargetPlr = Players:FindFirstChild(_G.SelectPly)
                if not TargetPlr or not TargetPlr.Character or not TargetPlr.Character:FindFirstChildOfClass("Humanoid") then
                    WindUI:Notify({ Title = L("观战中断"), Content = L("目标玩家不存在/角色消失"), Duration = 2 })
                    _G.SpectatePlys = false
                    break
                end
                Camera.CameraSubject = TargetPlr.Character.Humanoid
            until _G.SpectatePlys == false
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
                WindUI:Notify({ Title = L("观战结束"), Content = L("已恢复本地视角"), Duration = 2 })
            end
        end)
    end
})

local TeleportPlyConnection

RJR[L("传送")]:Toggle({
    Title = L("平滑传送至玩家"),
    Value = _G.TeleportPly,
    Callback = function(value)
        _G.TeleportPly = value
        if value and _G.SelectPly == "" then
            WindUI:Notify({ Title = L("操作失败"), Content = L("请先选择目标玩家"), Duration = 2 })
            _G.TeleportPly = false
            return
        end

        if TeleportPlyConnection then
            TeleportPlyConnection:Disconnect()
            TeleportPlyConnection = nil
        end

        if value then
            WindUI:Notify({
                Title = L("传送开启"),
                Content = L("已开始传送玩家（偏移X:")..(_G.TeleportOffsetX).." Y:"..(_G.TeleportOffsetY).." Z:"..(_G.TeleportOffsetZ).."）",
                Duration = 2
            })

            TeleportPlyConnection = RunService.Stepped:Connect(function()
                if not _G.TeleportPly then
                    if TeleportPlyConnection then
                        TeleportPlyConnection:Disconnect()
                        TeleportPlyConnection = nil
                    end
                    return
                end

                local TargetPlr = Players:FindFirstChild(_G.SelectPly)
                if not TargetPlr or not TargetPlr.Character or not TargetPlr.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end

                local targetCFrame = TargetPlr.Character.HumanoidRootPart.CFrame + Vector3.new(_G.TeleportOffsetX, _G.TeleportOffsetY, _G.TeleportOffsetZ)
                topos(targetCFrame, GetTweenSpeed())
            end)
        else
            if TeleportPlyConnection then
                TeleportPlyConnection:Disconnect()
                TeleportPlyConnection = nil
            end
            StopTween()
            WindUI:Notify({ Title = L("传送关闭"), Content = L("已停止传送目标玩家"), Duration = 2 })
        end
    end
})

local function DirectTeleport(pos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not pos then
        return false
    end

    SetNoCollide()
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(pos)
    end)

    task.spawn(function()
        task.wait(0.1)
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", pos)
        end)
    end)

    return true
end

local Sea3Islands = {
    ["Castle On The Sea"] = { Pos = Vector3.new(-4999.45, 314.56, -3010.54), SpawnId = "SeaCastle" },
    ["Port Town"] = { Pos = Vector3.new(-378.27, 20.66, 5537.93), SpawnId = "Default" },
    ["Hydra"] = { Pos = Vector3.new(5404.45, 1004.13, 506.21), SpawnId = "Hydra1" },
    ["Hydra2"] = { Pos = Vector3.new(3496.55, 51.37, 1873.13), SpawnId = "Hydra2" },
    ["Great Tree"] = { Pos = Vector3.new(2148.34, 21.76, -6652.35), SpawnId = "GreatTree" },
    ["Floating Turtle"] = { Pos = Vector3.new(-11352.54, 331.77, -10368.93), SpawnId = "PineappleTown" },
    ["Mansion"] = { Pos = Vector3.new(-12592.93, 336.96, -7470.36), SpawnId = "BigMansion" },
    ["Haunted Castle"] = { Pos = Vector3.new(-9625.31, 141.37, 5393.04), SpawnId = "HauntedCastle" },
    ["Sea Of Treats"] = { Pos = Vector3.new(-2145.42, 37.84, -11895.08), SpawnId = "Loaf" },
    ["Tiki Outpost"] = { Pos = Vector3.new(-16228.08, 9.11, 446.06), SpawnId = "Tiki" },
}

local TeleportLocations = {}
if World2 then
    TeleportLocations = {
        ["豪宅"] = Vector3.new(-390, 332, 673),
        ["天鹅房间"] = Vector3.new(2285, 15, 905),
        ["鬼船"] = Vector3.new(923, 126, 32852),
        ["僵尸岛"] = Vector3.new(-6509, 83, -133),
    }
elseif World3 then
    TeleportLocations = {
        ["海洋城堡"] = Sea3Islands["Castle On The Sea"].Pos,
        ["海龟豪宅"] = Sea3Islands["Floating Turtle"].Pos,
        ["司法"] = Vector3.new(-5096.48, 316.43, -3177.91),
        ["九头蛇"] = Sea3Islands["Hydra"].Pos,
    }
end

local IslandsLoaded = false

local AddLoDTag
do
    local CollectionService = game:GetService("CollectionService")
    AddLoDTag = function(part)
        if typeof(part.AddTag) == "function" then
            local ok = pcall(function() part:AddTag("LoDPosition") end)
            if ok then return true end
        end
        if typeof(part.SetAttribute) == "function" then
            local ok = pcall(function() part:SetAttribute("LoDPosition", true) end)
            if ok then return true end
        end
        return pcall(function() CollectionService:AddTag(part, "LoDPosition") end)
    end
end

local function LoadAllIslands()
    if IslandsLoaded or not World3 then
        return
    end
    IslandsLoaded = true
    task.spawn(function()
        local camera = workspace.CurrentCamera
        for _, data in pairs(Sea3Islands) do
            pcall(function()
                local part = Instance.new("Part")
                part.Name = "RJR_LoD_" .. tostring(data.SpawnId)
                part.Anchored = true
                part.Transparency = 1
                part.CanCollide = false
                part.CanQuery = false
                part.CanTouch = false
                part.Size = Vector3.zero
                part.CFrame = CFrame.new(data.Pos)
                AddLoDTag(part)
                part.Parent = camera or workspace
            end)
            task.wait(0.4)
        end
    end)
end

LoadAllIslands()

local ChaseAPI = { Start = nil, Stop = nil, HotkeyTarget = nil }

do

local ChaseCFG = {
    snapDist       = 70,
    snapInterval   = 0.01,
    predictLead    = 0.18,
    sampleInterval = 0.08,
}

local ChaseActive = nil
local ChaseConn = nil
local ChaseLastSnap = 0
local ChaseSample = nil

local function ChaseStop()
    if ChaseConn then ChaseConn:Disconnect() ChaseConn = nil end
    StopTween()
    ChaseActive = nil
    ChaseSample = nil
end

local function ChaseStart(mode)
    ChaseStop()
    ChaseActive = mode
    ChaseConn = RunService.Stepped:Connect(function()
        if not ChaseActive then return end
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if not myHRP or not myHum or myHum.Health <= 0 then
            return
        end

        local tH = nil
        if ChaseActive == "player" then
            local tPlr = Players:FindFirstChild(_G.SelectPly)
            tH = tPlr and tPlr.Character and tPlr.Character:FindFirstChild("HumanoidRootPart")
        elseif ChaseActive == "hotkey" then
            local tPlr = ChaseAPI.HotkeyTarget
            tH = tPlr and tPlr.Parent and tPlr.Character and tPlr.Character:FindFirstChild("HumanoidRootPart")
        elseif ChaseActive == "nearest" then
            local bestDist = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local c = p.Character
                    local h = c and c:FindFirstChild("HumanoidRootPart")
                    local hum = c and c:FindFirstChildOfClass("Humanoid")
                    if h and hum and hum.Health > 0 then
                        local d = (h.Position - myHRP.Position).Magnitude
                        if d < bestDist then bestDist, tH = d, h end
                    end
                end
            end
        end
        if not tH then return end

        local targetPos = tH.Position
        local myPos = myHRP.Position
        local dist = (myPos - targetPos).Magnitude

        local vel = Vector3.zero
        local now = tick()
        if ChaseSample then
            local dt = now - ChaseSample.t
            if dt > 0 and dt < 1 and (targetPos - ChaseSample.pos).Magnitude <= 500 then
                vel = (targetPos - ChaseSample.pos) / dt
            end
        end
        if not ChaseSample or now - ChaseSample.t >= ChaseCFG.sampleInterval then
            ChaseSample = { pos = targetPos, t = now }
        end

        local off = Vector3.new(_G.TeleportOffsetX, _G.TeleportOffsetY, _G.TeleportOffsetZ)

        if dist <= ChaseCFG.snapDist then
            StopTween()
            myHRP.AssemblyLinearVelocity = Vector3.zero
            if now - ChaseLastSnap >= ChaseCFG.snapInterval then
                ChaseLastSnap = now
                pcall(function() myHRP.CFrame = tH.CFrame + vel * ChaseCFG.predictLead + off end)
            end
        else
            topos(tH.CFrame + off, GetTweenSpeed())
        end
    end)
end

ChaseAPI.Start = ChaseStart
ChaseAPI.Stop = ChaseStop

local Lock2Toggle = RJR[L("传送")]:Toggle({
    Title = L("锁人2"),
    Value = _G.Lock2,
    Callback = function(value)
        _G.Lock2 = value
        if value then
            if _G.SelectPly == "" then
                WindUI:Notify({ Title = L("操作失败"), Content = L("请先选择目标玩家"), Duration = 2 })
                _G.Lock2 = false
                return
            end
            _G.TweenNearest = false
            ChaseStart("player")
            WindUI:Notify({ Title = L("锁人2开启"), Content = L("平滑追踪目标，近距离自动锁定"), Duration = 2 })
        else
            ChaseStop()
            WindUI:Notify({ Title = L("锁人2关闭"), Content = L("已停止锁定目标"), Duration = 2 })
        end
        SaveConfiguration()
    end
})

local NearestToggle = RJR[L("传送")]:Toggle({
    Title = L("传送至最近玩家"),
    Value = _G.TweenNearest,
    Callback = function(value)
        _G.TweenNearest = value
        if value then
            _G.Lock2 = false
            ChaseStart("nearest")
            WindUI:Notify({ Title = L("最近玩家传送开启"), Content = L("平滑追踪最近的玩家"), Duration = 2 })
        else
            ChaseStop()
            WindUI:Notify({ Title = L("最近玩家传送关闭"), Content = L("已停止锁定目标"), Duration = 2 })
        end
        SaveConfiguration()
    end
})

pcall(function()
    if Lock2Toggle.Unlock then Lock2Toggle:Unlock() end
    if NearestToggle.Unlock then NearestToggle:Unlock() end
end)

if _G.Lock2 and _G.SelectPly ~= "" then
    ChaseStart("player")
elseif _G.TweenNearest then
    ChaseStart("nearest")
end
end

RJR[L("传送")]:Slider({
    Title = L("统一传送速度"),
    Value = {
        Min = 0,
        Max = 500,
        Default = ConfigGet("TweenSpeed") or 180
    },
    Callback = Bind("TweenSpeed")
})

RJR[L("传送")]:Divider()

for name, pos in pairs(TeleportLocations) do
    RJR[L("传送")]:Button({
        Title = L(name),
        Icon = "map",
        Callback = function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if DirectTeleport(pos) then
                    WindUI:Notify({
                        Title = L("快捷传送点"),
                        Content = L("已设置为 ") .. name,
                        Duration = 2
                    })
                end
            end
        end
    })
end

RJR[L("传送")]:Input({
    Title = L("X轴偏移"),
    Value = tostring(_G.TeleportOffsetX),
    Placeholder = "-3000 - 3000",
    Callback = function(inputVal)
        _G.TeleportOffsetX = validateOffset(inputVal)
        SaveConfiguration()
    end
})

RJR[L("传送")]:Input({
    Title = L("Y轴偏移"),
    Value = tostring(_G.TeleportOffsetY),
    Placeholder = "-3000 - 3000",
    Callback = function(inputVal)
        _G.TeleportOffsetY = validateOffset(inputVal)
        SaveConfiguration()
    end
})

RJR[L("传送")]:Input({
    Title = L("Z轴偏移"),
    Value = tostring(_G.TeleportOffsetZ),
    Placeholder = "-3000 - 3000",
    Callback = function(inputVal)
        _G.TeleportOffsetZ = validateOffset(inputVal)
        SaveConfiguration()
    end
})

RJR[L("设置")]:Dropdown({
    Title = L("选择主题"),
    Values = themeList,
    Value = _G.Theme,
    Callback = function(v)
        _G.Theme = v
        WindUI:SetTheme(v)
    end
})

RJR[L("设置")]:Button({
    Title = L("保存配置"),
    Callback = function()
        SaveConfig(true)
        WindUI:Notify({ Title = L("保存配置"), Content = L("加载完成"), Duration = 2 })
    end
})

RJR[L("设置")]:Button({
    Title = L("加载配置"),
    Callback = function()
        LoadConfig()
        WindUI:Notify({ Title = L("加载配置"), Content = L("加载完成"), Duration = 2 })
    end
})

local function IsAlive(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local c = Drawing.new("Circle")
c.Visible = false
c.Color = Color3.fromRGB(255, 0, 0)
c.Radius = 150
c.Thickness = 2
c.Filled = false

local Line = Drawing.new("Line")
Line.Thickness = 2
Line.Color = Color3.fromRGB(255, 0, 0)
Line.Transparency = 1
Line.Visible = false

local LOCK_RING_BASE    = 26
local LOCK_RING_GROW    = 30
local LOCK_RING_PERIOD  = 1.1
local LOCK_RING_THICK   = 2
local LOCK_RING_HUE_CYC = 3.0

local function LockRingColor(hue)
    local h = (hue % 1) * 6
    local x = 1 - math.abs(h % 2 - 1)
    local r, g, b
    if h < 1 then      r, g, b = 1, x, 0
    elseif h < 2 then  r, g, b = x, 1, 0
    elseif h < 3 then  r, g, b = 0, 1, x
    elseif h < 4 then  r, g, b = 0, x, 1
    elseif h < 5 then  r, g, b = x, 0, 1
    else               r, g, b = 1, 0, x end
    return Color3.new(r, g, b)
end

local lockRings = {}
for i = 1, 3 do
    local ring = Drawing.new("Circle")
    ring.Filled = false
    ring.Thickness = LOCK_RING_THICK
    ring.Color = LockRingColor((i - 1) / 3)
    ring.NumSides = 60
    ring.Visible = false
    lockRings[i] = ring
end

local function LockRingsHide()
    for _, ring in ipairs(lockRings) do
        if ring.Visible then ring.Visible = false end
    end
end

local function LockRingsUpdate(screenPos)
    local now = os.clock()
    local hueShift = now / LOCK_RING_HUE_CYC
    for i, ring in ipairs(lockRings) do
        local phase = ((now - (i - 1) * LOCK_RING_PERIOD / #lockRings) % LOCK_RING_PERIOD) / LOCK_RING_PERIOD
        ring.Position = screenPos
        ring.Radius = LOCK_RING_BASE + LOCK_RING_GROW * phase
        ring.Transparency = 1 - phase * 0.85
        ring.Color = LockRingColor(hueShift + (i - 1) / #lockRings)
        ring.Visible = true
    end
end

if _G.SilentAimShowFOV then c.Visible = true end
if _G.SilentAimFOV then c.Radius = _G.SilentAimFOV end

task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if not c.Visible then return end

        local p
        if _G.FOVMode == "屏幕中心" then
            local v = workspace.CurrentCamera.ViewportSize
            p = Vector2.new(v.X / 2, v.Y / 2)
        else
            p = UIS:GetMouseLocation()
            if p.X <= 0 or p.Y <= 0 then
                local v = workspace.CurrentCamera.ViewportSize
                p = Vector2.new(v.X / 2, v.Y / 2)
            end
        end
        c.Position = p
    end)
end)

local currentSilentAimTarget = nil

local function IsSilentAimAlly(player)
    local main = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
    local frame = main and main:FindFirstChild("Allies")
        and main.Allies:FindFirstChild("Container")
        and main.Allies.Container:FindFirstChild("Allies")
        and main.Allies.Container.Allies:FindFirstChild("ScrollingFrame")
        and main.Allies.Container.Allies.ScrollingFrame:FindFirstChild("Frame")
    if not frame then return false end
    return frame:FindFirstChild(player.Name) ~= nil
end

local function IsSilentAimEnemy(player)
    if not player or player == LocalPlayer then return false end
    if IsSilentAimAlly(player) then return false end
    local myTeam, targetTeam = LocalPlayer.Team, player.Team
    if myTeam and targetTeam and myTeam.Name == "Marines" and targetTeam.Name == "Marines" then
        return false
    end
    return true
end

local function GetSilentAimOrigin()
    local p = UIS:GetMouseLocation()
    if _G.FOVMode == "屏幕中心" or p.X <= 0 or p.Y <= 0 then
        local v = workspace.CurrentCamera.ViewportSize
        return Vector2.new(v.X / 2, v.Y / 2)
    end
    return p
end

local SafeZonePositions = {
    World1 = {
        { pos = Vector3.new(-3000, 250, 2057), radius = 700 },
        { pos = Vector3.new(1101, 16, 1446), radius = 400 },
    },
    World2 = {
        { pos = Vector3.new(-12, 29, 2840), radius = 200 },
        { pos = Vector3.new(-376, 149, 307), radius = 150 },
        { pos = Vector3.new(-6437, 306, -4730), radius = 150 },
    },
    World3 = {
        { pos = Vector3.new(-338, 21, 5539), radius = 200 },
        { pos = Vector3.new(-12550, 337, -7506), radius = 400 },
        { pos = Vector3.new(-5046, 315, -2993), radius = 300 },
        { pos = Vector3.new(-16228, 9, 443), radius = 300 },
        { pos = Vector3.new(28695, 14959, -81), radius = 10000 },
        { pos = Vector3.new(9637, -1989, 9618), radius = 10000 },
    },
}

local function GetSafeZones()
    if World1 then return SafeZonePositions.World1 end
    if World2 then return SafeZonePositions.World2 end
    if World3 then return SafeZonePositions.World3 end
    return nil
end

local function IsInSafeZone(plr)
    if not plr or not plr.Character then return false end

    if plr:GetAttribute("SafeZone") == true
        or plr:GetAttribute("InSafeZone") == true then
        return true
    end

    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local zones = GetSafeZones()
    if not zones then return false end

    local pos = hrp.Position
    for _, zone in ipairs(zones) do
        if (pos - zone.pos).Magnitude <= zone.radius then
            return true
        end
    end
    return false
end

local function PassSilentAimSafeZone(player)
    if not _G.SilentAimExcludeSafeZone then return true end
    return not IsInSafeZone(player)
end

local function GetClosestTargetToMouse()
    local method = _G.SilentAimMethod or "鼠标最近的玩家"

    if method == "选择玩家" then
        if not _G.SilentAimTargetPlayers then return nil end
        local name = _G.SilentAimSelectedPlayer
        if not name or name == "" then return nil end
        local player = Players:FindFirstChild(name)
        if not player or player == LocalPlayer then return nil end
        if _G.SilentAimTeamCheck and not IsSilentAimEnemy(player) then return nil end
        if _G.SilentAimExcludePVP and player:GetAttribute("PvpDisabled") == true then return nil end
        if not PassSilentAimSafeZone(player) then return nil end
        local character = player.Character
        if not IsAlive(character) then return nil end
        return character:FindFirstChild(_G.SilentAimPart) or character:FindFirstChild("HumanoidRootPart")
    end

    if method == "最近的玩家" then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local closest, shortest = nil, math.huge
        local myPos = myRoot.Position

        local function checkNearest(character)
            if not IsAlive(character) then return end
            local part = character:FindFirstChild(_G.SilentAimPart) or character:FindFirstChild("HumanoidRootPart")
            if not part then return end
            local d = (part.Position - myPos).Magnitude
            if d < shortest then closest, shortest = part, d end
        end

        if _G.SilentAimTargetPlayers then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if (not _G.SilentAimTeamCheck or IsSilentAimEnemy(player))
                        and not (_G.SilentAimExcludePVP and player:GetAttribute("PvpDisabled") == true)
                        and PassSilentAimSafeZone(player) then
                        checkNearest(player.Character)
                    end
                end
            end
        end
        if _G.SilentAimTargetMobs and workspace:FindFirstChild("Enemies") then
            for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                checkNearest(enemy)
            end
        end
        return closest
    end

    local origin = GetSilentAimOrigin()
    local closest, shortest = nil, math.huge

    local function check(character)
        if not IsAlive(character) then return end
        local part = character:FindFirstChild(_G.SilentAimPart) or character:FindFirstChild("HumanoidRootPart")
        if not part then return end
        local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        if onScreen then
            local dist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
            if dist <= _G.SilentAimFOV and dist < shortest then closest, shortest = part, dist end
        end
    end

    if _G.SilentAimTargetPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if (not _G.SilentAimTeamCheck or IsSilentAimEnemy(player))
                    and not (_G.SilentAimExcludePVP and player:GetAttribute("PvpDisabled") == true)
                    and PassSilentAimSafeZone(player) then
                    check(player.Character)
                end
            end
        end
    end
    if _G.SilentAimTargetMobs and workspace:FindFirstChild("Enemies") then
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            check(enemy)
        end
    end
    return closest
end

local MouseModuleInstance = ReplicatedStorage:FindFirstChild("Mouse")
local MouseModule = nil
if MouseModuleInstance then
    pcall(function() MouseModule = require(MouseModuleInstance) end)
end
if MouseModule and typeof(MouseModule) == "table" then
    pcall(function()
        local realStore = { Hit = rawget(MouseModule, "Hit"), Target = rawget(MouseModule, "Target") }
        local mmt = getrawmetatable(MouseModule)
        if mmt then setreadonly(mmt, false) else mmt = {}; setmetatable(MouseModule, mmt) end
        rawset(MouseModule, "Hit", nil); rawset(MouseModule, "Target", nil)
        mmt.__index = function(self, key)
            if key == "Hit" then
                if _G.SilentAimSkill and IsCurrentSkillEnabled() and currentSilentAimTarget then return CFrame.new(currentSilentAimTarget.Position) end
                return realStore.Hit
            elseif key == "Target" then
                if _G.SilentAimSkill and IsCurrentSkillEnabled() and currentSilentAimTarget then return currentSilentAimTarget end
                return realStore.Target
            end
        end
        mmt.__newindex = function(self, key, value)
            if key == "Hit" or key == "Target" then realStore[key] = value else rawset(self, key, value) end
        end
        setreadonly(mmt, true)
    end)
end

local mouse = LocalPlayer:GetMouse()
local oldIndex
pcall(function()
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not _G.SilentAimM1R or self ~= mouse then
            return oldIndex(self, key)
        end
        if not currentSilentAimTarget or not IsCurrentSkillEnabled() or checkcaller() then
            return oldIndex(self, key)
        end
        local tp = currentSilentAimTarget.Position
        local cp = workspace.CurrentCamera.CFrame.Position
        if key == "Hit" then return CFrame.new(tp)
        elseif key == "Target" then return currentSilentAimTarget
        elseif key == "UnitRay" then return Ray.new(cp, (tp - cp).Unit)
        elseif key == "Origin" then return cp
        elseif key == "Direction" then return (tp - cp).Unit
        end
        return oldIndex(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    if not _G.SilentAimM1R and not _G.SilentAimSkill and not _G.SilentAimShowLine then
        currentSilentAimTarget = nil
        Line.Visible = false
        LockRingsHide()
        return
    end

    local p = UIS:GetMouseLocation()
    if _G.FOVMode == "屏幕中心" or p.X <= 0 or p.Y <= 0 then
        local v = workspace.CurrentCamera.ViewportSize
        p = Vector2.new(v.X / 2, v.Y / 2)
    end

    if _G.SilentAimM1R or _G.SilentAimSkill then
        currentSilentAimTarget = GetClosestTargetToMouse()
    else
        currentSilentAimTarget = nil
    end

    if _G.SilentAimShowLine and currentSilentAimTarget then
        local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(currentSilentAimTarget.Position)
        if onScreen then
            Line.Visible = true
            Line.From = p
            Line.To = Vector2.new(pos.X, pos.Y)
            LockRingsUpdate(Vector2.new(pos.X, pos.Y))
        else
            Line.Visible = false
            LockRingsHide()
        end
    else
        Line.Visible = false
        LockRingsHide()
    end
end)

local LockHotkey = {
    gui = nil,
    panel = nil,
    title = nil,
    status = nil,
    info = nil,
    btn = nil,
    conns = {},
    conn = nil,
    active = false,
    target = nil,
    distance = 0,
    uiTick = 0,
}

local function GetLockHotkeyName()
    local hotkey = _G.LockHotkeyKey or "H"
    if type(hotkey) ~= "string" then hotkey = "H" end
    hotkey = tostring(hotkey):upper()
    if hotkey == "" or hotkey == "NONE" then hotkey = "H" end
    return hotkey
end

local function DestroyLockHotkeyGui()
    for _, conn in pairs(LockHotkey.conns) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(LockHotkey.conns)
    if LockHotkey.gui then
        pcall(function() LockHotkey.gui:Destroy() end)
    end
    LockHotkey.gui = nil
    LockHotkey.panel = nil
    LockHotkey.title = nil
    LockHotkey.status = nil
    LockHotkey.info = nil
    LockHotkey.btn = nil
end

local function LockHotkeyUpdateUI()
    local status = LockHotkey.status
    local info = LockHotkey.info
    local btn = LockHotkey.btn
    local title = LockHotkey.title
    if not status or not info or not btn then return end
    local hotkeyText = GetLockHotkeyName()
    if title then
        title.Text = L("快捷锁人")
    end
    if LockHotkey.active and LockHotkey.target then
        status.Text = L("正在锁人: ") .. LockHotkey.target.Name
        status.TextColor3 = Color3.fromRGB(90, 255, 140)
        info.Text = L("距离: ") .. math.floor(LockHotkey.distance) .. L("米") .. "  |  " .. L("快捷键: ") .. hotkeyText
        btn.Text = L("解除锁定")
        btn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    elseif LockHotkey.active then
        status.Text = L("正在锁人...")
        status.TextColor3 = Color3.fromRGB(255, 200, 70)
        info.Text = L("快捷键: ") .. hotkeyText
        btn.Text = L("解除锁定")
        btn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
    else
        status.Text = L("未锁定")
        status.TextColor3 = Color3.fromRGB(255, 95, 95)
        info.Text = L("快捷键: ") .. hotkeyText .. "  |  " .. L("按下按键开始锁定")
        btn.Text = L("开始锁定")
        btn.BackgroundColor3 = Color3.fromRGB(45, 120, 70)
    end
end

local function LockHotkeyStopLoop()
    LockHotkey.active = false
    ChaseAPI.HotkeyTarget = nil
    if ChaseAPI.Stop then ChaseAPI.Stop() end
    StopTween()
    LockHotkey.target = nil
    LockHotkey.distance = 0
    LockHotkeyUpdateUI()
end

local function LockHotkeyStartLoop()
    if LockHotkey.active then return end

    local firstTarget = GetClosestTargetToMouse()
    local targetPlayer = nil
    if firstTarget then
        local tc = firstTarget.Parent
        if tc and tc:IsA("Model") then
            targetPlayer = Players:GetPlayerFromCharacter(tc)
        end
    end
    if not targetPlayer then
        WindUI:Notify({ Title = L("快捷锁人"), Content = L("请先选择目标玩家"), Duration = 1.5 })
        return
    end

    LockHotkey.target = targetPlayer
    LockHotkey.active = true
    LockHotkey.uiTick = 0
    LockHotkeyUpdateUI()

    ChaseAPI.HotkeyTarget = targetPlayer
    ChaseAPI.Start("hotkey")

    task.spawn(function()
        local VirtualUser = game:GetService("VirtualUser")
        while LockHotkey.active do
            task.wait(0.1)
            local tPlayer = LockHotkey.target
            if not tPlayer or not tPlayer.Parent or not tPlayer.Character then
                LockHotkeyStopLoop()
                break
            end
            local tHum = tPlayer.Character:FindFirstChildOfClass("Humanoid")
            local tHRP = tPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not tHRP or (tHum and tHum.Health <= 0) then
                LockHotkeyStopLoop()
                break
            end
            local myChar = LocalPlayer.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                LockHotkey.distance = (tHRP.Position - myHRP.Position).Magnitude
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                end)
            end
            LockHotkeyUpdateUI()
        end
    end)
end

local function CreateLockHotkeyGui()
    DestroyLockHotkeyGui()

    local parentGui
    pcall(function()
        if gethui then
            parentGui = gethui()
        end
    end)
    if not parentGui then
        pcall(function()
            parentGui = game:GetService("CoreGui")
        end)
    end
    if not parentGui then
        parentGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    end

    local sgui = Instance.new("ScreenGui")
    sgui.Name = "LockHotkeyGui"
    sgui.ResetOnSpawn = false
    sgui.IgnoreGuiInset = true
    sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sgui.DisplayOrder = 999
    sgui.Parent = parentGui
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(sgui)
        elseif protect_gui then
            protect_gui(sgui)
        end
    end)

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(0, 1)
    panel.Position = UDim2.new(0, 14, 1, -18)
    panel.Size = UDim2.new(0, 250, 0, 112)
    panel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    panel.BackgroundTransparency = 0.12
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Parent = sgui

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 10)
    panelCorner.Parent = panel

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(255, 150, 55)
    panelStroke.Thickness = 1.2
    panelStroke.Transparency = 0.15
    panelStroke.Parent = panel

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    titleBar.BackgroundTransparency = 0.15
    titleBar.BorderSizePixel = 0
    titleBar.Active = true
    titleBar.Parent = panel

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    titleFix.BackgroundTransparency = 0.15
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -12, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(255, 190, 95)
    title.Text = L("快捷锁人")
    title.Parent = titleBar

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 12, 0, 36)
    status.Size = UDim2.new(1, -24, 0, 20)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 14
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextColor3 = Color3.fromRGB(255, 95, 95)
    status.Text = L("未锁定")
    status.Parent = panel

    local info = Instance.new("TextLabel")
    info.Name = "Info"
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 12, 0, 56)
    info.Size = UDim2.new(1, -24, 0, 16)
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextColor3 = Color3.fromRGB(190, 190, 200)
    info.Text = ""
    info.Parent = panel

    local btn = Instance.new("TextButton")
    btn.Name = "ToggleBtn"
    btn.Position = UDim2.new(0, 12, 1, -32)
    btn.Size = UDim2.new(1, -24, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(45, 120, 70)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = L("开始锁定")
    btn.Parent = panel

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    LockHotkey.gui = sgui
    LockHotkey.panel = panel
    LockHotkey.title = title
    LockHotkey.status = status
    LockHotkey.info = info
    LockHotkey.btn = btn

    LockHotkey.conns.btn = btn.MouseButton1Click:Connect(function()
        if LockHotkey.active then
            LockHotkeyStopLoop()
        else
            LockHotkeyStartLoop()
        end
    end)

    local dragging = false
    local dragStart = Vector2.zero
    local startPos = UDim2.new()
    LockHotkey.conns.dragBegin = titleBar.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = panel.Position
        local ended
        ended = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if ended then ended:Disconnect() end
            end
        end)
    end)
    LockHotkey.conns.dragMove = UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end)

    LockHotkeyUpdateUI()
end

local function StartLockHotkey()
    if not LockHotkey.gui or not LockHotkey.gui.Parent then
        CreateLockHotkeyGui()
    else
        LockHotkeyUpdateUI()
    end

    if LockHotkey.conn then return end
    LockHotkey.conn = UIS.InputBegan:Connect(function(input)
        if not _G.LockHotkey then return end
        if UIS:GetFocusedTextBox() then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode.Name:upper() ~= GetLockHotkeyName() then return end
        if LockHotkey.active then
            LockHotkeyStopLoop()
        else
            LockHotkeyStartLoop()
        end
    end)
end

local function StopLockHotkey()
    LockHotkeyStopLoop()
    if LockHotkey.conn then
        LockHotkey.conn:Disconnect()
        LockHotkey.conn = nil
    end
    DestroyLockHotkeyGui()
end

RJR[L("绘制")]:Divider()
do
local FOVSection = RJR[L("绘制")]:Section({ Title = L("自瞄范围设置") })

FOVSection:Toggle({
    Title = L("显示 FOV 范围"),
    Value = _G.SilentAimShowFOV,
    Callback = function(v)
        c.Visible = v
        _G.SilentAimShowFOV = v
        SaveConfiguration()
    end
})

FOVSection:Dropdown({
    Title = L("FOV 位置"),
    Values = {"跟随鼠标", "屏幕中心"},
    Value = _G.FOVMode,
    Callback = function(v)
        _G.FOVMode = v
        _G.SilentAimFOVMode = v
        SaveConfiguration()
    end
})

FOVSection:Slider({
    Title = L("FOV 半径大小"),
    Value = {
        Min = 10,
        Max = 1500,
        Default = _G.SilentAimFOV or 150
    },
    Callback = function(value)
        c.Radius = value
        _G.SilentAimFOV = value
        SaveConfiguration()
    end
})

FOVSection:Colorpicker({
    Title = L("FOV 范围颜色"),
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(v)
        c.Color = v
    end
})

RJR[L("绘制")]:Divider()

local AimSection = RJR[L("绘制")]:Section({ Title = L("自瞄设置") })

AimSection:Toggle({
    Title = L("M1 R 自瞄"),
    Value = ConfigGet("SilentAimM1R"),
    Callback = Bind("SilentAimM1R")
})

AimSection:Toggle({
    Title = L("技能自瞄"),
    Value = ConfigGet("SilentAimSkill"),
    Callback = Bind("SilentAimSkill")
})

AimSection:Dropdown({
    Title = L("指定技能自瞄"),
    Values = {"Z", "X", "C", "V", "F"},
    Value = ConfigGet("SilentAimSkills"),
    Multi = true,
    Callback = Bind("SilentAimSkills")
})

AimSection:Dropdown({
    Title = L("静默瞄准方法"),
    Values = {"鼠标最近的玩家", "最近的玩家", "选择玩家"},
    Value = ConfigGet("SilentAimMethod") or "鼠标最近的玩家",
    Callback = Bind("SilentAimMethod")
})

AimSection:Toggle({
    Title = L("瞄准玩家"),
    Value = ConfigGet("SilentAimTargetPlayers"),
    Callback = Bind("SilentAimTargetPlayers")
})

AimSection:Toggle({
    Title = L("瞄准 NPC"),
    Value = ConfigGet("SilentAimTargetMobs"),
    Callback = Bind("SilentAimTargetMobs")
})

AimSection:Toggle({
    Title = L("团队检测"),
    Value = ConfigGet("SilentAimTeamCheck"),
    Callback = Bind("SilentAimTeamCheck")
})

AimSection:Toggle({
    Title = L("排除未开启pvp"),
    Value = ConfigGet("SilentAimExcludePVP"),
    Callback = Bind("SilentAimExcludePVP")
})

AimSection:Toggle({
    Title = L("排除安全区"),
    Value = ConfigGet("SilentAimExcludeSafeZone"),
    Callback = Bind("SilentAimExcludeSafeZone")
})

AimSection:Toggle({
    Title = L("显示锁定红线"),
    Value = ConfigGet("SilentAimShowLine"),
    Callback = Bind("SilentAimShowLine")
})

AimSection:Dropdown({
    Title = L("瞄准部位"),
    Values = {"HumanoidRootPart", "Head", "Torso", "UpperTorso", "LowerTorso"},
    Value = ConfigGet("SilentAimPart"),
    Callback = Bind("SilentAimPart")
})

RJR[L("绘制")]:Divider()

local SilentAimPlayerDropdown = RJR[L("绘制")]:Dropdown({
    Title = L("选择瞄准玩家"),
    Values = GetPlayerList(),
    Value = _G.SilentAimSelectedPlayer,
    Callback = function(v)
        _G.SilentAimSelectedPlayer = v or ""
        SaveConfiguration()
    end
})

RJR[L("绘制")]:Button({
    Title = L("刷新玩家列表"),
    Callback = function()
        local newPlayerList = GetPlayerList()
        if SilentAimPlayerDropdown and SilentAimPlayerDropdown.Refresh then
            SilentAimPlayerDropdown:Refresh(newPlayerList, true)
        end
        if _G.SilentAimSelectedPlayer ~= "" and SilentAimPlayerDropdown and SilentAimPlayerDropdown.SetValue then
            for _, name in ipairs(newPlayerList) do
                if name == _G.SilentAimSelectedPlayer then
                    pcall(function() SilentAimPlayerDropdown:SetValue(_G.SilentAimSelectedPlayer) end)
                    break
                end
            end
        end
    end
})
end

RJR[L("绘制")]:Toggle({
    Title = L("快捷键锁人"),
    Value = _G.LockHotkey,
    Callback = function(v)
        _G.LockHotkey = v
        if v then
            StartLockHotkey()
        else
            StopLockHotkey()
        end
        SaveConfiguration()
    end
})

RJR[L("绘制")]:Keybind({
    Title = L("锁人快捷键"),
    Value = _G.LockHotkeyKey or "H",
    Callback = function(v)
        _G.LockHotkeyKey = v
        LockHotkeyUpdateUI()
        SaveConfiguration()
    end
})

if _G.LockHotkey then StartLockHotkey() end

RJR[L("绘制")]:Divider()

do
    local autoSoruConn = nil

    local function soruTo(targetPosition)
        local Character = LocalPlayer.Character
        if not Character then return end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then return end

        local startCFrame = HumanoidRootPart.CFrame
        local finalCFrame = (startCFrame - startCFrame.Position) + targetPosition + Vector3.new(0, HumanoidRootPart.Size.Y * 1.5, 0)

        ReplicatedStorage.Remotes.CommE:FireServer(
            "Soru",
            startCFrame,
            finalCFrame,
            workspace:GetServerTimeNow(),
            math.random(1, 999999999)
        )
    end

    local function soruToClosestPlayer()
        local closestPlayer, shortestDistance = nil, math.huge
        local Character = LocalPlayer.Character
        local myRoot = Character and Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local myPos = myRoot.Position

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local otherChar = player.Character
                local otherHum = otherChar and otherChar:FindFirstChild("Humanoid")
                local otherRoot = otherChar and otherChar:FindFirstChild("HumanoidRootPart")
                if otherHum and otherRoot and otherHum.Health > 0 then
                    local distance = (otherRoot.Position - myPos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end

        local targetChar = closestPlayer and closestPlayer.Character
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            soruTo((targetRoot.CFrame * CFrame.new(0, 0, 3)).Position)
        end
    end

    local function startAutoSoru()
        if autoSoruConn then return end
        autoSoruConn = task.spawn(function()
            while _G.AutoSoru do
                pcall(soruToClosestPlayer)
                task.wait(1)
            end
            autoSoruConn = nil
        end)
    end

    local function stopAutoSoru()
        _G.AutoSoru = false
        autoSoruConn = nil
    end

    RJR[L("绘制")]:Toggle({
        Title = L("自动瞬步"),
        Desc = "",
        Value = _G.AutoSoru,
        Callback = function(v)
            _G.AutoSoru = v
            if v then
                startAutoSoru()
            else
                stopAutoSoru()
            end
            SaveConfiguration()
        end
    })

    if _G.AutoSoru then startAutoSoru() end
end

task.defer(function()
    SaveConfig(true)
    WindUI:Notify({ Title = L("保存配置"), Content = L("自动保存已开启"), Duration = 3 })
end)