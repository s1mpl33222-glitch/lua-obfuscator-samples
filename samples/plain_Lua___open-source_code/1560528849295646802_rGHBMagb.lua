-- =====================================================================
-- 🩸 RAGE HUB | Murder Mystery 2 | PREMIUM FULL EDITION
-- =====================================================================

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local Lighting        = game:GetService("Lighting")
local LocalPlayer     = Players.LocalPlayer

-- GUI PARENT
local GuiParent
pcall(function() GuiParent = gethui() end)
if not GuiParent then pcall(function() GuiParent = game:GetService("CoreGui") end) end
if not GuiParent then GuiParent = LocalPlayer:WaitForChild("PlayerGui") end

-- CONFIG
local Config = {
    Combat = {
        AimbotEnabled = false,
        AimbotKey = Enum.UserInputType.MouseButton2,
        KillAura = false,
        KillAuraRange = 15,
        AutoShoot = false
    },
    ESP = {
        Enabled = false,
        Boxes = false,
        Names = false,
        Distance = false,
        Tracers = false,
        ShowInnocents = true,
        Charms = false
    },
    AutoFarm = {
        AutoCoin = false,
        TeleportToGun = false
    },
    Player = {
        WalkSpeed = 16,
        JumpPower = 50,
        Noclip = false,
        SpeedHack = false,
        FlyEnabled = false
    },
    Misc = {
        ShowFPS = false
    }
}

local CustomIcons = {
    ["home"] = "rbxassetid://10723407389",
    ["crosshair"] = "rbxassetid://10709818534",
    ["eye"] = "rbxassetid://10723346959",
    ["wind"] = "rbxassetid://10747382750",
    ["car"] = "rbxassetid://10709789810",
    ["swords"] = "rbxassetid://10734975692",
    ["settings"] = "rbxassetid://10734950309",
    ["key"] = "rbxassetid://10723416652",
    ["hurricane"] = "rbxassetid://10709799298",
    ["droplets"] = "rbxassetid://10734883356",
    ["target"] = "rbxassetid://10734977012",
    ["sparkles"] = "rbxassetid://10734966601",
    ["circle"] = "rbxassetid://10709798174",
    ["box"] = "rbxassetid://10709782497",
    ["tag"] = "rbxassetid://10734976528",
    ["ruler"] = "rbxassetid://10734941018",
    ["heart"] = "rbxassetid://10723406885",
    ["skull"] = "rbxassetid://10734962068",
    ["sword"] = "rbxassetid://10734975486",
    ["satellite"] = "rbxassetid://10734945538",
    ["gem"] = "rbxassetid://10723396000",
    ["arrow-up"] = "rbxassetid://10709768939",
    ["ghost"] = "rbxassetid://10723396107",
    ["bird"] = "rbxassetid://10709778216",
    ["fast-forward"] = "rbxassetid://10723354521",
    ["fuel"] = "rbxassetid://10723394846",
    ["octagon"] = "rbxassetid://10734907361",
    ["rocket"] = "rbxassetid://10734934585",
    ["zap"] = "rbxassetid://10747384594",
    ["battery"] = "rbxassetid://10709774640",
    ["hurricane"] = "rbxassetid://10723411039",
    ["flame"] = "rbxassetid://10723376114",
    ["brick-wall"] = "rbxassetid://10709782497",
    ["activity"] = "rbxassetid://10709752035",
    ["cloud-off"] = "rbxassetid://10709806060",
    ["moon"] = "rbxassetid://10734897102",
    ["palette"] = "rbxassetid://10734910430"
}

local function GetLucide(name)
    local i = CustomIcons[name]
    if i then return i, Vector2.new(0,0), Vector2.new(0,0) else return "rbxassetid://10709796216", Vector2.new(0,0), Vector2.new(0,0) end
end

local colorMap = {
    ["Blood Red"] = Color3.fromRGB(220,20,60),
    ["White"]     = Color3.fromRGB(255,255,255),
    ["Purple"]    = Color3.fromRGB(130,60,255),
    ["Green"]     = Color3.fromRGB(50,255,50),
    ["Blue"]      = Color3.fromRGB(50,150,255),
    ["Yellow"]    = Color3.fromRGB(255,255,50),
}
local colorOrder = {"Blood Red","White","Purple","Green","Blue","Yellow"}

-- COLORS
local C = {
    Bg      = Color3.fromRGB(10,10,12),
    Sidebar = Color3.fromRGB(15,15,18),
    Accent  = Color3.fromRGB(220,20,60),
    Card    = Color3.fromRGB(22,18,18),
    Text    = Color3.fromRGB(240,230,230),
    Sub     = Color3.fromRGB(160,140,140),
    Green   = Color3.fromRGB(30,200,80),
}

-- TWEEN HELPER
local function tw(obj, t, props)
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end)
end

-- NOTIFICATION
local function Notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification",{Title="🩸 Rage Hub", Text=msg, Duration=3})
    end)
end

-- =====================================================================
-- ENGINE & FEATURES
-- =====================================================================

    -- Show FPS Logic
    task.spawn(function()
        local RunService = game:GetService("RunService")
        local fpsGui = Instance.new("ScreenGui")
        fpsGui.Name = "RageFPS"
        fpsGui.ResetOnSpawn = false
        local fpsLbl = Instance.new("TextLabel", fpsGui)
        fpsLbl.BackgroundTransparency = 1
        fpsLbl.Position = UDim2.new(1, -100, 0, 40)
        fpsLbl.Size = UDim2.new(0, 80, 0, 30)
        fpsLbl.Font = Enum.Font.GothamBold
        fpsLbl.TextSize = 16
        fpsLbl.TextColor3 = Color3.new(0, 1, 0)
        fpsLbl.TextStrokeTransparency = 0.5
        fpsLbl.Visible = false
        
        local SynV3 = syn and DrawingImmediate
        if (not is_sirhurt_closure) and (not SynV3) and (syn and syn.protect_gui) then
            syn.protect_gui(fpsGui)
            fpsGui.Parent = game:GetService("CoreGui")
        elseif get_hidden_gui or gethui then
            local hiddenUI = get_hidden_gui or gethui
            fpsGui.Parent = hiddenUI()
        else
            fpsGui.Parent = game:GetService("CoreGui")
        end
        
        local sec = os.clock()
        local frames = 0
        RunService.RenderStepped:Connect(function()
            if not Config.Misc.ShowFPS then
                fpsLbl.Visible = false
                return
            end
            fpsLbl.Visible = true
            frames = frames + 1
            if os.clock() - sec >= 1 then
                fpsLbl.Text = tostring(frames) .. " FPS"
                frames = 0
                sec = os.clock()
            end
        end)
    end)

local Roles = {} -- [Player] = "Murderer", "Sheriff", "Innocent", "Hero"

local function UpdateRoles()
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local role = "Innocent"
        
        -- Check Character
        if p.Character then
            if p.Character:FindFirstChild("Knife") or p.Character:FindFirstChild("Combat") then
                role = "Murderer"
            elseif p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Revolver") then
                role = "Sheriff"
            end
        end
        
        -- Check Backpack
        if role == "Innocent" and p:FindFirstChild("Backpack") then
            if p.Backpack:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Combat") then
                role = "Murderer"
            elseif p.Backpack:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Revolver") then
                role = "Sheriff"
            end
        end
        
        Roles[p] = role
    end
end

local function GetRoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 50, 50) end
    if role == "Sheriff" or role == "Hero" then return Color3.fromRGB(50, 100, 255) end
    return Color3.fromRGB(50, 255, 50) -- Innocent
end

local function GetMurderer()
    for p, r in pairs(Roles) do
        if r == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            return p.Character.HumanoidRootPart
        end
    end
    return nil
end

-- [[ ESP SYSTEM ]]
local ESP_Objects = {}

