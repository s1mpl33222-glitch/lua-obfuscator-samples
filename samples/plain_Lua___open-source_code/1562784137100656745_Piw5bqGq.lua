--if you want to use this ui, you can now join discord.gg/rTw5M8dRXN

local Settings = {
    SelectedLibrary = nil, -- "Luna" or "Rayfield"
    AutoLoad = false
}

local success, savedSettings = pcall(function()
    return game:GetService("HttpService"):JSONDecode(readfile("XVCHubSettings.json"))
end)

if success and savedSettings then
    Settings = savedSettings
end

if Settings.SelectedLibrary and Settings.AutoLoad then
    if Settings.SelectedLibrary == "Luna" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XVCHub/Loader/main/Loader.lua"))()
    elseif Settings.SelectedLibrary == "Rayfield" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XVCHub/RayfieldLoader/main/Loader.lua"))()
    end
    return
end

local XVCHubLoader = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local LunaButton = Instance.new("TextButton")
local TextLabel_2 = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local RayfieldButton = Instance.new("TextButton")
local TextLabel_3 = Instance.new("TextLabel")
local UICorner_2 = Instance.new("UICorner")
local UICorner_3 = Instance.new("UICorner")
local Frame_2 = Instance.new("Frame")
local Frame_3 = Instance.new("Frame")
local TextLabel_4 = Instance.new("TextLabel")
local TextLabel_5 = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local Frame_4 = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local ToggleStatus = Instance.new("TextLabel")
local UICorner_5 = Instance.new("UICorner")

local function protectUI(sGui)
    local function blankfunction(...)
        return ...
    end

    local cloneref = cloneref or blankfunction

    local function SafeGetService(service)
        return cloneref(game:GetService(service)) or game:GetService(service)
    end

    local cGUI = SafeGetService("CoreGui")
    local rPlr = SafeGetService("Players"):FindFirstChildWhichIsA("Player")
    local cGUIProtect = {}
    local rService = SafeGetService("RunService")
    local lPlr = SafeGetService("Players").LocalPlayer

    local function NAProtection(inst, var)
        if inst then
            if var then
                inst[var] = "\0"
                inst.Archivable = false
            else
                inst.Name = "\0"
                inst.Archivable = false
            end
        end
    end

    if (get_hidden_gui or gethui) then
        local hiddenUI = (get_hidden_gui or gethui)
        NAProtection(sGui)
        sGui.Parent = hiddenUI()
        return sGui
    elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
        NAProtection(sGui)
        syn.protect_gui(sGui)
        sGui.Parent = cGUI
        return sGui
    elseif cGUI:FindFirstChildWhichIsA("ScreenGui") then
        pcall(function()
            for _, v in pairs(sGui:GetDescendants()) do
                cGUIProtect[v] = rPlr.Name
            end
            sGui.DescendantAdded:Connect(function(v)
                cGUIProtect[v] = rPlr.Name
            end)
            cGUIProtect[sGui] = rPlr.Name

            local meta = getrawmetatable(game)
            local tostr = meta.__tostring
            setreadonly(meta, false)
            meta.__tostring = newcclosure(function(t)
                if cGUIProtect[t] and not checkcaller() then
                    return cGUIProtect[t]
                end
                return tostr(t)
            end)
        end)
        if not rService:IsStudio() then
            local newGui = cGUI:FindFirstChildWhichIsA("ScreenGui")
            newGui.DescendantAdded:Connect(function(v)
                cGUIProtect[v] = rPlr.Name
            end)
            for _, v in pairs(sGui:GetChildren()) do
                v.Parent = newGui
            end
            sGui = newGui
        end
        return sGui
    elseif cGUI then
        NAProtection(sGui)
        sGui.Parent = cGUI
        return sGui
    elseif lPlr and lPlr:FindFirstChild("PlayerGui") then
        NAProtection(sGui)
        sGui.Parent = lPlr:FindFirstChild("PlayerGui")
        return sGui
    else
        return nil
    end
end
local function SaveSettings()
    writefile("XVCHubSettings.json", game:GetService("HttpService"):JSONEncode(Settings))
