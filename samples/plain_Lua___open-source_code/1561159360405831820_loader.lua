local DZ_HOST  = "https://dzhub.xyz"
local DEV_MODE = _G.DevMode
local DEV_PORT = type(DEV_MODE) == "string" and DEV_MODE or "9000"

local scripts = {
    [2324662457] = { dev = "AnimeFighters" },
    [358276974] = { dev = "ApocalypseRising2" },
    [4658598196] = { dev = "AttackonTitanRevolution" },
    [7440311707] = { dev = "DevilHunter" },
    [9931749389] = { dev = "DungeonQuestReborn" },
    [8204806107] = { dev = "InfiniteNightsWithFreddy" },
    [9382839773] = { dev = "LineagePiece" },
    [8307114974] = { dev = "operationone" },
    [3317771874] = { dev = "Petsim99", id = "petsimulator99" },
    [1511883870] = { dev = "ShindoLife" },
    [5595353122] = { dev = "Slayers2" },
    [10563114921] = { dev = "StealAnEgg" },
    [7970033072] = { dev = "TheVeil" },
}

local function notify(title, msg, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DZ Hub — " .. title, Text = msg, Duration = dur or 8,
        })
    end)
    warn("[DZ Hub] " .. title .. ": " .. msg)
end

-- Autoexec e o queue_on_teleport rodam o loader antes de o jogo carregar. Sem
-- esperar, o GameId ainda e 0 (o loader saia sem dizer nada) e o LocalPlayer
-- nao existe (o HWID sem gethwid virava "uid:0:<executor>", igual pra todo
-- mundo do mesmo executor, e ficava guardado na sessao inteira).
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait(0.1) end

local entry = scripts[game.GameId]
if not entry then return end

local scriptName = entry.dev
local id = entry.id or scriptName:lower()

local function getHwid()
    local ok, v = pcall(function() return gethwid and gethwid() end)
    if ok and type(v) == "string" and #v >= 8 then return v end
    local ok2, v2 = pcall(function() return syn and syn.gethwid and syn:gethwid() end)
    if ok2 and type(v2) == "string" and #v2 >= 8 then return v2 end
    local ex = "unknown"
    pcall(function() ex = tostring((identifyexecutor and identifyexecutor()) or "unknown") end)
    local lp = game:GetService("Players").LocalPlayer
    return "uid:" .. tostring(lp and lp.UserId or 0) .. ":" .. ex
end

local function qenc(s)
    return (tostring(s):gsub("[^%w%-._~]", function(c)
        return string.format("%%%02X", c:byte())
    end))
end

local env = (getgenv and getgenv()) or _G
local hwid = env.DzHub_Hwid
-- Um "uid:0:" guardado por um loader de antes da espera la em cima e jogado
-- fora: ele nao identifica maquina nenhuma.
if type(hwid) ~= "string" or #hwid < 8 or hwid:find("^uid:0:") then
    hwid = getHwid()
    env.DzHub_Hwid = hwid
end

local KEY_FILES = { "DZHUB/key.txt", "DZHUB_key.txt" }

local function readSavedKey()
    for _, path in ipairs(KEY_FILES) do
        local ok, body = pcall(function()
            return isfile(path) and readfile(path) or nil
        end)
        if ok and type(body) == "string" then
            local k = body:gsub("%s+", "")
            if #k >= 8 then return k end
        end
    end
    return nil
end

local function saveKey(key)
    pcall(function()
        if not isfolder("DZHUB") then makefolder("DZHUB") end
    end)
    for _, path in ipairs(KEY_FILES) do
        if pcall(writefile, path, key) then
            local ok, back = pcall(readfile, path)
            if ok and back == key then return true end
        end
    end
    return false
end

local function forgetKey()
    for _, path in ipairs(KEY_FILES) do
        pcall(function()
            if isfile(path) then delfile(path) end
        end)
    end
end

if not env.DzHub_Key then
    env.DzHub_Key = readSavedKey()
