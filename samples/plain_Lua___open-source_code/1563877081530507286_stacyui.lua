-- X8 StacyUI security 20260922.1
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local isUnlocked = false
local isRenderingWarning = false
local cachedKey = ""
local keyStatusMsg = "Please sign in with Discord or activate a license key."
local keyFeedbackMsg = ""
local keyFeedbackColor = Color3.fromRGB(255, 90, 90)
local startupEnv = type(getgenv) == "function" and getgenv() or _G
startupEnv.StacyKeyVerified = false
startupEnv.StacyKeyToken = nil
if startupEnv.StacyKey == "SESSION_AUTHENTICATED" or (startupEnv.StacyKey and tostring(startupEnv.StacyKey):find("^ALPHA_DISCORD_")) then
    startupEnv.StacyKey = nil
end
if startupEnv.StacyCMDStartupKey == "SESSION_AUTHENTICATED" or (startupEnv.StacyCMDStartupKey and tostring(startupEnv.StacyCMDStartupKey):find("^ALPHA_DISCORD_")) then
    startupEnv.StacyCMDStartupKey = nil
end
startupEnv.StacyCMDStartupToken = nil
local discordPending = false
local discordExpiryTime = 0
local rememberKeyEnabled = true
local stagedAuthLink = "https://api.x8stuff.lol/auth/discord"
local sessionToken = nil
local cachedAccount = nil
local sessionAuthMode = nil
local requestedAuthRole = tostring(startupEnv.LarpkuranRequestedAuthRole or ""):upper()
local forceKeyLogin = startupEnv.LarpkuranForceKeyLogin == true
startupEnv.LarpkuranRequestedAuthRole, startupEnv.LarpkuranForceKeyLogin = nil, nil
local activateAsStand = requestedAuthRole == "STAND"
local activeRequestId = nil
local activeClaimSecret = nil
local lastPollTick = 0
local function syncAccountRole(account)
    if type(account) == "table" and (account.slotRole == "MAIN" or account.slotRole == "STAND") then
        activateAsStand = account.slotRole == "STAND"
    end
end

local req = (syn and syn.request) or (http and http.request) or http_request or request

local recoveryFlowActive = true
local authRestoreErrorCode = nil
local oldInsert = nil
local SoundService = game:GetService("SoundService")

local function playClickSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://129797567433050"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
        task.delay(5, function()
            if sound and sound.Parent then sound:Destroy() end
        end)
    end)
end

local function playLaunchSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://97972687450528"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
        task.delay(5, function()
            if sound and sound.Parent then sound:Destroy() end
        end)
    end)
end

local function showLarpkuranSelectionUI()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local localPlayer = Players.LocalPlayer
    local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

    local existing = playerGui:FindFirstChild("LarpkuranSelectionUI")
    if existing then
        existing:Destroy()
    end

    local function getAsset(path, url)
        if type(isfile) == "function" and not isfile(path) then
            if type(writefile) == "function" and type(game.HttpGet) == "function" then
                if type(makefolder) == "function" then
                    pcall(makefolder, "Staconf")
                    pcall(makefolder, "Staconf/assets")
                end
                local ok, data = pcall(game.HttpGet, game, url)
                if ok and type(data) == "string" and #data > 100 and data:sub(1, 8) == "\137PNG\r\n\26\n" then
                    pcall(writefile, path, data)
                end
            end
        end
        local assetFunc = getgenv and getgenv().gca or getcustomasset or getsynasset
        if type(assetFunc) == "function" then
            local ok, res = pcall(assetFunc, path)
            if ok and res then return res end
        end
        return ""
    end

    local diskIconAsset = getAsset("Staconf/assets/larpkuran-disk.png", "https://raw.githubusercontent.com/x8lua/Staconf/main/assets/larpkuran-disk.png")
    local betaDiskIconAsset = getAsset("Staconf/assets/larpkuran-beta-disk.png", "https://raw.githubusercontent.com/x8lua/Staconf/main/assets/larpkuran-beta-disk.png")

    local function font(weight)
        local ok, face = pcall(Font.new, "rbxassetid://12187365364", weight or Enum.FontWeight.Regular)
        return ok and face or Font.fromEnum(Enum.Font.Gotham)
    end

    local autoLoginDisabled = false
    if type(isfile) == "function" and isfile("x8stuff_disable_autologin.txt") then
        autoLoginDisabled = true
    end

    local function setAutoLoginDisabled(val)
        autoLoginDisabled = val
        if type(writefile) == "function" and type(delfile) == "function" then
            if val then
                pcall(writefile, "x8stuff_disable_autologin.txt", "true")
            else
                if type(isfile) == "function" and isfile("x8stuff_disable_autologin.txt") then
                    pcall(delfile, "x8stuff_disable_autologin.txt")
                end
            end
        end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LarpkuranSelectionUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    pcall(function() screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets end)
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999
    screenGui.Parent = playerGui
    screenGui:SetAttribute("LayoutVersion", "20260926004")

    local window = Instance.new("Frame")
    window.Name = "MacPanel"
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.Position = UDim2.fromScale(0.5, 0.5)
    window.Size = UDim2.fromOffset(840, 380)
    window.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
    window.BackgroundTransparency = 0
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Parent = screenGui

    local windowScale = Instance.new("UIScale")
    windowScale.Parent = window

    local windowStroke = Instance.new("UIStroke")
    windowStroke.Color = Color3.fromRGB(38, 40, 48)
    windowStroke.Transparency = 0.3
    windowStroke.Thickness = 1
    windowStroke.Parent = window

    local pickerContainer = Instance.new("ScrollingFrame")
    pickerContainer.Name = "PickerContainer"
    pickerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    pickerContainer.Position = UDim2.fromScale(0.5, 0.48)
    pickerContainer.Size = UDim2.new(1, -30, 0, 250)
    pickerContainer.BackgroundTransparency = 1
    pickerContainer.BorderSizePixel = 0
    pickerContainer.ScrollBarThickness = 0
    pickerContainer.ScrollingEnabled = false
    pickerContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    pickerContainer.CanvasSize = UDim2.fromOffset(0, 0)
    pickerContainer.Parent = window

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Padding = UDim.new(0, 14)
    rowLayout.Parent = pickerContainer

    local mobileGrid = Instance.new("UIGridLayout")
    mobileGrid.FillDirection = Enum.FillDirection.Horizontal
    mobileGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    mobileGrid.VerticalAlignment = Enum.VerticalAlignment.Top
    mobileGrid.SortOrder = Enum.SortOrder.LayoutOrder
    mobileGrid.CellPadding = UDim2.fromOffset(10, 10)

    local versions = {
        {
            id = "full-prod",
            title = "Full Production",
            subtitle = "Production Build",
            icon = diskIconAsset,
            layoutOrder = 1,
            config = { Name = "Full", ModeName = "Full Prod", Disabled = false, Url = "https://api.x8stuff.lol/scripts/larpkuran.lua" },
        },
        {
            id = "pvp-prod",
            title = "PvP Production",
            subtitle = "Production Build",
            icon = diskIconAsset,
            layoutOrder = 2,
            config = { Name = "PVP", ModeName = "PVP Mode", Disabled = false, Maintenance = false, Url = "https://api.x8stuff.lol/scripts/larpkuran-pvp.lua" },
        },
        {
            id = "full-beta",
            title = "Full Beta",
            subtitle = "Beta Channel • v2.0",
            icon = betaDiskIconAsset,
            layoutOrder = 4,
            config = { Name = "FullBeta", ModeName = "Full Beta", Disabled = false, Url = "https://api.x8stuff.lol/scripts/larpkuran-dev.lua" },
        },
        {
            id = "pvp-beta",
            title = "PvP Beta",
            subtitle = "Beta Channel",
            icon = betaDiskIconAsset,
            layoutOrder = 5,
        config = { Name = "PvpBeta", ModeName = "PVP Beta", Disabled = false, Maintenance = false, Url = "https://api.x8stuff.lol/scripts/larpkuran-pvp-beta.lua" },
        },
    }

    local separatorContainer = Instance.new("Frame")
    separatorContainer.Name = "ProdBetaSeparator"
    separatorContainer.Size = UDim2.fromOffset(20, 200)
    separatorContainer.BackgroundTransparency = 1
    separatorContainer.LayoutOrder = 3
    separatorContainer.Parent = pickerContainer

    local separatorLine = Instance.new("Frame")
    separatorLine.Name = "Line"
    separatorLine.AnchorPoint = Vector2.new(0.5, 0.5)
    separatorLine.Position = UDim2.fromScale(0.5, 0.44)
    separatorLine.Size = UDim2.fromOffset(1, 150)
    separatorLine.BackgroundColor3 = Color3.fromRGB(60, 64, 76)
    separatorLine.BorderSizePixel = 0
    separatorLine.Parent = separatorContainer

    local separatorGradient = Instance.new("UIGradient")
    separatorGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.15),
        NumberSequenceKeypoint.new(0.8, 0.15),
        NumberSequenceKeypoint.new(1, 1),
    })
    separatorGradient.Rotation = 90
    separatorGradient.Parent = separatorLine

    local selected = versions[1]
    local hovered = nil
    local cards = {}
    local executing = false
    local alive = true
    local connections = {}
    local compactLayout = false

    local function track(connection)
        table.insert(connections, connection)
        return connection
    end

    local function playTween(object, info, properties)
        local tween = TweenService:Create(object, info, properties)
        tween:Play()
        return tween
    end

    local function refresh()
        for _, entry in ipairs(cards) do
            local isSel = selected == entry.version
            local isHov = hovered == entry.version
            local disabled = entry.version.config and entry.version.config.Disabled == true
            local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            entry.icon.ImageColor3 = disabled and Color3.fromRGB(105, 108, 118) or Color3.fromRGB(255, 255, 255)
            entry.title.TextColor3 = disabled and Color3.fromRGB(132, 135, 145) or Color3.fromRGB(250, 250, 255)
            entry.subtitle.TextColor3 = disabled and Color3.fromRGB(185, 188, 198) or Color3.fromRGB(150, 154, 168)
            if entry.maintenance then
                entry.maintenance.Visible = disabled and isHov
            end
            if disabled then
                entry.card.BackgroundColor3 = Color3.fromRGB(43, 45, 51)
                playTween(entry.card, info, { BackgroundTransparency = 0.2 })
                playTween(entry.outline, info, { Transparency = isHov and 0.15 or 0.5, Color = Color3.fromRGB(100, 103, 112) })
                entry.continue.Visible = false
            elseif isSel then
                playTween(entry.card, info, { BackgroundTransparency = 0.45 })
                playTween(entry.outline, info, { Transparency = 0, Color = Color3.fromRGB(140, 145, 165) })
                entry.continue.Visible = not entry.version.config.Disabled
                playTween(entry.continue, info, { BackgroundTransparency = 0, TextTransparency = 0 })
            elseif isHov then
                playTween(entry.card, info, { BackgroundTransparency = 0.85 })
                playTween(entry.outline, info, { Transparency = 0.75, Color = Color3.fromRGB(110, 114, 125) })
                playTween(entry.continue, info, { BackgroundTransparency = 1, TextTransparency = 1 })
                entry.continue.Visible = false
            else
                playTween(entry.card, info, { BackgroundTransparency = 1 })
                playTween(entry.outline, info, { Transparency = 1 })
                playTween(entry.continue, info, { BackgroundTransparency = 1, TextTransparency = 1 })
                entry.continue.Visible = false
            end
        end
    end

    local function launchSelected()
        if executing or not selected or not selected.config or selected.config.Disabled then return end
        executing = true

        local targetUrl = selected.config.Url
        local fadeInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        playTween(window, fadeInfo, { BackgroundTransparency = 1 })
        playTween(windowStroke, fadeInfo, { Transparency = 1 })
        for _, desc in ipairs(window:GetDescendants()) do
            if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
                playTween(desc, fadeInfo, { ImageTransparency = 1 })
            elseif desc:IsA("TextLabel") or desc:IsA("TextButton") then
                playTween(desc, fadeInfo, { TextTransparency = 1, BackgroundTransparency = 1 })
            elseif desc:IsA("UIStroke") then
                playTween(desc, fadeInfo, { Transparency = 1 })
            end
        end

        task.delay(0.28, function()
            if screenGui.Parent then screenGui:Destroy() end
            task.spawn(function()
                if _G.LarpkuranShellShutdown then
                    pcall(_G.LarpkuranShellShutdown)
                end
                if _G.LarpkuranShellCycleConn then
                    pcall(function() _G.LarpkuranShellCycleConn:Disconnect() end)
                    _G.LarpkuranShellCycleConn = nil
                end
                local cg = game:GetService("CoreGui")
                for _, child in ipairs(cg:GetChildren()) do
                    if child.Name == "Iris_Root" then
                        for _, d in ipairs(child:GetDescendants()) do
                            if d:IsA("TextLabel") and d.Text:find("StacyKEYS") then
                                pcall(function() child:Destroy() end)
                                break
                            end
                        end
                    end
                end
                local env = type(getgenv) == "function" and getgenv() or _G
                env.StacyKeyVerified = true
                if sessionToken then
                    env.StacyKeyToken = sessionToken
                    env.StacyCMDStartupToken = sessionToken
                end
                if cachedKey and #cachedKey > 0 then
                    env.StacyKey = "SESSION_AUTHENTICATED"
                    env.StacyCMDStartupKey = "SESSION_AUTHENTICATED"
                    env.X8_KEY = nil
                elseif sessionToken then
                    local fallbackKey = "ALPHA_DISCORD_" .. tostring(sessionToken):sub(1, 12)
                    env.StacyKey = "SESSION_AUTHENTICATED"
                    env.StacyCMDStartupKey = "SESSION_AUTHENTICATED"
                    env.X8_KEY = nil
                end
                local ok, err = pcall(function()
                    local sep = targetUrl:find("%?") and "&" or "?"
                    local bustUrl = targetUrl .. sep .. "t=" .. tostring(os.time())
                    return loadstring(game:HttpGet(bustUrl))()
                end)
                if not ok then
                    warn("[LarpkuranPicker] execution error: " .. tostring(err))
                end
            end)
        end)
    end

    local lastClickId = nil
    local lastClickAt = 0

    for _, version in ipairs(versions) do
        local slot = Instance.new("Frame")
        slot.Name = version.id .. "Slot"
        slot.Size = UDim2.fromOffset(176, 245)
        slot.BackgroundTransparency = 1
        slot.LayoutOrder = version.layoutOrder
        slot.Parent = pickerContainer

        local card = Instance.new("TextButton")
        card.Name = "Card"
        card.AnchorPoint = Vector2.new(0.5, 0)
        card.Position = UDim2.new(0.5, 0, 0, 0)
        card.Size = UDim2.fromOffset(170, 192)
        card.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.AutoButtonColor = false
        card.Text = ""
        card.Parent = slot

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 18)
        cardCorner.Parent = card

        local outline = Instance.new("UIStroke")
        outline.Color = Color3.fromRGB(140, 145, 165)
        outline.Transparency = 1
        outline.Thickness = 1.5
        outline.Parent = card

        local icon = Instance.new("ImageLabel")
        icon.Name = "DiskIcon"
        icon.AnchorPoint = Vector2.new(0.5, 0)
        icon.Position = UDim2.new(0.5, 0, 0, 14)
        icon.Size = UDim2.fromOffset(116, 116)
        icon.BackgroundTransparency = 1
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Image = version.icon ~= "" and version.icon or "rbxassetid://16898670469"
        if version.icon == "" then
            icon.ImageRectSize = Vector2.new(256, 256)
            icon.ImageRectOffset = Vector2.new(0, 0)
            icon.ImageColor3 = Color3.fromRGB(220, 222, 230)
        end
        icon.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.AnchorPoint = Vector2.new(0.5, 1)
        titleLabel.Position = UDim2.new(0.5, 0, 1, -26)
        titleLabel.Size = UDim2.new(1, -8, 0, 22)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = version.title
        titleLabel.TextColor3 = Color3.fromRGB(250, 250, 255)
        titleLabel.TextSize = 16
        titleLabel.FontFace = font(Enum.FontWeight.SemiBold)
        titleLabel.Parent = card

        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Name = "Subtitle"
        subtitleLabel.AnchorPoint = Vector2.new(0.5, 1)
        subtitleLabel.Position = UDim2.new(0.5, 0, 1, -10)
        subtitleLabel.Size = UDim2.new(1, -8, 0, 16)
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Text = version.subtitle
        subtitleLabel.TextColor3 = Color3.fromRGB(150, 154, 168)
        subtitleLabel.TextSize = 13
        subtitleLabel.FontFace = font(Enum.FontWeight.Regular)
        subtitleLabel.Parent = card

        local maintenanceLabel = Instance.new("TextLabel")
        maintenanceLabel.Name = "MaintenanceTooltip"
        maintenanceLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        maintenanceLabel.Position = UDim2.fromScale(0.5, 0.46)
        maintenanceLabel.Size = UDim2.new(1, -18, 0, 30)
        maintenanceLabel.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
        maintenanceLabel.BackgroundTransparency = 0.08
        maintenanceLabel.BorderSizePixel = 0
        maintenanceLabel.Text = "Maintenance"
        maintenanceLabel.TextColor3 = Color3.fromRGB(240, 242, 248)
        maintenanceLabel.TextSize = 13
        maintenanceLabel.FontFace = font(Enum.FontWeight.Medium)
        maintenanceLabel.Visible = false
        maintenanceLabel.ZIndex = 4
        maintenanceLabel.Parent = card
        local maintenanceCorner = Instance.new("UICorner")
        maintenanceCorner.CornerRadius = UDim.new(0, 7)
        maintenanceCorner.Parent = maintenanceLabel

        local continueButton = Instance.new("TextButton")
        continueButton.Name = "Continue"
        continueButton.AnchorPoint = Vector2.new(0.5, 0)
        continueButton.Position = UDim2.new(0.5, 0, 0, 204)
        continueButton.Size = UDim2.fromOffset(104, 30)
        continueButton.BackgroundColor3 = Color3.fromRGB(92, 95, 106)
        continueButton.BorderSizePixel = 0
        continueButton.Text = version.config.Disabled and "Unavailable" or "Continue"
        continueButton.TextColor3 = Color3.fromRGB(250, 250, 255)
        continueButton.TextSize = 15
        continueButton.FontFace = font(Enum.FontWeight.Medium)
        continueButton.Visible = false
        continueButton.AutoButtonColor = false
        continueButton.Parent = slot

        local continueCorner = Instance.new("UICorner")
        continueCorner.CornerRadius = UDim.new(1, 0)
        continueCorner.Parent = continueButton

        track(continueButton.MouseEnter:Connect(function()
            playTween(continueButton, TweenInfo.new(0.16), { BackgroundColor3 = Color3.fromRGB(122, 126, 140) })
        end))
        track(continueButton.MouseLeave:Connect(function()
            playTween(continueButton, TweenInfo.new(0.16), { BackgroundColor3 = Color3.fromRGB(92, 95, 106) })
        end))
        track(continueButton.Activated:Connect(function()
            if version.config.Disabled then return end
            selected = version
            launchSelected()
        end))

        track(card.MouseEnter:Connect(function()
            hovered = version
            refresh()
        end))
        track(card.MouseLeave:Connect(function()
            if hovered == version then hovered = nil end
            refresh()
        end))
        track(card.Activated:Connect(function()
            if version.config.Disabled then
                return
            end
            local now = os.clock()
            if not compactLayout and selected == version and lastClickId == version.id and now - lastClickAt <= 0.5 then
                launchSelected()
            else
                selected = version
                refresh()
            end
            lastClickId = version.id
            lastClickAt = now
        end))

        table.insert(cards, {
            version = version, slot = slot, card = card, outline = outline,
            icon = icon, title = titleLabel, subtitle = subtitleLabel, maintenance = maintenanceLabel, continue = continueButton,
        })
    end

    local bottomBar = Instance.new("Frame")
    bottomBar.Name = "BottomBar"
    bottomBar.AnchorPoint = Vector2.new(0.5, 1)
    bottomBar.Position = UDim2.new(0.5, 0, 1, -12)
    bottomBar.Size = UDim2.fromOffset(240, 44)
    bottomBar.BackgroundTransparency = 1
    bottomBar.Parent = window

    local bottomLayout = Instance.new("UIListLayout")
    bottomLayout.FillDirection = Enum.FillDirection.Horizontal
    bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    bottomLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    bottomLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bottomLayout.Padding = UDim.new(0, 36)
    bottomLayout.Parent = bottomBar

    local shutDownButton = Instance.new("TextButton")
    shutDownButton.Name = "ShutDownButton"
    shutDownButton.Size = UDim2.fromOffset(72, 44)
    shutDownButton.BackgroundTransparency = 1
    shutDownButton.Text = ""
    shutDownButton.AutoButtonColor = false
    shutDownButton.LayoutOrder = 1
    shutDownButton.Parent = bottomBar

    local shutDownIcon = Instance.new("ImageLabel")
    shutDownIcon.Name = "Icon"
    shutDownIcon.AnchorPoint = Vector2.new(0.5, 0)
    shutDownIcon.Position = UDim2.new(0.5, 0, 0, 0)
    shutDownIcon.Size = UDim2.fromOffset(22, 22)
    shutDownIcon.BackgroundTransparency = 1
    shutDownIcon.Image = "rbxassetid://16898618049"
    shutDownIcon.ImageRectSize = Vector2.new(256, 256)
    shutDownIcon.ImageRectOffset = Vector2.new(0, 0)
    shutDownIcon.ImageColor3 = Color3.fromRGB(175, 178, 188)
    shutDownIcon.Parent = shutDownButton

    local shutDownLabel = Instance.new("TextLabel")
    shutDownLabel.Name = "Label"
    shutDownLabel.AnchorPoint = Vector2.new(0.5, 1)
    shutDownLabel.Position = UDim2.new(0.5, 0, 1, 0)
    shutDownLabel.Size = UDim2.new(1, 8, 0, 18)
    shutDownLabel.BackgroundTransparency = 1
    shutDownLabel.Text = "Shut Down"
    shutDownLabel.TextColor3 = Color3.fromRGB(175, 178, 188)
    shutDownLabel.TextSize = 13
    shutDownLabel.FontFace = font(Enum.FontWeight.Regular)
    shutDownLabel.Parent = shutDownButton

    local settingsButton = Instance.new("TextButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Size = UDim2.fromOffset(72, 44)
    settingsButton.BackgroundTransparency = 1
    settingsButton.Text = ""
    settingsButton.AutoButtonColor = false
    settingsButton.LayoutOrder = 2
    settingsButton.Parent = bottomBar

    local settingsIcon = Instance.new("ImageLabel")
    settingsIcon.Name = "Icon"
    settingsIcon.AnchorPoint = Vector2.new(0.5, 0)
    settingsIcon.Position = UDim2.new(0.5, 0, 0, 0)
    settingsIcon.Size = UDim2.fromOffset(22, 22)
    settingsIcon.BackgroundTransparency = 1
    settingsIcon.Image = "rbxassetid://6031280882"
    settingsIcon.ImageColor3 = Color3.fromRGB(175, 178, 188)
    settingsIcon.Parent = settingsButton

    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Name = "Label"
    settingsLabel.AnchorPoint = Vector2.new(0.5, 1)
    settingsLabel.Position = UDim2.new(0.5, 0, 1, 0)
    settingsLabel.Size = UDim2.new(1, 8, 0, 18)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Text = "Settings"
    settingsLabel.TextColor3 = Color3.fromRGB(175, 178, 188)
    settingsLabel.TextSize = 13
    settingsLabel.FontFace = font(Enum.FontWeight.Regular)
    settingsLabel.Parent = settingsButton

    track(settingsButton.MouseEnter:Connect(function()
        local info = TweenInfo.new(0.16)
        playTween(settingsIcon, info, { ImageColor3 = Color3.fromRGB(255, 255, 255) })
        playTween(settingsLabel, info, { TextColor3 = Color3.fromRGB(255, 255, 255) })
    end))
    track(settingsButton.MouseLeave:Connect(function()
        local info = TweenInfo.new(0.16)
        playTween(settingsIcon, info, { ImageColor3 = Color3.fromRGB(175, 178, 188) })
        playTween(settingsLabel, info, { TextColor3 = Color3.fromRGB(175, 178, 188) })
    end))

    local modalOverlay = Instance.new("Frame")
    modalOverlay.Name = "SettingsModalOverlay"
    modalOverlay.Size = UDim2.fromScale(1, 1)
    modalOverlay.Position = UDim2.fromScale(0, 0)
    modalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    modalOverlay.BackgroundTransparency = 1
    modalOverlay.Visible = false
    modalOverlay.ZIndex = 60
    modalOverlay.Active = true
    modalOverlay.Parent = window

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, 0)
    modalCorner.Parent = modalOverlay

    local modalDialog = Instance.new("Frame")
    modalDialog.Name = "Dialog"
    modalDialog.AnchorPoint = Vector2.new(0.5, 0.5)
    modalDialog.Position = UDim2.fromScale(0.5, 0.5)
    modalDialog.Size = UDim2.fromOffset(420, 230)
    modalDialog.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
    modalDialog.BorderSizePixel = 0
    modalDialog.ZIndex = 61
    modalDialog.Parent = modalOverlay

    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 12)
    dialogCorner.Parent = modalDialog

    local dialogStroke = Instance.new("UIStroke")
    dialogStroke.Color = Color3.fromRGB(48, 52, 66)
    dialogStroke.Thickness = 1
    dialogStroke.Parent = modalDialog

    local modalTitle = Instance.new("TextLabel")
    modalTitle.Name = "Title"
    modalTitle.Position = UDim2.new(0, 20, 0, 16)
    modalTitle.Size = UDim2.new(1, -40, 0, 24)
    modalTitle.BackgroundTransparency = 1
    modalTitle.Text = "Picker Settings"
    modalTitle.TextColor3 = Color3.fromRGB(240, 242, 250)
    modalTitle.TextSize = 16
    modalTitle.FontFace = font(Enum.FontWeight.SemiBold)
    modalTitle.TextXAlignment = Enum.TextXAlignment.Left
    modalTitle.ZIndex = 62
    modalTitle.Parent = modalDialog

    local modalSubtitle = Instance.new("TextLabel")
    modalSubtitle.Name = "Subtitle"
    modalSubtitle.Position = UDim2.new(0, 20, 0, 42)
    modalSubtitle.Size = UDim2.new(1, -40, 0, 16)
    modalSubtitle.BackgroundTransparency = 1
    modalSubtitle.Text = "Configure startup and authorization preferences"
    modalSubtitle.TextColor3 = Color3.fromRGB(130, 134, 148)
    modalSubtitle.TextSize = 12
    modalSubtitle.FontFace = font(Enum.FontWeight.Regular)
    modalSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    modalSubtitle.ZIndex = 62
    modalSubtitle.Parent = modalDialog

    local toggleRow = Instance.new("Frame")
    toggleRow.Name = "ToggleRow"
    toggleRow.Position = UDim2.new(0, 20, 0, 78)
    toggleRow.Size = UDim2.new(1, -40, 0, 58)
    toggleRow.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    toggleRow.BorderSizePixel = 0
    toggleRow.ZIndex = 62
    toggleRow.Parent = modalDialog

    local toggleRowCorner = Instance.new("UICorner")
    toggleRowCorner.CornerRadius = UDim.new(0, 8)
    toggleRowCorner.Parent = toggleRow

    local toggleRowStroke = Instance.new("UIStroke")
    toggleRowStroke.Color = Color3.fromRGB(40, 44, 56)
    toggleRowStroke.Thickness = 1
    toggleRowStroke.Parent = toggleRow

    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "Label"
    toggleText.Position = UDim2.new(0, 14, 0, 10)
    toggleText.Size = UDim2.new(1, -80, 0, 20)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = "Disable Auto Login on next session"
    toggleText.TextColor3 = Color3.fromRGB(235, 238, 245)
    toggleText.TextSize = 13
    toggleText.FontFace = font(Enum.FontWeight.Medium)
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.ZIndex = 63
    toggleText.Parent = toggleRow

    local toggleHint = Instance.new("TextLabel")
    toggleHint.Name = "Hint"
    toggleHint.Position = UDim2.new(0, 14, 0, 30)
    toggleHint.Size = UDim2.new(1, -80, 0, 16)
    toggleHint.BackgroundTransparency = 1
    toggleHint.Text = "Skips saved session and forces key entry screen"
    toggleHint.TextColor3 = Color3.fromRGB(120, 124, 138)
    toggleHint.TextSize = 11
    toggleHint.FontFace = font(Enum.FontWeight.Regular)
    toggleHint.TextXAlignment = Enum.TextXAlignment.Left
    toggleHint.ZIndex = 63
    toggleHint.Parent = toggleRow

    local toggleSwitch = Instance.new("TextButton")
    toggleSwitch.Name = "Switch"
    toggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
    toggleSwitch.Position = UDim2.new(1, -14, 0.5, 0)
    toggleSwitch.Size = UDim2.fromOffset(46, 26)
    toggleSwitch.BackgroundColor3 = autoLoginDisabled and Color3.fromRGB(45, 120, 255) or Color3.fromRGB(48, 52, 64)
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Text = ""
    toggleSwitch.AutoButtonColor = false
    toggleSwitch.ZIndex = 63
    toggleSwitch.Parent = toggleRow

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch

    local switchKnob = Instance.new("Frame")
    switchKnob.Name = "Knob"
    switchKnob.AnchorPoint = Vector2.new(0, 0.5)
    switchKnob.Position = autoLoginDisabled and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    switchKnob.Size = UDim2.fromOffset(20, 20)
    switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchKnob.BorderSizePixel = 0
    switchKnob.ZIndex = 64
    switchKnob.Parent = toggleSwitch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = switchKnob

    local function updateSwitchVisual()
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if autoLoginDisabled then
            playTween(toggleSwitch, info, { BackgroundColor3 = Color3.fromRGB(45, 120, 255) })
            playTween(switchKnob, info, { Position = UDim2.new(1, -23, 0.5, 0) })
        else
            playTween(toggleSwitch, info, { BackgroundColor3 = Color3.fromRGB(48, 52, 64) })
            playTween(switchKnob, info, { Position = UDim2.new(0, 3, 0.5, 0) })
        end
    end

    track(toggleSwitch.Activated:Connect(function()
        setAutoLoginDisabled(not autoLoginDisabled)
        updateSwitchVisual()
    end))

    local doneButton = Instance.new("TextButton")
    doneButton.Name = "DoneButton"
    doneButton.AnchorPoint = Vector2.new(1, 1)
    doneButton.Position = UDim2.new(1, -20, 1, -16)
    doneButton.Size = UDim2.fromOffset(90, 32)
    doneButton.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
    doneButton.BorderSizePixel = 0
    doneButton.Text = "Done"
    doneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    doneButton.TextSize = 13
    doneButton.FontFace = font(Enum.FontWeight.SemiBold)
    doneButton.AutoButtonColor = false
    doneButton.ZIndex = 63
    doneButton.Parent = modalDialog

    local doneCorner = Instance.new("UICorner")
    doneCorner.CornerRadius = UDim.new(0, 6)
    doneCorner.Parent = doneButton

    local function closeSettings()
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local t = playTween(modalOverlay, info, { BackgroundTransparency = 1 })
        playTween(modalDialog, info, { BackgroundTransparency = 1 })
        t.Completed:Connect(function()
            modalOverlay.Visible = false
        end)
    end

    local function openSettings()
        modalOverlay.Visible = true
        modalOverlay.BackgroundTransparency = 1
        modalDialog.BackgroundTransparency = 0
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        playTween(modalOverlay, info, { BackgroundTransparency = 0.55 })
    end

    track(settingsButton.Activated:Connect(openSettings))
    track(doneButton.Activated:Connect(closeSettings))

    track(shutDownButton.MouseEnter:Connect(function()
        local info = TweenInfo.new(0.16)
        playTween(shutDownIcon, info, { ImageColor3 = Color3.fromRGB(255, 255, 255) })
        playTween(shutDownLabel, info, { TextColor3 = Color3.fromRGB(255, 255, 255) })
    end))
    track(shutDownButton.MouseLeave:Connect(function()
        local info = TweenInfo.new(0.16)
        playTween(shutDownIcon, info, { ImageColor3 = Color3.fromRGB(175, 178, 188) })
        playTween(shutDownLabel, info, { TextColor3 = Color3.fromRGB(175, 178, 188) })
    end))
    track(shutDownButton.Activated:Connect(function()
        if executing then return end
        executing = true
        local fade = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeTween = playTween(window, fade, { BackgroundTransparency = 1 })
        playTween(windowStroke, fade, { Transparency = 1 })
        for _, desc in ipairs(window:GetDescendants()) do
            if desc:IsA("ImageLabel") or desc:IsA("ImageButton") then
                playTween(desc, fade, { ImageTransparency = 1 })
            elseif desc:IsA("TextLabel") or desc:IsA("TextButton") then
                playTween(desc, fade, { TextTransparency = 1, BackgroundTransparency = 1 })
            elseif desc:IsA("UIStroke") then
                playTween(desc, fade, { Transparency = 1 })
            end
        end
        fadeTween.Completed:Connect(function()
            if screenGui.Parent then screenGui:Destroy() end
        end)
    end))

    local function cycleSelection(dir)
        local currentIndex = 1
        for idx, version in ipairs(versions) do
            if version == selected then
                currentIndex = idx
                break
            end
        end
        local nextIndex = currentIndex + dir
        if nextIndex < 1 then nextIndex = #versions end
        if nextIndex > #versions then nextIndex = 1 end
        selected = versions[nextIndex]
        refresh()
    end

    local dragging = false
    local dragStart
    local startPos
    track(window.InputBegan:Connect(function(input)
        if compactLayout then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            track(input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end))
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if not alive or not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
    track(UserInputService.InputBegan:Connect(function(input)
        if not alive or executing then return end
        if input.KeyCode == Enum.KeyCode.Y or input.KeyCode == Enum.KeyCode.Escape then
            if screenGui.Parent then screenGui:Destroy() end
        elseif input.KeyCode == Enum.KeyCode.Left then
            cycleSelection(-1)
        elseif input.KeyCode == Enum.KeyCode.Right then
            cycleSelection(1)
        elseif input.KeyCode == Enum.KeyCode.Return then
            launchSelected()
        end
    end))

    local function fitWindow()
        local viewport = screenGui.AbsoluteSize
        if viewport.X <= 0 or viewport.Y <= 0 then return end
        compactLayout = UserInputService.TouchEnabled or viewport.X < 900 or viewport.Y < 420
        dragging = false
        if compactLayout then
            local panelWidth = math.min(440, math.max(1, viewport.X - 20))
            local panelHeight = math.min(580, math.max(1, viewport.Y - 20))
            local innerWidth = math.max(1, panelWidth - 30)
            local columns = panelWidth < 330 and 1 or 2
            local slotWidth = columns == 1 and math.min(176, innerWidth)
                or math.floor((innerWidth - 10) / 2)
            local slotHeight = 224
            local rows = math.ceil(#cards / columns)
            local contentHeight = rows * slotHeight + (rows - 1) * 10
            window.Size = UDim2.fromOffset(panelWidth, panelHeight)
            window.Position = UDim2.fromScale(0.5, 0.5)
            windowScale.Scale = 1
            pickerContainer.AnchorPoint = Vector2.new(0.5, 0)
            pickerContainer.Position = UDim2.new(0.5, 0, 0, 20)
            pickerContainer.Size = UDim2.new(1, -24, 0, math.max(1, panelHeight - 104))
            pickerContainer.CanvasSize = UDim2.fromOffset(0, contentHeight)
            pickerContainer.ScrollBarThickness = 3
            pickerContainer.ScrollingEnabled = true
            separatorContainer.Parent = nil
            rowLayout.Parent = nil
            mobileGrid.FillDirectionMaxCells = columns
            mobileGrid.CellSize = UDim2.fromOffset(slotWidth, slotHeight)
            mobileGrid.Parent = pickerContainer
            local cardWidth = math.max(1, slotWidth - 4)
            local iconSize = math.min(92, math.max(70, cardWidth - 34))
            for _, entry in ipairs(cards) do
                entry.slot.Size = UDim2.fromOffset(slotWidth, slotHeight)
                entry.card.Size = UDim2.fromOffset(cardWidth, 170)
                entry.icon.Size = UDim2.fromOffset(iconSize, iconSize)
                entry.icon.Position = UDim2.new(0.5, 0, 0, 12)
                entry.title.TextSize = 14
                entry.subtitle.TextSize = 12
                entry.continue.Position = UDim2.new(0.5, 0, 0, 178)
                entry.continue.Size = UDim2.fromOffset(math.min(120, cardWidth), 40)
            end
            modalDialog.Size = UDim2.fromOffset(math.min(420, math.max(1, panelWidth - 20)), 260)
            modalSubtitle.Size = UDim2.new(1, -40, 0, 32)
            modalSubtitle.TextWrapped = true
            toggleRow.Position = UDim2.new(0, 20, 0, 96)
            toggleRow.Size = UDim2.new(1, -40, 0, 74)
            toggleText.Position = UDim2.new(0, 14, 0, 8)
            toggleText.Size = UDim2.new(1, -80, 0, 34)
            toggleText.TextWrapped = true
            toggleHint.Position = UDim2.new(0, 14, 0, 42)
            toggleHint.Size = UDim2.new(1, -80, 0, 30)
            toggleHint.TextWrapped = true
            bottomBar.Size = UDim2.fromOffset(math.min(240, math.max(1, panelWidth - 12)), 44)
        else
            mobileGrid.Parent = nil
            rowLayout.Parent = pickerContainer
            separatorContainer.Parent = pickerContainer
            pickerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            pickerContainer.Position = UDim2.fromScale(0.5, 0.48)
            pickerContainer.Size = UDim2.new(1, -30, 0, 250)
            pickerContainer.CanvasSize = UDim2.fromOffset(0, 0)
            pickerContainer.ScrollBarThickness = 0
            pickerContainer.ScrollingEnabled = false
            window.Size = UDim2.fromOffset(840, 380)
            window.Position = UDim2.fromScale(0.5, 0.5)
            windowScale.Scale = math.min(1, (viewport.X - 24) / 840, (viewport.Y - 24) / 380)
            for _, entry in ipairs(cards) do
                entry.slot.Size = UDim2.fromOffset(176, 245)
                entry.card.Size = UDim2.fromOffset(170, 192)
                entry.icon.Size = UDim2.fromOffset(116, 116)
                entry.icon.Position = UDim2.new(0.5, 0, 0, 14)
                entry.title.TextSize = 16
                entry.subtitle.TextSize = 13
                entry.continue.Position = UDim2.new(0.5, 0, 0, 204)
                entry.continue.Size = UDim2.fromOffset(104, 30)
            end
            modalDialog.Size = UDim2.fromOffset(420, 230)
            modalSubtitle.Size = UDim2.new(1, -40, 0, 16)
            modalSubtitle.TextWrapped = false
            toggleRow.Position = UDim2.new(0, 20, 0, 78)
            toggleRow.Size = UDim2.new(1, -40, 0, 58)
            toggleText.Position = UDim2.new(0, 14, 0, 10)
            toggleText.Size = UDim2.new(1, -80, 0, 20)
            toggleText.TextWrapped = false
            toggleHint.Position = UDim2.new(0, 14, 0, 30)
            toggleHint.Size = UDim2.new(1, -80, 0, 16)
            toggleHint.TextWrapped = false
            bottomBar.Size = UDim2.fromOffset(240, 44)
        end
    end
    track(screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitWindow))
    fitWindow()

    screenGui.Destroying:Connect(function()
        alive = false
        dragging = false
        for _, connection in ipairs(connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(connections)
    end)

    local detectedExec = ""
    local dFn = (type(identifyexecutor) == "function" and identifyexecutor) or (type(getexecutorname) == "function" and getexecutorname) or (type(getgenv) == "function" and (getgenv().identifyexecutor or getgenv().getexecutorname))
    if type(dFn) == "function" then
        local ok, res = pcall(dFn)
        if ok and type(res) == "string" then
            detectedExec = res:lower()
        end
    end
    if detectedExec:find("xeno", 1, true) ~= nil or detectedExec:find("solara", 1, true) ~= nil then
        local overlay = Instance.new("Frame")
        overlay.Name = "UnsupportedOverlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.Position = UDim2.fromScale(0, 0)
        overlay.BackgroundTransparency = 1
        overlay.ZIndex = 50
        overlay.Active = false
        overlay.Parent = window

        local label = Instance.new("TextLabel")
        label.Name = "Text"
        label.Size = UDim2.new(1.2, 0, 0, 70)
        label.AnchorPoint = Vector2.new(0.5, 0.5)
        label.Position = UDim2.fromScale(0.5, 0.5)
        label.BackgroundTransparency = 1
        label.Text = "UNSUPPORTED EXECUTOR"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 38
        label.TextColor3 = Color3.fromRGB(255, 40, 40)
        label.TextTransparency = 0.2
        label.Rotation = -24
        label.ZIndex = 51
        label.TextStrokeTransparency = 0.4
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = overlay
    end

    refresh()
end
_G.LarpkuranShowPicker = function()
    if not recoveryFlowActive then showLarpkuranSelectionUI() end
end

local function autoExecuteProd()
    if recoveryFlowActive then return end
    if prodExecuted then return end
    if _G.LarpkuranForceLock == true then return end
    prodExecuted = true
    task.spawn(function()
        keyStatusMsg = "Authorized! Opening Larpkuran mode picker..."
        task.wait(0.2)
        local env = type(getgenv) == "function" and getgenv() or _G
        env.StacyKeyVerified = true
        if sessionToken then
            env.StacyKeyToken = sessionToken
            env.StacyCMDStartupToken = sessionToken
        end
        if cachedKey and #cachedKey > 0 then
            env.StacyKey = "SESSION_AUTHENTICATED"
            env.StacyCMDStartupKey = "SESSION_AUTHENTICATED"
            env.X8_KEY = nil
        elseif sessionToken then
            local fallbackKey = "ALPHA_DISCORD_" .. tostring(sessionToken):sub(1, 12)
            env.StacyKey = "SESSION_AUTHENTICATED"
            env.StacyCMDStartupKey = "SESSION_AUTHENTICATED"
            env.X8_KEY = nil
        end
        if _G.LarpkuranShellRereConn then
            pcall(_G.LarpkuranShellRereConn)
            _G.LarpkuranShellRereConn = nil
        end
        if oldInsert and Rere and Rere.Internal then
            Rere.Internal._Insert = oldInsert
        end
        showLarpkuranSelectionUI()
    end)
end

local function getCleanDeviceId()
    local device = nil
    if type(gethwid) == "function" then
        pcall(function() device = gethwid() end)
    end
    if type(device) == "string" then device = device:match("^%s*(.-)%s*$") end
    if type(device) ~= "string" or #device < 6 or device:lower() == "unknowndevice" then
        pcall(function() device = game:GetService("RbxAnalyticsService"):GetClientId() end)
    end
    if type(device) == "string" then
        device = device:match("^%s*(.-)%s*$")
    end
    return (device and #device >= 6 and device:lower() ~= "unknowndevice") and device or nil
end

local currentRobloxUserId = tostring(LocalPlayer and LocalPlayer.UserId or 0)
local accountSessionFile = "x8stuff_alpha_session_" .. currentRobloxUserId .. ".json"
local legacySessionFile = "x8stuff_alpha_session.json"
local signOutMarker = "x8stuff_explicit_signout_" .. currentRobloxUserId .. ".txt"
local function wasExplicitlySignedOut()
    local scope = type(getgenv) == "function" and getgenv() or _G
    if scope.LarpkuranExplicitlySignedOut == currentRobloxUserId then return true end
    if type(isfile) == "function" then
        local ok, exists = pcall(isfile, signOutMarker)
        if ok and exists then
            if type(readfile) == "function" then
                local readOk, contents = pcall(readfile, signOutMarker)
                if readOk and contents == "false" then return false end
            end
            return true
        end
    end
    return false
end
local function setExplicitSignOut()
    local scope = type(getgenv) == "function" and getgenv() or _G
    scope.LarpkuranExplicitlySignedOut = currentRobloxUserId
    _G.LarpkuranExplicitlySignedOut = currentRobloxUserId
    if type(writefile) == "function" then pcall(writefile, signOutMarker, "true") end
end
local function clearExplicitSignOut()
    local scope = type(getgenv) == "function" and getgenv() or _G
    if scope.LarpkuranExplicitlySignedOut == currentRobloxUserId then scope.LarpkuranExplicitlySignedOut = nil end
    if _G.LarpkuranExplicitlySignedOut == currentRobloxUserId then _G.LarpkuranExplicitlySignedOut = nil end
    if type(delfile) == "function" then pcall(delfile, signOutMarker) end
    if type(isfile) == "function" and type(writefile) == "function" then
        local ok, exists = pcall(isfile, signOutMarker)
        if ok and exists then pcall(writefile, signOutMarker, "false") end
    end
end

-- Legacy shared keys are never read by the entitlement wizard.

local function rememberRecoveryFailure(response)
    if not response then authRestoreErrorCode = "DISCORD_UNAVAILABLE"; return end
    local status = tonumber(response.StatusCode or response.Status or response.status_code)
    local body = response.Body or response.body
    local ok, parsed = pcall(HttpService.JSONDecode, HttpService, body or "")
    local code = ok and type(parsed) == "table" and parsed.code or nil
    if type(code) == "string" then
        authRestoreErrorCode = code
    elseif status == 404 then
        authRestoreErrorCode = "NOT_REGISTERED"
    elseif status == 403 then
        authRestoreErrorCode = "GUILD_MEMBERSHIP_REQUIRED"
    else
        authRestoreErrorCode = "DISCORD_UNAVAILABLE"
    end
end

local accountSessionMemory = type(getgenv)=="function" and getgenv() or _G
accountSessionMemory.LarpSavedSessions = accountSessionMemory.LarpSavedSessions or {}

-- Display-only identity survives key expiry. It is NEVER an authorization credential.
local rememberedProfile = {file = "x8stuff_profile_" .. currentRobloxUserId .. ".json"}
accountSessionMemory.LarpSavedProfiles = accountSessionMemory.LarpSavedProfiles or {}
function rememberedProfile.remember(account)
    if type(account) ~= "table" or tostring(account.robloxUserId) ~= currentRobloxUserId then return false end
    local profile = {robloxUserId = currentRobloxUserId, discordUsername = account.discordUsername,
        discordId = account.discordId, slotRole = account.slotRole, expiresAt = account.expiresAt,
        plan = account.plan, displayOnly = true}
    accountSessionMemory.LarpSavedProfiles[currentRobloxUserId] = profile
    if type(writefile) == "function" then
        pcall(function() writefile(rememberedProfile.file, HttpService:JSONEncode(profile)) end)
    end
    return true
end
function rememberedProfile.load()
    if wasExplicitlySignedOut() then return end
    local profile = accountSessionMemory.LarpSavedProfiles[currentRobloxUserId]
    if type(readfile) == "function" then
        local ok, value = pcall(function() return HttpService:JSONDecode(readfile(rememberedProfile.file)) end)
        if ok and type(value) == "table" then profile = value end
    end
    if type(profile) == "table" and tostring(profile.robloxUserId) == currentRobloxUserId then
        cachedAccount = profile
        syncAccountRole(profile)
    end
end
function rememberedProfile.clear()
    accountSessionMemory.LarpSavedProfiles[currentRobloxUserId] = nil
    if type(delfile) == "function" then pcall(delfile, rememberedProfile.file) end
    -- Tombstone prevents stale identity returning if the executor cannot delete files.
    if type(writefile) == "function" then pcall(writefile, rememberedProfile.file, "{}") end
end

local function readCurrentAccountSession(path)
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return nil end
    local existsOk, exists = pcall(isfile, path)
    if not existsOk or not exists then return nil end
    local readOk, raw = pcall(readfile, path)
    if not readOk or type(raw) ~= "string" then return nil end
    local parseOk, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not parseOk or type(data) ~= "table" or type(data.account) ~= "table"
        or tostring(data.account.robloxUserId) ~= currentRobloxUserId
        or type(data.sessionToken) ~= "string" or data.sessionToken == "" then
        return nil
    end
    return data
end

local function retireCurrentLegacySession()
    if not readCurrentAccountSession(legacySessionFile) or type(delfile) ~= "function" then return end
    pcall(delfile, legacySessionFile)
end

local function saveCurrentAccountSession(token, authType, account, device)
    rememberedProfile.remember(account)
    local data={sessionToken=token,authType=authType,authMode=sessionAuthMode,account=account,deviceId=device}
    accountSessionMemory.LarpSavedSessions[currentRobloxUserId]=data
    if type(writefile) ~= "function" then
        keyStatusMsg="Signed in, but this executor cannot save your login between Roblox sessions."
        return false
    end
    local ok=pcall(writefile,accountSessionFile,HttpService:JSONEncode(data))
    if ok and type(readfile)=="function" then
        local persisted=readCurrentAccountSession(accountSessionFile)
        ok=persisted~=nil and persisted.sessionToken==token
    end
    if ok then retireCurrentLegacySession() end
    if not ok then keyStatusMsg="Signed in, but this executor could not save your login. Rejoining may require Discord login again." end
    return ok
end

local function deleteCurrentAccountSession()
    accountSessionMemory.LarpSavedSessions[currentRobloxUserId]=nil
    rememberedProfile.clear()
    if type(delfile) ~= "function" then return false end
    pcall(delfile, accountSessionFile)
    retireCurrentLegacySession()
    if type(isfile) == "function" then
        local ok, exists = pcall(isfile, accountSessionFile)
        if not ok or exists then return false end
        local legacyOk, legacyExists = pcall(isfile, legacySessionFile)
        if legacyOk and legacyExists and readCurrentAccountSession(legacySessionFile) then return false end
    end
    return true
end

local function checkSavedSession()
    authRestoreErrorCode = nil
    isUnlocked, sessionToken = false, nil
    for _, scope in ipairs({accountSessionMemory, _G}) do
        scope.StacyKeyVerified, scope.StacyCMDStartupKeyVerified = false, false
        scope.StacyKeyToken, scope.StacyCMDStartupToken = nil, nil
    end
    rememberedProfile.load()
    if type(req) ~= "function" then authRestoreErrorCode = "DISCORD_UNAVAILABLE"; return false end
    local device = getCleanDeviceId()
    -- A Discord session is independent of the current device.
    -- Never send another Roblox account's saved token to validate-session.
    local data = readCurrentAccountSession(accountSessionFile)
    local savedPath = data and accountSessionFile or nil
    if not data then
        data = readCurrentAccountSession(legacySessionFile)
        savedPath = data and legacySessionFile or nil
    end
    if not data then data=accountSessionMemory.LarpSavedSessions[currentRobloxUserId] end
    if data and (type(data.account)~="table" or tostring(data.account.robloxUserId)~=currentRobloxUserId) then data=nil end
    if data then
        -- Migrate the previous saved login's profile before retiring its expired token.
        rememberedProfile.remember(data.account)
        cachedAccount = data.account
        syncAccountRole(cachedAccount)
        if not device and data.authMode ~= "DISCORD_NO_HWID" and data.authMode ~= "REVIEWER" then
            authRestoreErrorCode = "DEVICE_ID_UNAVAILABLE"
            return false
        end
        if data.authMode == "DISCORD_NO_HWID" or data.authMode == "REVIEWER" then device = nil end
        local response
        local requestOk = pcall(function()
            response = req({
                Url = "https://api.x8stuff.lol/v1/alpha/auth/validate-session",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    sessionToken = data.sessionToken,
                    robloxUserId = currentRobloxUserId,
                    deviceId = device
                })
            })
        end)
        if not requestOk or not response then
            authRestoreErrorCode = "DISCORD_UNAVAILABLE"
            return false
        end
        local status = tonumber(response.StatusCode or response.Status or response.status_code)
        local responseBody = response.Body or response.body
        if status == 200 and type(responseBody) == "string" then
            local parseOk, result = pcall(HttpService.JSONDecode, HttpService, responseBody)
            if parseOk and type(result) == "table" and result.ok == true and result.status == "ACTIVE"
                and type(result.account) == "table" and tostring(result.account.robloxUserId) == currentRobloxUserId then
                clearExplicitSignOut()
                authRestoreErrorCode = nil
                isUnlocked = true
                sessionToken = data.sessionToken
                cachedAccount = result.account
                rememberedProfile.remember(cachedAccount)
                syncAccountRole(cachedAccount)
                sessionAuthMode = result.authMode or result.account.authMode or data.authMode
                keyStatusMsg = "Session restored (" .. tostring(cachedAccount.discordUsername or "Authorized") .. ")."
                local env = type(getgenv) == "function" and getgenv() or _G
                env.StacyKeyVerified = true
                env.StacyKeyToken = data.sessionToken
                if savedPath == legacySessionFile or not savedPath then
                    saveCurrentAccountSession(data.sessionToken, data.authType or "DISCORD", result.account, device)
                end
                return true
            end
        end
        rememberRecoveryFailure(response)
        if not status or status == 200 or status == 429 or status >= 500 then return false end
        if status ~= 401 and status ~= 403 and status ~= 404 and status ~= 409 then return false end
        local permanent=authRestoreErrorCode=="INVALID_SESSION" or authRestoreErrorCode=="SESSION_REVOKED"
            or authRestoreErrorCode=="ENTITLEMENT_REVOKED" or authRestoreErrorCode=="BINDING_MISMATCH"
        if permanent then
            accountSessionMemory.LarpSavedSessions[currentRobloxUserId]=nil
            if savedPath and type(delfile)=="function" then pcall(delfile,savedPath) end
        end
        if status ~= 401 then return false end
    end

    -- An absent or foreign legacy file must not block this account's own restore.
    if currentRobloxUserId ~= "0" and device then
        local response
        local requestOk = pcall(function()
            response = req({
                Url = "https://api.x8stuff.lol/v1/alpha/auth/restore-roblox",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    robloxUserId = currentRobloxUserId,
                    robloxUsername = LocalPlayer and tostring(LocalPlayer.Name) or "Unknown",
                    deviceId = device
                })
            })
        end)
        if requestOk and response then
            local status = tonumber(response.StatusCode or response.Status or response.status_code)
            local responseBody = response.Body or response.body
            if status == 200 and type(responseBody) == "string" then
                local parseOk, result = pcall(HttpService.JSONDecode, HttpService, responseBody)
                if parseOk and type(result) == "table" and result.ok == true and result.status == "ACTIVE"
                    and type(result.sessionToken) == "string" and type(result.account) == "table"
                    and tostring(result.account.robloxUserId) == currentRobloxUserId then
                    clearExplicitSignOut()
                    authRestoreErrorCode = nil
                    isUnlocked = true
                    sessionToken = result.sessionToken
                    cachedAccount = result.account
                    syncAccountRole(cachedAccount)
                    sessionAuthMode = result.authMode or result.account.authMode or "DAILY_KEY"
                    keyStatusMsg = "Discord verified! Welcome, " .. tostring(result.account.discordUsername or "Member") .. "."
                    local env = type(getgenv) == "function" and getgenv() or _G
                    env.StacyKeyVerified = true
                    env.StacyKeyToken = result.sessionToken
                    saveCurrentAccountSession(result.sessionToken, "KEY", result.account, device)
                    return true
                end
            end
        end
        rememberRecoveryFailure(requestOk and response or nil)
    end
    return false
