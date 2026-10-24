-- Ash Hub | Universal | Xeno & Delta
-- UI: AshUi (custom) | Developer: @polarwzf - @silvazz7_hh

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("AshHubUI") then CoreGui.AshHubUI:Destroy() end

local Config = {
    SavedPos = nil, InstantSteal = false, Noclip = false,
    Speed = 16, BaseSpeed = 16, DefaultPos = nil, isTeleporting = false
}

local Yellow = Color3.fromRGB(255, 200, 0)
local DarkBg = Color3.fromRGB(20, 20, 20)
local PanelBg = Color3.fromRGB(28, 28, 28)
local TextColor = Color3.fromRGB(220, 220, 220)

local AshUI = {}
AshUI.__index = AshUI

local function MakeDraggable(frame, dragArea)
    local dragging, dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function AshUI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AshHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui

    local isAuthorized = false
    local MainFrame

    -- [ SISTEMA DE KEY - CORRIGIDO ] --
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 300, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    KeyFrame.BackgroundColor3 = DarkBg
    KeyFrame.Parent = ScreenGui
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.Position = UDim2.new(0, 0, 0, 15)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Text = "LOGIN"
    KeyTitle.TextColor3 = Yellow
    KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 24
    KeyTitle.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Position = UDim2.new(0.1, 0, 0, 65)
    KeyInput.BackgroundColor3 = PanelBg
    KeyInput.TextColor3 = TextColor
    KeyInput.PlaceholderText = "Insira a Key..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 16
    KeyInput.Text = ""
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0.8, 0, 0, 40)
    KeyBtn.Position = UDim2.new(0.1, 0, 0, 130)
    KeyBtn.BackgroundColor3 = Yellow
    KeyBtn.Text = "ENTRAR"
    KeyBtn.TextColor3 = DarkBg
    KeyBtn.Font = Enum.Font.GothamBold; KeyBtn.TextSize = 16
    KeyBtn.Parent = KeyFrame
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)

    -- [ BOTÃO PRINCIPAL ] --
    local DragBtn = Instance.new("ImageButton")
    DragBtn.Size = UDim2.new(0, 60, 0, 60)
    DragBtn.Position = UDim2.new(0, 50, 0, 50)
    DragBtn.Image = "rbxassetid://137983079191737"
    DragBtn.BackgroundColor3 = DarkBg
    DragBtn.Parent = ScreenGui
    DragBtn.Visible = false
    Instance.new("UICorner", DragBtn).CornerRadius = UDim.new(1, 0)
    local UIStroke = Instance.new("UIStroke", DragBtn)
    UIStroke.Color = Yellow; UIStroke.Thickness = 2

    -- Lógica do Botão de Key (Aceita "ash", "ashhub", "ash hub", etc)
    local function checkKey()
        local cleanText = string.lower(KeyInput.Text)
        cleanText = string.gsub(cleanText, "%s+", "") -- Remove todos os espaços
        
        if cleanText == "ashhub" or cleanText == "ash" then
            isAuthorized = true
            KeyFrame:Destroy()
            DragBtn.Visible = true
            print("[Ash Hub] Acesso concedido.")
        else
            KeyInput.Text = ""
            KeyBtn.Text = "KEY INCORRETA"
            KeyBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            KeyBtn.Text = "ENTRAR"
            KeyBtn.TextColor3 = DarkBg
        end
    end

    KeyBtn.MouseButton1Click:Connect(checkKey)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then checkKey() end
    end)

    -- [ MENU PRINCIPAL ] --
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 700, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -210)
    MainFrame.BackgroundColor3 = DarkBg
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Color = Yellow; stroke.Thickness = 1.5; stroke.Transparency = 0.8

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 80, 1, 0)
    Sidebar.BackgroundColor3 = PanelBg
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, -80, 0, 60)
    Header.Position = UDim2.new(0, 80, 0, 0)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title; Title.TextColor3 = Yellow
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Profile
    local Headshot = Instance.new("ImageLabel")
    Headshot.Size = UDim2.new(0, 40, 0, 40)
    Headshot.Position = UDim2.new(0.5, -20, 0, 10)
    Headshot.BackgroundColor3 = DarkBg
    Headshot.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    Headshot.Parent = Sidebar
    Instance.new("UICorner", Headshot).CornerRadius = UDim.new(1, 0)
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 0, 0, 55)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = LocalPlayer.DisplayName
    NameLabel.TextColor3 = Yellow; NameLabel.Font = Enum.Font.GothamBold; NameLabel.TextSize = 12
    NameLabel.Parent = Sidebar

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -100, 1, -80)
    PageContainer.Position = UDim2.new(0, 90, 0, 70)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    MakeDraggable(MainFrame, Header)
    
    -- Drag & Toggle
    local btnDragging, btnDragStart, btnStartPos, moved
    DragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true; moved = false; btnDragStart = input.Position; btnStartPos = DragBtn.Position
        end
    end)
    DragBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = false
            if not moved and isAuthorized then
                MainFrame.Visible = not MainFrame.Visible
                if MainFrame.Visible then
                    MainFrame.Size = UDim2.new(0, 0, 0, 0)
                    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 420)}):Play()
                end
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnDragStart
            if delta.Magnitude > 5 then moved = true end
            DragBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end)

    -- Atalho CTRL
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.LeftControl then
            if isAuthorized then
                MainFrame.Visible = not MainFrame.Visible
                if MainFrame.Visible then
                    MainFrame.Size = UDim2.new(0, 0, 0, 0)
                    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 420)}):Play()
                end
            end
        end
    end)

    local Pages = {}
    local tabButtons = {}
    
    function Pages:NewPage(name)
        local PageFrame = Instance.new("Frame")
        PageFrame.Size = UDim2.new(1, 0, 1, 0)
        PageFrame.BackgroundTransparency = 1
        PageFrame.Visible = false
        PageFrame.Parent = PageContainer
        
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.BackgroundTransparency = 1
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Yellow
        Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Scroll.Parent = PageFrame

        local Layout = Instance.new("UIListLayout")
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = Scroll
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 50, 0, 50)
        TabBtn.Position = UDim2.new(0, 15, 0, 90 + (#tabButtons * 60))
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)

        table.insert(tabButtons, TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do
                if p:IsA("Frame") then p.Visible = false end
            end
            for _, b in pairs(tabButtons) do
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end
            PageFrame.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Yellow, TextColor3 = DarkBg}):Play()
        end)

        if #tabButtons == 1 then
            PageFrame.Visible = true
            TabBtn.BackgroundColor3 = Yellow
            TabBtn.TextColor3 = DarkBg
        end
        return Scroll
    end

    function AshUI:AddSection(Scroll, text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -20, 0, 25)
        Label.BackgroundTransparency = 1
        Label.Text = text; Label.TextColor3 = Yellow
        Label.Font = Enum.Font.GothamBold; Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Scroll
    end

    function AshUI:AddToggle(Scroll, text, default, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -20, 0, 45)
        Container.BackgroundColor3 = PanelBg
        Container.Parent = Scroll
        Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text; Label.TextColor3 = TextColor
        Label.Font = Enum.Font.Gotham; Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Container

        local ToggleBg = Instance.new("Frame")
        ToggleBg.Size = UDim2.new(0, 40, 0, 20)
        ToggleBg.Position = UDim2.new(1, -55, 0.5, -10)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleBg.Parent = Container
        Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

        local ToggleDot = Instance.new("Frame")
        ToggleDot.Size = UDim2.new(0, 16, 0, 16)
        ToggleDot.Position = UDim2.new(0, 2, 0.5, -8)
        ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleDot.Parent = ToggleBg
        Instance.new("UICorner", ToggleDot).CornerRadius = UDim.new(1, 0)

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundTransparency = 1; Btn.Text = ""
        Btn.Parent = Container

        local isOn = default
        if isOn then ToggleBg.BackgroundColor3 = Yellow; ToggleDot.Position = UDim2.new(1, -18, 0.5, -8) end

        Btn.MouseButton1Click:Connect(function()
            isOn = not isOn
            if isOn then
                TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Yellow}):Play()
                TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            else
                TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
            if callback then callback(isOn) end
        end)
    end

    function AshUI:AddButton(Scroll, text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -20, 0, 45)
        Btn.BackgroundColor3 = PanelBg
        Btn.Text = text; Btn.TextColor3 = TextColor
        Btn.Font = Enum.Font.Gotham; Btn.TextSize = 14
        Btn.Parent = Scroll
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Yellow}):Play() end)
        Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = PanelBg, TextColor3 = TextColor}):Play() end)
        Btn.MouseButton1Click:Connect(callback)
    end

    function AshUI:AddSlider(Scroll, text, min, max, default, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -20, 0, 55)
        Container.BackgroundColor3 = PanelBg
        Container.Parent = Scroll
        Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -30, 0, 25)
        Label.Position = UDim2.new(0, 15, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = TextColor
        Label.Font = Enum.Font.Gotham; Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Container

        local BarBg = Instance.new("Frame")
        BarBg.Size = UDim2.new(1, -30, 0, 6)
        BarBg.Position = UDim2.new(0, 15, 0, 35)
        BarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        BarBg.Parent = Container
        Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

        local BarFill = Instance.new("Frame")
        BarFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        BarFill.BackgroundColor3 = Yellow
        BarFill.Parent = BarBg
        Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            BarFill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = text .. ": " .. val
            if callback then callback(val) end
        end

        BarBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; updateSlider(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
        end)
    end

    return Pages
end

-- ==========================================
-- CONSTRUÇÃO DO HUB
-- ==========================================
local Pages = AshUI:CreateWindow("ASH HUB")

local MainScroll = Pages:NewPage("Main")
AshUI:AddSection(MainScroll, "MAIN FEATURES")

AshUI:AddButton(MainScroll, "Save Position", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        Config.SavedPos = char.HumanoidRootPart.CFrame
        Config.DefaultPos = char.HumanoidRootPart.CFrame
        print("[Ash Hub] Posição salva com sucesso!")
    end
end)

AshUI:AddToggle(MainScroll, "Instant Steal", false, function(state) 
    Config.InstantSteal = state 
    if not state then Config.isTeleporting = false end
end)

AshUI:AddToggle(MainScroll, "Noclip", false, function(state) Config.Noclip = state end)

AshUI:AddSlider(MainScroll, "Speed", 0, 1000, 16, function(val)
    Config.Speed = val; Config.BaseSpeed = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = val end
end)

local SettingsScroll = Pages:NewPage("Settings")
AshUI:AddSection(SettingsScroll, "INFO")
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 120)
InfoLabel.BackgroundColor3 = PanelBg
InfoLabel.TextColor3 = TextColor
InfoLabel.Font = Enum.Font.Gotham; InfoLabel.TextSize = 14
InfoLabel.Text = "Developer: @polarwzf - @silvazz7_hh\n\nRecommended executor: Xeno & Delta\n\nUI: AshUi"
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = SettingsScroll
Instance.new("UICorner", InfoLabel).CornerRadius = UDim.new(0, 8)
local padding = Instance.new("UIPadding", InfoLabel)
padding.PaddingLeft = UDim.new(0, 15); padding.PaddingTop = UDim.new(0, 15)

-- ==========================================
-- LOOPS DE GAMEPLAY (FIX DO INSTANT STEAL)
-- ==========================================

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Noclip
    if Config.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    -- Instant Steal Consertado
    if Config.InstantSteal and Config.SavedPos and not Config.isTeleporting then
        local hasItem = false
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                hasItem = true
                break
            end
        end

        if hasItem then
            Config.isTeleporting = true -- Trava para não teleportar repetidamente
            
            -- Pequeno delay para o jogo registrar que você pegou o item
            task.wait(0.2)
            
            -- Tween suave para voltar pra base (evita o bug de travar o personagem)
            local tweenBack = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = Config.SavedPos})
            tweenBack:Play()
            tweenBack.Completed:Wait()
            
            -- Espera 2 segundos antes de permitir teleportar de novo (para não bugar caso você esteja segurando o item)
            task.wait(2)
            Config.isTeleporting = false
        end
    end
end)

print("[Ash Hub] Carregado com sucesso!")