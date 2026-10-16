local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local Games = {
    PlaceIds = {
        [4924922222] = {
            Name = "Brookhaven v1.6",
            Script = "BrookhavenSource"
        },
        [136801880565837] = {
            Name = "Flick v1",
            Script = "FlickSource"
        }
    },
    GameIds = {
        [6161049307] = {
            Name = "Pixel Blade v1.1",
            Script = "PixelBladeSource"
        },
        [10200395747] = {
            Name = "Grow a Garden 2 v1.2",
            Script = "GrowAGarden2Source"
        },
        [66654135] = {
            Name = "Murder Mystery 2 v1.3",
            Script = "MurderMystery2Source"
        },
        [4777817887] = {
            Name = "Blade Ball v1.3",
            Script = "BladeBallSource"
        },
        [1119466531] = {
            Name = "Legends Of Speed v1.3",
            Script = "LegendOfSpeedSource"
        }
    }
}


local placeId = game.PlaceId
local CurrentGame = Games.PlaceIds[placeId]


if not CurrentGame then
    CurrentGame = Games.GameIds[game.GameId]
end


local isSupported = CurrentGame ~= nil

local Languages = {
    { Code = "en", Name = "English", Display = "🇺🇸 English" },
    { Code = "ar", Name = "Arabic", Display = "🇸🇦 العربية" },
    { Code = "es", Name = "Española", Display = "🇪🇸 Española" },
    { Code = "tr", Name = "Turkey", Display = "🇹🇷 Türkçe" },
    { Code = "ru", Name = "Russian", Display = "🇷🇺 Русский" },
    { Code = "fr", Name = "France", Display = "🇫🇷 Français" },
    { Code = "de", Name = "Germany", Display = "🇩🇪 Deutsch" },
    { Code = "pt", Name = "Brazil", Display = "🇧🇷 Português" }
}

local SkipTranslations = {
    en = "Skip",
    ar = "تخطي",
    es = "Omitir",
    tr = "Geç",
    ru = "Пропустить",
    fr = "Passer",
    de = "Überspringen",
    pt = "Pular"
}

local CheckBoxTranslations = {
    en = "Don't show this again",
    ar = "عدم إظهار هذه القائمة مجدداً",
    es = "No volver a mostrar",
    tr = "Bunu tekrar gösterme",
    ru = "Больше не показывать",
    fr = "Ne plus afficher",
    de = "Nicht mehr anzeigen",
    pt = "Não mostrar novamente"
}

local function saveLanguageSetting(value)
    pcall(function()
        local json = {}
        local ok, data = pcall(readfile, "dropdowns.json")
        if ok and data then
            json = game:GetService("HttpService"):JSONDecode(data) or {}
        end
        json["LanguageSetting"] = value
        writefile("dropdowns.json", game:GetService("HttpService"):JSONEncode(json))
    end)
end

local function getSavedLanguageCode()
    local code = getgenv().SP_Hub_Language
    if code then return code end
    code = "en"
    pcall(function()
        local ok, data = pcall(readfile, "dropdowns.json")
        if ok and data then
            local json = game:GetService("HttpService"):JSONDecode(data)
            local savedName = json and json["LanguageSetting"]
            if savedName then
                local Codes = {
                    English = "en",
                    Arabic = "ar",
                    ["Española"] = "es",
                    Turkey = "tr",
                    Russian = "ru",
                    France = "fr",
                    Germany = "de",
                    Brazil = "pt"
                }
                code = Codes[savedName] or "en"
            end
        end
    end)
    return code
end

local function saveDontShowSetting(value)
    pcall(function()
        local json = {}
        local ok, data = pcall(readfile, "dropdowns.json")
        if ok and data then
            json = game:GetService("HttpService"):JSONDecode(data) or {}
        end
        json["DontShowLanguageMenu"] = value
        writefile("dropdowns.json", game:GetService("HttpService"):JSONEncode(json))
    end)
end

local function getSavedDontShowSetting()
    local dontShow = false
    pcall(function()
        local ok, data = pcall(readfile, "dropdowns.json")
        if ok and data then
            local json = game:GetService("HttpService"):JSONDecode(data)
            if json and json["DontShowLanguageMenu"] ~= nil then
                dontShow = json["DontShowLanguageMenu"]
            end
        end
    end)
    return dontShow
