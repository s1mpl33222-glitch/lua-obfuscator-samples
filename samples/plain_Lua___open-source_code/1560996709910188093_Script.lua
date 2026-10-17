-- =====================================================
-- mourazx optimizer - versão corrigida
-- =====================================================

local WINDUI_URL = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
local STRETCH_BIND_NAME = "MourazxCameraStretch"

local function GetRemoteSource(url)
    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and type(source) == "string" and #source > 1000 then
        return source
    end

    local httpRequest = request or http_request or (syn and syn.request)
    if type(httpRequest) == "function" then
        local response = httpRequest({
            Url = url,
            Method = "GET",
        })

        if response and response.Body then
            return response.Body
        end
    end

    error("Delta não conseguiu baixar o WindUI. Verifique o HttpGet/request.")
end

local WindUISource = GetRemoteSource(WINDUI_URL)
local WindUILoader, loadError = loadstring(WindUISource)
if not WindUILoader then
    error("WindUI inválido: " .. tostring(loadError))
end

local WindUI = WindUILoader()
if not WindUI then
    error("WindUI retornou nil após o carregamento.")
end

local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local DISCORD_LINK = "https://discord.gg/BgDrtUVtZw"

local function Notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "mourazx optimizer",
            Text = text,
            Duration = duration or 4,
        })
    end)
end

local MiniStatusGui
local MiniStatusLabel

local function SetMiniStatus(text, visible)
    pcall(function()
        if not MiniStatusGui then
            local parent = (gethui and gethui()) or game:GetService("CoreGui")
            MiniStatusGui = Instance.new("ScreenGui")
            MiniStatusGui.Name = "MourazxMiniStatus"
            MiniStatusGui.ResetOnSpawn = false
            MiniStatusGui.IgnoreGuiInset = true
            MiniStatusGui.DisplayOrder = 999998
            MiniStatusGui.Parent = parent

            local frame = Instance.new("Frame")
            frame.Name = "Status"
            frame.Size = UDim2.fromOffset(190, 28)
            frame.Position = UDim2.fromOffset(12, 12)
            frame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
            frame.BackgroundTransparency = 0.12
            frame.BorderSizePixel = 0
            frame.Parent = MiniStatusGui

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(220, 45, 55)
            stroke.Thickness = 1
            stroke.Parent = frame

            MiniStatusLabel = Instance.new("TextLabel")
            MiniStatusLabel.BackgroundTransparency = 1
            MiniStatusLabel.Size = UDim2.fromScale(1, 1)
            MiniStatusLabel.Font = Enum.Font.GothamSemibold
            MiniStatusLabel.TextSize = 12
            MiniStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            MiniStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
            MiniStatusLabel.Parent = frame
        end

        MiniStatusLabel.Text = text or ""
        MiniStatusGui.Enabled = visible ~= false
    end)
end

local function ClearMiniStatus()
    pcall(function()
        if MiniStatusGui then
            MiniStatusGui.Enabled = false
        end
    end)
end

-- Tema vermelho para a chave dos toggles, checkbox e slider.
pcall(function()
    local darkTheme = WindUI:GetThemes().Dark
    local redTheme = {}

    for key, value in pairs(darkTheme) do
        redTheme[key] = value
    end

    redTheme.Name = "MourazxRed"
    redTheme.Toggle = Color3.fromRGB(220, 45, 55)
    redTheme.Checkbox = Color3.fromRGB(220, 45, 55)
    redTheme.Slider = Color3.fromRGB(220, 45, 55)
    redTheme.Primary = Color3.fromRGB(220, 45, 55)
    redTheme.Accent = Color3.fromRGB(12, 12, 15)
    redTheme.Outline = Color3.fromRGB(0, 0, 0)
    redTheme.Button = Color3.fromRGB(150, 25, 35)
    redTheme.ElementBackground = Color3.fromRGB(18, 18, 22)
    redTheme.Background = Color3.fromRGB(7, 7, 10)
    redTheme.PanelBackground = Color3.fromRGB(8, 8, 11)
    redTheme.Icon = Color3.fromRGB(255, 95, 100)

    WindUI:AddTheme(redTheme)
    WindUI:SetTheme("MourazxRed")
end)