end

local execName = "unknown"
pcall(function() execName = tostring((identifyexecutor and identifyexecutor()) or "unknown") end)

local function fetchScript()
    local u = DZ_HOST .. "/api/script/" .. id .. "?t=" .. tostring(tick())
    if env.DzHub_Key then
        u = u .. "&key=" .. qenc(env.DzHub_Key) .. "&hwid=" .. qenc(hwid) .. "&ex=" .. qenc(execName)
    end
    return pcall(game.HttpGet, game, u)
end

local function keyWindow(opts)
    local lp = game:GetService("Players").LocalPlayer
    if not lp then return nil end
    local okHui, hui = pcall(function() return gethui and gethui() end)
    local host = (okHui and hui) or lp:WaitForChild("PlayerGui", 5)
    if not host then return nil end
    local TweenService = game:GetService("TweenService")

    local WHITE = Color3.fromRGB(245, 245, 245)
    local INK = Color3.fromRGB(12, 12, 12)
    local MUTED = Color3.fromRGB(165, 165, 165)
    local FAINT = Color3.fromRGB(115, 115, 115)
    local LINE = Color3.fromRGB(46, 46, 46)
    local TONE = {
        info = MUTED,
        ok = Color3.fromRGB(96, 208, 138),
        warn = Color3.fromRGB(240, 176, 84),
        bad = Color3.fromRGB(236, 98, 88),
    }

    local function make(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do
            o[k] = v
        end
        o.Parent = parent
        return o
    end

    local function tween(o, t, props)
        pcall(function()
            TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
        end)
    end

    local gui = make("ScreenGui", {
        Name = "DzHubKeyGate", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 99999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, nil)
    local backdrop = make("Frame", {
        Name = "Backdrop", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, Active = true,
    }, gui)

    local card = make("Frame", {
        Name = "Card", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -32, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13), BorderSizePixel = 0,
    }, gui)
    make("UISizeConstraint", { MaxSize = Vector2.new(420, math.huge) }, card)
    make("UICorner", { CornerRadius = UDim.new(0, 16) }, card)
    make("UIStroke", { Color = LINE, Thickness = 1 }, card)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 20), PaddingBottom = UDim.new(0, 22),
        PaddingLeft = UDim.new(0, 22), PaddingRight = UDim.new(0, 22),
    }, card)
    make("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, card)
    local scale = make("UIScale", { Scale = 0.96 }, card)

    local header = make("Frame", { Name = "Header", LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1 }, card)
    make("TextLabel", {
        Name = "Brand", Size = UDim2.new(1, -32, 1, 0), BackgroundTransparency = 1,
        Font = Enum.Font.BuilderSansExtraBold, TextSize = 14, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, Text = "DZ HUB",
    }, header)
    local close = make("TextButton", {
        Name = "Close", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 6, 0.5, 0),
        Size = UDim2.fromOffset(30, 30), BackgroundTransparency = 1, AutoButtonColor = false,
        Font = Enum.Font.BuilderSansMedium, TextSize = 24, TextColor3 = FAINT, Text = "×",
    }, header)

    make("TextLabel", {
        Name = "Title", LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.BuilderSansBold, TextSize = 26, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Text = "Enter your key",
    }, card)
    make("TextLabel", {
        Name = "Body", LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.BuilderSans, TextSize = 15, TextColor3 = MUTED,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, LineHeight = 1.15,
        Text = "Get a free key on dzhub.xyz (sign in with Discord, one or two quick steps) and paste it below. It locks to this device and stays saved until it expires.",
    }, card)

    local field = make("Frame", {
        Name = "Field", LayoutOrder = 4, Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Color3.fromRGB(7, 7, 7), BorderSizePixel = 0,
    }, card)
    make("UICorner", { CornerRadius = UDim.new(0, 10) }, field)
    local fieldStroke = make("UIStroke", { Color = LINE, Thickness = 1 }, field)
    local box = make("TextBox", {
        Name = "KeyBox", Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, 0),
        BackgroundTransparency = 1, ClearTextOnFocus = false, Font = Enum.Font.RobotoMono, TextSize = 15,
        TextColor3 = WHITE, PlaceholderColor3 = FAINT, PlaceholderText = "DZH-XXXXX-XXXXX-XXXXX-XXXXX",
        TextXAlignment = Enum.TextXAlignment.Left, Text = opts.prefill or "",
    }, field)

    local status = make("TextLabel", {
        Name = "Status", LayoutOrder = 5, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.BuilderSansMedium, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Text = "",
    }, card)
    local function setStatus(text, tone)
        status.Text = text or ""
        status.TextColor3 = TONE[tone or "info"] or MUTED
        status.Visible = status.Text ~= ""
    end
    setStatus(opts.message, opts.tone)

    local row = make("Frame", { Name = "Buttons", LayoutOrder = 6, Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1 }, card)
    local function pill(name, text, primary)
        local base = primary and WHITE or Color3.fromRGB(26, 26, 26)
        local hover = primary and Color3.fromRGB(222, 222, 222) or Color3.fromRGB(40, 40, 40)
        local b = make("TextButton", {
            Name = name, Position = UDim2.new(primary and 0.5 or 0, primary and 5 or 0, 0, 0),
            Size = UDim2.new(0.5, -5, 1, 0), AutoButtonColor = false, BorderSizePixel = 0,
            Font = Enum.Font.BuilderSansBold, TextSize = 15, Text = text,
            BackgroundColor3 = base, TextColor3 = primary and INK or WHITE,
        }, row)
        make("UICorner", { CornerRadius = UDim.new(1, 0) }, b)
        if not primary then
            make("UIStroke", { Color = LINE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, b)
        end
        b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundColor3 = hover }) end)
        b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundColor3 = base }) end)
        return b
    end
    local getBtn = pill("GetKey", "Get key", false)
    local okBtn = pill("Unlock", "Unlock", true)

    -- Quem ja tem key na conta nao devia digitar nada. O jogo nao sabe quem a
    -- pessoa e (nao ha login aqui dentro), entao pede um codigo curto ao site,
    -- mostra o codigo, e espera: a pessoa digita esse codigo no dzhub.xyz/link,
    -- ja logada, escolhe uma key dela, e a key chega aqui sozinha.
    local linkBtn = make("TextButton", {
        Name = "UseAccount", LayoutOrder = 7, Size = UDim2.new(1, 0, 0, 40),
        AutoButtonColor = false, BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        Font = Enum.Font.BuilderSansMedium, TextSize = 14, TextColor3 = MUTED,
        Text = "Use a key from my account",
    }, card)
    make("UICorner", { CornerRadius = UDim.new(1, 0) }, linkBtn)
    make("UIStroke", { Color = LINE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, linkBtn)
    linkBtn.MouseEnter:Connect(function() tween(linkBtn, 0.12, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }) end)
    linkBtn.MouseLeave:Connect(function() tween(linkBtn, 0.12, { BackgroundColor3 = Color3.fromRGB(18, 18, 18) }) end)

    -- Dentro do jogo nao ha link pra clicar: o endereco precisa estar escrito
    -- por extenso, do lado do codigo, senao a pessoa ve um codigo grande e nao
    -- sabe onde usar. Os dois passos ficam numerados no mesmo painel.
    local linkSite = (DZ_HOST:gsub("^https?://", "")) .. "/link"
    local pairPanel = make("Frame", {
        Name = "Pairing", LayoutOrder = 8, Visible = false,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(7, 7, 7), BorderSizePixel = 0,
    }, card)
    make("UICorner", { CornerRadius = UDim.new(0, 10) }, pairPanel)
    make("UIStroke", { Color = LINE, Thickness = 1 }, pairPanel)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16),
    }, pairPanel)
    make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, pairPanel)

    local function pairStep(order, text)
        make("TextLabel", {
            LayoutOrder = order, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Font = Enum.Font.BuilderSansMedium, TextSize = 12, TextColor3 = FAINT,
            TextXAlignment = Enum.TextXAlignment.Left, Text = text,
        }, pairPanel)
    end

    pairStep(1, "1 — Open in your browser")
    make("TextLabel", {
        Name = "Site", LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.BuilderSansBold, TextSize = 19, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, Text = linkSite,
    }, pairPanel)
    make("Frame", {
        Name = "Rule", LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = LINE, BorderSizePixel = 0,
    }, pairPanel)
    pairStep(4, "2 — Type this code there")
    local codeLabel = make("TextLabel", {
        Name = "Code", LayoutOrder = 5, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.RobotoMono, TextSize = 30, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, Text = "",
    }, pairPanel)

    make("TextLabel", {
        Name = "Footer", LayoutOrder = 9, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.BuilderSans, TextSize = 13, TextColor3 = FAINT,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        Text = "Changed PC or executor? Reset your key's HWID at dzhub.xyz/dashboard.",
    }, card)

    local closed, result, busy = false, nil, false
    local function finish(value)
        if closed then return end
        closed = true
        result = value
        tween(scale, 0.14, { Scale = 0.96 })
        tween(backdrop, 0.14, { BackgroundTransparency = 1 })
        task.delay(0.15, function() gui:Destroy() end)
    end

    local function submit()
        if busy or closed then return end
        local key = (box.Text or ""):gsub("%s+", "")
        if #key < 8 then
            setStatus("Paste your key first.", "bad")
            return
        end
        busy = true
        okBtn.Text = "Checking…"
        box.TextEditable = false
        local ok, message, tone, keep = opts.check(key)
        busy = false
        okBtn.Text = "Unlock"
        box.TextEditable = true
        if closed then return end
        if ok then
            setStatus("Key accepted.", "ok")
            finish(key)
            return
        end
        setStatus(message, tone)
        if not keep then box.Text = "" end
    end

    okBtn.MouseButton1Click:Connect(submit)
    box.FocusLost:Connect(function(enter)
        tween(fieldStroke, 0.12, { Color = LINE })
        if enter then submit() end
    end)
    box.Focused:Connect(function() tween(fieldStroke, 0.12, { Color = Color3.fromRGB(125, 125, 125) }) end)
    getBtn.MouseButton1Click:Connect(function()
        local copied = pcall(function() setclipboard(opts.keyUrl) end)
        local shown = opts.keyUrl:gsub("^https?://", "")
        setStatus(copied and ("Link copied. Open it in your browser: " .. shown)
            or ("Open " .. shown .. " in your browser to get a key."), "info")
    end)
    local linking = false
    linkBtn.MouseButton1Click:Connect(function()
        if busy or closed or linking or not opts.link then return end
        linking = true
        linkBtn.Text = "Asking the site…"
        local pair = opts.link()
        if closed then return end
        if not pair then
            linking = false
            linkBtn.Text = "Use a key from my account"
            if pair == false then
                setStatus("Too many codes from this device. Wait a few minutes and try again.", "warn")
            else
                setStatus("Could not reach DZ HUB. Try again.", "bad")
            end
            return
        end

        codeLabel.Text = pair.code
        pairPanel.Visible = true
        linkBtn.Text = "Waiting for the site…"
        -- No PC vale mais o endereco inteiro com o codigo dentro: quem cola no
        -- navegador nao digita nada. No celular a pessoa le o painel e digita.
        local copied = pcall(function() setclipboard(DZ_HOST .. "/link?c=" .. pair.code) end)
        setStatus(copied and ("Address copied — paste it in your browser.")
            or ("Open " .. linkSite .. " and type the code."), "info")

        -- O codigo vive 5 minutos do lado do site; aqui a espera acompanha isso
        -- e desiste junto, pra ninguem ficar olhando um codigo morto.
        task.spawn(function()
            local deadline = os.clock() + 300
            while not closed and os.clock() < deadline do
                task.wait(2)
                if closed then return end
                local got = opts.poll(pair.token)
                if got == nil then
                    linking = false
                    pairPanel.Visible = false
                    linkBtn.Text = "Use a key from my account"
                    setStatus("The code expired. Press the button for a new one.", "warn")
                    return
                end
                if got ~= "pending" then
                    pairPanel.Visible = false
                    linkBtn.Text = "Use a key from my account"
                    linking = false
                    box.Text = got
                    setStatus("Key received. Checking…", "info")
                    submit()
                    return
                end
            end
            if not closed and linking then
                linking = false
                pairPanel.Visible = false
                linkBtn.Text = "Use a key from my account"
                setStatus("The code expired. Press the button for a new one.", "warn")
            end
        end)
    end)

    close.MouseButton1Click:Connect(function() finish(nil) end)
    close.MouseEnter:Connect(function() close.TextColor3 = WHITE end)
    close.MouseLeave:Connect(function() close.TextColor3 = FAINT end)
    gui.Destroying:Connect(function() closed = true end)

    gui.Parent = host
    tween(backdrop, 0.18, { BackgroundTransparency = 0.45 })
    tween(scale, 0.18, { Scale = 1 })

    while not closed do
        task.wait(0.05)
    end
    return result
