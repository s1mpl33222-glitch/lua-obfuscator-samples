local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local PlayerGui = player:WaitForChild("PlayerGui")

local AZUL = Color3.fromRGB(0,170,255)
local AZUL_CLARO = Color3.fromRGB(100,200,255)
local AZUL_ESCURO = Color3.fromRGB(20,40,90)
local VERDE = Color3.fromRGB(45,225,95)
local BRANCO = Color3.fromRGB(240,250,255)

local Rayfield = nil
pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "SindicLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 99999
pcall(function() LoadingGui.Parent = PlayerGui end)

local LoadingBg = Instance.new("Frame")
LoadingBg.Size = UDim2.new(1,0,1,0)
LoadingBg.BackgroundColor3 = Color3.fromRGB(5,15,30)
LoadingBg.BorderSizePixel = 0
LoadingBg.Parent = LoadingGui

local BgG = Instance.new("UIGradient")
BgG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5,15,30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,100,200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5,15,30))
})
BgG.Rotation = 45
BgG.Parent = LoadingBg

local Buraco = Instance.new("Frame")
Buraco.Size = UDim2.new(0,180,0,180)
Buraco.Position = UDim2.new(0.5,-90,0.25,-90)
Buraco.BackgroundColor3 = Color3.fromRGB(0,0,0)
Buraco.BorderSizePixel = 0
Buraco.Parent = LoadingBg
Instance.new("UICorner", Buraco).CornerRadius = UDim.new(1,0)

local BStroke = Instance.new("UIStroke")
BStroke.Color = AZUL
BStroke.Thickness = 4
BStroke.Parent = Buraco

local Foto = Instance.new("ImageLabel")
Foto.Size = UDim2.new(1,-10,1,-10)
Foto.Position = UDim2.new(0,5,0,5)
Foto.BackgroundTransparency = 1
Foto.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
Foto.Parent = Buraco
Instance.new("UICorner", Foto).CornerRadius = UDim.new(1,0)

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1,0,0,80)
LoadingTitle.Position = UDim2.new(0,0,0.50,0)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Text = "SINDIC SCRIPT"
LoadingTitle.TextColor3 = AZUL
LoadingTitle.Font = Enum.Font.GothamBlack
LoadingTitle.TextSize = 48
LoadingTitle.Parent = LoadingBg

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1,0,0,25)
Sub.Position = UDim2.new(0,0,0.62,0)
Sub.BackgroundTransparency = 1
Sub.Text = "by AXY E FRANGO ESTUFADO"
Sub.TextColor3 = AZUL_CLARO
Sub.Font = Enum.Font.GothamMedium
Sub.TextSize = 14
Sub.Parent = LoadingBg

local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(0,400,0,8)
ProgressBg.Position = UDim2.new(0.5,-200,0.70,0)
ProgressBg.BackgroundColor3 = Color3.fromRGB(0,30,60)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = LoadingBg
Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1,0)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0,0,1,0)
ProgressFill.BackgroundColor3 = AZUL
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBg
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(1,0)

local ProgressText = Instance.new("TextLabel")
ProgressText.Size = UDim2.new(1,0,0,20)
ProgressText.Position = UDim2.new(0,0,0.70,20)
ProgressText.BackgroundTransparency = 1
ProgressText.Text = "Carregando... 0%"
ProgressText.TextColor3 = BRANCO
ProgressText.Font = Enum.Font.GothamBold
ProgressText.TextSize = 12
ProgressText.Parent = LoadingBg

local AutoFollowEnabled = false
local ReachEnabled = false
local ReachDistance = 10
local EsferaEnabled = false
local ESPEnabled = false
local AlertaEnabled = false
local FOVEnabled = false
local FOVValue = 70
local TPBolaEnabled = false
local AimbotBlueEnabled = false
local AimbotGreenEnabled = false
local AutoCatchEnabled = false
local AutoCatchRange = 8
local AutoCatchDelay = 1
local AutoCatchLast = 0
local AC_Hitbox = false
local AC_HitboxPart = nil
local BPAtivo = false
local BPC = nil
local BH = nil
local BPS = {}
local BPCir = nil
local BPMax = 15
local BPSv = Vector3.zero
local BPLast = nil
local esferaObjeto = nil
local espHighlight = nil
local alertaGui = nil
local FloatFollow, FloatBlue, FloatGreen = nil, nil, nil
local FPSFrame = nil

local bolas = {}
local texturasBackup = {}
local rainbowConn = nil
local isRainbow = false
local corAtual = nil
local corEscolhida = nil
local CachedBall = nil

local KEYWORDS = {"ball", "bola", "soccer", "futebol", "futbol", "pelota", "tps", "football", "sphere"}

