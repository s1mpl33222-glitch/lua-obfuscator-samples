-- LUXZ HUB
-- Creator: Luxz
-- Roblox: nik12qe12345
-- Friends: Larppingo

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local ENV = _G
pcall(function()
    if getgenv then
        ENV = getgenv()
    end
end)

if ENV.LUXZ_HUB_CLEANUP then
    pcall(ENV.LUXZ_HUB_CLEANUP)
    ENV.LUXZ_HUB_CLEANUP = nil
end

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local IMAGE = "rbxthumb://type=Asset&id=99464333170543&w=420&h=420"

local function parentGui(gui)
    local ok = pcall(function()
        if gethui then
            gui.Parent = gethui()
        else
            gui.Parent = game.CoreGui
        end
    end)
    if not ok or not gui.Parent then
        gui.Parent = Player:WaitForChild("PlayerGui")
    end
end

pcall(function()
    local old = game.CoreGui:FindFirstChild("LuxzHub")
    if old then old:Destroy() end
end)

pcall(function()
    local pg = Player:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("LuxzHub")
        if old then old:Destroy() end
    end
end)

local GUI = Instance.new("ScreenGui")
GUI.Name = "LuxzHub"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
parentGui(GUI)

local OriginalSkies = {}
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then
        table.insert(OriginalSkies, v:Clone())
    end
end

local OriginalTerrainGrassColor
if Terrain then
    pcall(function()
        OriginalTerrainGrassColor = Terrain:GetMaterialColor(Enum.Material.Grass)
    end)
end

local OriginalGrassParts = setmetatable({}, {__mode="k"})
local HubCleared = false
local GlobalInputConnection
local RatioConnection
local DescendantAddedConnection
local CharacterAddedConnection
local PersistentConnections = {}

local function TrackConnection(connection)
    if connection then
        table.insert(PersistentConnections, connection)
    end
    return connection
end

local function DisconnectPersistentConnections()
    for i = #PersistentConnections, 1, -1 do
        local connection = PersistentConnections[i]
        pcall(function()
            connection:Disconnect()
        end)
        PersistentConnections[i] = nil
    end
end

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function FixAsset(id)
    id = tostring(id)
    if string.find(id, "rbxasset://", 1, true) then
        return id
    end
    return "rbxassetid://" .. id
end

local SKYBOXES = {
    {Category="🌤️ REALISTAS",Name="Cinematic",Bk="162001887",Dn="161998893",Ft="162001897",Lf="162001904",Rt="162001919",Up="162001926"},
    {Category="🌤️ REALISTAS",Name="Classic Roblox",Bk="rbxasset://textures/sky/sky512_bk.tex",Dn="rbxasset://textures/sky/sky512_dn.tex",Ft="rbxasset://textures/sky/sky512_ft.tex",Lf="rbxasset://textures/sky/sky512_lf.tex",Rt="rbxasset://textures/sky/sky512_rt.tex",Up="rbxasset://textures/sky/sky512_up.tex"},
    {Category="🌤️ REALISTAS",Name="Blue Sky",Bk="135483466",Dn="135483484",Ft="135483461",Lf="135483495",Rt="135483499",Up="135483475"},
    {Category="🌤️ REALISTAS",Name="Beach",Bk="173380597",Dn="173380627",Ft="173380642",Lf="173380671",Rt="173380774",Up="173380790"},
    {Category="🌤️ REALISTAS",Name="Green Haze",Bk="160193404",Dn="160193466",Ft="160193461",Lf="160193469",Rt="160193463",Up="160193458"},
    {Category="🌅 PÔR DO SOL",Name="Sunset",Bk="323494035",Dn="323494368",Ft="323494130",Lf="323494252",Rt="323494067",Up="323493360"},
    {Category="🌅 PÔR DO SOL",Name="Setting Sun",Bk="626460377",Dn="626460216",Ft="626460513",Lf="626473032",Rt="626458639",Up="626460625"},
    {Category="🌅 PÔR DO SOL",Name="Purple Sunset",Bk="264908339",Dn="264907909",Ft="264909420",Lf="264909758",Rt="264908886",Up="264907379"},
    {Category="🌅 PÔR DO SOL",Name="Pink Morning",Bk="12635309703",Dn="12635311686",Ft="12635312870",Lf="12635313718",Rt="12635315817",Up="12635316856"},
    {Category="🌌 ESPAÇO",Name="Galaxy",Bk="159454299",Dn="159454296",Ft="159454293",Lf="159454286",Rt="159454300",Up="159454288"},
    {Category="🌌 ESPAÇO",Name="Blue Planet",Bk="218955819",Dn="218953419",Ft="218954524",Lf="218958493",Rt="218957134",Up="218950090"},
    {Category="🌌 ESPAÇO",Name="Over Planet",Bk="165052268",Dn="165052286",Ft="165052328",Lf="165052365",Rt="165052306",Up="165052345"},
    {Category="🌙 NOITE",Name="Red Night",Bk="401664839",Dn="401664862",Ft="401664960",Lf="401664881",Rt="401664901",Up="401664936"},
    {Category="🌙 NOITE",Name="Star Night",Bk="2570432999",Dn="2570433005",Ft="2570432998",Lf="2570433000",Rt="2570432997",Up="2570432996"},
    {Category="🎨 COLORIDOS",Name="Vaporwave",Bk="8631780182",Dn="8631784904",Ft="8631769834",Lf="8631777199",Rt="8631735555",Up="8631782345"},
    {Category="🎨 COLORIDOS",Name="Purple",Bk="8539982183",Dn="8539981943",Ft="8539981721",Lf="8539981424",Rt="8539980766",Up="8539981085"},
    {Category="🎨 COLORIDOS",Name="Purple 3",Bk="433274085",Dn="433274194",Ft="433274131",Lf="433274370",Rt="433274429",Up="433274285"},
    {Category="🎨 COLORIDOS",Name="White Purple",Bk="8107841671",Dn="6444884785",Ft="8107841671",Lf="8107841671",Rt="8107841671",Up="8107849791"},
    {Category="🎨 COLORIDOS",Name="White Pink",Bk="11427769401",Dn="11427770685",Ft="11427769401",Lf="11427769401",Rt="11427769401",Up="11427771954"}
}

local function ApplySkybox(data)
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    local s = Instance.new("Sky")
    s.Name = "LuxzSky"
    s.SkyboxBk = FixAsset(data.Bk)
    s.SkyboxDn = FixAsset(data.Dn)
    s.SkyboxFt = FixAsset(data.Ft)
    s.SkyboxLf = FixAsset(data.Lf)
    s.SkyboxRt = FixAsset(data.Rt)
    s.SkyboxUp = FixAsset(data.Up)
    s.CelestialBodiesShown = true
    s.StarCount = 3000
    s.Parent = Lighting