Notify("Comunidade Blox Fruits & Otimização:\n" .. DISCORD_LINK, 6)

if type(setclipboard) == "function" then
    pcall(function()
        setclipboard(DISCORD_LINK)
    end)
end

getgenv().StretchEnabled = false
getgenv().StretchIntensity = 0.75

local function StopStretch()
    SetMiniStatus("Tela esticada: desativando...", true)
    pcall(function()
        RunService:UnbindFromRenderStep(STRETCH_BIND_NAME)
    end)

    getgenv().StretchConn = nil
    ClearMiniStatus()
end

local function ApplyStretch()
    SetMiniStatus("Tela esticada: ativando...", true)
    -- Evita criar vários binds quando o usuário liga/desliga a função.
    StopStretch()

    RunService:BindToRenderStep(
        STRETCH_BIND_NAME,
        Enum.RenderPriority.Camera.Value + 1,
        function()
            local camera = workspace.CurrentCamera

            if not getgenv().StretchEnabled or not camera then
                return
            end

            local intensity = math.clamp(
                tonumber(getgenv().StretchIntensity) or 0.75,
                0.50,
                1.20
            )

            -- O CFrame original é restaurado antes de aplicar a nova intensidade.
            -- Assim o slider não acumula a distorção a cada frame.
            local original = camera.CFrame

            camera.CFrame = original * CFrame.new(
                0, 0, 0,
                1, 0, 0,
                0, intensity, 0,
                0, 0, 1
            )
        end
    )

    getgenv().StretchConn = true
    ClearMiniStatus()
end

local OptimizationRunning = false

local function BeginOptimization()
    if OptimizationRunning then
        Notify("Uma otimização já está em andamento.", 3)
        return false
    end

    OptimizationRunning = true
    return true
end

local function EndOptimization()
    OptimizationRunning = false
end

local YieldWithinBudget
local MobileAntiLagActive = false

local function ApplyMobileAntiLag()
    if MobileAntiLagActive or not BeginOptimization() then
        return
    end

    MobileAntiLagActive = true
    SetMiniStatus("Mobile Anti-Lag: otimizando...", true)
    Notify("Mobile Anti-Lag iniciado em microetapas.", 3)

    task.defer(function()
        local ok, errorMessage = pcall(function()
            local lighting = game:GetService("Lighting")
            local started = os.clock()

            pcall(function()
                local settings = UserSettings():GetService("UserGameSettings")
                settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)

            lighting.GlobalShadows = false
            lighting.Brightness = 1
            lighting.Ambient = Color3.fromRGB(150, 150, 150)
            lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
            lighting.FogStart = 0
            lighting.FogEnd = 9e9

            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                pcall(function()
                    terrain.Decoration = false
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                end)
            end

            -- Fila visual: não reprocessa cada parte do mapa nem altera rede/física.
            for _, object in ipairs(game:GetDescendants()) do
                pcall(function()
                    if object:IsA("ParticleEmitter") then
                        object.Rate = math.min(object.Rate, 2)
                        object.Enabled = false
                    elseif object:IsA("Trail") or object:IsA("Beam")
                        or object:IsA("Smoke") or object:IsA("Fire")
                        or object:IsA("Sparkles") or object:IsA("Highlight")
                        or object:IsA("PostEffect") or object:IsA("PointLight")
                        or object:IsA("SpotLight") or object:IsA("SurfaceLight") then
                        object.Enabled = false
                    elseif object:IsA("Atmosphere") then
                        object.Density = 0
                        object.Haze = 0
                        object.Glare = 0
                    elseif object:IsA("Clouds") then
                        object.Cover = 0
                        object.Density = 0
                    end
                end)

                started = YieldWithinBudget(started, 0.0005)
            end

            if type(setfpscap) == "function" then
                pcall(function()
                    setfpscap(60)
                end)
            end
        end)

        EndOptimization()
        MobileAntiLagActive = false
        ClearMiniStatus()
        if ok then
            Notify("Mobile Anti-Lag concluído gradualmente.", 5)
        else
            Notify("Mobile Anti-Lag interrompido: " .. tostring(errorMessage), 5)
        end
    end)
end