end

local function activateKey(keyToTry)
    if not keyToTry or #keyToTry < 3 then
        keyFeedbackMsg = "❌ [KEY_TOO_SHORT] Please enter a valid license key."
        keyFeedbackColor = Color3.fromRGB(255, 90, 90)
        keyStatusMsg = "Please enter a valid license key."
        return false
    end
    if type(req) ~= "function" then
        keyFeedbackMsg = "❌ [NO_HTTP_SUPPORT] HTTP request function not supported."
        keyFeedbackColor = Color3.fromRGB(255, 90, 90)
        keyStatusMsg = "HTTP request function not supported by executor."
        return false
    end
    -- Mobile clipboard wrapping may insert whitespace inside a replacement key.
    local compactKey = keyToTry:gsub("%s", ""):gsub("\226\128[\139-\143]", ""):gsub("\239\187\191", "")
    if compactKey:match("^x8new%-%x+$") and #compactKey == 54 then keyToTry = compactKey end
    local reviewerKey = compactKey:match("^x8review%-%x+$") ~= nil and #compactKey == 73
    if reviewerKey then keyToTry = compactKey end
    keyFeedbackMsg = "⏳ Validating license key with server..."
    keyFeedbackColor = Color3.fromRGB(255, 210, 100)
    local device = getCleanDeviceId()
    if not device and not reviewerKey then
        keyStatusMsg = "A device ID is required for key login. Use Discord login without HWID."
        keyFeedbackMsg = keyStatusMsg
        return false
    end
    local response
    local ok = pcall(function()
        response = req({
            Url = "https://api.x8stuff.lol/v1/alpha/auth/activate-key",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                key = keyToTry,
                deviceId = device,
                gameId = tostring(game.PlaceId),
                robloxUserId = LocalPlayer and tostring(LocalPlayer.UserId) or "0",
                robloxUsername = LocalPlayer and tostring(LocalPlayer.Name) or "Unknown",
                slotRole = activateAsStand and "STAND" or "MAIN",
            })
        })
    end)
    if not ok or not response then
        keyFeedbackMsg = "❌ [NETWORK_ERROR] Network error connecting to server."
        keyFeedbackColor = Color3.fromRGB(255, 90, 90)
        keyStatusMsg = "Network error connecting to activation server."
        return false
    end
    local statusCode = tonumber(response.StatusCode or response.Status or response.status_code)
    local bodyStr = response.Body or response.body
    if statusCode == 200 and type(bodyStr) == "string" then
        local parseOk, res = pcall(function() return HttpService:JSONDecode(bodyStr) end)
        if parseOk and type(res) == "table" and res.ok == true and (res.status == "ACTIVE" or res.status == "REBOUND") and type(res.sessionToken) == "string" and type(res.account) == "table" and tostring(res.account.robloxUserId) == tostring(LocalPlayer.UserId) then
            clearExplicitSignOut()
            authRestoreErrorCode = nil
            isUnlocked = true
            cachedKey = ""
            sessionToken = res.sessionToken
            cachedAccount = res.account
            syncAccountRole(cachedAccount)
            sessionAuthMode = res.authMode or res.account.authMode or "DAILY_KEY"
            keyFeedbackMsg = "✅ [SUCCESS] Daily key verified. Access lasts until this key expires."
            keyFeedbackColor = Color3.fromRGB(100, 255, 140)
            keyStatusMsg = res.status == "REBOUND" and "Device reset complete. Welcome back." or "Daily key verified. Access lasts until this key expires."
            if sessionAuthMode == "REVIEWER" then
                keyFeedbackMsg = "Reviewer key verified. LarpKuran access granted."
                keyStatusMsg = keyFeedbackMsg
                device = nil
            end
            local env = type(getgenv) == "function" and getgenv() or _G
            env.StacyKey = "SESSION_AUTHENTICATED"
            env.StacyKeyVerified = true
            env.StacyKeyToken = res.sessionToken
            saveCurrentAccountSession(res.sessionToken, "KEY", res.account, device)
            task.spawn(autoExecuteProd)
            return true
        else
            local code = (type(res) == "table" and res.code) or "REJECTED"
            local msg = (type(res) == "table" and res.message) or "Activation rejected by server."
            if code == "DISCORD_VERIFICATION_REQUIRED" and type(res.verificationCode) == "string" then
                local command = "/verify-newkey code:" .. res.verificationCode
                local copy = type(setclipboard) == "function" and setclipboard
                    or (type(toclipboard) == "function" and toclipboard)
                    or (type(syn) == "table" and type(syn.write_clipboard) == "function" and syn.write_clipboard)
                local copied = copy and pcall(copy, command)
                keyFeedbackMsg = "Discord verification required. " .. command
                keyFeedbackColor = Color3.fromRGB(100, 180, 255)
                keyStatusMsg = copied and "Command copied. Run it in Discord, then press Next here."
                    or "Copy the command below to Discord, then press Next here."
                return false, code, command
            end
            keyFeedbackMsg = "❌ [" .. tostring(code) .. "] " .. tostring(msg)
            keyFeedbackColor = Color3.fromRGB(255, 90, 90)
            if code == "BINDING_LOCKED" then
                keyStatusMsg = tostring(msg)
            elseif code == "KEY_ACCOUNT_MISMATCH" then
                keyStatusMsg = tostring(msg)
            else
                keyStatusMsg = keyFeedbackMsg
            end
            return false
        end
    else
        local parseOk, res = pcall(function() return HttpService:JSONDecode(bodyStr) end)
        local code = (parseOk and type(res) == "table" and res.code) or ("HTTP_" .. tostring(statusCode))
        local msg = (parseOk and type(res) == "table" and res.message) or "Activation failed"
        keyFeedbackMsg = "❌ [" .. tostring(code) .. "] " .. tostring(msg)
        keyFeedbackColor = Color3.fromRGB(255, 90, 90)
        if code == "BINDING_LOCKED" then
            keyStatusMsg = tostring(msg)
        elseif code == "KEY_ACCOUNT_MISMATCH" then
            keyStatusMsg = tostring(msg)
        else
            keyStatusMsg = keyFeedbackMsg
        end
        return false
    end
end

local function requestDiscordLogin()
    if type(req) ~= "function" then
        keyStatusMsg = "HTTP request function not supported by executor."
        return false
    end
    local res
    local ok = pcall(function()
        res = req({
            Url = "https://api.x8stuff.lol/v1/alpha/auth/request-login",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                robloxUserId = LocalPlayer and tostring(LocalPlayer.UserId) or "0",
                robloxUsername = LocalPlayer and tostring(LocalPlayer.Name) or "Unknown",
                placeId = tostring(game.PlaceId),
                product = "larpkuran",
                slotRole = activateAsStand and "STAND" or "MAIN"
            })
        })
    end)
    if not ok or not res then
        keyStatusMsg = "Network error requesting Discord login."
        return false
    end
    local sCode = tonumber(res.StatusCode or res.Status or res.status_code)
    local bStr = res.Body or res.body
    if (sCode == 200 or sCode == 201) and type(bStr) == "string" then
        local parseOk, resObj = pcall(function() return HttpService:JSONDecode(bStr) end)
        if parseOk and type(resObj) == "table" and resObj.ok == true then
            activeRequestId = resObj.requestId
            activeClaimSecret = resObj.claimSecret
            stagedAuthLink = resObj.loginUrl
            discordPending = true
            discordExpiryTime = os.clock() + (tonumber(resObj.expiresInSeconds) or 300)
            local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
            local copied = type(setclip) == "function" and pcall(setclip, stagedAuthLink)
            lastPollTick = 0
            keyStatusMsg = copied and "Login link copied. Paste it into your browser and authorize Discord."
                or "Copy the login link below into your browser and authorize Discord."
            return true
        end
    end
    local parsed, failure = pcall(HttpService.JSONDecode, HttpService, bStr or "")
    keyStatusMsg = parsed and type(failure) == "table" and tostring(failure.message or failure.code or "Discord login is unavailable.")
        or "Failed to initiate Discord login with server."
    return false
end