local function UpdateCharacter(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
end
player.CharacterAdded:Connect(UpdateCharacter)

local function temKeyword(nome)
    local low = string.lower(nome)
    for _, kw in pairs(KEYWORDS) do
        if string.find(low, kw) then return true end
    end
    return false
end

local function esferica(part)
    local s = part.Size
    local avg = (s.X + s.Y + s.Z) / 3
    if avg < 0.5 or avg > 10 then return false end
    local t = avg * 0.5
    return math.abs(s.X - avg) < t and math.abs(s.Y - avg) < t and math.abs(s.Z - avg) < t
end

local function EhBola(obj)
    if not obj or not obj.Parent then return false end
    if obj:IsDescendantOf(Character) then return false end
    local n = obj.Name:lower()
    if n == "head" or n == "torso" then return false end
    if n:find("stadium") or n:find("map") or n:find("goal") or n:find("net") then return false end
    local pm = obj:FindFirstAncestorOfClass("Model")
    if pm and pm:FindFirstChildOfClass("Humanoid") then return false end
    if temKeyword(obj.Name) then return true end
    if obj:IsA("MeshPart") and esferica(obj) and not obj.Anchored then return true end
    if obj:IsA("Part") then
        local ok = pcall(function()
            if obj.Shape == Enum.PartType.Ball and not obj.Anchored then return true end
        end)
        if ok and obj.Shape == Enum.PartType.Ball and not obj.Anchored then return true end
    end
    local mesh = obj:FindFirstChildWhichIsA("SpecialMesh")
    if mesh and mesh.MeshType == Enum.MeshType.Sphere and not obj.Anchored then return true end
    return false
end

local function GetValidBall()
    if not RootPart or not RootPart.Parent then return nil end
    local closest = nil
    local menor = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            if not obj:IsDescendantOf(Character) then
                local n = obj.Name:lower()
                if n == "tps" or n == "ball" or n == "bola" then
                    local pm = obj:FindFirstAncestorOfClass("Model")
                    local isChar = pm and pm:FindFirstChildOfClass("Humanoid")
                    if not isChar then
                        local s = obj.Size
                        if s.X >= 0.5 and s.X <= 8 then
                            local d = (obj.Position - RootPart.Position).Magnitude
                            if d < menor then menor = d closest = obj end
                        end
                    end
                end
            end
        end
    end
    CachedBall = closest
    return closest
end

local function scanBolas()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if not obj:IsA("BasePart") then continue end
        local match = false
        if temKeyword(obj.Name) then match = true end
        if not match and obj.Parent and obj.Parent ~= workspace then
            if temKeyword(obj.Parent.Name) then match = true end
        end
        if not match and obj.Parent and obj.Parent.Parent then
            if obj.Parent.Parent ~= workspace and temKeyword(obj.Parent.Parent.Name) then match = true end
        end
        if not match and obj:IsA("MeshPart") and esferica(obj) and not obj.Anchored then match = true end
        if not match and obj:IsA("Part") then
            pcall(function()
                if obj.Shape == Enum.PartType.Ball and not obj.Anchored then match = true end
            end)
        end
        if not match then
            local mesh = obj:FindFirstChildWhichIsA("SpecialMesh")
            if mesh and mesh.MeshType == Enum.MeshType.Sphere and not obj.Anchored then match = true end
        end
        if match then
            found[obj] = true
            if obj.Parent and obj.Parent:IsA("Model") and obj.Parent ~= workspace then
                for _, p in pairs(obj.Parent:GetDescendants()) do
                    if p:IsA("BasePart") then found[p] = true end
                end
            end
        end
    end
    bolas = {}
    for part, _ in pairs(found) do table.insert(bolas, part) end
    return #bolas
end

local function salvarTexturas()
    for _, part in pairs(bolas) do
        if texturasBackup[part] then continue end
        local data = {}
        pcall(function()
            if part:IsA("MeshPart") and part.TextureID ~= "" then data.TextureID = part.TextureID end
        end)
        local mesh = part:FindFirstChildWhichIsA("SpecialMesh")
        if mesh then
            pcall(function()
                if mesh.TextureId ~= "" then
                    data.MeshTexId = mesh.TextureId
                    data.Mesh = mesh
                end
            end)
        end
        data.Decals = {}
        for _, child in pairs(part:GetChildren()) do
            if child:IsA("Texture") or child:IsA("Decal") then
                table.insert(data.Decals, {Obj = child, Trans = child.Transparency})
            end
        end
        texturasBackup[part] = data
    end
end

local function removerTexturasDeUma(part)
    pcall(function() if part:IsA("MeshPart") then part.TextureID = "" end end)
    pcall(function()
        local mesh = part:FindFirstChildWhichIsA("SpecialMesh")
        if mesh then mesh.TextureId = "" end
    end)
    for _, child in pairs(part:GetChildren()) do
        pcall(function()
            if child:IsA("Texture") or child:IsA("Decal") then child.Transparency = 1 end
        end)
    end
end

local function restaurarTexturas()
    for part, data in pairs(texturasBackup) do
        if not part or not part.Parent then continue end
        pcall(function() if data.TextureID then part.TextureID = data.TextureID end end)
        pcall(function() if data.MeshTexId and data.Mesh then data.Mesh.TextureId = data.MeshTexId end end)
        for _, d in pairs(data.Decals) do
            pcall(function() if d.Obj and d.Obj.Parent then d.Obj.Transparency = d.Trans end end)
        end
    end
end

local function pararRainbow()
    if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
    isRainbow = false
end

local function pintarBola(part, cor)
    if not part or not part.Parent then return end
    pcall(function()
        removerTexturasDeUma(part)
        part.Color = cor
        part.Material = Enum.Material.Neon
    end)
end

local function AplicarCor(cor)
    pararRainbow()
    corAtual = cor
    corEscolhida = cor
    salvarTexturas()
    scanBolas()
    for _, part in pairs(bolas) do
        pintarBola(part, cor)
    end
end

local function IniciarRainbow()
    pararRainbow()
    corAtual = nil
    isRainbow = true
    salvarTexturas()
    scanBolas()
    for _, part in pairs(bolas) do
        pcall(function()
            if part and part.Parent then removerTexturasDeUma(part) end
        end)
    end
    local hue = 0
    rainbowConn = RunService.Heartbeat:Connect(function(dt)
        hue = (hue + dt * 0.5) % 1
        local c = Color3.fromHSV(hue, 0.85, 1)
        for _, part in pairs(bolas) do
            pcall(function()
                if part and part.Parent then
                    part.Color = c
                    part.Material = Enum.Material.Neon
                end
            end)
        end
    end)
end

local function HabilidadeAtiva()
    if not Humanoid then return true end
    if Humanoid.Sit or Humanoid.SeatPart then return true end
    local e = Humanoid:GetState()
    if e ~= Enum.HumanoidStateType.Running and e ~= Enum.HumanoidStateType.RunningNoPhysics and e ~= Enum.HumanoidStateType.Jumping and e ~= Enum.HumanoidStateType.Landed and e ~= Enum.HumanoidStateType.Freefall then return true end
    return false
end

local function InputManual()
    return UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D)