local function YieldWithinBudget(started, budget)
    if os.clock() - started >= (budget or 0.002) then
        RunService.Heartbeat:Wait()
        return os.clock()
    end

    return started
end

local LiveVFXEnabled = false
local LiveVFXConnections = {}
local LiveVFXSeen = setmetatable({}, {__mode = "k"})

local function IsLiveVFXObject(object)
    return object:IsA("ParticleEmitter")
        or object:IsA("Trail")
        or object:IsA("Beam")
        or object:IsA("Smoke")
        or object:IsA("Fire")
        or object:IsA("Sparkles")
        or object:IsA("Highlight")
        or object:IsA("PostEffect")
        or object:IsA("PointLight")
        or object:IsA("SpotLight")
        or object:IsA("SurfaceLight")
end

local function ReduceNewVFX(object)
    if not LiveVFXEnabled or LiveVFXSeen[object] or not object.Parent then
        return
    end

    LiveVFXSeen[object] = true
    if IsLiveVFXObject(object) then
        pcall(function()
            if object:IsA("ParticleEmitter") then
                object.Rate = 0
            end
            if object:IsA("PostEffect")
                or object:IsA("ParticleEmitter")
                or object:IsA("Trail")
                or object:IsA("Beam")
                or object:IsA("Smoke")
                or object:IsA("Fire")
                or object:IsA("Sparkles")
                or object:IsA("Highlight")
                or object:IsA("PointLight")
                or object:IsA("SpotLight")
                or object:IsA("SurfaceLight") then
                object.Enabled = false
            end
        end)
    end
end

local function StopLiveVFXMonitor()
    LiveVFXEnabled = false
    for _, connection in ipairs(LiveVFXConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    LiveVFXConnections = {}
    LiveVFXSeen = setmetatable({}, {__mode = "k"})
    ClearMiniStatus()
end

local function StartLiveVFXMonitor()
    if LiveVFXEnabled then
        return
    end

    LiveVFXEnabled = true
    SetMiniStatus("Live VFX: monitorando...", true)

    local roots = {
        workspace,
        game:GetService("Lighting"),
    }
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            table.insert(roots, playerGui)
        end
    end)

    for _, root in ipairs(roots) do
        table.insert(LiveVFXConnections, root.DescendantAdded:Connect(function(object)
            task.defer(ReduceNewVFX, object)
        end))
    end

    task.delay(2, function()
        if LiveVFXEnabled then
            ClearMiniStatus()
        end
    end)
end

local FPSGui
local FPSLabel
local FPSRenderConnection
local FPSUpdateConnection
local FPSInputChangedConnection
local FPSDragging = false
local FPSDragStart
local FPSStartPosition

local function DestroyFPSCounter()
    if FPSRenderConnection then
        FPSRenderConnection:Disconnect()
        FPSRenderConnection = nil
    end

    if FPSUpdateConnection then
        FPSUpdateConnection:Disconnect()
        FPSUpdateConnection = nil
    end

    if FPSInputChangedConnection then
        FPSInputChangedConnection:Disconnect()
        FPSInputChangedConnection = nil
    end

    if FPSGui then
        FPSGui:Destroy()
        FPSGui = nil
        FPSLabel = nil
    end
end

local function CreateFPSCounter()
    DestroyFPSCounter()

    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    FPSGui = Instance.new("ScreenGui")
    FPSGui.Name = "MourazxFPSCounter"
    FPSGui.ResetOnSpawn = false
    FPSGui.IgnoreGuiInset = true
    FPSGui.DisplayOrder = 999999
    FPSGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "FPSFrame"
    frame.Size = UDim2.fromOffset(130, 34)
    frame.Position = UDim2.new(1, -108, 0, 18)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Active = false
    frame.Parent = FPSGui

    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.fromScale(1, 1)
    FPSLabel.BackgroundTransparency = 1
    -- Arcade é a fonte pixelada mais próxima do estilo Minecraft disponível
    -- nativamente no Roblox, sem depender de asset externo.
    FPSLabel.Font = Enum.Font.Arcade
    FPSLabel.TextSize = 21
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
    FPSLabel.TextYAlignment = Enum.TextYAlignment.Center
    FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FPSLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    FPSLabel.TextStrokeTransparency = 0
    FPSLabel.Text = "FPS  --"
    FPSLabel.Parent = frame

    local frames = 0
    local elapsed = 0

    FPSRenderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        frames += 1
        elapsed += deltaTime
    end)

    FPSUpdateConnection = RunService.Heartbeat:Connect(function()
        if elapsed >= 0.25 and FPSLabel then
            local fps = math.floor((frames / elapsed) + 0.5)

            FPSLabel.Text = "FPS  " .. tostring(fps)
            FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            frames = 0
            elapsed = 0
        end
    end)