end

local oldUI = PlayerGui:FindFirstChild("Loading SP Hub") or CoreGui:FindFirstChild("Loading SP Hub")
if oldUI then oldUI:Destroy() end

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "Loading SP Hub"
LoadingGui.ResetOnSpawn = false
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function()
    LoadingGui.Parent = CoreGui
end)
if not successParent then
    LoadingGui.Parent = PlayerGui
end

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "Loading Screen"
LoadingFrame.Parent = LoadingGui
LoadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingFrame.Size = UDim2.new(0, 0, 0, 0)
LoadingFrame.ClipsDescendants = true
LoadingFrame.Visible = false

local UICorner_Load = Instance.new("UICorner")
UICorner_Load.CornerRadius = UDim.new(0, 20)
UICorner_Load.Parent = LoadingFrame

local UIStroke_Load = Instance.new("UIStroke")
UIStroke_Load.Thickness = 2
UIStroke_Load.Color = Color3.fromRGB(40, 40, 40)
UIStroke_Load.Parent = LoadingFrame

local LoadingRatio = Instance.new("UIAspectRatioConstraint")
LoadingRatio.AspectRatio = 1.3
LoadingRatio.Parent = LoadingFrame

local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "LogoImage"
LogoImage.Parent = LoadingFrame
LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LogoImage.BackgroundTransparency = 1
LogoImage.BorderSizePixel = 0
LogoImage.Position = UDim2.new(0.05, 0, 0.05, 0)
LogoImage.Size = UDim2.new(0.9, 0, 0.9, 0)
LogoImage.Image = "rbxassetid://95309586448728"
LogoImage.Visible = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = LoadingGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 1.5, 0)
MainFrame.Size = UDim2.new(0.32, 0, 0.32, 0)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 20)
UICorner_Main.Parent = MainFrame

local UIStroke_Main = Instance.new("UIStroke")
UIStroke_Main.Thickness = 2
UIStroke_Main.Color = Color3.fromRGB(45, 45, 45)
UIStroke_Main.Parent = MainFrame

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 1.48
UIAspectRatioConstraint.Parent = MainFrame

local SPHub = Instance.new("TextLabel")
SPHub.Name = "SP Hub"
SPHub.Parent = MainFrame
SPHub.BackgroundTransparency = 1
SPHub.Position = UDim2.new(0.1, 0, 0.08, 0)
SPHub.Size = UDim2.new(0.8, 0, 0.22, 0)
SPHub.Font = Enum.Font.FredokaOne
SPHub.Text = "SP Hub"
SPHub.TextColor3 = Color3.fromRGB(255, 255, 255)
SPHub.TextScaled = true
SPHub.ZIndex = 2

local SPHubGlow = Instance.new("Frame")
SPHubGlow.Name = "UnderGlow"
SPHubGlow.Parent = SPHub
SPHubGlow.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
SPHubGlow.BorderSizePixel = 0
SPHubGlow.Position = UDim2.new(0.4, 0, 1.05, 0)
SPHubGlow.Size = UDim2.new(0.2, 0, 0, 2)

local GameNameLabel = Instance.new("TextLabel")
GameNameLabel.Name = "GameNameLabel"
GameNameLabel.Parent = MainFrame
GameNameLabel.BackgroundTransparency = 1
GameNameLabel.Position = UDim2.new(0.1, 0, 0.32, 0)
GameNameLabel.Size = UDim2.new(0.8, 0, 0.16, 0)
GameNameLabel.Font = Enum.Font.FredokaOne
GameNameLabel.Text = isSupported and CurrentGame.Name or "Unsupported Game"
GameNameLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
GameNameLabel.TextScaled = true

local ExitButton = Instance.new("TextButton")
ExitButton.Name = "ExitButton"
ExitButton.Parent = MainFrame
ExitButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ExitButton.Position = UDim2.new(0.88, 0, 0.06, 0)
ExitButton.Size = UDim2.new(0.08, 0, 0.12, 0)
ExitButton.Font = Enum.Font.SourceSansBold
ExitButton.Text = "X"
ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitButton.TextScaled = true
ExitButton.ZIndex = 3