end

local function AtualizarEsfera()
    if not EsferaEnabled then
        if esferaObjeto then esferaObjeto:Destroy() esferaObjeto = nil end
        return
    end
    if not RootPart or not RootPart.Parent then return end
    if not esferaObjeto or not esferaObjeto.Parent then
        esferaObjeto = Instance.new("Part")
        esferaObjeto.Name = "Sindic_Esfera"
        esferaObjeto.Shape = Enum.PartType.Ball
        esferaObjeto.Anchored = true
        esferaObjeto.CanCollide = false
        esferaObjeto.CanTouch = false
        esferaObjeto.CanQuery = false
        esferaObjeto.Transparency = 0.7
        esferaObjeto.Material = Enum.Material.ForceField
        esferaObjeto.Color = AZUL
        esferaObjeto.Parent = Workspace
    end
    esferaObjeto.Size = Vector3.new(ReachDistance*2,ReachDistance*2,ReachDistance*2)
    esferaObjeto.Position = RootPart.Position
end

local function AtualizarESP()
    local b = GetValidBall()
    if ESPEnabled and b and b.Parent then
        if not espHighlight or not espHighlight.Parent or espHighlight.Adornee ~= b then
            if espHighlight then espHighlight:Destroy() end
            espHighlight = Instance.new("Highlight")
            espHighlight.Adornee = b
            espHighlight.FillColor = AZUL
            espHighlight.FillTransparency = 0.5
            espHighlight.OutlineColor = AZUL
            espHighlight.OutlineTransparency = 0
            espHighlight.Parent = Camera
        end
    else
        if espHighlight then espHighlight:Destroy() espHighlight = nil end
    end
end

local function AtualizarAlerta()
    local b = GetValidBall()
    if AlertaEnabled and b and b.Parent then
        if not alertaGui or not alertaGui.Parent or alertaGui.Adornee ~= b then
            if alertaGui then alertaGui:Destroy() end
            alertaGui = Instance.new("BillboardGui")
            alertaGui.Adornee = b
            alertaGui.Size = UDim2.new(0,80,0,30)
            alertaGui.StudsOffset = Vector3.new(0,4,0)
            alertaGui.AlwaysOnTop = true
            alertaGui.Parent = PlayerGui
            local t = Instance.new("TextLabel")
            t.Name = "Dist"
            t.Size = UDim2.new(1,0,1,0)
            t.BackgroundTransparency = 1
            t.TextColor3 = AZUL
            t.Font = Enum.Font.GothamBold
            t.TextSize = 14
            t.Text = "0m"
            t.Parent = alertaGui
        end
        if RootPart and alertaGui then
            local d = math.floor((RootPart.Position - b.Position).Magnitude)
            local t = alertaGui:FindFirstChild("Dist")
            if t then t.Text = d .. "m" end
        end
    else
        if alertaGui then alertaGui:Destroy() alertaGui = nil end
    end
end

local function AtualizarFOV()
    if FOVEnabled then
        Camera.FieldOfView = math.clamp(FOVValue, 30, 120)
    else
        if Camera.FieldOfView ~= 70 then Camera.FieldOfView = 70 end
    end
end

