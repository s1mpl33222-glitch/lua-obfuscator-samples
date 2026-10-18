-- [[ TH SYSTEM - VERSÃO VIP - 100% COMPLETO ]] --
-- DEVELOPER: MATHEUS DA SILVA ARAUJO
-- LOCAL: MACAPARANA PE

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- FIX CORE GUI
local TargetGui = (RunService:IsStudio() or not pcall(function() return game:GetService("CoreGui") end)) and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")

local DB_URL = "https://th-system-database-default-rtdb.firebaseio.com/"

if TargetGui:FindFirstChild("TH_SYSTEM_VIP") then TargetGui.TH_SYSTEM_VIP:Destroy() end
local ScreenGui = Instance.new("ScreenGui", TargetGui); ScreenGui.Name = "TH_SYSTEM_VIP"; ScreenGui.ResetOnSpawn = false

-- [[ VARIÁVEIS DE CONTROLE ]] --
local AimActive, AimFOV, AimVisible = false, 150, false
local NoRecoil = false
local FlyActive, FlySpeed = false, 50
local SpeedValue, JumpValue = 16, 50
local KillAuraActive = false
local EspBox, EspLine, EspName, EspHealthBar, EspWeapon = false, false, false, false, false
local PuxarArmas, PuxarJoias, FakeStaff, CarroNaMao = false, false, false, false
local CarroAlvo = nil

-- [[ FOV CIRCLE ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(130, 0, 255); FOVCircle.Transparency = 0.7; FOVCircle.Visible = false

-- [[ TELA DE LOGIN ]] --
local Login = Instance.new("Frame", ScreenGui); Login.Size = UDim2.new(0, 260, 0, 310); Login.Position = UDim2.new(0.5, -130, 0.5, -155); Login.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", Login); Instance.new("UIStroke", Login).Color = Color3.fromRGB(130, 0, 255)
local L_TH = Instance.new("TextLabel", Login); L_TH.Size = UDim2.new(1,0,0,40); L_TH.Position = UDim2.new(0,0,0,20); L_TH.Text = "TH"; L_TH.TextColor3 = Color3.fromRGB(130, 0, 255); L_TH.Font = "GothamBold"; L_TH.TextSize = 35; L_TH.BackgroundTransparency = 1
local L_SYS = Instance.new("TextLabel", L_TH); L_SYS.Size = UDim2.new(1,0,0,20); L_SYS.Position = UDim2.new(0,0,1,-10); L_SYS.Text = "SYSTEM VIP"; L_SYS.TextColor3 = Color3.new(1,1,1); L_SYS.Font = "GothamBold"; L_SYS.TextSize = 14; L_SYS.BackgroundTransparency = 1
local UserIn = Instance.new("TextBox", Login); UserIn.Size = UDim2.new(0, 200, 0, 45); UserIn.Position = UDim2.new(0.5, -100, 0.4, 10); UserIn.PlaceholderText = "NICK"; UserIn.BackgroundColor3 = Color3.fromRGB(20,20,20); UserIn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", UserIn)
local KeyIn = Instance.new("TextBox", Login); KeyIn.Size = UDim2.new(0, 200, 0, 45); KeyIn.Position = UDim2.new(0.5, -100, 0.6, 15); KeyIn.PlaceholderText = "KEY"; KeyIn.BackgroundColor3 = Color3.fromRGB(20,20,20); KeyIn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyIn)
local LogBtn = Instance.new("TextButton", Login); LogBtn.Size = UDim2.new(0, 200, 0, 40); LogBtn.Position = UDim2.new(0.5, -100, 0.8, 15); LogBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 255); LogBtn.Text = "ENTRAR NO SISTEMA"; LogBtn.TextColor3 = Color3.new(1,1,1); LogBtn.Font = "GothamBold"; Instance.new("UICorner", LogBtn)

-- [[ MENU PRINCIPAL ]] --
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 230, 0, 450); Main.Position = UDim2.new(0.5, -115, 0.5, -225); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.Visible = false; Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(130, 0, 255)
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40); Title.Position = UDim2.new(0, 0, 0, 10); Title.Text = "TH SYSTEM - VERSÃO VIP"; Title.TextColor3 = Color3.fromRGB(130, 0, 255); Title.Font = "GothamBold"; Title.TextSize = 15; Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Main); CloseBtn.Size = UDim2.new(1, -20, 0, 35); CloseBtn.Position = UDim2.new(0, 10, 1, -45); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Text = "FECHAR MENU"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = "GothamBold"; Instance.new("UICorner", CloseBtn)
local OpenBtn = Instance.new("TextButton", ScreenGui); OpenBtn.Size = UDim2.new(0, 45, 0, 45); OpenBtn.Position = UDim2.new(0, 10, 0.5, -22); OpenBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12); OpenBtn.Text = "TH"; OpenBtn.TextColor3 = Color3.fromRGB(130, 0, 255); OpenBtn.Font = "GothamBold"; OpenBtn.Visible = false; Instance.new("UICorner", OpenBtn); Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(130, 0, 255)