end

local function IsCharacterPart(obj)
    local current = obj
    while current and current ~= Workspace do
        if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
            return true
        end
        current = current.Parent
    end
    return false
end

local function HasBallName(obj)
    if not obj then return false end
    local n = string.lower(obj.Name)
    local names = {"soccerball","football","matchball","gameball","futebol","bola","ball","tps"}
    for _, word in ipairs(names) do
        if string.find(n, word, 1, true) then return true end
    end
    return false
end

local function IsBall(part)
    if not part or not part:IsA("BasePart") or IsCharacterPart(part) then return false end
    if string.lower(part.Name) == "tps" then return true end
    if HasBallName(part) or HasBallName(part.Parent) or (part.Parent and HasBallName(part.Parent.Parent)) then
        return true
    end
    local biggest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
    local smallest = math.min(part.Size.X, part.Size.Y, part.Size.Z)
    if biggest < 0.5 or biggest > 8 then return false end
    if part:IsA("Part") and part.Shape == Enum.PartType.Ball and not part.Anchored then return true end
    if part:IsA("MeshPart") and not part.Anchored and smallest / biggest >= 0.80 then return true end
    return false
end

local GRASS_PRESETS = {
    {"🔵 Azul",Color3.fromRGB(20,90,255)},
    {"🧊 Azul Gelo",Color3.fromRGB(70,190,255)},
    {"🟣 Roxo",Color3.fromRGB(120,40,200)},
    {"💜 Violeta",Color3.fromRGB(170,60,255)},
    {"🔴 Vermelho",Color3.fromRGB(210,35,35)},
    {"❤️ Crimson",Color3.fromRGB(115,15,25)},
    {"🌸 Rosa",Color3.fromRGB(255,75,170)},
    {"🟠 Laranja",Color3.fromRGB(255,120,25)},
    {"🟡 Dourado",Color3.fromRGB(220,175,35)},
    {"⚪ Branco",Color3.fromRGB(225,225,225)},
    {"⚫ Preto",Color3.fromRGB(20,20,20)},
    {"💠 Ciano",Color3.fromRGB(25,220,215)},
    {"🟢 Lime",Color3.fromRGB(120,255,25)},
    {"☢️ Verde Neon",Color3.fromRGB(0,255,70)}
}

local function IsGrassPart(part)
    if not part or not part:IsA("BasePart") or IsBall(part) or IsCharacterPart(part) then return false end
    if part.Size.X < 15 or part.Size.Z < 15 or not part.Anchored then return false end
    if part.Material == Enum.Material.Grass then return true end
    local n = string.lower(part.Name)
    for _, word in ipairs({"grass","grama","campo","field","pitch","turf","ground","lawn"}) do
        if string.find(n, word, 1, true) then return true end
    end
    local c = part.Color
    return part.Size.X >= 30 and part.Size.Z >= 30 and c.G > c.R * 1.10 and c.G > c.B * 1.10
end

local function ApplyGrass(color)
    if Terrain then
        pcall(function() Terrain:SetMaterialColor(Enum.Material.Grass, color) end)
    end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if IsGrassPart(v) then
            if OriginalGrassParts[v] == nil then
                OriginalGrassParts[v] = v.Color
            end
            pcall(function() v.Color = color end)
        end
    end
end

local function RestoreGrass()
    if Terrain and OriginalTerrainGrassColor then
        pcall(function()
            Terrain:SetMaterialColor(Enum.Material.Grass, OriginalTerrainGrassColor)
        end)
    end

    for part, color in pairs(OriginalGrassParts) do
        if part and part.Parent then
            pcall(function()
                part.Color = color
            end)
        end
    end

    for part in pairs(OriginalGrassParts) do
        OriginalGrassParts[part] = nil
    end
end

local OriginalBallVisuals = setmetatable({}, {__mode="k"})
local RGBBallEnabled = false
local RGBBallConnection
local CurrentBallColor

local function SaveBallVisual(obj)
    if OriginalBallVisuals[obj] then return end
    if obj:IsA("BasePart") then
        OriginalBallVisuals[obj] = {T="Part",Color=obj.Color}
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        OriginalBallVisuals[obj] = {T="Texture",Color=obj.Color3,Transparency=obj.Transparency}
    elseif obj:IsA("SpecialMesh") then
        OriginalBallVisuals[obj] = {T="Mesh",VertexColor=obj.VertexColor}
    end
end

local function ColorBallObject(obj, color)
    SaveBallVisual(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Color = color
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Color3 = color
        elseif obj:IsA("SpecialMesh") then
            obj.VertexColor = Vector3.new(color.R, color.G, color.B)
        end
    end)
end

