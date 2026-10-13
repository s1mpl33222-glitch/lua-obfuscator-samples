JugadorLocal = game.Players.LocalPlayer
PlayerGui = JugadorLocal:FindFirstChild("PlayerGui")
JugadorFisico = workspace:WaitForChild(JugadorLocal.Name)
JugadorHumanoid = JugadorFisico:WaitForChild("Humanoid")

local Functions = {}
local Connections = {}
local Globals = {}

RemotesFolder = game.ReplicatedStorage:FindFirstChild("RemotesFolder")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")

local TeleportService = game:GetService("TeleportService")

local RunService = game:GetService("RunService")

local SonidoNotificacion = Instance.new("Sound")

SonidoNotificacion.SoundId = "rbxassetid://4590662766"
SonidoNotificacion.Parent = game.SoundService

local CrearCarpetas = loadstring(game:HttpGet("https://pastebin.com/raw/yKkzQiKM"))()

-- Le pasamos "Doors" y "Hotel" directamente al ejecutar la función:
CrearCarpetas("Doors", "Lobby")

local Repo = "https://pastebin.com/raw/"
local Library = loadstring(game:HttpGet(Repo.."qR4uC8iC"))()
local ThemeManager = loadstring(game:HttpGet(Repo.."9T9nsW0r"))()
local SaveManager = loadstring(game:HttpGet(Repo.."tip8aY8D"))()

Library:Notify("Cargando script...")
SonidoNotificacion:Play()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)


local Window = Library:CreateWindow({
	-- Set Center to true if you want the menu to appear in the center
	-- Set AutoShow to true if you want the menu to appear when it is created
	-- Set Resizable to true if you want to have in-game resizable Window
	-- Set MobileButtonsSide to "Left" or "Right" if you want the ui toggle & lock buttons to be on the left or right side of the window
	-- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
	-- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
	-- Position and Size are also valid options here
	-- but you do not need to define them unless you are changing them :)

	Title = "Doors ~ Lobby",
	Footer = "Versión: 0.2",
	Icon = 0,
	NotifySide = "Right",
	ShowCustomCursor = false,
})

getgenv().Tabs = {
    InicioTab = Window:AddTab("Inicio", "house"),
    JugadorLocalTab = Window:AddTab("Jugador", "user"),
    ScriptsTab = Window:AddTab("Scripts", "layout-dashboard"),
    AjustesTab = Window:AddTab("Ajustes", "settings"),
}

getgenv().Library = Library

-- Cargar pestaña de Inicio pasando referencias
loadstring(game:HttpGet(Repo.."P3b94Sz7"))()

-- 1. Creas la variable global con el contenido que tú quieras
getgenv().NombreTexto = "Doors ~ Lobby"

-- 2. Ejecutas el Pastebin normalmente
loadstring(game:HttpGet("https://pastebin.com/raw/Aqt2ftkx"))()

getgenv().SonidoNotificacion = SonidoNotificacion

local TabBox = Tabs.JugadorLocalTab:AddLeftTabbox()
local Tab1 = TabBox:AddTab("Personaje", "user")

local TabBox2 = Tabs.JugadorLocalTab:AddRightTabbox()
local Tab2 = TabBox2:AddTab("Funciones", "wrench")

-- Guardamos referencias
local Toggle = Tab1:AddToggle("Velocidad", {
	Text = "Velocidad",
	Tooltip = "Modifica la velocidad del juagdor",
})

local Slider = Tab1:AddSlider("Velocidad2", {
	Text = "Ajústalo como quieras",
	Default = JugadorHumanoid.WalkSpeed,
	Min = JugadorHumanoid.WalkSpeed,
	Max = 100,
	Rounding = 0,

	Callback = function(Value)
		JugadorHumanoid.WalkSpeed = Value
	end,

	Disabled = true -- empieza desactivado
})

-- Conectamos el toggle
Toggle:OnChanged(function(Value)
	if Value then
		Slider:SetDisabled(false) -- activar slider
	else
		Slider:SetDisabled(true) -- desactivar slider
	end
end)

Tab1:AddDivider()

Tab1:AddButton("AntiAFK",{
	Text = "Anti AFK",
	Tooltip = "Evita que el jugador sea expulsado del juego por inactividad",
	
	Func = function()
		loadstring(game:HttpGet(Repo.."6KAradpr"))()
		Library:Notify("Anti AFK activado")
	end,
})

-- =============================================================================
-- 👁️ SISTEMA DE FOV (TOGGLE CONTROLADOR + SLIDER BLOQUEADO POR DEFECTO)
-- =============================================================================

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Variables originales del script
local defaultFOV = camera.FieldOfView
local customFOV = defaultFOV
local isFOVEnabled = false

