

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BotonFlotante"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Boton = Instance.new("TextButton")
Boton.Name = "BotonEjecutar"
Boton.Size = UDim2.new(0, 130, 0, 50)
Boton.Position = UDim2.new(1, -145, 0.5, -25)
Boton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Boton.TextColor3 = Color3.fromRGB(255, 255, 255)
Boton.Text = "ZL Hub PvP"
Boton.TextSize = 18
Boton.Parent = ScreenGui

local Esquinas = Instance.new("UICorner")
Esquinas.CornerRadius = UDim.new(0, 10)
Esquinas.Parent = Boton

local Cerrar = Instance.new("TextButton")
Cerrar.Name = "Cerrar"
Cerrar.Size = UDim2.new(0, 25, 0, 25)
Cerrar.Position = UDim2.new(1, -25, 0, -10)
Cerrar.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
Cerrar.TextColor3 = Color3.fromRGB(255, 255, 255)
Cerrar.Text = "X"
Cerrar.TextSize = 14
Cerrar.Parent = Boton

local EsquinasX = Instance.new("UICorner")
EsquinasX.CornerRadius = UDim.new(1, 0)
EsquinasX.Parent = Cerrar

Boton.MouseButton1Click:Connect(function()
    local codigo = [[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/Zlhub/refs/heads/main/zlpvp.lua"))()
    ]]

    local funcion, errorMsg = loadstring(codigo)

    if funcion then
        funcion()
    else
        warn("Error al ejecutar: " .. tostring(errorMsg))
    end
end)

Cerrar.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)