local function CreateESP(p)
    if p == LocalPlayer or ESP_Objects[p] then return end
    local esp = {
        Box=Drawing.new("Square"), BoxO=Drawing.new("Square"),
        Name=Drawing.new("Text"), Dist=Drawing.new("Text"),
        Tracer=Drawing.new("Line")
    }
    esp.Box.Filled=false; esp.Box.Thickness=1
    esp.BoxO.Filled=false; esp.BoxO.Thickness=3; esp.BoxO.Color=Color3.new(0,0,0)
    esp.Name.Center=true; esp.Name.Outline=true; esp.Name.Size=14; esp.Name.Font=2
    esp.Dist.Center=true; esp.Dist.Outline=true; esp.Dist.Size=12; esp.Dist.Color=C.Sub; esp.Dist.Font=2
    esp.Tracer.Thickness=1
    ESP_Objects[p] = esp
end

local function RemoveESP(p)
    if ESP_Objects[p] then
        for k, v in pairs(ESP_Objects[p]) do pcall(function() v.Visible=false; v:Remove() end) end
        ESP_Objects[p] = nil
    end
end

local function HideESP(e)
    e.Box.Visible=false; e.BoxO.Visible=false; e.Name.Visible=false
    e.Dist.Visible=false; e.Tracer.Visible=false
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end

local fpsFrames, fpsTick, currentFPS = 0, tick(), 0
local Aiming = false

local holdingSpace = false
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.Space then holdingSpace = true end
    if i.UserInputType == Config.Combat.AimbotKey or i.KeyCode == Config.Combat.AimbotKey then Aiming = true end
    if i.KeyCode == Enum.KeyCode.X then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                for _, t in pairs(char.Humanoid:GetPlayingAnimationTracks()) do 
                    pcall(function() t:Stop() end) 
                end
            end
        end)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Space then holdingSpace = false end
    if i.UserInputType == Config.Combat.AimbotKey or i.KeyCode == Config.Combat.AimbotKey then Aiming = false end
end)

-- Main RenderStepped
RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local mouseLoc = UIS:GetMouseLocation()

    fpsFrames = fpsFrames + 1
    if tick() - fpsTick >= 1 then currentFPS = fpsFrames; fpsFrames = 0; fpsTick = tick() end

    UpdateRoles()

    -- AIMBOT (Sheriff -> Murderer)
    if Config.Combat.AimbotEnabled and Aiming then
        local murdPart = GetMurderer()
        if murdPart then
            local pos, onScreen = cam:WorldToViewportPoint(murdPart.Position)
            if onScreen then
                if mousemoverel then
                    mousemoverel((pos.X - mouseLoc.X) / 2, (pos.Y - mouseLoc.Y) / 2)
                else
                    cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, murdPart.Position), 0.5)
                end
            end
        end
    end

    -- ESP UPDATE
    for p, e in pairs(ESP_Objects) do
        local role = Roles[p] or "Innocent"
        local char = p.Character

        local function HideCharms()
            if char and char:FindFirstChild("RAGE_CHARMS") then char.RAGE_CHARMS:Destroy() end
        end

        if not Players:FindFirstChild(p.Name) or not Config.ESP.Enabled then 
            HideESP(e) 
            HideCharms()
            continue 
        end
        if not Config.ESP.ShowInnocents and role == "Innocent" then 
            HideESP(e) 
            HideCharms()
            continue 
        end
        
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then 
            HideESP(e) 
            HideCharms()
            continue 
        end
        local torso = char.HumanoidRootPart
        local dist = (cam.CFrame.Position - torso.Position).Magnitude
        
        local pos, onScreen = cam:WorldToViewportPoint(torso.Position)
        if not onScreen then HideESP(e) continue end
        local topPos = cam:WorldToViewportPoint(torso.Position + Vector3.new(0, 2.5, 0))
        local botPos  = cam:WorldToViewportPoint(torso.Position - Vector3.new(0, 3.0, 0))
        local h = math.abs(topPos.Y - botPos.Y); if h < 1 then HideESP(e) continue end
        local w = h / 1.5

        local col = GetRoleColor(role)

        if Config.ESP.Boxes then
            e.Box.Size=Vector2.new(w,h); e.Box.Position=Vector2.new(pos.X-w/2,topPos.Y); e.Box.Color=col; e.Box.Visible=true
            e.BoxO.Size=Vector2.new(w+2,h+2); e.BoxO.Position=Vector2.new(pos.X-w/2-1,topPos.Y-1); e.BoxO.Visible=true
        else e.Box.Visible=false; e.BoxO.Visible=false end

        if Config.ESP.Names then e.Name.Text=p.Name .. " ["..role.."]"; e.Name.Position=Vector2.new(pos.X,topPos.Y-18); e.Name.Color=col; e.Name.Visible=true else e.Name.Visible=false end
        if Config.ESP.Distance then e.Dist.Text="["..math.floor(dist).."m]"; e.Dist.Position=Vector2.new(pos.X,botPos.Y+2); e.Dist.Visible=true else e.Dist.Visible=false end
        if Config.ESP.Tracers then
            e.Tracer.From=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y); e.Tracer.To=Vector2.new(pos.X,botPos.Y); e.Tracer.Color=col; e.Tracer.Visible=true
        else e.Tracer.Visible=false end
        
        -- CHARMS (Highlight)
        if Config.ESP.Charms then
            local highlight = char:FindFirstChild("RAGE_CHARMS")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "RAGE_CHARMS"
                highlight.Parent = char
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0.1
            end
            highlight.FillColor = col
            highlight.OutlineColor = Color3.new(1, 1, 1)
        else
            HideCharms()
        end
    end
end)

-- Main Stepped
RunService.Stepped:Connect(function(_, dt)
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    -- Player Speed
    if Config.Player.SpeedHack and hum then
        hum.WalkSpeed = Config.Player.WalkSpeed
    end

    if Config.Player.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                pcall(function() part.CanCollide = false end)
            end
        end
    end

    if Config.Player.FlyEnabled and holdingSpace and root then
        local vel = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(vel.X, Config.Player.JumpPower, vel.Z)
    end
    -- Kill Aura (Murderer)
    if Config.Combat.KillAura and root then
        local myKnife = char:FindFirstChild("Knife") or char:FindFirstChild("Combat")
        if not myKnife then
            if LocalPlayer.Backpack:FindFirstChild("Knife") then
                pcall(function() hum:EquipTool(LocalPlayer.Backpack.Knife) end)
            end
            myKnife = char:FindFirstChild("Knife")
        end
        
        if myKnife then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= Config.Combat.KillAuraRange then
                        pcall(function()
                            firetouchinterest(p.Character.HumanoidRootPart, myKnife.Handle, 0)
                            firetouchinterest(p.Character.HumanoidRootPart, myKnife.Handle, 1)
                        end)
                    end
                end
            end
        end
    end
end)

-- =====================================================================
-- GUI SETUP
-- =====================================================================
local GUI_NAME = "SLR_Premium_" .. tostring(math.random(1000, 9999))
-- Clean up old guis if they were injected in PlayerGui
for _, v in pairs(GuiParent:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name:match("^SLR_Premium_") then
        v:Destroy()
    end
end
if GuiParent:FindFirstChild("RageHub_SL_v6") then GuiParent["RageHub_SL_v6"]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", GuiParent)
ScreenGui.Name=GUI_NAME; ScreenGui.ResetOnSpawn=false; ScreenGui.IgnoreGuiInset=true
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui)
    elseif protectgui then protectgui(ScreenGui) end
end)
-- =====================================================================
-- MAIN MENU
-- =====================================================================
local Main=Instance.new("Frame",ScreenGui)
Main.Name="MainMenu"; Main.Size=UDim2.fromOffset(780,500); Main.Position=UDim2.new(0.5,-390,0.5,-250)
Main.BackgroundColor3=Color3.fromRGB(5,5,5); Main.BorderSizePixel=0; Main.Visible=false; Main.Active=true
Main.BackgroundTransparency=0.1
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,16)
local MS=Instance.new("UIStroke",Main); MS.Color=Color3.fromRGB(80,15,20); MS.Transparency=0.8

