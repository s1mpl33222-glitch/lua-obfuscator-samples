-- ============================================================
-- STITCH HUB | Block Spin 🔪 | v34
-- Logo: rbxassetid://88891962843649
-- Updates v34:
--   ✅ Tracer สีเขียวสว่างทั้งเส้น
--   ✅ Toggle / Slider / Accent / Icon = สีเขียว
--   ✅ เปลี่ยนโลโก้ใหม่ 88891962843649
--   ✅ Aim แม่นขึ้น (Muzzle pos + mixed prediction + 12 pellets)
--   ✅ Velocity history = 10 samples
--   ✅ Direct aim when target < 50 studs
--   ✅ Anti Ragdoll combined
--   ✅ Title: Stitch Hub | Block Spin 🔪
-- ============================================================

local LOGO_ID = "rbxassetid://88891962843649"

local function SendRobloxNotification(title, text, duration)
    task.spawn(function()
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title, Text = text,
                Icon = LOGO_ID,
                Duration = duration or 3
            })
        end)
    end)
end

RunMainScript = nil
local DATABASE_URL = "https://attackhubkey-default-rtdb.firebaseio.com/keys.json"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HWID = ""
if getgenv().gethwid then HWID = getgenv().gethwid()
elseif syn and syn.get_hwid then HWID = syn:get_hwid()
else HWID = tostring(LocalPlayer.UserId) end
local FileName = "StitchHub_CustomKey.txt"

local function HttpGetSafe(url)
    if request then
        local ok, res = pcall(function() return request({ Url = url, Method = "GET", Timeout = 15 }).Body end)
        if ok and res and #tostring(res) > 0 then return tostring(res) end
    end
    local ok2, res2 = pcall(function() return game:HttpGet(url) end)
    if ok2 and res2 and #tostring(res2) > 0 then return tostring(res2) end
    return nil
end

local function ValidateKey(userKey, callback)
    local response = HttpGetSafe(DATABASE_URL)
    if not response then callback(false, "Connection Error") return end
    local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
    if not ok or type(data) ~= "table" then callback(false, "Invalid Response") return end
    local matchedKeyId, keyData = nil, nil
    for id, info in pairs(data) do
        if type(info) == "table" and info.key == userKey then matchedKeyId = id; keyData = info; break end
    end
    if not keyData then callback(false, "Key Incorrect") return end
    local currentTime = os.time() * 1000
    if keyData.expireTime and keyData.expireTime > 0 and currentTime > keyData.expireTime then
        callback(false, "Key Expired") return
    end
    if not keyData.hwid or keyData.hwid == "" then
        pcall(function()
            local updateUrl = "https://attackhubkey-default-rtdb.firebaseio.com/keys/" .. matchedKeyId .. "/hwid.json"
            if request then
                request({ Url = updateUrl, Method = "PUT",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(HWID) })
            end
        end)
        callback(true, "Success! Loading...")
    elseif keyData.hwid == HWID then
        callback(true, "Success! Loading...")
    else
        callback(false, "HWID Mismatch")
    end
end

local bypassKeySystem = false
if writefile and readfile and isfile and isfile(FileName) then
    local ok, savedKey = pcall(readfile, FileName)
    if ok and savedKey and savedKey ~= "" then
        local response = HttpGetSafe(DATABASE_URL)
        if response then
            local ok2, data = pcall(function() return HttpService:JSONDecode(response) end)
            if ok2 and type(data) == "table" then
                for _, info in pairs(data) do
                    if type(info) == "table" and info.key == savedKey then
                        local currentTime = os.time() * 1000
                        local notExpired = not (info.expireTime and info.expireTime > 0 and currentTime > info.expireTime)
                        local validHwid = (info.hwid == HWID or not info.hwid or info.hwid == "")
                        if notExpired and validHwid then bypassKeySystem = true end
                        break
                    end
                end
            end
        end
    end
end

if not bypassKeySystem then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "StitchHubKeyUI"
    ScreenGui.ResetOnSpawn = false
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 420, 0, 155)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -77.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
    local stroke1 = Instance.new("UIStroke", MainFrame)
    stroke1.Color = Color3.fromRGB(0, 200, 80)
    stroke1.Thickness = 1.5
    stroke1.Transparency = 0.1
    local BgImage = Instance.new("ImageLabel", MainFrame)
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.Image = "rbxassetid://136789932955591"
    BgImage.ImageTransparency = 0.92
    BgImage.ZIndex = 1
    local IconBg = Instance.new("Frame", MainFrame)
    IconBg.Size = UDim2.new(0, 44, 0, 44)
    IconBg.Position = UDim2.new(0.5, -22, 0, 8)
    IconBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IconBg.BorderSizePixel = 0
    IconBg.ZIndex = 2
    Instance.new("UICorner", IconBg).CornerRadius = UDim.new(1, 0)
    local IconStroke = Instance.new("UIStroke", IconBg)
    IconStroke.Color = Color3.fromRGB(0, 220, 80)
    IconStroke.Thickness = 1.5
    local IconHolder = Instance.new("ImageLabel", IconBg)
    IconHolder.Size = UDim2.new(0.8, 0, 0.8, 0)
    IconHolder.Position = UDim2.new(0.1, 0, 0.1, 0)
    IconHolder.BackgroundTransparency = 1
    IconHolder.Image = LOGO_ID
    IconHolder.ZIndex = 3
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 54)
    Title.Text = "Stitch Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.BackgroundTransparency = 1
    Title.ZIndex = 2
    local Subtitle = Instance.new("TextLabel", MainFrame)
    Subtitle.Size = UDim2.new(1, 0, 0, 10)
    Subtitle.Position = UDim2.new(0, 0, 0, 76)
    Subtitle.Text = "PREMIUM SCRIPT INTERFACE"
    Subtitle.TextColor3 = Color3.fromRGB(0, 220, 80)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 7.5
    Subtitle.BackgroundTransparency = 1
    Subtitle.ZIndex = 2
    local KeyInput = Instance.new("TextBox", MainFrame)
    KeyInput.Size = UDim2.new(0.72, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.68, 0)
    KeyInput.PlaceholderText = "Enter your key..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 11
    KeyInput.ZIndex = 2
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)
    local CheckBtn = Instance.new("TextButton", MainFrame)
    CheckBtn.Size = UDim2.new(0, 30, 0, 30)
    CheckBtn.Position = UDim2.new(0.84, 0, 0.68, 0)
    CheckBtn.Text = "->"
    CheckBtn.TextColor3 = Color3.fromRGB(0, 220, 80)
    CheckBtn.BackgroundTransparency = 1
    CheckBtn.Font = Enum.Font.GothamBold
    CheckBtn.TextSize = 18
    CheckBtn.ZIndex = 3
    local isChecking = false
    CheckBtn.MouseButton1Click:Connect(function()
        if isChecking then return end
        local userKey = KeyInput.Text
        if userKey == "" then return end
        isChecking = true
        SendRobloxNotification("STITCH HUB", "Checking key...", 2)
        KeyInput.Text = "Checking..."
        KeyInput.TextColor3 = Color3.fromRGB(245, 158, 11)
        ValidateKey(userKey, function(isValid, msg)
            if isValid then
                if writefile then pcall(function() writefile(FileName, userKey) end) end
                KeyInput.Text = msg
                KeyInput.TextColor3 = Color3.fromRGB(16, 185, 129)
                SendRobloxNotification("STITCH HUB", "Success!", 4)
                task.wait(1)
                ScreenGui:Destroy()
                task.spawn(function()
                    repeat task.wait() until RunMainScript
                    RunMainScript()
                end)
            else
                KeyInput.Text = msg
                KeyInput.TextColor3 = Color3.fromRGB(239, 68, 68)
                SendRobloxNotification("STITCH HUB", "Invalid: " .. tostring(msg), 3)
                task.wait(2)
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Enter your key..."
                KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            isChecking = false
        end)
    end)
end