local function pollDiscordLogin()
    if not discordPending or not activeRequestId or not activeClaimSecret then return end
    if os.clock() - lastPollTick < 2.5 then return end
    lastPollTick = os.clock()
    if os.clock() > discordExpiryTime then
        discordPending = false
        activeRequestId = nil
        activeClaimSecret = nil
        keyStatusMsg = "Discord authorization timed out. Please click login again."
        return
    end
    local pollingRequestId = activeRequestId
    local res
    local ok = pcall(function()
        res = req({
            Url = "https://api.x8stuff.lol/v1/alpha/auth/poll-login",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                requestId = activeRequestId,
                claimSecret = activeClaimSecret,
                robloxUserId = currentRobloxUserId
            })
        })
    end)
    if not discordPending or activeRequestId ~= pollingRequestId then return end
    if not ok or not res then return end
    local sCode = tonumber(res.StatusCode or res.Status or res.status_code)
    local bStr = res.Body or res.body
    if sCode == 200 and type(bStr) == "string" then
        local parseOk, resObj = pcall(function() return HttpService:JSONDecode(bStr) end)
        if parseOk and type(resObj) == "table" then
            if resObj.status == "ACTIVE" and type(resObj.sessionToken) == "string"
                and type(resObj.account) == "table"
                and tostring(resObj.account.robloxUserId) == currentRobloxUserId then
                discordPending = false
                clearExplicitSignOut()
                authRestoreErrorCode = nil
                sessionAuthMode = "DISCORD_NO_HWID"
                isUnlocked = true
                sessionToken = resObj.sessionToken
                cachedAccount = resObj.account
                syncAccountRole(cachedAccount)
                activeRequestId = nil
                activeClaimSecret = nil
                local uname = (resObj.account and resObj.account.discordUsername) or "Member"
                keyStatusMsg = "Discord verified! Welcome, " .. tostring(uname) .. "."
                local env = type(getgenv) == "function" and getgenv() or _G
                env.StacyKeyVerified = true
                env.StacyKeyToken = resObj.sessionToken
                saveCurrentAccountSession(resObj.sessionToken, "DISCORD", resObj.account, nil)
                task.spawn(autoExecuteProd)
            end
        end
    elseif sCode == 403 or sCode == 400 or sCode == 404 or sCode == 409 then
        local parseOk, resObj = pcall(function() return HttpService:JSONDecode(bStr) end)
        local msg = (parseOk and type(resObj) == "table" and resObj.message) or ("HTTP " .. tostring(sCode))
        discordPending = false
        activeRequestId = nil
        activeClaimSecret = nil
        keyStatusMsg = "Login failed: " .. tostring(msg)
    end
end

local function logoutSession(unregister)
    if type(sessionToken) ~= "string" or sessionToken == "" or type(req) ~= "function" then
        return false, "Could not contact the sign-out service. Please try again."
    end
    local device = sessionAuthMode ~= "DISCORD_NO_HWID" and sessionAuthMode ~= "REVIEWER" and getCleanDeviceId() or nil
    if not device and sessionAuthMode ~= "DISCORD_NO_HWID" and sessionAuthMode ~= "REVIEWER" then
        return false, "This executor cannot provide a device ID. Sign-out was not submitted."
    end
    local requestOk, response = pcall(req, {
        Url = "https://api.x8stuff.lol/v1/alpha/auth/" .. (unregister and "unregister" or "logout"),
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({
            sessionToken = sessionToken,
            deviceId = device,
            robloxUserId = currentRobloxUserId
        })
    })
    local status = requestOk and response and tonumber(response.StatusCode or response.Status or response.status_code)
    local body = response and (response.Body or response.body) or ""
    local parseOk, result = pcall(HttpService.JSONDecode, HttpService, body)
    if status ~= 200 or not parseOk or type(result) ~= "table"
        or result.ok ~= true or result.status ~= (unregister and "UNREGISTERED" or "SIGNED_OUT") then
        return false, (parseOk and type(result) == "table" and result.message) or "Could not confirm account action. Check your connection and try again."
    end
    local signedOutToken = sessionToken
    sessionToken = nil
    cachedAccount = nil
    sessionAuthMode = nil
    cachedKey = ""
    isUnlocked = false
    discordPending = false
    activeRequestId = nil
    activeClaimSecret = nil
    for _, scope in ipairs({type(getgenv) == "function" and getgenv() or _G, _G}) do
        scope.StacyKeyVerified = false
        if scope.StacyKeyToken == signedOutToken then scope.StacyKeyToken = nil end
        if scope.StacyKey == "SESSION_AUTHENTICATED" then scope.StacyKey = nil end
        if scope.StacyCMDStartupToken == signedOutToken then scope.StacyCMDStartupToken = nil end
        if scope.StacyCMDStartupKey == "SESSION_AUTHENTICATED" then scope.StacyCMDStartupKey = nil end
        scope.StacyCMDStartupKeyVerified = false
    end
    local fileWarning = not deleteCurrentAccountSession()
    setExplicitSignOut()
    keyFeedbackMsg = "🔒 Signed out."
    keyFeedbackColor = Color3.fromRGB(140, 180, 255)
    keyStatusMsg = fileWarning and "Signed out on the server, but the local file could not be removed."
        or (unregister and "Account unregistered. Bans and cooldowns remain. Register again to continue." or "Signed out. Sign in with Discord or claim a daily key.")
    return true, fileWarning and keyStatusMsg or nil
end

local function isAutoLoginDisabled()
    if type(isfile) == "function" and isfile("x8stuff_disable_autologin.txt") then
        if type(readfile)=="function" then
            local ok,value=pcall(readfile,"x8stuff_disable_autologin.txt")
            if ok and value=="false" then return false end
        end
        return true
    end
    return false
end

-- Restore only server-authorized sessions; expired daily keys require a new claim.
if not forceKeyLogin and not isAutoLoginDisabled() and not wasExplicitlySignedOut() then
    checkSavedSession()
else
    rememberedProfile.load()
    keyStatusMsg = "Auto-login skipped via Settings. Enter key or sign in."
end

local function showRecoveryFlowUI()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local inviteUrl = "https://discord.gg/tKzhr5FecY"

local env = _G
if type(getgenv) == "function" then
    local ok, value = pcall(getgenv)
    if ok and type(value) == "table" then env = value end
end
local cleanupKey = "__LarpkuranKeySystemCleanup"
if type(env[cleanupKey]) == "function" then pcall(env[cleanupKey]) end

local assetBase = "https://raw.githubusercontent.com/x8lua/Staconf/main/assets/larpkuran-key-ui/v1/"
local assetFolder = "Staconf/assets/larpkuran-key-ui/v1/"
local function localAsset(path)
    local names = {
        ["larpkuran-key-default-pfp.png"] = "default-pfp.png",
        ["larpkuran-disk.png"] = "disk-production.png",
        ["larpkuran-beta-disk.png"] = "disk-beta.png",
        ["larpkuran-tutorial-v2/assets/nav-previous.png"] = "nav-previous.png",
        ["larpkuran-tutorial-v2/assets/nav-next.png"] = "nav-next.png",
    }
    local relative = names[path] or path:match("^larpkuran%-tutorial%-v2/cropped%-final/(step%-%d%d%.png)$")
    if relative and relative:match("^step%-%d%d%.png$") then relative = "tutorial/" .. relative end
    if not relative then return nil end
    local target = assetFolder .. relative
    local assetLoader = type(getcustomasset) == "function" and getcustomasset
        or (type(getsynasset) == "function" and getsynasset)
    if not assetLoader or type(isfile) ~= "function" then return nil end
    local existsOk, exists = pcall(isfile, target)
    if (not existsOk or not exists) and type(writefile) == "function" then
        local body
        if type(req) == "function" then
            local ok, response = pcall(req, {Url = assetBase .. relative, Method = "GET"})
            if ok and response and tonumber(response.StatusCode or response.Status or response.status_code) == 200 then
                body = response.Body or response.body
            end
        end
        if not body then
            local ok, result = pcall(game.HttpGet, game, assetBase .. relative)
            if ok then body = result end
        end
        if type(body) == "string" and #body > 100 and #body < 4 * 1024 * 1024
            and body:sub(1, 8) == "\137PNG\r\n\26\n" then
            pcall(function()
                if type(makefolder) == "function" then
                    for _, folder in ipairs({"Staconf", "Staconf/assets", "Staconf/assets/larpkuran-key-ui", assetFolder:sub(1, -2)}) do
                        if type(isfolder) ~= "function" or not isfolder(folder) then makefolder(folder) end
                    end
                    if relative:match("^tutorial/") and (type(isfolder) ~= "function" or not isfolder(assetFolder .. "tutorial")) then
                        makefolder(assetFolder .. "tutorial")
                    end
                end
                writefile(target, body)
            end)
        end
    end
    local ok, asset = pcall(assetLoader, target)
    return ok and type(asset) == "string" and asset ~= "" and asset or nil
end
local defaultPfpAsset = localAsset("larpkuran-key-default-pfp.png")
local diskAsset = localAsset("larpkuran-disk.png") or "rbxassetid://16898670469"
local betaDiskAsset = localAsset("larpkuran-beta-disk.png") or "rbxassetid://16898670469"

local function inter(weight)
    local ok, face = pcall(Font.new, "rbxassetid://12187365364", weight or Enum.FontWeight.Regular)
    return ok and face or Font.fromEnum(Enum.Font.Gotham)
end

local C = {
    panel = Color3.fromRGB(27, 27, 29),
    panelStroke = Color3.fromRGB(85, 85, 90),
    card = Color3.fromRGB(37, 38, 42),
    cardStroke = Color3.fromRGB(75, 77, 84),
    white = Color3.fromRGB(239, 240, 243),
    muted = Color3.fromRGB(154, 156, 164),
    dim = Color3.fromRGB(108, 110, 118),
    blue = Color3.fromRGB(16, 131, 255),
    blueHover = Color3.fromRGB(54, 150, 255),
    input = Color3.fromRGB(19, 20, 24),
}

local function new(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props) do object[key] = value end
    object.Parent = parent
    return object
end

local function rounded(object, radius, strokeColor, strokeTransparency)
    new("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
    if strokeColor then
        new("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = strokeColor,
            Transparency = strokeTransparency or 0,
            Thickness = 1,
        }, object)
    end
end

local function label(name, text, size, color, weight, parent)
    return new("TextLabel", {
        Name = name,
        Text = text,
        BackgroundTransparency = 1,
        TextColor3 = color or C.white,
        TextSize = size,
        FontFace = inter(weight),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        BorderSizePixel = 0,
    }, parent)
end

local gui = new("ScreenGui", {
    Name = "LarpkuranKeySystemUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)
-- Position the picker in the actual viewport. The safe area is handled by fit().
pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)

local parentGui
if type(gethui) == "function" then
    local ok, result = pcall(gethui)
    if ok and typeof(result) == "Instance" then parentGui = result end
end
parentGui = parentGui or player:WaitForChild("PlayerGui")
gui.Parent = parentGui

env[cleanupKey] = function()
    discordPending = false
    activeRequestId, activeClaimSecret = nil, nil
    if gui and gui.Parent then gui:Destroy() end
    env[cleanupKey] = nil
end

local panel = new("Frame", {
    Name = "RecoveryPanel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(760, 520),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
rounded(panel, 25, C.panelStroke, 0.12)


local close = new("TextButton", {
    Name = "Close",
    Text = "×",
    Position = UDim2.fromOffset(9, 7),
    Size = UDim2.fromOffset(44, 44),
    BackgroundTransparency = 1,
    TextColor3 = C.dim,
    TextSize = 25,
    FontFace = inter(Enum.FontWeight.Regular),
    AutoButtonColor = false,
}, panel)
close.Activated:Connect(function() env[cleanupKey]() end)

local title = label("Title", "LarpKuran", 36, Color3.fromRGB(128, 129, 135), Enum.FontWeight.Light, panel)
title.AnchorPoint = Vector2.new(0.5, 0)
title.Position = UDim2.new(0.5, 0, 0, 25)
title.Size = UDim2.new(1, -48, 0, 48)

local headerHint = label("HeaderHint", "Select a user you'd like to load with.", 15, C.white, Enum.FontWeight.Medium, panel)
headerHint.AnchorPoint = Vector2.new(0.5, 0)
headerHint.Position = UDim2.new(0.5, 0, 0, 77)
headerHint.Size = UDim2.new(1, -48, 0, 28)

local divider = new("Frame", {
    Name = "FooterDivider",
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 1, -78),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Color3.fromRGB(61, 62, 67),
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
}, panel)

local footer = new("Frame", {
    Name = "Footer",
    Position = UDim2.new(0, 0, 1, -77),
    Size = UDim2.new(1, 0, 0, 77),
    BackgroundTransparency = 1,
}, panel)

local function navButton(name, caption, direction, assetPath)
    local button = new("TextButton", {
        Name = name,
        Text = "",
        AnchorPoint = direction == "left" and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
        Position = UDim2.new(0.5, direction == "left" and -18 or 18, 0.5, 0),
        Size = UDim2.fromOffset(86, 68),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Visible = true,
    }, footer)
    local asset = localAsset(assetPath)
    local icon = new("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 2),
        Size = UDim2.fromOffset(38, 38),
        BackgroundTransparency = 1,
        Image = asset or "",
        ScaleType = Enum.ScaleType.Fit,
        Visible = asset ~= nil,
    }, button)
    local fallback = label("Fallback", direction == "left" and "←" or "→", 27, C.muted, Enum.FontWeight.Light, button)
    fallback.AnchorPoint = Vector2.new(0.5, 0)
    fallback.Position = UDim2.new(0.5, 0, 0, 2)
    fallback.Size = UDim2.fromOffset(38, 38)
    fallback.Visible = asset == nil
    if not asset then rounded(fallback, 19, C.muted, 0) end
    local textLabel = label("Caption", caption, 13, C.muted, Enum.FontWeight.Medium, button)
    textLabel.Position = UDim2.new(0, 0, 0, 43)
    textLabel.Size = UDim2.new(1, 0, 0, 19)
    button.MouseEnter:Connect(function()
        if icon.Visible then TweenService:Create(icon, TweenInfo.new(0.16), { ImageColor3 = C.white }):Play() end
        TweenService:Create(textLabel, TweenInfo.new(0.16), { TextColor3 = C.white }):Play()
    end)
    button.MouseLeave:Connect(function()
        if icon.Visible then TweenService:Create(icon, TweenInfo.new(0.16), { ImageColor3 = Color3.new(1, 1, 1) }):Play() end
        TweenService:Create(textLabel, TweenInfo.new(0.16), { TextColor3 = C.muted }):Play()
    end)
    return button, textLabel
end

local navBack, navBackCaption = navButton("Previous", "Close", "left", "larpkuran-tutorial-v2/assets/nav-previous.png")
local navNext, navNextCaption = navButton("Next", "Next", "right", "larpkuran-tutorial-v2/assets/nav-next.png")
local tutorialExit = new("TextButton", {
    Name = "ExitTutorial",
    Text = "Exit Tutorial",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 20, 0.5, 0),
    Size = UDim2.fromOffset(110, 44),
    BackgroundColor3 = Color3.fromRGB(52, 54, 61),
    BorderSizePixel = 0,
    TextColor3 = C.white,
    TextSize = 14,
    FontFace = inter(Enum.FontWeight.Medium),
    AutoButtonColor = false,
    Visible = false,
}, footer)
rounded(tutorialExit, 9, C.cardStroke, 0.4)
tutorialExit.MouseEnter:Connect(function()
    TweenService:Create(tutorialExit, TweenInfo.new(0.16), { BackgroundColor3 = Color3.fromRGB(65, 67, 75) }):Play()
end)
tutorialExit.MouseLeave:Connect(function()
    TweenService:Create(tutorialExit, TweenInfo.new(0.16), { BackgroundColor3 = Color3.fromRGB(52, 54, 61) }):Play()
end)

local contentHost = new("Frame", {
    Name = "ContentHost",
    Position = UDim2.fromOffset(0, 111),
    Size = UDim2.new(1, 0, 1, -189),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, panel)

local function stage(name)
    local page = new("Frame", {
        Name = name,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 0, 0, 331),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
    }, contentHost)
    new("UIScale", { Name = "FitScale", Scale = 1 }, page)
    return page
end

local selectPage = stage("SelectUser")
local keyPage = stage("EnterKey")
local welcomePage = stage("Welcome")
local pickerPage = stage("ChooseVersion")
local tutorialPage = stage("Tutorial")
local loginPage = stage("LoginMethod")
local discordPage = stage("DiscordLogin")

local registered = isUnlocked and sessionToken ~= nil
local activating = false
local launching = false
local signingOut = false
local signOutError = nil
local selectedVersion = nil
local step = 1
local avatarUrl = nil

local function avatar(name, diameter, parent)
    local ring = new("Frame", {
        Name = name,
        Size = UDim2.fromOffset(diameter, diameter),
        BackgroundColor3 = Color3.fromRGB(189, 189, 189),
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, parent)
    rounded(ring, diameter)
    local head = new("Frame", {
        Name = "DefaultHead",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.18, 0),
        Size = UDim2.fromOffset(math.floor(diameter * 0.33), math.floor(diameter * 0.33)),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250),
        BorderSizePixel = 0,
    }, ring)
    rounded(head, diameter)
    local shoulders = new("Frame", {
        Name = "DefaultShoulders",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.59, 0),
        Size = UDim2.fromOffset(math.floor(diameter * 0.82), math.floor(diameter * 0.7)),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250),
        BorderSizePixel = 0,
    }, ring)
    rounded(shoulders, diameter)
    head.Visible = defaultPfpAsset == nil
    shoulders.Visible = defaultPfpAsset == nil
    if defaultPfpAsset then
        local defaultPicture = new("ImageLabel", {
            Name = "DefaultUserImage",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = defaultPfpAsset,
            ScaleType = Enum.ScaleType.Crop,
        }, ring)
        rounded(defaultPicture, diameter)
    end
    local picture = new("ImageLabel", {
        Name = "RobloxAvatar",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Crop,
        Visible = false,
    }, ring)
    rounded(picture, diameter)
    return ring, picture
end

local function applyAvatar(image, knownAccount)
    image.Visible = knownAccount and type(avatarUrl) == "string" and avatarUrl ~= ""
    if image.Visible then image.Image = avatarUrl end
end

-- Select user: one profile for the current Roblox player.
local selectPrompt = label("Prompt", "Select a user you'd like to load with:", 16, C.white, Enum.FontWeight.Medium, selectPage)
selectPrompt.Position = UDim2.new(0, 18, 0, 15)
selectPrompt.Size = UDim2.new(1, -36, 0, 32)
local userChoice = new("TextButton", {
    Name = "CurrentUser",
    Text = "",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 71),
    Size = UDim2.fromOffset(220, 191),
    BackgroundTransparency = 1,
    AutoButtonColor = false,
}, selectPage)
local selectAvatar, selectImage = avatar("SelectAvatar", 108, userChoice)
selectAvatar.AnchorPoint = Vector2.new(0.5, 0)
selectAvatar.Position = UDim2.new(0.5, 0, 0, 0)
local selectName = label("UserName", "New User", 17, C.white, Enum.FontWeight.Medium, userChoice)
selectName.Position = UDim2.new(0, 0, 0, 119)
selectName.Size = UDim2.new(1, 0, 0, 26)
local selectSub = label("UserStatus", "Set up your LarpKuran account", 12, C.muted, Enum.FontWeight.Regular, userChoice)
selectSub.Position = UDim2.new(0, 0, 0, 150)
selectSub.Size = UDim2.new(1, 0, 0, 34)
local selectNote = label("SelectNote", "Only your current Roblox account can sign in.", 11, C.dim, Enum.FontWeight.Regular, selectPage)
selectNote.Position = UDim2.new(0, 20, 0, 278)
selectNote.Size = UDim2.new(1, -40, 0, 30)
local selectSignOut = new("TextButton", {
    Name = "SignOutFromAccount",
    Text = "Sign Out",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 272),
    Size = UDim2.fromOffset(128, 38),
    BackgroundColor3 = Color3.fromRGB(52, 54, 61),
    TextColor3 = C.white,
    TextSize = 13,
    FontFace = inter(Enum.FontWeight.Medium),
    BorderSizePixel = 0,
    Visible = false,
}, selectPage)
rounded(selectSignOut, 9, C.cardStroke, 0.4)

-- Key entry: exactly one text box.
local keyAvatar, keyImage = avatar("NewUserAvatar", 76, keyPage)
keyAvatar.AnchorPoint = Vector2.new(0.5, 0)
keyAvatar.Position = UDim2.new(0.5, 0, 0, 2)
local keyName = label("KeyUser", "New User", 17, C.white, Enum.FontWeight.Medium, keyPage)
keyName.Position = UDim2.new(0, 20, 0, 82)
keyName.Size = UDim2.new(1, -40, 0, 25)
local keyHelp = label("KeyHelp", "Claim a new 24-hour key in the Discord key channel each day.", 13, C.muted, Enum.FontWeight.Regular, keyPage)
keyHelp.Position = UDim2.new(0, 28, 0, 110)
keyHelp.Size = UDim2.new(1, -56, 0, 31)
local keyContainer = new("Frame", {
    Name = "KeyField",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 150),
    Size = UDim2.new(1, -48, 0, 48),
    BackgroundColor3 = C.input,
    BorderSizePixel = 0,
}, keyPage)
rounded(keyContainer, 9, C.cardStroke, 0.08)
new("UISizeConstraint", { MaxSize = Vector2.new(430, 48) }, keyContainer)
local keyBox = new("TextBox", {
    Name = "KeyInput",
    Position = UDim2.fromOffset(14, 0),
    Size = UDim2.new(1, -28, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "Enter your key grabbed from the server.",
    PlaceholderColor3 = C.dim,
    TextColor3 = C.white,
    TextSize = 14,
    FontFace = inter(Enum.FontWeight.Regular),
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
}, keyContainer)
local getKey = new("TextButton", {
    Name = "GetKey",
    Text = "Get Key  ↗",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(0.5, -4, 0, 205),
    Size = UDim2.fromOffset(140, 44),
    BackgroundTransparency = 1,
    TextColor3 = C.blue,
    TextSize = 14,
    FontFace = inter(Enum.FontWeight.Medium),
    AutoButtonColor = false,
}, keyPage)
local tutorialButton = new("TextButton", {
    Name = "TutorialButton",
    Text = "Tutorial  →",
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0.5, 4, 0, 205),
    Size = UDim2.fromOffset(140, 44),
    BackgroundTransparency = 1,
    TextColor3 = C.blue,
    TextSize = 14,
    FontFace = inter(Enum.FontWeight.Medium),
    AutoButtonColor = false,
}, keyPage)
local keyStatus = label("KeyStatus", "Use your new key from the Discord server.", 11, C.dim, Enum.FontWeight.Regular, keyPage)
keyStatus.Position = UDim2.new(0, 25, 0, 279)
keyStatus.Size = UDim2.new(1, -50, 0, 45)
keyStatus.TextWrapped = true
local verificationCommand = new("TextBox", {
    Name = "DiscordVerificationCommand",
    Position = keyStatus.Position,
    Size = keyStatus.Size,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Text = "",
    TextColor3 = C.blue,
    TextSize = 11,
    FontFace = inter(Enum.FontWeight.Regular),
    TextWrapped = true,
    TextScaled = true,
    ClearTextOnFocus = false,
    TextEditable = false,
    Visible = false,
}, keyPage)
new("UITextSizeConstraint", { MinTextSize = 8, MaxTextSize = 11 }, verificationCommand)
local standAccountButton = new("TextButton", {
    Name = "UseAsStandAccount",
    Text = activateAsStand and "Use as Stand account: ON" or "Use as Stand account: OFF",
    Position = UDim2.new(0.5, -140, 0, 250),
    Size = UDim2.fromOffset(280, 26),
    BackgroundTransparency = 1,
    TextColor3 = C.muted,
    TextSize = 12,
    FontFace = inter(Enum.FontWeight.Medium),
}, keyPage)
standAccountButton.Activated:Connect(function()
    activateAsStand = not activateAsStand
    standAccountButton.Text = activateAsStand and "Use as Stand account: ON" or "Use as Stand account: OFF"
    keyStatus.Text = activateAsStand and "Stand is only for the alt companion, not another LarpKuran main account." or "Use your LarpKuran key on this Roblox account."
end)
local keySignOut = new("TextButton", {
    Name = "SignOutFromKey",
    Text = "Sign Out",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -14, 0, 5),
    Size = UDim2.fromOffset(94, 32),
    BackgroundTransparency = 1,
    TextColor3 = C.muted,
    TextSize = 12,
    FontFace = inter(Enum.FontWeight.Medium),
    AutoButtonColor = false,
}, keyPage)
local inviteFallback = new("TextBox", {
    Name = "InviteLink",
    Text = inviteUrl,
    TextEditable = false,
    ClearTextOnFocus = false,
    Position = UDim2.new(0, 25, 0, 279),
    Size = UDim2.new(1, -50, 0, 45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    TextColor3 = C.blue,
    TextSize = 12,
    FontFace = inter(Enum.FontWeight.Regular),
    Visible = false,
}, keyPage)

-- Welcome: server-verified account and membership.
local welcomeAvatar, welcomeImage = avatar("WelcomeAvatar", 96, welcomePage)
welcomeAvatar.AnchorPoint = Vector2.new(0.5, 0)
welcomeAvatar.Position = UDim2.new(0.5, 0, 0, 0)
new("UIStroke", {
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Color = Color3.fromRGB(111, 116, 125),
    Transparency = 0.45,
    Thickness = 1,
}, welcomeAvatar)
local verifiedDot = new("Frame", {
    Name = "VerifiedDot",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 39, 0, 77),
    Size = UDim2.fromOffset(22, 22),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, welcomePage)
rounded(verifiedDot, 11)
local verifiedCenter = new("Frame", {
    Name = "Status",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(12, 12),
    BackgroundColor3 = Color3.fromRGB(83, 205, 139),
    BorderSizePixel = 0,
}, verifiedDot)
rounded(verifiedCenter, 6)
local welcomeTitle = label("WelcomeTitle", "Welcome", 27, C.white, Enum.FontWeight.SemiBold, welcomePage)
welcomeTitle.Position = UDim2.new(0, 20, 0, 101)
welcomeTitle.Size = UDim2.new(1, -40, 0, 38)
welcomeTitle.TextWrapped = false
welcomeTitle.TextTruncate = Enum.TextTruncate.AtEnd
local welcomeName = label("WelcomeName", "@" .. player.Name, 13, C.muted, Enum.FontWeight.Regular, welcomePage)
welcomeName.Position = UDim2.new(0, 20, 0, 140)
welcomeName.Size = UDim2.new(1, -40, 0, 20)
local welcomeNote = label("WelcomeNote", "Account verified", 11, Color3.fromRGB(151, 199, 169), Enum.FontWeight.Medium, welcomePage)
welcomeNote.Position = UDim2.new(0, 20, 0, 164)
welcomeNote.Size = UDim2.new(1, -40, 0, 18)
local summary = new("Frame", {
    Name = "AccountSummary",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 194),
    Size = UDim2.new(1, -48, 0, 86),
    BackgroundColor3 = Color3.fromRGB(42, 44, 49),
    BorderSizePixel = 0,
}, welcomePage)
new("UISizeConstraint", { MaxSize = Vector2.new(440, 86) }, summary)
rounded(summary, 14, Color3.fromRGB(100, 103, 111), 0.55)
new("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new(Color3.fromRGB(44, 46, 52), Color3.fromRGB(35, 36, 41)),
}, summary)
local accountCaption = label("AccountCaption", "ACCOUNT", 10, C.muted, Enum.FontWeight.Medium, summary)
accountCaption.Position = UDim2.new(0, 18, 0, 12)
accountCaption.Size = UDim2.new(0, 90, 0, 22)
accountCaption.TextXAlignment = Enum.TextXAlignment.Left
local accountLabel = label("Account", "@" .. player.Name, 13, C.white, Enum.FontWeight.Medium, summary)
accountLabel.Position = UDim2.new(0, 108, 0, 12)
accountLabel.Size = UDim2.new(1, -126, 0, 22)
accountLabel.TextXAlignment = Enum.TextXAlignment.Right
accountLabel.TextTruncate = Enum.TextTruncate.AtEnd
new("Frame", {
    Name = "RowDivider",
    Position = UDim2.new(0, 18, 0, 42),
    Size = UDim2.new(1, -36, 0, 1),
    BackgroundColor3 = Color3.fromRGB(78, 80, 88),
    BackgroundTransparency = 0.48,
    BorderSizePixel = 0,
}, summary)
local licenseCaption = label("LicenseCaption", "ACCESS", 10, C.muted, Enum.FontWeight.Medium, summary)
licenseCaption.Position = UDim2.new(0, 18, 0, 51)
licenseCaption.Size = UDim2.new(0, 90, 0, 22)
licenseCaption.TextXAlignment = Enum.TextXAlignment.Left
local licenseLabel = label("License", "Account access", 13, C.white, Enum.FontWeight.Medium, summary)
licenseLabel.Position = UDim2.new(0, 108, 0, 51)
licenseLabel.Size = UDim2.new(1, -126, 0, 22)
licenseLabel.TextXAlignment = Enum.TextXAlignment.Right
licenseLabel.TextTruncate = Enum.TextTruncate.AtEnd
local welcomeSignOut = new("TextButton", {
    Name = "SignOutFromWelcome",
    Text = "Sign Out",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 290),
    Size = UDim2.fromOffset(128, 32),
    BackgroundTransparency = 1,
    TextColor3 = C.muted,
    TextSize = 12,
    FontFace = inter(Enum.FontWeight.Medium),
    BorderSizePixel = 0,
    Visible = false,
}, welcomePage)
welcomeSignOut.MouseEnter:Connect(function() welcomeSignOut.TextColor3 = C.white end)
welcomeSignOut.MouseLeave:Connect(function() welcomeSignOut.TextColor3 = C.muted end)

-- Version selection follows the current LarpKuran disk picker.
local pickerPrompt = label("PickerPrompt", "Choose the version you'd like to load", 16, C.white, Enum.FontWeight.Medium, pickerPage)
pickerPrompt.Position = UDim2.new(0, 18, 0, 5)
pickerPrompt.Size = UDim2.new(1, -238, 0, 42)
pickerPrompt.TextXAlignment = Enum.TextXAlignment.Left
local pickerSignOut = new("TextButton", {
    Name = "SignOutFromVersionPicker",
    Text = "Sign Out",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 10),
    Size = UDim2.fromOffset(82, 32),
    BackgroundTransparency = 1,
    TextColor3 = C.muted,
    TextSize = 12,
    FontFace = inter(Enum.FontWeight.Medium),
    AutoButtonColor = false,
    Visible = false,
}, pickerPage)
local versionArea = new("Frame", {
    Name = "VersionArea",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 55),
    Size = UDim2.fromOffset(620, 190),
    BackgroundTransparency = 1,
}, pickerPage)
local versions = {
    { name = "Full Production", note = "Production Build", icon = diskAsset, url = "https://api.x8stuff.lol/scripts/larpkuran.lua" },
    { name = "PvP Production", note = "Production Build", icon = diskAsset, disabled = false, maintenance = false, url = "https://api.x8stuff.lol/scripts/larpkuran-pvp.lua" },
    { name = "Full Beta", note = "Beta Channel", icon = betaDiskAsset, url = "https://api.x8stuff.lol/scripts/larpkuran-dev.lua" },
        { name = "PvP Beta", note = "Beta Channel", icon = betaDiskAsset, disabled = false, maintenance = false, url = "https://api.x8stuff.lol/scripts/larpkuran-pvp-beta.lua" },
    { name = "Stand", note = "Alt companion", icon = diskAsset, url = "https://api.x8stuff.lol/scripts/larpkuran.lua", role = "Stand" },
}
local function savedStandMainUsername()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return "" end
    local altName = player.Name:lower()
    local paths = {
        "larpkuran_stand_session_" .. altName .. ".json",
        "larpkuran_always_stand_" .. altName .. ".json",
        "larpkuran_pair.json",
        "larpkuran_stand_session.json",
        "larpkuran_always_stand.json",
    }
    for _, path in ipairs(paths) do
        local existsOk, exists = pcall(isfile, path)
        if existsOk and exists then
            local readOk, raw = pcall(readfile, path)
            local parseOk, data = false, nil
            if readOk then parseOk, data = pcall(HttpService.JSONDecode, HttpService, raw) end
            if parseOk and type(data) == "table" then
                local matchesAlt = tostring(data.alt or ""):lower() == altName
                if not matchesAlt and type(data.alts) == "table" then
                    for _, listed in ipairs(data.alts) do
                        if tostring(listed):lower() == altName then matchesAlt = true; break end
                    end
                end
                local main = type(data.main) == "string" and data.main:match("^%s*(.-)%s*$") or ""
                if matchesAlt and #main >= 3 and #main <= 20 and main:match("^[%w_]+$")
                    and main:lower() ~= altName then return main end
            end
        end
    end
    return ""
