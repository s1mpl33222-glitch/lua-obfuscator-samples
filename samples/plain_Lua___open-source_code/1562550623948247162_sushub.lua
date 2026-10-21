local Players=game:GetService("Players")
local R=game:GetService("ReplicatedStorage")
local H=game:GetService("HttpService")
local Workspace=game:GetService("Workspace")
local VIM=game:GetService("VirtualInputManager")
local RunService=game:GetService("RunService")
local VirtualUser=game:GetService("VirtualUser")

local P=Players.LocalPlayer



local TesteAnti=R:WaitForChild("TesteAnti",5)

local mt=getrawmetatable(game)
local old_namecall=mt.__namecall
local old_newindex=mt.__newindex
setreadonly(mt,false)

mt.__namecall=newcclosure(function(self,...)
	local method=getnamecallmethod()

	if method=="Kick" and self==P then
		return
	end

	if method=="FireServer" and self==TesteAnti then
		return
	end

	return old_namecall(self,...)
end)

mt.__newindex=newcclosure(function(self,property,value)
	if self==P and property=="Parent" and value==nil then
		return
	end
	return old_newindex(self,property,value)
end)

setreadonly(mt,true)

local function patchHumanoid()
	if P.Character then
		local h=P.Character:FindFirstChildOfClass("Humanoid")
		if h then h.StateChanged:Connect(function()end) end
	end
end

P.CharacterAdded:Connect(patchHumanoid)
if P.Character then patchHumanoid() end

task.spawn(function()
	while task.wait(5) do
		if not TesteAnti or TesteAnti.Parent~=R then
			TesteAnti=R:FindFirstChild("TesteAnti")
		end
	end
end)



local E=P:WaitForChild("EstadoPersonagem")
local I=P:WaitForChild("Inventario")
local S=E:WaitForChild("Sede")
local F=E:WaitForChild("Fome")
local RE=R.InventarioSystem.Equipar


-- ============================================================
-- SUSHUB • VAMP AUTH KEY SYSTEM
-- ============================================================
-- IMPORTANTE:
-- 1) Não use a API Key do Work.ink aqui.
-- 2) Preencha PROJECT_ID e AUTH_SECRET com os dados do
--    seu projeto no Vampauth.
-- 3) O AUTH_SECRET é secreto. Não envie ele para ninguém.
-- ============================================================

local VAMP_PROJECT_ID = "76LISVAVYK73AD8S"
local VAMP_AUTH_SECRET = "c4d937d2313cb7443179f6ac4099c2dad28e070fc20c47dd"
local GET_KEY_URL = "https://discord.gg/TwEvjn35Ws"