end

local function CleanClientMemory()
    SetMiniStatus("Memória Lua: limpando...", true)
    local before = collectgarbage("count")

    -- Libera objetos Lua sem remover partes do mapa ou texturas do jogo.
    collectgarbage("collect")
    task.wait()
    collectgarbage("collect")

    local after = collectgarbage("count")
    local released = math.max(0, before - after)
    ClearMiniStatus()
    Notify(string.format("Limpeza concluída: %.1f KB de memória Lua liberados.", released), 5)
end

local Window = WindUI:CreateWindow({
    Title = "mourazx optimizer",
    Author = ":by @mourazx_",
    Folder = "MourazxOptimizer",
    Size = UDim2.fromOffset(500, 340),
    Transparent = false,
    Theme = "MourazxRed",
    Draggable = true,
    OpenButton = {
        Color = ColorSequence.new(
            Color3.fromRGB(0, 0, 0),
            Color3.fromRGB(0, 0, 0)
        ),
        StrokeThickness = 2,
        CornerRadius = UDim.new(1, 0),
        Draggable = true,
    },
})

local MainTab = Window:Tab({
    Title = "Screen",
    Icon = "monitor",
})

local OptiTab = Window:Tab({
    Title = "Optimization",
    Icon = "zap",
})

local LiveVFXTab = Window:Tab({
    Title = "Live VFX",
    Icon = "activity",
})


-- =====================================================
-- ABA SCREEN
-- =====================================================
MainTab:Section({
    Title = "Stretched Screen Settings",
})

MainTab:Toggle({
    Title = "Enable Stretched Screen",
    Desc = "Ativa a resolução de tela esticada",
    Value = false,
    Callback = function(value)
        getgenv().StretchEnabled = value

        if value then
            ApplyStretch()
        else
            StopStretch()
        end
    end,
})

MainTab:Slider({
    Title = "Stretch Intensity",
    Desc = "Ajusta a intensidade da tela esticada",
    Value = {
        Min = 50,
        Max = 120,
        Default = 75,
    },
    Step = 1,
    Callback = function(value)
        getgenv().StretchIntensity = tonumber(value) / 100
    end,
})

-- =====================================================
-- ABA OPTIMIZATION
-- =====================================================
OptiTab:Section({
    Title = "Moura Anti-Lag Engine",
})

OptiTab:Toggle({
    Title = "Dynamic FPS Counter",
    Desc = "Mostra FPS em tempo real; arraste o painel pela tela",
    Value = false,
    Callback = function(value)
        if value then
            CreateFPSCounter()
        else
            DestroyFPSCounter()
        end
    end,
})


OptiTab:Button({
    Title = "Clean Client Lua Memory",
    Desc = "Executa coleta segura de memória sem apagar o mapa",
    Callback = function()
        task.defer(CleanClientMemory)
    end,
})