Tab1:AddToggle("ActivarFOV", {
	Text = "FOV",
	Tooltip = "Customiza el campo de visión",
	Default = false,
	Callback = function(Value)
		isFOVEnabled = Value
		
		-- Habilitar / Deshabilitar el Slider dinámicamente
		if Options and Options.ValorFOV then
			Options.ValorFOV:SetDisabled(not Value)
		end

		-- Aplicar o restaurar FOV
		if isFOVEnabled then
			camera.FieldOfView = customFOV
		else
			camera.FieldOfView = defaultFOV
		end
	end
})

-- 1. SLIDER (Creación inicial con Disabled = true)
local SliderFOV = Tab1:AddSlider("ValorFOV", {
	Text = "Ajústalo como quieras",
	Default = math.floor(defaultFOV),
	Min = 1,
	Max = 120,
	Rounding = 0,
	Callback = function(Value)
		customFOV = Value
		if isFOVEnabled then
			camera.FieldOfView = customFOV
		end
	end,
	Disabled = true -- 🔒 Inicia desactivado/bloqueado
})

-- 3. DETECCIÓN DE REESPAWN
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	task.wait(1)
	if isFOVEnabled then
		camera.FieldOfView = customFOV
	end
end)

-- 4. MÉTODO ANTI-SOBREESCRITURA (Escucha directa a la cámara)
camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
	if isFOVEnabled and camera.FieldOfView ~= customFOV then
		camera.FieldOfView = customFOV
	end
end)

-- 5. BUCLE FORZADO EN RENDERSTEPPED (Refuerzo constante)
RunService.RenderStepped:Connect(function()
	if isFOVEnabled then
		if workspace.CurrentCamera ~= camera then
			camera = workspace.CurrentCamera
		end
		if camera.FieldOfView ~= customFOV then
			camera.FieldOfView = customFOV
		end
	end
end)

Tab1:AddDivider("Cámara Libre")
 
------------------------------------------------------------------------
-- SERVICIOS Y VARIABLES GLOBALES DE FREECAM
------------------------------------------------------------------------
 
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end
 
local Camera = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local newCamera = Workspace.CurrentCamera
    if newCamera then
        Camera = newCamera
    end
end)
 
local occ = LocalPlayer.DevCameraOcclusionMode
 
-- Matemáticas
local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local exp   = math.exp
local rad   = math.rad
local sign  = math.sign
local sqrt  = math.sqrt
local tan   = math.tan
 
-- Ajustes de movimiento y sensibilidad
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
 
local NAV_GAIN = Vector3.new(1, 1, 1) * 20
local SENSITIVITY_FACTOR = 1
local FOV_GAIN = 300
 
local PITCH_LIMIT = rad(90)
 
local VEL_STIFFNESS = 1.5
local PAN_STIFFNESS = 1.0
local FOV_STIFFNESS = 4.0
 
------------------------------------------------------------------------
-- MÓDULO SPRING
------------------------------------------------------------------------
local Spring = {} do
    Spring.__index = Spring
 
    function Spring.new(freq, pos)
        local self = setmetatable({}, Spring)
        self.f = freq
        self.p = pos
        self.v = pos*0
        return self
    end
 
    function Spring:Update(dt, goal)
        local f = self.f*2*pi
        local p0 = self.p
        local v0 = self.v
 
        local offset = goal - p0
        local decay = exp(-f*dt)
 
        local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
        local v1 = (f*dt*(offset*f - v0) + v0)*decay
 
        self.p = p1
        self.v = v1
 
        return p1
    end
 
    function Spring:Reset(pos)
        self.p = pos
        self.v = pos*0
    end
end
 
------------------------------------------------------------------------
-- ESTADOS Y RESORTES
------------------------------------------------------------------------
local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0
 
local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(FOV_STIFFNESS, 0)
 