local function ApplyColorToBall(ball, color)
    if not ball or not ball.Parent or not ball:IsA("BasePart") or not IsBall(ball) then return end
    ColorBallObject(ball, color)
    for _, v in ipairs(ball:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SpecialMesh") then
            ColorBallObject(v, color)
        end
    end
end

local function GetRGBBalls()
    local tps, fallback = {}, {}
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not IsCharacterPart(v) then
            local biggest = math.max(v.Size.X, v.Size.Y, v.Size.Z)
            if biggest <= 8 then
                if string.lower(v.Name) == "tps" then
                    table.insert(tps, v)
                elseif IsBall(v) then
                    table.insert(fallback, v)
                end
            end
        end
    end
    return #tps > 0 and tps or fallback
end

local function StopRGBBall()
    RGBBallEnabled = false
    if RGBBallConnection then
        RGBBallConnection:Disconnect()
        RGBBallConnection = nil
    end
end

local function StartRGBBall()
    if RGBBallEnabled then return end
    RGBBallEnabled = true
    CurrentBallColor = nil
    local hue, timer = 0, 0
    RGBBallConnection = RunService.RenderStepped:Connect(function(dt)
        if not RGBBallEnabled then return end
        hue = (hue + dt * 0.35) % 1
        timer += dt
        if timer < 0.03 then return end
        timer = 0
        local color = Color3.fromHSV(hue, 1, 1)
        for _, ball in ipairs(GetRGBBalls()) do
            ApplyColorToBall(ball, color)
        end
    end)
end

local function ToggleRGBBall()
    if RGBBallEnabled then StopRGBBall() else StartRGBBall() end
end

local function SetBallColor(color)
    StopRGBBall()
    CurrentBallColor = color
    for _, ball in ipairs(GetRGBBalls()) do
        ApplyColorToBall(ball, color)
    end
end

local function RestoreBallColor()
    StopRGBBall()
    CurrentBallColor = nil
    for obj, data in pairs(OriginalBallVisuals) do
        if obj and obj.Parent then
            pcall(function()
                if data.T == "Part" then
                    obj.Color = data.Color
                elseif data.T == "Texture" then
                    obj.Color3 = data.Color
                    obj.Transparency = data.Transparency
                elseif data.T == "Mesh" then
                    obj.VertexColor = data.VertexColor
                end
            end)
        end
    end
    for obj in pairs(OriginalBallVisuals) do OriginalBallVisuals[obj] = nil end
end

local BallFireEnabled = false

local function AddFire(ball)
    if not ball or not ball:IsA("BasePart") or not IsBall(ball) or ball:FindFirstChild("LuxzBallFire") then return end
    local marker = Instance.new("BoolValue")
    marker.Name = "LuxzBallFire"
    marker.Parent = ball
    local fire = Instance.new("Fire")
    fire.Name = "LuxzFire"
    fire.Color = Color3.fromRGB(255,80,0)
    fire.SecondaryColor = Color3.fromRGB(255,220,0)
    fire.Size = 5
    fire.Heat = 10
    fire.Parent = ball
end

local function ToggleFire()
    BallFireEnabled = not BallFireEnabled
    if BallFireEnabled then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and IsBall(v) then AddFire(v) end
        end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "LuxzBallFire" or v.Name == "LuxzFire" then
                pcall(function() v:Destroy() end)
            end
        end
    end
end

local AutoFollowBallEnabled = false
local AutoFollowConnection
local CurrentFollowBall
local FollowScanTimer = 0
local FollowStopDistance = 0.20
local ManualSteerStrength = 1.25
local PlayerControls = nil

pcall(function()
    local PlayerModule = require(
        Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    )
    PlayerControls = PlayerModule:GetControls()
end)
local FollowBallBind = Enum.KeyCode.Q
local WaitingFollowBind = false
local FollowToggleButton
local FollowBindButton
local FloatingFollowButton
local FloatingFollowLockButton
local FloatingFollowEnabled = true
local FloatingFollowLocked = false
local FloatingFollowMenuButton
local HubEntered = false

local function GetKeyName(key)
    local names = {
        LeftControl="CTRL ESQ.",RightControl="CTRL DIR.",
        LeftShift="SHIFT ESQ.",RightShift="SHIFT DIR.",
        LeftAlt="ALT ESQ.",RightAlt="ALT DIR.",
        Space="ESPAÇO",Return="ENTER",Escape="ESC",Backspace="BACKSPACE"
    }
    return names[key.Name] or key.Name
end

local function GetCharacterData()
    local char = Player.Character
    if not char then return nil,nil,nil end
    return char, char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart")
end

local function IsValidTPSBall(part)
    if not part or not part.Parent or not part:IsA("BasePart") then return false end
    if string.lower(part.Name) ~= "tps" then return false end
    if IsCharacterPart(part) or part.Anchored then return false end

    local biggest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
    local smallest = math.min(part.Size.X, part.Size.Y, part.Size.Z)

    if biggest < 0.5 or biggest > 6 then return false end
    if smallest / biggest < 0.60 then return false end

    return true
end

local function FindClosestBall()
    local _,_,root = GetCharacterData()
    if not root then return nil end

    local closest = nil
    local closestDistance = math.huge

    for _, part in ipairs(Workspace:GetDescendants()) do
        if IsValidTPSBall(part) then
            local offset = Vector3.new(
                part.Position.X - root.Position.X,
                0,
                part.Position.Z - root.Position.Z
            )

            local distance = offset.Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closest = part
            end
        end
    end

    if closest then
        return closest
    end

    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and IsBall(part) then
            local offset = Vector3.new(
                part.Position.X - root.Position.X,
                0,
                part.Position.Z - root.Position.Z
            )

            local distance = offset.Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closest = part
            end
        end
    end

    return closest
end

local function GetManualDirection()
    local cam = Workspace.CurrentCamera
    if not cam then return Vector3.zero end

    local forward = Vector3.new(
        cam.CFrame.LookVector.X,
        0,
        cam.CFrame.LookVector.Z
    )

    local right = Vector3.new(
        cam.CFrame.RightVector.X,
        0,
        cam.CFrame.RightVector.Z
    )

    if forward.Magnitude > 0 then
        forward = forward.Unit
    end

    if right.Magnitude > 0 then
        right = right.Unit
    end

    if PlayerControls then
        local ok, move = pcall(function()
            return PlayerControls:GetMoveVector()
        end)

        if ok and move then
            local dir =
                right * move.X
                + forward * -move.Z

            if dir.Magnitude > 1 then
                dir = dir.Unit
            end

            if dir.Magnitude > 0.01 then
                return dir
            end
        end
    end

    local dir = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then
        dir += forward
    end

    if UIS:IsKeyDown(Enum.KeyCode.S) then
        dir -= forward
    end

    if UIS:IsKeyDown(Enum.KeyCode.D) then
        dir += right
    end

    if UIS:IsKeyDown(Enum.KeyCode.A) then
        dir -= right
    end

    if dir.Magnitude > 1 then
        dir = dir.Unit
    end

    return dir
end

local function UpdateFollowButtons()
    if FollowToggleButton and FollowToggleButton.Parent then
        FollowToggleButton.Text = "      ⚽ Seguir Bola: " .. (AutoFollowBallEnabled and "ON" or "OFF")
    end
    if FollowBindButton and FollowBindButton.Parent and not WaitingFollowBind then
        FollowBindButton.Text = "      ⌨️ Bind ligar/desligar: " .. GetKeyName(FollowBallBind)
    end
    if FloatingFollowMenuButton and FloatingFollowMenuButton.Parent then
        FloatingFollowMenuButton.Text = "      📱 Botão flutuante: " .. (FloatingFollowEnabled and "ON" or "OFF")
    end
    if FloatingFollowButton and FloatingFollowButton.Parent then
        FloatingFollowButton.Visible = HubEntered and FloatingFollowEnabled
        FloatingFollowButton.Text = AutoFollowBallEnabled and "⚽ SEGUIR: ON" or "⚽ SEGUIR: OFF"
        FloatingFollowButton.BackgroundColor3 = AutoFollowBallEnabled and Color3.fromRGB(25,135,65) or Color3.fromRGB(130,25,35)
    end
    if FloatingFollowLockButton and FloatingFollowLockButton.Parent then
        FloatingFollowLockButton.Visible = HubEntered and FloatingFollowEnabled
        FloatingFollowLockButton.Text = FloatingFollowLocked and "🔒" or "🔓"
        FloatingFollowLockButton.BackgroundColor3 = FloatingFollowLocked and Color3.fromRGB(95,95,95) or Color3.fromRGB(35,35,35)
    end
end

local function StopAutoFollowBall()
    AutoFollowBallEnabled = false
    CurrentFollowBall = nil
    FollowScanTimer = 0
    if AutoFollowConnection then AutoFollowConnection:Disconnect() AutoFollowConnection = nil end
    local _, hum = GetCharacterData()
    if hum then hum.AutoRotate = true end
    UpdateFollowButtons()
end

local function StartAutoFollowBall()
    if AutoFollowBallEnabled then return end
    AutoFollowBallEnabled = true
    CurrentFollowBall = nil
    FollowScanTimer = 1
    if AutoFollowConnection then AutoFollowConnection:Disconnect() end
    UpdateFollowButtons()
    AutoFollowConnection = RunService.RenderStepped:Connect(function(dt)
        if not AutoFollowBallEnabled then return end
        local _, hum, root = GetCharacterData()
        if not hum or not root or hum.Health <= 0 then return end
        hum.AutoRotate = true
        FollowScanTimer += dt
        local currentInvalid =
            not CurrentFollowBall
            or not CurrentFollowBall.Parent
            or (
                string.lower(CurrentFollowBall.Name) == "tps"
                and not IsValidTPSBall(CurrentFollowBall)
            )

        local currentTooFar = false

        if CurrentFollowBall and CurrentFollowBall.Parent then
            local currentOffset = Vector3.new(
                CurrentFollowBall.Position.X - root.Position.X,
                0,
                CurrentFollowBall.Position.Z - root.Position.Z
            )

            currentTooFar = currentOffset.Magnitude > 250
        end

        if currentInvalid or currentTooFar then
            FollowScanTimer = 0
            CurrentFollowBall = FindClosestBall()
        elseif FollowScanTimer >= 0.25 then
            FollowScanTimer = 0
        end
        local ball = CurrentFollowBall
        if not ball or not ball.Parent then return end
        local toBall = Vector3.new(ball.Position.X-root.Position.X,0,ball.Position.Z-root.Position.Z)
        local distance = toBall.Magnitude
        local manual = GetManualDirection()
        if distance > FollowStopDistance then
            local follow = toBall.Unit
            local final = follow

            if manual.Magnitude > 0.01 then
                local inputAmount = math.clamp(manual.Magnitude, 0, 1)

                final =
                    follow * (1 - inputAmount * 0.45)
                    + manual * ManualSteerStrength

                if final.Magnitude > 0 then
                    final = final.Unit
                end
            end

            hum:Move(final, false)
        elseif manual.Magnitude > 0.01 then
            hum:Move(manual, false)
        end
    end)
end

local function ToggleAutoFollowBall()
    if AutoFollowBallEnabled then StopAutoFollowBall() else StartAutoFollowBall() end
end

GlobalInputConnection = UIS.InputBegan:Connect(function(input, processed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if WaitingFollowBind then
        if input.KeyCode == Enum.KeyCode.Escape then
            WaitingFollowBind = false
            UpdateFollowButtons()
            return
        end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        FollowBallBind = input.KeyCode
        WaitingFollowBind = false
        UpdateFollowButtons()
        return
    end
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode == FollowBallBind then
        ToggleAutoFollowBall()
        UpdateFollowButtons()
    end
end)

local R6_BODIES = {
    ["Robloxian 2.0"]={Torso=27111894,LeftArm=27111419,RightArm=27111864,LeftLeg=27111857,RightLeg=27111882},
    ["Woman"]={Torso=82987757,LeftArm=83001137,RightArm=83001181,LeftLeg=746826007,RightLeg=746825633},
    ["Roblox Boy 2016"]={Torso=376169183,LeftArm=279174949,RightArm=279174886,LeftLeg=319336109,RightLeg=319336155},
    ["Roblox Girl 2016"]={Torso=319346857,LeftArm=376541126,RightArm=303665872,LeftLeg=303665905,RightLeg=303665804}
}

local function Toggle54()
    Ratio54Enabled = not Ratio54Enabled
    LeftBar.Visible = Ratio54Enabled
    RightBar.Visible = Ratio54Enabled
    Update54()
end

RatioConnection = RunService.RenderStepped:Connect(function()
    if Ratio54Enabled then Update54() end
end)

local GraphicsMode = "NORMAL"
local SavedGraphicObjects = setmetatable({}, {__mode="k"})
local SavedLightingEffects = setmetatable({}, {__mode="k"})
local SavedLighting = {
    Brightness=Lighting.Brightness,
    ExposureCompensation=Lighting.ExposureCompensation,
    GlobalShadows=Lighting.GlobalShadows,
    Ambient=Lighting.Ambient,
    OutdoorAmbient=Lighting.OutdoorAmbient,
    FogStart=Lighting.FogStart,
    FogEnd=Lighting.FogEnd
}
local LuxzGraphicEffects = {}

local function SaveGraphicObject(obj)
    if SavedGraphicObjects[obj] then return end
    if obj:IsA("BasePart") then
        SavedGraphicObjects[obj] = {Type="Part",Material=obj.Material,Reflectance=obj.Reflectance,CastShadow=obj.CastShadow}
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        SavedGraphicObjects[obj] = {Type="Texture",Transparency=obj.Transparency}
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        SavedGraphicObjects[obj] = {Type="Effect",Enabled=obj.Enabled}
    end
end

local function SaveLightingEffect(obj)
    if not SavedLightingEffects[obj] and obj:IsA("PostEffect") then
        SavedLightingEffects[obj] = {Enabled=obj.Enabled}
    end
end

local function DestroyLuxzGraphicEffects()
    for _, effect in ipairs(LuxzGraphicEffects) do
        if effect and effect.Parent then pcall(function() effect:Destroy() end) end
    end
    LuxzGraphicEffects = {}
end

local function RestoreOriginalPostEffects()
    for obj, data in pairs(SavedLightingEffects) do
        if obj and obj.Parent then pcall(function() obj.Enabled = data.Enabled end) end
    end
end

local function DisableOriginalPostEffects()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") then
            SaveLightingEffect(obj)
            obj.Enabled = false
        end
    end
end

local function AddGraphicEffect(className, props)
    local effect = Instance.new(className)
    for k, v in pairs(props) do effect[k] = v end
    effect.Parent = Lighting
    table.insert(LuxzGraphicEffects, effect)
    return effect
end

local function ApplyCinematicShader()
    DestroyLuxzGraphicEffects()
    RestoreOriginalPostEffects()
    GraphicsMode = "CINEMATIC"
    Lighting.Brightness = 2.2
    Lighting.ExposureCompensation = 0.12
    Lighting.GlobalShadows = true
    AddGraphicEffect("ColorCorrectionEffect",{Name="Luxz_CinematicColor",Brightness=0.02,Contrast=0.18,Saturation=0.18,TintColor=Color3.fromRGB(255,242,225)})
    AddGraphicEffect("BloomEffect",{Name="Luxz_CinematicBloom",Intensity=0.45,Size=28,Threshold=1.1})
    AddGraphicEffect("SunRaysEffect",{Name="Luxz_CinematicSun",Intensity=0.06,Spread=0.8})
    local a = Instance.new("Atmosphere")
    a.Name = "Luxz_CinematicAtmosphere"
    a.Density = 0.22
    a.Offset = 0.05
    a.Color = Color3.fromRGB(210,220,255)
    a.Decay = Color3.fromRGB(120,120,145)
    a.Glare = 0.12
    a.Haze = 1.2
    a.Parent = Lighting
    table.insert(LuxzGraphicEffects, a)
end

local function ApplyVibrantShader()
    DestroyLuxzGraphicEffects()
    RestoreOriginalPostEffects()
    GraphicsMode = "VIBRANT"
    Lighting.Brightness = 2.4
    Lighting.ExposureCompensation = 0.1
    Lighting.GlobalShadows = true
    AddGraphicEffect("ColorCorrectionEffect",{Name="Luxz_VibrantColor",Brightness=0.04,Contrast=0.12,Saturation=0.45})
    AddGraphicEffect("BloomEffect",{Name="Luxz_VibrantBloom",Intensity=0.25,Size=20,Threshold=1.4})
end

local function ApplyDarkShader()
    DestroyLuxzGraphicEffects()
    RestoreOriginalPostEffects()
    GraphicsMode = "DARK"
    Lighting.Brightness = 1.35
    Lighting.ExposureCompensation = -0.25
    Lighting.GlobalShadows = true
    AddGraphicEffect("ColorCorrectionEffect",{Name="Luxz_DarkColor",Brightness=-0.07,Contrast=0.30,Saturation=-0.05,TintColor=Color3.fromRGB(205,215,255)})
    AddGraphicEffect("BloomEffect",{Name="Luxz_DarkBloom",Intensity=0.12,Size=16,Threshold=1.5})
end

local function ApplyColdShader()
    DestroyLuxzGraphicEffects()
    RestoreOriginalPostEffects()
    GraphicsMode = "COLD"
    Lighting.Brightness = 2
    Lighting.GlobalShadows = true
    AddGraphicEffect("ColorCorrectionEffect",{Name="Luxz_ColdColor",Contrast=0.17,Saturation=0.08,TintColor=Color3.fromRGB(185,215,255)})
    AddGraphicEffect("BloomEffect",{Name="Luxz_ColdBloom",Intensity=0.18,Size=18,Threshold=1.35})
end

local function ApplyLowGraphics()
    DestroyLuxzGraphicEffects()
    GraphicsMode = "LOW"
    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    DisableOriginalPostEffects()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                SaveGraphicObject(obj)
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                SaveGraphicObject(obj)
                obj.Enabled = false
            end
        end)
    end
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
end

local function ApplyVeryLowGraphics()
    ApplyLowGraphics()
    GraphicsMode = "VERY_LOW"
    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Decal") or obj:IsA("Texture") then
                SaveGraphicObject(obj)
                obj.Transparency = 1
            end
        end)
    end
