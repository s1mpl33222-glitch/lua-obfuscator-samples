local LOCOPANI_RAY_WINDOW
local LOCOPANI_RAYFIELD
local LOCOPANI_RAY_VISIBLE = true

-- LOCOPANI SUPABASE KEY SYSTEM
-- The Supabase Edge Function must atomically bind each key to its first userId.
local LOCOPANI_ACTIVATE_URL =
    "https://hshqmleifwkvzjrefabj.supabase.co/functions/v1/locopani-activate"

local function LOCOPANI_ActivateKey(key)
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local player = Players.LocalPlayer

    local env = (type(getgenv) == "function" and getgenv()) or _G
    local requestFn = env.request or env.http_request
    if not requestFn and type(env.syn) == "table" then
        requestFn = env.syn.request
    end
    if not requestFn and type(env.http) == "table" then
        requestFn = env.http.request
    end
    if not requestFn and type(env.fluxus) == "table" then
        requestFn = env.fluxus.request
    end

    if type(requestFn) ~= "function" then
        return false, "Este executor não disponibiliza uma função HTTP compatível."
    end

    -- Campos esperados pela Edge Function locopani-activate.
    local requestBody = HttpService:JSONEncode({
        key_code = key,
        roblox_user_id = tostring(player.UserId),
    })

    local requestOK, response = pcall(function()
        return requestFn({
            Url = LOCOPANI_ACTIVATE_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = requestBody,
        })
    end)

    if not requestOK or type(response) ~= "table" then
        return false, "Não foi possível contactar o servidor de ativação."
    end

    local statusCode = tonumber(response.StatusCode or response.Status or 0) or 0
    local body = response.Body
    if statusCode < 200 or statusCode >= 300 or type(body) ~= "string" then
        return false, "Erro no servidor de ativação (HTTP " .. tostring(statusCode) .. ")."
    end

    local decodeOK, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not decodeOK or type(data) ~= "table" then
        return false, "O servidor devolveu uma resposta inválida."
    end

    -- A Edge Function responde com { status = "...", authorized = true/false }.
    if data.authorized == true and
        (data.status == "ACTIVATED" or data.status == "ALREADY_LINKED") then
        if data.status == "ALREADY_LINKED" then
            return true, "Esta chave já está vinculada à tua conta."
        end
        return true, "Chave ativada com sucesso."
    end

    local messages = {
        INVALID_INPUT = "Os dados enviados são inválidos.",
        INVALID_KEY = "Chave inválida.",
        KEY_ALREADY_CLAIMED = "Esta chave já pertence a outro jogador.",
        USER_ALREADY_HAS_KEY = "Este jogador já tem uma chave vinculada.",
        EXPIRED_KEY = "Esta key expirou. Solicita uma nova key ao administrador.",
        INTERNAL_ERROR = "Erro interno ao validar a chave.",
        SERVER_CONFIG_ERROR = "A configuração do servidor está incompleta.",
        INVALID_REQUEST = "Pedido de ativação inválido.",
    }
    return false, messages[data.status] or
        ("Ativação recusada: " .. tostring(data.status or "resposta desconhecida"))
end

-- Lembra a key neste executor para não pedir novamente em cada execução.
-- A key salva NUNCA é considerada válida sem nova confirmação do Supabase.
local LOCOPANI_KEY_FILE = "locopani_key.dat"

local function LOCOPANI_GetSavedKey()
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local isfileFn = env.isfile or isfile
    local readfileFn = env.readfile or readfile
    if type(isfileFn) ~= "function" or type(readfileFn) ~= "function" then
        return nil
    end
    local okExists, exists = pcall(isfileFn, LOCOPANI_KEY_FILE)
    if not okExists or not exists then return nil end
    local okRead, saved = pcall(readfileFn, LOCOPANI_KEY_FILE)
    if not okRead or type(saved) ~= "string" then return nil end
    saved = string.upper(string.gsub(saved, "%s+", ""))
    if saved == "" then return nil end
    return saved
end

local function LOCOPANI_SaveKey(key)
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local writefileFn = env.writefile or writefile
    if type(writefileFn) == "function" then
        pcall(writefileFn, LOCOPANI_KEY_FILE, key)
    end
end

local function LOCOPANI_ShowKeyGate()
    local enteredKey = ""
    local accepted = false
    local busy = false
    local statusText = nil
    local statusLabel = nil

    -- Primeiro tenta validar a key salva. Se expirou ou o servidor recusar,
    -- continua para a tela normal de key.
    local savedKey = LOCOPANI_GetSavedKey()
    if savedKey then
        local savedValid = false
        local verifyOK, verifyResult = pcall(LOCOPANI_ActivateKey, savedKey)
        savedValid = verifyOK and verifyResult == true
        if savedValid then
            return true
        end
    end

    -- A interface do sistema de key usa Rayfield Gen2; a lógica de ativação Supabase permanece igual.
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()
    local keyWindow = Rayfield:CreateWindow({
        name = "LOCOPANI KEY SYSTEM",
        subtitle = "Rayfield Gen2",
        sidebarLayout = true,
        theme = "cobalt",
    })

    local keyTab = keyWindow:CreateTab({ name = "Key System" })
    keyTab:CreateInput({
        name = "Access key",
        placeholder = "LOCO-XXXX-XXXX",
        callback = function(value)
            enteredKey = tostring(value or "")
        end,
    })

    keyTab:CreateButton({
        name = "PEGAR ID ROBLOX",
        callback = function()
            local player = game:GetService("Players").LocalPlayer
            local userId = tostring(player.UserId)
            local env = (type(getgenv) == "function" and getgenv()) or _G
            local clipboardFn = env.setclipboard or env.toclipboard
                or env.set_clipboard or setclipboard or toclipboard

            if type(clipboardFn) == "function" then
                local copied = pcall(clipboardFn, userId)
                if statusText and statusText.Set then
                    pcall(function()
                        statusText:Set(copied and
                            ("ID do Roblox copiado: " .. userId) or
                            "Não foi possível copiar. Copie seu ID manualmente: " .. userId)
                    end)
                end
            elseif statusText and statusText.Set then
                pcall(function()
                    statusText:Set("Seu ID do Roblox: " .. userId ..
                        " (este executor não oferece suporte à área de transferência)")
                end)
            end
        end,
    })

    statusText = keyTab:CreateText({ name = "Digite sua chave de acesso e clique em Validar key." })

    keyTab:CreateButton({
        name = "Validar key",
        callback = function()
            if busy or accepted then return end
            busy = true

            local entered = string.upper(string.gsub(enteredKey, "%s+", ""))
            if entered == "" then
                if statusText and statusText.Set then
                    pcall(function() statusText:Set("Digite sua chave de acesso.") end)
                end
                busy = false
                return
            end

            if statusText and statusText.Set then
                pcall(function() statusText:Set("Verificando key no Supabase...") end)
            end

            local valid, message = LOCOPANI_ActivateKey(entered)
            if valid then
                LOCOPANI_SaveKey(entered)
                accepted = true
                if statusText and statusText.Set then
                    pcall(function() statusText:Set("Chave validada. Iniciando LOCOPANI...") end)
                end
                task.wait(0.35)
                pcall(function()
                    if keyWindow.Unload then
                        keyWindow:Unload()
                    elseif keyWindow.Destroy then
                        keyWindow:Destroy()
                    elseif keyWindow.SetVisibility then
                        keyWindow:SetVisibility(false)
                    elseif keyWindow.SetVisible then
                        keyWindow:SetVisible(false)
                    end
                end)
            else
                if statusText and statusText.Set then
                    pcall(function() statusText:Set(tostring(message or "Key inválida ou já vinculada a outro jogador.")) end)
                end
                busy = false
            end
        end,
    })

    while not accepted do
        task.wait(0.1)
    end
    return accepted
end
if not LOCOPANI_ShowKeyGate() then
    return
end

local players, replicatedStorage, userInputService, tweenService, httpService, workspaceService,
  runService, lighting, teleportService, collectionService, replicatedFirst, soundService, v174,
  options, toggles, localPlayer2, currentCamera2, v175, v176, v177, v178, v179, v182, v183,
  v184, v185, v186, v187, v188, v189, v190, v191, v192, v193, v194, v195, v196, v197, v198,
  v199, v200, v201, v202, scoreEffect, v203, v204, v205, v206, v207, v208, v209, v210, jersey,
  v211, ball, v212, v213, v214, v215, v216, v217, v218, v219, v220, v221, v222, v223, v224,
  v225, v226, v227, v228, v229, v231, ballService, serve, effects, doMove, stopAllEmotes,
  effect, v235, v238, f50, v242, v243, v255, v308, v323, v329, v336, textButton2, textButton3,
  textButton4, v395, textButton5, bodyVelocity, f96, textButton6, v418, v440, v451, v495,
  LocopaniWindow, v545, v546