local function DoAimbot(dir)
    local b = GetValidBall()
    if not b or not b.Parent then return end
    local vel = b.AssemblyLinearVelocity
    if vel.Magnitude < 15 then return end
    local gol = nil
    local mapa = workspace:FindFirstChild("WorkspaceStadiumMap1")
    if mapa then
        local team
        if dir == "Blue" then team = mapa:FindFirstChild("Team1") or mapa:FindFirstChild("TeamBlue")
        elseif dir == "Green" then team = mapa:FindFirstChild("Team2") or mapa:FindFirstChild("TeamGreen") end
        if team then
            local u = team:FindFirstChild("Union2") or team:FindFirstChildWhichIsA("BasePart", true)
            if u and u:IsA("BasePart") then gol = u.Position end
        end
    end
    if not gol then return end
    local dirGol = (Vector3.new(gol.X - b.Position.X, 0, gol.Z - b.Position.Z)).Unit
    local velH = Vector3.new(vel.X, 0, vel.Z)
    if velH.Magnitude < 0.1 then return end
    local velAlvo = velH.Unit:Lerp(dirGol, 0.25)
    pcall(function()
        b.AssemblyLinearVelocity = Vector3.new(velAlvo.X * velH.Magnitude, vel.Y, velAlvo.Z * velH.Magnitude)
        b.AssemblyAngularVelocity = Vector3.zero
    end)
end

local CatchRemote = nil
pcall(function() CatchRemote = ReplicatedStorage:FindFirstChild("CatchBall", true) end)

local function TryCatch(ball)
    if not ball or not ball.Parent then return end
    if CatchRemote then
        pcall(function()
            if CatchRemote:IsA("RemoteEvent") then CatchRemote:FireServer(ball)
            elseif CatchRemote:IsA("RemoteFunction") then CatchRemote:InvokeServer(ball) end
        end)
    end
    AutoCatchLast = tick()
end

local function BPI()
    if BPC then return end
    BPC = Instance.new("Folder")
    BPC.Name = "Sindic_BP"
    BPC.Parent = workspace
    BH = Instance.new("Part")
    BH.Anchored = true
    BH.CanCollide = false
    BH.CanQuery = false
    BH.CanTouch = false
    BH.CastShadow = false
    BH.Transparency = 1
    BH.Size = Vector3.new(0.1,0.1,0.1)
    BH.CFrame = CFrame.new(0,-500,0)
    BH.Parent = BPC
    for i = 1, BPMax do
        local a = Instance.new("Attachment") a.Parent = BH
        local b = Instance.new("Attachment") b.Parent = BH
        local bm = Instance.new("Beam")
        bm.Attachment0 = a
        bm.Attachment1 = b
        bm.Width0 = 0.16
        bm.Width1 = 0.16
        bm.Color = ColorSequence.new(AZUL)
        bm.LightEmission = 1
        bm.FaceCamera = true
        bm.Transparency = NumberSequence.new(0.1)
        bm.Enabled = false
        bm.Parent = BH
        BPS[i] = {a=a,b=b,beam=bm}
    end
    BPCir = Instance.new("Part")
    BPCir.Shape = Enum.PartType.Cylinder
    BPCir.Material = Enum.Material.Neon
    BPCir.Color = AZUL
    BPCir.Size = Vector3.new(0.1,7,7)
    BPCir.Anchored = true
    BPCir.CanCollide = false
    BPCir.CanQuery = false
    BPCir.CanTouch = false
    BPCir.CastShadow = false
    BPCir.Transparency = 1
    BPCir.Parent = BPC
end

local function BPH()
    if not BPC then return end
    for _, sg in ipairs(BPS) do sg.beam.Enabled = false end
    if BPCir then BPCir.Transparency = 1 end
end