end

local function ApplyPlasticMode()
    DestroyLuxzGraphicEffects()
    GraphicsMode = "PLASTIC"
    Lighting.GlobalShadows = false
    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") and not IsCharacterPart(obj) then
                SaveGraphicObject(obj)
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                SaveGraphicObject(obj)
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                SaveGraphicObject(obj)
                obj.Enabled = false
            end
        end)
    end
end

local function ApplyPlasticLite()
    DestroyLuxzGraphicEffects()
    GraphicsMode = "PLASTIC_LITE"
    Lighting.GlobalShadows = false
    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") and not IsCharacterPart(obj) then
                SaveGraphicObject(obj)
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end
        end)
    end
end

local function RestoreGraphics()
    GraphicsMode = "NORMAL"
    DestroyLuxzGraphicEffects()
    Lighting.Brightness = SavedLighting.Brightness
    Lighting.ExposureCompensation = SavedLighting.ExposureCompensation
    Lighting.GlobalShadows = SavedLighting.GlobalShadows
    Lighting.Ambient = SavedLighting.Ambient
    Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
    Lighting.FogStart = SavedLighting.FogStart
    Lighting.FogEnd = SavedLighting.FogEnd
    RestoreOriginalPostEffects()
    for obj, data in pairs(SavedGraphicObjects) do
        if obj and obj.Parent then
            pcall(function()
                if data.Type == "Part" then
                    obj.Material = data.Material
                    obj.Reflectance = data.Reflectance
                    obj.CastShadow = data.CastShadow
                elseif data.Type == "Texture" then
                    obj.Transparency = data.Transparency
                elseif data.Type == "Effect" then
                    obj.Enabled = data.Enabled
                end
            end)
        end
    end
    for obj in pairs(SavedGraphicObjects) do SavedGraphicObjects[obj] = nil end
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
end