local UICorner_Exit = Instance.new("UICorner")
UICorner_Exit.CornerRadius = UDim.new(1, 0)
UICorner_Exit.Parent = ExitButton

local UIAspectRatioConstraint_Exit = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint_Exit.AspectRatio = 1
UIAspectRatioConstraint_Exit.Parent = ExitButton

ExitButton.MouseEnter:Connect(function()
    TweenService:Create(ExitButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 90,
        BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    }):Play()
end)
ExitButton.MouseLeave:Connect(function()
    TweenService:Create(ExitButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = 0,
        BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    }):Play()
end)

ExitButton.MouseButton1Click:Connect(function()
    LoadingGui:Destroy()
end)

local function applyHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = hoverColor,
            Size = button.Size + UDim2.new(0.02, 0, 0.02, 0),
            Position = button.Position - UDim2.new(0.01, 0, 0.01, 0)
        }):Play()
        if button:FindFirstChild("UIStroke") then
            TweenService:Create(button.UIStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 60, 60)}):Play()
        end
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = defaultColor,
            Size = button.Size - UDim2.new(0.02, 0, 0.02, 0),
            Position = button.Position + UDim2.new(0.01, 0, 0.01, 0)
        }):Play()
        if button:FindFirstChild("UIStroke") then
            TweenService:Create(button.UIStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end)
end

local function makeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputState == Enum.UserInputState.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(MainFrame, SPHub)

local function closeMenu()
    local slideOut = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 1.5, 0)
    })
    slideOut:Play()
    slideOut.Completed:Wait()
    LoadingGui:Destroy()
end

local function launchGameScript(langCode)
    getgenv().SP_Hub_Language = langCode
    
    local ok, data = pcall(readfile, "dropdowns.json")
    if ok and data then
        local json = game:GetService("HttpService"):JSONDecode(data)
        local savedName = json and json["LanguageSetting"]
        if not savedName then
            local NameMap = {
                en = "English",
                ar = "Arabic",
                es = "Española",
                tr = "Turkey",
                ru = "Russian",
                fr = "France",
                de = "Germany",
                pt = "Brazil"
            }
            saveLanguageSetting(NameMap[langCode] or "English")
        end
    end

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SP Hub",
        Text = "The Script Will Be Load...",
        Duration = 3
    })

    local scriptUrl = "https://raw.githubusercontent.com/as6cd0/SP_Hub/main/" .. CurrentGame.Script
    pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
end

local SkipButton = nil
local CheckBoxText = nil

local function updateUIText(langCode)
    local isArabic = (langCode == "ar")
    if isArabic then
        SPHub.Text = "اختر اللغة"
        GameNameLabel.Text = "اللغة الحالية: العربية"
    else
        local langMap = {
            en = "English",
            es = "Española",
            tr = "Türkçe",
            ru = "Русский",
            fr = "Français",
            de = "Deutsch",
            pt = "Português"
        }
        local currentName = langMap[langCode] or "English"
        SPHub.Text = "Select Language"
        GameNameLabel.Text = "Current Language: " .. currentName
    end
    if SkipButton then
        SkipButton.Text = SkipTranslations[langCode] or "Skip / تخطي"
    end
    if CheckBoxText then
        CheckBoxText.Text = CheckBoxTranslations[langCode] or "Don't show this again"
    end
end