RunService.Heartbeat:Connect(function(dt)
    if not BPAtivo then return end
    if not BPC then BPI() end
    local b = GetValidBall()
    if not b or not b.Parent then BPH() BPSv = Vector3.zero BPLast = nil return end
    local rv = b.AssemblyLinearVelocity
    if BPLast ~= b then BPSv = rv BPLast = b end
    BPSv = BPSv:Lerp(rv, math.clamp(dt*30,0,1))
    local v0 = BPSv
    if Vector3.new(v0.X,0,v0.Z).Magnitude < 2 and math.abs(v0.Y) < 2 then BPH() return end
    local p0 = b.Position
    local g = workspace.Gravity
    if g <= 0 then g = 196.2 end
    local r = math.min(b.Size.X,b.Size.Y,b.Size.Z)*0.5
    if r <= 0 then r = 0.5 end
    local fl = {b,BPC}
    if Character then table.insert(fl, Character) end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = fl
    local hit = workspace:Raycast(p0, Vector3.new(0,-3000,0), rp)
    local gy = hit and (hit.Position.Y + r) or (p0.Y - 800)
    local ds = 0.03
    local p = p0
    local v = v0
    local pts = {p0}
    local ld = nil
    local tv = 0
    for i = 1, 300 do
        local np = p + v*ds + Vector3.new(0,-g*ds*ds*0.5,0)
        local nv = v + Vector3.new(0,-g*ds,0)
        tv = tv + (np-p).Magnitude
        if np.Y <= gy and v.Y < 0 then
            local dm = p.Y - np.Y
            local t = dm > 0 and ((p.Y-gy)/dm) or 0
            t = math.clamp(t,0,1)
            ld = p + (np-p)*t
            table.insert(pts, ld)
            break
        end
        p = np
        v = nv
        table.insert(pts, p)
        if tv > 1000 then break end
    end
    if not ld then ld = pts[#pts] end
    local tot = #pts
    local nd = BPMax + 1
    local rsa = {}
    if tot <= 1 then
        for i = 1, nd do rsa[i] = pts[1] end
    else
        for i = 1, nd do
            local t = (i-1)/(nd-1)
            local idx = t*(tot-1)+1
            local lo = math.max(1, math.floor(idx))
            local hi = math.min(lo+1, tot)
            local f = idx - lo
            rsa[i] = pts[lo] + (pts[hi]-pts[lo])*f
        end
    end
    for i = 1, BPMax do
        local sg = BPS[i]
        if rsa[i] and rsa[i+1] then
            sg.a.WorldPosition = rsa[i]
            sg.b.WorldPosition = rsa[i+1]
            sg.beam.Enabled = true
        else
            sg.beam.Enabled = false
        end
    end
    BPCir.Transparency = 0.35
    BPCir.CFrame = CFrame.new(ld) * CFrame.Angles(0,0,math.rad(90))
end)

RunService.PreRender:Connect(function(dt)
    if not RootPart or not RootPart.Parent or not Humanoid then return end
    local b = GetValidBall()
    local ab = HabilidadeAtiva()
    AtualizarFOV()
    AtualizarEsfera()
    AtualizarESP()
    AtualizarAlerta()
    if AutoFollowEnabled and not InputManual() and b and not ab then
        local d = b.Position - RootPart.Position
        local md = Vector3.new(d.X,0,d.Z)
        if md.Magnitude > 0.5 then Humanoid:Move(md.Unit, false) end
    end
    if ReachEnabled and b and not ab then
        if (b.Position - RootPart.Position).Magnitude <= ReachDistance then
            local lf = Character:FindFirstChild("Left Foot") or Character:FindFirstChild("Left Leg")
            local rf = Character:FindFirstChild("Right Foot") or Character:FindFirstChild("Right Leg")
            pcall(function()
                firetouchinterest(RootPart, b, 0)
                firetouchinterest(RootPart, b, 1)
                if lf then firetouchinterest(lf, b, 0) firetouchinterest(lf, b, 1) end
                if rf then firetouchinterest(rf, b, 0) firetouchinterest(rf, b, 1) end
            end)
        end
    end
    if TPBolaEnabled and b and b.Parent then
        pcall(function()
            local pp = RootPart.Position
            local bp = b.Position
            if (bp - pp).Magnitude > 5 then
                local dir = (bp - pp).Unit
                RootPart.CFrame = CFrame.new(bp - (dir*2.5) + Vector3.new(0,2,0))
            end
        end)
    end
    if AimbotBlueEnabled then DoAimbot("Blue") end
    if AimbotGreenEnabled then DoAimbot("Green") end
    if AutoCatchEnabled and tick() - AutoCatchLast >= AutoCatchDelay then
        local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
        if b and hrp then
            if (b.Position - hrp.Position).Magnitude <= AutoCatchRange then
                TryCatch(b)
            end
        end
    end
    if AC_Hitbox and RootPart and RootPart.Parent then
        local d = AutoCatchRange*2
        if not AC_HitboxPart or not AC_HitboxPart.Parent then
            AC_HitboxPart = Instance.new("Part")
            AC_HitboxPart.Shape = Enum.PartType.Ball
            AC_HitboxPart.Material = Enum.Material.ForceField
            AC_HitboxPart.Color = AZUL
            AC_HitboxPart.Transparency = 0.65
            AC_HitboxPart.CanCollide = false
            AC_HitboxPart.CanQuery = false
            AC_HitboxPart.CanTouch = false
            AC_HitboxPart.Anchored = true
            AC_HitboxPart.Parent = workspace
        end
        AC_HitboxPart.Size = Vector3.new(d,d,d)
        AC_HitboxPart.Position = RootPart.Position
    elseif AC_HitboxPart and AC_HitboxPart.Parent then
        AC_HitboxPart:Destroy()
        AC_HitboxPart = nil
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if corEscolhida then
            local novas = 0
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and EhBola(part) and not texturasBackup[part] then
                    salvarTexturas()
                    pintarBola(part, corEscolhida)
                    table.insert(bolas, part)
                    novas = novas + 1
                end
            end
            if novas > 0 then
                Rayfield:Notify({Title = "🎨 Cor Aplicada", Content = novas .. " bola(s) nova(s) pintada(s)!", Duration = 2})
            end
        end
    end
end)

local function TornarArrastavel(btn)
    local dragging = false
    local dragStart, startPos
    local dragInput
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

task.spawn(function()
    local t0 = tick()
    while tick() - t0 < 5 do
        local p = (tick()-t0)/5
        ProgressFill.Size = UDim2.new(p,0,1,0)
        ProgressText.Text = "Carregando... " .. math.floor(p*100) .. "%"
        task.wait(0.03)
    end
    LoadingGui:Destroy()

    if not Rayfield then return end

    local Window = Rayfield:CreateWindow({
        Name = "SINDIC SCRIPT",
        Icon = 0,
        LoadingTitle = "SINDIC SCRIPT",
        LoadingSubtitle = "by AXY E FRANGO ESTUFADO",
        Theme = "Blue",
        ConfigurationSaving = { Enabled = false },
        KeySystem = false
    })

    local TabP = Window:CreateTab("⚽ Principal", 4483362458)
    TabP:CreateSection("Auto Follow")
    TabP:CreateToggle({Name = "Seguir Bola", CurrentValue = false, Flag = "AF", Callback = function(v) AutoFollowEnabled = v if not v and Humanoid then Humanoid:Move(Vector3.zero, false) end end})
    TabP:CreateSection("🎯 Aimbot")
    TabP:CreateToggle({Name = "Aimbot Blue", CurrentValue = false, Flag = "AB", Callback = function(v)
        AimbotBlueEnabled = v
        if FloatBlue then FloatBlue.Visible = v end
    end})
    TabP:CreateToggle({Name = "Aimbot Green", CurrentValue = false, Flag = "AG", Callback = function(v)
        AimbotGreenEnabled = v
        if FloatGreen then FloatGreen.Visible = v end
    end})

    local TabR = Window:CreateTab("🦾 Reach", 4483362458)
    TabR:CreateSection("Reach")
    TabR:CreateToggle({Name = "Ativar Reach", CurrentValue = false, Flag = "RE", Callback = function(v) ReachEnabled = v end})
    TabR:CreateSlider({Name = "Distância", Range = {1,50}, Increment = 1, Suffix = "m", CurrentValue = 10, Flag = "RD", Callback = function(v) ReachDistance = v AtualizarEsfera() end})
    TabR:CreateSection("TP Bola")
    TabR:CreateToggle({Name = "TP Bola", CurrentValue = false, Flag = "TPB", Callback = function(v) TPBolaEnabled = v end})

    local TabV = Window:CreateTab("👁️ Visual", 4483362458)
    TabV:CreateSection("🎥 FOV")
    TabV:CreateToggle({Name = "Ativar FOV", CurrentValue = false, Flag = "FOV", Callback = function(v) FOVEnabled = v end})
    TabV:CreateSlider({Name = "Valor FOV", Range = {30,120}, Increment = 1, CurrentValue = 70, Flag = "FOVS", Callback = function(v) FOVValue = v end})
    TabV:CreateSection("Esfera do Reach")
    TabV:CreateToggle({Name = "Ativar Esfera", CurrentValue = false, Flag = "ESF", Callback = function(v) EsferaEnabled = v AtualizarEsfera() end})
    TabV:CreateSection("ESP da Bola")
    TabV:CreateToggle({Name = "Ativar ESP", CurrentValue = false, Flag = "ESP", Callback = function(v) ESPEnabled = v end})
    TabV:CreateSection("Alerta Distância")
    TabV:CreateToggle({Name = "Ativar Alerta", CurrentValue = false, Flag = "AL", Callback = function(v) AlertaEnabled = v end})
    TabV:CreateSection("Ball Predict")
    TabV:CreateToggle({Name = "Mostrar Previsão", CurrentValue = false, Flag = "BPT", Callback = function(v) BPAtivo = v if v then BPI() else BPH() end end})

    local TabB = Window:CreateTab("🎨 Bola", 4483362458)
    TabB:CreateSection("🔍 Detectar Bola")
    TabB:CreateButton({Name = "🔍 DETECTAR BOLA", Callback = function()
        local n = scanBolas()
        Rayfield:Notify({Title = "Detecção", Content = n .. " bola(s) encontrada(s)", Duration = 2})
    end})
    TabB:CreateSection("🎨 Color Picker")
    TabB:CreateColorPicker({Name = "Escolher Cor", Color = AZUL, Flag = "CP", Callback = function(c) AplicarCor(c) end})
    TabB:CreateSection("Cores Rápidas")
    local CORES = {
        {N="🔵 Azul", C=Color3.fromRGB(40,130,255)},
        {N="🟢 Verde", C=Color3.fromRGB(45,225,95)},
        {N="🟣 Roxo", C=Color3.fromRGB(155,55,255)},
        {N="🟡 Amarelo", C=Color3.fromRGB(255,220,30)},
        {N="⚪ Branco", C=Color3.fromRGB(255,255,255)},
        {N="🔴 Vermelho", C=Color3.fromRGB(255,45,45)},
        {N="💗 Rosa", C=Color3.fromRGB(255,85,185)},
        {N="🟠 Laranja", C=Color3.fromRGB(255,150,30)},
        {N="💎 Ciano", C=Color3.fromRGB(35,220,245)},
        {N="✨ Dourado", C=Color3.fromRGB(255,195,50)},
        {N="💚 Lima", C=Color3.fromRGB(140,255,50)},
        {N="🌊 Turquesa", C=Color3.fromRGB(0,200,180)},
        {N="💜 Violeta", C=Color3.fromRGB(180,30,220)},
        {N="🍑 Salmão", C=Color3.fromRGB(255,120,120)},
        {N="🩵 Azul Claro", C=Color3.fromRGB(120,200,255)},
        {N="🍃 Verde Água", C=Color3.fromRGB(150,240,200)},
        {N="🟤 Marrom", C=Color3.fromRGB(140,85,45)},
        {N="⚫ Cinza", C=Color3.fromRGB(140,140,150)},
        {N="🖤 Preto", C=Color3.fromRGB(15,15,20)},
        {N="🎀 Neon Pink", C=Color3.fromRGB(255,20,147)},
        {N="💐 Lavanda", C=Color3.fromRGB(200,170,255)},
    }
    for _, cor in ipairs(CORES) do
        TabB:CreateButton({Name = cor.N, Callback = function() AplicarCor(cor.C) end})
    end
    TabB:CreateButton({Name = "🌈 Arco-Íris", Callback = function() IniciarRainbow() end})
    TabB:CreateButton({Name = "↩ Restaurar Original", Callback = function()
        pararRainbow()
        restaurarTexturas()
        corAtual = nil
        corEscolhida = nil
    end})
    TabB:CreateSection("Auto Catch")
    TabB:CreateToggle({Name = "Ativar Auto Catch", CurrentValue = false, Flag = "AC", Callback = function(v) AutoCatchEnabled = v end})
    TabB:CreateSlider({Name = "Distância", Range = {3,30}, Increment = 1, Suffix = " studs", CurrentValue = 8, Flag = "ACR", Callback = function(v) AutoCatchRange = v end})
    TabB:CreateSlider({Name = "Cooldown", Range = {0.2,3}, Increment = 0.1, Suffix = "s", CurrentValue = 1, Flag = "ACD", Callback = function(v) AutoCatchDelay = v end})
    TabB:CreateToggle({Name = "Mostrar Hitbox", CurrentValue = false, Flag = "ACH", Callback = function(v) AC_Hitbox = v end})

    local TabC = Window:CreateTab("🎭 Chars", 4483362458)
    TabC:CreateSection("Chars Disponíveis")
    local Chars = {
        "Feliipeef","pret_oncio","jessnaldo","lucasbr8181","PositiveVapor",
        "kvbberdad","kvbber","ongoal","leolity","pauloneto05",
        "candyxzzz0","BRENOTAKEDA2011","monoball_jhh","defantastico",
        "emaofj","ByGui08","levi_furacao","o_lfk",
        "feliou23","thunder65q","MiguelcalebeGamer202","legendinho",
        "THIXGOOOOOO","talenttt","vnpthu","oxlade","Dismalbeni",
        "megutrap","brvnofalcon","Rhuanbla","SenAstrozx","I_Ruanblox",
        "Rvnezzy","heheboi202000","Nescauzin_skills","heitor756666",
        "nexzaard","mitoashpikachu2","rosa_skillsz","zico_alt123",
        "ry_dinno","cachorao_fla","barard28","yurinho_0011",
        "deyvztcs","eperdro14","Alex151kk"
    }
    local function SendChar(name)
        local ok = pcall(function()
            local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if ch then ch:SendAsync(":char " .. name) end
        end)
        if not ok then
            pcall(function()
                ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(":char " .. name, "All")
            end)
        end
    end
    for _, cn in ipairs(Chars) do
        TabC:CreateButton({Name = "🎭 " .. cn, Callback = function()
            SendChar(cn)
            Rayfield:Notify({Title = "Char", Content = "Aplicando: " .. cn, Duration = 2})
        end})
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SindicFloat"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    FloatFollow = Instance.new("TextButton")
    FloatFollow.Parent = ScreenGui
    FloatFollow.BackgroundColor3 = Color3.fromRGB(5,15,30)
    FloatFollow.Position = UDim2.new(0.83,0,0.18,0)
    FloatFollow.Size = UDim2.new(0,140,0,50)
    FloatFollow.Font = Enum.Font.GothamBlack
    FloatFollow.Text = "⚽ FOLLOW: OFF"
    FloatFollow.TextColor3 = AZUL
    FloatFollow.TextSize = 12
    FloatFollow.AutoButtonColor = false
    Instance.new("UICorner", FloatFollow).CornerRadius = UDim.new(0,12)
    local sf = Instance.new("UIStroke") sf.Color = AZUL sf.Thickness = 2 sf.Parent = FloatFollow
    TornarArrastavel(FloatFollow)
    FloatFollow.MouseButton1Click:Connect(function()
        AutoFollowEnabled = not AutoFollowEnabled
        FloatFollow.Text = AutoFollowEnabled and "⚽ FOLLOW: ON" or "⚽ FOLLOW: OFF"
        if not AutoFollowEnabled and Humanoid then Humanoid:Move(Vector3.zero, false) end
    end)

    FloatBlue = Instance.new("TextButton")
    FloatBlue.Parent = ScreenGui
    FloatBlue.BackgroundColor3 = Color3.fromRGB(5,15,30)
    FloatBlue.Position = UDim2.new(0.83,0,0.28,0)
    FloatBlue.Size = UDim2.new(0,140,0,42)
    FloatBlue.Font = Enum.Font.GothamBlack
    FloatBlue.Text = "🎯 BLUE: OFF"
    FloatBlue.TextColor3 = AZUL
    FloatBlue.TextSize = 11
    FloatBlue.AutoButtonColor = false
    FloatBlue.Visible = false
    Instance.new("UICorner", FloatBlue).CornerRadius = UDim.new(0,12)
    local sb = Instance.new("UIStroke") sb.Color = AZUL sb.Thickness = 2 sb.Parent = FloatBlue
    TornarArrastavel(FloatBlue)
    FloatBlue.MouseButton1Click:Connect(function()
        AimbotBlueEnabled = not AimbotBlueEnabled
        FloatBlue.Text = AimbotBlueEnabled and "🎯 BLUE: ON" or "🎯 BLUE: OFF"
    end)

    FloatGreen = Instance.new("TextButton")
    FloatGreen.Parent = ScreenGui
    FloatGreen.BackgroundColor3 = Color3.fromRGB(5,30,15)
    FloatGreen.Position = UDim2.new(0.83,0,0.38,0)
    FloatGreen.Size = UDim2.new(0,140,0,42)
    FloatGreen.Font = Enum.Font.GothamBlack
    FloatGreen.Text = "🎯 GREEN: OFF"
    FloatGreen.TextColor3 = VERDE
    FloatGreen.TextSize = 11
    FloatGreen.AutoButtonColor = false
    FloatGreen.Visible = false
    Instance.new("UICorner", FloatGreen).CornerRadius = UDim.new(0,12)
    local sg = Instance.new("UIStroke") sg.Color = VERDE sg.Thickness = 2 sg.Parent = FloatGreen
    TornarArrastavel(FloatGreen)
    FloatGreen.MouseButton1Click:Connect(function()
        AimbotGreenEnabled = not AimbotGreenEnabled
        FloatGreen.Text = AimbotGreenEnabled and "🎯 GREEN: ON" or "🎯 GREEN: OFF"
    end)

    FPSFrame = Instance.new("Frame")
    FPSFrame.Parent = ScreenGui
    FPSFrame.Size = UDim2.new(0,85,0,32)
    FPSFrame.Position = UDim2.new(0.02,0,0.02,0)
    FPSFrame.BackgroundColor3 = Color3.fromRGB(5,15,30)
    FPSFrame.BackgroundTransparency = 0.1
    Instance.new("UICorner", FPSFrame).CornerRadius = UDim.new(0,10)
    local fpsStroke = Instance.new("UIStroke") fpsStroke.Color = AZUL fpsStroke.Thickness = 1.5 fpsStroke.Parent = FPSFrame
    local FPSText = Instance.new("TextLabel")
    FPSText.Parent = FPSFrame
    FPSText.Size = UDim2.fromScale(1,1)
    FPSText.BackgroundTransparency = 1
    FPSText.Text = "FPS: 60"
    FPSText.TextColor3 = BRANCO
    FPSText.Font = Enum.Font.GothamBold
    FPSText.TextSize = 14
    TornarArrastavel(FPSFrame)
    local frames = 0
    local lastTime = tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - lastTime >= 1 then
            local fps = frames
            FPSText.Text = "FPS: " .. fps
            if fps >= 50 then
                FPSText.TextColor3 = VERDE
            elseif fps >= 30 then
                FPSText.TextColor3 = Color3.fromRGB(255,200,60)
            else
                FPSText.TextColor3 = Color3.fromRGB(255,60,60)
            end
            frames = 0
            lastTime = tick()
        end
    end)

    Rayfield:Notify({Title = "SINDIC SCRIPT", Content = "Carregado! by AXY E FRANGO ESTUFADO", Duration = 5, Image = 4483362458})

    task.spawn(function()
        task.wait(1.5)
        local RG = CoreGui:FindFirstChild("Rayfield") or PlayerGui:FindFirstChild("Rayfield")
        if not RG then return end
        for _, obj in ipairs(RG:GetDescendants()) do
            pcall(function()
                if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    if obj.BackgroundColor3 == Color3.fromRGB(25,25,25)
                    or obj.BackgroundColor3 == Color3.fromRGB(30,30,30)
                    or obj.BackgroundColor3 == Color3.fromRGB(20,20,20) then
                        obj.BackgroundColor3 = AZUL_ESCURO
                    end
                end
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    obj.TextColor3 = AZUL_CLARO
                end
                if obj:IsA("UIStroke") then obj.Color = AZUL end
                if obj:IsA("ScrollingFrame") then obj.ScrollBarImageColor3 = AZUL end
            end)
        end
    end)
end)

workspace.DescendantAdded:Connect(function(obj)
    if not obj:IsA("BasePart") then return end
    task.wait(0.3)
    if EhBola(obj) and corEscolhida then
        table.insert(bolas, obj)
        salvarTexturas()
        pintarBola(obj, corEscolhida)
    end
end)

task.delay(0.3, function()
    scanBolas()
end)

print("✅ SINDIC SCRIPT CARREGADO - by AXY E FRANGO ESTUFADO")