local Entrance = Instance.new("Frame")
Entrance.Size = UDim2.fromOffset(560,340)
Entrance.Position = UDim2.new(.5,-280,.5,-170)
Entrance.BackgroundColor3 = Color3.new(0,0,0)
Entrance.BorderSizePixel = 0
Entrance.Parent = GUI
Corner(Entrance,18)

local EntranceBG = Instance.new("ImageLabel")
EntranceBG.Size = UDim2.fromScale(1,1)
EntranceBG.BackgroundTransparency = 1
EntranceBG.Image = IMAGE
EntranceBG.ScaleType = Enum.ScaleType.Crop
EntranceBG.Parent = Entrance
Corner(EntranceBG,18)

local Shade = Instance.new("Frame")
Shade.Size = UDim2.fromScale(1,1)
Shade.BackgroundColor3 = Color3.new(0,0,0)
Shade.BackgroundTransparency = .35
Shade.BorderSizePixel = 0
Shade.Parent = Entrance
Corner(Shade,18)

local ET = Instance.new("TextLabel")
ET.Size = UDim2.new(1,0,0,60)
ET.Position = UDim2.new(0,0,.13,0)
ET.BackgroundTransparency = 1
ET.Text = "LUXZ HUB"
ET.Font = Enum.Font.GothamBlack
ET.TextSize = 34
ET.TextColor3 = Color3.new(1,1,1)
ET.Parent = Entrance

local EI = Instance.new("TextLabel")
EI.Size = UDim2.new(1,0,0,85)
EI.Position = UDim2.new(0,0,.33,0)
EI.BackgroundTransparency = 1
EI.Text = "Creator: Luxz\nRoblox: nik12qe12345\nFriends: Larppingo"
EI.Font = Enum.Font.GothamMedium
EI.TextSize = 16
EI.TextColor3 = Color3.fromRGB(220,220,220)
EI.Parent = Entrance