do
  players = game:GetService("Players")
  replicatedStorage = game:GetService("ReplicatedStorage")
  userInputService = game:GetService("UserInputService")
  tweenService = game:GetService("TweenService")
  local GuiService = game:GetService("GuiService")
  httpService = game:GetService("HttpService")
  workspaceService = game:GetService("Workspace")
  runService = game:GetService("RunService")
  lighting = game:GetService("Lighting")
  teleportService = game:GetService("TeleportService")
  collectionService = game:GetService("CollectionService")
  replicatedFirst = game:GetService("ReplicatedFirst")
  soundService = game:GetService("SoundService")

  local function f1()
    local TypeName = type(getgenv) == "function" and getgenv() or _G
    local GetFenv = getfenv(1)
    local v2 = {}

    local function f2(p1)
      for index, value in ipairs({ GetFenv, TypeName, _G }) do
        local Value = value
        local v4, v5 = pcall(function() return Value[p1] end)

        if v4 and type(v5) == "function" then
          return v5
        end
      end

      return nil
    end

    local function f3(p2)
      local v6, v7 = pcall(function() return GetFenv[p2] or TypeName[p2] end)

      if v6 and type(v7) == "table" then
        return v7
      end

      return nil
    end

    local function f4(p3, p4)
      if not p4 then
        table.insert(v2, p3)
        return
      end

      pcall(function() TypeName[p3] = p4 end)
      pcall(function() GetFenv[p3] = p4 end)
    end

    local f2_2 = f2("getconnections") or f2("get_signal_cons")
    f4("getconnections", f2_2)
    local f2_3 = f2("firesignal") or f2("fire_signal")
    local v10

    if f2_3 and f2_2 and function(p5, ...)
      for index2, value2 in ipairs(f2_2(p5)) do
      end
    end then
      local BindableEvent = Instance.new("BindableEvent")
      v10 = false
      BindableEvent.Event:Connect(function() v10 = true end)
      pcall(f2_3, BindableEvent.Event, true)
      task.wait(0.1)
      BindableEvent:Destroy()

      if not v10 then
        f2_3 = nil
      end
    end

    local f2_4 = f2("request") or f2("http_request")

    if not f2_4 then
      local f3_2 = f3("syn") or f3("http") or f3("fluxus")
      f2_4 = f3_2 and f3_2.f2_4
    end

    f4("httpGet", function(p6)
      local v11, v12 = pcall(function() return game:HttpGet(p6) end)

      if v11 and type(v12) == "string" and #v12 > 0 then
        return v12
      elseif f2_4 then
        local v13, v14 = pcall(f2_4, { Url = p6, Method = "GET" })

        if v13 and type(v14) == "table" and type(v14.Body) == "string" then
          return v14.Body
        end

        error("Locopani: no working HTTP method for " .. tostring(p6), 0)
        return
      else
        error("Locopani: no working HTTP method for " .. tostring(p6), 0)
        return
      end
    end)

    local f2_5 = f2("gethui") or f2("get_hidden_gui")
    local f2_6 = f2("protect_gui")

    if not f2_6 then
      local f3_3 = f3("syn")
      f2_6 = f3_3 and f3_3.protect_gui
    end

    f4("hidegui", function(p7)
      if f2_6 then
        pcall(f2_6, p7)
      end

      if f2_5 then
        local v16, v17 = pcall(f2_5)

        if v16 and typeof(v17) == "Instance" then
          p7.Parent = v17
          return
        end
      end

      local v18, v19 = pcall(game.GetService, game, "CoreGui")

      if v18 and v19 then
        if pcall(function() p7.Parent = v19 end) then
          return
        end

        p7.Parent = players.LocalPlayer:WaitForChild("PlayerGui")
        return
      end

      p7.Parent = players.LocalPlayer:WaitForChild("PlayerGui")
    end)

    if #v2 > 0 then
      warn("Locopani: this executor has no " .. table.concat(v2, ", ")
        .. " - features that need them stay off")
    end
  end

  f1()

  local TypeName_2 = type(getgenv) == "function" and getgenv() or _G
  local RawValue = rawget(TypeName_2, "Locopani_SESSION") or TypeName_2.Locopani_SESSION
  local TypeName_3 = type(RawValue) == "table" and RawValue.TypeName_3 or nil

  if type(RawValue) == "table" and type(RawValue.unload) == "function" then
    pcall(RawValue.unload)
  end

  local v20 = getrawmetatable and getrawmetatable(game)
  local v21 = v20 and rawget(v20, "__namecall")

  local v22 = {}
  v22.TypeName_3 = TypeName_3

  function v22.unload()
    if v22.TypeName_3 and v22.TypeName_3.inventory then
      pcall(function()
        local Module = require(replicatedStorage.Packages.Knit).GetController("InventoryController")

        if Module and Module.Inventory then
          Module.Inventory:set(v22.TypeName_3.inventory)
        end
      end)
    end

    if v22.ui and v22.ui.Unload then
      pcall(function() v22.ui:Unload() end)
    end

    for index3, value3 in ipairs(v22.links or {}) do
      local Value3 = value3
      pcall(function() Value3:Disconnect() end)
    end

    pcall(function()
      local v24 = {}

      for index4, value4 in ipairs(v22.tags or {}) do
        v24[value4] = true
      end

      if not next(v24) then
        return
      else
        local v25 = {}

        if type(gethui) == "function" then
          local v26, v27 = pcall(gethui)

          if v26 and v27 then
            table.insert(v25, v27)
          end
        end

        local Game = game
        table.insert(v25, Game:GetService("CoreGui"))

        if workspace.CurrentCamera then
          table.insert(v25, workspace.CurrentCamera)
        end

        if players.LocalPlayer then
          local PlayerGui = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

          if PlayerGui then
            table.insert(v25, PlayerGui)
          end
        end

        for index5, value5 in ipairs(v25) do
        end

        for index6, value6 in ipairs(workspace:GetChildren()) do
          if value6:IsA("Model") and value6.Name:match("^CLIENT_BALL_%d+$") then
            for index7, value7 in ipairs(value6:GetChildren()) do
              if v24[value7.Name] then
                value7:Destroy()
              end
            end
          end
        end

        for index8, value8 in ipairs(players:GetPlayers()) do
          if value8.Character then
            for index9, value9 in ipairs(value8.Character:GetChildren()) do
              if v24[value9.Name] then
                value9:Destroy()
              end
            end
          end
        end

        return
      end
    end)

    if v20 and v21 then
      pcall(setreadonly, v20, false)
      v20.__namecall = v21
      pcall(setreadonly, v20, true)
    end
  end

  v22.links = {}
  v22.tags = {}

  TypeName_2.Locopani_Season = v22

  local function f5()
    local LocalPlayer = players.LocalPlayer

    -- LOCOPANI UI theme: black minimalist / monochrome
    local v29 = {
      Accent = Color3.fromRGB(245, 245, 247),
      AccentSoft = Color3.fromRGB(42, 42, 46),
      Shell = Color3.fromRGB(8, 8, 9),
      ShellTop = Color3.fromRGB(24, 24, 26),
      Panel = Color3.fromRGB(15, 15, 17),
      Raised = Color3.fromRGB(30, 30, 33),
      Sunken = Color3.fromRGB(5, 5, 6),
      Line = Color3.fromRGB(72, 72, 77),
      LineSoft = Color3.fromRGB(38, 38, 42),
      Text = Color3.fromRGB(250, 250, 252),
      SubText = Color3.fromRGB(184, 184, 190),
      Faint = Color3.fromRGB(132, 132, 140),
    }

    local UDim_2 = UDim.new(1, 0)
    local TweenInfo_2 = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local v30 = {
      Options = {},
      Toggles = {},
      Theme = v29,
      CornerRadius = 12,
      ForceCheckbox = false,
      ShowToggleFrameInKeybinds = true,
      NotifySide = "Right",
      Unloaded = false,
      ToggleKeybind = nil,
      DefaultToggleKey = "RightShift",
    }

    local v31 = {}
    local v32 = {}
    local v33 = {}
    local v34 = {}
    local v35 = "Locopani"

    local function f6(p8, p9, p10)
      local Instance_2 = Instance.new(p8)

      for key, value10 in pairs(p9) do
        Instance_2[key] = value10
      end

      if p10 then
        Instance_2.Parent = p10
      end

      return Instance_2
    end

    local function f7(p11, cornerRadius, p12)
      local f6_2 = f6("UICorner", { CornerRadius = cornerRadius }, p11)

      if p12 then
        table.insert(v32, f6_2)
      end

      return f6_2
    end

    local function f8(p13, p14, p15, p16)
      return f6("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Round,
        Color = p14 or v29.Line,
        Thickness = p15 or 1,
        Transparency = p16 or 0,
      }, p13)
    end

    local function f9(p17, p18, p19, p20, p21)
      return f6("UIPadding", {
        PaddingLeft = UDim.new(0, p18 or 0),
        PaddingRight = UDim.new(0, p19 or 0),
        PaddingTop = UDim.new(0, p20 or 0),
        PaddingBottom = UDim.new(0, p21 or 0),
      }, p17)
    end

    local function f10(p22, p23, p24)
      return f6("UIListLayout", {
        FillDirection = p24 or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, p23 or 0),
      }, p22)
    end

    local function f11(p25, p26, p27)
      local New = tweenService:Create(p25, p27 and TweenInfo.new(
        p27, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
      ) or TweenInfo_2, p26)

      New:Play()
      return New
    end

    local function f12(p28, p29)
      local Connection = p28:Connect(p29)
      table.insert(v31, Connection)
      return Connection
    end

    local function f13()
      return string.char(
        math.random(97, 122), math.random(97, 122), math.random(97, 122), math.random(97, 122)
      ) .. tostring(math.random(100000, 999999))
    end

    local f6_3 = f6("ScreenGui", {
      Name = f13(),
      ResetOnSpawn = false,
      IgnoreGuiInset = true,
      AutoLocalize = false,
      ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
      DisplayOrder = 9999,
    })

    local v38 = false

    if type(hidegui) == "function" then
      v38 = pcall(hidegui, f6_3)
    end

    if not v38 or not f6_3.Parent then
      f6_3.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    pcall(function() userInputService.MouseIconEnabled = true end)

    local f6_4 = f6("Frame", {
      BackgroundColor3 = v29.Raised,
      BorderSizePixel = 0,
      AutomaticSize = Enum.AutomaticSize.XY,
      Size = UDim2.fromOffset(0, 0),
      Visible = false,
      ZIndex = 190,
    }, f6_3)

    f7(f6_4, UDim.new(0, 8))
    f8(f6_4, v29.Line, 1)
    f9(f6_4, 10, 10, 7, 7)

    local f6_5 = f6("TextLabel", {
      BackgroundTransparency = 1,
      AutomaticSize = Enum.AutomaticSize.XY,
      Font = Enum.Font.GothamMedium,
      TextSize = 12,
      TextColor3 = v29.Text,
      TextXAlignment = Enum.TextXAlignment.Left,
      Text = "",
      ZIndex = 191,
    }, f6_4)

    local f6_6 = f6("Frame", {
      AnchorPoint = Vector2.new(1, 0),
      Position = UDim2.new(1, -18, 0, 18),
      Size = UDim2.fromOffset(280, 0),
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      ZIndex = 180,
    }, f6_3)

    f10(f6_6, 8)

    local f6_7 = f6("Frame", {
      Position = UDim2.fromOffset(24, 120),
      Size = UDim2.fromOffset(190, 0),
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundColor3 = v29.Panel,
      BorderSizePixel = 0,
      Visible = false,
      ZIndex = 60,
    }, f6_3)

    f7(f6_7, UDim.new(0, v30.CornerRadius), true)
    f8(f6_7, v29.LineSoft, 1)
    f9(f6_7, 12, 12, 10, 12)
    f10(f6_7, 6)

    f6("TextLabel", {
      Size = UDim2.new(1, 0, 0, 16),
      BackgroundTransparency = 1,
      Font = Enum.Font.GothamBold,
      TextSize = 12,
      TextColor3 = v29.Text,
      TextXAlignment = Enum.TextXAlignment.Left,
      Text = "Keybinds",
      LayoutOrder = 0,
      ZIndex = 61,
    }, f6_7)

    local f6_8 = f6("Frame", {
      Size = UDim2.new(1, 0, 0, 0),
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      LayoutOrder = 1,
      ZIndex = 61,
    }, f6_7)

    f10(f6_8, 4)

    v30.KeybindFrame = f6_7
    v30.Root = f6_3

    local function f14()
      return userInputService:GetMouseLocation() + Vector2.new(0, GuiService:GetGuiInset().Y)
    end

    local function f15(p30, p31)
      if not p31 or p31 == "" then
        return
      end

      f12(p30.MouseEnter, function()
        f6_5.Text = p31
        local f14_2 = f14()

        f6_4.Position = UDim2.fromOffset(f14_2.X + 16, f14_2.Y + 18)
        f6_4.Visible = true
      end)

      f12(p30.MouseMoved, function()
        if f6_4.Visible then
          local f14_3 = f14()
          f6_4.Position = UDim2.fromOffset(f14_3.X + 16, f14_3.Y + 18)
        end
      end)

      f12(p30.MouseLeave, function() f6_4.Visible = false end)
    end

    function v30:Notify(p32, p33)
      local P33 = p33
      local P32 = p32

      if type(p32) == "table" then
        P32 = p32.Description or p32.Title or p32.Text or ""
        P33 = P33 or p32.Time
      end

      local f6_9 = f6("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = v29.Raised,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        ZIndex = 181,
      }, f6_6)

      f7(f6_9, UDim.new(0, 10))
      local f8_2 = f8(f6_9, v29.Line, 1, 1)
      f9(f6_9, 12, 12, 10, 10)

      local f6_10 = f6("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = v29.Text,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Text = tostring(P32),
        ZIndex = 182,
      }, f6_9)

      f11(f6_9, { BackgroundTransparency = 0 })
      f11(f8_2, { Transparency = 0 })
      f11(f6_10, { TextTransparency = 0 })

      task.delay(P33 or 4, function()
        if not f6_9.Parent then
          return
        end

        f11(f6_9, { BackgroundTransparency = 1 })
        f11(f8_2, { Transparency = 1 })
        f11(f6_10, { TextTransparency = 1 })

        task.wait(0.24)
        f6_9:Destroy()
      end)
    end

    function v30:SetNotifySide(p34)
      v30.NotifySide = p34

      if p34 == "Left" then
        f6_6.AnchorPoint = Vector2.new(0, 0)
        f6_6.Position = UDim2.new(0, 18, 0, 18)
      else
        f6_6.AnchorPoint = Vector2.new(1, 0)
        f6_6.Position = UDim2.new(1, -18, 0, 18)
      end
    end

    local function f16()
      for index10, value11 in ipairs(f6_8:GetChildren()) do
        if value11:IsA("Frame") then
          value11:Destroy()
        end
      end

      local count = 0

      for index11, value12 in ipairs(v33) do
        if not value12.NoUI and value12.Value and value12.Value ~= "" then
          count = count + 1

          local f6_11 = f6("Frame", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            LayoutOrder = count,
            ZIndex = 62,
          }, f6_8)

          f6("TextLabel", {
            Size = UDim2.new(1, -54, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = v29.SubText,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = value12.Label,
            ZIndex = 62,
          }, f6_11)

          local f6_12 = f6("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(52, 18),
            BackgroundColor3 = v29.Sunken,
            BorderSizePixel = 0,
            ZIndex = 62,
          }, f6_11)

          f7(f6_12, UDim_2)
          f8(f6_12, v29.Line, 1)

          f6("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = v29.Accent,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = value12.Value,
            ZIndex = 63,
          }, f6_12)
        end
      end
    end

    local function f17(p35, p36)
      local v52 = false
      local position, position2

      f12(p35.InputBegan, function(p37)
        if p37.UserInputType == Enum.UserInputType.MouseButton1
          or p37.UserInputType == Enum.UserInputType.Touch then
          v52 = true
          position = p37.Position
          position2 = p36.Position
        end
      end)

      f12(p35.InputEnded, function(p38)
        if p38.UserInputType == Enum.UserInputType.MouseButton1
          or p38.UserInputType == Enum.UserInputType.Touch then
          v52 = false
        end
      end)

      f12(userInputService.InputChanged, function(p39)
        if not v52 then
          return
        end

        if p39.UserInputType == Enum.UserInputType.MouseMovement
          or p39.UserInputType == Enum.UserInputType.Touch then
          local v53 = p39.Position - position

          p36.Position = UDim2.new(
            position2.X.Scale, position2.X.Offset + v53.X, position2.Y.Scale,
            position2.Y.Offset + v53.Y
          )
        end
      end)
    end

    f17(f6_7, f6_7)

    local function f18(p40)
      local v54 = { Holder = p40, Order = 0 }

      local function f19(p41, p42)
        v54.Order = v54.Order + 1

        local f6_13 = f6("Frame", {
          Size = UDim2.new(1, 0, 0, p41 or 0),
          BackgroundTransparency = 1,
          LayoutOrder = v54.Order,
        }, p40)

        if p42 then
          f6_13.AutomaticSize = Enum.AutomaticSize.Y
        end

        return f6_13
      end

      local function f20(p43, text)
        return f6("TextLabel", {
          Size = UDim2.new(1, 0, 0, 15),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.SubText,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Text = text,
          LayoutOrder = 0,
        }, p43)
      end

      function v54:AddToggle(p44, p45)
        local P45 = p45
        P45 = P45 or {}

        local f19_2 = f19(30)

        local f6_14 = f6("TextLabel", {
          Size = UDim2.new(1, -54, 1, 0),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.SubText,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Text = P45.Text or p44,
        }, f19_2)

        local ForceCheckbox = v30.ForceCheckbox

        local f6_15 = f6("Frame", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, 0, 0.5, 0),
          Size = ForceCheckbox and UDim2.fromOffset(21, 21) or UDim2.fromOffset(42, 22),
          BackgroundColor3 = v29.Sunken,
          BorderSizePixel = 0,
        }, f19_2)

        f7(f6_15, ForceCheckbox and UDim.new(0, 6) or UDim_2)
        local f8_3 = f8(f6_15, v29.Line, 1)

        local f6_16 = f6("Frame", {
          Position = ForceCheckbox and UDim2.fromOffset(5, 5) or UDim2.fromOffset(3, 3),
          Size = ForceCheckbox and UDim2.fromOffset(11, 11) or UDim2.fromOffset(16, 16),
          BackgroundColor3 = v29.Faint,
          BorderSizePixel = 0,
        }, f6_15)

        f7(f6_16, ForceCheckbox and UDim.new(0, 3) or UDim_2)

        if not ForceCheckbox then
          f8(f6_16, v29.Line, 1)
        end

        local f6_17 = f6("TextButton", {
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          Text = "",
          AutoButtonColor = false,
        }, f19_2)

        f15(f6_17, P45.Tooltip)

        local v63 = {
          Value = false,
          Type = "Toggle",
          Index = p44,
          Callbacks = {},
        }

        local function f21()
          if v63.Value then
            f11(f6_15, { BackgroundColor3 = v29.AccentSoft })
            f11(f8_3, { Color = v29.Accent })
            f11(f6_16, { BackgroundColor3 = v29.Text })
            f11(f6_14, { TextColor3 = v29.Text })

            if not ForceCheckbox then
              f11(f6_16, { Position = UDim2.fromOffset(23, 3) })
            end
          else
            f11(f6_15, { BackgroundColor3 = v29.Sunken })
            f11(f8_3, { Color = v29.Line })
            f11(f6_16, { BackgroundColor3 = v29.Faint })
            f11(f6_14, { TextColor3 = v29.SubText })

            if not ForceCheckbox then
              f11(f6_16, { Position = UDim2.fromOffset(3, 3) })
            end
          end
        end

        function v63:SetValue(p46, p47)
          v63.Value = p46 and true or false
          f21()

          if p47 then
            return
          end

          if P45.Callback then
            task.spawn(P45.Callback, v63.Value)
          end

          for index12, value13 in ipairs(v63.Callbacks) do
            task.spawn(value13, v63.Value)
          end
        end

        function v63.OnChanged(p48, p49)
          table.insert(v63.Callbacks, p49)
          task.spawn(p49, v63.Value)
          return v63
        end

        f12(f6_17.MouseButton1Click, function() v63:SetValue(not v63.Value) end)
        v63:SetValue(P45.Default and true or false, true)

        if P45.Default then
          if P45.Callback then
            task.spawn(P45.Callback, true)
          end
        end

        v30.Toggles[p44] = v63
        return v63
      end

      function v54:AddSlider(p50, p51)
        local P51 = p51
        P51 = P51 or {}

        local f19_3 = f19(44)
        f15(f19_3, P51.Tooltip)

        f6("TextLabel", {
          Size = UDim2.new(1, -70, 0, 16),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.SubText,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Text = P51.Text or p50,
        }, f19_3)

        local f6_18 = f6("TextLabel", {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, 0, 0, 0),
          Size = UDim2.fromOffset(70, 16),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamBold,
          TextSize = 12,
          TextColor3 = v29.Accent,
          TextXAlignment = Enum.TextXAlignment.Right,
          Text = "0",
        }, f19_3)

        local f6_19 = f6("Frame", {
          Position = UDim2.new(0, 0, 0, 26),
          Size = UDim2.new(1, 0, 0, 10),
          BackgroundColor3 = v29.Sunken,
          BorderSizePixel = 0,
        }, f19_3)

        f7(f6_19, UDim_2)
        f8(f6_19, v29.Line, 1)

        local f6_20 = f6("Frame", {
          Size = UDim2.new(0, 0, 1, 0),
          BackgroundColor3 = v29.Accent,
          BorderSizePixel = 0,
        }, f6_19)

        f7(f6_20, UDim_2)

        local f6_21 = f6("Frame", {
          AnchorPoint = Vector2.new(0.5, 0.5),
          Position = UDim2.new(0, 0, 0.5, 0),
          Size = UDim2.fromOffset(14, 14),
          BackgroundColor3 = v29.Text,
          BorderSizePixel = 0,
          ZIndex = 3,
        }, f6_19)

        f7(f6_21, UDim_2)
        f8(f6_21, v29.Accent, 1)
        local min = P51.Min or 0
        local max = P51.Max or 100
        local v70 = 10 ^ (P51.Rounding or 0)

        local v71 = {
          Value = P51.Default or min,
          Type = "Slider",
          Index = p50,
          Min = min,
          Max = max,
          Callbacks = {},
        }

        local function f22()
          local v72 = max - min
          local Clamp = v72 > 0 and math.clamp((v71.Value - min) / v72, 0, 1) or 0
          f6_20.Size = UDim2.new(Clamp, 0, 1, 0)
          f6_21.Position = UDim2.new(Clamp, 0, 0.5, 0)
          f6_18.Text = tostring(v71.Value) .. (P51.Suffix or "")
        end

        function v71:SetValue(p52, p53)
          local ToNumber = tonumber(p52) or min
          local MathClamp = math.clamp(ToNumber, min, max)
          local MathFloor = math.floor(MathClamp * v70 + 0.5) / v70
          v71.Value = MathFloor
          f22()

          if p53 then
            return
          end

          if P51.Callback then
            task.spawn(P51.Callback, MathFloor)
          end

          for index13, value14 in ipairs(v71.Callbacks) do
            task.spawn(value14, MathFloor)
          end
        end

        function v71.OnChanged(p54, p55)
          table.insert(v71.Callbacks, p55)
          task.spawn(p55, v71.Value)
          return v71
        end

        local function f23(p56)
          local X = f6_19.AbsoluteSize.X

          if X <= 0 then
            return
          end

          v71:SetValue(min + (max - min) * math.clamp((p56 - f6_19.AbsolutePosition.X) / X, 0, 1))
        end

        local v77 = false

        f12(f6_19.InputBegan, function(p57)
          if p57.UserInputType == Enum.UserInputType.MouseButton1
            or p57.UserInputType == Enum.UserInputType.Touch then
            v77 = true
            f11(f6_21, { Size = UDim2.fromOffset(18, 18) })
            f23(p57.Position.X)
          end
        end)

        f12(userInputService.InputEnded, function(p58)
          if p58.UserInputType == Enum.UserInputType.MouseButton1
            or p58.UserInputType == Enum.UserInputType.Touch then
            if v77 then
              v77 = false
              f11(f6_21, { Size = UDim2.fromOffset(14, 14) })
            end
          end
        end)

        f12(userInputService.InputChanged, function(p59)
          if v77
            and (p59.UserInputType == Enum.UserInputType.MouseMovement
              or p59.UserInputType == Enum.UserInputType.Touch) then
            f23(p59.Position.X)
          end
        end)

        v71:SetValue(P51.Default or min, true)

        if P51.Default ~= nil and P51.Callback then
          task.spawn(P51.Callback, v71.Value)
        end

        v30.Options[p50] = v71
        return v71
      end

      function v54:AddDropdown(p60, p61)
        local P61 = p61
        P61 = P61 or {}

        local f19_4 = f19(0, true)
        f10(f19_4, 6)
        f15(f19_4, P61.Tooltip)
        f20(f19_4, P61.Text or p60)

        local f6_22 = f6("TextButton", {
          Size = UDim2.new(1, 0, 0, 30),
          BackgroundColor3 = v29.Sunken,
          BorderSizePixel = 0,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.Text,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Text = "",
          AutoButtonColor = false,
          LayoutOrder = 1,
        }, f19_4)

        f7(f6_22, UDim_2)
        local f8_4 = f8(f6_22, v29.Line, 1)
        f9(f6_22, 14, 30, 0, 0)

        local f6_23 = f6("TextLabel", {
          AnchorPoint = Vector2.new(1, 0.5),
          Position = UDim2.new(1, -12, 0.5, 0),
          Size = UDim2.fromOffset(12, 12),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamBold,
          TextSize = 12,
          TextColor3 = v29.Faint,
          Text = ">",
          Rotation = 90,
        }, f6_22)

        local f6_24 = f6("Frame", {
          Size = UDim2.new(1, 0, 0, 0),
          BackgroundColor3 = v29.Sunken,
          BorderSizePixel = 0,
          Visible = false,
          LayoutOrder = 2,
          ClipsDescendants = true,
        }, f19_4)

        f7(f6_24, UDim.new(0, 10))
        f8(f6_24, v29.Line, 1)

        local f6_25 = f6("ScrollingFrame", {
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          CanvasSize = UDim2.new(),
          AutomaticCanvasSize = Enum.AutomaticSize.Y,
          ScrollBarThickness = 2,
          ScrollBarImageColor3 = v29.Line,
          ScrollingDirection = Enum.ScrollingDirection.Y,
        }, f6_24)

        f10(f6_25, 3)
        f9(f6_25, 5, 7, 5, 5)

        local v85 = {
          Value = nil,
          Type = "Dropdown",
          Index = p60,
          Values = P61.Values or {},
          Callbacks = {},
          Open = false,
        }

        local v86 = {}

        local function f24()
          f6_22.Text = tostring(v85.Value or "--")

          for key2, value15 in pairs(v86) do
            if key2 == v85.Value then
              f11(value15.Frame, { BackgroundColor3 = v29.AccentSoft })
              f11(value15.Edge, { Transparency = 0, Color = v29.Accent })
              f11(value15.Label, { TextColor3 = v29.Text })
            else
              f11(value15.Frame, { BackgroundColor3 = v29.Raised })
              f11(value15.Edge, { Transparency = 1, Color = v29.Line })
              f11(value15.Label, { TextColor3 = v29.SubText })
            end
          end
        end

        function v85:SetValue(p62, p63)
          v85.Value = p62
          f24()

          if p63 then
            return
          end

          if P61.Callback then
            task.spawn(P61.Callback, p62)
          end

          for index14, value16 in ipairs(v85.Callbacks) do
            task.spawn(value16, p62)
          end
        end

        function v85.OnChanged(p64, p65)
          table.insert(v85.Callbacks, p65)
          task.spawn(p65, v85.Value)
          return v85
        end

        local function f25()
          v85.Open = false

          f6_24.Visible = false
          f6_24.Size = UDim2.new(1, 0, 0, 0)

          f11(f6_23, { Rotation = 90 })
          f11(f8_4, { Color = v29.Line })
        end

        function v85:SetValues(p66)
          v85.Values = p66 or {}
          v86 = {}

          for index15, value17 in ipairs(f6_25:GetChildren()) do
            if value17:IsA("TextButton") then
              value17:Destroy()
            end
          end

          for index16, value18 in ipairs(v85.Values) do
            local Value18 = value18

            local f6_26 = f6("TextButton", {
              Size = UDim2.new(1, 0, 0, 26),
              BackgroundColor3 = v29.Raised,
              BorderSizePixel = 0,
              Font = Enum.Font.GothamMedium,
              TextSize = 12,
              TextColor3 = v29.SubText,
              TextXAlignment = Enum.TextXAlignment.Left,
              TextTruncate = Enum.TextTruncate.AtEnd,
              Text = "",
              AutoButtonColor = false,
              LayoutOrder = index16,
            }, f6_25)

            f7(f6_26, UDim_2)
            local f8_5 = f8(f6_26, v29.Line, 1, 1)
            local UDim2_2 = UDim2.new(1, -24, 1, 0)
            local UDim2_3 = UDim2.fromOffset(12, 0)
            local ToString = tostring(Value18)

            v86[Value18] = {
              Frame = f6_26,
              Edge = f8_5,
              Label = f6("TextLabel", {
                Size = UDim2_2,
                Position = UDim2_3,
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = v29.SubText,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = ToString,
              }, f6_26),
            }

            f12(f6_26.MouseButton1Click, function()
              v85:SetValue(Value18)
              f25()
            end)
          end

          f24()
        end

        f12(f6_22.MouseButton1Click, function()
          v85.Open = not v85.Open

          if v85.Open then
            local MathClamp_2 = math.clamp(#v85.Values * 29 + 10, 36, 168)

            f6_24.Visible = true
            f6_24.Size = UDim2.new(1, 0, 0, 0)

            f11(f6_24, { Size = UDim2.new(1, 0, 0, MathClamp_2) })
            f11(f6_23, { Rotation = 270 })
            f11(f8_4, { Color = v29.Accent })
          else
            f25()
          end
        end)

        v85:SetValues(P61.Values or {})
        v85:SetValue(P61.Default, true)

        if P61.Default ~= nil and P61.Callback then
          task.spawn(P61.Callback, P61.Default)
        end

        v30.Options[p60] = v85
        return v85
      end

      function v54:AddInput(p67, p68)
        local P68 = p68
        P68 = P68 or {}

        local f19_5 = f19(0, true)
        f10(f19_5, 6)
        f15(f19_5, P68.Tooltip)
        f20(f19_5, P68.Text or p67)
        local UDim2_4 = UDim2.new(1, 0, 0, 30)

        local f6_27 = f6("TextBox", {
          Size = UDim2_4,
          BackgroundColor3 = v29.Sunken,
          BorderSizePixel = 0,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.Text,
          PlaceholderColor3 = v29.Faint,
          PlaceholderText = P68.Placeholder or "",
          TextXAlignment = Enum.TextXAlignment.Left,
          ClearTextOnFocus = false,
          Text = P68.Default or "",
          LayoutOrder = 1,
        }, f19_5)

        f7(f6_27, UDim_2)
        local f8_6 = f8(f6_27, v29.Line, 1)
        f9(f6_27, 14, 14, 0, 0)

        local v94 = {
          Value = P68.Default or "",
          Type = "Input",
          Index = p67,
          Callbacks = {},
        }

        local function f26(p69)
          v94.Value = p69

          if P68.Callback then
            task.spawn(P68.Callback, p69)
          end

          for index17, value19 in ipairs(v94.Callbacks) do
            task.spawn(value19, p69)
          end
        end

        function v94:SetValue(p70, p71)
          local ToString_2 = tostring(p70 or "")
          f6_27.Text = ToString_2

          if p71 then
            v94.Value = ToString_2
            return
          end

          f26(ToString_2)
        end

        function v94.OnChanged(p72, p73)
          table.insert(v94.Callbacks, p73)
          task.spawn(p73, v94.Value)
          return v94
        end

        f12(f6_27.Focused, function() f11(f8_6, { Color = v29.Accent }) end)

        f12(f6_27.FocusLost, function()
          f11(f8_6, { Color = v29.Line })
          local Text = f6_27.Text

          if P68.Numeric and Text ~= "" and not tonumber(Text) then
            f6_27.Text = v94.Value
            return
          end

          f26(Text)
        end)

        if not P68.Finished then
          f12(f6_27:GetPropertyChangedSignal("Text"), function()
            if f6_27:IsFocused() then
              local Text_2 = f6_27.Text

              if P68.Numeric and Text_2 ~= "" and not tonumber(Text_2) then
                return
              end

              f26(Text_2)
              return
            end
          end)
        end

        v30.Options[p67] = v94
        return v94
      end

      function v54:AddTextBox(p74, p75)
        local P75 = p75
        P75 = P75 or {}

        local f19_6 = f19(0, true)
        f10(f19_6, 6)
        f15(f19_6, P75.Tooltip)
        f20(f19_6, P75.Text or p74)

        local f6_28 = f6("Frame", {
          Size = UDim2.new(1, 0, 0, P75.Height or 140),
          BackgroundColor3 = v29.Sunken,
          BorderSizePixel = 0,
          LayoutOrder = 1,
        }, f19_6)

        f7(f6_28, UDim.new(0, 10))
        local f8_7 = f8(f6_28, v29.Line, 1)

        local f6_29 = f6("TextBox", {
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          Font = Enum.Font.Code,
          TextSize = 12,
          TextColor3 = v29.Text,
          PlaceholderColor3 = v29.Faint,
          PlaceholderText = P75.Placeholder or "",
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Top,
          ClearTextOnFocus = false,
          MultiLine = true,
          TextWrapped = false,
          Text = P75.Default or "",
        }, f6_28)

        f9(f6_29, 12, 12, 10, 10)

        local v101 = {
          Value = P75.Default or "",
          Type = "TextBox",
          Index = p74,
          Callbacks = {},
        }

        local function f27(p76)
          v101.Value = p76

          if P75.Callback then
            task.spawn(P75.Callback, p76)
          end

          for index18, value20 in ipairs(v101.Callbacks) do
            task.spawn(value20, p76)
          end
        end

        function v101:SetValue(p77, p78)
          local ToString_3 = tostring(p77 or "")
          f6_29.Text = ToString_3

          if p78 then
            v101.Value = ToString_3
            return
          end

          f27(ToString_3)
        end

        function v101:GetValue()
          return f6_29.Text
        end

        function v101.OnChanged(p79, p80)
          table.insert(v101.Callbacks, p80)
          return v101
        end

        f12(f6_29.Focused, function() f11(f8_7, { Color = v29.Accent }) end)
        f12(f6_29.FocusLost, function() f11(f8_7, { Color = v29.Line }) end)

        if not P75.Finished then
          f12(f6_29:GetPropertyChangedSignal("Text"), function()
            if f6_29:IsFocused() then
              f27(f6_29.Text)
            end
          end)
        end

        v30.Options[p74] = v101
        return v101
      end

      function v54:AddButton(p81, p82)
        local text5, func

        if type(p81) == "table" then
          text5 = p81.Text
          func = p81.Func or p81.Callback
        else
          func = p82
          text5 = p81
        end

        local f19_7 = f19(32)

        local f6_30 = f6("TextButton", {
          Size = UDim2.fromScale(1, 1),
          BackgroundColor3 = v29.Raised,
          BorderSizePixel = 0,
          Font = Enum.Font.GothamBold,
          TextSize = 12,
          TextColor3 = v29.Text,
          Text = text5 or "Button",
          AutoButtonColor = false,
        }, f19_7)

        f7(f6_30, UDim_2)
        local f8_8 = f8(f6_30, v29.Line, 1)

        f12(f6_30.MouseEnter, function()
          f11(f6_30, { BackgroundColor3 = v29.AccentSoft })
          f11(f8_8, { Color = v29.Accent })
        end)

        f12(f6_30.MouseLeave, function()
          f11(f6_30, { BackgroundColor3 = v29.Raised })
          f11(f8_8, { Color = v29.Line })
        end)

        f12(f6_30.MouseButton1Click, function()
          f11(f6_30, { BackgroundColor3 = v29.Accent }, 0.08)
          task.delay(0.1, function() f11(f6_30, { BackgroundColor3 = v29.Raised }) end)

          if func then
            task.spawn(func)
          end
        end)

        local v106 = { Instance = f6_30 }

        function v106:SetText(text6)
          f6_30.Text = text6
        end

        return v106
      end

      function v54:AddDivider()
        local f19_8 = f19(9)

        local f6_31 = f6("Frame", {
          AnchorPoint = Vector2.new(0, 0.5),
          Position = UDim2.new(0, 0, 0.5, 0),
          Size = UDim2.new(1, 0, 0, 1),
          BackgroundColor3 = v29.LineSoft,
          BorderSizePixel = 0,
        }, f19_8)

        f7(f6_31, UDim_2)
        return { Instance = f6_31 }
      end

      function v54:AddLabel(p83, p84)
        local f19_9 = f19(0, true)

        local f6_32 = f6("TextLabel", {
          Size = UDim2.new(1, 0, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.SubText,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextWrapped = p84 and true or false,
          Text = p83 or "",
        }, f19_9)

        local v111 = { Instance = f6_32 }

        function v111:SetText(text7)
          f6_32.Text = text7
          return v111
        end

        function v111:AddKeyPicker(p85, p86)
          local P86 = p86
          P86 = P86 or {}

          f6_32.Size = UDim2.new(1, -66, 0, 0)

          local f6_33 = f6("TextButton", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.fromOffset(62, 22),
            BackgroundColor3 = v29.Sunken,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = v29.Accent,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = "",
            AutoButtonColor = false,
          }, f19_9)

          f7(f6_33, UDim_2)
          local f8_9 = f8(f6_33, v29.Line, 1)

          local v115 = {
            Value = P86.Default or "",
            Mode = P86.Mode or "Toggle",
            Type = "KeyPicker",
            Index = p85,
            Label = P86.Text or p83 or p85,
            NoUI = P86.NoUI and true or false,
            Active = false,
            Callbacks = {},
            Listening = false,
          }

          local function f28()
            f6_33.Text = v115.Listening and "..." or v115.Value ~= "" and v115.Value or "None"
            f11(f8_9, { Color = v115.Listening and v29.Accent or v29.Line })
          end

          function v115:SetValue(p87, p88)
            local P87 = p87

            if type(P87) == "table" then
              v115.Mode = P87[2] or v115.Mode
              P87 = P87[1]
            end

            v115.Value = tostring(P87 or "")
            f28()
            f16()

            if not p88 then
              for index19, value21 in ipairs(v115.Callbacks) do
                task.spawn(value21, v115.Value)
              end
            end
          end

          function v115.OnChanged(p89, p90)
            table.insert(v115.Callbacks, p90)
            return v115
          end

          function v115:GetState()
            return v115.Active
          end

          f12(f6_33.MouseButton1Click, function()
            v115.Listening = true
            f28()
          end)

          f12(userInputService.InputBegan, function(p91, p92)
            if v115.Listening then
              if p91.UserInputType == Enum.UserInputType.Keyboard then
                v115.Listening = false

                if p91.KeyCode == Enum.KeyCode.Backspace then
                  v115:SetValue("")
                else
                  v115:SetValue(p91.KeyCode.Name)
                end
              end

              return
            end

            if p92 or v115.Value == "" then
              return
            elseif userInputService:GetFocusedTextBox() then
              return
            elseif p91.UserInputType ~= Enum.UserInputType.Keyboard then
              return
            else
              if p91.KeyCode.Name ~= v115.Value then
                return
              end

              if v115.Mode == "Toggle" then
                v115.Active = not v115.Active
              else
                v115.Active = true
              end

              if P86.Callback then
                task.spawn(P86.Callback, v115.Active)
              end

              return
            end
          end)

          f12(userInputService.InputEnded, function(p93)
            if v115.Mode == "Hold" and p93.UserInputType == Enum.UserInputType.Keyboard
              and p93.KeyCode.Name == v115.Value then
              v115.Active = false

              if P86.Callback then
                task.spawn(P86.Callback, false)
              end
            end
          end)

          table.insert(v33, v115)
          v115:SetValue(P86.Default or "", true)
          v30.Options[p85] = v115
          return v115
        end

        return v111
      end

      return v54
    end

    local v117, v118, v119, v120, v121

    function v30:CreateWindow(p94)
      local v122 = p94 or {}

      v117 = f6("Frame", {
        Name = f13(),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(780, 550),
        BackgroundColor3 = v29.Shell,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
      }, f6_3)

      f7(v117, UDim.new(0, v30.CornerRadius), true)
      f8(v117, v29.Line, 1)
      local f6_34 = f6("UIScale", { Scale = 1 }, v117)

      local function f29()
        if not v118 then
          return
        else
          local AbsoluteSize = f6_3.AbsoluteSize

          if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            local CurrentCamera = workspace.CurrentCamera

            AbsoluteSize = CurrentCamera and CurrentCamera.ViewportSize
              or Vector2.new(1280, 720)
          end

          local MathMin = math.min(1, (AbsoluteSize.X - 24) / 780, (AbsoluteSize.Y - 24) / 550)
          v118.Scale = math.clamp(math.min(v30.DPI or 1, MathMin), 0.35, 2)
          return
        end
      end

      v118 = f6_34
      v30.Refit = f29
      f12(f6_3:GetPropertyChangedSignal("AbsoluteSize"), f29)
      task.defer(f29)

      f6(
        "UIGradient", { Rotation = 90, Color = ColorSequence.new(v29.ShellTop, v29.Shell) },
        v117
      )

      local f6_35 = f6(
        "Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1 }, v117
      )

      f17(f6_35, v117)

      local f6_36 = f6("ImageLabel", {
        Position = UDim2.fromOffset(18, 15),
        Size = UDim2.fromOffset(26, 26),
        BackgroundColor3 = v29.Raised,
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit,
        Image = v122.Icon and "rbxassetid://" .. tostring(v122.Icon) or "",
      }, f6_35)

      f7(f6_36, UDim_2)
      f8(f6_36, v29.Line, 1)

      f6("TextLabel", {
        Position = UDim2.fromOffset(54, 14),
        Size = UDim2.fromOffset(240, 16),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = v29.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = v122.Title or "Menu",
      }, f6_35)

      f6("TextLabel", {
        Position = UDim2.fromOffset(54, 31),
        Size = UDim2.fromOffset(300, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = v29.Faint,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = v122.Footer or "",
      }, f6_35)

      local f6_37 = f6("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(26, 26),
        BackgroundColor3 = v29.Raised,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = v29.SubText,
        Text = "X",
        AutoButtonColor = false,
      }, f6_35)

      f7(f6_37, UDim_2)
      local f8_10 = f8(f6_37, v29.Line, 1)

      f12(f6_37.MouseEnter, function()
        f11(f6_37, { BackgroundColor3 = v29.AccentSoft })
        f11(f8_10, { Color = v29.Accent })
      end)

      f12(f6_37.MouseLeave, function()
        f11(f6_37, { BackgroundColor3 = v29.Raised })
        f11(f8_10, { Color = v29.Line })
      end)

      f12(f6_37.MouseButton1Click, function() v117.Visible = false end)

      f6("Frame", {
        Position = UDim2.fromOffset(0, 56),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = v29.LineSoft,
        BorderSizePixel = 0,
      }, v117)

      v119 = f6("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 57),
        Size = UDim2.new(0, 170, 1, -57),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
      }, v117)

      f10(v119, 6)
      f9(v119, 14, 14, 14, 14)

      local f6_38 = f6("Frame", {
        Position = UDim2.fromOffset(170, 57),
        Size = UDim2.new(0, 1, 1, -57),
        BackgroundColor3 = v29.LineSoft,
        BorderSizePixel = 0,
      }, v117)

      v120 = f6("Frame", {
        Position = UDim2.fromOffset(171, 57),
        Size = UDim2.new(1, -171, 1, -57),
        BackgroundTransparency = 1,
      }, v117)

      local v130 = false
      local Size = v117.Size

      local f6_39 = f6("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -50, 0.5, 0),
        Size = UDim2.fromOffset(26, 26),
        BackgroundColor3 = v29.Raised,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = v29.SubText,
        Text = "-",
        AutoButtonColor = false,
      }, f6_35)

      f7(f6_39, UDim_2)
      local f8_11 = f8(f6_39, v29.Line, 1)

      f12(f6_39.MouseEnter, function()
        f11(f6_39, { BackgroundColor3 = v29.AccentSoft })
        f11(f8_11, { Color = v29.Accent })
      end)

      f12(f6_39.MouseLeave, function()
        f11(f6_39, { BackgroundColor3 = v29.Raised })
        f11(f8_11, { Color = v29.Line })
      end)

      local function f30(p95)
        v130 = p95 and true or false
        f6_39.Text = v130 and "+" or "-"

        if not v130 then
          v119.Visible = true
          f6_38.Visible = true
          v120.Visible = true
        end

        f11(
          v117, { Size = v130 and UDim2.new(Size.X.Scale, Size.X.Offset, 0, 56) or Size }, 0.22
        )

        if v130 then
          task.delay(0.24, function()
            if v130 then
              v119.Visible = false
              f6_38.Visible = false
              v120.Visible = false
            end
          end)
        end
      end

      f12(f6_39.MouseButton1Click, function() f30(not v130) end)

      local v133 = { Instance = v117 }

      function v133.SetMinimized(p96, p97)
        f30(p97)
      end

      function v133.IsMinimized(p98)
        return v130
      end

      function v133:AddTab(text8)
        local f6_40 = f6("TextButton", {
          Size = UDim2.new(1, 0, 0, 34),
          BackgroundColor3 = v29.Panel,
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Text = "",
          AutoButtonColor = false,
          LayoutOrder = #v34 + 1,
        }, v119)

        f7(f6_40, UDim_2)
        local f8_12 = f8(f6_40, v29.Line, 1, 1)

        local f6_41 = f6("Frame", {
          AnchorPoint = Vector2.new(0, 0.5),
          Position = UDim2.new(0, 11, 0.5, 0),
          Size = UDim2.fromOffset(3, 0),
          BackgroundColor3 = v29.Accent,
          BorderSizePixel = 0,
        }, f6_40)

        f7(f6_41, UDim_2)

        local f6_42 = f6("TextLabel", {
          Position = UDim2.fromOffset(24, 0),
          Size = UDim2.new(1, -34, 1, 0),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamMedium,
          TextSize = 12,
          TextColor3 = v29.SubText,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextTruncate = Enum.TextTruncate.AtEnd,
          Text = text8,
        }, f6_40)

        local f6_43 = f6("Frame", {
          Size = UDim2.fromScale(1, 1),
          BackgroundTransparency = 1,
          Visible = false,
        }, v120)

        f9(f6_43, 14, 14, 14, 0)

        local f6_44 = f6("ScrollingFrame", {
          Size = UDim2.new(0.5, -7, 1, 0),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          CanvasSize = UDim2.new(),
          AutomaticCanvasSize = Enum.AutomaticSize.Y,
          ScrollBarThickness = 2,
          ScrollBarImageColor3 = v29.Line,
          ScrollingDirection = Enum.ScrollingDirection.Y,
        }, f6_43)

        f10(f6_44, 12)
        f9(f6_44, 2, 8, 2, 16)

        local f6_45 = f6("ScrollingFrame", {
          Position = UDim2.new(0.5, 7, 0, 0),
          Size = UDim2.new(0.5, -7, 1, 0),
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          CanvasSize = UDim2.new(),
          AutomaticCanvasSize = Enum.AutomaticSize.Y,
          ScrollBarThickness = 2,
          ScrollBarImageColor3 = v29.Line,
          ScrollingDirection = Enum.ScrollingDirection.Y,
        }, f6_43)

        f10(f6_45, 12)
        f9(f6_45, 2, 8, 2, 16)

        local v141 = {
          Page = f6_43,
          Left = f6_44,
          Right = f6_45,
          Button = f6_40,
        }

        function v141:Select()
          for index20, value22 in ipairs(v34) do
            value22.Page.Visible = false

            f11(value22.Button, { BackgroundTransparency = 1 })
            f11(value22.Edge, { Transparency = 1 })
            f11(value22.Label, { TextColor3 = v29.SubText })
            f11(value22.Mark, { Size = UDim2.fromOffset(3, 0) })
          end

          f6_43.Visible = true

          f11(f6_40, { BackgroundTransparency = 0.86, BackgroundColor3 = v29.Accent })
          f11(f8_12, { Transparency = 0.45, Color = v29.Accent })
          f11(f6_42, { TextColor3 = v29.Text })
          f11(f6_41, { Size = UDim2.fromOffset(3, 16) })

          v121 = v141
        end

        local function f31(p99, p100)
          local f6_46 = f6("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = v29.Panel,
            BorderSizePixel = 0,
            LayoutOrder = #p99:GetChildren(),
          }, p99)

          f7(f6_46, UDim.new(0, v30.CornerRadius), true)
          f8(f6_46, v29.LineSoft, 1)
          f9(f6_46, 14, 14, 12, 14)

          local f6_47 = f6("Frame", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            LayoutOrder = 0,
          }, f6_46)

          f7(f6("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(3, 13),
            BackgroundColor3 = v29.Accent,
            BorderSizePixel = 0,
          }, f6_47), UDim_2)

          f6("TextLabel", {
            Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -12, 1, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = v29.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = p100 or "",
          }, f6_47)

          local f6_48 = f6("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
          }, f6_46)

          f10(f6_48, 9)
          f9(f6_48, 0, 0, 8, 0)
          f10(f6_46, 0)
          return f18(f6_48)
        end

        function v141:AddLeftGroupbox(p101)
          return f31(f6_44, p101)
        end

        function v141:AddRightGroupbox(p102)
          return f31(f6_45, p102)
        end

        f12(f6_40.MouseButton1Click, function() v141:Select() end)

        f12(f6_40.MouseEnter, function()
          if v121 ~= v141 then
            f11(f6_40, { BackgroundTransparency = 0.92, BackgroundColor3 = v29.Text })
          end
        end)

        f12(f6_40.MouseLeave, function()
          if v121 ~= v141 then
            f11(f6_40, { BackgroundTransparency = 1 })
          end
        end)

        table.insert(v34, {
          Page = f6_43,
          Button = f6_40,
          Edge = f8_12,
          Label = f6_42,
          Mark = f6_41,
        })

        if #v34 == 1 then
          v141:Select()
        end

        return v141
      end

      function v133:SetCornerRadius(p103)
        v30.CornerRadius = p103

        for index21, value23 in ipairs(v32) do
          value23.CornerRadius = UDim.new(0, p103)
        end
      end

      function v133.Toggle(p104)
        v117.Visible = not v117.Visible
      end

      v30.Window = v133
      v30:SetNotifySide(v122.NotifySide or "Right")

      v117.Visible = true
      v117.Size = UDim2.fromOffset(780, 490)

      f11(v117, { Size = UDim2.fromOffset(780, 550) }, 0.28)
      return v133
    end

    f12(userInputService.InputBegan, function(p105, p106)
      if p106 or v30.Unloaded or not v117 then
        return
      elseif p105.UserInputType ~= Enum.UserInputType.Keyboard then
        return
      elseif userInputService:GetFocusedTextBox() then
        return
      else
        local DefaultToggleKey = v30.ToggleKeybind and v30.ToggleKeybind.Value or v30.DefaultToggleKey

        if DefaultToggleKey ~= "" and p105.KeyCode.Name == DefaultToggleKey then
          -- The old window is retained for legacy callbacks, but must never be shown.
          v117.Visible = false
          -- The dedicated RightShift handler below controls the Gen2 window.
        end

        return
      end
    end)

    function v30:SetDPIScale(p107)
      v30.DPI = math.clamp((tonumber(p107) or 100) / 100, 0.5, 2)

      if v30.Refit then
        v30.Refit()
      elseif v118 then
        v118.Scale = v30.DPI
      end
    end

    function v30:Unload()
      v30.Unloaded = true

      for index22, value25 in ipairs(v31) do
      end

      v31 = {}
      f6_3:Destroy()
    end

    local function f32()
      local RawValue_2 = rawget(_G, "writefile") or writefile
      local RawValue_3 = rawget(_G, "readfile") or readfile
      local RawValue_4 = rawget(_G, "listfiles") or listfiles
      local RawValue_5 = rawget(_G, "isfile") or isfile
      local RawValue_6 = rawget(_G, "isfolder") or isfolder
      local RawValue_7 = rawget(_G, "makefolder") or makefolder
      local RawValue_8 = rawget(_G, "delfile") or delfile

      if type(RawValue_2) ~= "function" or type(RawValue_3) ~= "function" or type(RawValue_4) ~= "function" then
        return nil
      end

      return {
        write = RawValue_2,
        read = RawValue_3,
        list = RawValue_4,
        exists = RawValue_5,
        folder = RawValue_6,
        mkdir = RawValue_7,
        remove = RawValue_8,
      }
    end

    function v30:SetConfigFolder(p108)
      v35 = p108
    end

    local function f33(p109)
      if p109.folder and p109.mkdir then
        if not p109.folder(v35) then
          p109.mkdir(v35)
        end

        if not p109.folder(v35 .. "/configs") then
          p109.mkdir(v35 .. "/configs")
        end
      end
    end

    local function f34()
      local v152 = { toggles = {}, options = {} }

      for key3, value26 in pairs(v30.Toggles) do
        v152.toggles[key3] = value26.Value
      end

      for key4, value27 in pairs(v30.Options) do
        if value27.Type == "KeyPicker" then
          v152.options[key4] = { value27.Value, value27.Mode }
        else
          v152.options[key4] = value27.Value
        end
      end

      return v152
    end

    local function f35(p110)
      for key5, value28 in pairs(p110.toggles or {}) do
        local Toggles = v30.Toggles[key5]

        if Toggles then
          Toggles:SetValue(value28)
        end
      end

      for key6, value29 in pairs(p110.options or {}) do
        local Options = v30.Options[key6]

        if Options and Options.SetValue then
          Options:SetValue(value29)
        end
      end
    end

    function v30:SaveConfig(p111)
      local f32_2 = f32()

      if not f32_2 or not p111 or p111 == "" then
        return false
      else
        f33(f32_2)
        local v156, v157 = pcall(httpService.JSONEncode, httpService, f34())

        if not v156 then
          return false
        end

        return pcall(f32_2.write, v35 .. "/configs/" .. p111 .. ".json", v157)
      end
    end

    function v30:LoadConfig(p112)
      local f32_3 = f32()

      if not f32_3 or not p112 or p112 == "" then
        return false
      else
        local v159, v160 = pcall(f32_3.read, v35 .. "/configs/" .. p112 .. ".json")

        if not v159 or type(v160) ~= "string" then
          return false
        else
          local v161, v162 = pcall(httpService.JSONDecode, httpService, v160)

          if not v161 or type(v162) ~= "table" then
            return false
          end

          f35(v162)
          return true
        end
      end
    end

    function v30:ListConfigs()
      local v163 = {}
      local f32_4 = f32()

      if not f32_4 then
        return v163
      else
        f33(f32_4)
        local v165, v166 = pcall(f32_4.list, v35 .. "/configs")

        if not v165 or type(v166) ~= "table" then
          return v163
        end

        for index23, value30 in ipairs(v166) do
          local StringMatch = string.match(value30, "([^/\\]+)%.json$")

          if StringMatch then
            table.insert(v163, StringMatch)
          end
        end

        return v163
      end
    end

    function v30:LoadAutoloadConfig()
      local f32_5 = f32()

      if not f32_5 then
        return
      else
        local v169, v170 = pcall(f32_5.read, v35 .. "/autoload.txt")

        if v169 and type(v170) == "string" and v170 ~= "" then
          v30:LoadConfig(v170)
        end

        return
      end
    end

    function v30:BuildConfigSection(p113)
      local AddRightGroupbox = p113:AddRightGroupbox("Configuration")
      local f32_6 = f32()
      local addInput, addDropdown, addLabel

      if not f32_6 then
        AddRightGroupbox:AddLabel("This executor has no file API, configs are off", true)
        return AddRightGroupbox
      else
        addInput = AddRightGroupbox:AddInput("ConfigName", {
          Default = "",
          Text = "Config name",
          Placeholder = "default",
        })

        addDropdown = AddRightGroupbox:AddDropdown("ConfigList", {
          Values = v30:ListConfigs(),
          Default = nil,
          Text = "Saved configs",
        })

        AddRightGroupbox:AddButton({
          Text = "Create",
          Func = function()
            if v30:SaveConfig(addInput.Value) then
              addDropdown:SetValues(v30:ListConfigs())
              v30:Notify("Saved config " .. addInput.Value)
            end
          end,
        })

        AddRightGroupbox:AddButton({
          Text = "Load",
          Func = function()
            if addDropdown.Value and v30:LoadConfig(addDropdown.Value) then
              v30:Notify("Loaded config " .. addDropdown.Value)
            end
          end,
        })

        AddRightGroupbox:AddButton({
          Text = "Overwrite",
          Func = function()
            if addDropdown.Value and v30:SaveConfig(addDropdown.Value) then
              v30:Notify("Overwrote config " .. addDropdown.Value)
            end
          end,
        })

        AddRightGroupbox:AddButton({
          Text = "Delete",
          Func = function()
            if addDropdown.Value and f32_6.remove then
              pcall(f32_6.remove, v35 .. "/configs/" .. addDropdown.Value .. ".json")

              addDropdown:SetValues(v30:ListConfigs())
              addDropdown:SetValue(nil, true)

              v30:Notify("Deleted config")
            end
          end,
        })

        AddRightGroupbox:AddButton({
          Text = "Refresh list",
          Func = function() addDropdown:SetValues(v30:ListConfigs()) end,
        })

        addLabel = AddRightGroupbox:AddLabel("Autoload: none", true)

        AddRightGroupbox:AddButton({
          Text = "Set as autoload",
          Func = function()
            if addDropdown.Value then
              pcall(f32_6.write, v35 .. "/autoload.txt", addDropdown.Value)
              addLabel:SetText("Autoload: " .. addDropdown.Value)
            end
          end,
        })

        AddRightGroupbox:AddButton({
          Text = "Clear autoload",
          Func = function()
            pcall(f32_6.write, v35 .. "/autoload.txt", "")
            addLabel:SetText("Autoload: none")
          end,
        })

        local v172, v173 = pcall(f32_6.read, v35 .. "/autoload.txt")

        if v172 and type(v173) == "string" and v173 ~= "" then
          addLabel:SetText("Autoload: " .. v173)
        end

        return AddRightGroupbox
      end
    end

    return v30
  end

  v174 = f5()
end