------------------------------------------------------------------------
-- CAPTURA DE ENTRADA (INPUT)
------------------------------------------------------------------------
local Input = {} do
    local thumbstickCurve do
        local K_CURVATURE = 2.0
        local K_DEADZONE = 0.15
 
        local function fCurve(x)
            return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
        end
 
        local function fDeadzone(x)
            return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
        end
 
        function thumbstickCurve(x)
            return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
        end
    end
 
    local gamepad = {
        ButtonX = 0, ButtonY = 0,
        DPadDown = 0, DPadUp = 0,
        ButtonL2 = 0, ButtonR2 = 0,
        Thumbstick1 = Vector2.new(),
        Thumbstick2 = Vector2.new(),
    }
 
    local keyboard = {
        W = 0, A = 0, S = 0, D = 0, E = 0, Q = 0,
        U = 0, H = 0, J = 0, K = 0, I = 0, Y = 0,
        Up = 0, Down = 0,
        LeftShift = 0, RightShift = 0,
    }
 
    local mouse = {
        Delta = Vector2.new(),
        MouseWheel = 0,
    }
 
    local touch = {
        Delta = Vector2.new(),
        PinchScale = 0,
    }
 
    local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
    local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
    
    local PAN_MOUSE_SPEED   = Vector2.new(1, 1)
    local PAN_GAMEPAD_SPEED = Vector2.new(1, 1)
    local PAN_TOUCH_SPEED   = Vector2.new(0.15, 0.15)
    
    local FOV_WHEEL_SPEED    = 1.0
    local FOV_GAMEPAD_SPEED  = 0.25
    local FOV_TOUCH_SPEED    = 0.5
    local NAV_ADJ_SPEED      = 0.75
    local NAV_SHIFT_MUL      = 0.25
 
    local navSpeed = 1
 
    local function GetTouchMoveVector()
        local moveVector = Vector3.new()
        local playerScripts = LocalPlayer:FindFirstChildOfClass("PlayerScripts")
        if playerScripts then
            local playerModule = playerScripts:FindFirstChild("PlayerModule")
            if playerModule then
                local controls = require(playerModule):GetControls()
                if controls then
                    moveVector = controls:GetMoveVector()
                end
            end
        end
        return moveVector
    end
 
    function Input.Vel(dt)
        navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)
 
        local w = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
        local a = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
        local s = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
        local d = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
        local e = UserInputService:IsKeyDown(Enum.KeyCode.E) and 1 or 0
        local q = UserInputService:IsKeyDown(Enum.KeyCode.Q) and 1 or 0
 
        local kKeyboard = Vector3.new(
            (d - a) + (keyboard.K - keyboard.H),
            (e - q) + (keyboard.I - keyboard.Y),
            (s - w) + (keyboard.J - keyboard.U)
        )*NAV_KEYBOARD_SPEED
 
        local kGamepad = Vector3.new(
            thumbstickCurve(gamepad.Thumbstick1.X),
            thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
            thumbstickCurve(-gamepad.Thumbstick1.Y)
        )*NAV_GAMEPAD_SPEED
 
        local touchMove = GetTouchMoveVector()
        local kTouch = Vector3.new(touchMove.X, 0, touchMove.Z)
 
        local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
 
        return (kGamepad + kKeyboard + kTouch)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
    end
 
    function Input.Pan(dt)
        local kGamepad = Vector2.new(
            thumbstickCurve(gamepad.Thumbstick2.Y),
            thumbstickCurve(-gamepad.Thumbstick2.X)
        )*PAN_GAMEPAD_SPEED
        local kMouse = mouse.Delta*PAN_MOUSE_SPEED
        local kTouch = touch.Delta*PAN_TOUCH_SPEED
 
        mouse.Delta = Vector2.new()
        touch.Delta = Vector2.new()
 
        return kGamepad + kMouse + kTouch
    end
 
    function Input.Fov(dt)
        local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
        local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
        local kTouch = touch.PinchScale*FOV_TOUCH_SPEED
 
        mouse.MouseWheel = 0
        touch.PinchScale = 0
 
        return kGamepad + kMouse + kTouch
    end
 
    do
        local function Keypress(action, state, input)
            keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
            return Enum.ContextActionResult.Pass
        end
 
        local function GpButton(action, state, input)
            gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
            return Enum.ContextActionResult.Pass
        end
 
        local function MousePan(action, state, input)
            local delta = input.Delta
            mouse.Delta = Vector2.new(-delta.Y, -delta.X)
            return Enum.ContextActionResult.Pass
        end
 
        local function TouchPan(action, state, input)
            if state == Enum.UserInputState.Change then
                local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                local touchGui = playergui and playergui:FindFirstChild("TouchGui")
                
                if touchGui then
                    local touchControlFrame = touchGui:FindFirstChild("TouchControlFrame")
                    if touchControlFrame then
                        local thumbstick = touchControlFrame:FindFirstChild("DynamicThumbstickFrame") 
                            or touchControlFrame:FindFirstChild("ThumbstickFrame")
                        
                        if thumbstick and thumbstick.AbsolutePosition then
                            local pos = input.Position
                            local tPos = thumbstick.AbsolutePosition
                            local tSize = thumbstick.AbsoluteSize
                            
                            if pos.X >= tPos.X and pos.X <= (tPos.X + tSize.X) and pos.Y >= tPos.Y and pos.Y <= (tPos.Y + tSize.Y) then
                                return Enum.ContextActionResult.Pass
                            end
                        end
                    end
                end
 
                local delta = input.Delta
                touch.Delta = Vector2.new(-delta.Y, -delta.X)
            end
            
            return Enum.ContextActionResult.Pass
        end
 
        local function TouchPinch(action, state, input)
            if state == Enum.UserInputState.Change then
                touch.PinchScale = (1 - input.Scale)
            end
            return Enum.ContextActionResult.Pass
        end
 
        local function Thumb(action, state, input)
            gamepad[input.KeyCode.Name] = input.Position
            return Enum.ContextActionResult.Pass
        end
 
        local function Trigger(action, state, input)
            gamepad[input.KeyCode.Name] = input.Position.Z
            return Enum.ContextActionResult.Pass
        end
 
        local function MouseWheel(action, state, input)
            mouse[input.UserInputType.Name] = -input.Position.Z
            return Enum.ContextActionResult.Pass
        end
 
        local function Zero(t)
            for k, v in pairs(t) do
                if type(v) == "number" then
                    t[k] = 0
                elseif typeof(v) == "Vector2" then
                    t[k] = Vector2.new()
                end
            end
        end
 
        function Input.StartCapture()
            ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                Enum.KeyCode.W, Enum.KeyCode.U,
                Enum.KeyCode.A, Enum.KeyCode.H,
                Enum.KeyCode.S, Enum.KeyCode.J,
                Enum.KeyCode.D, Enum.KeyCode.K,
                Enum.KeyCode.E, Enum.KeyCode.I,
                Enum.KeyCode.Q, Enum.KeyCode.Y,
                Enum.KeyCode.Up, Enum.KeyCode.Down
            )
            ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
            ContextActionService:BindActionAtPriority("FreecamTouchPan", TouchPan, false, INPUT_PRIORITY, Enum.UserInputType.Touch)
            ContextActionService:BindActionAtPriority("FreecamTouchPinch", TouchPinch, false, INPUT_PRIORITY, Enum.UserInputType.Pinch)
            ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
            ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
            ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
            ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
        end
 
        function Input.StopCapture()
            navSpeed = 1
            Zero(gamepad)
            Zero(keyboard)
            Zero(mouse)
            Zero(touch)
            ContextActionService:UnbindAction("FreecamKeyboard")
            ContextActionService:UnbindAction("FreecamMousePan")
            ContextActionService:UnbindAction("FreecamTouchPan")
            ContextActionService:UnbindAction("FreecamTouchPinch")
            ContextActionService:UnbindAction("FreecamMouseWheel")
            ContextActionService:UnbindAction("FreecamGamepadButton")
            ContextActionService:UnbindAction("FreecamGamepadTrigger")
            ContextActionService:UnbindAction("FreecamGamepadThumbstick")
        end
    end