local Enter = Instance.new("TextButton")
Enter.Size = UDim2.fromOffset(210,50)
Enter.Position = UDim2.new(.5,-105,.73,0)
Enter.BackgroundColor3 = Color3.fromRGB(5,5,5)
Enter.Text = "ENTRAR NO HUB"
Enter.TextColor3 = Color3.new(1,1,1)
Enter.Font = Enum.Font.GothamBold
Enter.TextSize = 16
Enter.Parent = Entrance
Corner(Enter,12)

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(650,470)
Main.Position = UDim2.new(.5,-325,.5,-235)
Main.BackgroundColor3 = Color3.new(0,0,0)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = GUI
Corner(Main,16)

local BG = Instance.new("ImageLabel")
BG.Size = UDim2.fromScale(1,1)
BG.BackgroundTransparency = 1
BG.Image = IMAGE
BG.ImageTransparency = .20
BG.ScaleType = Enum.ScaleType.Crop
BG.Parent = Main
Corner(BG,16)

local Dark = Instance.new("Frame")
Dark.Size = UDim2.fromScale(1,1)
Dark.BackgroundColor3 = Color3.new(0,0,0)
Dark.BackgroundTransparency = .30
Dark.BorderSizePixel = 0
Dark.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,82)
Header.BackgroundColor3 = Color3.new(0,0,0)
Header.BackgroundTransparency = .13
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-80,0,28)
Title.Position = UDim2.fromOffset(20,5)
Title.BackgroundTransparency = 1
Title.Text = "LUXZ HUB"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 23
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1,-90,0,45)
Info.Position = UDim2.fromOffset(20,32)
Info.BackgroundTransparency = 1
Info.Text = "Creator: Luxz\nRoblox: nik12qe12345\nFriends: Larppingo"
Info.Font = Enum.Font.GothamMedium
Info.TextSize = 11
Info.TextColor3 = Color3.fromRGB(200,200,200)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(42,42)
Close.Position = UDim2.new(1,-54,0,18)
Close.BackgroundColor3 = Color3.fromRGB(120,25,35)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 19
Close.TextColor3 = Color3.new(1,1,1)
Close.Parent = Header
Corner(Close,12)

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1,-30,0,46)
Tabs.Position = UDim2.fromOffset(15,92)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main

local function NewTab(text, pos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/3,-5,1,0)
    b.Position = UDim2.new(pos,0,0,0)
    b.BackgroundColor3 = Color3.fromRGB(5,5,5)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = Tabs
    Corner(b,10)
    return b
end

local SkyTab = NewTab("🌌 CÉUS",0)
local GrassTab = NewTab("🌱 GRAMADOS",1/3)
local OthersTab = NewTab("🛠️ OUTROS",2/3)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1,-30,1,-158)
Content.Position = UDim2.fromOffset(15,150)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 5
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new()
Content.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0,7)
List.Parent = Content

local function Clear()
    for _, v in ipairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
end

local function Category(title, builder)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,-8,0,43)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.BackgroundTransparency = 1
    holder.Parent = Content
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0,6)
    list.Parent = holder

    local head = Instance.new("TextButton")
    head.Size = UDim2.new(1,0,0,43)
    head.BackgroundColor3 = Color3.new(0,0,0)
    head.Text = "   ▶  " .. title
    head.TextColor3 = Color3.new(1,1,1)
    head.Font = Enum.Font.GothamBold
    head.TextSize = 15
    head.TextXAlignment = Enum.TextXAlignment.Left
    head.Parent = holder
    Corner(head,9)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1,0,0,0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.BackgroundTransparency = 1
    body.Visible = false
    body.Parent = holder
    local bl = Instance.new("UIListLayout")
    bl.Padding = UDim.new(0,5)
    bl.Parent = body

    local built = false
    local function Add(text, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,39)
        b.BackgroundColor3 = Color3.fromRGB(4,4,4)
        b.Text = "      " .. text
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 14
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = body
        Corner(b,8)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    head.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        head.Text = (body.Visible and "   ▼  " or "   ▶  ") .. title
        if body.Visible and not built then
            built = true
            builder(Add)
        end
    end)
end

local function ShowSkies()
    Clear()
    for _, cat in ipairs({"🌤️ REALISTAS","🌅 PÔR DO SOL","🌌 ESPAÇO","🌙 NOITE","🎨 COLORIDOS"}) do
        Category(cat,function(Add)
            for _, sky in ipairs(SKYBOXES) do
                if sky.Category == cat then
                    Add("🌌 " .. sky.Name,function() ApplySkybox(sky) end)
                end
            end
        end)
    end
end

local function ShowGrass()
    Clear()
    Category("🎨 CORES DO GRAMADO",function(Add)
        for _, data in ipairs(GRASS_PRESETS) do
            Add(data[1],function() ApplyGrass(data[2]) end)
        end
    end)
end

local function RestoreSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then
            pcall(function()
                v:Destroy()
            end)
        end
    end

    for _, sky in ipairs(OriginalSkies) do
        pcall(function()
            sky:Clone().Parent = Lighting
        end)
    end
end

local function RemoveBallFire()
    BallFireEnabled = false
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "LuxzBallFire" or v.Name == "LuxzFire" then
            pcall(function()
                v:Destroy()
            end)
        end
    end
end

local function DestroyLuxzInstances()
    local roots = {Player:FindFirstChild("PlayerGui"), Lighting, Workspace}

    pcall(function()
        table.insert(roots, game:GetService("CoreGui"))
    end)

    pcall(function()
        if gethui then
            table.insert(roots, gethui())
        end
    end)

    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                local name = tostring(obj.Name)

                if name == "LuxzHub"
                    or name == "LuxzHubExit"
                    or name == "LuxzFollowToggle"
                    or name == "LuxzFollowLock"
                    or name == "LuxzBallFire"
                    or name == "LuxzFire"
                    or name == "LuxzSky"
                    or string.sub(name, 1, 5) == "Luxz_"
                then
                    pcall(function()
                        obj:Destroy()
                    end)
                end
            end
        end
    end
end

local function DisconnectHub()
    RGBBallEnabled = false
    AutoFollowBallEnabled = false
    BallFireEnabled = false
    FloatingFollowEnabled = false
    Ratio54Enabled = false

    local connections = {
        RGBBallConnection,
        AutoFollowConnection,
        GlobalInputConnection,
        RatioConnection,
        DescendantAddedConnection,
        CharacterAddedConnection
    }

    for _, connection in ipairs(connections) do
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end

    RGBBallConnection = nil
    AutoFollowConnection = nil
    GlobalInputConnection = nil
    RatioConnection = nil
    DescendantAddedConnection = nil
    CharacterAddedConnection = nil

    DisconnectPersistentConnections()