end

local LOCKED = "This key is locked to another device. Reset its HWID at dzhub.xyz/dashboard, then press Unlock."

local function checkKey(key)
    local u = DZ_HOST .. "/api/key/check?key=" .. qenc(key) .. "&hwid=" .. qenc(hwid)
    local ok, body = pcall(game.HttpGet, game, u)
    if not ok or type(body) ~= "string" or body == "" then
        return false, "Could not reach DZ HUB. Check your connection and try again.", "bad", true
    end
    if body:find('"ok":true', 1, true) then return true end
    if body:find('"why":"hwid"', 1, true) then return false, LOCKED, "warn", true end
    if body:find('"why":"rate"', 1, true) then return false, "Too many tries. Wait a minute and try again.", "warn", true end
    return false, "Invalid or expired key. Get a new one on the site.", "bad", false
end

-- Pareamento com a conta: GET nos dois lados porque game:HttpGet e a unica
-- chamada que todo executor tem. POST dependeria do request(), que varia de
-- executor pra executor — e esta e a chamada que precisa funcionar em todos.
local function linkStart()
    local u = DZ_HOST .. "/api/link/start?hwid=" .. qenc(hwid) .. "&ex=" .. qenc(execName)
    local ok, body = pcall(game.HttpGet, game, u)
    if not ok or type(body) ~= "string" then return nil end
    local code = body:match('"code":"([^"]+)"')
    local tok = body:match('"token":"([0-9a-f]+)"')
    if code and tok then return { code = code, token = tok } end
    -- Limite do site (codigos demais desta maquina, ou pareamentos demais no
    -- ar): false, pra janela dizer isso em vez de "nao alcancou o site".
    if body:find('"error":"rate"', 1, true) or body:find('"error":"busy"', 1, true) then return false end
    return nil