end
local standConfig = new("Frame", {
    Name = "StandMainAccount",
    AnchorPoint = Vector2.new(0.5, 0),
    Size = UDim2.new(1, -48, 0, 72),
    BackgroundTransparency = 1,
    Visible = false,
}, pickerPage)
local standHelp = label("StandHelp", "Main account Roblox username (not display name)", 12, C.muted, Enum.FontWeight.Regular, standConfig)
standHelp.Position = UDim2.fromOffset(0, 0)
standHelp.Size = UDim2.new(1, 0, 0, 24)
standHelp.TextWrapped = true
local standMainBox = new("TextBox", {
    Name = "MainUsername",
    Text = savedStandMainUsername(),
    PlaceholderText = "Enter main account username",
    PlaceholderColor3 = C.dim,
    TextColor3 = C.white,
    TextSize = 14,
    FontFace = inter(Enum.FontWeight.Regular),
    TextXAlignment = Enum.TextXAlignment.Center,
    ClearTextOnFocus = false,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0, 25),
    AnchorPoint = Vector2.new(0.5, 0),
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = C.input,
    BorderSizePixel = 0,
}, standConfig)
rounded(standMainBox, 9, C.cardStroke, 0.08)
new("UISizeConstraint", { MaxSize = Vector2.new(430, 42) }, standMainBox)
local versionButtons = {}
local versionOutlines = {}
local pickerStatus
local pickerEmpty
selectedVersion = 1
local function currentSlotRole()
    local role = cachedAccount and cachedAccount.slotRole
    if role == "MAIN" or role == "STAND" then return role end
    return nil
end
local function versionAllowed(version)
    if not version then return false end
    local role = currentSlotRole()
    if version.role == "Stand" then return role == "STAND" end
    return role == "MAIN"
end
local function updatePickerExtra()
    local standSelected = versions[selectedVersion] and versions[selectedVersion].role == "Stand"
    local areaHeight = versionArea.Size.Y.Offset
    standConfig.Visible = standSelected == true
    local areaTop = versionArea.Position.Y.Offset
    local pageHeight = pickerPage.Size.Y.Offset
    local standTop = math.min(areaTop + areaHeight + 8, pageHeight - standConfig.Size.Y.Offset - 40)
    standConfig.Position = UDim2.new(0.5, 0, 0, math.max(areaTop, standTop))
    if pickerEmpty then pickerEmpty.Visible = selectedVersion == nil end
    local statusTop = selectedVersion and (standSelected and standConfig.Position.Y.Offset + standConfig.Size.Y.Offset + 8 or areaTop + areaHeight + 8) or 132
    statusTop = math.min(statusTop, pageHeight - pickerStatus.Size.Y.Offset)
    pickerStatus.Position = UDim2.new(0, 20, 0, statusTop)
end
local function refreshVersions()
    if not selectedVersion or not versionAllowed(versions[selectedVersion]) or versions[selectedVersion].disabled then
        selectedVersion = nil
        for index, version in ipairs(versions) do
            if versionAllowed(version) and not version.disabled then selectedVersion = index; break end
        end
    end
    for index, button in ipairs(versionButtons) do
        button.Visible = versionAllowed(versions[index])
        local selected = index == selectedVersion
        local disabled = versions[index].disabled == true
        local icon = button:FindFirstChild("DiskIcon")
        local name = button:FindFirstChild("VersionName")
        local note = button:FindFirstChild("VersionNote")
        if icon then icon.ImageColor3 = disabled and Color3.fromRGB(105, 108, 118) or Color3.fromRGB(255, 255, 255) end
        if name then name.TextColor3 = disabled and Color3.fromRGB(132, 135, 145) or C.white end
        if note then note.TextColor3 = disabled and Color3.fromRGB(185, 188, 198) or C.muted end
        local tooltip = button:FindFirstChild("MaintenanceTooltip")
        if tooltip then tooltip.Visible = disabled and button:GetAttribute("Hovered") == true end
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = disabled and 0.2 or (selected and 0.45 or 1),
        }):Play()
        TweenService:Create(versionOutlines[index], TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = disabled and 0.35 or (selected and 0 or 1),
        }):Play()
    end
    if selectedVersion then
        pickerStatus.Text = versions[selectedVersion].role == "Stand" and "Enter your main account username below." or versions[selectedVersion].name .. " selected"
    end
    updatePickerExtra()
end
for index, version in ipairs(versions) do
    local selectedIndex = index
    local button = new("TextButton", {
        Name = version.name:gsub("%s+", "") .. "Version",
        Text = "",
        Size = UDim2.fromOffset(145, 180),
        BackgroundColor3 = Color3.fromRGB(26, 28, 36),
        BackgroundTransparency = index == selectedVersion and 0.45 or 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, versionArea)
    if version.disabled then button.BackgroundColor3 = Color3.fromRGB(43, 45, 51) end
    rounded(button, 18, Color3.fromRGB(140, 145, 165), index == selectedVersion and 0 or 1)
    local outline = button:FindFirstChildOfClass("UIStroke")
    outline.Thickness = 1.5
    versionOutlines[index] = outline
    local icon = new("ImageLabel", {
        Name = "DiskIcon",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 12),
        Size = UDim2.fromOffset(112, 112),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit,
        Image = version.icon,
    }, button)
    if version.icon == "rbxassetid://16898670469" then
        icon.ImageRectSize = Vector2.new(256, 256)
        icon.ImageRectOffset = Vector2.zero
        icon.ImageColor3 = Color3.fromRGB(220, 222, 230)
    end
    local name = label("VersionName", version.name, 13, C.white, Enum.FontWeight.SemiBold, button)
    name.Position = UDim2.new(0, 4, 0, 126)
    name.Size = UDim2.new(1, -8, 0, 24)
    local note = label("VersionNote", version.note, 11, C.muted, Enum.FontWeight.Regular, button)
    note.Position = UDim2.new(0, 4, 0, 149)
    note.Size = UDim2.new(1, -8, 0, 20)
    local maintenanceTooltip = label("MaintenanceTooltip", "Maintenance", 12, C.white, Enum.FontWeight.Medium, button)
    maintenanceTooltip.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
    maintenanceTooltip.BackgroundTransparency = 0.08
    maintenanceTooltip.Position = UDim2.new(0, 9, 0.5, -15)
    maintenanceTooltip.Size = UDim2.new(1, -18, 0, 30)
    maintenanceTooltip.ZIndex = 4
    maintenanceTooltip.Visible = false
    new("UICorner", { CornerRadius = UDim.new(0, 7) }, maintenanceTooltip)
    versionButtons[index] = button
    button.Activated:Connect(function()
        if not versionAllowed(version) or version.disabled then return end
        selectedVersion = selectedIndex
        pickerStatus.Text = version.role == "Stand" and "Enter your main account username below." or version.name .. " selected"
        refreshVersions()
    end)
    button.MouseEnter:Connect(function()
        button:SetAttribute("Hovered", true)
        if version.disabled then maintenanceTooltip.Visible = true end
    end)
    button.MouseLeave:Connect(function()
        button:SetAttribute("Hovered", false)
        maintenanceTooltip.Visible = false
    end)
end
pickerStatus = label("PickerStatus", "Full Production selected", 11, C.dim, Enum.FontWeight.Regular, pickerPage)
pickerStatus.Position = UDim2.new(0, 20, 0, 260)
pickerStatus.Size = UDim2.new(1, -40, 0, 32)
pickerEmpty = label("NoAuthorizedVersions", "No versions available. Reopen LarpKuran to verify your sign-in.", 13, C.muted, Enum.FontWeight.Medium, pickerPage)
pickerEmpty.Position = UDim2.new(0, 24, 0, 55)
pickerEmpty.Size = UDim2.new(1, -48, 0, 70)
pickerEmpty.Visible = false

-- The guide uses the supplied screenshots. Steps 8 and 9 are redrawn with the private key removed.
local tutorialSlides = {
    { title = "Click Get Key", detail = "Copy the Discord invite from the sign-in screen.", file = "step-01.png" },
    { title = "Open the invite", detail = "Paste the copied link into Discord or your browser.", file = "step-02.png" },
    { title = "Join the server", detail = "Accept the invite by pressing Join Server.", file = "step-03.png" },
    { title = "Find the key channel", detail = "Open #get-your-key-here-pls in the server.", file = "step-04.png" },
    { title = "Claim a key", detail = "Press Claim Key on the StacyKEYS panel.", file = "step-05.png" },
    { title = "Choose a game", detail = "Open the game menu in the bot's private reply.", file = "step-06.png" },
    { title = "Select Larpkuran", detail = "Pick Larpkuran, then choose MAIN, STAND, or reclaim as prompted.", file = "step-07.png" },
    { title = "Copy your private key", detail = "The bot shows your key privately. Copy it and keep it secret.", file = "step-08.png" },
    { title = "Paste and activate", detail = "Return here, paste your key, then press Activate Key.", file = "step-09.png" },
    { title = "Welcome", detail = "After activation, the account welcome screen appears.", file = "step-10.png" },
    { title = "Choose a version", detail = "Select the LarpKuran version you want to load.", file = "step-11.png" },
    { title = "Set up each Stand", detail = "Sign in separately on each Stand and approve your Main as its controller.", text = "1 Main + up to 10 Stand accounts per Discord.\n\nEach Stand needs its own valid sign-in and must explicitly approve control.\n\nKeep Main and Stands in the same Roblox server. Same-computer and cross-device setups are supported." },
    { title = "Choose command recipients", detail = "On Main, open Stand > Command Recipient.", text = "All Stands\nControl all paired Stands.\n\nA specific Stand\nManual commands and automatic events, including Double Trouble, go only to that Stand.\n\nAn offline selection is not redirected to other Stands." },
    { title = "Send a one-command override", detail = "Use /st without changing your saved UI selection.", text = "/st all /s\nSummon all available paired Stands.\n\n/st JayUwU24 /kill TargetName\nSend only to JayUwU24; replace TargetName.\n\n/st all /cancel\nCancel all available paired Stands.\n\n/unpair JayUwU24\nRemove pairing, not the account or key.\n\nMissed or expired commands are not replayed after reconnecting." },
}
local tutorialIndex = 1
local tutorialTitle = label("TutorialTitle", "", 18, C.white, Enum.FontWeight.SemiBold, tutorialPage)
tutorialTitle.Position = UDim2.new(0, 20, 0, 0)
tutorialTitle.Size = UDim2.new(1, -40, 0, 30)
local tutorialDetail = label("TutorialDetail", "", 13, C.muted, Enum.FontWeight.Regular, tutorialPage)
tutorialDetail.Position = UDim2.new(0, 24, 0, 27)
tutorialDetail.Size = UDim2.new(1, -48, 0, 33)
local tutorialImageFrame = new("Frame", {
    Name = "TutorialImageFrame",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 63),
    Size = UDim2.new(1, -48, 0, 260),
    BackgroundColor3 = C.input,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, tutorialPage)
rounded(tutorialImageFrame, 12, C.cardStroke, 0.3)
local tutorialImage = new("ImageLabel", {
    Name = "TutorialImage",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
}, tutorialImageFrame)
local tutorialMissing = label("MissingImage", "Tutorial image unavailable. Please reconnect and reopen the tutorial.", 12, C.muted, Enum.FontWeight.Regular, tutorialImageFrame)
tutorialMissing.Size = UDim2.new(1, -40, 1, -20)
tutorialMissing.Position = UDim2.fromOffset(20, 10)
local tutorialCounter = label("TutorialCounter", "", 11, C.dim, Enum.FontWeight.Medium, tutorialPage)
tutorialCounter.AnchorPoint = Vector2.new(1, 0)
tutorialCounter.Position = UDim2.new(1, -20, 0, 1)
tutorialCounter.Size = UDim2.fromOffset(54, 26)
tutorialCounter.TextXAlignment = Enum.TextXAlignment.Right

local function showTutorialSlide()
    local slide = tutorialSlides[tutorialIndex]
    tutorialTitle.Text = slide.title
    tutorialDetail.Text = slide.detail
    tutorialCounter.Text = string.format("%d / %d", tutorialIndex, #tutorialSlides)
    tutorialImage.Image = slide.file and (localAsset("larpkuran-tutorial-v2/cropped-final/" .. slide.file) or "") or ""
    tutorialImage.Size = slide.file == "step-01.png" and UDim2.fromOffset(285, 120) or UDim2.fromScale(1, 1)
    tutorialImage.ImageRectOffset = Vector2.zero
    tutorialImage.ImageRectSize = Vector2.zero
    tutorialMissing.Visible = tutorialImage.Image == ""
    tutorialMissing.Text = slide.text or "Tutorial image unavailable. Please reconnect and reopen the tutorial."
    tutorialMissing.TextXAlignment = slide.text and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    tutorialMissing.TextYAlignment = slide.text and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    tutorialMissing.TextSize = slide.text and 14 or 12
    if step == 5 then
        navBackCaption.Text = "Previous"
        navNextCaption.Text = tutorialIndex == #tutorialSlides and "Done" or "Next"
    end
end

-- Both entry points live in the current recovery wizard.
local function loginButton(name, text, y, parent)
    local button = new("TextButton", {
        Name = name, Text = text, AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, y), Size = UDim2.new(1, -48, 0, 54),
        BackgroundColor3 = C.input, BorderSizePixel = 0, TextColor3 = C.white,
        TextSize = 16, FontFace = inter(Enum.FontWeight.Medium), AutoButtonColor = false,
    }, parent)
    new("UISizeConstraint", { MaxSize = Vector2.new(430, 54) }, button)
    rounded(button, 12, C.cardStroke, 0.2)
    return button
end
local dailyLoginButton = loginButton("DailyKeyLogin", "License Key Login", 25, loginPage)
local dailyDescription = label("DailyKeyDescription", "Claim a new 24-hour key in the Discord key channel each day.", 12, C.muted, Enum.FontWeight.Regular, loginPage)
dailyDescription.Position = UDim2.new(0, 24, 0, 87)
dailyDescription.Size = UDim2.new(1, -48, 0, 40)
local discordLoginButton = loginButton("DiscordAccountLogin", "Discord Account Login", 153, loginPage)
local discordDescription = label("DiscordDescription", "No daily key. Linked to your Discord, with no device restriction.", 12, C.muted, Enum.FontWeight.Regular, loginPage)
discordDescription.Position = UDim2.new(0, 24, 0, 215)
discordDescription.Size = UDim2.new(1, -48, 0, 48)
local discordStart = loginButton("StartDiscordLogin", "Sign in with Discord", 12, discordPage)
local discordRole = loginButton("DiscordAccountRole", "Account role: Main", 77, discordPage)
local discordHelp = label("DiscordHelp", "Discord membership is required. No daily key or HWID binding.", 12, C.muted, Enum.FontWeight.Regular, discordPage)
discordHelp.Position = UDim2.new(0, 24, 0, 138)
discordHelp.Size = UDim2.new(1, -48, 0, 40)
local discordLink = new("TextBox", {
    Name = "DiscordLoginLink", Text = "", PlaceholderText = "Your browser login link appears here",
    TextEditable = false, ClearTextOnFocus = false, TextWrapped = true,
    Position = UDim2.new(0, 24, 0, 184), Size = UDim2.new(1, -48, 0, 62),
    BackgroundColor3 = C.input, BorderSizePixel = 0, TextColor3 = C.blue,
    TextSize = 11, FontFace = inter(Enum.FontWeight.Regular),
}, discordPage)
rounded(discordLink, 9, C.cardStroke, 0.2)
local discordStatus = label("DiscordStatus", "Authorize your Discord account in the browser to continue.", 12, C.muted, Enum.FontWeight.Regular, discordPage)
discordStatus.Position = UDim2.new(0, 24, 0, 258)
discordStatus.Size = UDim2.new(1, -48, 0, 60)
local pages = { selectPage, keyPage, welcomePage, pickerPage, tutorialPage, loginPage, discordPage }
local hints = {
    "",
    "Sign in with your 24-hour LarpKuran key.",
    "Your LarpKuran account is ready.",
    "Select a version to continue.",
    "Follow the steps to get your key.",
    "Choose how to sign in.",
    "Sign in with your Discord account.",
}

local function layoutVersions(panelWidth)
    local allowed = {}
    for index, version in ipairs(versions) do
        if versionAllowed(version) then table.insert(allowed, index) end
    end
    local columns = math.max(1, math.min(#allowed, panelWidth < 550 and 2 or (panelWidth < 700 and 3 or 4)))
    local width = math.min(620, math.max(1, panelWidth - 42))
    local gap = 10
    local cardWidth = math.min(180, math.floor((width - gap * (columns - 1)) / columns))
    local rows = math.ceil(#allowed / columns)
    local cardHeight = rows > 1 and 112 or (columns == 1 and 150 or 180)
    local areaHeight = rows > 0 and (rows * cardHeight + (rows - 1) * gap) or 0
    versionArea.Size = UDim2.fromOffset(width, areaHeight)
    local gridWidth = columns * cardWidth + (columns - 1) * gap
    for visibleIndex, index in ipairs(allowed) do
        local button = versionButtons[index]
        local col = (visibleIndex - 1) % columns
        local row = math.floor((visibleIndex - 1) / columns)
        button.Position = UDim2.fromOffset(math.floor((width - gridWidth) / 2) + col * (cardWidth + gap), row * (cardHeight + gap))
        button.Size = UDim2.fromOffset(cardWidth, cardHeight)
        local icon = button:FindFirstChild("DiskIcon")
        if icon then
            local iconSize = rows > 1 and 58 or (columns == 1 and 86 or 96)
            icon.Size = UDim2.fromOffset(iconSize, iconSize)
            icon.Position = UDim2.new(0.5, 0, 0, rows > 1 and 4 or 8)
        end
        local name = button:FindFirstChild("VersionName")
        local note = button:FindFirstChild("VersionNote")
        if name then
            name.Position = UDim2.new(0, 4, 0, rows > 1 and 65 or (columns == 1 and 98 or 111))
            name.TextSize = rows > 1 and 12 or 13
        end
        if note then
            note.Position = UDim2.new(0, 4, 0, rows > 1 and 88 or (columns == 1 and 122 or 145))
            note.TextSize = rows > 1 and 10 or 11
        end
    end
    refreshVersions()
    updatePickerExtra()
end

local function selectPageLift(height)
    return math.min(24, math.max(0, math.floor((height - 360) * 0.15)))
end

local function fit()
    local bounds = gui.AbsoluteSize
    if bounds.X < 1 or bounds.Y < 1 then return end
    local insetTopLeft, insetBottomRight = Vector2.zero, Vector2.zero
    pcall(function()
        insetTopLeft, insetBottomRight = game:GetService("GuiService"):GetGuiInset()
    end)
    local safeLeft = math.clamp(insetTopLeft.X, 0, bounds.X - 1)
    local safeTop = math.clamp(insetTopLeft.Y, 0, bounds.Y - 1)
    local safeRight = math.clamp(insetBottomRight.X, 0, bounds.X - safeLeft - 1)
    local safeBottom = math.clamp(insetBottomRight.Y, 0, bounds.Y - safeTop - 1)
    local safeWidth = bounds.X - safeLeft - safeRight
    local safeHeight = bounds.Y - safeTop - safeBottom
    local marginX = math.min(12, (safeWidth - 1) / 2)
    local marginY = math.min(12, (safeHeight - 1) / 2)
    local width = math.min(760, safeWidth - marginX * 2)
    local height = math.min(520, safeHeight - marginY * 2)
    -- Keep the visual centre on the screen unless a phone safe area requires a shift.
    local centreX = math.clamp(bounds.X / 2, safeLeft + marginX + width / 2, bounds.X - safeRight - marginX - width / 2)
    local centreY = math.clamp(bounds.Y / 2, safeTop + marginY + height / 2, bounds.Y - safeBottom - marginY - height / 2)
    panel.Position = UDim2.fromOffset(centreX, centreY)
    panel.Size = UDim2.fromOffset(width, height)
    local keyLinkWidth = math.min(140, math.max(1, math.floor((width - 32) / 2)))
    getKey.Size = UDim2.fromOffset(keyLinkWidth, 44)
    tutorialButton.Size = UDim2.fromOffset(keyLinkWidth, 44)
    local compactTutorial = step == 5 and width < 470
    tutorialExit.Text = compactTutorial and "Exit" or "Exit Tutorial"
    tutorialExit.Position = UDim2.new(0, compactTutorial and 8 or 20, 0.5, 0)
    tutorialExit.Size = UDim2.fromOffset(compactTutorial and 45 or 110, 44)
    navBack.Position = UDim2.new(0, compactTutorial and math.floor(width * 0.59) or math.floor(width / 2 - 18), 0.5, 0)
    navNext.Position = UDim2.new(0, compactTutorial and math.floor(width * 0.59 + 8) or math.floor(width / 2 + 18), 0.5, 0)
    local longNextCaption = step == 2 or step == 3
    navNext.Size = UDim2.fromOffset(longNextCaption and math.min(128, math.max(86, math.floor(width / 2 - 30))) or 86, 68)
    navNextCaption.TextSize = longNextCaption and width < 360 and 11 or 13
    title.TextSize = width < 450 and 29 or 36
    headerHint.TextSize = width < 450 and 13 or 15
    local compactHeader = height < 500
    local headerHeight = compactHeader and 88 or 111
    title.Position = UDim2.new(0.5, 0, 0, compactHeader and 11 or 25)
    headerHint.Position = UDim2.new(0.5, 0, 0, compactHeader and 56 or 77)
    contentHost.Position = UDim2.fromOffset(0, headerHeight)
    contentHost.Size = UDim2.new(1, 0, 1, -(headerHeight + 78))
    local contentHeight = math.max(1, height - headerHeight - 78)
    local contentScale = math.min(1, contentHeight / 331)
    for _, page in ipairs(pages) do
        page.FitScale.Scale = contentScale
    end
    if step == 1 and selectPage.Visible then
        selectPage.Position = UDim2.new(0.5, 0, 0.5, -selectPageLift(height))
    end
    layoutVersions(width)
end

local function refreshProfile()
    if cachedAccount then syncAccountRole(cachedAccount) end
    standAccountButton.Text = activateAsStand and "Use as Stand account: ON" or "Use as Stand account: OFF"
    discordRole.Text = activateAsStand and "Account role: Stand" or "Account role: Main"
    local knownAccount = registered or (type(cachedAccount) == "table" and tostring(cachedAccount.robloxUserId) == currentRobloxUserId)
        or authRestoreErrorCode == "DEVICE_MISMATCH"
        or authRestoreErrorCode == "BINDING_MISMATCH"
        or authRestoreErrorCode == "DEVICE_RESET_REQUIRED"
        or authRestoreErrorCode == "GUILD_MEMBERSHIP_REQUIRED"
        or authRestoreErrorCode == "LEFT_SERVER"
        or authRestoreErrorCode == "ENTITLEMENT_REVOKED"
    -- Roblox identity is available even if an older loader already deleted its login cache.
    -- Showing the current player is not proof of Discord identity or authorization.
    local name = player.DisplayName
    keyName.Text = name
    keyHelp.Text = not registered and knownAccount
        and (tostring(cachedAccount and cachedAccount.discordUsername or player.Name)
            .. " · " .. (activateAsStand and "Stand" or "Main") .. "\nAccount remembered. Enter a new valid key.")
        or authRestoreErrorCode == "DEVICE_RESET_REQUIRED"
        and "Claim a new LarpKuran key in Discord to rebind your device."
        or authRestoreErrorCode == "KEY_REQUIRED"
        and "Claim a new key for this Roblox account from your linked Discord."
        or "Claim a new 24-hour key in the Discord key channel each day."
    selectName.Text = name
    selectSignOut.Visible = registered
    selectNote.Position = UDim2.new(0, 20, 0, registered and 311 or 278)
    selectNote.Size = UDim2.new(1, -40, 0, registered and 18 or 30)
    welcomeSignOut.Visible = registered
    pickerSignOut.Visible = registered
    keySignOut.Visible = registered or knownAccount or authRestoreErrorCode == "DEVICE_RESET_REQUIRED"
    keySignOut.Text = registered and "Sign Out" or "Forget Account"
    welcomeNote.Text = signOutError or "Account verified"
    welcomeNote.TextColor3 = signOutError and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(151, 199, 169)
    selectSub.Text = signOutError or registered and "Registered LarpKuran account"
        or knownAccount and (tostring(cachedAccount and cachedAccount.discordUsername or player.Name)
            .. " · " .. (activateAsStand and "Stand" or "Main") .. "\nAccount remembered. New key required.")
        or authRestoreErrorCode == "KEY_REQUIRED" and "Claim a new key for this Roblox account from your linked Discord."
        or authRestoreErrorCode == "DEVICE_ID_UNAVAILABLE" and "A device ID is required for key login. Use Discord login without HWID."
        or authRestoreErrorCode == "GUILD_MEMBERSHIP_REQUIRED" and "Rejoin Discord, then use Discord login or a new daily key."
        or authRestoreErrorCode == "LEFT_SERVER" and "LEFT_SERVER: Rejoin Discord, then sign in again."
        or authRestoreErrorCode == "DISCORD_UNAVAILABLE" and "Discord verification is unavailable. Choose a login method to retry."
        or authRestoreErrorCode == "ENTITLEMENT_REVOKED" and "This license was revoked. Claim a new key or contact x8."
        or authRestoreErrorCode == "DEVICE_MISMATCH" and "Key login is bound to another device. Use Discord login or reset the device."
        or authRestoreErrorCode == "BINDING_MISMATCH" and "Sign in again to verify this account binding."
        or authRestoreErrorCode == "DEVICE_RESET_REQUIRED" and "Claim a new LarpKuran key in Discord to rebind this device."
        or "Set up your LarpKuran account"
    applyAvatar(selectImage, true)
    applyAvatar(keyImage, true)
    applyAvatar(welcomeImage, registered)
    welcomeTitle.Text = "Welcome, " .. player.DisplayName
    welcomeName.Text = "@" .. player.Name
    local expiry = cachedAccount and cachedAccount.expiresAt
    licenseLabel.Text = registered and (sessionAuthMode == "REVIEWER"
        and "Reviewer access · No HWID restriction"
        or sessionAuthMode == "DISCORD_NO_HWID"
        and "Discord login · No HWID restriction"
        or expiry and "Daily key expires " .. tostring(expiry) or "Daily key access") or "Unavailable"
    refreshVersions()
    if registered and not currentSlotRole() then
        pickerStatus.Text = "Account role unavailable. Reopen this loader to verify again."
    end
end

local function switchTo(nextStep)
    step = nextStep
    headerHint.Text = hints[step]
    local inTutorial = step == 5
    navNext.Visible = step ~= 6 and step ~= 7
    tutorialExit.Visible = inTutorial
    fit()
    -- The account chooser has no header hint. Centre its content in the
    -- available body instead of leaving the empty hint row above it.
    local selectLift = selectPageLift(panel.Size.Y.Offset)
    for index, page in ipairs(pages) do
        page.Visible = index == step
        if index == step then
            local targetOffset = index == 1 and -selectLift or 0
            page.Position = UDim2.new(0.5, 0, 0.5, targetOffset + 8)
            TweenService:Create(page, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, targetOffset),
            }):Play()
        end
    end
    navBackCaption.Text = step == 1 and "Close" or "Previous"
    if step == 1 then
        navNextCaption.Text = "Next"
    elseif step == 2 then
        navNextCaption.Text = "Activate Key"
    elseif step == 3 then
        navNextCaption.Text = "Choose Version"
    elseif step == 5 then
        showTutorialSlide()
    else
        navNextCaption.Text = "Continue"
    end
    refreshProfile()
end

local function handleNext()
    if signingOut or discordPending then return end
    if step == 1 then
        if registered then
            switchTo(3)
            return
        end
        switchTo(6)
    elseif step == 2 then
        if activating then return end
        inviteFallback.Visible = false
        verificationCommand.Visible = false
        keyStatus.Visible = true
        if not cachedAccount then keyHelp.Text = "Claim a new 24-hour key in the Discord key channel each day." end
        local value = keyBox.Text:match("^%s*(.-)%s*$")
        if value == "" then
            keyStatus.Text = "Enter your key to activate your account."
            keyStatus.TextColor3 = Color3.fromRGB(255, 151, 151)
            return
        end
        activating = true
        keyStatus.Text = "Verifying your key and Discord membership..."
        keyStatus.TextColor3 = C.muted
        task.spawn(function()
            local success, resultCode, command = activateKey(value)
            activating = false
            if not gui.Parent then return end
            if resultCode == "DISCORD_VERIFICATION_REQUIRED" then
                -- Keep the original key: the clipboard now contains the Discord command.
                keyHelp.Text = keyStatusMsg
                keyStatus.Visible = false
                verificationCommand.Text = command
                verificationCommand.Visible = true
                return
            end
            if not success or not isUnlocked or not sessionToken then
                keyStatus.Text = keyStatusMsg
                keyStatus.TextColor3 = Color3.fromRGB(255, 151, 151)
                return
            end
            keyBox.Text = ""
            registered = true
            welcomeTitle.Text = "Welcome, " .. player.DisplayName
            refreshProfile()
            switchTo(3)
        end)
    elseif step == 3 then
        switchTo(4)
    elseif step == 4 then
        if launching then return end
        if not registered or not isUnlocked or not sessionToken then
            switchTo(2)
            return
        end
        if not currentSlotRole() then
            pickerStatus.Text = "Rechecking your account role..."
            local restored = checkSavedSession()
            refreshProfile()
            if not restored or not currentSlotRole() then
                pickerStatus.Text = authRestoreErrorCode == "NOT_REGISTERED" and "No active account found. Claim a new key and sign in."
                    or authRestoreErrorCode == "GUILD_MEMBERSHIP_REQUIRED" and "Discord membership is required. Rejoin the server, then sign in again."
                    or authRestoreErrorCode == "LEFT_SERVER" and "LEFT_SERVER: Rejoin Discord, then sign in again."
                    or authRestoreErrorCode == "DISCORD_UNAVAILABLE" and "Discord verification is unavailable. Try again shortly."
                    or "Account role unavailable. Reopen this loader and sign in again."
                return
            end
        end
        if not selectedVersion then
            pickerStatus.Text = "Choose a version for your verified account."
            return
        end
        if not versionAllowed(versions[selectedVersion]) then
            pickerStatus.Text = "This version is not available for your account role. Choose another version."
            return
        end
        local version = versions[selectedVersion]
        if version.disabled then
            pickerStatus.Text = "Maintenance: this version is temporarily unavailable."
            return
        end
        local mainUsername = nil
        if version.role == "Stand" then
            mainUsername = standMainBox.Text:match("^%s*(.-)%s*$")
            if #mainUsername < 3 or #mainUsername > 20 or not mainUsername:match("^[%w_]+$")
                or mainUsername:lower() == player.Name:lower() then
                pickerStatus.Text = "Enter your main Roblox username (3-20 letters, numbers or _)."
                return
            end
        end
        launching = true
        pickerStatus.Text = "Loading " .. version.name .. "..."
        task.spawn(function()
            local ok, err = pcall(function()
                if type(loadstring) ~= "function" then error("Script loading is unavailable in this executor.") end
                local separator = version.url:find("?", 1, true) and "&" or "?"
                local source = game:HttpGet(version.url .. separator .. "t=" .. tostring(os.time()))
                local fn, compileError = loadstring(source)
                if type(fn) ~= "function" then error(compileError or "Script compilation failed.") end
                -- The existing public loader performs the final server-side authorization and payload checks.
                env.StacyKeyVerified = true
                env.StacyKeyToken = sessionToken
                env.StacyCMDStartupToken = sessionToken
                env.LarpRole = version.role == "Stand" and "Stand" or "Main"
                _G.LarpRole = env.LarpRole
                if mainUsername then
                    env.MainUsername = mainUsername
                    _G.MainUsername = mainUsername
                    _G.StandMainUsername = mainUsername
                end
                local launchResult = fn()
                if launchResult == false then
                    error("The loader could not start LarpKuran. Check the loader error window.")
                end
            end)
            launching = false
            if not gui.Parent then return end
            if ok then
                env[cleanupKey]()
            else
                pickerStatus.Text = "Could not load " .. version.name .. ": " .. tostring(err):sub(1, 160)
            end
        end)
    elseif step == 5 then
        if tutorialIndex < #tutorialSlides then
            tutorialIndex = tutorialIndex + 1
            showTutorialSlide()
        else
            switchTo(2)
        end
    end
end

local function handleSignOut(unregister)
    if not registered and not sessionToken and not unregister then
        rememberedProfile.clear()
        deleteCurrentAccountSession()
        cachedAccount, sessionAuthMode, cachedKey = nil, nil, ""
        setExplicitSignOut()
        authRestoreErrorCode = "KEY_REQUIRED"
        keyBox.Text = ""
        switchTo(1)
        return
    end
    if signingOut or not registered then return end
    signingOut = true
    signOutError = nil
    selectSignOut.Text = "Signing Out..."
    welcomeSignOut.Text = "Signing Out..."
    pickerSignOut.Text = "Signing Out..."
    keySignOut.Text = "Signing Out..."
    task.spawn(function()
        local success, message = logoutSession(unregister == true)
        signingOut = false
        if not gui.Parent then return end
        selectSignOut.Text = "Sign Out"
        welcomeSignOut.Text = "Sign Out"
        pickerSignOut.Text = "Sign Out"
        keySignOut.Text = "Sign Out"
        if not success then
            signOutError = message or "Could not sign out. Please try again."
            refreshProfile()
            return
        end
        registered = false
        authRestoreErrorCode = "KEY_REQUIRED"
        signOutError = message
        keyBox.Text = ""
        selectedVersion = 1
        switchTo(1)
    end)
end
selectSignOut.Activated:Connect(handleSignOut)
welcomeSignOut.Activated:Connect(handleSignOut)
pickerSignOut.Activated:Connect(handleSignOut)
keySignOut.Activated:Connect(function()
    if not registered and not sessionToken and cachedAccount then
        handleSignOut(false)
        return
    end
    if not registered or type(sessionToken) ~= "string" or sessionToken == "" then
        verificationCommand.Visible = false
        keyStatus.Visible = true
        inviteFallback.Visible = false
        keyStatus.Text = "Sign Out is available after you sign in. Activate a new key first."
        keyStatus.TextColor3 = C.muted
        return
    end
    handleSignOut()
end)
do
    local actions = {}
    local overlay = new("TextButton", {Name="UnregisterConfirmation",Text="",AutoButtonColor=false,Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.2,Visible=false,ZIndex=100,Active=true,Modal=true}, gui)
    local dialog = new("Frame", {AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.new(0.86,0,0,220),BackgroundColor3=C.card,BorderSizePixel=0,ZIndex=101}, overlay)
    new("UISizeConstraint", {MaxSize=Vector2.new(430,220)}, dialog)
    rounded(dialog,12,C.cardStroke,0.4)
    new("TextLabel", {Text="Unregister LarpKuran?",Position=UDim2.fromOffset(16,14),Size=UDim2.new(1,-32,0,30),
        BackgroundTransparency=1,TextColor3=C.white,TextSize=18,FontFace=inter(Enum.FontWeight.Medium),ZIndex=102}, dialog)
    new("TextLabel", {Text="Remove this Roblox account's authorization and binding, and release its slot. Bans and cooldowns remain. You must register again.",
        Position=UDim2.fromOffset(20,52),Size=UDim2.new(1,-40,0,92),BackgroundTransparency=1,TextColor3=C.muted,
        TextWrapped=true,TextSize=13,FontFace=inter(Enum.FontWeight.Regular),ZIndex=102}, dialog)
    for i, name in ipairs({"Cancel","Unregister"}) do
        local button = new("TextButton", {Text=name,Position=UDim2.new((i-1)*0.5,12,1,-57),Size=UDim2.new(0.5,-24,0,40),
            BackgroundColor3=i==2 and Color3.fromRGB(155,55,63) or Color3.fromRGB(52,54,61),TextColor3=C.white,
            TextSize=13,FontFace=inter(Enum.FontWeight.Medium),BorderSizePixel=0,ZIndex=102}, dialog)
        rounded(button,8)
        button.Activated:Connect(function()
            overlay.Visible=false
            if i==2 then handleSignOut(true) end
        end)
    end
    for _, original in ipairs({selectSignOut,welcomeSignOut,pickerSignOut,keySignOut}) do
        local button=original:Clone()
        button.Name="UnregisterAccount"
        button.Text="Unregister"
        button.Parent=original.Parent
        original.Size=UDim2.fromOffset(100,32)
        button.Size=UDim2.fromOffset(100,32)
        if original==selectSignOut or original==welcomeSignOut then
            original.Position=UDim2.new(0.5,-56,original.Position.Y.Scale,original.Position.Y.Offset)
            button.Position=UDim2.new(0.5,56,button.Position.Y.Scale,button.Position.Y.Offset)
        else
            original.Position=UDim2.new(1,-118,original.Position.Y.Scale,original.Position.Y.Offset)
        end
        button.Visible=original.Visible
        original:GetPropertyChangedSignal("Visible"):Connect(function() button.Visible=original.Visible end)
        button.Activated:Connect(function()
            if signingOut then return end
            if not registered or not sessionToken then
                keyStatus.Text="Sign in with Discord or a new key before unregistering. You can also unregister in the Discord key channel."
                keyStatus.Visible=true
                return
            end
            overlay.Visible=true
        end)
        actions[#actions+1]=button
    end
end
userChoice.Activated:Connect(function() if step == 1 then handleNext() end end)
navNext.Activated:Connect(handleNext)
local function handleBack()
    if step == 1 then
        env[cleanupKey]()
    elseif step == 2 or step == 7 then
        discordPending = false
        activeRequestId, activeClaimSecret = nil, nil
        switchTo(6)
    elseif step == 6 then
        switchTo(1)
    elseif step == 3 then
        switchTo(registered and 1 or 2)
    elseif step == 4 then
        switchTo(3)
    elseif step == 5 then
        if tutorialIndex > 1 then
            tutorialIndex = tutorialIndex - 1
            showTutorialSlide()
        else
            switchTo(2)
        end
    end
end
navBack.Activated:Connect(handleBack)
dailyLoginButton.Activated:Connect(function() switchTo(2) end)
discordLoginButton.Activated:Connect(function()
    discordRole.Text = activateAsStand and "Account role: Stand" or "Account role: Main"
    switchTo(7)
end)
discordRole.Activated:Connect(function()
    if discordPending then return end
    activateAsStand = not activateAsStand
    discordRole.Text = activateAsStand and "Account role: Stand" or "Account role: Main"
    standAccountButton.Text = activateAsStand and "Use as Stand account: ON" or "Use as Stand account: OFF"
end)
local discordStarting = false
discordStart.Activated:Connect(function()
    if discordStarting or discordPending then return end
    discordStarting = true
    discordStart.Text = "Connecting..."
    discordStatus.Text = "Requesting secure Discord login..."
    task.spawn(function()
        local started = requestDiscordLogin()
        discordStarting = false
        if not gui.Parent or step ~= 7 then
            discordPending = false
            activeRequestId, activeClaimSecret = nil, nil
            return
        end
        discordLink.Text = started and tostring(stagedAuthLink or "") or ""
        discordStatus.Text = keyStatusMsg
        discordStart.Text = started and "Waiting for Discord..." or "Retry Discord Login"
        while gui.Parent and step == 7 and discordPending do
            pollDiscordLogin()
            if not gui.Parent or step ~= 7 then return end
            discordStatus.Text = keyStatusMsg
            if isUnlocked and sessionToken and not discordPending then
                registered = true
                refreshProfile()
                switchTo(3)
                return
            end
            task.wait(0.5)
        end
        if gui.Parent then discordStart.Text = "Sign in with Discord" end
    end)
end)
tutorialExit.Activated:Connect(function() switchTo(2) end)
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and step == 2 then handleNext() end
end)
getKey.Activated:Connect(function()
    verificationCommand.Visible = false
    local copy = type(setclipboard) == "function" and setclipboard
        or (type(toclipboard) == "function" and toclipboard)
    local copied = copy and pcall(copy, inviteUrl)
    keyStatus.Visible = copied == true
    inviteFallback.Visible = not copied
    if copied then
        keyStatus.Text = "Discord invite copied — open Discord and paste the link."
        keyStatus.TextColor3 = C.blue
    else
        inviteFallback.Text = inviteUrl
    end
end)
tutorialButton.Activated:Connect(function()
    tutorialIndex = 1
    switchTo(5)
end)

gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
task.defer(fit)
switchTo((forceKeyLogin or (not registered and cachedAccount ~= nil)) and 2 or 1)
if not registered and (authRestoreErrorCode == "GUILD_MEMBERSHIP_REQUIRED" or authRestoreErrorCode == "LEFT_SERVER") then
    selectSub.Text = "Rejoin Discord, then use Discord login or a new daily key."
elseif not registered and authRestoreErrorCode == "DISCORD_UNAVAILABLE" then
    selectSub.Text = "Discord verification is unavailable. Choose a login method to retry."
end
task.spawn(function()
    local ok, result = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
    end)
    if ok and type(result) == "string" and gui.Parent then
        avatarUrl = result
        refreshProfile()
    end
end)