end
 
------------------------------------------------------------------------
-- CÁLCULO DE FOCO Y PASO DE CÁMARA
------------------------------------------------------------------------
local function GetFocusDistance(cameraFrame)
    local znear = 0.1
    local viewport = Camera.ViewportSize
    local projy = 2*tan(cameraFov/2)
    local projx = viewport.X/viewport.Y*projy
    local fx = cameraFrame.RightVector
    local fy = cameraFrame.UpVector
    local fz = cameraFrame.LookVector
 
    local minVect = Vector3.new()
    local minDist = 512
 
    for x = 0, 1, 0.5 do
        for y = 0, 1, 0.5 do
            local cx = (x - 0.5)*projx
            local cy = (y - 0.5)*projy
            local offset = fx*cx - fy*cy + fz
            local origin = cameraFrame.Position + offset*znear
            local raycastResult = Workspace:Raycast(origin, offset.Unit * minDist)
            local hit = raycastResult and raycastResult.Position or (origin + offset.Unit * minDist)
            local dist = (hit - origin).Magnitude
            if minDist > dist then
                minDist = dist
                minVect = offset.Unit
            end
        end
    end
 
    return fz:Dot(minVect)*minDist
end
 
local function StepFreecam(dt)
    -- Asegurar el comportamiento del ratón en PC dentro del bucle de RenderStep
    if UserInputService.KeyboardEnabled then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
 
    local vel = velSpring:Update(dt, Input.Vel(dt))
    local pan = panSpring:Update(dt, Input.Pan(dt))
    local fov = fovSpring:Update(dt, Input.Fov(dt))
 
    local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))
 
    cameraFov = clamp(cameraFov + fov * FOV_GAIN * (dt / zoomFactor), 1, 120)
    
    cameraRot = cameraRot + (pan * (SENSITIVITY_FACTOR * 0.05)) / zoomFactor
    cameraRot = Vector2.new(clamp(cameraRot.X, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.Y % (2 * pi))
 
    local cameraCFrame = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.X, cameraRot.Y, 0) * CFrame.new(vel * NAV_GAIN * dt)
    cameraPos = cameraCFrame.Position
 
    Camera.CFrame = cameraCFrame
    Camera.Focus = cameraCFrame * CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
    Camera.FieldOfView = cameraFov
end
 