end

-- Tres respostas: a key, "pending" (segue esperando) e nil (o codigo morreu).
-- Rede tremendo no meio nao mata a espera: vira "pending" e tenta de novo.
local function linkPoll(tok)
    local u = DZ_HOST .. "/api/link/poll?t=" .. qenc(tok)
    local ok, body = pcall(game.HttpGet, game, u)
    if not ok or type(body) ~= "string" or body == "" then return "pending" end
    if body:find('"pending":true', 1, true) then return "pending" end
    local key = body:match('"key":"([^"]+)"')
    if key then return key end
    return nil
end

local function runKeyGate(firstLine, keyUrl)
    local prefill, message, tone = nil, nil, nil
    if env.DzHub_Key then
        if firstLine:find("another machine", 1, true) then
            prefill, message, tone = env.DzHub_Key, LOCKED, "warn"
        else
            forgetKey()
            message, tone = "Your saved key stopped working (expired or revoked). Get a new one on the site.", "bad"
        end
        env.DzHub_Key = nil
    end
    local keyIn = keyWindow({
        keyUrl = keyUrl, prefill = prefill, message = message, tone = tone,
        check = checkKey, link = linkStart, poll = linkPoll,
    })
    if not keyIn then return false end
    env.DzHub_Key = keyIn
    saveKey(keyIn)
    return true