end

-- Keep the existing backend and public version loaders, with the new sign-in UI as entry point.
if recoveryFlowActive then
    _G.LarpkuranShowPicker = function()
        isUnlocked, sessionToken, cachedAccount = false, nil, nil
        for _, scope in ipairs({type(getgenv) == "function" and getgenv() or _G, _G}) do
            scope.StacyKeyVerified = false
            scope.StacyKeyToken = nil
            scope.StacyCMDStartupToken = nil
        end
        if not wasExplicitlySignedOut() then checkSavedSession() end
        showRecoveryFlowUI()
    end
    if _G.LarpkuranShellShutdown then
        pcall(_G.LarpkuranShellShutdown)
        _G.LarpkuranShellShutdown = nil
    end
    if _G.LarpkuranShellCycleConn then
        pcall(function() _G.LarpkuranShellCycleConn:Disconnect() end)
        _G.LarpkuranShellCycleConn = nil
    end
    if _G.LarpkuranShellRereConn then
        pcall(_G.LarpkuranShellRereConn)
        _G.LarpkuranShellRereConn = nil
    end
    if _G.LarpkuranRereUI and type(_G.LarpkuranRereUI.Shutdown) == "function" then
        pcall(_G.LarpkuranRereUI.Shutdown)
        _G.LarpkuranRereUI = nil
    end
    showRecoveryFlowUI()
    return
end

if _G.LarpkuranRereUI and type(_G.LarpkuranRereUI.Shutdown) == "function" then
    pcall(_G.LarpkuranRereUI.Shutdown)
    _G.LarpkuranRereUI = nil
end
if _G.LarpkuranShellShutdown then
    pcall(_G.LarpkuranShellShutdown)
    _G.LarpkuranShellShutdown = nil
end
if _G.LarpkuranShellCycleConn then
    pcall(function() _G.LarpkuranShellCycleConn:Disconnect() end)
    _G.LarpkuranShellCycleConn = nil
end
if _G.LarpkuranShellRereConn then
    pcall(_G.LarpkuranShellRereConn)
    _G.LarpkuranShellRereConn = nil
end
local oldIrisRoot = game:GetService("CoreGui"):FindFirstChild("Iris_Root")
if oldIrisRoot then
    pcall(function() oldIrisRoot:Destroy() end)
end

local Rere
do
    local fn = _G.RereCompiledFn
    if not fn then
        local rereSource = _G.RereLibrarySource
        if not rereSource then
            for _, u in ipairs({
                "https://raw.githubusercontent.com/x8lua/Rere/main/src/Rere.lua?nocache=" .. tostring(tick()),
                "https://api.x8stuff.lol/assets/Rere.lua?nocache=" .. tostring(tick())
            }) do
                local ok, res = pcall(game.HttpGet, game, u)
                if ok and type(res) == "string" and #res > 50000 and not res:find("503 Backend") and not res:find("<!DOCTYPE") and not res:find("<html") then
                    rereSource = res
                    _G.RereLibrarySource = res
                    break
                end
            end
        end
        if not rereSource or type(rereSource) ~= "string" or #rereSource < 50000 then
            error("Failed to download Rere UI library: length " .. tostring(rereSource and #rereSource or 0))
        end
        rereSource = rereSource:gsub("return requireModule%(nodes%['Iris'%]%)", "local iris = requireModule(nodes['Iris']); local oldShut = iris.Shutdown; iris.Shutdown = function() if oldShut then pcall(oldShut) end end; return iris")
        rereSource = rereSource:gsub("Vector2%.new%(400, 300%)", "Vector2.new(500, 300)")
        rereSource = rereSource:gsub("ChildContainer%.AutomaticSize = Enum%.AutomaticSize%.XY%s*ChildContainer%.Size = UDim2%.fromOffset%(0, 0%)", "ChildContainer.AutomaticSize = Enum.AutomaticSize.Y; ChildContainer.Size = UDim2.fromScale(1, 0)")
        rereSource = rereSource:gsub("local function openTab%(TabBar: Types%.TabBar, Index: number%)%s*for i, tab in TabBar%.Tabs do%s*tab%.state%.isOpened:set%(i == Index%)%s*end%s*end", "local function openTab(TabBar: Types.TabBar, Index: number) _G.LarpkuranActiveTabIndex = Index for i, tab in TabBar.Tabs do tab.state.isOpened:set(i == Index) end end"); rereSource = rereSource:gsub("table%.insert%(thisWidget%.Tabs, thisChild%)", "table.insert(thisWidget.Tabs, thisChild) task.defer(function() local target = _G.LarpkuranActiveTabIndex or 1 if thisChild.Index == target and thisChild.state and thisChild.state.isOpened then thisChild.state.isOpened:set(true) elseif thisChild.Index ~= target and thisChild.state and thisChild.state.isOpened then thisChild.state.isOpened:set(false) end end)")
        rereSource = rereSource:gsub("if not Container%.Visible then%s*local Layout = Container%.UIListLayout.-OpenTween%.Completed:Once%(function%(.-end%)%s*end%s*Container%.Visible = true", [[TweenService:Create(Tab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Iris._config.TabActiveColor, BackgroundTransparency = Iris._config.TabActiveTransparency }):Play()
        if not Container.Visible then
            local OpenScale = Container:FindFirstChild("OpenScale")
            if not OpenScale then
                OpenScale = Instance.new("UIScale")
                OpenScale.Name = "OpenScale"
                OpenScale.Parent = Container
            end
            OpenScale.Scale = 0.95
            Container.Position = UDim2.fromOffset(0, 8)
            Container.Visible = true
            TweenService:Create(OpenScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            TweenService:Create(Container, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(0, 0) }):Play()
        else
            Container.Position = UDim2.fromOffset(0, 0)
        end]])
        rereSource = rereSource:gsub("Tab%.BackgroundColor3 = Iris%._config%.TabColor%s*Tab%.BackgroundTransparency = Iris%._config%.TabTransparency", [[TweenService:Create(Tab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = Iris._config.TabColor, BackgroundTransparency = Iris._config.TabTransparency }):Play()]])
        rereSource = rereSource:gsub("thisWidget%.state%.index:onChange", "if type(thisWidget.state.index) == 'table' and thisWidget.state.index.onChange then thisWidget.state.index:onChange")
        rereSource = rereSource:gsub("thisWidget%.lastChangedTick = Iris%._cycleTick %+ 1%s*if thisWidget%.state%.isOpened%.value then%s*thisWidget%.state%.isOpened:set%(false%)%s*end%s*end%)", "thisWidget.lastChangedTick = Iris._cycleTick + 1; if thisWidget.state.isOpened and thisWidget.state.isOpened.value then thisWidget.state.isOpened:set(false) end end) end")
        rereSource = rereSource:gsub("PreviewLabel%.Text = if typeof%(stateIndex%) == \"EnumItem\" then stateIndex%.Name else tostring%(stateIndex%)", "local pStr = typeof(stateIndex) == 'EnumItem' and stateIndex.Name or tostring(stateIndex); PreviewLabel.Text = _G.LarpkuranLocalize and _G.LarpkuranLocalize(pStr) or pStr")
        rereSource = rereSource:gsub("if thisWidget%.arguments%.NoCollapse then%s*TitleBar%.CollapseButton%.Visible = false%s*else%s*TitleBar%.CollapseButton%.Visible = true%s*end", "TitleBar.CollapseButton.Visible = not (game:GetService('UserInputService').TouchEnabled or thisWidget.arguments.NoCollapse)")
        rereSource = rereSource:gsub("return Vector2%.new%(input%.Position%.X, input%.Position%.Y%) %- widgets%.MouseOffset", "return Vector2.new(input.Position.X, input.Position.Y)")
        rereSource = rereSource:gsub("return input == activeWindowInput", "return input.UserInputType == Enum.UserInputType.Touch")
        rereSource = rereSource:gsub("local WindowButton = Window%.WindowButton :: TextButton", "local WindowButton = Window and Window:FindFirstChild('WindowButton') :: TextButton; if not WindowButton or not Window.Parent then return end")
        rereSource = rereSource:gsub("local WindowButton = Window%.WindowButton", "local WindowButton = Window and Window:FindFirstChild('WindowButton'); if not WindowButton or not Window.Parent then return end")
        rereSource = rereSource:gsub("Internal%._widgets%[thisWidget%.type%]%.UpdateState%(thisWidget%)", "pcall(Internal._widgets[thisWidget.type].UpdateState, thisWidget)")
        rereSource = rereSource:gsub('if Internal%._stackIndex ~%= 1 then%s*Internal%._stackIndex = 1%s*Internal%._HandleFatalError%(%"Too few calls to Iris%.End%(%)%.%"%)%s*return%s*end', function()
            return [[if Internal._stackIndex ~= 1 then
                local unclosedList = {}
                for idx = 2, Internal._stackIndex do
                    local wid = Internal._IDStack[idx]
                    local w = wid and Internal._VDOM and Internal._VDOM[wid]
                    local origin = Internal._stackOrigins and Internal._stackOrigins[idx]
                    local wType = (w and w.type) or (origin and origin.type) or "Widget"
                    local label = ""
                    if w and w.arguments and type(w.arguments) == "table" then
                        local l = w.arguments.Title or w.arguments.Text or w.arguments[1]
                        if l then label = " (\"" .. tostring(l) .. "\")" end
                    end
                    local trace = (origin and origin.trace) or "No traceback"
                    table.insert(unclosedList, string.format("#%d: %s%s [ID: %s]\nCaller trace:\n%s", idx, wType, label, tostring(wid), trace))
                end
                local errMsg = string.format("Rere auto-recovering from unclosed containers (%d unclosed widget%s):\n%s", Internal._stackIndex - 1, (Internal._stackIndex - 1 > 1 and "s" or ""), table.concat(unclosedList, "\n====================\n"))
                warn(errMsg)
                while Internal._stackIndex > 1 do
                    Internal._IDStack[Internal._stackIndex] = nil
                    if Internal._stackOrigins then Internal._stackOrigins[Internal._stackIndex] = nil end
                    Internal._stackIndex = Internal._stackIndex - 1
                end
                Internal._globalRefreshRequested = true
            end]]
        end)
        rereSource = rereSource:gsub("local dragInstance: TextButton = Window%.WindowButton", "local dragInstance: TextButton? = Window and Window:FindFirstChild('WindowButton') :: any; if not dragInstance then isDragging = false; dragWindow = nil; activeWindowInput = nil; return end")
        rereSource = rereSource:gsub("local resizeInstance: TextButton = Window%.WindowButton", "local resizeInstance: TextButton? = Window and Window:FindFirstChild('WindowButton') :: any; if not resizeInstance then isResizing = false; resizeWindow = nil; activeWindowInput = nil; return end")
        rereSource = rereSource:gsub("thisWidgetInstance%.WindowButton%.AbsoluteSize", "(thisWidgetInstance:FindFirstChild('WindowButton') and thisWidgetInstance:FindFirstChild('WindowButton').AbsoluteSize or Vector2.zero)")
        rereSource = rereSource:gsub("local PopupScreenGui = Iris%._rootInstance:FindFirstChild%(%\"PopupScreenGui%\"%)%s*local TooltipContainer: Frame = PopupScreenGui%.TooltipContainer", "local PopupScreenGui = Iris._rootInstance and Iris._rootInstance:FindFirstChild(\"PopupScreenGui\"); if not PopupScreenGui then return end; local TooltipContainer = PopupScreenGui:FindFirstChild(\"TooltipContainer\"); if not TooltipContainer then return end")
        rereSource = rereSource:gsub("function Internal%._RenderErrorWindow%(%).-end%s*Internal%._cycleCoroutine", function()
            return [[function Internal._RenderErrorWindow()
            local screenWidth = 800
            local screenHeight = 600
            if Internal.parentInstance and Internal.parentInstance:IsA("GuiBase2d") then
                local absSize = Internal.parentInstance.AbsoluteSize
                if absSize.X > 100 and absSize.Y > 100 then
                    screenWidth = absSize.X
                    screenHeight = absSize.Y
                end
            else
                local camera = workspace.CurrentCamera
                if camera and camera.ViewportSize.X > 100 then
                    screenWidth = camera.ViewportSize.X
                    screenHeight = camera.ViewportSize.Y
                end
            end

            if not Internal._errorPosState then
                local winW, winH = 480, 240
                local posX = math.max(20, math.floor((screenWidth - winW) / 2))
                local posY = math.max(20, math.floor((screenHeight - winH) / 2))
                Internal._errorPosState = {
                    ID = "RereFatalErrorPos",
                    value = Vector2.new(posX, posY),
                    lastChangeTick = Internal._cycleTick,
                    ConnectedWidgets = {},
                    ConnectedFunctions = {},
                }
                setmetatable(Internal._errorPosState, Internal.StateClass)
            end

            if not Internal._errorSizeState then
                Internal._errorSizeState = {
                    ID = "RereFatalErrorSize",
                    value = Vector2.new(480, 240),
                    lastChangeTick = Internal._cycleTick,
                    ConnectedWidgets = {},
                    ConnectedFunctions = {},
                }
                setmetatable(Internal._errorSizeState, Internal.StateClass)
            end

            Iris.Window({"Whoops, Rere has crashed...", [Iris.Args.Window.NoClose] = true, [Iris.Args.Window.NoCollapse] = true}, {
                position = Internal._errorPosState,
                size = Internal._errorSizeState,
            })
                Iris.PushConfig({ TextColor = Color3.fromRGB(255, 140, 140) })
                Iris.Text({"(ノ_<。) ...well, this is awkward."})
                Iris.PopConfig()
                Iris.Separator()
                Iris.Text({"Look, it's not you, it's me. I completely folded under pressure."})
                Iris.Text({"Was it a stack overflow? A phantom pointer? Who knows, I'm just a brick right now."})
                Iris.Separator()
                Iris.SameLine()
                    if Iris.Button({"Exit"}).clicked() then
                        Iris.Shutdown()
                    end
                    if Iris.Button({Internal._copyStatusText or "Error log"}).clicked() then
                        local copyFunc = (type(setclipboard) == "function" and setclipboard) or (type(toclipboard) == "function" and toclipboard)
                        if copyFunc then
                            copyFunc(tostring(Internal._errorReason or "No error log"))
                            Internal._copyStatusText = "Error log copied!"
                            task.delay(2, function()
                                Internal._copyStatusText = "Error log"
                            end)
                        end
                    end
                Iris.End()
            Iris.End()
        end

        Internal._cycleCoroutine]]
        end)
        local compileOk, fnOrErr = pcall(loadstring, rereSource)
        if not compileOk or type(fnOrErr) ~= "function" then
            error("Failed to compile Rere UI library: " .. tostring(fnOrErr))
        end
        fn = fnOrErr
        _G.RereCompiledFn = fn
    end
    Rere = fn()
    oldInsert = Rere.Internal._Insert
    Rere.Internal._Insert = function(widgetType, arguments, states)
        local w = oldInsert(widgetType, arguments, states)
        if not isUnlocked and not isRenderingWarning and _G.LarpkuranActiveTabIndex and _G.LarpkuranActiveTabIndex > 1 then
            local lockedWidgets = {
                Button = true, Checkbox = true, SliderNum = true, Combo = true,
                InputText = true, Keybind = true, RadioButton = true
            }
            if lockedWidgets[widgetType] then
                if w.clicked then
                    w.clicked = function()
                        keyStatusMsg = "🔒 Login required on the 🔑 Key tab to use this feature."
                        return false
                    end
                end
                if w.rightClicked then
                    w.rightClicked = function() return false end
                end
                if w.doubleClicked then
                    w.doubleClicked = function() return false end
                end
                if type(w.state) == "table" then
                    for _, s in pairs(w.state) do
                        if type(s) == "table" and type(s.onChange) == "function" then
                            s.onChange = function() end
                        end
                    end
                end
                if w.Instance and w.Instance:IsA("GuiObject") then
                    for _, desc in ipairs(w.Instance:GetDescendants()) do
                        if desc:IsA("GuiButton") then
                            desc.Active = false
                            desc.AutoButtonColor = false
                        elseif desc:IsA("TextBox") then
                            desc.TextEditable = false
                            desc.ClearTextOnFocus = false
                        end
                    end
                    if w.Instance:IsA("GuiButton") then
                        w.Instance.Active = false
                        w.Instance.AutoButtonColor = false
                    elseif w.Instance:IsA("TextBox") then
                        w.Instance.TextEditable = false
                        w.Instance.ClearTextOnFocus = false
                    end
                end
            end
        end
        return w
    end
end

do
    local interval, elapsed, sinceCycle = 1 / 30, 0, 0
    local stopped = false
    local connection
    local shutdown = Rere.Shutdown
    Rere.Init(game:GetService("CoreGui"), false)
    Rere.Shutdown = function(...)
        if stopped then return end
        stopped = true
        if connection then connection:Disconnect(); connection = nil end
        return shutdown(...)
    end
    _G.LarpkuranShellShutdown = Rere.Shutdown
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if stopped then return end
        elapsed += deltaTime
        sinceCycle += deltaTime
        if elapsed + 0.000001 < interval then return end
        local cycleDelta = sinceCycle
        sinceCycle = 0
        elapsed = math.max(0, elapsed - interval) % interval
        Rere.Internal._cycle(cycleDelta)
    end)
    _G.LarpkuranShellCycleConn = connection
end
pcall(Rere.ForceRefresh)

Rere.TooltipElement = function(widget, tooltipText)
    if widget and widget.hovered and widget.hovered() and tooltipText and tooltipText ~= "" then
        Rere.Tooltip({ tooltipText })
    end
    return widget
end

Rere.HelpMarker = function(tooltipText)
    if not tooltipText or tooltipText == "" then return end
    Rere.PushConfig({ TextColor = Color3.fromRGB(160, 160, 160) })
    local t = Rere.Text({ "(?)" })
    Rere.PopConfig()
    if t and t.hovered and t.hovered() then
        Rere.Tooltip({ tooltipText })
    end
    return t
end