------------------------------------------------------------------------
-- GESTIÓN DE ESTADO DEL JUGADOR
------------------------------------------------------------------------
local PlayerState = {} do
    local mouseBehavior
    local mouseIconEnabled
    local cameraType
    local cameraFocus
    local cameraCFrame
    local cameraFieldOfView
    local characterAnchoredState = {}
    local screenGuis = {}
    local coreGuis = {
        Backpack = true,
        Chat = true,
        Health = true,
        PlayerList = true,
    }
 
    -- Congelar/Descongelar al personaje físicamente sin apagar los controles táctiles
    local function SetCharacterAnchored(anchored)
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if anchored then
                        characterAnchoredState[part] = part.Anchored
                        part.Anchored = true
                    else
                        if characterAnchoredState[part] ~= nil then
                            part.Anchored = characterAnchoredState[part]
                        else
                            part.Anchored = false
                        end
                    end
                end
            end
        end
        if not anchored then
            characterAnchoredState = {}
        end
    end
 
    function PlayerState.Push()
        for name in pairs(coreGuis) do
            pcall(function()
                coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
            end)
        end
 
        local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playergui then
            for _, gui in pairs(playergui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "TouchGui" then
                    screenGuis[#screenGuis + 1] = gui
                    gui.Enabled = false
                end
            end
        end
 
        -- Anclamos el cuerpo para que no camine, pero dejamos los controles ON para leer el joystick táctil
        SetCharacterAnchored(true)
 
        cameraFieldOfView = Camera.FieldOfView
        Camera.FieldOfView = 70
 
        cameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Scriptable
 
        cameraCFrame = Camera.CFrame
        cameraFocus = Camera.Focus
 
        mouseIconEnabled = UserInputService.MouseIconEnabled
        UserInputService.MouseIconEnabled = false
 
        mouseBehavior = UserInputService.MouseBehavior
        if not UserInputService.KeyboardEnabled then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
 
    function PlayerState.Pop()
        for name, isEnabled in pairs(coreGuis) do
            pcall(function()
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
            end)
        end
 
        for _, gui in pairs(screenGuis) do
            if gui.Parent then
                gui.Enabled = true
            end
        end
        screenGuis = {}
 
        -- Desanclamos al personaje al apagar la cámara
        SetCharacterAnchored(false)
 
        Camera.FieldOfView = cameraFieldOfView or 70
        cameraFieldOfView = nil
 
        Camera.CameraType = cameraType or Enum.CameraType.Custom
        cameraType = nil
 
        if cameraCFrame then Camera.CFrame = cameraCFrame end
        cameraCFrame = nil
 
        if cameraFocus then Camera.Focus = cameraFocus end
        cameraFocus = nil
 
        UserInputService.MouseIconEnabled = mouseIconEnabled ~= nil and mouseIconEnabled or true
        mouseIconEnabled = nil
 
        UserInputService.MouseBehavior = mouseBehavior or Enum.MouseBehavior.Default
        mouseBehavior = nil
    end
end
 
------------------------------------------------------------------------
-- ACTIVACIÓN / DESACTIVACIÓN
------------------------------------------------------------------------
local function StartFreecam()
    occ = LocalPlayer.DevCameraOcclusionMode
    LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    local cframe = Camera.CFrame
    cameraRot = Vector2.new(cframe:ToEulerAnglesYXZ())
    cameraPos = cframe.Position
    cameraFov = Camera.FieldOfView
 
    velSpring:Reset(Vector3.new())
    panSpring:Reset(Vector2.new())
    fovSpring:Reset(0)
 
    PlayerState.Push()
    RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
    Input.StartCapture()
end
 
local function StopFreecam()
    LocalPlayer.DevCameraOcclusionMode = occ
    Input.StopCapture()
    RunService:UnbindFromRenderStep("Freecam")
    PlayerState.Pop()
end
 
------------------------------------------------------------------------
-- INTERFAZ DE LINORIALIB
------------------------------------------------------------------------
 
Tab1:AddToggle('FreecamToggle', {
    Text = 'Cámara Libre',
    Default = false,
    Tooltip = 'Activa/Desactiva la cámara libre.',
    Callback = function(Value)
        if Value then
            StartFreecam()
        else
            StopFreecam()
        end
    end
}):AddKeyPicker('FreecamKeybind', {
    Default = 'L',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Cámara libre',
    NoUI = false,
})
 
Tab1:AddSlider('FreecamSpeed', {
    Text = 'Velocidad',
    Default = 20,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        NAV_GAIN = Vector3.new(1, 1, 1) * Value
    end
})
 
Tab1:AddSlider('FreecamSensitivity', {
    Text = 'Sensibilidad',
    Default = 1.5,
    Min = 0.1,
    Max = 15,
    Rounding = 2,
    Compact = false,
    Callback = function(Value)
        SENSITIVITY_FACTOR = Value * 0.1
    end
})

-- ==========================================
-- REGISTRO EN LA INTERFAZ (UI)
-- ==========================================

-- Declaración del Toggle para Activar/Desactivar
Tab2:AddToggle("AutoJoinElevator", {
    Text = "Unirse a un ascensor",
    Default = false,
    Tooltip = "Tu personaje se une automáticamente al ascensor de quien quieras"
})

-- Declaración del Dropdown para seleccionar al jugador objetivo
Tab2:AddDropdown("AutoJoinElevatorTarget", {
    Text = "Víctima",
    SpecialType = "Player",
    ExcludeLocalPlayer = true,
    Searchable = true
})

-- ==========================================
-- LÓGICA DE DETECCIÓN Y UNIÓN
-- ==========================================

Functions.CheckElevators = function()
    -- Si el Toggle está apagado, no hace nada
    if not Toggles.AutoJoinElevator or not Toggles.AutoJoinElevator.Value then
        return
    end

    local TargetFound = false
    local TargetCharacter

    -- Obtiene el personaje del objetivo desde las opciones del Dropdown
    if Options.AutoJoinElevatorTarget then
        local TargetValue = Options.AutoJoinElevatorTarget.Value
        
        if typeof(TargetValue) == "Instance" then
            TargetCharacter = TargetValue.Character
        elseif typeof(TargetValue) == "string" then
            local targetPlayer = Services.Players:FindFirstChild(TargetValue)
            TargetCharacter = targetPlayer and targetPlayer.Character
        end
    end

    -- Recorre los elevadores en el Lobby
    local LobbyElevators = Workspace:FindFirstChild("Lobby") and Workspace.Lobby:FindFirstChild("LobbyElevators")

    if LobbyElevators and TargetCharacter then
        local TargetElevatorID = TargetCharacter:GetAttribute("InGameElevator")

        if TargetElevatorID then
            for _, Elevator in ipairs(LobbyElevators:GetChildren()) do
                if Elevator:GetAttribute("ID") == TargetElevatorID then
                    TargetFound = true
                    RemotesFolder.ElevatorJoin:FireServer(Elevator)
                    break
                end
            end
        end
    end

    -- Si el objetivo no está en ningún elevador, sale del elevador actual
    if not TargetFound then
        RemotesFolder.ElevatorExit:FireServer()
    end
end

-- ==========================================
-- BUCLE DE EJECUCIÓN (HEARTBEAT)
-- ==========================================

Globals.LastElevatorCheck = tick()

Connections.MainConnection = RunService.Heartbeat:Connect(function()
    if tick() - Globals.LastElevatorCheck > 0.25 then
        Functions.CheckElevators()
        Globals.LastElevatorCheck = tick()
    end
end)

-- ==========================================
-- REGISTRO EN LA INTERFAZ (UI)
-- ==========================================
Tab2:AddDivider()
-- Toggle para activar/desactivar la rotación de emblemas
Tab2:AddToggle("CycleAchievements", {
    Text = "Mostrar logros",
    Default = false,
    Tooltip = "Te equipa un logro aleatorio automáticamente"
})

-- Slider para controlar la velocidad de cambio (en segundos)
Tab2:AddSlider("CycleAchievementsDelay", {
    Text = "Tiempo de espera",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Compact = true
})

-- ==========================================
-- RECOLECCIÓN DE EMBLEMAS DESBLOQUEADOS
-- ==========================================

Globals.UnlockedBadges = {}
Globals.LastBadgeChange = tick()

local AchievementsList = PlayerGui:WaitForChild("MainUI"):WaitForChild("LobbyFrame"):WaitForChild("Achievements"):WaitForChild("List")

-- Función para registrar un emblema si está desbloqueado
local function RegisterBadge(Frame)
    if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
        if not table.find(Globals.UnlockedBadges, Frame.Name) then
            table.insert(Globals.UnlockedBadges, Frame.Name)
        end
    end
end

-- Escanear los emblemas actuales en la UI
for _, Frame in ipairs(AchievementsList:GetChildren()) do
    RegisterBadge(Frame)
end

-- Escuchar si el jugador desbloquea un emblema nuevo en tiempo real
Connections.BadgeAddedConnection = AchievementsList.ChildAdded:Connect(function(Frame)
    Services.RunService.Heartbeat:Wait()
    RegisterBadge(Frame)
end)

-- ==========================================
-- LÓGICA DE ROTACIÓN (DENTRO DEL HEARTBEAT)
-- ==========================================

-- Nota: Este bloque va dentro de tu conexión principal RunService.Heartbeat
local PreviousBadge = nil

Connections.MainConnection = RunService.Heartbeat:Connect(function()
    
    -- Lógica de rotación de emblemas
    if Toggles.CycleAchievements and Toggles.CycleAchievements.Value then
        local DelayValue = Options.CycleAchievementsDelay and Options.CycleAchievementsDelay.Value or 0.1
        
        if tick() - Globals.LastBadgeChange > DelayValue and #Globals.UnlockedBadges > 0 then
            
            -- Selección de un emblema aleatorio asegurando que no sea idéntico al anterior
            local Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
            if Badge == PreviousBadge and #Globals.UnlockedBadges > 1 then
                repeat
                    Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
                until Badge ~= PreviousBadge
            end

            -- Ocultar el icono de estrella del emblema previo visualmente en la UI local
            for _, Frame in ipairs(AchievementsList:GetChildren()) do
                if Frame:IsA("ImageButton") and Frame:FindFirstChild("Icons") and Frame.Icons:FindFirstChild("Star") then
                    Frame.Icons.Star.Visible = false
                end
            end

            -- Enviar petición al servidor para equipar/mostrar el emblema
            RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
            PreviousBadge = Badge

            -- Mostrar la estrella localmente en el nuevo emblema
            local ActiveFrame = AchievementsList:FindFirstChild(Badge)
            if ActiveFrame and ActiveFrame:FindFirstChild("Icons") and ActiveFrame.Icons:FindFirstChild("Star") then
                ActiveFrame.Icons.Star.Visible = true
            end

            Globals.LastBadgeChange = tick()
        end
    end

end)

-- ==========================================
-- REGISTRO EN LA INTERFAZ (UI) Y DATOS
-- ==========================================

Globals.RedeemingCodes = false

-- Lista de códigos de Doors
Globals.CodesList = {
    "67",
    "54",
    "41",
    "CHEDDAR BALLS",
    "XQC",
    "PENGUINZ0",
    "KREEKCRAFT",
    "ISHOWSPEED",
    "DANTDM",
    "KUBZ SCOUTS",
    "FIND THE TROLLFACES",
    "THINKNOODLES",
    "W",
    "RAGDOLL UNIVERSE",
    "RAGDOLL MAYHEM",
    "BIJUU MIKE",
    "8BITRYAN",
    "SCREECHSUCKS",
    "LORE",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "3rd",
    "LAZYDEVS",
    "RAGDOLL COMBAT",
    "VOCAB HAVOC",
    "PATHSWAP",
    "JUMP OVER THE BRICK"
}

Tab2:AddDivider()
-- Botón para iniciar el canje automático
Tab2:AddButton("Canjear códigos", function()
    -- Previene ejecuciones dobles si ya se está corriendo la secuencia
    if Globals.RedeemingCodes then
        return
    end

    Globals.RedeemingCodes = true

    -- Crea un hilo secundario para no congelar la UI ni el script
    task.spawn(function()
        for _, Code in ipairs(Globals.CodesList) do
            -- Revisa si la carpeta de Remotes existe antes de enviar
            if RemotesFolder and RemotesFolder:FindFirstChild("ShopCode") then
                RemotesFolder.ShopCode:FireServer(Code)
            end
            
            -- Tiempo de espera necesario entre cada código para evitar el "cooldown" del juego
            task.wait(5.1)
        end
        
        Globals.RedeemingCodes = false
    end)
end)

local TabBox3 = Tabs.JugadorLocalTab:AddRightGroupbox("Gestión Del Juego", "settings-2")


TabBox3:AddButton("SalirDelJuego",{
	Text = "Salir del juego (Kick)",
	Tooltip = "Permite expulsar al jugador del juego directamente",
	
	Func = function()
		JugadorLocal:Kick("Fuiste expulsado del juego correctamente")
	end,
})


TabBox3:AddButton("VolverAlLobby",{
	Text = "Volver a unirse",
	Tooltip = "Permite teletransportar al jugador al lobby del juego",
	
	Func = function()
		TeleportService:Teleport(6516141723, JugadorLocal)
	end,
})

local TabBox5 = Tabs.JugadorLocalTab:AddRightTabbox("Notificaciones")
local Tab5 = TabBox5:AddTab("Notificaciones", "scan-text")


Tab5:AddDivider(" Ajustes ")

Tab5:AddInput("SonidoDeNotificacion", {
	Default = "4590662766",
	Numeric = true,
	Finished = false,
	ClearTextOnFocus = false,

	Text = "Sonido de notificación",
	Tooltip = "Elige que sonido reproducir cuando haya una notificación",
	Placeholder = "ID",

	Callback = function(Value)
		-- Guardamos el valor de forma segura sin tocar objetos que no hayan cargado
		if Value and Value ~= "" then
			-- Si el objeto físico ya existe en el juego, le actualizamos la ID en tiempo real
			if SonidoNotificacion and typeof(SonidoNotificacion) == "Instance" then
				SonidoNotificacion.SoundId = "rbxassetid://" .. tostring(Value)
                SonidoNotificacion:Play()
			end
		end
	end,
})

Tab5:AddSlider("VolumenNotificacion", {
    Text = "Volumen",
    Default = 1,
    Min = 0,
    Max = 2,
    Rounding = 1,

    Callback = function(Value)
       SonidoNotificacion.Volume = Value
    end,

    Disabled = false
})

local TabBox6 = Tabs.JugadorLocalTab:AddLeftGroupbox("Ambiente", "cloud")

_G.FullBrightExecuted = _G.FullBrightExecuted or false
_G.FullBrightEnabled = false
_G.FullBrightColor = Color3.fromRGB(255,255,255)

local NormalSettings = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient
}

local function ApplyFullBright()
	Lighting.Brightness = 1
	Lighting.ClockTime = 12
	Lighting.FogEnd = 786543
	Lighting.GlobalShadows = false
	Lighting.Ambient = _G.FullBrightColor
end

local function RestoreLighting()
	Lighting.Brightness = NormalSettings.Brightness
	Lighting.ClockTime = NormalSettings.ClockTime
	Lighting.FogEnd = NormalSettings.FogEnd
	Lighting.GlobalShadows = NormalSettings.GlobalShadows
	Lighting.Ambient = NormalSettings.Ambient
end

-- UI
local TabBox7 = TabBox6:AddToggle("IluminacionMaxima",{
	Text = "Iluminación máxima",
	Tooltip = "Activa la iluminación máxima",
	Default = false,

	Callback = function(Value)
		_G.FullBrightEnabled = Value

		if Value then
			ApplyFullBright()
		else
			RestoreLighting()
		end
	end,
})

TabBox7:AddColorPicker("ColorPickerIluminacionMaxima", {
	Default = _G.FullBrightColor,
	Title = "Selecciona un color",

	Callback = function(Value)
		_G.FullBrightColor = Value

		if _G.FullBrightEnabled then
			Lighting.Ambient = Value
		end
	end,
})

-- Mantener activo si lo cambian en el juego
RunService.RenderStepped:Connect(function()
	if _G.FullBrightEnabled then
		Lighting.Brightness = 1
		Lighting.ClockTime = 12
		Lighting.FogEnd = 786543
		Lighting.GlobalShadows = false
		Lighting.Ambient = _G.FullBrightColor
	end
end)

local originalFogEnd = Lighting.FogEnd
local originalFogStart = Lighting.FogStart
local originalGlobalShadows = Lighting.GlobalShadows

TabBox6:AddToggle("AntiNiebla", {
	Text = "Anti niebla",
	Tooltip = "Elimina la niebla",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(value)
		if value then
			Lighting.FogEnd = 100000
			Lighting.FogStart = 0
			Lighting.GlobalShadows = false
		else
			-- Restaurar valores originales
			Lighting.FogEnd = originalFogEnd
			Lighting.FogStart = originalFogStart
			Lighting.GlobalShadows = originalGlobalShadows
		end
	end
})

TabBox6:AddButton("AntiLag",{
	Text = "Anti lag",
	Tooltip = "Elimina el lag",
	
	Func = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/djKa8a7D"))()
	end,
})

-- Scripts Tab

loadstring(game:HttpGet(Repo.."cmNjq04V"))()

-- AJUSTES

local MenuGroup = Tabs.AjustesTab:AddLeftGroupbox("Menú", "wrench")

MenuGroup:AddToggle("OcultarBoton", {
	Default = false,
	Text = "Ocultar Botón",
	Callback = function(value)
		game:FindFirstChild("CoreGui"):FindFirstChild("BotonPanelGui").Enabled = not value
	end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Cursor customizable",
	Default = false,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Izquierda", "Derecha" }, -- Las opciones que verá el usuario en español
    Default = "Derecha",

    Text = "Sentido de notificación",

    Callback = function(Value)
        -- Traducimos el valor seleccionado al inglés antes de mandarlo a la librería original
        if Value == "Izquierda" then
            Library:SetNotifySide("Left")
        else
            Library:SetNotifySide("Right")
        end
    end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "Resolución",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})

MenuGroup:AddSlider("UICornerSlider", {
	Text = "Curvatura de las esquinas",
	Default = Library.CornerRadius,
	Min = 0,
	Max = 30,
	Rounding = 0,
	Callback = function(value)
		Window:SetCornerRadius(value)
	end
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", {
    Text = "Eliminar script (GUI)",
    Tooltip = "Elimina el menú por completo", -- Opcional: puedes quitar esta línea si no quieres descripción

    Func = function()
        Library:Unload()
    end,
})
Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs.AjustesTab)

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs.AjustesTab)

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()
    game:FindFirstChild("CoreGui"):FindFirstChild("BotonPanelGui"):Destroy()
	print("El script ha sido descargado con éxito del cliente de "..JugadorLocal.Name)
end)

Library:Notify("Script ejecutado correctamente")
SonidoNotificacion:Play()