end

local function RestoreHubChanges()
    local restoreFunctions = {
        RestoreBallColor,
        RemoveBallFire,
        RestoreGrass,
        RestoreGraphics,
        RestoreSky
    }

    for _, fn in ipairs(restoreFunctions) do
        task.spawn(function()
            pcall(fn)
        end)
    end
end

local function DestroyHubGui()
    pcall(function()
        if LeftBar then
            LeftBar:Destroy()
        end
    end)

    pcall(function()
        if RightBar then
            RightBar:Destroy()
        end
    end)

    LeftBar = nil
    RightBar = nil

    pcall(function()
        if GUI then
            GUI:Destroy()
        end
    end)

    pcall(DestroyLuxzInstances)
end

local function HardClear()
    if HubCleared then return end
    HubCleared = true

    DisconnectHub()
    RestoreHubChanges()
    DestroyHubGui()

    ENV.LUXZ_HUB_CLEANUP = nil

    pcall(function()
        collectgarbage("collect")
    end)
end

ENV.LUXZ_HUB_CLEANUP = function()
    if HubCleared then return end
    HardClear()
end

local function FinishHub()
    if HubCleared then return end

    local exitGui = Instance.new("ScreenGui")
    exitGui.Name = "LuxzHubExitScreen"
    exitGui.ResetOnSpawn = false
    exitGui.IgnoreGuiInset = true
    exitGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    parentGui(exitGui)

    local exitFrame = Instance.new("Frame")
    exitFrame.Size = UDim2.fromOffset(520,300)
    exitFrame.Position = UDim2.new(.5,-260,.5,-150)
    exitFrame.BackgroundColor3 = Color3.new(0,0,0)
    exitFrame.BorderSizePixel = 0
    exitFrame.Parent = exitGui
    Corner(exitFrame,18)

    local exitImage = Instance.new("ImageLabel")
    exitImage.Size = UDim2.fromScale(1,1)
    exitImage.BackgroundTransparency = 1
    exitImage.Image = IMAGE
    exitImage.ScaleType = Enum.ScaleType.Crop
    exitImage.Parent = exitFrame
    Corner(exitImage,18)

    local shade = Instance.new("Frame")
    shade.Size = UDim2.fromScale(1,1)
    shade.BackgroundColor3 = Color3.new(0,0,0)
    shade.BackgroundTransparency = .32
    shade.BorderSizePixel = 0
    shade.Parent = exitFrame
    Corner(shade,18)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,0,58)
    title.Position = UDim2.new(0,20,.5,-58)
    title.BackgroundTransparency = 1
    title.Text = "LUXZ HUB"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 34
    title.ZIndex = 5
    title.Parent = exitFrame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1,-40,0,36)
    status.Position = UDim2.new(0,20,.5,8)
    status.BackgroundTransparency = 1
    status.Text = "FECHANDO..."
    status.TextColor3 = Color3.fromRGB(230,230,230)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 17
    status.ZIndex = 5
    status.Parent = exitFrame

    local Debris = game:GetService("Debris")
    Debris:AddItem(exitGui, 1.6)

    task.delay(.65,function()
        if status and status.Parent then
            status.Text = "SCRIPT REMOVIDO"
        end
    end)

    task.delay(1.35,function()
        pcall(function()
            exitGui:Destroy()
        end)
    end)

    HardClear()
end

local function ShowOthers()
    Clear()

    Category("🌈 RGB",function(Add)
        local rgb
        rgb = Add("⚽ Bola RGB: " .. (RGBBallEnabled and "ON" or "OFF"),function()
            ToggleRGBBall()
            rgb.Text = "      ⚽ Bola RGB: " .. (RGBBallEnabled and "ON" or "OFF")
        end)
    end)

    Category("🏃 SEGUIR BOLA",function(Add)
        FollowToggleButton = Add("⚽ Seguir Bola: " .. (AutoFollowBallEnabled and "ON" or "OFF"),function()
            ToggleAutoFollowBall()
            UpdateFollowButtons()
        end)
        FollowBindButton = Add("⌨️ Bind ligar/desligar: " .. GetKeyName(FollowBallBind),function()
            WaitingFollowBind = true
            FollowBindButton.Text = "      ⌨️ Pressione uma tecla..."
        end)
        FloatingFollowMenuButton = Add("📱 Botão flutuante: " .. (FloatingFollowEnabled and "ON" or "OFF"),function()
            FloatingFollowEnabled = not FloatingFollowEnabled
            UpdateFollowButtons()
        end)
    end)

    Category("🧍 CORPOS",function(Add)
        Add("⬛ Blocky",function() ApplyR6Body("Blocky") end)
        for _, name in ipairs({"Robloxian 2.0","Woman","Roblox Boy 2016","Roblox Girl 2016"}) do
            Add(name,function() ApplyR6Body(name) end)
        end
    end)

    Category("🎮 GRÁFICOS",function(Add)
        Add("✨ Shader Cinemático",ApplyCinematicShader)
        Add("🌈 Shader Vibrante",ApplyVibrantShader)
        Add("🌙 Shader Escuro",ApplyDarkShader)
        Add("❄️ Shader Frio",ApplyColdShader)
        Add("🚀 Gráficos Baixos",ApplyLowGraphics)
        Add("⚡ Gráficos Muito Baixos",ApplyVeryLowGraphics)
        Add("🧱 Modo Massinha",ApplyPlasticMode)
        Add("🧸 Massinha Leve",ApplyPlasticLite)
        Add("↩️ Restaurar Gráficos",RestoreGraphics)
    end)

    Category("🖥️ VISUAL",function(Add)
        local ratio
        ratio = Add("↔️ Proporção 5:4: " .. (Ratio54Enabled and "ON" or "OFF"),function()
            Toggle54()
            ratio.Text = "      ↔️ Proporção 5:4: " .. (Ratio54Enabled and "ON" or "OFF")
        end)
    end)

    Category("⚽ BOLA",function(Add)
        local fire
        fire = Add("🔥 Fogo: " .. (BallFireEnabled and "ON" or "OFF"),function()
            ToggleFire()
            fire.Text = "      🔥 Fogo: " .. (BallFireEnabled and "ON" or "OFF")
        end)
        local colors = {
            {"🔴 Vermelha",Color3.fromRGB(255,35,35)},
            {"🔵 Azul",Color3.fromRGB(25,90,255)},
            {"🟣 Roxa",Color3.fromRGB(160,40,255)},
            {"🌸 Rosa",Color3.fromRGB(255,60,170)},
            {"🟢 Verde",Color3.fromRGB(25,255,90)},
            {"💠 Ciano",Color3.fromRGB(0,230,255)},
            {"🟡 Dourada",Color3.fromRGB(255,190,20)},
            {"⚪ Branca",Color3.new(1,1,1)},
            {"⚫ Preta",Color3.fromRGB(10,10,10)}
        }
        for _, data in ipairs(colors) do
            Add(data[1],function() SetBallColor(data[2]) end)
        end
        Add("↩️ Original",RestoreBallColor)
    end)

    Category("🧹 CLEAR",function(Add)
        Add("🗑️ Clear",function()
            FinishHub()
        end)
    end)