do
    local widgets = Rere.Internal._utility
    Rere.Internal.WidgetConstructor("Keybind", {
        hasState = false,
        hasChildren = false,
        Args = {
            ["Title"] = 1,
            ["Key"] = 2,
            ["Capturing"] = 3
        },
        Events = {
            ["clicked"] = {
                ["Init"] = function(thisWidget)
                    thisWidget.lastClickedTick = -1
                    widgets.applyButtonClick(thisWidget.Instance, function()
                        thisWidget.lastClickedTick = Rere.Internal._cycleTick + 1
                    end)
                    local btn = thisWidget.Instance:FindFirstChild("KeyButton")
                    if btn then
                        widgets.applyButtonClick(btn, function()
                            thisWidget.lastClickedTick = Rere.Internal._cycleTick + 1
                        end)
                    end
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastClickedTick == Rere.Internal._cycleTick
                end
            }
        },
        Generate = function(thisWidget)
            local frame = Instance.new("TextButton")
            frame.Name = "Iris_Keybind"
            frame.Size = UDim2.new(0, 314, 0, 26)
            frame.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
            frame.BackgroundTransparency = 0.25
            frame.BorderSizePixel = 0
            frame.AutoButtonColor = false
            frame.Text = ""

            local corner = Instance.new("UICorner", frame)
            corner.CornerRadius = UDim.new(0, 5)

            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = Color3.fromRGB(38, 40, 50)
            stroke.Thickness = 1
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local padding = Instance.new("UIPadding", frame)
            padding.PaddingLeft = UDim.new(0, 10)
            padding.PaddingRight = UDim.new(0, 6)
            padding.PaddingTop = UDim.new(0, 2)
            padding.PaddingBottom = UDim.new(0, 2)

            local label = Instance.new("TextLabel", frame)
            label.Name = "TitleLabel"
            label.Size = UDim2.new(1, -105, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(220, 222, 232)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 12

            local keyBtn = Instance.new("TextButton", frame)
            keyBtn.Name = "KeyButton"
            keyBtn.Size = UDim2.new(0, 95, 1, 0)
            keyBtn.AnchorPoint = Vector2.new(1, 0.5)
            keyBtn.Position = UDim2.new(1, 0, 0.5, 0)
            keyBtn.AutoButtonColor = false
            keyBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
            keyBtn.BorderSizePixel = 0
            keyBtn.TextColor3 = Color3.fromRGB(130, 185, 255)
            keyBtn.Font = Enum.Font.RobotoMono
            keyBtn.TextSize = 11

            local btnCorner = Instance.new("UICorner", keyBtn)
            btnCorner.CornerRadius = UDim.new(0, 4)

            local btnStroke = Instance.new("UIStroke", keyBtn)
            btnStroke.Color = Color3.fromRGB(48, 52, 68)
            btnStroke.Thickness = 1

            widgets.applyMouseEnter(frame, function()
                local args = thisWidget.arguments or {}
                local isCap = args.Capturing == true or args[3] == true
                if not isCap then
                    frame.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
                    stroke.Color = Color3.fromRGB(55, 60, 75)
                    keyBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 58)
                    btnStroke.Color = Color3.fromRGB(75, 95, 130)
                end
            end)

            widgets.applyMouseLeave(frame, function()
                local args = thisWidget.arguments or {}
                local isCap = args.Capturing == true or args[3] == true
                if not isCap then
                    frame.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
                    stroke.Color = Color3.fromRGB(38, 40, 50)
                    keyBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
                    btnStroke.Color = Color3.fromRGB(48, 52, 68)
                end
            end)

            return frame
        end,
        Update = function(thisWidget)
            local frame = thisWidget.Instance
            local args = thisWidget.arguments or {}
            local title = tostring(args.Title or args[1] or "")
            local key = tostring(args.Key or args[2] or "None")
            local isCap = args.Capturing == true or args[3] == true

            local label = frame.TitleLabel
            local keyBtn = frame.KeyButton
            local stroke = frame.UIStroke
            local btnStroke = keyBtn.UIStroke

            label.Text = title

            if isCap then
                stroke.Color = Color3.fromRGB(0, 160, 240)
                frame.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
                keyBtn.Text = "[ Press key ]"
                keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                keyBtn.BackgroundColor3 = Color3.fromRGB(0, 110, 210)
                btnStroke.Color = Color3.fromRGB(0, 200, 255)
            else
                stroke.Color = Color3.fromRGB(38, 40, 50)
                frame.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
                keyBtn.Text = "[" .. key .. "]"
                keyBtn.TextColor3 = Color3.fromRGB(130, 185, 255)
                keyBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
                btnStroke.Color = Color3.fromRGB(48, 52, 68)
            end
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end
    })

    Rere.Keybind = function(arguments, states)
        return Rere.Internal._Insert("Keybind", arguments, states)
    end

    Rere.Internal.WidgetConstructor("CustomKeyPanel", {
        hasState = false,
        hasChildren = false,
        Args = {},
        Events = {},
        Generate = function(thisWidget)
            local container = Instance.new("Frame")
            container.Name = "Iris_CustomKeyPanel"
            container.Size = UDim2.new(1, 0, 0, 345)
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0

            local scroll = Instance.new("ScrollingFrame", container)
            scroll.Name = "Scroll"
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.ScrollBarThickness = 3
            scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 72, 98)
            scroll.ScrollBarImageTransparency = 0.2
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.CanvasSize = UDim2.fromOffset(0, 0)
            scroll.ClipsDescendants = true

            local list = Instance.new("UIListLayout", scroll)
            list.FillDirection = Enum.FillDirection.Vertical
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Padding = UDim.new(0, 7)

            local pad = Instance.new("UIPadding", scroll)
            pad.PaddingLeft = UDim.new(0, 4)
            pad.PaddingRight = UDim.new(0, 8)
            pad.PaddingTop = UDim.new(0, 4)
            pad.PaddingBottom = UDim.new(0, 8)

            local headerCard = Instance.new("Frame", scroll)
            headerCard.Name = "HeaderCard"
            headerCard.LayoutOrder = 1
            headerCard.Size = UDim2.new(1, 0, 0, 44)
            headerCard.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
            headerCard.BorderSizePixel = 0
            Instance.new("UICorner", headerCard).CornerRadius = UDim.new(0, 6)
            local hStroke = Instance.new("UIStroke", headerCard)
            hStroke.Color = Color3.fromRGB(38, 42, 58)
            hStroke.Thickness = 1
            local hPad = Instance.new("UIPadding", headerCard)
            hPad.PaddingLeft = UDim.new(0, 14)
            hPad.PaddingRight = UDim.new(0, 14)
            hPad.PaddingTop = UDim.new(0, 8)
            hPad.PaddingBottom = UDim.new(0, 8)

            local titleLabel = Instance.new("TextLabel", headerCard)
            titleLabel.Name = "Title"
            titleLabel.Size = UDim2.new(1, 0, 1, 0)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "LARPKURAN"
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 20
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.TextYAlignment = Enum.TextYAlignment.Center

            local keyCard = Instance.new("Frame", scroll)
            keyCard.Name = "KeyCard"
            keyCard.LayoutOrder = 2
            keyCard.Size = UDim2.new(1, 0, 0, 114)
            keyCard.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
            keyCard.BorderSizePixel = 0
            Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 6)
            local kStroke = Instance.new("UIStroke", keyCard)
            kStroke.Color = Color3.fromRGB(38, 42, 58)
            kStroke.Thickness = 1
            local kPad = Instance.new("UIPadding", keyCard)
            kPad.PaddingLeft = UDim.new(0, 12)
            kPad.PaddingRight = UDim.new(0, 12)
            kPad.PaddingTop = UDim.new(0, 8)
            kPad.PaddingBottom = UDim.new(0, 8)
            local kList = Instance.new("UIListLayout", keyCard)
            kList.FillDirection = Enum.FillDirection.Vertical
            kList.SortOrder = Enum.SortOrder.LayoutOrder
            kList.Padding = UDim.new(0, 7)

            local kHeader = Instance.new("TextLabel", keyCard)
            kHeader.Name = "Header"
            kHeader.Size = UDim2.new(1, 0, 0, 15)
            kHeader.BackgroundTransparency = 1
            kHeader.Text = "🔑  LICENSE KEY LOGIN"
            kHeader.Font = Enum.Font.GothamBold
            kHeader.TextSize = 12
            kHeader.TextColor3 = Color3.fromRGB(210, 220, 245)
            kHeader.TextXAlignment = Enum.TextXAlignment.Left

            local inContainer = Instance.new("Frame", keyCard)
            inContainer.Name = "InputContainer"
            inContainer.Size = UDim2.new(1, 0, 0, 28)
            inContainer.BackgroundColor3 = Color3.fromRGB(13, 14, 19)
            inContainer.BorderSizePixel = 0
            Instance.new("UICorner", inContainer).CornerRadius = UDim.new(0, 4)
            local inStroke = Instance.new("UIStroke", inContainer)
            inStroke.Color = Color3.fromRGB(44, 48, 66)
            inStroke.Thickness = 1
            local inPad = Instance.new("UIPadding", inContainer)
            inPad.PaddingLeft = UDim.new(0, 8)
            inPad.PaddingRight = UDim.new(0, 8)

            local textBox = Instance.new("TextBox", inContainer)
            textBox.Name = "KeyBox"
            textBox.Size = UDim2.new(1, 0, 1, 0)
            textBox.BackgroundTransparency = 1
            textBox.BorderSizePixel = 0
            textBox.Text = cachedKey
            textBox.PlaceholderText = "Paste your license key here..."
            textBox.PlaceholderColor3 = Color3.fromRGB(100, 108, 130)
            textBox.TextColor3 = Color3.fromRGB(220, 230, 255)
            textBox.Font = Enum.Font.RobotoMono
            textBox.TextSize = 12
            textBox.ClearTextOnFocus = false
            textBox.TextXAlignment = Enum.TextXAlignment.Left

            textBox.Focused:Connect(function()
                inStroke.Color = Color3.fromRGB(45, 120, 255)
            end)
            textBox.FocusLost:Connect(function(enterPressed)
                inStroke.Color = Color3.fromRGB(44, 48, 66)
                cachedKey = textBox.Text
                if enterPressed and #cachedKey > 0 then
                    task.spawn(function()
                        activateKey(cachedKey)
                    end)
                end
            end)

            local kActions = Instance.new("Frame", keyCard)
            kActions.Name = "Actions"
            kActions.Size = UDim2.new(1, 0, 0, 26)
            kActions.BackgroundTransparency = 1
            local kaList = Instance.new("UIListLayout", kActions)
            kaList.FillDirection = Enum.FillDirection.Horizontal
            kaList.SortOrder = Enum.SortOrder.LayoutOrder
            kaList.Padding = UDim.new(0, 6)

            local actBtn = Instance.new("TextButton", kActions)
            actBtn.Name = "ActivateButton"
            actBtn.Size = UDim2.new(0, 125, 1, 0)
            actBtn.BackgroundColor3 = Color3.fromRGB(30, 95, 220)
            actBtn.BorderSizePixel = 0
            actBtn.Text = "⚡ Activate Key"
            actBtn.Font = Enum.Font.GothamBold
            actBtn.TextSize = 11
            actBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            actBtn.AutoButtonColor = false
            Instance.new("UICorner", actBtn).CornerRadius = UDim.new(0, 4)
            local actStroke = Instance.new("UIStroke", actBtn)
            actStroke.Color = Color3.fromRGB(55, 135, 255)
            actStroke.Thickness = 1

            actBtn.MouseEnter:Connect(function()
                actBtn.BackgroundColor3 = Color3.fromRGB(45, 115, 245)
            end)
            actBtn.MouseLeave:Connect(function()
                actBtn.BackgroundColor3 = Color3.fromRGB(30, 95, 220)
            end)
            actBtn.MouseButton1Click:Connect(function()
                playClickSound()
                cachedKey = textBox.Text
                task.spawn(function()
                    activateKey(cachedKey)
                end)
            end)

            local getBtn = Instance.new("TextButton", kActions)
            getBtn.Name = "GetButton"
            getBtn.Size = UDim2.new(0, 135, 1, 0)
            getBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
            getBtn.BorderSizePixel = 0
            getBtn.Text = "Get Key (DISCORD)"
            getBtn.Font = Enum.Font.GothamMedium
            getBtn.TextSize = 11
            getBtn.TextColor3 = Color3.fromRGB(175, 190, 225)
            getBtn.AutoButtonColor = false
            Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0, 4)
            local getStroke = Instance.new("UIStroke", getBtn)
            getStroke.Color = Color3.fromRGB(45, 50, 68)
            getStroke.Thickness = 1

            getBtn.MouseEnter:Connect(function()
                getBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
            end)
            getBtn.MouseLeave:Connect(function()
                getBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
            end)
            getBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                if type(setclip) == "function" then
                    pcall(setclip, "https://discord.gg/tKzhr5FecY")
                    keyFeedbackMsg = "📋 Copied: https://discord.gg/tKzhr5FecY"
                    keyFeedbackColor = Color3.fromRGB(140, 180, 255)
                    keyStatusMsg = "Copied link: https://discord.gg/tKzhr5FecY"
                end
            end)

            local remBtn = Instance.new("TextButton", kActions)
            remBtn.Name = "RememberButton"
            remBtn.Size = UDim2.new(0, 130, 1, 0)
            remBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            remBtn.BorderSizePixel = 0
            remBtn.Text = rememberKeyEnabled and "[✓] Remember Key" or "[  ] Remember Key"
            remBtn.Font = Enum.Font.GothamMedium
            remBtn.TextSize = 11
            remBtn.TextColor3 = Color3.fromRGB(145, 160, 190)
            remBtn.AutoButtonColor = false
            Instance.new("UICorner", remBtn).CornerRadius = UDim.new(0, 4)
            local remStroke = Instance.new("UIStroke", remBtn)
            remStroke.Color = Color3.fromRGB(40, 44, 60)
            remStroke.Thickness = 1

            remBtn.MouseEnter:Connect(function()
                remBtn.BackgroundColor3 = Color3.fromRGB(32, 35, 48)
            end)
            remBtn.MouseLeave:Connect(function()
                remBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            end)
            remBtn.MouseButton1Click:Connect(function()
                playClickSound()
                rememberKeyEnabled = not rememberKeyEnabled
                remBtn.Text = rememberKeyEnabled and "[✓] Remember Key" or "[  ] Remember Key"
            end)

            local keyFeedback = Instance.new("TextLabel", keyCard)
            keyFeedback.Name = "KeyFeedback"
            keyFeedback.Size = UDim2.new(1, 0, 0, 16)
            keyFeedback.BackgroundTransparency = 1
            keyFeedback.Text = keyFeedbackMsg
            keyFeedback.Font = Enum.Font.RobotoMono
            keyFeedback.TextSize = 11
            keyFeedback.TextColor3 = keyFeedbackColor
            keyFeedback.TextXAlignment = Enum.TextXAlignment.Left
            keyFeedback.TextTruncate = Enum.TextTruncate.AtEnd

            local orDivider = Instance.new("Frame", scroll)
            orDivider.Name = "OrDivider"
            orDivider.LayoutOrder = 3
            orDivider.Size = UDim2.new(1, 0, 0, 16)
            orDivider.BackgroundTransparency = 1

            local orLineLeft = Instance.new("Frame", orDivider)
            orLineLeft.Name = "LineLeft"
            orLineLeft.Size = UDim2.new(0.5, -24, 0, 1)
            orLineLeft.Position = UDim2.new(0, 4, 0.5, 0)
            orLineLeft.BackgroundColor3 = Color3.fromRGB(38, 42, 58)
            orLineLeft.BorderSizePixel = 0

            local orLabel = Instance.new("TextLabel", orDivider)
            orLabel.Name = "Label"
            orLabel.Size = UDim2.new(0, 36, 1, 0)
            orLabel.Position = UDim2.new(0.5, -18, 0, 0)
            orLabel.BackgroundTransparency = 1
            orLabel.Text = "OR"
            orLabel.Font = Enum.Font.GothamBold
            orLabel.TextSize = 10
            orLabel.TextColor3 = Color3.fromRGB(130, 140, 170)
            orLabel.TextXAlignment = Enum.TextXAlignment.Center

            local orLineRight = Instance.new("Frame", orDivider)
            orLineRight.Name = "LineRight"
            orLineRight.Size = UDim2.new(0.5, -24, 0, 1)
            orLineRight.Position = UDim2.new(1, -4, 0.5, 0)
            orLineRight.AnchorPoint = Vector2.new(1, 0)
            orLineRight.BackgroundColor3 = Color3.fromRGB(38, 42, 58)
            orLineRight.BorderSizePixel = 0

            local dCard = Instance.new("Frame", scroll)
            dCard.Name = "DiscordCard"
            dCard.LayoutOrder = 4
            dCard.Size = UDim2.new(1, 0, 0, 114)
            dCard.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
            dCard.BorderSizePixel = 0
            Instance.new("UICorner", dCard).CornerRadius = UDim.new(0, 6)
            local dStroke = Instance.new("UIStroke", dCard)
            dStroke.Color = Color3.fromRGB(38, 42, 58)
            dStroke.Thickness = 1
            local dPad = Instance.new("UIPadding", dCard)
            dPad.PaddingLeft = UDim.new(0, 12)
            dPad.PaddingRight = UDim.new(0, 12)
            dPad.PaddingTop = UDim.new(0, 8)
            dPad.PaddingBottom = UDim.new(0, 8)
            local dList = Instance.new("UIListLayout", dCard)
            dList.FillDirection = Enum.FillDirection.Vertical
            dList.SortOrder = Enum.SortOrder.LayoutOrder
            dList.Padding = UDim.new(0, 6)

            local dHeader = Instance.new("TextLabel", dCard)
            dHeader.Name = "Header"
            dHeader.Size = UDim2.new(1, 0, 0, 15)
            dHeader.BackgroundTransparency = 1
            dHeader.Text = "💬  DISCORD ACCOUNT LOGIN"
            dHeader.Font = Enum.Font.GothamBold
            dHeader.TextSize = 12
            dHeader.TextColor3 = Color3.fromRGB(150, 175, 255)
            dHeader.TextXAlignment = Enum.TextXAlignment.Left

            local dSub = Instance.new("TextLabel", dCard)
            dSub.Name = "SubText"
            dSub.Size = UDim2.new(1, 0, 0, 26)
            dSub.BackgroundTransparency = 1
            dSub.TextWrapped = true
            dSub.Text = "Must be in our Discord server (discord.gg/tKzhr5FecY)\nInstant keyless access for server members"
            dSub.Font = Enum.Font.GothamMedium
            dSub.TextSize = 10
            dSub.TextColor3 = Color3.fromRGB(245, 185, 100)
            dSub.TextXAlignment = Enum.TextXAlignment.Left

            local dActions = Instance.new("Frame", dCard)
            dActions.Name = "Actions"
            dActions.Size = UDim2.new(1, 0, 0, 26)
            dActions.BackgroundTransparency = 1
            local daList = Instance.new("UIListLayout", dActions)
            daList.FillDirection = Enum.FillDirection.Horizontal
            daList.SortOrder = Enum.SortOrder.LayoutOrder
            daList.Padding = UDim.new(0, 6)

            local dLoginBtn = Instance.new("TextButton", dActions)
            dLoginBtn.Name = "DiscordLoginButton"
            dLoginBtn.Size = UDim2.new(0, 165, 1, 0)
            dLoginBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            dLoginBtn.BorderSizePixel = 0
            dLoginBtn.Text = "🌐 Sign in with Discord"
            dLoginBtn.Font = Enum.Font.GothamBold
            dLoginBtn.TextSize = 11
            dLoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            dLoginBtn.AutoButtonColor = false
            Instance.new("UICorner", dLoginBtn).CornerRadius = UDim.new(0, 4)
            local dlStroke = Instance.new("UIStroke", dLoginBtn)
            dlStroke.Color = Color3.fromRGB(115, 128, 255)
            dlStroke.Thickness = 1

            dLoginBtn.MouseEnter:Connect(function()
                dLoginBtn.BackgroundColor3 = Color3.fromRGB(105, 118, 255)
            end)
            dLoginBtn.MouseLeave:Connect(function()
                dLoginBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            end)
            dLoginBtn.MouseButton1Click:Connect(function()
                playClickSound()
                requestDiscordLogin()
            end)

            local copyLinkBtn = Instance.new("TextButton", dActions)
            copyLinkBtn.Name = "CopyLinkButton"
            copyLinkBtn.Size = UDim2.new(0, 105, 1, 0)
            copyLinkBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
            copyLinkBtn.BorderSizePixel = 0
            copyLinkBtn.Text = "📋 Copy Link"
            copyLinkBtn.Font = Enum.Font.GothamMedium
            copyLinkBtn.TextSize = 11
            copyLinkBtn.TextColor3 = Color3.fromRGB(175, 190, 225)
            copyLinkBtn.AutoButtonColor = false
            Instance.new("UICorner", copyLinkBtn).CornerRadius = UDim.new(0, 4)
            local clStroke = Instance.new("UIStroke", copyLinkBtn)
            clStroke.Color = Color3.fromRGB(45, 50, 68)
            clStroke.Thickness = 1

            copyLinkBtn.MouseEnter:Connect(function()
                copyLinkBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 52)
            end)
            copyLinkBtn.MouseLeave:Connect(function()
                copyLinkBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
            end)
            copyLinkBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                if type(setclip) == "function" then
                    pcall(setclip, stagedAuthLink)
                end
                keyStatusMsg = "Copied Discord auth URL to clipboard."
            end)

            local cancelBtn = Instance.new("TextButton", dActions)
            cancelBtn.Name = "CancelButton"
            cancelBtn.Size = UDim2.new(0, 75, 1, 0)
            cancelBtn.BackgroundColor3 = Color3.fromRGB(38, 22, 26)
            cancelBtn.BorderSizePixel = 0
            cancelBtn.Text = "✕ Cancel"
            cancelBtn.Font = Enum.Font.GothamMedium
            cancelBtn.TextSize = 11
            cancelBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
            cancelBtn.AutoButtonColor = false
            Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 4)
            local cnStroke = Instance.new("UIStroke", cancelBtn)
            cnStroke.Color = Color3.fromRGB(75, 35, 42)
            cnStroke.Thickness = 1

            cancelBtn.MouseEnter:Connect(function()
                cancelBtn.BackgroundColor3 = Color3.fromRGB(52, 26, 32)
            end)
            cancelBtn.MouseLeave:Connect(function()
                cancelBtn.BackgroundColor3 = Color3.fromRGB(38, 22, 26)
            end)
            cancelBtn.MouseButton1Click:Connect(function()
                playClickSound()
                discordPending = false
                keyStatusMsg = "Discord login request cancelled."
            end)

            local dStatusNotice = Instance.new("TextLabel", dCard)
            dStatusNotice.Name = "Notice"
            dStatusNotice.Size = UDim2.new(1, 0, 0, 14)
            dStatusNotice.BackgroundTransparency = 1
            dStatusNotice.Text = "Status: Ready - Must be in Discord server (discord.gg/tKzhr5FecY)"
            dStatusNotice.Font = Enum.Font.GothamMedium
            dStatusNotice.TextSize = 10
            dStatusNotice.TextColor3 = Color3.fromRGB(140, 180, 255)
            dStatusNotice.TextXAlignment = Enum.TextXAlignment.Left

            local infoCard = Instance.new("Frame", scroll)
            infoCard.Name = "InfoCard"
            infoCard.LayoutOrder = 5
            infoCard.Size = UDim2.new(1, 0, 0, 56)
            infoCard.BackgroundColor3 = Color3.fromRGB(16, 18, 25)
            infoCard.BorderSizePixel = 0
            Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)
            local iStroke = Instance.new("UIStroke", infoCard)
            iStroke.Color = Color3.fromRGB(34, 38, 52)
            iStroke.Thickness = 1
            local iPad = Instance.new("UIPadding", infoCard)
            iPad.PaddingLeft = UDim.new(0, 12)
            iPad.PaddingRight = UDim.new(0, 12)
            iPad.PaddingTop = UDim.new(0, 7)
            iPad.PaddingBottom = UDim.new(0, 7)
            local iList = Instance.new("UIListLayout", infoCard)
            iList.FillDirection = Enum.FillDirection.Vertical
            iList.SortOrder = Enum.SortOrder.LayoutOrder
            iList.Padding = UDim.new(0, 4)

            local row1 = Instance.new("TextLabel", infoCard)
            row1.Name = "Row1"
            row1.Size = UDim2.new(1, 0, 0, 16)
            row1.BackgroundTransparency = 1
            row1.Text = "Roblox: @" .. tostring(LocalPlayer and LocalPlayer.Name or "Unknown") .. " (" .. tostring(LocalPlayer and LocalPlayer.UserId or 0) .. ")  |  Discord: Not Linked"
            row1.Font = Enum.Font.GothamMedium
            row1.TextSize = 11
            row1.TextColor3 = Color3.fromRGB(165, 175, 200)
            row1.TextXAlignment = Enum.TextXAlignment.Left

            local row2 = Instance.new("TextLabel", infoCard)
            row2.Name = "Row2"
            row2.Size = UDim2.new(1, 0, 0, 14)
            row2.BackgroundTransparency = 1
            row2.Text = "Tier: Free Preview (Shell Mode)  |  Expiry: N/A  |  Stand Capacity: up to 10"
            row2.Font = Enum.Font.Gotham
            row2.TextSize = 10
            row2.TextColor3 = Color3.fromRGB(125, 135, 155)
            row2.TextXAlignment = Enum.TextXAlignment.Left

            local fActions = Instance.new("Frame", scroll)
            fActions.Name = "FooterActions"
            fActions.LayoutOrder = 5
            fActions.Size = UDim2.new(1, 0, 0, 26)
            fActions.BackgroundTransparency = 1
            local faList = Instance.new("UIListLayout", fActions)
            faList.FillDirection = Enum.FillDirection.Horizontal
            faList.SortOrder = Enum.SortOrder.LayoutOrder
            faList.Padding = UDim.new(0, 6)

            local ticketBtn = Instance.new("TextButton", fActions)
            ticketBtn.Name = "TicketButton"
            ticketBtn.Size = UDim2.new(0, 130, 1, 0)
            ticketBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            ticketBtn.BorderSizePixel = 0
            ticketBtn.Text = "🎫 Support Ticket"
            ticketBtn.Font = Enum.Font.GothamMedium
            ticketBtn.TextSize = 11
            ticketBtn.TextColor3 = Color3.fromRGB(165, 180, 210)
            ticketBtn.AutoButtonColor = false
            Instance.new("UICorner", ticketBtn).CornerRadius = UDim.new(0, 4)
            local tStroke = Instance.new("UIStroke", ticketBtn)
            tStroke.Color = Color3.fromRGB(42, 46, 62)
            tStroke.Thickness = 1

            ticketBtn.MouseEnter:Connect(function()
                ticketBtn.BackgroundColor3 = Color3.fromRGB(32, 35, 48)
            end)
            ticketBtn.MouseLeave:Connect(function()
                ticketBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            end)
            ticketBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                if type(setclip) == "function" then
                    pcall(setclip, "https://discord.gg/tKzhr5FecY")
                end
                keyStatusMsg = "Copied Ticket URL: https://discord.gg/tKzhr5FecY"
            end)

            local rejoinBtn = Instance.new("TextButton", fActions)
            rejoinBtn.Name = "RejoinButton"
            rejoinBtn.Size = UDim2.new(0, 130, 1, 0)
            rejoinBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            rejoinBtn.BorderSizePixel = 0
            rejoinBtn.Text = "💬 Rejoin Discord"
            rejoinBtn.Font = Enum.Font.GothamMedium
            rejoinBtn.TextSize = 11
            rejoinBtn.TextColor3 = Color3.fromRGB(165, 180, 210)
            rejoinBtn.AutoButtonColor = false
            Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 4)
            local rjStroke = Instance.new("UIStroke", rejoinBtn)
            rjStroke.Color = Color3.fromRGB(42, 46, 62)
            rjStroke.Thickness = 1

            rejoinBtn.MouseEnter:Connect(function()
                rejoinBtn.BackgroundColor3 = Color3.fromRGB(32, 35, 48)
            end)
            rejoinBtn.MouseLeave:Connect(function()
                rejoinBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
            end)
            rejoinBtn.MouseButton1Click:Connect(function()
                playClickSound()
                local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                if type(setclip) == "function" then
                    pcall(setclip, "https://discord.gg/tKzhr5FecY")
                end
                keyStatusMsg = "Copied Discord Invite: https://discord.gg/tKzhr5FecY"
            end)

            local logoutBtn = Instance.new("TextButton", fActions)
            logoutBtn.Name = "LogoutButton"
            logoutBtn.Size = UDim2.new(0, 80, 1, 0)
            logoutBtn.BackgroundColor3 = Color3.fromRGB(32, 22, 26)
            logoutBtn.BorderSizePixel = 0
            logoutBtn.Text = "🚪 Logout"
            logoutBtn.Font = Enum.Font.GothamMedium
            logoutBtn.TextSize = 11
            logoutBtn.TextColor3 = Color3.fromRGB(220, 120, 120)
            logoutBtn.AutoButtonColor = false
            Instance.new("UICorner", logoutBtn).CornerRadius = UDim.new(0, 4)
            local loStroke = Instance.new("UIStroke", logoutBtn)
            loStroke.Color = Color3.fromRGB(60, 36, 42)
            loStroke.Thickness = 1

            logoutBtn.MouseEnter:Connect(function()
                logoutBtn.BackgroundColor3 = Color3.fromRGB(46, 26, 32)
            end)
            logoutBtn.MouseLeave:Connect(function()
                logoutBtn.BackgroundColor3 = Color3.fromRGB(32, 22, 26)
            end)
            logoutBtn.MouseButton1Click:Connect(function()
                playClickSound()
                logoutSession()
            end)

            local statusLabel = Instance.new("TextLabel", scroll)
            statusLabel.Name = "StatusFeedback"
            statusLabel.LayoutOrder = 6
            statusLabel.Size = UDim2.new(1, 0, 0, 16)
            statusLabel.BackgroundTransparency = 1
            statusLabel.Text = keyStatusMsg
            statusLabel.Font = Enum.Font.GothamMedium
            statusLabel.TextSize = 11
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            statusLabel.TextXAlignment = Enum.TextXAlignment.Left

            local renderConn
            renderConn = RunService.Heartbeat:Connect(function()
                if not container.Parent then
                    if renderConn then renderConn:Disconnect(); renderConn = nil end
                    return
                end
                if isUnlocked and _G.LarpkuranForceLock ~= true then
                    local dUser = (cachedAccount and cachedAccount.discordUsername) or (cachedKey ~= "" and "Key License" or "Authorized")
                    local planStr = (cachedAccount and cachedAccount.plan) or "Permanent License"
                    local expStr = (cachedAccount and cachedAccount.expiresAt and cachedAccount.expiresAt:sub(1,10)) or "Lifetime"
                    row1.Text = "Roblox: @" .. tostring(LocalPlayer and LocalPlayer.Name or "Unknown") .. " (" .. tostring(LocalPlayer and LocalPlayer.UserId or 0) .. ")  |  Discord: @" .. tostring(dUser)
                    row2.Text = "Tier: " .. tostring(planStr) .. "  |  Expiry: " .. tostring(expStr) .. "  |  Roblox accounts: Unlimited per device"
                else
                    row1.Text = "Roblox: @" .. tostring(LocalPlayer and LocalPlayer.Name or "Unknown") .. " (" .. tostring(LocalPlayer and LocalPlayer.UserId or 0) .. ")  |  Discord: Not Linked"
                    row2.Text = "Tier: Free Preview (Shell Mode)  |  Expiry: N/A  |  Stand Capacity: up to 10"
                end

                if discordPending then
                    pollDiscordLogin()
                    local remaining = math.max(0, math.ceil(discordExpiryTime - os.clock()))
                    if remaining > 0 then
                        dStatusNotice.Text = string.format("⏳ Waiting for browser OAuth authorization... (%d s left)", remaining)
                        dStatusNotice.TextColor3 = Color3.fromRGB(255, 210, 100)
                    else
                        discordPending = false
                        dStatusNotice.Text = "Status: Discord login link expired. Click sign in again."
                        dStatusNotice.TextColor3 = Color3.fromRGB(255, 120, 120)
                    end
                else
                    if isUnlocked and cachedAccount and cachedAccount.discordUsername then
                        dStatusNotice.Text = "Status: Authorized as " .. tostring(cachedAccount.discordUsername)
                        dStatusNotice.TextColor3 = Color3.fromRGB(74, 222, 128)
                    else
                        dStatusNotice.Text = "Status: Ready - Must be in Discord server (discord.gg/tKzhr5FecY)"
                        dStatusNotice.TextColor3 = Color3.fromRGB(140, 180, 255)
                    end
                end

                if statusLabel.Text ~= keyStatusMsg then
                    statusLabel.Text = keyStatusMsg
                end
                if keyFeedback.Text ~= keyFeedbackMsg then
                    keyFeedback.Text = keyFeedbackMsg
                    keyFeedback.TextColor3 = keyFeedbackColor
                end
            end)

            thisWidget.renderConn = renderConn
            return container
        end,
        Update = function(thisWidget) end,
        Discard = function(thisWidget)
            if thisWidget.renderConn then
                thisWidget.renderConn:Disconnect()
                thisWidget.renderConn = nil
            end
            thisWidget.Instance:Destroy()
        end
    })

    Rere.CustomKeyPanel = function(arguments, states)
        return Rere.Internal._Insert("CustomKeyPanel", arguments, states)
    end
end


local controller = {}
controller.LarpkuranOpenedState = Rere.State(true)
controller.LarpkuranSizeState = Rere.State(Vector2.new(530, 420))
local detectedExecName = ""
local detectFn = (type(identifyexecutor) == "function" and identifyexecutor) or (type(getexecutorname) == "function" and getexecutorname) or (type(getgenv) == "function" and (getgenv().identifyexecutor or getgenv().getexecutorname))
if type(detectFn) == "function" then
    local ok, res = pcall(detectFn)
    if ok and type(res) == "string" then
        detectedExecName = res:lower()
    end
end
local isUnsupportedExecutor = (detectedExecName:find("xeno", 1, true) ~= nil) or (detectedExecName:find("solara", 1, true) ~= nil)
controller.UnsupportedExecutor = isUnsupportedExecutor

local enabled = Rere.State(false)
local holdTime = Rere.State(0.08)
local parryChance = Rere.State(100)
local parryLead = Rere.State(0.06)
local timingScale = Rere.State(1.0)
local radius = Rere.State(15)
local autoFaceEnabled = Rere.State(false)
local autoParryKey = Rere.State("PageUp")
local m1PriorityEnabled = Rere.State(false)
local dontParryWhenNotFacing = Rere.State(false)

controller.PingCompensationScaleState = Rere.State(100)
controller.PerfectParryState = Rere.State(true)
controller.HeavyAttackParryState = Rere.State(true)
controller.AdaptiveTuningState = Rere.State(false)
controller.AdaptiveAutoState = Rere.State(false)
controller.AdaptiveM1OffsetMsState = Rere.State(0)
controller.AdaptiveM2OffsetMsState = Rere.State(0)
controller.CurrentPing = 45
controller.CalibratedPing = 45
controller.CalibratedOffsetMs = 0
controller.CalibrateCurrentMs = function() end
controller.ResetAdaptiveTuning = function() end