local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -10, 1, -110); Container.Position = UDim2.new(0, 5, 0, 50); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2; Container.ScrollBarImageColor3 = Color3.fromRGB(130,0,255); local currentY = 0

local function AddLabel(txt)
    local b = Instance.new("TextLabel", Container); b.Size = UDim2.new(1, -10, 0, 25); b.Position = UDim2.new(0,5,0,currentY); b.BackgroundColor3 = Color3.fromRGB(130, 0, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b); currentY = currentY + 30
end
local function AddToggle(name, callback)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, -10, 0, 25); f.Position = UDim2.new(0,5,0,currentY); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.7, 0, 1, 0); t.Text = name; t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.TextSize = 10; t.TextXAlignment = "Left"; t.BackgroundTransparency = 1
    local bg = Instance.new("Frame", f); bg.Size = UDim2.new(0, 30, 0, 15); bg.Position = UDim2.new(1, -35, 0.5, -7.5); bg.BackgroundColor3 = Color3.fromRGB(45,45,45); Instance.new("UICorner", bg)
    local ball = Instance.new("Frame", bg); ball.Size = UDim2.new(0, 11, 0, 11); ball.Position = UDim2.new(0, 2, 0.5, -5.5); ball.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", ball)
    local act = false; local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""
    btn.MouseButton1Click:Connect(function() act = not act; bg.BackgroundColor3 = act and Color3.fromRGB(130, 0, 255) or Color3.fromRGB(45,45,45); ball.Position = act and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5); callback(act) end); currentY = currentY + 28
end
local function AddSlider(name, min, max, callback)
    local f = Instance.new("Frame", Container); f.Size = UDim2.new(1, -10, 0, 35); f.Position = UDim2.new(0,5,0,currentY); f.BackgroundTransparency = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, 0, 0, 15); t.Text = name; t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.TextSize = 9; t.BackgroundTransparency = 1
    local s_bg = Instance.new("Frame", f); s_bg.Size = UDim2.new(1, 0, 0, 3); s_bg.Position = UDim2.new(0, 0, 0.75, 0); s_bg.BackgroundColor3 = Color3.fromRGB(45,45,45); Instance.new("UICorner", s_bg)
    local fill = Instance.new("Frame", s_bg); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(130, 0, 255); Instance.new("UICorner", fill)
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""
    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then local con; con = RunService.RenderStepped:Connect(function() local p = math.clamp((UIS:GetMouseLocation().X - s_bg.AbsolutePosition.X) / s_bg.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(p,0,1,0); callback(math.floor(min + (max - min) * p)) end); UIS.InputEnded:Connect(function() con:Disconnect() end) end end); currentY = currentY + 40
end

-- [[ CONFIGURAÇÃO DO MENU ]] --
AddLabel("AIMBOT & COMBAT")
AddToggle("ATIVAR AIMBOT (HEAD)", function(v) AimActive = v end)
AddToggle("AIM VISIBLE (WALLCHECK)", function(v) AimVisible = v end)
AddToggle("MOSTRAR FOV", function(v) FOVCircle.Visible = v end)
AddSlider("FOV RAIO", 30, 600, function(v) AimFOV = v end)
AddToggle("NO RECOIL", function(v) NoRecoil = v end)

AddLabel("VISUAIS (ESP)")
AddToggle("ESP CAIXA", function(v) EspBox = v end)
AddToggle("ESP LINHA", function(v) EspLine = v end)
AddToggle("ESP NOME", function(v) EspName = v end)
AddToggle("ESP VIDA", function(v) EspHealthBar = v end)
AddToggle("ESP ARMA", function(v) EspWeapon = v end)

AddLabel("MOVIMENTAÇÃO")
AddToggle("ATIVAR FLY (Q/E)", function(v) FlyActive = v end)
AddSlider("VELOCIDADE FLY", 10, 500, function(v) FlySpeed = v end)
AddSlider("SPEED (VELOCIDADE)", 16, 300, function(v) SpeedValue = v end)
AddSlider("SUPER PULO", 50, 500, function(v) JumpValue = v end)

AddLabel("SCRIPT SPLOITS")
AddToggle("PUXAR ARMAS", function(v) PuxarArmas = v end)
AddToggle("PUXAR JOIAS", function(v) PuxarJoias = v end)
AddToggle("CARRO NA MAO (FIVEM)", function(v) CarroNaMao = v if not v then CarroAlvo = nil end end)
AddToggle("FPS 120", function(v) if setfpscap then setfpscap(v and 120 or 60) end end)
AddToggle("MODO LEVE", function(v) if v then for _,obj in pairs(game:GetDescendants()) do if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end end end end)

Container.CanvasSize = UDim2.new(0,0,0,currentY)