local function showVampauthKeyGate()
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    local old = CoreGui:FindFirstChild("SushubVampauthKeyGate")
    if old then old:Destroy() end

    -- Vampauth official reference client
    local Vampauth
    local loaded, client = pcall(function()
        return loadstring(game:HttpGet("https://vampauth.com/client/vampauth.lua"))()
    end)

    if not loaded or not client then
        warn("[SUS HUB] Não foi possível carregar o cliente Vampauth.")
        return false
    end

    Vampauth = client

    local vp
    local created, instance = pcall(function()
        return Vampauth.new({
            projectId = VAMP_PROJECT_ID,
            authSecret = VAMP_AUTH_SECRET,
        })
    end)

    if not created or not instance then
        warn("[SUS HUB] Configuração Vampauth inválida.")
        return false
    end

    vp = instance

    local gui = Instance.new("ScreenGui")
    gui.Name = "SushubVampauthKeyGate"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    -- Fundo escuro suave
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.38
    overlay.BorderSizePixel = 0
    overlay.Parent = gui

    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.fromOffset(440, 278)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 14)
    frameCorner.Parent = frame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(55, 55, 60)
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.25
    frameStroke.Parent = frame

    -- Barra superior
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 76)
    top.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    top.BorderSizePixel = 0
    top.Parent = frame

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 14)
    topCorner.Parent = top

    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 18)
    topFix.Position = UDim2.new(0, 0, 1, -18)
    topFix.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    topFix.BorderSizePixel = 0
    topFix.Parent = top

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 3)
    accent.BackgroundColor3 = Color3.fromRGB(255, 55, 65)
    accent.BorderSizePixel = 0
    accent.Parent = frame

    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 45, 55)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 95)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 25, 35)),
    })
    accentGradient.Parent = accent

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, -42, 0, 32)
    logo.Position = UDim2.fromOffset(21, 13)
    logo.BackgroundTransparency = 1
    logo.Text = "SUS HUB"
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.TextSize = 25
    logo.Font = Enum.Font.GothamBlack
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Parent = frame

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -42, 0, 18)
    subtitle.Position = UDim2.fromOffset(22, 43)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "KEY SYSTEM  •  ACESSO RESTRITO"
    subtitle.TextColor3 = Color3.fromRGB(145, 145, 150)
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = frame

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -42, 0, 30)
    info.Position = UDim2.fromOffset(21, 88)
    info.BackgroundTransparency = 1
    info.Text = "Entre no Discord abaixo para pegar sua Key."
    info.TextColor3 = Color3.fromRGB(205, 205, 210)
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -42, 0, 43)
    box.Position = UDim2.fromOffset(21, 120)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    box.BorderSizePixel = 0
    box.PlaceholderText = "Cole sua Key aqui..."
    box.PlaceholderColor3 = Color3.fromRGB(105, 105, 110)
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(245, 245, 245)
    box.TextSize = 13
    box.Font = Enum.Font.GothamMedium
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = frame

    local boxPadding = Instance.new("UIPadding")
    boxPadding.PaddingLeft = UDim.new(0, 14)
    boxPadding.PaddingRight = UDim.new(0, 14)
    boxPadding.Parent = box

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 9)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(50, 50, 55)
    boxStroke.Thickness = 1
    boxStroke.Parent = box

    box.Focused:Connect(function()
        TweenService:Create(boxStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 60, 70)}):Play()
    end)
    box.FocusLost:Connect(function()
        TweenService:Create(boxStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 50, 55)}):Play()
    end)

    local getButton = Instance.new("TextButton")
    getButton.Size = UDim2.new(0.5, -26, 0, 42)
    getButton.Position = UDim2.fromOffset(21, 176)
    getButton.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    getButton.BorderSizePixel = 0
    getButton.Text = "GET KEY"
    getButton.TextColor3 = Color3.fromRGB(245, 245, 245)
    getButton.TextSize = 13
    getButton.Font = Enum.Font.GothamBold
    getButton.AutoButtonColor = false
    getButton.Parent = frame

    local getCorner = Instance.new("UICorner")
    getCorner.CornerRadius = UDim.new(0, 9)
    getCorner.Parent = getButton

    local getStroke = Instance.new("UIStroke")
    getStroke.Color = Color3.fromRGB(60, 60, 65)
    getStroke.Thickness = 1
    getStroke.Parent = getButton

    local verifyButton = Instance.new("TextButton")
    verifyButton.Size = UDim2.new(0.5, -26, 0, 42)
    verifyButton.Position = UDim2.new(0.5, 5, 0, 176)
    verifyButton.BackgroundColor3 = Color3.fromRGB(235, 48, 58)
    verifyButton.BorderSizePixel = 0
    verifyButton.Text = "VERIFICAR"
    verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyButton.TextSize = 13
    verifyButton.Font = Enum.Font.GothamBold
    verifyButton.AutoButtonColor = false
    verifyButton.Parent = frame

    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 9)
    verifyCorner.Parent = verifyButton

    local verifyGradient = Instance.new("UIGradient")
    verifyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 65, 75)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 30, 40)),
    })
    verifyGradient.Rotation = 90
    verifyGradient.Parent = verifyButton

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -42, 0, 26)
    status.Position = UDim2.fromOffset(21, 225)
    status.BackgroundTransparency = 1
    status.Text = "Pronto para verificar sua Key."
    status.TextColor3 = Color3.fromRGB(125, 125, 130)
    status.TextSize = 11
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Center
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Parent = frame

    -- Hover dos botões
    getButton.MouseEnter:Connect(function()
        TweenService:Create(getButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40, 40, 44)}):Play()
    end)
    getButton.MouseLeave:Connect(function()
        TweenService:Create(getButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30, 30, 34)}):Play()
    end)
    verifyButton.MouseEnter:Connect(function()
        TweenService:Create(verifyButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(255, 65, 75)}):Play()
    end)
    verifyButton.MouseLeave:Connect(function()
        TweenService:Create(verifyButton, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(235, 48, 58)}):Play()
    end)

    -- Permite arrastar a interface
    local dragging = false
    local dragStart
    local startPos

    top.InputBegan:Connect(function(input)
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Entrada animada
    frame.Size = UDim2.fromOffset(420, 265)
    frame.BackgroundTransparency = 1
    logo.TextTransparency = 1
    subtitle.TextTransparency = 1
    info.TextTransparency = 1
    box.BackgroundTransparency = 1
    getButton.BackgroundTransparency = 1
    verifyButton.BackgroundTransparency = 1
    status.TextTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(440, 278),
        BackgroundTransparency = 0,
    }):Play()
    task.delay(0.05, function()
        TweenService:Create(logo, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(subtitle, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(info, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(box, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(getButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(status, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    end)

    local unlocked = false

    getButton.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(setclipboard, GET_KEY_URL)
            status.Text = "Discord copiado! Abra o convite para pegar sua Key."
            status.TextColor3 = Color3.fromRGB(110, 235, 135)
        else
            status.Text = GET_KEY_URL
            status.TextColor3 = Color3.fromRGB(220, 220, 225)
        end
    end)

    verifyButton.MouseButton1Click:Connect(function()
        local key = box.Text:gsub("^%s+", ""):gsub("%s+$", "")

        if key == "" then
            status.Text = "Cole uma Key primeiro."
            status.TextColor3 = Color3.fromRGB(255, 105, 110)
            return
        end

        status.Text = "Verificando sua Key..."
        status.TextColor3 = Color3.fromRGB(220, 220, 225)
        verifyButton.Text = "AGUARDE..."

        task.spawn(function()
            local ok, data = pcall(function()
                return vp:Check(key)
            end)

            if ok and data then
                unlocked = true
                status.Text = "Key válida! Abrindo o Sus Hub..."
                status.TextColor3 = Color3.fromRGB(110, 235, 135)
                task.wait(0.6)
                gui:Destroy()
            else
                local reason = tostring(data or "Key inválida")
                status.Text = "Key inválida: " .. reason
                status.TextColor3 = Color3.fromRGB(255, 105, 110)
                verifyButton.Text = "VERIFICAR"
            end
        end)
    end)

    repeat task.wait() until unlocked
    return true
end

if not showVampauthKeyGate() then
    return
end

-- ============================================================
-- FIM DO KEY SYSTEM
-- ============================================================

local Repo="https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library=loadstring(game:HttpGet(Repo.."Library.lua"))()
Library.Scheme.Accent=Color3.fromRGB(255,60,60)

local ThemeManager=loadstring(game:HttpGet(Repo.."addons/ThemeManager.lua"))()
local SaveManager=loadstring(game:HttpGet(Repo.."addons/SaveManager.lua"))()

local Window=Library:CreateWindow({
	Title="Sus Hub",
	Footer="by sillage | vai se fuder klz",
	NotifySide="Right",
	ShowCustomCursor=false,
	DisableSearch=true,
	Size=UDim2.fromOffset(570,500)
})

Library.Scheme.AccentColor=Color3.fromRGB(255,60,60)

local Tabs={
	Main=Window:AddTab("Principal","user"),
}

local AutoFarm=Tabs.Main:AddGroupbox({Side="Left",Name="Auto Farm"})
local Outros=Tabs.Main:AddGroupbox({Side="Right",Name="Outros"})

local autoRota=false
local autoComida=false
local autoGasolina=false
local gasolinaBusy=false
local comidaBusy=false
local rotaBusy=false
local noclip=false
local rotaThread=nil
local ultimaRota=0
local posRota=nil
local tempoLocal=23
local AntiAfkConnection

local function carro()
	local f=Workspace:FindFirstChild("CarrosSpawnados")
	if not f then return end
	for _,v in pairs(f:GetChildren()) do
		local i=v:FindFirstChild("Info")
		local o=i and i:FindFirstChild("Owner")
		if o and o.Value==P.Name then return v end
	end
end

local function bomba()
	local c=Workspace:FindFirstChild("Construcoes")
	local p=c and c:FindFirstChild("PostoDe Gasolina")
	local b=p and p:FindFirstChild("Bombas")
	if not b then return end
	for _,v in pairs(b:GetChildren()) do
		if v:IsA("Model") and v.Name=="BombaGasolina" then return v end
	end
end

local function motor(m,state)
	local body=m and m:FindFirstChild("Body")
	local seat=body and body:FindFirstChild("PPDriveSeat")
	local e=seat and (seat:FindFirstChild("Engine") or seat:FindFirstChild("EngineBypass"))
	if e and e:IsA("BoolValue") then e.Value=state end
end

local function fisica(m)
	if not m then return end
	for _,v in pairs(m:GetDescendants()) do
		if v:IsA("BasePart") then
			v.AssemblyLinearVelocity=Vector3.zero
			v.AssemblyAngularVelocity=Vector3.zero
		end
	end
end

local function ancorar(m,state)
	if not m then return end
	for _,v in pairs(m:GetDescendants()) do
		if v:IsA("BasePart") then v.Anchored=state end
	end
end

local function cameraCustom()
	local c=Workspace.CurrentCamera
	if c then c.CameraType=Enum.CameraType.Custom end
end

local function cameraFix(cf)
	local c=Workspace.CurrentCamera
	if c then
		c.CameraType=Enum.CameraType.Scriptable
		c.CFrame=CFrame.new(cf.Position+Vector3.new(0,8,-12),cf.Position)
	end
end

local function teclaE(t)
	VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)
	task.wait(t)
	VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
end

local function pular()
	VIM:SendKeyEvent(true,Enum.KeyCode.Space,false,game)
	task.wait(.2)
	VIM:SendKeyEvent(false,Enum.KeyCode.Space,false,game)
	local h=P.Character and P.Character:FindFirstChildOfClass("Humanoid")
	if h then h.Sit=false end
end

local function entrar(m,extraGasolinaWait)
	if not m then return false end
	local c=P.Character
	local r=c and c:FindFirstChild("HumanoidRootPart")
	local body=m:FindFirstChild("Body")
	local seat=body and body:FindFirstChild("PPDriveSeat")
	if not r or not seat then return false end
	local cam=Workspace.CurrentCamera
	cam.CameraType=Enum.CameraType.Scriptable
	cam.CFrame=CFrame.lookAt(seat.Position+seat.CFrame.UpVector*5-seat.CFrame.LookVector*6,seat.Position)
	r.CFrame=seat.CFrame*CFrame.new(2,1,0)
	task.wait(.6)
	local q=seat:FindFirstChildWhichIsA("ProximityPrompt",true)
	if q then fireproximityprompt(q) else teclaE(1.5) end
	if extraGasolinaWait then task.wait(2) else task.wait(1) end
	cameraCustom()
	motor(m,true)
	return true
end

local function mover(m,cf)
	if not m or not autoRota then return false end
	if gasolinaBusy then return false end
	motor(m,false)
	fisica(m)
	ancorar(m,true)
	noclip=true
	m:PivotTo(cf)
	cameraFix(cf)
	pcall(function() P:RequestStreamAroundAsync(cf.Position) end)
	task.wait(.3)
	ancorar(m,false)
	noclip=false
	fisica(m)
	return true
end

local function usar(nome)
	if not autoComida or gasolinaBusy or comidaBusy then return false end
	if not I:FindFirstChild(nome) then return false end
	comidaBusy=true
	local x=P.Backpack:FindFirstChild(nome)
	if not x then
		RE:FireServer(nome,"Equipar",H:GenerateGUID(false))
		local tempo=0
		repeat
			task.wait(.1)
			tempo+=.1
			x=P.Backpack:FindFirstChild(nome)
		until x or tempo>=5
	end
	local h=P.Character and P.Character:FindFirstChildOfClass("Humanoid")
	if h and x then
		h:EquipTool(x)
		task.wait(.15)
		x:Activate()
		task.wait(.5)
	end
	comidaBusy=false
	return x~=nil
end

local function cuidarNecessidades()
	if not autoComida or gasolinaBusy or comidaBusy then return end
	if F.Value<50 then usar("Pizza") return end
	if S.Value<50 then
		if I:FindFirstChild("Coca-Cola") then usar("Coca-Cola")
		else usar("Agua") end
	end
end

S:GetPropertyChangedSignal("Value"):Connect(cuidarNecessidades)
F:GetPropertyChangedSignal("Value"):Connect(cuidarNecessidades)

local function abastecer()
	if not autoGasolina or gasolinaBusy then return false end
	local m=carro()
	local b=bomba()
	if not m or not b then return false end
	local info=m:FindFirstChild("Info")
	local status=info and info:FindFirstChild("Status")
	local gas=status and status:FindFirstChild("Gasolina")
	if not gas or not gas:IsA("NumberValue") or gas.Value>=50 then return false end
	gasolinaBusy=true
	local entrou=entrar(m,true)
	if not entrou then gasolinaBusy=false return false end
	task.wait(.3)
	local bp=b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart",true)
	if not bp then gasolinaBusy=false cameraCustom() return false end
	local _,size=m:GetBoundingBox()
	local x=bp.CFrame*CFrame.new(-10,0,20)
	motor(m,false)
	fisica(m)
	ancorar(m,true)
	m:PivotTo(CFrame.new(x.X,bp.Position.Y+bp.Size.Y/2+size.Y/2,x.Z)*CFrame.Angles(0,math.rad(bp.Orientation.Y),0))
	pcall(function() P:RequestStreamAroundAsync(x.Position) end)
	task.wait(.4)
	ancorar(m,false)
	fisica(m)
	local c=P.Character
	local h=c and c:FindFirstChildOfClass("Humanoid")
	local r=c and c:FindFirstChild("HumanoidRootPart")
	if h then pular() end
	task.wait(.5)
	local engate=b:FindFirstChild("engate",true)
	local ep=engate and engate:FindFirstChild("ProximityPrompt")
	if r and engate and ep then
		r.CFrame=engate.CFrame*CFrame.new(0,2,0)
		task.wait(1.1)
		r.Anchored=true
		teclaE(2)
		r.Anchored=false
	end
	local body=m:FindFirstChild("Body")
	local gasPart=body and body:FindFirstChild("Gasolina")
	local gp=gasPart and gasPart:FindFirstChild("GasolinaProxy")
	if r and gasPart and gp and autoGasolina then
		r.CFrame=gasPart.CFrame*CFrame.new(0,2,0)
		task.wait(1.1)
		r.Anchored=true
		teclaE(11)
		r.Anchored=false
	end
	cameraCustom()
	gasolinaBusy=false
	return true
end

local function promptLocal(x)
	if not x or not autoRota or gasolinaBusy then return false end
	local r=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
	local q=x:FindFirstChildWhichIsA("ProximityPrompt",true)
	if not r or not q then return false end
	r.CFrame=x.CFrame
	task.wait(.4)
	if gasolinaBusy or not autoRota then return false end
	fireproximityprompt(q)
	task.wait(.2)
	teclaE(1.5)
	return true
end

local function prioridade()
	if gasolinaBusy then return true end
	if autoGasolina then
		local m=carro()
		local i=m and m:FindFirstChild("Info")
		local s=i and i:FindFirstChild("Status")
		local g=s and s:FindFirstChild("Gasolina")
		if g and g:IsA("NumberValue") and g.Value<50 then
			abastecer()
			return true
		end
	end
	if autoComida and not rotaBusy then cuidarNecessidades() end
	return false
end

RunService.Stepped:Connect(function()
	local c=P.Character
	if noclip and c then
		for _,v in pairs(c:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

AutoFarm:AddToggle("AutoRota",{
	Text="Auto Rota",
	Default=false,
	Callback=function(v)
		autoRota=v
		if not v then
			if rotaThread then task.cancel(rotaThread) rotaThread=nil end
			rotaBusy=false
			noclip=false
			cameraCustom()
			local r=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
			if r then r.Anchored=false end
			return
		end
		if rotaThread then task.cancel(rotaThread) end
		rotaThread=task.spawn(function()
			rotaBusy=true
			local pasta=P:WaitForChild("FacRuaInfos",5)
			if not pasta then rotaBusy=false return end
			local org=pasta:WaitForChild("OrgName",5)
			if not org then rotaBusy=false return end
			local sys=Workspace:WaitForChild("SystemFacsRua",5)
			if not sys then rotaBusy=false return end
			local facs=sys:FindFirstChild("FacsOcupadas")
			local fac=facs and facs:FindFirstChild(org.Value)
			if not fac then rotaBusy=false return end
			local melhorias=fac:WaitForChild("MelhoriasProxys",5)
			local rotas=melhorias and melhorias:WaitForChild("Rotas",5)
			local proxit=rotas and rotas:WaitForChild("Proxit",5)
			if not proxit then rotaBusy=false return end
			posRota=proxit.CFrame
			while autoRota do
				if gasolinaBusy then task.wait(.5) continue end
				if autoGasolina then
					local m=carro()
					local i=m and m:FindFirstChild("Info")
					local s=i and i:FindFirstChild("Status")
					local g=s and s:FindFirstChild("Gasolina")
					if g and g:IsA("NumberValue") and g.Value<50 then
						abastecer()
						task.wait(.5)
						continue
					end
				end
				if autoComida then cuidarNecessidades() task.wait(.2) end
				local m=carro()
				if not m then task.wait(2) continue end
				local h=P.Character and P.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Sit then h.Sit=false task.wait(.4) end
				if not h or not h.Sit then
					promptLocal(proxit)
					task.wait(.5)
					entrar(m)
					task.wait(.5)
				end
				local emRota=P:FindFirstChild("EmRota")
				local espera=0
				while autoRota and espera<15 do
					if gasolinaBusy then break end
					emRota=P:FindFirstChild("EmRota")
					if emRota and emRota.Value>0 then break end
					task.wait(.5)
					espera+=.5
				end
				if not autoRota then break end
				if gasolinaBusy then continue end
				emRota=P:FindFirstChild("EmRota")
				if not emRota or emRota.Value<=0 then task.wait(3) continue end
				ultimaRota=0
				while autoRota do
					if gasolinaBusy then break end
					if autoGasolina then
						local info=m:FindFirstChild("Info")
						local status=info and info:FindFirstChild("Status")
						local gas=status and status:FindFirstChild("Gasolina")
						if gas and gas:IsA("NumberValue") and gas.Value<50 then break end
					end
					emRota=P:FindFirstChild("EmRota")
					if not emRota or emRota.Value<=0 then break end
					local n=emRota.Value
					if n==ultimaRota then break end
					local locais=Workspace.Construcoes:FindFirstChild("LocaisRotas")
					local destino=locais and locais:FindFirstChild("Local"..n)
					if not destino then break end
					ultimaRota=n
					local alvo=destino.CFrame
					local frente=alvo*CFrame.new(0,0,10)
					local emCarro=P:FindFirstChild("EmCarro")
					if emCarro then
						while autoRota and not emCarro.Value do
							if gasolinaBusy then break end
							task.wait(.5)
						end
					end
					if not autoRota or gasolinaBusy then break end
					mover(m,frente)
					if gasolinaBusy then break end
					motor(m,true)
					pular()
					task.wait(.1)
					local r=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
					if r then
						r.CFrame=alvo*CFrame.new(0,0,1)
						r.Anchored=true
						cameraFix(alvo)
					end
					task.wait(1.5)
					if autoRota and not gasolinaBusy then promptLocal(destino) end
					local tempo=0
					while autoRota and tempo<tempoLocal do
						if gasolinaBusy then break end
						if autoComida then cuidarNecessidades() end
						task.wait(.5)
						tempo+=.5
					end
					r=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
					if r then r.Anchored=false end
					cameraCustom()
					if gasolinaBusy then break end
					if autoRota then entrar(m) task.wait(.4) end
				end
				if not autoRota then break end
				if gasolinaBusy then task.wait(.5) continue end
				if autoGasolina then
					local info=m:FindFirstChild("Info")
					local status=info and info:FindFirstChild("Status")
					local gas=status and status:FindFirstChild("Gasolina")
					if gas and gas:IsA("NumberValue") and gas.Value<50 then
						abastecer()
						task.wait(.5)
						continue
					end
				end
				if posRota then
					local emCarro=P:FindFirstChild("EmCarro")
					if emCarro then
						while autoRota and not emCarro.Value do task.wait(.5) end
					end
					if not autoRota then break end
					motor(m,false)
					fisica(m)
					ancorar(m,true)
					noclip=true
					m:PivotTo(posRota)
					cameraFix(posRota)
					pcall(function() P:RequestStreamAroundAsync(posRota.Position) end)
					task.wait(.3)
					ancorar(m,false)
					noclip=false
					fisica(m)
					pular()
					task.wait(.2)
					local r=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
					if r then r.CFrame=posRota*CFrame.new(0,0,2) r.Anchored=true end
					task.wait(1.5)
					if r then r.Anchored=false end
					cameraCustom()
				end
			end
			rotaBusy=false
		end)
	end
})

Outros:AddToggle("AutoComidaBebida",{
	Text="Auto Comida/Bebida",
	Default=false,
	Tooltip="Usa comida e bebida automaticamente.",
	Callback=function(v)
		autoComida=v
		if v then
			task.spawn(function()
				while autoComida do
					if not gasolinaBusy then cuidarNecessidades() end
					task.wait(1)
				end
			end)
		end
	end
})

Outros:AddToggle("AutoGasolina",{
	Text="Auto Gasolina",
	Default=false,
	Tooltip="Abastece o veículo automaticamente.",
	Callback=function(v)
		autoGasolina=v
		if not v then
			gasolinaBusy=false
			local r=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
			if r then r.Anchored=false end
			cameraCustom()
		end
	end
})

Outros:AddToggle("AntiAfk",{
	Text="Anti AFK",
	Default=true,
	Tooltip="Impede que você seja desconectado por inatividade.",
	Callback=function(v)
		if AntiAfkConnection then
			AntiAfkConnection:Disconnect()
			AntiAfkConnection=nil
		end
		if v then
			AntiAfkConnection=P.Idled:Connect(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end
	end
})

task.spawn(function()
	while task.wait(2) do
		if autoGasolina and not gasolinaBusy then prioridade() end
	end
end)