controller.ParryOnlyTargetState = Rere.State(false)
controller.BlockM1UntilParryState = Rere.State(false)
controller.HoldThroughComboState = Rere.State(false)
controller.FallbackSafetyBlockState = Rere.State(false)
controller.FallbackBlockDurationState = Rere.State(0.45)
controller.FallbackBlockRangeState = Rere.State(12)
controller.LegitBlockAnimationState = Rere.State(false)
controller.SkipFirstHitState = Rere.State(false)
controller.DisableBlockMidDashState = Rere.State(false)
controller.ParryState = "Idle"
controller.LastState = "None"
controller.ParrySuccesses = 0
controller.TriggerCount = 0

controller.AttackDesyncStates = {
    Enabled = Rere.State(false),
    Key = Rere.State("None"),
    Delay = Rere.State(120),
    ApplyM1 = Rere.State(false),
    ApplyM2 = Rere.State(false),
}

controller.TrackingStates = {
    Mode = Rere.State(1),
    RapidSwitch = Rere.State(false),
    ImpactSnap = Rere.State(false),
    Smoothness = Rere.State(0.2),
}
controller.FaceAtEnabledState = Rere.State(false)
controller.TargetMarkerEnabledState = Rere.State(false)
controller.FaceAtToggleKey = "None"
controller.FaceTargetKey = "None"
controller.FaceAtTarget = nil
controller.SelectNearestFaceAtTarget = function() end
controller.SetFaceAtTarget = function() end

controller.MagnifyEnabledState = Rere.State(false)
controller.MagnifySpeedState = Rere.State(2)
controller.MagnifyMaxDistState = Rere.State(35)

controller.BoxingStates = {
    Counter = Rere.State(false),
    Reach = Rere.State(5),
}
controller.BoxingKeyState = Rere.State("None")
controller.StyleExtensionsKeyState = Rere.State("None")

controller.DodgeStates = {
    Enabled = Rere.State(false),
    Chance = Rere.State(100),
    Key = Rere.State("None"),
    Mode = Rere.State(1),
    AggressiveCutIn = Rere.State(50),
    AllHeavies = Rere.State(false),
    ParryM2 = Rere.State(false),
    AllM1s = Rere.State(false),
    IfCantParry = Rere.State(false),
    Distance = Rere.State(10),
    ReactionLeadMs = Rere.State(50),
    CooldownMs = Rere.State(500),
}

controller.AliStates = {
    Counter = Rere.State(false),
    CounterRange = Rere.State(8),
    EvasiveCounter = Rere.State(false),
    DodgeAbuse = Rere.State(false),
    RotationHoldMs = Rere.State(300),
    M2Variant = Rere.State(1),
}

controller.WingChunStates = {
    Counter = Rere.State(false),
    CounterRange = Rere.State(8),
    WindowAimPoint = Rere.State(50),
    RequireLiveTrack = Rere.State(true),
    SoloThreatOnly = Rere.State(true),
    SkipGrabs = Rere.State(false),
    CounterInsteadOfDodge = Rere.State(false),
}

controller.WrestlingM2BoostState = Rere.State(false)
controller.WrestlingM2DistanceState = Rere.State(12)
controller.WrestlingTargetQueryState = Rere.State("")
controller.WrestlingBringPosState = Rere.State("-179, -265, -205")

controller.RageStates = {
    Enabled = Rere.State(false),
    AutoGrip = Rere.State(false),
    TargetQuery = Rere.State(""),
    AttackMode = Rere.State(1),
    BackOffset = Rere.State(3),
    UndergroundDepth = Rere.State(6),
    AntiAimJitter = Rere.State(false),
    JitterAngle = Rere.State(45),
    JitterRadius = Rere.State(1),
    JitterDuration = Rere.State(0.05),
    Range = Rere.State(3),
    TweenTime = Rere.State(0.1),
    Prediction = Rere.State(0.1),
    PingPrediction = Rere.State(false),
    UseM2 = Rere.State(false),
    M2Every = Rere.State(4),
    UseDodge = Rere.State(false),
    DodgeEvery = Rere.State(4),
    DodgeRadius = Rere.State(3),
    DodgeBackstep = Rere.State(1),
    DodgeTime = Rere.State(0.05),
    StrafeEnabled = Rere.State(false),
    StrafeRadius = Rere.State(2),
    StrafeStep = Rere.State(1),
}
local rageRuntime = {
    States = {
        SpamM1 = Rere.State(false),
        SpamDelay = Rere.State(0.05),
    }
}

controller.ReturnToDeathPosState = Rere.State(false)
controller.MaxZoomDistanceState = Rere.State(128)
local runForeverEnabled = Rere.State(false)
local autoRunEnabled = Rere.State(false)
controller.BypassGreenZoneState = Rere.State(false)
controller.ResetHudPositions = function() end
controller.ReviverEnabledState = Rere.State(false)
local visualState = {
    M2Cooldown = {
        uiEnabled = Rere.State(true),
    }
}
controller.AutoNewspaperState = Rere.State(false)
controller.AutoNewspaperGuiState = Rere.State(false)
controller.AutoNewspaperStatusLine = "Status: Idle (Shell Mode)"
controller.AutoNewspaperTaskLine = "Task: Waiting for key activation"
controller.AutoNewspaperStreakLine = "Streak: 0 | Earned: 0"

local attackVelocity = {
    enabledState = Rere.State(false),
    speedState = Rere.State(25),
}
local speedOfHit = {
    enabledState = Rere.State(false),
    speedState = Rere.State(25),
}
controller.AttackVelocityKey = "None"
controller.EvasiveEnabledState = Rere.State(false)
controller.EvasiveCooldownState = Rere.State(3.5)
controller.EvasiveDistanceState = Rere.State(18)
controller.EvasiveProcessSpeedState = Rere.State(1)
controller.OutnumberedEvasiveState = Rere.State(false)
controller.EvadeAllState = Rere.State(false)

controller.EspStates = {
    MaxDistance = Rere.State(1000),
    HitboxVisualizerState = Rere.State(false),
    Enabled = Rere.State(false),
    Boxes = Rere.State(false),
    BoxFill = Rere.State(false),
    Box3D = Rere.State(false),
    Chams = Rere.State(false),
    Names = Rere.State(false),
    Distance = Rere.State(false),
    HealthBar = Rere.State(false),
    VerticalHealthBar = Rere.State(false),
    HealthText = Rere.State(false),
    Style = Rere.State(false),
    Tracers = Rere.State(false),
    OffScreenArrows = Rere.State(false),
    Skeleton = Rere.State(false),
    AttackZone = Rere.State(false),
    AttackZoneLocalRing = Rere.State(false),
    AttackZoneRange = Rere.State(12),
    AttackZoneFov = Rere.State(90),
    AttackZoneMaxDistance = Rere.State(60),
    LegacyEnabled = Rere.State(false),
    LegacyChams = Rere.State(false),
    LegacyNames = Rere.State(false),
    LegacyStyle = Rere.State(false),
    TargetYellowChams = Rere.State(false),
    TargetHUD = Rere.State(false),
}
controller.EspStates.ShowTargetHud = controller.EspStates.TargetHUD
controller.HitboxVisualizerState = Rere.State(false)

local flingEnabled = Rere.State(false)
local flingDisableStandingStill = Rere.State(false)
local flingStrength = Rere.State(2500)
local stunwalkEnabled = Rere.State(false)
local stunwalkSpeed = Rere.State(1)
local flyEnabled = Rere.State(false)
local flySpeed = Rere.State(1)
controller.ButterflyAnimState = Rere.State(false)
local targetQuery = Rere.State("")
local targetFlingEnabled = Rere.State(false)
local knockvoidEnabled = Rere.State(false)
local targetOffset = Rere.State(0)
local targetFlingStrength = Rere.State(500000)
controller.EnableDropkickState = Rere.State(false)
controller.DropkickSpeedState = Rere.State(1.4)
controller.TouchAnimationKey = "H"
local function playTouchAnimation() end
local function gakuranNameOf(p) return p and p.DisplayName or "None" end
local function findFlingTarget() return nil end

local autoPerfectNoteEnabled = Rere.State(false)
controller.RhythmHits = 0
local autoGreenBasketballEnabled = Rere.State(false)
controller.BasketballGreens = 0
controller.ComboState = Rere.State(false)
controller.ComboCount = 0
controller.MainGoonState = Rere.State(false)
controller.MainGoonActive = false
controller.SetMainGoon = function() end
controller.JackKeyState = Rere.State("None")
controller.MainGoonSpeedState = Rere.State(1)
controller.StandGoonSpeedState = Rere.State(1)
local fakeStylesEnabled = Rere.State(false)
local fakeStyle = Rere.State("Basic")
local function fakeStyleFolders() return { { Name = "Basic" }, { Name = "Boxing" }, { Name = "Karate" }, { Name = "MuayThai" }, { Name = "Wrestling" } } end
local function rebuildFakeStyleMap() end
controller.FakeStyleStatus = "Shell Mode"
controller.FakeStyleMapped = 5
controller.FakeStylePlayed = 0
controller.FakeStyleSeenTracks = 0
controller.FakeStyleAttackDetected = 0
controller.FakeStyleMovementSeen = 0
controller.SlenderManState = Rere.State(false)
controller.SlenderManActive = false
controller.SetSlenderMan = function() end
controller.SlenderManAnimIdState = Rere.State("92807081069528")
controller.FormatSlenderAnimId = function(id) return tostring(id or "") end
controller.SlenderManCurrentAnimId = ""

local chalk = {
    hasChalkCached = false,
    hasEraserCached = false,
    currentBoardDist = 99,
    isBoardClose = false,
    secretKeyState = Rere.State(""),
    rateLimitUntil = 0,
    isDrawingNow = false,
    isDrawingPaused = false,
    statusState = Rere.State("Ready (Preview)"),
    progressCountState = Rere.State("0 / 0"),
    progressBarState = Rere.State("[----------]"),
    timeLeftState = Rere.State("0s"),
    canGrabChalk = false,
    grabChalkReason = "Preview Shell Mode",
    canGrabEraser = false,
    grabEraserReason = "Preview Shell Mode",
    grabChalkTool = function() end,
    grabEraserTool = function() end,
    showPreviewState = Rere.State(false),
    selectionBox = { Visible = false },
    boardSg = { Enabled = false },
    boxImage = { Visible = false },
    textState = Rere.State("Hello Larpkuran"),
    fontSelectedState = Rere.State(1),
    fonts = { { name = "Default", id = 1 }, { name = "Bold", id = 2 } },
    getFontObj = function() return { name = "Default", id = 1 } end,
    generateImageFromVPS = function() end,
    thicknessState = Rere.State(2),
    drawDelayState = Rere.State(85),
    stretchXState = Rere.State(100),
    letterSpacingState = Rere.State(2),
    autoDrawSmallScanlines = function() end,
    clearBoard = function() end,
    stopDrawingRequested = false,
    posXState = Rere.State(8),
    posYState = Rere.State(25),
    widthState = Rere.State(84),
    heightState = Rere.State(50),
    applyStatesToBox = function() end,
    isDraggingOnBoard = false,
    isResizingBR = false,
    isResizingR = false,
    isResizingB = false,
}
controller.Chalk = chalk

controller.StandAltState = Rere.State("")
controller.AltUsername = ""
controller.UnpairStand = function() end

local function renderBindRow(title, configKey)
    local isCapturing = (controller.CapturingKey == configKey)
    local currentVal = (controller.Keybinds and controller.Keybinds[configKey]) or "None"
    if Rere.Keybind({title, currentVal, isCapturing}).clicked() then
        controller.CapturingKey = configKey
    end
end
controller.Keybinds = {}
controller.ResetKeybindsToDefaults = function() end

local autoroll = {
    CurrentStatState = Rere.State("FightStyle"),
    Stats = { "FightStyle", "SkateboardSkin", "Ethnicity", "UniformRarity", "Face", "HairColor" },
    DesiredValueState = Rere.State("Ali"),
    RollDelayState = Rere.State(1.2),
    SlowModeState = Rere.State(false),
    SlowModeDurationState = Rere.State(7),
    StopOnLegendaryState = Rere.State(true),
    AutoUndoState = Rere.State(false),
    SkipItemsState = Rere.State("Basic"),
    SkipRaritiesState = Rere.State("Common"),
    SkipCommonState = Rere.State(true),
    SkipUncommonState = Rere.State(false),
    SkipRareState = Rere.State(false),
    SkipEpicState = Rere.State(false),
    Running = false,
    ConfirmStep = 0,
    ConfirmExpire = 0,
    LastStatSelected = "FightStyle",
    StatusState = Rere.State("Idle (Preview Shell)"),
    RollCountState = Rere.State(0),
    SlowModeTimerState = Rere.State(0),
    SlowModeCanUndoState = Rere.State(false),
    LastRolledState = Rere.State("Basic"),
    GetCurrentValue = function(k) return "Basic" end,
    FormatValueWithRarity = function(k, v) return tostring(v) .. " [Common]" end,
    ValidateHairColorTarget = function() return true, "Valid target" end,
    Start = function() end,
    Stop = function() end,
}
controller.AutoRoll = autoroll

controller.AntiModState = Rere.State(true)
controller.SetAntiMod = function() end
controller.AnonymousModeState = Rere.State(false)
controller.SetAnonymousMode = function() end
controller.LanguageState = Rere.State("English")
controller.HideHealthBarState = Rere.State(false)
controller.HideStaminaBarState = Rere.State(false)
controller.HideHeavyBarState = Rere.State(false)
controller.DoubleTroubleGuiState = Rere.State(false)
controller.UIKeyState = Rere.State("K")
controller.SaveConfig = function() end
controller.LoadConfig = function() end
controller.ResetConfig = function() end
local CONFIG_FILE = "larpkuran_config.json"
local function triggerLarpkuranRestart() end

local warningDismissed = false
local warningStartTime = nil
local allTabs = {}

_G.LarpkuranDismissWarning = function()
    warningDismissed = true
end
_G.LarpkuranResetWarning = function()
    warningDismissed = false
    warningStartTime = nil
end

local function switchTab(index)
    _G.LarpkuranActiveTabIndex = index
    for i, t in ipairs(allTabs) do
        if t and t.state and t.state.isOpened then
            t.state.isOpened:set(i == index)
        end
    end
end
_G.LarpkuranSwitchTab = switchTab

local function switchToKeyTab()
    if not warningDismissed then
        warningStartTime = nil
    end
    switchTab(1)
end

local function renderFullWarningScreen()
    isRenderingWarning = true
    if not warningStartTime then
        warningStartTime = os.clock()
    end
    local elapsed = os.clock() - warningStartTime
    local remaining = math.max(0, math.ceil(7 - elapsed))

    Rere.PushConfig({
        HeaderColor = Color3.fromRGB(60, 15, 15),
        TextColor = Color3.fromRGB(255, 65, 65)
    })
    Rere.SeparatorText({"⚠️ PREVIEW ONLY ⚠️"})
    Rere.PopConfig()

    Rere.Separator()

    Rere.PushConfig({
        TextColor = Color3.fromRGB(255, 225, 90)
    })
    Rere.Text({"Preview Only! These features do NOT work under the key system."})
    Rere.Text({"You MUST get a key in order to use these!"})
    Rere.PopConfig()

    Rere.PushConfig({
        TextColor = Color3.fromRGB(255, 130, 130)
    })
    Rere.Text({"Everything here doesn't work, don't ask me why Larpkuran doesn't work! :)"})
    Rere.PopConfig()

    Rere.Separator()

    local canDismiss = (remaining == 0)
    Rere.PushConfig({
        TextColor = canDismiss and Color3.fromRGB(130, 255, 130) or Color3.fromRGB(255, 180, 180)
    })
    local statusPrompt = canDismiss and "You can now get rid of this screen to preview." or string.format("You can only get rid of this screen after 7 seconds (%d s left)", remaining)
    Rere.Text({statusPrompt})
    Rere.PopConfig()

    Rere.PushConfig({
        TextColor = canDismiss and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(140, 140, 140)
    })
    local btnLabel = canDismiss and "[ 🔓 Get rid of this screen / Preview ]" or string.format("[ Please wait... (%d s) ]", remaining)
    local dismissBtn = Rere.Button({btnLabel, UDim2.fromOffset(300, 28)})
    if dismissBtn.Instance and dismissBtn.Instance:IsA("GuiButton") then
        dismissBtn.Instance.Active = canDismiss
        dismissBtn.Instance.AutoButtonColor = canDismiss
        if not dismissBtn.Instance:GetAttribute("BoundClick") then
            dismissBtn.Instance:SetAttribute("BoundClick", true)
            dismissBtn.Instance.MouseButton1Click:Connect(function()
                local elapsedNow = warningStartTime and (os.clock() - warningStartTime) or 0
                if elapsedNow >= 7 then
                    playClickSound()
                    warningDismissed = true
                end
            end)
        end
    end
    if dismissBtn.clicked() then
        if canDismiss then
            playClickSound()
            warningDismissed = true
        end
    end
    Rere.PopConfig()

    Rere.Separator()
    local returnBtn = Rere.Button({"[ 🔑 Return to Key Tab ]", UDim2.fromOffset(200, 24)})
    if returnBtn.Instance and returnBtn.Instance:IsA("GuiButton") then
        returnBtn.Instance.Active = true
        returnBtn.Instance.AutoButtonColor = true
        if not returnBtn.Instance:GetAttribute("BoundClick") then
            returnBtn.Instance:SetAttribute("BoundClick", true)
            returnBtn.Instance.MouseButton1Click:Connect(function()
                playClickSound()
                switchToKeyTab()
            end)
        end
    end
    if returnBtn.clicked() then
        playClickSound()
        switchToKeyTab()
    end
    local discordBtn = Rere.Button({"[ Get Key (DISCORD) ]", UDim2.fromOffset(200, 24)})
    if discordBtn.Instance and discordBtn.Instance:IsA("GuiButton") then
        discordBtn.Instance.Active = true
        discordBtn.Instance.AutoButtonColor = true
        if not discordBtn.Instance:GetAttribute("BoundClick") then
            discordBtn.Instance:SetAttribute("BoundClick", true)
            discordBtn.Instance.MouseButton1Click:Connect(function()
                playClickSound()
                local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
                if type(setclip) == "function" then
                    pcall(setclip, "https://discord.gg/tKzhr5FecY")
                end
            end)
        end
    end
    if discordBtn.clicked() then
        playClickSound()
        local setclip = setclipboard or toclipboard or (syn and syn.write_clipboard)
        if type(setclip) == "function" then
            pcall(setclip, "https://discord.gg/tKzhr5FecY")
        end
    end
    isRenderingWarning = false
end

local function shouldShowWarning()
    if isUnlocked and _G.LarpkuranForceLock ~= true then
        return false
    end
    return not warningDismissed
end

local function renderLockedBanner()
    if not isUnlocked or _G.LarpkuranForceLock == true then
        Rere.PushConfig({
            HeaderColor = Color3.fromRGB(36, 20, 24),
            TextColor = Color3.fromRGB(255, 185, 120)
        })
        Rere.Text({"🔒 [SHOWCASE MODE] Features are locked. Sign in on the 🔑 Key tab to unlock."})
        Rere.PopConfig()
        Rere.Separator()
    end
end

if _G.LarpkuranShellRereConn then
    pcall(_G.LarpkuranShellRereConn)
    _G.LarpkuranShellRereConn = nil
end

if isUnlocked and _G.LarpkuranForceLock ~= true then
    autoExecuteProd()
    return
end

_G.LarpkuranActiveTabIndex = 1
controller.LarpkuranOpenedState.value = true