-- Draggable main
do
    local d,ds,sp
    Main.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;ds=i.Position;sp=Main.Position end end)
    Main.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then local delta=i.Position-ds; Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y) end end)
end

UIS.InputBegan:Connect(function(i,g)
    if not g and (i.KeyCode==Enum.KeyCode.Insert or i.KeyCode==Enum.KeyCode.K) then
        Main.Visible=not Main.Visible
    end
end)

-- SIDEBAR
local Sidebar=Instance.new("Frame",Main)
Sidebar.Size=UDim2.new(0,256,1,0); Sidebar.BackgroundColor3=Color3.new(0,0,0); Sidebar.BackgroundTransparency=0.4; Sidebar.BorderSizePixel=0
Instance.new("UICorner",Sidebar).CornerRadius=UDim.new(0,16)

-- Logo area
local LogoBox=Instance.new("Frame",Sidebar); LogoBox.Size=UDim2.new(1,0,0,80); LogoBox.BackgroundTransparency=1
local LogoIconBg=Instance.new("Frame",LogoBox)
LogoIconBg.Size=UDim2.fromOffset(40,40); LogoIconBg.Position=UDim2.fromOffset(24,20)
LogoIconBg.BackgroundColor3=Color3.fromRGB(40,10,15); LogoIconBg.BorderSizePixel=0
Instance.new("UICorner",LogoIconBg).CornerRadius=UDim.new(0,12)
Instance.new("UIStroke",LogoIconBg).Color=Color3.fromRGB(150,30,40)
local LogoIconLbl=Instance.new("ImageLabel",LogoIconBg)
LogoIconLbl.Size=UDim2.fromOffset(22,22); LogoIconLbl.Position=UDim2.new(0.5,-11,0.5,-11)
LogoIconLbl.BackgroundTransparency=1; LogoIconLbl.ImageColor3=Color3.fromRGB(248,113,113)
local l1,l2,l3 = GetLucide("droplets")
LogoIconLbl.Image=l1; LogoIconLbl.ImageRectOffset=l2; LogoIconLbl.ImageRectSize=l3

local LogoText=Instance.new("TextLabel",LogoBox)
LogoText.Size=UDim2.new(1,-80,0,24); LogoText.Position=UDim2.fromOffset(76,20)
LogoText.BackgroundTransparency=1; LogoText.Text="RAGE HUB"
LogoText.Font=Enum.Font.GothamBlack; LogoText.TextSize=20; LogoText.TextColor3=Color3.new(1,1,1)
LogoText.TextXAlignment=Enum.TextXAlignment.Left

local LogoSub=Instance.new("TextLabel",LogoBox)
LogoSub.Size=UDim2.new(1,-80,0,14); LogoSub.Position=UDim2.fromOffset(76,46)
LogoSub.BackgroundTransparency=1; LogoSub.Text="WE ARE ANONYMOUS"
LogoSub.Font=Enum.Font.GothamBold; LogoSub.TextSize=8; LogoSub.TextColor3=Color3.fromRGB(248,113,113)
LogoSub.TextXAlignment=Enum.TextXAlignment.Left; LogoSub.TextTransparency=0.15

local LogoDiv=Instance.new("Frame",LogoBox)
LogoDiv.Size=UDim2.new(1,0,0,1); LogoDiv.Position=UDim2.new(0,0,1,0)
LogoDiv.BackgroundColor3=Color3.fromRGB(255,255,255); LogoDiv.BackgroundTransparency=0.94; LogoDiv.BorderSizePixel=0

-- Tab holder
local TabHold=Instance.new("Frame",Sidebar)
TabHold.Size=UDim2.new(1,0,1,-160); TabHold.Position=UDim2.fromOffset(0,81); TabHold.BackgroundTransparency=1
local tLayout=Instance.new("UIListLayout",TabHold)
tLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; tLayout.Padding=UDim.new(0,4)
local tPadding=Instance.new("UIPadding",TabHold); tPadding.PaddingTop=UDim.new(0,16)

-- Profile box (real player name + avatar)
local ProfileBox=Instance.new("Frame",Sidebar)
ProfileBox.Size=UDim2.new(1,0,0,80); ProfileBox.Position=UDim2.new(0,0,1,-80)
ProfileBox.BackgroundColor3=Color3.fromRGB(8,5,6); ProfileBox.BorderSizePixel=0
Instance.new("UICorner",ProfileBox).CornerRadius=UDim.new(0,16)
local ProfDiv=Instance.new("Frame",ProfileBox)
ProfDiv.Size=UDim2.new(1,0,0,1); ProfDiv.BackgroundColor3=Color3.fromRGB(255,255,255)
ProfDiv.BackgroundTransparency=0.93; ProfDiv.BorderSizePixel=0

local Avatar=Instance.new("ImageLabel",ProfileBox)
Avatar.Size=UDim2.fromOffset(40,40); Avatar.Position=UDim2.fromOffset(16,20)
Avatar.BackgroundColor3=Color3.fromRGB(40,10,15); Avatar.BorderSizePixel=0
Avatar.Image="rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=150&h=150"
Instance.new("UICorner",Avatar).CornerRadius=UDim.new(1,0)
Instance.new("UIStroke",Avatar).Color=Color3.fromRGB(150,30,40)

local PName=Instance.new("TextLabel",ProfileBox)
PName.Size=UDim2.new(1,-70,0,20); PName.Position=UDim2.fromOffset(68,18)
PName.BackgroundTransparency=1; PName.Text=LocalPlayer.Name
PName.Font=Enum.Font.GothamBold; PName.TextSize=14; PName.TextColor3=Color3.new(1,1,1)
PName.TextXAlignment=Enum.TextXAlignment.Left

local PStatus=Instance.new("TextLabel",ProfileBox)
PStatus.Size=UDim2.new(1,-70,0,16); PStatus.Position=UDim2.fromOffset(68,42)
PStatus.BackgroundTransparency=1; PStatus.Text="🟢  Premium Access"
PStatus.Font=Enum.Font.GothamMedium; PStatus.TextSize=10; PStatus.TextColor3=Color3.fromRGB(74,222,128)
PStatus.TextXAlignment=Enum.TextXAlignment.Left

local PSettings=Instance.new("ImageButton",ProfileBox)
PSettings.Size=UDim2.fromOffset(20,20); PSettings.Position=UDim2.new(1,-36,0.5,-10)
PSettings.BackgroundTransparency=1; PSettings.ImageColor3=Color3.fromRGB(156,163,175)
local s1,s2,s3 = GetLucide("settings")
PSettings.Image=s1; PSettings.ImageRectOffset=s2; PSettings.ImageRectSize=s3
PSettings.MouseEnter:Connect(function() tw(PSettings,0.2,{ImageColor3=Color3.fromRGB(248,113,113)}) end)
PSettings.MouseLeave:Connect(function() tw(PSettings,0.2,{ImageColor3=Color3.fromRGB(156,163,175)}) end)

local PMenu=Instance.new("Frame",Sidebar)
PMenu.Size=UDim2.new(1,-32,0,100); PMenu.Position=UDim2.new(0,16,1,-185)
PMenu.BackgroundColor3=Color3.fromRGB(15,10,12); PMenu.BorderSizePixel=0; PMenu.Visible=false
Instance.new("UICorner",PMenu).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",PMenu).Color=Color3.fromRGB(80,20,30)

local PHideName=Instance.new("TextButton",PMenu)
PHideName.Size=UDim2.new(1,-16,0,24); PHideName.Position=UDim2.fromOffset(8,8)
PHideName.BackgroundColor3=Color3.fromRGB(30,20,25); PHideName.BorderSizePixel=0
PHideName.Text="Hide Name (Spoof)"; PHideName.TextColor3=Color3.new(1,1,1); PHideName.Font=Enum.Font.GothamMedium; PHideName.TextSize=11
Instance.new("UICorner",PHideName).CornerRadius=UDim.new(0,4)