RunMainScript = function()
    task.spawn(function()
        if getgenv then getgenv().ACBYPASS = nil end
        _G.Bypass = nil
        _G.IsGodMode = nil
        task.wait(0.5)
        if not game:IsLoaded() then game.Loaded:Wait() end
        repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.PlayerGui
        if not cloneref then cloneref = function(a) return a end end
        local task = task
        local debug = debug
        local setconstant = debug and debug.setconstant
        local getupvalue = debug and debug.getupvalue
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local GuiService = game:GetService("GuiService")
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local TeleportService = game:GetService("TeleportService")
        local Debris = game:GetService("Debris")
        local Workspace = game:GetService("Workspace")
        local TweenService = game:GetService("TweenService")
        local Client = Players.LocalPlayer
        local PlayerGui = Client:WaitForChild("PlayerGui")
        local c = getgenv
        local Net
        pcall(function() Net = require(ReplicatedStorage.Modules.Core.Net) end)

        if not c().ACBYPASS then
            local ModeDone = false
            local LogoID = LOGO_ID
            _G.IsGodMode = nil
            local function finishMode()
                if ModeDone then return end
                ModeDone = true
                c().ACBYPASS = true
            end
            local function checkCondition()
                local splash = PlayerGui:FindFirstChild("SplashScreenGui")
                if splash then
                    local frame = splash:FindFirstChild("Frame")
                    local playButton = frame and frame:FindFirstChild("PlayButton")
                    if playButton and playButton.Visible then return true end
                end
                if PlayerGui:FindFirstChild("CharacterCreator") then return true end
                return false
            end
            local function pressEnter(guiObject)
                if not guiObject then return end
                pcall(function()
                    GuiService.SelectedObject = guiObject
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    task.wait(0.15)
                    GuiService.SelectedObject = nil
                end)
            end
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "StitchHubUI"
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            screenGui.DisplayOrder = 999
            screenGui.Parent = PlayerGui
            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.fromOffset(360, 140)
            mainFrame.Position = UDim2.fromScale(0.5, 0.5)
            mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            mainFrame.BackgroundTransparency = 0.15
            mainFrame.BorderSizePixel = 0
            mainFrame.Parent = screenGui
            Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
            local frameStroke = Instance.new("UIStroke")
            frameStroke.Color = Color3.fromRGB(0, 220, 80)
            frameStroke.Transparency = 0.2
            frameStroke.Thickness = 1.5
            frameStroke.Parent = mainFrame
            local headerFrame = Instance.new("Frame")
            headerFrame.Size = UDim2.new(1, 0, 0, 35)
            headerFrame.Position = UDim2.new(0, 0, 0, 8)
            headerFrame.BackgroundTransparency = 1
            headerFrame.Parent = mainFrame
            local headerLayout = Instance.new("UIListLayout")
            headerLayout.FillDirection = Enum.FillDirection.Horizontal
            headerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            headerLayout.Padding = UDim.new(0, 8)
            headerLayout.Parent = headerFrame
            local logo = Instance.new("ImageLabel")
            logo.Size = UDim2.fromOffset(22, 22)
            logo.BackgroundTransparency = 1
            logo.Image = LogoID
            logo.Parent = headerFrame
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(0, 0, 1, 0)
            title.AutomaticSize = Enum.AutomaticSize.X
            title.BackgroundTransparency = 1
            title.Text = "STITCH HUB"
            title.TextColor3 = Color3.fromRGB(220, 220, 220)
            title.TextSize = 16
            title.Font = Enum.Font.GothamBold
            title.AutoLocalize = false
            title.Parent = headerFrame
            local buttonContainer = Instance.new("Frame")
            buttonContainer.Size = UDim2.new(0.92, 0, 0, 80)
            buttonContainer.Position = UDim2.new(0.04, 0, 0, 48)
            buttonContainer.BackgroundTransparency = 1
            buttonContainer.Parent = mainFrame
            local buttonLayout = Instance.new("UIListLayout")
            buttonLayout.Padding = UDim.new(0, 6)
            buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
            buttonLayout.Parent = buttonContainer
            local function createButton(text, order)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 34)
                btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                btn.BackgroundTransparency = 0.2
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(240, 240, 240)
                btn.TextSize = 14
                btn.LayoutOrder = order
                btn.Font = Enum.Font.GothamBold
                btn.AutoLocalize = false
                btn.Parent = buttonContainer
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                local btnStroke = Instance.new("UIStroke")
                btnStroke.Color = Color3.fromRGB(0, 220, 80)
                btnStroke.Thickness = 1.5
                btnStroke.Parent = btn
                return btn
            end
            local function destroyUI()
                pcall(function()
                    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(360, 0)
                    })
                    tween:Play()
                end)
                task.wait(0.22)
                pcall(function() screenGui:Destroy() end)
            end
            local godBtn = createButton("God Mode", 1)
            local normalBtn = createButton("Normal Mode", 2)
            normalBtn.MouseButton1Click:Connect(function()
                if ModeDone then return end
                _G.IsGodMode = false
                task.spawn(function()
                    destroyUI()
                    task.wait(0.1)
                    local t = 0
                    while t < 5 and not checkCondition() do task.wait(0.2) t = t + 0.2 end
                    local sp = PlayerGui:FindFirstChild("SplashScreenGui")
                    if sp and sp.Enabled then
                        pressEnter(sp:FindFirstChild("Frame") and sp.Frame:FindFirstChild("PlayButton"))
                    end
                    t = 0
                    while t < 6 and not PlayerGui:FindFirstChild("CharacterCreator") do task.wait(0.2) t = t + 0.2 end
                    local cr = PlayerGui:FindFirstChild("CharacterCreator")
                    if cr then
                        local menu = cr:FindFirstChild("MenuFrame")
                        local skipBtn = menu and menu:FindFirstChild("AvatarMenuSkipButton")
                        pressEnter(skipBtn)
                    end
                    finishMode()
                end)
            end)
            godBtn.MouseButton1Click:Connect(function()
                if ModeDone then return end
                _G.IsGodMode = true
                task.spawn(function()
                    destroyUI()
                    task.wait(0.1)
                    if not _G.Bypass then
                        pcall(function()
                            local func = getupvalue(Net.get, 2)
                            if func then
                                setconstant(func, 3, "KUYIENGOKUYIENGO")
                                setconstant(func, 4, "KUYIENGOKUYIENGO")
                            end
                        end)
                        _G.Bypass = true
                    end
                    local old
                    old = hookfunction(Net.send, function(...)
                        local args = {...}
                        if args[1] == "leave_character_creator" or args[1] == "player_created_outfit" then return nil end
                        return old(...)
                    end)
                    local t = 0
                    while t < 5 and not checkCondition() do task.wait(0.2) t = t + 0.2 end
                    local sp = PlayerGui:FindFirstChild("SplashScreenGui")
                    if sp and sp.Enabled then
                        pressEnter(sp:FindFirstChild("Frame") and sp.Frame:FindFirstChild("PlayButton"))
                    end
                    task.wait(3)
                    local cr = PlayerGui:FindFirstChild("CharacterCreator")
                    if cr then
                        local menu = cr:FindFirstChild("MenuFrame")
                        local skipBtn = menu and menu:FindFirstChild("AvatarMenuSkipButton")
                        pressEnter(skipBtn)
                    end
                    task.wait(2)
                    pcall(function() replicatesignal(game.Players.LocalPlayer.Kill) end)
                    task.wait(5)
                    pcall(function() Net.send("death_screen_request_respawn") end)
                    finishMode()
                end)
            end)
            local selWait = 0
            while not ModeDone and selWait < 20 do task.wait(0.1) selWait = selWait + 0.1 end
            if not ModeDone then
                pcall(function() destroyUI() end)
                finishMode()
            end
            if not _G.IsGodMode then
                pcall(function()
                    local kickF = getupvalue(Net.send, 2)
                    local function v_u_19(p12, p13, p14, p15, ...) return p12(p13, p14, p15, ...) end
                    if typeof(kickF) == "function" and hookfunction then hookfunction(kickF, v_u_19) end
                end)
            end
        end

        local bypassWait = 0
        while not c().ACBYPASS and bypassWait < 15 do task.wait(0.25) bypassWait = bypassWait + 0.25 end
        c().ACBYPASS = true
        task.wait(0.3)

        local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
        pcall(function()
            WindUI:AddTheme({
                Name = "StitchGreen",
                Accent = Color3.fromRGB(0, 220, 80),
                Background = Color3.fromRGB(0, 0, 0),
                Outline = Color3.fromRGB(20, 60, 30),
                Text = Color3.fromRGB(255, 255, 255),
                Placeholder = Color3.fromRGB(120, 150, 120),
                Button = Color3.fromRGB(0, 0, 0),
                Icon = Color3.fromRGB(0, 220, 80),
                Static = Color3.fromRGB(0, 0, 0),
                TabIcon = Color3.fromRGB(0, 220, 80),
                Slider = Color3.fromRGB(0, 220, 80),
                Toggle = {
                    Disabled = Color3.fromRGB(0, 0, 0),
                    Enabled = Color3.fromRGB(0, 220, 80),
                    DisabledStroke = Color3.fromRGB(30, 60, 40),
                    EnabledStroke = Color3.fromRGB(80, 255, 130),
                    DisabledFill = Color3.fromRGB(0, 0, 0),
                    EnabledFill = Color3.fromRGB(0, 220, 80),
                }
            })
            WindUI:SetTheme("StitchGreen")
        end)
        local Window = WindUI:CreateWindow({
            Title = "Stitch Hub | Block Spin 🔪",
            Icon = LOGO_ID,
            Author = "stitch.dev",
            Folder = "StitchVocational",
            Size = UDim2.fromOffset(640, 520),
            Theme = "StitchGreen",
            Transparent = true,
            BackgroundImage = "rbxassetid://136789932955591",
            Resizable = true,
            HasOutline = false,
            HideSearchBar = false,
            ToggleKey = Enum.KeyCode.LeftShift,
            User = {
                Enabled = true, Anonymous = false, Name = Client.Name,
                Image = "rbxthumb://type=AvatarHeadShot&id=" .. Client.UserId,
                Callback = function() end,
            },
        })
        pcall(function() Window:Tag({ Title = "pvp | paid", Icon = "github", Color = Color3.fromRGB(0, 220, 80), Radius = 6 }) end)
        pcall(function() Window:Tag({ Title = "stitch.hub", Icon = "link", Color = Color3.fromRGB(0, 220, 80), Radius = 6 }) end)
        pcall(function()
            Window:EditOpenButton({
                Title = "Stitch Hub",
                Icon = LOGO_ID,
                Size = UDim2.new(0, 140, 0, 42),
                CornerRadius = UDim.new(0, 12),
                StrokeThickness = 0,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                }),
            })
        end)

        do
            local SmallToggleGui = Instance.new("ScreenGui")
            SmallToggleGui.Name = "StitchSmallToggle"
            SmallToggleGui.ResetOnSpawn = false
            SmallToggleGui.IgnoreGuiInset = true
            SmallToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            SmallToggleGui.DisplayOrder = 998
            SmallToggleGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
            local SmallBtn = Instance.new("ImageButton")
            SmallBtn.Name = "StitchToggleBtn"
            SmallBtn.Size = UDim2.new(0, 40, 0, 40)
            SmallBtn.Position = UDim2.new(0.94, 0, 0.35, 0)
            SmallBtn.AnchorPoint = Vector2.new(0.5, 0.5)
            SmallBtn.Image = LOGO_ID
            SmallBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            SmallBtn.BackgroundTransparency = 0.2
            SmallBtn.BorderSizePixel = 0
            SmallBtn.AutoButtonColor = false
            SmallBtn.Draggable = true
            SmallBtn.ZIndex = 5
            SmallBtn.Parent = SmallToggleGui
            Instance.new("UICorner", SmallBtn).CornerRadius = UDim.new(1, 0)
            local SmallStroke = Instance.new("UIStroke", SmallBtn)
            SmallStroke.Color = Color3.fromRGB(0, 220, 80)
            SmallStroke.Thickness = 1.5
            SmallStroke.Transparency = 0.15
            SmallBtn.MouseEnter:Connect(function()
                TweenService:Create(SmallBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(0, 60, 30), BackgroundTransparency = 0 }):Play()
                TweenService:Create(SmallStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(255, 255, 255), Transparency = 0 }):Play()
            end)
            SmallBtn.MouseLeave:Connect(function()
                TweenService:Create(SmallBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.2 }):Play()
                TweenService:Create(SmallStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(0, 220, 80), Transparency = 0.15 }):Play()
            end)
            SmallBtn.MouseButton1Click:Connect(function()
                pcall(function() Window:Toggle() end)
                local tIn = TweenService:Create(SmallBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 32, 0, 32) })
                local tOut = TweenService:Create(SmallBtn, TweenInfo.new(0.08, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 40, 0, 40) })
                tIn:Play()
                tIn.Completed:Connect(function() tOut:Play() end)
            end)
        end

        local Char, Util, Data, Network, VehicleSystem, CrateController, SprintModule, RagdollModule
        pcall(function() Char = require(ReplicatedStorage.Modules.Core.Char) end)
        pcall(function() Util = require(ReplicatedStorage.Modules.Core.Util) end)
        pcall(function() Data = require(ReplicatedStorage.Modules.Core.Data) end)
        pcall(function() Network = require(ReplicatedStorage.Modules.Core.Net) end)
        pcall(function() VehicleSystem = require(ReplicatedStorage.Modules.Game.VehicleSystem.Vehicle) end)
        pcall(function() CrateController = require(ReplicatedStorage.Modules.Game.CrateSystem.Crate) end)
        pcall(function() SprintModule = require(ReplicatedStorage.Modules.Game.Sprint) end)
        pcall(function() RagdollModule = require(ReplicatedStorage.Modules.Game.Ragdoll) end)

        local charWait = 0
        while (not Client.Character or not Client.Character:FindFirstChild("Humanoid")) and charWait < 15 do task.wait(0.5) charWait = charWait + 0.5 end
        local Character = Client.Character
        local Humanoid = Character and Character:FindFirstChild("Humanoid")
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local Backpack = Client:FindFirstChild("Backpack") or Client:WaitForChild("Backpack", 5)
        local CurrentCamera = workspace.CurrentCamera
        local Camera = workspace.CurrentCamera
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            Camera = workspace.CurrentCamera
        end)

        local function IsAlive(model)
            if not model then return false end
            local hum = model:FindFirstChildOfClass('Humanoid')
            if not hum then return false end
            return hum.Health > 0
        end
        local function Comma(n)
            local s = tostring(math.floor(n or 0))
            local r = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
            return r:gsub("^,", "")
        end
        local function GetDistanceFromRootPart(target)
            if not target then return math.huge end
            if not RootPart or not RootPart.Parent then
                RootPart = Client.Character and Client.Character:FindFirstChild('HumanoidRootPart')
            end
            if not RootPart then return math.huge end
            return (RootPart.Position - target.Position).Magnitude
        end
        Client.CharacterAdded:Connect(function(newCharacter)
            Character = newCharacter
            Humanoid = Character:WaitForChild('Humanoid')
            RootPart = Character:WaitForChild('HumanoidRootPart')
            Backpack = Client:WaitForChild('Backpack')
        end)

        local F, H, I = false, 120, nil
        local SafePlayers = {}
        local SafeDropdown = nil
        local PartTarget = "Head"
        local ToggleName, ToggleHealth, ToggleBox, ToggleSkeleton = false, false, false, false
        local itemESPEnabled, inventoryViewerEnabled = false, false
        local ESPList = {}
        local GunModsAutoApply = false
        local FireRateValue, AccuracyValue, RecoilValue, AutomaticValue = 1000, 1, 0, true
        local at = {
            Common = Color3.fromRGB(255, 255, 255), Uncommon = Color3.fromRGB(99, 255, 52),
            Rare = Color3.fromRGB(51, 170, 255), Epic = Color3.fromRGB(237, 44, 255),
            Legendary = Color3.fromRGB(255, 150, 0), Omega = Color3.fromRGB(255, 20, 51),
        }
        local au = {}
        local func = {}
        local itemRarityCache = {}
        pcall(function()
            local itemsFolder = ReplicatedStorage:FindFirstChild('Items')
            if itemsFolder then
                for _, template in ipairs(itemsFolder:GetDescendants()) do
                    if not template:IsA('ModuleScript') and not template:IsA('Folder') then
                        local rarity = template:GetAttribute('RarityName')
                        if rarity then itemRarityCache[template.Name] = rarity end
                    end
                end
            end
        end)

        -- ANTI LOCK
        local SavedHistoryCFrame = nil
        local function HighVelocity(Root)
            local A, B, C, R = Root.Velocity, Root.AssemblyLinearVelocity, Root.AssemblyAngularVelocity, Root.RotVelocity
            Root.Velocity = Vector3.new(math.random(-750000, 999999), math.random(-750000, 999999), math.random(-750000, 999999))
            Root.AssemblyLinearVelocity = Vector3.new(math.random(-750000, 999999), math.random(-750000, 999999), math.random(-750000, 999999))
            Root.AssemblyAngularVelocity = Vector3.new(math.random(-500000, 999999), math.random(-500000, 999999), math.random(-500000, 999999))
            Root.RotVelocity = Vector3.new(math.random(-500000, 999999), math.random(-500000, 999999), math.random(-500000, 999999))
            RunService.RenderStepped:Wait()
            Root.Velocity = A
            Root.AssemblyLinearVelocity = B
            Root.AssemblyAngularVelocity = C
            Root.RotVelocity = R
        end
        local function Csync(Root)
            local SavedCFrame = Root.CFrame
            SavedHistoryCFrame = SavedCFrame
            local FakeCFrame = CFrame.new(Root.Position + Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
            Root.CFrame = FakeCFrame
            RunService.RenderStepped:Wait()
            Root.CFrame = SavedHistoryCFrame
        end
        RunService.Heartbeat:Connect(function()
            if c().AntiLock and Client.Character then
                local humMod = Client.Character:FindFirstChildOfClass("Humanoid")
                if humMod and not humMod:GetAttribute("HasBeenDowned") then
                    local rpMod = Client.Character:FindFirstChild("HumanoidRootPart")
                    if rpMod then                        HighVelocity(rpMod)
                        Csync(rpMod)
                    end
                end
            end
        end)
        do
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", function(self, idx)
                if not checkcaller() and c().AntiLock and idx == "CFrame" then
                    if Client.Character and self == Client.Character:FindFirstChild("HumanoidRootPart") then
                        local humMod = Client.Character:FindFirstChildOfClass("Humanoid")
                        if humMod and not humMod:GetAttribute("HasBeenDowned") and SavedHistoryCFrame then
                            return SavedHistoryCFrame
                        end
                    end
                end
                return oldIndex(self, idx)
            end)
        end

        -- ANTI FALL / RAGDOLL
        local AntiFallEnabled = false
        local AntiRagdollEnabled = false
        local antiFallRemote = nil
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then antiFallRemote = remotes:FindFirstChild("Send") end
        end)
        local function findCounterIdx()
            for _, v in ipairs(getgc and getgc(true) or {}) do
                if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then return v end
            end
        end
        RunService.RenderStepped:Connect(function()
            if not AntiFallEnabled then return end
            local char = Client.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            if hum.Health <= 0 then return end
            pcall(function()
                if RagdollModule and RagdollModule.is_ragdolling and RagdollModule.is_ragdolling.get() then
                    RagdollModule.is_ragdolling.set(false)
                end
            end)
            pcall(function()
                if hum:GetAttribute("HasBeenDowned") then hum:SetAttribute("HasBeenDowned", false) end
            end)
            hum.PlatformStand = false
            hum.AutoRotate = true
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.Physics then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
            local look = hrp.CFrame.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude > 0.01 then
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flatLook.Unit)
            end
        end)
        task.spawn(function()
            while task.wait(0.1) do
                if AntiFallEnabled then
                    pcall(function()
                        if antiFallRemote then
                            local counter = findCounterIdx()
                            if counter then
                                counter.event = (counter.event or 0) + 1
                                pcall(function() antiFallRemote:FireServer(counter.event, "end_ragdoll_early") end)
                                counter.event = counter.event + 1
                                pcall(function() antiFallRemote:FireServer(counter.event, "clear_ragdoll") end)
                            end
                        end
                    end)
                end
            end
        end)
        local function hookAntiFallOnDamage()
            local char = Client.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            hum.HealthChanged:Connect(function()
                if not AntiFallEnabled then return end
                task.wait(0.05)
                pcall(function()
                    if RagdollModule and RagdollModule.is_ragdolling and RagdollModule.is_ragdolling.get() then
                        RagdollModule.is_ragdolling.set(false)
                    end
                    if hum.PlatformStand then hum.PlatformStand = false end
                    if antiFallRemote then
                        local counter = findCounterIdx()
                        if counter then
                            counter.event = (counter.event or 0) + 1
                            pcall(function() antiFallRemote:FireServer(counter.event, "end_ragdoll_early") end)
                        end
                    end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end)
        end
        if Client.Character then hookAntiFallOnDamage() end
        Client.CharacterAdded:Connect(function() task.spawn(function() task.wait(0.5) hookAntiFallOnDamage() end) end)

        -- VEHICLE
        local CarGuardEnabled = false
        pcall(function()
            local RemoteEvent = Instance.new('RemoteEvent')
            local oldFire = RemoteEvent.FireServer
            local hookedFire
            hookedFire = hookfunction(oldFire, newcclosure(function(self, ...)
                if not checkcaller() and CarGuardEnabled and tostring(self) == 'Send' then
                    local args = {...}
                    for _, v in pairs(args) do
                        if tostring(v) == 'crashed_car' then return nil end
                    end
                end
                return hookedFire(self, ...)
            end))
        end)

        local BumpAuraEnabled = false
        local function BumpAuraLoop()
            while BumpAuraEnabled do
                task.wait(0.1)
                pcall(function()
                    local car = VehicleSystem and VehicleSystem.get_car_player_is_in and VehicleSystem.get_car_player_is_in()
                    if not car then task.wait() else
                        local myChar = Client.Character
                        local targets = (Char and Char.get_all and Char.get_all()) or {}
                        for _, target in pairs(targets) do
                            if target ~= myChar then
                                local hrp = target:FindFirstChild('HumanoidRootPart')
                                if hrp and GetDistanceFromRootPart(hrp) < 100 then
                                    local Assembly = car.DriverSeat.AssemblyLinearVelocity + Vector3.new(65, 65, 65)
                                    Network.send('run_over', car, target, Assembly)
                                end
                            end
                        end
                    end
                end)
            end
        end

        local VehicleModsEnabled = false
        local VehicleModConfig = {
            Acceleration = 500, SlipThreshold = 2, StaticFriction = 20,
            TorqueMultiplier = 12, MaxSpeedMultiplier = 3.5, Slammed = false,
        }
        local SpeedBoostMultiplier = 3
        local vehicleOriginals = {}
        local function ApplyVehicleMods(vehicle)
            if not vehicle then return end
            vehicleOriginals[vehicle] = vehicleOriginals[vehicle] or { folders = {}, chassis = nil, wheels = {} }
            local store = vehicleOriginals[vehicle]
            for _, folder in ipairs(vehicle:GetChildren()) do
                if folder:IsA("Folder") then
                    store.folders[folder] = store.folders[folder] or {}
                    for _, attr in ipairs({ "acceleration", "slipThreshold", "staticFriction", "maxSpeedTorque", "minSpeedTorque", "maxSpeed", "max_speed", "MaxSpeed", "engine_force", "EngineForce", "torque", "Torque" }) do
                        local cur = folder:GetAttribute(attr)
                        if cur ~= nil and store.folders[folder][attr] == nil then store.folders[folder][attr] = cur end
                    end
                    pcall(function() folder:SetAttribute("acceleration", VehicleModConfig.Acceleration) end)
                    pcall(function() folder:SetAttribute("slipThreshold", VehicleModConfig.SlipThreshold) end)
                    pcall(function() folder:SetAttribute("staticFriction", VehicleModConfig.StaticFriction) end)
                    local oMax = store.folders[folder].maxSpeedTorque
                    local oMin = store.folders[folder].minSpeedTorque
                    if oMax then pcall(function() folder:SetAttribute("maxSpeedTorque", oMax * VehicleModConfig.TorqueMultiplier) end) end
                    if oMin then pcall(function() folder:SetAttribute("minSpeedTorque", oMin * VehicleModConfig.TorqueMultiplier) end) end
                    for _, engAttr in ipairs({ "engine_force", "EngineForce", "torque", "Torque" }) do
                        local orig = store.folders[folder][engAttr]
                        if orig ~= nil then pcall(function() folder:SetAttribute(engAttr, orig * SpeedBoostMultiplier) end) end
                    end
                    for _, spdAttr in ipairs({ "maxSpeed", "max_speed", "MaxSpeed" }) do
                        local oSpeed = store.folders[folder][spdAttr]
                        if oSpeed ~= nil then
                            pcall(function() folder:SetAttribute(spdAttr, oSpeed * VehicleModConfig.MaxSpeedMultiplier) end)
                        end
                    end
                end
            end
            local chassis = vehicle:FindFirstChild("Chassis")
            if chassis and chassis:IsA("BasePart") then
                for _, part in ipairs(vehicle:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        local nm = part.Name:lower()
                        if nm:find("wheel") or nm:find("tire") then
                            if not store.wheels[part] then
                                local cp = part.CustomPhysicalProperties
                                store.wheels[part] = cp and { density = cp.Density, friction = cp.Friction, elasticity = cp.Elasticity, fw = cp.FrictionWeight, ew = cp.ElasticityWeight } or false
                            end
                            pcall(function() part.CustomPhysicalProperties = PhysicalProperties.new(2, 3, 0, 10, 10) end)
                        end
                    end
                end
                if not store.chassis then
                    local cp = chassis.CustomPhysicalProperties
                    store.chassis = {
                        hadCustom = cp ~= nil, density = cp and cp.Density or 1, friction = cp and cp.Friction or 0.3,
                        elasticity = cp and cp.Elasticity or 0, frictionW = cp and cp.FrictionWeight or 1, elasticityW = cp and cp.ElasticityWeight or 1,
                    }
                end
                if VehicleModConfig.Slammed then
                    chassis.CustomPhysicalProperties = PhysicalProperties.new(50, store.chassis.friction, store.chassis.elasticity, store.chassis.frictionW, store.chassis.elasticityW)
                else
                    pcall(function()
                        chassis.CustomPhysicalProperties = PhysicalProperties.new(store.chassis.density, store.chassis.friction, store.chassis.elasticity, store.chassis.frictionW, store.chassis.elasticityW)
                    end)
                end
            end
        end
        local function RestoreVehicleMods()
            for vehicle, store in pairs(vehicleOriginals) do
                if vehicle and vehicle.Parent then
                    for folder, attrs in pairs(store.folders) do
                        if folder and folder.Parent then
                            for attr, val in pairs(attrs) do pcall(function() folder:SetAttribute(attr, val) end) end
                        end
                    end
                    for wheel, cp in pairs(store.wheels) do
                        if wheel and wheel.Parent and cp then
                            pcall(function() wheel.CustomPhysicalProperties = PhysicalProperties.new(cp.density, cp.friction, cp.elasticity, cp.fw, cp.ew) end)
                        end
                    end
                    local chassis = vehicle:FindFirstChild("Chassis")
                    if chassis and chassis:IsA("BasePart") and store.chassis then
                        pcall(function()
                            chassis.CustomPhysicalProperties = PhysicalProperties.new(store.chassis.density, store.chassis.friction, store.chassis.elasticity, store.chassis.frictionW, store.chassis.elasticityW)
                        end)
                    end
                end
            end
            vehicleOriginals = {}
        end
        task.spawn(function()
            while task.wait(0.25) do
                if VehicleModsEnabled then
                    pcall(function()
                        local char = Client.Character
                        if not char then return end
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if not hum or not hum.SeatPart then return end
                        local vehicle = hum.SeatPart.Parent
                        if vehicle then ApplyVehicleMods(vehicle) end
                    end)
                end
            end
        end)
        local StableDriveEnabled = true
        RunService.Heartbeat:Connect(function(dt)
            pcall(function()
                local char = Client.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or not hum.SeatPart then return end
                local vehicle = hum.SeatPart.Parent
                if not vehicle then return end
                local chassis = vehicle:FindFirstChild("Chassis") or vehicle.PrimaryPart
                if not chassis then return end
                if StableDriveEnabled then
                    local av = chassis.AssemblyAngularVelocity
                    chassis.AssemblyAngularVelocity = Vector3.new(av.X * 0.25, av.Y, av.Z * 0.25)
                    local look = chassis.CFrame.LookVector
                    local right = chassis.CFrame.RightVector
                    local vel = chassis.AssemblyLinearVelocity
                    local lateral = vel:Dot(right)
                    if math.abs(lateral) > 5 then chassis.AssemblyLinearVelocity = vel - (right * lateral * 0.7) end
                    local rX, rY, rZ = chassis.CFrame:ToOrientation()
                    local pitch = math.deg(rX)
                    local roll = math.deg(rZ)
                    if math.abs(roll) > 18 or math.abs(pitch) > 18 then
                        local flatLook = Vector3.new(chassis.CFrame.LookVector.X, 0, chassis.CFrame.LookVector.Z)
                        if flatLook.Magnitude > 0.01 then
                            local targetYaw = math.atan2(-flatLook.X, -flatLook.Z)
                            local corrected = CFrame.new(chassis.Position) * CFrame.Angles(0, targetYaw, 0)
                            chassis.CFrame = chassis.CFrame:Lerp(corrected, 0.35)
                        end
                    end
                end
                if VehicleModsEnabled then
                    local av = chassis.AssemblyAngularVelocity
                    if math.abs(av.X) > 4 or math.abs(av.Z) > 4 then chassis.AssemblyAngularVelocity = Vector3.new(av.X * 0.4, av.Y, av.Z * 0.4) end
                    if av.Magnitude > 15 then chassis.AssemblyAngularVelocity = Vector3.new(av.X * 0.3, av.Y * 0.9, av.Z * 0.3) end
                end
            end)
        end)

        -- AUTO FINISH
        local AutoFinishEnabled = false
        local FINISH_HOLD_TIME = 0.05
        local function setFinishPrompt(prompt)
            if prompt and prompt:IsA("ProximityPrompt") then
                pcall(function() prompt.HoldDuration = FINISH_HOLD_TIME end)
                pcall(function() prompt.MaxActivationDistance = 20 end)
            end
        end
        local function tryHoldPrompt(prompt, holdTime)
            if not prompt or prompt:GetAttribute("__AutoFinishBusy") then return end
            prompt:SetAttribute("__AutoFinishBusy", true)
            pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
            pcall(function() if prompt.HoldBegin then prompt:HoldBegin() end end)
            pcall(function() if prompt.Trigger then prompt:Trigger() end end)
            task.wait(holdTime or FINISH_HOLD_TIME)
            pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
            pcall(function() if prompt.HoldEnd then prompt:HoldEnd() end end)
            prompt:SetAttribute("__AutoFinishBusy", nil)
        end
        local function findFinishPrompts()
            local list = {}
            for _, char in ipairs(workspace:GetChildren()) do
                local plr = Players:GetPlayerFromCharacter(char)
                if plr and plr ~= Client then
                    local safe = false
                    for _, safeName in ipairs(SafePlayers) do
                        if safeName == plr.Name then safe = true break end
                    end
                    if not safe then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local prompt = hrp:FindFirstChild("FinishPrompt")
                            if prompt then setFinishPrompt(prompt) table.insert(list, prompt) end
                        end
                    end
                end
            end
            return list
        end
        local function applyFinishToAll()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Client and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local prompt = hrp:FindFirstChild("FinishPrompt")
                        if prompt then setFinishPrompt(prompt) end
                    end
                end
            end
        end
        local function setupFastFinish(plr)
            if plr == Client then return end
            local function onPrompt(child)
                if AutoFinishEnabled and child.Name == "FinishPrompt" and child:IsA("ProximityPrompt")
                    and child.Parent and child.Parent.Name == "HumanoidRootPart" then
                    setFinishPrompt(child)
                end
            end
            plr.CharacterAdded:Connect(function(char)
                char.DescendantAdded:Connect(onPrompt)
                local hrp = char:WaitForChild("HumanoidRootPart", 5)
                if hrp and AutoFinishEnabled then
                    local prompt = hrp:FindFirstChild("FinishPrompt")
                    if prompt then setFinishPrompt(prompt) end
                end
            end)
            if plr.Character then
                plr.Character.DescendantAdded:Connect(onPrompt)
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and AutoFinishEnabled then
                    local prompt = hrp:FindFirstChild("FinishPrompt")
                    if prompt then setFinishPrompt(prompt) end
                end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do setupFastFinish(plr) end
        Players.PlayerAdded:Connect(setupFastFinish)
        task.spawn(function()
            while true do
                task.wait(0.15)
                if AutoFinishEnabled then
                    for _, prompt in ipairs(findFinishPrompts()) do
                        task.spawn(function() tryHoldPrompt(prompt, FINISH_HOLD_TIME) end)
                    end
                end
            end
        end)

        -- AUTO HEAL
        local autoHealBusy = false
        local autoHealLastUse = 0
        local function stopAnimations()
            pcall(function()
                local char = Character or Client.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local animator = hum:FindFirstChildOfClass("Animator")
                if not animator then return end
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    pcall(function() track:Stop(0) end)
                end
            end)
        end
        local function getHealthTool()
            if not Backpack then return nil end
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local h = tool:GetAttribute("HealthRestoreAmount") or tool:GetAttribute("HealAmount") or tool:GetAttribute("RestoreHealth") or tool:GetAttribute("Medical")
                    if h and h > 0 then return tool end
                end
            end
            if Character then
                for _, tool in pairs(Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local h = tool:GetAttribute("HealthRestoreAmount") or tool:GetAttribute("HealAmount") or tool:GetAttribute("RestoreHealth") or tool:GetAttribute("Medical")
                        if h and h > 0 then return tool end
                    end
                end
            end
            return nil
        end
        local function useHealthTool(tool)
            if autoHealBusy then return end
            if tick() - autoHealLastUse < 0.4 then return end
            autoHealBusy = true
            autoHealLastUse = tick()
            local char = Character or Client.Character
            if not char then autoHealBusy = false return end
            local oldTool = char:FindFirstChildOfClass("Tool")
            pcall(function() tool.Parent = char end)
            task.wait(0.03)
            pcall(function() tool:Activate() end)
            task.wait(0.03)
            stopAnimations()
            task.wait(0.15)
            pcall(function() if tool and tool.Parent == char then tool.Parent = Backpack end end)
            if oldTool and oldTool.Parent == char then pcall(function() oldTool.Parent = Backpack end) end
            autoHealBusy = false
        end
        function func.AutoHeal()
            while task.wait(0.25) do
                if c().AutoHeal then
                    local char = Character or Client.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local hpPercent = (hum.Health / math.max(hum.MaxHealth, 1)) * 100
                            local threshold = c().HealThreshold or 50
                            if hpPercent <= threshold then
                                local tool = getHealthTool()
                                if tool then useHealthTool(tool) end
                            end
                        end
                    end
                end
            end
        end

        local function getTargetPart(player)
            local char = player.Character
            if not char then return nil end
            if PartTarget == "Random" then
                local options = { "Head", "HumanoidRootPart" }
                return char:FindFirstChild(options[math.random(1, #options)]) or char:FindFirstChild("Head")
            elseif PartTarget == "Body" then
                return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
            else
                return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            end
        end
        local function IsBehindWall(s, e, ignore)
            if not s or not e then return true end
            local ray = Ray.new(s, e - s)
            local ignoreList = { Character }
            if ignore then table.insert(ignoreList, ignore) end
            return workspace:FindPartOnRayWithIgnoreList(ray, ignoreList) ~= nil
        end
        local function getPing()
            local pg = Client:FindFirstChild("PlayerGui")
            if not pg then return 0.08 end
            local ns = pg:FindFirstChild("NetworkStats")
            if not ns then return 0.08 end
            local pl = ns:FindFirstChild("PingLabel")
            if not pl then return 0.08 end
            local n = tonumber(tostring(pl.Text):match("%d+"))
            if not n then return 0.08 end
            return math.clamp(n / 1000, 0, 2)
        end
        local VELOCITY_SAMPLES = 10
        local VELOCITY_Y_CLAMP = 150
        local VELOCITY_Y_DAMPEN = 0.85
        local velocityHistory = {}
        RunService.Heartbeat:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Client and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        velocityHistory[p] = velocityHistory[p] or {}
                        table.insert(velocityHistory[p], { time = os.clock(), pos = hrp.Position })
                        if #velocityHistory[p] > VELOCITY_SAMPLES then table.remove(velocityHistory[p], 1) end
                    else
                        velocityHistory[p] = nil
                    end
                end
            end
        end)
        Players.PlayerRemoving:Connect(function(p) velocityHistory[p] = nil end)
        local function calculateJuixVelocity(player)
            local hist = velocityHistory[player]
            if not hist or #hist < 2 then return Vector3.new() end
            local sum = Vector3.new()
            local count = 0
            for i = 2, #hist do
                local dt = hist[i].time - hist[i - 1].time
                if dt > 0 then sum = sum + (hist[i].pos - hist[i - 1].pos) / dt count = count + 1 end
            end
            if count == 0 then return Vector3.new() end
            local avg = sum / count
            if avg.Y > VELOCITY_Y_CLAMP then
                return Vector3.new(avg.X * 1.15, math.clamp(avg.Y * VELOCITY_Y_DAMPEN, 0, 400), avg.Z * 1.15)
            end
            return avg
        end

        local function predictTarget(player)
            local char = player.Character
            if not char then return nil, nil end
            local targetPart = getTargetPart(player)
            if not targetPart then return nil, nil end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return targetPart.Position, targetPart end

            local ping = math.clamp(getPing(), 0.05, 0.4)

            local vel = hrp.AssemblyLinearVelocity or Vector3.new()
            if vel.Magnitude > 250 then vel = vel.Unit * 250 end

            local velTracked = calculateJuixVelocity(player)

            local speed = velTracked.Magnitude
            local weightReal, weightTracked

            if speed < 5 then
                weightReal = 0.7
                weightTracked = 0.3
            elseif speed < 20 then
                weightReal = 0.4
                weightTracked = 0.6
            else
                weightReal = 0.2
                weightTracked = 0.8
            end

            local realPos = targetPart.Position + (vel * ping * 1.05)
            local trackedPos = targetPart.Position + (velTracked * ping * 1.25)

            local finalPos = (realPos * weightReal) + (trackedPos * weightTracked)

            local vy = vel.Y
            if vy > 15 then
                finalPos = finalPos + Vector3.new(0, math.min(vy * ping * 0.4, 3), 0)
            end

            local myRoot = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local dist = (myRoot.Position - hrp.Position).Magnitude
                if dist < 50 then
                    finalPos = targetPart.Position + (vel * ping * 1.0)
                end
            end

            return finalPos, targetPart
        end

        local function isShotgun()
            local char = Client.Character
            if not char then return false end
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then
                    local ammoType = item:GetAttribute("AmmoType")
                    if ammoType == "shotgun" or ammoType == "shootgun" then return true end
                end
            end
            return false
        end
        local function findCounter()
            for _, v in ipairs(getgc and getgc(true) or {}) do
                if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then return v end
            end
        end
        local function getPlayerList()
            local list = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Client then table.insert(list, player.Name) end
            end
            return list
        end
        Players.PlayerAdded:Connect(function()
            task.wait(0.5)
            if SafeDropdown then pcall(function() SafeDropdown:Refresh(getPlayerList()) end) end
        end)
        Players.PlayerRemoving:Connect(function(leavingPlayer)
            task.wait(0.5)
            for i = #SafePlayers, 1, -1 do
                if SafePlayers[i] == leavingPlayer.Name then table.remove(SafePlayers, i) end
            end
            if SafeDropdown then pcall(function() SafeDropdown:Refresh(getPlayerList()) end) end
        end)

        -- ✅ Tracer สีเขียวสว่าง
        local function createTracer(from, to)
            local dist = (to - from).Magnitude
            if dist < 0.1 then return end
            local line = Instance.new("Part")
            line.Anchored = true
            line.CanCollide = false
            line.Size = Vector3.new(0.20, 0.20, dist)
            line.CFrame = CFrame.lookAt(from, to) * CFrame.new(0, 0, -dist / 2)
            line.Material = Enum.Material.Neon
            line.Color = Color3.fromRGB(0, 255, 80)  -- 🟢 เขียวสว่าง
            line.Transparency = 0
            line.Parent = workspace
            Debris:AddItem(line, 1.5)
        end

        local function registerItems(folder)
            pcall(function()
                if not folder then return end
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA("Tool") then
                        local handle = item:FindFirstChild("Handle")
                        local key
                        local displayName = item:GetAttribute("DisplayName") or item.Name
                        local itemId = item:GetAttribute("ItemId") or item:GetAttribute("Id") or item.Name
                        local rarity = item:GetAttribute("RarityName") or "Common"
                        local imageId = item:GetAttribute("ImageId") or "rbxassetid://7072725737"
                        if handle then
                            local sm = handle:FindFirstChildOfClass("SpecialMesh")
                            if sm and sm.MeshId ~= "" then
                                key = sm.MeshId .. (sm.TextureId or "") .. "_RARITY_" .. rarity
                            elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                                key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
                            end
                        end
                        if not key and itemId and itemId ~= "" and itemId ~= item.Name then key = "ITEMID_" .. itemId .. "_RARITY_" .. rarity end
                        if not key then key = "NAME_" .. displayName .. "_" .. item.Name .. "_RARITY_" .. rarity end
                        au[key] = { Name = displayName, Rarity = rarity, ImageId = imageId, ToolName = item.Name }
                    end
                end
            end)
        end
        local function getItemKey(tool)
            local handle = tool:FindFirstChild("Handle")
            local displayName = tool:GetAttribute("DisplayName") or tool.Name
            local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
            local rarity = tool:GetAttribute("RarityName") or "Common"
            if handle then
                local sm = handle:FindFirstChildOfClass("SpecialMesh")
                if sm and sm.MeshId ~= "" then
                    return sm.MeshId .. (sm.TextureId or "") .. "_RARITY_" .. rarity
                elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                    return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
                end
            end
            if itemId and itemId ~= "" and itemId ~= tool.Name then return "ITEMID_" .. itemId .. "_RARITY_" .. rarity end
            return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
        end
        local function getWeaponInfo(tool)
            if not tool or not tool:IsA("Tool") then return nil end
            return au[getItemKey(tool)]
        end
        pcall(function()
            local itemsFolder = ReplicatedStorage:WaitForChild("Items", 5)
            if itemsFolder then
                for _, folderName in ipairs({ "gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish" }) do
                    local f = itemsFolder:FindFirstChild(folderName)
                    if f then registerItems(f) end
                end
            end
        end)
        local GunFolder = ReplicatedStorage:WaitForChild("Items", 10) and ReplicatedStorage.Items:WaitForChild("gun", 10)
        local function isGunTool(tool)
            if not tool or not tool:IsA("Tool") then return false end
            if GunFolder and GunFolder:FindFirstChild(tool.Name) then return true end
            if tool:FindFirstChild("Handle") then
                local attrs = tool:GetAttributes()
                if attrs.AmmoType or attrs.fire_rate or attrs.accuracy then return true end
            end
            return false
        end

        local function applyGodGun(tool)
            if not tool or not isGunTool(tool) then return end
            pcall(function()
                tool:SetAttribute("fire_rate", FireRateValue)
                tool:SetAttribute("accuracy", AccuracyValue)
                tool:SetAttribute("Recoil", RecoilValue)
                tool:SetAttribute("automatic", AutomaticValue)
                tool:SetAttribute("RecoilAmount", RecoilValue)
                tool:SetAttribute("Spread", 0)
                tool:SetAttribute("BulletSpread", 0)
            end)
        end
        task.spawn(function()
            while task.wait(0.3) do
                pcall(function()
                    if GunModsAutoApply then
                        local char = Client.Character
                        if char then
                            for _, item in ipairs(char:GetChildren()) do
                                if item:IsA("Tool") and isGunTool(item) then task.spawn(applyGodGun, item) end
                            end
                        end
                    end
                end)
            end
        end)

        local RapidFireEnabled = false
        local RAPID_FIRE_VALUE = math.huge
        local function FindFireRateAttribute(gun)
            if not gun then return nil end
            if gun:GetAttribute('fire_rate') ~= nil then return 'fire_rate' end
            for attrName, _ in pairs(gun:GetAttributes()) do
                if type(attrName) == 'string' and attrName:sub(-3) == '486' then return attrName end
            end
            return nil
        end
        local function IsGunForRapidFire(tool)
            if not tool or not tool:IsA('Tool') then return false end
            return tool:GetAttribute('reload_time') or tool:GetAttribute('AmmoType') or FindFireRateAttribute(tool)
        end
        local function ApplyRapidFire(gun)
            if not gun or not gun:IsA('Tool') then return end
            local attr = FindFireRateAttribute(gun)
            if attr then gun:SetAttribute(attr, RAPID_FIRE_VALUE) else gun:SetAttribute('fire_rate', RAPID_FIRE_VALUE) end
        end
        task.spawn(function()
            while task.wait(0.15) do
                if RapidFireEnabled then
                    local char = Client.Character
                    if char then
                        local tool = char:FindFirstChildOfClass('Tool')
                        if tool and IsGunForRapidFire(tool) then pcall(ApplyRapidFire, tool) end
                    end
                    local bp = Client:FindFirstChild('Backpack')
                    if bp then
                        for _, tool in pairs(bp:GetChildren()) do
                            if IsGunForRapidFire(tool) then pcall(ApplyRapidFire, tool) end
                        end
                    end
                end
            end
        end)

        Client.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            Character = char
            Humanoid = char:FindFirstChild("Humanoid")
            RootPart = char:FindFirstChild("HumanoidRootPart")
            if GunModsAutoApply then
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") and isGunTool(item) then task.spawn(applyGodGun, item) end
                end
            end
            char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and GunModsAutoApply then task.wait(0.1) applyGodGun(child) end
            end)
        end)

        local function claimAllQuests()
            task.spawn(function()
                pcall(function()
                    local counter = findCounter()
                    if not counter then return end
                    local function sendGet(...)
                        local args = { ... }
                        counter.func = (counter.func or 0) + 1
                        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get")
                        return remote:InvokeServer(counter.func, table.unpack(args))
                    end
                    local questsGui = Client:WaitForChild("PlayerGui"):WaitForChild("Quests")
                    local scroll = questsGui:WaitForChild("QuestsHolder"):WaitForChild("QuestsScrollingFrame")
                    for _, frame in ipairs(scroll:GetChildren()) do
                        if frame:IsA("Frame") or frame:IsA("TextButton") or frame:IsA("ImageButton") then
                            pcall(function() sendGet("claim_quest", frame.Name) end)
                            task.wait(0.2)
                        end
                    end
                end)
            end)
        end

        local EnabledSkip = false
        local function startSkipLoop()
            task.spawn(function()
                while EnabledSkip do
                    task.wait()
                    pcall(function()
                        if CrateController and CrateController.class and CrateController.class.objects then
                            for _, crate in pairs(CrateController.class.objects) do
                                if crate.states and crate.states.open and crate.states.open.set then crate.states.open.set(true) end
                                if CrateController.skipping and CrateController.skipping.set then CrateController.skipping.set(true) end
                            end
                        end
                        if CrateController and CrateController.spinning and CrateController.skip_spin then
                            if not CrateController.spinning.get() then CrateController.skip_spin() end
                        end
                    end)
                end
            end)
        end

        -- ========== ESP ==========
        local PlayerESPGui = Instance.new("ScreenGui")
        PlayerESPGui.Name = "StitchPlayerESP"
        PlayerESPGui.ResetOnSpawn = false
        PlayerESPGui.IgnoreGuiInset = true
        PlayerESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        PlayerESPGui.DisplayOrder = 50
        PlayerESPGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

        local ESPHolder = {}
        local SKELETON_CONNS = {
            { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
            { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
            { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
            { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
            { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
        }
        local function createESP(player)
            if ESPHolder[player] then return end
            local d = { invCache = "", skeletonLines = {} }
            local box = Instance.new("Frame", PlayerESPGui)
            box.Name = "ESP_" .. player.Name
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            box.Visible = false
            d.box = box
            local stroke = Instance.new("UIStroke", box)
            stroke.Thickness = 1.5
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            d.stroke = stroke
            local nameLbl = Instance.new("TextLabel", PlayerESPGui)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = player.Name
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLbl.TextStrokeTransparency = 0
            nameLbl.TextSize = 13
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.Visible = false
            d.name = nameLbl
            local hpBG = Instance.new("Frame", PlayerESPGui)
            hpBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            hpBG.BorderSizePixel = 0
            hpBG.Size = UDim2.new(0, 3, 0, 0)
            hpBG.Visible = false
            d.healthBG = hpBG
            local hpFill = Instance.new("Frame", hpBG)
            hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            hpFill.BorderSizePixel = 0
            hpFill.AnchorPoint = Vector2.new(0, 1)
            hpFill.Position = UDim2.new(0, 0, 1, 0)
            hpFill.Size = UDim2.new(1, 0, 1, 0)
            d.healthFill = hpFill
            local inv = Instance.new("Frame", PlayerESPGui)
            inv.BackgroundTransparency = 1
            inv.Visible = false
            d.invHolder = inv
            local lay = Instance.new("UIListLayout", inv)
            lay.FillDirection = Enum.FillDirection.Horizontal
            lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
            lay.VerticalAlignment = Enum.VerticalAlignment.Top
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.Padding = UDim.new(0, 3)
            for i = 1, #SKELETON_CONNS do
                local line = Drawing.new("Line")
                line.Thickness = 1
                line.Color = Color3.fromRGB(255, 255, 255)
                line.Transparency = 1
                line.Visible = false
                d.skeletonLines[i] = line
            end
            ESPHolder[player] = d
            ESPList[player] = d
        end
        local function removeESP(player)
            local d = ESPHolder[player]
            if d then
                if d.box then d.box:Destroy() end
                if d.name then d.name:Destroy() end
                if d.healthBG then d.healthBG:Destroy() end
                if d.invHolder then d.invHolder:Destroy() end
                if d.skeletonLines then
                    for _, l in ipairs(d.skeletonLines) do
                        if l and l.Remove then pcall(function() l:Remove() end) end
                    end
                end
                ESPHolder[player] = nil
                ESPList[player] = nil
            end
        end
        local lastESPUpdate = 0
        local ESP_UPDATE_INTERVAL = 1/45
        local function updateOneESP(player, d)
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            if not (char and hum and hrp and head and hum.Health > 0) then
                d.box.Visible = false
                d.name.Visible = false
                d.healthBG.Visible = false
                d.invHolder.Visible = false
                for _, l in ipairs(d.skeletonLines) do l.Visible = false end
                return
            end
            local leftArm = char:FindFirstChild("LeftUpperArm")
            local rightArm = char:FindFirstChild("RightUpperArm")
            local halfWidth
            if leftArm and rightArm then
                halfWidth = (rightArm.Position - leftArm.Position).Magnitude * 0.5 + 0.6
            else
                halfWidth = 2.0
            end
            local headTop = head.Position + Vector3.new(0, head.Size.Y * 0.5, 0)
            local hrpBot = hrp.Position - Vector3.new(0, hrp.Size.Y * 0.5 + 0.4, 0)
            local corners = {
                headTop + Vector3.new(-halfWidth, 0, 0),
                headTop + Vector3.new(halfWidth, 0, 0),
                hrpBot + Vector3.new(-halfWidth, 0, 0),
                hrpBot + Vector3.new(halfWidth, 0, 0),
            }
            local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
            local anyOnScreen = false
            for _, cPos in ipairs(corners) do
                local s, on = Camera:WorldToViewportPoint(cPos)
                if on and s.Z > 0 then
                    anyOnScreen = true
                    if s.X < minX then minX = s.X end
                    if s.X > maxX then maxX = s.X end
                    if s.Y < minY then minY = s.Y end
                    if s.Y > maxY then maxY = s.Y end
                end
            end
            if not anyOnScreen then
                d.box.Visible = false
                d.name.Visible = false
                d.healthBG.Visible = false
                d.invHolder.Visible = false
                for _, l in ipairs(d.skeletonLines) do l.Visible = false end
                return
            end
            local PAD_X = 4
            local PAD_TOP = 3
            local PAD_BOT = 4
            minX = minX - PAD_X
            maxX = maxX + PAD_X
            minY = minY - PAD_TOP
            maxY = maxY + PAD_BOT
            local height = maxY - minY
            local width = maxX - minX
            if height < 6 then
                d.box.Visible = false
                d.name.Visible = false
                d.healthBG.Visible = false
                d.invHolder.Visible = false
                return
            end
            local hpRatio = hum.Health / math.max(hum.MaxHealth, 1)
            local isLocked = (I == player)
            local boxCol = isLocked and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(255, 255, 255)
            d.box.Visible = ToggleBox
            d.box.Position = UDim2.fromOffset(minX, minY)
            d.box.Size = UDim2.fromOffset(width, height)
            d.stroke.Color = boxCol
            d.stroke.Thickness = 1.5
            d.name.Visible = ToggleName
            d.name.Text = (player.Name:gsub("[%[%]]", ""))
            d.name.Position = UDim2.fromOffset(minX + width / 2 - 60, minY - 17)
            d.name.Size = UDim2.fromOffset(120, 14)
            d.healthBG.Visible = ToggleHealth
            d.healthBG.Position = UDim2.fromOffset(minX - 6, minY)
            d.healthBG.Size = UDim2.fromOffset(3, height)
            d.healthFill.Size = UDim2.new(1, 0, hpRatio, 0)
            d.healthFill.BackgroundColor3 = Color3.fromHSV(hpRatio * 0.333, 0.9, 1)
            if inventoryViewerEnabled then
                d.invHolder.Visible = true
                d.invHolder.Position = UDim2.fromOffset(minX, minY + height + 2)
                d.invHolder.Size = UDim2.fromOffset(width, 24)
                local tools = {}
                for _, folderName in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
                    local folder = player:FindFirstChild(folderName)
                    if folder then
                        for _, item in ipairs(folder:GetChildren()) do
                            if item:IsA("Tool") and item.Name ~= "Fists" then table.insert(tools, item) end
                        end
                    end
                end
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") and item.Name ~= "Fists" then table.insert(tools, item) end
                end
                local parts = {}
                for _, t in ipairs(tools) do table.insert(parts, t.Name) end
                local key = table.concat(parts, "|")
                if key ~= d.invCache then
                    d.invCache = key
                    for _, cc in ipairs(d.invHolder:GetChildren()) do
                        if cc:IsA("Frame") then cc:Destroy() end
                    end
                    for _, tool in ipairs(tools) do
                        local info = getWeaponInfo(tool)
                        if info then
                            local f = Instance.new("Frame", d.invHolder)
                            f.Size = UDim2.new(0, 22, 0, 22)
                            f.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
                            f.BackgroundTransparency = 0.15
                            f.BorderSizePixel = 0
                            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
                            local fs = Instance.new("UIStroke", f)
                            fs.Color = at[info.Rarity] or Color3.new(1, 1, 1)
                            fs.Thickness = 1.5
                            fs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            local img = Instance.new("ImageLabel", f)
                            img.Size = UDim2.new(1, -4, 1, -4)
                            img.Position = UDim2.new(0, 2, 0, 2)
                            img.BackgroundTransparency = 1
                            img.Image = info.ImageId
                            img.ScaleType = Enum.ScaleType.Fit
                        end
                    end
                end
            else
                d.invHolder.Visible = false
            end
            if ToggleSkeleton then
                for i, conn in ipairs(SKELETON_CONNS) do
                    local pA = char:FindFirstChild(conn[1])
                    local pB = char:FindFirstChild(conn[2])
                    local line = d.skeletonLines[i]
                    if pA and pB then
                        local sA, oA = Camera:WorldToViewportPoint(pA.Position)
                        local sB, oB = Camera:WorldToViewportPoint(pB.Position)
                        if oA and oB and sA.Z > 0 and sB.Z > 0 then
                            line.From = Vector2.new(sA.X, sA.Y)
                            line.To = Vector2.new(sB.X, sB.Y)
                            line.Color = boxCol
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
            else
                for _, l in ipairs(d.skeletonLines) do l.Visible = false end
            end
        end
        local function loadESP()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Client and not ESPHolder[p] then createESP(p) end
            end
            Players.PlayerAdded:Connect(function(p) if p ~= Client then createESP(p) end end)
            Players.PlayerRemoving:Connect(function(p) removeESP(p) end)
            RunService.RenderStepped:Connect(function()
                local now = os.clock()
                if now - lastESPUpdate < ESP_UPDATE_INTERVAL then return end
                lastESPUpdate = now
                for player, d in pairs(ESPHolder) do updateOneESP(player, d) end
            end)
        end
        loadESP()

        local SpeedConnection = nil
        function func.SetupCharacter(newChar)
            Character = newChar
            Humanoid = newChar:WaitForChild("Humanoid")
            RootPart = newChar:WaitForChild("HumanoidRootPart")
            Backpack = Client:WaitForChild("Backpack", 5)
            if SpeedConnection then SpeedConnection:Disconnect() end
            SpeedConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    if c().WalkSpeedCustom and Humanoid and RootPart then
                        local dir = Humanoid.MoveDirection
                        if dir.Magnitude > 0 then
                            RootPart.CFrame = RootPart.CFrame + (dir.Unit * ((c().WalkSpeedValue or 2) / 155))
                        end
                    end
                end)
            end)
        end
        if Character then func.SetupCharacter(Character) end
        Client.CharacterAdded:Connect(func.SetupCharacter)

        local MoveConn = nil
        task.spawn(function()
            while task.wait() do
                pcall(function()
                    if (c().WalkSpeedCustom or c().JumpPowerCustom) and not MoveConn then
                        MoveConn = RunService.Heartbeat:Connect(function()
                            pcall(function()
                                if not Character or not IsAlive(Character) then return end
                                if c().WalkSpeedCustom then
                                    if Humanoid:GetAttribute("TargetWalkSpeed") ~= 30 and Humanoid.WalkSpeed ~= 30 then
                                        Humanoid:SetAttribute("TargetWalkSpeed", 30)
                                        Humanoid.WalkSpeed = 30
                                    end
                                end
                                if c().JumpPowerCustom then Humanoid.JumpHeight = c().JumpPowerValue or 10
                                else Humanoid.JumpHeight = 7.2 end
                            end)
                        end)
                    elseif not c().WalkSpeedCustom and not c().JumpPowerCustom and MoveConn then
                        MoveConn:Disconnect()
                        MoveConn = nil
                        if Character and IsAlive(Character) then
                            Humanoid.JumpHeight = 7.2
                            Humanoid.WalkSpeed = 16
                        end
                    end
                end)
            end
        end)

        local InfStaminaLoop = nil
        local OriginalSprintUpdate = nil
        function func.InfStamina()
            if not SprintModule then return end
            if InfStaminaLoop then task.cancel(InfStaminaLoop) InfStaminaLoop = nil end
            pcall(function()
                local consumeStamina = SprintModule.consume_stamina
                if not consumeStamina then return end
                local upval = getupvalue(consumeStamina, 2)
                if not upval then return end
                local sprintBar = upval.sprint_bar
                if not sprintBar then return end
                local original = sprintBar.update
                sprintBar.update = function(...) return original(function() return 1 end) end
                OriginalSprintUpdate = original
                InfStaminaLoop = task.spawn(function()
                    while c().InfStamina do
                        pcall(function()
                            Network.send("set_sprinting_1", true)
                            task.wait(0.5)
                            Network.send("set_sprinting_1", false)
                        end)
                        task.wait(0.1)
                    end
                    pcall(function() Network.send("set_sprinting_1", false) end)
                end)
            end)
        end
        task.spawn(function()
            local wasOn = false
            while task.wait(0.5) do
                pcall(function()
                    if c().InfStamina and not wasOn then
                        wasOn = true
                        func.InfStamina()
                    elseif not c().InfStamina and wasOn then
                        wasOn = false
                        if InfStaminaLoop then task.cancel(InfStaminaLoop) InfStaminaLoop = nil end
                        if OriginalSprintUpdate and SprintModule then
                            local consumeStamina = SprintModule.consume_stamina
                            if consumeStamina then
                                local upval = getupvalue(consumeStamina, 2)
                                if upval and upval.sprint_bar then upval.sprint_bar.update = OriginalSprintUpdate end
                            end
                        end
                        pcall(function() Network.send("set_sprinting_1", false) end)
                    end
                end)
            end
        end)

        -- AIM UI
        local AimGui = Instance.new("ScreenGui")
        AimGui.Name = "StitchAimUI"
        AimGui.ResetOnSpawn = false
        AimGui.IgnoreGuiInset = true
        AimGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        AimGui.DisplayOrder = 100
        AimGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

        local FOV_SIDES = 12
        local FOV_THICKNESS = 1
        local FovPolygon = Instance.new("Frame", AimGui)
        FovPolygon.Name = "FovPolygon"
        FovPolygon.AnchorPoint = Vector2.new(0.5, 0.5)
        FovPolygon.Position = UDim2.new(0.5, 0, 0.5, 0)
        FovPolygon.Size = UDim2.new(0, 0, 0, 0)
        FovPolygon.BackgroundTransparency = 1
        FovPolygon.BorderSizePixel = 0
        FovPolygon.Visible = false
        local FovSegments = {}
        for i = 1, FOV_SIDES do
            local seg = Instance.new("Frame", FovPolygon)
            seg.Name = "Seg" .. i
            seg.AnchorPoint = Vector2.new(0.5, 0.5)
            seg.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
            seg.BackgroundTransparency = 0
            seg.BorderSizePixel = 0
            seg.ZIndex = 2
            FovSegments[i] = seg
        end
        local RainbowFovEnabled = true
        local RainbowFovSpeed = 0.4
        local RainbowFovHue = 0
        local function updateFovPolygon(radius)
            if not radius or radius <= 0 then return end
            local angleStep = math.pi * 2 / FOV_SIDES
            local segLen = 2 * radius * math.sin(math.pi / FOV_SIDES)
            for i = 1, FOV_SIDES do
                local a1 = (i - 1) * angleStep
                local a2 = i * angleStep
                local x1, y1 = radius * math.cos(a1), radius * math.sin(a1)
                local x2, y2 = radius * math.cos(a2), radius * math.sin(a2)
                local mx, my = (x1 + x2) / 2, (y1 + y2) / 2
                local dx, dy = x2 - x1, y2 - y1
                local ang = math.deg(math.atan2(dy, dx))
                local seg = FovSegments[i]
                seg.Size = UDim2.fromOffset(segLen, FOV_THICKNESS)
                seg.Position = UDim2.fromOffset(mx, my)
                seg.Rotation = ang
            end
        end

        local MARKER_MIN_SIZE = 16
        local MARKER_MAX_SIZE = 28
        local MARKER_PIXEL_SCALE = 1.25

        local HeadMarker = Instance.new("Frame", AimGui)
        HeadMarker.Name = "HeadMarker"
        HeadMarker.AnchorPoint = Vector2.new(0.5, 0.5)
        HeadMarker.BackgroundTransparency = 1
        HeadMarker.BorderSizePixel = 0
        HeadMarker.Rotation = 0
        HeadMarker.Visible = false
        HeadMarker.ZIndex = 3
        local HeadMarkerStroke = Instance.new("UIStroke", HeadMarker)
        HeadMarkerStroke.Color = Color3.fromRGB(0, 255, 80)
        HeadMarkerStroke.Thickness = 1
        HeadMarkerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local CenterRedLine = Drawing.new("Line")
        CenterRedLine.Thickness = 1
        CenterRedLine.Color = Color3.fromRGB(0, 255, 80)
        CenterRedLine.Transparency = 0
        CenterRedLine.Visible = false

        local AimAssistEnabled = false
        local CrosshairHolder = Instance.new("Frame", AimGui)
        CrosshairHolder.Name = "AimAssistCrosshair"
        CrosshairHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        CrosshairHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
        CrosshairHolder.Size = UDim2.new(0, 24, 0, 24)
        CrosshairHolder.BackgroundTransparency = 1
        CrosshairHolder.BorderSizePixel = 0
        CrosshairHolder.Visible = false
        CrosshairHolder.ZIndex = 6

        local CROSS_COLOR = Color3.fromRGB(0, 255, 80)
        local CROSS_THICK = 1
        local CROSS_LEN = 6
        local CROSS_GAP = 4

        local cUp = Instance.new("Frame", CrosshairHolder)
        cUp.Size = UDim2.new(0, CROSS_THICK, 0, CROSS_LEN)
        cUp.Position = UDim2.new(0.5, 0, 0, -CROSS_GAP - CROSS_LEN)
        cUp.AnchorPoint = Vector2.new(0.5, 0)
        cUp.BackgroundColor3 = CROSS_COLOR
        cUp.BorderSizePixel = 0
        local cDown = Instance.new("Frame", CrosshairHolder)
        cDown.Size = UDim2.new(0, CROSS_THICK, 0, CROSS_LEN)
        cDown.Position = UDim2.new(0.5, 0, 1, CROSS_GAP + CROSS_LEN)
        cDown.AnchorPoint = Vector2.new(0.5, 1)
        cDown.BackgroundColor3 = CROSS_COLOR
        cDown.BorderSizePixel = 0
        local cLeft = Instance.new("Frame", CrosshairHolder)
        cLeft.Size = UDim2.new(0, CROSS_LEN, 0, CROSS_THICK)
        cLeft.Position = UDim2.new(0, -CROSS_GAP - CROSS_LEN, 0.5, 0)
        cLeft.AnchorPoint = Vector2.new(0, 0.5)
        cLeft.BackgroundColor3 = CROSS_COLOR
        cLeft.BorderSizePixel = 0
        local cRight = Instance.new("Frame", CrosshairHolder)
        cRight.Size = UDim2.new(0, CROSS_LEN, 0, CROSS_THICK)
        cRight.Position = UDim2.new(1, CROSS_GAP + CROSS_LEN, 0.5, 0)
        cRight.AnchorPoint = Vector2.new(1, 0.5)
        cRight.BackgroundColor3 = CROSS_COLOR
        cRight.BorderSizePixel = 0
        local cDot = Instance.new("Frame", CrosshairHolder)
        cDot.Size = UDim2.new(0, 2, 0, 2)
        cDot.Position = UDim2.new(0.5, 0, 0.5, 0)
        cDot.AnchorPoint = Vector2.new(0.5, 0.5)
        cDot.BackgroundColor3 = CROSS_COLOR
        cDot.BorderSizePixel = 0

        local MARKER_ROT_SPEED = 30
        local MarkerRotation = 0
        RunService.RenderStepped:Connect(function(dt)
            MarkerRotation = (MarkerRotation + dt * MARKER_ROT_SPEED) % 360
            HeadMarker.Rotation = MarkerRotation
        end)

        local function getClosestTarget()
            local closest = nil
            local closestDist = math.huge
            local center = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
            local myRoot = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Client and player.Character then
                    local skipPlayer = false
                    for _, safeName in ipairs(SafePlayers) do
                        if safeName == player.Name then skipPlayer = true break end
                    end
                    if not skipPlayer then
                        local targetPart = getTargetPart(player)
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if targetPart and humanoid and humanoid.Health > 0 then
                            if not c().WallBang and myRoot then
                                if not IsBehindWall(myRoot.Position, targetPart.Position, player.Character) then
                                    local sp, onScreen = CurrentCamera:WorldToViewportPoint(targetPart.Position)
                                    if onScreen then
                                        local sv = Vector2.new(sp.X, sp.Y)
                                        local dx = math.abs(sv.X - center.X)
                                        local dy = math.abs(sv.Y - center.Y)
                                        if dx <= H and dy <= H then
                                            local dist = dx + dy
                                            if dist < closestDist then closestDist = dist closest = player end
                                        end
                                    end
                                end
                            else
                                local sp, onScreen = CurrentCamera:WorldToViewportPoint(targetPart.Position)
                                if onScreen then
                                    local sv = Vector2.new(sp.X, sp.Y)
                                    local dx = math.abs(sv.X - center.X)
                                    local dy = math.abs(sv.Y - center.Y)
                                    if dx <= H and dy <= H then
                                        local dist = dx + dy
                                        if dist < closestDist then closestDist = dist closest = player end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return closest
        end

        pcall(function()
            if Network and Network.send and hookfunction then
                local OldSend
                OldSend = hookfunction(Network.send, function(...)
                    local args = { ... }
                    if F and args[1] == "shoot_gun" then
                        local target = getClosestTarget()
                        if target and target.Character then
                            local myChar = Client.Character
                            if myChar then
                                local origin = nil
                                local tool = myChar:FindFirstChildOfClass("Tool")
                                if tool then
                                    local muzzle = tool:FindFirstChild("Muzzle") 
                                        or tool:FindFirstChild("Barrel")
                                        or tool:FindFirstChild("FirePoint")
                                    if muzzle and muzzle:IsA("BasePart") then
                                        origin = muzzle.Position
                                    else
                                        local handle = tool:FindFirstChild("Handle")
                                        if handle and handle:IsA("BasePart") then
                                            origin = handle.Position
                                        end
                                    end
                                end
                                if not origin then
                                    local myHead = myChar:FindFirstChild("Head")
                                    if myHead then origin = myHead.Position end
                                end
                                if not origin then
                                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                                    if myHRP then origin = myHRP.Position end
                                end

                                if origin then
                                    local pos, part = predictTarget(target)
                                    if pos and part then
                                        if isShotgun() then
                                            args[3] = CFrame.new(origin, pos)
                                            local pellets = {}
                                            for i = 1, 12 do
                                                local jitter = Vector3.new(
                                                    (math.random() - 0.5) * 0.15,
                                                    (math.random() - 0.5) * 0.15,
                                                    (math.random() - 0.5) * 0.15)
                                                table.insert(pellets, { [1] = { Instance = part, Normal = Vector3.new(0, 1, 0), Position = pos + jitter } })
                                            end
                                            args[4] = pellets
                                        else
                                            args[3] = CFrame.new(origin, pos)
                                            args[4] = { { [1] = { Instance = part, Position = pos, Normal = Vector3.new(0, 1, 0) } } }
                                        end
                                        pcall(function() createTracer(origin, pos) end)
                                    end
                                end
                            end
                        end
                    end
                    return OldSend(unpack(args))
                end)
            end
        end)

        RunService.RenderStepped:Connect(function(dt)
            pcall(function()
                if F then I = getClosestTarget() else I = nil end
                FovPolygon.Visible = F
                if F then
                    updateFovPolygon(H)
                    if RainbowFovEnabled then
                        RainbowFovHue = (RainbowFovHue + dt * RainbowFovSpeed) % 1
                        for i = 1, FOV_SIDES do
                            local segHue = (RainbowFovHue + (i - 1) / FOV_SIDES) % 1
                            FovSegments[i].BackgroundColor3 = Color3.fromHSV(segHue, 1, 1)
                        end
                    else
                        for i = 1, FOV_SIDES do
                            FovSegments[i].BackgroundColor3 = Color3.fromRGB(0, 220, 80)
                        end
                    end
                end

                if I and I.Character then
                    local targetPart = getTargetPart(I)
                    if targetPart then
                        local worldPos = targetPart.Position
                        local pos, onScreen = CurrentCamera:WorldToViewportPoint(worldPos)

                        if onScreen and pos.Z > 0 then
                            local centerScreen = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
                            CenterRedLine.From = centerScreen
                            CenterRedLine.To = Vector2.new(pos.X, pos.Y)
                            CenterRedLine.Visible = true
                        else
                            CenterRedLine.Visible = false
                        end

                        if onScreen and pos.Z > 0 then
                            local hSize = targetPart.Size or Vector3.new(1, 1, 1)
                            local topW = worldPos + Vector3.new(0, hSize.Y * 0.5, 0)
                            local botW = worldPos - Vector3.new(0, hSize.Y * 0.5, 0)
                            local topS = CurrentCamera:WorldToViewportPoint(topW)
                            local botS = CurrentCamera:WorldToViewportPoint(botW)
                            local pixelSize = math.abs(topS.Y - botS.Y)
                            local finalSize = math.clamp(pixelSize * MARKER_PIXEL_SCALE, MARKER_MIN_SIZE, MARKER_MAX_SIZE)
                            HeadMarker.Position = UDim2.fromOffset(pos.X, pos.Y)
                            HeadMarker.Size = UDim2.fromOffset(finalSize, finalSize)
                            HeadMarkerStroke.Color = Color3.fromRGB(0, 255, 80)
                            HeadMarker.Visible = true
                        else
                            HeadMarker.Visible = false
                        end
                    else
                        HeadMarker.Visible = false
                        CenterRedLine.Visible = false
                    end
                else
                    HeadMarker.Visible = false
                    CenterRedLine.Visible = false
                end
            end)
        end)

        -- DROPPED ITEM ESP
        local droppedESP_UI = {}
        local droppedBoxDrawings = {}
        local droppedRarityColors = {
            Common = Color3.fromRGB(220, 220, 220), Uncommon = Color3.fromRGB(99, 255, 52),
            Rare = Color3.fromRGB(51, 170, 255), Epic = Color3.fromRGB(237, 44, 255),
            Legendary = Color3.fromRGB(255, 150, 0), Omega = Color3.fromRGB(255, 20, 51),
        }
        local droppedItemDatabase = {}
        local function formatImageId(id)
            if not id then return nil end
            if type(id) == "number" or (type(id) == "string" and tonumber(id)) then
                return "rbxassetid://" .. tostring(id)
            elseif type(id) == "string" and (id:find("rbxassetid://") or id:find("http")) then
                return id
            end
            return nil
        end
        local function registerDroppedItems()
            local ItemsFolder = ReplicatedStorage:FindFirstChild("Items")
            if not ItemsFolder then return end
            for _, folder in ipairs(ItemsFolder:GetChildren()) do
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Model") or item:IsA("Configuration") or item:IsA("Folder") then
                        local dispName = item:GetAttribute("DisplayName") or item.Name
                        local rarity = item:GetAttribute("RarityName") or item:GetAttribute("Rarity") or "Common"
                        local rawImg = item:GetAttribute("ImageId") or item:GetAttribute("Icon") or item:GetAttribute("Texture")
                        local img = formatImageId(rawImg)
                        if not img then
                            local handle = item:FindFirstChild("Handle")
                            if handle then
                                if handle:IsA("MeshPart") and handle.TextureID ~= "" then
                                    img = formatImageId(handle.TextureID)
                                else
                                    local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                                    if mesh and mesh.TextureId ~= "" then img = formatImageId(mesh.TextureId) end
                                end
                            end
                        end
                        img = img or "rbxassetid://7072725737"
                        local info = { Name = dispName, Rarity = rarity, ImageId = img, ToolName = item.Name }
                        droppedItemDatabase[item.Name:lower()] = info
                        local itemId = item:GetAttribute("ItemId") or item:GetAttribute("Id")
                        if itemId then droppedItemDatabase[tostring(itemId):lower()] = info end
                    end
                end
            end
        end
        pcall(registerDroppedItems)
        local function getDroppedItemInfo(itemModel)
            if not itemModel then return nil end
            local lowerName = itemModel.Name:lower()
            if droppedItemDatabase[lowerName] then return droppedItemDatabase[lowerName] end
            local dispName = itemModel:GetAttribute("DisplayName") or itemModel.Name
            local rarity = itemModel:GetAttribute("RarityName") or itemModel:GetAttribute("Rarity") or "Common"
            local rawImg = itemModel:GetAttribute("ImageId") or itemModel:GetAttribute("Icon") or itemModel:GetAttribute("Texture")
            local img = formatImageId(rawImg)
            if not img then
                local handle = itemModel:FindFirstChild("Handle")
                if handle then
                    if handle:IsA("MeshPart") and handle.TextureID ~= "" then
                        img = formatImageId(handle.TextureID)
                    else
                        local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                        if mesh and mesh.TextureId ~= "" then img = formatImageId(mesh.TextureId) end
                    end
                end
            end
            img = img or "rbxassetid://7072725737"
            local info = { Name = dispName, Rarity = rarity, ImageId = img, ToolName = itemModel.Name }
            droppedItemDatabase[lowerName] = info
            return info
        end
        local function createDroppedItemBillboard(itemModel)
            local target = itemModel:FindFirstChild("PickUpZone") or itemModel:FindFirstChildWhichIsA("BasePart") or itemModel.PrimaryPart
            if not target then return nil end
            local info = getDroppedItemInfo(itemModel)
            local rarityColor = info and droppedRarityColors[info.Rarity] or Color3.fromRGB(220, 220, 220)
            local imageId = info and info.ImageId or "rbxassetid://7072725737"
            local displayName = info and info.Name or itemModel.Name
            local amount = itemModel:GetAttribute("Amount") or 1
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "DroppedESP_" .. itemModel.Name
            billboard.Adornee = target
            billboard.Size = UDim2.new(0, 100, 0, 20)
            billboard.StudsOffset = Vector3.new(0, 1.0, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = gethui and gethui() or game:GetService("CoreGui")
            local highlight = Instance.new("Highlight")
            highlight.Name = "StitchESP_Highlight"
            highlight.Adornee = itemModel
            highlight.FillColor = rarityColor
            highlight.OutlineColor = rarityColor
            highlight.FillTransparency = 0.4
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = itemModel
            local main = Instance.new("Frame", billboard)
            main.Size = UDim2.new(1, 0, 1, 0)
            main.BackgroundTransparency = 1
            local layout = Instance.new("UIListLayout", main)
            layout.FillDirection = Enum.FillDirection.Horizontal
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 3)
            local iconFrame = Instance.new("Frame", main)
            iconFrame.Size = UDim2.new(0, 18, 0, 18)
            iconFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            iconFrame.BackgroundTransparency = 0.15
            iconFrame.LayoutOrder = 1
            Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(1, 0)
            local stroke = Instance.new("UIStroke", iconFrame)
            stroke.Color = rarityColor
            stroke.Thickness = 1.5
            local imgLabel = Instance.new("ImageLabel", iconFrame)
            imgLabel.Size = UDim2.new(1, -4, 1, -4)
            imgLabel.Position = UDim2.new(0, 2, 0, 2)
            imgLabel.BackgroundTransparency = 1
            imgLabel.Image = imageId
            local badge = Instance.new("Frame", main)
            badge.AutomaticSize = Enum.AutomaticSize.X
            badge.Size = UDim2.new(0, 0, 0, 16)
            badge.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            badge.BackgroundTransparency = 0.25
            badge.LayoutOrder = 2
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0.5, 0)
            local pad = Instance.new("UIPadding", badge)
            pad.PaddingLeft = UDim.new(0, 6)
            pad.PaddingRight = UDim.new(0, 6)
            local label = Instance.new("TextLabel", badge)
            label.AutomaticSize = Enum.AutomaticSize.X
            label.Size = UDim2.new(0, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.TextColor3 = rarityColor
            label.Text = (amount > 1) and (displayName .. " x" .. tostring(amount)) or displayName
            return billboard
        end
        local function createDroppedBox(itemModel)
            if droppedBoxDrawings[itemModel] then return end
            local lines = {}
            for i = 1, 12 do
                local line = Drawing.new("Line")
                line.Thickness = 1.5
                line.Transparency = 1
                line.Visible = false
                lines[i] = line
            end
            droppedBoxDrawings[itemModel] = lines
        end
        local function removeDroppedBox(itemModel)
            if droppedBoxDrawings[itemModel] then
                for _, line in ipairs(droppedBoxDrawings[itemModel]) do pcall(function() line:Remove() end) end
                droppedBoxDrawings[itemModel] = nil
            end
        end
        local function updateDroppedBox(itemModel, rarityColor, show)
            local lines = droppedBoxDrawings[itemModel]
            if not lines then return end
            if not show then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end
            local minVec = Vector3.new(math.huge, math.huge, math.huge)
            local maxVec = Vector3.new(-math.huge, -math.huge, -math.huge)
            local hasPart = false
            for _, part in ipairs(itemModel:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "PickUpZone" then
                    hasPart = true
                    local p = part.Position
                    local s = part.Size / 2
                    minVec = Vector3.new(math.min(minVec.X, p.X - s.X), math.min(minVec.Y, p.Y - s.Y), math.min(minVec.Z, p.Z - s.Z))
                    maxVec = Vector3.new(math.max(maxVec.X, p.X + s.X), math.max(maxVec.Y, p.Y + s.Y), math.max(maxVec.Z, p.Z + s.Z))
                end
            end
            if not hasPart then
                local ok, cf, size = pcall(function() return itemModel:GetBoundingBox() end)
                if ok and cf and size then
                    local half = size / 2
                    minVec = cf.Position - half
                    maxVec = cf.Position + half
                    hasPart = true
                end
            end
            if not hasPart then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end
            local corners = {
                Vector3.new(minVec.X, maxVec.Y, minVec.Z), Vector3.new(maxVec.X, maxVec.Y, minVec.Z),
                Vector3.new(maxVec.X, minVec.Y, minVec.Z), Vector3.new(minVec.X, minVec.Y, minVec.Z),
                Vector3.new(minVec.X, maxVec.Y, maxVec.Z), Vector3.new(maxVec.X, maxVec.Y, maxVec.Z),
                Vector3.new(maxVec.X, minVec.Y, maxVec.Z), Vector3.new(minVec.X, minVec.Y, maxVec.Z),
            }
            local screen = {}
            local anyVisible = false
            for k = 1, 8 do
                local sp, on = Camera:WorldToViewportPoint(corners[k])
                if on and sp.Z > 0 then
                    screen[k] = Vector2.new(sp.X, sp.Y)
                    anyVisible = true
                else screen[k] = nil end
            end
            if not anyVisible then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end
            local edges = {
                {1, 2}, {2, 3}, {3, 4}, {4, 1},
                {5, 6}, {6, 7}, {7, 8}, {8, 5},
                {1, 5}, {2, 6}, {3, 7}, {4, 8},
            }
            for k, edge in ipairs(edges) do
                local p1 = screen[edge[1]]
                local p2 = screen[edge[2]]
                local line = lines[k]
                if p1 and p2 then
                    line.From = p1
                    line.To = p2
                    line.Color = rarityColor
                    line.Visible = true
                else line.Visible = false end
            end
        end
        local function cleanupDroppedESP()
            for model, _ in pairs(droppedBoxDrawings) do
                if not model or not model.Parent then removeDroppedBox(model) end
            end
            for model, gui in pairs(droppedESP_UI) do
                if not model or not model.Parent then
                    if gui and gui.Parent then gui:Destroy() end
                    if model then
                        local hl = model:FindFirstChild("StitchESP_Highlight")
                        if hl then hl:Destroy() end
                    end
                    droppedESP_UI[model] = nil
                end
            end
        end

        local lastDropESPUpdate = 0
        local DROP_ESP_UPDATE_INTERVAL = 1/60
        RunService.RenderStepped:Connect(function()
            local now = os.clock()
            if now - lastDropESPUpdate < DROP_ESP_UPDATE_INTERVAL then return end
            lastDropESPUpdate = now
            cleanupDroppedESP()
            if not itemESPEnabled then
                for _, gui in pairs(droppedESP_UI) do if gui then gui.Enabled = false end end
                for _, lines in pairs(droppedBoxDrawings) do
                    for _, line in ipairs(lines) do line.Visible = false end
                end
                return
            end
            local dropped = workspace:FindFirstChild("DroppedItems")
            if not dropped then return end
            local root = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            for _, model in ipairs(dropped:GetChildren()) do
                if model:IsA("Model") and model.Name ~= "Money" and not model:GetAttribute("Locked") then
                    local target = model:FindFirstChild("PickUpZone") or model:FindFirstChildWhichIsA("BasePart") or model.PrimaryPart
                    if target then
                        local dist = (target.Position - root.Position).Magnitude
                        if dist <= 800 then
                            if not droppedESP_UI[model] or not droppedESP_UI[model].Parent then
                                droppedESP_UI[model] = createDroppedItemBillboard(model)
                            else
                                droppedESP_UI[model].Enabled = true
                                local hl = model:FindFirstChild("StitchESP_Highlight")
                                if hl then hl.Enabled = true end
                            end
                            if not droppedBoxDrawings[model] then createDroppedBox(model) end
                            local info = getDroppedItemInfo(model)
                            local rColor = info and droppedRarityColors[info.Rarity] or Color3.fromRGB(220, 220, 220)
                            updateDroppedBox(model, rColor, true)
                        else
                            if droppedESP_UI[model] then droppedESP_UI[model].Enabled = false end
                            local hl = model:FindFirstChild("StitchESP_Highlight")
                            if hl then hl.Enabled = false end
                            if droppedBoxDrawings[model] then
                                for _, line in ipairs(droppedBoxDrawings[model]) do line.Visible = false end
                            end
                        end
                    end
                end
            end
        end)
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.X then
                itemESPEnabled = not itemESPEnabled
                if not itemESPEnabled then
                    for _, gui in pairs(droppedESP_UI) do if gui then gui.Enabled = false end end
                    for _, item in ipairs(workspace:FindFirstChild("DroppedItems") and workspace.DroppedItems:GetChildren() or {}) do
                        local hl = item:FindFirstChild("StitchESP_Highlight")
                        if hl then hl.Enabled = false end
                    end
                    for _, lines in pairs(droppedBoxDrawings) do
                        for _, line in ipairs(lines) do line.Visible = false end
                    end
                end
                if WindUI then WindUI:Notify({ Title = itemESPEnabled and "Item ESP ON" or "Item ESP OFF", Duration = 2 }) end
            end
        end)

        -- TABS
        local MainTab = Window:Tab({ Title = 'General', Icon = 'globe' })
        local CombatTab = Window:Tab({ Title = 'Combat', Icon = 'swords' })
        local WeaponTab = Window:Tab({ Title = 'Weapon', Icon = 'wrench' })
        local VisualTab = Window:Tab({ Title = 'Visual', Icon = 'eye' })
        local VehicleTab = Window:Tab({ Title = 'Vehicle', Icon = 'car' })
        local MiscTab = Window:Tab({ Title = 'Misc', Icon = 'circle-ellipsis' })
        local ServerTab = Window:Tab({ Title = 'Server', Icon = 'server' })
        pcall(function() MainTab:Select() end)

        local function Section(Tab, Text) return Tab:Section({ Title = Text }) end
        local function Button(Tab, Title, Desc, Callback)
            return Tab:Button({ Title = Title, Desc = Desc, Locked = false, Callback = Callback or function() end })
        end

        MainTab:Section({ Title = 'BALANCE:' })
        local BankBalance = MainTab:Button({ Title = '🏦ATM Balance', Desc = 'ยอดเงิน ATM' })
        local HandBalance = MainTab:Button({ Title = '💸Hand Balance', Desc = 'ยอดเงินในมือ' })
        task.spawn(function()
            while task.wait(0.5) do
                pcall(function()
                    local hand = (Data and Data.money and Data.money.hand) or 0
                    local bank = (Data and Data.money and Data.money.bank) or 0
                    BankBalance:SetDesc('<b><font color="#00FF00">$' .. Comma(bank) .. '</font></b>')
                    HandBalance:SetDesc('<b><font color="#00f2ff">$' .. Comma(hand) .. '</font></b>')
                end)
            end
        end)

        MainTab:Section({ Title = 'PLAYER MODIFIER:' })
        MainTab:Toggle({ Title = 'Walk Speed', Desc = 'วิ่งไว', Flag = 'WalkSpeedCustom', Type = 'Checkbox', Value = false, Callback = function(v) c().WalkSpeedCustom = v end })
        MainTab:Slider({ Title = 'Speed Value', Desc = 'ค่าความเร็ว', Flag = 'WalkSpeedValue', Step = 0.1, Value = { Min = 1, Max = 5, Default = 2 }, Callback = function(v) c().WalkSpeedValue = v end })
        MainTab:Toggle({ Title = 'Jump Power', Desc = 'กระโดดสูง', Flag = 'JumpPowerCustom', Type = 'Checkbox', Value = false, Callback = function(v) c().JumpPowerCustom = v end })
        MainTab:Slider({ Title = 'Jump Value', Desc = 'ค่ากระโดด', Flag = 'JumpPowerValue', Step = 1, Value = { Min = 1, Max = 25, Default = 10 }, Callback = function(v) c().JumpPowerValue = v end })
        MainTab:Toggle({ Title = 'Infinite Stamina', Desc = 'สตามิน่าไม่จำกัด', Flag = 'InfStamina', Type = 'Checkbox', Value = false, Callback = function(v) c().InfStamina = v end })

        MainTab:Section({ Title = 'UTILITY:' })
        _G.AutoPickItems = false
        _G.BlacklistRarity = {}
        _G.AutoDropEnabled = false
        _G.AutoDropRarities = {}

        local function IsBlacklisted(item)
            if not item then return false end
            local dropName = item:GetAttribute('ItemName') or item.Name
            if not dropName then return false end
            local rarity = itemRarityCache[dropName] or item:GetAttribute("RarityName") or "Common"
            for _, r in ipairs(_G.BlacklistRarity) do
                if r == rarity then return true end
            end
            return false
        end

        task.spawn(function()
            while true do
                task.wait(0.05)
                if _G.AutoPickItems then
                    local myRoot = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local dropped = workspace:FindFirstChild("DroppedItems")
                        if dropped then
                            for _, model in ipairs(dropped:GetChildren()) do
                                if model:IsA("Model") and not model:GetAttribute("Locked") then
                                    local part = model:FindFirstChild("PickUpZone") or model:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        local dist = (myRoot.Position - part.Position).Magnitude
                                        if dist <= 25 then
                                            if not IsBlacklisted(model) then
                                                task.spawn(function()
                                                    pcall(function() Network.get('pickup_dropped_item', model) end)
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        MainTab:Toggle({ Title = 'Auto Pickup Items', Desc = 'เก็บของอัตโนมัติ', Flag = 'Pickitem', Type = 'Checkbox', Value = false, Callback = function(value) _G.AutoPickItems = value end })
        MainTab:Dropdown({ Title = 'Pickup Blacklist', Desc = 'แบล็คลิสต์การเก็บ', Flag = 'BlacklistRarity', Values = { 'Common', 'Uncommon', 'Rare', 'Epic', 'Legendary', 'Omega' }, Default = {}, Multi = true, AllowNone = true, Callback = function(selected) _G.BlacklistRarity = selected or {} end })
        MainTab:Toggle({ Title = 'Auto Drop Items', Desc = 'ทิ้งของอัตโนมัติ', Flag = 'AutoDropToggle', Type = 'Checkbox', Value = false, Callback = function(v) _G.AutoDropEnabled = v end })
        MainTab:Dropdown({ Title = 'Drop Rarity', Desc = 'ระดับที่ทิ้ง', Flag = 'AutoDropRarityList', Values = { 'Common', 'Uncommon', 'Rare', 'Epic', 'Legendary', 'Omega' }, Default = {}, Multi = true, AllowNone = true, Callback = function(selected) _G.AutoDropRarities = selected or {} end })

        MainTab:Section({ Title = 'PROTECTION:' })
        MainTab:Toggle({ Title = 'Anti Lock', Desc = 'กันล็อก', Flag = 'antilock', Type = 'Checkbox', Value = false, Callback = function(Value) c().AntiLock = Value if not Value then SavedHistoryCFrame = nil end end })
        MainTab:Toggle({ Title = 'Anti Ragdoll', Desc = 'กันเรนดิเกิ้ล', Flag = 'antifall', Type = 'Checkbox', Value = false, Callback = function(Value) 
            AntiFallEnabled = Value
            AntiRagdollEnabled = Value
        end })
        MainTab:Toggle({ Title = 'Hide Name', Desc = 'ซ่อนชื่อ', Flag = 'HideName', Type = 'Checkbox', Value = false, Callback = function(Value)
            _G.HideName = Value
            pcall(function()
                local char = Client.Character
                if char then
                    local hrp = char:FindFirstChild('HumanoidRootPart')
                    if hrp then
                        local bbGui = hrp:FindFirstChild('CharacterBillboardGui')
                        if bbGui then bbGui.Enabled = not _G.HideName end
                    end
                end
            end)
        end })
        MainTab:Toggle({ Title = 'Auto Mask', Flag = 'automask', Desc = 'ใส่หน้ากากอัตโนมัติ', Type = 'Checkbox', Value = false, Callback = function(Value)
            if not Value then return end
            pcall(function()
                local function GetAllInfos(itemName)
                    local infos = {}
                    local Holding = PlayerGui.Items:FindFirstChild('ItemsHolder').ItemsScrollingFrame
                    for _, v in ipairs(Holding:GetChildren()) do
                        if v.Name ~= 'Folder' and v.Name ~= 'UIGridLayout' and v.Name ~= 'ItemTemplate' then
                            if v.ItemName.Text == itemName then
                                table.insert(infos, { Uid = v.Name, Using = v:FindFirstChild('ItemEquipped').Visible, Drowning = v:FindFirstChild('DestroyedItemIcon').Visible })
                            end
                        end
                    end
                    return infos
                end
                local function EquipAccessory(itemName)
                    for _, info in ipairs(GetAllInfos(itemName)) do
                        if not info.Using and not info.Drowning then
                            Network.get('toggle_equip_item', info.Uid)
                            repeat task.wait() until GetAllInfos(itemName)[1].Using
                        end
                    end
                end
                EquipAccessory('Shiesty')
            end)
        end })

        MainTab:Section({ Title = 'AUTOMATION:' })
        MainTab:Toggle({ Title = 'Auto Finish', Desc = 'กระทืบอัตโนมัติ', Flag = 'AutoFinish', Type = 'Checkbox', Value = false, Callback = function(v) AutoFinishEnabled = v if v then applyFinishToAll() end end })
        MainTab:Toggle({ Title = 'Auto Heal', Flag = 'autohealth', Desc = 'ฟื้นเลือดอัตโนมัติ', Type = 'Checkbox', Value = false, Callback = function(state) c().AutoHeal = state if state then task.spawn(func.AutoHeal) end end })
        MainTab:Slider({ Title = 'Heal Threshold (%)', Flag = 'HealThreshold', Desc = 'ค่า HP ที่ฟื้น', Step = 1, Value = { Min = 1, Max = 99, Default = 50 }, Callback = function(v) c().HealThreshold = v end })

        -- Underground
        local EnabledSnapRunning = false
        local SnapThread = nil
        local YoffsetValue = 70
        local SnapBaseY = nil
        local SnapTargetPart = nil
        local function EnabledSnap()
            SnapBaseY = nil
            SnapTargetPart = nil
            while EnabledSnapRunning do
                task.wait()
                if not EnabledSnapRunning then break end
                local char = Client.Character
                if not char then continue end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end
                local targetPart = hrp
                if hum and hum.SeatPart then
                    local vehicle = hum.SeatPart.Parent
                    if vehicle then
                        local chassis = vehicle:FindFirstChild("Chassis") or vehicle:FindFirstChild("ChassisPart") or vehicle.PrimaryPart
                        if not chassis then
                            for _, d in ipairs(vehicle:GetDescendants()) do
                                if d:IsA("BasePart") then
                                    local n = d.Name:lower()
                                    if n:find("chassis") or n:find("body") or n:find("base") then chassis = d break end
                                end
                            end
                        end
                        if chassis then targetPart = chassis end
                    end
                end
                if SnapTargetPart ~= targetPart or not SnapBaseY then
                    SnapBaseY = targetPart.Position.Y
                    SnapTargetPart = targetPart
                end
                local targetY = SnapBaseY - YoffsetValue
                local deltaY = targetY - targetPart.Position.Y
                if math.abs(deltaY) > 0.01 then
                    targetPart.CFrame = targetPart.CFrame * CFrame.new(0, deltaY, 0)
                end
            end
            SnapBaseY = nil
            SnapTargetPart = nil
        end
        local function SetSnapState(value)
            if EnabledSnapRunning == value then return end
            EnabledSnapRunning = value
            if value then
                if not SnapThread then SnapThread = task.spawn(EnabledSnap) end
            else SnapThread = nil end
            pcall(function() MainTab:Get('UndergroundToggle'):SetValue(value) end)
        end
        MainTab:Section({ Title = 'UNDERGROUND:' })
        MainTab:Toggle({ Title = 'Underground', Desc = 'มุดดิน', Type = 'Checkbox', Value = false, Flag = 'UndergroundToggle', Callback = function(value) SetSnapState(value) end })
        MainTab:Keybind({ Title = 'Keybind', Desc = 'ปุ่มลัด', Flag = 'keybind', Value = 'G', Callback = function() SetSnapState(not EnabledSnapRunning) end })
        MainTab:Slider({ Title = 'Depth', Desc = 'ความลึก', Flag = 'snap_height', Step = 1, Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(value) YoffsetValue = value end })

        local GunSec = Section(CombatTab, 'SILENT AIM')
        GunSec:Toggle({ Title = "Silent Aim", Desc = "เล็งอัตโนมัติ", Type = 'Checkbox', Value = false, Callback = function(v) F = v if not v then I = nil end end })
        GunSec:Toggle({
            Title = "Aim Assist Crosshair",
            Desc  = "เป้าช่วยเล็ง",
            Type  = 'Checkbox', Value = false,
            Callback = function(v)
                AimAssistEnabled = v
                CrosshairHolder.Visible = v
            end
        })
        GunSec:Toggle({ Title = "Wall Bang", Desc = "ยิงทะลุกำแพง", Type = 'Checkbox', Value = false, Callback = function(v) c().WallBang = v end })
        GunSec:Toggle({ Title = "Rainbow FOV", Desc = "FOV สายรุ้ง", Type = 'Checkbox', Value = true, Callback = function(v) RainbowFovEnabled = v end })
        GunSec:Slider({ Title = "FOV Size", Desc = "ขนาด FOV", Step = 1, Value = { Min = 50, Max = 800, Default = 200 }, Callback = function(v) H = tonumber(v) or 200 end })
        GunSec:Dropdown({ Title = "Target Part", Desc = "จุดเล็งเป้า",
            Values = { "Head", "Body", "Random" }, Multi = false, AllowNone = false, Default = "Head",
            Callback = function(selected)
                if selected == "Head" then PartTarget = "Head"
                elseif selected == "Body" then PartTarget = "Body"
                elseif selected == "Random" then PartTarget = "Random" end
                if WindUI then WindUI:Notify({ Title = "Target", Content = "ล็อก: " .. tostring(selected), Duration = 2 }) end
            end
        })
        SafeDropdown = GunSec:Dropdown({ Title = "Safe Players", Desc = "ผู้เล่นปลอดภัย",
            Values = getPlayerList(), Multi = true, AllowNone = true,
            Callback = function(selected)
                SafePlayers = {}
                if typeof(selected) == "table" then
                    for _, name in ipairs(selected) do table.insert(SafePlayers, name) end
                elseif typeof(selected) == "string" then table.insert(SafePlayers, selected) end
            end
        })

        WeaponTab:Section({ Title = 'GUN MODS' })
        WeaponTab:Button({ Title = "Apply Now", Desc = "ใช้ทันที", Callback = function()
            local char = Client.Character
            if not char then return end
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") and isGunTool(item) then applyGodGun(item) end
            end
            if WindUI then WindUI:Notify({ Title = "Gun Mods", Content = "ใช้แล้ว", Duration = 2 }) end
        end })
        WeaponTab:Toggle({ Title = "Auto Apply", Desc = "ใช้อัตโนมัติ", Type = 'Checkbox', Value = false, Callback = function(v) GunModsAutoApply = v end })
        WeaponTab:Slider({ Title = "Fire Rate", Desc = "อัตราการยิง", Step = 100, Value = { Min = 100, Max = 3000, Default = 1000 }, Callback = function(v) FireRateValue = v end })
        WeaponTab:Slider({ Title = "Accuracy", Desc = "ความแม่นยำ", Step = 0.01, Value = { Min = 0, Max = 1, Default = 1 }, Callback = function(v) AccuracyValue = v end })
        WeaponTab:Slider({ Title = "Recoil", Desc = "แรงถอย", Step = 0.1, Value = { Min = 0, Max = 10, Default = 0 }, Callback = function(v) RecoilValue = v end })
        WeaponTab:Toggle({ Title = "Rapid Fire", Desc = "ยิงเร็ว", Type = 'Checkbox', Value = false, Callback = function(v)
            RapidFireEnabled = v
            if v then
                local char = Client.Character
                if char then
                    local tool = char:FindFirstChildOfClass('Tool')
                    if tool and IsGunForRapidFire(tool) then pcall(ApplyRapidFire, tool) end
                end
                local bp = Client:FindFirstChild('Backpack')
                if bp then
                    for _, tool in pairs(bp:GetChildren()) do
                        if IsGunForRapidFire(tool) then pcall(ApplyRapidFire, tool) end
                    end
                end
                if WindUI then WindUI:Notify({ Title = "Rapid Fire ON", Duration = 2 }) end
            else
                if WindUI then WindUI:Notify({ Title = "Rapid Fire OFF", Duration = 2 }) end
            end
        end })

        local PlayerESPSec = Section(VisualTab, "PLAYER ESP")
        PlayerESPSec:Toggle({ Title = "Name", Desc = "ชื่อ", Type = 'Checkbox', Value = false, Callback = function(v) ToggleName = v end })
        PlayerESPSec:Toggle({ Title = "Health", Desc = "เลือด", Type = 'Checkbox', Value = false, Callback = function(v) ToggleHealth = v end })
        PlayerESPSec:Toggle({ Title = "Box", Desc = "กรอบ", Type = 'Checkbox', Value = false, Callback = function(v) ToggleBox = v end })
        PlayerESPSec:Toggle({ Title = "Skeleton", Desc = "โครงกระดูก", Type = 'Checkbox', Value = false, Callback = function(v) ToggleSkeleton = v end })

        local ItemESPSec = Section(VisualTab, "ITEM ESP")
        ItemESPSec:Toggle({ Title = "Dropped Items", Desc = "ของที่ตก", Type = 'Checkbox', Value = false, Callback = function(v)
            itemESPEnabled = v
            if not v then
                for _, gui in pairs(droppedESP_UI) do if gui then gui.Enabled = false end end
                for _, item in ipairs(workspace:FindFirstChild("DroppedItems") and workspace.DroppedItems:GetChildren() or {}) do
                    local hl = item:FindFirstChild("StitchESP_Highlight")
                    if hl then hl.Enabled = false end
                end
                for _, lines in pairs(droppedBoxDrawings) do
                    for _, line in ipairs(lines) do line.Visible = false end
                end
            end
        end })

        local InvViewerSec = Section(VisualTab, "INVENTORY VIEWER")
        InvViewerSec:Toggle({ Title = "View Player Inventory", Desc = "ดูกระเป๋าผู้เล่น", Type = 'Checkbox', Value = false, Callback = function(v) inventoryViewerEnabled = v end })

        -- VEHICLE TAB
        local VehSec = Section(VehicleTab, "VEHICLE")
        Button(VehSec, "Bring My Car", "ดึงรถตัวเอง", function()
            pcall(function()
                local character = Client.Character or Client.CharacterAdded:Wait()
                local rootPart = character:WaitForChild("HumanoidRootPart")
                local vehicles = Workspace:WaitForChild("Vehicles")
                for _, vehicle in pairs(vehicles:GetChildren()) do
                    if vehicle:IsA("Model") then
                        local ownerId = vehicle:GetAttribute("OwnerUserId")
                        if ownerId and ownerId == Client.UserId then
                            local offset = CFrame.new(math.random(-5, 5), 3, math.random(-15, -5))
                            if vehicle.PrimaryPart then
                                vehicle:SetPrimaryPartCFrame(rootPart.CFrame * offset)
                            else
                                local part = vehicle:FindFirstChildWhichIsA("BasePart")
                                if part then part.CFrame = rootPart.CFrame * offset end
                            end
                        end
                    end
                end
                WindUI:Notify({ Title = "Vehicle", Content = "ดึงรถแล้ว", Duration = 2 })
            end)
        end)
        VehSec:Toggle({ Title = 'Car Guard', Desc = 'กันรถพัง', Type = 'Checkbox', Value = false, Callback = function(v) CarGuardEnabled = v end })
        VehSec:Toggle({ Title = 'Bump Aura', Desc = 'ชนออร่า', Type = 'Checkbox', Value = false, Callback = function(Value)
            BumpAuraEnabled = Value
            if Value then task.spawn(BumpAuraLoop) end
        end })
        VehSec:Toggle({ Title = 'Stable Drive', Desc = 'ขับนิ่ง', Type = 'Checkbox', Value = true, Callback = function(v) StableDriveEnabled = v end })
        VehSec:Toggle({ Title = 'Slammed', Desc = 'รถเตี้ย', Type = 'Checkbox', Value = false, Callback = function(v) VehicleModConfig.Slammed = v end })
        VehSec:Toggle({ Title = 'Vehicle Mods', Desc = 'ปรับแต่งรถ', Type = 'Checkbox', Value = false, Callback = function(v)
            VehicleModsEnabled = v
            if not v then RestoreVehicleMods() end
        end })
        VehSec:Slider({ Title = 'Acceleration', Desc = 'อัตราเร่ง', Step = 10, Value = { Min = 50, Max = 1000, Default = 500 }, Callback = function(v) VehicleModConfig.Acceleration = v end })
        VehSec:Slider({ Title = 'Slip Threshold', Desc = 'ค่าไถล', Step = 1, Value = { Min = 1, Max = 100, Default = 2 }, Callback = function(v) VehicleModConfig.SlipThreshold = v end })
        VehSec:Slider({ Title = 'Static Friction', Desc = 'แรงเสียดทาน', Step = 0.5, Value = { Min = 1, Max = 30, Default = 20 }, Callback = function(v) VehicleModConfig.StaticFriction = v end })
        VehSec:Slider({ Title = 'Torque Multiplier', Desc = 'ตัวคูณทอร์ก', Step = 0.5, Value = { Min = 0.1, Max = 20, Default = 12 }, Callback = function(v) VehicleModConfig.TorqueMultiplier = v end })
        VehSec:Slider({ Title = 'Max Speed', Desc = 'ความเร็วสูงสุด', Step = 0.1, Value = { Min = 1, Max = 10, Default = 3.5 }, Callback = function(v) VehicleModConfig.MaxSpeedMultiplier = v end })
        VehSec:Slider({ Title = 'Speed Boost', Desc = 'คูณความเร็วเพิ่มเติม', Step = 0.1, Value = { Min = 1, Max = 10, Default = 3 }, Callback = function(v) SpeedBoostMultiplier = v end })

        local CrateSec = Section(MiscTab, "CRATES & QUESTS")
        CrateSec:Button({ Title = "Claim All Quests", Desc = "รับภารกิจทั้งหมด", Callback = function()
            claimAllQuests()
            WindUI:Notify({ Title = "Quests", Content = "กำลังรับ...", Duration = 3 })
        end })
        CrateSec:Toggle({ Title = "Skip Crate Animation", Desc = "ข้ามแอนิเมชัน", Type = 'Checkbox', Value = false, Callback = function(v)
            EnabledSkip = v
            if EnabledSkip then
                startSkipLoop()
                WindUI:Notify({ Title = "Skip ON", Duration = 2 })
            else
                pcall(function()
                    if CrateController and CrateController.skipping and CrateController.skipping.set then
                        CrateController.skipping.set(false)
                    end
                end)
                WindUI:Notify({ Title = "Skip OFF", Duration = 2 })
            end
        end })
        CrateSec:Dropdown({ Title = "Ammo Crate", Desc = "กล่องกระสุน", Values = { "Pistol", "Rifle", "Shotgun", "Special" }, Callback = function(o) c().AmmoCrate = o end })
        CrateSec:Button({ Title = "Open Ammo Crate", Desc = "สุ่มกระสุน", Callback = function()
            pcall(function() Network.send("open_crate", workspace.Map.Tiles.GunShopTile.PatriotWeapons.Interior.Crates["Ammo Crate"].CrateOptions[c().AmmoCrate or "Pistol"], "money") end)
        end })
        CrateSec:Dropdown({ Title = "Weapon Crate", Desc = "กล่องปืน", Values = { "Basic", "Advanced", "Superior", "Elite", "Legendary" }, Callback = function(o) c().GunCrate = o end })
        CrateSec:Button({ Title = "Open Weapon Crate", Desc = "สุ่มปืน", Callback = function()
            pcall(function() Network.send("open_crate", workspace.Map.Tiles.GunShopTile.PatriotWeapons.Interior.Crates["Weapon Crate"].CrateOptions[c().GunCrate or "Basic"], "money") end)
        end })
        CrateSec:Dropdown({ Title = "Car Crate", Desc = "กล่องรถ", Values = { "Basic", "Rare", "Elite", "Omega" }, Callback = function(o) c().CarCrate = o end })
        CrateSec:Button({ Title = "Open Car Crate", Desc = "สุ่มรถ", Callback = function()
            pcall(function() Network.send("open_crate", workspace.Map.Tiles.PrestigeDealerAndHousing.PrestigeCarDealer.Interior.Crates["Car Crate"].CrateOptions[c().CarCrate or "Basic"], "money") end)
        end })

        local SSec = Section(ServerTab, "SERVER INFO")
        SSec:Code({ Title = "Info", Code = string.format("Place ID: %s\nJob ID: %s\nPlayers: %d / %d", game.PlaceId, game.JobId, #Players:GetPlayers(), Players.MaxPlayers) })
        SSec:Input({ Title = "Job ID", Desc = "Job ID", Value = "", InputIcon = "link", Type = "Input", Placeholder = "ใส่ Job ID ที่นี่...", Callback = function(v) c().JobID = v end })
        SSec:Button({ Title = "Join Server", Desc = "เข้าเซิร์ฟเวอร์", Callback = function()
            if not c().JobID or c().JobID == "" then
                WindUI:Notify({ Title = "ผิดพลาด", Content = "กรุณากรอก Job ID", Duration = 2 })
                return
            end
            WindUI:Notify({ Title = "กำลังเข้า", Content = "เซิร์ฟเวอร์ " .. c().JobID, Duration = 3 })
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, c().JobID, Client) end)
        end })
        SSec:Divider()
        Button(SSec, "Copy Job ID", "คัดลอก Job ID", function()
            if setclipboard then
                setclipboard(game.JobId)
                WindUI:Notify({ Title = "คัดลอกแล้ว", Content = "Job ID: " .. game.JobId, Duration = 2 })
            end
        end)
        Button(SSec, "Rejoin Server", "เข้าเซิร์ฟเดิม", function()
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Client) end)
        end)
        Button(SSec, "Hop Server", "เปลี่ยนเซิร์ฟเวอร์", function()
            pcall(function()
                local gameId = game.PlaceId
                local success, result = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Desc&limit=100"))
                end)
                if not success or not result or not result.data then return end
                local availableServers = {}
                for _, server in ipairs(result.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then table.insert(availableServers, server) end
                end
                if #availableServers == 0 then return end
                table.sort(availableServers, function(a, b) return a.playing > b.playing end)
                TeleportService:TeleportToPlaceInstance(gameId, availableServers[1].id, Client)
            end)
        end)

        print("[STITCH] v34 Ready - Green Neon + New Logo + Aim Precision!")

    end)
end

if bypassKeySystem then
    SendRobloxNotification("STITCH HUB", "คีย์เดิมใช้ได้ กำลังโหลด...", 2)
    task.spawn(function()
        repeat task.wait() until RunMainScript
        RunMainScript()
    end)
end