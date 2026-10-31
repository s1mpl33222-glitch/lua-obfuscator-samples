local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local NOMBRE_GUI = "BotonFlotanteSimple"

local function obtenerPadre()
    local ok, gui = pcall(function()
        if gethui then
            return gethui()
        end
        return nil
    end)
    if ok and gui then
        return gui
    end
    local okCore = pcall(function()
        local test = Instance.new("Folder")
        test.Parent = CoreGui
        test:Destroy()
    end)
    if okCore then
        return CoreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local padre = obtenerPadre()

local viejo = padre:FindFirstChild(NOMBRE_GUI)
if viejo then
    viejo:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = NOMBRE_GUI
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = padre

local boton = Instance.new("TextButton")
boton.Name = "Boton"
boton.Size = UDim2.fromOffset(56, 56)
boton.Position = UDim2.new(1, -80, 0.5, -28)
boton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
boton.BorderSizePixel = 0
boton.AutoButtonColor = false
boton.Text = "OFF"
boton.TextColor3 = Color3.fromRGB(255, 255, 255)
boton.TextSize = 16
boton.Font = Enum.Font.GothamBold
boton.Active = true
boton.Parent = screenGui

local esquina = Instance.new("UICorner")
esquina.CornerRadius = UDim.new(1, 0)
esquina.Parent = boton

local borde = Instance.new("UIStroke")
borde.Color = Color3.fromRGB(120, 120, 140)
borde.Thickness = 2
borde.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borde.Parent = boton

local activo = false

local function actualizarEstado()
    if activo then
        boton.Text = "ON"
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 160, 80)
        }):Play()
        TweenService:Create(borde, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(120, 255, 170)
        }):Play()
    else
        boton.Text = "OFF"
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        }):Play()
        TweenService:Create(borde, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(120, 120, 140)
        }):Play()
    end
end

local function alCambiar(estado)
    -- Pon aquí lo que quieres que haga el botón
    -- estado = true cuando se enciende, false cuando se apaga
    print("Botón:", estado and "ON" or "OFF")
end

local arrastrando = false
local movio = false
local inicioInput = nil
local inicioPos = nil
local DISTANCIA_MINIMA = 8

local function limitarPosicion(x, y)
    local camara = workspace.CurrentCamera
    local vista = camara and camara.ViewportSize or Vector2.new(800, 600)
    local ancho = boton.AbsoluteSize.X
    local alto = boton.AbsoluteSize.Y
    local nx = math.clamp(x, 0, vista.X - ancho)
    local ny = math.clamp(y, 0, vista.Y - alto)
    return nx, ny
end

boton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        arrastrando = true
        movio = false
        inicioInput = input.Position
        inicioPos = Vector2.new(boton.AbsolutePosition.X, boton.AbsolutePosition.Y)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                arrastrando = false
                if not movio then
                    activo = not activo
                    actualizarEstado()
                    task.spawn(alCambiar, activo)
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not arrastrando then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - inicioInput
        if not movio and delta.Magnitude >= DISTANCIA_MINIMA then
            movio = true
        end
        if movio then
            local inset = screenGui.IgnoreGuiInset and Vector2.new(0, 0) or Vector2.new(0, 36)
            local nx, ny = limitarPosicion(inicioPos.X + delta.X, inicioPos.Y + delta.Y)
            boton.Position = UDim2.fromOffset(nx, ny - inset.Y)
        end
    end
end)

actualizarEstado()