local PChangeName=Instance.new("TextButton",PMenu)
PChangeName.Size=UDim2.new(1,-16,0,24); PChangeName.Position=UDim2.fromOffset(8,38)
PChangeName.BackgroundColor3=Color3.fromRGB(30,20,25); PChangeName.BorderSizePixel=0
PChangeName.Text="Change Name"; PChangeName.TextColor3=Color3.new(1,1,1); PChangeName.Font=Enum.Font.GothamMedium; PChangeName.TextSize=11
Instance.new("UICorner",PChangeName).CornerRadius=UDim.new(0,4)

local PChangeAvatar=Instance.new("TextButton",PMenu)
PChangeAvatar.Size=UDim2.new(1,-16,0,24); PChangeAvatar.Position=UDim2.fromOffset(8,68)
PChangeAvatar.BackgroundColor3=Color3.fromRGB(30,20,25); PChangeAvatar.BorderSizePixel=0
PChangeAvatar.Text="Change Avatar"; PChangeAvatar.TextColor3=Color3.new(1,1,1); PChangeAvatar.Font=Enum.Font.GothamMedium; PChangeAvatar.TextSize=11
Instance.new("UICorner",PChangeAvatar).CornerRadius=UDim.new(0,4)

PSettings.MouseButton1Click:Connect(function() PMenu.Visible=not PMenu.Visible end)

local isSpoofed=false
local originalName=LocalPlayer.Name
PHideName.MouseButton1Click:Connect(function()
    isSpoofed=not isSpoofed
    local wt = pHome and pHome:FindFirstChild("WTitle", true)
    if isSpoofed then 
        PName.Text="HiddenUser"
        PHideName.Text="Show Name" 
        if wt then wt.Text="Welcome back, HiddenUser" end
    else 
        PName.Text=originalName
        PHideName.Text="Hide Name (Spoof)" 
        if wt then wt.Text="Welcome back, "..originalName end
    end
end)
PChangeName.MouseButton1Click:Connect(function() 
    local newName = "Anon_"..tostring(math.random(1000,9999))
    PName.Text=newName
    local wt = pHome and pHome:FindFirstChild("WTitle", true)
    if wt then wt.Text="Welcome back, "..newName end
end)
PChangeAvatar.MouseButton1Click:Connect(function() Avatar.Image="rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150" end)

-- Content area
local ContentBg=Instance.new("Frame",Main)
ContentBg.Size=UDim2.new(1,-256,1,0); ContentBg.Position=UDim2.fromOffset(256,0); ContentBg.BackgroundTransparency=1

local Topbar=Instance.new("Frame",ContentBg)
Topbar.Size=UDim2.new(1,0,0,80); Topbar.BackgroundColor3=Color3.new(0,0,0); Topbar.BackgroundTransparency=0.6; Topbar.BorderSizePixel=0
local TopDiv=Instance.new("Frame",Topbar)
TopDiv.Size=UDim2.new(1,0,0,1); TopDiv.Position=UDim2.new(0,0,1,-1)
TopDiv.BackgroundColor3=Color3.fromRGB(255,255,255); TopDiv.BackgroundTransparency=0.95; TopDiv.BorderSizePixel=0

local TopIconBg=Instance.new("Frame",Topbar)
TopIconBg.Size=UDim2.fromOffset(40,40); TopIconBg.Position=UDim2.fromOffset(32,20)
TopIconBg.BackgroundColor3=Color3.fromRGB(40,10,15); TopIconBg.BorderSizePixel=0
Instance.new("UICorner",TopIconBg).CornerRadius=UDim.new(0,12)
Instance.new("UIStroke",TopIconBg).Color=Color3.fromRGB(150,30,40)
local TopIconLbl=Instance.new("ImageLabel",TopIconBg)
TopIconLbl.Size=UDim2.fromOffset(20,20); TopIconLbl.Position=UDim2.fromOffset(10,10)
TopIconLbl.BackgroundTransparency=1; TopIconLbl.ImageColor3=Color3.fromRGB(248,113,113)
local t1,t2,t3 = GetLucide("home")
TopIconLbl.Image=t1; TopIconLbl.ImageRectOffset=t2; TopIconLbl.ImageRectSize=t3

local TopTitle=Instance.new("TextLabel",Topbar)
TopTitle.Size=UDim2.new(1,-200,1,0); TopTitle.Position=UDim2.fromOffset(84,0)
TopTitle.BackgroundTransparency=1; TopTitle.Text="Home"
TopTitle.Font=Enum.Font.GothamBold; TopTitle.TextSize=20; TopTitle.TextColor3=Color3.new(1,1,1)
TopTitle.TextXAlignment=Enum.TextXAlignment.Left

local SessionBadge=Instance.new("Frame",Topbar)
SessionBadge.Size=UDim2.fromOffset(140,30); SessionBadge.Position=UDim2.new(1,-152,0.5,-15)
SessionBadge.BackgroundColor3=Color3.new(0,0,0); SessionBadge.BackgroundTransparency=0.4; SessionBadge.BorderSizePixel=0
Instance.new("UICorner",SessionBadge).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",SessionBadge).Color=Color3.fromRGB(120,20,30)
local SBLabel=Instance.new("TextLabel",SessionBadge)
SBLabel.Size=UDim2.fromScale(1,1); SBLabel.BackgroundTransparency=1
SBLabel.Text="✅  Session Active"; SBLabel.Font=Enum.Font.GothamMedium
SBLabel.TextSize=10; SBLabel.TextColor3=Color3.fromRGB(248,113,113)

local PageHost=Instance.new("Frame",ContentBg)
PageHost.Size=UDim2.new(1,-64,1,-112); PageHost.Position=UDim2.fromOffset(32,96); PageHost.BackgroundTransparency=1

-- =====================================================================
-- TAB SYSTEM
-- =====================================================================
local activeBtn,activePage=nil,nil

local function SelectTab(btn,page,name,emoji)
    if activeBtn then
        tw(activeBtn,0.18,{BackgroundTransparency=1})
        tw(activeBtn:FindFirstChild("Title"),0.18,{TextColor3=Color3.fromRGB(156,163,175)})
        if activeBtn:FindFirstChild("Ico") then tw(activeBtn:FindFirstChild("Ico"),0.18,{ImageColor3=Color3.fromRGB(156,163,175)}) end
    end
    if activePage then activePage.Visible=false end

    tw(btn,0.18,{BackgroundTransparency=0.82})
    tw(btn:FindFirstChild("Title"),0.18,{TextColor3=Color3.fromRGB(248,113,113)})
    if btn:FindFirstChild("Ico") then tw(btn:FindFirstChild("Ico"),0.18,{ImageColor3=Color3.fromRGB(248,113,113)}) end

    page.Visible=true
    page.Position=UDim2.new(0,0,0,10)
    tw(page,0.3,{Position=UDim2.new(0,0,0,0)})

    TopTitle.Text=name
    local a1,a2,a3 = GetLucide(emoji)
    TopIconLbl.Image=a1; TopIconLbl.ImageRectOffset=a2; TopIconLbl.ImageRectSize=a3
    activeBtn=btn; activePage=page
end