OptiTab:Button({
    Title = "Apply Native FPS Boost",
    Desc = "Céu sem Sky com filtro cinza, fog da ilha Tiki removido, sombras e VFX reduzidos",
    Callback = function()
        if not BeginOptimization() then
            return
        end

        SetMiniStatus("Native FPS: otimizando...", true)
        Notify("Otimizando gráficos e texturas...", 3)

        task.defer(function()
            local ok, errorMessage = pcall(function()
                local Lighting = game:GetService("Lighting")
                local started = os.clock()

                Lighting.GlobalShadows = false
                -- Mantém a noite clara e cinza sem alterar o ClockTime.
                Lighting.Brightness = 1
                Lighting.Ambient = Color3.fromRGB(150, 150, 150)
                Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
                Lighting.ExposureCompensation = 1
                Lighting.FogStart = 0
                Lighting.FogEnd = 9e9
                Lighting.Technology = Enum.Technology.Compatibility

                -- Remove o Sky e todas as fontes de neblina do Lighting.
                for _, effect in ipairs(Lighting:GetDescendants()) do
                    if effect:IsA("Sky") then
                        pcall(function()
                            effect:Destroy()
                        end)
                    elseif effect:IsA("Atmosphere") then
                        effect.Density = 0
                        effect.Haze = 0
                        effect.Glare = 0
                    elseif effect:IsA("Clouds") then
                        effect.Cover = 0
                        effect.Density = 0
                    end
                end

                -- Alguns executores oferecem setfpscap; em outros, esta etapa
                -- é ignorada e o Anti-Lag segue funcionando normalmente.
                if type(setfpscap) == "function" then
                    pcall(function()
                        setfpscap(90)
                    end)
                end

                for _, object in ipairs(game:GetDescendants()) do
                    pcall(function()
                        if object:IsA("BasePart") then
                            object.Material = Enum.Material.SmoothPlastic
                            object.Reflectance = 0
                        elseif object:IsA("ParticleEmitter")
                            or object:IsA("Trail")
                            or object:IsA("Smoke")
                            or object:IsA("Fire")
                            or object:IsA("Sparkles") then
                            object.Enabled = false
                        elseif object:IsA("PostEffect") then
                            object.Enabled = false
                        elseif object:IsA("Sky") then
                            object:Destroy()
                        elseif object:IsA("Atmosphere") then
                            object.Density = 0
                            object.Haze = 0
                            object.Glare = 0
                        elseif object:IsA("Clouds") then
                            object.Cover = 0
                            object.Density = 0
                        end
                    end)

                    started = YieldWithinBudget(started)
                end

                -- Sem Sky, o cliente pode exibir um fundo azulado. Este
                -- filtro local remove a saturação azul e mantém o visual em
                -- tons de cinza durante a sessão.
                local grayFilter = Lighting:FindFirstChild("MourazxGraySkyFilter")
                if not grayFilter then
                    grayFilter = Instance.new("ColorCorrectionEffect")
                    grayFilter.Name = "MourazxGraySkyFilter"
                    grayFilter.Parent = Lighting
                end
                grayFilter.Saturation = -1
                grayFilter.Contrast = -0.1
                grayFilter.Brightness = 0.08
                grayFilter.TintColor = Color3.fromRGB(190, 190, 190)
            end)

            EndOptimization()
            ClearMiniStatus()

            if ok then
                Notify("Jogo otimizado gradualmente com sucesso!", 5)
            else
                Notify("Otimização interrompida: " .. tostring(errorMessage), 5)
            end
        end)
    end,
})


OptiTab:Button({
    Title = "Copy Discord Link",
    Desc = "Copia o convite da comunidade",
    Callback = function()
        if type(setclipboard) == "function" then
            local copied = pcall(function()
                setclipboard(DISCORD_LINK)
            end)

            if copied then
                Notify("Link do Discord copiado!", 4)
            else
                Notify("Não foi possível copiar o link.", 4)
            end
        else
            Notify("Clipboard não suportado neste executor.", 4)
        end
    end,
})

-- =====================================================
-- ABA LIVE VFX
-- =====================================================
LiveVFXTab:Section({
    Title = "Monitor de efeitos novos",
})

LiveVFXTab:Paragraph({
    Title = "Sem nova varredura",
    Desc = "Processa somente partículas e efeitos criados depois da ativação.",
})

LiveVFXTab:Toggle({
    Title = "Reduce New VFX",
    Desc = "Desliga partículas, beams, trails, luzes e pós-efeitos novos",
    Value = false,
    Callback = function(value)
        if value then
            StartLiveVFXMonitor()
        else
            StopLiveVFXMonitor()
        end
    end,
})

-- Garante que a janela abra diretamente na aba Screen.
task.defer(function()
    -- Nesta versão do WindUI, Window:SelectTab espera o índice da aba,
    -- enquanto a própria aba já expõe o método correto: :Select().
    MainTab:Select()
end)