if isSupported then
    local PlayButton = Instance.new("TextButton")
    PlayButton.Name = "PlayButton"
    PlayButton.Parent = MainFrame
    PlayButton.Position = UDim2.new(0.3, 0, 0.62, 0)
    PlayButton.Size = UDim2.new(0.4, 0, 0.22, 0)
    PlayButton.Font = Enum.Font.SourceSansBold
    PlayButton.Text = "Play"
    PlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayButton.TextScaled = true
    PlayButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local UICorner_Play = Instance.new("UICorner")
    UICorner_Play.CornerRadius = UDim.new(0, 12)
    UICorner_Play.Parent = PlayButton

    local UIStroke_Play = Instance.new("UIStroke")
    UIStroke_Play.Thickness = 1.5
    UIStroke_Play.Color = Color3.fromRGB(60, 60, 60)
    UIStroke_Play.Parent = PlayButton

    applyHoverEffect(PlayButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(45, 45, 45))

    local dontShowAgain = false

    local DontShowFrame = Instance.new("Frame")
    DontShowFrame.Name = "DontShowFrame"
    DontShowFrame.Parent = MainFrame
    DontShowFrame.BackgroundTransparency = 1
    DontShowFrame.Position = UDim2.new(0.15, 0, 0.79, 0)
    DontShowFrame.Size = UDim2.new(0.7, 0, 0.06, 0)
    DontShowFrame.Visible = false

    local CheckBoxButton = Instance.new("TextButton")
    CheckBoxButton.Name = "CheckBoxButton"
    CheckBoxButton.Parent = DontShowFrame
    CheckBoxButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CheckBoxButton.Size = UDim2.new(1, 0, 1, 0)
    CheckBoxButton.Text = ""
    CheckBoxButton.BackgroundTransparency = 0

    local CheckBoxRatio = Instance.new("UIAspectRatioConstraint")
    CheckBoxRatio.AspectRatio = 1
    CheckBoxRatio.Parent = CheckBoxButton

    local CheckBoxCorner = Instance.new("UICorner")
    CheckBoxCorner.CornerRadius = UDim.new(0, 4)
    CheckBoxCorner.Parent = CheckBoxButton

    local CheckBoxStroke = Instance.new("UIStroke")
    CheckBoxStroke.Thickness = 1.5
    CheckBoxStroke.Color = Color3.fromRGB(60, 60, 60)
    CheckBoxStroke.Parent = CheckBoxButton

    local CheckMark = Instance.new("TextLabel")
    CheckMark.Name = "CheckMark"
    CheckMark.Parent = CheckBoxButton
    CheckMark.BackgroundTransparency = 1
    CheckMark.Size = UDim2.new(1, 0, 1, 0)
    CheckMark.Font = Enum.Font.SourceSansBold
    CheckMark.Text = ""
    CheckMark.TextColor3 = Color3.fromRGB(255, 60, 60)
    CheckMark.TextScaled = true

    CheckBoxText = Instance.new("TextLabel")
    CheckBoxText.Name = "CheckBoxText"
    CheckBoxText.Parent = DontShowFrame
    CheckBoxText.BackgroundTransparency = 1
    CheckBoxText.Position = UDim2.new(0.12, 0, 0, 0)
    CheckBoxText.Size = UDim2.new(0.88, 0, 1, 0)
    CheckBoxText.Font = Enum.Font.SourceSansBold
    CheckBoxText.TextColor3 = Color3.fromRGB(180, 180, 180)
    CheckBoxText.TextXAlignment = Enum.TextXAlignment.Left
    CheckBoxText.TextScaled = true

    local TriggerButton = Instance.new("TextButton")
    TriggerButton.Name = "TriggerButton"
    TriggerButton.Parent = DontShowFrame
    TriggerButton.BackgroundTransparency = 1
    TriggerButton.Size = UDim2.new(1, 0, 1, 0)
    TriggerButton.Text = ""
    TriggerButton.ZIndex = 4

    TriggerButton.MouseButton1Click:Connect(function()
        dontShowAgain = not dontShowAgain
        CheckMark.Text = dontShowAgain and "✓" or ""
        TweenService:Create(CheckBoxStroke, TweenInfo.new(0.2), {
            Color = dontShowAgain and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 60, 60)
        }):Play()
    end)

    local ButtonsFrame = Instance.new("Frame")
    ButtonsFrame.Name = "ButtonsFrame"
    ButtonsFrame.Parent = MainFrame
    ButtonsFrame.BackgroundTransparency = 1
    ButtonsFrame.Position = UDim2.new(0.05, 0, 0.30, 0)
    ButtonsFrame.Size = UDim2.new(0.9, 0, 0.46, 0)
    ButtonsFrame.Visible = false

    local UIGridLayout = Instance.new("UIGridLayout")
    UIGridLayout.Parent = ButtonsFrame
    UIGridLayout.CellSize = UDim2.new(0.44, 0, 0.20, 0)
    UIGridLayout.CellPadding = UDim2.new(0.04, 0, 0.03, 0)
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    SkipButton = Instance.new("TextButton")
    SkipButton.Name = "SkipButton"
    SkipButton.Parent = MainFrame
    SkipButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SkipButton.Position = UDim2.new(0.35, 0, 0.88, 0)
    SkipButton.Size = UDim2.new(0.3, 0, 0.08, 0)
    SkipButton.Font = Enum.Font.SourceSansBold
    SkipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    SkipButton.TextScaled = true
    SkipButton.Visible = false

    local UICorner_Skip = Instance.new("UICorner")
    UICorner_Skip.CornerRadius = UDim.new(0, 8)
    UICorner_Skip.Parent = SkipButton

    local UIStroke_Skip = Instance.new("UIStroke")
    UIStroke_Skip.Thickness = 1
    UIStroke_Skip.Color = Color3.fromRGB(40, 40, 40)
    UIStroke_Skip.Parent = SkipButton

    applyHoverEffect(SkipButton, Color3.fromRGB(25, 25, 25), Color3.fromRGB(35, 35, 35))

    SkipButton.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(SkipButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = SkipButton.Size - UDim2.new(0.04, 0, 0.04, 0),
            Position = SkipButton.Position + UDim2.new(0.02, 0, 0.02, 0)
        })
        clickTween:Play()
        clickTween.Completed:Wait()

        saveDontShowSetting(dontShowAgain)
        local activeCode = getSavedLanguageCode()
        task.spawn(launchGameScript, activeCode)
        closeMenu()
    end)

    for _, lang in ipairs(Languages) do
        local btn = Instance.new("TextButton")
        btn.Name = lang.Name .. "Button"
        btn.Parent = ButtonsFrame
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = lang.Display
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.SourceSansBold

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Thickness = 1.5
        btnStroke.Color = Color3.fromRGB(60, 60, 60)
        btnStroke.Parent = btn

        applyHoverEffect(btn, Color3.fromRGB(30, 30, 30), Color3.fromRGB(45, 45, 45))

        btn.MouseButton1Click:Connect(function()
            local clickTween = TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = btn.Size - UDim2.new(0.04, 0, 0.04, 0),
                Position = btn.Position + UDim2.new(0.02, 0, 0.02, 0)
            })
            clickTween:Play()
            clickTween.Completed:Wait()

            saveLanguageSetting(lang.Name)
            saveDontShowSetting(dontShowAgain)
            updateUIText(lang.Code)

            task.wait(0.3)
            task.spawn(launchGameScript, lang.Code)
            closeMenu()
        end)
    end

    PlayButton.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(PlayButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = PlayButton.Size - UDim2.new(0.04, 0, 0.04, 0),
            Position = PlayButton.Position + UDim2.new(0.02, 0, 0.02, 0)
        })
        clickTween:Play()
        clickTween.Completed:Wait()

        if getSavedDontShowSetting() then
            local activeCode = getSavedLanguageCode()
            task.spawn(launchGameScript, activeCode)
            closeMenu()
            return
        end

        PlayButton.Visible = false
        ExitButton.Visible = false

        local activeCode = getSavedLanguageCode()
        updateUIText(activeCode)

        TweenService:Create(SPHub, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.05, 0, 0.05, 0),
            Size = UDim2.new(0.9, 0, 0.12, 0)
        }):Play()

        TweenService:Create(GameNameLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.05, 0, 0.22, 0),
            Size = UDim2.new(0.9, 0, 0.08, 0)
        }):Play()

        local resizeTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.35, 0, 0.45, 0)
        })
        local ratioTween = TweenService:Create(UIAspectRatioConstraint, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            AspectRatio = 1.2
        })
        resizeTween:Play()
        ratioTween:Play()
        resizeTween.Completed:Wait()

        ButtonsFrame.Visible = true
        DontShowFrame.Visible = true
        SkipButton.Visible = true
    end)