local function createTab(emoji,name)
    local btn=Instance.new("TextButton",TabHold)
    btn.Size=UDim2.new(1,-32,0,48); btn.BackgroundColor3=Color3.fromRGB(220,38,38); btn.BackgroundTransparency=1
    btn.Text=""; btn.BorderSizePixel=0
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,12)
    local bStroke=Instance.new("UIStroke",btn); bStroke.Color=Color3.fromRGB(255,255,255); bStroke.Transparency=0.96

    local icoLbl=Instance.new("ImageLabel",btn); icoLbl.Name="Ico"
    icoLbl.Size=UDim2.fromOffset(20,20); icoLbl.Position=UDim2.fromOffset(14,14)
    icoLbl.BackgroundTransparency=1; icoLbl.ImageColor3=Color3.fromRGB(156,163,175)
    local i1,i2,i3 = GetLucide(emoji)
    icoLbl.Image=i1; icoLbl.ImageRectOffset=i2; icoLbl.ImageRectSize=i3

    local tLbl=Instance.new("TextLabel",btn); tLbl.Name="Title"
    tLbl.Size=UDim2.new(1,-50,1,0); tLbl.Position=UDim2.fromOffset(44,0); tLbl.BackgroundTransparency=1
    tLbl.Text=name; tLbl.Font=Enum.Font.GothamMedium; tLbl.TextSize=14
    tLbl.TextColor3=Color3.fromRGB(156,163,175); tLbl.TextXAlignment=Enum.TextXAlignment.Left

    local page=Instance.new("ScrollingFrame",PageHost)
    page.Size=UDim2.fromScale(1,1); page.BackgroundTransparency=1; page.BorderSizePixel=0
    page.ScrollBarThickness=4; page.ScrollBarImageColor3=Color3.fromRGB(220,38,38); page.ScrollBarImageTransparency=0.3
    page.CanvasSize=UDim2.fromOffset(0,600); page.Visible=false
    page.ScrollingEnabled=true; page.Selectable=true; page.Active=true
    local lay=Instance.new("UIListLayout",page); lay.Padding=UDim.new(0,12)
    local pad=Instance.new("UIPadding",page); pad.PaddingTop=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)
    
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize=UDim2.new(0,0,0,lay.AbsoluteContentSize.Y+20)
    end)

    btn.MouseButton1Click:Connect(function() SelectTab(btn,page,name,emoji) end)
    btn.MouseEnter:Connect(function()
        if btn~=activeBtn then
            tw(tLbl,0.1,{TextColor3=Color3.fromRGB(229,231,235)})
            tw(icoLbl,0.1,{ImageColor3=Color3.fromRGB(229,231,235)})
            tw(btn,0.1,{BackgroundTransparency=0.95})
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn~=activeBtn then
            tw(tLbl,0.1,{TextColor3=Color3.fromRGB(156,163,175)})
            tw(icoLbl,0.1,{ImageColor3=Color3.fromRGB(156,163,175)})
            tw(btn,0.1,{BackgroundTransparency=1})
        end
    end)
    return page,btn
end

-- =====================================================================
-- WIDGETS
-- =====================================================================
local layoutOrderCounter = 0
local function nextOrder() layoutOrderCounter = layoutOrderCounter + 1; return layoutOrderCounter; end

local function addButton(parent,emoji,text,callback)
    local r=Instance.new("TextButton",parent)
    r.BackgroundColor3=Color3.fromRGB(30,20,25); r.BorderSizePixel=0
    r.Size=UDim2.new(1,0,0,40)
    r.LayoutOrder = nextOrder()
    Instance.new("UICorner",r).CornerRadius=UDim.new(0,8)
    
    local eLbl=Instance.new("ImageLabel",r)
    eLbl.Size=UDim2.fromOffset(20,20); eLbl.Position=UDim2.fromOffset(16,10)
    eLbl.BackgroundTransparency=1; eLbl.ImageColor3=Color3.fromRGB(229,231,235)
    local s1,s2,s3 = GetLucide(emoji)
    eLbl.Image=s1; eLbl.ImageRectOffset=s2; eLbl.ImageRectSize=s3

    local l=Instance.new("TextLabel",r)
    l.Size=UDim2.new(1,-50,1,0); l.Position=UDim2.fromOffset(40,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.fromRGB(229,231,235)
    l.Font=Enum.Font.GothamMedium; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left
    
    r.MouseButton1Click:Connect(callback)
    return r
end

local function addToggle(parent,emoji,text,tbl,key)
    local r=Instance.new("Frame",parent)
    r.BackgroundColor3=Color3.fromRGB(255,255,255); r.BackgroundTransparency=0.94; r.BorderSizePixel=0
    r.Size=UDim2.new(1,0,0,52)
    r.LayoutOrder = nextOrder()
    Instance.new("UICorner",r).CornerRadius=UDim.new(0,10)
    local rs=Instance.new("UIStroke",r); rs.Color=Color3.fromRGB(255,255,255); rs.Transparency=0.94

    local eLbl=Instance.new("ImageLabel",r)
    eLbl.Size=UDim2.fromOffset(20,20); eLbl.Position=UDim2.fromOffset(16,16)
    eLbl.BackgroundTransparency=1; eLbl.ImageColor3=Color3.fromRGB(229,231,235)
    local e1,e2,e3 = GetLucide(emoji)
    eLbl.Image=e1; eLbl.ImageRectOffset=e2; eLbl.ImageRectSize=e3

    local l=Instance.new("TextLabel",r)
    l.Size=UDim2.new(1,-96,1,0); l.Position=UDim2.fromOffset(40,0)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.fromRGB(229,231,235)
    l.Font=Enum.Font.GothamMedium; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextWrapped=true

    local tBg=Instance.new("TextButton",r)
    tBg.Size=UDim2.fromOffset(40,22); tBg.Position=UDim2.new(1,-52,0.5,-11)
    tBg.BackgroundColor3=Color3.fromRGB(75,85,99); tBg.Text=""; tBg.BorderSizePixel=0
    Instance.new("UICorner",tBg).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",tBg)
    knob.Size=UDim2.fromOffset(17,17); knob.Position=UDim2.fromOffset(2,2)
    knob.BackgroundColor3=Color3.fromRGB(255,255,255); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local function upd()
        local s=tbl[key]
        tw(tBg,0.18,{BackgroundColor3=s and Color3.fromRGB(220,38,38) or Color3.fromRGB(75,85,99)})
        tw(knob,0.18,{Position=s and UDim2.fromOffset(21,2) or UDim2.fromOffset(2,2)})
    end
    upd()
    tBg.MouseButton1Click:Connect(function() tbl[key]=not tbl[key]; upd() end)
    r.MouseEnter:Connect(function() tw(r,0.1,{BackgroundTransparency=0.89}) end)
    r.MouseLeave:Connect(function() tw(r,0.1,{BackgroundTransparency=0.94}) end)
end

local function addSlider(parent,emoji,text,tbl,key,mn,mx)
    local r=Instance.new("Frame",parent)
    r.BackgroundColor3=Color3.fromRGB(255,255,255); r.BackgroundTransparency=0.94; r.BorderSizePixel=0
    r.Size=UDim2.new(1,0,0,72)
    r.LayoutOrder = nextOrder()
    Instance.new("UICorner",r).CornerRadius=UDim.new(0,10)
    local rs=Instance.new("UIStroke",r); rs.Color=Color3.fromRGB(255,255,255); rs.Transparency=0.94

    local eLbl=Instance.new("ImageLabel",r)
    eLbl.Size=UDim2.fromOffset(18,18); eLbl.Position=UDim2.fromOffset(16,13)
    eLbl.BackgroundTransparency=1; eLbl.ImageColor3=Color3.fromRGB(229,231,235)
    local sl1,sl2,sl3 = GetLucide(emoji)
    eLbl.Image=sl1; eLbl.ImageRectOffset=sl2; eLbl.ImageRectSize=sl3

    local l=Instance.new("TextLabel",r)
    l.Size=UDim2.new(0.6,0,0,28); l.Position=UDim2.fromOffset(40,8)
    l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.fromRGB(229,231,235)
    l.Font=Enum.Font.GothamMedium; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left

    local vL=Instance.new("TextLabel",r)
    vL.Size=UDim2.new(0.35,0,0,28); vL.Position=UDim2.new(0.65,-12,0,8)
    vL.BackgroundTransparency=1; vL.Text=tostring(tbl[key])
    vL.TextColor3=Color3.fromRGB(248,113,113); vL.Font=Enum.Font.GothamBold; vL.TextSize=13
    vL.TextXAlignment=Enum.TextXAlignment.Right

    local sBg=Instance.new("Frame",r)
    sBg.Size=UDim2.new(1,-24,0,6); sBg.Position=UDim2.fromOffset(12,50)
    sBg.BackgroundColor3=Color3.fromRGB(45,55,70); sBg.BorderSizePixel=0
    Instance.new("UICorner",sBg).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",sBg)
    fill.Size=UDim2.fromScale(math.clamp((tbl[key]-mn)/(mx-mn),0,1),1)
    fill.BackgroundColor3=Color3.fromRGB(239,68,68); fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local hitBtn=Instance.new("TextButton",sBg)
    hitBtn.Size=UDim2.new(1,0,1,16); hitBtn.Position=UDim2.fromOffset(0,-8)
    hitBtn.BackgroundTransparency=1; hitBtn.Text=""

    local ds=false
    hitBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds=true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then ds=false end end)
    UIS.InputChanged:Connect(function(i)
        if ds and i.UserInputType==Enum.UserInputType.MouseMovement then
            local pct=math.clamp((i.Position.X-sBg.AbsolutePosition.X)/sBg.AbsoluteSize.X,0,1)
            fill.Size=UDim2.fromScale(pct,1)
            local val=math.floor(mn+((mx-mn)*pct))
            vL.Text=tostring(val); tbl[key]=val
        end
    end)