_G.LarpkuranShellRereConn = Rere:Connect(function()
    local isMobile = UserInputService.TouchEnabled
    local windowTitle = (isUnlocked and _G.LarpkuranForceLock ~= true) and "StacyKEYS [ACTIVE]" or "StacyKEYS"
    local window = Rere.Window({windowTitle, false, false, isMobile, true}, {isOpened = controller.LarpkuranOpenedState, size = controller.LarpkuranSizeState})
    if isUnsupportedExecutor and window and window.Instance then
        local winInst = window.Instance
        local targetParent = winInst:FindFirstChild("WindowButton") or winInst
        local overlay = targetParent:FindFirstChild("UnsupportedOverlay")
        if not overlay then
            overlay = Instance.new("Frame")
            overlay.Name = "UnsupportedOverlay"
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.Position = UDim2.new(0, 0, 0, 0)
            overlay.BackgroundTransparency = 1
            overlay.ZIndex = 9999
            overlay.Active = false
            overlay.Parent = targetParent

            local label = Instance.new("TextLabel")
            label.Name = "Text"
            label.Size = UDim2.new(1.4, 0, 0, 60)
            label.AnchorPoint = Vector2.new(0.5, 0.5)
            label.Position = UDim2.new(0.5, 0, 0.5, 0)
            label.BackgroundTransparency = 1
            label.Text = "UNSUPPORTED EXECUTOR"
            label.Font = Enum.Font.GothamBold
            label.TextSize = 28
            label.TextColor3 = Color3.fromRGB(255, 40, 40)
            label.TextTransparency = 0.2
            label.Rotation = -28
            label.ZIndex = 10000
            label.TextStrokeTransparency = 0.4
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Parent = overlay
        end
    end
    if window.state.isOpened.value and window.state.isUncollapsed.value then
        Rere.TabBar()

        local tabKey = Rere.Tab({"🔑 Key"})
        allTabs[1] = tabKey
        if tabKey.state.isOpened.value then
            Rere.CustomKeyPanel({})
        end
        Rere.End()

        local tabCombat = Rere.Tab({"Combat"})
        allTabs[2] = tabCombat
        if tabCombat.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            local headerAutoParry = Rere.CollapsingHeader({"Auto Parry"})
            if headerAutoParry.state.isUncollapsed.value then
                Rere.Checkbox({"Enabled"}, {isChecked = enabled})
                Rere.SliderNum({"Hold Duration", 0.01, 0.08, 0.35, "%.2f s"}, {number = holdTime})
                Rere.SliderNum({"Parry Chance", 1, 1, 100, "%.0f%%"}, {number = parryChance})
                Rere.SliderNum({"Parry Lead", 0.005, -0.1, 0.15, "%.3f s"}, {number = parryLead})
                Rere.SliderNum({"Hold Time", 0.01, 0.08, 0.70, "%.2f s"}, {number = holdTime})
                Rere.SliderNum({"Timing Scale", 0.05, 0.5, 1.5, "%.2f"}, {number = timingScale})
                Rere.SliderNum({"Ping Compensation", 5, 0, 300, "%.0f%%"}, {number = controller.PingCompensationScaleState})
                Rere.Checkbox({"Perfect Parry"}, {isChecked = controller.PerfectParryState})
                Rere.Checkbox({"Heavy Attack Parry"}, {isChecked = controller.HeavyAttackParryState})
                Rere.SliderNum({"Detection Range", 1, 6, 40, "%.0f studs"}, {number = radius})
                Rere.Checkbox({"Auto Face Attacker"}, {isChecked = autoFaceEnabled})
                Rere.TooltipElement(Rere.Checkbox({"Adaptive Tuning (?)"}, {isChecked = controller.AdaptiveTuningState}), "Adaptive parry timing system that calibrates lead timing based on your latency.")
                local curPing = math.floor(controller.CurrentPing or 0)
                Rere.Text({"Ping: " .. tostring(curPing) .. "ms"})
                local autoParryKeyLabel = "Keybind: " .. tostring(autoParryKey:get() or "PageUp")
                Rere.Button({autoParryKeyLabel})
                Rere.Separator()
                local headerAdvancedParry = Rere.CollapsingHeader({"[ Advanced Parry Settings ]"})
                if headerAdvancedParry.state.isUncollapsed.value then
                    Rere.TooltipElement(Rere.Checkbox({"Parries Only To Target (?)"}, {isChecked = controller.ParryOnlyTargetState}), "Only parry attacks from your currently selected or locked target player.")
                    Rere.TooltipElement(Rere.Checkbox({"Block M1 Until Parry (?)"}, {isChecked = controller.BlockM1UntilParryState}), "Blocks your own M1 clicks while preparing or executing a parry.")
                    Rere.TooltipElement(Rere.Checkbox({"Hold Through Combo (?)"}, {isChecked = controller.HoldThroughComboState}), "Extends block hold duration by 0.35s when facing combo attack chains.")
                    Rere.TooltipElement(Rere.Checkbox({"Facing Check (?)"}, {isChecked = dontParryWhenNotFacing}), "Only parry attackers actually facing you.")
                    Rere.TooltipElement(Rere.Checkbox({"Fallback Safety Block (?)"}, {isChecked = controller.FallbackSafetyBlockState}), "Automatically holds regular block guard if parry is on cooldown.")
                    Rere.TooltipElement(Rere.SliderNum({"Fallback Block Duration (?)", 0.05, 0.1, 1.5, "%.2f s"}, {number = controller.FallbackBlockDurationState}), "Duration to maintain regular safety block.")
                    Rere.TooltipElement(Rere.SliderNum({"Fallback Block Range (?)", 1, 5, 30, "%.0f studs"}, {number = controller.FallbackBlockRangeState}), "Maximum distance to incoming attacker.")
                    Rere.TooltipElement(Rere.Checkbox({"M1 Priority (?)"}, {isChecked = m1PriorityEnabled}), "Gives your own M1 attacks priority over parrying.")
                    Rere.TooltipElement(Rere.Checkbox({"Legit Block Animation (?)"}, {isChecked = controller.LegitBlockAnimationState}), "Hides the block animation during auto parry.")
                    Rere.TooltipElement(Rere.Checkbox({"Skip First Hit (?)"}, {isChecked = controller.SkipFirstHitState}), "Ignores the first M1 attack and only parries from second hit.")
                    Rere.TooltipElement(Rere.Checkbox({"Disable Block Mid Dash (?)"}, {isChecked = controller.DisableBlockMidDashState}), "Prevents auto-parry and manual block input while dashing.")
                    Rere.Separator()
                    Rere.Text({"Status: " .. tostring(controller.ParryState) .. " | " .. tostring(controller.LastState)})
                    Rere.Text({"Successes: " .. tostring(controller.ParrySuccesses) .. " | Triggers: " .. tostring(controller.TriggerCount)})
                end
                Rere.End()
            end
            Rere.End()

            Rere.Separator()
            local headerAttackDesync = Rere.CollapsingHeader({"Attack Desync"})
            if headerAttackDesync.state.isUncollapsed.value then
                Rere.Checkbox({"Enabled"}, {isChecked = controller.AttackDesyncStates.Enabled})
                Rere.Text({"desyncs ur swings so enemies mistime the parry"})
                Rere.Button({"Keybind: " .. tostring(controller.AttackDesyncStates.Key:get())})
                Rere.SliderNum({"Anim Delay", 1, 0, 1000, "%.0f ms"}, {number = controller.AttackDesyncStates.Delay})
                Rere.Checkbox({"Apply to M1"}, {isChecked = controller.AttackDesyncStates.ApplyM1})
                Rere.Checkbox({"Apply to M2"}, {isChecked = controller.AttackDesyncStates.ApplyM2})
            end
            Rere.End()

            Rere.Separator()
            local headerTargetTracking = Rere.CollapsingHeader({"Target Tracking"})
            if headerTargetTracking.state.isUncollapsed.value then
                Rere.TooltipElement(Rere.Checkbox({"Auto Orient"}, {isChecked = autoFaceEnabled}), "aligns facing angle toward incoming strike for directional parry")
                Rere.ComboArray({"Pivot Mode"}, {index = controller.TrackingStates.Mode}, {"Character Model", "Camera View"})
                Rere.TooltipElement(Rere.Checkbox({"Rapid Threat Switch"}, {isChecked = controller.TrackingStates.RapidSwitch}), "instantly snaps facing angle to new target")
                Rere.TooltipElement(Rere.Checkbox({"Impact Angle Lock"}, {isChecked = controller.TrackingStates.ImpactSnap}), "locks onto attacker right before hit contact")
                Rere.SliderNum({"Tracking Smoothness", 0.05, 0.1, 1, "%.2f"}, {number = controller.TrackingStates.Smoothness})
                Rere.Separator()
                Rere.Text({"FACE AT TARGET"})
                Rere.Checkbox({"Face at target (All the time)"}, {isChecked = controller.FaceAtEnabledState})
                Rere.Checkbox({"Target Marker (No ESP needed)"}, {isChecked = controller.TargetMarkerEnabledState})
                Rere.Button({"Bind toggle: " .. tostring(controller.FaceAtToggleKey)})
                Rere.Text({"Target: None"})
                Rere.Button({"Select nearest player"})
                Rere.Button({"Clear target"})
            end
            Rere.End()

            Rere.Separator()
            local headerMagnify = Rere.CollapsingHeader({"Magnify"})
            if headerMagnify.state.isUncollapsed.value then
                Rere.TooltipElement(Rere.Checkbox({"Enable Magnify (?)"}, {isChecked = controller.MagnifyEnabledState}), "Gently pulls while attacking, stopping around 6 studs away.")
                Rere.SliderNum({"Magnify Speed", 1, 1, 100, "%.0f"}, {number = controller.MagnifySpeedState})
                Rere.SliderNum({"Max Distance", 1, 5, 60, "%.0f studs"}, {number = controller.MagnifyMaxDistState})
                Rere.Text({"Target: None"})
            end
            Rere.End()

            Rere.Separator()
            local headerBoxing = Rere.CollapsingHeader({"Boxing"})
            if headerBoxing.state.isUncollapsed.value then
                Rere.TooltipElement(Rere.Checkbox({"Boxing Counter"}, {isChecked = controller.BoxingStates.Counter}), "boxing style only")
                Rere.Button({"Toggle Key: " .. tostring(controller.BoxingKeyState:get())})
                Rere.TooltipElement(Rere.SliderNum({"Counter Range", 0.5, 2, 15, "%.1f studs"}, {number = controller.BoxingStates.Reach}), "max distance to attacker")
            end
            Rere.End()

            Rere.Separator()
            local headerDodge = Rere.CollapsingHeader({"Dodge"})
            if headerDodge.state.isUncollapsed.value then
                Rere.TooltipElement(Rere.Checkbox({"Enabled (?)"}, {isChecked = controller.DodgeStates.Enabled}), "Combat auto dodge using native evasive roll/dash")
                Rere.TooltipElement(Rere.SliderNum({"Dodge Chance (?)", 1, 1, 100, "%.0f%%"}, {number = controller.DodgeStates.Chance}), "Chance to perform dodge")
                Rere.Button({"Keybind: " .. tostring(controller.DodgeStates.Key:get())})
                Rere.ComboArray({"Dodge Mode (?)"}, {index = controller.DodgeStates.Mode}, {"Defensive", "Aggressive"})
                Rere.TooltipElement(Rere.Checkbox({"Dodge All Heavies (?)"}, {isChecked = controller.DodgeStates.AllHeavies}), "prefer dodge for all M2 heavies")
                Rere.TooltipElement(Rere.Checkbox({"Still Parry M2 (?)"}, {isChecked = controller.DodgeStates.ParryM2}), "still parry M2 fallback")
                Rere.TooltipElement(Rere.Checkbox({"Dodge All M1s (?)"}, {isChecked = controller.DodgeStates.AllM1s}), "dodge light attacks / M1 combos")
                Rere.TooltipElement(Rere.Checkbox({"Dodge If Cant Parry (?)"}, {isChecked = controller.DodgeStates.IfCantParry}), "dodge when parry is on cooldown")
                Rere.Separator()
                Rere.Text({"DODGE TUNING"})
                Rere.SliderNum({"Dodge Distance (?)", 1, 6, 16, "%.0f studs"}, {number = controller.DodgeStates.Distance})
                Rere.SliderNum({"Dodge Reaction (?)", 1, 0, 300, "%.0f ms"}, {number = controller.DodgeStates.ReactionLeadMs})
                Rere.SliderNum({"Dodge CD (?)", 10, 0, 3000, "%.0f ms"}, {number = controller.DodgeStates.CooldownMs})
            end
            Rere.End()

            Rere.Separator()
            local headerAli = Rere.CollapsingHeader({"Ali"})
            if headerAli.state.isUncollapsed.value then
                Rere.Checkbox({"Ali Counter"}, {isChecked = controller.AliStates.Counter})
                Rere.SliderNum({"Ali Counter Range", 0.5, 2, 25, "%.1f studs"}, {number = controller.AliStates.CounterRange})
                Rere.Checkbox({"Ali Evasive Counter"}, {isChecked = controller.AliStates.EvasiveCounter})
                Rere.Checkbox({"Ali Dodge Abuse"}, {isChecked = controller.AliStates.DodgeAbuse})
                Rere.SliderNum({"Ali Rotation Hold", 10, 50, 2000, "%.0f ms"}, {number = controller.AliStates.RotationHoldMs})
                Rere.ComboArray({"Ali M2 Variant"}, {index = controller.AliStates.M2Variant}, {"Right", "Left"})
            end
            Rere.End()

            Rere.Separator()
            local headerWingChun = Rere.CollapsingHeader({"Wing Chun"})
            if headerWingChun.state.isUncollapsed.value then
                Rere.Checkbox({"Wing Chun Counter"}, {isChecked = controller.WingChunStates.Counter})
                Rere.SliderNum({"Wing Chun Counter Range", 0.5, 2, 25, "%.1f studs"}, {number = controller.WingChunStates.CounterRange})
                Rere.SliderNum({"Window Aim Point", 1, 5, 95, "%.0f %%"}, {number = controller.WingChunStates.WindowAimPoint})
                Rere.Checkbox({"WC Require Live Track"}, {isChecked = controller.WingChunStates.RequireLiveTrack})
                Rere.Checkbox({"WC Solo Threat Only"}, {isChecked = controller.WingChunStates.SoloThreatOnly})
                Rere.Checkbox({"WC Skip Grabs"}, {isChecked = controller.WingChunStates.SkipGrabs})
                Rere.Checkbox({"Counter Instead Of Dodge"}, {isChecked = controller.WingChunStates.CounterInsteadOfDodge})
            end
            Rere.End()

            Rere.Separator()
            local headerWrestling = Rere.CollapsingHeader({"Wrestling"})
            if headerWrestling.state.isUncollapsed.value then
                Rere.Text({"WRESTLING M2 (Combat Grab Boost)"})
                Rere.Checkbox({"M2 Forward Boost (?)"}, {isChecked = controller.WrestlingM2BoostState})
                Rere.SliderNum({"M2 Total Distance", 1, 2, 40, "%.0f studs"}, {number = controller.WrestlingM2DistanceState})
                Rere.Separator()
                Rere.Text({"WRESTLING BRING (Underground M2 Grab & TP)"})
                Rere.InputText({"Target", "Target username, display name, or leave blank"}, {text = controller.WrestlingTargetQueryState})
                Rere.InputText({"Destination XYZ", "X, Y, Z coordinates"}, {text = controller.WrestlingBringPosState})
                Rere.SameLine()
                    Rere.Button({"Execute Wrestling Bring (/wbring)"})
                    Rere.Button({"Set to Current Pos"})
                    Rere.Button({"Set to Look Pos"})
                    Rere.Button({"Preset: Isolate"})
                    Rere.Button({"Preset: Farlands"})
                Rere.End()
            end
            Rere.End()

            Rere.Separator()
            local headerRagepunch = Rere.CollapsingHeader({"Ragepunch"})
            if headerRagepunch.state.isUncollapsed.value then
                Rere.Checkbox({"Enable Ragepunch"}, {isChecked = controller.RageStates.Enabled})
                Rere.Checkbox({"Auto Grip When Downed"}, {isChecked = controller.RageStates.AutoGrip})
                Rere.InputText({"Ragepunch target", "Gakuran name, username, or random"}, {text = controller.RageStates.TargetQuery})
                Rere.ComboArray({"Ragepunch attack mode"}, {index = controller.RageStates.AttackMode}, {"Back Tween", "Tween", "Underground"})
                Rere.SliderNum({"Ragepunch back offset", 0.1, 1.5, 15, "%.1f studs"}, {number = controller.RageStates.BackOffset})
                Rere.SliderNum({"Underground depth", 1, 4, 10, "%.0f studs"}, {number = controller.RageStates.UndergroundDepth})
                Rere.Checkbox({"Spam M1 (Fast Attack)"}, {isChecked = rageRuntime.States.SpamM1})
                Rere.SliderNum({"Spam delay", 0.01, 0.01, 0.15, "%.2f s"}, {number = rageRuntime.States.SpamDelay})
                local headerAdvRage = Rere.CollapsingHeader({"ADVANCED"})
                if headerAdvRage.state.isUncollapsed.value then
                    Rere.Checkbox({"Ragepunch anti-aim jitter"}, {isChecked = controller.RageStates.AntiAimJitter})
                    Rere.SliderNum({"Ragepunch jitter angle", 1, 0, 90, "%.0f degrees"}, {number = controller.RageStates.JitterAngle})
                    Rere.SliderNum({"Ragepunch jitter radius", 0.1, 0, 3, "%.1f studs"}, {number = controller.RageStates.JitterRadius})
                    Rere.SliderNum({"Ragepunch jitter duration", 0.01, 0.02, 0.2, "%.2f s"}, {number = controller.RageStates.JitterDuration})
                    Rere.SliderNum({"Ragepunch tween distance", 0.1, 2, 5, "%.1f studs"}, {number = controller.RageStates.Range})
                    Rere.SliderNum({"Ragepunch tween time", 0.01, 0.04, 0.35, "%.2f s"}, {number = controller.RageStates.TweenTime})
                    Rere.SliderNum({"Ragepunch prediction", 0.01, 0, 0.5, "%.2f s"}, {number = controller.RageStates.Prediction})
                    Rere.Checkbox({"Ping prediction (horizontal only)"}, {isChecked = controller.RageStates.PingPrediction})
                    Rere.Checkbox({"Use M2"}, {isChecked = controller.RageStates.UseM2})
                    Rere.SliderNum({"M2 every", 1, 2, 12, "every %.0f attacks"}, {number = controller.RageStates.M2Every})
                    Rere.Checkbox({"Custom rage dodge"}, {isChecked = controller.RageStates.UseDodge})
                    Rere.SliderNum({"Dodge every", 1, 2, 12, "every %.0f attacks"}, {number = controller.RageStates.DodgeEvery})
                    Rere.SliderNum({"Dodge radius", 0.1, 1, 6, "%.1f studs"}, {number = controller.RageStates.DodgeRadius})
                    Rere.SliderNum({"Dodge backstep", 0.1, 0, 3, "%.1f studs"}, {number = controller.RageStates.DodgeBackstep})
                    Rere.SliderNum({"Dodge time", 0.01, 0.03, 0.2, "%.2f s"}, {number = controller.RageStates.DodgeTime})
                    Rere.Checkbox({"Strafe while attacking"}, {isChecked = controller.RageStates.StrafeEnabled})
                    Rere.SliderNum({"Strafe radius", 0.1, 0, 5, "%.1f studs"}, {number = controller.RageStates.StrafeRadius})
                    Rere.SliderNum({"Strafe step", 0.01, 0.1, 4, "%.2f"}, {number = controller.RageStates.StrafeStep})
                    Rere.Text({"Ragepunch status: Shell Mode"})
                    Rere.Text({"Prediction scale: 1.4 | Y prediction: off"})
                    Rere.Button({"Stop Ragepunch"})
                end
                Rere.End()
            end
            Rere.End()
            end
        end
        Rere.End()

        local tabMain = Rere.Tab({"Main"})
        allTabs[3] = tabMain
        if tabMain.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Text({"RESPAWN POSITION"})
            Rere.Checkbox({"Return to death/reset position"}, {isChecked = controller.ReturnToDeathPosState})
            Rere.Separator()
            Rere.Text({"CAMERA & ZOOM"})
            Rere.SliderNum({"Max Zoom Distance", 1, 12, 500, "%.0f studs"}, {number = controller.MaxZoomDistanceState})
            Rere.Separator()
            Rere.Checkbox({"Inf Stamina (?)"}, {isChecked = runForeverEnabled})
            Rere.Checkbox({"Auto Run (?)"}, {isChecked = autoRunEnabled})
            Rere.Checkbox({"Bypass green zone & match walls (?)"}, {isChecked = controller.BypassGreenZoneState})
            Rere.Button({"Reset HUD bar positions (?)"})
            Rere.Checkbox({"Reviver (?)"}, {isChecked = controller.ReviverEnabledState})
            Rere.Checkbox({"Heavy CD bar (?)"}, {isChecked = visualState.M2Cooldown.uiEnabled})
            Rere.Separator()
            Rere.Text({"SCHOOL NEWSPAPER"})
            Rere.Checkbox({"Auto Newspaper (School)"}, {isChecked = controller.AutoNewspaperState})
            Rere.Checkbox({"Show Newspaper Status HUD"}, {isChecked = controller.AutoNewspaperGuiState})
            end
        end
        Rere.End()

        local tabMovement = Rere.Tab({"Movement"})
        allTabs[4] = tabMovement
        if tabMovement.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Text({"CAMERA & ZOOM"})
            Rere.SliderNum({"Max Zoom Distance", 1, 12, 500, "%.0f studs"}, {number = controller.MaxZoomDistanceState})
            Rere.Separator()
            Rere.Text({"MOVEMENT"})
            Rere.Checkbox({"Attack Velocity (?)"}, {isChecked = attackVelocity.enabledState})
            Rere.SliderNum({"Attack Velocity speed", 1, 4, 30, "%.0f"}, {number = attackVelocity.speedState})
            Rere.Checkbox({"Speed of Hit (?)"}, {isChecked = speedOfHit.enabledState})
            Rere.SliderNum({"Hit Speed", 1, 4, 60, "%.0f"}, {number = speedOfHit.speedState})
            Rere.Text({"Current speed: 25"})
            Rere.Button({"Bind velocity hotkey: None"})
            Rere.Separator()
            Rere.Text({"EVASIVE"})
            Rere.Checkbox({"Custom Evasive CD (?)"}, {isChecked = controller.EvasiveEnabledState})
            Rere.SliderNum({"Evasive Cooldown", 0.1, 0, 15, "%.1f s"}, {number = controller.EvasiveCooldownState})
            Rere.SliderNum({"Dash Distance", 1, 6, 120, "%.0f studs"}, {number = controller.EvasiveDistanceState})
            Rere.SliderNum({"Dash Process Speed (?)", 0.1, 0.5, 5, "%.1fx"}, {number = controller.EvasiveProcessSpeedState})
            Rere.Checkbox({"Outnumbered Evasive (?)"}, {isChecked = controller.OutnumberedEvasiveState})
            Rere.Checkbox({"Evade ALL (?)"}, {isChecked = controller.EvadeAllState})
            end
        end
        Rere.End()

        local tabEsp = Rere.Tab({"ESP"})
        allTabs[5] = tabEsp
        if tabEsp.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.SliderNum({"Max Distance", 50, 100, 5000, "%.0f studs"}, {number = controller.EspStates.MaxDistance})
            Rere.Separator()
            local headerHitbox = Rere.CollapsingHeader({"Hitbox Visualizer"})
            if headerHitbox.state.isUncollapsed.value then
                Rere.Checkbox({"Enable Hitbox Visualizer"}, {isChecked = controller.HitboxVisualizerState})
            end
            Rere.End()
            Rere.Separator()
            local headerModernEsp = Rere.CollapsingHeader({"Modern ESP"})
            if headerModernEsp.state.isUncollapsed.value then
                Rere.Checkbox({"Enable Modern ESP"}, {isChecked = controller.EspStates.Enabled})
                Rere.Separator()
                Rere.Text({"BOXES & CHAMS"})
                Rere.Checkbox({"2D Boxes"}, {isChecked = controller.EspStates.Boxes})
                Rere.Checkbox({"Box Fill"}, {isChecked = controller.EspStates.BoxFill})
                Rere.Checkbox({"3D Boxes"}, {isChecked = controller.EspStates.Box3D})
                Rere.Checkbox({"Chams / Highlight"}, {isChecked = controller.EspStates.Chams})
                Rere.Checkbox({"Yellow Chams on Target"}, {isChecked = controller.EspStates.TargetYellowChams})
                Rere.Separator()
                Rere.Text({"INFO & FIGHTING STYLE"})
                Rere.Checkbox({"Names"}, {isChecked = controller.EspStates.Names})
                Rere.Checkbox({"Distance"}, {isChecked = controller.EspStates.Distance})
                Rere.Checkbox({"Health Bar"}, {isChecked = controller.EspStates.HealthBar})
                Rere.Checkbox({"Vertical Health Bar"}, {isChecked = controller.EspStates.VerticalHealthBar})
                Rere.Checkbox({"Health Text"}, {isChecked = controller.EspStates.HealthText})
                Rere.Checkbox({"Fighting Style"}, {isChecked = controller.EspStates.Style})
                Rere.Checkbox({"Show Target HUD"}, {isChecked = controller.EspStates.TargetHUD})
                Rere.Separator()
                Rere.Text({"TRACERS & ARROWS"})
                Rere.Checkbox({"Tracers"}, {isChecked = controller.EspStates.Tracers})
                Rere.Checkbox({"Off-Screen Arrows"}, {isChecked = controller.EspStates.OffScreenArrows})
                Rere.Checkbox({"Skeleton / Bones"}, {isChecked = controller.EspStates.Skeleton})
            end
            Rere.End()
            local headerZones = Rere.CollapsingHeader({"Attack Zones & Rings"})
            if headerZones.state.isUncollapsed.value then
                Rere.Checkbox({"Enemy Attack Zone (Turns red in range)"}, {isChecked = controller.EspStates.AttackZone})
                Rere.Checkbox({"Local Player Defense Ring"}, {isChecked = controller.EspStates.AttackZoneLocalRing})
                Rere.SliderNum({"Attack Range", 1, 6, 25, "%.0f studs"}, {number = controller.EspStates.AttackZoneRange})
                Rere.SliderNum({"Attack FOV", 5, 60, 180, "%.0f deg"}, {number = controller.EspStates.AttackZoneFov})
                Rere.SliderNum({"Attack Zone Max Distance", 1, 7, 240, "%.0f studs"}, {number = controller.EspStates.AttackZoneMaxDistance})
            end
            Rere.End()
            local headerLegacy = Rere.CollapsingHeader({"Legacy ESP"})
            if headerLegacy.state.isUncollapsed.value then
                Rere.Checkbox({"Enable Legacy ESP"}, {isChecked = controller.EspStates.LegacyEnabled})
                Rere.Checkbox({"Chams (Health Color) (?)"}, {isChecked = controller.EspStates.LegacyChams})
                Rere.Checkbox({"Username"}, {isChecked = controller.EspStates.LegacyNames})
                Rere.Checkbox({"Fighting Style"}, {isChecked = controller.EspStates.LegacyStyle})
            end
            Rere.End()
            end
        end
        Rere.End()

        local tabFling = Rere.Tab({"Fling"})
        allTabs[6] = tabFling
        if tabFling.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Text({"STUNWALK + FLY FLING"})
            Rere.Checkbox({"fling | USE WITH STUNWALK + FLY"}, {isChecked = flingEnabled})
            Rere.Checkbox({"Disable fling when standing still"}, {isChecked = flingDisableStandingStill})
            Rere.SliderNum({"STUNWALK + FLY fling strength", 100, 100, 30000, "%.0f"}, {number = flingStrength})
            Rere.Checkbox({"Enable STUNWALK (?)"}, {isChecked = stunwalkEnabled})
            Rere.SliderNum({"STUNWALK speed", 0.1, 0.5, 4, "%.1fx"}, {number = stunwalkSpeed})
            Rere.Checkbox({"Enable FLY (?)"}, {isChecked = flyEnabled})
            Rere.SliderNum({"FLY speed", 0.1, 0.5, 4, "%.1fx"}, {number = flySpeed})
            Rere.Checkbox({"Butterfly"}, {isChecked = controller.ButterflyAnimState})
            Rere.Separator()
            Rere.Text({"TARGET FLING"})
            Rere.InputText({"Target (?)", "Gakuran name, username, or random"}, {text = targetQuery})
            Rere.PushConfig({TextFont = Font.fromEnum(Enum.Font.Bodoni), TextSize = 18})
            Rere.Text({"Target selected: None", false, Color3.fromRGB(255, 255, 255)})
            Rere.PopConfig()
            Rere.Checkbox({"Run target fling"}, {isChecked = targetFlingEnabled})
            Rere.Checkbox({"Knockvoid (+1.5 vertical studs)"}, {isChecked = knockvoidEnabled})
            Rere.SliderNum({"Target offset", 0.1, -5, 5, "%.1f studs"}, {number = targetOffset})
            Rere.Separator()
            Rere.SliderNum({"Target fling strength", 100000, 100000, 10000000, "%.0f"}, {number = targetFlingStrength})
            Rere.Checkbox({"Enable dropkick"}, {isChecked = controller.EnableDropkickState})
            Rere.SliderNum({"Dropkick speed", 0.1, 0.5, 10, "%.1fx"}, {number = controller.DropkickSpeedState})
            Rere.Button({"Bind dropkick key: " .. tostring(controller.TouchAnimationKey)})
            Rere.Button({"Play dropkick animation (?)"})
            end
        end
        Rere.End()

        local tabFun = Rere.Tab({"Fun"})
        allTabs[7] = tabFun
        if tabFun.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Checkbox({"Auto perfect note"}, {isChecked = autoPerfectNoteEnabled})
            Rere.Text({"Rhythm notes hit: " .. tostring(controller.RhythmHits)})
            Rere.Separator()
            Rere.Checkbox({"Auto Green Basketball"}, {isChecked = autoGreenBasketballEnabled})
            Rere.Text({"Basketball green shots: " .. tostring(controller.BasketballGreens)})
            Rere.Separator()
            Rere.Checkbox({"Combo System (?)"}, {isChecked = controller.ComboState})
            Rere.Text({"Current combo: " .. tostring(controller.ComboCount)})
            Rere.Separator()
            Rere.Text({"GOON"})
            Rere.Checkbox({"Enable Goon (Main)"}, {isChecked = controller.MainGoonState})
            Rere.Button({"Keybind: " .. tostring(controller.JackKeyState:get())})
            Rere.SliderNum({"Main Goon Speed", 0.1, 0.2, 5, "%.1fx"}, {number = controller.MainGoonSpeedState})
            Rere.SliderNum({"Stand Goon Speed", 0.1, 0.2, 5, "%.1fx"}, {number = controller.StandGoonSpeedState})
            Rere.Separator()
            Rere.Text({"FAKE STYLES (IN EXPERIMENT)"})
            Rere.Checkbox({"Enable fake style"}, {isChecked = fakeStylesEnabled})
            Rere.ComboArray({"Style"}, {index = fakeStyle}, {"Basic", "Boxing", "Karate", "MuayThai", "Wrestling"})
            Rere.Button({"Refresh fake style"})
            Rere.Text({"Status: Shell Mode | mapped: 5 | played: 0"})
            Rere.Separator()
            Rere.Text({"SLENDERMAN"})
            Rere.Checkbox({"Enable SlenderMan"}, {isChecked = controller.SlenderManState})
            Rere.InputText({"Idle Anim ID", "e.g. 92807081069528"}, {text = controller.SlenderManAnimIdState})
            Rere.Text({"Current Status: Disabled"})
            end
        end
        Rere.End()

        local tabDraw = Rere.Tab({"Draw"})
        allTabs[8] = tabDraw
        if tabDraw.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Text({"Status: " .. tostring(chalk.statusState:get())})
            Rere.Separator()
            Rere.Text({"Building Progress: " .. tostring(chalk.progressCountState:get())})
            Rere.Text({tostring(chalk.progressBarState:get())})
            Rere.Text({tostring(chalk.timeLeftState:get())})
            Rere.Separator()
            Rere.Text({"Equipment & Box Setup:"})
            Rere.SameLine()
                Rere.Button({"🎒 Grab Chalk"})
                Rere.Button({"🧽 Grab Eraser"})
                Rere.Button({"👁 Show Box"})
            Rere.End()
            Rere.Separator()
            Rere.PushConfig({ ContentWidth = UDim.new(0, 200) })
                Rere.InputText({"Text", "Type text to draw"}, {text = chalk.textState})
                Rere.Combo({"Font", "Default"}, { index = chalk.fontSelectedState })
                    Rere.Selectable({"Default", 1}, { index = chalk.fontSelectedState })
                    Rere.Selectable({"Bold", 2}, { index = chalk.fontSelectedState })
                Rere.End()
                Rere.InputText({"SecretKey", "Bypass 80s limit"}, {text = chalk.secretKeyState})
                Rere.Separator()
                Rere.SliderNum({"Thickness", 1, 1, 8, "%.0f px"}, {number = chalk.thicknessState})
                Rere.SliderNum({"Draw Delay", 5, 30, 150, "%.0f ms"}, {number = chalk.drawDelayState})
                Rere.SliderNum({"Stretch X", 5, 50, 300, "%.0f%%"}, {number = chalk.stretchXState})
                Rere.SliderNum({"Letter Spacing", 1, -5, 30, "%.0f px"}, {number = chalk.letterSpacingState})
            Rere.PopConfig()
            Rere.Separator()
            Rere.Text({"Drawing & Board Controls:"})
            Rere.SameLine()
                Rere.Button({"▶ OK & Start Drawing"})
                Rere.Button({"🧹 Clear Board"})
                Rere.Button({"🔄 Refresh Preview"})
            Rere.End()
            Rere.Separator()
            Rere.Text({"3D Board Box Quick Presets:"})
            Rere.SameLine()
                Rere.Button({"[Center]"})
                Rere.Button({"[Top Half]"})
                Rere.Button({"[Bottom Half]"})
                Rere.Button({"[Left Half]"})
                Rere.Button({"[Right Half]"})
                Rere.Button({"[Full Board]"})
            Rere.End()
            end
        end
        Rere.End()

        local tabStand = Rere.Tab({"Stand"})
        allTabs[9] = tabStand
        if tabStand.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.SeparatorText({"PAIRING"})
            Rere.Text({"Owner: @" .. tostring(LocalPlayer and LocalPlayer.Name or "Player")})
            Rere.Text({"Status: Not paired"})
            Rere.InputText({"Alt usernames", "Comma-separated exact Roblox usernames"}, {text = controller.StandAltState})
            Rere.Button({"Pair alt"})
            Rere.Button({"Unpair"})
            Rere.Button({"Copy Full Prod alt loader"})
            Rere.SeparatorText({"CHAT COMMANDS"})
            Rere.Text({"Type commands in game chat. Replace <user> with a username."})
            Rere.SeparatorText({"BASIC"})
            Rere.Text({"1 Main + 10 Stand; choose All Stands or one Stand in Full."})
            Rere.Text({"/st all /s | /st <StandUsername> /s"})
            Rere.Text({"/s - Summon"})
            Rere.Text({"/vanish - Hide"})
            Rere.Text({"/hardv - Hard vanish"})
            Rere.Text({"/stealth - Toggle stealth"})
            Rere.Text({"/cancel - Cancel action"})
            Rere.Text({"/drop - Drop carried player"})
            Rere.Text({"/exit - Stop this Stand session"})
            Rere.Text({"/unpair [alt username] - Clear pairing permanently"})
            Rere.Text({"/rejoin - Rejoin"})
            Rere.SeparatorText({"TARGET ACTIONS"})
            Rere.Text({"/kill <user>"})
            Rere.Text({"/stomp <user>"})
            Rere.Text({"/grab <user>"})
            Rere.Text({"/yeet <user>"})
            Rere.Text({"/knockvoid <user>"})
            Rere.Text({"/autokill <user> | /autokill off"})
            Rere.Text({"/torture <user> | /untorture <user> | /torturelist"})
            Rere.Text({"/deal <user> <damage>"})
            Rere.Text({"/mode 1 | /mode 2"})
            Rere.Text({"/depth <studs>"})
            Rere.SeparatorText({"MOVEMENT"})
            Rere.Text({"/wbring <user> [x y z] - Wrestling bring (main)"})
            Rere.Text({"/settp <x> <y> <z> - Save destination"})
            Rere.Text({"/tp <user> - Move user to saved destination"})
            Rere.Text({"/isolate <user>"})
            Rere.Text({"/jail <user>"})
            Rere.Text({"/farlands <user>"})
            Rere.SeparatorText({"PROTECTION"})
            Rere.Text({"/block <user> | /block off"})
            Rere.Text({"/save <user> | /save me"})
            Rere.Text({"/stopsave - Pause rescue"})
            Rere.Text({"/defense - Toggle defense"})
            Rere.Text({"/guardian <user> | /unguardian <user>"})
            Rere.Text({"/doubletrouble on | /doubletrouble off"})
            Rere.SeparatorText({"OWNERSHIP"})
            Rere.Text({"/own <user> - Delegate control"})
            Rere.Text({"/unown - Return control to owner"})
            Rere.Text({"/stand <user> | /stand reset"})
            Rere.Text({"/standadmin <user>"})
            Rere.Text({"/standadmin remove <user> | /standadmin clear"})
            Rere.SeparatorText({"EXTRAS"})
            Rere.Text({"/destroyvoid - Clear void parts"})
            Rere.Text({"/anim <asset id> [speed] | /anim stop"})
            Rere.Text({"/ball | /glasses"})
            Rere.Text({"/say <user> <text>"})
            Rere.Text({"/jack <user> | /jack off | /jackspeed <speed>"})
            end
        end
        Rere.End()

        local tabKeybinds = Rere.Tab({"Keybinds"})
        allTabs[10] = tabKeybinds
        if tabKeybinds.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.SeparatorText({"COMBAT"})
            renderBindRow("Light Attack", "LightAttack")
            renderBindRow("Heavy Attack", "HeavyAttack")
            renderBindRow("Block / Parry", "Block")
            renderBindRow("Evasive / Dash", "Evasive")
            renderBindRow("Equip / Stance", "Equip")
            Rere.SeparatorText({"DOWNED ACTIONS"})
            renderBindRow("Carry / Drop", "Carry")
            renderBindRow("Grip / Execute", "Grip")
            Rere.SeparatorText({"MOVEMENT & GENERAL"})
            renderBindRow("Sprint", "Sprint")
            renderBindRow("Interact", "Interact")
            renderBindRow("Emotes Menu", "Emotes")
            renderBindRow("Toggle Phone", "Phone")
            renderBindRow("First Person", "FirstPerson")
            Rere.SeparatorText({"SPORT MODES"})
            renderBindRow("Basketball Mode", "Basketball")
            renderBindRow("Volleyball Mode", "Volleyball")
            Rere.SeparatorText({"LARPKURAN TOOLS"})
            renderBindRow("Hide UI", "HideUI")
            renderBindRow("Auto Parry Toggle", "AutoParry")
            renderBindRow("Attack Velocity Toggle", "AttackVelocity")
            renderBindRow("Face At Target Toggle (All the time)", "FaceAtToggle")
            renderBindRow("Face Target Toggle", "FaceTarget")
            renderBindRow("Goon Toggle", "Jack")
            Rere.Separator()
            Rere.Button({"Reset All to Game Defaults", UDim2.fromOffset(314, 26)})
            end
        end
        Rere.End()

        local tabRoll = Rere.Tab({"Roll"})
        allTabs[11] = tabRoll
        if tabRoll.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Text({"AUTO ROLL / REROLLER"})
            Rere.Separator()
            Rere.ComboArray({"Stat to Reroll"}, {index = autoroll.CurrentStatState}, autoroll.Stats)
            Rere.Text({"Current Value: Basic [Common]"})
            Rere.InputText({"Target / Desired", "Exact or partial match (e.g. CQC, Ali)"}, {text = autoroll.DesiredValueState})
            Rere.SliderNum({"Delay (seconds)", 0.5, 1.0, 3, "%.2f s"}, {number = autoroll.RollDelayState})
            Rere.Checkbox({"Slow mode (wait for decision) (?)"}, {isChecked = autoroll.SlowModeState})
            Rere.SliderNum({"Slow mode wait (seconds)", 1, 7, 20, "%.0f s"}, {number = autoroll.SlowModeDurationState})
            Rere.Checkbox({"Stop on Legendary or above (?)"}, {isChecked = autoroll.StopOnLegendaryState})
            Rere.Checkbox({"Auto Undo non-targets if undoable (?)"}, {isChecked = autoroll.AutoUndoState})
            Rere.Separator()
            Rere.Text({"AUTO SKIP SETTINGS"})
            Rere.InputText({"Skip Items (comma-separated)", "e.g. Basic, Karate, Polo"}, {text = autoroll.SkipItemsState})
            Rere.InputText({"Skip Rarities (comma-separated)", "e.g. Common, Uncommon, Rare"}, {text = autoroll.SkipRaritiesState})
            Rere.Checkbox({"Skip Common"}, {isChecked = autoroll.SkipCommonState})
            Rere.Checkbox({"Skip Uncommon"}, {isChecked = autoroll.SkipUncommonState})
            Rere.Checkbox({"Skip Rare"}, {isChecked = autoroll.SkipRareState})
            Rere.Checkbox({"Skip Epic"}, {isChecked = autoroll.SkipEpicState})
            Rere.Separator()
            Rere.Button({"Start Auto Roll", UDim2.fromOffset(314, 26)})
            Rere.Text({"Status: Idle (Preview Shell)"})
            Rere.Text({"Rolls completed: 0"})
            Rere.Separator()
            local headerRef = Rere.CollapsingHeader({"AVAILABLE ROLLABLES REFERENCE"})
            if headerRef.state.isUncollapsed.value then
                Rere.Text({"FIGHT STYLES:"})
                Rere.Text({"• Common: Basic"})
                Rere.Text({"• Uncommon: Karate, MuayThai, Slugger, Kickboxing"})
                Rere.Text({"• Epic: Boxing, Striker"})
                Rere.Text({"• Legendary: Wrestling, Capoeira, Kure, Hakari, Kyokushin"})
                Rere.Text({"• ??? (Mystery): Ali, WingChun, CQC"})
            end
            Rere.End()
            end
        end
        Rere.End()

        local tabConfig = Rere.Tab({"Config"})
        allTabs[12] = tabConfig
        if tabConfig.state.isOpened.value then
            if shouldShowWarning() then
                renderFullWarningScreen()
            else
                renderLockedBanner()
            Rere.Text({"Full Prod | Shell Preview Edition"})
            Rere.Checkbox({"Anti-Mod"}, {isChecked = controller.AntiModState})
            if config and controller.AntiModState:get() ~= config.AntiMod then
                controller.SetAntiMod(controller.AntiModState:get())
            end
            Rere.Checkbox({"Anonymous Mode"}, {isChecked = controller.AnonymousModeState})
            Rere.Text({"Hide your Larpkurian identity from other users."})
            Rere.Separator()
            Rere.ComboArray({"Language"}, {index = controller.LanguageState}, {"English", "ZH-TW"})
            Rere.Separator()
            Rere.Checkbox({"Hide health bar"}, {isChecked = controller.HideHealthBarState})
            Rere.Checkbox({"Hide stamina bar"}, {isChecked = controller.HideStaminaBarState})
            Rere.Checkbox({"Hide heavy CD bar"}, {isChecked = controller.HideHeavyBarState})
            Rere.Separator()
            Rere.Button({"Hide UI keybind: " .. tostring(controller.UIKeyState:get())})
            Rere.Separator()
            Rere.Button({"Save config"})
            Rere.Button({"Load config"})
            Rere.Button({"Reset config"})
            Rere.Separator()
            Rere.Button({"Ban yourself"})
            Rere.Text({"Persistent file: " .. CONFIG_FILE})
            end
        end
        Rere.End()

        Rere.End()
    end
    Rere.End()
end)