do
  local LOCOPANI_SESSION = (type(getgenv) == "function" and getgenv() or _G).LOCOPANI_SESSION

  if type(LOCOPANI_SESSION) == "table" then
    LOCOPANI_SESSION.ui = v174
  end

  options = v174.Options
  toggles = v174.Toggles

  v174.ForceCheckbox = false
  v174.ShowToggleFrameInKeybinds = true

  localPlayer2 = players.LocalPlayer
  currentCamera2 = workspaceService.CurrentCamera
  v175 = require(replicatedFirst.Controllers.AnimationController)

  v176 = string.char(math.random(97, 122), math.random(97, 122), math.random(97, 122))
    .. tostring(math.random(100000, 999999))

  v177 = string.char(math.random(97, 122), math.random(97, 122), math.random(97, 122))
    .. tostring(math.random(100000, 999999))

  local LOCOPANI_SESSION_2 = (type(getgenv) == "function" and getgenv() or _G).LOCOPANI_SESSION

  if type(LOCOPANI_SESSION_2) == "table" and type(LOCOPANI_SESSION_2.tags) == "table" then
    table.insert(LOCOPANI_SESSION_2.tags, v176)
    table.insert(LOCOPANI_SESSION_2.tags, v177)
  end
end

local function f36(p114)
  local LOCOPANI_SESSION_3 = (type(getgenv) == "function" and getgenv() or _G).LOCOPANI_SESSION

  if type(LOCOPANI_SESSION_3) == "table" and type(LOCOPANI_SESSION_3.links) == "table" then
    table.insert(LOCOPANI_SESSION_3.links, p114)
  end

  return p114
end

v178 = false
v179 = 5
local Color3_2 = Color3.fromRGB(0, 0, 255)

local function f37()
  for index24, value31 in ipairs(workspaceService:GetChildren()) do
    if value31:IsA("Model") and value31.Name:match("^CLIENT_BALL_%d+$") then
      local LOCOPANIBALL = value31:FindFirstChild("LOCOPANI.BALL")

      if LOCOPANIBALL then
        LOCOPANIBALL:Destroy()
      end
    end
  end
end

local function f38(p115)
  for index25, value32 in ipairs(p115:GetDescendants()) do
    if value32:IsA("BasePart") then
      return value32
    end
  end

  return nil
end

local Color = Color3_2
local transparency = 0.3

local function f39(p116)
  if not v178 then
    return
  end

  for index26, value33 in ipairs(workspaceService:GetChildren()) do
    if value33:IsA("Model") and value33.Name:match("^CLIENT_BALL_%d+$") then
      local LOCOPANIBALL2 = value33:FindFirstChild("LOCOPANI.BALL")

      if not LOCOPANIBALL2 then
        local f38_2 = f38(value33)

        if f38_2 then
          local Part = Instance.new("Part")
          Part.Name = "LOCOPANI.BALL"
          Part.Shape = Enum.PartType.Ball
          Part.Size = Vector3.new(2, 2, 2) * p116
          Part.CFrame = f38_2.CFrame
          Part.Anchored = true
          Part.CanCollide = false
          Part.Transparency = transparency
          Part.Material = Enum.Material.ForceField
          Part.Color = Color
          Part.Parent = value33
        end
      else
        LOCOPANIBALL2.Size = Vector3.new(2, 2, 2) * p116
        LOCOPANIBALL2.Color = Color
        LOCOPANIBALL2.Transparency = transparency
      end
    end
  end
end

do
  local function f40()
    if not v178 then
      return
    end

    for index27, value34 in ipairs(workspaceService:GetChildren()) do
      if value34:IsA("Model") and value34.Name:match("^CLIENT_BALL_%d+$") then
        local LOCOPANIBALL4 = value34:FindFirstChild("LOCOPANI.BALL")
        local f38_3 = f38(value34)

        if LOCOPANIBALL4 and f38_3 then
          LOCOPANIBALL4.CFrame = f38_3.CFrame
        end
      end
    end
  end

  workspaceService.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child.Name:match("^CLIENT_BALL_%d+$") then
      task.wait(0.1)

      if v178 then
        f39(v179)
      end
    end
  end)

  runService.RenderStepped:Connect(function() f40() end)

  function enableHitbox()
    v178 = true
    f39(v179)
  end

  function disableHitbox()
    v178 = false
    f37()
  end

  function isHitboxEnabled()
    return v178
  end

  function setHitboxScale(p117)
    v179 = p117 or 5

    if v178 then
      f39(v179)
    end
  end

  function getHitboxScale()
    return v179
  end

  function setHitboxColor(p118)
    Color = p118 or Color3.fromRGB(0, 0, 255)

    if v178 then
      f39(v179)
    end
  end

  function setHitboxTransparency(p119)
    transparency = p119 or 0.3

    if v178 then
      f39(v179)
    end
  end

  _G.enableHitbox = enableHitbox
  _G.disableHitbox = disableHitbox
end

_G.isHitboxEnabled = isHitboxEnabled
_G.setHitboxScale = setHitboxScale
_G.getHitboxScale = getHitboxScale
_G.setHitboxColor = setHitboxColor
_G.setHitboxTransparency = setHitboxTransparency

v182 = false
v183 = false
v184 = false
v185 = false
v186 = false
v187 = false
v188 = false
v189 = false
v190 = false
v191 = false
v192 = false
v193 = false
v194 = {}
v195 = {}
v196 = false
v197 = false
v198 = false
v199 = false
v200 = 16
v201 = false
v202 = false
scoreEffect = "SupernovaScoreEffect"
v203 = false
v204 = false
v205 = {}
v206 = false
v207 = "UltimateChampionPlayerCard"
v208 = false
v209 = false
v210 = {}
jersey = "DragonTuxedoJersey"
v211 = {}
ball = "ClassicBall"
v212 = {}
v213 = false
v214 = false
v215 = {}
v216 = {}
v217 = "Normal"
v218 = "Normal"
v219 = false
v220 = false
v221 = false

do
  v222 = false
  v223 = false
  v224 = false
  v225 = false
  v226 = {}
  v227 = {}
  v228 = {}
  v229 = {}

  local v230 = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 165, 0), Color3.fromRGB(128, 0, 128), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(139, 0, 0), Color3.fromRGB(0, 100, 0),
  }

  v231 = {}
  ballService = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService
  serve = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.GameService.RF.Serve
end

effects = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RE.Effects
doMove = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RE.DoMove
stopAllEmotes = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.AnimationService.RE.StopAllEmotes
effect = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.GameService.RE.Effect

local v232 = {
  NameTag = "LOCOPANI PROTECTION",
  Title = "<font color='#FF0000'><b>Pro</b></font>",
  NotifConn = nil,
  NotifConn2 = nil,
  CardLoopConn = nil,
  CharWatcher = nil,
  Enabled = true,
}

local function f41()
  if not v232.Enabled then
    return
  end

  if localPlayer2 and localPlayer2.Character then
    local Nametag = localPlayer2.Character:FindFirstChild("Nametag")

    if Nametag then
      local PlayerName = Nametag:FindFirstChild("PlayerName")

      if PlayerName and PlayerName:IsA("TextLabel") then
        PlayerName.Text = v232.NameTag
      end
    end
  end
end

local function f42()
  if not v232.Enabled then
    return
  end

  if localPlayer2 then
    localPlayer2:SetAttribute("User_Title", v232.Title)
  end
end

local function f43()
  if v232.CardLoopConn then
    v232.CardLoopConn:Disconnect()
    v232.CardLoopConn = nil
  end
end

local f44

local function f45()
  if v232.NotifConn then
    v232.NotifConn:Disconnect()
    v232.NotifConn = nil
  end

  if v232.NotifConn2 then
    v232.NotifConn2:Disconnect()
    v232.NotifConn2 = nil
  end

  if not v232.Enabled then
    return
  elseif not localPlayer2 then
    return
  else
    local Interface = localPlayer2.PlayerGui:FindFirstChild("Interface")

    if Interface then
      Interface = Interface:FindFirstChild("Persistent")

      if Interface then
        Interface = Interface:FindFirstChild("Notifications")
      end
    end

    if not Interface then
      return
    end

    for index28, value35 in ipairs(Interface:GetChildren()) do
      f44(value35)
    end

    v232.NotifConn = Interface.ChildAdded:Connect(function(child2) f44(child2) end)

    v232.NotifConn2 = Interface.DescendantAdded:Connect(function(descendant)
      if descendant:IsA("TextLabel") then
        if not v232.Enabled or not localPlayer2 then
          return
        end

        -- Nunca deixe o protetor antigo substituir o nome do Custom Protect.
        if _G.CustomProtect and _G.CustomProtect.Enabled then
          return
        end

        local text9 = descendant.Text or ""
        if string.find(text9, localPlayer2.Name, 1, true) then
          descendant.Text = string.gsub(text9, localPlayer2.Name, function()
            return v232.NameTag
          end)
        end
      end
    end)

    return
  end
end

function f44(p120)
  -- Quando o Custom Protect estiver ativo, deixe a legenda usar o nome personalizado.
  if _G.CustomProtect and _G.CustomProtect.Enabled then
    return
  end
  if not v232.Enabled then
    return
  elseif not p120 then
    return
  elseif not localPlayer2 then
    return
  else
    local TextLabel = p120:FindFirstChild("TextLabel")

    if not TextLabel then
      for index29, value36 in ipairs(p120:GetDescendants()) do
        if value36:IsA("TextLabel") then
          TextLabel = value36
          break
        end
      end
    end

    if not TextLabel then
      return
    else
      local text10 = TextLabel.Text or ""

      if string.find(text10, localPlayer2.Name) then
        TextLabel.Text = string.gsub(text10, localPlayer2.Name, v232.NameTag)
      end

      return
    end
  end
end

local function f46()
  -- O protetor antigo não deve sobrescrever o nome personalizado do Custom Protect.
  if _G.CustomProtect and _G.CustomProtect.Enabled then
    return
  end
  if not v232.Enabled then
    return
  else
    local StringUpper = string.upper(localPlayer2.Name)
    local Interface_2 = localPlayer2.PlayerGui:FindFirstChild("Interface")

    if Interface_2 then
      local Persistent = Interface_2:FindFirstChild("Persistent")

      if Persistent then
        for index30, value37 in ipairs(Persistent:GetChildren()) do
          if value37.Name == "FlashPlayerCardFrame" then
            local Username = value37:FindFirstChild("Username", true)

            if Username and Username:IsA("TextLabel") then
              local StringUpper_2 = string.upper(Username.Text or "")

              if string.find(StringUpper_2, StringUpper) then
                Username.Text = v232.NameTag
              end
            end
          end
        end
      end
    end

    return
  end
end

local function f47()
  if v232.CardLoopConn then
    v232.CardLoopConn:Disconnect()
    v232.CardLoopConn = nil
  end

  if not v232.Enabled then
    return
  end

  v232.CardLoopConn = runService.Heartbeat:Connect(function() f46() end)
end

local f48

local function f49(p121)
  v232.Enabled = p121 and true or false

  if p121 then
    f41()
    f42()
    f45()
    f47()
    f48()
    f46()
  else
    if v232.NotifConn then
      v232.NotifConn:Disconnect()
      v232.NotifConn = nil
    end

    if v232.NotifConn2 then
      v232.NotifConn2:Disconnect()
      v232.NotifConn2 = nil
    end

    if v232.CharWatcher then
      v232.CharWatcher:Disconnect()
      v232.CharWatcher = nil
    end

    f43()

    if localPlayer2.Character then
      local Nametag_2 = localPlayer2.Character:FindFirstChild("Nametag")

      if Nametag_2 then
        local PlayerName_2 = Nametag_2:FindFirstChild("PlayerName")

        if PlayerName_2 and PlayerName_2:IsA("TextLabel") then
          PlayerName_2.Text = localPlayer2.Name
        end
      end
    end

    localPlayer2:SetAttribute("User_Title", "")
  end
end

function f48()
  if v232.CharWatcher then
    v232.CharWatcher:Disconnect()
    v232.CharWatcher = nil
  end

  if not v232.Enabled then
    return
  end

  v232.CharWatcher = localPlayer2.CharacterAdded:Connect(function()
    task.wait(0.5)
    f41()
    f42()
    f45()
  end)
end

f41()
f42()
f45()
f47()
f48()
f46()

_G.Protect = {
  Toggle = f49,
  Update = function()
    f41()
    f42()
    f46()
  end,
  SetName = function(nameTag) v232.NameTag = nameTag end,
  SetTitle = function(title) v232.Title = title end,
  IsEnabled = function() return v232.Enabled end,
}

_G.LOCOPANI = {
  Enable = function() f49(true) end,
  Disable = function() f49(false) end,
  SetNameTag = function(nameTag2)
    v232.NameTag = nameTag2
    f41()
  end,
  SetTitle = function(title2)
    v232.Title = title2
    f42()
  end,
  IsEnabled = function() return v232.Enabled end,
}

v235 = {
  Enabled = false,
  Name = "CUSTOM NAME",
  Title = "<font color='#00FF00'><b>Custom</b></font>",
  NotifConn = nil,
  NotifConn2 = nil,
  CardLoopConn = nil,
  CharWatcher = nil,
}

function v235.updateNametag()
  if not v235.Enabled then
    return
  end

  if localPlayer2 and localPlayer2.Character then
    local Nametag_3 = localPlayer2.Character:FindFirstChild("Nametag")

    if Nametag_3 then
      local PlayerName_3 = Nametag_3:FindFirstChild("PlayerName")

      if PlayerName_3 and PlayerName_3:IsA("TextLabel") then
        PlayerName_3.Text = v235.Name
      end
    end
  end
end

function v235.updateTitle()
  if not v235.Enabled then
    return
  end

  if localPlayer2 then
    localPlayer2:SetAttribute("User_Title", v235.Title)
  end
end

v235.TextWatchers = v235.TextWatchers or {}

function v235.replaceLegendName(label)
  if not v235.Enabled or not localPlayer2 or not label
    or not label:IsA("TextLabel") then
    return
  end

  local text = label.Text or ""
  local playerName = localPlayer2.Name
  local customName = tostring(v235.Name or "CUSTOM NAME")
  local oldProtectName = tostring(v232 and v232.NameTag or "LOCOPANI PROTECTION")

  if text == "" then
    return
  end

  -- O listener do protetor antigo pode ter trocado o nome primeiro.
  -- Substituímos tanto o username real quanto o nome padrão antigo.
  if playerName ~= "" and string.find(text, playerName, 1, true) then
    text = string.gsub(text, playerName, function()
      return customName
    end)
  end

  if oldProtectName ~= "" and string.find(text, oldProtectName, 1, true) then
    text = string.gsub(text, oldProtectName, function()
      return customName
    end)
  end

  -- Compatibilidade com textos já alterados para o nome padrão antigo.
  if string.find(text, "LOCOPANI PROTECT", 1, true) then
    text = string.gsub(text, "LOCOPANI PROTECT", function()
      return customName
    end)
  end

  if label.Text ~= text then
    label.Text = text
  end
end

function v235.watchLegendLabel(label)
  if not label or not label:IsA("TextLabel") then
    return
  end

  -- Process immediately, and again whenever the game updates the label's text.
  v235.replaceLegendName(label)

  if v235.TextWatchers[label] then
    return
  end

  local ok, connection = pcall(function()
    return label:GetPropertyChangedSignal("Text"):Connect(function()
      v235.replaceLegendName(label)
    end)
  end)

  if ok and connection then
    v235.TextWatchers[label] = connection
  end
end

function v235.processNotification(item)
  if not v235.Enabled or not item then
    return
  end

  if item:IsA("TextLabel") then
    v235.watchLegendLabel(item)
  end

  for _, descendant in ipairs(item:GetDescendants()) do
    if descendant:IsA("TextLabel") then
      v235.watchLegendLabel(descendant)
    end
  end
end

function v235.setupNotifications()
  if v235.NotifConn then
    v235.NotifConn:Disconnect()
    v235.NotifConn = nil
  end

  if v235.NotifConn2 then
    v235.NotifConn2:Disconnect()
    v235.NotifConn2 = nil
  end

  -- Remove text-change listeners from the previous interface.
  for label, connection in pairs(v235.TextWatchers) do
    if connection then
      pcall(function() connection:Disconnect() end)
    end
    v235.TextWatchers[label] = nil
  end

  if not v235.Enabled or not localPlayer2 then
    return
  end

  local playerGui = localPlayer2:FindFirstChildOfClass("PlayerGui")
  local interface = playerGui and playerGui:FindFirstChild("Interface")
  if not interface then
    return
  end

  -- Watch the whole Interface, not only Persistent/Notifications:
  -- score announcements/legend labels may be created elsewhere.
  v235.processNotification(interface)

  v235.NotifConn = interface.DescendantAdded:Connect(function(descendant)
    if not v235.Enabled then
      return
    end

    if descendant:IsA("TextLabel") then
      v235.watchLegendLabel(descendant)
    else
      v235.processNotification(descendant)
    end
  end)

  -- Also catch labels directly parented to Interface.
  v235.NotifConn2 = interface.ChildAdded:Connect(function(child)
    v235.processNotification(child)
  end)
end

function v235.protectPlayerCard()
  if not v235.Enabled then
    return
  else
    local StringUpper_3 = string.upper(localPlayer2.Name)
    local Interface_4 = localPlayer2.PlayerGui:FindFirstChild("Interface")

    if Interface_4 then
      local Persistent_2 = Interface_4:FindFirstChild("Persistent")

      if Persistent_2 then
        for index33, value40 in ipairs(Persistent_2:GetChildren()) do
          if value40.Name == "FlashPlayerCardFrame" then
            local Username_2 = value40:FindFirstChild("Username", true)

            if Username_2 and Username_2:IsA("TextLabel") then
              local StringUpper_4 = string.upper(Username_2.Text or "")

              if string.find(StringUpper_4, StringUpper_3) then
                Username_2.Text = v235.Name
              end
            end
          end
        end
      end
    end

    return
  end
end

function v235.startCardLoop()
  if v235.CardLoopConn then
    v235.CardLoopConn:Disconnect()
    v235.CardLoopConn = nil
  end

  if not v235.Enabled then
    return
  end

  v235.CardLoopConn = runService.Heartbeat:Connect(function() v235.protectPlayerCard() end)
end

function v235.stopCardLoop()
  if v235.CardLoopConn then
    v235.CardLoopConn:Disconnect()
    v235.CardLoopConn = nil
  end
end

function v235.installCharacterWatcher()
  if v235.CharWatcher then
    v235.CharWatcher:Disconnect()
    v235.CharWatcher = nil
  end

  if not v235.Enabled then
    return
  end

  v235.CharWatcher = localPlayer2.CharacterAdded:Connect(function()
    task.wait(0.5)

    v235.updateNametag()
    v235.updateTitle()
    v235.setupNotifications()
  end)
end

function v235.toggle(p123)
  v235.Enabled = p123 and true or false

  if p123 then
    v235.updateNametag()
    v235.updateTitle()
    v235.setupNotifications()
    v235.startCardLoop()
    v235.installCharacterWatcher()
    v235.protectPlayerCard()
  else
    if v235.NotifConn then
      v235.NotifConn:Disconnect()
      v235.NotifConn = nil
    end

    if v235.NotifConn2 then
      v235.NotifConn2:Disconnect()
      v235.NotifConn2 = nil
    end

    if v235.CharWatcher then
      v235.CharWatcher:Disconnect()
      v235.CharWatcher = nil
    end

    v235.stopCardLoop()

    for label, connection in pairs(v235.TextWatchers or {}) do
      if connection then
        pcall(function() connection:Disconnect() end)
      end
      v235.TextWatchers[label] = nil
    end

    if localPlayer2.Character then
      local Nametag_4 = localPlayer2.Character:FindFirstChild("Nametag")

      if Nametag_4 then
        local PlayerName_4 = Nametag_4:FindFirstChild("PlayerName")

        if PlayerName_4 and PlayerName_4:IsA("TextLabel") then
          PlayerName_4.Text = localPlayer2.Name
        end
      end
    end

    localPlayer2:SetAttribute("User_Title", "")
  end
end

function v235.setName(p124)
  v235.Name = p124 or "CUSTOM NAME"

  if v235.Enabled then
    v235.updateNametag()
    v235.protectPlayerCard()
  end
end

function v235.setTitle(p125)
  v235.Title = p125 or ""

  if v235.Enabled then
    v235.updateTitle()
  end
end

_G.CustomProtect = v235
v238 = { EffectEnabled = false, CardEnabled = false, BallEnabled = false }