-- [[ ENGINE ESP 2D & BILLBOARD ]] --
local function CreateESP(p)
    local Box = Drawing.new("Square"); Box.Thickness = 1; Box.Color = Color3.fromRGB(130, 0, 255); Box.Filled = false
    local Line = Drawing.new("Line"); Line.Thickness = 1; Line.Color = Color3.fromRGB(130, 0, 255)
    
    local BGui = Instance.new("BillboardGui", TargetGui)
    BGui.Size = UDim2.new(0, 100, 0, 60); BGui.AlwaysOnTop = true; BGui.ExtentsOffset = Vector3.new(0, 3, 0)
    local NameL = Instance.new("TextLabel", BGui); NameL.Size = UDim2.new(1, 0, 0.3, 0); NameL.BackgroundTransparency = 1; NameL.TextColor3 = Color3.new(1,1,1); NameL.Font = "GothamBold"; NameL.TextSize = 12
    local WeaponL = Instance.new("TextLabel", BGui); WeaponL.Size = UDim2.new(1, 0, 0.3, 0); WeaponL.Position = UDim2.new(0,0,0.7,0); WeaponL.BackgroundTransparency = 1; WeaponL.TextColor3 = Color3.fromRGB(130,0,255); WeaponL.Font = "Gotham"; WeaponL.TextSize = 10
    local HBar = Instance.new("Frame", BGui); HBar.Size = UDim2.new(0.8, 0, 0.05, 0); HBar.Position = UDim2.new(0.1, 0, 0.4, 0); HBar.BackgroundColor3 = Color3.new(0,0,0)
    local HFill = Instance.new("Frame", HBar); HFill.Size = UDim2.new(1, 0, 1, 0); HFill.BackgroundColor3 = Color3.new(0,1,0)

    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            BGui.Adornee = p.Character.Head; BGui.Enabled = (EspName or EspHealthBar or EspWeapon)
            NameL.Visible = EspName; NameL.Text = p.Name
            HBar.Visible = EspHealthBar; HFill.Size = UDim2.new(p.Character.Humanoid.Health/100, 0, 1, 0)
            
            local tool = p.Character:FindFirstChildOfClass("Tool")
            WeaponL.Visible = EspWeapon; WeaponL.Text = tool and tool.Name or "Mãos"

            if vis then
                local sY = (Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position - Vector3.new(0,3,0)).Y - Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position + Vector3.new(0,2.6,0)).Y)
                local sX = sY * 0.6
                Box.Visible = EspBox; Box.Size = Vector2.new(sX, sY); Box.Position = Vector2.new(pos.X - sX/2, pos.Y - sY/2)
                Line.Visible = EspLine; Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Line.To = Vector2.new(pos.X, pos.Y)
            else Box.Visible = false; Line.Visible = false end
        else Box.Visible = false; Line.Visible = false; BGui.Enabled = false end
    end)
end
for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer then CreateESP(v) end end
Players.PlayerAdded:Connect(CreateESP)

-- [[ ENGINE GERAL (AIMBOT, FLY, CAR) ]] --
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = AimFOV
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        LocalPlayer.Character.Humanoid.JumpPower = JumpValue
    end

    if AimActive then
        local t = nil; local d = AimFOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local obs = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, p.Character.Head.Position}, {LocalPlayer.Character, p.Character})
                    if not AimVisible or #obs == 0 then
                        local m = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
                        if m < d then t = p; d = m end
                    end
                end
            end
        end
        if t and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end

    if FlyActive and LocalPlayer.Character then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        HRP.Velocity = Vector3.new(0, 0.1, 0)
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0,1,0) end
        HRP.CFrame = HRP.CFrame + (move * (FlySpeed/10))
    end
end)

-- [[ ENGINE CARRO NA MÃO (THROW) ]] --
RunService.Heartbeat:Connect(function()
    if CarroNaMao and LocalPlayer.Character then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        if not CarroAlvo then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") and (v.Position - HRP.Position).Magnitude < 30 then
                    CarroAlvo = v.Parent:IsA("Model") and v.Parent.PrimaryPart or v
                end
            end
        else
            CarroAlvo.Velocity = Vector3.new(0,0,0); CarroAlvo.RotVelocity = Vector3.new(0,0,0)
            CarroAlvo.CFrame = HRP.CFrame * CFrame.new(0, 5, -15)
            if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                CarroAlvo.Velocity = Camera.CFrame.LookVector * 1000
                CarroAlvo = nil
            end
        end
    end
end)

-- [[ LOGIN & DRAG ]] --
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

local function Drag(o)
    local d, s, sp; o.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = o.Position end end)
    UIS.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local del = i.Position - s; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
    UIS.InputEnded:Connect(function() d = false end)
end

LogBtn.MouseButton1Click:Connect(function()
    LogBtn.Text = "VALIDANDO..."; local s, r = pcall(function() return game:HttpGet(DB_URL.."users/"..UserIn.Text..".json") end)
    if s and r ~= "null" and tostring(HttpService:JSONDecode(r).key) == KeyIn.Text then
        Login:Destroy(); Main.Visible = true; Drag(Main); Drag(OpenBtn)
    else LogBtn.Text = "FALHA!"; task.wait(1); LogBtn.Text = "ENTRAR NO SISTEMA" end
end)
Drag(Login)