end

-- Mouse unlock system
local VW5sb2NrTW91c2U = Instance.new("ScreenGui")
local textButton = Instance.new("TextButton")
textButton.BackgroundTransparency = 1
textButton.Size = UDim2.new(0, 0, 0, 0)
textButton.Modal = true
textButton.Text = ""
textButton.Parent = VW5sb2NrTW91c2U
VW5sb2NrTW91c2U.ResetOnSpawn = true

local guienabled = true
local inputcon = game:GetService("UserInputService").InputBegan:Connect(function(input, gameprocessed)
    if not gameprocessed and input.KeyCode == Enum.KeyCode.Z then
        guienabled = not guienabled
        VW5sb2NrTW91c2U.Enabled = guienabled
    end
end)

local buttonsenabled = true

XVCHubLoader.Name = "XVCHubLoader"
protectUI(XVCHubLoader)
protectUI(VW5sb2NrTW91c2U)
XVCHubLoader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = XVCHubLoader
Frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
Frame.BackgroundTransparency = 0.300
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.328345984, 0, 0.328127146, 0)
Frame.Size = UDim2.new(0.342480838, 0, 0.340751022, 0)

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.141164184, 0, 0.105588883, 0)
TextLabel.Size = UDim2.new(0.712184846, 0, 0.108597279, 0)
TextLabel.Font = Enum.Font.Unknown
TextLabel.Text = "Which Library do you prefer?"
TextLabel.TextColor3 = Color3.fromRGB(244, 244, 244)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

LunaButton.Name = "LunaButton"
LunaButton.Parent = Frame
LunaButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LunaButton.BackgroundTransparency = 0.900
LunaButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
LunaButton.Position = UDim2.new(0.0280318242, 0, 0.382928848, 0)
LunaButton.Size = UDim2.new(0.420168072, 0, 0.22624433, 0)
LunaButton.Font = Enum.Font.Unknown
LunaButton.Text = "Luna Library"
LunaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LunaButton.TextScaled = true
LunaButton.TextSize = 14.000
LunaButton.TextWrapped = true
LunaButton.MouseButton1Down:Connect(function()
    if not buttonsenabled then return end
    buttonsenabled = false
    Settings.SelectedLibrary = "Luna"
    SaveSettings()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XVCHub/Loader/main/Loader.lua"))()
    XVCHubLoader:Destroy()
    inputcon:Disconnect()
    VW5sb2NrTW91c2U:Destroy()
end)

TextLabel_2.Parent = LunaButton
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0, 0, 1.42846918, 0)
TextLabel_2.Size = UDim2.new(1, 0, 1, 0)
TextLabel_2.Font = Enum.Font.Unknown
TextLabel_2.Text = "Luna Library So good mobile and pc"
TextLabel_2.TextColor3 = Color3.fromRGB(186, 186, 186)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14.000
TextLabel_2.TextWrapped = true

UICorner.Parent = LunaButton

RayfieldButton.Name = "RayfieldButton"
RayfieldButton.Parent = Frame
RayfieldButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RayfieldButton.BackgroundTransparency = 0.900
RayfieldButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
RayfieldButton.Position = UDim2.new(0.556099236, 0, 0.382928848, 0)
RayfieldButton.Size = UDim2.new(0.420168072, 0, 0.22624433, 0)
RayfieldButton.Font = Enum.Font.Unknown
RayfieldButton.Text = "Rayfield Library"
RayfieldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RayfieldButton.TextScaled = true
RayfieldButton.TextSize = 14.000
RayfieldButton.TextWrapped = true
RayfieldButton.MouseButton1Down:Connect(function()
    if not buttonsenabled then return end
    buttonsenabled = false
    Settings.SelectedLibrary = "Rayfield"
    SaveSettings()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XVCHub/RayfieldLoader/main/Loader.lua"))()
    XVCHubLoader:Destroy()
    inputcon:Disconnect()
    VW5sb2NrTW91c2U:Destroy()
end)