do
  local function f51()
    local f50_2 = f50("Ball")

    if f50_2 then
      ball = f50_2

      if v220 then
        sweep()
      end

      v174:Notify("Random Ball: " .. f50_2)
    end
  end

  local function f52()
    local f50_3 = f50("ScoreEffect")

    if f50_3 then
      scoreEffect = f50_3

      if v202 then
        disableHitEffect()
        task.wait(0.1)
        enableHitEffect()
      end

      v174:Notify("Random Effect: " .. f50_3)
    end
  end

  function f50(p126)
    local findFirstChild3

    if type(p126) == "string" then
      findFirstChild3 = replicatedStorage.Assets:FindFirstChild(p126)

      if not findFirstChild3 then
        findFirstChild3 = replicatedStorage:FindFirstChild(p126)
      end

      if not findFirstChild3 then
        findFirstChild3 = replicatedStorage.Content:FindFirstChild(p126)
      end
    end

    if not findFirstChild3 then
      return nil
    else
      local v239 = {}

      for index34, value41 in ipairs(findFirstChild3:GetChildren()) do
        if value41:IsA("ModuleScript") or value41:IsA("Model") or value41:IsA("Folder") then
          table.insert(v239, value41.Name)
        end
      end

      if #v239 == 0 then
        return nil
      end

      return v239[math.random(1, #v239)]
    end
  end

  local function f53(p127)
    if not v238.EffectEnabled then
      return
    end

    if p127.Name == "HitIndicator" then
      f52()
    end
  end

  local function f54(p128)
    if not v238.BallEnabled then
      return
    end

    if p128:IsA("Model") and p128.Name:match("^CLIENT_BALL_") then
      task.wait(0.1)
      f51()
    end
  end

  workspace.ChildAdded:Connect(function(child4) f54(child4) end)
  workspace.DescendantAdded:Connect(function(descendant3) f53(descendant3) end)

  task.wait(1)

  for index35, value42 in ipairs(workspace:GetChildren()) do
    f54(value42)
  end

  for index36, value43 in ipairs(workspace:GetDescendants()) do
    f53(value43)
  end
end

local f55

local function f56()
  if v209 then
    return
  end

  if not v206 and not v238.CardEnabled then
    return
  else
    local Interface_5 = localPlayer2.PlayerGui:FindFirstChild("Interface")

    if Interface_5 then
      local Persistent_3 = Interface_5:FindFirstChild("Persistent")

      if Persistent_3 then
        for index37, value44 in ipairs(Persistent_3:GetChildren()) do
          if value44.Name == "FlashPlayerCardFrame" then
            local Username_3 = value44:FindFirstChild("Username", true)

            if Username_3 and Username_3:IsA("TextLabel") then
              local StringUpper_5 = string.upper(Username_3.Text or "")
              local StringUpper_6 = string.upper(localPlayer2.Name)

              if string.find(StringUpper_5, StringUpper_6) then
                if v228.__cardFiredFor == value44 then
                  return
                end

                if v238.CardEnabled then
                  local f50_4 = f50("PlayerCard")

                  if f50_4 then
                    v207 = f50_4
                    v174:Notify("Random Card: " .. f50_4)
                  end
                end

                v228.__cardFiredFor = value44
                value44:Destroy()
                task.wait(0.1)
                f55()
              end
            end
          end
        end

        return
      end

      return
    end

    return
  end
end

function f55()
  if v208 or v209 then
    return
  else
    local OnFlashCard = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PlayerCardService.RE.OnFlashCard

    if OnFlashCard and firesignal then
      v209 = true
      v208 = true

      firesignal(OnFlashCard.OnClientEvent, {
        PlayerCardItemId = v207,
        Context = { Custom = {}, PlacementId = "ScoredPoint" },
        Player = localPlayer2,
      })

      task.wait(0.3)
      v208 = false
      v209 = false
    end

    return
  end
end

local connect2
local playerCardGuiConn
local playerCardInterfaceConn
local playerCardPersistentConn
local playerCardPending = false

local function f57()
  if connect2 then
    connect2:Disconnect()
    connect2 = nil
  end
  if playerCardGuiConn then
    playerCardGuiConn:Disconnect()
    playerCardGuiConn = nil
  end
  if playerCardInterfaceConn then
    playerCardInterfaceConn:Disconnect()
    playerCardInterfaceConn = nil
  end
  if playerCardPersistentConn then
    playerCardPersistentConn:Disconnect()
    playerCardPersistentConn = nil
  end
  playerCardPending = false
  v228.__cardFiredFor = nil
  v208 = false
  v209 = false
end

local function f58()
  if connect2 or playerCardGuiConn then
    return
  end

  local function attachPersistent(persistent)
    if not persistent or not persistent:IsA("Instance") then return end
    if connect2 and playerCardPersistentConn == persistent then return end
    if connect2 then
      connect2:Disconnect()
      connect2 = nil
    end
    playerCardPersistentConn = persistent

    local function onCardAdded(child5)
      if child5.Name ~= "FlashPlayerCardFrame" or playerCardPending then return end
      playerCardPending = true
      task.spawn(function()
        -- The game sometimes adds the card frame before its Username label is ready.
        for attempt = 1, 12 do
          if not child5.Parent then break end
          local username = child5:FindFirstChild("Username", true)
          if username and username:IsA("TextLabel") and username.Text ~= "" then
            break
          end
          task.wait(0.05)
        end
        if child5.Parent then
          f56()
        end
        playerCardPending = false
      end)
    end

    connect2 = persistent.ChildAdded:Connect(onCardAdded)
    -- Handle a card that appeared just before the listener was attached.
    for _, existingCard in ipairs(persistent:GetChildren()) do
      if existingCard.Name == "FlashPlayerCardFrame" then
        onCardAdded(existingCard)
      end
    end
  end

  local function attachInterface(interface)
    if not interface then return end
    local persistent = interface:FindFirstChild("Persistent")
    if persistent then attachPersistent(persistent) end

    if playerCardInterfaceConn then
      playerCardInterfaceConn:Disconnect()
      playerCardInterfaceConn = nil
    end
    playerCardInterfaceConn = interface.ChildAdded:Connect(function(child)
      if child.Name == "Persistent" then attachPersistent(child) end
    end)
  end

  local playerGui = localPlayer2:FindFirstChildOfClass("PlayerGui") or localPlayer2:WaitForChild("PlayerGui", 10)
  if not playerGui then return end

  local interface = playerGui:FindFirstChild("Interface")
  if interface then attachInterface(interface) end

  -- The interface can load after the toggle is enabled, so keep watching for it.
  playerCardGuiConn = playerGui.ChildAdded:Connect(function(child)
    if child.Name == "Interface" then attachInterface(child) end
  end)
end

_G.PlayerCard = {
  Enable = f58,
  Disable = f57,
  SetCard = function(p129) v207 = p129 end,
  GetCard = function() return v207 end,
  Fire = f55,
  Apply = function(p130)
    if p130 and p130 ~= "" then
      v207 = p130
    end

    if not v206 then
      v174:Notify("Turn PlayerCard Changer on first")
      return
    end

    v228.__cardFiredFor = nil
    f55()
  end,
}

v242 = {
  enabled = false,
  Color3_2 = Color3.fromRGB(255, 0, 0),
  currentPlayer = nil,
  originalColors = {},
  connection = nil,
}

function v242.saveAndPaint(p131)
  if not p131 then
    return
  end

  for index38, value45 in ipairs(p131:GetDescendants()) do
    if value45:IsA("BasePart") then
      if v242.originalColors[value45] == nil then
        v242.originalColors[value45] = value45.Color
      end

      value45.Color = v242.Color3_2
    end
  end
end

function v242.restoreColors(p132)
  if not p132 then
    return
  end

  for index39, value46 in ipairs(p132:GetDescendants()) do
    if value46:IsA("BasePart") and v242.originalColors[value46] then
      value46.Color = v242.originalColors[value46]
      v242.originalColors[value46] = nil
    end
  end
end

function v242.clearCurrent()
  if v242.currentPlayer then
    local Character = v242.currentPlayer.Character

    if Character then
      v242.restoreColors(Character)
    end

    v242.currentPlayer = nil
  end
end

function v242.start()
  if v242.connection then
    return
  else
    local BallTouched = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RE.BallTouched

    if not BallTouched then
      return
    end

    v242.connection = BallTouched.OnClientEvent:Connect(function(p133)
      if not v242.enabled then
        return
      end

      if not (typeof(p133) == "Instance" and p133:IsA("Player")) then
        return
      end

      if v242.currentPlayer and v242.currentPlayer ~= p133 then
        local Character_2 = v242.currentPlayer.Character

        if Character_2 then
          v242.restoreColors(Character_2)
        end
      end

      if v242.currentPlayer ~= p133 then
        local Character_3 = p133.Character

        if Character_3 then
          v242.saveAndPaint(Character_3)
        else
          p133.CharacterAdded:Once(function(p134)
            task.wait(0.1)

            if v242.enabled then
              v242.saveAndPaint(p134)
            end
          end)
        end
      end

      v242.currentPlayer = p133
    end)

    return
  end
end

function v242.stop()
  if v242.connection then
    v242.connection:Disconnect()
    v242.connection = nil
  end

  v242.clearCurrent()
end

function v242.setColor(color3)
  v242.Color3_2 = color3

  if v242.enabled and v242.currentPlayer then
    local Character_4 = v242.currentPlayer.Character

    if Character_4 then
      v242.saveAndPaint(Character_4)
    end
  end
end

v243 = {
  enabled = false,
  wasInRange = false,
  cooldownActive = false,
  radius = 20,
  connection = nil,
  charConnection = nil,
}

function v243.getNearestBall()
  local MathHuge = math.MathHuge
  local Character_5 = localPlayer2.Character
  local v244

  if not Character_5 then
    return nil, nil
  else
    local HumanoidRootPart = Character_5:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
      return nil, nil
    end

    for index40, value47 in ipairs(workspaceService:GetChildren()) do
      if value47:IsA("Model") and value47.Name:match("^CLIENT_BALL_%d+$") then
        for index41, value48 in ipairs(value47:GetDescendants()) do
          if value48:IsA("BasePart") then
            local Magnitude = (value48.Position - HumanoidRootPart.Position).Magnitude

            if Magnitude < MathHuge then
              v244 = value48
              MathHuge = Magnitude
            end

            break
          end
        end
      end
    end

    return v244, MathHuge
  end
end

function v243.isOnGround()
  local Character_6 = localPlayer2.Character

  if not Character_6 then
    return false
  else
    local Humanoid = Character_6:FindFirstChild("Humanoid")

    if not Humanoid then
      return false
    end

    return Humanoid.FloorMaterial ~= Enum.Material.Air
  end
end

function v243.triggerCooldown()
  v243.cooldownActive = true
  v243.wasInRange = true

  task.delay(5, function()
    v243.cooldownActive = false
    v243.wasInRange = false
  end)
end

do
  function v243.step()
    if not v243.enabled then
      return
    elseif v243.cooldownActive then
      return
    else
      local Character_7 = localPlayer2.Character

      if not Character_7 then
        return
      else
        local Humanoid_2 = Character_7:FindFirstChild("Humanoid")

        if not Humanoid_2 then
          return
        end

        if Humanoid_2:GetState() == Enum.HumanoidStateType.Jumping
          or Humanoid_2:GetState() == Enum.HumanoidStateType.Freefall or Humanoid_2.Jump == true then
          v243.wasInRange = false
          return
        elseif not v243.isOnGround() then
          v243.wasInRange = false
          return
        else
          local v245, v246 = v243.getNearestBall()

          if not v245 then
            v243.wasInRange = false
            return
          else
            local v247 = v246 <= v243.radius

            if v247 and not v243.wasInRange then
              if firesignal then
                firesignal(doMove.OnClientEvent, "Set", false, false)
                firesignal(stopAllEmotes.OnClientEvent)
              end

              v243.triggerCooldown()
            end

            v243.wasInRange = v247
            return
          end
        end
      end
    end
  end

  function v243.start()
    if v243.connection then
      return
    end

    v243.connection = runService.Heartbeat:Connect(v243.step)
    f36(v243.connection)

    if not v243.charConnection then
      v243.charConnection = localPlayer2.CharacterAdded:Connect(function()
        v243.wasInRange = false
        v243.cooldownActive = false
      end)

      f36(v243.charConnection)
    end
  end

  function v243.stop()
    if v243.connection then
      v243.connection:Disconnect()
      v243.connection = nil
    end

    if v243.charConnection then
      v243.charConnection:Disconnect()
      v243.charConnection = nil
    end

    v243.wasInRange = false
    v243.cooldownActive = false
  end

  function v243.setRadius(p135)
    v243.radius = p135 or 20
  end

  _G.AutoReceive = {
    SetEnabled = function(p136)
      v243.enabled = p136

      if p136 then
        v243.start()
      else
        v243.stop()
      end
    end,
    IsEnabled = function() return v243.enabled end,
    SetRadius = function(p137) v243.setRadius(p137) end,
  }

  local function f59()
    v212 = {}
    local Assets = replicatedStorage:FindFirstChild("Assets")
    local Ball = Assets and Assets:FindFirstChild("Ball")

    if Ball then
      for index42, value49 in ipairs(Ball:GetChildren()) do
        if value49:IsA("Model") then
          table.insert(v212, value49.Name)
        end
      end
    end

    table.sort(v212)

    if #v212 == 0 then
      table.insert(v212, "ClassicBall")
      table.insert(v212, "ExtremeBall")
      table.insert(v212, "MediumBall")
    end

    return v212
  end

  local function f60()
    v210 = {}
    local Entities = replicatedStorage.Content.Item.Entities

    if Entities then
      for index43, value50 in ipairs(Entities:GetChildren()) do
        if value50:IsA("ModuleScript") then
          local Name = value50.Name

          if string.match(Name, "Card") or string.match(Name, "PlayerCard") then
            table.insert(v210, Name)
          end
        end
      end
    end

    table.sort(v210)

    if #v210 == 0 then
      table.insert(v210, "ContentCreatorPlayerCard")
      table.insert(v210, "UltimateChampionPlayerCard")
      table.insert(v210, "ProPlayerCard")
    end

    return v210
  end

  local function f61()
    v205 = {}
    local ScoreEffect = replicatedStorage.Assets:FindFirstChild("ScoreEffect")

    if ScoreEffect then
      for index44, value51 in ipairs(ScoreEffect:GetChildren()) do
        if value51:IsA("ModuleScript") then
          table.insert(v205, value51.Name)
        end
      end
    end

    local Effects = replicatedStorage.Assets:FindFirstChild("Effects")

    if Effects then
      for index45, value52 in ipairs({ "GroundHit1", "GroundHit2", "SupernovaScoreEffect" }) do
        if Effects:FindFirstChild(value52) then
          table.insert(v205, value52)
        end
      end
    end

    table.sort(v205)

    if #v205 == 0 then
      table.insert(v205, "SupernovaScoreEffect")
      table.insert(v205, "GroundHit1")
      table.insert(v205, "GroundHit2")
    end

    return v205
  end

  v205 = f61()

  local function f62()
    local GetRawMetatable = getrawmetatable(game)
    local namecall = GetRawMetatable.__namecall
    setreadonly(GetRawMetatable, false)

    function GetRawMetatable.__namecall(p138, ...)
      local GetNamecallMethod = getnamecallmethod()
      local v250 = ...

      if p138 == ballService.RF.Interact and GetNamecallMethod == "InvokeServer" then
        if type(v250) == "table" and v250.Move == "Spike" then
          if v222 and firesignal and localPlayer2 and localPlayer2.Character then
            firesignal(effects.OnClientEvent, {
              Character = localPlayer2.Character,
              Sound = "PowerSpike",
              Effect = "SpecialChargeSpikeVFX",
            })
          elseif v223 and firesignal and localPlayer2 and localPlayer2.Character then
            firesignal(effects.OnClientEvent, {
              Character = localPlayer2.Character,
              Sound = "PowerSpike",
              Effect = "HidariSpikeVFX",
            })
          end
        end

        return namecall(p138, v250)
      end

      return namecall(p138, ...)
    end

    setreadonly(GetRawMetatable, true)
  end

  v210 = f60()
  v212 = f59()

  if getrawmetatable and setreadonly and getnamecallmethod then
    f62()
  end
end

local function f63()
  local MathHuge_2 = math.huge
  local Character_8 = localPlayer2.Character
  local v251

  if not Character_8 then
    return nil
  else
    local HumanoidRootPart_2 = Character_8:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart_2 then
      return nil
    end

    for index46, value53 in ipairs(workspaceService:GetChildren()) do
      if value53:IsA("Model") and value53.Name:match("^CLIENT_BALL_%d+$") then
        for index47, value54 in ipairs(value53:GetDescendants()) do
          if value54:IsA("BasePart") then
            local Magnitude_2 = (value54.Position - HumanoidRootPart_2.Position).Magnitude

            if Magnitude_2 < MathHuge_2 then
              MathHuge_2 = Magnitude_2
              v251 = value54
            end

            break
          end
        end
      end
    end

    return v251
  end
end

local function f64()
  v182 = true

  if v183 then
    return
  end

  local namecall2

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  else
    local GetRawMetatable_2 = getrawmetatable(game)
    namecall2 = GetRawMetatable_2.__namecall
    setreadonly(GetRawMetatable_2, false)

    function GetRawMetatable_2.__namecall(p139, ...)
      local GetNamecallMethod_2 = getnamecallmethod()
      local v254 = ...

      if p139 == ballService.RF.Interact and GetNamecallMethod_2 == "InvokeServer" then
        if type(v254) == "table" and v254.Move == "Spike" and v182 then
          local LookVector = currentCamera2.CFrame.LookVector

          v254.LookVector = LookVector
          v254.Direction = LookVector

          if v254.MoveDirection then
            v254.MoveDirection = LookVector
          end
        end

        return namecall2(p139, v254)
      end

      return namecall2(p139, ...)
    end

    setreadonly(GetRawMetatable_2, true)
    v183 = true
    return
  end
end

local function f65()
  for index48, value55 in ipairs(workspaceService:GetChildren()) do
    if value55:IsA("Model") and value55.Name:match("^CLIENT_BALL_%d+$") then
      local Match = value55.Name:match("%d+")

      if Match then
        return tonumber(Match)
      end
    end
  end

  return nil
end

local function f66()
  v182 = false
end

v255 = { enabled = false, side = "Auto", reach = "All" }

local function f67()
  v184 = true

  if v185 then
    return
  end

  local namecall3

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  else
    local GetRawMetatable_3 = getrawmetatable(game)
    namecall3 = GetRawMetatable_3.__namecall
    setreadonly(GetRawMetatable_3, false)

    function GetRawMetatable_3.__namecall(p140, ...)
      local GetNamecallMethod_3 = getnamecallmethod()
      local v258 = ...

      if p140 == ballService.RF.Interact and GetNamecallMethod_3 == "InvokeServer" then
        if type(v258) == "table" and v258.Move == "Spike" and v184 then
          if v258.TiltDirection and v258.LookVector then
            local TiltDirection = v258.TiltDirection

            if math.abs(TiltDirection.X) > 0.01 or math.abs(TiltDirection.Z) > 0.01 then
              local LookVector_2 = v258.LookVector
              local Vector3_2 = Vector3.new(TiltDirection.X, 0, TiltDirection.Z)

              v258.LookVector = Vector3.new(
                LookVector_2.X + Vector3_2.X * 0.3, LookVector_2.Y, LookVector_2.Z + Vector3_2.Z * 0.3
              ).Unit

              v258.TiltDirection = Vector3.new(
                TiltDirection.X * 1.35, TiltDirection.Y, TiltDirection.Z * 1.35
              )
            end
          end
        end

        return namecall3(p140, v258)
      end

      return namecall3(p140, ...)
    end

    setreadonly(GetRawMetatable_3, true)
    v185 = true
    return
  end
end

local function f68()
  v184 = false
end

do
  function v255.physics()
    local v259, v260 = pcall(require, replicatedStorage.Common.Physics)
    return v259 and v260 or nil
  end

  function v255.bounds()
    local Physics = v255.physics()
    local map, court

    if Physics and Physics._getCourtlines then
      local v262, v263 = pcall(Physics._getCourtlines)

      if v262 and v263 and v263:IsA("BasePart") then
        return v263.Position, v263.Size * 0.5, v263.Position.Y
      end

      map = workspaceService:FindFirstChild("Map")
      court = map and map:FindFirstChild("Court")

      if court then
        return court.Position, court.Size * 0.5 - Vector3.new(1, 0, 1), court.Position.Y + court.Size.Y * 0.5
      end

      return nil
    end

    map = workspaceService:FindFirstChild("Map")
    court = map and map:FindFirstChild("Court")

    if court then
      return court.Position, court.Size * 0.5 - Vector3.new(1, 0, 1), court.Position.Y + court.Size.Y * 0.5
    end

    return nil
  end

  function v255.trackBall(p141, p142, p143)
    if p143 <= 0 then
      return
    end

    v255.drift = (p141.Position - p142) / p143
  end

  function v255.origin()
    local f63_2 = f63()

    local Character_9 = localPlayer2.Character
      and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

    if not f63_2 then
      return Character_9 and Character_9.Position or Vector3.zero
    else
      local v265 = not Character_9
      local drift = v255.drift

      if v265 or typeof(drift) ~= "Vector3" or drift.Magnitude < 1 then
        return f63_2.Position
      else
        local Position = f63_2.Position - Character_9.Position
        local AssemblyLinearVelocity = drift - Character_9.AssemblyLinearVelocity
        local Dot = AssemblyLinearVelocity:Dot(AssemblyLinearVelocity)

        if Dot < 1 then
          return f63_2.Position
        else
          local Dot_2 = Position:Dot(AssemblyLinearVelocity)
          local MathClamp_3 = math.clamp(-Dot_2 / Dot, 0, 0.45)
          return f63_2.Position + drift * MathClamp_3
        end
      end
    end
  end

  local function f69()
    local Character_10 = localPlayer2.Character
      and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

    local v269 = not Character_10
    local v270, v271, v272 = v255.bounds()
    local v273

    if v269 or not v270 then
      return nil
    else
      local MathMax = math.max(v271.X - 2, 1)
      local MathMax_2 = math.max(v271.Z - 2, 1)
      local Map = workspaceService:FindFirstChild("Map")
      local BallCollideOnly = Map and Map:FindFirstChild("BallCollideOnly")
      local Net = BallCollideOnly and BallCollideOnly:FindFirstChild("Net")
      local Z = Net and Net.Position.Z or v270.Z
      local Value_2 = localPlayer2.Team and localPlayer2.Team:GetAttribute("Index")

      if Value_2 == 1 then
        v273 = 1
      elseif Value_2 == 2 then
        v273 = -1
      else
        v273 = Character_10.Position.Z < Z and 1 or -1
      end

      local v276 = v270.Z + v273 * MathMax_2
      local v277 = v270.X + v273 * MathMax
      local v278 = v270.X - v273 * MathMax
      local Origin = v255.origin()
      local MathAbs = math.abs(Character_10.Position.Z - Z)
      local Clamp_2 = 1 - math.clamp(MathAbs / (v271.Z / 3), 0, 1)
      v255.lean = Clamp_2
      local v282 = v270.Z + v273 * MathMax_2 * 0.3
      local reach = v255.reach
      local v283 = reach == "Nearest"

      local V283 = v283
      V283 = v283 or reach ~= "Back" and Clamp_2 > 0

      local side = v255.side

      if side == "Left" then
        return Vector3.new(v277, v272, V283 and v282 or v276)
      elseif side == "Right" then
        return Vector3.new(v278, v272, V283 and v282 or v276)
      else
        local v285 = {}

        if reach ~= "Nearest" then
          v285[#v285 + 1] = { at = Vector3.new(v277, v272, v276), reward = 0 }
          v285[#v285 + 1] = { at = Vector3.new(v278, v272, v276), reward = 0 }
        end

        if V283 then
          v285[#v285 + 1] = { at = Vector3.new(v277, v272, v282), reward = 0.45 * Clamp_2 }
          v285[#v285 + 1] = { at = Vector3.new(v278, v272, v282), reward = 0.45 * Clamp_2 }
        end

        local currentCamera3 = workspaceService.CurrentCamera or currentCamera2

        local LookVector_3 = currentCamera3 and currentCamera3.CFrame.LookVector
          or Character_10.CFrame.LookVector

        local Vector3_3 = Vector3.new(LookVector_3.X, 0, LookVector_3.Z)

        if Vector3_3.Magnitude < 0.01 then
          return v285[1].at
        else
          local Unit = Vector3_3.Unit
          local Physics_2 = v255.physics()
          local GetCourtlines = Physics_2 and Physics_2._getCourtlines and Physics_2._getCourtlines()
          local v287 = {}

          for index50, value56 in ipairs(players:GetPlayers()) do
            if value56 ~= localPlayer2
              and (not localPlayer2.Team or value56.Team ~= localPlayer2.Team) then
              local Character_11 = value56.Character

              local Character9 = Character_11

              Character9 = Character_11
                and value56.Character:FindFirstChild("HumanoidRootPart")

              if Character9 then
                v287[#v287 + 1] = Vector3.new(
                  Character9.Position.X, v272, Character9.Position.Z
                )
              end
            end
          end

          local v288 = {}

          for index51, value57 in ipairs(v285) do
            local v289 = true

            if GetCourtlines and Physics_2.isPositionInCourt then
              local v290, v291 = pcall(
                Physics_2.isPositionInCourt, value57.at, GetCourtlines, 0, nil
              )

              v289 = not v290 or v291
            end

            if v289 then
              local Vector3_4 = Vector3.new(value57.at.X - Origin.X, 0, value57.at.Z - Origin.Z)

              if Vector3_4.Magnitude > 0.01 then
                local Dot_3 = Vector3_4.Unit:Dot(Unit)
                v288[#v288 + 1] = { spot = value57.at, dot = Dot_3, reward = value57.reward }
              end
            end
          end

          if #v288 == 0 then
            return v285[1].at
          else
            local v292 = nil

            for index52, value58 in ipairs(v288) do
              if not v292 or value58.dot > v292.dot then
                v292 = value58
              end
            end

            local X_2 = v292.spot.X >= v270.X
            local spot = nil
            local v294 = nil

            for index53, value59 in ipairs(v288) do
              if value59.spot.X >= v270.X == X_2 then
                local v295 = 60

                for index54, value60 in ipairs(v287) do
                  local Magnitude_3 = (value60 - value59.spot).Magnitude

                  if Magnitude_3 < v295 then
                    v295 = Magnitude_3
                  end
                end

                local MathMin_2 = math.min(v295, 45) / 45 + value59.reward

                if not v294 or MathMin_2 > v294 then
                  v294 = MathMin_2
                  spot = value59.spot
                end
              end
            end

            return spot or v292.spot
          end
        end
      end
    end
  end

  function v255.facing()
    local f69_2 = f69()

    if not f69_2 then
      return nil
    else
      local Origin_2 = v255.origin()
      local Vector3_5 = Vector3.new(f69_2.X - Origin_2.X, 0, f69_2.Z - Origin_2.Z)

      local Character_12 = localPlayer2.Character
        and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

      if Character_12 then
        local Map_2 = workspaceService:FindFirstChild("Map")
        local BallCollideOnly_2 = Map_2 and Map_2:FindFirstChild("BallCollideOnly")
        local Net_2 = BallCollideOnly_2 and BallCollideOnly_2:FindFirstChild("Net")
        local Z_2 = Net_2 and Net_2.Position.Z

        if Z_2 then
          local v299 = Character_12.Position.Z > Z_2 and 1 or -1

          if Vector3_5.Z * v299 >= 0 then
            Vector3_5 = Vector3.new(
              f69_2.X - Character_12.Position.X, 0, f69_2.Z - Character_12.Position.Z
            )
          end

          if Vector3_5.Z * v299 >= 0 then
            Vector3_5 = Vector3.new(Vector3_5.X, 0, -v299 * math.max(math.abs(Vector3_5.Z), 1))
          end
        end
      end

      if Vector3_5.Magnitude < 0.01 then
        return nil
      end

      return Vector3_5.Unit
    end
  end

  function v255.installAim()
    if v255.aimed then
      return
    end

    local namecall4

    if not (getrawmetatable and setreadonly and getnamecallmethod) then
      return
    else
      local GetRawMetatable_4 = getrawmetatable(game)
      namecall4 = GetRawMetatable_4.__namecall
      setreadonly(GetRawMetatable_4, false)

      function GetRawMetatable_4.__namecall(p144, ...)
        local GetNamecallMethod_4 = getnamecallmethod()
        local v302 = { ... }

        if p144 == ballService.RF.Interact and GetNamecallMethod_4 == "InvokeServer" then
          local v303 = v302[1]

          if v255.enabled and type(v303) == "table"
            and (v303.Move == "Spike" or v303.Move == "ServeSpike") then
            local steer = v255.steer

            if typeof(steer) == "Vector3" then
              local Vector3_6 = Vector3.new(steer.X, 0, steer.Z)

              if Vector3_6.Magnitude > 0.01 then
                local New_2 = (Vector3_6.Unit - Vector3.new(0, 0.35, 0)).Unit
                v303.LookVector = New_2
                v303.Direction = New_2
              end
            end
          end

          return namecall4(p144, v303)
        end

        return namecall4(p144, unpack(v302))
      end

      setreadonly(GetRawMetatable_4, true)
      v255.aimed = true
      return
    end
  end
end

local namecall5, v304

local function f70()
  v186 = true

  if v187 then
    return
  end

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  end

  v304 = getrawmetatable(game)
  namecall5 = v304.__namecall
  setreadonly(v304, false)

  function v304.__namecall(p145, ...)
    local GetNamecallMethod_5 = getnamecallmethod()
    local v306 = { ... }

    if p145 == ballService.RF.Interact and GetNamecallMethod_5 == "InvokeServer" then
      local v307 = v306[1]

      if type(v307) == "table" and v307.Move == "Spike" and v186 then
        v307.Charge = 1
        v307.SpecialCharge = 1
        v307.HoldDuration = 1

        if type(v307.CustomClient) == "table" then
          v307.CustomClient.HoldDuration = 1
        else
          v307.CustomClient = { HoldDuration = 1 }
        end
      end

      return namecall5(p145, unpack(v306))
    end

    return namecall5(p145, ...)
  end

  setreadonly(v304, true)
  v187 = true
end

local function f71()
  v186 = false
end

v308 = {
  enabled = false,
  gui = nil,
  loopThread = nil,
  heartbeatLink = nil,
  state = {
    tp = false,
    block = false,
    spike = false,
    jump = false,
    interval = 0.05,
  },
  jumpState = false,
}

function v308.getRF(p146)
  local v309, v310 = pcall(function()
    return replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RF[p146]
  end)

  if v309 and v310 then
    return v310
  else
    local v311, v312 = pcall(function()
      local Packages = replicatedStorage:FindFirstChild("Packages")

      if not Packages then
        return nil
      else
        local Index = Packages:FindFirstChild("_Index")

        if not Index then
          return nil
        end

        for v313, v314 in Index:GetChildren() do
          if v314.Name:find("knit") then
            local Knit = v314:FindFirstChild("knit")

            if Knit then
              local Services = Knit:FindFirstChild("Services")

              local Services_2 = Services
              Services_2 = Services and Knit.Services:FindFirstChild("BallService")

              if Services_2 then
                local RF = Services_2:FindFirstChild("RF")

                if RF then
                  return RF:FindFirstChild(p146)
                end
              end
            end
          end
        end

        return nil
      end
    end)

    return v311 and v312 or nil
  end
end

v308.remotes = {
  CreateHitbox = v308.getRF("CreateHitbox"),
  Interact = v308.getRF("Interact"),
  Jump = v308.getRF("Jump"),
  UpdateTilt = v308.getRF("UpdateTilt"),
}

function v308.getBall()
  for index56, value61 in ipairs(workspaceService:GetDescendants()) do
    if typeof(value61.Name) == "string" and value61.Name:sub(1, 12) == "CLIENT_BALL_" then
      local IsType = value61:IsA("BasePart") and value61

      local BasePart = IsType
      BasePart = IsType or value61:FindFirstChildWhichIsA("BasePart", true)

      if BasePart then
        local Value_3 = value61:GetAttribute("ServerId")
          or BasePart:GetAttribute("ServerId") or value61:GetAttribute("Id")
          or BasePart:GetAttribute("Id") or tonumber(value61.Name:sub(13))

        if Value_3 then
          return BasePart, Value_3
        end
      end
    end
  end

  return nil, 0
end

function v308.getHRP()
  local Character_13 = localPlayer2.Character
  return Character_13 and Character_13:FindFirstChild("HumanoidRootPart")
end

function v308.timestamp()
  local v315, v316 = pcall(function() return workspaceService:GetServerTimeNow() end)

  if v315 and typeof(v316) == "number" then
    return v316
  end

  return tick()
end

function v308.buildGUI()
  local frame, textBox

  if v308.gui then
    return
  else
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = v176 .. "_Farm"
    ScreenGui.ResetOnSpawn = false

    hidegui(ScreenGui)

    if not ScreenGui.Parent then
      ScreenGui.Parent = localPlayer2:WaitForChild("PlayerGui")
    end

    frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 175)
    frame.Position = UDim2.new(0.05, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = frame

    local TextLabel_3 = Instance.new("TextLabel")
    TextLabel_3.Size = UDim2.new(1, 0, 0, 22)
    TextLabel_3.BackgroundTransparency = 1
    TextLabel_3.Text = "Auto Farm"
    TextLabel_3.TextColor3 = Color3.fromRGB(238, 240, 248)
    TextLabel_3.Font = Enum.Font.GothamBold
    TextLabel_3.TextSize = 13
    TextLabel_3.Parent = frame

    local function f72(p147, p148, p149)
      local TextButton = Instance.new("TextButton")
      TextButton.Size = UDim2.new(0, 134, 0, 24)
      TextButton.Position = UDim2.new(0, 8, 0, p147)
      TextButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
      TextButton.Text = p148 .. " OFF"
      TextButton.TextColor3 = Color3.fromRGB(238, 240, 248)
      TextButton.TextSize = 12
      TextButton.Font = Enum.Font.GothamBold
      TextButton.AutoButtonColor = false
      TextButton.Parent = frame

      local UICorner_2 = Instance.new("UICorner")
      UICorner_2.CornerRadius = UDim.new(0, 6)
      UICorner_2.Parent = TextButton

      TextButton.MouseButton1Click:Connect(function()
        v308.state[p149] = not v308.state[p149]
        TextButton.Text = p148 .. " " .. (v308.state[p149] and "ON" or "OFF")

        TextButton.BackgroundColor3 = v308.state[p149] and Color3.fromRGB(0, 140, 0)
          or Color3.fromRGB(55, 55, 55)
      end)
    end

    f72(26, "TP", "tp")
    f72(54, "BALL", "block")
    f72(82, "SPIKE", "spike")
    f72(110, "JUMP", "jump")

    textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 134, 0, 24)
    textBox.Position = UDim2.new(0, 8, 0, 140)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.Text = "0.05"
    textBox.PlaceholderText = "interval"
    textBox.TextColor3 = Color3.fromRGB(238, 240, 248)
    textBox.TextSize = 13
    textBox.Font = Enum.Font.GothamMedium
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    local UICorner_3 = Instance.new("UICorner")
    UICorner_3.CornerRadius = UDim.new(0, 6)
    UICorner_3.Parent = textBox

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
      v308.state.interval = tonumber(textBox.Text) or 0.05
    end)

    v308.gui = ScreenGui
    return
  end
end

function v308.destroyGUI()
  if v308.gui then
    v308.gui:Destroy()
    v308.gui = nil
  end
end

function v308.start()
  if v308.enabled then
    return
  end

  v308.enabled = true
  v308.buildGUI()

  if v308.heartbeatLink then
    v308.heartbeatLink:Disconnect()
  end

  v308.heartbeatLink = runService.Heartbeat:Connect(function()
    if not v308.enabled or not v308.state.tp then
      return
    end

    local GetBall = v308.getBall()
    local GetHRP = v308.getHRP()

    if GetBall and GetHRP then
      pcall(function() GetHRP.CFrame = GetBall.CFrame end)
    end
  end)

  f36(v308.heartbeatLink)

  v308.loopThread = task.spawn(function()
    while v308.enabled do
      local interval = v308.state.interval or 0.05
      local v319, v320 = v308.getBall()
      local GetHRP_2 = v308.getHRP()

      local LookVector_4 = currentCamera2 and currentCamera2.CFrame.LookVector
        or Vector3.new(0, 0, -1)

      local lookVector5 = GetHRP_2 and GetHRP_2.CFrame.LookVector or Vector3.zero
      local Vector3_7 = Vector3.new(0, 1, 0)
      local Timestamp = v308.timestamp()

      if v308.state.block and v320 ~= 0 and v319 and v308.remotes.CreateHitbox
        and v308.remotes.Interact then
        local Random = "Block" .. math.random(1000000, 9999999)

        pcall(function()
          v308.remotes.CreateHitbox:InvokeServer({
            BallId = v320,
            Charge = 1,
            Key = Random,
            ClientTimestamp = Timestamp,
            Move = "Block",
          })
        end)

        pcall(function()
          v308.remotes.Interact:InvokeServer({
            Charge = 1,
            Move = "Block",
            SpecialCharge = 0,
            TiltDirection = Vector3_7,
            BallId = v320,
            MoveDirection = lookVector5,
            Key = Random,
            From = "Client",
            LookVector = LookVector_4,
            Timestamp = Timestamp,
            ClientCanRunSpecial = false,
            CustomClient = {},
          })
        end)

        if v308.remotes.UpdateTilt then
          pcall(function() v308.remotes.UpdateTilt:InvokeServer(Vector3_7) end)
        end
      end

      if v308.state.spike and v320 ~= 0 and v319 and v308.remotes.Interact then
        local Vector3_8 = Vector3.new(LookVector_4.X, 1, LookVector_4.Z)

        pcall(function()
          v308.remotes.Interact:InvokeServer({
            Charge = 1,
            Move = "Spike",
            SpecialCharge = 0,
            TiltDirection = Vector3_8,
            LookVector = LookVector_4,
            MoveDirection = lookVector5,
            ClientCanRunSpecial = false,
            From = "Client",
            Timestamp = Timestamp,
            BallId = v320,
            CustomClient = {},
          })
        end)

        if v308.remotes.UpdateTilt then
          pcall(function() v308.remotes.UpdateTilt:InvokeServer(Vector3_8) end)
        end
      end

      if v308.state.jump and v308.remotes.Jump then
        v308.jumpState = not v308.jumpState
        pcall(function() v308.remotes.Jump:InvokeServer(v308.jumpState) end)
      end

      task.wait(interval)
    end
  end)
end

function v308.stop()
  v308.enabled = false

  if v308.heartbeatLink then
    v308.heartbeatLink:Disconnect()
    v308.heartbeatLink = nil
  end

  v308.loopThread = nil
  v308.state.tp = false
  v308.state.block = false
  v308.state.spike = false
  v308.state.jump = false
  v308.jumpState = false
  v308.destroyGUI()
end

v323 = {
  enabled = false,
  connection = nil,
  lookVector = nil,
  direction = nil,
  tilt = nil,
  mode = "Nearest",
}

function v323.isSameTeam(p150)
  local Team = localPlayer2.Team

  if not Team then
    return false
  end

  return p150.Team == Team
end

function v323.getTarget()
  local Character_14 = localPlayer2.Character

  if not Character_14 then
    return nil
  else
    local HumanoidRootPart_3 = Character_14:FindFirstChild("HumanoidRootPart")

-- https://discord.gg/AwGHNh7Z7T
    if not HumanoidRootPart_3 then
      return nil
    else
      local v324 = {}

      for index57, value62 in ipairs(players:GetPlayers()) do
        if value62 ~= localPlayer2 and v323.isSameTeam(value62) then
          local Character_15 = value62.Character

          if Character_15 then
            local HumanoidRootPart_4 = Character_15:FindFirstChild("HumanoidRootPart")
            local Humanoid_3 = Character_15:FindFirstChildOfClass("Humanoid")

            if HumanoidRootPart_4 and Humanoid_3 and Humanoid_3.Health > 0 then
              table.insert(v324, HumanoidRootPart_4)
            end
          end
        end
      end

      if #v324 == 0 then
        return nil
      elseif v323.mode == "Random" then
        return v324[math.random(1, #v324)]
      else
        local v325 = nil
        local MathHuge_3 = math.huge

        for index58, value63 in ipairs(v324) do
          local Magnitude_4 = (value63.Position - HumanoidRootPart_3.Position).Magnitude

          if Magnitude_4 < MathHuge_3 then
            v325 = value63
            MathHuge_3 = Magnitude_4
          end
        end

        return v325
      end
    end
  end
end

function v323.calculateDirection()
  local Character_16 = localPlayer2.Character

  if not Character_16 then
    v323.lookVector = nil
    v323.direction = nil
    v323.tilt = nil

    return
  else
    local HumanoidRootPart_5 = Character_16:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart_5 then
      v323.lookVector = nil
      v323.direction = nil
      v323.tilt = nil

      return
    else
      local GetTarget = v323.getTarget()

      if not GetTarget then
        v323.lookVector = nil
        v323.direction = nil
        v323.tilt = nil

        return
      else
        local Position_2 = HumanoidRootPart_5.Position
        local Position_3 = GetTarget.Position
        local Vector3_9 = Vector3.new(Position_3.X - Position_2.X, 0, Position_3.Z - Position_2.Z)

        if Vector3_9.Magnitude < 0.01 then
          v323.lookVector = nil
          v323.direction = nil
          v323.tilt = nil

          return
        else
          local Unit_2 = Vector3_9.Unit

          v323.lookVector = Vector3.new(Unit_2.X, 0, Unit_2.Z)
          v323.direction = Vector3.new(Unit_2.X, 0, Unit_2.Z)
          v323.tilt = Vector3.new(Unit_2.X, 1, Unit_2.Z)

          return
        end
      end
    end
  end
end

function v323.fire()
  if not v323.lookVector then
    return false
  end

  local f65_2 = f65()

  if not f65_2 then
    return false
  end

  pcall(function()
    local Interact = ballService.RF.Interact
    local Workspace = workspace

    Interact:InvokeServer({
      Charge = 1,
      Move = "JumpSet",
      SpecialCharge = 1,
      TiltDirection = v323.tilt,
      LookVector = v323.lookVector,
      Direction = v323.direction,
      MoveDirection = Vector3.new(0, 0, 0),
      ClientCanRunSpecial = false,
      From = "Client",
      Timestamp = Workspace:GetServerTimeNow(),
      BallId = f65_2,
      CustomClient = {},
    })
  end)

  return true
end

function v323.start()
  if v323.connection then
    return
  end

  v323.connection = runService.Heartbeat:Connect(function()
    if v323.enabled then
      v323.calculateDirection()
    end
  end)

  f36(v323.connection)
end

function v323.stop()
  if v323.connection then
    v323.connection:Disconnect()
    v323.connection = nil
  end

  v323.lookVector = nil
  v323.direction = nil
  v323.tilt = nil
end

_G.AutoSet = v323

v329 = {
  enabled = false,
  connection = nil,
  namecallOld = nil,
  hooked = false,
  direction = nil,
  targetName = nil,
  mode = "Nearest",
}

function v329.isSameTeam(p151)
  local Team_2 = localPlayer2.Team

  if not Team_2 then
    return false
  end

  return p151.Team == Team_2
end

function v329.getTarget()
  local Character_17 = localPlayer2.Character

  if not Character_17 then
    return nil
  else
    local HumanoidRootPart_6 = Character_17:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart_6 then
      return nil
    else
      local v330 = {}

      for index59, value64 in ipairs(players:GetPlayers()) do
        if value64 ~= localPlayer2 and v329.isSameTeam(value64) then
          local Character_18 = value64.Character

          if Character_18 then
            local HumanoidRootPart_7 = Character_18:FindFirstChild("HumanoidRootPart")
            local Humanoid_4 = Character_18:FindFirstChildOfClass("Humanoid")

            if HumanoidRootPart_7 and Humanoid_4 and Humanoid_4.Health > 0 then
              table.insert(v330, HumanoidRootPart_7)
            end
          end
        end
      end

      if #v330 == 0 then
        return nil
      elseif v329.mode == "Random" then
        return v330[math.random(1, #v330)]
      else
        local v331 = nil
        local MathHuge_4 = math.huge

        for index60, value65 in ipairs(v330) do
          local Magnitude_5 = (value65.Position - HumanoidRootPart_6.Position).Magnitude

          if Magnitude_5 < MathHuge_4 then
            MathHuge_4 = Magnitude_5
            v331 = value65
          end
        end

        return v331
      end
    end
  end
end

function v329.calculateDirection()
  local Character_19 = localPlayer2.Character

  if not Character_19 then
    v329.direction = nil
    v329.targetName = nil
    return
  else
    local HumanoidRootPart_8 = Character_19:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart_8 then
      v329.direction = nil
      v329.targetName = nil
      return
    else
      local GetTarget_2 = v329.getTarget()

      if not GetTarget_2 then
        v329.direction = nil
        v329.targetName = nil
        return
      else
        local Position_4 = HumanoidRootPart_8.Position
        local Position_5 = GetTarget_2.Position
        local Vector3_10 = Vector3.new(Position_5.X - Position_4.X, 0, Position_5.Z - Position_4.Z)

        if Vector3_10.Magnitude < 0.01 then
          v329.direction = nil
          v329.targetName = nil
          return
        end

        v329.direction = Vector3_10.Unit
        v329.targetName = GetTarget_2.Parent.Name

        return
      end
    end
  end
end

function v329.start()
  if not ballService then
    return
  end

  if v329.connection then
    return
  end

  v329.connection = runService.Heartbeat:Connect(function()
    if v329.enabled then
      v329.calculateDirection()
    end
  end)

  f36(v329.connection)

  if v329.hooked then
    return
  end

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  else
    local GetRawMetatable_5 = getrawmetatable(game)
    v329.namecallOld = GetRawMetatable_5.__namecall
    setreadonly(GetRawMetatable_5, false)

    function GetRawMetatable_5.__namecall(p152, ...)
      local GetNamecallMethod_6 = getnamecallmethod()
      local v335 = ...

      if v329.enabled and p152 == ballService.RF.Interact and GetNamecallMethod_6 == "InvokeServer" then
        if type(v335) == "table" and v335.Move == "JumpSet" then
          if v329.direction then
            v335.LookVector = Vector3.new(v329.direction.X, 0, v329.direction.Z)
            v335.TiltDirection = Vector3.new(v329.direction.X, 1, v329.direction.Z)
            v335.MoveDirection = Vector3.new(0, 0, 0)
          end
        end

        return v329.namecallOld(p152, v335)
      end

      return v329.namecallOld(p152, ...)
    end

    setreadonly(GetRawMetatable_5, true)
    v329.hooked = true
    return
  end
end

function v329.stop()
  if v329.connection then
    v329.connection:Disconnect()
    v329.connection = nil
  end

  v329.direction = nil
  v329.targetName = nil
end

_G.AimSet = v329

v336 = { lastCount = 0 }

function v336.cleanName(p153)
  return p153:gsub("^DFInt", ""):gsub("^DFFlag", ""):gsub("^FFFlag", ""):gsub("^FFlag", ""):gsub(
    "^FInt", ""
  ):gsub(
    "^FString", ""
  ):gsub(
    "^FLog", ""
  )
end

function v336.apply(p154)
  local v337

  if type(setfflag) ~= "function" then
    v174:Notify("setfflag is not supported in this executor")
    return 0
  else
    local v338, v339 = pcall(function() return httpService:JSONDecode(p154) end)

    if not v338 or type(v339) ~= "table" then
      v174:Notify("Invalid JSON")
      return 0
    else
      v337 = 0
      local count2 = 0

      for key8, value66 in pairs(v339) do
        local Key8 = key8
        local Value66 = value66
        count2 = count2 + 1

        if count2 % 15 == 0 then
          task.wait()
        end

        pcall(function()
          local CleanName = v336.cleanName(Key8)
          local v343

          if type(getfflag) == "function" then
            v343 = getfflag(CleanName)
          end

          if v343 ~= nil or type(getfflag) ~= "function" then
            setfflag(CleanName, tostring(Value66))
            v337 = v337 + 1
          end
        end)
      end

      v336.lastCount = v337
      v174:Notify("Applied " .. v337 .. " fflag(s)")
      return v337
    end
  end
end

function v336.example()
  return [[
{
  "DFIntTaskSchedulerTargetFps": "9999",
  "FFlagDebugGraphicsDisableDirect3D11": "True"
}]]
end

local v344 = {
  active = false,
  links = {},
  damped = {},
  paused = {},
  loud = {
    [Enum.AnimationPriority.Action] = true,
    [Enum.AnimationPriority.Action2] = true,
    [Enum.AnimationPriority.Action3] = true,
    [Enum.AnimationPriority.Action4] = true,
  },
}

function v344.gag(p155)
  if type(getconnections) ~= "function" then
    return
  else
    local v345, v346 = pcall(getconnections, p155)

    if not v345 or type(v346) ~= "table" then
      return
    end

    for index61, value67 in ipairs(v346) do
      local Value67 = value67

      pcall(function()
        if Value67.Enabled ~= false then
          Value67:Disable()
          v344.paused[#v344.paused + 1] = Value67
        end
      end)
    end

    return
  end
end

function v344.quiet(p156)
  if not p156:IsA("Sound") then
    return
  end

  v344.damped[#v344.damped + 1] = { inst = p156, level = p156.Volume }

  pcall(function()
    p156.Volume = 0
    p156:Stop()
  end)
end

function v344.start()
  if v344.active then
    return
  else
    v344.active = true
    v344.gag(effects.OnClientEvent)
    v344.gag(effect.OnClientEvent)
    v344.animUntil = os.clock() + 0.2

    local Character_20 = localPlayer2.Character

    local Character17 = Character_20
      and Character_20:FindFirstChildWhichIsA("Animator", true)

    if Character17 then
      for index62, value68 in ipairs(Character17:GetPlayingAnimationTracks()) do
      end

      local AnimationPlayed = Character17.AnimationPlayed

      v344.links[#v344.links + 1] = AnimationPlayed:Connect(function(p157)
        if not v344.active or os.clock() > v344.animUntil then
          return
        end
      end)
    end

    for index63, value69 in ipairs({ workspaceService, soundService, Character_20 }) do
      if value69 then
        local DescendantAdded = value69.DescendantAdded

        v344.links[#v344.links + 1] = DescendantAdded:Connect(function(p158)
          if v344.active then
            v344.quiet(p158)
          end
        end)
      end
    end

    return
  end
end

function v344.stop()
  if not v344.active then
    return
  end

  v344.active = false

  for index64, value70 in ipairs(v344.links) do
    local Value70 = value70
    pcall(function() Value70:Disconnect() end)
  end

  v344.links = {}

  for index65, value71 in ipairs(v344.paused) do
    local Value71 = value71
    pcall(function() Value71:Enable() end)
  end

  v344.paused = {}

  for index66, value72 in ipairs(v344.damped) do
    local Value72 = value72

    if Value72.inst.Parent then
      pcall(function() Value72.inst.Volume = Value72.level end)
    end
  end

  v344.damped = {}
end

local function f73()
  local Character_21 = localPlayer2.Character
    and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

  local v351

  if not Character_21 then
    return nil
  else
    local v352, v353, v354 = v255.bounds()

    if not v352 then
      return nil
    else
      local Map_3 = workspaceService:FindFirstChild("Map")
      local BallCollideOnly_3 = Map_3 and Map_3:FindFirstChild("BallCollideOnly")
      local Net_3 = BallCollideOnly_3 and BallCollideOnly_3:FindFirstChild("Net")
      local Z_3 = Net_3 and Net_3.Position.Z or v352.Z
      local v355 = Net_3 and Net_3.Position.Y + Net_3.Size.Y * 0.5 or v354
      local Value_4 = localPlayer2.Team and localPlayer2.Team:GetAttribute("Index")

      if Value_4 == 1 then
        v351 = 1
      elseif Value_4 == 2 then
        v351 = -1
      else
        v351 = Character_21.Position.Z < Z_3 and 1 or -1
      end

      local f63_3 = f63()
      local Position_6 = f63_3 and f63_3.Position

      local Position7 = Position_6
      Position7 = Position_6 or Character_21.Position + Vector3.new(0, 6, 0)

      local MathAbs_2 = math.abs(Z_3 - Position7.Z)
      local MathMax_3 = math.max(MathAbs_2, 2)
      local MathClamp_4 = math.clamp(0.45 * (Position7.Y - v355) / MathMax_3, -0.05, 0.3)
      local MathMax_4 = math.max(v353.Z - 2, 1)

      local Vector3_11 = Vector3.new(
        v352.X + (Position7.X - v352.X) * 0.25, v354, v352.Z + v351 * MathMax_4 * 0.55
      )

      local Vector3_12 = Vector3.new(Vector3_11.X - Position7.X, 0, Vector3_11.Z - Position7.Z)

      if Vector3_12.Magnitude < 0.01 then
        return nil
      end

      return (Vector3_12.Unit - Vector3.new(0, MathClamp_4, 0)).Unit
    end
  end
end

local v362 = { steer = nil, expiry = 0, hooked = false }
local connect3

local function f74()
  if connect3 then
    connect3:Disconnect()
    connect3 = nil
  end

  v196 = false
end

function v362.install()
  if v362.hooked then
    return
  end

  local namecall6

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  else
    local GetRawMetatable_6 = getrawmetatable(game)
    namecall6 = GetRawMetatable_6.__namecall
    setreadonly(GetRawMetatable_6, false)

    function GetRawMetatable_6.__namecall(p159, ...)
      local v364 = { ... }
      local GetNamecallMethod_7 = getnamecallmethod()

      if p159 == ballService.RF.Interact and GetNamecallMethod_7 == "InvokeServer" then
        local v366 = v364[1]
        local steer2 = v362.steer

        if type(v366) == "table" and typeof(steer2) == "Vector3" and os.clock() < v362.expiry then
          if v366.Move == "Spike" or v366.Move == "ServeSpike" then
            v366.LookVector = steer2
            v366.Direction = steer2

            local Vector3_13 = Vector3.new(steer2.X, 0, steer2.Z)

            if typeof(v366.TiltDirection) == "Vector3" and Vector3_13.Magnitude > 0.01 then
              local Vector3_14 = Vector3.new(v366.TiltDirection.X, 0, v366.TiltDirection.Z).Magnitude

              if Vector3_14 > 0.05 then
                local v367 = Vector3_13.Unit * Vector3_14
                v366.TiltDirection = Vector3.new(v367.X, v366.TiltDirection.Y, v367.Z)
              end
            end
          end
        end

        return namecall6(p159, v366)
      end

      return namecall6(p159, unpack(v364))
    end

    setreadonly(GetRawMetatable_6, true)
    v362.hooked = true
    return
  end
end

local function f75()
  local v368

  if not v188 then
    return
  elseif not firesignal then
    return
  else
    local DoMove = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RE.DoMove
    v344.start()
    v368 = v178
    v178 = true
    f39(300)
    local f73_2 = f73() or currentCamera2.CFrame.LookVector

    v362.steer = f73_2
    v362.expiry = os.clock() + 0.8
    v362.install()

    firesignal(DoMove.OnClientEvent, "Spike", false, false, f73_2)

    task.spawn(function()
      task.wait(0.3)
      v178 = v368

      if v368 then
        f39(v179)
      else
        f37()
      end

      v344.stop()
    end)

    return
  end
end

local function f76()
  if connect3 then
    return
  end

  local DoMove_2 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RE.DoMove

  connect3 = userInputService.JumpRequest:Connect(function()
    if v196 then
      task.wait(0.03)

      if firesignal then
        firesignal(DoMove_2.OnClientEvent, "Spike", false, false)
      end
    end
  end)

  v196 = true
end

do
  local function f77()
    local ScreenGui_2 = Instance.new("ScreenGui")
    ScreenGui_2.Name = v176

    hidegui(ScreenGui_2)
    ScreenGui_2.ResetOnSpawn = false

    textButton2 = Instance.new("TextButton")
    textButton2.Size = UDim2.new(0, 50, 0, 50)
    textButton2.Position = UDim2.new(0.5, -25, 0.85, -25)
    textButton2.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    textButton2.Text = "Spike"
    textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton2.TextScaled = true
    textButton2.Font = Enum.Font.GothamBold
    textButton2.Parent = ScreenGui_2
    textButton2.BackgroundTransparency = 0.2
    textButton2.BorderSizePixel = 0
    textButton2.Selectable = false

    local UICorner_4 = Instance.new("UICorner")
    UICorner_4.CornerRadius = UDim.new(1, 0)
    UICorner_4.Parent = textButton2

    local v369 = false
    local position8, position9

    textButton2.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        v369 = true
        position8 = input.Position
        position9 = textButton2.Position

        input.Changed:Connect(function()
          if input.UserInputState == Enum.UserInputState.End then
            v369 = false
          end
        end)
      end
    end)

    textButton2.InputChanged:Connect(function(input2)
      if v369
        and (input2.UserInputType == Enum.UserInputType.MouseMovement
          or input2.UserInputType == Enum.UserInputType.Touch) then
        local v370 = input2.Position - position8

        textButton2.Position = UDim2.new(
          position9.X.Scale, position9.X.Offset + v370.X, position9.Y.Scale,
          position9.Y.Offset + v370.Y
        )
      end
    end)

    textButton2.MouseButton1Click:Connect(function() f75() end)
    textButton2.Visible = false

    return textButton2
  end

  textButton2 = f77()

  f36(userInputService.JumpRequest:Connect(function()
    if not v224 and not v225 then
      return
    end

    local Character_22 = localPlayer2.Character
    local v371

    if not Character_22 or not Character_22.PrimaryPart then
      return
    elseif os.clock() - (v228.__kazanaAt or 0) < 0.35 then
      return
    else
      v228.__kazanaAt = os.clock()
      v371 = v225
      local Effects_2 = replicatedStorage.Assets:FindFirstChild("Effects")

      local Effects3 = Effects_2
        and Effects_2:FindFirstChild(v371 and "KazanaWhite" or "KazanaBlue")

      if not Effects3 then
        return
      end

      v2090 = getthreadidentity and getthreadidentity()

      pcall(function()
        require(Effects3)(Character_22)
        require(replicatedStorage.Tools.Sound).fromName(v371 and "Kazana_White" or "Kazana_Blue")({})
      end)

      return
    end
  end))
end

local f78

local function f79()
  if not v191 then
    return
  else
    local Character_23 = localPlayer2.Character

    if not Character_23 then
      return
    else
      local HumanoidRootPart_9 = Character_23:FindFirstChild("HumanoidRootPart")

      if not HumanoidRootPart_9 then
        return
      else
        local v372 = 10
        local unit4 = nil
        local f63_4 = f63()

        if f63_4 then
          local Vector3_15 = Vector3.new(
            f63_4.Position.X - HumanoidRootPart_9.Position.X, 0,
            f63_4.Position.Z - HumanoidRootPart_9.Position.Z
          )

          if Vector3_15.Magnitude > 0.01 then
            unit4 = Vector3_15.Unit
            v372 = math.clamp(Vector3_15.Magnitude - 1, 0, 16)
          end
        end

        if not unit4 then
          local LookVector_5 = currentCamera2.CFrame.LookVector
          unit4 = Vector3.new(LookVector_5.X, 0, LookVector_5.Z).Unit
        end

        f78(unit4)

        tweenService:Create(HumanoidRootPart_9, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
          CFrame = CFrame.new(HumanoidRootPart_9.Position + unit4 * v372)
            * CFrame.Angles(0, math.rad(HumanoidRootPart_9.Orientation.Y), 0),
        }):Play()

        return
      end
    end
  end
end

function f78(direction)
  local v374 = getthreadidentity and getthreadidentity()

  pcall(function()
    require(replicatedStorage.Content.Effect):Play("KuraiDashFX")({
      Player = localPlayer2,
      Direction = direction,
    })
  end)
end

local function f80()
  local ScreenGui_3 = Instance.new("ScreenGui")
  ScreenGui_3.Name = v176

  hidegui(ScreenGui_3)
  ScreenGui_3.ResetOnSpawn = false

  textButton3 = Instance.new("TextButton")
  textButton3.Size = UDim2.new(0, 50, 0, 50)
  textButton3.Position = UDim2.new(0.15, -25, 0.8, -25)
  textButton3.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
  textButton3.Text = "Dash"
  textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton3.TextScaled = true
  textButton3.Font = Enum.Font.GothamBold
  textButton3.Parent = ScreenGui_3
  textButton3.BackgroundTransparency = 0.2
  textButton3.BorderSizePixel = 0
  textButton3.Selectable = false

  local UICorner_5 = Instance.new("UICorner")
  UICorner_5.CornerRadius = UDim.new(1, 0)
  UICorner_5.Parent = textButton3

  local v375 = false
  local position10, position11

  textButton3.InputBegan:Connect(function(input3)
    if input3.UserInputType == Enum.UserInputType.MouseButton1
      or input3.UserInputType == Enum.UserInputType.Touch then
      v375 = true
      position10 = input3.Position
      position11 = textButton3.Position

      input3.Changed:Connect(function()
        if input3.UserInputState == Enum.UserInputState.End then
          v375 = false
        end
      end)
    end
  end)

  textButton3.InputChanged:Connect(function(input4)
    if v375
      and (input4.UserInputType == Enum.UserInputType.MouseMovement
        or input4.UserInputType == Enum.UserInputType.Touch) then
      local v376 = input4.Position - position10

      textButton3.Position = UDim2.new(
        position11.X.Scale, position11.X.Offset + v376.X, position11.Y.Scale,
        position11.Y.Offset + v376.Y
      )
    end
  end)

  textButton3.MouseButton1Click:Connect(f79)
  textButton3.Visible = false

  return textButton3
end

local function f81()
  if not ballService then
    return
  else
    local f65_3 = f65()

    if not f65_3 then
      return
    else
      local Vector3_16 = Vector3.new(0, -1, 0)
      local Interact_2 = ballService.RF.Interact

      if Interact_2 then
        Interact_2:InvokeServer({
          Charge = 1,
          Move = "Block",
          SpecialCharge = 0,
          TiltDirection = Vector3.new(-0.1260179579258, 1, 0.99202799797058),
          LookVector = Vector3_16,
          MoveDirection = Vector3.new(0, 0, 0),
          ClientCanRunSpecial = false,
          From = "Client",
          BallId = f65_3,
          Timestamp = tick(),
          CustomClient = {},
        })
      end

      return
    end
  end
end

f80()

local function f82()
  local ScreenGui_4 = Instance.new("ScreenGui")
  ScreenGui_4.Name = v176

  hidegui(ScreenGui_4)
  ScreenGui_4.ResetOnSpawn = false

  textButton4 = Instance.new("TextButton")
  textButton4.Size = UDim2.new(0, 50, 0, 50)
  textButton4.Position = UDim2.new(0.35, -25, 0.8, -25)
  textButton4.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
  textButton4.Text = "Stop"
  textButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton4.TextScaled = true
  textButton4.Font = Enum.Font.GothamBold
  textButton4.Parent = ScreenGui_4
  textButton4.BackgroundTransparency = 0.2
  textButton4.BorderSizePixel = 0
  textButton4.Selectable = false

  local UICorner_6 = Instance.new("UICorner")
  UICorner_6.CornerRadius = UDim.new(1, 0)
  UICorner_6.Parent = textButton4

  local v378 = false
  local position12, position13

  textButton4.InputBegan:Connect(function(input5)
    if input5.UserInputType == Enum.UserInputType.MouseButton1
      or input5.UserInputType == Enum.UserInputType.Touch then
      v378 = true
      position12 = input5.Position
      position13 = textButton4.Position

      input5.Changed:Connect(function()
        if input5.UserInputState == Enum.UserInputState.End then
          v378 = false
        end
      end)
    end
  end)

  textButton4.InputChanged:Connect(function(input6)
    if v378
      and (input6.UserInputType == Enum.UserInputType.MouseMovement
        or input6.UserInputType == Enum.UserInputType.Touch) then
      local v379 = input6.Position - position12

      textButton4.Position = UDim2.new(
        position13.X.Scale, position13.X.Offset + v379.X, position13.Y.Scale,
        position13.Y.Offset + v379.Y
      )
    end
  end)

  textButton4.MouseButton1Click:Connect(function() f81() end)
  textButton4.Visible = v189

  return textButton4
end

do
  local function f83()
    local v380 = {
      enabled = false,
      move = "Auto",
      netRange = 9,
      lateral = 14,
      reach = 16,
      delay = 0.05,
      cooldown = 0.5,
      autoJump = true,
    }

    local v381 = false
    local v382 = 0

    local function f84(p160)
      local v383 = getthreadidentity and getthreadidentity()
      return (pcall(p160))
    end

    local v384, gameController

    local function f85()
      if v384 and gameController then
        return true
      end

      f84(function()
        v384 = require(replicatedFirst.Controllers.GameController.Handlers)
        gameController = require(replicatedStorage.Packages.Knit).GetController("GameController")
      end)

      return v384 ~= nil and gameController ~= nil
    end

    local function f86()
      local Tagged = collectionService:GetTagged("Net")[1]

      if Tagged and Tagged:IsA("BasePart") then
        return Tagged
      else
        local Map_4 = workspaceService:FindFirstChild("Map")
        local BallCollideOnly_4 = Map_4 and Map_4:FindFirstChild("BallCollideOnly")
        return BallCollideOnly_4 and BallCollideOnly_4:FindFirstChild("Net")
      end
    end

    local function f87(p161, p162)
      local Team_3 = localPlayer2.Team
      local Value_5 = Team_3 and Team_3:GetAttribute("Index")

      if Value_5 == 1 then
        return -1
      end

      if Value_5 == 2 then
        return 1
      end

      return p161.Position.Z >= p162 and 1 or -1
    end

    local function f88(p163, p164)
      local Z_4 = p164.Position.Z
      local v386 = p164.Position.Y + p164.Size.Y * 0.5
      local f87_2 = f87(p163, Z_4)
      local v388 = (p163.Position.Z - Z_4) * f87_2

      if v388 < 0 or v388 > v380.netRange then
        return nil
      else
        local f63_5 = f63()

        if not f63_5 then
          return nil
        elseif f63_5.Position.Y < v386 - 3 then
          return nil
        elseif math.abs(f63_5.Position.Z - Z_4) > v380.netRange + 6 then
          return nil
        elseif math.abs(f63_5.Position.X - p163.Position.X) > v380.lateral then
          return nil
        else
          local Team_4 = localPlayer2.Team

          for index69, value73 in ipairs(players:GetPlayers()) do
            if value73 ~= localPlayer2 and (Team_4 == nil or value73.Team ~= Team_4) then
              local Character_24 = value73.Character

              local Character20 = Character_24

              Character20 = Character_24
                and Character_24:FindFirstChild("HumanoidRootPart")

              if Character20 and Character_24:GetAttribute("Jumping") then
                local v390 = (Character20.Position.Z - Z_4) * f87_2

                if v390 < 0 and -v390 <= v380.netRange + 4
                  and (f63_5.Position - Character20.Position).Magnitude <= v380.reach
                  and math.abs(Character20.Position.X - p163.Position.X) <= v380.lateral then
                  return f63_5, Z_4, f87_2
                end
              end
            end
          end

          return nil
        end
      end
    end

    local function f89(p165, p166, p167)
      if v380.move ~= "Auto" then
        return v380.move
      end

      if (p165.Position.Z - p166) * p167 > 0 then
        return "Spike"
      end

      return "Block"
    end

    local function f90(actionName)
      if not f85() then
        return
      end

      local States = v384.States

      if States.IsBusy:get() or States.IsStunned:get() or States.IsServing:get() then
        return
      end

      if not States.IsPlaying:get() then
        return
      end

      if replicatedStorage:GetAttribute("ServedByTeam") then
        return
      end

      v381 = true

      task.spawn(function()
        if v380.autoJump and not States.IsJumping:get() then
          f84(function() gameController:PerformJump() end)
        end

        if v380.delay > 0 then
          task.wait(v380.delay)
        end

        f84(function()
          gameController:DoMove({
            ActionName = actionName,
            IsAerial = true,
            InputState = Enum.UserInputState.Begin,
            Metadata = {},
          })
        end)

        v382 = os.clock()
        v381 = false
      end)
    end

    f36(runService.Heartbeat:Connect(function()
      if not v380.enabled or v381 then
        return
      elseif os.clock() - v382 < v380.cooldown then
        return
      else
        local Character_25 = localPlayer2.Character

        local Character21 = Character_25
          and Character_25:FindFirstChild("HumanoidRootPart")

        if not Character21 then
          return
        else
          local f86_2 = f86()

          if not f86_2 then
            return
          else
            local v392, v393, v394 = f88(Character21, f86_2)

            if not v392 then
              return
            end

            f90(f89(v392, v393, v394))
            return
          end
        end
      end
    end))

    return { state = v380 }
  end

  v395 = f83()
end

local f91

local function f92()
  local unit5

  if not ballService then
    return
  else
    local f65_4 = f65()

    if not f65_4 then
      return
    else
      local f91_2 = f91()

      if not f91_2 then
        return
      else
        local HumanoidRootPart_10 = f91_2.Character:FindFirstChild("HumanoidRootPart")

        local Character_26 = localPlayer2.Character
          and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart_10 or not Character_26 then
          return
        else
          local Unit_3 = (HumanoidRootPart_10.Position - Character_26.Position).Unit
          local Vector3_17 = Vector3.new(Unit_3.X, 1, Unit_3.Z)
          local Vector3_18 = Vector3.new(Unit_3.X, 0, Unit_3.Z)

          if Vector3_18.Magnitude > 0 then
            unit5 = Vector3_18.Unit
          else
            unit5 = Vector3.new(0.1756955832243, 9.2147594443759e-8, -0.98444455862045)
          end

          local Interact_3 = ballService.RF.Interact

          if Interact_3 then
            Interact_3:InvokeServer({
              Charge = 1,
              Move = "JumpSet",
              SpecialCharge = 0.99999963647062,
              TiltDirection = Vector3_17,
              LookVector = unit5,
              MoveDirection = Vector3.new(0, 0, 0),
              ClientCanRunSpecial = false,
              From = "Client",
              Timestamp = tick(),
              BallId = f65_4,
              CustomClient = {},
            })
          end

          return
        end
      end
    end
  end
end

function f91()
  local MathHuge_5 = math.huge

  local Character_27 = localPlayer2.Character
    and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

  if not Character_27 then
    return nil
  end

  local v398

  for index70, value74 in ipairs(players:GetPlayers()) do
    if value74 ~= localPlayer2 and value74.Team == localPlayer2.Team then
      local Character_28 = value74.Character

      if Character_28 then
        local HumanoidRootPart_11 = Character_28:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart_11 then
          local Magnitude_6 = (HumanoidRootPart_11.Position - Character_27.Position).Magnitude

          if Magnitude_6 < MathHuge_5 then
            MathHuge_5 = Magnitude_6
            v398 = value74
          end
        end
      end
    end
  end

  return v398
end

local function f93()
  local ScreenGui_5 = Instance.new("ScreenGui")
  ScreenGui_5.Name = v176

  hidegui(ScreenGui_5)
  ScreenGui_5.ResetOnSpawn = false

  textButton5 = Instance.new("TextButton")
  textButton5.Size = UDim2.new(0, 50, 0, 50)
  textButton5.Position = UDim2.new(0.65, -25, 0.8, -25)
  textButton5.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
  textButton5.Text = "Aim"
  textButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton5.TextScaled = true
  textButton5.Font = Enum.Font.GothamBold
  textButton5.Parent = ScreenGui_5
  textButton5.BackgroundTransparency = 0.2
  textButton5.BorderSizePixel = 0
  textButton5.Selectable = false

  local UICorner_7 = Instance.new("UICorner")
  UICorner_7.CornerRadius = UDim.new(1, 0)
  UICorner_7.Parent = textButton5

  local v399 = false
  local position14, position15

  textButton5.InputBegan:Connect(function(input7)
    if input7.UserInputType == Enum.UserInputType.MouseButton1
      or input7.UserInputType == Enum.UserInputType.Touch then
      v399 = true
      position14 = input7.Position
      position15 = textButton5.Position

      input7.Changed:Connect(function()
        if input7.UserInputState == Enum.UserInputState.End then
          v399 = false
        end
      end)
    end
  end)

  textButton5.InputChanged:Connect(function(input8)
    if v399
      and (input8.UserInputType == Enum.UserInputType.MouseMovement
        or input8.UserInputType == Enum.UserInputType.Touch) then
      local v400 = input8.Position - position14

      textButton5.Position = UDim2.new(
        position15.X.Scale, position15.X.Offset + v400.X, position15.Y.Scale,
        position15.Y.Offset + v400.Y
      )
    end
  end)

  textButton5.MouseButton1Click:Connect(function() f92() end)
  textButton5.Visible = v190

  return textButton5
end

do
  f36(runService.RenderStepped:Connect(function()
    if not v199 then
      if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
      end

      return
    else
      local Character_29 = localPlayer2.Character
      local Humanoid_5 = Character_29 and Character_29:FindFirstChildOfClass("Humanoid")

      local Character23 = Character_29
      Character23 = Character_29 and Character_29:FindFirstChild("HumanoidRootPart")

      local v401 = not Humanoid_5
      local HumanoidRootPart21 = Character23

      if v401 or not HumanoidRootPart21 then
        return
      else
        if not bodyVelocity or bodyVelocity.Parent ~= HumanoidRootPart21 then
          if bodyVelocity then
            bodyVelocity:Destroy()
          end

          bodyVelocity = Instance.new("BodyVelocity")
          bodyVelocity.Name = v176
          bodyVelocity.MaxForce = Vector3.zero
          bodyVelocity.Velocity = Vector3.zero
          bodyVelocity.P = 12500
          bodyVelocity.Parent = HumanoidRootPart21
        end

        local MoveDirection = Humanoid_5.MoveDirection

        if MoveDirection.Magnitude == 0 then
          if v228.__controls == nil then
            local v403, v404 = pcall(function()
              return require(localPlayer2.PlayerScripts.PlayerModule):GetControls()
            end)

            v228.__controls = v403 and v404 or false
          end

          if v228.__controls then
            local v405, vectorToWorldSpace = pcall(
              v228.__controls.GetMoveVector, v228.__controls
            )

            if v405 and typeof(vectorToWorldSpace) == "Vector3"
              and vectorToWorldSpace.Magnitude > 0 then
              local CurrentCamera_2 = workspaceService.CurrentCamera

              if CurrentCamera_2 then
                vectorToWorldSpace = CurrentCamera_2.CFrame:VectorToWorldSpace(vectorToWorldSpace)
              end

              MoveDirection = Vector3.new(vectorToWorldSpace.X, 0, vectorToWorldSpace.Z)
            end
          end
        end

        if Humanoid_5.FloorMaterial == Enum.Material.Air and MoveDirection.Magnitude > 0 then
          bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
          bodyVelocity.Velocity = MoveDirection.Unit * v200
        else
          bodyVelocity.MaxForce = Vector3.zero
          bodyVelocity.Velocity = Vector3.zero
        end

        return
      end
    end
  end))

  local function f94(p168)
    if not p168.Character or v194[p168] then
      return
    else
      local Color3_3 = Color3.fromRGB(255, 72, 72)

      local Highlight = Instance.new("Highlight")
      Highlight.Name = v176
      Highlight.Adornee = p168.Character
      Highlight.FillColor = Color3_3
      Highlight.FillTransparency = 0.72
      Highlight.OutlineTransparency = 0
      Highlight.OutlineColor = Color3_3
      Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      Highlight.Parent = p168.Character

      v194[p168] = Highlight
      return
    end
  end

  local function f95(p169)
    if p169 == localPlayer2 then
      return false
    end

    if not p169.Team or not localPlayer2.Team then
      return false
    end

    return p169.Team ~= localPlayer2.Team
  end

  local function f97(p170)
    if v195[p170] then
      for key9, value75 in pairs(v195[p170]) do
        value75:Disconnect()
      end

      v195[p170] = nil
    end

    f96(p170)
  end

  function f96(p171)
    if v194[p171] then
      v194[p171]:Destroy()
      v194[p171] = nil
    end
  end

  local function f98(p172)
    if p172 == localPlayer2 then
      return
    else
      local function f99(p173)
        f97(p172)
        local Humanoid_6 = p173:WaitForChild("Humanoid", 3)

        if not Humanoid_6 or not p173:FindFirstChild("Head") then
          return
        else
          local Connection_2 = Humanoid_6.StateChanged:Connect(function(p174, p175)
            if not v193 or not f95(p172) then
              f96(p172)
              return
            end

            if p175 == Enum.HumanoidStateType.Jumping or p175 == Enum.HumanoidStateType.Freefall then
              f94(p172)
            elseif p175 == Enum.HumanoidStateType.Landed
              or p175 == Enum.HumanoidStateType.Running then
              f96(p172)
            end
          end)

          local Connection_3 = runService.Heartbeat:Connect(function()
            if not v193 or not p172.Character or not f95(p172) then
              f96(p172)
              return
            else
              local GetState = Humanoid_6:GetState()

              if GetState == Enum.HumanoidStateType.Jumping
                or GetState == Enum.HumanoidStateType.Freefall then
                f94(p172)
              else
                f96(p172)
              end

              return
            end
          end)

          v195[p172] = { f36(Connection_2), f36(Connection_3) }
          return
        end
      end

      if p172.Character then
        f99(p172.Character)
      end

      f36(p172.CharacterAdded:Connect(f99))
      return
    end
  end

  for index71, value76 in ipairs(players:GetPlayers()) do
    f98(value76)
  end

  f36(players.PlayerAdded:Connect(f98))
end

local function f100()
  v197 = false
end

local namecall7, v406

local function f101()
  v197 = true

  if v198 then
    return
  end

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  end

  v406 = getrawmetatable(game)
  namecall7 = v406.__namecall
  setreadonly(v406, false)

  function v406.__namecall(p176, ...)
    local GetNamecallMethod_8 = getnamecallmethod()
    local v408 = p176 == serve
    local V408 = v408
    local v410 = { ... }

    if v408 then
      V408 = GetNamecallMethod_8 == "InvokeServer" and v197
    end

    if V408 then
      v410[2] = 5
      return namecall7(p176, unpack(v410))
    end

    return namecall7(p176, ...)
  end

  setreadonly(v406, true)
  v198 = true
end

local connect6

local function f102()
  local primaryPart, humanoid6, metadata, gameController2, v411

  if not v192 then
    return
  else
    local Character_30 = localPlayer2.Character

    if not Character_30 or not Character_30.PrimaryPart then
      return
    end

    primaryPart = Character_30.PrimaryPart
    humanoid6 = Character_30:FindFirstChildOfClass("Humanoid")

    if not humanoid6 or humanoid6.Health <= 0 then
      return
    end

    metadata = { Acceleration = -10000, TerminalVelocity = -300, Duration = 2 }
    gameController2 = nil
    v2368 = getthreadidentity and getthreadidentity()

    pcall(function()
      local Module_2 = require(replicatedStorage.Content.Ability.LeadFeet)

      if type(Module_2) == "table" and type(Module_2.Metadata) == "table" then
        metadata = Module_2.Metadata
      end

      gameController2 = require(replicatedStorage.Packages.Knit).GetController("GameController")

      if gameController2 then
        gameController2.IsBusy:set(false)
      end

      require(replicatedStorage.Content.Effect):Play("LeadFeetFX")({ Player = localPlayer2 })
      require(replicatedFirst.Controllers.GameController.Actions.Move.Jump).stop()

      if gameController2 then
        gameController2.IsBusy:set(true)
      end
    end)

    if connect6 then
      connect6:Disconnect()
      connect6 = nil
    end

    v411 = os.clock() + (metadata.Duration or 2)

    connect6 = runService.Heartbeat:Connect(function(delta)
      if not primaryPart.Parent or humanoid6.FloorMaterial ~= Enum.Material.Air
        or os.clock() >= v411 then
        if gameController2 then
          gameController2.IsBusy:set(false)
        end

        if connect6 then
          connect6:Disconnect()
          connect6 = nil
        end

        return
      else
        local AssemblyLinearVelocity_2 = primaryPart.AssemblyLinearVelocity

        local MathMax_5 = math.max(AssemblyLinearVelocity_2.Y
          + (metadata.Acceleration or -10000) * delta, metadata.TerminalVelocity or -300)

        primaryPart.AssemblyLinearVelocity = Vector3.new(
          AssemblyLinearVelocity_2.X, MathMax_5, AssemblyLinearVelocity_2.Z
        )

        return
      end
    end)

    return
  end
end

do
  local function f103()
    local ScreenGui_6 = Instance.new("ScreenGui")
    ScreenGui_6.Name = v176

    hidegui(ScreenGui_6)
    ScreenGui_6.ResetOnSpawn = false

    textButton6 = Instance.new("TextButton")
    textButton6.Size = UDim2.new(0, 50, 0, 50)
    textButton6.Position = UDim2.new(0.25, -25, 0.8, -25)
    textButton6.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    textButton6.Text = "LF"
    textButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
    textButton6.TextScaled = true
    textButton6.Font = Enum.Font.GothamBold
    textButton6.Parent = ScreenGui_6
    textButton6.BackgroundTransparency = 0.2
    textButton6.BorderSizePixel = 0
    textButton6.Selectable = false

    local UICorner_8 = Instance.new("UICorner")
    UICorner_8.CornerRadius = UDim.new(1, 0)
    UICorner_8.Parent = textButton6

    local v414 = false
    local position16, position17

    textButton6.InputBegan:Connect(function(input9)
      if input9.UserInputType == Enum.UserInputType.MouseButton1
        or input9.UserInputType == Enum.UserInputType.Touch then
        v414 = true
        position16 = input9.Position
        position17 = textButton6.Position

        input9.Changed:Connect(function()
          if input9.UserInputState == Enum.UserInputState.End then
            v414 = false
          end
        end)
      end
    end)

    textButton6.InputChanged:Connect(function(input10)
      if v414
        and (input10.UserInputType == Enum.UserInputType.MouseMovement
          or input10.UserInputType == Enum.UserInputType.Touch) then
        local v415 = input10.Position - position16

        textButton6.Position = UDim2.new(
          position17.X.Scale, position17.X.Offset + v415.X, position17.Y.Scale,
          position17.Y.Offset + v415.Y
        )
      end
    end)

    textButton6.MouseButton1Click:Connect(f102)
    textButton6.Visible = false

    return textButton6
  end

  f103()

  local function f104()
    v211 = {}
    local Module_3 = require(replicatedStorage.Content.Item)
    local Entities_2 = replicatedStorage.Content.Item:FindFirstChild("Entities")

    if Entities_2 and Module_3 and Module_3.Type then
      for index72, value77 in ipairs(Entities_2:GetChildren()) do
        if value77:IsA("ModuleScript") then
          local Module_4 = require(value77)

          if Module_4 and type(Module_4) == "table" and Module_4.Type == Module_3.Type.Jersey then
            table.insert(v211, tostring(Module_4.Id or value77.Name))
          end
        end
      end
    end

    if #v211 == 0 then
      local Assets_2 = replicatedStorage.Assets
        and replicatedStorage.Assets:FindFirstChild("Jersey")

      if Assets_2 then
        for index73, value78 in ipairs(Assets_2:GetChildren()) do
          table.insert(v211, value78.Name)
        end
      end
    end

    table.sort(v211)
    return v211
  end

  f104()
end

local function f105(p177)
  local Character_31 = localPlayer2.Character

  if not Character_31 or not Character_31:FindFirstChild("UpperTorso") then
    return false
  end

  local Assets_3 = replicatedStorage:FindFirstChild("Assets")
  Assets_3 = Assets_3 and Assets_3:FindFirstChild("Jersey")

  if not Assets_3 then
    return false
  else
    if not v228.__jerseyHook then
      v228.__jerseyHook = localPlayer2.CharacterAdded:Connect(function(character26)
        v418 = nil

        if character26:WaitForChild("UpperTorso", 10) and v219 then
          task.wait(1)
          f105(jersey)
        end
      end)
    end

    local function f106()
      for index74, value79 in ipairs(Character_31:GetChildren()) do
        if value79.Name == "JerseyFront" or value79.Name == "JerseyBack"
          or value79.Name == "_jerseyInstances" or value79:IsA("Clothing")
          or value79:IsA("ShirtGraphic") then
          value79:Destroy()
        end
      end
    end

    if not v219 then
      local v419 = v226[Character_31]

      if v419 then
        f106()

        for index75, value80 in ipairs(v419) do
          local Clone = value80:Clone()

          if Clone:IsA("SurfaceGui") then
            Clone.Adornee = Character_31:FindFirstChild("UpperTorso")
          end

          Clone.Parent = Character_31
        end

        v226[Character_31] = nil
      end

      v418 = nil
      return true
    else
      if not v226[Character_31] then
        local v420 = {}

        for index76, value81 in ipairs(Character_31:GetChildren()) do
          if value81.Name == "JerseyFront" or value81.Name == "JerseyBack"
            or value81:IsA("Clothing") or value81:IsA("ShirtGraphic") then
            table.insert(v420, value81:Clone())
          end
        end

        v226[Character_31] = v420
      end

      local function f107()
        local Shirt = Character_31:FindFirstChildOfClass("Shirt")

        if not Shirt then
          return nil
        end

        for index77, value82 in ipairs(Assets_3:GetChildren()) do
          for index78, value83 in ipairs(value82:GetChildren()) do
            local Shirt_2 = value83:FindFirstChild("Shirt")

            if Shirt_2 and Shirt_2:IsA("Shirt") and Shirt_2.ShirtTemplate == Shirt.ShirtTemplate then
              return value83.Name
            end
          end
        end

        return nil
      end

      local v421, v422 = pcall(require, replicatedStorage.Tools.Jersey)

      if not v421 or type(v422) ~= "table" or not v422.set then
        return false
      else
        v418 = v418 or f107()

        local v423, v424 = pcall(v422.set, {
          Player = localPlayer2,
          Character = Character_31,
          Id = p177 or jersey,
          TeamName = v418,
        })

        if not v423 then
          warn("[LOCOPANI] jersey apply failed: " .. tostring(v424))
          return false
        end

        v418 = v418 or f107()
        return true
      end
    end
  end
end

local function f108()
  local Assets_4 = replicatedStorage:FindFirstChild("Assets")
  Assets_4 = Assets_4 and Assets_4:FindFirstChild("Ball")

  local f109

  if not Assets_4 then
    return
  else
    function f109(p178)
      local v425 = v227[p178]

      if v425 then
        v425:Destroy()
        v227[p178] = nil
      end

      local v426 = v226[p178]

      if v426 then
        for key10, value84 in pairs(v426) do
          local Key10 = key10
          local Value84 = value84

          if Key10.Parent then
            pcall(function() Key10[Value84.field] = Value84.value end)
          end
        end

        v226[p178] = nil
      end
    end

    local function f110(p179)
      local PrimaryPart = p179.PrimaryPart

      local PrimaryPart2 = PrimaryPart
      PrimaryPart2 = PrimaryPart or p179:FindFirstChildWhichIsA("BasePart")

      local Assets3 = Assets_4
      local BasePart2 = PrimaryPart2
      local v431 = not BasePart2
      local Child = Assets3:FindFirstChild(ball)
      local v432

      if v431 or not Child then
        return
      else
        f109(p179)
        local GetDescendants = p179.GetDescendants
        v432 = {}

        local function f111(p180, p181, p182)
          v432[p180] = { field = p181, value = p180[p181] }
          p180[p181] = p182
        end

        for index79, value85 in ipairs(GetDescendants(p179)) do
          if value85:IsA("BasePart") then
            if value85.Name ~= v176 then
              f111(value85, "Transparency", 1)
            end
          elseif value85:IsA("Decal") or value85:IsA("Texture") then
            f111(value85, "Transparency", 1)
          elseif value85:IsA("Trail") or value85:IsA("ParticleEmitter") or value85:IsA("Beam")
            or value85:IsA("Light") or value85:IsA("Smoke") or value85:IsA("Fire")
            or value85:IsA("Sparkles") then
            f111(value85, "Enabled", false)
          end
        end

        v226[p179] = v432

        local Clone_2 = Child:Clone()
        Clone_2.Name = v177
        Clone_2.Parent = p179

        local v433 = {}

        if Clone_2:IsA("BasePart") then
          v433[#v433 + 1] = Clone_2
        end

        for index80, value86 in ipairs(Clone_2:GetDescendants()) do
          if value86:IsA("BasePart") then
            v433[#v433 + 1] = value86
          end
        end

        local IsType_2 = Clone_2:IsA("Model") and Clone_2.PrimaryPart or nil

        if not IsType_2 then
          local v434 = nil

          for index81, value87 in ipairs(v433) do
            if value87:IsA("BasePart") then
              local Z_5 = value87.Size.X * value87.Size.Y * value87.Size.Z
              local MathAbs_3 = math.abs(value87.Size.X - value87.Size.Y) < 0.5

              local V436 = MathAbs_3
              V436 = MathAbs_3 and math.abs(value87.Size.Y - value87.Size.Z) < 0.5

              local V435 = Z_5

              if value87:IsA("Part") and value87.Shape == Enum.PartType.Ball then
                V435 = V435 * 6
              elseif V436 then
                V435 = V435 * 3
              end

              if not v434 or V435 > v434 then
                IsType_2 = value87
                v434 = V435
              end
            end
          end
        end

        if IsType_2 then
          local ToObjectSpace = Clone_2:GetPivot():ToObjectSpace(IsType_2.CFrame)
          Clone_2:PivotTo(BasePart2.CFrame * ToObjectSpace:Inverse())
        else
          Clone_2:PivotTo(BasePart2.CFrame)
        end

        for index82, value88 in ipairs(v433) do
          value88.Anchored = false
          value88.CanCollide = false
          value88.CanQuery = false
          value88.CanTouch = false
          value88.Massless = true

          local WeldConstraint = Instance.new("WeldConstraint")
          WeldConstraint.Part0 = BasePart2
          WeldConstraint.Part1 = value88
          WeldConstraint.Parent = value88
        end

        v227[p179] = Clone_2
        return
      end
    end

    local v439 = {}

    for key11 in pairs(v227) do
      table.insert(v439, key11)
    end

    for index83, value89 in ipairs(v439) do
      f109(value89)
    end

    if not v220 then
      return
    end

    for index84, value90 in ipairs(workspaceService:GetChildren()) do
      if value90:IsA("Model") and value90.Name:match("^CLIENT_BALL_") then
        f110(value90)
      end
    end

    if not v228.__ballHook then
      v228.__ballHook = workspaceService.ChildAdded:Connect(function(child6)
        if not v220 or not child6:IsA("Model") or not child6.Name:match("^CLIENT_BALL_") then
          return
        end

        task.spawn(function()
          local count3 = 0

          while true do
            count3 = 1 + count3

            if not (40 >= count3) then
              break
            end

            if child6.PrimaryPart or child6:FindFirstChildWhichIsA("BasePart") then
              break
            end

            task.wait(0.05)
          end

          if v220 and child6.Parent then
            f108()
          end
        end)
      end)
    end

    return
  end
end

v440 = { enabled = false, hooked = false, charge = 1 }

function v440.effect(isStrong)
  local Character_32 = localPlayer2.Character
  local v441 = not Character_32
  local superDive

  if v441 or not Character_32.PrimaryPart then
    return
  else
    local Assets_5 = replicatedStorage:FindFirstChild("Assets")
    local Effects_3 = Assets_5 and Assets_5:FindFirstChild("Effects")
    superDive = Effects_3 and Effects_3:FindFirstChild("SuperDive")

    if not superDive then
      return
    end

    v2599 = getthreadidentity and getthreadidentity()
    pcall(function() task.spawn(require(superDive), Character_32, { IsStrong = isStrong }) end)
    return
  end
end

function v440.install()
  local dive

  if v440.hooked then
    return
  else
    local v442, v443 = pcall(require, replicatedStorage.Packages.Knit)

    if not v442 then
      return
    else
      local v444, v445 = pcall(v443.GetController, "GameController")

      if not v444 or type(v445) ~= "table" or type(v445.Dive) ~= "function" then
        return
      end

      dive = v445.Dive

      function v445.Dive(p183, p184, ...)
        local P184 = p184

        if not v440.enabled then
          return dive(p183, P184, ...)
        else
          local MathClamp_5 = math.clamp(v440.charge, 0, 1)
          local v448, v449 = pcall(require, replicatedStorage.Content.Style.Kimiro.Special)
          local Metadata = v448 and type(v449) == "table" and v449.Metadata

          if type(Metadata) == "table" then
            P184 = type(P184) == "table" and P184 or {}
            P184.MaxForce = Metadata.MaxForce
            P184.TimeScale = Metadata.TimeScale
            P184.StretchSpeedFactor = Metadata.StretchSpeedFactor
            P184.EasingStyle = Metadata.EasingStyle
            P184.Debounce = Metadata.Debounce

            if not P184.Target and typeof(Metadata.Power) == "NumberRange" then
              local Character_33 = localPlayer2.Character

              local Character28 = Character_33
              Character28 = Character_33 and Character_33:FindFirstChildOfClass("Humanoid")

              local moveDirection2 = Character28 and Character28.MoveDirection or Vector3.zero

              if moveDirection2.Magnitude < 0.5 and Character_33 then
                moveDirection2 = Character_33:GetPivot().LookVector
              end

              local Vector3_19 = Vector3.new(moveDirection2.X, 0, moveDirection2.Z)

              if Vector3_19.Magnitude > 0.01 then
                P184.Target = Vector3_19.Unit
                  * (Metadata.Power.Min + (Metadata.Power.Max - Metadata.Power.Min) * MathClamp_5)
              end
            end
          end

          local dive_2 = dive(p183, P184, ...)

          if dive_2 ~= nil then
            v440.effect(MathClamp_5 >= 0.5)
          end

          return dive_2
        end
      end

      v440.hooked = true
      return
    end
  end
end

v451 = { real = nil, want = {} }

function v451.mark(p185, p186)
  v451.want[p185] = p186 or nil

  if p186 then
    v451.wear()
  end

  local v452, v453 = pcall(require, replicatedStorage.Packages.Knit)
  local v454

  if not v452 then
    return
  else
    local v455, v456 = pcall(v453.GetController, "InventoryController")

    if not v455 or type(v456) ~= "table" or not v456.Inventory then
      return
    else
      local v457, v458 = pcall(function() return v456.Inventory:get() end)

      if not v457 or type(v458) ~= "table" then
        return
      else
        local TypeName_4 = type(getgenv) == "function" and getgenv() or _G

        local TypeName_5 = type(TypeName_4.LOCOPANI_SESSION) == "table" and TypeName_4.LOCOPANI_SESSION
          or nil

        if not v451.real then
          local vault2 = TypeName_5 and TypeName_5.vault or nil

          if vault2 and vault2.inventory then
            v451.real = vault2.inventory
            v451.realTitle = vault2.title
            v451.realEquipped = vault2.equipped or {}
          else
            local v459 = {}

            for key12, value91 in pairs(v458) do
              v459[key12] = value91
            end

            v451.real = v459
            v451.realTitle = localPlayer2:GetAttribute("User_Title")

            local v460, v461 = pcall(function() return v456.Equipped:get() end)
            local v462 = {}

            if v460 and type(v461) == "table" then
              for key13, value92 in pairs(v461) do
                v462[key13] = value92
              end
            end

            v451.realEquipped = v462

            if TypeName_5 then
              TypeName_5.vault = {
                inventory = v451.real,
                title = v451.realTitle,
                equipped = v451.realEquipped,
              }
            end
          end
        end

        local v463 = false
        local v464, v465, v466 = pairs(v451.want)

        if v464(v465, v466) then
          v463 = true
        end

        if not v463 then
          pcall(function() v456.Inventory:set(v451.real) end)
          v451.real = nil

          if TypeName_5 then
            TypeName_5.vault = nil
          end

          return
        else
          local v467, v468 = pcall(require, replicatedStorage.Content.Item)
          local Item = replicatedStorage.Content.Item
          local v469 = not v467
          local Entities_3 = Item:FindFirstChild("Entities")

          if v469 or not Entities_3 then
            return
          end

          v454 = {}

          for key14, value93 in pairs(v451.real) do
            v454[key14] = value93
          end

          for index85, value94 in ipairs(Entities_3:GetChildren()) do
            if value94:IsA("ModuleScript") and not v454[value94.Name] then
              local v470, v471 = pcall(require, value94)

              if v470 and type(v471) == "table" and v471.Type then
                for key15 in pairs(v451.want) do
                  if v471.Type == v468.Type[key15] then
                    v454[value94.Name] = 1
                    break
                  end
                end
              end
            end
          end

          pcall(function() v456.Inventory:set(v454) end)
          return
        end
      end
    end
  end
end

function v451.typeOf(p187)
  local Entities_4 = replicatedStorage.Content.Item:FindFirstChild("Entities")
  local Child_2 = Entities_4 and Entities_4:FindFirstChild(p187)

  if not Child_2 then
    return nil
  else
    local v472, v473 = pcall(require, Child_2)

    if v472 and type(v473) == "table" and v473.Type then
      return v473.Type, v473
    end

    return nil
  end
end

function v451.paint(p188, p189, p190)
  local realEquipped = v451.realEquipped or {}

  if p188 == "Title" then
    pcall(function()
      localPlayer2:SetAttribute(
        "User_Title", p189 and (p190 and p190.DisplayName or p189) or v451.realTitle
      )
    end)
  elseif p188 == "ScoreEffect" then
    scoreEffect = p189 or realEquipped.ScoreEffect or "SupernovaScoreEffect"
  elseif p188 == "Ball" then
    ball = p189 or realEquipped.Ball or "ClassicBall"
    task.spawn(function() pcall(f108) end)
  elseif p188 == "Jersey" then
    jersey = p189 or realEquipped.Jersey or "DragonTuxedoJersey"
    v418 = nil
    task.spawn(function() pcall(f105, jersey) end)
  elseif p188 == "PlayerCard" then
    if p189 then
      v207 = p189
    end
  end
end

function v451.setSlot(p191, p192)
  -- Visual-only equip: update the local Equipped store so the UI/game client
  -- reacts to the selected cosmetic without claiming ownership on the server.
  local okKnit, Knit = pcall(require, replicatedStorage.Packages.Knit)
  if not okKnit or not Knit then return false end

  local okController, inventoryController = pcall(Knit.GetController, "InventoryController")
  if not okController or type(inventoryController) ~= "table" or not inventoryController.Equipped then
    return false
  end

  local okEquipped, currentEquipped = pcall(function()
    return inventoryController.Equipped:get()
  end)
  if not okEquipped or type(currentEquipped) ~= "table" then return false end

  local updatedEquipped = {}
  for key, value in pairs(currentEquipped) do
    updatedEquipped[key] = value
  end

  if p192 == nil or p192 == false or p192 == "" then
    updatedEquipped[p191] = nil
  else
    updatedEquipped[p191] = p192
  end

  local okSet = pcall(function()
    inventoryController.Equipped:set(updatedEquipped)
  end)
  if not okSet then return false end

  -- Keep v451.realEquipped unchanged: it stores the player's original items
  -- so the visual spoof can be reverted cleanly when the toggle is disabled.
  return true
end

function v451.currentSlot(p193)
  local v480, v481 = pcall(require, replicatedStorage.Packages.Knit)
  local v482

  if not v480 then
    return nil
  else
    local v483
    v483, v482 = pcall(v481.GetController, "InventoryController")

    if not v483 or type(v482) ~= "table" or not v482.Equipped then
      return nil
    else
      local v484, v485 = pcall(function() return v482.Equipped:get() end)

      if v484 and type(v485) == "table" then
        return v485[p193]
      end

      return nil
    end
  end
end

function v451.dress(p194)
  local v486, v487 = v451.typeOf(p194)

  if not v486 then
    return false
  end

  if v486 == "Title" or v486 == "ScoreEffect" or v486 == "Ball" or v486 == "Jersey"
    or v486 == "PlayerCard" then
    v451.paint(v486, p194, v487)
    v451.setSlot(v486, p194)
    return true
  end

  if v486 ~= "ProfileArt" then
    return false
  end

  v451.setSlot(v486, p194)
  return true
end

function v451.revert(p195)
  local realEquipped2 = v451.realEquipped and v451.realEquipped[p195] or nil
  v451.paint(p195, nil)
  v451.setSlot(p195, realEquipped2)
end

function v451.wear()
  if v451.worn then
    return
  end

  local v488, namecall8

  if not (getrawmetatable and setreadonly and getnamecallmethod) then
    return
  else
    local v489

    v489, v488 = pcall(function()
      return replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RF.Equip
    end)

    if not v489 or not v488 then
      return
    else
      local GetRawMetatable_7 = getrawmetatable(game)
      namecall8 = GetRawMetatable_7.__namecall
      setreadonly(GetRawMetatable_7, false)

      function GetRawMetatable_7.__namecall(p196, ...)
        local v491 = { ... }

        if p196 == v488 and getnamecallmethod() == "InvokeServer" then
          local v492 = v491[1]

          if type(v492) == "string" and v451.real then
            local v493, v494 = v451.typeOf(v492)

            if not v451.real[v492] then
              if v493 and v451.currentSlot(v493) == v492 then
                v451.revert(v493)
                return true
              end

              v451.dress(v492)
              return true
            elseif v493 then
              v451.paint(v493, v492, v494)
            end
          end

          return namecall8(p196, unpack(v491))
        end

        return namecall8(p196, unpack(v491))
      end

      setreadonly(GetRawMetatable_7, true)
      v451.worn = true
      return
    end
  end
end

v495 = {
  enabled = false,
  marker = nil,
  label = nil,
  tracked = nil,
  last = nil,
  stamp = 0,
  drift = Vector3.zero,
}

function v495.clear()
  if v495.marker then
    v495.marker:Destroy()
    v495.marker = nil
    v495.label = nil
  end

  v495.tracked = nil
  v495.last = nil
  v495.drift = Vector3.zero
end

function v495.build()
  local Part_2 = Instance.new("Part")
  Part_2.Name = v176
  Part_2.Shape = Enum.PartType.Cylinder
  Part_2.Size = Vector3.new(0.2, 7, 7)
  Part_2.Anchored = true
  Part_2.CanCollide = false
  Part_2.CanQuery = false
  Part_2.CanTouch = false
  Part_2.Material = Enum.Material.Neon
  Part_2.Transparency = 0.35
  Part_2.CastShadow = false
  Part_2.Parent = currentCamera2

  local BillboardGui = Instance.new("BillboardGui")
  BillboardGui.Size = UDim2.new(0, 90, 0, 30)
  BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
  BillboardGui.AlwaysOnTop = true
  BillboardGui.Parent = Part_2

  local TextLabel_4 = Instance.new("TextLabel")
  TextLabel_4.Size = UDim2.fromScale(1, 1)
  TextLabel_4.BackgroundTransparency = 1
  TextLabel_4.TextScaled = true
  TextLabel_4.Font = Enum.Font.GothamBold
  TextLabel_4.TextStrokeTransparency = 0
  TextLabel_4.Parent = BillboardGui

  v495.marker = Part_2
  v495.label = TextLabel_4
end

function v495.gravity()
  local v496, v497 = pcall(function()
    local Module_5 = require(replicatedStorage.Configuration.Game)
    local Module_6 = require(replicatedStorage.Common.State)
    return Module_6.get(replicatedStorage, Module_6.Id.Modifier, "BallGravity", Module_5.Physics.Gravity)
  end)

  if v496 and type(v497) == "number" and v497 > 0 then
    return v497
  end

  return 17
end

function v495.velocity(p197)
  local v500, v501 = pcall(require, replicatedStorage.Packages.Knit)

  if v500 then
    local v502, v503 = pcall(v501.GetController, "BallController")

    if v502 and type(v503) == "table" and type(v503.ActiveBalls) == "table" then
      for key17, value96 in pairs(v503.ActiveBalls) do
        local Ball_2 = value96.Ball

        if Ball_2 and Ball_2.Parent and Ball_2:IsAncestorOf(p197)
          and typeof(value96.Velocity) == "Vector3" then
          return value96.Velocity
        end
      end
    end

    return v495.drift
  end

  return v495.drift
end

function v495.solve(p198, p199, p200, p201)
  local v504 = p198.Y - p201

  if v504 < 0 then
    return nil
  else
    local v505 = p199.Y * p199.Y + 2 * p200 * v504

    if v505 < 0 then
      return nil
    else
      local Sqrt = (p199.Y + math.sqrt(v505)) / p200

      if Sqrt ~= Sqrt or Sqrt <= 0 or Sqrt > 15 then
        return nil
      end

      return Sqrt
    end
  end
end

function v495.netHit(p202, p203, p204, p205)
  local Map_5 = workspaceService:FindFirstChild("Map")
  local BallCollideOnly_5 = Map_5 and Map_5:FindFirstChild("BallCollideOnly")
  local Net_4 = BallCollideOnly_5 and BallCollideOnly_5:FindFirstChild("Net")

  if not Net_4 then
    return false
  else
    local Z_6 = Net_4.Position.Z - p202.Z

    if math.abs(p203.Z) < 0.01 then
      return false
    else
      local Z_7 = Z_6 / p203.Z

      if Z_7 <= 0 or Z_7 >= p205 then
        return false
      else
        local v509 = p202.Y + p203.Y * Z_7 - 0.5 * p204 * Z_7 * Z_7
        local v510 = p202.X + p203.X * Z_7

        if v509 > Net_4.Position.Y + Net_4.Size.Y * 0.5
          or v509 < Net_4.Position.Y - Net_4.Size.Y * 0.5 then
          return false
        end

        return math.abs(v510 - Net_4.Position.X) <= Net_4.Size.X * 0.5
      end
    end
  end
end

function v495.predict(p206)
  local v511, v512 = pcall(require, replicatedStorage.Common.Physics)

  if not v511 then
    return nil
  else
    local Gravity = v495.gravity()
    local Position_7 = p206.Position
    local Velocity = v495.velocity(p206)

    if typeof(Velocity) ~= "Vector3" then
      return nil
    else
      local LastFloorHeight = v512.LastFloorHeight

      if not LastFloorHeight then
        local v515, v516 = pcall(v512.calculateFloorHeight, Position_7, true)
        LastFloorHeight = v515 and v516 or nil
      end

      if not LastFloorHeight then
        return nil
      else
        local Solve = v495.solve(Position_7, Velocity, Gravity, LastFloorHeight)

        if not Solve then
          return nil
        else
          local Vector3_20 = Vector3.new(
            Position_7.X + Velocity.X * Solve, LastFloorHeight, Position_7.Z + Velocity.Z * Solve
          )

          local v518, v519 = pcall(
            v512.calculateFloorHeight, Vector3.new(Vector3_20.X, Position_7.Y, Vector3_20.Z), true
          )

          if v518 and type(v519) == "number" and math.abs(v519 - LastFloorHeight) > 0.05 then
            local Solve_2 = v495.solve(Position_7, Velocity, Gravity, v519)

            if Solve_2 then
              Solve = Solve_2

              Vector3_20 = Vector3.new(
                Position_7.X + Velocity.X * Solve, v519, Position_7.Z + Velocity.Z * Solve
              )
            end
          end

          return Vector3_20, v512, Solve, v495.netHit(Position_7, Velocity, Gravity, Solve)
        end
      end
    end
  end
end

local RenderStepped = runService.RenderStepped

local function f112(p207)
  v201 = p207

  if not p207 then
    local Character_34 = localPlayer2.Character

    if Character_34 then
      local Humanoid_7 = Character_34:FindFirstChild("Humanoid")

      if Humanoid_7 then
        Humanoid_7.AutoRotate = false
      end
    end
  end
end

f36(RenderStepped:Connect(function()
  local v521, color5

  if not v495.enabled then
    if v495.marker then
      v495.clear()
    end

    return
  else
    local f63_6 = f63()

    if not f63_6 then
      if v495.marker then
        v495.marker.Transparency = 1
      end

      v495.last = nil
      return
    else
      local OsClock = os.clock()

      if v495.tracked == f63_6 and v495.last and OsClock > v495.stamp then
        v495.drift = (f63_6.Position - v495.last) / (OsClock - v495.stamp)
      end

      v495.tracked = f63_6
      v495.last = f63_6.Position
      v495.stamp = OsClock

      local v524, v525, v526, v527 = v495.predict(f63_6)

      if not v524 then
        if v495.marker then
          v495.marker.Transparency = 1
        end

        return
      else
        if not v495.marker then
          v495.build()
        end

        local GetCourtlines_2 = v525._getCourtlines and v525._getCourtlines()
        local v528 = true

        if GetCourtlines_2 and v525.isPositionInCourt then
          local v529, v530 = pcall(v525.isPositionInCourt, v524, nil, f63_6.Size.X * 0.5, nil)
          v528 = not v529 or v530
        end

        if v527 then
          color5 = Color3.fromRGB(250, 180, 40)
          v521 = "NET"
        elseif v528 then
          color5 = Color3.fromRGB(60, 220, 90)
          v521 = "IN"
        else
          local Color3_4 = Color3.fromRGB(235, 60, 60)
          v521 = "OUT"
          color5 = Color3_4
        end

        local MathClamp_6 = math.clamp(1 - v526 / 2, 0, 1)
        local v532 = 6 + MathClamp_6 * 3

        v495.marker.Size = Vector3.new(0.2, v532, v532)
        v495.marker.Transparency = 0.35 - MathClamp_6 * 0.15
        v495.marker.Color = color5

        v495.marker.CFrame = CFrame.new(v524 + Vector3.new(0, 0.1, 0))
          * CFrame.Angles(0, 0, math.rad(90))

        v495.label.Text = v521 .. "  " .. string.format("%.1fs", v526)
        v495.label.TextColor3 = color5

        return
      end
    end
  end
end))

local connect7, connect8, connect9

local function f113()
  if connect7 then
    return
  end

  v203 = false
  v204 = false

  local HitGround = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.BallService.RE.HitGround

  HitGround.OnClientEvent:Connect(function(...)
    local v533 = { ... }
    local Name_2 = localPlayer2.Name

    for key18, value97 in pairs(v533) do
      if tostring(value97) == Name_2 then
        v204 = true
        break
      end
    end
  end)

  local f114

  function f114(p208)
    if v203 then
      return
    elseif not v204 then
      return
    elseif not v202 then
      return
    else
      v203 = true

      local Child_3 = workspace:FindFirstChild(localPlayer2.Name)
        or workspace:FindFirstChild("uwuwuwiiwuw6")

      local ScoreEffect_2 = scoreEffect
      local v535 = true

      if ScoreEffect_2 == "GroundHit1" or ScoreEffect_2 == "GroundHit2" then
        local v536 = ScoreEffect_2 == "GroundHit2"
        ScoreEffect_2 = nil
        v535 = v536
      end

      if firesignal then
        firesignal(HitGround.OnClientEvent, table.unpack({
          p208, v535, false, 5, ScoreEffect_2, Child_3,
          Vector3.new(-0.0000020885916001134, 1, -0.000004710930170404),
        }, 1, 7))
      end

      task.wait(0.5)
      v203 = false
      v204 = false
      return
    end
  end

  connect7 = workspace.ChildAdded:Connect(function(child7)
    if child7.Name == "HitIndicator" then
      if child7.Color == Color3.fromRGB(0, 255, 0) then
        f114(child7.Position)
      end
    end
  end)

  connect8 = workspace.DescendantAdded:Connect(function(descendant4)
    if descendant4.Name == "HitIndicator" and descendant4:IsA("BasePart") then
      if descendant4.Color == Color3.fromRGB(0, 255, 0) then
        f114(descendant4.Position)
      end
    end
  end)

  connect9 = workspace.DescendantRemoving:Connect(function(descendant5)
    if descendant5.Name == "HitIndicator" then
      v203 = false
      v204 = false
    end
  end)
end

local function f115()
  if connect7 then
    connect7:Disconnect()
    connect7 = nil
  end

  if connect8 then
    connect8:Disconnect()
    connect8 = nil
  end

  if connect9 then
    connect9:Disconnect()
    connect9 = nil
  end

  v203 = false
  v204 = false
end

do
  local connect10

  local function f116(p209)
    local Humanoid_8 = p209:WaitForChild("Humanoid")
    local HumanoidRootPart_12 = p209:WaitForChild("HumanoidRootPart")

    if connect10 then
      connect10:Disconnect()
      connect10 = nil
    end

    connect10 = Humanoid_8:GetPropertyChangedSignal("Jump"):Connect(function()
      if Humanoid_8.Jump and (v201 or v255.enabled) then
        task.defer(function()
          local enabled = v255.enabled and f63()
          local Position_8 = enabled and enabled.Position
          local OsClock_2 = os.clock()
          task.wait(0.03)

          if enabled and Position_8 and enabled.Parent then
            v255.trackBall(enabled, Position_8, os.clock() - OsClock_2)
          end

          local Facing = v255.enabled and v255.facing()

          if not Facing and v201 then
            Facing = Vector3.new(
              currentCamera2.CFrame.LookVector.X, 0, currentCamera2.CFrame.LookVector.Z
            )
          end

          if Facing and Facing.Magnitude > 0 then
            v255.steer = Facing

            if v201 or v255.enabled then
              HumanoidRootPart_12.CFrame = CFrame.lookAt(HumanoidRootPart_12.Position, HumanoidRootPart_12.Position
                + Facing.Unit)

              Humanoid_8.AutoRotate = false
            end
          end
        end)
      else
        Humanoid_8.AutoRotate = false
      end
    end)
  end

  if localPlayer2.Character then
    f116(localPlayer2.Character)
  end

  f36(localPlayer2.CharacterAdded:Connect(f116))

  local function f117()
    if not v221 then
      return
    else
      local Character_35 = localPlayer2.Character

      if not Character_35 then
        return
      else
        local Humanoid_9 = Character_35:FindFirstChildOfClass("Humanoid")

        if not Humanoid_9 then
          return
        end

        if v175 and v175.PlayAnimation then
          Humanoid_9.Jump = true
          v175:PlayAnimation("SpikeJump")
          task.delay(0.28, function() v175:PlayAnimation("Spike") end)
        end

        return
      end
    end
  end

  f36(userInputService.JumpRequest:Connect(function()
    if v221 then
      f117()
    end
  end))
end

local function f118()
  coroutine.wrap(function()
    while v214 do
      local Text_3 = localPlayer2.PlayerGui.Interface.Lobby.Abilities.TopPanel.DisplayName.Text

      for index86, value98 in ipairs(v216) do
        if Text_3 == value98 then
          v214 = false
          return
        end
      end

      local v538 = { v218 == "Lucky" }
      local AbilityService = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.AbilityService

      if AbilityService then
        local RF_2 = AbilityService:FindFirstChild("RF")

        if RF_2 then
          local Roll = RF_2:FindFirstChild("Roll")

          if Roll then
            Roll:InvokeServer(unpack(v538))
          end
        end
      end

      task.wait(0)
    end
  end)()
end

local qualityLevel, savedQualityLevel

local function f119()
  for key19, value99 in pairs(v231) do
    for key20, value100 in pairs(value99) do
      key19[key20] = value100
    end
  end

  v231 = {}

  if qualityLevel ~= nil then
    settings().Rendering.QualityLevel = qualityLevel
    qualityLevel = nil
  end

  if savedQualityLevel ~= nil then
    local UserSettings_2 = UserSettings()
    UserSettings_2:GetService("UserGameSettings").SavedQualityLevel = savedQualityLevel
    savedQualityLevel = nil
  end
end

local function f120()
  local function f121(p210, p211)
    local v540, v541 = pcall(function() return p210[p211] end)

    if v540 then
      return v541
    end

    return nil
  end

  local function f122(p212, p213, p214)
    p212[p213] = p214
  end

  local function f123(p215, p216)
    if not p215 then
      return
    else
      local v542 = v231[p215]

      if not v542 then
        v542 = {}
        v231[p215] = v542
      end

      if v542[p216] == nil then
        local f121_2 = f121(p215, p216)

        if f121_2 == nil then
          return false
        end

        v542[p216] = f121_2
        return true
      end

      return true
    end
  end

  local function f124(p217, p218, p219)
    if not p217 then
      return
    end

    if not f123(p217, p218) then
      return
    end

    f122(p217, p218, p219)
  end

  local function f125(p220)
    if not p220 then
      return true
    else
      local Character_36 = localPlayer2.Character

      if Character_36 and p220:IsDescendantOf(Character_36) then
        return true
      end

      return false
    end
  end

  local function f126(p221)
    if f125(p221) then
      return
    end

    if p221:IsA("BasePart") then
      f124(p221, "Material", Enum.Material.SmoothPlastic)
      f124(p221, "Reflectance", 0)
      f124(p221, "CastShadow", false)

      if p221:IsA("MeshPart") then
        f124(p221, "RenderFidelity", Enum.RenderFidelity.Performance)
        f124(p221, "TextureID", "")
      end
    elseif p221:IsA("Decal") or p221:IsA("Texture") then
      f124(p221, "Transparency", 1)
    elseif p221:IsA("ParticleEmitter") or p221:IsA("Trail") or p221:IsA("Beam")
      or p221:IsA("Smoke") or p221:IsA("Fire") or p221:IsA("Sparkles") then
      f124(p221, "Enabled", false)
    elseif p221:IsA("PointLight") or p221:IsA("SpotLight") or p221:IsA("SurfaceLight") then
      f124(p221, "Enabled", false)
    elseif p221:IsA("SpecialMesh") then
      f124(p221, "TextureId", "")
    elseif p221:IsA("SurfaceAppearance") then
      f124(p221, "ColorMap", "")
      f124(p221, "MetalnessMap", "")
      f124(p221, "NormalMap", "")
      f124(p221, "RoughnessMap", "")
    end
  end

  local function f127()
    f124(lighting, "Technology", Enum.Technology.Compatibility)
    f124(lighting, "GlobalShadows", false)
    f124(lighting, "FogEnd", 1000000000)
    f124(lighting, "ShadowSoftness", 0)

    for index87, value101 in ipairs(lighting:GetChildren()) do
      if value101:IsA("PostEffect") then
        f124(value101, "Enabled", false)
      elseif value101:IsA("Atmosphere") then
        f124(value101, "Density", 0)
        f124(value101, "Haze", 0)
        f124(value101, "Glare", 0)
      elseif value101:IsA("Sky") then
        f124(value101, "CelestialBodiesShown", false)
        f124(value101, "StarCount", 0)
      end
    end
  end

  local function f128()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")

    if not Terrain then
      return
    end

    f124(Terrain, "Decoration", false)
    f124(Terrain, "WaterWaveSize", 0)
    f124(Terrain, "WaterWaveSpeed", 0)
    f124(Terrain, "WaterReflectance", 0)
    f124(Terrain, "WaterTransparency", 1)
  end

  local function f129()
    local Settings = settings().Rendering

    if qualityLevel == nil then
      qualityLevel = Settings.QualityLevel
    end

    Settings.QualityLevel = Enum.QualityLevel.Level01
    local UserGameSettings = UserSettings():GetService("UserGameSettings")

    if savedQualityLevel == nil then
      savedQualityLevel = UserGameSettings.SavedQualityLevel
    end

    UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
  end

  f129()

  f127()
  f128()

  for index88, value102 in ipairs(workspace:GetDescendants()) do
    f126(value102)
  end

  workspace.DescendantAdded:Connect(function(descendant6) f126(descendant6) end)
end

local function f130()
  coroutine.wrap(function()
    while v213 do
      local Text_4 = localPlayer2.PlayerGui.Interface.Lobby.Styles.TopPanel.DisplayName.Text

      for index89, value103 in ipairs(v215) do
        if Text_4 == value103 then
          v213 = false
          return
        end
      end

      local v544 = { v217 == "Lucky" }
      local StyleService = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.StyleService

      if StyleService then
        local RF_3 = StyleService:FindFirstChild("RF")

        if RF_3 then
          local Roll_2 = RF_3:FindFirstChild("Roll")

          if Roll_2 then
            Roll_2:InvokeServer(unpack(v544))
          end
        end
      end

      task.wait(0)
    end
  end)()
end

-- LOCOPANI Rayfield Gen2 UI bridge: keeps the original control callbacks and names.
LOCOPANI_RAYFIELD = loadstring(game:HttpGet("https://sirius.menu/gen2"))()
local Rayfield = LOCOPANI_RAYFIELD
LOCOPANI_RAY_WINDOW = Rayfield:CreateWindow({
  name = "LOCOPANI",
  subtitle = "OWNER / CREATOR: LOCOPANI",
  sidebarLayout = true,
})

-- Corrige falhas raras de cálculo de layout no primeiro carregamento (texto estreito/empilhado).
-- Reaplica o texto após a interface terminar de montar e recalcula os TextLabels envolvidos.
task.spawn(function()
  local RunService = game:GetService("RunService")
  for _, delayFrames in ipairs({1, 3, 8}) do
    for _ = 1, delayFrames do RunService.Heartbeat:Wait() end
    pcall(function()
      local containers = {game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")}
      for _, container in ipairs(containers) do
        if container then
          for _, gui in ipairs(container:GetChildren()) do
            if gui:IsA("ScreenGui") and (gui.Name:lower():find("rayfield") or gui.Name:lower():find("sirius")) then
              for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Visible and obj.Text ~= "" and obj.TextWrapped then
                  local oldText = obj.Text
                  obj.Text = " "
                  RunService.Heartbeat:Wait()
                  if obj.Parent then obj.Text = oldText end
                end
              end
            end
          end
        end
      end
    end)
  end
end)

-- Main menu visibility key: RightShift. Handle it directly against the Gen2 window.
local UserInputService = game:GetService("UserInputService")
local function LOCOPANI_SetRayfieldVisibility(visible)
  LOCOPANI_RAY_VISIBLE = visible
  local ok = pcall(function()
    if LOCOPANI_RAY_WINDOW.SetVisibility then
      LOCOPANI_RAY_WINDOW:SetVisibility(visible)
    elseif LOCOPANI_RAY_WINDOW.SetVisible then
      LOCOPANI_RAY_WINDOW:SetVisible(visible)
    elseif LOCOPANI_RAY_WINDOW.Toggle then
      LOCOPANI_RAY_WINDOW:Toggle(visible)
    else
      error("Rayfield Gen2 window visibility method unavailable")
    end
  end)
  if not ok then
    -- Fallback: hide/show the ScreenGui created by Rayfield, without showing the legacy UI.
    pcall(function()
      local containers = {game:GetService("CoreGui"), game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")}
      for _, container in ipairs(containers) do
        for _, gui in ipairs(container:GetChildren()) do
          if gui:IsA("ScreenGui") and (gui.Name:lower():find("rayfield") or gui.Name:lower():find("sirius")) then
            gui.Enabled = visible
          end
        end
      end
    end)
  end
end

UserInputService.InputBegan:Connect(function(input, processed)
  if processed or UserInputService:GetFocusedTextBox() then return end
  if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightShift then
    LOCOPANI_SetRayfieldVisibility(not LOCOPANI_RAY_VISIBLE)
  end
end)

-- Keep the original window object for legacy functions/notifications, but hide its visual frame.
LOCOPANIHUBWindow = v174:CreateWindow({
  Title = "LOCOPANI",
  Footer = "OWNER / CREATOR: LOCOPANI",
  NotifySide = "Right",
})
_G.LOCOPANI_WINDOW = LOCOPANIHUBWindow
pcall(function()
  if LOCOPANIHUBWindow.Instance then LOCOPANIHUBWindow.Instance.Visible = false end
end)

-- Updates e criada primeiro para aparecer como a primeira categoria da UI principal.
local LOCOPANI_RAY_TABS = {
  Updates = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Updates" }),
  Main = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Main" }),
  Character = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Character" }),
  Visuals = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Visuals" }),
  Misc = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Misc" }),
  GameJoin = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Game Join" }),
  ["UI Settings"] = LOCOPANI_RAY_WINDOW:CreateTab({ name = "UI Settings" }),
}

-- Changelog isolado em um bloco proprio para liberar registradores locais.
do
  local history = {
    {
      date = "20/10/2026",
      title = "Update ocorrida",
      changes = {
        "Bug fixes",
        "Level Changer",
      },
    },
    {
      date = "20/10/2026",
      title = "ScoreEffect Changer",
      changes = {
        "Corrigido o equipamento visual local dos ScoreEffects.",
        "Atualizado o estado local de equipamento para aplicar o efeito visual.",
      },
    },
    {
      date = "20/10/2026",
      title = "Visual Level",
      changes = {
        "Corrigida a exibicao do nivel acima do personagem.",
        "Melhorada a atualizacao do BillboardGui do personagem.",
      },
    },
    {
      date = "18/10/2026",
      title = "Linkvertise Key System",
      changes = {
        "Corrigida a validacao de respostas JSON e texto simples do Linkvertise Anti-Bypass.",
        "Respostas JSON validas com status true passaram a ser reconhecidas corretamente.",
      },
    },
  }

  -- Erros no conteudo do changelog nao devem impedir a inicializacao do hub.
  pcall(function()
    local updatesTab = LOCOPANI_RAY_TABS.Updates
    if not updatesTab then return end
    updatesTab:CreateSection({ name = "Historico de atualizacoes" })
    for _, update in ipairs(history) do
      updatesTab:CreateSection({ name = update.date .. " - " .. update.title })
      for _, change in ipairs(update.changes) do
        updatesTab:CreateParagraph({ Title = "Update ocorrida", Content = "- " .. change })
      end
    end
    updatesTab:CreateSection({ name = "Como adicionar uma update" })
    updatesTab:CreateParagraph({
      Title = "Dica",
      Content = "Adicione novas entradas a tabela history neste bloco, com data, titulo e lista de mudancas.",
    })
  end)
end

local function LOCOPANI_RayControl(kind, tab, name, cfg, callback)
  cfg = cfg or {}
  local title = cfg.Text or cfg.Name or name or kind
  local handle = { Value = cfg.Default, _control = nil, _callbacks = {}, Values = cfg.Values }
  local function onValue(value, ...)
    handle.Value = value
    if callback then callback(value, ...) end
    for _, fn in ipairs(handle._callbacks) do task.spawn(fn, value) end
  end
  local h
  local common = { name = title }
  if kind == "Toggle" then
    common.value = cfg.Default == true
    common.callback = onValue
    h = tab:CreateToggle(common)
  elseif kind == "Button" then
    common.callback = callback or cfg.Func or cfg.Callback
    h = tab:CreateButton(common)
  elseif kind == "Slider" then
    common.range = { cfg.Min or 0, cfg.Max or 100 }
    common.increment = cfg.Rounding and (cfg.Rounding > 0 and 10 ^ (-cfg.Rounding) or 1) or 1
    common.value = cfg.Default or cfg.Min or 0
    common.callback = onValue
    h = tab:CreateSlider(common)
  elseif kind == "Dropdown" then
    common.options = cfg.Values or {}
    common.value = cfg.Default
    common.callback = onValue
    h = tab:CreateDropdown(common)
  elseif kind == "Input" or kind == "TextBox" then
    common.value = cfg.Default or ""
    common.placeholder = cfg.Placeholder or title
    common.callback = onValue
    h = tab:CreateInput(common)
  elseif kind == "Keybind" then
    local key = cfg.Default or "RightShift"
    local enumKey = key
    pcall(function() enumKey = Enum.KeyCode[key] end)
    common.value = enumKey
    common.callback = onValue
    h = tab:CreateKeybind(common)
  elseif kind == "Label" then
    h = tab:CreateText({ name = title })
  elseif kind == "Divider" then
    h = tab:CreateDivider()
  end
  handle._control = h
  function handle:SetValue(value, silent)
    self.Value = value
    if self._control and self._control.Set then pcall(function() self._control:Set(value) end) end
    if not silent then
      local cb = callback or cfg.Callback
      if cb then task.spawn(cb, value) end
      for _, fn in ipairs(self._callbacks) do task.spawn(fn, value) end
    end
  end
  function handle:GetValue() return self.Value end
  function handle:SetValues(values)
    self.Values = values or {}
    local control = self._control
    if not control then return end
    -- Rayfield forks expose different names for updating dropdown options.
    local updated = false
    for _, methodName in ipairs({"SetOptions", "Refresh", "SetValues", "UpdateOptions"}) do
      local method = control[methodName]
      if type(method) == "function" then
        local ok = pcall(method, control, self.Values)
        if ok then updated = true; break end
      end
    end
    -- Keep common internal option fields in sync for forks that read these directly.
    pcall(function() control.Options = self.Values end)
    pcall(function() control.options = self.Values end)
    pcall(function() control.Values = self.Values end)
    return updated
  end
  function handle:OnChanged(fn) table.insert(self._callbacks, fn); return self end
  function handle:SetText(value)
    if self._control and self._control.Set then pcall(function() self._control:Set(value) end) end
  end
  function handle:AddKeyPicker(keyName, keyCfg)
    return LOCOPANI_RayControl("Keybind", tab, keyName, keyCfg, keyCfg and keyCfg.Callback)
  end
  return handle
end

local LOCOPANI_RayGroup = {}
LOCOPANI_RayGroup.__index = LOCOPANI_RayGroup
function LOCOPANI_RayGroup:AddLeftGroupbox(name)
  self._tab:CreateSection({ name = name })
  return setmetatable({ _tab = self._tab }, LOCOPANI_RayGroup)
end
function LOCOPANI_RayGroup:AddRightGroupbox(name) return self:AddLeftGroupbox(name) end
function LOCOPANI_RayGroup:AddToggle(name, cfg)
  local h = LOCOPANI_RayControl("Toggle", self._tab, name, cfg, cfg and cfg.Callback)
  if v174 and v174.Toggles then v174.Toggles[name] = h end
  toggles[name] = h
  return h
end
function LOCOPANI_RayGroup:AddButton(name, callback)
  local cfg = type(name) == "table" and name or { Text = name, Func = callback }
  local h = LOCOPANI_RayControl("Button", self._tab, nil, cfg, cfg.Func or cfg.Callback)
  return h
end
function LOCOPANI_RayGroup:AddSlider(name, cfg)
  local h = LOCOPANI_RayControl("Slider", self._tab, name, cfg, cfg and cfg.Callback)
  options[name] = h; v174.Options[name] = h
  return h
end
function LOCOPANI_RayGroup:AddDropdown(name, cfg)
  local h = LOCOPANI_RayControl("Dropdown", self._tab, name, cfg, cfg and cfg.Callback)
  options[name] = h; v174.Options[name] = h
  return h
end
function LOCOPANI_RayGroup:AddInput(name, cfg) return self:AddTextBox(name, cfg) end
function LOCOPANI_RayGroup:AddTextBox(name, cfg)
  local h = LOCOPANI_RayControl("TextBox", self._tab, name, cfg, cfg and cfg.Callback)
  options[name] = h; v174.Options[name] = h
  return h
end
function LOCOPANI_RayGroup:AddLabel(name)
  return LOCOPANI_RayControl("Label", self._tab, nil, { Text = name })
end
function LOCOPANI_RayGroup:AddDivider() return LOCOPANI_RayControl("Divider", self._tab, nil, {}) end
function LOCOPANI_RayGroup:AddKeyPicker(name, cfg)
  local h = LOCOPANI_RayControl("Keybind", self._tab, name, cfg, cfg and cfg.Callback)
  options[name] = h; v174.Options[name] = h
  return h
end

v545 = {}
for key, rayTab in pairs(LOCOPANI_RAY_TABS) do
  v545[key] = setmetatable({ _tab = rayTab }, LOCOPANI_RayGroup)
end

v546 = {}
v546.LeftGroupBox = v545.Main:AddLeftGroupbox("Spike Settings")

v546.LeftGroupBox:AddToggle("redirectspike", {
  Text = "Redirect Spike",
  Tooltip = "Redirect spike to camera direction",
  Default = false,
  Callback = function(value104)
    if value104 then
      f64()
    else
      f66()
    end
  end,
})

v546.LeftGroupBox:AddToggle("autocorner", {
  Text = "Auto Corner",
  Tooltip = "Aims to the corner sides of the enemy's goal",
  Default = false,
  Callback = function(value105)
    v255.enabled = value105

    if value105 then
      v255.installAim()
    end
  end,
})

v546.LeftGroupBox:AddDropdown("autocornerside", {
  Values = { "Auto", "Left", "Right" },
  Default = "Auto",
  Text = "Corner Side",
  Callback = function(value106) v255.side = value106 end,
})

v546.LeftGroupBox:AddDropdown("autocornerreach", {
  Values = { "All", "Back", "Nearest" },
  Default = "All",
  Text = "Corner Depth",
  Callback = function(value107) v255.reach = value107 end,
})

v546.LeftGroupBox:AddLabel("Auto Corner bind"):AddKeyPicker("autocornerbind", {
  Default = "C",
  Mode = "Press",
  Text = "Auto Corner",
  Callback = function()
    local autocorner = toggles.autocorner

    if autocorner then
      autocorner:SetValue(not autocorner.Value)
    end
  end,
})

v546.LeftGroupBox:AddToggle("newspike", {
  Text = "Silent Spike",
  Tooltip = "Spike with no animation or sound",
  Default = false,
  Callback = function(value108)
    v188 = value108

    if textButton2 then
      textButton2.Visible = value108
    end
  end,
})

v546.LeftGroupBox:AddLabel("Silent Spike bind"):AddKeyPicker("newspikebind", {
  Default = "R",
  Mode = "Press",
  Text = "Silent Spike",
  Callback = function() f75() end,
})

v546.LeftGroupBox:AddToggle("sanju", {
  Text = "Sanju Tilt",
  Tooltip = "Sanju tilt effect",
  Default = false,
  Callback = function(value109)
    if value109 then
      f67()
    else
      f68()
    end
  end,
})

v546.LeftGroupBox:AddToggle("maxcharge", {
  Text = "Max Charge Special",
  Tooltip = "Max charge your special",
  Default = false,
  Callback = function(value110)
    if value110 then
      f70()
    else
      f71()
    end
  end,
})

v546.LeftGroupBox:AddToggle("autofarm", {
  Text = "Auto Farm",
  Tooltip = "Spike/Block/Jump/TP farm loop with its own GUI",
  Default = false,
  Callback = function(value111)
    if value111 then
      v308.start()
    else
      v308.stop()
    end
  end,
})

v546.LeftGroupBox:AddToggle("fakespike", {
  Text = "Fake Spike",
  Tooltip = "Auto fake spike when jumping",
  Default = false,
  Callback = function(value112) v221 = value112 end,
})

v546.LeftGroupBox:AddToggle("autocounter", {
  Text = "Auto Counter",
  Tooltip = "Counters an enemy spike when both of you are at the net",
  Default = false,
  Callback = function(value113) v395.state.enabled = value113 end,
})

v546.LeftGroupBox:AddDropdown("autocountermove", {
  Values = { "Auto", "Block", "Spike" },
  Default = "Auto",
  Text = "Counter Move",
  Tooltip = "Auto: block while the ball is still on their half, spike once it crosses",
  Callback = function(value114) v395.state.move = value114 end,
})

v546.LeftGroupBox:AddSlider("autocounternetrange", {
  Text = "Counter Net Range",
  Default = 9,
  Min = 3,
  Max = 20,
  Rounding = 1,
  Callback = function(value115) v395.state.netRange = value115 end,
})

v546.LeftGroupBox:AddSlider("autocounterlateral", {
  Text = "Counter Width",
  Default = 14,
  Min = 4,
  Max = 30,
  Rounding = 1,
  Callback = function(value116) v395.state.lateral = value116 end,
})

v546.LeftGroupBox:AddSlider("autocounterdelay", {
  Text = "Counter Delay",
  Default = 0.05,
  Min = 0,
  Max = 0.5,
  Rounding = 2,
  Callback = function(value117) v395.state.delay = value117 end,
})

v546.LeftGroupBox:AddToggle("autocounterjump", {
  Text = "Counter Auto Jump",
  Tooltip = "Jump before the counter, the block hitbox dies the moment you land",
  Default = true,
  Callback = function(value118) v395.state.autoJump = value118 end,
})

v546.LeftGroupBox:AddLabel("Auto Counter bind"):AddKeyPicker("autocounterbind", {
  Default = "N",
  Mode = "Press",
  Text = "Auto Counter",
  Callback = function()
    local autocounter = toggles.autocounter

    if autocounter then
      autocounter:SetValue(not autocounter.Value)
    end
  end,
})

v546.AutoSetGroup = v545.Main:AddLeftGroupbox("Auto Set")

v546.AutoSetGroup:AddToggle("autoset", {
  Text = "Auto Set",
  Tooltip = "Aims and fires a set at the target",
  Default = false,
  Callback = function(value119)
    v323.enabled = value119

    if value119 then
      v323.start()
    else
      v323.stop()
    end
  end,
})

v546.AutoSetGroup:AddDropdown("autosettarget", {
  Values = { "Nearest", "Random" },
  Default = "Nearest",
  Text = "Target Mode",
  Callback = function(value120) v323.mode = value120 end,
})

v546.AutoSetGroup:AddLabel("Set keybind"):AddKeyPicker("autosetfirebind", {
  Default = "F",
  Mode = "Press",
  Text = "Set",
  NoUI = false,
  Callback = function()
    if not v323.enabled then
      return
    end

    if v323.fire() then
      v174:Notify("Set fired")
    else
      v174:Notify("No target or no ball")
    end
  end,
})

v546.AimSetGroup = v545.Main:AddLeftGroupbox("Aim Set")

v546.AimSetGroup:AddToggle("aimset", {
  Text = "Aim Set",
  Tooltip = "Auto-aims any JumpSet at the target",
  Default = false,
  Callback = function(value121)
    v329.enabled = value121

    if value121 then
      v329.start()
    else
      v329.stop()
    end
  end,
})

v546.AimSetGroup:AddDropdown("aimsettarget", {
  Values = { "Nearest", "Random" },
  Default = "Nearest",
  Text = "Target Mode",
  Callback = function(value122) v329.mode = value122 end,
})

v546.HitboxGroup = v545.Main:AddRightGroupbox("Hitbox Settings")

v546.HitboxGroup:AddToggle("hitboxenable", {
  Text = "Enable Hitbox",
  Tooltip = "Turn Hitbox ON/OFF",
  Default = false,
  Callback = function(value123)
    if value123 then
      enableHitbox()
    else
      disableHitbox()
    end
  end,
})

v546.HitboxGroup:AddSlider("hitboxsize", {
  Text = "Hitbox Size",
  Tooltip = "Reach in studs, the server refuses anything past 20",
  Default = 5,
  Min = 0,
  Max = 20,
  Rounding = 1,
  Callback = function(value124) setHitboxScale(value124) end,
})

v546.HitboxGroup:AddDropdown("hitboxcolor", {
  Values = {
    "Invisible", "White", "Green", "Blue", "Red", "Yellow", "Purple", "Orange", "Pink",
  },
  Default = "Blue",
  Text = "Hitbox Color",
  Callback = function(value125)
    local Color3_5 = Color3.fromRGB(255, 255, 255)
    local Color3_6 = Color3.fromRGB(255, 255, 255)
    local Color3_7 = Color3.fromRGB(0, 255, 0)
    local Color3_8 = Color3.fromRGB(0, 0, 255)
    local Color3_9 = Color3.fromRGB(255, 0, 0)
    local Color3_10 = Color3.fromRGB(255, 255, 0)
    local Color3_11 = Color3.fromRGB(128, 0, 128)
    local Color3_12 = Color3.fromRGB(255, 165, 0)
    local Color3_13 = Color3.fromRGB(255, 105, 180)

    local v547 = {
      Invisible = 1,
      White = 0.3,
      Green = 0.3,
      Blue = 0.3,
      Red = 0.3,
      Yellow = 0.3,
      Purple = 0.3,
      Orange = 0.3,
      Pink = 0.3,
    }

    setHitboxColor(({
      Invisible = Color3_5,
      White = Color3_6,
      Green = Color3_7,
      Blue = Color3_8,
      Red = Color3_9,
      Yellow = Color3_10,
      Purple = Color3_11,
      Orange = Color3_12,
      Pink = Color3_13,
    })[value125] or Color3.fromRGB(0, 0, 255))

    setHitboxTransparency(v547[value125] or 0.3)

    if v178 then
      f39(v179)
    end
  end,
})

v546.HitboxGroup:AddButton({ Text = "Remove Hitboxes", Func = function() f37() end })

v546.HitboxGroup:AddButton({
  Text = "Show Stop Ball",
  Func = function()
    v189 = not v189

    if textButton4 then
      textButton4.Visible = v189
    else
      textButton4 = f82()
    end
  end,
})

v546.HitboxGroup:AddButton({
  Text = "Show Aim",
  Func = function()
    v190 = not v190

    if textButton5 then
      textButton5.Visible = v190
    else
      textButton5 = f93()
    end
  end,
})

v546.PerfGroup = v545.Main:AddLeftGroupbox("Performance")

v546.PerfGroup:AddToggle("antilag", {
  Text = "Anti-Lag",
  Tooltip = "Reduce graphics for better performance",
  Default = false,
  Callback = function(value126)
    if value126 then
      f120()
    else
      f119()
    end
  end,
})

v546.MoveGroup = v545.Main:AddRightGroupbox("Movement")

v546.MoveGroup:AddToggle("desync", {
  Text = "Desync",
  Tooltip = "Desync movement",
  Default = false,
  Callback = function(value127)
    if value127 then
      f76()
    else
      f74()
    end
  end,
})

v546.MoveGroup:AddToggle("autoreceive", {
  Text = "Auto Receive",
  Tooltip = "Auto receive the ball when grounded and in range",
  Default = false,
  Callback = function(value128)
    v243.enabled = value128

    if value128 then
      v243.start()
    else
      v243.stop()
    end
  end,
})

v546.MoveGroup:AddSlider("autoreceiverange", {
  Text = "Receive Range",
  Default = 20,
  Min = 3,
  Max = 50,
  Rounding = 1,
  Callback = function(value129) v243.setRadius(value129) end,
})

v546.MoveGroup:AddLabel("Auto Receive bind"):AddKeyPicker("autoreceivebind", {
  Default = "X",
  Mode = "Press",
  Text = "Auto Receive",
  Callback = function()
    local autoreceive = toggles.autoreceive

    if autoreceive then
      autoreceive:SetValue(not autoreceive.Value)
    end
  end,
})

v546.MoveGroup:AddToggle("kisukidive", {
  Text = "Kisuki Dive",
  Tooltip = "Kisuki super dive",
  Default = false,
  Callback = function(value130)
    v440.enabled = value130

    if value130 then
      v440.install()
    end
  end,
})

v546.MoveGroup:AddSlider("kisukicharge", {
  Text = "Dive Charge",
  Tooltip = "Lerps Kimiro's real 19.5-45 power range, past 0.5 the FX go strong",
  Default = 1,
  Min = 0,
  Max = 1,
  Rounding = 2,
  Callback = function(value131) v440.charge = value131 end,
})

v546.MoveGroup:AddToggle("akaridash", {
  Text = "Akari Dash",
  Tooltip = "Dash into the ball",
  Default = false,
  Callback = function(value132)
    v191 = value132

    if textButton3 then
      textButton3.Visible = value132
    end
  end,
})

v546.MoveGroup:AddLabel("Akari Dash bind"):AddKeyPicker("akaridashbind", {
  Default = "F",
  Mode = "Press",
  Text = "Akari Dash",
  Callback = function() f79() end,
})

v546.MoveGroup:AddToggle("leadfeet", {
  Text = "Lead Feet",
  Tooltip = "Slams you down at the ability's own -10000 acceleration",
  Default = false,
  Callback = function(value133)
    v192 = value133

    if textButton6 then
      textButton6.Visible = value133
    end
  end,
})

v546.MoveGroup:AddLabel("Lead Feet bind"):AddKeyPicker("leadfeetbind", {
  Default = "G",
  Mode = "Press",
  Text = "Lead Feet",
  Callback = function() f102() end,
})

v546.MaxServeGroup = v545.Main:AddLeftGroupbox("Max Serve")

v546.MaxServeGroup:AddToggle("maxserve", {
  Text = "Max Serve",
  Tooltip = "Max serve power",
  Default = false,
  Callback = function(value134)
    if value134 then
      f101()
    else
      f100()
    end
  end,
})

v546.MaxServeGroup:AddToggle("esp", {
  Text = "Jump ESP",
  Tooltip = "Highlight enemies while they are jumping",
  Default = false,
  Callback = function(value135)
    v193 = value135

    if not value135 then
      for key21 in pairs(v194) do
        f96(key21)
      end
    end
  end,
})

v546.DataGroup = v545.Main:AddRightGroupbox("Data")

v546.DataGroup:AddButton({
  Text = "Data Rollback",
  Func = function()
    replicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SettingsService"):WaitForChild("RF"):WaitForChild("UpdateKeybind"):InvokeServer(
      "MouseButton1", true, "Spike​\143"
    )

    teleportService:Teleport(game.PlaceId)
  end,
})

v546.CharAttrGroup = v545.Character:AddLeftGroupbox("Attributes")

v546.CharAttrGroup:AddInput("divespeed", {
  Default = "",
  Numeric = true,
  Finished = true,
  Text = "Dive Speed",
  Placeholder = "0.95",
  Callback = function(value136)
    local ToNumber_2 = tonumber(value136)

    if ToNumber_2 then
      localPlayer2:SetAttribute("Multiplier_DiveSpeed", ToNumber_2)
    end
  end,
})

v546.CharAttrGroup:AddInput("jumppower", {
  Default = "",
  Numeric = true,
  Finished = true,
  Text = "Jump Power",
  Placeholder = "1.1",
  Callback = function(value137)
    local ToNumber_3 = tonumber(value137)

    if ToNumber_3 then
      localPlayer2:SetAttribute("Multiplier_JumpPower", ToNumber_3)
    end
  end,
})

v546.CharAttrGroup:AddInput("speed", {
  Default = "",
  Numeric = true,
  Finished = true,
  Text = "Speed",
  Placeholder = "0.85",
  Callback = function(value138)
    local ToNumber_4 = tonumber(value138)

    if ToNumber_4 then
      localPlayer2:SetAttribute("Multiplier_Speed", ToNumber_4)
    end
  end,
})

v546.BallESPGroup = v545.Character:AddLeftGroupbox("Ball ESP")

v546.BallESPGroup:AddToggle("ballesp", {
  Text = "Ball ESP",
  Tooltip = "Highlights the player who last touched the ball",
  Default = false,
  Callback = function(value139)
    v242.enabled = value139

    if value139 then
      v242.start()
    else
      v242.stop()
    end
  end,
})

v546.BallESPGroup:AddDropdown("ballespcolor", {
  Values = { "Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Pink", "Cyan", "White" },
  Default = "Red",
  Text = "ESP Color",
  Callback = function(value140)
    local v551 = ({
      Red = Color3.fromRGB(255, 0, 0),
      Green = Color3.fromRGB(0, 255, 0),
      Blue = Color3.fromRGB(0, 0, 255),
      Yellow = Color3.fromRGB(255, 255, 0),
      Purple = Color3.fromRGB(128, 0, 128),
      Orange = Color3.fromRGB(255, 165, 0),
      Pink = Color3.fromRGB(255, 105, 180),
      Cyan = Color3.fromRGB(0, 255, 255),
      White = Color3.fromRGB(255, 255, 255),
    })[value140]

    v242.setColor(v551 or Color3.fromRGB(255, 0, 0))
  end,
})

v546.CharMoveGroup = v545.Character:AddRightGroupbox("Movement")

v546.CharMoveGroup:AddToggle("airmove", {
  Text = "Air Movement",
  Tooltip = "Move in the air",
  Default = false,
  Callback = function(value141)
    local v552 = not value141
    v199 = value141

    if v552 and bodyVelocity then
      bodyVelocity:Destroy()
      bodyVelocity = nil
    end
  end,
})

v546.CharMoveGroup:AddSlider("airspeed", {
  Text = "Air Movement Speed",
  Default = 16,
  Min = 0,
  Max = 100,
  Rounding = 0,
  Callback = function(value142) v200 = value142 end,
})

v546.CharMoveGroup:AddToggle("autoshiftlock", {
  Text = "Auto Shift Lock",
  Tooltip = "Auto rotate to camera when jumping",
  Default = false,
  Callback = function(value143) f112(value143) end,
})

v546.CharMoveGroup:AddToggle("characterlines", {
  Text = "Character Enemy/Team Line",
  Tooltip = "Show colored beams to enemies",
  Default = false,
  Callback = function(value144)
    if not value144 then
      for key22 in pairs(v229) do
        removeLine(key22)
      end
    end
  end,
})

v546.CharMoveGroup:AddSlider("linedistance", {
  Text = "Line Distance",
  Default = 50,
  Min = 10,
  Max = 200,
  Rounding = 1,
  Callback = function(value145) end,
})

v545.Visuals:AddRightGroupbox("Ball Prediction"):AddToggle("ballmarker", {
  Text = "Landing Marker",
  Tooltip = "Predict where the ball land and say if it's out or not",
  Default = false,
  Callback = function(value146)
    v495.enabled = value146

    if not value146 then
      v495.clear()
    end
  end,
})

-- Visual-only level override: changes local PlayerGui text only, never server data.
local LOCOPANI_VisualLevel = {
  Enabled = false,
  Value = "1000",
  Records = {},
  AddedConn = nil,
  CharacterConn = nil,
  CharacterAddedConn = nil,
}

function LOCOPANI_VisualLevel:IsLevelLabel(label)
  if not label or not (label:IsA("TextLabel") or label:IsA("TextButton")) then
    return false
  end
  local name = string.lower(tostring(label.Name or ""))
  local currentText = tostring(label.Text or "")
  local lowerText = string.lower(currentText)
  local namedAsLevel = string.find(name, "level", 1, true) or string.find(name, "lvl", 1, true)
  local textHasLevel = string.find(lowerText, "level", 1, true) or
    string.find(lowerText, "lvl", 1, true) or
    string.find(lowerText, "lv.", 1, true) or
    string.match(lowerText, "^%s*lv%s*%d+")
  local isJustNumber = string.match(currentText, "^%s*%d+%s*$") ~= nil

  -- Overhead level labels are often parented to the local character's Head
  -- inside a BillboardGui, not inside PlayerGui. Inspect ancestor names too.
  local ancestor = label.Parent
  local inBillboard = false
  local ancestorHintsLevel = false
  while ancestor do
    local ancestorName = string.lower(tostring(ancestor.Name or ""))
    if ancestor:IsA("BillboardGui") then inBillboard = true end
    if string.find(ancestorName, "level", 1, true) or string.find(ancestorName, "lvl", 1, true) then
      ancestorHintsLevel = true
    end
    ancestor = ancestor.Parent
  end

  return namedAsLevel ~= nil or textHasLevel ~= nil or ancestorHintsLevel or
    (isJustNumber and (string.find(name, "exp", 1, true) ~= nil or inBillboard))
end

function LOCOPANI_VisualLevel:MakeSpoofedText(label, sourceText)
  local desired = tostring(math.max(0, math.floor(tonumber(self.Value) or 1000)))
  local original = tostring(sourceText or "")
  local lower = string.lower(original)
  if string.match(original, "^%s*%d+%s*$") and
    (string.find(string.lower(label.Name), "level", 1, true) or string.find(string.lower(label.Name), "lvl", 1, true)) then
    return string.gsub(original, "%d+", desired, 1)
  end
  if string.find(lower, "level", 1, true) or string.find(lower, "lvl", 1, true) or string.find(lower, "lv.", 1, true) or string.match(lower, "^%s*lv%s*%d+") then
    local replaced, count = string.gsub(original, "%d+", desired, 1)
    if count > 0 then return replaced end
  end
  return nil
end

function LOCOPANI_VisualLevel:Watch(label)
  if not self.Enabled or not self:IsLevelLabel(label) then return end
  if self.Records[label] then
    local record = self.Records[label]
    if record.busy then return end
    local nowText = tostring(label.Text or "")
    if nowText ~= record.spoofed then
      record.original = nowText
      local spoofed = self:MakeSpoofedText(label, record.original)
      if spoofed then
        record.spoofed = spoofed
        record.busy = true
        label.Text = spoofed
        record.busy = false
      end
    end
    return
  end

  local original = tostring(label.Text or "")
  local spoofed = self:MakeSpoofedText(label, original)
  if not spoofed then return end
  local record = { original = original, spoofed = spoofed, busy = true, connection = nil }
  self.Records[label] = record
  label.Text = spoofed
  record.busy = false
  record.connection = label:GetPropertyChangedSignal("Text"):Connect(function()
    if not self.Enabled or record.busy or not label.Parent then return end
    local current = tostring(label.Text or "")
    if current == record.spoofed then return end
    record.original = current
    local updated = self:MakeSpoofedText(label, record.original)
    if updated then
      record.spoofed = updated
      record.busy = true
      label.Text = updated
      record.busy = false
    end
  end)
end

function LOCOPANI_VisualLevel:WatchContainer(container)
  if not container then return end
  for _, item in ipairs(container:GetDescendants()) do
    if item:IsA("TextLabel") or item:IsA("TextButton") then
      self:Watch(item)
    end
  end
  if container:IsA("Model") and container:FindFirstChildOfClass("Humanoid") then
    -- The level over the character is normally in a BillboardGui under the
    -- character/head, outside PlayerGui. Only scan the local character.
    for _, item in ipairs(container:GetDescendants()) do
      if item:IsA("BillboardGui") then
        for _, guiItem in ipairs(item:GetDescendants()) do
          if guiItem:IsA("TextLabel") or guiItem:IsA("TextButton") then
            self:Watch(guiItem)
          end
        end
      end
    end
  end
end

function LOCOPANI_VisualLevel:Apply()
  if not self.Enabled then return end
  local player = localPlayer2 or game:GetService("Players").LocalPlayer
  if not player then return end
  local playerGui = player:FindFirstChildOfClass("PlayerGui")
  if playerGui then
    self:WatchContainer(playerGui)
    if not self.AddedConn then
      self.AddedConn = playerGui.DescendantAdded:Connect(function(item)
        if self.Enabled and (item:IsA("TextLabel") or item:IsA("TextButton")) then
          task.defer(function() self:Watch(item) end)
        end
      end)
    end
  end

  local function bindCharacter(character)
    if not self.Enabled or not character then return end
    if self.CharacterConn then
      self.CharacterConn:Disconnect()
      self.CharacterConn = nil
    end
    self:WatchContainer(character)
    self.CharacterConn = character.DescendantAdded:Connect(function(item)
      if self.Enabled and (item:IsA("TextLabel") or item:IsA("TextButton")) then
        task.defer(function() self:Watch(item) end)
      elseif self.Enabled and item:IsA("BillboardGui") then
        task.defer(function() self:WatchContainer(item) end)
      end
    end)
  end

  if player.Character then bindCharacter(player.Character) end
  if not self.CharacterAddedConn then
    self.CharacterAddedConn = player.CharacterAdded:Connect(function(character)
      task.defer(function() bindCharacter(character) end)
    end)
  end
end

function LOCOPANI_VisualLevel:SetEnabled(enabled)
  self.Enabled = enabled == true
  if self.Enabled then
    self:Apply()
    return
  end
  if self.AddedConn then
    self.AddedConn:Disconnect()
    self.AddedConn = nil
  end
  if self.CharacterConn then
    self.CharacterConn:Disconnect()
    self.CharacterConn = nil
  end
  if self.CharacterAddedConn then
    self.CharacterAddedConn:Disconnect()
    self.CharacterAddedConn = nil
  end
  for label, record in pairs(self.Records) do
    if record.connection then record.connection:Disconnect() end
    if label and label.Parent then
      record.busy = true
      label.Text = record.original
      record.busy = false
    end
    self.Records[label] = nil
  end
end

v546.VisualScoreGroup = v545.Visuals:AddLeftGroupbox("Score Effect")

v546.VisualScoreGroup:AddDropdown("effectselect", {
  Values = v205,
  Default = v205[1] or "SupernovaScoreEffect",
  Text = "Select Score Effect",
  Callback = function(value147)
    if value147 then
      scoreEffect = value147
      v174:Notify("Selected Effect: " .. value147)
    end
  end,
})

v546.VisualScoreGroup:AddToggle("scoreeffect", {
  Text = "ScoreEffect Changer",
  Tooltip = "Change score effect",
  Default = false,
  Callback = function(value148)
    v202 = value148

    if value148 then
      f113()
    else
      f115()
    end

    v451.mark("ScoreEffect", value148)
  end,
})

v546.VisualScoreGroup:AddToggle("randomeffect", {
  Text = "Random Effect",
  Tooltip = "Pick random effect when HitIndicator appears",
  Default = false,
  Callback = function(value149) v238.EffectEnabled = value149 end,
})

v546.VisualProtectGroup = v545.Visuals:AddRightGroupbox("Protection")

v546.VisualProtectGroup:AddToggle("protect", {
  Text = "Protect",
  Tooltip = "Enable/Disable all protection features",
  Default = true,
  Callback = function(value150) f49(value150) end,
})

v546.VisualProtectGroup:AddToggle("tshanimation", {
  Text = "TSH Animation",
  Tooltip = "PowerSpike + SpecialChargeSpikeVFX on spike",
  Default = false,
  Callback = function(value151) v222 = value151 end,
})

v546.VisualProtectGroup:AddToggle("hidarianimation", {
  Text = "Hidari Animation",
  Tooltip = "PowerSpike + HidariSpikeVFX on spike",
  Default = false,
  Callback = function(value152) v223 = value152 end,
})

v546.VisualProtectGroup:AddToggle("kazanabluejump", {
  Text = "Kazana Blue Jump",
  Tooltip = "Fires KazanaBlue on jump",
  Default = false,
  Callback = function(value153) v224 = value153 end,
})

v546.VisualProtectGroup:AddToggle("kazanawhitejump", {
  Text = "Kazana White Jump",
  Tooltip = "Fires KazanaWhite on jump",
  Default = false,
  Callback = function(value154) v225 = value154 end,
})

v546.CustomProtectGroup = v545.Visuals:AddLeftGroupbox("Custom Protect")

v546.CustomProtectGroup:AddToggle("customprotect", {
  Text = "Custom Protect",
  Tooltip = "Independent protect with your own name and title",
  Default = false,
  Callback = function(value155) v235.toggle(value155) end,
})

v546.CustomProtectGroup:AddInput("customprotectname", {
  Default = "CUSTOM NAME",
  Text = "Name",
  Placeholder = "CUSTOM NAME",
  Callback = function(value156) v235.setName(value156) end,
})

v546.CustomProtectGroup:AddInput("customprotecttitle", {
  Default = "<font color='#00FF00'><b>Custom</b></font>",
  Text = "Title (rich text OK)",
  Placeholder = "<font color='#00FF00'><b>Custom</b></font>",
  Callback = function(value157) v235.setTitle(value157) end,
})

v546.CustomProtectGroup:AddButton({
  Text = "Apply now",
  Func = function()
    v235.setName(options.customprotectname.Value)
    v235.setTitle(options.customprotecttitle.Value)

    if v235.Enabled then
      v235.updateNametag()
      v235.updateTitle()
      v235.protectPlayerCard()

      v174:Notify("Custom Protect applied")
    else
      v174:Notify("Turn the toggle on first")
    end
  end,
})

v546.PlayerCardGroup = v545.Visuals:AddLeftGroupbox("Player Card")

v546.PlayerCardGroup:AddDropdown("cardselect", {
  Values = v210,
  Default = v210[1] or "UltimateChampionPlayerCard",
  Text = "Select Player Card",
  Callback = function(value158)
    if value158 then
      v207 = value158
      _G.PlayerCard.Apply(value158)
      v174:Notify("Selected Card: " .. value158)
    end
  end,
})

v546.PlayerCardGroup:AddToggle("playercard", {
  Text = "PlayerCard Changer",
  Tooltip = "Change player card",
  Default = false,
  Callback = function(value159)
    v206 = value159

    -- Add/remove PlayerCard items in the local inventory view while enabled.
    -- This is client-side only; it does not grant server-side ownership.
    pcall(function()
      if v451 and v451.mark then
        v451.mark("PlayerCard", value159)
      end
    end)

    if value159 then
      f58()
    elseif not v238.CardEnabled then
      f57()
    end
  end,
})

v546.PlayerCardGroup:AddToggle("randomcard", {
  Text = "Random Card",
  Tooltip = "Pick random player card when card appears",
  Default = false,
  Callback = function(value160)
    v238.CardEnabled = value160

    if value160 then
      local f50_5 = f50("PlayerCard")

      if f50_5 then
        v207 = f50_5
        v174:Notify("Random Card: " .. f50_5)
      end

      if not v206 then
        f58()
      end
    elseif not v206 then
      f57()
    end
  end,
})

v545.Visuals:AddRightGroupbox("Title Changer"):AddToggle("titleunlock", {
  Text = "Title Changer",
  Tooltip = "Change title",
  Default = false,
  Callback = function(value161) v451.mark("Title", value161) end,
})

v546.BallSkinGroup = v545.Visuals:AddLeftGroupbox("Ball Changer")

v546.BallSkinGroup:AddDropdown("ballskinselect", {
  Values = v212,
  Default = v212[1] or "ClassicBall",
  Text = "Select Ball Skin",
  Callback = function(value162)
    if value162 then
      ball = value162
      v174:Notify("Selected Ball Skin: " .. value162)
    end
  end,
})

v546.BallSkinGroup:AddToggle("autoapplyball", {
  Text = "Auto Apply Ball",
  Tooltip = "Automatically apply selected ball skin",
  Default = false,
  Callback = function(value163)
    v220 = value163
    f108()
    v451.mark("Ball", value163)
  end,
})

v546.BallSkinGroup:AddToggle("randomball", {
  Text = "Random Ball",
  Tooltip = "Pick random ball when ball spawns",
  Default = false,
  Callback = function(value164) v238.BallEnabled = value164 end,
})

v546.VisualLevelGroup = v545.Visuals:AddRightGroupbox("Visual Level")

v546.VisualLevelGroup:AddInput("visuallevelvalue", {
  Default = "1000",
  Text = "Displayed Level",
  Placeholder = "1000",
  Callback = function(value167)
    local numeric = tonumber(value167)
    if numeric and numeric >= 0 then
      LOCOPANI_VisualLevel.Value = tostring(math.floor(numeric))
      if LOCOPANI_VisualLevel.Enabled then
        LOCOPANI_VisualLevel:SetEnabled(false)
        LOCOPANI_VisualLevel:SetEnabled(true)
      end
    end
  end,
})

v546.VisualLevelGroup:AddToggle("visuallevel", {
  Text = "Change Level (Visual Only)",
  Tooltip = "Changes level text locally in your interface only; it does not change the real account level.",
  Default = false,
  Callback = function(value168)
    LOCOPANI_VisualLevel:SetEnabled(value168)
    v174:Notify(value168 and ("Visual level set to " .. LOCOPANI_VisualLevel.Value) or "Visual level disabled")
  end,
})

v546.VisualLevelGroup:AddButton({
  Text = "Apply Visual Level",
  Func = function()
    if LOCOPANI_VisualLevel.Enabled then
      LOCOPANI_VisualLevel:SetEnabled(false)
      LOCOPANI_VisualLevel:SetEnabled(true)
      v174:Notify("Visual level applied: " .. LOCOPANI_VisualLevel.Value)
    else
      v174:Notify("Enable Change Level (Visual Only) first")
    end
  end,
})

v546.JerseyGroup = v545.Visuals:AddRightGroupbox("Jersey Changer")

v546.JerseyGroup:AddDropdown("jerseyselect", {
  Values = v211,
  Default = v211[1] or "DragonTuxedoJersey",
  Text = "Select Jersey",
  Callback = function(value165)
    if value165 then
      jersey = value165
      v418 = nil
      v174:Notify("Selected Jersey: " .. value165)
    end
  end,
})

v546.JerseyGroup:AddToggle("autoapplyjersey", {
  Text = "Auto Apply Jersey",
  Tooltip = "Automatically apply selected jersey",
  Default = false,
  Callback = function(value166)
    v219 = value166
    f105(jersey)
  end,
})

v546.MiscFFlagsGroup = v545.Misc:AddLeftGroupbox("FFlags Applier")

v546.MiscFFlagsGroup:AddTextBox("fflagsbox", {
  Text = "Fflags JSON (risky)",
  Placeholder = '{ "DFIntTaskSchedulerTargetFps": "9999" }',
  Height = 170,
  Default = "",
})

v546.MiscFFlagsGroup:AddButton({
  Text = "Apply FFlags",
  Func = function()
    local GetValue = options.fflagsbox:GetValue()

    if GetValue == "" then
      v174:Notify("Paste some JSON first")
      return
    end

    v336.apply(GetValue)
  end,
})

v546.MiscFFlagsGroup:AddButton({
  Text = "Load Example",
  Func = function()
    options.fflagsbox:SetValue(v336.example())
    v174:Notify("Example loaded")
  end,
})

v546.MiscFFlagsGroup:AddButton({
  Text = "Clear",
  Func = function() options.fflagsbox:SetValue("") end,
})

v546.MiscStyleGroup = v545.Misc:AddLeftGroupbox("Auto Style Spin")

v546.MiscStyleGroup:AddToggle("autostyle", {
  Text = "Auto Style Spin",
  Tooltip = "Auto spin until target style obtained",
  Default = false,
  Callback = function(value167)
    v213 = value167

    if value167 then
      f130()
    end
  end,
})

v546.MiscStyleGroup:AddDropdown("spintype", {
  Values = { "Normal", "Lucky" },
  Default = "Normal",
  Text = "Spin Type",
  Callback = function(value168) v217 = value168 end,
})

v546.MiscStyleGroup:AddInput("targetstyle", {
  Default = "",
  Text = "Target Style (Type manually)",
  Placeholder = "Sanju",
  Callback = function(value169) v215 = { value169 } end,
})

v546.MiscStyleGroup:AddDropdown("stylelist", {
  Values = {
    "Ronin", "Hidari", "Jinko", "Timeskip Hinto", "Timeskip Kyamo", "Akuto", "Taichou", "Sanju",
    "Mikage", "Kazana", "Timeskip Okazu", "Kisuki", "Bakuri", "Kyamo", "Okazu", "Hirakumi",
    "Kozai", "Azmei", "Uchikai", "Yokai", "Yogan", "Sazuroku", "Kyoshin", "Yomosuke", "Oyatsu",
    "Tsuchiro", "Imaezi", "Tonkura", "Ninyoku", "Hinto", "Hakochi", "Yakisukai", "Sagumi",
    "Koshoti",
  },
  Default = "Ronin",
  Text = "Style List (Select to auto-fill)",
  Callback = function(value170)
    options.targetstyle:SetValue(value170)
    v215 = { value170 }
  end,
})

v546.MiscAbilityGroup = v545.Misc:AddRightGroupbox("Auto Ability Spin")

v546.MiscAbilityGroup:AddToggle("autoabilityspin", {
  Text = "Auto Ability Spin",
  Tooltip = "Auto spin until target ability obtained",
  Default = false,
  Callback = function(value171)
    v214 = value171

    if value171 then
      f118()
    end
  end,
})

v546.MiscAbilityGroup:AddDropdown("abilityspintype", {
  Values = { "Normal", "Lucky" },
  Default = "Normal",
  Text = "Ability Spin Type",
  Callback = function(value172) v218 = value172 end,
})

v546.MiscAbilityGroup:AddInput("targetability", {
  Default = "",
  Text = "Target Ability (Type manually)",
  Placeholder = "Shield Breaker",
  Callback = function(value173) v216 = { value173 } end,
})

v546.MiscAbilityGroup:AddDropdown("abilitylist", {
  Values = {
    "Shield Breaker", "Magnetic Pull", "Lead Feet", "Extra Touch", "Godly", "Redirection Jump",
    "Curve Spike", "Divine Strength", "Legendary", "Steel Block", "Zero Gravity Set", "Rare",
    "Boom Jump", "Moonball", "Common", "Super Sprint", "Team Spirit", "Rolling Thunder",
  },
  Default = "Shield Breaker",
  Text = "Ability List (Select to auto-fill)",
  Callback = function(value174)
    options.targetability:SetValue(value174)
    v216 = { value174 }
  end,
})

v546.MiscShopGroup = v545.Misc:AddRightGroupbox("Shop")

v546.MiscShopGroup:AddButton({
  Text = "Buy Emote",
  Func = function()
    local RF_4 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PackService.RF

    if RF_4 then
      local Open = RF_4:FindFirstChild("Open")

      if Open then
        Open:InvokeServer("Emote1")
      end
    end
  end,
})

v546.MiscShopGroup:AddButton({
  Text = "Buy Effect",
  Func = function()
    local RF_5 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PackService.RF

    if RF_5 then
      local Open_2 = RF_5:FindFirstChild("Open")

      if Open_2 then
        Open_2:InvokeServer("ScoreEffect1")
      end
    end
  end,
})

v546.MiscShopGroup:AddButton({
  Text = "Buy Extreme Ball",
  Func = function()
    local RF_6 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PackService.RF

    if RF_6 then
      local Open_3 = RF_6:FindFirstChild("Open")

      if Open_3 then
        Open_3:InvokeServer("Extreme")
      end
    end
  end,
})

v546.MiscShopGroup:AddButton({
  Text = "Buy Medium Ball",
  Func = function()
    local RF_7 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PackService.RF

    if RF_7 then
      local Open_4 = RF_7:FindFirstChild("Open")

      if Open_4 then
        Open_4:InvokeServer("Medium")
      end
    end
  end,
})

v546.MiscShopGroup:AddButton({
  Text = "Buy Basic Ball",
  Func = function()
    local RF_8 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PackService.RF

    if RF_8 then
      local Open_5 = RF_8:FindFirstChild("Open")

      if Open_5 then
        Open_5:InvokeServer("Basic")
      end
    end
  end,
})

v546.MiscClaimGroup = v545.Misc:AddRightGroupbox("Claim Rewards")

v546.MiscClaimGroup:AddButton({
  Text = "Claim Level Rewards",
  Func = function()
    local LevelService = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.LevelService

    if LevelService then
      local RF_9 = LevelService:FindFirstChild("RF")

      if RF_9 then
        local ClaimLevelRewards = RF_9:FindFirstChild("ClaimLevelRewards")

        if ClaimLevelRewards then
          ClaimLevelRewards:InvokeServer()
        end
      end
    end
  end,
})

v546.MiscClaimGroup:AddButton({
  Text = "Claim Quest Rewards",
  Func = function()
    local QuestService = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.QuestService

    if QuestService then
      local RF_10 = QuestService:FindFirstChild("RF")

      if RF_10 then
        local ClaimAll = RF_10:FindFirstChild("ClaimAll")

        if ClaimAll then
          ClaimAll:InvokeServer(true)
        end
      end
    end
  end,
})

do
  v546.MiscClaimGroup:AddButton({
    Text = "Redeem All Codes",
    Func = function()
      local function f131()
        local v553, v554 = pcall(function()
          return httpGet("https://beebom.com/haikyuu-legends-codes/")
        end)

        if not v553 or not v554 then
          return {}
        else
          local v555 = {}
          local v556 = {}

          for match in string.gmatch(v554, [[
[^
]+]]) do
            if string.find(match, "(NEW)") then
              local StringMatch_2 = string.match(match, "(%u+[%u%d_]+)")

              if StringMatch_2 and not v556[StringMatch_2] then
                v556[StringMatch_2] = true
                table.insert(v555, StringMatch_2)
              end
            end

            if #v555 >= 3 then
              break
            end
          end

          return v555
        end
      end

      local f131_2 = f131()

      if #f131_2 > 0 then
        for key23, value175 in pairs(f131_2) do
          local CodeService = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.CodeService

          if CodeService then
            local RF_11 = CodeService:FindFirstChild("RF")

            if RF_11 then
              local Redeem = RF_11:FindFirstChild("Redeem")

              if Redeem then
                Redeem:InvokeServer(value175)
              end
            end
          end

          task.wait(0.01)
        end
      end
    end,
  })

  v546.GameJoinGroup = v545.GameJoin:AddLeftGroupbox("Game Modes")

  for index90, value176 in ipairs({
    { "Chaos Mode", "ChaosMode" }, { "1v1 Mini Map", "OnesMini" }, { "2v2 Ranked", "Twos" },
    { "3v3 Ranked", "Threes" }, { "4v4 Ranked", "Fours" }, { "6v6 Ranked", "Sixes" },
    { "Training", "Training" },
  }) do
    local Value176 = value176

    v546.GameJoinGroup:AddButton({
      Text = Value176[1],
      Func = function()
        v174:Notify("Joining " .. Value176[1] .. "...")
        local RF_12 = replicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PartyService.RF
        local requestTeleport

        if RF_12 then
          requestTeleport = RF_12:FindFirstChild("RequestTeleport")

          if requestTeleport then
            pcall(function()
              requestTeleport:InvokeServer(Value176[2])
              v174:Notify("Joined " .. Value176[1] .. "!")
            end)
          end
        end
      end,
    })
  end

  local AddLeftGroupbox = v545["UI Settings"]:AddLeftGroupbox("Menu")

  AddLeftGroupbox:AddToggle("KeybindMenuOpen", {
    Default = v174.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value177) v174.KeybindFrame.Visible = value177 end,
  })

  AddLeftGroupbox:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(value178) v174:SetNotifySide(value178) end,
  })

  AddLeftGroupbox:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(value179) v174:SetDPIScale((tonumber((value179:gsub("%%", ""))))) end,
  })

  AddLeftGroupbox:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = v174.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value180) LOCOPANIHUBWindow:SetCornerRadius(value180) end,
  })

  AddLeftGroupbox:AddDivider()

  AddLeftGroupbox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind",
  })

  AddLeftGroupbox:AddButton("Unload", function() v174:Unload() end)

  v174.ToggleKeybind = options.MenuKeybind
end


-- LOCOPANI CONFIG UI (Rayfield Gen2)
do
  pcall(function() v174:SetConfigFolder("LOCOPANI") end)
  local configTab = LOCOPANI_RAY_WINDOW:CreateTab({ name = "Configs" })
  local configName = ""
  local selectedConfig = nil
  local configStatus
  local configDropdown
  local configNames = {}

  configTab:CreateInput({
    name = "Nome para salvar",
    placeholder = "Digite um nome para salvar",
    callback = function(value)
      configName = tostring(value or "")
    end,
  })

  local function setConfigStatus(message)
    if configStatus and configStatus.Set then
      pcall(function() configStatus:Set(message) end)
    end
    pcall(function() v174:Notify(message) end)
  end

  local function cleanConfigName(name)
    name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("[^%w_%-]", "_")
    if #name > 48 then name = name:sub(1, 48) end
    return name
  end

  local function refreshConfigList()
    local found = {}
    -- Use the same config manager as SaveConfig/LoadConfig, so the dropdown
    -- reads exactly the folder the script is configured to use.
    local ok, files = pcall(function() return v174:ListConfigs() end)
    if ok and type(files) == "table" then
      for _, item in ipairs(files) do
        local name = tostring(item):match("([^/\\]+)%.json$") or tostring(item)
        name = name:gsub("%.json$", "")
        if name ~= "" then found[name] = true end
      end
    end

    configNames = {}
    for name in pairs(found) do table.insert(configNames, name) end
    table.sort(configNames, function(a, b) return string.lower(a) < string.lower(b) end)

    if configDropdown and configDropdown.SetValues then
      configDropdown:SetValues(configNames)
    end

    if selectedConfig and not found[selectedConfig] then selectedConfig = nil end
    return configNames
  end

  -- Use the Gen2 wrapper so the dropdown can refresh through SetValues.
  configDropdown = LOCOPANI_RayControl("Dropdown", configTab, "Configurações", {
    Values = {},
    Default = nil,
    Placeholder = "Selecione uma configuração",
  }, function(selected)
    if type(selected) == "table" then selected = selected[1] end
    if type(selected) == "string" and selected ~= "" then
      selectedConfig = selected
      configName = selected
    end
  end)

  local function getConfigTarget()
    if tostring(configName or ""):gsub("%s+", "") ~= "" then
      return cleanConfigName(configName)
    end
    return cleanConfigName(selectedConfig)
  end

  configTab:CreateButton({
    name = "Atualizar lista",
    callback = function()
      refreshConfigList()
      setConfigStatus("Lista de configurações atualizada.")
    end,
  })

  configTab:CreateButton({
    name = "Salvar configuração",
    callback = function()
      local name = cleanConfigName(configName)
      if name == "" then
        setConfigStatus("Digite um nome para a nova configuração.")
        return
      end
      local saveCallOk, saveResult = pcall(function() return v174:SaveConfig(name) end)
      if saveCallOk and saveResult == true then
        selectedConfig = name
        refreshConfigList()
        if configDropdown and configDropdown.Set then
          pcall(function() configDropdown:Set(name) end)
        elseif configDropdown and configDropdown._control and configDropdown._control.Set then
          pcall(function() configDropdown._control:Set(name) end)
        end
        setConfigStatus("Configuração salva: " .. name)
      else
        setConfigStatus("Não foi possível salvar. Verifique se o executor suporta arquivos.")
      end
    end,
  })

  configTab:CreateButton({
    name = "Carregar selecionada",
    callback = function()
      local name = getConfigTarget()
      if name == "" then
        setConfigStatus("Selecione uma configuração na lista ou digite um nome.")
        return
      end
      if v174:LoadConfig(name) then
        selectedConfig = name
        setConfigStatus("Configuração carregada: " .. name)
      else
        setConfigStatus("Configuração não encontrada ou arquivo indisponível: " .. name)
      end
    end,
  })

  configTab:CreateButton({
    name = "Excluir configuração selecionada",
    callback = function()
      -- Exclusão baseada somente na seleção do dropdown, nunca no texto digitado.
      local name = cleanConfigName(selectedConfig)
      if name == "" then
        setConfigStatus("Selecione no menu a configuração que deseja excluir.")
        return
      end

      local env = (type(getgenv) == "function" and getgenv()) or _G
      local isfileFn = env.isfile or isfile
      local deleteFn = env.delfile or delfile
      local path = "LOCOPANI/configs/" .. name .. ".json"
      if type(deleteFn) ~= "function" then
        setConfigStatus("Este executor não suporta excluir arquivos (delfile).")
        return
      end

      local exists = false
      if type(isfileFn) == "function" then
        local okExists, result = pcall(isfileFn, path)
        exists = okExists and result == true
      else
        local listFn = env.listfiles or listfiles
        if type(listFn) == "function" then
          local okList, files = pcall(listFn, "LOCOPANI/configs")
          if okList and type(files) == "table" then
            for _, filePath in ipairs(files) do
              local base = tostring(filePath):match("([^/\\]+)%.json$")
              if base == name then exists = true break end
            end
          end
        end
      end
      if not exists then
        setConfigStatus("A configuração selecionada não foi encontrada.")
        refreshConfigList()
        return
      end

      local okDelete, deleteErr = pcall(deleteFn, path)
      if not okDelete then
        setConfigStatus("Falha ao excluir a configuração: " .. tostring(deleteErr))
        return
      end

      -- Remove o autoload caso ele aponte para a configuração excluída.
      local readFn = env.readfile or readfile
      local writeFn = env.writefile or writefile
      if type(readFn) == "function" and type(writeFn) == "function" then
        local okRead, autoName = pcall(readFn, "LOCOPANI/autoload.txt")
        if okRead and tostring(autoName or ""):gsub("^%s+", ""):gsub("%s+$", "") == name then
          pcall(writeFn, "LOCOPANI/autoload.txt", "")
        end
      end

      selectedConfig = nil
      configName = ""
      refreshConfigList()
      setConfigStatus("Configuração excluída: " .. name)
    end,
  })

  configTab:CreateButton({
    name = "Ativar autoload",
    callback = function()
      local name = getConfigTarget()
      if name == "" then
        setConfigStatus("Selecione uma configuração na lista primeiro.")
        return
      end
      local env = (type(getgenv) == "function" and getgenv()) or _G
      local writeFn = env.writefile or writefile
      if type(writeFn) ~= "function" then
        setConfigStatus("Este executor não suporta salvar arquivos.")
        return
      end
      local env2 = (type(getgenv) == "function" and getgenv()) or _G
      local isfileFn = env2.isfile or isfile
      local exists = false
      if type(isfileFn) == "function" then
        local okExists, result = pcall(isfileFn, "LOCOPANI/configs/" .. name .. ".json")
        exists = okExists and result == true
      else
        local listFn = env2.listfiles or listfiles
        if type(listFn) == "function" then
          local okList, files = pcall(listFn, "LOCOPANI/configs")
          if okList and type(files) == "table" then
            for _, filePath in ipairs(files) do
              if tostring(filePath):match("([^/\\\\]+)%.json$") == name then
                exists = true
                break
              end
            end
          end
        end
      end
      if not exists then
        setConfigStatus("Essa configuração ainda não existe. Salve-a primeiro.")
        return
      end
      pcall(function()
        local mk = env.makefolder or makefolder
        if type(mk) == "function" then
          pcall(mk, "LOCOPANI")
          pcall(mk, "LOCOPANI/configs")
        end
      end)
      local ok = pcall(writeFn, "LOCOPANI/autoload.txt", name)
      if ok then
        setConfigStatus("Autoload ativado: " .. name)
      else
        setConfigStatus("Não foi possível definir o autoload.")
      end
    end,
  })

  configTab:CreateButton({
    name = "Desativar autoload",
    callback = function()
      local env = (type(getgenv) == "function" and getgenv()) or _G
      local writeFn = env.writefile or writefile
      if type(writeFn) ~= "function" then
        setConfigStatus("Este executor não suporta arquivos.")
        return
      end
      local ok = pcall(writeFn, "LOCOPANI/autoload.txt", "")
      if ok then
        setConfigStatus("Autoload desativado.")
      else
        setConfigStatus("Não foi possível desativar o autoload.")
      end
    end,
  })

  refreshConfigList()
end

do
  v174:SetConfigFolder("LOCOPANI")
  pcall(function() v174:LoadAutoloadConfig() end)

  -- O botao flutuante circular com "L" foi removido.
  -- A janela principal continua podendo ser aberta/fechada com RightShift.
  v174:Notify("LOCOPANI HUB Loaded Successfully! UPDATE V2.3")
  pcall(function() LOCOPANI_RAY_WINDOW:Notify({ title = "LOCOPANI", content = "HUB Loaded Successfully! UPDATE V2.3" }) end)
end

-- https://discord.gg/34P22Bgnbk