end

local httpOk, source
if DEV_MODE then
    local u = "http://127.0.0.1:" .. DEV_PORT .. "/scripts/wip/" .. scriptName .. ".lua?t=" .. tostring(tick())
    httpOk, source = pcall(game.HttpGet, game, u)
    -- DevMode mora no _G e vale a sessao inteira do Roblox: uma vez ligado,
    -- todo run seguinte busca no 127.0.0.1 e volta VAZIO enquanto o servidor de
    -- dev nao esta de pe. O erro que aparecia era "Empty response", que nao
    -- dizia nada disso e parecia o site fora do ar (relatado em 18/09/2026).
    -- Agora diz, desliga o dev mode e segue pelo ar. A versao do prelude sai
    -- junto de proposito: ele captura o dev mode na INSTALACAO e nao muda de
    -- ideia no meio da sessao, entao sem isto a lib continuaria apontando pro
    -- 127.0.0.1 mesmo com o script vindo do site.
    if not httpOk or type(source) ~= "string" or #source < 10 then
        notify("Dev mode was on", "127.0.0.1:" .. DEV_PORT
            .. " sent nothing, so this run uses the live script.", 12)
        _G.DevMode = nil
        env.DzHub_DevMode = nil
        env.DzHub_PreludeVersion = nil
        DEV_MODE = false
    end