else
    local AutoClickerButton = Instance.new("TextButton")
    AutoClickerButton.Name = "AutoClickerButton"
    AutoClickerButton.Parent = MainFrame
    AutoClickerButton.Position = UDim2.new(0.08, 0, 0.62, 0)
    AutoClickerButton.Size = UDim2.new(0.38, 0, 0.22, 0)
    AutoClickerButton.Font = Enum.Font.SourceSansBold
    AutoClickerButton.Text = "Auto Clicker"
    AutoClickerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoClickerButton.TextScaled = true
    AutoClickerButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local UICorner_AC = Instance.new("UICorner")
    UICorner_AC.CornerRadius = UDim.new(0, 12)
    UICorner_AC.Parent = AutoClickerButton

    local UIStroke_AC = Instance.new("UIStroke")
    UIStroke_AC.Thickness = 1.5
    UIStroke_AC.Color = Color3.fromRGB(60, 60, 60)
    UIStroke_AC.Parent = AutoClickerButton

    applyHoverEffect(AutoClickerButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(45, 45, 45))

    AutoClickerButton.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(AutoClickerButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = AutoClickerButton.Size - UDim2.new(0.04, 0, 0.04, 0),
            Position = AutoClickerButton.Position + UDim2.new(0.02, 0, 0.02, 0)
        })
        clickTween:Play()
        clickTween.Completed:Wait()

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SP Hub",
            Text = "Loading Auto Clicker...",
            Duration = 3
        })

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/main/AutoClicker"))()
        end)

        if not success then
            warn("Error loading Auto Clicker: " .. tostring(err))
        else
            LoadingGui:Destroy()
        end
    end)

    local AnimationsButton = Instance.new("TextButton")
    AnimationsButton.Name = "AnimationsButton"
    AnimationsButton.Parent = MainFrame
    AnimationsButton.Position = UDim2.new(0.54, 0, 0.62, 0)
    AnimationsButton.Size = UDim2.new(0.38, 0, 0.22, 0)
    AnimationsButton.Font = Enum.Font.SourceSansBold
    AnimationsButton.Text = "Animations"
    AnimationsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AnimationsButton.TextScaled = true
    AnimationsButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local UICorner_Anim = Instance.new("UICorner")
    UICorner_Anim.CornerRadius = UDim.new(0, 12)
    UICorner_Anim.Parent = AnimationsButton

    local UIStroke_Anim = Instance.new("UIStroke")
    UIStroke_Anim.Thickness = 1.5
    UIStroke_Anim.Color = Color3.fromRGB(60, 60, 60)
    UIStroke_Anim.Parent = AnimationsButton

    applyHoverEffect(AnimationsButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(45, 45, 45))

    AnimationsButton.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(AnimationsButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = AnimationsButton.Size - UDim2.new(0.04, 0, 0.04, 0),
            Position = AnimationsButton.Position + UDim2.new(0.02, 0, 0.02, 0)
        })
        clickTween:Play()
        clickTween.Completed:Wait()

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SP Hub",
            Text = "Loading Animations...",
            Duration = 3
        })

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/main/Animations"))()
        end)

        if not success then
            warn("Error loading Animations: " .. tostring(err))
        else
            LoadingGui:Destroy()
        end
    end)
end

local function runLoadingSequence()
    LoadingFrame.Visible = true
    
    local openTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.3, 0, 0.3, 0)
    })
    openTween:Play()
    openTween.Completed:Wait()

    LogoImage.Visible = true
    LogoImage.ImageTransparency = 1
    local logoFade = TweenService:Create(LogoImage, TweenInfo.new(0.3), {ImageTransparency = 0})
    logoFade:Play()
    logoFade.Completed:Wait()

    task.wait(1)

    local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeLogo = TweenService:Create(LogoImage, fadeInfo, {ImageTransparency = 1})
    fadeLogo:Play()
    fadeLogo.Completed:Wait()

    local fadeBgInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local elementsFadeOut = {
        TweenService:Create(LoadingFrame, fadeBgInfo, {BackgroundTransparency = 1}),
        TweenService:Create(UIStroke_Load, fadeBgInfo, {Transparency = 1})
    }
    for _, tween in ipairs(elementsFadeOut) do tween:Play() end
    elementsFadeOut[1].Completed:Wait()
    LoadingFrame.Visible = false

    MainFrame.Visible = true
    local menuSlide = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    menuSlide:Play()
end

task.spawn(runLoadingSequence)