end

SkyTab.MouseButton1Click:Connect(ShowSkies)
GrassTab.MouseButton1Click:Connect(ShowGrass)
OthersTab.MouseButton1Click:Connect(ShowOthers)

local Toggle = Instance.new("ImageButton")
Toggle.Size = UDim2.fromOffset(66,66)
Toggle.Position = UDim2.new(0,18,.5,-33)
Toggle.BackgroundColor3 = Color3.new(0,0,0)
Toggle.BorderSizePixel = 0
Toggle.Image = IMAGE
Toggle.ScaleType = Enum.ScaleType.Crop
Toggle.Active = true
Toggle.AutoButtonColor = false
Toggle.Visible = false
Toggle.ZIndex = 1000
Toggle.Parent = GUI
Corner(Toggle,15)

FloatingFollowButton = Instance.new("TextButton")
FloatingFollowButton.Name = "LuxzFollowToggle"
FloatingFollowButton.Size = UDim2.fromOffset(150,48)
FloatingFollowButton.Position = UDim2.new(1,-170,1,-80)
FloatingFollowButton.BackgroundColor3 = Color3.fromRGB(130,25,35)
FloatingFollowButton.BorderSizePixel = 0
FloatingFollowButton.Text = "⚽ SEGUIR: OFF"
FloatingFollowButton.TextColor3 = Color3.new(1,1,1)
FloatingFollowButton.Font = Enum.Font.GothamBold
FloatingFollowButton.TextSize = 13
FloatingFollowButton.Visible = false
FloatingFollowButton.Active = true
FloatingFollowButton.AutoButtonColor = false
FloatingFollowButton.ZIndex = 1002
FloatingFollowButton.Parent = GUI
Corner(FloatingFollowButton,12)

FloatingFollowLockButton = Instance.new("TextButton")
FloatingFollowLockButton.Name = "LuxzFollowLock"
FloatingFollowLockButton.Size = UDim2.fromOffset(38,38)
FloatingFollowLockButton.Position = UDim2.new(1,-42,0,5)
FloatingFollowLockButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
FloatingFollowLockButton.BorderSizePixel = 0
FloatingFollowLockButton.Text = "🔓"
FloatingFollowLockButton.TextColor3 = Color3.new(1,1,1)
FloatingFollowLockButton.Font = Enum.Font.GothamBold
FloatingFollowLockButton.TextSize = 18
FloatingFollowLockButton.Active = true
FloatingFollowLockButton.AutoButtonColor = false
FloatingFollowLockButton.ZIndex = 1003
FloatingFollowLockButton.Parent = FloatingFollowButton
Corner(FloatingFollowLockButton,10)

FloatingFollowLockButton.MouseButton1Click:Connect(function()
    FloatingFollowLocked = not FloatingFollowLocked
    UpdateFollowButtons()
end)

local function Drag(object, moveObject, callback)
    local dragging = false
    local start, startPos
    local moved = false
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            start = input.Position
            startPos = moveObject.Position
        end
    end)
    TrackConnection(UIS.InputChanged:Connect(function(input)
        if HubCleared then return end
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            if delta.Magnitude > 5 then moved = true end
            moveObject.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end))
    TrackConnection(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and not moved and callback then callback() end
            dragging = false
        end
    end))
end

Drag(Toggle,Toggle,function() Main.Visible = not Main.Visible end)
Drag(Header,Main)
do
    local dragging = false
    local start
    local startPos
    local moved = false

    FloatingFollowButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            moved = false
            start = input.Position
            startPos = FloatingFollowButton.Position
        end
    end)

    TrackConnection(UIS.InputChanged:Connect(function(input)
        if HubCleared then return end
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        then
            local delta = input.Position - start

            if delta.Magnitude > 5 then
                moved = true
            end

            if FloatingFollowLocked then return end

            FloatingFollowButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end))

    TrackConnection(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            if dragging and not moved then
                local mousePos = input.Position
                local lockPos = FloatingFollowLockButton.AbsolutePosition
                local lockSize = FloatingFollowLockButton.AbsoluteSize

                local onLock =
                    mousePos.X >= lockPos.X
                    and mousePos.X <= lockPos.X + lockSize.X
                    and mousePos.Y >= lockPos.Y
                    and mousePos.Y <= lockPos.Y + lockSize.Y

                if not onLock then
                    ToggleAutoFollowBall()
                    UpdateFollowButtons()
                end
            end

            dragging = false
        end
    end))
end

Close.MouseButton1Click:Connect(function() Main.Visible = false end)

Enter.MouseButton1Click:Connect(function()
    Entrance.Visible = false
    Main.Visible = true
    Toggle.Visible = true
    HubEntered = true
    UpdateFollowButtons()
end)

DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(obj)
    task.delay(.15,function()
        if not obj or not obj.Parent then return end
        if obj:IsA("BasePart") and IsBall(obj) then
            if BallFireEnabled then AddFire(obj) end
            if CurrentBallColor then ApplyColorToBall(obj,CurrentBallColor) end
        end
        if GraphicsMode == "LOW" or GraphicsMode == "VERY_LOW" or GraphicsMode == "PLASTIC" or GraphicsMode == "PLASTIC_LITE" then
            pcall(function()
                if obj:IsA("BasePart") and not IsCharacterPart(obj) then
                    SaveGraphicObject(obj)
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                end
                if GraphicsMode == "VERY_LOW" or GraphicsMode == "PLASTIC" then
                    if obj:IsA("Decal") or obj:IsA("Texture") then
                        SaveGraphicObject(obj)
                        obj.Transparency = 1
                    end
                end
            end)
        end
    end)
end)

CharacterAddedConnection = Player.CharacterAdded:Connect(function()
    CurrentFollowBall = nil
    FollowScanTimer = 1
    if AutoFollowBallEnabled then
        task.wait(1)
        if AutoFollowConnection then AutoFollowConnection:Disconnect() AutoFollowConnection = nil end
        AutoFollowBallEnabled = false
        StartAutoFollowBall()
    end
end)

ShowSkies()
UpdateFollowButtons()