TextLabel_3.Parent = RayfieldButton
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0, 0, 1.42846918, 0)
TextLabel_3.Size = UDim2.new(1, 0, 1, 0)
TextLabel_3.Font = Enum.Font.Unknown
TextLabel_3.Text = "Rayfield Library so good for pc, but It might be a little bad on mobile too"
TextLabel_3.TextColor3 = Color3.fromRGB(186, 186, 186)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 14.000
TextLabel_3.TextWrapped = true

UICorner_2.Parent = RayfieldButton
UICorner_3.Parent = Frame

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(182, 182, 182)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.49579832, 0, 0.28054297, 0)
Frame_2.Size = UDim2.new(0.0063025211, 0, 0.719456971, 0)

Frame_3.Parent = Frame
Frame_3.BackgroundColor3 = Color3.fromRGB(182, 182, 182)
Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0, 0, 0.28054297, 0)
Frame_3.Size = UDim2.new(1, 0, 0.0180995464, 0)

TextLabel_4.Parent = Frame
TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.BackgroundTransparency = 1.000
TextLabel_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_4.BorderSizePixel = 0
TextLabel_4.Size = UDim2.new(0.237394959, 0, 0.0769230723, 0)
TextLabel_4.Font = Enum.Font.Unknown
TextLabel_4.Text = "XVC Hub Loader"
TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.TextScaled = true
TextLabel_4.TextSize = 14.000
TextLabel_4.TextWrapped = true

TextLabel_5.Parent = Frame
TextLabel_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.BackgroundTransparency = 1.000
TextLabel_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_5.BorderSizePixel = 0
TextLabel_5.Position = UDim2.new(0.234882638, 0, 0, 0)
TextLabel_5.Size = UDim2.new(0.0861344561, 0, 0.0769230723, 0)
TextLabel_5.Font = Enum.Font.Unknown
TextLabel_5.Text = "v5"
TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.TextScaled = true
TextLabel_5.TextSize = 14.000
TextLabel_5.TextWrapped = true

CloseButton.Name = "CloseButton"
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 1.000
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.953715503, 0, -1.5570194e-07, 0)
CloseButton.Size = UDim2.new(0.0451357327, 0, 0.102040827, 0)
CloseButton.Font = Enum.Font.Unknown
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextScaled = true
CloseButton.TextSize = 14.000
CloseButton.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextStrokeTransparency = 0.500
CloseButton.TextWrapped = true
CloseButton.MouseButton1Down:Connect(function()
    XVCHubLoader:Destroy()
    inputcon:Disconnect()
    VW5sb2NrTW91c2U:Destroy()
end)

UICorner_4.Parent = CloseButton

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Settings.AutoLoad and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.9, 0, 0, 0)
ToggleButton.Size = UDim2.new(0.045, 0, 0.102, 0)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Text = ""
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextSize = 14.000

ToggleStatus.Name = "ToggleStatus"
ToggleStatus.Parent = Frame
ToggleStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleStatus.BackgroundTransparency = 1.000
ToggleStatus.Position = UDim2.new(0.75, 0, 0, 0)
ToggleStatus.Size = UDim2.new(0.15, 0, 0.102, 0)
ToggleStatus.Font = Enum.Font.Unknown
ToggleStatus.Text = "Auto Load: " .. (Settings.AutoLoad and "ON" or "OFF")
ToggleStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleStatus.TextScaled = true
ToggleStatus.TextSize = 14.000
ToggleStatus.TextWrapped = true
ToggleStatus.TextXAlignment = Enum.TextXAlignment.Right

UICorner_5.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Settings.AutoLoad = not Settings.AutoLoad
    SaveSettings()
    ToggleButton.BackgroundColor3 = Settings.AutoLoad and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    ToggleStatus.Text = "Auto Load: " .. (Settings.AutoLoad and "ON" or "OFF")
end)

Frame_4.Parent = Frame
Frame_4.BackgroundColor3 = Color3.fromRGB(182, 182, 182)
Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0, 0, 0.627481759, 0)
Frame_4.Size = UDim2.new(1, 0, 0.0180995464, 0)