end

-- Color picker (dropdown style)
local function addColorPicker(parent)
    local r=Instance.new("Frame",parent)
    r.BackgroundColor3=Color3.fromRGB(255,255,255); r.BackgroundTransparency=0.94; r.BorderSizePixel=0
    r.Size=UDim2.new(1,0,0,52)
    r.LayoutOrder = nextOrder()
    Instance.new("UICorner",r).CornerRadius=UDim.new(0,10)
    Instance.new("UIStroke",r).Color=Color3.fromRGB(255,255,255); r:FindFirstChild("UIStroke").Transparency=0.94

    local eLbl=Instance.new("ImageLabel",r)
    eLbl.Size=UDim2.fromOffset(20,20); eLbl.Position=UDim2.fromOffset(16,16)
    eLbl.BackgroundTransparency=1; eLbl.ImageColor3=Color3.fromRGB(229,231,235)
    local cp1,cp2,cp3 = GetLucide("palette")
    eLbl.Image=cp1; eLbl.ImageRectOffset=cp2; eLbl.ImageRectSize=cp3

    local l=Instance.new("TextLabel",r)
    l.Size=UDim2.new(0.45,0,1,0); l.Position=UDim2.fromOffset(40,0)
    l.BackgroundTransparency=1; l.Text="ESP Color"; l.TextColor3=Color3.fromRGB(229,231,235)
    l.Font=Enum.Font.GothamMedium; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left

    local colIdx=1
    for i,c in ipairs(colorOrder) do if c==Config.Visual.ColorName then colIdx=i end end

    local colSwatch=Instance.new("Frame",r)
    colSwatch.Size=UDim2.fromOffset(20,20); colSwatch.Position=UDim2.new(1,-96,0.5,-10)
    colSwatch.BackgroundColor3=colorMap[colorOrder[colIdx]]; colSwatch.BorderSizePixel=0
    Instance.new("UICorner",colSwatch).CornerRadius=UDim.new(1,0)

    local colNameLbl=Instance.new("TextLabel",r)
    colNameLbl.Size=UDim2.fromOffset(72,52); colNameLbl.Position=UDim2.new(1,-76,0,0)
    colNameLbl.BackgroundTransparency=1; colNameLbl.Text=colorOrder[colIdx]
    colNameLbl.Font=Enum.Font.GothamMedium; colNameLbl.TextSize=11
    colNameLbl.TextColor3=Color3.fromRGB(248,113,113); colNameLbl.TextXAlignment=Enum.TextXAlignment.Center

    local cycleBtn=Instance.new("TextButton",r)
    cycleBtn.Size=UDim2.fromScale(1,1); cycleBtn.BackgroundTransparency=1; cycleBtn.Text=""
    cycleBtn.MouseButton1Click:Connect(function()
        colIdx=(colIdx%#colorOrder)+1
        Config.Visual.ColorName=colorOrder[colIdx]
        local col=colorMap[colorOrder[colIdx]]
        tw(colSwatch,0.2,{BackgroundColor3=col})
        colNameLbl.Text=colorOrder[colIdx]
    end)
end

-- Section header
local function addHeader(parent, text)
    local h=Instance.new("TextLabel",parent)
    h.Size=UDim2.new(1,0,0,24); h.BackgroundTransparency=1
    h.LayoutOrder = nextOrder()
    h.Text=text; h.Font=Enum.Font.GothamBold; h.TextSize=11
    h.TextColor3=Color3.fromRGB(120,100,105); h.TextXAlignment=Enum.TextXAlignment.Left
end

-- =====================================================================
-- BUILD TABS
-- =====================================================================
local pHome, bHome  = createTab("home","Home")
local pAim,  bAim   = createTab("crosshair","Combat")
local pVis,  bVis   = createTab("eye","Visuals")
local pMove, bMove  = createTab("wind","Player")
local pEmote, bEmote = createTab("activity", "Emotes")
local pMisc, bMisc  = createTab("settings","Misc")

-- HOME TAB
do
    local wbox=Instance.new("Frame",pHome)
    wbox.Size=UDim2.new(1,0,0,140); wbox.BackgroundColor3=Color3.fromRGB(15,5,5); wbox.BorderSizePixel=0
    Instance.new("UICorner",wbox).CornerRadius=UDim.new(0,16)
    Instance.new("UIStroke",wbox).Color=Color3.fromRGB(100,20,25)
    local wTitle=Instance.new("TextLabel",wbox); wTitle.Name="WTitle"
    wTitle.Size=UDim2.new(1,-40,0,30); wTitle.Position=UDim2.fromOffset(24,20)
    wTitle.BackgroundTransparency=1; wTitle.Text="Welcome back, "..LocalPlayer.Name
    wTitle.TextColor3=Color3.fromRGB(248,113,113); wTitle.Font=Enum.Font.GothamBold
    wTitle.TextSize=18; wTitle.TextXAlignment=Enum.TextXAlignment.Left
    local wSub=Instance.new("TextLabel",wbox)
    wSub.Size=UDim2.new(1,-40,0,70); wSub.Position=UDim2.fromOffset(24,56)
    wSub.BackgroundTransparency=1; wSub.Text="MM2 Premium injection active. Press INSERT or K to toggle menu.\nPress X to instantly stop any playing emote."
    wSub.TextColor3=Color3.fromRGB(156,163,175); wSub.Font=Enum.Font.GothamMedium; wSub.TextSize=13
    wSub.TextWrapped=true; wSub.TextXAlignment=Enum.TextXAlignment.Left; wSub.TextYAlignment=Enum.TextYAlignment.Top

    local statHold=Instance.new("Frame",pHome)
    statHold.Size=UDim2.new(1,0,0,90); statHold.BackgroundTransparency=1
    local sLay=Instance.new("UIListLayout",statHold)
    sLay.FillDirection=Enum.FillDirection.Horizontal; sLay.Padding=UDim.new(0,12)

    local function makeStat(lbl,val,vc)
        local s=Instance.new("Frame",statHold)
        s.Size=UDim2.new(0.31,0,1,0); s.BackgroundColor3=Color3.new(0,0,0); s.BackgroundTransparency=0.6; s.BorderSizePixel=0
        Instance.new("UICorner",s).CornerRadius=UDim.new(0,14)
        Instance.new("UIStroke",s).Color=Color3.fromRGB(255,255,255); s:FindFirstChild("UIStroke").Transparency=0.94
        local l1=Instance.new("TextLabel",s)
        l1.Size=UDim2.new(1,-20,0,20); l1.Position=UDim2.fromOffset(14,14)
        l1.BackgroundTransparency=1; l1.Text=lbl; l1.TextColor3=Color3.fromRGB(107,114,128)
        l1.Font=Enum.Font.GothamBold; l1.TextSize=9; l1.TextXAlignment=Enum.TextXAlignment.Left
        local l2=Instance.new("TextLabel",s)
        l2.Size=UDim2.new(1,-20,0,28); l2.Position=UDim2.fromOffset(14,34)
        l2.BackgroundTransparency=1; l2.Text=val; l2.TextColor3=vc
        l2.Font=Enum.Font.GothamBold; l2.TextSize=13; l2.TextXAlignment=Enum.TextXAlignment.Left
    end
    makeStat("DETECTION","✔ Undetected",Color3.fromRGB(74,222,128))
    makeStat("GAME","Murder Mystery 2",Color3.new(1,1,1))
    makeStat("STATUS","🔴 Injected",Color3.fromRGB(248,113,113))

    pHome.CanvasSize=UDim2.fromOffset(0,260)
end

-- COMBAT TAB
do
    addToggle(pAim,"target","Sheriff Aimbot (Lock on Murderer)",Config.Combat,"AimbotEnabled")
    
    addHeader(pAim,"  MURDERER OPTIONS")
    addToggle(pAim,"sword","Kill Aura",Config.Combat,"KillAura")
    addSlider(pAim,"ruler","Kill Aura Range",Config.Combat,"KillAuraRange",5,50)
    pAim.CanvasSize=UDim2.fromOffset(0,400)
end

-- VISUALS TAB
do
    addToggle(pVis,"eye","Enable Role ESP",Config.ESP,"Enabled")
    addToggle(pVis,"box","Role Box",Config.ESP,"Boxes")
    addToggle(pVis,"tag","Role Name",Config.ESP,"Names")
    addToggle(pVis,"ruler","Role Distance",Config.ESP,"Distance")
    addToggle(pVis,"satellite","Role Tracers",Config.ESP,"Tracers")
    addToggle(pVis,"gem","Role Charms (Highlight)",Config.ESP,"Charms")
    addToggle(pVis,"ghost","Show Innocents (Green)",Config.ESP,"ShowInnocents")
    pVis.CanvasSize=UDim2.fromOffset(0,450)
end



-- PLAYER TAB
do
    addToggle(pMove,"fast-forward","Enable WalkSpeed",Config.Player,"SpeedHack")
    addSlider(pMove,"fast-forward","WalkSpeed Value",Config.Player,"WalkSpeed",16,100)
    addToggle(pMove,"rocket","Hold Space to Fly (Inf Jump)",Config.Player,"FlyEnabled")
    addSlider(pMove,"activity","Jump Power",Config.Player,"JumpPower",50,200)
    addToggle(pMove,"ghost","No Clip",Config.Player,"Noclip")
    pMove.CanvasSize=UDim2.fromOffset(0,300)
end

-- EMOTES TAB
do
    addHeader(pEmote, "  CUSTOM ANIMATION ID (R15)")
    
    local idBox=Instance.new("TextBox",pEmote)
    idBox.Size=UDim2.new(1,0,0,40); idBox.BackgroundColor3=Color3.fromRGB(15,15,15); idBox.BorderSizePixel=0
    idBox.Text="Enter Animation ID here (e.g. 507771019)"; idBox.TextColor3=Color3.new(1,1,1); idBox.Font=Enum.Font.Gotham; idBox.TextSize=12
    idBox.ClearTextOnFocus=true
    idBox.LayoutOrder = nextOrder()
    Instance.new("UICorner",idBox).CornerRadius=UDim.new(0,8)

    local playIdBtn=Instance.new("TextButton",pEmote)
    playIdBtn.Size=UDim2.new(1,0,0,40); playIdBtn.BackgroundColor3=Color3.fromRGB(40,150,80); playIdBtn.BorderSizePixel=0
    playIdBtn.Text="▶ PLAY CUSTOM ID"; playIdBtn.TextColor3=Color3.new(1,1,1); playIdBtn.Font=Enum.Font.GothamBold; playIdBtn.TextSize=14
    playIdBtn.LayoutOrder = nextOrder()
    Instance.new("UICorner",playIdBtn).CornerRadius=UDim.new(0,8)

    local customTrack = nil
    playIdBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local id = tonumber(idBox.Text:match("%d+"))
            if id then
                if customTrack then pcall(function() customTrack:Stop() end); customTrack = nil end
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. tostring(id)
                local char = game:GetService("Players").LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    local animator = char.Humanoid:FindFirstChild("Animator") or Instance.new("Animator", char.Humanoid)
                    customTrack = animator:LoadAnimation(anim)
                    customTrack:Play()
                end
            end
        end)
    end)
    
    addHeader(pEmote, "  STOP ANIMATION")
    
    local stopBtn=Instance.new("TextButton",pEmote)
    stopBtn.Size=UDim2.new(1,0,0,40); stopBtn.BackgroundColor3=Color3.fromRGB(200,40,40); stopBtn.BorderSizePixel=0
    stopBtn.Text="🛑 STOP EMOTE (Or press X)"; stopBtn.TextColor3=Color3.new(1,1,1); stopBtn.Font=Enum.Font.GothamBold; stopBtn.TextSize=14
    stopBtn.LayoutOrder = nextOrder()
    Instance.new("UICorner",stopBtn).CornerRadius=UDim.new(0,8)
    
    stopBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if customTrack then pcall(function() customTrack:Stop() end); customTrack = nil end
            local char = game:GetService("Players").LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local tracks = char.Humanoid:GetPlayingAnimationTracks()
                for _, t in pairs(tracks) do pcall(function() t:Stop() end) end
            end
        end)
    end)

    pEmote.CanvasSize=UDim2.fromOffset(0, 300)