end

if not DEV_MODE then
    httpOk, source = fetchScript()
    local firstLine = (type(source) == "string" and source:match("^[^\r\n]*") or "")
    if httpOk and firstLine:find("[KEY]", 1, true) then
        if not runKeyGate(firstLine, DZ_HOST .. "/pricing") then return end
        httpOk, source = fetchScript()
    end

    -- Resposta vazia em producao quase sempre e o site reiniciando (um deploy
    -- leva segundos). Uma segunda tentativa custa dois segundos e resolve
    -- sozinha, em vez de deixar a pessoa achando que o hub morreu.
    if not httpOk or type(source) ~= "string" or #source < 10 then
        task.wait(2)
        httpOk, source = fetchScript()
    end
end

if not httpOk then
    notify("HttpGet failed", tostring(source), 10)
    return
end
if type(source) ~= "string" or #source < 10 then
    notify("Empty response", "The site sent nothing back. Try again in a minute, or check status.dzhub.xyz", 12)
    return
end
if source:sub(1, 3) == "\239\187\191" then
    source = source:sub(4)
end

-- Resposta do site que nao e script ("-- DZ HUB: no script named ...") e um
-- comentario Lua valido: o loadstring compilava, rodava nada, e o aviso de
-- "Script unavailable" logo abaixo nunca aparecia. Confere a primeira linha
-- antes.
local head = source:match("^[^\r\n]*") or ""
if head:find("^%-%- DZ HUB:") then
    notify("Script unavailable", head, 12)
    return
end

local fn, parseErr = loadstring(source, "@" .. scriptName)
if not fn then
    local firstLine = tostring(source):match("^[^\r\n]*") or ""
    if firstLine:find("DZ HUB", 1, true) then
        notify("Script unavailable", firstLine, 12)
    else
        notify("Parse error", tostring(parseErr), 12)
    end
    return
end

local runOk, runErr = pcall(fn)
if not runOk then
    notify("Runtime error", tostring(runErr), 12)
end
