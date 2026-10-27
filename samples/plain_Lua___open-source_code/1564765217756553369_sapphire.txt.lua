 
local __S = {}

if not isfolder then
    function isfolder()
        return false
    end
end

if not makefolder then
    function makefolder()
    end
end

if not writefile then
    function writefile()
    end
end

if not readfile then
    function readfile()
        return nil
    end
end

local u796 = game
local u797 = workspace
local u798 = getgenv
__S[10] = hookmetamethod
__S[11] = newcclosure
local u799 = cloneref
local u800 = getconnections
local u801 = getupvalues
local u802 = setupvalue
local u803 = getinfo
local u804 = islclosure
local u805 = checkcaller
local u806 = select
local u807 = unpack
local u808 = pcall
local u809 = type
local u810 = typeof
local u811 = pairs
local u812 = ipairs
__S[23] = assert
local u813 = warn
local u814 = tostring
local u815 = tonumber
__S[19] = rawget
local u816 = setmetatable
local u817 = tick
local u818 = Vector3
local u819 = CFrame
local u820 = Color3
local u821 = UDim2
local u822 = UDim
local u823 = Instance
local u824 = Enum
local u825 = table
local u826 = string
local u827 = math
local u828 = task
local u829 = os
local u830 = u799(u796:GetService("UserInputService"))
local u831 = u799(u796:GetService("ContentProvider"))
local u832 = u799(u796:GetService("TweenService"))
local u833 = u799(u796:GetService("HttpService"))
local u834 = u799(u796:GetService("TextService"))
u799(u796:GetService("RunService"))
u799(u796:GetService("Lighting"))
local u835 = u799(u796:GetService("Players"))
local u836 = u799(u796:GetService("CoreGui"))
u799(u796:GetService("Debris"))
local u837 = 0
local u838 = 0
local u839

local function u840(r0)
    u837 = u837 + 1
    local r1 = r0 or math.random(14, 22)
    local r2 = table.create(r1)

    for r3 = 1, r1 do
        local r8 = math.random(1, 63)

        if r3 == r1 then
            r8 = (r8 + u837 * 19 + r1 * 7) % 63 + 1
        end

        r2[r3] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_", r8, r8)
    end

    return table.concat(r2)
end

local function u841(r0)
    u837 = u837 + 1
    local r1 = r0 or math.random(12, 18)
    local r2 = table.create(r1)

    for r3 = 1, r1 do
        local r8 = math.random(1, 63)

        if r3 == r1 then
            r8 = (r8 + u837 * 23) % 63 + 1
        end

        r2[r3] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_", r8, r8)
    end

    return table.concat(r2)
end

local u842 = u840(u827.random(14, 22))
local u843 = u841(u827.random(12, 18))

local function u844()
    local u845

    pcall(function()
        if typeof(gethui) ~= "function" then
            return
        end

        u845 = gethui()

        if u845 and typeof(u799) == "function" then
            u845 = u799(u845)
        end
    end)

    if u845 then
        return u845
    end

    return u836
end

local function u846(r0)
    r0(u844())
    r0(u836)
    r0(u835.LocalPlayer and u835.LocalPlayer:FindFirstChildOfClass("PlayerGui"))
end

local function u847(r0)
    u838 = u838 + 1
    local r1 = u823.new(r0)
    r1.Name = u840(math.random(14, 22))
    return r1
end

local u848 = {
    ScreenGui = true,
    BillboardGui = true,
    SurfaceGui = true,
    Frame = true,
    ScrollingFrame = true,
    TextLabel = true,
    TextButton = true,
    TextBox = true,
    ImageLabel = true,
    ImageButton = true,
    ViewportFrame = true,
    VideoFrame = true,
    CanvasGroup = true,
    Folder = true,
    UICorner = true,
    UIStroke = true,
    UIGradient = true,
    UIPadding = true,
    UIListLayout = true,
    UIGridLayout = true,
    UIAspectRatioConstraint = true,
    UITextSizeConstraint = true,
    UISizeConstraint = true,
    UIScale = true,
    UIPageLayout = true,
    UITableLayout = true
}

local function u849(r0, ...)
    if u848[r0] then
        return u847(r0)
    end

    return u823.new(r0, ...)
end

local u850 = u816({}, {
    __index = function(r0, r1)
        if r1 == "new" then
            return u849
        end

        return u823[r1]
    end
})

local function u851(r0)
    if not r0 then
        return
    end

    r0:SetAttribute(u843, u841(math.random(14, 22)))
    u839 = r0

    if u798 then
        u798()[u842] = r0
        u798()._AllusiveObfuscationRegistry = {GuiRoot = r0, GlobalKey = u842, MarkerAttribute = u843}
    end
end

local function u852()
    local r0 = u843

    u846(function(r0)
        if not r0 then
            return
        end

        for r3, r4 in r0:GetChildren() do
            if r4:IsA("ScreenGui") and r4:GetAttribute(u843) ~= nil then
                r4:Destroy()
            end
        end
    end)
end

local function u853()
    if not u798 then
        return
    end

    local u854 = u798()._AllusiveObfuscationRegistry

    if typeof(u854) ~= "table" then
        return
    end

    if typeof(u854.GuiRoot) == "Instance" and u854.GuiRoot.Parent then
        pcall(function()
            u854.GuiRoot:Destroy()
        end)
    end

    if typeof(u854.GlobalKey) == "string" then
        local u855 = u798()[u854.GlobalKey]

        if typeof(u855) == "Instance" and u855.Parent then
            pcall(function()
                u855:Destroy()
            end)
        end

        u798()[u854.GlobalKey] = nil
    end

    if typeof(u854.MarkerAttribute) == "string" then
        local u856 = u854.MarkerAttribute

        u846(function(r0)
            if not r0 then
                return
            end

            for r2, r3 in r0:GetChildren() do
                if r3:IsA("ScreenGui") and r3:GetAttribute(u856) ~= nil then
                    r3:Destroy()
                end
            end
        end)
    end
end

__S[7] = function()
    u853()
    u852()

    if u798 and u842 then
        local r2 = u798()[u842]

        if typeof(r2) == "Instance" and r2.Parent then
            r2:Destroy()
        end

        u798()[u842] = nil
    end

    if u839 and u839.Parent then
        u839:Destroy()
    end

    u839 = nil
end

local function u857()
    local r0 = u847("ScreenGui")
    r0.ResetOnSpawn = false
    r0.IgnoreGuiInset = true
    r0.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    r0.Parent = u844()
    u851(r0)
    return r0
end

local function u858()
    local r4 = u847("ScreenGui")
    r4.ResetOnSpawn = false
    r4.IgnoreGuiInset = true
    r4.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    r4:SetAttribute(u843, u841(math.random(14, 22)))
    r4.Parent = u844()
    return r4
end

local u859 = {new = u847}
local u860 = u835.LocalPlayer:GetMouse()

local u861 = {
    Language = {
        CheckboxEnabled = "Enabled",
        CheckboxDisabled = "Disabled",
        SliderValue = "Value",
        DropdownSelect = "Select",
        DropdownNone = "None",
        DropdownSelected = "Selected",
        ButtonClick = "Click",
        TextboxEnter = "Enter",
        ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled",
        TabGeneral = "General",
        TabSettings = "Settings",
        Loading = "Loading...",
        Error = "Error",
        Success = "Success"
    },
    Colors = {
        Background = u820.fromRGB(8, 7, 12),
        Card = u820.fromRGB(14, 13, 18),
        CardDeep = u820.fromRGB(21, 20, 25),
        Stroke = u820.fromRGB(42, 42, 46),
        StrokeHot = u820.fromRGB(98, 98, 103),
        Accent = u820.fromRGB(235, 234, 239),
        AccentDim = u820.fromRGB(125, 124, 130),
        AccentSoft = u820.fromRGB(185, 184, 190),
        AccentGlow = u820.fromRGB(235, 234, 239),
        Text = u820.fromRGB(235, 234, 239),
        SubText = u820.fromRGB(100, 99, 105),
        NotifyBg = u820.fromRGB(14, 13, 18),
        Danger = u820.fromRGB(240, 70, 70),
        Success = u820.fromRGB(72, 210, 140)
    },
    DefaultColors = {},
    Connections = u816({}, {
        __index = {
            disconnect = function(r0, r1)
                if not r0[r1] then
                    return
                end

                r0[r1]:Disconnect()
                r0[r1] = nil
            end,
            disconnect_all = function(r0)
                for r2, r3 in r0 do
                    if typeof(r3) ~= "function" then
                        r3:Disconnect()
                    end
                end
            end
        }
    }),
    Util = {
        map = function(r0, r1, r2, r3, r4, r5)
            return (r1 - r2) * (r5 - r4) / (r3 - r2) + r4
        end,
        viewport_point_to_world = function(r0, r1, r2)
            local r5 = u797.CurrentCamera:ScreenPointToRay(r1.X, r1.Y)
            return r5.Origin + r5.Direction * r2
        end,
        get_offset = function(r0)
            return r0:map(u797.CurrentCamera.ViewportSize.Y, 0, 2560, 8, 56)
        end
    },
    Library = {
        _all_modules = {},
        _config = nil,
        _choosing_keybind = false,
        _blocking_drag = false,
        _device = nil,
        _ui_open = true,
        _ui_scale = 1,
        _ui_loaded = false,
        _ui = nil,
        _dragging = false,
        _drag_start = nil,
        _container_position = nil,
        _tab = 0,
        _active_tab_ref = nil,
        _theme_container = nil,
        _theme_container_stroke = nil,
        _theme_vert_div = nil,
        _theme_search = nil,
        _theme_search_stroke = nil,
        _theme_client_grad = nil,
        _theme_pin = nil,
        _theme_logo = nil,
        _container_uiscale = nil,
        _applying_theme = false,
        _theme_pending = false,
        _theme_debounce = nil
    }
}

for r5_10, r6_6 in u811(u861.Colors) do
    u861.DefaultColors[r5_10] = r6_6
end

u798().GG = {Language = u861.Language}
local u862 = u861.Language
local u863 = u861.Connections
__S[3] = u861.Util
local u864 = u861.Library
u864.__index = u864
local u865 = loadstring(u796:HttpGet("https://raw.githubusercontent.com/ieltxq/Library/refs/heads/main/Icons"))()

local function u866(r0)
    if not r0 then
        return ""
    end

    if r0:find("rbxassetid://") then
        return r0
    end

    return u865[r0] or ""
end

__S[7]()

if not isfolder("Allusive") then
    makefolder("Allusive")
end

local u867 = {}
u867.__index = u867

function u867.save(r0, u868, u869)
    local function r4()
        writefile("Allusive/" .. u868 .. ".json", u833:JSONEncode(u869))
    end

    local r3, r4_2 = pcall(r4)

    if not r3 then
        u813("failed to save config", r4_2)
    end
end

function u867.load(u871, u870, u872)
    local function r4()
        if not isfile("Allusive/" .. u870 .. ".json") then
            u871:save(u870, u872)
            return
        end

        local r4 = readfile("Allusive/" .. u870 .. ".json")

        if not r4 then
            u871:save(u870, u872)
            return
        end

        return u833:JSONDecode(r4)
    end

    local r3, r4_2 = pcall(r4)

    if not r3 then
        u813("failed to load config", r4_2)
    end

    local r3_2 = r4_2 or {_flags = {}, _keybinds = {}, _library = {}}
    return r3_2
end

 
function u864.normalize_parry_method(value)
    if type(value) == "table" then value = value.Name or value[1] end
    local name = type(value) == "string" and string.lower(value) or ""
    return (name == "keypress" or name == "vim") and "Keypress" or "Remote"
end

 
function u864.normalize_curve_method(value)
    if type(value) == "table" then value = value.Name or value[1] end
    local labels = {"Randomized Backwards", "Backwards", "BB Camera", "Camera", "Straight", "Dot", "High", "Random", "Stop"}
    if type(value) == "number" then
        return ({"Camera", "Random", "Camera", "Backwards", "Stop", "Camera", "Dot"})[math.floor(value)] or labels[math.clamp(math.floor(value), 1, #labels)]
    end
    local name = type(value) == "string" and string.lower(value):gsub("[%s_%-]", "") or ""
    local methods = {
        randomizedbackwards = "Randomized Backwards", randombackwards = "Randomized Backwards",
        backwards = "Backwards", back = "Backwards", bbcamera = "BB Camera", camera = "Camera",
        straight = "Straight", dot = "Dot", high = "High", up = "High", random = "Random",
        stop = "Stop", slow = "Stop", down = "Stop",
    }
    return methods[name] or "Camera"
end

function u864.keybind_is_clear(input)
    return input.UserInputType == u824.UserInputType.Keyboard and input.KeyCode == u824.KeyCode.Backspace
end
function u864.keybind_can_capture(input, processed, keyboardOnly)
    if keyboardOnly ~= false and input.UserInputType ~= u824.UserInputType.Keyboard then return false end
    return input.KeyCode ~= u824.KeyCode.Unknown and (not processed or u864.keybind_is_clear(input))
end
function u864.finish_keybind_capture()
     
    task.defer(function() u864._choosing_keybind = false end)
end

u864._config = u867:load(u796.GameId)
do
    local legacyPrefix = string.char(102, 108, 121, 116, 101, 95)
    local changed = false
    for _, name in ipairs({"_flags", "_keybinds"}) do
        local saved = u864._config[name]
        if type(saved) == "table" then
            local pending = {}
            for key, value in pairs(saved) do
                if type(key) == "string" and string.sub(key, 1, #legacyPrefix) == legacyPrefix then
                    pending[#pending + 1] = {Key = key, Value = value}
                end
            end
            for _, entry in ipairs(pending) do
                local key = "sapphire_" .. string.sub(entry.Key, #legacyPrefix + 1)
                if saved[key] == nil then saved[key] = entry.Value end
                saved[entry.Key] = nil
                changed = true
            end
        end
    end
    if changed then u867:save(u796.GameId, u864._config) end
end
 
do
    local saved = u864._config._flags
    if type(saved) == "table" then
        local changed = false
        for _, key in ipairs({"parry_mode", "manual_spam_mode", "auto_spam_mode", "sapphire_trigger_type", "sapphire_fury_method"}) do
            if saved[key] ~= nil then
                local method = u864.normalize_parry_method(saved[key])
                if saved[key] ~= method then saved[key], changed = method, true end
            end
        end
        if changed then u867:save(u796.GameId, u864._config) end
    end
end

 
do
    local changed = false
    local saved = u864._config._flags
    if type(saved) == "table" then
        local old = saved.curve_method
        if old == nil then old = saved.curve_mode end
        if old ~= nil then
            local method = u864.normalize_curve_method(old)
            method = method:sub(1, 1):upper() .. method:sub(2)
            if saved.curve_method ~= method then saved.curve_method, changed = method, true end
        end
        if saved.curve_mode ~= nil then saved.curve_mode, changed = nil, true end
    end
    local bindings = u864._config._keybinds
    if type(bindings) == "table" then
        for _, oldName in ipairs({"Camera", "Random", "Accelerated", "Back", "Down", "Up", "Dot", "camera", "random", "dot", "backwards", "slow"}) do
            local oldKey = "curve_mode_" .. oldName
            local value = bindings[oldKey]
            if value ~= nil then
                 
                if oldName ~= "Accelerated" and oldName ~= "Up" then
                    local label = u864.normalize_curve_method(oldName)
                    local newKey = "curve_method_" .. label:gsub("%s+", "")
                    if bindings[newKey] == nil then bindings[newKey] = value end
                end
                bindings[oldKey], changed = nil, true
            end
        end
    end
     
    if type(bindings) == "table" then
        for _, name in ipairs({"camera", "dot", "backwards", "slow", "random"}) do
            local oldKey = "curve_method_" .. name
            local newKey = "curve_method_" .. u864.normalize_curve_method(name):gsub("%s+", "")
            if bindings[oldKey] ~= nil then
                if bindings[newKey] == nil then bindings[newKey] = bindings[oldKey] end
                bindings[oldKey], changed = nil, true
            end
        end
    end
    local library = u864._config._library
    if type(library) == "table" and library.curve_mode_dd_notify ~= nil then
        if library.curve_method_dd_notify == nil then library.curve_method_dd_notify = library.curve_mode_dd_notify end
        library.curve_mode_dd_notify, changed = nil, true
    end
    if changed then u867:save(u796.GameId, u864._config) end
end

__S[3] = u864._config._gui

if not __S[3] then
    __S[3] = {}
    u864._config._gui = __S[3]
end

 
do
    local changed = false
    for key, value in pairs(u864._config._keybinds or {}) do
        if value == "Backspace" or value == "Enum.KeyCode.Backspace" then
            u864._config._keybinds[key], changed = nil, true
        end
    end
    for _, value in pairs(u864._config._flags or {}) do
        if type(value) == "table" and (value.BIND == "Backspace" or value.BIND == "Enum.KeyCode.Backspace") then
            value.BIND, changed = "Unknown", true
        end
    end
    if __S[3].toggle_key == "Backspace" or __S[3].toggle_key == "Enum.KeyCode.Backspace" then
        __S[3].toggle_key, changed = false, true
    end
    if changed then u867:save(u796.GameId, u864._config) end
end

if __S[3].toggle_key == nil then
    __S[3].toggle_key = "Enum.KeyCode.RightControl"
end

if __S[3].hide_minimized == nil then
    __S[3].hide_minimized = false
end

if __S[3].bg_transparency == nil then
    __S[3].bg_transparency = 0.04
end

__S[3] = u857()
__S[3].ZIndexBehavior = u824.ZIndexBehavior.Global
local u873 = u859.new("Frame")
u873.Size = u821.new(0, 330, 1, -40)
u873.Position = u821.new(0, 18, 1, -20)
u873.AnchorPoint = Vector2.new(0, 1)
u873.BackgroundTransparency = 1
u873.ClipsDescendants = false
u873.Parent = __S[3]
__S[3] = u850.new("UIListLayout")
__S[3].VerticalAlignment = u824.VerticalAlignment.Bottom
__S[3].Padding = u822.new(0, 10)
__S[3].Parent = u873

function u864.SendNotification(r0)
    local r6 = u859
    local r1 = u861.Colors
    local r7 = r0.duration or 4
    local r8 = r0.iconColor or r1.Accent
    local u874 = r6.new("Frame")
    u874.Size = u821.new(1, 0, 0, 66)
    u874.BackgroundTransparency = 1
    u874.Parent = u873
    local u875 = r6.new("Frame")
    u875.Size = u821.new(1, 0, 1, 0)
    u875.BackgroundColor3 = u820.fromRGB(14, 13, 18)
    u875.BackgroundTransparency = 0
    u875.BorderSizePixel = 0
    u875.ClipsDescendants = true
    u875.Parent = u874
    local r2 = r6.new("UICorner")
    r2.CornerRadius = u822.new(0, 12)
    r2.Parent = u875
    local r2_2 = r6.new("UIStroke")
    r2_2.Color = r1.StrokeHot
    r2_2.Transparency = 0.64
    r2_2.ApplyStrokeMode = u824.ApplyStrokeMode.Border
    r2_2.Parent = u875
    local r2_3 = r6.new("Frame")
    r2_3.Size = u821.new(1, 0, 0, 34)
    r2_3.Position = u821.new(0, 0, 0, 0)
    r2_3.BackgroundColor3 = r8
    r2_3.BackgroundTransparency = 0.85
    r2_3.BorderSizePixel = 0
    r2_3.Parent = u875
    local r3 = r6.new("UICorner")

    r3.CornerRadius = u822.new(0, 12)
    r3.Parent = r2_3
    local r3_2 = r6.new("UIGradient")
    r3_2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    r3_2.Rotation = 90
    r3_2.Parent = r2_3
    local r2_4 = r6.new("Frame")
    r2_4.Size = u821.new(0, 30, 0, 30)
    r2_4.Position = u821.new(0, 13, 0.5, 0)
    r2_4.AnchorPoint = Vector2.new(0, 0.5)
    r2_4.BackgroundColor3 = r8
    r2_4.BackgroundTransparency = 0.72
    r2_4.BorderSizePixel = 0
    r2_4.Parent = u875
    local r3_3 = r6.new("UICorner")
    r3_3.CornerRadius = u822.new(0, 8)
    r3_3.Parent = r2_4
    local r3_4 = r6.new("ImageLabel")
    r3_4.BackgroundTransparency = 1
    r3_4.Size = u821.new(0, 14, 0, 14)
    r3_4.Position = u821.new(0.5, 0, 0.5, 0)
    r3_4.AnchorPoint = Vector2.new(0.5, 0.5)
    r3_4.Image = u866(r0.icon)
    r3_4.ImageColor3 = r8
    r3_4.Parent = r2_4
    local r2_5 = r6.new("TextLabel")
    r2_5.Text = r0.title or "Notification"
    r2_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
    r2_5.TextSize = 13
    r2_5.TextColor3 = r1.Text
    r2_5.TextTransparency = 0
    r2_5.BackgroundTransparency = 1
    r2_5.Position = u821.new(0, 52, 0, 9)
    r2_5.Size = u821.new(1, -60, 0, 16)
    r2_5.TextXAlignment = u824.TextXAlignment.Left
    r2_5.Parent = u875
    local r2_6 = r6.new("TextLabel")
    r2_6.Text = r0.text or ""
    r2_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Regular)
    r2_6.TextSize = 11
    r2_6.TextColor3 = r1.SubText
    r2_6.BackgroundTransparency = 1
    r2_6.Position = u821.new(0, 52, 0, 27)
    r2_6.Size = u821.new(1, -60, 0, 28)
    r2_6.TextWrapped = true
    r2_6.TextXAlignment = u824.TextXAlignment.Left
    r2_6.TextYAlignment = u824.TextYAlignment.Top
    r2_6.Parent = u875
    local r10 = r6.new("Frame")
    r10.Size = u821.new(1, -24, 0, 3)
    r10.Position = u821.new(0, 12, 1, -5)
    r10.AnchorPoint = Vector2.new(0, 1)
    r10.BackgroundColor3 = r1.Stroke
    r10.BackgroundTransparency = 0.3
    r10.BorderSizePixel = 0
    r10.Parent = u875
    local r1_2 = r6.new("UICorner")
    r1_2.CornerRadius = u822.new(0, 2)
    r1_2.Parent = r10
    local r20 = r6.new("Frame")
    r20.Size = u821.new(1, 0, 1, 0)
    r20.BackgroundColor3 = r8
    r20.BackgroundTransparency = 0.15
    r20.BorderSizePixel = 0
    r20.Parent = r10
    local r1_3 = r6.new("UICorner")
    r1_3.CornerRadius = u822.new(0, 2)
    r1_3.Parent = r20
    u875.Position = u821.new(-1.08, 0, 0, 0)
    u832:Create(u875, TweenInfo.new(0.52, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Position = u821.new(0, 0, 0, 0)}):Play()
    u832:Create(r20, TweenInfo.new(r7 - 0.04, u824.EasingStyle.Linear), {Size = u821.new(0, 0, 1, 0)}):Play()

    task.delay(r7, function()
        u832:Create(u875, TweenInfo.new(0.38, u824.EasingStyle.Quint, u824.EasingDirection.In), {Position = u821.new(-1.08, 0, 0, 0)}):Play()

        task.delay(0.4, function()
            u874:Destroy()
        end)
    end)
end

function u864.get_screen_scale(r0)
    local r1 = u797.CurrentCamera.ViewportSize.X / 1400

    if r0._device == "Mobile" then
        r0._ui_scale = math.clamp(r1 * 0.97, 0.68, 0.9)
    else
        r0._ui_scale = math.clamp(r1, 0.5, 1.2)
    end
end

function u864.get_device(r0)
    if not u830.TouchEnabled and u830.KeyboardEnabled and u830.MouseEnabled then
        r0._device = "PC"
    elseif u830.TouchEnabled then
        r0._device = "Mobile"
    elseif u830.GamepadEnabled then
        r0._device = "Console"
    else
        r0._device = "Unknown"
    end
end

function u864.removed(r0, r1)
    r0._ui.AncestryChanged:Once(r1)
end

function u864.flag_type(r0, r1, r2)
    if not u864._config._flags[r1] then
        return
    end

    return typeof(u864._config._flags[r1]) == r2
end

function u864.remove_table_value(r0, r1, r2)
    for r8, r9 in r1 do
        if r9 == r2 then
            table.remove(r1, r8)
            return
        end
    end
end

function u864.new()
    local r4 = setmetatable({_loaded = false}, u864)
    r4:create_ui()
    return r4
end

function u864.create_ui(u876)
    local r4 = u859;

    (function()
        local r7 = u864._config._gui

        if not r7 or not r7.colors then
            return
        end

        for r1, r2 in pairs(r7.colors) do
            if type(r2) == "table" and r2.H ~= nil and u861.Colors[r1] then
                u861.Colors[r1] = u820.fromHSV(r2.H, r2.S, r2.V)
            end
        end

        local r9 = u861.Colors

        if r7.colors.Stroke then
            local r6 = r9.Stroke
            r9.StrokeHot = u820.new(math.clamp(r6.R * 1.2 + 0.05, 0, 1), math.clamp(r6.G * 1.2 + 0.05, 0, 1), math.clamp(r6.B * 1.22 + 0.06, 0, 1))
        end

        if r7.colors.Accent then
            local r11 = r9.Accent
            r9.AccentSoft = u820.new(math.clamp(r11.R * 0.55 + 0.42, 0, 1), math.clamp(r11.G * 0.55 + 0.42, 0, 1), math.clamp(r11.B * 0.58 + 0.45, 0, 1))
            r9.AccentDim = u820.new(math.clamp(r11.R * 0.42, 0, 1), math.clamp(r11.G * 0.42, 0, 1), math.clamp(r11.B * 0.48, 0, 1))
            r9.AccentGlow = r11
        end

        if r7.colors.Card then
            local r0 = r9.Card
            r9.CardDeep = u820.new(r0.R * 0.78, r0.G * 0.78, r0.B * 0.8)
        end
    end)()

    local u877 = u861.Colors
    local u878 = u857()
    local u879 = r4.new("Frame")
    u879.ClipsDescendants = true
    u879.AnchorPoint = Vector2.new(0.5, 0.5)
    u879.Name = "Container"
    u879.BackgroundTransparency = u864._config._gui and u864._config._gui.bg_transparency or 0.04
    u879.BackgroundColor3 = u877.Background
    u879.Position = u821.new(0.5, 0, 0.5, 0)
    u879.Size = u821.new(0, 0, 0, 0)
    u879.Active = true
    u879.BorderSizePixel = 0
    u879.Parent = u878
    local r2 = r4.new("UICorner")
    r2.CornerRadius = u822.new(0, 18)
    r2.Parent = u879
    local r2_2 = r4.new("UIStroke")
    r2_2.Color = u877.StrokeHot
    r2_2.Transparency = 0.6
    r2_2.ApplyStrokeMode = u824.ApplyStrokeMode.Border
    r2_2.Parent = u879
    local u880 = r4.new("Frame")
    u880.BackgroundTransparency = 1
    u880.Name = "Handler"
    u880.Size = u821.new(0, 698, 0, 479)
    u880.BorderSizePixel = 0
    u880.Parent = u879
    local u881 = r4.new("Frame")
    u881.Name = "Search"
    u881.Size = u821.new(0, 32, 0, 32)
    u881.Position = u821.new(1, -14, 0, 10)
    u881.AnchorPoint = Vector2.new(1, 0)
    u881.BackgroundColor3 = u877.CardDeep
    u881.BackgroundTransparency = 0.3
    u881.BorderSizePixel = 0
    u881.Parent = u880
    local r3 = r4.new("UICorner")
    r3.CornerRadius = u822.new(1, 0)
    r3.Parent = u881
    local r10 = r4.new("UIStroke")
    r10.Color = u877.StrokeHot
    r10.Transparency = 0.5
    r10.Parent = u881
    local r11 = r4.new("ImageButton")
    r11.Size = u821.new(0, 15, 0, 15)
    r11.Position = u821.new(0, 8, 0.5, 0)
    r11.AnchorPoint = Vector2.new(0, 0.5)
    r11.ImageColor3 = u877.Accent
    r11.BackgroundTransparency = 1
    r11.Image = u866("search")
    r11.Parent = u881
    local u882 = r4.new("TextBox")
    u882.Size = u821.new(1, -38, 1, 0)
    u882.Position = u821.new(0, 32, 0, 0)
    u882.TextXAlignment = u824.TextXAlignment.Left
    u882.TextYAlignment = u824.TextYAlignment.Center
    u882.BackgroundTransparency = 1
    u882.TextTransparency = 1
    u882.PlaceholderText = "Search modules..."
    u882.PlaceholderColor3 = u877.SubText
    u882.TextColor3 = u877.Text
    u882.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Regular)
    u882.TextSize = 12
    u882.ClearTextOnFocus = false
    u882.Text = ""
    u882.Parent = u881
    local r12 = r4.new("UIPadding")
    r12.PaddingLeft = u822.new(0, 2)
    r12.Parent = u882
    local u883 = false

    r11.MouseButton1Click:Connect(function()
        if u883 then
            return
        end

        u883 = true
        u832:Create(u881, TweenInfo.new(0.38, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Size = u821.new(0, 200, 0, 32)}):Play()
        u832:Create(u882, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

        task.delay(0.15, function()
            u882:CaptureFocus()
        end)
    end)

    u882.FocusLost:Connect(function()
        if u882.Text ~= "" then
            return
        end

        u883 = false
        u882:ReleaseFocus()
        u832:Create(u881, TweenInfo.new(0.38, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Size = u821.new(0, 32, 0, 32)}):Play()
        u832:Create(u882, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    end)

    u882:GetPropertyChangedSignal("Text"):Connect(function()
        local r6 = u882.Text:lower()

        for r2, r3 in ipairs(u864._all_modules) do
            r3.frame.Visible = r6 == "" or r3.title:find(r6, 1, true) ~= nil
        end
    end)

    local u884 = r4.new("ScrollingFrame")
    u884.ScrollBarImageTransparency = 1
    u884.ScrollBarThickness = 0
    u884.Name = "Tabs"
    u884.Size = u821.new(0, 129, 0, 440)
    u884.Selectable = false
    u884.AutomaticCanvasSize = u824.AutomaticSize.XY
    u884.BackgroundTransparency = 1
    u884.Position = u821.new(0.0261, 0, 0.16, 0)
    u884.BorderSizePixel = 0
    u884.CanvasSize = u821.new(0, 0, 0.5, 0)
    u884.Parent = u880
    local r30 = r4.new("UIListLayout")
    r30.Padding = u822.new(0, 4)
    r30.SortOrder = u824.SortOrder.LayoutOrder
    r30.Parent = u884

    local function r32(r0, r1)
        local r2 = u859.new("Frame")
        r2.Name = "Divider"
        r2.BackgroundTransparency = 0.38
        r2.BorderSizePixel = 0
        r2.BackgroundColor3 = u877.Stroke
        r2.Position = r0
        r2.Size = r1
        r2.Parent = u880
        local r3 = u859.new("UIGradient")

        r3.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.7, 0),
            NumberSequenceKeypoint.new(1, 1)
        })

        r3.Parent = r2
    end

    r32(u821.new(0.23, 0, 0.12, 0), u821.new(0, 450, 0, 1))
    r32(u821.new(0, 0, 0.12, 0), u821.new(0, 157, 0, 1))
    local r34 = r4.new("Frame")
    r34.BackgroundTransparency = 0.48
    r34.BorderSizePixel = 0
    r34.BackgroundColor3 = u877.Stroke
    r34.Position = u821.new(0.225, 0, 0.13, 0)
    r34.Size = u821.new(0, 1, 0.78, 0)
    r34.Parent = u880
    local r38 = r4.new("UIGradient")

    r38.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    r38.Rotation = 90
    r38.Parent = r34
    local r47 = r4.new("TextLabel")
    r47.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
    r47.TextColor3 = u877.Accent
    r47.TextTransparency = 0.05
    r47.Text = "Sapphire"
    r47.Name = "ClientName"
    r47.Size = u821.new(0, 140, 0, 18)
    r47.AnchorPoint = Vector2.new(0, 0.5)
    r47.Position = u821.new(0.056, 0, 0.055, 0)
    r47.BackgroundTransparency = 1
    r47.TextXAlignment = u824.TextXAlignment.Left
    r47.TextSize = 15
    r47.Parent = u880
    local r56 = r4.new("UIGradient")

    r56.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, u877.Accent),
        ColorSequenceKeypoint.new(0.42, u877.Accent),
        ColorSequenceKeypoint.new(1, u877.Accent)
    })

    r56.Offset = Vector2.new(0, 0)
    r56.Parent = r47
    local r65 = r4.new("Frame")
    r65.Name = "Pin"
    r65.Position = u821.new(0.026, 0, 0.136, 0)
    r65.Size = u821.new(0, 2, 0, 16)
    r65.BorderSizePixel = 0
    r65.BackgroundColor3 = u877.Accent
    r65.Visible = false
    r65.Parent = u880
    local r68 = r4.new("UICorner")
    r68.CornerRadius = u822.new(0, 12)
    r68.Parent = r65
    local u885 = r4.new("ImageLabel")
    u885.ScaleType = u824.ScaleType.Fit
    u885.AnchorPoint = Vector2.new(0, 0.5)
    u885.Image = "rbxassetid://10723396000"
    u885.BackgroundTransparency = 1
    u885.Position = u821.new(0.025, 0, 0.055, 0)
    u885.Name = "Icon"
    u885.Size = u821.new(0, 18, 0, 18)
    u885.BorderSizePixel = 0
    u885.ImageColor3 = u877.AccentSoft
    u885.Parent = u880
    u885.ImageRectSize = Vector2.new(0, 0)

    task.spawn(function()
    end)

    local u886 = r4.new("Folder")
    u886.Name = "Sections"
    u886.Parent = u880
    local r81 = r4.new("TextButton")
    r81.Text = ""
    r81.AutoButtonColor = false
    r81.BackgroundTransparency = 1
    r81.Name = "Minimize"
    r81.Position = u821.new(0.0201, 0, 0.0292, 0)
    r81.Size = u821.new(0, 24, 0, 24)
    r81.BorderSizePixel = 0
    r81.Parent = u880
    local u887 = r4.new("UIScale")
    u887.Parent = u879
    u876._container_uiscale = u887
    u876._ui = u878
    u876._theme_container = u879
    u876._theme_container_stroke = r2_2
    u876._theme_vert_div = r34
    u876._theme_search = u881
    u876._theme_search_stroke = r10
    u876._theme_search_icon = r11
    u876._theme_search_box = u882
    u876._theme_client_name = r47
    u876._theme_client_grad = r56
    u876._theme_pin = r65
    u876._theme_logo = u885
    u876._theme_tabs_ref = u884

     
    do
        local G = {Idle = {}, Hover = {}, Connections = {}, Active = false, Destroyed = false}
        u876._title_gem = G
        local badge = r4.new("Frame")
        badge.Name = "SapphireGemBadge"
        badge.AnchorPoint = Vector2.new(0.5, 0.5)
        badge.Position = u821.new(0.025, 5, 0.055, 0)
        badge.Size = u821.fromOffset(22, 22)
        badge.BackgroundColor3 = u877.AccentDim
        badge.BackgroundTransparency = 0.68
        badge.BorderSizePixel = 0
        badge.Active = false
        badge.ZIndex = u885.ZIndex
        badge.Parent = u880
        local corner = r4.new("UICorner")
        corner.CornerRadius = u822.new(0, 7)
        corner.Parent = badge
        local border = r4.new("UIStroke")
        border.Name = "GemRim"
        border.Color = u877.AccentSoft
        border.Thickness = 0.8
        border.Transparency = 0.62
        border.ApplyStrokeMode = u824.ApplyStrokeMode.Border
        border.Parent = badge
        local rimGradient = r4.new("UIGradient")
        rimGradient.Rotation = 35
        rimGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.45, 0.75),
            NumberSequenceKeypoint.new(1, 0.1)
        })
        rimGradient.Parent = border
        local hoverScale = r4.new("UIScale")
        hoverScale.Scale = 1
        hoverScale.Parent = badge
        local jewel = r4.new("Frame")
        jewel.Name = "GemMotion"
        jewel.AnchorPoint = Vector2.new(0.5, 0.5)
        jewel.Position = u821.new(0.5, 0, 0.5, 0)
        jewel.Size = u821.new(1, 0, 1, 0)
        jewel.BackgroundTransparency = 1
        jewel.Rotation = -3
        jewel.Active = false
        jewel.Parent = badge
        local breath = r4.new("UIScale")
        breath.Scale = 1
        breath.Parent = jewel
        local function overlay(name, size, opacity)
            local image = r4.new("ImageLabel")
            image.Name = name
            image.Image = u885.Image
            image.ImageRectSize = Vector2.new(0, 0)
            image.ScaleType = u824.ScaleType.Fit
            image.AnchorPoint = Vector2.new(0.5, 0.5)
            image.Position = u821.new(0.5, 0, 0.5, 0)
            image.Size = u821.fromOffset(size, size)
            image.ImageColor3 = u877.AccentSoft
            image.ImageTransparency = opacity
            image.BackgroundTransparency = 1
            image.BorderSizePixel = 0
            image.Active = false
            image.ZIndex = u885.ZIndex
            image.Parent = jewel
            return image
        end
        local aura = overlay("GemAura", 21, 0.9)
        u885.Parent = jewel
        u885.AnchorPoint = Vector2.new(0.5, 0.5)
        u885.Position = u821.new(0.5, 0, 0.5, 0)
        u885.Size = u821.fromOffset(16, 16)
        u885.ZIndex = badge.ZIndex + 1
        local facet = r4.new("UIGradient")
        facet.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, u820.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, u820.fromRGB(173, 185, 255)),
            ColorSequenceKeypoint.new(1, u820.fromRGB(242, 246, 255))
        })
        facet.Rotation = 35
        facet.Parent = u885
        local hoverLight = overlay("GemHoverLight", 18, 1)
        hoverLight.ZIndex = badge.ZIndex + 2
        local glint = overlay("GemGlint", 16, 0.12)
        glint.ZIndex = badge.ZIndex + 3
        glint.ImageColor3 = u820.fromRGB(244, 249, 255)
        local shine = r4.new("UIGradient")
        shine.Rotation = 25
        shine.Offset = Vector2.new(-1.15, 0)
        shine.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.38, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.62, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        shine.Parent = glint
        local function idle(object, info, goal)
            table.insert(G.Idle, u832:Create(object, info, goal))
        end
        local slow = TweenInfo.new(3.4, u824.EasingStyle.Sine, u824.EasingDirection.InOut, -1, true)
        idle(jewel, slow, {Rotation = 3})
        idle(breath, slow, {Scale = 1.035})
        idle(aura, slow, {ImageTransparency = 0.76})
        idle(shine, TweenInfo.new(1.35, u824.EasingStyle.Sine, u824.EasingDirection.InOut, -1, false, 2.8),
            {Offset = Vector2.new(1.15, 0)})
        idle(rimGradient, TweenInfo.new(9, u824.EasingStyle.Linear, u824.EasingDirection.InOut, -1), {Rotation = 395})
        local function listen(signal, callback)
            table.insert(G.Connections, signal:Connect(callback))
        end
        local function cancelHover()
            for _, tween in ipairs(G.Hover) do tween:Cancel() end
            table.clear(G.Hover)
        end
        function G.SetHover(entered)
            if G.Destroyed or not G.Active then return end
            cancelHover()
            local info = TweenInfo.new(entered and 0.22 or 0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out)
            table.insert(G.Hover, u832:Create(hoverScale, info, {Scale = entered and 1.08 or 1}))
            table.insert(G.Hover, u832:Create(hoverLight, info, {ImageTransparency = entered and 0.5 or 1}))
            for _, tween in ipairs(G.Hover) do tween:Play() end
        end
        function G.Refresh()
            if G.Destroyed then return end
            local visible = u878.Enabled and u878.Parent ~= nil and u879.Visible and u880.Visible
                and u879.AbsoluteSize.X > 1 and u879.AbsoluteSize.Y > 1
            if visible == G.Active then return end
            G.Active = visible
            if visible then
                for _, tween in ipairs(G.Idle) do tween:Play() end
            else
                for _, tween in ipairs(G.Idle) do tween:Pause() end
                cancelHover()
                hoverScale.Scale, hoverLight.ImageTransparency = 1, 1
            end
        end
        function G.Retint()
            if G.Destroyed then return end
            local colors = u861.Colors
            badge.BackgroundColor3 = colors.AccentDim
            border.Color = colors.AccentSoft
            aura.ImageColor3, hoverLight.ImageColor3 = colors.AccentSoft, colors.AccentSoft
        end
        function G.Destroy()
            if G.Destroyed then return end
            G.Destroyed, G.Active = true, false
            cancelHover()
            for _, tween in ipairs(G.Idle) do tween:Cancel() end
            for _, connection in ipairs(G.Connections) do connection:Disconnect() end
            table.clear(G.Idle)
            table.clear(G.Connections)
            if u876._title_gem == G then u876._title_gem = nil end
            if u876._theme_logo == u885 then u876._theme_logo = nil end
             
            badge:Destroy()
        end
        listen(r81.MouseEnter, function() G.SetHover(true) end)
        listen(r81.MouseLeave, function() G.SetHover(false) end)
        listen(u878:GetPropertyChangedSignal("Enabled"), G.Refresh)
        listen(u879:GetPropertyChangedSignal("Visible"), G.Refresh)
        listen(u880:GetPropertyChangedSignal("Visible"), G.Refresh)
        listen(u879:GetPropertyChangedSignal("AbsoluteSize"), G.Refresh)
        listen(u885:GetPropertyChangedSignal("ImageColor3"), G.Retint)
        listen(u878.AncestryChanged, function(_, parent)
            if parent == nil then G.Destroy() else G.Refresh() end
        end)
        listen(u878.Destroying, G.Destroy)
        G.Refresh()
    end
     

    local function r18(u888)
        if u864._blocking_drag then
            return
        end

        if u888.UserInputType ~= u824.UserInputType.MouseButton1 and u888.UserInputType ~= u824.UserInputType.Touch then
            return
        end

        u876._dragging = true
        u876._drag_start = u888.Position
        u876._container_position = u879.Position

        u863.container_input_ended = u888.Changed:Connect(function()
            if u888.UserInputState ~= u824.UserInputState.End then
                return
            end

            u863:disconnect("container_input_ended")
            u876._dragging = false
        end)
    end

    local function r19(r0)
        if not u876._dragging or u864._blocking_drag then
            return
        end

        if r0.UserInputType ~= u824.UserInputType.MouseMovement and r0.UserInputType ~= u824.UserInputType.Touch then
            return
        end

        local r2 = r0.Position - u876._drag_start

        u832:Create(u879, TweenInfo.new(0.2), {
            Position = u821.new(u876._container_position.X.Scale, u876._container_position.X.Offset + r2.X, u876._container_position.Y.Scale, u876._container_position.Y.Offset + r2.Y)
        }):Play()
    end

    u863.container_input_began = u879.InputBegan:Connect(r18)
    u863.input_changed = u830.InputChanged:Connect(r19)

    u876:removed(function()
        u876._ui = nil
        u863:disconnect_all()
    end)

    function u876.Update1Run(u890, u889)
        if u889 == "nil" then
            u879.BackgroundTransparency = 0.04
        else
            pcall(function()
                u879.BackgroundTransparency = tonumber(u889)
            end)
        end
    end

    function u876.UIVisiblity(r0)
        u878.Enabled = not u878.Enabled
    end

    function u876.change_visiblity(u891, r1)
        u891._vis_seq = (u891._vis_seq or 0) + 1
        local u892 = u891._vis_seq
        local r2 = not r1
        local r3 = u891._device
        local r4 = "PC"
        local r7 = r3 == r4

        if r3 == r4 then
            r7 = u864._config._gui and u864._config._gui.hide_minimized
        end

        local u893 = u891._container_uiscale
        local u894 = u891._ui_scale or 1

        if r2 and r7 then
            if u893 then
                u832:Create(u893, TweenInfo.new(0.34, u824.EasingStyle.Quint, u824.EasingDirection.In), {Scale = 0.04}):Play()

                task.delay(0.36, function()
                    if u892 ~= u891._vis_seq then
                        return
                    end

                    if not u891._ui_open then
                        u878.Enabled = false
                        u893.Scale = u894
                    end
                end)
            else
                u878.Enabled = false
            end

            return
        end

        u878.Enabled = true

        if r1 and u893 then
            u893.Scale = 0.04
            u832:Create(u893, TweenInfo.new(0.34, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Scale = u894}):Play()
        end

        local r12 = u832
        local r2_2 = r12.Create
        local r14 = TweenInfo.new(0.34, u824.EasingStyle.Quint, u824.EasingDirection.Out)
        local r15 = {}

        if r1 then
            r1 = u821.fromOffset(698, 479)
        end

        if not r1 then
            r1 = u821.fromOffset(132, 52)
        end

        r15.Size = r1
        r2_2(r12, u879, r14, r15):Play()
    end

    function u876.load(u895)
        local r6 = {}

        for r2, r3 in u878:GetDescendants() do
            if r3:IsA("ImageLabel") then
                table.insert(r6, r3)
            end
        end

        u831:PreloadAsync(r6)
        u895:get_device()

        if u895._device == "Mobile" or u895._device == "Unknown" then
            u895:get_screen_scale()
            u887.Scale = u895._ui_scale

            u863.ui_scale = u797.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                u895:get_screen_scale()
                u887.Scale = u895._ui_scale
            end)
        end

        u832:Create(u879, TweenInfo.new(0.55, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Size = u821.fromOffset(698, 479)}):Play()
        u895._ui_loaded = true
    end

    function u876.update_tabs(r0, r1, r2)
        local r12 = r2 ~= false
        r0._active_tab_ref = r1

        for r4, r5 in u884:GetChildren() do
            if r5.Name == "Tab" then
                r5.BackgroundColor3 = u877.CardDeep
                local r2_2 = r5:FindFirstChild("Indicator")
                local r13 = r5:FindFirstChildOfClass("TextLabel")
                local r14 = r13 and r13:FindFirstChildOfClass("UIGradient")
                local r15 = r5:FindFirstChild("Icon")

                if r5 == r1 then
                    r5:SetAttribute("_active", true)

                    if r12 then
                        u832:Create(r5, TweenInfo.new(0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out), {BackgroundTransparency = 0.82}):Play()

                        if r13 then
                            u832:Create(r13, TweenInfo.new(0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                                TextTransparency = 0,
                                TextColor3 = u877.Accent
                            }):Play()
                        end

                        if r14 then
                            u832:Create(r14, TweenInfo.new(0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Offset = Vector2.new(1, 0)}):Play()
                        end

                        if r15 then
                            u832:Create(r15, TweenInfo.new(0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                                ImageTransparency = 0,
                                ImageColor3 = u877.Accent
                            }):Play()
                        end

                        if r2_2 then
                            r2_2.BackgroundColor3 = u877.Accent
                            r2_2.BackgroundTransparency = 1
                            r2_2.Size = u821.new(0, 3, 0, 6)

                            u832:Create(r2_2, TweenInfo.new(0.42, u824.EasingStyle.Back, u824.EasingDirection.Out), {
                                BackgroundTransparency = 0,
                                Size = u821.new(0, 3, 0, 22)
                            }):Play()
                        end
                    else
                        r5.BackgroundTransparency = 0.82

                        if r13 then
                            r13.TextTransparency = 0
                            r13.TextColor3 = u877.Accent
                        end

                        if r14 then
                            r14.Offset = Vector2.new(1, 0)
                        end

                        if r15 then
                            r15.ImageTransparency = 0
                            r15.ImageColor3 = u877.Accent
                        end

                        if r2_2 then
                            r2_2.BackgroundColor3 = u877.Accent
                            r2_2.BackgroundTransparency = 0
                            r2_2.Size = u821.new(0, 3, 0, 22)
                        end
                    end
                else
                    r5:SetAttribute("_active", false)

                    if r12 then
                        u832:Create(r5, TweenInfo.new(0.28, u824.EasingStyle.Quint, u824.EasingDirection.Out), {BackgroundTransparency = 1}):Play()

                        if r13 then
                            u832:Create(r13, TweenInfo.new(0.28, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                                TextTransparency = 0.42,
                                TextColor3 = u877.Text
                            }):Play()
                        end

                        if r14 then
                            u832:Create(r14, TweenInfo.new(0.28, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Offset = Vector2.new(0, 0)}):Play()
                        end

                        if r15 then
                            u832:Create(r15, TweenInfo.new(0.28, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                                ImageTransparency = 0.5,
                                ImageColor3 = u877.Text
                            }):Play()
                        end

                        if r2_2 then
                            u832:Create(r2_2, TweenInfo.new(0.22, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                                BackgroundTransparency = 1,
                                Size = u821.new(0, 3, 0, 10)
                            }):Play()
                        end
                    else
                        r5.BackgroundTransparency = 1

                        if r13 then
                            r13.TextTransparency = 0.42
                            r13.TextColor3 = u877.Text
                        end

                        if r14 then
                            r14.Offset = Vector2.new(0, 0)
                        end

                        if r15 then
                            r15.ImageTransparency = 0.5
                            r15.ImageColor3 = u877.Text
                        end

                        if r2_2 then
                            r2_2.BackgroundColor3 = u877.Accent
                            r2_2.BackgroundTransparency = 1
                            r2_2.Size = u821.new(0, 3, 0, 10)
                        end
                    end
                end
            end
        end
    end

    function u876.update_sections(r0, r1, r2)
        for r4, r5 in u886:GetChildren() do
            if r5 == r1 or r5 == r2 then
                r5.Visible = true
                r5.Position = u821.new(r5.Position.X.Scale, 12, r5.Position.Y.Scale, r5.Position.Y.Offset)
                local r6 = r5:FindFirstChildOfClass("UIScale")

                if not r6 then
                    r6 = u859.new("UIScale")
                    r6.Scale = 0.97
                    r6.Parent = r5
                else
                    r6.Scale = 0.97
                end

                u832:Create(r5, TweenInfo.new(0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                    Position = u821.new(r5.Position.X.Scale, 0, r5.Position.Y.Scale, r5.Position.Y.Offset)
                }):Play()

                u832:Create(r6, TweenInfo.new(0.32, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Scale = 1}):Play()
            else
                r5.Visible = false
            end
        end
    end

    function u876.create_tab(u896, r1, r2, r3)
        local r6 = r3 or {}
        local r7 = {}
        local r11 = u859.new("GetTextBoundsParams")
        r11.Text = r1
        r11.Font = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        r11.Size = 13
        r11.Width = 10000
        local r3_2 = u834:GetTextBoundsAsync(r11)
        local r8 = not r6.no_activate and (not u884:FindFirstChild("Tab") or u896._active_tab_ref == nil)
        local u897 = u859.new("TextButton")
        u897.Text = ""
        u897.AutoButtonColor = false
        u897.BackgroundTransparency = 1
        u897.Name = "Tab"
        u897.Size = u821.new(0, 129, 0, 38)
        u897.BorderSizePixel = 0
        u897.BackgroundColor3 = u877.CardDeep
        u897.Parent = u884

        if r6.layout_order ~= nil then
            u897.LayoutOrder = r6.layout_order
        else
            u897.LayoutOrder = u896._tab
            u896._tab = u896._tab + 1
        end

        local r5 = u859.new("UICorner")
        r5.CornerRadius = u822.new(0, 8)
        r5.Parent = u897
        local r5_2 = u859.new("UIScale")
        r5_2.Scale = 1
        r5_2.Parent = u897
        local r5_3 = u859.new("Frame")
        r5_3.Name = "Indicator"
        r5_3.Size = u821.new(0, 3, 0, 20)
        r5_3.Position = u821.new(0, 2, 0.5, 0)
        r5_3.AnchorPoint = Vector2.new(0, 0.5)
        r5_3.BackgroundColor3 = u877.Accent
        r5_3.BackgroundTransparency = 1
        r5_3.BorderSizePixel = 0
        r5_3.Parent = u897
        local r6_2 = u859.new("UICorner")
        r6_2.CornerRadius = u822.new(0, 3)
        r6_2.Parent = r5_3
        local r5_4 = u859.new("TextLabel")
        r5_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        r5_4.TextColor3 = u877.Text
        r5_4.TextTransparency = 0.38
        r5_4.Text = r1
        r5_4.Size = u821.new(0, r3_2.X, 0, 16)
        r5_4.AnchorPoint = Vector2.new(0, 0.5)
        r5_4.Position = u821.new(0.24, 0, 0.5, 0)
        r5_4.BackgroundTransparency = 1
        r5_4.TextXAlignment = u824.TextXAlignment.Left
        r5_4.TextSize = 13
        r5_4.Parent = u897
        local r6_3 = u859.new("UIGradient")

        r6_3.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, u877.Text),
            ColorSequenceKeypoint.new(0.65, u820.fromRGB(148, 147, 153)),
            ColorSequenceKeypoint.new(1, u820.fromRGB(75, 74, 80))
        })

        r6_3.Parent = r5_4
        local r5_5 = u859.new("ImageLabel")
        r5_5.ScaleType = u824.ScaleType.Fit
        r5_5.ImageTransparency = 0.45
        r5_5.AnchorPoint = Vector2.new(0, 0.5)
        r5_5.BackgroundTransparency = 1
        r5_5.Position = u821.new(0.1, 0, 0.5, 0)
        r5_5.Name = "Icon"
        r5_5.Image = u866(r2)
        r5_5.ImageColor3 = u877.Text
        r5_5.Size = u821.new(0, 13, 0, 13)
        r5_5.BorderSizePixel = 0
        r5_5.Parent = u897

        local function r5_6(r0)
            local r1 = u859.new("ScrollingFrame")
            r1.AutomaticCanvasSize = u824.AutomaticSize.XY
            r1.ScrollBarThickness = 0
            r1.Size = u821.new(0, 243, 0, 360)
            r1.Selectable = false
            r1.ScrollBarImageTransparency = 1
            r1.BackgroundTransparency = 1
            r1.Position = u821.new(r0, 0, 0.16, 0)
            r1.BorderSizePixel = 0
            r1.CanvasSize = u821.new(0, 0, 0.5, 0)
            r1.Visible = false
            r1.Parent = u886
            local r2 = u859.new("UIListLayout")
            r2.Padding = u822.new(0, 10)
            r2.HorizontalAlignment = u824.HorizontalAlignment.Center
            r2.SortOrder = u824.SortOrder.LayoutOrder
            r2.Parent = r1
            local r2_2 = u859.new("UIPadding")
            r2_2.PaddingTop = u822.new(0, 1)
            r2_2.PaddingBottom = u822.new(0, 8)
            r2_2.Parent = r1
            return r1
        end

        local u898 = r5_6(0.23)
        local u899 = r5_6(0.6)

        if r8 then
            u896:update_tabs(u897)
            u896:update_sections(u898, u899)
        end

        u897.MouseButton1Click:Connect(function()
            u896:update_tabs(u897)
            u896:update_sections(u898, u899)
        end)

        function r7.create_module(r0, u903)
            local u900 = 0

            local u901 = {
                _state = false,
                _size = 0,
                _multiplier = 0,
                _accent_bar = nil
            }

            local u902 = false
            local r14
            u903.section = u903.section == "right" and u899 or u898
            u903.section:FindFirstChildOfClass("UIListLayout")

            local function r4()
                local r7 = 0

                for r1, r2 in u903.section:GetChildren() do
                    if r2:IsA("Frame") and r7 < r2.LayoutOrder then
                        r7 = r2.LayoutOrder
                    end
                end

                return r7 + 1
            end

            local u904 = u859.new("Frame")
            u904.ClipsDescendants = true
            u904.BorderSizePixel = 0
            u904.BackgroundTransparency = 0.68
            u904.Name = "Module"
            u904.Size = u821.new(1, -8, 0, 93)
            u904.BackgroundColor3 = u877.Card
            u904.LayoutOrder = r4()
            u904.Parent = u903.section
            local u905 = u904.LayoutOrder
            u904:SetAttribute("expanded", false)
            u904:SetAttribute("pinned", false)
            local r4_2 = u859.new("UIListLayout")
            r4_2.SortOrder = u824.SortOrder.LayoutOrder
            r4_2.Parent = u904
            local r4_3 = u859.new("UICorner")
            r4_3.CornerRadius = u822.new(0, 10)
            r4_3.Parent = u904
            local u906 = u859.new("UIStroke")
            u906.Color = u877.Stroke
            u906.Transparency = 0.32
            u906.ApplyStrokeMode = u824.ApplyStrokeMode.Border
            u906.Parent = u904

            table.insert(u864._all_modules, {
                frame = u904,
                title = (u903.title or ""):lower(),
                manager = u901,
                flag = u903.flag
            })

            local r16 = u859.new("TextButton")
            r16.Text = ""
            r16.AutoButtonColor = false
            r16.BackgroundTransparency = 1
            r16.Name = "Header"
            r16.Size = u821.new(1, 0, 0, 93)
            r16.BorderSizePixel = 0
            r16.Parent = u904
            local r4_4 = u859.new("Frame")
            r4_4.Size = u821.new(1, 0, 0, 58)
            r4_4.Position = u821.new(0, 0, 0, 0)
            r4_4.BackgroundColor3 = u877.CardDeep
            r4_4.BackgroundTransparency = 0.6
            r4_4.BorderSizePixel = 0
            r4_4.ZIndex = 0
            r4_4.Parent = r16
            local r5 = u859.new("UIGradient")
            r5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
            r5.Rotation = 90
            r5.Parent = r4_4
            local u907 = u859.new("Frame")
            u907.Name = "AccentBar"
            u907.Size = u821.new(0, 2, 0, 50)
            u907.Position = u821.new(0, 2, 0.5, 0)
            u907.AnchorPoint = Vector2.new(0, 0.5)
            u907.BackgroundColor3 = u861.Colors.AccentDim
            u907.BackgroundTransparency = 0.45
            u907.BorderSizePixel = 0
            u907.ZIndex = 3
            u907.Parent = r16
            local r4_5 = u859.new("UICorner")
            r4_5.CornerRadius = u822.new(0, 2)
            r4_5.Parent = u907
            u901._accent_bar = u907
            local r4_6 = u859.new("ImageLabel")
            r4_6.ImageColor3 = u877.AccentSoft
            r4_6.ScaleType = u824.ScaleType.Fit
            r4_6.AnchorPoint = Vector2.new(0, 0.5)
            r4_6.Image = "rbxassetid://79095934438045"
            r4_6.BackgroundTransparency = 1
            r4_6.Position = u821.new(0.071, 0, 0.82, 0)
            r4_6.Name = "Icon"
            r4_6.Size = u821.new(0, 15, 0, 15)
            r4_6.BorderSizePixel = 0
            r4_6.ImageTransparency = 0.25
            r4_6.Parent = r16
            local u908 = u859.new("ImageButton")
            u908.Name = "PinBtn"
            u908.Size = u821.new(0, 13, 0, 13)
            u908.AnchorPoint = Vector2.new(1, 0.5)
            u908.Position = u821.new(1, -10, 0.5, -23)
            u908.BackgroundTransparency = 1
            u908.Image = u866("pin") ~= "" and u866("pin") or "rbxassetid://7072718362"
            u908.ImageColor3 = u877.SubText
            u908.ImageTransparency = 0.55
            u908.BorderSizePixel = 0
            u908.ZIndex = 5
            u908.Parent = r16

            u908.MouseEnter:Connect(function()
                u832:Create(u908, TweenInfo.new(0.18), {ImageColor3 = u902 and u877.Accent or u877.Text, ImageTransparency = 0.1}):Play()
            end)

            u908.MouseLeave:Connect(function()
                u832:Create(u908, TweenInfo.new(0.22), {ImageColor3 = u902 and u877.Accent or u877.SubText, ImageTransparency = u902 and 0.08 or 0.55}):Play()
            end)

            u908.MouseButton1Click:Connect(function()
                u902 = not u902
                u904:SetAttribute("pinned", u902)

                if u902 then
                    u904.LayoutOrder = -1000

                    u832:Create(u908, TweenInfo.new(0.35, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        ImageColor3 = u877.Accent,
                        ImageTransparency = 0.08
                    }):Play()

                    u832:Create(u906, TweenInfo.new(0.35), {Color = u877.Accent, Transparency = 0.55}):Play()
                else
                    u904.LayoutOrder = u905

                    u832:Create(u908, TweenInfo.new(0.35, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        ImageColor3 = u877.SubText,
                        ImageTransparency = 0.55
                    }):Play()

                    if not u901._state then
                        u832:Create(u906, TweenInfo.new(0.35), {Color = u877.Stroke, Transparency = 0.32}):Play()
                    end
                end
            end)

            local r4_7 = u859.new("TextLabel")
            r4_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
            r4_7.TextColor3 = u877.Text
            r4_7.TextTransparency = 0.06

            if not u903.rich then
                r4_7.Text = u903.title or "Module"
            else
                r4_7.RichText = true
                r4_7.Text = u903.richtext or "Module"
            end

            r4_7.Name = "ModuleName"
            r4_7.Size = u821.new(0, 205, 0, 14)
            r4_7.AnchorPoint = Vector2.new(0, 0.5)
            r4_7.Position = u821.new(0.073, 0, 0.24, 0)
            r4_7.BackgroundTransparency = 1
            r4_7.TextXAlignment = u824.TextXAlignment.Left
            r4_7.TextSize = 13
            r4_7.Parent = r16
            local r4_8 = u859.new("TextLabel")
            r4_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Regular)
            r4_8.TextColor3 = u877.SubText
            r4_8.TextTransparency = 0.1
            r4_8.Text = u903.description or ""
            r4_8.Name = "Description"
            r4_8.Size = u821.new(0, 205, 0, 13)
            r4_8.AnchorPoint = Vector2.new(0, 0.5)
            r4_8.Position = u821.new(0.073, 0, 0.42, 0)
            r4_8.BackgroundTransparency = 1
            r4_8.TextXAlignment = u824.TextXAlignment.Left
            r4_8.TextSize = 10
            r4_8.Parent = r16
            local u909 = u859.new("Frame")
            u909.Name = "Toggle"
            u909.BackgroundTransparency = 0.6
            u909.Position = u821.new(0.82, 0, 0.757, 0)
            u909.Size = u821.new(0, 26, 0, 13)
            u909.BorderSizePixel = 0
            u909.BackgroundColor3 = u820.fromRGB(8, 7, 12)
            u909.Parent = r16
            local r4_9 = u859.new("UICorner")
            r4_9.CornerRadius = u822.new(0, 12)
            r4_9.Parent = u909
            local r4_10 = u859.new("UIStroke")
            r4_10.Color = u877.Stroke
            r4_10.Transparency = 0.25
            r4_10.Parent = u909
            local u910 = u859.new("Frame")
            u910.AnchorPoint = Vector2.new(0, 0.5)
            u910.BackgroundTransparency = 0.1
            u910.Position = u821.new(0, 2, 0.5, 0)
            u910.Name = "Circle"
            u910.Size = u821.new(0, 9, 0, 9)
            u910.BorderSizePixel = 0
            u910.BackgroundColor3 = u877.SubText
            u910.Parent = u909
            local r4_11 = u859.new("UICorner")
            r4_11.CornerRadius = u822.new(0, 12)
            r4_11.Parent = u910
            local u911 = u859.new("Frame")
            u911.Name = "Keybind"
            u911.BackgroundTransparency = 0.65
            u911.Position = u821.new(0.15, 0, 0.73, 0)
            u911.Size = u821.new(0, 33, 0, 15)
            u911.BorderSizePixel = 0
            u911.BackgroundColor3 = u877.Accent
            u911.Parent = r16
            local r4_12 = u859.new("UICorner")
            r4_12.CornerRadius = u822.new(0, 3)
            r4_12.Parent = u911

            local u912 = u859.new("TextLabel")
            u912.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
            u912.TextColor3 = u877.AccentSoft
            u912.Text = "None"
            u912.AnchorPoint = Vector2.new(0.5, 0.5)
            u912.Size = u821.new(0, 25, 0, 13)
            u912.BackgroundTransparency = 1
            u912.TextXAlignment = u824.TextXAlignment.Left
            u912.Position = u821.new(0.5, 0, 0.5, 0)
            u912.TextSize = 10
            u912.Parent = u911
            local u913 = false

            if u903.notify then
                local u914 = u903.flag .. "_notify"
                u913 = u864._config._library[u914] == true
                local u915 = u859.new("ImageButton")
                u915.Name = "Bell"
                u915.Size = u821.new(0, 18, 0, 18)
                u915.AnchorPoint = Vector2.new(0, 0)
                u915.Position = u821.new(0.72, 0, 0.735, 0)
                u915.BackgroundTransparency = 1
                u915.Image = u866("bell")
                u915.ImageColor3 = u913 and u877.Accent or u877.SubText
                u915.ImageTransparency = u913 and 0.05 or 0.45
                u915.BorderSizePixel = 0
                u915.Parent = r16

                u915.MouseButton1Click:Connect(function()
                    u913 = not u913
                    u864._config._library[u914] = u913
                    u867:save(u796.GameId, u864._config)

                    u832:Create(u915, TweenInfo.new(0.3, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        ImageColor3 = u913 and u861.Colors.Accent or u861.Colors.SubText,
                        ImageTransparency = u913 and 0.05 or 0.45
                    }):Play()
                end)
            end

            for r5_2, r6 in {0.62, 1} do
                local r25 = u859.new("Frame")
                r25.AnchorPoint = Vector2.new(0.5, 0)
                r25.BackgroundTransparency = 0.12
                r25.Position = u821.new(0.5, 0, r6, 0)
                r25.Size = u821.new(0, 241, 0, 1)
                r25.BorderSizePixel = 0
                r25.BackgroundColor3 = u877.Stroke
                r25.Parent = r16
            end

            local u916 = u859.new("Frame")
            u916.Name = "Options"
            u916.BackgroundTransparency = 1
            u916.Position = u821.new(0, 0, 1, 0)
            u916.Size = u821.new(1, 0, 0, 8)
            u916.BorderSizePixel = 0
            u916.Parent = u904
            local r4_13 = u859.new("UIPadding")
            r4_13.PaddingTop = u822.new(0, 8)
            r4_13.PaddingBottom = u822.new(0, 10)
            r4_13.Parent = u916
            local r4_14 = u859.new("UIListLayout")
            r4_14.Padding = u822.new(0, 6)
            r4_14.HorizontalAlignment = u824.HorizontalAlignment.Center
            r4_14.SortOrder = u824.SortOrder.LayoutOrder
            r4_14.Parent = u916

            r16.MouseEnter:Connect(function()
                if u901._state then
                    return
                end

                u832:Create(u906, TweenInfo.new(0.22, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                    Color = u861.Colors.StrokeHot,
                    Transparency = 0.1
                }):Play()

                u832:Create(u907, TweenInfo.new(0.22), {BackgroundTransparency = 0.2}):Play()
            end)

            r16.MouseLeave:Connect(function()
                if u901._state then
                    return
                end

                u832:Create(u906, TweenInfo.new(0.28, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Color = u861.Colors.Stroke, Transparency = 0.32}):Play()
                u832:Create(u907, TweenInfo.new(0.28), {BackgroundTransparency = 0.45}):Play()
            end)

            local function u917()
                if u901._state then
                    u904.Size = u821.new(1, -8, 0, 93 + u901._size + u901._multiplier + 16)
                end

                u916.Size = u821.new(1, -8, 0, u901._size + u901._multiplier)
            end

            function u901.change_state(r0, r1)
                r0._state = r1
                u904:SetAttribute("expanded", r0._state)

                if r0._state then
                    u832:Create(u904, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.new(1, -8, 0, 93 + r0._size + r0._multiplier + 16)
                    }):Play()

                    u832:Create(u909, TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        BackgroundColor3 = u861.Colors.Accent,
                        BackgroundTransparency = 0.3
                    }):Play()

                    u832:Create(u910, TweenInfo.new(0.35, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.new(0, 9, 0, 9),
                        Position = u821.new(1, -11, 0.5, 0),
                        BackgroundColor3 = u861.Colors.Background
                    }):Play()

                    local r16 = TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out)
                    u901._ab_tween = u832:Create(u907, r16, {BackgroundColor3 = u861.Colors.Accent, BackgroundTransparency = 0.08})
                    u901._ab_tween:Play()
                    u832:Create(u906, TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Color = u861.Colors.Accent, Transparency = 0.68}):Play()
                else
                    u832:Create(u904, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Size = u821.new(1, -8, 0, 93)}):Play()

                    u832:Create(u909, TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        BackgroundColor3 = u820.fromRGB(8, 7, 12),
                        BackgroundTransparency = 0.6
                    }):Play()

                    u832:Create(u910, TweenInfo.new(0.35, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.new(0, 9, 0, 9),
                        Position = u821.new(0, 2, 0.5, 0),
                        BackgroundColor3 = u861.Colors.SubText
                    }):Play()

                    local r16_2 = TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out)
                    u901._ab_tween = u832:Create(u907, r16_2, {BackgroundColor3 = u861.Colors.AccentDim, BackgroundTransparency = 0.45})
                    u901._ab_tween:Play()
                    u832:Create(u906, TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Color = u861.Colors.Stroke, Transparency = 0.32}):Play()
                end

                u864._config._flags[u903.flag] = r0._state
                u867:save(u796.GameId, u864._config)
                u903.callback(r0._state)

                if u913 then
                    u864.SendNotification({
                        title = u903.title or "Module",
                        text = r0._state and u862.ModuleEnabled or u862.ModuleDisabled,
                        icon = r0._state and "check" or "x",
                        iconColor = r0._state and u877.Accent or u877.Danger,
                        duration = 2.5
                    })
                end
            end

            function u901.connect_keybind(u918)
                if not u864._config._keybinds[u903.flag] then
                    return
                end

                u863[u903.flag .. "_keybind"] = u830.InputBegan:Connect(function(r0, r1)
                    if r1 or u864._choosing_keybind or u864.keybind_is_clear(r0) then
                        return
                    end

                    if tostring(r0.KeyCode) ~= u864._config._keybinds[u903.flag] then
                        return
                    end

                    u918:change_state(not u918._state)
                end)
            end

            function u901.scale_keybind(r0, r1)
                if u864._config._keybinds[u903.flag] and not r1 then
                    local r7 = u864._config._keybinds[u903.flag]:gsub("Enum.KeyCode.", "")
                    local r1_2 = u859.new("GetTextBoundsParams")
                    r1_2.Text = r7
                    r1_2.Font = Font.new("rbxasset://fonts/families/Montserrat.json", u824.FontWeight.Bold)
                    r1_2.Size = 10
                    r1_2.Width = 10000
                    local r8 = u834:GetTextBoundsAsync(r1_2)
                    u911.Size = u821.fromOffset(r8.X + 6, 15)
                    u912.Size = u821.fromOffset(r8.X, 13)
                else
                    u911.Size = u821.fromOffset(31, 15)
                    u912.Size = u821.fromOffset(25, 13)
                end
            end

            if u864:flag_type(u903.flag, "boolean") then
                u901._state = true
                u904:SetAttribute("expanded", true)
                u909.BackgroundColor3 = u861.Colors.Accent
                u909.BackgroundTransparency = 0.3
                u910.BackgroundColor3 = u861.Colors.Background
                u910.Position = u821.new(1, -11, 0.5, 0)
                u907.BackgroundColor3 = u861.Colors.Accent
                u907.BackgroundTransparency = 0.08
                u906.Color = u861.Colors.Accent
                u906.Transparency = 0.68
                u903.callback(u901._state)
            end

            if u864._config._keybinds[u903.flag] then
                u912.Text = u864._config._keybinds[u903.flag]:gsub("Enum.KeyCode.", "")

                u901:connect_keybind()
                u901:scale_keybind()
            end

            u863[u903.flag .. "_input_began"] = r16.InputBegan:Connect(function(u919)
                if u864._choosing_keybind then
                    return
                end

                if u919.UserInputType ~= u824.UserInputType.MouseButton3 then
                    return
                end

                u864._choosing_keybind = true

                function u919(r0, r1)
                    if not u864.keybind_can_capture(r0, r1, false) then return end

                    if r0.KeyCode == u824.KeyCode.Backspace then
                        u901:scale_keybind(true)
                        u864._config._keybinds[u903.flag] = nil
                        u867:save(u796.GameId, u864._config)
                        u912.Text = "None"
                        u863:disconnect(u903.flag .. "_keybind")
                        u863:disconnect("keybind_choose_start")
                        u864.finish_keybind_capture()
                        return
                    end

                    u863:disconnect("keybind_choose_start")
                    u864._config._keybinds[u903.flag] = tostring(r0.KeyCode)
                    u867:save(u796.GameId, u864._config)
                    u863:disconnect(u903.flag .. "_keybind")
                    u901:connect_keybind()
                    u901:scale_keybind()
                    u864.finish_keybind_capture()
                    u912.Text = u864._config._keybinds[u903.flag]:gsub("Enum.KeyCode.", "")
                end

                u863.keybind_choose_start = u830.InputBegan:Connect(u919)
            end)

            r16.MouseButton1Click:Connect(function()
                u901:change_state(not u901._state)
            end)

            function u901.create_slider(r0, u920)
                u900 = u900 + 1

                if r0._size == 0 then
                    r0._size = 11
                end

                r0._size = r0._size + 28
                u917()
                local u921 = u920.decimals or 0
                local u922 = 10 ^ u921

                local function u923(r0)
                    if u921 == 0 then
                        return tostring(math.floor(r0))
                    end

                    return string.format("%." .. u921 .. "f", r0)
                end

                local r11 = u859.new("TextButton")
                r11.Text = ""
                r11.AutoButtonColor = false
                r11.BackgroundTransparency = 1
                r11.Name = "Slider"
                r11.Size = u821.new(0, 207, 0, 22)
                r11.BorderSizePixel = 0
                r11.Parent = u916
                r11.LayoutOrder = u900
                local r2 = u859.new("TextLabel")
                r2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r2.TextSize = 11
                r2.TextColor3 = u877.Text
                r2.TextTransparency = 0.16
                r2.Text = u920.title
                r2.Size = u821.new(0, 153, 0, 13)
                r2.Position = u821.new(0, 0, 0.05, 0)
                r2.BackgroundTransparency = 1
                r2.TextXAlignment = u824.TextXAlignment.Left
                r2.Parent = r11
                local u924 = u859.new("Frame")
                u924.AnchorPoint = Vector2.new(0.5, 1)
                u924.BackgroundTransparency = 0.78
                u924.Position = u821.new(0.5, 0, 0.95, 0)
                u924.Name = "Drag"
                u924.Size = u821.new(0, 207, 0, 4)
                u924.BorderSizePixel = 0
                u924.BackgroundColor3 = u877.Stroke
                u924.Parent = r11
                local r2_2 = u859.new("UICorner")
                r2_2.CornerRadius = u822.new(0, 12)
                r2_2.Parent = u924
                local u925 = u859.new("Frame")
                u925.AnchorPoint = Vector2.new(0, 0.5)
                u925.BackgroundTransparency = 0.05
                u925.Position = u821.new(0, 0, 0.5, 0)
                u925.Name = "Fill"
                u925.Size = u821.new(0, 103, 0, 4)
                u925.BorderSizePixel = 0
                u925.BackgroundColor3 = u877.Accent
                u925.Parent = u924
                local r2_3 = u859.new("UICorner")
                r2_3.CornerRadius = u822.new(0, 3)
                r2_3.Parent = u925
                local r2_4 = u859.new("UIGradient")
                r2_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, u877.AccentSoft), ColorSequenceKeypoint.new(1, u877.AccentDim)})
                r2_4.Parent = u925
                local r2_5 = u859.new("Frame")
                r2_5.AnchorPoint = Vector2.new(1, 0.5)
                r2_5.Name = "Circle"
                r2_5.Position = u821.new(1, 0, 0.5, 0)
                r2_5.Size = u821.new(0, 7, 0, 7)
                r2_5.BorderSizePixel = 0
                r2_5.BackgroundColor3 = u877.AccentSoft
                r2_5.Parent = u925
                local r3 = u859.new("UICorner")
                r3.CornerRadius = u822.new(0, 12)
                r3.Parent = r2_5
                local u926 = u859.new("TextLabel")
                u926.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                u926.TextColor3 = u820.fromRGB(235, 234, 239)
                u926.TextTransparency = 0.2
                u926.Text = "0"
                u926.Name = "Value"
                u926.Size = u821.new(0, 42, 0, 13)
                u926.AnchorPoint = Vector2.new(1, 0)
                u926.Position = u821.new(1, 0, 0, 0)
                u926.BackgroundTransparency = 1
                u926.TextXAlignment = u824.TextXAlignment.Right
                u926.TextSize = 10
                u926.Parent = r11

                local u927 = {
                    set_percentage = function(r0, r1)
                        local r4 = math.floor(math.clamp(r1, u920.minimum_value, u920.maximum_value) * u922 + 0.5) / u922
                        local r3 = math.clamp((r4 - u920.minimum_value) / (u920.maximum_value - u920.minimum_value), 0.02, 1) * u924.Size.X.Offset
                        u864._config._flags[u920.flag] = r4
                        u926.Text = u923(r4)
                        u832:Create(u925, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Size = u821.fromOffset(r3, u924.Size.Y.Offset)}):Play()
                        u920.callback(r4)
                    end,
                    update = function(r0)
                        r0:set_percentage(u920.minimum_value + (u920.maximum_value - u920.minimum_value) * math.clamp((u860.X - u924.AbsolutePosition.X) / u924.Size.X.Offset, 0, 1))
                    end,
                    input = function(u928)
                        u928:update()

                        u863["slider_drag_" .. u920.flag] = u860.Move:Connect(function()
                            u928:update()
                        end)

                        u863["slider_input_" .. u920.flag] = u830.InputEnded:Connect(function(r0)
                            if r0.UserInputType ~= u824.UserInputType.MouseButton1 and r0.UserInputType ~= u824.UserInputType.Touch then
                                return
                            end

                            u863:disconnect("slider_drag_" .. u920.flag)
                            u863:disconnect("slider_input_" .. u920.flag)

                            if not u920.ignoresaved then
                                u867:save(u796.GameId, u864._config)
                            end
                        end)
                    end
                }

                if u864:flag_type(u920.flag, "number") and not u920.ignoresaved then
                    u927:set_percentage(u864._config._flags[u920.flag])
                else
                    u927:set_percentage(u920.value)
                end

                r11.MouseButton1Down:Connect(function()
                    u927:input()
                end)

                return u927
            end

            function u901.create_doubleslider(u929, u930)
                u900 = u900 + 1

                if u929._size == 0 then
                    u929._size = 11
                end

                u929._size = u929._size + 28
                u917()
                local u931 = u930.decimals or 0
                local u932 = 10 ^ u931

                local function u933(r0)
                    if u931 == 0 then
                        return tostring(math.floor(r0))
                    end

                    return string.format("%." .. u931 .. "f", r0)
                end

                local u934 = u930.minimum_value
                local u935 = u930.maximum_value
                local r3, r5

                if u930.value and type(u930.value) == "table" then
                    r3 = u930.value[1] or u930.value.L or u934
                    r5 = u930.value[2] or u930.value.H or u935
                else
                    r3 = u930.value_low or u934
                    r5 = u930.value_high or u935
                end

                local r18, r4

                if u864._config._flags[u930.flag] and type(u864._config._flags[u930.flag]) == "table" then
                    local r6 = u864._config._flags[u930.flag]

                    if r6.L ~= nil and r6.H ~= nil then
                        r18 = r6.L
                        r4 = r6.H
                    elseif r6[1] ~= nil and r6[2] ~= nil then
                        r18 = r6[1]
                        r4 = r6[2]
                    else
                        r18 = r3
                        r4 = r5
                    end
                else
                    r18 = r3
                    r4 = r5
                end

                local r3_2 = math.clamp(r18, u934, u935)
                local r17 = math.clamp(r4, u934, u935)
                local r23, r24

                if r17 < r3_2 then
                    r23 = r17
                    r24 = r3_2
                else
                    r23 = r3_2
                    r24 = r17
                end

                local r11 = u859.new("TextButton")
                r11.Text = ""
                r11.AutoButtonColor = false
                r11.BackgroundTransparency = 1
                r11.Name = "DoubleSlider"
                r11.Size = u821.new(0, 207, 0, 22)
                r11.BorderSizePixel = 0
                r11.Parent = u916
                r11.LayoutOrder = u900
                local r12 = u859.new("TextLabel")
                r12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r12.TextSize = 11
                r12.TextColor3 = u877.Text
                r12.TextTransparency = 0.16
                r12.Text = u930.title
                r12.Size = u821.new(0, 120, 0, 13)
                r12.Position = u821.new(0, 0, 0.05, 0)
                r12.BackgroundTransparency = 1
                r12.TextXAlignment = u824.TextXAlignment.Left
                r12.Parent = r11
                local u936 = u859.new("Frame")
                u936.Active = true
                u936.AnchorPoint = Vector2.new(0.5, 1)
                u936.BackgroundTransparency = 0.78
                u936.Position = u821.new(0.5, 0, 0.95, 0)
                u936.Name = "Drag"
                u936.Size = u821.new(0, 207, 0, 4)
                u936.BorderSizePixel = 0
                u936.BackgroundColor3 = u877.Stroke
                u936.Parent = r11
                local r6_2 = u859.new("UICorner")
                r6_2.CornerRadius = u822.new(0, 12)
                r6_2.Parent = u936
                local u937 = u859.new("Frame")
                u937.AnchorPoint = Vector2.new(0, 0.5)
                u937.BackgroundTransparency = 0.05
                u937.Name = "RangeFill"
                u937.BorderSizePixel = 0
                u937.BackgroundColor3 = u877.Accent
                u937.Parent = u936
                local r6_3 = u859.new("UICorner")
                r6_3.CornerRadius = u822.new(0, 3)
                r6_3.Parent = u937
                local r14 = u859.new("UIGradient")
                r14.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, u877.AccentSoft), ColorSequenceKeypoint.new(1, u877.AccentDim)})
                r14.Parent = u937
                local u938 = u859.new("Frame")
                u938.Active = true
                u938.AnchorPoint = Vector2.new(0.5, 0.5)
                u938.Name = "KnobL"
                u938.Size = u821.new(0, 7, 0, 7)
                u938.BorderSizePixel = 0
                u938.BackgroundColor3 = u877.AccentSoft
                u938.ZIndex = 2
                u938.Parent = u936
                local r6_4 = u859.new("UICorner")
                r6_4.CornerRadius = u822.new(0, 12)
                r6_4.Parent = u938
                local u939 = u859.new("Frame")
                u939.Active = true
                u939.AnchorPoint = Vector2.new(0.5, 0.5)
                u939.Name = "KnobR"
                u939.Size = u821.new(0, 7, 0, 7)
                u939.BorderSizePixel = 0
                u939.BackgroundColor3 = u877.AccentSoft
                u939.ZIndex = 2
                u939.Parent = u936
                local r6_5 = u859.new("UICorner")
                r6_5.CornerRadius = u822.new(0, 12)
                r6_5.Parent = u939
                local u940 = u859.new("TextLabel")
                u940.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                u940.TextColor3 = u877.Text
                u940.TextTransparency = 0.2
                u940.Text = "0 - 0"
                u940.Name = "Value"
                u940.Size = u821.new(0, 80, 0, 13)
                u940.AnchorPoint = Vector2.new(1, 0)
                u940.Position = u821.new(1, 0, 0, 0)
                u940.BackgroundTransparency = 1
                u940.TextXAlignment = u824.TextXAlignment.Right
                u940.TextSize = 9
                u940.Parent = r11
                local u941
                local u942 = {}

                local function u943(r0)
                    return (r0 - u934) / (u935 - u934)
                end

                function u942.set_range(r0, r1, r2, r3)
                    local r7 = math.floor(math.clamp(r1, u934, u935) * u932 + 0.5) / u932
                    local r6 = math.floor(math.clamp(r2, u934, u935) * u932 + 0.5) / u932

                    if not (r6 < r7) then
                        local r18 = r6
                        r6 = r7
                        r7 = r18
                    end

                    local r4 = u931 == 0 and 1 or math.max((u935 - u934) * (0.5 / math.max(u932, 1)), 1 / u932)
                    local r8 = u941

                    if u941 and r7 - r6 < r4 then
                        if u941 == "low" then
                            r6 = math.clamp(r7 - r4, u934, u935)
                        else
                            r7 = math.clamp(r6 + r4, u934, u935)
                        end
                    end

                    u864._config._flags[u930.flag] = {L = r6, H = r7}
                    u940.Text = u933(r6) .. " - " .. u933(r7)
                    local r12 = u943(r6)
                    local r4_2 = u943(r7)
                    if r0._visualReady then
                         
                         
                        for _, tween in ipairs(r0._visualTweens or {}) do tween:Cancel() end
                        local info = TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out)
                        r0._visualTweens = {
                            u832:Create(u937, info, {
                                Position = u821.new(r12, 0, 0.5, 0),
                                Size = u821.new(math.max(r4_2 - r12, 0.02), 0, 1, 0)
                            }),
                            u832:Create(u938, info, {Position = u821.new(r12, 0, 0.5, 0)}),
                            u832:Create(u939, info, {Position = u821.new(r4_2, 0, 0.5, 0)})
                        }
                        for _, tween in ipairs(r0._visualTweens) do tween:Play() end
                    else
                         
                        u937.Position = u821.new(r12, 0, 0.5, 0)
                        u937.Size = u821.new(math.max(r4_2 - r12, 0.02), 0, 1, 0)
                        u938.Position = u821.new(r12, 0, 0.5, 0)
                        u939.Position = u821.new(r4_2, 0, 0.5, 0)
                    end
                    r0._visualReady = true
                    u930.callback(r6, r7)

                    if not r3 and not u930.ignoresaved then
                        u867:save(u796.GameId, u864._config)
                    end
                end

                function u942.pick_which(r0, r1)
                    local r2 = u934 + (u935 - u934) * math.clamp((r1 - u936.AbsolutePosition.X) / u936.AbsoluteSize.X, 0, 1)
                    local r4 = u864._config._flags[u930.flag].H

                    if math.abs(r2 - u864._config._flags[u930.flag].L) <= math.abs(r2 - r4) then
                        return "low"
                    end

                    return "high"
                end

                function u942.update_from_mouse(r0)
                    local r1 = u864._config._flags[u930.flag]

                    if not r1 or not u941 then
                        return
                    end

                    local r2 = u934 + (u935 - u934) * math.clamp((u860.X - u936.AbsolutePosition.X) / u936.AbsoluteSize.X, 0, 1)
                    local r3 = r1.L
                    local r11 = r1.H

                    if u941 == "low" then
                        u942:set_range(math.min(r2, r11), r11, true)
                    elseif u941 == "high" then
                        local r9 = math.max(r2, r3)
                        u942:set_range(r3, r9, true)
                    end
                end

                u864._config._flags[u930.flag] = {L = r23, H = r24}
                u942:set_range(r23, r24, true)

                local function u944(r0)
                    u863:disconnect("dsl_drag_" .. u930.flag)
                    u863:disconnect("dsl_end_" .. u930.flag)
                    u941 = r0
                    u942:update_from_mouse()

                    local function r0_2()
                        u942:update_from_mouse()
                    end

                    u863["dsl_drag_" .. u930.flag] = u860.Move:Connect(r0_2)

                    local function r0_3(r0)
                        if r0.UserInputType ~= u824.UserInputType.MouseButton1 and r0.UserInputType ~= u824.UserInputType.Touch then
                            return
                        end

                        u863:disconnect("dsl_drag_" .. u930.flag)
                        u863:disconnect("dsl_end_" .. u930.flag)
                        u941 = nil

                        if not u930.ignoresaved then
                            u867:save(u796.GameId, u864._config)
                        end
                    end

                    u863["dsl_end_" .. u930.flag] = u830.InputEnded:Connect(r0_3)
                end

                u938.InputBegan:Connect(function(r0)
                    if r0.UserInputType == u824.UserInputType.MouseButton1 or r0.UserInputType == u824.UserInputType.Touch then
                        u944("low")
                    end
                end)

                u939.InputBegan:Connect(function(r0)
                    if r0.UserInputType == u824.UserInputType.MouseButton1 or r0.UserInputType == u824.UserInputType.Touch then
                        u944("high")
                    end
                end)

                u936.InputBegan:Connect(function(r0)
                    if r0.UserInputType ~= u824.UserInputType.MouseButton1 and r0.UserInputType ~= u824.UserInputType.Touch then
                        return
                    end

                    u944(u942:pick_which(r0.Position.X))
                end)

                r11.Destroying:Connect(function()
                    for _, tween in ipairs(u942._visualTweens or {}) do tween:Cancel() end
                    u942._visualTweens = nil
                end)

                return u942
            end

            function u901.create_dropdown(r0, u945)
                if not u945.Order then
                    u900 = u900 + 1
                end

                local u946 = {_state = false, _size = 0}
                local u947 = false
                local u948 = false
                local u949 = u945.search and 26 or 0

                if not u945.Order then
                    if r0._size == 0 then
                        r0._size = 11
                    end

                    r0._size = r0._size + 45
                    u917()
                end

                if not u864._config._flags[u945.flag] then
                    u864._config._flags[u945.flag] = {}
                end

                local u950 = {}
                local u951 = u859.new("TextButton")
                u951.Text = ""
                u951.AutoButtonColor = false
                u951.BackgroundTransparency = 1
                u951.Name = "Dropdown"
                u951.Size = u821.new(0, 207, 0, 39)
                u951.BorderSizePixel = 0
                u951.Parent = u916
                u951.LayoutOrder = u945.Order and u945.OrderValue or u900
                local r3 = u859.new("TextLabel")
                r3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r3.TextSize = 11
                r3.TextColor3 = u877.Text
                r3.TextTransparency = 0.16
                r3.Text = u945.title
                r3.Size = u821.new(0, 207, 0, 13)
                r3.BackgroundTransparency = 1
                r3.TextXAlignment = u824.TextXAlignment.Left
                r3.Parent = u951

                if u945.notify then
                    local u952 = u945.flag .. "_dd_notify"

                    if not u864._config._library then
                        u864._config._library = {}
                    end

                    u947 = u864._config._library[u952] == true
                    local u953 = u859.new("ImageButton")
                    u953.Name = "DDBell"
                    u953.Size = u821.new(0, 14, 0, 14)
                    u953.AnchorPoint = Vector2.new(1, 0.5)
                    u953.Position = u821.new(1, 0, 0.5, 0)
                    u953.BackgroundTransparency = 1
                    u953.Image = u866("bell")
                    u953.ImageColor3 = u947 and u877.Accent or u877.SubText
                    u953.ImageTransparency = u947 and 0.05 or 0.48
                    u953.BorderSizePixel = 0
                    u953.ZIndex = 6
                    u953.Parent = r3

                    u953.MouseButton1Click:Connect(function()
                        u947 = not u947
                        u864._config._library[u952] = u947
                        u867:save(u796.GameId, u864._config)

                        u832:Create(u953, TweenInfo.new(0.3, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                            ImageColor3 = u947 and u877.Accent or u877.SubText,
                            ImageTransparency = u947 and 0.05 or 0.48
                        }):Play()
                    end)
                end

                local u954 = u859.new("Frame")
                u954.ClipsDescendants = true
                u954.AnchorPoint = Vector2.new(0.5, 0)
                u954.BackgroundTransparency = 0.9
                u954.Position = u821.new(0.5, 0, 1.2, 0)
                u954.Name = "Box"
                u954.Size = u821.new(0, 207, 0, 22)
                u954.BorderSizePixel = 0
                u954.BackgroundColor3 = u877.Accent
                u954.Parent = r3
                local r3_2 = u859.new("UICorner")
                r3_2.CornerRadius = u822.new(0, 6)
                r3_2.Parent = u954
                local r3_3 = u859.new("UIStroke")
                r3_3.Color = u877.StrokeHot
                r3_3.Transparency = 0.42
                r3_3.Parent = u954
                local r3_4 = u859.new("UIListLayout")
                r3_4.SortOrder = u824.SortOrder.LayoutOrder
                r3_4.Parent = u954
                local r3_5 = u859.new("Frame")
                r3_5.AnchorPoint = Vector2.new(0.5, 0)
                r3_5.BackgroundTransparency = 1
                r3_5.Position = u821.new(0.5, 0, 0, 0)
                r3_5.Size = u821.new(0, 207, 0, 22)
                r3_5.BorderSizePixel = 0
                r3_5.LayoutOrder = 1
                r3_5.Parent = u954
                local u955 = u859.new("TextLabel")
                u955.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                u955.TextColor3 = u877.Text
                u955.TextTransparency = 0.1
                u955.Name = "CurrentOption"
                u955.Size = u821.new(0, 161, 0, 13)
                u955.AnchorPoint = Vector2.new(0, 0.5)
                u955.Position = u821.new(0.05, 0, 0.5, 0)
                u955.BackgroundTransparency = 1
                u955.TextXAlignment = u824.TextXAlignment.Left
                u955.TextSize = 10
                u955.Parent = r3_5
                local r4 = u859.new("UIGradient")

                r4.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.704, 0),
                    NumberSequenceKeypoint.new(0.872, 0.36),
                    NumberSequenceKeypoint.new(1, 1)
                })

                r4.Parent = u955
                local u956 = u859.new("TextLabel")
                u956.Text = "⇅"
                u956.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                u956.TextSize = 10
                u956.TextColor3 = u877.Accent
                u956.BackgroundTransparency = 1
                u956.Size = u821.new(0, 10, 0, 10)
                u956.Position = u821.new(0.91, 0, 0.5, 0)
                u956.AnchorPoint = Vector2.new(0, 0.5)
                u956.Parent = r3_5
                local u957

                if u945.search then
                    local r3_6 = u859.new("Frame")
                    r3_6.Size = u821.new(0, 207, 0, u949)
                    r3_6.BackgroundColor3 = u877.CardDeep
                    r3_6.BackgroundTransparency = 0.25
                    r3_6.BorderSizePixel = 0
                    r3_6.LayoutOrder = 2
                    r3_6.Parent = u954
                    local r4_2 = u859.new("Frame")
                    r4_2.Size = u821.new(1, 0, 0, 1)
                    r4_2.Position = u821.new(0, 0, 0, 0)
                    r4_2.BackgroundColor3 = u877.StrokeHot
                    r4_2.BackgroundTransparency = 0.5
                    r4_2.BorderSizePixel = 0
                    r4_2.Parent = r3_6
                    local r4_3 = u859.new("ImageLabel")
                    r4_3.Size = u821.new(0, 10, 0, 10)
                    r4_3.Position = u821.new(0, 7, 0.5, 0)
                    r4_3.AnchorPoint = Vector2.new(0, 0.5)
                    r4_3.BackgroundTransparency = 1
                    r4_3.Image = u866("search")
                    r4_3.ImageColor3 = u877.SubText
                    r4_3.ImageTransparency = 0.25
                    r4_3.Parent = r3_6
                    u957 = u859.new("TextBox")
                    u957.Size = u821.new(1, -24, 1, -2)
                    u957.Position = u821.new(0, 21, 0, 1)
                    u957.BackgroundTransparency = 1
                    u957.TextColor3 = u877.Text
                    u957.PlaceholderColor3 = u877.SubText
                    u957.PlaceholderText = "Search..."
                    u957.Text = ""
                    u957.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Regular)
                    u957.TextSize = 10
                    u957.TextXAlignment = u824.TextXAlignment.Left
                    u957.ClearTextOnFocus = false
                    u957.AutomaticSize = u824.AutomaticSize.None
                    u957.Parent = r3_6
                end

                local u958 = u859.new("ScrollingFrame")
                u958.Active = true
                u958.ScrollBarImageTransparency = 0.35
                u958.ScrollBarImageColor3 = u877.SubText
                u958.AutomaticCanvasSize = u824.AutomaticSize.XY
                u958.ScrollBarThickness = 3
                u958.Name = "Options"
                u958.Size = u821.new(0, 207, 0, 0)
                u958.BackgroundTransparency = 1
                u958.Position = u821.new(0, 0, 1, 0)
                u958.BorderSizePixel = 0
                u958.CanvasSize = u821.new(0, 0, 0, 0)
                u958.LayoutOrder = u945.search and 3 or 2
                u958.Parent = u954
                local r3_7 = u859.new("UIListLayout")
                r3_7.SortOrder = u824.SortOrder.LayoutOrder
                r3_7.Parent = u958
                local r3_8 = u859.new("UIPadding")
                r3_8.PaddingTop = u822.new(0, -1)
                r3_8.PaddingLeft = u822.new(0, 8)
                r3_8.Parent = u958

                if u957 then
                    u957:GetPropertyChangedSignal("Text"):Connect(function()
                        local r11 = u957.Text:lower()

                        for r2, r3 in u958:GetChildren() do
                            if (r3.Name == "Option" or r3.Name == "DDSlider") and r3.Name == "Option" then
                                local r4 = r3:IsA("TextButton") and r3 or r3:FindFirstChild("OptionBtn")

                                if r4 then
                                    local r6 = r11 == ""

                                    if r11 ~= "" then
                                        r6 = r4.Text:lower():find(r11, 1, true) ~= nil
                                    end

                                    r3.Visible = r6
                                end
                            end
                        end
                    end)
                end

                local function u959(r0)
                    if r0:IsA("TextButton") then
                        return r0
                    end

                    return r0:FindFirstChild("OptionBtn")
                end

                local function u960()
                    if u945.multi_dropdown then
                        if #u950 == 0 then
                            u955.Text = "None"
                        else
                            u955.Text = table.concat(u950, ", ")
                        end

                        for r1, r2 in u958:GetChildren() do
                            if r2.Name == "Option" then
                                local r7 = u959(r2)

                                if r7 then
                                    local r3 = table.find(u950, r7.Text)
                                    r7.TextTransparency = r3 and 0.1 or 0.6

                                    if r3 then
                                        r3 = u877.AccentSoft
                                    end

                                    if not r3 then
                                        r3 = u877.Text
                                    end

                                    r7.TextColor3 = r3
                                end
                            end
                        end

                        u864._config._flags[u945.flag] = {unpack(u950)}
                    else
                        for r4, r5 in u958:GetChildren() do
                            if r5.Name == "Option" then
                                local r0 = u959(r5)

                                if r0 then
                                    local r1_2 = r0.Text == u955.Text
                                    r0.TextTransparency = r1_2 and 0.1 or 0.6

                                    if r1_2 then
                                        r1_2 = u877.AccentSoft
                                    end

                                    r0.TextColor3 = r1_2 or u877.Text
                                end
                            end
                        end
                    end
                end

                function u946.update(r0, r1)
                    if u945.multi_dropdown then
                        local r11 = typeof(r1) ~= "string" and r1.Name or r1
                        local r9 = table.find(u950, r11)

                        if r9 then
                            table.remove(u950, r9)
                        else
                            table.insert(u950, r11)
                        end

                        u960()
                        u867:save(u796.GameId, u864._config)
                        u945.callback({unpack(u950)})

                        if u947 and u948 then
                            local r9_2 = 0 < #u950 and table.concat(u950, ", ") or "None"

                            u864.SendNotification({
                                title = u945.title or "Dropdown",
                                text = r9_2,
                                icon = "check",
                                iconColor = u877.Accent,
                                duration = 2.5
                            })
                        end
                    else
                        u955.Text = typeof(r1) == "string" and r1 or r1.Name
                        u960()
                        u864._config._flags[u945.flag] = r1
                        u867:save(u796.GameId, u864._config)
                        u945.callback(r1)

                        if u947 and u948 then
                            local r2 = typeof(r1) == "string" and r1 or r1.Name

                            u864.SendNotification({
                                title = u945.title or "Dropdown",
                                text = r2,
                                icon = "check",
                                iconColor = u877.Accent,
                                duration = 2.5
                            })
                        end
                    end
                end

                local u961 = 0

                function u946.unfold_settings(r0)
                    r0._state = not r0._state
                    local r7 = r0._size + u949

                    if r0._state then
                        local r1 = u901
                        r1._multiplier = r1._multiplier + r7
                        u961 = r7
                    else
                        local r1_2 = u901
                        r1_2._multiplier = r1_2._multiplier - r7
                        u961 = 0

                        if u957 then
                            u957:ReleaseFocus()
                            u957.Text = ""
                        end
                    end

                    u832:Create(u904, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.new(1, -8, 0, 93 + u901._size + u901._multiplier + 16)
                    }):Play()

                    u832:Create(u904.Options, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.new(1, -8, 0, u901._size + u901._multiplier)
                    }):Play()

                    u832:Create(u951, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.fromOffset(207, r0._state and 39 + r7 or 39)
                    }):Play()

                    u832:Create(u954, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.fromOffset(207, r0._state and 22 + r7 or 22)
                    }):Play()

                    u832:Create(u956, TweenInfo.new(0.5, u824.EasingStyle.Quint, u824.EasingDirection.Out), {Rotation = r0._state and 180 or 0}):Play()
                end

                local function u962(u963, r1)
                    local r5 = typeof(u963) == "string" and u963 or u963.Name
                    local u964 = u945.flag .. "_" .. r5

                    if u945.keybind then
                        local r8 = u859.new("Frame")
                        r8.Size = u821.new(0, 186, 0, 16)
                        r8.BackgroundTransparency = 1
                        r8.Name = "Option"
                        r8.BorderSizePixel = 0
                        r8.Parent = u958
                        local r9 = u859.new("TextButton")
                        r9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                        r9.Active = false
                        r9.TextTransparency = 0.6
                        r9.TextSize = 10
                        r9.Size = u821.new(1, -44, 1, 0)
                        r9.Position = u821.new(0, 0, 0, 0)
                        r9.TextColor3 = u877.Text
                        r9.Text = r5
                        r9.AutoButtonColor = false
                        r9.Name = "OptionBtn"
                        r9.BackgroundTransparency = 1
                        r9.TextXAlignment = u824.TextXAlignment.Left
                        r9.Selectable = false
                        r9.BorderSizePixel = 0
                        r9.Parent = r8

                        local r3 = u859.new("UIGradient")

                        r3.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(0.704, 0),
                            NumberSequenceKeypoint.new(0.872, 0.36),
                            NumberSequenceKeypoint.new(1, 1)
                        })

                        r3.Parent = r9

                        local r4 = u864._config._keybinds[u964]
                        local r12 = r4 and r4:gsub("Enum.KeyCode.", "") or "..."
                        local u965 = u859.new("TextButton")
                        u965.AnchorPoint = Vector2.new(1, 0.5)
                        u965.Position = u821.new(1, 0, 0.5, 0)
                        u965.BackgroundColor3 = u877.Accent
                        u965.BackgroundTransparency = 0.6
                        u965.TextColor3 = u877.AccentSoft
                        u965.TextSize = 9
                        u965.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                        u965.Text = r12
                        u965.BorderSizePixel = 0
                        u965.AutoButtonColor = false
                        u965.Parent = r8
                        local r3_2 = u859.new("UICorner")
                        r3_2.CornerRadius = u822.new(0, 3)
                        r3_2.Parent = u965

                        local function u966(r0)
                            if r0 == "..." or r0 == "?" then
                                u965.Size = u821.fromOffset(22, 14)
                                return
                            end

                            local r5 = u859.new("GetTextBoundsParams")
                            r5.Text = r0
                            r5.Font = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                            r5.Size = 9
                            r5.Width = 10000
                            local r4 = u834:GetTextBoundsAsync(r5)
                            u965.Size = u821.fromOffset(math.max(22, r4.X + 8), 14)
                        end

                        u966(r12)

                        if r4 then
                            u863["dd_kb_" .. u964] = u830.InputBegan:Connect(function(r0, r1)
                                if r1 or u864._choosing_keybind or u864.keybind_is_clear(r0) then
                                    return
                                end

                                if tostring(r0.KeyCode) ~= u864._config._keybinds[u964] then
                                    return
                                end

                                u946:update(u963)
                            end)
                        end

                        u965.InputBegan:Connect(function(u967)
                            if u967.UserInputType ~= u824.UserInputType.MouseButton3 then
                                return
                            end

                            if u864._choosing_keybind then
                                return
                            end

                            u864._choosing_keybind = true
                            u965.Text = "?"
                            u966("?")
                            local u968

                            function u967(r0, r1)
                                if not u864.keybind_can_capture(r0, r1) then return end

                                u968:Disconnect()

                                if r0.KeyCode == u824.KeyCode.Backspace then
                                    u864._config._keybinds[u964] = nil
                                    u867:save(u796.GameId, u864._config)
                                    u965.Text = "..."
                                    u966("...")
                                    u863:disconnect("dd_kb_" .. u964)
                                else
                                    u864._config._keybinds[u964] = tostring(r0.KeyCode)
                                    u867:save(u796.GameId, u864._config)
                                    u965.Text = r0.KeyCode.Name
                                    u966(r0.KeyCode.Name)
                                    u863:disconnect("dd_kb_" .. u964)
                                    local u969 = "dd_kb_" .. u964

                                    u863[u969] = u830.InputBegan:Connect(function(r0, r1)
                                        if r1 or u864._choosing_keybind or u864.keybind_is_clear(r0) then
                                            return
                                        end

                                        if tostring(r0.KeyCode) ~= u864._config._keybinds[u964] then
                                            return
                                        end

                                        u946:update(u963)
                                    end)
                                end

                                u864.finish_keybind_capture()
                            end

                            u968 = u830.InputBegan:Connect(u967)
                        end)

                        r9.MouseButton1Click:Connect(function()
                            u946:update(u963)
                        end)

                        if r1 <= u945.maximum_options then
                            local r3_3 = u946
                            r3_3._size = r3_3._size + 16
                            u958.Size = u821.fromOffset(207, u946._size)
                        end
                    else
                        local r3_4 = u859.new("TextButton")
                        r3_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                        r3_4.Active = false
                        r3_4.TextTransparency = 0.6
                        r3_4.TextSize = 10
                        r3_4.Size = u821.new(0, 186, 0, 16)
                        r3_4.TextColor3 = u877.Text
                        r3_4.Text = r5
                        r3_4.AutoButtonColor = false
                        r3_4.Name = "Option"
                        r3_4.BackgroundTransparency = 1
                        r3_4.TextXAlignment = u824.TextXAlignment.Left
                        r3_4.Selectable = false
                        r3_4.BorderSizePixel = 0
                        r3_4.Parent = u958
                        local r4_2 = u859.new("UIGradient")

                        r4_2.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(0.704, 0),
                            NumberSequenceKeypoint.new(0.872, 0.36),
                            NumberSequenceKeypoint.new(1, 1)
                        })

                        r4_2.Parent = r3_4

                        r3_4.MouseButton1Click:Connect(function()
                            u946:update(u963)
                        end)

                        if r1 <= u945.maximum_options then
                            local r3_5 = u946
                            r3_5._size = r3_5._size + 16
                            u958.Size = u821.fromOffset(207, u946._size)
                        end
                    end
                end

                if #u945.options > 0 then
                    u946._size = 3

                    for r10, r11 in u945.options do
                        u962(r11, r10)
                    end
                end

                function u946.set_options(r0, r1)
                    if r0._state then
                        local r2 = r0._size + u949
                        r0._state = false
                        local r3 = u901
                        r3._multiplier = r3._multiplier - r2
                        u961 = 0
                        u951.Size = u821.fromOffset(207, 39)
                        u954.Size = u821.fromOffset(207, 22)
                        u956.Rotation = 0

                        if u957 then
                            u957:ReleaseFocus()
                            u957.Text = ""
                        end
                    end

                    for r3_2, r4 in u958:GetChildren() do
                        if r4.Name == "Option" then
                            r4:Destroy()
                        end
                    end

                    local r2_2 = u955.Text
                    local r3_3 = {}

                    if u945.multi_dropdown then
                        for r6, r7 in ipairs(u950) do
                            r3_3[r7] = true
                        end
                    end

                    u950 = {}
                    r0._size = #r1 > 0 and 3 or 0
                    u945.options = r1
                    u945.maximum_options = #r1

                    for r9, r10 in ipairs(r1) do
                        u962(r10, r9)
                    end

                    if u945.multi_dropdown then
                        local r4_2 = {}

                        for r12, r13 in ipairs(r1) do
                            local r5 = typeof(r13) == "string" and r13 or r13.Name

                            if r3_3[r5] then
                                table.insert(r4_2, r5)
                            end
                        end

                        u950 = r4_2

                        if #u950 == 0 then
                            u955.Text = "None"
                            u864._config._flags[u945.flag] = {}
                        else
                            u955.Text = table.concat(u950, ", ")
                            u864._config._flags[u945.flag] = {unpack(u950)}
                        end

                        u960()
                    else
                        local r3_4 = false

                        for r15, r16 in ipairs(r1) do
                            local r5_2 = typeof(r16) == "string" and r16 or r16.Name

                            if r5_2 == r2_2 then
                                u955.Text = r5_2
                                u864._config._flags[u945.flag] = r16
                                r3_4 = true
                                break
                            end
                        end

                        if not r3_4 then
                            if r1[1] then
                                u955.Text = typeof(r1[1]) == "string" and r1[1] or r1[1].Name
                                u864._config._flags[u945.flag] = r1[1]
                            else
                                u955.Text = "None"
                                u864._config._flags[u945.flag] = "None"
                            end
                        end

                        u960()
                    end

                    u867:save(u796.GameId, u864._config)
                    u958.Size = u821.fromOffset(207, r0._size)

                    if u901._state then
                        u832:Create(u904, TweenInfo.new(0.4, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                            Size = u821.new(1, -8, 0, 93 + u901._size + u901._multiplier + 16)
                        }):Play()

                        u832:Create(u904.Options, TweenInfo.new(0.4, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                            Size = u821.new(1, -8, 0, u901._size + u901._multiplier)
                        }):Play()
                    end
                end

                function u946.New(r0, r1)
                    u951:Destroy()
                    r1.OrderValue = u951.LayoutOrder
                    local r0_2 = u901
                    r0_2._multiplier = r0_2._multiplier - u961
                    return u901:create_dropdown(r1)
                end

                if u945.multi_dropdown then
                    local r4_4 = u864._config._flags[u945.flag]

                    if typeof(r4_4) == "table" and #r4_4 > 0 then
                        for r4_5, r5 in ipairs(r4_4) do
                            local r16 = typeof(r5) ~= "string" and r5.Name or r5

                            if not table.find(u950, r16) then
                                table.insert(u950, r16)
                            end
                        end

                        u960()
                        u945.callback({unpack(u950)})
                    else
                        u955.Text = "None"
                    end
                elseif u864:flag_type(u945.flag, "string") then
                    u946:update(u864._config._flags[u945.flag])
                elseif u945.options[1] then
                    u955.Text = typeof(u945.options[1]) == "string" and u945.options[1] or u945.options[1].Name
                    u960()
                    u864._config._flags[u945.flag] = u945.options[1]
                    u867:save(u796.GameId, u864._config)
                    u945.callback(u945.options[1])
                end

                u948 = true

                u951.MouseButton1Click:Connect(function()
                    u946:unfold_settings()
                end)

                return u946
            end

            function u901.create_checkbox(u971, u972)
                u900 = u900 + 1
                local u970 = {_state = false}

                if u971._size == 0 then
                    u971._size = 11
                end

                u971._size = u971._size + 21
                u917()
                local r6 = u859.new("TextButton")
                r6.Text = ""
                r6.AutoButtonColor = false
                r6.BackgroundTransparency = 1
                r6.Name = "Checkbox"
                r6.Size = u821.new(0, 207, 0, 15)
                r6.BorderSizePixel = 0
                r6.Parent = u916
                r6.LayoutOrder = u900
                local r3 = u859.new("TextLabel")
                r3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r3.TextSize = 11
                r3.TextColor3 = u877.Text
                r3.TextTransparency = 0.16
                r3.Text = u972.title or ""
                r3.Size = u821.new(0, 142, 0, 13)
                r3.AnchorPoint = Vector2.new(0, 0.5)
                r3.Position = u821.new(0, 0, 0.5, 0)
                r3.BackgroundTransparency = 1
                r3.TextXAlignment = u824.TextXAlignment.Left
                r3.Parent = r6
                local u973 = u859.new("Frame")
                u973.Size = u821.fromOffset(14, 14)
                u973.Position = u821.new(1, -20, 0.5, 0)
                u973.AnchorPoint = Vector2.new(1, 0.5)
                u973.BackgroundColor3 = u877.Accent
                u973.BackgroundTransparency = 0.6
                u973.BorderSizePixel = 0
                u973.Parent = r6
                local r3_2 = u859.new("UICorner")
                r3_2.CornerRadius = u822.new(0, 4)
                r3_2.Parent = u973
                local u974 = u859.new("TextLabel")
                u974.Size = u821.new(1, 0, 1, 0)
                u974.BackgroundTransparency = 1
                u974.TextColor3 = u877.AccentSoft
                u974.TextSize = 10
                u974.Font = u824.Font.SourceSans
                u974.Text = u864._config._keybinds[u972.flag] and u864._config._keybinds[u972.flag]:gsub("Enum.KeyCode.", "") or "..."
                u974.Parent = u973

                local function u975(r0)
                    if r0 == "..." or r0 == "?" then
                        u973.Size = u821.fromOffset(14, 14)
                        return
                    end

                    local r3 = u859.new("GetTextBoundsParams")
                    r3.Text = r0
                    r3.Font = Font.fromEnum(u824.Font.SourceSans)
                    r3.Size = 10
                    r3.Width = 10000
                    local r2 = u834:GetTextBoundsAsync(r3)
                    u973.Size = u821.fromOffset(math.max(14, r2.X + 6), 14)
                end

                u975(u974.Text)
                local u976 = u859.new("Frame")
                u976.AnchorPoint = Vector2.new(1, 0.5)
                u976.BackgroundTransparency = 0.86
                u976.Position = u821.new(1, 0, 0.5, 0)
                u976.Name = "Box"
                u976.Size = u821.new(0, 15, 0, 15)
                u976.BorderSizePixel = 0
                u976.BackgroundColor3 = u877.Accent
                u976.Parent = r6
                local r3_3 = u859.new("UICorner")
                r3_3.CornerRadius = u822.new(0, 4)
                r3_3.Parent = u976
                local r3_4 = u859.new("UIStroke")
                r3_4.Color = u877.StrokeHot
                r3_4.Transparency = 0.3
                r3_4.Parent = u976
                local u977 = u859.new("Frame")
                u977.AnchorPoint = Vector2.new(0.5, 0.5)
                u977.BackgroundTransparency = 0.08
                u977.Position = u821.new(0.5, 0, 0.5, 0)
                u977.Name = "Fill"
                u977.Size = u821.fromOffset(0, 0)
                u977.BorderSizePixel = 0
                u977.BackgroundColor3 = u877.Accent
                u977.Parent = u976
                local r3_5 = u859.new("UICorner")
                r3_5.CornerRadius = u822.new(0, 3)
                r3_5.Parent = u977

                function u970.change_state(r0, r1)
                    r0._state = r1
                    u832:Create(u976, TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out), {BackgroundTransparency = r1 and 0.62 or 0.86}):Play()
                    local r7 = u832
                    local r2 = r7.Create
                    local r9 = TweenInfo.new(0.45, u824.EasingStyle.Quint, u824.EasingDirection.Out)
                    local r10 = {}

                    if r1 then
                        r1 = u821.fromOffset(9, 9)
                    end

                    if not r1 then
                        r1 = u821.fromOffset(0, 0)
                    end

                    r10.Size = r1
                    r2(r7, u977, r9, r10):Play()
                    u864._config._flags[u972.flag] = r0._state
                    u867:save(u796.GameId, u864._config)
                    u972.callback(r0._state)
                end

                if u864:flag_type(u972.flag, "boolean") then
                    u970:change_state(u864._config._flags[u972.flag])
                end

                r6.MouseButton1Click:Connect(function()
                    u970:change_state(not u970._state)
                end)

                r6.InputBegan:Connect(function(r0, r1)
                    if r1 or r0.UserInputType ~= u824.UserInputType.MouseButton3 or u864._choosing_keybind then
                        return
                    end

                    u864._choosing_keybind = true
                    local u978
                    local u979 = u830.InputBegan

                    u978 = u979:Connect(function(r0, r1)
                        if not u864.keybind_can_capture(r0, r1) then return end

                        u978:Disconnect()

                        if r0.KeyCode == u824.KeyCode.Backspace then
                            u864._config._keybinds[u972.flag] = nil
                            u867:save(u796.GameId, u864._config)
                            u974.Text = "..."
                            u975("...")
                            u863:disconnect(u972.flag .. "_keybind")
                        else
                            u864._config._keybinds[u972.flag] = tostring(r0.KeyCode)
                            u867:save(u796.GameId, u864._config)
                            u863:disconnect(u972.flag .. "_keybind")
                            u974.Text = u864._config._keybinds[u972.flag]:gsub("Enum.KeyCode%.", "")
                            u975(u974.Text)
                        end

                        u864.finish_keybind_capture()
                    end)
                end)

                u863[u972.flag .. "_keypress"] = u830.InputBegan:Connect(function(r0, r1)
                    if r1 or u864._choosing_keybind or u864.keybind_is_clear(r0) or r0.UserInputType ~= u824.UserInputType.Keyboard then
                        return
                    end

                    local r2 = u864._config._keybinds[u972.flag]

                    if r2 and tostring(r0.KeyCode) == r2 then
                        u970:change_state(not u970._state)
                    end
                end)

                return u970
            end

            function u901.create_divider(r0, r1)
                u900 = u900 + 1

                if r0._size == 0 then
                    r0._size = 11
                end

                r0._size = r0._size + 27
                u917()
                local r2 = u859.new("Frame")
                r2.Size = u821.new(0, 207, 0, 20)
                r2.BackgroundTransparency = 1
                r2.Name = "DividerRow"
                r2.Parent = u916
                r2.LayoutOrder = u900

                if r1 and r1.showtopic then
                    local r3 = u859.new("TextLabel")
                    r3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                    r3.TextColor3 = u820.fromRGB(235, 234, 239)
                    r3.TextTransparency = 0.2
                    r3.Text = r1.title
                    r3.Size = u821.new(0, 153, 0, 13)
                    r3.Position = u821.new(0.5, 0, 0.501, 0)
                    r3.BackgroundTransparency = 1
                    r3.TextXAlignment = u824.TextXAlignment.Center
                    r3.AnchorPoint = Vector2.new(0.5, 0.5)
                    r3.TextSize = 11
                    r3.ZIndex = 3
                    r3.TextStrokeTransparency = 0
                    r3.Parent = r2
                end

                local r3_2 = not r1

                if r3_2 then
                    r1 = r3_2
                elseif r1 then
                    r1 = not r1.disableline
                end

                if r1 then
                    local r3_3 = u859.new("Frame")
                    r3_3.Size = u821.new(1, 0, 0, 1)
                    r3_3.BackgroundColor3 = u820.fromRGB(235, 234, 239)
                    r3_3.BorderSizePixel = 0
                    r3_3.ZIndex = 2
                    r3_3.BackgroundTransparency = 0.55
                    r3_3.Position = u821.new(0, 0, 0.5, -0.5)
                    r3_3.Parent = r2
                    local r2_2 = u859.new("UICorner")
                    r2_2.CornerRadius = u822.new(0, 2)
                    r2_2.Parent = r3_3
                    local r2_3 = u859.new("UIGradient")

                    r2_3.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.5, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    })

                    r2_3.Parent = r3_3
                end

                return true
            end

            function u901.create_textbox(r0, u981)
                u900 = u900 + 1

                if r0._size == 0 then
                    r0._size = 11
                end

                r0._size = r0._size + 45
                u917()
                local r2 = u859.new("TextLabel")
                r2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r2.TextColor3 = u877.Text
                r2.TextTransparency = 0.16
                r2.Text = u981.title or "Textbox"
                r2.Size = u821.new(0, 207, 0, 13)
                r2.BackgroundTransparency = 1
                r2.TextXAlignment = u824.TextXAlignment.Left
                r2.TextSize = 10
                r2.Parent = u916
                r2.LayoutOrder = u900
                local u982 = u859.new("TextBox")
                u982.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", u824.FontWeight.Regular)
                u982.TextColor3 = u877.Text
                u982.PlaceholderText = u981.placeholder or "Enter text..."
                u982.PlaceholderColor3 = u877.SubText
                u982.Text = u864._config._flags[u981.flag] or ""
                u982.Name = "Textbox"
                u982.Size = u821.new(0, 207, 0, 20)
                u982.BorderSizePixel = 0
                u982.TextSize = 11
                u982.BackgroundColor3 = u820.fromRGB(21, 20, 25)
                u982.BackgroundTransparency = 0
                u982.ClearTextOnFocus = false
                u982.Parent = u916
                u982.LayoutOrder = u900
                local r2_2 = u859.new("UICorner")
                r2_2.CornerRadius = u822.new(0, 5)
                r2_2.Parent = u982
                local r2_3 = u859.new("UIStroke")
                r2_3.Color = u877.Accent
                r2_3.Transparency = 0.55
                r2_3.Parent = u982
                local r2_4 = u859.new("UIPadding")
                r2_4.PaddingLeft = u822.new(0, 7)
                r2_4.Parent = u982

                u982.Focused:Connect(function()
                    u832:Create(u982:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Transparency = 0.1}):Play()
                end)

                u982.FocusLost:Connect(function()
                    u832:Create(u982:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Transparency = 0.55}):Play()
                end)

                local u983 = {
                    _text = "",
                    update_text = function(r0, r1)
                        r0._text = r1
                        u864._config._flags[u981.flag] = r1
                        u867:save(u796.GameId, u864._config)
                        u981.callback(r1)
                    end
                }

                if u864:flag_type(u981.flag, "string") then
                    u983:update_text(u864._config._flags[u981.flag])
                end

                u982.FocusLost:Connect(function()
                    u832:Create(u982:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Transparency = 0.55}):Play()
                    u983:update_text(u982.Text)
                end)

                return u983
            end

            function u901.create_paragraph(r0, r1)
                u900 = u900 + 1

                if r0._size == 0 then
                    r0._size = 11
                end

                r0._size = r0._size + (r1.customScale or 70)
                u917()
                local u984 = u859.new("Frame")
                u984.BackgroundColor3 = u877.CardDeep
                u984.BackgroundTransparency = 0.15
                u984.Size = u821.new(1, -16, 0, 30)
                u984.BorderSizePixel = 0
                u984.Name = "Paragraph"
                u984.AutomaticSize = u824.AutomaticSize.Y
                u984.Parent = u916
                u984.LayoutOrder = u900
                local r4 = u859.new("UICorner")
                r4.CornerRadius = u822.new(0, 6)
                r4.Parent = u984
                local r4_2 = u859.new("UIStroke")
                r4_2.Color = u877.Stroke
                r4_2.Transparency = 0.25
                r4_2.Parent = u984
                local r4_3 = u859.new("TextLabel")
                r4_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
                r4_3.TextColor3 = u877.Text
                r4_3.TextTransparency = 0.08
                r4_3.Text = r1.title or "Title"
                r4_3.Size = u821.new(1, -10, 0, 20)
                r4_3.Position = u821.new(0, 5, 0, 5)
                r4_3.BackgroundTransparency = 1
                r4_3.TextXAlignment = u824.TextXAlignment.Left
                r4_3.TextSize = 12
                r4_3.AutomaticSize = u824.AutomaticSize.XY
                r4_3.Parent = u984
                local r4_4 = u859.new("TextLabel")
                r4_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Regular)
                r4_4.TextColor3 = u877.SubText
                local r6 = not r1.rich

                if r6 then
                    r6 = r1.text or ""
                elseif not r6 then
                    r6 = nil
                end

                r4_4.Text = r6

                if r1.rich then
                    r4_4.RichText = true
                    r4_4.Text = r1.richtext or ""
                end

                r4_4.Size = u821.new(1, -10, 0, 20)
                r4_4.Position = u821.new(0, 5, 0, 30)
                r4_4.BackgroundTransparency = 1

                r4_4.TextXAlignment = u824.TextXAlignment.Left
                r4_4.TextYAlignment = u824.TextYAlignment.Top
                r4_4.TextSize = 11
                r4_4.TextWrapped = true
                r4_4.AutomaticSize = u824.AutomaticSize.XY
                r4_4.Parent = u984

                u984.MouseEnter:Connect(function()
                    u832:Create(u984, TweenInfo.new(0.25, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        BackgroundColor3 = u820.fromRGB(21, 20, 25),
                        BackgroundTransparency = 0.08
                    }):Play()
                end)

                u984.MouseLeave:Connect(function()
                    u832:Create(u984, TweenInfo.new(0.25, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        BackgroundColor3 = u877.CardDeep,
                        BackgroundTransparency = 0.15
                    }):Play()
                end)

                return {}
            end

            function u901.create_text(r0, r1)
                u900 = u900 + 1

                if r0._size == 0 then
                    r0._size = 11
                end

                r0._size = r0._size + (r1.customScale or 50)
                u917()
                local u985 = u859.new("Frame")
                u985.BackgroundColor3 = u877.CardDeep
                u985.BackgroundTransparency = 0.15
                u985.Size = u821.new(0, 207, 0, r1.CustomYSize or 20)
                u985.BorderSizePixel = 0
                u985.Name = "Text"
                u985.AutomaticSize = u824.AutomaticSize.Y
                u985.Parent = u916
                u985.LayoutOrder = u900
                local r4 = u859.new("UICorner")
                r4.CornerRadius = u822.new(0, 6)
                r4.Parent = u985
                local r4_2 = u859.new("UIStroke")
                r4_2.Color = u877.Stroke
                r4_2.Transparency = 0.25
                r4_2.Parent = u985
                local u986 = u859.new("TextLabel")
                u986.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Regular)
                u986.TextColor3 = u877.SubText
                local r7 = not r1.rich and (r1.text or "")

                if not r7 then
                    r7 = nil
                end

                u986.Text = r7

                if r1.rich then
                    u986.RichText = true
                    u986.Text = r1.richtext or ""
                end

                u986.Size = u821.new(1, -10, 1, 0)
                u986.Position = u821.new(0, 5, 0, 5)
                u986.BackgroundTransparency = 1
                u986.TextXAlignment = u824.TextXAlignment.Left
                u986.TextYAlignment = u824.TextYAlignment.Top
                u986.TextSize = 10
                u986.TextWrapped = true
                u986.AutomaticSize = u824.AutomaticSize.XY
                u986.Parent = u985

                u985.MouseEnter:Connect(function()
                    u832:Create(u985, TweenInfo.new(0.25, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        BackgroundColor3 = u820.fromRGB(21, 20, 25),
                        BackgroundTransparency = 0.08
                    }):Play()
                end)

                u985.MouseLeave:Connect(function()
                    u832:Create(u985, TweenInfo.new(0.25, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        BackgroundColor3 = u877.CardDeep,
                        BackgroundTransparency = 0.15
                    }):Play()
                end)

                return {
                    Set = function(r0, r1)
                        local r3 = u986
                        local r4 = not r1.rich
                        local r5

                        if r4 then
                            r4 = r1.text

                            if r4 then
                                r5 = r4
                            else
                                r4 = ""
                                r5 = r4
                            end
                        else
                            r5 = r4 or nil
                        end

                        r3.Text = r5

                        if r1.rich then
                            u986.RichText = true
                            u986.Text = r1.richtext or ""
                        end
                    end
                }
            end

            function u901.create_feature(r0, u987)
                u900 = u900 + 1
                local r8 = false

                if r0._size == 0 then
                    r0._size = 11
                end

                r0._size = r0._size + 20
                u917()
                local r9 = u859.new("Frame")
                r9.Size = u821.new(0, 207, 0, 16)
                r9.BackgroundTransparency = 1
                r9.Parent = u916
                r9.LayoutOrder = u900
                local r3 = u859.new("UIListLayout")
                r3.FillDirection = u824.FillDirection.Horizontal
                r3.SortOrder = u824.SortOrder.LayoutOrder
                r3.Parent = r9
                local r10 = u859.new("TextButton")
                r10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r10.TextSize = 11
                r10.Size = u821.new(1, -50, 0, 16)
                r10.BackgroundColor3 = u877.CardDeep
                r10.BackgroundTransparency = 0.38
                r10.TextColor3 = u877.Text
                r10.Text = "  " .. (u987.title or "Feature")
                r10.AutoButtonColor = false
                r10.TextXAlignment = u824.TextXAlignment.Left
                r10.TextTransparency = 0.12
                r10.Parent = r9
                local r3_2 = u859.new("UICorner")
                r3_2.CornerRadius = u822.new(0, 4)
                r3_2.Parent = r10
                local r11 = u859.new("Frame")
                r11.Size = u821.new(0, 45, 0, 16)
                r11.BackgroundTransparency = 1
                r11.Parent = r9
                local r3_3 = u859.new("UIListLayout")
                r3_3.Padding = u822.new(0.1, 0)
                r3_3.FillDirection = u824.FillDirection.Horizontal
                r3_3.HorizontalAlignment = u824.HorizontalAlignment.Right
                r3_3.SortOrder = u824.SortOrder.LayoutOrder
                r3_3.Parent = r11
                local u988 = u859.new("TextLabel")
                u988.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                u988.Size = u821.new(0, 15, 0, 15)
                u988.BackgroundColor3 = u877.Accent
                u988.TextColor3 = u877.AccentSoft
                u988.TextSize = 11
                u988.BackgroundTransparency = 0.62
                u988.LayoutOrder = 2
                u988.Parent = r11
                local r3_4 = u859.new("UICorner")
                r3_4.CornerRadius = u822.new(0, 3)
                r3_4.Parent = u988
                local r3_5 = u859.new("UIStroke")
                r3_5.Color = u877.Accent
                r3_5.Transparency = 0.4
                r3_5.Thickness = 1
                r3_5.ApplyStrokeMode = u824.ApplyStrokeMode.Border
                r3_5.Parent = u988
                local r13 = u859.new("TextButton")
                r13.Size = u821.new(1, 0, 1, 0)
                r13.BackgroundTransparency = 1
                r13.TextTransparency = 1
                r13.Parent = u988

                if not u864._config._flags then
                    u864._config._flags = {}
                end

                if not u864._config._flags[u987.flag] then
                    u864._config._flags[u987.flag] = {checked = false, BIND = u987.default or "Unknown"}
                end

                 
                if u987.momentary then u864._config._flags[u987.flag].checked = false end
                local u989 = u864._config._flags[u987.flag].checked
                u988.Text = u864._config._flags[u987.flag].BIND == "Unknown" and "..." or u864._config._flags[u987.flag].BIND
                local u991

                if not u987.disablecheck then
                    local u990 = u859.new("TextButton")
                    u990.Size = u821.new(0, 15, 0, 15)
                    u990.BackgroundColor3 = u989 and u877.Accent or u877.CardDeep
                    u990.BackgroundTransparency = u989 and 0.32 or 0.5
                    u990.Text = ""
                    u990.LayoutOrder = 1
                    u990.Parent = r11
                    local r3_6 = u859.new("UICorner")
                    r3_6.CornerRadius = u822.new(0, 3)
                    r3_6.Parent = u990
                    local r3_7 = u859.new("UIStroke")
                    r3_7.Color = u877.Accent
                    r3_7.Transparency = 0.35
                    r3_7.Thickness = 1
                    r3_7.ApplyStrokeMode = u824.ApplyStrokeMode.Border
                    r3_7.Parent = u990

                    function u991()
                        if u987.momentary then
                            u832:Create(u990, TweenInfo.new(0.12), {
                                BackgroundColor3 = u877.Accent, BackgroundTransparency = 0.32
                            }):Play()
                            task.delay(0.15, function()
                                if u990.Parent then
                                    u832:Create(u990, TweenInfo.new(0.18), {
                                        BackgroundColor3 = u877.CardDeep, BackgroundTransparency = 0.5
                                    }):Play()
                                end
                            end)
                            if u987.button_callback then u987.button_callback() end
                            return
                        end
                        u989 = not u989

                        u832:Create(u990, TweenInfo.new(0.3), {
                            BackgroundColor3 = u989 and u877.Accent or u877.CardDeep,
                            BackgroundTransparency = u989 and 0.32 or 0.5
                        }):Play()

                        u864._config._flags[u987.flag].checked = u989
                        u867:save(u796.GameId, u864._config)

                        if u987.callback then
                            u987.callback(u989)
                        end
                    end

                    u990.MouseButton1Click:Connect(u991)
                else
                    function u991()
                        if u987.button_callback then
                            u987.button_callback()
                        end
                    end
                end

                r13.MouseButton1Click:Connect(function()
                    if u864._choosing_keybind then return end
                    u864._choosing_keybind = true
                    u988.Text = "..."
                    u863:disconnect("feat_keybind_input_" .. u987.flag)
                    local u992
                    u992 = u830.InputBegan:Connect(function(input, processed)
                        local clear = u864.keybind_is_clear(input)
                        local middle = input.UserInputType == u824.UserInputType.MouseButton3 and not processed
                        if not clear and not middle and not u864.keybind_can_capture(input, processed) then return end
                        local name = (clear or middle) and "Unknown" or input.KeyCode.Name
                        u864._config._flags[u987.flag].BIND = name
                        u988.Text = name == "Unknown" and "..." or name
                        u867:save(u796.GameId, u864._config)
                        u992:Disconnect()
                        u863["feat_keybind_input_" .. u987.flag] = nil
                        u864.finish_keybind_capture()
                    end)
                    u863["feat_keybind_input_" .. u987.flag] = u992
                end)

                u863["feat_keybind_press_" .. u987.flag] = u830.InputBegan:Connect(function(input, processed)
                    if processed or u864._choosing_keybind or u864.keybind_is_clear(input)
                        or input.UserInputType ~= u824.UserInputType.Keyboard then return end
                    if input.KeyCode.Name == u864._config._flags[u987.flag].BIND then u991() end
                end)

                r10.MouseButton1Click:Connect(function()
                    if u987.button_callback then
                        u987.button_callback()
                    end
                end)

                if not u987.disablecheck and not u987.momentary and u987.callback then
                    u987.callback(u989)
                end

                return r9
            end

            function u901.create_colorpicker(u995, u994)
                u900 = u900 + 1
                local u993 = {_h = 0, _s = 1, _v = 1}

                if u864._config._flags[u994.flag] then
                    local r3 = u864._config._flags[u994.flag]

                    if type(r3) == "table" and r3.H ~= nil then
                        local r9 = r3.H
                        local r10 = r3.S
                        r3 = r3.V
                        u993._h = r9
                        u993._s = r10
                        u993._v = r3
                    end
                elseif u994.color then
                    local r12, r13, r14 = u820.toHSV(u994.color)
                    u993._h = r12
                    u993._s = r13
                    u993._v = r14
                end

                if u995._size == 0 then
                    u995._size = 11
                end

                u995._size = u995._size + 32
                u917()
                local r9_2 = u859.new("TextButton")
                r9_2.Size = u821.new(0, 207, 0, 20)
                r9_2.BackgroundTransparency = 1
                r9_2.Text = ""
                r9_2.AutoButtonColor = false
                r9_2.Parent = u916
                r9_2.LayoutOrder = u900
                local r10_2 = u859.new("TextLabel")
                r10_2.Text = u994.title or "Color"
                r10_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
                r10_2.TextSize = 11
                r10_2.TextColor3 = u877.Text
                r10_2.TextTransparency = 0.16
                r10_2.BackgroundTransparency = 1
                r10_2.Size = u821.new(0, 150, 1, 0)
                r10_2.TextXAlignment = u824.TextXAlignment.Left
                r10_2.Parent = r9_2
                local u996 = u859.new("Frame")
                u996.Size = u821.new(0, 44, 0, 14)
                u996.AnchorPoint = Vector2.new(1, 0.5)
                u996.Position = u821.new(1, 0, 0.5, 0)
                u996.BorderSizePixel = 0
                u996.BackgroundColor3 = u820.fromHSV(u993._h, u993._s, u993._v)
                u996.Parent = r9_2
                local r3_2 = u859.new("UICorner")
                r3_2.CornerRadius = u822.new(0, 5)
                r3_2.Parent = u996
                local r3_3 = u859.new("UIStroke")
                r3_3.Color = u877.StrokeHot
                r3_3.Transparency = 0.38
                r3_3.Parent = u996
                local u997 = u859.new("TextLabel")
                u997.Text = "›"
                u997.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
                u997.TextSize = 14
                u997.TextColor3 = u877.Accent
                u997.BackgroundTransparency = 1
                u997.Size = u821.new(0, 12, 1, 0)
                u997.AnchorPoint = Vector2.new(1, 0.5)
                u997.Position = u821.new(1, -50, 0.5, 0)
                u997.Rotation = 90
                u997.Parent = r9_2
                local u998 = u859.new("Frame")
                u998.Size = u821.new(0, 207, 0, 0)
                u998.BackgroundTransparency = 1
                u998.ClipsDescendants = true
                u998.BorderSizePixel = 0
                u998.Parent = u916
                u998.LayoutOrder = u900
                local u999 = u859.new("Frame")
                u999.Size = u821.new(1, 0, 0, 62)
                u999.Position = u821.new(0, 0, 0, 4)
                u999.BorderSizePixel = 0
                u999.BackgroundColor3 = u820.fromHSV(u993._h, 1, 1)
                u999.ClipsDescendants = true
                u999.Parent = u998
                local r3_4 = u859.new("UICorner")
                r3_4.CornerRadius = u822.new(0, 7)
                r3_4.Parent = u999
                local r3_5 = u859.new("Frame")
                r3_5.Size = u821.new(1, 0, 1, 0)
                r3_5.BackgroundColor3 = u820.new(1, 1, 1)
                r3_5.BorderSizePixel = 0
                r3_5.ZIndex = 2
                r3_5.Parent = u999
                local r4 = u859.new("UIGradient")
                r4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
                r4.Parent = r3_5
                local r3_6 = u859.new("Frame")
                r3_6.Size = u821.new(1, 0, 1, 0)
                r3_6.BackgroundColor3 = u820.new(0, 0, 0)
                r3_6.BorderSizePixel = 0
                r3_6.ZIndex = 3
                r3_6.Parent = u999
                local r4_2 = u859.new("UIGradient")
                r4_2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
                r4_2.Rotation = 90
                r4_2.Parent = r3_6
                local u1000 = u859.new("Frame")
                u1000.Size = u821.new(0, 12, 0, 12)
                u1000.AnchorPoint = Vector2.new(0.5, 0.5)
                u1000.BackgroundColor3 = u820.fromRGB(0, 0, 0)
                u1000.BorderSizePixel = 0
                u1000.ZIndex = 5
                u1000.Visible = false
                u1000.Position = u821.new(u993._s, 0, 1 - u993._v, 0)
                u1000.Parent = u999
                local r3_7 = u859.new("UICorner")
                r3_7.CornerRadius = u822.new(1, 0)

                r3_7.Parent = u1000
                local r3_8 = u859.new("Frame")
                r3_8.Size = u821.new(0, 8, 0, 8)
                r3_8.AnchorPoint = Vector2.new(0.5, 0.5)
                r3_8.Position = u821.new(0.5, 0, 0.5, 0)
                r3_8.BackgroundColor3 = u820.new(1, 1, 1)
                r3_8.BorderSizePixel = 0
                r3_8.ZIndex = 6
                r3_8.Parent = u1000
                local r4_3 = u859.new("UICorner")
                r4_3.CornerRadius = u822.new(1, 0)
                r4_3.Parent = r3_8
                local u1001 = u859.new("Frame")
                u1001.Size = u821.new(1, 0, 0, 12)
                u1001.Position = u821.new(0, 0, 0, 72)
                u1001.BorderSizePixel = 0
                u1001.BackgroundColor3 = u820.new(1, 1, 1)
                u1001.Parent = u998
                local r3_9 = u859.new("UICorner")
                r3_9.CornerRadius = u822.new(0, 5)
                r3_9.Parent = u1001
                local r28 = u859.new("UIGradient")

                r28.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, u820.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.167, u820.fromHSV(0.167, 1, 1)),
                    ColorSequenceKeypoint.new(0.333, u820.fromHSV(0.333, 1, 1)),
                    ColorSequenceKeypoint.new(0.5, u820.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, u820.fromHSV(0.667, 1, 1)),
                    ColorSequenceKeypoint.new(0.833, u820.fromHSV(0.833, 1, 1)),
                    ColorSequenceKeypoint.new(1, u820.fromHSV(0, 1, 1))
                })

                r28.Parent = u1001
                local u1002 = u859.new("Frame")
                u1002.Size = u821.new(0, 6, 1, 4)
                u1002.AnchorPoint = Vector2.new(0.5, 0.5)
                u1002.Position = u821.new(u993._h, 0, 0.5, 0)
                u1002.BackgroundColor3 = u820.fromRGB(0, 0, 0)
                u1002.BorderSizePixel = 0
                u1002.ZIndex = 4
                u1002.Visible = false
                u1002.Parent = u1001
                local r3_10 = u859.new("UICorner")
                r3_10.CornerRadius = u822.new(0, 3)
                r3_10.Parent = u1002
                local r3_11 = u859.new("Frame")
                r3_11.Size = u821.new(0, 4, 1, 0)
                r3_11.AnchorPoint = Vector2.new(0.5, 0.5)
                r3_11.Position = u821.new(0.5, 0, 0.5, 0)
                r3_11.BackgroundColor3 = u820.new(1, 1, 1)
                r3_11.BorderSizePixel = 0
                r3_11.ZIndex = 5
                r3_11.Parent = u1002
                local r5 = u859.new("UICorner")
                r5.CornerRadius = u822.new(0, 2)
                r5.Parent = r3_11

                local function u1003()

                    return u820.fromHSV(u993._h, u993._s, u993._v)
                end

                local function u1004()
                    u996.BackgroundColor3 = u1003()
                    u999.BackgroundColor3 = u820.fromHSV(u993._h, 1, 1)
                    u1000.Position = u821.new(u993._s, 0, 1 - u993._v, 0)
                    u1002.Position = u821.new(u993._h, 0, 0.5, 0)
                end

                local function u1005()
                    u864._config._flags[u994.flag] = {H = u993._h, S = u993._s, V = u993._v}
                    u867:save(u796.GameId, u864._config)

                    if u994.callback then
                        u994.callback(u1003())
                    end
                end

                local u1006 = false
                local u1007 = false

                u999.InputBegan:Connect(function(r0)
                    if r0.UserInputType == u824.UserInputType.MouseButton1 then
                        u1006 = true
                        u864._blocking_drag = true
                    end
                end)

                u1001.InputBegan:Connect(function(r0)
                    if r0.UserInputType == u824.UserInputType.MouseButton1 then
                        u1007 = true
                        u864._blocking_drag = true
                    end
                end)

                u863["cp_moved_" .. u994.flag] = u830.InputChanged:Connect(function(r0)
                    if r0.UserInputType ~= u824.UserInputType.MouseMovement then
                        return
                    end

                    if u1006 then
                        u993._s = math.clamp((r0.Position.X - u999.AbsolutePosition.X) / u999.AbsoluteSize.X, 0, 1)
                        u993._v = 1 - math.clamp((r0.Position.Y - u999.AbsolutePosition.Y) / u999.AbsoluteSize.Y, 0, 1)
                        u1004()

                        if u994.callback then
                            u994.callback(u820.fromHSV(u993._h, u993._s, u993._v))
                        end
                    end

                    if not u1007 then
                        return
                    end

                    u993._h = math.clamp((r0.Position.X - u1001.AbsolutePosition.X) / u1001.AbsoluteSize.X, 0, 1)
                    u1004()

                    if u994.callback then
                        u994.callback(u820.fromHSV(u993._h, u993._s, u993._v))
                    end
                end)

                u863["cp_ended_" .. u994.flag] = u830.InputEnded:Connect(function(r0)
                    if r0.UserInputType ~= u824.UserInputType.MouseButton1 then
                        return
                    end

                    local r2 = u1006
                    local r3

                    if u1006 then
                        r3 = r2
                    else
                        r3 = u1007
                    end

                    if r3 then
                        u1006 = false
                        u1007 = false
                        u864._blocking_drag = false
                        u1005()
                    end
                end)

                local u1008 = false

                r9_2.MouseButton1Click:Connect(function()
                    u1008 = not u1008
                    u1000.Visible = u1008
                    u1002.Visible = u1008
                    u995._size = u1008 and u995._size + 90 or u995._size - 90

                    u832:Create(u998, TweenInfo.new(0.35, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                        Size = u821.new(0, 207, 0, u1008 and 90 or 0)
                    }):Play()

                    u832:Create(u997, TweenInfo.new(0.3), {Rotation = u1008 and -90 or 90}):Play()

                    if u901._state then
                        u904.Size = u821.new(1, -8, 0, 93 + u995._size + u995._multiplier + 16)
                    end

                    u916.Size = u821.new(1, -8, 0, u995._size + u995._multiplier)
                end)

                u1004()

                if u994.callback then
                    u994.callback(u1003())
                end

                function u993.Set(r0, r1)
                    local r278, r279, r280 = u820.toHSV(r1)
                    r0._h = r278
                    r0._s = r279
                    r0._v = r280
                    u1004()
                    u1005()
                end

                return u993
            end

            return u901
        end

        r7._left = u898
        r7._right = u899
        return r7
    end

    local function u1009(r0, r1, r2)
        return u820.new(r0.R + (r1.R - r0.R) * r2, r0.G + (r1.G - r0.G) * r2, r0.B + (r1.B - r0.B) * r2)
    end

    local function u1010()
        local r34 = u861.Colors

        for r2, r3 in ipairs(u864._all_modules) do
            local r10 = r3.frame
            r10.BackgroundColor3 = r34.Card
            local r31 = r10:FindFirstChildOfClass("UIStroke")

            if r31 then
                if r10:GetAttribute("pinned") == true then
                    r31.Color = r34.Accent
                    r31.Transparency = 0.55
                elseif r10:GetAttribute("expanded") == true then
                    r31.Color = r34.Accent
                    r31.Transparency = 0.68
                else
                    r31.Color = r34.Stroke
                    r31.Transparency = 0.32
                end
            end

            local r11 = r10:FindFirstChild("Header")

            if r11 then
                r11.BackgroundColor3 = r34.CardDeep
                local r4 = r3.manager
                local r8 = r4 and r4._accent_bar

                if r8 then
                    if r4._ab_tween then
                        r4._ab_tween:Cancel()
                        r4._ab_tween = nil
                    end

                    if r10:GetAttribute("expanded") == true then
                        r8.BackgroundColor3 = r34.Accent
                        r8.BackgroundTransparency = 0.08
                    else
                        r8.BackgroundColor3 = r34.AccentDim
                        r8.BackgroundTransparency = 0.45
                    end
                end

                local r4_2 = r11:FindFirstChild("ModuleName")

                if r4_2 then
                    r4_2.TextColor3 = r34.Text
                end

                local r4_3 = r11:FindFirstChild("Description")

                if r4_3 then
                    r4_3.TextColor3 = r34.SubText
                end

                local r4_4 = r11:FindFirstChild("Icon")

                if r4_4 and r4_4:IsA("GuiObject") then
                    r4_4.ImageColor3 = r34.AccentSoft
                end

                local r4_5 = r11:FindFirstChild("Keybind")

                if r4_5 then
                    r4_5.BackgroundColor3 = r34.Accent
                    local r31_2 = r4_5:FindFirstChildOfClass("TextLabel")

                    if r31_2 then
                        r31_2.TextColor3 = r34.AccentSoft
                    end

                    local r4_6 = r4_5:FindFirstChildOfClass("UIStroke")

                    if r4_6 then
                        r4_6.Color = r34.Accent
                    end
                end

                local r4_7 = r11:FindFirstChild("Bell")

                if r4_7 and r4_7:IsA("GuiObject") then
                    local r5 = u864._config._library[r3.flag .. "_notify"] == true
                    r4_7.ImageColor3 = r5 and r34.Accent or r34.SubText

                    if r5 then
                        r5 = 0.05
                    end

                    r4_7.ImageTransparency = r5 or 0.45
                end

                local r4_8 = r11:FindFirstChild("PinBtn")

                if r4_8 and r4_8:IsA("GuiObject") then
                    if r10:GetAttribute("pinned") == true then
                        r4_8.ImageColor3 = r34.Accent
                        r4_8.ImageTransparency = 0.08
                    else
                        r4_8.ImageColor3 = r34.SubText
                        r4_8.ImageTransparency = 0.55
                    end
                end

                local r4_9 = r11:FindFirstChild("Toggle")

                if r4_9 then
                    local r7 = r4_9.BackgroundTransparency < 0.4
                    local r24 = u820.new(math.clamp(r34.Card.R * 0.48, 0, 1), math.clamp(r34.Card.G * 0.48, 0, 1), math.clamp(r34.Card.B * 0.52, 0, 1))
                    r4_9.BackgroundColor3 = r7 and r34.Accent or r24
                    local r31_3 = r4_9:FindFirstChildOfClass("UIStroke")

                    if r31_3 then
                        r31_3.Color = r34.Stroke
                    end

                    local r4_10 = r4_9:FindFirstChild("Circle")

                    if r4_10 then
                        if r7 then
                            r7 = r34.Background
                        end

                        if not r7 then
                            r7 = r34.SubText
                        end

                        r4_10.BackgroundColor3 = r7
                    end
                end

                for r5_2, r6 in r11:GetChildren() do
                    if r6:IsA("Frame") and r6:FindFirstChildOfClass("UIGradient") then
                        r6.BackgroundColor3 = r34.CardDeep
                        break
                    end
                end

                for r8_2, r9 in r11:GetChildren() do
                    local r28 = r9:IsA("Frame")
                    local r4_11

                    if r28 then
                        local r4_12 = r9.Size.Y.Offset
                        r28 = r4_12 == 1

                        if r4_12 == 1 then
                            r4_11 = r9.Name ~= "AccentBar"
                        else
                            r4_11 = r28
                        end
                    else
                        r4_11 = r28
                    end

                    if r4_11 and r9.Name ~= "Underline" then
                        r9.BackgroundColor3 = r34.Stroke
                    end
                end
            end

            local r9_2 = r10:FindFirstChild("Options")

            if r9_2 then
                for r11_2, r12 in r9_2:GetChildren() do
                    if r12.Name == "Slider" or r12.Name == "DoubleSlider" then
                        local r5_3 = r12:FindFirstChild("Drag")

                        if r5_3 then
                            r5_3.BackgroundColor3 = r34.Stroke
                            local r4_13 = r5_3:FindFirstChild("Fill")

                            if r4_13 then
                                r4_13.BackgroundColor3 = r34.Accent
                                local r25 = r4_13:FindFirstChildOfClass("UIGradient")

                                if r25 then
                                    r25.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, r34.AccentSoft), ColorSequenceKeypoint.new(1, r34.AccentDim)})
                                end

                                local r24_2 = r4_13:FindFirstChild("Circle")

                                if r24_2 then
                                    r24_2.BackgroundColor3 = r34.AccentSoft
                                end
                            end

                            local r4_14 = r5_3:FindFirstChild("RangeFill")

                            if r4_14 then
                                r4_14.BackgroundColor3 = r34.Accent
                                local r24_3 = r4_14:FindFirstChildOfClass("UIGradient")

                                if r24_3 then
                                    r24_3.Color = ColorSequence.new({
                                        ColorSequenceKeypoint.new(0, r34.AccentSoft),
                                        ColorSequenceKeypoint.new(1, r34.AccentDim)
                                    })
                                end
                            end

                            for r23, r24_4 in ipairs({"KnobL", "KnobR"}) do
                                local r25_2 = r5_3:FindFirstChild(r24_4)

                                if r25_2 then
                                    r25_2.BackgroundColor3 = r34.AccentSoft
                                end
                            end
                        end

                        for r26, r27 in r12:GetChildren() do
                            if r27:IsA("TextLabel") then
                                r27.TextColor3 = r34.Text
                            end
                        end
                    elseif r12.Name == "Checkbox" then
                        for r14, r15 in r12:GetChildren() do
                            if r15:IsA("TextLabel") and r15.Name ~= "Value" then
                                r15.TextColor3 = r34.Text
                            end

                            if r15.Name == "Box" then
                                r15.BackgroundColor3 = r34.Accent
                                local r28_2 = r15:FindFirstChildOfClass("UIStroke")

                                if r28_2 then
                                    r28_2.Color = r34.StrokeHot
                                end
                            elseif r15.Name == "Fill" then
                                r15.BackgroundColor3 = r34.Accent
                            elseif r15.Name == "CBKey" then
                                r15.BackgroundColor3 = r34.Accent
                                local r28_3 = r15:FindFirstChildOfClass("UIStroke")

                                if r28_3 then
                                    r28_3.Color = r34.Accent
                                end
                            end
                        end
                    elseif r12.Name == "Dropdown" then
                        for r17, r18 in r12:GetDescendants() do
                            if r18:IsA("TextLabel") and r18.Text == "⇅" then
                                r18.TextColor3 = r34.Accent
                            elseif r18:IsA("TextLabel") then
                                r18.TextColor3 = r34.Text
                            elseif r18:IsA("TextButton") and (r18.Name == "Option" or r18.Name == "OptionBtn") then
                                r18.TextColor3 = r34.Text
                            elseif r18:IsA("Frame") and r18.Name == "Box" then
                                r18.BackgroundColor3 = r34.Accent
                                local r27_2 = r18:FindFirstChildOfClass("UIStroke")

                                if r27_2 then
                                    r27_2.Color = r34.StrokeHot
                                end
                            elseif r18:IsA("ImageLabel") and r18.Name == "DDIcon" then
                                r18.ImageColor3 = r34.AccentSoft
                            elseif r18:IsA("TextButton") and r18.Name == "DDSlider" then
                                for r20, r21 in r18:GetChildren() do
                                    if r21:IsA("TextLabel") then
                                        r21.TextColor3 = r34.Text
                                    end
                                end

                                local r4_15 = r18:FindFirstChild("Drag")

                                if r4_15 then
                                    r4_15.BackgroundColor3 = r34.Stroke
                                    local r5_4 = r4_15:FindFirstChild("Fill")

                                    if r5_4 then
                                        r5_4.BackgroundColor3 = r34.Accent
                                        local r6_2 = r5_4:FindFirstChildOfClass("UIGradient")

                                        if r6_2 then
                                            r6_2.Color = ColorSequence.new({
                                                ColorSequenceKeypoint.new(0, r34.AccentSoft),
                                                ColorSequenceKeypoint.new(1, r34.AccentDim)
                                            })
                                        end

                                        local r5_5 = r5_4:FindFirstChild("Circle")

                                        if r5_5 then
                                            r5_5.BackgroundColor3 = r34.AccentSoft
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                for r29, r30 in r9_2:GetDescendants() do
                    if r30:IsA("UIStroke") then
                        local r4_16 = r30.Parent

                        if r4_16 then
                            local r5_6 = r4_16.Name == "Box"
                            local r6_3

                            if r5_6 then
                                r6_3 = r5_6
                            else
                                local r6_4 = r4_16.Name
                                r5_6 = r6_4 == "Swatch"

                                if r6_4 == "Swatch" then
                                    r6_3 = r5_6
                                else
                                    local r6_5 = r4_16.Name
                                    r5_6 = r6_5 == "Keybind"

                                    if r6_5 == "Keybind" then
                                        r6_3 = r5_6
                                    else
                                        r6_3 = r4_16.Name == "CBKey"
                                    end
                                end
                            end

                            if r6_3 or r4_16.Name == "FCB" then
                                r30.Color = r34.StrokeHot
                            end
                        end
                    elseif r30:IsA("Frame") and r30.Name == "PickerBox" then
                        local r31_4 = r30:FindFirstChildOfClass("UIStroke")

                        if r31_4 then
                            r31_4.Color = r34.StrokeHot
                        end
                    elseif r30:IsA("TextLabel") and r30.Name == "PickerArrow" then
                        r30.TextColor3 = r34.Accent
                    elseif r30:IsA("TextLabel") and r30.Parent and r30.Parent.Name == "Row" then
                        r30.TextColor3 = r34.Text
                    end
                end
            end
        end
    end

    function u876.apply_gui_theme_fast(u1011)
        task.defer(function()
            local r7 = u861.Colors

            if u1011._theme_container then
                u1011._theme_container.BackgroundColor3 = r7.Background
            end

            if u1011._theme_container_stroke then
                u1011._theme_container_stroke.Color = r7.StrokeHot
            end

            if u1011._theme_search then
                u1011._theme_search.BackgroundColor3 = r7.CardDeep
            end

            if u1011._theme_client_grad then
                u1011._theme_client_grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, r7.Accent),
                    ColorSequenceKeypoint.new(0.42, r7.Accent),
                    ColorSequenceKeypoint.new(1, r7.Accent)
                })
            end

            if u1011._theme_pin then
                u1011._theme_pin.BackgroundColor3 = r7.Accent
            end

            if u1011._theme_logo then
                u1011._theme_logo.ImageColor3 = r7.AccentSoft
            end

            local r1 = u1011._theme_tabs_ref

            if r1 then
                for r1_2, r2 in r1:GetChildren() do
                    if r2.Name == "Tab" then
                        local r3 = r2:FindFirstChild("Indicator")

                        if r3 then
                            r3.BackgroundColor3 = r7.Accent
                        end
                    end
                end
            end

            if u1011._active_tab_ref then
                u1011:update_tabs(u1011._active_tab_ref, false)
            end
        end)
    end

    function u876.apply_gui_theme_fast(u1012)
        task.defer(function()
            local r7 = u861.Colors

            if u1012._theme_container then
                u1012._theme_container.BackgroundColor3 = r7.Background
            end

            if u1012._theme_container_stroke then
                u1012._theme_container_stroke.Color = r7.StrokeHot
            end

            if u1012._theme_search then
                u1012._theme_search.BackgroundColor3 = r7.CardDeep
            end

            if u1012._theme_client_grad then
                u1012._theme_client_grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, r7.Accent),
                    ColorSequenceKeypoint.new(0.42, r7.Accent),
                    ColorSequenceKeypoint.new(1, r7.Accent)
                })
            end

            if u1012._theme_pin then
                u1012._theme_pin.BackgroundColor3 = r7.Accent
            end

            if u1012._theme_logo then
                u1012._theme_logo.ImageColor3 = r7.AccentSoft
            end

            local r1 = u1012._theme_tabs_ref

            if r1 then
                for r1_2, r2 in r1:GetChildren() do
                    if not (r2.Name ~= "Tab") then
                        local r3 = r2:FindFirstChild("Indicator")

                        if r3 then
                            r3.BackgroundColor3 = r7.Accent
                        end
                    end
                end
            end

            if u1012._active_tab_ref then
                u1012:update_tabs(u1012._active_tab_ref, false)
            end
        end)
    end

    function u876.apply_gui_theme(u1013)
        if u1013._theme_debounce then
            u1013._theme_debounce:Disconnect()
            u1013._theme_debounce = nil
        end

        u1013._theme_pending = true

        u1013._theme_debounce = task.delay(0.05, function()
            u1013._theme_debounce = nil

            if not u1013._theme_pending then
                return
            end

            u1013._theme_pending = false

            if u1013._applying_theme then
                return
            end

            u1013._applying_theme = true
            local r28 = u861.Colors
            local r0 = u864._config._gui

            if u1013._theme_container then
                u1013._theme_container.BackgroundColor3 = r28.Background

                if r0 and r0.bg_transparency ~= nil then
                    u1013._theme_container.BackgroundTransparency = r0.bg_transparency
                end
            end

            if u1013._theme_container_stroke then
                u1013._theme_container_stroke.Color = r28.StrokeHot
            end

            if u1013._theme_vert_div then
                u1013._theme_vert_div.BackgroundColor3 = r28.Stroke
            end

            if u1013._theme_search then
                u1013._theme_search.BackgroundColor3 = r28.CardDeep
            end

            if u1013._theme_search_stroke then
                u1013._theme_search_stroke.Color = r28.StrokeHot
            end

            if u1013._theme_search_icon then
                u1013._theme_search_icon.ImageColor3 = r28.Accent
            end

            if u1013._theme_search_box then
                u1013._theme_search_box.PlaceholderColor3 = r28.SubText
                u1013._theme_search_box.TextColor3 = r28.Text
            end

            if u1013._theme_client_name then
                u1013._theme_client_name.TextColor3 = r28.Accent
            end

            if u1013._theme_client_grad then
                u1013._theme_client_grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, r28.Accent),
                    ColorSequenceKeypoint.new(0.42, r28.Accent),
                    ColorSequenceKeypoint.new(1, r28.Accent)
                })
            end

            if u1013._theme_pin then
                u1013._theme_pin.BackgroundColor3 = r28.Accent
            end

            if u1013._theme_logo then
                u1013._theme_logo.ImageColor3 = r28.AccentSoft
            end

            local r5 = u1013._theme_tabs_ref

            if r5 then
                for r1, r2 in r5:GetChildren() do
                    if r2.Name == "Tab" then
                        local r12 = r2:FindFirstChild("Indicator")

                        if r12 then
                            r12.BackgroundColor3 = r28.Accent
                        end

                        local r3 = r2:FindFirstChildOfClass("TextLabel")

                        if r3 then
                            local r11 = r3:FindFirstChildOfClass("UIGradient")

                            if r11 then
                                r11.Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, r28.Text),
                                    ColorSequenceKeypoint.new(0.65, u1009(r28.Text, r28.SubText, 0.45)),
                                    ColorSequenceKeypoint.new(1, u1009(r28.Text, r28.SubText, 0.78))
                                })
                            end
                        end

                        local r3_2 = r2:FindFirstChild("Icon")

                        if r3_2 and r3_2:IsA("GuiObject") then
                            r3_2.ImageColor3 = r2 == u1013._active_tab_ref and r28.Accent or r28.Text
                        end
                    end
                end
            end

            if u1013._gui_tr then
                local r1_2 = u1013._gui_tr

                if r1_2.drag then
                    r1_2.drag.BackgroundColor3 = r28.Stroke
                end

                if r1_2.fill then
                    r1_2.fill.BackgroundColor3 = r28.Accent
                    local r20 = r1_2.fill:FindFirstChildOfClass("UIGradient")

                    if r20 then
                        r20.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, r28.AccentSoft), ColorSequenceKeypoint.new(1, r28.AccentDim)})
                    end
                end

                if r1_2.circle then
                    r1_2.circle.BackgroundColor3 = r28.AccentSoft
                end

                if r1_2.title then
                    r1_2.title.TextColor3 = r28.Text
                end

                if r1_2.val then
                    r1_2.val.TextColor3 = r28.Text
                end
            end

            if u1013._gui_sections then
                for r4, r5_2 in ipairs(u1013._gui_sections) do
                    for r7, r8 in r5_2:GetDescendants() do
                        if r8:IsA("TextLabel") then
                            if r8:GetAttribute("GUICardHead") then
                                r8.TextColor3 = r28.AccentSoft
                            elseif r8.Name == "Value" then
                                r8.TextColor3 = r28.Text
                            elseif r8.Text == "›" then
                                r8.TextColor3 = r28.Accent
                            elseif r8.Parent and r8.Parent.Name == "resetBtn" then
                                r8.TextColor3 = r28.AccentSoft
                            else
                                r8.TextColor3 = r28.Text
                            end
                        end
                    end
                end
            end

            local r332 = u880:GetChildren()

            for r10, r11_2 in ipairs(r332) do
                if r11_2.Name == "ThemeDivider" then
                    r11_2.BackgroundColor3 = r28.Stroke
                end
            end

            local r330 = u880:GetDescendants()

            for r13, r14 in ipairs(r330) do
                if r14.Name == "GUICard" then
                    local r24 = r14:FindFirstChildOfClass("UIStroke")

                    if r24 then
                        r24.Color = r28.Stroke
                    end

                    r14.BackgroundColor3 = r28.Card
                end
            end

            u1010()

            if u1013._active_tab_ref then
                u1013:update_tabs(u1013._active_tab_ref, false)
            end

            if u1013._gui_reset_btn then
                local r0_2 = u1013._gui_reset_btn

                if r0_2.btn then
                    r0_2.btn.BackgroundColor3 = r28.CardDeep
                end

                if r0_2.stroke then
                    r0_2.stroke.Color = r28.StrokeHot
                end

                if r0_2.lbl then
                    r0_2.lbl.TextColor3 = r28.AccentSoft
                end
            end

            if u1013._gui_hide_toggle then
                local r1_3 = u1013._gui_hide_toggle
                local r2_2 = u864._config._gui.hide_minimized == true
                local r20_2 = u820.new(math.clamp(r28.Card.R * 0.48, 0, 1), math.clamp(r28.Card.G * 0.48, 0, 1), math.clamp(r28.Card.B * 0.52, 0, 1))

                if r1_3.toggle then
                    r1_3.toggle.BackgroundColor3 = r2_2 and r28.Accent or r20_2
                end

                if r1_3.circ then
                    r1_3 = r1_3.circ

                    if r2_2 then
                        r2_2 = r28.Background
                    end

                    if not r2_2 then
                        r2_2 = r28.SubText
                    end

                    r1_3.BackgroundColor3 = r2_2
                end
            end

            if u1013._gui_kb then
                local r0_3 = u1013._gui_kb

                if r0_3.btn then
                    r0_3.btn.BackgroundColor3 = r28.CardDeep
                end

                if r0_3.stroke then
                    r0_3.stroke.Color = r28.StrokeHot
                end

                if r0_3.lbl then
                    r0_3.lbl.TextColor3 = r28.AccentSoft
                end
            end

            u1013._applying_theme = false
        end)
    end

    function u876.bind_gui_toggle_key(u1015)
        u863:disconnect("library_visibility")
        local saved = u864._config._gui and u864._config._gui.toggle_key
        if saved == false then return end
        local r4 = (saved or "Enum.KeyCode.RightControl"):gsub("Enum.KeyCode%.", "")
        if r4 == "Backspace" or r4 == "Unknown" or r4 == "None" then return end
        local u1014

        for r2, r3 in u824.KeyCode:GetEnumItems() do
            if r3.Name == r4 then
                u1014 = r3
                break
            end
        end

        if not u1014 then return end
        u863["library_visibility"] = u830.InputBegan:Connect(function(r0, r1)
            if r1 or u864._choosing_keybind or u864.keybind_is_clear(r0) then
                return
            end

            if r0.KeyCode ~= u1014 then
                return
            end

            if not u878.Enabled then
                u878.Enabled = true
            end

            u1015._ui_open = not u1015._ui_open
            u1015:change_visiblity(u1015._ui_open)
        end)
    end

    local function u1016()
        local r4 = u876:create_tab("Settings", "settings", {layout_order = 999999, no_activate = true})
        local u1017 = r4._left
        local r12 = r4._right
        local u1018 = 0
        local u1019 = 0

        local function u1020(r0)
            if r0 == "left" then
                u1018 = u1018 + 1
                return u1018
            end

            u1019 = u1019 + 1
            return u1019
        end

        local function r2(r0, r1)
            local r7 = u859.new("Frame")
            r7.Name = "GUICard"
            r7.BackgroundColor3 = u877.Card
            r7.BackgroundTransparency = 0.68
            r7.BorderSizePixel = 0
            r7.Size = u821.new(1, -8, 0, 0)
            r7.AutomaticSize = u824.AutomaticSize.Y
            local r3 = u1020
            local r4 = r0 == u1017
            local r5

            if r4 then
                r5 = "left"
            else
                local r5_2 = r4
                r5 = "right"
            end

            r7.LayoutOrder = r3(r5)
            r7.Parent = r0
            local r2 = u859.new("UICorner")
            r2.CornerRadius = u822.new(0, 12)
            r2.Parent = r7
            local r2_2 = u859.new("UIStroke")
            r2_2.Color = u877.Stroke
            r2_2.Transparency = 0.35
            r2_2.Parent = r7
            local r2_3 = u859.new("UIPadding")
            r2_3.PaddingLeft = u822.new(0, 12)
            r2_3.PaddingRight = u822.new(0, 12)
            r2_3.PaddingTop = u822.new(0, 10)
            r2_3.PaddingBottom = u822.new(0, 12)
            r2_3.Parent = r7
            local r2_4 = u859.new("UIListLayout")
            r2_4.Padding = u822.new(0, 10)
            r2_4.SortOrder = u824.SortOrder.LayoutOrder
            r2_4.Parent = r7
            local r2_5 = u859.new("TextLabel")
            r2_5.BackgroundTransparency = 1
            r2_5.Size = u821.new(1, 0, 0, 16)
            r2_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
            r2_5.TextSize = 12
            r2_5.TextColor3 = u877.AccentSoft
            r2_5.TextTransparency = 0.1
            r2_5.TextXAlignment = u824.TextXAlignment.Left
            r2_5.Text = r1
            r2_5.LayoutOrder = 0
            r2_5:SetAttribute("GUICardHead", true)
            r2_5.Parent = r7
            return r7
        end

        local r1 = r2(u1017, "Interaction")
        local u1021 = r2(r12, "Theme")
        local r2_2 = u859.new("Frame")
        r2_2.BackgroundTransparency = 1
        r2_2.Size = u821.new(1, 0, 0, 22)
        r2_2.LayoutOrder = 1
        r2_2.Parent = r1
        local r3 = u859.new("TextLabel")
        r3.Size = u821.new(0, 120, 1, 0)
        r3.BackgroundTransparency = 1
        r3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        r3.TextSize = 11
        r3.TextColor3 = u877.Text
        r3.TextTransparency = 0.14
        r3.TextXAlignment = u824.TextXAlignment.Left
        r3.Text = "Toggle UI"
        r3.Parent = r2_2
        local r3_2 = u859.new("TextButton")
        r3_2.Size = u821.new(0, 72, 0, 20)
        r3_2.AnchorPoint = Vector2.new(1, 0.5)
        r3_2.Position = u821.new(1, 0, 0.5, 0)
        r3_2.BackgroundColor3 = u877.CardDeep
        r3_2.BackgroundTransparency = 0.35
        r3_2.Text = ""
        r3_2.AutoButtonColor = false
        r3_2.Parent = r2_2
        local r2_3 = u859.new("UICorner")
        r2_3.CornerRadius = u822.new(0, 6)
        r2_3.Parent = r3_2
        local r2_4 = u859.new("UIStroke")
        r2_4.Color = u877.StrokeHot
        r2_4.Transparency = 0.45
        r2_4.Parent = r3_2
        local u1022 = u859.new("TextLabel")
        u1022.BackgroundTransparency = 1
        u1022.Size = u821.new(1, -6, 1, 0)
        u1022.Position = u821.new(0, 3, 0, 0)
        u1022.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", u824.FontWeight.Bold)
        u1022.TextSize = 10
        u1022.TextColor3 = u877.AccentSoft
        u1022.Parent = r3_2

        local function u1023()
            local saved = u864._config._gui.toggle_key
            u1022.Text = saved == false and "None" or (saved or "Enum.KeyCode.RightControl"):gsub("Enum.KeyCode%.", "")
        end

        u1023()
        u876._gui_kb = {btn = r3_2, stroke = r3_2:FindFirstChildOfClass("UIStroke"), lbl = u1022}

        r3_2.MouseButton1Click:Connect(function()
            if u864._choosing_keybind then return end
            u864._choosing_keybind = true
            local u1025
            local r1 = u830.InputBegan
            local u1026 = r1.Connect

            u1026 = u1026(r1, function(r0, r1)
                if not u864.keybind_can_capture(r0, r1, false) then return end

                if r0.KeyCode == u824.KeyCode.Backspace then
                    u864._config._gui.toggle_key = false
                    u867:save(u796.GameId, u864._config)
                    u1023()
                    u876:bind_gui_toggle_key()
                    u1025:Disconnect(); u864.finish_keybind_capture()
                    return
                end

                u864._config._gui.toggle_key = tostring(r0.KeyCode)
                u867:save(u796.GameId, u864._config)
                u1023()
                u876:bind_gui_toggle_key()
                u1025:Disconnect(); u864.finish_keybind_capture()
            end)

            u1025 = u1026
            u863.gui_keybind_choose = u1025
        end)

        local r2_5 = u859.new("Frame")
        r2_5.BackgroundTransparency = 1
        r2_5.Size = u821.new(1, 0, 0, 22)
        r2_5.LayoutOrder = 2
        r2_5.Parent = r1
        local r3_3 = u859.new("TextLabel")
        r3_3.Size = u821.new(1, -50, 1, 0)
        r3_3.BackgroundTransparency = 1
        r3_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        r3_3.TextSize = 11
        r3_3.TextColor3 = u877.Text
        r3_3.TextTransparency = 0.14
        r3_3.TextXAlignment = u824.TextXAlignment.Left
        r3_3.Text = "Hide When Minimized"
        r3_3.Parent = r2_5
        local u1027 = u859.new("TextButton")
        u1027.Size = u821.new(0, 36, 0, 18)
        u1027.AnchorPoint = Vector2.new(1, 0.5)
        u1027.Position = u821.new(1, 0, 0.5, 0)
        u1027.BackgroundColor3 = u820.fromRGB(8, 7, 12)
        u1027.BackgroundTransparency = 0.6
        u1027.Text = ""
        u1027.AutoButtonColor = false
        u1027.Parent = r2_5
        local r3_4 = u859.new("UICorner")
        r3_4.CornerRadius = u822.new(1, 0)
        r3_4.Parent = u1027
        local u1028 = u859.new("Frame")
        u1028.Size = u821.new(0, 9, 0, 9)
        u1028.Position = u821.new(0, 2, 0.5, 0)
        u1028.AnchorPoint = Vector2.new(0, 0.5)
        u1028.BackgroundColor3 = u877.SubText
        u1028.BorderSizePixel = 0
        u1028.Parent = u1027
        local r3_5 = u859.new("UICorner")
        r3_5.CornerRadius = u822.new(1, 0)
        r3_5.Parent = u1028
        local r3_6 = u864._config._gui.hide_minimized
        local u1029 = r3_6 == true
        r2_5.Visible = u876._device == "PC"
        u876._gui_hide_toggle = {toggle = u1027, circ = u1028}

        local function u1030(r0)
            u1029 = r0
            u864._config._gui.hide_minimized = r0
            u867:save(u796.GameId, u864._config)
            local r9 = u861.Colors
            local r13 = u820.new(math.clamp(r9.Card.R * 0.48, 0, 1), math.clamp(r9.Card.G * 0.48, 0, 1), math.clamp(r9.Card.B * 0.52, 0, 1))
            u832:Create(u1027, TweenInfo.new(0.35), {BackgroundColor3 = r0 and r9.Accent or r13, BackgroundTransparency = r0 and 0.3 or 0.6}):Play()
            local r16 = u832
            local r1 = r16.Create
            local r18 = TweenInfo.new(0.3)
            local r19 = {Position = r0 and u821.new(1, -11, 0.5, 0) or u821.new(0, 2, 0.5, 0)}

            if r0 then
                r0 = r9.Background
            end

            if not r0 then
                r0 = r9.SubText
            end

            r19.BackgroundColor3 = r0
            r1(r16, u1028, r18, r19):Play()
        end

        if r3_6 == true then
            u1030(true)
        end

        u1027.MouseButton1Click:Connect(function()
            u1030(not u1029)
        end)

        local r2_6 = u859.new("TextButton")
        r2_6.Text = ""
        r2_6.AutoButtonColor = false
        r2_6.BackgroundTransparency = 1
        r2_6.Size = u821.new(1, 0, 0, 22)
        r2_6.LayoutOrder = 3
        r2_6.Parent = r1
        local r1_2 = u859.new("TextLabel")
        r1_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        r1_2.TextSize = 11
        r1_2.TextColor3 = u877.Text
        r1_2.TextTransparency = 0.16
        r1_2.Text = "Window Transparency"
        r1_2.Size = u821.new(0, 153, 0, 13)
        r1_2.Position = u821.new(0, 0, 0.05, 0)
        r1_2.BackgroundTransparency = 1
        r1_2.TextXAlignment = u824.TextXAlignment.Left
        r1_2.Parent = r2_6
        local u1031 = u859.new("Frame")
        u1031.Active = true
        u1031.AnchorPoint = Vector2.new(0.5, 1)
        u1031.BackgroundTransparency = 0.78
        u1031.Position = u821.new(0.5, 0, 0.95, 0)
        u1031.Name = "Drag"
        u1031.Size = u821.new(1, 0, 0, 4)
        u1031.BorderSizePixel = 0
        u1031.BackgroundColor3 = u877.Stroke
        u1031.Parent = r2_6
        local r3_7 = u859.new("UICorner")
        r3_7.CornerRadius = u822.new(0, 12)
        r3_7.Parent = u1031
        local u1032 = u859.new("Frame")
        u1032.AnchorPoint = Vector2.new(0, 0.5)
        u1032.BackgroundTransparency = 0.05
        u1032.Position = u821.new(0, 0, 0.5, 0)
        u1032.Name = "Fill"
        u1032.Size = u821.new(0.5, 0, 1, 0)
        u1032.BorderSizePixel = 0
        u1032.BackgroundColor3 = u877.Accent
        u1032.Parent = u1031
        local r3_8 = u859.new("UICorner")
        r3_8.CornerRadius = u822.new(0, 3)
        r3_8.Parent = u1032
        local r3_9 = u859.new("UIGradient")
        r3_9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, u877.AccentSoft), ColorSequenceKeypoint.new(1, u877.AccentDim)})
        r3_9.Parent = u1032
        local r3_10 = u859.new("Frame")
        r3_10.AnchorPoint = Vector2.new(1, 0.5)
        r3_10.Name = "Circle"
        r3_10.Position = u821.new(1, 0, 0.5, 0)
        r3_10.Size = u821.new(0, 7, 0, 7)
        r3_10.BorderSizePixel = 0
        r3_10.BackgroundColor3 = u877.AccentSoft
        r3_10.Parent = u1032
        local r6 = u859.new("UICorner")
        r6.CornerRadius = u822.new(0, 12)
        r6.Parent = r3_10
        local u1033 = u859.new("TextLabel")
        u1033.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        u1033.TextColor3 = u877.Text
        u1033.TextTransparency = 0.2
        u1033.Name = "Value"
        u1033.Size = u821.new(0, 42, 0, 13)
        u1033.AnchorPoint = Vector2.new(1, 0)
        u1033.Position = u821.new(1, 0, 0, 0)
        u1033.BackgroundTransparency = 1
        u1033.TextXAlignment = u824.TextXAlignment.Right
        u1033.TextSize = 10
        u1033.Parent = r2_6

        u876._gui_tr = {
            drag = u1031,
            fill = u1032,
            val = u1033,
            title = r1_2,
            circle = r3_10
        }

        local function u1034(r0)
            local r1 = math.clamp(r0, 0, 1)
            u864._config._gui.bg_transparency = r1
            u867:save(u796.GameId, u864._config)

            if u876._theme_container then
                u876._theme_container.BackgroundTransparency = r1
            end

            u1032.Size = u821.new(math.clamp(r1, 0.02, 1), 0, 1, 0)
            u1033.Text = string.format("%.2f", r1)
        end

        local u1024
        u1034(u864._config._gui.bg_transparency ~= u1024 and u864._config._gui.bg_transparency or 0.04)

        local function u1035(r0)
            local r1 = u1031.AbsoluteSize.X

            if r1 < 1 then
                return
            end

            local r4 = math.clamp((r0 - u1031.AbsolutePosition.X) / r1, 0, 1)
            u1034(r4)
        end

        r2_6.MouseButton1Down:Connect(function()
            u863:disconnect("gui_tr_drag")
            u863:disconnect("gui_tr_end")
            u1035(u860.X)

            u863.gui_tr_drag = u830.InputChanged:Connect(function(r0)
                if r0.UserInputType == u824.UserInputType.MouseMovement or r0.UserInputType == u824.UserInputType.Touch then
                    u1035(r0.Position.X)
                end
            end)

            u863.gui_tr_end = u830.InputEnded:Connect(function(r0)
                if r0.UserInputType ~= u824.UserInputType.MouseButton1 and r0.UserInputType ~= u824.UserInputType.Touch then
                    return
                end

                u863:disconnect("gui_tr_drag")
                u863:disconnect("gui_tr_end")
                u867:save(u796.GameId, u864._config)
            end)
        end)

        local u1036 = {}

        local u1037 = {
            {title = "Secondary", key = "Card", flag = "_gui_col_card"},
            {title = "Accent", key = "Accent", flag = "_gui_col_accent"},
            {title = "Stroke", key = "Stroke", flag = "_gui_col_stroke"},
            {title = "Text", key = "Text", flag = "_gui_col_text"},
            {title = "SubText", key = "SubText", flag = "_gui_col_sub"}
        }

        if not u864._config._gui.colors then
            u864._config._gui.colors = {}
        end

        for r2_7, r3_11 in ipairs(u1037) do
            if not u864._config._gui.colors[r3_11.key] then
                local r21, r22, r23 = u820.toHSV(u861.DefaultColors[r3_11.key])
                u864._config._gui.colors[r3_11.key] = {H = r21, S = r22, V = r23}
            end
        end

        u867:save(u796.GameId, u864._config)

        local function r20(r0, u1039, r2)
            local u1038 = {_h = 0, _s = 1, _v = 1}
            local r4 = u864._config._gui.colors[u1039]

            if r4 then
                local r9 = r4.H
                local r10 = r4.S
                r4 = r4.V
                u1038._h = r9
                u1038._s = r10
                u1038._v = r4
            end

            local r7 = u859.new("TextButton")
            r7.Size = u821.new(1, 0, 0, 20)
            r7.BackgroundTransparency = 1
            r7.Text = ""
            r7.AutoButtonColor = false
            r7.LayoutOrder = r2 * 2
            r7.Parent = u1021
            local r4_2 = u859.new("TextLabel")
            r4_2.Text = r0
            r4_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
            r4_2.TextSize = 11
            r4_2.TextColor3 = u877.Text
            r4_2.TextTransparency = 0.14
            r4_2.BackgroundTransparency = 1
            r4_2.Size = u821.new(0, 130, 1, 0)
            r4_2.TextXAlignment = u824.TextXAlignment.Left
            r4_2.Parent = r7
            local u1040 = u859.new("Frame")
            u1040.Size = u821.new(0, 44, 0, 14)
            u1040.AnchorPoint = Vector2.new(1, 0.5)
            u1040.Position = u821.new(1, 0, 0.5, 0)
            u1040.BorderSizePixel = 0
            u1040.BackgroundColor3 = u820.fromHSV(u1038._h, u1038._s, u1038._v)
            u1040.Parent = r7
            local r4_3 = u859.new("UICorner")
            r4_3.CornerRadius = u822.new(0, 5)
            r4_3.Parent = u1040
            local r4_4 = u859.new("UIStroke")
            r4_4.Color = u877.StrokeHot
            r4_4.Transparency = 0.64
            r4_4.Parent = u1040
            local u1041 = u859.new("TextLabel")
            u1041.Text = "›"
            u1041.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.Bold)
            u1041.TextSize = 14
            u1041.TextColor3 = u877.Accent
            u1041.BackgroundTransparency = 1
            u1041.Size = u821.new(0, 12, 1, 0)
            u1041.AnchorPoint = Vector2.new(1, 0.5)
            u1041.Position = u821.new(1, -50, 0.5, 0)
            u1041.Rotation = 90
            u1041.Parent = r7
            local u1042 = u859.new("Frame")
            u1042.Size = u821.new(1, 0, 0, 0)
            u1042.BackgroundTransparency = 1
            u1042.ClipsDescendants = true
            u1042.BorderSizePixel = 0
            u1042.LayoutOrder = r2 * 2 + 1
            u1042.Parent = u1021
            local u1043 = u859.new("Frame")
            u1043.Size = u821.new(1, 0, 0, 62)
            u1043.Position = u821.new(0, 0, 0, 4)
            u1043.BorderSizePixel = 0
            u1043.BackgroundColor3 = u820.fromHSV(u1038._h, 1, 1)
            u1043.ClipsDescendants = true
            u1043.Parent = u1042
            local r4_5 = u859.new("UICorner")
            r4_5.CornerRadius = u822.new(0, 7)
            r4_5.Parent = u1043
            local r4_6 = u859.new("Frame")
            r4_6.Size = u821.new(1, 0, 1, 0)
            r4_6.BackgroundColor3 = u820.new(1, 1, 1)
            r4_6.BorderSizePixel = 0
            r4_6.ZIndex = 2
            r4_6.Parent = u1043
            local r5 = u859.new("UIGradient")
            local r13 = NumberSequence.new
            local r16 = NumberSequenceKeypoint.new(0, 0)
            local r17 = NumberSequenceKeypoint.new(1, 1)
            r5.Transparency = r13({})
            r5.Parent = r4_6
            local r4_7 = u859.new("Frame")
            r4_7.Size = u821.new(1, 0, 1, 0)
            r4_7.BackgroundColor3 = u820.new(0, 0, 0)
            r4_7.BorderSizePixel = 0
            r4_7.ZIndex = 3
            r4_7.Parent = u1043
            local r5_2 = u859.new("UIGradient")
            local r13_2 = NumberSequence.new
            local r16_2 = NumberSequenceKeypoint.new(0, 1)
            local r17_2 = NumberSequenceKeypoint.new(1, 0)
            r5_2.Transparency = r13_2({})
            r5_2.Rotation = 90
            r5_2.Parent = r4_7
            local u1044 = u859.new("Frame")
            u1044.Size = u821.new(0, 12, 0, 12)
            u1044.AnchorPoint = Vector2.new(0.5, 0.5)
            u1044.BackgroundColor3 = u820.fromRGB(0, 0, 0)
            u1044.BorderSizePixel = 0
            u1044.ZIndex = 5
            u1044.Visible = false
            u1044.Position = u821.new(u1038._s, 0, 1 - u1038._v, 0)
            u1044.Parent = u1043
            local r4_8 = u859.new("UICorner")
            r4_8.CornerRadius = u822.new(1, 0)
            r4_8.Parent = u1044
            local r4_9 = u859.new("Frame")
            r4_9.Size = u821.new(0, 8, 0, 8)
            r4_9.AnchorPoint = Vector2.new(0.5, 0.5)
            r4_9.Position = u821.new(0.5, 0, 0.5, 0)
            r4_9.BackgroundColor3 = u820.new(1, 1, 1)
            r4_9.BorderSizePixel = 0
            r4_9.ZIndex = 6
            r4_9.Parent = u1044
            local r5_3 = u859.new("UICorner")
            r5_3.CornerRadius = u822.new(1, 0)
            r5_3.Parent = r4_9
            local u1045 = u859.new("Frame")
            u1045.Size = u821.new(1, 0, 0, 12)
            u1045.Position = u821.new(0, 0, 0, 72)
            u1045.BorderSizePixel = 0
            u1045.BackgroundColor3 = u820.new(1, 1, 1)
            u1045.Parent = u1042

            local r4_10 = u859.new("UICorner")
            r4_10.CornerRadius = u822.new(0, 5)
            r4_10.Parent = u1045
            local r14 = u859.new("UIGradient")

            r14.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, u820.fromHSV(0, 1, 1)),
                ColorSequenceKeypoint.new(0.167, u820.fromHSV(0.167, 1, 1)),
                ColorSequenceKeypoint.new(0.333, u820.fromHSV(0.333, 1, 1)),
                ColorSequenceKeypoint.new(0.5, u820.fromHSV(0.5, 1, 1)),
                ColorSequenceKeypoint.new(0.667, u820.fromHSV(0.667, 1, 1)),
                ColorSequenceKeypoint.new(0.833, u820.fromHSV(0.833, 1, 1)),
                ColorSequenceKeypoint.new(1, u820.fromHSV(0, 1, 1))
            })

            r14.Parent = u1045
            local u1046 = u859.new("Frame")
            u1046.Size = u821.new(0, 6, 1, 4)
            u1046.AnchorPoint = Vector2.new(0.5, 0.5)
            u1046.Position = u821.new(u1038._h, 0, 0.5, 0)
            u1046.BackgroundColor3 = u820.fromRGB(0, 0, 0)
            u1046.BorderSizePixel = 0
            u1046.ZIndex = 4
            u1046.Visible = false
            u1046.Parent = u1045
            local r4_11 = u859.new("UICorner")
            r4_11.CornerRadius = u822.new(0, 3)
            r4_11.Parent = u1046
            local r4_12 = u859.new("Frame")
            r4_12.Size = u821.new(0, 4, 1, 0)
            r4_12.AnchorPoint = Vector2.new(0.5, 0.5)
            r4_12.Position = u821.new(0.5, 0, 0.5, 0)
            r4_12.BackgroundColor3 = u820.new(1, 1, 1)
            r4_12.BorderSizePixel = 0
            r4_12.ZIndex = 5
            r4_12.Parent = u1046
            local r14_2 = u859.new("UICorner")
            r14_2.CornerRadius = u822.new(0, 2)
            r14_2.Parent = r4_12

            local function u1047()
                return u820.fromHSV(u1038._h, u1038._s, u1038._v)
            end

            local function u1048()
                u1040.BackgroundColor3 = u1047()
                u1043.BackgroundColor3 = u820.fromHSV(u1038._h, 1, 1)
                u1044.Position = u821.new(u1038._s, 0, 1 - u1038._v, 0)
                u1046.Position = u821.new(u1038._h, 0, 0.5, 0)
            end

            local function u1049()
                u864._config._gui.colors[u1039] = {H = u1038._h, S = u1038._s, V = u1038._v}
                local r7 = u1047()
                u861.Colors[u1039] = r7

                if u1039 == "Stroke" then
                    u861.Colors.StrokeHot = u820.new(math.clamp(r7.R * 1.2 + 0.05, 0, 1), math.clamp(r7.G * 1.2 + 0.05, 0, 1), math.clamp(r7.B * 1.22 + 0.06, 0, 1))
                end

                if u1039 == "Accent" then
                    u861.Colors.AccentSoft = u820.new(math.clamp(r7.R * 0.55 + 0.42, 0, 1), math.clamp(r7.G * 0.55 + 0.42, 0, 1), math.clamp(r7.B * 0.58 + 0.45, 0, 1))
                    u861.Colors.AccentDim = u820.new(math.clamp(r7.R * 0.42, 0, 1), math.clamp(r7.G * 0.42, 0, 1), math.clamp(r7.B * 0.48, 0, 1))
                    u861.Colors.AccentGlow = r7
                end

                if u1039 == "Card" then
                    u861.Colors.CardDeep = u820.new(r7.R * 0.78, r7.G * 0.78, r7.B * 0.8)
                end

                u867:save(u796.GameId, u864._config)
            end

            local u1050 = 0
            local u1051 = false
            local u1052 = false

            u1043.InputBegan:Connect(function(r0)
                if r0.UserInputType == u824.UserInputType.MouseButton1 then
                    u1051 = true
                    u864._blocking_drag = true
                end
            end)

            u1045.InputBegan:Connect(function(r0)
                if r0.UserInputType == u824.UserInputType.MouseButton1 then
                    u1052 = true
                    u864._blocking_drag = true
                end
            end)

            u863["gcp_m_" .. u1039] = u830.InputChanged:Connect(function(r0)
                if r0.UserInputType ~= u824.UserInputType.MouseMovement then
                    return
                end

                local r2 = u817()

                if u1051 then
                    u1038._s = math.clamp((r0.Position.X - u1043.AbsolutePosition.X) / u1043.AbsoluteSize.X, 0, 1)
                    u1038._v = 1 - math.clamp((r0.Position.Y - u1043.AbsolutePosition.Y) / u1043.AbsoluteSize.Y, 0, 1)
                    u1048()
                    u1049()

                    if r2 - u1050 >= 0.08 then
                        u1050 = r2
                        u876:apply_gui_theme_fast()
                    end
                end

                if not u1052 then
                    return
                end

                u1038._h = math.clamp((r0.Position.X - u1045.AbsolutePosition.X) / u1045.AbsoluteSize.X, 0, 1)
                u1048()
                u1049()

                if r2 - u1050 >= 0.08 then
                    u1050 = r2
                    u876:apply_gui_theme_fast()
                end
            end)

            u863["gcp_e_" .. u1039] = u830.InputEnded:Connect(function(r0)
                if r0.UserInputType ~= u824.UserInputType.MouseButton1 then
                    return
                end

                if u1051 or u1052 then
                    u1051 = false
                    u1052 = false
                    u864._blocking_drag = false
                    u1049()
                    u876:apply_gui_theme()
                end
            end)

            local u1053 = false

            r7.MouseButton1Click:Connect(function()
                u1053 = not u1053
                u1044.Visible = u1053
                u1046.Visible = u1053

                u832:Create(u1042, TweenInfo.new(0.35, u824.EasingStyle.Quint, u824.EasingDirection.Out), {
                    Size = u821.new(1, 0, 0, u1053 and 90 or 0)
                }):Play()

                u832:Create(u1041, TweenInfo.new(0.3), {Rotation = u1053 and -90 or 90}):Play()
            end)

            u1048()

            function u1038.updateVisuals(r0)
                u1040.BackgroundColor3 = u1047()
                u1043.BackgroundColor3 = u820.fromHSV(u1038._h, 1, 1)
                u1044.Position = u821.new(u1038._s, 0, 1 - u1038._v, 0)
                u1046.Position = u821.new(u1038._h, 0, 0.5, 0)
            end

            function u1038.SetFromColor(r0, r1)
                local r4 = u1038
                local r8 = u1038
                local r305, r306, r307 = u820.toHSV(r1)
                u1038._h = r305
                r4._s = r306
                r8._v = r307
                u1038:updateVisuals()
                u864._config._gui.colors[u1039] = {H = u1038._h, S = u1038._s, V = u1038._v}
                u861.Colors[u1039] = r1

                if u1039 == "Stroke" then
                    u861.Colors.StrokeHot = u820.new(math.clamp(r1.R * 1.2 + 0.05, 0, 1), math.clamp(r1.G * 1.2 + 0.05, 0, 1), math.clamp(r1.B * 1.22 + 0.06, 0, 1))
                end

                if u1039 == "Accent" then
                    u861.Colors.AccentSoft = u820.new(math.clamp(r1.R * 0.55 + 0.42, 0, 1), math.clamp(r1.G * 0.55 + 0.42, 0, 1), math.clamp(r1.B * 0.58 + 0.45, 0, 1))
                    u861.Colors.AccentDim = u820.new(math.clamp(r1.R * 0.42, 0, 1), math.clamp(r1.G * 0.42, 0, 1), math.clamp(r1.B * 0.48, 0, 1))
                    u861.Colors.AccentGlow = r1
                end

                if u1039 == "Card" then
                    u861.Colors.CardDeep = u820.new(r1.R * 0.78, r1.G * 0.78, r1.B * 0.8)
                end
            end

            u1036[u1039] = u1038
        end

        for r7, r8 in ipairs(u1037) do
            r20(r8.title, r8.key, r7)
        end

        local r2_8 = u859.new("TextButton")
        r2_8.Name = "resetBtn"
        r2_8.Size = u821.new(1, 0, 0, 32)
        r2_8.BackgroundColor3 = u877.CardDeep
        r2_8.BackgroundTransparency = 0.25
        r2_8.Text = ""
        r2_8.AutoButtonColor = false
        r2_8.LayoutOrder = 900
        r2_8.Parent = u1021
        local r1_3 = u859.new("UICorner")
        r1_3.CornerRadius = u822.new(0, 8)
        r1_3.Parent = r2_8
        local r1_4 = u859.new("UIStroke")
        r1_4.Color = u877.StrokeHot
        r1_4.Transparency = 0.4
        r1_4.Parent = r2_8
        local r3_12 = u859.new("TextLabel")
        r3_12.BackgroundTransparency = 1
        r3_12.Size = u821.new(1, 0, 1, 0)
        r3_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", u824.FontWeight.SemiBold)
        r3_12.TextSize = 11
        r3_12.TextColor3 = u877.AccentSoft
        r3_12.Text = "Restore Default Theme"
        r3_12.Parent = r2_8
        u876._gui_reset_btn = {btn = r2_8, stroke = r2_8:FindFirstChildOfClass("UIStroke"), lbl = r3_12}

        r2_8.MouseButton1Click:Connect(function()
            u864._config._gui.bg_transparency = 0.04
            u864._config._gui.colors = {}

            for r1, r2 in pairs(u861.DefaultColors) do
                local r3, r4, r5 = u820.toHSV(r2)
                u864._config._gui.colors[r1] = {H = r3, S = r4, V = r5}
                u861.Colors[r1] = r2
            end

            local r7 = u861.Colors
            local r6 = r7.Stroke
            r7.StrokeHot = u820.new(math.clamp(r6.R * 1.2 + 0.05, 0, 1), math.clamp(r6.G * 1.2 + 0.05, 0, 1), math.clamp(r6.B * 1.22 + 0.06, 0, 1))
            local r8 = r7.Accent
            r7.AccentSoft = u820.new(math.clamp(r8.R * 0.55 + 0.42, 0, 1), math.clamp(r8.G * 0.55 + 0.42, 0, 1), math.clamp(r8.B * 0.58 + 0.45, 0, 1))
            r7.AccentDim = u820.new(math.clamp(r8.R * 0.42, 0, 1), math.clamp(r8.G * 0.42, 0, 1), math.clamp(r8.B * 0.48, 0, 1))
            r7.AccentGlow = r8
            local r0 = r7.Card
            r7.CardDeep = u820.new(r0.R * 0.78, r0.G * 0.78, r0.B * 0.8)
            u867:save(u796.GameId, u864._config)
            u1034(0.04)

            for r4_2, r5_2 in ipairs(u1037) do
                if u1036[r5_2.key] then
                    u1036[r5_2.key]:SetFromColor(u861.DefaultColors[r5_2.key])
                end
            end

            u876:apply_gui_theme()
        end)

        u876._gui_sections = {u1017, r12}
    end

    task.defer(function()
        u876:get_device()
        u1016()
        u876:apply_gui_theme()
    end)

    u876:bind_gui_toggle_key()

    u878.Container.Handler.Minimize.MouseButton1Click:Connect(function()
        if not u878.Enabled then
            u878.Enabled = true
        end

        u876._ui_open = not u876._ui_open
        u876:change_visiblity(u876._ui_open)
    end)

    return u876
end

__S[84] = u864.new()
__S[84]:load()
local u1054 = u799(u796:GetService("Players"))
local u1055 = u799(u796:GetService("RunService"))
local u1056 = u799(u796:GetService("UserInputService"))
local u1057 = u799(u796:GetService("ReplicatedStorage"))
local u1058 = u799(u796:GetService("Workspace"))
local u1059 = u799(u796:GetService("Stats"))
local u1060 = u850.new("VirtualInputManager")
u799(u796:GetService("InsertService"))
local u1061 = u1054.LocalPlayer
local u1062 = u1058.CurrentCamera
local u1063 = u1055.Heartbeat
local u1064 = u1055.RenderStepped
local u1065 = u1055.PreSimulation
u797 = u1058
local u1066 = u829.clock
local u1067 = u797:FindFirstChild("Runtime")
local u1068 = u796.PlaceId == 0
local u1069 = {}

local u1070 = {
    config = {
        auto_parry = false,
        accuracy = 75,
        parry_range = 0,
        parry_loop = "PreSimulation",
        randomize_accuracy = false,
        random_accuracy_min = 1,
        random_accuracy_max = 100,
        curve_method = "Camera",
        parry_mode = "Remote",
        is_mobile = u1056.TouchEnabled and not u1056.MouseEnabled,
        auto_parry_animation_fix = false,
        predictive_timing = false,
        target_player_enabled = false,
        target_player_name = nil,
        kill_pre_click = false,
        preclick_for_all = false,
        kill_pre_click_range = 30,
        kill_pre_click_speed = 1
    },
    state = {
        grab_track = nil,
        ball_tracking = {},
        parried = false,
        infinity_active = false,
        deathslash_active = false,
        slashesoffury_active = false,
        timehole_active = false
    },
    cache = {
        ping = 50,
        emotes_shared = nil,
        trove_module = nil
    },
    parry_cooldown = {
        failed_at = 0,
        duration = 2,
        last_parrying = nil,
        conn = nil,
        pending_id = 0,
        success_window = 0.75
    },
    triggerbot = {
        enabled = false, is_parrying = false, connection = nil,
        mode = "Remote", delay = 0, randomize = false,
        delay_min = 0, delay_max = 200, ignore_spawn = false
    },
    spam = {
        manual_enabled = false,
        auto_enabled = false,
        parries = 0,
        threshold = 1.5,
        distance_multiplier = 0.3,
        sensitivity_multiplier = 1,
        connection_manual = nil,
        connection_auto = nil,
        animation_fix_manual = false,
        animation_fix_auto = false,
        manual_mode = "Remote",
        auto_mode = "Remote",
        remote_list = {},
        remote_list_dirty = true,
        auto_decay_at = {},
        ping_cache = 0,
        ping_cache_t = 0,
        balls_ref = nil,
        alive_ref = nil
    },
    ability = {cooldown_protection = false, auto_ability = false},
    mobile_guis = {triggerbot = nil, manual_spam = nil},
    ability_esp = {
        active = false,
        drawings = {},
        connection = nil,
        mode = "Text",
        show_name = false,
        name_mode = "Display Name",
        name_size = 18,
        name_color = u820.fromRGB(255, 255, 255),
        ability_size = 16,
        ability_color = u820.fromRGB(120, 200, 255),
        show_cd = true,
        cd_size = 15,
        cd_color = u820.fromRGB(180, 180, 180),
        show_timer = true,
        active_size = 15,
        active_color = u820.fromRGB(255, 200, 80)
    },
    ball_velocity = {
        active = false,
        gui = nil,
        peak = {},
        connection = nil
    },
    ball_indicator = {
        active = false,
        gui = nil,
        position = Vector2.new(0, 0),
        rotation = 0,
        connection = nil,
        size = u1056.TouchEnabled and not u1056.MouseEnabled and 30 or 40,
        distance = u1056.TouchEnabled and not u1056.MouseEnabled and 70 or 90
    },
    no_render = {active = false, connection = nil},
    plushies = {
        active = false,
        active_types = {},
        folder = nil,
        connection = nil,
        loaded_models = {},
        models = {
            Reimu = "rbxassetid://17657672380",
            Youmou = "rbxassetid://13242826151",
            Shion = "rbxassetid://12124164278",
            Yuuka = "rbxassetid://12181667428",
            Flandre = "rbxassetid://12136125365",
            Ayanami = "rbxassetid://11965563704",
            Padoru = "rbxassetid://11905337091"
        },
        scales = {
            Reimu = 1.5,
            Youmou = 2.3,
            Shion = 2.3,
            Yuuka = 1.5,
            Flandre = 3.3,
            Ayanami = 1.5,
            Padoru = 1.5
        },
        rotations = {
            Reimu = u819.Angles(0, u827.rad(0), 0),
            Youmou = u819.Angles(0, u827.rad(-90), 0),
            Shion = u819.Angles(u827.rad(110), 0, u827.rad(90)),
            Yuuka = u819.Angles(u827.rad(-90), u827.rad(180), 0),
            Flandre = u819.Angles(0, u827.rad(-40), 0),
            Ayanami = u819.Angles(0, 0, 0),
            Padoru = u819.Angles(0, 0, 0)
        },
        positions = {
            u818.new(2.5, 2, 0),
            u818.new(-2.5, 2, 0),
            u818.new(0, 4, 2.5),
            u818.new(0, 4, -2.5),
            u818.new(2.5, 2, 2.5),
            u818.new(-2.5, 2, 2.5),
            u818.new(2.5, 2, -2.5)
        }
    },
    remote = {},
    animation = {},
    ball = {},
    player = {},
    curve = {},
    parry = {},
    sword_changer = {
        original = {model = nil, saved = false},
        model_cache = {},
        swords_controller = nil,
        parry_func = nil,
        loaded = false,
        enabled = false,
        model = "",
        animations = "",
        fx = "",
        slash_name = "SlashEffect",
        update = nil
    },
    avatar_changer = {
        applying = false,
        applied_id = nil,
        cache = {},
        original_desc = nil,
        enabled = false,
        target = "",
        respawn_token = 0,
        expected_accessories = 0
    },
    emotes = {
        storage = {},
        current = nil,
        trove = nil,
        enabled = false,
        auto_stop = false,
        paused = false,
        _replay_t = 0,
        _loop_t = 0,
        connection = nil
    },
    avatar = {
        korblox_enabled = false,
        headless_enabled = false,
        korblox_conn = nil,
        headless_conn = nil
    },
    parry_visualizer = {
        active = false,
        color = u820.fromRGB(255, 255, 255),
        parts = {},
        connection = nil,
        char_conn = nil,
        sphere = nil,
        weld = nil
    },
    parry_hits = {active = false, color = u820.fromRGB(255, 255, 255), parts = {}},
    player_mods = {
        fov_enabled = false,
        fov = 70,
        speed_enabled = false,
        speed = 16,
        gravity_enabled = false,
        gravity = 196.2,
        jump_power_enabled = false,
        jump_power = 50,
        infinite_jump_enabled = false,
        infinite_jump_conn = nil,
        speed_conn = nil,
        jump_conn = nil
    },
    ball_trail = {
        active = false,
        color = u820.fromRGB(0, 255, 255),
        num_trails = 8,
        attachments = {},
        connection = nil
    },
    orbit_ball = {
        active = false,
        speed = 50,
        height = 5,
        distance = 15,
        angle = 0,
        connection = nil
    },
    winstreak = {
        enabled = false,
        streak = "1",
        conn = nil,
        enabled_conn = nil,
        char_conn = nil,
        original_text = nil,
        original_icon = nil,
        original_enabled = nil
    },
    custom_win = {
        enabled = false,
        win_message = "Allusive",
        kill_message = "Allusive",
        connections = {}
    },
    immortal = {
        config = {
            radius = 25,
            height = 30,
            angles = 360,
            visualizer_enabled = false,
            visualizer_color = u820.fromRGB(255, 0, 0)
        },
        state = {
            enabled = false,
            notify = false,
            connections = {},
            cache = {
                character = nil,
                hrp = nil,
                head = nil,
                alive = nil,
                original_cframe = nil,
                original_velocity = nil
            },
            visualizer = {parts = {}, folder = nil}
        },
        constants = {empty_cframe = u819.new(), velocity = u818.new(1, 1, 1)}
    },
    staff_detection = {mode = "Notify"},
    phantom = {
        enabled = false,
        mode = "Ability",
        range = 130,
        active = false
    }
}

__S[3] = function()
    local r4 = u1061.Character

    if r4 == u1070.immortal.state.cache.character then
        return
    end

    u1070.immortal.state.cache.character = r4

    if r4 then
        u1070.immortal.state.cache.hrp = r4:FindFirstChild("HumanoidRootPart")
        u1070.immortal.state.cache.head = r4:FindFirstChild("Head")
        u1070.immortal.state.cache.alive = u797:FindFirstChild("Alive")
    else
        u1070.immortal.state.cache.hrp = nil
        u1070.immortal.state.cache.head = nil
    end
end

u1070.immortal.update_cache = __S[3]

__S[3] = function()
    return u1070.immortal.state.cache.alive and u1070.immortal.state.cache.character and u1070.immortal.state.cache.character.Parent == u1070.immortal.state.cache.alive
end

u1070.immortal.is_in_alive = __S[3]

__S[3] = function()
    if not u1070.immortal.state.cache.hrp then
        return u819.new()
    end

    local r3 = u1070.immortal.state.cache.hrp
    local r4 = r3.Position
    local r0 = (nil)(math.random(0, u1070.immortal.config.angles))
    local r5 = u1070.immortal.config.radius
    local r2 = math.floor(u817() * 11.9) % 2 == 0 and 0 or u1070.immortal.config.height
    local r1 = r4.X + math.cos(r0) * r5
    r2 = r4.Y - r3.Size.Y * 0.5 + 5 + r2
    local r3_2 = r4.Z + math.sin(r0) * r5
    return u819.new(r1, r2, r3_2)
end

u1070.immortal.get_random_position = __S[3]

__S[3] = function()
    if u1070.immortal.state.visualizer.folder then
        u1070.immortal.state.visualizer.folder:Destroy()
    end

    local r0 = u850.new("Folder")
    r0.Name = "ImmortalVisualizer"
    r0.Parent = u797
    u1070.immortal.state.visualizer.folder = r0
end

u1070.immortal.create_visualizer = __S[3]

__S[3] = function(r0)
    if not u1070.immortal.config.visualizer_enabled or not u1070.immortal.state.visualizer.folder then
        return
    end

    for r2, r3 in ipairs(u1070.immortal.state.visualizer.parts) do
        if r3 and r3.Parent then
            r3:Destroy()
        end
    end

    u1070.immortal.state.visualizer.parts = {}
    local r2_2 = u850.new("Part")
    r2_2.Size = Vector3.new(2, 0.5, 2)
    r2_2.CFrame = r0
    r2_2.Anchored = true
    r2_2.CanCollide = false
    r2_2.Material = u824.Material.Neon
    r2_2.Color = u1070.immortal.config.visualizer_color
    r2_2.Transparency = 0.5
    r2_2.Parent = u1070.immortal.state.visualizer.folder
    table.insert(u1070.immortal.state.visualizer.parts, r2_2)
    u796:GetService("Debris"):AddItem(r2_2, 0.1)
end

u1070.immortal.update_visualizer = __S[3]

__S[3] = function()
    if u1070.immortal.state.visualizer.folder then
        u1070.immortal.state.visualizer.folder:Destroy()
        u1070.immortal.state.visualizer.folder = nil
    end

    u1070.immortal.state.visualizer.parts = {}
end

u1070.immortal.destroy_visualizer = __S[3]

__S[6] = function()
    u1070.immortal.update_cache()

    if not u1070.immortal.state.enabled or not u1070.immortal.state.cache.hrp or not u1070.immortal.is_in_alive() then
        return
    end

    local v1 = u1070.immortal.state.cache.hrp
    u1070.immortal.state.cache.original_cframe = v1.CFrame
    u1070.immortal.state.cache.original_velocity = v1.AssemblyLinearVelocity
    local v2 = u1070.immortal.get_random_position()
    v1.CFrame = v2
    v1.AssemblyLinearVelocity = u1070.immortal.constants.velocity

    if u1070.immortal.config.visualizer_enabled then
        u1070.immortal.update_visualizer(v2)
    end

    u1064:Wait()
    v1.CFrame = u1070.immortal.state.cache.original_cframe
    v1.AssemblyLinearVelocity = u1070.immortal.state.cache.original_velocity
end  

u1070.immortal.perform_desync = __S[6]

__S[3] = function()
    u1070.immortal.state.cache.character = nil
    u1070.immortal.state.cache.hrp = nil

    u1070.immortal.state.cache.head = nil
    u1070.immortal.state.cache.alive = nil
    u1070.immortal.state.cache.original_cframe = nil
    u1070.immortal.state.cache.original_velocity = nil
end

u1070.immortal.reset_cache = __S[3]

__S[3] = function()
    if u1070.immortal.state.enabled then
        return
    end

    u1070.immortal.state.enabled = true

    if u1070.immortal.config.visualizer_enabled then
        u1070.immortal.create_visualizer()
    end

    if not u1070.immortal.state.connections.heartbeat then
        u1070.immortal.state.connections.heartbeat = u1063:Connect(u1070.immortal.perform_desync)
    end
end

u1070.immortal.start = __S[3]

__S[3] = function()
    if not u1070.immortal.state.enabled then
        return
    end

    u1070.immortal.state.enabled = false

    if u1070.immortal.state.connections.heartbeat then
        u1070.immortal.state.connections.heartbeat:Disconnect()
        u1070.immortal.state.connections.heartbeat = nil
    end

    u1070.immortal.destroy_visualizer()
    u1070.immortal.reset_cache()
end

u1070.immortal.stop = __S[3]

u1061.CharacterAdded:Connect(function(r0)
    if not u1070.immortal.state.enabled then
        return
    end

    task.wait(1)
    u1070.immortal.reset_cache()

    if u1070.immortal.state.connections.heartbeat then
        u1070.immortal.state.connections.heartbeat:Disconnect()
    end

    u1070.immortal.state.connections.heartbeat = u1063:Connect(u1070.immortal.perform_desync)

    if u1070.immortal.config.visualizer_enabled then
        u1070.immortal.create_visualizer()
    end
end)

local u1071

__S[3] = function(v1, v2)
    if not u1070.immortal.state.enabled or (u805()) or v2 ~= "CFrame" or not u1070.immortal.state.cache.hrp or not u1070.immortal.is_in_alive() then
        return u1071(v1, v2)
    end

    if v1 == u1070.immortal.state.cache.hrp then
        return u1070.immortal.state.cache.original_cframe or u1070.immortal.constants.empty_cframe
    elseif v1 == u1070.immortal.state.cache.head and u1070.immortal.state.cache.original_cframe then
        local v3 = u818.new(0, u1070.immortal.state.cache.hrp.Size.Y * 0.5 + 0.5, 0)
        return u1070.immortal.state.cache.original_cframe + v3
    end

    return u1071(v1, v2)
end  

u1071 = __S[10](u796, "__index", __S[11](__S[3]))

__S[3] = function()
    local r0 = u1057:FindFirstChild("Misc")

    if not r0 then
        return
    end

    local r4 = r0:FindFirstChild("Emotes")

    if not r4 then
        return
    end

    local r292 = r4:GetChildren()

    for r1, r2 in pairs(r292) do
        if r2:IsA("Animation") and r2:GetAttribute("EmoteName") then
            local r3 = r2:GetAttribute("EmoteName")
            u1070.emotes.storage[r3] = r2
        end
    end
end

u1070.emotes.load_animations = __S[3]

__S[3] = function()
    local r3 = {}

    for r1, r2 in pairs(u1070.emotes.storage) do
        table.insert(r3, r1)
    end

    table.sort(r3)
    return r3
end

u1070.emotes.get_emotes_list = __S[3]

__S[6] = function()
    if u1070.cache.emotes_shared ~= nil then
        return u1070.cache.emotes_shared or nil
    end

    local v1 = u1057:FindFirstChild("Shared")
    local v2 = v1 and (v1:FindFirstChild("EmotesShared"))

    if not v2 then
        u1070.cache.emotes_shared = false
        return nil
    end

    v1 = getthreadidentity()
    setthreadidentity(6)
    local v3, v4 = u808(require, v2)
    setthreadidentity(v1)

    if v3 and u809(v4) == "table" and u809(v4.Play) == "function" then
        u1070.cache.emotes_shared = v4
    end

    if not (v3 and u809(v4) == "table" and u809(v4.Play) == "function") then
        u1070.cache.emotes_shared = false
    end

    return u1070.cache.emotes_shared or nil
end  

u1070.emotes.get_shared = __S[6]

__S[6] = function()
    if u1070.cache.trove_module ~= nil then
        return u1070.cache.trove_module or nil
    end

    local v1 = u1057:FindFirstChild("Packages")
    local v2 = v1 and (v1:FindFirstChild("Trove"))

    if not v2 then
        u1070.cache.trove_module = false
        return nil
    end

    local v3, v4 = u808(require, v2)

    if v3 and u809(v4) == "table" and u809(v4.new) == "function" then
        u1070.cache.trove_module = v4
    end

    if not (v3 and u809(v4) == "table" and u809(v4.new) == "function") then
        u1070.cache.trove_module = false
    end

    return u1070.cache.trove_module or nil
end  

u1070.emotes.get_trove_module = __S[6]

__S[3] = function(r0)
    local u1072 = u1070.emotes

    if u1072.trove then
        pcall(function()
            u1072.trove:Destroy()
        end)

        u1072.trove = nil
    end

    if not r0 then
        u1072.current = nil
        u1072.paused = false
    end
end

u1070.emotes._stop_track = __S[3]

__S[6] = function(v1)
    local v2 = u1070.emotes.storage[v1]

    if not v2 then
        return false
    end

    local v3 = u1061.Character

    if not v3 or not v3.PrimaryPart then
        return false
    end

    if not v3:FindFirstChildWhichIsA("Humanoid") then
        return false
    end

    local v4, v5 = u1070.emotes.get_shared(), u1070.emotes.get_trove_module()

    if not v4 or not v5 then
        return false
    end

    u1070.emotes._stop_track(false)
    u1070.emotes.paused = false
    u1070.emotes.trove = v5.new()
    u1070.emotes.current = v1

    if not u808(function()
        v4:Play(v3, u1070.emotes.trove, v2.Name, true, u1058:GetServerTimeNow(), nil)
    end) then
        u1070.emotes._stop_track(false)
        return false
    end

    return true
end  

u1070.emotes.play = __S[6]

__S[6] = function(v1)
    if u809(v1) ~= "string" or v1 == "" then
        return false
    end

    local v2 = u1061.Character

    if not v2 or not v2.PrimaryPart then
        return false
    end

    if not v2:FindFirstChildWhichIsA("Humanoid") then
        return false
    end

    local v3, v4 = u1070.emotes.get_shared(), u1070.emotes.get_trove_module()

    if not v3 or not v4 then
        return false
    end

    u1070.emotes._stop_track(false)
    u1070.emotes.paused = false
    u1070.emotes.trove = v4.new()
    u1070.emotes.current = v1

    if not u808(function()
        v3:Play(v2, u1070.emotes.trove, v1, true, u1058:GetServerTimeNow(), nil)
    end) then
        u1070.emotes._stop_track(false)
        return false
    end

    return true
end  

u1070.emotes.play_internal = __S[6]

__S[3] = function()
    u1070.emotes._stop_track(false)
end

u1070.emotes.stop = __S[3]

__S[6] = function()
    local v1 = u1070.emotes

    if not v1.enabled or not v1.current then
        return
    end

    local v2 = u1066()

    if v2 - v1._loop_t < 0.08 then
        return
    end

    v1._loop_t = v2
    local v3 = u1061.Character

    if not v3 then
        return
    end

    local v4 = v3.PrimaryPart

    if not v4 then
        return
    end

    v3 = v4.AssemblyLinearVelocity.Magnitude > 2

    if v1.auto_stop then
        if v3 then
            if not v1.paused then
                v1._stop_track(true)
                v1.paused = true
            end
        elseif v1.paused then
            v1.paused = false
            v1.play(v1.current)
        end

        return
    end

    if not v1.trove then
        if v2 - v1._replay_t >= 0.3 then
            v1._replay_t = v2
            v1.play(v1.current)
        end
    end
end  

u1070.emotes.update_loop = __S[6]

__S[3] = function()
    u1070.emotes.enabled = true

    if not u1070.emotes.connection then
        local function r2()
            if u1070.emotes.enabled then
                u1070.emotes.update_loop()
            end
        end  

        u1070.emotes.connection = u1055.Heartbeat:Connect(r2)
    end

    if u1070.emotes.current then
        u1070.emotes.play(u1070.emotes.current)
    end
end

u1070.emotes.start = __S[3]

__S[3] = function()
    u1070.emotes.enabled = false
    local r0 = u1070.emotes.current
    u1070.emotes.stop()
    u1070.emotes.current = r0

    if u1070.emotes.connection then
        u1070.emotes.connection:Disconnect()
        u1070.emotes.connection = nil
    end
end

u1070.emotes.cleanup = __S[3]
u1070.emotes.load_animations()
local u1073 = {"Randomized Backwards", "Backwards", "BB Camera", "Camera", "Straight", "Dot", "High", "Random", "Stop"}

 
 
do
    local R = {Entries = {}, Destroyed = false}
    u1070.runtime_cache = R
    function R.Forget(folder)
        local entry = R.Entries[folder]
        if not entry then return end
        R.Entries[folder] = nil
        for _, connection in ipairs(entry.Connections) do connection:Disconnect() end
        table.clear(entry.Connections)
        entry.List = nil
    end
    function R.Children(folder)
        if R.Destroyed or folder.Parent ~= u797 then return folder:GetChildren() end
        local entry = R.Entries[folder]
        if not entry then
            entry = {Connections = {}}
            R.Entries[folder] = entry
            local function invalidate() entry.List = nil end
            entry.Connections[1] = folder.ChildAdded:Connect(invalidate)
            entry.Connections[2] = folder.ChildRemoved:Connect(invalidate)
            entry.Connections[3] = folder.Destroying:Connect(function() R.Forget(folder) end)
        end
        if not entry.List then entry.List = folder:GetChildren() end
        return entry.List
    end
    function R.Destroy()
        if R.Destroyed then return end
        R.Destroyed = true
        local folders = {}
        for folder in pairs(R.Entries) do folders[#folders + 1] = folder end
        for _, folder in ipairs(folders) do R.Forget(folder) end
        if R.Removed then R.Removed:Disconnect(); R.Removed = nil end
        if R.Cleanup then R.Cleanup:Disconnect(); R.Cleanup = nil end
    end
    R.Removed = u797.ChildRemoved:Connect(R.Forget)
    if u839 then R.Cleanup = u839.Destroying:Connect(R.Destroy) end
end

do
    local function initializeAdaptivePing()
        local function filter()
            return {Window = {}, RawWindow = {}, Noise = 0, Trend = 0, Slope = 0, Rejected = 0, Changes = 0, Run = 0}
        end
        local P, N = filter(), filter()
        P.Frames, P.Ratios, P.FrameMargin, P.StatsFailures, P.StatsRecovery = {}, {}, 0, 0, 0
        u1070.cache.adaptive_ping, u1070.cache.floxy_ping = P, P
        local statsItem
        local function valid(value, zero)
            return type(value) == "number" and value == value and value < math.huge
                and value >= (zero and 0 or 0.001) and value <= 10000
        end
        local function append(list, value, size)
            if #list >= size then table.remove(list, 1) end
            table.insert(list, value)
        end
        local sortedScratch, deviationScratch = {}, {}
        P.WorkSorted, P.WorkDeviations = sortedScratch, deviationScratch
        local function ordered(list)
            table.clear(sortedScratch)
            for i = 1, #list do sortedScratch[i] = list[i] end
            table.sort(sortedScratch)
            return sortedScratch
        end
        local function percentile(sorted, fraction)
            if #sorted == 0 then return 0 end
            local index = 1 + (#sorted - 1) * fraction
            local low, high = math.floor(index), math.ceil(index)
            return sorted[low] + (sorted[high] - sorted[low]) * (index - low)
        end
        local function quantile(list, fraction)
            return percentile(ordered(list), fraction)
        end
        local function spread(list)
            local sorted = ordered(list)
            local center = percentile(sorted, 0.5)
            local lower, upper, tail = percentile(sorted, 0.25), percentile(sorted, 0.75), percentile(sorted, 0.85)
            table.clear(deviationScratch)
            for i = 1, #sorted do deviationScratch[i] = math.abs(sorted[i] - center) end
            table.sort(deviationScratch)
            local noise = math.max(percentile(deviationScratch, 0.5) * 1.4826, (upper - lower) / 1.349)
            return center, noise, lower, upper, tail
        end
        local function ingest(F, value, now, native, corroborated)
            if value ~= F.Raw then F.RawChangedAt = now end
            F.Raw = value
            append(F.RawWindow, value, 9)
            if not F.Estimate then
                F.Estimate, F.Window, F.Slope, F.UpperQuantile, F.RawNoise = value, {value}, 0, value, 0
            else
                local center, noise = spread(F.Window)
                local _, rawNoise, lower, upper = spread(F.RawWindow)
                F.RawNoise = rawNoise
                local bothSides = #F.RawWindow >= 7 and lower < center - (native and 4 or 8)
                    and upper > center + (native and 4 or 8)
                local limit = math.max(native and 10 or 20, center * 0.2,
                    math.min(native and 40 or 80, noise * 3))
                 
                 
                local turns, lastDirection = 0, 0
                for i = 2, #F.RawWindow do
                    local change = F.RawWindow[i] - F.RawWindow[i - 1]
                    if math.abs(change) > (native and 3 or 6) then
                        local direction = change > 0 and 1 or -1
                        if lastDirection ~= 0 and direction ~= lastDirection then turns += 1 end
                        lastDirection = direction
                    end
                end
                local oscillating = turns >= 3 and upper - lower > (native and 8 or 16)
                local jitterEvidence = (bothSides or oscillating)
                    and (corroborated or rawNoise <= math.max(native and 80 or 160, center))
                if jitterEvidence then limit = math.max(limit, rawNoise * 3) end
                local stale = now - F.AcceptedAt > 3
                if math.abs(value - center) > limit or stale then
                    local pending = F.Pending
                    local sameSide = pending and ((value - center) * (pending.Value - center) > 0 or stale)
                    local close = pending and math.abs(value - pending.Value) <= math.max(corroborated and limit * 2 or limit, math.abs(pending.Value - center) * 0.25)
                    if pending and sameSide and close and now - pending.At <= 0.6 then
                         
                        pending.Dwell = corroborated and 0.065 or 0.085
                        if now - pending.At < pending.Dwell then return false end
                        F.Estimate, F.Window, F.RawWindow = (pending.Value + value) * 0.5, {pending.Value, value}, {pending.Value, value}
                        F.UpperQuantile = math.min(pending.Value, value) + math.abs(value - pending.Value) * 0.85
                        F.RawNoise = math.abs(value - pending.Value) * 0.5 * 1.4826
                        F.Noise = math.min(F.Noise, math.abs(value - pending.Value) * 0.5)
                        F.Pending, F.Slope, F.Trend, F.Run = nil, 0, 0, 0
                        F.Changes += 1
                    else
                        F.Pending = {Value = value, At = now, Dwell = corroborated and 0.065 or 0.085}; F.Rejected += 1
                        return false
                    end
                else
                    F.Pending = nil
                    local previous = F.Estimate
                    local difference = value - previous
                    local direction = difference > 0 and 1 or difference < 0 and -1 or 0
                    F.Run = direction ~= 0 and direction == F.Direction and F.Run + 1 or 1
                    F.Direction = direction
                    local coherent = F.Run >= 2 and math.abs(difference) > math.max(3, F.Noise * 0.75)
                    local alpha = coherent and (direction > 0 and 0.65 or 0.55)
                        or (F.Noise > 2 and 0.25 or (direction > 0 and 0.4 or 0.35))
                    local dt = math.clamp(now - F.AcceptedAt, 0.001, 0.3)
                    alpha = 1 - (1 - alpha) ^ (dt / 0.1)
                    F.Estimate = previous + difference * alpha
                    local slopeAlpha = 1 - 0.6 ^ (dt / 0.1)
                    F.Slope += ((F.Estimate - previous) / dt - F.Slope) * slopeAlpha
                    F.Trend = coherent and math.max(0, F.Slope) * 0.1 or 0
                    append(F.Window, value, 16)
                    local _, acceptedNoise, _, _, upperQuantile = spread(F.Window)
                    F.UpperQuantile = upperQuantile
                    if jitterEvidence then acceptedNoise = math.max(acceptedNoise, rawNoise) end
                    acceptedNoise = math.min(acceptedNoise, native and 30 or 60)
                    local noiseAlpha = 1 - (acceptedNoise > F.Noise and 0.65 or 0.8) ^ (dt / 0.1)
                    F.Noise += (acceptedNoise - F.Noise) * noiseAlpha
                end
            end
            F.AcceptedAt, F.AcceptedRaw = now, value
            F.Tail = math.max(0, (F.UpperQuantile or F.Estimate) - F.Estimate)
            return true
        end
        local function calibrate(value, now)
            if not N.AcceptedAt or now - N.AcceptedAt > 0.15 or not N.AcceptedRaw or N.AcceptedRaw <= 0 then return end
            if math.abs(now - N.AcceptedAt) > 1e-6 then return end
            if P.Ratio and #P.Ratios >= 4 then
                local statsNoise, nativeNoise = P.RawNoise or 0, N.RawNoise or 0
                if statsNoise > math.max(3, P.Estimate * 0.04) or nativeNoise > math.max(1, N.Estimate * 0.04) then return end
            end
            local candidate = value / N.AcceptedRaw
            if candidate < 0.5 or candidate > 4 then P.RatioCandidates = nil; return end
            if P.Ratio and math.abs(candidate / P.Ratio - 1) > 0.2 then
                 
                if #P.Ratios >= 4 then return end
                P.RatioCandidates = P.RatioCandidates or {}
                append(P.RatioCandidates, candidate, 3)
                if #P.RatioCandidates < 3 then return end
                local center, noise = spread(P.RatioCandidates)
                if noise > center * 0.1 then return end
                P.Ratio, P.Ratios, P.RatioCandidates = center, table.clone(P.RatioCandidates), nil
                return
            end
            P.RatioCandidates = nil
            append(P.Ratios, candidate, 9)
            local target = quantile(P.Ratios, 0.5)
            P.Ratio = P.Ratio and P.Ratio + (target - P.Ratio) * 0.1 or target
        end
        local function agreement(stats, native)
            return P.Ratio and valid(stats, false) and valid(native, false)
                and math.abs(stats - native * P.Ratio) <= math.max(12, math.min(stats * 0.15, 50))
        end
        local function ingestStats(value, now, synchronized, observedAt, nativeAccepted)
            if P.Destroyed or not valid(value, false) then return false end
            if value ~= P.Raw then P.FrozenCount = 0 end
            local corroborated = synchronized ~= false and N.ObservedAt and now >= N.ObservedAt
                and now - N.ObservedAt <= 0.15 and agreement(value, N.Raw)
            local accepted = ingest(P, value, now, false, corroborated)
            if accepted then
                P.AcceptedObservedAt = observedAt or now
                u1070.cache.ping = P.Estimate
                if synchronized ~= false and nativeAccepted ~= false then calibrate(value, now) end
            end
            return accepted
        end
        function P.Ingest(value)
            return ingestStats(value, u1066())
        end
        function P.RecordFrame(delta)
            if P.Destroyed or not valid(delta, false) or delta < 0.001 or delta > 0.5 then return end
            local now = u1066()
            if P.FrameAt and (now < P.FrameAt or now - P.FrameAt > 0.5) then
                table.clear(P.Frames)
                P.FrameElapsed, P.FrameMargin, P.FrameSeconds = 0, 0, nil
            end
            P.FrameAt = now
            append(P.Frames, delta * 1000, 32)
            P.FrameElapsed = (P.FrameElapsed or 0) + delta
            if #P.Frames < 12 or P.FrameElapsed < 0.1 then return end
            P.FrameElapsed = 0
            local frames = ordered(P.Frames)
            P.FrameSeconds = math.clamp(percentile(frames, 0.75) / 1000, 0.004, 0.05)
            local target = math.clamp(percentile(frames, 0.9) - 20, 0, 12)
            P.FrameMargin += (target - P.FrameMargin) * (target > P.FrameMargin and 0.55 or 0.65)
            if P.FrameMargin < 0.01 then P.FrameMargin = 0 end
        end
        local function base()
            local now = u1066()
            local statsAt = P.AcceptedObservedAt or P.AcceptedAt
            local networkAt = N.AcceptedObservedAt or N.AcceptedAt
            local statsFresh = statsAt and now >= statsAt and now - statsAt <= 0.75
            local networkFresh = networkAt and now >= networkAt and now - networkAt <= 0.5 and (N.Estimate > 0 or not P.Estimate)
            local recovering = P.StatsFailures >= 2 or P.Recovering and P.StatsRecovery < 2
            if P.Estimate and statsFresh and (P.FrozenCount or 0) < 3 and not P.Pending and not recovering then
                return P.Estimate, "stats", P.Noise, P.Trend, statsAt
            end
            if networkFresh then return math.clamp(N.Estimate * (P.Ratio or 1), 0, 10000), "network",
                math.min(N.Noise * (P.Ratio or 1), 60), N.Trend * (P.Ratio or 1), networkAt end
            if P.Estimate and (P.FrozenCount or 0) < 3 and P.StatsFailures < 2
                and P.AcceptedAt >= (P.LastEffectiveAt or -math.huge) then
                return P.Estimate, "last valid", 0, 0, statsAt
            end
            if P.LastEffective or P.Estimate then return P.LastEffective or P.Estimate, "last valid", 0, 0, P.LastEffectiveAt or P.AcceptedAt end
            return 50, "default", 0, 0, nil
        end
        function P.Get() return (base()) end
        function P.Jitter() local _, _, noise = base(); return noise end
        local function compensation()
            local value, source, noise, trend, at = base()
            local now = u1066()
            local live = source == "stats" or source == "network"
            local tail = source == "stats" and (P.Tail or 0)
                or source == "network" and (N.Tail or 0) * (P.Ratio or 1) or 0
            local margin = live and math.min(8, math.max(noise * 0.25, tail * 0.35) + trend * 0.35) or 0
            local framesFresh = P.FrameAt and now >= P.FrameAt and now - P.FrameAt <= 0.5
            local frameMargin = framesFresh and P.FrameMargin or 0
            local total = math.clamp(margin + frameMargin, 0, 20)
            return value + total, value, noise, total, frameMargin, framesFresh, source, at, now, live, tail
        end
        function P.Snapshot()
            local compensated, value, noise, total, frameMargin, framesFresh, source, at, now, live, tail = compensation()
            return {NetworkPing = value, CompensationPing = compensated, Jitter = noise,
                Margin = total, FrameMargin = frameMargin, FrameSeconds = framesFresh and P.FrameSeconds or 1 / 60,
                Source = source, Age = at and math.max(0, now - at) or math.huge, At = now,
                Live = live, Tail = tail, Calibrated = P.Ratio ~= nil and #P.Ratios >= 4}
        end
        function P.Parry() return (compensation()) end
        local function pollInterval(now)
            local nativeAlive = N.AcceptedAt and now - N.AcceptedAt <= 0.5 and N.Estimate > 0
            if P.StatsFailures >= 8 and not nativeAlive then return 0.25 end
            return P.FastUntil and now < P.FastUntil and 0.05 or 0.1
        end
        function P.Diagnostics()
            local snapshot = P.Snapshot()
            return {NetworkPing = snapshot.NetworkPing, CompensationPing = snapshot.CompensationPing, Jitter = snapshot.Jitter,
                Margin = snapshot.Margin, FrameMargin = snapshot.FrameMargin, Source = snapshot.Source,
                Tail = snapshot.Tail, Live = snapshot.Live, Calibrated = snapshot.Calibrated, FrameSeconds = snapshot.FrameSeconds,
                RejectedSpikes = P.Rejected, ConfirmedChanges = P.Changes, Samples = #P.Window,
                NativeRejectedSpikes = N.Rejected, CalibrationSamples = #P.Ratios, Scale = P.Ratio,
                Age = snapshot.Age, SensorSkew = P.SensorSkew, Synchronized = P.Synchronized,
                ConfirmationAt = P.ConfirmationAt, ExpiredReads = P.ExpiredReads or 0,
                PollInterval = pollInterval(u1066())}
        end
        local function refreshSamples()
            local started = u1066()
            P.LastPollAt = started
            if not statsItem or not statsItem.Parent or not statsItem:IsDescendantOf(u1059) then
                local folder = u1059:FindFirstChild("Network")
                local items = folder and folder:FindFirstChild("ServerStatsItem")
                statsItem = items and items:FindFirstChild("Data Ping")
            end
            local statsOK, raw = false, nil
            local readItem = statsItem
            if readItem then statsOK, raw = pcall(readItem.GetValue, readItem) end
            local statsCompleted = u1066()
            if P.Destroyed then return false end
            local nativeStarted = u1066()
            local ok, network = pcall(function() return u1061:GetNetworkPing() * 1000 end)
            if P.Destroyed then return false end
             
             
            local now = u1066()
            local statsTimely = now >= started and now - started <= 0.15
            local nativeTimely = now >= nativeStarted and now - nativeStarted <= 0.15
            statsOK = statsOK and statsTimely and valid(raw, false) and readItem == statsItem
                and readItem.Parent ~= nil and readItem:IsDescendantOf(u1059)
            if not statsTimely or not nativeTimely then P.ExpiredReads = (P.ExpiredReads or 0) + 1 end
            local nativeOK = ok and nativeTimely and valid(network, true) and (network > 0 or not P.Estimate)
            P.SensorSkew = math.max(0, now - statsCompleted)
            P.Synchronized = statsOK and nativeOK and P.SensorSkew <= 0.05
                and statsCompleted >= started and statsCompleted - started <= 0.05
            local nativeAccepted = false
            if nativeOK then
                N.ObservedAt = nativeStarted
                nativeAccepted = ingest(N, network, now, true, P.Synchronized and agreement(raw, network))
                if nativeAccepted then
                    N.AcceptedObservedAt = nativeStarted
                end
            end
            P.Network, P.NetworkAt, P.NetworkRaw = N.Estimate, N.AcceptedAt, N.AcceptedRaw
            if statsOK then
                P.StatsRecovery += 1
                local accepted = ingestStats(raw, now, P.Synchronized, started, nativeAccepted)
                if P.StatsRecovery >= 2 and accepted then P.Recovering = false end
                P.StatsFailures = 0
            else
                P.StatsFailures += 1; P.StatsRecovery = 0
                if P.StatsFailures >= 2 then P.Recovering = true end
            end
            local nativeFresh = N.AcceptedAt and now - N.AcceptedAt <= 0.5 and N.Estimate > 0
            if P.Estimate and P.Ratio and #P.Ratios >= 4 and nativeFresh then
                local disagreement = math.abs(N.Estimate * P.Ratio - P.Estimate)
                local threshold = math.max(18, P.Estimate * 0.15, math.min(40, (P.Noise + N.Noise * P.Ratio) * 0.75))
                local frozen = P.RawChangedAt and now - P.RawChangedAt >= 0.25 and disagreement > threshold
                    and ((P.FrozenCount or 0) >= 3 or N.RawChangedAt and now - N.RawChangedAt <= 0.75)
                P.FrozenCount = frozen and (P.FrozenCount or 0) + 1 or 0
            end
            if P.Pending or N.Pending or P.StatsFailures > 0 or (P.FrozenCount or 0) > 0
                or P.Noise > 12 or N.Noise * (P.Ratio or 1) > 12 or P.Trend > 2 then P.FastUntil = now + 0.75 end
            P.ConfirmationAt = nil
            for _, filterState in ipairs({P, N}) do
                local pending = filterState.Pending
                local available = filterState == P and statsOK or filterState == N and nativeOK
                if pending and available and now >= pending.At and now - pending.At <= 0.6 then
                    local deadline = math.max(now + 0.01, pending.At + (pending.Dwell or 0.085))
                    P.ConfirmationAt = math.min(P.ConfirmationAt or math.huge, deadline)
                end
            end
            local value, source, _, _, at = base()
            if (source == "stats" or source == "network") and value > 0 then P.LastEffective, P.LastEffectiveAt = value, at end
            u1070.cache.ping = value
            return true
        end
        function P.Refresh()
            if P.Destroyed or P.Refreshing then return false end
            local token = {}
            P.Refreshing = token
            local ok, result = pcall(refreshSamples)
            if P.Refreshing == token then P.Refreshing = nil end
            if not ok then P.RefreshError = tostring(result); P.ConfirmationAt = nil; return false end
            P.RefreshError = nil
            return result
        end
        function P.Destroy()
            P.Destroyed, P.Refreshing = true, nil
            if P.Connection then P.Connection:Disconnect(); P.Connection = nil end
            statsItem = nil
            for _, list in ipairs({P.Window, P.RawWindow, P.Frames, P.Ratios, N.Window, N.RawWindow, sortedScratch, deviationScratch}) do table.clear(list) end
            P.Pending, N.Pending, P.RatioCandidates, P.ConfirmationAt = nil, nil, nil, nil
        end
        u1070.cache.get_ping, u1070.cache.get_ping_jitter, u1070.cache.get_parry_ping = P.Get, P.Jitter, P.Parry
        P.Refresh()
        local elapsed = 0
        P.Connection = u1063:Connect(function(delta)
            if not valid(delta, true) then return end
            elapsed += delta
            if P.Refreshing then return end
            local now = u1066()
            local interval = pollInterval(now)
            local scheduled = elapsed + 1e-9 >= interval
            local confirmation = P.ConfirmationAt and now + 1e-9 >= P.ConfirmationAt
                and (not P.LastPollAt or now - P.LastPollAt >= 0.01 - 1e-9)
            if scheduled or confirmation then
                elapsed = scheduled and math.max(0, elapsed - math.floor((elapsed + 1e-9) / interval) * interval) or 0
                P.Refresh()
            end
        end)
    end
    initializeAdaptivePing()
end

local function u1075()
    if u1070.config.is_mobile then
        u1060:SendMouseButtonEvent(0, 0, 0, true, u796, 0)
        u1060:SendMouseButtonEvent(0, 0, 0, false, u796, 0)
    else
        u1060:SendKeyEvent(true, u824.KeyCode.F, false, u796)
        u1060:SendKeyEvent(false, u824.KeyCode.F, false, u796)
    end
end

local function u1076()
    if u864.normalize_curve_method(u1070.config.curve_method) == "Camera" and u1070.config.parry_mode == "Keypress" then
        u1075()
        return
    end

    local r0 = u1070.curve.get_cframe()
    local r8 = u1062.CFrame
    u1062.CFrame = r0

    if u1070.config.is_mobile then
        u1060:SendMouseButtonEvent(0, 0, 0, true, u796, 0)
        u1060:SendMouseButtonEvent(0, 0, 0, false, u796, 0)
    else
        u1060:SendKeyEvent(true, u824.KeyCode.F, false, u796)
        u1060:SendKeyEvent(false, u824.KeyCode.F, false, u796)
    end

    u1064:Wait()
    u1062.CFrame = r8
end

local function u1077(u1078)
    local r2 = tonumber(u1078)

    if r2 then
        return r2
    end

    local function r4()
        return u1054:GetUserIdFromNameAsync(tostring(u1078))
    end

    local r3, r4_2 = pcall(r4)
    return r3 and r4_2 or nil
end

local function u1079(r0, r1, r2)
    local r8 = u858()
    local u1080 = u847("TextButton")
    u1080.Size = u821.new(0, 120, 0, 48)
    u1080.Position = u821.new(0.5, -60, r1, 0)
    u1080.BackgroundTransparency = 1
    u1080.AnchorPoint = Vector2.new(0.5, 0)
    u1080.AutoButtonColor = false
    u1080.ZIndex = 2
    u1080.Text = ""
    u1080.Parent = r8
    local r10 = u847("Frame")
    r10.Size = u821.new(1, 0, 1, 0)
    r10.BackgroundColor3 = u820.fromRGB(18, 18, 24)
    r10.BorderSizePixel = 0
    r10.Parent = u1080
    local r6 = u847("UICorner")
    r6.CornerRadius = u822.new(0, 10)
    r6.Parent = r10
    local r3 = u847("UIStroke")
    r3.Color = r2
    r3.Thickness = 1.5
    r3.Transparency = 0.3
    r3.Parent = r10
    local r10_2 = u847("TextLabel")
    r10_2.Size = u821.new(1, 0, 1, 0)
    r10_2.BackgroundTransparency = 1
    r10_2.Text = r0
    r10_2.Font = u824.Font.GothamBold
    r10_2.TextSize = 14
    r10_2.TextColor3 = u820.fromRGB(235, 234, 239)
    r10_2.ZIndex = 3
    r10_2.Parent = u1080
    local u1081 = false
    local u1082
    local u1083

    u1080.InputBegan:Connect(function(r0)
        if r0.UserInputType == u824.UserInputType.Touch then
            u1081 = true
            u1082 = r0.Position
            u1083 = u1080.Position
        end
    end)

    u1080.InputChanged:Connect(function(r0)
        local r2 = u1081

        if not u1081 or r0.UserInputType ~= u824.UserInputType.Touch then
            return
        end

        local r1 = r0.Position - u1082

        if r1.Magnitude > 8 then
            u1080.Position = u821.new(u1083.X.Scale, u1083.X.Offset + r1.X, u1083.Y.Scale, u1083.Y.Offset + r1.Y)
        end
    end)

    u1080.InputEnded:Connect(function(r0)
        if r0.UserInputType == u824.UserInputType.Touch then
            u1081 = false
        end
    end)

    return {gui = r8, button = u1080, label = r10_2}
end

local u1084 = u1057

local u1091 = u1057
__S[49] = u1091:WaitForChild("Shared", 9000000000):WaitForChild("ReplicatedInstances", 9000000000):WaitForChild("Swords", 9000000000)
local u1092 = require(__S[49])

u828.spawn(function()
    while task.wait() and not u1070.sword_changer.swords_controller do
        for r1, r2 in u800(u1091.Remotes.FireSwordInfo.OnClientEvent) do
            if r2.Function and u804(r2.Function) then
                local r3 = u801(r2.Function)

                if #r3 == 1 and type(r3[1]) == "table" then
                    u1070.sword_changer.swords_controller = r3[1]
                    break
                end
            end
        end
    end
end)

u828.spawn(function()
    local r4

    while task.wait() and not r4 do
        for r2, r3 in u800(u1091.Remotes.ParrySuccessAll.OnClientEvent) do
            if r3.Function and u803(r3.Function).name == "parrySuccessAll" then
                u1070.sword_changer.parry_func = r3.Function
                r3:Disable()
                r4 = r3
                break
            end
        end
    end

    local u1093
    local r1 = u1093

    while task.wait() and not r1 do
        for r5, r6 in u800(u1091.Remotes.ParrySuccessClient.Event) do
            if r6.Function and u803(r6.Function).name == "parrySuccessAll" then
                r6:Disable()
                r1 = r6
                break
            end
        end
    end

    u1091.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
        if not u1070.sword_changer.loaded then
            return u1070.sword_changer.parry_func(...)
        end

        setthreadidentity(2)
        local r5 = {...}
        local r7 = select("#", ...)

        if u1070.sword_changer.enabled and u1070.sword_changer.fx ~= "" then
            if 4 <= r7 and typeof(r5[4]) == "Instance" and r5[4]:IsA("Player") then
                if r5[4] == u1061 then
                    r5[1] = u1070.sword_changer.slash_name
                    r5[3] = u1070.sword_changer.fx
                end
            else
                local r0 = u1061.Character

                if r0 and typeof(r5[2]) == "Instance" then
                    local r3 = r5[2]

                    if r3 ~= r0 then
                        r3 = r5[2].Parent
                        local r2 = r3 == r0
                    end

                    if r3 == r0 then
                        r5[1] = u1070.sword_changer.slash_name
                        r5[3] = u1070.sword_changer.fx
                    end
                end
            end
        end

        return u1070.sword_changer.parry_func(unpack(r5, 1, r7))
    end)
end)

local u1094 = __S[19](u1092, "EquipSwordTo")
local u1095

for r8_8, r9_7 in u812(u801(u1094)) do
    if u809(r9_7) == "table" and u809(__S[19](r9_7, "getInstance")) == "function" then
        u1095 = r9_7
        break
    end
end

__S[23](u1095, "u8 not found")
local u1096
__S[7] = nil

for r11_7, r12_2 in u812(u801(u1095.getInstance)) do
    if u809(r12_2) == "table" then
        if __S[19](r12_2, "Collections") and not u1096 then
            u1096 = r12_2
        end

        if u809(__S[19](r12_2, "deserialize")) == "function" and not __S[7] then
            __S[7] = r12_2.deserialize
        end
    end
end

__S[23](u1096, "u46 not found")
__S[23](u809(__S[7]) == "function", "deserialize_fn not found")
local u1097
local u1098
local u1099

for r14_3, r15_3 in u812(u801(__S[7])) do
    if u810(r15_3) == "Instance" and r15_3.ClassName == "HttpService" then
        u1097 = r15_3
    elseif u809(r15_3) == "table" then
        if u809(__S[19](r15_3, "decode")) == "function" and not u1098 then
            u1098 = r15_3
        else
            __S[7] = u809(__S[19](r15_3, "deserialize")) == "function"

            if __S[7] and u809(__S[19](r15_3, "serialize")) == "function" then
                __S[7] = not u1099

                if __S[7] then
                    u1099 = r15_3
                end
            end
        end
    end
end

if not u1097 then
    u1097 = u796:GetService("HttpService")
end

__S[23](u1098, "roblox_buff_dyn not found")
__S[23](u1099, "instance_serializer not found")

local u1100 = (function()
    if not u1096.Collections then
        return nil
    end

    if u1096.Collections.Swords then
        return "Swords"
    end

    for r2, r3 in pairs(u1096.Collections) do
        if type(r2) == "string" and r2:lower() == "swords" then
            return r2
        end
    end

    return nil
end)()

local function u1101(u1102)
    if u1070.sword_changer.model_cache[u1102] and u1070.sword_changer.model_cache[u1102].Parent then
        return u1070.sword_changer.model_cache[u1102]:Clone()
    end

    local r3

    if u1100 then
        local r4 = u1096.Collections[u1100]
        r3 = nil

        if r4 and r4.Instances then
            r3 = r4.Instances[u1102]
        end
    end

    if not r3 then
        local u1103 = u1100 or "Swords"

        local function r11()
            return u1096:GetInstance(u1103, u1102)
        end

        local r10, r11_2 = pcall(r11)

        if r10 then
            r3 = r11_2 or r3
        end
    end

    if not r3 then
        return nil
    end

    local function r6(r0)
        local r10

        if r0:IsA("StringValue") then
            r10 = r0.Value
        else
            if not r0:IsA("ModuleScript") then
                return nil
            end

            local r3 = getthreadidentity()
            setthreadidentity(6)
            local r5, r6 = pcall(require, r0)
            local r8 = r6
            setthreadidentity(r3)

            if not r5 then
                return nil
            elseif type(r8) == "string" then
                r10 = r8
            else
                if typeof(r8) == "buffer" then
                    local r6_2, r7 = pcall(u1098.decode, r8)

                    if not r6_2 then
                        return nil
                    end

                    local r9 = {}

                    for r3_2, r4 in r0:GetChildren() do
                        r9[r4.Name] = r4
                    end

                    local r4_2, r5_2 = pcall(u1099.deserialize, r7, r9)

                    if r4_2 then
                        return r5_2
                    end

                    return nil
                end

                r10 = nil

                if type(r8) == "table" then
                    local r6_3, r7_2 = pcall(u1098.decode, r8)
                    local r2 = r7_2

                    if r6_3 then
                        local r3_3 = {}

                        for r6_4, r7_3 in r0:GetChildren() do
                            r3_3[r7_3.Name] = r7_3
                        end

                        local r4_3, r5_3 = pcall(u1099.deserialize, r2, r3_3)

                        if r4_3 then
                            return r5_3
                        end
                    end

                    local r5_4, r6_5 = pcall(u1097.JSONEncode, u1097, r8)
                    r10 = r6_5

                    if not r5_4 then
                        r10 = nil
                    end
                end
            end
        end

        if not r10 or r10 == "" then
            return nil
        end

        local r7_4, r8_2 = pcall(u1097.JSONDecode, u1097, r10)

        if not r7_4 then
            return nil
        end

        local r6_6, r7_5 = pcall(u1098.decode, r8_2)

        if not r6_6 then
            return nil
        end

        local r3_4 = {}

        for r9_2, r10_2 in r0:GetChildren() do
            r3_4[r10_2.Name] = r10_2
        end

        local r5_5, r6_7 = pcall(u1099.deserialize, r7_5, r3_4)

        if not r5_5 then
            return nil
        end

        return r6_7
    end

    local r5

    if typeof(r3) == "Instance" and r3:IsA("Model") then
        r5 = r3:Clone()
    elseif typeof(r3) == "Instance" and r3:IsA("Tool") then
        r5 = u850.new("Model")
        r5.Name = u1102
        local r10_2 = r3:Clone()
        r10_2.Name = u1102
        r10_2.Parent = r5
        local r9 = r10_2:FindFirstChildWhichIsA("BasePart", true)

        if r9 then
            r5.PrimaryPart = r9
        end
    else
        if typeof(r3) ~= "Instance" or not r3:IsA("StringValue") and not r3:IsA("ModuleScript") then
            return nil
        end

        r5 = r6(r3)

        if not r5 then
            return nil
        elseif not r5:IsA("Model") then
            if r5:IsA("Tool") then
                r5.Name = u1102
                local r4_2 = u850.new("Model")
                r4_2.Name = u1102
                r5.Parent = r4_2
                local r9_2 = r5:FindFirstChildWhichIsA("BasePart", true)

                if r9_2 then
                    r4_2.PrimaryPart = r9_2
                    r5 = r4_2
                else
                    r5 = r4_2
                end
            else
                local r6_2 = u850.new("Model")
                r6_2.Name = u1102
                r5.Parent = r6_2
                local r9_3 = r5:IsA("BasePart") and r5 or r5:FindFirstChildWhichIsA("BasePart", true)

                if r9_3 then
                    r6_2.PrimaryPart = r9_3
                    r5 = r6_2
                else
                    r5 = r6_2
                end
            end
        end
    end

    if not r5 then
        return nil
    end

    local r9_4 = r5:FindFirstChildWhichIsA("Tool", true)

    if r9_4 and r9_4.Name ~= u1102 then
        r9_4.Name = u1102
    end

    u1070.sword_changer.model_cache[u1102] = r5
    return r5:Clone()
end

local function u1104(r0, u1106)
    local u1105 = u1101(u1106)

    if not u1105 then
        return
    end

    local r302 = u801(u1094)
    local r16
    local r12

    for r3, r4 in ipairs(r302) do
        if r4 == u1095 then
            if not r16 then
                r16 = r3
            elseif type(r4) == "boolean" and not r12 then
                r12 = r3
            end
        elseif type(r4) == "boolean" and not r12 then
            r12 = r3
        end
    end

    if not r16 then
        return
    end

    local r17 = {
        getInstance = function(r0, r1)
            if r1 == u1106 then
                return u1105
            end

            return u1101(r1)
        end
    }

    if r12 then
        u802(u1094, r12, false)
    end

    u802(u1094, r16, r17)
    pcall(u1092.EquipSwordTo, u1092, r0, u1106)
    u802(u1094, r16, u1095)

    if r12 then
        u802(u1094, r12, true)
    end
end

local function u1107(r0)
    if not r0 or r0 == "" then
        return "SlashEffect"
    end

    local r2 = u1092:GetSword(r0)

    if r2 then
        r2 = r2.SlashName
    end

    if not r2 then
        r2 = "SlashEffect"
    end

    return r2
end

local function u1108()
    if not u1070.sword_changer.enabled or not u1070.sword_changer.loaded then
        return
    end

    local r0 = u1061.Character

    if not r0 then
        return
    end

    if u1070.sword_changer.model ~= "" then
        u1104(r0, u1070.sword_changer.model)
    end

    if u1070.sword_changer.animations ~= "" and u1070.sword_changer.swords_controller then
        u1070.sword_changer.swords_controller:SetSword(u1070.sword_changer.animations)
    end
end

__S[261] = function()
    if u1070.sword_changer.original.saved then
        return
    end

    local r1 = u1061.Character

    if not r1 then
        return
    end

    local r3 = r1:GetAttribute("CurrentlyEquippedSword") or u1061:GetAttribute("CurrentlyEquippedSword")

    if r3 then
        u1070.sword_changer.original.model = r3
        u1070.sword_changer.original.saved = true
    end
end

u1070.sword_changer.save_original = __S[261]

__S[263] = function()
    if not u1070.sword_changer.original.saved then
        return
    end

    local r0 = u1061.Character

    if not r0 then
        return
    end

    u1104(r0, u1070.sword_changer.original.model)

    if u1070.sword_changer.swords_controller then
        u1070.sword_changer.swords_controller:SetSword(u1070.sword_changer.original.model)
    end
end

u1070.sword_changer.restore_original = __S[263]

function u1070.sword_changer.update()
    if not u1070.sword_changer.loaded then
        return
    end

    if u1070.sword_changer.fx ~= "" then
        u1070.sword_changer.slash_name = u1107(u1070.sword_changer.fx)
    end

    u1108()
end

u828.spawn(function()
    while task.wait(1) do
        if not (not u1070.sword_changer.enabled or not u1070.sword_changer.loaded) then
            local r4 = u1061.Character

            if r4 then
                if u1070.sword_changer.model ~= "" then
                    if u1061:GetAttribute("CurrentlyEquippedSword") ~= u1070.sword_changer.model then
                        u1108()
                    end

                    if not r4:FindFirstChild(u1070.sword_changer.model) then
                        u1108()
                    end

                    for r1, r2 in r4:GetChildren() do
                        if r2:IsA("Model") and r2.Name ~= u1070.sword_changer.model then
                            r2:Destroy()
                        end
                    end
                end

                if u1070.sword_changer.animations ~= "" and u1070.sword_changer.swords_controller then
                    u1070.sword_changer.swords_controller:SetSword(u1070.sword_changer.animations)
                end
            end
        end
    end
end)

__S[3] = function()
    if u1070.avatar_changer.original_desc then
        return
    end

    local u1109 = u1070.avatar_changer.saving_original

    if u1109 then
        return
    end

    u1070.avatar_changer.saving_original = true

    task.spawn(function()
        for r2 = 1, 5 do
            local function r1()
                return u1054:GetHumanoidDescriptionFromUserIdAsync(u1061.UserId)
            end

            local r0, r1_2 = pcall(r1)

            if r0 and r1_2 then
                u1070.avatar_changer.original_desc = r1_2
                break
            end

            task.wait(0.3 * r2)
        end

        u1070.avatar_changer.saving_original = false
    end)
end

u1070.avatar_changer.save_original = __S[3]

__S[3] = function(u1110)
    if u1070.avatar_changer.cache[u1110] then
        return u1070.avatar_changer.cache[u1110]
    end

    for r2 = 1, 5 do
        local function r6()
            return u1054:GetHumanoidDescriptionFromUserIdAsync(u1110)
        end

        local r5, r6_2 = pcall(r6)

        if r5 and r6_2 then
            u1070.avatar_changer.cache[u1110] = r6_2
            return r6_2
        elseif r2 < 5 then
            task.wait(0.2 * r2)
        end
    end

    return nil
end

u1070.avatar_changer.get_description = __S[3]

__S[3] = function(u1111, r1)
    if not r1 then
        r1 = u824.HumanoidRigType.R15
    end

    local function r2(u1112)
        local function r6()
            return u1054:CreateHumanoidModelFromDescriptionAsync(u1111, u1112, u824.AssetTypeVerification.Always)
        end

        local r5, r6_2 = pcall(r6)

        if not r5 or not r6_2 then
            local function r3()
                return u1054:CreateHumanoidModelFromDescriptionAsync(u1111, u1112)
            end

            r5, r6_2 = pcall(r3)
        end

        if not r5 or not r6_2 then
            return nil
        end

        r6_2.Name = "ZenthraAvatarPreview"
        r6_2.Parent = u1057

        pcall(function()
            u1055.Heartbeat:Wait()
        end)

        return r6_2
    end

    local r3 = r2(r1)

    if r3 then
        return r3
    end

    return r2(r1 == u824.HumanoidRigType.R15 and u824.HumanoidRigType.R6 or u824.HumanoidRigType.R15)
end

u1070.avatar_changer.create_temp_model = __S[3]

__S[3] = function(r0)
    local r291 = r0:GetDescendants()

    for r2, r3 in ipairs(r291) do
        if r3:IsA("Weld") or r3:IsA("Motor6D") or r3:IsA("WeldConstraint") then
            r3:Destroy()
        end
    end
end

u1070.avatar_changer.strip_accessory_joints = __S[3]

__S[3] = function(r0, r1)
    if not r1 or r1 == "" then
        return nil
    end

    local r12 = r0:FindFirstChild(r1)

    if r12 and r12:IsA("BasePart") then
        return r12
    end

    local r7 = {
        ["Left Arm"] = {"LeftUpperArm", "LeftLowerArm", "LeftHand"},
        ["Right Arm"] = {"RightUpperArm", "RightLowerArm", "RightHand"},
        ["Left Leg"] = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        ["Right Leg"] = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        Torso = {"UpperTorso", "LowerTorso"}
    }

    local r4 = r7[r1] or {}

    for r4_2, r5 in ipairs(r4) do
        local r12_2 = r0:FindFirstChild(r5)

        if r12_2 and r12_2:IsA("BasePart") then
            return r12_2
        end
    end

    return nil
end

u1070.avatar_changer.find_body_part = __S[3]

__S[3] = function(r0, u1116, r2)
    if not r0 or not r2 then
        return false
    end

    local u1115 = r2:Clone()
    u1070.avatar_changer.strip_accessory_joints(u1115)
    local r7 = u1115:FindFirstChild("Handle")

    if not r7 or not r7:IsA("BasePart") then
        u1115:Destroy()
        return false
    end

    r7.Anchored = false
    r7.CanCollide = false
    r7.Massless = true
    local r3 = r2:FindFirstChild("Handle")

    if r3 then
        r3 = r3:FindFirstChild("AccessoryWeld")
    end

    local r17 = u819.new()
    local r18 = u819.new()
    local r9

    if r3 and r3:IsA("Weld") and r3.Part1 then
        r9 = u1070.avatar_changer.find_body_part(r0, r3.Part1.Name)
        r17 = r3.C0
        r18 = r3.C1
    end

    local r16

    if not r9 then
        local r2_2 = r7:FindFirstChildOfClass("Attachment")

        if r2_2 then
            local r305 = r0:GetDescendants()

            for r4, r5 in ipairs(r305) do
                if r5:IsA("Attachment") and r5.Name == r2_2.Name and not r5:IsDescendantOf(u1115) then
                    r9 = r5.Parent
                    r17 = r2_2.CFrame
                    r18 = r5.CFrame
                    break
                end
            end

            r16 = r9
        else
            r16 = r9
        end
    else
        r16 = r9
    end

    local r4_2

    if not r16 then
        local r3_2 = u1115.AccessoryType
        local r5_2 = r3_2 == u824.AccessoryType.Hair
        local r2_3

        if r5_2 then
            r2_3 = r5_2
        else
            local r2_4 = u824.AccessoryType.Hat
            r5_2 = r3_2 == r2_4

            if r3_2 ~= r2_4 then
                r2_4 = u824.AccessoryType.Face
                r5_2 = r3_2 == r2_4
            end

            if r3_2 ~= r2_4 then
                r2_4 = u824.AccessoryType.Eyebrow
                r5_2 = r3_2 == r2_4
            end

            if r3_2 == r2_4 then
                r2_3 = r5_2
            else
                r2_3 = r3_2 == u824.AccessoryType.Eyelash
            end
        end

        if r2_3 then
            r16 = r0:FindFirstChild("Head")
        end

        if not r16 then
            r16 = r0:FindFirstChild("Head") or r0:FindFirstChild("UpperTorso") or r0:FindFirstChild("Torso")
        end

        r17 = u819.new(0, 0.5, 0)
        r18 = u819.new()
        r4_2 = r16
    else
        r4_2 = r16
    end

    if r4_2 and r4_2:IsA("BasePart") then
        local r3_3 = u850.new("Weld")
        r3_3.Name = "AccessoryWeld"
        r3_3.Part0 = r7
        r3_3.Part1 = r4_2
        r3_3.C0 = r17
        r3_3.C1 = r18
        r3_3.Parent = r7
        u1115.Parent = r0
        return true
    end

    if u1116 then
        local function r3_4()
            u1116:AddAccessory(u1115)
        end

        if pcall(r3_4) and u1115.Parent == r0 then
            return true
        end
    end

    u1115:Destroy()
    return false
end

u1070.avatar_changer.attach_accessory = __S[3]

__S[3] = function(u1120, u1122)
    local u1117 = {}
    local u1118 = {}
    local r17

    local function u1119(r0)
        if not r0 or u1118[r0] then
            return
        end

        u1118[r0] = true
        table.insert(u1117, r0)
    end

    if u1120 then
        local r3 = u1120:GetChildren()

        for r3_2, r4 in ipairs(r3) do
            if r4:IsA("Accessory") or r4:IsA("Hat") then
                u1119(r4)
            end
        end

        if #u1117 == 0 then
            local r4_2 = u1120
            u1120 = "Humanoid"
            local u1121 = r4_2:FindFirstChildOfClass(u1120)

            if u1121 then
                pcall(function()
                    local r287 = u1121:GetAccessories()

                    for r1, r2 in ipairs(r287) do
                        u1119(r2)
                    end
                end)
            end
        end
    end

    if u1122 and u1122.GetAccessories then
        pcall(function()
            local r1 = u1122:GetAccessories(true)

            for r1_2, r2 in ipairs(r1) do
                local u1123 = r2.AssetId

                if u1123 and 0 < u1123 then
                    pcall(function()
                        local r4 = u796:GetObjects("rbxassetid://" .. u1123)

                        for r1, r2 in ipairs(r4) do
                            local r9 = r2:IsA("Accessory") and r2 or r2:FindFirstChildOfClass("Accessory")

                            if not r9 then
                                local r298 = r2:GetDescendants()

                                for r4_2, r5 in ipairs(r298) do
                                    if r5:IsA("Accessory") then
                                        r9 = r5
                                        break
                                    end
                                end
                            end

                            if r9 then
                                u1119(r9)
                            end
                        end
                    end)
                end
            end
        end)
    end

    if u1122 and #u1117 == 0 then
        for r6, r7 in ipairs({
            "HatAccessory",
            "HairAccessory",
            "FaceAccessory",
            "NeckAccessory",
            "ShouldersAccessory",
            "FrontAccessory",
            "BackAccessory",
            "WaistAccessory"
        }) do
            local r2 = u1122[r7]

            if r2 and r2 ~= "" then
                for r9, r10 in string.gmatch(tostring(r2), "%d+") do
                    local u1125 = tonumber(r9)

                    if u1125 and 0 < u1125 then
                        local function r4_3()
                            local r4 = u796:GetObjects("rbxassetid://" .. u1125)

                            for r1, r2 in ipairs(r4) do
                                local r9 = r2:IsA("Accessory") and r2 or r2:FindFirstChildOfClass("Accessory")

                                if not r9 then
                                    local r298 = r2:GetDescendants()

                                    for r4_2, r5 in ipairs(r298) do
                                        if r5:IsA("Accessory") then
                                            r9 = r5
                                            break
                                        end
                                    end
                                end

                                if r9 then
                                    u1119(r9)
                                end
                            end
                        end

                        u1120 = pcall
                        u1120(r4_3)
                    end
                end
            end
        end
    end

    return u1117
end

u1070.avatar_changer.collect_accessories = __S[3]

__S[3] = function(r0)
    local r290 = r0:GetChildren()

    for r2, r3 in ipairs(r290) do
        if r3:IsA("Accessory") or r3:IsA("Hat") then
            r3:Destroy()
        end
    end
end

u1070.avatar_changer.remove_accessories = __S[3]

__S[3] = function(r0, r1)
    if not r0 or not r1 then
        return false
    end

    local r13 = r1:FindFirstChild("Handle")

    if not r13 or not r13:IsA("BasePart") then
        return false
    end

    r13.Anchored = false
    r13.CanCollide = false
    r13.Massless = true
    local r8 = r13:FindFirstChild("AccessoryWeld")

    if not r8 then
        local r302 = r13:GetChildren()

        for r4, r5 in ipairs(r302) do
            if r5:IsA("Weld") or r5:IsA("WeldConstraint") then
                r8 = r5
                break
            end
        end
    end

    if r8 and r8.Part1 then
        local r13_2 = u1070.avatar_changer.find_body_part(r0, r8.Part1.Name)

        if r13_2 then
            r8.Part1 = r13_2
            r1.Parent = r0
            return true
        end
    end

    return u1070.avatar_changer.attach_accessory(r0, nil, r1)
end

u1070.avatar_changer.transfer_accessory_from_temp = __S[3]

__S[3] = function(u1126, r1, r2, r3)
    u1070.avatar_changer.remove_accessories(u1126)
    local u1127 = 0

    if r2 then
        local r308 = r2:GetChildren()

        for r6, r7 in ipairs(r308) do
            if (r7:IsA("Accessory") or r7:IsA("Hat")) and u1070.avatar_changer.transfer_accessory_from_temp(u1126, r7) then
                u1127 = u1127 + 1
            end
        end

        if u1127 == 0 then
            local u1128 = r2:FindFirstChildOfClass("Humanoid")

            if u1128 then
                pcall(function()
                    local r288 = u1128:GetAccessories()

                    for r1, r2 in ipairs(r288) do
                        if u1070.avatar_changer.transfer_accessory_from_temp(u1126, r2) then
                            u1127 = u1127 + 1
                        end
                    end
                end)
            end
        end
    end

    if u1127 == 0 then
        local r5 = u1070.avatar_changer.collect_accessories(nil, r3)

        for r10, r11 in ipairs(r5) do
            if u1070.avatar_changer.attach_accessory(u1126, r1, r11) then
                u1127 = u1127 + 1
            end
        end
    end

    return u1127
end

u1070.avatar_changer.apply_accessories = __S[3]

__S[3] = function(r0, r1)
    if not r0 or not r1 then
        return
    end

    for r3, r4 in ipairs({
        {"BodyHeightScale", r1.HeightScale, false},
        {"BodyWidthScale", r1.WidthScale, false},
        {"BodyDepthScale", r1.DepthScale, false},
        {"HeadScale", r1.HeadScale, false},
        {"BodyTypeScale", r1.BodyTypeScale, true},
        {"ProportionScale", r1.ProportionScale, true}
    }) do
        local r16 = r4[1]
        local r7 = r4[2]
        local r5 = r4[3]

        if typeof(r7) == "number" and (r7 > 0 or r5 and r7 >= 0) then
            local r5_2 = r0:FindFirstChild(r16)

            if not r5_2 and r0.RigType == u824.HumanoidRigType.R15 then
                local r6 = u850.new("NumberValue")
                r6.Name = r16
                r6.Parent = r0
                r5_2 = r6
            end

            if r5_2 and r5_2:IsA("NumberValue") then
                r5_2.Value = r7
            end
        end
    end
end

u1070.avatar_changer.apply_body_scales = __S[3]

__S[3] = function(u1129, r1)
    if not u1129 or not r1 then
        return
    end

    if r1.Head and (r1.Head == 15093053680 or r1.Head == 134082513) then
        pcall(u1070.avatar.apply_headless, u1129)
    end

    if r1.RightLeg and r1.RightLeg == 139607718 then
        pcall(function()
            if u1129:FindFirstChild("RightLeg") or u1129:FindFirstChild("Right Leg") then
                u1070.avatar.apply_korblox(u1129)
                return
            end

            for r1, r2 in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local r7 = u1129:FindFirstChild(r2)

                if r7 then
                    r7.Transparency = 1
                end
            end

            local r0 = u1129:FindFirstChild("RightUpperLeg")

            if r0 and not r0:FindFirstChild("KorbloxLeg") then
                local r1_2 = u850.new("Part")
                r1_2.Name = "KorbloxLeg"
                r1_2.CanCollide = false
                r1_2.Massless = true
                r1_2.Size = Vector3.new(1, 2, 1)
                local r2_2 = u850.new("SpecialMesh")
                r2_2.MeshId = "rbxassetid://101851696"
                r2_2.TextureId = "rbxassetid://115727863"
                r2_2.Scale = Vector3.new(1, 1, 1)
                r2_2.Parent = r1_2
                local r2_3 = u850.new("Weld")
                r2_3.Part0 = r0
                r2_3.Part1 = r1_2
                r2_3.C0 = u819.new(0, -0.5, 0)
                r2_3.Parent = r1_2
                r1_2.Parent = r0
            end
        end)
    end
end

u1070.avatar_changer.apply_special_body_parts = __S[3]

__S[3] = function(u1130, u1131, r2)
    if not u1130 or not u1131 then
        return
    end

    if r2 and r2.RigType ~= u824.HumanoidRigType.R15 then
        local r327 = u1130:GetChildren()

        for r4, u1132 in ipairs(r327) do
            if u1132:IsA("CharacterMesh") then
                pcall(function()
                    local r290 = u1131:GetChildren()

                    for r1, r2 in ipairs(r290) do
                        if r2:IsA("CharacterMesh") and r2.BodyPart == u1132.BodyPart then
                            r2:Destroy()
                        end
                    end

                    u1132:Clone().Parent = u1131
                end)
            end
        end

        return
    end

    for r7, r8 in ipairs({
        "Head",
        "UpperTorso",
        "LowerTorso",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand",
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperLeg",
        "LeftLowerLeg",
        "LeftFoot",
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot"
    }) do
        local u1133 = u1130:FindFirstChild(r8)
        local u1134 = u1131:FindFirstChild(r8)

        if u1133 and u1134 and u1133:IsA("MeshPart") and u1134:IsA("MeshPart") then
            local u1135 = false

            pcall(function()
                u1134:ApplyMesh(u1133)
                u1135 = true
            end)

            if not u1135 then
                pcall(function()
                    u1134.MeshId = u1133.MeshId
                end)

                pcall(function()
                    u1134.TextureID = u1133.TextureID
                end)
            end

            pcall(function()
                local r4 = u1134:FindFirstChildOfClass("SurfaceAppearance")

                if r4 then
                    r4:Destroy()
                end

                local r0 = u1133:FindFirstChildOfClass("SurfaceAppearance")

                if r0 then
                    r0:Clone().Parent = u1134
                end
            end)
        end
    end
end

u1070.avatar_changer.transfer_body_meshes = __S[3]

__S[3] = function(r0, r1, u1136, u1137)
    if not r0 or not r1 or not u1136 then
        return false
    end

    pcall(function()
        if u1136.ApplyDescriptionClientServer then
            u1136:ApplyDescriptionClientServer(u1137)
        else
            u1136:ApplyDescription(u1137)
        end
    end)

    u1070.avatar_changer.transfer_body_meshes(r0, r1, u1136)

    for r5, r6 in ipairs({"Shirt", "Pants", "ShirtGraphic"}) do
        local r15 = r0:FindFirstChildOfClass(r6)

        if r15 then
            local r7 = r1:FindFirstChildOfClass(r6)

            if r7 then
                r7:Destroy()
            end

            r15:Clone().Parent = r1
        end
    end

    local r15_2 = r0:FindFirstChildOfClass("BodyColors")
    local r6_2 = r1:FindFirstChildOfClass("BodyColors")

    if not r6_2 then
        r6_2 = u850.new("BodyColors")
        r6_2.Parent = r1
    end

    if r15_2 then
        r6_2.HeadColor3 = r15_2.HeadColor3
        r6_2.TorsoColor3 = r15_2.TorsoColor3
        r6_2.LeftArmColor3 = r15_2.LeftArmColor3
        r6_2.RightArmColor3 = r15_2.RightArmColor3
        r6_2.LeftLegColor3 = r15_2.LeftLegColor3
        r6_2.RightLegColor3 = r15_2.RightLegColor3
    end

    if u1137 then
        r6_2.HeadColor3 = u1137.HeadColor
        r6_2.TorsoColor3 = u1137.TorsoColor
        r6_2.LeftArmColor3 = u1137.LeftArmColor
        r6_2.RightArmColor3 = u1137.RightArmColor
        r6_2.LeftLegColor3 = u1137.LeftLegColor
        r6_2.RightLegColor3 = u1137.RightLegColor
    end

    local r14 = r0:FindFirstChild("Head")
    local r5_2 = r1:FindFirstChild("Head")

    if r14 and r5_2 then
        local r11 = r14:FindFirstChild("face") or r14:FindFirstChildOfClass("Decal")

        if r11 then
            local r6_3 = r5_2:FindFirstChild("face") or r5_2:FindFirstChildOfClass("Decal")

            if r6_3 then
                r6_3:Destroy()
            end

            local r4 = r11:Clone()
            r4.Name = "face"
            r4.Parent = r5_2
        end
    end

    u1070.avatar_changer.apply_body_scales(u1136, u1137)
    u1070.avatar_changer.apply_special_body_parts(r1, u1137)
    u1070.avatar_changer.apply_accessories(r1, u1136, r0, u1137)
    return true
end

u1070.avatar_changer.transfer_appearance = __S[3]

__S[3] = function(r0)
    local r15 = {}
    local r325 = r0:GetChildren()

    for r3, r4 in ipairs(r325) do
        if r4:IsA("Tool") or r4:IsA("HopperBin") then
            table.insert(r15, r4)
            r4.Parent = nil
        end
    end

    local r3_2 = r0.Parent and r0.Parent:FindFirstChild("Backpack")

    if r3_2 then
        local r327 = r3_2:GetChildren()

        for r6, r7 in ipairs(r327) do
            if r7:IsA("Tool") or r7:IsA("HopperBin") then
                table.insert(r15, r7)
            end
        end
    end

    local r4_2 = {}
    local r323 = r0:GetDescendants()

    for r9, r10 in ipairs(r323) do
        if r10:IsA("BaseScript") then
            r4_2[r10] = true

            if r10.Parent then
                r4_2[r10.Parent] = true
            end
        end
    end

    local r321 = r0:GetChildren()

    for r12, r13 in ipairs(r321) do
        if not r4_2[r13] and (r13:IsA("Accessory") or r13:IsA("Hat") or r13:IsA("BodyColors") or r13:IsA("CharacterMesh") or r13:IsA("Shirt") or r13:IsA("Pants") or r13:IsA("ShirtGraphic")) then
            r13:Destroy()
        end
    end

    for r15_2, r16 in ipairs(r15) do
        if r16 and r16.Parent == nil then
            if r3_2 then
                r16.Parent = r3_2
            end

            if not r3_2 then
                r16.Parent = r0
            end
        end
    end
end

u1070.avatar_changer.clean = __S[3]

__S[3] = function(r0, u1138, r2)
    if not r0 or not u1138 then
        return
    end

    if not r2 then
        local r5 = u1070.avatar_changer.original_parts or {}
        u1070.avatar_changer.original_parts = r5

        if not u1070.avatar_changer.original_parts[r0.Name] then
            local r7 = r0:Clone()
            local r319 = r7:GetChildren()

            for r4, r5_2 in ipairs(r319) do
                if r5_2:IsA("JointInstance") then
                    r5_2:Destroy()
                end
            end

            u1070.avatar_changer.original_parts[r0.Name] = r7
        end
    end

    u1138.Name = r0.Name
    u1138.CFrame = r0.CFrame
    u1138.Color = r0.Color
    u1138.Transparency = r0.Transparency
    u1138.CanCollide = r0.CanCollide
    u1138.Anchored = r0.Anchored
    local r315 = r0:GetChildren()

    for r8, u1139 in ipairs(r315) do
        if u1139:IsA("Attachment") and not u1138:FindFirstChild(u1139.Name) then
            pcall(function()
                u1139:Clone().Parent = u1138
            end)
        end
    end

    local r4_2 = {}
    local r14 = r0.Parent

    if r14 then
        local r317 = r14:GetDescendants()

        for r11, r12 in ipairs(r317) do
            if r12:IsA("Motor6D") and (r12.Part0 == r0 or r12.Part1 == r0) then
                table.insert(r4_2, {
                    class = r12.ClassName,
                    name = r12.Name,
                    parent = r12.Parent == r0 and "new" or r12.Parent,
                    part0 = r12.Part0 == r0 and "new" or r12.Part0,
                    part1 = r12.Part1 == r0 and "new" or r12.Part1,
                    c0 = r12.C0,
                    c1 = r12.C1,
                    joint_obj = r12
                })
            end
        end
    end

    u1138.Parent = r0.Parent

    for r14_2, u1140 in ipairs(r4_2) do
        local u1141 = u1140.joint_obj
        local r4_3 = u1140.part0 == "new" and u1138 or u1140.part0
        local r5_3 = u1140.part1 == "new" and u1138 or u1140.part1
        local r6 = u1140.parent == "new" and u1138 or u1140.parent

        pcall(function()
            u1141:Destroy()
        end)

        local u1142 = r4_3
        local u1143 = r5_3
        local u1144 = r6

        pcall(function()
            local r0 = u850.new("Motor6D")
            r0.Name = u1140.name
            r0.Part0 = u1142
            r0.Part1 = u1143
            r0.C0 = u1140.c0
            r0.C1 = u1140.c1
            r0.Parent = u1144
        end)
    end

    r0:Destroy()
end

u1070.avatar_changer.replace_body_part = __S[3]

__S[3] = function(u1145)
    if not u1145 then
        return
    end

    pcall(u1070.avatar.remove_headless, u1145)
    pcall(u1070.avatar.remove_korblox, u1145)

    pcall(function()
        for r1, r2 in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local r3 = u1145:FindFirstChild(r2)

            if r3 then
                r3.Transparency = 0
            end
        end

        local r0 = u1145:FindFirstChild("RightUpperLeg")

        if r0 then
            r0 = r0:FindFirstChild("KorbloxLeg")
        end

        if r0 then
            r0:Destroy()
        end
    end)

    if not u1070.avatar_changer.original_parts then
        return
    end

    for r4, u1146 in pairs(u1070.avatar_changer.original_parts) do
        local u1147 = u1145:FindFirstChild(r4)

        if u1147 then
            pcall(function()
                u1070.avatar_changer.replace_body_part(u1147, u1146:Clone(), true)
            end)
        end
    end

    u1070.avatar_changer.original_parts = nil
end

u1070.avatar_changer.revert_to_original = __S[3]

__S[3] = function(u1148, r1, u1149)
    if u1070.avatar_changer.applying then
        return
    end

    u1070.avatar_changer.applying = true

    pcall(function()
        u1070.avatar_changer.expected_accessories = #u1148:GetAccessories(true)
    end)

    task.spawn(function()
        local function u1150()
            local function r6()
                if u1149 then
                    return false
                end

                return not u1070.avatar_changer.enabled
            end

            local r7 = u1061.Character or u1061.CharacterAdded:Wait()

            if r6() then
                u1070.avatar_changer.applying = false
                return
            end

            if not r7 then
                u1070.avatar_changer.applying = false
                return
            end

            r7 = u1061.Character or r7
            local u1151 = r7:FindFirstChildOfClass("Humanoid") or r7:WaitForChild("Humanoid", 5)

            if not u1151 then
                u1070.avatar_changer.applying = false
                return
            end

            if not u1149 then
                u1070.avatar_changer.revert_to_original(r7)
            end

            u1070.avatar_changer.clean(r7)

            if r6() then
                u1070.avatar_changer.applying = false
                return
            end

            local r6_2 = u1070.avatar_changer.create_temp_model(u1148, u1151.RigType)
            local r9 = false

            if r6_2 then
                r9 = u1070.avatar_changer.transfer_appearance(r6_2, r7, u1151, u1148)
                r6_2:Destroy()
            end

            if r9 then
                return
            end

            pcall(function()
                if u1151.ApplyDescriptionClientServer then
                    u1151:ApplyDescriptionClientServer(u1148)
                else
                    u1151:ApplyDescription(u1148)
                end
            end)

            u1070.avatar_changer.apply_body_scales(u1151, u1148)
            u1070.avatar_changer.apply_special_body_parts(r7, u1148)
            local r2 = r7:FindFirstChildOfClass("BodyColors")

            if not r2 then
                r2 = u850.new("BodyColors")
                r2.Parent = r7
            end

            r2.HeadColor3 = u1148.HeadColor
            r2.TorsoColor3 = u1148.TorsoColor
            r2.LeftArmColor3 = u1148.LeftArmColor
            r2.RightArmColor3 = u1148.RightArmColor
            r2.LeftLegColor3 = u1148.LeftLegColor
            r2.RightLegColor3 = u1148.RightLegColor
            u1070.avatar_changer.apply_accessories(r7, u1151, nil, u1148)
        end

        pcall(u1150)
        u1150 = u1070.avatar_changer
        u1150.applying = false
    end)
end

u1070.avatar_changer.apply_description = __S[3]

__S[3] = function(u1153)
    if u1070.avatar_changer.applying then
        return
    end

    u1070.avatar_changer.attempt_id = (u1070.avatar_changer.attempt_id or 0) + 1
    local u1152 = u1070.avatar_changer.attempt_id

    task.spawn(function()
        if not u1070.avatar_changer.enabled or u1070.avatar_changer.target ~= u1153 or u1070.avatar_changer.attempt_id ~= u1152 then
            return
        end

        local r0 = u1077(u1153)

        if not r0 then
            return
        end

        if u1070.avatar_changer.applied_id == r0 then
            return
        end

        local r1 = u1070.avatar_changer.get_description(r0)

        if not r1 then
            return
        end

        if not u1070.avatar_changer.enabled or u1070.avatar_changer.target ~= u1153 or u1070.avatar_changer.attempt_id ~= u1152 then
            return
        end

        u1070.avatar_changer.applied_id = r0
        u1070.avatar_changer.apply_description(r1, r0)
    end)
end

u1070.avatar_changer.apply = __S[3]

__S[3] = function()
    if not u1070.avatar_changer.original_desc then
        return
    end

    u1070.avatar_changer.applied_id = nil
    u1070.avatar_changer.applying = false
    local r0 = u1061.Character

    if r0 then
        u1070.avatar_changer.revert_to_original(r0)
    end

    u1070.avatar_changer.apply_description(u1070.avatar_changer.original_desc, u1061.UserId, true)
end

u1070.avatar_changer.restore = __S[3]

local function u1154(r0, r1)
    u1070.avatar_changer.applying = false
    u1070.avatar_changer.applied_id = nil
    u1070.avatar_changer.apply(r0)
    local r2 = 0

    while not u1070.avatar_changer.applying and r2 < 2 do
        task.wait(0.05)
        r2 = r2 + 0.05
    end

    local r2_2 = 0

    while u1070.avatar_changer.applying do
        if not (r2_2 < (r1 or 8)) then
            break
        end

        task.wait(0.05)
        r2_2 = r2_2 + 0.05
    end
end

function u1070.avatar_changer.reapply_on_spawn(u1155)
    if not (u1070.avatar_changer.enabled and u1070.avatar_changer.target ~= "") then
        return
    end

    if not u1155 then
        return
    end

    u1070.avatar_changer.respawn_token = (u1070.avatar_changer.respawn_token or 0) + 1
    local u1156 = u1070.avatar_changer.respawn_token

    task.spawn(function()
        if not (u1155:FindFirstChildOfClass("Humanoid") or u1155:WaitForChild("Humanoid", 10)) then
            return
        end

        u1155:WaitForChild("HumanoidRootPart", 10)
        local u1157 = false

        pcall(function()
            u1157 = u1061:HasAppearanceLoaded()
        end)

        if not u1157 then
            local u1158 = false

            local r1 = u1061.CharacterAppearanceLoaded:Connect(function()
                u1158 = true
            end)

            local r3 = 0

            while not u1158 and r3 < 6 do
                task.wait(0.1)
                r3 = r3 + 0.1

                pcall(function()
                    if u1061:HasAppearanceLoaded() then
                        u1158 = true
                    end
                end)
            end

            if r1 then
                r1:Disconnect()
            end
        end

        if u1070.avatar_changer.respawn_token ~= u1156 then
            return
        end

        for r1_2 = 1, 3 do
            if u1070.avatar_changer.respawn_token ~= u1156 then
                return
            end

            if not (u1070.avatar_changer.enabled and u1070.avatar_changer.target ~= "") then
                return
            end

            if u1155.Parent == nil then
                return
            end

            u1154(u1070.avatar_changer.target, 8)

            if r1_2 < 3 then
                task.wait(1)
            end
        end
    end)
end

u1061.CharacterAdded:Connect(function(r0)
    u1070.avatar_changer.reapply_on_spawn(r0)
end)

__S[3] = function(r0)
    local r4 = r0:FindFirstChild("RightLeg") or r0:FindFirstChild("Right Leg")

    if not r4 then
        return
    end

    local r296 = r4:GetChildren()

    for r2, r3 in ipairs(r296) do
        if r3:IsA("SpecialMesh") or r3:IsA("Mesh") then
            r3:Destroy()
        end
    end

    local r1 = u850.new("SpecialMesh")
    r1.MeshId = "rbxassetid://101851696"
    r1.TextureId = "rbxassetid://115727863"
    r1.Scale = Vector3.new(1, 1, 1)
    r1.Parent = r4
end

u1070.avatar.apply_korblox = __S[3]

__S[3] = function(r0)
    local r1 = r0:FindFirstChild("RightLeg") or r0:FindFirstChild("Right Leg")

    if not r1 then
        return
    end

    local r293 = r1:GetChildren()

    for r2, r3 in ipairs(r293) do
        if r3:IsA("SpecialMesh") and r3.MeshId == "rbxassetid://101851696" then
            r3:Destroy()
        end
    end
end

u1070.avatar.remove_korblox = __S[3]

__S[3] = function(r0)
    u1070.avatar.korblox_enabled = r0

    if u1070.avatar.korblox_conn then
        u1070.avatar.korblox_conn:Disconnect()
        u1070.avatar.korblox_conn = nil
    end

    local r2 = u1061.Character

    if r0 then
        if r2 then
            u1070.avatar.apply_korblox(r2)
        end

        local function r0_2(r0)
            task.wait(0.1)

            if u1070.avatar.korblox_enabled then
                u1070.avatar.apply_korblox(r0)
            end
        end

        u1070.avatar.korblox_conn = u1061.CharacterAdded:Connect(r0_2)
    elseif r2 then
        u1070.avatar.remove_korblox(r2)
    end
end

u1070.avatar.set_korblox = __S[3]

__S[3] = function(r0)
    local r1 = r0:FindFirstChild("Head")

    if not r1 then
        return
    end

    r1.Transparency = 1
    local r1_2 = r1:FindFirstChildOfClass("Decal")

    if r1_2 then
        r1_2:Destroy()
    end
end

u1070.avatar.apply_headless = __S[3]

__S[3] = function(r0)
    local r2 = r0:FindFirstChild("Head")

    if not r2 then
        return
    end

    r2.Transparency = 0
end

u1070.avatar.remove_headless = __S[3]

__S[3] = function(r0)
    u1070.avatar.headless_enabled = r0

    if u1070.avatar.headless_conn then
        u1070.avatar.headless_conn:Disconnect()
        u1070.avatar.headless_conn = nil
    end

    local r2 = u1061.Character

    if r0 then
        if r2 then
            u1070.avatar.apply_headless(r2)
        end

        local function r0_2(r0)
            task.wait(0.1)

            if u1070.avatar.headless_enabled then
                u1070.avatar.apply_headless(r0)
            end
        end

        u1070.avatar.headless_conn = u1061.CharacterAdded:Connect(r0_2)
    else
        if r2 then
            u1070.avatar.remove_headless(r2)
        end
    end
end

u1070.avatar.set_headless = __S[3]

 
 
__S[3] = function(speed, accuracy)
    local ping = (u1070.cache.get_parry_ping or u1070.cache.get_ping)()
    local jitter = math.min(u1070.cache.get_ping_jitter(), 40)
    local frameAt = u1070.sapphire and u1070.sapphire.State.ParryFrameAt
    local difference = (ping + math.min(u1066() - (frameAt or u1066()), 0.02) * 1000) / 1000
    local base = math.clamp(ping / 10 + jitter / 8, 10, 16.7 + jitter / 8)
    local step = math.clamp(difference * 0.5 - 0.05 + jitter / 2000, 0, 0.04 + jitter / 2000)
    local inverse = 101 - math.clamp(tonumber(accuracy) or u1070.config.accuracy or 80, 1, 100)
    local factor = math.clamp((inverse - 1) / 99, 0, 1)
    local smooth = factor * factor * (3 - 2 * factor)
    local denominator = 2.4 + math.clamp(speed - 9.5, 0, 990.5) * 0.002
    local center = speed / denominator * (0.75 + factor * 0.43)
    local slow = center <= 9.5
    local compensation = slow and math.min(base, speed * difference) or base + math.min(speed * step, 30)
    local normal = compensation + math.max(center, 9.5)
    local radius = normal
    if inverse > 70 then
        local blend = math.clamp((inverse - 44) / 30, 0, 1)
        blend = blend * blend * (3 - 2 * blend)
        local senderDistance, ballDistance
        local F = u1070.sapphire
        local ball = F and F.MainBall()
        local root = u1070.player.get_root()
        local alive = workspace:FindFirstChild("Alive")
        local sender = ball and ball:GetAttribute("from")
        local character = type(sender) == "string" and alive and alive:FindFirstChild(sender)
        local otherRoot = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
        if root and otherRoot then senderDistance = (root.Position - otherRoot.Position).Magnitude end
        local part = ball and (ball:IsA("BasePart") and ball or ball.PrimaryPart or ball:FindFirstChild("Body") or ball:FindFirstChild("Corpo"))
        if root and part then ballDistance = (root.Position - part.Position).Magnitude end
        local close = senderDistance and math.clamp((8 - senderDistance) / 3, 0, 1) or 0
        if senderDistance and ballDistance and ballDistance > senderDistance + 3 then close = 0 end
        local low = (slow and math.min(base, speed * difference) or base) + math.max(speed / denominator * (0.75 + factor * 0.2), 9.5)
        local high = base + speed / denominator * (1.4 + factor * 0.2)
        local adjusted = high + math.max(low - high, 0) * math.clamp((speed - 1000) / 800, 0, 1)
        radius = normal + (adjusted + (low - adjusted) * close - normal) * blend
    end
    return radius + math.clamp(tonumber(u1070.config.parry_range) or 0, 0, 10)
        + (slow and (base - compensation) * (1 - smooth) or 0)
end

u1070.parry.get_premium_parry_distance = __S[3]

__S[3] = function()
    local r0 = u1070.parry_cooldown
    r0.pending_id = r0.pending_id + 1
    local u1159 = r0.pending_id

    task.delay(r0.success_window, function()
        if u1070.parry_cooldown.pending_id == u1159 then
            u1070.parry_cooldown.failed_at = u817()
        end
    end)
end

u1070.parry.mark_attempt = __S[3]

__S[3] = function(u1160)
    if u1070.parry_cooldown.conn then
        u1070.parry_cooldown.conn:Disconnect()
        u1070.parry_cooldown.conn = nil
    end

    if not u1160 then
        return
    end

    u1070.parry_cooldown.last_parrying = u1160:GetAttribute("Parrying")
    u1070.parry_cooldown.failed_at = 0

    u1070.parry_cooldown.conn = u1160:GetAttributeChangedSignal("Parrying"):Connect(function()
        local r0 = u1160:GetAttribute("Parrying")

        if u1070.parry_cooldown.last_parrying == true and r0 == false then
            u1070.parry_cooldown.failed_at = u817()
        elseif r0 == nil or r0 == true then
            u1070.parry_cooldown.failed_at = 0
        end

        u1070.parry_cooldown.last_parrying = r0
    end)
end

u1070.parry.hook_cooldown_tracker = __S[3]

if u1061.Character then
    u808(u1070.parry.hook_cooldown_tracker, u1061.Character)
end

u1061.CharacterAdded:Connect(function(r0)
    pcall(u1070.parry.hook_cooldown_tracker, r0)
end)

__S[3] = function()
    local r291 = u1070.ball.get_all()
    local r4 = 0

    for r1, r2 in ipairs(r291) do
        r4 = math.max(r4, u1070.ball.get_velocity(r2.part, r2.model).Magnitude)
    end

    return math.clamp(u1070.parry.get_premium_parry_distance(r4, u1070.config.accuracy), 4, 60)
end

u1070.parry_visualizer.get_parry_radius = __S[3]

__S[3] = function()
    local r4 = u1070.parry_visualizer

    if r4.sphere and r4.sphere.Parent then
        r4.sphere:Destroy()
    end

    r4.sphere = nil
    r4.weld = nil
    local r5 = u1070.player.get_root()

    if not r5 then
        return
    end

    local r6 = u850.new("Part")
    r6.Name = "ParryVisualizerSphere"
    r6.Shape = u824.PartType.Ball
    r6.Material = u824.Material.ForceField
    r6.Color = r4.color
    r6.Size = Vector3.new(8, 8, 8)
    r6.Anchored = true
    r6.CanCollide = false
    r6.CanTouch = false
    r6.CanQuery = false
    r6.CastShadow = false
    r6.Transparency = 0.35
    r6.CFrame = r5.CFrame
    r6.Parent = u1058
    r4.sphere = r6
end

u1070.parry_visualizer.rebuild_sphere = __S[3]

__S[3] = function(u1163)
    local u1161 = u1070.parry_hits
    local r9 = u1161.color

    while #u1161.parts >= 20 do
        local r5 = table.remove(u1161.parts, 1)

        if r5 and r5.Parent then
            r5:Destroy()
        end
    end

    local u1162 = {}

    for r2 = 1, 12 do
        local r3 = r2 <= 4
        local r1 = r3 and math.random(70, 110) / 100 or math.random(25, 55) / 100
        local r12 = u850.new("Part")
        r12.Size = Vector3.new(0.1, r1, 0.1)
        r12.Anchored = true
        r12.CanCollide = false
        r12.CanTouch = false
        r12.CanQuery = false
        r12.CastShadow = false
        r12.Material = u824.Material.Neon
        r12.Color = r9
        r12.CFrame = u819.new(u1163)
        r12.Parent = u1058

        if r2 == 1 then
            local r4 = u850.new("PointLight")
            r4.Brightness = 5
            r4.Range = 12
            r4.Color = r9
            r4.Parent = r12
        end

        r2 = r2 / 12 * 3.141592653589793 * 2 + math.random() * 0.5
        local r7 = r3 and 3.141592653589793 * 0.35 + math.random() * 3.141592653589793 * 0.3 or math.random() * 3.141592653589793

        table.insert(u1162, {
            part = r12,
            dir = Vector3.new(math.sin(r7) * math.cos(r2), math.abs(math.cos(r7)) * 0.5 + math.random() * 0.6, math.sin(r7) * math.sin(r2)).Unit,
            speed = r3 and math.random(6, 10) or math.random(3, 6),
            init_len = r1,
            rx = (math.random() - 0.5) * 0.25,
            ry = (math.random() - 0.5) * 0.25,
            rz = (math.random() - 0.5) * 0.25
        })

        table.insert(u1161.parts, r12)
    end

    task.spawn(function()
        local r8 = 0

        while r8 < 1.4 do
            r8 = r8 + u1063:Wait()
            local r9 = r8 / 1.4

            for r1, r2 in ipairs(u1162) do
                if r2.part.Parent then
                    r2.part.CFrame = u819.new(u1163 + r2.dir * (r2.speed * (1 - (1 - r9) ^ 3) * 3.5)) * u819.Angles(r2.rx * r8 * 6, r2.ry * r8 * 6, r2.rz * r8 * 6)
                    local r3 = math.max(1 - r9, 0)
                    r2.part.Size = Vector3.new(0.1, r2.init_len * r3, 0.1)
                    r2.part.Transparency = math.clamp((r9 - 0.3) / 0.7, 0, 1)
                    local r3_2 = r2.part:FindFirstChildOfClass("PointLight")

                    if r3_2 then
                        r3_2.Brightness = 5 * (1 - r9) ^ 2
                    end
                end
            end
        end

        for r4, r5 in ipairs(u1162) do
            if r5.part.Parent then
                local r6 = table.find(u1161.parts, r5.part)

                if r6 then
                    table.remove(u1161.parts, r6)
                end

                r5.part:Destroy()
            end
        end
    end)
end

u1070.parry_hits.spawn = __S[3]

__S[3] = function()
    u1070.parry_hits.active = true
end

u1070.parry_hits.start = __S[3]

__S[3] = function()
    u1070.parry_hits.active = false

    for r1, r2 in ipairs(u1070.parry_hits.parts) do
        if r2 and r2.Parent then
            r2:Destroy()
        end
    end

    u1070.parry_hits.parts = {}
end

u1070.parry_hits.stop = __S[3]

__S[3] = function(r0)
    u1070.parry_hits.color = r0
end

u1070.parry_hits.update_color = __S[3]

__S[3] = function()
    if u1070.parry_visualizer.active then
        return
    end

    u1070.parry_visualizer.active = true
    u1070.parry_visualizer.rebuild_sphere()

    u1070.parry_visualizer.char_conn = u1061.CharacterAdded:Connect(function()
        task.wait(0.5)

        if u1070.parry_visualizer.active then
            u1070.parry_visualizer.rebuild_sphere()
        end
    end)

    local function r3()
    end

    u1070.parry_visualizer.connection = u1063:Connect(r3)
end

u1070.parry_visualizer.start = __S[3]

__S[3] = function()
    if not u1070.parry_visualizer.active then
        return
    end

    u1070.parry_visualizer.active = false

    if u1070.parry_visualizer.connection then
        u1070.parry_visualizer.connection:Disconnect()
        u1070.parry_visualizer.connection = nil
    end

    if u1070.parry_visualizer.char_conn then
        u1070.parry_visualizer.char_conn:Disconnect()
        u1070.parry_visualizer.char_conn = nil
    end

    if u1070.parry_visualizer.sphere and u1070.parry_visualizer.sphere.Parent then
        u1070.parry_visualizer.sphere:Destroy()
    end

    u1070.parry_visualizer.sphere = nil
    u1070.parry_visualizer.weld = nil

    for r2, r3 in ipairs(u1070.parry_visualizer.parts) do
        if r3 and r3.Parent then
            r3:Destroy()
        end
    end

    u1070.parry_visualizer.parts = {}
end

u1070.parry_visualizer.stop = __S[3]

__S[3] = function(r0)
    u1070.parry_visualizer.color = r0

    if u1070.parry_visualizer.sphere and u1070.parry_visualizer.sphere.Parent then
        u1070.parry_visualizer.sphere.Color = r0
    end
end

u1070.parry_visualizer.update_color = __S[3]

local function u1164(u1165)
    if not u1165 or u1165 == "" then
        return nil
    end

    local function r5()
        return require(u1057.Shared.Abilities[u1165])
    end

    local r4, r5_2 = pcall(r5)
    return r4 and r5_2 or nil
end

local function u1166(u1168, u1167)
    if not u1167 or u1167 == "" then
        return 0
    end

    local function r3()
        return u1168.Upgrades[u1167].Value
    end

    local r2, r3_2 = pcall(r3)
    return r2 and r3_2 or 0
end

local function u1169(r0)
    return 2 + u1166(r0, "Dribble")
end

local function u1170(r0, r1)
    if not r0 or r0 == "" then
        return nil
    end

    return r0 .. " V" .. u1166(r1, r0) + 1
end

local function u1171()
    local function r1()
        return tonumber(u1061.PlayerGui.Hotbar.Ability.ready.counts.Text)
    end

    local u1172 = pcall
    local r1_2
    u1172, r1_2 = u1172(r1)
    u1172 = u1172 and r1_2 or nil
    return u1172
end

__S[3] = function()
    local r4 = Drawing.new("Text")
    r4.Visible = false
    r4.Center = true
    r4.Outline = true
    r4.OutlineColor = u820.new(0, 0, 0)
    r4.Color = u1070.ability_esp.cd_color
    r4.Size = u1070.ability_esp.cd_size
    r4.Font = Drawing.Fonts.UI
    return r4
end

u1070.ability_esp.new_cd_drawing = __S[3]

__S[3] = function(r0)
    r0.nameDraw.Visible = false
    r0.abilityDraw.Visible = false
    r0.timerDraw.Visible = false
    r0.cdDraw.Visible = false
    r0.usesDraw.Visible = false

    for r3, r4 in ipairs(r0.cdDrawings) do
        r4.Visible = false
    end

    if r0.billboard then
        r0.billboard.Enabled = false
        r0.billboard.Adornee = nil
    end
end

u1070.ability_esp.hide_all = __S[3]

__S[3] = function(r0, r1)
    if not r0.billboard or not r0.billboard.Parent then
        if not u1070.ability_esp._holder or not u1070.ability_esp._holder.Parent then
            u1070.ability_esp._holder = u858()
        end

        local r8 = u850.new("BillboardGui")
        r8.AlwaysOnTop = true
        r8.Enabled = false
        r8.Parent = u1070.ability_esp._holder
        local r9 = u850.new("ImageLabel")
        r9.Size = u821.new(1, 0, 1, 0)
        r9.BackgroundTransparency = 1
        r9.Image = ""
        r9.Parent = r8
        local r6 = u850.new("TextLabel")
        r6.BackgroundTransparency = 1
        r6.TextStrokeTransparency = 0
        r6.TextStrokeColor3 = u820.new(0, 0, 0)
        r6.Font = u824.Font.GothamBold
        r6.Parent = r8
        r0.billboard = r8
        r0.billboardImg = r9
        r0.billboardLvl = r6
    end

    local r7 = u1070.ability_esp
    local r4 = r7.ability_size * 3
    r0.billboard.Size = u821.new(0, r4, 0, r4)
    r0.billboard.StudsOffset = Vector3.new(0, 4, 0)

    if r0.billboardLvl then
        local r8_2 = r7.ability_size
        r0.billboardLvl.Size = u821.new(0, r8_2 * 2, 0, r8_2 + 4)
        r0.billboardLvl.Position = u821.new(1, -r8_2, 0, 0)
        r0.billboardLvl.TextSize = r8_2
        r0.billboardLvl.TextColor3 = r7.ability_color
    end

    r0.billboard.Adornee = r1
    return r0.billboard, r0.billboardImg, r0.billboardLvl
end

u1070.ability_esp.get_billboard = __S[3]

__S[3] = function(r0)
    if u1070.ability_esp.drawings[r0] then
        u1070.ability_esp.remove_drawing(r0)
    end

    local r3 = u1070.ability_esp

    local function r2(r0, r1)
        local r6 = Drawing.new("Text")
        r6.Visible = false
        r6.Center = true
        r6.Outline = true
        r6.OutlineColor = u820.new(0, 0, 0)
        r6.Color = r1
        r6.Size = r0
        r6.Font = Drawing.Fonts.UI
        return r6
    end

    r3.drawings[r0] = {
        nameDraw = r2(r3.name_size, r3.name_color),
        abilityDraw = r2(r3.ability_size, r3.ability_color),
        timerDraw = r2(r3.active_size, r3.active_color),
        cdDraw = r2(r3.cd_size, r3.cd_color),
        usesDraw = r2(r3.active_size, u820.fromRGB(100, 255, 150)),
        cdQueue = {},
        cdDrawings = {},
        curUses = nil,
        maxUses = nil,
        activeStart = nil,
        activeDur = nil,
        cdStart = nil,
        cdLen = nil,
        abilityName = nil,
        abilityLine = nil,
        iconId = nil,
        billboard = nil,
        billboardImg = nil,
        billboardLvl = nil,
        charConns = {}
    }
end

u1070.ability_esp.create_drawing = __S[3]

__S[3] = function(r0)
    local r2 = u1070.ability_esp.drawings[r0]

    if not r2 then
        return
    end

    r2.nameDraw:Remove()
    r2.abilityDraw:Remove()
    r2.timerDraw:Remove()
    r2.cdDraw:Remove()
    r2.usesDraw:Remove()

    for r5, r6 in ipairs(r2.cdDrawings) do
        r6:Remove()
    end

    if r2.billboard then
        r2.billboard:Destroy()
    end

    local r8 = r2.charConns or {}

    for r8_2, u1173 in ipairs(r8) do
        pcall(function()
            u1173:Disconnect()
        end)
    end

    u1070.ability_esp.drawings[r0] = nil
end

u1070.ability_esp.remove_drawing = __S[3]

__S[3] = function(r0, r1)
    local r3 = u1164(r0.abilityName)

    if not r3 then
        return
    end

    local r1_2 = u1166(r1, r0.abilityName)
    local r1_3 = math.max(0, r3.cooldown - (r3.cooldownReductionPerUpgrade or 0) * r1_2)

    if r1_3 > 0 then
        r0.cdStart = u817()
        r0.cdLen = r1_3
    end
end

u1070.ability_esp.begin_cd = __S[3]

__S[3] = function(u1174)
    u1070.ability_esp.create_drawing(u1174)

    local function u1175(u1177)
        local r8 = u1070.ability_esp.drawings[u1174]

        if not r8 then
            return
        end

        for r3, u1176 in ipairs(r8.charConns) do
            pcall(function()
                u1176:Disconnect()
            end)
        end

        table.clear(r8.charConns)
        r8.activeStart = nil
        r8.activeDur = nil
        r8.cdStart = nil
        r8.cdLen = nil
        r8.cdQueue = {}
        r8.curUses = nil
        r8.maxUses = nil

        for r6, r7 in ipairs(r8.cdDrawings) do
            r7.Visible = false
        end

        if r8.billboard then
            r8.billboard.Adornee = nil
            r8.billboard.Enabled = false
        end

        local r9 = u1174:GetAttribute("CurrentlyEquippedAbility")

        if r9 and r9 ~= "" then
            r8.abilityName = r9
            r8.abilityLine = u1170(r9, u1174)
            local r2 = u1164(r9)

            if r2 then
                r2 = r2.iconId
            end

            r8.iconId = r2 or nil

            if r9 == "Dribble" then
                r8.maxUses = u1169(u1174)
                r8.curUses = r8.maxUses
            end
        end

        table.insert(r8.charConns, u1177.AttributeChanged:Connect(function(r0)
            local r3 = u1070.ability_esp.drawings[u1174]

            if not r3 then
                return
            end

            if r0 == "DribbleDebounce" and u1177:GetAttribute("DribbleDebounce") == true and r3.abilityName == "Dribble" then
                local r2 = u1164("Dribble")

                if r2 then
                    table.insert(r3.cdQueue, {t = u817(), dur = r2.cooldown})
                end

                if r3.curUses ~= nil then
                    r3.curUses = math.max(0, r3.curUses - 1)
                end
            end

            if r0 == "AbilityUpgrade" and u1177:GetAttribute("AbilityUpgrade") ~= nil and r3.abilityName ~= "Dribble" then
                r3.abilityLine = u1170(r3.abilityName, u1174)
                u1070.ability_esp.begin_cd(r3, u1174)
            end

            if r0 ~= "AbilityActive" then
                return
            end

            local r9 = u1177:GetAttribute("AbilityActive")
            local r10 = u1174:GetAttribute("AbilityDuration")

            if r9 == true and r10 and r10 > 0 then
                r3.activeStart = u817()
                r3.activeDur = r10
            else
                r3.activeStart = nil
                r3.activeDur = nil
            end
        end))

        table.insert(r8.charConns, u1174.AttributeChanged:Connect(function(r0)
            local r5 = u1070.ability_esp.drawings[u1174]

            if not r5 then
                return
            end

            if r0 == "CurrentlyEquippedAbility" then
                local r8 = u1174:GetAttribute("CurrentlyEquippedAbility")
                r5.abilityName = r8
                r5.abilityLine = u1170(r8, u1174)
                r5.cdStart = nil
                r5.cdLen = nil
                r5.cdQueue = {}

                for r3, r4 in ipairs(r5.cdDrawings) do
                    r4.Visible = false
                end

                local r2 = u1164(r8)

                if r2 then
                    r2 = r2.iconId
                end

                r5.iconId = r2 or nil

                if r8 == "Dribble" then
                    r5.maxUses = u1169(u1174)
                    r5.curUses = r5.maxUses
                else
                    r5.maxUses = nil
                    r5.curUses = nil
                end
            end

            if r0 ~= "AbilityDuration" then
                return
            end

            local r6 = u1177:GetAttribute("AbilityActive")
            local r7 = u1174:GetAttribute("AbilityDuration")

            if r6 == true and r7 and r7 > 0 then
                r5.activeStart = u817()
                r5.activeDur = r7
            end
        end))
    end

    if u1174.Character then
        u1175(u1174.Character)
    end

    u1174.CharacterAdded:Connect(function(r0)
        u1175(r0)
    end)

    u1174.CharacterRemoving:Connect(function()
        local r0 = u1070.ability_esp.drawings[u1174]

        if not r0 then
            return
        end

        u1070.ability_esp.hide_all(r0)
        r0.activeStart = nil
        r0.activeDur = nil
        r0.cdStart = nil
        r0.cdLen = nil
        r0.cdQueue = {}
        r0.curUses = nil
        r0.maxUses = nil
    end)
end

u1070.ability_esp.track_player = __S[3]

__S[6] = function()
    local v1 = u817()
    local v2 = u1070.ability_esp

    for v3, v4 in u811(v2.drawings) do
        if not v3 or not v3.Parent then
            v2.remove_drawing(v3)
            continue
        end

        local v5 = v3.Character
        local v6 = v5 and (v5:FindFirstChild("HumanoidRootPart"))

        if not v6 then
            v2.hide_all(v4)
            continue
        end

        local v7, v8 = u1062:WorldToViewportPoint(v6.Position + u818.new(0, 3.5, 0))

        if not v8 or v7.Z < 0 then
            v2.hide_all(v4)
            continue
        end

        v5, v8 = Vector2.new(v7.X, v7.Y), 0

        if v2.show_name then
            v7 = v2.name_mode == "Username" and v3.Name or v3.DisplayName
            v4.nameDraw.Position = v5 + Vector2.new(0, -(v2.name_size - 9))
            v4.nameDraw.Text = v7
            v4.nameDraw.Size = v2.name_size
            v4.nameDraw.Color = v2.name_color
            v4.nameDraw.Visible = true
        else
            v4.nameDraw.Visible = false
        end

        if v2.mode == "Image" then
            v4.abilityDraw.Visible = false

            if v4.iconId and v4.iconId ~= "" and v4.iconId ~= "rbxassetid://0" then
                local v9, v10, v11 = v2.get_billboard(v4, v6)
                v10.Image = v4.iconId

                if v11 then
                    v11.Text = "V" .. u1166(v3, v4.abilityName) + 1
                end

                v9.Enabled = true
            elseif v4.billboard then
                v4.billboard.Enabled = false
            end

            local v12, v13, v14 = v2.ability_size * 3, u1062:WorldToViewportPoint(v6.Position + u818.new(0, 3.5 + (v4.billboard and v4.billboard.StudsOffset.Y or 4), 0))

            if v14 and v13.Z > 0 then
                u1062:WorldToViewportPoint(v6.Position + u818.new(0, 3.5 + (v4.billboard and v4.billboard.StudsOffset.Y or 4), 0))
                v8 += v12 * (v12 / u827.max(1, u1062.ViewportSize.Y / 10)) * 0.5 + 4
            else
                v8 += v2.ability_size + 4
            end
        else
            if v4.billboard then
                v4.billboard.Enabled = false
            end

            if v4.abilityLine then
                v4.abilityDraw.Position = v5 + Vector2.new(0, v8)
                v4.abilityDraw.Text = v4.abilityLine
                v4.abilityDraw.Size = v2.ability_size
                v4.abilityDraw.Color = v2.ability_color
                v4.abilityDraw.Visible = true
                v8 += v2.ability_size + 4
            else
                v4.abilityDraw.Visible = false
            end
        end

        if v4.abilityName == "Dribble" then
            v4.cdDraw.Visible = false
            local v15 = v4.maxUses or (u1169(v3))
            v7 = v3 == u1061 and (u1171()) or v4.curUses

            if v2.show_cd and v7 ~= nil then
                local v16 = v7 / u827.max(1, v15)
                v4.usesDraw.Color = u820.fromRGB(u827.floor(255 * (1 - v16)), u827.floor(255 * v16), 50)
                v4.usesDraw.Size = v2.active_size
                v4.usesDraw.Position = v5 + Vector2.new(0, v8)
                v4.usesDraw.Text = "uses  " .. v7
                v4.usesDraw.Visible = true
                v8 += v2.active_size + 2
            else
                v4.usesDraw.Visible = false
            end

            local v17 = 1

            while v17 <= #v4.cdQueue do
                v6 = v4.cdQueue[v17]

                if v1 - v6.t >= v6.dur then
                    if v3 ~= u1061 and v4.curUses ~= nil then
                        v4.curUses = u827.min(v15, v4.curUses + 1)
                    end

                    u825.remove(v4.cdQueue, v17)
                else
                    v17 += 1
                end
            end

            while #v4.cdDrawings < #v4.cdQueue do
                u825.insert(v4.cdDrawings, v2.new_cd_drawing())
            end

            if v2.show_cd then
                for v18, v19 in u812(v4.cdQueue) do
                    v17, v15 = u827.max(0, v19.dur - (v1 - v19.t)), v4.cdDrawings[v18]
                    v15.Size = v2.cd_size
                    v15.Color = v2.cd_color
                    v15.Position = v5 + Vector2.new(0, v8)
                    v15.Text = u826.format("cd %d  %.1fs", v18, v17)
                    v15.Visible = true
                    v8 += v2.cd_size + 2
                end

                for v20 = #v4.cdQueue + 1, #v4.cdDrawings do
                    v4.cdDrawings[v20].Visible = false
                end
            else
                for v21, v22 in u812(v4.cdDrawings) do
                    v22.Visible = false
                end
            end
        else
            v4.usesDraw.Visible = false

            for v23, v24 in u812(v4.cdDrawings) do
                v24.Visible = false
            end

            if v2.show_cd and v4.cdStart and v4.cdLen then
                local v25 = u827.max(0, v4.cdLen - (v1 - v4.cdStart))

                if v25 > 0 then
                    v4.cdDraw.Size = v2.cd_size
                    v4.cdDraw.Color = v2.cd_color
                    v4.cdDraw.Position = v5 + Vector2.new(0, v8)
                    v4.cdDraw.Text = u826.format("cd  %.1fs", v25)
                    v4.cdDraw.Visible = true
                    v8 += v2.cd_size + 2
                else
                    v4.cdDraw.Visible = false
                    v4.cdStart = nil
                    v4.cdLen = nil
                end
            else
                v4.cdDraw.Visible = false

                if v4.cdStart and v4.cdLen then
                    if v4.cdLen - (v1 - v4.cdStart) <= 0 then
                        v4.cdStart = nil
                        v4.cdLen = nil
                    end
                end
            end
        end

        if v2.show_timer and v4.activeStart and v4.activeDur then
            v3 = u827.max(0, v4.activeDur - (v1 - v4.activeStart))

            if v3 > 0 then
                v4.timerDraw.Size = v2.active_size
                v4.timerDraw.Color = v2.active_color
                v4.timerDraw.Position = v5 + Vector2.new(0, v8)
                v4.timerDraw.Text = u826.format("active  %.1fs", v3)
                v4.timerDraw.Visible = true
            else
                v4.timerDraw.Visible = false
                v4.activeStart = nil
                v4.activeDur = nil
            end
        else
            v4.timerDraw.Visible = false

            if v4.activeStart and v4.activeDur then
                if v4.activeDur - (v1 - v4.activeStart) <= 0 then
                    v4.activeStart = nil
                    v4.activeDur = nil
                end
            end
        end
    end
end  

u1070.ability_esp.update = __S[6]

__S[3] = function()
    if u1070.ability_esp.active then
        return
    end

    u1070.ability_esp.active = true

    pcall(function()
        require(u1057.Shared.Abilities)
    end)

    local r1 = u1054:GetPlayers()

    for r1_2, r2 in ipairs(r1) do
        if r2 ~= u1061 then
            u1070.ability_esp.track_player(r2)
        end
    end

    u1054.PlayerAdded:Connect(function(r0)
        if u1070.ability_esp.active and r0 ~= u1061 then
            u1070.ability_esp.track_player(r0)
        end
    end)

    u1054.PlayerRemoving:Connect(function(r0)
        u1070.ability_esp.remove_drawing(r0)
    end)

    u1070.ability_esp.connection = u1064:Connect(u1070.ability_esp.update)
end

u1070.ability_esp.start = __S[3]

__S[3] = function()
    if not u1070.ability_esp.active then
        return
    end

    u1070.ability_esp.active = false

    if u1070.ability_esp.connection then
        u1070.ability_esp.connection:Disconnect()
        u1070.ability_esp.connection = nil
    end

    for r1, r2 in pairs(u1070.ability_esp.drawings) do
        u1070.ability_esp.remove_drawing(r1)
    end
end

u1070.ability_esp.stop = __S[3]

__S[6] = function(...)
    return u1070.sapphire.IsCurved(...)
end

u1070.ball.is_curved = __S[6]
local u1178

local function u1179()
    if u1178 then
        return true
    end

    local r4 = u1057:FindFirstChild("Controllers")

    if not r4 then
        return false
    end

    local r292 = r4:GetChildren()

    for r1, r2 in ipairs(r292) do
        if r2.Name:find("SwordsController", 1, true) == 1 then
            local r7 = r2:FindFirstChild("PRY")

            if r7 then
                local r5, r6 = pcall(require, r7)

                if r5 and type(r6) == "function" then
                    u1178 = require(u1057.Packages.Signal).new()
                    u1178:Connect(r6)
                    return true
                end
            end
        end
    end

    return false
end

__S[6] = function()
    if u1068 then
        return false
    end

    if not u1179() then
        return false
    end

    local r1 = u1178.Fire
    local r2 = u1178
    local r4, r5, r6 = u1070.parry.get_payload()
    return pcall(r1, r2, 0.5, r4, r5, r6, false)
end

u1070.parry.fire_remote = __S[6]

u1061.CharacterAdded:Connect(function()
    u1070.state.grab_track = nil
end)

__S[3] = function()
    local r1 = u1061.Character

    if not r1 then
        return nil
    end

    local r4 = u1070.sword_changer.enabled

    if r4 then
        r4 = u1070.sword_changer.animations ~= "" and u1070.sword_changer.animations or r1:GetAttribute("CurrentlyEquippedSword")
    elseif not r4 then
        r4 = r1:GetAttribute("CurrentlyEquippedSword")
    end

    if not r4 then
        r4 = u1061:GetAttribute("CurrentlyEquippedSword")
    end

    return r4
end

u1070.animation.get_sword_name = __S[3]

__S[3] = function()
    local u1180 = u1070.animation.get_sword_name()
    local r4 = u1057.Shared.SwordAPI.Collection

    if u1180 then
        local function r0()
            return u1057.Shared.ReplicatedInstances.Swords.GetSword:Invoke(u1180)
        end

        local r2, r3 = pcall(r0)
        local r5 = r3

        if r2 and r5 and r5.AnimationType then
            local r0_2 = r4:FindFirstChild(r5.AnimationType)

            if r0_2 then
                return r0_2
            end
        end
    end

    return r4.Default
end

u1070.animation.get_anim_folder = __S[3]

__S[3] = function(r0, r1)
    if not r0 then
        return
    end

    local r300 = r0:GetPlayingAnimationTracks()

    for r3, u1181 in ipairs(r300) do
        for r6, r7 in ipairs(r1) do
            if u1181:GetAttribute(r7) then
                pcall(function()
                    u1181:Stop(u1181:GetAttribute("StopFadeTime"))
                end)

                break
            end
        end
    end
end

u1070.animation.stop_tracks_with_attrs = __S[3]

__S[3] = function()
    local r4 = u1061.Character

    if not r4 then
        return
    end

    local r5 = r4:FindFirstChildOfClass("Humanoid")
    local r10 = r5 and r5:FindFirstChildOfClass("Animator")

    if not r10 then
        return
    end

    if r4:GetAttribute("InOverdriveMech") then
        return
    end

    u1070.animation.stop_tracks_with_attrs(r10, {"SuccessParry", "Parry", "GrabParry"})
    local r1 = u1070.animation.get_anim_folder()

    if not r1 then
        return
    end

    local r11 = r1:FindFirstChild("GrabParry") or r1:FindFirstChild("Grab") or r1:FindFirstChild("Parry")

    if not r11 then
        return
    end

    local r13 = r10:LoadAnimation(r11)
    r13.Priority = u824.AnimationPriority.Action4
    r13:Play(r13:GetAttribute("PlayFadeTime"), r13:GetAttribute("PlayWeight"), r13:GetAttribute("PlaySpeed"))
    local r8 = r13:GetAttribute("PlaySpeed") or 1
    r4:SetAttribute("ParryTime", math.max(r4:GetAttribute("ParryTime") or 0, r13.Length == 0 and 1 or (r13.Length - r13.TimePosition) * r8))
    u1070.state.grab_track = r13
end

u1070.animation.play_grab = __S[3]

__S[3] = function()
    local u1182 = u1070.state.grab_track

    if u1182 then
        pcall(function()
            u1182:Stop(u1182:GetAttribute("StopFadeTime"))
        end)
    end

    u1070.state.grab_track = nil
    local r5 = u1061.Character

    if r5 then
        r5 = r5:FindFirstChildOfClass("Humanoid")
    end

    local r7 = r5 and r5:FindFirstChildOfClass("Animator")

    if not r7 then
        return
    end

    u1070.animation.stop_tracks_with_attrs(r7, {"GrabParry", "Parry"})
end

u1070.animation.stop_grab = __S[3]

__S[3] = function()
    local function u1183()
        local r1 = u1057.Remotes.ParrySuccess.OnClientEvent
        local u1184 = r1.Connect

        u1184(r1, function()
            local r0 = u1070.parry_cooldown
            r0.pending_id = r0.pending_id + 1
            u1070.parry_cooldown.failed_at = 0
            u1070.animation.stop_grab()

            if u1070.parry_hits.active then
                local r0_2 = u1070.player.get_root()

                if r0_2 then
                    u1070.parry_hits.spawn(r0_2.Position)
                end
            end

        end)
    end

    pcall(u1183)
end

u1070.animation.init = __S[3]

__S[3] = function(r0)
    local r3 = r0:FindFirstChild("CollisionWhitelist")

    if not r3 then
        return false
    end

    return r3.Value == u1061.Character
end

u1070.ball.is_model_targeting_me = __S[3]

__S[6] = function()
    local v1 = {}
    local v2 = {"Balls", "TrainingBalls"}

    for v3, v4 in u812(v2) do
        v3 = u797:FindFirstChild(v4)

        if not v3 then
            continue
        end

        for v5, v6 in u812(u1070.runtime_cache.Children(v3)) do
            if v6:GetAttribute("realBall") then
                u825.insert(v1, {part = v6, model = nil})
                continue
            end

            if v6:IsA("Model") then
                v5 = v6:FindFirstChild("Corpo") or v6.PrimaryPart or (v6:FindFirstChildWhichIsA("BasePart"))

                if v5 then
                    u825.insert(v1, {part = v5, model = v6})
                end
            end
        end
    end

    return v1
end  

u1070.ball.get_all = __S[6]

__S[6] = function()
    local v1 = u1061.Name
    local v2 = {}

    for v3, v4 in u812(u1070.ball.get_all()) do
        if if v4.model then (u1070.ball.is_model_targeting_me(v4.model)) else v4.part:GetAttribute("target") == v1 then
            u825.insert(v2, v4)
        end
    end

    return v2
end  

u1070.ball.get_targeted = __S[6]

__S[6] = function(v1, v2)
    if v2 then
        local v3 = v2:GetAttribute("Velocity")

        if u810(v3) == "Vector3" then
            return v3
        end
    end

    v2 = v1:FindFirstChild("zoomies")

    if v2 then
        return v2.VectorVelocity
    end

    return v1.AssemblyLinearVelocity
end  

u1070.ball.get_velocity = __S[6]

__S[3] = function()
    local r5 = u797:FindFirstChild("Balls")

    if not r5 then
        return nil
    end

    local r292 = r5:GetChildren()

    for r2, r3 in ipairs(r292) do
        if r3:IsA("BasePart") then
            return r3
        end
    end

    return nil
end

u1070.ball.get_first = __S[3]



__S[3] = function(...)
    return u1070.sapphire.CheckTornado(...)
end

u1070.ball.check_tornado = __S[3]

__S[6] = function()
    local v1 = u1061.Character
    return v1 and (v1:FindFirstChild("HumanoidRootPart"))
end  

u1070.player.get_root = __S[6]

__S[3] = function()
    local r4 = u1061.Character

    if not r4 then
        return false
    end

    local r3 = r4:FindFirstChildOfClass("Humanoid")
    local r0 = r4:FindFirstChild("HumanoidRootPart")
    local r1 = r3 ~= nil

    if r3 ~= nil then
        r1 = r0 ~= nil

        if r0 ~= nil then
            r1 = r3.Health > 0
        end
    end

    return r1
end

u1070.player.is_alive = __S[3]

__S[3] = function()
    local r1 = u1061.Character

    if not r1 or not r1.PrimaryPart then
        return false
    end

    return r1.PrimaryPart:FindFirstChild("SingularityCape") ~= nil
end

u1070.player.has_singularity_cape = __S[3]

__S[3] = function(context)
    if context and context.Characters then return context.Characters end
    local r4 = u797:FindFirstChild("Alive")

    if r4 then
        local list = u1070.runtime_cache.Children(r4)
        if context then context.Characters = list end
        return list
    end

    local r4_2 = {}
    local r289 = u1054:GetPlayers()

    for r1, r2 in ipairs(r289) do
        if r2.Character then
            table.insert(r4_2, r2.Character)
        end
    end

    if context then context.Characters = r4_2 end
    return r4_2
end

u1070.player.get_alive_chars = __S[3]

__S[3] = function(context)
    if context and context.ClosestRead then return context.Closest end
    if context then context.ClosestRead = true end
    local camera = context and context.Camera or u1062
    if not u1070.player.get_root() then
        return nil
    end

    local function r6()
        return u1056:GetMouseLocation()
    end

    local r5, r6_2 = pcall(r6)

    if not r5 then
        return nil
    end

    local r0 = camera:ScreenPointToRay(r6_2.X, r6_2.Y)
    local r8 = u819.lookAt(r0.Origin, r0.Origin + r0.Direction)
    local r9 = -(1/0)
    local r295 = u1070.player.get_alive_chars(context)
    local r10

    for r1, r2 in ipairs(r295) do
        if not (r2 == u1061.Character) then
            local r3 = r2:FindFirstChild("HumanoidRootPart")

            if r3 then
                local r4 = r8.LookVector:Dot((r3.Position - camera.CFrame.Position).Unit)

                if r9 < r4 then
                    r9 = r4
                    r10 = r2
                end
            end
        end
    end

    if context then context.Closest = r10 end
    return r10
end

u1070.player.get_closest_to_cursor = __S[3]

__S[3] = function(context)
    local target = u1070.target_player and u1070.target_player.Character()
    local root = target and u1070.target_player.RootOf(target)
    if root then return root.Position end
    local closest = u1070.player.get_closest_to_cursor(context)
    root = closest and (closest.PrimaryPart or closest:FindFirstChild("HumanoidRootPart"))
    if root then return root.Position end
    root = u1070.player.get_root()
    local camera = u797.CurrentCamera or u1062
    return root and camera and root.Position + camera.CFrame.LookVector * 1000 or nil
end

u1070.curve.get_target_pos = __S[3]

__S[3] = function(context)
    local camera = context and context.Camera or u797.CurrentCamera or u1062
    local cameraFrame = camera and camera.CFrame
    if not cameraFrame then return u819.new() end
    local character = u1061.Character
    local root = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
    if not root then return cameraFrame end
    local method = u864.normalize_curve_method(u1070.config.curve_method)
    if method == "Camera" or method == "BB Camera" then return cameraFrame end
    local position = u1070.curve.get_target_pos(context)
    if not position then
        local target = u1070.player.get_closest_to_cursor(context)
        local targetRoot = target and (target.PrimaryPart or target:FindFirstChild("HumanoidRootPart"))
        position = targetRoot and targetRoot.Position
    end
    if method == "Randomized Backwards" then
        local radians = math.random() * math.pi * 2
        local angle = math.random(20, 70) / 100
        local cf = root.CFrame
        local direction = (-cf.LookVector + (cf.RightVector * math.cos(radians) + cf.UpVector * math.sin(radians)) * angle).Unit
        return u819.lookAt(root.Position, root.Position + direction * 10000)
    elseif method == "Backwards" then
        local direction = -cameraFrame.LookVector * 10000
        return u819.new(cameraFrame.Position, cameraFrame.Position + Vector3.new(direction.X, 0, direction.Z))
    elseif method == "Stop" then
        return u819.new(root.Position, root.Position + Vector3.new(0, -3500, 0))
    elseif method == "High" then
        return u819.new(root.Position, root.Position + Vector3.new(0, 1e8, 0))
    elseif method == "Random" then
        local steer = position and (position - root.Position) or cameraFrame.LookVector
        if steer.Magnitude < 0.001 then return cameraFrame end
        local forward = steer.Unit
        local side = forward:Cross(math.abs(forward.Y) < 0.9 and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0)).Unit
        local up = side:Cross(forward)
        local angle = math.random() * math.pi * 2
        local direction = (side * math.cos(angle) + up * math.sin(angle) - forward * (0.25 + math.random() * 0.55)).Unit
        return u819.new(root.Position, root.Position + direction * 1500)
    elseif position and method == "Straight" then
        return u819.new(root.Position, position + Vector3.new(0, 10, 0))
    elseif position and method == "Dot" then
        return (position - root.Position).Magnitude > 0.001 and u819.lookAt(root.Position, position) or root.CFrame
    end
    return root.CFrame
end
u1070.curve.get_cframe = __S[3]

__S[3] = function(context)
    local aim = u1070.target_player and u1070.target_player.GetAim(context)
    if aim then return aim.Points end
    local camera = context and context.Camera or u1062
    local r6 = {}

    if not u1070.target_player and u1070.config.target_player_enabled and u1070.config.target_player_name then
        local u1187 = u1054:FindFirstChild(u1070.config.target_player_name)

        if u1187 and u1187.Character and u1187.Character.PrimaryPart then
            local function r5()
                return camera:WorldToScreenPoint(u1187.Character.PrimaryPart.Position)
            end

            local r4, r5_2 = pcall(r5)

            if r4 then
                r6[u1187.Character.Name] = r5_2
            end
        end

        return r6
    end

    local r291 = u1070.player.get_alive_chars(context)

    for r1, u1188 in ipairs(r291) do
        if u1188.PrimaryPart then
            local function r5_3()
                return camera:WorldToScreenPoint(u1188.PrimaryPart.Position)
            end

            local r4_2, r5_4 = pcall(r5_3)

            if r4_2 then
                r6[u1188.Name] = r5_4
            end
        end
    end

    return r6
end

u1070.parry.get_event_data = __S[3]

__S[3] = function(context)
    local aim = u1070.target_player and u1070.target_player.GetAim(context)
    if aim then return aim.Coordinates end
    local camera = context and context.Camera or u1062
    if u1070.config.is_mobile then
        local r0 = u1062.ViewportSize
        return {r0.X / 2, r0.Y / 2}
    end

    if not u1070.target_player and u1070.config.target_player_enabled and u1070.config.target_player_name then
        local r0_2 = u1054:FindFirstChild(u1070.config.target_player_name)

        if r0_2 and r0_2.Character then
            local u1189 = r0_2.Character:FindFirstChild("HumanoidRootPart")

            if u1189 then
                local function r3()
                    return camera:WorldToScreenPoint(u1189.Position)
                end

                local r2, r3_2 = pcall(r3)

                if r2 then
                    return {r3_2.X, r3_2.Y}
                end
            end
        end
    end

    local r2_2 = u1070.player.get_closest_to_cursor(context)

    if r2_2 then
        local u1190 = r2_2:FindFirstChild("HumanoidRootPart")

        if u1190 then
            local function r3_3()
                return camera:WorldToScreenPoint(u1190.Position)
            end

            local r2_3, r3_4 = pcall(r3_3)

            if r2_3 then
                return {r3_4.X, r3_4.Y}
            end
        end
    end

    local function r2_4()
        return u1056:GetMouseLocation()
    end

    local r1, r2_5 = pcall(r2_4)

    if r1 then
        r1 = {r2_5.X, r2_5.Y}
    end

    if not r1 then
        r1 = {0, 0}
    end

    return r1
end

u1070.parry.get_mouse_vec = __S[3]

function u1070.parry.get_payload(context)
    context = context or {Camera = u797.CurrentCamera or u1062}
    local frame = u1070.curve.get_cframe(context)
    local targets = u1070.parry.get_event_data(context)
    local coordinates = u1070.parry.get_mouse_vec(context)
    return frame, targets, coordinates
end

__S[3] = function()
    if u1070.config.parry_mode == "Keypress" then
        u1076()
        task.spawn(u1070.animation.play_grab)
        return
    end

    if not u1070.parry.fire_remote() then
        u1076()
    end

    task.spawn(u1070.animation.play_grab)
end

u1070.parry.execute = __S[3]

__S[6] = function(v1)
    if v1 == "Keypress" then
        u1075()
        return
    end

    if not u1070.parry.fire_remote() then
        u1075()
    end
end  

u1070.parry.execute_fast = __S[6]

__S[3] = function(r0, r1)
    local r2 = u1070.player.get_root()

    if not r2 then
        return false
    end

    local r6 = u1070.ball.get_velocity(r0, r1).Magnitude
    return (r2.Position - r0.Position).Magnitude <= u1070.parry.get_premium_parry_distance(r6, u1070.config.accuracy)
end

u1070.parry.should_fire = __S[3]

__S[3] = function()
    if not u1070.ability.cooldown_protection then
        return false
    end

    local r0 = u1070.parry_cooldown.failed_at

    if r0 == 0 then
        return false
    end

    if u817() - r0 >= u1070.parry_cooldown.duration then
        u1070.parry_cooldown.failed_at = 0
        return false
    end

    local r0_2 = pcall(function()
        u1057.Remotes.AbilityButtonPress:Fire()
    end)

    u1070.parry_cooldown.failed_at = 0
    return r0_2
end

u1070.parry.try_cooldown_protection = __S[3]

__S[3] = function()
    local u1191 = u1070.ability.auto_ability

    if not u1191 then
        return false
    end

    local function r1()
        if u1061.PlayerGui.Hotbar.Ability.UIGradient.Offset.Y ~= 0.5 then
            return false
        end

        local r9 = u1061.Character and u1061.Character:FindFirstChild("Abilities")

        if not r9 then
            return false
        end

        for r1, r2 in ipairs({
            "Raging Deflection",
            "Rapture",
            "Calming Deflection",
            "Aerodynamic Slash",
            "Fracture",
            "Death Slash"
        }) do
            local r6 = r9:FindFirstChild(r2)

            if r6 and r6.Enabled then
                u1057.Remotes.AbilityButtonPress:Fire()

                if r2 == "Death Slash" then
                    local u1192 = task.delay

                    u1192(2.432, function()
                        pcall(function()
                            u1057:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                        end)
                    end)
                end

                return true
            end
        end

        return false
    end

    u1191 = pcall
    local r1_2
    u1191, r1_2 = u1191(r1)
    return u1191 and r1_2
end

u1070.parry.try_auto_ability = __S[3]

 
__S[6] = function()
    if u1070.sapphire then return u1070.sapphire.StepAuto() end
end

u1070.parry.process = __S[6]

 
u1070.triggerbot.process = function()
    if u1070.sapphire then return u1070.sapphire.StepTrigger() end
end
u1070.triggerbot.set = function(enabled)
    if u1070.sapphire then return u1070.sapphire.SetTriggerEnabled(enabled) end
end


 
u1070.spam.manual_start = function()
    if u1070.oxy_manual then u1070.oxy_manual.SetManual(true) end
end
u1070.spam.manual_stop = function()
    if u1070.oxy_manual then u1070.oxy_manual.SetManual(false) end
end

 
u1070.spam.auto_start = function()
    if u1070.oxy_manual then u1070.oxy_manual.SetAuto(true) end
end
u1070.spam.auto_stop = function()
    if u1070.oxy_manual then u1070.oxy_manual.SetAuto(false) end
end

__S[3] = function(r0, r1)
    u1070.player_mods.fov_enabled = r0
    local r2 = u1070.player_mods

    if not r1 then
        r1 = u1070.player_mods.fov
    end

    r2.fov = r1

    u1062.FieldOfView = r0 and u1070.player_mods.fov or 70
end

u1070.player_mods.set_fov = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.speed_enabled = r0
    u1070.player_mods.speed = r1 or u1070.player_mods.speed

    if u1070.player_mods.speed_conn then
        u1070.player_mods.speed_conn:Disconnect()
        u1070.player_mods.speed_conn = nil
    end

    if r0 then
        local function r1_2()
            local v1 = u1061.Character
            local v2 = v1 and (v1:FindFirstChildOfClass("Humanoid"))

            if v2 then
                v2.WalkSpeed = u1070.player_mods.speed
            end
        end  

        u1070.player_mods.speed_conn = u1063:Connect(r1_2)
    else
        local r4 = u1061.Character

        if r4 then
            r4 = r4:FindFirstChildOfClass("Humanoid")
        end

        if r4 then
            r4.WalkSpeed = 36
        end
    end
end

u1070.player_mods.set_speed = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.gravity_enabled = r0
    u1070.player_mods.gravity = r1 or u1070.player_mods.gravity
    local r2 = u797

    if r0 then
        r0 = u1070.player_mods.gravity
    end

    if not r0 then
        r0 = 196.2
    end

    r2.Gravity = r0
end

u1070.player_mods.set_gravity = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.jump_power_enabled = r0
    local r2 = u1070.player_mods

    if not r1 then
        r1 = u1070.player_mods.jump_power
    end

    r2.jump_power = r1

    if u1070.player_mods.jump_conn then
        u1070.player_mods.jump_conn:Disconnect()
        u1070.player_mods.jump_conn = nil
    end

    if r0 then
        local function r1_2()
            local v1 = u1061.Character
            local v2 = v1 and (v1:FindFirstChildOfClass("Humanoid"))

            if not v2 then
                return
            end

            if v2.UseJumpPower then
                v2.JumpPower = u1070.player_mods.jump_power
            else
                v2.JumpHeight = u1070.player_mods.jump_power / 5
            end
        end  

        u1070.player_mods.jump_conn = u1063:Connect(r1_2)
    else
        local r3 = u1061.Character

        if r3 then
            r3 = r3:FindFirstChildOfClass("Humanoid")
        end

        if r3 then
            if r3.UseJumpPower then
                r3.JumpPower = 50
            else
                r3.JumpHeight = 7.2
            end
        end
    end
end

u1070.player_mods.set_jump_power = __S[3]

__S[3] = function(r0)
    u1070.player_mods.infinite_jump_enabled = r0

    if u1070.player_mods.infinite_jump_conn then
        u1070.player_mods.infinite_jump_conn:Disconnect()
        u1070.player_mods.infinite_jump_conn = nil
    end

    if r0 then
        local function r0_2()
            local r4 = u1061.Character

            if r4 then
                r4 = r4:FindFirstChildOfClass("Humanoid")
            end

            if r4 then
                r4:ChangeState(u824.HumanoidStateType.Jumping)
            end
        end

        u1070.player_mods.infinite_jump_conn = u1056.JumpRequest:Connect(r0_2)
    end
end

u1070.player_mods.set_infinite_jump = __S[3]

__S[3] = function()
    local r5 = u797:FindFirstChild("Balls")

    if not r5 then
        return nil
    end

    local r293 = r5:GetChildren()

    for r2, r3 in ipairs(r293) do
        if r3:IsA("BasePart") then
            return r3
        end
    end

    return nil
end

u1070.ball_trail.get_ball = __S[3]

__S[3] = function()
    local r0 = u1070.ball_trail.color

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, r0),
        ColorSequenceKeypoint.new(0.5, u820.new(math.min(r0.R * 1.3, 1), math.min(r0.G * 1.3, 1), math.min(r0.B * 1.3, 1))),
        ColorSequenceKeypoint.new(1, r0)
    })
end

u1070.ball_trail.build_color_sequence = __S[3]

__S[3] = function(r0)
    u1070.ball_trail.detach()
    local r9 = u1070.ball_trail.num_trails

    for r1 = 1, r9 do
        local r10 = r1 / r9 * 3.141592653589793 * 2
        local r17 = math.random(150, 250) / 100
        local r3 = math.random(-150, 150) / 100
        local r18 = u850.new("Attachment")
        r18.Position = Vector3.new(math.cos(r10) * r17, r3, math.sin(r10) * r17)
        r18.Parent = r0
        local r2 = u850.new("Attachment")
        r2.Position = Vector3.new(math.cos(r10 + 3.141592653589793 * 0.7) * r17 * 1.3, -r3, math.sin(r10 + 3.141592653589793 * 0.7) * r17 * 1.3)
        r2.Parent = r0
        local r19 = u850.new("Trail")
        r19.Attachment0 = r18
        r19.Attachment1 = r2
        r19.Lifetime = 0.6
        r19.MinLength = 0
        r19.FaceCamera = true
        r19.LightEmission = 1
        r19.LightInfluence = 0
        r19.Texture = "rbxassetid://5029929719"
        r19.TextureMode = u824.TextureMode.Stretch
        r19.Color = u1070.ball_trail.build_color_sequence()

        r19.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })

        r19.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.3, 0.25),
            NumberSequenceKeypoint.new(0.7, 0.15),
            NumberSequenceKeypoint.new(1, 0.02)
        })

        r19.Parent = r0

        table.insert(u1070.ball_trail.attachments, {
            a0 = r18,
            a1 = r2,
            trail = r19,
            baseAngle = r10,
            angle = 0,
            speed = math.random(15, 30) / 10,
            spiralSpeed = math.random(25, 45) / 10,
            radiusMultiplier = math.random(80, 120) / 100,
            pulseOffset = math.random() * 3.141592653589793 * 2,
            baseRadius = r17,
            baseHeight = r3,
            chaosSpeed = math.random(10, 20) / 10
        })
    end
end

u1070.ball_trail.attach = __S[3]

__S[3] = function()
    for r1, r2 in ipairs(u1070.ball_trail.attachments) do
        if r2.a0 and r2.a0.Parent then
            r2.a0:Destroy()
        end

        if r2.a1 and r2.a1.Parent then
            r2.a1:Destroy()
        end

        if r2.trail and r2.trail.Parent then
            r2.trail:Destroy()
        end
    end

    u1070.ball_trail.attachments = {}
end

u1070.ball_trail.detach = __S[3]

__S[6] = function(v1)
    if not u1070.ball_trail.active then
        return
    end

    local v2 = u817()

    for v3, v4 in u812(u1070.ball_trail.attachments) do
        if not v4.a0.Parent then
            continue
        end

        v4.angle = v4.angle + v4.speed * v1
        local v5 = v4.angle * v4.spiralSpeed
        local v6, v7, v8 = u827.sin(v2 * 4 + v4.pulseOffset) * 0.4 + 1, u827.sin(v4.angle * 3) * 0.7, u827.sin(v2 * v4.chaosSpeed + v4.pulseOffset) * 0.5
        local v9 = v4.baseRadius * v4.radiusMultiplier * v6
        local v10 = v4.baseRadius * 1.3 * v4.radiusMultiplier * v6
        v4.a0.Position = u818.new(u827.cos(v4.baseAngle + v4.angle) * v9 + u827.cos(v5) * 0.6, v4.baseHeight + u827.sin((v4.baseAngle + v4.angle) * 3) * 0.8 + v7 + v8 + u827.sin(v5 * 2) * 0.6, u827.sin(v4.baseAngle + v4.angle) * v9 + u827.sin(v5) * 0.6)
        v4.a1.Position = u818.new(u827.cos(v4.baseAngle + v4.angle + u827.pi * 0.7) * v10 + u827.sin(v5 * 1.3) * 0.5, -v4.baseHeight + u827.cos((v4.baseAngle + v4.angle) * 2.5) * 0.8 - v7 - v8 + u827.cos(v5 * 1.7) * 0.5, u827.sin(v4.baseAngle + v4.angle + u827.pi * 0.7) * v10 + u827.cos(v5 * 1.1) * 0.5)
        v4.trail.LightEmission = u827.sin(v2 * 5 + v4.pulseOffset) * 0.4 + 0.6
    end
end  

u1070.ball_trail.animate = __S[6]

__S[3] = function()
    if u1070.ball_trail.active then
        return
    end

    u1070.ball_trail.active = true;

    (function()
        local r0 = u1070.ball_trail.get_ball()

        if r0 then
            u1070.ball_trail.attach(r0)
        end
    end)()

    local function r2(v1)
        if not u1070.ball_trail.active then
            return
        end

        local v2 = u1070.ball_trail.get_ball()

        if not v2 then
            u1070.ball_trail.detach()
            return
        end

        if #u1070.ball_trail.attachments == 0 then
            u1070.ball_trail.attach(v2)
        end

        u1070.ball_trail.animate(v1)
    end  

    u1070.ball_trail.connection = u1063:Connect(r2)
end

u1070.ball_trail.start = __S[3]

__S[3] = function()
    if not u1070.ball_trail.active then
        return
    end

    u1070.ball_trail.active = false

    if u1070.ball_trail.connection then
        u1070.ball_trail.connection:Disconnect()
        u1070.ball_trail.connection = nil
    end

    u1070.ball_trail.detach()
end

u1070.ball_trail.stop = __S[3]

__S[3] = function(r0)
    u1070.ball_trail.color = r0

    for r2, r3 in ipairs(u1070.ball_trail.attachments) do
        if r3.trail and r3.trail.Parent then
            r3.trail.Color = u1070.ball_trail.build_color_sequence()
        end
    end
end

u1070.ball_trail.update_color = __S[3]

 
do
    local B = u1070.ball_velocity
    local function magnitude(value)
        if typeof(value) ~= "Vector3" then return nil end
        local speed = value.Magnitude
        if speed ~= speed or speed == math.huge then return nil end
        return speed
    end
    local function readVelocity(object, property)
        if not object then return nil end
        local ok, value = pcall(function() return object[property] end)
        return ok and magnitude(value) or nil
    end
    function B.ResolvePart(ball)
        if ball:IsA("BasePart") then return ball end
        if not ball:IsA("Model") then return nil end
        for _, name in ipairs({"Corpo", "Body", "HumanoidRootPart"}) do
            local part = ball:FindFirstChild(name)
            if part and part:IsA("BasePart") then return part end
        end
        local primary = ball.PrimaryPart
        if primary and primary:IsA("BasePart") then return primary end
        return ball:FindFirstChildWhichIsA("BasePart", true)
    end
    function B.SpeedOf(ball, part, now)
        local position = part.Position
        local previous = B.samples[part]
        local oldPosition, oldTime = previous and previous.Position, previous and previous.Time
        if previous then previous.Position, previous.Time = position, now
        else B.samples[part] = {Position = position, Time = now} end
         
        local zoomies = ball:FindFirstChild("zoomies") or part:FindFirstChild("zoomies")
        local speed = readVelocity(zoomies, "VectorVelocity")
        if speed and speed > 0.001 then return speed end
        speed = magnitude(ball:GetAttribute("Velocity"))
        if speed and speed > 0.001 then return speed end
        if ball ~= part then
            speed = magnitude(part:GetAttribute("Velocity"))
            if speed and speed > 0.001 then return speed end
        end
        speed = readVelocity(part, "AssemblyLinearVelocity")
        if speed and speed > 0.001 then return speed end
        speed = readVelocity(part, "Velocity")
        if speed and speed > 0.001 then return speed end
         
        if previous then
            local elapsed = now - oldTime
            if elapsed > 0.001 and elapsed <= 0.5 then
                return magnitude((position - oldPosition) / elapsed) or 0
            end
        end
        return 0
    end
    function B.Sample(now)
        if not B.active then return 0, B.peak_speed or 0 end
        B.samples = B.samples or setmetatable({}, {__mode = "k"})
        B.peak = B.peak or setmetatable({}, {__mode = "k"})
        local best, bestPriority, current = nil, -1, 0
        for _, name in ipairs({"Balls", "TrainingBalls"}) do
            local folder = u797:FindFirstChild(name)
            if folder then
                for _, ball in ipairs(u1070.runtime_cache.Children(folder)) do
                    local part = B.ResolvePart(ball)
                    local real = ball:GetAttribute("realBall")
                    if real == nil and part then real = part:GetAttribute("realBall") end
                    local zoomies = part and (ball:FindFirstChild("zoomies") or part:FindFirstChild("zoomies"))
                    local target = ball:GetAttribute("target") or (part and part:GetAttribute("target"))
                    local marked = real == true or zoomies or target or ball:FindFirstChild("TargetAttachment")
                        or ball:FindFirstChild("CollisionWhitelist") or typeof(ball:GetAttribute("Velocity")) == "Vector3"
                        or (part and typeof(part:GetAttribute("Velocity")) == "Vector3")
                    if part and part.Parent and real ~= false and marked then
                        local speed = B.SpeedOf(ball, part, now)
                        local peak = math.max(B.peak[ball] or 0, speed)
                        B.peak[ball] = peak
                        B.peak_speed = math.max(B.peak_speed or 0, peak)
                        if u1070.sapphire and type(u1070.sapphire.Target) == "function" then
                            local ok, resolved = pcall(u1070.sapphire.Target, ball)
                            if ok and resolved ~= nil then target = resolved end
                        end
                        local priority = (target == u1061.Name and 100 or 0) + (name == "Balls" and 10 or 0)
                        if priority > bestPriority or priority == bestPriority and speed > current then
                            best, bestPriority, current = ball, priority, speed
                        end
                    end
                end
            end
        end
        B.current_ball, B.current_speed = best, current
        return current, B.peak_speed or 0
    end
end

__S[3] = function()
    if u1070.ball_velocity.active then
        return
    end

    u1070.ball_velocity.active = true
    u1070.ball_velocity.peak = setmetatable({}, {__mode = "k"})
    u1070.ball_velocity.samples = setmetatable({}, {__mode = "k"})
    u1070.ball_velocity.current_ball = nil
    u1070.ball_velocity.current_speed, u1070.ball_velocity.peak_speed = 0, 0
    u1070.ball_velocity.last_update = nil
    u1070.ball_velocity.drag_connections = {}
    local r6 = u858()
    r6.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    local u1193 = u847("Frame")
    u1193.Size = u821.new(0, 230, 0, 130)
    u1193.Position = u821.new(0, 20, 0, 150)
    u1193.BackgroundColor3 = u820.fromRGB(17, 17, 24)
    u1193.BorderSizePixel = 0
    u1193.Parent = r6
    local r0 = u850.new("UICorner")
    r0.CornerRadius = u822.new(0, 12)
    r0.Parent = u1193
    local r0_2 = u850.new("UIStroke")
    r0_2.Thickness = 1
    r0_2.Color = u820.fromRGB(36, 40, 58)
    r0_2.Parent = u1193
    local r9 = u850.new("Frame")
    r9.Size = u821.new(1, 0, 0, 34)
    r9.BackgroundColor3 = u820.fromRGB(13, 13, 20)
    r9.BorderSizePixel = 0
    r9.Parent = u1193
    local r0_3 = u850.new("UICorner")
    r0_3.CornerRadius = u822.new(0, 12)
    r0_3.Parent = r9
    local r0_4 = u850.new("Frame")
    r0_4.Size = u821.new(1, 0, 0, 12)
    r0_4.Position = u821.new(0, 0, 1, -12)
    r0_4.BackgroundColor3 = u820.fromRGB(13, 13, 20)
    r0_4.BorderSizePixel = 0
    r0_4.Parent = r9
    local r0_5 = u850.new("TextLabel")
    r0_5.Size = u821.new(1, -16, 1, 0)
    r0_5.Position = u821.new(0, 12, 0, 0)
    r0_5.BackgroundTransparency = 1
    r0_5.Text = "Ball Stats"
    r0_5.TextColor3 = u820.fromRGB(235, 234, 239)
    r0_5.TextSize = 13
    r0_5.Font = u824.Font.GothamBold
    r0_5.TextXAlignment = u824.TextXAlignment.Left
    r0_5.Parent = r9
    local u1194 = u850.new("Frame")
    u1194.Size = u821.new(1, -24, 1, -44)
    u1194.Position = u821.new(0, 12, 0, 40)
    u1194.BackgroundTransparency = 1
    u1194.Parent = u1193

    local function r4(r0, r1)
        local r3 = u850.new("Frame")
        r3.Size = u821.new(1, 0, 0, 38)
        r3.Position = u821.new(0, 0, 0, r1)
        r3.BackgroundTransparency = 1
        r3.Parent = u1194
        local r2 = u850.new("TextLabel")
        r2.Size = u821.new(1, 0, 0, 14)
        r2.Position = u821.new(0, 0, 0, 0)
        r2.BackgroundTransparency = 1
        r2.Text = r0
        r2.TextColor3 = u820.fromRGB(148, 152, 185)
        r2.TextSize = 11
        r2.Font = u824.Font.Gotham
        r2.TextXAlignment = u824.TextXAlignment.Left
        r2.Parent = r3
        local r2_2 = u850.new("TextLabel")
        r2_2.Size = u821.new(1, 0, 0, 22)
        r2_2.Position = u821.new(0, 0, 0, 15)
        r2_2.BackgroundTransparency = 1
        r2_2.Text = "0.0"
        r2_2.TextColor3 = u820.fromRGB(172, 178, 255)
        r2_2.TextSize = 18
        r2_2.Font = u824.Font.GothamBold
        r2_2.TextXAlignment = u824.TextXAlignment.Left
        r2_2.Parent = r3
        return r2_2
    end

    local u1195 = r4("Current Velocity", 0)
    local u1196 = r4("Peak Velocity", 42)
    local u1197 = false
    local u1198
    local u1199

    local function listen(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(u1070.ball_velocity.drag_connections, connection)
        return connection
    end
    listen(r9.InputBegan, function(r0)
        if r0.UserInputType == u824.UserInputType.MouseButton1 or r0.UserInputType == u824.UserInputType.Touch then
            u1197 = true
            u1198 = r0.Position
            u1199 = u1193.Position
        end
    end)

    listen(u1056.InputChanged, function(r0)
        local r2 = u1197

        if u1197 and (r0.UserInputType == u824.UserInputType.MouseMovement or r0.UserInputType == u824.UserInputType.Touch) then
            local r1 = r0.Position - u1198
            u1193.Position = u821.new(u1199.X.Scale, u1199.X.Offset + r1.X, u1199.Y.Scale, u1199.Y.Offset + r1.Y)
        end
    end)

    listen(u1056.InputEnded, function(r0)
        if r0.UserInputType == u824.UserInputType.MouseButton1 or r0.UserInputType == u824.UserInputType.Touch then
            u1197 = false
        end
    end)

    u1070.ball_velocity.gui = r6

    local function r6_2()
        local stats = u1070.ball_velocity
        if not stats.active or stats.gui ~= r6 then return end
        local now = u1066()
        if stats.last_update and now - stats.last_update < 0.1 then return end
        stats.last_update = now
        local current, peak = stats.Sample(now)
        u1195.Text = string.format("%.1f", current)
        u1196.Text = string.format("%.1f", peak)
    end

    listen(r6.Destroying, function() u1070.ball_velocity.stop() end)
    u1070.ball_velocity.connection = u1063:Connect(r6_2)
    r6_2()
end

u1070.ball_velocity.start = __S[3]

__S[3] = function()
    if not u1070.ball_velocity.active then
        return
    end

    u1070.ball_velocity.active = false
    for _, connection in ipairs(u1070.ball_velocity.drag_connections or {}) do connection:Disconnect() end
    u1070.ball_velocity.drag_connections = nil

    if u1070.ball_velocity.connection then
        u1070.ball_velocity.connection:Disconnect()
        u1070.ball_velocity.connection = nil
    end

    if u1070.ball_velocity.gui then
        u1070.ball_velocity.gui:Destroy()
        u1070.ball_velocity.gui = nil
    end

    u1070.ball_velocity.peak = {}
    u1070.ball_velocity.samples = nil
    u1070.ball_velocity.current_ball = nil
    u1070.ball_velocity.current_speed, u1070.ball_velocity.peak_speed = 0, 0
    u1070.ball_velocity.last_update = nil
end

u1070.ball_velocity.stop = __S[3]

__S[3] = function()
    if u1070.no_render.active then
        return
    end

    u1070.no_render.active = true

    pcall(function()
        u1061.PlayerScripts.EffectScripts.ClientFX.Disabled = true
    end)

    if u1067 then
        u1070.no_render.connection = u1067.ChildAdded:Connect(function(r0)
            if u1070.no_render.active then
                u796:GetService("Debris"):AddItem(r0, 0)
            end
        end)
    end
end

u1070.no_render.start = __S[3]

__S[3] = function()
    if not u1070.no_render.active then
        return
    end

    u1070.no_render.active = false

    pcall(function()
        u1061.PlayerScripts.EffectScripts.ClientFX.Disabled = false
    end)

    if u1070.no_render.connection then
        u1070.no_render.connection:Disconnect()
        u1070.no_render.connection = nil
    end
end

u1070.no_render.stop = __S[3]

__S[3] = function()
    if u1070.ball_indicator.active then
        return
    end

    u1070.ball_indicator.active = true
    local r6 = u858()
    r6.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    local u1200 = u850.new("Frame")
    u1200.Size = u821.new(0, u1070.ball_indicator.size, 0, u1070.ball_indicator.size)
    u1200.Position = u821.new(0.5, 0, 0.5, 0)
    u1200.AnchorPoint = Vector2.new(0.5, 0.5)
    u1200.BackgroundTransparency = 1
    u1200.Parent = r6
    local u1201 = u850.new("ImageLabel")
    u1201.BackgroundTransparency = 1
    u1201.Size = u821.new(1, 0, 1, 0)
    u1201.Position = u821.new(0.5, 0, 0.5, 0)
    u1201.AnchorPoint = Vector2.new(0.5, 0.5)
    u1201.Image = "rbxassetid://18604510750"
    u1201.ImageColor3 = u820.new(0, 0, 0)
    u1201.Parent = u1200
    u1070.ball_indicator.gui = r6

    local function r2()
    end

    u1070.ball_indicator.connection = u1064:Connect(r2)
end

u1070.ball_indicator.start = __S[3]

__S[3] = function()
    if not u1070.ball_indicator.active then
        return
    end

    u1070.ball_indicator.active = false

    if u1070.ball_indicator.connection then
        u1070.ball_indicator.connection:Disconnect()
        u1070.ball_indicator.connection = nil
    end

    if u1070.ball_indicator.gui then
        u1070.ball_indicator.gui:Destroy()
        u1070.ball_indicator.gui = nil
    end
end

u1070.ball_indicator.stop = __S[3]

__S[3] = function(r0)
    local u1202 = u1070.plushies.models[r0]

    if not u1202 then
        return nil
    end

    if not u1070.plushies.loaded_models[r0] then
        local function r9()
            return u796:GetObjects(u1202)[1]
        end

        local r8, r9_2 = pcall(r9)

        if not r8 or not r9_2 then
            return nil
        end

        u1070.plushies.loaded_models[r0] = r9_2
    end

    local r5 = u1070.plushies.loaded_models[r0]:Clone()
    r5.Name = r0
    local r12 = u1070.plushies.scales[r0] or 1.5
    local r296 = r5:GetDescendants()

    for r3, r4 in ipairs(r296) do
        if r4:IsA("BasePart") or r4:IsA("MeshPart") then
            r4.CanCollide = false
            r4.Anchored = false
            r4.Size = r4.Size * r12
            local r6 = r4:FindFirstChildOfClass("SpecialMesh")

            if r6 then
                r6.Scale = r6.Scale * r12
            end
        end
    end

    local r2 = r5:FindFirstChildOfClass("BasePart") or r5:FindFirstChildOfClass("MeshPart")

    if r2 then
        r5.PrimaryPart = r2
    end

    return r5
end

u1070.plushies.create = __S[3]

__S[6] = function()
    if not u1070.plushies.active then
        return
    end

    local v1 = u1061.Character

    if not v1 or not v1.PrimaryPart or not u1070.plushies.folder then
        return
    end

    local v2 = 1

    for v3 in u811(u1070.plushies.active_types) do
        local v4, v5 = u1070.plushies.positions[(v2 - 1) % #u1070.plushies.positions + 1], u1070.plushies.folder:FindFirstChild(v3)

        if not v5 then
            local v6 = u1070.plushies.create(v3)

            if v6 then
                v6.Parent = u1070.plushies.folder
                v6:SetPrimaryPartCFrame(u819.new(v1.PrimaryPart.Position + v4))
                v5 = v6
            end
        end

        if v5 and v5.PrimaryPart then
            local v7 = v5.PrimaryPart
            local v8 = u818.new(0, u827.sin(u817() * 2) * 0.3, 0)
            local v9, v10 = v1.PrimaryPart.CFrame * u819.new(v4 + v8) * (u1070.plushies.rotations[v3] or (u819.new())), v7:FindFirstChild("PlushieBP")

            if not v10 then
                v10 = u850.new("BodyPosition")
                v10.Name = "PlushieBP"
                v10.MaxForce = u818.new(40000, 40000, 40000)
                v10.P = 10000
                v10.D = 1000
                v10.Parent = v7
            end

            v10.Position = v9.Position
            v7.CFrame = u819.new(v7.Position) * v9.Rotation
        end

        v2 += 1
    end

    for v11, v12 in u812(u1070.plushies.folder:GetChildren()) do
        if not u1070.plushies.active_types[v12.Name] then
            v12:Destroy()
        end
    end
end  

u1070.plushies.update = __S[6]

__S[3] = function()
    if u1070.plushies.active then
        return
    end

    u1070.plushies.active = true
    u1070.plushies.folder = u850.new("Folder")
    u1070.plushies.folder.Name = "Plushies_Temp"
    u1070.plushies.folder.Parent = u1058
    u1070.plushies.connection = u1064:Connect(u1070.plushies.update)
end

u1070.plushies.start = __S[3]

__S[3] = function()
    if not u1070.plushies.active then
        return
    end

    u1070.plushies.active = false

    if u1070.plushies.connection then
        u1070.plushies.connection:Disconnect()
        u1070.plushies.connection = nil
    end

    if u1070.plushies.folder then
        u1070.plushies.folder:Destroy()
        u1070.plushies.folder = nil
    end
end

u1070.plushies.stop = __S[3]

__S[3] = function()
    if u1070.orbit_ball.active then
        return
    end

    u1070.orbit_ball.active = true
    u1070.orbit_ball.angle = 0

    local function r2()
    end

    u1070.orbit_ball.connection = u1063:Connect(r2)
end

u1070.orbit_ball.start = __S[3]

__S[3] = function()
    if not u1070.orbit_ball.active then
        return
    end

    u1070.orbit_ball.active = false
    local r5 = u1061.Character

    if r5 then
        r5 = r5:FindFirstChildOfClass("Humanoid")
    end

    if r5 then
        u1062.CameraSubject = r5
    end

    if u1070.orbit_ball.connection then
        u1070.orbit_ball.connection:Disconnect()
        u1070.orbit_ball.connection = nil
    end
end

u1070.orbit_ball.stop = __S[3]

__S[6] = function()
    if not u1070.winstreak.enabled then
        if u1070.winstreak.conn then
            u1070.winstreak.conn:Disconnect()
            u1070.winstreak.conn = nil
        end

        if u1070.winstreak.enabled_conn then
            u1070.winstreak.enabled_conn:Disconnect()
            u1070.winstreak.enabled_conn = nil
        end

        return
    end

    local v1 = u1061.Character

    if not v1 then
        return
    end

    local v2 = v1:FindFirstChild("WinStreakDisplay")

    if not v2 then
        v2 = v1:WaitForChild("WinStreakDisplay", 5)
    end

    if not v2 then
        return
    end

    v1 = v2:FindFirstChild("Main")

    if not v1 then
        return
    end

    local v3, v4 = v1:FindFirstChild("Icon"), v1:FindFirstChild("Value")

    if not v3 or not v4 then
        return
    end

    if u1070.winstreak.original_enabled == nil then
        u1070.winstreak.original_enabled = v2.Enabled
    end

    if not u1070.winstreak.original_text or u1070.winstreak.original_text == "" then
        u1070.winstreak.original_text = v4.Text
    end

    if not u1070.winstreak.original_icon or u1070.winstreak.original_icon == "" then
        u1070.winstreak.original_icon = v3.Image
    end

    local v5 = u1070.winstreak.streak or "1"
    v1 = u826.format("<b><stroke color='rgb(0, 0, 0)' thickness='2'>%s</stroke></b>", u814(v5))
    local v6 = u815(v5)
    v5 = if v6 and v6 >= 10 then true else false

    if u1070.winstreak.conn then
        u1070.winstreak.conn:Disconnect()
        u1070.winstreak.conn = nil
    end

    if u1070.winstreak.enabled_conn then
        u1070.winstreak.enabled_conn:Disconnect()
        u1070.winstreak.enabled_conn = nil
    end

    local v7 = false
    v3.Image = v5 and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
    v4.Text = v1
    v2.Enabled = true

    u1070.winstreak.conn = v4:GetPropertyChangedSignal("Text"):Connect(function()
        if v7 then
            return
        end

        u1070.winstreak.original_text = v4.Text
        v7 = true
        local v8 = u1070.winstreak.streak or "1"
        local v9 = u815(v8)
        v3.Image = (if v9 and v9 >= 10 then true else false) and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
        v4.Text = u826.format("<b><stroke color='rgb(0, 0, 0)' thickness='2'>%s</stroke></b>", u814(v8))
        v7 = false
    end)

    u1070.winstreak.enabled_conn = v2:GetPropertyChangedSignal("Enabled"):Connect(function()
        if v7 then
            return
        end

        u1070.winstreak.original_enabled = v2.Enabled
        v7 = true
        v2.Enabled = true
        v7 = false
    end)
end  

u1070.winstreak.update = __S[6]

__S[3] = function()
    u1070.winstreak.enabled = true
    local u1203

    if not u1070.winstreak.char_conn then
        local r4 = u1070.winstreak
        local r1 = u1061.CharacterAdded
        u1203 = r1.Connect

        u1203 = u1203(r1, function()
            u1070.winstreak.original_text = nil
            u1070.winstreak.original_icon = nil
            u1070.winstreak.original_enabled = nil
            task.wait(1.5)
            pcall(u1070.winstreak.update)
        end)

        r4.char_conn = u1203
    end

    u1203 = u1070.winstreak
    u1203 = u1203.update
    pcall(u1203)
end

u1070.winstreak.start = __S[3]

__S[3] = function()
    u1070.winstreak.enabled = false

    if u1070.winstreak.char_conn then
        u1070.winstreak.char_conn:Disconnect()
        u1070.winstreak.char_conn = nil
    end

    if u1070.winstreak.conn then
        u1070.winstreak.conn:Disconnect()
        u1070.winstreak.conn = nil
    end

    if u1070.winstreak.enabled_conn then
        u1070.winstreak.enabled_conn:Disconnect()
        u1070.winstreak.enabled_conn = nil
    end

    local r4 = u1061.Character

    if r4 then
        local r6 = r4:FindFirstChild("WinStreakDisplay")

        if r6 then
            local r5 = r6:FindFirstChild("Main")

            if r5 then
                local r4_2 = r5:FindFirstChild("Icon")
                local r1 = r5:FindFirstChild("Value")

                if r4_2 and r1 then
                    if u1070.winstreak.original_text and u1070.winstreak.original_text ~= "" then
                        r1.Text = u1070.winstreak.original_text
                    end

                    if u1070.winstreak.original_icon and u1070.winstreak.original_icon ~= "" then
                        r4_2.Image = u1070.winstreak.original_icon
                    end
                end
            end

            if u1070.winstreak.original_enabled ~= nil then
                r6.Enabled = u1070.winstreak.original_enabled
            end
        end
    end

    u1070.winstreak.original_text = nil
    u1070.winstreak.original_icon = nil
    u1070.winstreak.original_enabled = nil
end

u1070.winstreak.stop = __S[3]

__S[6] = function()
    if not u1070.custom_win.enabled then
        return
    end

    local v1 = u1061:FindFirstChild("PlayerGui")

    if not v1 then
        return
    end

    local v2 = v1:FindFirstChild("announcer")

    if not v2 then
        return
    end

    v1 = u1070.custom_win.kill_message

    if v1 ~= nil and v1 ~= "" then
        local v3 = v2:FindFirstChild("Killed")

        if v3 and (v3:IsA("TextLabel") or (v3:IsA("TextBox"))) then
            if v3.Text ~= v1 then
                v3.Text = v1
            end
        end
    end

    v1 = u1070.custom_win.win_message

    if v1 ~= nil and v1 ~= "" then
        local v4 = v2:FindFirstChild("Winner")

        if v4 and (v4:IsA("TextLabel") or (v4:IsA("TextBox"))) then
            if v4.Text ~= v1 then
                v4.Text = v1
            end
        end
    end
end  

u1070.custom_win.update = __S[6]

__S[3] = function()
    u1070.custom_win.stop()
    u1070.custom_win.enabled = true
    local r0 = u1061:WaitForChild("PlayerGui", 10)

    if not r0 then
        return
    end

    local r5 = r0:WaitForChild("announcer", 10)

    if not r5 then
        return
    end

    local function u1204(u1205, u1206)
        if not u1205 then
            return
        end

        table.insert(u1070.custom_win.connections, u1205.Changed:Connect(function(r0)
            if r0 ~= "Text" or not u1070.custom_win.enabled then
                return
            end

            local r2 = u1206()

            if r2 ~= nil and r2 ~= "" and u1205.Text ~= r2 then
                u1205.Text = r2
            end
        end))

        local r2 = u1206()

        if r2 ~= nil and r2 ~= "" and u1205.Text ~= r2 then
            u1205.Text = r2
        end
    end

    u1204(r5:WaitForChild("Killed", 10), function()
        return u1070.custom_win.kill_message
    end)

    u1204(r5:FindFirstChild("Winner"), function()
        return u1070.custom_win.win_message
    end)

    table.insert(u1070.custom_win.connections, r5.ChildAdded:Connect(function(r0)
        if r0.Name == "Winner" then
            u1204(r0, function()
                return u1070.custom_win.win_message
            end)
        end

        if r0.Name == "Killed" then
            u1204(r0, function()
                return u1070.custom_win.kill_message
            end)
        end
    end))
end

u1070.custom_win.start = __S[3]

__S[3] = function()
    u1070.custom_win.enabled = false

    for r1, u1207 in ipairs(u1070.custom_win.connections) do
        pcall(function()
            u1207:Disconnect()
        end)
    end

    table.clear(u1070.custom_win.connections)
end

u1070.custom_win.stop = __S[3]

local function u1208(r0)
    if type(r0) ~= "string" or r0 == "" then
        return nil
    end

    local r2 = u1058:FindFirstChild("Alive")

    if r2 then
        r2 = r2:FindFirstChild(r0)
    end

    local r3 = r2 or u1058:FindFirstChild(r0)

    if r3 and r3:IsA("Model") then
        local r2_2 = r3:FindFirstChild("HumanoidRootPart") or r3.PrimaryPart or r3:FindFirstChildWhichIsA("BasePart")

        if r2_2 then
            return r2_2.Position
        end
    end

    return nil
end

local function u1209()
    local r290 = u1070.ball.get_all()
    local r6 = 0

    for r1, r2 in ipairs(r290) do
        local r3 = u1070.ball.get_velocity(r2.part, r2.model)

        if r3 then
            local r4 = r3.Magnitude

            if r6 < r4 then
                r6 = r4
            end
        end
    end

    return r6
end

local function u1210(...)
    if not u1070.config.kill_pre_click then
        return
    end

     
    local all = u1070.sapphire and u1070.sapphire.PreclickAll
    if all and all.HandlesKilled() then return end

    local v1 = u1070.player.get_root()

    if not v1 then
        return
    end

    if not u1070.player.is_alive() then
        return
    end

    local v2 = u1070.config.kill_pre_click_speed or 1

    if v2 > 1 and u1209() < v2 then
        return
    end

    local v3 = u1070.config.kill_pre_click_range or 30
    local v4 = v1.Position
    local v5 = false

    for v6 = 1, u806("#", ...) do
        v2 = u806(v6, ...)
        v6 = u1208(if u809(v2) == "string" then v2 else if u809(v2) == "table" then v2.Name or v2.DisplayName or v2.Victim or v2.Player else nil)

        if v6 and (v4 - v6).Magnitude <= v3 then
            v5 = true
            break
        end
    end

    if not v5 then
        local v7 = u1061.Character

        for v8, v9 in u812(u1070.player.get_alive_chars()) do
            if v9 ~= v7 then
                v8 = v9:FindFirstChild("HumanoidRootPart") or v9.PrimaryPart

                if v8 and (v4 - v8.Position).Magnitude <= v3 then
                    v5 = true
                    break
                end
            end
        end
    end

    if v5 then
        if u1070.sapphire then u1070.sapphire.State.PreclickFired = true end
        u808(u1070.parry.execute)
    end
end  

u828.spawn(function()
    local r5 = u1057:WaitForChild("Remotes", 30)

    if not r5 then
        return
    end

    local u1211 = r5:WaitForChild("Killed", 30)

    if not u1211 then
        return
    end

    pcall(function()
        u1211.OnClientEvent:Connect(u1210)
    end)
end)

 
 
 
do
    local F = {Flags = {}, State = {StaffDetected = {}, AbilityUses = {}}, Connections = {}, Balls = setmetatable({}, {__mode = "k"})}
    u1070.sapphire = F
    local flags, sapphireBBState = F.Flags, F.State
    sapphireBBState.Connections = F.Connections
    local coroutineFunction = function(key) F.Disconnect(key) end
    local localPlayer, playersService, replicatedStorage, runService = u1061, u1054, u1057, u1055
    local features = {Detection = {}, Staff = {}, Phantom = {}, Quasar = {}, Ball = {}}
    local Workspace = game:GetService("Lighting")
    local smallest, newRoot, playerGui, CoreGui, PlayerGui
    local function refresh()
        smallest = workspace:FindFirstChild("Alive")
        newRoot = workspace:FindFirstChild("Runtime")
        playerGui = workspace:FindFirstChild("Balls")
        CoreGui = workspace:FindFirstChild("TrainingBalls")
        local gui = localPlayer:FindFirstChildOfClass("PlayerGui")
        local hotbar = gui and gui:FindFirstChild("Hotbar")
        local ability = hotbar and hotbar:FindFirstChild("Ability")
        PlayerGui = ability and ability:FindFirstChild("Duration")
        return ability, hotbar
    end
    refresh()
    local defaults = {
        InfinityDetection = false, FreezeDetection = false, DeathSlashDetection = false,
        DeathSlashMinigame = false, SingularityDetection = false, TimeHoleDetection = false,
        ForcefieldDetection = false, ParryOnDribble = false, DribbleDetection = false,
        FuryDetection = false, FurySpamHit = false, FuryParryAmount = 35,
        FuryParryDelay = 0.05, FuryParryMethod = "Remote",
        AntiCurveEnabled = true, BackwardsAntiCurveEnabled = true,
        AntiPhantomEnabled = false, AntiPhantomBlatant = false, AntiPhantomType = "Spam",
        AntiFlashCounterEnabled = false, AntiFlashCounterBlatant = false, AntiFlashCounterType = "Spam",
        AntiBlindness = false, AntiDisorientate = false, StaffDetection = false, StaffDetectionMode = "warn"
    }
    for key, value in pairs(defaults) do flags[key] = value end
    function F.Disconnect(key)
        local conn = F.Connections[key]
        if not conn then return end
        if type(conn) == "table" then
            for _, item in pairs(conn) do
                local itemType = type(item)
                if (itemType == "table" or itemType == "userdata") and type(item.Disconnect) == "function" then
                    pcall(item.Disconnect, item)
                elseif itemType == "thread" and type(task.cancel) == "function" then
                    pcall(task.cancel, item)
                end
            end
        else
            local connType = type(conn)
            if (connType == "table" or connType == "userdata") and type(conn.Disconnect) == "function" then
                pcall(conn.Disconnect, conn)
            end
        end
        F.Connections[key] = nil
    end
    local function connect(key, signal, callback)
        F.Disconnect(key)
        F.Connections[key] = signal:Connect(function(...)
            if not F.Destroyed then callback(...) end
        end)
        return F.Connections[key]
    end
    local function previous() return (u1070.cache.get_parry_ping or u1070.cache.get_ping)() end
    local function pingJitterMs() return u1070.cache.get_ping_jitter and u1070.cache.get_ping_jitter() or 0 end
    local function normalizeVector() return previous() / 1000 end
    local function compareFunction(ball)
        if not ball then return nil end
        local target = ball:GetAttribute("target")
        if target and target ~= "" then return target end
        local attachment = ball:FindFirstChild("TargetAttachment")
        local value = attachment and attachment.Value
        local model = value and value:FindFirstAncestorWhichIsA("Model")
        local visited = {}
        while model and not visited[model] do
            visited[model] = true
            local actual = model:FindFirstChild("ActualCharacter")
            if not actual or not actual.Value then break end
            model = actual.Value
        end
        local whitelist = ball:FindFirstChild("CollisionWhitelist")
        if not model and whitelist and whitelist.Value then model = whitelist.Value end
        return model and model.Name
    end
    F.Target = compareFunction
    local function executeFunction(ball)
        if not ball then return nil end
        return ball:IsA("BasePart") and ball or ball:IsA("Model") and (ball.PrimaryPart or ball:FindFirstChild("Body") or ball:FindFirstChild("Corpo"))
    end
    local function unexecuteFunction(ball)
        local part = executeFunction(ball)
        return part and part.Position or Vector3.zero
    end
    local function index4(ball)
        if not ball then return Vector3.zero end
        local zoomies = ball:FindFirstChild("zoomies")
        if zoomies then return zoomies.VectorVelocity end
        local velocity = ball:GetAttribute("Velocity")
        if typeof(velocity) == "Vector3" then return velocity end
        local part = executeFunction(ball)
        return part and u1070.ball.get_velocity(part, ball:IsA("Model") and ball or nil) or Vector3.zero
    end
    local function index5(ball)
        return ball and ((ball:IsA("BasePart") and ball:GetAttribute("realBall")) or
            (ball:IsA("Model") and executeFunction(ball) and (ball:FindFirstChild("CollisionWhitelist") or ball:FindFirstChild("TargetAttachment"))))
    end
    local function index6(ball)
         
         
        return ball and ball:IsA("Model") and executeFunction(ball) and not ball:FindFirstChild("zoomies")
    end
    local function index7(ball)
        local state = F.Balls[ball]
        if not state then
            state = {Target = compareFunction(ball), CurveVersion = 0, Connections = {}}
            F.Balls[ball] = state
        end
        return state
    end
    local function updateFunction(name)
        refresh()
        local char = localPlayer.Character
        local abilities = char and char:FindFirstChild("Abilities")
        local ability = abilities and abilities:FindFirstChild(name)
        return localPlayer:GetAttribute("CurrentlyEquippedAbility") == name and ability and ability.Enabled and PlayerGui and PlayerGui.Visible
    end
    local function abilityReady()
        local ability = refresh()
        local grad = ability and ability:FindFirstChildOfClass("UIGradient")
        return grad and grad.Offset.Y >= 0.49
    end
    local function fireAbility()
        local remotes = replicatedStorage:FindFirstChild("Remotes")
        local ability = remotes and remotes:FindFirstChild("AbilityButtonPress")
        if not ability then return false end
        local ok = pcall(function()
            if ability:IsA("BindableEvent") then ability:Fire()
            elseif ability:IsA("RemoteEvent") then ability:FireServer() end
        end)
        return ok
    end
    local function continuation(char)
        return char and sapphireBBState.InvisibilityCharacter == char and os.clock() < (sapphireBBState.InvisibilityUntil or 0)
    end
    function F.InvisDetection(char)
        refresh()
        if not smallest then return false end
        local found = false
        for _, other in smallest:GetChildren() do
            if other ~= char then
                if not continuation(other) then return false end
                found = true
            end
        end
        return found
    end
    local index9, index10, index11, index12, index13, index14, index15
    local index17

index9 = function(key)local y= localPlayer .Character;local currentLength=y and(y.PrimaryPart or(y:FindFirstChild("HumanoidRootPart")));y= smallest and  smallest .Parent and  smallest or(workspace:FindFirstChild("Alive"));local deltaX=type(key)=="string"and y and(y:FindFirstChild(key));key=deltaX and(deltaX.PrimaryPart or(deltaX:FindFirstChild("HumanoidRootPart")));y=currentLength and key and currentLength.Position-key.Position;return y and y.Magnitude>0.001 and y or nil;end
index10 = function(key,callback)local currentLength=callback.Zoomies;local velocity= compareFunction (key);if not  flags .BackwardsAntiCurveEnabled or not currentLength or key.Parent== CoreGui or velocity== localPlayer .Name then return;end;if key:GetAttribute("DribbleActive")==true then callback.CurveReference=nil;return;end;key=currentLength.VectorVelocity;velocity=key.Magnitude;if velocity~=velocity or velocity==math.huge or velocity<0.001 then return;end;callback.CurveReference=key;end
index11 = function(key,callback,relativeVelocity,scale)if not  flags .BackwardsAntiCurveEnabled or not key or key.Parent== CoreGui or( index6 (key))then return false;end;if(relativeVelocity or( compareFunction (key)))~= localPlayer .Name then return false;end;local toTarget,length= index7 (key),callback.Magnitude;if length~=length or length==math.huge or length<0.001 then return false;end;local current,currentIndex,currentNode=toTarget.CurveSource,toTarget.CurveTargetDirection,key:GetAttribute("from");if scale and(not current or not currentIndex)then if type(currentNode)=="string"and currentNode~=""and currentNode~= localPlayer .Name then current,currentIndex=currentNode,( index9 (currentNode));end;end;if not current or currentNode~=current or not currentIndex then return false;end;key=currentIndex.Magnitude;if key<0.001 then return false;end;relativeVelocity=toTarget.CurveReference;local x,progress=relativeVelocity and relativeVelocity.Magnitude or 0,currentIndex:Dot(callback)/(key*length);if x<0.001 then return scale and length>=35 and progress<-0.45;end;scale,currentNode=relativeVelocity:Dot(callback)/(x*length),false;if scale>0.2 and progress>=-0.45 and progress<0 then local normal= index9 (current);local deltaY=normal and normal.Magnitude or 0;if deltaY>0.001 then local distance=normal:Dot(callback)/(deltaY*length);currentNode=scale>0.95 and progress<-0.2 and distance<-0.2;if distance<progress then progress,key,currentIndex=distance,deltaY,normal;end;end;end;local normal=currentNode or scale>0.2 and progress<-0.45;if not normal and(math.abs(currentIndex.Y)>key*0.1 or scale>0.2 and progress<-0.2)then local i,deltaY,distance=Vector3.new(relativeVelocity.X,0,relativeVelocity.Z),Vector3.new(callback.X,0,callback.Z),Vector3.new(currentIndex.X,0,currentIndex.Z);local y,currentLength,currentIndex=i.Magnitude,deltaY.Magnitude,distance.Magnitude;if y>x*0.35 and currentLength>length*0.35 and currentIndex>0.001 then normal=i:Dot(deltaY)/(y*currentLength)>0.2 and distance:Dot(deltaY)/(currentIndex*currentLength)<-0.45;if normal and currentIndex<=1 then currentNode= index9 (current);local deltaX=currentNode and(Vector3.new(currentNode.X,0,currentNode.Z));local i=deltaX and deltaX.Magnitude or 0;normal=i>0.001 and deltaX:Dot(deltaY)<-0.45*i*currentLength;end;end;end;if not normal and progress>0.2 and scale<0 then toTarget.CurveReference=nil;end;
    local ahora=os.clock()
    local score=math.clamp((toTarget.BackwardsScore or 0)*0.62+(normal and 1 or 0)*0.38,0,1)
    toTarget.BackwardsScore=score
    if score>=0.55 then toTarget.BackwardsAt=ahora;return true;end;if toTarget.BackwardsAt and ahora-toTarget.BackwardsAt<0.045 then return true;end;return false ;end

index12 = function(line)
	local serialized = line.Connections
	local conn = serialized and serialized.CurveVelocity

	if conn then
		conn:Disconnect()
		serialized.CurveVelocity = nil
	end

	line.CurveReference = nil
	line.CurveSource = nil
	line.CurveTargetDirection = nil
    line.CurveObservation = nil
    line.CurveWarping = nil
    line.CurveTime = nil
	line.CurveReady = nil
	line.CurveVersion = (line.CurveVersion or 0) + 1
end

index13 = function(line)
	line.CurveTime = os.clock()
	line.CurveWarping = nil
    line.CurveObservation = nil
end

index14 = function(line)
	line.CurveTime = nil
	line.CurveWarping = nil
    line.CurveObservation = nil
end

local function finiteCurveComponent(value)
    return value == value and math.abs(value) < math.huge
end
index15 = function(line, object, descendant, radius, zCoordinate, alpha, color, initialCapacity, targetPosition)
	if not flags.AntiCurveEnabled or not line or line.Parent == CoreGui or index6(line) then
		return false
	end

	if (initialCapacity or compareFunction(line)) ~= localPlayer.Name then
		return false
	end

	radius = radius or index4(line)
    if typeof(radius) ~= "Vector3" then return false end
	alpha = alpha or radius.Magnitude
	if alpha ~= alpha or alpha == math.huge or alpha < 0.001 then
		return false
	end

	if not object then
		object = localPlayer.Character

		if object then
			object = object:FindFirstChild("HumanoidRootPart") or object.PrimaryPart
		end
	end

	if not object then
		return false
	end

	if not color then
		color = object.Position - (descendant or unexecuteFunction(line))
	end

	zCoordinate = zCoordinate or color.Magnitude
	if zCoordinate ~= zCoordinate or zCoordinate == math.huge or zCoordinate < 0.001 then
		return false
	end
    if not object.Position or typeof(object.Position) ~= "Vector3" or typeof(color) ~= "Vector3"
        or descendant and typeof(descendant) ~= "Vector3" then return false end
    local px, py, pz = object.Position.X, object.Position.Y, object.Position.Z
    if not finiteCurveComponent(radius.X) or not finiteCurveComponent(radius.Y) or not finiteCurveComponent(radius.Z)
        or not finiteCurveComponent(color.X) or not finiteCurveComponent(color.Y) or not finiteCurveComponent(color.Z)
        or not finiteCurveComponent(px) or not finiteCurveComponent(py) or not finiteCurveComponent(pz) then return false end
    if descendant and (not finiteCurveComponent(descendant.X) or not finiteCurveComponent(descendant.Y)
        or not finiteCurveComponent(descendant.Z)) then return false end

	local radians = index7(line)
	local osClock = os.clock()
	local pingTime = math.max(targetPosition or normalizeVector() or 0, 0)
	local ballPosition = descendant or (object.Position - color)
	local aheadVector = object.Position - (ballPosition + radius * pingTime)
	local aheadDistance = aheadVector.Magnitude

	if aheadDistance < 0.001 then
		radians.CurveWarping = nil
		radians.CurveTime = nil
		return false
	end

	local closing = aheadVector:Dot(radius) / (aheadDistance * alpha)
	local eta = aheadDistance / alpha
	local reach = 10 + alpha * pingTime

	if aheadDistance < reach then
		radians.CurveWarping = nil
		radians.CurveTime = nil
		return false
	end

    local observedVelocity = radius
    local observedSpeed = observedVelocity.Magnitude
    local sender = line:GetAttribute("from")
    local observation = radians.CurveObservation
    local target = initialCapacity or compareFunction(line)
    if observedSpeed == observedSpeed and observedSpeed < math.huge and observedSpeed >= 0.001 then
        local previous = observation
        local dt = previous and osClock - previous.At or nil
        local sameCycle = previous and previous.Target == target and previous.Sender == sender
            and previous.Parent == line.Parent and previous.Version == (radians.CurveVersion or 0)
        if not sameCycle or not dt or dt < 0 or dt > 0.12 then
            radians.CurveWarping, radians.CurveTime = nil, nil
            observation = {At = osClock, Position = ballPosition, Velocity = observedVelocity,
                Target = target, Sender = sender, Parent = line.Parent, Version = radians.CurveVersion or 0}
            radians.CurveObservation = observation
        elseif dt >= 0.008 then
            local oldSpeed = previous.Velocity.Magnitude
            local directionDot = oldSpeed > 0.001 and observedVelocity:Dot(previous.Velocity) / (observedSpeed * oldSpeed) or 1
            local predicted = previous.Position + previous.Velocity * dt
            local bendError = (ballPosition - predicted).Magnitude
            local bendFloor = math.max(0.35, math.min(observedSpeed, oldSpeed) * dt * 0.06)
            local turned = directionDot < 0.97 and bendError > bendFloor
            observation = {At = osClock, Position = ballPosition, Velocity = observedVelocity,
                Target = target, Sender = sender, Parent = line.Parent, Version = radians.CurveVersion or 0}
            radians.CurveObservation = observation
            if closing < 0.45 and turned then radians.CurveWarping = osClock end
        end
    else
        radians.CurveObservation = nil
    end

	local warping = radians.CurveWarping

	if warping then
		local window = math.min(math.max(eta, 0.12), 0.4 + pingTime * 0.5)

		if osClock - warping < window then
			return true
		end

		radians.CurveWarping = nil
		radians.CurveTime = nil
	end

	return false
end

features.Detection.GetDribbleBall = function(line)
	local cell = not flags.ParryOnDribble or not line or not index5(line) or line:GetAttribute("DribbleActive") ~= true

	if not cell then
		local targetPlayerName = localPlayer.Name
		cell = compareFunction(line) == targetPlayerName
	end

	if cell then
		return
	end
	local radians = playerGui
	local angleRadians

	if playerGui then
		angleRadians = radians
	else
		angleRadians = workspace:FindFirstChild("Balls")
	end

	if not angleRadians then
		return
	end

	for _, propertyName in angleRadians:GetChildren() do
		if propertyName ~= line and propertyName.Name == line.Name and not index5(propertyName) and propertyName:GetAttribute("highlighted") == true then
			return line
		end
	end
end

features.Detection.GetSelfDribbleBall = function(player14, line)
	if not flags.DribbleDetection then
		sapphireBBState.SelfDribbleBall = nil
		sapphireBBState.SelfDribbleAway = nil
		return nil, false
	end

	local cell = not player14.Parent or not index5(player14) or player14:GetAttribute("DribbleActive") ~= true
	local active

	if cell then
		active = cell
	else
		local targetPlayerName = localPlayer.Name
		active = compareFunction(player14) ~= targetPlayerName
	end

	if active then
		if sapphireBBState.SelfDribbleBall == player14 then
			sapphireBBState.SelfDribbleBall = nil
			sapphireBBState.SelfDribbleAway = nil
		end

		return nil, false
	end

	if sapphireBBState.SelfDribbleBall ~= player14 then
		sapphireBBState.SelfDribbleBall = player14
		sapphireBBState.SelfDribbleAway = false
	end

	local isArray = (line.Position - unexecuteFunction(player14)):Dot(index4(player14)) > 0

	if not isArray then
		sapphireBBState.SelfDribbleAway = true
	end

	return player14, sapphireBBState.SelfDribbleAway and isArray
end

features.Detection.TrackAbilityUse = function(line, object, descendant, quantity, radius)
	local index51 = workspace:GetServerTimeNow()
	local lines = sapphireBBState.AbilityUses[line]

	if not lines or lines.Ability ~= descendant or lines.Character ~= object then
		lines = { Ability = descendant, Character = object, Recoveries = {} }
		sapphireBBState.AbilityUses[line] = lines
	end

	for k = #lines.Recoveries, 1, -1 do
		if lines.Recoveries[k] <= index51 then
			table.remove(lines.Recoveries, k)
		end
	end

	lines.Maximum = quantity

	if #lines.Recoveries < quantity then
		lines.Recoveries[#lines.Recoveries + 1] = index51 + radius
	end
end

index17 = function(line, object)
	local cell = flags.FreezeDetection and line:GetAttribute("Frozen") == true

	if cell then
		cell = (object or compareFunction(line)) == localPlayer.Name
	end

	local active

	if cell then
		active = not (false)
	else
		active = cell
	end

	return active
end

features.Detection.BlocksParry = function(line, object, descendant)
	local explosion = descendant or object and object:FindFirstChild("HumanoidRootPart")
	if not explosion then
		return true
	end

	if line and index17(line) then
		return true
	end
	local player25 = newRoot and newRoot:FindFirstChild("Tornado")

	if player25 then
		local callbackFunction = player25:GetAttribute("TornadoTime")

		if sapphireBBState.Tornado ~= player25 or sapphireBBState.TornadoDuration ~= callbackFunction or not sapphireBBState.TornadoAt then
			sapphireBBState.Tornado = player25
			sapphireBBState.TornadoDuration = callbackFunction
			sapphireBBState.TornadoAt = tick()
		end

		local index56 = sapphireBBState.TornadoAt
		if tick() - index56 < (callbackFunction or 1) + 0.314159 then
			return true
		end
	elseif sapphireBBState.Tornado then
		sapphireBBState.Tornado = nil
		sapphireBBState.TornadoDuration = nil
		sapphireBBState.TornadoAt = nil
	end

	if flags.SingularityDetection and explosion:FindFirstChild("SingularityCape") then
		return true
	end

	if flags.FuryDetection and (sapphireBBState.FuryCatch or sapphireBBState.FuryActive) then
		return true
	end

	if flags.DeathSlashDetection and sapphireBBState.DeathSlash then
		return true
	end
	local rootPart = object:FindFirstChild("Abilities")
	local result76 = PlayerGui and PlayerGui.Visible
	local effectInstance = rootPart and rootPart:FindFirstChild("Time Hole")
	if flags.TimeHoleDetection and (sapphireBBState.TimeHole or result76 and effectInstance and effectInstance.Enabled) then
		return true
	end

	if flags.InfinityDetection and (sapphireBBState.InfinityActive or updateFunction("Infinity")) then
		return true
	end

	if flags.ForcefieldDetection and updateFunction("Forcefield") and (explosion:FindFirstChild("MaxShield") or explosion:FindFirstChild("Shield")) then
		return true
	end
	return false, rootPart
end

features.Staff = {
	Group = 12836673,
	Roles = {
	Mod = true,
	Support = true,
	Admin = true,
	Developer = true,
	["Lead Developer"] = true,
	Management = true,
	Executive = true,
	["Co-Owner"] = true,
	Contributor = true,
	["Trial QA"] = true,
	Holder = true,
},
}



features.Staff.Check = function(line)
	if F.Destroyed or not flags.StaffDetection or line == localPlayer then
		return
	end

	if sapphireBBState.StaffDetected[line] or line.Parent ~= playersService then
		return
	end
	local decoded, loadError = pcall(line.GetRoleInGroup, line, features.Staff.Group)

	if not F.Destroyed and flags.StaffDetection and decoded and features.Staff.Roles[loadError] then
		sapphireBBState.StaffDetected[line] = true
		local query = "Staff Detected: " .. line.Name .. " | " .. loadError

		if flags.StaffDetectionMode == "kick" then
			localPlayer:Kick(query)
		else
			u864.SendNotification({title = "Staff Detection", text = query, duration = 15})
		end
	end
end

features.Staff.Set = function(line)
	coroutineFunction("Staff")
	if not line then
		coroutineFunction("Staff")
		table.clear(sapphireBBState.StaffDetected)
		return
	end

	for _, particle in playersService:GetPlayers() do
		features.Staff.Check(particle)
	end

	sapphireBBState.Connections.Staff = playersService.PlayerAdded:Connect(function(player9)
			task.wait(1)

			if flags.StaffDetection then
				features.Staff.Check(player9)
			end
		end)
end


features.Phantom = {}

features.Phantom.Reset = function()
	sapphireBBState.PhantomTarget = nil
	sapphireBBState.PhantomAbility = nil
	sapphireBBState.PhantomData = nil
end

features.Phantom.Trigger = function(line, options, object)
	local gameProcessed, low, priority

	if line == "Phantom" then
		gameProcessed = flags.AntiPhantomEnabled
		low = flags.AntiPhantomBlatant
		priority = flags.AntiPhantomType
	else
		gameProcessed = flags.AntiFlashCounterEnabled
		low = flags.AntiFlashCounterBlatant
		priority = flags.AntiFlashCounterType
	end

	if not gameProcessed then
		return
	end

	if object ~= localPlayer.Character or typeof(options) ~= "Instance" or not options:IsA("Model") then
		return
	end
	sapphireBBState.PhantomTarget = options
	sapphireBBState.PhantomAbility = nil

	sapphireBBState.PhantomData = {
		Name = line,
		Blatant = low,
		Type = priority,
		Ball = line == "Phantom" and features.Ball.GetMainBall() or nil,
		Expires = os.clock() + 1.25,
	}
end

features.Phantom.Released = function(expectedType)
	local ENT = sapphireBBState.PhantomData
	local innerPlayer = sapphireBBState.PhantomTarget
	if not ENT or ENT.Name ~= "Phantom" or not innerPlayer or ENT.Ball and ENT.Ball ~= expectedType then
		return false
	end
	local targetPlayerName = innerPlayer.Name

	if compareFunction(expectedType) ~= targetPlayerName then
		ENT.Position = nil
		ENT.Released = false
		return false
	end

	ENT.Ball = expectedType
	local radians = unexecuteFunction(expectedType)

	if ENT.Position and radians ~= ENT.Position then
		ENT.Released = true
	end

	ENT.Position = radians
	return ENT.Released == true
end

features.Phantom.Update = function()
	local ENT = sapphireBBState.PhantomData
	local innerPlayer = sapphireBBState.PhantomTarget
	local model = localPlayer.Character
	model = model and model:FindFirstChild("HumanoidRootPart")
	local explosion = innerPlayer and innerPlayer:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = innerPlayer and innerPlayer:FindFirstChildOfClass("Humanoid")
	local cell = not ENT

	if not cell then
		local neighborX = ENT.Expires
		cell = os.clock() >= neighborX
	end

	if cell or not model or not explosion or not targetHumanoid or targetHumanoid.Health <= 0 then
		features.Phantom.Reset()
		return
	end
	local difference = model.Position - explosion.Position
	local exponent = difference.Magnitude

	if ENT.Blatant and exponent < 32 then
		model.CFrame = model.CFrame + (exponent > 0.1 and difference.Unit or -explosion.CFrame.LookVector) * (32 - exponent)
		features.Phantom.Reset()
		return
	end

	return innerPlayer, exponent, ENT
end


features.Quasar.Reset = function()
	sapphireBBState.QuasarUntil = nil
end

features.Quasar.ClearBlindness = function(line)
	local blindness = Workspace:FindFirstChild("Blindness")
	if blindness and not blindness:IsA("Atmosphere") then pcall(function() blindness.Enabled = false end) end

	if not line then
		for _, particle in Workspace:GetChildren() do
			if particle:IsA("Atmosphere") and particle.Name == "Blindness" then
				features.Quasar.ClearBlindness(particle)
			end
		end

		return
	end

	local projectile = sapphireBBState.QuasarAtmosphere
	line.Density = projectile and projectile.Density or 0
	line.Offset = projectile and projectile.Offset or 0
	line.Haze = projectile and projectile.Haze or 0
	line.Glare = projectile and projectile.Glare or 0

	if projectile then
		line.Color = projectile.Color
		line.Decay = projectile.Decay
	end
end

features.Quasar.SetBlindness = function(line)
	local atmosphere = line and Workspace:FindFirstChildWhichIsA("Atmosphere")
    sapphireBBState.QuasarAtmosphere = atmosphere and {
        Density = atmosphere.Density, Offset = atmosphere.Offset, Haze = atmosphere.Haze,
        Glare = atmosphere.Glare, Color = atmosphere.Color, Decay = atmosphere.Decay
    } or nil
end

features.Quasar.SetDisorientate = function(line)
	coroutineFunction("Quasar Camera")
	sapphireBBState.QuasarCamera = nil
	if not line then
		return
	end

	sapphireBBState.Connections["Quasar Camera"] = runService.PreRender:Connect(function()
			local bodyGyro = workspace.CurrentCamera

			if bodyGyro then
				sapphireBBState.QuasarCamera = bodyGyro.CFrame
			end
		end)
end



    F.Detection, F.Staff, F.Phantom, F.Quasar = features.Detection, features.Staff, features.Phantom, features.Quasar
    function F.Set(key, value)
         
        if key == "AntiCurveEnabled" or key == "BackwardsAntiCurveEnabled" then
            flags[key] = true
            return
        end
        if key == "FuryParryMethod" then value = u864.normalize_parry_method(value) end
        flags[key] = value
        if key == "StaffDetection" then features.Staff.Set(value)
        elseif key == "AntiBlindness" then features.Quasar.SetBlindness(value)
        elseif key == "AntiDisorientate" then features.Quasar.SetDisorientate(value)
        elseif (key == "AntiPhantomEnabled" and not value and sapphireBBState.PhantomData and sapphireBBState.PhantomData.Name == "Phantom") or
               (key == "AntiFlashCounterEnabled" and not value and sapphireBBState.PhantomData and sapphireBBState.PhantomData.Name == "Flash Counter") then
            features.Phantom.Reset()
        elseif key == "DribbleDetection" and not value then
            sapphireBBState.SelfDribbleBall = nil; sapphireBBState.SelfDribbleAway = nil
        end
    end
    function F.MainBall()
        local first
        for _, item in ipairs(u1070.ball.get_all()) do
            local ball = item.model or item.part
            first = first or ball
            if compareFunction(ball) == localPlayer.Name then return ball end
        end
        return first
    end
    features.Ball.GetMainBall = F.MainBall
    function F.Fire(method)
        if F.Destroyed then return false end
        method = u864.normalize_parry_method(method)
        local char = localPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return false end
        local ok, success = pcall(function()
            if method == "Remote" then
                if u1070.parry.fire_remote() then return true end
                u1075()
            else u1075() end
            return true
        end)
        if ok and success and u1070.oxy_manual then u1070.oxy_manual.RecordSend() end
        return ok and success
    end
    local function validChar()
        refresh()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return char and hum and hum.Health > 0 and char.Parent == smallest and char or nil
    end
    local function onInfinityEnd()
        if sapphireBBState.InfinityParried or not flags.InfinityDetection then return end
        local ball, char = F.MainBall(), validChar()
        local root = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
        if not ball or not root or compareFunction(ball) ~= localPlayer.Name or (unexecuteFunction(ball) - root.Position).Magnitude > 10 then return end
        if not u1070.config.auto_parry and not u1070.triggerbot.enabled then return end
        sapphireBBState.InfinityParried = F.Fire(u1070.config.parry_mode)
        if sapphireBBState.InfinityParried then
            local state = index7(ball)
            state.ParryResetAt = os.clock() + 0.6
            u1070.state.parried = true
            task.delay(0.6, function() if not F.Destroyed then u1070.state.parried = false end end)
        end
    end
    local function doDeathSlashMinigame()
        local frame
        while not F.Destroyed and flags.DeathSlashDetection and flags.DeathSlashMinigame and sapphireBBState.DeathSlash do
            local gui = localPlayer:FindFirstChildOfClass("PlayerGui")
            local timer = gui and gui:FindFirstChild("DeathSlashTimer")
            frame = timer and timer:FindFirstChild("Frame")
            if frame and frame.Visible then break end
            runService.PreRender:Wait()
        end
        if not frame or not frame.Visible then return end
        local image, circle, inner = frame:FindFirstChild("ImageLabel"), frame:FindFirstChild("Circle"), frame:FindFirstChild("Inner")
        local threshold = circle and inner and (circle.Size.X.Scale + inner.Size.X.Scale) / 2
        while not F.Destroyed and flags.DeathSlashDetection and flags.DeathSlashMinigame and sapphireBBState.DeathSlash and frame.Parent and frame.Visible and image and threshold do
            if image.Size.X.Scale <= threshold then fireAbility(); return end
            runService.PreRender:Wait()
        end
    end
    function F.CheckTornado()
        refresh()
        local tornado = newRoot and newRoot:FindFirstChild("Tornado")
        if tornado then
            local duration = tornado:GetAttribute("TornadoTime")
            if sapphireBBState.Tornado ~= tornado or sapphireBBState.TornadoDuration ~= duration or not sapphireBBState.TornadoAt then
                sapphireBBState.Tornado, sapphireBBState.TornadoDuration, sapphireBBState.TornadoAt = tornado, duration, tick()
            end
            return tick() - sapphireBBState.TornadoAt < (tonumber(duration) or 1) + 0.314159
        end
        sapphireBBState.Tornado, sapphireBBState.TornadoDuration, sapphireBBState.TornadoAt = nil, nil, nil
        return false
    end
    function F.BlocksParry(ball, char, root)
        refresh()
        char = char or localPlayer.Character
        root = root or char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
        if not char or not root then return true end
        if continuation(char) then return true end
         
        return features.Detection.BlocksParry(ball, char, root)
    end
    function F.GetTargets()
        local found = {}
        local root = u1070.player.get_root()
        for _, item in ipairs(u1070.ball.get_all()) do
            local ball = item.model or item.part
            local target = compareFunction(ball)
            local selfBall, returned = nil, false
            if root then selfBall, returned = features.Detection.GetSelfDribbleBall(ball, root) end
            local otherDribble = features.Detection.GetDribbleBall(ball) == ball
            if target == localPlayer.Name or otherDribble or (selfBall and returned) then
                 
                if not (selfBall and not returned) then table.insert(found, item) end
            end
        end
        return found
    end
    function F.IsCurved(part, model, position, velocity, speed, distance)
        local ball = model or part
        local root = u1070.player.get_root()
        if not root then return false, false end
        velocity = velocity or index4(ball)
        speed = speed or velocity.Magnitude
        local toTarget = (position or root.Position) - unexecuteFunction(ball)
        distance = distance or toTarget.Magnitude
        local target = compareFunction(ball)
        if features.Detection.GetDribbleBall(ball) == ball then return false, false end
        local _, returned = features.Detection.GetSelfDribbleBall(ball, root)
        if returned then return false, false end
        local anti = index15(ball, root, unexecuteFunction(ball), velocity, distance, speed, toTarget, target, normalizeVector())
        local backwards = index11(ball, velocity, target, true)
        return anti, backwards
    end
    local function disconnectBall(ball)
        if F.OnAutoBallRemoved then F.OnAutoBallRemoved(ball) end
        local state = F.Balls[ball]
        if state then
            for _, conn in pairs(state.Connections) do conn:Disconnect() end
            F.Balls[ball] = nil
        end
        if sapphireBBState.SelfDribbleBall == ball then
            sapphireBBState.SelfDribbleBall, sapphireBBState.SelfDribbleAway = nil, nil
        end
    end
    local function trackBall(ball)
        if not ball:IsA("BasePart") and not ball:IsA("Model") then return end
        if F.Balls[ball] and F.Balls[ball].Tracked then return end
        local state = index7(ball)
        state.Tracked = true
        state.LoopTarget = state.Target
        state.Parried, state.ParryResetAt = false, 0
        state.Zoomies = ball:FindFirstChild("zoomies")
        state.AutoFrom = ball:GetAttribute("from")
        state.AutoFromVersion = state.AutoFrom == localPlayer.Name and (state.AutoCycleVersion or 0) or nil
        local function captureVelocity()
            index10(ball, state)
            if compareFunction(ball) == localPlayer.Name then
                local ready = state.CurveReady
                state.CurveReady = true
                if not ready and F.QueueAuto and u1070.config.auto_parry then F.QueueAuto() end
            end
        end
        local function attachVelocity(zoomies)
            if state.Connections.Velocity then state.Connections.Velocity:Disconnect(); state.Connections.Velocity = nil end
            state.Zoomies = zoomies
            if zoomies then
                state.Connections.Velocity = zoomies:GetPropertyChangedSignal("VectorVelocity"):Connect(captureVelocity)
                captureVelocity()
            end
        end
        local function targetChanged()
            local target, old = compareFunction(ball), state.Target
            if target == old then return end
            state.Target, state.ParryResetAt = target, 0
            state.Parried = false
            state.CurveVersion += 1
            u1070.state.parried = false
            if target == localPlayer.Name then
                index13(state)
                if ball:GetAttribute("DribbleActive") == true then state.CurveReference = nil end
                state.CurveSource = type(old) == "string" and old ~= "" and old ~= localPlayer.Name and old or nil
                state.CurveTargetDirection = index9(state.CurveSource)
                state.CurveReady = nil
                local velocity, reference = index4(ball), state.CurveReference
                local direction = state.CurveTargetDirection
                if not reference or reference.Magnitude < 0.001 or (velocity.Magnitude >= 0.001 and (reference:Dot(velocity) <= 0 or direction and direction:Dot(velocity) >= 0)) then
                    state.CurveReady = true
                end
            else
                index14(state)
                state.CurveReference, state.CurveSource, state.CurveTargetDirection, state.CurveReady = nil, nil, nil, nil
                index10(ball, state)
            end
            if F.OnAutoTargetChanged then F.OnAutoTargetChanged(ball, state, target, old) end
            if F.OnTriggerTargetChanged then F.OnTriggerTargetChanged(ball, state, target) end
        end
        state.Connections.Target = ball:GetAttributeChangedSignal("target"):Connect(targetChanged)
        state.Connections.TriggerFrom = ball:GetAttributeChangedSignal("from"):Connect(function()
            if F.OnAutoFromChanged then F.OnAutoFromChanged(ball, state) end
            if F.OnTriggerBallAvailable and u1070.triggerbot.ignore_spawn then F.OnTriggerBallAvailable(ball) end
        end)
        state.Connections.TriggerEligibility = ball:GetAttributeChangedSignal("realBall"):Connect(function()
            if F.OnTriggerBallAvailable then F.OnTriggerBallAvailable(ball) end
        end)
        local attachment = ball:FindFirstChild("TargetAttachment") or ball:FindFirstChild("CollisionWhitelist")
        if attachment then state.Connections.TargetValue = attachment.Changed:Connect(targetChanged) end
        state.Connections.ChildAdded = ball.ChildAdded:Connect(function(child)
            if child.Name == "zoomies" then attachVelocity(child) end
            if child.Name == "ComboCounter" then F.StartFuryCounter(child) end
            if F.OnTriggerBallAvailable then F.OnTriggerBallAvailable(ball) end
        end)
        state.Connections.ChildRemoved = ball.ChildRemoved:Connect(function(child)
            if child == state.Zoomies then attachVelocity(nil); state.CurveReady = true end
        end)
        attachVelocity(state.Zoomies)
        local counter = ball:FindFirstChild("ComboCounter")
        if counter then F.StartFuryCounter(counter) end
        if F.QueueAuto and u1070.config.auto_parry then F.QueueAuto() end
        if F.OnTriggerBallAvailable then F.OnTriggerBallAvailable(ball) end
    end
    F.FuryCounters = setmetatable({}, {__mode = "k"})
    function F.StartFuryCounter(counter)
        if F.FuryCounters[counter] or not flags.FuryDetection or not sapphireBBState.FuryCatch then return end
        F.FuryCounters[counter] = true
        task.spawn(function()
            local label = counter:FindFirstChildOfClass("TextLabel")
            if not label then F.FuryCounters[counter] = nil; return end
            sapphireBBState.FuryActive = true
            local count, pending, method = tonumber(label.Text) or 0, {}, flags.FuryParryMethod
            local lastAcknowledged = count
            while not F.Destroyed and flags.FuryDetection and sapphireBBState.FuryCatch and counter:IsDescendantOf(workspace) do
                local began = os.clock()
                local selected, acknowledged = flags.FuryParryMethod, tonumber(label.Text)
                if acknowledged then
                    if selected ~= method then
                        table.clear(pending); count, lastAcknowledged, method = acknowledged, acknowledged, selected
                    end
                    if selected == "Remote" then count = math.max(count, acknowledged)
                    else
                        for _ = 1, math.min(math.max(acknowledged - lastAcknowledged, 0), #pending) do table.remove(pending, 1) end
                        while pending[1] and began >= pending[1] do table.remove(pending, 1) end
                        lastAcknowledged = math.max(lastAcknowledged, acknowledged)
                        count = lastAcknowledged + #pending
                    end
                    if flags.FurySpamHit and count < flags.FuryParryAmount and F.Fire(selected) then
                        count += 1
                        if selected ~= "Remote" then pending[#pending + 1] = os.clock() + math.max(0.15, normalizeVector() + 0.001) end
                    end
                end
                local delay = flags.FuryParryDelay or 0.05
                task.wait(selected == "Remote" and delay or math.max(delay - (os.clock() - began), 0))
            end
            sapphireBBState.FuryActive, sapphireBBState.FuryCatch = false, false
            F.FuryCounters[counter] = nil
        end)
    end
    local function furyCatch()
        sapphireBBState.FuryCatch, sapphireBBState.FuryActive = true, false
        refresh()
        if playerGui then
            for _, ball in playerGui:GetChildren() do
                local counter = ball:FindFirstChild("ComboCounter")
                if counter then F.StartFuryCounter(counter) end
            end
        end
    end
    local function detectFuryAbility()
        local char = validChar()
        local abilities = char and char:FindFirstChild("Abilities")
        local ability = abilities and abilities:FindFirstChild("Slashes of Fury")
        local gui = localPlayer:FindFirstChildOfClass("PlayerGui")
        local hotbar = gui and gui:FindFirstChild("Hotbar")
        local button = hotbar and hotbar:FindFirstChild("Ability")
        local red = button and button:FindFirstChild("Red")
        refresh()
        if flags.FuryDetection and ability and ability.Enabled and red and not red.Visible and playerGui and #playerGui:GetChildren() > 0 then furyCatch() end
    end
    local function watchFolder(folder)
        if F.WatchedFolders[folder] then return end
        F.WatchedFolders[folder] = true
        for _, ball in folder:GetChildren() do trackBall(ball) end
        connect(folder, folder.ChildAdded, trackBall)
        connect("remove:" .. folder.Name, folder.ChildRemoved, disconnectBall)
    end
    F.WatchedFolders = setmetatable({}, {__mode = "k"})
    local function resetCharacter()
        sapphireBBState.InfinityActive, sapphireBBState.InfinityParried = false, false
        sapphireBBState.TimeHole, sapphireBBState.FuryCatch, sapphireBBState.FuryActive, sapphireBBState.DeathSlash = false, false, false, false
        sapphireBBState.Tornado, sapphireBBState.TornadoAt = nil, nil
        sapphireBBState.InvisibilityCharacter, sapphireBBState.InvisibilityUntil = nil, nil
        sapphireBBState.SelfDribbleBall, sapphireBBState.SelfDribbleAway = nil, nil
        features.Phantom.Reset(); features.Quasar.Reset()
        u1070.state.parried = false
        for _, state in pairs(F.Balls) do index12(state); index14(state) end
        if F.AutoAnimation then F.AutoAnimation.Reset(true); F.AutoAnimation.WatchCharacter() end
        if F.ResetAutoState then F.ResetAutoState() end
        if F.ResetTriggerTokens then F.ResetTriggerTokens() end
    end
    local function bindEvent(instance)
        local name = instance.Name
        if F.EventBound[instance] then return end
        local callbacks = F.RemoteCallbacks
        local callback = callbacks[name]
        if not callback then return end
        local signal
        if instance:IsA("RemoteEvent") or instance:IsA("UnreliableRemoteEvent") then signal = instance.OnClientEvent
        elseif instance:IsA("BindableEvent") then signal = instance.Event end
        if signal then
            F.EventBound[instance] = true
            connect(instance, signal, callback)
        end
    end
    F.EventBound = setmetatable({}, {__mode = "k"})
    F.RemoteCallbacks = {
        InfinityBall = function(_, active)
            local old = sapphireBBState.InfinityActive
            if active then
                if updateFunction("Infinity") then sapphireBBState.InfinityActive, sapphireBBState.InfinityParried = true, false end
            elseif old then sapphireBBState.InfinityActive = false; task.defer(onInfinityEnd) end
        end,
        DeathBall = function(player, active)
            if player ~= localPlayer and player ~= localPlayer.Name then return end
            local old = sapphireBBState.DeathSlash
            sapphireBBState.DeathSlash = active == true
            if active and not old and flags.DeathSlashDetection and flags.DeathSlashMinigame then task.spawn(doDeathSlashMinigame) end
        end,
        ["RE/TimeHoleActivate"] = function(player)
            if player == localPlayer or player == localPlayer.Name then sapphireBBState.TimeHole = true end
        end,
        ["RE/TimeHoleDeactivate"] = function() sapphireBBState.TimeHole = false end,
        ["RE/SlashesOfFuryCatch"] = furyCatch,
        ["RE/SlashesOfFuryEnd"] = function() sapphireBBState.FuryCatch, sapphireBBState.FuryActive = false, false end,
        AbilityButtonPress = detectFuryAbility,
        ActivateAbility = function(char, data)
            if typeof(char) == "Instance" and char:GetAttribute("Ability") == "Phantom" then
                features.Phantom.Trigger("Phantom", char, type(data) == "table" and data.target)
            end
        end,
        PlrFlashCountered = function(char, target) features.Phantom.Trigger("Flash Counter", char, target) end,
        VisualBindableCD = function()
            if localPlayer:GetAttribute("CurrentlyEquippedAbility") == "Phantom" then
                sapphireBBState.InvisibilityCharacter, sapphireBBState.InvisibilityUntil = localPlayer.Character, os.clock() + 3
            end
        end,
        PlrQuasared = function(player, target)
            if target ~= localPlayer.Character then return end
            local upgrades = typeof(player) == "Instance" and player:FindFirstChild("Upgrades")
            local quasar = upgrades and upgrades:FindFirstChild("Quasar")
            sapphireBBState.QuasarUntil = os.clock() + 5 + (quasar and quasar.Value or 0)
            if flags.AntiBlindness then features.Quasar.ClearBlindness() end
            local saved = flags.AntiDisorientate and sapphireBBState.QuasarCamera
            if saved then task.defer(function()
                local camera = workspace.CurrentCamera
                if camera and flags.AntiDisorientate and not F.Destroyed then camera.CFrame = CFrame.new(camera.CFrame.Position) * saved.Rotation end
            end) end
        end
    }
     
    local function lightingChild(child)
        if child.Name == "Blindness" and not child:IsA("Atmosphere") then
            local ok, signal = pcall(function() return child:GetPropertyChangedSignal("Enabled") end)
            if ok then connect(child, signal, function()
                if flags.AntiBlindness and os.clock() < (sapphireBBState.QuasarUntil or 0) and child.Enabled then child.Enabled = false end
            end) end
        elseif child:IsA("Atmosphere") then
            if flags.AntiBlindness and child.Name == "Blindness" and os.clock() < (sapphireBBState.QuasarUntil or 0) then features.Quasar.ClearBlindness(child)
            elseif child.Name ~= "Blindness" then sapphireBBState.QuasarAtmosphere = child end
        end
    end
    function F.UpdatePhantom()
        if not flags.AntiPhantomEnabled and not flags.AntiFlashCounterEnabled then return end
        local char, distance, data = features.Phantom.Update()
        if not char or data.Blatant then return end
        if data.Type == "Ability" then
            if sapphireBBState.PhantomAbility ~= char and abilityReady() then sapphireBBState.PhantomAbility = char; fireAbility() end
            return
        end
        if F.BlocksParry(nil) then return end
        local root = u1070.player.get_root()
        if not root then return end
        local ball = data.Ball or F.MainBall()
        if not ball then return end
        if data.Name == "Phantom" and (distance > 30 or not features.Phantom.Released(ball)) then return end
         
        local speed = index4(ball).Magnitude
        if (unexecuteFunction(ball) - root.Position).Magnitude <= u1070.parry.get_premium_parry_distance(speed, u1070.config.accuracy) then
            if os.clock() - (F.PhantomParryAt or 0) >= 1 / 60 then
                F.PhantomParryAt = os.clock(); F.Fire(u1070.config.parry_mode)
            end
        end
    end
    function F.Destroy()
        if F.Destroyed then return end
        if F.PreclickAll then F.PreclickAll.Stop() end
        if F.Predictive then F.Predictive.Reset() end
        if F.ResetAutoState then F.ResetAutoState() elseif F.Decision then F.Decision.Reset() end
        if u1070.cache.floxy_ping then u1070.cache.floxy_ping.Destroy() end
        if u1070.ball_velocity and u1070.ball_velocity.stop then u1070.ball_velocity.stop() end
        if F.AutoAnimation then F.AutoAnimation.Reset(true) end
        if u1070.sapphire_misc then u1070.sapphire_misc.Destroy() end
        if u1070.target_player then u1070.target_player.Destroy() end
        if u1070.oxy_manual then u1070.oxy_manual.Destroy() end
        if u1070.runtime_cache then u1070.runtime_cache.Destroy() end
        if features.AutoPlay then pcall(features.AutoPlay.Toggle, false) end
        if features.AFK then pcall(features.AFK.Toggle, false) end
        if features.Stats then pcall(features.Stats.Stop) end
        if features.Streak then pcall(features.Streak.Stop) end
        if features.Rewards then
            for _, item in ipairs(features.Rewards.Items or {}) do flags[item.ID] = false end
            pcall(features.Rewards.Toggle)
        end
        F.Destroyed = true
        u1070.triggerbot.enabled, u1070.triggerbot.connection = false, nil
        for key in pairs(F.Connections) do F.Disconnect(key) end
        local balls = {}
        for ball in pairs(F.Balls) do table.insert(balls, ball) end
        for _, ball in ipairs(balls) do disconnectBall(ball) end
        table.clear(sapphireBBState.StaffDetected)
        features.Phantom.Reset()
    end

     
     
    local managerObject = F.Balls
    local top, currentDate, elapsedTime, packed = false, nil, 0, nil
    local attemptAutoParry
    local function isInTrainingArea(char)
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local lobby = workspace:FindFirstChild("LobbyTraining", true)
        local area = lobby and lobby:FindFirstChild("TrainingArea")
        if not root or not area or not area:IsA("BasePart") then return false end
        local point, half = area.CFrame:PointToObjectSpace(root.Position), area.Size * 0.5
        return math.abs(point.X) <= half.X and math.abs(point.Y) <= half.Y and math.abs(point.Z) <= half.Z
    end
    local function undoFunction(char)
        return char and char.PrimaryPart and (char.Parent == smallest or isInTrainingArea(char))
    end
    local function redoFunction(ball, part, now)
         
         
        return nil
    end
    local function onInputEnded(ball, position, ballPosition, velocity)
        local offset = position - (ballPosition or unexecuteFunction(ball))
        local distance = offset.Magnitude
        if distance < 0.001 then return 0, 0 end
        local projected = offset:Dot(velocity or index4(ball))
        if projected <= 0 then return math.huge, distance end
        return distance * distance / projected, distance
    end
    F.TimeToImpact = onInputEnded
     
    do
        local function initializePredictiveTiming()
            local P = {Frame = 1 / 60, FrameSamples = {}}
            F.Predictive = P
            local function finite(value)
                return type(value) == "number" and value == value and math.abs(value) < 1e8
            end
            local function vector(value)
                return typeof(value) == "Vector3" and finite(value.X) and finite(value.Y) and finite(value.Z)
            end
            function P.Clear(state) state.Predictive = nil end
            function P.Reset()
                P.Frame = 1 / 60
                table.clear(P.FrameSamples)
                for _, state in pairs(F.Balls) do P.Clear(state) end
            end
            function P.Observe(delta)
                if finite(delta) and delta >= 0.001 and delta <= 0.1 then
                    if #P.FrameSamples >= 9 then table.remove(P.FrameSamples, 1) end
                    table.insert(P.FrameSamples, delta)
                    local sorted = table.clone(P.FrameSamples)
                    table.sort(sorted)
                    local target = sorted[math.ceil(#sorted / 2)]
                    if #sorted < 5 then target = math.min(target, P.Frame * 1.5) end
                    P.Frame += (target - P.Frame) * 0.2
                end
            end
            function P.SetEnabled(enabled)
                u1070.config.predictive_timing = enabled == true
                P.Reset()
            end
            function P.Credit(speed, step, accuracyError, multiple, minimum, normal, center)
                 
                if center <= 9.5 then return 0 end
                local lead = math.min(speed * step, 30)
                if accuracyError <= 70 or multiple and accuracyError > 44 and normal >= minimum then return lead end
                local blend = math.clamp((accuracyError - 44) / 30, 0, 1)
                blend = blend * blend * (3 - 2 * blend)
                return lead * (1 - blend)
            end
            local function linearEntry(relative, motion, radius)
                local c = relative:Dot(relative) - radius * radius
                if c <= 0 then return 0 end
                local a, b = motion:Dot(motion), relative:Dot(motion)
                if a < 1e-12 or b >= 0 then return nil end
                local discriminant = b * b - a * c
                if discriminant < 0 then return nil end
                return c / (-b + math.sqrt(discriminant))
            end
            function P.SweptEntry(relative, motion, acceleration, radius, horizon)
                if acceleration.Magnitude < 0.001 then return linearEntry(relative, motion, radius) end
                if relative.Magnitude <= radius then return 0 end
                local function point(t) return relative + motion * t + acceleration * (0.5 * t * t) end
                local interval = horizon / 8
                 
                 
                local inset = acceleration.Magnitude * interval * interval / 8 + 1e-7
                local innerRadius = math.max(0, radius - inset)
                local start = relative
                for i = 1, 8 do
                    local finishTime = interval * i
                    local finish = point(finishTime)
                    local fraction = linearEntry(start, finish - start, innerRadius)
                    if fraction and fraction <= 1 then
                        local low = finishTime - interval
                        local high = low + interval * fraction
                        if point(high).Magnitude <= radius then
                            if point(low).Magnitude <= radius then return low end
                            for _ = 1, 14 do
                                local middle = (low + high) * 0.5
                                if point(middle).Magnitude <= radius then high = middle else low = middle end
                            end
                            return high
                        end
                    end
                    start = finish
                end
                return nil
            end
            function P.Evaluate(state, ball, target, root, position, velocity, radius, credit, ping, now)
                if not root or not vector(root.Position) or not vector(position) or not finite(radius) then
                    P.Clear(state); return false, nil
                end
                local legacy = (root.Position - position).Magnitude <= radius
                if F.Destroyed or u1070.config.predictive_timing ~= true then return legacy, nil end
                if not vector(position) or not vector(velocity) or not vector(root.Position)
                    or not finite(radius) or radius <= 0 or not finite(credit) or not finite(ping) then
                    P.Clear(state); return legacy, nil
                end
                if target ~= localPlayer.Name then P.Clear(state); return false, nil end
                local playerVelocity = root.AssemblyLinearVelocity
                if not vector(playerVelocity) or playerVelocity.Magnitude > 500 then playerVelocity = Vector3.zero end
                local relative = position - root.Position
                local motion = velocity - playerVelocity
                local distance, speed = relative.Magnitude, motion.Magnitude
                if not finite(speed) or speed > 1e6 then P.Clear(state); return legacy, nil end
                local old = state.Predictive
                local dt = old and now - old.At or 0
                local continuous = old and old.Ball == ball and old.Target == target and old.Root == root
                    and old.Version == state.CurveVersion and dt >= 0.001 and dt <= 0.15
                if continuous then
                    local expected = old.Position + old.Velocity * dt
                    local playerExpected = old.PlayerPosition + old.PlayerVelocity * dt
                    if (position - expected).Magnitude > math.max(25, old.Velocity.Magnitude * dt)
                        or (root.Position - playerExpected).Magnitude > 15 then continuous = false end
                    local oldSpeed = old.Motion.Magnitude
                    if speed > 0.01 and oldSpeed > 0.01 and (motion / speed):Dot(old.Motion / oldSpeed) < 0.95 then continuous = false end
                end
                 
                local sameSnapshot = old and old.Ball == ball and old.Target == target and old.Root == root
                    and old.Version == state.CurveVersion and dt >= 0 and dt < 0.001
                    and old.Position == position and old.PlayerPosition == root.Position and old.Velocity == velocity and old.PlayerVelocity == playerVelocity
                local sample = sameSnapshot and old or (continuous and old or {})
                local acceleration = sameSnapshot and old.Acceleration or Vector3.zero
                local count = sameSnapshot and old.Count or 1
                local confidence = sameSnapshot and old.Confidence or 0.5
                local evidence = sameSnapshot and old.Evidence or 1
                local pending = sameSnapshot and old.PendingAcceleration or nil
                local anchorAt = sameSnapshot and old.AnchorAt or now
                local anchor = sameSnapshot and old.Anchor or relative
                local integral = sameSnapshot and old.Integral or Vector3.zero
                if continuous then
                    local observed = (position - root.Position) - (old.Position - old.PlayerPosition)
                    local expected = (motion + old.Motion) * (dt * 0.5)
                    local tolerance = math.max(0.15, expected.Magnitude * 0.3)
                    local instantEvidence = 1 - math.clamp((observed - expected).Magnitude / tolerance, 0, 1)
                     
                     
                    anchorAt, anchor = old.AnchorAt, old.Anchor
                    integral = old.Integral + expected
                    evidence, confidence = old.Evidence, old.Confidence
                    if now - anchorAt >= 0.04 then
                        local errorDistance = ((relative - anchor) - integral).Magnitude
                        evidence = 1 - math.clamp(errorDistance / math.max(0.4, integral.Magnitude * 0.4), 0, 1)
                        confidence = confidence * 0.5 + evidence * 0.5
                        anchorAt, anchor, integral = now, relative, Vector3.zero
                    end
                    local change = motion - old.Motion
                    local measured = change / dt
                    local previous = old.PendingAcceleration
                    local consistent = previous and previous.Magnitude > 0.001 and measured.Magnitude > 0.001
                        and measured:Dot(previous) / (measured.Magnitude * previous.Magnitude) >= 0.7
                        and measured.Magnitude >= previous.Magnitude * 0.25 and measured.Magnitude <= previous.Magnitude * 4
                     
                     
                    if change.Magnitude > math.max(1, speed * 0.015) and instantEvidence >= 0.6 then
                        pending = measured
                        acceleration = consistent and old.Acceleration * 0.6 + measured * 0.4 or old.Acceleration * 0.5
                    else
                        pending = nil; acceleration = old.Acceleration * 0.5
                    end
                    count = math.min(old.Count + 1, 8)
                end
                sample.Ball, sample.Target, sample.Root, sample.Version = ball, target, root, state.CurveVersion
                sample.At, sample.Position, sample.PlayerPosition = now, position, root.Position
                sample.Velocity, sample.PlayerVelocity, sample.Motion = velocity, playerVelocity, motion
                sample.Acceleration, sample.Count = acceleration, count
                sample.Confidence, sample.Evidence, sample.PendingAcceleration = confidence, evidence, pending
                sample.AnchorAt, sample.Anchor, sample.Integral = anchorAt, anchor, integral
                state.Predictive = sample
                local baseRadius = math.max(1, radius - math.max(0, credit))
                local frame = math.clamp(P.Frame, 0.004, 0.033)
                local creditedTime = speed > 0.01 and math.max(credit, 0) / speed or 0
                 
                local horizon = math.clamp(creditedTime + frame, 0.004, 0.12)
                if count < 2 then horizon = math.min(horizon, creditedTime + math.min(frame, 0.02)) end
                local applied = count >= 3 and confidence >= 0.5 and evidence >= 0.6 and acceleration or Vector3.zero
                local maxAcceleration = speed * 0.15 / horizon
                if applied.Magnitude > maxAcceleration and applied.Magnitude > 0.001 then
                    applied = applied / applied.Magnitude * maxAcceleration
                end
                sample.AppliedAcceleration = applied
                sample.BaseRadius, sample.Horizon = baseRadius, horizon
                local function decision(allowed, eta, reason)
                    sample.Allowed, sample.ETA, sample.Reason = allowed, eta, reason
                    return allowed, eta
                end
                 
                if legacy and distance <= math.min(baseRadius, 12) then return decision(true, 0, "close") end
                if speed < 0.01 then return decision(legacy, nil, "stationary") end
                if count >= 2 and confidence < 0.4 then return decision(legacy, nil, "uncertain motion") end
                if relative:Dot(motion) >= 0 then return decision(false, nil, "receding") end
                local a, b = motion:Dot(motion), relative:Dot(motion)
                if a < 1e-6 or b >= 0 then return decision(false, nil, "turning away") end
                local eta = P.SweptEntry(relative, motion, applied, baseRadius, horizon)
                if not eta then return decision(false, nil, "miss") end
                 
                local extension = math.min(20, speed * 0.04)
                if distance > radius + extension then return decision(false, eta, "outside envelope") end
                 
                 
                local activeWindow = math.max(0, 0.5 - math.max(ping, 0) / 2000)
                if distance > radius and -b / a > activeWindow then return decision(false, eta, "too early") end
                return decision(eta <= horizon, eta, eta <= horizon and "entry" or "waiting")
            end
        end
        initializePredictiveTiming()
    end
     
    do
        local function initializeAutoDecision()
            local D = {Generation = 0, Receipts = {}}
            F.Decision = D
            function D.Vector(value)
                if typeof(value) ~= "Vector3" then return false end
                local x, y, z = value.X, value.Y, value.Z
                return x == x and y == y and z == z and math.abs(x) < 1e8 and math.abs(y) < 1e8 and math.abs(z) < 1e8
            end
            function D.ReadRaw(ball)
                local ok, position, velocity, part = pcall(function()
                    local body = executeFunction(ball)
                    if not body then return nil end
                    return body.Position, index4(ball), body
                end)
                if ok and D.Vector(position) and D.Vector(velocity) then return position, velocity, part end
                return nil
            end
            function D.Read(ball, scan)
                if not scan then return D.ReadRaw(ball) end
                if scan.Generation ~= D.Generation or scan.Character ~= localPlayer.Character
                    or not scan.Character or scan.Character.PrimaryPart ~= scan.Root then return nil end
                if not scan.Samples then scan.Samples = {} end
                local sample = scan.Samples[ball]
                local state = F.Balls[ball]
                if sample and state and sample.Cycle ~= state.AutoCycleVersion then sample = nil end
                if sample == nil then
                    local position, velocity, part = D.ReadRaw(ball)
                    if scan.Generation ~= D.Generation then return nil end
                    if position then
                        local effective, source = D.Motion(ball, position, velocity, part, scan)
                        sample = {Position = position, RawVelocity = velocity, Velocity = effective, Source = source,
                            Part = part, Parent = ball.Parent, Cycle = index7(ball).AutoCycleVersion}
                    else sample = false end
                    scan.Samples[ball] = sample
                end
                if sample then return sample.Position, sample.Velocity, sample.Part end
                return nil
            end
            function D.PlayerVelocity(root)
                local velocity = root.AssemblyLinearVelocity
                return D.Vector(velocity) and velocity:Dot(velocity) <= 250000 and velocity or Vector3.zero
            end
            function D.Frame(root, network)
                if not D.Vector(root.Position) then return nil end
                 
                return {Root = root, Character = localPlayer.Character, RootPosition = root.Position,
                    PlayerVelocity = D.PlayerVelocity(root), At = os.clock(), Generation = D.Generation, Network = network}
            end
            function D.SameVector(a, b)
                return D.Vector(a) and D.Vector(b) and a.X == b.X and a.Y == b.Y and a.Z == b.Z
            end
            function D.SenderMatches(expected, sender, allowOwn)
                if sender == expected or allowOwn and sender == localPlayer.Name then return true end
                if sender == nil or sender == "" then return true end
                if expected == nil or expected == "" then return type(sender) == "string" and sender ~= localPlayer.Name end
                return false
            end
            function D.Motion(ball, position, velocity, part, scan)
                if scan.Generation ~= D.Generation or scan.Character ~= localPlayer.Character
                    or not scan.Character or scan.Character.PrimaryPart ~= scan.Root then return velocity, "native" end
                local state = index7(ball)
                local now, target = scan.At, compareFunction(ball)
                local sender = ball:GetAttribute("from")
                if type(sender) ~= "string" or sender == "" then sender = nil end
                local m = state.Motion
                 
                if m and now < m.Seen then return velocity, "native" end
                if not m or m.Character ~= scan.Character or m.Root ~= scan.Root or m.Part ~= part
                    or m.Parent ~= ball.Parent or m.Target ~= target or now - m.Seen > 0.25
                    or sender and sender ~= m.Sender and (m.Sender ~= nil or sender == localPlayer.Name) then
                    m = {Character = scan.Character, Root = scan.Root, Part = part, Parent = ball.Parent, Target = target, Sender = sender,
                        Position = position, At = now, Seen = now, Raw = velocity, RawAt = now, Count = 0}
                    state.Motion = m
                    return velocity, "native"
                end
                 
                if sender then m.Sender = sender end
                local rawDelta = velocity - m.Raw
                if rawDelta:Dot(rawDelta) > math.max(16, m.Raw:Dot(m.Raw) * 0.0225) then
                    m.Raw, m.RawAt, m.Count, m.Estimate = velocity, now, 0, nil
                end
                m.Seen = now
                local delta, dt = position - m.Position, now - m.At
                if m.Estimate and dt >= 0 and dt < 0.008 then
                    local distance2, speed2 = delta:Dot(delta), m.Estimate:Dot(m.Estimate)
                    local projection = delta:Dot(m.Estimate)
                    if distance2 > math.max(0.0025, speed2 * dt * dt * 0.0625)
                        and (projection <= 0 or projection * projection < distance2 * speed2 * 0.25) then
                         
                         
                        m.Position, m.At, m.Count, m.Estimate, m.Measured = position, now, 0, nil, nil
                        return velocity, "native"
                    end
                end
                if delta:Dot(delta) > 0.000001 and dt >= 0.008 then
                    local measured = delta / dt
                    local speed2 = measured:Dot(measured)
                    if dt <= 0.2 and speed2 >= 4 and speed2 <= 144000000 then
                        local previous = m.Measured
                        local previous2 = previous and previous:Dot(previous) or 0
                        local agreement = previous2 > 0 and measured:Dot(previous) / math.sqrt(speed2 * previous2) or 0
                        local ratio = previous2 > 0 and speed2 / previous2 or 0
                        if agreement >= 0.94 and ratio >= 0.49 and ratio <= 2.04 then
                            m.Count = math.min((m.Count or 0) + 1, 4)
                             
                            m.Estimate = measured * math.sqrt(math.min(speed2, previous2) / speed2)
                        else
                            m.Count, m.Estimate = 1, nil
                        end
                        m.Measured, m.Cadence = measured, dt
                    else
                        m.Count, m.Estimate, m.Measured = 0, nil, nil
                    end
                    m.Position, m.At = position, now
                elseif dt > 0.2 then
                    m.Position, m.At, m.Count, m.Estimate, m.Measured = position, now, 0, nil, nil
                end
                local estimate = m.Estimate
                local lifetime = math.clamp((m.Cadence or 0.025) * 2.2, 0.035, 0.12)
                if estimate and m.Count >= 2 and now - m.At <= lifetime and now - m.RawAt >= math.min(0.12, (m.Cadence or 0.025) * 1.8) then
                    local speed2, raw2 = estimate:Dot(estimate), velocity:Dot(velocity)
                    local alignment = raw2 > 1 and velocity:Dot(estimate) / math.sqrt(raw2 * speed2) or 0
                    local ratio = raw2 / speed2
                    local sustained = m.Count >= 3 and now - m.RawAt >= 0.12
                        and alignment >= 0.94 and (ratio < 0.49 or ratio > 2.04)
                    if raw2 < 1 or alignment < 0.7 or ratio < 0.1225 or ratio > 7.84 or sustained then
                        return estimate, "observed"
                    end
                end
                return velocity, "native"
            end
            function D.Velocity(ball)
                local character = localPlayer.Character
                local root = character and character.PrimaryPart
                local scan = root and D.Frame(root)
                local _, velocity = D.Read(ball, scan)
                return velocity or Vector3.zero
            end
            function D.PruneReceipts(now)
                local receipts = D.Receipts
                for i = #receipts, 1, -1 do
                    local receipt = receipts[i]
                    if receipt.Dropped or receipt.Generation ~= D.Generation or now - receipt.At > 1.5 or now < receipt.At then
                        table.remove(receipts, i)
                    end
                end
            end
            function D.Transported(token)
                token.TransportSucceeded = true
            end
            function D.Acknowledge(name, object, explicitName, now)
                D.PruneReceipts(now)
                local explicit = type(explicitName) == "string" and explicitName ~= ""
                local id = explicit and explicitName or type(name) == "string" and name or nil
                local named, count, seen = nil, 0, {}
                local balls = features.Ball.GetAllBalls()
                for _, ball in ipairs(balls) do
                    if ball.Name == id and not seen[ball] then named, count = ball, count + 1; seen[ball] = true end
                end
                local namedReceipt = false
                for _, receipt in ipairs(D.Receipts) do
                    if receipt.Ball.Name == id then namedReceipt = true; break end
                end
                local filter = explicit or count > 0 or namedReceipt
                local pending, owner, anyOwner, ambiguous, acknowledgedAt = nil, nil, nil, false, nil
                for _, receipt in ipairs(D.Receipts) do
                    if not filter or receipt.Ball.Name == id then
                        if anyOwner and anyOwner ~= receipt.Ball then ambiguous = true end
                        anyOwner = anyOwner or receipt.Ball
                        if receipt.Acked then acknowledgedAt = math.max(acknowledgedAt or -math.huge, receipt.AckAt or -math.huge)
                        else
                            if owner and owner ~= receipt.Ball then ambiguous = true end
                            owner, pending = owner or receipt.Ball, pending or receipt
                        end
                    end
                end
                if ambiguous then D.LastAckReason = "ambiguous"; return true end
                if not pending then
                    if acknowledgedAt and now - acknowledgedAt <= 0.035 then D.LastAckReason = "duplicate"; return true end
                    if count == 1 then D.LastAckReason = "named legacy/manual"; return true, named end
                    if filter then D.LastAckReason = "unknown or non-unique name"; return true end
                    return false
                end
                if acknowledgedAt and now - acknowledgedAt <= 0.035 and pending.At <= acknowledgedAt then
                    D.LastAckReason = "possible duplicate"; return true
                end
                pending.Acked, pending.AckAt = true, now
                D.LastAck = {Ball = owner, At = now}
                local state = F.Balls[owner]
                 
                if state == pending.State and state.AutoReservation == pending and state.AutoParryAt == pending.At
                    and state.AutoCycleVersion == pending.Cycle and state.CurveVersion == pending.Version
                    and owner.Parent == pending.Parent and localPlayer.Character == pending.Character
                    and pending.Character.PrimaryPart == pending.Root then
                    state.AutoParryAt = nil
                    if sapphireBBState.AutoBall == owner then sapphireBBState.AutoBall = nil end
                end
                D.LastAckReason = "matched automatic receipt"
                if u1070.config.auto_parry == true and #balls > 1 then F.QueueAuto() end
                return true
            end
            function D.Choose(scan, ball, geometry, state, target, version, cycle, sender)
                scan.Ball, scan.Geometry, scan.State, scan.Target = ball, geometry, state, target
                scan.Version, scan.Cycle, scan.Sender = version, cycle, sender
            end
            function D.Selection(scan, ball, geometry, state, target, version, cycle, sender)
                 
                local selected = table.clone(scan)
                D.Choose(selected, ball, geometry, state, target, version, cycle, sender)
                return selected
            end
            function D.Fresh(scan)
                local ball, state = scan.Ball, scan.State
                local function contextCurrent()
                    local now = os.clock()
                    local character = localPlayer.Character
                    return scan.Generation == D.Generation and now >= scan.At and now - scan.At <= 0.1
                        and character == scan.Character and character ~= nil and character.PrimaryPart == scan.Root
                        and D.SameVector(scan.Root.Position, scan.RootPosition)
                        and D.SameVector(D.PlayerVelocity(scan.Root), scan.PlayerVelocity)
                        and F.Balls[ball] == state and state.CurveVersion == scan.Version and state.AutoCycleVersion == scan.Cycle
                        and compareFunction(ball) == scan.Target and D.SenderMatches(scan.Sender, ball:GetAttribute("from"), false)
                end
                if not contextCurrent() then return false end
                local function sameSample(item)
                    local sample = scan.Samples[item]
                    if not sample or item.Parent ~= sample.Parent or not item.Parent then return false end
                    local position, velocity, part = D.ReadRaw(item)
                    return part == sample.Part and item.Parent == sample.Parent
                        and D.SameVector(position, sample.Position) and D.SameVector(velocity, sample.RawVelocity)
                end
                 
                return sameSample(ball) and (scan.Geometry == ball or sameSample(scan.Geometry)) and contextCurrent()
            end
            function D.Alive(character)
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                return humanoid and type(humanoid.Health) == "number" and humanoid.Health > 0
                    and character.PrimaryPart and D.Vector(character.PrimaryPart.Position)
            end
            function D.Threat(root, position, velocity, scan)
                local rootPosition = scan and scan.Root == root and scan.RootPosition or root.Position
                if not D.Vector(rootPosition) or not D.Vector(position) or not D.Vector(velocity) then return false, math.huge, math.huge end
                local playerVelocity = scan and scan.Root == root and scan.PlayerVelocity or D.PlayerVelocity(root)
                local relative, motion = position - rootPosition, velocity - playerVelocity
                local distanceSquared = relative:Dot(relative)
                if distanceSquared < 0.000001 then return true, 0, 0 end
                local distance = math.sqrt(distanceSquared)
                if motion:Dot(motion) < 0.000001 then return true, math.huge, distance end
                local closing = -relative:Dot(motion)
                if closing <= 0 then return distanceSquared <= 144, math.huge, distance end
                 
                return true, distanceSquared / closing, distance
            end
            function D.Arrival(root, position, velocity, scan)
                local approaching, radial, distance = D.Threat(root, position, velocity, scan)
                if not approaching or radial == math.huge or distance <= 12 then return approaching, radial, distance end
                local rootPosition = scan and scan.Root == root and scan.RootPosition or root.Position
                local playerVelocity = scan and scan.Root == root and scan.PlayerVelocity or D.PlayerVelocity(root)
                local relative, motion = position - rootPosition, velocity - playerVelocity
                local a, b = motion:Dot(motion), relative:Dot(motion)
                local missSquared = a > 0.000001 and math.max(0, relative:Dot(relative) - b * b / a) or 0
                local penalty = math.clamp((missSquared - 144) / 144, 0, 1) * 0.5
                return true, radial * (1 + penalty), distance
            end
            function D.Rank(root, position, velocity, scan)
                local approaching, radial, distance = D.Threat(root, position, velocity, scan)
                if not approaching then return false, radial, distance, 2 end
                if distance <= 12 then return true, 0, distance, 0 end
                if radial == math.huge then return false, radial, distance, 2 end
                local rootPosition = scan and scan.Root == root and scan.RootPosition or root.Position
                local playerVelocity = scan and scan.Root == root and scan.PlayerVelocity or D.PlayerVelocity(root)
                local relative, motion = position - rootPosition, velocity - playerVelocity
                local rx, ry, rz = relative.X, relative.Y, relative.Z
                local vx, vy, vz = motion.X, motion.Y, motion.Z
                local a, b = vx * vx + vy * vy + vz * vz, rx * vx + ry * vy + rz * vz
                local x, y, z = ry * vz - rz * vy, rz * vx - rx * vz, rx * vy - ry * vx
                local missSquared = (x * x + y * y + z * z) / a
                if missSquared <= 144 then
                    local c = rx * rx + ry * ry + rz * rz - 144
                    local impact = c / (-b + math.sqrt(a * math.max(0, 144 - missSquared)))
                    return true, impact, distance, 0
                end
                local penalty = math.clamp((missSquared - 144) / 144, 0, 1) * 0.5
                return true, radial * (1 + penalty), distance, 1
            end
            function D.Prefer(priority, arrival, distance, previousPriority, previousArrival, previousDistance)
                return priority < previousPriority or priority == previousPriority
                    and (arrival < previousArrival or arrival == previousArrival and distance < previousDistance)
            end
            local frameTime = {At = nil, Budget = 0}
            D.FrameTime = frameTime
            function D.ResetFrameTime()
                frameTime.At, frameTime.Budget = nil, 0
            end
            function D.ObserveFrame(delta)
                if delta == nil then return end
                local now = os.clock()
                if type(delta) ~= "number" or delta ~= delta or delta <= 0 or delta > 0.25 then
                    frameTime.At, frameTime.Budget = now, 0
                    return
                end
                local gap = frameTime.At and now - frameTime.At or 0
                frameTime.At = now
                frameTime.Budget = gap >= 0 and gap <= 0.25 and math.min(gap, 0.02) or 0
            end
            function D.FrameBudget(now)
                if frameTime.At then
                    return now >= frameTime.At and now - frameTime.At <= 0.1 and frameTime.Budget or 0
                end
                return math.clamp(now - (sapphireBBState.ParryFrameAt or now), 0, 0.02)
            end
            function D.TimingRadius(root, position, velocity, radius, scan, ping, step)
                if type(radius) ~= "number" or radius ~= radius or radius <= 0 then return 0 end
                if not D.Vector(position) or not D.Vector(velocity) then return radius end
                local rootPosition = scan and scan.Root == root and scan.RootPosition or root.Position
                if not D.Vector(rootPosition) then return radius end
                local delta = position - rootPosition
                local distance = delta.Magnitude
                if distance < 0.001 then return radius end
                local playerVelocity = scan and scan.Root == root and scan.PlayerVelocity or D.PlayerVelocity(root)
                local closing = playerVelocity:Dot(delta) / distance
                local latency = type(ping) == "number" and ping == ping and math.clamp(ping / 2000, 0, 0.12) or 0
                local credit = type(step) == "number" and step == step and math.clamp(step, 0, 0.06) or 0
                local horizon = math.clamp(latency + credit, 0.01, 0.16)
                local adjustment = math.clamp(closing * horizon, -math.min(8, radius * 0.15), math.min(10, radius * 0.2))
                return math.max(3, radius + adjustment)
            end
            function D.Clear(state)
                state.AutoCycleVersion = (state.AutoCycleVersion or 0) + 1
                state.AutoReservation, state.Motion = nil, nil
                state.BackwardsScore, state.BackwardsAt = nil, nil
                state.CurveObservation, state.CurveWarping, state.CurveTime = nil, nil, nil
            end
            function D.Reset()
                D.ResetFrameTime()
                D.Generation += 1
                D.Inflight, D.LastAck = nil, nil
                table.clear(D.Receipts)
                F.AutoJob, F.AutoBusy, F.AutoPending = nil, false, false
                for _, state in pairs(F.Balls) do D.Clear(state) end
            end
            function D.Begin(ball, state, character, now, job)
                local token = {Ball = ball, State = state, Character = character, Root = character.PrimaryPart,
                    Target = compareFunction(ball), From = ball:GetAttribute("from"), Parent = ball.Parent,
                    Version = state.CurveVersion, Cycle = state.AutoCycleVersion, Generation = job and job.Generation or D.Generation, Job = job, At = now, Until = now + 0.6}
                D.PruneReceipts(now)
                if #D.Receipts >= 16 then table.remove(D.Receipts, 1) end
                D.Receipts[#D.Receipts + 1] = token
                state.AutoReservation = token
                D.Inflight = token
                if job then job.Inflight = token end
                return token
            end
            function D.Valid(token)
                return not F.Destroyed and token.Generation == D.Generation
                    and (not token.Job or F.AutoJob == token.Job)
                    and token.State.AutoReservation == token and F.Balls[token.Ball] == token.State
                    and token.State.CurveVersion == token.Version and token.Ball.Parent == token.Parent
                    and token.Ball.Parent ~= nil and localPlayer.Character == token.Character
                    and token.Character.PrimaryPart == token.Root and D.Alive(token.Character)
                    and undoFunction(token.Character) and not continuation(token.Character)
                    and (u1070.config.auto_parry == true or flags.DribbleDetection)
                    and compareFunction(token.Ball) == token.Target
                    and D.SenderMatches(token.From, token.Ball:GetAttribute("from"), true)
            end
            function D.Animate(isTriggerbot)
                local ok, played = pcall(features.Animation.PlayAnimation, true, isTriggerbot)
                if not ok then D.AnimationError = tostring(played); return false end
                return played
            end
            function D.Finish(token)
                if D.Inflight == token then D.Inflight = nil end
                if token.Job and token.Job.Inflight == token then token.Job.Inflight = nil end
            end
            function D.Abort(token)
                D.Finish(token)
                if not token.TransportSucceeded and not token.Acked then token.Dropped = true end
                local state = token.State
                if state.AutoReservation ~= token then return end
                state.AutoReservation = nil
                if state.AutoParryAt ~= token.At or state.ParryResetAt ~= token.Until then return end
                state.Parried, state.ParryResetAt, state.AutoParryAt = false, 0, nil
                if sapphireBBState.AutoBall == token.Ball then sapphireBBState.AutoBall = nil end
                if currentDate == token.Ball and elapsedTime == token.Until then top, currentDate, elapsedTime = false, nil, 0 end
            end
        end
        initializeAutoDecision()
    end
    local bottomSnapZone, knob
    local hotbarRefreshAt = -math.huge
    local function refreshHotbar()
        local now = os.clock()
        if now - hotbarRefreshAt < 0.1 then return end
        hotbarRefreshAt = now
        local ability, hotbar = refresh()
        local block = hotbar and hotbar:FindFirstChild("Block")
        bottomSnapZone = block and block:FindFirstChildOfClass("UIGradient")
        knob = ability and ability:FindFirstChildOfClass("UIGradient")
    end
    function F.SyncAutoSettings()
        refreshHotbar()
        local config = u1070.config
        flags.AutoParryEnabled = config.auto_parry == true
        config.parry_mode = u864.normalize_parry_method(config.parry_mode)
        flags.AutoParryType = config.parry_mode
        flags.ParryAccuracy = config.accuracy or 80
        flags.ParryRange = config.parry_range or 0
        flags.RandomizedParryAccuracy = config.randomize_accuracy == true
        local low = math.clamp(tonumber(config.random_accuracy_min) or 1, 1, 100)
        local high = math.clamp(tonumber(config.random_accuracy_max) or 100, 1, 100)
        flags.RandomAccuracyMin, flags.RandomAccuracyMax = math.min(low, high), math.max(low, high)
        flags.AutoAbilityEnabled = u1070.ability.auto_ability == true
        flags.CooldownProtectionEnabled = u1070.ability.cooldown_protection == true
        flags.AutoSpamEnabled = u1070.spam.auto_enabled == true
        flags.ManualSpamEnabled = u1070.spam.manual_enabled == true
        flags.TriggerbotEnabled = u1070.triggerbot.enabled == true
        flags.AntiCurveEnabled, flags.BackwardsAntiCurveEnabled = true, true
    end
    local autoAbilities = {
        "Calming Deflection", "Raging Deflection", "Rapture", "Aerodynamic Slash", "Forcefield",
        "Infinity", "Fracture", "Phantom", "Ninja Dash", "Dribble", "Dragon Spirit"
    }
    local function wrapper(abilities)
        if not abilities or not abilityReady() then return false end
        for _, name in ipairs(autoAbilities) do
            local ability = abilities:FindFirstChild(name)
            if ability and ability.Enabled then return fireAbility() end
        end
        return false
    end
    local left = {Fire = function() return fireAbility() end}
    features.Loop = {InvisDetection = F.InvisDetection}
    features.Ball.GetAllBalls = function(refreshed)
        if not refreshed then refresh() end
        local char = localPlayer.Character
        local training = char and char.Parent ~= smallest and isInTrainingArea(char)
        local folder = training and CoreGui or playerGui
        local list = {}
        for _, item in ipairs(u1070.ball.get_all()) do
            local ball = item.model or item.part
            if folder and ball.Parent == folder then table.insert(list, ball) end
        end
        return list
    end
    features.Ball.GetMainBall = function()
        local char = localPlayer.Character
        local root = char and char.PrimaryPart
        local best, time, distance, bestPriority
        local scan = root and u1070.config.auto_parry == true and F.Decision.Frame(root)
        for _, ball in ipairs(features.Ball.GetAllBalls()) do
            if compareFunction(ball) == localPlayer.Name then
                if not root then features.Ball.Target = ball; return ball end
                local arrival, separation
                local priority = 0
                if u1070.config.auto_parry == true then
                    local position, velocity = F.Decision.Read(ball, scan)
                    if not position then continue end
                    local approaching
                    approaching, arrival, separation, priority = F.Decision.Rank(root, position, velocity, scan)
                    if not approaching then continue end
                else
                    arrival, separation = onInputEnded(ball, root.Position)
                end
                if not best or F.Decision.Prefer(priority, arrival, separation, bestPriority, time, distance) then
                    best, time, distance, bestPriority = ball, arrival, separation, priority
                end
            end
        end
        features.Ball.Target = best
        return best
    end
    F.MainBall = features.Ball.GetMainBall
    features.Parry = {Fire = function()
         
        return F.Fire("Remote"), false
    end}
    features.Curve = {GetCFrame = function() return u1070.curve.get_cframe() end}
     
    local A = {Generation = 0, Owned = {}, Metadata = {}, Pending = nil}
    F.AutoAnimation = A
    local function oxyTrack()
        local oxy = u1070.oxy_manual
        return oxy and oxy.Visual and oxy.Visual.Track
    end
    function A.Reset(full)
        A.Generation += 1
        A.Pending = nil
        for track in pairs(A.Owned) do
            if track ~= oxyTrack() then pcall(function() track:Stop(0) end) end
        end
        table.clear(A.Owned)
        sapphireBBState.GrabAnimation = nil
        sapphireBBState.AutoParryAnimationPlayed = nil
        if full then A.Sword = nil end
    end
    function A.Allowed(character, sword, generation)
        if F.Destroyed or u1070.config.auto_parry_animation_fix ~= true or u1070.config.auto_parry ~= true
            or character ~= localPlayer.Character or A.Generation ~= generation then return false end
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        return humanoid and humanoid.Health > 0 and undoFunction(character) and not continuation(character)
            and (u1070.animation.get_sword_name() or "Base Sword") == sword
    end
    function A.Modules()
        local shared = replicatedStorage:FindFirstChild("Shared")
        local controllers = replicatedStorage:FindFirstChild("Controllers")
        local apiModule = shared and shared:FindFirstChild("SwordAPI")
        local controllerModule = controllers and controllers:FindFirstChild("AnimationController")
        if not apiModule or not controllerModule then error("SwordAPI/AnimationController is missing", 0) end
        if A.APIModule ~= apiModule then A.API = require(apiModule); A.APIModule = apiModule end
        if A.ControllerModule ~= controllerModule then A.Controller = require(controllerModule); A.ControllerModule = controllerModule end
        return shared, A.API, A.Controller
    end
    function A.ParryAnimation(character, sword, generation)
        if not A.Allowed(character, sword, generation) then return false end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return false end
        local shared, api, controller = A.Modules()
        if not A.Allowed(character, sword, generation) then return false end
        local data = A.Metadata[sword]
        if not data then
            local replicated = shared:FindFirstChild("ReplicatedInstances")
            local swords = replicated and replicated:FindFirstChild("Swords")
            local getSword = swords and swords:FindFirstChild("GetSword")
            if not getSword then error("Sword metadata is missing", 0) end
            data = getSword:Invoke(sword)
            if type(data) ~= "table" then error("Sword metadata could not be resolved", 0) end
            A.Metadata[sword] = data
        end
         
        local assets = api:GetAnimations(character, {"Parry", "GrabParry"}, data.AnimationType, data.SwordType)
        if not A.Allowed(character, sword, generation) then return false end
        if type(assets) ~= "table" or not next(assets) then return false end
        local tracks = {}
        for _, asset in pairs(assets) do
            if not A.Allowed(character, sword, generation) then return false end
            local track = controller:LoadAnimation(animator, asset, true)
            if track then table.insert(tracks, track) end
        end
        if not A.Allowed(character, sword, generation) then return false end
        for _, track in pairs(controller:GetPlayingAnimationTracks(animator)) do
            if track ~= oxyTrack() and (track:GetAttribute("GrabParry") or track:GetAttribute("Parry")
                or track.Name == "GrabParry" or track.Name == "Grab" or track.Name == "SuccessParry" or track.Name == "Success") then
                track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
            end
        end
        table.clear(A.Owned)
        sapphireBBState.GrabAnimation = {}
        local played = false
        for _, track in ipairs(tracks) do
            if not A.Allowed(character, sword, generation) then return false end
            A.Owned[track] = true
            local speed = track:GetAttribute("PlaySpeed") or 1
            track:Play(track:GetAttribute("PlayFadeTime") or 0.001, track:GetAttribute("PlayWeight") or 1, speed)
            character:SetAttribute("ParryTime", math.max(character:GetAttribute("ParryTime") or 0,
                track.Length == 0 and 1 or (track.Length - track.TimePosition) * speed))
            table.insert(sapphireBBState.GrabAnimation, track)
            played = true
        end
        return played
    end
    function A.Queue()
        if F.Destroyed or u1070.config.auto_parry_animation_fix ~= true or u1070.config.auto_parry ~= true then return false end
        local character = localPlayer.Character
        local sword = u1070.animation.get_sword_name() or "Base Sword"
        local generation = A.Generation
        if not A.Allowed(character, sword, generation) then return false end
        if A.Pending then return true end
        A.Sword = sword
        local pending = {}
        A.Pending = pending
         
        task.defer(function()
            if not A.Allowed(character, sword, generation) then
                if A.Pending == pending then A.Pending = nil end
                return
            end
            local ok, played = pcall(A.ParryAnimation, character, sword, generation)
            if A.Pending == pending then A.Pending = nil end
            if A.Generation ~= generation then return end
            if not ok or not played then
                sapphireBBState.AutoParryAnimationPlayed = nil
                local message = ok and "No parry animation could be played" or tostring(played)
                if A.LastError ~= message then warn("[Allusive Private] Auto Parry Animation Fix: " .. message) end
                A.LastError = message
            else A.LastError = nil end
        end)
        return true
    end
    function A.WatchCharacter()
        F.Disconnect("AP Animation Character Sword")
        local character = localPlayer.Character
        if character then
            connect("AP Animation Character Sword", character:GetAttributeChangedSignal("CurrentlyEquippedSword"), function()
                if A.Sword ~= (u1070.animation.get_sword_name() or "Base Sword") then A.Reset(true) end
            end)
        end
    end
    function F.SetAutoAnimation(enabled)
        if F.Destroyed then return end
        u1070.config.auto_parry_animation_fix = enabled == true
        A.Reset(false)
    end
    connect("AP Animation Player Sword", localPlayer:GetAttributeChangedSignal("CurrentlyEquippedSword"), function()
        if A.Sword ~= (u1070.animation.get_sword_name() or "Base Sword") then A.Reset(true) end
    end)
    A.WatchCharacter()
    features.Animation = {
        Keypress = function() return F.Fire("Keypress") end,
        Input = function(method) return F.Fire(method) end,
        PlayAnimation = function(_, isTriggerbot)
            if isTriggerbot then
                 
                if u1070.animation and u1070.animation.play_grab then task.spawn(u1070.animation.play_grab) end
                return true
            end
            return A.Queue()
        end
    }
    sapphireBBState.SpamParries = {}
    features.Player = {GetClosest = function()
        local char = localPlayer.Character
        local root = char and char.PrimaryPart
        if not root or not smallest then return nil end
        local best, distance = nil, math.huge
        for _, other in ipairs(smallest:GetChildren()) do
            local part = other:IsA("Model") and (other.PrimaryPart or other:FindFirstChild("HumanoidRootPart"))
            if other ~= char and part then
                local separation = (part.Position - root.Position).Magnitude
                if separation < distance then best, distance = other, separation end
            end
        end
        return best
    end}

features.Detection.UseProtection = function(line, object)
	local osClock = os.clock()

	if not (sapphireBBState.ParryCooldownUntil and osClock < sapphireBBState.ParryCooldownUntil or bottomSnapZone and bottomSnapZone.Offset.Y < 0.49) then
		sapphireBBState.ParryCooldownUntil = nil
		sapphireBBState.PreclickFired = nil
		sapphireBBState.PreclickCooldown = nil
		sapphireBBState.CooldownProtected = nil
	elseif flags.CooldownProtectionEnabled then
		if sapphireBBState.CooldownProtected then
			return true
		end

		if osClock < (sapphireBBState.ParryActiveUntil or 0) then
			return true
		end
		local result8 = features.Ball and features.Ball.GetMainBall and features.Ball.GetMainBall()
		local exponent = (result8 and (u1070.config.auto_parry == true and F.Decision.Velocity(result8) or index4(result8)) or Vector3.zero).Magnitude
		local cell = not result8 or exponent < 35
		local active

		if cell then
			active = cell
		else
			local targetPlayerName = localPlayer.Name
			active = compareFunction(result8) ~= targetPlayerName
		end

		if active then
			return true
		end

		if sapphireBBState.PreclickCooldown then
			local difference = (previous() + math.min(pingJitterMs(), 30)) / 1000
			if math.max(0, (line.PrimaryPart.Position - unexecuteFunction(result8)).Magnitude - 5) / exponent - difference > math.max(0, 0.5 - difference) then
				return true
			end
		end

		if knob and knob.Offset.Y >= 0.49 then
			sapphireBBState.CooldownProtected = true
			left:Fire()
			return true, true
		end

		return true
	end

	if object then
		return false
	end

	if flags.AutoAbilityEnabled then
		line = line and line:FindFirstChild("Abilities")

		if features.Ball and features.Ball.GetMainBall then
			features.Ball.GetMainBall()
		end

		if wrapper(line) then
			return true, true
		end
	end

	return false
end

attemptAutoParry = function(player15, line, object, descendant, radius, zCoordinate, isTriggerbot, decision)
    if decision and not F.Decision.Valid(decision) then return false end
	local model = localPlayer.Character
	if not undoFunction(model) then
		return false
	end

	if continuation(model) then
		return false
	end

	if not player15 then
		player15 = features.Ball and features.Ball.GetMainBall and features.Ball.GetMainBall()
	end

	if not player15 then
		return false
	end
	line = line or flags.AutoParryType

	if line == "Remote" then
		if features.Parry and features.Parry.Fire then
			sapphireBBState.ParryMethod = "Remote"
			local cell = not descendant

			if cell then
				local targetPlayerName = localPlayer.Name
				cell = compareFunction(player15) ~= targetPlayerName
			end

			if cell then
				return false
			end

			if index6(player15) then
				sapphireBBState.ParryMethod = "Keypress"
				if not features.Animation.Keypress() then
					return false
				end
                if decision then F.Decision.Transported(decision) end
			else
				local osClock = os.clock()

				if sapphireBBState.ParryCooldownUntil and osClock >= sapphireBBState.ParryCooldownUntil then
					sapphireBBState.AutoParryAnimationPlayed = nil
				end

				local active = not sapphireBBState.AutoParryAnimationPlayed and (not sapphireBBState.ParryCooldownUntil or osClock >= sapphireBBState.ParryCooldownUntil)
				local radians, angleRadians = features.Parry.Fire(object and features.Curve.GetCFrame() or nil)
                if decision and radians then F.Decision.Transported(decision) end
                if decision and not F.Decision.Valid(decision) then return false end
				if not radians then
					return false
				end

				if active and sapphireBBState.ParryMethod == "Remote" then
					if angleRadians or (decision and F.Decision.Animate(isTriggerbot) or not decision and features.Animation.PlayAnimation(true, isTriggerbot)) then
						sapphireBBState.AutoParryAnimationPlayed = true
					end
				end
			end
		end
	else
		local cell = not descendant

		if cell then
			local targetPlayerName = localPlayer.Name
			cell = compareFunction(player15) ~= targetPlayerName
		end

		if cell then
			return false
		end
		if not features.Animation.Input(line) then
			return false
		end
        if decision then F.Decision.Transported(decision) end
        if decision and not F.Decision.Valid(decision) then return false end
        if not isTriggerbot then
            if decision then F.Decision.Animate() else features.Animation.PlayAnimation(true) end
        end
	end

    if decision and not F.Decision.Valid(decision) then return false end
	if flags.AutoSpamEnabled then
		local osClock = os.clock()

		while sapphireBBState.SpamParries[1] and sapphireBBState.SpamParries[1] < osClock - 0.75 do
			table.remove(sapphireBBState.SpamParries, 1)
		end

		sapphireBBState.SpamParries[#sapphireBBState.SpamParries + 1] = osClock
		local cell = not descendant

		if cell then
			local targetPlayerName = localPlayer.Name
			cell = compareFunction(player15) == targetPlayerName
		end

		if cell then
			sapphireBBState.SpamBall = player15
			sapphireBBState.SpamTargetAt = osClock
		end
	end

	sapphireBBState.PreclickFired = nil
	sapphireBBState.PreclickCooldown = nil
	sapphireBBState.ParryActiveUntil = os.clock() + math.max(0, 0.5 - (radius or previous() + math.min(pingJitterMs(), 40)) / 2000)
	sapphireBBState.CooldownProtected = nil
	return true
end

 
features.Loop.MainParryLoop = function(line, job)
    if F.Destroyed or (job and (job.Generation ~= F.Decision.Generation or F.AutoJob ~= job)) then return end
    F.SyncAutoSettings()
	local graph = flags.AutoParryEnabled
	if not graph and not flags.DribbleDetection then
		return
	end
	local osClock = os.clock()
	smallest = smallest and smallest.Parent and smallest or workspace:FindFirstChild("Alive")
	local model = localPlayer.Character
	if not undoFunction(model) or not F.Decision.Alive(model) then
		return
	end

	if continuation(model) then
		return
	end
	local vehicleRoot = model.PrimaryPart
	local radians = features.Ball.GetAllBalls(true)
	if #radians == 0 then
		return
	end

	if features.Detection.UseProtection(model, true) then
		return
	end
    if job and (job.Generation ~= F.Decision.Generation or F.AutoJob ~= job) then return end
	local valueType = flags.AutoParryType
	local cell = valueType == "Remote"

	if cell then
		cell = osClock < (sapphireBBState.ExtraParryCooldownUntil or 0)
	end

	if cell then
		return
	end
	sapphireBBState.ExtraParryCooldownUntil = nil

	if top and osClock >= elapsedTime then
		top = false
		currentDate = nil
	end

    local provider = u1070.cache.adaptive_ping
    local networkSnapshot = provider and provider.Snapshot and provider.Snapshot()
    local angleRadians = networkSnapshot and networkSnapshot.CompensationPing or previous()
    local jitter = math.min(networkSnapshot and networkSnapshot.Jitter or pingJitterMs(), 40)
	local difference = (angleRadians + F.Decision.FrameBudget(osClock) * 1000) / 1000
	sapphireBBState.ParryFrameAt = osClock
	local openError = math.clamp(angleRadians / 10 + jitter / 8, 10, 16.7 + jitter / 8)
	local step = math.clamp(difference * 0.5 - 0.05 + jitter / 2000, 0, 0.04 + jitter / 2000)
	local clampedY = math.clamp(tonumber(flags.ParryRange) or 0, 0, 10)
	local currentPosition = vehicleRoot.Position
	local targetPlayerName = localPlayer.Name
	local track, vertexCount = features.Detection.BlocksParry(nil, model, vehicleRoot)
	if track then
		return
	end
	local active = #radians > 1
	local label = active and sapphireBBState.AutoBall
	local steering = nil

	if label then
		local attachment = sapphireBBState.AutoBall
		local major = managerObject[attachment]
		local isArray = graph and attachment.Parent and attachment:GetAttribute("from") == targetPlayerName
		steering = nil

		if isArray then
			steering = features.Loop.InvisDetection(model)
		end

		local bestLabel = not steering and attachment.Parent and compareFunction(attachment) == targetPlayerName

		if bestLabel then
			bestLabel = osClock < (major and major.ParryResetAt or 0)
		end

        if bestLabel and osClock < (sapphireBBState.ParryActiveUntil or (major and major.ParryResetAt) or 0) then
            return
        end
         
		sapphireBBState.AutoBall = nil
	end

    local scan = active and F.Decision.Frame(vehicleRoot, networkSnapshot) or nil
    if active and not scan then return end
    if scan then currentPosition = scan.RootPosition end
	local mathMax = 0

	if active then
		for _, weld in pairs(radians) do
            local position, velocity = F.Decision.Read(weld, scan)
            if not position then continue end
			local byte = managerObject[weld]
			local result68 = weld and compareFunction(weld)
			local splitHorizontal = byte and byte.Parried

			if splitHorizontal then
				splitHorizontal = osClock < (byte.ParryResetAt or 0)
			end

			if splitHorizontal then
				mathMax += 1
			elseif result68 == targetPlayerName and not index17(weld, result68) then
				local minX = math.huge

                local approaching, arrival = F.Decision.Rank(vehicleRoot, position, velocity, scan)
				if approaching and arrival < minX then
					mathMax += 1
				end
			end

			if not (1 < mathMax) then
				continue
			end
			break
		end
	end

	local isArray = mathMax > 1
	local major = nil
	local byte = nil
	local result68 = nil
    local abilitySelection = nil
    local abilityPriority, selectedPriority = nil, nil
	local net = nil
	local slider = nil
	local newPrice = nil
	local screenPoint = nil
	local bestLabel = nil
	local result69 = nil
	local result70 = nil
	local result71 = nil

	for _, word in pairs(radians) do
		if word and word.Parent then
             
            if flags.DribbleDetection and not F.Decision.Read(word, scan) then continue end
			local ikConstraint = index7(word)
			local result72 = compareFunction(word)

			if not index17(word, result72) then
				local result73 = nil
				local bestPair = nil

				if flags.DribbleDetection then
					result73, bestPair = features.Detection.GetSelfDribbleBall(word, vehicleRoot)
				end

				local isPinned = not result73 and graph and word:GetAttribute("from") == targetPlayerName
				local changed = false

				if isPinned then
					if steering ~= nil then
						changed = steering
					else
						changed = features.Loop.InvisDetection(model)
						steering = changed
					end
				end

				if changed then
					if ikConstraint.InvisibleReturnAway == nil then
						ikConstraint.InvisibleReturnAway = not ikConstraint.Parried
					end

					local dotProduct = (currentPosition - unexecuteFunction(word)):Dot(index4(word))
					bestPair = dotProduct > 0

					if dotProduct < 0 then
						ikConstraint.InvisibleReturnAway = true
					end

					local result14 = ikConstraint.InvisibleReturnAway

					if result14 then
						result73 = word
					else
						result73 = word
						bestPair = result14
					end
				else
					ikConstraint.InvisibleReturnAway = nil
				end

				if not (not graph and not result73) then
					if result73 and (changed and ikConstraint.InvisibleReturnAway or not changed and sapphireBBState.SelfDribbleAway) then
						ikConstraint.Parried = false
						ikConstraint.ParryResetAt = 0

						if sapphireBBState.ManualBall == word then
							sapphireBBState.ManualBall = nil
						end

						if currentDate == word then
							top = false
							currentDate = nil
							elapsedTime = 0
						end
					end

					if sapphireBBState.AutoBall == word and result72 ~= targetPlayerName then
						sapphireBBState.AutoBall = nil
					end

					if sapphireBBState.ManualBall == word then
						if result72 == targetPlayerName then
							continue
						end
						sapphireBBState.ManualBall = nil
					end

					if ikConstraint.LoopTarget ~= result72 then
                        F.Decision.Clear(ikConstraint)
                        F.Predictive.Clear(ikConstraint)
                        if currentDate == word then top, currentDate, elapsedTime = false, nil, 0 end
						ikConstraint.Parried = false
						ikConstraint.ParryResetAt = 0

						if ikConstraint.Target ~= result72 then
							if result72 == targetPlayerName then
								index13(ikConstraint)
							else
								index14(ikConstraint)
							end
						end

						ikConstraint.LoopTarget = result72

						if result72 == targetPlayerName and currentDate == word then
							top = false
							currentDate = nil
							elapsedTime = 0
						end
					end

					if result72 ~= targetPlayerName then
						ikConstraint.Parried = false
					elseif ikConstraint.Parried then
						if osClock < (ikConstraint.ParryResetAt or 0) then
							continue
						end
						ikConstraint.Parried = false
					end

					local bestChild = packed == word and word or nil

					if packed and features.Detection.GetDribbleBall(packed) ~= packed then
						if currentDate == packed then
							top = false
							currentDate = nil
							elapsedTime = 0
						end

						packed = nil
						bestChild = nil
					end

					if flags.ParryOnDribble and not packed then
						bestChild = features.Detection.GetDribbleBall(word)

						if bestChild then
							packed = bestChild
						end
					end

					if not (word:GetAttribute("DribbleActive") == true and not flags.ParryOnDribble and not result73 and result72 ~= targetPlayerName) then
						local dotProduct = bestChild or result73 or word
                        if not scan then
                            scan = F.Decision.Frame(vehicleRoot, networkSnapshot)
                            if not scan then return end
                            currentPosition = scan.RootPosition
                        end
                        local choiceVersion, choiceCycle, choiceFrom = ikConstraint.CurveVersion, ikConstraint.AutoCycleVersion, word:GetAttribute("from")
                        if dotProduct ~= word and not F.Decision.Read(word, scan) then continue end
                        local ballPosition, moveDirection, result74 = F.Decision.Read(dotProduct, scan)
                        if not result74 then continue end
						local exponent = moveDirection.Magnitude
						local index3 = dotProduct == word and result72 or compareFunction(dotProduct)
						local rayOrigin = redoFunction(dotProduct, result74, osClock) or ballPosition
						local leftChild = currentPosition - rayOrigin
						local totalTime = leftChild.Magnitude
						local endPosition = 101 - math.clamp(tonumber(flags.ParryAccuracy) or 80, 1, 100)
						local ENT = sapphireBBState.PhantomData
						local innerPlayer = sapphireBBState.PhantomTarget
						innerPlayer = innerPlayer and innerPlayer:FindFirstChild("HumanoidRootPart")
						local index31 = ENT and ENT.Name == "Phantom" and not ENT.Blatant and ENT.Type == "Spam" and innerPlayer and (currentPosition - innerPlayer.Position).Magnitude

						if flags.RandomizedParryAccuracy then
							local maximumValue = math.clamp(flags.RandomAccuracyMin or 1, 1, 100)
							endPosition = 101 - math.random(maximumValue, math.clamp(flags.RandomAccuracyMax or 100, maximumValue, 100))
						end

						if index31 and index31 > 30 then
							endPosition = 100
						elseif index31 and not ENT.Released then
							continue
						end

						local isRoblox = not result73

                        local curveBlocked = isRoblox and (flags.BackwardsAntiCurveEnabled and index11(dotProduct, moveDirection, index3, active) or index15(dotProduct, vehicleRoot, rayOrigin, moveDirection, totalTime, exponent, leftChild, index3, difference))
                        if curveBlocked and u1070.config.predictive_timing == true then F.Predictive.Clear(ikConstraint) end
                        if not curveBlocked then
							if not (result73 and not bestPair) then
								local maximumValue = math.clamp((endPosition - 1) / 99, 0, 1)
								local offsetZ = maximumValue * maximumValue * (3 - 2 * maximumValue)
								local newDenominator = 2.4 + math.clamp(exponent - 9.5, 0, 990.5) * 0.002
								local center = exponent / newDenominator * (0.75 + maximumValue * 0.43)
								local isInside = center <= 9.5
								local clampedX = isInside and math.min(openError, exponent * difference) or openError + math.min(exponent * step, 30)
								local max = clampedX + math.max(center, 9.5)
								local tMinimum

								if not (endPosition > 70) then
									tMinimum = max
								else
									local maximumLength = math.clamp((endPosition - 44) / 30, 0, 1)
									local index35 = maximumLength * maximumLength * (3 - 2 * maximumLength)
									local callbackFunction = word:GetAttribute("from")
									local offsetY = type(callbackFunction) == "string" and smallest and smallest:FindFirstChild(callbackFunction)

									if offsetY then
										offsetY = offsetY.PrimaryPart or offsetY:FindFirstChild("HumanoidRootPart")
									end

									offsetY = offsetY and (currentPosition - offsetY.Position).Magnitude
									local index36 = offsetY and math.clamp((8 - offsetY) / 3, 0, 1) or 0

									if offsetY and totalTime > offsetY + 3 then
										index36 = 0
									end

									local index37 = (isInside and math.min(openError, exponent * difference) or openError) + math.max(exponent / newDenominator * (0.75 + maximumValue * 0.2), 9.5)
									local index38 = openError + exponent / newDenominator * (1.4 + maximumValue * 0.2)
									local clampedDistance = math.clamp((exponent - 1000) / 800, 0, 1)
									local index39 = index38 + math.max(index37 - index38, 0) * clampedDistance
									tMinimum = max + (index39 + (index37 - index39) * index36 - max) * index35
								end

								local maximumLength

								if isArray and endPosition > 44 then
									maximumLength = math.max(tMinimum, max)
								else
									maximumLength = tMinimum
								end

								isInside = isInside and (openError - clampedX) * (1 - offsetZ) or 0
								local index35 = bestChild and clampedX * (1 - offsetZ * 0.5) or 0
                                    local selectedRange = clampedY
                                    if flags.RandomizedParryRange then
                                        local minimumRange = math.clamp(math.floor(tonumber(flags.RandomizedRangeMin) or 0), 0, 10)
                                        local maximumRange = math.clamp(math.floor(tonumber(flags.RandomizedRangeMax) or 10), minimumRange, 10)
                                        local cycle = ikConstraint.AutoCycleVersion or 0
                                        if ikConstraint.RandomizedRangeCycle ~= cycle then
                                            ikConstraint.RandomizedRangeCycle = cycle
                                            ikConstraint.RandomizedParryRange = math.random(minimumRange, maximumRange)
                                        end
                                        selectedRange = ikConstraint.RandomizedParryRange
                                    end
                                    local responseLead = math.clamp(exponent * 0.035, 0, 10)
								local index36 = maximumLength + selectedRange + isInside + index35 + responseLead
                                if dotProduct == word and not result73 and not bestChild and result72 == targetPlayerName and u1070.config.predictive_timing ~= true then
                                    index36 = F.Decision.TimingRadius(vehicleRoot, rayOrigin, moveDirection, index36, scan, angleRadians, step)
                                end
								local seat = flags.AutoAbilityEnabled and not result73 and result72 == targetPlayerName and totalTime <= maximumLength
								local result75 = nil
								local index58 = nil
                                local candidatePriority = 0

								if seat then
                                    local approaching
                                    approaching, result75, index58, candidatePriority = F.Decision.Rank(vehicleRoot, rayOrigin, moveDirection, scan)
                                    if not approaching then result75 = math.huge end

									if approaching and (not major or F.Decision.Prefer(candidatePriority, result75, index58, abilityPriority, major, byte)) then
                                        abilityPriority = candidatePriority
										major = result75
										byte = index58
										result68 = word
                                        abilitySelection = F.Decision.Selection(scan, word, dotProduct, ikConstraint, result72, choiceVersion, choiceCycle, choiceFrom)
									end
								end

								isRoblox = isRoblox and result72 ~= targetPlayerName and leftChild:Dot(moveDirection) > 0

								if isRoblox then
									if steering ~= nil then
										isRoblox = steering
									else
										steering = features.Loop.InvisDetection(model)
										isRoblox = steering
									end
								end

                                local timingAllowed = totalTime <= index36
                                if u1070.config.predictive_timing == true and dotProduct == word and not result73 and not bestChild and result72 == targetPlayerName then
                                    timingAllowed = F.Predictive.Evaluate(ikConstraint, word, result72, vehicleRoot, rayOrigin, moveDirection, index36,
                                        F.Predictive.Credit(exponent, step, endPosition, isArray, tMinimum, max, center), angleRadians, osClock)
                                end
                                if dotProduct == word and not result73 and not bestChild and result72 == targetPlayerName then
                                    local approaching, arrival, centerArrival, priority = F.Decision.Rank(vehicleRoot, rayOrigin, moveDirection, scan)
                                    candidatePriority = priority
                                    timingAllowed = timingAllowed and approaching
                                    if active then result75, index58 = arrival, centerArrival end
                                end
								if (isRoblox or not result73 and result72 == targetPlayerName or bestChild or bestPair) and timingAllowed and not ikConstraint.Parried and (not top or currentDate ~= word) then
									local empty = isRoblox or bestPair or not result73 and result72 == targetPlayerName

									if not empty and bestChild then
										empty = features.Detection.GetDribbleBall(bestChild) == bestChild
									end

									if empty then
										if active and not result75 then
											result75, index58 = onInputEnded(dotProduct, currentPosition, rayOrigin, moveDirection)
										end

										if not net or F.Decision.Prefer(candidatePriority, result75, index58, selectedPriority, slider, newPrice) then
											bestLabel = not not (isRoblox or bestChild or result73)
                                            selectedPriority = candidatePriority
											net = word
                                            F.Decision.Choose(scan, word, dotProduct, ikConstraint, result72, choiceVersion, choiceCycle, choiceFrom)
											slider = result75
											newPrice = index58
											screenPoint = ikConstraint
											result69 = endPosition
											result70 = bestPair
											result71 = changed
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

    local abilityUsed = result68 and F.Decision.Fresh(abilitySelection) and wrapper(vertexCount)
    if job and (job.Generation ~= F.Decision.Generation or F.AutoJob ~= job) then return end
	if abilityUsed then
		top = true
		currentDate = result68
		elapsedTime = osClock + 0.6
		return
	end

	if not net then
		return
	end
    if job and (job.Generation ~= F.Decision.Generation or F.AutoJob ~= job) then return end
    if not F.Decision.Fresh(scan) then return end
    local decision = F.Decision.Begin(net, screenPoint, model, osClock, job)
    if not F.Decision.Valid(decision) then F.Decision.Abort(decision); return end
	screenPoint.Parried = true
	screenPoint.ParryResetAt = osClock + 0.6
	screenPoint.AutoParryAt = osClock
	top = true
	currentDate = net
	elapsedTime = screenPoint.ParryResetAt
	sapphireBBState.AutoBall = net

    if not attemptAutoParry(net, valueType, nil, bestLabel, angleRadians, result69, nil, decision)
        or not F.Decision.Valid(decision) then
        F.Decision.Abort(decision)
        return
    end

    F.Decision.Finish(decision)
	if valueType == "Remote" then
		sapphireBBState.AutoParryAt = osClock
	end

	if result70 then
		if result71 then
			screenPoint.InvisibleReturnAway = false
		else
			sapphireBBState.SelfDribbleAway = false
		end
	end
end

     
    function F.ResetAutoState()
        if F.Predictive then F.Predictive.Reset() end
        if F.Decision then F.Decision.Reset() end
        top, currentDate, elapsedTime, packed = false, nil, 0, nil
        sapphireBBState.ParryFrameAt = nil
        sapphireBBState.AutoBall, sapphireBBState.ManualBall, features.Ball.Target = nil, nil, nil
        sapphireBBState.AutoParryAt, sapphireBBState.AutoParryAnimationPlayed = nil, nil
        sapphireBBState.ParryCooldownUntil, sapphireBBState.ExtraParryCooldownUntil = nil, nil
        sapphireBBState.PreclickFired, sapphireBBState.PreclickCooldown, sapphireBBState.CooldownProtected = nil, nil, nil
        sapphireBBState.SelfDribbleBall, sapphireBBState.SelfDribbleAway = nil, nil
        for _, state in pairs(managerObject) do
            state.Parried, state.ParryResetAt, state.AutoParryAt = false, 0, nil
            state.InvisibleReturnAway = nil
            state.BackwardsScore, state.BackwardsAt = nil, nil
            index14(state)
        end
    end
    function F.StepAuto(delta)
        if F.Destroyed then return end
        local ping = u1070.cache.adaptive_ping
        if ping then ping.RecordFrame(delta) end
        if u1070.config.auto_parry ~= true and not flags.DribbleDetection then
            F.Decision.ResetFrameTime()
            flags.AutoParryEnabled = false
            return
        end
        if u1070.config.predictive_timing == true then F.Predictive.Observe(delta) end
        F.Decision.ObserveFrame(delta)
        if F.AutoBusy then F.AutoPending = true; return end
        local job = {Generation = F.Decision.Generation}
        F.AutoJob, F.AutoBusy = job, true
        local ok, err = pcall(features.Loop.MainParryLoop, nil, job)
        if not ok and job.Inflight then F.Decision.Abort(job.Inflight) end
        if F.AutoJob == job then
            F.AutoJob, F.AutoBusy = nil, false
            local retry = F.AutoPending
            F.AutoPending = false
            if retry and not F.Destroyed and (u1070.config.auto_parry or flags.DribbleDetection) then F.QueueAuto() end
        end
        if not ok and os.clock() - (F.AutoErrorAt or -math.huge) > 5 then
            F.AutoErrorAt = os.clock()
            warn("[Allusive Private] Auto Parry: " .. tostring(err))
        end
    end
    F.RunAutoParry = features.Loop.MainParryLoop
    function F.QueueAuto()
        if F.Destroyed or F.AutoQueued then return end
        F.AutoQueued = true
        task.defer(function()
            F.AutoQueued = false
            if not F.Destroyed then F.StepAuto() end
        end)
    end
    function F.SetAutoEnabled(enabled)
        if F.Destroyed or F.SyncingModeUI then return end
        enabled = enabled == true
        u1070.config.auto_parry = enabled
        if not enabled then A.Reset(false) end
        local restoreTrigger = false
        if enabled and u1070.triggerbot.enabled then
            sapphireBBState.AutoParryTriggerbot = true
            sapphireBBState.TriggerbotAutoParry = nil
            if F.SetTriggerEnabled then F.SetTriggerEnabled(false) end
        elseif not enabled and sapphireBBState.AutoParryTriggerbot then
            sapphireBBState.AutoParryTriggerbot = nil
            restoreTrigger = true
        end
        F.ResetAutoState()
        F.SyncAutoSettings()
        if F.RefreshModeCard then F.RefreshModeCard("Auto Parry", enabled) end
        if restoreTrigger and F.SetTriggerEnabled then F.SetTriggerEnabled(true)
        elseif enabled then F.QueueAuto() end
    end
    function F.SetAutoLoop(mode)
        mode = mode == "PreRender" and "PreRender" or "PreSimulation"
        u1070.config.parry_loop = mode
        local signal = mode == "PreRender" and runService.PreRender or runService.PreSimulation
        connect("Auto Parry", signal, F.StepAuto)
    end
    function F.OnAutoTargetChanged(ball, state, target, old)
        F.Decision.Clear(state)
        F.Predictive.Clear(state)
        state.Parried, state.ParryResetAt = false, 0
        if sapphireBBState.ManualBall == ball then sapphireBBState.ManualBall = nil end
        if currentDate == ball then top, currentDate, elapsedTime = false, nil, 0 end
        if sapphireBBState.AutoBall == ball and target ~= localPlayer.Name then sapphireBBState.AutoBall = nil end
        if features.Ball.Target == ball and target ~= localPlayer.Name then features.Ball.Target = nil end
        if u1070.config.auto_parry and (target == localPlayer.Name or #features.Ball.GetAllBalls() > 1) then F.QueueAuto() end
    end
    function F.OnAutoFromChanged(ball, state)
        local sender = ball:GetAttribute("from")
         
        if type(sender) ~= "string" or sender == "" then return end
        local old, oldVersion = state.AutoFrom, state.AutoFromVersion
        state.AutoFrom = sender
        state.AutoFromVersion = sender == localPlayer.Name and (state.AutoCycleVersion or 0) or nil
        if F.Destroyed or u1070.config.auto_parry ~= true or compareFunction(ball) ~= localPlayer.Name then return end
        if old == localPlayer.Name and oldVersion == (state.AutoCycleVersion or 0)
            and sender ~= old then
             
             
            state.CurveVersion = (state.CurveVersion or 0) + 1
            state.CurveReference, state.CurveSource, state.CurveTargetDirection = nil, sender, index9(sender)
            state.CurveReady = true
            index13(state)
            F.OnAutoTargetChanged(ball, state, localPlayer.Name, localPlayer.Name)
        elseif state.AutoReservation and not F.Decision.SenderMatches(state.AutoReservation.From, sender, true) then
            F.QueueAuto()
        end
    end
    function F.OnAutoBallRemoved(ball)
        if F.Balls[ball] then F.Predictive.Clear(F.Balls[ball]); F.Decision.Clear(F.Balls[ball]) end
        if currentDate == ball then top, currentDate, elapsedTime = false, nil, 0 end
        if packed == ball then packed = nil end
        if sapphireBBState.AutoBall == ball then sapphireBBState.AutoBall = nil end
        if sapphireBBState.ManualBall == ball then sapphireBBState.ManualBall = nil end
        if features.Ball.Target == ball then features.Ball.Target = nil end
    end
    local function resolveParryBall(name, part, explicitName)
        local id = tostring(explicitName or name)
        local position = typeof(part) == "Instance" and part:IsA("BasePart") and part.Position
        local named, nearest, namedDistance, nearestDistance
        for _, ball in ipairs(features.Ball.GetAllBalls()) do
            local distance = position and (unexecuteFunction(ball) - position).Magnitude or 0
            if ball.Name == id and (not named or distance < namedDistance) then named, namedDistance = ball, distance end
            if position and (not nearest or distance < nearestDistance) then nearest, nearestDistance = ball, distance end
        end
        return named or nearest or features.Ball.GetMainBall()
    end
    F.RemoteCallbacks.VisualCD = function(line, active, duration)
        if not line then return end
        F.SyncAutoSettings()
        local now = os.clock()
        if active then
            sapphireBBState.ParryCooldownUntil = now + (tonumber(duration) or 1.3)
            local grace = math.clamp((previous() + math.min(pingJitterMs(), 40)) / 1000 + 0.1, 0.15, 1)
            if not (sapphireBBState.AutoBall or sapphireBBState.AutoParryAt and now - sapphireBBState.AutoParryAt <= grace)
                and not (sapphireBBState.AutoSpamParryAt and now - sapphireBBState.AutoSpamParryAt <= grace) then
                sapphireBBState.ExtraParryCooldownUntil = sapphireBBState.ParryCooldownUntil
            end
            sapphireBBState.PreclickCooldown, sapphireBBState.PreclickFired = sapphireBBState.PreclickFired or nil, nil
            sapphireBBState.ParryActiveUntil = now + math.max(0, 0.5 - (previous() + math.min(pingJitterMs(), 40)) / 2000)
            sapphireBBState.CooldownProtected = nil
        else
            sapphireBBState.ParryCooldownUntil, sapphireBBState.ExtraParryCooldownUntil = nil, nil
            sapphireBBState.AutoParryAt, sapphireBBState.AutoParryAnimationPlayed = nil, nil
            sapphireBBState.PreclickCooldown, sapphireBBState.CooldownProtected, sapphireBBState.ManualBall = nil, nil, nil
            if flags.TriggerbotEnabled then task.spawn(u1070.triggerbot.process)
            elseif flags.AutoParryEnabled then F.QueueAuto() end
        end
    end
    F.RemoteCallbacks.ParrySuccessAll = function(line, object, descendant, player, ballName)
        F.SyncAutoSettings()
        local model = localPlayer.Character
        local vehicleRoot = model and model.PrimaryPart
        if not vehicleRoot then return end
        local ball = resolveParryBall(line, object, ballName)
        if not ball then return end
        if player == localPlayer then
            local now = os.clock()
            local exactBall = false
            if u1070.config.auto_parry == true then
                local handled, identified = F.Decision.Acknowledge(line, object, ballName, now)
                if handled then
                    if not identified then return end
                    ball, exactBall = identified, true
                end
            end
            local grace = math.clamp((tonumber(previous()) or 0) / 1000 + math.min((tonumber(pingJitterMs()) or 0) / 1500, 0.04) + 0.001, 0.15, 1)
            local autoBall = not exactBall and sapphireBBState.AutoBall
            local autoState = autoBall and managerObject[autoBall]
            local recent = autoBall and autoBall.Parent and autoState and autoState.AutoParryAt and now - autoState.AutoParryAt <= grace
            if not recent then autoBall = ball end
            local state = index7(autoBall)
            local automatic = recent or state.AutoParryAt and now - state.AutoParryAt <= grace
            local manual = not automatic
            if manual then
                state.Parried, state.ParryResetAt = true, now + 0.6
                top, currentDate, elapsedTime = true, autoBall, state.ParryResetAt
            end
            state.AutoParryAt = nil
            if sapphireBBState.AutoBall == autoBall then sapphireBBState.AutoBall = nil end
            if manual and compareFunction(autoBall) == localPlayer.Name then
                sapphireBBState.ManualBall = autoBall
                if flags.TriggerbotEnabled then
                    state.TriggerbotTarget, state.TriggerbotParried = localPlayer.Name, true
                end
            end
            if automatic and flags.AutoParryEnabled and #features.Ball.GetAllBalls() > 1 then F.QueueAuto() end
            return
        end
        local velocity = index4(ball)
        local speed = velocity.Magnitude
        local offset = vehicleRoot.Position - unexecuteFunction(ball)
        local distance = offset.Magnitude
        if speed < 0.001 or distance < 0.001 then return end
        if flags.AutoParryEnabled and speed > 100 and typeof(object) == "Instance" and object.Parent and object.Parent ~= model and object.Parent.Parent == smallest and not top then
            local closest = features.Player.GetClosest()
            if closest and closest.PrimaryPart and (vehicleRoot.Position - closest.PrimaryPart.Position).Magnitude < 15
                and distance < 15 and offset.Unit:Dot(velocity.Unit) > -0.25 and index15(ball) then
                top, currentDate, elapsedTime = true, ball, os.clock() + 0.6
                if not attemptAutoParry(nil, nil, nil, nil, nil, flags.ParryAccuracy or 50) then top, currentDate = false, nil end
            end
        end
    end
     
    F.RemoteCallbacks.InfinityBall = function(_, active)
        local previousState = sapphireBBState.InfinityActive
        if active then
            if updateFunction("Infinity") then sapphireBBState.InfinityActive, sapphireBBState.InfinityParried = true, false end
        elseif previousState then
            sapphireBBState.InfinityActive = false
            if flags.InfinityDetection then task.defer(function()
                if F.Destroyed then return end
                F.SyncAutoSettings()
                if not flags.AutoParryEnabled or sapphireBBState.InfinityParried then return end
                local ball = features.Ball.GetMainBall()
                local char = localPlayer.Character
                local root = char and char.PrimaryPart
                if not ball or not root or compareFunction(ball) ~= localPlayer.Name or (unexecuteFunction(ball) - root.Position).Magnitude > 10 then return end
                local state = index7(ball)
                state.Parried, state.ParryResetAt = true, os.clock() + 0.6
                top, currentDate, elapsedTime = true, ball, state.ParryResetAt
                sapphireBBState.InfinityParried = true
                if not attemptAutoParry(ball, flags.AutoParryType, true) then
                    state.Parried, state.ParryResetAt = false, 0
                    top, currentDate, sapphireBBState.InfinityParried = false, nil, false
                end
            end) end
        end
    end
    F.SyncAutoSettings()
    F.SetAutoLoop(u1070.config.parry_loop)
    u1070.parry.process = F.StepAuto

    function F.SyncTriggerSettings()
        F.SyncAutoSettings()
        local config = u1070.triggerbot
        config.mode = u864.normalize_parry_method(config.mode)
        flags.TriggerbotType = config.mode
        flags.TriggerbotDelay = math.clamp(tonumber(config.delay) or 0, 0, 200)
        flags.TriggerbotRandomize = config.randomize == true
        local low = math.clamp(tonumber(config.delay_min) or 0, 0, 200)
        local high = math.clamp(tonumber(config.delay_max) or 200, 0, 200)
        flags.TriggerbotDelayMin, flags.TriggerbotDelayMax = math.min(low, high), math.max(low, high)
        flags.TriggerbotIgnoreSpawn = config.ignore_spawn == true
    end

features.Triggerbot = features.Triggerbot or {}

features.Triggerbot.Fire = function(line, object, descendant)
    if F.Destroyed then return false end
    F.SyncTriggerSettings()
    if not flags.TriggerbotEnabled or not line or not line.Parent or F.Balls[line] ~= object then return false end
	local osClock = os.clock()
	local cell = sapphireBBState.ManualBall == line

	if cell then
		local targetPlayerName = localPlayer.Name
		cell = compareFunction(line) == targetPlayerName
	end

	if not cell then
		cell = osClock < (sapphireBBState.ExtraParryCooldownUntil or 0)
	end

	if cell then
		return false
	end
	local result63 = {}
	object.TriggerbotParried = result63
	object.AutoParryAt = osClock
	sapphireBBState.AutoParryAt = osClock
	local underwater = attemptAutoParry(line, flags.TriggerbotType, true, descendant, nil, nil, true) == true

	if object.TriggerbotParried == result63 then
		object.TriggerbotParried = underwater
	end

	if not underwater then
		if object.AutoParryAt == osClock then
			object.AutoParryAt = nil
		end

		if sapphireBBState.AutoParryAt == osClock then
			sapphireBBState.AutoParryAt = nil
		end
	end

	return underwater
end

features.Triggerbot.TryParry = function(line, object, modulus)
    if F.Destroyed then return end
    F.SyncTriggerSettings()
	if not flags.TriggerbotEnabled or not line or not line.Parent or not object or not index5(line) then
		return
	end
	modulus = modulus or compareFunction(line)

	if object.TriggerbotTarget ~= modulus then
		if object.TriggerbotTarget and sapphireBBState.ManualBall == line then
			sapphireBBState.ManualBall = nil
		end

		object.TriggerbotTarget = modulus
		object.TriggerbotParried = false
	end

	local cell = not (modulus == localPlayer.Name)

	if cell and sapphireBBState.ManualBall == line then
		sapphireBBState.ManualBall = nil
	end

	local radians = cell and features.Detection.GetDribbleBall(line)
	if cell and not radians then
		object.TriggerbotParried = false
		return
	end

	if object.TriggerbotParried then
		return
	end
	local model = localPlayer.Character
	if not undoFunction(model) then
		return
	end

	if flags.TriggerbotIgnoreSpawn then
		local callbackFunction = line:GetAttribute("from")
		if not callbackFunction or callbackFunction == "" then
			return
		end
	end

	if features.Detection.BlocksParry(line, model) then
		return
	end
	local angleRadians, track = features.Detection.UseProtection(model)
	if angleRadians then
		object.TriggerbotParried = track == true
		return
	end
	local randomIndex = flags.TriggerbotDelay or 0

	if flags.TriggerbotRandomize then
		local substitution = flags.TriggerbotDelayMin or 0
		local insertion = flags.TriggerbotDelayMax or 200
		local remaining = math.max
		randomIndex = math.random(math.min(substitution, insertion), remaining(substitution, insertion))
	end

	if randomIndex <= 0 then
		features.Triggerbot.Fire(line, object, radians ~= nil)
		return
	end
	local result63 = {}
	object.TriggerbotParried = result63

	task.delay(randomIndex / 1000, function()
        if F.Destroyed or F.Balls[line] ~= object then return end
        F.SyncTriggerSettings()
			if object.TriggerbotParried ~= result63 then
				return
			end
			local active = radians and features.Detection.GetDribbleBall(radians) == radians
			local isArray = not flags.TriggerbotEnabled or not line.Parent or not index5(line)

			if not isArray then
				local targetPlayerName = localPlayer.Name
				isArray = compareFunction(line) ~= targetPlayerName and not active
			end

			if isArray or features.Detection.BlocksParry(line, localPlayer.Character) then
				object.TriggerbotParried = false
				return
			end
			object.TriggerbotParried = false
			features.Triggerbot.Fire(line, object, active and true or false)
		end)
end

features.Triggerbot.Update = function()
    if F.Destroyed then return end
    F.SyncTriggerSettings()
	if not flags.TriggerbotEnabled then
		return
	end

	for _, particle in features.Ball.GetAllBalls() do
		features.Triggerbot.TryParry(particle, index7(particle))
	end
end


     
    function F.ResetTriggerTokens()
        for _, state in pairs(F.Balls) do
            state.TriggerbotParried, state.TriggerbotTarget = false, nil
        end
        u1070.triggerbot.is_parrying = false
    end
    function F.StepTrigger()
        if F.Destroyed or F.TriggerBusy then return end
        F.TriggerBusy = true
        local ok, err = xpcall(features.Triggerbot.Update, debug.traceback)
        F.TriggerBusy = false
        if not ok and os.clock() - (F.TriggerErrorAt or -math.huge) > 5 then
            F.TriggerErrorAt = os.clock()
            warn("[Allusive Private] Triggerbot: " .. tostring(err))
        end
    end
    function F.RefreshModeCard(which, enabled)
        local card = F.ModeCards and F.ModeCards[which]
        if card and card._state ~= enabled and not (which == "Triggerbot" and u1070.config.is_mobile) then
            F.SyncingModeUI = true
            local ok, err = pcall(function() card:change_state(enabled) end)
            F.SyncingModeUI = false
            if not ok then warn("[Allusive Private] Mode UI: " .. tostring(err)) end
        end
        if which == "Triggerbot" then
            local panel = u1070.mobile_guis and u1070.mobile_guis.triggerbot
            if panel and panel.label then panel.label.Text = enabled and "ON" or "Trigger" end
        end
    end
    function F.SetTriggerEnabled(enabled)
        if F.Destroyed or F.SyncingModeUI then return end
        enabled = enabled == true
        if u1070.triggerbot.enabled == enabled then
            F.SyncTriggerSettings()
            return
        end
        if enabled then
            sapphireBBState.AutoParryTriggerbot = nil
            sapphireBBState.TriggerbotAutoParry = u1070.config.auto_parry or nil
            if u1070.config.auto_parry then
                u1070.config.auto_parry = false
                A.Reset(false)
                F.RefreshModeCard("Auto Parry", false)
            end
        end
        u1070.triggerbot.enabled = enabled
        F.SyncTriggerSettings()
        F.Disconnect("Triggerbot")
        u1070.triggerbot.connection = nil
        F.ResetTriggerTokens()
        if enabled then
            F.ResetAutoState()
            F.StepTrigger()
            u1070.triggerbot.connection = connect("Triggerbot", runService.PreSimulation, F.StepTrigger)
        else
            local restoreAuto = sapphireBBState.TriggerbotAutoParry
            sapphireBBState.TriggerbotAutoParry = nil
            if restoreAuto then
                u1070.config.auto_parry = true
                F.ResetAutoState()
                F.SyncAutoSettings()
                F.RefreshModeCard("Auto Parry", true)
                F.QueueAuto()
            end
        end
        F.RefreshModeCard("Triggerbot", enabled)
    end
    features.Triggerbot.SetEnabled = F.SetTriggerEnabled
    local sapphireAutoPlayState = sapphireBBState
    sapphireAutoPlayState.Loaded = true
    local newCharacter = localPlayer:FindFirstChildOfClass("PlayerGui")
    local Data
    local packages = replicatedStorage:FindFirstChild("Packages")
    local replionModule = packages and packages:FindFirstChild("Replion")
    local dataModuleOk, dataModule = pcall(function() return replionModule and require(replionModule) end)
    if dataModuleOk and dataModule and dataModule.Client then
        pcall(function() Data = dataModule.Client:WaitReplion("Data") end)
    end
    Data = Data or {Get = function() return nil end, OnChange = function() return {Disconnect = function() end} end}
    for key, value in pairs({AutoPlayEnabled = false, AutoVoteMap = false, HitFreeze = false,
        SpamJump = false, AutoPlaySmoothness = 50, AutoPlayAggressiveness = 45,
        AntiAFK = false, AutoPlayMode = "Play Edge", ShowWins = false, ShowElims = false,
        ShowRAP = false, CustomStreakEnabled = false, CustomStreak = ""}) do
        if flags[key] == nil then flags[key] = value end
    end
    local function getAutoPlayOpponent(character, position)
        local folder = smallest and smallest.Parent and smallest or workspace:FindFirstChild("Alive")
        if not folder then return math.huge, nil, 0 end
        smallest = folder
        local queue = folder:GetChildren()
        local bestDistance, bestRoot = math.huge, nil
        for _, other in ipairs(queue) do
            if other ~= character then
                local root = other:IsA("BasePart") and other or other:IsA("Model") and (other.PrimaryPart or other:FindFirstChild("HumanoidRootPart"))
                if root and root.Parent then
                    local distance = (position - root.Position).Magnitude
                    if distance < bestDistance then bestDistance, bestRoot = distance, root end
                end
            end
        end
        return bestDistance, bestRoot, #queue
    end

for key, value in pairs({CustomStreakEnabled = false, CustomStreak = "", ShowWins = false, ShowElims = false, ShowRAP = false}) do if flags[key] == nil then flags[key] = value end end
features.Streak = { Originals = {} }

features.Streak.Get = function()
	local userId = tonumber(tostring(flags.CustomStreak or ""):match("^%s*(.-)%s*$"))
	return userId and math.max(0, math.floor(userId))
end

features.Streak.Format = function(line)
	return (tostring(line):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

features.Streak.Set = function(line, object, descendant)
	if not features.Streak.Originals[line] then
		features.Streak.Originals[line] = { object, line[object] }
	end

	if line[object] ~= descendant then
		line[object] = descendant
	end
end

features.Streak.RestoreObject = function(line)
	local radians = features.Streak.Originals[line]
	if not radians then
		return
	end

	if line.Parent then
		line[radians[1]] = radians[2]
	end

	features.Streak.Originals[line] = nil
end

features.Streak.Restore = function()
	for vertex, particle in pairs(features.Streak.Originals) do
		if vertex.Parent then
			vertex[particle[1]] = particle[2]
		end
	end

	table.clear(features.Streak.Originals)
end

sapphireBBState.StreakRestore = features.Streak.Restore

features.Streak.Refresh = function(line)
	local radians = features.Streak.Originals[line]

	if radians then
		radians[2] = line[radians[1]]
	end

	coroutineFunction("Streak Display")
	coroutineFunction("Streak Value")
	coroutineFunction("Streak Flame")
	features.Streak.Value = nil
	task.defer(features.Streak.ApplyDisplay)
end

features.Streak.Profile = function()
	local result38 = newCharacter:FindFirstChild("ProfileCard")
	local objects = result38 and result38:FindFirstChild("Customize") and result38.Customize:FindFirstChild("Profile")
	local result36 = objects and objects:FindFirstChild("PlayerProfile")
	result36 = result36 and result36:FindFirstChild("Details")
	objects = objects and objects:FindFirstChild("Achievements")
	return result36 and result36:FindFirstChild("Username"), objects and objects:FindFirstChild("Scrollingframe")
end

features.Streak.ApplyDisplay = function()
	if not flags.CustomStreakEnabled then
		return
	end
	local model = localPlayer.Character
	local guiClone = model and model:FindFirstChild("WinStreakDisplay", true)

	if not guiClone and model then
		local nearestPlayer = model:FindFirstChild("Head")
		local leaderstats = replicatedStorage:FindFirstChild("Assets")
		local template = leaderstats and leaderstats:FindFirstChild("UI")
		template = template and template:FindFirstChild("WinStreakDisplay")

		if nearestPlayer and template then
			guiClone = template:Clone()
			guiClone.Adornee = nearestPlayer
			features.Streak.Display = guiClone
			guiClone.Parent = model
		end
	end

	local result22 = guiClone and guiClone:FindFirstChild("Main")
	local yString = result22 and result22:FindFirstChild("Value")
	local Lighting = result22 and result22:FindFirstChild("Icon")
	if not yString or not Lighting then
		return
	end
	local radians = features.Streak.Get()
	if not radians then
		return
	end
	local query = "<b><stroke color='rgb(0, 0, 0)' thickness='2'>" .. features.Streak.Format(radians) .. "</stroke></b>"
	local concatenated = radians >= 10 and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
	features.Streak.Set(guiClone, "Enabled", true)
	features.Streak.Set(yString, "Text", query)
	features.Streak.Set(Lighting, "Image", concatenated)

	if features.Streak.Value ~= yString then
		coroutineFunction("Streak Display")
		coroutineFunction("Streak Value")
		coroutineFunction("Streak Flame")
		features.Streak.Value = yString

		sapphireBBState.Connections["Streak Display"] = guiClone:GetPropertyChangedSignal("Enabled"):Connect(function()
				features.Streak.Refresh(guiClone)
			end)

		sapphireBBState.Connections["Streak Value"] = yString:GetPropertyChangedSignal("Text"):Connect(function()
				features.Streak.Refresh(yString)
			end)

		sapphireBBState.Connections["Streak Flame"] = Lighting:GetPropertyChangedSignal("Image"):Connect(function()
				features.Streak.Refresh(Lighting)
			end)
	end
end

features.Streak.ApplyProfile = function()
	if not flags.CustomStreakEnabled then
		return
	end
	local radians = features.Streak.Get()
	if not radians then
		return
	end
	local cell = radians > (tonumber(Data:Get("TotalStats.BestWinStreak")) or 0)
	local angleRadians = features.Streak.Format(radians)
	local objects = newCharacter:FindFirstChild("Profile")
	objects = objects and objects:FindFirstChild("BestWinStreak", true)
	objects = objects and objects:FindFirstChild("Value")

	if objects then
		if cell then
			features.Streak.Set(objects, "Text", angleRadians .. " Wins")
		else
			features.Streak.RestoreObject(objects)
		end
	end

	local track, vertexCount = features.Streak.Profile()
	if not track or track.Text ~= "@" .. localPlayer.Name or not vertexCount then
		return
	end

	for _, info in vertexCount:GetChildren() do
		local inputBox = info:FindFirstChild("Title")
		local item = info:FindFirstChild("Description")

		if inputBox and item and inputBox.Text == "Best Win Streak" then
			if cell then
				features.Streak.Set(item, "Text", angleRadians)
			else
				features.Streak.RestoreObject(item)
			end

			break
		end
	end
end

features.Streak.BindCharacter = function(line)
	coroutineFunction("Streak Character UI")

	sapphireBBState.Connections["Streak Character UI"] = line.DescendantAdded:Connect(function(hit)
			if hit.Name == "WinStreakDisplay" or hit.Name == "Value" or hit.Name == "Icon" then
				if hit.Name == "WinStreakDisplay" and features.Streak.Display and hit ~= features.Streak.Display then
					features.Streak.Display:Destroy()
					features.Streak.Display = nil
				end

				task.defer(features.Streak.ApplyDisplay)
			end
		end)

	features.Streak.ApplyDisplay()
end

features.Streak.Stop = function()
	for _, particle in pairs({
		"Streak Character",
		"Streak Character UI",
		"Streak Display",
		"Streak Value",
		"Streak Flame",
		"Streak Profile",
		"Streak Profile Items",
		"Streak Best",
	}) do
		coroutineFunction(particle)
	end

	features.Streak.Restore()
	local model = localPlayer.Character
	local splitHorizontally = features.Streak.Display and model

	if splitHorizontally then
		splitHorizontally = (tonumber(model:GetAttribute("Killstreak")) or 0) > 0
	end

	if features.Streak.Display then
		features.Streak.Display:Destroy()
		features.Streak.Display = nil
	end

	if splitHorizontally then
		firesignal(model:GetAttributeChangedSignal("Killstreak"))
	end

	features.Streak.Value = nil
end

features.Streak.Toggle = function(other)
	flags.CustomStreakEnabled = other
	features.Streak.Stop()
	if not other or not features.Streak.Get() then
		return
	end
	sapphireBBState.Connections["Streak Character"] = localPlayer.CharacterAdded:Connect(features.Streak.BindCharacter)

	sapphireBBState.Connections["Streak Best"] = Data:OnChange("TotalStats.BestWinStreak", function()
			task.defer(features.Streak.ApplyProfile)
		end)

	local radians, angleRadians = features.Streak.Profile()

	if radians then
		sapphireBBState.Connections["Streak Profile"] = radians:GetPropertyChangedSignal("Text"):Connect(features.Streak.ApplyProfile)
	end

	if angleRadians then
		sapphireBBState.Connections["Streak Profile Items"] = angleRadians.ChildAdded:Connect(function()
				task.defer(features.Streak.ApplyProfile)
			end)
	end

	if localPlayer.Character then
		features.Streak.BindCharacter(localPlayer.Character)
	end

	features.Streak.ApplyProfile()
end



features.Stats = {
	Connections = {},
	Originals = setmetatable({}, { __mode = "k" }),
	Writing = setmetatable({}, { __mode = "k" }),
	Info = {
	Wins = {
	Attribute = "PlayerWins",
	Config = "ShowWins",
	Leaderstat = "Wins",
	Profile = "Wins",
},
	Elims = {
	Attribute = "PlayerElims",
	Config = "ShowElims",
	Leaderstat = "Elims",
	Profile = "Kills",
},
	RAP = { Attribute = "TotalRAP", Config = "ShowRAP", Profile = "Rap" },
},
}

features.Stats.Connect = function(line, object)
	features.Stats.Connections[#features.Stats.Connections + 1] = line:Connect(object)
end

features.Stats.ConnectProfile = function(line, object)
	features.Stats.ProfileConnections = features.Stats.ProfileConnections or {}
	features.Stats.ProfileConnections[#features.Stats.ProfileConnections + 1] = line:Connect(object)
end

features.Stats.RestoreProfile = function()
	local neighborIterator = features.Stats.ProfileOriginal or {}

	for _, particle in pairs(neighborIterator) do
		if particle.Button.Parent then
			features.Stats.Writing[particle.Button] = true
			features.Stats.Writing[particle.Amount] = true
			particle.Button.Visible = particle.Visible
			particle.Amount.Text = particle.Text
			features.Stats.Writing[particle.Button] = nil
			features.Stats.Writing[particle.Amount] = nil
		end
	end
end

features.Stats.ClearProfile = function(line)
	local matchIterator = features.Stats.ProfileConnections or {}

	for _, particle in pairs(matchIterator) do
		particle:Disconnect()
	end

	table.clear(features.Stats.ProfileConnections or {})

	if line then
		features.Stats.RestoreProfile()
	end

	features.Stats.ProfileOriginal = nil
end

features.Stats.Stop = function()
	for _, particle in pairs(features.Stats.Connections) do
		particle:Disconnect()
	end

	table.clear(features.Stats.Connections)

	for vertex, particle in pairs(features.Stats.Originals) do
		if vertex.Parent then
			features.Stats.Writing[vertex] = true
			vertex.Value = particle
			features.Stats.Writing[vertex] = nil
		end
	end

	features.Stats.ClearProfile(true)
	table.clear(features.Stats.Originals)
end

features.Stats.SetValue = function(line, object, descendant)
	if features.Stats.Originals[descendant] ~= nil then
		return
	end
	features.Stats.Originals[descendant] = descendant.Value

	local function onInputEnded()
		local callbackFunction = line:GetAttribute(object.Attribute)

		if flags[object.Config] and features.Stats.Originals[descendant] == 0 and type(callbackFunction) == "number" and callbackFunction > 0 and descendant.Value ~= callbackFunction then
			features.Stats.Writing[descendant] = true
			descendant.Value = callbackFunction
			features.Stats.Writing[descendant] = nil
		end
	end

	features.Stats.Connect(descendant:GetPropertyChangedSignal("Value"), function()
			if features.Stats.Writing[descendant] then
				return
			end
			features.Stats.Originals[descendant] = descendant.Value
			onInputEnded()
		end)

	features.Stats.Connect(line:GetAttributeChangedSignal(object.Attribute), onInputEnded)
	onInputEnded()
end

features.Stats.BindPlayer = function(line)
	local function onInputEnded(object)
		for _, particle in pairs(features.Stats.Info) do
			if particle.Leaderstat and flags[particle.Config] then
				local angleRadians = object:FindFirstChild(particle.Leaderstat)

				if angleRadians and angleRadians:IsA("ValueBase") then
					features.Stats.SetValue(line, particle, angleRadians)
				end
			end
		end

		features.Stats.Connect(object.ChildAdded, function(descendant)
				for _, particle in pairs(features.Stats.Info) do
					if particle.Leaderstat and flags[particle.Config] and descendant.Name == particle.Leaderstat and descendant:IsA("ValueBase") then
						features.Stats.SetValue(line, particle, descendant)
						break
					end
				end
			end)
	end

	local result19 = line:FindFirstChild("leaderstats")

	if result19 then
		onInputEnded(result19)
	else
		features.Stats.Connect(line.ChildAdded, function(object)
				if object.Name == "leaderstats" then
					onInputEnded(object)
				end
			end)
	end
end

features.Stats.FormatRAP = function(line)
	local difference = 1
	local query

	if line >= 1e12 then
		query = "T"
		difference = 1e12
	elseif line >= 1e9 then
		query = "B"
		difference = 1e9
	elseif line >= 1000000 then
		query = "M"
		difference = 1000000
	else
		query = ""

		if line >= 1000 then
			query = "K"
			difference = 1000
		end
	end

	if difference == 1 then
		return tostring(math.floor(line))
	end
	local openError = math.floor(line / difference * 10) / 10
	return (openError % 1 == 0 and tostring(math.floor(openError)) or tostring(openError)) .. query .. (line > 1000 and "+" or "")
end

features.Stats.GetProfile = function()
	local result38 = newCharacter:FindFirstChild("ProfileCard")
	local playerCharacter = result38 and result38:FindFirstChild("Customize")
	local objects = playerCharacter and playerCharacter:FindFirstChild("Profile")
	objects = objects and objects:FindFirstChild("PlayerProfile")
	local elevatorModel = objects and objects:FindFirstChild("Details")
	return result38, elevatorModel and elevatorModel:FindFirstChild("Username"), objects and objects:FindFirstChild("Stats")
end

features.Stats.ShowProfile = function(line, object, descendant, radius)
	local callbackFunction = radius:GetAttribute(object.Attribute)
	if not flags[object.Config] or not descendant or descendant.Visible or type(callbackFunction) ~= "number" then
		return
	end
	features.Stats.Writing[descendant.Button] = true
	features.Stats.Writing[descendant.Amount] = true
	descendant.Button.Visible = true
	descendant.Amount.Text = line == "RAP" and features.Stats.FormatRAP(callbackFunction) or features.Streak.Format(callbackFunction)
	features.Stats.Writing[descendant.Button] = nil
	features.Stats.Writing[descendant.Amount] = nil
end

features.Stats.ApplyProfile = function()
	local radians, targetName, angleRadians = features.Stats.GetProfile()
	targetName = targetName and targetName.Text:match("^@(.+)$")
	local track = targetName and playersService:FindFirstChild(targetName)
	if not radians or not radians.Enabled or not angleRadians or not track then
		return
	end

	if not features.Stats.ProfileOriginal then
		features.Stats.ProfileOriginal = {}

		for vertex, modelName in pairs(features.Stats.Info) do
			local steering = angleRadians:FindFirstChild(modelName.Profile)
			local xCoordinate = steering and steering:FindFirstChild("Amount")

			if steering and xCoordinate then
				features.Stats.ProfileOriginal[vertex] = { Button = steering, Amount = xCoordinate, Visible = steering.Visible, Text = xCoordinate.Text }
				local major = features.Stats.ProfileOriginal[vertex]

				features.Stats.ConnectProfile(steering:GetPropertyChangedSignal("Visible"), function()
						if not features.Stats.Writing[steering] then
							major.Visible = steering.Visible
							features.Stats.ShowProfile(vertex, modelName, major, track)
						end
					end)

				features.Stats.ConnectProfile(xCoordinate:GetPropertyChangedSignal("Text"), function()
						if not features.Stats.Writing[xCoordinate] then
							major.Text = xCoordinate.Text
							features.Stats.ShowProfile(vertex, modelName, major, track)
						end
					end)
			end
		end
	end

	features.Stats.RestoreProfile()

	for vertex, modelName in pairs(features.Stats.Info) do
		features.Stats.ShowProfile(vertex, modelName, features.Stats.ProfileOriginal[vertex], track)
	end
end

features.Stats.QueueProfile = function()
	if features.Stats.ProfileQueued then
		return
	end
	features.Stats.ProfileQueued = true
	features.Stats.ClearProfile(false)

	task.defer(function()
			features.Stats.ProfileQueued = nil
			features.Stats.ApplyProfile()
		end)
end

features.Stats.Toggle = function()
	features.Stats.Stop()
	if not flags.ShowWins and not flags.ShowElims and not flags.ShowRAP then
		return
	end

	if flags.ShowWins or flags.ShowElims then
		features.Stats.Connect(playersService.PlayerAdded, features.Stats.BindPlayer)

		for _, particle in playersService:GetPlayers() do
			features.Stats.BindPlayer(particle)
		end
	end

	local radians, angleRadians = features.Stats.GetProfile()

	if radians then
		features.Stats.Connect(radians:GetPropertyChangedSignal("Enabled"), function()
				if radians.Enabled then
					features.Stats.QueueProfile()
				end
			end)
	end

	if angleRadians then
		local onTouch = features.Stats.QueueProfile
		features.Stats.Connect(angleRadians:GetPropertyChangedSignal("Text"), onTouch)
	end

	features.Stats.QueueProfile()
end

features.Stats.Queue = function()
	if features.Stats.Queued then
		return
	end
	features.Stats.Queued = true

	task.defer(function()
			features.Stats.Queued = nil
			features.Stats.Toggle()
		end)
end


features.LoadRewards = function()
	local instance5 = { Items = {} }
	features.Rewards = instance5
	local tween = replicatedStorage.Controllers
	local ffi = require(replicatedStorage.Shared.InfiniteBattlepass.InfiniteBattlepassData)
	local hullIterator = nil
	local position = nil
	local visited = nil
	local lines = {}
	local sourceTable = {}

	local function onInputEnded(...)
		local result35 = localPlayer.PlayerGui

		for _, particle in pairs({ ... }) do
			result35 = result35:FindFirstChild(particle)
			if not result35 then
				return
			end
		end

		return result35
	end

	instance5.Notify = function(line, object)
		local radians = uiElements and uiElements.toggles[line]

		if sapphireBBState.Loaded and flags[line] and radians and radians.notify and type(object) == "string" and object ~= "" then
			u864.SendNotification({title = "Rewards", text = "Got " .. object, duration = 3})
		end
	end

	local function handlePlayerRemoving(line, object, descendant, radius, zCoordinate)
		flags[line] = false
		instance5.Items[#instance5.Items + 1] = { ID = line, Name = object, Run = descendant, Interval = radius or 5, Next = 0, Notify = zCoordinate }
	end

	local function onTouched(line, object, descendant, radius, zCoordinate, alpha)
		if not object or not object.Visible or lines[object] then
			return false
		end
		local radians = getconnections
		local query = alpha or "Activated"

		for _, existingPlayer in radians(object[query]) do
			if existingPlayer.Enabled and existingPlayer.Function and getfenv(existingPlayer.Function).script == descendant then
				lines[object] = { ID = line, Check = radius, Names = zCoordinate }
				existingPlayer:Fire()
				return true
			end
		end

		return false
	end

	handlePlayerRemoving("Claim_Daily_Rewards", "Auto Claim Daily", function()
			local value = Data:Get("CurrentDailyLoginType")
			local radians = Data:Get({ "DailyLoginData", value })
			local cell = (value == "D30" or value == "Longterm") and radians and type(radians.NextClaim) == "number"

			if cell then
				local accumulator = radians.NextClaim
				cell = workspace:GetServerTimeNow() >= accumulator
			end

			if cell then
				local head = onInputEnded("DailyLogin_" .. value .. "_Rewards")

				if head then
					local active = value == "D30" and head.Page.Rewards:FindFirstChild("Day" .. radians.DaysClaimedStreak + 1, true)

					if active then
						head = active
					else
						head = value == "Longterm" and head.Frame.Claim
					end
				end

				local accumulator = radians.NextClaim

				onTouched("Claim_Daily_Rewards", head, tween.UI.DailyLoginController, function()
					return Data:Get({ "DailyLoginData", value, "NextClaim" }) ~= accumulator
				end)
			end

			local character = ffi.isEnabled() and onInputEnded("BattlepassDailyLogin", "Background", "Frame", "ScrollingFrame")

			if character then
				for _, existingPlayer in character:GetChildren() do
					if existingPlayer:GetAttribute("State") == "Claimable" then
						local userId = tonumber(existingPlayer.Day.Text:match("%d+"))

						if userId then
							onTouched("Claim_Daily_Rewards", existingPlayer.Claim, localPlayer.PlayerScripts.Client.UIBinders.BattlepassDailyLogin, function()
								return table.find(Data:Get("NewDailyLoginAwardList") or {}, userId) ~= nil
							end)
						end

						break
					end
				end
			end

			local parent = Data:Get("WelcomeBackEvent")
			local active

			if parent then
				active = workspace:GetServerTimeNow() < (parent.EventEndTime or 0)
			else
				active = parent
			end

			active = active and onInputEnded("NewWelcomeBack", "Frame", "Views", "Login", "Days")

			if active then
				for _, existingPlayer in active:GetChildren() do
					local head = existingPlayer:FindFirstChild("Claim")
					local leftIndex = head and existingPlayer.LayoutOrder

					if head and head.Visible and leftIndex <= parent.DailyLoginStreak and not parent.ClaimedDailyRewards[leftIndex] then
						onTouched("Claim_Daily_Rewards", head, tween.WelcomeBackController.EventControllers.Login, function()
							local vehicle = Data:Get("WelcomeBackEvent")
							return vehicle and vehicle.ClaimedDailyRewards[leftIndex] == true
						end, nil, "MouseButton1Click")

						break
					end
				end
			end
		end)

	handlePlayerRemoving("Claim_Playtime_Rewards", "Auto Claim Playtime", function()
			hullIterator = hullIterator or require(replicatedStorage.Common.PlaytimeRewardsInfo).Rewards
			position = position or require(replicatedStorage.Shared.Battlepass.BattlepassPlaytimeRewardsData)
			visited = visited or require(replicatedStorage.Shared.Quests)
			local humanoid = Data:Get("PlaytimeRewardsData")

			if humanoid then
				for vertex, particle in pairs(hullIterator) do
					local cell = not humanoid.ClaimedRewards[tostring(vertex)]

					if cell then
						local difference = humanoid.TimerStart + particle.Duration
						cell = workspace:GetServerTimeNow() >= difference
					end

					if cell then
						local result37 = tween.UI.PlaytimeRewardsController

						onTouched("Claim_Playtime_Rewards", onInputEnded("PlaytimeRewards", "PlaytimeRewards", "Page", "List", "RewardsList", tostring(vertex), "ClaimButton"), result37, function()
							return Data:Get({ "PlaytimeRewardsData", "ClaimedRewards", tostring(vertex) }) == true
						end)

						break
					end
				end
			end

			if ffi.isEnabled() then
				local message = Data:Get("ClaimedPlaytimeRewards") or {}

				for vertex, particle in pairs(position) do
					if particle.Seconds <= (Data:Get("SecondsPlayedToday") or 0) and not table.find(message, vertex) then
						local success = onInputEnded("BattlepassPlaytimeRewards", "PlaytimeRewards", "MainFrame", "Grid", tostring(vertex))

						onTouched("Claim_Playtime_Rewards", success and success.Claim.Claim, tween.Battlepass.BattlepassPlaytimeRewardsController, function()
							return table.find(Data:Get("ClaimedPlaytimeRewards") or {}, vertex) ~= nil
						end)

						break
					end
				end
			end

			local count = Data:Get("CurrentQuests") or {}

			for _, particle in pairs(count) do
				local cell = visited[particle]

				if cell then
					cell = (Data:Get({ "QuestStats", cell.stat }) or 0) >= cell.goal
				end

				if cell then
					cell = not table.find(Data:Get("QuestsAwarded") or {}, particle)
				end

				if cell then
					local result39 = tween.UI.QuestsController

					onTouched("Claim_Playtime_Rewards", onInputEnded("NewDailyQuests", "Holder", "Quests", particle, "Intermediate"), result39, function()
						return table.find(Data:Get("QuestsAwarded") or {}, particle) ~= nil
					end)
				end
			end
		end)

	if ffi.isEnabled() then
		handlePlayerRemoving("Claim_Battlepass_Rewards", "Auto Claim Battlepass", function()
				if not ffi.isEnabled() then
					return
				end
				local player = onInputEnded("Battlepass", "Main", "Background", "Left", "ClaimAll")
				if not player or not player.Visible or lines[player] then
					return
				end
				local status = Data:Get("InfiniteBattlepass")
				local players = {}
				local success5 = ffi.SeasonData.Rewards.getTierFromXP
				local index60 = status.Quests.XP or 0

				for k = 1, success5(index60) do
					local radians = ffi.SeasonData.Rewards.getReward(k, localPlayer)

					for _, existingPlayer in pairs({ "Free", "Premium" }) do
						if radians and radians[existingPlayer:lower()] and (existingPlayer == "Free" or status.Premium == true) and not status.Claimed[existingPlayer][tostring(k)] then
							players[#players + 1] = { existingPlayer, tostring(k) }
						end
					end
				end

				if #players == 0 then
					return
				end

				onTouched("Claim_Battlepass_Rewards", player, tween.Battlepass.BattlepassTierController, function()
					local RunService = Data:Get("InfiniteBattlepass.Claimed")

					for _, particle in pairs(players) do
						if not RunService[particle[1]][particle[2]] then
							return false
						end
					end

					return true
				end)
			end)
	end

	handlePlayerRemoving("Auto_Wheel_Spins", "Auto Spin Wheel", function()
			local index47 = Data:Get("rolls") or 0
			if index47 <= 0 then
				return
			end
			local humanoidRootPart = onInputEnded("Wheel", "Default")
			if not humanoidRootPart or humanoidRootPart:GetAttribute("Spinning") then
				return
			end
			local instance9 = humanoidRootPart.WheelMenu

			onTouched("Auto_Wheel_Spins", instance9.Button.SpinButton, humanoidRootPart.SpinWheelClient, function()
				return (Data:Get("rolls") or 0) < index47 and not humanoidRootPart:GetAttribute("Spinning")
			end, function()
				return instance9.Win.Text:match("^You won (.-)!$")
			end)
		end, 12, true)

	if ffi.isEnabled() then
		local cell = require(replicatedStorage.Shared.BattlepassUIType) == "Window"

		local function heartbeatUpdate(player17, line)
			if not ffi.isEnabled() or Data:Get("InfiniteBattlepass.UseSteps") then
				return
			end

			if os.clock() < (instance5.SpinUntil or 0) then
				return
			end
			local difference = Data:Get("InfGachaRounds" .. ffi.Season) or 0

			if line then
				local active = difference > 0 or ffi.SeasonData.Currency.Name ~= "Gold"

				if not active then
					active = Data:Get("CanPurchaseInfGachaRounds" .. ffi.Season .. "DailyExtra") ~= true
				end

				if not active then
					active = (Data:Get("InfiniteBattlepass.Currency") or 0) < 400
				end

				if active then
					return
				end
			elseif difference <= 0 then
				return
			end

			local node = cell and onInputEnded("BattlepassSpinGacha", "Main") or onInputEnded("Battlepass", "Main", "Background", "Views", "SpinGacha")
			local radians = instance5
			local angleRadians = instance5
			local track = 15
			local index52 = os.clock() + track
			radians.SpinID = player17
			angleRadians.SpinUntil = index52

			if not onTouched(player17, node and node.Background.Spin.Spin, tween.Battlepass.BattlepassSpinGachaController, function()
					local active = line and Data:Get("CanPurchaseInfGachaRounds" .. ffi.Season .. "DailyExtra") ~= true

					if not active then
						active = not line

						if active then
							active = (Data:Get("InfGachaRounds" .. ffi.Season) or 0) < difference
						end
					end

					return active
				end) then
				local vertexCount = instance5
				instance5.SpinID = nil
				vertexCount.SpinUntil = nil
			end
		end

		handlePlayerRemoving("Auto_Battlepass_Spins", "Auto Battlepass", function()
				heartbeatUpdate("Auto_Battlepass_Spins", false)
			end, 12, true)

		handlePlayerRemoving("Auto_Gold_Spin", "Auto Kraken Spin", function()
				heartbeatUpdate("Auto_Gold_Spin", true)
			end, 14, true)
	end

	instance5.Step = function()
		for vertex, particle in pairs(lines) do
			if particle.Check() then
				lines[vertex] = nil
				instance5.Notify(particle.ID, type(particle.Names) == "function" and particle.Names() or particle.Names)
			elseif not vertex.Parent then
				lines[vertex] = nil
			end
		end

		for _, particle in pairs(instance5.Items) do
			local cell = flags[particle.ID]

			if cell then
				local index41 = particle.Next
				cell = os.clock() >= index41
			end

			if cell then
				local index27 = particle.Interval
				particle.Next = os.clock() + index27

				if not pcall(particle.Run) then
					particle.Next = os.clock() + 30
				end
			end
		end
	end

	instance5.Toggle = function()
		if not sapphireBBState.Loaded then
			return
		end
		local cell = false

		for _, particle in pairs(instance5.Items) do
			if flags[particle.ID] then
				cell = true
				break
			end
		end

		if not cell then
			coroutineFunction("Rewards")
			return
		end

		if sapphireBBState.Connections.Rewards then
			return
		end
		local result41 = {}
		sapphireBBState.Connections.Rewards = result41

		result41.Results = replicatedStorage.Remote.RemoteEvent.OnClientEvent:Connect(function(line, object, descendant)
				local canUseCoyote = instance5.SpinID

				if canUseCoyote then
					local index52 = instance5.SpinUntil
					canUseCoyote = os.clock() <= index52
				end

				if canUseCoyote and type(descendant) == "table" then
					if line == "GachaSpinStartBottom" then
						local radians = sourceTable
						local result6 = {}
						local result50 = instance5.SpinID
						local moduleName = descendant.DisplayName or descendant.ItemName
						result6[1] = result50
						result6[2] = moduleName
						radians.GachaSpinEndBottom = result6
					elseif line == "GachaSpinStartTop" then
						local radians = sourceTable
						local result7 = {}
						local result50 = instance5.SpinID
						local moduleName = descendant.DisplayName or descendant.ItemName
						result7[1] = result50
						result7[2] = moduleName
						radians.GachaSpinEndTop = result7
					end
				end

				local radians = sourceTable[line]

				if radians then
					sourceTable[line] = nil
					instance5.Notify(radians[1], radians[2])
				end
			end)

		result41.Loop = task.spawn(function()
				while sapphireBBState.Loaded and sapphireBBState.Connections.Rewards == result41 do
					instance5.Step()
					task.wait(1)
				end
			end)
	end
end

pcall(features.LoadRewards)
for key, value in pairs({
	AutoPlayEnabled = false,
	AutoVoteMap = false,
	HitFreeze = false,
	SpamJump = false,
	AutoPlaySmoothness = 50,
	AutoPlayAggressiveness = 45,
	AntiAFK = false,
	AutoRejoinExecute = false,
	ScriptKey = "",
	AutoPlayMode = "Play Edge",}) do if flags[key] == nil then flags[key] = value end end

features.AFK = {}

features.AFK.Toggle = function(line)
	sapphireBBState.AFKConnections = sapphireBBState.AFKConnections or {}

	for _, particle in pairs(sapphireBBState.AFKConnections) do
		if not particle.Enabled then
			particle:Enable()
		end
	end

	table.clear(sapphireBBState.AFKConnections)
	if not line then
		return
	end

	for _, particle in getconnections(localPlayer.Idled) do
		if particle.Enabled then
			particle:Disable()
			table.insert(sapphireBBState.AFKConnections, particle)
		end
	end
end

features.AutoPlay = { Direction = 1, Voting = {} }

features.AutoPlay.Jump = function(line, object)
	if not line then
		features.AutoPlay.DoubleJumped = nil
		features.AutoPlay.JumpAt = nil
		return
	end

	local model = localPlayer.Character
	model = model and model:FindFirstChildOfClass("Humanoid")
	if not model then
		return
	end

	if model.FloorMaterial ~= Enum.Material.Air then
		model:ChangeState(Enum.HumanoidStateType.Jumping)
		features.AutoPlay.DoubleJumped = false
		features.AutoPlay.JumpAt = os.clock()
	else
		local cell = object and not features.AutoPlay.DoubleJumped

		if cell then
			cell = os.clock() - (features.AutoPlay.JumpAt or 0) >= 0.12
		end

		if cell then
			features.AutoPlay.DoubleJumped = true
			firesignal(u1056.JumpRequest)
		end
	end
end

features.AutoPlay.VoteMode = function(line)
	local RoundStateEnum = features.AutoPlay.Voting
	local bloomEffect = localPlayer.PlayerGui:FindFirstChild("voter")

	if not bloomEffect or not bloomEffect.Enabled then
		RoundStateEnum.Mode = nil
		RoundStateEnum.ModeAt = nil
		return
	end

	if RoundStateEnum.Mode ~= bloomEffect then
		RoundStateEnum.Mode = bloomEffect
		RoundStateEnum.ModeAt = line + 0.25 + math.random() * 0.5
	end

	if not RoundStateEnum.ModeAt or line < RoundStateEnum.ModeAt then
		return
	end
	RoundStateEnum.ModeAt = nil
	local toolInstance = bloomEffect:FindFirstChild("Frame")
	toolInstance = toolInstance and toolInstance:FindFirstChild("1")
	local radians = toolInstance and toolInstance:FindFirstChildWhichIsA("TextLabel", true)

	if toolInstance and radians and radians.Text == "Classic" then
		firesignal(toolInstance.Activated)
	end
end

features.AutoPlay.VoteMap = function(line, object, descendant, radius)
	local RoundStateEnum = features.AutoPlay.Voting
	local character3 = radius:FindFirstChild("GUI")
	local character5 = character3 and character3:FindFirstChild("SurfaceGui")
	local square = character5 and character5:FindFirstChild("Top")

	if not (square and square.Visible) then
		if RoundStateEnum.Map then
			RoundStateEnum.Done = true
		end

		RoundStateEnum.Map = nil
		RoundStateEnum.MapAt = nil
		RoundStateEnum.Pad = nil
		if RoundStateEnum.Done then
			object:MoveTo(descendant.Position)
			return
		end

		if not RoundStateEnum.Waiting then
			RoundStateEnum.Waiting = true
			RoundStateEnum.Moves = math.random(1, 3)
			RoundStateEnum.Move = 0
			RoundStateEnum.MoveAt = line + 0.4 + math.random()
		end

		if not RoundStateEnum.Target and RoundStateEnum.Move < RoundStateEnum.Moves and line >= RoundStateEnum.MoveAt then
			local result33 = radius:FindFirstChild("Part")
			result33 = result33 and result33.Position - descendant.Position or Vector3.zero
			local relativePosition = Vector3.new(result33.X, 0, result33.Z)

			if relativePosition.Magnitude > 0.1 then
				local directionToTarget = relativePosition.Unit
				local horizontalVelocity = Vector3.new(-directionToTarget.Z, 0, directionToTarget.X)
				RoundStateEnum.Move = RoundStateEnum.Move + 1
				local currentPosition = descendant.Position
				local cell = RoundStateEnum.Move == 1

				if cell then
					cell = 3 + math.random() * 24
				end

				local difference = currentPosition + directionToTarget * (cell or math.random() * 1.5)
				RoundStateEnum.Target = difference + horizontalVelocity * (math.random() - 0.5) * (RoundStateEnum.Move == 1 and 5 or 3)
			end
		end

		if not RoundStateEnum.Target then
			object:MoveTo(descendant.Position)
			return
		end

		if (RoundStateEnum.Target - descendant.Position).Magnitude <= 1.5 then
			RoundStateEnum.Target = nil
			RoundStateEnum.MoveAt = line + 0.5 + math.random() * 1.5
			object:MoveTo(descendant.Position)
		else
			object:MoveTo(RoundStateEnum.Target)
		end

		return
	end

	RoundStateEnum.Done = nil
	RoundStateEnum.Waiting = nil
	RoundStateEnum.Moves = nil
	RoundStateEnum.Move = nil
	RoundStateEnum.Target = nil

	if RoundStateEnum.Map ~= square or not RoundStateEnum.Pad or not RoundStateEnum.Pad.Parent then
		RoundStateEnum.Map = square
		RoundStateEnum.MapAt = line + 0.8 + math.random() * 1.7
		local gui = radius:FindFirstChild("Colliders")
		local lines = {}
		local queue = gui and gui:GetChildren() or {}

		for _, particle in pairs(queue) do
			if particle:IsA("BasePart") then
				lines[#lines + 1] = particle
			end
		end

		RoundStateEnum.Pad = #lines > 0 and lines[math.random(#lines)]
	end

	local cell = not RoundStateEnum.Pad

	if not cell then
		cell = line < (RoundStateEnum.MapAt or 0)
	end

	if cell then
		object:MoveTo(descendant.Position)
		return
	end
	local currentPosition = RoundStateEnum.Pad.Position
	object:MoveTo(Vector3.new(currentPosition.X, descendant.Position.Y, currentPosition.Z))
end

features.AutoPlay.Stop = function()
	coroutineFunction("Auto Play")
	features.AutoPlay.Jump(false)
	table.clear(features.AutoPlay.Voting)
	features.AutoPlay.Floor = nil
	features.AutoPlay.Spawn = nil
	features.AutoPlay.Map = nil
	features.AutoPlay.Mode = nil
	features.AutoPlay.Middle = nil
	features.AutoPlay.MixAt = nil
	features.AutoPlay.UpdateAt = nil
	features.AutoPlay.PressureAt = nil
	features.AutoPlay.PressureUntil = nil
	features.AutoPlay.Home = nil
	features.AutoPlay.Anchor = nil
	features.AutoPlay.AnchorAt = nil
	features.AutoPlay.EndAt = nil
	features.AutoPlay.Raycast = nil
	features.AutoPlay.LobbyTarget = nil
	features.AutoPlay.LobbySettling = nil
	features.AutoPlay.LobbyJumpAt = nil
	features.AutoPlay.LobbyJumpUntil = nil
	features.AutoPlay.LobbyDouble = nil
	features.AutoPlay.LobbyDecided = nil
	features.AutoPlay.LobbyIdle = nil
	features.AutoPlay.InMatch = nil
	features.AutoPlay.MatchHadOpponent = nil
	features.AutoPlay.WonLast = nil
	features.AutoPlay.ClashUntil = nil
	features.AutoPlay.ChaseUntil = nil
	features.AutoPlay.ClashDistance = nil
	features.AutoPlay.ClashMoveAt = nil
	features.AutoPlay.ClashTarget = nil
	features.AutoPlay.Opponent = nil
	features.AutoPlay.OpponentUntil = nil
	features.AutoPlay.LastMove = nil
	features.AutoPlay.Character = nil
end

features.AutoPlay.Step = function()
	smallest = smallest.Parent and smallest or workspace:FindFirstChild("Alive")
	local model = localPlayer.Character
	local targetHumanoid = model and model:FindFirstChildOfClass("Humanoid")
	local explosion = model and model:FindFirstChild("HumanoidRootPart")
	if not targetHumanoid or not explosion or targetHumanoid.Health <= 0 then
		features.AutoPlay.Jump(false)
		return
	end
	local osClock = os.clock()
	if osClock < (features.AutoPlay.UpdateAt or 0) then
		return
	end
	features.AutoPlay.UpdateAt = osClock + 0.066666666666666666

	if flags.AutoVoteMap then
		features.AutoPlay.VoteMode(osClock)
	end

	if model.Parent == workspace:FindFirstChild("Dead") then
		features.AutoPlay.InMatch = false
		local result49 = workspace:FindFirstChild("Spawn")
		result49 = result49 and result49:FindFirstChild("NewPlayerCounter")
		if flags.AutoVoteMap and result49 then
			features.AutoPlay.VoteMap(osClock, targetHumanoid, explosion, result49)
			return
		end

		if not features.AutoPlay.LobbyDecided then
			features.AutoPlay.LobbyDecided = true
			features.AutoPlay.LobbyIdle = features.AutoPlay.WonLast and math.random(3) ~= 1 or not features.AutoPlay.WonLast and math.random(5) == 1
		end

		if features.AutoPlay.LobbyIdle then
			features.AutoPlay.Jump(false)
			targetHumanoid:MoveTo(explosion.Position)
			return
		end

		result49 = result49 and result49:FindFirstChild("Part")
		if not result49 then
			features.AutoPlay.Jump(false)
			return
		end

		if features.AutoPlay.Character ~= model or not features.AutoPlay.LobbyTarget then
			local mouse = workspace:FindFirstChild("LobbySpawnPlate")
			mouse = mouse and mouse:FindFirstChild("DO_NOT_DELETE")
			mouse = mouse and mouse.Position - result49.Position or explosion.Position - result49.Position
			local relativePosition = Vector3.new(mouse.X, 0, mouse.Z)
			local directionToTarget = relativePosition.Magnitude > 0.001 and relativePosition.Unit or Vector3.zAxis
			local horizontalVelocity = Vector3.new(-directionToTarget.Z, 0, directionToTarget.X)
			features.AutoPlay.Character = model
			features.AutoPlay.LobbySettling = false
			features.AutoPlay.LobbyJumpAt = osClock + math.random()
			features.AutoPlay.LobbyJumpUntil = nil
			local currentLength = result49.Size.X
			features.AutoPlay.LobbyTarget = result49.Position + directionToTarget * (8 + math.random() * 10) + horizontalVelocity * (math.random() - 0.5) * currentLength * 0.65
		end

		local halfSize = features.AutoPlay.LobbyTarget
		local relativePosition = Vector3.new(halfSize.X, explosion.Position.Y, halfSize.Z)

		if (Vector3.new(relativePosition.X, 0, relativePosition.Z) - Vector3.new(explosion.Position.X, 0, explosion.Position.Z)).Magnitude > 2.5 then
			if (features.AutoPlay.LobbyJumpAt or 0) <= osClock then
				features.AutoPlay.LobbyJumpAt = osClock + 1.2 + math.random() * 2
				features.AutoPlay.LobbyJumpUntil = osClock + 0.45
				features.AutoPlay.LobbyDouble = math.random() < 0.5
			end

			features.AutoPlay.Jump(osClock < (features.AutoPlay.LobbyJumpUntil or 0), features.AutoPlay.LobbyDouble)
			targetHumanoid:MoveTo(relativePosition)
		elseif not features.AutoPlay.LobbySettling then
			local horizontalVelocity = Vector3.new(explosion.Position.X - result49.Position.X, 0, explosion.Position.Z - result49.Position.Z)
			local directionToTarget = horizontalVelocity.Magnitude > 0.1 and horizontalVelocity.Unit or Vector3.zAxis
			local moveVector = Vector3.new(-directionToTarget.Z, 0, directionToTarget.X)
			features.AutoPlay.LobbySettling = true
			local dummy = features.AutoPlay
			local currentPosition = explosion.Position
			dummy.LobbyTarget = currentPosition + moveVector * (math.random(0, 1) == 0 and -1 or 1) * (3 + math.random() * 4) + directionToTarget * (math.random() - 0.5) * 3
		else
			features.AutoPlay.Jump(false)
			targetHumanoid:MoveTo(explosion.Position)
		end

		return
	end

	if not smallest or model.Parent ~= smallest then
		features.AutoPlay.Jump(false)
		return
	end

	if not features.AutoPlay.InMatch then
		features.AutoPlay.InMatch = true
		table.clear(features.AutoPlay.Voting)
		features.AutoPlay.MatchHadOpponent = false
		features.AutoPlay.WonLast = false
		features.AutoPlay.LobbyDecided = false
		features.AutoPlay.LobbyIdle = nil
		features.AutoPlay.ClashUntil = nil
		features.AutoPlay.ChaseUntil = nil
		features.AutoPlay.ClashDistance = nil
		features.AutoPlay.ClashMoveAt = nil
		features.AutoPlay.ClashTarget = nil
		features.AutoPlay.Opponent = nil
		features.AutoPlay.OpponentUntil = nil
		features.AutoPlay.LastMove = nil
		features.AutoPlay.Home = nil
		features.AutoPlay.Anchor = nil
		features.AutoPlay.AnchorAt = nil
		features.AutoPlay.EndAt = nil
	end

	local radians, angleRadians, track = getAutoPlayOpponent(model, explosion.Position)
	local player8 = features.AutoPlay.Opponent
	local checkpointFolder = player8 and player8.Parent

	if checkpointFolder then
		checkpointFolder = osClock < (features.AutoPlay.OpponentUntil or 0)
	end

	if checkpointFolder then
		local exponent = (explosion.Position - player8.Position).Magnitude

		if exponent <= radians + 2.5 then
			angleRadians = player8
			radians = exponent
		end
	end

	if angleRadians ~= features.AutoPlay.Opponent then
		features.AutoPlay.Opponent = angleRadians
		features.AutoPlay.OpponentUntil = osClock + 0.65
	end

	if track > 1 then
		features.AutoPlay.MatchHadOpponent = true
	elseif features.AutoPlay.MatchHadOpponent then
		features.AutoPlay.WonLast = true
	end

	if track <= 1 then
		features.AutoPlay.EndAt = features.AutoPlay.EndAt or osClock + 0.5 + math.random() * 0.7

		if features.AutoPlay.EndAt <= osClock then
			features.AutoPlay.Jump(false)
			targetHumanoid:MoveTo(explosion.Position)
			return
		end
	else
		features.AutoPlay.EndAt = nil
	end

	features.AutoPlay.Character = model
	features.AutoPlay.LobbyTarget = nil
	features.AutoPlay.LobbySettling = nil
	features.AutoPlay.Jump(flags.SpamJump, true)
	local result24 = workspace:FindFirstChild("Map")

	if features.AutoPlay.Map ~= result24 or features.AutoPlay.Mode ~= flags.AutoPlayMode or not features.AutoPlay.Floor or not features.AutoPlay.Floor.Parent then
		features.AutoPlay.Map = result24
		features.AutoPlay.Mode = flags.AutoPlayMode
		features.AutoPlay.Floor = result24 and result24:FindFirstChild("FLOOR", true)
		features.AutoPlay.Spawn = flags.AutoPlayMode ~= "Play Edge" and result24 and result24:FindFirstChild("BALLSPAWN", true)
		features.AutoPlay.Raycast = nil
		features.AutoPlay.Home = nil
		features.AutoPlay.Anchor = nil

		if features.AutoPlay.Floor then
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Include
			raycastParams.FilterDescendantsInstances = { features.AutoPlay.Floor:FindFirstAncestorOfClass("Model") or result24 }
			raycastParams.RespectCanCollide = true
			raycastParams.IgnoreWater = true
			features.AutoPlay.Raycast = raycastParams
		end
	end

	local titleLabel = features.AutoPlay.Floor
	if not titleLabel or not titleLabel:IsA("BasePart") then
		return
	end
	local difference = previous() / 1000
	local result27 = features.AutoPlay.Middle
	local IsFiveM = flags.AutoPlayMode == "Play Middle"

	if flags.AutoPlayMode == "Mix" then
		local cell = features.AutoPlay.Middle == nil

		if not cell then
			cell = osClock >= (features.AutoPlay.MixAt or 0)
		end

		if cell then
			local openError = track <= 2 and 0.8

			if not openError then
				openError = math.clamp(0.55 - difference * 2 - math.max(track - 24, 0) * 0.04 + ((not angleRadians or radians > 28) and 0.12 or 0), 0.35, 0.75)
			end

			features.AutoPlay.Middle = math.random() < openError
			features.AutoPlay.MixAt = osClock + 4 + math.random() * 4
		end

		IsFiveM = features.AutoPlay.Middle
	end

	if result27 ~= IsFiveM then
		features.AutoPlay.Middle = IsFiveM
		features.AutoPlay.Home = nil
		features.AutoPlay.Anchor = nil
	end

	local result49 = features.AutoPlay.Spawn
	result49 = IsFiveM and result49 and result49:IsA("BasePart") and result49 or titleLabel
	local relativePosition = Vector3.new(result49.Position.X, explosion.Position.Y, result49.Position.Z)
	local horizontalVelocity = Vector3.new(explosion.Position.X - relativePosition.X, 0, explosion.Position.Z - relativePosition.Z)
	local directionToTarget = horizontalVelocity.Magnitude > 1 and horizontalVelocity.Unit or Vector3.xAxis
	local openError = IsFiveM and math.max(result49.Size.X, result49.Size.Z) or 0
	local step = math.min(titleLabel.Size.X, titleLabel.Size.Z) * (IsFiveM and 0.13 or 0.31)
	local mathMax = IsFiveM and math.max(openError * 0.75, targetHumanoid.WalkSpeed * 0.45) or 0
	local t = features.AutoPlay.Direction
	local leftChild = Vector3.new(-directionToTarget.Z, 0, directionToTarget.X) * t
	local endPosition = relativePosition + directionToTarget * step
	local maximumValue = math.clamp((flags.AutoPlayAggressiveness or nil) / 100, 0.01, 1)
	local offsetZ = (18 + targetHumanoid.WalkSpeed * difference * (8 + math.min(math.max(track - 2, 0), 4))) * (1 + (0.45 - maximumValue) * (maximumValue > 0.45 and 1.18 or 0.5))
	local cell = angleRadians and radians < offsetZ

	if not features.AutoPlay.Home then
		local dummy = features.AutoPlay
		local newDenominator = targetHumanoid.WalkSpeed * 0.5
		dummy.Home = math.abs(horizontalVelocity.Magnitude - step) > newDenominator and endPosition or explosion.Position
		features.AutoPlay.Anchor = features.AutoPlay.Home
		features.AutoPlay.AnchorAt = osClock
	end

	local moveVector

	if cell then
		local newDenominator = explosion.Position - angleRadians.Position
		local newDirection = Vector3.new(newDenominator.X, 0, newDenominator.Z)
		moveVector = nil

		if newDirection.Magnitude > 0.1 then
			local deltaZ = features.AutoPlay.Direction
			local directionVector = (newDirection.Unit + Vector3.new(-newDirection.Unit.Z, 0, newDirection.Unit.X) * deltaZ * 0.55).Unit
			local center = math.min(offsetZ - radians + targetHumanoid.WalkSpeed * 0.25, targetHumanoid.WalkSpeed)
			local screenPosition = explosion.Position + directionVector * center
			local edgeVector = Vector3.new(screenPosition.X - relativePosition.X, 0, screenPosition.Z - relativePosition.Z)
			local clampedX = step + targetHumanoid.WalkSpeed * 0.45

			if clampedX < edgeVector.Magnitude then
				local max = edgeVector.Unit * clampedX
				screenPosition = Vector3.new(relativePosition.X, explosion.Position.Y, relativePosition.Z) + max
			elseif IsFiveM and edgeVector.Magnitude < mathMax then
				screenPosition = relativePosition + (edgeVector.Magnitude > 0.001 and edgeVector.Unit or directionToTarget) * mathMax
			end

			local max = screenPosition - explosion.Position
			moveVector = Vector3.new(max.X, 0, max.Z)

			if moveVector.Magnitude < 1 then
				moveVector = (leftChild - directionToTarget * 0.4).Unit * center
				screenPosition = explosion.Position + moveVector
			end

			features.AutoPlay.Home = screenPosition
			features.AutoPlay.Anchor = features.AutoPlay.Home
		end
	else
		local direction = features.AutoPlay.Anchor or explosion.Position
		local active = (Vector3.new(direction.X, 0, direction.Z) - Vector3.new(explosion.Position.X, 0, explosion.Position.Z)).Magnitude < 1.5

		if not active then
			active = osClock >= (features.AutoPlay.AnchorAt or 0)
		end

		moveVector = nil

		if active then
			if math.random() < 0.4 then
				features.AutoPlay.Direction = -features.AutoPlay.Direction
				leftChild = -leftChild
			end

			features.AutoPlay.AnchorAt = osClock + 0.6 + math.random() * 0.8
			local originalWalkSpeed = targetHumanoid.WalkSpeed
			features.AutoPlay.Anchor = features.AutoPlay.Home + leftChild * targetHumanoid.WalkSpeed * (0.2 + math.random() * 0.25) + directionToTarget * (math.random() - 0.5) * originalWalkSpeed * 0.25
			moveVector = nil
		end
	end

	local newDenominator = (features.AutoPlay.Anchor or features.AutoPlay.Home) - explosion.Position
	local newDirection = Vector3.new(newDenominator.X, 0, newDenominator.Z)
	local directionVector = newDirection.Magnitude > 2 and newDirection.Unit or Vector3.zero
	local active = osClock >= (sapphireBBState.ParryActiveUntil or 0)

	if active then
		active = osClock < (sapphireBBState.ParryCooldownUntil or 0)
	end

	local aimDirection = nil
	local axis = nil

	if not continuation(model) then
		aimDirection = nil
		axis = nil

		for _, modelName in features.Ball.GetAllBalls() do
			local steering = index7(modelName)
			local exponent = index4(modelName).Magnitude
			local targetPlayerName = localPlayer.Name
			local isArray = compareFunction(modelName) == targetPlayerName
			local isFiveM = flags.HitFreeze and isArray

			if isFiveM then
				isFiveM = modelName:GetAttribute("Frozen") == true
			end

			if isArray and active then
				local center = explosion.Position - unexecuteFunction(modelName)
				local edgeVector = Vector3.new(center.X, 0, center.Z)

				if edgeVector.Magnitude > 0.1 then
					aimDirection = edgeVector.Unit
					axis = nil
					break
				else
					aimDirection = nil
					axis = nil
				end
			else
				if isArray then
					isArray = (steering.TargetChanges or 0) <= 1 and exponent <= targetHumanoid.WalkSpeed or isFiveM
				end

				if isArray then
					local currentPosition = explosion.Position
					local center = unexecuteFunction(modelName) - currentPosition
					local edgeVector = Vector3.new(center.X, 0, center.Z)

					if not (edgeVector.Magnitude > 0.1) then
						aimDirection = nil
						axis = nil
					else
						axis = edgeVector.Unit
						aimDirection = nil
						break
					end
				else
					aimDirection = nil
					axis = nil
				end
			end
		end
	end

	if angleRadians and not aimDirection then
		local center = math.clamp((offsetZ - radians) / offsetZ, 0, 1)

		if center > 0 and moveVector and moveVector.Magnitude > 0.001 then
			directionVector = directionVector:Lerp(moveVector.Unit, center)
		end

		local clampedX = math.clamp(math.clamp(1 - difference / 0.001, 0, 1) * (0.6 + maximumValue * 0.4) + maximumValue * 0.25 + math.max(maximumValue - 0.45, 0) * 0.5, 0, 1)

		if (features.AutoPlay.PressureAt or 0) <= osClock then
			local max = math.clamp(maximumValue / 0.45, 0.65, 2)
			local endIndex = math.min
			local tMinimum = track == 2 and 0.3 + clampedX * 0.35 or clampedX * 0.45
			local vertexCount = 1
			local steering = endIndex(tMinimum * math.clamp(max, 0.55, 1.8), vertexCount)
			features.AutoPlay.PressureAt = osClock + ((track == 2 and 2.5 or 3) + math.random() * 3) / max
			features.AutoPlay.PressureUntil = math.random() < steering and osClock + (0.65 + math.random() * 0.55) * math.clamp(max, 0.75, 1.5) or 0
		end

		local isArray = center == 0

		if isArray then
			isArray = osClock < (features.AutoPlay.PressureUntil or 0)
		end

		if isArray and radians < offsetZ * (2 + maximumValue) then
			local max = angleRadians.Position - explosion.Position
			directionVector = directionVector:Lerp(Vector3.new(max.X, 0, max.Z).Unit, 0.35 + clampedX * 0.2)
		end

		if track == 2 then
			local parts = flags.AutoSpamEnabled

			if parts then
				parts = osClock - (sapphireBBState.AutoSpamAt or 0) < 0.2
			end

			if not parts then
				parts = flags.ManualSpamEnabled

				if parts then
					parts = osClock - (sapphireBBState.ManualSpamAt or 0) < 0.2
				end
			end

			if parts then
				local bestLabel = osClock >= (features.AutoPlay.ClashUntil or 0)
				features.AutoPlay.ClashUntil = osClock + 0.4

				if not bestLabel and features.AutoPlay.ClashDistance and radians > features.AutoPlay.ClashDistance + 0.3 then
					features.AutoPlay.ChaseUntil = osClock + 0.9
				end

				if bestLabel then
					features.AutoPlay.ClashMoveAt = nil
					features.AutoPlay.ClashTarget = nil
				end

				features.AutoPlay.ClashDistance = radians
			end

			if osClock < (features.AutoPlay.ClashUntil or 0) then
				local max = angleRadians.Position - explosion.Position
				local edgeVector = Vector3.new(max.X, 0, max.Z)
				local bestLabel = edgeVector.Magnitude > 0.1

				if bestLabel then
					bestLabel = radians > 9

					if not bestLabel then
						bestLabel = osClock < (features.AutoPlay.ChaseUntil or 0)
					end
				end

				if bestLabel then
					local currentPosition = angleRadians.Position
					IsFiveM = IsFiveM and horizontalVelocity.Magnitude < mathMax + 12 and edgeVector.Unit:Dot(directionToTarget) < 0

					if IsFiveM then
						currentPosition = explosion.Position + (leftChild + directionToTarget * 0.25).Unit * 14
					end

					targetHumanoid:MoveTo(currentPosition)
				else
					if (features.AutoPlay.ClashMoveAt or 0) <= osClock then
						features.AutoPlay.ClashMoveAt = osClock + 0.35 + math.random() * 0.5
						features.AutoPlay.ClashTarget = explosion.Position + (edgeVector.Magnitude > 0.1 and Vector3.new(-edgeVector.Z, 0, edgeVector.X).Unit or Vector3.zero) * (math.random(3) == 1 and math.random(-2, 2) or 0)
					end

					targetHumanoid:MoveTo(features.AutoPlay.ClashTarget or explosion.Position)
				end

				return
			end
		end
	end

	if aimDirection then
		directionVector = aimDirection
	elseif axis then
		directionVector = (axis * 0.9 + leftChild * 0.1).Unit
	end

	if directionVector.Magnitude > 0.1 then
		local surfaceNormal = directionVector.Unit

		if IsFiveM and horizontalVelocity.Magnitude < mathMax + 12 and surfaceNormal:Dot(directionToTarget) < 0 then
			surfaceNormal = (leftChild + directionToTarget * 0.25).Unit
		end

		local raycastResult = features.AutoPlay.Raycast and workspace:Raycast(explosion.Position, surfaceNormal * 12, features.AutoPlay.Raycast)

		if raycastResult then
			local edgeVector = Vector3.new(raycastResult.Normal.X, 0, raycastResult.Normal.Z)

			if 0.001 < edgeVector.Magnitude then
				local finalDirection = edgeVector.Unit
				local range = Vector3.new(-finalDirection.Z, 0, finalDirection.X)

				if range:Dot(surfaceNormal) < 0 then
					range = -range
				end

				surfaceNormal = (range + finalDirection * 0.35).Unit
			end
		end

		if not axis and not aimDirection and features.AutoPlay.LastMove and features.AutoPlay.LastMove:Dot(surfaceNormal) > -0.6 then
			local deepCopyTable = math.clamp
			local currentQuantity = flags.AutoPlaySmoothness or 50
			local vertexCount = 1
			local center = 0.82 - (deepCopyTable(currentQuantity, 1, 100) - vertexCount) / 99 * 0.48

			if cell then
				center = math.min(center + 0.18, 0.9)
			end

			local steering = features.AutoPlay.LastMove:Lerp(surfaceNormal, center)

			if 0.001 < steering.Magnitude then
				surfaceNormal = steering.Unit
			end
		end

		features.AutoPlay.LastMove = surfaceNormal
		targetHumanoid:MoveTo(explosion.Position + surfaceNormal * 12)
	else
		features.AutoPlay.LastMove = nil
		targetHumanoid:MoveTo(explosion.Position)
	end
end

    features.AutoPlay.Toggle = function(enabled)
        flags.AutoPlayEnabled = enabled == true
        features.AutoPlay.Stop()
        if enabled then
            sapphireBBState.Connections["Auto Play"] = runService.PreSimulation:Connect(features.AutoPlay.Step)
        end
    end

    F.AutoPlay, F.AFK = features.AutoPlay, features.AFK
    F.Rewards, F.Stats, F.Streak = features.Rewards, features.Stats, features.Streak

    function F.SetTriggerOption(key, value)
        if F.Destroyed then return end
        local config = u1070.triggerbot
        if key == "mode" then
            config.mode = u864.normalize_parry_method(value)
        elseif key == "delay" then
            config.delay = math.clamp(math.floor((tonumber(value) or 0) + 0.5), 0, 200)
        elseif key == "randomize" then config.randomize = value == true
        elseif key == "delay_min" or key == "delay_max" then
            config[key] = math.clamp(math.floor((tonumber(value) or 0) + 0.5), 0, 200)
        elseif key == "ignore_spawn" then config.ignore_spawn = value == true
        else return end
        F.SyncTriggerSettings()
    end
    function F.OnTriggerTargetChanged(ball, state, target)
        if F.Destroyed then return end
        F.SyncTriggerSettings()
        if flags.TriggerbotEnabled then features.Triggerbot.TryParry(ball, state, target) end
    end
    function F.OnTriggerBallAvailable(ball)
        if F.Destroyed then return end
        F.SyncTriggerSettings()
        if flags.TriggerbotEnabled then features.Triggerbot.TryParry(ball, index7(ball)) end
    end
    do
    local function initializeDeathPreclick()
     
     
    local C = {Queue = {}, Connections = {}, Revision = 0, Active = false}
    F.PreclickAll = C
    local function enabled()
        return not F.Destroyed and u1070.config.kill_pre_click == true and u1070.config.preclick_for_all == true
    end
    local function characterReady()
        local character = localPlayer.Character
        local root = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 or character.Parent ~= workspace:FindFirstChild("Alive")
            or continuation(character) or character:GetAttribute("DEATH_SLASH_STANCE")
            or character:GetAttribute("IsRagingDeflection") or character:GetAttribute("IsRapture")
            or updateFunction("Infinity") or updateFunction("Forcefield") then return nil end
        return character
    end
    local function victimCharacter(value)
        if typeof(value) == "Instance" then
            if value:IsA("Player") then return value.Character end
            if value:IsA("Model") then return value end
            return value:FindFirstAncestorWhichIsA("Model")
        end
        if type(value) == "string" then
            local player = playersService:FindFirstChild(value)
            local alive = workspace:FindFirstChild("Alive")
            return player and player.Character or alive and alive:FindFirstChild(value)
        end
    end
    local function speedOf(ball)
        local ok, velocity = pcall(index4, ball)
        if ok and typeof(velocity) == "Vector3" then
            local speed = velocity.Magnitude
            if speed == speed and speed < math.huge then return speed end
        end
        return 0
    end
    local function currentSpeed()
        local fastest = 0
        local ok, records = pcall(u1070.ball.get_all)
        if ok and type(records) == "table" then
            for _, record in ipairs(records) do fastest = math.max(fastest, speedOf(record.model or record.part)) end
        end
        return fastest
    end
    function C.Stop()
        C.Revision += 1
        C.Active = false
        F.Disconnect("Preclick For All Queue")
        for _, connection in ipairs(C.Connections) do connection:Disconnect() end
        table.clear(C.Connections)
        table.clear(C.Queue)
        C.Lives = setmetatable({}, {__mode = "k"})
        C.Players = setmetatable({}, {__mode = "k"})
        C.Characters = setmetatable({}, {__mode = "k"})
        C.Folders = setmetatable({}, {__mode = "k"})
        C.VFXConnected = false
    end
    local function listen(signal, callback)
        if not signal then return end
        local revision = C.Revision
        local connection = signal:Connect(function(...)
            if revision == C.Revision and enabled() then callback(...) end
        end)
        table.insert(C.Connections, connection)
        return connection
    end
    local function flush()
        if not enabled() then C.Stop(); return end
        for i = #C.Queue, 1, -1 do
            local entry = C.Queue[i]
            if os.clock() >= entry.FireAt then
                table.remove(C.Queue, i)
                local threshold = tonumber(u1070.config.kill_pre_click_speed) or 1
                if characterReady() == entry.Character and (threshold <= 1 or entry.Speed >= threshold) then
                    local previous = sapphireBBState.PreclickFired
                    sapphireBBState.PreclickFired = true
                    if not pcall(u1070.parry.execute) then sapphireBBState.PreclickFired = previous end
                end
            end
        end
        if #C.Queue == 0 then F.Disconnect("Preclick For All Queue") end
    end
    function C.OnDeath(victim, ball)
        if not enabled() or not C.Active then return end
        local character = characterReady()
        victim = victimCharacter(victim)
        if not character or not victim or victim == character or victim.Name == localPlayer.Name then return end
        local humanoid = victim:FindFirstChildOfClass("Humanoid")
        local life = C.Lives[victim]
        if not life or humanoid and life.Humanoid ~= humanoid then
            life = {Humanoid = humanoid}; C.Lives[victim] = life
        end
         
        if life.Queued then return end
        local speed = ball and speedOf(ball) or currentSpeed()
        local threshold = tonumber(u1070.config.kill_pre_click_speed) or 1
        if threshold > 1 and speed < threshold then return end
        life.Queued = true
        table.insert(C.Queue, {FireAt = os.clock() + 0.135, Character = character, Speed = speed})
        if not F.Connections["Preclick For All Queue"] then connect("Preclick For All Queue", runService.Heartbeat, flush) end
    end
    function C.OnVFX(_, _, ball, victim, _, killed)
         
        if killed == true then C.OnDeath(victim, ball) end
    end
    local function watchCharacter(character)
        if not character or C.Characters[character] then return end
        C.Characters[character] = true
        local function watchHumanoid(humanoid)
            if not humanoid:IsA("Humanoid") then return end
            local existing = C.Lives[character]
            if existing and existing.Humanoid == humanoid and existing.Watched then return end
            local life = existing and existing.Humanoid == humanoid and existing or {Humanoid = humanoid}
            life.Watched, life.Health = true, humanoid.Health
            C.Lives[character] = life
            listen(humanoid.Died, function()
                if character == localPlayer.Character then
                    table.clear(C.Queue); F.Disconnect("Preclick For All Queue")
                else C.OnDeath(character) end
            end)
            listen(humanoid.HealthChanged, function(health)
                if life.Health <= 0 and health > 0 then life.Queued = nil end
                life.Health = health
            end)
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then watchHumanoid(humanoid) end
        listen(character.ChildAdded, watchHumanoid)
    end
    local function watchPlayer(player)
        if C.Players[player] then return end
        C.Players[player] = true
        if player.Character then watchCharacter(player.Character) end
        listen(player.CharacterAdded, function(character)
            if player == localPlayer then table.clear(C.Queue); F.Disconnect("Preclick For All Queue") end
            watchCharacter(character)
        end)
    end
    local function watchFolder(folder)
        if folder.Name ~= "Alive" or C.Folders[folder] then return end
        C.Folders[folder] = true
        for _, character in ipairs(folder:GetChildren()) do
            if character:IsA("Model") then watchCharacter(character) end
        end
        listen(folder.ChildAdded, function(character) if character:IsA("Model") then watchCharacter(character) end end)
    end
    function C.HandlesKilled()
         
        return enabled() and C.Active
    end
    function C.Sync()
        C.Stop()
        if not enabled() then return end
        C.Active = true
        for _, player in ipairs(playersService:GetPlayers()) do watchPlayer(player) end
        listen(playersService.PlayerAdded, watchPlayer)
        for _, folder in ipairs(workspace:GetChildren()) do watchFolder(folder) end
        listen(workspace.ChildAdded, watchFolder)
         
        local revision = C.Revision
        local ok, remote = pcall(function()
            local controllers = replicatedStorage:FindFirstChild("Controllers")
            local module = controllers and controllers:FindFirstChild("VFXController")
            local upvalues = getupvalues or (debug and debug.getupvalues)
            if not module or type(upvalues) ~= "function" then return nil end
            local controller = require(module)
            for _, value in pairs(upvalues(controller.Start)) do
                if typeof(value) == "Instance" and value:IsA("RemoteEvent") then return value end
            end
        end)
        if revision ~= C.Revision or not enabled() then return end
        if ok and remote then C.VFXConnected = listen(remote.OnClientEvent, C.OnVFX) ~= nil end
    end
    end
    initializeDeathPreclick()
    end

    F.Triggerbot = features.Triggerbot
    u1070.triggerbot.process = F.StepTrigger
    u1070.triggerbot.set = F.SetTriggerEnabled
    F.SyncTriggerSettings()

    for _, instance in replicatedStorage:GetDescendants() do bindEvent(instance) end
    connect("RemoteAdded", replicatedStorage.DescendantAdded, bindEvent)
    for _, folder in workspace:GetChildren() do
        if folder.Name == "Balls" or folder.Name == "TrainingBalls" then watchFolder(folder) end
    end
    connect("FolderAdded", workspace.ChildAdded, function(folder)
        if folder.Name == "Balls" or folder.Name == "TrainingBalls" then watchFolder(folder) end
    end)
    connect("Character", localPlayer.CharacterAdded, resetCharacter)
    connect("Input", u1056.InputBegan, function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.Q then detectFuryAbility() end
    end)
    connect("LightingAdded", Workspace.ChildAdded, lightingChild)
    for _, child in Workspace:GetChildren() do lightingChild(child) end
    connect("PhantomLoop", runService.Heartbeat, F.UpdatePhantom)
    if u839 then connect("Cleanup", u839.Destroying, F.Destroy) end
     
    u1070.ball.get_targeted = F.GetTargets
    u1070.ball.is_curved = F.IsCurved
    u1070.ball.check_tornado = F.CheckTornado
end

 
do
    local F = u1070.sapphire
    local M = {Features = {}, Flags = F.Flags, Loaders = {}, Loaded = {}, Errors = {},
        Tasks = setmetatable({}, {__mode = "k"}), Ready = false, Desired = false, Revision = 0}
    u1070.sapphire_misc = M
    local features, flags = M.Features, M.Flags
    local localPlayer, playersService, replicatedStorage, runService = u1061, u1054, u1057, u1055
    local httpService, teleportService = game:GetService("HttpService"), game:GetService("TeleportService")
    local newCharacter = localPlayer:FindFirstChildOfClass("PlayerGui")
    local globalEnvironment = type(getgenv) == "function" and getgenv() or _G
    local configData = u864._config
    local saved = type(configData.UnlockAll) == "table" and configData.UnlockAll or {}
    flags.UnlockAllEnabled, flags.DeviceSpoofType = false, "PC"
    flags.UnlockAllSword, flags.UnlockAllExplosion = saved.Sword or "", saved.Explosion or ""
    flags.UnlockAllEmotes, flags.UnlockAllFinishers = saved.Emotes or {}, saved.Finishers or {}
    flags.UnlockAllAccessory, flags.UnlockAllFavorites = saved.Accessory == true, saved.Favorites or {}
    local function saveConfig() u867:save(game.GameId, u864._config) end
    local function notify(text)
        if not M.Destroyed then u864.SendNotification({title = "Allusive Private", text = text, duration = 6}) end
    end
    M.Notify = notify
    local window = {Notify = function(_, data) notify(data.Title or data.Text or "") end}
    local function cleanupResources(value, seen)
        if value == nil then return end
        if typeof(value) == "RBXScriptConnection" then pcall(function() value:Disconnect() end)
        elseif type(value) == "thread" then
            if value ~= coroutine.running() and coroutine.status(value) ~= "dead" then pcall(task.cancel, value) end
        elseif type(value) == "table" then
            if type(value.Disconnect) == "function" then pcall(value.Disconnect, value); return end
            seen = seen or {}; if seen[value] then return end; seen[value] = true
            for _, child in pairs(value) do cleanupResources(child, seen) end
        end
    end
    function M.Try(name, fn, ...)
        local ok, result = pcall(fn, ...)
        if ok then M.Errors[name] = nil; return true, result end
        if M.Errors[name] ~= tostring(result) then
            M.Errors[name] = tostring(result)
            notify(name .. ": unavailable or incompatible with this game/executor. " .. tostring(result))
        end
        return false, result
    end
    local baseTask = task
    local task = setmetatable({}, {__index = baseTask})
    local function scheduled(method, delay, fn, ...)
        local args = table.pack(...)
        local function guarded()
            if not M.Destroyed then M.Try("Inventory task", fn, table.unpack(args, 1, args.n)) end
        end
        local thread
        if delay then thread = baseTask[method](delay, guarded) else thread = baseTask[method](guarded) end
        if type(thread) == "thread" and coroutine.status(thread) ~= "dead" then M.Tasks[thread] = true end
        return thread
    end
    task.defer = function(fn, ...) return scheduled("defer", nil, fn, ...) end
    task.spawn = function(fn, ...) return scheduled("spawn", nil, fn, ...) end
    task.delay = function(delay, fn, ...) return scheduled("delay", delay, fn, ...) end
    local function callWithRestoredThreadIdentity(fn, ...)
        local getter = getthreadidentity or (syn and syn.get_thread_identity)
        local setter = setthreadidentity or (syn and syn.set_thread_identity)
        local identity = type(getter) == "function" and getter() or nil
        local result = table.pack(pcall(fn, ...))
        if identity and type(setter) == "function" then pcall(setter, identity) end
        return table.unpack(result, 1, result.n)
    end
    local getupvalues = getupvalues or (debug and debug.getupvalues)
    local setupvalue = setupvalue or (debug and debug.setupvalue)
    local getinfo = getinfo or (debug and debug.getinfo)
     
    features.Animation = {SwordAPI = setmetatable({}, {__index = function(_, key)
        local api = require(replicatedStorage.Shared.SwordAPI)
        local method = api[key]
        if type(method) ~= "function" then return method end
        return function(_, ...) return method(api, ...) end
    end})}
    features.Animation.Reset = function()
        if u1070.oxy_manual and u1070.oxy_manual.Visual then u1070.oxy_manual.Visual.Reset(true) end
    end
    features.Animation.PreloadSword = function(sword)
        task.spawn(function()
            local character = localPlayer.Character
            local data = features.UnlockAll and features.UnlockAll.GetSwordData(sword)
            if not character or not data then return end
            local list = features.Animation.SwordAPI:GetAnimations(character, {"GrabParry", "Parry", "SuccessParry"}, data.AnimationType, data.SwordType)
            if type(list) == "table" and #list > 0 then game:GetService("ContentProvider"):PreloadAsync(list) end
        end)
    end
    local queue = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    local queue_on_teleport = function(code)
        assert(type(queue) == "function", "Executor does not support queue_on_teleport")
        M.DevicePayload = code
        return queue(code)
    end
    M.Loaders.Device = function()
			features.DeviceSpoof = {}

			features.DeviceSpoof.Apply = function()
				local query = [[local Source = %q
					if not game:IsLoaded() then game.Loaded:Wait() end
					if game.GameId ~= ]] .. tostring(game.GameId) .. [[ then return end
					local Queue = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
					local Players = game:GetService('Players')
					local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
					local Environment = getgenv()
					if Environment.AllusiveDeviceSpoofQueue then
						Environment.AllusiveDeviceSpoofQueue:Disconnect()
					end
					local Queued = false
					Environment.AllusiveDeviceSpoofQueue = Player.OnTeleport:Connect(function()
						if not Queued then
							Queue(Source:format(Source))
							Queued = true
						end
					end)
					local Device = ]] .. httpService:JSONEncode(flags.DeviceSpoofType == "Mobile" and "Phone" or flags.DeviceSpoofType) .. "if game.GameId ~= " .. tostring(game.GameId) .. [[ then return end
					local Previous = Environment.AllusiveDeviceSpoofRun
					if Previous and Previous.JobId == game.JobId and Previous.Device == Device then return end
					if Previous and Previous.Restore then Previous.Restore() end
					local Run = {Device = Device, JobId = game.JobId}
					Environment.AllusiveDeviceSpoofRun = Run
					while not workspace:GetAttribute('ClientModulesLoaded') do
						workspace:GetAttributeChangedSignal('ClientModulesLoaded'):Wait()
					end
					if Environment.AllusiveDeviceSpoofRun ~= Run then return end
					local ReplicatedStorage = game:GetService('ReplicatedStorage')
					local Listener = require(ReplicatedStorage:WaitForChild('ClientGameModules'):WaitForChild('DeviceListener'))
					local Observe = Listener.Observe

					local function Apply(Callback)
						if Run.Restore then Run.Restore() end
						task.spawn(function()
							local Success, Result = pcall(function()
								Callback(Device)
								Callback(Listener.Device)
							end)
							if not Success then
								Environment.AllusiveDeviceSpoofRun = nil
								error(Result, 0)
							end
							Environment.AllusiveDeviceSpoofApplied = {Device = Device, JobId = game.JobId}
						end)
					end

					for _, Connection in Listener.OnChange:GetConnections() do
						if debug.info(Connection._fn, 's') == 'ReplicatedStorage.Controllers.PlayerProfileController' then
							Apply(Connection._fn)
							return
						end
					end

					local function ObserveDevice(Self, Callback)
						if debug.info(Callback, 's') == 'ReplicatedStorage.Controllers.PlayerProfileController' then
							Apply(Callback)
							return Self.OnChange:Connect(Callback)
						end

						return Observe(Self, Callback)
					end

					Run.Restore = function()
						if Listener.Observe == ObserveDevice then Listener.Observe = Observe end
						Run.Restore = nil
					end
					Listener.Observe = ObserveDevice
					]]

				local concatenated = query:format(query)

				if globalEnvironment.AllusiveDeviceSpoofQueue then
					globalEnvironment.AllusiveDeviceSpoofQueue:Disconnect()
					globalEnvironment.AllusiveDeviceSpoofQueue = nil
				end
				;(queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport)(concatenated)
				window:Notify({ Title = "Rejoining...", Duration = 1 })
				task.wait(0.2)

				if not pcall(teleportService.TeleportToPlaceInstance, teleportService, game.PlaceId, game.JobId, localPlayer) then
					game.ExperienceService:LaunchExperience({ placeId = game.PlaceId, gameInstanceId = game.JobId })
				end
			end

    end

    M.Loaders.UnlockAll = function()
	do
		local hook = {
			Run = 0,
			Types = { "Sword", "Explosion" },
			Connections = {},
			Originals = {},
			SavedEquipped = {},
			Defaults = {},
			SwordData = {},
			Clones = {},
			Favorites = { Sword = {}, Explosion = {}, Emote = {} },
			Deleted = { Sword = {}, Explosion = {}, Emote = {} },
			ShopState = {},
			ShopChanges = {},
			ShopItems = { Sword = {}, Explosion = {} },
			ShopFields = {
			{ "ItemsMatching", "ItemsMatching" },
			{ "InDeleteMulti", "InDeleteMulti" },
			{ "Owns", "OwnsItem" },
			{ "Section", "Section" },
			{ "ForceHide", "ForceHide" },
		},
			ShopActive = false,
			FavoriteStates = {},
			DefaultFavorites = {},
			EmoteItems = {},
			EmoteItemsList = {},
			EmoteDisplays = {},
			EmoteItemKeys = {},
			EmoteBuildIndex = 1,
			EmoteBuildToken = 0,
			EmoteBuilding = false,
			EmotesReady = false,
			EmoteCatalogLoaded = false,
			ButtonConnections = {},
			CardConnections = {},
			EquippedEmotes = {},
			Finishers = {},
			DefaultFinishers = {},
			Overlays = {},
			MultiDelete = { Sword = {}, Explosion = {} },
			MultiDeleteCards = {},
		}

		features.UnlockAll = hook

		hook.Add = function(line)
			if line then
				table.insert(hook.Connections, line)
			end

			return line
		end

		local function onInputEnded(line, object, descendant)
			local radians = hook.Originals[line]

			if radians then
				object[descendant or line] = radians
				hook.Originals[line] = nil
			end
		end

		hook.GetCharacter = function()
			local model = localPlayer.Character
			local targetHumanoid = model and model:FindFirstChildOfClass("Humanoid")
			if model and model.Parent and (not targetHumanoid or targetHumanoid.Health > 0) then
				return model
			end
		end

		hook.Load = function()
			if hook.EmotesFolder then
				return true
			end
			local tween = replicatedStorage.Controllers
			local instance6 = replicatedStorage.Shared
			local screenGui = require(replicatedStorage.Packages.Replion)
			hook.InventoryClient = require(instance6.Inventory).Client
			hook.InventoryShared = require(instance6.Inventory.Shared)
			hook.InventoryController = require(tween.Trading.InventoryController)
			hook.InventoryReplion = screenGui.Client:GetReplion("Inventory")
			hook.DataReplion = screenGui.Client:GetReplion("Data")
			hook.Shop = require(tween.UI.ShopController)
			hook.ShopAPI = require(tween.UI.ShopControllerAPI)
			hook.TradeInfo = require(instance6.Trading.TradeInfo)
			hook.Swords = require(instance6.ReplicatedInstances.Swords)
			hook.SwordFX = require(instance6.ReplicatedInstances.SwordFX)
			hook.EmoteWheel = require(tween.EmoteWheelController)
			hook.EmoteController = require(tween.EmoteController)
			hook.DeletePrompt = require(tween.DeleteItemPromptController)
			hook.FinishersController = require(tween.FinishersController)
			hook.VFX = require(tween.VFXController)
			hook.EmotesShared = require(instance6.EmotesShared)
			hook.ItemInfo = require(instance6.ItemInfo)
			hook.AwakenData = require(instance6.SecretAwakenData)
			hook.AwakenBase = {}

			for vertex, particle in pairs(hook.AwakenData) do
				if type(particle) == "table" and particle.Awakened then
					hook.AwakenBase[particle.Awakened.Value] = vertex
				end
			end

			hook.Trove = require(replicatedStorage.Packages.Trove)
			hook.EmotesFolder = replicatedStorage.Misc.Emotes
			return true
		end

		hook.ShopReady = function()
			local player30 = hook.Shop._virtualItems
			if not player30 then
				return false
			end
			local result21 = hook.Shop._loadInventoryPage

			if result21 then
				for _, particle in pairs(hook.Types) do
					if player30[particle] and not next(player30[particle]) then
						result21(particle)
					end
				end
			end

			local result13 = hook.Shop._inventoryPages
			local player20 = result13 and result13.Sword
			result13 = result13 and result13.Explosion
			return player30.Sword and next(player30.Sword) ~= nil and player30.Explosion and next(player30.Explosion) ~= nil and player20 and player20.BatchDepth == 0 and result13 and result13.BatchDepth == 0
		end

		hook.Save = function()
			configData.UnlockAll = configData.UnlockAll or {}
			configData.UnlockAll.Sword = hook.AwakenBase[hook.Sword] or hook.Sword
			configData.UnlockAll.Explosion = hook.Explosion
			local result3 = {}

			for vertex, particle in pairs(hook.EquippedEmotes) do
				result3[tostring(vertex)] = particle
			end

			configData.UnlockAll.Emotes = result3
			configData.UnlockAll.Accessory = hook.Accessory == true
			configData.UnlockAll.Finishers = table.clone(hook.Finishers)

			configData.UnlockAll.Favorites = {
				Sword = table.clone(hook.Favorites.Sword),
				Explosion = table.clone(hook.Favorites.Explosion),
				Emote = table.clone(hook.Favorites.Emote),
			}

			flags.UnlockAllSword = configData.UnlockAll.Sword or ""
			flags.UnlockAllExplosion = hook.Explosion or ""
			flags.UnlockAllEmotes = configData.UnlockAll.Emotes
			flags.UnlockAllAccessory = configData.UnlockAll.Accessory
			flags.UnlockAllFinishers = configData.UnlockAll.Finishers
			flags.UnlockAllFavorites = configData.UnlockAll.Favorites
			saveConfig()
		end

		hook.LoadFavorites = function()
			for _, particle in pairs({ "Sword", "Explosion", "Emote" }) do
				table.clear(hook.Favorites[particle])
				local cell = type(flags.UnlockAllFavorites) == "table" and flags.UnlockAllFavorites[particle]

				if type(cell) == "table" then
					for vertex, existingPlayer in pairs(cell) do
						if existingPlayer == true then
							hook.Favorites[particle][vertex] = true
						end
					end
				end
			end
		end

		hook.ApplyFavorites = function()
			for vertex, particle in pairs(hook.Favorites) do
				for neighbor in pairs(particle) do
					hook.SetFavorite(vertex, neighbor, true, false)
				end
			end
		end

		hook.GetFavoriteState = function(line, object)
			local query = line .. "\0" .. tostring(object)
			local radians = hook.FavoriteStates[query]
			if radians then
				return radians
			end
			local SelectionService = hook.InventoryController:GetFavoriteState(line, object)

			if SelectionService then
				hook.FavoriteStates[query] = SelectionService
				hook.DefaultFavorites[query] = SelectionService:Get() == true
			end

			return SelectionService
		end

		hook.GetShopFavorites = function()
			if hook.ShopFavorites then
				return hook.ShopFavorites
			end
			local player20 = hook.Shop._inventoryPages and hook.Shop._inventoryPages.Sword
			local radians = player20 and getupvalues and getupvalues(player20.MarkDirty)
			radians = radians and radians[2]
			local lines = radians and getupvalues(radians)
			lines = lines and lines[4]
			lines = lines and getupvalues(lines) or {}

			for _, existingPlayer in pairs(lines) do
				if type(existingPlayer) == "table" and type(existingPlayer.Sword) == "table" and type(existingPlayer.Explosion) == "table" then
					hook.ShopFavorites = existingPlayer
					return existingPlayer
				end
			end
		end

		hook.SetFavorite = function(line, object, descendant, radius)
			if not hook.Favorites[line] then
				return
			end
			hook.Favorites[line][object] = descendant and true or nil
			local radians = hook.GetFavoriteState(line, object)
			local cell = line ~= "Emote" and hook.GetShopFavorites()

			if cell and cell[line] then
				cell[line][object] = descendant and true or nil
				local result13 = hook.Shop._inventoryPages and hook.Shop._inventoryPages[line]

				if result13 and result13.MarkDirty then
					result13.MarkDirty(nil, true, true)
				end
			end

			if radians then
				radians:Set(descendant == true)
			end

			local sortedArray = hook.ConsoleItems and hook.ConsoleItems[line] and hook.ConsoleItems[line][object]

			if sortedArray then
				sortedArray.Data.IsFavorited:Set(descendant == true)
			end

			if radius ~= false then
				hook.Save()
			end
		end

		hook.ToggleFavorite = function(line, object)
			hook.SetFavorite(line, object, not hook.Favorites[line][object])
		end

		hook.RestoreFavorites = function()
			local radians = hook.GetShopFavorites()

			for vertex, existingPlayer in pairs(hook.FavoriteStates) do
				local cell = hook.DefaultFavorites[vertex] == true
				local query = string.find(vertex, "\0", 1, true)
				local concatenated = query and string.sub(vertex, 1, query - 1)
				query = query and string.sub(vertex, query + 1)

				if radians and radians[concatenated] and query then
					radians[concatenated][query] = cell and true or nil
				end

				existingPlayer:Set(cell)
			end

			for _, existingPlayer in pairs(hook.Types) do
				local result13 = hook.Shop._inventoryPages and hook.Shop._inventoryPages[existingPlayer]

				if result13 then
					result13.MarkDirty(nil, true, true)
				end
			end

			table.clear(hook.FavoriteStates)
			table.clear(hook.DefaultFavorites)
		end

		hook.GetShopState = function(arguments,key)local y=arguments and arguments[key];if type(y)=="table"and type(y.Get)=="function"then return y:Get();end;return y;end
		hook.ApplyShopState = function(arguments,key,callback)local currentLength=arguments and arguments[key];if type(currentLength)=="table"and type(currentLength.Set)=="function"then currentLength:Set(callback);elseif arguments then arguments[key]=callback;end;end

		hook.SetShopState = function(line, object)
			if not line then
				return
			end
			local radians = hook.ShopState[line]
			if not radians then
				return
			end
			local lines = hook.ShopChanges[line]
			local cell = false

			for _, existingPlayer in pairs(hook.ShopFields) do
				local track = existingPlayer[1]
				local vertexCount = existingPlayer[2]
				local steering = object[track]

				if steering ~= nil then
					local major = hook.GetShopState(line, vertexCount)

					if major ~= steering then
						hook.ApplyShopState(line, vertexCount, steering)
						lines = lines or {}

						if lines[track] == nil then
							lines[track] = major
						elseif lines[track] == steering then
							lines[track] = nil
						end

						cell = true
					end

					radians[track] = steering
				end
			end

			if lines then
				hook.ShopChanges[line] = next(lines) and lines or nil
			end

			local result13 = hook.Shop._inventoryPages and hook.Shop._inventoryPages[line.Type]

			if cell and result13 and result13.MarkDirty and result13.BatchDepth == 0 then
				result13.MarkDirty(line, false, true)
			end

			if cell and hook.ConsoleItems then
				hook.SyncConsoleItem(line)
			end
		end

		hook.IsUnlockItem = function(line)
			local radians = "table"
			local cell = type(line) == radians

			if cell then
				cell = tostring(line.Id or ""):match("^UnlockAll:") ~= nil
			end

			return cell
		end

		hook.GetOwnedItem = function(line, object)
			local radians = hook.InventoryClient:FindItems(line, object)
			local cell = type(radians) == "table" and radians[1]
			local accessoryPrototype = cell and hook.InventoryClient:GetItem(line, cell)

			if accessoryPrototype and not hook.IsUnlockItem(accessoryPrototype) then
				local angleRadians = table.clone(accessoryPrototype)
				angleRadians.Id = angleRadians.Id or cell
				return angleRadians
			end

			local lines = hook.InventoryClient:GetInventory()[line] or {}

			for _, existingPlayer in pairs(lines) do
				if existingPlayer.Name == object and not hook.IsUnlockItem(existingPlayer) then
					return existingPlayer
				end
			end
		end

		hook.GetRealEquipped = function(line)
			local instance2 = hook.InventoryClient:GetEquipped(line)
			if not hook.IsUnlockItem(instance2) then
				return instance2
			end
			return hook.GetOwnedItem(line, instance2.Name)
		end

		hook.ActivateShop = function()
			if hook.ShopActive then
				return true
			end
			hook.ShopActive = true
			table.clear(hook.ShopState)
			table.clear(hook.ShopChanges)
			local HOOK_ORIGINAL_RUN = hook.Run
			local difference = os.clock() + 0.004
			local File = hook.Shop
			local result13 = File._inventoryPages
			local result47 = hook.ShopState
			local result46 = hook.ShopItems
			local heap = hook.Deleted

			local function handlePlayerRemoving(line)
				if os.clock() < difference then
					return true
				end
				runService.Heartbeat:Wait()

				if hook.Run ~= HOOK_ORIGINAL_RUN or hook.Status ~= "active" then
					if line and line.EndBatch then
						line.EndBatch()
					end

					return false
				end

				difference = os.clock() + 0.004
				return true
			end

			for _, particle in pairs(hook.Types) do
				local angleRadians = result13 and result13[particle]

				if angleRadians and angleRadians.BeginBatch then
					angleRadians.BeginBatch()
				end

				local lines = File._virtualItems[particle] or {}
				local track = result46[particle]
				local sourceTable = {}
				table.clear(track)

				for _, modelName in pairs(lines) do
					local targetPlayerName = modelName.Name

					if targetPlayerName and targetPlayerName ~= "Random" then
						local cell = hook.GetShopState(modelName, "OwnsItem")

						local players = {
							Owns = cell,
							Section = hook.GetShopState(modelName, "Section"),
							ForceHide = hook.GetShopState(modelName, "ForceHide"),
							ItemsMatching = hook.GetShopState(modelName, "ItemsMatching"),
							InDeleteMulti = hook.GetShopState(modelName, "InDeleteMulti"),
							Virtual = cell ~= true,
						}

						result47[modelName] = players
						local steering = track[targetPlayerName]

						if not steering then
							track[targetPlayerName] = modelName
							cell = cell and not players.ForceHide or nil
							sourceTable[targetPlayerName] = cell
						elseif not sourceTable[targetPlayerName] then
							local major = result47[steering]

							if cell and not players.ForceHide then
								track[targetPlayerName] = modelName
								sourceTable[targetPlayerName] = true
							elseif cell and not major.Owns then
								track[targetPlayerName] = modelName
							elseif major.ForceHide and not players.ForceHide then
								track[targetPlayerName] = modelName
							end
						end
					end

					if not handlePlayerRemoving(angleRadians) then
						return false
					end
				end

				for _, modelName in pairs(lines) do
					local targetPlayerName = modelName.Name

					if targetPlayerName and targetPlayerName ~= "Random" then
						local steering = result47[modelName]
						local major = table.clone(steering)

						if modelName == track[targetPlayerName] then
							local byte = heap[particle][targetPlayerName]
							local withinY = particle == "Sword" and hook.AwakenBase[targetPlayerName] ~= nil
							local characters = steering.ItemsMatching or {}

							if byte or withinY then
								characters = {}
							elseif #characters == 0 then
								characters = { "UnlockAll:" .. targetPlayerName }
							end

							steering.ItemsMatching = characters
							steering.InDeleteMulti = 0
							steering.Owns = #characters > 0
							steering.Section = steering.Owns and "Owned" or "Unowned"
							steering.ForceHide = withinY
						else
							steering.ForceHide = true
						end

						local players = {}

						for _, partTemplate in pairs(hook.ShopFields) do
							if steering[partTemplate[1]] ~= major[partTemplate[1]] then
								players[partTemplate[1]] = major[partTemplate[1]]
							end
						end

						hook.ShopChanges[modelName] = next(players) and players or nil
					end

					if not handlePlayerRemoving(angleRadians) then
						return false
					end
				end

				for _, modelName in pairs(lines) do
					local steering = hook.ShopChanges[modelName]

					if steering then
						for _, weld in pairs(hook.ShopFields) do
							if steering[weld[1]] ~= nil then
								hook.ApplyShopState(modelName, weld[2], result47[modelName][weld[1]])
							end
						end
					end
				end

				if angleRadians and angleRadians.MarkDirty then
					angleRadians.MarkDirty(nil, false, true)
				end

				if angleRadians and angleRadians.EndBatch then
					angleRadians.EndBatch()
				end
			end

			return true
		end

		hook.RestoreShop = function()
			if not hook.ShopActive then
				return
			end
			hook.ShopActive = false
			local result13 = hook.Shop._inventoryPages

			for _, particle in pairs(hook.Types) do
				local angleRadians = result13 and result13[particle]

				if angleRadians and angleRadians.BeginBatch then
					angleRadians.BeginBatch()
				end
			end

			for vertex, particle in pairs(hook.ShopChanges) do
				for _, existingPlayer in pairs(hook.ShopFields) do
					if particle[existingPlayer[1]] ~= nil then
						hook.ApplyShopState(vertex, existingPlayer[2], particle[existingPlayer[1]])
					end
				end
			end

			for _, particle in pairs(hook.Types) do
				local angleRadians = result13 and result13[particle]

				if angleRadians and angleRadians.MarkDirty then
					angleRadians.MarkDirty(nil, false, true)
				end

				if angleRadians and angleRadians.EndBatch then
					angleRadians.EndBatch()
				end
			end

			table.clear(hook.ShopState)
			table.clear(hook.ShopChanges)
			table.clear(hook.ShopItems.Sword)
			table.clear(hook.ShopItems.Explosion)
		end

		hook.GetSelected = function()
			local endTime = hook.Console

			if endTime then
				local timestamp = endTime:GetCurrentPage()
				local targetPlayerName = endTime.PageInfo[timestamp]
				targetPlayerName = targetPlayerName and targetPlayerName.ItemState:Get()
				targetPlayerName = targetPlayerName and targetPlayerName.ItemInfo.Name
				if hook.ShopItems[timestamp] and targetPlayerName then
					return timestamp, targetPlayerName, hook.ShopItems[timestamp][targetPlayerName]
				end
				return
			end

			local definition = hook.Shop and hook.Shop._selectedItem
			local index57 = definition and definition.type
			definition = definition and definition.name
			if (index57 == "Sword" or index57 == "Explosion") and definition then
				return index57, definition, hook.ShopItems[index57][definition]
			end
		end

		hook.MakeOverlay = function(line, hitboxPart, object)
			if not hitboxPart then
				return
			end
			local containerFrame = Instance.new("TextButton")
			containerFrame.Name = "UnlockAll" .. line
			containerFrame.Text = ""
			containerFrame.AutoButtonColor = false
			containerFrame.BackgroundTransparency = 1
			containerFrame.BorderSizePixel = 0
			containerFrame.Size = UDim2.new(1, 0, 1, 0)
			containerFrame.ZIndex = 100
			containerFrame.Visible = false
			containerFrame.Parent = hitboxPart
			hook.Add(containerFrame.Activated:Connect(object))
			hook.Overlays[line] = containerFrame
		end

		hook.RefreshShop = function()
			if hook.Console then
				return
			end
			local radians, angleRadians, track = hook.GetSelected()
			local result76 = hook.Status == "active" and track ~= nil and not hook.Shop._multiDelete and hook.Deleted[radians][angleRadians] ~= true
			local rope = hook.Overlays.Favorite
			local cash = hook.Overlays.Delete
			local right = hook.Overlays.Accessory
			local constraint = hook.Overlays.Finisher

			if rope then
				rope.Visible = result76
			end

			if right then
				right.Visible = false
			end

			if constraint then
				constraint.Visible = false
			end

			track = track and hook.ShopState[track]
			local result32 = result76 and track ~= nil and track.Owns

			if cash then
				cash.Visible = result32 and track ~= nil
			end

			local File = newCharacter:FindFirstChild("Shop")
			File = File and File:FindFirstChild("Holder")

			if (radians == "Sword" or radians == "Explosion") and File and File:FindFirstChild("Favorite") then
				File.Favorite.Visible = result32

				if result32 then
					local cell = hook.Favorites[radians][angleRadians] == true
					File.Favorite.Image = cell and "rbxassetid://15697987058" or "rbxassetid://15697981750"
					File.Favorite.HoverImage = cell and "rbxassetid://15697983062" or "rbxassetid://15697987058"
				end
			end

			File = File and File:FindFirstChild("InfoBG")

			if File and File:FindFirstChild("SecretUpgrade") then
				File.SecretUpgrade.Visible = result32 and radians == "Sword" and hook.AwakenData[angleRadians] ~= nil
			end

			local cell = radians and angleRadians and hook.Deleted[radians][angleRadians] == true

			if File and File:FindFirstChild("Delete") then
				File.Delete.Visible = cash and cash.Visible or false
			end

			local characterModel = File and File:FindFirstChild("BuyButton")

			if File and cell then
				for _, modelName in pairs({
					"BuyButton",
					"GiftButton",
					"UpgradeButton",
					"Finisher",
					"ChangeStyle",
					"EquipAccessory",
					"SecretUpgrade",
					"CharacterUpgradeButton",
					"UpgradesInfoButton",
					"Equips",
				}) do
					local steering = File:FindFirstChild(modelName)

					if steering and steering:IsA("GuiObject") then
						steering.Visible = false
					end
				end
			end

			if characterModel and result32 and track and track.Virtual then
				local active = radians == "Sword" and hook.Sword == angleRadians or radians == "Explosion" and hook.Explosion == angleRadians
				characterModel.Visible = true
				characterModel.Active = true

				if characterModel:FindFirstChild("PriceTag") then
					local optionContainer = characterModel.PriceTag:FindFirstChild("Price")
					local nameLabel = characterModel.PriceTag:FindFirstChild("TextLabel")

					if optionContainer then
						optionContainer.Visible = false
					end

					if nameLabel then
						nameLabel.Text = active and "Equipped" or "Equip"
					end
				end
			end

			if radians == "Sword" and result32 and track and track.Virtual and File and File:FindFirstChild("Equips") then
				local list = hook.Shop._selectedItem and hook.Shop._selectedItem.data
				local drawingObject = File.Equips:FindFirstChild("Finisher")
				local ropeConstraint = File.Equips:FindFirstChild("EquipAccessory")

				if drawingObject and list and list.HasFinisher then
					drawingObject.Visible = true

					if constraint then
						constraint.Visible = true
					end

					drawingObject.ImageColor3 = Color3.new(1, 1, 1)
					drawingObject.Label.Text = hook.Finishers[angleRadians] and "UNEQUIP" or "EQUIP"
				end

				if ropeConstraint and list and list.AccessoryToggleable and hook.Sword == angleRadians then
					ropeConstraint.Visible = true

					if right then
						right.Visible = true
					end

					ropeConstraint.Label.Text = hook.Accessory and "UNEQUIP ACCESSORY" or "EQUIP ACCESSORY"
				end
			end

			if hook.Shop._multiDelete then
				hook.Shop:_updateMultiDeleteVisbility()
			end
		end

		hook.SetAccessory = function(line)
			hook.Accessory = line == true
			localPlayer:SetAttribute("ShowSwordAccessory", hook.Accessory)

			if hook.Accessory and hook.Sword then
				hook.ApplySword(hook.Sword)
			elseif not hook.Accessory then
				local radians = hook.GetCharacter()
				local result54 = radians and radians:FindFirstChild("SwordAccessories")

				if result54 then
					result54:Destroy()
				end
			end

			hook.Save()
			hook.RefreshShop()

			for vertex in pairs(hook.Clones) do
				hook.UpdateClone(vertex)
			end
		end

		hook.SetFinisher = function(line, object)
			if not line then
				return
			end
			local lines = { "Finishers", "Equipped", line }

			if hook.DefaultFinishers[line] == nil and hook.DataReplion then
				hook.DefaultFinishers[line] = hook.DataReplion:Get(lines) == true
			end

			hook.Finishers[line] = object and true or nil

			if hook.DataReplion then
				hook.DataReplion:_set(lines, object == true)
			end

			hook.Save()
			hook.RefreshShop()
		end

		hook.GetCardType = function(line)
			local File = newCharacter:FindFirstChild("Shop")
			local root = File and File:FindFirstChild("Holder") and File.Holder:FindFirstChild("Pages")
			if root and root:FindFirstChild("Sword") and line:IsDescendantOf(root.Sword) then
				return "Sword"
			end

			if root and root:FindFirstChild("Explosion") and line:IsDescendantOf(root.Explosion) then
				return "Explosion"
			end
		end

		hook.UpdateMultiDelete = function()
			local radians = 0

			for _, existingPlayer in pairs(hook.Types) do
				for _, propertyName in pairs(hook.MultiDelete[existingPlayer]) do
					radians += propertyName
				end
			end

			local lineObject = hook.Overlays.MultiDelete

			if lineObject then
				lineObject.Visible = hook.Status == "active"
			end

			local File = newCharacter:FindFirstChild("Shop")
			local textButton = File and File:FindFirstChild("Holder") and File.Holder:FindFirstChild("DeleteItems")
			textButton = textButton and textButton:FindFirstChild("Title")

			if textButton then
				textButton.Text = radians > 0 and "Delete Items (" .. radians .. ")" or "Delete Items"
			end
		end

		hook.GetDeleteList = function()
			local File = newCharacter:FindFirstChild("Shop")
			File = File and File:FindFirstChild("Holder")
			File = File and File:FindFirstChild("DeleteItems")
			local targetCharacter = File and File:FindFirstChild("List") and File.List:FindFirstChild("ContentsCanvas")
			return targetCharacter and targetCharacter:FindFirstChild("ScrollingFrame")
		end

		hook.SetDeleteCount = function(line, object, descendant)
			local radians = hook.ShopItems[line][object]
			local angleRadians = radians and hook.ShopState[radians]
			if not angleRadians then
				return
			end
			local difference = math.clamp(descendant, 0, #angleRadians.ItemsMatching)
			hook.MultiDelete[line][object] = difference > 0 and difference or nil
			hook.SetShopState(radians, { InDeleteMulti = difference, ForceHide = difference > 0 and difference == #angleRadians.ItemsMatching })
			local query = line .. "\0" .. object
			local targetPart = hook.MultiDeleteCards[query]

			if difference == 0 then
				if targetPart then
					targetPart:Destroy()
				end

				hook.MultiDeleteCards[query] = nil
			else
				local track = hook.GetDeleteList()

				if track then
					if not targetPart or targetPart.Parent ~= track then
						local modelTemplate = track:FindFirstChildWhichIsA("UIListLayout")
						modelTemplate = modelTemplate and modelTemplate:FindFirstChild("Template")
						local vertexCount = hook.ItemInfo[line][object]
						if not modelTemplate or not vertexCount then
							return
						end
						targetPart = modelTemplate:Clone()
						targetPart.Name = line .. "_" .. object
						targetPart.Visible = true
						targetPart.Button.Label.Text = vertexCount.DisplayName or vertexCount.Name or object
						targetPart.Button.Item.Vector.Image = vertexCount.Icon or ""
						local MATERIAL_PENETRATION_COST = hook.TradeInfo.SmallerSlotColors
						local capacity = MATERIAL_PENETRATION_COST[vertexCount.Rarity] or MATERIAL_PENETRATION_COST.Default
						targetPart.Button.Item.Image = capacity.Image
						targetPart.Button.Item.HoverImage = capacity.HoverImage
						targetPart.Parent = track
						hook.MultiDeleteCards[query] = targetPart

						local function handlePlayerRemoving()
							hook.SetDeleteCount(line, object, (hook.MultiDelete[line][object] or 0) - 1)
						end

						targetPart.Button.Activated:Connect(handlePlayerRemoving)
						targetPart.Button.Item.Activated:Connect(handlePlayerRemoving)
					end

					targetPart.Button.Item.Label.Text = "x" .. difference
				end
			end

			hook.UpdateMultiDelete()
		end

		hook.ClearMultiDelete = function()
			for _, particle in pairs(hook.Types) do
				for vertex in pairs(hook.MultiDelete[particle]) do
					local angleRadians = hook.ShopItems[particle][vertex]

					if angleRadians and not hook.Deleted[particle][vertex] then
						hook.SetShopState(angleRadians, { InDeleteMulti = 0, ForceHide = false })
					end
				end
			end

			table.clear(hook.MultiDelete.Sword)
			table.clear(hook.MultiDelete.Explosion)

			for vertex, particle in pairs(hook.MultiDeleteCards) do
				if particle then
					particle:Destroy()
				end

				hook.MultiDeleteCards[vertex] = nil
			end

			hook.UpdateMultiDelete()

			if hook.Status == "active" then
				hook.RefreshShop()
			end
		end

		hook.ToggleMultiItem = function(line)
			if not hook.Shop._multiDelete then
				return
			end
			local radians = hook.GetCardType(line)
			local callbackFunction = line:GetAttribute("Name")
			local angleRadians = radians and callbackFunction and hook.ShopItems[radians][callbackFunction]
			if not (angleRadians and hook.ShopState[angleRadians]) or hook.Deleted[radians][callbackFunction] then
				return
			end
			hook.SetDeleteCount(radians, callbackFunction, (hook.MultiDelete[radians][callbackFunction] or 0) + 1)
		end

		hook.HookMultiCard = function(line)
			if hook.Status ~= "active" or not line:IsA("GuiButton") or not hook.GetCardType(line) or hook.CardConnections[line] then
				return
			end

			hook.CardConnections[line] = line.Activated:Connect(function()
					hook.ToggleMultiItem(line)
				end)
		end

		hook.CloseMultiDelete = function()
			hook.Shop._multiDelete = nil
			hook.Shop:_updateMultiDeleteVisbility()
			hook.Shop:_updateMultiDelete()
			hook.ClearMultiDelete()
		end

		hook.ConfirmMultiDelete = function()
			if not hook.Shop._multiDelete then
				return
			end
			local lines = {}
			local radians = 0

			for _, existingPlayer in pairs(hook.Types) do
				for vertex, propertyName in pairs(hook.MultiDelete[existingPlayer]) do
					radians += propertyName
					table.insert(lines, { Type = existingPlayer, Name = vertex, Quantity = propertyName })
				end
			end

			hook.ConfirmDelete(lines, "x" .. radians .. " items", hook.CloseMultiDelete)
		end

		hook.HookMultiDelete = function(line)
			local root = line:FindFirstChild("Pages")
			local textButton = line:FindFirstChild("DeleteItems")
			local ServerStorage = textButton and textButton:FindFirstChild("List") and textButton.List:FindFirstChild("Buttons")
			local File = hook.Shop
			hook.Originals.CanDelete = File._canDelete

			File._canDelete = function()
				return false
			end

			hook.CloseMultiDelete()
			local result66 = File._updateMultiDelete

			File._updateMultiDelete = function(object)
				if hook.Status ~= "active" then
					return result66(object)
				end

				if not object._multiDelete then
					hook.ClearMultiDelete()
					return
				end
				hook.UpdateMultiDelete()
			end

			hook.Originals.UpdateMultiDelete = result66
			hook.MakeOverlay("MultiDelete", ServerStorage and ServerStorage:FindFirstChild("Delete"), hook.ConfirmMultiDelete)

			if root then
				for _, particle in root:GetDescendants() do
					hook.HookMultiCard(particle)
				end

				hook.Add(root.DescendantAdded:Connect(function(hit)
						task.defer(hook.HookMultiCard, hit)
					end))
			end

			hook.UpdateMultiDelete()
		end

		hook.HookShop = function()
			local File = newCharacter:FindFirstChild("Shop")
			File = File and File:FindFirstChild("Holder")
			local player5 = File and File:FindFirstChild("InfoBG")
			if not File or not player5 then
				return
			end

			for _, particle in pairs(hook.Types) do
				local angleRadians = hook.Shop._inventoryPages[particle]
				local result25 = angleRadians.MarkDirty

				local function handlePlayerRemoving(line)
					local track = hook.ShopState[line]
					if not track or not hook.ShopChanges[line] then
						return
					end

					for _, modelName in pairs(hook.ShopFields) do
						local steering = track[modelName[1]]

						if hook.GetShopState(line, modelName[2]) ~= steering then
							hook.ApplyShopState(line, modelName[2], steering)
						end
					end

					if hook.ConsoleItems then
						hook.SyncConsoleItem(line)
					end
				end

				angleRadians.MarkDirty = function(line, object, descendant)
					if hook.Status == "active" then
						if line then
							handlePlayerRemoving(line)
						else
							for _, propertyName in pairs(hook.Shop._virtualItems[particle]) do
								handlePlayerRemoving(propertyName)
							end
						end
					end

					return result25(line, object, descendant)
				end

				hook.Originals["MarkDirty" .. particle] = result25
			end

			hook.Add(player5.BuyButton.Activated:Connect(function()
					local radians, angleRadians = hook.GetSelected()

					if radians == "Sword" then
						hook.SelectSword(angleRadians)
					elseif radians == "Explosion" then
						hook.SelectExplosion(angleRadians)
					end

					task.defer(hook.RefreshShop)
				end))

			hook.MakeOverlay("Favorite", File:FindFirstChild("Favorite"), function()
					local radians, angleRadians = hook.GetSelected()

					if radians and angleRadians then
						hook.ToggleFavorite(radians, angleRadians)
						hook.RefreshShop()
					end
				end)

			hook.MakeOverlay("Delete", player5:FindFirstChild("Delete"), function()
					local radians, angleRadians, track = hook.GetSelected()

						if radians and angleRadians and track and hook.ShopState[track] then
							hook.PromptDelete(radians, angleRadians)
						end

						return
				end)

			local partInstance = newCharacter:FindFirstChild("SecretUpgrade")

			if partInstance then
				hook.MakeOverlay("AwakenOpen", player5:FindFirstChild("SecretUpgrade"), function()
						local radians, angleRadians = hook.GetSelected()

						if radians == "Sword" then
							hook.OpenAwaken(angleRadians)
						end
					end)

				hook.MakeOverlay("Awaken", partInstance.Main.Upgrade, function()
						hook.AwakenSword(hook.AwakenName)
					end)

				hook.Overlays.AwakenOpen.Visible = true
				hook.Overlays.Awaken.Visible = true
			end

			local character2 = player5:FindFirstChild("Equips")

			hook.MakeOverlay("Accessory", character2 and character2:FindFirstChild("EquipAccessory"), function()
					local radians, angleRadians = hook.GetSelected()

						if radians == "Sword" and hook.Sword == angleRadians then
							hook.SetAccessory(not hook.Accessory)
						end

						return
				end)

			hook.MakeOverlay("Finisher", character2 and character2:FindFirstChild("Finisher"), function()
					local radians, angleRadians = hook.GetSelected()

					if radians == "Sword" then
						hook.SetFinisher(angleRadians, not hook.Finishers[angleRadians])
					end
				end)

			if hook.Shop.itemSelected and hook.Shop.itemSelected.Connect then
				hook.Add(hook.Shop.itemSelected:Connect(function()
						task.defer(hook.RefreshShop)
					end))
			end

			hook.HookMultiDelete(File)
		end

		hook.SyncConsoleItem = function(line)
			local radians = hook.ConsoleItems[line.Type][line.Name]
			if not radians or hook.ShopItems[line.Type][line.Name] ~= line then
				return
			end
			local angleRadians = hook.ShopState[line]
			local difference = angleRadians.ForceHide and 0 or #angleRadians.ItemsMatching
			radians.Data.OwnedCopies:Set(difference)
			hook.ShopAPI:GetItemBaseOwnedState(line.Type, line.Name):SetTag("UnlockAll", difference > 0)
			hook.Console:UpdateItem(radians.Data)
		end

		hook.BindConsole = function(line, object)
			for _, particle in getconnections(line.Activated) do
				if particle.Enabled then
					particle:Disable()
					table.insert(hook.ConsoleConnections, particle)
				end
			end

			hook.Add(line.Activated:Connect(object))
		end

		hook.HookConsole = function()
			local result45 = hook.ShopAPI
			local ok = result45.ActiveVariant
			if not ok then
				return
			end
			hook.Console = ok
			hook.ConsoleItems = { Sword = {}, Explosion = {} }
			hook.ConsoleConnections = {}
			local result22 = newCharacter.ControllerShop.Main

			for vertex, particle in pairs({
				SetEquipped = function(line, object, descendant)
					if not hook.ShopItems[object] then
						return hook.Originals.APISetEquipped(line, object, descendant)
					end
					local accessoryPrototype = hook.InventoryClient:GetItem(object, descendant)
					accessoryPrototype = accessoryPrototype and accessoryPrototype.Name or descendant
					if not hook.ShopItems[object][accessoryPrototype] or hook.Deleted[object][accessoryPrototype] then
						return false
					end

					if object == "Sword" then
						hook.SelectSword(accessoryPrototype)
					else
						hook.SelectExplosion(accessoryPrototype)
					end

					return true
				end,
				ToggleFavorited = function(line, object)
					local player7 = object.ItemInfo.ItemType
					local targetPlayerName = object.ItemInfo.Name
					if not hook.ShopItems[player7] then
						return hook.Originals.APIToggleFavorited(line, object)
					end
					hook.ToggleFavorite(player7, targetPlayerName)
					return true
				end,
				ToggleSwordAccessory = function()
					hook.SetAccessory(not hook.Accessory)
				end,
				RequestFinisherEquip = function(line, object)
					hook.SetFinisher(object.Name, not hook.Finishers[object.Name])
					return true
				end,
				ToggleSwordStyle = function()
					local radians = hook.ItemInfo.Sword[hook.Sword]

					if radians then
						radians = radians.AnimationStyles[hook.Accessory and "Accessory" or "Base"]
					end

					if radians and #radians > 0 then
						localPlayer:SetAttribute("AnimationStyle", radians[(table.find(radians, localPlayer:GetAttribute("AnimationStyle")) or 0) % #radians + 1])
					end
				end,
			}) do
				hook.Originals["API" .. vertex] = result45[vertex]
				result45[vertex] = particle
			end

			local ServerStorage = result22.DeleteItems.List.Buttons
			local radians = nil

			for _, existingPlayer in getconnections(ServerStorage.Cancel.Activated) do
				local edgeIterator = existingPlayer.Enabled and existingPlayer.Function

				if edgeIterator then
					local endTime = replicatedStorage.Controllers.UI.ShopControllerAPI.Variants.Console
					edgeIterator = getfenv(existingPlayer.Function).script == endTime
				end

				if edgeIterator then
					radians = existingPlayer
					break
				end
			end

			hook.ConsoleCancel = radians

			hook.BindConsole(ServerStorage.Delete, function()
					local lines = {}
					local angleRadians = 0

					for vertex, propertyName in debug.getupvalue(ok.GetDeletingItemState, 1) do
						local vertexCount = propertyName:Get()
						local player7 = vertex.ItemInfo.ItemType
						local targetPlayerName = vertex.ItemInfo.Name

						if vertexCount > 0 and hook.ShopItems[player7] then
							angleRadians += vertexCount
							table.insert(lines, { Type = player7, Name = targetPlayerName, Quantity = vertexCount })
						end
					end

					hook.ConfirmDelete(lines, "x" .. angleRadians .. " items", function()
						if radians then
							radians:Fire()
						end
					end)
				end)

			hook.BindConsole(result22.Pages.Sword.Right.UpgradeButton, function()
					local angleRadians, track = hook.GetSelected()

					if angleRadians == "Sword" then
						hook.OpenAwaken(track)
					end
				end)

			hook.BindConsole(newCharacter.SecretUpgrade.Main.Upgrade, function()
					hook.AwakenSword(hook.AwakenName)
				end)

			local HOOK_ORIGINAL_RUN = hook.Run
			local difference = os.clock() + 0.004

			for _, existingPlayer in pairs(hook.Types) do
				for vertex, propertyName in pairs(hook.ShopItems[existingPlayer]) do
					local vertexCount = table.clone(propertyName.Item)

					if hook.ShopState[propertyName].Virtual and existingPlayer == "Sword" then
						local steering = hook.ItemInfo.Sword[vertex]
						vertexCount.Finisher = steering.HasFinisher or nil
						vertexCount.Accessory = steering.AccessoryUnlockable or nil
					end

					local instance3 = result45:GetItemData(existingPlayer, result45:ParseItemKey(existingPlayer, vertexCount))
					vertexCount.Id = "UnlockAll:" .. existingPlayer .. ":" .. vertex
					hook.ConsoleItems[existingPlayer][vertex] = { Data = instance3, Item = vertexCount, Favorite = instance3.IsFavorited:Get() }
					instance3.IsFavorited:Set(hook.Favorites[existingPlayer][vertex] == true)
					hook.SyncConsoleItem(propertyName)

					if os.clock() >= difference then
						runService.Heartbeat:Wait()
						if hook.Run ~= HOOK_ORIGINAL_RUN or hook.Status ~= "active" then
							return
						end
						difference = os.clock() + 0.004
					end
				end

				hook.Add(hook.InventoryClient:OnInventoryChange(existingPlayer, function()
						task.defer(function()
							if hook.Run ~= HOOK_ORIGINAL_RUN or hook.Status ~= "active" then
								return
							end

							for _, propertyName in pairs(hook.ShopItems[existingPlayer]) do
								hook.SyncConsoleItem(propertyName)
							end
						end)
					end))

				local track = hook[existingPlayer]

				if track then
					hook.SetEquipped(existingPlayer, track)
				end
			end
		end

		hook.RestoreConsole = function()
			local endTime = hook.Console
			if not endTime then
				return
			end

			if hook.ConsoleCancel then
				hook.ConsoleCancel:Fire()
			end

			for _, particle in pairs({
				"SetEquipped",
				"ToggleFavorited",
				"ToggleSwordAccessory",
				"RequestFinisherEquip",
				"ToggleSwordStyle",
			}) do
				onInputEnded("API" .. particle, hook.ShopAPI, particle)
			end

			for _, particle in pairs(hook.ConsoleConnections) do
				particle:Enable()
			end

			for vertex, particle in pairs(hook.ConsoleItems) do
				for neighbor, existingPlayer in pairs(particle) do
					existingPlayer.Data.OwnedCopies:Set(#hook.InventoryClient:FindItemsWithKey(vertex, existingPlayer.Data.ParsedItemKey))
					existingPlayer.Data.IsFavorited:Set(existingPlayer.Favorite)
					hook.ShopAPI:GetItemBaseOwnedState(vertex, neighbor):SetTag("UnlockAll", nil)
					endTime:UpdateItem(existingPlayer.Data)
				end
			end

			hook.Console = nil
			hook.ConsoleItems = nil
			hook.ConsoleConnections = nil
			hook.ConsoleCancel = nil
		end

		hook.OpenAwaken = function(columnIndex)
			local radians = hook.AwakenData[columnIndex]
			if not radians then
				return
			end
			hook.AwakenName = columnIndex
			local partInstance = newCharacter.SecretUpgrade
			partInstance:SetAttribute("ToAwaken", nil)
			local result22 = partInstance.Main
			result22.template1.vector.Image = radians.Regular.Icon
			result22.template2.vector.Image = radians.Awakened.Icon
			result22.template2.customs.c3.Visible = radians.CustomSlash == true
			result22.Progress.Fill.Size = UDim2.fromScale(1, 1)
			local result40 = hook.AwakenData.Requirement
			result22.Progress.Progress.Text = result40 .. "/" .. result40
			require(replicatedStorage.ClientGameModules.GuiHandler):Open("SecretUpgrade")
		end

		hook.DestroyOverlays = function()
			for _, particle in pairs(hook.Overlays) do
				if particle and particle.Parent then
					particle:Destroy()
				end
			end

			table.clear(hook.Overlays)
		end

		hook.ConfirmDelete = function(line, object, descendant)
			local HOOK_ORIGINAL_RUN = hook.Run

			hook.DeletePrompt:PromptConfirmation({
				PromptType = "Single",
				Description = "Are you sure you want to delete " .. object .. "? This cannot be undone.",
			}, function(radius)
					if not radius or hook.Status ~= "active" or hook.Run ~= HOOK_ORIGINAL_RUN then
						return
					end

					for _, particle in pairs(line) do
						hook.DeleteItem(particle.Type, particle.Name, particle.Quantity)
					end

					if descendant then
						descendant()
					end
				end)
		end

		hook.PromptDelete = function(line, object)
			if not hook.DeletePrompt then
				return hook.DeleteItem(line, object)
			end
			local radians = hook.ItemInfo[line] and hook.ItemInfo[line][object]
			hook.ConfirmDelete({ { Type = line, Name = object } }, "x1 " .. tostring(radians and (radians.DisplayName or radians.Name) or object))
		end

		hook.AwakenSword = function(line)
			local radians = line and hook.AwakenData[line]
			local angleRadians = line and hook.ShopItems.Sword[line]
			local track = radians and hook.ShopItems.Sword[radians.Awakened.Value]
			local vertexCount = angleRadians and hook.ShopState[angleRadians]
			if hook.Status ~= "active" or not track or not vertexCount or #vertexCount.ItemsMatching == 0 then
				return
			end
			hook.AwakenName = nil
			local steering = table.clone(vertexCount.ItemsMatching)
			table.remove(steering)

			hook.SetShopState(angleRadians, {
				ItemsMatching = steering,
				Owns = #steering > 0,
				Section = #steering > 0 and "Owned" or "Unowned",
				ForceHide = #steering == 0,
			})

			local contactName = radians.Awakened.Value
			local major = table.clone(hook.ShopState[track].ItemsMatching)
			table.insert(major, "UnlockAll:" .. contactName)
			hook.Deleted.Sword[contactName] = nil
			hook.SetShopState(track, { ItemsMatching = major, Owns = true, Section = "Owned", ForceHide = false })

			if hook.Sword == line then
				hook.SelectSword(contactName, false)
			end

			if hook.Console then
				hook.Console.PageInfo.Sword.ItemState:Set(hook.ConsoleItems.Sword[contactName].Data)
			else
				hook.Shop:Select({ type = "Sword", name = contactName, data = hook.GetSwordData(contactName) })
			end

			require(replicatedStorage.ClientGameModules.GuiHandler):Open(hook.Console and "ControllerShop" or "Shop")
			hook.RefreshShop()
		end

		hook.DeleteItem = function(line, object, descendant)
			if hook.Status ~= "active" then
				return
			end

			if line == "Emote" then
				local radians = hook.EmoteItems[object]
				if not radians then
					return
				end
				hook.Deleted.Emote[object] = true
				hook.SetFavorite("Emote", object, false, false)
				local sourceIterator = hook.EmoteCaller and hook.EmoteCaller.Replion.Data.Inventory.Emote

				if sourceIterator and sourceIterator[radians.Id] then
					sourceIterator[radians.Id] = nil

					if hook.EmoteView then
						hook.EmoteView.TriggerUpdate(radians, "Remove")
					end
				end

				for vertex, existingPlayer in pairs(hook.EquippedEmotes) do
					if existingPlayer == object then
						hook.EquippedEmotes[vertex] = nil
					end
				end

				hook.UpdateEmoteWheel()
				hook.Save()
				return
			end

			local radians = hook.ShopItems[line] and hook.ShopItems[line][object]
			local angleRadians = radians and hook.ShopState[radians]
			if not angleRadians then
				return
			end
			local track = table.clone(angleRadians.ItemsMatching)
			local vertexCount = 1
			local endIndex = math.min
			local difference = descendant or 1

			for k = vertexCount, endIndex(difference, #track) do
				table.remove(track)
			end

			hook.SetShopState(radians, { ItemsMatching = track, InDeleteMulti = 0 })

			if #track > 0 then
				hook.SetShopState(radians, { ForceHide = false })
				hook.RefreshShop()
				return
			end

			hook.Deleted[line][object] = true
			hook.SetFavorite(line, object, false, false)
			hook.SetShopState(radians, { Owns = false, Section = "Unowned", ForceHide = false })

			if line == "Sword" and hook.Sword == object then
				hook.RestoreSword(true)
			elseif line == "Explosion" and hook.Explosion == object then
				hook.RestoreExplosion(true)
			else
				hook.Save()
			end

			hook.RefreshShop()
		end

		hook.PatchSwords = function()
			if hook.SwordsPatched then
				return
			end
			local yString = rawget(hook.Swords, "EquipSwordTo")
			local radians = yString and getupvalues and getupvalues(yString)
			if not radians or not setupvalue then
				return
			end
			local angleRadians = nil

			for vertex, propertyName in pairs(radians) do
				if typeof(propertyName) == "Instance" and propertyName.ClassName == "Players" then
					angleRadians = vertex
				elseif type(propertyName) == "table" and type(rawget(propertyName, "cancel")) == "function" and type(rawget(propertyName, "begin")) == "function" then
					hook.SwordState = propertyName
				end
			end

			if not angleRadians and radians[3] == false and radians[4] == true then
				setupvalue(yString, 3, playersService)
				angleRadians = 3
			end

			if angleRadians and type(radians[angleRadians + 1]) == "boolean" then
				setupvalue(yString, angleRadians + 1, false)
			end

			hook.SwordsPatched = angleRadians ~= nil
		end

		hook.GetSwordData = function(line)
			local radians = hook.SwordData[line]
			if radians then
				return radians
			end
			local bypassFunction = hook.Swords
			bypassFunction = bypassFunction and bypassFunction:GetSword(line)

			if not bypassFunction then
				bypassFunction = replicatedStorage.Shared.ReplicatedInstances:FindFirstChild("Swords")
				bypassFunction = bypassFunction and bypassFunction:FindFirstChild("GetSword")
				bypassFunction = bypassFunction and bypassFunction:Invoke(line)
			end

			if bypassFunction then
				hook.SwordData[line] = bypassFunction
			end

			return bypassFunction
		end

		hook.GetSlash = function(line)
			local radians = hook.GetSwordData(line)
			if not radians then
				return
			end
			local result48 = radians.SlashName or "SlashEffect"
			hook.SwordFX:GetInstance(result48)
			return result48
		end

		hook.RemoveSwords = function(line, object)
			if not line then
				return
			end

			for _, particle in line:GetChildren() do
				if particle:IsA("Model") and particle.Name ~= object and hook.GetSwordData(particle.Name) then
					particle:Destroy()
				end
			end
		end

		hook.GetBlade = function()
			if hook.BladeController then
				return hook.BladeController
			end

			if not getconnections or not getupvalues then
				return
			end
			local event = replicatedStorage:FindFirstChild("Remotes") and replicatedStorage.Remotes:FindFirstChild("FireSwordInfo")
			if not event then
				return
			end

			for _, particle in getconnections(event.OnClientEvent) do
				local edgeIterator = particle.Function and getupvalues(particle.Function)

				if type(edgeIterator) == "table" then
					for _, existingPlayer in pairs(edgeIterator) do
						if type(existingPlayer) == "table" and type(existingPlayer.SetSword) == "function" then
							hook.BladeController = existingPlayer
							return existingPlayer
						end
					end
				end
			end
		end

		hook.PatchBlade = function(line)
			if not line or hook.Originals.SetSword then
				return
			end
			hook.Originals.SetSword = line.SetSword

			line.SetSword = function(object, descendant)
				if hook.Status == "active" and hook.Sword then
					descendant = hook.Sword
				end

				return hook.Originals.SetSword(object, descendant)
			end
		end

		hook.ApplySword = function(line)
			local radians = hook.GetCharacter()
			if not radians or not line then
				return
			end
			local targetHumanoid = radians:FindFirstChildOfClass("Humanoid") or radians:WaitForChild("Humanoid", 2)
			if not targetHumanoid or targetHumanoid.Health <= 0 or not radians:FindFirstChild("HumanoidRootPart") then
				return
			end

			if hook.Sword and not hook.SavedEquipped.Sword then
				hook.Originals.EquippedSword = hook.GetRealEquipped("Sword")
				hook.SavedEquipped.Sword = true
			end

			hook.PatchSwords()
			local player22 = hook.SwordState

			if player22 then
				player22.cancel(radians)
			end

			if hook.Swords:EquipSwordTo(radians, line) == false then
				return
			end
			hook.Slash = hook.GetSlash(line) or hook.Slash

			if not hook.Accessory then
				local result54 = radians:FindFirstChild("SwordAccessories")

				if result54 then
					result54:Destroy()
				end
			end

			local angleRadians = hook.GetBlade()

			if angleRadians then
				hook.PatchBlade(angleRadians)
				angleRadians:SetSword(line)
			end

			if not hook.Accessory then
				task.defer(function()
						local result54 = radians:FindFirstChild("SwordAccessories")

						if result54 then
							result54:Destroy()
						end
					end)
			end

			task.defer(hook.RemoveSwords, radians, line)
		end

		hook.SetEquipped = function(line, object)
			if not hook.SavedEquipped[line] then
				hook.Originals["Equipped" .. line] = hook.GetRealEquipped(line)
				hook.SavedEquipped[line] = true
			end

			local sortedArray = hook.ConsoleItems and hook.ConsoleItems[line][object]
			hook.InventoryReplion:_set({ "Equipped", line }, sortedArray and sortedArray.Item or hook.GetOwnedItem(line, object) or { Name = object, Id = "UnlockAll:" .. line .. ":" .. object })

			if hook.Shop and hook.Shop._selectedItem then
				hook.Shop:Select(hook.Shop._selectedItem, true)
			end
		end

		hook.WatchSword = function(line)
			if not line then
				return
			end

			hook.Add(line.DescendantAdded:Connect(function(hit)
					local player20 = hook.Sword
					if hook.Status ~= "active" or not player20 then
						return
					end
					local otherPart = hit:FindFirstAncestorOfClass("Model")

					while otherPart and otherPart.Parent ~= line do
						otherPart = otherPart:FindFirstAncestorOfClass("Model")
					end

					if not otherPart or not otherPart:GetAttribute("_equippedSword") or otherPart.Name == player20 then
						return
					end

					if hit:IsA("BasePart") or hit:IsA("Decal") then
						hit.Transparency = 1
					elseif hit:IsA("ParticleEmitter") or hit:IsA("Trail") then
						hit.Enabled = false
						hit:Clear()
					elseif hit:IsA("Beam") or hit:IsA("Fire") or hit:IsA("Smoke") or hit:IsA("Sparkles") or hit:IsA("Light") then
						hit.Enabled = false
					end
				end))

			hook.Add(line:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function()
					local player20 = hook.Sword

					if hook.Status == "active" and player20 and line:GetAttribute("CurrentlyEquippedSword") ~= player20 then
						task.defer(hook.ApplySword, player20)
					end
				end))

			local targetHumanoid = line:FindFirstChildOfClass("Humanoid") or line:WaitForChild("Humanoid", 2)

			if targetHumanoid then
				hook.Add(targetHumanoid.HealthChanged:Connect(function(startIndex)
						local player20 = hook.Sword

						if hook.Status == "active" and startIndex > 0 and player20 then
							task.defer(hook.ApplySword, player20)
						end
					end))
			end
		end

		hook.ClearCloneTracks = function(line)
			line.Data = nil

				for vertex, particle in pairs(line.OriginalTracks) do
					if line.Animator and line.Animator.Parent then
						vertex:Play(0, particle.Weight, particle.Speed)
					end
				end

				table.clear(line.OriginalTracks)

				for _, particle in pairs(line.Tracks) do
					particle:Stop(0)
					particle:Destroy()
				end

				table.clear(line.Tracks)
				return
		end

		hook.PlayCloneTrack = function(line, object)
			local radians = hook.Clones[line]
			if not radians or not radians.Data or not object.IsPlaying then
				return
			end

			for _, existingPlayer in pairs(radians.Tracks) do
				if object == existingPlayer then
					return
				end
			end

			local chunk = object.Animation and hook.CloneAnimationTypes[object.Animation.AnimationId]
			if not chunk then
				return
			end
			local angleRadians = features.Animation.SwordAPI:GetAnimations(line, chunk, radians.Data.AnimationType, radians.Data.SwordType)[1]
			if not angleRadians or angleRadians.AnimationId == object.Animation.AnimationId then
				return
			end
			local track = radians.Tracks[angleRadians]

			if not track then
				track = radians.Animator:LoadAnimation(angleRadians)
				radians.Tracks[angleRadians] = track
			end

			local originPosition = object.WeightTarget

			if object.Looped then
				radians.OriginalTracks[object] = { Weight = originPosition, Speed = object.Speed }
			end

			track.Priority = object.Priority
			track.Looped = object.Looped
			track:Play(0, originPosition, object.Speed)

			if track.Length > 0 then
				track.TimePosition = math.min(object.TimePosition, track.Length)
			end

			object:Stop(0)
		end

		hook.UpdateClone = function(line)
			local radians = hook.Clones[line]
			if not radians or radians.Thread or hook.Status ~= "active" or not hook.Sword then
				return
			end
			local targetHumanoid = line:FindFirstChildOfClass("Humanoid")
			local sourcePlayer = targetHumanoid and targetHumanoid:FindFirstChildOfClass("Animator")
			if not sourcePlayer or not line:FindFirstChild("Torso") or not line:FindFirstChild("Left Arm") or not line:FindFirstChild("Right Arm") then
				return
			end

			if radians.Model and radians.Model.Parent == line and radians.Name == hook.Sword and radians.Accessory == hook.Accessory then
				for _, existingPlayer in line:GetChildren() do
					if existingPlayer ~= radians.Model and existingPlayer:GetAttribute("_equippedSword") then
						existingPlayer:Destroy()
					end
				end

				return
			end

			radians.Thread = task.defer(function()
					local player20 = hook.Sword
					local right = hook.Accessory
					hook.ClearCloneTracks(radians)
					local angleRadians = hook.GetSwordData(player20)
					local decoded, otherPart = pcall(hook.Swords.ForceEquipSwordTo, hook.Swords, line, player20, nil, right)
					if hook.Clones[line] ~= radians then
						return
					end

					if not decoded or not otherPart or not angleRadians then
						radians.Thread = nil
						return
					end
					local track = radians
					local vertexCount = radians
					radians.Model = otherPart
					track.Name = player20
					vertexCount.Accessory = right
					local steering = radians
					local major = sourcePlayer
					radians.Data = angleRadians
					steering.Animator = major

					if not radians.Connections.Animation then
						radians.Connections.Animation = sourcePlayer.AnimationPlayed:Connect(function(object)
							hook.PlayCloneTrack(line, object)
						end)
					end

					for _, partTemplate in sourcePlayer:GetPlayingAnimationTracks() do
						hook.PlayCloneTrack(line, partTemplate)
					end

					radians.Thread = nil
					hook.UpdateClone(line)
				end)
		end

		hook.ClearClone = function(line, object)
			local radians = hook.Clones[line]
			if not radians then
				return
			end
			hook.Clones[line] = nil
			cleanupResources(radians.Connections)
			cleanupResources(radians.Thread)
			hook.ClearCloneTracks(radians)

			if object and radians.Model and line.Parent then
				local callbackFunction = line:GetAttribute("EquippedSword") or radians.OriginalSword

				if callbackFunction then
					task.defer(function()
							if line.Parent and not hook.Clones[line] then
								hook.Swords:ForceEquipSwordTo(line, callbackFunction, nil, radians.OriginalAccessory)
							end
						end)
				end
			end
		end

		hook.WatchClone = function(line)
			local cell = hook.Status ~= "active"
			local active

			if cell then
				active = cell
			else
				local targetPlayerName = localPlayer.Name
				active = line:GetAttribute("EncryptedCloneOwner") ~= targetPlayerName
			end

			if active or hook.Clones[line] then
				return
			end

			if not hook.CloneAnimationTypes then
				local keys = {}

				for _, particle in replicatedStorage.Shared.SwordAPI.Collection:GetDescendants() do
					if particle:IsA("Animation") then
						for _, existingPlayer in pairs({ "Idle", "Parry", "GrabParry", "SuccessParry" }) do
							if particle:GetAttribute(existingPlayer) then
								local track = keys[particle.AnimationId]
								local rowIndex = particle.AnimationId
								local isArray = track == nil and existingPlayer
								local bestLabel

								if isArray then
									bestLabel = isArray
								else
									bestLabel = track == existingPlayer and existingPlayer
								end

								bestLabel = bestLabel or false
								keys[rowIndex] = bestLabel
								break
							end
						end
					end
				end

				hook.CloneAnimationTypes = keys
			end

			local lines = {
				Connections = {},
				Tracks = {},
				OriginalTracks = {},
				OriginalSword = line:GetAttribute("EquippedSword"),
				OriginalAccessory = line:GetAttribute("HasAccessoryEquipped") == true,
			}

			hook.Clones[line] = lines

			lines.Connections.Loaded = line.DescendantAdded:Connect(function(hit)
					local result15 = hit:IsA("Animator")
					local callbackFunction

					if result15 then
						callbackFunction = result15
					else
						local isArray = hit.Parent == line

						if isArray then
							callbackFunction = not lines.Model or hit:GetAttribute("_equippedSword")
						else
							callbackFunction = isArray
						end
					end

					if callbackFunction then
						task.defer(hook.UpdateClone, line)
					end
				end)

			hook.UpdateClone(line)
		end

		hook.WatchEmotes = function(line)
			local targetHumanoid

			if line then
				targetHumanoid = line:FindFirstChildOfClass("Humanoid") or line:WaitForChild("Humanoid", 2)
			else
				targetHumanoid = line
			end

			if not targetHumanoid then
				return
			end

			hook.Add(targetHumanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
					if targetHumanoid.MoveDirection ~= Vector3.zero and hook.EmoteTrove then
						hook.StopEmote()
					end
				end))
		end

		hook.SelectSword = function(player21, line)
			if not player21 or hook.Deleted.Sword[player21] then
				return
			end
			hook.Sword = player21
			hook.Slash = hook.GetSlash(player21)
			features.Animation.PreloadSword(player21)
			hook.SetEquipped("Sword", player21)
			hook.PatchParrySuccess()

			for _, particle in game:GetService("CollectionService"):GetTagged("EncryptedClone") do
				hook.WatchClone(particle)
				hook.UpdateClone(particle)
			end

			task.defer(function()
					if hook.Status == "active" and hook.Sword == player21 then
						hook.ApplySword(player21)
					end
				end)

			if line ~= false then
				hook.Save()
			end
		end

		hook.RestoreSword = function(line)
			local player20 = hook.Defaults.Sword or "Base Sword"
			hook.Sword = nil
			hook.Slash = nil

			if hook.SavedEquipped.Sword then
				hook.InventoryReplion:_set({ "Equipped", "Sword" }, hook.Originals.EquippedSword)
				hook.Originals.EquippedSword = nil
				hook.SavedEquipped.Sword = nil
			end

			hook.ApplySword(player20)

			if line then
				hook.Save()
			end

			for vertex in pairs(hook.Clones) do
				callWithRestoredThreadIdentity(hook.ClearClone, vertex, true)
			end
		end

		hook.SelectExplosion = function(vehicleEntity, line)
			if not vehicleEntity or hook.Deleted.Explosion[vehicleEntity] then
				return
			end
			hook.Explosion = vehicleEntity
			hook.SetEquipped("Explosion", vehicleEntity)
			localPlayer:SetAttribute("CurrentlyEquippedExplosion", vehicleEntity)
			local radians = hook.GetCharacter()

			if radians then
				radians:SetAttribute("CurrentlyEquippedExplosion", vehicleEntity)
			end

			if line ~= false then
				hook.Save()
			end
		end

		hook.RestoreExplosion = function(line)
			local health = hook.Defaults.Explosion or "Explosion Normal"
			hook.Explosion = nil

			if hook.SavedEquipped.Explosion then
				hook.InventoryReplion:_set({ "Equipped", "Explosion" }, hook.Originals.EquippedExplosion)
				hook.Originals.EquippedExplosion = nil
				hook.SavedEquipped.Explosion = nil
			end

			localPlayer:SetAttribute("CurrentlyEquippedExplosion", health)
			local radians = hook.GetCharacter()

			if radians then
				radians:SetAttribute("CurrentlyEquippedExplosion", health)
			end

			if line then
				hook.Save()
			end
		end

		hook.PatchExplosion = function()
			if not hook.VFX or hook.Originals.PlayExplosion then
				return
			end
			hook.Originals.PlayExplosion = hook.VFX.PlayExplosion

			hook.VFX.PlayExplosion = function(line, object, descendant, radius, zCoordinate, alpha, color)
				if hook.Status == "active" and hook.Explosion and color and alpha == localPlayer.Character then
					object = hook.Explosion
				end

				if hook.Status == "active" and color and alpha == localPlayer.Character and hook.Sword and hook.Finishers[hook.Sword] and hook.FinishersController then
					local explosion = zCoordinate and zCoordinate:FindFirstChild("HumanoidRootPart")
					local folder = workspace:FindFirstChild("Alive")
					local queue = folder and folder:GetChildren() or {}
					local difference = 0

					for _, particle in pairs(queue) do
						if particle ~= zCoordinate then
							difference += 1
						end
					end

					if explosion and folder and difference <= 1 then
						hook.FinishersController:PlayFinisher(hook.Sword, alpha, zCoordinate, explosion.CFrame, workspace:GetServerTimeNow())
					end
				end

				return hook.Originals.PlayExplosion(line, object, descendant, radius, zCoordinate, alpha, color)
			end
		end

		hook.PatchParrySuccess = function()
			if not hookfunction or not getconnections or not getinfo then
				return
			end
			local bindable = replicatedStorage:FindFirstChild("Remotes")
			local result5 = globalEnvironment.AllusiveSwordEffects or {}
			globalEnvironment.AllusiveSwordEffects = result5

			local function handlePlayerRemoving(line, object)
				if hook.Originals[line] or not object then
					return false
				end

				for _, particle in getconnections(object) do
					if particle.Function and (getinfo(particle.Function).name == "parrySuccessAll" or result5[line] == particle.Function) then
						result5[line] = particle.Function
						hook.Originals[line .. "Target"] = particle.Function
						hook.Originals[line] = hookfunction(particle.Function, function(...)local i={...};if  hook .Status=="active"and  hook .Sword and(tostring(i[4])== localPlayer .Name or type(i[4])=="table"and  hook .Clones[i[4].Character])then local y= hook .Slash;if y then i[1]=y;i[3]= hook .Sword;end;end;return  hook .Originals[ line ](unpack(i));end)
						return true
					end
				end

				return false
			end

			local remote = bindable and bindable:FindFirstChild("ParrySuccessAll")
			handlePlayerRemoving("Parry_All_Func", remote and remote.OnClientEvent)
			bindable = bindable and bindable:FindFirstChild("ParrySuccessClient")

			if bindable then
				bindable = bindable:IsA("BindableEvent") and bindable.Event or bindable.OnClientEvent
			end

			handlePlayerRemoving("Parry_Client_Func", bindable)
		end

		hook.StopEmote = function()
			if hook.EmoteTrove then
				hook.EmoteTrove:Destroy()
				hook.EmoteTrove = nil
			end

			local model = localPlayer.Character

			if model then
				model:SetAttribute("Emoting", nil)
			end
		end

		hook.PlayEmote = function(line)
			local radians = hook.EmotesFolder:FindFirstChild(line)
			local angleRadians = hook.GetCharacter()
			local targetHumanoid = angleRadians and angleRadians:FindFirstChildOfClass("Humanoid")
			if not radians or not angleRadians or not targetHumanoid or targetHumanoid.MoveDirection.Magnitude > 0 then
				return
			end
			hook.StopEmote()
			hook.EmoteTrove = hook.Trove.new()
			angleRadians:SetAttribute("Emoting", radians:GetAttribute("EmoteName") or radians.Name)
			hook.EmotesShared:Play(angleRadians, hook.EmoteTrove, radians.Name, true, workspace:GetServerTimeNow(), 1, nil, false)
		end

		hook.PatchEmotes = function()
			if hook.Originals.EmotePlay then
				return
			end
			hook.Originals.EmotePlay = hook.EmoteController.Play

			hook.EmoteController.Play = function(line, object, descendant)
				local cell = hook.Status == "active" and object and hook.EmotesFolder:FindFirstChild(object)
				if cell and cell.AnimationId ~= "" and cell.AnimationId ~= "rbxassetid://0" then
					return hook.PlayEmote(object)
				end
				return hook.Originals.EmotePlay(line, object, descendant)
			end

			for _, particle in pairs({ "UpdateHolderEmotes", "UpdateMenuContentEmotes" }) do
				local angleRadians = particle
				hook.Originals[angleRadians] = hook.EmoteWheel[angleRadians]

				hook.EmoteWheel[angleRadians] = function(line, ...)
					local track = hook.Originals[angleRadians]
					local vertexCount = table.pack(...)
					vertexCount.n = 2 + vertexCount.n - 1
					table.move(vertexCount, 1, vertexCount.n, 2, vertexCount)
					vertexCount[1] = line
					local steering = track(table.unpack(vertexCount, 1, vertexCount.n))

					if hook.Status == "active" then
						hook.RefreshEmotes()
					end

					return steering
				end
			end
		end

		hook.GetEmoteSlot = function()
			if hook.EmoteWheel.type == "Menu" then
				return math.clamp(tonumber(hook.EmoteWheel.selected) or 1, 1, 24)
			end
			return math.clamp(tonumber(hook.EmoteWheel.selected) or hook.SelectedSlot or 1, 1, 8) + ((tonumber(hook.EmoteWheel.page) or 1) - 1) * 8
		end

		hook.SetEmoteButton = function(line, object)
			local radians = hook.EmotesFolder:FindFirstChild(object)
			if not radians then
				return
			end
			local callbackFunction = radians:GetAttribute("EmoteName") or radians.Name
			local cost = radians:GetAttribute("Icon") or ""
			local hitHumanoid = newCharacter:FindFirstChild("EmoteWheel")
			local result78 = hitHumanoid and hitHumanoid:FindFirstChild("Wheel")
			hitHumanoid = hitHumanoid and hitHumanoid:FindFirstChild("Menu")
			local angleRadians = 1
			local difference = math.floor((line - 1) / 8) + angleRadians
			result78 = result78 and result78:FindFirstChild("Holder")
			hitHumanoid = hitHumanoid and hitHumanoid:FindFirstChild("Content")
			local lines = {}
			local cell = difference == (tonumber(hook.EmoteWheel.page) or 1) and result78 and result78:FindFirstChild(tostring((line - 1) % 8 + 1))
			hitHumanoid = hitHumanoid and hitHumanoid:FindFirstChild(tostring(line))
			lines[1] = cell
			lines[2] = hitHumanoid

			for _, propertyName in pairs(lines) do
				if propertyName then
					propertyName:SetAttribute("EmoteId", object)
					propertyName:SetAttribute("EmoteName", callbackFunction)
					local relativePosition = propertyName:FindFirstChild("Vector")

					if relativePosition then
						relativePosition.Image = cost
					elseif propertyName:IsA("ImageButton") then
						propertyName.Image = cost
					end

					local inputBox = propertyName:FindFirstChild("Title") or propertyName:FindFirstChild("ItemName") or propertyName:FindFirstChild("Text")

					if inputBox and inputBox:IsA("TextLabel") then
						inputBox.Text = callbackFunction
					end
				end
			end
		end

		hook.RefreshEmotes = function()
			for vertex, particle in pairs(hook.EquippedEmotes) do
				hook.SetEmoteButton(tonumber(vertex) or vertex, particle)
			end
		end

		hook.UpdateEmoteWheel = function()
			local result64 = hook.Originals.UpdateHolderEmotes
			local result65 = hook.Originals.UpdateMenuContentEmotes

			if result64 then
				result64(hook.EmoteWheel)
			else
				hook.EmoteWheel:UpdateHolderEmotes()
			end

			if result65 then
				result65(hook.EmoteWheel)
			else
				hook.EmoteWheel:UpdateMenuContentEmotes()
			end

			hook.EmoteWheel:updateCenterText()
			hook.RefreshEmotes()
		end

		hook.ApplyEmote = function(line, object)
			local index50 = tonumber(line) or hook.GetEmoteSlot()
			if not object or hook.Deleted.Emote[object] or not hook.EmotesFolder:FindFirstChild(object) then
				return
			end
			hook.SelectedSlot = index50
			hook.EquippedEmotes[index50] = object
			hook.UpdateEmoteWheel()
			hook.Save()
		end

		hook.GetEmoteScroller = function()
			if hook.EmoteContainer then
				return hook.EmoteContainer
			end
			local hitHumanoid = newCharacter:FindFirstChild("EmoteWheel")
			hitHumanoid = hitHumanoid and hitHumanoid:FindFirstChild("List")
			return hitHumanoid and hitHumanoid:FindFirstChild("Content")
		end

		hook.LoadEmotes = function()
			local sourceIterator = hook.InventoryClient:GetInventory().Emote or {}
			if hook.EmoteCatalogLoaded then
				return sourceIterator
			end
			table.clear(hook.EmoteItems)
			table.clear(hook.EmoteItemsList)
			table.clear(hook.EmoteDisplays)
			table.clear(hook.EmoteItemKeys)
			local lines = {}

			for _, particle in pairs(sourceIterator) do
				if not hook.IsUnlockItem(particle) then
					lines[particle.Name] = true
				end
			end

			local radians = 0.001
			local difference = os.clock() + radians

			for _, existingPlayer in hook.EmotesFolder:GetChildren() do
				local track = hook.ItemInfo.Emote[existingPlayer.Name]

				if existingPlayer:IsA("Animation") and track then
					hook.EmoteDisplays[track.DisplayName or track.Name] = existingPlayer.Name
				end

				if existingPlayer:IsA("Animation") and not lines[existingPlayer.Name] and track and type(track.Icon) == "string" and track.Icon ~= "" and track.Icon ~= "rbxassetid://0" and track.Icon ~= existingPlayer.AnimationId then
					local sourceTable = { Name = existingPlayer.Name, Id = "UnlockAll:Emote:" .. existingPlayer.Name, CreatedAt = 0 }
					hook.EmoteItems[existingPlayer.Name] = sourceTable
					table.insert(hook.EmoteItemsList, sourceTable)
					local players = { "Id" }
					local result11 = sourceTable.Id
					hook.EmoteItemKeys[hook.InventoryShared:ItemToKey("Emote", sourceTable, players)] = result11
				end

				if difference <= os.clock() then
					runService.Heartbeat:Wait()
					difference = os.clock() + 0.001
				end
			end

			hook.EmoteCatalogLoaded = true
			return sourceIterator
		end

		hook.FillEmoteInventory = function()
			if hook.EmotesReady or hook.EmoteBuilding or not hook.EmoteView then
				return
			end
			hook.EmoteBuilding = true
			hook.EmoteBuildToken = hook.EmoteBuildToken + 1
			local isReady = hook.EmoteBuildToken

			task.spawn(function()
					local pattern = hook.EmoteItemsList
					local result2 = hook.EmoteInventory
					local rightIndex = hook.EmoteBuildIndex

					while rightIndex <= #pattern and hook.EmoteBuildToken == isReady do
						local difference = os.clock() + 0.001

						while true do
							local radians = pattern[rightIndex]

							if not result2[radians.Id] and not hook.Deleted.Emote[radians.Name] then
								result2[radians.Id] = radians
								hook.EmoteView.TriggerUpdate(radians, "Insert")
							end

							rightIndex += 1
							if not (rightIndex > #pattern or os.clock() >= difference) then
								continue
							end
							break
						end

						hook.EmoteBuildIndex = rightIndex

						if rightIndex <= #pattern then
							runService.Heartbeat:Wait()
						end
					end

					if hook.EmoteBuildToken == isReady then
						hook.EmoteBuilding = false
						hook.EmotesReady = rightIndex > #pattern
					end
				end)
		end

		hook.PatchInventory = function(line)
			if hook.Originals.CreateInventory then
				return
			end
			local sound = hook.EmoteSource

			if not sound or not sound.Parent then
				sound = newCharacter:FindFirstChild("EmoteWheel")
				sound = sound and sound:FindFirstChild("List")
				sound = sound and sound:FindFirstChild("Content")
				hook.EmoteSource = sound
			end

			if not sound then
				return
			end

			if not hook.EmoteContainer then
				local lines = {}

				for _, particle in sound:GetDescendants() do
					if particle:IsA("GuiButton") then
						lines[particle] = particle.Archivable
						particle.Archivable = false
					end
				end

				hook.EmoteContainer = sound:Clone()

				for vertex, particle in pairs(lines) do
					vertex.Archivable = particle
				end

				hook.EmoteContainer.Name = "UnlockAllContent"
				hook.EmoteContainer.Visible = false
				hook.EmoteInventory = table.clone(line)
				local radians = hook.InventoryShared.CreateFakeReplion()
				radians.Data = { Inventory = { Emote = hook.EmoteInventory } }
				hook.EmoteCaller = { Replion = radians }
			end

			hook.Originals.EmoteFindItemsWithKey = hook.InventoryClient.FindItemsWithKey
			hook.Originals.EmoteGetItem = hook.InventoryClient.GetItem

			hook.InventoryClient.FindItemsWithKey = function(object, descendant, radius, ...)
				local cell = descendant == "Emote" and hook.EmoteItemKeys[radius]
				if hook.Status == "active" and cell then
					return { cell }
				end
				local score = hook.Originals.EmoteFindItemsWithKey
				local radians = table.pack(...)
				radians.n = 4 + radians.n - 1
				table.move(radians, 1, radians.n, 4, radians)
				radians[1] = object
				radians[2] = descendant
				radians[3] = radius
				return score(table.unpack(radians, 1, radians.n))
			end

			hook.InventoryClient.GetItem = function(object, descendant, radius, ...)
				local targetName = descendant == "Emote" and tostring(radius):match("^UnlockAll:Emote:(.+)$")
				if hook.Status == "active" and targetName and hook.EmoteItems[targetName] then
					return hook.EmoteItems[targetName]
				end
				local sortedArray = hook.ConsoleItems and hook.ConsoleItems[descendant]
				local result26 = sortedArray and tostring(radius):match("^UnlockAll:" .. descendant .. ":(.+)$")
				if hook.Status == "active" and result26 and sortedArray[result26] then
					return sortedArray[result26].Item
				end
				local str = hook.Originals.EmoteGetItem
				local radians = table.pack(...)
				radians.n = 4 + radians.n - 1
				table.move(radians, 1, radians.n, 4, radians)
				radians[1] = object
				radians[2] = descendant
				radians[3] = radius
				return str(table.unpack(radians, 1, radians.n))
			end

			local bar = hook.EmoteContainer
			bar.Position = sound.Position
			bar.Size = sound.Size
			bar.Active = sound.Active
			bar.Visible = false
			hook.EmoteContainer.Parent = sound.Parent
			hook.EmoteOriginal = sound
			hook.OriginalPosition = sound.Position
			hook.OriginalSize = sound.Size
			hook.OriginalActive = sound.Active
			hook.OriginalVisible = sound.Visible
			sound.Visible = false
			sound.Position = UDim2.fromOffset(-100000, -15)
			sound.Active = false
			hook.Originals.CreateInventory = hook.InventoryController.CreateInventory

			hook.InventoryController.CreateInventory = function(object, descendant)
				if hook.Status == "active" and descendant.InventoryType == "Emote" then
					local radians = table.clone(descendant)
					radians.Caller = hook.EmoteCaller
					radians.Container = hook.EmoteContainer
					radians.WatchOnChange = false

					radians.FindItemsWithKey = function(radius, zCoordinate)
						local cell = radius == "Emote" and hook.EmoteItemKeys[zCoordinate]
						if cell then
							return hook.EmoteInventory[cell] and { cell } or {}
						end
						return hook.InventoryShared:FindItemsWithKey(hook.EmoteCaller, radius, zCoordinate)
					end

					local result30 = radians.OnSlotCreated

					radians.OnSlotCreated = function(radius, zCoordinate, alpha, color, initialCapacity)
						if result30 then
							result30(radius, zCoordinate, alpha, color, initialCapacity)
						end

						if zCoordinate and zCoordinate.Name and color and initialCapacity then
							if hook.EmoteItems[zCoordinate.Name] and getconnections then
								for _, existingPlayer in getconnections(color.Activated) do
									existingPlayer:Disconnect()
								end
							end

							initialCapacity:Add(color.Activated:Connect(function()
									local targetPlayerName = zCoordinate.Name
									task.defer(hook.ApplyEmote, hook.GetEmoteSlot(), targetPlayerName)
								end))
						end
					end

					hook.EmoteView = hook.Originals.CreateInventory(object, radians)
					return hook.EmoteView
				end

				return hook.Originals.CreateInventory(object, descendant)
			end

			if not hook.EmoteView then
				local lines = {}
				local result43 = sound.Parent:FindFirstChild("SearchFrame")

				if result43 and getconnections then
					lines[result43.Search.MouseButton1Click] = {}
					lines[result43.SearchBG.SearchInput.FocusLost] = {}

					for vertex, particle in pairs(lines) do
						for _, existingPlayer in getconnections(vertex) do
							if existingPlayer.Function then
								particle[existingPlayer.Function] = true
							end
						end
					end
				end

				local playerData = hook.InventoryController.CreateSortOptions

				hook.InventoryController.CreateSortOptions = function()
				end

				hook.EmoteWheel:populateEmoteList()
				hook.InventoryController.CreateSortOptions = playerData

				for vertex, particle in pairs(lines) do
					for _, existingPlayer in getconnections(vertex) do
						if next(particle) and existingPlayer.Function and not particle[existingPlayer.Function] then
							existingPlayer:Disconnect()
						end
					end
				end
			end

			bar.Visible = true
			hook.FillEmoteInventory()
		end

		hook.RestoreInventory = function(line)
			hook.EmoteBuildToken = hook.EmoteBuildToken + 1
			hook.EmoteBuilding = false
			hook.EmoteBuildIndex = 1
			hook.EmotesReady = false
			onInputEnded("CreateInventory", hook.InventoryController)
			onInputEnded("EmoteFindItemsWithKey", hook.InventoryClient, "FindItemsWithKey")
			onInputEnded("EmoteGetItem", hook.InventoryClient, "GetItem")

			if hook.EmoteContainer then
				hook.EmoteContainer.Visible = false
				hook.EmoteContainer.Parent = nil
			end

			if hook.EmoteOriginal then
				hook.EmoteOriginal.Position = hook.OriginalPosition
				hook.EmoteOriginal.Size = hook.OriginalSize
				hook.EmoteOriginal.Active = hook.OriginalActive
				hook.EmoteOriginal.Visible = hook.OriginalVisible
				hook.EmoteOriginal = nil
				hook.OriginalPosition = nil
				hook.OriginalSize = nil
				hook.OriginalActive = nil
				hook.OriginalVisible = nil
			end

			if not line then
				return
			end
			cleanupResources(hook.ButtonConnections)
			table.clear(hook.ButtonConnections)

			if hook.EmoteView then
				hook.EmoteView.Destroy()
				hook.EmoteView = nil
			end

			if hook.EmoteCaller then
				hook.EmoteCaller.Replion:Destroy()
				hook.EmoteCaller = nil
			end

			if hook.EmoteContainer then
				hook.EmoteContainer:Destroy()
				hook.EmoteContainer = nil
			end

			hook.EmoteSource = nil
			hook.EmoteInventory = nil
			hook.EmoteCatalogLoaded = false
		end

		hook.BindEmoteCard = function(line)
			local radians = hook.ButtonConnections[line]

			if radians then
				cleanupResources(radians)
				hook.ButtonConnections[line] = nil
			end

			if hook.Status ~= "active" or not line.Parent then
				return
			end
			local timerLabel = line:FindFirstChild("ItemName")
			local angleRadians = timerLabel and hook.EmoteDisplays[timerLabel.Text]
			if not angleRadians then
				return
			end

			if not hook.EmoteItems[angleRadians] then
				return
			end
			local rope = line:FindFirstChild("Favorite")
			local cash = line:FindFirstChild("Delete")

			if getconnections and rope then
				for _, propertyName in getconnections(rope.Activated) do
					propertyName:Disconnect()
				end
			end

			if getconnections and cash then
				for _, propertyName in getconnections(cash.Activated) do
					propertyName:Disconnect()
				end
			end

			local lines = {}

			if rope then
				table.insert(lines, rope.Activated:Connect(function()
						hook.ToggleFavorite("Emote", angleRadians)
					end))
			end

			if cash then
				table.insert(lines, cash.Activated:Connect(function()
						hook.PromptDelete("Emote", angleRadians)
					end))
			end

			hook.ButtonConnections[line] = lines
		end

		hook.HookEmoteCard = function(line)
			if hook.Status ~= "active" or not line:IsA("GuiButton") or not line:FindFirstChild("ItemName") or hook.CardConnections[line] then
				return
			end

			hook.CardConnections[line] = line.ItemName:GetPropertyChangedSignal("Text"):Connect(function()
					task.defer(hook.BindEmoteCard, line)
				end)

			task.defer(hook.BindEmoteCard, line)
		end

		hook.HookEmotes = function()
			local radians = hook.GetEmoteScroller()
			if not radians then
				return
			end

			for _, existingPlayer in radians:GetDescendants() do
				hook.HookEmoteCard(existingPlayer)
			end

			hook.Add(radians.DescendantAdded:Connect(function(hit)
					task.defer(hook.HookEmoteCard, hit)
				end))
		end

		hook.SaveDefaults = function()
			local model = localPlayer.Character
			hook.Defaults.Sword = model and model:GetAttribute("CurrentlyEquippedSword") or localPlayer:GetAttribute("CurrentlyEquippedSword") or "Base Sword"
			hook.Defaults.Explosion = localPlayer:GetAttribute("CurrentlyEquippedExplosion") or model and model:GetAttribute("CurrentlyEquippedExplosion") or "Explosion Normal"
			hook.Defaults.Accessory = localPlayer:GetAttribute("ShowSwordAccessory") == true
		end

		hook.ApplySaved = function()
			local query = tostring(flags.UnlockAllSword or "")
			local radians = hook.AwakenBase[query] or query
			local concatenated = tostring(flags.UnlockAllExplosion or "")
			local partsIterator = flags.UnlockAllEmotes or {}
			local right = flags.UnlockAllAccessory == true
			hook.Accessory = right
			localPlayer:SetAttribute("ShowSwordAccessory", right)
			local cell = radians ~= ""
			local active

			if cell then
				active = not hook.ShopActive or hook.ShopItems.Sword[radians]
			else
				active = cell
			end

			if active then
				hook.SelectSword(radians, false)
			end

			if concatenated ~= "" and (not hook.ShopActive or hook.ShopItems.Explosion[concatenated]) then
				hook.SelectExplosion(concatenated, false)
			end

			table.clear(hook.EquippedEmotes)
			local lines = {}

			for vertex in pairs(partsIterator) do
				local userId = tonumber(vertex)

				if userId then
					table.insert(lines, userId)
				end
			end

			table.sort(lines)
			local sourceTable = {}
			local sourceIterator = hook.InventoryClient:GetInventory().Emote or {}

			for _, existingPlayer in pairs(sourceIterator) do
				sourceTable[existingPlayer.Name] = true
			end

			for _, existingPlayer in pairs(lines) do
				local track = partsIterator[tostring(existingPlayer)] or partsIterator[existingPlayer]

				if track and (sourceTable[track] or hook.EmoteItems[track]) then
					hook.EquippedEmotes[existingPlayer] = track
				end
			end

			table.clear(hook.Finishers)
			local pointGenerator = flags.UnlockAllFinishers or {}

			for vertex, existingPlayer in pairs(pointGenerator) do
				if existingPlayer == true then
					hook.Finishers[vertex] = true

					if hook.DataReplion then
						local players = { "Finishers", "Equipped", vertex }
						hook.DefaultFinishers[vertex] = hook.DataReplion:Get(players) == true
						hook.DataReplion:_set(players, true)
					end
				end
			end

			hook.UpdateEmoteWheel()
		end

		hook.RestoreEmotes = function()
			table.clear(hook.EquippedEmotes)
			hook.StopEmote()
			hook.EmoteWheel:UpdateHolderEmotes()
			hook.EmoteWheel:UpdateMenuContentEmotes()
		end

		hook.Start = function()
			if hook.Status then
				return
			end
			hook.Status = "starting"
			local HOOK_ORIGINAL_RUN = hook.Run + 1
			hook.Run = HOOK_ORIGINAL_RUN
			hook.Load()

			while flags.UnlockAllEnabled and hook.Run == HOOK_ORIGINAL_RUN and not hook.ShopReady() do
				runService.Heartbeat:Wait()
			end

			if not flags.UnlockAllEnabled or hook.Run ~= HOOK_ORIGINAL_RUN then
				if hook.Run == HOOK_ORIGINAL_RUN then
					hook.Status = nil
				end

				return
			end

			hook.Status = "active"

			for _, particle in pairs(hook.Deleted) do
				table.clear(particle)
			end

			table.clear(hook.EquippedEmotes)
			table.clear(hook.SavedEquipped)
			table.clear(hook.Finishers)
			table.clear(hook.DefaultFinishers)
			hook.Accessory = false
			hook.Originals.EquippedSword = nil
			hook.Originals.EquippedExplosion = nil
			hook.LoadFavorites()
			hook.SaveDefaults()
			local radians = hook.LoadEmotes()
			if hook.Run ~= HOOK_ORIGINAL_RUN or hook.Status ~= "active" then
				return
			end
			hook.PatchInventory(radians)
			hook.HookEmotes()
			hook.PatchExplosion()
			hook.PatchEmotes()
			hook.PatchParrySuccess()
			hook.ApplySaved()
			hook.WatchSword(localPlayer.Character)
			local Players = game:GetService("CollectionService")
			hook.Add(Players:GetInstanceAddedSignal("EncryptedClone"):Connect(hook.WatchClone))

			hook.Add(Players:GetInstanceRemovedSignal("EncryptedClone"):Connect(function(line)
					hook.ClearClone(line, true)
				end))

			for _, existingPlayer in Players:GetTagged("EncryptedClone") do
				hook.WatchClone(existingPlayer)
			end

			hook.WatchEmotes(localPlayer.Character)

			hook.Add(localPlayer:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function()
					local player20 = hook.Sword

					if player20 and localPlayer:GetAttribute("CurrentlyEquippedSword") ~= player20 then
						task.defer(hook.ApplySword, player20)
					end
				end))

			hook.Add(localPlayer.CharacterAdded:Connect(function(playerInstance)
					local HookCall = hook.Run
					features.Animation.Reset()
					hook.WatchSword(playerInstance)
					hook.WatchEmotes(playerInstance)

					task.delay(1, function()
						if hook.Status == "active" and hook.Run == HookCall and localPlayer.Character == playerInstance and hook.Sword then
							hook.ApplySword(hook.Sword)

							if hook.Explosion then
								localPlayer:SetAttribute("CurrentlyEquippedExplosion", hook.Explosion)
								playerInstance:SetAttribute("CurrentlyEquippedExplosion", hook.Explosion)
							end
						end
					end)
				end))

			if not hook.ActivateShop() then
				return
			end
			hook.ApplyFavorites()
			hook.HookShop()
			hook.HookConsole()
		end

		hook.Stop = function(line)
			if line then
				for _, particle in pairs({ "Parry_All_Func", "Parry_Client_Func" }) do
					local angleRadians = hook.Originals[particle .. "Target"]

					if angleRadians then
						hookfunction(angleRadians, hook.Originals[particle])
						hook.Originals[particle .. "Target"] = nil
						hook.Originals[particle] = nil
					end
				end
			end

			local result53 = hook.Status
			hook.Status = nil
			hook.Run = hook.Run + 1

			if result53 ~= "active" then
				if line then
					hook.RestoreInventory(true)
				end

				return
			end

			onInputEnded("UpdateMultiDelete", hook.Shop, "_updateMultiDelete")
			onInputEnded("CanDelete", hook.Shop, "_canDelete")

			for _, particle in pairs(hook.Types) do
				onInputEnded("MarkDirty" .. particle, hook.Shop._inventoryPages[particle], "MarkDirty")
			end

			hook.CloseMultiDelete()
			cleanupResources(hook.Connections)
			table.clear(hook.Connections)
			cleanupResources(hook.CardConnections)
			table.clear(hook.CardConnections)
			hook.RestoreConsole()
			hook.DestroyOverlays()
			hook.RestoreInventory(line)
			hook.RestoreShop()
			hook.RestoreFavorites()
			localPlayer:SetAttribute("ShowSwordAccessory", hook.Defaults.Accessory == true)

			for vertex, particle in pairs(hook.DefaultFinishers) do
				if hook.DataReplion then
					hook.DataReplion:_set({ "Finishers", "Equipped", vertex }, particle == true)
				end
			end

			table.clear(hook.Finishers)
			table.clear(hook.DefaultFinishers)
			onInputEnded("PlayExplosion", hook.VFX)
			onInputEnded("EmotePlay", hook.EmoteController, "Play")
			onInputEnded("UpdateHolderEmotes", hook.EmoteWheel)
			onInputEnded("UpdateMenuContentEmotes", hook.EmoteWheel)
			hook.RestoreSword()

			if hook.Originals.SetSword and hook.BladeController then
				onInputEnded("SetSword", hook.BladeController)
			end

			hook.RestoreExplosion()
			hook.RestoreEmotes()
			hook.Sword = nil
			hook.Explosion = nil
		end

		hook.Toggle = function(player28)
			flags.UnlockAllEnabled = player28

			if player28 then
				task.defer(hook.Start)
			else
				hook.Stop()
			end
		end
	end

        local inventory = features.UnlockAll
        local start = inventory.Start
        inventory.Start = function()
            if M.Destroyed or not flags.UnlockAllEnabled then return end
            if not M.Try("Unlock All startup", start) then
                pcall(inventory.Stop, true)
                inventory.Status = nil
                inventory.Run += 1
            end
        end

    end

    function M.Load(group)
        if M.Destroyed then return false end
        if M.Loaded[group] then return true end
        if not M.Loaders[group] then return false end
        if not M.Try(group, M.Loaders[group]) then return false end
        M.Loaded[group] = true
        return true
    end
    function M.ScheduleUnlock()
        if M.Destroyed or not M.Ready or M.Pending then return end
        M.Pending = true
        task.defer(function()
            local revision
            repeat
                revision = M.Revision
                if M.Desired or M.Loaded.UnlockAll then
                    if M.Load("UnlockAll") and not M.Destroyed then
                        flags.UnlockAllEnabled = M.Desired
                        M.Try("Unlock All", features.UnlockAll.Toggle, M.Desired)
                    end
                end
            until M.Destroyed or revision == M.Revision
            M.Pending = false
        end)
    end
    function M.Set(key, value)
        if M.Destroyed then return end
        if key == "DeviceSpoofType" then
            flags[key] = (value == "Mobile" or value == "Console") and value or "PC"
        elseif key == "UnlockAllEnabled" then
            M.Desired = value == true
            flags[key] = M.Desired
            M.Revision += 1
            M.ScheduleUnlock()
        end
    end
    function M.Commit()
        if M.Destroyed then return end
        M.Ready = true
        if M.Desired then M.ScheduleUnlock() end
    end
    function M.ApplyDevice()
        if M.Destroyed or M.DeviceApplying then return end
        M.DeviceApplying = true
        task.defer(function()
            if M.Load("Device") and not M.Destroyed then M.Try("Device Spoof", features.DeviceSpoof.Apply) end
            M.DeviceApplying = false
        end)
    end
    function M.Destroy()
        if M.Destroyed then return end
        M.Desired, flags.UnlockAllEnabled = false, false
        if M.Loaded.UnlockAll then M.Try("Unlock All restore", features.UnlockAll.Stop, true) end
        M.Destroyed = true
        local deviceRun = globalEnvironment.AllusiveDeviceSpoofRun
        if type(deviceRun) == "table" and deviceRun.JobId == game.JobId then
            if type(deviceRun.Restore) == "function" then pcall(deviceRun.Restore) end
        end
        cleanupResources(globalEnvironment.AllusiveDeviceSpoofQueue)
        globalEnvironment.AllusiveDeviceSpoofQueue = nil
        M.DevicePayload = nil
        for thread in pairs(M.Tasks) do cleanupResources(thread) end
        table.clear(M.Tasks)
        M.Pending, M.DeviceApplying = false, false
        if M.CleanupConnection then M.CleanupConnection:Disconnect() end
    end
    M.CleanupConnection = u839.Destroying:Connect(M.Destroy)
end

 
 
do
    local M = {
        Enabled = false, AutoEnabled = false, Destroyed = false, Ready = false, AutoReady = false, Busy = false,
        LastTick = 0, LastAuto = 0, Count = 0, AutoDistance = 0, Generation = 0,
        Session = 0, AutoSession = 0, Captured = {}, Hooks = {},
        TokenCandidates = {}, CandidatesScanned = false, KnownMetatables = {},
    }
    u1070.oxy_manual = M

    function M.SessionFor(owner)
        return owner == "Auto" and M.AutoSession or M.Session
    end
    function M.Active(owner, session)
        local enabled = owner == "Auto" and M.AutoEnabled and not M.Enabled or owner ~= "Auto" and M.Enabled
        return enabled and not M.Destroyed and M.SessionFor(owner) == session
    end
    function M.VisualAllowed()
        if M.Destroyed then return false end
         
        if M.Enabled then return M.Ready and u1070.spam.animation_fix_manual == true end
        return M.AutoEnabled and M.AutoReady and u1070.spam.animation_fix_auto == true
    end

    function M.ValidArguments(args)
        return args.n == 8 and type(args[2]) == "string" and type(args[3]) == "string"
            and type(args[4]) == "number" and typeof(args[5]) == "CFrame"
            and type(args[6]) == "table" and type(args[7]) == "table" and type(args[8]) == "boolean"
    end

    local function writeIndex(mt, index, readOnly)
        local ok = pcall(function()
            setreadonly(mt, false)
            mt.__index = index
        end)
         
        pcall(setreadonly, mt, readOnly)
        return ok
    end

    function M.ReleaseCapture()
        if M.CaptureAddedConnection then M.CaptureAddedConnection:Disconnect(); M.CaptureAddedConnection = nil end
        for mt, entry in pairs(M.Hooks) do
            entry.Active = false
             
            if mt.__index == entry.Wrapper then
                writeIndex(mt, entry.Original, entry.ReadOnly)
            end
        end
        table.clear(M.Hooks)
    end

    function M.HookRemote(remote)
        if M.Destroyed or not (M.Enabled or M.AutoEnabled) or next(M.Captured) ~= nil then return end
        if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then return end
        local ok, mt = pcall(getrawmetatable, remote)
        if ok and type(mt) == "table" then
            M.KnownMetatables[mt] = true
            M.HookMetatable(mt)
        end
    end
    function M.HookMetatable(mt)
        if M.Hooks[mt] or type(mt.__index) ~= "function" then return end
        local readOnly = true
        if type(isreadonly) == "function" then
            local readOK, value = pcall(isreadonly, mt)
            if readOK then readOnly = value end
        end
        local entry = {Original = mt.__index, ReadOnly = readOnly, Active = true}
        entry.Wrapper = function(object, key)
            local method = entry.Original(object, key)
            if not entry.Active or (key ~= "FireServer" and key ~= "InvokeServer")
                or type(method) ~= "function" then return method end
            if not (object:IsA("RemoteEvent") or object:IsA("RemoteFunction")) then return method end
            return function(self, ...)
                local args = table.pack(...)
                if entry.Active and (M.Enabled or M.AutoEnabled) and not M.Destroyed and self == object and M.ValidArguments(args) then
                    M.Captured[object] = args
                    M.ReleaseCapture()
                end
                return method(self, table.unpack(args, 1, args.n))
            end
        end
        M.Hooks[mt] = entry
        if not writeIndex(mt, entry.Wrapper, readOnly) then
            entry.Active = false
            M.Hooks[mt] = nil
        end
    end
    function M.InstallCapture()
        if M.Destroyed or not (M.Enabled or M.AutoEnabled) or next(M.Captured) ~= nil then return end
        if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then return end
        if next(M.Hooks) ~= nil then return end
        local now = u817()
        if M.CaptureRetryAt and now - M.CaptureRetryAt < 1 then return end
        M.CaptureRetryAt = now
        if not M.CaptureAddedConnection then
            M.CaptureAddedConnection = u1057.DescendantAdded:Connect(M.HookRemote)
        end
        for mt in pairs(M.KnownMetatables) do M.HookMetatable(mt) end
        if next(M.Hooks) == nil then
            for _, remote in ipairs(u1057:GetDescendants()) do M.HookRemote(remote) end
        end
    end

    function M.CollectTokenCandidates()
        if M.CandidatesScanned then return end
        M.CandidatesScanned = true
        local getValues = getupvalues or (debug and debug.getupvalues)
        if type(getValues) ~= "function" then return end
        local seen = {}
        local function collect(fn)
            if type(fn) ~= "function" then return end
            local ok, values = pcall(getValues, fn)
            if not ok or type(values) ~= "table" then return end
            for _, value in pairs(values) do
                if type(value) == "function" and not seen[value] then
                    seen[value] = true
                    table.insert(M.TokenCandidates, value)
                end
            end
        end
         
        local controllers = u1057:FindFirstChild("Controllers")
        if controllers then
            for _, controller in ipairs(controllers:GetChildren()) do
                if controller.Name:find("SwordsController", 1, true) == 1 then
                    local pry = controller:FindFirstChild("PRY")
                    if pry then
                        local ok, fn = pcall(require, pry)
                        if ok then collect(fn) end
                    end
                end
            end
        end
         
        if type(getgc) == "function" and debug and type(debug.info) == "function" then
            local ok, objects = pcall(getgc, true)
            if ok and type(objects) == "table" then
                for _, fn in pairs(objects) do
                    if type(fn) == "function" then
                        local sourceOK, source = pcall(debug.info, fn, "s")
                        if sourceOK and type(source) == "string" and source:find("PRY", 1, true) then collect(fn) end
                    end
                end
            end
        end
    end

    function M.Tokenize(seed)
        M.CollectTokenCandidates()
        local mask
        if M.TokenFunction then
            local ok, value = pcall(M.TokenFunction, seed, "TIME")
            if ok and type(value) == "string" and #value > 0 then mask = value end
        end
        if not mask then
            M.TokenFunction = nil
            for _, fn in ipairs(M.TokenCandidates) do
                local ok, value = pcall(fn, seed, "TIME")
                if ok and type(value) == "string" and #value > 0 then
                    M.TokenFunction, mask = fn, value
                    break
                end
            end
        end
        if not mask then return nil end
        local serverTime = tostring(math.floor(u797:GetServerTimeNow() * 100))
        local bytes = table.create(#serverTime)
        for i = 1, #serverTime do
            bytes[i] = string.char(bit32.bxor((serverTime:byte(i) + i) % 256,
                mask:byte((i - 1) % #mask + 1)))
        end
        return table.concat(bytes)
    end

    function M.RecordSend()
         
        if M.Destroyed or M.Count > 7 then return end
        M.Count += 1
        u1070.spam.parries = M.Count
        local generation = M.Generation
        task.delay(0.5, function()
            if M.Destroyed or M.Generation ~= generation then return end
            M.Count = math.max(0, M.Count - 1)
            u1070.spam.parries = M.Count
        end)
    end

    function M.FireRemote(owner, context)
        owner = owner or "Manual"
        local session = M.SessionFor(owner)
        if not M.Active(owner, session) or u1068 or not u797.CurrentCamera then return false end
        local cf, targets, coordinates = u1070.parry.get_payload(context)
        if not M.Active(owner, session) then return false end
        local sent = false
        for remote, original in pairs(M.Captured) do
            if not M.Active(owner, session) then return sent end
            if not remote.Parent then
                M.Captured[remote] = nil
            else
                local token = M.Tokenize(original[2])
                if not M.Active(owner, session) then return sent end
                if token then
                     
                    local method = remote:IsA("RemoteEvent") and remote.FireServer
                        or remote:IsA("RemoteFunction") and remote.InvokeServer
                    local ok = type(method) == "function" and pcall(method, remote, original[1], original[2], token, 0.5, cf, targets, coordinates, false)
                    if ok then sent = true else M.Captured[remote] = nil end
                end
            end
        end
        if not M.Active(owner, session) then return sent end
        if not sent then
             
             
            if next(M.Captured) == nil then M.InstallCapture() end
            if u1179() and M.Active(owner, session) then
                sent = pcall(u1178.Fire, u1178, 0.5, cf, targets, coordinates, false)
            end
            if not sent then return false end
        end
        if sent and M.Active(owner, session) then
            if u1070.sapphire and u1070.sapphire.State then
                local state = u1070.sapphire.State
                if owner == "Auto" then state.AutoSpamAt = os.clock() else state.ManualSpamAt = os.clock() end
            end
            M.RecordSend()
        end
        return sent
    end

    function M.IsAlive()
        local character = u1061.Character
        if not character then return false end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 or not character:FindFirstChild("HumanoidRootPart") then return false end
        local alive = u1070.spam.alive_ref
        if not alive or alive.Parent ~= u797 then
            alive = u797:FindFirstChild("Alive")
            u1070.spam.alive_ref = alive
        end
        return alive ~= nil and alive:FindFirstChild(u1061.Name) ~= nil
    end

     
     
     
    local V = {Generation = 0, Interval = 0.12, CancelFraction = 0.35}
    M.Visual = V

    local function stopOwned(track, destroy)
        if not track then return end
        if u1070.state.grab_track == track then u1070.state.grab_track = nil end
        pcall(function() track:Stop(V.StopFade or 0.05) end)
        if destroy then pcall(function() track:Destroy() end) end
    end

    function V.CancelStop()
        local pending = V.StopTask
        V.StopTask = nil
        if pending and type(task.cancel) == "function" then pcall(task.cancel, pending) end
    end
    function V.Reset(full)
        V.CancelStop()
        V.Generation += 1
        V.Pending = nil
        V.LastPulse = nil
        V.RetryAt = nil
        stopOwned(V.Track, full)
        if full then
            V.Track, V.Asset, V.Character, V.Animator, V.Sword = nil, nil, nil, nil, nil
        end
    end

    local function findGrab(folder)
        if not folder then return nil end
        local animation = folder:FindFirstChild("GrabParry") or folder:FindFirstChild("Parry") or folder:FindFirstChild("Grab")
        if animation then return animation end
        local base = folder:FindFirstChild("Base")
        return base and (base:FindFirstChild("GrabParry") or base:FindFirstChild("Parry") or base:FindFirstChild("Grab"))
    end

    function V.ReportError(message)
        if V.LastError ~= message and type(warn) == "function" then
            warn("[Allusive Private] Animation Fix: " .. message)
        end
        V.LastError = message
    end

    function V.Resolve(character, sword)
         
         
        local shared = u1057:FindFirstChild("Shared")
        local apiModule = shared and shared:FindFirstChild("SwordAPI")
        local data
        local replicated = shared and shared:FindFirstChild("ReplicatedInstances")
        local swords = replicated and replicated:FindFirstChild("Swords")
        local getSword = swords and swords:FindFirstChild("GetSword")
        if getSword then
            local ok, result = pcall(function() return getSword:Invoke(sword) end)
            if ok and type(result) == "table" then data = result end
        end
        local animationType, swordType = data and data.AnimationType or "Single", data and data.SwordType or "Single"
        if apiModule then
            if V.APIModule ~= apiModule or not V.API then
                local ok, api = pcall(require, apiModule)
                if ok and type(api) == "table" then V.API, V.APIModule = api, apiModule end
            end
            if V.API and type(V.API.GetAnimations) == "function" then
                local ok, animations = pcall(function()
                    return V.API:GetAnimations(character, {"Parry", "GrabParry"}, animationType, swordType)
                end)
                if ok and type(animations) == "table" then
                    for _, asset in ipairs(animations) do
                        if typeof(asset) == "Instance" and asset:IsA("Animation") then return asset end
                    end
                end
            end
            local collection = apiModule:FindFirstChild("Collection") or apiModule
            local asset = findGrab(collection:FindFirstChild(animationType)) or findGrab(collection:FindFirstChild("Default"))
            if asset and asset:IsA("Animation") then return asset end
        end
         
        local ok, folder = pcall(u1070.animation.get_anim_folder)
        local asset = ok and folder and (folder:IsA("Animation") and folder or findGrab(folder))
        if asset and asset:IsA("Animation") then return asset end
        return nil
    end

    function V.Prepare()
        if V.Pending or (V.RetryAt and u817() < V.RetryAt) then return end
        local generation, animator, character, sword = V.Generation, V.Animator, V.Character, V.Sword
        local pending = {}
        V.Pending = pending
        V.RetryAt = u817() + 1
         
        task.defer(function()
            local track
            local ok, result = pcall(function()
                local asset = V.Resolve(character, sword)
                if generation ~= V.Generation or M.Destroyed or not M.VisualAllowed() then return end
                if not asset then error("No parry Animation was found for " .. tostring(sword), 0) end
                track = animator:LoadAnimation(asset)
                for key, value in pairs(asset:GetAttributes()) do track:SetAttribute(key, value) end
                track:SetAttribute("GrabParry", true)
                track.Priority = u824.AnimationPriority.Action4
                return {
                    Asset = asset,
                    PlayFade = asset:GetAttribute("PlayFadeTime") or 0.05,
                    Weight = asset:GetAttribute("PlayWeight") or 1,
                    Speed = asset:GetAttribute("PlaySpeed") or 1,
                    StopFade = asset:GetAttribute("StopFadeTime") or 0.05,
                }
            end)
            if V.Pending == pending then V.Pending = nil end
            if not ok or not result or generation ~= V.Generation or M.Destroyed or not M.VisualAllowed() then
                stopOwned(track, true)
                if generation == V.Generation and not M.Destroyed and M.VisualAllowed() then
                    V.ReportError(tostring(result or "Could not prepare parry animation"))
                end
                return
            end
            V.LastError = nil
            V.Asset, V.Track = result.Asset, track
            V.PlayFade, V.Weight, V.Speed, V.StopFade = result.PlayFade, result.Weight, result.Speed, result.StopFade
            V.LastPulse = nil
        end)
    end

    function V.Pulse()
        if M.Destroyed or not M.VisualAllowed() then return end
        local now = u817()
        local character = u1061.Character
        if not character then return end
        if character:GetAttribute("InOverdriveMech") then
            if V.Track or V.Pending then V.Reset(true) end
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end
         
        local sword = u1070.animation.get_sword_name() or "Base Sword"
        if V.Character ~= character or V.Animator ~= animator or V.Sword ~= sword then
            V.Reset(true)
            V.Character, V.Animator, V.Sword = character, animator, sword
        end
        local track = V.Track
        if V.LastPulse and now - V.LastPulse < V.Interval then
            if not track then return end
             
             
            if track.IsPlaying then
                character:SetAttribute("ParryTime", math.max(character:GetAttribute("ParryTime") or 0,
                    track.Length > 0 and track.Length or 1))
                return
            end
        end
        V.LastPulse = now
        if not track then V.Prepare(); return end
         
        for _, other in ipairs(animator:GetPlayingAnimationTracks()) do
            if other:GetAttribute("GrabParry") or other:GetAttribute("Parry") or other:GetAttribute("SuccessParry") then
                pcall(function() other:Stop(other:GetAttribute("StopFadeTime") or 0.05) end)
            end
        end
        local ok = pcall(function()
            track.TimePosition = 0
            track:Play(V.PlayFade, V.Weight, V.Speed)
            u1070.state.grab_track = track
            local length = track.Length or 0
            local parryTime = length > 0 and (length - track.TimePosition) * V.Speed or 1
            character:SetAttribute("ParryTime", math.max(character:GetAttribute("ParryTime") or 0, parryTime))
        end)
        if not ok then
            stopOwned(track, true)
            V.Track, V.Asset = nil, nil
            V.RetryAt = now + 1
            V.ReportError("Could not play the cached parry animation")
            return
        end
        V.LastError = nil
        V.CancelStop()
        V.Generation += 1
        local generation = V.Generation
        local length = track.Length or 0
        local cancelDelay = math.max(0.05, length > 0 and math.min(V.Interval, length * V.CancelFraction) or V.Interval)
        V.StopTask = task.delay(cancelDelay, function()
            if M.Destroyed or not M.VisualAllowed() or V.Generation ~= generation or V.Track ~= track then return end
            V.StopTask = nil
            pcall(function() track:Stop(V.StopFade) end)
        end)
    end

    function M.SetAnimation(owner, enabled)
        local key = owner == "Auto" and "animation_fix_auto" or "animation_fix_manual"
        u1070.spam[key] = enabled == true
        local currentOwner = M.Enabled and "Manual" or M.AutoEnabled and "Auto" or nil
        if owner == currentOwner then V.Reset(false) end
    end

    function M.Dispatch(owner, context)
        if M.Busy or not M.IsAlive() then return false end
        local session = M.SessionFor(owner)
        if not M.Active(owner, session) then return false end
        M.Busy = true
        local ok, result = pcall(function()
            local mode = owner == "Auto" and u1070.spam.auto_mode or u1070.spam.manual_mode
            if V.Mode ~= mode then V.Reset(false); V.Mode = mode end
            local sent = false
            if mode == "Keypress" then
                M.ReleaseCapture()
                sent = u1070.parry.execute_fast("Keypress") ~= false
                if sent and M.Active(owner, session) then
            if u1070.sapphire and u1070.sapphire.State then
                local state = u1070.sapphire.State
                if owner == "Auto" then state.AutoSpamAt = os.clock() else state.ManualSpamAt = os.clock() end
            end
            M.RecordSend()
        end
            else
                sent = M.FireRemote(owner, context)
                if not sent and M.Active(owner, session) then
                    sent = u1070.parry.execute_fast("Keypress") ~= false
                    if sent and M.Active(owner, session) then
            if u1070.sapphire and u1070.sapphire.State then
                local state = u1070.sapphire.State
                if owner == "Auto" then state.AutoSpamAt = os.clock() else state.ManualSpamAt = os.clock() end
            end
            M.RecordSend()
        end
                end
            end
            if sent and M.Active(owner, session) and M.VisualAllowed() then V.Pulse() end
            return sent
        end)
        M.Busy = false
        if M.Active(owner, session) then M.LastError = not ok and tostring(result) or nil end
        return ok and result
    end

    function M.Step()
        if M.Destroyed or not M.Ready or not M.Enabled or M.Busy then return end
        local now = u817()
        if now - M.LastTick < 0.001 then return end
        M.LastTick = now
        M.Dispatch("Manual")  
    end

    function M.UpdateSchedulers()
        local manual = not M.Destroyed and M.Enabled
        local automatic = not M.Destroyed and M.AutoEnabled and not manual
        if not manual and u1070.spam.connection_manual then
            u1070.spam.connection_manual:Disconnect(); u1070.spam.connection_manual = nil
        end
        if not automatic and u1070.spam.connection_auto then
            u1070.spam.connection_auto:Disconnect(); u1070.spam.connection_auto = nil
        end
        if manual and not u1070.spam.connection_manual then
            u1070.spam.connection_manual = u1065:Connect(M.Step)
        elseif automatic and not u1070.spam.connection_auto then
            u1070.spam.connection_auto = u1065:Connect(M.StepAutoSpam)
        end
    end
    function M.SetManual(enabled)
        enabled = enabled == true
        if M.Destroyed then return end
        if M.Enabled == enabled then return end  
        M.AutoEvaluating = nil
        M.Session += 1
        M.AutoSession += 1  
        V.Reset(false)
        M.Enabled = enabled
        u1070.spam.manual_enabled = enabled
        M.UpdateSchedulers()
        if enabled then
            M.LastTick = 0
            M.CaptureRetryAt = nil
             
        elseif not M.AutoEnabled then
            M.ReleaseCapture()
        end
    end

     
    function M.ResetCount()
        M.AutoEvaluating = nil
        M.Generation += 1
        M.Count = 0
        u1070.spam.parries = 0
        M.AutoDistance, M.LastAuto = 0, 0
    end
    function M.WatchBalls(folder)
        if M.Destroyed or M.BallsFolder == folder then return end
        if M.BallRemovedConnection then M.BallRemovedConnection:Disconnect(); M.BallRemovedConnection = nil end
        M.BallsFolder = folder
        M.ResetCount()
        if folder then
            M.BallRemovedConnection = folder.ChildRemoved:Connect(function()
                M.ResetCount()
                M.AutoSession += 1
            end)
        end
    end
    function M.GetAutoBall()
        local folder = M.BallsFolder
        if not folder or folder.Parent ~= u797 or folder.Name ~= "Balls" then
            folder = u797:FindFirstChild("Balls")
            M.WatchBalls(folder)
        end
        if not folder then return end
        for _, ball in ipairs(u1070.runtime_cache.Children(folder)) do
            if ball:GetAttribute("realBall") then
                local part = ball:IsA("BasePart") and ball or ball.PrimaryPart or ball:FindFirstChild("Corpo") or ball:FindFirstChild("Body")
                if part then return ball, part end
            end
        end
    end
    function M.GetAutoOpponent(root, context)
        local config = u1070.config
        local lock = u1070.target_player
        if lock and lock.Ready and lock.Enabled then return lock.Character() end
        if not lock and config.target_player_enabled and config.target_player_name then
            local target = u1054:FindFirstChild(config.target_player_name)
            return target and target.Character
        end
        if type(u1070.player.get_closest_to_cursor) == "function" then
            return u1070.player.get_closest_to_cursor(context)
        end
         
        local folder = u797:FindFirstChild("Alive")
        local best, distance
        if folder then
            for _, character in ipairs(u1070.runtime_cache.Children(folder)) do
                local part = character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if character ~= u1061.Character and part and (not humanoid or humanoid.Health > 0) then
                    local current = (root.Position - part.Position).Magnitude
                    if not distance or current < distance then best, distance = character, current end
                end
            end
        end
        return best
    end
    function M.GetDistanceMultiplier(value)
        value = tonumber(value) or 0.3
        if value ~= value then value = 0.3 end
        return math.clamp(value, 0.3, 3)
    end
    function M.SetDistanceMultiplier(value)
        if M.Destroyed then return end
        value = M.GetDistanceMultiplier(value)
        if u1070.spam.distance_multiplier ~= value then
            u1070.spam.distance_multiplier = value
            M.AutoDistance, M.AutoDistanceScale = 0, nil
            M.AutoSession += 1  
        end
    end
    function M.AutoPerform(properties, dot, ballDistance, entityDistance, characterDistance, ping)
         
        local speed = properties
        if type(properties) == "table" then
            speed, dot = properties.Speed, properties.Dot
            ballDistance, entityDistance = properties.BallDistance, properties.EntityDistance
            characterDistance, ping = properties.CharacterDistance, properties.Ping
        end
         
         
        local multiplier = M.GetDistanceMultiplier(u1070.spam.distance_multiplier)
        if M.AutoDistanceScale ~= multiplier then
            M.AutoDistance, M.AutoDistanceScale = 0, multiplier
        end
        local baseRadius = ping + math.min(speed / 6, 95)
        local radius = baseRadius * multiplier
        if entityDistance > radius or ballDistance > radius or (characterDistance or entityDistance) > radius then
            return M.AutoDistance or 0
        end
        M.AutoDistance = (baseRadius - math.clamp(dot, -1, 0) * (5 - math.min(speed / 5, 5))) * multiplier
        return M.AutoDistance
    end
    function M.StepAutoSpam()
        if M.Destroyed or not M.AutoReady or not M.AutoEnabled or M.Enabled or M.Busy then return end
        if M.AutoEvaluating and M.AutoEvaluating.Session == M.AutoSession then return end
        local now = u817()
        if now - (M.LastAuto or 0) < 0.001 then return end
        local threshold = math.clamp(tonumber(u1070.spam.threshold) or 1.5, 1, 5)
        if M.Count <= threshold then
            M.AutoDistance, M.AutoDistanceScale = 0, nil
            return
        end
        if not M.IsAlive() then return end
        local evaluation = {Session = M.AutoSession, At = now}
        M.AutoEvaluating = evaluation
        local ok, err = pcall(function()
            local ball, part = M.GetAutoBall()
            local zoomies = ball and ball:FindFirstChild("zoomies")
            if not zoomies then return end
            local character = u1061.Character
            local root = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
            if not root or character:GetAttribute("Pulsed") then return end
            local context = {Camera = u797.CurrentCamera or u1062}
            local opponent = M.GetAutoOpponent(root, context)
            local opponentRoot = opponent and (opponent.PrimaryPart or opponent:FindFirstChild("HumanoidRootPart"))
            local humanoid = opponent and opponent:FindFirstChildOfClass("Humanoid")
            if not opponentRoot or opponent == character or humanoid and humanoid.Health <= 0 then return end
            local offset = root.Position - part.Position
            local distance = offset.Magnitude
            local velocity = part.AssemblyLinearVelocity
             
            local speed = typeof(velocity) == "Vector3" and velocity.Magnitude or nil
            if not speed or speed < 0.001 then
                velocity = zoomies.VectorVelocity
                speed = typeof(velocity) == "Vector3" and velocity.Magnitude or nil
            end
            if not speed then return end
            if speed ~= speed or speed == math.huge or distance ~= distance or distance == math.huge then return end
            local dot = distance > 0.001 and speed > 0.001 and offset:Dot(velocity) / (distance * speed) or 0
            local enemyDistance = (root.Position - opponentRoot.Position).Magnitude
            local characterDistance = type(u1061.DistanceFromCharacter) == "function" and u1061:DistanceFromCharacter(opponentRoot.Position) or enemyDistance
            local radius = M.AutoPerform(speed, dot, distance, enemyDistance, characterDistance,
                math.clamp((tonumber(u1070.cache.get_ping()) or 50) / 10, 1, 16))
            local target = u1070.sapphire and u1070.sapphire.Target(ball) or ball:GetAttribute("target")
            if not target or target == "" or characterDistance > radius or distance > radius then return end
            if target == u1061.Name and characterDistance > 30 and distance > 30 then return end
            if M.AutoEvaluating ~= evaluation or not M.Active("Auto", evaluation.Session)
                or u817() - now > 0.1 or u817() < now then return end
            if distance <= radius and M.Count > threshold and ball.Parent and M.AutoEnabled and not M.Enabled then
                M.LastAuto = now
                M.Dispatch("Auto", context)
            end
        end)
        if M.AutoEvaluating == evaluation then
            M.AutoEvaluating = nil
            if not ok then M.LastError = tostring(err) end
        end
    end
    function M.SetAuto(enabled)
        if M.Destroyed then return end
        enabled = enabled == true
        if M.AutoEnabled == enabled then return end
        M.AutoEvaluating = nil
        M.AutoSession += 1
        M.AutoEnabled = enabled
        u1070.spam.auto_enabled = enabled
        M.UpdateSchedulers()
        if not M.Enabled then V.Reset(false) end
        if enabled then
            M.LastAuto = 0
        elseif not M.Enabled then M.ReleaseCapture() end
    end
    M.WatchBalls(u797:FindFirstChild("Balls"))
    M.FolderAddedConnection = u797.ChildAdded:Connect(function(folder)
        if folder.Name == "Balls" then M.WatchBalls(folder) end
    end)
    u1070.spam.auto_start = function() M.SetAuto(true) end
    u1070.spam.auto_stop = function() M.SetAuto(false) end

    function M.Destroy()
        if M.Destroyed then return end
        M.SetAuto(false)
        M.SetManual(false)
        V.Reset(true)
        M.Destroyed = true
        M.AutoEvaluating = nil
        M.Generation += 1
        M.Count = 0
        u1070.spam.parries = 0
        table.clear(M.Captured)
        table.clear(M.TokenCandidates)
        table.clear(M.KnownMetatables)
        M.TokenFunction = nil
        if M.CleanupConnection then M.CleanupConnection:Disconnect() end
        if M.CharacterConnection then M.CharacterConnection:Disconnect() end
        if M.BallRemovedConnection then M.BallRemovedConnection:Disconnect() end
        if M.FolderAddedConnection then M.FolderAddedConnection:Disconnect() end
    end
    M.CharacterConnection = u1061.CharacterAdded:Connect(function()
        V.Reset(true)
        M.ReleaseCapture()
        table.clear(M.Captured)
        M.ResetCount()
        M.Session += 1
        M.AutoSession += 1
        M.LastTick = 0
        M.CaptureRetryAt = nil
        M.CandidatesScanned = false
        M.TokenFunction = nil
        table.clear(M.TokenCandidates)
    end)
    if u839 then M.CleanupConnection = u839.Destroying:Connect(M.Destroy) end
    u1070.spam.manual_start = function() M.SetManual(true) end
    u1070.spam.manual_stop = function() M.SetManual(false) end
end


 
do
    local T = {Enabled = false, Ready = false, Destroyed = false, Name = "", KillSwitch = false,
        HighlightEnabled = false, Highlight = nil, Connections = {}, Removing = setmetatable({}, {__mode = "k"}), Last = 0}
    u1070.target_player = T

    function T.PlayerList()
        local list = {}
        for _, player in ipairs(u1054:GetPlayers()) do
            if player ~= u1061 and not T.Removing[player] then table.insert(list, player.Name) end
        end
        table.sort(list)
        if #list == 0 then list = {"no players"} end
        return list
    end
    function T.Resolve()
        if T.Destroyed or T.Name == "" then return nil end
        local player = u1054:FindFirstChild(T.Name)
        if player == u1061 or T.Removing[player] then return nil end
        return player
    end
    function T.FindCharacter(folder, player)
        if not folder or not player then return nil end
        local character = folder:FindFirstChild(player.Name, true)
        if not character and type(player.DisplayName) == "string" then character = folder:FindFirstChild(player.DisplayName, true) end
        if character and character:IsA("Model") then return character end
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") then
                local id = model:GetAttribute("UserId") or model:GetAttribute("UserID") or model:GetAttribute("User")
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if id ~= nil and player.UserId ~= nil and tostring(id) == tostring(player.UserId)
                    or model.Name == player.Name or model.Name == player.DisplayName
                    or humanoid and humanoid.DisplayName and (humanoid.DisplayName == player.DisplayName or humanoid.DisplayName == player.Name) then
                    return model
                end
            end
        end
    end
    function T.AliveCharacter(player)
        if not player or player == u1061 or T.Removing[player] then return nil end
        local folder = u797:FindFirstChild("Alive")
        local character = player.Character
        if character and character.Parent then
            if folder and character.Parent ~= folder then return nil end
        else
            character = T.FindCharacter(folder, player)
        end
        if not character or not character.Parent then return nil end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then return nil end
        return character
    end
    function T.RootOf(character)
        return character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head"))
    end
    function T.Character()
        if not T.Ready or not T.Enabled or T.Destroyed then return nil end
        return T.AliveCharacter(T.Resolve())
    end
    function T.GetAim(context)
        if context and context.AimRead then return context.Aim end
        if context then context.AimRead = true end
        local character = T.Character()
        local targetRoot = T.RootOf(character)
        local mine = u1061.Character
        local myRoot = mine and (mine.PrimaryPart or mine:FindFirstChild("HumanoidRootPart"))
        local camera = context and context.Camera or u797.CurrentCamera or u1062
        if not character or not targetRoot or not myRoot or not camera then return nil end
        if (myRoot.Position - targetRoot.Position).Magnitude < 0.001 then return nil end
        local ok, screenPoint = pcall(function() return camera:WorldToScreenPoint(targetRoot.Position) end)
        if not ok or not screenPoint then return nil end
        if screenPoint.Z <= 0 then
            local viewport = camera.ViewportSize
            screenPoint = Vector3.new(math.clamp(screenPoint.X, 0, viewport.X), math.clamp(screenPoint.Y, 0, viewport.Y), 0)
        end
        local aim = {Frame = u819.lookAt(myRoot.Position, targetRoot.Position),
            Coordinates = {screenPoint.X, screenPoint.Y}, Points = {[character.Name] = screenPoint}}
        if context then context.Aim = aim end
        return aim
    end
    function T.SyncConfig()
        u1070.config.target_player_enabled = T.Ready and T.Enabled and not T.Destroyed
        u1070.config.target_player_name = T.Name ~= "" and T.Name or nil
    end
    function T.RefreshHighlight()
        local character = T.Ready and not T.Destroyed and T.HighlightEnabled and T.AliveCharacter(T.Resolve()) or nil
        local highlight = T.Highlight
        if highlight and (not character or highlight.Parent ~= character) then
            highlight:Destroy(); highlight = nil; T.Highlight = nil
        end
        if character and not highlight then
            highlight = u859.new("Highlight")
            highlight.Name = "AllusiveTargetPlayerHighlight"
            highlight.Adornee = character
            highlight.FillColor = u820.fromRGB(30, 110, 255)
            highlight.FillTransparency = 0.55
            highlight.OutlineColor = u820.fromRGB(90, 165, 255)
            highlight.OutlineTransparency = 0
            highlight.DepthMode = u824.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
            T.Highlight = highlight
        end
    end
    function T.NextTarget()
        local folder = u797:FindFirstChild("Alive")
        local mine = u1061.Character
        local myRoot = mine and (mine.PrimaryPart or mine:FindFirstChild("HumanoidRootPart"))
        local best, bestDistance = nil, math.huge
        if not folder or not myRoot then return nil end
        for _, model in ipairs(folder:GetChildren()) do
            local player = u1054:GetPlayerFromCharacter(model)
            local character = player and player ~= u1061 and T.AliveCharacter(player)
            local root = character == model and T.RootOf(model)
            if root then
                local distance = (myRoot.Position - root.Position).Magnitude
                if distance < bestDistance then best, bestDistance = player, distance end
            end
        end
        return best
    end
    function T.SyncDropdown()
        local dropdown = T.Dropdown
        if not dropdown or type(dropdown.update) ~= "function" then return end
        local list = T.PlayerList()
        local display = T.Name ~= "" and T.Name or list[1] == "no players" and "no players" or "No target"
        T.Syncing = true
        local ok, err = pcall(function() dropdown:update(display) end)
        T.Syncing = false
        if not ok then T.LastError = tostring(err) end
    end
    function T.SetTarget(name, notify, fromDropdown)
        if T.Destroyed or T.Syncing then return end
        if type(name) == "table" then name = name.Name or name[1] end
        if type(name) ~= "string" or name == "no players" or name == "No target" or name == u1061.Name then name = "" end
        local changed = T.Name ~= name
        T.Name = name
        T.SyncConfig()
        if not fromDropdown then T.SyncDropdown() end
        T.RefreshHighlight()
        if notify and changed then
            pcall(u864.SendNotification, {title = "Target Player", text = "Target Player -> " .. name, duration = 3})
        end
    end
    function T.RefreshList()
        if T.Destroyed then return end
        local dropdown = T.Dropdown
        if not dropdown or type(dropdown.set_options) ~= "function" then return end
        T.Syncing = true
        local ok, err = pcall(function() dropdown:set_options(T.PlayerList()) end)
        T.Syncing = false
        if not ok then T.LastError = tostring(err) end
         
         
        T.SyncDropdown()
    end
    function T.SetEnabled(enabled)
        if T.Destroyed then return end
        T.Enabled = enabled == true
        T.SyncConfig()
        T.RefreshHighlight()
    end
    function T.SetKillSwitch(enabled)
        if not T.Destroyed then T.KillSwitch = enabled == true end
    end
    function T.SetHighlight(enabled)
        if T.Destroyed then return end
        T.HighlightEnabled = enabled == true
        T.RefreshHighlight()
    end
    function T.Loop()
        if T.Destroyed or not T.Ready then return end
        local now = u817()
        if now - T.Last < 0.25 then return end
        T.Last = now
        if not (T.Enabled or T.HighlightEnabled) then
            if T.Highlight then T.RefreshHighlight() end
            return
        end
        if not T.AliveCharacter(T.Resolve()) and T.KillSwitch then
            local nextPlayer = T.NextTarget()
            if nextPlayer then T.SetTarget(nextPlayer.Name, true); return end
        end
        T.RefreshHighlight()
    end
    function T.Destroy()
        if T.Destroyed then return end
        T.Destroyed, T.Enabled, T.HighlightEnabled = true, false, false
        T.SyncConfig()
        for _, connection in ipairs(T.Connections) do connection:Disconnect() end
        table.clear(T.Connections)
        if T.Highlight then T.Highlight:Destroy(); T.Highlight = nil end
        T.Dropdown = nil
        table.clear(T.Removing)
    end
    table.insert(T.Connections, u1054.PlayerAdded:Connect(function(player)
        if T.Destroyed then return end
        T.Removing[player] = nil
        T.RefreshList()
    end))
    table.insert(T.Connections, u1054.PlayerRemoving:Connect(function(player)
        if T.Destroyed then return end
         
        T.Removing[player] = true
        T.RefreshList()
        T.RefreshHighlight()
    end))
    table.insert(T.Connections, u1063:Connect(T.Loop))
    if u839 then table.insert(T.Connections, u839.Destroying:Connect(T.Destroy)) end
end

 
do
    local O = {Connections = {}, Destroyed = false, Busy = false}
    u1070.optimization = O
    local localPlayer = u1061
    local sapphireBBState = O
    local features = {UnlockAll = {GetSwordData = function(name)
        local inventory = u1070.sapphire_misc and u1070.sapphire_misc.Features.UnlockAll
        return inventory and type(inventory.GetSwordData) == "function" and inventory.GetSwordData(name)
    end}}
    O.Features = features
    local newRoot = workspace:FindFirstChild("Runtime")
    local playerGui = workspace:FindFirstChild("Balls")
    local CoreGui = workspace:FindFirstChild("TrainingBalls")
    local function cleanupResources(connections)
        for _, connection in pairs(connections) do pcall(function() connection:Disconnect() end) end
    end
    local function coroutineFunction(name)
        local connection = O.Connections[name]
        O.Connections[name] = nil
        if connection then pcall(function() connection:Disconnect() end) end
    end
    function O.Notify(text)
        if not O.Destroyed then pcall(u864.SendNotification, {title = "Sapphire • Optimization", text = tostring(text), duration = 5}) end
    end
    features.LoadRender = function()
        local lines = {
            BallEmit = true,
            Upgrade = true,
            Arch2 = true,
            MaxHook = true,
            Wave = true,
            Totem = true,
            TotemRange = true,
            InfinityFX = true,
            maxTransmission = true,
            transmissionpart = true,
            Tornado = true,
            Barrier = true,
            GUARDIAN_DRAGON = true,
            DRAGON_POSITIONER = true,
            SpiritDeflect = true,
            Vanity = true,
            dash = true,
            Summon = true,
            MaxBlink = true,
        }

        features.Render = {}
        local sourceTable = { Spawn = true, Rhythm = true, Leaderboards = true, Map = true, UiClaimer = true }

        local players = {
            ParticleEmitter = true,
            Beam = true,
            Trail = true,
            Smoke = true,
            Fire = true,
            Sparkles = true,
            PointLight = true,
            SpotLight = true,
            SurfaceLight = true,
        }

        local targetTransparency = NumberSequence.new(1)

        local sorted = {
            "Workspace.Spawn.Limited",
            "Workspace.Spawn.ItemDuelsNPC",
            "Workspace.Spawn.AFK",
            "Workspace.Spawn.GroupCrate",
            "Workspace.Spawn.Portal",
            "Workspace.Spawn.ExplosionCratesSign",
            "Workspace.Spawn.SwordCratesSign",
            "Workspace.Spawn.MenuRings",
            "Workspace.Spawn.Spinnyy",
            "Workspace.Leaderboards",
            "Workspace.Rhythm.Runtime.Map.Decoration",
            "Workspace.Rhythm.Runtime.Map.Visuals",
            "Workspace.Rhythm.Track",
        }

        local neighbors = {}

        local function onInputEnded(line)
            local tree = line.ClassName
            return tree == "Sound" or tree:find("Audio", 1, true) ~= nil
        end

        local function handlePlayerRemoving(line)
            local radians = playerGui ~= nil and line:IsDescendantOf(playerGui)
            local cell

            if radians then
                cell = radians
            else
                cell = CoreGui ~= nil and line:IsDescendantOf(CoreGui)
            end

            return cell
        end

        local function onTouched(line)
            while line and line.Parent and line.Parent ~= workspace do
                line = line.Parent
            end

            return line and sourceTable[line.Name] == true
        end

        local function heartbeatUpdate(line)
            local sourceString = line:GetFullName()

            for _, particle in pairs(sorted) do
                if sourceString == particle or sourceString:sub(1, #particle + 1) == particle .. "." then
                    return true
                end
            end

            return false
        end

        local function onInputChanged(line)
            if line:IsA("Model") and features.UnlockAll.GetSwordData(line.Name) then
                return true
            end
            local checkpointFolder = line.Parent

            while checkpointFolder and checkpointFolder ~= workspace and checkpointFolder ~= newRoot do
                if checkpointFolder:IsA("Model") and features.UnlockAll.GetSwordData(checkpointFolder.Name) then
                    return true
                end
                local radians = string.lower(checkpointFolder.Name)
                if radians == "sord" or radians == "blade" then
                    return true
                end
                checkpointFolder = checkpointFolder.Parent
            end

            return false
        end

        local function vectorLength(line, object)
            sapphireBBState.RenderCache = sapphireBBState.RenderCache or {}
            local sample = sapphireBBState.RenderCache[line]

            if not sample then
                sample = {}
                sapphireBBState.RenderCache[line] = sample
            end

            for vertex, particle in pairs(object) do
                if sample[vertex] == nil then
                    sample[vertex] = line[vertex]
                end

                line[vertex] = particle
            end
        end

        local function vectorAdd()
            local generator = sapphireBBState.RenderCache
            sapphireBBState.RenderCache = nil
            if not generator then
                return
            end

            local function targetFunction(line, object)
                for vertex, particle in pairs(object) do
                    line[vertex] = particle
                end
            end

            for vertex, particle in pairs(generator) do
                if vertex.Parent then
                    targetFunction(vertex, particle)
                else
                    pcall(targetFunction, vertex, particle)
                end
            end
        end

        local function targetFunction(line, object, descendant)
            if onInputEnded(line) then
                return
            end

            if line:IsA("Highlight") then
                return
            end

            if players[line.ClassName] then
                if line:IsA("ParticleEmitter") or line:IsA("Beam") or line:IsA("Trail") then
                    vectorLength(line, { Enabled = false, Transparency = targetTransparency })
                else
                    vectorLength(line, { Enabled = false })
                end

                if line:IsA("ParticleEmitter") then
                    line:Clear()
                end
            elseif line:IsA("Decal") or line:IsA("Texture") then
                vectorLength(line, { Transparency = 1 })
            elseif descendant and (line:IsA("SurfaceGui") or line:IsA("BillboardGui")) then
                vectorLength(line, { Enabled = false })
            elseif line:IsA("BasePart") then
                if handlePlayerRemoving(line) then
                    return
                end

                if object or (heartbeatUpdate(line) or neighbors[line]) and not onInputChanged(line) then
                    vectorLength(line, { LocalTransparencyModifier = 1, CanCollide = false, CanTouch = false, CanQuery = false })
                end
            end
        end

        local function cleanup(line)
            while line and line.Parent and line.Parent ~= newRoot do
                line = line.Parent
            end

            return line and line.Parent == newRoot and line
        end

        local function createNode(line)
            if not line or not line.Parent then
                return
            end

            if newRoot and line:IsDescendantOf(newRoot) then
                local rootFirst = cleanup(line)

                if rootFirst then
                    rootFirst = rootFirst.Name:find("PortalFor_") or rootFirst.Name:find("WaypointFor_") or lines[rootFirst.Name]
                end

                if rootFirst then
                    return
                end
                targetFunction(line, true, false)
            elseif (line:IsA("SurfaceGui") or line:IsA("BillboardGui")) and onTouched(line) then
                targetFunction(line, false, true)
            else
                targetFunction(line, false)
            end
        end

        features.Render.DisableFX = function(eventData)
            sapphireBBState.NoRender = eventData
            coroutineFunction("Render Workspace")

            if not eventData then
                vectorAdd()
                table.clear(neighbors)
                return
            end

            local lastTime = workspace:GetDescendants()
            table.clear(neighbors)

            for _, particle in pairs(lastTime) do
                if onInputEnded(particle) then
                    local points = particle:FindFirstAncestorWhichIsA("BasePart")

                    if points and not handlePlayerRemoving(points) then
                        neighbors[points] = true
                    end
                end
            end

            for _, particle in pairs(lastTime) do
                createNode(particle)
            end

            sapphireBBState.Connections["Render Workspace"] = workspace.DescendantAdded:Connect(function(hit)
                    if not sapphireBBState.NoRender then
                        return
                    end

                    if onInputEnded(hit) then
                        local points = hit:FindFirstAncestorWhichIsA("BasePart")

                        if points and not handlePlayerRemoving(points) then
                            neighbors[points] = true
                            targetFunction(points, false)
                        end

                        return
                    end

                    createNode(hit)
                end)
        end

        local sample = { BloomEffect = true, BlurEffect = true, DepthOfFieldEffect = true, SunRaysEffect = true }

        local function generateRandomString(line, object, descendant)
            sapphireBBState.AntiLagCache = sapphireBBState.AntiLagCache or {}
            local result57 = sapphireBBState.AntiLagCache[line]

            if not result57 then
                result57 = {}
                sapphireBBState.AntiLagCache[line] = result57
            end

            if result57[object] == nil then
                result57[object] = line[object]
            end

            line[object] = descendant
        end

        local function createClass()
            sapphireBBState.AntiLag = false
            sapphireBBState.AntiLagRestore = nil
            cleanupResources(sapphireBBState.AntiLagConnections or {})
            sapphireBBState.AntiLagConnections = nil
            local duration = sapphireBBState.AntiLagCache
            sapphireBBState.AntiLagCache = nil
            duration = duration or {}

            for vertex, particle in pairs(duration) do
                pcall(function()
                        for neighbor, existingPlayer in pairs(particle) do
                            vertex[neighbor] = existingPlayer
                        end
                    end)
            end
        end

        local function onHumanoidDied(hit)
            if not sapphireBBState.AntiLag then
                return
            end
            local tree = hit.ClassName

            if tree == "Atmosphere" then
                generateRandomString(hit, "Density", 0)
                generateRandomString(hit, "Haze", 0)
                generateRandomString(hit, "Glare", 0)
                return
            end

            if tree == "Clouds" then
                generateRandomString(hit, "Enabled", false)
                return
            end

            if not sample[tree] then
                return
            end
            local duration = sapphireBBState.AntiLagCache and sapphireBBState.AntiLagCache[hit]
            if duration and duration.Enabled ~= nil then
                return
            end
            generateRandomString(hit, "Enabled", false)

            sapphireBBState.AntiLagConnections[#sapphireBBState.AntiLagConnections + 1] = hit:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if sapphireBBState.AntiLag and hit.Enabled then
                        hit.Enabled = false
                    end
                end)
        end

        features.Render.SetAntiLag = function(line)
            createClass()
            if not line then
                return
            end
            sapphireBBState.AntiLag = true
            sapphireBBState.AntiLagConnections = {}
            sapphireBBState.AntiLagRestore = createClass
            local TweenService = game:GetService("Lighting")
            local Terrain = workspace.Terrain
            local result20 = Enum.QualityLevel.Level01
            generateRandomString(settings().Rendering, "QualityLevel", result20)
            generateRandomString(TweenService, "GlobalShadows", false)
            generateRandomString(TweenService, "EnvironmentDiffuseScale", 0)
            generateRandomString(TweenService, "EnvironmentSpecularScale", 0)
            generateRandomString(Terrain, "WaterWaveSize", 0)
            generateRandomString(Terrain, "WaterWaveSpeed", 0)
            generateRandomString(Terrain, "WaterReflectance", 0)

            local function subtractVectors(object)
                if not object then
                    return
                end

                for _, particle in object:GetDescendants() do
                    onHumanoidDied(particle)
                end

                sapphireBBState.AntiLagConnections[#sapphireBBState.AntiLagConnections + 1] = object.DescendantAdded:Connect(onHumanoidDied)
            end

            subtractVectors(TweenService)
            subtractVectors(Terrain)
            subtractVectors(workspace.CurrentCamera)

            sapphireBBState.AntiLagConnections[#sapphireBBState.AntiLagConnections + 1] = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                    subtractVectors(workspace.CurrentCamera)
                end)
        end
    end

    features.LoadRender()
    function O.Preset(line)
        return {
                    FFlagGraphicsDisableShadows = "True",
                    FFlagDebugGraphicsDisableShadows = "True",
                    FFlagGraphicsDisablePostEffects = "True",
                    FFlagDisablePostFx = "True",
                    FFlagDisablePostEffect = "True",
                    FFlagGraphicsDisableParticles = "True",
                    FFlagDisableScreenSpaceEffects = "True",
                    FFlagDebugDisableLightingEffects = "True",
                    FFlagDisableLightInfluence = "True",
                    FIntRenderQualityLevel = "1",
                    FIntQualityLevel = "1",
                    FFlagGraphicsQualityAutoAdjust = "False",
                    FIntMockClientLightingTechnologyIxpExperimentMode = "0",
                    FIntMockClientLightingTechnologyIxpExperimentQualityLevel = "7",
                    DFIntDebugFRMQualityLevelOverride = "3",
                    DFFlagTextureQualityOverrideEnabled = "True",
                    DFIntTextureQualityOverride = "0",
                    FIntTextureLODOverride = "3",
                    FIntAvatarTextureLOD = "3",
                    FIntFRMMinGrassDistance = "0",
                    FIntFRMMaxGrassDistance = "0",
                    FIntRenderGrassDetailStrands = "0",
                    FFlagDebugDisableTerrainDecoration = "True",
                    FIntAvatarHeadMeshQuality = "0",
                    FIntAvatarBodyMeshQuality = "0",
                    FFlagDebugSkipAvatarMaterials = "True",
                    FFlagEnableAvatarStreaming = "True",
                    FFlagEnableAvatarLoadingSuppression = "True",
                    FFlagHumanoidAutoLOD = "True",
                    FFlagEnableHumanoidLOD = "True",
                    FFlagDebugForceLowMeshAvatars = "True",
                    FFlagLowQualityCharacterRendering = "True",
                    FIntAvatarAccessoryRenderDistance = "0",
                    FIntAvatarLoadTimeoutMS = "0",
                    FFlagAvatarRenderingOptimization = "True",
                    FFlagRenderLocalCharacter = "False",
                    FFlagForceStreamOutCharacters = "True",
                    FIntMeshPartDetailLevel = "0",
                    FFlagDisableSunRays = "True",
                    FFlagDisableWeather = "True",
                    FFlagDisableAtmosphere = "True",
                    FFlagDebugDisableWaterEffects = "True",
                    FFlagDisableMaterialEffects = "True",
                    FFlagForceSimpleMaterials = "True",
                    FFlagSkipDecals = "True",
                    FFlagDisableCameraShake = "True",
                    FFlagNewLightAttenuation = "True",
                    DFFlagDisableFrameRateSmoothing = "True",
                    FFlagDisableRenderingThrottling = "True",
                    DFIntPerformanceControlFrameTimeMax = "1",
                    FFlagForceLowMemoryMode = "True",
                    FFlagDebugLowMemoryMode = "True",
                    FIntVideoMemoryLimitMB = "256",
                    FFlagLowDetailMode = "True",
                    FFlagUIQualityReductionEnabled = "True",
                    FFlagSkipQualityReductionInLowMemory = "True",
                    FIntUIQualityReductionLevel = "3",
                    FIntRobloxGuiBlurIntensity = "0",
                    FFlagEnableRegionSelectionOverride = "True",
                    FFlagDebugUseOnlySpecifiedRegion = "True",
                    DFIntLargePacketQueueSizeCutoffMB = "1000",
                    DFIntClientPacketHealthyAllocationPercent = "50",
                    FIntRakNetResendBufferArrayLength = "128",
                    DFIntWaitOnUpdateNetworkLoopEndedMS = "100",
                    DFIntWaitOnRecvFromLoopEndedMS = "100",
                    DFIntCodecMaxOutgoingFrames = "10000",
                    DFIntCodecMaxIncomingPackets = "100",
                    DFIntMaxFrameBufferSize = "4",
                    DFIntMaxProcessPacketsStepsPerCyclic = "5000",
                    DFIntMaxProcessPacketsJobScaling = "2139999999",
                    DFIntConnectionMTUSize = "1396",
                    DFIntClientPacketMaxDelayMs = "1",
                    DFIntRakNetLoopMs = "1",
                    DFIntMaxFramesToSend = "1",
                    DFIntMaxProcessPacketsStepsAccumulated = "0",
                    DFIntRakNetResendRttMultiple = "1",
                    DFIntRakNetClockDriftAdjustmentPerPingMillisecond = "2139999999",
                    DFIntRaknetBandwidthPingSendEveryXSeconds = "1",
                    DFIntRaknetBandwidthInfluxHundredthsPercentageV2 = "10000",
                    FIntInterpolationMaxDelayMSec = "1",
                    FIntInterpolationAwareTargetTimeLerpHundredth = "100",
                    DFIntParallelAdaptiveInterpolationBatchCount = "1",
                    DFIntInterpolationDtLimitForLod = "1",
                    FFlagDebugDisableTelemetryV2Event = "True",
                    FFlagDebugDisableTelemetryEphemeralStat = "True",
                    FFlagDebugDisableTelemetryEventIngest = "True",
                    FFlagDebugDisableTelemetryV2Stat = "True",
                    FFlagDebugDisableTelemetryV2Counter = "True",
                    FFlagDebugDisableTelemetryEphemeralCounter = "True",
                    FFlagDebugDisableTelemetryPoint = "True",
                    DFIntClientLightingTechnologyChangedTelemetryHundredthsPercent = "0",
                    DFIntTrackCountryRegionAPIHundredthsPercent = "10000",
                    DFIntClientLightingEnvmapPlacementTelemetryHundredthsPercent = "100",
                    FFlagEnableFastPathRendering = "True",
                    FFlagEnableMeshLODStreaming = "True",
                    FFlagMovePrerenderV2 = "True",
                    FFlagMovePrerender = "true",
                    FFlagFastGPULightCulling3 = "True",
                    FFlagRenderForceLowQualityDOF = "True",
                    FFlagPreferLowQualityParts = "True",
                    FFlagDebugGraphicsPreferLowQuality = "True",
                    FIntSimSolverResponsiveness = "2147483647",
                    DFFlagSimRefactorCollisionGeometry2 = "true",
                    DFFlagSimOptimizeSetSize = "true",
                    DFFlagSimSolverOptimizeGeometricStiffness4 = "true",
                    DFFlagSimHumanoidPhysics = "true",
                    FIntDebugTextureManagerSkipMips = "0",
                    FIntNumFramesToCaptureCallStack = "1",
                    FFlagDebugDisplayFPS = "true",
                    FFlagDebugSkyGray = "true",
                    FIntFullscreenTitleBarTriggerDelayMillis = "18000000",
                    FFlagHandleAltEnterFullscreenManually = "False",
                    FIntActivatedCountTimerMSMouse = "0",
                    FIntActivatedCountTimerMSKeyboard = "0",
                    FIntCLI20390 = "-1",
                    FLogNetwork = "7",
                    DFFlagDebugPerfMode = "True",
                    DFIntParryHitboxSize = "23",
                    FIntHitboxPredictionBuffer = "40",
                    DFFlagEnableCustomHitbox = "true",
                    DFFlagCorrectServerReplicatorStatsIP = "True",
                    DFIntMaxAverageFrameDelayExceedFactor = "0",
                    DFIntNumFramesAllowedToBeAboveError = "0",
                    DFFlagRakNetUnblockSelectOnShutdownByWritingToSocket = "True",
                    DFFlagGameNetFixReplicationSkipBug = "True",
                    DFFlagCorrectCachePolicySkipRedirectCache = "True",
                    DFFlagAnimatorFixReplicationASANError = "True",
                    DFFlagRakNetFixBwCollapse = "False",
                    FFlagEnableInGameMenuDurationLogger = "False",
                    DFFlagRakNetDecoupleRecvAndUpdateLoopShutdown = "True",
                    FFlagPushFrameTimeToHarmony = "True",
                    DFFlagRakNetUseSlidingWindow4 = "True",
                    FFlagAnimatorRetargetSkipAnkleModification = "True",
                    DFFlagSkipSomePropertiesSkip = "True",
                    DFFlagSkipReadDiskCacheRedirects = "True",
                    DFFlagSkipSomeProperties = "True",
                    DFFlagReplicatorCheckReadTableCollisions = "True",
                    DFFlagDisableDPIScale = "False",
                    DFFlagJointIrregularityOptimization = "True",
                    DFFlagReplicateCreateToPlayer = "True",
                    DFFlagDebugLargeReplicatorForceFullSend = "True",
                    FFlagEnableZstdDictionaryForClientSettings = "False",
                    FFlagOnlyDecrementCompletenessIfReplicating = "True",
                    FFlagDebugDisableOptimizedBytecode = "False",
                    DFFlagReplicatorSeparateVarThresholds = "True",
                    FFlagEnableZstdForClientSettings = "False",
                    FFlagFasterPreciseTime4 = "True",
                    FFlagDebugCodegenOptSize = "True",
                    FFlagQuaternionPoseCorrection = "True",
                    DFFlagAnimatorAnywhere = "True",
                    InterpolationAwareTargetTimeLerpHundredth = "100",
                    MaxAverageFrameDelayExceedFactor = "0",
                    TargetTimeDelayFacctorTenths = "0",
                    FIntFontSizePadding = "2",
                    DFIntCSGLevelOfDetailSwitchingDistance = "0",
                    DFIntCSGLevelOfDetailSwitchingDistanceL12 = "0",
                    DFIntCSGLevelOfDetailSwitchingDistanceL34 = "0",
                    DFIntCSGLevelOfDetailSwitchingDistanceL23 = "0",
                    DebugDisplayFPS = "True",
                    FStringNetworkDefaultDNSResolveRegion = line,
                    FStringForceHttpProxyRegion = line,
                    FStringForceFastConnectRegion = line,
                    FStringPreferredClientRegion = line,
                    FStringMatchmakingRegion = line,
                    FStringDataStoreRegion = line,
                    FStringClientTelemetryRegionOverride = line,
                    FStringForceRegion = line,
                    FStringOverrideRegion = line,
                    FStringForceGameServerRegion = line,
                }
    end
     
    local environment = type(getgenv) == "function" and getgenv() or _G
    local httpService = game:GetService("HttpService")
    local regions = {
        {"US East (Virginia / New Jersey)", "us-east"},
        {"US Central (Illinois / Texas)", "us-central"},
        {"US West (California / Washington)", "us-west"},
        {"US South (Florida / Georgia)", "us-south"},
        {"Europe West (France / Netherlands / UK)", "eu-west"},
        {"Europe Central (Germany)", "eu-central"},
        {"Asia East (Hong Kong / Japan)", "as-east"},
        {"Southeast Asia (Singapore)", "as-southeast"},
        {"South Asia (India)", "as-south"},
        {"Oceania (Australia)", "oceania"},
        {"South America (Brazil)", "sa-east"}
    }
    O.RegionNames, O.RegionCodes = {}, {}
    for _, region in ipairs(regions) do
        table.insert(O.RegionNames, region[1]); O.RegionCodes[region[1]] = region[2]
    end
    O.Region, O.Custom, O.CustomText = O.RegionNames[1], false, ""
    function O.Parse(text)
        text = tostring(text or ""):gsub("^\u{FEFF}", ""):match("^%s*(.-)%s*$")
        if text == "" then return nil, "Custom FFlags is empty." end
        local ok, value = pcall(httpService.JSONDecode, httpService, text)
        if ok and type(value) == "string" then ok, value = pcall(httpService.JSONDecode, httpService, value) end
        if not ok or type(value) ~= "table" then return nil, "Invalid custom FFlags JSON object." end
        if next(value) == nil then return nil, "Custom FFlags is empty." end
        for key, entry in pairs(value) do
            if type(key) ~= "string" or key == "" or not ({string=true, number=true, boolean=true, table=true})[type(entry)] then
                return nil, "Custom FFlags must be a JSON object with named flags."
            end
        end
        return value
    end
    function O.DefaultFlags()
        local line = O.RegionCodes[O.Region] or "us-east"
        return O.Preset(line)
    end
    function O.ApplyFlags(restore)
        if O.Destroyed or O.Busy then return false end
        if type(setfflag) ~= "function" or type(getfflag) ~= "function" then
            O.Notify("FFlags requires executor support for getfflag and setfflag."); return false
        end
        local queue = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if type(queue) ~= "function" then O.Notify("Apply & Rejoin requires teleport queue support."); return false end
        local values, err
        if restore then
            values = environment.SapphireFFlagDefaults
            if type(values) ~= "table" or next(values) == nil then O.Notify("No saved FFlags to restore."); return false end
        elseif O.Custom then values, err = O.Parse(O.CustomText)
        else values = O.DefaultFlags() end
        if not values then O.Notify(err); return false end
        O.Busy = true
        task.spawn(function()
            local previous, committed = {}, false
            local ok, failure = pcall(function()
                local defaults = table.clone(environment.SapphireFFlagDefaults or {})
                local selected, keys = {}, {}
                for key in pairs(values) do table.insert(keys, key) end
                table.sort(keys)
                for i, key in ipairs(keys) do
                    if O.Destroyed then break end
                    local name = restore and key or key:gsub("^D?F[FISL][a-z]*", "")
                    local readable, original = pcall(getfflag, name)
                    if readable and original ~= nil then
                        local value = values[key]
                        if type(value) == "table" then value = httpService:JSONEncode(value)
                        elseif type(value) == "boolean" then value = value and "True" or "False"
                        else value = tostring(value) end
                        if pcall(setfflag, name, value) then
                            if previous[name] == nil then previous[name] = original end
                            selected[name] = value
                            if defaults[name] == nil then defaults[name] = original end
                        end
                    end
                    if i % (O.Custom and 60 or 10) == 0 then task.wait(O.Custom and 0.01 or 0.07) end
                end
                if O.Destroyed then return end
                if next(selected) == nil then O.Notify("No supported FFlags were applied; no rejoin performed."); return end
                 
                local payload = string.format([[local H=game:GetService("HttpService")
local E=type(getgenv)=="function" and getgenv() or _G
local V=H:JSONDecode(%q)
E.SapphireFFlagDefaults=H:JSONDecode(%q)
E.SapphireFFlagsApplied=%s
if type(setfflag)=="function" then for K,X in pairs(V) do pcall(setfflag,K,X) end end]],
                    httpService:JSONEncode(selected), httpService:JSONEncode(restore and {} or defaults), restore and "nil" or "true")
                local queued, queueError = pcall(queue, payload)
                if not queued then error("Could not queue flags; changes rolled back: " .. tostring(queueError)) end
                committed = true
                environment.SapphireFFlagDefaults = restore and {} or defaults
                environment.SapphireFFlagsApplied = not restore and true or nil
                O.Notify(restore and "FFlags restored. Rejoining..." or "FFlags applied. Rejoining...")
                task.wait(O.Custom and 0.04 or 0.5)
                if O.Destroyed then return end
                local teleport = game:GetService("TeleportService")
                if game.JobId ~= "" then teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
                else teleport:Teleport(game.PlaceId, localPlayer) end
            end)
            if not committed then
                for name, value in pairs(previous) do pcall(setfflag, name, tostring(value)) end
            end
            O.Busy = false
            if not ok then O.Notify("FFlags: " .. tostring(failure)) end
        end)
        return true
    end
    function O.SetNoRender(enabled)
        if O.Destroyed then return end
        newRoot = workspace:FindFirstChild("Runtime")
        playerGui, CoreGui = workspace:FindFirstChild("Balls"), workspace:FindFirstChild("TrainingBalls")
        local ok, err = pcall(features.Render.DisableFX, enabled == true)
        if not ok then
            pcall(features.Render.DisableFX, false)
            O.Notify("No Render: " .. tostring(err))
        end
    end
    function O.SetAntiLag(enabled)
        if O.Destroyed then return end
        local ok, err = pcall(features.Render.SetAntiLag, enabled == true)
        if not ok then
            pcall(features.Render.SetAntiLag, false)
            O.Notify("Anti-Lag: " .. tostring(err))
        end
    end
    function O.Destroy()
        if O.Destroyed then return end
        O.Destroyed = true
        pcall(features.Render.DisableFX, false)
        pcall(features.Render.SetAntiLag, false)
        cleanupResources(O.Connections)
        table.clear(O.Connections)
    end
    if u839 then O.Connections.Cleanup = u839.Destroying:Connect(O.Destroy) end
end
 

u1070.animation.init()
u1070.avatar_changer.save_original()
__S[5] = __S[84]:create_tab("Combat", "sword")
__S[6] = __S[84]:create_tab("Detections", "shield")
__S[7] = __S[84]:create_tab("Visuals", "eye")
__S[8] = __S[84]:create_tab("Player", "user")
__S[11] = __S[84]:create_tab("Blatant", "skull")
__S[12] = __S[84]:create_tab("Misc", "settings")

 
do
    local tab = __S[84]:create_tab("Optimization", "rbxassetid://10709813383")
    local O = u1070.optimization
    local saved = u864._config._flags
    local function renderCard(title, description, flag, setter)
        local initial, building = saved[flag], true
        local card = tab:create_module({
            title = title, description = description, section = "left", flag = flag,
            callback = function(enabled)
                if building and initial == false then enabled = false end
                setter(enabled)
            end
        })
        if initial == false then card:change_state(false) end
        building = false
        return card
    end
    renderCard("No Render", "disables visual effects and selected map decorations while preserving balls, sounds and ability indicators",
        "optimization_no_render", O.SetNoRender)
    renderCard("Anti-Lag", "reduces lighting quality, shadows, water effects and post-processing; restores previous values when disabled",
        "optimization_anti_lag", O.SetAntiLag)
    local panel = tab:create_module({
        title = "FFlags", description = "applies client flags supported by your executor; region hints do not guarantee server location",
        section = "right", flag = "optimization_fflags_panel", callback = function() end
    })
    panel:create_checkbox({
        title = "Custom FFlags", flag = "optimization_custom_fflags",
        callback = function(enabled) O.Custom = enabled == true end
    })
    panel:create_dropdown({
        title = "Region", flag = "optimization_fflags_region", options = O.RegionNames,
        maximum_options = 5, multi_dropdown = false,
        callback = function(region) O.Region = O.RegionCodes[region] and region or O.RegionNames[1] end
    })
    panel:create_textbox({
        title = "Custom FFlags JSON", flag = "optimization_fflags_json", placeholder = '{"FFlagExample":"True"}',
        callback = function(text) O.CustomText = text end
    })
    panel:create_feature({
        title = "Apply & Rejoin", flag = "optimization_fflags_apply", momentary = true,
        button_callback = function() O.ApplyFlags(false) end
    })
    panel:create_feature({
        title = "Restore & Rejoin", flag = "optimization_fflags_restore", momentary = true,
        button_callback = function() O.ApplyFlags(true) end
    })
    panel:create_paragraph({title = "FFlags Support", customScale = 90,
        text = "Requires getfflag, setfflag and teleport queue support. Unsupported flags are skipped. Apply rejoins this server; run Sapphire again afterward. Restore uses the original values saved before Apply."})
end

 
do
    local detectionsTab, miscTab = __S[6], __S[12]
detectionsTab:create_module({
    title = "Staff Detection",
    description = "identifies staff by their official group roles",
    section = "left", flag = "staff_detection",
    callback = function(enabled) u1070.sapphire.Set("StaffDetection", enabled) end
}):create_dropdown({
    title = "Detection Mode", flag = "staff_detection_mode",
    options = {"Notify", "Kick"}, maximum_options = 2, multi_dropdown = false,
    callback = function(mode)
        u1070.staff_detection.mode = mode
        u1070.sapphire.Set("StaffDetectionMode", mode == "Kick" and "kick" or "warn")
    end
})

 
do
    local M = u1070.sapphire_misc
    local tab, saved = miscTab, u864._config._flags
    local initial = saved.sapphire_misc_unlockallenabled
    local initializing = true
    local unlock = tab:create_module({
        title = "Unlock All (Client)",
        description = "unlocks client-side inventory previews for swords, explosions, emotes and finishers; does not grant server ownership",
        section = "right", flag = "sapphire_misc_unlockallenabled", notify = true,
        callback = function(enabled)
            if initializing and initial == false then enabled = false end
            M.Set("UnlockAllEnabled", enabled)
        end
    })
    if initial == false then unlock:change_state(false) end
    initializing = false
    local device = tab:create_module({
        title = "Device Spoof",
        description = "changes the device shown on your player profile after rejoining",
        section = "left", flag = "sapphire_misc_device_panel", callback = function() end
    })
    local env = type(getgenv) == "function" and getgenv() or _G
    local applied = env.AllusiveDeviceSpoofApplied
    local name = type(applied) == "table" and applied.JobId == game.JobId and applied.Device or "PC"
    if name == "Phone" or name == "Tablet" then name = "Mobile" end
    if name ~= "Mobile" and name ~= "Console" then name = "PC" end
     
    saved.sapphire_misc_devicespooftype = name
    device:create_dropdown({
        title = "Device", flag = "sapphire_misc_devicespooftype", options = {"PC", "Mobile", "Console"},
        maximum_options = 3, multi_dropdown = false,
        callback = function(value) M.Set("DeviceSpoofType", value) end
    })
    device:create_feature({
        title = "Apply & Rejoin", flag = "sapphire_misc_device_apply", momentary = true,
        button_callback = function() M.ApplyDevice() end
    })
    device:create_paragraph({title = "Apply", text = "Apply rejoins this server. Run Allusive again afterward. Requires teleport queue support."})
    M.Commit()
end

end

do
    local tab, saved = __S[12], u864._config._flags
    local autoSaved = saved.sapphire_misc_auto_play
    local autoBuilding = true
    local autoPlay = tab:create_module({
        title = "Auto Play", description = "moves and plays automatically using the selected mode",
        section = "left", flag = "sapphire_misc_auto_play", notify = true,
        callback = function(enabled)
            if autoBuilding and autoSaved == false then enabled = false end
            u1070.sapphire.Flags.AutoPlayEnabled = enabled == true
            u1070.sapphire.AutoPlay.Toggle(enabled == true)
        end
    })
    if autoSaved == false then autoPlay:change_state(false) end
    autoBuilding = false
    autoPlay:create_checkbox({
        title = "Auto Vote Map", flag = "sapphire_misc_auto_vote_map",
        callback = function(value)
            u1070.sapphire.Flags.AutoVoteMap = value == true
            if not value then table.clear(u1070.sapphire.AutoPlay.Voting) end
        end
    })
    autoPlay:create_checkbox({
        title = "Hit Freeze", flag = "sapphire_misc_hit_freeze",
        callback = function(value) u1070.sapphire.Flags.HitFreeze = value == true end
    })
    autoPlay:create_checkbox({
        title = "Spam Jump", flag = "sapphire_misc_spam_jump",
        callback = function(value)
            u1070.sapphire.Flags.SpamJump = value == true
            if not value then u1070.sapphire.AutoPlay.Jump(false) end
        end
    })
    autoPlay:create_slider({
        title = "Smoothness", flag = "sapphire_misc_auto_play_smoothness", value = 50,
        minimum_value = 1, maximum_value = 100, decimals = 0,
        callback = function(value) u1070.sapphire.Flags.AutoPlaySmoothness = value end
    })
    autoPlay:create_slider({
        title = "Aggressiveness", flag = "sapphire_misc_auto_play_aggressiveness", value = 45,
        minimum_value = 1, maximum_value = 100, decimals = 0,
        callback = function(value) u1070.sapphire.Flags.AutoPlayAggressiveness = value end
    })
    autoPlay:create_checkbox({
        title = "Anti-AFK", flag = "sapphire_misc_anti_afk",
        callback = function(value)
            u1070.sapphire.Flags.AntiAFK = value == true
            if u1070.sapphire.AFK then u1070.sapphire.AFK.Toggle(value == true) end
        end
    })
    autoPlay:create_dropdown({
        title = "Mode", flag = "sapphire_misc_auto_play_mode",
        options = {"Play Edge", "Play Middle", "Mix"}, maximum_options = 3,
        multi_dropdown = false,
        callback = function(value) u1070.sapphire.Flags.AutoPlayMode = value end
    })

    local rewardInitial = saved.sapphire_misc_rewards
    local rewardBuilding = true
    local rewards = tab:create_module({
        title = "Rewards", description = "automatically claims available rewards",
        section = "right", flag = "sapphire_misc_rewards", notify = true,
        callback = function(enabled)
            if rewardBuilding and rewardInitial == false then enabled = false end
            for _, item in ipairs(u1070.sapphire.Rewards and u1070.sapphire.Rewards.Items or {}) do
                u1070.sapphire.Flags[item.ID] = enabled == true
            end
            if u1070.sapphire.Rewards then u1070.sapphire.Rewards.Toggle() end
        end
    })
    if rewardInitial == false then rewards:change_state(false) end
    rewardBuilding = false
    for _, item in ipairs(u1070.sapphire.Rewards and u1070.sapphire.Rewards.Items or {}) do
        rewards:create_checkbox({
            title = item.Name, flag = "sapphire_misc_" .. string.lower(item.ID), notify = item.Notify == true,
            callback = function(enabled)
                u1070.sapphire.Flags[item.ID] = enabled == true
                if u1070.sapphire.Rewards then u1070.sapphire.Rewards.Toggle() end
            end
        })
    end

    local statsInitial = saved.sapphire_misc_stats
    local statsBuilding = true
    local stats = tab:create_module({
        title = "Stats", description = "shows Wins, Elims and RAP in player stats and profile cards",
        section = "right", flag = "sapphire_misc_stats", notify = true,
        callback = function(enabled)
            if statsBuilding and statsInitial == false then enabled = false end
            u1070.sapphire.Flags.ShowWins = enabled == true
            u1070.sapphire.Flags.ShowElims = enabled == true
            u1070.sapphire.Flags.ShowRAP = enabled == true
            if u1070.sapphire.Stats then u1070.sapphire.Stats.Queue() end
        end
    })
    if statsInitial == false then stats:change_state(false) end
    statsBuilding = false
    for _, entry in ipairs({{"Wins", "Show Wins"}, {"Elims", "Show Elims"}, {"RAP", "Show RAP"}}) do
        local key, label = entry[1], entry[2]
        stats:create_checkbox({
            title = label, flag = "sapphire_misc_show_" .. string.lower(key),
            callback = function(enabled)
                u1070.sapphire.Flags["Show" .. key] = enabled == true
                if u1070.sapphire.Stats then u1070.sapphire.Stats.Queue() end
            end
        })
    end
end

__S[13] = __S[5]:create_module({
    title = "Auto Parry",
    description = "automatic ball deflection",
    section = "left",
    flag = "auto_parry",
    notify = true,
    callback = function(r0)
        u1070.sapphire.SetAutoEnabled(r0)
    end
})

if u864._config._flags.auto_parry == false then __S[13]:change_state(false) end

u1070.sapphire.ModeCards = u1070.sapphire.ModeCards or {}
u1070.sapphire.ModeCards["Auto Parry"] = __S[13]

local u1212 = __S[13]:create_slider({
    title = "Accuracy",
    flag = "parry_accuracy",
    value = 75,
    minimum_value = 1,
    maximum_value = 100,
    decimals = 0,
    callback = function(r0)
        if not u1070.config.randomize_accuracy then
            u1070.config._accuracy_before_random = r0
        end

        u1070.config.accuracy = r0
    end
})

__S[13]:create_slider({
    title = "Parry Range", flag = "sapphire_parry_range", value = 0,
    minimum_value = 0, maximum_value = 10, decimals = 0,
    callback = function(value) u1070.config.parry_range = value end
})

__S[13]:create_checkbox({
    title = "Randomize Accuracy",
    flag = "randomize_accuracy",
    callback = function(r0)
        u1070.config.randomize_accuracy = r0

        if r0 then
            u1070.config._accuracy_before_random = u1070.config.accuracy
        else
            local r1 = tonumber(u1070.config._accuracy_before_random or u864._config._flags.parry_accuracy or u1070.config.accuracy)

            if r1 then
                local r4 = math.clamp(math.floor(r1 + 0.5), 1, 100)
                u1070.config.accuracy = r4
                u864._config._flags.parry_accuracy = r4
                u867:save(u796.GameId, u864._config)

                if u1212 and u1212.set_percentage then
                    u1212:set_percentage(r4)
                end
            end
        end
    end
})

__S[13]:create_doubleslider({
    title = "Random Accuracy",
    flag = "random_accuracy_range",
    value = {25, 85},
    minimum_value = 1,
    maximum_value = 100,
    decimals = 0,
    callback = function(r0, r1)
        u1070.config.random_accuracy_min = r0
        u1070.config.random_accuracy_max = r1
    end
})

__S[13]:create_dropdown({
    title = "Parry Mode",
    flag = "parry_mode",
    options = {"Remote", "Keypress"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.config.parry_mode = u864.normalize_parry_method(r0)
    end
})

__S[13]:create_dropdown({
    title = "Parry Loop",
    flag = "parry_loop",
    options = {"PreSimulation", "PreRender"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(value) u1070.sapphire.SetAutoLoop(value) end
})

__S[13]:create_divider({showtopic = true, title = "Pre Click"})

__S[13]:create_checkbox({
    title = "Kill Pre Click",
    flag = "kill_pre_click",
    notify = true,
    callback = function(r0)
        u1070.config.kill_pre_click = r0
        if u1070.sapphire and u1070.sapphire.PreclickAll then u1070.sapphire.PreclickAll.Sync() end
    end
})

__S[13]:create_slider({
    title = "Pre Click Range",
    flag = "kill_pre_click_range",
    value = 30,
    minimum_value = 5,
    maximum_value = 100,
    decimals = 0,
    callback = function(r0)
        u1070.config.kill_pre_click_range = r0
    end
})

__S[13]:create_slider({
    title = "Pre Click Ball Speed",
    flag = "kill_pre_click_speed",
    value = 1,
    minimum_value = 1,
    maximum_value = 1000,
    decimals = 0,
    callback = function(r0)
        u1070.config.kill_pre_click_speed = r0
    end
})

__S[13]:create_checkbox({
    title = "Preclick for all",
    description = "preclicks when any other player dies, even if you did not get the kill",
    flag = "preclick_for_all",
    notify = true,
    callback = function(value)
        u1070.config.preclick_for_all = value == true
        if u1070.sapphire and u1070.sapphire.PreclickAll then u1070.sapphire.PreclickAll.Sync() end
    end
})

__S[13]:create_divider({showtopic = true, title = "Abilities"})

__S[13]:create_checkbox({
    title = "Cooldown Protection",
    flag = "cooldown_protection",
    callback = function(r0)
        u1070.ability.cooldown_protection = r0
    end
})

__S[13]:create_checkbox({
    title = "Predictive Timing",
    description = "predicts ball entry using relative motion, latency and frame timing",
    flag = "predictive_timing",
    notify = true,
    callback = function(value) u1070.sapphire.Predictive.SetEnabled(value) end
})

__S[13]:create_checkbox({
    title = "Animation Fix",
    flag = "auto_parry_anim_fix",
    callback = function(value) u1070.sapphire.SetAutoAnimation(value) end
})

__S[13]:create_checkbox({
    title = "Auto Ability",
    flag = "auto_ability",
    callback = function(r0)
        u1070.ability.auto_ability = r0
    end
})

__S[13]:create_divider({showtopic = true, title = "Curve"})

__S[13]:create_dropdown({
    title = "Curve Type",
    flag = "curve_method",
    options = u1073,
    maximum_options = 9,
    multi_dropdown = false,
    keybind = true,
    notify = true,
    callback = function(value)
        u1070.config.curve_method = u864.normalize_curve_method(value)
    end
})

u1070.sapphire.TriggerUIInitializing = true
local triggerCard = __S[5]:create_module({
    title = "Triggerbot",
    description = "instantly parry if targeted",
    section = "left",
    flag = "triggerbot",
    notify = true,
    callback = function(r0)
        if u1070.sapphire.TriggerUIInitializing and u864._config._flags.triggerbot == false then return end
        if u1070.sapphire.TriggerUIInitializing and not u1070.config.is_mobile then
            u1070.sapphire.InitialTriggerEnabled = r0
            return
        end
        if u1070.config.is_mobile then
            if r0 then
                if not u1070.mobile_guis.triggerbot then
                    local u1213 = u1079("Trigger", 0.7, u820.fromRGB(255, 100, 0))
                    u1070.mobile_guis.triggerbot = u1213
                    local u1214 = 0
                    local u1215 = false

                    u1213.button.InputBegan:Connect(function(r0)
                        if r0.UserInputType == u824.UserInputType.Touch then
                            u1214 = u817()
                            u1215 = false
                        end
                    end)

                    u1213.button.InputChanged:Connect(function(r0)
                        if r0.UserInputType == u824.UserInputType.Touch and u817() - u1214 > 0.15 then
                            u1215 = true
                        end
                    end)

                    u1213.button.InputEnded:Connect(function(r0)
                        if r0.UserInputType ~= u824.UserInputType.Touch or u1215 then
                            return
                        end

                        local r5 = not u1070.triggerbot.enabled
                        u1070.triggerbot.set(r5)
                        u1213.label.Text = r5 and "ON" or "Trigger"
                        local r2 = u1213.label

                        if r5 then
                            r5 = u820.fromRGB(255, 100, 0)
                        end

                        if not r5 then
                            r5 = u820.fromRGB(235, 234, 239)
                        end

                        r2.TextColor3 = r5
                    end)
                end
            else
                u1070.triggerbot.set(false)

                if u1070.mobile_guis.triggerbot then
                    u1070.mobile_guis.triggerbot.gui:Destroy()
                    u1070.mobile_guis.triggerbot = nil
                end
            end
        else
            u1070.triggerbot.set(r0)
        end
    end
})

u1070.sapphire.ModeCards["Triggerbot"] = triggerCard
if u864._config._flags.triggerbot == false then triggerCard:change_state(false) end

triggerCard:create_dropdown({
    title = "Triggerbot Type", flag = "sapphire_trigger_type", options = {"Remote", "Keypress"},
    maximum_options = 2, multi_dropdown = false,
    callback = function(value) u1070.sapphire.SetTriggerOption("mode", value) end
})
triggerCard:create_slider({
    title = "Delay (MS)", flag = "sapphire_trigger_delay", value = 0,
    minimum_value = 0, maximum_value = 200, decimals = 0,
    callback = function(value) u1070.sapphire.SetTriggerOption("delay", value) end
})
triggerCard:create_checkbox({
    title = "Randomize Delay", flag = "sapphire_trigger_randomize",
    callback = function(value) u1070.sapphire.SetTriggerOption("randomize", value) end
})
triggerCard:create_doubleslider({
    title = "Delay Range (MS)", flag = "sapphire_trigger_delay_range", value = {0, 200},
    minimum_value = 0, maximum_value = 200, decimals = 0,
    callback = function(low, high)
        u1070.sapphire.SetTriggerOption("delay_min", low)
        u1070.sapphire.SetTriggerOption("delay_max", high)
    end
})
triggerCard:create_checkbox({
    title = "Don't Parry On Ball Spawn", flag = "sapphire_trigger_ignore_spawn",
    callback = function(value) u1070.sapphire.SetTriggerOption("ignore_spawn", value) end
})

 
u1070.sapphire.TriggerUIInitializing = false
if not u1070.config.is_mobile then
    u1070.sapphire.SetTriggerEnabled(u1070.sapphire.InitialTriggerEnabled == true)
end
u1070.sapphire.InitialTriggerEnabled = nil

 
do
    local T = u1070.target_player
    local savedEnabled = u864._config._flags.target_player
    local card = __S[5]:create_module({
        title = "Target Player",
        description = "locks parry aim to the selected player",
        section = "right",
        flag = "target_player",
        notify = true,
        callback = function(value) T.SetEnabled(value) end
    })
    T.Dropdown = card:create_dropdown({
        title = "Target",
        flag = "target_player_target",
        options = T.PlayerList(),
        maximum_options = 8,
        search = true,
        multi_dropdown = false,
        callback = function(value) T.SetTarget(value, false, true) end
    })
    card:create_checkbox({
        title = "Kill Switch",
        flag = "target_player_kill_switch",
        callback = function(value) T.SetKillSwitch(value) end
    })
    card:create_checkbox({
        title = "Highlight Target",
        flag = "target_player_highlight",
        callback = function(value) T.SetHighlight(value) end
    })
     
    local dropdown = T.Dropdown
    local unfold = dropdown and dropdown.unfold_settings
    if type(unfold) == "function" then
        dropdown.unfold_settings = function(self)
            if not self._state then T.RefreshList() end
            return unfold(self)
        end
    end
    if savedEnabled == false then card:change_state(false) end
    T.Ready = true
    T.SyncConfig()
    T.RefreshList()
    T.RefreshHighlight()
end

__S[13] = __S[5]:create_module({
    title = "Manual Spam",
    description = "continuously spams parry",
    section = "right",
    flag = "manual_spam",
    notify = true,
    callback = function(r0)
        if u1070.config.is_mobile then
            if r0 then
                if not u1070.mobile_guis.manual_spam then
                    local u1216 = u1079("Spam", 0.8, u820.fromRGB(99, 102, 241))
                    u1070.mobile_guis.manual_spam = u1216
                    local u1217 = 0
                    local u1218 = false

                    u1216.button.InputBegan:Connect(function(r0)
                        if r0.UserInputType == u824.UserInputType.Touch then
                            u1217 = u817()
                            u1218 = false
                        end
                    end)

                    u1216.button.InputChanged:Connect(function(r0)
                        if r0.UserInputType ~= u824.UserInputType.Touch or not (u817() - u1217 > 0.15) then
                            return
                        end

                        u1218 = true
                    end)

                    u1216.button.InputEnded:Connect(function(r0)
                        if r0.UserInputType ~= u824.UserInputType.Touch or u1218 then
                            return
                        end

                        if u1070.spam.manual_enabled then
                            u1070.spam.manual_stop()
                            u1216.label.Text = "Spam"
                            u1216.label.TextColor3 = u820.fromRGB(235, 234, 239)
                        else
                            u1070.spam.manual_start()
                            u1216.label.Text = "ON"
                            u1216.label.TextColor3 = u820.fromRGB(99, 102, 241)
                        end
                    end)
                end
            else
                u1070.spam.manual_stop()

                if u1070.mobile_guis.manual_spam then
                    u1070.mobile_guis.manual_spam.gui:Destroy()
                    u1070.mobile_guis.manual_spam = nil
                end
            end
        elseif r0 then
            u1070.spam.manual_start()
        else
            u1070.spam.manual_stop()
        end
    end
})

__S[13]:create_dropdown({
    title = "Parry Method",
    flag = "manual_spam_mode",
    options = {"Remote", "Keypress"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.spam.manual_mode = u864.normalize_parry_method(r0)
    end
})

__S[13]:create_checkbox({
    title = "Animation Fix",
    flag = "manual_spam_anim_fix",
    callback = function(value) u1070.oxy_manual.SetAnimation("Manual", value) end
})

 
if not u1070.config.is_mobile and u864._config._flags.manual_spam == false then
    __S[13]:change_state(false)
end
u1070.oxy_manual.Ready = true

__S[13] = __S[5]:create_module({
    title = "Auto Spam",
    description = "spams based on ball proximity",
    section = "right",
    flag = "auto_spam",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.spam.auto_start()
        else
            u1070.spam.auto_stop()
        end
    end
})

__S[13]:create_dropdown({
    title = "Parry Method",
    flag = "auto_spam_mode",
    options = {"Remote", "Keypress"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.spam.auto_mode = u864.normalize_parry_method(r0)
    end
})

__S[13]:create_slider({
    title = "Parry Threshold",
    flag = "spam_threshold",
    value = 1.5,
    minimum_value = 1,
    maximum_value = 5,
    callback = function(r0)
        u1070.spam.threshold = r0
    end
})

__S[13]:create_slider({
    title = "Sensitivity Multiplier",
    flag = "auto_spam_distance_multiplier",
    value = 0.3,
    minimum_value = 0.3,
    maximum_value = 3,
    decimals = 1,
    callback = function(value) u1070.oxy_manual.SetDistanceMultiplier(value) end
})

__S[13]:create_checkbox({
    title = "Animation Fix",
    flag = "auto_spam_anim_fix",
    callback = function(value) u1070.oxy_manual.SetAnimation("Auto", value) end
})

if u864._config._flags.auto_spam == false then __S[13]:change_state(false) end
u1070.oxy_manual.AutoReady = true

 
do
    local F = u1070.sapphire
    local descriptions = {
        InfinityDetection = "waits for infinity to end before parrying",
        DeathSlashDetection = "pauses normal parries during death slash",
        FuryDetection = "tracks fury catches and combo hits",
        SingularityDetection = "pauses parries while singularity is active",
        TimeHoleDetection = "pauses parries during time hole",
        FreezeDetection = "avoids parrying while your ball is frozen",
        ForcefieldDetection = "pauses parries while your shield is active",
        ParryOnDribble = "parries an opponent's highlighted dribble ball",
        DribbleDetection = "waits for your dribble ball to return",
        AntiPhantomEnabled = "responds when phantom targets your character",
        AntiFlashCounterEnabled = "responds when flash counter targets you"
    }
    local function toggle(title, key, section, flag, description)
        local saved = u864._config._flags[flag or ("sapphire_" .. key)]
        local module = __S[6]:create_module({
            title = title, description = description or descriptions[key] or "adjusts parry timing for active abilities",
            section = section, flag = flag or ("sapphire_" .. key), notify = true,
            callback = function(value) F.Set(key, value) end
        })
        if saved == false then module:change_state(false) end
        return module
    end
    toggle("Infinity Detection", "InfinityDetection", "left", "detect_infinity")
    local death = toggle("Death Slash Detection", "DeathSlashDetection", "right", "detect_deathslash")
    death:create_checkbox({
        title = "Do Minigame", flag = "sapphire_deathslash_minigame",
        callback = function(value) F.Set("DeathSlashMinigame", value) end
    })
    local fury = toggle("SOF Detection", "FuryDetection", "left", "sapphire_sof_detection")
    fury:create_checkbox({title = "Auto Hit", flag = "sapphire_fury_auto_hit", callback = function(v) F.Set("FurySpamHit", v) end})
    fury:create_dropdown({
        title = "Parry Method", flag = "sapphire_fury_method", options = {"Remote", "Keypress"},
        maximum_options = 2, multi_dropdown = false, callback = function(v) F.Set("FuryParryMethod", v) end
    })
    fury:create_slider({title = "Parry Amount", flag = "sapphire_fury_amount", value = 35, minimum_value = 1, maximum_value = 35,
        callback = function(v) F.Set("FuryParryAmount", v) end})
    fury:create_slider({title = "Parry Delay", flag = "sapphire_fury_delay", value = 0.05, minimum_value = 0.02, maximum_value = 0.25,
        decimals = 2, callback = function(v) F.Set("FuryParryDelay", v) end})
    toggle("Singularity Detection", "SingularityDetection", "left")
    toggle("Time Hole Detection", "TimeHoleDetection", "left")
    toggle("Freeze Detection", "FreezeDetection", "left")
    toggle("Forcefield Detection", "ForcefieldDetection", "right")
    toggle("Parry On Dribble", "ParryOnDribble", "right")
    toggle("Parry On Self Dribble", "DribbleDetection", "right")
     
    local function counter(title, prefix, side)
        local module = toggle(title, prefix .. "Enabled", side)
        module:create_dropdown({title = "Mode", flag = "sapphire_" .. prefix .. "Mode", options = {"Legit", "Blatant"},
            maximum_options = 2, multi_dropdown = false, callback = function(v) F.Set(prefix .. "Blatant", v == "Blatant") end})
        module:create_dropdown({title = "Legit Type", flag = "sapphire_" .. prefix .. "Type", options = {"Spam", "Ability"},
            maximum_options = 2, multi_dropdown = false, callback = function(v) F.Set(prefix .. "Type", v) end})
    end
    counter("Anti Phantom", "AntiPhantom", "right")
    counter("Anti Flash Counter", "AntiFlashCounter", "right")
    toggle("Anti Blindness", "AntiBlindness", "right", nil, "suppresses quasar blindness effects")
    toggle("Anti Disorientate", "AntiDisorientate", "right", nil, "preserves camera orientation when quasar hits")
end

__S[13] = __S[7]:create_module({
    title = "Ball Trail",
    description = "trails on the ball",
    section = "left",
    flag = "ball_trail",
    callback = function(r0)
        if r0 then
            u1070.ball_trail.start()
        else
            u1070.ball_trail.stop()
        end
    end
})

__S[13]:create_slider({
    title = "Trail Count",
    flag = "ball_trail_count",
    value = 8,
    minimum_value = 1,
    maximum_value = 16,
    callback = function(r0)
        u1070.ball_trail.num_trails = r0

        if not u1070.ball_trail.active then
            return
        end

        local r1 = u1070.ball_trail.get_ball()

        if r1 then
            u1070.ball_trail.detach()
            u1070.ball_trail.attach(r1)
        end
    end
})

__S[13]:create_colorpicker({
    title = "Trail Color",
    flag = "ball_trail_color",
    value = u820.fromRGB(0, 255, 255),
    callback = function(r0)
        u1070.ball_trail.update_color(r0)
    end
})

__S[7]:create_module({
    title = "Parry Visualizer",
    description = "shows a forcefield ball on parry",
    section = "left",
    flag = "parry_visualizer",
    callback = function(r0)
        if r0 then
            u1070.parry_visualizer.start()
        else
            u1070.parry_visualizer.stop()
        end
    end
}):create_colorpicker({
    title = "Visualizer Color",
    flag = "parry_visualizer_color",
    value = u820.fromRGB(255, 255, 255),
    callback = function(r0)
        u1070.parry_visualizer.update_color(r0)
    end
})

__S[7]:create_module({
    title = "Parry Hits",
    description = "burst effect on every parry success",
    section = "left",
    flag = "parry_hits",
    callback = function(r0)
        if r0 then
            u1070.parry_hits.start()
        else
            u1070.parry_hits.stop()
        end
    end
}):create_colorpicker({
    title = "Hits Color",
    flag = "parry_hits_color",
    value = u820.fromRGB(255, 255, 255),
    callback = function(r0)
        u1070.parry_hits.update_color(r0)
    end
})

__S[13] = __S[7]:create_module({
    title = "Custom WinStreak",
    description = "Customize your client-side win streak display",
    section = "right",
    flag = "custom_winstreak",
    callback = function(r0)
        if r0 then
            u1070.winstreak.start()
        else
            u1070.winstreak.stop()
        end
    end
})

if u864._config._flags.custom_winstreak_amount == nil then
    u864._config._flags.custom_winstreak_amount = "1"
end

u1070.winstreak.streak = u864._config._flags.custom_winstreak_amount

if u864._config._flags.custom_winstreak then
    u828.spawn(u1070.winstreak.start)
end

__S[13]:create_textbox({
    title = "Streak Amount",
    flag = "custom_winstreak_amount",
    placeholder = "Enter streak value (e.g. 999)...",
    callback = function(r0)
        u1070.winstreak.streak = r0

        if u1070.winstreak.enabled then
            pcall(u1070.winstreak.update)
        end
    end
})

__S[13] = __S[7]:create_module({
    title = "Custom Win Message",
    description = "Customize announcer messages for win and kills",
    section = "right",
    flag = "custom_win_enabled",
    callback = function(r0)
        if r0 then
            u1070.custom_win.start()
        else
            u1070.custom_win.stop()
        end
    end
})

if u864._config._flags.custom_win_win_text == nil then
    __S[3] = u864._config._flags.custom_win_text
    __S[5] = u864._config._flags

    if __S[3] then
        __S[294] = __S[3] ~= ""

        if __S[3] == "" then
            __S[3] = __S[294]
        end
    else
        __S[3] = __S[3]
    end

    if not __S[3] then
        __S[3] = "Allusive"
    end

    __S[5].custom_win_win_text = __S[3]
end

if u864._config._flags.custom_win_kill_text == nil then
    __S[3] = u864._config._flags.custom_win_text
    __S[5] = u864._config._flags

    if __S[3] then
        __S[294] = __S[3] ~= ""

        if __S[3] == "" then
            __S[3] = __S[294]
        end
    else
        __S[3] = __S[3]
    end

    if not __S[3] then
        __S[3] = "Allusive"
    end

    __S[5].custom_win_kill_text = __S[3]
end

u1070.custom_win.win_message = u864._config._flags.custom_win_win_text
u1070.custom_win.kill_message = u864._config._flags.custom_win_kill_text

if u864._config._flags.custom_win_enabled then
    u828.spawn(u1070.custom_win.start)
end

__S[13]:create_textbox({
    title = "Win Message",
    flag = "custom_win_win_text",
    placeholder = "Enter win message...",
    callback = function(r0)
        u1070.custom_win.win_message = r0

        if u1070.custom_win.enabled then
            u1070.custom_win.update()
        end
    end
})

__S[13]:create_textbox({
    title = "Kill Message",
    flag = "custom_win_kill_text",
    placeholder = "Enter kill message...",
    callback = function(r0)
        u1070.custom_win.kill_message = r0

        if u1070.custom_win.enabled then
            u1070.custom_win.update()
        end
    end
})

__S[13] = __S[7]:create_module({
    title = "Ability ESP",
    description = "shows player equipped abilities",
    section = "left",
    flag = "ability_esp",
    callback = function(r0)
        if r0 then
            u1070.ability_esp.start()
        else
            u1070.ability_esp.stop()
        end
    end
})

__S[13]:create_divider({showtopic = true, title = "Name"})

__S[13]:create_checkbox({
    title = "Show Name",
    flag = "esp_show_name",
    value = false,
    callback = function(r0)
        u1070.ability_esp.show_name = r0
    end
})

__S[13]:create_dropdown({
    title = "Name Type",
    flag = "esp_name_mode",
    options = {"Display Name", "Username"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.ability_esp.name_mode = r0
    end
})

__S[13]:create_slider({
    title = "Name Size",
    flag = "esp_name_size",
    value = 18,
    minimum_value = 8,
    maximum_value = 36,
    callback = function(r0)
        u1070.ability_esp.name_size = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.nameDraw then
                r3.nameDraw.Size = r0
            end
        end
    end
})

__S[13]:create_colorpicker({
    title = "Name Color",
    flag = "esp_name_color",
    value = u820.fromRGB(255, 255, 255),
    callback = function(r0)
        u1070.ability_esp.name_color = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.nameDraw then
                r3.nameDraw.Color = r0
            end
        end
    end
})

__S[13]:create_divider({showtopic = true, title = "Ability"})

__S[13]:create_slider({
    title = "Ability Size",
    flag = "esp_ability_size",
    value = 16,
    minimum_value = 8,
    maximum_value = 36,
    callback = function(r0)
        u1070.ability_esp.ability_size = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.abilityDraw then
                r3.abilityDraw.Size = r0
            end
        end
    end
})

__S[13]:create_colorpicker({
    title = "Ability Color",
    flag = "esp_ability_color",
    value = u820.fromRGB(120, 200, 255),
    callback = function(r0)
        u1070.ability_esp.ability_color = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.abilityDraw then
                r3.abilityDraw.Color = r0
            end
        end
    end
})

do
local saved = u864._config._flags.ball_velocity
local initializing = true
local card = __S[7]:create_module({
    title = "Ball Velocity",
    description = "displays current and peak ball speed",
    section = "left",
    flag = "ball_velocity",
    callback = function(r0)
        if initializing and saved == false then return end
        if r0 then
            u1070.ball_velocity.start()
        else
            u1070.ball_velocity.stop()
        end
    end
})
if saved == false then card:change_state(false) end
initializing = false
end

__S[7]:create_module({
    title = "Ball Indicator",
    description = "shows ball direction on screen",
    section = "right",
    flag = "ball_indicator",
    callback = function(r0)
        if r0 then
            u1070.ball_indicator.start()
        else
            u1070.ball_indicator.stop()
        end
    end
})

__S[7]:create_module({
    title = "No Render",
    description = "disables client effects",
    section = "right",
    flag = "no_render",
    callback = function(r0)
        if r0 then
            u1070.no_render.start()
        else
            u1070.no_render.stop()
        end
    end
})

__S[7]:create_module({
    title = "Plushies",
    description = "animated plushies that follow you",
    section = "right",
    flag = "plushies",
    callback = function(r0)
        if r0 then
            u1070.plushies.start()
        else
            u1070.plushies.stop()
        end
    end
}):create_dropdown({
    title = "Plushie Type",
    flag = "plushie_type",
    options = {
        "Reimu",
        "Youmou",
        "Shion",
        "Yuuka",
        "Flandre",
        "Ayanami",
        "Padoru"
    },
    maximum_options = 7,
    multi_dropdown = true,
    callback = function(r0)
        u1070.plushies.active_types = {}

        for r2, r3 in ipairs(r0) do
            u1070.plushies.active_types[r3] = true
        end
    end
})

__S[8]:create_module({
    title = "Field of View",
    description = "changes camera field of view",
    section = "left",
    flag = "fov",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_fov(r0, nil)
    end
}):create_slider({
    title = "FOV",
    flag = "fov_value",
    value = 70,
    minimum_value = 40,
    maximum_value = 120,
    callback = function(r0)
        u1070.player_mods.fov = r0

        if u1070.player_mods.fov_enabled then
            u1062.FieldOfView = r0
        end
    end
})

__S[8]:create_module({
    title = "Speed",
    description = "changes walk speed",
    section = "left",
    flag = "speed",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_speed(r0, nil)
    end
}):create_slider({
    title = "Walk Speed",
    flag = "speed_value",
    value = 16,
    minimum_value = 1,
    maximum_value = 200,
    callback = function(r0)
        u1070.player_mods.speed = r0

        if not u1070.player_mods.speed_enabled then
            return
        end

        local r5 = u1061.Character
        local r2 = r5 and r5:FindFirstChildOfClass("Humanoid")

        if not r2 then
            return
        end

        r2.WalkSpeed = r0
    end
})

__S[8]:create_module({
    title = "Gravity",
    description = "changes workspace gravity",
    section = "right",
    flag = "gravity",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_gravity(r0, nil)
    end
}):create_slider({
    title = "Gravity",
    flag = "gravity_value",
    value = 196,
    minimum_value = 0,
    maximum_value = 500,
    callback = function(r0)
        u1070.player_mods.gravity = r0

        if not u1070.player_mods.gravity_enabled then
            return
        end

        u1058.Gravity = r0
    end
})

__S[8]:create_module({
    title = "Jump Power",
    description = "changes humanoid jump power",
    section = "right",
    flag = "jump_power",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_jump_power(r0, nil)
    end
}):create_slider({
    title = "Jump Power",
    flag = "jump_power_value",
    value = 50,
    minimum_value = 0,
    maximum_value = 300,
    callback = function(r0)
        u1070.player_mods.jump_power = r0

        if not u1070.player_mods.jump_power_enabled then
            return
        end

        local r2 = u1061.Character

        if r2 then
            r2 = r2:FindFirstChildOfClass("Humanoid")
        end

        if r2 then
            r2.JumpPower = r0
        end
    end
})

__S[8]:create_module({
    title = "Infinite Jump",
    description = "allows jumping in mid-air",
    section = "right",
    flag = "infinite_jump",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_infinite_jump(r0)
    end
})

__S[5] = u1070.emotes.get_emotes_list()

__S[6] = __S[8]:create_module({
    title = "Emotes",
    description = "plays character emote animations",
    section = "left",
    flag = "emotes",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.emotes.start()
        else
            u1070.emotes.cleanup()
        end
    end
})

__S[6]:create_dropdown({
    title = "Emote",
    flag = "emote_select",
    options = __S[5],
    maximum_options = 10,
    multi_dropdown = false,
    search = true,
    callback = function(r0)
        u1070.emotes.current = r0

        if u1070.emotes.enabled then
            u1070.emotes.play(r0)
        end
    end
})

__S[6]:create_checkbox({
    title = "Auto Stop",
    flag = "emote_auto_stop",
    callback = function(r0)
        u1070.emotes.auto_stop = r0
    end
})

__S[7] = __S[12]:create_module({
    title = "Sword Changer",
    description = "customizes sword appearance and effects",
    section = "left",
    flag = "sword_changer",
    callback = function(r0)
        if r0 then
            u1070.sword_changer.save_original()
            u1070.sword_changer.enabled = true
            pcall(u1070.sword_changer.update)
        else
            u1070.sword_changer.enabled = false
            u1070.sword_changer.restore_original()
        end
    end
})

__S[7]:create_textbox({
    title = "Sword Model",
    flag = "sword_model",
    placeholder = "Enter sword model name...",
    callback = function(r0)
        u1070.sword_changer.model = r0
        u1070.sword_changer.model_cache[r0] = nil
        pcall(u1070.sword_changer.update)
    end
})

__S[7]:create_textbox({
    title = "Sword Animations",
    flag = "sword_animations",
    placeholder = "Enter sword animation name...",
    callback = function(r0)
        u1070.sword_changer.animations = r0
        pcall(u1070.sword_changer.update)
    end
})

__S[7]:create_textbox({
    title = "Sword FX",
    flag = "sword_fx",
    placeholder = "Enter sword FX name...",
    callback = function(r0)
        u1070.sword_changer.fx = r0
        pcall(u1070.sword_changer.update)
    end
})

__S[12]:create_module({
    title = "Avatar Changer",
    description = "copies another player avatar",
    section = "left",
    flag = "avatar_changer",
    callback = function(r0)
        u1070.avatar_changer.enabled = r0

        if r0 then
            u1070.avatar_changer.save_original()

            if u1070.avatar_changer.target ~= "" then
                u1070.avatar_changer.apply(u1070.avatar_changer.target)
            end
        end

        if not r0 and u1070.avatar_changer.applied_id then
            u1070.avatar_changer.restore()
        end
    end
}):create_textbox({
    title = "Username",
    flag = "avatar_target",
    placeholder = "Enter username...",
    callback = function(r0)
        local r2 = u1070.avatar_changer

        if not r0 then
            r0 = ""
        end

        r2.target = r0

        if u1070.avatar_changer.enabled and u1070.avatar_changer.target ~= "" then
            u1070.avatar_changer.applied_id = nil
            u1070.avatar_changer.apply(u1070.avatar_changer.target)
        end
    end
})

__S[12]:create_module({
    title = "Korblox",
    description = "replaces right leg with korblox mesh",
    section = "right",
    flag = "korblox",
    callback = function(r0)
        u1070.avatar.set_korblox(r0)
    end
})

__S[12]:create_module({
    title = "Headless",
    description = "makes head invisible",
    section = "right",
    flag = "headless",
    callback = function(r0)
        u1070.avatar.set_headless(r0)
    end
})

__S[8] = __S[11]:create_module({
    title = "Orbit Ball",
    description = "orbits your character around the ball",
    section = "left",
    flag = "orbit_ball",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.orbit_ball.start()
        else
            u1070.orbit_ball.stop()
        end
    end
})

__S[8]:create_slider({
    title = "Speed",
    flag = "orbit_speed",
    value = 50,
    minimum_value = 1,
    maximum_value = 200,
    callback = function(r0)
        u1070.orbit_ball.speed = r0
    end
})

__S[8]:create_slider({
    title = "Distance",
    flag = "orbit_distance",
    value = 15,
    minimum_value = 5,
    maximum_value = 60,
    callback = function(r0)
        u1070.orbit_ball.distance = r0
    end
})

__S[8]:create_slider({
    title = "Height",
    flag = "orbit_height",
    value = 5,
    minimum_value = -20,
    maximum_value = 30,
    callback = function(r0)
        u1070.orbit_ball.height = r0
    end
})

__S[9] = __S[11]:create_module({
    title = "Immortality",
    description = "desyncs position while in alive",
    section = "right",
    flag = "walkable_immortal",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.immortal.start()
        else
            u1070.immortal.stop()
        end
    end
})

__S[9]:create_checkbox({
    title = "Show Visualizer",
    flag = "immortal_visualizer",
    callback = function(r0)
        u1070.immortal.config.visualizer_enabled = r0

        if r0 and u1070.immortal.state.enabled then
            u1070.immortal.create_visualizer()
        elseif not r0 then
            u1070.immortal.destroy_visualizer()
        end
    end
})

__S[9]:create_colorpicker({
    title = "Visualizer Color",
    flag = "immortal_visualizer_color",
    value = u820.fromRGB(255, 0, 0),
    callback = function(r0)
        u1070.immortal.config.visualizer_color = r0
    end
})

__S[9]:create_slider({
    title = "Radius",
    flag = "immortal_radius",
    value = 25,
    minimum_value = 0,
    maximum_value = 100,
    callback = function(r0)
        u1070.immortal.config.radius = r0
    end
})

__S[9]:create_slider({
    title = "Height",
    flag = "immortal_height",
    value = 30,
    minimum_value = 0,
    maximum_value = 60,
    callback = function(r0)
        u1070.immortal.config.height = r0
    end
})




u828.spawn(function()
    task.wait(3)
    u1070.sword_changer.loaded = true

    if u1070.sword_changer.enabled and u1070.sword_changer.update then
        pcall(u1070.sword_changer.update)
    end
end)