end

-- MISC TAB
do
    addHeader(pMisc, "  PERFORMANCE")
    
    addToggle(pMisc, "activity", "Show FPS", Config.Misc, "ShowFPS")
    
    addButton(pMisc, "zap", "FPS Boost (Removes Textures/Lighting)", function()
        pcall(function()
            local l = game:GetService("Lighting")
            l.GlobalShadows = false
            l.FogEnd = 9e9
            l.ShadowSoftness = 0
            if sethiddenproperty then sethiddenproperty(l, "Technology", 2) end
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") and v.Name ~= "roblox" then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                    v.Enabled = false
                elseif v:IsA("MeshPart") then
                    v.Material = "Plastic"
                    v.Reflectance = 0
                end
            end
        end)
    end)
    
    addHeader(pMisc, "  SERVERS & COMMUNITY")
    
    addButton(pMisc, "globe", "Server Hop", function()
        local placeId, jobId = game.PlaceId, game.JobId
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
            if servers and servers.data then
                for _, srv in pairs(servers.data) do
                    if srv.playing < srv.maxPlayers and srv.id ~= jobId then
                        TeleportService:TeleportToPlaceInstance(placeId, srv.id, game.Players.LocalPlayer); break
                    end
                end
            end
        end)
    end)
    
    pMisc.CanvasSize=UDim2.fromOffset(0,200)
end

SelectTab(bHome,pHome,"Home","home")

-- =====================================================================
-- LAUNCH SCRIPT (No Key System)
-- =====================================================================
-- The new Cinematic Loader will handle revealing the menu.
-- We keep Main.Visible = false initially.
Main.Visible = false
Main.Position = UDim2.new(0.5, -390, 0.5, -250)
Main.BackgroundTransparency = 0.1

-- =====================================================================
-- [SECTION 8] LUXURY CINEMATIC LOADER
-- =====================================================================
task.spawn(function()
    local originalPos = Main.Position
    Main.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset + 60)

    -- Center loader card
    local LoaderCard = Instance.new("Frame")
    LoaderCard.Parent = ScreenGui
    LoaderCard.Size = UDim2.fromOffset(480, 260)
    LoaderCard.Position = UDim2.new(0.5, -240, 0.5, -130)
    LoaderCard.BackgroundColor3 = C.Card
    LoaderCard.BorderSizePixel = 0
    LoaderCard.ZIndex = 9992
    Instance.new("UICorner", LoaderCard).CornerRadius = UDim.new(0, 12)
    local LoaderStroke = Instance.new("UIStroke", LoaderCard)
    LoaderStroke.Color = C.Accent
    LoaderStroke.Thickness = 1.5

    -- Logo box
    local LogoBg = Instance.new("Frame", LoaderCard)
    LogoBg.Size = UDim2.fromOffset(60, 60)
    LogoBg.Position = UDim2.fromOffset(30, 28)
    LogoBg.BackgroundColor3 = C.Accent
    LogoBg.BorderSizePixel = 0
    LogoBg.ZIndex = 9993
    Instance.new("UICorner", LogoBg).CornerRadius = UDim.new(0, 14)
    local LogoText = Instance.new("TextLabel", LogoBg)
    LogoText.Size = UDim2.fromScale(1, 1)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "R"
    LogoText.Font = Enum.Font.GothamBlack
    LogoText.TextSize = 30
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.ZIndex = 9994

    -- Title
    local MainTitle = Instance.new("TextLabel", LoaderCard)
    MainTitle.Size = UDim2.new(1, -120, 0, 32)
    MainTitle.Position = UDim2.fromOffset(108, 22)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "RAGE HUB"
    MainTitle.Font = Enum.Font.GothamBlack
    MainTitle.TextSize = 26
    MainTitle.TextColor3 = C.Text
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.ZIndex = 9993

    local SubTitle = Instance.new("TextLabel", LoaderCard)
    SubTitle.Size = UDim2.new(1, -120, 0, 18)
    SubTitle.Position = UDim2.fromOffset(108, 58)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "MURDER MYSTERY 2  //  PREMIUM EDITION"
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.TextSize = 11
    SubTitle.TextColor3 = C.Accent
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.ZIndex = 9993

    -- Divider
    local Divider = Instance.new("Frame", LoaderCard)
    Divider.Size = UDim2.new(1, -60, 0, 1)
    Divider.Position = UDim2.fromOffset(30, 104)
    Divider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 9993

    -- Status text
    local StepLbl = Instance.new("TextLabel", LoaderCard)
    StepLbl.Size = UDim2.new(1, -80, 0, 22)
    StepLbl.Position = UDim2.fromOffset(30, 118)
    StepLbl.BackgroundTransparency = 1
    StepLbl.Text = "[ INITIALIZING... ]"
    StepLbl.Font = Enum.Font.Code
    StepLbl.TextSize = 13
    StepLbl.TextColor3 = C.Accent
    StepLbl.TextXAlignment = Enum.TextXAlignment.Left
    StepLbl.ZIndex = 9993

    -- Percent label
    local PctLbl = Instance.new("TextLabel", LoaderCard)
    PctLbl.Size = UDim2.fromOffset(60, 22)
    PctLbl.Position = UDim2.new(1, -90, 0, 118)
    PctLbl.BackgroundTransparency = 1
    PctLbl.Text = "0%"
    PctLbl.Font = Enum.Font.GothamBold
    PctLbl.TextSize = 13
    PctLbl.TextColor3 = C.Sub
    PctLbl.TextXAlignment = Enum.TextXAlignment.Right
    PctLbl.ZIndex = 9993

    -- Progress bar
    local BarBg = Instance.new("Frame", LoaderCard)
    BarBg.Size = UDim2.new(1, -60, 0, 8)
    BarBg.Position = UDim2.fromOffset(30, 154)
    BarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    BarBg.BorderSizePixel = 0
    BarBg.ZIndex = 9993
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

    local BarFill = Instance.new("Frame", BarBg)
    BarFill.Size = UDim2.fromScale(0, 1)
    BarFill.BackgroundColor3 = C.Accent
    BarFill.BorderSizePixel = 0
    BarFill.ZIndex = 9994
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    local BarGlow = Instance.new("Frame", BarBg)
    BarGlow.Size = UDim2.fromScale(0, 1)
    BarGlow.BackgroundColor3 = C.Accent
    BarGlow.BackgroundTransparency = 0.55
    BarGlow.BorderSizePixel = 0
    BarGlow.ZIndex = 9993
    Instance.new("UICorner", BarGlow).CornerRadius = UDim.new(1, 0)

    -- Bottom info
    local BottomInfo = Instance.new("TextLabel", LoaderCard)
    BottomInfo.Size = UDim2.new(1, -60, 0, 18)
    BottomInfo.Position = UDim2.fromOffset(30, 178)
    BottomInfo.BackgroundTransparency = 1
    BottomInfo.Text = "User: " .. LocalPlayer.Name .. "  //  We Are Anonymous  //  MM2"
    BottomInfo.Font = Enum.Font.Gotham
    BottomInfo.TextSize = 11
    BottomInfo.TextColor3 = C.Sub
    BottomInfo.TextXAlignment = Enum.TextXAlignment.Left
    BottomInfo.ZIndex = 9993

    -- Animated dots
    local dotFrames = {}
    for i = 1, 3 do
        local dot = Instance.new("Frame", LoaderCard)
        dot.Size = UDim2.fromOffset(7, 7)
        dot.Position = UDim2.new(1, -22 - (i - 1) * 14, 1, -22)
        dot.BackgroundColor3 = C.Accent
        dot.BackgroundTransparency = 0.85
        dot.BorderSizePixel = 0
        dot.ZIndex = 9993
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        table.insert(dotFrames, dot)
    end

    local dotRunning = true
    task.spawn(function()
        local idx = 1
        while dotRunning do
            for i, d in ipairs(dotFrames) do
                tw(d, 0.18, { BackgroundTransparency = i == idx and 0.1 or 0.88 })
            end
            idx = idx % 3 + 1
            task.wait(0.33)
        end
    end)

    -- Step sequence
    local steps = {
        { text = "[ INITIALIZING FRAMEWORK... ]",      pct = 0.07 },
        { text = "[ LOADING MURDERER LOGIC... ]",       pct = 0.20 },
        { text = "[ CALIBRATING SHERIFF TRACKER... ]",  pct = 0.38 },
        { text = "[ BYPASSING ANTI-CHEAT LAYERS... ]",  pct = 0.56 },
        { text = "[ INJECTING EXPLOIT MODULES... ]",    pct = 0.74 },
        { text = "[ ARMING ESP SYSTEMS... ]",           pct = 0.90 },
        { text = "[ WELCOME, " .. string.upper(LocalPlayer.Name) .. " ]", pct = 1.00 },
    }

    for i, step in ipairs(steps) do
        StepLbl.Text = step.text
        PctLbl.Text = math.floor(step.pct * 100) .. "%"
        local dur = (i == #steps) and 0.8 or 0.75
        tw(BarFill, dur, { Size = UDim2.fromScale(step.pct, 1) })
        tw(BarGlow, dur + 0.15, { Size = UDim2.fromScale(step.pct, 1) })
        task.wait((i == #steps) and 0.9 or 0.45)
    end

    task.wait(0.35)
    dotRunning = false

    -- Slide up + fade out
    tw(LoaderCard, 0.45, { Position = UDim2.new(0.5, -240, 0.5, -150) })
    task.wait(0.18)
    tw(LoaderCard, 0.5, { BackgroundTransparency = 1 })
    tw(LoaderStroke, 0.5, { Transparency = 1 })
    tw(Divider, 0.4, { BackgroundTransparency = 1 })
    tw(BarBg, 0.4, { BackgroundTransparency = 1 })
    tw(BarFill, 0.35, { BackgroundTransparency = 1 })
    tw(BarGlow, 0.35, { BackgroundTransparency = 1 })
    tw(StepLbl, 0.35, { TextTransparency = 1 })
    tw(PctLbl, 0.35, { TextTransparency = 1 })
    tw(MainTitle, 0.35, { TextTransparency = 1 })
    tw(SubTitle, 0.35, { TextTransparency = 1 })
    tw(LogoText, 0.35, { TextTransparency = 1 })
    tw(LogoBg, 0.4, { BackgroundTransparency = 1 })
    tw(BottomInfo, 0.35, { TextTransparency = 1 })
    for _, d in ipairs(dotFrames) do
        tw(d, 0.3, { BackgroundTransparency = 1 })
    end
    task.wait(0.65)
    LoaderCard:Destroy()

    -- Reveal menu
    Main.Visible = true
    tw(Main, 0.65, { Position = originalPos })
end)

print("[RAGE HUB V3 MM2] Fully Loaded & Injected.")
